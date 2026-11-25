CREATE TABLE Dim_Date (
    Date_Key INTEGER PRIMARY KEY,
    Full_Date DATE,
    Day INTEGER,
    Month INTEGER,
    Month_Name VARCHAR(20),
    Quarter INTEGER,
    Year INTEGER
);

CREATE TABLE Dim_Product (
    Product_Key INTEGER PRIMARY KEY,
    Product_ID VARCHAR(20),
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50)
);

CREATE TABLE Dim_Customer (
    Customer_Key INTEGER PRIMARY KEY,
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Gender VARCHAR(10),
    City VARCHAR(50)
);

CREATE TABLE Dim_Store (
    Store_Key INTEGER PRIMARY KEY,
    Store_ID VARCHAR(20),
    Store_Name VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50)
);

CREATE TABLE Fact_Sales (
    Sales_Key INTEGER PRIMARY KEY,
    Date_Key INTEGER,
    Product_Key INTEGER,
    Customer_Key INTEGER,
    Store_Key INTEGER,
    Quantity INTEGER,
    Unit_Price NUMERIC(10,2),
    Sales_Amount NUMERIC(12,2),

    FOREIGN KEY (Date_Key)
        REFERENCES Dim_Date(Date_Key),

    FOREIGN KEY (Product_Key)
        REFERENCES Dim_Product(Product_Key),

    FOREIGN KEY (Customer_Key)
        REFERENCES Dim_Customer(Customer_Key),

    FOREIGN KEY (Store_Key)
        REFERENCES Dim_Store(Store_Key)
);
INSERT INTO Dim_Date VALUES
(20260110, '2026-01-10', 10, 1, 'January', 1, 2026),
(20260111, '2026-01-11', 11, 1, 'January', 1, 2026),
(20260205, '2026-02-05', 5, 2, 'February', 1, 2026),
(20260215, '2026-02-15', 15, 2, 'February', 1, 2026),
(20260310, '2026-03-10', 10, 3, 'March', 1, 2026);

INSERT INTO Dim_Product VALUES
(1, 'P101', 'Laptop', 'Electronics', 'Dell'),
(2, 'P102', 'Mouse', 'Accessories', 'Logitech'),
(3, 'P103', 'Keyboard', 'Accessories', 'HP'),
(4, 'P104', 'Mobile', 'Electronics', 'Samsung');

INSERT INTO Dim_Customer VALUES
(1, 'C101', 'Rahul', 'Male', 'Hyderabad'),
(2, 'C102', 'Priya', 'Female', 'Vijayawada'),
(3, 'C103', 'Amit', 'Male', 'Chennai'),
(4, 'C104', 'Sneha', 'Female', 'Bengaluru');

INSERT INTO Dim_Store VALUES
(1, 'S101', 'Store A', 'Hyderabad', 'Telangana'),
(2, 'S102', 'Store B', 'Vijayawada', 'Andhra Pradesh'),
(3, 'S103', 'Store C', 'Chennai', 'Tamil Nadu');

INSERT INTO Fact_Sales VALUES
(1, 20260110, 1, 1, 1, 1, 50000, 50000),
(2, 20260110, 2, 1, 1, 2, 500, 1000),
(3, 20260111, 3, 2, 2, 1, 1500, 1500),
(4, 20260205, 4, 3, 3, 2, 20000, 40000),
(5, 20260215, 1, 4, 1, 1, 50000, 50000),
(6, 20260310, 2, 2, 2, 3, 500, 1500);
SELECT
    P.Product_Name,
    SUM(F.Quantity) AS Total_Quantity,
    SUM(F.Sales_Amount) AS Total_Sales
FROM Fact_Sales F
JOIN Dim_Product P
    ON F.Product_Key = P.Product_Key
GROUP BY P.Product_Name
ORDER BY Total_Sales DESC;
SELECT
    D.Month_Name,
    SUM(F.Sales_Amount) AS Monthly_Sales
FROM Fact_Sales F
JOIN Dim_Date D
    ON F.Date_Key = D.Date_Key
GROUP BY D.Month, D.Month_Name
ORDER BY D.Month;
CREATE TABLE Dim_Category (
    Category_Key INTEGER PRIMARY KEY,
    Category_Name VARCHAR(50)
);

INSERT INTO Dim_Category VALUES
(1, 'Electronics'),
(2, 'Accessories');

CREATE TABLE Dim_Product_Snowflake (
    Product_Key INTEGER PRIMARY KEY,
    Product_ID VARCHAR(20),
    Product_Name VARCHAR(100),
    Category_Key INTEGER,

    FOREIGN KEY (Category_Key)
        REFERENCES Dim_Category(Category_Key)
);

INSERT INTO Dim_Product_Snowflake VALUES
(1, 'P101', 'Laptop', 1),
(2, 'P102', 'Mouse', 2),
(3, 'P103', 'Keyboard', 2),
(4, 'P104', 'Mobile', 1);
SELECT
    C.Category_Name,
    SUM(F.Quantity) AS Total_Quantity,
    SUM(F.Sales_Amount) AS Total_Sales
FROM Fact_Sales F
JOIN Dim_Product_Snowflake P
    ON F.Product_Key = P.Product_Key
JOIN Dim_Category C
    ON P.Category_Key = C.Category_Key
GROUP BY C.Category_Name
ORDER BY Total_Sales DESC;


