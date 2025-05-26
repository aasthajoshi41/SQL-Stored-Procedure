  -- Create Customers_sp Table
CREATE TABLE Customers_sp (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    CreatedDate DATETIME
);

-- Create Products_sp Table
CREATE TABLE Products_sp (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

-- Create Orders_sp Table
CREATE TABLE Orders_sp (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers_sp(CustomerID)
);

-- Create OrderDetails_sp Table
CREATE TABLE OrderDetails_sp (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders_sp(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products_sp(ProductID)
);

-- Insert into Customers_sp
INSERT INTO Customers_sp VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '2023-01-10'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '2023-02-15'),
(3, 'Mike', 'Johnson', 'mike.johnson@example.com', '2023-03-20');

-- Insert into Products_sp
INSERT INTO Products_sp VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Desk Chair', 'Furniture', 150.00, 20);

-- Insert into Orders_sp
INSERT INTO Orders_sp VALUES
(1, 1, '2023-04-01', 1950.00),
(2, 2, '2023-04-05', 800.00),
(3, 1, '2023-04-10', 150.00);

-- Insert into OrderDetails_sp
INSERT INTO OrderDetails_sp VALUES
(1, 1, 1, 1, 1200.00),   -- John Doe ordered 1 Laptop
(2, 1, 2, 1, 800.00),    -- John Doe ordered 1 Smartphone
(3, 2, 2, 1, 800.00),    -- Jane Smith ordered 1 Smartphone
(4, 3, 3, 1, 150.00);    -- John Doe ordered 1 Desk Chair

INSERT INTO OrderDetails_sp VALUES (5, 3, 2, 3, 100.00);

SELECT * FROM Customers_sp; 
SELECT * FROM Products_sp;
SELECT * FROM Orders_sp;
SELECT * FROM OrderDetails_sp;

-- 1 Write a stored procedure to insert a new customer.

SELECT * FROM Customers_sp; 

alter PROCEDURE InsertNewCustomer
    @CustomerID INT,
    @FirstName VARCHAR(100),
    @Email VARCHAR(100)
AS
BEGIN
    INSERT INTO Customers_sp  (CustomerID, FirstName, Email)
    VALUES (@CustomerID, @FirstName, @Email);
END;

EXEC InsertNewCustomer 
    @CustomerID = 5, 
    @FirstName = 'AVINASH', 
    @Email = 'AVI@example.com';


-- 2 Write a stored procedure to update a customer's email.

SELECT * FROM Customers_sp; 

ALTER PROCEDURE Updatemail
	@CustomerID INT = 3
AS
BEGIN
	UPDATE Customers_sp
	set Email = 'a@gmail.com'
	where CustomerID = @CustomerID
END;

EXEC Updatemail;



CREATE PROCEDURE Updatemail1
	@CustomerID INT,
	@Email VARCHAR(100)
AS
BEGIN
	UPDATE Customers_sp
	SET Email = @Email
	WHERE CustomerID = @CustomerID;
END;

EXEC Updatemail1
	 @CustomerID = 1,
	 @Email = 'Q@GMAIL.COM';

-- 3 Write a stored procedure to delete a customer by ID.

SELECT * FROM Customers_sp;

ALTER PROCEDURE Deletecus
	@CustomerID INT = 4
AS
BEGIN
	delete from  Customers_sp
	where CustomerID = @CustomerID
END;

EXEC Deletecus;

--4 Write a stored procedure to retrieve all customers.

CREATE PROCEDURE GetAllCustomers
AS
BEGIN
    SELECT * FROM Customers_sp;
END;

EXEC GetAllCustomers;

--5 Write a stored procedure to find customers created in the last 30 days.

SELECT * FROM Customers_sp;

ALTER PROCEDURE recentcustomers
AS
BEGIN
	SELECT * FROM Customers_sp
	WHERE CreatedDate >= DATEADD(DAY, -30, GETDATE());
END;

EXEC recentcustomers;


--6 Write a stored procedure to insert a new product.

SELECT * FROM Products_sp;

CREATE PROCEDURE insertpro
	@ProductID int,
	@ProductName varchar(255),
	@Category varchar(50),
	@Price float,
	@Stock int
AS
BEGIN
	INSERT INTO Products_sp (ProductID, ProductName, Category, Price, Stock)
	 VALUES (@ProductID, @ProductName, @Category, @Price, @Stock);
END;

EXEC insertpro 4, Mobile, Electronics, 12000.00, 40;

--7 Write a stored procedure to get all products below a given stock level.

SELECT * FROM Products_sp;

CREATE PROCEDURE belowstocklevel
    @StockThreshold INT
AS
BEGIN
    SELECT * 
    FROM Products_sp
    WHERE Stock < @StockThreshold;
END;

EXEC belowstocklevel @StockThreshold = 20;

--8 Write a stored procedure to update product price by ProductID.

SELECT * FROM Products_sp;

CREATE PROCEDURE updateproductprice
    @ProductID INT,
	@Price float
AS
BEGIN
	UPDATE Products_sp
	SET Price = @Price
	WHERE ProductID = @ProductID;
END;

EXEC updateproductprice
    @ProductID = 2,
    @Price = 750.00;

--9 Write a stored procedure to retrieve all orders by a specific customer.

SELECT * FROM Orders_sp;

CREATE PROCEDURE GetOrdersByCustomer
    @CustomerID INT
AS
BEGIN
    SELECT * 
    FROM Orders_sp
    WHERE CustomerID = @CustomerID;
END;

EXEC GetOrdersByCustomer
	 @CustomerID = 1;

--10 Write a stored procedure to calculate total amount for an order using OrderDetails.

SELECT * FROM OrderDetails_sp;

CREATE PROCEDURE totalorder
    @OrderID INT
AS
BEGIN
	SELECT 
	@OrderID AS OrderID,
	SUM(Quantity * UnitPrice) AS TotalAmount
	FROM OrderDetails_sp
	WHERE OrderID = @OrderID;
END;

EXEC totalorder @OrderID = 3;

-- 11 Write a stored procedure to delete an order and its related order details.

SELECT * FROM OrderDetails_sp;
SELECT * FROM Orders_sp;

CREATE PROCEDURE deleteorderdetails
    @OrderID INT
AS
BEGIN
	DELETE FROM OrderDetails_sp
    WHERE OrderID = @OrderID;

	DELETE FROM Orders_sp
    WHERE OrderID = @OrderID;
END;

EXEC deleteorderdetails @OrderID = 1;

--12 Write a stored procedure to fetch products in a specific category.

SELECT * FROM Products_sp;

CREATE PROCEDURE specificcat
    @Category varchar(255)
AS
BEGIN
	SELECT * 
    FROM Products_sp
	WHERE Category = @Category;
END;

EXEC specificcat @Category = 'Electronics';

--13 Write a stored procedure to count the number of orders placed by a customer.

SELECT * FROM Orders_sp;

alter PROCEDURE totalorderbycus
	@CustomerID INT
AS
BEGIN
	SELECT 
	COUNT (*) AS totalcus
	FROM Orders_sp
	WHERE CustomerID = @CustomerID;
END;

EXEC totalorderbycus  @CustomerID = 1;

--14 Write a stored procedure to list top 5 products with highest stock.

SELECT * FROM Products_sp;

alter PROCEDURE top5
AS
BEGIN
	SELECT TOP 5 ProductName
    FROM Products_sp
	ORDER BY Stock DESC;
end;

EXEC top5;

--15 Write a stored procedure to get order history (order + details) for a customer.

CREATE PROCEDURE orderhis
    @CustomerID INT
AS
BEGIN
    SELECT o.OrderID, o.OrderDate, od.ProductID, p.ProductName, od.quantity, od.UnitPrice, (od.quantity * od.UnitPrice) AS total_price
    FROM Orders_sp o
    INNER JOIN OrderDetails_sp od ON o.OrderID = od.OrderID
    INNER JOIN Products_sp p ON od.ProductID = p.ProductID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC, o.OrderID;
END;

EXEC orderhis @CustomerID = 1;

--16 Write a stored procedure to check if a customer exists by email.

SELECT * FROM Customers_sp;

CREATE PROCEDURE cusbyemail
    @Email varchar(255)
AS
BEGIN
	SELECT * 
    FROM Customers_sp
    WHERE Email = @Email;
END;

EXEC cusbyemail @Email = 'Q@GMAIL.COM';

--17 Write a stored procedure to list orders placed in a specific date range.

SELECT * FROM Orders_sp;

CREATE PROCEDURE ordersbydate
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT *
    FROM Orders_sp
    WHERE OrderDate BETWEEN @StartDate AND @EndDate;
END;

EXEC ordersbydate @StartDate = '2023-04-01', @EndDate = '2023-04-06';

--18 Write a stored procedure to get total number of customers.

SELECT * FROM Customers_sp;

ALTER PROCEDURE totalcus
AS
BEGIN
	SELECT 
	COUNT (*) AS totalcus
	FROM Customers_sp;
END;

EXEC totalcus;

--19 Write a stored procedure to retrieve the top N most expensive products.

SELECT * FROM Products_sp;

CREATE PROCEDURE topn
AS
BEGIN
	SELECT TOP 2 ProductName
    FROM Products_sp
	ORDER BY Price DESC;
end;

EXEC topn;

--20 Write a stored procedure to update stock quantity after a new order.

SELECT * FROM Products_sp;
SELECT * FROM OrderDetails_sp;

CREATE PROCEDURE UpdateStockAfterOrder
    @OrderID INT
AS
BEGIN
    UPDATE P
    SET P.Stock = P.Stock - OD.Quantity
    FROM Products_sp P
    INNER JOIN OrderDetails_sp OD ON P.ProductID = OD.ProductID
    WHERE OD.OrderID = @OrderID;
END;

EXEC UpdateStockAfterOrder @OrderID = 2;

--21 Write a stored procedure to apply a discount to products in a specific category.

SELECT * FROM Products_sp;

CREATE PROCEDURE discount
	@Category varchar(50), @DiscountPercentage int
AS
BEGIN
	update Products_sp
	SET Price = Price - (Price * @DiscountPercentage / 100)
	where Category = @Category;
END;

EXEC discount @DiscountPercentage = 10, @Category = 'Furniture';

--22 Write a stored procedure to get monthly sales totals for the current year.

SELECT * FROM Orders_sp;

CREATE PROCEDURE salestotal
AS
BEGIN
    SELECT 
        MONTH(OrderDate) AS MonthNumber,
        DATENAME(MONTH, OrderDate) AS MonthName,
        SUM(TotalAmount) AS MonthlySales
    FROM Orders_sp
    WHERE YEAR(OrderDate) = YEAR(GETDATE())  -- Filter for current year
    GROUP BY MONTH(OrderDate), DATENAME(MONTH, OrderDate)
    ORDER BY MonthNumber;
END;

EXEC salestotal;

--23 Write a stored procedure that accepts a category and returns average product price.

SELECT * FROM Products_sp;

CREATE PROCEDURE avgprice
	@Category varchar(100)
AS
BEGIN
	SELECT avg(Price)
    FROM Products_sp
	where Category = @Category;
END;

EXEC avgprice @Category = 'Electronics';

--24 Write a stored procedure to get customers who haven’t placed any orders.

SELECT * FROM Customers_sp;

CREATE PROCEDURE notplacedorder
AS
BEGIN
	SELECT *
    FROM Customers_sp
    WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders_sp);
END;

EXEC notplacedorder;

--25 Write a stored procedure to return the best-selling product.

SELECT * FROM OrderDetails_sp;
SELECT * FROM Products_sp;

CREATE PROCEDURE GetBestSellingProduct
AS
BEGIN
    SELECT TOP 1 p.ProductID, p.ProductName, SUM(od.Quantity) AS totalquantity
    FROM OrderDetails_sp od
    INNER JOIN Products_sp p ON od.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName
    ORDER BY totalquantity DESC;
END;

EXEC GetBestSellingProduct;

--26 Write a stored procedure to calculate revenue generated per product.

CREATE PROCEDURE GetRevenueProduct
@productID int
as 
begin
   select productID , SUM(quantity * unitprice) as revenue from OrderDetails_sp
   WHERE ProductID = @productID 
   GROUP BY ProductID
end;
 
exec GetRevenueProduct @productID = 1;

--27 Write a stored procedure to retrieve top 3 customers by total order value.

SELECT * FROM Customers_sp;
SELECT * FROM Orders_sp;

CREATE PROCEDURE GetTop3CustomerValue
as
begin  
	 select top 3 customerID , SUM(TotalAmount) as value from Orders_sp
	 group by CustomerID
	 order by value desc
end;
 
exec GetTop3CustomerValue;	

--28 Write a stored procedure to insert a new order with order details.

SELECT * FROM Orders_sp;
SELECT * FROM OrderDetails_sp;

ALTER PROCEDURE insertnwew 
    @OrderID INT, @CustomerID INT, @ProductID INT, @Quantity INT, @UnitPrice DECIMAL(10,2), @TotalAmount FLOAT
AS
BEGIN
	INSERT INTO Orders_sp (OrderID, CustomerID, OrderDate, TotalAmount)
    VALUES (@OrderID, @CustomerID, GETDATE(), @TotalAmount);

	INSERT INTO OrderDetails_sp (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
    VALUES (@OrderID * 10+ 1, @OrderID, @ProductID, @Quantity, @UnitPrice);
END;

EXEC insertnwew
    @OrderID = 6,
    @CustomerID = 1,
    @ProductID = 1,
    @Quantity = 1,
    @UnitPrice = 199.99,
	@TotalAmount = 500.00;

--29 Write a stored procedure to archive orders older than 2 years.

SELECT * FROM Orders_sp;

CREATE PROCEDURE oldorders
AS
BEGIN
	select * from Orders_sp
	where orderdate <= dateadd(year, -2, getdate());
END;

EXEC oldorders;

--30 Write a stored procedure to find orders with missing order details.

SELECT * FROM OrderDetails_sp;
SELECT * FROM Orders_sp;

alter PROCEDURE missingorder
AS
BEGIN
	SELECT * FROM Orders_sp
	WHERE OrderID NOT IN ( SELECT DISTINCT OrderID FROM OrderDetails_sp);
END;

EXEC missingorder;

--31 Write a stored procedure to detect and return duplicate customer emails.

SELECT * FROM Customers_sp;

CREATE PROCEDURE duplicate_email
AS
BEGIN
    SELECT Email, COUNT(*) AS DuplicateCount
    FROM Customers_sp
    GROUP BY Email
    HAVING COUNT(*) > 1;
END;

EXEC duplicate_email;

--32 Write a stored procedure to return products that were never ordered.

SELECT * FROM Products_sp;
SELECT * FROM OrderDetails_sp;

CREATE PROCEDURE pronotordered
AS
BEGIN
	SELECT *
    FROM Products_sp
    WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails_sp);
END;

EXEC pronotordered;

--33 Write a stored procedure to calculate average order value per month.

SELECT * FROM Orders_sp;

CREATE PROCEDURE avgordervalue
AS
BEGIN
		SELECT 
        YEAR(OrderDate) AS OrderYear,
        MONTH(OrderDate) AS OrderMonth,
        AVG(TotalAmount) AS AvgOrderValue
		FROM Orders_sp
		GROUP BY YEAR(OrderDate), MONTH(OrderDate)
		ORDER BY OrderYear, OrderMonth;
END;

EXEC avgordervalue;

--34 Write a stored procedure to get all orders for products in a specific category.

SELECT * FROM Products_sp;
SELECT * FROM OrderDetails_sp;
SELECT * FROM Orders_sp;

alter procedure allOrderCategory
@category varchar(20)
as
begin
    SELECT  P.Category ,O.OrderID ,  SUM(OD.Quantity * OD.UnitPrice) as Totalprice from Orders_sp  O
	left join OrderDetails_sp OD ON O.OrderID = OD.OrderID
	JOIN Products_sp P ON OD.ProductID = P.ProductID
	WHERE P.Category = @category
	GROUP BY O.OrderID , P.Category
end;
 
exec allOrderCategory @category = 'Electronics';

--35 Write a stored procedure to generate a sales report by category.

SELECT * FROM Products_sp;
SELECT * FROM OrderDetails_sp;

alter PROCEDURE salesreport
AS
BEGIN
    SELECT  p.Category,  COUNT(DISTINCT od.OrderID) AS TotalOrders, SUM(od.Quantity) AS TotalQuantitySold, SUM(od.Quantity * od.UnitPrice) AS TotalSalesAmount
    FROM OrderDetails_sp od INNER JOIN Products_sp p ON od.ProductID = p.ProductID
    GROUP BY p.Category
    ORDER BY TotalSalesAmount DESC;
END;

EXEC salesreport;

--36 Write a stored procedure to get the customer with the highest order total.

SELECT * FROM Orders_sp;

CREATE PROCEDURE HIGHESTORDERTOTAL
AS
BEGIN
SELECT TOP 1
    CustomerID,
    COUNT(OrderID) AS TotalOrders
	FROM Orders_sp
	GROUP BY CustomerID
	ORDER BY TotalOrders DESC;
END;

EXEC HIGHESTORDERTOTAL;

--37 Write a stored procedure that returns order count by customer with more than 5 orders.

SELECT * FROM Orders_sp;
SELECT * FROM Customers_sp;

ALTER PROCEDURE COUNTCUS
AS
BEGIN
	select c.CustomerID, c.FirstName, c.LastName from Customers_sp c join Orders_sp o on c.CustomerID = o.CustomerID
	GROUP BY c.CustomerID, c.FirstName, c.LastName
    HAVING COUNT(o.OrderID) > 5;
END;

EXEC COUNTCUS;

--38 Write a stored procedure to get top 5 most frequently ordered products.

SELECT * FROM OrderDetails_sp;
SELECT * FROM Products_sp;

alter PROCEDURE frequentlyorder
AS
BEGIN
    SELECT p.ProductID, p.ProductName, p.Category,count (od.ProductID) as product_total ,SUM(od.Quantity) AS totalquantity
    FROM OrderDetails_sp od
    INNER JOIN Products_sp p ON od.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName, p.Category
    ORDER BY product_total DESC;
END;

EXEC frequentlyorder;

--39 Write a stored procedure to track daily stock changes.

--40 Write a stored procedure that returns products where stock < average stock.

CREATE PROCEDURE avgstock
AS
BEGIN
	SELECT * FROM Products_sp
    WHERE Stock < (SELECT AVG(Stock) FROM Products_sp);
END;

EXEC avgstock;

--41 Write a stored procedure that returns a dynamic pivot table showing sales per category per month.

--42 Write a stored procedure that performs bulk insert of products from a temporary staging table.

create  table ProductStaging( productID int, ProductName  varchar(50), Category  varchar(50), Price decimal(10,2), Stock int )

INSERT INTO ProductStaging (ProductID, ProductName, Category, Price, Stock) VALUES 
(121, 'USB Drive', 'Electronics', 600.50, 10),
(122, 'memory card', 'Furniture', 250.00, 5),
(123, 'Monitor', 'Accessories', 2000.00, 100),
(124, 'Mouse', 'Accessories', 65.00, 80);

CREATE procedure StagingTable
as
begin  
	-- Optional: Remove records already existing in main table (ProductID match)
    --DELETE FROM Products_Staging
    --WHERE ProductID IN (SELECT ProductID FROM Products_sp);

    -- Insert new products
    INSERT INTO Products_sp (ProductID, ProductName, Category, Price, Stock)
    SELECT ProductID, ProductName, Category, Price, Stock
    FROM ProductStaging;

    -- Optional: Clear the staging table
    --DELETE FROM Products_Staging;
End;
 
exec StagingTable;
SELECT * FROM Products_sp;
SELECT * FROM ProductStaging;
 
--43 Write a stored procedure that audits changes to the Products table (trigger + log table).

CREATE TABLE ProductAuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY, 
    ProductID INT,                         
    OperationType VARCHAR(20),            
    OldProductName VARCHAR(100),         
    NewProductName VARCHAR(100),          
    OldPrice DECIMAL(10,2),               
    NewPrice DECIMAL(10,2),               
    ChangeDate DATETIME DEFAULT GETDATE() 
);

alter TRIGGER triggeraudit
ON Products_sp
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    -- INSERT operations
    INSERT INTO ProductAuditLog (ProductID, OperationType, NewProductName, NewPrice)
    SELECT i.ProductID,  'INSERT',  i.ProductName, i.Price
    FROM inserted i
    LEFT JOIN deleted d ON i.ProductID = d.ProductID
    WHERE d.ProductID IS NULL;

    -- DELETE operations
    INSERT INTO ProductAuditLog (ProductID, OperationType, OldProductName, OldPrice)
    SELECT  d.ProductID,  'DELETE',  d.ProductName,  d.Price
    FROM deleted d
    LEFT JOIN inserted i ON i.ProductID = d.ProductID
    WHERE i.ProductID IS NULL;

    -- UPDATE operations
    INSERT INTO ProductAuditLog (ProductID, OperationType, OldProductName, NewProductName, OldPrice, NewPrice)
    SELECT  i.ProductID,  'UPDATE',  d.ProductName, i.ProductName,d.Price, i.Price
    FROM inserted i
    INNER JOIN deleted d ON i.ProductID = d.ProductID
    WHERE i.ProductName != d.ProductName OR i.Price != d.Price;
END;

select * from Products_sp;
select * from ProductAuditLog;

INSERT INTO Products_sp (ProductID, ProductName, Category, Price, Stock)
VALUES (5, 'Laptop', 'Electronics', 700.00, 10);

UPDATE Products_sp
SET Price = 750.00
WHERE ProductID = 1;

DELETE FROM Products_sp
WHERE ProductID = 5;

--44 Write a stored procedure that calculates reorder level dynamically based on past 3 months sales.

CREATE procedure dynamicRecorderLevel
   as
    begin
	   create table #RecorderLevel (
	     productID int,
		 productname varchar(20),
		 avgMontlySales  decimal(10,2),
		 reorderLevel decimal(10,2)
	   )
 
	   insert into #RecorderLevel(productID, productname, avgMontlySales, reorderLevel)
	   select P.ProductID ,
	   P.ProductName ,
	   avg(cast(OD.Quantity as decimal(10,2) )) as avgMontlySales , 
	   round(avg(cast(OD.Quantity as decimal(10,2))) * 1.5, 2) as reorderLevel 
	   from Products_sp p
	   JOIN OrderDetails_sp OD ON P.ProductID = OD.ProductID
	   JOIN Orders_sp O ON OD.OrderID = O.OrderID
	   WHERE  O.OrderDate >= DATEADD(MONTH, -3 , GETDATE())
	   group by p.ProductID , p.ProductName ;
 
	     select * from  #RecorderLevel
 
	   end;
 
  exec dynamicRecorderLevel;

--45 Write a stored procedure to generate invoice (with order + customer + product details) in one result.

SELECT * FROM Products_sp;
SELECT * FROM OrderDetails_sp;
SELECT * FROM Orders_sp;
SELECT * FROM Customers_sp;

CREATE procedure InvoiceData
  @customerID int
  as 
  begin
 
with tempt as (
     select OD.OrderID , SUM(OD.Quantity * P.Price) as TotalOrderPrice from OrderDetails_sp OD 
	 FULL OUTER JOIN Products_sp P ON OD.ProductID = P.ProductID
	 GROUP BY OD.OrderID
  )
  SELECT C.CustomerID , CONCAT(C.FirstName , ' ', C.LastName) AS FullName , c.Email, o.OrderID, o.OrderDate, p.ProductID, p.ProductName,  p.Category,  p.Price ,od.Quantity , (OD.Quantity * P.Price) as LineTotal  ,t.TotalOrderPrice FROM Customers_sp C
  FULL OUTER JOIN Orders_sp O ON C.CustomerID = O.CustomerID
  FULL OUTER JOIN OrderDetails_sp OD ON O.OrderID = OD.OrderID
  FULL OUTER JOIN Products_sp P ON OD.ProductID = P.ProductID
  FULL OUTER JOIN tempt T ON O.OrderID = T.OrderID
  where c.CustomerID  is not null and c.CustomerID = @customerID;
end;
 
exec InvoiceData  @customerID = 1;
 

--46 Write a stored procedure that implements pagination for the Orders table (page size, number).

alter PROCEDURE pagination
    @PageNumber INT,
    @PageSize INT
AS
BEGIN

    SELECT *
    FROM Orders_sp
    ORDER BY OrderID
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;

EXEC pagination @PageNumber = 2, @PageSize = 3;


--47 Write a stored procedure that returns top 3 selling products per category.

SELECT * FROM Products_sp;
SELECT * FROM OrderDetails_sp;

ALTER PROCEDURE get_top_3_products_per_category
AS
BEGIN
WITH RankedProducts AS (SELECT p.ProductID,p.ProductName, p.Category, SUM(o.Quantity) AS TotalQuantity,
						ROW_NUMBER() OVER (PARTITION BY p.Category ORDER BY SUM(o.Quantity) DESC) AS rank 
						from Products_sp p join OrderDetails_sp o on p.ProductID = o.ProductID
						group by p.Category, p.ProductID,p.ProductName) 
						select * from RankedProducts
						where rank <= 3;
END;

EXEC get_top_3_products_per_category;

--48 Write a stored procedure that validates all order details for consistency (e.g., price * quantity = subtotal).

SELECT * FROM OrderDetails_sp;
SELECT * FROM Orders_sp;
EXEC validateordertotal;

ALTER PROCEDURE validateordertotal
AS
BEGIN
    SELECT 
        o.OrderID,
        o.TotalAmount AS StoredTotal, 
        SUM(od.Quantity * od.UnitPrice) AS CalculatedTotal, 
        
        CASE 
            WHEN SUM(od.Quantity * od.UnitPrice) = o.TotalAmount THEN 'Valid'
            ELSE 'Mismatch'
        END AS Status

    FROM Orders_sp o
    JOIN OrderDetails_sp od ON o.OrderID = od.OrderID 

    GROUP BY o.OrderID, o.TotalAmount; 
END;

EXEC validateordertotal;

--49 Write a stored procedure to simulate order placement: insert order, deduct stock, return receipt.

--50 Write a stored procedure to predict stockout dates based on order trends (requires historical order data).

