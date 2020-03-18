<template>
  <div>
    <div class="mini-im-head">
      <span>
        <i class="el-icon-picture-outline-round"></i>
        <span slot="title">机器人管理</span>
      </span>
       <el-button  v-if="adminInfo.root == 1" @click="createDialogFormVisible = true" size="mini">添 加</el-button>
    </div>
    <el-divider />
    <el-table
      :data="tableData"
      style="width: 100%"
       v-loading="loading"
    >
      <el-table-column
        type="index"
        width="60">
      </el-table-column>
      <el-table-column
        prop="avatar"
        label="头像"
        width="80">
        <template slot-scope="scope">
          <el-avatar :size="40" :src="scope.row.avatar"></el-avatar>
        </template>
      </el-table-column>
      <el-table-column
        prop="nickname"
        label="机器人昵称">
      </el-table-column>
      <el-table-column
        prop="welcome"
        label="欢迎语">
      </el-table-column>
      <el-table-column
        prop="understand"
        label="无匹配知识库语">
      </el-table-column>
      <el-table-column
        prop="timeout_text"
        label="超时结束提示">
      </el-table-column>
      <el-table-column
        prop="no_services"
        label="无人工在线提示">
      </el-table-column>
      <el-table-column
        prop="loog_time_wait_text"
        label="长时间等待提示">
      </el-table-column>
      <el-table-column
        prop="keyword"
        label="检索知识库热词">
        <template slot-scope="scope">
          <span>{{scope.row.keyword.replace(/\|/g, " , ")}}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="artificial"
        label="转人工关键词">
        <template slot-scope="scope">
          <span>{{scope.row.artificial.replace(/\|/g, " , ")}}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="switch"
         align="center"
        label="运行状态">
        <template slot-scope="scope">
          <el-tag type="success" v-if="scope.row.switch == 1">服务中</el-tag>
          <el-tag type="danger" v-if="scope.row.switch == 0">服务暂停</el-tag>
        </template>
      </el-table-column>
      <el-table-column
       align="center"
        prop="platform"
        label="服务平台">
        <template slot-scope="scope">
          <el-tag>{{$getPlatformItem(scope.row.platform).title}}</el-tag>
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
        v-if="adminInfo.root == 1"
        prop="operating"
        align="center"
        label="操作"
        width="150"
        >
        <template slot-scope="scope">
            <el-button
              size="mini"
              @click="edit(scope.row)">编 辑</el-button>
            <el-button
              size="mini"
              type="danger"
              @click="deleteRobot(scope.row)">删 除</el-button>
          </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" style="margin-top: 20px;" justify="space-between">
      <span style="color:#666;font-size: 14px;">当前有{{tableData.length}}个机器人</span>
    </el-row>
    <CreateDialog :complete="getRobotList" :dialogFormVisible.sync="createDialogFormVisible" />
    <EditDialog :complete="getRobotList" :formData="editItem" :dialogFormVisible.sync="editDialogFormVisible" />
  </div>
</template>

<script>
import CreateDialog from "./create"
import EditDialog from "./edit"
import axios from 'axios'
export default {
  name: "robot",
  components: {
    CreateDialog,
    EditDialog
  },
  data() {
    return {
      createDialogFormVisible: false,
      editDialogFormVisible: false,
      loading: true,
      editItem: {}
    }
  },
  created(){
    setTimeout( ()=> this.getRobotList(), 500)
  },
  computed: {
    tableData(){
      return this.$store.getters.robots || []
    },
    adminInfo(){
      return this.$store.getters.adminInfo || {}
    }
  },
  methods: {
    // 删除
    deleteRobot(item){
      this.$confirm('您确定要删除该机器人吗? 删除后不可恢复！', '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        axios.delete('/robot/' + item.id)
        .then(response => {
            console.log(response.data)
            this.$message.success("删除成功")
            this.getRobotList()
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
    // 获取数据
    getRobotList(){
      axios.get('/robot/list')
      .then(response => {
          this.loading = false
          this.$store.commit('onChangeRobos', response.data.data)
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
</style>
