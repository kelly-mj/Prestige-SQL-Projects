-- [TSPA] ADM Active Students in Campus
-- Kelly MJ 05-31-2019: Excluded LOA students

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(STD.studentId AS CHAR), '">', STD.firstName, ' ', STD.lastName, '</a>') AS 'Student Name'
     , (SELECT MAX(campusName) FROM Campuses WHERE campusCode = STD.studentCampus) AS 'Student Campus'
     , (SELECT statusName FROM StatusSequences WHERE statusId = Active.regStatus) AS status
	 , Active.ProgrammeName
     , ROUND(SUM(ATD.duration),2) AS Hours
FROM (Select REG.studentID
		   , REG.regstatus
           , REG.RegistrationID
           , REG.programmeId
           , PRG.ProgrammeName
      FROM Registrations REG
      INNER JOIN Programmes PRG
			  ON REG.ProgrammeID = PRG.ProgrammeID
      WHERE REG.isactive = 1 ORDER BY REG.registrationDate) AS Active
INNER JOIN Attendance ATD ON Active.StudentID = ATD.studentID
INNER JOIN Classes CLS ON CLS.ClassID = ATD.ClassId
INNER JOIN ClassStudentReltn CSR ON CSR.studentID = ATD.studentID AND CLS.classID = CSR.classId
INNER JOIN Students STD ON CSR.StudentID = STD.StudentID
WHERE  CLS.subjectId IN (SELECT subjectId
                         FROM GroupSubjectReltn GSR, CourseGroups CG
						 WHERE CG.programmeId=Active.programmeId
                         AND CG.isActive=1
                         AND CG.courseGroupId=GSR.courseGroupId
                         AND GSR.isActive=1)
    AND ATD.Isactive = 1
    AND CLS.Isactive = 1
    AND CSR.Isactive = 1
    AND Active.regStatus = 1
    AND ATD.<ADMINID>
    AND STD.isActive = 1
GROUP BY Active.RegistrationID
ORDER BY STD.studentCampus DESC,  Active.ProgrammeName , STD.lastname
