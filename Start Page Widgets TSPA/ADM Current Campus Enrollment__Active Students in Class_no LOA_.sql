-- Current Campus Enrollment -  - Active Students in Class ( no LOA )

SELECT  CMP.CampusName AS 'Campus Name',
Count(Distinct STD.Lastname,STD.Firstname) AS Students,
Count(DISTINCT TCH.lastname, TCH.firstname) AS Teachers,
CONCAT('<div align="center">',Round(Count(DISTINCT STD.lastname,STD.firstname) / Count(Distinct TCH.Lastname,TCH.firstname)),'',' To 1','</div>') AS 'Students Per Teacher'
FROM Students STD
INNER JOIN Registrations REG ON REG.studentID = STD.studentID AND STD.isactive = 1 And REG.isactive = 1
INNER JOIN Campuses CMP ON CMP.CampusCode = REG.studentCampus AND CMP.isactive = 1 AND CMP.<ADMINID>
INNER JOIN Teachers TCH ON TCH.campusCode = CMP.CampusCode Where TCH.Isactive = 1 AND TCH.<ADMINID>
Group BY CMP.CampusCode
