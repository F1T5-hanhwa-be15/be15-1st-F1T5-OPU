-- 프로필
-- 1. 다른 사용자 프로필
-- TEST-013 - 사용자 프로필 조회
				-- 사용자(닉네임, 프로필사진, 한줄소개), 등급(등급 이름) 
				-- , OPU 추가(성취율), 게시글(게시글 수), 
				-- , 팔로우 관계 (팔로잉, 팔로워 수)

SELECT 
    u.nickname AS '닉네임',
    u.profile_img AS '프로필 사진',
    u.introduce AS '한줄 소개',
    l.level_title AS '등급',
    -- 성취율 계산 (opu_add 테이블에서 is_check = 'Y' 비율)
    CASE 
        WHEN COALESCE(o.total, 0) = 0 THEN 0
        ELSE ROUND((COALESCE(o.checked_count, 0) * 100.0) / o.total)
    END AS '성취율',
    -- 게시글 수 계산
    COALESCE(p.게시글수, 0) AS '게시글수',
    -- 팔로잉 수 계산
    COALESCE(f.팔로잉수, 0) AS '팔로잉수',
    -- 팔로워 수 계산
    COALESCE(fw.팔로워수, 0) AS '팔로워수'
FROM user u
JOIN level l ON u.level_id = l.level_id
LEFT JOIN (
    SELECT 
        user_code, 
        COUNT(*) AS total,  -- 전체 개수
        SUM(CASE WHEN is_check = 'Y' THEN 1 ELSE 0 END) AS checked_count  -- 'Y'인 개수
    FROM opu_add
    GROUP BY user_code
) o ON u.user_code = o.user_code
LEFT JOIN (
    SELECT 
        user_code, 
        COUNT(*) AS 게시글수
    FROM post
    GROUP BY user_code
) p ON u.user_code = p.user_code
LEFT JOIN (
    SELECT 
        following_code AS user_code, 
        COUNT(*) AS 팔로잉수
    FROM follow
    GROUP BY following_code
) f ON u.user_code = f.user_code
LEFT JOIN (
    SELECT 
        follower_code AS user_code, 
        COUNT(*) AS 팔로워수
    FROM follow
    GROUP BY follower_code
) fw ON u.user_code = fw.user_code   -- 조회할 사용자 코드
WHERE u.is_public = 'Y';


UPDATE user
   SET is_public = 'Y';

-- TEST-014 - 사용자 팔로우 (다른 사용자 프로필)
				-- 사용자(사용자코드)
				-- 본인 사용자 코드
				-- 팔로우

INSERT INTO follow (following_code, follower_code)
VALUES 
	(8, 16)
ON DUPLICATE KEY UPDATE following_code = VALUES(following_code);			-- 임의:팔로우/팔로워 사용자 코드

SELECT * FROM follow WHERE following_code = 8;



-- TEST-015 - 사용자 팔로우 취소  (다른 사용자 프로필)
				-- 사용자(사용자코드)
				-- 본인 사용자 코드
				-- 팔로우

DELETE
  FROM follow
 WHERE following_code = 8				-- 임의:팔로잉 사용자 코드
 	AND follower_code = 16			-- 임의:팔로워 사용자 코드
 LIMIT 1;

SELECT * FROM follow WHERE following_code = 8;



-- 2. 사용자 프로필(본인)
-- TEST-016 - 팔로워 목록 조회
				-- 본인 사용자 코드
				-- 팔로두 ID
				-- 팔로우 ID를 통한 타 사용자 프로필 사진/닉네임

SELECT
		  u.profile_img AS '프로필사진'
		, u.nickname AS '닉네임'
  FROM user u
  JOIN follow f ON u.user_code = f.following_code
  WHERE f.follower_code = 2;							-- 임의의 사용자



-- TEST-017 - 팔로잉 목록 조회
				-- 본인 사용자 코드
				-- 팔로두 ID
				-- 팔로우 ID를 통한 타 사용자 프로필 사진/닉네임

SELECT
		  fu.profile_img AS '프로필사진'
		, fu.nickname AS '닉네임'
  FROM user fu
  JOIN follow f ON fu.user_code = f.follower_code
  WHERE f.following_code = 2;							-- 임의의 사용자



-- TEST-018 - 팔로워 취소
				-- 본인 사용자 코드
				-- 팔로두 ID

DELETE
  FROM follow
 WHERE following_code = 8				-- 임의:본인 사용자 코드
 	AND follower_code = 16			-- 임의:팔로워 사용자 코드
 LIMIT 1;

SELECT * FROM follow WHERE following_code = 8;



-- TEST-019 - 팔로잉 취소
				-- 본인 사용자 코드
				-- 팔로두 ID

DELETE
  FROM follow
 WHERE following_code = 8				-- 임의:팔로잉 사용자 코드
 	AND follower_code = 2				-- 임의:본인 사용자 코드
 LIMIT 1;

SELECT * FROM follow WHERE follower_code = 2;
