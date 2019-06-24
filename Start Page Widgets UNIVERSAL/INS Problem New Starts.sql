-- [SHELL] INS Problem New Starts
-- Kelly MJ  |  06/17/2019
-- Displays new starts (start date <= 30 days before current date) who have not attended their first days of class OR have < 90% attendance.
-- Students are matched to admissions officer's campus.

SELECT t1.className
    , t1.Name
    , t1.startDate AS 'Start Date'
    , t1.day1Att AS 'Attended Day 1?'
    , CASE WHEN (t1.attRate = '--' OR t1.attRate > 70) THEN CONCAT(FORMAT(t1.attRate, 2), ' %')
           ELSE CONCAT('<div style="color: red;">', FORMAT(t1.attRate, 2), ' %</div>')
           END AS 'Att Rate'

FROM (
    SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
        , C.className
        , DATE_FORMAT(R.startDate, '%m/%d/%Y') AS startDate
        , IF(ATT.firstDay IS NOT NULL, 'Yes', '<div style="color: red;">No</div>') AS day1Att
        , COALESCE(100*(SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_ATTENDED')/SCH.fieldValue
    				, '--') AS attRate

    FROM Students S
    INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
        ON RR.studentId = S.studentId
    INNER JOIN Registrations R ON R.studentId = S.studentId
        AND R.registrationId = RR.maxReg
    INNER JOIN ProfileFieldValues SCH ON SCH.userId = S.studentId
        AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'
    INNER JOIN ClassStudentReltn CSR ON CSR.registrationId = R.registrationId
    INNER JOIN Classes C ON C.classId = CSR.classId
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
    AND CSR.isActive = 1
    AND CSR.status = 0
    AND C.isActive = 1
    AND EXISTS (SELECT * FROM ClassTeacherReltn
                WHERE classId = CSR.classId
                AND teacherId = [USERID]
                AND isActive = 1)

    AND S.<ADMINID>

    GROUP BY S.studentId
    ORDER BY R.startDate ASC
) t1

WHERE attRate < 90
