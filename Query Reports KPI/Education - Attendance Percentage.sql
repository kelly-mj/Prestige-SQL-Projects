-- 2019-07-16 - BBR - Attendance %

SELECT
  CMP.campusName,
  COUNT(DISTINCT STD.lastName, STD.firstName) AS StudentCount,
  concat(ROUND(100 * SUM(PHA.fieldValue) / SUM(PHS.fieldValue), 2),'%') AS 'Attendance %'
FROM Students STD
INNER JOIN Registrations REG ON REG.studentId = STD.studentId AND STD.isActive = 1 AND REG.isActive = 1 AND REG.regStatus=1 AND REG.startDate <= NOW()
INNER JOIN ProfileFieldValues PHS ON PHS.userId = STD.studentId AND PHS.fieldName = 'PROGRAM_HOURS_SCHEDULED'
INNER JOIN ProfileFieldValues PHA ON PHA.userId = STD.studentId AND PHA.fieldName = 'PROGRAM_HOURS_ATTENDED'
INNER JOIN Campuses CMP ON STD.studentCampus = CMP.campusCode
WHERE
STD.firstName NOT LIKE '%test%'
AND STD.studentId NOT IN (SELECT DISTINCT
    L.studentId
  FROM LeavesOfAbsence L
  WHERE L.isActive = 1
  AND L.leaveDate < NOW()
  AND (L.returnDate IS NULL
  OR L.returnDate > NOW()))

 AND STD.<ADMINID>
GROUP BY CMP.campusName
ORDER BY CMP.campusName
