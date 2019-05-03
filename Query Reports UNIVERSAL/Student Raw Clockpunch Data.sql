-- [SHELL] Query Report: Student Raw ClockPunch Data
-- Kelly MJ  |  5/3/2019

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
    , CP.originalPunchTime
    , CASE CP.clockedStatus
        WHEN 0 THEN 'Manual'
        WHEN 1 THEN 'Clock In'
        WHEN 2 THEN 'Clock Out' END AS clockedStatus


FROM Students S

INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
    ON RR.studentId = S.studentid

INNER JOIN Registrations R
    ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg

INNER JOIN ClockPunches CP
    ON CP.userId = S.studentId

WHERE CP.isActive > 0
AND S.<ADMINID>
AND (S.idNumber = [?ID Number] OR S.studentId = [?ID Number])
AND DATE(CP.punchTime) >= IF('[?From Date]' = '', R.startDate, '[?From Date]')
AND DATE(CP.punchTime) <= IF('[?To Date]' = '', CURDATE(), '[?To Date]')

ORDER BY CP.clockPunchId DESC
