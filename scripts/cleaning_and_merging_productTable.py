'''# Product Dimension Table Creation (dim_product)

## Purpose  
This script cleans, standardizes, and builds a **slowly changing dimension Type 2-aware** product master table (`dim_product`) from raw product info and category data.

### Key Tasks  
- Cleans product name, cost, line, and date validity  
- Handles **slowly changing product attributes** (valid-from / valid-to logic)  
- Corrects `prd_end_dt` using next record’s `prd_start_dt – 1 day`  
- Takes current (active) product snapshot by filtering null `prd_end_dt`  
- Extracts and standardizes `cat_id` from `prd_key`  
- Joins with product category hierarchy (category → sub-category)  
- Adds clean **surrogate key** (`prd_key`) for data warehouse use  

### Output  
`clean_dim_product.csv` – A clean, conformed **product dimension** ready for star schema, with proper hierarchy and current product attributes.

Perfect for analytics, reporting, and joining with `fact_sales`.'''
# ************************ Cleaning The product columns ************************ 
# understanding the data
df_prod_info.info()
df_prod_info.head()

# Checking the primary key is not repeated 
df_prod_info["prd_id"].value_counts()[df_prod_info["prd_id"].value_counts() > 1]

#Extracting the cat_id from prd_key 
df_prod_info["cat_id"] = df_prod_info["prd_key"].str.slice(start = 0 , stop = 5 )
df_prod_info["cat_id"] = df_prod_info["cat_id"].str.replace("-","_" ,regex = False)

# checking the cst_id column 
df_prod_info.head()

# Correcting the prd_key to join with sls_prd_key
df_prod_info["prd_key"] = df_prod_info["prd_key"].str.slice(start = 6)

df_prod_info.head() 

# checking unwanted spaces in prd_nm
df_prod_info[df_prod_info["prd_nm"] != df_prod_info["prd_nm"].str.strip()]

#Checking if prd_cost contain negative values 
df_prod_info[df_prod_info["prd_cost"] < 0 ]

#checking null values in prd_cost
df_prod_info[df_prod_info["prd_cost"].isna()]

# filling the null value with median
df_prod_info["prd_cost"].fillna(df_prod_info["prd_cost"].median(), inplace = True)

df_prod_info.head()

#checking the null values in prd_line 
df_prod_info[df_prod_info["prd_line"].isna()]

#checking unique value
df_prod_info["prd_line"].unique()

#removing spaces
df_prod_info["prd_line"] = df_prod_info["prd_line"].str.strip()

#filling null value with n/a 
df_prod_info["prd_line"] = df_prod_info["prd_line"].fillna("n/a")

df_prod_info.prd_line

#checing unique value in prd_line
df_prod_info["prd_line"].unique()

#checking the data type prd_start_dt
df_prod_info["prd_start_dt"].dtype

#checking the data type prd_end_dt
df_prod_info["prd_end_dt"].dtype

#changing the type of prd_start_dt and end_dt
df_prod_info["prd_start_dt"] = pd.to_datetime(df_prod_info["prd_start_dt"], format = "mixed", errors = "coerce")
df_prod_info["prd_end_dt"] = pd.to_datetime(df_prod_info["prd_end_dt"], format = "mixed", errors = "coerce")

df_prod_info[['prd_start_dt',"prd_end_dt"]]

#checking start and end date are correct 
df_prod_info[df_prod_info["prd_end_dt"] < df_prod_info["prd_start_dt"]]

 # Sorting by key and start date to maintain order
df_prod_info = df_prod_info.sort_values(["prd_key", "prd_start_dt"])

# Creating the next start date 
df_prod_info["next_start_dt"] = df_prod_info.groupby("prd_key")["prd_start_dt"].shift(-1)

# Subtracting 1 day to get end date
df_prod_info["prd_end_dt"] = df_prod_info["next_start_dt"] - pd.Timedelta(days=1)

#  Droping helper column
df_prod_info.drop(columns="next_start_dt", inplace=True)

# rechecking the end date 
df_prod_info[df_prod_info["prd_end_dt"] < df_prod_info["prd_start_dt"]]

df_prod_info

# ************************ Cleaning Product catagory ************************ 
#understanding the product catagory
df_prod_cat.info()
df_prod_cat.head()

# renaming the columns 
df_prod_cat.rename(columns = {
    "ID" : "cat_id",
    "CAT" : "category",
    "SUBCAT" : "sub_category",
    "MAINTENANCE" : "maintenance"
},inplace = True)

df_prod_cat.columns

#checking extra spaces in cst_id 
df_prod_cat[df_prod_cat["cat_id"] != df_prod_cat["cat_id"].str.strip()]

#checing the extra spaces in category
df_prod_cat[df_prod_cat["category"] != df_prod_cat["category"].str.strip()]

#checking nulls in category 
df_prod_cat["category"].isna().sum()

#checking the extra spaces in sub category 
df_prod_cat[df_prod_cat["sub_category"] != df_prod_cat["sub_category"].str.strip()]

#checking nulls in category 
df_prod_cat["sub_category"].isna().sum()

#checking the extra spaces in sub category 
df_prod_cat[df_prod_cat["maintenance"] != df_prod_cat["maintenance"].str.strip()]

#checking nulls in category 
df_prod_cat["maintenance"].isna().sum()

# ************************ Merging the product information table with product category and creating dim_products ************************ 

dim_product = pd.merge(df_prod_info, df_prod_cat, on = "cat_id", how = "left") 

dim_product.head()

# Filter for nulls and droping the end date column
dim_product = dim_product[dim_product['prd_end_dt'].isnull()].drop(columns=['prd_end_dt'])

#changing the dim product column name 
dim_product = dim_product.rename(columns = {
    "prd_key" : "prd_number",
    "prd_nm" : "prd_name"
})

dim_product.tail()

# add surrogate key in dim_product 
dim_product["prd_key"] = range(1, len(dim_product) + 1)

# checking the surrogate key 
dim_product.info()
dim_product.tail()

# ************************ creating csv file of dim_product ************************ 

dim_product.to_csv("clean_dim_product.csv", index = False)









