-- Tardy Notification
-- Author: Kelly MJ  |  08/27/2018

-- Tardy Notification builder

SELECT t1.*
FROM (
    SELECT A.studentId, A.attendanceId, A.duration
        -- , DATE(CP.punchTime) AS 'Date'
        , CS.className AS 'Class'
        , CS.classStart AS 'Class Start'
        , MIN(TIME(CP.punchTime)) AS 'Time In'
        , CS.classDur
        , SUBTIME(TIME(CP.punchTime), CS.classStart) AS Hours_Late -- calculation for hours missed due to tardy
        
    FROM (      -- selects info from Attendance table for 'tardy' records
        SELECT studentId
            , attendanceId
            , duration
            , attendanceDate
            , DAYOFWEEK(attendanceDate) AS attDayNum
            , classId
        FROM Attendance
        WHERE tardy > 0 AND isActive = 1) A

    LEFT JOIN ClockPunches CP
        ON CP.userId = A.studentId
        AND CP.clockedStatus = 1
        
    LEFT JOIN (             -- selects class schedule info, including a time-formatted start time
        SELECT S.classId
            , C.className
            , MAKETIME(TRUNCATE(startTime/100, 0), startTime%100, 00) as classStart
            , MAKETIME(TRUNCATE((endTime-startTime)/100, 0), (endTime-startTime)%100, 00) as classDur
            , dayNum
        FROM ClassSchedules S, Classes C
        WHERE C.classId = S.classId) CS     -- selects class information
        ON CS.classId = A.classId
        AND CS.dayNum = A.attDayNum

    GROUP BY A.attendanceId
) t1

-- WHERE t1.Hours_Late > 0