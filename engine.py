"""
engine.py — SentinelDesk Helpdesk Engine (Part 1)

Defines the domain model (abstract base class + concrete ticket types,
Employee, Asset) and the HelpdeskEngine that loads data from SQLite.
"""

from __future__ import annotations

import sqlite3
from abc import ABC, abstractmethod
from datetime import date


# ---------------------------------------------------------------------------
# Abstract base class: Ticket
# ---------------------------------------------------------------------------

class Ticket(ABC):
    """
    Abstract base class for all helpdesk tickets.

    NOTE: Directly instantiating Ticket(...) raises TypeError because
    `resolution_checklist` is declared abstract and has no concrete body.
    Python's ABC machinery enforces this at instantiation time, before any
    user code inside __init__ even runs.

        >>> Ticket(...)   # raises TypeError: Can't instantiate abstract class
    """

    def __init__(
        self,
        ticket_id: int,
        asset_id: int | None,
        raised_by: int,
        priority: str,
        status: str,
        created_at: str,
        resolved_at: str | None,
    ) -> None:
        self.ticket_id = ticket_id
        self.asset_id = asset_id
        self.raised_by = raised_by
        self.priority = priority
        self.status = status
        self.created_at = created_at       # YYYY-MM-DD string
        self.resolved_at = resolved_at     # YYYY-MM-DD string or None

    @abstractmethod
    def resolution_checklist(self) -> list[str]:
        """Return a list of steps required to resolve this ticket."""

    def age_in_days(self, reference_date: str) -> int:
        """
        Return the number of days between created_at and reference_date.

        Both dates must be YYYY-MM-DD strings.
        A positive result means reference_date is after created_at.
        """
        created = date.fromisoformat(self.created_at)
        reference = date.fromisoformat(reference_date)
        return (reference - created).days


# ---------------------------------------------------------------------------
# Concrete ticket types
# ---------------------------------------------------------------------------

class IncidentTicket(Ticket):
    """An unplanned disruption or degradation of service."""

    def resolution_checklist(self) -> list[str]:
        return [
            "Acknowledge the incident and assign a responder.",
            "Identify the root cause (logs, monitoring dashboards).",
            "Isolate affected systems to prevent further impact.",
            "Apply fix or roll back the offending change.",
            "Verify service is restored and KPIs are back to normal.",
            "Write and publish a post-incident review (PIR).",
        ]


class ServiceRequestTicket(Ticket):
    """A formal request for something new — software, access, hardware, etc."""

    def resolution_checklist(self) -> list[str]:
        return [
            "Confirm the request details with the requester.",
            "Obtain necessary manager / security approval.",
            "Procure or provision the requested resource.",
            "Configure and test the resource with the requester.",
            "Update the CMDB / asset register if hardware is involved.",
            "Notify the requester and close the ticket.",
        ]


class MaintenanceTicket(Ticket):
    """Scheduled or preventive maintenance on an asset."""

    def resolution_checklist(self) -> list[str]:
        return [
            "Notify stakeholders of the maintenance window.",
            "Take a pre-maintenance snapshot / backup.",
            "Carry out the maintenance tasks per the runbook.",
            "Run smoke tests to confirm system health post-maintenance.",
            "Update asset maintenance log with date and technician.",
            "Close the change request and notify stakeholders.",
        ]


# ---------------------------------------------------------------------------
# Plain data classes: Employee and Asset
# ---------------------------------------------------------------------------

class Employee:
    """Represents a helpdesk employee / system user."""

    def __init__(
        self,
        emp_id: int,
        name: str,
        department: str,
        role: str,
    ) -> None:
        self.emp_id = emp_id
        self.name = name
        self.department = department
        self.role = role

    def __repr__(self) -> str:
        return (
            f"Employee(emp_id={self.emp_id}, name={self.name!r}, "
            f"role={self.role!r})"
        )


class Asset:
    """Represents a physical or virtual IT asset."""

    def __init__(
        self,
        asset_id: int,
        asset_tag: str,
        category: str,
        purchase_date: str,
        assigned_to: int | None,
    ) -> None:
        self.asset_id = asset_id
        self.asset_tag = asset_tag
        self.category = category
        self.purchase_date = purchase_date
        self.assigned_to = assigned_to     # emp_id, may be None

    def __repr__(self) -> str:
        return (
            f"Asset(id={self.asset_id}, tag={self.asset_tag!r}, "
            f"category={self.category!r})"
        )


# ---------------------------------------------------------------------------
# HelpdeskEngine
# ---------------------------------------------------------------------------

# Mapping from the ticket_type string stored in the DB to the correct class.
_TICKET_CLASS_MAP: dict[str, type[Ticket]] = {
    "incident":        IncidentTicket,
    "service_request": ServiceRequestTicket,
    "maintenance":     MaintenanceTicket,
}


class HelpdeskEngine:
    """
    Central engine that loads and organises helpdesk data from SQLite.

    Attributes
    ----------
    employees_by_id      : dict[int, Employee]
    assets_by_id         : dict[int, Asset]
    tickets_by_status    : dict[str, list[Ticket]]
    ticket_type_seen     : set[str]
    count_by_type_status : dict[tuple[str, str], int]
                           key → (ticket_type, status)
    """

    def __init__(self) -> None:
        self.employees_by_id: dict[int, Employee] = {}
        self.assets_by_id: dict[int, Asset] = {}
        self.tickets_by_status: dict[str, list[Ticket]] = {}
        self.ticket_type_seen: set[str] = set()
        self.count_by_type_status: dict[tuple[str, str], int] = {}

    def load_from_db(self, db_path: str) -> None:
        """
        Populate the engine by reading from the SQLite database at db_path.

        Tables expected (created in Part 2):
            employees, assets, tickets
        """
        conn = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row   # lets us access columns by name
        try:
            self._load_employees(conn)
            self._load_assets(conn)
            self._load_tickets(conn)
        finally:
            conn.close()

    # --- private helpers ---------------------------------------------------

    def _load_employees(self, conn: sqlite3.Connection) -> None:
        cursor = conn.execute(
            "SELECT emp_id, name, department, role FROM employees"
        )
        for row in cursor:
            emp = Employee(
                emp_id=row["emp_id"],
                name=row["name"],
                department=row["department"],
                role=row["role"],
            )
            self.employees_by_id[emp.emp_id] = emp

    def _load_assets(self, conn: sqlite3.Connection) -> None:
        cursor = conn.execute(
            "SELECT asset_id, asset_tag, category, purchase_date, assigned_to FROM assets"
        )
        for row in cursor:
            asset = Asset(
                asset_id=row["asset_id"],
                asset_tag=row["asset_tag"],
                category=row["category"],
                purchase_date=row["purchase_date"],
                assigned_to=row["assigned_to"],   # may be None
            )
            self.assets_by_id[asset.asset_id] = asset

    def _load_tickets(self, conn: sqlite3.Connection) -> None:
        cursor = conn.execute(
            """
            SELECT ticket_id, ticket_type, asset_id, raised_by,
                   priority, status, created_at, resolved_at
            FROM tickets
            """
        )
        for row in cursor:
            ticket_type = row["ticket_type"]

            # Look up the concrete class — never instantiate Ticket directly.
            ticket_class = _TICKET_CLASS_MAP.get(ticket_type)
            if ticket_class is None:
                raise ValueError(f"Unknown ticket_type in DB: {ticket_type!r}")

            ticket = ticket_class(
                ticket_id=row["ticket_id"],
                asset_id=row["asset_id"],       # may be None
                raised_by=row["raised_by"],
                priority=row["priority"],
                status=row["status"],
                created_at=row["created_at"],
                resolved_at=row["resolved_at"],  # may be None
            )

            # tickets_by_status
            status = ticket.status
            self.tickets_by_status.setdefault(status, []).append(ticket)

            # ticket_type_seen
            self.ticket_type_seen.add(ticket_type)

            # count_by_type_status
            key = (ticket_type, status)
            self.count_by_type_status[key] = (
                self.count_by_type_status.get(key, 0) + 1
            )


# ---------------------------------------------------------------------------
# notify() helper
# ---------------------------------------------------------------------------

def notify(ticket: Ticket) -> list[str]:
    """
    Return the resolution checklist for a ticket.

    WHY THE ABC MATTERS HERE
    ------------------------
    Because Ticket declares resolution_checklist() as @abstractmethod, Python
    guarantees at class-definition time that *every* concrete subclass must
    provide a real implementation.  That means any object that successfully
    passed through HelpdeskEngine.load_from_db() is guaranteed to have the
    method — notify() can call it unconditionally with no risk.

    With ordinary duck-typing (no ABC) a class author could forget to define
    resolution_checklist().  The omission would go unnoticed until notify()
    was actually called on that object, producing an AttributeError at
    runtime, possibly deep inside production code.  The ABC turns that
    potential runtime surprise into an immediate, obvious TypeError at the
    moment someone tries to instantiate the incomplete class.
    """
    return ticket.resolution_checklist()
