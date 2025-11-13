'''
Purpose:
This script loads and explores multiple raw datasets related to sales, products, and customers. It helps in understanding the structure, data types, and relationships between different tables before cleaning and transformation.

Main Tasks:
Imports essential libraries (pandas, numpy)
Loads CSV files from the data/ folder:
sales_details.csv
prd_info.csv
PX_CAT_G1V2.csv
cust_info.csv
LOC_A101.csv
CUST_AZ12.csv
Displays basic information and sample records from each dataset (.info() and .head())

Notes key observations like:
Columns with null values
Non-unique IDs
Incorrect data types (e.g., dates stored as objects)
Defines how different tables are related through common keys (e.g., product and customer IDs)

Use Case:
Run this script as the first step in your data analytics or ETL pipeline to verify dataset integrity and understand schema relationships before data cleaning and merging.
'''

#************************ importing liabraries ************************ 
import pandas as pd
import numpy as np

# ************************ loading all datasets ************************ 
df_sales = pd.read_csv("data/sales_details.csv")
df_prod_info = pd.read_csv('data/prd_info.csv')
df_prod_cat = pd.read_csv('data/PX_CAT_G1V2.csv')
df_cust_info = pd.read_csv('data/cust_info.csv')
df_cust_loc = pd.read_csv('data/LOC_A101.csv')
df_cust_demo = pd.read_csv('data/CUST_AZ12.csv')

#************************ Understanding Data Structure ************************ 

print("sales detail info")
df_sales.info()
df_sales.head()

print("customer detail info")
df_cust_info.info()
df_cust_info.head()

### Note:
#Customer Information:
# * Every column contains null values
# * cst_id is not unique
# * cst_create_date dtype is object

print("product detail info")
df_prod_info.info()
df_prod_info.head()

print("product category details")
df_prod_cat.info()
df_prod_cat.head()

print("customer location details")
df_cust_loc.info()
df_cust_loc.head()

## NOTE:
# Customer location information:
# * In cntry there is null values

print("customer extra details")
df_cust_demo.info()
df_cust_demo.head()

## NOTE:
# customer extra information:
# * customer id start with NAS
# * birthdate is object
# * gender have null values

##************************  RELATION BETWEWEN TABLE ************************ 
# * df_sales_info (prd_key) → joins with → df_prod_info (prd_key)
# * df_sales_info (cst_id) → joins with → df_cust_info (cst_id)
# * df_prod_cat (id) → joins with → df_prod_info (prd_key)
# * df_cust_info (cst_key) → joins with → df_cust_loc (cid) and df_cust_demo (cid)

