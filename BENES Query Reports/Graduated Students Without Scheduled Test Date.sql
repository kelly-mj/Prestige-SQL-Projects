-- Report: Graduated Students Without Scheduled Test Dates
-- Author: Kelly MJ   |   Creation date: 8/3/2018
-- Purpose: Display a list of students who have graduated since the "Report Start Date" who have not scheduled their state board exam.
		 -- The list is ordered by the least-to-most recent graduation dates
-- 8/24/18 update:
    -- Corrected Pending Grad status code from 16 to 17
    -- Restructured joins
    -- Now uses graduationDate instead of endDate to determine student grad dates

SELECT S.idNumber 'Student ID'
	 , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS 'Student Name'
     , DATE_FORMAT(R.graduationDate, '%m/%d/%Y') AS 'Graduation Date'
     , CASE WHEN R.regStatus =  3 THEN 'Graduated'
            WHEN R.regStatus = 17 THEN 'Pending Grad'
	   END AS 'Status'
     -- , PFV.fieldValue AS 'State Board Exam Date'

FROM Registrations R

INNER JOIN Students S
    ON S.studentId = R.studentId

INNER JOIN Programmes P
    ON P.programmeId = R.programmeId
    AND P.programmeName NOT LIKE '%career%'

INNER JOIN ProfileFieldValues PFV
    ON PFV.userId = R.studentId
    AND PFV.fieldName LIKE 'EXAM_DATE'
    AND (PFV.fieldValue IS NULL OR PFV.fieldValue < '1970-01-01')

INNER JOIN (
    SELECT studentId
        , MAX(endDate) AS maxEnd
        , registrationDate
    FROM Registrations 
    GROUP BY studentId) RR
    ON RR.studentId = R.studentId
    AND RR.maxEnd = R.endDate

WHERE
  R.regStatus IN (3, 17)			-- Grad or Pending Grad status
  AND R.isActive = 1
  -- AND R.enrollmentSemesterId = 4000441
  AND R.registrationDate > '[?Report Start Date]'
  AND R.<ADMINID>
GROUP BY S.studentId

ORDER BY R.endDate ASC