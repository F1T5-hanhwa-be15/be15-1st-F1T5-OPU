-- 1. opu 조회
-- 1-1. opu 목록 조회
SELECT os.opu_content, t.time_content
  FROM opu_list ol
  JOIN opu_script os ON ol.opu_id = os.opu_id
  JOIN time t ON t.time_id = ol.time_id;

-- 1-2) 데일리 opu 조회
SELECT o.date, o.is_check, o.is_random, os.opu_content, t.time_content
  FROM opu_add o
  JOIN opu_list ol ON ol.opu_list_id = o.opu_list_id
  JOIN opu_script os ON os.opu_id = ol.opu_id
  JOIN time t ON ol.time_id = t.time_id
 WHERE o.user_code = 6
   AND o.is_delete = 'N'
   AND o.date = CURRENT_DATE();

-- 2. 데일리 opu 체크표시
SELECT *
  FROM opu_add
 WHERE opu_add_id = 420;

UPDATE opu_add o
   SET o.is_check = 'Y'
 WHERE o.opu_add_id = 420;
 
SELECT *
  FROM opu_add
 WHERE opu_add_id = 420;

-- 3. opu 추가
-- 3-1) opu 추가 - 디폴트일 때

DELIMITER //

CREATE or replace PROCEDURE addOPUFromList(
	IN id INTEGER,
	IN input_array JSON,
	IN end_date DATE,
	IN opu_id INTEGER
)
BEGIN 
	DECLARE cur_date DATE DEFAULT CURDATE();
	DECLARE weekday_idx INT;
	DECLARE repeat_flag INT;
	
	WHILE DATEDIFF(end_date, cur_date) >= 0 DO
		SET weekday_idx = WEEKDAY(cur_date);
		
		SET repeat_flag = JSON_UNQUOTE(JSON_EXTRACT(input_array, CONCAT('$[', weekday_idx, ']')));
		
		IF repeat_flag = 1 THEN
			INSERT INTO opu_add(user_code, date, opu_list_id)
			VALUES (id, cur_date, opu_id);
		END IF;
		
		SET cur_date = DATE_ADD(cur_date, INTERVAL 1 DAY);
	END WHILE;
END //

DELIMITER ;

CALL addOPUFromList(3, '[1,1,1,1,0,0,0]', '2025-03-01', 10);

SELECT *
FROM opu_add
WHERE user_code = 2
ORDER BY opu_add_id DESC
LIMIT 10;

-- 근데 같은 날에 같은 것을 집어넣는다면 그것은 안됨 -> 트리거 추가해야함!!

-- 3-2) opu 추가 - 사용자 정의일 때
-- 사용자의 설정에 따라 
-- OPU 목록에서 반복 횟수와 종료 날짜만큼 반복해서 OPU를 추가한다.
-- INPUT : 반복 횟수, 종료 날짜.(현재 날짜는 이미 잇슴.)
-- DEFAULT : 체크여부 n 랜덤여부 n 삭제여부 n 
SELECT WEEKDAY(NOW());

INSERT INTO user
VALUES
	(NULL, 'coddl', '윤영', '1234', '챙챙이', '01011111101', '2000-12-19', NULL, NULL, CURRENT_TIMESTAMP, 'Y', 'N', 'N', 'N', NULL, 1);

SELECT * FROM user;

-- 3-2) 랜덤뽑기 opu 추가