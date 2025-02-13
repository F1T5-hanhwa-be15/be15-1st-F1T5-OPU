-- 사용자 회원 탈퇴
-- 계정 탈퇴 요청

DELIMITER //

CREATE PROCEDURE RequestDelete(
	IN p_usercode INT,
	OUT p_message VARCHAR(50)
)
BEGIN 
	UPDATE user
		SET is_delete = 'Y'
	 WHERE user_code = p_usercode;
	UPDATE user
		SET delete_date = NOW()
	 WHERE user_code = p_usercode;
	 
		SET p_message = '변경완료';
END //

DELIMITER ;

-- DROP PROCEDURE userdelete;

-- requestDelete(회원코드, 출력)
CALL requestdelete(9,@message);
SELECT @message;

SELECT user_code, nickname, is_delete, delete_date
FROM user
WHERE user_code = 9;