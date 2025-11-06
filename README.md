# Global CycleSales: A Multi-Dimensional Sales & Customer Analysis

This is a complete, end-to-end data analytics portfolio project. The goal was to process raw, disparate data from multiple sources (sales, product, customer), build a clean and robust data pipeline, and ultimately create an interactive dashboard for business stakeholders to track KPIs and uncover insights.

**Core skills demonstrated:** Data Cleaning (ETL), Rel..." (Pandas), Relational Database Design (MySQL), Exploratory Data Analysis (SQL), and Business Intelligence & Visualization (Power BI).

---

## Tools & Technologies

* **Data Cleaning:** Pandas (in a Jupyter Notebook)
* **Database:** MySQL
* **Analysis:** SQL (in MySQL Workbench)
* **Visualization:** Power BI

---

## Project Workflow

This project was executed in three main phases:

### 1. Data Cleaning & Preparation (Pandas)

The first step was to clean and transform the 6 raw CSV files into analysis-ready tables.

* **Files:** `sales_details.csv`, `prd_info.csv`, `PX_CAT_G1V2.csv`, `cust_info.csv`, `LOC_A101.csv`, `CUST_AZ12.csv`
* **Process:**
    * Loaded all 6 files into Pandas DataFrames.
    * **Customer Data:** Merged three customer files (`cust_info`, `LOC_A101`, `CUST_AZ12`) into a single `dim_customer` table. This involved:
        * Standardizing inconsistent join keys (e.g., `AW00011000` vs. `NASAW00011000`).
        * Stripping leading/trailing whitespace from names.
        * Consolidating demographic and location data.
    * **Product Data:** Merged two product files (`prd_info`, `PX_CAT_G1V2`) into a single `dim_product` table. This required:
        * Engineering a new join key by splitting the `prd_key` to match the category `ID`.
        * Handling missing values in `prd_cost`.
    * **Sales Data:** Cleaned the `sales_details.csv` to create `fact_sales`.
        * Converted all date columns to the proper `datetime` format.
        * Verified numeric data types for sales and quantity.
* **Output:** Three clean CSVs: `clean_dim_customer.csv`, `clean_dim_product.csv`, and `clean_fact_sales.csv`.

### 2. Database Modeling & SQL Analysis (MySQL)

With clean data, the next step was to create a relational database and perform exploratory analysis.

* **Database Design:** Designed a **Star Schema** with `fact_sales` at the center, connected to `dim_customer` and `dim_product`.
* **Table Creation:** Wrote a `CREATE TABLE` script to build the database, defining primary keys, foreign keys, and data integrity constraints.
* **Data Loading:** Loaded the three clean CSVs into the MySQL database.
* **EDA with SQL:** Used SQL queries to explore the data and answer key business questions. (See `EDA_Queries.sql` in this repo).

**Sample EDA Questions Answered:**
* What are the total sales per year and month?
* What are the top 10 best-selling products by revenue?
* Who are the top 10 customers by total sales?
* What is the sales breakdown by country and customer gender?

### 3. Dashboard & Visualization (Power BI)

The final phase was to build an interactive dashboard for a non-technical audience.

* **Data Connection:** Connected Power BI directly to the MySQL database.
* **Data Modeling:** Built the data model in Power BI, creating relationships between the tables and adding a `dim_date` table using DAX for time-intelligence functions.
* **DAX Measures:** Wrote DAX measures to create key metrics like `[Total Sales]`, `[Total Quantity]`, `[Avg Order Value]`, and `[Sales YTD]`.
* **Visualization:** Designed a multi-page interactive dashboard with three views:
    1.  **Executive Summary:** High-level KPIs, sales over time, and sales by country.
    2.  **Product Deep Dive:** Analysis of sales by category, subcategory, and individual product.
    3.  **Customer Analysis:** A breakdown of customer demographics, sales by gender, and sales by marital status.

---

## Dashboard Preview

**(ADD SCREENSHOTS OF YOUR POWER BI DASHBOARD HERE)**

*Executive Summary Page:*
`[Insert screenshot of your main dashboard page]`

*Product Analysis Page:*
`[Insert screenshot of your product dashboard page]`

---
## ABOUT ME 
Hi there! I'm **Mohammed Sharfuddin**.
