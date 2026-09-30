-- seed_data.sql — SentinelDesk seed data (verbatim from capstone specification)
-- Produces: 12 employees | 18 assets | 30 tickets | 50 ticket_status_history rows

-- -----------------------------------------------------------------------
-- employees (12 rows)
-- -----------------------------------------------------------------------
INSERT INTO employees (emp_id,name,department,role) VALUES (1,'Aarav Sharma','Engineering','Backend Engineer');
INSERT INTO employees (emp_id,name,department,role) VALUES (2,'Isha Verma','IT Support','Support Technician');
INSERT INTO employees (emp_id,name,department,role) VALUES (3,'Rohan Gupta','Design','Product Designer');
INSERT INTO employees (emp_id,name,department,role) VALUES (4,'Diya Nair','Sales','Account Executive');
INSERT INTO employees (emp_id,name,department,role) VALUES (5,'Kabir Singh','HR','HR Executive');
INSERT INTO employees (emp_id,name,department,role) VALUES (6,'Meera Iyer','Engineering','Backend Engineer');
INSERT INTO employees (emp_id,name,department,role) VALUES (7,'Vivaan Rao','IT Support','Support Technician');
INSERT INTO employees (emp_id,name,department,role) VALUES (8,'Ananya Joshi','Design','UX Researcher');
INSERT INTO employees (emp_id,name,department,role) VALUES (9,'Aditya Menon','Sales','Account Executive');
INSERT INTO employees (emp_id,name,department,role) VALUES (10,'Sara Khan','HR','HR Executive');
INSERT INTO employees (emp_id,name,department,role) VALUES (11,'Arjun Reddy','Engineering','QA Engineer');
INSERT INTO employees (emp_id,name,department,role) VALUES (12,'Priya Das','IT Support','Support Technician');

-- -----------------------------------------------------------------------
-- assets (18 rows)
-- -----------------------------------------------------------------------
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (1,'AST-001','Laptop','2024-02-04',9);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (2,'AST-002','Monitor','2024-03-07',2);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (3,'AST-003','Server','2024-04-10',6);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (4,'AST-004','Networking','2024-05-13',12);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (5,'AST-005','Printer','2024-06-16',7);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (6,'AST-006','Laptop','2024-07-19',7);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (7,'AST-007','Monitor','2024-08-22',4);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (8,'AST-008','Server','2024-09-25',9);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (9,'AST-009','Networking','2024-10-28',1);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (10,'AST-010','Printer','2024-11-03',4);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (11,'AST-011','Laptop','2024-12-06',8);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (12,'AST-012','Monitor','2024-01-09',2);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (13,'AST-013','Server','2024-02-12',2);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (14,'AST-014','Networking','2024-03-15',8);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (15,'AST-015','Printer','2024-04-18',1);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (16,'AST-016','Laptop','2024-05-21',12);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (17,'AST-017','Monitor','2024-06-24',NULL);
INSERT INTO assets (asset_id,asset_tag,category,purchase_date,assigned_to) VALUES (18,'AST-018','Server','2024-07-27',NULL);

-- -----------------------------------------------------------------------
-- tickets (30 rows — verbatim from specification)
-- -----------------------------------------------------------------------
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (1,10,1,'service_request','Critical','Closed','2026-07-02',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (2,NULL,11,'service_request','Low','Open','2026-08-03',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (3,NULL,3,'service_request','Medium','Open','2026-06-04',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (4,3,1,'incident','Medium','Open','2026-07-05',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (5,NULL,7,'service_request','High','Resolved','2026-08-06','2026-08-08');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (6,2,8,'incident','Low','Closed','2026-06-07','2026-06-09');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (7,11,4,'incident','Medium','InProgress','2026-07-08',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (8,2,11,'service_request','High','Closed','2026-08-09','2026-08-11');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (9,2,11,'maintenance','Medium','Resolved','2026-06-10','2026-06-12');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (10,4,1,'incident','High','Open','2026-07-11',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (11,NULL,11,'service_request','High','Resolved','2026-08-12','2026-08-14');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (12,12,1,'service_request','Low','Open','2026-06-13',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (13,6,11,'maintenance','Low','Resolved','2026-07-14','2026-07-16');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (14,11,9,'incident','Medium','Closed','2026-08-15','2026-08-17');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (15,8,9,'incident','Medium','Open','2026-06-16',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (16,6,7,'service_request','Medium','Open','2026-07-17',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (17,1,1,'maintenance','Low','Closed','2026-08-18','2026-08-20');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (18,17,2,'service_request','Medium','Open','2026-06-19',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (19,NULL,11,'service_request','High','Resolved','2026-07-20','2026-07-22');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (20,NULL,6,'service_request','High','Open','2026-08-21',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (21,2,7,'maintenance','High','InProgress','2026-06-22',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (22,NULL,1,'service_request','Low','InProgress','2026-07-23',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (23,6,7,'incident','High','Resolved','2026-08-24','2026-08-26');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (24,NULL,5,'service_request','Medium','InProgress','2026-06-25',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (25,5,9,'maintenance','Low','InProgress','2026-07-26',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (26,NULL,11,'service_request','Medium','InProgress','2026-08-27',NULL);
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (27,NULL,6,'service_request','High','Resolved','2026-06-01','2026-06-03');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (28,5,1,'service_request','Medium','Closed','2026-07-02','2026-07-04');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (29,1,10,'service_request','Low','Closed','2026-08-03','2026-08-05');
INSERT INTO tickets (ticket_id,asset_id,raised_by,ticket_type,priority,status,created_at,resolved_at) VALUES (30,8,10,'service_request','Medium','Open','2026-06-04',NULL);

-- -----------------------------------------------------------------------
-- ticket_status_history (50 rows)
--
-- Rule A [30 rows]: one creation row per ticket
--   old_status = NULL, new_status = 'Open', changed_at = created_at
--
-- Rule B [20 rows]: one transition row for each ticket whose seeded status
--   is not 'Open'
--   old_status = 'Open', new_status = seeded status,
--   changed_at = resolved_at if resolved_at IS NOT NULL, else created_at
--
-- Non-Open tickets and their Rule-B changed_at:
--   Closed  (resolved_at=NULL):  ticket 1  → changed_at = '2026-07-02' (created_at)
--   Resolved (resolved_at set):  tickets 5,9,11,13,19,23,27
--   Closed  (resolved_at set):   tickets 6,8,14,17,28,29
--   InProgress (resolved_at=NULL): tickets 7,21,22,24,25,26 → changed_at = created_at
-- -----------------------------------------------------------------------

-- Rule A: creation rows (all 30 tickets)
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (1, NULL,'Open','2026-07-02');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (2, NULL,'Open','2026-08-03');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (3, NULL,'Open','2026-06-04');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (4, NULL,'Open','2026-07-05');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (5, NULL,'Open','2026-08-06');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (6, NULL,'Open','2026-06-07');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (7, NULL,'Open','2026-07-08');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (8, NULL,'Open','2026-08-09');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (9, NULL,'Open','2026-06-10');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (10,NULL,'Open','2026-07-11');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (11,NULL,'Open','2026-08-12');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (12,NULL,'Open','2026-06-13');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (13,NULL,'Open','2026-07-14');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (14,NULL,'Open','2026-08-15');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (15,NULL,'Open','2026-06-16');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (16,NULL,'Open','2026-07-17');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (17,NULL,'Open','2026-08-18');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (18,NULL,'Open','2026-06-19');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (19,NULL,'Open','2026-07-20');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (20,NULL,'Open','2026-08-21');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (21,NULL,'Open','2026-06-22');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (22,NULL,'Open','2026-07-23');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (23,NULL,'Open','2026-08-24');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (24,NULL,'Open','2026-06-25');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (25,NULL,'Open','2026-07-26');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (26,NULL,'Open','2026-08-27');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (27,NULL,'Open','2026-06-01');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (28,NULL,'Open','2026-07-02');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (29,NULL,'Open','2026-08-03');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (30,NULL,'Open','2026-06-04');

-- Rule B: transition rows for the 20 non-Open tickets
-- Closed, resolved_at = NULL  → changed_at = created_at
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (1, 'Open','Closed','2026-07-02');
-- Resolved tickets (resolved_at present → changed_at = resolved_at)
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (5, 'Open','Resolved','2026-08-08');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (9, 'Open','Resolved','2026-06-12');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (11,'Open','Resolved','2026-08-14');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (13,'Open','Resolved','2026-07-16');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (19,'Open','Resolved','2026-07-22');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (23,'Open','Resolved','2026-08-26');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (27,'Open','Resolved','2026-06-03');
-- Closed tickets (resolved_at present → changed_at = resolved_at)
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (6, 'Open','Closed','2026-06-09');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (8, 'Open','Closed','2026-08-11');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (14,'Open','Closed','2026-08-17');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (17,'Open','Closed','2026-08-20');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (28,'Open','Closed','2026-07-04');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (29,'Open','Closed','2026-08-05');
-- InProgress tickets (resolved_at = NULL → changed_at = created_at)
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (7, 'Open','InProgress','2026-07-08');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (21,'Open','InProgress','2026-06-22');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (22,'Open','InProgress','2026-07-23');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (24,'Open','InProgress','2026-06-25');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (25,'Open','InProgress','2026-07-26');
INSERT INTO ticket_status_history (ticket_id,old_status,new_status,changed_at) VALUES (26,'Open','InProgress','2026-08-27');
