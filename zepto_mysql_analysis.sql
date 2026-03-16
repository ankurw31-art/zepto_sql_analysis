
CREATE DATABASE IF NOT EXISTS zepto_db;
USE zepto_db;
 
DROP TABLE IF EXISTS zepto;
 
CREATE TABLE zepto (
    sku_id                  INT AUTO_INCREMENT PRIMARY KEY,
    category                VARCHAR(120),
    name                    VARCHAR(150) NOT NULL,
    mrp                     DECIMAL(8,2),
    discountPercent         DECIMAL(5,2),
    availableQuantity       INT,
    discountedSellingPrice  DECIMAL(8,2),
    weightInGms             INT,
    outOfStock              VARCHAR(10),
    quantity                INT
);

SET SQL_SAFE_UPDATES = 0;

-- Step 1: Fix outOfStock column (convert TRUE/FALSE text to 1/0)
UPDATE zepto SET outOfStock = IF(UPPER(TRIM(outOfStock)) = 'TRUE', '1', '0');

-- Step 2: Convert prices from paise to rupees FIRST
UPDATE zepto
SET mrp                    = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- Step 3: Delete zero-price rows (after conversion)
DELETE FROM zepto WHERE mrp = 0;

-- Total number of rows
SELECT COUNT(*) AS total_rows FROM zepto;

-- Preview first 10 rows
SELECT * FROM zepto LIMIT 10;

-- Check for NULL values
SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- All unique product categories
SELECT DISTINCT category FROM zepto ORDER BY category;

-- Products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id) AS product_count
FROM zepto
GROUP BY outOfStock;

-- Product names with multiple SKUs
SELECT name, COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Q1: Top 10 products with highest discount percentage
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2: Premium products (MRP > 300) that are out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = '1' AND mrp > 300
ORDER BY mrp DESC;

-- Q3: Estimated revenue per category
SELECT category,
       ROUND(SUM(discountedSellingPrice * availableQuantity), 2) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4: High MRP (> 500) with low discount (< 10%)
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5: Top 5 categories by highest average discount
SELECT category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6: Price per gram for products weighing 100g or more
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

-- Q7: Classify products by weight (Low / Medium / Bulk)
SELECT DISTINCT name, weightInGms,
       CASE
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q8: Total inventory weight per category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
