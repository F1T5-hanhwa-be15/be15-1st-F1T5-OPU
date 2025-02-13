-- 좋아요
-- TEST-059 - 게시글 좋아요 수 조회
				-- 게시글 (게시글 아이디)
				-- 게시글좋아요(count)

SELECT
		  COALESCE(COUNT(*), 0) AS '게시글 좋아요 수'
  FROM post_like
 WHERE post_id = 5;
  


-- TEST-060 - 댓글 좋아요 수 조회
				-- 댓글 (댓글 아이디)
				-- 댓글좋아요(count)

SELECT
		  COALESCE(COUNT(*), 0) AS '댓글 좋아요 수'
  FROM comment_like
 WHERE comment_id = 4;



-- TEST-061 - 게시글 좋아요 표시
				-- 사용자(사용자코드)
				-- 게시글 (게시글 아이디)

INSERT INTO post_like (user_code, post_id)
VALUES 
	(8, 16)
ON DUPLICATE KEY UPDATE user_code = VALUES(user_code);

SELECT * FROM post_like WHERE user_code = 8;



-- TEST-06 - 댓글 좋아요 표시
				-- 사용자(사용자코드)
				-- 댓글 (댓글 아이디)

INSERT INTO comment_like (user_code, comment_id)
VALUES 
	(8, 4)
ON DUPLICATE KEY UPDATE user_code = VALUES(user_code);

SELECT * FROM comment_like WHERE user_code = 8;



-- TEST-063 - 게시글 좋아요 취소
				-- 사용자(사용자코드)
				-- 게시글 (게시글 아이디)

DELETE 
  FROM post_like
 WHERE user_code = 8					-- 임의:사용자 코드
 	AND post_id = 16			-- 임의:댓글  코드
 LIMIT 1;

SELECT * FROM post_like WHERE user_code = 8;



-- TEST-064 - 댓글 좋아요 취소
				-- 사용자(사용자코드)
				-- 댓글 (댓글 아이디)

DELETE 
  FROM comment_like
 WHERE user_code = 8					-- 임의:사용자 코드
 	AND comment_id = 4			-- 임의: 댓글  코드
 LIMIT 1;
 
 SELECT * FROM comment_like WHERE user_code = 8;

