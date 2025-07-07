-- SQL Retail Sales Analysis --
CREATE DATABASE sql_project_p2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transaction_id INT PRIMARY KEY,	
    sale_date DATE,	 
    sale_time TIME,	
    customer_id	INT,
    gender	VARCHAR(15),
    age	INT,
    category VARCHAR(15),	
    quantity	INT,
    price_per_unit FLOAT,	
    cogs	FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Transactions in 'Clothing' category with quantity > 4 in Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;

-- Q.3 Total sales per category
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Average age of customers who purchased from 'Beauty' category
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Transactions where total_sale > 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Total number of transactions by gender and category
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Q.7 Average sale per month; best selling month per year
SELECT 
    year,
    month,
    avg_sale
FROM 
(    
    SELECT 
        EXTRACT(YEAR FROM sale_date) as year,
        EXTRACT(MONTH FROM sale_date) as month,
        AVG(total_sale) as avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
    FROM retail_sales
    GROUP BY 1, 2
) as t1
WHERE rank = 1;

-- Q.8 Top 5 customers by highest total sales
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Unique customers per category
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- Q.10 Orders by time-based shift (Morning, Afternoon, Evening)
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
