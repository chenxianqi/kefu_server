<template>
  <el-dialog
    width="600px" 
    title="修改客服资料"
    :show-close="false"
    :visible.sync="dialogFormVisible"
    :close-on-click-modal="false"
  >
    <el-form :model="form">
      <el-form-item label="头像" :label-width="formLabelWidth">
        <el-row :gutter="10">
          <el-col :span="3">
            <div class="mini-im-file-button" title="点击上传图片">
              <el-avatar
                :size="50"
                :src="form.avatar || $store.state.avatar"
              ></el-avatar>
              <input onClick="this.value = null" @change="changeFile" type="file" accept="image/*" />
              <div v-show="isUploading" class="mini-im-file-percent">
                <span>{{uploadPercent}}</span>
              </div>
            </div>
          </el-col>
          <el-col :span="6"></el-col>
        </el-row>
      </el-form-item>
      <el-form-item label="客服账号" :label-width="formLabelWidth">
        <span>{{form.username}}</span>
      </el-form-item>
      <el-form-item label="客服昵称" :label-width="formLabelWidth">
        <el-input v-model="form.nickname" placeholder="请输入客服昵称" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="手机号" :label-width="formLabelWidth">
        <el-input v-model="form.phone" placeholder="请输入登录密码" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="自动回复语" :label-width="formLabelWidth">
          <el-input v-model="form.auto_reply" type="textarea"  placeholder="请输入自动回复语,不支持emoji，请使用简单语句描述" autocomplete="off"></el-input>
        </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="closeModal">取 消</el-button>
      <el-button type="primary" @click="save">保 存</el-button>
    </div>
  </el-dialog>
</template>
<script>
import axios from "axios";
import upload from '../../common/upload'
export default {
  name: "mini-im-create-admin",
  data() {
    return {
      form: {
        phone: "",
        nickname: "",
        avatar: "",
        auto_reply: ""
      },
      formLabelWidth: "90px",
      isUploading: false,
      uploadPercent: ""
    };
  },
  props: {
    dialogFormVisible: Boolean,
    complete: Function,
    formData: Object
  },
  methods: {
    // 关闭
    closeModal() {
      this.$emit("update:dialogFormVisible", false);
    },
    // 上传
    changeFile(file) {

      var fileData = file.target.files[0];
       upload({
         file: fileData,
         progress: (percent) => {
           this.isUploading = true;
          this.uploadPercent = percent + "%";
         },
         success: (url) => {
          this.isUploading = false;
          this.uploadPercent = "";
          this.$message.success("上传成功");
          var imgUrl = this.$store.getters.uploadToken.host + "/" + url
          this.form.avatar = imgUrl;
         },
         error: (err)=>{
          this.isUploading = false;
          this.uploadPercent = "";
          this.$message.error(err.message);
         }
       });


    },
    // 保存
    save() {
      // 验证字段 ！！ 算了其它前端不验证了
      const loading = this.$loading({
        lock: true,
        text: "保存中...",
        spinner: "el-icon-loading",
        background: "rgba(0, 0, 0, 0.5)"
      });
      axios
        .put("/admin", this.form)
        .then(response => {
          try {
            loading.close();
            this.$message.success("修改成功");
            this.closeModal();
            this.complete(1);
          } catch (e) {
            console.log(e, response);
          }
        })
        .catch(error => {
          loading.close();
          this.$message.error(error.response.data.message);
        });
    }
  },
  watch: {
    formData() {
      this.form = Object.assign({}, this.form, this.formData);
    }
  }
};
</script>
<style scoped lang="stylus">
.mini-im-file-button {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  position: relative;
  overflow: hidden;

  input {
    font-size: 100px;
    position: absolute;
    top: 0px;
    left: 0px;
    cursor: pointer;
    opacity 0
  }

  cursor: pointer;

  .mini-im-file-percent {
    position: absolute;
    top: 0px;
    left: 0px;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background-color: rgba(0, 0, 0, 0.5);
    color: #fff;
    font-size: 12px;
  }
}
</style>
