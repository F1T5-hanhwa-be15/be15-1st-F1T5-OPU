-- 아이디 찾기
DELIMITER //

CREATE PROCEDURE FindId(
    IN p_name VARCHAR(50),
    IN p_phone VARCHAR(20),
    OUT p_userid VARCHAR(50)
)
BEGIN
    -- 이름과 전화번호가 일치하는 사용자 조회
    SELECT user_id INTO p_userid
    FROM user
    WHERE user_name = p_name AND phone = p_phone
    LIMIT 1;
END //

DELIMITER ;

CALL findid('차명호', '01011111115', @id);
SELECT @id 아이디;