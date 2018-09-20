-- Developer: Zachary Bene 
-- Version 1.1
-- Created 03/20/2017
-- Leave of Absence List for Campus Director

-- the purpose of this query is to show
	-- students who are on leave
	-- students who returned less that 5 days ago

SELECT
	SDT.idNumber AS ID_Number,
	CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', CAST(SDT.firstName AS CHAR), ' ', CAST(SDT.lastName AS CHAR), '</a>') AS Name,
	DATE_FORMAT(LOA.leaveDate, '%m-%d-%Y') AS Leave_Date,
	DATE_FORMAT(LOA.expectedReturnDate, '%m-%d-%Y') AS Expected_Return_Date,
	DATE_FORMAT(LOA.returnDate, '%m-%d-%Y') AS Actual_Return_Date

FROM Registrations REG
	JOIN Students SDT ON REG.studentId = SDT.studentId AND NOT SDT.isActive = 0
	JOIN ClassStudentReltn CSR ON SDT.studentId = CSR.studentId AND NOT CSR.isActive = 0
	JOIN Classes CLS ON CSR.classId = CLS.classId AND NOT CLS.isActive = 0
	JOIN LeavesOfAbsence LOA ON SDT.studentId = LOA.studentId AND NOT LOA.isActive = 0
	JOIN SubAdmins SAN ON SDT.studentCampus = SAN.campusCode AND NOT SAN.isActive = 0
	
WHERE
	REG.<ADMINID> AND NOT REG.isActive = 0 	AND
	REG.enrollmentSemesterId = 4000441		AND
	CURDATE() > LOA.leaveDate				AND
	LOA.returnDate IS NULL					AND
	SAN.subAdminId = [USERID]				AND
	CLS.subjectId IN (SELECT GSR.subjectId
				FROM CourseGroups CGP
				INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
				WHERE REG.programmeId = CGP.programmeId and CGP.isActive = 1)
	OR
	REG.<ADMINID> AND NOT REG.isActive = 0 			AND
	REG.enrollmentSemesterId = 4000441				AND
	CURDATE() > LOA.leaveDate						AND
	LOA.returnDate > (CURDATE() - INTERVAL 15 DAY)	AND
	SAN.subAdminId = [USERID]						AND
	CLS.subjectId IN (SELECT GSR.subjectId
				FROM CourseGroups CGP
				INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
				WHERE REG.programmeId = CGP.programmeId and CGP.isActive = 1)			

GROUP BY LOA.expectedReturnDate, ID_Number -- this is to resolve double entry problems
ORDER BY SDT.firstName, SDT.lastName
