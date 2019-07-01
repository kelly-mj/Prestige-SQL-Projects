-- [SHELL] Product Sales
-- Kelly MJ  |  7/1/2019
-- Shows the revenue and inventory count by product and campus for the selected date range.
   -- Enter "aggregate" for campus to show the totals across all campuses
   -- Enter "all" for campus to show the totals per campus for every campus
   -- Enter all or part of campus name to select a specific campus

SELECT t1.Campus
	, t1.Product
    , t1.SKU
    , SUM(t1.Current_Inventory) 'Current Inventory'
    , SUM(t1.Number_Sold) 'Number Sold'
    , CONCAT('$', ROUND(SUM(t1.Total_Revenue), 2)) 'Total Revenue'

FROM (
	SELECT IF('[?Campus]' = 'aggregate', 'All Campuses', C.campusName) AS Campus
		, P.productName AS Product
		, P.skuNumber AS SKU
		, PCR.onHandQuantity AS Current_Inventory
		, SUM(PIT.quantity) AS Number_Sold
		, P.cost*SUM(PIT.quantity) AS Total_Revenue

	FROM ProductInventoryTransactions PIT
	INNER JOIN Campuses C ON C.campusCode = PIT.campusCode
	INNER JOIN Products P ON P.productCode = PIT.productCode
	LEFT JOIN ProductCampusReltn PCR ON PCR.productId = P.productId
		AND PCR.campusId = PIT.campusCode

	WHERE P.productCategory = 'Retail'
	AND PIT.notes = 'product sold'
    AND PIT.isActive = 1
    AND PCR.isActive = 1
    AND PIT.<ADMINID>
    /* user input */
    AND DATE(PIT.transactionDtTm) >= '[?From Date]'
    AND DATE(PIT.transactionDtTm) <= '[?To Date]'
    AND IF('[?Campus]' IN ('', 'aggregate', 'all')
		, P.isActive = 1   /* dummy condition */
        , LOCATE('[?Campus]', C.campusName) > 0)

	GROUP BY PIT.campusCode, PIT.productCode
	ORDER BY C.campusName, P.productName ) t1

GROUP BY t1.Campus, t1.Product
