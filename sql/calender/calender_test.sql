-- 캘린더 조회
-- 1. 성취율 조회
DROP FUNCTION check_achievement_rate;
DELIMITER //

CREATE FUNCTION check_achievement_rate(
	id INT, 
	check_date DATE 
)
RETURNS CHAR(10) 
DETERMINISTIC
BEGIN
	DECLARE all_opu INT;
	DECLARE check_opu INT;
	DECLARE achievement_rate CHAR(10);
	
	SELECT COUNT(opu_add_id) INTO all_opu
	FROM opu_add
	WHERE user_code = id AND date = check_date;
	
	SELECT COUNT(opu_add_id) INTO check_opu
	FROM opu_add
	WHERE user_code = id AND is_check = 'y' AND  date = check_date;
	
	IF all_opu > 0 THEN
		SET achievement_rate = CONCAT(ROUND((check_opu * 100.0) / all_opu), '%');
	ELSE
		SET achievement_rate = '0%';
	END IF;
	
	RETURN achievement_rate;
END //

DELIMITER ;

-- select check_achievement_rate(6,'2025-02-02');

-- 2.사용자 OPU 기록 조회
SELECT
		a.date, 
		c.opu_content 'user_opu_content',
		CONCAT(a.opu_content, ' ', d.time_content, '분 동안 하기') AS 'opu_content',
		a.is_check
FROM opu_add a
JOIN opu_list b ON a.opu_list_id = b.opu_list_id
JOIN opu_script c ON b.opu_id= c.opu_id
JOIN time d ON b.time_id = d.time_id
WHERE a.user_code = 6 	
AND a.date = '2025-02-02'
AND is_delete ='N';
