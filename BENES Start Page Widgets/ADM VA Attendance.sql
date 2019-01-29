-- School: BENES
-- ADM VA Students
-- Writteb by: ??

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(SDT.studentId AS CHAR), '">', SDT.firstName, ' ', SDT.lastName, '</a>') AS 'Student Name',
CASE WHEN SUM(ATD.duration)/SUM(CLS.lessonDuration)*100 <= 80 THEN Concat('<font color="red">',PRG.programmeName,'</font>')
            ELSE PRG.programmeName END AS Program,
CASE WHEN SUM(ATD.duration)/SUM(CLS.lessonDuration)*100 <= 80 THEN Concat('<font color="red">',CMP.campusName ,'</font>')
            ELSE CMP.campusName  END AS 'Campus',
CASE WHEN SUM(ATD.duration)/SUM(CLS.lessonDuration)*100 <= 80 THEN Concat('<font color="red">',REG.startdate,'</font>')
            ELSE REG.startdate END AS 'Start Date',
      
CASE WHEN SUM(ATD.duration)/(SUM(CLS.lessonDuration) * REG.enrollmentType)*100 <= 80 THEN CONCAT( '<div align="center">','<font color="red">'  , ROUND(100*SUM(ATD.duration)/SUM(CLS.lessonDuration),2)  ,' %', '</font>','</div>')
            ELSE CONCAT( '<div align="center">',ROUND(100*SUM(ATD.duration)/(SUM(CLS.lessonDuration) * REG.enrollmentType),2),' %','</div>') END AS Attendance_Percentage,
CASE WHEN SUM(ATD.duration)/SUM(CLS.lessonDuration)*100 <= 80 THEN Concat('<font color="red">','At Risk','</font>')
            ELSE 'Satisfactory' END AS 'SAP'


FROM Registrations REG
INNER JOIN Attendance ATD ON REG.studentId=ATD.studentId AND ATD.isActive=1
INNER JOIN Classes CLS ON ATD.classId = CLS.classId AND CLS.isActive=1
INNER JOIN Students SDT ON REG.studentId = SDT.studentId AND SDT.isActive=1
INNER JOIN Campuses CMP ON SDT.studentCampus = CMP.campusCode AND CMP.isActive=1
INNER JOIN Programmes PRG ON PRG.programmeId = REG.programmeId AND PRG.isActive=1
INNER JOIN ProfileFieldValues PVF ON REG.studentID = PVF.userID AND PVF.isActive=1
WHERE
  REG.<ADMINID> AND REG.isActive=1 AND
  REG.enrollmentSemesterId = 4000441 AND
    REG.endDate>=CURDATE() AND PVF.fieldName = 'VA_student' AND PVF.fieldValue = 'TRUE' 
   
GROUP BY SDT.studentId
Order by CMP.campusName, SDT.lastName, PRG.programmeName ASC