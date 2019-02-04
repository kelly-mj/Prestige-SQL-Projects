-- Widget (Admin View): Students Past Contract Grad Date
-- Author: Kelly MJ  |  8/15/2018
-- Displays students who have not fulfilled their program hours by their contracted graduation date.
-- 9/20/18 Kelly MJ: Added surcharge hours column

SELECT t1.Name
    , t1.programmeName 'Program Name'
    , t1.endDate 'Contract<br>Grad Date'
    , t1.lastPunch 'Last Date Attended'
    , ROUND(t1.HoursAttended, 1) 'Contract<br>Hours<br>Attended'
    , CASE WHEN t1.overContactType = 'Hourly'
            THEN CONCAT(COALESCE(ROUND(t2.hoursAfterGradDate, 1), 0.0), ' hours at $', t1.overContactAmount, '/hr<br><strong>= $', COALESCE(ROUND(t2.hoursAfterGradDate, 1), 0.0)*t1.overContactAmount)
           WHEN t1.overContactType = 'Daily'
            THEN CONCAT(COALESCE(ROUND(t2.daysAfterGradDate, 1), 0.0), ' days at $', t1.overContactAmount, '/day<br><strong>= $', COALESCE(ROUND(t2.daysAfterGradDate, 1), 0.0)*t1.overContactAmount)
           ELSE 'N/A' END AS 'Hours Surcharge'

FROM (

SELECT S.idNumber
    , S.studentId
    , S.studentCampus AS Campus
    , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
    , P.programmeName
    , P.minClockHours
    , P.overContactAmount
    , P.overContactType
    , DATE_FORMAT(R.endDate, "%m/%d/%y") AS endDate
    , SUM(A.duration) AS HoursAttended  -- before contracted grad date
    , DATE_FORMAT(CP.lastPunch, "%m/%d/%y") AS lastPunch

FROM Students S

INNER JOIN Registrations R
    ON R.studentId = S.studentId

-- Finds greatest contract grad date for each student
INNER JOIN (
    SELECT RR.studentId
        , MAX(RR.endDate) endDate
    FROM Registrations RR
    WHERE RR.programmeId IN (SELECT PP.programmeId FROM Programmes PP WHERE PP.programmeName NOT LIKE '%areer%' AND PP.programmeName NOT LIKE '%nstructor%raining%')
    GROUP BY RR.studentId) MAXREG
    ON MAXREG.studentId = R.studentId
    AND MAXREG.endDate = R.endDate
    
INNER JOIN Programmes P
    ON P.programmeId = R.programmeId
    AND P.isActive = 1

INNER JOIN Attendance A
    ON A.studentId = S.studentId
    AND A.attendanceDate <= R.endDate
    AND A.attendanceDate >= R.startDate
    AND A.subjectId IN (SELECT GSR.subjectId FROM CourseGroups CG
                        INNER JOIN GroupSubjectReltn GSR ON GSR.courseGroupId = CG.courseGroupId
                        WHERE GSR.isActive = 1 AND CG.isActive = 1 AND R.programmeId = CG.programmeId)
    AND A.classId IN (SELECT CSR.classId FROM ClassStudentReltn CSR
                      WHERE CSR.studentId = A.studentId AND CSR.isActive = 1)

INNER JOIN (
    SELECT DATE(MAX(CPS.punchTime)) AS lastPunch, CPS.userId
    FROM ClockPunches CPS
    GROUP BY CPS.userId) CP
    ON CP.userId = R.studentId

WHERE
    S.isActive = 1
    AND R.isActive = 1
    AND R.regStatus NOT IN (0, 3)
    AND R.endDate <= CURDATE()
    AND R.enrollmentSemesterId = 4000441
    AND S.firstName NOT LIKE 'test'
    AND R.<ADMINID>
    
GROUP BY S.studentId
ORDER BY R.endDate DESC
) t1

LEFT JOIN (
    SELECT S.studentId
    , SUM(A.duration) AS hoursAfterGradDate  -- hours attended after contracted grad date
    , COUNT(DISTINCT A.attendanceDate) AS daysAfterGradDate      -- days attended after contract grad date
    
    FROM Students S

    INNER JOIN Registrations R
        ON R.studentId = S.studentId
        AND R.enrollmentSemesterId = 4000441

    INNER JOIN Attendance A
        ON A.studentId = S.studentId
        AND A.attendanceDate >= R.endDate
        AND A.subjectId IN (SELECT GSR.subjectId FROM CourseGroups CG
                            INNER JOIN GroupSubjectReltn GSR ON GSR.courseGroupId = CG.courseGroupId
                            WHERE GSR.isActive = 1 AND CG.isActive = 1 AND R.programmeId = CG.programmeId)
        AND A.classId IN (SELECT CSR.classId FROM ClassStudentReltn CSR
                          WHERE CSR.studentId = A.studentId AND CSR.isActive = 1)

    WHERE S.isActive = 1
        AND R.isActive = 1
        AND R.regStatus NOT IN (0, 3)
        AND R.endDate <= CURDATE()
        AND S.firstName NOT LIKE 'test'
        AND R.<ADMINID>
        
    GROUP BY S.studentId
    ORDER BY R.endDate DESC ) t2
    ON t2.studentId = t1.studentId

WHERE t1.HoursAttended < t1.minClockHours