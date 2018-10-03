SELECT R.studentId, C.className, A.attendanceDate, CSR.classId, SUM(C.lessonDuration)*8.5/8    -- , C.lessonDuration 

FROM Registrations R

INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId) R2
	ON R2.studentId = R.studentId AND R2.maxDate = R.startDate

INNER JOIN ClassStudentReltn CSR
	ON CSR.studentId = R.studentId
    AND CSR.isActive = 1

INNER JOIN Classes C
	ON C.classId = CSR.classId
    AND C.isActive=1
    AND C.startDate <= R.endDate AND C.endDate >= R.startDate
    and C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=R.programmeId and CG.isActive=1 and CG.courseGroupId=GSR.courseGroupId and GSR.isActive=1)

INNER JOIN (
	SELECT DISTINCT attendanceDate, DAYOFWEEK(attendanceDate) AS DOW
	FROM Attendance) A
    ON A.attendanceDate <= R.endDate AND A.attendanceDate >= R.startDate
    AND A.attendanceDate <= C.endDate AND A.attendanceDate >= C.startDate
    AND A.attendanceDate <= '2018-06-01'
    AND A.DOW IN (SELECT 1+CS.dayNum FROM ClassSchedules CS WHERE CS.classId = CSR.classId)
    
WHERE R.studentId = 316
ORDER BY A.attendanceDate ASC