-- reports/05_asset_set_operations.sql
-- Part 2 — Task 4(e): SQL Set Operations (UNION and EXCEPT)
--
-- Query 1 — UNION:
-- Returns distinct asset IDs that have had at least one incident ticket OR
-- at least one maintenance ticket.
-- Expected output: exactly 8 distinct asset IDs: {1, 2, 3, 4, 5, 6, 8, 11}.

SELECT asset_id
FROM tickets
WHERE ticket_type = 'incident' AND asset_id IS NOT NULL
UNION
SELECT asset_id
FROM tickets
WHERE ticket_type = 'maintenance' AND asset_id IS NOT NULL
ORDER BY asset_id ASC;

-- Query 2 — EXCEPT:
-- Returns asset IDs that have had an incident ticket but NO maintenance ticket
-- (incident asset set minus maintenance asset set).
-- Expected output: exactly 4 distinct asset IDs: {3, 4, 8, 11}.

SELECT asset_id
FROM tickets
WHERE ticket_type = 'incident' AND asset_id IS NOT NULL
EXCEPT
SELECT asset_id
FROM tickets
WHERE ticket_type = 'maintenance' AND asset_id IS NOT NULL
ORDER BY asset_id ASC;
