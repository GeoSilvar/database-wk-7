-- QUESTION 1

WITH RECURSIVE split_products AS (
    SELECT 
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_Products(Products, 1, INSTR(Products | ',', ',') - 1)) AS Product,
        SUBSTRING(Products, INSTR(Products | ',', ',') + 1) AS remaining_products
    FROM ProductDetail
    UNION ALL
    SELECT 
        OrderID,
        CustomerName,
        TRIM(SUBSTRING(remaining_products, 1, INSTR(remaining_products | ',', ',') - 1)),
        SUBSTRING(remaining_products, INSTR(remaining_products | ',', ',') + 1)
    FROM split_products
    WHERE remaining_products != ''
)
SELECT 
    OrderID,
    CustomerName,
    Product
FROM split_products
WHERE Product != ''
ORDER BY OrderID, Product;

-- QUESTION 2

-- 1st Step: Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL
);

-- 2nd Step: Create the new OrderDetails_2NF table
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 3rd Step: Insert data into Orders (remove duplicates)
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- 4th Step: Insert data into OrderDetails_2NF
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

