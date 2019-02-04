-- Daily Hour Shortage
-- Written by: Kelly MJ    |    Created: 7/16/2018
   -- Displays missing sessions for MBI students. Session 1 attendance is 9:00a - 10:15a; Session 2 attendance is 10:15a - 1:30p

SELECT S.studentId AS 'Student ID', CONCAT(S.firstName, ' ', S.lastName) 'Name'
            -- , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ', CAST(S.lastName AS CHAR), '</a>') AS Name
             , CP.punchDate
             , CP.inTime
             , CP.outTime

FROM Students S

INNER JOIN 	(
	SELECT C.userId
		 , TIME(MIN(C.punchTime)) AS inTime
         , TIME(MAX(C.punchTime)) AS outTime
         , C.punchTime
         , DATE_FORMAT(DATE(C.punchTime), "%a, %M %e") AS punchDate
    FROM ClockPunches C
    WHERE DATE(C.punchTime) > '07-10-2018'
    GROUP BY C.userId, DATE(C.punchTime)
) CP
ON CP.userId = S.studentId

WHERE S.<ADMINID>

ORDER BY CP.punchTime DESC
