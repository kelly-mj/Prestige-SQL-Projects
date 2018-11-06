-- TESTING; NOT THE REAL WIDGET
-- INS Summit Team Totals REWORK
-- Kelly MJ  |  Sometime in 2018

-- INDIVIDUAL STUDENT TOTALS
SELECT S.studentId, S.studentName
    , CONCAT('<div align="center">', COALESCE(SD.TotalService, 0), '</div>') '# Of Services'
    , CONCAT('<div align="right">$', FORMAT(COALESCE(SD.ServiceSum, 0), 2), '</div>') 'Total Services'
    , CONCAT('<div align="center">', COALESCE(SD.TotalRetail, 0), '</div>') '# of Retail Sales'
    , CONCAT('<div align="right">$', FORMAT(COALESCE(SD.RetailSum, 0), 2), '</div>') 'Total Retail Sales'
    , COALESCE(C.customerCount, 0)

-- Select all of the students on the user's (teacher's) team
FROM (
	SELECT SDT.studentId
		, CONCAT(SDT.firstName, ' ', SDT.lastName) AS studentName

	FROM ProfileFieldValues PFV
	INNER JOIN (SELECT PFV.fieldValue FROM ProfileFieldValues PFV 
                WHERE PFV.usertype = 3 AND PFV.userID = 4001205
                ) AS t1 
	ON t1.fieldValue = PFV.fieldValue
	INNER JOIN Students SDT
		ON SDT.studentId = PFV.userId

	WHERE PFV.fieldName = 'TEAM_NAME'
	  AND PFV.fieldValue != ''
	  AND PFV.usertype = 1 
	  AND PFV.<ADMINID>
) AS S

-- Count all the unique customers a student has had in the selected time period
-- Exclude any non-sale services/retail (i.e. no money brought it, done on a mannequin, done for theory, sold to Backbar backbar)
LEFT JOIN (
	SELECT COALESCE(COUNT(SC.customerName), 0) AS customerCount
		, SC.studentId

	FROM ( SELECT studentId, customerName FROM StudentServiceCustomerReltn
			WHERE DATE(creationDtTm) BETWEEN '2018-10-01' AND '2018-12-01'					-- Summit period
				AND (parentCategory LIKE '%Service%' OR parentCategory LIKE '%Retail%')		-- Only count service or retail sales
				AND serviceName NOT IN ('%mannequin%', '%sanitation%', '%theory%')
				AND ticketTotal > 0
				AND customerName NOT LIKE '%backbar%'
			GROUP BY customerName, studentId) SC

	GROUP BY SC.studentId ) AS C
ON C.studentId = S.studentId

-- Count all the services done by a student and sum all the money brought in by each student in the selected time period
-- Exclude any non-sale services/retail (i.e. no money brought it, done on a mannequin, done for theory, sold to Backbar backbar)
LEFT JOIN (
	SELECT SC.studentId
		, COUNT(CASE WHEN SC.parentcategory = 'Retail' THEN 1 END) AS TotalRetail 
		, SUM(CASE WHEN SC.parentcategory = 'Retail' THEN SC.tickettotal END) AS RetailSum
		, COUNT(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN 1 END) AS TotalService
		, SUM(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN SC.tickettotal END) AS ServiceSum

	FROM StudentServiceCustomerReltn SC

	WHERE SC.creationDtTm BETWEEN DATE('2018-10-01') AND DATE('2018-12-01')
		AND (parentCategory LIKE '%Service%' OR parentCategory LIKE '%Retail%')
		AND serviceName NOT IN ('%mannequin%', '%sanitation%', '%theory%')
		AND ticketTotal > 0
		AND customerName NOT LIKE '%backbar%'

	GROUP BY SC.studentID ) AS SD		-- SalesData
ON S.studentId = SD.studentId

GROUP BY S.studentId

/*
-- Overall team totals
UNION
 SELECT NULL, NULL, NULL, NULL, NULL, NULL
UNION
SELECT DistinctDate.FieldValue
, CONCAT('<div align="center">',SalesData.TotalService,'</div>')
, CONCAT('<div align="right">','$',ROUND(SalesData.ServiceSum,2),'</div>')
, CONCAT('<div align="center">',SalesData.TotalRetail,'</div>')
, CONCAT('<div align="right">','$',ROUND(SalesData.RetailSum,2),'</div>')
, CONCAT('<div align="center">',DistinctDate.TotalCustomer,'</div>')



FROM( SELECT COUNT(Distinct CustomerName) AS TotalCustomers,
		COUNT(CustomerName) As TotalCustomer, PFV.fieldValue
	FROM ProfileFieldValues PFV
	INNER JOIN StudentServiceCustomerReltn SC 
			ON PFV.UserID = SC.studentID
	INNER JOIN  (SELECT PFV.usertype as UT, PFV.userID, PFV.fieldValue AS FV  
			       FROM ProfileFieldValues PFV 
                               WHERE PFV.usertype = 3 AND PFV.userID = 4001205) AS t1 ON t1.FV = PFV.fieldValue 
        WHERE FieldName = 'TEAM_NAME' and PFV.fieldValue != '' AND PFV.usertype != 3 AND SC.creationDtTm BETWEEN DATE('2018-10-01') AND DATE('2018-12-01')  AND
            (SC.ParentCategory IN ('Service','Retail', '1. Service')) AND SC.<ADMINID>
        GROUP BY FieldValue) AS DistinctDate

INNER JOIN (SELECT  PFV.fieldValue
			, COUNT(CASE WHEN SC.parentcategory = 'Retail' THEN 1 END) AS TotalRetail 
			, SUM(CASE WHEN SC.parentcategory = 'Retail' THEN SC.tickettotal END) AS RetailSum
			, COUNT(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN 1 END) AS TotalService
			, SUM(CASE WHEN SC.parentcategory IN ('Service', '1. Service') THEN SC.tickettotal END) AS ServiceSum
            FROM StudentServiceCustomerReltn SC
            INNER JOIN ProfileFieldValues PFV 
					ON PFV.userID = SC.StudentID
			WHERE
            SC.creationDtTm BETWEEN DATE('2018-10-01') AND DATE('2018-12-01') AND FieldName = 'TEAM_NAME'
            GROUP BY PFV.fieldvalue) AS SalesData ON DistinctDate.fieldValue = SalesData.fieldValue

GROUP BY DistinctDate.FieldValue
*/

/*
TEAM SBERS OF 'The Elite Squad'
-- userId IN (4043922, 4046149, 4046367, 4046445, 4046854, 4046870 ,4046886 ,4046935 ,4046955 ,4047002 ,4047424 ,4047616 ,4047658 ,4047695 ,4047746 ,4047982 ,4047996 ,4048013 ,4048042)
*/

/* ** finding sc records for each student in the elite squad
 SELECT SC.*
 FROM StudentServiceCustomerReltn SC
 WHERE SC.studentId IN (4043922, 4046149, 4046367, 4046445, 4046854, 4046870 ,4046886 ,4046935 ,4046955 ,4047002 ,4047424 ,4047616 ,4047658 ,4047695 ,4047746 ,4047982 ,4047996 ,4048013 ,4048042)
 AND SC.creationUpdateDtTm BETWEEN '2018-10-01' AND '2018-12-30'