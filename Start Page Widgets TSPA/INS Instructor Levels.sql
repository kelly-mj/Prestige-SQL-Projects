-- [TSPA] ADM Instructor Levels

Select DISTINCT CONCAT(STD.firstName, ' ', STD.lastName, '</a>') AS 'Student Name'
, PVF.FieldValue AS Team
, PRG.programmeName AS Program

FROM ProfileFieldValues PVF
INNER JOIN Students STD
               ON  PVF.UserID = STD.StudentID
INNER JOIN Registrations REG
               ON REG.studentID = STD.studentID
INNER JOIN Programmes PRG
               ON PRG.programmeID = REG.ProgrammeID AND PRG.programmeName NOT LIKE 'Career%' AND PRG.programmeName NOT LIKE 'Instruct%'

INNER JOIN
                     (SELECT PVF.usertype as UT, PVF.userID, PVF.fieldValue AS FV
                      FROM ProfileFieldValues PVF
                      WHERE PVF.usertype = 3 AND PVF.userID = [USERID]) AS TeamLeader ON TeamLeader.FV = PVF.fieldValue

WHERE FieldName = 'Team_name' and PVF.fieldValue != '' AND PVF.usertype != 3 AND REG.isActive = 1 AND STD.Isactive = 1 AND PVF.<ADMINID>
GROUP BY STD.lastname, STD.Firstname
ORDER BY STD.creationDtTm
