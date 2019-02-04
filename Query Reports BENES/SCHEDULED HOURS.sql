-- tried to generate a table of dates that could be whittled down to only list the dates within the student's contract start/end dates and
-- on their scheduled days of the week
-- but left-joining their attendance to the overall table of dates leaves a strip of "null" information from all the other tables (because the
-- attendance date is null for that day, and all the other information is joined from that point), so it's not filling in the days that
-- were originally left out of that student's attendance records...
/*
SELECT v.selected_date, A.attendanceDate, A.attendanceType, A.duration, R.startDate
-- , IF(v.selected_date IN (SELECT CS.dayNum FROM ClassSchedules CS WHERE CS.classId = C.classId), 1, 0)
, CSR.classId
	, CS.*

FROM
(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_date
	, dayofweek(adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i)) day_num from
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v

-- from https://stackoverflow.com/questions/9295616/how-to-get-list-of-dates-between-two-dates-in-mysql-select-query

LEFT JOIN Attendance A
	ON A.attendanceDate = V.selected_date
	AND A.studentId = 4046985

LEFT JOIN (
	SELECT RR.* FROM Registrations RR
    INNER JOIN (SELECT MAX(startDate) AS maxStart, studentId FROM Registrations GROUP BY studentId) RRR
		ON RRR.studentId = RR.studentId AND RRR.maxStart = RR.startDate) R
	ON R.studentId = A.studentId
    
LEFT JOIN ClassStudentReltn CSR
	ON CSR.studentId = R.studentId
    AND CSR.classId = A.classId
    
INNER JOIN ClassSchedules CS
	ON CS.dayNum = IF(v.day_num <> 1, v.day_num - 1, v.day_num + 6)
    AND CS.classId = CSR.classId

WHERE v.selected_date between '2018-04-01' and '2018-10-01'
	-- AND CS.dayNum IN (SELECT IF(dayNum <> 7, dayNum + 1, dayNum - 6) FROM ClassSchedules CS WHERE CS.classId = CSR.classId) */
    
    
-- new attempt: use math. Find number of days b/w their start date (and grad date or curdate) and subtract out unscheduled days.

SELECT SCH.*

FROM (
	SELECT R.studentId
		, R.startDate
		, COALESCE(R.graduationDate, R.endDate) AS endDay
        , LDA.lastDay
        , COUNT(CS.dayNum) AS weekDays
        , (FLOOR(DATEDIFF(IF(LDA.lastDay > COALESCE(R.graduationDate, R.endDate), COALESCE(R.graduationDate, R.endDate), LDA.lastDay), R.startDate)/7)*COUNT(CS.dayNum) + (DAYOFWEEK(LDA.lastDay) - MIN(CS.dayNum)) - 10) AS totalDays
        , FORMAT(C.lessonDuration*R.enrollmentType, 2) AS lessonDur
		, (FLOOR(DATEDIFF(IF(LDA.lastDay > COALESCE(R.graduationDate, R.endDate), COALESCE(R.graduationDate, R.endDate), LDA.lastDay), R.startDate)/7)*COUNT(CS.dayNum) + (DAYOFWEEK(LDA.lastDay) - MIN(CS.dayNum)) - 10) * C.lessonDuration * R.enrollmentType AS hoursSch
	FROM Registrations R
	INNER JOIN ( SELECT MAX(startDate) AS maxStart, studentId FROM Registrations GROUP BY studentId) RR
		ON RR.studentId = R.studentId
        AND RR.maxStart = R.startDate
	INNER JOIN ClassStudentReltn CSR
		ON CSR.studentId = R.studentId
		AND CSR.isActive = 1
	INNER JOIN Classes C
		ON C.classId = CSR.classId
		AND C.className NOT LIKE '%career%'
	INNER JOIN ClassSchedules CS
		ON CS.classId = CSR.classId
	INNER JOIN (SELECT MAX(attendanceDate) AS lastDay, studentId FROM Attendance WHERE attendanceType = 0 GROUP BY studentId) LDA
		ON LDA.studentId = R.studentId
	INNER JOIN Students S
		ON S.studentId = R.studentId
        AND S.isActive = 1
	-- INNER JOIN (SELECT COUNT(eventDate) AS holidays, adminId FROM calendarEvents WHERE eventDate BETWEEN R.startDate AND '2018-06-01' AND isDayOff = 1) CAL
	-- 	ON CAL.adminId = R.adminId
	GROUP BY R.studentId
    ) SCH