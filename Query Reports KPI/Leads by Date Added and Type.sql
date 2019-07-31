-- Leads by Type/Date Added
-- Kelly MJ  |  7/30/2019

SELECT CMP.campusName
    , CT.typeName AS 'Type'
    , C.contactId
    , CONCAT('<a href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', CAST(C.lastName AS CHAR), ', ', CAST(C.firstName AS CHAR), '</a>') AS Name
    , (SELECT CONCAT(firstName, ' ', lastName) FROM SubAdmins WHERE subAdminId = C.staffId) AS 'Rep Assigned'
    , C.creationDtTm
    , C.lastUpdateDtTm
    , USR.typeName AS 'Prev Status'
    , USR.updateUserName AS 'Updated By'
    , USR.lastUpdate AS 'Prev Status updateDtTm'

FROM Contacts C
LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
LEFT JOIN Campuses CMP ON CMP.campusCode = C.campusCode
    AND IF('[?Campus]' <> '', LOCATE('[?Campus]', CMP.campusName) <> 0, CMP.isActive = 1)
LEFT JOIN (SELECT U.toUserId, MAX(U.status) AS lastStatus, T.typeName, MAX(U.updateDtTm) AS lastUpdate, U.updateUserName
            FROM UserStatusRecords U
            INNER JOIN ContactTypes T ON T.contactTypeId = U.status
            WHERE LOCATE('[?Type]', T.typeName) <> 0
            GROUP BY U.toUserId) USR
    ON USR.toUserId = C.contactId

WHERE (LOCATE('[?Type]', CT.typeName) <> 0 OR USR.toUserId IS NOT NULL)
  AND IF('[?From Date]' <> '', DATE(C.creationDtTm) >= '[?From Date]', C.isActive = 1)
  AND IF('[?To Date]' <> '', DATE(C.creationDtTm) >= '[?To Date]', C.isActive = 1)
  AND C.isActive = 1
  AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
  AND CMP.isActive = 1

ORDER BY CMP.campusName, CT.typeName, C.creationDtTm

/* <ADMINID> */
