-- BENES ADM Current SAP Report
-- Kelly MJ  |  3/27/19
  -- Looks for students who have 20 hours remaining until their next SAP date, or are 50 hours past their last SAP date.
  -- Displays whether there is a SAP report for that period or not.

SELECT t2.Name
	, t2.Program
	, FORMAT(t2.programHours, 0) 'Program Hours'
	, FORMAT(t2.hours, 0) AS 'Hours Scheduled'
	, FORMAT(t2.SAPPeriod, 0) AS 'SAP Report'
	, COALESCE(IF(t2.SAPReports > 0
					, DATE_FORMAT(t2.dueDate, '<div style="background-color: #bdefaa; color: black;">%m/%d/%y</div>')
					, IF(t2.dueDate >= CURDATE()
							, DATE_FORMAT(t2.dueDate, '%m/%d/%y')
							, DATE_FORMAT(t2.dueDate, '<div style="background-color: #ffb7af; color: black;">%m/%d/%y</div>')))
			, 'No due date') 'Due Date'
	, IF(t2.SAPReports > 0
		, CONCAT(t2.SAPurl, 'Yes</a>')
        , CONCAT(t2.SAPurl, 'No', IF(t2.dueDate < CURDATE(), '; Past due', ''),'</a>')) 'SAP Report Status'

FROM (
	SELECT t1.*
		, (SELECT MAX(PPD.payPeriodDate) FROM PayPeriodDates PPD WHERE PPD.studentId = t1.studentId AND PPD.payPeriodNo = t1.SAPPeriod GROUP BY PPD.studentId) AS dueDate
        , CASE t1.SAPPeriod
			WHEN 1 THEN t1.disb2files
			WHEN 2 THEN t1.disb3files
			WHEN 3 THEN t1.disb4files END AS SAPReports
		, CASE t1.SAPPeriod
			WHEN 1 THEN CONCAT(SAPurlStart, CAST((SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 2' AND isActive = 1) AS CHAR), SAPurlEnd)
			WHEN 2 THEN CONCAT(SAPurlStart, CAST((SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 3' AND isActive = 1) AS CHAR), SAPurlEnd)
			WHEN 3 THEN CONCAT(SAPurlStart, CAST((SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 4' AND isActive = 1) AS CHAR), SAPurlEnd) END AS SAPurl

	FROM (
		SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
					, S.studentId
					, P.programmeName AS Program
					, P.minClockHours AS programHours
					, HOURS.hours
					, PP.programmeId	-- Matching program in PayPeriod table
					, PP.ppHours		-- Hours in matching program (1200, 600, 360)
					, PP.disbPercent	-- How the payments are split up (100%, 50%, 25% per pay period)
					, DISB2.disb2files
					, DISB3.disb3files
					, DISB4.disb4files
					, CASE WHEN PP1.period1 - HOURS.hours BETWEEN -50 AND 50 THEN 1		-- find pay period of student
						   WHEN PP2.period2 - HOURS.hours BETWEEN -50 AND 50 THEN 2
                           WHEN PP3.period3 - HOURS.hours BETWEEN -50 AND 50 THEN 3
                           ELSE 5 END AS SAPPeriod
					, CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(S.studentId AS CHAR), '&usertype=1&folderFolderReltnId=') AS SAPurlStart
					, '&previousFolderId=0,0">' AS SAPurlEnd


				FROM Students S

				INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
					ON RR.studentId = S.studentId

				INNER JOIN Registrations R ON R.studentId = S.studentId
					AND R.registrationId = RR.maxReg

				INNER JOIN Programmes P ON P.programmeId = R.programmeId

				INNER JOIN (SELECT programmeId, MAX(payPeriodHours) ppHours, MAX(payPeriodDisbPercent) disbPercent FROM PayPeriod GROUP BY programmeId) PP
					ON PP.programmeId = R.programmeId

				INNER JOIN (SELECT PFV.userId, PFV.fieldValue AS hours FROM ProfileFieldValues PFV WHERE PFV.fieldName = 'PROGRAM_HOURS_SCHEDULED') HOURS
					ON HOURS.userId = S.studentId

				LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS disb2files FROM FolderFileReltn
							WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 2' AND isActive = 1)
							  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 1' AND isActive = 1)
							GROUP BY userId) DISB2
			        ON DISB2.userId = S.studentId

				LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS disb3files FROM FolderFileReltn
							WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 3' AND isActive = 1)
							  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 2' AND isActive = 1)
							GROUP BY userId) DISB3
			        ON DISB3.userId = S.studentId

			    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS disb4files FROM FolderFileReltn
							WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 4' AND isActive = 1)
							  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 3' AND isActive = 1)
							GROUP BY userId) DISB4
			        ON DISB4.userId = S.studentId

				LEFT JOIN (SELECT registrationId, MAX(payPeriodHours) AS period1 FROM PayPeriodDates WHERE payPeriodNo = 1 GROUP BY registrationId) PP1
					ON PP1.registrationId = R.registrationId

				LEFT JOIN (SELECT registrationId, MAX(payPeriodHours) AS period2 FROM PayPeriodDates WHERE payPeriodNo = 2 GROUP BY registrationId) PP2
					ON PP2.registrationId = R.registrationId

                LEFT JOIN (SELECT registrationId, MAX(payPeriodHours) AS period3 FROM PayPeriodDates WHERE payPeriodNo = 3 GROUP BY registrationId) PP3
					ON PP3.registrationId = R.registrationId

				WHERE S.isActive = 1
				   AND S.<ADMINID>
			) t1

		WHERE t1.SAPPeriod < 5

	) t2

ORDER BY t2.dueDate ASC
