"""
run_concurrency_experiment.py -- SentinelDesk Part 2, Task 3

Demonstrates the lost-update anomaly using two concurrent threading.Thread
workers against a fresh, isolated throwaway SQLite database, then shows how
BEGIN IMMEDIATE (lock-based concurrency control) eliminates the anomaly.

This script never touches the seeded capstone database from Task 1.
"""

import os
import sqlite3
import tempfile
import threading
import time


# ---------------------------------------------------------------------------
# Throwaway experiment database helpers
# ---------------------------------------------------------------------------

def _create_experiment_db(db_path: str) -> None:
    """
    Build a minimal one-row table in a fresh file-based SQLite database.
    Uses only the reopen_count column from the capstone schema -- no seed
    data, no employees, no assets.
    """
    conn = sqlite3.connect(db_path)
    conn.execute(
        "CREATE TABLE tickets "
        "(ticket_id INTEGER PRIMARY KEY, reopen_count INTEGER NOT NULL DEFAULT 0)"
    )
    conn.execute(
        "INSERT INTO tickets (ticket_id, reopen_count) VALUES (1, 0)"
    )
    conn.commit()
    conn.close()


def _reset(db_path: str) -> None:
    """Reset reopen_count = 0 before every trial."""
    conn = sqlite3.connect(db_path)
    conn.execute("UPDATE tickets SET reopen_count = 0 WHERE ticket_id = 1")
    conn.commit()
    conn.close()


def _read_count(db_path: str) -> int:
    """Read the current reopen_count after a trial completes."""
    conn = sqlite3.connect(db_path)
    val = conn.execute(
        "SELECT reopen_count FROM tickets WHERE ticket_id = 1"
    ).fetchone()[0]
    conn.close()
    return val


# ---------------------------------------------------------------------------
# Naive implementation -- no explicit transaction (lost-update race)
# ---------------------------------------------------------------------------

def reopen_ticket_naive(
    db_path: str,
    ticket_id: int,
    barrier: threading.Barrier,
) -> None:
    """
    Read-modify-write WITHOUT an explicit transaction.

    Each SQL statement is its own autocommit micro-transaction.
    After the SELECT the shared lock is immediately released, so nothing
    prevents the other thread from reading the same stale value before
    either thread reaches its UPDATE.

    Race window (with barrier + sleep guaranteeing it):
        Thread 1: SELECT -> count=0   (lock released)
        Thread 2: SELECT -> count=0   (reads same stale 0)
        Thread 1: sleep 0.15 s
        Thread 2: sleep 0.15 s
        Thread 1: UPDATE count=1      (writes 1)
        Thread 2: UPDATE count=1      (also writes 1 -- one increment LOST)
        Final reopen_count: 1
    """
    conn = sqlite3.connect(db_path, isolation_level=None, timeout=10)
    try:
        barrier.wait()          # release both threads at exactly the same moment

        # READ: both threads read before either writes
        count = conn.execute(
            "SELECT reopen_count FROM tickets WHERE ticket_id = ?",
            (ticket_id,),
        ).fetchone()[0]

        # SLEEP: guarantees both reads finish before either write begins,
        # making the lost-update race window large and reliable
        time.sleep(0.15)

        # WRITE: both threads write count+1 = 1; one increment is silently lost
        conn.execute(
            "UPDATE tickets SET reopen_count = ? WHERE ticket_id = ?",
            (count + 1, ticket_id),
        )
    finally:
        conn.close()


# ---------------------------------------------------------------------------
# Safe implementation -- BEGIN IMMEDIATE (lock-based concurrency control)
# ---------------------------------------------------------------------------

def reopen_ticket_safe(
    db_path: str,
    ticket_id: int,
    barrier: threading.Barrier,
) -> None:
    """
    Read-modify-write INSIDE a BEGIN IMMEDIATE transaction.

    BEGIN IMMEDIATE acquires a RESERVED write lock at transaction start,
    before any data is read.  SQLite allows only one RESERVED lock at a
    time, so the second thread's BEGIN IMMEDIATE blocks (retrying internally
    up to timeout seconds) until the first thread commits.

    Safe sequence:
        Thread 1: BEGIN IMMEDIATE -> RESERVED lock acquired
        Thread 2: BEGIN IMMEDIATE -> BLOCKED (waits for Thread 1 to commit)
        Thread 1: SELECT -> count=0
        Thread 1: sleep 0.15 s
        Thread 1: UPDATE count=1
        Thread 1: COMMIT -> lock released
        Thread 2: BEGIN IMMEDIATE -> lock acquired
        Thread 2: SELECT -> count=1  (reads the updated value!)
        Thread 2: sleep 0.15 s
        Thread 2: UPDATE count=2
        Thread 2: COMMIT
        Final reopen_count: 2
    """
    # timeout=30 s: more than enough for Thread 1 to complete its ~0.15 s work
    conn = sqlite3.connect(db_path, isolation_level=None, timeout=30)
    try:
        barrier.wait()

        conn.execute("BEGIN IMMEDIATE")
        try:
            count = conn.execute(
                "SELECT reopen_count FROM tickets WHERE ticket_id = ?",
                (ticket_id,),
            ).fetchone()[0]

            time.sleep(0.15)

            conn.execute(
                "UPDATE tickets SET reopen_count = ? WHERE ticket_id = ?",
                (count + 1, ticket_id),
            )

            conn.execute("COMMIT")
        except Exception:
            conn.execute("ROLLBACK")
            raise
    finally:
        conn.close()


# ---------------------------------------------------------------------------
# Trial runner
# ---------------------------------------------------------------------------

def run_trial(fn, db_path: str, ticket_id: int = 1) -> int:
    """
    Run one trial of fn:
      1. Reset reopen_count to 0.
      2. Launch two threads, barrier-synchronized so they start together.
      3. Join both threads.
      4. Return the final reopen_count from the database.
    """
    _reset(db_path)
    barrier = threading.Barrier(2)

    t1 = threading.Thread(target=fn, args=(db_path, ticket_id, barrier))
    t2 = threading.Thread(target=fn, args=(db_path, ticket_id, barrier))

    t1.start()
    t2.start()
    t1.join()
    t2.join()

    return _read_count(db_path)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    NUM_TRIALS = 5
    TICKET_ID  = 1

    # Isolated throwaway database -- never touches the seeded capstone DB.
    tmp_fd, db_path = tempfile.mkstemp(suffix=".db", prefix="sentineldesk_exp_")
    os.close(tmp_fd)

    try:
        _create_experiment_db(db_path)

        print("=" * 62)
        print("SentinelDesk -- Concurrency Experiment (Part 2, Task 3)")
        print("=" * 62)
        print(f"Experiment DB : {db_path}")
        print(f"Threads/trial : 2   |   Trials/version: {NUM_TRIALS}")
        print(f"Correct result: 2   (two increments both applied)")

        # ── Naive trials ─────────────────────────────────────────────
        print()
        print("NAIVE VERSION  (no explicit transaction -- lost-update race)")
        print("-" * 50)
        naive_results = []
        for i in range(1, NUM_TRIALS + 1):
            result = run_trial(reopen_ticket_naive, db_path, TICKET_ID)
            naive_results.append(result)
            tag = "LOST UPDATE" if result < 2 else "correct (no race this trial)"
            print(f"  Trial {i}: final reopen_count = {result}  [{tag}]")

        # ── Safe trials ──────────────────────────────────────────────
        print()
        print("SAFE VERSION   (BEGIN IMMEDIATE -- serialised by write lock)")
        print("-" * 50)
        safe_results = []
        for i in range(1, NUM_TRIALS + 1):
            result = run_trial(reopen_ticket_safe, db_path, TICKET_ID)
            safe_results.append(result)
            tag = "correct" if result == 2 else "UNEXPECTED"
            print(f"  Trial {i}: final reopen_count = {result}  [{tag}]")

        # ── Acceptance-criterion check ────────────────────────────────
        print()
        print("=" * 62)
        print("RESULTS SUMMARY")
        print("=" * 62)
        naive_lost = naive_results.count(1)
        safe_ok    = safe_results.count(2)

        print(f"Naive  : {naive_results}")
        ac_naive = "PASS" if naive_lost >= 4 else "FAIL"
        print(f"  Lost-update (=1) in {naive_lost}/5 trials  --> {ac_naive}"
              f"  (spec requires >= 4)")

        print()
        print(f"Safe   : {safe_results}")
        ac_safe = "PASS" if safe_ok == 5 else "FAIL"
        print(f"  Correct     (=2) in {safe_ok}/5 trials  --> {ac_safe}"
              f"  (spec requires   5)")

        # ── Explanation ───────────────────────────────────────────────
        print()
        print("=" * 62)
        print("EXPLANATION")
        print("=" * 62)
        print("""
Why the naive version loses an update
--------------------------------------
Without an explicit transaction, each SQL statement is its own
autocommit operation.  The shared lock from the SELECT is released
the moment the row is returned -- long before the UPDATE runs.
The Barrier + 0.15 s sleep guarantee:

  Thread 1: SELECT reopen_count -> 0   (lock released immediately)
  Thread 2: SELECT reopen_count -> 0   (reads same stale 0)
  Thread 1 & 2 sleep 0.15 s
  Thread 1: UPDATE reopen_count = 1    (writes 1, autocommit)
  Thread 2: UPDATE reopen_count = 1    (also writes 1 -- LOST!)
  Final value: 1

Because no lock is held between the read and the write, both threads
observe the same pre-update value and one increment overwrites the
other silently.

Why BEGIN IMMEDIATE prevents the lost update
---------------------------------------------
BEGIN IMMEDIATE acquires a RESERVED write lock at the START of the
transaction, before the first SELECT.  SQLite permits only one
RESERVED lock at a time:

  Thread 1: BEGIN IMMEDIATE -> RESERVED lock acquired
  Thread 2: BEGIN IMMEDIATE -> BLOCKED (SQLite retries internally)
  Thread 1: SELECT -> 0
  Thread 1: sleep 0.15 s, UPDATE count=1, COMMIT -> lock released
  Thread 2: BEGIN IMMEDIATE -> now succeeds, lock acquired
  Thread 2: SELECT -> 1  (reads Thread 1's committed value)
  Thread 2: sleep 0.15 s, UPDATE count=2, COMMIT
  Final value: 2

The lock serialises the two read-modify-write operations.  The second
thread cannot read until after the first thread has written and
committed, so both increments are preserved.  This is lock-based
concurrency control: a write lock held for the lifetime of the
transaction prevents any concurrent writer from observing stale data.
""")

    finally:
        if os.path.exists(db_path):
            os.remove(db_path)


if __name__ == "__main__":
    main()
