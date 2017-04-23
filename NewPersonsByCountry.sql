SELECT countryId, SUBSTR(P.id, 1,4) startyear, COUNT(P.id) FROM Persons P
GROUP BY countryId, startyear;
