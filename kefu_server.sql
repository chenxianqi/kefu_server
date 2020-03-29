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

 Date: 29/03/2020 16:53:32
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
) ENGINE=InnoDB AUTO_INCREMENT=1006 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
BEGIN;
INSERT INTO `admin` VALUES (1000, 'http://qiniu.cmp520.com/3971858868282022.jpg', 'keith', 'Keith', 'e10adc3949ba59abbe56e057f20f883e', '13800138001', '', '您好，我是在线客服Keith,工号100，有什么可以帮到您呢？', 0, 1, 0, 1585471958, 1585471960, 1563118630);
INSERT INTO `admin` VALUES (1001, 'http://qiniu.cmp520.com/3971858868282022.jpg', 'test1', '小敏', '3470a55fa7e388375d2586e971b0dca8', '13800138000', '', '您好，我是在线客服小敏,工号101，有什么可以帮到您呢？', 0, 0, 0, 1583557477, 1583371312, 1567564796);
INSERT INTO `admin` VALUES (1002, 'http://qiniu.cmp520.com/4097459283995998.jpeg', 'test2', '草草', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服草草，工号102，有什么可以帮到您呢？', 0, 0, 0, 1583826929, 1578034246, 1569209832);
INSERT INTO `admin` VALUES (1003, 'http://qiniu.cmp520.com/1845329999348814.jpeg', 'test3', '小文', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服小文，工号103，有什么可以帮到您呢？', 0, 0, 0, 1580979599, 1577095312, 1569209862);
INSERT INTO `admin` VALUES (1004, 'http://qiniu.cmp520.com/11538885325704032.jpeg', 'test4', 'lucky', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服lucky，工号104，有什么可以帮到您呢？', 0, 0, 0, 1578377194, 1577095334, 1569209969);
INSERT INTO `admin` VALUES (1005, 'http://qiniu.cmp520.com/9195327141090814.jpg', 'test5', '雯雯', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服雯雯，工号105，有什么可以帮到您呢？', 0, 0, 0, 1585377099, 1577095351, 1571016120);
COMMIT;

-- ----------------------------
-- Table structure for auth_types
-- ----------------------------
DROP TABLE IF EXISTS `auth_types`;
CREATE TABLE `auth_types` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` char(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_types
-- ----------------------------
BEGIN;
INSERT INTO `auth_types` VALUES (1, '网页');
INSERT INTO `auth_types` VALUES (2, 'APP');
COMMIT;

-- ----------------------------
-- Table structure for auths
-- ----------------------------
DROP TABLE IF EXISTS `auths`;
CREATE TABLE `auths` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `auth_type` bigint(20) NOT NULL DEFAULT '0',
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `token` longtext,
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auths
-- ----------------------------
BEGIN;
INSERT INTO `auths` VALUES (50, 2, 105, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTA1LCJBdXRoVHlwZSI6MiwiVXNlck5hbWUiOiJ0ZXN0NSIsImV4cCI6MTU4MzY4MjYxNCwiaWF0IjoxNTgzNDIzNDE0LCJpc3MiOiJ0ZXN0NSJ9._gLoBMRcSSob_uxQ3TNZVlarwG_ZBqHySl9DhFdbp90', 1583423414, 1583423414);
INSERT INTO `auths` VALUES (54, 2, 100, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTAwLCJBdXRoVHlwZSI6MiwiVXNlck5hbWUiOiJrZWl0aCIsImV4cCI6MTU4NDE1NzQ4NSwiaWF0IjoxNTgzODk4Mjg1LCJpc3MiOiJrZWl0aCJ9._OGZlem6_rvq_BxITpTi2Q_E7Fr9uQlGjMQTC6xKBLY', 1583898285, 1583477044);
INSERT INTO `auths` VALUES (56, 1, 101, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTAxLCJBdXRoVHlwZSI6MSwiVXNlck5hbWUiOiJ0ZXN0MSIsImV4cCI6MTU4Mzc0MzI0MiwiaWF0IjoxNTgzNDg0MDQyLCJpc3MiOiJ0ZXN0MSJ9.gwCkNFnQxbmSmsnW7yJef_3sYTsulyQH6-Uv9AFYFAI', 1583484042, 1583484042);
INSERT INTO `auths` VALUES (57, 1, 105, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTA1LCJBdXRoVHlwZSI6MSwiVXNlck5hbWUiOiJ0ZXN0NSIsImV4cCI6MTU4NDA3MDY4MiwiaWF0IjoxNTgzODExNDgyLCJpc3MiOiJ0ZXN0NSJ9.E2vll62CWEPvxEV6Ym6TFn4S-mvcdlHZgFuHjSarGso', 1583811482, 1583582070);
INSERT INTO `auths` VALUES (63, 2, 102, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTAyLCJBdXRoVHlwZSI6MiwiVXNlck5hbWUiOiJ0ZXN0MiIsImV4cCI6MTU4NDE2MzY1OCwiaWF0IjoxNTgzOTA0NDU4LCJpc3MiOiJ0ZXN0MiJ9.abipF0-XcG-U5SojNioUPnlEStR-BKPO4_WdatOTZ9s', 1583904458, 1583904458);
INSERT INTO `auths` VALUES (65, 1, 100, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTAwLCJBdXRoVHlwZSI6MSwiVXNlck5hbWUiOiJrZWl0aCIsImV4cCI6MTU4NDE3NTQwNSwiaWF0IjoxNTgzOTE2MjA1LCJpc3MiOiJrZWl0aCJ9.Jlq25o13AiAOmHe66E970FYAYCE1t_Bt8PBEzcvtIwY', 1583916205, 1583916205);
INSERT INTO `auths` VALUES (66, 1, 1000, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTAwMCwiQXV0aFR5cGUiOjEsIlVzZXJOYW1lIjoia2VpdGgiLCJleHAiOjE1ODU2NjQ2NjEsImlhdCI6MTU4NTQwNTQ2MSwiaXNzIjoia2VpdGgifQ.iBvzmzb24QVZaWEJb8P4D7ubFZv5t6AQQNV4e9fITPY', 1585405461, 1584172132);
INSERT INTO `auths` VALUES (67, 2, 1000, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTAwMCwiQXV0aFR5cGUiOjIsIlVzZXJOYW1lIjoia2VpdGgiLCJleHAiOjE1ODUxODkyODQsImlhdCI6MTU4NDkzMDA4NCwiaXNzIjoia2VpdGgifQ.NB9PNBjCdDPMPo9t7BnkD8W6Du3bvX_sDLRG7R4PirA', 1584930084, 1584275686);
INSERT INTO `auths` VALUES (68, 1, 1005, 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTAwNSwiQXV0aFR5cGUiOjEsIlVzZXJOYW1lIjoidGVzdDUiLCJleHAiOjE1ODU2MzYyMzksImlhdCI6MTU4NTM3NzAzOSwiaXNzIjoidGVzdDUifQ.U8F7fkmlApMtRihx2YouOYRFVibUoubVwZm_qgYSnPc', 1585377039, 1585377039);
COMMIT;

-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` char(255) NOT NULL DEFAULT '',
  `logo` char(255) NOT NULL DEFAULT '',
  `service` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `tel` varchar(255) NOT NULL DEFAULT '',
  `address` char(255) NOT NULL DEFAULT '',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of company
-- ----------------------------
BEGIN;
INSERT INTO `company` VALUES (1, 'keith', 'http://kf.aissz.com:666/static/uploads/images/15655775732227256.jpg', '周一至周五 9:00-18:00', '361554012@qq.com', '400-000-001', '广州', 1584675995);
COMMIT;

-- ----------------------------
-- Table structure for contact
-- ----------------------------
DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_account` bigint(20) NOT NULL DEFAULT '0',
  `to_account` bigint(20) NOT NULL DEFAULT '0',
  `last_message` longtext NOT NULL,
  `last_message_type` longtext NOT NULL,
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `is_session_end` int(11) NOT NULL DEFAULT '0',
  `delete` int(11) NOT NULL DEFAULT '0',
  `last_account` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15925 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of contact
-- ----------------------------
BEGIN;
INSERT INTO `contact` VALUES (15915, 10000005, 1000, '5oKo6ZW/5pe26Ze05pyq5Zue5aSN5a6i5oi377yM5Lya6K+d57uT5p2f', 'timeout', 1584274320, 1, 1, 10000005);
INSERT INTO `contact` VALUES (15916, 10000528, 0, '5oKo6ZW/5pe26Ze05pyq5Zue5aSN5a6i5oi377yM5Lya6K+d57uT5p2f', 'timeout', 1585029900, 1, 0, 10000528);
INSERT INTO `contact` VALUES (15917, 10000016, 1000, 'MQ==', 'text', 1585404696, 1, 1, 10000016);
INSERT INTO `contact` VALUES (15918, 10000607, 1000, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 'text', 1585056978, 1, 1, 1000);
INSERT INTO `contact` VALUES (15919, 10000017, 1000, 'MjM0MjEz', 'text', 1585297156, 1, 1, 10000017);
INSERT INTO `contact` VALUES (15920, 10000019, 1000, '', 'end', 1585377834, 1, 1, 10000019);
INSERT INTO `contact` VALUES (15921, 10000021, 100, '', 'end', 1585376866, 1, 0, 10000021);
INSERT INTO `contact` VALUES (15922, 10000021, 1000, '6Zuv6Zuv5bCG6K6/5a6iMTAwMDAwMjHovazmjqXnu5nmgqg=', 'transfer', 1585377117, 1, 1, 10000021);
INSERT INTO `contact` VALUES (15923, 10000021, 1005, '5oKo5bCG6K6/5a6iMTAwMDAwMjHovazmjqXnu5lLZWl0aA==', 'transfer', 1585377117, 1, 0, 10000021);
INSERT INTO `contact` VALUES (15924, 10025818, 1000, '', 'end', 1585470233, 1, 0, 1000);
COMMIT;

-- ----------------------------
-- Table structure for knowledge_base
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_base`;
CREATE TABLE `knowledge_base` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `title` char(255) NOT NULL DEFAULT '',
  `sub_title` varchar(255) DEFAULT NULL,
  `content` longtext,
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of knowledge_base
-- ----------------------------
BEGIN;
INSERT INTO `knowledge_base` VALUES (2, 100, '小米即时消息云是什么', '|mimc|消息云|', 'MIMC是小米自研的一种安全、可靠、易用的分布式IM云服务。为广大开发者提供免费快捷的即时通讯接入服务。MIMC基于多年小米通讯技术积累，让即时通讯不再复杂。', 1, 0, 1576855560);
INSERT INTO `knowledge_base` VALUES (3, 100, '在线文档', '|SDK下载|API接入文档|', '目前开发者可在PC端打开链接小米开放平台查看小米即时消息云的介绍和API接入文档，SDK下载等。', 1, 0, 1576855628);
INSERT INTO `knowledge_base` VALUES (4, 100, '小米消息云使用场景', '|有什么用|用在什么地方|简单实现|', '1. 实现基础聊天功能\n网页、app内等引用场景下轻松实现基础聊天功能，包括单聊、群聊、聊天室等，无论你是社交app单聊，还是游戏内玩家公会聊天接入MIMC都可以轻松实现。\n2. 实现在线客服功能\n利用MIMC的一对一聊天通道实现在线客服的业务逻辑功能。\n3. 实现系统消息功能\n利用MIMC的消息下发功能实现系统消息的推送。\n4. 实现在线直播等其他功能\nMIMC的灵活易扩展的消息类型方便实现类似直播等其他各种不同类型的消息的传送。', 1, 0, 1576855695);
INSERT INTO `knowledge_base` VALUES (5, 100, '小米消息云有什么优势呢', '|完全免费|海量并发| 消息必达|消息漫游|全球接入|零成本接入|全平台支持|', '完全免费 海量并发 消息必达 消息漫游 全球接入 零成本接入 全平台支持\n\n1、APP方账号体系完美契合 目前市场上的消息云，APP开发者需要额外申请一套某信账号，并在服务端明文存储某信账号/密码，维护成本高昂，安全风险极高。 如果接入MIMC，APP开发者丝毫感知不到MIMC账号体系，所有收发都是用APP账号，无缝契合，安全性高。\n\n2、适用场景广泛 目前市场上的消息云，大都只能适用于聊天场景，其他消息场景不能支持。MIMC则可以支持智能硬件信令/聊天/客服/推送等任何消息传递场景。\n\n3、全平台支持 Android/iOS/Web/C/C#/Java/Go等全平台/多语言支持，一期支持Android/iOS/Web三平台，后续会根据用户需要支持更多平台/语言\n\n4、消息格式100%自定义高灵活度 目前市场上的消息云大都聊天内容/格式自定义程度低，扩展性差。MIMC不对消息内容/格式进行限制，APP可根据自己需求，灵活定制消息格式，传递更契合APP自身需求的数据。\n\n5、极简API设计 基于全新的api设计大大简化了app开发者的接入成本，3分钟即可实现聊天功能。', 1, 0, 1576855864);
INSERT INTO `knowledge_base` VALUES (6, 100, '目前已支持的SDK有哪些语言', '|sdk支持|开发语言|', 'WebJS，iOS，Android，Java， C#，C++， Go，和开发者贡献的小程序sdk,flutter-mimc等等，并不断的增加，并且绝大部分SDK代码已经开源，如果需要其他SDK支持请单独联系我们；', 1, 0, 1576856153);
INSERT INTO `knowledge_base` VALUES (7, 100, '小米消息云SDK支持多端登录吗', '|多端|消息同步|多终端同步|多个UA|', '小米消息云各个SDK都支持多端登录，并且消息多平台多终端同步，同一个用户允许同时登录多个UA', 1, 0, 1576856234);
INSERT INTO `knowledge_base` VALUES (8, 100, '如何新建一个应用', '|开始使用|创建应用|获取AppId|获取AppKey|获取AppSecret|', 'APP开发者访问小米开放平台（dev.mi.com）申请appId/appKey/appSecret。\n步骤：登录小米开放平台网页 -> ”管理控制台” -> ”小米应用商店” -> ”创建应用” -> 填入应用名和包名 -> ”创建” -> 记下看到的AppId/AppKey/AppSecret 。', 1, 1583475155, 1576856366);
INSERT INTO `knowledge_base` VALUES (9, 100, '名词解释', '|名词|术语|', 'App: 开发者开发之应用\nSDK: MIMC SDK\nappProxyService: 代理认证服务\nTokenService: 小米认证服务\nappId: 应用ID，小米开放平台申请分配\nappKey: 应用Key，小米开放平台申请分配\nappSec: 应用Sec，小米开放平台申请分配\nappAccount: 应用账号系统内用户账号ID，应用账号系统内唯一\ntoken: 小米认证服务(TokenService)下发Token', 1, 0, 1576856403);
INSERT INTO `knowledge_base` VALUES (10, 100, '小米消息云是否收费', '|是否收费|如何收费|免费吗|', '即时消息服务将会一直供大家免费使用，解除开发者后顾之忧\n即时消息云中的所有功能，我们都不做限制，免费供大家使用，包括但不限于：\n    发送消息数，注册用户数，多终端登录，创建群个数，群历史消息，实时/离线消息回调，推送消息数等\n当然，对于恶意使用者，我们仍然保留封禁的权利', 1, 0, 1576856463);
INSERT INTO `knowledge_base` VALUES (11, 100, '小米消息云适用哪些场景', '|信令|留言|群聊|单聊|在线客服|', '适用于一切基于长连接的信息传递场景，包括不限于：\n即时通讯：单聊/群聊/在线客服/等\n论坛：私信/留言等\nIoT：信令传递等\n其他：网页扫码登录等', 1, 0, 1576856516);
INSERT INTO `knowledge_base` VALUES (12, 100, '开发者工作', '|界面|消息体格式|', '1. 开发者需要自己实现聊天界面\n2. 开发者需要接入消息云安全认证\n3. 开发者需要自己定义消息体格式', 1, 0, 1576856552);
INSERT INTO `knowledge_base` VALUES (13, 100, '为什么不提供聊天界面', '|UI|风格|', '我们不提供统一的聊天UI，基于以下理由：\n1. APP都有自己的风格，万紫千红才是春，一套UI显然不能满足大家需求\n2. UI对于开发者而言，开发成本并不高\n3. 开发者自行开发UI，可100%自定义界面和功能\n所以，我们认为由开发者根据自己APP的风格来自定义UI比较合适', 1, 0, 1576856605);
INSERT INTO `knowledge_base` VALUES (14, 100, '为什么需要开发者自定义消息格式', '|消息格式|消息体|', '我们不提供统一的消息格式，而由开发者自定义消息格式，基于以下理由：\n\n1. APP所需消息功能各异，有的需要已读，有的则不需要已读功能，所以我们提供了推荐的消息格式， 由开发者根据自己情况定义最适合自己的消息格式\n\n2. MIMC(小米即时消息云)应用场景广泛，IM聊天只是MIMC的一个特殊使用场景，还存在IoT信令传递等各种消息传递场景\n所以，我们认为由开发者根据自己APP的实际需求，参考我们推荐的消息格式，来定义消息体格式比较合适', 1, 0, 1576856665);
INSERT INTO `knowledge_base` VALUES (15, 100, '什么开发者不需要维护帐号映射', '|用户登录|帐号映射|MIMC帐号|帐号|', 'MIMC用户登录/消息收发等都使用APP帐号系统里的账号ID，MIMC帐号体系对APP开发者透明！\n\nAPP开发者接入其他IM提供商时，要访问IM提供商服务，主动为每一个appAccount注册一个新的ID，\n开发者还需要在自己的后台系统储存以下信息：\n1. appAccount --> IM提供商系统内ID\n2. IM提供商系统内ID + IM提供商系统内登录密码(明文)\n这样做有以下弊端：\n1. 开发者维护帐号映射成本高，一旦出错难以修正\n2. 明文存储登录密码，安全性极差，开发者承担极高的安全风险\n\n所以，MIMC(小米即时消息云)没有采取以上方案，MIMC自维护帐号映射，保证MIMC ID对开发者透明\n这不仅降低了开发者负担，增强了帐号安全性，还能让开发者感觉MIMC就是\"自己的\"消息系统', 1, 0, 1576856698);
INSERT INTO `knowledge_base` VALUES (16, 100, 'APP在后台收不到消息如何处理', '|消息通知|APP推送|离线消息|', 'iOS平台下，APP进入后台时，进程代码执行会暂停，连接过一段时间后也会被关闭(当前Android也慢慢趋同于iOS)\n在APP后台运行被限制越来越严格的大背景下，如何让APP在后台运行时仍然可以\"收到\"消息呢？\n我们建议以下方案：\n1. 开发者开发线上服务OfflineMessageService，接收MIMC服务回调的离线消息\n2. OfflineMessageService将接收到的离线消息，通过小米推送将离线消息提醒下发到用户手机通知栏\n3. 用户点击手机通知栏提醒，APP被启动进入前台，MIMC会自动重连接收离线消息', 1, 0, 1576856789);
INSERT INTO `knowledge_base` VALUES (17, 100, '关于demo', '|demo|ui|', '关于UI组件\n目前MIMC的Demo UI 比较粗糙，仅作为功能演示使用，公共开源的通用UI组件正在开发过程中，小伙伴们暂时可通过其他方式自己处理设计UI。', 1, 0, 1576856816);
INSERT INTO `knowledge_base` VALUES (18, 100, '如何接入小米消息云', '|接入|如何使用|文档|', '1. 先确认DEMO是可用的\n2. 删除本地缓存目录\n3. 替换DEMO中appid/appkey/appsec为自用app信息\n4. 仔细阅读文档（不要偷懒不要省）\n5. 开始编写自己的业务代码', 1, 0, 1577019789);
INSERT INTO `knowledge_base` VALUES (19, 100, '收不到消息如何排查', '|排查|收不到|', '1. 删除本地缓存目录，尝试（appid修改后必须执行此操作）\n2. 检查发送方和接收方的appid是否一致（防止粗心大意导致不一致）\n3. 发送者和接收者确认都在线(onlineStatus回调打印日志)\n4. 发送者serverAck回调是否被执行\n5. 打印出接收者账号，确认接收者账号是不是正确（防止发给了错误的人）\n6. 接收端handleMessage回调是否被执行（在第一行添加日志，排除消息回调中业务逻辑bug导致消息不能正确显示）', 1, 0, 1577019831);
INSERT INTO `knowledge_base` VALUES (20, 100, 'mimc支持跨应用聊天吗', '|跨平台|多终端|', 'mimc支持跨应用聊天，实现两个不同的APP之间聊天，使用同一个appId/appKey/appSecret即可。', 1, 0, 1577019898);
INSERT INTO `knowledge_base` VALUES (21, 100, '服务端实现代理认证服务', '|认证|服务端|小米认证|代理认证|服务端认证|', '服务端实现代理认证服务(appProxyService)，顺序做以下事情：\n\n    1. 代理认证服务存储appKey/appSec等敏感数据\n       访问小米认证服务需要appKey/appSec等，这些数据非常敏感，\n       如果放在应用端代码中会非常容易泄露，而且一旦泄漏无法更新，\n       而存储在代理认证服务，则泄露风险很低，一旦泄露也可以快速更新。\n    2. 代理认证服务做账号合法性认证\n       代理认证服务需要保证登录的appAccount在其账号系统内是合法有效的\n    3. 调用小米认证服务(TokenService)\n       代理认证服务在保证用户合法以后，调用小米认证服务，\n       并将[小米认证服务下发的原始数据]适当封装后，返回给安全认证接口', 1, 0, 1577020039);
INSERT INTO `knowledge_base` VALUES (22, 100, '应用端实现安全认证接口', '|访问代理|应用端认证|客户端认证|', '应用端实现安全认证接口，做以下事情：\n\n    1. 访问代理认证服务(appProxyService)\n    2. 代理认证服务返回结果中解析[小米认证服务下发的原始数据]并返回\n注意：\n\n    访问代理认证服务(appProxyService)传入的appAccount，\n    必须与User构造函数传入的appAccount相同', 1, 0, 1577020078);
INSERT INTO `knowledge_base` VALUES (23, 100, '各语言平台SDK安全认证接口实现逻辑', '|安全认证|fetchToken|认证服务|Delegate|token|', 'Android:\nJava:\nC++:\n    实现MIMCTokenFetcher.fetchToken()，同步访问代理认证服务，\n    从代理认证服务返回结果中解析[小米认证服务下发的原始数据]并返回\nWebJS:\n    实现function fetchMIMCToken()，同步访问代理认证服务，\n    从代理认证服务返回结果中解析[小米认证服务下发的原始数据]并返回\nC#:\n    实现IMIMCTokenFetcher.fetchToken()，同步访问代理认证服务，\n    从代理认证服务返回结果中解析[小米认证服务下发的原始数据]并返回\niOS:\n    初始化NSMutableURLRequest，用于异步访问应用代理认证服务\n    实现parseTokenDelegate，从NSMutableURLRequest异步返回结果中\n    解析[小米认证服务下发的原始数据]并返回\nGO:\n    实现FetchToken() *string，同步访问代理认证服务，\n    从代理认证服务返回结果中解析[小米认证服务下发的原始数据]并返回', 1, 0, 1577020140);
INSERT INTO `knowledge_base` VALUES (24, 100, '推送api接口限流', '|推送|限流|', '为保证服务公平性和可用性，对服务开放的接口进行限流。限流策略如下：\n\n单聊消息------------>上限50 人·消息/秒\n普通聊消息--------->上限20 群·消息/秒\n无限群聊消息------->上限50 群·消息/秒\n\n推送有 qps限制现在只是服务保护，用户增长不够了可以通知我们调整', 1, 0, 1577020624);
INSERT INTO `knowledge_base` VALUES (25, 100, '消息回调', '|回调|保活|消息回调|', '消息回调功能可以帮助应用方完全掌控App使用情况，回调消息数据可用于数据挖掘、统计、监控、App保活等。', 1, 1584281777, 1577020988);
INSERT INTO `knowledge_base` VALUES (26, 100, '消息回调发送与失败重试', '|消息回调|回调|', '回调服务将App用户的即时消息和离线消息POST发给应用方，回调服务收到返回200状态码则表示接收成功\n用户发送的完整消息体base64编码后放置在payload字段中\n当消息回调失败时，系统会重试最多3次（5s后，30s后，5min后）', 1, 1584281774, 1577021059);
COMMIT;

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_account` bigint(20) NOT NULL DEFAULT '0',
  `to_account` bigint(20) NOT NULL DEFAULT '0',
  `biz_type` char(255) NOT NULL DEFAULT '',
  `version` char(255) NOT NULL DEFAULT '0',
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `timestamp` bigint(20) NOT NULL DEFAULT '0',
  `payload` longtext,
  `read` int(11) NOT NULL DEFAULT '1',
  `transfer_account` bigint(20) NOT NULL DEFAULT '0',
  `key` bigint(20) NOT NULL DEFAULT '0',
  `sequence` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for message_history
-- ----------------------------
DROP TABLE IF EXISTS `message_history`;
CREATE TABLE `message_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_account` bigint(20) NOT NULL DEFAULT '0',
  `to_account` bigint(20) NOT NULL DEFAULT '0',
  `biz_type` char(255) NOT NULL DEFAULT '',
  `version` char(255) NOT NULL DEFAULT '0',
  `timestamp` bigint(20) NOT NULL DEFAULT '0',
  `key` bigint(20) NOT NULL DEFAULT '0',
  `transfer_account` bigint(20) NOT NULL DEFAULT '0',
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `payload` longtext,
  `read` int(11) NOT NULL DEFAULT '0',
  `sequence` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for platform
-- ----------------------------
DROP TABLE IF EXISTS `platform`;
CREATE TABLE `platform` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` char(255) NOT NULL DEFAULT '',
  `alias` char(255) NOT NULL DEFAULT '',
  `system` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

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
  `bucket` char(255) NOT NULL DEFAULT '',
  `access_key` char(255) NOT NULL DEFAULT '',
  `secret_key` char(255) NOT NULL DEFAULT '',
  `host` char(255) NOT NULL DEFAULT '',
  `update_at` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qiniu_setting
-- ----------------------------
BEGIN;
INSERT INTO `qiniu_setting` VALUES (1, 'bucket', 'access_key', 'secret_key', 'https://upload.qiniup.com', 1583581996);
COMMIT;

-- ----------------------------
-- Table structure for robot
-- ----------------------------
DROP TABLE IF EXISTS `robot`;
CREATE TABLE `robot` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nickname` char(255) NOT NULL DEFAULT '',
  `avatar` char(255) NOT NULL DEFAULT '',
  `welcome` varchar(255) NOT NULL DEFAULT '',
  `understand` varchar(255) NOT NULL DEFAULT '',
  `artificial` varchar(255) NOT NULL DEFAULT '',
  `switch` int(11) NOT NULL DEFAULT '0',
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) DEFAULT NULL,
  `system` int(11) NOT NULL DEFAULT '1',
  `keyword` varchar(255) NOT NULL DEFAULT '',
  `timeout_text` varchar(255) NOT NULL DEFAULT '',
  `no_services` varchar(255) NOT NULL DEFAULT '',
  `loog_time_wait_text` varchar(255) NOT NULL DEFAULT '',
  `delete` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of robot
-- ----------------------------
BEGIN;
INSERT INTO `robot` VALUES (1, 'MIMC机器人助理', 'http://qiniu.cmp520.com/4473448454302935.jpg', '您好，我是MIMC机器人助理，很高兴为您服务，您可以问我一些关于MIMC的相关问题，如需接入在线客服，请回复“人工”。', '我还不理解您的意思呢，换个其他问题看看.', '|转人工|在线客服|找人工|人工服务|我要找人工|人工客服|', 1, 1, 1580974855, 1564626187, 1, '|收费|使用|跨平台|排查|安全认证|ui|消息体|支持|通知|token|回调|跨应用|消息云|SDK|安全认证|限流|认证|代理|跨应用|排查|多终端|接入|文档|demo|收不到消息|离线消息|帐号|消息|界面|适用|免费吗|如何收费|名词|术语|新建|开始使用|在线文档|支持|mimc|离线消息|', '由于您长时间未回复，系统结束了本次会话，如您还有其他问题，请重新发起会话，感谢您的支持', '当前没有值班MM哦，我们的MM值班时间为周一至周五 9:00 - 18:00 您可以在此时间段进行咨询，感谢您的支持', '很抱歉呢，由于目前咨询人数过多，请耐心等待一会哦', 0);
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
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `nickname` char(255) DEFAULT NULL,
  `is_reply` int(11) DEFAULT '0',
  `satisfaction` int(11) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `is_reception` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shortcut
-- ----------------------------
DROP TABLE IF EXISTS `shortcut`;
CREATE TABLE `shortcut` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `content` longtext,
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `title` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shortcut
-- ----------------------------
BEGIN;
INSERT INTO `shortcut` VALUES (2, 101, '5L2g5aW977yM5pyJ5ZCI6YCC5ZGi5LmI5Y+v5Lul5biu5Yiw5oKo', 0, 1578743157, '5L2g5aW977yM5pyJ5ZCI6YCC5ZGi5LmI5Y+v5Lul5biu5Yiw5oKo');
INSERT INTO `shortcut` VALUES (3, 101, '5piv55qEbWlt5pyA54mb6YC8', 0, 1578743179, '5piv55qEbWlt5pyA54mb6YC8');
INSERT INTO `shortcut` VALUES (4, 100, '5oKo5aW977yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo77yf', 0, 1578830825, '5oKo5aW9');
INSERT INTO `shortcut` VALUES (5, 100, '5aW955qE77yM6K+356iN562J54mH5Yi777yM5q2j5Zyo5Li65oKo5p+l6K+i55u45YWz6Zeu6aKY', 0, 1578830870, '5aW955qE77yM6K+356iN562J54mH5Yi7');
INSERT INTO `shortcut` VALUES (6, 100, '5b6I6auY5YW06IO95Li65oKo5pyN5Yqh77yM6K+357uZ5oiR5pyN5Yqh6K+E5YiG77yM6LCi6LCi', 0, 1578830908, '5pyN5Yqh6K+E5YiG6K+35rGC');
INSERT INTO `shortcut` VALUES (7, 100, '5YaN6KeB77yM5qyi6L+O5LiL5qyh5YWJ5Li0', 0, 1578831007, '5YaN6KeB');
INSERT INTO `shortcut` VALUES (8, 100, '5oKo5piv6YGH5Yiw5LuA5LmI6Zeu6aKY5LqG5ZCX77yf6K+3566A5Y2V5o+P6L+w5oKo55qE6Zeu6aKY5oKo5piv6YGH5Yiw5LuA5LmI6Zeu6aKY5LqG5ZCX77yf6K+3566A5Y2V5o+P6L+w5oKo55qE6Zeu6aKY5oKo5piv6YGH5Yiw5LuA5LmI6Zeu6aKY5LqG5ZCX77yf6K+3566A5Y2V5o+P6L+w5oKo55qE6Zeu6aKY5oKo5piv6YGH5Yiw5LuA5LmI6Zeu6aKY5LqG5ZCX77yf6K+3566A5Y2V5o+P6L+w5oKo55qE6Zeu6aKY', 0, 1578831054, '6YGH5Yiw5LuA5LmI6Zeu6aKY77yf');
INSERT INTO `shortcut` VALUES (10, 100, '6L+Y5Lul5Li6', 0, 1580869073, '5aW95ZCn');
INSERT INTO `shortcut` VALUES (11, 100, '5bm/5bee', 0, 1580869078, '5L+h5oGv');
INSERT INTO `shortcut` VALUES (12, 100, '6ay86LC35a2Q', 0, 1580869083, '5L2g6L+Y5Y+v5Lul');
INSERT INTO `shortcut` VALUES (13, 100, '5YWz5rOo5LiA5LiL', 0, 1580869087, '5LiqMOS4qjbnrKzlhavljLo=');
INSERT INTO `shortcut` VALUES (14, 100, '5b2x5a2Q546w5Zyo', 0, 1580869092, '6aKc6Imy5a625bqt');
INSERT INTO `shortcut` VALUES (15, 100, '5YWz5rOo5LiA5LiL', 0, 1580869096, '6LCi6LCi5YWz5rOo5oiR');
INSERT INTO `shortcut` VALUES (16, 100, '5ZC85ZC85ZC8', 0, 1580869101, '5pyJ44CC6Imy5om+5LuW');
INSERT INTO `shortcut` VALUES (17, 100, '5ZC85ZC85ZC8', 0, 1580869106, '6L+Z5Lqb5aSp5L2g5Lul5Li6');
INSERT INTO `shortcut` VALUES (18, 101, '5b2i5L2T5Zi75Zi75Zi75Zi75Zi7', 0, 1580958803, '54mb6YC85p2R6Iqx');
INSERT INTO `shortcut` VALUES (19, 100, '5oKo5aW9KOKKmW/iipkp5ZOH77yM5Zac5qyi5pys57O757uf55qE57uZ5oiR5Liqc3RhcuWZou+8jOiwouiwon4=', 1583660671, 1581152254, '5oKo5aW9KOKKmW/iipkp5ZOH');
INSERT INTO `shortcut` VALUES (21, 102, 'YWFhYWFhYWFhYWFh', 0, 1583826536, 'YQ==');
COMMIT;

-- ----------------------------
-- Table structure for system
-- ----------------------------
DROP TABLE IF EXISTS `system`;
CREATE TABLE `system` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` char(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `logo` char(255) NOT NULL DEFAULT '',
  `copy_right` varchar(255) NOT NULL DEFAULT '',
  `upload_mode` int(11) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `open_workorder` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of system
-- ----------------------------
BEGIN;
INSERT INTO `system` VALUES (1, '客服系统-工作台', 'http://kf.aissz.com:666/static/uploads/images/1580880580547289_scaled_13-28-01-1895426542557186.png', '©2019-2029 Macromedia, Inc. All rights reserved.', 1, 1585378497, 1);
COMMIT;

-- ----------------------------
-- Table structure for uploads_config
-- ----------------------------
DROP TABLE IF EXISTS `uploads_config`;
CREATE TABLE `uploads_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` char(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

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
  `avatar` char(255) DEFAULT NULL,
  `address` char(255) DEFAULT NULL,
  `nickname` char(255) DEFAULT NULL,
  `token` longtext,
  `user_token` longtext,
  `phone` char(255) DEFAULT NULL,
  `platform` bigint(20) NOT NULL DEFAULT '0',
  `online` int(11) NOT NULL DEFAULT '0',
  `is_window` int(11) NOT NULL DEFAULT '0',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `remarks` char(255) DEFAULT NULL,
  `last_activity` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `remote_addr` char(255) DEFAULT NULL,
  `is_service` int(11) NOT NULL DEFAULT '0',
  `is_workorder` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for work_order
-- ----------------------------
DROP TABLE IF EXISTS `work_order`;
CREATE TABLE `work_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `last_reply` bigint(20) NOT NULL DEFAULT '0',
  `phone` char(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `close_at` bigint(20) NOT NULL DEFAULT '0',
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `content` longtext NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `update_at` bigint(20) NOT NULL DEFAULT '0',
  `delete` int(11) NOT NULL DEFAULT '0',
  `remark` varchar(255) NOT NULL DEFAULT '',
  `cid` bigint(20) NOT NULL DEFAULT '0',
  `tid` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for work_order_comment
-- ----------------------------
DROP TABLE IF EXISTS `work_order_comment`;
CREATE TABLE `work_order_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `wid` bigint(20) NOT NULL DEFAULT '0',
  `content` longtext,
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `aid` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for work_order_type
-- ----------------------------
DROP TABLE IF EXISTS `work_order_type`;
CREATE TABLE `work_order_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `create_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of work_order_type
-- ----------------------------
BEGIN;
INSERT INTO `work_order_type` VALUES (5, '综合问题', 1584623917);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
