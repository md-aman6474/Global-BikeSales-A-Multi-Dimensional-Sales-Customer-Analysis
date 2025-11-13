-- creating database bikesales_db
CREATE DATABASE bikeSales_db;

USE bikeSales_db;

-- creating dim_customer table
CREATE TABLE dim_customer(
cst_id INT,
cst_number VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_create_date DATE,
cst_country VARCHAR(50),
cst_birthdate DATE,
cst_gender VARCHAR(50),
cst_key INT PRIMARY KEY 
);

-- creating dim_product table
CREATE TABLE dim_product(
prd_id INT,
prd_number VARCHAR(50),
prd_name VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
cat_id INT,
category VARCHAR(50),
sub_category VARCHAR(50),
maintenance VARCHAR(50),
prd_key INT PRIMARY KEY
);

-- creating fact_sale table
CREATE TABLE fact_sale(
sls_ord_num VARCHAR(50),
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
prd_key INT,
cst_key INT,
FOREIGN KEY(cst_key) REFERENCES dim_customer(cst_key),
FOREIGN KEY(prd_key) REFERENCES dim_product(prd_key)
);

-- loading data in dim_customer
LOAD DATA LOCAL INFILE "C:\\Users\\sharf\\OneDrive\\Desktop\\bike_sales_csv\\clean_dim_customer.xls"
INTO TABLE dim_customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'  
IGNORE 1 ROWS;

-- checking table
SELECT * FROM dim_customer;
select count(*) FROM dim_customer;

-- loading data in dim_product
LOAD DATA LOCAL INFILE "C:\\Users\\sharf\\OneDrive\\Desktop\\bike_sales_csv\\clean_dim_product.xls"
INTO TABLE dim_product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'  
IGNORE 1 ROWS;

-- checking the table 
SELECT * FROM dim_product;
SELECT COUNT(*) FROM dim_product;

-- loading data in dim_product
LOAD DATA LOCAL INFILE "C:\\Users\\sharf\\OneDrive\\Desktop\\bike_sales_csv\\clean_fact_sales.xls"
INTO TABLE fact_sale
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'  
IGNORE 1 ROWS;

-- checking the table 
SELECT * FROM fact_sale;
SELECT COUNT(*) FROM fact_sale;