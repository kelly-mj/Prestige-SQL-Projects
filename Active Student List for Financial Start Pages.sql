-- [BENES] Active Student List for Financial Start Pages
-- Unknown author  |  Last updated 7/12/2019

SELECT
	CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', CAST(SDT.lastName AS CHAR), ', ', CAST(SDT.firstName AS CHAR), '</a>') AS Name,
	PGM.programmeName AS Program_Name,
	CMP.campusName AS Campus_Name,
	PFV.fieldValue AS 'Schedule Type',
    SSS.StatusName,
	(SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = SDT.studentId AND fieldName = 'PROGRAM_HOURS_ATTENDED') AS Hours_Attended


FROM Students SDT
	INNER JOIN Registrations	REG ON SDT.studentId = REG.studentId AND  REG.isActive = 1
	INNER JOIN Programmes 	PGM ON REG.programmeId = PGM.programmeId AND  PGM.isActive = 1
	INNER JOIN Campuses          CMP ON SDT.studentCampus = CMP.campusCode AND CMP.isActive = 1
    INNER JOIN StatusSequences SSS ON SSS.statusId = SDT.isActive AND SSS.seqNum = 1 AND  SSS.isActive = 1 AND SSS.<ADMINID>
	LEFT JOIN ProfileFieldValues PFV ON PFV.userId = SDT.studentId AND PFV.isActive=1 AND PFV.fieldName = 'ATTENDANCE_INFO'

WHERE
	REG.<ADMINID>						AND
	REG.isActive = 1				AND
	REG.enrollmentSemesterId = 4000441	AND
	SSS.StatusID AND SSS.statusID NOT IN (0,3)

GROUP BY SDT.studentId
ORDER BY CMP.campusName, SDT.lastName
