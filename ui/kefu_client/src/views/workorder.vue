<template>
  <div class="container">
    
    <mt-header v-if="isShowHeader" fixed :title="isInputPongIng ? inputPongIngString : '在线客服'">
      <div slot="left">
        <mt-button @click="back" icon="back"></mt-button>
      </div>
      <mt-button @click="headRightBtn" slot="right">
        <img title="人工客服" v-if="!isArtificial" src="http://qiniu.cmp520.com/kefu_icon_2000.png" alt />
        <span v-else>结束会话</span>
      </mt-button>
    </mt-header>

  </div>
</template>
<script>
export default {
  name: "workorder",
  components: {},
  data() {
    return {};
  },
  mounted() {},
  methods: {}
};
</script>
<style lang="stylus" scoped>

</style>

