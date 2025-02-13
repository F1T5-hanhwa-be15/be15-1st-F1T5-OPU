-- 계정 복구
-- restoreuser

DELIMITER //

CREATE PROCEDURE RestoreUser(
	IN p_usercode INT,
	OUT p_message VARCHAR(50)
)
BEGIN 
	UPDATE user
		SET is_delete = 'N'
	 WHERE user_code = p_usercode;
	UPDATE user
		SET delete_date = NULL
	 WHERE user_code = p_usercode;
	 
		SET p_message = '복구완료';
END //

DELIMITER ;

-- DROP PROCEDURE resotruser;

-- RestoreUser(회원코드, 출력)
CALL RestoreUser(9,@message);
SELECT @message;

SELECT user_code, nickname, is_delete, delete_date
FROM user
WHERE user_code = 9;