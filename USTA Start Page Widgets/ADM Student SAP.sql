-- USTA ADM Student SAP
-- Written by Andrew
-- Edited by Kelly MJ  |  12/18/2018

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS 'Student Name'
	, P.programmeName AS Program
	, SCH.fieldValue AS 'Sch. Hours'
	, ATT.fieldValue AS 'Actual Hours'
	, CONCAT( '<div align="center">', ROUND(ATT.fieldValue/SCH.fieldValue*100, 1),'%', '</div>') As 'Attendance Percentage'
	, CONCAT( '<div align="center">', ROUND(ATT.fieldValue/P.minClockHours*100,1),'%', '</div>') As 'Program Completion'
	, P.minClockHours as 'Program Hours'
    
FROM Registrations R

INNER JOIN Attendance A
	ON R.studentId=A.studentId
	AND A.isActive=1

INNER JOIN Students S
	ON R.studentId = S.studentId
	AND S.isActive=1

INNER JOIN Programmes P
	ON P.programmeId = R.programmeId
	AND P.isActive=1

INNER JOIN ProfileFieldValues SCH
	ON SCH.userId = S.studentId
	AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'

INNER JOIN ProfileFieldValues ATT
	ON ATT.userId = S.studentId
	AND ATT.fieldName = 'PROGRAM_HOURS_ATTENDED'

WHERE R.<ADMINID>
AND R.isActive = 1
AND R.enrollmentSemesterId = 4000441
AND R.endDate >= CURDATE() 

GROUP BY S.studentId

ORDER BY P.programmeName, S.lastName