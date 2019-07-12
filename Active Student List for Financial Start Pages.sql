SELECT
	CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', CAST(SDT.firstName AS CHAR), ' ', CAST(SDT.lastName AS CHAR), '</a>') AS Name,
	-- REG.registrationId AS KeyZ,
	-- ATD.subjectId AS Subject_ID,
	-- ATD.classId AS Class_ID,
	PGM.programmeName AS Program_Name,
	CMP.campusName AS Campus_Name,
    SSS.StatusName,
	FORMAT(SUM(ATD.duration),2) AS Hours_Attended

FROM Attendance ATD
	INNER JOIN Registrations	REG ON ATD.studentId = REG.studentId AND  REG.isActive = 1
	INNER JOIN Programmes 	PGM ON REG.programmeId = PGM.programmeId AND  PGM.isActive = 1
	INNER JOIN Students 		SDT ON REG.studentId = SDT.studentId
	INNER JOIN Campuses          CMP ON SDT.studentCampus = CMP.campusCode AND CMP.isActive = 1
        INNER JOIN StatusSequences SSS ON SSS.statusId = SDT.isActive AND SSS.seqNum = 1 AND  SSS.isActive = 1 AND SSS.<ADMINID>

WHERE
	REG.<ADMINID>						AND
	REG.isActive = 1				AND
	REG.enrollmentSemesterId = 4000441	AND
	SSS.StatusID AND SSS.statusID NOT IN (0,3) AND
	ATD.subjectId IN (SELECT GSR.subjectId
			FROM CourseGroups CGP
			INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
			WHERE REG.programmeId = CGP.programmeId and CGP.isActive=1)
										AND
	ATD.classId IN (SELECT DISTINCT CRS.classId
			From ClassStudentReltn CRS
			Where CRS.studentId = ATD.studentId AND CRS.isActive=1)
GROUP BY ATD.studentId
ORDER BY CMP.campusName, SDT.firstName
