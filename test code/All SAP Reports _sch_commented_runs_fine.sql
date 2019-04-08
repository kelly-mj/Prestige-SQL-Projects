-- TESTING ALL SAP Reports
-- This report ran fine on benestest.orbund.com as a query report (SCH join commented out, loaded results in under 30 seconds)

SELECT t1.Name
    , t1.Program
    , FORMAT(t1.programHours, 1) 'Program Hours'
--    , FORMAT(t1.hoursScheduled, 1) 'Hours Scheduled'
    , FORMAT(t1.actualHours, 1) 'Actual Hours'
    -- link to Disbursement 1 folder (display student's start date)
    , CONCAT(disb1url, DATE_FORMAT(t1.startDate, '%m/%d/%y</a>')) AS 'Start Date'
    -- display whether there is a SAP 1 report in Disbursement 2 folder (due by end of first disbursement)
    , IF(t1.disb2Files IS NOT NULL
        , CONCAT('<div style="background-color: #bdefaa;">', disb2url, COALESCE(DATE_FORMAT(t1.dueDate1, '%m/%d/%y'), 'No due date'), '</a></div>')
        , IF(t1.dueDate1 < CURDATE()
            , CONCAT('<div style="background-color: #ffb7af;">', disb2url, DATE_FORMAT(t1.dueDate1, '%m/%d/%y'), '</a></div>')
            , CONCAT('<div>', disb2url, COALESCE(DATE_FORMAT(t1.dueDate1, 'Due: %m/%d/%y'), 'No due date'), '</a></div>'))) 'SAP 1'
    -- display whether there is a SAP 2 report in Disbursement 3 folder
    , IF(t1.numPayPeriods > 1
        , IF(t1.disb3Files IS NOT NULL
            , CONCAT('<div style="background-color: #bdefaa;">', disb3url, COALESCE(DATE_FORMAT(t1.dueDate2, '%m/%d/%y'), 'No due date'), '</a></div>')
            , IF(t1.dueDate2 < CURDATE()
                , CONCAT('<div style="background-color: #ffb7af;">', disb3url, DATE_FORMAT(t1.dueDate2, '%m/%d/%y'), '</a></div>')
                , CONCAT('<div>', disb3url, COALESCE(DATE_FORMAT(t1.dueDate2, 'Due: %m/%d/%y'), 'No due date'), '</a></div>'))), NULL) 'SAP 2'
    -- display whether there is a SAP 3 report in Disbursement 4 folder
    , IF(t1.numPayPeriods > 2
        , IF(t1.disb4Files IS NOT NULL
            , CONCAT('<div style="background-color: #bdefaa;">', disb4url, COALESCE(DATE_FORMAT(t1.dueDate3, '%m/%d/%y'), 'No due date'), '</a></div>')
            , IF(t1.dueDate3 < CURDATE()
                , CONCAT('<div style="background-color: #ffb7af;">', disb4url, DATE_FORMAT(t1.dueDate3, '%m/%d/%y'), '</a></div>')
                , CONCAT('<div>', disb4url, COALESCE(DATE_FORMAT(t1.dueDate3, 'Due: %m/%d/%y'), 'No due date'), '</a></div>'))), NULL) 'SAP 3'

FROM (
    SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
        , S.studentId
        , S.lastName
        , R.startDate
        , P.programmeName AS Program
        , P.minClockHours AS programHours
        , ATT.actualHours
--         , SCH.hoursScheduled
        , PP.programmeId	-- Matched program in PayPeriod table
        , PP.ppHours        -- Total hours in matched program (1200, 600, 360)
        , PP.numPayPeriods  -- How many pay periods there are in the student's program
        , DISB2.disb2Files  -- Number of files in each disbursement folder
        , DISB3.disb3Files
        , DISB4.disb4Files
        , PP1.dueDate1      -- Due date for each pay period (also due date for the SAP report)
        , PP2.dueDate2
        , PP3.dueDate3
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId='
                , (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 1'),'&previousFolderId=0">') AS disb1url       -- url for each disbursement folder
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId='
                , (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 2'),'&previousFolderId=0">') AS disb2url
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId='
                , (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 3'),'&previousFolderId=0">') AS disb3url
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId='
                , (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 4'),'&previousFolderId=0">') AS disb4url

    FROM Students S

    -- get details of most recent registration record for each student
    INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations
            WHERE isActive = 1 AND programmeId NOT IN (SELECT programmeId FROM Programmes WHERE programmeName LIKE '%Pathways%')
            GROUP BY studentId) RR
        ON RR.studentId = S.studentId

    INNER JOIN Registrations R ON R.studentId = S.studentId
        AND R.registrationId = RR.maxReg

    INNER JOIN Programmes P ON P.programmeId = R.programmeId

    -- get PayPeriod/SAP information for student's current program
    INNER JOIN (SELECT programmeId, MAX(payPeriodHours) ppHours, MAX(payPeriodDisbPercent) disbPercent, COUNT(payPeriodDisbPercent) AS numPayPeriods FROM PayPeriod GROUP BY programmeId) PP
        ON PP.programmeId = R.programmeId

    -- get student scheduled/completed hours
    INNER JOIN (SELECT PFV.userId, PFV.fieldValue AS actualHours FROM ProfileFieldValues PFV WHERE PFV.fieldName = 'HOURS_ATTENDED_FOR_CURRENT_PROGRAM') ATT     --     -- PROGRAM_HOURS_ATTENDED
        ON ATT.userId = S.studentId

--     INNER JOIN (SELECT PFV.userId, PFV.fieldValue AS hoursScheduled FROM ProfileFieldValues PFV WHERE PFV.fieldName = 'HOURS_SCHEDULED_FOR_CURRENT_PROGRAM') SCH --    -- PROGRAM_HOURS_SCHEDULED
--         ON SCH.userId = S.studentId

    -- count SAP 1 reports in Disbursement 2 folder
    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS disb2Files FROM FolderFileReltn
                WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 2' AND isActive = 1)
                  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 1' AND isActive = 1)
                GROUP BY userId) DISB2
        ON DISB2.userId = S.studentId

    -- count SAP 2 reports in Disbursement 3 folder
    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS disb3Files FROM FolderFileReltn
                WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 3' AND isActive = 1)
                  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 2' AND isActive = 1)
                GROUP BY userId) DISB3
        ON DISB3.userId = S.studentId

    -- count SAP 3 reports in Disbursement 4 folder
    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS disb4Files FROM FolderFileReltn
                WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 4' AND isActive = 1)
                  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 3' AND isActive = 1)
                GROUP BY userId) DISB4
        ON DISB4.userId = S.studentId

    -- get pay period dates for each pay period
        -- for 1200 hour program, dates should be at 450, 900, 1050, 1200 hours
        -- for 600 hour programs, dates should be at 300/301, 600 hours (depending on hours split and whether each period's disbursement is 50% or 100% completed hours)
        -- for 360 hour programs, dates should be at 180 or 360 hours (depending on whether each period's disbursement is 50% or 100%)
    LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate1, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 1) PP1
        ON PP1.studentId = S.studentId AND PP1.registrationId = R.registrationId

    LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate2, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 2) PP2
        ON PP2.studentId = S.studentId AND PP2.registrationId = R.registrationId

    LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate3, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 3) PP3
        ON PP3.studentId = S.studentId AND PP3.registrationId = R.registrationId

    WHERE S.isActive = 1
        AND S.<ADMINID>
) t1

ORDER BY t1.Program, t1.lastName
