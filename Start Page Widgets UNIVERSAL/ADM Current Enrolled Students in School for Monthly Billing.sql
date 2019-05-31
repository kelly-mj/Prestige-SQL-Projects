SELECT COUNT(Distinct S.studentId) 'Total Enrolled Students'
FROM Students S
,Registrations R, Programmes P
WHERE S.isActive = 1
AND S.<ADMINID>
AND R.studentId=S.studentId
AND R.regStatus = 1
AND R.isActive = 1
AND P.isActive = 1
AND P.programmeId = R.programmeId
AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)
AND S.firstName NOT LIKE '%test%'
