----AdventureWorks2019
--1.
SELECT COUNT(p.ProductID) AS NumProd
FROM Production.Product p

--2.
SELECT COUNT(p.ProductSubcategoryID) AS NumInSubCate
FROM Production.Product p

--3.
SELECT p.ProductSubcategoryID, COUNT(p.ProductSubcategoryID) AS CountedProducts
FROM Production.Product p
GROUP BY p.ProductSubcategoryID

--4.
SELECT COUNT(*) - COUNT(p.ProductSubcategoryID) AS NumWithoutSubCate
FROM Production.Product p

--5.
SELECT SUM(pin.Quantity) AS ProdSum
FROM Production.ProductInventory pin

--6.
SELECT pin.ProductID, SUM(pin.Quantity) AS TheSum
FROM Production.ProductInventory pin
GROUP BY pin.ProductID

--7.
SELECT dt.Shelf, dt.ProductID, dt.TheSum
FROM (
	SELECT Shelf, ProductID, SUM(Quantity) TheSum, LocationID
	FROM Production.ProductInventory
	GROUP BY Shelf, ProductID, LocationID
) dt
WHERE dt.LocationID = 40 AND dt.TheSum < 100
GROUP BY dt.Shelf, dt.ProductID, dt.TheSum

--8.
SELECT AVG(pin.Quantity) AS AvgQuantity
FROM Production.ProductInventory pin
WHERE pin.LocationID = 10

--9.
SELECT pin.ProductID, pin.Shelf, AVG(pin.Quantity) AS TheAvg
FROM Production.ProductInventory pin
GROUP BY pin.ProductID, pin.Shelf

--10.
SELECT pin.ProductID, pin.Shelf, AVG(pin.Quantity) AS TheAvg
FROM Production.ProductInventory pin
WHERE pin.Shelf != 'N/A'
GROUP BY pin.ProductID, pin.Shelf

--11.
SELECT p.Color, p.Class, COUNT(p.ProductID) AS TheCount, AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p
WHERE p.Color is not null AND p.Class is not null
GROUP BY p.Color, p.Class


--JOINS
--12.
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON sp.CountryRegionCode = cr.CountryRegionCode

--13.
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'Germany' OR cr.Name = 'Canada'


----Northwind DB
--14.
SELECT DISTINCT p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderDate > '1998-02-15'

--15.
SELECT TOP 5 dt.ShipPostalCode
FROM (
	SELECT o.ShipPostalCode, COUNT(p.ProductID) AS ProdSold
	FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID
	GROUP BY o.ShipPostalCode
) dt
ORDER BY dt.ProdSold DESC

--16.
SELECT TOP 5 dt.ShipPostalCode
FROM (
	SELECT o.ShipPostalCode, COUNT(p.ProductID) AS ProdSold
	FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID
	WHERE o.OrderDate > '1998-02-15'
	GROUP BY o.ShipPostalCode
) dt
ORDER BY dt.ProdSold DESC

--17.
SELECT c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c
GROUP BY c.City

--18.
SELECT dt.City, dt.CustomerCount
FROM (
	SELECT c.City, COUNT(c.CustomerID) AS CustomerCount
	FROM Customers c
	GROUP BY c.City
) dt
WHERE dt.CustomerCount > 2

--19.
SELECT DISTINCT c.ContactName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'

--20.
SELECT c.ContactName, MAX(o.OrderDate)
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName;

--21.
SELECT c.ContactName, COUNT(od.ProductID) AS ProdCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName
--ORDER BY ProdCount DESC

--22.
SELECT dt.ContactName, dt.ProdCount
FROM (
	SELECT c.ContactName, COUNT(od.ProductID) AS ProdCount
	FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
	GROUP BY c.ContactName
) dt
WHERE dt.ProdCount > 100

--23.
SELECT DISTINCT supp.CompanyName, ship.CompanyName
FROM Suppliers supp JOIN Products p ON supp.SupplierID = p.SupplierID JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID JOIN Shippers ship ON ship.ShipperID = o.ShipVia
ORDER BY supp.CompanyName

--24.
SELECT DISTINCT o.OrderDate, p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID
ORDER BY o.OrderDate

--25.
SELECT DISTINCT e1.FirstName + ' ' + e1.LastName AS EmployeeNames
FROM Employees e1 INNER JOIN Employees e2 ON e1.Title = e2.Title AND e1.EmployeeID != e2.EmployeeID

--26.
SELECT *
FROM Employees e LEFT JOIN (
	SELECT e1.ReportsTo, COUNT(e2.ReportsTo) NumReport
	FROM Employees e1 LEFT JOIN Employees e2 ON e1.ReportsTo = e2.ReportsTo 
	GROUP BY e1.ReportsTo
) e3 ON e.EmployeeID = e3.ReportsTo
WHERE e.Title LIKE '%manager%' AND e3.ReportsTo > 4
	--was not able to remove duplicates during JOIN, so the count of 'e1.ReportsTo = e2.ReportsTo' data are squared; 2^2 = 4;

--27.
SELECT *
FROM (
	SELECT c.City, c.ContactName, 'Customer' AS [Customer or Supplier]
	FROM Customers c
	UNION
	SELECT s.City, s.ContactName, 'Suppliers' AS [Customer or Supplier]
	FROM Suppliers s
) dt
ORDER BY dt.City
