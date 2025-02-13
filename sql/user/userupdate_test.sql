-- 회원정보 수정
UPDATE user
  SET nickname = '챙이'
 WHERE user_code = 1;
UPDATE user
  SET profile_img = 'testimg'
 WHERE user_code = 1;
UPDATE user
  SET introduce = 'test'
 WHERE user_code = 1;
UPDATE user
  SET is_alarm = 'N'
 WHERE user_code = 1;
 UPDATE user
  SET is_public = 'N'
 WHERE user_code = 1;
