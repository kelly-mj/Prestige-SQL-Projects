-- BENES Report: Summit Team Members By Campus COLOR tables
-- Written by: Andrew

SELECT *
FROM (SELECT CONCAT('</td></tr><tr><td></td><td colspan="6" style="text-align: left; background-color: #01E37F; font-size: 125%; font-weight: bold;">'
                    ,'Team Leader: ',Ucase(T.firstname),' ', UCASE(T.lastname), '</td></tr>') AS Name
,PVF.FieldValue AS TEAM
,NULL AS Course
,NULL AS Level
,NULL AS Campus
FROM
    ProfileFieldValues PVF
INNER JOIN Teachers T
		ON T.TeacherID = PVF.userID
WHERE
    PVF.usertype = 3
	AND FieldName = 'TEAM_TENACIOUS'
	AND PVF.isActive = 1
    AND T.Isactive = 1
    AND T.CampusCode =  34652
GROUP BY PVF.FieldValue
UNION
SELECT
      CONCAT(CONCAT(UCASE(SUBSTRING(Firstname, 1, 1)),LCASE(SUBSTRING(Firstname, 2)))," ",
	  CONCAT(UCASE(SUBSTRING(LastName, 1, 1)),LCASE(SUBSTRING(LastName, 2)))) AS Lastname
	 ,PVF.FieldValue AS TEAM
     ,PRG.programmeName AS Program
     ,CASE
        WHEN StudentLevel.Level = 'Level 1' THEN CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 1', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 2' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 2', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 3' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 3', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 4' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 4', '</div>','</font>')
        ELSE CONCAT('No Level')
    END AS Level
, CASE WHEN STD.studentCampus = 34652 THEN 'New Port Richey'
	   WHEN STD.studentCampus = 34606 THEN 'Spring Hill'
       WHEN STD.studentCampus = 34601 THEN 'Brooksville'
       ELSE 'Unknown/Other'
	   END AS Campus
FROM
    ProfileFieldValues PVF
        INNER JOIN Students STD
                ON PVF.UserID = STD.StudentID
        INNER JOIN Registrations REG
                ON REG.studentID = STD.studentID
        INNER JOIN Programmes PRG
                ON PRG.programmeID = REG.ProgrammeID
        AND PRG.programmeName NOT LIKE 'Career%'
        AND PRG.programmeName NOT LIKE 'Instruct%'
        AND REG.enrollmentSemesterId = 4000441
        INNER JOIN
    (SELECT
        PVF.userID AS UID, Fieldvalue AS Level
    FROM
        ProfileFieldValues PVF
    WHERE
        FieldName = 'STUDENT_LEVEL' AND PVF.<ADMINID>) AS StudentLevel ON StudentLevel.UID = PVF.userID
WHERE
    FieldName = 'Team_name'
        AND PVF.fieldValue != ''
        AND PVF.usertype != 3
        AND REG.isActive = 1
        AND STD.Isactive = 1
        AND PVF.isActive = 1
        AND STD.studentCampus = 34652
GROUP BY STD.lastname , STD.Firstname
ORDER BY Team) AS t1


UNION

SELECT *
FROM (SELECT CONCAT('</td></tr><tr><td></td><td colspan="6" style="text-align: left; background-color:#01E37F; font-size: 125%; font-weight: bold;">','Team Leader: '
				,Ucase(T.firstname),' ', UCASE(T.lastname), '</td></tr>') AS Name
,PVF.FieldValue AS TEAM
,NULL AS Course
,NULL AS Level
,NULL AS Campus
FROM
    ProfileFieldValues PVF
INNER JOIN Teachers T
		ON T.TeacherID = PVF.userID
WHERE
    PVF.usertype = 3
	AND FieldName = 'TEAM_TENACIOUS'
	AND PVF.isActive = 1
    AND T.Isactive = 1
    AND T.CampusCode =  34606
GROUP BY PVF.FieldValue
UNION
SELECT

    CONCAT(CONCAT(UCASE(SUBSTRING(Firstname, 1, 1)),LCASE(SUBSTRING(Firstname, 2)))," ",
                CONCAT(UCASE(SUBSTRING(LastName, 1, 1)),LCASE(SUBSTRING(LastName, 2)))) AS Lastname
	,PVF.FieldValue AS TEAM
   ,PRG.programmeName AS Program
    ,CASE
        WHEN StudentLevel.Level = 'Level 1' THEN CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 1', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 2' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 2', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 3' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 3', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 4' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 4', '</div>','</font>')
        ELSE CONCAT('No Level')
    END AS Level
, CASE WHEN STD.studentCampus = 34652 THEN 'New Port Richey'
	   WHEN STD.studentCampus = 34606 THEN 'Spring Hill'
       WHEN STD.studentCampus = 34601 THEN 'Brooksville'
       ELSE 'Unknown/Other'
	   END AS Campus
FROM
    ProfileFieldValues PVF
        INNER JOIN Students STD
                ON PVF.UserID = STD.StudentID
        INNER JOIN Registrations REG
                ON REG.studentID = STD.studentID
        INNER JOIN Programmes PRG
                ON PRG.programmeID = REG.ProgrammeID
        AND PRG.programmeName NOT LIKE 'Career%'
        AND PRG.programmeName NOT LIKE 'Instruct%'
        AND REG.enrollmentSemesterId = 4000441
        INNER JOIN
    (SELECT
        PVF.userID AS UID, Fieldvalue AS Level
    FROM
        ProfileFieldValues PVF
    WHERE
        FieldName = 'STUDENT_LEVEL' AND PVF.<ADMINID>) AS StudentLevel ON StudentLevel.UID = PVF.userID
WHERE
    FieldName = 'Team_name'
        AND PVF.fieldValue != ''
        AND PVF.usertype != 3
        AND REG.isActive = 1
        AND STD.Isactive = 1
        AND PVF.isActive = 1
        AND STD.studentCampus = 34606
GROUP BY STD.lastname , STD.Firstname
ORDER BY Team) AS t2

UNION

SELECT *
FROM (SELECT CONCAT('</td></tr><tr><td></td><td colspan="6" style="text-align: left; background-color: #01E37F; font-size: 125%; font-weight: bold;">','Team Leader: '
				,Ucase(T.firstname),' ', UCASE(T.lastname), '</td></tr>') AS Name
,PVF.FieldValue AS TEAM
,NULL AS Course
,NULL AS Level
,NULL AS Campus
FROM
    ProfileFieldValues PVF
INNER JOIN Teachers T
		ON T.TeacherID = PVF.userID
WHERE
    PVF.usertype = 3
	AND FieldName = 'TEAM_TENACIOUS'
	AND PVF.isActive = 1
    AND T.Isactive = 1
    AND T.CampusCode =  34601
GROUP BY PVF.FieldValue
UNION
SELECT

    CONCAT(CONCAT(UCASE(SUBSTRING(Firstname, 1, 1)),LCASE(SUBSTRING(Firstname, 2)))," ",
                CONCAT(UCASE(SUBSTRING(LastName, 1, 1)),LCASE(SUBSTRING(LastName, 2)))) AS Lastname
	,PVF.FieldValue AS TEAM
   ,PRG.programmeName AS Program
    ,CASE
        WHEN StudentLevel.Level = 'Level 1' THEN CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 1', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 2' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 2', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 3' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 3', '</div>','</font>')
        WHEN StudentLevel.Level = 'Level 4' THEN  CONCAT('<font color="white">','<div style="background-color:#5AA5DD; ; width: 100%; height:100%; margin:-3px -3px -3px -3.75px; padding:4px 4px 2px 4px""> ' , 'Level 4', '</div>','</font>')
        ELSE CONCAT('No Level')
    END AS Level
, CASE WHEN STD.studentCampus = 34652 THEN 'New Port Richey'
	   WHEN STD.studentCampus = 34606 THEN 'Spring Hill'
       WHEN STD.studentCampus = 34601 THEN 'Brooksville'
       ELSE 'Unknown/Other'
	   END AS Campus
FROM
    ProfileFieldValues PVF
        INNER JOIN Students STD
                ON PVF.UserID = STD.StudentID
        INNER JOIN Registrations REG
                ON REG.studentID = STD.studentID
        INNER JOIN Programmes PRG
                ON PRG.programmeID = REG.ProgrammeID
        AND PRG.programmeName NOT LIKE 'Career%'
        AND PRG.programmeName NOT LIKE 'Instruct%'
        AND REG.enrollmentSemesterId = 4000441
        INNER JOIN
    (SELECT
        PVF.userID AS UID, Fieldvalue AS Level
    FROM
        ProfileFieldValues PVF
    WHERE
        FieldName = 'STUDENT_LEVEL' AND PVF.<ADMINID>) AS StudentLevel ON StudentLevel.UID = PVF.userID
WHERE
    FieldName = 'Team_name'
        AND PVF.fieldValue != ''
        AND PVF.usertype != 3
        AND REG.isActive = 1
        AND STD.Isactive = 1
        AND PVF.isActive = 1
        AND STD.studentCampus = 34601
GROUP BY STD.lastname , STD.Firstname
ORDER BY Team) AS t3
