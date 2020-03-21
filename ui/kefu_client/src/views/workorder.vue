<template>
  <div class="container">
    
    <mt-header v-if="isShowHeader" fixed title="工单">
      <div slot="left">
        <mt-button @click="$router.go(-1)" icon="back"></mt-button>
      </div>
      <mt-button @click="$router.push('/workorder/create')" slot="right">
        <span>创建工单</span>
      </mt-button>
    </mt-header>

  </div>
</template>
<script>
import { mapGetters } from 'vuex'
export default {
  name: "workorder",
  components: {},
  data() {
    return {};
  },
  computed: {
    ...mapGetters([
      'isShowHeader'
    ])
  },
  mounted() {},
  methods: {
   
  }
};
</script>
<style lang="stylus" scoped>

</style>

