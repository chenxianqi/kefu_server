
<template>
    <div class="workorder-view" :class="{'is-show-aside': !isShowAside}" v-show="value">
        <div class="mask" @dblclick="close"></div>
            <transition name="el-zoom-in-bottom">
            <div class="content" v-show="value">
                <div class="title">
                    <i class="el-icon-tickets"></i> 工单详细
                </div>
                <span class="close" @click="close"><i class="el-icon-close"></i></span>
                <div class="form-line">
                    <span class="lable"> 标题：</span>
                    <div class="con">{{showData.title}}</div>
                </div>
                <div class="form-line">
                    <span class="lable"> 手机：</span>
                    <div class="con">{{showData.phone}}</div>
                </div>
                <div class="form-line">
                    <span class="lable"> 邮箱：</span>
                    <div class="con">{{showData.email || '未预留邮箱'}}</div>
                </div>
                <div class="form-line">
                    <span class="lable"> 状态：</span>
                    <div class="con">
                        <span style="color:#e6a23c;" v-if="showData.status == 0">待处理</span>
                        <span style="color:#e6a23c;" v-if="showData.status == 1">待回复</span>
                        <span style="color:#67c23a;" v-if="showData.status == 2">已回复</span>
                        <span style="color:#909399;" v-if="showData.status == 3">已结束</span>
                    </div>
                </div>
                <div class="form-line">
                    <span class="lable"> 内容：</span>
                    <div class="con" v-html="showData.content"></div>
                </div>
            </div>
        </transition>
    </div>
</template>
<script>
import axios from "axios";
export default {
  name: "workorder-view",
  data() {
    return {
        workorder: null,
    };
  },
  props: {
    value: {
      default: false,
      type: Boolean
    },
    prop: Object
  },
  computed: {
    showData(){
        return this.workorder || this.prop
    },
    isShowAside(){
      return this.$store.state.isShowAside;
    }
  },
  methods: {
    // 按钮操作
    close() {
      this.$emit("input", false);
    },
    getWorkOrder(){
        axios
        .get("/public/workorder/" + this.prop.id)
        .then(response => {
          this.workorder = response.data.data;
          setTimeout(()=> this.$previewRefresh(), 500)
        })
    }
  },
  watch: {
      prop(){
          this.getWorkOrder()
          setTimeout(()=> this.$previewRefresh(), 500)
      }
  },
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
  .mask{
    width: 100%;
    height: 100%;
  }
  .content {
    width: 550px;
    height: 100%;
    background-color: #fff;
    position: fixed;
    right: 0px;
    left 260px
    margin 0 auto
    top: 30px;
    padding 10px
    overflow hidden
    overflow-y auto
    border-radius 5px 5px 0 0
    padding-top 50px
    .title{
        width 100%
        height 40px
        border-bottom 1px solid #ddd
        position absolute
        top 0
        left 0
        background-color #fff
        padding 10px 0 0 10px
        box-sizing border-box
    }
    .close{
        position absolute
        top 5px
        right 5px
        font-size 25px
        color #ccc
        cursor pointer
    }
    .form-line{
        margin-bottom 5px
        font-size 14px
        color #333
        display flex
        .lable{
            width: 50px
            flex-shrink 0
        }
        .con{
            flex-grow 1
        }
        img{
            width 30% ;
        }

    }
  }
  &.is-show-aside{
    left: 0;
    .content{
        left 0px
    }
  }
}
</style>

