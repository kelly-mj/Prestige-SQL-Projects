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
WHERE SDT.<ADMINID> AND SDT.isActive = 1  OR
		SDT.<ADMINID> AND SDT.isActive = 12
Order By CLS.className, IDT.lastPunch DESC
