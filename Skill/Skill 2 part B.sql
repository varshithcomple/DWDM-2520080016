CREATE TABLE dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT
);
CREATE TABLE dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50)
);
CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50)
);
CREATE TABLE dim_store (
    store_key SERIAL PRIMARY KEY,
    store_id INT,
    store_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);
CREATE TABLE fact_sales (
    sales_key SERIAL PRIMARY KEY,
    transaction_id INT,
    date_key INT,
    product_key INT,
    customer_key INT,
    store_key INT,
    quantity INT,
    unit_price NUMERIC(10,2),
    discount NUMERIC(10,2),
    total_sales NUMERIC(12,2),

    FOREIGN KEY (date_key)
    REFERENCES dim_date(date_key),

    FOREIGN KEY (product_key)
    REFERENCES dim_product(product_key),

    FOREIGN KEY (customer_key)
    REFERENCES dim_customer(customer_key),

    FOREIGN KEY (store_key)
    REFERENCES dim_store(store_key)
);
INSERT INTO dim_date
(full_date,day,month,month_name,quarter,year)
VALUES
('2026-01-10',10,1,'January',1,2026),
('2026-01-15',15,1,'January',1,2026),
('2026-02-05',5,2,'February',1,2026),
('2026-02-20',20,2,'February',1,2026);
INSERT INTO dim_product
(product_id,product_name,category,brand)
VALUES
(101,'Laptop','Electronics','Dell'),
(102,'Mobile','Electronics','Samsung'),
(103,'Mouse','Accessories','Logitech'),
(104,'Keyboard','Accessories','HP'),
(105,'Chair','Furniture','Godrej');
INSERT INTO dim_customer
(customer_id,customer_name,gender,city,state)
VALUES
(201,'Rahul','Male','Hyderabad','Telangana'),
(202,'Priya','Female','Vijayawada','Andhra Pradesh'),
(203,'Amit','Male','Chennai','Tamil Nadu'),
(204,'Sneha','Female','Bengaluru','Karnataka');
INSERT INTO dim_store
(store_id,store_name,city,state)
VALUES
(301,'Central Mall','Hyderabad','Telangana'),
(302,'City Mall','Vijayawada','Andhra Pradesh'),
(303,'Mega Store','Chennai','Tamil Nadu');
INSERT INTO fact_sales
(transaction_id,date_key,product_key,
customer_key,store_key,quantity,
unit_price,discount,total_sales)
VALUES
(1001,1,1,1,1,2,50000,2000,98000),
(1001,1,3,1,1,1,1000,0,1000),
(1002,2,2,2,2,2,20000,1000,39000),
(1003,3,1,3,3,1,50000,5000,45000),
(1004,4,4,4,1,3,2000,0,6000);
SELECT SUM(total_sales) AS total_revenue
FROM fact_sales;
SELECT
p.product_name,
SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_product p
ON f.product_key = p.product_key
GROUP BY p.product_name;
SELECT
c.customer_name,
SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_customer c
ON f.customer_key = c.customer_key
GROUP BY c.customer_name;
SELECT
d.month_name,
SUM(f.total_sales) AS monthly_sales
FROM fact_sales f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY d.month,d.month_name
ORDER BY d.month;
SELECT
s.store_name,
SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_store s
ON f.store_key = s.store_key
GROUP BY s.store_name;
SELECT
p.category,
SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_product p
ON f.product_key = p.product_key
GROUP BY p.category;
SELECT
COUNT(*) AS total_records,
SUM(quantity) AS total_quantity,
SUM(total_sales) AS total_revenue
FROM fact_sales;
