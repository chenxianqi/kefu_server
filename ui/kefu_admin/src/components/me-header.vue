<template>
  <el-row type="flex" justify="end" :gutter="20">
     <el-col :span="5">
      <el-button
        @click="$store.commit('onChangeToggleAside', !$store.state.isShowAside)"
        class="mini-im-button"
        type="info"
        :icon="$store.state.isShowAside ? 'el-icon-s-fold' : 'el-icon-s-unfold'"
      >
      </el-button>
    </el-col>
    <el-col :span="16" >
      <div class="mini-im-title">{{$store.state.heaserTitle}}</div>
    </el-col>
    <el-col :span="5">
        <el-row type="flex" justify="end" class="mini-im-dropdown">
          <el-dropdown @command="handleCommand"  trigger="click">
            <div class="el-dropdown-link">
                <el-avatar :size="25" class="mini-im-avatar">
                    <img :src="$store.getters.avatar"/>
                </el-avatar>
                <span style="padding:0 5px;"> {{$store.getters.nickname}} </span>
                <i class="el-icon-arrow-down el-icon--right"></i>
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="a">
                <i class="el-icon-user icon"></i>
                修改资料
              </el-dropdown-item>
              <el-dropdown-item command="b">
                <i class="el-icon-unlock icon"></i>
                修改密码
              </el-dropdown-item>
              <el-dropdown-item command="c" divided>
                <i class="el-icon-caret-right icon"></i>
                退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </el-row>
    </el-col>
  </el-row>
</template>
<script>
import axios from 'axios'
export default {
  name: "mini-im-aside",
  data(){
    return {
      bgColor: "#ffffff"
    }
  },
  props: {
    title: String
  },
  methods: {
     // 退出登录
    logout(){
      axios.put('/admin/online/0')
      axios.get('/auth/logout')
      .then(() => {
        this.$store.commit("onReset")
        this.$store.commit("onChangeAdminInfo", null)
        this.$router.push({ path: '/login'})
        this.$mimcInstance.logout()
        this.$store.commit("onIsLogin", false)
         localStorage.clear()
      })
      .catch(error => {
        this.$message.error('退出失败')
        console.log(error)
      })
    },
    handleCommand(command){
        switch(command){
          case 'a':
            this.$store.commit("onChangeEditDialogFormVisible", true)
            break
          case 'b':
            this.$store.commit("onChangeEditPasswordDialogFormVisible", true)
            break
          case 'c':
            this.$confirm('您确定要退出登录吗? ', '温馨提示！', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              center: true,
              type: 'warning'
            }).then(() => this.logout())
            break

        }
    }
  }
}
</script>
<style scoped lang="stylus">
.mini-im-header {
  background-color: #545c64;
  border-bottom: 1px solid #545c64;
  .mini-im-dropdown{
    height 100%
  }
  .mini-im-button{
    border 0
    font-size 35px
    display block
    background 0
    padding-left 0
  }
  .mini-im-title{
    color #fff
    font-size 16px
    text-align center
    line-height 60px
  }
  .icon {
    color: #fff;
  }
  .el-dropdown-link {
    cursor: pointer;
    display flex
    height 100%
    line-height  60px
    align-items center
    color: #fff;
  }
  .el-icon-arrow-down {
    font-size: 12px;
  }
}
</style>
