-- SBD ADM Student SAP
-- Kelly MJ  |  12/31/2018

/*
 *	Students who have accumulated over 400 scheduled hours
 */

SELECT '<strong>Over 400 Scheduled Hours</strong>' AS 'Name'
	, NULL 'Program'
	, NULL 'Sch.<br>Hours'
	, NULL 'Actual<br>Hours'
	, NUll 'Att %'
	, NULL 'Program<br>Completion'
	, NULL 'Program<br>Hours'

UNION (
SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.lastName, ', ', SDT.firstName, '</a>') AS 'Name'
	, PRG.programmeName AS Program
	, SCH.fieldValue AS 'Sch. Hours'
	, CAST(SUM(ATD.duration) AS dec(10)) as 'Actual Hours'
	, CONCAT( '<div align="center">', ROUND(SUM(100*ATD.duration)/SCH.fieldValue, 0),'%', '</div>') As 'Att %'
	, CONCAT( '<div align="center">', ROUND(SUM(ATD.duration)/(PRG.minClockHours)*100, 0),'%', '</div>') As 'Program<br>Completion'
	, PRG.minClockHours as 'Program<br>Hours'

FROM Registrations REG

INNER JOIN Attendance ATD
	ON REG.studentId=ATD.studentId AND ATD.isActive=1

INNER JOIN ProfileFieldValues SCH
	ON SCH.userId = REG.studentId
	AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'
	AND SCH.isActive = 1

INNER JOIN Students SDT
	ON REG.studentId = SDT.studentId AND SDT.isActive=1

INNER JOIN Programmes PRG
	ON PRG.programmeId = REG.programmeId AND PRG.isActive=1

WHERE REG.<ADMINID> AND REG.isActive=1
AND REG.enrollmentSemesterId = 4000441
AND REG.endDate>=CURDATE()
AND SCH.fieldValue >= 400
AND SCH.fieldValue < 800

GROUP BY SDT.studentId
ORDER BY SDT.lastName, PRG.programmeName ASC )

/*
 *	Students who have acculmulated over 800 scheduled hours
 */
UNION
SELECT '<strong>Over 800 Scheduled Hours</strong>' AS 'Name', NULL, NULL, NULL, NULL, NULL, NULL

UNION (
SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.lastName, ', ', SDT.firstName, '</a>') AS 'Name'
	, PRG.programmeName AS Program
	, SCH.fieldValue AS 'Sch. Hours'
	, CAST(SUM(ATD.duration) AS dec(10)) as 'Actual Hours'
	, CONCAT( '<div align="center">', ROUND(SUM(100*ATD.duration)/SCH.fieldValue, 0),'%', '</div>') As 'Att %'
	, CONCAT( '<div align="center">', ROUND(SUM(ATD.duration)/(PRG.minClockHours)*100, 0),'%', '</div>') As 'Program<br>Completion'
	, PRG.minClockHours as 'Program<br>Hours'

FROM Registrations REG

INNER JOIN Attendance ATD
	ON REG.studentId=ATD.studentId AND ATD.isActive=1

INNER JOIN ProfileFieldValues SCH
	ON SCH.userId = REG.studentId
	AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'
	AND SCH.isActive = 1

INNER JOIN Students SDT
	ON REG.studentId = SDT.studentId AND SDT.isActive=1

INNER JOIN Programmes PRG
	ON PRG.programmeId = REG.programmeId AND PRG.isActive=1

WHERE REG.<ADMINID> AND REG.isActive=1
AND REG.enrollmentSemesterId = 4000441
AND REG.endDate>=CURDATE()
AND SCH.fieldValue >= 400

GROUP BY SDT.studentId
ORDER BY SDT.lastName, PRG.programmeName ASC )