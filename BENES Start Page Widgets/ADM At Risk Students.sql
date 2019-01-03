-- BENES ADM At Risk Students
-- Written by Andrew
-- Kelly MJ 1/3/19: Added case for when lda is in a separate year than the current date

SELECT Name AS 'Student'
,ClassName AS Class
, CONCAT('<div align="center">', lda,'</div>') AS 'Last Day Attended'
, CASE WHEN DifD >= 14 THEN CONCAT('<div align="center">','<font color="red">', Difd, '</font>','</div>') ELSE CONCAT('<div align="center">', Difd, '</div>')  END AS 'Consecutive Days Absent'

FROM
(
SELECT Name,Classname, lda, ((DATEDIFF(CURRENT_DATE, lda)) -
( 2 * IF(YEAR(CURDATE()) <= YEAR(lda), (WEEK(CURRENT_DATE) - WEEK(lda)), 52*(YEAR(CURDATE()) - YEAR(lda) - 1) + 52 - WEEK(lda) + WEEK(CURDATE())) ) -
(case when weekday(CURRENT_DATE) = 6 then 1 else 0 end) -
(case when weekday(lda) = 5 then 1 else 0 end)) as DifD
, DATEDIFF(CURRENT_DATE, lda) as date_diff
, (WEEK(CURRENT_DATE) - WEEK(lda)) * 2 as week_diff
, case when weekday(CURRENT_DATE) = 6 then 1 else 0 end AS isSun
, case when weekday(lda) = 5 then 1 else 0 end AS isSat
FROM(
SELECT Distinct A.studentID,C.ClassName, CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name, MAX(A.attendanceDate) as lda
FROM Attendance A
INNER JOIN Classes C 
ON A.classId = C.classId
INNER JOIN ClassStudentReltn R 
ON  C.classId = R.classId
AND A.studentId = R.studentId 
INNER JOIN 
(SELECT RR.registrationId, RR.studentID  
FROM Registrations RR 
WHERE RR.isActive=1 
AND RR.regstatus = 1) AS REG ON REG.RegistrationID = R.registrationId 
INNER JOIN Students S 
ON S.studentID = REG.studentID 
AND S.<ADMINID>
WHERE C.isActive=1 AND R.isActive=1 AND A.isActive=1 AND A.present > 0 AND A.AttendanceDate  BETWEEN (CURRENT_DATE - INTERVAL 60 DAY) AND CURRENT_DATE
AND S.studentID NOT IN (SELECT LOA.StudentID FROM LeavesOfAbsence LOA WHERE LOA.isactive = 1 AND LOA.returnDate IS NULL OR LOA.returndate = '') 
GROUP BY A.studentID) as t1) as t2
WHERE DifD > 7
ORDER BY DifD DESC