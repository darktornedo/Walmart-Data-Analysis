# 🛒 Walmart Sales Analysis Using Python, MySQL

## 📌 Project Overview
This project focuses on analyzing Walmart sales data to uncover business insights and patterns using **Python (Pandas, SQLAlchemy)**, **MySQL**.  
The main objective of this project is to clean, transform, and analyze the dataset to answer key business questions related to sales performance, profit, customer behavior, and payment methods.

---

## 🗂️ Project Workflow

### 1. Dataset Source
- The dataset was **downloaded from Kaggle** (Walmart Sales Dataset).
- It contains transactional data of different Walmart branches, including columns such as:
  - `invoice_id`, `branch`, `city`, `category`, `unit_price`, `quantity`, `date`, `time`, `payment_method`, `rating`, `profit_margin`.

---

### 2. Data Exploration in Excel
- The dataset was first **viewed and explored in Excel** to understand its structure and contents.
- Checked for missing values, column data types, and overall data consistency.

---

### 3. Data Cleaning & Preparation in Jupyter Notebook
- Imported required Python libraries:
  ```python
  import pandas as pd
  from sqlalchemy import create_engine
  import urllib.parse
- Used urllib.parse to handle special characters in the MySQL password while creating the connection string.
- Created the SQLAlchemy engine:
   ```
   password = urllib.parse.quote_plus("Your@MySQL#Password123")
   engine_mysql = create_engine(f"mysql+pymysql://root:{password}@localhost:3306/walmart_db")
- Performed data cleaning using pandas:
   - Removed null values
   - Dropped duplicate rows
   - Changed incorrect data types (like date and time)
   - Created two new calculated columns:
        - total_sales = unit_price * quantity
        - profit = total_sales * profit_margin
- Verified that the data was clean and consistent before loading it into MySQL.
