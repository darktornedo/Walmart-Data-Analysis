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

### 2. Data Exploration in Excel
- The dataset was first **viewed and explored in Excel** to understand its structure and contents.
- Checked for missing values, column data types, and overall data consistency.

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
   - Replaced the $ sign and changed the incorrect data type for `unit_price` column (`object` to `float`)
   - Created two new calculated columns:
        - total_sales = unit_price * quantity
        - profit = total_sales * profit_margin
- Verified that the data was clean and consistent before loading it into MySQL.


### 4. Connecting to MySQL Database
- Established a successful connection to MySQL using the created SQLAlchemy engine.
- Loaded the cleaned dataset into a new MySQL table:
   ```
   df.to_sql(name='walmart', con=engine_mysql, if_exists='append', index=False)
- Confirmed the successful data transfer using:
   ```
   SELECT * FROM walmart
   Limit 10;
   ```


### 5. Business Problem Questions

---

### 🧠 Tools & Technologies Used
- Excel → For initial data exploration
- Python (Jupyter Notebook) → For data cleaning and preparation
- Libraries: pandas, sqlalchemy, urllib.parse
- MySQL → For database connection and SQL-based analysis


### 📊 Key Learnings
- Establishing database connections securely using SQLAlchemy and URL encoding for passwords with special characters.
- Cleaning and transforming data effectively using Pandas.
- Writing and executing complex SQL queries for business insights.
- Structuring an end-to-end data analysis workflow from raw dataset to actionable insights.


### 📁 Project Structure
```plaintext
📦 Walmart_Sales_Analysis
│
├── walmart_cleaned_dataset.csv     # Cleaned dataset file
├── walmart_analysis.ipynb          # Jupyter Notebook (data cleaning & MySQL connection)
├── walmart_queries.sql             # SQL business problem queries
├── README.md                       # Project documentation (this file)
└── requirements.txt                # Python libraries used
```

### 🧾 Conclusion
This project demonstrates a complete data analysis pipeline — from raw data extraction to business insights using Excel, Python, and MySQL.
It highlights the importance of data cleaning, database integration, and SQL querying for real-world business analysis.


👩‍💻 Author: Kumkum Pal
📧 Contact: kumkumpal404@gmail.com
