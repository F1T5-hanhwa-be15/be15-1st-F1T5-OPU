-- 댓글
-- TEST-053 - 댓글 조회
				-- 게시글(게시글 아이디)
				-- 댓글 (댓글 내용, 댓글, 생성일, 좋아요 수, 답글)

SELECT 
		  c.comment_id AS '댓글 ID'
		, c.comment_content AS '댓글 내용'
		,c.create_at AS '생성일'
		, COALESCE(cl.댓글좋아요수, 0) AS '댓글 좋아요 수',
    		CASE 
        		WHEN EXISTS (
            	SELECT 1 
            	FROM comment r 
            	WHERE r.reply_comment_id = c.comment_id
        		) THEN '더보기'
        		ELSE '-'
    		END AS '답글 존재 여부'
  FROM comment c
  JOIN post p ON p.post_id = c.post_id
  LEFT JOIN (
       SELECT 
        		comment_id, 
        		COUNT(*) AS 댓글좋아요수
    	   FROM comment_like
        GROUP BY comment_id
			) cl ON c.comment_id = cl.comment_id
 WHERE c.post_id = 3  
   AND c.reply_comment_id IS NULL  -- ✅ 상위 댓글만 조회 (대댓글 제외)
   AND c.is_delete = 'N'  -- ✅ 삭제되지 않은 댓글만 조회
 ORDER BY c.create_at ASC;  -- ✅ 오래된 순서대로 정렬



-- TEST-054 - 답글 조회
				-- 상위 댓글 (댓글 아이디)
				-- 댓글 (댓글 내용, 댓글, 생성일, 좋아요 수, 답글)

SELECT 
		  c.reply_comment_id AS '상위댓글 ID'
		, cc.comment_content AS '상위댓글 내용'
		, c.comment_id AS '답글 ID'
		, c.comment_content AS '답글 내용'
		, c.create_at AS '생성일'
		, COALESCE(cl.댓글좋아요수, 0) AS '댓글 좋아요 수'
  FROM comment c
  JOIN comment cc ON c.reply_comment_id = cc.comment_id
  LEFT JOIN (
    	SELECT 
        comment_id, 
        COUNT(*) AS 댓글좋아요수
    	  FROM comment_like
       GROUP BY comment_id
		) cl ON c.comment_id = cl.comment_id
 WHERE c.reply_comment_id = 1  -- ✅ 특정 상위 댓글(예: ID=10)의 대댓글 조회
 ORDER BY c.create_at ASC;  -- ✅ 오래된 순서대로 정렬


-- TEST-055 - 댓글 추가
				-- 게시글(게시글 아이디)
				-- 댓글 댓글 ID
				-- 댓글 (댓글 내용, 댓글, 생성일, 좋아요 수, 답글)

INSERT INTO comment (user_code, comment_content, post_id, reply_comment_id)
VALUES 
    (5, '이 게시글 정말 유용하네요!', 10, NULL);

SELECT * FROM comment ORDER BY comment_id DESC LIMIT 1;



-- TEST-056 - 답글 추가
				-- 상위 댓글 ID
				-- 댓글 (댓글 내용, 댓글, 생성일, 좋아요 수, 답글)

INSERT INTO comment (user_code, comment_content, post_id, reply_comment_id)
VALUES 
    (7, '동의합니다! 좋은 정보네요!', 10, 5);

SELECT 
		  c.reply_comment_id AS '상위댓글 ID'
		, cc.comment_content AS '상위댓글 내용'
		, c.comment_id AS '답글 ID'
		, c.comment_content AS '답글 내용'
		, c.create_at AS '생성일'
		, COALESCE(cl.댓글좋아요수, 0) AS '댓글 좋아요 수'
  FROM comment c
  JOIN comment cc ON c.reply_comment_id = cc.comment_id
  LEFT JOIN (
    	SELECT 
        comment_id, 
        COUNT(*) AS 댓글좋아요수
    	  FROM comment_like
       GROUP BY comment_id
		) cl ON c.comment_id = cl.comment_id
 WHERE c.reply_comment_id = 5  -- ✅ 특정 상위 댓글(예: ID=10)의 대댓글 조회
 ORDER BY c.create_at ASC;  -- ✅ 오래된 순서대로 정렬



-- TEST-057 - 댓글 수정
				-- 댓글 (댓글 ID, 댓글 내용, 댓글, 생성일, 좋아요 수, 답글)

UPDATE comment
   SET comment_content = '동의합니다! 정말 유용한 정보네요!'
 WHERE comment_id = 6;

SELECT * FROM comment WHERE comment_id = 6;



-- TEST-058 - 댓글 삭제
				-- 댓글 (댓글 ID, 댓글 내용, 댓글, 생성일, 좋아요 수, 답글)

UPDATE comment
SET is_delete = 'Y'
WHERE comment_id = 5 OR reply_comment_id = 5;

SELECT comment_id, comment_content, is_delete FROM comment;


