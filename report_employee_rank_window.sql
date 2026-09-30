-- reports/07_rank_employees_by_ticket_count.sql
-- Part 2 — Task 4(g): Employee ranking by ticket count using window function
--
-- First aggregates ticket counts per ticket-raising employee, then applies
-- RANK() OVER (ORDER BY ticket_count DESC).
-- Demonstrates rank skipping behavior on ties:
-- Aarav Sharma (7) and Arjun Reddy (7) tie for Rank 1, so Rank 2 is consumed
-- and Vivaan Rao (4) receives Rank 3.

WITH employee_counts AS (
    SELECT
        e.emp_id,
        e.name,
        COUNT(t.ticket_id) AS ticket_count
    FROM employees e
    INNER JOIN tickets t ON e.emp_id = t.raised_by
    GROUP BY e.emp_id, e.name
)
SELECT
    emp_id,
    name,
    ticket_count,
    RANK() OVER (ORDER BY ticket_count DESC) AS rank
FROM employee_counts
ORDER BY rank ASC, emp_id ASC;
