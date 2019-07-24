-- [SSI] Student Schedule Report
-- Kelly MJ  |  07/23/2019

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name
	, P.programmeName AS Program
    , SS.statusName AS Status
    , CONCAT('$', ROUND(COALESCE(SL.owed, 0), 2)) '<div style="text-align: left;">Contract Amount</div>'
    , FORMAT(COALESCE(A.hoursAttended, 0), 2) 'Hours thru To_Date'
    , CONCAT('$', ROUND(COALESCE(SL.paid, 0), 2)) '<div style="text-align: left;">Amount Paid thru To_Date</div>'

FROM Students S
INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
	ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
	AND R.registrationId = RR.maxReg
INNER JOIN Programmes P ON P.programmeId = R.programmeId
INNER JOIN StatusSequences SS ON SS.statusId = S.isActive
LEFT JOIN (SELECT CSR.registrationId, FORMAT(SUM(A.duration), 2) AS hoursAttended
			FROM ClassStudentReltn CSR
            INNER JOIN Attendance A ON A.studentId = CSR.studentId
            WHERE CSR.isActive = 1
            AND A.isActive = 1
            AND A.classId = CSR.classId
            AND A.attendanceDate >= (SELECT startDate FROM Registrations WHERE registrationId = CSR.registrationId)
            AND A.attendanceDate <= '[?To Date]'
            GROUP BY CSR.registrationId) A
	ON A.registrationId = RR.maxReg
LEFT JOIN (SELECT registrationId
				, ABS(SUM(credit)) AS paid
				, SUM(debit) AS owed
            FROM StudentLedger
            WHERE billingDate <= '[?To Date]'
            GROUP BY registrationId) AS SL
	ON SL.registrationId = R.registrationId

WHERE R.isActive = 1
AND SS.isActive = 1
AND S.isActive IN (1, 12)
AND S.<ADMINID>

GROUP BY S.studentId
ORDER BY S.lastName
