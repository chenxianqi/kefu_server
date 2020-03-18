<template>
  <div class="login">
      <div class="form">
          <div class="left">
              <div class="tit">欢迎回来， 请登录！</div>
              <span>客服系统-工作台</span>
              <div class="client">
                <p>客户端下载</p>
                  <el-button @click="dmac" type="primary" size="mini" icon="el-icon-download">Mac 版下载</el-button>
                  <el-button @click="dwin" type="primary" size="mini" icon="el-icon-download">Windows 版下载</el-button>
              </div>
          </div>
          <div class="right">
            <el-form ref="form" :model="form" onsubmit="return false" label-width="80px">
                <span class="lable">用户登录</span>
                <el-input
                  class="input"
                  placeholder="请输入用户名"
                  prefix-icon="el-icon-user"
                  v-model="form.username">
                </el-input>
                <el-input
                  class="input"
                  type="password"
                  placeholder="请输入密码"
                  prefix-icon="el-icon-unlock"
                  show-password
                  v-model="form.password">
                </el-input>
                <el-row type="flex" class="btn-group">
                  <el-button native-type="submit" @click="login" size="small" type="primary">登录</el-button>
                  <el-button size="small" type="info">重置</el-button>
                </el-row>
            </el-form>
          </div>
      </div>
  </div>
</template>
<script>
import axios from 'axios'
export default {
  name: 'login',
  data(){
    return{
      form: {
        auth_type: 1,
        username: "",
        password: ""
      }
    }
  },
  mounted(){
    document.title = "用户登录"
  },
  methods: {
    // login
    login(){
      // valid
      if(this.form.username.trim() == ""){
        this.$message.error('用户名不能为空！')
        return
      }
      if(this.form.password.trim() == ""){
        this.$message.error('密码不能为空！')
        return
      }
      axios.post('/auth/login', this.form)
      .then(response => {
        this.$store.commit("onChangeAdminInfo", response.data.data)
        this.$store.commit("onIsLogin", true)
        localStorage.setItem("Authorization", response.data.data.token)
        this.$message({
          message: '登录成功！',
          type: 'success'
        });
        this.$router.push({ path: '/index'})
      })
      .catch(error => {
        console.log(error)
        this.$message.error(error.response.data.message)
      });
    },
    dmac(){
      window.open("http://kf.aissz.com:666/static/app/mac-0.0.1.dmg")
    },
    dwin(){
      window.open("http://kf.aissz.com:666/static/app/win-0.0.1.exe")
    }
  }
}
</script>
<style lang="stylus" scoped>
  .login{
    display flex
    width 100%
    height 100%
    background url('../../assets/login_bg.jpg') center bottom no-repeat;
    background-size cover
    .form{
      display flex
      overflow hidden
      width 600px;
      height 300px;
      background-color #fff
      margin auto
      border-radius 5px;
      .left{
        width 350px
        height 100%
        padding 20px;
        box-sizing border-box
        background url('../../assets/login_bg1.jpg') center bottom no-repeat;
        background-size cover
        font-size 18px;
        color  #fff
        display flex
        flex-direction column
        justify-content center
        .tit{
          margin-top: 50px;
          border-bottom 1px solid  #fff
        }
        div{
          width 300px
          padding-bottom 10px;
          margin-bottom 10px;
        }
        span{
          font-size 14px;
        }
        .client{
          margin-top: 80px;
          button{
            margin-top 10px
          }
        }
      }
      .right{
        padding 20px;
        padding-top: 50px;
        .input{
          margin-bottom 20px;
        }
        .btn-group{
          margin-top: 15px;
        }
        .lable{
          font-size 18px;
          color: #606266;
          margin-bottom 15px;
          display block
        }
      }
    }
  }
</style>

