-- reports/02_employee_ticket_left_join.sql
-- Part 2 — Task 4(b): LEFT JOIN between employees and tickets
--
-- Why COUNT(*) and COUNT(t.ticket_id) differ for Priya Das (emp_id = 12):
-- A LEFT JOIN generates a single NULL-padded row for an employee with no matching tickets.
-- COUNT(*) counts total rows in each group regardless of NULLs (evaluating to 1 for Priya),
-- while COUNT(t.ticket_id) ignores NULL values and counts only matched tickets (evaluating to 0).

SELECT
    e.emp_id,
    e.name,
    COUNT(*) AS count_star,
    COUNT(t.ticket_id) AS count_ticket_id
FROM employees e
LEFT JOIN tickets t ON e.emp_id = t.raised_by
GROUP BY e.emp_id, e.name
ORDER BY e.emp_id ASC;
