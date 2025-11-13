'''
Purpose (EDA_Queries.sql)
This SQL script performs comprehensive Exploratory Data Analysis (EDA) on the bikeSales_db data mart to uncover key business insights across multiple dimensions:

Overall performance metrics (total revenue, quantity, orders, AOV)
Time-based trends & seasonality (sales by year/month, best-performing month)
Product performance (top-selling products, categories, subcategories, and maintenance impact)
Customer analysis (top customers, sales by country, gender, marital status)
Demographic breakdowns (customer age distribution and purchasing behavior by age group)

Designed as a ready-to-run query library for business stakeholders and analysts to quickly understand sales patterns,
customer behavior, product performance, and growth opportunities in the bike sales dataset.
'''
-- 1.Overall Performance:
--  What are the total sales revenue and total quantity sold?
SELECT 
	SUM(sls_sales) AS total_sales_revenue,
    SUM(sls_quantity) AS total_quantity
FROM fact_sale;

-- What is the total number of unique orders and unique customers?
SELECT 
	COUNT(DISTINCT sls_ord_num) AS unique_order,
	COUNT( DISTINCT cst_key) AS unique_customer
FROM fact_sale;

-- What is the overall average order value?
SELECT 
	ROUND(SUM(sls_sales) / COUNT(DISTINCT sls_ord_num),2) AS avg_order_value
FROM fact_sale;

-- 2. Time-Based Analysis:
-- What are the total sales per year and per month?
SELECT 
	YEAR(sls_order_dt) AS order_year,
    MONTHNAME(sls_order_dt) AS order_month,
	SUM(sls_sales) AS total_sales
FROM fact_sale
GROUP BY YEAR(sls_order_dt), MONTHNAME(sls_order_dt)
ORDER BY order_year , order_month;

-- Is there a clear seasonality in sales?
-- * From the above table its clear that from june sales is going high till december.

-- What was the best month for sales?
SELECT 
	YEAR(sls_order_dt) AS order_year,
    MONTHNAME(sls_order_dt) AS order_month,
    SUM(sls_Sales) AS total_sales
FROM fact_sale
GROUP BY order_year,order_month
ORDER BY total_sales DESC
LIMIT 1;

-- 3.Product Analysis:
-- What are the top 10 best-selling products by revenue?
SELECT 
	p.prd_name AS best_selling_prd,
	SUM(s.sls_sales) AS revenue
FROM fact_sale s
LEFT JOIN dim_product p
ON s.prd_key = p.prd_key
GROUP BY best_selling_prd
ORDER BY revenue DESC
LIMIT 10;

-- What are the top 5 best-selling product categories and subcategories?
SELECT 
	p.category,
    p.sub_category,
    SUM(s.sls_sales) AS revenue
FROM dim_product p
LEFT JOIN fact_sale s 
ON p.prd_key = s.prd_key
GROUP BY category, sub_category
ORDER BY  revenue DESC
LIMIT 5;

-- Which products or categories have the highest maintenance requirements? Does this correlate with sales?
SELECT 
    p.prd_name,
    p.category,
    COUNT(*) AS maintenance_count,
    SUM(s.sls_sales) AS total_sales
FROM dim_product p
LEFT JOIN fact_sale s
    ON p.prd_key = s.prd_key
WHERE p.maintenance = 'Yes'
GROUP BY p.prd_name, p.category
ORDER BY maintenance_count DESC, total_sales DESC;

-- 4.Customer Analysis:
-- Who are the top 10 customers by total sales revenue?
SELECT 
	CONCAT(c.cst_firstname," ",c.cst_lastname) AS cst_name,
    SUM(s.sls_sales) AS total_sales_revenue
FROM dim_customer c
LEFT JOIN fact_sale s 
ON c.cst_key = s.cst_key
GROUP BY  cst_name
ORDER BY total_sales_revenue DESC
LIMIT 10 ;

-- What is the distribution of customers by country?
SELECT 
    cst_country,
    COUNT(cst_key) AS total_customer
FROM dim_customer
GROUP BY cst_country
ORDER BY total_customer DESC;

-- What is the total sales revenue by country?
SELECT 
	c.cst_country AS country,
    SUM(s.sls_sales) AS total_sales_revenue
FROM dim_customer c
LEFT JOIN fact_sale s
ON c.cst_key = s.cst_key
GROUP BY country
ORDER BY total_sales_revenue DESC;

-- 5.Customer Demographics:
-- What is the sales breakdown by gender?
SELECT 
	c.cst_gender AS gender,
    SUM(s.sls_sales) AS sales_revenue
FROM dim_customer c
LEFT JOIN fact_sale s
ON c.cst_key = s.cst_key 
GROUP BY gender
ORDER BY sales_revenue DESC;

-- What is the sales breakdown by marital status? (S vs. M).
SELECT 
	c.cst_marital_status AS marital_status,
    SUM(s.sls_sales) AS total_sales_revenue
FROM dim_customer c
LEFT JOIN fact_sale s
ON c.cst_key = s.cst_key 
GROUP BY marital_status
ORDER BY total_sales_revenue DESC;

-- Calculate customer age: YEAR(CURDATE()) - YEAR(birth_date). What is the average age of your customers?
SELECT 
    AVG(TIMESTAMPDIFF(YEAR, cst_birthdate, CURDATE())) AS avg_cst_age
FROM dim_customer;

-- What is the sales distribution by age group (e.g., 20-30, 30-40, etc.)?
SELECT 
    CASE
        WHEN TIMESTAMPDIFF(YEAR, c.cst_birthdate, CURDATE()) BETWEEN 20 AND 29 THEN '20-29'
        WHEN TIMESTAMPDIFF(YEAR, c.cst_birthdate, CURDATE()) BETWEEN 30 AND 39 THEN '30-39'
        WHEN TIMESTAMPDIFF(YEAR, c.cst_birthdate, CURDATE()) BETWEEN 40 AND 49 THEN '40-49'
        WHEN TIMESTAMPDIFF(YEAR, c.cst_birthdate, CURDATE()) BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    SUM(s.sls_sales) AS total_sales,
    COUNT(s.sls_ord_num) AS total_orders,
    COUNT(DISTINCT c.cst_key) AS total_customers
FROM dim_customer c
LEFT JOIN fact_sale s
    ON c.cst_key = s.cst_key
GROUP BY age_group
ORDER BY age_group;









