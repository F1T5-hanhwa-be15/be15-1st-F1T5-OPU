-- 사용자 등급 변경
-- 1. 유저의 등급을 수정하기 위해 필요한 정보들 프로시저로 구현해 가져오기
DELIMITER //

CREATE PROCEDURE update_user_level
(IN p_user_code INT)
BEGIN
    DECLARE post_count INT;
    DECLARE opu_count INT;

    -- 사용자의 게시글 개수 조회 (관리자 제외)
    SELECT COUNT(*) INTO post_count
    FROM post
    WHERE user_code = p_user_code 
      AND is_delete = 'N'
      AND NOT EXISTS (SELECT 1 FROM user WHERE user_code = p_user_code AND is_manager = 'Y');

    -- 사용자의 OPU 완료 개수 조회
    SELECT COUNT(*) INTO opu_count
    FROM opu_add
    WHERE user_code = p_user_code AND is_check = 'Y';

    -- 등급 업데이트
    UPDATE user
    SET level_id = CASE 
        WHEN post_count >= 200 AND opu_count >= 200 THEN 5 
        WHEN post_count >= 100 AND opu_count >= 100 THEN 4 
        WHEN post_count >= 50  AND opu_count >= 50  THEN 3 
        WHEN post_count >= 5   AND opu_count >= 5   THEN 2 
        ELSE 1  
    END
    WHERE user_code = p_user_code;
END //

DELIMITER ;


-- 2. opu_add가 update 될 경우
DELIMITER //

CREATE TRIGGER update_user_level_after_opu
AFTER UPDATE ON opu_add
FOR EACH ROW
BEGIN
    CALL update_user_level(NEW.user_code);
END //

DELIMITER ;

-- 3. post가 추가된 이후
DELIMITER //

CREATE TRIGGER update_user_level_after_post
AFTER INSERT ON post
FOR EACH ROW
BEGIN
    CALL update_user_level(NEW.user_code);
END //

DELIMITER ;

-- 4. 상위 30명 선정해서 등급6으로 설정하기
DROP procedure update_ranker_level;
DELIMITER //

CREATE PROCEDURE update_ranker_level()
BEGIN
    UPDATE user
    SET level_id = 6
    WHERE user_code IN (
        SELECT user_code
        FROM (
            SELECT user_code, 
                   (SELECT COUNT(*) 
						  FROM post
						  WHERE user_code = u.user_code 
						  AND is_delete = 'N') AS post_count,
                   (SELECT COUNT(*) 
						  FROM opu_add 
					     WHERE user_code = u.user_code 
						  AND is_check = 'Y') AS opu_count
            FROM user u
            WHERE level_id = 5
            ORDER BY (post_count + opu_count) DESC
            LIMIT 30
        ) AS top_users
    );


    UPDATE user
    SET level_id = 5
    WHERE level_id = 6 AND user_code NOT IN (
        SELECT user_code
        FROM (
            SELECT user_code, 
                   (SELECT COUNT(*) 
						  FROM post 
						  WHERE user_code = u.user_code 
						  AND is_delete = 'N') AS post_count,
                   (SELECT COUNT(*) 
						  FROM opu_add 
						  WHERE user_code = u.user_code 
						  AND is_check = 'Y') AS opu_count
            FROM user u
            WHERE level_id = 5  -- 다이아 등급 이상
            ORDER BY (post_count + opu_count) DESC
            LIMIT 30
        ) AS top_users
    );
END //

DELIMITER ;