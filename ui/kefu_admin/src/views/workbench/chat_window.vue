<template>
  <div class="mini-im-chat-list">

    <div class="mini-im-chat-message-box">
      <div class="loading" v-show="loading">
        <i class="el-icon-loading"></i><span>消息加载中...</span>
      </div>
      <el-button v-show="isMessageEnd" type="text" disabled icon="el-icon-refresh-right">无更多聊天记录...</el-button>
      <el-button v-if="!isMessageEnd && !loading" type="text" @click="onLoadMor" icon="el-icon-refresh">点击加载更多聊天记录</el-button>
    </div>

    <div class="mini-im-chat-message-box">
      <div class="loading" v-show="messages.length <= 0 && !loading">
        <i class="el-icon-time"></i><span>暂无聊天记录...</span>
      </div>
    </div>

    <div class="mini-im-chat-message-box" :class="{'self': item.from_account != seviceCurrentUser.id}" v-for="(item, index) in messages" :key="index">
      
     

          <!-- 用户信息 -->
          <template v-if="item.biz_type == 'text' || item.biz_type == 'photo' || item.biz_type == 'knowledge' || item.biz_type == 'knowledge_list'">
            <div class="user-date">
              <span v-if="item.from_account == adminInfo.id">
                {{adminInfo.nickname || adminInfo.username}}
              </span>
              <span v-else-if="item.from_account == seviceCurrentUser.from_account">
                {{seviceCurrentUser.nickname}}
              </span>
              <span v-else>
                <span style="font-size:12px;color: #666;">(机器人)</span>{{$robotNickname(item.from_account)}}
              </span>
              <em>{{$formatFromNowDate(item.timestamp)}}</em>
            </div>
          </template>

          <!-- 文本消息 -->
          <template v-if="item.biz_type == 'text'">
            <div class="text">
              <div @click="()=>onCancelMessage(item.key)" title="撤回本条消息" class="cancel-btn" v-if="item.from_account == adminInfo.id  && item.isShowCancel">
                撤回
              </div>
              <span v-html="item.payload.replace(/\n/ig, '<br />')"></span>
            </div>
          </template>

          <!-- 图片 -->
          <template v-if="item.biz_type == 'photo'">
            <div class="photo">
              <div class="loading" v-if="item.percent && item.percent != 100">
                <i class="el-icon-loading"></i>
                <span>{{item.percent}}%</span>
              </div>
              <div @click="()=>onCancelMessage(item.key)" title="撤回本条消息" class="cancel-btn" v-if="item.from_account == adminInfo.id && item.isShowCancel">
                撤回
              </div>
              <div class="img-content">
                <img :src="item.payload" preview="1" />
              </div>
            </div>
          </template>

          <!-- 转接 -->
          <template v-if="item.biz_type == 'transfer'">
            <div class="system">
              <em>{{$formatFromNowDate(item.timestamp)}}</em>
              <span>{{item.payload}}</span>
            </div>
          </template>

          <!-- 结束聊天 -->
          <template v-if="item.biz_type == 'end'">
            <div class="system">
              <em>{{$formatFromNowDate(item.timestamp)}}</em>
              <span v-if="item.to_account != adminInfo.id">你结束了会话</span>
              <span v-else>对方结束了会话</span>
              <em>{{$formatFromNowDate(item.timestamp)}}</em>
            </div>
          </template>

           <!-- 聊天超时 -->
          <template v-if="item.biz_type == 'timeout'">
            <div class="system">
              <em>{{$formatFromNowDate(item.timestamp)}}</em>
              <span>{{item.payload}}</span>
            </div>
          </template>

          <!-- 撤回消息 -->
          <template v-if="item.biz_type == 'cancel'">
            <div class="system">
              <em>{{$formatFromNowDate(item.timestamp)}}</em>
              <span v-if="item.from_account == adminInfo.id">您撤回了一条消息</span>
              <span v-else>对方撤回了一条消息</span>
            </div>
          </template>

          <!-- 知识库列表 -->
          <template v-if="item.biz_type == 'knowledge'">
           <div class="knowledge">
              <div class="content">
                <div class="title">以下是否是您关心的相关问题呢？</div>
                <div class="item" :key="index" v-for="(item, index) in JSON.parse(item.payload)">
                  {{index+1}}.{{item.title}}
                </div>
              </div>
            </div>
          </template>

    </div>

  </div>
</template>
<script>
export default {
  name: "mini-im-contact",
  data() {
    return {};
  },
  computed: {
    seviceCurrentUser(){
      return this.$store.getters.seviceCurrentUser || {}
    },
    adminInfo(){
      return this.$store.getters.adminInfo || {}
    }
  },
  props: {
    loading: Boolean,
    onCancelMessage: Function,
    messages: Array,
    onLoadMor: Function,
    isMessageEnd: Boolean
  },
  watch:{
    messages(){
     setTimeout(()=>{
        this.$previewRefresh()
     }, 1000)
    }
  }
};
</script>
<style scoped lang="stylus">
.mini-im-chat-list {
  display: flex;
  flex-direction: column;

  .mini-im-chat-message-box {
    width: 100%;
    display: flex;
    flex-direction: column;
    margin-bottom: 15px;

    .user-date {
      display: flex;
      align-items: center;
      color: #999;
      font-size: 14px;

      span {
        color: #666;
        font-weight: 500;
        font-size: 14px;
        padding: 0 5px;
      }

      em {
        font-style: normal;
        font-size 12px
      }
    }

    .loading{
      color #666
      display: flex;
      margin-top: 5px;
      align-items center
      align-content center
      justify-content center
      span{
        margin-left 5px
        font-size 13px
      }
    }

    .text {
      display: flex;
      margin-top: 5px;
      word-break:break-all;
      span {
        max-width: 40%;
        display: inline;
        padding: 5px 10px;
        border-radius: 5px;
        background-color: #eef4f9;
        font-size: 14px;
        color: #666;
      }
    }

    .photo {
      display: flex;
      margin-top: 5px;

      .loading{
        align-self flex-end
        padding 0 5px
        span{
          background none !important
          color: #999 !important
        }
      }

      .img-content{
        border-radius: 5px;
        width: 200px;
        overflow hidden
      }

      img {
        cursor: pointer;
        width: 100%;
        height  100%
        display: inline;
      }
    }

    .knowledge {
      display: flex;
      margin-top: 5px;
      justify-content: flex-end;

      .content {
        display: flex;
        flex-direction: column;
        padding: 5px;
        border-radius: 5px;
        color: #666;
        text-align: left;
        background-color: #eef4f9;

        .title {
          font-size: 13px;
          font-weight: 500;
        }

        .item {
          font-size: 13px;
          line-height: 22px;
        }
      }
    }

    .system {
      display: flex;
      margin-top: 5px;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      em{
        margin-top: 5px;
        font-size: 12px;
        color: #999;
      }
      span {
        font-size: 12px;
        max-width: 50%;
        min-width: 100px;
        display: inline;
        padding: 3px 20px;
        border-radius: 5px;
        text-align: center;
        background-color: #f2f2f2;
        color: #999;
      }
    }

    &.self {
      text-align: right;

      .user-date {
        display: flex;
        justify-content: flex-end;

        span {
          order: -2;
        }

        em {
          order: -3;
        }
      }

      .text, .photo {
        justify-content: flex-end;
        align-items flex-end
        word-break:break-all;
        .cancel-btn{
          color #26a2ff
          font-size 12px
          margin-right 5px
          cursor pointer
        }
        span {
          background-color: rgba(33, 150, 243, 0.72);
          color: #fff;
          text-align left
        }
      }

      .knowledge>.content {
        background-color: rgba(33, 150, 243, 0.72);
        color: #fff;
      }
    }
  }
}
</style>
