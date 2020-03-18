<template>
    <el-dialog width="600px"  title="添加快捷语" :show-close="false" :visible.sync="dialogFormVisible" :close-on-click-modal="false">
      <el-form :model="form">
        <el-form-item label="标题" :label-width="formLabelWidth">
          <el-input  maxlength="50" show-word-limit v-model="form.title" type="text" placeholder="请输入标题" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="内容" :label-width="formLabelWidth">
          <el-input rows="8" resize="none" :autosize="false"  maxlength="200" show-word-limit v-model="form.content" type="textarea" placeholder="请输入快捷语" autocomplete="off"></el-input>
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
export default {
  name: 'mini-im-create-shortcuts',
  data(){
    return {
        form: {
          content: '',
          title: ""
        },
        formLabelWidth: "40px"
    }
  },
  props:{
    dialogFormVisible: Boolean,
    complete: Function
  },
  mounted(){

  },
  methods: {
    // 关闭
    closeModal(){
      this.$emit('update:dialogFormVisible', false);
    },
    // 保存
    save() {
      if(this.form.title.trim() == "") return
      if(this.form.content.trim() == "") return
      // 验证字段 ！！ 算了其它前端不验证了
      const loading = this.$loading({
        lock: true,
        text: "保存中...",
        spinner: "el-icon-loading",
        background: "rgba(0, 0, 0, 0.5)"
      });
      axios
        .post("/shortcut", this.form)
        .then(response => {
          try {
            console.log(response);
            loading.close();
            this.$message.success("添加成功");
            this.closeModal();
            this.complete();
            this.form = {content: "", title: ""}
          } catch (e) {
            console.log(e);
          }
        })
        .catch(error => {
          loading.close();
          this.$message.error(error.response.data.message);
        });
    },
  }
}
</script>
<style scoped lang="stylus">
   
</style>
