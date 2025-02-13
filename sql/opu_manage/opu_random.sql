-- 목차
-- 1. 로그인한 사용자
-- 2. 로그인 하지 않은 사용자


-- 1. 로그인한 사용자

-- result 초기 더미데이터
INSERT INTO result(user_code, health_score, food_score, culture_score, knowledge_score)
VALUES
(13, 10, 30, 20, 40),
(14, 20, 20, 40, 20),
(15, 40, 40, 0, 20),
(16, 30, 30, 30, 10),
(11, 50, 40, 10, 0),
(12, 10, 10, 10, 70);

-- opu 카테고리 더미데이터
INSERT INTO opu_category
VALUES 
 (1, '운동'),
 (2, '지식'),
 (3, '문화생활'),
 (4, '음식');

-- user별 rank 매기는 view 생성
CREATE OR REPLACE VIEW user_result_rank AS
SELECT
    user_code,
    score_type,
    score_value,
    RANK() OVER (PARTITION BY user_code ORDER BY score_value DESC) AS rank_value
FROM
(
    SELECT user_code, '운동'      AS score_type, health_score   AS score_value FROM result
    UNION ALL
    SELECT user_code, '음식'      AS score_type, food_score     AS score_value FROM result
    UNION ALL
    SELECT user_code, '문화생활'  AS score_type, culture_score  AS score_value FROM result
    UNION ALL
    SELECT user_code, '지식'      AS score_type, knowledge_score AS score_value FROM result
) t;

SELECT * from user_result_rank;

-- 랜덤 opu 뽑기
-- 1. 2위까지의 주제 뽑기
-- 2. 해당 주제의 opu목록에서 random 돌리기
DELIMITER //

CREATE PROCEDURE getRandomOPU(
	IN id VARCHAR(3),
	IN time_length INTEGER,
	OUT opu_list_id INTEGER
)
BEGIN 
   SELECT score_type
     FROM user_result_rank
     JOIN 
    ORDER BY rank_value
    WHERE user_code = id
      AND rank_value IN (1,2);
END //

DELIMITER ;
