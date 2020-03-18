<template>
   <div class="mini-im-username-component-box">
        <div class="mini-im-username-component">
          <button @click="isUserReadonly = !isUserReadonly" title="编辑用户信息"><i class="el-icon-edit"></i></button>
        </div>
        <el-form ref="form" :class="{'form-item-readonly': isUserReadonly}" label-width="80px">
          <el-form-item  class="form-item" label="用户昵称">
            <el-input v-model="form.nickname" placeholder="游客" :readonly="isUserReadonly" type="text"></el-input>
          </el-form-item>
            <el-form-item class="form-item" label="所在地区">
              <el-input :readonly="isUserReadonly" placeholder="无" v-model="form.address"  type="text"></el-input>
          </el-form-item>
          <el-form-item class="form-item" label="联系方式">
            <el-input :readonly="isUserReadonly"  placeholder="无联系方式" v-model="form.phone"  type="text"></el-input>
          </el-form-item>
          <el-form-item class="form-item no-border" label="所在平台">
              <el-input readonly :value="$getPlatformItem(user.platform).title" resize="none" type="text"></el-input>
          </el-form-item>
          <el-form-item class="form-item no-border" label="创建时间">
            <el-input readonly :value='$formatUnixDate(user.create_at, "YYYY/MM/DD")' resize="none" type="text"></el-input>
          </el-form-item>
          <el-form-item class="form-item" label="备注信息">
            <el-input rows="4" :readonly="isUserReadonly" placeholder="无备注" v-model="form.remarks"   resize="none" type="textarea"></el-input>
          </el-form-item>
          <el-row type="flex" justify="center" v-if="!isUserReadonly">
            <el-button @click="isUserReadonly = true">取消</el-button>
            <el-button @click="save" type="primary">保存</el-button>
          </el-row>
          <div v-if="!isUserReadonly" style="text-align: center;font-size: 12px; color: #666;margin-top: 15px;">当前为编辑模式</div>
        </el-form>
   </div>

</template>
<script>
import axios from "axios";
export default {
  name: 'mini-im-user-info',
  data(){
    return {
      form:{
        id: "",
        nickname: "",
        address: "",
        phone: "",
        remarks: ""
      },
      isUserReadonly: true, // 用户信息是否是编辑模式
    }
  },
  computed: {
    user(){
      return this.$store.getters.seviceCurrentUser || {}
    }
  },
  methods:{
    // 保存
    save() {
      axios
        .put("/user", this.form)
        .then(() => {
            this.isUserReadonly = true
        })
        .catch(error => {
          this.$message.error(error.response.data.message);
        });
    },
  },
  watch: {
    user(newUser){
      if(newUser.id != this.form.id) this.isUserReadonly = true
      if(!this.isUserReadonly && newUser.id == this.form.id) return
      this.form = this.user
    }
  }
}
</script>
<style lang="stylus">
  .mini-im-username-component-box{
    height 100%
    overflow hidden
    overflow-y auto
    padding: 10px 10px 10px 5px;
    .form-item{
      margin-top 25px
    }
   .form-item-readonly input.el-input__inner,
   .form-item-readonly textarea.el-textarea__inner {
      border  0
    }
   .no-border input.el-input__inner{
     border  0
   }
  }
  .mini-im-username-component{
    position absolute
    top 10px
    right 25px
    span{
      font-size 18px 
      color #666
      i{
        font-size 20px
      }
    }
    button{
      border  0
      cursor pointer
    }
  }
</style>
