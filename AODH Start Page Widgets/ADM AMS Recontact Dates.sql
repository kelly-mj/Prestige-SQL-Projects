-- AODH: ADM, AMS Recontact Dates
-- Kelly MJ  |  1/23/2019
    -- 2 versions of this widget exist on the site for each user; one for each campus (Austin, Springfield)

/*
 *	Contact records with a recontact date, ordered by campus and date (most recent to least recent)
 */
( SELECT CONCAT('<a target="_blank" href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS name
	, CONCAT(DATE_FORMAT(RD.fieldValue, '%m/%d/%Y '), '<span style="color:red;">', REPEAT('!', DATEDIFF(CURDATE(), RD.fieldValue)), '</span>') AS 'Recontact Date'
    , CT.typeName 'Contact Type'

FROM Contacts C

INNER JOIN ContactTypes CT
	ON CT.contactTypeId = C.contactTypeId

-- "Recontact Date"
LEFT JOIN ProfileFieldValues RD
	ON RD.userId = C.contactId
    AND RD.fieldName = 'RECONTACT_DATE'
    AND RD.fieldValue > '1970-01-01'

-- "Campuses"
INNER JOIN ProfileFieldValues CMP
	ON CMP.userId = C.contactId
    AND CMP.fieldName = 'CAMPUS'
    AND CMP.fieldValue = 'Springfield Campus'

WHERE CT.typeName IN (
			  '01. New Leads'
            , '02. Left Message'
            , '03. Working'
            , '04. Made Appointment'
            , '06. In Process'
            , '07. Future Attend Date' )
AND RD.fieldValue <= CURDATE()
AND C.<ADMINID>

ORDER BY CMP.fieldValue, RD.fieldValue )	-- end SELECT

/*
 *	Contact records without a recontact date
 */
UNION
( SELECT CONCAT('<a target="_blank" href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS name
	, '<div style="color:red;">No recontact date found</div>' AS 'Recontact Date'
    , CT.typeName 'Contact Type'

FROM Contacts C

INNER JOIN ContactTypes CT
	ON CT.contactTypeId = C.contactTypeId

-- "Recontact Date"
LEFT JOIN ProfileFieldValues RD
	ON RD.userId = C.contactId
    AND RD.fieldName = 'RECONTACT_DATE'
    AND RD.fieldValue < '1970-01-01'
    
-- "Campuses"
INNER JOIN ProfileFieldValues CMP
	ON CMP.userId = C.contactId
    AND CMP.fieldName = 'CAMPUS'
    AND CMP.fieldValue = 'Springfield Campus'
    
WHERE CT.typeName IN (
			  '01. New Leads'
            , '02. Left Message'
            , '03. Working'
            , '04. Made Appointment'
            , '06. In Process'
            , '07. Future Attend Date' )
AND RD.fieldValue <= CURDATE()
AND C.<ADMINID>

ORDER BY CMP.fieldValue, RD.fieldValue )	-- end SELECT