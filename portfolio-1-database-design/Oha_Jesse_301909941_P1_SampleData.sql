-- Fictional sample records for E-commerce Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at") VALUES (1, 'ava@example.test', 'Ava Chen', '2026-01-10T09:30:00Z');
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at") VALUES (2, 'noah@example.test', 'Noah Kim', '2026-01-11T10:15:00+00:00');
INSERT INTO portfolio."products" ("product_id", "sku", "name", "active") VALUES (101, 'MUG-001', 'Ceramic Mug', TRUE);
INSERT INTO portfolio."products" ("product_id", "sku", "name", "active") VALUES (102, 'BOOK-002', 'Notebook', TRUE);
INSERT INTO portfolio."orders" ("order_id", "customer_id", "idempotency_key", "placed_at", "status") VALUES (201, 1, 'ava-order-001', '2026-02-01T12:00:00Z', 'paid');
INSERT INTO portfolio."orders" ("order_id", "customer_id", "idempotency_key", "placed_at", "status") VALUES (202, 2, 'noah-order-001', '2026-02-02T13:15:00+00:00', 'pending');
INSERT INTO portfolio."order_items" ("line_id", "order_id", "product_id", "quantity", "unit_price") VALUES (301, 201, 101, 2, 12.5);
INSERT INTO portfolio."order_items" ("line_id", "order_id", "product_id", "quantity", "unit_price") VALUES (302, 202, 102, 1, 4.75);
COMMIT;
