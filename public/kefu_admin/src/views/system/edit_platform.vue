<template>
    <el-dialog  title="修改平台" :show-close="false" :visible.sync="dialogFormVisible" :close-on-click-modal="false">
      <el-form :model="form">
        <el-form-item label="平台名称" :label-width="formLabelWidth">
          <el-input v-model="form.title" placeholder="请输入平台名称" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="平台别名" :label-width="formLabelWidth">
          <el-input v-model="form.alias" placeholder="请输入平台别名" autocomplete="off"></el-input>
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
  name: 'me-create-admin',
  data(){
    return {
        form: {
          title: '',
          alias: '',
        },
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
        .put("/platform", this.form)
        .then(response => {
          console.log(response);
          loading.close();
          this.$message.success("添加成功");
          this.closeModal();
          this.$store.dispatch('ON_GET_PLATFORM_CONFIG')
        })
        .catch(error => {
          loading.close();
          this.$message.error(error.response.data.message);
        });
    }
  },
  watch:{
    formData(){
      this.form = Object.assign({},this.form, this.formData)
    }
  }
}
</script>
<style scoped lang="stylus">
   
</style>
