-- ADM Students at 2nd Disbursement
-- Written by Zach or Andrew
-- 10/11/18 Kelly MJ: Added CSR constraint to fix attendance hours

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(userZ.SID AS CHAR), '">', First, ' ', Last, '</a>') AS 'Student Name'
    , PRG.programmeName as 'Program Name'
    , userZ.Class_Name AS 'Class Name'
    , userZ.Hours_Attended AS 'Hours Attended'
FROM Registrations REG
INNER JOIN Programmes PRG
	ON PRG.programmeId = REG.programmeId
	AND PRG.isActive = 1
INNER JOIN ProfileFieldValues PFV
	ON PFV.userid = REG.studentId
	AND PFV.fieldName = '2ND_DISBURSEMENT' AND PFV.fieldValue = 'FALSE'
INNER JOIN (
	SELECT SDT.Firstname AS First
		, SDT.LastName AS Last
		, SDT.studentId AS SID
		, CLS.className AS Class_Name
		, CLS.subjectId AS Subject_ID
		, FORMAT(SUM(ATD.duration),2) AS Hours_Attended
	FROM Attendance ATD
	INNER JOIN Students SDT
		ON ATD.studentId = SDT.studentId
		AND SDT.isActive = 1   -- 1 means active students only
	INNER JOIN Registrations R
		ON R.studentId = SDT.studentId
	INNER JOIN (SELECT studentId, MAX(startDate) AS maxStartDate FROM Registrations GROUP BY studentId) RR
		ON RR.studentId = R.studentId AND RR.maxStartDate = R.startDate
	INNER JOIN Classes CLS
		ON ATD.classId = CLS.classId
		AND CLS.isActive=1
		AND CLS.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
          WHERE CG.programmeId=R.programmeId AND CG.isActive=1
                    AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)
	INNER JOIN ClassStudentReltn CSR
		ON CSR.studentId = ATD.studentId
		AND CSR.classId = CLS.classId
		AND CSR.isActive = 1
	WHERE ATD.isActive = 1
	  AND ATD.attendanceDate >= R.startDate
	GROUP BY ATD.studentId) AS userZ 
    ON REG.studentId = userZ.SID
WHERE REG.isActive=1
AND REG.endDate >= CURDATE()
AND CASE PRG.programmeID
    	WHEN 1 THEN Hours_Attended BETWEEN 375 AND 450
        WHEN 2 THEN Hours_Attended BETWEEN 325 AND 375
        WHEN 3 THEN Hours_Attended BETWEEN 375 AND 450 
		END
-- 1 = Aestetics
-- 2 = Massage
-- 3 = Instructor
AND REG.<ADMINID>
/*AND userZ.Subject_ID IN (SELECT GSR.subjectId
					FROM CourseGroups CGP
					INNER JOIN GroupSubjectReltn GSR ON CGP.courseGroupId=GSR.courseGroupId AND GSR.isActive=1
					WHERE REG.programmeId = CGP.programmeId and CGP.isActive=1)*/

ORDER BY Last