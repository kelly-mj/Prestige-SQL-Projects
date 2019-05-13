-- [SHELL] Contract Changes
-- Kelly MJ 5/13/2019: Displays student records which have had contract changes

SELECT t1.lastName, t1.firstName -- , t1.studentId, t1.registrationId
/*	, CONCAT(IF(t1.studentCampus <> t2.studentCampus, 'campus; ', '')
			 , IF(t1.startDate <> t2.startDate, 'start date; ', '')
			 , IF(t1.endDate <> t2.endDate, 'end date; ', '')
			 , IF(t1.programmeId <> t2.programmeId, 'program; ', '')
			 , IF(t1.enrollmentType <> t2.enrollmentType, 'enrollment type', '') ) AS 'What Changed?'  */
	, IF(t1.studentCampus <> t2.studentCampus, (SELECT campusName FROM Campuses WHERE campusCode = t1.studentCampus), '') AS 'Old Campus'
    , IF(t1.studentCampus <> t2.studentCampus, (SELECT campusName FROM Campuses WHERE campusCode = t2.studentCampus), '') AS 'New Campus'
    , IF(t1.startDate <> t2.startDate, DATE_FORMAT(t1.startDate, '%m/%d/%Y'), '') AS 'Old Start Date'
    , IF(t1.startDate <> t2.startDate, DATE_FORMAT(t2.startDate, '%m/%d/%Y'), '') AS 'New Start Date'
    , IF(t1.endDate <> t2.endDate, DATE_FORMAT(t1.endDate, '%m/%d/%Y'), '') AS 'Old End Date'
    , IF(t1.endDate <> t2.endDate, DATE_FORMAT(t2.endDate, '%m/%d/%Y'), '') AS 'New End Date'
    , IF(t1.programmeId <> t2.programmeId, (SELECT programmeName FROM Programmes WHERE programmeId = t1.programmeId), '') AS 'Old Program'
    , IF(t1.programmeId <> t2.programmeId, (SELECT programmeName FROM Programmes WHERE programmeId = t2.programmeId), '') AS 'New Program'
    , IF(t1.enrollmentType <> t2.enrollmentType, t1.enrollmentType, '') AS 'Old Enroll. Type'
    , IF(t1.enrollmentType <> t2.enrollmentType, t2.enrollmentType, '') AS 'New Enroll. Type'
    
FROM (
	SELECT S.lastName, S.firstName
		, (SELECT MAX(creationDtTm) FROM Registrations_Audit WHERE registrationId = R.registrationId AND creationDtTm < RA1_max.RA1_dateMax) AS RA2_dateMax
        , RA1.*
        , RA1_max.RA1_dateMax
        
	FROM Students S
    
    INNER JOIN Registrations R ON R.studentId = S.studentId
		AND R.isActive = 1

	INNER JOIN (SELECT registrationId, MAX(lastUpdateDtTm) AS RA1_dateMax FROM Registrations_Audit WHERE isActive = 1 GROUP BY registrationId) RA1_max
		ON RA1_max.registrationId = R.registrationId

	INNER JOIN Registrations_Audit RA1
		ON RA1.registrationId = RA1_max.registrationId
		AND RA1.lastUpdateDtTm = RA1_max.RA1_dateMax
	
    WHERE S.isActive = 1
      AND S.studentCampus = 34652
      AND SUBSTR(S.lastName, 1, 1) NOT IN ('a', 'b', 'c',  'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l')
    
--    LIMIT 150
	) t1

INNER JOIN Registrations_Audit t2
	ON t2.registrationId = t1.registrationId
	AND t2.lastUpdateDtTm = t1.RA2_dateMax
    
WHERE t1.isActive = 1
AND (  t1.studentCampus <> t2.studentCampus
    OR t1.startDate <> t2.startDate
    OR t1.endDate <> t2.endDate
    OR t1.programmeId <> t2.programmeId
    OR t1.enrollmentType <> t2.enrollmentType )