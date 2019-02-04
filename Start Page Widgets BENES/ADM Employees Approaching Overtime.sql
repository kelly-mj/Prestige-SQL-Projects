-- Widget (Admin view): Employees Approaching Overtime
-- Author: Kelly MJ  |  08/16/2018
-- Displays instructors/staff who have accumulated more than 35 hours in the current week.

-- Displays the date range for which the information is being displayed
(SELECT
	'Date range: ' AS 'Staff Name'
	, CASE
		WHEN DAYOFWEEK(CURDATE()) = 7
			THEN CONCAT(DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 6 DAY), '%m/%d/%Y'), ' - ', DATE_FORMAT(CURDATE(), '%m/%d/%Y'))
		WHEN DAYOFWEEK(CURDATE()) = 6
			THEN CONCAT(DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 5 DAY), '%m/%d/%Y'), ' - ', DATE_FORMAT(CURDATE(), '%m/%d/%Y'))
		WHEN DAYOFWEEK(CURDATE()) = 5
			THEN CONCAT(DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 4 DAY), '%m/%d/%Y'), ' - ', DATE_FORMAT(CURDATE(), '%m/%d/%Y'))
		WHEN DAYOFWEEK(CURDATE()) = 4
			THEN CONCAT(DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 3 DAY), '%m/%d/%Y'), ' - ', DATE_FORMAT(CURDATE(), '%m/%d/%Y'))
		WHEN DAYOFWEEK(CURDATE()) = 3
			THEN CONCAT(DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 DAY), '%m/%d/%Y'), ' - ', DATE_FORMAT(CURDATE(), '%m/%d/%Y'))
		WHEN DAYOFWEEK(CURDATE()) = 2
			THEN CONCAT(DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '%m/%d/%Y'), ' - ', DATE_FORMAT(CURDATE(), '%m/%d/%Y'))
		ELSE CONCAT(DATE_FORMAT(CURDATE(), '%m/%d/%Y'), ' - ', DATE_FORMAT(CURDATE(), '%m/%d/%Y'))
		END AS 'Total Hours This Week'
)

UNION

-- Lists employees/their culumative hours
(SELECT allData.TAAname AS 'Staff Name'
    , CASE
        WHEN allData.TAAduration <= 40
            THEN CONCAT('<div>','<font color="black">', allData.TAAduration, '</font>','</div>')
        ELSE CONCAT('<div>','<font color="red">', allData.TAAduration, '</font>','</div>')
        END AS 'Total Hours This Week'

FROM

(SELECT CONCAT(TA.firstName, ' ', TA.lastName) AS TAAname
              , SUM(TAA.duration) AS TAAduration
	
FROM Teachers TA

INNER JOIN
	(SELECT TeacherAttendance.*
          , CASE WHEN DAYOFWEEK(CURDATE()) = 7
					  THEN DATE_SUB(CURDATE(), INTERVAL 6 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 6
					  THEN DATE_SUB(CURDATE(), INTERVAL 5 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 5
					  THEN DATE_SUB(CURDATE(), INTERVAL 4 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 4
					  THEN DATE_SUB(CURDATE(), INTERVAL 3 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 3
					  THEN DATE_SUB(CURDATE(), INTERVAL 2 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 2
					  THEN DATE_SUB(CURDATE(), INTERVAL 1 DAY)
			END as monday
	 FROM TeacherAttendance
     ) AS TAA
ON TAA.teacherId = TA.teacherId
AND TA.isActive = 1
AND TA.<ADMINID>

WHERE TAA.attendanceDate BETWEEN TAA.monday AND CURDATE()
      AND TAA.<ADMINID>
GROUP BY TA.teacherId

UNION

SELECT CONCAT(SA.firstName, ' ', SA.lastName)
             , SUM(SAA.duration) AS SAAduration
	
FROM SubAdmins SA

INNER JOIN
	(SELECT SubAdminAttendance.*
          , CASE WHEN DAYOFWEEK(CURDATE()) = 7
					  THEN DATE_SUB(CURDATE(), INTERVAL 6 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 6
					  THEN DATE_SUB(CURDATE(), INTERVAL 5 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 5
					  THEN DATE_SUB(CURDATE(), INTERVAL 4 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 4
					  THEN DATE_SUB(CURDATE(), INTERVAL 3 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 3
					  THEN DATE_SUB(CURDATE(), INTERVAL 2 DAY)
				 WHEN DAYOFWEEK(CURDATE()) = 2
					  THEN DATE_SUB(CURDATE(), INTERVAL 1 DAY)
			END as monday
	 FROM SubAdminAttendance
         WHERE SubAdminAttendance.<ADMINID>
     ) AS SAA
ON SAA.SubAdminId = SA.SubAdminId
AND SA.isActive = 1

WHERE SAA.attendanceDate BETWEEN SAA.monday AND CURDATE()
      AND SA.<ADMINID>
GROUP BY SA.subAdminId) AS allData

WHERE (allData.TAAduration >= 35))