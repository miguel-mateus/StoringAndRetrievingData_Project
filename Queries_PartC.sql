use partc;

-- QUERIES

-- 1. List all the customer’s names, dates, and products or services bought by these customers in a range of two dates
-- "Between range of two dates": We decided to use the dates from the 1st of January of 2020 until the DATETIME we are 
SELECT Client_Name as 'Client Name', Issue_Date as 'Invoice Issue Date',  Product_Name as 'Product Name'
FROM client c, invoice i,  items it, products p
WHERE c.idClient =i.Client_idClient and i.idInvoice = it.Invoice_idInvoice and it.Products_idProducts = p.idProducts and `Issue_Date` > '2020-01-01 00:00:00' and `Issue_Date` < curdate();

-- 2. List the best three customers (Our criteria was the total amount spent on our shop)
SELECT Client_Name as 'Client Name' , SUM(Total_Price) as 'Total Amount Spent'
FROM client c,  invoice i
WHERE c.idClient =i.Client_idClient 
group by c.Client_Name
ORDER BY SUM(Total_Price)  DESC LIMIT 3;

-- 3.Total Sales, Average Sales per Year, Average Sales per month
SELECT CONCAT(EXTRACT(YEAR_MONTH FROM MIN(I.Issue_Date)),' - ', EXTRACT(YEAR_MONTH FROM MAX(I.Issue_Date))) as 'Period of Sales', SUM(I.Total_Price) AS 'TotalSales(euros)',
(SUM(I.Total_Price) / COUNT(DISTINCT YEAR(I.Issue_Date))) as 'YearlyAverage',
(SUM(I.Total_Price) / COUNT(DISTINCT EXTRACT(YEAR_MONTH FROM I.Issue_Date))) as 'MonthlyAverage'
FROM Invoice AS I;

-- 3. (Alternative), instead of considering only the years where we have transactions,
-- we are taking into account consectuive years/months, since the first one where we registered a purchase until the last one
SELECT CONCAT(EXTRACT(YEAR_MONTH FROM MIN(I.Issue_Date)),' - ', EXTRACT(YEAR_MONTH FROM MAX(I.Issue_Date))) as 'Period of Sales', 
SUM(I.Total_Price) AS 'TotalSales(euros)',
(SUM(I.Total_Price) / (YEAR(MAX(I.Issue_Date)) - YEAR(MIN(I.Issue_Date)))) as 'YearlyAverage',
(SUM(I.Total_Price) / (((YEAR(MAX(I.Issue_Date)) - YEAR(MIN(I.Issue_Date)))) * 12 + MONTH(MAX(I.Issue_Date)) - MONTH(MIN(I.Issue_Date)))) as 'MonthlyAverage'
FROM Invoice AS I;

-- 4.Total Sales per City 
SELECT c.City_Name as 'City',
COUNT(i.idInvoice) as 'Total Number of Sales',
SUM(i.Total_Price) as 'Total Value of Sales'
From City c
INNER JOIN  Address as a ON c.idCity = a.City_idCity
INNER JOIN `Client` as cl ON a.idAddress = cl.Address_idAddress
INNER JOIN Invoice as i ON cl.idClient = i.Client_idClient
GROUP BY c.City_Name;

-- 4.1 Total Sales per Country
SELECT co.Country_Name as 'Country',
COUNT(i.idInvoice) as 'Total Number of Sales',
SUM(i.Total_Price) as 'Total Value of Sales'
From Country co
INNER JOIN City as c ON co.idCountry = c.Country_idCountry
INNER JOIN  Address as a ON c.idCity = a.City_idCity
INNER JOIN `Client` as cl ON a.idAddress = cl.Address_idAddress
INNER JOIN Invoice as i ON cl.idClient = i.Client_idClient
GROUP BY co.Country_Name;

-- 5. List all the locations where products/services were sold
SELECT c.City_Name as 'City'
From City c
INNER JOIN  Address as a ON c.idCity = a.City_idCity
INNER JOIN `Client` as cl ON a.idAddress = cl.Address_idAddress
INNER JOIN Invoice as i ON cl.idClient = i.Client_idClient
INNER JOIN Items as it ON i.idInvoice = it.Invoice_idInvoice
WHERE it.Ratings IS NOT NULL
GROUP BY c.City_Name;
