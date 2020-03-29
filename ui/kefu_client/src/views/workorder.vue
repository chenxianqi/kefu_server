<template>
  <div class="container">
    
    <mt-header v-if="isShowHeader" fixed title="我的工单">
      <div slot="left">
        <mt-button @click="$router.go(-1)" icon="back"></mt-button>
      </div>
      <mt-button @click="$router.push('/workorder/create')" slot="right">
        <span>创建工单</span>
      </mt-button>
    </mt-header>
    <div class="list" :class="{'hide-header': !isShowHeader}">
      <div class="no-data" v-if="workorders.length <= 0">
        <img src="../assets/workorder.png" alt="">
        <div>没有相关记录~</div>
      </div>
      <ul v-else>
        <template v-for="(item,index) in workorders">
          <li :key="index" @click="$router.push('/workorder/detail/'+item.id)">
            <div class="title">{{item.title}}</div>
            <div>
              <span class="type">{{getTypeName(item.tid)}}</span>
              <span class="date">{{$formatDate(item.create_at)}}</span>
            </div>
            <i v-if="item.status == 1" style="color:#8bc34a;">已回复</i>
            <i v-if="item.status == 3" style="color:#ccc">已结束</i>
            <i v-if="item.status == 0" style="color:#FF9800">待处理</i>
            <i v-if="item.status == 2" style="color:#FF9800">待回复</i>
          </li>
        </template>
      </ul>        
    </div>

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
  created() {
    document.title = "我的工单"
  },
  computed: {
    ...mapGetters([
      'isShowHeader',
      'workorders',
      'workorderTypes',
    ])
  },
  mounted() {
    // 获取工单类型
    this.$store.dispatch("onGetWorkorderTypes");
    // 获取工单列表
    this.$store.dispatch("onGetWorkorders");
  },
  methods: {
    getTypeName(tid){
      try{
      return this.workorderTypes.filter((i)=>i.id == tid)[0].title
      }catch(e){
        console.log(e)
        return ""
      }
    }
  }
};
</script>
<style lang="stylus" scoped>
.no-data{
  text-align center
  padding-top 50px
  img{
    width 50px
    height 50px
  }
  div{
    color #666
    font-size 14px
  }
}
.list{
  padding-top 50px
  &.hide-header{
    padding-top 0
  }
  li{
    padding 10px 20px
    background url('../assets/workorder.png') 10px center no-repeat 
    background-size 25px
    padding-left 40px
    padding-right 70px
    border-bottom 1px solid #ddd
    position relative
    height 40px
    .title{
      font-size 15px
      color #333
      text-overflow: ellipsis;
      overflow: hidden;
      white-space: nowrap;
    }
    .type{
      font-size 13px
      color #666
    }
    .date{
      margin-left 10px
      font-size 13px
      color #999
    }
    i{
      font-style normal
      font-size 13px
      position absolute
      right 10px
      top 0
      height: 20px;
      bottom 0
      margin auto 0
    }
  }
}

</style>

