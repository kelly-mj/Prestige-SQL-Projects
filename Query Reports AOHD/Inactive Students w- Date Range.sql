-- [AOHD] Inactive Student Report w/ Date Range
-- Kelly MJ  |  6/10/2019

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name
	, P.programmeName AS Program
    , SCH.fieldValue AS 'Schedule'
    , DATE_FORMAT(R.graduationDate, '%m/%d/%Y') AS 'Drop Date'
    , R.registrationNote AS 'Registration Notes'
    
FROM Students S
INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
	ON RR.studentId = S.studentID
INNER JOIN Registrations R ON R.studentId = S.studentId
	AND R.registrationId = RR.maxReg
INNER JOIN Programmes P ON P.programmeId = R.programmeId
INNER JOIN StatusSequences SS ON SS.statusId = S.isActive
LEFT JOIN ( SELECT * FROM ProfileFieldValues 
			WHERE fieldName = 'SCHEDULE_' ) SCH ON SCH.userId = S.studentId

WHERE R.graduationDate BETWEEN '[?From Date]' AND '[?To Date]'
AND SS.statusName IN ('Inactive/Past Student/Dropped', 'Inactive/Past student/Withdrawn')
AND S.<ADMINID>

ORDER BY R.graduationDate ASC, S.lastName