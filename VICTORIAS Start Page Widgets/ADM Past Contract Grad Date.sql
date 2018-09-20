-- original victorias Past Contract grad Date

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', CAST(SDT.firstName AS CHAR), ' ', CAST(SDT.lastName AS CHAR), '</a>') AS Name
,  PGM.programmeName AS 'Program'
,  ROUND(SUM(ATD.duration)) AS 'Total Hours At End Date'
,  PGM.MinClockHours AS 'Program Total'
,  REG.Enddate AS 'EndDate'
,  PGM.overContactAmount AS 'Hours Surcharge'
,  ROUND((PGM.MinClockHours)-(SUM(ATD.duration))) AS 'Surcharge Hours Total'
, CONCAT('$',ROUND((PGM.MinClockHours)-(SUM(ATD.duration))) * PGM.overContactAmount) AS 'Total'

FROM Attendance ATD
INNER JOIN Registrations    REG ON ATD.studentId = REG.studentId AND  REG.isActive = 1
INNER JOIN Programmes       PGM ON REG.programmeId = PGM.programmeId AND  PGM.isActive = 1
INNER JOIN Students         SDT ON REG.studentId = SDT.studentId AND SDT.isactive = 1
INNER JOIN (SELECT SDT.StudentID AS Student 
FROM Attendance ATD 
INNER JOIN  Registrations REG ON ATD.studentId = REG.studentId 
INNER JOIN Students        SDT ON REG.studentId = SDT.studentId AND SDT.isactive = 1
INNER JOIN Programmes       PGM ON REG.programmeId = PGM.programmeId AND  PGM.isActive = 1
AND  REG.isActive = 1
WHERE ATD.attendanceDate >= REG.enddate AND REG.regStatus not like '3' AND REG.regStatus not like '0'   AND PGM.programmename Not like ('Care%%') AND PGM.programmename Not like ('Instructor Training')
Group BY SDT.studentID) as late ON REG.studentId = late.Student
 
 WHERE
    REG.<ADMINID>                        AND
    REG.enrollmentSemesterId = 4000441  AND
	REG.regStatus not like '3' AND REG.regStatus not like '0' AND
     ATD.attendancedate <= REG.enddate AND
    ATD.subjectId IN (SELECT GSR.subjectId
            FROM CourseGroups CGP
            INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
            WHERE REG.programmeId = CGP.programmeId and CGP.isActive=1)
                                        AND
    ATD.classId IN (SELECT DISTINCT CRS.classId
            From ClassStudentReltn CRS
            Where CRS.studentId = ATD.studentId AND CRS.isActive=1)
GROUP BY late.Student
ORDER BY SDT.firstName