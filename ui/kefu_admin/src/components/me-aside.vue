<template>
  <el-aside width="200px" class="mini-im-aside">
      <div class="mini-im-logo" @click="$router.push({ path: '/index'})">
        <div v-if="$store.getters.systemInfo.logo"><img :src="$store.getters.systemInfo.logo + '?id=' + Date.now()" alt=""></div>
        <div v-else><img src="../assets/kefu_logo.png" alt=""></div>
      </div>
        <el-menu
          :default-active="menuActive"
          class="el-menu-vertical-demo"
          background-color="#3e444a"
          text-color="#fff"
          :router="true"
          active-text-color="#ffd04b"
        >
        <el-menu-item index="/index">
          <i class="el-icon-s-home"></i>
          <span slot="title">首页</span>
        </el-menu-item>
          <el-menu-item index="/workbench">
           <el-badge :hidden="$store.getters.readCount == 0" :value="$store.getters.readCount" :max="99" style="width: 100%;">
            <div>
              <i class="el-icon-s-platform"></i>
              <span slot="title">工作台</span>
            </div>
            </el-badge>
          </el-menu-item>
        <el-menu-item index="/knowledge">
          <i class="el-icon-reading"></i>
          <span slot="title">知识库</span>
        </el-menu-item>
        <el-menu-item index="/robot">
          <i class="el-icon-picture-outline-round"></i>
          <span slot="title">机器人</span>
        </el-menu-item>
        <el-menu-item index="/customer">
          <i class="el-icon-headset"></i>
          <span slot="title">客服管理</span>
        </el-menu-item>
        <el-menu-item index="/users">
          <i class="el-icon-user"></i>
          <span slot="title">用户管理</span>
        </el-menu-item>
        <el-menu-item index="/chat_record">
          <i class="el-icon-time"></i>
          <span slot="title">服务记录</span>
        </el-menu-item>
        <el-menu-item index="/system">
          <i class="el-icon-setting"></i>
          <span slot="title">系统设置</span>
        </el-menu-item>
       
      </el-menu>
      <div class="fix-bottom">
        <a title="去给作者Star" target="_blank" href="https://github.com/chenxianqi/kefu_server.git">
          <svg class="github-logo" height="23" viewBox="0 0 16 16" version="1.1" width="23" aria-hidden="true"><path fill="#fff" fill-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"></path></svg>
          <span> Github</span>
        </a>
      </div>
    </el-aside>
</template>
<script>
export default {
  name: 'mini-im-aside',
  data(){
    return {
      menuActive: "/index"
    }
  },
  mounted(){
   this.setHeaderTitle()
  },
  methods: {
    setHeaderTitle(){
      this.menuActive = this.$route.path
      var title
      switch(this.menuActive){
        case "/index":
          title = "首页"
          break
        case "/workbench":
          title = "工作台"
          break
        case "/knowledge":
          title = "知识库"
          break
        case "/robot":
          title = "机器人"
          break
        case "/customer":
          title = "客服管理"
          break
        case "/users":
          title = "用户管理"
          break
        case "/system":
          title = "系统设置"
          break
      }
      this.$store.commit("onChangeHeaserTitle", title)
    }
  },
  watch: {
    "$route"(){
     this.setHeaderTitle()
    }
  }
}
</script>
<style lang="stylus">
    .mini-im-aside{
      background-color: #3e444a
      display flex
      flex-direction column
      .mini-im-logo{
        width 100%;
        height: 100px;
        display  flex
        justify-content center
        flex-direction column
        align-items center
        border-bottom 1px solid #ddd
        img{
          height : 30px
        }
      }
      .el-menu{
        border-right  0
      }
      .el-badge__content{
        border 0
        top 30px
      }
      .fix-bottom{
        flex-grow 1
        display flex
        flex-direction column
        justify-content flex-end
        padding-bottom 30px
        a{
          cursor pointer
          padding 0 30px
          text-align center
          align-items center
          color #fff
          display flex
          align-content center
          .github-log{
            width 50px
          }
          span{
            margin-top 3px
            margin-left 5px
          }
        }
      }
    }
</style>
