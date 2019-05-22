-- [SHELL] Query Report: Daily Contact Hours
-- Kelly MJ 5/13/2019

SELECT A.attendanceDate AS 'Date'
    , SUM(A.duration) AS 'Total Daily Attendance'

FROM Attendance A

WHERE A.isActive = 1
AND A.<ADMINID>
AND A.attendanceDate >= IF('[?From Date]' = '', DATE_SUB(CURDATE(), INTERVAL 14 DAY),'[?From Date]')         -- From user-selected date, or default range of past two weeks
AND IF('[?To Date]' = '', A.attendanceDate < CURDATE(), A.attendanceDate <= '[?To Date]')                    -- To user-selected date, or default current date
AND IF('[?Ignore Weekends?{Yes|Yes|No|No}]' = 'Yes', DAYOFWEEK(A.attendanceDate) NOT IN (1, 7), A.<ADMINID>) -- Option to ignore data from weekends

GROUP BY A.attendanceDate

ORDER BY A.attendanceDate ASC
