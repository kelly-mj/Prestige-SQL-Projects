-- [FRANKLIN] COE Report
-- Kelly MJ  |  7/1/2019

(SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.studentId AS CHAR), '</a>') AS Name
	, S.lastName
	, S.firstName
    , SUBSTRING(S.ssn, 8, 12) 'Last 4 of SSN#'
    , DATE_FORMAT(R.startDate, '%m/%d/%Y') 'Enrollment Date'
    , SUBSTRING(P.programmeName, 1, 1) 'Course of Study'
    , COALESCE(ROUND(SUM(CASE WHEN A.attendanceDate <  CONCAT('[?Year (YYYY)]-', '[?Month (MM)]', '-01') THEN A.duration END), 1), 0) 'Hours Passed Last Month'
    , COALESCE(ROUND(SUM(CASE WHEN A.attendanceDate >= CONCAT('[?Year (YYYY)]-', '[?Month (MM)]', '-01')
					 AND A.attendanceDate <= LAST_DAY(CONCAT('[?Year (YYYY)]-', '[?Month (MM)]', '-01'))
						THEN A.duration END), 1), 0) 'Hours Passed This Month'
    , COALESCE(ROUND(SUM(CASE WHEN A.attendanceDate <=  LAST_DAY(CONCAT('[?Year (YYYY)]-', '[?Month (MM)]', '-01')) THEN A.duration END), 1), 0) 'Hours Passed to Date'

FROM Students S
INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
	ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
	AND R.registrationId = RR.maxReg
INNER JOIN Programmes P ON P.programmeId = R.programmeId
LEFT JOIN (SELECT studentId, attendanceDate, duration, classId
	FROM Attendance A
    WHERE isActive = 1
    AND attendanceDate <= CURDATE()) A
    ON A.studentId = S.studentId
LEFT JOIN ClassStudentReltn CSR ON CSR.classId = A.classId
	AND CSR.studentId = A.studentId

WHERE (R.graduationDate IS NULL OR
	   R.graduationDate BETWEEN CONCAT('[?Year (YYYY)]-', LPAD('[?Month (MM)]', 2, '0'), '-01') AND LAST_DAY(CONCAT('[?Year (YYYY)]-', LPAD('[?Month (MM)]', 2, '0'), '-01')) )
AND P.programmeName = '[?Program{Aesthetics|Aesthetics|Cosmetology|Cosmetology}]'
AND A.attendanceDate >= R.startDate
AND CSR.isActive = 1
AND S.<ADMINID>

GROUP BY S.studentId
ORDER BY S.lastName ASC)

UNION
(SELECT NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
    , COALESCE(ROUND(SUM(hoursLastMonth), 1), 0)
    , COALESCE(ROUND(SUM(hoursThisMonth), 1), 0)
	, COALESCE(ROUND(SUM(hoursLastMonth)+SUM(hoursThisMonth), 1), 0)

FROM (
	SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.studentId AS CHAR), '</a>') AS Name
		, S.lastName
		, S.firstName
	    , SUBSTRING(S.ssn, 8, 12) 'Last 4 of SSN#'
	    , DATE_FORMAT(R.startDate, '%m/%d/%Y') 'Enrollment Date'
	    , SUBSTRING(P.programmeName, 1, 1) 'Course of Study'
	    , COALESCE(ROUND(SUM(CASE WHEN A.attendanceDate <  CONCAT('[?Year (YYYY)]-', '[?Month (MM)]', '-01') THEN A.duration END), 1), 0) hoursLastMonth
	    , COALESCE(ROUND(SUM(CASE WHEN A.attendanceDate >= CONCAT('[?Year (YYYY)]-', '[?Month (MM)]', '-01')
						 AND A.attendanceDate <= LAST_DAY(CONCAT('[?Year (YYYY)]-', '[?Month (MM)]', '-01'))
							THEN A.duration END), 1), 0) hoursThisMonth

	FROM Students S
	INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
		ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId
		AND R.registrationId = RR.maxReg
	INNER JOIN Programmes P ON P.programmeId = R.programmeId
	LEFT JOIN (SELECT studentId, attendanceDate, duration, classId
		FROM Attendance
	    WHERE isActive = 1
	    AND attendanceDate <= CURDATE()) A
	    ON A.studentId = S.studentId
	LEFT JOIN ClassStudentReltn CSR ON CSR.classId = A.classId
		AND CSR.studentId = A.studentId

	WHERE (R.graduationDate IS NULL OR
		   R.graduationDate BETWEEN CONCAT('[?Year (YYYY)]-', LPAD('[?Month (MM)]', 2, '0'), '-01') AND LAST_DAY(CONCAT('[?Year (YYYY)]-', LPAD('[?Month (MM)]', 2, '0'), '-01')) )
	AND P.programmeName = '[?Program{Aesthetics|Aesthetics|Cosmetology|Cosmetology}]'
	AND A.attendanceDate >= R.startDate
	AND CSR.isActive = 1
	AND S.<ADMINID>

	GROUP BY S.studentId) t1
)
