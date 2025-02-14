
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