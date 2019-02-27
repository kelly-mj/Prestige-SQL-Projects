-- BENES ADM At Risk Students
-- Written by Andrew
-- Kelly MJ 1/3/19: Added case for when lda is in a separate year than the current date

SELECT Name AS 'Student'
	, CASE t2.enrollmentType WHEN 1.000000 THEN 'Full-Time'
		WHEN 0.750000 THEN '3/4-Time'
		WHEN 0.653847 THEN 'Part-Time'
		WHEN 0.600000 THEN 'Part-Time'
		WHEN 0.500000 THEN 'Half-Time'
		WHEN 0.250000 THEN '1/4-Time'
		ELSE 'Unknown' END AS Enrollment
	, ClassName AS Class
	, DATE_FORMAT(lda, '<div align="center">%m/%d/%Y</div>') AS 'Last Day Attended'
	, CASE
		WHEN DifD >= 14 AND DifD < 30 THEN CONCAT('<div align="center">','<font color="#ff8f00">', Difd, '</font>','</div>')
		WHEN DifD >= 30 THEN CONCAT('<div align="center">','<font color="red">', Difd, '</font>','</div>')
		ELSE CONCAT('<div align="center">', Difd, '</div>')  END AS 'Consecutive Days Absent'

FROM (
	SELECT Name
		, Classname
		, lda
		, ((DATEDIFF(CURRENT_DATE, lda)) -
			( 2 * IF(YEAR(CURDATE()) <= YEAR(lda), (WEEK(CURRENT_DATE) - WEEK(lda)), 52*(YEAR(CURDATE()) - YEAR(lda) - 1) + 52 - WEEK(lda) + WEEK(CURDATE())) ) -
			(case when weekday(CURRENT_DATE) = 6 then 1 else 0 end) -
			(case when weekday(lda) = 5 then 1 else 0 end)
			- (SELECT COUNT(CAL.calendarEventId)
				FROM CalendarEvents CAL WHERE CAL.eventDate >= lda AND CAL.eventDate < CURDATE() AND WEEKDAY(CAL.eventDate) IN (0, 1, 2, 3, 4)
				AND CAL.isDayOff = 1 AND CAL.isActive = 1)) as DifD
			-- field kelly uses for testing START
			, DATEDIFF(CURRENT_DATE, lda) as date_diff
			, ( IF(YEAR(CURDATE()) <= YEAR(lda), (WEEK(CURRENT_DATE) - WEEK(lda)), 52*(YEAR(CURDATE()) - YEAR(lda) - 1) + 52 - WEEK(lda) + WEEK(CURDATE())) ) as week_diff
			, t1.classDays
			, t1.enrollmentType
			-- fields kelly uses for testing END
	FROM (
		SELECT Distinct A.studentID
			, C.ClassName
			, CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
			, MAX(A.attendanceDate) as lda
			, RR.enrollmentType
			-- fields kelly uses for testing START
			, CS.classDays
			-- field kelly uses for testing END
		FROM Attendance A
		INNER JOIN Classes C
			ON A.classId = C.classId
		-- kelly testing START
		INNER JOIN (
			SELECT classId, COUNT(classScheduleId) AS classDays FROM ClassSchedules
			WHERE isActive = 1 GROUP BY classId ) CS
			ON CS.classId = C.classId
		-- kelly testing END
		INNER JOIN ClassStudentReltn CSR
			ON  C.classId = CSR.classId
			AND A.studentId = CSR.studentId
		INNER JOIN (
			SELECT RR.registrationId, RR.studentID, RR.enrollmentType
			FROM Registrations RR
			WHERE RR.isActive=1
			AND RR.regstatus = 1) AS RR
			ON RR.RegistrationID = CSR.registrationId
		INNER JOIN Students S
			ON S.studentID = RR.studentID
			AND S.<ADMINID>
		WHERE C.isActive=1
			AND CSR.isActive=1
			AND A.isActive=1
			AND A.present > 0
			AND A.AttendanceDate  BETWEEN (CURRENT_DATE - INTERVAL 60 DAY) AND CURRENT_DATE
			AND S.studentCampus IN (SELECT SA.campusCode FROM SubAdmins SA WHERE SA.subAdminId = [USERID])
			AND S.studentID NOT IN (SELECT LOA.StudentID FROM LeavesOfAbsence LOA WHERE LOA.isactive = 1 AND LOA.returnDate IS NULL OR LOA.returndate = '')
		GROUP BY A.studentID) as t1) as t2
WHERE DifD > 7
ORDER BY DifD DESC
