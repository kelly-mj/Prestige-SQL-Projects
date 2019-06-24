-- [SHELL] Lead List
-- Kelly MJ  |  6/17/2019
-- Displays a list of leads. User input: lead type, lead campus

SELECT CMP.fieldValue AS Campus
    , CT.typeName
    , CONCAT('<a target="_blank" href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS Name
    , IF(RD.fieldValue < CURDATE(), DATE_FORMAT(RD.fieldValue, '<div style="background-color: #f09595;">%m/%d/%Y</div>'), DATE_FORMAT(RD.fieldValue, '%m/%d/%Y')) AS 'Recontact Date'
    , CASE
        WHEN DATEDIFF(CURDATE(), C.lastUpdateDtTm) > 60
            THEN DATE_FORMAT(C.lastUpdateDtTm, '<strong><div style="color: red;">%m/%d/%Y</div></strong>')
        WHEN C.lastUpdateDtTm < RD.fieldValue OR DATEDIFF(CURDATE(), C.lastUpdateDtTm) > 30
            THEN DATE_FORMAT(C.lastUpdateDtTm, '<div style="color: red;">%m/%d/%Y</div>')
        ELSE DATE_FORMAT(C.lastUpdateDtTm, '%m/%d/%Y') END AS 'Last Updated'
    , CASE
        WHEN LENGTH(CMT.fieldValue) <= 100 THEN CMT.fieldValue
        WHEN LENGTH(CMT.fieldValue) BETWEEN 100 AND 200 THEN CONCAT(SUBSTRING(CMT.fieldValue, 1, 100), '</br>', SUBSTRING(CMT.fieldValue, 101, 200))
        WHEN LENGTH(CMT.fieldValue) > 200 THEN CONCAT(SUBSTRING(CMT.fieldValue, 1, 100), '</br>', SUBSTRING(CMT.fieldValue, 101, 200), '</br>', SUBSTRING(CMT.fieldValue, 201, 300)) END AS 'Comments'

FROM Contacts C
INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
LEFT JOIN ProfileFieldValues RD ON RD.userId = C.contactId
    AND RD.fieldName = 'RECONTACT_DATE'
INNER JOIN ProfileFieldValues CMP ON CMP.userId = C.contactId
    AND CMP.fieldName = 'CAMPUS'
LEFT JOIN ProfileFieldValues CMT ON CMT.userId = C.contactId
    AND CMT.fieldName = 'NOTES'

WHERE C.isActive = 1
AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '0')
AND C.<ADMINID>
-- user inputs
AND IF('[?Campus]' <> ''
		, ( INSTR(REPLACE(LOWER(CMP.fieldValue), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) )
		, C.<ADMINID> /* dummy condition */ )
AND IF('[?Lead Type{Show All|Show All|1.|1. New Lead|2.|2. Attempted Contact|3.|3. Contacted/Working|4.|4. 1st Appointment/School Tour|5.|5. 2nd Appointment/Toured|6.|6. 3rd Appointment/Financial Aid|7.|7. Pending Enrollment|8.|8. Enrolled|9.|9. Nurturing|86|86. Lost/Not Interested}]' = 'Show All'
    , C.<ADMINID> /* dummy condition */
    , SUBSTRING(CT.typeName, 1, 2) = '[?Lead Type{Show All|Show All|1.|1. New Lead|2.|2. Attempted Contact|3.|3. Contacted/Working|4.|4. 1st Appointment/School Tour|5.|5. 2nd Appointment/Toured|6.|6. 3rd Appointment/Financial Aid|7.|7. Pending Enrollment|8.|8. Enrolled|9.|9. Nurturing|86|86. Lost/Not Interested}]')

ORDER BY CMP.fieldValue, CAST(SUBSTRING(typeName, 1, 2) AS SIGNED), C.lastName ASC
