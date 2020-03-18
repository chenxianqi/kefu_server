<template>
  <div id="app">
    <router-view/>
  </div>
</template>
<script>
import axios from "axios";
import Push from "push.js";
export default {
  created(){
    this.$store.dispatch('ON_GET_ME')
  },
  methods: {
    // app init
    appInit(){
      if(!this.adminInfo){
        setTimeout(()=> this.appInit(), 50)
        return
      }
      this.$store.dispatch('ON_GET_UPLOAD_TOKEN')
      this.$store.dispatch('ON_GET_PLATFORM_CONFIG')
      this.$store.dispatch('ON_GET_SYSTEM')
      this.$store.dispatch('ON_GET_COMPANY')
      this.$store.dispatch('ON_GET_UPLOADS_CONFIG')
      this.$store.dispatch('ON_GET_ROBOTS')
      this.$store.dispatch('ON_GET_CONTACTS')

      // 一分钟上报一次我的活动时间
      this.upLastActivity()

      // 获取会话表
      this.getContacts()

      // Mimc 初始化
      this.initMimc()

    },
    // 获取会话列表
    getContacts(){
      if(this.adminInfo){
        this.$store.dispatch('ON_GET_CONTACTS')
        if(this.seviceCurrentUser && this.$store.getters.contacts.length > 0){
          this.$store.getters.contacts.map(i =>  {
            if(i.from_account == this.seviceCurrentUser.from_account){
              this.$store.commit("onChangeSeviceCurrentUser", i)
            }
          })
        }
      }
    },
    // 上报最后活动时间
    upLastActivity(){
      this.$store.dispatch('ON_RUN_LAST_ACTiIVITY')
      setTimeout(() => this.upLastActivity(), 1000*60)
    },
    // 初始化Mimc
    initMimc(){
        var self = this
        var adminInfo = this.$store.state.adminInfo
        if(!adminInfo){
          setTimeout(() => this.initMimc(), 1000)
        }else{
          self.$mimcInstance.init({
            type: 1,
            account_id: adminInfo.id
          }, (isSuccess) => {
            // 初始化完成
            if(isSuccess){
              // 监听登录状态
              this.$mimcInstance.addEventListener("statusChange", (status) => {
                if(!status && self.$store.getters.adminInfo.online != 0){
                  self.watchLogin()
                }
              })
              // 监听连接断开
              this.$mimcInstance.addEventListener("disconnect", () => {
                console.log("链接断开！")
                if(self.$store.getters.adminInfo.online != 0){
                 self.watchLogin()
                }
              })
              self.watchLogin()
            }else{
              self.initMimc()
            }
          })
        }
    },
    // 更新用户状态
    changeUserOnlineStatus(online){
        // 更新状态
        axios.put('/admin/online/' + online)
        .then(() => {
          this.$store.dispatch('ON_GET_ME')
          if(online == 0){
             this.$message.info("当前状态为离线")
          }
        })
        .catch(error => {
            this.$message.error(error.response.data.message)
        });
    },
    // 监听用户是否有上线登录
    watchLogin(){
      try{
        var self = this
        if(self.$store.state.user != null) return;
        if(self.$store.getters.adminInfo.online == 1 || self.$store.getters.adminInfo.online == 2){
          self.$mimcInstance.login(()=>{
            self.changeUserOnlineStatus(self.$store.getters.adminInfo.online)
            self.$store.dispatch('ON_RUN_LAST_ACTiIVITY')
            self.$store.dispatch('ON_GET_CONTACTS')
            self.$store.commit("onChangeMimcUser", self.$mimcInstance.user)
          })
        }else if(self.$store.getters.adminInfo.online != 0){
          setTimeout(() => self.watchLogin(), 1000)
        }
      }catch(err){
        setTimeout(() => this.watchLogin(), 1000)
      }
    },
  },
  mounted(){
    window.addEventListener("resize", () => {
      this.$store.commit("onChangeToggleAside", true)
      if(document.body.clientWidth < 1000){
        this.$store.commit("onChangeToggleAside", false)
      }
    }, false)
    // 判断通知权限
    if(!Push.Permission.has()){
      Push.Permission.request(function(){}, function(){})
    }
  },
  computed: {
    adminInfo(){
      return this.$store.getters.adminInfo
    },
    seviceCurrentUser(){
      return this.$store.getters.seviceCurrentUser
    },
    messageRecord(){
      return this.$store.getters.messageRecord
    },
    isLogin(){
      return this.$store.getters.isLogin
    }
  },
  watch: {
    "$route"(){
      if(!/^\/workbench(\/\d+)?$/i.test(this.$route.path)){
        // 监听消息
        this.$mimcInstance.addEventListener("receiveP2PMsg", (message) => {
          var nowTime = parseInt((new Date().getTime() +"").substr(0, 10))
          message.timestamp = parseInt((message.timestamp +"").substr(0, 10))
          if(nowTime - message.timestamp >= 60) return
          // 处理用户列表
          if(message.biz_type == "contacts"){
            var contacts = JSON.parse(message.payload)
            //  console.log(contacts)
            this.$store.commit('onChangeContacts', contacts)
            return
          }
          // 判断是否是握手消息
          if(message.biz_type == "handshake"){
            this.$mimcInstance.sendMessage("text", message.from_account, this.adminInfo.auto_reply)
            return
          }
          var newMessageRecord = JSON.parse(JSON.stringify(this.messageRecord))
          newMessageRecord.list.push(message)
          this.$store.commit("onChangeMessageRecord", newMessageRecord)

          // 推送消息
          if(message.biz_type == "contacts" || message.biz_type == "pong" || message.biz_type == "welcome" || message.biz_type == "cancel" || message.biz_type == "handshake" || message.biz_type == "end" || message.biz_type == "timeout") return
          if(!Push.Permission.has()) return
          Push.create("收到一条新消息", {
              body: message.payload,
              icon: this.$store.state.pushIcon,
              timeout: 5000,
              onClick: () => {
                this.$router.push({ path: '/workbench?uid=' + message.from_account})
                window.focus();
              }
          });

        })
      }
    },
    isLogin(){
      console.log("当前是登录状态")
      this.appInit()
    }
    
  }
}
</script>
<style lang="stylus">
#app{
  display flex
  height 100vh
}
.el-tabs__content,.el-tab-pane{
  height 100%
  padding 0
}
.el-tabs__content{
  padding 0 !important
}
button{
  background-color #fff
}
.pswp{
  z-index 3000!important
}
</style>
