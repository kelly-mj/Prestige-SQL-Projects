-- [TSPA] STF Active Student List for Financial State Pages

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', CAST(SDT.lastName AS CHAR), ', ', CAST(SDT.firstName AS CHAR), '</a>') AS Name
	, PGM.programmeName AS Program
	, CMP.campusName AS Campus
	, PFV.fieldValue AS 'Hours Attended'

FROM Registrations REG
	INNER JOIN Programmes PGM ON REG.programmeId = PGM.programmeId
	INNER JOIN Students SDT ON REG.studentId = SDT.studentId
	INNER JOIN Campuses CMP ON SDT.studentCampus = CMP.campusCode
	LEFT JOIN ProfileFieldValues PFV ON PFV.userId = SDT.studentId
	INNER JOIN ClassStudentReltn CSR ON CSR.studentId = SDT.studentId

WHERE CMP.isActive = 1
	AND CSR.isActive = 1
	AND CSR.status = 0
	AND PFV.fieldName = 'PROGRAM_HOURS_ATTENDED'
	AND PGM.isActive = 1
	AND REG.isActive = 1
	AND REG.regStatus = 1
	AND SDT.isActive = 1
	AND SDT.<ADMINID>

GROUP BY SDT.studentId

ORDER BY CMP.campusName, SDT.lastName
