<template>
  <div class="record-page">
    <div class="record-mini-im-head">
      <span>
        <i class="el-icon-time"></i>
        <span slot="title">服务记录</span>
      </span>
    </div>
    <el-divider />
    <div class="search">
      <el-row :gutter="20">
        <el-col style="width: 120px">
          <el-form ref="form" label-width="120px">
            <el-form-item :label="adminInfo.root == 1 ? '按客服：' : '按日期：'"></el-form-item>
          </el-form>
        </el-col>
        <el-col v-if="adminInfo.root == 1" :span="3">
          <el-select v-model="selectCustomerId" @change="refreshRecord" placeholder="请选择客服">
            <el-option
              v-for="item in customerData"
              :key="item.id"
              :label="item.nickname"
              :value="item.id"
            ></el-option>
          </el-select>
        </el-col>
        <el-col :span="5.5">
          <el-date-picker
            v-model="selectDate"
            align="right"
            type="date"
            @change="refreshRecord"
            placeholder="选择日期"
            :picker-options="pickerOptions">
          </el-date-picker>
        </el-col>
        <el-col :span="5.5">
          <el-checkbox v-model="isDeWeighting" label="去重目标客户" @change="refreshRecord" border></el-checkbox>
        </el-col>
        <el-col :span="5.5">
          <el-checkbox v-model="isReception" label="只显示未接待客户" @change="refreshRecord" border></el-checkbox>
        </el-col>
      </el-row>
    </div>
    <el-table :data="tableData.list" v-loading="loading" style="width: 100%">
       <el-table-column
        type="index"
        :index="indexMethod"
        width="60">
      </el-table-column>
      <el-table-column prop="service_account" label="接待客服">
        <template slot-scope="scope">
          <span>{{serviceNickname(scope.row.service_account)}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="nickname" label="目标客户">
         <template slot-scope="scope">
           <el-tag type="success">{{scope.row.nickname}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="is_reception" label="是否已接待">
         <template slot-scope="scope">
           <el-tag v-show="scope.row.is_reception == 0" type="danger">未接待</el-tag>
           <el-tag v-show="scope.row.is_reception == 1" type="success">已接待</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="transfer_account" label="满意度">
         <template>
          <span>-----</span>
        </template>
      </el-table-column>
      <el-table-column prop="platform" label="客户端平台">
         <template slot-scope="scope">
          <el-tag>{{$getPlatformItem(scope.row.platform).title}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="create_at" label="服务时间">
         <template slot-scope="scope">
          {{$formatUnixDate(scope.row.create_at, "YYYY/MM/DD HH:mm:ss")}}
        </template>
      </el-table-column>
      <el-table-column prop="operating" align="center" label="操作" width="150">
        <template slot-scope="scope">
          <el-button size="mini" @click="openModal(scope)">聊天记录</el-button>
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


    <!-- 聊天数据模态框 -->
    <el-dialog :visible.sync="dialogFormVisible">
      <div slot="title" class="dialog-title">
        <div style="color: #666">
          <span style="color: #e6a23c">{{serviceNickname(selectUser.service_account)}}</span>
            与
          <span style="color: #67c23a">{{selectUser.nickname}}</span>
          的聊天记录
        </div>
      </div>
      <div class="record-modal-chat-box" ref="chatBody" id="chatBody">
        <ChatsComponent
          :isMessageEnd="isMessageEnd"
          :seviceId="selectCustomerId+''"
          :seviceNickname="serviceNickname(selectUser.service_account)"
          :messages="messageRecord.list"
          :userId="selectUser.user_account"
          :userNickname="selectUser.nickname"
          :onLoadMor="onLoadMor"
          :loading="getMessageRecordLoading"/>
      </div>
    </el-dialog>


  </div>
</template>

<script>
import axios from 'axios'
var moment = require('moment');
import ChatsComponent from "./chats"
export default {
  name: "robot",
  components:{
    ChatsComponent
  },
  data() {
    return {
      loading: true,
      isDeWeighting: false,
      isReception: false,
      selectDate: Date.now(),
      tableData: {
        list: [],
        page_on: 1,
        page_size: 10,
        cid: 0,
        total: 0,
        is_de_weighting: false,
        date: "",
      },
      customerData: [],
      selectCustomerId: null,
      selectUser: {},
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now();
        },
        shortcuts: [{
          text: '今天',
          onClick(picker) {
            picker.$emit('pick', new Date());
          }
        }, {
          text: '昨天',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() - 3600 * 1000 * 24);
            picker.$emit('pick', date);
          }
        }, {
          text: '一周前',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit('pick', date);
          }
        }]
      },
      isMessageEnd: false,

      // 模态框数据
      getMessageRecordLoading: false,
      getMessageRecordPageSize: 20,
      dialogFormVisible: false,
      messageRecord: {
        list: []
      }


    };
  },
  computed: {
    platformConfig(){
      return this.$store.getters.platformConfig
    },
    adminInfo(){
      return this.$store.getters.adminInfo
    }
  },
  created() {
    this.getAdmins()
  },
  mounted(){
    setTimeout(() =>{
      this.selectCustomerId = this.adminInfo.id
      this.getRecord(1)
    }, 1000)
  },
  methods: {
     // 行号
    indexMethod(index) {
      return (this.tableData.page_on - 1) * this.tableData.page_size + index +1;
    },
     // 改变每页条数
    handleSizeChange(val) {
      this.tableData.page_size = val
      this.getRecord()
    },
    // 分页
    handleCurrentChange(val) {
      this.tableData.page_on = val
      this.getRecord()
    },
    // 获取客服昵称
    serviceNickname(id){
      let nickname = ""
      for(let i =0; i< this.customerData.length; i++){
        if(this.customerData[i].id == id){
          nickname = this.customerData[i].nickname
          break
        }
      }
      return nickname
    },
    // 获取数据
    getAdmins(){
      axios.post('/admin/list', {page_on: 1, page_size: 100, "online": 3})
      .then(response => {
          this.customerData = response.data.data.list
      })
      .catch(error => {
        this.$message.error(error.response.data.message)
      });
    },
    // 获取数据
    getRecord(index){
      this.loading = true
      if(index) this.tableData.page_on = index
      const {page_on, page_size} = this.tableData
      axios.post('/services_statistical/list', {
        page_on,
        page_size,
        cid: this.selectCustomerId,
        date: moment(this.selectDate).format("YYYY-MM-DD"),
        is_de_weighting: this.isDeWeighting,
        is_reception: this.isReception
      })
      .then(response => {
        this.loading = false
        this.tableData = response.data.data
      })
      .catch(error => {
        this.loading = false
        this.$message.error(error.response.data.message)
      });
    },
    // 刷新记录
    refreshRecord(){
      this.getRecord()
    },
    // 打开模态框
    openModal(scope){
      this.selectUser = scope.row
      this.isMessageEnd = false
      this.dialogFormVisible = true
      this.messageRecord = {
        list: []
      }
      this.getMessageRecord()
    },
    // 获取聊天记录
    getMessageRecord(timestamp){
      this.getMessageRecordLoading = true
      if(timestamp == undefined){
        timestamp = 0
      }
      axios.post('/message/list', {
        "timestamp": timestamp,
        "page_size": this.getMessageRecordPageSize,
        "service": parseInt(this.selectCustomerId),
        "account": parseInt(this.selectUser.user_account)
      })
      .then(response => {
        this.getMessageRecordLoading = false
        if(response.data.data.list.length < this.getMessageRecordPageSize){
          this.isMessageEnd = true
        }
        if(this.messageRecord.list.length == 0 || timestamp == 0){
          this.messageRecord = response.data.data
          this.scrollIntoBottom()
        }else{
          response.data.data.list = response.data.data.list.concat(this.messageRecord.list)
          this.messageRecord = response.data.data
        }
        setTimeout(()=>this.$previewRefresh(), 500)
      })
      .catch(error => {
        console.log(error)
        this.getMessageRecordLoading = false
      });
    },
    // 加载更多数据
    onLoadMor(){
      if(this.getMessageRecordLoading) return
      if(this.messageRecord.list.length >= this.messageRecord.total || this.messageRecord.total <= this.getMessageRecordPageSize){
        this.isMessageEnd = true
        return
      }
      this.getMessageRecord(this.messageRecord.list[0].timestamp)
      setTimeout(()=>{
        var chatBody = document.getElementById("chatBody")
        chatBody.scrollTop = 500
      }, 50)
    },
    // 滚动条置底
    scrollIntoBottom(){
      try{
        setTimeout(()=>{
          var chatBody = document.getElementById("chatBody")
          if(!chatBody) return
          var height = chatBody.clientHeight
          var scrollHeight = chatBody.scrollHeight
          chatBody.scrollTop = scrollHeight-height
        }, 50)
      }catch(e){
        console.log(e)
      }
    },
  }
};
</script>
<style lang="stylus">
  .record-page .record-mini-im-head {
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
  .record-page .record-modal-chat-box{
    height 600px;
    padding 0 20px
    overflow hidden
    overflow-y auto
  }
  .record-page .el-dialog__body{
    padding: 0px;
    border-top: 1px solid #f7f7f7
  }
</style>
