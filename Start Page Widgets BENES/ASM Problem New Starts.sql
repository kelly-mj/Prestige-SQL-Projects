-- [BENES] ASM Problem New Starts
-- Kelly MJ  |  06/17/2019
-- Displays new starts (start date <= 30 days before current date) who have not attended their first days of class OR have < 90% attendance.
-- Students are matched to admissions officer's campus.

SELECT S.studentId, CONCAT(S.lastName, ', ', S.firstName) AS Name
    , P.programmeName AS Program
    , DATE_FORMAT(R.startDate, '%m/%d/%Y') AS 'Start Date'
    , IF(ATT.firstDay IS NOT NULL, '<div style="color: green;">Yes</div>', '<div style="color: red;">No</div>') AS 'Attended Day 1?'
    , CONCAT(COALESCE((SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_ATTENDED')/SCH.fieldValue
				, 0), '%') AS 'Att Rate'

FROM Students S
INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN Programmes P ON P.programmeId = R.programmeId
INNER JOIN ProfileFieldValues SCH ON SCH.userId = S.studentId
    AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'
INNER JOIN ClassStudentReltn CSR ON CSR.registrationId = R.registrationId
LEFT JOIN (SELECT studentId, classId, MIN(attendanceDate) AS firstDay
            FROM Attendance
            WHERE isActive = 1
            AND present = 1
            GROUP BY studentId, classId) ATT
    ON ATT.studentId = S.studentId
    AND ATT.classId = CSR.classId

WHERE S.isActive = 1
AND R.startDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
AND R.startDate <  CURDATE()
AND S.<ADMINID>
