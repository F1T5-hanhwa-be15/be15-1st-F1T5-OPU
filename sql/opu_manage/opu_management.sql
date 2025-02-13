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

