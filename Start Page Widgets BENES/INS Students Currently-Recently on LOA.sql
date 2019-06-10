-- [BENES] INS Students Currently-Recently on LOA
-- Kelly MJ  |  6/9/2018
-- Displays students in instructor's class(es) who are currently LOA or have returned within the past 15 days.

SELECT CMP.campusName
	, CSR.className
    -- , (SELECT CONCAT(T.lastName, ', ', T.firstName) FROM Teachers T WHERE T.teacherId = CSR.teacherId) AS Teacher
    -- , CSR.teacherId
    , S.idNumber AS 'ID Number'
    , CONCAT(S.lastName, ', ', S.firstName) AS 'Student Name'
    , DATE_FORMAT(LOA.leaveDate, '%m/%d/%Y') AS 'Leave Date'
    , DATE_FORMAT(LOA.expectedReturnDate, '%m/%d/%Y') 'Expected Return'
    , DATE_FORMAT(LOA.returnDate, '%m/%d/%Y') 'Return Date'

FROM LeavesOfAbsence LOA
INNER JOIN Students S ON LOA.studentId = S.studentId
INNER JOIN Campuses CMP ON CMP.campusCode = S.studentCampus
INNER JOIN (SELECT CS.*, C.className, C.teacherId
		FROM ClassStudentReltn CS
		INNER JOIN Classes C ON C.classId = CS.classId
		WHERE CS.isActive = 1
        AND CS.status = 0) CSR
    ON CSR.studentId = S.studentId

WHERE LOA.isActive = 1
  AND LOA.leaveDate <= CURDATE()
  AND (LOA.returnDate IS NULL OR LOA.returnDate >= DATE_SUB(CURDATE(), INTERVAL 15 DAY))
  AND S.<ADMINID>
  AND CSR.teacherId = [USERID]
  
ORDER BY CSR.className, S.lastName