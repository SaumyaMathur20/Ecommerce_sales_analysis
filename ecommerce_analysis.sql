-- ===========================================
-- E-COMMERCE SALES ANALYSIS
-- AUTHOR- Saumya Mathur
-- ===========================================

-- STEP1: database is created. Inside database the dataset table is imported. 
CREATE DATABASE Ecommerce_project;
USE Ecommerce_project;

-- preview the raw imported table
SELECT* FROM ecommerce_table;

-- displays the structure of the table
DESCRIBE ecommerce_table;

-- check total number of rows
SELECT COUNT(*)
FROM ecommerce_table;

-- edit the names of column if spaces exist in the column name
ALTER TABLE ecommerce_table
CHANGE COLUMN `Order Date` Order_Date DATE;
ALTER TABLE ecommerce_table
CHANGE COLUMN `Product Name` Product_Name text;

-- check for duplicates
SELECT *,
COUNT(*) as duplicate_count
FROM ecommerce_table
GROUP BY
Order_Date,
Product_Name,
Category,
Region,
Quantity,
Sales,
Profit
HAVING COUNT(*)>1;

-- Key Performance Indicators 
SELECT 
MIN(Quantity) as min_qnty,
MAX(Quantity) as max_sale,
MIN(Sales) as min_sale,
MAX(Sales) as max_sale,
MIN(Profit) as min_profit,
MAX(Profit) as max_profit
FROM ecommerce_table;

-- create MYSQL view and use it for calculated column and functions
CREATE VIEW ecomm_view AS
SELECT 
Order_Date,
Product_Name,
Category,
Region,
Quantity,
Sales,
Profit,
(Sales-Profit) AS Cost,
(Sales/NULLIF(Quantity,0)) AS Price_per_Unit,
(Sales/NULLIF(Profit,0)) AS profit_margin
FROM ecommerce_table;
SELECT * FROM ecomm_view;

-- KPI creation for later visual analysis
SELECT 
SUM(Sales) AS total_Sales,
SUM(Profit) AS Total_Profit,
SUM(profit_margin) AS Total_profit_margin,
SUM(Cost) AS Total_Cost,
AVG(profit_margin) AS avg_total_margin,
SUM(Quantity) AS Total_items_sold
FROM ecomm_view;

-- calculated sales by category
SELECT Category,
SUM(Sales) AS total_sales,
SUM(Profit) AS total_profit
FROM ecomm_view
GROUP BY Category
ORDER BY total_sales;

-- calculated sales by region
SELECT Region,
SUM(Sales) AS total_sales,
SUM(profit) AS total_profit
FROM ecomm_view
GROUP BY Region
ORDER BY total_sales;

-- calculated sales over time period i.e. date wise
SELECT Order_Date,
SUM(Sales) AS Total_sales,
SUM(Profit) AS Total_profit
FROM ecomm_view
GROUP BY Order_Date
ORDER BY Order_Date;

-- sales over Year- Month basis
SELECT 
DATE_FORMAT(Order_Date, '%y-%m') AS yearMonth,
SUM(Sales) AS total_sales,
SUM(Profit) AS total_profit
FROM ecomm_view
GROUP BY yearMonth
ORDER BY yearMonth;

