-- reports/04_employees_above_average_tickets.sql
-- Part 2 — Task 4(d): Employees with ticket counts above average
--
-- Uses a scalar subquery to calculate the average ticket count per ticket raiser
-- (30 tickets / 11 raisers ≈ 2.7273).
-- Returns employees whose ticket count exceeds this average.
-- Expected output: exactly 4 employees (Aarav Sharma: 7, Arjun Reddy: 7,
-- Vivaan Rao: 4, Aditya Menon: 3).

SELECT
    e.emp_id,
    e.name,
    COUNT(t.ticket_id) AS ticket_count
FROM employees e
INNER JOIN tickets t ON e.emp_id = t.raised_by
GROUP BY e.emp_id, e.name
HAVING COUNT(t.ticket_id) > (
    SELECT AVG(raiser_count)
    FROM (
        SELECT COUNT(*) AS raiser_count
        FROM tickets
        GROUP BY raised_by
    )
)
ORDER BY ticket_count DESC, e.emp_id ASC;
