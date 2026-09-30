-- reports/06_ticket_type_status_having.sql
-- Part 2 — Task 4(f): Ticket type and status aggregation with HAVING
--
-- Groups tickets by ticket_type and status, filtering for combinations
-- that have at least 3 tickets using HAVING COUNT(*) >= 3.
-- Expected output: exactly 5 rows
--   - incident, Open: 3
--   - service_request, Closed: 4
--   - service_request, InProgress: 3
--   - service_request, Open: 7
--   - service_request, Resolved: 4

SELECT
    ticket_type,
    status,
    COUNT(*) AS ticket_count
FROM tickets
GROUP BY ticket_type, status
HAVING COUNT(*) >= 3
ORDER BY ticket_type ASC, status ASC;
