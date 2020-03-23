<template>
  <div class="container">
    <mt-header v-if="isShowHeader" fixed title="工单详细">
      <div slot="left">
        <mt-button @click="$router.go(-1)" icon="back"></mt-button>
      </div>
      <mt-button @click="close()" v-if="workorder.status != 3" slot="right">
        <span>关闭工单</span>
      </mt-button>
      <mt-button @click="del()" v-else slot="right">
        <span>删除</span>
      </mt-button>
    </mt-header>
    <div class="content" :class="{'hide-header': !isShowHeader}">
      <div class="head">
        <div class="con">
          <span>标题：</span>
          <span>{{workorder.title}}</span>
        </div>
        <div class="con">
          <span>内容：</span>
          <span v-html="workorder.content"></span>
        </div>
        <div class="con">
          <span>电话：</span>
          <span>{{workorder.phone || '未预留电话号码'}}</span>
        </div>
        <div class="con">
          <span>邮箱：</span>
          <span>{{workorder.email || '未预留邮箱'}}</span>
        </div>
        <div class="con">
          <span>时间：</span>
          <span>{{$formatDate(workorder.create_at)}}</span>
        </div>
        <div class="con">
          <span>状态：</span>
          <span>
            <i v-if="workorder.status == 1" style="color:#8bc34a;">已回复</i>
            <i v-if="workorder.status == 3" style="color:#ccc">已结束</i>
            <i v-if="workorder.status == 0" style="color:#FF9800">待处理</i>
            <i v-if="workorder.status == 2" style="color:#FF9800">待回复</i>
          </span>
        </div>
      </div>
      <div class="comments">
        <div class="no-data" v-if="comments.length <= 0">暂无回复内容,请您耐心等待~</div>
        <template v-else v-for="(item,index) in comments">
          <div :key="index" class="item">
            <div class="avatar">
              <img
                v-if="item.aid == '0'"
                :src="userInfo.avatar || 'http://qiniu.cmp520.com/avatar_degault_3.png'"
                alt
              />
              <img v-else :src="item.avatar || 'http://qiniu.cmp520.com/avatar_degault_3.png'" alt />
            </div>
            <div class="right">
              <div class="nickname" v-if="item.aid == '0'">我</div>
              <div class="nickname" v-else>{{item.nickname}}</div>
              <div class="detail" v-html="commentView(item.content)"></div>
              <div class="date">{{$formatDate(item.create_at)}}</div>
            </div>
          </div>
        </template>
        <div class="workorder-close" v-if="workorder.status == 3">工单已结束~</div>
      </div>
      <div class="file-view" v-if="request.file != '' || isShowUploadLoading">
        <span v-if="isShowUploadLoading">
          <img src="./../assets/loading.gif" alt />
          <i>上传中~</i>
        </span>
        <span v-else>
          <img src="./../assets/fujian1.png" alt />
          <i>你已成功添加附件，重新上传可替换~</i>
        </span>
      </div>
      <div class="input-form" v-if="workorder.status != 3">
        <textarea v-model="request.content" @blur="inputBlur()" placeholder="请输入内容~"></textarea>
        <span class="icon-btn">
          <input type="file" @change="uploadFile" onclick="this.value = null" />
        </span>
        <span class="sub-btn" @click="reply()">提交</span>
      </div>
    </div>
  </div>
</template>
<script>
import { mapGetters } from "vuex";
import { Toast, MessageBox } from "mint-ui";
import axios from "axios";
export default {
  name: "workorder_detail",
  components: {},
  data() {
    return {
      isShowUploadLoading: false,
      isSubmit: false,
      workorder: {},
      comments: [],
      fileType: "",
      request: {
        file: "",
        content: ""
      }
    };
  },
  computed: {
    ...mapGetters([
      "isShowHeader",
      "workorders",
      "userInfo",
      "workorderTypes",
      "uploadToken"
    ])
  },
  created() {
    document.title = "工单详细";
    const id = this.$route.params.id;
    this.$store.commit("updateState", { isShowPageLoading: true });
    axios.all([this.getWorkOrder(id), this.getComments(id)]).then(
      axios.spread(() => {
        this.$store.commit("updateState", { isShowPageLoading: false });
      })
    );
  },
  methods: {
    commentView(comment) {
      var res = comment.match(/\[file=(.*)\]/);
      if (res == null) return comment;
      var fileType = res[1].substr(res[1].lastIndexOf(".") + 1);
      if ("jpg,jpeg,png,JPG,JPEG,PNG".indexOf(fileType) != -1) {
        comment = comment.replace(
          res[0],
          "<br><img style='max-width:60%' preview='1' src='" + res[1] + "' />"
        );
        this.$previewRefresh();
      }
      return comment;
    },
    getWorkOrder(id) {
      return axios
        .get("/public/workorder/" + id)
        .then(response => {
          this.workorder = response.data.data;
        })
        .catch(error => {
          console.log(error);
        });
    },
    getComments(id) {
      return axios
        .get("/public/workorder/comments/" + id)
        .then(response => {
          if (response.data.data == null) return;
          this.comments = response.data.data;
        })
        .catch(error => {
          console.log(error);
        });
    },
    reply() {
      const content = this.request.content + this.request.file;
      if (content.trim() == "") {
        Toast({
          message: "请输入内容~"
        });
        return;
      }
      if (this.isSubmit) return;
      this.isSubmit = true;
      const wid = this.workorder.id;
      axios
        .post("/public/workorder/reply", { wid, content })
        .then(response => {
           this.isSubmit = false
          console.log(response);
          this.getComments(wid);
          this.request = {
            file: "",
            content: ""
          };
        })
        .catch(error => {
          this.isSubmit = false
          console.log(error);
          Toast({
            message: "提交失败~"
          });
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
      this.$uploadFile({
        file,
        mode: this.uploadToken.mode,
        // 七牛才会执行
        percent() {},
        success(src) {
          self.request.file =
            "[file=" + self.uploadToken.host + "/" + src + "]";
          self.isShowUploadLoading = false;
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
    close() {
      var wid = this.workorder.id;
      MessageBox.confirm("您确定关闭该工单吗?").then(() => {
        axios
          .put("/public/workorder/close/" + wid)
          .then(response => {
            console.log(response);
            Toast({
              message: "工单已关闭~"
            });
            this.getWorkOrder(wid);
          })
          .catch(error => {
            Toast({
              message: "工单关闭失败~"
            });
            console.log(error);
          });
      });
    },
    del() {
      var wid = this.workorder.id;
      MessageBox.confirm("您确定删除该工单吗?").then(() => {
        axios
          .delete("/public/workorder/" + wid)
          .then(response => {
            console.log(response);
            Toast({
              message: "工单已删除~"
            });
            setTimeout(() => this.$router.go(-1));
          })
          .catch(error => {
            Toast({
              message: "工单关闭失败~"
            });
            console.log(error);
          });
      });
    }
  }
};
</script>
<style lang="stylus" scoped>
.container {
  height: 100vh;
  overflow: hidden;
  overflow-y: auto;
}

.content {
  padding-top: 50px;
  padding-bottom: 90px;

  .no-data {
    color: #666;
    font-size: 14px;
  }

  .workorder-close {
    text-align: center;
    color: #666;
    font-size: 14px;
    padding: 10px;
  }

  &.hide-header {
    padding-top: 0;
  }

  .head {
    margin: 0 10px;
    padding: 10px 0;
    border-bottom: 1px solid rgba(158, 158, 158, 0.13);

    .con {
      font-size: 15px;
      color: #333;
      display: flex;
      margin-bottom: 8px;

      span {
        flex-flow: 1;
      }

      span:first-child {
        flex-flow: 0;
        flex-shrink: 0;
        width: 45px;
      }

      i {
        font-style: normal;
      }
    }
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

  .file-view {
    position: fixed;
    bottom: 80px;
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
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    margin: 0 auto;
    width: 100%;
    height: 80px;
    background-color: #fff;
    border-top: 1px solid rgba(158, 158, 158, 0.13);
    display: flex;
    justify-content: space-between;
    padding: 0 10px;
    box-sizing: border-box;
    align-content: center;
    align-items: center;

    textarea {
      height: 45px;
      flex-grow: 1;
      border-radius: 0;
      border: 0;
      color: #333;
      font-size: 14px;
      resize: none;
    }

    .icon-btn {
      background: url('./../assets/upload.png') center center no-repeat;
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

    .sub-btn {
      display: block;
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
}
</style>

