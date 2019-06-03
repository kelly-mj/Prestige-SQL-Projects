-- [AOHD] ADM Campus Average Attendance
-- Kelly MJ  |  06/03/2019

SELECT C.campusName AS Campus
    , FORMAT(SUM(t1.hoursAtt), 0) AS 'Total Hours Attended'
    , FORMAT(SUM(t1.hoursSch), 0) AS 'Total Hours Scheduled'
    , CONCAT(FORMAT(100*SUM(t1.hoursAtt)/SUM(t1.hoursSch), 2), '%') AS 'Attendance Percentage'

FROM (
    SELECT S.studentCampus
        , ATT.fieldValue AS hoursAtt
        , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_SCHEDULED') AS hoursSch
    FROM Students S
    INNER JOIN (SELECT userId, fieldValue FROM ProfileFieldValues WHERE fieldName = 'PROGRAM_HOURS_ATTENDED') ATT
        ON ATT.userId = S.studentId
) t1

INNER JOIN Campuses C ON C.campusCode = t1.studentCampus

WHERE C.<ADMINID>

GROUP BY C.campusCode
