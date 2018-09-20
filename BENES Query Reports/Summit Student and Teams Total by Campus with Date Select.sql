-- Created by: Andrew St. George
-- Edited by: Kelly MJ
-- 5/30/2018 update
   -- For "Retail" and "Services", changed "SC.parentcatergory = 'Retail'" to "SC.parentcategory LIKE '%Retail%'"
-- 8/9/2018
   -- added columns for customer count and average services per customer; removed "services performed" column

-- Individual student totals
SELECT
	PFV.fieldValue AS Team  -- Team Name
	, CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ', CAST(S.lastName AS CHAR), '</a>') AS 'Name'
	, COUNT(CASE WHEN SC.parentcategory LIKE '%Retail%' THEN 1 END) AS 'Total Retail'
	, CONCAT('<div align="right">','$',ROUND(SUM(CASE WHEN SC.parentcategory LIKE '%Retail%' THEN SC.tickettotal END),2),'</div>') AS 'Retail Sum'
	, COUNT(CASE WHEN SC.parentcategory LIKE '%Service%' THEN 1 END) AS 'Total Services'
	, CC.customerCount AS 'Customer Count'
	, ROUND(COUNT(CASE WHEN SC.parentcategory LIKE '%Service%' THEN 1 END)/CC.customerCount, 0)  'Avg Services/Customer'
	, CONCAT('<div align="right">','$',ROUND(SUM(CASE WHEN SC.parentcategory LIKE '%Service%' THEN SC.tickettotal END),2),'</div>') AS 'Service Sum'
	, COUNT(CASE WHEN SC.productID = 1215 THEN 1 END) AS 'Total GitfCard'
    , CONCAT('<div align="right">','$',ROUND(SUM(CASE WHEN SC.productID = 1215 THEN SC.ticketTotal END),2),'</div>') AS 'Giftcard Sum'
    , COUNT(CASE WHEN SC.serviceName = 'Pre-Book Next Appointment' THEN 1 END) AS 'PreBooks'
    , COUNT(CASE WHEN SC.serviceName = 'Referral Customer' THEN 1 END) AS 'Referral'
    , COUNT(CASE WHEN SC.serviceName = 'Add On Style' THEN 1 END) AS 'AddOns'

FROM
	StudentServiceCustomerReltn SC

INNER JOIN
	Students S
	ON S.studentId = SC.studentId

INNER JOIN
	ProfileFieldValues PFV
	ON PFV.userId = S.studentId
	AND PFV.fieldName = 'TEAM_NAME'

-- Customer count join
INNER JOIN (
	SELECT
		SC.studentId
		, COUNT(DISTINCT SC.customerId) AS customerCount
	FROM StudentServiceCustomerReltn SC
    INNER JOIN Students S ON S.studentId = SC.studentId
    WHERE SC.creationDtTm BETWEEN '[?Start Date]' AND '[?End Date]'
	  AND (SC.ParentCategory LIKE '%Service%' OR SC.ParentCategory LIKE '%Retail%')
	  AND S.studentCampus = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	GROUP BY SC.studentId
		) CC
	ON CC.studentId = SC.studentId

WHERE
	SC.creationDtTm BETWEEN '[?Start Date]' AND '[?End Date]'
	AND (SC.ParentCategory LIKE '%Service%' OR SC.ParentCategory LIKE '%Retail%')
	AND S.studentCampus = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	AND PFV.FieldValue IS NOT NULL AND PFV.FieldValue != ''
	AND SC.<ADMINID>

GROUP BY
	SC.studentId

UNION

-- Team subtotals
SELECT
	PFV.fieldValue AS Team
	, CONCAT('<b>',' Sub Totals','</b>')   -- 'Name'
	, COUNT(CASE WHEN SC.parentcategory LIKE '%Retail%' THEN 1 END) -- 'Total Retail'
	, CONCAT('<div align="right">','$',ROUND(SUM(CASE WHEN SC.parentcategory LIKE '%Retail%' THEN SC.tickettotal END),2),'</div>') -- 'Retail Sum'
	, COUNT(CASE WHEN SC.parentcategory LIKE '%Service%' THEN 1 END)  -- 'Total Services'
	, Customer.custCount  -- 'Customer Count'
	, ROUND(COUNT(CASE WHEN SC.parentcategory LIKE '%Service%' THEN 1 END)/Customer.custCount, 0)  -- 'Avg Services/Customer'
    , CONCAT('<div align="right">','$',ROUND(SUM(CASE WHEN SC.parentcategory LIKE '%Service%' THEN SC.tickettotal END),2),'</div>')  -- 'Service Sum'
	, COUNT(CASE WHEN SC.productID = 1215 THEN 1 END)  -- 'Total Giftcard'
	, CONCAT('<div align="right">','$',ROUND(SUM(CASE WHEN SC.productID = 1215 THEN SC.ticketTotal END),2),'</div>')  -- 'Giftcard Sum'
	, COUNT(CASE WHEN SC.serviceName = 'Pre-Book Next Appointment' THEN 1 END)  -- 'PreBooks'
	, COUNT(CASE WHEN SC.serviceName = 'Referral Customer' THEN 1 END)  -- 'Referral'
	, COUNT(CASE WHEN SC.serviceName = 'Add On Style' THEN 1 END)  -- 'AddOns'

FROM
	StudentServiceCustomerReltn SC

INNER JOIN
	Students S
	ON S.studentId = SC.studentId

INNER JOIN
	ProfileFieldValues PFV
	ON PFV.userId = SC.studentId
	AND PFV.fieldName = 'TEAM_NAME'

-- Customer count join
INNER JOIN (
	SELECT CC.studentId
		, CC.teamName
        , SUM(CC.customerCount) AS custCount
	FROM (
		SELECT
			SC.studentId
			, COUNT(DISTINCT SC.customerId) AS customerCount
			, PFV.fieldValue AS teamName
		FROM StudentServiceCustomerReltn SC
		INNER JOIN Students S ON S.studentId = SC.studentId
		INNER JOIN ProfileFieldValues PFV ON PFV.userId = SC.studentId AND PFV.fieldName = 'TEAM_NAME'
		WHERE SC.creationDtTm BETWEEN '[?Start Date]' AND '[?End Date]'
		  AND (SC.ParentCategory LIKE '%Service%' OR SC.ParentCategory LIKE '%Retail%')
		  AND S.studentCampus = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
		  AND PFV.FieldValue IS NOT NULL AND PFV.FieldValue != ''
		GROUP BY SC.studentId
		) CC
	GROUP BY CC.teamName
	) Customer
	ON Customer.teamName = PFV.fieldValue

WHERE
	SC.creationDtTm BETWEEN '[?Start Date]' AND '[?End Date]'
	AND (SC.ParentCategory LIKE '%Service%' OR SC.ParentCategory LIKE '%Retail%')
	AND S.studentCampus = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	AND PFV.FieldValue IS NOT NULL AND PFV.FieldValue != ''
	AND SC.<ADMINID>

GROUP BY
	PFV.fieldValue

UNION

-- Team name

SELECT
	PFV.fieldValue AS Team
	, NULL  -- 'Name'
	, NULL  -- 'Total Retail'
	, NULL  -- 'Retail Sum'
	, NULL  -- 'Total Services'
	, NULL  -- 'Customer Count'
	, NULL  -- 'Avg Services/Customer'
	, NULL  -- 'Service Sum'
	, NULL  -- 'Total Giftcard'
	, NULL  -- 'Giftcard Sum'
	, NULL  -- 'PreBooks'
	, NULL  -- 'Referral'
	, NULL  -- 'AddOns'

FROM
	StudentServiceCustomerReltn SC

INNER JOIN
	Students S
	ON S.studentId = SC.studentId

INNER JOIN
	ProfileFieldValues PFV
	ON PFV.userId = SC.studentId
	AND PFV.fieldValue = 'TEAM_NAME'

WHERE
	SC.creationDtTm BETWEEN '[?Start Date]' AND '[?End Date]'
	AND (SC.ParentCategory LIKE '%Service%' OR SC.ParentCategory LIKE '%Retail%')
	AND S.studentCampus = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	AND PFV.FieldValue IS NOT NULL AND PFV.FieldValue != ''
	AND SC.<ADMINID>

ORDER BY
	Team