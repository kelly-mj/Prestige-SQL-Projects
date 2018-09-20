-- Campus Director Widget: VA by Campus
-- Edit: Kelly MJ 09/13/2018 - changed percent attendance to PFV calculation

SELECT t1.name 'Student Name'
	, IF(t1.percent < 80, CONCAT('<font color="red">',t1.programmeName,'</font>'), t1.programmeName) AS Program
	, IF(t1.percent < 80, CONCAT('<font color="red">',t1.startDate,'</font>'), t1.startDate) AS 'Start Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
	, IF(t1.percent < 80, CONCAT('<font color="red">',t1.percent,'</font>'), t1.percent) AS 'Attendance<br>Percentage'
	, IF(t1.percent < 80, '<font color="red">At Risk</font>', 'Satisfactory') AS 'SAP'

FROM (
	SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS name
		, P.programmeName
		, R.startDate
		, ROUND((SUM(A.duration)/SCH.hours)*100, 2) percent
		, SUM(A.duration) AS attH
		, SCH.hours AS schH
		, S.studentCampus AS Campus

	FROM Registrations R

	INNER JOIN Students S
		ON S.studentId = R.studentId

	INNER JOIN Attendance A
		ON A.studentId = S.studentId
		AND A.attendanceDate >= R.startDate
		AND A.isActive = 1
 
	INNER JOIN (
		SELECT userId
			, fieldValue AS hours
		FROM ProfileFieldValues
		WHERE fieldName = "HOURS_ATTENDED") ATT
		ON ATT.userId = R.studentId

	INNER JOIN (
		SELECT userId
			, fieldValue AS hours
		FROM ProfileFieldValues
		WHERE fieldName = "HOURS_SCHEDULED_FOR_CURRENT_PROGRAM") SCH
		ON SCH.userId = R.studentId

	INNER JOIN ProfileFieldValues PFV
		ON PFV.userId = R.studentId
		AND PFV.fieldName = 'VA_Student' AND PFV.fieldValue = 'TRUE'

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	INNER JOIN (
		SELECT studentId, MAX(startDate) AS maxStartDate
		FROM Registrations WHERE isActive = 1 AND enrollmentSemesterId = 4000441
		GROUP BY studentId) RR
		ON RR.studentId = R.studentId
		AND RR.maxStartDate = R.startDate

	INNER JOIN (
		SELECT studentId, classId
		FROM ClassStudentReltn
		WHERE isActive = 1) CSR
		ON CSR.studentId = R.studentId
	INNER JOIN Classes C
		ON C.classId = CSR.classId
		and C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=R.programmeId and CG.isActive=1 and CG.courseGroupId=GSR.courseGroupId and GSR.isActive=1)

	WHERE R.isActive = 1
		AND R.enrollmentSemesterId = 4000441
		AND S.isActive IN (1, 12)
		AND A.classId = C.classId
		AND S.studentCampus = (SELECT campusCode FROM SubAdmins WHERE <ADMINID> AND subAdminId=[USERID]) 
		AND R.<ADMINID>

	GROUP BY R.studentId
		) t1