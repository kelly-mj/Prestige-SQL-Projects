-- TCH Students Hours Massage Count Widget
-- 10/2/18  |  Kelly MJ
-- Lists the Theory, Clinic hours attended and massages completed for each student listed  in a teacher's class. Built for Mind Body Institute.

SELECT C.className AS 'Class'
	-- , S.idNumber AS 'Student ID'
	, CONCAT('<a href="https://mbi.orbund.com/einstein-freshair/admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ',   CAST(S.lastName AS CHAR), '</a>') 'Name'
	, CONCAT('<div style="text-align: left;">', FORMAT(TH.duration,2), '</div>') 'Theory Hours Attended'		-- theory hours attended
	, CONCAT('<div style="text-align: left;">', FORMAT(IC.duration,2), '</div>') 'Clinic Hours Attended'		-- IC hours attended
	, CONCAT('<div style="text-align: left;">', COALESCE(SS.massageCount, 0), '</div>') 'Massage Count'						-- massages

FROM Registrations R

INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId) R2
	ON R2.studentId = R.studentId AND R2.maxDate = R.startDate

INNER JOIN Students S
	ON S.studentId = R.studentId
	AND S.isActive = 1

INNER JOIN ClassStudentReltn CSR
	ON CSR.studentId = R.studentId
	AND CSR.isActive = 1

INNER JOIN ClassTeacherReltn CTR
	ON CTR.classId = CSR.classId
	AND CTR.teacherId = [USERID]
	AND CTR.isActive = 1

INNER JOIN Classes C
	ON CSR.classId = C.classId

-- sum of Intern Clinic hours per student
INNER JOIN (
	SELECT A.studentId
		, SUM(A.duration) AS duration
	FROM Attendance A
	INNER JOIN Registrations R ON R.studentId = A.studentId
	INNER JOIN Classes C
		ON C.classId = A.classId
		AND C.isActive = 1
		AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
							WHERE CG.programmeId=R.programmeId AND CG.isActive=1
							AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)
		AND (C.className LIKE '%Intern%' OR C.className LIKE '%IC')
	INNER JOIN ClassStudentReltn CSR ON CSR.studentId = R.studentId AND CSR.classId = C.classId AND CSR.isActive = 1
	GROUP BY R.registrationId	) IC
	ON IC.studentId = R.studentId

-- sum of theory class hours  per student
INNER JOIN (
	SELECT A.studentId
		, SUM(A.duration) AS duration
	FROM Attendance A
	INNER JOIN Registrations R ON R.studentId = A.studentId
	INNER JOIN Classes C
		ON C.classId = A.classId
		AND C.isActive = 1
		AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
							WHERE CG.programmeId=R.programmeId AND CG.isActive=1
							AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)
		AND C.className NOT LIKE '%Intern%' AND C.className NOT LIKE '%IC'
	INNER JOIN ClassStudentReltn CSR ON CSR.studentId = R.studentId AND CSR.classId = C.classId AND CSR.isActive = 1
	GROUP BY R.registrationId	) TH
	ON TH.studentId = R.studentId

-- sum of massages per student
LEFT JOIN (
	SELECT studentId
		, SUM(serviceUnit)/2 as massageCount
	FROM StudentService
	WHERE service LIKE 'M-Massages'
	AND isActive = 1
	GROUP BY studentId	) SS
	ON SS.studentId = R.studentId

WHERE R.<ADMINID>

ORDER BY CSR.classId, SS.massageCount DESC