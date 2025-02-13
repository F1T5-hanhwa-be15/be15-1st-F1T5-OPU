-- 아이디 찾기
DELIMITER //

CREATE PROCEDURE FindId(
    IN p_name VARCHAR(50),
    IN p_phone VARCHAR(20),
    OUT p_userid VARCHAR(50)
)
BEGIN
    -- 아이디 조회 (존재하지 않으면 NULL 반환)
    SELECT COALESCE(
        (SELECT user_id FROM user WHERE user_name = p_name AND phone = p_phone LIMIT 1), 
        '일치하는 아이디 없음'
    ) INTO p_userid;
END //

DELIMITER ;

-- DROP PROCEDURE FindId;

CALL findid('차명호', '01011111115', @id);
SELECT @id 아이디;



