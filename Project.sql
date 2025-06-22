CREATE DATABASE project;
USE project;



# top 5 customers based on total puchase
SELECT
    C.CustomerName,
    SUM(S.Sales_Amount) AS TotalPurchase
FROM Sales_Data S
JOIN Customer_Data C ON S.CustomerID = C.CustomerID
GROUP BY C.CustomerName
ORDER BY TotalPurchase DESC
LIMIT 5;
    
    
#Products with >20% discount but positive profit

SELECT
    P.ProductName,
    S.Sales_Amount,
    S.`Discount (%)` AS DiscountPercentage,
    S.Profit
FROM Sales_Data S
JOIN Product_Data P ON S.ProductID = P.ProductID
WHERE S.`Discount (%)` > 20 AND S.Profit > 0
LIMIT 0, 1000;
    
    
#Region-wise average discount

SELECT
    Region,
    AVG(`Discount (%)`) AS AverageDiscount 
FROM Sales_Data
GROUP BY Region;
    
select * from Sales_data;

## Year-wise sales growth %
WITH YearlySales AS (
    SELECT
        YEAR(OrderDate) AS SalesYear,
        SUM(Sales_Amount) AS TotalSales
    FROM Sales_Data
    GROUP BY YEAR(OrderDate)
)
SELECT
    YS_Current.SalesYear,
    YS_Current.TotalSales,
    YS_Previous.TotalSales AS PreviousYearSales,
    CASE
        WHEN YS_Previous.TotalSales IS NULL THEN NULL
        WHEN YS_Previous.TotalSales = 0 THEN NULL
        ELSE ((YS_Current.TotalSales - YS_Previous.TotalSales) * 100.0 / YS_Previous.TotalSales)
    END AS SalesGrowthPercentage
FROM
    YearlySales YS_Current
LEFT JOIN
    YearlySales YS_Previous ON YS_Current.SalesYear = YS_Previous.SalesYear + 1
ORDER BY
    YS_Current.SalesYear;

# Product catagory with highest margin profit

SELECT
    P.Category,
    SUM(S.Profit) AS TotalProfit,
    SUM(S.Sales_Amount) AS TotalSales,
    (SUM(S.Profit) / SUM(S.Sales_Amount)) AS ProfitMargin
FROM Sales_Data S
JOIN Product_Data P ON S.ProductID = P.ProductID
GROUP BY P.Category
ORDER BY ProfitMargin DESC
LIMIT 1;

# AOV per customer segment
SELECT
    C.CustomerSegment,
    SUM(S.Sales_Amount) AS TotalSales,
    COUNT(DISTINCT S.OrderID) AS TotalOrders,
    SUM(S.Sales_Amount) / COUNT(DISTINCT S.OrderID) AS AverageOrderValue
FROM Sales_Data S
JOIN Customer_Data C ON S.CustomerID = C.CustomerID
GROUP BY C.CustomerSegment
ORDER BY AverageOrderValue DESC;


