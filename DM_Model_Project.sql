-- Define meta data in mysql workbench or any other SQL tool

show databases;

use retail;

select * from retail;


-- 1:What is the distribution of order values across all customers in the dataset?

Select CustomerID, sum(Quantity* UnitPrice) as TotalOrderValues
From retail
group by CustomerID
order by TotalOrderValues desc;

-- 2    How many unique products has each customer purchased?

select CustomerID , count(distinct StockCode) as UniqueProductsPurchased
from retail
group by CustomerID;

-- 3 Which customers have only made a single purchase from the company?

select CustomerID, count(distinct InvoiceNo) as PurchaseCount
from retail
group by CustomerID
having PurchaseCount=1;

-- 4  Which products are most commonly purchased together by customers in the dataset?

select  a.StockCode as ProductA, b.StockCode as productB, count(*) as PurchaseCount
from retail a
join retail b on a.InvoiceNo= b.InvoiceNo and a.StockCode < b.StockCode
group by ProductA, ProductB
order by PurchaseCount desc
limit 10;

-- Advance Qs
--  1.Customer Segmentation by Purchase Frequency
 
select CustomerID, count(InvoiceNo) as Purchase_Frequency
from retail
group by CustomerID;

select CustomerID,
		case 
			when Purchase_Frequency >= 20 then "High"
            when Purchase_Frequency >= 5 then "Medium"
            else "Low"
		end as Frequency_segement
from (
		select CustomerID, count(InvoiceNo) as Purchase_Frequency
        from retail
        group by CustomerID
	)   as sPurchase_Frequency;
    
-- 2. Average Order Value by Country
-- Calculate the average order value for each country to identify where your most valuable customers are located.

select Country, avg(Quantity * UnitPrice) as AverageOrderValue
from retail
group by Country
order by  AverageOrderValue desc;

-- 3. Customer Churn Analysis
-- Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn.

select customerID 
from retail
where InvoiceNo <= date_sub(now(), interval 6 month)
group by CustomerID 
having max(InvoiceDate) < date_sub(now(),interval 6 month);

-- 4. Product Affinity Analysis
--    Determine which products are often purchased together by calculating the correlation between product purchases.

create temporary table ProductPairs as
select A.StockCode as Product_A, B.StockCode as Product_B
from retail A
join retail B on A.InvoiceNo = B.InvoiceNo and A.StockCode < B.StockCode;

select Product_A, Product_B, count(*) as Occurrences
from  ProductPairs
group by Product_A, Product_B
order by Occurrences desc
limit 10;

	
    
-- 5. Time-based Analysis
 --   Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.
    
select
    year(InvoiceDate) as Year,
    month(InvoiceDate) as Month,
    count(distinct CustomerID) as Unique_Customers,
    sum(Quantity) as Total_Quantity_Sold
from retail
group by Year, Month
order by Year, Month;

-- Checking Null Values in DataSet
select *
from retail
where retail.InvoiceNo and retail.StockCode and retail.Description and retail.Quantity 
 and retail.InvoiceDate and retail.UnitPrice and retail.CustomerID and retail.Country is null;
