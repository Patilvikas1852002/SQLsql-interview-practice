CREATE DATABASE interview_sql_practice;
USE interview_sql_practice;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_mode VARCHAR(20),
    payment_status VARCHAR(20),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
INSERT INTO customers VALUES
(1,'Ravi','Mumbai','2022-01-10'),
(2,'Anita','Pune','2022-03-15'),
(3,'Suresh','Delhi','2023-02-20'),
(4,'Meena','Bangalore','2023-04-10'),
(5,'Rahul','Mumbai','2023-06-05');

INSERT INTO products VALUES
(101,'Laptop','Electronics',60000),
(102,'Mobile','Electronics',30000),
(103,'Headphones','Accessories',3000),
(104,'Keyboard','Accessories',1500);

INSERT INTO orders VALUES
(1001,1,101,'2023-01-15',1),
(1002,1,103,'2023-02-10',2),
(1003,2,102,'2023-03-05',1),
(1004,3,104,'2023-03-20',3),
(1005,4,101,'2023-04-25',1),
(1006,5,103,'2023-06-15',1);

INSERT INTO payments VALUES
(1,1001,'UPI','SUCCESS',60000),
(2,1002,'CARD','FAILED',6000),
(3,1003,'UPI','SUCCESS',30000),
(4,1004,'NETBANKING','SUCCESS',4500),
(5,1005,'CARD','SUCCESS',60000),
(6,1006,'UPI','FAILED',3000);


select * from customers;
select * from orders;
select * from payments;
select * from products;

-- BASIC (TCS, Mahindra, Infosys)

-- Q1. Display customer name, city, and signup date

select  customer_name,city,signup_date from customers;
-- Q2. Show all orders with product name and quantity
SELECT O.ORDER_ID,P.PRODUCT_NAME,O.QUANTITY FROM ORDERS O JOIN  PRODUCTS P 
ON O.PRODUCT_ID=P.PRODUCT_ID;

-- Q3. Find customers from Mumbai only
SELECT * FROM CUSTOMERS
WHERE CITY='MUMBAI';

-- Q4. Show total number of orders placed
SELECT COUNT(*) AS TOTAL_NUMBER_OF_ORDERS FROM ORDERS

🟡 MEDIUM QUESTIONS

-- Q5. Find total amount spent by each customer
SELECT c.customer_name,c.customer_id,sum(p.price*o.quantity) as total_amt from customers c join  orders o
on c.customer_id=o.customer_id
join products p on p.product_id=o.product_id
group by c.customer_name,c.customer_id;


-- Q6. Show customers who have not placed any order

SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
SELECT customer_id, customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders
);


-- Q7. Display order_id, customer_name, product_name, payment_status 
select o.order_id,c.customer_name,p.product_name,py.payment_status from orders o
join customers c on
o.customer_id=c.customer_id
join products p on
o.product_id=p.product_id
left join payments py on 
o.order_id=py.order_id;


-- Q8. Find total sales per product category

select p.category,sum(p.price*o.quantity) as total_saales from orders o
join products p on o.product_id=p.product_id
group by category;


-- 🔥 NEXT ROUND (ADVANCED – Amazon, Uber, PayPal)

-- Choose ONE to continue:

-- Q9. Customers who made more than 1 order
select c.customer_name,count(o.order_id) from customers c join orders o on c.customer_id=o.customer_id
group by customer_name
having count(o.order_id)>1;
-- Q10. Highest selling product (by amount)
select p.product_name,sum(p.price*o.quantity) as total_sell from products p
join orders o on p.product_id=o.product_id
group by p.product_name
LIMIT 1;




-- Q11. Customers whose payment failed
with a as(select c.customer_name,o.order_id,p.payment_status from customers c
join orders o on c.customer_id=o.customer_id
left join payments p on o.order_id=p.order_id)
select customer_name,payment_status from a
where payment_status='failed';


-- Q12. Month-wise total revenue
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY order_month;

 
-- Q13. Customers who paid using UPI only

SELECT c.customer_name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_id, c.customer_name
HAVING 
    SUM(CASE WHEN p.payment_mode <> 'UPI' THEN 1 ELSE 0 END) = 0;
