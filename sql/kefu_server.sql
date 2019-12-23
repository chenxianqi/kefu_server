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

 Date: 23/12/2019 21:04:54
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
INSERT INTO `admin` VALUES (100, 'http://kf.aissz.com:666/static/uploads/images/10595706961116000.jpg', 'keith', 'Keith', 'da13dd1612637af2a8d3103e4279b2ea', '13800138000', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAwLCJhdmF0YXIiOiJodHRwOi8va2YuYWlzc3ouY29tOjY2Ni9zdGF0aWMvdXBsb2Fkcy9pbWFnZXMvMTA1OTU3MDY5NjExMTYwMDAuanBnIiwidXNlcm5hbWUiOiJrZWl0aCIsIm5pY2tuYW1lIjoiS2VpdGgiLCJwYXNzd29yZCI6IiIsInBob25lIjoiMTM4MDAxMzgwMDAiLCJ0b2tlbiI6IiIsImF1dG9fcmVwbHkiOiLmgqjlpb3vvIzmiJHmmK_lnKjnur_lrqLmnI1LZWl0aCzlt6Xlj7cxMDDvvIzmnInku4DkuYjlj6_ku6XluK7liLDmgqjlkaLvvJ8iLCJvbmxpbmUiOjAsInJvb3QiOjEsImN1cnJlbnRfY29uX3VzZXIiOjAsImxhc3RfYWN0aXZpdHkiOjE1NzcwOTU2NjksInVwZGF0ZV9hdCI6MTU3Njc2MjkyNSwiY3JlYXRlX2F0IjoxNTYzMTE4NjMwLCJleHAiOjE1NzczNjM5NTYsImlhdCI6MTU3NzEwNDc1NiwiaXNzIjoia2VpdGgifQ.kX8fwytC3O0zePiwM0eWBtBjxr0BAAJ0vbs61WqW5A8', '您好，我是在线客服Keith,工号100，有什么可以帮到您呢？', 1, 1, 10114, 1577106278, 1577104813, 1563118630);
INSERT INTO `admin` VALUES (101, 'http://qiniu.cmp520.com/3971858868282022.jpg', 'test1', '小敏', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服小敏,工号101，有什么可以帮到您呢？', 0, 0, 0, 1577095255, 1577095272, 1567564796);
INSERT INTO `admin` VALUES (102, 'http://qiniu.cmp520.com/4097459283995998.jpeg', 'test2', '草草', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服草草，工号102，有什么可以帮到您呢？', 0, 0, 0, 1577095282, 1577095289, 1569209832);
INSERT INTO `admin` VALUES (103, 'http://qiniu.cmp520.com/1845329999348814.jpeg', 'test3', '小文', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服小文，工号103，有什么可以帮到您呢？', 0, 0, 0, 1577095315, 1577095312, 1569209862);
INSERT INTO `admin` VALUES (104, 'http://qiniu.cmp520.com/11538885325704032.jpeg', 'test4', 'lucky', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服lucky，工号104，有什么可以帮到您呢？', 0, 0, 0, 1577095335, 1577095334, 1569209969);
INSERT INTO `admin` VALUES (105, 'http://qiniu.cmp520.com/9195327141090814.jpg', 'test5', '雯雯', '2569d419bfea999ff13fd1f7f4498b89', '13800138000', '', '您好，我是在线客服雯雯，工号105，有什么可以帮到您呢？', 0, 0, 0, 1577095352, 1577095351, 1571016120);
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
) ENGINE=InnoDB AUTO_INCREMENT=15777 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of contact
-- ----------------------------
BEGIN;
INSERT INTO `contact` VALUES (15766, 10005, 100, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1576684440, 1, 1);
INSERT INTO `contact` VALUES (15767, 10006, 100, '', 'end', 1576852655, 1, 1);
INSERT INTO `contact` VALUES (15768, 10007, 100, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1577023860, 1, 0);
INSERT INTO `contact` VALUES (15769, 10010, 100, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1577028120, 1, 0);
INSERT INTO `contact` VALUES (15770, 10021, 101, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1577028480, 1, 0);
INSERT INTO `contact` VALUES (15771, 10081, 100, '', 'end', 1577084153, 1, 0);
INSERT INTO `contact` VALUES (15772, 10084, 100, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1577084280, 1, 0);
INSERT INTO `contact` VALUES (15773, 10082, 100, '', 'end', 1577083821, 1, 0);
INSERT INTO `contact` VALUES (15774, 10086, 100, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1577084760, 1, 0);
INSERT INTO `contact` VALUES (15775, 10090, 100, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1577085900, 1, 0);
INSERT INTO `contact` VALUES (15776, 10114, 100, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 'timeout', 1577106060, 1, 0);
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

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
INSERT INTO `knowledge_base` VALUES (8, 100, '如何新建一个应用', '|开始使用|创建应用|获取AppId|获取AppKey|获取AppSecret|', 'APP开发者访问小米开放平台（dev.mi.com）申请appId/appKey/appSecret。\n步骤：登录小米开放平台网页 -> ”管理控制台” -> ”小米应用商店” -> ”创建应用” -> 填入应用名和包名 -> ”创建” -> 记下看到的AppId/AppKey/AppSecret 。', 1, 0, 1576856366);
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
INSERT INTO `knowledge_base` VALUES (25, 100, '消息回调', '|回调|保活|消息回调|', '消息回调功能可以帮助应用方完全掌控App使用情况，回调消息数据可用于数据挖掘、统计、监控、App保活等。', 1, 0, 1577020988);
INSERT INTO `knowledge_base` VALUES (26, 100, '消息回调发送与失败重试', '|消息回调|回调|', '回调服务将App用户的即时消息和离线消息POST发给应用方，回调服务收到返回200状态码则表示接收成功\n用户发送的完整消息体base64编码后放置在payload字段中\n当消息回调失败时，系统会重试最多3次（5s后，30s后，5min后）', 1, 0, 1577021059);
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=310467 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of message
-- ----------------------------
BEGIN;
INSERT INTO `message` VALUES (310031, 10005, 1000000000, 'text', '0', 5, 1576683891, '5Lq65bel', 0, 0, 0, 1576683891861);
INSERT INTO `message` VALUES (310032, 10005, 100, 'transfer', '', 0, 1576683892, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310033, 1000000000, 10005, 'transfer', '', 0, 1576683892, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL3Fpbml1LmNtcDUyMC5jb20vMTE0NDU4MzA4NjA0MDg2ODYuanBlZyJ9', 1, 100, 1, 0);
INSERT INTO `message` VALUES (310034, 100, 10005, 'text', '0', 0, 1576683893, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 1, 0, 0, 1576683893099);
INSERT INTO `message` VALUES (310035, 10005, 100, 'text', '0', 5, 1576683896, 'MTE=', 0, 0, 0, 1576683896003);
INSERT INTO `message` VALUES (310036, 10005, 100, 'text', '0', 5, 1576683933, 'MQ==', 0, 0, 0, 1576683933215);
INSERT INTO `message` VALUES (310037, 10006, 100, 'end', '0', 5, 1576683952, '', 0, 0, 0, 1576683952702);
INSERT INTO `message` VALUES (310038, 10006, 1000000000, 'text', '0', 5, 1576683955, '5Lq65bel', 0, 0, 0, 1576683955562);
INSERT INTO `message` VALUES (310039, 10006, 100, 'transfer', '', 0, 1576683956, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310040, 1000000000, 10006, 'transfer', '', 0, 1576683956, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL3Fpbml1LmNtcDUyMC5jb20vMTE0NDU4MzA4NjA0MDg2ODYuanBlZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310041, 100, 10006, 'text', '0', 0, 1576683957, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1576683957144);
INSERT INTO `message` VALUES (310042, 10006, 100, 'text', '0', 5, 1576683959, 'MQ==', 0, 0, 0, 1576683959657);
INSERT INTO `message` VALUES (310043, 10006, 100, 'text', '0', 5, 1576683984, 'MQ==', 0, 0, 0, 1576683984385);
INSERT INTO `message` VALUES (310044, 10006, 100, 'text', '0', 5, 1576683986, 'Mg==', 0, 0, 0, 1576683985940);
INSERT INTO `message` VALUES (310045, 10006, 100, 'text', '0', 5, 1576683987, 'Mw==', 0, 0, 0, 1576683987265);
INSERT INTO `message` VALUES (310046, 10006, 100, 'text', '0', 5, 1576683990, 'MQ==', 0, 0, 0, 1576683990174);
INSERT INTO `message` VALUES (310047, 10006, 100, 'text', '0', 5, 1576683992, 'Mg==', 0, 0, 0, 1576683992417);
INSERT INTO `message` VALUES (310048, 10006, 100, 'text', '0', 5, 1576683993, 'MQ==', 0, 0, 0, 1576683993486);
INSERT INTO `message` VALUES (310049, 10006, 100, 'text', '0', 5, 1576683994, 'Mg==', 0, 0, 0, 1576683994662);
INSERT INTO `message` VALUES (310050, 10006, 100, 'text', '0', 5, 1576683996, 'Mw==', 0, 0, 0, 1576683996473);
INSERT INTO `message` VALUES (310051, 10006, 100, 'text', '0', 5, 1576683999, 'MzI0', 0, 0, 0, 1576683999770);
INSERT INTO `message` VALUES (310052, 10006, 100, 'text', '0', 5, 1576684001, 'MjM0MjM=', 0, 0, 0, 1576684001441);
INSERT INTO `message` VALUES (310053, 10006, 100, 'text', '0', 5, 1576684005, 'NDIzNDIzNA==', 0, 0, 0, 1576684005808);
INSERT INTO `message` VALUES (310054, 10006, 100, 'text', '0', 5, 1576684036, 'MQ==', 0, 0, 0, 1576684036489);
INSERT INTO `message` VALUES (310055, 10005, 100, 'timeout', '', 0, 1576684440, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310056, 10006, 100, 'timeout', '', 0, 1576684560, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310057, 10006, 1000000000, 'text', '0', 5, 1576761871, '5Lq65bel', 0, 0, 0, 1576761871004);
INSERT INTO `message` VALUES (310058, 10006, 100, 'transfer', '', 0, 1576761871, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310059, 1000000000, 10006, 'transfer', '', 0, 1576761871, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL3Fpbml1LmNtcDUyMC5jb20vMTE0NDU4MzA4NjA0MDg2ODYuanBlZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310060, 100, 10006, 'text', '0', 0, 1576761873, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1576761873697);
INSERT INTO `message` VALUES (310061, 100, 10006, 'text', '0', 0, 1576761878, 'MTI=', 0, 0, 0, 1576761878428);
INSERT INTO `message` VALUES (310062, 10006, 100, 'text', '0', 5, 1576762021, 'MTI=', 0, 0, 0, 1576762021759);
INSERT INTO `message` VALUES (310063, 10006, 100, 'text', '0', 5, 1576762151, 'MTI=', 0, 0, 0, 1576762151655);
INSERT INTO `message` VALUES (310064, 10006, 100, 'timeout', '', 0, 1576762680, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310065, 10006, 1, 'text', '0', 5, 1576851574, '5Lq65bel', 0, 0, 0, 1576851574140);
INSERT INTO `message` VALUES (310066, 1, 10006, 'text', '', 0, 1576851574, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310067, 10006, 1, 'text', '0', 5, 1576851584, '5Lq65bel', 0, 0, 0, 1576851584242);
INSERT INTO `message` VALUES (310068, 10006, 100, 'transfer', '', 0, 1576851584, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310069, 1, 10006, 'transfer', '', 0, 1576851584, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3N0YXRpYy91cGxvYWRzL2ltYWdlcy8xMDU5NTcwNjk2MTExNjAwMC5qcGcifQ==', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310070, 100, 10006, 'text', '0', 0, 1576851585, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1576851585867);
INSERT INTO `message` VALUES (310071, 10006, 100, 'timeout', '', 0, 1576852080, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310072, 10006, 1, 'text', '0', 5, 1576852313, 'aHR0cHM6Ly9naXRodWIuY29tL2NoZW54aWFucWkva2VmdV9zZXJ2ZXI=', 0, 0, 0, 1576852313005);
INSERT INTO `message` VALUES (310073, 1, 10006, 'text', '', 0, 1576852313, '5oiR6L+Y5LiN55CG6Kej5oKo55qE5oSP5oCd5ZGi77yM5o2i5Liq5YW25LuW6Zeu6aKY55yL55yLLg==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310074, 10006, 1, 'text', '0', 5, 1576852351, '5Lq65bel', 0, 0, 0, 1576852351511);
INSERT INTO `message` VALUES (310075, 10006, 100, 'transfer', '', 0, 1576852352, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310076, 1, 10006, 'transfer', '', 0, 1576852352, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3N0YXRpYy91cGxvYWRzL2ltYWdlcy8xMDU5NTcwNjk2MTExNjAwMC5qcGcifQ==', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310077, 100, 10006, 'text', '0', 0, 1576852353, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1576852353238);
INSERT INTO `message` VALUES (310078, 10006, 100, 'text', '0', 5, 1576852366, 'MTI=', 0, 0, 0, 1576852366821);
INSERT INTO `message` VALUES (310079, 10006, 100, 'end', '0', 5, 1576852655, '', 0, 0, 0, 1576852655482);
INSERT INTO `message` VALUES (310080, 10007, 1, 'text', '0', 5, 1576852672, '5Lq65bel', 0, 0, 0, 1576852671864);
INSERT INTO `message` VALUES (310081, 10007, 100, 'transfer', '', 0, 1576852672, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310082, 1, 10007, 'transfer', '', 0, 1576852672, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3N0YXRpYy91cGxvYWRzL2ltYWdlcy8xMDU5NTcwNjk2MTExNjAwMC5qcGcifQ==', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310083, 100, 10007, 'text', '0', 0, 1576852673, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1576852673097);
INSERT INTO `message` VALUES (310084, 10007, 100, 'timeout', '', 0, 1576853160, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310085, 10007, 1, 'text', '0', 5, 1576854972, 'Z2l0', 0, 0, 0, 1576854972489);
INSERT INTO `message` VALUES (310086, 1, 10007, 'knowledge', '', 0, 1576854972, 'W3sidGl0bGUiOiLmnKzpobnnm65naXRodWLlnLDlnYAifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310087, 10007, 1, 'text', '0', 5, 1576854975, '5pys6aG555uuZ2l0aHVi5Zyw5Z2A', 0, 0, 0, 1576854975329);
INSERT INTO `message` VALUES (310088, 1, 10007, 'text', '', 0, 1576854975, 'aHR0cHM6Ly9naXRodWIuY29tL2NoZW54aWFucWkva2VmdV9zZXJ2ZXI=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310089, 10007, 1, 'text', '0', 5, 1576854983, '5Lq65bel', 0, 0, 0, 1576854983172);
INSERT INTO `message` VALUES (310090, 10007, 100, 'transfer', '', 0, 1576854983, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310091, 1, 10007, 'transfer', '', 0, 1576854983, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3N0YXRpYy91cGxvYWRzL2ltYWdlcy8xMDU5NTcwNjk2MTExNjAwMC5qcGcifQ==', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310092, 100, 10007, 'text', '0', 0, 1576854984, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1576854984843);
INSERT INTO `message` VALUES (310093, 10007, 100, 'text', '0', 5, 1576855026, 'MTExMTExYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYQ==', 0, 0, 0, 1576855026196);
INSERT INTO `message` VALUES (310094, 10007, 100, 'text', '0', 5, 1576855033, 'c2RmZ2RzZmdzZGZnc2RmZ3NkZmdzZGY=', 0, 0, 0, 1576855032979);
INSERT INTO `message` VALUES (310095, 10007, 100, 'text', '0', 5, 1576855039, 'aWQiOjEwMDA3LCJ1aWQiOjAsImF2YXRhciI6IiIsImFkZHJlc3MiOiIiLCJuaWNrbmFtZSI6Iuiuv+WuojEwMDA3IiwidG9rZW4iOiIiLCJwaG9uZSI6IiIsInBsYXRmb3JtIjo1LCJvbmxpbmUiOjEsImlzX3dpbmRvdyI6MCwidXBkYXRlX2F0IjowLCJyZW1hcmtzIjoiIiwibGFzdF9hY3Rpdml0eSI6MTU3Njg1MjY2OCwiY3JlYXRlX2F0IjoxNTc2ODUyNjY4', 0, 0, 0, 1576855039151);
INSERT INTO `message` VALUES (310096, 100, 10007, 'text', '0', 0, 1576855233, 'MTExMTExYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYSAxMTExMTFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhIDExMTExMWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWEgMTExMTExYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYSAx', 0, 0, 0, 1576855233570);
INSERT INTO `message` VALUES (310097, 100, 10007, 'text', '0', 0, 1576855247, 'MTAwMDciLCJ0b2tlbiI6IiIsInBob25lIjoiIiwicGxhdGZvcm0iOjUsIm9ubGluZSI6MSwiaXNfd2luZG93IjowLCJ1cGRhdGVfYXQiOjAsInJlbWFya3MiOiIiLCJsYXN0X2FjdGl2aXR5IjoxNTc2ODUyNjY4LCJjcmVhdGVfYXQiOjE1NzY4NTI2NjgxMDAwNyIsInRva2VuIjoiIiwicGhvbmUiOiIiLCJwbGF0Zm9ybSI6NSwib25saW5lIjoxLCJpc18=', 0, 0, 0, 1576855246798);
INSERT INTO `message` VALUES (310098, 100, 10007, 'text', '0', 0, 1576855255, 'MTAwMDciLCJ0b2tlbiI6IiIsInBob25lIjoiIiwicGxhdGZvcm0iOjUsIm9ubGluZSI6MSwiaXNfd2luZG93IjowLCJ1cGRhdGVfYXQiOjAsInJlbWFya3MiOiIiLCJsYXN0X2FjdGl2aXR5IjoxNTc2ODUyNjY4LCJjcmVhdGVfYXQiOjE1NzY4NTI2Njg=', 0, 0, 0, 1576855255181);
INSERT INTO `message` VALUES (310099, 10007, 100, 'text', '0', 5, 1576855726, '5bCP57Gz5raI5oGv5LqR5L2/55So5Zy65pmv', 0, 0, 0, 1576855726446);
INSERT INTO `message` VALUES (310100, 10007, 100, 'end', '0', 5, 1576855736, '', 0, 0, 0, 1576855736470);
INSERT INTO `message` VALUES (310101, 10007, 1, 'text', '0', 5, 1576855738, '5bCP57Gz5raI5oGv5LqR5L2/55So5Zy65pmv', 0, 0, 0, 1576855738486);
INSERT INTO `message` VALUES (310102, 1, 10007, 'text', '', 0, 1576855738, 'MS4g5a6e546w5Z+656GA6IGK5aSp5Yqf6IO9Cue9kemhteOAgWFwcOWGheetieW8leeUqOWcuuaZr+S4i+i9u+advuWunueOsOWfuuehgOiBiuWkqeWKn+iDve+8jOWMheaLrOWNleiBiuOAgee+pOiBiuOAgeiBiuWkqeWupOetie+8jOaXoOiuuuS9oOaYr+ekvuS6pGFwcOWNleiBiu+8jOi/mOaYr+a4uOaIj+WGheeOqeWutuWFrOS8muiBiuWkqeaOpeWFpU1JTUPpg73lj6/ku6Xovbvmnb7lrp7njrDjgIIKMi4g5a6e546w5Zyo57q/5a6i5pyN5Yqf6IO9CuWIqeeUqE1JTUPnmoTkuIDlr7nkuIDogYrlpKnpgJrpgZPlrp7njrDlnKjnur/lrqLmnI3nmoTkuJrliqHpgLvovpHlip/og73jgIIKMy4g5a6e546w57O757uf5raI5oGv5Yqf6IO9CuWIqeeUqE1JTUPnmoTmtojmga/kuIvlj5Hlip/og73lrp7njrDns7vnu5/mtojmga/nmoTmjqjpgIHjgIIKNC4g5a6e546w5Zyo57q/55u05pKt562J5YW25LuW5Yqf6IO9Ck1JTUPnmoTngbXmtLvmmJPmianlsZXnmoTmtojmga/nsbvlnovmlrnkvr/lrp7njrDnsbvkvLznm7Tmkq3nrYnlhbbku5blkITnp43kuI3lkIznsbvlnovnmoTmtojmga/nmoTkvKDpgIHjgII=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310103, 10007, 1, 'text', '0', 5, 1576855870, '5a6M5YWo5YWN6LS5', 0, 0, 0, 1576855870242);
INSERT INTO `message` VALUES (310104, 1, 10007, 'knowledge', '', 0, 1576855870, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupHmnInku4DkuYjkvJjlir/lkaIifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310105, 10007, 1, 'text', '0', 5, 1576855875, '5bCP57Gz5raI5oGv5LqR5pyJ5LuA5LmI5LyY5Yq/5ZGi', 0, 0, 0, 1576855875566);
INSERT INTO `message` VALUES (310106, 1, 10007, 'text', '', 0, 1576855875, '5a6M5YWo5YWN6LS5IOa1t+mHj+W5tuWPkSDmtojmga/lv4Xovr4g5raI5oGv5ryr5ri4IOWFqOeQg+aOpeWFpSDpm7bmiJDmnKzmjqXlhaUg5YWo5bmz5Y+w5pSv5oyBCjHjgIFBUFDmlrnotKblj7fkvZPns7vlroznvo7lpZHlkIgg55uu5YmN5biC5Zy65LiK55qE5raI5oGv5LqR77yMQVBQ5byA5Y+R6ICF6ZyA6KaB6aKd5aSW55Sz6K+35LiA5aWX5p+Q5L+h6LSm5Y+377yM5bm25Zyo5pyN5Yqh56uv5piO5paH5a2Y5YKo5p+Q5L+h6LSm5Y+3L+Wvhuegge+8jOe7tOaKpOaIkOacrOmrmOaYgu+8jOWuieWFqOmjjumZqeaegemrmOOAgiDlpoLmnpzmjqXlhaVNSU1D77yMQVBQ5byA5Y+R6ICF5Lid5q+r5oSf55+l5LiN5YiwTUlNQ+i0puWPt+S9k+ezu++8jOaJgOacieaUtuWPkemDveaYr+eUqEFQUOi0puWPt++8jOaXoOe8neWlkeWQiO+8jOWuieWFqOaAp+mrmOOAggoKMuOAgemAgueUqOWcuuaZr+W5v+azmyDnm67liY3luILlnLrkuIrnmoTmtojmga/kupHvvIzlpKfpg73lj6rog73pgILnlKjkuo7ogYrlpKnlnLrmma/vvIzlhbbku5bmtojmga/lnLrmma/kuI3og73mlK/mjIHjgIJNSU1D5YiZ5Y+v5Lul5pSv5oyB5pm66IO956Gs5Lu25L+h5LukL+iBiuWkqS/lrqLmnI0v5o6o6YCB562J5Lu75L2V5raI5oGv5Lyg6YCS5Zy65pmv44CCCgoz44CB5YWo5bmz5Y+w5pSv5oyBIEFuZHJvaWQvaU9TL1dlYi9DL0MjL0phdmEvR2/nrYnlhajlubPlj7Av5aSa6K+t6KiA5pSv5oyB77yM5LiA5pyf5pSv5oyBQW5kcm9pZC9pT1MvV2Vi5LiJ5bmz5Y+w77yM5ZCO57ut5Lya5qC55o2u55So5oi36ZyA6KaB5pSv5oyB5pu05aSa5bmz5Y+wL+ivreiogAoKNOOAgea2iOaBr+agvOW8jzEwMCXoh6rlrprkuYnpq5jngbXmtLvluqYg55uu5YmN5biC5Zy65LiK55qE5raI5oGv5LqR5aSn6YO96IGK5aSp5YaF5a65L+agvOW8j+iHquWumuS5ieeoi+W6puS9ju+8jOaJqeWxleaAp+W3ruOAgk1JTUPkuI3lr7nmtojmga/lhoXlrrkv5qC85byP6L+b6KGM6ZmQ5Yi277yMQVBQ5Y+v5qC55o2u6Ieq5bex6ZyA5rGC77yM54G15rS75a6a5Yi25raI5oGv5qC85byP77yM5Lyg6YCS5pu05aWR5ZCIQVBQ6Ieq6Lqr6ZyA5rGC55qE5pWw5o2u44CCCgo144CB5p6B566AQVBJ6K6+6K6hIOWfuuS6juWFqOaWsOeahGFwaeiuvuiuoeWkp+Wkp+eugOWMluS6hmFwcOW8gOWPkeiAheeahOaOpeWFpeaIkOacrO+8jDPliIbpkp/ljbPlj6/lrp7njrDogYrlpKnlip/og73jgII=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310107, 10007, 1, 'text', '0', 5, 1576855926, '5rW36YeP5bm25Y+R', 0, 0, 0, 1576855926399);
INSERT INTO `message` VALUES (310108, 1, 10007, 'knowledge', '', 0, 1576855926, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupHmnInku4DkuYjkvJjlir/lkaIifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310109, 10007, 1, 'text', '0', 5, 1576855928, '5bCP57Gz5raI5oGv5LqR5pyJ5LuA5LmI5LyY5Yq/5ZGi', 0, 0, 0, 1576855928484);
INSERT INTO `message` VALUES (310110, 1, 10007, 'text', '', 0, 1576855928, '5a6M5YWo5YWN6LS5IOa1t+mHj+W5tuWPkSDmtojmga/lv4Xovr4g5raI5oGv5ryr5ri4IOWFqOeQg+aOpeWFpSDpm7bmiJDmnKzmjqXlhaUg5YWo5bmz5Y+w5pSv5oyBCjHjgIFBUFDmlrnotKblj7fkvZPns7vlroznvo7lpZHlkIgg55uu5YmN5biC5Zy65LiK55qE5raI5oGv5LqR77yMQVBQ5byA5Y+R6ICF6ZyA6KaB6aKd5aSW55Sz6K+35LiA5aWX5p+Q5L+h6LSm5Y+377yM5bm25Zyo5pyN5Yqh56uv5piO5paH5a2Y5YKo5p+Q5L+h6LSm5Y+3L+Wvhuegge+8jOe7tOaKpOaIkOacrOmrmOaYgu+8jOWuieWFqOmjjumZqeaegemrmOOAgiDlpoLmnpzmjqXlhaVNSU1D77yMQVBQ5byA5Y+R6ICF5Lid5q+r5oSf55+l5LiN5YiwTUlNQ+i0puWPt+S9k+ezu++8jOaJgOacieaUtuWPkemDveaYr+eUqEFQUOi0puWPt++8jOaXoOe8neWlkeWQiO+8jOWuieWFqOaAp+mrmOOAggoy44CB6YCC55So5Zy65pmv5bm/5rObIOebruWJjeW4guWcuuS4iueahOa2iOaBr+S6ke+8jOWkp+mDveWPquiDvemAgueUqOS6juiBiuWkqeWcuuaZr++8jOWFtuS7lua2iOaBr+WcuuaZr+S4jeiDveaUr+aMgeOAgk1JTUPliJnlj6/ku6XmlK/mjIHmmbrog73noazku7bkv6Hku6Qv6IGK5aSpL+WuouacjS/mjqjpgIHnrYnku7vkvZXmtojmga/kvKDpgJLlnLrmma/jgIIKM+OAgeWFqOW5s+WPsOaUr+aMgSBBbmRyb2lkL2lPUy9XZWIvQy9DIy9KYXZhL0dv562J5YWo5bmz5Y+wL+WkmuivreiogOaUr+aMge+8jOS4gOacn+aUr+aMgUFuZHJvaWQvaU9TL1dlYuS4ieW5s+WPsO+8jOWQjue7reS8muagueaNrueUqOaIt+mcgOimgeaUr+aMgeabtOWkmuW5s+WPsC/or63oqIAKNOOAgea2iOaBr+agvOW8jzEwMCXoh6rlrprkuYnpq5jngbXmtLvluqYg55uu5YmN5biC5Zy65LiK55qE5raI5oGv5LqR5aSn6YO96IGK5aSp5YaF5a65L+agvOW8j+iHquWumuS5ieeoi+W6puS9ju+8jOaJqeWxleaAp+W3ruOAgk1JTUPkuI3lr7nmtojmga/lhoXlrrkv5qC85byP6L+b6KGM6ZmQ5Yi277yMQVBQ5Y+v5qC55o2u6Ieq5bex6ZyA5rGC77yM54G15rS75a6a5Yi25raI5oGv5qC85byP77yM5Lyg6YCS5pu05aWR5ZCIQVBQ6Ieq6Lqr6ZyA5rGC55qE5pWw5o2u44CCCjXjgIHmnoHnroBBUEnorr7orqEg5Z+65LqO5YWo5paw55qEYXBp6K6+6K6h5aSn5aSn566A5YyW5LqGYXBw5byA5Y+R6ICF55qE5o6l5YWl5oiQ5pys77yMM+WIhumSn+WNs+WPr+WunueOsOiBiuWkqeWKn+iDveOAgg==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310111, 10007, 1, 'text', '0', 5, 1576855950, '5rW36YeP5bm25Y+R', 0, 0, 0, 1576855950376);
INSERT INTO `message` VALUES (310112, 1, 10007, 'knowledge', '', 0, 1576855950, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupHmnInku4DkuYjkvJjlir/lkaIifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310113, 10007, 1, 'text', '0', 5, 1576855952, '5bCP57Gz5raI5oGv5LqR5pyJ5LuA5LmI5LyY5Yq/5ZGi', 0, 0, 0, 1576855951925);
INSERT INTO `message` VALUES (310114, 1, 10007, 'text', '', 0, 1576855952, '5a6M5YWo5YWN6LS5IOa1t+mHj+W5tuWPkSDmtojmga/lv4Xovr4g5raI5oGv5ryr5ri4IOWFqOeQg+aOpeWFpSDpm7bmiJDmnKzmjqXlhaUg5YWo5bmz5Y+w5pSv5oyBCgox44CBQVBQ5pa56LSm5Y+35L2T57O75a6M576O5aWR5ZCIIOebruWJjeW4guWcuuS4iueahOa2iOaBr+S6ke+8jEFQUOW8gOWPkeiAhemcgOimgemineWklueUs+ivt+S4gOWll+afkOS/oei0puWPt++8jOW5tuWcqOacjeWKoeerr+aYjuaWh+WtmOWCqOafkOS/oei0puWPty/lr4bnoIHvvIznu7TmiqTmiJDmnKzpq5jmmILvvIzlronlhajpo47pmanmnoHpq5jjgIIg5aaC5p6c5o6l5YWlTUlNQ++8jEFQUOW8gOWPkeiAheS4neavq+aEn+efpeS4jeWIsE1JTUPotKblj7fkvZPns7vvvIzmiYDmnInmlLblj5Hpg73mmK/nlKhBUFDotKblj7fvvIzml6DnvJ3lpZHlkIjvvIzlronlhajmgKfpq5jjgIIKCjLjgIHpgILnlKjlnLrmma/lub/ms5sg55uu5YmN5biC5Zy65LiK55qE5raI5oGv5LqR77yM5aSn6YO95Y+q6IO96YCC55So5LqO6IGK5aSp5Zy65pmv77yM5YW25LuW5raI5oGv5Zy65pmv5LiN6IO95pSv5oyB44CCTUlNQ+WImeWPr+S7peaUr+aMgeaZuuiDveehrOS7tuS/oeS7pC/ogYrlpKkv5a6i5pyNL+aOqOmAgeetieS7u+S9lea2iOaBr+S8oOmAkuWcuuaZr+OAggoKM+OAgeWFqOW5s+WPsOaUr+aMgSBBbmRyb2lkL2lPUy9XZWIvQy9DIy9KYXZhL0dv562J5YWo5bmz5Y+wL+WkmuivreiogOaUr+aMge+8jOS4gOacn+aUr+aMgUFuZHJvaWQvaU9TL1dlYuS4ieW5s+WPsO+8jOWQjue7reS8muagueaNrueUqOaIt+mcgOimgeaUr+aMgeabtOWkmuW5s+WPsC/or63oqIAKCjTjgIHmtojmga/moLzlvI8xMDAl6Ieq5a6a5LmJ6auY54G15rS75bqmIOebruWJjeW4guWcuuS4iueahOa2iOaBr+S6keWkp+mDveiBiuWkqeWGheWuuS/moLzlvI/oh6rlrprkuYnnqIvluqbkvY7vvIzmianlsZXmgKflt67jgIJNSU1D5LiN5a+55raI5oGv5YaF5a65L+agvOW8j+i/m+ihjOmZkOWItu+8jEFQUOWPr+agueaNruiHquW3semcgOaxgu+8jOeBtea0u+WumuWItua2iOaBr+agvOW8j++8jOS8oOmAkuabtOWlkeWQiEFQUOiHqui6q+mcgOaxgueahOaVsOaNruOAggoKNeOAgeaegeeugEFQSeiuvuiuoSDln7rkuo7lhajmlrDnmoRhcGnorr7orqHlpKflpKfnroDljJbkuoZhcHDlvIDlj5HogIXnmoTmjqXlhaXmiJDmnKzvvIwz5YiG6ZKf5Y2z5Y+v5a6e546w6IGK5aSp5Yqf6IO944CC', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310115, 10007, 1, 'text', '0', 5, 1576856409, '5ZCN6K+N', 0, 0, 0, 1576856409601);
INSERT INTO `message` VALUES (310116, 1, 10007, 'knowledge', '', 0, 1576856409, 'W3sidGl0bGUiOiLlkI3or43op6Pph4oifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310117, 10007, 1, 'text', '0', 5, 1576856411, '5ZCN6K+N6Kej6YeK', 0, 0, 0, 1576856411117);
INSERT INTO `message` VALUES (310118, 1, 10007, 'text', '', 0, 1576856411, 'QXBwOiDlvIDlj5HogIXlvIDlj5HkuYvlupTnlKgKU0RLOiBNSU1DIFNESwphcHBQcm94eVNlcnZpY2U6IOS7o+eQhuiupOivgeacjeWKoQpUb2tlblNlcnZpY2U6IOWwj+exs+iupOivgeacjeWKoQphcHBJZDog5bqU55SoSUTvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwS2V5OiDlupTnlKhLZXnvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwU2VjOiDlupTnlKhTZWPvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwQWNjb3VudDog5bqU55So6LSm5Y+357O757uf5YaF55So5oi36LSm5Y+3SUTvvIzlupTnlKjotKblj7fns7vnu5/lhoXllK/kuIAKdG9rZW46IOWwj+exs+iupOivgeacjeWKoShUb2tlblNlcnZpY2Up5LiL5Y+RVG9rZW4=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310119, 10007, 1, 'text', '0', 5, 1576856700, '55So5oi355m75b2V', 0, 0, 0, 1576856700792);
INSERT INTO `message` VALUES (310120, 1, 10007, 'knowledge', '', 0, 1576856701, 'W3sidGl0bGUiOiLku4DkuYjlvIDlj5HogIXkuI3pnIDopoHnu7TmiqTluJDlj7fmmKDlsIQifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310121, 10007, 1, 'text', '0', 5, 1576856702, '5LuA5LmI5byA5Y+R6ICF5LiN6ZyA6KaB57u05oqk5biQ5Y+35pig5bCE', 0, 0, 0, 1576856702285);
INSERT INTO `message` VALUES (310122, 1, 10007, 'text', '', 0, 1576856702, 'TUlNQ+eUqOaIt+eZu+W9lS/mtojmga/mlLblj5HnrYnpg73kvb/nlKhBUFDluJDlj7fns7vnu5/ph4znmoTotKblj7dJRO+8jE1JTUPluJDlj7fkvZPns7vlr7lBUFDlvIDlj5HogIXpgI/mmI7vvIEKCkFQUOW8gOWPkeiAheaOpeWFpeWFtuS7lklN5o+Q5L6b5ZWG5pe277yM6KaB6K6/6ZeuSU3mj5DkvpvllYbmnI3liqHvvIzkuLvliqjkuLrmr4/kuIDkuKphcHBBY2NvdW505rOo5YaM5LiA5Liq5paw55qESUTvvIwK5byA5Y+R6ICF6L+Y6ZyA6KaB5Zyo6Ieq5bex55qE5ZCO5Y+w57O757uf5YKo5a2Y5Lul5LiL5L+h5oGv77yaCiAgICAxLiBhcHBBY2NvdW50IC0tPiBJTeaPkOS+m+WVhuezu+e7n+WGhUlECiAgICAyLiBJTeaPkOS+m+WVhuezu+e7n+WGhUlEICsgSU3mj5DkvpvllYbns7vnu5/lhoXnmbvlvZXlr4bnoIEo5piO5paHKQrov5nmoLflgZrmnInku6XkuIvlvIrnq6/vvJoKICAgIDEuIOW8gOWPkeiAhee7tOaKpOW4kOWPt+aYoOWwhOaIkOacrOmrmO+8jOS4gOaXpuWHuumUmemavuS7peS/ruatowogICAgMi4g5piO5paH5a2Y5YKo55m75b2V5a+G56CB77yM5a6J5YWo5oCn5p6B5beu77yM5byA5Y+R6ICF5om/5ouF5p6B6auY55qE5a6J5YWo6aOO6ZmpCgrmiYDku6XvvIxNSU1DKOWwj+exs+WNs+aXtua2iOaBr+S6kSnmsqHmnInph4flj5bku6XkuIrmlrnmoYjvvIxNSU1D6Ieq57u05oqk5biQ5Y+35pig5bCE77yM5L+d6K+BTUlNQyBJROWvueW8gOWPkeiAhemAj+aYjgrov5nkuI3ku4XpmY3kvY7kuoblvIDlj5HogIXotJ/mi4XvvIzlop7lvLrkuobluJDlj7flronlhajmgKfvvIzov5jog73orqnlvIDlj5HogIXmhJ/op4lNSU1D5bCx5pivIuiHquW3seeahCLmtojmga/ns7vnu58=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310123, 10007, 1, 'text', '0', 5, 1577020628, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 0, 0, 0, 1577020628368);
INSERT INTO `message` VALUES (310124, 1, 10007, 'text', '', 0, 1577020628, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCua2iOaBr+exu+WeiwkgICAgICAg5LiK6ZmQCuWNleiBiua2iOaBrwkgICAgICAgIDUwIOS6usK35raI5oGvL+enkgrmma7pgJrogYrmtojmga8gICAgICAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvICA1MCDnvqTCt+a2iOaBry/np5I=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310125, 10007, 1, 'text', '0', 5, 1577020647, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 0, 0, 0, 1577020647845);
INSERT INTO `message` VALUES (310126, 1, 10007, 'text', '', 0, 1577020648, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8JICAgICAgICA1MCDkurrCt+a2iOaBry/np5IK5pmu6YCa6IGK5raI5oGvICAgICAgMjAg576kwrfmtojmga8v56eSCuaXoOmZkOe+pOiBiua2iOaBryAgNTAg576kwrfmtojmga8v56eS', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310127, 10007, 1, 'text', '0', 5, 1577020706, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 0, 0, 0, 1577020706255);
INSERT INTO `message` VALUES (310128, 1, 10007, 'text', '', 0, 1577020706, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+NTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT4yMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT41MCDnvqTCt+a2iOaBry/np5I=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310129, 10007, 1, 'text', '0', 5, 1577020737, '5o6o6YCB', 0, 0, 0, 1577020736987);
INSERT INTO `message` VALUES (310130, 1, 10007, 'knowledge', '', 0, 1577020737, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310131, 10007, 1, 'text', '0', 5, 1577020744, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 0, 0, 0, 1577020744315);
INSERT INTO `message` VALUES (310132, 1, 10007, 'text', '', 0, 1577020744, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5I=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310133, 10007, 1, 'text', '0', 5, 1577020841, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 0, 0, 0, 1577020841804);
INSERT INTO `message` VALUES (310134, 1, 10007, 'text', '', 0, 1577020842, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310135, 10007, 1, 'text', '0', 5, 1577020846, '5o6o6YCBYXBp5o6l5Y+j6ZmQ', 0, 0, 0, 1577020846230);
INSERT INTO `message` VALUES (310136, 1, 10007, 'knowledge', '', 0, 1577020846, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310137, 10007, 1, 'text', '0', 5, 1577020847, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 0, 0, 0, 1577020847799);
INSERT INTO `message` VALUES (310138, 1, 10007, 'text', '', 0, 1577020848, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310139, 10007, 1, 'text', '0', 5, 1577021091, 'ZmV0Y2hUb2tlbg==', 0, 0, 0, 1577021091203);
INSERT INTO `message` VALUES (310140, 1, 10007, 'knowledge', '', 0, 1577021091, 'W3sidGl0bGUiOiLlkITor63oqIDlubPlj7BTREvlronlhajorqTor4HmjqXlj6Plrp7njrDpgLvovpEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310141, 10007, 1, 'text', '0', 5, 1577021093, '5ZCE6K+t6KiA5bmz5Y+wU0RL5a6J5YWo6K6k6K+B5o6l5Y+j5a6e546w6YC76L6R', 0, 0, 0, 1577021093660);
INSERT INTO `message` VALUES (310142, 1, 10007, 'text', '', 0, 1577021093, 'QW5kcm9pZDoKSmF2YToKQysrOgogICAg5a6e546wTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCldlYkpTOgogICAg5a6e546wZnVuY3Rpb24gZmV0Y2hNSU1DVG9rZW4oKe+8jOWQjOatpeiuv+mXruS7o+eQhuiupOivgeacjeWKoe+8jAogICAg5LuO5Luj55CG6K6k6K+B5pyN5Yqh6L+U5Zue57uT5p6c5Lit6Kej5p6QW+Wwj+exs+iupOivgeacjeWKoeS4i+WPkeeahOWOn+Wni+aVsOaNrl3lubbov5Tlm54KQyM6CiAgICDlrp7njrBJTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCmlPUzoKICAgIOWIneWni+WMlk5TTXV0YWJsZVVSTFJlcXVlc3TvvIznlKjkuo7lvILmraXorr/pl67lupTnlKjku6PnkIborqTor4HmnI3liqEKICAgIOWunueOsHBhcnNlVG9rZW5EZWxlZ2F0Ze+8jOS7jk5TTXV0YWJsZVVSTFJlcXVlc3TlvILmraXov5Tlm57nu5PmnpzkuK0KICAgIOino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCkdPOgogICAg5a6e546wRmV0Y2hUb2tlbigpICpzdHJpbmfvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5Zue', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310143, 10007, 1, 'text', '0', 5, 1577021191, '5ZCE6K+t6KiA5bmz5Y+wU0RL5a6J5YWo6K6k6K+B5o6l5Y+j5a6e546w6YC76L6R', 0, 0, 0, 1577021191658);
INSERT INTO `message` VALUES (310144, 1, 10007, 'text', '', 0, 1577021191, 'QW5kcm9pZDoKSmF2YToKQysrOgogICAg5a6e546wTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCldlYkpTOgogICAg5a6e546wZnVuY3Rpb24gZmV0Y2hNSU1DVG9rZW4oKe+8jOWQjOatpeiuv+mXruS7o+eQhuiupOivgeacjeWKoe+8jAogICAg5LuO5Luj55CG6K6k6K+B5pyN5Yqh6L+U5Zue57uT5p6c5Lit6Kej5p6QW+Wwj+exs+iupOivgeacjeWKoeS4i+WPkeeahOWOn+Wni+aVsOaNrl3lubbov5Tlm54KQyM6CiAgICDlrp7njrBJTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCmlPUzoKICAgIOWIneWni+WMlk5TTXV0YWJsZVVSTFJlcXVlc3TvvIznlKjkuo7lvILmraXorr/pl67lupTnlKjku6PnkIborqTor4HmnI3liqEKICAgIOWunueOsHBhcnNlVG9rZW5EZWxlZ2F0Ze+8jOS7jk5TTXV0YWJsZVVSTFJlcXVlc3TlvILmraXov5Tlm57nu5PmnpzkuK0KICAgIOino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCkdPOgogICAg5a6e546wRmV0Y2hUb2tlbigpICpzdHJpbmfvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5Zue', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310145, 10007, 1, 'text', '0', 5, 1577021643, '5bCP57Gz5raI5oGv5LqR5pyJ5LuA5LmI5LyY5Yq/5ZGi', 0, 0, 0, 1577021643210);
INSERT INTO `message` VALUES (310146, 1, 10007, 'text', '', 0, 1577021643, '5a6M5YWo5YWN6LS5IOa1t+mHj+W5tuWPkSDmtojmga/lv4Xovr4g5raI5oGv5ryr5ri4IOWFqOeQg+aOpeWFpSDpm7bmiJDmnKzmjqXlhaUg5YWo5bmz5Y+w5pSv5oyBCgox44CBQVBQ5pa56LSm5Y+35L2T57O75a6M576O5aWR5ZCIIOebruWJjeW4guWcuuS4iueahOa2iOaBr+S6ke+8jEFQUOW8gOWPkeiAhemcgOimgemineWklueUs+ivt+S4gOWll+afkOS/oei0puWPt++8jOW5tuWcqOacjeWKoeerr+aYjuaWh+WtmOWCqOafkOS/oei0puWPty/lr4bnoIHvvIznu7TmiqTmiJDmnKzpq5jmmILvvIzlronlhajpo47pmanmnoHpq5jjgIIg5aaC5p6c5o6l5YWlTUlNQ++8jEFQUOW8gOWPkeiAheS4neavq+aEn+efpeS4jeWIsE1JTUPotKblj7fkvZPns7vvvIzmiYDmnInmlLblj5Hpg73mmK/nlKhBUFDotKblj7fvvIzml6DnvJ3lpZHlkIjvvIzlronlhajmgKfpq5jjgIIKCjLjgIHpgILnlKjlnLrmma/lub/ms5sg55uu5YmN5biC5Zy65LiK55qE5raI5oGv5LqR77yM5aSn6YO95Y+q6IO96YCC55So5LqO6IGK5aSp5Zy65pmv77yM5YW25LuW5raI5oGv5Zy65pmv5LiN6IO95pSv5oyB44CCTUlNQ+WImeWPr+S7peaUr+aMgeaZuuiDveehrOS7tuS/oeS7pC/ogYrlpKkv5a6i5pyNL+aOqOmAgeetieS7u+S9lea2iOaBr+S8oOmAkuWcuuaZr+OAggoKM+OAgeWFqOW5s+WPsOaUr+aMgSBBbmRyb2lkL2lPUy9XZWIvQy9DIy9KYXZhL0dv562J5YWo5bmz5Y+wL+WkmuivreiogOaUr+aMge+8jOS4gOacn+aUr+aMgUFuZHJvaWQvaU9TL1dlYuS4ieW5s+WPsO+8jOWQjue7reS8muagueaNrueUqOaIt+mcgOimgeaUr+aMgeabtOWkmuW5s+WPsC/or63oqIAKCjTjgIHmtojmga/moLzlvI8xMDAl6Ieq5a6a5LmJ6auY54G15rS75bqmIOebruWJjeW4guWcuuS4iueahOa2iOaBr+S6keWkp+mDveiBiuWkqeWGheWuuS/moLzlvI/oh6rlrprkuYnnqIvluqbkvY7vvIzmianlsZXmgKflt67jgIJNSU1D5LiN5a+55raI5oGv5YaF5a65L+agvOW8j+i/m+ihjOmZkOWItu+8jEFQUOWPr+agueaNruiHquW3semcgOaxgu+8jOeBtea0u+WumuWItua2iOaBr+agvOW8j++8jOS8oOmAkuabtOWlkeWQiEFQUOiHqui6q+mcgOaxgueahOaVsOaNruOAggoKNeOAgeaegeeugEFQSeiuvuiuoSDln7rkuo7lhajmlrDnmoRhcGnorr7orqHlpKflpKfnroDljJbkuoZhcHDlvIDlj5HogIXnmoTmjqXlhaXmiJDmnKzvvIwz5YiG6ZKf5Y2z5Y+v5a6e546w6IGK5aSp5Yqf6IO944CC', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310147, 10007, 1, 'text', '0', 5, 1577021678, 'bWltYw==', 0, 0, 0, 1577021678473);
INSERT INTO `message` VALUES (310148, 1, 10007, 'knowledge', '', 0, 1577021678, 'W3sidGl0bGUiOiJtaW1j5pSv5oyB6Leo5bqU55So6IGK5aSp5ZCXIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310149, 10007, 1, 'text', '0', 5, 1577021725, '56a757q/5raI5oGv', 0, 0, 0, 1577021725077);
INSERT INTO `message` VALUES (310150, 1, 10007, 'knowledge', '', 0, 1577021725, 'W3sidGl0bGUiOiJBUFDlnKjlkI7lj7DmlLbkuI3liLDmtojmga/lpoLkvZXlpITnkIYifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310151, 10007, 1, 'text', '0', 5, 1577022078, '5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCX', 0, 0, 0, 1577022078010);
INSERT INTO `message` VALUES (310152, 1, 10007, 'text', '', 0, 1577022078, '5bCP57Gz5raI5oGv5LqR5ZCE5LiqU0RL6YO95pSv5oyB5aSa56uv55m75b2V77yM5bm25LiU5raI5oGv5aSa5bmz5Y+w5aSa57uI56uv5ZCM5q2l77yM5ZCM5LiA5Liq55So5oi35YWB6K645ZCM5pe255m75b2V5aSa5LiqVUE=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310153, 10007, 1, 'text', '0', 5, 1577022087, '5Lq65bel', 0, 0, 0, 1577022087800);
INSERT INTO `message` VALUES (310154, 10007, 100, 'transfer', '', 0, 1577022088, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310155, 1, 10007, 'transfer', '', 0, 1577022088, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3N0YXRpYy91cGxvYWRzL2ltYWdlcy8xMDU5NTcwNjk2MTExNjAwMC5qcGcifQ==', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310156, 10007, 100, 'text', '0', 5, 1577022129, '5raI5oGv', 0, 0, 0, 1577022129794);
INSERT INTO `message` VALUES (310157, 100, 10007, 'end', '0', 0, 1577022266, '', 0, 0, 0, 1577022266757);
INSERT INTO `message` VALUES (310158, 10007, 1, 'text', '0', 5, 1577022602, '5Lq65bel', 0, 0, 0, 1577022602577);
INSERT INTO `message` VALUES (310159, 10007, 100, 'transfer', '', 0, 1577022602, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310160, 1, 10007, 'transfer', '', 0, 1577022603, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3N0YXRpYy91cGxvYWRzL2ltYWdlcy8xMDU5NTcwNjk2MTExNjAwMC5qcGcifQ==', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310161, 100, 10007, 'text', '0', 0, 1577022603, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577022603466);
INSERT INTO `message` VALUES (310162, 10007, 100, 'timeout', '', 0, 1577023860, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310163, 10007, 1, 'text', '0', 5, 1577024950, 'MQ==', 0, 0, 0, 1577024949992);
INSERT INTO `message` VALUES (310164, 1, 10007, 'knowledge', '', 0, 1577024950, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupFTREvmlK/mjIHlpJrnq6/nmbvlvZXlkJcifSx7InRpdGxlIjoi5aaC5L2V5o6l5YWl5bCP57Gz5raI5oGv5LqRIn0seyJ0aXRsZSI6IuacjeWKoeerr+WunueOsOS7o+eQhuiupOivgeacjeWKoSJ9LHsidGl0bGUiOiLmlLbkuI3liLDmtojmga/lpoLkvZXmjpLmn6UifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310165, 10007, 1, 'text', '0', 5, 1577024957, '5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCX', 0, 0, 0, 1577024956925);
INSERT INTO `message` VALUES (310166, 1, 10007, 'text', '', 0, 1577024957, '5bCP57Gz5raI5oGv5LqR5ZCE5LiqU0RL6YO95pSv5oyB5aSa56uv55m75b2V77yM5bm25LiU5raI5oGv5aSa5bmz5Y+w5aSa57uI56uv5ZCM5q2l77yM5ZCM5LiA5Liq55So5oi35YWB6K645ZCM5pe255m75b2V5aSa5LiqVUE=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310167, 10010, 1, 'text', '0', 5, 1577027263, '5Lq65bel', 0, 0, 0, 1577027263802);
INSERT INTO `message` VALUES (310168, 10010, 100, 'transfer', '', 0, 1577027264, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310169, 1, 10010, 'transfer', '', 0, 1577027264, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310170, 100, 10010, 'text', '0', 0, 1577027265, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577027265196);
INSERT INTO `message` VALUES (310171, 10010, 100, 'text', '0', 5, 1577027274, '5L2g5aW9', 0, 0, 0, 1577027274806);
INSERT INTO `message` VALUES (310172, 100, 10010, 'text', '0', 0, 1577027288, '5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo', 0, 0, 0, 1577027287864);
INSERT INTO `message` VALUES (310173, 10010, 100, 'text', '0', 5, 1577027293, '5L2g5aW9', 0, 0, 0, 1577027293804);
INSERT INTO `message` VALUES (310174, 10010, 100, 'text', '0', 5, 1577027305, '5L2g5aW9', 0, 0, 0, 1577027305455);
INSERT INTO `message` VALUES (310175, 10010, 100, 'text', '0', 5, 1577027311, '5piv5ZCX', 0, 0, 0, 1577027311374);
INSERT INTO `message` VALUES (310176, 10010, 100, 'text', '0', 5, 1577027315, '5Zev5Zev', 0, 0, 0, 1577027315223);
INSERT INTO `message` VALUES (310177, 10010, 100, 'text', '0', 5, 1577027403, '5rC055S16LS55rC055S16LS5', 0, 0, 0, 1577027403676);
INSERT INTO `message` VALUES (310178, 10010, 100, 'text', '0', 5, 1577027420, 'MQ==', 0, 0, 0, 1577027420017);
INSERT INTO `message` VALUES (310179, 10010, 100, 'text', '0', 5, 1577027471, 'MQ==', 0, 0, 0, 1577027471090);
INSERT INTO `message` VALUES (310180, 10010, 100, 'text', '0', 5, 1577027473, 'Mg==', 0, 0, 0, 1577027473748);
INSERT INTO `message` VALUES (310181, 10010, 100, 'text', '0', 5, 1577027476, 'Mw==', 0, 0, 0, 1577027476180);
INSERT INTO `message` VALUES (310182, 10010, 100, 'photo', '0', 5, 1577027482, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzc4NzA3NzQ0NTY4NTQ2OTYucG5n', 0, 0, 0, 1577027482490);
INSERT INTO `message` VALUES (310183, 10010, 100, 'text', '0', 5, 1577027602, 'MQ==', 0, 0, 0, 1577027602250);
INSERT INTO `message` VALUES (310184, 10011, 1, 'text', '0', 5, 1577027628, 'MjM0Mg==', 1, 0, 0, 1577027627957);
INSERT INTO `message` VALUES (310185, 1, 10011, 'knowledge', '', 0, 1577027628, 'W3sidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5Zyo57q/5paH5qGjIn0seyJ0aXRsZSI6IuWmguS9leaOpeWFpeWwj+exs+a2iOaBr+S6kSJ9LHsidGl0bGUiOiJtaW1j5pSv5oyB6Leo5bqU55So6IGK5aSp5ZCXIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310186, 10011, 1, 'text', '0', 5, 1577027629, 'bWltY+aUr+aMgei3qOW6lOeUqOiBiuWkqeWQlw==', 1, 0, 0, 1577027629814);
INSERT INTO `message` VALUES (310187, 1, 10011, 'text', '', 0, 1577027630, 'bWltY+aUr+aMgei3qOW6lOeUqOiBiuWkqe+8jOWunueOsOS4pOS4quS4jeWQjOeahEFQUOS5i+mXtOiBiuWkqe+8jOS9v+eUqOWQjOS4gOS4qmFwcElkL2FwcEtleS9hcHBTZWNyZXTljbPlj6/jgII=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310188, 10011, 1, 'text', '0', 5, 1577027631, '5aaC5L2V5o6l5YWl5bCP57Gz5raI5oGv5LqR', 1, 0, 0, 1577027631282);
INSERT INTO `message` VALUES (310189, 1, 10011, 'text', '', 0, 1577027631, 'MS4g5YWI56Gu6K6kREVNT+aYr+WPr+eUqOeahAoyLiDliKDpmaTmnKzlnLDnvJPlrZjnm67lvZUKMy4g5pu/5o2iREVNT+S4rWFwcGlkL2FwcGtleS9hcHBzZWPkuLroh6rnlKhhcHDkv6Hmga8KNC4g5LuU57uG6ZiF6K+75paH5qGj77yI5LiN6KaB5YG35oeS5LiN6KaB55yB77yJCjUuIOW8gOWni+e8luWGmeiHquW3seeahOS4muWKoeS7o+eggQ==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310190, 10021, 1, 'text', '0', 3, 1577027944, 'MQ==', 0, 0, 0, 1577027944139);
INSERT INTO `message` VALUES (310191, 1, 10021, 'knowledge', '', 0, 1577027944, 'W3sidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5YqhIn0seyJ0aXRsZSI6IuS7gOS5iOW8gOWPkeiAheS4jemcgOimgee7tOaKpOW4kOWPt+aYoOWwhCJ9LHsidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310192, 10018, 1, 'text', '0', 5, 1577027946, 'Mg==', 1, 0, 0, 1577027946191);
INSERT INTO `message` VALUES (310193, 1, 10018, 'knowledge', '', 0, 1577027946, 'W3sidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5Zyo57q/5paH5qGjIn0seyJ0aXRsZSI6IuaOqOmAgWFwaeaOpeWPo+mZkOa1gSJ9LHsidGl0bGUiOiLlpoLkvZXmlrDlu7rkuIDkuKrlupTnlKgifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310194, 10021, 1, 'text', '0', 3, 1577027961, '5Lq65bel', 0, 0, 0, 1577027961568);
INSERT INTO `message` VALUES (310195, 10021, 101, 'transfer', '', 0, 1577027961, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 101, 0, 0);
INSERT INTO `message` VALUES (310196, 1, 10021, 'transfer', '', 0, 1577027961, 'eyJpZCI6MTAxLCJuaWNrbmFtZSI6IuWwj+aVjyIsImF2YXRhciI6Imh0dHA6Ly9xaW5pdS5jbXA1MjAuY29tLzM5NzE4NTg4NjgyODIwMjIuanBnIn0=', 0, 101, 1, 0);
INSERT INTO `message` VALUES (310197, 10018, 1, 'photo', '0', 5, 1577027976, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzU0ODU2MTc3ODQzNTgxNzIucG5n', 1, 0, 0, 1577027976465);
INSERT INTO `message` VALUES (310198, 1, 10018, 'knowledge', '', 0, 1577027976, 'W3sidGl0bGUiOiLlhbPkuo5kZW1vIn0seyJ0aXRsZSI6IuS4uuS7gOS5iOmcgOimgeW8gOWPkeiAheiHquWumuS5iea2iOaBr+agvOW8jyJ9LHsidGl0bGUiOiLlnKjnur/mlofmoaMifSx7InRpdGxlIjoibWltY+aUr+aMgei3qOW6lOeUqOiBiuWkqeWQlyJ9XQ==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310199, 10021, 101, 'photo', '0', 3, 1577027987, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzI0NDg4MjUwODQ1MDU3NDMucG5n', 0, 0, 0, 1577027987481);
INSERT INTO `message` VALUES (310200, 10010, 100, 'timeout', '', 0, 1577028120, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310201, 10026, 1, 'photo', '0', 5, 1577028231, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzg2Njk5MzgwNDAxNjAzLnBuZw==', 1, 0, 0, 1577028231920);
INSERT INTO `message` VALUES (310202, 1, 10026, 'knowledge', '', 0, 1577028232, 'W3sidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5Zyo57q/5paH5qGjIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6keacieS7gOS5iOS8mOWKv+WRoiJ9LHsidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310203, 10026, 1, 'text', '0', 5, 1577028267, 'MQ==', 1, 0, 0, 1577028267001);
INSERT INTO `message` VALUES (310204, 1, 10026, 'knowledge', '', 0, 1577028267, 'W3sidGl0bGUiOiJtaW1j5pSv5oyB6Leo5bqU55So6IGK5aSp5ZCXIn0seyJ0aXRsZSI6IuWQjeivjeino+mHiiJ9LHsidGl0bGUiOiLmtojmga/lm57osIPlj5HpgIHkuI7lpLHotKXph43or5UifSx7InRpdGxlIjoi5ZCE6K+t6KiA5bmz5Y+wU0RL5a6J5YWo6K6k6K+B5o6l5Y+j5a6e546w6YC76L6RIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310205, 10026, 1, 'text', '0', 5, 1577028395, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 1, 0, 0, 1577028395067);
INSERT INTO `message` VALUES (310206, 1, 10026, 'text', '', 0, 1577028395, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310207, 10021, 101, 'timeout', '', 0, 1577028480, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310208, 10036, 1, 'photo', '0', 3, 1577028518, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEyNjkzNTc3Mjg1MTk2MTE0LnBuZw==', 1, 0, 0, 1577028518752);
INSERT INTO `message` VALUES (310209, 1, 10036, 'knowledge', '', 0, 1577028519, 'W3sidGl0bGUiOiLlupTnlKjnq6/lrp7njrDlronlhajorqTor4HmjqXlj6MifSx7InRpdGxlIjoi5aaC5L2V5o6l5YWl5bCP57Gz5raI5oGv5LqRIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6keacieS7gOS5iOS8mOWKv+WRoiJ9LHsidGl0bGUiOiLnm67liY3lt7LmlK/mjIHnmoRTREvmnInlk6rkupvor63oqIAifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310210, 10043, 1, 'photo', '0', 3, 1577028532, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwMjcyMzI4NTM5MTk3NjYyLnBuZw==', 1, 0, 0, 1577028532104);
INSERT INTO `message` VALUES (310211, 1, 10043, 'knowledge', '', 0, 1577028532, 'W3sidGl0bGUiOiLlhbPkuo5kZW1vIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6keacieS7gOS5iOS8mOWKv+WRoiJ9LHsidGl0bGUiOiLlsI/nsbPmtojmga/kupFTREvmlK/mjIHlpJrnq6/nmbvlvZXlkJcifSx7InRpdGxlIjoi5pS25LiN5Yiw5raI5oGv5aaC5L2V5o6S5p+lIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310212, 10046, 1, 'text', '0', 3, 1577028767, '55Sz6L6+6IKh5Lu95omL5Yqo6ZiA', 1, 0, 0, 1577028766889);
INSERT INTO `message` VALUES (310213, 1, 10046, 'knowledge', '', 0, 1577028767, 'W3sidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5byA5Y+R6ICF5bel5L2cIn0seyJ0aXRsZSI6IuaOqOmAgWFwaeaOpeWPo+mZkOa1gSJ9LHsidGl0bGUiOiLlkI3or43op6Pph4oifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310214, 10046, 1, 'text', '0', 3, 1577028769, '5byA5Y+R6ICF5bel5L2c', 1, 0, 0, 1577028769817);
INSERT INTO `message` VALUES (310215, 1, 10046, 'text', '', 0, 1577028770, 'MS4g5byA5Y+R6ICF6ZyA6KaB6Ieq5bex5a6e546w6IGK5aSp55WM6Z2iCjIuIOW8gOWPkeiAhemcgOimgeaOpeWFpea2iOaBr+S6keWuieWFqOiupOivgQozLiDlvIDlj5HogIXpnIDopoHoh6rlt7HlrprkuYnmtojmga/kvZPmoLzlvI8=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310216, 10046, 1, 'photo', '0', 3, 1577028891, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEyMzA0MDYyODI2NDA4ODEyLnBuZw==', 1, 0, 0, 1577028891575);
INSERT INTO `message` VALUES (310217, 1, 10046, 'knowledge', '', 0, 1577028891, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupFTREvmlK/mjIHlpJrnq6/nmbvlvZXlkJcifSx7InRpdGxlIjoi5YWz5LqOZGVtbyJ9LHsidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifSx7InRpdGxlIjoi5raI5oGv5Zue6LCDIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310218, 10026, 1, 'photo', '0', 5, 1577028983, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEzNjEyMTU2MzQ1MTcyODY4LnBuZw==', 1, 0, 0, 1577028983057);
INSERT INTO `message` VALUES (310219, 1, 10026, 'knowledge', '', 0, 1577028983, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupFTREvmlK/mjIHlpJrnq6/nmbvlvZXlkJcifSx7InRpdGxlIjoi5bCP57Gz5raI5oGv5LqR5piv5ZCm5pS26LS5In0seyJ0aXRsZSI6Iua2iOaBr+Wbnuiwg+WPkemAgeS4juWksei0pemHjeivlSJ9LHsidGl0bGUiOiLmlLbkuI3liLDmtojmga/lpoLkvZXmjpLmn6UifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310220, 10026, 1, 'text', '0', 5, 1577028983, '5pS25LiN5Yiw5raI5oGv5aaC5L2V5o6S5p+l', 1, 0, 0, 1577028983739);
INSERT INTO `message` VALUES (310221, 1, 10026, 'text', '', 0, 1577028984, 'MS4g5Yig6Zmk5pys5Zyw57yT5a2Y55uu5b2V77yM5bCd6K+V77yIYXBwaWTkv67mlLnlkI7lv4XpobvmiafooYzmraTmk43kvZzvvIkKMi4g5qOA5p+l5Y+R6YCB5pa55ZKM5o6l5pS25pa555qEYXBwaWTmmK/lkKbkuIDoh7TvvIjpmLLmraLnspflv4PlpKfmhI/lr7zoh7TkuI3kuIDoh7TvvIkKMy4g5Y+R6YCB6ICF5ZKM5o6l5pS26ICF56Gu6K6k6YO95Zyo57q/KG9ubGluZVN0YXR1c+Wbnuiwg+aJk+WNsOaXpeW/lykKNC4g5Y+R6YCB6ICFc2VydmVyQWNr5Zue6LCD5piv5ZCm6KKr5omn6KGMCjUuIOaJk+WNsOWHuuaOpeaUtuiAhei0puWPt++8jOehruiupOaOpeaUtuiAhei0puWPt+aYr+S4jeaYr+ato+ehru+8iOmYsuatouWPkee7meS6humUmeivr+eahOS6uu+8iQo2LiDmjqXmlLbnq69oYW5kbGVNZXNzYWdl5Zue6LCD5piv5ZCm6KKr5omn6KGM77yI5Zyo56ys5LiA6KGM5re75Yqg5pel5b+X77yM5o6S6Zmk5raI5oGv5Zue6LCD5Lit5Lia5Yqh6YC76L6RYnVn5a+86Ie05raI5oGv5LiN6IO95q2j56Gu5pi+56S677yJ', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310222, 10055, 1, 'photo', '0', 3, 1577029125, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzg5NTA4Mjk1OTU0NDI4NDcucG5n', 1, 0, 0, 1577029125506);
INSERT INTO `message` VALUES (310223, 1, 10055, 'knowledge', '', 0, 1577029125, 'W3sidGl0bGUiOiJBUFDlnKjlkI7lj7DmlLbkuI3liLDmtojmga/lpoLkvZXlpITnkIYifSx7InRpdGxlIjoi5raI5oGv5Zue6LCDIn0seyJ0aXRsZSI6IuWwj+exs+WNs+aXtua2iOaBr+S6keaYr+S7gOS5iCJ9LHsidGl0bGUiOiLlupTnlKjnq6/lrp7njrDlronlhajorqTor4HmjqXlj6MifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310224, 10056, 1, 'photo', '0', 3, 1577029211, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzExODg0NjYwNzAzNTc3MTY0LnBuZw==', 1, 0, 0, 1577029211005);
INSERT INTO `message` VALUES (310225, 1, 10056, 'knowledge', '', 0, 1577029211, 'W3sidGl0bGUiOiLmtojmga/lm57osIPlj5HpgIHkuI7lpLHotKXph43or5UifSx7InRpdGxlIjoi5aaC5L2V5o6l5YWl5bCP57Gz5raI5oGv5LqRIn0seyJ0aXRsZSI6IuWQjeivjeino+mHiiJ9LHsidGl0bGUiOiLmnI3liqHnq6/lrp7njrDku6PnkIborqTor4HmnI3liqEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310226, 10026, 1, 'photo', '0', 5, 1577029242, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzMzNzc5MDM1ODc2OTAwNTEucG5n', 1, 0, 0, 1577029242606);
INSERT INTO `message` VALUES (310227, 1, 10026, 'knowledge', '', 0, 1577029242, 'W3sidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5bCP57Gz5Y2z5pe25raI5oGv5LqR5piv5LuA5LmIIn0seyJ0aXRsZSI6IuaOqOmAgWFwaeaOpeWPo+mZkOa1gSJ9LHsidGl0bGUiOiLlpoLkvZXmjqXlhaXlsI/nsbPmtojmga/kupEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310228, 10060, 1, 'text', '0', 3, 1577029288, 'MQ==', 1, 0, 0, 1577029288183);
INSERT INTO `message` VALUES (310229, 1, 10060, 'knowledge', '', 0, 1577029288, 'W3sidGl0bGUiOiLlhbPkuo5kZW1vIn0seyJ0aXRsZSI6IuWQhOivreiogOW5s+WPsFNES+WuieWFqOiupOivgeaOpeWPo+WunueOsOmAu+i+kSJ9LHsidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5LuA5LmI5byA5Y+R6ICF5LiN6ZyA6KaB57u05oqk5biQ5Y+35pig5bCEIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310230, 10060, 1, 'text', '0', 3, 1577029289, 'Mg==', 1, 0, 0, 1577029288888);
INSERT INTO `message` VALUES (310231, 1, 10060, 'knowledge', '', 0, 1577029289, 'W3sidGl0bGUiOiLlpoLkvZXmlrDlu7rkuIDkuKrlupTnlKgifSx7InRpdGxlIjoi5Li65LuA5LmI6ZyA6KaB5byA5Y+R6ICF6Ieq5a6a5LmJ5raI5oGv5qC85byPIn0seyJ0aXRsZSI6IuaUtuS4jeWIsOa2iOaBr+WmguS9leaOkuafpSJ9LHsidGl0bGUiOiJtaW1j5pSv5oyB6Leo5bqU55So6IGK5aSp5ZCXIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310232, 10062, 1, 'text', '0', 5, 1577029306, 'MQ==', 1, 0, 0, 1577029306825);
INSERT INTO `message` VALUES (310233, 1, 10062, 'knowledge', '', 0, 1577029307, 'W3sidGl0bGUiOiLmlLbkuI3liLDmtojmga/lpoLkvZXmjpLmn6UifSx7InRpdGxlIjoi5aaC5L2V5paw5bu65LiA5Liq5bqU55SoIn0seyJ0aXRsZSI6IuWQhOivreiogOW5s+WPsFNES+WuieWFqOiupOivgeaOpeWPo+WunueOsOmAu+i+kSJ9LHsidGl0bGUiOiLlupTnlKjnq6/lrp7njrDlronlhajorqTor4HmjqXlj6MifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310234, 10062, 1, 'text', '0', 5, 1577029307, 'Mg==', 1, 0, 0, 1577029307612);
INSERT INTO `message` VALUES (310235, 1, 10062, 'knowledge', '', 0, 1577029307, 'W3sidGl0bGUiOiJtaW1j5pSv5oyB6Leo5bqU55So6IGK5aSp5ZCXIn0seyJ0aXRsZSI6IuaOqOmAgWFwaeaOpeWPo+mZkOa1gSJ9LHsidGl0bGUiOiLlkITor63oqIDlubPlj7BTREvlronlhajorqTor4HmjqXlj6Plrp7njrDpgLvovpEifSx7InRpdGxlIjoi5raI5oGv5Zue6LCD5Y+R6YCB5LiO5aSx6LSl6YeN6K+VIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310236, 10007, 1, 'photo', '0', 5, 1577029438, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzQ0NzExNTQ5MzQ0OTAxNzEucG5n', 0, 0, 0, 1577029438500);
INSERT INTO `message` VALUES (310237, 1, 10007, 'knowledge', '', 0, 1577029438, 'W3sidGl0bGUiOiLlsI/nsbPljbPml7bmtojmga/kupHmmK/ku4DkuYgifSx7InRpdGxlIjoi5bCP57Gz5raI5oGv5LqR5pyJ5LuA5LmI5LyY5Yq/5ZGiIn0seyJ0aXRsZSI6IuebruWJjeW3suaUr+aMgeeahFNES+acieWTquS6m+ivreiogCJ9LHsidGl0bGUiOiLlvIDlj5HogIXlt6XkvZwifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310238, 10007, 1, 'photo', '0', 5, 1577029452, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwOTM3NTE2NTk4MTExNjYucG5n', 0, 0, 0, 1577029451946);
INSERT INTO `message` VALUES (310239, 1, 10007, 'knowledge', '', 0, 1577029452, 'W3sidGl0bGUiOiLlkITor63oqIDlubPlj7BTREvlronlhajorqTor4HmjqXlj6Plrp7njrDpgLvovpEifSx7InRpdGxlIjoi5raI5oGv5Zue6LCDIn0seyJ0aXRsZSI6IuWQjeivjeino+mHiiJ9LHsidGl0bGUiOiLlsI/nsbPmtojmga/kupHmnInku4DkuYjkvJjlir/lkaIifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310240, 10007, 1, 'photo', '0', 5, 1577029487, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzE1Mjk5MDE0MTQ0MzYwNzcyLnBuZw==', 0, 0, 0, 1577029487289);
INSERT INTO `message` VALUES (310241, 1, 10007, 'knowledge', '', 0, 1577029487, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifSx7InRpdGxlIjoi5aaC5L2V5o6l5YWl5bCP57Gz5raI5oGv5LqRIn0seyJ0aXRsZSI6IuWQjeivjeino+mHiiJ9LHsidGl0bGUiOiLkuLrku4DkuYjpnIDopoHlvIDlj5HogIXoh6rlrprkuYnmtojmga/moLzlvI8ifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310242, 10007, 1, 'photo', '0', 5, 1577029684, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzExODk2NDkzMzMxMjI3MTcyLnBuZw==', 0, 0, 0, 1577029684106);
INSERT INTO `message` VALUES (310243, 1, 10007, 'knowledge', '', 0, 1577029684, 'W3sidGl0bGUiOiLlnKjnur/mlofmoaMifSx7InRpdGxlIjoi5bCP57Gz5raI5oGv5LqR5piv5ZCm5pS26LS5In0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6kVNES+aUr+aMgeWkmuerr+eZu+W9leWQlyJ9LHsidGl0bGUiOiLlkI3or43op6Pph4oifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310244, 10007, 1, 'photo', '0', 5, 1577029744, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzg3MDczNjE0Mjg0NTQ3NTEucG5n', 0, 0, 0, 1577029743978);
INSERT INTO `message` VALUES (310245, 1, 10007, 'knowledge', '', 0, 1577029744, 'W3sidGl0bGUiOiLnm67liY3lt7LmlK/mjIHnmoRTREvmnInlk6rkupvor63oqIAifSx7InRpdGxlIjoibWltY+aUr+aMgei3qOW6lOeUqOiBiuWkqeWQlyJ9LHsidGl0bGUiOiLmtojmga/lm57osIMifSx7InRpdGxlIjoi5bCP57Gz5Y2z5pe25raI5oGv5LqR5piv5LuA5LmIIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310246, 10007, 1, 'photo', '0', 5, 1577029807, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzg4MzE5NzA0OTA5MjkwNTAucG5n', 0, 0, 0, 1577029806997);
INSERT INTO `message` VALUES (310247, 1, 10007, 'knowledge', '', 0, 1577029807, 'W3sidGl0bGUiOiJBUFDlnKjlkI7lj7DmlLbkuI3liLDmtojmga/lpoLkvZXlpITnkIYifSx7InRpdGxlIjoi5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5YqhIn0seyJ0aXRsZSI6IuS4uuS7gOS5iOmcgOimgeW8gOWPkeiAheiHquWumuS5iea2iOaBr+agvOW8jyJ9LHsidGl0bGUiOiLlkI3or43op6Pph4oifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310248, 10078, 1, 'photo', '0', 3, 1577030034, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzY0MzY1NzU4NjI4ODQzMDYucG5n', 1, 0, 0, 1577030033952);
INSERT INTO `message` VALUES (310249, 1, 10078, 'knowledge', '', 0, 1577030034, 'W3sidGl0bGUiOiLlnKjnur/mlofmoaMifSx7InRpdGxlIjoi5raI5oGv5Zue6LCD5Y+R6YCB5LiO5aSx6LSl6YeN6K+VIn0seyJ0aXRsZSI6Iua2iOaBr+WbnuiwgyJ9LHsidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310250, 10078, 1, 'text', '0', 3, 1577030039, '5Zyo57q/5paH5qGj', 1, 0, 0, 1577030039639);
INSERT INTO `message` VALUES (310251, 1, 10078, 'text', '', 0, 1577030039, '55uu5YmN5byA5Y+R6ICF5Y+v5ZyoUEPnq6/miZPlvIDpk77mjqXlsI/nsbPlvIDmlL7lubPlj7Dmn6XnnIvlsI/nsbPljbPml7bmtojmga/kupHnmoTku4vnu43lkoxBUEnmjqXlhaXmlofmoaPvvIxTREvkuIvovb3nrYnjgII=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310252, 10078, 1, 'text', '0', 3, 1577030041, '5raI5oGv5Zue6LCD5Y+R6YCB5LiO5aSx6LSl6YeN6K+V', 1, 0, 0, 1577030041213);
INSERT INTO `message` VALUES (310253, 1, 10078, 'text', '', 0, 1577030041, '5Zue6LCD5pyN5Yqh5bCGQXBw55So5oi355qE5Y2z5pe25raI5oGv5ZKM56a757q/5raI5oGvUE9TVOWPkee7meW6lOeUqOaWue+8jOWbnuiwg+acjeWKoeaUtuWIsOi/lOWbnjIwMOeKtuaAgeeggeWImeihqOekuuaOpeaUtuaIkOWKnwrnlKjmiLflj5HpgIHnmoTlrozmlbTmtojmga/kvZNiYXNlNjTnvJbnoIHlkI7mlL7nva7lnKhwYXlsb2Fk5a2X5q615LitCuW9k+a2iOaBr+Wbnuiwg+Wksei0peaXtu+8jOezu+e7n+S8mumHjeivleacgOWkmjPmrKHvvIg1c+WQju+8jDMwc+WQju+8jDVtaW7lkI7vvIk=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310254, 10079, 1, 'text', '0', 5, 1577030777, '5Lq65bel', 1, 0, 0, 1577030777020);
INSERT INTO `message` VALUES (310255, 1, 10079, 'text', '', 0, 1577030777, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310256, 10079, 1, 'text', '0', 5, 1577030804, 'QVBQ5Zyo5ZCO5Y+w5pS25LiN5Yiw5raI5oGv5aaC5L2V5aSE55CG', 1, 0, 0, 1577030804794);
INSERT INTO `message` VALUES (310257, 1, 10079, 'text', '', 0, 1577030805, 'aU9T5bmz5Y+w5LiL77yMQVBQ6L+b5YWl5ZCO5Y+w5pe277yM6L+b56iL5Luj56CB5omn6KGM5Lya5pqC5YGc77yM6L+e5o6l6L+H5LiA5q615pe26Ze05ZCO5Lmf5Lya6KKr5YWz6ZetKOW9k+WJjUFuZHJvaWTkuZ/mhaLmhaLotovlkIzkuo5pT1MpCuWcqEFQUOWQjuWPsOi/kOihjOiiq+mZkOWItui2iuadpei2iuS4peagvOeahOWkp+iDjOaZr+S4i++8jOWmguS9leiuqUFQUOWcqOWQjuWPsOi/kOihjOaXtuS7jeeEtuWPr+S7pSLmlLbliLAi5raI5oGv5ZGi77yfCuaIkeS7rOW7uuiuruS7peS4i+aWueahiO+8mgoxLiDlvIDlj5HogIXlvIDlj5Hnur/kuIrmnI3liqFPZmZsaW5lTWVzc2FnZVNlcnZpY2XvvIzmjqXmlLZNSU1D5pyN5Yqh5Zue6LCD55qE56a757q/5raI5oGvCjIuIE9mZmxpbmVNZXNzYWdlU2VydmljZeWwhuaOpeaUtuWIsOeahOemu+e6v+a2iOaBr++8jOmAmui/h+Wwj+exs+aOqOmAgeWwhuemu+e6v+a2iOaBr+aPkOmGkuS4i+WPkeWIsOeUqOaIt+aJi+acuumAmuefpeagjwozLiDnlKjmiLfngrnlh7vmiYvmnLrpgJrnn6XmoI/mj5DphpLvvIxBUFDooqvlkK/liqjov5vlhaXliY3lj7DvvIxNSU1D5Lya6Ieq5Yqo6YeN6L+e5o6l5pS256a757q/5raI5oGv', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310258, 10079, 1, 'text', '0', 5, 1577030897, '5byA5Y+R6ICF5bel5L2c', 1, 0, 0, 1577030897457);
INSERT INTO `message` VALUES (310259, 1, 10079, 'text', '', 0, 1577030897, 'MS4g5byA5Y+R6ICF6ZyA6KaB6Ieq5bex5a6e546w6IGK5aSp55WM6Z2iCjIuIOW8gOWPkeiAhemcgOimgeaOpeWFpea2iOaBr+S6keWuieWFqOiupOivgQozLiDlvIDlj5HogIXpnIDopoHoh6rlt7HlrprkuYnmtojmga/kvZPmoLzlvI8=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310260, 10079, 1, 'text', '0', 5, 1577030924, '5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCX', 1, 0, 0, 1577030924419);
INSERT INTO `message` VALUES (310261, 1, 10079, 'text', '', 0, 1577030924, '5bCP57Gz5raI5oGv5LqR5ZCE5LiqU0RL6YO95pSv5oyB5aSa56uv55m75b2V77yM5bm25LiU5raI5oGv5aSa5bmz5Y+w5aSa57uI56uv5ZCM5q2l77yM5ZCM5LiA5Liq55So5oi35YWB6K645ZCM5pe255m75b2V5aSa5LiqVUE=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310262, 10079, 1, 'text', '0', 5, 1577030941, '8J+YiA==', 1, 0, 0, 1577030940963);
INSERT INTO `message` VALUES (310263, 1, 10079, 'knowledge', '', 0, 1577030941, 'W3sidGl0bGUiOiLmlLbkuI3liLDmtojmga/lpoLkvZXmjpLmn6UifSx7InRpdGxlIjoi5raI5oGv5Zue6LCDIn0seyJ0aXRsZSI6IuWQhOivreiogOW5s+WPsFNES+WuieWFqOiupOivgeaOpeWPo+WunueOsOmAu+i+kSJ9LHsidGl0bGUiOiLlsI/nsbPmtojmga/kupFTREvmlK/mjIHlpJrnq6/nmbvlvZXlkJcifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310264, 10079, 1, 'text', '0', 5, 1577030943, '5raI5oGv5Zue6LCD', 1, 0, 0, 1577030943377);
INSERT INTO `message` VALUES (310265, 1, 10079, 'text', '', 0, 1577030943, '5raI5oGv5Zue6LCD5Yqf6IO95Y+v5Lul5biu5Yqp5bqU55So5pa55a6M5YWo5o6M5o6nQXBw5L2/55So5oOF5Ya177yM5Zue6LCD5raI5oGv5pWw5o2u5Y+v55So5LqO5pWw5o2u5oyW5o6Y44CB57uf6K6h44CB55uR5o6n44CBQXBw5L+d5rS7562J44CC', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310266, 10079, 1, 'text', '0', 5, 1577030945, '5ZCE6K+t6KiA5bmz5Y+wU0RL5a6J5YWo6K6k6K+B5o6l5Y+j5a6e546w6YC76L6R', 1, 0, 0, 1577030945173);
INSERT INTO `message` VALUES (310267, 1, 10079, 'text', '', 0, 1577030945, 'QW5kcm9pZDoKSmF2YToKQysrOgogICAg5a6e546wTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCldlYkpTOgogICAg5a6e546wZnVuY3Rpb24gZmV0Y2hNSU1DVG9rZW4oKe+8jOWQjOatpeiuv+mXruS7o+eQhuiupOivgeacjeWKoe+8jAogICAg5LuO5Luj55CG6K6k6K+B5pyN5Yqh6L+U5Zue57uT5p6c5Lit6Kej5p6QW+Wwj+exs+iupOivgeacjeWKoeS4i+WPkeeahOWOn+Wni+aVsOaNrl3lubbov5Tlm54KQyM6CiAgICDlrp7njrBJTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCmlPUzoKICAgIOWIneWni+WMlk5TTXV0YWJsZVVSTFJlcXVlc3TvvIznlKjkuo7lvILmraXorr/pl67lupTnlKjku6PnkIborqTor4HmnI3liqEKICAgIOWunueOsHBhcnNlVG9rZW5EZWxlZ2F0Ze+8jOS7jk5TTXV0YWJsZVVSTFJlcXVlc3TlvILmraXov5Tlm57nu5PmnpzkuK0KICAgIOino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCkdPOgogICAg5a6e546wRmV0Y2hUb2tlbigpICpzdHJpbmfvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5Zue', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310268, 10079, 1, 'text', '0', 5, 1577031041, '5b6u5L+h', 1, 0, 0, 1577031041019);
INSERT INTO `message` VALUES (310269, 1, 10079, 'knowledge', '', 0, 1577031041, 'W3sidGl0bGUiOiLlhbPkuo5kZW1vIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6keaYr+WQpuaUtui0uSJ9LHsidGl0bGUiOiLlpoLkvZXmlrDlu7rkuIDkuKrlupTnlKgifSx7InRpdGxlIjoi5bqU55So56uv5a6e546w5a6J5YWo6K6k6K+B5o6l5Y+jIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310270, 10079, 1, 'text', '0', 5, 1577031054, '5aW95ZCn', 1, 0, 0, 1577031054118);
INSERT INTO `message` VALUES (310271, 1, 10079, 'knowledge', '', 0, 1577031054, 'W3sidGl0bGUiOiLkuLrku4DkuYjpnIDopoHlvIDlj5HogIXoh6rlrprkuYnmtojmga/moLzlvI8ifSx7InRpdGxlIjoibWltY+aUr+aMgei3qOW6lOeUqOiBiuWkqeWQlyJ9LHsidGl0bGUiOiLlsI/nsbPmtojmga/kupHmnInku4DkuYjkvJjlir/lkaIifSx7InRpdGxlIjoi5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWBIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310272, 10079, 1, 'text', '0', 5, 1577031056, '5Lq65bel', 1, 0, 0, 1577031055762);
INSERT INTO `message` VALUES (310273, 1, 10079, 'text', '', 0, 1577031056, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310274, 10079, 1, 'text', '0', 5, 1577031059, '5bCP57Gz5raI5oGv5LqR5pyJ5LuA5LmI5LyY5Yq/5ZGi', 1, 0, 0, 1577031059061);
INSERT INTO `message` VALUES (310275, 1, 10079, 'text', '', 0, 1577031059, '5a6M5YWo5YWN6LS5IOa1t+mHj+W5tuWPkSDmtojmga/lv4Xovr4g5raI5oGv5ryr5ri4IOWFqOeQg+aOpeWFpSDpm7bmiJDmnKzmjqXlhaUg5YWo5bmz5Y+w5pSv5oyBCgox44CBQVBQ5pa56LSm5Y+35L2T57O75a6M576O5aWR5ZCIIOebruWJjeW4guWcuuS4iueahOa2iOaBr+S6ke+8jEFQUOW8gOWPkeiAhemcgOimgemineWklueUs+ivt+S4gOWll+afkOS/oei0puWPt++8jOW5tuWcqOacjeWKoeerr+aYjuaWh+WtmOWCqOafkOS/oei0puWPty/lr4bnoIHvvIznu7TmiqTmiJDmnKzpq5jmmILvvIzlronlhajpo47pmanmnoHpq5jjgIIg5aaC5p6c5o6l5YWlTUlNQ++8jEFQUOW8gOWPkeiAheS4neavq+aEn+efpeS4jeWIsE1JTUPotKblj7fkvZPns7vvvIzmiYDmnInmlLblj5Hpg73mmK/nlKhBUFDotKblj7fvvIzml6DnvJ3lpZHlkIjvvIzlronlhajmgKfpq5jjgIIKCjLjgIHpgILnlKjlnLrmma/lub/ms5sg55uu5YmN5biC5Zy65LiK55qE5raI5oGv5LqR77yM5aSn6YO95Y+q6IO96YCC55So5LqO6IGK5aSp5Zy65pmv77yM5YW25LuW5raI5oGv5Zy65pmv5LiN6IO95pSv5oyB44CCTUlNQ+WImeWPr+S7peaUr+aMgeaZuuiDveehrOS7tuS/oeS7pC/ogYrlpKkv5a6i5pyNL+aOqOmAgeetieS7u+S9lea2iOaBr+S8oOmAkuWcuuaZr+OAggoKM+OAgeWFqOW5s+WPsOaUr+aMgSBBbmRyb2lkL2lPUy9XZWIvQy9DIy9KYXZhL0dv562J5YWo5bmz5Y+wL+WkmuivreiogOaUr+aMge+8jOS4gOacn+aUr+aMgUFuZHJvaWQvaU9TL1dlYuS4ieW5s+WPsO+8jOWQjue7reS8muagueaNrueUqOaIt+mcgOimgeaUr+aMgeabtOWkmuW5s+WPsC/or63oqIAKCjTjgIHmtojmga/moLzlvI8xMDAl6Ieq5a6a5LmJ6auY54G15rS75bqmIOebruWJjeW4guWcuuS4iueahOa2iOaBr+S6keWkp+mDveiBiuWkqeWGheWuuS/moLzlvI/oh6rlrprkuYnnqIvluqbkvY7vvIzmianlsZXmgKflt67jgIJNSU1D5LiN5a+55raI5oGv5YaF5a65L+agvOW8j+i/m+ihjOmZkOWItu+8jEFQUOWPr+agueaNruiHquW3semcgOaxgu+8jOeBtea0u+WumuWItua2iOaBr+agvOW8j++8jOS8oOmAkuabtOWlkeWQiEFQUOiHqui6q+mcgOaxgueahOaVsOaNruOAggoKNeOAgeaegeeugEFQSeiuvuiuoSDln7rkuo7lhajmlrDnmoRhcGnorr7orqHlpKflpKfnroDljJbkuoZhcHDlvIDlj5HogIXnmoTmjqXlhaXmiJDmnKzvvIwz5YiG6ZKf5Y2z5Y+v5a6e546w6IGK5aSp5Yqf6IO944CC', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310276, 10079, 1, 'text', '0', 5, 1577031072, '5Lq65bel', 1, 0, 0, 1577031072390);
INSERT INTO `message` VALUES (310277, 1, 10079, 'text', '', 0, 1577031072, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310278, 10079, 1, 'photo', '0', 5, 1577031088, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzM5NDY1MTQwMzEwMTgyMDUuanBlZw==', 1, 0, 0, 1577031087973);
INSERT INTO `message` VALUES (310279, 1, 10079, 'knowledge', '', 0, 1577031088, 'W3sidGl0bGUiOiLlkI3or43op6Pph4oifSx7InRpdGxlIjoi5LuA5LmI5byA5Y+R6ICF5LiN6ZyA6KaB57u05oqk5biQ5Y+35pig5bCEIn0seyJ0aXRsZSI6IuWFs+S6jmRlbW8ifSx7InRpdGxlIjoibWltY+aUr+aMgei3qOW6lOeUqOiBiuWkqeWQlyJ9XQ==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310280, 10079, 1, 'text', '0', 5, 1577031095, '5YWz5LqOZGVtbw==', 1, 0, 0, 1577031095368);
INSERT INTO `message` VALUES (310281, 1, 10079, 'text', '', 0, 1577031095, '5YWz5LqOVUnnu4Tku7YK55uu5YmNTUlNQ+eahERlbW8gVUkg5q+U6L6D57KX57OZ77yM5LuF5L2c5Li65Yqf6IO95ryU56S65L2/55So77yM5YWs5YWx5byA5rqQ55qE6YCa55SoVUnnu4Tku7bmraPlnKjlvIDlj5Hov4fnqIvkuK3vvIzlsI/kvJnkvLTku6zmmoLml7blj6/pgJrov4flhbbku5bmlrnlvI/oh6rlt7HlpITnkIborr7orqFVSeOAgg==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310282, 10079, 1, 'text', '0', 5, 1577031100, '5ZCN6K+N6Kej6YeK', 1, 0, 0, 1577031099897);
INSERT INTO `message` VALUES (310283, 1, 10079, 'text', '', 0, 1577031100, 'QXBwOiDlvIDlj5HogIXlvIDlj5HkuYvlupTnlKgKU0RLOiBNSU1DIFNESwphcHBQcm94eVNlcnZpY2U6IOS7o+eQhuiupOivgeacjeWKoQpUb2tlblNlcnZpY2U6IOWwj+exs+iupOivgeacjeWKoQphcHBJZDog5bqU55SoSUTvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwS2V5OiDlupTnlKhLZXnvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwU2VjOiDlupTnlKhTZWPvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwQWNjb3VudDog5bqU55So6LSm5Y+357O757uf5YaF55So5oi36LSm5Y+3SUTvvIzlupTnlKjotKblj7fns7vnu5/lhoXllK/kuIAKdG9rZW46IOWwj+exs+iupOivgeacjeWKoShUb2tlblNlcnZpY2Up5LiL5Y+RVG9rZW4=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310284, 10079, 1, 'text', '0', 5, 1577031111, '6ZmQ5Yi2', 1, 0, 0, 1577031110862);
INSERT INTO `message` VALUES (310285, 1, 10079, 'knowledge', '', 0, 1577031111, 'W3sidGl0bGUiOiLlpoLkvZXmjqXlhaXlsI/nsbPmtojmga/kupEifSx7InRpdGxlIjoi5raI5oGv5Zue6LCDIn0seyJ0aXRsZSI6IuS7gOS5iOW8gOWPkeiAheS4jemcgOimgee7tOaKpOW4kOWPt+aYoOWwhCJ9LHsidGl0bGUiOiLlkITor63oqIDlubPlj7BTREvlronlhajorqTor4HmjqXlj6Plrp7njrDpgLvovpEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310286, 10079, 1, 'text', '0', 5, 1577031128, 'UXBz', 1, 0, 0, 1577031128611);
INSERT INTO `message` VALUES (310287, 1, 10079, 'knowledge', '', 0, 1577031128, 'W3sidGl0bGUiOiLlupTnlKjnq6/lrp7njrDlronlhajorqTor4HmjqXlj6MifSx7InRpdGxlIjoi5bCP57Gz5raI5oGv5LqR5pyJ5LuA5LmI5LyY5Yq/5ZGiIn0seyJ0aXRsZSI6IuaUtuS4jeWIsOa2iOaBr+WmguS9leaOkuafpSJ9LHsidGl0bGUiOiLnm67liY3lt7LmlK/mjIHnmoRTREvmnInlk6rkupvor63oqIAifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310288, 10079, 1, 'text', '0', 5, 1577031141, '6ZmQ', 1, 0, 0, 1577031141311);
INSERT INTO `message` VALUES (310289, 1, 10079, 'knowledge', '', 0, 1577031141, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310290, 10079, 1, 'text', '0', 5, 1577031144, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 1, 0, 0, 1577031143956);
INSERT INTO `message` VALUES (310291, 1, 10079, 'text', '', 0, 1577031144, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310292, 10079, 1, 'text', '0', 5, 1577031158, '6ZmQ5rWB', 1, 0, 0, 1577031158281);
INSERT INTO `message` VALUES (310293, 1, 10079, 'knowledge', '', 0, 1577031158, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310294, 10079, 1, 'text', '0', 5, 1577031163, 'QVBQ5Zyo5ZCO5Y+w5pS25LiN5Yiw5raI5oGv5aaC5L2V5aSE55CG', 1, 0, 0, 1577031163729);
INSERT INTO `message` VALUES (310295, 1, 10079, 'text', '', 0, 1577031164, 'aU9T5bmz5Y+w5LiL77yMQVBQ6L+b5YWl5ZCO5Y+w5pe277yM6L+b56iL5Luj56CB5omn6KGM5Lya5pqC5YGc77yM6L+e5o6l6L+H5LiA5q615pe26Ze05ZCO5Lmf5Lya6KKr5YWz6ZetKOW9k+WJjUFuZHJvaWTkuZ/mhaLmhaLotovlkIzkuo5pT1MpCuWcqEFQUOWQjuWPsOi/kOihjOiiq+mZkOWItui2iuadpei2iuS4peagvOeahOWkp+iDjOaZr+S4i++8jOWmguS9leiuqUFQUOWcqOWQjuWPsOi/kOihjOaXtuS7jeeEtuWPr+S7pSLmlLbliLAi5raI5oGv5ZGi77yfCuaIkeS7rOW7uuiuruS7peS4i+aWueahiO+8mgoxLiDlvIDlj5HogIXlvIDlj5Hnur/kuIrmnI3liqFPZmZsaW5lTWVzc2FnZVNlcnZpY2XvvIzmjqXmlLZNSU1D5pyN5Yqh5Zue6LCD55qE56a757q/5raI5oGvCjIuIE9mZmxpbmVNZXNzYWdlU2VydmljZeWwhuaOpeaUtuWIsOeahOemu+e6v+a2iOaBr++8jOmAmui/h+Wwj+exs+aOqOmAgeWwhuemu+e6v+a2iOaBr+aPkOmGkuS4i+WPkeWIsOeUqOaIt+aJi+acuumAmuefpeagjwozLiDnlKjmiLfngrnlh7vmiYvmnLrpgJrnn6XmoI/mj5DphpLvvIxBUFDooqvlkK/liqjov5vlhaXliY3lj7DvvIxNSU1D5Lya6Ieq5Yqo6YeN6L+e5o6l5pS256a757q/5raI5oGv', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310296, 10079, 1, 'text', '0', 5, 1577031192, '5a6e5pe25rWB', 1, 0, 0, 1577031192206);
INSERT INTO `message` VALUES (310297, 1, 10079, 'knowledge', '', 0, 1577031192, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupHmmK/lkKbmlLbotLkifSx7InRpdGxlIjoi5Zyo57q/5paH5qGjIn0seyJ0aXRsZSI6IuebruWJjeW3suaUr+aMgeeahFNES+acieWTquS6m+ivreiogCJ9LHsidGl0bGUiOiJBUFDlnKjlkI7lj7DmlLbkuI3liLDmtojmga/lpoLkvZXlpITnkIYifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310298, 10079, 1, 'text', '0', 5, 1577031959, '5rWB', 1, 0, 0, 1577031204889);
INSERT INTO `message` VALUES (310299, 1, 10079, 'knowledge', '', 0, 1577031959, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310300, 10079, 1, 'text', '0', 5, 1577031959, '5rWB', 1, 0, 0, 1577031211563);
INSERT INTO `message` VALUES (310301, 1, 10079, 'knowledge', '', 0, 1577031959, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310302, 10079, 1, 'text', '0', 5, 1577031959, '5aqS5L2T', 1, 0, 0, 1577031214684);
INSERT INTO `message` VALUES (310303, 1, 10079, 'knowledge', '', 0, 1577031960, 'W3sidGl0bGUiOiLlkITor63oqIDlubPlj7BTREvlronlhajorqTor4HmjqXlj6Plrp7njrDpgLvovpEifSx7InRpdGxlIjoi5ZCN6K+N6Kej6YeKIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6keaYr+WQpuaUtui0uSJ9LHsidGl0bGUiOiLlsI/nsbPljbPml7bmtojmga/kupHmmK/ku4DkuYgifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310304, 10079, 1, 'text', '0', 5, 1577031960, '55uu5YmN5bey5pSv5oyB55qEU0RL5pyJ5ZOq5Lqb6K+t6KiA', 1, 0, 0, 1577031220312);
INSERT INTO `message` VALUES (310305, 1, 10079, 'text', '', 0, 1577031960, 'V2ViSlPvvIxpT1PvvIxBbmRyb2lk77yMSmF2Ye+8jCBDI++8jEMrK++8jCBHb++8jOWSjOW8gOWPkeiAhei0oeeMrueahOWwj+eoi+W6j3NkayxmbHV0dGVyLW1pbWPnrYnnrYnvvIzlubbkuI3mlq3nmoTlop7liqDvvIzlubbkuJTnu53lpKfpg6jliIZTREvku6PnoIHlt7Lnu4/lvIDmupDvvIzlpoLmnpzpnIDopoHlhbbku5ZTREvmlK/mjIHor7fljZXni6zogZTns7vmiJHku6zvvJs=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310306, 10079, 1, 'text', '0', 5, 1577031960, '5rWB', 1, 0, 0, 1577031283992);
INSERT INTO `message` VALUES (310307, 1, 10079, 'knowledge', '', 0, 1577031960, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310308, 10079, 1, 'text', '0', 5, 1577031960, 'QVBQ5Zyo5ZCO5Y+w5pS25LiN5Yiw5raI5oGv5aaC5L2V5aSE55CG', 1, 0, 0, 1577031288006);
INSERT INTO `message` VALUES (310309, 1, 10079, 'text', '', 0, 1577031960, 'aU9T5bmz5Y+w5LiL77yMQVBQ6L+b5YWl5ZCO5Y+w5pe277yM6L+b56iL5Luj56CB5omn6KGM5Lya5pqC5YGc77yM6L+e5o6l6L+H5LiA5q615pe26Ze05ZCO5Lmf5Lya6KKr5YWz6ZetKOW9k+WJjUFuZHJvaWTkuZ/mhaLmhaLotovlkIzkuo5pT1MpCuWcqEFQUOWQjuWPsOi/kOihjOiiq+mZkOWItui2iuadpei2iuS4peagvOeahOWkp+iDjOaZr+S4i++8jOWmguS9leiuqUFQUOWcqOWQjuWPsOi/kOihjOaXtuS7jeeEtuWPr+S7pSLmlLbliLAi5raI5oGv5ZGi77yfCuaIkeS7rOW7uuiuruS7peS4i+aWueahiO+8mgoxLiDlvIDlj5HogIXlvIDlj5Hnur/kuIrmnI3liqFPZmZsaW5lTWVzc2FnZVNlcnZpY2XvvIzmjqXmlLZNSU1D5pyN5Yqh5Zue6LCD55qE56a757q/5raI5oGvCjIuIE9mZmxpbmVNZXNzYWdlU2VydmljZeWwhuaOpeaUtuWIsOeahOemu+e6v+a2iOaBr++8jOmAmui/h+Wwj+exs+aOqOmAgeWwhuemu+e6v+a2iOaBr+aPkOmGkuS4i+WPkeWIsOeUqOaIt+aJi+acuumAmuefpeagjwozLiDnlKjmiLfngrnlh7vmiYvmnLrpgJrnn6XmoI/mj5DphpLvvIxBUFDooqvlkK/liqjov5vlhaXliY3lj7DvvIxNSU1D5Lya6Ieq5Yqo6YeN6L+e5o6l5pS256a757q/5raI5oGv', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310310, 10079, 1, 'text', '0', 5, 1577031960, 'QVBQ5Zyo5ZCO5Y+w5pS25LiN5Yiw5raI5oGv5aaC5L2V5aSE55CG', 1, 0, 0, 1577031509829);
INSERT INTO `message` VALUES (310311, 1, 10079, 'text', '', 0, 1577031960, 'aU9T5bmz5Y+w5LiL77yMQVBQ6L+b5YWl5ZCO5Y+w5pe277yM6L+b56iL5Luj56CB5omn6KGM5Lya5pqC5YGc77yM6L+e5o6l6L+H5LiA5q615pe26Ze05ZCO5Lmf5Lya6KKr5YWz6ZetKOW9k+WJjUFuZHJvaWTkuZ/mhaLmhaLotovlkIzkuo5pT1MpCuWcqEFQUOWQjuWPsOi/kOihjOiiq+mZkOWItui2iuadpei2iuS4peagvOeahOWkp+iDjOaZr+S4i++8jOWmguS9leiuqUFQUOWcqOWQjuWPsOi/kOihjOaXtuS7jeeEtuWPr+S7pSLmlLbliLAi5raI5oGv5ZGi77yfCuaIkeS7rOW7uuiuruS7peS4i+aWueahiO+8mgoxLiDlvIDlj5HogIXlvIDlj5Hnur/kuIrmnI3liqFPZmZsaW5lTWVzc2FnZVNlcnZpY2XvvIzmjqXmlLZNSU1D5pyN5Yqh5Zue6LCD55qE56a757q/5raI5oGvCjIuIE9mZmxpbmVNZXNzYWdlU2VydmljZeWwhuaOpeaUtuWIsOeahOemu+e6v+a2iOaBr++8jOmAmui/h+Wwj+exs+aOqOmAgeWwhuemu+e6v+a2iOaBr+aPkOmGkuS4i+WPkeWIsOeUqOaIt+aJi+acuumAmuefpeagjwozLiDnlKjmiLfngrnlh7vmiYvmnLrpgJrnn6XmoI/mj5DphpLvvIxBUFDooqvlkK/liqjov5vlhaXliY3lj7DvvIxNSU1D5Lya6Ieq5Yqo6YeN6L+e5o6l5pS256a757q/5raI5oGv', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310312, 10079, 1, 'text', '0', 5, 1577032422, '5rWB', 1, 0, 0, 1577032422051);
INSERT INTO `message` VALUES (310313, 1, 10079, 'knowledge', '', 0, 1577032422, 'W3sidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310314, 10079, 1, 'text', '0', 5, 1577032424, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 1, 0, 0, 1577032424125);
INSERT INTO `message` VALUES (310315, 1, 10079, 'text', '', 0, 1577032424, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310316, 10079, 1, 'text', '0', 5, 1577032451, '5L2g5aW9', 1, 0, 0, 1577032451207);
INSERT INTO `message` VALUES (310317, 1, 10079, 'knowledge', '', 0, 1577032451, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupHmnInku4DkuYjkvJjlir/lkaIifSx7InRpdGxlIjoi5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5YqhIn0seyJ0aXRsZSI6Iua2iOaBr+Wbnuiwg+WPkemAgeS4juWksei0pemHjeivlSJ9LHsidGl0bGUiOiLmtojmga/lm57osIMifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310318, 10079, 1, 'text', '0', 5, 1577032456, '5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5Yqh', 1, 0, 0, 1577032456662);
INSERT INTO `message` VALUES (310319, 1, 10079, 'text', '', 0, 1577032456, '5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5YqhKGFwcFByb3h5U2VydmljZSnvvIzpobrluo/lgZrku6XkuIvkuovmg4XvvJoKCiAgICAxLiDku6PnkIborqTor4HmnI3liqHlrZjlgqhhcHBLZXkvYXBwU2Vj562J5pWP5oSf5pWw5o2uCiAgICAgICDorr/pl67lsI/nsbPorqTor4HmnI3liqHpnIDopoFhcHBLZXkvYXBwU2Vj562J77yM6L+Z5Lqb5pWw5o2u6Z2e5bi45pWP5oSf77yMCiAgICAgICDlpoLmnpzmlL7lnKjlupTnlKjnq6/ku6PnoIHkuK3kvJrpnZ7luLjlrrnmmJPms4TpnLLvvIzogIzkuJTkuIDml6bms4TmvI/ml6Dms5Xmm7TmlrDvvIwKICAgICAgIOiAjOWtmOWCqOWcqOS7o+eQhuiupOivgeacjeWKoe+8jOWImeazhOmcsumjjumZqeW+iOS9ju+8jOS4gOaXpuazhOmcsuS5n+WPr+S7peW/q+mAn+abtOaWsOOAggogICAgMi4g5Luj55CG6K6k6K+B5pyN5Yqh5YGa6LSm5Y+35ZCI5rOV5oCn6K6k6K+BCiAgICAgICDku6PnkIborqTor4HmnI3liqHpnIDopoHkv53or4HnmbvlvZXnmoRhcHBBY2NvdW505Zyo5YW26LSm5Y+357O757uf5YaF5piv5ZCI5rOV5pyJ5pWI55qECiAgICAzLiDosIPnlKjlsI/nsbPorqTor4HmnI3liqEoVG9rZW5TZXJ2aWNlKQogICAgICAg5Luj55CG6K6k6K+B5pyN5Yqh5Zyo5L+d6K+B55So5oi35ZCI5rOV5Lul5ZCO77yM6LCD55So5bCP57Gz6K6k6K+B5pyN5Yqh77yMCiAgICAgICDlubblsIZb5bCP57Gz6K6k6K+B5pyN5Yqh5LiL5Y+R55qE5Y6f5aeL5pWw5o2uXemAguW9k+WwgeijheWQju+8jOi/lOWbnue7meWuieWFqOiupOivgeaOpeWPow==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310320, 10079, 1, 'text', '0', 5, 1577032472, '5Zyo5bmy5Zib', 1, 0, 0, 1577032472189);
INSERT INTO `message` VALUES (310321, 1, 10079, 'knowledge', '', 0, 1577032472, 'W3sidGl0bGUiOiLlnKjnur/mlofmoaMifSx7InRpdGxlIjoi5aaC5L2V5paw5bu65LiA5Liq5bqU55SoIn0seyJ0aXRsZSI6IuaUtuS4jeWIsOa2iOaBr+WmguS9leaOkuafpSJ9LHsidGl0bGUiOiLkuLrku4DkuYjpnIDopoHlvIDlj5HogIXoh6rlrprkuYnmtojmga/moLzlvI8ifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310322, 10081, 1, 'text', '0', 5, 1577065968, '5Lq65bel', 0, 0, 0, 1577065968528);
INSERT INTO `message` VALUES (310323, 10081, 100, 'transfer', '', 0, 1577065968, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310324, 1, 10081, 'transfer', '', 0, 1577065968, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310325, 100, 10081, 'text', '0', 0, 1577065972, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577065971831);
INSERT INTO `message` VALUES (310326, 10081, 100, 'text', '0', 5, 1577065991, '8J+YtA==', 0, 0, 0, 1577065991269);
INSERT INTO `message` VALUES (310327, 100, 10081, 'text', '0', 0, 1577066141, '8J+kqg==', 0, 0, 0, 1577066141881);
INSERT INTO `message` VALUES (310328, 10081, 100, 'timeout', '', 0, 1577066640, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310329, 10081, 1, 'text', '0', 5, 1577083459, '5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCX', 0, 0, 0, 1577083459409);
INSERT INTO `message` VALUES (310330, 1, 10081, 'text', '', 0, 1577083459, '5bCP57Gz5raI5oGv5LqR5ZCE5LiqU0RL6YO95pSv5oyB5aSa56uv55m75b2V77yM5bm25LiU5raI5oGv5aSa5bmz5Y+w5aSa57uI56uv5ZCM5q2l77yM5ZCM5LiA5Liq55So5oi35YWB6K645ZCM5pe255m75b2V5aSa5LiqVUE=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310331, 10081, 1, 'text', '0', 5, 1577083504, '8J+krA==', 0, 0, 0, 1577083504260);
INSERT INTO `message` VALUES (310332, 1, 10081, 'knowledge', '', 0, 1577083504, 'W3sidGl0bGUiOiLlupTnlKjnq6/lrp7njrDlronlhajorqTor4HmjqXlj6MifSx7InRpdGxlIjoi5Zyo57q/5paH5qGjIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6kVNES+aUr+aMgeWkmuerr+eZu+W9leWQlyJ9LHsidGl0bGUiOiJtaW1j5pSv5oyB6Leo5bqU55So6IGK5aSp5ZCXIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310333, 10081, 1, 'text', '0', 5, 1577083506, '5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCX', 0, 0, 0, 1577083506145);
INSERT INTO `message` VALUES (310334, 1, 10081, 'text', '', 0, 1577083506, '5bCP57Gz5raI5oGv5LqR5ZCE5LiqU0RL6YO95pSv5oyB5aSa56uv55m75b2V77yM5bm25LiU5raI5oGv5aSa5bmz5Y+w5aSa57uI56uv5ZCM5q2l77yM5ZCM5LiA5Liq55So5oi35YWB6K645ZCM5pe255m75b2V5aSa5LiqVUE=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310335, 10081, 1, 'text', '0', 5, 1577083508, '5Lq65bel', 0, 0, 0, 1577083507951);
INSERT INTO `message` VALUES (310336, 10081, 100, 'transfer', '', 0, 1577083508, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310337, 1, 10081, 'transfer', '', 0, 1577083508, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310338, 100, 10081, 'text', '0', 0, 1577083509, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577083509640);
INSERT INTO `message` VALUES (310339, 10082, 1, 'text', '0', 5, 1577083708, '5ZOI5Za9', 0, 0, 0, 1577083708109);
INSERT INTO `message` VALUES (310340, 1, 10082, 'knowledge', '', 0, 1577083708, 'W3sidGl0bGUiOiLkuLrku4DkuYjpnIDopoHlvIDlj5HogIXoh6rlrprkuYnmtojmga/moLzlvI8ifSx7InRpdGxlIjoi5LuA5LmI5byA5Y+R6ICF5LiN6ZyA6KaB57u05oqk5biQ5Y+35pig5bCEIn0seyJ0aXRsZSI6IuWQhOivreiogOW5s+WPsFNES+WuieWFqOiupOivgeaOpeWPo+WunueOsOmAu+i+kSJ9LHsidGl0bGUiOiLlkI3or43op6Pph4oifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310341, 10082, 1, 'text', '0', 5, 1577083715, '5Li65LuA5LmI6ZyA6KaB5byA5Y+R6ICF6Ieq5a6a5LmJ5raI5oGv5qC85byP', 0, 0, 0, 1577083715582);
INSERT INTO `message` VALUES (310342, 1, 10082, 'text', '', 0, 1577083715, '5oiR5Lus5LiN5o+Q5L6b57uf5LiA55qE5raI5oGv5qC85byP77yM6ICM55Sx5byA5Y+R6ICF6Ieq5a6a5LmJ5raI5oGv5qC85byP77yM5Z+65LqO5Lul5LiL55CG55Sx77yaCgoxLiBBUFDmiYDpnIDmtojmga/lip/og73lkITlvILvvIzmnInnmoTpnIDopoHlt7Lor7vvvIzmnInnmoTliJnkuI3pnIDopoHlt7Lor7vlip/og73vvIzmiYDku6XmiJHku6zmj5DkvpvkuobmjqjojZDnmoTmtojmga/moLzlvI/vvIwg55Sx5byA5Y+R6ICF5qC55o2u6Ieq5bex5oOF5Ya15a6a5LmJ5pyA6YCC5ZCI6Ieq5bex55qE5raI5oGv5qC85byPCgoyLiBNSU1DKOWwj+exs+WNs+aXtua2iOaBr+S6kSnlupTnlKjlnLrmma/lub/ms5vvvIxJTeiBiuWkqeWPquaYr01JTUPnmoTkuIDkuKrnibnmrorkvb/nlKjlnLrmma/vvIzov5jlrZjlnKhJb1Tkv6Hku6TkvKDpgJLnrYnlkITnp43mtojmga/kvKDpgJLlnLrmma8K5omA5Lul77yM5oiR5Lus6K6k5Li655Sx5byA5Y+R6ICF5qC55o2u6Ieq5bexQVBQ55qE5a6e6ZmF6ZyA5rGC77yM5Y+C6ICD5oiR5Lus5o6o6I2Q55qE5raI5oGv5qC85byP77yM5p2l5a6a5LmJ5raI5oGv5L2T5qC85byP5q+U6L6D5ZCI6YCC', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310343, 10084, 1, 'text', '0', 5, 1577083717, '5Lq65bel', 0, 0, 0, 1577083717429);
INSERT INTO `message` VALUES (310344, 10084, 100, 'transfer', '', 0, 1577083718, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310345, 1, 10084, 'transfer', '', 0, 1577083718, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310346, 100, 10084, 'text', '0', 0, 1577083720, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577083720395);
INSERT INTO `message` VALUES (310347, 10082, 1, 'text', '0', 5, 1577083739, '5LuA5LmI5byA5Y+R6ICF5LiN6ZyA6KaB57u05oqk5biQ5Y+35pig5bCE', 0, 0, 0, 1577083738903);
INSERT INTO `message` VALUES (310348, 1, 10082, 'text', '', 0, 1577083739, 'TUlNQ+eUqOaIt+eZu+W9lS/mtojmga/mlLblj5HnrYnpg73kvb/nlKhBUFDluJDlj7fns7vnu5/ph4znmoTotKblj7dJRO+8jE1JTUPluJDlj7fkvZPns7vlr7lBUFDlvIDlj5HogIXpgI/mmI7vvIEKCkFQUOW8gOWPkeiAheaOpeWFpeWFtuS7lklN5o+Q5L6b5ZWG5pe277yM6KaB6K6/6ZeuSU3mj5DkvpvllYbmnI3liqHvvIzkuLvliqjkuLrmr4/kuIDkuKphcHBBY2NvdW505rOo5YaM5LiA5Liq5paw55qESUTvvIwK5byA5Y+R6ICF6L+Y6ZyA6KaB5Zyo6Ieq5bex55qE5ZCO5Y+w57O757uf5YKo5a2Y5Lul5LiL5L+h5oGv77yaCjEuIGFwcEFjY291bnQgLS0+IElN5o+Q5L6b5ZWG57O757uf5YaFSUQKMi4gSU3mj5DkvpvllYbns7vnu5/lhoVJRCArIElN5o+Q5L6b5ZWG57O757uf5YaF55m75b2V5a+G56CBKOaYjuaWhykK6L+Z5qC35YGa5pyJ5Lul5LiL5byK56uv77yaCjEuIOW8gOWPkeiAhee7tOaKpOW4kOWPt+aYoOWwhOaIkOacrOmrmO+8jOS4gOaXpuWHuumUmemavuS7peS/ruatowoyLiDmmI7mloflrZjlgqjnmbvlvZXlr4bnoIHvvIzlronlhajmgKfmnoHlt67vvIzlvIDlj5HogIXmib/mi4XmnoHpq5jnmoTlronlhajpo47pmakKCuaJgOS7pe+8jE1JTUMo5bCP57Gz5Y2z5pe25raI5oGv5LqRKeayoeaciemHh+WPluS7peS4iuaWueahiO+8jE1JTUPoh6rnu7TmiqTluJDlj7fmmKDlsITvvIzkv53or4FNSU1DIElE5a+55byA5Y+R6ICF6YCP5piOCui/meS4jeS7hemZjeS9juS6huW8gOWPkeiAhei0n+aLhe+8jOWinuW8uuS6huW4kOWPt+WuieWFqOaAp++8jOi/mOiDveiuqeW8gOWPkeiAheaEn+iniU1JTUPlsLHmmK8i6Ieq5bex55qEIua2iOaBr+ezu+e7nw==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310349, 10084, 100, 'text', '0', 5, 1577083743, '5oOz6Zeu5LiL5pKk5Zue5Yqf6IO95pyJ5LmI', 0, 0, 0, 1577083742779);
INSERT INTO `message` VALUES (310350, 10082, 1, 'text', '0', 5, 1577083743, '5ZCN6K+N6Kej6YeK', 0, 0, 0, 1577083743209);
INSERT INTO `message` VALUES (310351, 1, 10082, 'text', '', 0, 1577083743, 'QXBwOiDlvIDlj5HogIXlvIDlj5HkuYvlupTnlKgKU0RLOiBNSU1DIFNESwphcHBQcm94eVNlcnZpY2U6IOS7o+eQhuiupOivgeacjeWKoQpUb2tlblNlcnZpY2U6IOWwj+exs+iupOivgeacjeWKoQphcHBJZDog5bqU55SoSUTvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwS2V5OiDlupTnlKhLZXnvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwU2VjOiDlupTnlKhTZWPvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwQWNjb3VudDog5bqU55So6LSm5Y+357O757uf5YaF55So5oi36LSm5Y+3SUTvvIzlupTnlKjotKblj7fns7vnu5/lhoXllK/kuIAKdG9rZW46IOWwj+exs+iupOivgeacjeWKoShUb2tlblNlcnZpY2Up5LiL5Y+RVG9rZW4=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310352, 10085, 1, 'text', '0', 5, 1577083760, '5raI5oGv5pKk5Zue', 1, 0, 0, 1577083760709);
INSERT INTO `message` VALUES (310353, 1, 10085, 'knowledge', '', 0, 1577083761, 'W3sidGl0bGUiOiLlhbPkuo5kZW1vIn0seyJ0aXRsZSI6IuWQjeivjeino+mHiiJ9LHsidGl0bGUiOiLku4DkuYjlvIDlj5HogIXkuI3pnIDopoHnu7TmiqTluJDlj7fmmKDlsIQifSx7InRpdGxlIjoi5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5YqhIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310354, 10085, 1, 'text', '0', 5, 1577083768, '5YWz5LqOZGVtbw==', 1, 0, 0, 1577083768463);
INSERT INTO `message` VALUES (310355, 1, 10085, 'text', '', 0, 1577083768, '5YWz5LqOVUnnu4Tku7YK55uu5YmNTUlNQ+eahERlbW8gVUkg5q+U6L6D57KX57OZ77yM5LuF5L2c5Li65Yqf6IO95ryU56S65L2/55So77yM5YWs5YWx5byA5rqQ55qE6YCa55SoVUnnu4Tku7bmraPlnKjlvIDlj5Hov4fnqIvkuK3vvIzlsI/kvJnkvLTku6zmmoLml7blj6/pgJrov4flhbbku5bmlrnlvI/oh6rlt7HlpITnkIborr7orqFVSeOAgg==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310356, 10082, 1, 'text', '0', 5, 1577083770, '5Lq65bel', 0, 0, 0, 1577083770101);
INSERT INTO `message` VALUES (310357, 10082, 100, 'transfer', '', 0, 1577083770, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310358, 1, 10082, 'transfer', '', 0, 1577083770, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310359, 100, 10082, 'text', '0', 0, 1577083772, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577083772400);
INSERT INTO `message` VALUES (310360, 10085, 1, 'text', '0', 5, 1577083784, '5ZCN6K+N6Kej6YeK', 1, 0, 0, 1577083784685);
INSERT INTO `message` VALUES (310361, 1, 10085, 'text', '', 0, 1577083784, 'QXBwOiDlvIDlj5HogIXlvIDlj5HkuYvlupTnlKgKU0RLOiBNSU1DIFNESwphcHBQcm94eVNlcnZpY2U6IOS7o+eQhuiupOivgeacjeWKoQpUb2tlblNlcnZpY2U6IOWwj+exs+iupOivgeacjeWKoQphcHBJZDog5bqU55SoSUTvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwS2V5OiDlupTnlKhLZXnvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwU2VjOiDlupTnlKhTZWPvvIzlsI/nsbPlvIDmlL7lubPlj7DnlLPor7fliIbphY0KYXBwQWNjb3VudDog5bqU55So6LSm5Y+357O757uf5YaF55So5oi36LSm5Y+3SUTvvIzlupTnlKjotKblj7fns7vnu5/lhoXllK/kuIAKdG9rZW46IOWwj+exs+iupOivgeacjeWKoShUb2tlblNlcnZpY2Up5LiL5Y+RVG9rZW4=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310363, 10085, 1, 'text', '0', 5, 1577083788, '5LuA5LmI5byA5Y+R6ICF5LiN6ZyA6KaB57u05oqk5biQ5Y+35pig5bCE', 1, 0, 0, 1577083788886);
INSERT INTO `message` VALUES (310364, 1, 10085, 'text', '', 0, 1577083789, 'TUlNQ+eUqOaIt+eZu+W9lS/mtojmga/mlLblj5HnrYnpg73kvb/nlKhBUFDluJDlj7fns7vnu5/ph4znmoTotKblj7dJRO+8jE1JTUPluJDlj7fkvZPns7vlr7lBUFDlvIDlj5HogIXpgI/mmI7vvIEKCkFQUOW8gOWPkeiAheaOpeWFpeWFtuS7lklN5o+Q5L6b5ZWG5pe277yM6KaB6K6/6ZeuSU3mj5DkvpvllYbmnI3liqHvvIzkuLvliqjkuLrmr4/kuIDkuKphcHBBY2NvdW505rOo5YaM5LiA5Liq5paw55qESUTvvIwK5byA5Y+R6ICF6L+Y6ZyA6KaB5Zyo6Ieq5bex55qE5ZCO5Y+w57O757uf5YKo5a2Y5Lul5LiL5L+h5oGv77yaCjEuIGFwcEFjY291bnQgLS0+IElN5o+Q5L6b5ZWG57O757uf5YaFSUQKMi4gSU3mj5DkvpvllYbns7vnu5/lhoVJRCArIElN5o+Q5L6b5ZWG57O757uf5YaF55m75b2V5a+G56CBKOaYjuaWhykK6L+Z5qC35YGa5pyJ5Lul5LiL5byK56uv77yaCjEuIOW8gOWPkeiAhee7tOaKpOW4kOWPt+aYoOWwhOaIkOacrOmrmO+8jOS4gOaXpuWHuumUmemavuS7peS/ruatowoyLiDmmI7mloflrZjlgqjnmbvlvZXlr4bnoIHvvIzlronlhajmgKfmnoHlt67vvIzlvIDlj5HogIXmib/mi4XmnoHpq5jnmoTlronlhajpo47pmakKCuaJgOS7pe+8jE1JTUMo5bCP57Gz5Y2z5pe25raI5oGv5LqRKeayoeaciemHh+WPluS7peS4iuaWueahiO+8jE1JTUPoh6rnu7TmiqTluJDlj7fmmKDlsITvvIzkv53or4FNSU1DIElE5a+55byA5Y+R6ICF6YCP5piOCui/meS4jeS7hemZjeS9juS6huW8gOWPkeiAhei0n+aLhe+8jOWinuW8uuS6huW4kOWPt+WuieWFqOaAp++8jOi/mOiDveiuqeW8gOWPkeiAheaEn+iniU1JTUPlsLHmmK8i6Ieq5bex55qEIua2iOaBr+ezu+e7nw==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310365, 10082, 100, 'cancel', '0', 5, 1577083790, 'MTU3NzA4Mzc4NTc1OA==', 0, 0, 0, 1577083790388);
INSERT INTO `message` VALUES (310366, 10082, 100, 'text', '0', 5, 1577083807, '5aW95Y6J5a6z8J+RjQ==', 0, 0, 0, 1577083807055);
INSERT INTO `message` VALUES (310367, 10082, 100, 'text', '0', 5, 1577083815, '5ZCN6K+N6Kej6YeK', 0, 0, 0, 1577083814939);
INSERT INTO `message` VALUES (310368, 10082, 100, 'end', '0', 5, 1577083821, '', 0, 0, 0, 1577083820994);
INSERT INTO `message` VALUES (310369, 10082, 1, 'text', '0', 5, 1577083824, '5ZCE6K+t6KiA5bmz5Y+wU0RL5a6J5YWo6K6k6K+B5o6l5Y+j5a6e546w6YC76L6R', 0, 0, 0, 1577083824474);
INSERT INTO `message` VALUES (310370, 1, 10082, 'text', '', 0, 1577083824, 'QW5kcm9pZDoKSmF2YToKQysrOgogICAg5a6e546wTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCldlYkpTOgogICAg5a6e546wZnVuY3Rpb24gZmV0Y2hNSU1DVG9rZW4oKe+8jOWQjOatpeiuv+mXruS7o+eQhuiupOivgeacjeWKoe+8jAogICAg5LuO5Luj55CG6K6k6K+B5pyN5Yqh6L+U5Zue57uT5p6c5Lit6Kej5p6QW+Wwj+exs+iupOivgeacjeWKoeS4i+WPkeeahOWOn+Wni+aVsOaNrl3lubbov5Tlm54KQyM6CiAgICDlrp7njrBJTUlNQ1Rva2VuRmV0Y2hlci5mZXRjaFRva2VuKCnvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCmlPUzoKICAgIOWIneWni+WMlk5TTXV0YWJsZVVSTFJlcXVlc3TvvIznlKjkuo7lvILmraXorr/pl67lupTnlKjku6PnkIborqTor4HmnI3liqEKICAgIOWunueOsHBhcnNlVG9rZW5EZWxlZ2F0Ze+8jOS7jk5TTXV0YWJsZVVSTFJlcXVlc3TlvILmraXov5Tlm57nu5PmnpzkuK0KICAgIOino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5ZueCkdPOgogICAg5a6e546wRmV0Y2hUb2tlbigpICpzdHJpbmfvvIzlkIzmraXorr/pl67ku6PnkIborqTor4HmnI3liqHvvIwKICAgIOS7juS7o+eQhuiupOivgeacjeWKoei/lOWbnue7k+aenOS4reino+aekFvlsI/nsbPorqTor4HmnI3liqHkuIvlj5HnmoTljp/lp4vmlbDmja5d5bm26L+U5Zue', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310371, 10081, 100, 'timeout', '', 0, 1577084040, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310372, 10081, 1, 'text', '0', 5, 1577084080, '5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCX', 0, 0, 0, 1577084080605);
INSERT INTO `message` VALUES (310373, 1, 10081, 'text', '', 0, 1577084080, '5bCP57Gz5raI5oGv5LqR5ZCE5LiqU0RL6YO95pSv5oyB5aSa56uv55m75b2V77yM5bm25LiU5raI5oGv5aSa5bmz5Y+w5aSa57uI56uv5ZCM5q2l77yM5ZCM5LiA5Liq55So5oi35YWB6K645ZCM5pe255m75b2V5aSa5LiqVUE=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310375, 10081, 100, 'cancel', '0', 5, 1577084136, 'MTU3NzA4NDEzNTI5Mw==', 0, 0, 0, 1577084136768);
INSERT INTO `message` VALUES (310376, 10081, 100, 'cancel', '0', 5, 1577084137, 'MTU3NzA4NDEzNTI5Mw==', 0, 0, 0, 1577084136776);
INSERT INTO `message` VALUES (310378, 10081, 100, 'cancel', '0', 5, 1577084139, 'MTU3NzA4NDEzODc3MQ==', 0, 0, 0, 1577084139434);
INSERT INTO `message` VALUES (310379, 10081, 100, 'cancel', '0', 5, 1577084139, 'MTU3NzA4NDEzODc3MQ==', 0, 0, 0, 1577084139442);
INSERT INTO `message` VALUES (310381, 10081, 100, 'cancel', '0', 5, 1577084145, 'MTU3NzA4NDE0NDYyNg==', 0, 0, 0, 1577084145542);
INSERT INTO `message` VALUES (310383, 10081, 100, 'cancel', '0', 5, 1577084149, 'MTU3NzA4NDE0OTA0MQ==', 0, 0, 0, 1577084149760);
INSERT INTO `message` VALUES (310384, 10081, 100, 'end', '0', 5, 1577084153, '', 0, 0, 0, 1577084152937);
INSERT INTO `message` VALUES (310385, 10086, 1, 'text', '0', 5, 1577084222, '5Lq65bel', 0, 0, 0, 1577084222513);
INSERT INTO `message` VALUES (310386, 10086, 100, 'transfer', '', 0, 1577084222, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310387, 1, 10086, 'transfer', '', 0, 1577084222, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310388, 100, 10086, 'text', '0', 0, 1577084224, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577084224706);
INSERT INTO `message` VALUES (310390, 10086, 100, 'cancel', '0', 5, 1577084236, 'MTU3NzA4NDIzMzczMA==', 0, 0, 0, 1577084236038);
INSERT INTO `message` VALUES (310391, 10084, 100, 'timeout', '', 0, 1577084280, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310392, 10086, 100, 'timeout', '', 0, 1577084760, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310393, 10090, 1, 'text', '0', 5, 1577084923, 'Pw==', 0, 0, 0, 1577084923368);
INSERT INTO `message` VALUES (310394, 1, 10090, 'knowledge', '', 0, 1577084923, 'W3sidGl0bGUiOiLmtojmga/lm57osIPlj5HpgIHkuI7lpLHotKXph43or5UifSx7InRpdGxlIjoi5pS25LiN5Yiw5raI5oGv5aaC5L2V5o6S5p+lIn0seyJ0aXRsZSI6IuS4uuS7gOS5iOmcgOimgeW8gOWPkeiAheiHquWumuS5iea2iOaBr+agvOW8jyJ9LHsidGl0bGUiOiLlpoLkvZXmjqXlhaXlsI/nsbPmtojmga/kupEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310395, 10090, 1, 'text', '0', 5, 1577084949, '5Lq65bel', 0, 0, 0, 1577084949058);
INSERT INTO `message` VALUES (310396, 10090, 100, 'transfer', '', 0, 1577084949, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310397, 1, 10090, 'transfer', '', 0, 1577084949, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310398, 100, 10090, 'text', '0', 0, 1577084950, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577084950596);
INSERT INTO `message` VALUES (310399, 10090, 100, 'text', '0', 5, 1577084961, '5aaC5L2V5o6l5YWl5bCP57Gz5raI5oGv5LqR', 0, 0, 0, 1577084961641);
INSERT INTO `message` VALUES (310400, 100, 10090, 'text', '0', 0, 1577085404, '55yL5paH5qGj', 0, 0, 0, 1577085404602);
INSERT INTO `message` VALUES (310401, 10090, 100, 'timeout', '', 0, 1577085900, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310402, 10098, 1, 'text', '0', 3, 1577094130, '5Lq65bel', 1, 0, 0, 1577094130713);
INSERT INTO `message` VALUES (310403, 1, 10098, 'text', '', 0, 1577094130, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310404, 10097, 1, 'text', '0', 5, 1577094133, '5Lq65bel', 1, 0, 0, 1577094133373);
INSERT INTO `message` VALUES (310405, 1, 10097, 'text', '', 0, 1577094133, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310406, 10099, 1, 'text', '0', 5, 1577095238, '5Lq65bel', 1, 0, 0, 1577095158135);
INSERT INTO `message` VALUES (310407, 1, 10099, 'text', '', 0, 1577095238, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310409, 1, 10099, 'knowledge', '', 0, 1577095253, 'W3sidGl0bGUiOiLlpoLkvZXmlrDlu7rkuIDkuKrlupTnlKgifSx7InRpdGxlIjoi5raI5oGv5Zue6LCDIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6keaYr+WQpuaUtui0uSJ9LHsidGl0bGUiOiLmlLbkuI3liLDmtojmga/lpoLkvZXmjpLmn6UifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310410, 10099, 1, 'cancel', '0', 5, 1577095258, 'MTU3NzA5NTE3Mjg1Mw==', 1, 0, 0, 1577095178195);
INSERT INTO `message` VALUES (310411, 10099, 1, 'text', '0', 5, 1577095262, '5Lq65bel', 1, 0, 0, 1577095182465);
INSERT INTO `message` VALUES (310412, 1, 10099, 'text', '', 0, 1577095263, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310413, 10100, 1, 'text', '0', 5, 1577095397, '5L2g5aW95ZWK', 1, 0, 0, 1577095397673);
INSERT INTO `message` VALUES (310414, 1, 10100, 'knowledge', '', 0, 1577095397, 'W3sidGl0bGUiOiLmnI3liqHnq6/lrp7njrDku6PnkIborqTor4HmnI3liqEifSx7InRpdGxlIjoi5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCXIn0seyJ0aXRsZSI6Iua2iOaBr+WbnuiwgyJ9LHsidGl0bGUiOiLmjqjpgIFhcGnmjqXlj6PpmZDmtYEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310415, 10100, 1, 'text', '0', 5, 1577095403, '5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5Yqh', 1, 0, 0, 1577095403481);
INSERT INTO `message` VALUES (310416, 1, 10100, 'text', '', 0, 1577095403, '5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5YqhKGFwcFByb3h5U2VydmljZSnvvIzpobrluo/lgZrku6XkuIvkuovmg4XvvJoKCiAgICAxLiDku6PnkIborqTor4HmnI3liqHlrZjlgqhhcHBLZXkvYXBwU2Vj562J5pWP5oSf5pWw5o2uCiAgICAgICDorr/pl67lsI/nsbPorqTor4HmnI3liqHpnIDopoFhcHBLZXkvYXBwU2Vj562J77yM6L+Z5Lqb5pWw5o2u6Z2e5bi45pWP5oSf77yMCiAgICAgICDlpoLmnpzmlL7lnKjlupTnlKjnq6/ku6PnoIHkuK3kvJrpnZ7luLjlrrnmmJPms4TpnLLvvIzogIzkuJTkuIDml6bms4TmvI/ml6Dms5Xmm7TmlrDvvIwKICAgICAgIOiAjOWtmOWCqOWcqOS7o+eQhuiupOivgeacjeWKoe+8jOWImeazhOmcsumjjumZqeW+iOS9ju+8jOS4gOaXpuazhOmcsuS5n+WPr+S7peW/q+mAn+abtOaWsOOAggogICAgMi4g5Luj55CG6K6k6K+B5pyN5Yqh5YGa6LSm5Y+35ZCI5rOV5oCn6K6k6K+BCiAgICAgICDku6PnkIborqTor4HmnI3liqHpnIDopoHkv53or4HnmbvlvZXnmoRhcHBBY2NvdW505Zyo5YW26LSm5Y+357O757uf5YaF5piv5ZCI5rOV5pyJ5pWI55qECiAgICAzLiDosIPnlKjlsI/nsbPorqTor4HmnI3liqEoVG9rZW5TZXJ2aWNlKQogICAgICAg5Luj55CG6K6k6K+B5pyN5Yqh5Zyo5L+d6K+B55So5oi35ZCI5rOV5Lul5ZCO77yM6LCD55So5bCP57Gz6K6k6K+B5pyN5Yqh77yMCiAgICAgICDlubblsIZb5bCP57Gz6K6k6K+B5pyN5Yqh5LiL5Y+R55qE5Y6f5aeL5pWw5o2uXemAguW9k+WwgeijheWQju+8jOi/lOWbnue7meWuieWFqOiupOivgeaOpeWPow==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310417, 10100, 1, 'text', '0', 5, 1577095415, '5bCP57Gz5raI5oGv5LqRU0RL5pSv5oyB5aSa56uv55m75b2V5ZCX', 1, 0, 0, 1577095415823);
INSERT INTO `message` VALUES (310418, 1, 10100, 'text', '', 0, 1577095416, '5bCP57Gz5raI5oGv5LqR5ZCE5LiqU0RL6YO95pSv5oyB5aSa56uv55m75b2V77yM5bm25LiU5raI5oGv5aSa5bmz5Y+w5aSa57uI56uv5ZCM5q2l77yM5ZCM5LiA5Liq55So5oi35YWB6K645ZCM5pe255m75b2V5aSa5LiqVUE=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310419, 10100, 1, 'text', '0', 5, 1577095426, '5raI5oGv5Zue6LCD', 1, 0, 0, 1577095425988);
INSERT INTO `message` VALUES (310420, 1, 10100, 'text', '', 0, 1577095426, '5raI5oGv5Zue6LCD5Yqf6IO95Y+v5Lul5biu5Yqp5bqU55So5pa55a6M5YWo5o6M5o6nQXBw5L2/55So5oOF5Ya177yM5Zue6LCD5raI5oGv5pWw5o2u5Y+v55So5LqO5pWw5o2u5oyW5o6Y44CB57uf6K6h44CB55uR5o6n44CBQXBw5L+d5rS7562J44CC', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310421, 10100, 1, 'text', '0', 5, 1577095431, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 1, 0, 0, 1577095430972);
INSERT INTO `message` VALUES (310422, 1, 10100, 'text', '', 0, 1577095431, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310423, 10100, 1, 'text', '0', 5, 1577095453, '5Lq65bel', 1, 0, 0, 1577095453800);
INSERT INTO `message` VALUES (310424, 1, 10100, 'text', '', 0, 1577095454, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310425, 10100, 1, 'text', '0', 5, 1577095458, '5Lq65bel', 1, 0, 0, 1577095458823);
INSERT INTO `message` VALUES (310426, 1, 10100, 'text', '', 0, 1577095459, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310427, 10079, 1, 'text', '0', 5, 1577096530, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 1, 0, 0, 1577096530401);
INSERT INTO `message` VALUES (310428, 1, 10079, 'text', '', 0, 1577096530, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310429, 10079, 1, 'text', '0', 5, 1577096543, '5Lq65bel', 1, 0, 0, 1577096543533);
INSERT INTO `message` VALUES (310430, 1, 10079, 'text', '', 0, 1577096543, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310431, 10079, 1, 'text', '0', 5, 1577096550, '5o6o6YCBYXBp5o6l5Y+j6ZmQ5rWB', 1, 0, 0, 1577096550268);
INSERT INTO `message` VALUES (310432, 1, 10079, 'text', '', 0, 1577096550, '5Li65L+d6K+B5pyN5Yqh5YWs5bmz5oCn5ZKM5Y+v55So5oCn77yM5a+55pyN5Yqh5byA5pS+55qE5o6l5Y+j6L+b6KGM6ZmQ5rWB44CC6ZmQ5rWB562W55Wl5aaC5LiL77yaCgrljZXogYrmtojmga8tLS0tLS0tLS0tLS0+5LiK6ZmQNTAg5Lq6wrfmtojmga8v56eSCuaZrumAmuiBiua2iOaBry0tLS0tLS0tLT7kuIrpmZAyMCDnvqTCt+a2iOaBry/np5IK5peg6ZmQ576k6IGK5raI5oGvLS0tLS0tLT7kuIrpmZA1MCDnvqTCt+a2iOaBry/np5IKCuaOqOmAgeaciSBxcHPpmZDliLbnjrDlnKjlj6rmmK/mnI3liqHkv53miqTvvIznlKjmiLflop7plb/kuI3lpJ/kuoblj6/ku6XpgJrnn6XmiJHku6zosIPmlbQ=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310433, 10102, 1, 'text', '0', 5, 1577097182, 'bmlhaG8=', 1, 0, 0, 1577097182428);
INSERT INTO `message` VALUES (310434, 1, 10102, 'knowledge', '', 0, 1577097182, 'W3sidGl0bGUiOiLlsI/nsbPmtojmga/kupHmmK/lkKbmlLbotLkifSx7InRpdGxlIjoi5ZCN6K+N6Kej6YeKIn0seyJ0aXRsZSI6IuaOqOmAgWFwaeaOpeWPo+mZkOa1gSJ9LHsidGl0bGUiOiJBUFDlnKjlkI7lj7DmlLbkuI3liLDmtojmga/lpoLkvZXlpITnkIYifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310435, 10102, 1, 'text', '0', 5, 1577097189, '5bCP57Gz5raI5oGv5LqR5piv5ZCm5pS26LS5', 1, 0, 0, 1577097189260);
INSERT INTO `message` VALUES (310436, 1, 10102, 'text', '', 0, 1577097189, '5Y2z5pe25raI5oGv5pyN5Yqh5bCG5Lya5LiA55u05L6b5aSn5a625YWN6LS55L2/55So77yM6Kej6Zmk5byA5Y+R6ICF5ZCO6aG+5LmL5b+nCuWNs+aXtua2iOaBr+S6keS4reeahOaJgOacieWKn+iDve+8jOaIkeS7rOmDveS4jeWBmumZkOWItu+8jOWFjei0ueS+m+Wkp+WutuS9v+eUqO+8jOWMheaLrOS9huS4jemZkOS6ju+8mgogICAg5Y+R6YCB5raI5oGv5pWw77yM5rOo5YaM55So5oi35pWw77yM5aSa57uI56uv55m75b2V77yM5Yib5bu6576k5Liq5pWw77yM576k5Y6G5Y+y5raI5oGv77yM5a6e5pe2L+emu+e6v+a2iOaBr+Wbnuiwg++8jOaOqOmAgea2iOaBr+aVsOetiQrlvZPnhLbvvIzlr7nkuo7mgbbmhI/kvb/nlKjogIXvvIzmiJHku6zku43nhLbkv53nlZnlsIHnpoHnmoTmnYPliKk=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310437, 10102, 1, 'text', '0', 5, 1577097251, '5Lq65bel', 1, 0, 0, 1577097251886);
INSERT INTO `message` VALUES (310438, 1, 10102, 'text', '', 0, 1577097251, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310439, 10105, 1, 'text', '0', 5, 1577097404, 'Y2Vz', 1, 0, 0, 1577097403225);
INSERT INTO `message` VALUES (310440, 1, 10105, 'knowledge', '', 0, 1577097405, 'W3sidGl0bGUiOiLkuLrku4DkuYjpnIDopoHlvIDlj5HogIXoh6rlrprkuYnmtojmga/moLzlvI8ifSx7InRpdGxlIjoi5Zyo57q/5paH5qGjIn0seyJ0aXRsZSI6IuWwj+exs+a2iOaBr+S6keaYr+WQpuaUtui0uSJ9LHsidGl0bGUiOiJtaW1j5pSv5oyB6Leo5bqU55So6IGK5aSp5ZCXIn1d', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310441, 10105, 1, 'text', '0', 5, 1577097413, '5Lq65bel', 1, 0, 0, 1577097411770);
INSERT INTO `message` VALUES (310442, 1, 10105, 'text', '', 0, 1577097413, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310443, 10108, 1, 'text', '0', 5, 1577099475, '5Lq65bel', 1, 0, 0, 1577099475615);
INSERT INTO `message` VALUES (310444, 1, 10108, 'text', '', 0, 1577099475, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310445, 10109, 1, 'text', '0', 5, 1577099509, '5Lq65bel', 1, 0, 0, 1577099509284);
INSERT INTO `message` VALUES (310446, 1, 10109, 'text', '', 0, 1577099509, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310448, 1, 10107, 'text', '', 0, 1577099536, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310449, 10107, 1, 'cancel', '0', 3, 1577099539, 'MTU3NzA5OTUzNjc2NA==', 1, 0, 0, 1577099539323);
INSERT INTO `message` VALUES (310450, 10107, 1, 'text', '0', 3, 1577099547, '5Lq65bel', 1, 0, 0, 1577099547218);
INSERT INTO `message` VALUES (310451, 1, 10107, 'text', '', 0, 1577099547, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310452, 10107, 1, 'text', '0', 3, 1577099552, '6J6N5ZCI5LqR', 1, 0, 0, 1577099552690);
INSERT INTO `message` VALUES (310453, 1, 10107, 'knowledge', '', 0, 1577099552, 'W3sidGl0bGUiOiLlkITor63oqIDlubPlj7BTREvlronlhajorqTor4HmjqXlj6Plrp7njrDpgLvovpEifSx7InRpdGxlIjoi5aaC5L2V5paw5bu65LiA5Liq5bqU55SoIn0seyJ0aXRsZSI6IuWQjeivjeino+mHiiJ9LHsidGl0bGUiOiLmnI3liqHnq6/lrp7njrDku6PnkIborqTor4HmnI3liqEifV0=', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310454, 10107, 1, 'text', '0', 3, 1577099559, '5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5Yqh', 1, 0, 0, 1577099559572);
INSERT INTO `message` VALUES (310455, 1, 10107, 'text', '', 0, 1577099559, '5pyN5Yqh56uv5a6e546w5Luj55CG6K6k6K+B5pyN5YqhKGFwcFByb3h5U2VydmljZSnvvIzpobrluo/lgZrku6XkuIvkuovmg4XvvJoKCiAgICAxLiDku6PnkIborqTor4HmnI3liqHlrZjlgqhhcHBLZXkvYXBwU2Vj562J5pWP5oSf5pWw5o2uCiAgICAgICDorr/pl67lsI/nsbPorqTor4HmnI3liqHpnIDopoFhcHBLZXkvYXBwU2Vj562J77yM6L+Z5Lqb5pWw5o2u6Z2e5bi45pWP5oSf77yMCiAgICAgICDlpoLmnpzmlL7lnKjlupTnlKjnq6/ku6PnoIHkuK3kvJrpnZ7luLjlrrnmmJPms4TpnLLvvIzogIzkuJTkuIDml6bms4TmvI/ml6Dms5Xmm7TmlrDvvIwKICAgICAgIOiAjOWtmOWCqOWcqOS7o+eQhuiupOivgeacjeWKoe+8jOWImeazhOmcsumjjumZqeW+iOS9ju+8jOS4gOaXpuazhOmcsuS5n+WPr+S7peW/q+mAn+abtOaWsOOAggogICAgMi4g5Luj55CG6K6k6K+B5pyN5Yqh5YGa6LSm5Y+35ZCI5rOV5oCn6K6k6K+BCiAgICAgICDku6PnkIborqTor4HmnI3liqHpnIDopoHkv53or4HnmbvlvZXnmoRhcHBBY2NvdW505Zyo5YW26LSm5Y+357O757uf5YaF5piv5ZCI5rOV5pyJ5pWI55qECiAgICAzLiDosIPnlKjlsI/nsbPorqTor4HmnI3liqEoVG9rZW5TZXJ2aWNlKQogICAgICAg5Luj55CG6K6k6K+B5pyN5Yqh5Zyo5L+d6K+B55So5oi35ZCI5rOV5Lul5ZCO77yM6LCD55So5bCP57Gz6K6k6K+B5pyN5Yqh77yMCiAgICAgICDlubblsIZb5bCP57Gz6K6k6K+B5pyN5Yqh5LiL5Y+R55qE5Y6f5aeL5pWw5o2uXemAguW9k+WwgeijheWQju+8jOi/lOWbnue7meWuieWFqOiupOivgeaOpeWPow==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310456, 10111, 1, 'text', '0', 5, 1577099686, '5Lq65bel', 1, 0, 0, 1577099686894);
INSERT INTO `message` VALUES (310457, 1, 10111, 'text', '', 0, 1577099687, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310458, 10111, 1, 'text', '0', 5, 1577099695, '5Lq65bel', 1, 0, 0, 1577099695354);
INSERT INTO `message` VALUES (310459, 1, 10111, 'text', '', 0, 1577099695, '5b2T5YmN5rKh5pyJ5YC854+tTU3lk6bvvIzmiJHku6znmoRNTeWAvOePreaXtumXtOS4uuWRqOS4gOiHs+WRqOS6lCA5OjAwIC0gMTg6MDAg5oKo5Y+v5Lul5Zyo5q2k5pe26Ze05q616L+b6KGM5ZKo6K+i77yM5oSf6LCi5oKo55qE5pSv5oyB', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310460, 10114, 1, 'photo', '0', 5, 1577105009, 'aHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzI2MTIwOTYyMzM0OTc2MTMuanBn', 0, 0, 0, 1577105009001);
INSERT INTO `message` VALUES (310461, 1, 10114, 'knowledge', '', 0, 1577105009, 'W3sidGl0bGUiOiJBUFDlnKjlkI7lj7DmlLbkuI3liLDmtojmga/lpoLkvZXlpITnkIYifSx7InRpdGxlIjoi5ZCN6K+N6Kej6YeKIn0seyJ0aXRsZSI6Im1pbWPmlK/mjIHot6jlupTnlKjogYrlpKnlkJcifSx7InRpdGxlIjoi5YWz5LqOZGVtbyJ9XQ==', 0, 0, 0, 0);
INSERT INTO `message` VALUES (310462, 10114, 1, 'text', '0', 5, 1577105566, '5Lq65bel', 0, 0, 0, 1577105565936);
INSERT INTO `message` VALUES (310463, 10114, 100, 'transfer', '', 0, 1577105566, '57O757uf5bCG5a6i5oi35YiG6YWN57uZ5oKo', 0, 100, 0, 0);
INSERT INTO `message` VALUES (310464, 1, 10114, 'transfer', '', 0, 1577105566, 'eyJpZCI6MTAwLCJuaWNrbmFtZSI6IktlaXRoIiwiYXZhdGFyIjoiaHR0cDovL2tmLmFpc3N6LmNvbTo2NjYvc3RhdGljL3VwbG9hZHMvaW1hZ2VzLzEwNTk1NzA2OTYxMTE2MDAwLmpwZyJ9', 0, 100, 1, 0);
INSERT INTO `message` VALUES (310465, 100, 10114, 'text', '0', 0, 1577105568, '5oKo5aW977yM5oiR5piv5Zyo57q/5a6i5pyNS2VpdGgs5bel5Y+3MTAw77yM5pyJ5LuA5LmI5Y+v5Lul5biu5Yiw5oKo5ZGi77yf', 0, 0, 0, 1577105568342);
INSERT INTO `message` VALUES (310466, 10114, 100, 'timeout', '', 0, 1577106060, '55Sx5LqO5oKo6ZW/5pe26Ze05pyq5Zue5aSN77yM5pys5qyh5Lya6K+d6LaF5pe25LqG', 0, 0, 0, 0);
COMMIT;

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
INSERT INTO `qiniu_setting` VALUES (1, 'Bucket', 'accessKey', 'secretKey', 'Host', 1577022339);
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
INSERT INTO `robot` VALUES (1, 'MIMC机器人助理', 'http://qiniu.cmp520.com/4473448454302935.jpg', '您好，我是MIMC机器人助理，很高兴为您服务，您可以问我一些关于MIMC的相关问题，如需接入在线客服，请回复“人工”。', '我还不理解您的意思呢，换个其他问题看看.', '|转人工|在线客服|找人工|人工服务|我要找人工|人工客服|', 1, 1, 0, 1564626187, 1, '|收费|使用|跨平台|排查|安全认证|ui|消息体|支持|通知|token|回调|跨应用|消息云|SDK|安全认证|限流|认证|代理|跨应用|排查|多终端|接入|文档|demo|收不到消息|离线消息|帐号|消息|界面|适用|免费吗|如何收费|名词|术语|新建|开始使用|在线文档|支持|mimc|离线消息|', '由于您长时间未回复，系统结束了本次会话，如您还有其他问题，请重新发起会话，感谢您的支持', '当前没有值班MM哦，我们的MM值班时间为周一至周五 9:00 - 18:00 您可以在此时间段进行咨询，感谢您的支持', '很抱歉呢，由于目前咨询人数过多，请耐心等待一会哦');
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
) ENGINE=InnoDB AUTO_INCREMENT=17068 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of services_statistical
-- ----------------------------
BEGIN;
INSERT INTO `services_statistical` VALUES (17050, 10005, 100, 1000000000, 1576683892, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17051, 10006, 100, 1000000000, 1576683956, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17052, 10006, 100, 1000000000, 1576761871, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17053, 10006, 100, 1, 1576851584, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17054, 10006, 100, 1, 1576852352, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17055, 10007, 100, 1, 1576852672, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17056, 10007, 100, 1, 1576854983, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17057, 10007, 100, 1, 1577022088, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17058, 10007, 100, 1, 1577022603, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17059, 10010, 100, 1, 1577027264, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17060, 10021, 101, 1, 1577027961, 3, '', 0);
INSERT INTO `services_statistical` VALUES (17061, 10081, 100, 1, 1577065968, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17062, 10081, 100, 1, 1577083508, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17063, 10084, 100, 1, 1577083718, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17064, 10082, 100, 1, 1577083770, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17065, 10086, 100, 1, 1577084222, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17066, 10090, 100, 1, 1577084949, 5, '', 0);
INSERT INTO `services_statistical` VALUES (17067, 10114, 100, 1, 1577105566, 5, '', 0);
COMMIT;

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
INSERT INTO `system` VALUES (1, '客服系统-工作台', 'http://kf.aissz.com:666/static/uploads/images/1895426542557186.png', '©2019-2029 Macromedia, Inc. All rights reserved.', 1, 1576682340);
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
) ENGINE=InnoDB AUTO_INCREMENT=10115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES (10006, 0, '', '', '访客10006', '', '', 5, 0, 0, '', 1576852658, 1576683949, 0);
INSERT INTO `user` VALUES (10007, 0, '', '', '访客10007', '', '', 5, 0, 0, '', 1577029862, 1576852668, 0);
INSERT INTO `user` VALUES (10008, 0, '', '', '访客10008', '', '', 5, 0, 0, '', 1577025337, 1577025048, 0);
INSERT INTO `user` VALUES (10009, 0, '', '', '访客10009', '', '', 5, 0, 0, '', 1577027222, 1577026674, 0);
INSERT INTO `user` VALUES (10010, 0, '', '', '访客10010', '', '', 5, 0, 0, '', 1577029850, 1577027244, 0);
INSERT INTO `user` VALUES (10011, 0, '', '', '访客10011', '', '', 5, 0, 0, '', 1577027616, 1577027616, 0);
INSERT INTO `user` VALUES (10012, 0, '', '', '访客10012', '', '', 3, 0, 0, '', 1577027883, 1577027880, 0);
INSERT INTO `user` VALUES (10013, 0, '', '', '访客10013', '', '', 5, 0, 0, '', 1577027904, 1577027883, 0);
INSERT INTO `user` VALUES (10014, 0, '', '', '访客10014', '', '', 3, 0, 0, '', 1577027886, 1577027886, 0);
INSERT INTO `user` VALUES (10015, 0, '', '', '访客10015', '', '', 3, 0, 0, '', 1577027889, 1577027889, 0);
INSERT INTO `user` VALUES (10016, 0, '', '', '访客10016', '', '', 3, 0, 0, '', 1577027896, 1577027896, 0);
INSERT INTO `user` VALUES (10017, 0, '', '', '访客10017', '', '', 3, 0, 0, '', 1577027906, 1577027904, 0);
INSERT INTO `user` VALUES (10018, 0, '', '', '访客10018', '', '', 5, 0, 0, '', 1577028040, 1577027906, 0);
INSERT INTO `user` VALUES (10019, 0, '', '', '访客10019', '', '', 3, 0, 0, '', 1577027909, 1577027909, 0);
INSERT INTO `user` VALUES (10020, 0, '', '', '访客10020', '', '', 3, 0, 0, '', 1577027912, 1577027912, 0);
INSERT INTO `user` VALUES (10021, 0, '', '', '访客10021', '', '', 3, 0, 0, '', 1577028093, 1577027920, 0);
INSERT INTO `user` VALUES (10022, 0, '', '', '访客10022', '', '', 5, 0, 0, '', 1577028085, 1577028084, 0);
INSERT INTO `user` VALUES (10023, 0, '', '', '访客10023', '', '', 5, 0, 0, '', 1577028101, 1577028092, 0);
INSERT INTO `user` VALUES (10024, 0, '', '', '访客10024', '', '', 3, 0, 0, '', 1577028101, 1577028101, 0);
INSERT INTO `user` VALUES (10025, 0, '', '', '访客10025', '', '', 3, 0, 0, '', 1577028246, 1577028125, 0);
INSERT INTO `user` VALUES (10026, 0, '', '', '访客10026', '', '', 5, 0, 0, '', 1577029416, 1577028225, 0);
INSERT INTO `user` VALUES (10027, 0, '', '', '访客10027', '', '', 3, 0, 0, '', 1577028276, 1577028255, 0);
INSERT INTO `user` VALUES (10028, 0, '', '', '访客10028', '', '', 5, 0, 0, '', 1577028881, 1577028276, 0);
INSERT INTO `user` VALUES (10029, 0, '', '', '访客10029', '', '', 3, 0, 0, '', 1577028312, 1577028312, 0);
INSERT INTO `user` VALUES (10030, 0, '', '', '访客10030', '', '', 3, 0, 0, '', 1577028315, 1577028315, 0);
INSERT INTO `user` VALUES (10031, 0, '', '', '访客10031', '', '', 3, 0, 0, '', 1577028343, 1577028343, 0);
INSERT INTO `user` VALUES (10032, 0, '', '', '访客10032', '', '', 3, 0, 0, '', 1577028345, 1577028345, 0);
INSERT INTO `user` VALUES (10033, 0, '', '', '访客10033', '', '', 3, 0, 0, '', 1577028358, 1577028358, 0);
INSERT INTO `user` VALUES (10034, 0, '', '', '访客10034', '', '', 3, 0, 0, '', 1577028359, 1577028359, 0);
INSERT INTO `user` VALUES (10035, 0, '', '', '访客10035', '', '', 3, 0, 0, '', 1577028452, 1577028391, 0);
INSERT INTO `user` VALUES (10036, 0, '', '', '访客10036', '', '', 3, 0, 0, '', 1577028510, 1577028510, 0);
INSERT INTO `user` VALUES (10037, 0, '', '', '访客10037', '', '', 3, 0, 0, '', 1577028523, 1577028523, 0);
INSERT INTO `user` VALUES (10038, 0, '', '', '访客10038', '', '', 3, 0, 0, '', 1577028523, 1577028523, 0);
INSERT INTO `user` VALUES (10039, 0, '', '', '访客10039', '', '', 3, 0, 0, '', 1577028523, 1577028523, 0);
INSERT INTO `user` VALUES (10040, 0, '', '', '访客10040', '', '', 3, 0, 0, '', 1577028524, 1577028524, 0);
INSERT INTO `user` VALUES (10041, 0, '', '', '访客10041', '', '', 3, 0, 0, '', 1577028524, 1577028524, 0);
INSERT INTO `user` VALUES (10042, 0, '', '', '访客10042', '', '', 3, 0, 0, '', 1577028524, 1577028524, 0);
INSERT INTO `user` VALUES (10043, 0, '', '', '访客10043', '', '', 3, 0, 0, '', 1577028525, 1577028525, 0);
INSERT INTO `user` VALUES (10044, 0, '', '', '访客10044', '', '', 3, 0, 0, '', 1577028613, 1577028553, 0);
INSERT INTO `user` VALUES (10045, 0, '', '', '访客10045', '', '', 3, 0, 0, '', 1577028641, 1577028641, 0);
INSERT INTO `user` VALUES (10046, 0, '', '', '访客10046', '', '', 3, 0, 0, '', 1577028942, 1577028641, 0);
INSERT INTO `user` VALUES (10047, 0, '', '', '访客10047', '', '', 5, 0, 0, '', 1577029001, 1577028882, 0);
INSERT INTO `user` VALUES (10048, 0, '', '', '访客10048', '', '', 3, 0, 0, '', 1577028952, 1577028952, 0);
INSERT INTO `user` VALUES (10049, 0, '', '', '访客10049', '', '', 3, 0, 0, '', 1577028962, 1577028962, 0);
INSERT INTO `user` VALUES (10050, 0, '', '', '访客10050', '', '', 3, 0, 0, '', 1577028964, 1577028964, 0);
INSERT INTO `user` VALUES (10051, 0, '', '', '访客10051', '', '', 3, 0, 0, '', 1577029034, 1577029001, 0);
INSERT INTO `user` VALUES (10052, 0, '', '', '访客10052', '', '', 5, 0, 0, '', 1577029068, 1577029034, 0);
INSERT INTO `user` VALUES (10053, 0, '', '', '访客10053', '', '', 3, 0, 0, '', 1577029098, 1577029069, 0);
INSERT INTO `user` VALUES (10054, 0, '', '', '访客10054', '', '', 5, 0, 0, '', 1577029197, 1577029098, 0);
INSERT INTO `user` VALUES (10055, 0, '', '', '访客10055', '', '', 3, 0, 0, '', 1577029162, 1577029102, 0);
INSERT INTO `user` VALUES (10056, 0, '', '', '访客10056', '', '', 3, 0, 0, '', 1577029259, 1577029197, 0);
INSERT INTO `user` VALUES (10057, 0, '', '', '访客10057', '', '', 5, 0, 0, '', 1577029198, 1577029198, 0);
INSERT INTO `user` VALUES (10058, 0, '', '', '访客10058', '', '', 5, 0, 0, '', 1577029275, 1577029198, 0);
INSERT INTO `user` VALUES (10059, 0, '', '', '访客10059', '', '', 3, 0, 0, '', 1577029263, 1577029263, 0);
INSERT INTO `user` VALUES (10060, 0, '', '', '访客10060', '', '', 3, 0, 0, '', 1577029301, 1577029275, 0);
INSERT INTO `user` VALUES (10061, 0, '', '', '访客10061', '', '', 5, 0, 0, '', 1577029293, 1577029293, 0);
INSERT INTO `user` VALUES (10062, 0, '', '', '访客10062', '', '', 5, 0, 0, '', 1577029595, 1577029300, 0);
INSERT INTO `user` VALUES (10063, 0, '', '', '访客10063', '', '', 3, 0, 0, '', 1577029369, 1577029309, 0);
INSERT INTO `user` VALUES (10064, 0, '', '', '访客10064', '', '', 3, 0, 0, '', 1577029393, 1577029393, 0);
INSERT INTO `user` VALUES (10065, 0, '', '', '访客10065', '', '', 3, 0, 0, '', 1577029473, 1577029412, 0);
INSERT INTO `user` VALUES (10066, 0, '', '', '访客10066', '', '', 3, 0, 0, '', 1577029538, 1577029477, 0);
INSERT INTO `user` VALUES (10067, 0, '', '', '访客10067', '', '', 3, 0, 0, '', 1577029658, 1577029595, 0);
INSERT INTO `user` VALUES (10068, 0, '', '', '访客10068', '', '', 5, 0, 0, '', 1577029661, 1577029597, 0);
INSERT INTO `user` VALUES (10069, 0, '', '', '访客10069', '', '', 3, 0, 0, '', 1577029698, 1577029661, 0);
INSERT INTO `user` VALUES (10070, 0, '', '', '访客10070', '', '', 5, 0, 0, '', 1577029762, 1577029698, 0);
INSERT INTO `user` VALUES (10071, 0, '', '', '访客10071', '', '', 3, 0, 0, '', 1577029707, 1577029707, 0);
INSERT INTO `user` VALUES (10072, 0, '', '', '访客10072', '', '', 3, 0, 0, '', 1577029732, 1577029732, 0);
INSERT INTO `user` VALUES (10073, 0, '', '', '访客10073', '', '', 3, 0, 0, '', 1577029799, 1577029762, 0);
INSERT INTO `user` VALUES (10074, 0, '', '', '访客10074', '', '', 5, 0, 0, '', 1577030169, 1577029799, 0);
INSERT INTO `user` VALUES (10075, 0, '', '', '访客10075', '', '', 3, 0, 0, '', 1577029822, 1577029822, 0);
INSERT INTO `user` VALUES (10076, 0, '', '', '访客10076', '', '', 3, 0, 0, '', 1577029824, 1577029824, 0);
INSERT INTO `user` VALUES (10077, 0, '', '', '访客10077', '', '', 3, 0, 0, '', 1577029827, 1577029827, 0);
INSERT INTO `user` VALUES (10078, 0, '', '', '访客10078', '', '', 3, 0, 0, '', 1577030025, 1577030025, 0);
INSERT INTO `user` VALUES (10079, 0, '', '', '访客10079', '', '', 5, 0, 0, '', 1577096527, 1577030766, 0);
INSERT INTO `user` VALUES (10080, 0, '', '', '访客10080', '', '', 5, 0, 0, '', 1577063799, 1577063793, 0);
INSERT INTO `user` VALUES (10081, 0, '', '', '访客10081', '', '', 5, 0, 0, '', 1577084142, 1577065921, 0);
INSERT INTO `user` VALUES (10082, 0, '', '', '访客10082', '', '', 5, 0, 0, '', 1577084236, 1577083689, 0);
INSERT INTO `user` VALUES (10083, 0, '', '', '访客10083', '', '', 5, 0, 0, '', 1577083689, 1577083689, 0);
INSERT INTO `user` VALUES (10084, 0, '', '', '访客10084', '', '', 5, 0, 0, '', 1577084001, 1577083700, 0);
INSERT INTO `user` VALUES (10085, 0, '', '', '访客10085', '', '', 5, 0, 0, '', 1577083773, 1577083713, 0);
INSERT INTO `user` VALUES (10086, 0, '', '', '访客10086', '', '', 5, 0, 0, '', 1577084321, 1577084204, 0);
INSERT INTO `user` VALUES (10087, 0, '', '', '访客10087', '', '', 3, 0, 0, '', 1577087153, 1577084321, 0);
INSERT INTO `user` VALUES (10088, 0, '', '', '访客10088', '', '', 5, 0, 0, '', 1577084809, 1577084326, 0);
INSERT INTO `user` VALUES (10089, 0, '', '', '访客10089', '', '', 5, 0, 0, '', 1577084534, 1577084475, 0);
INSERT INTO `user` VALUES (10090, 0, '', '', '访客10090', '', '', 5, 0, 0, '', 1577084952, 1577084876, 0);
INSERT INTO `user` VALUES (10091, 0, '', '', '访客10091', '', '', 5, 0, 0, '', 1577087146, 1577087146, 0);
INSERT INTO `user` VALUES (10092, 0, '', '', '访客10092', '', '', 5, 0, 0, '', 1577087153, 1577087153, 0);
INSERT INTO `user` VALUES (10093, 0, '', '', '访客10093', '', '', 5, 0, 0, '', 1577087655, 1577087655, 0);
INSERT INTO `user` VALUES (10094, 0, '', '', '访客10094', '', '', 3, 0, 0, '', 1577091884, 1577091884, 0);
INSERT INTO `user` VALUES (10095, 0, '', '', '访客10095', '', '', 5, 0, 0, '', 1577092429, 1577091884, 0);
INSERT INTO `user` VALUES (10096, 0, '', '', '访客10096', '', '', 3, 0, 0, '', 1577092429, 1577092429, 0);
INSERT INTO `user` VALUES (10097, 0, '', '', '访客10097', '', '', 5, 0, 0, '', 1577094119, 1577094119, 0);
INSERT INTO `user` VALUES (10098, 0, '', '', '访客10098', '', '', 3, 0, 0, '', 1577094119, 1577094119, 0);
INSERT INTO `user` VALUES (10099, 0, '', '', '访客10099', '', '', 5, 0, 0, '', 1577095231, 1577095231, 0);
INSERT INTO `user` VALUES (10100, 0, '', '', '访客10100', '', '', 5, 0, 0, '', 1577095448, 1577095388, 0);
INSERT INTO `user` VALUES (10101, 0, '', '', '访客10101', '', '', 5, 0, 0, '', 1577096908, 1577096908, 0);
INSERT INTO `user` VALUES (10102, 0, '', '', '访客10102', '', '', 5, 0, 0, '', 1577098912, 1577097170, 0);
INSERT INTO `user` VALUES (10103, 0, '', '', '访客10103', '', '', 3, 0, 0, '', 1577098913, 1577097171, 0);
INSERT INTO `user` VALUES (10104, 0, '', '', '访客10104', '', '', 5, 0, 0, '', 1577097308, 1577097308, 0);
INSERT INTO `user` VALUES (10105, 0, '', '', '访客10105', '', '', 5, 1, 0, '', 1577106258, 1577097399, 1);
INSERT INTO `user` VALUES (10106, 0, '', '', '访客10106', '', '', 3, 1, 0, '', 1577106260, 1577097399, 1);
INSERT INTO `user` VALUES (10107, 0, '', '', '访客10107', '', '', 3, 0, 0, '', 1577099546, 1577099433, 0);
INSERT INTO `user` VALUES (10108, 0, '', '', '访客10108', '', '', 5, 0, 0, '', 1577099433, 1577099433, 0);
INSERT INTO `user` VALUES (10109, 0, '', '', '访客10109', '', '', 5, 0, 0, '', 1577099767, 1577099487, 0);
INSERT INTO `user` VALUES (10110, 0, '', '', '访客10110', '', '', 3, 0, 0, '', 1577099767, 1577099587, 0);
INSERT INTO `user` VALUES (10111, 0, '', '', '访客10111', '', '', 5, 0, 0, '', 1577099902, 1577099601, 0);
INSERT INTO `user` VALUES (10112, 0, '', '', '访客10112', '', '', 3, 0, 0, '', 1577099902, 1577099601, 0);
INSERT INTO `user` VALUES (10113, 0, '', '', '访客10113', '', '', 5, 0, 0, '', 1577104738, 1577104738, 0);
INSERT INTO `user` VALUES (10114, 0, '', '小米办公室', '访客10114', '', '13800138000', 5, 1, 0, '牛人', 1577106288, 1577104952, 1);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
