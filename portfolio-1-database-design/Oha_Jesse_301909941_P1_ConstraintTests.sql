-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. test customers pk. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (1, 'fresh-pk@example.test', 'Test Customer', '2026-03-01T09:00:00Z');

-- 2. test customers unique. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (9001, 'ava@example.test', 'Test Customer', '2026-03-01T09:00:00Z');

-- 3. test customers not null. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (9002, 'fresh@example.test', NULL, '2026-03-01T09:00:00Z');

-- 4. test products pk. Expected: pk_products, SQLSTATE 23505.
INSERT INTO portfolio."products" ("product_id", "sku", "name", "active")
VALUES (101, 'FRESH-SKU', 'Test Product', TRUE);

-- 5. test products unique. Expected: uq_products_0, SQLSTATE 23505.
INSERT INTO portfolio."products" ("product_id", "sku", "name", "active")
VALUES (9003, 'MUG-001', 'Test Product', TRUE);

-- 6. test orders pk. Expected: pk_orders, SQLSTATE 23505.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "idempotency_key", "placed_at", "status")
VALUES (201, 2, 'fresh-key', '2026-03-02T10:00:00Z', 'pending');

-- 7. test orders unique. Expected: uq_orders_0, SQLSTATE 23505.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "idempotency_key", "placed_at", "status")
VALUES (9004, 1, 'ava-order-001', '2026-03-02T10:00:00Z', 'pending');

-- 8. test orders fk. Expected: fk_orders_0, SQLSTATE 23503.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "idempotency_key", "placed_at", "status")
VALUES (9005, 999999, 'fresh-fk-key', '2026-03-02T10:00:00Z', 'pending');

-- 9. test order items pk. Expected: pk_order_items, SQLSTATE 23505.
INSERT INTO portfolio."order_items" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (301, 202, 102, 1, 1);

-- 10. test order items order fk. Expected: fk_order_items_0, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (9006, 999999, 101, 1, 1);

-- 11. test order items product fk. Expected: fk_order_items_1, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (9007, 201, 999999, 1, 1);

-- 12. test order items quantity check. Expected: positive_item_quantity, SQLSTATE 23514.
INSERT INTO portfolio."order_items" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (9008, 201, 101, 0, 1);

-- 13. test order items price check. Expected: nonnegative_unit_price, SQLSTATE 23514.
INSERT INTO portfolio."order_items" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (9009, 201, 101, 1, -1);

-- 14. test orders status check. Expected: valid_order_status, SQLSTATE 23514.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "idempotency_key", "placed_at", "status")
VALUES (9010, 1, 'fresh-status-key', '2026-03-02T10:00:00Z', 'shipped');
