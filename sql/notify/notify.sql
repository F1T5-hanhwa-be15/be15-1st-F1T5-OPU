-- 게시글 신고
INSERT INTO notify
VALUES
(NULL, '후기글인데 자유게시판에 올라와있어요!', NULL, 3, 7, NULL); -- 게시글 신고

SELECT * FROM notify WHERE comment_id IS NULL;



-- 댓글 신고
INSERT INTO notify
VALUES
(NULL, '욕설 신고합니다.' , NULL, 10, 3, 2);  -- 댓글 신고

SELECT * FROM notify WHERE comment_id IS NOT NULL;