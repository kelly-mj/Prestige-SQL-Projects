-- DEL SDT: Your Current Hours

SELECT FORMAT(SUM(A.duration),2) as "Total Hours Attended in Program"

FROM Registrations R, Attendance A, Classes C, ClassStudentReltn CSR

WHERE R.<ADMINID> and R.isActive=1 
and R.studentId=[USERID] 
and R.studentId=A.studentId and A.attendanceDate>=R.startDate and A.isActive=1
and A.classId=C.classId and C.isActive=1 AND CSR.classId=C.classId AND CSR.studentId=A.studentId AND CSR.isActive<>0
and C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=R.programmeId and CG.isActive=1 and CG.courseGroupId=GSR.courseGroupId and GSR.isActive=1)

GROUP BY R.registrationId