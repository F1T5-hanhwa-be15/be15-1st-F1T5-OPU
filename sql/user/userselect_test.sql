-- resultrank(사용자아이디, 보고싶은 순위, 결과)

WITH RankedScores AS (
    SELECT
        user_code,
        CASE 
            WHEN score_type = 'knowledge' THEN '지식'
            WHEN score_type = 'culture' THEN '문화생활'
            WHEN score_type = 'health' THEN '건강'
            WHEN score_type = 'food' THEN '음식'
            ELSE score_type
        END AS score_type_kr,
        score_value,
        DENSE_RANK() OVER (PARTITION BY user_code ORDER BY score_value DESC) AS score_rank
    FROM user_result
),
TopScores AS (
    SELECT 
        user_code, 
        GROUP_CONCAT(score_type_kr ORDER BY score_rank ASC SEPARATOR ', ') AS 상위_성향_유형
    FROM RankedScores
    WHERE score_rank <= 2  -- ✅ 2위까지 포함 (동점 포함 가능)
    GROUP BY user_code
)
SELECT 
    u.user_code,
    u.user_id AS '아이디',
    u.user_name AS '이름',
    u.nickname AS '닉네임',
    u.phone AS '전화번호',
    u.birth AS '생년월일',
    u.profile_img,
    u.introduce AS '한줄소개',
    u.is_alarm AS '알람설정',
    u.is_public AS '프로필공개',
    u.level_id AS '등급',
    COALESCE(ts.상위_성향_유형, '데이터 없음') AS '성향검사 결과'
FROM user u
LEFT JOIN TopScores ts ON u.user_code = ts.user_code
WHERE u.user_code = 1;


