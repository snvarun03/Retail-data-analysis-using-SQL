---Data Preparation and Understanding
---Q1
---Alias
select(select count(*) from customer) [Number of rows in customer],
		(select count(*) from prod_cat_info)[Number of rows in prod_cat_info],
		(select count(*) from Transactions)[Number of rows in transactions]

---Q2
select count(total_amt)[No of return transactions] from Transactions
where total_amt like '-%'


---Q3
select convert(date, dob,23)[converteddate] from Customer
select convert(date, tran_date, 23)[converteddate] from Transactions

---Q4

SELECT (datediff(day, MIN(tran_date),max(tran_date)))[Days], (datediff(month,MIN(tran_date),max(tran_date)))[Months]
,(datediff(year,min(tran_date),max(tran_date)))[Years]
FROM Transactions

---Q5
select prod_cat
from prod_cat_info
where prod_subcat = 'DIY'

----Data analysis
---Q1
select top 1 store_type, count(cust_id)[Most preferred transaction]
from transactions
group by Store_type
order by count(cust_id) desc

---Q2
select gender,count(customer_Id)[count_of_gender] from Customer
where Gender in ('M', 'F')
group by Gender

---Q3
select top 1 city_code,count(customer_id) [count_of_customers] from customer
group by city_code
order by count(customer_id) desc

---Q4
select prod_cat,count(prod_subcat)[count_of_prod_subcat]
from prod_cat_info
where prod_cat='Books'
group by prod_cat

---Q5
select top 1 p.prod_cat, t.prod_cat_code,max(qty)[Maximum qty]
from Transactions t left join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
group by p.prod_cat,t.prod_cat_code
order by max(qty) desc

---Q6
select p.prod_cat_code,p.prod_cat,sum(total_amt)[Total revenue] from Transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where p.prod_cat in ('Books','Electronics')
group by p.prod_cat_code,p.prod_cat
order by sum(total_amt) desc



---Q7
select count(customer_id)[number_of_customers] from Customer where customer_Id in 
(select cust_id from transactions t left join customer c on t.cust_id=c.customer_Id where total_amt not like '-%' group by cust_id
having count(transaction_id)>10)

---Q8
select sum(total_amt)[combined revenue] from Transactions t inner join prod_cat_info p on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where p.prod_cat in ('Electronics','Clothing') and Store_type='flagship store'

---Q9
select p.prod_subcat,sum(total_amt)[amount spend by Male]
from Transactions t left join customer c on t.cust_id=c.customer_Id
					left join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
					where gender='M' and p.prod_cat='Electronics'
group by p.prod_subcat
order by sum(total_amt) desc

---Q10
select top 5 p.prod_subcat,(sum(total_amt)/(select sum(total_amt) from transactions)*100) [Percentage_of_sales],
(count(case when qty<0 then qty else null end)/sum(t.Qty))*100[Percentage of returns] from transactions t
inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
group by p.prod_subcat
order by [Percentage_of_sales] desc

---Q11
select cust_Id,sum(total_amt)[Revenue]
from transactions
where cust_id in ((select customer_id from Customer where datediff(yyyy,dob,GETDATE()) between 25 and 35))
and tran_date between dateadd(day,-30,(select max(tran_date) from transactions)) and (select max(tran_date) from Transactions)
group by cust_id


---Q12
select top 1 p.prod_cat,sum(total_amt)[returns]
from transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where total_amt < 0 and tran_date between dateadd(month,-3,(select max(tran_date) from Transactions)) and (select max(tran_date) from Transactions)
group by p.prod_cat
order by [returns] desc 

---Q13
select top 1 store_type,sum(total_amt)[Total sales],sum(qty)[Total qty] from Transactions
group by store_type
order by [Total sales] desc

---Q14
select p.prod_cat,avg(total_amt)[Average greater than overall]
from transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
group by p.prod_cat
having avg(total_amt)>(select avg(total_amt) from transactions)
order by avg(total_amt) desc

---Q15
select p.prod_cat,p.prod_subcat,avg(total_amt)[Average],sum(total_amt)[Total revenue]
from transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where p.prod_cat in 
(
select top 5 p.prod_cat from Transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code
and t.prod_subcat_code=p.prod_sub_cat_code group by prod_cat order by sum(qty) desc
)
group by p.prod_cat,p.prod_subcat






