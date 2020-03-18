<template>
  <el-popover
    placement="top-start"
    width="400"
    trigger="hover">
    <div class="emoji-box">
        <span @click="clickEmoji(item)" v-for="(item, index) in emojis" :key="index">{{item}}</span>
    </div>
    <button slot="reference" style="font-size: 20px" title="选择表情" class="mini-im-button">😊</button>
  </el-popover>
</template>
<script>
var emojiService = require("../../resource/emoji")
export default {
  name: 'mini-im-emoji',
  data(){
    return {
      emojis: emojiService.emojiData
    }
  },
  props: {
    clickEmoji: Function
  },
}
</script>
<style scoped lang="stylus">
  .mini-im-button{
    height 30px
    padding  0 5px
    border 0
    background-color  #fff
    cursor pointer
    color #666
    font-size 12px
    i{
      color #666
    }
  }
  .emoji-box{
    font-size 20px
    span{
      cursor pointer
      padding 2px
    }
  }
</style>
