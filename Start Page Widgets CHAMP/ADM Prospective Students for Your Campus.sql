SELECT
CONCAT('<a href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', CAST(C.firstName AS CHAR), ' ', CAST(C.lastName AS CHAR), '</a>') AS Name,

	CT.typeName AS Status,
	DATE_FORMAT(C.lastUpdateDtTm, '%m-%d %h:%i') AS 'Last Update'

FROM
	Contacts C
INNER JOIN ContactTypes CT ON C.contactTypeId = CT.contactTypeId AND CT.isActive=1
WHERE
	C.<ADMINID> AND
	C.contactTypeId <> 4000039 AND -- not vendor
        C.contactTypeId <> 4000052 AND -- not Salon Customer
	C.contactTypeId <> 4000042 AND -- not nurturing
 	C.contactTypeId <> 4000047 AND -- not Gains
        C.contactTypeId <> 4000049 AND -- not Future Attending Date
        C.contactTypeId <> 4000050 AND -- not lost
	C.contactTypeId <> 4000046  -- not enrolled student
