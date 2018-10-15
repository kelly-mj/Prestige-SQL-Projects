-- CMN Students at 2nd Disbursement
-- Written by Zach (or Andrew)

SELECT
	CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(userZ.SID AS CHAR), '">', First, ' ', Last, '</a>') AS 'Student Name',
        PRG.programmeName as 'Program Name', userZ.Class_Name AS 'Class Name', userZ.Hours_Attended AS 'Hours Attended'
FROM Registrations REG
INNER JOIN Programmes PRG ON PRG.programmeId = REG.programmeId AND PRG.isActive = 1
INNER JOIN ProfileFieldValues PFV ON PFV.userid = REG.studentId AND 
                                                                 PFV.fieldName = '2ND_DISBURSEMENT' AND
                                                                 PFV.fieldValue = 'FALSE'
INNER JOIN(
		SELECT SDT.Firstname AS First, SDT.LastName AS Last, SDT.studentId AS SID, CLS.className AS Class_Name,
			       CLS.subjectId AS Subject_ID, FORMAT(SUM(ATD.duration),2) AS Hours_Attended
		FROM Attendance ATD
		INNER JOIN Students SDT ON ATD.studentId = SDT.studentId AND SDT.isActive = 1   -- 1 means active students only
		INNER JOIN Classes CLS ON ATD.classId = CLS.classId AND CLS.isActive=1
		WHERE NOT ATD.isActive=0
		GROUP BY ATD.studentId) AS userZ 
        ON REG.studentId = userZ.SID
WHERE REG.isActive=1 AND
	REG.endDate >= CURDATE() AND
        CASE PRG.programmeID
            WHEN 1 THEN Hours_Attended BETWEEN 375 AND 450
            WHEN 2 THEN Hours_Attended BETWEEN 325 AND 375
            WHEN 3 THEN Hours_Attended BETWEEN 375 AND 450 
		END AND
-- 1 = Aestetics
-- 2 = Massage
-- 3 = Instructor
        REG.<ADMINID> AND
	userZ.Subject_ID IN (SELECT GSR.subjectId
					FROM CourseGroups CGP
					INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
					WHERE REG.programmeId = CGP.programmeId and CGP.isActive=1)

ORDER BY Last
