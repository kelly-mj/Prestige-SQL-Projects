-- Audit Report
-- Written by: Kelly MJ
-- Created: 06/29/2018
-- Selects students who have started ON or BEFORE the lower limit of the date range (lower limit: 01/01/YYYY)
-- Selects students who have a contract graduation date DURING or BEFORE the date range (upper limit: 12/31/YYYY)

SELECT S.idNumber 'ID Number'
	 , S.name 'Student Name'
         , P.programmeName 'Program Name'
         , R.startDate 'Start Date'
         , R.gradDate 'Graduation Date'

FROM (
	SELECT S.studentId
		     , S.idNumber
                     , CONCAT(S.firstName, ' ', S.lastName) AS Name
	FROM Students S
        WHERE S.<ADMINID>                                                                   -- <ADMINID> tag
) S
      
INNER JOIN (
	SELECT R.studentId
		 , MAX(R.startDate) AS startDate                                            -- gets latest start date (for students who've enrolled in more than 1 program)
                 , R.programmeId
                 , MAX(R.graduationDate) AS gradDate                                  -- gets latest contract graduation date
	FROM Registrations R
        GROUP BY R.studentId
) R
ON R.studentId = S.studentId

INNER JOIN Programmes P
ON P.programmeId = R.programmeId

WHERE R.startDate < CONCAT( '[?Audit Year (YYYY)]' , '-12-31' )
AND R.gradDate > CONCAT( '[?Audit Year (YYYY)]' , '-01-01' )

ORDER BY S.idNumber ASC
