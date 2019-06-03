-- [AOHD] Campus Attendance Percentage with Date Range
-- Kelly MJ  |  06/03/2019

SELECT C.campusName
    , FORMAT(SUM(t1.hoursAtt), 0) AS 'Total Hours Attended'
    , FORMAT(SUM(t1.hoursSch), 0) AS 'Total Hours Scheduled'
    , CONCAT(FORMAT(100*SUM(t1.hoursAtt)/SUM(t1.hoursSch), 2), '%') AS 'Attendance Percentage'

FROM (
    SELECT S.studentCampus
		, S.studentId
        , S.firstName
        , S.lastName
        , S.isActive
        , R.startDate
        , R.graduationDate
        , SUM(A.duration) AS hoursAtt
        , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_SCHEDULED') AS hoursSch
    FROM Registrations R
    INNER JOIN (SELECT MAX(registrationId) maxReg, studentId FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
        ON RR.studentId = R.studentId AND RR.maxReg = R.registrationId
    INNER JOIN Students S ON S.studentId = R.studentId
    INNER JOIN Attendance A ON A.studentId = R.studentId
    INNER JOIN ClassStudentReltn CSR ON CSR.studentId = R.studentId
    INNER JOIN Classes C ON C.classId = CSR.classId
    WHERE( R.graduationDate IS NULL OR R.graduationDate >= '[?From Date]' )
        AND R.startDate <= '[?To Date]'
        AND A.attendanceDate >= R.startDate
        AND A.isActive = 1
        AND A.classId = C.classId
        AND CSR.isActive = 1
        AND C.isActive=1
        AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=R.programmeId and CG.isActive=1 and CG.courseGroupId=GSR.courseGroupId and GSR.isActive=1)
        AND S.isActive <> 14
    GROUP BY R.studentId
) t1

INNER JOIN Campuses C ON C.campusCode = t1.studentCampus

WHERE C.<ADMINID>

GROUP BY C.campusId
