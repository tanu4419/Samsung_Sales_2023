create database samsung;
use samsung;
drop database Beanie;

alter table samsung_sales_data
MODIFY date DATE;

-- 1. Count the total number of unique products sold.
SELECT COUNT(DISTINCT product_id) AS unique_products_sold
FROM samsung_sales_data;

-- 2. Find the top 5 highest-selling products by total sales.
SELECT product_id, SUM(total_sales) AS total_sales
FROM samsung_sales_data
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 5;

-- 3. Calculate the total revenue generated for all products.
SELECT SUM(total_sales) AS total_revenue
FROM samsung_sales_data;

-- 4. Find the product with the highest total revenue.
SELECT product_id, SUM(total_sales) AS total_sales
FROM samsung_sales_data
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 1;

-- 5. Find all transactions that occurred in October 2023.
SELECT *
FROM samsung_sales_data
WHERE DATE_FORMAT(date, '%Y-%m') = '2023-10';

-- 6. Find the average price of products sold.
SELECT AVG(price) AS average_price
FROM samsung_sales_data;

-- 7. Sales in a Specific Period (e.g., Q1 2023) 
SELECT SUM(s.quantity * s.price) AS total_sales
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE s.date BETWEEN '2023-01-01' AND '2023-03-31';

-- 8. Most Sold Product (Units) in 2023 
SELECT p.product_name, SUM(s.quantity) AS total_units_sold
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE YEAR(s.date) = 2023
GROUP BY p.product_name
ORDER BY total_units_sold DESC
LIMIT 1;

-- 9. Sales Performance by Price Range 
SELECT 
    CASE
        WHEN s.price < 10000 THEN 'Under 10K'
        WHEN s.price BETWEEN 10000 AND 20000 THEN '10K-20K'
        WHEN s.price BETWEEN 20000 AND 30000 THEN '20K-30K'
        ELSE 'Above 30K'
    END AS price_range,
    SUM(s.quantity * s.price) AS total_sales
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
GROUP BY price_range
ORDER BY total_sales DESC;

-- 10. Quarterly Sales Trend in 2023 
SELECT 
    CASE
        WHEN MONTH(s.date) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(s.date) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(s.date) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(s.date) BETWEEN 10 AND 12 THEN 'Q4'
    END AS quarter,
    SUM(s.quantity * s.price) AS total_sales
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE YEAR(s.date) = 2023
GROUP BY quarter
ORDER BY quarter;


-- 11. Which month had the highest total sales in 2023? 
SELECT MONTH(s.date) AS month, SUM(s.quantity * s.price) AS total_sales
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE YEAR(s.date) = 2023
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;

-- 12. What was the total sales revenue for the first half of 2023 (Jan-Jun)? 
SELECT SUM(s.quantity * s.price) AS total_sales
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE s.date BETWEEN '2023-01-01' AND '2023-06-30';

-- 13 How many products were sold each month in 2023? 
SELECT MONTH(s.date) AS month, SUM(s.quantity) AS total_units_sold
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE YEAR(s.date) = 2023
GROUP BY month
ORDER BY month;

-- 14 What is the price range for the products sold? 
SELECT MIN(s.price) AS lowest_price, MAX(s.price) AS highest_price
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id;

-- 15. How many products were sold with a price above the average price? 
SELECT p.product_name, SUM(s.quantity) AS total_units_sold
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE s.price > (SELECT AVG(price) FROM samsung_sales_data)
GROUP BY p.product_name
ORDER BY total_units_sold DESC;

-- 16. How many products were sold in each quarter?
SELECT 
    CASE 
        WHEN MONTH(s.date) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(s.date) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(s.date) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS quarter,
    SUM(s.quantity) AS total_units_sold
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
GROUP BY quarter
ORDER BY quarter;

-- 17. What was the total revenue from the top 3 most sold products?
SELECT p.product_name, SUM(s.quantity * s.price) AS total_revenue
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 3;

-- 18. Which product had the largest price drop between the first and last sale? 
SELECT p.product_name, 
       (MAX(s.price) - MIN(s.price)) AS price_drop
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY price_drop DESC
LIMIT 1;

-- 19. How many products were sold during weekends (Saturday and Sunday)? 
SELECT p.product_name, SUM(s.quantity) AS total_units_sold
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
WHERE DAYOFWEEK(s.date) IN (7, 1)  -- 7 is Saturday, 1 is Sunday
GROUP BY p.product_name
ORDER BY total_units_sold DESC;

-- 20. What is the total quantity sold for each product, grouped by product name and release year?
SELECT p.product_name, p.release_year, SUM(s.quantity) AS total_quantity_sold
FROM samsung_sales_data s
JOIN samsung_product_data p ON s.product_id = p.product_id
GROUP BY p.product_name, p.release_year
ORDER BY total_quantity_sold DESC;

-- 21. Count the total number of transactions for each product.**
SELECT product_id, COUNT(transaction_id) AS total_transactions
FROM samsung_sales_data
GROUP BY product_id;

-- 22. List all products that have not been sold (no matching records in sales data).**
SELECT p.*
FROM samsung_product_data p
LEFT JOIN samsung_sales_data s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- 23. List all products released in 2023.**
SELECT *
FROM samsung_product_data
WHERE release_year = 2023;

-- 24. Find the most recent transaction date for each product.**
SELECT product_id, MAX(date) AS most_recent_transaction
FROM samsung_sales_data
GROUP BY product_id;

-- 25. Find the total quantity sold for each product.**
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM samsung_sales_data
GROUP BY product_id;

-- 26. Find the total sales for each product.
SELECT product_id, SUM(total_sales) AS total_sales
FROM samsung_sales_data
GROUP BY product_id;

-- 27. Retrieve details of a sample of products (e.g., top 5 by release year).**
SELECT product_id, product_name, category, brand, release_year
FROM samsung_product_data
ORDER BY release_year DESC
LIMIT 5;


 





 

 


