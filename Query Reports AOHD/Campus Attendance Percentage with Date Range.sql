-- [AOHD] Campus Attendance Percentage with Date Range
-- Kelly MJ  |  06/03/2019
-- Shows the ratio of overall attended hours to overall scheduled hours. Date range selects active students during the selected window (Active or LOA, not Grad/Withdrew). Separated by campus.

SELECT CMP.campusName
    , FORMAT(SUM(t1.hoursAtt), 0) AS 'Total Hours Attended'
    , FORMAT(SUM(SCH.hoursSch - t1.hoursToday), 0) AS 'Total Hours Scheduled'
    , CONCAT(FORMAT(100*SUM(t1.hoursAtt)/SUM(SCH.hoursSch - t1.hoursToday), 2), '%') AS 'Attendance Percentage'

FROM (
    SELECT SUM(A.duration) AS hoursAtt
        , S.studentId
        , S.studentCampus
        , C.lessonDuration
        , IF(LOCATE(DAYOFWEEK(CURDATE()), CS.dayNums) <> 0 AND CURTIME() < CS.endTime
            , C.lessonDuration
            , 0) AS hoursToday

    FROM Students S
    INNER JOIN (SELECT MAX(registrationId) maxReg, studentId FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
        ON RR.studentId = S.studentId
    INNER JOIN Registrations R ON R.studentId = S.studentId
        AND RR.maxReg = R.registrationId
    INNER JOIN Attendance A ON A.studentId = R.studentId
    INNER JOIN ClassStudentReltn CSR ON CSR.studentId = R.studentId
    INNER JOIN Classes C ON C.classId = CSR.classId
    LEFT JOIN (SELECT classId
                    , CONCAT(SUBSTRING(MAX(endTime), 1, 2), ':', SUBSTRING(MAX(endTime), 3, 2), ':00') AS endTime
                    , GROUP_CONCAT(dayNum SEPARATOR ' ') AS dayNums
				FROM ClassSchedules
                GROUP BY classId) CS
		ON CS.classId = CSR.classId

    WHERE ( R.graduationDate IS NULL OR R.graduationDate >= '[?From Date]' )
        AND R.startDate <= '[?To Date]'
        AND A.attendanceDate >= R.startDate
        AND A.isActive = 1
        AND A.classId = C.classId
        AND CSR.isActive = 1
        AND C.isActive=1
        AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=R.programmeId and CG.isActive=1 and CG.courseGroupId=GSR.courseGroupId and GSR.isActive=1)
        AND S.<ADMINID>

    GROUP BY R.studentId
    ) t1
INNER JOIN (SELECT userId, fieldValue AS hoursSch FROM ProfileFieldValues WHERE fieldName = 'PROGRAM_HOURS_SCHEDULED') SCH
    ON SCH.userId = t1.studentId
INNER JOIN Campuses CMP ON CMP.campusCode = t1.studentCampus

GROUP BY t1.studentCampus
