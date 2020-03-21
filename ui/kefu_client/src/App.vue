<template>
    <div>
       <router-view />
    </div>
</template>

<script>
import axios from "axios";
import { Toast, MessageBox } from "mint-ui";
import * as qiniu from "qiniu-js";
var emojiService = require("../resource/emoji");
import BScroll from "better-scroll";
export default {
  name: "app",
  data() {
    return {

    };
  },
  computed: {
    
  },
  mounted() {
    console.log(11111)
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
      this.$store.commit("updateState", {isShowHeader,isMobile,userAccount,uid,isArtificial,artificialAccount,robotAccount})
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

.mint-tabbar {
  z-index: 999999999 !important;
  background-color: #fff !important;
}

.mint-loadmore-spinner {
  width: 15px !important;
  height: 15px !important;
}

.mini-im-container {
  margin: 0 auto;
  padding: 50px 0 100px;
  overflow: hidden;
  height: 100vh;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;

  .input-ing {
    width: 100vw;
    height: 25px;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    background-color: #26a2ff !important;
    z-index: 9;
    color: #fff;
    margin: auto;
    text-align: center;
    font-size: 14px;
    line-height: 25px;
  }

  .mini-im-loading {
    display: flex;
    min-width: 240px;
    width: 100%;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    background-color: #fff !important;
    margin: auto;
    align-items: center;
    justify-content: center;
  }
}

.mini-im-container-no-pto {
  padding-top: 0px !important;
}

.mini-im-tabbar-input {
  width: 100%;
  padding: 5px 10px;
  overflow: hidden;
  height: 100px;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  position: fixed;
  bottom: 0;
  z-index: 9;
  background-color: #fff !important;
  border-top: 1px solid #f2f2f2;
  left: 0;
  right: 0;
  margin: 0 auto;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;

  textarea {
    outline: none;
    -webkit-appearance: none;
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
    border: none;
    border-radius: 5px;
    height: 65px;
    flex-grow: 1;
    padding: 8px 0;
    font-size: 14px;
    color: #666;
    background-color: #ffffff;
    display: block;
    box-sizing: border-box;
    resize: none;
    flex-shrink: 1;
    flex-grow: 1;
    width: 100px;
  }

  span {
    width: 25px;
    height: 25px;
    display: flex;
    align-items: center;
    justify-content: center;

    img {
      width: 28px;
    }

    &.expression-btn {
      position: absolute;
      left: 45px;
      top: 6px;
      z-index: 99;
    }

    &.workorder-btn{
      position: absolute;
      left: 70px;
      top: 6px;
      z-index: 99;
      width 70px
      color #999
      font-size 14px
      display flex
      img{
        width 28px
        hieght 28px
      }
      i{
        font-style normal
      }
    }

    &.photo-btn {
      position: absolute;
      left: 10px;
      top: 5px;
      overflow: hidden;
      z-index: 99;

      img {
        width: 22px;
      }

      input {
        width: 100%;
        height: 100%;
        position: absolute;
        top: 0;
        left: 0;
        opacity: 0;
      }
    }

    &.serverci {
      width: 70px;
      position: absolute;
      flex-direction: row;
      justify-content: flex-end;
      top: 5px;
      right: 10px;

      img {
        width: 26px;
      }

      span {
        width: 70px;
        background-color: #f3f3f370;
        color: #999;
        font-size: 14px;
      }

      &.on {
        left: 75px;
        justify-content: flex-start;
        right: initial;
      }
    }
  }

  .mini-input-send {
    width: 55px;
    height: 30px;
    color: #fff;
    line-height: 30px;
    text-align: center;
    border-radius: 3px;
    border: none;
    font-size: 14px;
    background: linear-gradient(to right, #26a2ff, #736cde);
    flex-shrink: 0;

    &:active {
      opacity: 0.8;
    }
  }
}

.mini-im-emoji {
  width: 100%;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  padding: 5px 0;
  z-index: 9;
  margin: 0 auto;
  background-color: #fff;

  .mini-im-emoji-content {
    width: 100%;
    height: 100vh;
    padding: 50px 0 5px;
    position: absolute;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    overflow: hidden;
    bottom: 0;
    left: 0;
    right: 0;
    margin: 0 auto;
    background-color: #fff;
    text-align: center;
    box-shadow: 0px 2px 2px 1px rgba(0, 0, 0, 0.1);

    span {
      display: inline-block;
      width: 28px;
      height: 28px;
      padding: 2px;
      text-align: center;
      font-size: 23px;
    }
  }
}

.mini-im-body {
  position: relative;
  height: 100%;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  background-color: #f3f3f3;
  margin: 0 auto;
  overflow: hidden;
  z-index: 1;

  ul {
    position: absolute;
    z-index: 1;
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
    width: 100%;
    -webkit-transform: translateZ(0);
    -moz-transform: translateZ(0);
    -ms-transform: translateZ(0);
    -o-transform: translateZ(0);
    transform: translateZ(0);
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    -webkit-text-size-adjust: none;
    -moz-text-size-adjust: none;
    -ms-text-size-adjust: none;
    -o-text-size-adjust: none;
    text-size-adjust: none;
  }

  .loading {
    height: 100%;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    margin: auto;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .top-loading {
    width: 100%;
    height: 35px;
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9;

    span {
      color: #999;
      font-size: 13px;
      margin-left: 5px;
    }
  }
}

.mini-im-knowledge {
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.2);
  position: fixed;
  z-index: 8;
  top: 0;
  left: 0;
  right: 0;
  margin: 0 auto;
  box-sizing: border-box;
  padding-bottom: 100px;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;

  .mask {
    flex-grow: 1;
    width: 100vw;
    height: 100px;
  }

  span {
    background-color: #fff;
    font-size: 14px;
    color: #666;
    padding: 10px;
  }

  ul {
    background-color: white;

    li {
      font-size: 13px;
      cursor: pointer;
      color: #56b7ff;
      padding: 6px 10px;
      border-top: 1px solid #f2f2f2;
    }
  }
}

.mint-loadmore {
  height: 100%;
}

.mint-loadmore-text {
  color: #666;
  font-size: 14px;
}

.mini-im-chat-list {
  padding: 20px 10px;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;

  .message-loading {
    padding-bottom: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .mini-im-chat-item {
    display: flex;
    margin-bottom: 15px;

    .chat-avatar {
      width: 30px;
      height: 30px;
      flex-grow: 0;
      flex-shrink: 0;
      overflow: hidden;
      margin-top: 2px;
      box-shadow: 1px 1px 2px 0px rgba(0, 0, 0, 0.3);
      border-radius: 100%;

      img {
        width: 100%;
        height: 100%;
        border-radius: 100%;
      }
    }

    .chat-content {
      width: 100%;
      padding-left: 10px;

      .chat-username {
        display: flex;
        align-items: center;
        padding-bottom: 5px;

        span {
          font-size: 12px;
          color: #666;
          font-weight: 500;
        }

        em {
          color: #666;
          font-size: 12px;
          margin-left: 8px;
        }
      }

      .chat-body {
        display: flex;
        align-items: flex-end;

        .cancel-btn {
          font-size: 12px;
          color: #26a2ff !important;
          margin-right: 5px;
        }

        .text {
          padding: 5px 8px;
          background-color: #fff;
          border-radius: 3px;
          font-size: 14px;
          color: #333;
          max-width: 85%;
          position: relative;
          box-shadow: 1px 2px 2px 0px rgba(0, 0, 0, 0.1);
          -webkit-user-select: text;
          -moz-user-select: text;
          -o-user-select: text;
          user-select: text;
          word-break: break-all;

          &:before {
            content: '';
            display: block;
            position: absolute;
            top: 5px;
            left: -9px;
            width: 0;
            height: 0;
            overflow: hidden;
            font-size: 0;
            line-height: 0;
            border: 5px;
            border-radius: 2px;
            border-style: dashed solid dashed dashed;
            border-color: transparent #fff transparent transparent;
          }
        }

        .photo {
          display: flex;
          align-items: flex-end;

          img {
            width: 120px;
            display: block;
            border-radius: 5px;
            cursor: pointer;
          }

          span {
            font-size: 12px;
            color: #999;
            padding-right: 5px;
          }
        }

        .system {
          width: 100%;
          display: flex;
          flex-direction: column;
          justify-content: center;

          span {
            text-align: center;
            font-size: 12px;
            color: #999;
          }

          .content {
            margin-top: 1.5px;
            height: 25px;
            text-align: center;

            span {
              padding: 0 10px;
              text-align: center;
              font-size: 12px;
              border-radius: 5px;
              display: inline-block;
              line-height: 22px;
              height: 22px;
              min-width: 80px;
              color: #949393;
            }
          }
        }

        .knowledge {
          padding: 5px 8px;
          background-color: #fff;
          border-radius: 3px;
          font-size: 13px;
          color: #333;
          max-width: 80%;
          position: relative;
          box-shadow: 1px 2px 2px 0px rgba(0, 0, 0, 0.1);
          display: flex;
          flex-direction: column;
          align-items: flex-start;

          .title {
            min-height: 25px;
            font-size: 14px;
          }

          a {
            font-size: 13px;
            color: #26a2ff;
            text-decoration: none;
            width: 100%;
            display: flex;
            min-height: 25px;
          }
        }
      }
    }

    &.self {
      justify-content: flex-end;

      .chat-content {
        padding-right: 10px;
      }

      .chat-body {
        justify-content: flex-end;

        .text {
          box-shadow: -1px 1px 3px 0px rgba(0, 0, 0, 0.1);
          background-color: #26a2ff;
          color: #fff;
          -webkit-user-select: text;
          -moz-user-select: text;
          -o-user-select: text;
          user-select: text;
          word-break: break-all;

          &:before {
            left: inherit;
            right: -9px;
            border-style: dashed dashed dashed solid;
            border-color: transparent transparent transparent #26a2ff;
          }
        }
      }

      .chat-avatar {
        order: 1;
      }

      .chat-username {
        justify-content: flex-end;

        em {
          order: -2;
          margin-right: 5px;
        }
      }
    }
  }
}

// PC端兼容样式
.mini-im-pc-container {
  width: 360px;
  height: 500px;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  margin: auto;
  display: flex;
  flex-direction: column;
  padding: 0 !important;
  overflow: hidden;
  box-shadow: 1px 1px 8px 2px #ccc;

  .mini-im-loading, .mini-im-emoji {
    width: 360px !important;
    height: 500px !important;
    bottom: 0;
    margin: auto !important;
  }

  .mini-im-emoji {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
  }

  .cancel-btn {
    cursor: pointer;
  }

  .mini-im-emoji-content {
    padding: 8px !important;
    height: 465px !important;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;

    span {
      width: 26px;
      height: 26px;
      cursor: pointer;
    }
  }

  .mini-im-body {
    width: 360px;
    height: 500px;
    position: static !important;

    .mini-im-chat-list {
      padding: 15px !important;
    }
  }

  .mini-im-pc-header {
    z-index: 999999999 !important;
    height: 45px;
    background: linear-gradient(to right, #26a2ff, #736cde);
    flex-shrink: 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 10px;
    color: #fff;

    .right {
      display: flex;
      align-items: center;
      cursor: pointer;

      img {
        width: 20px;
        margin-right: 5px;
      }
    }

    .title {
      font-size: 14px;
      display: flex;
      align-items: center;

      img {
        width: 20px;
        margin-right: 5px;
      }
    }

    span {
      font-size: 14px;
    }

    .close-btn {
      width: 20px;
      height: 35px;
      text-align: right;
      line-height: 35px;
      cursor: pointer;
    }
  }

  .mini-im-tabbar-input {
    height: 130px;
    overflow: hidden;
    padding: 5px;
    position: relative;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    z-index: 9;

    textarea {
      height: 65px;
      padding-right: 5px;
      margin: 0;
    }

    .mini-input-send {
      height: 70px;
      width: 60px;
      background: linear-gradient(to right, #26a2ff, #736cde);
      color: #fff;
      border: 0;
      cursor: pointer;
      border-radius: 2px;
    }

    span.photo-btn {
      left: 3px;
    }

    span.expression-btn {
      left: 30px;
    }
  }
}

.bscroll-vertical-scrollbar {
  right: 0px !important;
  height: 100% !important;

  .bscroll-indicator {
    width: 4px !important;
    border: 0 !important;
    background: rgba(0, 0, 0, 0.2) !important;
    right: 0 !important;
  }
}
</style>
