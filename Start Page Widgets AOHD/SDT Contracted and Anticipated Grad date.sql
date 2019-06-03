-- [AOHD] SDT Grad Dates
--

SELECT DATE_FORMAT(R.endDate, '%m/%d/%Y') AS 'Contracted Grad Date'
-- , calculation AS 'Anticipated Grad Date'

FROM Registrations R
INNER JOIN (SELECT MAX(R.registrationId) AS maxReg FROM Registrations WHERE studentId = [?USERID]) RR
    ON RR.maxReg = R.registrationDate

WHERE R.studentId = [?USERID]
  AND R.<ADMINID>
