
<template>
    <div>
      <div class="me-head">
        <span>
          <i class="el-icon-tickets"></i>
          <span slot="title">工单系统</span>
        </span>
        <el-button size="mini">设置</el-button>
      </div>
       <el-divider />
        <el-table :data="tableData.list" style="width: 100%" v-loading="loading">
      <el-table-column type="index" :index="indexMethod" width="60"></el-table-column>
      <el-table-column prop="nickname" label="用户"></el-table-column>
      <el-table-column prop="title" label="工单标题"></el-table-column>
      <el-table-column prop="status" label="当前状态">
         <template slot-scope="scope">
          <el-tag type="warning" v-if="scope.row.status == 0">待处理</el-tag>
          <el-tag type="warning" v-if="scope.row.status == 1">待回复</el-tag>
          <el-tag type="success" v-if="scope.row.status == 2">已回复</el-tag>
          <el-tag type="info" v-if="scope.row.status == 3">已结束</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="create_at" label="创建时间">
        <template slot-scope="scope">{{$formatUnixDate(scope.row.create_at, "YYYY/MM/DD")}}</template>
      </el-table-column>
      <el-table-column prop="operating" align="center" width="150" label="操作">
        <template>
          <el-button size="mini">查 看</el-button>
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
</template>
<script>
import axios from "axios";
export default {
  name: 'workorder-index',
  data(){
    return {
      loading: true,
      tableData: {
        list: [],
        page_on: 1,
        page_size: 10,
        total: 0,
        status: -1,
        tid: 0,
      },
    }
  },
  created() {
    setTimeout(() => {
      this.getWorkorderList();
    }, 500);
  },
  methods: {
    // 行号
    indexMethod(index) {
      return (
        (this.tableData.page_on - 1) * this.tableData.page_size + index + 1
      );
    },
    // 获取数据
    getWorkorderList(index) {
      if (index) this.tableData.page_on = index;
      const { page_on, page_size, tid, status } = this.tableData;
      axios
        .post("/workorder/list", { page_on, page_size, tid, status })
        .then(response => {
          this.loading = false;
          this.tableData = response.data.data;
        })
        .catch(error => {
          this.loading = false;
          this.$message.error(error.response.data.message);
        });
    },
    // 改变每页条数
    handleSizeChange(val) {
      this.tableData.page_size = val;
      this.getKnowledgeList();
    },
    // 分页
    handleCurrentChange(val) {
      this.tableData.page_on = val;
      this.getKnowledgeList();
    },
  }
}
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
</style>

