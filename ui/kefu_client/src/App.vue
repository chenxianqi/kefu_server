<template>
    <div>
       <router-view />
    </div>
</template>

<script>
export default {
  name: "app",
  data() {
    return {

    };
  },
  computed: {
    
  },
  mounted() {
    this.handelUrl()
  },
  methods: {
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
      var isShowHeader,isMobile,userAccount,uid,isArtificial,artificialAccount,robotAccount,platform
      var query = this.queryToJson(location.search);
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
            isArtificial = true
            artificialAccount = parseInt(query.a)
        } else {
            robotAccount = parseInt(query.a)
        }
      }
      var isArtificialString = localStorage.getItem("isArtificial");
      var artificialAccountString = localStorage.getItem("artificialAccount");
      if (isArtificialString == "true") {
          isArtificial = true
          artificialAccount = parseInt(artificialAccountString)
      }
      this.$store.commit("updateState", {isShowHeader,isMobile,userAccount,uid,isArtificial,artificialAccount,robotAccount, platform})
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


</style>
