-- 회원가입
INSERT INTO user
VALUES 
(17, 'dnjswns', '양원준', 0208, '꺽다리', '01002085234', '2000-02-08', 'image123', '26 남 키 193', CURRENT_TIMESTAMP, 'N', 'Y', 'N', 'N', NULL, DEFAULT);

DELIMITER //

CREATE PROCEDURE RegisterMember(
    IN p_username VARCHAR(30),
    IN p_userid VARCHAR(30),
    IN p_password VARCHAR(255),
    IN p_phone VARCHAR(20),
    OUT p_message VARCHAR(50)
)
BEGIN
    DECLARE user_count INT;
    DECLARE phone_count INT;
    DECLARE id_count INT;

    -- 아이디 또는 전화번호가 이미 존재하는지 확인
    SELECT COUNT(*) INTO user_count FROM user WHERE user_name = p_username;
    SELECT COUNT(*) INTO phone_count FROM user WHERE phone = p_phone;
    SELECT COUNT(*) INTO id_count FROM user WHERE user_id = p_userid;

    IF id_count > 0 OR (phone_count > 0 AND user_count > 0) THEN
        SET p_message = '존재하는 계정이 있습니다.';
    ELSE
        -- 신규 회원 등록
        -- INSERT INTO Members (username, phone) VALUES (p_username, p_phone);
        SET p_message = '회원가입 성공';
    END IF;
END //

DELIMITER ;

DROP PROCEDURE RegisterMember;

SET @p_massage = '';
CALL RegisterMember('양원준', 'dnjswns', '123456', '01045225222', @p_massage);
SELECT @p_massage;