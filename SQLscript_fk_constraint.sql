-- 성향 질문 - 성향 답변 (CASCADE)
ALTER TABLE `answer`
DROP CONSTRAINT answer_FK1;
ALTER TABLE `answer`
 ADD CONSTRAINT `answer_FK1` FOREIGN KEY (`question_id`)
 REFERENCES `question` (`question_id`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- OPU 카테고리 - 성향 답변 (CASCADE)
ALTER TABLE `answer`
DROP CONSTRAINT answer_FK;
ALTER TABLE `answer`
 ADD CONSTRAINT `answer_FK` FOREIGN KEY (`opu_category_id`)
 REFERENCES `opu_category` (`opu_category_id`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 사용자 - 성향 결과 (CASCADE)
ALTER TABLE `result`
DROP CONSTRAINT result_FK;
ALTER TABLE `result`
 ADD CONSTRAINT `result_FK` FOREIGN KEY (`user_code`)
 REFERENCES `user` (`user_code`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 사용자 - 팔로우 (CASCADE)
ALTER TABLE `follow`
DROP CONSTRAINT follow_FK;
DROP CONSTRAINT follow_FK1;
ALTER TABLE `follow`
 ADD CONSTRAINT `follow_FK` FOREIGN KEY (`following_code`)
 REFERENCES `user` (`user_code`)
 ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `follow`
 ADD CONSTRAINT `follow_FK1` FOREIGN KEY (`following_code1`)
 REFERENCES `user` (`user_code`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 댓글 - 댓글 좋아요 (CASCADE)
ALTER TABLE `comment_like`
DROP CONSTRAINT comment_like_FK1;
ALTER TABLE `comment_like`
 ADD CONSTRAINT `comment_like_FK1` FOREIGN KEY (`comment_id`)
 REFERENCES `comment` (`comment_id`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 게시글 - 게시글 좋아요 (CASCADE)
ALTER TABLE `post_like`
DROP CONSTRAINT post_like_FK;
ALTER TABLE `post_like`
 ADD CONSTRAINT `post_like_FK` FOREIGN KEY (`post_id`)
 REFERENCES `post` (`post_id`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 사용자 - 댓글 좋아요 (CASCADE)
ALTER TABLE `comment_like`
DROP CONSTRAINT comment_like_FK;
ALTER TABLE `comment_like`
 ADD CONSTRAINT `comment_like_FK` FOREIGN KEY (`user_code`)
 REFERENCES `user` (`user_code`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 사용자 - 게시글 좋아요 (CASCADE)
ALTER TABLE `post_like`
DROP CONSTRAINT post_like_FK1;
ALTER TABLE `post_like`
 ADD CONSTRAINT `post_like_FK1` FOREIGN KEY (`user_code`)
 REFERENCES `user` (`user_code`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 게시글 - 댓글 (CASCADE)
ALTER TABLE `comment`
DROP CONSTRAINT comment_FK2;
ALTER TABLE `comment`
 ADD CONSTRAINT `comment_FK2` FOREIGN KEY (`post_id`)
 REFERENCES `post` (`post_id`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 게시글 - 게시글 사진 (CASCADE)
ALTER TABLE `post_img`
DROP CONSTRAINT post_img_FK;
ALTER TABLE `post_img`
 ADD CONSTRAINT `post_img_FK` FOREIGN KEY (`post_id`)
 REFERENCES `post` (`post_id`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 게시글 카테고리 - 게시글 (CASCADE)
ALTER TABLE `post`
DROP CONSTRAINT post_FK1;
ALTER TABLE `post`
 ADD CONSTRAINT `post_FK1` FOREIGN KEY (`category_id`)
 REFERENCES `post_category` (`category_id`)
 ON DELETE CASCADE ON UPDATE CASCADE;

-- 등급 - 사용자 (RESTRICT)
ALTER TABLE `user`
DROP CONSTRAINT user_FK;
ALTER TABLE `user`
 ADD CONSTRAINT `user_FK` FOREIGN KEY (`level_id`)
 REFERENCES `level` (`level_id`)
 ON DELETE RESTRICT ON UPDATE RESTRICT;

-- 사용자 - 신고 (NO ACTION)
ALTER TABLE `notify`
DROP CONSTRAINT notify_FK;
ALTER TABLE `notify`
 ADD CONSTRAINT `notify_FK` FOREIGN KEY (`user_code`)
 REFERENCES `user` (`user_code`)
 ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 댓글 - 신고 (NO ACTION)
ALTER TABLE `notify`
DROP CONSTRAINT notify_FK2;
ALTER TABLE `notify`
 ADD CONSTRAINT `notify_FK2` FOREIGN KEY (`comment_id`)
 REFERENCES `comment` (`comment_id`)
 ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 게시글 - 신고 (NO ACTION)
ALTER TABLE `notify`
DROP CONSTRAINT notify_FK1;
ALTER TABLE `notify`
 ADD CONSTRAINT `notify_FK1` FOREIGN KEY (`post_id`)
 REFERENCES `post` (`post_id`)
 ON DELETE NO ACTION ON UPDATE NO ACTION;