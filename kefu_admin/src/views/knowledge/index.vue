<template>
  <div>
    <div class="me-head">
      <span>
        <i class="el-icon-reading"></i>
        <span slot="title">知识库管理 </span>
      </span>
        <el-button-group>
       <template v-for="item in total" >
           <el-button :class="{'el-button--primary': item.id + '' == tableData.platform + ''}" @click="onTogglePlatform(item.id)" :key="item.id" size="mini">
            {{item.title}} ({{item.count}})
            </el-button>
       </template>
      </el-button-group>  
       <el-col :span="5">
          <el-input @change="onRefresh" placeholder="请输入关键词" prefix-icon="el-icon-search" v-model="keyword" clearable></el-input>
        </el-col>
       <el-button @click="createDialogFormVisible = true" size="mini">添 加</el-button>
    </div>
    <el-divider />
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
        prop="title"
        label="主标题">
      </el-table-column>
      <el-table-column
        prop="sub_title"
        label="子标题">
        <template slot-scope="scope">
          <div v-if="scope.row.sub_title != ''">
            <div style="font-size: 13px;" :key="key" v-for="(item, key) in scope.row.sub_title.split('|')">
              {{key+1}}.{{item}}
            </div>
          </div>
          <div v-else>-----</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="content"
        label="内容">
        <template slot-scope="scope">
             <div style="font-size: 13px;" :key="key" v-for='(item, key) in scope.row.content.split("\n")'>
                {{item}}
              </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="platform"
         align="center"
        label="匹配平台">
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
        prop="operating"
        align="center"
        width="150"
        label="操作">
         <template slot-scope="scope">
            <el-button
              size="mini"
              @click="edit(scope.row)">编 辑</el-button>
            <el-button
              size="mini"
              type="danger"
              @click="deleteKnowledge(scope.row)">删 除</el-button>
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
    <CreateDialog :complete="onRefresh" :dialogFormVisible.sync="createDialogFormVisible" />
    <EditDialog :formData="editItem" :complete="onRefresh" :dialogFormVisible.sync="editDialogFormVisible" />
  </div>
</template>

<script>
import CreateDialog from "./create"
import EditDialog from "./edit"
import axios from 'axios'
export default {
  name: "knowledge",
  components: {
    CreateDialog,
    EditDialog
  },
  data() {
    return {
      keyword: "",
      tableData: {
        list: [],
        page_on: 1,
        page_size: 10,
        total: 0,
        keyword: "",
        platform: 1,
      },
      total: [],
      createDialogFormVisible: false,
      editDialogFormVisible: false,
      loading: true,
      editItem: null
    }
  },
  computed: {
    platformConfig(){
      return this.$store.state.platformConfig || []
    }
  },
  created(){
    setTimeout( ()=> {
      this.getKnowledgeList()
      this.getTotal()
    }, 500)
    
  },
  methods: {
    onRefresh(){
      this.getTotal()
      this.getKnowledgeList()
    },
    // 行号
    indexMethod(index) {
      return (this.tableData.page_on - 1) * this.tableData.page_size + index +1;
    },
    // 删除
    deleteKnowledge(item){
      this.$confirm('您确定要删除该知识库吗? 删除后不可恢复！', '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        axios.delete('/knowledge/' + item.id)
        .then(response => {
            console.log(response.data)
            this.$message.success("删除成功")
            this.getKnowledgeList(1)
        })
        .catch(error => {
          this.$message.error(error.response.data.message)
        });
      })
    },
    // 切换显示平台
    onTogglePlatform(pid){
      this.tableData.platform = parseInt(pid)
      this.getKnowledgeList(1)
    },
    // 编辑
    edit(item){
      this.editItem = item
      this.editDialogFormVisible = true
    },
    // 改变每页条数
    handleSizeChange(val) {
      this.tableData.page_size = val
      this.getKnowledgeList()
    },
    // 分页
    handleCurrentChange(val) {
      this.tableData.page_on = val
      this.getKnowledgeList()
    },
    // 获取数据
    getKnowledgeList(index){
      if(index) this.tableData.page_on = index
      const {page_on, page_size, platform} = this.tableData
      const keyword = this.keyword
      axios.post('/knowledge/list', {page_on, page_size, platform, keyword})
      .then(response => {
          this.loading = false
          this.tableData = response.data.data
      })
      .catch(error => {
        this.loading = false
        this.$message.error(error.response.data.message)
      });
    },
    // 获取统计数据
    getTotal(){
      axios.get('/knowledge/total')
      .then(response => {
          this.total = response.data.data
      })
    },
  },
};
</script>
<style lang="stylus" scoped>
  .me-head{
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
