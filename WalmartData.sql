create database IF NOT exists salesDataWalmart;

create table if not exists sales(
invoice_id varchar(30) NOT NULL primary KEY,
branch varchar(5) NOT NULL,
city varchar(30) NOT NULL,
customer_type varchar(30) NOT NULL,
gender varchar(10) NOT NULL,
product_line varchar(100) NOT NULL,
unit_price decimal(10,2) NOT NULL,
quantity int NOT NULL,
VAT float(6, 4) NOT NULL,
total decimal(12,4) NOT NULL,
date datetime NOT NULL,
time time NOT NULL,
payment_method varchar(15) NOT NULL,
cogs decimal(10,2) NOT NULL,
gross_margin_pct float(11,9),
gross_income decimal(12,4) NOT NULL,
rating float(2,1)
);


-- ---------------------------------------------------------------------------------------------------------
-- -------------------------------FEAUTURE ENGINEERING------------------------------------------------------
-- -----time of the day
select time,
CASE 
WHEN time between "00:00:00" and "12:00:00" THEN "Morning"
WHEN time between "12:01:00" and "16:00:00" THEN "Afternoon"
else "Evening"
end as time_of_day
from sales;
-- Adding a new column to the table
ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);
-- Update the new column based on the existing 'time' values
UPDATE sales
SET time_of_day = 
  CASE 
    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END;
  
-- -----day_of_week
select date, dayname(date) as day_of_week
from sales;
ALTER TABLE sales
ADD COLUMN day_of_week VARCHAR(10);
UPDATE sales
SET day_of_week = DAYNAME(date);

-- -----month_name
SELECT date, MONTHNAME(date) AS month_name
FROM sales;
ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = MONTHNAME(date);

-- ---------------------------------------------------------------------------------------------------------
-- ------------------------------------Exploratory Data Analysis--------------------------------------------

-- Generic Analysis-----------------------------------------------------------------------------------------

-- How many unique cities does the data have?
	SELECT COUNT(DISTINCT city) AS num_of_distinct_cities
FROM sales;

-- In which city is each branch?
select 
distinct branch,city
from sales;

--  PRODUCT Analysis ---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- How many product lines does the data have?

SELECT COUNT(DISTINCT product_line) 
FROM sales;

-- What are the most common payment methods?
select payment_method,
count(payment_method ) as num_of_payment
from sales
group by payment_method
order by num_of_payment desc ;

-- What are the most selling product lines?

select product_line,
count(product_line) as num_of_sales
from sales
group by product_line
order by num_of_sales desc ;

-- What is the total revenue by month?

select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What months had the largest cogs?

select month_name as month,
sum(cogs) as cogs
from sales
group by month
order by cogs desc;

-- What product line had the largest revenue?
select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?
select city,branch,
sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;

-- What is the most common product line by gender?
 
select	product_line,gender, count(gender) as gender_count
from sales
group by gender,product_line
order by gender_count, product_line desc ;

-- What is the average rating of each product line?

select product_line, round(avg(rating) ,2) as avg_rating
from sales
group by product_line
order by avg_rating desc;


-- SALES Analysis ------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

-- Number of sales made at each time of the day per weekday

select time_of_day,
    count(*) as total_sales
    from sales
    group by time_of_day;
    
-- Which of the customer types brings the most revenue

select customer_type,
sum(total) as total_rev
from sales
group by customer_type
order by total_rev;

-- Which city has the largest tax percent

select city,
avg(VAT) AS VAT
from sales
group by city
order by VAT desc;
      
-- Which customer type pays the most in VAT?
 select customer_type,avg(VAT) as VAT 
 from sales
 group by customer_type
 order by VAT desc;

-- CUSTOMER Analysis ---------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------
   
-- How many unique customer types does the data have?

     select  distinct customer_type
     from sales;
     
-- which customer type buys the most?

select customer_type,
count(*) as cstm_count
from sales
group by customer_type;

-- what is the gender of most of the customers?

select gender,
count(*) as gender_count
from sales
group by gender
order by gender_count desc;


-- what is the gender distribution per branch?

select gender, branch,
count(*) as gender_count
from sales
where branch = 'A'
group by gender
order by gender_count desc;

-- which time of the day do customers give most ratings?

select time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;


-- which time of the day do customers give most ratings per branch?

select time_of_day,branch,
avg(rating) as avg_rating
from sales
where branch = 'A'
group by time_of_day
order by avg_rating desc;

-- which day of the week has the best average ratings?

select day_of_week, avg(rating) as avg_rating
from sales
group by day_of_week
order by avg_rating desc;
-- 

