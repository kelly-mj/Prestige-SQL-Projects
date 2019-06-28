-- Report: All Currently Attending (Active) Students
-- Kelly MJ  |  9/6/2018

SELECT '<strong>Date Report Run: </strong>' AS 'Student ID'
	, CONCAT('<strong>', CURDATE(), '</strong>') 'Student Name'
    , NULL AS 'Course Enrolled'
    , NULL AS 'Contract Start Date'
    , NULL AS '<div style="text-align: left">Scheduled Hours</div>'
    , NULL AS 'Actual Hours Completed'

UNION

SELECT '<strong>Student Count: </strong>'
	, COUNT(t2.Name)
	, NULL, NULL, NULL, NULL
FROM (
	SELECT DISTINCT S.idNumber 'Student ID'
		, CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>') AS Name

	FROM Students S

	INNER JOIN Registrations R
		ON R.studentId = S.studentId
		AND R.enrollmentSemesterId = 4000441

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	INNER JOIN ProfileFieldValues PFV
		ON PFV.userId = S.studentId
	    AND PFV.fieldName = 'HOURS_ATTENDED'

	WHERE S.isActive IN (1, 12)
		AND S.<ADMINID>
		AND S.firstName NOT LIKE '%test%'

	ORDER BY S.lastName ASC
) t2

UNION
SELECT null, null, null, null, null, null
UNION

SELECT t1.* FROM (
	SELECT DISTINCT S.idNumber 'Student ID'
		, CASE
			WHEN S.isActive = 1 THEN CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>')
			WHEN S.isActive = 12 THEN CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), ' (LOA)</a>')
			END AS Name
	    , P.programmeName 'Course Enrolled'              -- program name
	    , DATE_FORMAT(R.startDate, "%m/%d/%Y") 'Contract Start Date'
	    , CAST(P.minClockHours AS CHAR) 'Scheduled Hours'		-- scheduled hours
	    , CONCAT('<div style="text-align: left">', COALESCE(ROUND(SUM(A.duration), 2), 0.00), '</div>') 'Actual Hours Completed'		-- actual hours completed

	FROM Students S

	INNER JOIN Registrations R
		ON R.studentId = S.studentId
		AND R.enrollmentSemesterId = 4000441

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	INNER JOIN ProfileFieldValues PFV
		ON PFV.userId = S.studentId
	    AND PFV.fieldName = 'HOURS_ATTENDED'

	LEFT JOIN Attendance A
	ON A.studentId = S.studentId
    AND A.attendanceDate <= R.endDate
    AND A.attendanceDate >= R.startDate
    AND A.subjectId IN (SELECT GSR.subjectId FROM CourseGroups CG
						INNER JOIN GroupSubjectReltn GSR ON GSR.courseGroupId = CG.courseGroupId
                        WHERE GSR.isActive = 1 AND CG.isActive = 1 AND R.programmeId = CG.programmeId)
	AND A.classId IN (SELECT CSR.classId FROM ClassStudentReltn CSR
					  WHERE CSR.studentId = A.studentId AND CSR.isActive = 1)

	WHERE S.isActive IN (1, 12)
		AND S.<ADMINID>
		AND S.firstName NOT LIKE '%test%'
	GROUP BY S.studentId
	ORDER BY S.lastName ASC
) t1
