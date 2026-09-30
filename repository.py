"""
repository.py — SentinelDesk transactional write layer (Part 2, Task 2)

Implements the Repository class, whose write methods wrap every multi-table
operation in a single explicit transaction to guarantee Atomicity: the
database is either updated completely or left exactly as it was.
"""

from __future__ import annotations

import sqlite3
from datetime import date


class Repository:
    """
    Data-access layer for SentinelDesk.

    All write methods that touch more than one table run inside an explicit
    BEGIN … COMMIT transaction.  Any exception triggers a ROLLBACK so the
    database is never left in a partially-updated state.

    Usage
    -----
    The caller must open the connection with isolation_level=None (autocommit
    mode) so that Python's sqlite3 module does not issue its own implicit BEGIN
    and so that our explicit BEGIN / COMMIT / ROLLBACK statements have full
    control over the transaction boundary:

        conn = sqlite3.connect('sentineldesk.db', isolation_level=None)
        repo = Repository()
        repo.update_ticket_status(conn, ticket_id=2, new_status='InProgress')
        conn.close()
    """

    def update_ticket_status(
        self,
        conn: sqlite3.Connection,
        ticket_id: int,
        new_status: str,
    ) -> None:
        """
        Change a ticket's status and record the transition in ticket_status_history.

        Transaction sequence
        --------------------
        BEGIN
          1. SELECT current status  (to capture old_status for the history row)
          2. UPDATE tickets.status  (CHECK constraint fires here — rejects any
                                     value not in Open/InProgress/Resolved/Closed)
          3. INSERT ticket_status_history row
        COMMIT   ← only reached when all three steps succeed
        ROLLBACK ← issued automatically on any exception, leaving zero trace

        Parameters
        ----------
        conn       : Open sqlite3.Connection created with isolation_level=None.
        ticket_id  : Primary key of the ticket to update.
        new_status : Desired new status.  Must satisfy the schema CHECK constraint:
                     ('Open', 'InProgress', 'Resolved', 'Closed').
                     Any other value causes an IntegrityError → automatic ROLLBACK.

        Raises
        ------
        ValueError       if ticket_id does not exist in the database.
        sqlite3.IntegrityError
                         if new_status violates the CHECK constraint — the caller
                         receives this exception after the ROLLBACK completes.
        """
        changed_at = date.today().isoformat()   # YYYY-MM-DD timestamp for history row

        conn.execute("BEGIN")
        try:
            # Step 1 — read the old status so the history row is accurate.
            row = conn.execute(
                "SELECT status FROM tickets WHERE ticket_id = ?",
                (ticket_id,),
            ).fetchone()
            if row is None:
                raise ValueError(f"ticket_id {ticket_id} does not exist.")
            old_status = row[0]

            # Step 2 — update tickets.status.
            # The schema CHECK constraint rejects any value outside the allowed
            # set; sqlite3 raises IntegrityError before this statement commits,
            # which is caught below and triggers the ROLLBACK.
            conn.execute(
                "UPDATE tickets SET status = ? WHERE ticket_id = ?",
                (new_status, ticket_id),
            )

            # Step 3 — insert the audit row into ticket_status_history.
            conn.execute(
                """
                INSERT INTO ticket_status_history
                    (ticket_id, old_status, new_status, changed_at)
                VALUES (?, ?, ?, ?)
                """,
                (ticket_id, old_status, new_status, changed_at),
            )

            conn.execute("COMMIT")

        except Exception:
            # Rollback unconditionally — the caller receives the original
            # exception so it can log/display it.
            conn.execute("ROLLBACK")
            raise
