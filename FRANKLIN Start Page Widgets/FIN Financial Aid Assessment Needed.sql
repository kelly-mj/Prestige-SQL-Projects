-- FIN Financial Aid Assessment Needed
-- Written by Andrew

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.firstName, ' ', SDT.lastName, '</a>') AS 'Student Name',
(Select PRG.programmeName From Programmes PRG Where PRG.<ADMINID> AND PRG.programmeId = REG.programmeId AND PRG.isActive=1) AS 'Enrolled Program',
	CMP.campusName AS 'Campus',
	CAST(SUM(ATD.duration) AS dec(10)) as 'Hours Attended'

FROM Registrations REG
INNER JOIN Attendance ATD ON REG.studentId=ATD.studentId AND ATD.isActive=1
INNER JOIN Students SDT ON REG.studentId = SDT.studentId AND SDT.isActive=1
INNER JOIN Campuses CMP ON SDT.studentCampus = CMP.campusCode AND CMP.isActive=1
INNER JOIN Classes CLS ON ATD.classId = CLS.classId AND CLS.isActive=1
INNER JOIN ProfileFieldValues PVF ON REG.studentID = PVF.userID AND PVF.isActive=1

WHERE 
        REG.ADMINID AND REG.isActive=1 AND
	REG.endDate>=CURDATE() AND
	REG.enrollmentSemesterId = 4000441 AND
	ATD.attendanceDate>=REG.startDate AND
        PVF.fieldName = 'FINANCIAL_AID_ASSESSMENT' AND
        (PVF.fieldValue IS NULL OR PVF.fieldValue ='FALSE') AND 
 CLS.subjectId IN
		(SELECT subjectId
			FROM CourseGroups CGP
			INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
			WHERE REG.programmeId = CGP.programmeId and CGP.isActive=1)
        	

GROUP BY SDT.studentId, CLS.subjectId
HAVING SUM(ATD.duration) >= 880
