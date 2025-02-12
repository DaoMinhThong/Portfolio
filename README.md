<h1>E-commerce SQL project on BigQuery Studio</h1>
<h3> 1. About Dataset</h3>

- The Brazilian e-commerce dataset by Olist as an SQLite database file
- The datasets were used from Kaggle. There are 11 datasets, but just only 10 tables were explored and analyzed in this case

- Kaggle dataset: E-commerce dataset by Olist (SQLite):

  > https://www.kaggle.com/datasets/terencicp/e-commerce-dataset-by-olist-as-an-sqlite-database

![Database schema](https://github.com/DaoMinhThong/Portfolio/blob/main/ERD.png?raw=true)
- There are 7 SQL files containing query scripts (Google Big Query) written to determine and solve existing problems in this case. Before querying, the SQLite file had been extracted 

The SQLite file was converted into datasets (CSV) using Python: [Extract SQLite](https://github.com/DaoMinhThong/E-commerce_SQL_project/blob/main/Extract_datasets.ipynb)

<h3> 2. Explore Data Analysis</h3>

  **Big Query Studio** has support to perform each table without query 

<h3> 3. Data Analyst</h3>

#### Determine the meaning and problems of the database:
  - Explore orders, order_items, order_payments
  - Explore products, product_category_name_translation
  - Explore customers, Geolocation
  - Explore sellers → lead_qualify → lead_closed
#### Explore orders tables
  - How many orders per month, orders per weekday, orders per hours
  - How many order status
#### Explore the product data
  - How many products are sold on the web?
  - Report the main feature to focus on products
  - Which product or product category is the best-seller?
  - Categories_by_median with the top 20 categories get the best sales
#### Explore customer data
  - Fetch the top 20 customers paid the most money
  - Fetch the top 20 cities that have the most number of customers
  - Classifying the customer segmentation into 5 labels by RFM score:
  *{VIP, Churned, New, At Risk, Potential}*
  Create tables: customer_segmentation<br/>
  - Calculate average sales per customer for customer segmentation
  - Calculate Customer Lifetime Value -geolocation:<br>
      Determine the first time purchased, and the last time purchase<br>
      Calculating the duration (weeks) ⇔ Active Customer Lifetime (ACL)<br>
      Average Order Value<br>
  - Calculate Customer Lifetime Value -customer_segmentation:
#### Discuss productivity of delivery ability
  - How long does it take to conduct the order from purchased orders to the approved orders, the delivery carrier, and then to customer delivery? Productivity when compared with the predicted duration for each city
  - Daily avg shipping time
#### Product Affinity
  - Most order products
  - Analyzing the product affinity
#### Lead conversion



