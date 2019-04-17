-- [U] Query Report: Dictionary Differences
-- Kelly MJ | 4/17/2019
-- Detects every phrase in a dictionary where the phrase does not match its translation.

SELECT W.word 'Phrase'
 	, T.translatedWord 'Translation'
    , DATE_FORMAT(T.lastUpdateDtTm, '%m/%d/%Y') 'Date Changed'


FROM (
	SELECT wordId, translatedWord, REPLACE(REPLACE(REPLACE(translatedWord, 'Â ', ''), ' ', ''), ' ', '') AS translatedWordNoSpaces, lastUpdateDtTm
    FROM Translations WHERE isActive = 1 AND <ADMINID>
    AND languageId = (SELECT languageId FROM Languages WHERE languageName = IF('[?Language]' = '', 'Prestige', '[?Language]'))) T


INNER JOIN (SELECT wordId, word, REPLACE(REPLACE(word, ' ', ''), ' ', '') AS wordNoSpaces FROM Words WHERE isActive = 1) W
	ON W.wordId = T.wordId

WHERE CASE '[?Ignore spacing differences{1|Yes|2|No}]'
		WHEN '1' THEN T.translatedWordNoSpaces <> W.wordNoSpaces   -- compares phrase (spaces removed) to its translation (spaces removed)
        WHEN '2' THEN T.translatedWord <> W.word                   -- compares original phrase to its original translation
	  END

ORDER BY W.word ASC
