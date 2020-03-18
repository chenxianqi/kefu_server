<template>
    <el-dialog  width="500px" title="修改密码" :show-close="false" :visible.sync="$store.state.editPasswordDialogFormVisible" :close-on-click-modal="false">
      <el-form :model="form">
        <el-form-item label="旧密码" :label-width="formLabelWidth">
          <el-input v-model="form.old_password" placeholder="请输入旧密码" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="新密码" :label-width="formLabelWidth">
          <el-input v-model="form.new_password" placeholder="请输入新密码" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="确认密码" :label-width="formLabelWidth">
          <el-input v-model="form.enter_password" placeholder="请再次输入新密码" autocomplete="off"></el-input>
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
        form: {
          old_password: "",
          new_password: "",
          enter_password: ""
        },
        robotSwitch: true,
        formLabelWidth: "80px"
    }
  },
  props:{
    dialogFormVisible: Boolean
  },
  mounted(){
  },
  methods: {
    // 关闭
    closeModal(){
      this.resize()
      this.$store.commit("onChangeEditPasswordDialogFormVisible", false)
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
      axios.put('/admin/password', this.form)
      .then(response => {
          console.log(response)
          loading.close();
          this.$message.success("资料修改成功")
          this.closeModal()
          this.resize()
      })
      .catch(error => {
        loading.close();
        this.$message.error(error.response.data.message)
      });

    },
    resize(){
      this.form = {
          old_password: "",
          new_password: "",
          enter_password: ""
        }
    }
  }
}
</script>
<style scoped lang="stylus">
   
</style>
