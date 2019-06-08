-- [TSPA] ADM Current Enrolled Students in School for Monthly Billing
-- Kelly MJ 05-31-2019: Excluded students without an active class enrollment
-- Kelly MJ 06-08-2019: Added requirement: R.startDate <= CURDATE()

SELECT COUNT(Distinct S.studentId) 'Total Enrolled Students'
FROM Students S
    , Registrations R
    , Programmes P
    , ClassStudentReltn CSR
WHERE S.isActive = 1
    AND S.<ADMINID>
    AND R.studentId=S.studentId
    AND R.regStatus = 1
    AND R.isActive = 1
    AND R.startDate <= CURDATE()
    AND P.isActive = 1
    AND CSR.studentId = S.studentId
    AND CSR.isActive = 1
    AND CSR.status = 0
    AND P.programmeId = R.programmeId
    AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)
    AND S.firstName NOT LIKE '%test%'
