-- 로그인
DELIMITER //

CREATE PROCEDURE userlogin(
    IN p_userid VARCHAR(30),
    IN p_password VARCHAR(255),
    OUT p_message VARCHAR(50)
)
BEGIN
    DECLARE login_count INT;

    -- 올바른 ID와 비밀번호가 일치하는 사용자 수 확인
    SELECT COUNT(*) INTO login_count 
    FROM user 
    WHERE user_id = p_userid AND PASSWORD = p_password;

    -- 로그인 검증
    IF login_count > 0 THEN
        SET p_message = '로그인 성공!';
    ELSE
        SET p_message = '아이디 또는 비밀번호가 일치하지 않습니다.';
    END IF;
END //

DELIMITER ;

-- DROP PROCEDURE userlogin;

SET @p_massage = '';
CALL userlogin('dnjswns', '208', @p_massage);
SELECT @p_massage;
