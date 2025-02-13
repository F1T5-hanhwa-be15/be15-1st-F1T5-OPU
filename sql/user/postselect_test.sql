-- 사용자 활동 조회
-- 사용자 게시글 조회 

SELECT 
		 p.post_id,
		 p.post_title 제목,
		 p.create_at 작성시간,
		 u.user_id
  FROM post p
  JOIN user u ON u.user_code = p.user_code
 WHERE u.user_id = 'coddl';