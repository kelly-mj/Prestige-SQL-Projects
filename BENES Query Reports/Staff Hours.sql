-- Staff Hours

SELECT t1.Name 'Staff Name' -- staff name
	, t1.attendanceDate 'Attendance Date' -- date
	, t1.duration AS 'Hours' -- hours

FROM (
	-- Teacher information
	SELECT T.teacherId
		, CONCAT('<a href="admin_view_teacher.jsp?teacherid=', CAST(T.teacherId AS CHAR),'"target="_blank">', T.firstName, ' ', T.lastName, '</a>') AS Name
		, T.campusCode AS campusCode
		, TA.teacherAttendanceId AS attendanceId
		, TA.attendanceDate AS attendanceDate
		, MAX(TA.duration) AS duration
	FROM Teachers T
	INNER JOIN TeacherAttendance TA
		ON TA.teacherId = T.teacherId
		AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
		AND TA.isActive = 1
		AND TA.duration > 0
	WHERE T.<ADMINID>
		AND T.isActive = 1
		AND T.campusCode = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	-- Subadmin information
	UNION
	SELECT SA.subAdminId
		, CONCAT('<a href="admin_view_subadmin.jsp?subadminid=', CAST(SA.subAdminId AS CHAR),'" target="_blank">', SA.firstName, ' ', SA.lastName, '</a>') AS Name
		, SA.campusCode AS campusCode
		, SAA.subAdminAttendanceId AS attendanceId
		, SAA.attendanceDate AS attendanceDate
		, MAX(SAA.duration) AS duration
	FROM SubAdmins SA
	INNER JOIN SubAdminAttendance SAA
		ON SAA.subAdminId = SA.subAdminId
		AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
		AND SAA.isActive = 1
		AND SAA.duration > 0
	WHERE SAA.<ADMINID>
		AND SA.isActive = 1
		AND SA.campusCode = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	GROUP BY attendanceId
	ORDER BY attendanceDate ASC
) t1

-- FLOOR(SUM(t3.duration)),'.', LPAD(ROUND((SUM(t3.duration)- FLOOR(SUM(t3.duration))) * 100)% 100,2,0)

UNION	-- weekly hours
SELECT 'Total Hours: '
	, NULL
	, SUM(t2.duration) -- weekly hours total
FROM (
	-- Teacher information
	SELECT T.teacherId
		, CONCAT('<a href="admin_view_teacher.jsp?teacherid=', CAST(T.teacherId AS CHAR),'"target="_blank">', T.firstName, ' ', T.lastName, '</a>') AS Name
		, T.campusCode AS campusCode
		, TA.teacherAttendanceId AS attendanceId
		, TA.attendanceDate AS attendanceDate
		, MAX(TA.duration) AS duration
	FROM Teachers T
	INNER JOIN TeacherAttendance TA
		ON TA.teacherId = T.teacherId
		AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
		AND TA.isActive = 1
		AND TA.duration > 0
	WHERE T.<ADMINID>
		AND T.isActive = 1
		AND T.campusCode = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	-- Subadmin information
	UNION
	SELECT SA.subAdminId
		, CONCAT('<a href="admin_view_subadmin.jsp?subadminid=', CAST(SA.subAdminId AS CHAR),'" target="_blank">', SA.firstName, ' ', SA.lastName, '</a>') AS Name
		, SA.campusCode AS campusCode
		, SAA.subAdminAttendanceId AS attendanceId
		, SAA.attendanceDate AS attendanceDate
		, MAX(SAA.duration) AS duration
	FROM SubAdmins SA
	INNER JOIN SubAdminAttendance SAA
		ON SAA.subAdminId = SA.subAdminId
		AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
		AND SAA.isActive = 1
		AND SAA.duration > 0
	WHERE SAA.<ADMINID>
		AND SA.isActive = 1
		AND SA.campusCode = [?Campus{34652|New Port Richey|34606|Spring Hill|34601|BrooksVille}]
	GROUP BY attendanceId
) t2
GROUP BY t2.Name

ORDER BY Name