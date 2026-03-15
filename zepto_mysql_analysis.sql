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




-- ============================================================
-- BLOCK 2: FIX outOfStock COLUMN
-- Converts 'TRUE'/'FALSE' text to 1/0 numbers MySQL can use
-- ============================================================
SET SQL_SAFE_UPDATES = 0;
UPDATE zepto SET outOfStock = (UPPER(outOfStock) = 'TRUE');
SELECT outOfStock, COUNT(*) FROM zepto GROUP BY outOfStock;


-- ============================================================
-- BLOCK 3: DATA CLEANING
-- ============================================================

-- Remove products with zero price (invalid data)
DELETE FROM zepto WHERE mrp = 0;

-- Convert prices from paise to rupees (divide by 100)
-- Example: 45000 paise becomes 450.00 rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;


-- ============================================================
-- BLOCK 4: DATA EXPLORATION
-- Understand the dataset before analyzing
-- ============================================================

-- Total number of rows in the table
SELECT COUNT(*) FROM zepto;

-- Preview first 10 rows of raw data
SELECT * FROM zepto LIMIT 10;

-- Check for any NULL (missing) values across all important columns
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

-- See all 14 unique product categories
SELECT DISTINCT category FROM zepto ORDER BY category;

-- Count how many products are in stock vs out of stock
-- 0 = in stock, 1 = out of stock
SELECT outOfStock, COUNT(sku_id) AS product_count
FROM zepto
GROUP BY outOfStock;

-- Find product names that appear more than once (multiple SKUs)
SELECT name, COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


-- ============================================================
-- BLOCK 5: ANALYSIS QUERIES
-- ============================================================

-- Q1: Top 10 products with highest discount percentage
-- Shows best deals available on Zepto
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2: Premium products (MRP > 300) that are currently out of stock
-- These represent direct lost revenue opportunities
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;

-- Q3: Estimated revenue per category
-- Formula: selling price x available stock, grouped by category
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4: High MRP products (above 500) with low discount (below 10%)
-- These are premium, high-margin items with room for promotions
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5: Top 5 categories offering the highest average discount
-- Reveals which categories use aggressive pricing strategy
SELECT category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6: Price per gram for products weighing 100g or more
-- Lower value = better deal for the customer
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

-- Q7: Classify every product into Low / Medium / Bulk by weight
-- Low = under 1kg, Medium = 1kg to 5kg, Bulk = above 5kg
SELECT DISTINCT name, weightInGms,
       CASE
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q8: Total physical inventory weight per category (in grams)
-- Helps with warehouse space planning and logistics decisions
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

