/* -- Origionally created by Ottie
    -- moved to contacts while it is corrected, because it is showing incorrect information on student profile.



SELECT DISTINCT ATT.hoursAtt AS 'Hours Attended'
   , ROUND((SCH.hoursSch - TRN.hoursTrans), 2) AS 'Hours Scheduled'
   , ROUND((SCH.hoursSch - TRN.hoursTrans - ATT.hoursAtt), 2) AS 'Hours Remaining'

FROM Students S

INNER JOIN (
   SELECT PFV.userId
        , PFV.fieldValue AS hoursSch
        , PFV.profileFieldNameId
   FROM ProfileFieldValues PFV
    WHERE profileFieldNameId = 4002074
    ) AS SCH
ON SCH.userId = S.studentId

INNER JOIN (
   SELECT userId
        , fieldValue AS hoursAtt
        , profileFieldNameId
   FROM ProfileFieldValues
    WHERE profileFieldNameId = 4002072
    ) AS ATT
ON ATT.userId = S.studentId

INNER JOIN (
  SELECT userId
       , fieldValue AS hoursTrans
       , profileFieldNameId
           FROM ProfileFieldValues
    WHERE profileFieldNameId = 4002241
     ) AS TRN
ON TRN.userId = S.studentId

WHERE S.isActive = 1
AND S.studentId = [USERID]
AND S.<ADMINID> */
