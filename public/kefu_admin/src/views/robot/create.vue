<template>
  <el-dialog
    width="600px"
    title="添加机器人"
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
                :src="form.avatar"
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
      <el-form-item label="机器人昵称" :label-width="formLabelWidth">
        <el-input v-model="form.nickname" placeholder="请输入机器人昵称" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="机器人欢迎语" :label-width="formLabelWidth">
        <el-input type="textarea" :rows="2" v-model="form.welcome" placeholder="请输入机器人欢迎语" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="无匹配知识库语" :label-width="formLabelWidth">
        <el-input type="textarea" :rows="2" v-model="form.understand" placeholder="请输入无法识别回复语" autocomplete="off"></el-input>
      </el-form-item>
       <el-form-item label="超时结束提示" :label-width="formLabelWidth">
        <el-input type="textarea" :rows="2" v-model="form.timeout_text" placeholder="请输入会话超时结束提示" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="无人工在线提示" :label-width="formLabelWidth">
        <el-input type="textarea" :rows="2" v-model="form.no_services" placeholder="请输入无人工在线提示" autocomplete="off"></el-input>
      </el-form-item>
       <el-form-item label="长时间等待提示" :label-width="formLabelWidth">
        <el-input type="textarea" :rows="2" v-model="form.loog_time_wait_text" placeholder="请输入长时间等待提示语" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="检索知识库热词" :label-width="formLabelWidth">
        <el-tag
          :key="tag"
          v-for="tag in keyWordTags"
          closable
          :disable-transitions="false"
          @close="handleKeyWordDel(tag, 'keyWordTagsInput')"
        >{{tag}}</el-tag>
        <el-input
          class="input-new-tag"
          v-if="showkeyWordTagsInput"
          v-model="inputkeyWordTagValue"
          ref="keyWordTagsInput"
          size="small"
          @keyup.enter.native="handleInputConfirm"
          @blur="handleInputConfirm"
        ></el-input>
        <el-button v-else class="button-new-tag" size="small" @click="showTagInput('keyWordTagsInput')">+ 新增</el-button>
         <div style="font-size:12px;">* 该词库会在用户输入的时候去匹配检索提示</div>
      </el-form-item>
      <el-form-item label="转人工关键词" :label-width="formLabelWidth">
        <el-tag
          :key="tag"
          v-for="tag in dynamicTags"
          closable
          :disable-transitions="false"
          @close="handleKeyWordDel(tag, 'dynamicTagsInput')"
        >{{tag}}</el-tag>
        <el-input
          class="input-new-tag"
          v-if="showDynamicTagsInput"
          v-model="inputDynamicTagValue"
          ref="dynamicTagsInput"
          size="small"
          @keyup.enter.native="handleInputConfirm"
          @blur="handleInputConfirm"
        ></el-input>
        <el-button v-else class="button-new-tag" size="small" @click="showTagInput('dynamicTagsInput')">+ 新增</el-button>
        <div style="font-size:12px;">* 匹配该关键词进入人工，系统已内置： "人工"</div>
      </el-form-item>
      <el-form-item label="运行状态" :label-width="formLabelWidth">
        <el-switch v-model="robotSwitch" active-color="#13ce66" inactive-color="#ff4949"></el-switch>
      </el-form-item>
      <el-form-item label="匹配平台" :label-width="formLabelWidth">
        <el-select v-model="form.platform" placeholder="请选择匹配平台">
          <el-option
            :label="item.title"
            :value="item.id"
            :key="index"
            v-for="(item, index) in $store.getters.platformConfig"
          ></el-option>
        </el-select>
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
  name: "mini-im-create-robot",
  data() {
    return {
      dynamicTags: [],
      keyWordTags: [],
      showkeyWordTagsInput: false,
      inputkeyWordTagValue: "",
      showDynamicTagsInput: false,
      inputDynamicTagValue: "",
      form: {
        nickname: "",
        avatar: "",
        welcome: "",
        understand: "",
        artificial: "",
        keyword: "",
        timeout_text: "",
        no_services: "",
        loog_time_wait_text: "",
        platform: 1,
        switch: 1
      },
      robotSwitch: true,
      formLabelWidth: "120px",
      isUploading: false,
      uploadPercent: ""
    };
  },
  props: {
    dialogFormVisible: Boolean,
    complete: Function
  },
  methods: {
    // 关闭
    closeModal() {
      this.resize();
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
    // 删除标签
    handleKeyWordDel(tag, type) {
      if(type == "dynamicTagsInput"){
        this.dynamicTags.splice(this.dynamicTags.indexOf(tag), 1);
      }
      else if(type == "keyWordTagsInput"){
        this.keyWordTags.splice(this.keyWordTags.indexOf(tag), 1);
      }
    },
    // 显示子标题输入框
    showTagInput(type) {
      if(type == "dynamicTagsInput"){
        this.showDynamicTagsInput = true;
        this.$nextTick(() => {
          this.$refs.dynamicTagsInput.$refs.input.focus();
        });
      }else if(type == "keyWordTagsInput"){
        this.showkeyWordTagsInput = true;
        this.$nextTick(() => {
          this.$refs.keyWordTagsInput.$refs.input.focus();
        });
      }
    
    },
    // 标签确定
    handleInputConfirm() {
      let inputDynamicTagValue = this.inputDynamicTagValue;
      let inputkeyWordTagValue = this.inputkeyWordTagValue;
      if (inputDynamicTagValue) {
        this.dynamicTags.push(inputDynamicTagValue);
      }
      if (inputkeyWordTagValue) {
        this.keyWordTags.push(inputkeyWordTagValue);
      }
      this.showkeyWordTagsInput = false;
      this.showDynamicTagsInput = false;
      this.inputDynamicTagValue = "";
      this.inputkeyWordTagValue = "";
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
      this.form.artificial = this.dynamicTags.join("|");
      this.form.keyword = this.keyWordTags.join("|");
      this.form.switch = this.robotSwitch ? 1 : 0
      axios
        .post("/robot", this.form)
        .then(response => {
          try {
            console.log(response);
            loading.close();
            this.$message.success("添加成功");
            this.closeModal();
            this.resize();
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
    // 重置
    resize(){
      this.dynamicTags = []
      this.inputVisible = false
      this.inputValue = ""
      this.form = {
        nickname: "",
        avatar: "",
        welcome: "",
        timeout_text: "",
        no_services: "",
        loog_time_wait_text: "",
        understand: "",
        artificial: "",
        platform: 1,
        switch: 1
      }
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

.el-tag + .el-tag {
  margin-left: 10px;
}

.button-new-tag {
  margin-left: 10px;
  height: 32px;
  line-height: 30px;
  padding-top: 0;
  padding-bottom: 0;
}

.input-new-tag {
  width: 150px;
  margin-left: 10px;
  vertical-align: bottom;
}
</style>
