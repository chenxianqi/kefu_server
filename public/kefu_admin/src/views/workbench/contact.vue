<template>

    <div class="mini-im-chat-item">
           <span @click.capture="deleteContact(item)" class="delete_contact" title="删除该记录"> <i class="el-icon-close"></i></span>
            <el-avatar @click="clickItem(item)" class="mini-im-avatar">
              <img v-if="item.avatar != ''" :src="item.avatar"/>
              <template v-else>访</template>
            </el-avatar>
          <div @click="clickItem(item)" class="mini-im-message-box">
            <div class="mini-im-user-date">
              <div class="mini-im-nickname">
                  <span class="mini-im-online-status" :class="{'success': item.online == 1}">●</span> {{item.nickname}}
              </div>
              <div class="mini-im-date">
                  {{$formatFromNowDate(item.contact_create_at)}}
              </div>
            </div>
            <div class="mini-im-message-badge">
              <div v-if="item.last_message_type == 'text'" class="mini-im-message">{{item.last_message}}</div>
              <div v-if="item.last_message_type == 'photo'" class="mini-im-message">收到图片文件</div>
              <div v-if="item.last_message_type == 'video'" class="mini-im-message">收到视频文件</div>
              <div v-if="item.last_message_type == 'end'" class="mini-im-message">会话结束</div>
              <div v-if="item.last_message_type == 'cancel'" class="mini-im-message">对方撤回了一条消息</div>
              <div v-if="item.last_message_type == 'timeout'" class="mini-im-message">会话超时，结束对话</div>
              <div v-if="item.last_message_type == 'transfer' || item.last_message_type == 'handshake'" class="mini-im-message">客服转接...</div>
              <div v-if="item.read > 0" class="mini-im-badge">{{item.read}}</div>
            </div>
          </div>
      </div>

</template>
<script>
export default {
  name: 'mini-im-contact',
  data(){
    return {
    }
  },
  props: {
    item: Object,
    clickItem: Function,
    deleteContact: Function,
  },
}
</script>
<style scoped lang="stylus">
  .mini-im-chat-item{
        padding  10px
        cursor pointer
        display  flex
        border-left 3px solid #fff
        border-bottom 1px solid rgba(175, 175, 175, 0.11)
        position relative
        &:hover{
          border-left 3px solid #ff5722
          background-color #f3f3f3
          .delete_contact{
            display block
          }
        }
        .mini-im-avatar{
          align-self center
          flex-shrink 0
        }
        &::last-child{
          border-bottom 0
        }
        .delete_contact{
          position absolute
          left 0
          top 0
          color #999
          display none
        }
        .mini-im-message-box{
          width 180px
          flex-grow 1
          padding 8px 0
          padding-left 10px
          display  flex
          flex-direction column
          justify-content space-around
          box-sizing border-box
          font-size 14px
          .mini-im-nickname{
            font-size 14px
            color #666
            font-weight 600
            margin-bottom 5px
            .mini-im-online-status{
              font-size 12px
              color #9e9e9e
              &.success{
                color #aadc97
              }
            }
          }
          .mini-im-user-date,.mini-im-message-badge{
            display flex
            justify-content space-between
          }
          .mini-im-badge{
              width  20px
              height 20px
              border-radius 100%
              background-color #f56c6c
              text-align center
              color #ffffff
              line-height 20px
              font-size 12px
              flex-shrink  0
          }
          .mini-im-message{
            font-size 13px
            color #999
            text-overflow: ellipsis
            white-space: nowrap
            overflow:hidden
            padding-right 5px
          }
          .mini-im-date{
            font-size 12px
            color #999
          }
        }
      }
      .mini-im-chat-item-active{
        border-left 3px solid #ff5722
        background-color #f4f5f7
      }
</style>
