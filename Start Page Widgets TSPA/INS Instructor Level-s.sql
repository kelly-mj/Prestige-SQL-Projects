-- INS Summit Team Totals REWORK
-- Kelly MJ  |  Sometime in 2018

-- Individual student totals
SELECT Name
	, CONCAT('<div align="center">',SalesData.TotalService,'</div>')  AS '# Of Services'
	, CONCAT('<div align="center">','$',ROUND(SalesData.ServiceSUM,2),'</div>') AS 'Total Services'
	, CONCAT('<div align="center">',SalesData.TotalRetail,'</div>')  AS '# Of Retail Sales'
	, CONCAT('<div align="center">','$',ROUND(SalesData.RetailSum,2),'</div>') As 'Total Retail Sales'
	, CONCAT('<div align="center">',Customers.CustomerCount,'</div>')  AS '# Of Customers'
	, CONCAT('<div align="center">',SalesData.Prebook,'</div>')  AS '# Of Prebooks'


FROM( SELECT SC.studentiD AS SID
		   , COUNT(DISTINCT CustomerName) AS TotalCustomers
		   , Concat(STD.FirstName, '  ', STD.lastName) AS Name
		   , COUNT(CustomerName) As TotalCustomer
		   , DATE_FORMAT(SC.creationDtTm, '%Y-%m-%d') AS DATE
		   , CustomerName

	FROM ProfileFieldValues PVF

	INNER JOIN Students STD
			ON PVF.UserID = STD.StudentID

	INNER JOIN StudentServiceCustomerReltn SC
			ON STD.StudentID = SC.studentID

	INNER JOIN  (SELECT PVF.usertype as UT
					  , PVF.userID, PVF.fieldValue AS FV
			       FROM ProfileFieldValues PVF
                   WHERE PVF.usertype = 3
                     AND PVF.userID = [USERID]
                ) AS t1
	ON t1.FV = PVF.fieldValue

	WHERE FieldName = 'TEAM_NAME'
	  AND PVF.fieldValue != ''
	  AND PVF.usertype != 3
	  -- DATERANGE
	  AND CASE
        WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        ELSE 'error setting daterange'
		END
	  -- END DATERANGE
	  AND SC.ParentCategory IN ('Service','Retail', '1. Service')
	  AND SC.<ADMINID>

	GROUP BY STD.studentID
		   , SC.CustomerName
		   , MONTH(SC.creationDTtm)
		   , DAY(SC.creationDTtm)
) AS DistinctDate

INNER  JOIN (
	SELECT COUNT(Distinct CustomerName) AS NewCustomer
		, SC.studentiD AS SID
		, DATE_FORMAT(SC.creationDtTm, '%Y-%m') AS DATE

	FROM StudentServiceCustomerReltn SC
	INNER JOIN Students STD
		ON STD.StudentID = SC.studentID
	-- DATERANGE
	WHERE CASE
        WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        ELSE 'error setting daterange'
        END
	-- END DATERANGE
	AND SC.ParentCategory IN ('Service','Retail', '1. Service')
	GROUP BY STD.studentID
) AS NewCustomers ON NewCustomers.SID = DistinctDate.SID

INNER JOIN (
	SELECT COUNT(SC.customerName) AS CustomerCount
		, SC.studentId AS SID
	FROM StudentServiceCustomerReltn SC
	-- DATERANGE
	WHERE CASE
        WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        ELSE 'error setting daterange'
        END
	-- END DATERANGE
    AND (SC.ParentCategory = 'Retail' OR SC.parentcategory = 'Service')
	GROUP BY SC.studentID
) AS Customers ON Customers.SID = DistinctDate.SID

INNER JOIN (
	SELECT  SC.studentID AS SID
		, COUNT(CASE WHEN SC.parentcategory = 'Retail' THEN 1 END) AS TotalRetail
		, SUM(CASE WHEN SC.parentcategory = 'Retail' THEN SC.tickettotal END) AS RetailSum
		, COUNT(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN 1 END) AS TotalService
		, SUM(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN SC.tickettotal END) AS ServiceSum
		, COUNT(CASE WHEN SC.productID = 1215 THEN 1 END) AS TotalGift
		, SUM(CASE WHEN SC.productID = 1215 THEN SC.ticketTotal END) AS GiftSum
		, COUNT(CASE WHEN SC.serviceName = 'Pre-Book Next Appointment' THEN 1 END) AS PreBook
		, COUNT(CASE WHEN SC.serviceName = 'Referral Customer' THEN 1 END) AS Referral
		, COUNT(CASE WHEN SC.serviceName = 'Add On Service' THEN 1 END) AS AddOn
	FROM StudentServiceCustomerReltn SC
	-- DATERANGE
	WHERE CASE
        WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        ELSE 'error setting daterange'
        END
	-- END DATERANGE
	GROUP BY SC.studentID
) AS SalesData ON NewCustomers.SID = SalesData.SID

GROUP BY NewCustomers.SID

-- Overall team totals
UNION
 SELECT NULL, NULL, NULL, NULL, NULL, NULL ,NULL
UNION
SELECT DistinctDate.FieldValue
, CONCAT('<div align="center">',SalesData.TotalService,'</div>')
, CONCAT('<div align="center">','$',ROUND(SalesData.ServiceSum,2),'</div>')
, CONCAT('<div align="center">',SalesData.TotalRetail,'</div>')
, CONCAT('<div align="center">','$',ROUND(SalesData.RetailSum,2),'</div>')
, CONCAT('<div align="center">',DistinctDate.TotalCustomer,'</div>')
, CONCAT('<div align="center">',SalesData.Prebook,'</div>')


FROM( SELECT COUNT(Distinct CustomerName) AS TotalCustomers,
		COUNT(CustomerName) As TotalCustomer, PVF.fieldValue
	FROM ProfileFieldValues PVF
	INNER JOIN StudentServiceCustomerReltn SC
			ON PVF.UserID = SC.studentID
	INNER JOIN  (SELECT PVF.usertype as UT, PVF.userID, PVF.fieldValue AS FV
			       FROM ProfileFieldValues PVF
                               WHERE PVF.usertype = 3 AND PVF.userID = [USERID]) AS t1 ON t1.FV = PVF.fieldValue
        WHERE FieldName = 'TEAM_NAME' and PVF.fieldValue != '' AND PVF.usertype != 3
        -- DATERANGE
        AND CASE
        WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
        WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
        ELSE 'error setting daterange'
        END
        -- END DATERANGE
        AND (SC.ParentCategory IN ('Service','Retail', '1. Service')) AND SC.<ADMINID>
        GROUP BY FieldValue) AS DistinctDate

INNER JOIN (SELECT  PVF.fieldValue
			, COUNT(CASE WHEN SC.parentcategory = 'Retail' THEN 1 END) AS TotalRetail
			, SUM(CASE WHEN SC.parentcategory = 'Retail' THEN SC.tickettotal END) AS RetailSum
			, COUNT(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN 1 END) AS TotalService
			, SUM(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN SC.tickettotal END) AS ServiceSum
			, COUNT(CASE WHEN SC.serviceName = 'Pre-Book Next Appointment' THEN 1 END) AS PreBook
            FROM StudentServiceCustomerReltn SC
            INNER JOIN ProfileFieldValues PVF
					ON PVF.userID = SC.StudentID
			-- DATERANGE
	        WHERE CASE
		        WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
		        WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
		        WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
		        WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
		        ELSE 'error setting daterange'
		        END
            -- END DATERANGE
            AND FieldName = 'TEAM_NAME'
            GROUP BY PVF.fieldvalue) AS SalesData ON DistinctDate.fieldValue = SalesData.fieldValue

GROUP BY DistinctDate.FieldValue
