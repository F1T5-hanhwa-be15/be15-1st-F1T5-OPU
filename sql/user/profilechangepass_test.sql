DELIMITER //

CREATE PROCEDURE UpdatePassword(
    IN p_userid VARCHAR(50),
    IN p_old_password VARCHAR(50),
    IN p_new_password1 VARCHAR(50),
    IN p_new_password2 VARCHAR(50),
    OUT p_message VARCHAR(50)
)
BEGIN
    DECLARE user_count INT;

    -- 아이디와 기존 비밀번호가 일치하는 사용자 확인
    SELECT COUNT(*) INTO user_count 
    FROM user
    WHERE user_id = p_userid 
    AND password = p_old_password;

    -- 기존 비밀번호가 일치하지 않으면 변경 불가
    IF user_count = 0 THEN
        SET p_message = '현재 비밀번호가 일치하지 않습니다.';
    ELSEIF p_new_password1 <> p_new_password2 THEN
        SET p_message = '새 비밀번호가 서로 일치하지 않습니다.';
    ELSE
        -- 비밀번호 업데이트
        UPDATE `user`
        SET password = p_new_password1
        WHERE user_id = p_userid;
        
        SET p_message = '비밀번호 변경 완료.';
    END IF;
END //

DELIMITER ;

-- UpdatePassword(아이디, 현재비밀번호, 변경할 비밀번호, 변경할 비밀번호 재입력, 출력)
CALL UpdatePassword('audgh', 'audgh1211', 'audgh1217', 'audgh1217', @message);
SELECT @message;