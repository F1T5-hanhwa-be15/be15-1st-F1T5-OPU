-- opu 검색
SELECT opu_content
FROM opu_script
WHERE opu_content LIKE '%하기%';

-- opu 목록 조회
SELECT os.opu_content
FROM opu_script os
JOIN opu_list ol ON  os.opu_id = ol.opu_id 
JOIN opu_add oa on ol.opu_list_id = oa.opu_list_id
WHERE user_code = 3;

-- opu 수정
UPDATE opu_add
	SET opu_content = '뒹굴뒹굴 구르기'
 WHERE opu_add_id = 102;
 
-- opu삭제
DELETE FROM opu_add
WHERE user_code = 2
AND opu_list_id IS NULL; 
	
-- 랜덤뽑기 opu 추가 
DELIMITER //

CREATE PROCEDURE random_opu_add(
	IN user_code INT 
)
BEGIN
		DECLARE random_id INT;
		
		
    	SELECT opu_list_id INTO random_id
    	FROM opu_list
    	ORDER BY RAND()
    	LIMIT 1;

    	INSERT INTO opu_add
		VALUES (NULL, user_code , CURRENT_TIMESTAMP(), 'Y', NULL, random_id, 'Y', 'N');
END //

DELIMITER ;

CALL random_opu_add(10);

-- opu 찜삭제
DELETE FROM opu_like
WHERE user_code = 6 AND opu_list_id = 15;

-- opu 찜추가
INSERT INTO opu_like
VALUES
(NULL, 10, 17);
