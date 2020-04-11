<template>
  <div class="container">
    <mt-header v-if="isShowHeader" fixed title="创建工单">
      <div slot="left">
        <mt-button @click="$router.go(-1)" icon="back"></mt-button>
      </div>
    </mt-header>
    <div class="content" :class="{'hide-header': !isShowHeader}">

      <div class="field-line arrow-right" @click="isShowTypesPicker = true">
        <span>类型:</span>
        <span>{{selectTyped || '选择工单分类'}}</span>
      </div>
      <div class="field-line algin-left">
        <span>标题:</span>
        <input type="text" v-model="request.title" placeholder="请输入工单标题~">
      </div>
      <div class="field-line algin-left">
        <span>手机:</span>
        <input type="number" v-model="request.phone" placeholder="请输入您的手机~">
      </div>
      <div class="tip">必填，预留手机号方便客服联系到您~</div>
      <div class="field-line algin-left">
        <span>邮箱:</span>
        <input type="email" v-model="request.email" placeholder="请输入您的电子邮箱~">
      </div>
      <div class="tip">非必填，预留邮箱后若工单回复后会通过邮箱通知您~</div>
      <div class="field-line textarea">
        <span>内容:</span>
        <textarea v-model="request.content" placeholder="请输入您的工单内容~"></textarea>
      </div>
      <div class="field-line arrow-right file">
        <span>附件:</span>
        <span :class="{'ed': source != ''}">{{source ? '已上传附件，重新上传可替换~' : '上传附件'}}</span>
        <input type="file" @change="uploadFile" />
      </div>
      <div class="tips">温馨提示：由于客服值班时间原因，工单回复较慢，请您耐心等待~</div>
      <span class="sub-btn" @click="submit()">提交</span>
    </div>

    <!-- types-sheet -->
    <div class="types-sheet" v-if="isShowTypesPicker">
      <!-- <div class="mask" @click="isShowTypesPicker = false"></div> -->
      <div class="picker-box">
        <div class="title">
          <span>选择工单类型</span>
          <span class="sub-btn" @click="isShowTypesPicker = false">确定</span>
        </div>
        <mt-picker :slots="types" @change="onValuesChange"></mt-picker>
      </div>
    </div>

  </div>
</template>
<script>
import { mapGetters } from "vuex";
import { Toast } from "mint-ui";
import axios from "axios";
export default {
  name: "workorder_create",
  components: {},
  data() {
    return {
      isSubmit: false,
      request: {
        "tid": 0,
        "title": "",
        "content": "",
        "phone": "",
        "email": ""
      },
      selectTyped: "",
      source: "",
      isShowTypesPicker: false
    };
  },
  computed: {
    ...mapGetters([
      "isShowHeader",
      "workorders",
      "userInfo",
      "workorderTypes",
      "configs",
      "workorderTypes"
    ]),
    types() {
      var values = [];
      var slot = [
        {
          flex: 1,
          values: [],
          className: "workorder-create-picker",
          textAlign: "center"
        }
      ];
      for (var i = 0; i < this.workorderTypes.length; i++) {
        values.push(this.workorderTypes[i].title);
      }
      slot[0].values = values;
      return slot;
    }
  },
  mounted() {
    
  },
  methods: {
    onValuesChange(_, values) {
      this.selectTyped = values[0]
      for(var i=0; i<this.workorderTypes.length; i++){
        if(values[0] == this.workorderTypes[i].title){
          this.request.tid = this.workorderTypes[i].id
          break
        }
      }
      console.log(_)
    },
    uploadFile(e) {
      var fileDom = e.target;
      var file = fileDom.files[0];
      this.isShowUploadLoading = true;
      const self = this;
      this.$uploadFile({
        file,
        secret: this.configs.upload_secret,
        mode: this.configs.upload_mode,
        // 七牛才会执行
        percent() {},
        success(src) {

          self.isShowUploadLoading = false;
          var html
          var fullPath = self.configs.upload_host + "/" + src;
          var fileType = src.substr(src.lastIndexOf(".") + 1);
          if ("jpg,jpeg,png,JPG,JPEG,PNG".indexOf(fileType) != -1) {
              html = "<br><img style='max-width:45%;margin-top:5px;' preview='1' src='" + fullPath + "' />"
          }else{
              html = "<br><img style='width:20px;height:20px;top:3px; right:3px;position: relative;' preview='1' src='http://qiniu.cmp520.com/fj.png' />"
              html += "<a target='_blank' style='color: #2e9dfc;' href='"+fullPath+"'>下载附件</a>"
          }
          self.source = html
          Toast({
            message: "上传成功~"
          });
        },
        fail(e) {
          self.isShowUploadLoading = false;
          if (e.response && e.response.data) {
            Toast({
              message: e.response.data.message
            });
            return;
          }
        }
      });
    },
    submit(){
      if(this.request.tid == 0){
        Toast({
          message: "请选择工单类型！"
        });
        return
      }
      if(this.request.title.trim() == ""){
        Toast({
          message: "工单标题不能为空！"
        });
        return
      }
      if(this.request.content.trim() == ""){
        Toast({
          message: "工单内容不能为空！"
        });
        return
      }
      if(this.isSubmit) return
      this.isSubmit = true
      this.request.content += this.source
      axios
        .post("/public/workorder/create", this.request)
        .then(response => {
          this.isSubmit = false
          Toast({
            message: "工单创建成功~"
          });
          setTimeout(()=>this.$router.replace("/workorder/detail/"+response.data.data), 500)
        })
        .catch(error => {
          this.isSubmit = false
          Toast({
            message: error.response.data.message
          });
          console.log(error);
        });
    }
  }
};
</script>
<style lang="stylus" scoped>
.content {
  padding 50px 10px
  .field-line{
    display flex
    justify-content space-between
    box-sizing border-box
    height 45px
    border-bottom 1px solid #ddd
    align-content center
    align-items center
    font-size 14px
    color #333
    span:first-child{
      width 35px
    }
    input{
      flex-grow 1
      padding-left 10px
      height 100%
      background none 
      border 0
      color #333
      font-size 14px
      border-radius 0
    }
    &.algin-left{
      align-content left 
      align-items left
    }
    &.arrow-right{
      background url(./../assets/arrow.png) right center no-repeat
      background-size  18px
      padding-right 25px
    }
    &.file{
      position relative
      overflow hidden
      margin-top 20px
      border-top 1px solid #ddd
      .ed{
        color #8bc34a
      }
      input{
        font-size 100px
        opacity 0
        position absolute
        top 0
        right 0
      }
    }
    &.textarea{
      align-items start
      align-content start
      border-bottom 0
      padding-top 10px
      height 100px
      textarea{
        flex-grow 1
        border 0
        height 100%
        resize none
        color #333
        font-size 14px
        padding 3px 10px
        background-color rgba(0, 0, 0, 0.03);
        border-radius 3px
      }
    }
  }
  .tip{
    font-size 11px
    color #ff9800
  }
  &.hide-header {
    padding-top: 0;
  }
  .sub-btn {
    display: block;
    width: 100%;
    height: 45px;
    color: #fff;
    margin-top 30px
    line-height: 45px;
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
.types-sheet{
  width 100vw;
  height 100vh
  position fixed
  top 0
  left 0
  right 0
  bottom 0
  margin auto
  background-color rgba(0,0,0,.5)
  // .mask{
  //   width 100vw;
  //   height 100vh
  //   background-color rgba(0,0,0,.5)
  // }
  .picker-box{
    height 250px
    width 100vw
    position absolute
    bottom 0
    left 0
    right 0
    margin 0 auto
    background-color #fff
  }
  .title{
    height 35px
    border-bottom 1px solid #f3f3f3
    display flex
    justify-content space-between
    padding 0 10px
    box-sizing border-box
    align-content center
    align-items center
    span{
      font-size 14px
      color #333
    }
    .sub-btn {
      display: block;
      width: 55px;
      height: 30px;
      color: #26a2ff
      line-height: 30px;
      text-align: right;
      font-size: 14px;
      font-weight 900
      &:active {
        opacity: 0.8;
      }
    }
  }
}
.tips{
  font-size 12px
  color red
  padding 10px 0
}
</style>

