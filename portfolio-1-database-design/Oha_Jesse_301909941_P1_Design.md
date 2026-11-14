# E-commerce Platform — database design

My case study records customers, products, orders, order_items.

## Users

- Customers placing and tracking orders
- Store staff reviewing orders and sales

## Main operations

- Create an order for a customer with one or more product lines.
- Filter orders by customer and status, and review their product lines.
- Aggregate order-line quantities and value by product.
- Separate benchmark plan: generate 20000 synthetic order lines, run the same order_id equality filter before and after a B-tree index on order_items.order_id, verify matching result sets, and compare repeated elapsed-time measurements after warm-up.

## Entities

| Entity | Information stored |
| --- | --- |
| customers | Stores customer identity and contact details. |
| products | Stores the catalog details used by order lines. |
| orders | Stores order ownership, placement time, status, and duplicate-submission protection. |
| order_items | Stores the products, quantities, and purchase-time prices belonging to each order. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## products

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## orders

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| idempotency_key | TEXT |  | Yes |
| placed_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customers.customer_id
- Unique key: (customer_id, idempotency_key).

## order_items

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| line_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → orders.order_id
- product_id → products.product_id

## Relationships and business rules

- Each customer email identifies at most one customer.
- Each product SKU identifies at most one catalog product.
- Every order references an existing customer.
- A customer cannot create two orders with the same idempotency key.
- Every order line references an existing order.
- Every order line references an existing product.
- An order-line quantity must be greater than zero.
- An order-line unit price must be zero or greater.
- An order status must be one of pending, paid, cancelled, or fulfilled.

## Assumptions

- Each customer has one email address, and product SKUs identify products uniquely.
- Each order belongs to one customer; each order line refers to one order and one product.
- Order-line unit prices are recorded at purchase time and do not change when a product's current details change.
- A customer's idempotency key is required and unique per customer to prevent duplicate order creation.
- The worked normalization example starts with orders: move repeated customer name and email details to customers, retaining customer_id on orders; this example uses one customer role and does not repeat ancestor roles.
- All example records and benchmark rows are synthetic.

