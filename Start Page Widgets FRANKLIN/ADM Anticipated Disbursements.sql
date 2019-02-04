SELECT DATE_FORMAT(CURDATE(), '<strong>In %M:</strong>') AS 'Student Name' , NULL 'Disb. Date', NULL 'Details', NULL 'Amount'

/*
 *  Disbursements in the current month
 */
UNION
SELECT CONCAT('<a target="_blank" href="/einstein-freshair/admin_view_program_invoice.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ' ', S.firstName, '</a>') 'Student Name'
    , CONCAT('<div style="padding-top: 3px; padding-bottom: 3px;">', SR.refundDate, '</div>')   'Disb. Date'
    , CONCAT(SR.refundName, ' - ', SR.refundNote, ' (\'', SUBSTRING(SR.awardYear, 3, 2), '-\'', SUBSTRING(SR.awardYear, 8, 2), ' Disb. #', CAST(SR.disbursementNo AS CHAR), ')') 'Details' -- Format: "FDLPS - 1000-1250 HRS ('18-'19 Disb. #1)"
    , CONCAT('$', SR.refundAmount) 'Amount' -- amount
    
FROM StudentRefunds SR

INNER JOIN Students S
    ON S.studentId = SR.studentId
    AND S.isActive = 1

WHERE MONTH(SR.refundDate) = MONTH(CURDATE())
AND YEAR(SR.refundDate) = YEAR(CURDATE())
AND SR.<ADMINID>

/*
 *  Upcoming disbursements in the next 2 months
 */

/*
UNION
SELECT 'Upcoming:', NULL, NULL, NULL
UNION

SELECT CONCAT('<a target="_blank" href="/einstein-freshair/admin_view_program_invoice.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ' ', S.firstName, '</a>') 'Student Name'
    , SR.refundDate 'Disb. Date'
    , CONCAT(SR.refundName, ' - ', SR.refundNote, ' (', SR.awardYear, ' Disb. #', CAST(SR.disbursementNo AS CHAR), ')') 'Details' -- "FDLPS  — 1000-1250 HRS (2018-2019 Disbursement# 1)" --> "FDLPS - 1000-1250 HRS ('18-'19 Disb. #1)"
    , CONCAT('$', SR.refundAmount) 'Disb. Amount'   -- amount
    
FROM StudentRefunds SR

INNER JOIN Students S
    ON S.studentId = SR.studentId
    AND S.isActive = 1

WHERE SR.refundDate BETWEEN DATE_ADD(LAST_DAY(CURDATE()), INTERVAL 1 DAY) AND DATE_ADD(LAST_DAY(CURDATE()), INTERVAL 2 MONTH)
AND SR.<ADMINID>
*/