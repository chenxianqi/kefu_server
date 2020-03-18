<template>
  <div>
    <div class="mini-im-head">
      <span>
        <i class="el-icon-user"></i>
        <span slot="title">用户管理</span>
      </span>
    </div>
    <el-divider />
    <div class="search">
      <el-row :gutter="20">
        <el-col style="width: 120px">
          <el-form ref="form" label-width="120px">
            <el-form-item label="按条件查找："></el-form-item>
          </el-form>
        </el-col>
        <el-col :span="3">
          <el-select v-model="tableData.platform" placeholder="请选择平台">
            <el-option
              v-for="item in platformConfig"
              :key="item.id"
              :label="item.title"
              :value="item.id"
            ></el-option>
          </el-select>
        </el-col>
        <el-col :span="4">
          <el-input placeholder="请输入关键词" prefix-icon="el-icon-search" v-model="tableData.keyword" clearable></el-input>
        </el-col>
        <el-col :span="6.5">
          <el-date-picker
            v-model="selectDate"
            type="daterange"
            align="right"
            unlink-panels
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          ></el-date-picker>
        </el-col>
        <el-col :span="3">
          <el-button @click="search">查 找</el-button>
        </el-col>
      </el-row>
    </div>
    <el-table :data="tableData.list" v-loading="loading" style="width: 100%">
       <el-table-column
        type="index"
        :index="indexMethod"
        width="60">
      </el-table-column>
      <el-table-column prop="avatar" label="头像" width="80">
        <template slot-scope="scope">
          <el-avatar :size="40" :src="scope.row.avatar || $store.state.avatar"></el-avatar>
        </template>
      </el-table-column>
      <el-table-column prop="nickname" label="用户昵称">
        <template slot-scope="scope">
          <span v-if="scope.row.nickname != ''">{{scope.row.nickname}}</span>
          <span v-else>------</span>
        </template>
      </el-table-column>
      <el-table-column prop="uid" label="业务平台ID">
         <template slot-scope="scope">
          <span v-if="scope.row.uid != ''">{{scope.row.uid}}</span>
          <span v-else>------</span>
        </template>
      </el-table-column>
      <el-table-column prop="address" label="所在地区">
         <template slot-scope="scope">
          <span v-if="scope.row.address != ''">{{scope.row.address}}</span>
          <span v-else>------</span>
        </template>
      </el-table-column>
      <el-table-column prop="phone" label="联系方式">
         <template slot-scope="scope">
          <span v-if="scope.row.phone != ''">{{scope.row.phone}}</span>
          <span v-else>------</span>
        </template>
      </el-table-column>
      <el-table-column prop="online" align="center" label="在线状态">
        <template slot-scope="scope">
          <el-tag type="success" v-if="scope.row.online == 1">在线</el-tag>
          <el-tag type="info" v-if="scope.row.online == 0">离线</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="platform" align="center" label="服务平台">
         <template slot-scope="scope">
          <el-tag>{{$getPlatformItem(scope.row.platform).title}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="remarks" label="备注">
         <template slot-scope="scope">
          {{scope.row.remarks || '------'}}
        </template>
      </el-table-column>
      <el-table-column prop="create_at" label="注册时间">
         <template slot-scope="scope">
          {{$formatUnixDate(scope.row.create_at, "YYYY/MM/DD")}}
        </template>
      </el-table-column>
      <el-table-column prop="operating" align="center" label="操作" width="150">
        <template slot-scope="scope">
          <el-button size="mini" @click="edit(scope.row)">编 辑</el-button>
          <el-button v-if="$store.getters.adminInfo.root == 1" size="mini" type="danger" @click="deleteUser(scope.row)">删 除</el-button>
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
        :total="tableData.total">
      </el-pagination>
    </el-row>
    <EditDialog :complete="getUsers" :formData="editItem" :dialogFormVisible.sync="editDialogFormVisible" />
  </div>
</template>

<script>
import EditDialog from "./edit";
import axios from 'axios'
var moment = require('moment');
export default {
  name: "robot",
  components: {
    EditDialog
  },
  data() {
    return {
      loading: true,
      selectDate: [],
      tableData: {
        list: [],
        page_on: 1,
        page_size: 10,
        keyword: "",
        total: 0,
        platform: 1,
        date_start: "",
        date_end: "",
      },
      editItem: {},
      editDialogFormVisible: false,
    };
  },
  computed: {
    platformConfig(){
      return this.$store.getters.platformConfig
    }
  },
  created() {
    setTimeout(()=> this.getUsers(1), 500)
  },
  methods: {
     // 行号
    indexMethod(index) {
      return (this.tableData.page_on - 1) * this.tableData.page_size + index +1;
    },
    // 编辑
    edit(item){
      this.editItem = item
      this.editDialogFormVisible = true
    },
    // 删除
    deleteUser(item) {
      this.$confirm('您确定要删除该用户吗? 删除后不可恢复！', '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        axios.delete('/user/' + item.id)
        .then(response => {
            console.log(response.data)
            this.$message.success("删除成功")
            this.getUsers(1)
        })
        .catch(error => {
          this.$message.error(error.response.data.message)
        });
      })
    },
     // 改变每页条数
    handleSizeChange(val) {
      this.tableData.page_size = val
      this.getUsers()
    },
    // 分页
    handleCurrentChange(val) {
      this.tableData.page_on = val
      this.getUsers()
    },
    // 查询
    search(){
      if(this.selectDate.length == 2){
        this.tableData.date_start = moment(this.selectDate[0]).format("YYYY-MM-DD")
        this.tableData.date_end = moment(this.selectDate[1]).format("YYYY-MM-DD")
      }else{
        this.tableData.date_start = ""
        this.tableData.date_end = ""
      }
      this.getUsers(1)
    },
    // 获取数据
    getUsers(index){
      if(index) this.tableData.page_on = index
      const {page_on, page_size, keyword, date_start, date_end, platform} = this.tableData
      axios.post('/user/list', {page_on, page_size, keyword, date_start, date_end, platform})
      .then(response => {
        this.loading = false
        this.tableData = response.data.data
      })
      .catch(error => {
        this.loading = false
        this.$message.error(error.response.data.message)
      });
    },
  }
};
</script>
<style lang="stylus" scoped>
.mini-im-head {
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
