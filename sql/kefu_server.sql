/*
 Navicat MySQL Data Transfer

 Source Server         : 192.168.31.72
 Source Server Type    : MySQL
 Source Server Version : 50728
 Source Host           : 192.168.31.72:3306
 Source Schema         : kefu_server

 Target Server Type    : MySQL
 Target Server Version : 50728
 File Encoding         : 65001

 Date: 18/12/2019 23:43:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `avatar` char(255) NOT NULL DEFAULT '',
  `username` char(255) NOT NULL DEFAULT '',
  `nickname` char(255) NOT NULL DEFAULT '',
  `password` char(255) NOT NULL DEFAULT '',
  `phone` char(255) DEFAULT NULL,
  `token` longtext,
  `auto_reply` longtext,
  `online` int(11) NOT NULL DEFAULT '0',
  `root` int(11) NOT NULL DEFAULT '0',
  `current_con_user` bigint(20) NOT NULL DEFAULT '0',
  `last_activity` bigint(20) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
BEGIN;
INSERT INTO `admin` VALUES (100, 'http://qiniu.cmp520.com/11445830860408686.jpeg', 'keith', 'Keith', 'b74625d2e39e76f7d017873f3f5a7571', '13800138000', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAwLCJhdmF0YXIiOiJodHRwOi8vcWluaXUuY21wNTIwLmNvbS84MDk2MTYwOTU5OTgzNTc2LmpwZyIsInVzZXJuYW1lIjoia2VpdGgiLCJuaWNrbmFtZSI6IktlaXRoIiwicGFzc3dvcmQiOiIiLCJwaG9uZSI6IjEzODAwMTM4MDAwIiwidG9rZW4iOiIiLCJhdXRvX3JlcGx5Ijoi5oKo5aW977yM5oiR5piv5Zyo57q_5a6i5pyNS2VpdGgs5bel5Y-3MTAw77yM5pyJ5LuA5LmI5Y-v5Lul5biu5Yiw5oKo5ZGi77yfIiwib25saW5lIjowLCJyb290IjoxLCJjdXJyZW50X2Nvbl91c2VyIjowLCJsYXN0X2FjdGl2aXR5IjoxNTc2NTk3MzI5LCJ1cGRhdGVfYXQiOjE1NzY1ODgxNDMsImNyZWF0ZV9hdCI6MTU2MzExODYzMCwiZXhwIjoxNTc2OTM2MzgyLCJpYXQiOjE1NzY2NzcxODIsImlzcyI6ImtlaXRoIn0.xO5jp__ogQ0uUi99NKAE31l7Fa7bB4tL7w4hfaCE3LA', '您好，我是在线客服Keith,工号100，有什么可以帮到您呢？', 1, 1, 0, 1576683750, 1576681836, 1563118630);
INSERT INTO `admin` VALUES (101, 'http://qiniu.cmp520.com/3971858868282022.jpg', 'test1', '小敏', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTExLCJhdmF0YXIiOiJodHRwOi8vcWluaXUuY21wNTIwLmNvbS8zOTcxODU4ODY4MjgyMDIyLmpwZyIsInVzZXJuYW1lIjoib3VtaW4iLCJuaWNrbmFtZSI6IuWwj-aVjyIsInBhc3N3b3JkIjoiIiwicGhvbmUiOiIxMzgwMDEzODAwMCIsInRva2VuIjoiIiwiYXV0b19yZXBseSI6IuaCqOWlve-8jOaIkeaYr-WcqOe6v-WuouacjeWwj-aVj--8jOacieS7gOS5iOWPr-S7peW4ruWIsOS9oO-8nyIsIm9ubGluZSI6MSwicm9vdCI6MCwiY3VycmVudF9jb25fdXNlciI6MjM4OTAwNCwibGFzdF9hY3Rpdml0eSI6MTU3NjM5MTM2NSwidXBkYXRlX2F0IjowLCJjcmVhdGVfYXQiOjE1Njc1NjQ3OTYsImV4cCI6MTU3NjY1MDU4MCwiaWF0IjoxNTc2MzkxMzgwLCJpc3MiOiJvdW1pbiJ9.B7kTtJUHmBX7c-jz54G1K_OUTL3FRhojUe_IAPtUaKg', '您好，我是在线客服小敏,工号101，有什么可以帮到您呢？', 0, 0, 2394408, 1576403960, 0, 1567564796);
INSERT INTO `admin` VALUES (102, 'http://qiniu.cmp520.com/4097459283995998.jpeg', 'test2', '草草', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTE1LCJhdmF0YXIiOiJodHRwOi8vcWluaXUuY21wNTIwLmNvbS80MDk3NDU5MjgzOTk1OTk4LmpwZWciLCJ1c2VybmFtZSI6Inl1YW55dWFuIiwibmlja25hbWUiOiLojYnojYkiLCJwYXNzd29yZCI6IiIsInBob25lIjoiMTM4MDAxMzgwMDAiLCJ0b2tlbiI6IiIsImF1dG9fcmVwbHkiOiLmgqjlpb3vvIzmiJHmmK_lnKjnur_kurrlt6XlrqLmnI3lsI_onJzonILvvIzmnInku4DkuYjlj6_ku6XluK7liLDkvaDvvJ8iLCJvbmxpbmUiOjAsInJvb3QiOjAsImN1cnJlbnRfY29uX3VzZXIiOjIzODQ2OTgsImxhc3RfYWN0aXZpdHkiOjE1NzY0Njg5MzIsInVwZGF0ZV9hdCI6MTU3MzAxMzQyNywiY3JlYXRlX2F0IjoxNTY5MjA5ODMyLCJleHAiOjE1NzY3MjgxNDcsImlhdCI6MTU3NjQ2ODk0NywiaXNzIjoieXVhbnl1YW4ifQ.MojEmfRIc9yUik-td5FOOcuj4LU_zALhVTiP2CrcnfM', '您好，我是在线客服草草，工号102，有什么可以帮到您呢？', 0, 0, 2397675, 1576470937, 1573013427, 1569209832);
INSERT INTO `admin` VALUES (103, 'http://qiniu.cmp520.com/1845329999348814.jpeg', 'test3', '小文', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTE2LCJhdmF0YXIiOiJodHRwOi8vcWluaXUuY21wNTIwLmNvbS8xODQ1MzI5OTk5MzQ4ODE0LmpwZWciLCJ1c2VybmFtZSI6ImxpbmdsaW5nIiwibmlja25hbWUiOiLlkYblkYYiLCJwYXNzd29yZCI6IiIsInBob25lIjoiMTM4MDAxMzgwMDAiLCJ0b2tlbiI6IiIsImF1dG9fcmVwbHkiOiLmgqjlpb3vvIzmiJHmmK_lnKjnur_kurrlt6XlrqLmnI3lkYblkYbvvIzor7fnroDljZXmj4_ov7Dpl67popgr5o-Q5L6b5LiL5Y2V5omL5py65Y-356CBL-iuouWNleWPt--8jOS7peS-v-W_q-mAn-S4uuaCqOino-WGs-mXrumimOOAgiIsIm9ubGluZSI6MCwicm9vdCI6MCwiY3VycmVudF9jb25fdXNlciI6MjM4NTI2NiwibGFzdF9hY3Rpdml0eSI6MTU3NjIyMDM4MywidXBkYXRlX2F0IjoxNTc2MDI2MzA2LCJjcmVhdGVfYXQiOjE1NjkyMDk4NjIsImV4cCI6MTU3NjczMzQ3NiwiaWF0IjoxNTc2NDc0Mjc2LCJpc3MiOiJsaW5nbGluZyJ9.ETARh2wSN_xnMtlav7u9Y3HOE6hyWmpjsXsVUB9kWEM', '您好，我是在线客服小文，工号103，有什么可以帮到您呢？', 0, 0, 2398306, 1576477657, 1576026306, 1569209862);
INSERT INTO `admin` VALUES (104, 'http://qiniu.cmp520.com/11538885325704032.jpeg', 'test4', 'lucky', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTE3LCJhdmF0YXIiOiJodHRwOi8vcWluaXUuY21wNTIwLmNvbS8xMTUzODg4NTMyNTcwNDAzMi5qcGVnIiwidXNlcm5hbWUiOiJkaWRpIiwibmlja25hbWUiOiJsdWNreSIsInBhc3N3b3JkIjoiIiwicGhvbmUiOiIxMzgwMDEzODAwMCIsInRva2VuIjoiIiwiYXV0b19yZXBseSI6IuaCqOWlve-8jOW-iOmrmOWFtOS4uuaCqOacjeWKoe-8jOivt-eugOWNleaPj-i_sOmXrumimCvmj5DkvpvkuIvljZXmiYvmnLrlj7fnoIEv6K6i5Y2V5Y-377yM5Lul5L6_5b-r6YCf5Li65oKo6Kej5Yaz6Zeu6aKY44CCIiwib25saW5lIjowLCJyb290IjowLCJjdXJyZW50X2Nvbl91c2VyIjoyMzg1MTAzLCJsYXN0X2FjdGl2aXR5IjoxNTc2NDcyNzUwLCJ1cGRhdGVfYXQiOjE1NzYwMjUyNTAsImNyZWF0ZV9hdCI6MTU2OTIwOTk2OSwiZXhwIjoxNTc2NzMxOTU1LCJpYXQiOjE1NzY0NzI3NTUsImlzcyI6ImRpZGkifQ.1eS63ZAUnF3nAKRD4qCmct4GutZkhoZOgJ3pg37Afl8', '您好，我是在线客服lucky，工号104，有什么可以帮到您呢？', 0, 0, 2398187, 1576474882, 1576025250, 1569209969);
INSERT INTO `admin` VALUES (105, 'http://qiniu.cmp520.com/9195327141090814.jpg', 'test5', '雯雯', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTE4LCJhdmF0YXIiOiJodHRwOi8vcWluaXUuY21wNTIwLmNvbS85MTk1MzI3MTQxMDkwODE0LmpwZyIsInVzZXJuYW1lIjoibGlud2Fud2VuIiwibmlja25hbWUiOiLpm6_pm68iLCJwYXNzd29yZCI6IiIsInBob25lIjoiMTM4MDAxMzgwMDAiLCJ0b2tlbiI6IiIsImF1dG9fcmVwbHkiOiLmgqjlpb3vvIzlvojpq5jlhbTkuLrmgqjmnI3liqHvvIzor7fnroDljZXmj4_ov7Dpl67popgr5o-Q5L6b5LiL5Y2V5omL5py65Y-356CBL-iuouWNleWPt--8jOS7peS-v-W_q-mAn-S4uuaCqOino-WGs-mXrumimOOAgiIsIm9ubGluZSI6MCwicm9vdCI6MCwiY3VycmVudF9jb25fdXNlciI6MjM4Njc0MywibGFzdF9hY3Rpdml0eSI6MTU3NjMwMTQyMCwidXBkYXRlX2F0IjoxNTc2MDI2MzI2LCJjcmVhdGVfYXQiOjE1NzEwMTYxMjAsImV4cCI6MTU3NjU2MDY1MSwiaWF0IjoxNTc2MzAxNDUxLCJpc3MiOiJsaW53YW53ZW4ifQ.1lhMawoCtROiPIs7T2AEMCIX6pgl35oJDRV-nBzKsIE', '您好，我是在线客服雯雯，工号105，有什么可以帮到您呢？', 0, 0, 2399519, 1576490686, 1576026326, 1571016120);
COMMIT;

-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `logo` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `service` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `email` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `tel` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `address` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of company
-- ----------------------------
BEGIN;
INSERT INTO `company` VALUES (1, '客服系统', 'http://localhost:8080/static/uploads/images/7485103156563738.png', '周一至周日 9:00 - 18:00', '361554012@qq.com', '400', '广州', 1576680961);
COMMIT;

-- ----------------------------
-- Table structure for contact
-- ----------------------------
DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_account` bigint(20) NOT NULL DEFAULT '0',
  `to_account` bigint(20) NOT NULL DEFAULT '0',
  `last_message` longtext COLLATE utf8mb4_bin NOT NULL,
  `last_message_type` longtext COLLATE utf8mb4_bin NOT NULL,
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `is_session_end` int(11) NOT NULL DEFAULT '0',
  `delete` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15766 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for knowledge_base
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_base`;
CREATE TABLE `knowledge_base` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `title` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `sub_title` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_bin,
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_account` bigint(20) NOT NULL DEFAULT '0',
  `to_account` bigint(20) NOT NULL DEFAULT '0',
  `biz_type` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `version` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `timestamp` bigint(20) NOT NULL DEFAULT '0',
  `payload` longtext COLLATE utf8mb4_bin,
  `read` int(11) NOT NULL DEFAULT '1',
  `transfer_account` bigint(20) NOT NULL DEFAULT '0',
  `delete` int(11) NOT NULL DEFAULT '0',
  `key` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=310031 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for platform
-- ----------------------------
DROP TABLE IF EXISTS `platform`;
CREATE TABLE `platform` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `alias` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `system` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of platform
-- ----------------------------
BEGIN;
INSERT INTO `platform` VALUES (1, '全平台', 'all', 1);
INSERT INTO `platform` VALUES (2, 'IOS', 'ios', 1);
INSERT INTO `platform` VALUES (3, '小程序', 'small', 1);
INSERT INTO `platform` VALUES (4, 'PC网页', 'pc', 1);
INSERT INTO `platform` VALUES (5, '移动网页', 'mobile', 1);
INSERT INTO `platform` VALUES (6, 'Android', 'android', 1);
COMMIT;

-- ----------------------------
-- Table structure for qiniu_setting
-- ----------------------------
DROP TABLE IF EXISTS `qiniu_setting`;
CREATE TABLE `qiniu_setting` (
  `id` bigint(20) NOT NULL,
  `bucket` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `access_key` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `secret_key` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `host` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `update_at` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of qiniu_setting
-- ----------------------------
BEGIN;
INSERT INTO `qiniu_setting` VALUES (1, 'cmp520', 'eeMnLRyKSTp0JvtsX1fIhZFDWSb6c8qQEBqc5OGZ', 'tPdOHTsSI7d8uXOZUcmVolF7qGARxYvHQrDut8RR', 'http://qiniu.cmp520.com', 1576680587);
COMMIT;

-- ----------------------------
-- Table structure for robot
-- ----------------------------
DROP TABLE IF EXISTS `robot`;
CREATE TABLE `robot` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nickname` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `avatar` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `welcome` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `understand` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `artificial` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `switch` int(11) NOT NULL DEFAULT '0',
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) DEFAULT NULL,
  `system` int(11) NOT NULL DEFAULT '1',
  `keyword` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `timeout_text` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `no_services` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `loog_time_wait_text` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000000001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of robot
-- ----------------------------
BEGIN;
INSERT INTO `robot` VALUES (1000000000, 'MIMC机器人助理', 'http://qiniu.cmp520.com/4473448454302935.jpg', '您好，我是MIMC机器人助理，很高兴为您服务，您可以问我一些关于MIMC的相关问题，如需接入在线客服，请回复“人工”。', '我还不理解您的意思呢，换个其他问题看看.', '|转人工|在线客服|找人工|人工服务|我要找人工|人工客服|', 1, 1, 0, 1564626187, 1, '|收费|', '由于您长时间未回复，系统结束了本次会话，如您还有其他问题，请重新发起会话，感谢您的支持', '当前没有值班MM哦，我们的MM值班时间为周一至周五 9:00 - 18:00 您可以在此时间段进行咨询，感谢您的支持', '很抱歉呢，由于目前咨询人数过多，请耐心等待一会哦');
COMMIT;

-- ----------------------------
-- Table structure for services_statistical
-- ----------------------------
DROP TABLE IF EXISTS `services_statistical`;
CREATE TABLE `services_statistical` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_account` bigint(20) NOT NULL DEFAULT '0',
  `service_account` bigint(20) NOT NULL DEFAULT '0',
  `transfer_account` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `nickname` char(255) DEFAULT NULL,
  `satisfaction` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17050 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shortcut
-- ----------------------------
DROP TABLE IF EXISTS `shortcut`;
CREATE TABLE `shortcut` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `content` longtext COLLATE utf8mb4_bin,
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `title` longtext COLLATE utf8mb4_bin,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for system
-- ----------------------------
DROP TABLE IF EXISTS `system`;
CREATE TABLE `system` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `logo` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `copy_right` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `upload_mode` int(11) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of system
-- ----------------------------
BEGIN;
INSERT INTO `system` VALUES (1, '客服系统-工作台', 'http://localhost:8080/static/uploads/images/1895426542557186.png', '©2019-2029 Macromedia, Inc. All rights reserved.', 1, 1576682340);
COMMIT;

-- ----------------------------
-- Table structure for uploads_config
-- ----------------------------
DROP TABLE IF EXISTS `uploads_config`;
CREATE TABLE `uploads_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` char(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of uploads_config
-- ----------------------------
BEGIN;
INSERT INTO `uploads_config` VALUES (1, '系统内置存储');
INSERT INTO `uploads_config` VALUES (2, '七牛云存储');
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `avatar` char(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `address` char(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `nickname` char(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `token` longtext COLLATE utf8mb4_bin,
  `phone` char(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `online` int(11) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `remarks` char(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `last_activity` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `is_window` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

SET FOREIGN_KEY_CHECKS = 1;
