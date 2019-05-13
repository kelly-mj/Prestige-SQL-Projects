-- [SHELL] Contract Changes
-- Kelly MJ 5/13/2019: Displays student records which have had contract changes

SELECT t1.Name
	, DATE_FORMAT(t1.RA1_dateMax, '%m/%d/%Y') AS 'Updated'
	, IF(t1.studentCampus <> t2.studentCampus, (SELECT campusName FROM Campuses WHERE campusCode = t2.studentCampus), '') AS 'Old Campus'
    , IF(t1.studentCampus <> t2.studentCampus, (SELECT campusName FROM Campuses WHERE campusCode = t1.studentCampus), '') AS 'New Campus'
    , IF(t1.startDate <> t2.startDate, DATE_FORMAT(t2.startDate, '%m/%d/%Y'), '') AS 'Old Start Date'
    , IF(t1.startDate <> t2.startDate, DATE_FORMAT(t1.startDate, '%m/%d/%Y'), '') AS 'New Start Date'
    , IF(t1.endDate <> t2.endDate, DATE_FORMAT(t2.endDate, '%m/%d/%Y'), '') AS 'Old End Date'
    , IF(t1.endDate <> t2.endDate, DATE_FORMAT(t1.endDate, '%m/%d/%Y'), '') AS 'New End Date'
    , IF(t1.programmeId <> t2.programmeId, (SELECT programmeName FROM Programmes WHERE programmeId = t2.programmeId), '') AS 'Old Program'
    , IF(t1.programmeId <> t2.programmeId, (SELECT programmeName FROM Programmes WHERE programmeId = t1.programmeId), '') AS 'New Program'
    , IF(t1.enrollmentType <> t2.enrollmentType, t2.enrollmentType, '') AS 'Old Enroll Type'
    , IF(t1.enrollmentType <> t2.enrollmentType, t1.enrollmentType, '') AS 'New Enroll Type'
    
FROM (
	SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
		, CONCAT(S.lastName, ', ', S.firstName) AS names
		, S.lastName
		, (SELECT MAX(lastUpdateDtTm)
			FROM Registrations_Audit
            WHERE registrationId = R.registrationId AND lastUpdateDtTm < RA1_max.RA1_dateMax) AS RA2_dateMax
        , RA1.*
        , RA1_max.RA1_dateMax
        
	FROM Students S
    
    INNER JOIN Registrations R ON R.studentId = S.studentId
		AND R.isActive = 1

	INNER JOIN (SELECT registrationId, MAX(lastUpdateDtTm) AS RA1_dateMax
				FROM Registrations_Audit
                WHERE isActive = 1 GROUP BY registrationId) RA1_max
		ON RA1_max.registrationId = R.registrationId

	INNER JOIN Registrations_Audit RA1
		ON RA1.registrationId = RA1_max.registrationId
		AND RA1.lastUpdateDtTm = RA1_max.RA1_dateMax
	
    WHERE S.isActive = 1
	  AND DATE(RA1.lastUpdateDtTm) >= IF('[?From Date]' = '', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '[?From Date]')
	  AND S.<ADMINID>
	) t1

INNER JOIN Registrations_Audit t2
	ON t2.registrationId = t1.registrationId
	AND t2.lastUpdateDtTm = t1.RA2_dateMax
    AND t2.regStatus IN (1, 12)
    
WHERE t1.isActive = 1
AND (  t1.studentCampus <> t2.studentCampus
    OR t1.startDate <> t2.startDate
    OR t1.endDate <> t2.endDate
    OR t1.programmeId <> t2.programmeId
    OR t1.enrollmentType <> t2.enrollmentType )
    
ORDER BY t1.lastName ASC