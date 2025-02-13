-- resultrank(사용자아이디, 보고싶은 순위, 결과)

SELECT 
		 user_code
	  , user_id 아아디
	  , user_name 이름
	  , nickname 닉네임
	  , phone 전화번호
	  , birth 생년월일
	  , profile_img 
	  , introduce 한줄소개
	  , is_alarm 알람설정
	  , is_public 프로필공개
	  , level_id 등급
  FROM user u
 WHERE user_code = 1;
-- 성향검사 결과순위
SELECT
		 score_type
	  , RANK() OVER(ORDER BY score_value DESC) AS score_rank
  FROM user_result
 WHERE user_code = 1;
-- 성향검사 결과
CREATE OR REPLACE VIEW user_result AS
SELECT user_code, 'health' AS score_type, health_score AS score_value FROM result
UNION ALL
SELECT user_code, 'food', food_score FROM result
UNION ALL
SELECT user_code, 'culture', culture_score FROM result
UNION ALL
SELECT user_code, 'knowledge', knowledge_score FROM result;

SELECT * FROM user_result;

  
