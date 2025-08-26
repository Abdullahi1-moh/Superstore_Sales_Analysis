/* ===== Classic Models – Portfolio Views ===== */
/* Run this in MySQL Workbench.*/

-- 0) Choose the database
USE classicmodels;

-- 1) Orders by country (distinct orders)
DROP VIEW IF EXISTS v_orders_by_country;
CREATE VIEW v_orders_by_country AS
SELECT
  c.country,
  COUNT(DISTINCT o.orderNumber) AS total_orders
FROM customers c
JOIN orders o
  ON o.customerNumber = c.customerNumber
GROUP BY c.country
ORDER BY total_orders DESC;

-- 2) High-spending customers (> $10,000) – using payments table
DROP VIEW IF EXISTS v_high_spending_customers;
CREATE VIEW v_high_spending_customers AS
SELECT
  c.customerNumber,
  c.customerName,
  ROUND(SUM(p.amount), 2) AS total_spent
FROM customers c
JOIN payments p
  ON p.customerNumber = c.customerNumber
GROUP BY c.customerNumber, c.customerName
HAVING total_spent > 10000
ORDER BY total_spent DESC;

-- 3) Average order value by country (AOV)
DROP VIEW IF EXISTS v_avg_order_value_by_country;
CREATE VIEW v_avg_order_value_by_country AS
WITH order_totals AS (
  SELECT
    c.country,
    o.orderNumber,
    SUM(od.quantityOrdered * od.priceEach) AS order_total
  FROM customers c
  JOIN orders o
    ON o.customerNumber = c.customerNumber
  JOIN orderdetails od
    ON od.orderNumber = o.orderNumber
  GROUP BY c.country, o.orderNumber
)
SELECT
  country,
  ROUND(AVG(order_total), 2) AS avg_order_value
FROM order_totals
GROUP BY country
ORDER BY avg_order_value DESC;

-- 4) Top 3 cities by total sales
DROP VIEW IF EXISTS v_top_3_cities_by_sales;
CREATE VIEW v_top_3_cities_by_sales AS
SELECT
  c.city,
  ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS total_sales
FROM customers c
JOIN orders o
  ON o.customerNumber = c.customerNumber
JOIN orderdetails od
  ON od.orderNumber = o.orderNumber
GROUP BY c.city
ORDER BY total_sales DESC
LIMIT 3;

-- 5) Products per customer (distinct products + total units)
DROP VIEW IF EXISTS v_products_per_customer;
CREATE VIEW v_products_per_customer AS
SELECT
  c.customerNumber,
  c.customerName,
  COUNT(DISTINCT od.productCode) AS distinct_products,
  SUM(od.quantityOrdered)        AS total_units
FROM customers c
JOIN orders o
  ON o.customerNumber = c.customerNumber
JOIN orderdetails od
  ON od.orderNumber = o.orderNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY distinct_products DESC, total_units DESC;

-- 6) Products with no orders
DROP VIEW IF EXISTS v_products_with_no_orders;
CREATE VIEW v_products_with_no_orders AS
SELECT
  p.productCode,
  p.productName,
  p.productLine
FROM products p
LEFT JOIN orderdetails od
  ON od.productCode = p.productCode
WHERE od.productCode IS NULL
ORDER BY p.productLine, p.productName;

/* ===== Quick checks (run as needed) =====
SELECT * FROM v_orders_by_country;
SELECT * FROM v_high_spending_customers;
SELECT * FROM v_avg_order_value_by_country;
SELECT * FROM v_top_3_cities_by_sales;
SELECT * FROM v_products_per_customer;
SELECT * FROM v_products_with_no_orders;
*/
