CREATE TABLE `level`
(
    `level_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '등급ID',
    `level_title`    VARCHAR(15) NOT NULL COMMENT '등급이름',
 PRIMARY KEY ( `level_id` )
) COMMENT = '등급';


CREATE TABLE `user`
(
    `user_code`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '사용자코드',
    `user_id`    VARCHAR(30) NOT NULL COMMENT '아이디',
    `user_name`    VARCHAR(255) NOT NULL COMMENT '이름',
    `password`    VARCHAR(255) NOT NULL COMMENT '비밀번호',
    `nickname`    VARCHAR(255) NOT NULL COMMENT '닉네임',
    `phone`    VARCHAR(11) NOT NULL COMMENT '전화번호',
    `birth`    DATE NOT NULL COMMENT '생년월일',
    `profile_img`    TEXT COMMENT '프로필사진',
    `introduce`    VARCHAR(255) COMMENT '한줄소개',
    `create_date`    TIMESTAMP NOT NULL COMMENT '계정생성날짜',
    `is_manager`    CHAR(1) DEFAULT 'N' NOT NULL COMMENT '관리자권한여부',
    `is_ararm`    CHAR(1) DEFAULT 'Y' NOT NULL COMMENT '알림설정여부',
    `is_public`    CHAR(1) DEFAULT 'N' COMMENT '계정공개여부',
    `is_delete`    CHAR(1) DEFAULT 'N' NOT NULL COMMENT '탈퇴여부',
    `delete_date`    TIMESTAMP COMMENT '탈퇴신청날짜',
    `level_id`    INTEGER NOT NULL COMMENT '등급ID',
 PRIMARY KEY ( `user_code` )
) COMMENT = '사용자';

ALTER TABLE `user`
 ADD CONSTRAINT `user_FK` FOREIGN KEY ( `level_id` )
 REFERENCES `level` (`level_id` );

CREATE TABLE `opu_category`
(
    `opu_category_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT 'OPU카테고리ID',
    `opu_category_name`    CHAR(5) NOT NULL COMMENT 'OPU카테고리이름',
 PRIMARY KEY ( `opu_category_id` )
) COMMENT = 'OPU카테고리';

CREATE TABLE `question`
(
    `question_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '성향질문ID',
    `question_content`    VARCHAR(60) NOT NULL COMMENT '질문내용',
 PRIMARY KEY ( `question_id` )
) COMMENT = '성향 질문';

CREATE TABLE `answer`
(
    `answer_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '성향답변ID',
    `opu_category_id`    INTEGER NOT NULL COMMENT 'OPU카테고리ID',
    `question_id`    INTEGER NOT NULL COMMENT '성향질문ID',
    `answer_content`    VARCHAR(255) NOT NULL COMMENT '답변내용',
 PRIMARY KEY ( `answer_id` )
) COMMENT = '성향답변';

ALTER TABLE `answer`
 ADD CONSTRAINT `answer_FK` FOREIGN KEY ( `opu_category_id` )
 REFERENCES `opu_category` (`opu_category_id` );

ALTER TABLE `answer`
 ADD CONSTRAINT `answer_FK1` FOREIGN KEY ( `question_id` )
 REFERENCES `question` (`question_id` );


CREATE TABLE `blacklist`
(
    `블랙리스트ID`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '블랙리스트ID',
    `사용자이름`    VARCHAR(255) NOT NULL COMMENT '사용자이름',
    `전화번호`    VARCHAR(11) NOT NULL COMMENT '전화번호',
    `사유`    VARCHAR(255) NOT NULL COMMENT '사유',
    `지정날짜`    TIMESTAMP NOT NULL COMMENT '지정날짜',
 PRIMARY KEY ( `블랙리스트ID` )
) COMMENT = '블랙리스트';


CREATE TABLE `post_category`
(
    `category_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '게시글-카테고리ID',
    `category_name`    CHAR(30) NOT NULL COMMENT '카테고리명',
 PRIMARY KEY ( `category_id` )
) COMMENT = '게시글-카테고리';


CREATE TABLE `post`
(
    `post_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '게시글ID',
    `post_title`    VARCHAR(255) NOT NULL COMMENT '제목',
    `post_content`    TEXT NOT NULL COMMENT '내용',
    `create_at`    TIMESTAMP NOT NULL COMMENT '생성시간',
    `update_at`    TIMESTAMP NOT NULL COMMENT '마지막수정시간',
    `user_code`    INTEGER NOT NULL COMMENT '사용자코드',
    `category_id`    INTEGER NOT NULL COMMENT '게시글-카테고리ID',
 PRIMARY KEY ( `post_id` )
) COMMENT = '게시글';

ALTER TABLE `post`
 ADD CONSTRAINT `post_FK` FOREIGN KEY ( `user_code` )
 REFERENCES `user` (`user_code` );

ALTER TABLE `post`
 ADD CONSTRAINT `post_FK1` FOREIGN KEY ( `category_id` )
 REFERENCES `post_category` (`category_id` );



CREATE TABLE `comment`
(
    `comment_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '댓글ID',
    `comment_content`    TEXT NOT NULL COMMENT '댓글내용',
    `create_at`    TIMESTAMP NOT NULL COMMENT '댓글생성시간',
    `update_at`    TIMESTAMP NOT NULL COMMENT '마지막수정시간',
    `post_id`    INTEGER NOT NULL COMMENT '게시글ID',
    `user_code`    INTEGER NOT NULL COMMENT '사용자코드',
    `reply_comment_id`    INTEGER COMMENT '답글ID',
 PRIMARY KEY ( `comment_id` )
) COMMENT = '댓글';

ALTER TABLE `comment`
 ADD CONSTRAINT `comment_FK` FOREIGN KEY ( `user_code` )
 REFERENCES `user` (`user_code` );

ALTER TABLE `comment`
 ADD CONSTRAINT `comment_FK1` FOREIGN KEY ( `reply_comment_id` )
 REFERENCES `comment` (`comment_id` );

ALTER TABLE `comment`
 ADD CONSTRAINT `comment_FK2` FOREIGN KEY ( `post_id` )
 REFERENCES `post` (`post_id` );


CREATE TABLE `comment_like`
(
    `user_code`    INTEGER NOT NULL COMMENT '사용자코드',
    `comment_id`    INTEGER NOT NULL COMMENT '댓글ID',
 PRIMARY KEY ( `user_code`,`comment_id` )
) COMMENT = '댓글좋아요';

ALTER TABLE `comment_like`
 ADD CONSTRAINT `comment_like_FK` FOREIGN KEY ( `user_code` )
 REFERENCES `user` (`user_code` );

ALTER TABLE `comment_like`
 ADD CONSTRAINT `comment_like_FK1` FOREIGN KEY ( `comment_id` )
 REFERENCES `comment` (`comment_id` );

CREATE TABLE `follow`
(
    `follow_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '팔로우ID',
    `following_code`    INTEGER NOT NULL COMMENT '팔로잉코드',
    `following_code1`    INTEGER NOT NULL COMMENT '팔로워코드',
 PRIMARY KEY ( `follow_id` )
) COMMENT = '팔로우';

ALTER TABLE `follow`
 ADD CONSTRAINT `follow_FK` FOREIGN KEY ( `following_code` )
 REFERENCES `user` (`user_code` );

ALTER TABLE `follow`
 ADD CONSTRAINT `follow_FK1` FOREIGN KEY ( `following_code1` )
 REFERENCES `user` (`user_code` );

CREATE TABLE `notify`
(
    `notify_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '신고ID',
    `notify_reason`    TEXT NOT NULL COMMENT '신고사유',
    `notify_date`    TIMESTAMP NOT NULL COMMENT '신고날짜',
    `user_code`    INTEGER NOT NULL COMMENT '신고자ID',
    `post_id`    INTEGER COMMENT '게시글ID',
    `comment_id`    INTEGER COMMENT '댓글ID',
 PRIMARY KEY ( `notify_id` )
) COMMENT = '신고';

ALTER TABLE `notify`
 ADD CONSTRAINT `notify_FK` FOREIGN KEY ( `user_code` )
 REFERENCES `user` (`user_code` );

ALTER TABLE `notify`
 ADD CONSTRAINT `notify_FK1` FOREIGN KEY ( `post_id` )
 REFERENCES `post` (`post_id` );

ALTER TABLE `notify`
 ADD CONSTRAINT `notify_FK2` FOREIGN KEY ( `comment_id` )
 REFERENCES `comment` (`comment_id` );


CREATE TABLE `opu_script`
(
    `opu_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT 'OPUID',
    `opu_content`    VARCHAR(30) NOT NULL COMMENT 'OPU내용',
    `opu_category_id`    INTEGER NOT NULL COMMENT 'OPU카테고리ID',
 PRIMARY KEY ( `opu_id` )
) COMMENT = 'OPU스크립트';

ALTER TABLE `opu_script`
 ADD CONSTRAINT `opu_script_FK` FOREIGN KEY ( `opu_category_id` )
 REFERENCES `opu_category` (`opu_category_id` );


CREATE TABLE `time`
(
    `time_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '시간ID',
    `time_content`    INTEGER NOT NULL COMMENT '시간내용',
 PRIMARY KEY ( `time_id` )
) COMMENT = '시간ID';


CREATE TABLE `opu_list`
(
    `opu_list_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT 'OPU목록ID',
    `opu_id`    INTEGER NOT NULL COMMENT 'OPUID',
    `time_id`    INTEGER NOT NULL COMMENT '시간ID',
 PRIMARY KEY ( `opu_list_id` )
) COMMENT = 'OPU목록';

ALTER TABLE `opu_list`
 ADD CONSTRAINT `opu_list_FK` FOREIGN KEY ( `time_id` )
 REFERENCES `time` (`time_id` );

ALTER TABLE `opu_list`
 ADD CONSTRAINT `opu_list_FK1` FOREIGN KEY ( `opu_id` )
 REFERENCES `opu_script` (`opu_id` );




CREATE TABLE `opu_add`
(
    `OPU 추가 ID`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT 'OPU 추가 ID',
    `user_code`    INTEGER NOT NULL COMMENT '사용자코드',
    `date`    DATE NOT NULL COMMENT '날짜',
    `is_check`    CHAR(1) DEFAULT 'N' NOT NULL COMMENT '체크여부',
    `opu_content`    VARCHAR(30) COMMENT 'OPU내용',
    `opu_list_id`    INTEGER COMMENT 'OPU목록ID',
 PRIMARY KEY ( `OPU 추가 ID` )
) COMMENT = 'OPU추가';

ALTER TABLE `opu_add`
 ADD CONSTRAINT `opu_add_FK` FOREIGN KEY ( `opu_list_id` )
 REFERENCES `opu_list` (`opu_list_id` );

ALTER TABLE `opu_add`
 ADD CONSTRAINT `opu_add_FK1` FOREIGN KEY ( `user_code` )
 REFERENCES `user` (`user_code` );




CREATE TABLE `post_img`
(
    `img_id`    INTEGER NOT NULL AUTO_INCREMENT
 COMMENT '게시글-사진ID',
    `post_id`    INTEGER NOT NULL COMMENT '게시글ID',
    `img_url`    TEXT NOT NULL COMMENT '사진URL',
 PRIMARY KEY ( `img_id` )
) COMMENT = '게시글-사진';

ALTER TABLE `post_img`
 ADD CONSTRAINT `post_img_FK` FOREIGN KEY ( `post_id` )
 REFERENCES `post` (`post_id` );


CREATE TABLE `post_like`
(
    `user_code`    INTEGER NOT NULL COMMENT '사용자코드',
    `post_id`    INTEGER NOT NULL COMMENT '게시글ID',
 PRIMARY KEY ( `user_code`,`post_id` )
) COMMENT = '게시글좋아요';

ALTER TABLE `post_like`
 ADD CONSTRAINT `post_like_FK` FOREIGN KEY ( `post_id` )
 REFERENCES `post` (`post_id` );

ALTER TABLE `post_like`
 ADD CONSTRAINT `post_like_FK1` FOREIGN KEY ( `user_code` )
 REFERENCES `user` (`user_code` );


CREATE TABLE `result`
(
    `user_code`    INTEGER NOT NULL COMMENT '사용자코드',
    `health_score`    INTEGER DEFAULT 0 NOT NULL COMMENT '건강점수',
    `food_score`    INTEGER DEFAULT 0 NOT NULL COMMENT '음식점수',
    `culture_score`    INTEGER DEFAULT 0 NOT NULL COMMENT '문화점수',
    `knowledge_score`    INTEGER DEFAULT 0 NOT NULL COMMENT '지식점수',
 PRIMARY KEY ( `user_code` )
) COMMENT = '성향결과';

ALTER TABLE `result`
 ADD CONSTRAINT `result_FK` FOREIGN KEY ( `user_code` )
 REFERENCES `user` (`user_code` );




