-- Developer: Zachary Bene
-- Version 1.0
-- Updated 03/30/2017
-- All Active Students From Attendance
-- The purpose of this query is to show
	-- all active students who appear on the attendance record

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
	, P.programmeName
	, R.startDate 'Dates'
	, FORMAT(SUM(A.duration), 2) AS 'Hours Attended'

FROM Students S

INNER JOIN Registrations R ON R.studentId = S.studentId AND R.isActive = 1
INNER JOIN Programmes P ON P.programmeId = R.programmeId
INNER JOIN Attendance A ON A.studentId = S.studentId AND A.isActive

WHERE S.<ADMINID>
	AND S.isActive = 1
	AND R.regStatus = 1
	AND A.subjectId IN (SELECT GSR.subjectId
			FROM CourseGroups CGP
			INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
			WHERE R.programmeId = CGP.programmeId and CGP.isActive=1)
	AND A.classId IN (SELECT DISTINCT CRS.classId
			From ClassStudentReltn CRS
			Where CRS.studentId = A.studentId AND CRS.isActive=1)
GROUP BY S.studentId