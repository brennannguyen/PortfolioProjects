--EXPLORATORY DATA ANALYSIS

-- total profit from all cars sold broken up by seller
SELECT seller, SUM(sellingprice) as 'TotalProfit'
FROM PortfolioProject..VehicleSalesData
GROUP BY seller
ORDER BY TotalProfit DESC

-- how many cars each seller sold
SELECT seller, COUNT(vin) AS CarsSold
FROM PortfolioProject..VehicleSalesData
GROUP BY seller
ORDER BY CarsSold DESC

-- how many cars each seller sold per year
SELECT seller, year, COUNT(vin) AS CarsSold
FROM PortfolioProject..VehicleSalesData
GROUP BY seller, year
ORDER BY year, CarsSold DESC

-- Average selling price of each make at each seller with a car year after 2010
SELECT seller, make, COUNT(vin) as 'CarsSold', AVG(sellingprice) as 'AvgSellingPrice'
FROM PortfolioProject..VehicleSalesData
WHERE make IS NOT NULL AND year > 2010
GROUP BY seller, make
ORDER BY seller, CarsSold DESC, make

-- Average Selling Price, HighestSellingPrice, and Lowest Selling Price at each seller
Select DISTINCT seller, AVG(sellingprice) OVER(PARTITION BY seller) AS AvgSellingPrice,
MAX(sellingprice) OVER(PARTITION BY seller) AS HighestSellingPrice,
MIN(sellingprice) OVER(PARTITION BY seller) AS LowestSellingPrice
FROM PortfolioProject..VehicleSalesData
ORDER BY AvgSellingPrice DESC

--USING CTE
WITH CTE_SaleInfo as
(SELECT seller, make, COUNT(vin) as 'CarsSold', AVG(sellingprice) as 'AvgSellingPrice'
FROM PortfolioProject..VehicleSalesData
WHERE make IS NOT NULL 
GROUP BY seller, make
)
SELECT seller, make, CarsSold
FROM CTE_SaleInfo
ORDER BY seller, CarsSold DESC

--USING TEMP TABLE
DROP TABLE IF EXISTS #CarSalesInfo2010
CREATE TABLE #CarSalesInfo2010
(Seller nvarchar(50),
Make nvarchar(50),
CarsSold int,
AvgSellingPrice int)

INSERT INTO #CarSalesInfo2010
SELECT seller, make, COUNT(vin) as 'CarsSold', AVG(sellingprice) as 'AvgSellingPrice'
FROM PortfolioProject..VehicleSalesData
WHERE make IS NOT NULL AND year > 2010
GROUP BY seller, make

Select *
FROM #CarSalesInfo2010
WHERE seller = 'excell auto center'
AND make = 'Jeep'