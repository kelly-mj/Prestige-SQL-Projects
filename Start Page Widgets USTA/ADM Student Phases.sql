-- Widget (Admin view): Student Phases
-- Author: Kelly MJ  |  8/13/2018
   -- Displays student id number, name, enrolled class, and current phase

SELECT
    CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS 'Name'
    , MAX(C.className) AS Class
    , CASE WHEN PFV.fieldValue IS NOT NULL THEN PFV.fieldValue
           ELSE 'No phase selected'
      END AS Phase

FROM
    Students S

INNER JOIN 
    ClassStudentReltn CSR
    ON CSR.studentId = S.studentId

INNER JOIN
    Classes C
    ON C.classId = CSR.classId

INNER JOIN
    ClassTeacherReltn CTR
    ON CTR.classId = CSR.classId

LEFT JOIN
    ProfileFieldValues PFV
    ON PFV.userId = S.studentId
    AND PFV.fieldName LIKE 'PHASE'

WHERE S.<ADMINID>

GROUP BY S.studentId
ORDER BY S.lastName