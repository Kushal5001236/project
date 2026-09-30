-- reports/01_employee_ticket_inner_join.sql
-- Part 2 — Task 4(a): INNER JOIN between employees and tickets
--
-- Show employees who have raised at least one ticket.
-- Uses an INNER JOIN on raised_by, grouped by employee, counting tickets.
-- Returns exactly 11 rows (employees 1–11).
-- Priya Das (emp_id = 12) raised no tickets, so she is omitted by the INNER JOIN.

SELECT
    e.emp_id,
    e.name,
    e.department,
    e.role,
    COUNT(t.ticket_id) AS ticket_count
FROM employees e
INNER JOIN tickets t ON e.emp_id = t.raised_by
GROUP BY e.emp_id, e.name, e.department, e.role
ORDER BY e.emp_id ASC;
