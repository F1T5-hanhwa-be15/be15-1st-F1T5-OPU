-- 비밀번호 찾기
DELIMITER //

CREATE PROCEDURE FindAndChangePass(
    IN p_name VARCHAR(50),
    IN p_phone VARCHAR(20),
    IN p_userid VARCHAR(50),
    OUT p_message VARCHAR(50)
)
BEGIN
    DECLARE user_count INT;

    -- ID, 이름, 전화번호가 일치하는 사용자 조회
    SELECT COUNT(*) INTO user_count
    FROM user
    WHERE user_id = p_userid AND user_name = p_name AND phone = p_phone;

    -- 결과에 따라 메시지 반환
    IF user_count > 0 THEN
        SET p_message = '비밀번호 변경이 가능합니다.';
    ELSE
        SET p_message = '회원정보가 일치하지 않습니다.';
    END IF;
END //

DELIMITER ;

-- DROP PROCEDURE FindAndChangePass;

CALL FindAndChangePass('차명호', '01011111115', 'audgh', @message);
SELECT @message '비밀번호 찾기';




















-- 비밀번호 변경
DELIMITER //

CREATE PROCEDURE ChangePass(
	 IN userid VARCHAR(50),
    IN pass1 VARCHAR(50),
    IN pass2 VARCHAR(50),
    OUT p_message VARCHAR(50)
)
BEGIN
    IF pass1 <> pass2 THEN
        SET p_message = '비밀번호가 일치하지 않습니다.';
    ELSE
    	  UPDATE user
			  set password = pass1
			 WHERE user_id = userid;
			 
        SET p_message = '비밀번호 변경 완료.';
    END IF;
END //

DELIMITER ;

-- changepass(아이디, 변경할 비밀번호, 변경할 비밀번호 재입력, 출력)
CALL changePass('audgh', 'audgh1234', 'audgh1234', @message);
SELECT @message;
SELECT 
		 PASSWORD 
  FROM user
 WHERE user_name = '차명호';
