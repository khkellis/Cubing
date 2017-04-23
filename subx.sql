DELIMITER //
CREATE PROCEDURE subx(id VARCHAR(5),subtime NUMERIC)
BEGIN
SELECT * FROM(	
    SELECT 
		personName, 
		SUM(if(value1<100*subtime AND value1>0, 1,0) 
			  + if(value2<100*subtime AND value2>0,1,0) 
			  + if(value3<100*subtime AND value3>0,1,0) 
			  + if(value4<100*subtime AND value4>0,1,0) 
			  + if(value5<100*subtime AND value5>0,1,0)) AS Sub10Count
			FROM Results
			WHERE eventId = id
            GROUP BY personName
            ) A
WHERE Sub10Count > 0
ORDER BY Sub10Count DESC;
END//