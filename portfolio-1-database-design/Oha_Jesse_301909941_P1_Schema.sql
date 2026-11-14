-- E-commerce Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customers" (
  "customer_id" bigint NOT NULL,
  "email" text NOT NULL,
  "display_name" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customers" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customers_0" UNIQUE ("email")
);
CREATE TABLE portfolio."products" (
  "product_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "name" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_products" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_products_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."orders" (
  "order_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "idempotency_key" text NOT NULL,
  "placed_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_orders" PRIMARY KEY ("order_id"),
  CONSTRAINT "uq_orders_0" UNIQUE ("customer_id", "idempotency_key")
);
CREATE TABLE portfolio."order_items" (
  "line_id" bigint NOT NULL,
  "order_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_order_items" PRIMARY KEY ("line_id")
);
ALTER TABLE portfolio."orders" ADD CONSTRAINT "fk_orders_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("customer_id");
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "fk_order_items_0" FOREIGN KEY ("order_id") REFERENCES portfolio."orders" ("order_id");
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "fk_order_items_1" FOREIGN KEY ("product_id") REFERENCES portfolio."products" ("product_id");
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "positive_item_quantity" CHECK ("quantity" > 0);
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "nonnegative_unit_price" CHECK ("unit_price" >= 0);
ALTER TABLE portfolio."orders" ADD CONSTRAINT "valid_order_status" CHECK (("status" = 'pending') OR ("status" = 'paid') OR ("status" = 'cancelled') OR ("status" = 'fulfilled'));
COMMIT;
