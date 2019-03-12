SELECT
CONCAT('<a href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', CAST(C.firstName AS CHAR), ' ', CAST(C.lastName AS CHAR), '</a>') AS Name,

	CT.typeName AS Status,
	DATE_FORMAT(C.lastUpdateDtTm, '%m/%d/%Y %h:%i %p') AS 'Last Update'

FROM
	Contacts C
INNER JOIN ContactTypes CT ON C.contactTypeId = CT.contactTypeId AND CT.isActive=1
WHERE
	C.<ADMINID> AND
	CT.typeName IN ('1. New Leads', '3. Scheduled IIT')

ORDER BY CT.typeName, C.lastUpdateDtTm DESC
