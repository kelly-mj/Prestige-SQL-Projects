-- [AOHD] ADM Inactive Students from Past 30 Days
-- Kelly MJ  |  6/10/2019

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name
	, CMP.campusName AS Campus
	, P.programmeName AS Program
    , DATE_FORMAT(R.graduationDate, '%m/%d/%Y') AS 'Drop Date'

FROM Students S
INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
	ON RR.studentId = S.studentID
INNER JOIN Registrations R ON R.studentId = S.studentId
	AND R.registrationId = RR.maxReg
INNER JOIN Programmes P ON P.programmeId = R.programmeId
INNER JOIN StatusSequences SS ON SS.statusId = S.isActive
INNER JOIN Campuses CMP ON CMP.campusCode = S.studentCampus

WHERE R.graduationDate > DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
AND SS.statusName IN ('Inactive/Past Student/Dropped', 'Inactive/Past student/Withdrawn')
AND S.<ADMINID>

ORDER BY CMP.campusName, S.lastName
