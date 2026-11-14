# E-commerce Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | orders records (list) |
| --- | --- |
| 1 | [201] |
| 2 | [202] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| orders.order_id | orders.customer_id | orders.idempotency_key | customers.customer_id | customers.email |
| --- | --- | --- | --- | --- |
| 201 | 1 | ava-order-001 | 1 | ava@example.test |
| 202 | 2 | noah-order-001 | 2 | noah@example.test |

Key: order_id.

## 2NF: depend on the whole key

orders: customer_id is a proper part of candidate key (customer_id, idempotency_key), and determines customers details.

## customers_example

| customers.customer_id | customers.email |
| --- | --- |
| 1 | ava@example.test |
| 2 | noah@example.test |

## orders_example

| orders.order_id | orders.customer_id | orders.idempotency_key |
| --- | --- | --- |
| 201 | 1 | ava-order-001 |
| 202 | 2 | noah-order-001 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| customer_id | email | display_name | created_at |
| --- | --- | --- | --- |
| 1 | ava@example.test | Ava Chen | 2026-01-10T09:30:00+00:00 |
| 2 | noah@example.test | Noah Kim | 2026-01-11T10:15:00+00:00 |

## products

| product_id | sku | name | active |
| --- | --- | --- | --- |
| 101 | MUG-001 | Ceramic Mug | true |
| 102 | BOOK-002 | Notebook | true |

## orders

| order_id | customer_id | idempotency_key | placed_at | status |
| --- | --- | --- | --- | --- |
| 201 | 1 | ava-order-001 | 2026-02-01T12:00:00+00:00 | paid |
| 202 | 2 | noah-order-001 | 2026-02-02T13:15:00+00:00 | pending |

## order_items

| line_id | order_id | product_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 301 | 201 | 101 | 2 | 12.5 |
| 302 | 202 | 102 | 1 | 4.75 |

## Dependencies

- customers: (customer_id) → email, display_name, created_at
- products: (product_id) → sku, name, active
- orders: (order_id) → customer_id, idempotency_key, placed_at, status
- order_items: (line_id) → order_id, product_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
