-- School: BENES
-- ADM, FIN, BOM VA Students
-- Written by: ??
-- Kelly MJ 1/28/19: Used PFV fields instead of calculation to determine students' hours attended and hours scheduled - may result in attended hours lagging by a day and artificially reducing student attendance percentage

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.firstName, ' ', SDT.lastName, '</a>') AS 'Student Name',
CASE WHEN ATT.fieldValue/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">',PRG.programmeName,'</font>')
            ELSE PRG.programmeName END AS Program,
CASE WHEN ATT.fieldValue/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">',CMP.campusName ,'</font>')
            ELSE CMP.campusName  END AS 'Campus',
CASE WHEN ATT.fieldValue/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">',REG.startdate,'</font>')
            ELSE REG.startdate END AS 'Start Date',
CASE WHEN ATT.fieldValue/(SCH.fieldValue * REG.enrollmentType)*100 <= 80 THEN CONCAT( '<div align="center">','<font color="red">'  , ROUND(100*ATT.fieldValue/SCH.fieldValue,2)  ,' %', '</font>','</div>')
            ELSE CONCAT( '<div align="center">',ROUND(100*ATT.fieldValue/(SCH.fieldValue * REG.enrollmentType),2),' %','</div>') END 'Atten. %',
CASE WHEN ATT.fieldValue/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">','At Risk','</font>')
            ELSE 'Satisfactory' END AS 'SAP'


FROM Registrations REG
INNER JOIN Students SDT ON REG.studentId = SDT.studentId AND SDT.isActive=1
INNER JOIN ClassStudentReltn CSR ON CSR.studentId = SDT.studentId AND CSR.isActive = 1
-- INNER JOIN Attendance ATD ON REG.studentId=ATD.studentId AND ATD.isActive=1
INNER JOIN Campuses CMP ON SDT.studentCampus = CMP.campusCode AND CMP.isActive=1
INNER JOIN Programmes PRG ON PRG.programmeId = REG.programmeId AND PRG.isActive=1
INNER JOIN ProfileFieldValues PVF ON REG.studentID = PVF.userID AND PVF.isActive=1
LEFT JOIN ProfileFieldValues SCH ON SCH.userId = REG.studentId AND SCH.isActive=1
LEFT JOIN ProfileFieldValues ATT ON ATT.userId = REG.studentId AND ATT.isActive=1 AND ATT.fieldName = 'PROGRAM_HOURS_ATTENDED'

WHERE REG.<ADMINID>
  AND REG.isActive=1
  AND REG.enrollmentSemesterId = 4000441
  AND REG.endDate>=CURDATE()
  AND PVF.fieldName = 'VA_student'
  AND PVF.fieldValue = 'TRUE'
  AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'
   
GROUP BY SDT.studentId
Order by CMP.campusName, SDT.lastName, PRG.programmeName ASC