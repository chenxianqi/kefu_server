
<template>
  <div>
    <div class="me-head">
      <span>
        <i class="el-icon-tickets"></i>
        <span slot="title">工单管理</span>
        <span style="font-size:15px;margin-left: 30px;color:#e7a646">
           当前有： 
          <template v-if="workOrderCounts.status0 > 0">
              <strong style="color: #f56c6c">{{workOrderCounts.status0}}</strong>条待处理 ，
          </template>
          <template v-if="workOrderCounts.status2 > 0">
             <strong style="color: #f56c6c"> {{workOrderCounts.status2}}</strong>条待回复工单 
          </template>
        </span>
      </span>
      <el-row style="width:300px;" type="flex" align="middle" justify="space-between" v-if="adminInfo.root == 1">
       <div class="switch">
          <el-switch
          @change="changeSwitch"
          v-model="isOpenWorkorder"
          inactive-color="#cccccc"
          active-color="#8bc34a"
          :active-text="isOpenWorkorder ? '工单功能启用中' : '工单功能关闭中'"
        >
        </el-switch>
        <div>工单关闭后客户端无法发起工单~</div>
       </div>
        <div>
          <el-button size="mini" @click="isShowTypesView = true">分类设置</el-button>
        </div>
      </el-row>
    </div>
    <el-divider />
    <el-row class="container-box" type="flex" justify="space-between">
      <div class="menu">
        <el-tabs @tab-click="tabsChange" tab-position="left" style="width:200px;height: 80vh;">
          <template size="small" v-for="item in workorderTypes" border>
            <el-tab-pane :key="item.id" :label="item.title + '（'+item.count+'）'"></el-tab-pane>
          </template>
        </el-tabs>
      </div>
      <div class="table-content">
        <el-table :data="tableData.list" style="width: 100%" v-loading="loading">
        <el-table-column type="index" :index="indexMethod" width="60" label="#序号"></el-table-column>
        <el-table-column prop="title" label="工单标题"></el-table-column>
        <el-table-column prop="status" label="状态">
          <template slot-scope="scope">
            <template v-if="workorderTypes.length-1 == tabIndex">
            <span style="color:#f56c6b">已删除</span>
           </template>
            <template v-else>
              <el-tag type="danger" v-if="scope.row.status == 0">待客服处理</el-tag>
              <el-tag type="warning" v-if="scope.row.status == 2">待客服回复</el-tag>
              <el-tag type="success" v-if="scope.row.status == 1">客服已回复</el-tag>
              <el-tag type="info" v-if="scope.row.status == 3"> 工单已结束 </el-tag>
             </template>
          </template>
        </el-table-column>
        <el-table-column prop="u_nickname" label="用户"></el-table-column>
        <el-table-column prop="a_nickname" label="最近处理（客服）">
          <template slot-scope="scope">
            {{scope.row.a_nickname || '-----'}}
          </template>
        </el-table-column>
        <el-table-column prop="create_at" label="创建时间">
          <template slot-scope="scope">{{$formatUnixDate(scope.row.create_at, "YYYY/MM/DD")}}</template>
        </el-table-column>
        <el-table-column prop="operating" align="center" width="150" label="操作">
          <template slot-scope="scope">
            <el-button @click="onShow(scope.row)" size="mini">查 看</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-row type="flex" style="margin-top: 20px;" justify="space-between">
        <span style="color:#666;font-size: 14px;">共找到{{tableData.total}}条数据</span>
        <el-pagination
          background
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          layout="sizes, prev, pager, next"
          :current-page="tableData.page_on"
          :page-sizes="[5, 10, 15, 20]"
          :total="tableData.total"
        ></el-pagination>
      </el-row>
      </div>
    </el-row>
     <WorkOrderView :workorderTypes="workorderTypes" :prop="showWorkOrder" v-model="isShowWorkOrderView" />
     <WorkOrderTypesView :workorderTypes="workorderTypes" v-model="isShowTypesView" />
  </div>
</template>
<script>
import axios from "axios";
import WorkOrderView from "./workorder-view"
import WorkOrderTypesView from "./workorder-types-view"
import { mapGetters } from 'vuex'
export default {
  name: "workorder-index",
  components: {
    WorkOrderView,
    WorkOrderTypesView
  },
  data() {
    return {
      loading: true,
      isShowWorkOrderView: false,
      isShowTypesView: false,
      showWorkOrder: {},
      tableData: {
        list: [],
        page_on: 1,
        page_size: 10,
        total: 0,
        status: "",
        del: 0,
        tid: 0
      },
      tabIndex: 0,
      del: 0,
      isOpenWorkorder: false,
      workorderTypes:[],
    };
  },
  computed: {
    workStatus(){
      if(this.tabIndex == this.workorderTypes.length-1 && this.workorderTypes.length > 1){
        return '0,1,2,3'
      }
      if(this.tabIndex == this.workorderTypes.length-2 && this.workorderTypes.length > 1){
        return '3'
      }
      return "0,1,2"
    },
    ...mapGetters([
      "workOrderCounts",
      "adminInfo",
      "systemInfo",
      "configs",
    ])
  },
  created() {
    this.getWorkorderList();
    this.getWorkorderTypes()
    this.isOpenWorkorder = this.configs.open_workorder == 1
    this.$store.dispatch('ON_GET_WORKORDER_COUNTS')
  },
  methods: {
    onShow(item){
      this.showWorkOrder = item
      this.isShowWorkOrderView = true
    },
    tabsChange(tab){
      this.tabIndex = parseInt(tab.index)
      this.del = 0
      if(this.tabIndex == this.workorderTypes.length-1) this.del = 1
      this.changeType(this.workorderTypes[this.tabIndex].id)
    },
    changeSwitch(open){
      var title = "您确定打开工单功能吗？"
      var open_workorder = 1
      if(!open){
        title = "您确定关闭工单功能吗？"
        open_workorder = 0
      }
      this.$confirm(title, "温馨提示！", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        axios
          .put("/system/workorder/", {open_workorder})
          .then(() => {
            this.$store.dispatch('ON_GET_CONFIGS')
          })
          .catch(error => {
            this.$message.error(error.response.data.message);
          });
      }).catch(() => {
        this.isOpenWorkorder = !this.isOpenWorkorder       
      });
    },
    // 行号
    indexMethod(index) {
      return (
        (this.tableData.page_on - 1) * this.tableData.page_size + index + 1
      );
    },
    changeType(tid){
      this.tableData.tid = tid;
      this.getWorkorderList(1);
    },
    // 获取数据
    getWorkorderList(index) {
      if (index) this.tableData.page_on = index;
       this.tableData.status =  this.workStatus
       this.tableData.del = this.del
      const { page_on, page_size, tid, status, del } = this.tableData;
      axios
        .post("/workorder/list", { page_on, page_size, tid, status, del })
        .then(response => {
          this.loading = false;
          this.tableData = response.data.data;
        })
        .catch(error => {
          this.loading = false;
          this.$message.error(error.response.data.message);
        });
    },
    // 获取类型数据
    getWorkorderTypes() {
      axios
        .get("/workorder/types")
        .then(response => {
          this.workorderTypes = [{
            "id": 0,
            "count": 0,
            "title": "全部工单"
          }];
          this.workorderTypes = this.workorderTypes.concat(response.data.data);
           for(var i=0; i<response.data.data.length; i++){
             this.workorderTypes[0].count += response.data.data[i].count
           }
           this.workorderTypes.push({
            "id": -1,
            "count": this.workOrderCounts.status3,
            "title": "已结单"
          })
          this.workorderTypes.push({
            "id": -2,
            "count": this.workOrderCounts.delete_count,
            "title": "回收站"
          })
        })
        .catch(error => {
          this.$message.error(error.response.data.message);
        });
    },
    // 改变每页条数
    handleSizeChange(val) {
      this.tableData.page_size = val;
      this.getWorkorderList();
    },
    // 分页
    handleCurrentChange(val) {
      this.tableData.page_on = val;
      this.getWorkorderList();
    }
  },
  watch: {
    isShowTypesView(show){
      if(!show){
        this.workorderTypes = []
        this.getWorkorderTypes();
      }
    },
    isShowWorkOrderView(show){
      if(!show){
        this.$store.dispatch('ON_GET_WORKORDER_COUNTS')
        this.getWorkorderList();
      }
    },
    systemInfo(){
      this.isOpenWorkorder = this.systemInfo.open_workorder == 1
    }
  }
};
</script>
<style scoped lang="stylus">
.me-head {
  height: 30px;
  display: flex;
  align-items: center;
  font-size: 20px;
  justify-content: space-between;
  color: #666;
  .switch{
    div{
      font-size 13px
      padding-top 5px
      color #ccc
      span.el-switch__label{
        color #ff5722!important
      }
    }
  }
  i {
    margin-right: 5px;
  }
}
.container-box{
  .menu{
    flex-shrink: 0;
    width 180px;
  }
  .table-content{
    width 500px;
    flex-grow 1
  }
}
</style>
<style lang="stylus">
.switch{
  div{
    span.el-switch__label{
      color #ff5722!important
    }
    span.el-switch__label.is-active{
      color #8bc34a!important
    }
  }
}
</style>

