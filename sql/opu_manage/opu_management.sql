-- 1. opu 조회
-- 1-1) opu 추가 목록 조회
SELECT o.date, o.user_code, o.is_check, os.opu_content
  FROM opu_add o
  JOIN opu_list ol ON ol.opu_list_id = o.opu_list_id
  JOIN opu_script os ON os.opu_id = ol.opu_id
 WHERE o.is_delete = 'N'
   AND DATEDIFF(o.date, CURDATE()) >= 0
   AND o.user_code = 3
 ORDER BY o.date;

-- 1-2) 데일리 opu 조회
SELECT o.date, o.is_check, o.is_random, os.opu_content, t.time_content
  FROM opu_add o
  JOIN opu_list ol ON ol.opu_list_id = o.opu_list_id
  JOIN opu_script os ON os.opu_id = ol.opu_id
  JOIN time t ON ol.time_id = t.time_id
 WHERE o.user_code = 6
   AND o.is_delete = 'N'
   AND o.date = CURRENT_DATE();

-- 2. opu 체크표시 - 데일리 OPU 체크표시
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
-- 근데 같은 날에 같은 것을 집어넣는다면 그것은 안됨 -> 중복검사 필요
DELIMITER //

CREATE OR REPLACE PROCEDURE addOPUFromList(
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
        SET repeat_flag = CAST(JSON_UNQUOTE(JSON_EXTRACT(input_array, CONCAT('$[', weekday_idx, ']'))) AS UNSIGNED);
        
        IF repeat_flag = 1 THEN
            -- 중복 검사 후 INSERT (중복이면 스킵)
            IF NOT EXISTS (
                SELECT 1 FROM opu_add o
                WHERE o.user_code = id 
                AND o.date = cur_date 
                AND o.opu_list_id = opu_id
            ) THEN
                INSERT INTO opu_add(user_code, date, opu_list_id)
                VALUES (id, cur_date, opu_id);
            END IF;
        END IF;
        
        SET cur_date = DATE_ADD(cur_date, INTERVAL 1 DAY);
    END WHILE;
END //

DELIMITER ;


CALL addOPUFromList(3, '[1,1,1,1,0,0,0]', '2025-03-01', 10);

SELECT *
FROM opu_add
WHERE user_code = 3
ORDER BY opu_add_id DESC
LIMIT 10;

-- opu 수정
UPDATE opu_add
	SET opu_content = '뒹굴뒹굴 구르기'
 WHERE opu_add_id = 102;

-- opu 찜추가
INSERT INTO opu_like
VALUES
(NULL, 10, 17);

-- opu 찜삭제
DELETE FROM opu_like
WHERE user_code = 6 AND opu_list_id = 15;

-- opu 검색
SELECT opu_content
FROM opu_script
WHERE opu_content LIKE '%하기%';

-- opu 목록 조회
SELECT os.opu_content, t.time_content, oc.opu_category_name
FROM opu_list ol
JOIN opu_script os ON  os.opu_id = ol.opu_id
JOIN time t ON ol.time_id = t.time_id
JOIN opu_category oc ON oc.opu_category_id = os.opu_category_id;
 
-- opu삭제
DELETE FROM opu_add
WHERE user_code = 2
AND opu_list_id IS NULL; 