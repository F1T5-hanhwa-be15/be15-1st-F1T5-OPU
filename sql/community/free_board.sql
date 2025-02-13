-- 자유게시판

-- 1. 게시글 목록 조회

SELECT 
    p.post_id AS 게시글ID,
    p.post_title AS 제목,
    u.nickname AS 닉네임,
    COALESCE(p.update_at, p.create_at) AS 작성시간
FROM post p
JOIN post_category c ON p.category_id = c.category_id
JOIN user u ON p.user_code = u.user_code
WHERE c.category_name = '자유게시판'
	AND p.is_delete = 'Y'
ORDER BY COALESCE(p.update_at, p.create_at) DESC;

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
    AND f.follower_code = 5  -- 사용자 코드 테스트용
WHERE c.category_name = '자유게시판'
	AND p.is_delete = 'Y'
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
WHERE c.category_name = '자유게시판'
	 AND p.is_delete = 'Y'
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
    COALESCE(pl.좋아요수, 0) AS 좋아요수
FROM post p 
JOIN user u ON p.user_code = u.user_code
LEFT JOIN post_img i ON p.post_id = i.post_id
LEFT JOIN (
    SELECT 
        post_id, 
        COUNT(*) AS 좋아요수
    FROM post_like
    GROUP BY post_id
) pl ON p.post_id = pl.post_id
WHERE p.post_id = 3
	 AND p.is_delete = 'Y';  -- 조회할 게시글 ID
	 
-- 5. 게시글 추가
INSERT INTO post (post_title, post_content, user_code, category_id)
VALUES ('하마도 아니고 물 어케 2리터 마시냐', '저는 하마입니다', 11, 1);

-- 6. 게시글 수정
update post
SET post_title = '하루에 물 2리터는 하마 아니냐?'
WHERE post_id = 362;

— 7. 게시글 삭제
UPDATE post 
SET is_delete = 'Y'
WHERE post_id = 362;