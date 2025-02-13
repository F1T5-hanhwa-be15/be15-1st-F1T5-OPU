-- -----------------------------------------------------------------
-- 외래 키 제약 조건을 무시하여 테이블 삭제
-- -----------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;

-- 재생성을 위해 테이블 모두 삭제
DROP TABLE IF EXISTS `answer`;
DROP TABLE IF EXISTS `blacklist`;
DROP TABLE IF EXISTS `comment`;
DROP TABLE IF EXISTS `comment_like`;
DROP TABLE IF EXISTS `follow`;
DROP TABLE IF EXISTS `level`;
DROP TABLE IF EXISTS `notify`;
DROP TABLE IF EXISTS `opu_add`;
DROP TABLE IF EXISTS `opu_category`;
DROP TABLE IF EXISTS `opu_like`;
DROP TABLE IF EXISTS `opu_list`;
DROP TABLE IF EXISTS `opu_script`;
DROP TABLE IF EXISTS `post`;
DROP TABLE IF EXISTS `post_category`;
DROP TABLE IF EXISTS `post_img`;
DROP TABLE IF EXISTS `post_like`;
DROP TABLE IF EXISTS `question`;
DROP TABLE IF EXISTS `result`;
DROP TABLE IF EXISTS `time`;
DROP TABLE IF EXISTS `user`;

-- 외래 키 제약 조건 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------< CREATE문 시작 >-----------------

-- 등급 테이블
CREATE OR REPLACE TABLE `level` (
    `level_id`    INTEGER NOT NULL AUTO_INCREMENT COMMENT '등급 ID',
    `level_title` VARCHAR(15) NOT NULL COMMENT '등급 이름',
    `level_criteria`    VARCHAR(255) NOT NULL COMMENT '등급기준',
    PRIMARY KEY (`level_id`)
) COMMENT = '등급';

-- 사용자 테이블
CREATE OR REPLACE TABLE `user` (
    `user_code`    INTEGER      NOT NULL AUTO_INCREMENT COMMENT '사용자 코드',
    `user_id`      VARCHAR(30)  NOT NULL COMMENT '아이디',
    `user_name`    VARCHAR(255) NOT NULL COMMENT '이름',
    `password`     VARCHAR(255) NOT NULL COMMENT '비밀번호',
    `nickname`     VARCHAR(255) NOT NULL COMMENT '닉네임',
    `phone`        VARCHAR(11)  NOT NULL COMMENT '전화번호',
    `birth`        DATE         NOT NULL COMMENT '생년월일',
    `profile_img`  TEXT         COMMENT '프로필 사진',
    `introduce`    VARCHAR(255) COMMENT '한 줄 소개',
    `create_date`  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '계정 생성 날짜',
    `is_manager`   CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '관리자 권한 여부',
    `is_alarm`     CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '알림 설정 여부',
    `is_public`    CHAR(1)      DEFAULT 'N' COMMENT '계정 공개 여부',
    `is_delete`    CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '탈퇴 여부',
    `delete_date`  TIMESTAMP    COMMENT '탈퇴 신청 날짜',
    `level_id`     INTEGER      DEFAULT 1 NOT NULL COMMENT '등급 ID',
    PRIMARY KEY (`user_code`),
    UNIQUE ( `user_id`,`phone` ),
    FOREIGN KEY (`level_id`)
        REFERENCES `level` (`level_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) COMMENT = '사용자';

-- OPU 카테고리
CREATE OR REPLACE TABLE `opu_category` (
    `opu_category_id`   INTEGER  NOT NULL AUTO_INCREMENT COMMENT 'OPU 카테고리 ID',
    `opu_category_name` CHAR(5)  NOT NULL COMMENT 'OPU 카테고리 이름',
    PRIMARY KEY (`opu_category_id`)
) COMMENT = 'OPU 카테고리';

-- 성향 질문
CREATE OR REPLACE TABLE `question` (
    `question_id`      INTEGER     NOT NULL AUTO_INCREMENT COMMENT '성향 질문 ID',
    `question_content` VARCHAR(60) NOT NULL COMMENT '질문 내용',
    PRIMARY KEY (`question_id`)
) COMMENT = '성향 질문';

-- 성향 답변
CREATE OR REPLACE TABLE `answer` (
    `answer_id`        INTEGER      NOT NULL AUTO_INCREMENT COMMENT '성향 답변 ID',
    `opu_category_id`  INTEGER      NOT NULL COMMENT 'OPU 카테고리 ID',
    `question_id`      INTEGER      NOT NULL COMMENT '성향 질문 ID',
    `answer_content`   VARCHAR(255) NOT NULL COMMENT '답변 내용',
    PRIMARY KEY (`answer_id`),
    FOREIGN KEY (`opu_category_id`)
        REFERENCES `opu_category` (`opu_category_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`question_id`)
        REFERENCES `question` (`question_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = '성향 답변';

-- 블랙리스트
CREATE OR REPLACE TABLE `blacklist` (
    `blacklist_id`   INTEGER      NOT NULL AUTO_INCREMENT COMMENT '블랙리스트 ID',
    `blacklist_reason`         VARCHAR(255) NOT NULL COMMENT '사유',
    `blacklist_date`  TIMESTAMP    NOT NULL COMMENT '지정 날짜',
    `user_code`    INTEGER NOT NULL COMMENT '사용자코드',
    PRIMARY KEY (`blacklist_id`),
    FOREIGN KEY ( `user_code` )
        REFERENCES `user` (`user_code` )
) COMMENT = '블랙리스트';

-- 성향결과
CREATE OR REPLACE TABLE `result` (
    `user_code`       INTEGER NOT NULL COMMENT '사용자코드',
    `health_score`    INTEGER NOT NULL DEFAULT 0 COMMENT '건강점수',
    `food_score`      INTEGER NOT NULL DEFAULT 0 COMMENT '음식점수',
    `culture_score`   INTEGER NOT NULL DEFAULT 0 COMMENT '문화점수',
    `knowledge_score` INTEGER NOT NULL DEFAULT 0 COMMENT '지식점수',
    PRIMARY KEY (`user_code`),
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = '성향결과';

-- OPU스크립트
CREATE OR REPLACE TABLE `opu_script` (
    `opu_id`          INTEGER      NOT NULL AUTO_INCREMENT COMMENT 'OPUID',
    `opu_content`     VARCHAR(30)  NOT NULL COMMENT 'OPU내용',
    `opu_category_id` INTEGER      NOT NULL COMMENT 'OPU카테고리ID',
    PRIMARY KEY (`opu_id`),
    FOREIGN KEY (`opu_category_id`)
        REFERENCES `opu_category` (`opu_category_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = 'OPU스크립트';

-- 시간ID
CREATE OR REPLACE TABLE `time` (
    `time_id`      INTEGER      NOT NULL AUTO_INCREMENT COMMENT '시간ID',
    `time_content` VARCHAR(20)  NOT NULL COMMENT '시간내용',
    PRIMARY KEY (`time_id`)
) COMMENT = '시간ID';

-- OPU목록
CREATE OR REPLACE TABLE `opu_list` (
    `opu_list_id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'OPU목록ID',
    `opu_id`      INTEGER NOT NULL COMMENT 'OPUID',
    `time_id`     INTEGER NOT NULL COMMENT '시간ID',
    PRIMARY KEY (`opu_list_id`),
    FOREIGN KEY (`time_id`)
        REFERENCES `time` (`time_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`opu_id`)
        REFERENCES `opu_script` (`opu_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = 'OPU목록';

-- OPU추가
CREATE OR REPLACE TABLE `opu_add` (
    `opu_add_id`   INTEGER     NOT NULL AUTO_INCREMENT COMMENT 'OPU 추가 ID',
    `user_code`    INTEGER     NOT NULL COMMENT '사용자코드',
    `date`         DATE        NOT NULL COMMENT '날짜',
    `is_check`     CHAR(1)     NOT NULL DEFAULT 'N' COMMENT '체크여부',
    `opu_content`  VARCHAR(30) COMMENT 'OPU내용',
    `opu_list_id`  INTEGER     COMMENT 'OPU목록ID',
    `is_random`    CHAR(1)     DEFAULT 'N' NOT NULL COMMENT '랜덤여부',
    `is_delete`    CHAR(1)     DEFAULT 'N' NOT NULL COMMENT '삭제여부',
    PRIMARY KEY (`opu_add_id`),
    FOREIGN KEY (`opu_list_id`)
        REFERENCES `opu_list` (`opu_list_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = 'OPU추가';


-- OPU 찜
CREATE OR REPLACE TABLE `opu_like` (
    `opu_like_id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'OPU 찜 ID',
    `user_code`   INTEGER NOT NULL COMMENT '사용자코드',
    `opu_list_id` INTEGER NOT NULL COMMENT 'OPU목록ID',
    PRIMARY KEY (`opu_like_id`),
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`opu_list_id`)
        REFERENCES `opu_list` (`opu_list_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = 'OPU 찜';


-- 게시글 카테고리
CREATE OR REPLACE TABLE `post_category` (
    `category_id`   INTEGER     NOT NULL AUTO_INCREMENT COMMENT '게시글-카테고리 ID',
    `category_name` CHAR(30)    NOT NULL COMMENT '카테고리명',
    PRIMARY KEY (`category_id`)
) COMMENT = '게시글-카테고리';

-- 게시글
CREATE OR REPLACE TABLE `post` (
    `post_id`      INTEGER      NOT NULL AUTO_INCREMENT COMMENT '게시글 ID',
    `post_title`   VARCHAR(255) NOT NULL COMMENT '제목',
    `post_content` TEXT         NOT NULL COMMENT '내용',
    `create_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '생성 시간',
    `update_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT '마지막 수정 시간',
    `user_code`    INTEGER      NOT NULL COMMENT '사용자 코드',
    `category_id`  INTEGER      NOT NULL COMMENT '게시글-카테고리 ID',
    `is_delete`    CHAR(1)      DEFAULT 'N' NOT NULL COMMENT '삭제여부',
    `opu_add_id`   INTEGER      COMMENT 'OPU 추가 ID',
    PRIMARY KEY (`post_id`),
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (`category_id`)
        REFERENCES `post_category` (`category_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`opu_add_id`)
        REFERENCES `opu_add` (`opu_add_id`)
) COMMENT = '게시글';

-- 댓글
CREATE OR REPLACE TABLE `comment` (
    `comment_id`       INTEGER   NOT NULL AUTO_INCREMENT COMMENT '댓글 ID',
    `comment_content`  TEXT      NOT NULL COMMENT '댓글 내용',
    `create_at`        TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '댓글 생성 시간',
    `update_at`        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT '마지막 수정 시간',
    `post_id`          INTEGER   NOT NULL COMMENT '게시글 ID',
    `user_code`        INTEGER   NOT NULL COMMENT '사용자 코드',
    `reply_comment_id` INTEGER   COMMENT '상위댓글ID',
    `is_delete`        CHAR(1)   DEFAULT 'N' NOT NULL COMMENT '삭제여부',
    PRIMARY KEY (`comment_id`),
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (`reply_comment_id`)
        REFERENCES `comment` (`comment_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (`post_id`)
        REFERENCES `post` (`post_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = '댓글';

-- 댓글 좋아요
CREATE OR REPLACE TABLE `comment_like` (
    `user_code`   INTEGER NOT NULL COMMENT '사용자 코드',
    `comment_id`  INTEGER NOT NULL COMMENT '댓글 ID',
    PRIMARY KEY (`user_code`, `comment_id`),
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`comment_id`)
        REFERENCES `comment` (`comment_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = '댓글 좋아요';

-- 팔로우
CREATE OR REPLACE TABLE `follow` (
    `follow_id`       INTEGER NOT NULL AUTO_INCREMENT COMMENT '팔로우 ID',
    `following_code`  INTEGER NOT NULL COMMENT '팔로잉 코드',
    `follower_code`   INTEGER NOT NULL COMMENT '팔로워 코드',
    PRIMARY KEY (`follow_id`),
    FOREIGN KEY (`following_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`follower_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = '팔로우';

-- 게시글-사진
CREATE OR REPLACE TABLE `post_img` (
    `img_id`   INTEGER NOT NULL AUTO_INCREMENT COMMENT '게시글-사진ID',
    `post_id`  INTEGER NOT NULL COMMENT '게시글ID',
    `img_url`  TEXT    NOT NULL COMMENT '사진URL',
    PRIMARY KEY (`img_id`),
    FOREIGN KEY (`post_id`)
        REFERENCES `post` (`post_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = '게시글-사진';

-- 게시글좋아요
CREATE OR REPLACE TABLE `post_like` (
    `user_code` INTEGER NOT NULL COMMENT '사용자코드',
    `post_id`   INTEGER NOT NULL COMMENT '게시글ID',
    PRIMARY KEY (`user_code`, `post_id`),
    FOREIGN KEY (`post_id`)
        REFERENCES `post` (`post_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = '게시글좋아요';

-- 신고
CREATE OR REPLACE TABLE `notify` (
    `notify_id`     INTEGER     NOT NULL AUTO_INCREMENT COMMENT '신고ID',
    `notify_reason` TEXT        NOT NULL COMMENT '신고사유',
    `notify_date`   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '신고날짜',
    `user_code`     INTEGER     NOT NULL COMMENT '신고자ID',
    `post_id`       INTEGER     COMMENT '게시글ID',
    `comment_id`    INTEGER     COMMENT '댓글ID',
    PRIMARY KEY (`notify_id`),
    FOREIGN KEY (`user_code`)
        REFERENCES `user` (`user_code`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (`post_id`)
        REFERENCES `post` (`post_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (`comment_id`)
        REFERENCES `comment` (`comment_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) COMMENT = '신고';
