-- Edited by Kelly MJ
-- 12/12/2018: Date ranges will automatically reset in the following pattern: On even months, the summit period resets for a new 2-month period
   -- (ex: In Feb, the daterange will be 2018-02-01 to 2018-04-01. In Apr, the daterange becomes 2018-04-01 to 2018-06-01, etc.)

SELECT DistinctDate.Name AS 'Student Name'
, SalesData.TotalService AS '# Of Services'
, CONCAT('<div align="right">','$',SalesData.ServiceSUM,'</div>') AS 'Total Services'
, SalesData.TotalRetail  AS '# Of Retail Sales'
, CONCAT('$', SalesData.RetailSum) As 'Total Retail Sales'
, SalesData.TotalGift  AS '# Of GiftCard Sales'
, CONCAT('$', SalesData.GiftSum) As 'Total GiftCard Sales'

FROM

(SELECT SC.studentiD AS SID, COUNT(Distinct CustomerName) AS NewCustomer, Concat(STD.FirstName, '  ', STD.lastName) AS Name,
		COUNT(CustomerName) As TotalCustomer, DATE_FORMAT(SC.creationDtTm, '%Y-%m-%d') AS DATE, CustomerName
		FROM StudentServiceCustomerReltn SC
		INNER JOIN Students STD 
				ON STD.StudentID = SC.studentID
		WHERE SC.creationDTtm AND STD.studentId = [USERID]
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
		GROUP BY STD.studentID,SC.CustomerName, MONTH(SC.creationDTtm), DAY(SC.creationDTtm)) AS DistinctDate

INNER JOIN (SELECT COUNT(Distinct CustomerName) AS NewCustomer, SC.studentiD AS SID, Concat(STD.FirstName, '  ', STD.lastName) AS Name,
			DATE_FORMAT(SC.creationDtTm, '%Y-%m') AS DATE
			FROM StudentServiceCustomerReltn SC
			INNER JOIN Students STD 
					ON STD.StudentID = SC.studentID
			WHERE SC.creationDTtm AND STD.studentId = [USERID]
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
			GROUP BY STD.studentID) AS TotalCustomers ON DistinctDate.SID = TotalCustomers.SID
     
INNER JOIN (SELECT  SC.studentID AS SID
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
			WHERE SC.creationDTtm AND SC.studentId = [USERID]
            -- DATERANGE
			AND CASE
                WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
                WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
                WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
                WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
                ELSE 'error setting daterange'
                END
        -- END DATERANGE
            AND SC.<ADMINID>) AS SalesData ON TotalCustomers.SID = SalesData.SID
GROUP BY DistinctDate.Name