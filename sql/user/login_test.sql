-- 로그인
DELIMITER //

CREATE PROCEDURE userlogin(
    IN p_userid VARCHAR(30),
    IN p_password VARCHAR(255),
    OUT p_message VARCHAR(50)
)
BEGIN
    DECLARE id_count INT;
    DECLARE pass_count INT;

    -- 아이디 또는 비밀번호가 이미 존재하는지 확인
    SELECT COUNT(*) INTO pass_count FROM user WHERE PASSWORD = p_password;
    SELECT COUNT(*) INTO id_count FROM user WHERE user_id = p_userid;

    IF id_count > 0 AND pass_count > 0 THEN
        SET p_message = '로그인 성공!';
    ELSE
        SET p_message = '아이디 또는 비밀번호가 일치하지 않습니다.';
    END IF;
END //

DELIMITER ;

DROP PROCEDURE userlogin;

SET @p_massage = '';
CALL userlogin('dnjswns', '123456', @p_massage);
SELECT @p_massage;