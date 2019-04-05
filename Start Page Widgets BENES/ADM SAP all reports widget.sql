-- BENES ADM All SAP Reports
-- Kelly MJ | 3/27/19
-- Displays whether there is a SAP report for SAP Periods 1, 2, 3, 4.

-- Last Modifed by Nilima, added one missing field - actualHours on t1

SELECT t1.Name
    , t1.Program
    , FORMAT(t1.programHours, 1) 'Program Hours'
    , FORMAT(t1.hoursScheduled, 1) 'Hours Scheduled'
    , FORMAT(t1.actualHours, 1) 'Actual Hours'
    , IF(t1.fileCount1 IS NOT NULL
    , CONCAT('<div style="background-color: #bdefaa;">', SAP1url, COALESCE(DATE_FORMAT(t1.dueDate1, '%m/%d/%y'), 'No due date'), '</a></div>')
        , IF(t1.dueDate1 < CURDATE()
            , CONCAT('<div style="background-color: #ffb7af;">',SAP1url, DATE_FORMAT(t1.dueDate1, '%m/%d/%y'), '</a></div>')
            , CONCAT('<div>', SAP1url, COALESCE(DATE_FORMAT(t1.dueDate1, 'Due: %m/%d/%y'), 'No due date'), '</a></div>'))) 'Period 1 SAP'
    , IF(t1.noPP > 1, IF(t1.fileCount2 IS NOT NULL
        , CONCAT('<div style="background-color: #bdefaa;">', SAP2url, COALESCE(DATE_FORMAT(t1.dueDate2, '%m/%d/%y'), 'No due date'), '</a></div>')
        , IF(t1.dueDate2 < CURDATE()
            , CONCAT('<div style="background-color: #ffb7af;">', SAP2url, DATE_FORMAT(t1.dueDate2, '%m/%d/%y'), '</a></div>')
            , CONCAT('<div>', SAP2url, COALESCE(DATE_FORMAT(t1.dueDate2, 'Due: %m/%d/%y'), 'No due date'), '</a></div>'))), NULL) 'Period 2 SAP'
    , IF(t1.noPP > 2, IF(t1.fileCount3 IS NOT NULL
        , CONCAT('<div style="background-color: #bdefaa;">', SAP3url, COALESCE(DATE_FORMAT(t1.dueDate3, '%m/%d/%y'), 'No due date'), '</a></div>')
        , IF(t1.dueDate3 < CURDATE()
            , CONCAT('<div style="background-color: #ffb7af;">', SAP3url, DATE_FORMAT(t1.dueDate3, '%m/%d/%y'), '</a></div>')
            , CONCAT('<div>', SAP3url, COALESCE(DATE_FORMAT(t1.dueDate3, 'Due: %m/%d/%y'), 'No due date'), '</a></div>'))), NULL) 'Period 3 SAP'
    , IF(t1.noPP > 2, IF(t1.fileCount4 IS NOT NULL
        , CONCAT('<div style="background-color: #bdefaa;">', SAP4url, COALESCE(DATE_FORMAT(t1.dueDate4, '%m/%d/%y'), 'No due date'), '</a></div>')
        , IF(t1.dueDate4 < CURDATE()
            , CONCAT('<div style="background-color: #ffb7af;">', SAP4url, DATE_FORMAT(t1.dueDate4, '%m/%d/%y'), '</a></div>')
            , CONCAT('<div>', SAP4url, COALESCE(DATE_FORMAT(t1.dueDate4, 'Due: %m/%d/%y'), 'No due date'), '</a></div>'))), NULL) 'Period 4 SAP'

FROM (
    SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
        , S.studentId
        , S.lastName
        , P.programmeName AS Program
        , P.minClockHours AS programHours
        , ATT.actualHours
        , SCH.hoursScheduled
        , PP.programmeId	-- Matching program in PayPeriod table
        , PP.ppHours	-- Hours in matching program (1200, 600, 360)
        , PP.disbPercent	-- How the payments are split up (100%, 50%, 25% per pay period)
        , PP.numPayPeriods -- How many pay periods there are for the student's program
        , DISB1.fileCount1
        , DISB2.fileCount2
        , DISB3.fileCount3
        , DISB4.fileCount4
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId=116&previousFolderId=0,116">') AS SAP1url
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId=117&previousFolderId=0,117">') AS SAP2url
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId=118&previousFolderId=0,118">') AS SAP3url
        , CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId=119&previousFolderId=0,119">') AS SAP4url
        , PP1.dueDate1
        , PP2.dueDate2
        , PP3.dueDate3
        , PP4.dueDate4
        , CASE PP.ppHours WHEN 1200 THEN 4
            WHEN 600 THEN IF(PP.disbPercent = 50.0, 2, 1)
            WHEN 360 THEN IF(PP.disbPercent = 50.0, 2, 1)
            WHEN 300 THEN 1 ELSE 5 END AS noPP

    FROM Students S

    INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
        ON RR.studentId = S.studentId

    INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg

    INNER JOIN Programmes P ON P.programmeId = R.programmeId

    INNER JOIN (SELECT programmeId, MAX(payPeriodHours) ppHours, MAX(payPeriodDisbPercent) disbPercent, COUNT(payPeriodDisbPercent) AS numPayPeriods FROM PayPeriod GROUP BY programmeId) PP
        ON PP.programmeId = R.programmeId

    INNER JOIN (SELECT PFV.userId, PFV.fieldValue AS actualHours FROM ProfileFieldValues PFV WHERE PFV.fieldName = 'PROGRAM_HOURS_ATTENDED') ATT
        ON ATT.userId = S.studentId

    INNER JOIN (SELECT PFV.userId, PFV.fieldValue AS hoursScheduled FROM ProfileFieldValues PFV WHERE PFV.fieldName = 'PROGRAM_HOURS_SCHEDULED') SCH
        ON SCH.userId = S.studentId

    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount1 FROM FolderFileReltn
			WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 1' AND isActive = 1)
			AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 1' AND isActive = 1)
			GROUP BY userId) DISB1
        ON DISB1.userId = S.studentId

    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount2 FROM FolderFileReltn
			WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 2' AND isActive = 1)
			AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 2' AND isActive = 1)
			GROUP BY userId) DISB2
        ON DISB2.userId = S.studentId

    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount3 FROM FolderFileReltn
			WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 3' AND isActive = 1)
			AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 3' AND isActive = 1)
			GROUP BY userId) DISB3
        ON DISB3.userId = S.studentId

    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount4 FROM FolderFileReltn
			WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 4' AND isActive = 1)
			AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 4' AND isActive = 1)
			GROUP BY userId) DISB4
        ON DISB4.userId = S.studentId

    LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate1, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 1) PP1
        ON PP1.studentId = S.studentId AND PP1.registrationId = R.registrationId

    LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate2, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 2) PP2
        ON PP2.studentId = S.studentId AND PP2.registrationId = R.registrationId

    LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate3, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 3) PP3
        ON PP3.studentId = S.studentId AND PP3.registrationId = R.registrationId

    LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate4, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 4) PP4
        ON PP4.studentId = S.studentId AND PP4.registrationId = R.registrationId

    WHERE S.isActive = 1
        AND S.<ADMINID>
) t1

ORDER BY t1.Program, t1.lastName
