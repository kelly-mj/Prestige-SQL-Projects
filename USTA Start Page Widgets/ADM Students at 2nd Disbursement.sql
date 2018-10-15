-- ADM Students at 2nd Disbursement
-- Written by Zach or Andrew
-- 10/11/18 Kelly MJ: Added CSR constraint to fix attendance hours, refactored code

SELECT CAST(t1.idNumber AS CHAR) 'Student ID'
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(t1.studentId AS CHAR), '">', t1.studentName, '</a>') 'Name'
	, t1.programmeName 'Program'
	, t1.className 'Class'
	, FORMAT(t1.attHours, 2) 'Hours Attended' 

-- NEXT COLULMNS ARE FOR TESTING PURPOSES
-- First column displays student's attendance hours, program id, and whether their attendance hours are within the second disbursement hours range. Second column links to attendance report and displays supposed class duration.
/* , CONCAT(P.programmeId, '  ', CASE P.programmeId
	WHEN 1 THEN IF(SUM(A.duration) BETWEEN 375 AND 450, 'ELIGIBLE', ' ')
	WHEN 2 THEN IF(SUM(A.duration) BETWEEN 325 AND 375, 'ELIGIBLE', ' ')
	WHEN 3 THEN IF(SUM(A.duration) BETWEEN 375 AND 450, 'ELIGIBLE', ' ')
   END, '  ', PFV.fieldValue) 'ELIGIBLE?'
, CONCAT(C.className, '(', CAST(C.classId AS CHAR), ')&nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="https://usta.orbund.com/einstein-freshair/custom/benes/reports/attendance_history_report.jsp?userId=', CAST(S.studentId AS CHAR), '&userType=1">', CAST(C.lessonDuration AS CHAR), '</a>') 'Class' */

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

-- Following join is for the purpose of adding up scheduled hours
/*INNER JOIN (
	SELECT DISTINCT attendanceDate, DAYOFWEEK(attendanceDate) AS DOW
	FROM Attendance) A
    ON A.attendanceDate <= R.endDate AND A.attendanceDate >= R.startDate
    AND A.attendanceDate <= C.endDate AND A.attendanceDate >= C.startDate
    AND A.DOW IN (SELECT 1+CS.dayNum FROM ClassSchedules CS WHERE CS.classId = CSR.classId)*/
    
WHERE CASE t1.programmeId
		WHEN 1 THEN t1.attHours BETWEEN 375 AND 450
		WHEN 2 THEN t1.attHours BETWEEN 325 AND 375
		WHEN 3 THEN t1.attHours BETWEEN 375 AND 450
	  END