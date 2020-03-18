<template>
  <div>
    <div class="mini-im-head">
      <span>
        <i class="el-icon-headset"></i>
        <span slot="title">客服管理</span>
      </span>
       <el-button v-if="adminInfo.root == 1" @click="createDialogFormVisible = true" size="mini">添 加</el-button>
    </div>
    <el-divider />
    <div class="search">
      <el-row :gutter="20">
        <el-col :span="2.1">
          <el-form ref="form" label-width="120px">
            <el-form-item  label="按关键字："></el-form-item>
          </el-form>
        </el-col>
        <el-col :span="5">
          <el-input @change="changeInput" @clear="clearKeyword" placeholder="请输入关键词" v-model="tableData.keyword" clearable prefix-icon="el-icon-search"></el-input>
        </el-col>
        <el-col :span="3">
          <el-button @click="search">查 找</el-button>
        </el-col>
      </el-row>
    </div>
    <el-table
      :data="tableData.list"
      style="width: 100%"
      v-loading="loading"
    >
      <el-table-column
        type="index"
        :index="indexMethod"
        width="60">
      </el-table-column>
      <el-table-column
        prop="avatar"
        label="头像"
        width="120">
       <template slot-scope="scope">
          <el-avatar :size="40" :src="scope.row.avatar || $store.state.avatar"></el-avatar>
        </template>
      </el-table-column>
       <el-table-column
        prop="username"
        label="客服账号">
      </el-table-column>
      <el-table-column
        prop="nickname"
        label="客服昵称">
      </el-table-column>
      <el-table-column
        prop="online"
         align="center"
        label="在线状态">
        <template slot-scope="scope">
          <el-tag type="success" v-if="scope.row.online == 1">在线</el-tag>
          <el-tag type="warning" v-if="scope.row.online == 2">繁忙</el-tag>
          <el-tag type="info" v-if="scope.row.online == 0">离线</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="root"
         align="center"
        label="角色">
        <template slot-scope="scope">
          <el-tag effect="dark" type="warning" v-if="scope.row.root == 1">超级管理</el-tag>
          <el-tag v-if="scope.row.root == 0">客服人员</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="last_activity"
        label="最后在线时间">
        <template slot-scope="scope">
          {{$formatUnixDate(scope.row.last_activity, "YYYY/MM/DD HH:mm")}}
        </template>
      </el-table-column>
      <el-table-column
        prop="create_at"
        label="创建时间">
        <template slot-scope="scope">
          {{$formatUnixDate(scope.row.create_at, "YYYY/MM/DD")}}
        </template>
      </el-table-column>
      <el-table-column
        prop="operating"
        align="center"
        width="150"
        v-if="adminInfo.root == 1"
        label="操作">
        <template slot-scope="scope">
        <el-button
          size="mini"
          v-if="scope.row.root == 0"
          @click="edit(scope.row)">编 辑</el-button>
        <el-button
          size="mini"
          type="danger"
          v-if="scope.row.root == 0"
          @click="deleteAdmin(scope.row)">删 除</el-button>
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
    <CreateDialog :complete="getAdmins" :dialogFormVisible.sync="createDialogFormVisible" />
    <EditDialog :formData="editItem" :complete="getAdmins" :dialogFormVisible.sync="editDialogFormVisible" />
  </div>
</template>

<script>
import CreateDialog from "./create"
import EditDialog from "./edit"
import axios from 'axios'
export default {
  name: "admins",
  components: {
    CreateDialog,
    EditDialog
  },
  data() {
    return {
      tableData: {
        list: [],
        page_on: 1,
        page_size: 10,
        keyword: "",
        total: 0,
      },
      createDialogFormVisible: false,
      editDialogFormVisible: false,
      loading: true,
      editItem: {}
    }
  },
  computed: {
    adminInfo(){
      return this.$store.getters.adminInfo
    }
  },
  created(){
    setTimeout(()=> this.getAdmins(1), 500)
  },
  methods: {
     // 行号
    indexMethod(index) {
      return (this.tableData.page_on - 1) * this.tableData.page_size + index +1;
    },
    // 删除
    deleteAdmin(item){
      this.$confirm('您确定要删除该客服吗? 删除后不可恢复！', '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        axios.delete('/admin/' + item.id)
        .then(response => {
            console.log(response.data)
            this.$message.success("删除成功")
            this.getAdmins(1)
        })
        .catch(error => {
          this.$message.error(error.response.data.message)
        });
      })
    },
    // 编辑
    edit(item){
      this.editItem = item
      this.editDialogFormVisible = true
    },
    // 改变每页条数
    handleSizeChange(val) {
      this.tableData.page_size = val
      this.getAdmins()
    },
    // 分页
    handleCurrentChange(val) {
      this.tableData.page_on = val
      this.getAdmins()
    },
    // 清空关键字
    clearKeyword(){
      this.getAdmins(1)
    },
    // 关键字input变动
    changeInput(){
      if(this.tableData.keyword == ""){
        this.getAdmins(1)
      }
    },
    // 查找
    search(){
      this.tableData.keyword = this.tableData.keyword.trim()
      if(!this.tableData.keyword) return
      this.getAdmins(1)
    },
    // 获取数据
    getAdmins(index){
      if(index) this.tableData.page_on = index
      const {page_on, page_size, keyword} = this.tableData
      axios.post('/admin/list', {page_on, page_size, keyword, "online": 3})
      .then(response => {
          this.loading = false
          this.tableData = response.data.data
      })
      .catch(error => {
        this.loading = false
        this.$message.error(error.response.data.message)
      });
    }
  }
};
</script>
<style lang="stylus" scoped>
  .mini-im-head{
    height 30px
    display flex
    align-items center
    font-size 20px
    justify-content space-between
    color #666
    i{
      margin-right 5px
    }
  }
  .el-select .el-input {
    width: 130px;
  }
  .input-with-select .el-input-group__prepend {
    background-color: #fff;
  }
</style>
