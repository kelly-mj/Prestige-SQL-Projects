-- AMS Prospective Students for Your Campus
-- Edit: Kelly MJ  |  1/2/2019
-- The two halves of these codes were thrown into two separate front page reports and are linked to by a 'Widget Links' report in Admissions' front page.

/*
 *  Brooksville Report
 */
SELECT IFNULL(PV.fieldValue,"") AS CAMPUS
	, CONCAT('<a href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', CAST(C.firstName AS CHAR), ' ', CAST(C.lastName AS CHAR), '</a>') AS Name
	, CT.typeName AS Status
	, DATE_FORMAT(C.lastUpdateDtTm, '%m/%d/%Y' ) AS 'Last Update'
        
FROM Contacts C
INNER JOIN ContactTypes CT ON C.contactTypeId = CT.contactTypeId AND CT.isActive=1
LEFT JOIN ProfileFieldValues PV ON PV.userId=C.contactId AND PV.userType=99 AND PV.fieldName="CAMPUS"  AND PV.isActive=1 AND PV.<ADMINID>
WHERE
	C.<ADMINID> AND
	C.contactTypeId <> 4000039 AND -- not vendor
        C.contactTypeId <> 4000052 AND -- not Salon Customer
	C.contactTypeId <> 4000042 AND -- not nurturing
 	C.contactTypeId <> 4000047 AND -- not Gains
        C.contactTypeId <> 4000049 AND -- not Future Attending Date
        C.contactTypeId <> 4000050 AND -- not lost       
	C.contactTypeId <> 4000046  -- not enrolled student
	AND PV.fieldValue = 'Brooksville'
   
ORDER BY CAMPUS, status, C.lastUpdateDtTm DESC


/*
 *  Spring Hill Report
 */

SELECT IFNULL(PV.fieldValue,"") AS CAMPUS
	, CONCAT('<a href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', CAST(C.firstName AS CHAR), ' ', CAST(C.lastName AS CHAR), '</a>') AS Name
	, CT.typeName AS Status
	, DATE_FORMAT(C.lastUpdateDtTm, '%m/%d/%Y' ) AS 'Last Update'
        
FROM Contacts C
INNER JOIN ContactTypes CT ON C.contactTypeId = CT.contactTypeId AND CT.isActive=1
LEFT JOIN ProfileFieldValues PV ON PV.userId=C.contactId AND PV.userType=99 AND PV.fieldName="CAMPUS"  AND PV.isActive=1 AND PV.<ADMINID>
WHERE
	C.<ADMINID> AND
	C.contactTypeId <> 4000039 AND -- not vendor
        C.contactTypeId <> 4000052 AND -- not Salon Customer
	C.contactTypeId <> 4000042 AND -- not nurturing
 	C.contactTypeId <> 4000047 AND -- not Gains
        C.contactTypeId <> 4000049 AND -- not Future Attending Date
        C.contactTypeId <> 4000050 AND -- not lost       
	C.contactTypeId <> 4000046  -- not enrolled student
	AND PV.fieldValue = 'Spring Hill'
   
ORDER BY CAMPUS, status, C.lastUpdateDtTm DESC