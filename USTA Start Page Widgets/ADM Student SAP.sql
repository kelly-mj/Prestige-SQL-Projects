-- USTA ADM Student SAP
-- Written by Andrew

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.firstName, ' ', SDT.lastName, '</a>') AS 'Student Name',
PRG.programmeName AS Program,
CMP.campusName AS 'Campus',
Concat( '<div align="center">', CAST(SUM(CLS.lessonDuration) AS dec(10)) ,'</div>') As 'Scheduled Hours',
CAST(SUM(ATD.duration) AS dec(10)) as 'Actual Hours',
CONCAT( '<div align="center">', ROUND(SUM(ATD.duration)/SUM(CLS.lessonDuration)*100,1),'%', '</div>') As 'Attendance Percentage',
CONCAT( '<div align="center">', ROUND(SUM(ATD.duration)/(PRG.minClockHours)*100,1),'%', '</div>') As 'Program Completion' ,
PRG.minClockHours as 'Total Hours'




    
    FROM Registrations REG
INNER JOIN Attendance ATD ON REG.studentId=ATD.studentId AND ATD.isActive=1
INNER JOIN Classes CLS ON ATD.classId = CLS.classId AND CLS.isActive=1
INNER JOIN Students SDT ON REG.studentId = SDT.studentId AND SDT.isActive=1
INNER JOIN Campuses CMP ON SDT.studentCampus = CMP.campusCode AND CMP.isActive=1
INNER JOIN Programmes PRG ON PRG.programmeId = REG.programmeId AND PRG.isActive=1
WHERE
	REG.<ADMINID> AND REG.isActive=1 AND
	REG.enrollmentSemesterId = 4000441 AND
    REG.endDate>=CURDATE() 
   

GROUP BY SDT.studentId
ORDER BY CMP.campusName, SDT.lastName, PRG.programmeName ASC