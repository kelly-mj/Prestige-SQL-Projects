-- School: BENES
-- ADM, FIN, BOM VA Students
-- Written by: ??
-- Kelly MJ 1/28/19: Used PFV fields instead of calculation to determine students' hours attended and hours scheduled - may result in attended hours lagging by a day and artificially reducing student attendance percentage

( SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.firstName, ' ', SDT.lastName, '</a>') AS 'Student Name',
CASE WHEN SUM(ATD.duration)/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">',PRG.programmeName,'</font>')
            ELSE PRG.programmeName END AS Program,
CASE WHEN SUM(ATD.duration)/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">',CMP.campusName ,'</font>')
            ELSE CMP.campusName  END AS 'Campus',
CASE WHEN SUM(ATD.duration)/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">',REG.startdate,'</font>')
            ELSE REG.startdate END AS 'Start Date',
CASE WHEN SUM(ATD.duration)/(SCH.fieldValue * REG.enrollmentType)*100 <= 80 THEN CONCAT( '<div align="center">','<font color="red">'  , ROUND(100*SUM(ATD.duration)/SCH.fieldValue,2)  ,' %', '</font>','</div>')
            ELSE CONCAT( '<div align="center">',ROUND(100*SUM(ATD.duration)/(SCH.fieldValue * REG.enrollmentType),2),' %','</div>') END 'Atten. %',
CASE WHEN SUM(ATD.duration)/SCH.fieldValue*100 <= 80 THEN Concat('<font color="red">','At Risk','</font>')
            ELSE 'Satisfactory' END AS 'SAP'


FROM Registrations REG
INNER JOIN Students SDT ON REG.studentId = SDT.studentId AND SDT.isActive=1
INNER JOIN ClassStudentReltn CSR ON CSR.studentId = SDT.studentId AND CSR.isActive = 1
INNER JOIN Attendance ATD ON REG.studentId=ATD.studentId AND ATD.isActive=1
INNER JOIN Campuses CMP ON SDT.studentCampus = CMP.campusCode AND CMP.isActive=1
INNER JOIN Programmes PRG ON PRG.programmeId = REG.programmeId AND PRG.isActive=1
INNER JOIN ProfileFieldValues PVF ON REG.studentID = PVF.userID AND PVF.isActive=1
LEFT JOIN ProfileFieldValues SCH ON SCH.userId = REG.studentId AND SCH.isActive=1
INNER JOIN Classes C ON C.classId = ATD.classId AND C.isActive = 1
    AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=REG.programmeId AND CG.isActive=1 AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)
-- LEFT JOIN ProfileFieldValues ATT ON ATT.userId = REG.studentId AND ATT.isActive=1 AND ATT.fieldName = 'PROGRAM_HOURS_ATTENDED'

WHERE REG.<ADMINID>
  AND REG.isActive=1
  AND REG.enrollmentSemesterId = 4000441
  AND REG.endDate>=CURDATE()
  AND PVF.fieldName = 'VA_student'
  AND PVF.fieldValue = 'TRUE'
  AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'
  -- attendance record criteria
  AND ATD.attendanceDate >= REG.startDate
  AND ATD.classId = C.classId
  AND ATD.classId = CSR.classId

   
GROUP BY SDT.studentId
Order by CMP.campusName, SDT.lastName, PRG.programmeName ASC )

-- for VA students who haven't attended school yet
UNION (
SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.firstName, ' ', SDT.lastName, '</a>') AS 'Student Name'
    , PRG.programmeName
    , CMP.campusName
    , REG.startdate
    , 'N/A'
    , 'N/A'

FROM Students SDT
INNER JOIN Registrations REG ON REG.studentId = SDT.studentId AND REG.isActive = 1
INNER JOIN Programmes PRG ON PRG.programmeId = REG.programmeId AND PRG.isActive = 1
INNER JOIN Campuses CMP ON CMP.campusCode = SDT.studentCampus AND CMP.isActive = 1
INNER JOIN ProfileFieldValues PFV ON PFV.userId = SDT.studentId AND PFV.isActive = 1
    AND PFV.fieldName = 'VA_STUDENT' AND PFV.fieldValue = 'TRUE'
LEFT JOIN (
  SELECT studentId, SUM(duration) AS durSum
  FROM Attendance WHERE isActive = 1 GROUP BY studentId
  ) ATD ON ATD.studentId = SDT.studentId

WHERE REG.enrollmentSemesterId = 4000441
  AND REG.endDate >= CURDATE()
  AND SDT.<ADMINID>
  AND SDT.isActive = 1
  AND ATD.durSum <= 0

ORDER BY REG.startDate ASC )