-- [SHELL] AMS Recontact Dates
-- Kelly MJ  |  6/12//2019
-- Displays a list of active leads and their recontact dates. Leads have the same campus as the user (admissions employee) who is logged in.

SELECT CONCAT(DATE_FORMAT(RD.fieldValue, '%m/%d/%Y '), '<span style="color:red;">', REPEAT('!', DATEDIFF(CURDATE(), RD.fieldValue)), '</span>') AS 'Recontact Date'
	, CONCAT('<a target="_blank" href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS Name
    , CT.typeName 'Contact Type'
	, DATE_FORMAT(C.lastUpdateDtTm, '%m/%d/%Y') AS 'Last Updated'

FROM Contacts C

INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId

LEFT JOIN ProfileFieldValues RD ON RD.userId = C.contactId
    AND RD.fieldName = 'RECONTACT_DATE'

INNER JOIN ProfileFieldValues CMP ON CMP.userId = C.contactId
    AND CMP.fieldName = 'CAMPUS'

WHERE SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '0')	-- only display numbered leads (indicated propective student)
  AND SUBSTRING(CT.typeName, 1, 2) <> '86'													-- exclude Lost/Not Interested Leads
  AND (RD.fieldValue <= DATE_ADD(CURDATE(), INTERVAL 2 WEEK) OR RD.fieldValue IS NULL)		-- show recontact date 2 weeks out (and missing RDs)
  AND CMP.fieldValue = (SELECT fieldValue FROM ProfileFieldValues WHERE userId = [USERID] AND fieldName = 'CAMPUS')
  AND C.<ADMINID>

ORDER BY RD.fieldValue, CT.typeName, C.lastName
