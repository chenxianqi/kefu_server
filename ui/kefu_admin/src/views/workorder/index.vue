
<template>
  <div>
    <div class="me-head">
      <span>
        <i class="el-icon-tickets"></i>
        <span slot="title">工单管理</span>
        <span style="font-size:15px;margin-left: 30px;color:#e7a646">当前有
           <strong style="color: #f56c6c">5</strong>
            条待处理, 和<strong style="color: #f56c6c"> 8</strong>
             条待回复工单</span>
      </span>
      <div>
        <el-button size="mini">分类设置</el-button>
      </div>
    </div>
    <el-divider />
    <div class="container-box">
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
        <el-table-column prop="status" label="当前状态">
          <template slot-scope="scope">
            <el-tag type="warning" v-if="scope.row.status == 0">等待客服处理</el-tag>
            <el-tag type="warning" v-if="scope.row.status == 2">等待客服回复</el-tag>
            <el-tag type="success" v-if="scope.row.status == 1">已有客服回复</el-tag>
            <el-tag type="info" v-if="scope.row.status == 3"> 工单已结束 </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="u_nickname" label="用户（发布者）"></el-table-column>
        <el-table-column prop="a_nickname" label="最后回复者（客服）">
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
    </div>
     <WorkOrderView :workorderTypes="workorderTypes" :prop="showWorkOrder" v-model="isShowWorkOrderView" />
  </div>
</template>
<script>
import axios from "axios";
import WorkOrderView from "./workorder-view"
export default {
  name: "workorder-index",
  components: {
    WorkOrderView
  },
  data() {
    return {
      loading: true,
      isShowWorkOrderView: false,
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
      workorderTypes:[
        {
          "id": 0,
          "count": 0,
          "title": "全部工单"
        }
      ],
    };
  },
  computed: {
    workStatus(){
      if(this.tabIndex == this.workorderTypes.length-1 && this.workorderTypes.length > 1){
        return '0,1,2,3'
      }
      return "0,1,2"
    }
  },
  created() {
    this.getWorkorderList();
    this.getWorkorderTypes()
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
          this.workorderTypes = this.workorderTypes.concat(response.data.data);
           for(var i=0; i<response.data.data.length; i++){
             this.workorderTypes[0].count += response.data.data[i].count
           }
           this.workorderTypes.push({
            "id": -1,
            "count": 0,
            "title": "已结单"
          })
          this.workorderTypes.push({
            "id": -2,
            "count": 0,
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
    isShowWorkOrderView(show){
      if(!show){
        this.getWorkorderList();
      }
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

  i {
    margin-right: 5px;
  }
}
.container-box{
  display flex
  .menu{
    flex-shrink: 0;
    width 180px;
  }
  .table-content{
    flex-grow 1
  }
}
</style>

