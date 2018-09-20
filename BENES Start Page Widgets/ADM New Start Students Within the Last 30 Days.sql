-- New Start Students Within the Last 30 Days
-- Author: Kelly MJ   |   5/15/2018
   -- Lists newly started students
-- 5/16/2018: Updated date range from CURDATE() - 30 Days to CURDATE() - 3 Days

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS 'Student Name'
	     , P.programmeName 'Program'
             , R.startDate 'Scheduled Start Date'
     
FROM Students S

INNER JOIN Registrations R
ON R.studentId = S.studentId
AND R.startDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND DATE_SUB(CURDATE(), INTERVAL 2 DAY)
AND NOT R.programmeId IN (4000968, 4000979, 4000983, 4000999, 4001011)

INNER JOIN Programmes P
ON P.programmeId = R.programmeId

LEFT JOIN (
	SELECT ClP.userId
         , MAX(ClP.punchTime) AS lastPunch
	FROM ClockPunches ClP
    GROUP BY ClP.userId
    ) AS CP
ON CP.userId = S.studentId

WHERE CP.lastPunch IS NULL
      AND S.<ADMINID>

GROUP BY S.studentId

ORDER BY R.startDate DESC