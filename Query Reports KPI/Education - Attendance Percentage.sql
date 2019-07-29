-- 2019-07-16 - BBR - Attendance %
-- 2019-07-24 - Kelly MJ - Subtracts daily scheduled hours so attendance and scheduled hours are both for previous day.

SELECT
  CMP.campusName,
  COUNT(DISTINCT STD.studentId) AS StudentCount,
  concat(ROUND(100 * SUM(PHA.fieldValue) / SUM(PHS.fieldValue-COALESCE(CSR.lessonDuration)), 2),'%') AS 'Attendance %'
FROM Students STD
INNER JOIN Registrations REG ON REG.studentId = STD.studentId AND STD.isActive = 1 AND REG.isActive = 1 AND REG.regStatus=1 AND REG.startDate <= NOW()
LEFT JOIN ProfileFieldValues PHS ON PHS.userId = STD.studentId AND PHS.fieldName = 'PROGRAM_HOURS_SCHEDULED'
LEFT JOIN ProfileFieldValues PHA ON PHA.userId = STD.studentId AND PHA.fieldName = 'PROGRAM_HOURS_ATTENDED'
INNER JOIN Campuses CMP ON STD.studentCampus = CMP.campusCode
LEFT JOIN (
    SELECT CSR.studentId, CSR.classId, C.lessonDuration
    FROM ClassStudentReltn CSR
    INNER JOIN ClassSchedules CS ON CS.classId = CSR.classId
    INNER JOIN Classes C ON C.classId = CSR.classId
    WHERE CS.dayNum = DAYOFWEEK(CURDATE()) - 1
      AND CSR.isActive = 1
      AND CSR.status = 0
    GROUP BY CSR.studentId
    ) CSR
    ON CSR.studentId = STD.studentId

WHERE
STD.firstName NOT LIKE '%test%'
AND STD.studentId NOT IN (SELECT DISTINCT
    L.studentId
  FROM LeavesOfAbsence L
  WHERE L.isActive = 1
  AND L.leaveDate < NOW()
  AND (L.returnDate IS NULL
  OR L.returnDate > NOW()))
  AND CMP.isActive = 1

 AND STD.<ADMINID>
GROUP BY CMP.campusName
ORDER BY CMP.campusName
