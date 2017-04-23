DELIMITER //
CREATE PROCEDURE NRDatesTwoCols()
BEGIN
-- Joining the results from both the single and average query to get the date of both the current single and average NRs
-- Changed join to a left outer join, changed selection and ordering in largest query from average to single
SELECT S.personCountryId, S.eventId, S.NR, S.CompDate, A.NR, A.CompDate FROM 
	(-- Single Query
	-- Joining the table of NRs by date with the table of current NRs to get the table of current NRs by date
	SELECT SD.personCountryId, SD.eventId, SM.NR, SD.CompDate FROM
		-- Gettingn all the NR singles over all competitions with dates
		(SELECT R.personCountryId, R.eventId, R.best, CAST(CONCAT(C.year,'-',C.month,'-',C.day) AS DATE) AS CompDate
			FROM Results R JOIN Competitions C
				ON R.competitionId = C.id
			WHERE R.regionalSingleRecord LIKE '%R'
			ORDER BY R.personCountryId, R.eventId
			LIMIT 15000)SD
			
	JOIN
			
		-- Getting the actual NR    
		(SELECT R.personCountryId, R.eventId, MIN(R.best) NR
			FROM Results R JOIN Competitions C
				ON R.competitionId = C.id
			WHERE R.regionalSingleRecord LIKE '%R'
			GROUP BY R.personCountryId, R.eventId
			LIMIT 15000)SM
			
			ON SD.personCountryId = SM.personCountryId AND SD.eventID = SM.eventId AND SD.best = SM.NR
			ORDER BY SD.personCountryId, SD.eventId
            LIMIT 15000) S
            
LEFT JOIN
            
	(-- Average Query
	-- Joining the table of NRs by date with the table of current NRs to get the table of current NRs by date
	SELECT AD.personCountryId, AD.eventId, AM.NR, AD.CompDate FROM
		-- List of average NRs
		(SELECT R.personCountryId, R.eventId, R.average, CAST(CONCAT(C.year,'-',C.month,'-',C.day) AS DATE) AS CompDate
			FROM Results R JOIN Competitions C
				ON R.competitionId = C.id
			WHERE R.regionalAverageRecord LIKE '%R'
			ORDER BY R.personCountryId, R.eventId
			LIMIT 15000)AD
			
	JOIN
			
		-- List of current Average NRs
		(SELECT R.personCountryId, R.eventId, MIN(R.average) NR
			FROM Results R JOIN Competitions C
				ON R.competitionId = C.id
			WHERE R.regionalAverageRecord LIKE '%R'
			GROUP BY R.personCountryId, R.eventId
			LIMIT 15000)AM
			
			ON AD.personCountryId = AM.personCountryId AND AD.eventID = AM.eventId AND AD.average = AM.NR
			ORDER BY AD.personCountryId, AD.eventId
            LIMIT 15000) A
ON A.personCountryId = S.personCountryId AND A.eventId = S.eventId
ORDER BY S.personCountryId, S.eventId
LIMIT 15000
;
END//
