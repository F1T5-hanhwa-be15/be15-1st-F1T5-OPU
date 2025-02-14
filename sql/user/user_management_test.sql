-- 사용자 관리 : user_management
-- 1. 사용자 신고 기록 조회
SELECT 
    IFNULL(p.post_title, '-') AS '게시글 제목',
    IFNULL(c.comment_content, '-') AS '댓글 내용', 
    u.user_name AS '신고자 이름' ,
    n.notify_reason AS '신고 이유',
    n.notify_date AS '신고 날짜'
FROM notify n
JOIN user u ON n.user_code = u.user_code
LEFT JOIN post p ON n.post_id = p.post_id
LEFT JOIN comment c ON n.comment_id = c.comment_id 
ORDER BY p.post_id, n.comment_id;

-- 2. 사용자 목록 조회
SELECT 
	user_id '아이디',
	user_name '이름',
	nickname '닉네임', 
	phone '핸드폰 번호',
	birth '생일',
	profile_img '프로필 사진',
	introduce '한 줄 소개',
	create_date '계정 생성 날짜',
	is_public '공개/비공개',
	is_delete '계정 삭제 여부',
	delete_date '계정 삭제 날짜',
	level_id '등급'
FROM USER; 

-- 3. 사용자 계정 복구
UPDATE USER 
SET is_delete = 'N'
WHERE user_code = 7;

SELECT nickname '닉네임',is_delete '계정 삭제 여부' FROM user
WHERE user_code = 7;

-- 4. 사용자 계정 삭제 (30일 이후)
UPDATE USER
SET is_delete = 'Y'	
WHERE delete_date IS NOT NULL
AND DATEDIFF(CURRENT_DATE(),delete_date)>30;


-- 5. 블랙리스트
-- 블랙리스트 목록 조회
SELECT b.user_name, b.phone, a.blacklist_reason, a.blacklist_date
FROM blacklist a
JOIN user b ON a.user_code = b.user_code;

-- 블랙리스트에 등록되는 순간 사용자의 탈퇴여부가 y로 활성화되야 함
Delimiter //

CREATE TRIGGER set_user_deleted_on_blacklist
AFTER INSERT ON blacklist
FOR EACH ROW

BEGIN 	
	UPDATE user 
	SET is_delete = 'Y' 
	WHERE user_code = NEW.user_code;
END //

DELIMITER ;

-- 블랙리스트 등록
INSERT 
	INTO blacklist
VALUES (
	NULL,
	'타인의 명예훼손',
	NOW(),
	9
);

	
-- 블랙리스트에서 해제되면 사용자 계정 비활성화(삭제) 해제
DELIMITER //

CREATE TRIGGER unset_user_deleted_on_blacklist
AFTER DELETE ON blacklist
FOR EACH ROW
BEGIN
    UPDATE user 
    SET is_delete = 'N' 
    WHERE user_code = OLD.user_code;
END //

DELIMITER ;

DELETE FROM blacklist 
WHERE user_code = 9;

-- 6. 사용자 활동 관리
-- 사용자 활동 기록 조회 
-- 게시글
SELECT 
		u.nickname '닉네임',
		p.post_title '게시글 제목',
		p.post_content '게시글 내용'
FROM USER u
JOIN post p ON u.user_code = p.user_code
WHERE u.is_manager = 'N'
ORDER BY u.user_code;

-- 댓글
-- 댓글을 단 사람, 댓글 내용, 댓글이 있는 게시글의 아이디와 제목
SELECT 
		u.nickname '닉네임',
		c.comment_content '댓글',
		p.post_id '게시글 번호',
		p.post_title '해당 게시글 제목'
FROM USER u
JOIN comment c ON u.user_code = c.user_code
JOIN post p ON p.post_id = c.post_id
WHERE u.is_manager = 'N'
ORDER BY u.user_code;

-- 사용자 활동 기록 삭제 (게시글, 댓글)
UPDATE comment
SET is_delete = 'Y'
WHERE is_delete = 'N'
AND comment_id =1;

UPDATE post
SET is_delete = 'Y'
WHERE is_delete = 'N'
AND post_id =1;;