-- SDB ADM Grad Date for Students as 85% Attendance
-- Kelly MJ  |  12/17/2018

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">' , S.lastname, ', ', S.firstName, '</a>') AS name
	, R.startDate 'Start Date'
    , R.endDate 'Contract End Date'
    -- , DATE_ADD(R.endDate, INTERVAL (ROUND((1 - t1.attPercent)*DATEDIFF(R.endDate, R.startDate), 0)) DAY) 'Projected End Date'        -- for percentage determined by student's current attendance rate
    , DATE_ADD(R.endDate, INTERVAL (ROUND((1-0.85)*DATEDIFF(R.endDate, R.startDate), 0)) DAY) 'Projected End Date (85% ATT)'      -- for 85% attendance
    , CONCAT(ROUND(100*t1.attPercent, 0), '%') '  Att %'
    
FROM Students S

INNER JOIN (
	SELECT studentId, MAX(startDate) AS maxDate
    FROM Registrations WHERE regStatus = 1
    GROUP BY studentId ) RR
    ON RR.studentId = S.studentId

INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.startDate = RR.maxDate

INNER JOIN (
    SELECT A.studentId
        , SUM(A.duration) AS hoursAtt
        , PFV.fieldValue AS hoursSch
        , SUM(A.duration)/PFV.fieldValue AS attPercent

    FROM ( SELECT studentId, MAX(startDate) AS maxDate, programmeId FROM Registrations WHERE regStatus = 1 GROUP BY studentId ) RR

    INNER JOIN Attendance A
        ON RR.studentId = A.studentId
        AND A.isActive = 1
        AND A.attendanceDate >= RR.maxDate

    INNER JOIN Classes C
        ON C.classId = A.classId
        AND C.startDate <= CURDATE() and C.endDate >= CURDATE()
        AND C.isActive = 1
        AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
                  WHERE CG.programmeId=RR.programmeId AND CG.isActive=1
                  AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)

    INNER JOIN ProfileFieldValues PFV
        ON PFV.userId = RR.studentId
        AND PFV.fieldName LIKE 'PROGRAM_HOURS_SCHEDULED'

    INNER JOIN ClassStudentReltn CSR
        ON CSR.classId = C.classId
        AND CSR.isActive = 1
        AND RR.studentId = CSR.studentId
    GROUP BY RR.studentId
    ) t1
    ON t1.studentId = S.studentId

LEFT JOIN Programmes P
	ON P.programmeId = R.programmeId
    
WHERE S.isActive = 1
AND S.<ADMINID>
AND t1.attPercent <= 0.85

GROUP BY S.studentId
ORDER BY S.lastName