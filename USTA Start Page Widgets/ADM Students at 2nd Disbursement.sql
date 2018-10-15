-- ADM Students at 2nd Disbursement
-- Written by Zach or Andrew
-- 10/11/18 Kelly MJ: Added CSR constraint to fix attendance hours, refactored code

SELECT CAST(t1.idNumber AS CHAR) 'Student ID'
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(t1.studentId AS CHAR), '">', t1.studentName, '</a>') 'Name'
	, t1.programmeName 'Program'
	, t1.className 'Class'
	, FORMAT(t1.attHours, 2) 'Hours Attended' 

FROM (
	SELECT R.studentId
		, R.programmeId
		, S.idNumber
		, CONCAT(S.firstName, ' ', S.lastName) AS studentName
		, SUM(A.duration) AS attHours
		, P.programmeName
		, C.className

	FROM Registrations R

	INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId) R2
		ON R2.studentId = R.studentId AND R2.maxDate = R.startDate

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	INNER JOIN Students S
		ON S.studentId = R.studentId
		AND S.isActive = 1

	INNER JOIN ClassStudentReltn CSR
		ON CSR.studentId = R.studentId
	    AND CSR.isActive = 1

	INNER JOIN ProfileFieldValues PFV
		ON PFV.userId = R.studentId
		AND PFV.fieldName = '2ND_DISBURSEMENT'
		AND PFV.fieldValue = 'FALSE'

	INNER JOIN Classes C
		ON C.classId = CSR.classId
	    AND C.isActive=1
	    AND C.startDate <= R.endDate AND C.endDate >= R.startDate
	    and C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=R.programmeId and CG.isActive=1 and CG.courseGroupId=GSR.courseGroupId and GSR.isActive=1)

	INNER JOIN Attendance A
		ON A.studentId = S.studentId
		AND A.attendanceDate >= R.startDate
		AND A.classId = C.classId

	WHERE R.<ADMINID> AND R.isActive = 1
	GROUP BY R.studentId
	) t1

WHERE CASE t1.programmeId
		WHEN 1 THEN t1.attHours BETWEEN 375 AND 450
		WHEN 2 THEN t1.attHours BETWEEN 325 AND 375
		WHEN 3 THEN t1.attHours BETWEEN 375 AND 450
	  END