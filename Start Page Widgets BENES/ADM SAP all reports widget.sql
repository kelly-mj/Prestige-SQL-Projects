SELECT t1.Name
	, t1.Program
    , t1.programHours
    , t1.hoursScheduled
	, IF(t1.fileCount1 > 0
		, CONCAT(SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd1, 'Yes</a>')
        , CONCAT('<div style="background-color: #ffb7af;">', SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd1, 'No</a></div>')) 'Period 1 SAP'
    , IF(t1.fileCount2 > 0
		, CONCAT(SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd2, 'Yes</a>')
        , CONCAT('<div style="background-color: #ffb7af;">', SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd2, 'No</a></div>')) 'Period 2 SAP'
    , IF(t1.fileCount3 > 0
		, CONCAT(SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd3, 'Yes</a>')
        , CONCAT('<div style="background-color: #ffb7af;">', SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd3, 'No</a></div>')) 'Period 3 SAP'
    , IF(t1.fileCount4 > 0
		, CONCAT(SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd4, 'Yes</a>')
        , CONCAT('<div style="background-color: #ffb7af;">', SAPurlStart, CAST(t1.studentId AS CHAR), SAPurlEnd4, 'No</a></div>')) 'Period 4 SAP'

FROM (
	SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
				, S.studentId
				, P.programmeName AS Program
				, P.minClockHours AS programHours
				, SCH.hoursScheduled
				, PP.programmeId	-- Matching program in PayPeriod table
				, PP.ppHours		-- Hours in matching program (1200, 600, 360)
				, PP.disbPercent	-- How the payments are split up (100%, 50%, 25% per pay period)
                , PP.numPayPeriods  -- How many pay periods there are for the student's program
			    , DISB1.fileCount1
			    , DISB2.fileCount2
			    , DISB3.fileCount3
			    , DISB4.fileCount4
                , '<a target="_blank" href="files_and_documents.jsp?userid=' AS SAPurlStart
                , '&usertype=1&folderFolderReltnId=116&previousFolderId=0,116">' AS SAPurlEnd1
                , '&usertype=1&folderFolderReltnId=117&previousFolderId=0,117">' AS SAPurlEnd2
                , '&usertype=1&folderFolderReltnId=118&previousFolderId=0,118">' AS SAPurlEnd3
                , '&usertype=1&folderFolderReltnId=119&previousFolderId=0,119">' AS SAPurlEnd4

			FROM Students S

			INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
				ON RR.studentId = S.studentId

			INNER JOIN Registrations R ON R.studentId = S.studentId
				AND R.registrationId = RR.maxReg

			INNER JOIN Programmes P ON P.programmeId = R.programmeId

			INNER JOIN (SELECT programmeId, MAX(payPeriodHours) ppHours, MAX(payPeriodDisbPercent) disbPercent, COUNT(payPeriodDisbPercent) AS numPayPeriods FROM PayPeriod GROUP BY programmeId) PP
				ON PP.programmeId = R.programmeId

			INNER JOIN (SELECT PFV.userId, PFV.fieldValue AS hoursScheduled FROM ProfileFieldValues PFV WHERE PFV.fieldName = 'PROGRAM_HOURS_SCHEDULED') SCH
				ON SCH.userId = S.studentId

			LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount1 FROM FolderFileReltn WHERE folderFolderReltnId = 116 AND documentTypeId IN (52, 53) GROUP BY userId) DISB1
				ON DISB1.userId = S.studentId

			LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount2 FROM FolderFileReltn WHERE folderFolderReltnId = 117 AND documentTypeId IN (52, 53) GROUP BY userId) DISB2
				ON DISB2.userId = S.studentId

			LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount3 FROM FolderFileReltn WHERE folderFolderReltnId = 118 AND documentTypeId IN (52, 53) GROUP BY userId) DISB3
				ON DISB3.userId = S.studentId

			LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount4 FROM FolderFileReltn WHERE folderFolderReltnId = 119 AND documentTypeId IN (52, 53) GROUP BY userId) DISB4
				ON DISB4.userId = S.studentId

			WHERE S.isActive = 1
				AND S.<ADMINID>
			) t1