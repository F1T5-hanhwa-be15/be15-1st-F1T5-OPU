-- 후기 게시판

-- 1. 게시판 목록 조회
SELECT 
    p.post_id AS 게시글ID,
    p.post_title AS 제목,
    u.nickname AS 닉네임,
    COALESCE(p.update_at, p.create_at) AS 작성시간
FROM post p
JOIN post_category c ON p.category_id = c.category_id
JOIN user u ON p.user_code = u.user_code
WHERE c.category_name = '후기'
	AND p.is_delete = 'N'
ORDER BY 작성시간 DESC;

-- 2. 팔로잉 우선 조회
SELECT 
    p.post_id AS 게시글ID,
    p.post_title AS 제목,
    u.nickname AS 닉네임,
    COALESCE(p.update_at, p.create_at) AS 작성시간,
    CASE 
        WHEN f.following_code IS NOT NULL THEN 1   -- 팔로잉한 사용자의 게시글이면 우선순위 1
        ELSE 2
    END AS priority
FROM post p
JOIN post_category c ON p.category_id = c.category_id
JOIN user u ON p.user_code = u.user_code
LEFT JOIN follow f ON p.user_code = f.following_code 
    AND f.follower_code = 1  -- 사용자 코드 테스트용
WHERE c.category_name = '후기'
AND p.is_delete = 'N'
ORDER BY priority, COALESCE(p.update_at, p.create_at) DESC;

-- 3. 게시글 검색
SELECT 
    p.post_id AS 게시글ID,
    p.post_title AS 제목,
    u.nickname AS 닉네임,
    COALESCE(p.update_at, p.create_at) AS 작성시간
FROM post p
JOIN user u ON p.user_code = u.user_code
JOIN post_category c ON p.category_id = c.category_id
WHERE c.category_name = '후기'
	 AND p.is_delete = 'N'
    AND p.post_title LIKE CONCAT('%', '갓생', '%')  -- 검색 키워드
ORDER BY COALESCE(p.update_at, p.create_at) DESC;

-- 4. 게시글 상세 조회 

SELECT 
    p.post_id AS 게시글ID, 
    u.nickname AS 닉네임, 
    p.post_title AS 제목,
    p.post_content AS 내용, 
    i.img_url AS 사진, 
    COALESCE(p.update_at, p.create_at) AS 작성시간,
    os.opu_content AS OPU내용
FROM post p 
JOIN user u ON p.user_code = u.user_code
LEFT JOIN opu_add oa ON p.opu_add_id = oa.opu_add_id
LEFT JOIN opu_list ol ON oa.opu_list_id = ol.opu_list_id  
LEFT JOIN opu_script os ON ol.opu_id = os.opu_id
LEFT JOIN post_img i ON p.post_id = i.post_id
WHERE p.post_id = 4  
  AND p.is_delete = 'Y';

-- 5. 게시글 추가  
INSERT INTO post (post_title, post_content, user_code, category_id)
VALUES ('[후기] 하체운동 주3일한 후기', '-5kg 감량 성공', 15, 3);

-- 6. 게시글 수정
UPDATE post
SET post_title = '[OPU 성공 후기] 집밥 도선생'
WHERE post_id = 365;  

-- 7. 게시글 삭제
UPDATE post 
SET is_delete = 'Y'
WHERE post_id = 365;