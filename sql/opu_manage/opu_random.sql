-- 목차
-- 1. 로그인한 사용자
-- 2. 로그인 하지 않은 사용자


-- 1. 로그인한 사용자
-- 1-1. user별 rank 매기는 view 생성
CREATE OR REPLACE VIEW user_result_rank AS
SELECT
    user_code,
    score_type,
    score_value,
    RANK() OVER (PARTITION BY user_code ORDER BY score_value DESC) AS rank_value
FROM
(
    SELECT user_code, '1'      AS score_type, health_score   AS score_value FROM result
    UNION ALL
    SELECT user_code, '4'      AS score_type, food_score     AS score_value FROM result
    UNION ALL
    SELECT user_code, '3'  AS score_type, culture_score  AS score_value FROM result
    UNION ALL
    SELECT user_code, '2'      AS score_type, knowledge_score AS score_value FROM result
) t;

SELECT * from user_result_rank;



-- 1-2. 프로시저 생성성
DELIMITER //

CREATE OR REPLACE PROCEDURE getRandomOPUById(
	IN id INTEGER,
	IN time_length INTEGER,
  OUT opu_list_id_result INT
)
BEGIN 
	DECLARE user_time INTEGER;
	
	CASE
		WHEN (time_length >= 60) THEN
			SET user_time = 4;
		when (time_length >= 30) THEN
			SET user_time = 3;
		WHEN (time_length >= 10) THEN
			SET user_time = 2;
		ELSE
			SET user_time = 1;
	END CASE;
	
   SELECT ol.opu_list_id INTO opu_list_id_result
     FROM user_result_rank u
     JOIN opu_category o ON o.opu_category_id = u.score_type
     JOIN user ON u.user_code = user.user_code
     JOIN opu_script os ON os.opu_category_id = o.opu_category_id
     JOIN opu_list ol ON ol.opu_id = os.opu_id
     JOIN time t ON ol.time_id = t.time_id
    WHERE user.user_code = id
      AND u.rank_value IN (1,2)
      AND ol.time_id = user_time
    ORDER BY RAND()
	 LIMIT 1;
END //

DELIMITER ;


-- 1-3. 실행 쿼리
CALL getRandomOPUById(10, 5);
CALL getRandomOPUById(13, 10);

-- 2. 로그인 하지 않은 사용자
-- 2-1. 프로시저 생성
DELIMITER //

CREATE or replace PROCEDURE getRandomOPU_experience_version(
	IN time_length INTEGER
)
BEGIN 
	DECLARE user_time INTEGER;
	
	CASE
		WHEN (time_length >= 60) THEN
			SET user_time = 4;
		when (time_length >= 30) THEN
			SET user_time = 3;
		WHEN (time_length >= 10) THEN
			SET user_time = 2;
		ELSE
			SET user_time = 1;
	END CASE;
	
   SELECT o.opu_category_id , o.opu_category_name, os.opu_content, t.time_content
     FROM opu_category o
     JOIN opu_script os ON os.opu_category_id = o.opu_category_id
     JOIN opu_list ol ON ol.opu_id = os.opu_id
     JOIN time t ON ol.time_id = t.time_id
    WHERE ol.time_id = user_time
    ORDER BY RAND()
	 LIMIT 1;
END //

DELIMITER ;

-- 2-2. 실행 쿼리
CALL getRandomOPU_experience_version(30);

