CREATE TABLE `opu_list` (
    `opu_list_id` INT NOT NULL AUTO_INCREMENT COMMENT 'OPU 목록 ID',
    `time_id` INT NOT NULL COMMENT '시간 ID',
    `opu_id` INT NOT NULL COMMENT 'OPU ID',
    PRIMARY KEY (`opu_list_id`)
);

CREATE TABLE `answer` (
    `answer_id` INT NOT NULL AUTO_INCREMENT COMMENT '성향 답변 ID',
    `question_id` INT NOT NULL COMMENT '성향 질문 ID',
    `category_id` INT NOT NULL COMMENT '카테고리 ID',
    PRIMARY KEY (`answer_id`)
);

CREATE TABLE `comment_like` (
    `post_id` INT NOT NULL COMMENT '게시글 ID',
    `user_code` INT NOT NULL COMMENT '사용자 코드',
    PRIMARY KEY (`post_id`, `user_code`)
);

CREATE TABLE `opu_category` (
    `category_id` INT NOT NULL AUTO_INCREMENT COMMENT '카테고리 ID',
    `category_name` VARCHAR(5) NOT NULL COMMENT '음식, 건강, 지식, 문화, 사용자 지정',
    PRIMARY KEY (`category_id`)
);

CREATE TABLE `post_category` (
    `category_id` INT NOT NULL AUTO_INCREMENT COMMENT '게시글 카테고리 ID',
    `category_name` CHAR(30) NULL COMMENT '자유게시판, 후기, 공지사항',
    PRIMARY KEY (`category_id`)
);

CREATE TABLE `opu_add` (
    `opu_add_id` INT NOT NULL AUTO_INCREMENT COMMENT 'OPU 추가 ID',
    `opu_content` VARCHAR(30) NULL COMMENT 'OOO 하기',
    `opu_add_date` DATE NOT NULL DEFAULT CURDATE() COMMENT '날짜',
    `is_check` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '체크 여부',
    `user_code` INT NOT NULL COMMENT '사용자 코드',
    `opu_id` INT NOT NULL COMMENT 'OPU 목록 ID',
    PRIMARY KEY (`opu_add_id`)
);

CREATE TABLE `blacklist` (
    `blacklist_id` INT NOT NULL AUTO_INCREMENT COMMENT '블랙리스트 ID',
    `user_name` VARCHAR(255) NOT NULL COMMENT '사용자 이름',
    `phone` VARCHAR(11) NOT NULL COMMENT '전화번호',
    `blacklist_reason` VARCHAR(255) NOT NULL COMMENT '등록 이유',
    `blacklist_date` DATE NOT NULL COMMENT '등록 날짜',
    PRIMARY KEY (`blacklist_id`)
);

CREATE TABLE `post_like` (
    `comment_id` INT NOT NULL COMMENT '댓글 ID',
    `user_code` INT NOT NULL COMMENT '사용자 코드',
    PRIMARY KEY (`comment_id`, `user_code`)
);

CREATE TABLE `opu` (
    `opu_id` INT NOT NULL AUTO_INCREMENT COMMENT 'OPU ID',
    `opu_name` VARCHAR(30) NOT NULL COMMENT '물마시기, 산책하기 등',
    `category_id` INT NOT NULL COMMENT 'OPU 카테고리 ID',
    PRIMARY KEY (`opu_id`)
);

CREATE TABLE `post_img` (
    `img_id` INT NOT NULL AUTO_INCREMENT COMMENT '게시글 사진 ID',
    `post_id` INT NOT NULL COMMENT '게시글 ID',
    `img_url` TEXT NOT NULL COMMENT '사진 URL',
    PRIMARY KEY (`img_id`)
);

CREATE TABLE `post` (
    `post_id` INT NOT NULL AUTO_INCREMENT COMMENT '게시글 ID',
    `post_title` VARCHAR(50) NOT NULL COMMENT '게시글 제목',
    `post_comment` TEXT NOT NULL COMMENT '게시글 내용',
    `post_img_url` TEXT NULL COMMENT '게시글 사진',
    `create_at` TIMESTAMP NOT NULL COMMENT '게시글 생성 시간',
    `update_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT '마지막 수정 시간',
    `category_id` CHAR(30) NOT NULL COMMENT '게시글 카테고리 ID',
    `user_code` VARCHAR(30) NOT NULL COMMENT '사용자 코드',
    PRIMARY KEY (`post_id`)
);

CREATE TABLE `comment` (
    `comment_id` INT NOT NULL AUTO_INCREMENT COMMENT '댓글 ID',
    `comment_content` TEXT NOT NULL COMMENT '댓글 내용',
    `create_at` DATETIME NOT NULL COMMENT '댓글 생성 시간',
    `update_at` DATETIME NULL COMMENT '마지막 수정 시간',
    `post_id` INT NOT NULL COMMENT '게시글 ID',
    `reply_comment_id` INT NOT NULL COMMENT '상위 댓글 ID',
    `user_code` INT NOT NULL COMMENT '작성자 - 사용자 코드',
    PRIMARY KEY (`comment_id`)
);

CREATE TABLE `question` (
    `question_id` INT NOT NULL AUTO_INCREMENT COMMENT '성향 질문 ID',
    `question_content` VARCHAR(60) NULL COMMENT '쉬는 날에 뭐하시나요?',
    PRIMARY KEY (`question_id`)
);

CREATE TABLE `opu_test_result` (
    `user_code` INT NOT NULL COMMENT '사용자 코드',
    `health_score` INT NULL DEFAULT 0 COMMENT '건강 점수',
    `food_score` INT NULL DEFAULT 0 COMMENT '음식 점수',
    `culture_score` INT NULL DEFAULT 0 COMMENT '문화 점수',
    `knowledge_score` INT NULL DEFAULT 0 COMMENT '지식 점수',
    PRIMARY KEY (`user_code`)
);

CREATE TABLE `notify` (
    `notify_id` INT NOT NULL AUTO_INCREMENT COMMENT '신고 ID',
    `notify_reason` VARCHAR(50) NOT NULL COMMENT '신고된 이유',
    `notify_date` DATE NOT NULL COMMENT '신고된 날짜',
    `post_id` INT NULL COMMENT '신고된 게시글 ID',
    `comment_id` INT NULL COMMENT '신고된 댓글 ID',
    PRIMARY KEY (`notify_id`)
);

CREATE TABLE `user` (
    `user_code` INT NOT NULL AUTO_INCREMENT COMMENT '사용자 코드',
    `user_id` VARCHAR(30) NOT NULL COMMENT '사용자 아이디',
    `user_name` VARCHAR(255) NOT NULL COMMENT '사용자 이름',
    `password` VARCHAR(255) NOT NULL COMMENT '사용자 비밀번호',
    `nickname` VARCHAR(255) NOT NULL COMMENT '사용자 닉네임',
    `phone` VARCHAR(11) NOT NULL COMMENT '사용자 전화번호',
    `birth` DATE NOT NULL COMMENT '사용자 생년월일',
    `profile_img` TEXT NULL COMMENT '사용자 프로필 사진',
    `introduce` VARCHAR(255) NULL COMMENT '사용자 한 줄 소개',
    `user_date` TIMESTAMP NOT NULL COMMENT '계정 생성 날짜',
    `is_manager` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '사용자/관리자 구분',
    `notification` BOOLEAN NOT NULL DEFAULT TRUE COMMENT '알림 설정 여부',
    `is_public` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '프로필 공개 여부',
    `is_delete` BOOLEAN NOT NULL COMMENT '계정 탈퇴 여부',
    `delete_date` DATE NULL COMMENT '삭제 신청일',
    `level_id` INT NOT NULL COMMENT '사용자 등급 ID',
    PRIMARY KEY (`user_code`)
);

CREATE TABLE `opu_time` (
    `time_id` INT NOT NULL AUTO_INCREMENT COMMENT '시간 ID',
    `time_content` INT NOT NULL COMMENT '5, 10, 30, 60',
    PRIMARY KEY (`time_id`)
);

CREATE TABLE `level` (
    `level_id` INT NOT NULL AUTO_INCREMENT COMMENT '등급 ID',
    `level_title` VARCHAR(15) NOT NULL COMMENT '등급 이름',
    PRIMARY KEY (`level_id`)
);

CREATE TABLE `user_follow` (
    `follow_code` INT NOT NULL AUTO_INCREMENT COMMENT '팔로우 코드',
    `follower_code` INT NOT NULL COMMENT '팔로워 사용자 코드',
    `following_code` INT NOT NULL COMMENT '팔로잉 사용자 코드',
    PRIMARY KEY (`follow_code`)
);

-- 사용자 (user) 관련 외래키
ALTER TABLE `user`
ADD CONSTRAINT `FK_user_level` FOREIGN KEY (`level_id`) REFERENCES `level` (`level_id`);

-- 게시글 (post) 관련 외래키
ALTER TABLE `post`
ADD CONSTRAINT `FK_post_user` FOREIGN KEY (`user_code`) REFERENCES `user` (`user_code`),
ADD CONSTRAINT `FK_post_category` FOREIGN KEY (`category_id`) REFERENCES `post_category` (`category_id`);

-- 댓글 (comment) 관련 외래키
ALTER TABLE `comment`
ADD CONSTRAINT `FK_comment_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`),
ADD CONSTRAINT `FK_comment_user` FOREIGN KEY (`user_code`) REFERENCES `user` (`user_code`),
ADD CONSTRAINT `FK_comment_reply` FOREIGN KEY (`reply_comment_id`) REFERENCES `comment` (`comment_id`);

-- 게시글 좋아요 (post_like) 관련 외래키
ALTER TABLE `post_like`
ADD CONSTRAINT `FK_post_like_user` FOREIGN KEY (`user_code`) REFERENCES `user` (`user_code`),
ADD CONSTRAINT `FK_post_like_comment` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`comment_id`);

-- 댓글 좋아요 (comment_like) 관련 외래키
ALTER TABLE `comment_like`
ADD CONSTRAINT `FK_comment_like_user` FOREIGN KEY (`user_code`) REFERENCES `user` (`user_code`),
ADD CONSTRAINT `FK_comment_like_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

-- 신고 (notify) 관련 외래키
ALTER TABLE `notify`
ADD CONSTRAINT `FK_notify_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`),
ADD CONSTRAINT `FK_notify_comment` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`comment_id`);

-- 블랙리스트 (blacklist) 관련 외래키
ALTER TABLE `blacklist`
ADD CONSTRAINT `FK_blacklist_user` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`);

-- 사용자 팔로우 (user_follow) 관련 외래키
ALTER TABLE `user_follow`
ADD CONSTRAINT `FK_follow_follower` FOREIGN KEY (`follower_code`) REFERENCES `user` (`user_code`),
ADD CONSTRAINT `FK_follow_following` FOREIGN KEY (`following_code`) REFERENCES `user` (`user_code`);

-- OPU 추가 (opu_add) 관련 외래키
ALTER TABLE `opu_add`
ADD CONSTRAINT `FK_opu_add_user` FOREIGN KEY (`user_code`) REFERENCES `user` (`user_code`),
ADD CONSTRAINT `FK_opu_add_opu` FOREIGN KEY (`opu_id`) REFERENCES `opu` (`opu_id`);

-- OPU 카테고리 (opu_category) 관련 외래키
ALTER TABLE `opu`
ADD CONSTRAINT `FK_opu_category` FOREIGN KEY (`category_id`) REFERENCES `opu_category` (`category_id`);

-- OPU 목록 (opu_list) 관련 외래키
ALTER TABLE `opu_list`
ADD CONSTRAINT `FK_opu_list_time` FOREIGN KEY (`time_id`) REFERENCES `opu_time` (`time_id`),
ADD CONSTRAINT `FK_opu_list_opu` FOREIGN KEY (`opu_id`) REFERENCES `opu` (`opu_id`);

-- 성향 질문 (question) 관련 외래키
ALTER TABLE `answer`
ADD CONSTRAINT `FK_answer_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`),
ADD CONSTRAINT `FK_answer_category` FOREIGN KEY (`category_id`) REFERENCES `opu_category` (`category_id`);

-- 성향 결과 (opu_test_result) 관련 외래키
ALTER TABLE `opu_test_result`
ADD CONSTRAINT `FK_opu_test_user` FOREIGN KEY (`user_code`) REFERENCES `user` (`user_code`);

-- 게시글 이미지 (post_img) 관련 외래키
ALTER TABLE `post_img`
ADD CONSTRAINT `FK_post_img_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);
