-- [TSPA] INS Summit Team Totals
-- Kelly MJ  |  6/9/2019
-- Displays the number of services/customers per student in a teacher's summit team in the current summit period

SELECT 'Summit Period: ' AS 'Team Name'
    , CASE WHEN MONTH(CURDATE()) = 1
            THEN CONCAT('12/01/', YEAR(CURDATE())-1, ' - ', DATE_FORMAT(LAST_DAY(CURDATE()), '%m/%d/%Y'))
        WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10)
            THEN CONCAT(DATE_FORMAT(CURDATE(), '%m/01/%Y - '), DATE_FORMAT(LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH)), '%m/%d/%Y'))
        WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11)
            THEN CONCAT(DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%m/01/%Y - '), DATE_FORMAT(LAST_DAY(CURDATE()), '%m/%d/%Y'))
        WHEN MONTH(CURDATE()) = 12
            THEN CONCAT(DATE_FORMAT(CURDATE(), '%m/01/%Y - '), DATE_FORMAT(LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH)), '%m/%d/%Y'))
        ELSE 'error setting daterange'
        END AS 'Student Name'
    , NULL AS '# Services'
    , NULL AS '# Customers'

UNION
( SELECT PFV.fieldValue AS 'Team Name'
	, CONCAT(S.lastName, ', ', S.firstName) AS 'Student Name' -- student Name
    , COALESCE(SS.serviceCount, 0) AS '# Services'
    , COALESCE(SS.customerCount, 0) AS '# Customers'

FROM Students S
INNER JOIN ProfileFieldValues PFV ON PFV.userId = S.studentId
INNER JOIN ProfileFieldValues TCH ON TCH.fieldValue = PFV.fieldValue
LEFT JOIN ( SELECT studentId, COUNT(DISTINCT serviceId) AS serviceCount, COUNT(DISTINCT customerName) AS customerCount
			FROM StudentService
			WHERE CASE
				WHEN MONTH(CURDATE()) = 1
					THEN DATE(serviceDateTime) BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
				WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10)
					THEN DATE(serviceDateTime) BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
				WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11)
					THEN DATE(serviceDateTime) BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
				WHEN MONTH(CURDATE()) = 12
					THEN DATE(serviceDateTime) BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
				ELSE 'error setting daterange'
				END
			AND isActive = 1
			GROUP BY studentId
	) SS ON SS.studentId = S.studentId

WHERE S.isActive = 1
    AND TCH.fieldName = 'INSTRUCTOR_TEAM_NAME'
    AND TCH.userId = [USERID]
    AND S.<ADMINID>
GROUP BY S.studentId )


UNION
( SELECT NULL
	, '<div style="text-align:left;"><strong>Totals:</strong></div>'
    , CONCAT('<strong>', COALESCE(SUM(SS.serviceCount), 0), '</strong>')
    , CONCAT('<strong>', COALESCE(SUM(SS.customerCount), 0), '</strong>')
FROM Students S
INNER JOIN ProfileFieldValues PFV ON PFV.userId = S.studentId
INNER JOIN ProfileFieldValues TCH ON TCH.fieldValue = PFV.fieldValue
LEFT JOIN ( SELECT studentId, COUNT(DISTINCT serviceId) AS serviceCount, COUNT(DISTINCT customerName) AS customerCount
			FROM StudentService
			WHERE CASE
				WHEN MONTH(CURDATE()) = 1
					THEN DATE(serviceDateTime) BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
				WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10)
					THEN DATE(serviceDateTime) BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
				WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11)
					THEN DATE(serviceDateTime) BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
				WHEN MONTH(CURDATE()) = 12
					THEN DATE(serviceDateTime) BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
				ELSE 'error setting daterange'
				END
			AND isActive = 1
			GROUP BY studentId
	) SS ON SS.studentId = S.studentId

WHERE S.isActive = 1
    AND TCH.fieldName = 'INSTRUCTOR_TEAM_NAME'
    AND TCH.userId = [USERID]
    AND S.<ADMINID> )
