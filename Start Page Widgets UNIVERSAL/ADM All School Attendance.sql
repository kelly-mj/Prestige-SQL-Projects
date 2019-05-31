-- I'm guessing Zach Bene was the author
-- Edited by: Kelly MJ
-- Last Update: 6/13/2018
   -- Omitted Career Pathways students from the list
-- 2019-05-14 Bern - Removed the active check on the punches and also converted punchtime to DATE(punchTime) in the join
-- 2019-05-14 Bern - added check to only show items where ClassStudentReltn status is 0, which should be their current active class

SELECT
	SDT.idNumber,
	CONVERT(CONCAT("<a target='_blank' href='admin_view_student_attendance_record.jsp?studentid=", SDT.studentId, "'>", SDT.firstName, ' ', SDT.lastName, "</a>"), CHAR CHARACTER SET utf8) AS Name,
	CLS.className,
	IF(IDT.totalPunch % 2 = 1,
		"Clocked In",
		IF(IDT.totalPunch % 2 = 0,
			"Clocked Out",
			IF(SDT.isactive = 12,
				'Leave of Absence',
				'Absent'
			)
		)
	) AS 'Status',
	IDT.lastPunch AS 'Last Time Clocked'

FROM Students SDT

INNER JOIN (
	SELECT REG.studentId
		, REG.programmeId
		, MAX(REG.startDate)  AS startDate
	FROM Registrations REG
	WHERE REG.isActive = 1
	GROUP BY REG.studentId
) R
ON R.studentId = SDT.studentId and R.startDate<=CURDATE()

JOIN ClassStudentReltn CSR ON SDT.studentId = CSR.studentId AND CSR.isActive = 1
JOIN Classes CLS ON CSR.classId = CLS.classId AND CLS.isActive = 1
	AND NOT CLS.className LIKE '%Career%'
LEFT OUTER JOIN
	(SELECT
		idNumber,
		userId,
		DATE_FORMAT(MAX(punchTime), '%m-%d @ %l:%i') AS lastPunch,
		COUNT(userId) AS totalPunch
	FROM ClockPunches
	WHERE <ADMINID> AND -- isActive=1 AND
	CURDATE() = DATE(punchTime)
	GROUP BY userId) AS IDT ON SDT.studentId = IDT.userId

INNER JOIN Programmes P
ON R.programmeId = P.programmeId
AND P.isActive = 1
AND NOT ( P.programmeId IN (4000968, 4000979, 4000983, 4000999, 4001011))

WHERE CSR.status=0 and (SDT.<ADMINID> AND SDT.isActive = 1  OR
		SDT.<ADMINID> AND SDT.isActive = 12)

Order By CLS.className, IDT.lastPunch DESC


/*
SELECT
	SDT.idNumber,
	CONVERT(CONCAT("<a target='_blank' href='admin_view_student_attendance_record.jsp?studentid=", SDT.studentId, "'>", SDT.firstName, ' ', SDT.lastName, "</a>"), CHAR CHARACTER SET utf8) AS Name,
	CLS.className,
	IF(IDT.totalPunch % 2 = 1,
		"Clocked In",
		IF(IDT.totalPunch % 2 = 0,
			"Clocked Out",
			IF(SDT.isactive = 12,
				'Leave of Absence',
				'Absent'
			)
		)
	) AS 'Status',
	IDT.lastPunch AS 'Last Time Clocked'

FROM Students SDT
JOIN ClassStudentReltn CSR ON SDT.studentId = CSR.studentId AND CSR.isActive = 1
JOIN Classes CLS ON CSR.classId = CLS.classId AND CLS.isActive = 1
LEFT OUTER JOIN
	(SELECT
		idNumber,
		userId,
		DATE_FORMAT(MAX(punchTime), '%m-%d @ %l:%i') AS lastPunch,
		COUNT(userId) AS totalPunch
	FROM ClockPunches
	WHERE <ADMINID> AND isActive=1 AND
	CURDATE() = DATE(punchTime)
	GROUP BY userId) AS IDT ON SDT.studentId = IDT.userId
WHERE CST.status=0 AND ( SDT.<ADMINID> AND SDT.isActive = 1  OR
		SDT.<ADMINID> AND SDT.isActive = 12 )
Order By CLS.className, IDT.lastPunch DESC
*/
