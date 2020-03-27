
<template>
  <div class="workorder-view" v-show="value">
    <div class="mask" @dblclick="close"></div>
    <transition name="el-zoom-in-bottom">
      <div class="content-box" :class="{'padding-bottom30': showData.status == 3}" v-show="value">
        <div class="title">
          <i class="el-icon-tickets"></i> 工单详细
        </div>
        <div class="buttons">
          <el-button
            size="mini"
            @click="closeWorkorder"
            v-if="(showData.status == 1 || showData.status == 2) && showData.delete == 0"
            type="warning"
          >关闭工单</el-button>
          <el-button
            size="mini"
            @click="delWorkorder"
            v-if="showData.status == 3 && adminInfo.root == 1 && showData.delete == 0"
            type="danger"
          >删除工单</el-button>
          <div v-if="showData.delete == 1" style="font-size:13px;margin-top:5px;color:#f44336">该工单已删除</div>
        </div>
        <span class="close" @click="close">
          <i class="el-icon-close"></i>
        </span>
        <div class="content">
          <div class="scroll">
            <div class="form-line">
              <span class="lable">标题：</span>
              <div class="con">{{showData.title}}</div>
            </div>
            <div class="form-line">
              <span class="lable">用户：</span>
              <div class="con">{{showData.u_nickname}}</div>
            </div>
            <div class="form-line">
              <span class="lable">手机：</span>
              <div class="con">{{showData.phone}}</div>
            </div>
            <div class="form-line">
              <span class="lable">邮箱：</span>
              <div class="con">{{showData.email || '未预留邮箱'}}</div>
            </div>
            <div class="form-line">
              <span class="lable">类型：</span>
              <div class="con">{{typeName || '---'}}</div>
            </div>
            <div class="form-line">
              <span class="lable">状态：</span>
              <div class="con">
                <span style="color:#f56c6b" v-if="showData.status == 0">待客服处理</span>
                <span style="color:#e6a23c;" v-if="showData.status == 2">待客服回复</span>
                <span style="color:#67c23a;" v-if="showData.status == 1">客服已回复</span>
                <span style="color:#909399;" v-if="showData.status == 3">工单已结束</span>
              </div>
            </div>
            <div class="form-line">
              <span class="lable">内容：</span>
              <div class="con" v-html="showData.content"></div>
            </div>
            <el-divider style="height:10px;" />
            <div class="comments">
              <div class="no-data" v-if="comments.length <= 0 && !isShowGetCommentsLoading">暂无回复内容~</div>
              <div class="comments-loading" v-if="isShowGetCommentsLoading">
                <i class="el-icon-loading"></i>
                <span>正在努力加载中~</span>
              </div>
              <template v-else v-for="(item,index) in comments">
                <div :key="index" class="item">
                  <div class="avatar">
                    <img
                      v-if="item.aid == adminInfo.id"
                      :src="adminInfo.avatar || 'http://qiniu.cmp520.com/avatar_degault_3.png'"
                      alt
                    />
                    <img
                      v-else
                      :src="item.a_avatar || 'http://qiniu.cmp520.com/avatar_degault_3.png'"
                      alt
                    />
                  </div>
                  <div class="right">
                    <div class="nickname" v-if="item.aid == 0">{{item.u_nickname}}</div>
                    <div class="nickname" v-else>{{item.a_nickname}}</div>
                    <div class="detail" v-html="item.content"></div>
                    <div class="date">{{$formatDate(item.create_at)}}</div>
                  </div>
                </div>
              </template>
              <div class="workorder-close" v-if="showData && showData.status == 3">工单已结束~</div>
            </div>
          </div>
        </div>
        <div class="file-view" v-if="request.source != '' || isShowUploadLoading">
          <span v-if="isShowUploadLoading">
            <i class="el-icon-loading"></i>
            <i>上传中~</i>
          </span>
          <span v-else>
            <i class="el-icon-paperclip"></i>
            <i>你已成功添加附件，重新上传可替换~</i>
          </span>
        </div>
        <div class="input-form" v-if="showData.status != 3">
          <textarea v-model="request.content" @blur="inputBlur()" placeholder="请输入内容~"></textarea>
          <span class="icon-btn">
            <input title="添加附件" type="file" @change="uploadFile" onclick="this.value = null" />
          </span>
          <el-button type="primary" @click="reply()">提交</el-button>
        </div>
      </div>
    </transition>
  </div>
</template>
<script>
import axios from "axios";
import { mapGetters } from "vuex";
import upload from "../../common/upload";
export default {
  name: "workorder-view",
  data() {
    return {
      isShowUploadLoading: false,
      isShowGetCommentsLoading: false,
      isSubmit: false,
      workorder: null,
      comments: [],
      fileType: "",
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
    prop: Object,
    workorderTypes: Array
  },
  created() {
    this.comments = [];
  },
  computed: {
    showData() {
      return this.workorder || this.prop;
    },
    isShowAside() {
      return this.$store.state.isShowAside;
    },
    typeName(){
      try{
        return this.workorderTypes.filter((i)=>i.id == this.showData.tid)[0].title
      }catch(e){
        return ""
      }
    },
    ...mapGetters(["adminInfo", "uploadToken"])
  },
  methods: {
    // 按钮操作
    close() {
      this.$emit("input", false);
    },
    getWorkOrder() {
      axios.get("/public/workorder/" + this.prop.id).then(response => {
        if (response.data.data != null) this.workorder = response.data.data;
        setTimeout(() => this.$previewRefresh(), 500);
      });
    },
    getComments() {
      this.isShowGetCommentsLoading = true;
      axios
        .get("/public/workorder/comments/" + this.prop.id)
        .then(response => {
          if (response.data.data != null) this.comments = response.data.data;
          setTimeout(() => this.$previewRefresh(), 500);
          this.isShowGetCommentsLoading = false;
        })
        .catch(error => {
          console.log(error);
          this.isShowGetCommentsLoading = false;
          this.$message.error("加载失败，请刷新尝试~");
        });
    },
    closeWorkorder() {
      this.$prompt("请输入关闭原因！", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        inputPattern: /\S/,
        inputErrorMessage: "关闭工单原因不能为空~"
      }).then(({ value }) => {
        const wid = this.showData.id;
        let remark = value
        axios
          .post("/workorder/close", { wid, remark })
          .then(() => {
            this.getWorkOrder()
            this.$notify({
              title: "温馨提示！",
              message: "工单已关闭~",
              showClose: false,
              type: "success"
            });
          })
          .catch(() => {
            this.$message.error("工单关闭失败~");
          });
      });
    },
    delWorkorder() {
        this.$confirm('您确定删除该工单吗?', '温馨提示！', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
        const wid = this.showData.id;
        axios
          .delete("/public/workorder/" +wid)
          .then(() => {
              this.$notify({
                title: "温馨提示！",
                message: "工单已删除~",
                showClose: false,
                type: "success"
              });
              this.close()
          })
          .catch(() => {
            this.$message.error("工单删除失败~");
          });
      });
    },
    reply() {
      const content = this.request.content + this.request.source;
      if (content.trim() == "") {
        this.$message.error("请输入内容~");
        return;
      }
      if (this.isSubmit) return;
      this.isSubmit = true;
      const wid = this.showData.id;
      axios
        .post("/public/workorder/reply", { wid, content })
        .then(response => {
          this.isSubmit = false;
          console.log(response);
          this.getComments();
          this.request = {
            source: "",
            content: ""
          };
          this.$notify({
            title: "温馨提示！",
            message: "回复成功~",
            showClose: false,
            type: "success"
          });
          setTimeout(() => {
            var sBoxHeight = document.querySelector(".content").clientHeight;
            var sHeight = document.querySelector(".scroll").clientHeight;
            document.querySelector(".content").scrollTop =
              sHeight - sBoxHeight + 20;
          }, 500);
        })
        .catch(error => {
          this.isSubmit = false;
          console.log(error);
          this.$message.error("提交失败~");
        });
    },
    inputBlur() {
      setTimeout(() => {
        document.body.scrollTo = 0;
        window.scrollTo(0, 0);
      }, 100);
    },
    uploadFile(e) {
      var fileDom = e.target;
      var file = fileDom.files[0];
      this.isShowUploadLoading = true;
      const self = this;
      upload({
        file,
        mode: this.uploadToken.mode,
        progress() {},
        success(src) {
          self.isShowUploadLoading = false;
          var html;
          var fullPath = self.uploadToken.host + "/" + src;
          var fileType = src.substr(src.lastIndexOf(".") + 1);
          if ("jpg,jpeg,png,JPG,JPEG,PNG".indexOf(fileType) != -1) {
            html =
              "<br><img style='max-width:45%;margin-top:5px;' preview='1' src='" +
              fullPath +
              "' />";
          } else {
            html =
              "<br><img style='width:20px;height:20px;top:3px; right:3px;position: relative;' preview='1' src='http://qiniu.cmp520.com/fj.png' />";
            html +=
              "<a target='_blank' style='color: #2e9dfc;' href='" +
              fullPath +
              "'>下载附件</a>";
          }
          self.request.source = html;
          self.$notify({
            title: "温馨提示！",
            message: "上传成功~",
            showClose: false,
            type: "success"
          });
        },
        error(e) {
          self.isShowUploadLoading = false;
          if (e.response && e.response.data) {
            self.$message.error(e.response.data.message);
            return;
          }
        }
      });
    }
  },
  watch: {
    prop() {
      this.getWorkOrder();
      setTimeout(() => {
        this.$previewRefresh();
        this.getComments();
      }, 500);
    }
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

  .no-data {
    color: #666;
    font-size: 14px;
  }

  .workorder-close, .comments-loading {
    text-align: center;
    color: #666;
    font-size: 14px;
    padding: 10px;
  }

  .comments {
    padding: 10px;

    .item {
      display: flex;

      .avatar {
        padding-top: 10px;

        img {
          width: 30px;
          height: 30px;
          border-radius: 100px;
          display: block;
        }

        border-bottom: 1px solid rgba(158, 158, 158, 0.13);
      }

      .right {
        padding: 10px 5px;
        flex-grow: 1;
        border-bottom: 1px solid rgba(158, 158, 158, 0.13);

        .nickname {
          font-size: 15px;
          color: #333;
        }

        .detail {
          font-size: 15px;
          color: #333;
          margin-top: 5px;
        }

        .date {
          color: #999;
          font-size: 14px;
          margin-top: 5px;
        }
      }

      &:last-child {
        .right, .avatar {
          border-bottom: 0;
        }
      }
    }
  }

  .content-box {
    width: 600px;
    height: 100%;
    background-color: #fff;
    position: fixed;
    right: 0px;
    left: 260px;
    margin: 0 auto;
    top: 30px;
    overflow: hidden;
    border-radius: 5px 5px 0 0;
    padding-top: 40px;
    padding-bottom: 135px;
    box-sizing: border-box;
    &.padding-bottom30{
      padding-bottom: 30px;
    }

    .content {
      box-sizing: border-box;
      width: 100%;
      padding: 0 10px;
      height: 100%;
      overflow: hidden;
      overflow-y: auto;
      padding-top: 10px;
      position: relative;
      padding-bottom: 20px;
    }

    .file-view {
      position: absolute;
      bottom: 135px;
      left: 0;
      right: 0;
      padding: 5px 10px;
      margin: 0 auto;
      font-size: 13px;
      color: #8bc34a;

      span {
        display: flex;
        align-content: center;
        align-items: center;

        img {
          width: 20px;
          height: 20px;
        }

        i {
          font-style: normal;
          margin-left: 5px;
        }
      }
    }

    .input-form {
      position: absolute;
      bottom: 35px;
      left: 0;
      right: 0;
      margin: 0 auto;
      width: 100%;
      height: 100px;
      background-color: #fff;
      border-top: 1px solid rgba(158, 158, 158, 0.13);
      display: flex;
      justify-content: space-between;
      padding: 10px 10px 0;
      box-sizing: border-box;
      align-content: center;
      align-items: center;

      textarea {
        height: 90%;
        flex-grow: 1;
        border-radius: 0;
        border: 0;
        color: #333;
        font-size: 14px;
        resize: none;
      }

      .icon-btn {
        background: url('../../assets/upload.png') center center no-repeat;
        background-size: 30px;
        width: 55px;
        height: 55px;
        overflow: hidden;

        input {
          display: block;
          width: 100%;
          height: 100%;
          font-size: 100px;
          opacity: 0;
        }
      }
    }

    .title {
      width: 100%;
      height: 40px;
      border-bottom: 1px solid #ddd;
      position: absolute;
      top: 0;
      left: 0;
      background-color: #fff;
      padding: 10px 0 0 10px;
      box-sizing: border-box;
    }

    .buttons {
      position: absolute;
      top: 5px;
      right: 50px;
    }

    .close {
      position: absolute;
      top: 5px;
      right: 5px;
      font-size: 25px;
      color: #ccc;
      cursor: pointer;
    }

    .form-line {
      margin-bottom: 5px;
      font-size: 14px;
      color: #333;
      display: flex;

      .lable {
        width: 50px;
        flex-shrink: 0;
      }

      .con {
        flex-grow: 1;
      }

      img {
        width: 30%;
      }
    }
  }
}
</style>

