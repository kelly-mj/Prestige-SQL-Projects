-- [HWD] KPI - Salon/Clinic - Product Sales
-- Kelly MJ  |  7/25/2019

SELECT CMP.campusName
	, P.productName AS Product
	, FORMAT(PIT.count, 0) AS 'Amount Sold'
	, CONCAT('$', ROUND(PCR.salePrice, 2)) AS 'Price per Unit'
	, CONCAT('$', ROUND(COALESCE(PCR.salePrice*PIT.count, 0), 2)) AS 'Revenue'
	, COALESCE(PCR.onHandQuantity, 'N/A') AS 'Inventory Count'

FROM Products P
JOIN (SELECT campusCode, campusName
		FROM Campuses
		WHERE isActive = 1
		AND IF('[?Campus]' <> ''
				, LOCATE('[?Campus]', campusName) <> 0
				, isActive = 1)) CMP
LEFT JOIN (SELECT * FROM ProductCampusReltn
	 		WHERE isActive = 1) PCR
	ON PCR.productId = P.productId
	AND PCR.campusId = CMP.campusCode
LEFT JOIN (SELECT campusCode
				, productCode
				, COALESCE(COUNT(productInventoryTransactionId), 0) as count
			FROM ProductInventoryTransactions
			WHERE notes = 'product sold'
				AND DATE(transactionDtTm) >= IF('[?From Date]' = '', DATE_FORMAT(CURDATE(), '%Y-%m-01'), '[?From Date]')
				AND DATE(transactionDtTm) <= IF('[?To Date]' = '', CURDATE(), '[?To Date]')
            GROUP BY campusCode, productcode) PIT
	ON PIT.productcode = P.productcode
	AND PIT.campusCode = PCR.campusId

WHERE P.isActive = 1
	AND P.productCategoryId IN (SELECT productCategoryId FROM ProductCategories WHERE name = 'Retail')
	AND P.<ADMINID>

ORDER BY CMP.campusName ASC, PIT.count DESC, P.productName ASC
