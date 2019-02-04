SELECT t1.name
      , t1.program
      , CONCAT(t1.percent, '%') 'Att. Percentage'
      , t1.startDate

FROM (
SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CONCAT(UCASE(SUBSTRING(S.lastName, 1, 1)),LCASE(SUBSTRING(S.lastName, 2)),", ",CONCAT(UCASE(SUBSTRING(S.firstName, 1, 1)),LCASE(SUBSTRING(S.firstName, 2)))), '</a>') 'Name'  -- Name (link)
     , P.programmeName 'Program' -- Program name
     , ROUND( 100*(SUM(A.duration)/PFV.fieldValue), 0 ) 'percent'                                             -- Percentage (numerical)
     , R.startDate
     , PFV.fieldValue AS ih

FROM Registrations R
   
INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate
            FROM Registrations
            GROUP BY studentId) R2
	ON R2.studentId = R.studentId
	AND R2.maxDate = R.startDate

INNER JOIN Attendance A
	ON R.studentId = A.studentId
	AND A.isActive = 1
	AND A.attendanceDate >= R.startDate

INNER JOIN Classes C
	ON C.classId = A.classId
	AND C.startDate <= CURDATE() and C.endDate >= CURDATE()
	AND C.isActive = 1
	AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
	          WHERE CG.programmeId=R.programmeId AND CG.isActive=1
	          AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)

INNER JOIN ProfileFieldValues PFV
    ON PFV.userId = R.studentId
    AND PFV.fieldName LIKE 'PROGRAM_HOURS_SCHEDULED'

INNER JOIN ClassStudentReltn CSR
	ON CSR.classId = C.classId
	AND CSR.isActive = 1
	AND R.studentId = CSR.studentId

INNER JOIN Programmes P
	ON P.programmeId = R.programmeId

INNER JOIN Students S
	ON R.studentId = S.studentId
	AND S.isActive = 1

WHERE R.isActive = 1
AND R.<ADMINID>
AND S.firstName NOT IN ('Test', 'TEST', 'test')
AND S.lastName NOT IN ('Test', 'TEST', 'test')

GROUP BY R.registrationId
ORDER BY S.lastName
) t1
WHERE t1.percent >= 90.0