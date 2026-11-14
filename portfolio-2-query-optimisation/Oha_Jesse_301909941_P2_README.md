# E-commerce Platform — SQL queries

## 1. Show related orders, customers, order_items, products records (up to 20).

```sql
SELECT t0."order_id" AS "orders_order_id",
       t0."idempotency_key" AS "orders_idempotency_key",
       t3."customer_id" AS "customers_customer_id",
       t3."email" AS "customers_email",
       t1."line_id" AS "order_items_line_id",
       t1."quantity" AS "order_items_quantity",
       t2."product_id" AS "products_product_id",
       t2."sku" AS "products_sku"
FROM portfolio."orders" t0
JOIN portfolio."order_items" t1 ON t1."order_id" = t0."order_id"
JOIN portfolio."products" t2 ON t1."product_id" = t2."product_id"
JOIN portfolio."customers" t3 ON t0."customer_id" = t3."customer_id"
ORDER BY t0."order_id", t3."customer_id", t1."line_id", t2."product_id"
LIMIT 20;
```

| orders_order_id | orders_idempotency_key | customers_customer_id | customers_email | order_items_line_id | order_items_quantity | products_product_id | products_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 201 | ava-order-001 | 1 | ava@example.test | 301 | 2 | 101 | MUG-001 |
| 202 | noah-order-001 | 2 | noah@example.test | 302 | 1 | 102 | BOOK-002 |

## 2. Find customers records where email matches "ava@example.test" (up to 20).

```sql
SELECT * FROM portfolio."customers"
WHERE "email" IS NOT DISTINCT FROM 'ava@example.test'
ORDER BY "customer_id"
LIMIT 20;
```

| customer_id | email | display_name | created_at |
| --- | --- | --- | --- |
| 1 | ava@example.test | Ava Chen | 2026-01-10T09:30:00+00:00 |

## 3. Count order_items records for each order_id (up to 20 groups).

```sql
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_items"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
```

| order_id | record_count |
| --- | --- |
| 201 | 1 |
| 202 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.85 | 0.85, 0.856, 0.817 | Sort → Seq Scan | 112 |
| After index | 0.208 | 0.216, 0.208, 0.179 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.85 ms to 0.208 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.822..0.824 rows=20 loops=1)
  Seq Scan on order_items (actual time=0.018..0.788 rows=20 loops=1)
Planning Time: 0.35 ms
Execution Time: 0.85 ms
```

### Before index, run 2

```text
Sort (actual time=0.831..0.832 rows=20 loops=1)
  Seq Scan on order_items (actual time=0.018..0.798 rows=20 loops=1)
Planning Time: 0.31 ms
Execution Time: 0.856 ms
```

### Before index, run 3

```text
Sort (actual time=0.792..0.793 rows=20 loops=1)
  Seq Scan on order_items (actual time=0.017..0.758 rows=20 loops=1)
Planning Time: 0.304 ms
Execution Time: 0.817 ms
```

### After index, run 1

```text
Sort (actual time=0.134..0.136 rows=20 loops=1)
  Bitmap Heap Scan on order_items (actual time=0.037..0.095 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.018..0.018 rows=20 loops=1)
Planning Time: 0.686 ms
Execution Time: 0.216 ms
```

### After index, run 2

```text
Sort (actual time=0.153..0.155 rows=20 loops=1)
  Bitmap Heap Scan on order_items (actual time=0.034..0.12 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.018 rows=20 loops=1)
Planning Time: 0.504 ms
Execution Time: 0.208 ms
```

### After index, run 3

```text
Sort (actual time=0.124..0.126 rows=20 loops=1)
  Bitmap Heap Scan on order_items (actual time=0.033..0.091 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.506 ms
Execution Time: 0.179 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Oha_Jesse_301909941_P2_Queries.sql, then Oha_Jesse_301909941_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Oha_Jesse_301909941_P2_QueryResults.png) · [Index comparison](screenshots/Oha_Jesse_301909941_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

