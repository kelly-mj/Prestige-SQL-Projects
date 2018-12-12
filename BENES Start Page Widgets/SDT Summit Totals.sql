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
		WHERE SC.creationDTtm AND STD.studentId = [USERID] AND
		SC.creationDtTm BETWEEN DATE('2018-12-01') AND DATE('2019-01-01') AND 
        (SC.ParentCategory IN ('Service','Retail', '1. Service')) AND SC.<ADMINID>
		GROUP BY STD.studentID,SC.CustomerName, MONTH(SC.creationDTtm), DAY(SC.creationDTtm)) AS DistinctDate

INNER JOIN (SELECT COUNT(Distinct CustomerName) AS NewCustomer, SC.studentiD AS SID, Concat(STD.FirstName, '  ', STD.lastName) AS Name,
			DATE_FORMAT(SC.creationDtTm, '%Y-%m') AS DATE
			FROM StudentServiceCustomerReltn SC
			INNER JOIN Students STD 
					ON STD.StudentID = SC.studentID
			WHERE SC.creationDTtm AND STD.studentId = [USERID]  AND
			SC.creationDtTm BETWEEN DATE('2018-12-01') AND DATE('2019-01-01') AND
            (SC.ParentCategory IN ('Service','Retail', '1. Service')) AND SC.<ADMINID>
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
			WHERE SC.creationDTtm AND SC.studentId = [USERID] AND 
            SC.creationDtTm BETWEEN DATE('2018-12-01') AND DATE('2019-01-01') AND SC.<ADMINID>) AS SalesData ON TotalCustomers.SID = SalesData.SID
GROUP BY DistinctDate.Name