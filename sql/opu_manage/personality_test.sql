-- 성향검사
-- TEST-020 - 성향 검사
				-- 사용자코드
				-- 성향검사 결과
SELECT * FROM result;
SELECT * FROM user;

INSERT INTO user (user_id, user_name, PASSWORD, nickname, phone, birth, profile_img, introduce)
VALUES ('traittest', '성향', 1234, '성향테스트', '01012341234', '2000-01-21', 'image15', '성향테스트를 위해 생성한 유저입니다.');

SELECT * FROM user 
 WHERE user_code = (
    SELECT user_code
    FROM user
    WHERE user_name = '성향'
    LIMIT 1
);

SELECT * FROM user ORDER BY user_code DESC LIMIT 1;

INSERT INTO result (user_code, health_score, knowledge_score, culture_score, food_score)
VALUES (
	(SELECT user_code FROM user ORDER BY user_code DESC LIMIT 1)
	, 30, 10, 20, 40)
 ;

SELECT * FROM result ORDER BY  user_code DESC LIMIT 1;


-- TEST-021 - 성향 검사 결과 조회
				-- 성향 검사 결과 테이블
				-- (health_score, food_score, culture_score, knowledge_score)

SELECT 
		  health_score AS '건강점수'
		, knowledge_score AS '지식점수'
		, culture_score AS '문화생활점수'
		, food_score AS '음식점수'
  FROM result
 ORDER BY  user_code DESC LIMIT 1;



-- TEST-020 - 성향 재검사
				-- 사용자코드
				-- 성향검사 결과

UPDATE result
   SET health_score = 30
		, knowledge_score = 40
		, culture_score = 10
		, food_score = 20
 WHERE user_code = (
    SELECT user_code
    FROM user
    WHERE user_name = '성향'
    LIMIT 1
);

SELECT * FROM result ORDER BY  user_code DESC LIMIT 1;
