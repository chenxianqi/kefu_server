<template>
  <div class="container">
    <mt-header v-if="isShowHeader" fixed title="工单详细">
      <div slot="left">
        <mt-button @click="$router.go(-1)" icon="back"></mt-button>
      </div>
      <mt-button v-if="workorder.status == 3" slot="right">
        <span>删除</span>
      </mt-button>
    </mt-header>
    <div class="content"  :class="{'hide-header': !isShowHeader}">
      <div class="head">
        <div class="con">
          <span>标题：</span>
          <span>{{workorder.title}}</span>
        </div>
        <div class="con">
          <span>内容：</span>
          <span v-html="workorder.content"></span>
        </div>
        <div class="con">
          <span>电话：</span>
          <span>{{workorder.phone || '未预留电话号码'}}</span>
        </div>
        <div class="con">
          <span>邮箱：</span>
          <span>{{workorder.email || '未预留邮箱'}}</span>
        </div>
        <div class="con">
          <span>时间：</span>
          <span>{{$formatDate(workorder.create_at)}}</span>
        </div>
        <div class="con">
          <span>状态：</span>
          <span>
            <i v-if="workorder.status == 1" style="color:#8bc34a;">已回复</i>
            <i v-if="workorder.status == 3" style="color:#ccc">已结束</i>
            <i v-if="workorder.status == 0 || workorder.status == 2" style="color:#FF9800">待处理</i>
          </span>
        </div>
      </div>
    </div>
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
      comments:[]
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
    document.title = "工单详细"
    const id = this.$route.params.id
    this.$store.commit("updateState", {isShowPageLoading: true});
    axios.all([this.getWorkOrder(id), this.getComments(id)])
    .then(axios.spread(() => {
      this.$store.commit("updateState", {isShowPageLoading: false});
    }));
  },
  methods: {
    getWorkOrder(id){
      return axios.get("/public/workorder/"+id).then(response => {
        this.workorder = response.data.data
        console.log(this.workorder)
      }).catch(error => {
        console.log(error)
      });
    },
    getComments(id){
      return axios.get("/public/workorder/comments/"+id).then(response => {
        this.comments = response.data.data
        console.log(this.comments)
      }).catch(error => {
        console.log(error)
      });
    }
  }
};
</script>
<style lang="stylus" scoped>
  .content{
    padding-top 50px
    &.hide-header{
      padding-top 0
    }
    .head{
      margin 0 10px
      padding 10px 0
      border-bottom 1px solid rgba(158, 158, 158, 0.13);
      .con{
        font-size 15px
        color #333
        display flex
        margin-bottom 8px
        span{
          flex-flow 1
        }
        span:first-child{
          flex-flow 0
          flex-shrink 0
          width 45px
        }
        i{
          font-style normal
        }
      }
  
    }
  }
</style>

