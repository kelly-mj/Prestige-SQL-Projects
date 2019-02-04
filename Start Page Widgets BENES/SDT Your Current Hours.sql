-- Current Attended Hours in School (student widget)
-- Author: Kelly MJ   |   7/17/2018
    -- Lists students' hours attended, scheduled, and remaining
-- Update 7/26/18: Added 'Hours Transferred' to the balance
    
SELECT FORMAT(SUM(A.duration),2) 'Hours Attended'    -- hours attended
     , R.transferUnits 'Hours Transferred' -- Hours transferred
     , SUM(C.instructHour)/COUNT(A.attendanceId) 'Hours Scheduled'          -- hours scheduled
     , FORMAT(SUM(C.instructHour)/COUNT(A.attendanceId) - SUM(A.duration) - R.transferUnits, 2) 'Hours Remaining' -- hours remaining
    
FROM Registrations R
   
INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId) R2
ON R2.studentId = R.studentId AND R2.maxDate = R.startDate

INNER JOIN Attendance A
ON R.studentId = A.studentId
AND A.isActive = 1
AND A.attendanceDate >= R.startDate

INNER JOIN Classes C
ON C.classId = A.classId
AND C.isActive = 1
AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
					WHERE CG.programmeId=R.programmeId AND CG.isActive=1
                    AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)

INNER JOIN ClassStudentReltn CSR
ON CSR.classId = C.classId
AND CSR.isActive = 1
AND R.studentId = CSR.studentId

INNER JOIN Students S
ON R.studentId = S.studentId
AND S.isActive = 1 

WHERE R.<ADMINID>
AND R.studentId = [USERID]
  
GROUP BY R.registrationId
