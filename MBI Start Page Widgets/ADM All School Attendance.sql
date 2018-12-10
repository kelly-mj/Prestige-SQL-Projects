SELECT CONCAT('<a target="_blank" href="https://mbi.orbund.com/einstein-freshair/admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS name
    , SUM(A.duration) AS totalHours
	, R.startDate

FROM Students S

INNER JOIN (
	SELECT studentId, MAX(startDate) AS maxDate FROM Registrations R WHERE isActive = 1 GROUP BY studentId ) AS RR
    ON RR.studentId = S.studentId

INNER JOIN Registrations R
	ON R.studentId = S.studentId 
    AND R.startDate = RR.maxDate
    
LEFT JOIN Attendance A
	ON A.studentId = S.studentId
    AND A.isActive = 1
    AND A.classId IN (SELECT classId FROM Classes WHERE className NOT LIKE '%intern%' AND className NOT LIKE '%ic%')

WHERE S.isActive = 1
	AND S.<ADMINID>
    
GROUP BY S.studentId