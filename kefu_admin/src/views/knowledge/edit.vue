<template>
    <el-dialog width="600px"  title="编辑的知识" :show-close="false" :visible.sync="dialogFormVisible" :close-on-click-modal="false">
      <el-form :model="form">
        <el-form-item label="主标题" :label-width="formLabelWidth">
          <el-input v-model="form.title" placeholder="请输入主标题" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="子标题" :label-width="formLabelWidth">
          <el-tag
            :key="tag"
            v-for="tag in dynamicTags"
            closable
            :disable-transitions="false"
            @close="handleDel(tag)">
            {{tag}}
          </el-tag>
          <el-input
            class="input-new-tag"
            v-if="inputVisible"
            v-model="inputValue"
            ref="saveTagInput"
            size="small"
            @keyup.enter.native="handleInputConfirm"
            @blur="handleInputConfirm"
          >
          </el-input>
          <el-button v-else class="button-new-tag" size="small" @click="showInput">+ 新增子标题</el-button>
        </el-form-item>
        <el-form-item label="内容" :label-width="formLabelWidth">
          <el-input rows="5" type="textarea" v-model="form.content" autocomplete="off"></el-input>
        </el-form-item>
         <el-form-item label="匹配平台" :label-width="formLabelWidth">
            <el-select v-model="form.platform" placeholder="请选择匹配平台">
              <el-option :label="item.title" :value="item.id" :key="index" v-for="(item, index) in platformConfig"></el-option>
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
export default {
  name: 'mini-im-create-knowledge',
  data(){
    return {
      dynamicTags: [],
      inputVisible: false,
      inputValue: '',
      form: {
        uid: "",
        platform: 1,
        title: '',
        sub_title: '',
        content: '',
      },
      platformConfig: [],
      formLabelWidth: "80px"
    }
  },
  props:{
    dialogFormVisible: Boolean,
    complete: Function,
    formData: Object
  },
  methods: {
    // 关闭
    closeModal(){
      this.$emit('update:dialogFormVisible', false);
    },
    // 删除标签
    handleDel(tag) {
      this.dynamicTags.splice(this.dynamicTags.indexOf(tag), 1);
    },
    // 显示子标题输入框
    showInput() {
      this.inputVisible = true;
      this.$nextTick(() => {
        this.$refs.saveTagInput.$refs.input.focus();
      });
    },
    // 确定
    handleInputConfirm() {
      let inputValue = this.inputValue;
      if (inputValue) {
        this.dynamicTags.push(inputValue);
      }
      this.inputVisible = false;
      this.inputValue = '';
    },
    // 保存
    save(){
      // 验证字段 ！！ 算了前端不验证了
      const loading = this.$loading({
        lock: true,
        text: '保存中...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.5)'
      });
      this.form.uid = this.$store.state.adminInfo.id
      this.form.sub_title = this.dynamicTags.join("|")
      axios.put('/knowledge', this.form)
      .then(response => {
        try{
          console.log(response)
          loading.close();
          this.$message.success("修改成功")
          this.closeModal()
          this.resize()
          this.complete(1)
        }catch(e){
          console.log(e)
        }
      })
      .catch(error => {
        loading.close();
        this.$message.error(error.response.data.message)
      });

    },
    resize(){
      this.dynamicTags = []
      this.form = {
        uid: "",
        platform: 1,
        title: '',
        sub_title: '',
        content: '',
      };
    }
  },
  watch:{
    formData(){
      this.platformConfig = this.$store.getters.platformConfig
      this.form = Object.assign({},this.form, this.formData)
      if(this.formData.sub_title != "") this.dynamicTags = this.formData.sub_title.split("|")
    }
  }
}
</script>
<style scoped lang="stylus">
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
