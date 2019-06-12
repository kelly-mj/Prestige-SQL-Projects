-- [SHELL] ASM Recontact Date

/*
 *	Contact records with a recontact date, ordered by campus and date (most recent to least recent)
 */
SELECT CONCAT(DATE_FORMAT(RD.fieldValue, '%m/%d/%Y '), '<span style="color:red;">', REPEAT('!', DATEDIFF(CURDATE(), RD.fieldValue)), '</span>') AS 'Recontact Date'
	, CONCAT('<a target="_blank" href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS Name
    , CT.typeName 'Contact Type'
	, DATE_FORMAT(C.lastUpdateDtTm, '%m/%d/%Y') AS 'Last Updated'

FROM Contacts C

INNER JOIN ContactTypes CT
	ON CT.contactTypeId = C.contactTypeId

-- "Recontact Date"
LEFT JOIN ProfileFieldValues RD
	ON RD.userId = C.contactId
    AND RD.fieldName = 'RECONTACT_DATE'
    -- AND RD.fieldValue > '1970-01-01'

-- "Campuses"
INNER JOIN ProfileFieldValues CMP
	ON CMP.userId = C.contactId
    AND CMP.fieldName = 'CAMPUS'
    AND CMP.fieldValue = (SELECT fieldValue FROM ProfileFieldValues WHERE userId = [?USERID] AND fieldName = 'CAMPUS')

WHERE SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '0')
  AND SUBSTRING(CT.typeName, 1, 1) <> '8'		-- exclude GAIN Leads
  AND SUBSTRING(CT.typeName, 1, 2) <> '86'		-- exclude Lost/Not Interested Leads
-- AND RD.fieldValue <= CURDATE()
AND C.<ADMINID>

ORDER BY RD.fieldValue, CT.typeName, C.lastName
