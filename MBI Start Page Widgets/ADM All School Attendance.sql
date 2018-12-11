-- MBI ADM All School Attendance
-- Kelly MJ  |  12/10/18

SELECT t1.idNumber
	, t1.name
	, CASE
		WHEN t1.hours <= 500 THEN TH.className
		WHEN t1.hours BETWEEN 500 AND 600 THEN CONCAT(TH.className, ' /</br>', IC.className)
        ELSE IC.className
	  END AS Class
    , CONCAT(IF(CPP.clockedStatus%2=1, 'Clocked In', 'Clocked Out')) AS Status
    , CP.lastPunch

FROM (
    SELECT S.studentId
		, S.idNumber
		, CONCAT('<a target="_blank" href="https://mbi.orbund.com/einstein-freshair/admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS name
		, S.lastName
        , SUM(A.duration) AS hours
		, R.startDate

	FROM Students S

	INNER JOIN (
		SELECT studentId, MAX(startDate) AS maxDate FROM Registrations R WHERE isActive = 1 GROUP BY studentId ) AS RR
		ON RR.studentId = S.studentId

	INNER JOIN Registrations R
		ON R.studentId = S.studentId 
		AND R.startDate = RR.maxDate
		
	LEFT JOIN Attendance A
		ON A.studentId = S.studentId
		AND A.isActive = 1
		AND A.classId IN (SELECT classId FROM Classes WHERE className NOT LIKE '%intern%' AND className NOT LIKE '%ic%')

	WHERE S.isActive = 1
		AND S.<ADMINID>
		
	GROUP BY S.studentId ) t1

LEFT JOIN (
	SELECT C.className, CSR.studentId
    FROM ClassStudentReltn CSR
    INNER JOIN Classes C
		ON C.classId = CSR.classId
        AND C.className NOT LIKE '%intern%' AND C.className NOT LIKE '%ic%'
        AND C.isActive = 1 AND CSR.isActive = 1 ) TH
	ON TH.studentId = t1.studentId
    
LEFT JOIN (
	SELECT C.className, CSR.studentId
    FROM ClassStudentReltn CSR
    INNER JOIN Classes C
		ON C.classId = CSR.classId
        AND C.className LIKE '%intern%' AND C.className LIKE '%ic%'
        AND C.isActive = 1 AND CSR.isActive = 1 ) IC
	ON IC.studentId = t1.studentId
    
INNER JOIN (
	SELECT userId
		, DATE_FORMAT(MAX(punchTime), '%a %m/%d/%y</br>%h:%i %p') AS lastPunch
        , MAX(punchTime) AS maxPunch
	FROM ClockPunches
    WHERE userId IN (SELECT studentId FROM Students WHERE isActive = 1)
    GROUP BY userId ) CP
    ON CP.userId = t1.studentId

INNER JOIN ClockPunches CPP
	ON CPP.userId = t1.studentId
	AND CPP.punchTime = CP.maxPunch
    
ORDER BY DATE(CP.maxPunch) DESC, t1.lastName