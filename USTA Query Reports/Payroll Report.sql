-- USTA Payroll Report
-- Kelly MJ 12/04/2018

/*
 *  REGULAR HOURS (at or below 40 hours)
 */
 
SELECT t1.id 'ID'
    , t1.name 'Name'
    , FORMAT(IF(t1.duration <= 40.0, duration, 40), 2) 'Hours'
    , t1.paycode 'Paycode'
    
FROM (
    SELECT T.teacherId AS id
        , CONCAT(T.lastName, ' ', T.firstName) AS name
        , SUM(TA.duration) AS duration
        , 'Regular' AS paycode
    
    FROM TeacherAttendance TA
    INNER JOIN Teachers T
        ON T.teacherId = TA.teacherId
        
    WHERE TA.attendanceDate BETWEEN '2018-11-11' AND '2018-11-17'   -- '[?Start Date]' AND '[?End Date]'
    AND TA.<ADMINID>
    
    GROUP BY T.teacherID
    ORDER BY T.lastName
) t1

/*
 *  OVERTIME (anything over 40 hours)
 */
UNION
SELECT t1.id 'ID'
    , t1.name 'Name'
    , FORMAT(duration - 40.0, 2) 'Hours'
    , t1.paycode 'Paycode'
    
FROM (
    SELECT T.teacherId AS id
        , CONCAT(T.lastName, ' ', T.firstName) AS name
        , SUM(TA.duration) AS duration
        , 'OT' AS paycode
    
    FROM TeacherAttendance TA
    INNER JOIN Teachers T
        ON T.teacherId = TA.teacherId
        
    WHERE TA.attendanceDate BETWEEN '2018-11-11' AND '2018-11-17'   -- '[?Start Date]' AND '[?End Date]'
    AND TA.<ADMINID>
    
    GROUP BY T.teacherID
    ORDER BY T.lastName
) t1

WHERE t1.duration > 40.0

/*
 * AFFECTS ALL 'UNIONS'
 */
 
ORDER BY id