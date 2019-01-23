-- AOHD Query: Recontact Information
-- Kelly MJ  |  1/23/2019

SELECT CMP.fieldValue
    , CONCAT('<a target="_blank" href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS name
    , DATE_FORMAT(RD.fieldValue, '%m/%d/%Y ') AS 'Recontact Date'
    , RN.fieldValue AS 'Recontact Notes'
    , DATE_FORMAT(C.creationDtTm, '%m/%d/%Y %h:%i %p') 'Creation Date'
    , DATE_FORMAT(C.lastUpdateDtTm, '%m/%d/%Y %h:%i %p')'Last Updated'
    
FROM Contacts C

INNER JOIN ContactTypes CT
    ON CT.contactTypeId = C.contactTypeId

-- "Recontact Date"
LEFT JOIN ProfileFieldValues RD
    ON RD.userId = C.contactId
    AND RD.fieldName = 'RECONTACT_DATE'
    
-- "Recontact Notes"
LEFT JOIN ProfileFieldValues RN
    ON RN.userId = C.contactId
    AND RN.fieldName = 'RECONTACT_NOTES'

-- "Campuses"
INNER JOIN ProfileFieldValues CMP
    ON CMP.userId = C.contactId
    AND CMP.fieldName = 'CAMPUS'

WHERE CT.typeName IN (
              '01. New Leads'
            , '02. Left Message'
            , '03. Working'
            , '04. Made Appointment'
            , '06. In Process'
            , '07. Future Attend Date' )

-- Date select: If fields are left blank, default values are the first and last date of current month
AND ((RD.fieldValue BETWEEN IF('[?Start Date]' = '', DATE_FORMAT(CURDATE(), '%Y-%m-01'), '[?Start Date]')
                        AND IF('[?End Date]' = '', LAST_DAY(CURDATE()), '[?End Date]') )    -- end "BETWEEN"
        OR RD.fieldValue < '1970-01-01')                                                    -- if record is NULL, it's still included in the report

-- Campus select
AND CASE '[?Campus{1|Springfield|2|Austin|3|All Campuses}]'
        WHEN 1 THEN CMP.fieldValue = 'Springfield Campus'
        WHEN 2 THEN CMP.fieldValue = 'Austin Campus'
        ELSE CMP.fieldValue IS NOT NULL
    END
AND C.<ADMINID>
