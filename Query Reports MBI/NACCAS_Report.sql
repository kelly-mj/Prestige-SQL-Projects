-- NACCAS Report
-- Author: Kelly MJ
-- Created: 06/29/2018
-- Lists students in an enrollment year (Ex: for 2018, all students who registered between 2018-01-01 and 2018-12-31 will be listed)

SELECT S.idNumber 'ID Number'
	 , S.name 'Student Name'
         , P.programmeName 'Program Name'
         , R.startDate 'Start Date'

FROM (
	SELECT S.studentId
		 , S.idNumber
         , CONCAT(S.firstName, ' ', S.lastName) AS Name
	FROM Students S
        WHERE S.<ADMINID>
) S
      
INNER JOIN (
	SELECT R.studentId
		 , MAX(R.startDate) AS startDate
                 , R.programmeId
	FROM Registrations R
    GROUP BY R.studentId
) R
ON R.studentId = S.studentId

INNER JOIN Programmes P
ON P.programmeId = R.programmeId

-- [?Enrollment Year (YYYY)] must be entered as a 4-digit value
WHERE R.startDate BETWEEN CONCAT(CAST( [?Enrollment Year (YYYY)] AS CHAR ),'-01-01') AND CONCAT(CAST( [?Enrollment Year (YYYY)] AS CHAR ),'-12-31')

ORDER BY R.startDate
