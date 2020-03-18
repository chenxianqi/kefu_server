<template>
  <el-container>
    <me-aside v-if="$store.state.isShowAside"></me-aside>
    <el-container style="min-width: 800px;">
       <el-header class="mini-im-header">
        <me-heaser title="sdfsd"></me-heaser>
      </el-header>
      <el-main :style="'background-color:' + workbenchBgColor">
        <router-view></router-view>
      </el-main>
    </el-container>
    <EditProfile />
    <EditPassword />
  </el-container>
</template>

<script>

import MeAside from "@/components/me-aside.vue";
import MeHeaser from "@/components/me-header.vue";
import EditProfile from "@/components/me-edit-profile.vue";
import EditPassword from "@/components/me-edit-password.vue";

export default {
  name: "home",
  components: {
    MeAside,MeHeaser,EditProfile,EditPassword
  },
  computed: {
    workbenchBgColor(){
      if(this.$route.path == "/workbench"){
        return this.$store.getters.workbenchBgColor
      }
      return "#ffffff"
    }
  }
};
</script>
<style lang="stylus" scoped>
  .mini-im-header{
    background-color #545c64
    border-bottom 1px solid #545c64
  }
</style>
