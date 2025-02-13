-- 공지사항

-- 1. 게시글 목록 조회
SELECT 
    p.post_id AS 게시글ID,
    p.post_title AS 제목,
    u.nickname AS 닉네임,
    COALESCE(p.update_at, p.create_at) AS 작성시간
FROM post p
JOIN post_category c ON p.category_id = c.category_id
JOIN user u ON p.user_code = u.user_code
WHERE c.category_name = '공지사항'
AND p.is_delete = 'N'
ORDER BY 작성시간 DESC;

-- 2. 게시글 검색
SELECT 
    p.post_id AS 게시글ID,
    p.post_title AS 제목,
    u.nickname AS 닉네임,
    COALESCE(p.update_at, p.create_at) AS 작성시간
FROM post p
JOIN user u ON p.user_code = u.user_code
JOIN post_category c ON p.category_id = c.category_id
	WHERE c.category_name = '공지사항'
	AND p.is_delete = 'N'
    AND p.post_title LIKE CONCAT('%', '규칙', '%'); — 검색 키워드
    ORDER BY COALESCE(p.update_at, p.create_at) DESC;

-- 3. 게시글 상세 조회
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
	 AND p.is_delete = 'N';  -- 조회할 게시글 ID

-- 5. 게시글 추가
DELIMITER //

CREATE TRIGGER trg_before_post_insert
BEFORE INSERT ON post
FOR EACH ROW
BEGIN
    DECLARE user_manager_status CHAR(1);

    -- user 테이블에서 is_manager 상태 조회
    SELECT is_manager 
    INTO user_manager_status
    FROM user 
    WHERE user_code = NEW.user_code;

    -- is_manager가 'Y'가 아니면 삽입 중단
    IF user_manager_status IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '존재하지 않는 사용자입니다.';
    ELSEIF user_manager_status != 'Y' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '관리자만 게시글을 등록할 수 있습니다.';
    END IF;
END;
//

DELIMITER ;


INSERT INTO post (post_title, post_content, user_code, category_id)
VALUES ('[공지] 후기 게시판 규칙', '1. 직접 수행한 OPU여야 합니다. 2. 과시하는 듯한 태도는 버려주세요.', 2, 2);

-- 6. 게시글 수정
update post
SET post_content = '1. 직접 수행한 OPU여야 합니다. 2. 과시해주세요.'
WHERE post_id = 363;

--  7. 게시글 삭제
UPDATE post 
SET is_delete = 'Y'
WHERE post_id = 363;