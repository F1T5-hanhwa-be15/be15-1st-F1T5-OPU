-- 푸쉬 알림
-- TEST-037 - 푸쉬 알림 설정
				-- 사용자 테이블(푸쉬알림 설정)
SELECT nickname, is_alarm FROM user WHERE user_code = 13;

UPDATE user
   SET is_alarm = 'Y'
 WHERE user_code = 13;



-- TEST-038 - 푸쉬 알림 설정
				-- 사용자 테이블(푸쉬알림 설정)

UPDATE user
   SET is_alarm = 'N'
 WHERE user_code = 13;


-- TEST-37 & TEST-38 - 푸쉬 알림 설정 변경

UPDATE user
SET is_alarm = CASE 
                 WHEN is_alarm = 'Y' THEN 'N' 
                 ELSE 'Y' 
               END
WHERE user_code = 13;


SELECT nickname, is_alarm FROM user WHERE user_code = 13;
