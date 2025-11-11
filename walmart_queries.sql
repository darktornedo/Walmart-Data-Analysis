create database walmart_db;

use walmart_db;

select * from walmart limit 10;

select count(*) from walmart;

-- Basic Understanding of the dataset:
-- count the total number of invoices in the dataset
select count(*) as total_orders from walmart;

-- count distinct branches
select count(distinct branch) as no_of_branches from walmart;

-- total sales in millions 
select round(sum(total_sales)/1000000.0,2) as total_sales from walmart;

-- calculating total profit generated across all branches
select round(sum(profit),2) as total_profit from walmart;

-- How many unique product categories are sold
select distinct category from walmart;

-- What is the average rating given by customers
select round(avg(rating),2) as avg_rating from walmart;

-- Highest rated category
select category, round(avg(rating),2) as avg_rating  
from walmart 
group by category
order by avg_rating desc;

-- Daily average number of transactions
select round(count(invoice_id)/count(distinct date),2) as avg_daily_transactions
from walmart;


-- Business Problem:
-- Q1: Find different payment methods, number of transactions, and quantity sold by payment method
select 
     payment_method, 
     count(*) as no_of_payments,
     sum(quantity) as total_qty_sold
from walmart
group by payment_method;


-- Q2: Which branch has the highest total sales
select branch, city, round(sum(total_sales),2) as total_sales
from walmart
group by branch, city
order by total_sales desc
limit 100;

-- Q3: Profit-Sale-Ratio across all the branch
select branch, city, round(sum(profit)/sum(total_sales),2) as profit_sale_ratio
from walmart
group by branch, city
order by profit_sale_ratio desc;

-- Q4: Branches with highest avg ratings
select branch, city, round(avg(rating),2) as avg_ratings
from walmart
group by branch, city
order by avg_ratings desc;


-- Q5: Identify the highest-rated category in each branch display the branch, category, and avg rating
with highest_rated_category as (
	   select 
            branch, 
            category, 
            round(avg(rating),2) as avg_rating,
            rank() over(partition by branch order by avg(rating) desc) as rnk
	   from walmart
       group by branch, category
	)
select 
     branch, 
     category, 
     avg_rating
from highest_rated_category
where rnk = 1;


-- Q6: Busiest day of the week by no of transactions
select dayname(str_to_date(date,"%d/%m/%y")) as day_name, count(*) as no_of_transactions
from walmart
group by day_name
order by no_of_transactions desc;


-- Q7: Identify the busiest day for each branch based on the number of transactions
with busiest_day as (
     select 
          branch,
          dayname(str_to_date(date,"%d/%m/%y")) as day_name,
          count(*) as no_of_transactions,
          rank() over(partition by branch order by count(*) desc) as rnk
	from walmart 
    group by branch, day_name
)
select 
     branch, 
     day_name, 
     no_of_transactions
from busiest_day
where rnk = 1;


-- Q8: Determine the average, minimum, and maximum rating of categories for each city
select 
      distinct city, 
      category, 
      round(avg(rating),2) as avg_rating, 
      min(rating) as min_rating,
      max(rating) as max_rating
from walmart
group by  city, category
order by city;


-- Q9: Determine the Peak sales hour
select 
      case
          when hour(time(time)) < 12 then "Morning"
          when hour(time(time)) between 12 and 16 then "Afternoon"
          when hour(time(time)) between 17 and 19 then "Evening"
          else "Night"
          end as shift_type,
          round(sum(total_sales),2) as total_sales
from walmart
group by shift_type
order by total_sales desc;

-- Q10: weekday vs weekend sales
select 
    case
        when dayofweek(str_to_date(date,"%d/%m/%y")) in (1,7) then "weekday"
        else "weekend"
        end as day_type,
        round(sum(total_sales),2) as total_sales
from walmart
group by day_type
order by total_sales desc;


-- Q11: Calculate the total profit for each category
with high_profit_category as (
    select 
        category, 
        round(sum(total_sales),2) as total_sales,
        round(sum(profit),2) as total_profit
   from walmart 
   group by category
)
select 
     category, 
     total_sales,
     total_profit,
     round((total_sales - total_profit),2) as profit_margin
from high_profit_category
order by profit_margin desc;


-- Q12: Do higher-rated transactions earn more profit?
select 
     case
         when rating >= 8 then "High Rated"
         when rating between 5 and 7.99 then "Medium Rated"
         else "Low Rated"
         end as rating_group,
         round(avg(profit),2) as avg_profit
from walmart
group by rating_group 
order by avg_profit desc;


-- Q13: city wise lowest rated category
with lowest_rated_category as(
      select 
          city, 
          category, 
          round(avg(rating),2) as avg_ratings,
          rank() over(partition by city order by avg(rating)) as rnk
      from walmart
      group by city,category
	)
select 
    city, 
    category,
    avg_ratings
from lowest_rated_category
where rnk = 1;

-- Q14: Determine the most common payment method for each branch
with most_common_payment_method as(
	    select 
		    branch, 
		    payment_method, 
			count(*) as total_transaction,
			rank() over(partition by branch order by count(*) desc) as rnk
		from walmart 
		group by branch, payment_method
) 
select 
	branch, 
	payment_method, 
	total_transaction
from most_common_payment_method
where rnk = 1;


-- Q15: Most profitable payment method by city
with profitable_payment_method as(
	  select 
          city, 
          payment_method, 
          round(sum(profit),2) as total_profit,
          rank() over(partition by city order by sum(profit) desc) as rnk
      from walmart 
	  group by city, payment_method
  )
select 
     city,
     payment_method,
     total_profit
from profitable_payment_method
where rnk = 1;


-- Q16: how many transactions occur in each shift (Morning, Afternoon, Evening) across branches
select
	branch,
    case
         when hour(time(time)) < 12 then "Morning"
         when hour(time(time)) between 12 and 16 then "Afternoon"
         when hour(time(time)) between 17 and 19 then "Evening"
         else "Night"
         end as shift,
	 round(sum(total_sales),2) as total_sales,
     count(*) as no_of_transactions
from walmart
group by branch, shift
order by branch, no_of_transactions desc;


-- Q17: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
with revenue_2022 as(
		select 
            branch,
            sum(total_sales) as revenue
		from walmart
        where year(str_to_date(date,"%d/%m/%y")) = 2022
        group by branch
   ),
revenue_2023 as(
        select
            branch,
            sum(total_sales) as revenue
		from walmart
        where year(str_to_date(date,"%d/%m/%y")) = 2023
        group by branch
  )
select 
     r_2022.branch, 
     r_2022.revenue as last_year_revenue, 
     r_2023.revenue as current_year_revenue,
     round((((r_2022.revenue - r_2023.revenue) / r_2022.revenue) *100),2) as revenue_decrease_ratio
from revenue_2022 as r_2022
join revenue_2023 as r_2023
on r_2022.branch = r_2023.branch
where r_2022.revenue > r_2023.revenue
order by revenue_decrease_ratio desc
limit 5;


-- Q18: Month over Month Sales grwoth percentage
with sale_growth as(
     select 
         date_format(str_to_date(date,"%d/%m/%y"),'%Y-%m') as month,
         round(sum(total_sales),2) as current_sales,
		 round(lag(sum(total_sales)) over(order by date_format(str_to_date(date,"%d/%m/%y"),'%Y-%m')),2)  as previous_sales
	from walmart
    group by month
)
select 
     month,
     current_sales,
     previous_sales,
     round((current_sales - previous_sales),2) as difference,
     round((current_sales - previous_sales)*100 /previous_sales,2) as sales_grwoth_percentage
from sale_growth;