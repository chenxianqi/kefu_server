<template>
  <div class="container">
    <mt-header v-if="isShowHeader" fixed :title="workorder.title || '工单详情'">
      <div slot="left">
        <mt-button @click="$router.go(-1)" icon="back"></mt-button>
      </div>
      <mt-button slot="right">
        <span>删除</span>
      </mt-button>
    </mt-header>
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import axios from "axios";
export default {
  name: "workorder_detail",
  components: {},
  data() {
    return {
      workorder: {},
    };
  },
  computed: {
    ...mapGetters([
      'isShowHeader',
      'workorders',
      'workorderTypes',
    ])
  },
  created() {
    document.title = "工单详情"
    const id = this.$route.params.id
    this.getWorkOrder(id)
  },
  methods: {
    getWorkOrder(id){
      axios.get("/public/workorder/"+id).then(response => {
        this.workorder = response.data.data
        console.log(this.workorder)
      }).catch(error => {
        console.log(error)
      });
    }
  }
};
</script>
<style lang="stylus" scoped>

</style>

