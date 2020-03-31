<template>
  <div>
    <div
      class="mini-im-loading"
      :class="{'pc-mini-im-loading': !isMobile}"
      v-if="isShowPageLoading"
    >
      <mt-spinner type="triple-bounce" color="#26a2ff"></mt-spinner>
    </div>
    <router-view />
  </div>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  name: "app",
  data() {
    return {};
  },
  computed: {
    ...mapGetters([
      "isShowPageLoading",
      "userAccount",
      "isArtificial",
      "isMobile",
      "artificialAccount",
      "robotAccount",
      "platform",
      "userLocal",
      "uid",
      "uid",
    ])
  },
  created() {
    this.getLocal();
    setTimeout(() => {
      this.handelUrl()
      this.runApp()
    }, 500);
    // 判断是否被踢出对话
    this.onCheckIsOutSession();
  },
  methods: {
    runApp() {
      const user = this.$mimcInstance.getLocalCacheUser();
      if (
        user &&
        this.userAccount != null &&
        this.userAccount != user.id &&
        this.userAccount != 0
      ) {
        localStorage.clear();
      }
      this.$mimcInstance.init(
        {
          type: 0, // 默认0
          address: this.userLocal,
          uid: this.uid || 0, // 预留字段扩展自己平台业务
          platform: this.platform, // 渠道（平台）
          account_id: this.userAccount || 0 // 用户ID
          // 初始化完成这里返回一个user
        },
        user => {

          // 上报活动时间
          this.upLastActivity();

          // 获取公司信息
          this.$store.dispatch("onGetCompanyInfo");

          // 获取配置信息
          this.$store.dispatch("onGetConfigs");

          // 获取工单类型
          this.$store.dispatch("onGetWorkorderTypes");

          // 获取工单列表
          this.$store.dispatch("onGetWorkorders");

          // 重试
          if (!user) {
            setTimeout(() => this.runApp(), 1000);
            return;
          }

          // user
          this.$store.commit("updateState", {
            userAccount: user.id,
            userInfo: user
          });

          // robot
          var robot = this.$mimcInstance.robot;
          localStorage.setItem("robot_" + robot.id, JSON.stringify(robot));
          this.$store.commit("updateState", {
            robotAccount: robot.id,
            robotInfo: robot
          });

          // 发送一条握手消息给机器人
          var sentHandshake =() =>{
            if (this.$mimcInstance.user == null || !this.$mimcInstance.user.isLogin()) {
                setTimeout(() => sentHandshake(), 1000);
                return
            }
            if (!this.artificialAccount) {
              console.log("握手消息");
              this.$mimcInstance.sendMessage(
                "handshake",
                this.robotAccount,
                ""
              );
            }
          }
          sentHandshake()


        }
      );
    },
    // Handelurl
    handelUrl() {
      // url query 介绍
      // h == header  0 不显示 1显示 默认值显示，PC端不显示
      // m == mobile  0 不是移动端 1是移动端
      // p == platform  平台ID（渠道）
      // r == robot   0 当前为为客服 1机器人（对应的账号为a）
      // a == account 当前提供对话服务的账号，即客服账号，或机器人
      // u == userAccount  会话用户账号
      // uid == userId  业务平台的ID
      // c = 1          清除本地缓存
      var isShowHeader,
        isMobile,
        userAccount,
        uid,
        isArtificial,
        artificialAccount,
        robotAccount,
        platform;
      var query = this.queryToJson(location.href.substr(location.href.lastIndexOf("?")).replace('#/index', ""))
      if (query && query.c) localStorage.clear();
      // 获取本地缓存
      var urlQuery = this.queryToJson(localStorage.getItem("urlQuery"));
      if (urlQuery) {
        query = Object.assign({}, urlQuery, query);
      }
      if (query) {
        if (query.h == "0") isShowHeader = false;
        if (query.m == "0") {
          isMobile = false;
          isShowHeader = false;
        }
        if (query.u) userAccount = parseInt(query.u);
        if (query.p) platform = parseInt(query.p);
        if (query.uid) uid = parseInt(query.uid);
        if (query.r == "0") {
          isArtificial = true;
          artificialAccount = parseInt(query.a);
        } else {
          robotAccount = parseInt(query.a);
        }
      }
      var isArtificialString = localStorage.getItem("isArtificial");
      var artificialAccountString = localStorage.getItem("artificialAccount");
      if (isArtificialString == "true") {
        isArtificial = true;
        artificialAccount = parseInt(artificialAccountString);
      }
      this.$store.commit("updateState", {
        isShowHeader,
        isMobile,
        userAccount,
        uid,
        isArtificial,
        artificialAccount,
        robotAccount,
        platform
      });
    },
    // query 转json
    queryToJson(str) {
      if (!str || str == "") return null;
      var query = str.substr(1, str.length).split("&");
      if (!query) return null;
      var mapData = {};
      for (let i = 0; i < query.length; i++) {
        var temArr = query[i].split("=");
        mapData[temArr[0]] = temArr[1];
      }
      return mapData;
    },
    // 根据IP获取用户地理位置
    getLocal() {
      this.$store.dispatch("onGetLocal", this.$store.state.AmapAPPKey);
    },
    // 上报最后活动时间
    upLastActivity() {
      this.onCheckIsOutSession();
      const user = this.$mimcInstance.getLocalCacheUser();
      if (user) this.$store.dispatch("onUpdateLastActivity");
      if (this.isArtificial) {
        localStorage.setItem("artificialTime", Date.now());
      }
      setTimeout(() => this.upLastActivity(), 1000 * 60);
    },
    // 判断是否被踢出对话
    onCheckIsOutSession() {
      var artificialTime = localStorage.getItem("artificialTime");
      if (artificialTime) {
        artificialTime = parseInt(artificialTime);
        if (Date.now() > artificialTime + 60 * 1000 * 10) {
          this.$store.commit("updateState", {
            isArtificial: false,
            artificialAccount: null
          });
        }
      }
    },
  }
};
</script>

<style lang="stylus">
body {
  min-width: 240px;
  overflow: hidden;
  height: 100vh;
  background-color: #f3f3f3;
}

.mint-header.is-fixed {
  height: 50px !important;
  background: -webkit-linear-gradient(to right, #26a2ff, #736cde);
  background: -o-linear-gradient(to right, #26a2ff, #736cde);
  background: -moz-linear-gradient(to right, #26a2ff, #736cde);
  background: linear-gradient(to right, #26a2ff, #736cde);

  .mint-header-title {
    font-size: 15px;
  }
}

.mint-header, .mint-tabbar {
  min-width: 240px;
  z-index: 999999999 !important;
}

.mint-header .is-right {
  img {
    width: 25px;
  }
}

.mint-header .mint-button .mintui {
  font-size: 23px !important;
}

.mini-im-loading {
  display: flex;
  width: 100%;
  position: fixed;
  height: 100vh;
  top: 0;
  left: 0;
  z-index: 9;
  right: 0;
  background-color: #fff !important;
  margin: auto;
  align-items: center;
  justify-content: center;

  &.pc-mini-im-loading {
    width: 360px !important;
    height: 360px !important;
    top: -48px;
    bottom: 0;
    margin: auto !important;
  }
}
.workorder-create-picker .picker-item{
  font-size 15px
}
</style>
