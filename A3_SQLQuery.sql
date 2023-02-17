--1.
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City IN (
SELECT c.City
FROM Customers c
)

--2.subquery
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City NOT IN 
(
SELECT e.City
FROM Employees e
)

--2.no_subquery ----------------------------------------------
SELECT DISTINCT c.City
FROM Customers c JOIN Employees e ON c.City != e.City

--3.
SELECT ProductID, SUM(Quantity) TotalOrder
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

--4.
SELECT City, SUM(oc.SumPerOrder) TotalProducts
FROM (
	SELECT CustomerID, City
	FROM Customers
) c JOIN (
	SELECT o.OrderID, o.CustomerID, SUM(od.Quantity) SumPerOrder
	FROM Orders o JOIN (
		SELECT OrderID, Quantity
		FROM [Order Details]
		) od ON od.OrderID = o.OrderID
	GROUP BY o.OrderID, o.CustomerID
	) oc ON c.CustomerID = oc.CustomerID
GROUP BY City

--5.union
SELECT City, COUNT(CustomerID) NumCustomer
FROM Customers c
GROUP BY City
UNION
SELECT City, COUNT(CustomerID) NumCustomer
FROM Customers c
GROUP BY City

--5.subquery_no_union
SELECT dt.City
FROM (
SELECT City, COUNT(CustomerID) NumCustomer
FROM Customers c
GROUP BY City
) dt
WHERE dt.NumCustomer >= 2

--6.
SELECT dt.City
FROM (SELECT City, COUNT(DISTINCT ProductID) DistProd 
FROM (
SELECT OrderID, ProductID
FROM [Order Details]
) od JOIN (
SELECT OrderID, CustomerID
FROM Orders
) o ON od.OrderID = o.OrderID JOIN (
SELECT CustomerID, City
FROM Customers
) c ON o.CustomerID = c.CustomerID
--WHERE City = 'Madrid'
GROUP BY City
) dt
WHERE dt.DistProd >= 2

--7.
SELECT *
FROM Customers
WHERE CustomerID IN (
SELECT DISTINCT c.CustomerID
FROM (
SELECT CustomerID, City
FROM Customers) c JOIN
(SELECT OrderID, CustomerID, ShipCity
FROM Orders) o ON c.CustomerID = o.CustomerID
WHERE City != ShipCity
)

--8.


--9.subquery


--9.no_subquery

--10.join_subquery

--11.
-- Using GROUP BY, DISTINCT
