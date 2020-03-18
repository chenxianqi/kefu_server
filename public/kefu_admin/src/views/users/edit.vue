<template>
  <el-dialog
    title="编辑用户"
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
      <el-form-item label="用户昵称" :label-width="formLabelWidth">
        <el-input v-model="form.nickname" placeholder="请输入用户昵称" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="所在地区" :label-width="formLabelWidth">
        <el-input v-model="form.address" placeholder="请输入所在地区" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="联系方式" :label-width="formLabelWidth">
        <el-input v-model="form.phone" placeholder="请输入联系方式" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="备注" :label-width="formLabelWidth">
        <el-input v-model="form.remarks" type="textarea" placeholder="请输入备注" autocomplete="off"></el-input>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="closeModal">取 消</el-button>
      <el-button type="primary" @click="save">保 存</el-button>
    </div>
  </el-dialog>
</template>
<script>
import axios from 'axios'
import upload from '../../common/upload'
export default {
  name: "mini-im-edit-user",
  data() {
    return {
      form: {
        id: "",
        avatar: "",
        phone: "",
        address: "",
        nickname: "",
        remarks: ""
      },
      formLabelWidth: "120px",
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
    save(){
      // 验证字段 ！！ 算了前端不验证了
      const loading = this.$loading({
        lock: true,
        text: "保存中...",
        spinner: "el-icon-loading",
        background: "rgba(0, 0, 0, 0.5)"
      });
      axios
        .put("/user", this.form)
        .then(response => {
          try {
            console.log(response);
            loading.close();
            this.$message.success("修改成功");
            this.closeModal();
            this.complete();
          } catch (e) {
            console.log(e);
          }
        })
        .catch(error => {
          loading.close();
          this.$message.error(error.response.data.message);
        });
    },
  },
  watch:{
    formData(){
      this.form = Object.assign({},this.form, this.formData)
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
