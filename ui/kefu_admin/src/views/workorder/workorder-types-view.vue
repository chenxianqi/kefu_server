
<template>
  <div class="workorder-view" v-show="value">
    <div class="mask" @dblclick="close"></div>
    <div class="content-box">
      <el-row type="flex" class="title" >
        <span><i class="el-icon-tickets"></i> 分类设置</span>
       <div>
          <el-button size="mini" type="primary">添加分类</el-button>
       </div>
      </el-row >
      <span class="close" @click="close">
        <i class="el-icon-close"></i>
      </span>
      <div class="content">
        <div class="scroll">

        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "workorder-view",
  data() {
    return {
      isSubmit: false,
      comments: [],
      request: {
        source: "",
        content: ""
      }
    };
  },
  props: {
    value: {
      default: false,
      type: Boolean
    },
    workorderTypes: Array
  },
  created() {
    this.comments = [];
  },
  computed: {
    isShowAside() {
      return this.$store.state.isShowAside;
    },
  },
  methods: {
    // 按钮操作
    close() {
      this.$emit("input", false);
    },
  },
  watch: {
  }
};
</script>
<style scoped lang="stylus">
.workorder-view {
  width: 100vw;
  height: 100vh;
  position: fixed;
  right: 0;
  top: 0px;
  left: 0px;
  background-color: rgba(0, 0, 0, 0.8);
  z-index: 9;

  .mask {
    width: 100%;
    height: 100%;
  }
  .content-box {
    width: 400px;
    height: 100%;
    background-color: #fff;
    position: fixed;
    right: 0px;
    margin: 0 auto;
    top: 0px;
    overflow: hidden;
    padding-top: 40px;
    padding-bottom: 135px;
    box-sizing: border-box;
   


    .title {
      width: 100%;
      height: 60px;
      border-bottom: 1px solid #ddd;
      position: absolute;
      top: 0;
      left: 0;
      padding 0 10px
      background-color: #fff;
      box-sizing: border-box;
      &>span{
        width 260px;
      }
      align-content center
      align-items center
    }

    .buttons {
      position: absolute;
      top: 5px;
      right: 50px;
    }

    .close {
      position: absolute;
      top: 15px;
      right: 5px;
      font-size: 25px;
      color: #ccc;
      cursor: pointer;
    }
  }
}
</style>

