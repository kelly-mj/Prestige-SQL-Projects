-- [VICTORIAS] Hoursheets
-- Kelly MJ  |  8/20/2019
-- Displays the number of services performed, per day, per service, for the selected month and student.
-- [?Student ID Number] [?Month (MM)] [?Year (YYYY)] <-- allows this field to appear before 2018-07-07

(SELECT PS.requirements AS 'Service Name'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  1 , SS.serviceUnit, NULL)), 0), 0) AS '1'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  2 , SS.serviceUnit, NULL)), 0), 0) AS '2'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  3 , SS.serviceUnit, NULL)), 0), 0) AS '3'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  4 , SS.serviceUnit, NULL)), 0), 0) AS '4'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  5 , SS.serviceUnit, NULL)), 0), 0) AS '5'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  6 , SS.serviceUnit, NULL)), 0), 0) AS '6'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  7 , SS.serviceUnit, NULL)), 0), 0) AS '7'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  8 , SS.serviceUnit, NULL)), 0), 0) AS '8'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  9 , SS.serviceUnit, NULL)), 0), 0) AS '9'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  10 , SS.serviceUnit, NULL)), 0), 0) AS '10'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  11 , SS.serviceUnit, NULL)), 0), 0) AS '11'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  12 , SS.serviceUnit, NULL)), 0), 0) AS '12'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  13 , SS.serviceUnit, NULL)), 0), 0) AS '13'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  14 , SS.serviceUnit, NULL)), 0), 0) AS '14'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  15 , SS.serviceUnit, NULL)), 0), 0) AS '15'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  16 , SS.serviceUnit, NULL)), 0), 0) AS '16'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  17 , SS.serviceUnit, NULL)), 0), 0) AS '17'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  18 , SS.serviceUnit, NULL)), 0), 0) AS '18'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  19 , SS.serviceUnit, NULL)), 0), 0) AS '19'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  20 , SS.serviceUnit, NULL)), 0), 0) AS '20'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  21 , SS.serviceUnit, NULL)), 0), 0) AS '21'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  22 , SS.serviceUnit, NULL)), 0), 0) AS '22'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  23 , SS.serviceUnit, NULL)), 0), 0) AS '23'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  24 , SS.serviceUnit, NULL)), 0), 0) AS '24'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  25 , SS.serviceUnit, NULL)), 0), 0) AS '25'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  26 , SS.serviceUnit, NULL)), 0), 0) AS '26'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  27 , SS.serviceUnit, NULL)), 0), 0) AS '27'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  28 , SS.serviceUnit, NULL)), 0), 0) AS '28'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  29 , SS.serviceUnit, NULL)), 0), 0) AS '29'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  30 , SS.serviceUnit, NULL)), 0), 0) AS '30'
    , IF( DAY(LAST_DAY(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'))) < 31
        , 'n/a'
        , FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) = 31, SS.serviceUnit, NULL)), 0), 0)) AS '31'
    , PS.requiredUnits AS 'Required Units'
    , COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  [?Month (MM)] AND YEAR(SS.serviceDateTime) = [?Year (YYYY)] , SS.serviceUnit, NULL)), 0) AS 'Current Month'
    , COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  MONTH(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)) AND YEAR(SS.serviceDateTime) = YEAR(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)
) , SS.serviceUnit, NULL)), 0) AS 'Previous Month'
    , FORMAT(COALESCE(SUM(SS.serviceUnit), 0), 0) AS 'Total to Date'

FROM (SELECT DISTINCT programServiceId, requirements, requiredUnits, serviceType
        FROM ProgramServices PS
        INNER JOIN Programmes P ON P.programmeId = PS.programId
        WHERE P.programmeName = 'Master Esthetics'
          AND PS.isActive = 1
          AND PS.<ADMINID>) PS

LEFT JOIN ( SELECT SS.*
    FROM StudentService SS
    WHERE SS.isActive = 1
      AND SS.studentId = (SELECT studentId FROM Students WHERE idNumber = [?Student ID Number]) ) SS
    ON SS.programServiceId = PS.programServiceId

WHERE PS.serviceType = 'Practical'

GROUP BY PS.programServiceId)

UNION
(SELECT CONCAT('<strong>Practice Total</strong>') AS 'Service Name'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  1 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '1'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  2 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '2'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  3 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '3'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  4 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '4'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  5 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '5'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  6 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '6'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  7 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '7'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  8 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '8'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  9 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '9'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  10 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '10'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  11 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '11'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  12 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '12'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  13 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '13'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  14 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '14'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  15 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '15'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  16 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '16'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  17 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '17'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  18 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '18'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  19 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '19'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  20 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '20'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  21 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '21'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  22 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '22'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  23 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '23'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  24 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '24'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  25 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '25'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  26 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '26'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  27 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '27'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  28 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '28'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  29 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '29'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  30 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '30'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  31 , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS '31'
    , CONCAT('<strong>', SUM(PS.requiredUnits), '</strong>') AS 'Required Units'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  [?Month (MM)] AND YEAR(SS.serviceDateTime) = [?Year (YYYY)] , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS 'Current Month'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  MONTH(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)) AND YEAR(SS.serviceDateTime) = YEAR(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)
) , SS.serviceUnit, NULL)), 0), 0), '</strong>') AS 'Previous Month'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(SS.serviceUnit), 0), 0), '</strong>') AS 'Total to Date'

FROM (SELECT DISTINCT programServiceId, requirements, requiredUnits, serviceType
        FROM ProgramServices PS
        INNER JOIN Programmes P ON P.programmeId = PS.programId
        WHERE P.programmeName = 'Master Esthetics'
          AND PS.isActive = 1
          AND PS.<ADMINID>) PS

LEFT JOIN ( SELECT SS.*
    FROM StudentService SS
    WHERE SS.isActive = 1
      AND SS.studentId = (SELECT studentId FROM Students WHERE idNumber = [?Student ID Number]) ) SS
    ON SS.programServiceId = PS.programServiceId

WHERE PS.serviceType = 'Practical' )

UNION
(SELECT PS.requirements AS 'Service Name'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  1 , SS.serviceDuration, NULL))/60, 2), 0) AS '1'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  2 , SS.serviceDuration, NULL))/60, 2), 0) AS '2'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  3 , SS.serviceDuration, NULL))/60, 2), 0) AS '3'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  4 , SS.serviceDuration, NULL))/60, 2), 0) AS '4'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  5 , SS.serviceDuration, NULL))/60, 2), 0) AS '5'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  6 , SS.serviceDuration, NULL))/60, 2), 0) AS '6'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  7 , SS.serviceDuration, NULL))/60, 2), 0) AS '7'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  8 , SS.serviceDuration, NULL))/60, 2), 0) AS '8'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  9 , SS.serviceDuration, NULL))/60, 2), 0) AS '9'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  10 , SS.serviceDuration, NULL))/60, 2), 0) AS '10'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  11 , SS.serviceDuration, NULL))/60, 2), 0) AS '11'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  12 , SS.serviceDuration, NULL))/60, 2), 0) AS '12'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  13 , SS.serviceDuration, NULL))/60, 2), 0) AS '13'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  14 , SS.serviceDuration, NULL))/60, 2), 0) AS '14'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  15 , SS.serviceDuration, NULL))/60, 2), 0) AS '15'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  16 , SS.serviceDuration, NULL))/60, 2), 0) AS '16'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  17 , SS.serviceDuration, NULL))/60, 2), 0) AS '17'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  18 , SS.serviceDuration, NULL))/60, 2), 0) AS '18'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  19 , SS.serviceDuration, NULL))/60, 2), 0) AS '19'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  20 , SS.serviceDuration, NULL))/60, 2), 0) AS '20'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  21 , SS.serviceDuration, NULL))/60, 2), 0) AS '21'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  22 , SS.serviceDuration, NULL))/60, 2), 0) AS '22'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  23 , SS.serviceDuration, NULL))/60, 2), 0) AS '23'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  24 , SS.serviceDuration, NULL))/60, 2), 0) AS '24'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  25 , SS.serviceDuration, NULL))/60, 2), 0) AS '25'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  26 , SS.serviceDuration, NULL))/60, 2), 0) AS '26'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  27 , SS.serviceDuration, NULL))/60, 2), 0) AS '27'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  28 , SS.serviceDuration, NULL))/60, 2), 0) AS '28'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  29 , SS.serviceDuration, NULL))/60, 2), 0) AS '29'
    , COALESCE(FORMAT(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  30 , SS.serviceDuration, NULL))/60, 2), 0) AS '30'
    , IF( DAY(LAST_DAY(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'))) < 31
        , 'n/a'
        , FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) = 31, SS.serviceDuration, NULL))/60, 0), 2 )) AS '31'
    , PS.requiredUnits AS 'Required Units'
    , FORMAT(COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  [?Month (MM)] AND YEAR(SS.serviceDateTime) = [?Year (YYYY)] , SS.serviceDuration, NULL))/60, 0), 2) AS 'Current Month'
    , FORMAT(COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  MONTH(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)) AND YEAR(SS.serviceDateTime) = YEAR(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)
) , SS.serviceDuration, NULL)), 0)/60, 2) AS 'Previous Month'
    , FORMAT(COALESCE(SUM(SS.serviceDuration), 0)/60, 2) AS 'Total to Date'

FROM (SELECT DISTINCT programServiceId, requirements, requiredUnits, serviceType
        FROM ProgramServices PS
        INNER JOIN Programmes P ON P.programmeId = PS.programId
        WHERE P.programmeName = 'Master Esthetics'
          AND PS.isActive = 1
          AND PS.<ADMINID>) PS

LEFT JOIN ( SELECT SS.*
    FROM StudentService SS
    WHERE SS.isActive = 1
      AND SS.studentId = (SELECT studentId FROM Students WHERE idNumber = [?Student ID Number]) ) SS
    ON SS.programServiceId = PS.programServiceId

WHERE PS.serviceType = 'Theory'

GROUP BY PS.programServiceId)

UNION
(SELECT CONCAT('<strong>Theory Total</strong>') AS 'Service Name'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  1 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '1'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  2 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '2'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  3 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '3'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  4 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '4'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  5 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '5'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  6 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '6'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  7 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '7'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  8 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '8'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  9 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '9'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  10 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '10'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  11 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '11'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  12 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '12'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  13 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '13'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  14 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '14'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  15 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '15'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  16 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '16'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  17 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '17'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  18 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '18'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  19 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '19'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  20 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '20'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  21 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '21'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  22 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '22'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  23 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '23'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  24 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '24'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  25 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '25'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  26 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '26'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  27 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '27'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  28 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '28'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  29 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '29'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  30 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '30'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(YEAR(SS.serviceDateTime) = [?Year (YYYY)] AND MONTH(SS.serviceDateTime) = [?Month (MM)] AND DAY(SS.serviceDateTime) =  31 , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS '31'
    , CONCAT('<strong>', SUM(PS.requiredUnits), '</strong>') AS 'Required Units'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  [?Month (MM)] AND YEAR(SS.serviceDateTime) = [?Year (YYYY)] , SS.serviceDuration, NULL))/60, 0), 2), '</strong>') AS 'Current Month'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(IF(MONTH(SS.serviceDateTime) =  MONTH(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)) AND YEAR(SS.serviceDateTime) = YEAR(DATE_SUB(CONCAT('[?Year (YYYY)]', '-', '[?Month (MM)]', '-01'), INTERVAL 1 MONTH)
) , SS.serviceDuration, NULL)), 0), 2), '</strong>') AS 'Previous Month'
    , CONCAT('<strong>', FORMAT(COALESCE(SUM(SS.serviceDuration)/60, 0), 2), '</strong>') AS 'Total to Date'

FROM (SELECT DISTINCT programServiceId, requirements, requiredUnits, serviceType
        FROM ProgramServices PS
        INNER JOIN Programmes P ON P.programmeId = PS.programId
        WHERE P.programmeName = 'Master Esthetics'
          AND PS.isActive = 1
          AND PS.<ADMINID>) PS

LEFT JOIN ( SELECT SS.*
    FROM StudentService SS
    WHERE SS.isActive = 1
      AND SS.studentId = (SELECT studentId FROM Students WHERE idNumber = [?Student ID Number]) ) SS
    ON SS.programServiceId = PS.programServiceId

WHERE PS.serviceType = 'Theory' )
