-- [AOHD] Inactive Students w/ Date Range
-- Kelly MJ  |  6/10/2019

SELECT (SELECT campusName FROM Campuses WHERE S.studentCampus = campusCode) AS 'Campus'
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name
	, P.programmeName AS Program
    , SCH.fieldValue AS 'Schedule'
    , DATE_FORMAT(R.graduationDate, '%m/%d/%Y') AS 'Grad/Drop Date'
	, SS.statusName AS 'Status'
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
AND S.<ADMINID>
-- user input filters
AND IF('[?Campus]' <> ''
		, ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = S.studentCampus)
			OR S.studentCampus = '[?Campus]')
		, S.<ADMINID> /* dummy condition */ )
AND S.isActive = '[?Student type{3|Graduated|0|Inactive/Past Student/Withdrawn|17|Inactive/Past Student/Dropped}]'

GROUP BY R.registrationId
ORDER BY R.graduationDate ASC, S.lastName
