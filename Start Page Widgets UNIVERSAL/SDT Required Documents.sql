-- [SHELL] SDT Required Documents
-- Kelly MJ  |  8/23/2018

SELECT IF( FI.formInstanceId IS NULL
        , CONCAT('<span style="padding-left: 1em;"><a target="_blank" href="addedit_form_instance.jsp?userId=', CAST([USERID] AS CHAR), '&userType=1&formId=', CAST(F.formId AS CHAR), '">', F.formTitle,'</a></span>')
        , CONCAT('<span style="color: green;">✔ ', F.formTitle, '</span>')) AS 'Form'

FROM Forms F
LEFT JOIN FormInstances FI ON FI.formId = F.formId
  AND FI.userId = [USERID]
  AND FI.isActive = 1
WHERE F.isActive = 1
  AND F.formTitle IN (
      'Enrollment Agreement'
      , 're entery Visalia ama'
      , 'Prior Education Disclosure and Evaluation'
      , 'Re-Entry Enrollment Agreement Sparks')

  AND F.forStudent = 1
  AND F.<ADMINID>

GROUP BY F.formId
