# Zepto SQL Data Analysis Project

## Project Overview
End-to-end SQL data analysis on Zepto's product catalog. Zepto is a
quick-commerce grocery delivery platform in India. This project covers
data ingestion, cleaning, exploration, and 8 business intelligence queries
across 3,731 SKUs in 14 product categories using MySQL.
## Dataset
| Field | Details |
|---|---|
| File | zepto_v2.csv |
| Rows | 3,732 (3,731 after cleaning) |
| Categories | 14 |
| Columns | category, name, mrp, discountPercent, availableQuantity, |
| | discountedSellingPrice, weightInGms, outOfStock, quantity |
## Key Insights
| # | Insight |
|---|---|
| 1 | 3,731 valid SKUs across 14 categories after removing 1 zero-price record |
| 2 | 12.1% of products (453 SKUs) are out of stock — supply gap identified |
| 3 | Maximum discount is 51% — snacks and pasta dominate best-deal listings |
| 4 | Cooking Essentials and Munchies lead revenue at ~Rs.3.37L each |
| 5 | Fruits & Vegetables has highest avg discount at 15.5% — competing vs local
markets |
| 6 | Premium products (MRP > Rs.500, discount < 10%) identified for promotions |
| 7 | Staple foods rank best on price-per-gram metric |
| 8 | Weight classification (Low/Medium/Bulk) enables logistics segmentation |
## SQL Concepts Used
SELECT, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT, DISTINCT,
COUNT, SUM, AVG, ROUND, UPDATE, DELETE, CASE WHEN, Column Aliases,
Arithmetic in SELECT, IS NULL, AND/OR, AUTO_INCREMENT
## Project Structure
```

zepto_v2.csv Raw dataset
Zepto_SQL_data_analysis.sql All SQL queries
README.md Project documentation
```
## Setup
1. Create database: `CREATE DATABASE zepto_db; USE zepto_db;`
2. Create table using the schema in the .sql file
3. Import zepto_v2.csv via MySQL Workbench Table Data Import Wizard
4. Run queries from Zepto_SQL_data_analysis.sql in order
## Analysis Questions
- Q1: Top 10 products by discount percentage
- Q2: Premium products (MRP > Rs.300) that are out of stock
- Q3: Estimated revenue per category
- Q4: High MRP products with low discount
- Q5: Top 5 categories by average discount
- Q6: Best price-per-gram value products
- Q7: Product weight classification (Low / Medium / Bulk)
- Q8: Total inventory weight per category
## Tools
MySQL 8.0 | MySQL Workbench
