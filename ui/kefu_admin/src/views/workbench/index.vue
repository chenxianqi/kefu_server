<template>
   <div class="mini-im-workbench">
      <div class="mini-im-session-list">
          <div class="title">
             <el-row type="flex" justify="space-between" :gutter="20">
                <el-col :span="16">
                  <span>
                    <i class="el-icon-s-custom"></i>
                    会话列表 ( {{contacts.length}}人 )
                  </span>
                  <i style="cursor: pointer;" @click="clearContact" title="清空列表" class="el-icon-delete"></i>
                </el-col>
                <el-col :span="9">
                  <el-popover
                    placement="bottom"
                    width="100">
                    <div class="mini-im-online-setting">
                        <div v-if="adminInfo.online != 1" class="item"  @click="()=>online(1)">
                          <i style="color: rgb(135, 208, 104)" class="el-icon-circle-check"></i>
                          我要上线
                        </div>
                        <div v-if="adminInfo.online != 0" class="item" @click="()=>online(0)">
                          <i style="color: #ccc" class="el-icon-switch-button"></i>
                          我要下线
                        </div>
                        <div v-if="adminInfo.online != 2" class="item" @click="()=>online(2)">
                          <i style="color: #e6a23c" class="el-icon-remove-outline"></i>
                          繁忙状态
                        </div>
                    </div>
                    <el-button v-if="adminInfo.online == 0" size="mini" slot="reference">
                      <i  class="el-icon-switch-button"></i >
                        <em>离 线 </em>
                      <i class="el-icon-arrow-right el-icon--right"></i>
                    </el-button>
                    <el-button  v-else-if="adminInfo.online == 1" size="mini" slot="reference">
                      <span style="color: rgb(135, 208, 104)">
                        <i class="el-icon-circle-check"></i>
                          <em>在 线</em> 
                        <i class="el-icon-arrow-right el-icon--right"></i>
                      </span> 
                    </el-button>
                     <el-button  v-else size="mini" slot="reference">
                      <span style="color: #e6a23c">
                        <i class="el-icon-circle-check"></i>
                          <em>繁 忙</em> 
                        <i class="el-icon-arrow-right el-icon--right"></i>
                      </span> 
                    </el-button>
                  </el-popover>
                </el-col>
             </el-row>
          </div>
        <div class="mini-im-session-content">
          <div class="mini-im-flex">
            <div class="mini-im-no-data" v-if="contacts.length <= 0">暂无会话数据</div>
            <ContactComponent :deleteContact="deleteContact" :clickItem="selectUser" :item="item" :class="{'mini-im-chat-item-active': seviceCurrentUser.from_account == item.from_account}" :key="index" v-for="(item, index) in contacts" />
          </div>
        </div>
      </div>
      <div class="mini-im-chat-view no-window" v-if="!$store.getters.seviceCurrentUser.id" >
        <div><i class="el-icon-service"></i></div>
        <span>当前无对话</span>
        <div class="mini-im-right-window-loading" v-show="chatWindowLoading">
          <i class="el-icon-loading"></i><span>数据加载中...</span>
        </div>
      </div>
      <div v-else class="mini-im-chat-view">
        <div class="mini-im-chat-view-content-header">
            <div class="mini-im-header-user-box">
              <el-avatar :size="35" class="mini-im-avatar">
                <img v-if="seviceCurrentUser.avatar != ''" :src="seviceCurrentUser.avatar"/>
                <template v-else>访</template>
              </el-avatar>
              <div class="mini-im-header-user-info">
                  <div>
                    {{seviceCurrentUser.nickname}}
                    <span style="color: rgb(135, 208, 104)" v-if="seviceCurrentUser.online == 1">● 在线</span>
                    <span v-else>● 离线</span>
                    <template v-if="isInputPongIng">
                      <span class="input-pong">{{inputPongIngString}} <i class="el-icon-edit"></i></span>
                    </template>
                  </div>
                  <span>用户来至：{{$getPlatformItem(seviceCurrentUser.platform).title}}客户端，所在地：{{seviceCurrentUser.address || '未知'}}</span>
              </div>
            </div>
            <el-row class="mini-im-buttons">
              <el-popover
                placement="bottom"
                width="200"
                trigger="click">
                <div class="mini-im-customer-list">
                  <div class="mini-im-customer-title">请选择转接的客服 ({{filterAdmins.length}}人在线)</div>
                  <div class="mini-im-customer-item" :key="item.id" v-for="item in filterAdmins" @click="()=>transferCustomer(item)">
                    <el-avatar :size="30" class="mini-im-avatar">
                      <img :src="item.avatar"/>
                    </el-avatar>
                    <span>{{item.nickname || item.username}}</span>
                  </div>
                  <div style="background: none;border:0;" v-if="filterAdmins.length == 0" class="mini-im-customer-item">
                    <span>当前没有其他客服在线</span>
                  </div>
                </div>
                <el-button v-show="seviceCurrentUser.is_session_end == 0 && adminInfo.online != 0" @click="getAdmins" slot="reference" icon="el-icon-refresh" size="small">
                  转接客服
                </el-button>
              </el-popover>
              <el-button v-if="seviceCurrentUser.is_session_end == 0 && adminInfo.online != 0" @click="closeSession" icon="el-icon-close" size="small">结束会话</el-button>
            </el-row>
        </div>
         <div ref="miniImChatViewBontentBody" class="mini-im-chat-view-content-body">
            <div class="mini-im-chat-view-content">
                <div v-show="advanceText.trim() != ''" class="advance">
                  <div>正在输入：</div>
                  <span>
                    {{advanceText}}
                    <template v-if="isInputPongIng">
                      <span class="input-pong">{{inputPongIngString.replace("对方正在输入", "")}} <i class="el-icon-edit"></i></span>
                    </template>
                  </span>
                  </div>
                <div ref="chatBody" id="chatBody" class="mini-im-chat-body">
                    <ChatWindowComponent :onLoadMor="onLoadMorMessage" :isMessageEnd="isMessageEnd" :onCancelMessage="onCancelMessage" :messages="messageRecord.list" :loading="getMessageRecordLoading"/>
                </div>
                <div class="mini-im-chat-input">
                    <div class="mini-im-chat-input-bar">
                      <el-row>
                        <EmojiComponent :clickEmoji="clickEmoji" />
                        <span title="选择图片" class="mini-im-button">
                          🌁
                          <input 
                            onClick="this.value = null"
                            @change="sendPhotoMessageEvent"
                            type="file"
                            accept="image/*"
                          />
                        </span>
                      </el-row>
                      <el-row>
                        <el-popover
                          placement="top-start"
                          width="350"
                          trigger="hover"
                          >
                          <div class="mini-im-shortcut">
                              <div class="mini-im-shortcut-head">
                                <span><i class="el-icon-tickets"></i>快捷语回复列表</span>
                                <div>
                                  <button  @click="createShortcutDialogFormVisible = true" title="添加"><i class="el-icon-plus"></i></button>
                                  <button  @click="shortcutEditVisible = !shortcutEditVisible" title="编辑"><i class="el-icon-edit"></i></button>
                                </div>
                              </div>
                              <div class="mini-im-shortcut-body">
                                <el-input  clearable style="margin-bottom: 10px;" v-model="shortcutKey" type="text" placeholder="请输入关键词" autocomplete="off"></el-input>
                                <div style="background: none;" class="mini-im-shortcut-item" v-if="filterShortcuts.length == 0">
                                  <span style="text-align: center;margin-top: 20px;">暂无快捷语</span>
                                </div>
                                <div :title="item.content" class="mini-im-shortcut-item" :key="item.id" v-for="item in filterShortcuts">
                                  <span @click.capture="()=>checkShortcut(item.content)" v-html='item.title.replace(/\n/g, "<br>")'></span>
                                  <button v-show="shortcutEditVisible" @click.capture="()=>editShortcut(item)" title="修改"><i class="el-icon-edit"></i></button>
                                  <button v-show="shortcutEditVisible" @click.capture="()=>deleteShortcut(item)" title="删除"><i class="el-icon-delete"></i></button>
                                </div>
                               </div>
                          </div>
                          <button class="mini-im-button" slot="reference">
                            <i style="font-size: 15px" class="el-icon-tickets"></i>
                            <span style="font-size: 14px"> 快捷语</span>
                          </button>
                        </el-popover>
                      
                      </el-row>
                    </div>
                    <div class="mini-im-chat-input-edit" @keyup.exact="keyUpEvent"  @keyup.enter.13.shift="enterShift" @keyup.enter.exact="sendMessage">
                      <el-input 
                        type="textarea" 
                        ref="chatValueDom"
                        rows="3" resize="none" 
                        :autosize="false" 
                        :disabled="seviceCurrentUser.is_session_end == 1 || adminInfo.online == 0"
                        class="mini-im-chat-text-input" 
                        maxlength="200" 
                        show-word-limit 
                        v-model="chatValue" 
                        :placeholder="seviceCurrentUser.is_session_end == 1 ? '当前会话已结束' : '请输入内容'">
                      </el-input>
                    </div>
                </div>
            </div>
            <div class="mini-im-chat-view-user">
              <el-tabs type="border-card">
                <el-tab-pane label="用户信息">
                  <UserInfoComponent />
                </el-tab-pane>
              </el-tabs>
            </div>
         </div>
      </div>
      <CreateShortcutComponent :complete="getShortcuts" :dialogFormVisible.sync="createShortcutDialogFormVisible" />
      <EditShortcutComponent :formData="editShortcutItem" :complete="getShortcuts" :dialogFormVisible.sync="editShortcutDialogFormVisible" />
    </div>
</template>

<script>
import EmojiComponent from "./emoji"
import ContactComponent from "./contact"
import UserInfoComponent from "./user_info"
import CreateShortcutComponent from "./create_shortcut"
import EditShortcutComponent from "./edit_shortcut"
import ChatWindowComponent from "./chat_window"
import upload from '../../common/upload'
import axios from "axios";
import Push from "push.js";
import { mapGetters } from 'vuex'
export default {
  name: "workbench",
  components: {
    EmojiComponent,
    ContactComponent,
    UserInfoComponent,
    ChatWindowComponent,
    CreateShortcutComponent,
    EditShortcutComponent
  },
  data(){
    return {
      chatValue: "",
      advanceText: "",
      admins: [],
      shortcuts: [],
      shortcutKey: "",
      createShortcutDialogFormVisible: false,
      editShortcutDialogFormVisible: false,
      editShortcutItem: null,
      shortcutEditVisible: false,
      getMessageRecordLoading: true,
      chatWindowLoading: false,
      currentSessionIsEnd: false,
      getMessageRecordPageSize: 20,
      isInputPongIng: false,
      isSendPong: false,
      inputPongIngString: "对方正在输入...",
      isPush: false, // 是否可以推送消息
      isMessageEnd: false,
      mousemoveTimerout: null
    }
  },
  computed: {
    filterShortcuts(){
      var shortcutKey = this.shortcutKey.trim()
      if(shortcutKey != ""){
        return this.shortcuts.filter(i => i.title.indexOf(shortcutKey) != -1)
      }else{
        return this.shortcuts
      }
    },
    filterAdmins(){
      return this.admins.filter((i) => i.id != this.adminInfo.id && (i.online == 1 || i.online == 2))
    },
    ...mapGetters([
      "contacts",
      "adminInfo",
      "seviceCurrentUser",
      "messageRecord"
    ])
  },
  mounted(){
  
    // 关闭快捷语面板
    document.ondblclick = () => {
      this.shortcutEditVisible = false
    }
    this.init()

    // 刷新鼠标动态
    document.addEventListener("mousemove", this.onMousemoveEvent, false)

     // 粘贴事件
    document.addEventListener("paste", this.inputPaste, false)

  },
  beforeDestroy(){
    document.removeEventListener("mousemove", this.onMousemoveEvent, false)
    document.removeEventListener("paste", this.inputPaste, false)
    this.changeCurrentUser();
  },
  methods: {
    // 初始化
    init(){
      if(!this.adminInfo){
        this.$store.dispatch('ON_GET_ME')
        setTimeout(() => this.init(), 100)
        return
      }
      // 获取快捷语
      this.getShortcuts()

      // 判断当前和谁聊天
      this.chatWindowLoading = true
      setTimeout(()=>{
        this.chatWindowLoading = false
      }, 1500)
      setTimeout(()=>{
        var uid = this.$store.getters.seviceCurrentUser.id || this.$route.query.uid
        this.changeCurrentUser(uid || 0)
        if(uid){
          var user
          this.contacts.map(i => {
            if(i.from_account == uid){
              user = i
            }
          })
          history.replaceState(null, null, location.href.replace(/uid=\d+/i, "uid=" + uid))
          this.$store.commit("onChangeSeviceCurrentUser", user)
          if(user) this.selectUser(user)
          // 获取聊天记录
          this.getMessageRecord()
          this.scrollIntoBottom()
        }
      }, 1000)

      // 监听登录状态
      this.$mimcInstance.addEventListener("statusChange", (status) => {
        if(this.adminInfo.online == 1){
          this.$message.success("您当前状态为在线")
        }else if(this.adminInfo.online == 2){
          this.$message.warning("您当前状态为繁忙")
        }
        if(!status){
          this.$store.dispatch('ON_GET_ME').then(()=>{
            if(this.adminInfo.online != 0){
              this.init();
            }
          })
        }
      })

      // 监听消息
      this.$mimcInstance.addEventListener("receiveP2PMsg", this.receiveP2PMsg)

      // 监听连接断开
      this.$mimcInstance.addEventListener("disconnect", () => {
        console.log("链接断开！")
        var adminInfo = this.adminInfo
        if(adminInfo.online != 0){
          this.adminInfo = null;
          this.init();
        }else{
          adminInfo.online = 0
          this.$store.commit("onChangeAdminInfo", adminInfo)
        }
      })
    },
    // 刷新鼠标动态 mousemove
    onMousemoveEvent(){
      // 以下其他浏览器的聊天高度
      if(this.$refs.miniImChatViewBontentBody){
        this.$refs.miniImChatViewBontentBody.style.height = document.body.clientHeight - 155 + "px"
      }
      this.isPush = false;
      if(this.mousemoveTimerout) clearTimeout(this.mousemoveTimerout);
      this.mousemoveTimerout = setTimeout(()=>{
        this.isPush = true;
      }, 30000)
    },
    // 快捷键换行
    enterShift(event){
      if(event.code == "Enter") return
      this.chatValue = this.chatValue + "\n"
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
    // 删除单个会话记录(聊天数据不会删除)
    deleteContact(item){
      if(!item)return
      if(!item.cid)return
      axios.delete('/contact/' + item.cid)
      .then(() => {
          this.$message.success("删除成功")
          this.$store.dispatch('ON_GET_CONTACTS')
          if(this.seviceCurrentUser.id == item.id){
            this.changeCurrentUser();
            this.$store.commit("onChangeSeviceCurrentUser", null)
          }
      })
      .catch(error => {
        this.$message.error(error.response.data.message)
      });
    },
    // 清空会话记录(聊天数据不会删除)
    clearContact(){
      this.$confirm('您确定要清空列表吗? ', '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        axios.delete('/contact/clear')
        .then(() => {
            this.$message.success("清空成功")
            this.$store.dispatch('ON_GET_CONTACTS')
            this.changeCurrentUser();
            this.$store.commit("onChangeSeviceCurrentUser", null)
        })
        .catch(error => {
          this.$message.error(error.response.data.message)
        });
      })
    },
    // emoji
    clickEmoji(emoji){
      // 当前用户是否上线
      if(this.adminInfo.online == 0){
        this.$message.info("您当前为离线状态！")
        return
      }
      if(this.seviceCurrentUser.is_session_end == 1){
        this.$message.info("当前会话已结束！")
        return
      }
      this.chatValue  = this.chatValue + emoji
      this.$refs.chatValueDom.focus()
    },
    // 选择快捷语
    checkShortcut(value){
      // 当前用户是否上线
      if(this.adminInfo.online == 0){
        this.$message.info("您当前为离线状态！")
        return
      }
      if(this.seviceCurrentUser.is_session_end == 1){
        this.$message.info("当前会话已结束！")
        return
      }
      this.shortcutKey = ""
      this.chatValue  = value
      this.$refs.chatValueDom.focus()
    },
    // 获取快捷语
    getShortcuts(){
      axios.get('/shortcut/list')
      .then((res) => {
          this.shortcuts = res.data.data
      })
      .catch((error)=>{
        this.$message.error(error.response.data.message);
      })
    },
    // 编辑快捷语
    editShortcut(item){
      this.editShortcutItem= item  
      this.editShortcutDialogFormVisible = true
    },
    // 获取在线客服
    getAdmins(){
      axios.post('/admin/list', {page_on: 1, page_size: 10000, online: 3})
      .then(response => {
          this.loading = false
          this.admins = response.data.data.list
      })
      .catch(error => {
        this.$message.error(error.response.data.message)
      });
    },
    // 删除快捷语
    deleteShortcut(item){
      this.$confirm('您确定要删除该快捷语吗?', '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        axios.delete('/shortcut/' + item.id)
        .then(() => {
            this.$message.success("删除成功")
            this.getShortcuts()
        })
        .catch(error => {
          this.$message.error(error.response.data.message)
        });
      })
    },
    // 撤回消息
    onCancelMessage(key){
      const message = this.$mimcInstance.sendMessage("cancel", this.seviceCurrentUser.from_account, key)
      this.messageRecord.list.push(message)
      this.removeMessage(this.adminInfo.id, key)
      if(this.qiniuObservable) this.qiniuObservable.unsubscribe()
    },
    // 转接客服
    transferCustomer(item){
      this.$confirm('您确定将该客户转接给 ' +(item.nickname || item.username)+' 吗?', '温馨提示！', {
        confirmButtonText: '转接',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        axios.post('/contact/transfer', {to_account: item.id, user_account: this.seviceCurrentUser.from_account})
        .then(() => {
          var seviceCurrentUser = this.seviceCurrentUser
          seviceCurrentUser.is_session_end = 1
          this.$store.commit("onChangeSeviceCurrentUser", seviceCurrentUser)
        })
        .catch(error => {
          this.$message.error(error.response.data.message)
        });
      })
      
    },
    // 结束当前会话
    closeSession(){
      this.$confirm("您确定结束当前会话吗?强制结束可能会被客户投诉！", '温馨提示！', {
        confirmButtonText: '结束',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
        const localMessage = this.$mimcInstance.sendMessage("end", this.seviceCurrentUser.from_account, "")
        this.messageRecord.list.push(localMessage)
        var seviceCurrentUser = this.seviceCurrentUser
        seviceCurrentUser.is_session_end = 1
        this.$store.commit("onChangeSeviceCurrentUser", seviceCurrentUser)
      })
    },
    // 更新用户状态
    changeUserOnlineStatus(online){
        // 更新状态
        axios.put('/admin/online/' + online)
        .then(() => {
          this.$store.dispatch('ON_GET_ME')
          if(online == 0){
             this.$message.info("当前状态为离线")
          }
        })
        .catch(error => {
            this.$message.error(error.response.data.message)
        });
    },
    // 上下线
    online(online){
      var self = this
      if(self.adminInfo.online == online) return
      self.$confirm("您确定" + (online == 0 ? "下线" : online == 1 ? "上线": "设置繁忙") +"吗！", '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() =>{
        if(online == 0){
          self.$mimcInstance.logout()
          self.changeUserOnlineStatus(online)
          self.$store.commit("onChangeMimcUser", null)
        }else{
          self.$mimcInstance.login(()=>{
            self.changeUserOnlineStatus(online)
            self.$store.dispatch('ON_RUN_LAST_ACTiIVITY')
            self.$store.dispatch('ON_GET_CONTACTS')
            self.$store.commit("onChangeMimcUser", self.$mimcInstance.user)
          })
        }
      })
    },
    // 接收消息
    receiveP2PMsg(message){
      console.log(message)
      var nowTime = parseInt((new Date().getTime() +"").substr(0, 10))
      message.timestamp = parseInt((message.timestamp +"").substr(0, 10))
       if(message.from_account == this.adminInfo.id && message.biz_type == "pong") return;
      if(message.biz_type == "into") return;
      if(message.from_account == this.adminInfo.id && this.seviceCurrentUser.from_account == message.to_account){
        this.messageRecord.list.push(message)
        if(message.biz_type == "cancel"){
          this.removeMessage(message.from_account, message.payload)
        }
        this.scrollIntoBottom()
        this.$previewRefresh()
        return;
      }
      // 文本消息
      if(message.biz_type == "text" && message.from_account == this.seviceCurrentUser.from_account){
         this.advanceText = ""
      }

      // 处理用户列表
      if(message.biz_type == "contacts"){
        var contacts = JSON.parse(message.payload)
        this.$store.commit('onChangeContacts', contacts)
        return
      }
      if(nowTime - message.timestamp >= 60) return
      // 是否是撤回消息
      if(message.biz_type == "cancel"){
        this.removeMessage(message.from_account, message.payload)
      }
       // 判断是否是握手消息
      if(message.biz_type == "handshake"){
        setTimeout(() => {
          this.$mimcInstance.sendMessage("text", message.from_account, this.adminInfo.auto_reply)
          if(this.seviceCurrentUser == undefined || this.seviceCurrentUser == null) return
          setTimeout(() => this.getMessageRecord(), 1000)
        }, 500)
        return
      }
      // 对方正在输入
      if(message.biz_type == "pong" && message.from_account == this.seviceCurrentUser.from_account){
        this.advanceText = message.payload
        this.inputPongIng()
        return
      }
      // 推送消息
      if(!(message.biz_type == "contacts" || message.biz_type == "pong" || message.biz_type == "welcome" || message.biz_type == "cancel" || message.biz_type == "handshake" || message.biz_type == "end" || message.biz_type == "timeout") && this.isPush && Push.Permission.has()){
        Push.create("收到一条新消息", {
            body: message.payload,
            icon: this.$store.state.pushIcon,
            timeout: 5000,
            onClick: () => {
              this.$router.push({ path: '/workbench?uid=' + message.from_account})
              window.focus();
              setTimeout(() => this.getMessageRecord(), 1000)
            }
        });
      }
      // 是否是否当前会话消息
      if(message.from_account != this.seviceCurrentUser.from_account) return
      if(message.biz_type == 'end'){
        var seviceCurrentUser = this.seviceCurrentUser
        seviceCurrentUser.is_session_end = 1
        this.$store.commit("onChangeSeviceCurrentUser", seviceCurrentUser)
        this.advanceText = ""
      }
      this.messageRecord.list.push(message)
      let messageRecord = JSON.stringify(this.messageRecord)
      this.$store.commit("onChangeMessageRecord", JSON.parse(messageRecord))
      this.scrollIntoBottom()
      this.$previewRefresh()

    },
    // 更新当前和谁聊天
    changeCurrentUser(uid = 0){
      if(JSON.stringify(this.adminInfo) == "{}") return;
      axios.get('/admin/current/user/' + uid)
    },
    // 发送文本消息
    sendMessage(){
      // 当前用户是否上线
      if(this.adminInfo.online == 0){
        this.$message.info("您当前为离线状态！")
        return
      }
      if(this.seviceCurrentUser.is_session_end == 1) return
      // 当前用户是否已经结束会话
      if(this.seviceCurrentUser.is_session_end == 1){
        this.$message.info("当前会话已结束！")
        return
      }
      var chatValue= this.chatValue.trim()
      if(chatValue == ""){
        this.chatValue = ""
        return
      }
      this.shortcutEditVisible = false
      this.scrollIntoBottom()
      const msg = this.$mimcInstance.sendMessage("text", this.seviceCurrentUser.from_account, this.chatValue.trim("\n"))
      msg.isShowCancel = true
      setTimeout(() => msg.isShowCancel = false, 10000)
      this.messageRecord.list.push(msg)
      this.chatValue = ""
    },
    // 发送图片消息
    sendPhotoMessageEvent(e){
      var fileDom = e.target;
      var file = fileDom.files[0]
      this.sendPhotoMessage(file)

    },
    sendPhotoMessage(file){
      // 当前用户是否上线
      if(this.adminInfo.online == 0){
        this.$message.info("您当前为离线状态！")
        return
      }
      if(this.seviceCurrentUser.is_session_end == 1){
        this.$message.info("当前会话已结束！")
        return
      }
      var imgFile = new FileReader();
      imgFile.readAsDataURL(file)
      var self = this
      var localMessage
      imgFile.onload = function(){
        localMessage = self.$mimcInstance.createLocalMessage("photo", self.seviceCurrentUser.from_account, this.result)
        localMessage["percent"] = 0
        localMessage.isShowCancel = true
        self.messageRecord.list.push(localMessage)
        setTimeout(() => localMessage.isShowCancel = false, 10000)
        self.$previewRefresh()
        self.scrollIntoBottom()

        upload({ file,
         progress: (percent) => {
           localMessage.percent = percent
         },
         success: (url) => {
            localMessage.percent = 100
            var imgUrl = self.$store.getters.uploadToken.host + "/" + url;
            self.$mimcInstance.sendMessage("photo", self.seviceCurrentUser.from_account, imgUrl)
         },
         error: (err)=>{
           localMessage.percent = 0
           self.$message.error(err.message);
         }
       });

      }
    },
    // 选择用户
    selectUser(user){
      let href = location.href
      let index = href.indexOf("#")
      href = href.substr(0, index != -1 ? index : href.length)
      history.replaceState(null, null, href + '#/workbench?uid=' + user.from_account)
      this.isMessageEnd = false
      if(this.seviceCurrentUser.from_account != user.from_account){
        this.messageRecord.list = []
        this.$store.commit("onChangeSeviceCurrentUser", user)
        this.changeCurrentUser(user.from_account)
      }
      // 获取聊天记录
      this.timestamp = undefined
      this.getMessageRecord()
      this.advanceText = ""
    },
    // 获取聊天记录
    getMessageRecord(timestamp){
      this.getMessageRecordLoading = true
      if(timestamp == undefined){
        timestamp = 0
      }
      var account = parseInt(this.seviceCurrentUser.from_account)
      if(!account) return
      axios.post('/message/list', {
        "timestamp": timestamp,
        "page_size": this.getMessageRecordPageSize,
        "account": account
      })
      .then(response => {
        this.getMessageRecordLoading = false
        if(response.data.data.list.length < this.getMessageRecordPageSize){
          this.isMessageEnd = true
        }
        if(this.messageRecord.list.length == 0 || timestamp == 0){
          this.$store.commit("onChangeMessageRecord", response.data.data)
          this.scrollIntoBottom()
        }else{
          response.data.data.list = response.data.data.list.concat(this.messageRecord.list)
          this.$store.commit("onChangeMessageRecord", response.data.data)
        }
        setTimeout(()=>this.$previewRefresh(), 1000)
        this.$store.dispatch('ON_GET_CONTACTS')
      })
      .catch(() => {
        this.getMessageRecordLoading = false
      });
    },
    //获取更多消息
    onLoadMorMessage(){
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
    // 显示正在输入
    inputPongIng(){
      if(this.isInputPongIng)return
      this.isInputPongIng = true
      setTimeout(()=>{
        this.inputPongIngString = "对方正在输入."
      }, 500)
      setTimeout(()=>{
        this.inputPongIngString = "对方正在输入.."
      }, 1500)
      setTimeout(()=>{
        this.inputPongIngString = "对方正在输入..."
        this.isInputPongIng = false
      }, 3000)
    },
    // 敲键盘发送pong事件消息
    keyUpEvent(){
      if(this.isSendPong) return
      this.isSendPong = true
      setTimeout(() => this.isSendPong = false, 500)
      this.$mimcInstance.sendMessage("pong", this.seviceCurrentUser.from_account, "")
    },
    // 删除消息
    removeMessage(accountId, key){
       var newMessages = []
        var list = this.messageRecord.list
        for(let i =0; i<list.length; i++){
          if(list[i].key == key && list[i].from_account == accountId) continue
          newMessages.push(list[i])
        }
        this.messageRecord.list = newMessages
        this.$store.commit("onChangeMessageRecord", this.messageRecord)
    },
    // 输入框粘贴事件
    inputPaste(e){
      if(!this.seviceCurrentUser.id) return
      if(this.seviceCurrentUser.is_session_end == 1) return
      let self = this
      var cbd = e.clipboardData;
      var ua = window.navigator.userAgent;
      // Safari return
      if ( !(e.clipboardData && e.clipboardData.items) ) {
          return;
      }
      // Mac平台下Chrome49版本以下 复制Finder中的文件的Bug Hack掉
      if(cbd.items && cbd.items.length === 2 && cbd.items[0].kind === "string" && cbd.items[1].kind === "file" &&
          cbd.types && cbd.types.length === 2 && cbd.types[0] === "text/plain" && cbd.types[1] === "Files" &&
          ua.match(/Macintosh/i) && Number(ua.match(/Chrome\/(\d{2})/i)[1]) < 49){
          return;
      }
      for(var i = 0; i < cbd.items.length; i++) {
          var item = cbd.items[i];
          if(item.kind == "file"){
              var file = item.getAsFile();
              if (file.size === 0) {
                  return;
              }
              var imgFile = new FileReader();
              imgFile.readAsDataURL(file);
              imgFile.onload = function () {
                var imgData = this.result;
                self.$alert(
                  '<img preview="1" style="width:100%;max-height: 500px;" src="'+imgData+'" />',
                  '检测到图片是否要发送？', {
                  dangerouslyUseHTMLString: true,
                  showCancelButton: true,
                  confirmButtonText: "发送"
                }).then(() => {
                  self.sendPhotoMessage(file)
                });
                self.$previewRefresh()
              }
          }
      }
    }
  },
  watch:{
    messageRecord(){
      this.$previewRefresh()
    }
  }
};
</script>
<style lang="stylus" scoped>
  .mini-im-workbench{
    height 100%
    display flex
    flex-direction row
    min-width: 1100px;
  }
  .mini-im-session-list{
    width 280px
    border-radius 5px
    box-sizing border-box
    display flex
    flex-direction column
    height 100%
    .mini-im-no-data{
      text-align center
      padding-top 15px
      font-size 14px
      color #666
    }
    .title{
      height 35px
      border-radius 5px 5px 0 0
      background-color #f4f5f7
      line-height 35px
      padding-left 10px
      color #666
      font-size 14px
      border 1px solid #edf1f5
      button{
        border 0
        background none
        text-align right
        span>span{
          display flex
          align-items center
          align-content center
          i{
            font-size 15px
          }
          em{
            margin-left 3px
          }
          .el-icon--right{
            font-size 12px
          }
        }
      }
    }
    .mini-im-session-content{
      flex-grow 1
      height 100%
      border 1px solid #edf1f5
      overflow hidden
      overflow-y auto
      width 278px
      background-color #fff
      border-radius 0 0 5px 5px
    }
  
  }
  .mini-im-chat-view{
    flex-grow 1
    border 1px solid #edf1f5
    margin-left 20px
    border-radius 3px
    overflow hidden
    display flex
    flex-direction column
    .mini-im-chat-view-content-header{
      width 100%
      flex-shrink 0
      height 55px
      border-bottom 1px solid #edf1f5
      display flex
      justify-content space-between
      background-color #f4f5f7
      align-items center
      padding 0 10px
      box-sizing border-box
      .mini-im-header-user-box{
        display flex
        flex-direction row
        align-items center
        .mini-im-header-user-info{
          padding-left 10px
          font-size 14px
          display flex
          flex-direction column
          justify-content space-around
          .input-pong{
            margin-left 10px
            font-size 12px
          }
          div{
            font-weight 600
            color #666
            span{
              font-size 10px
            }
          }
          span{
            color #999
            font-size 12px
          }
        }

      }
      .mini-im-buttons{
        width: 230px;
        display: flex;
        justify-content: space-around;
      }
    }
    .mini-im-chat-view-content-body{
      display flex
      flex-direction row
      flex-grow 1
      overflow hidden
      background-color #fff
      .mini-im-chat-view-content{
        flex-grow 1
        height 100%
        display flex
        flex-direction column
        .mini-im-chat-body{
          background-color #fff
          flex-grow 1
          padding 10px
          padding-bottom 20px
          overflow: hidden;
          overflow-y: auto;
          min-width: 400px;
        }
        .mini-im-chat-input{
          height 115px
          border-top 1px solid  #edf1f5
          position relative
          flex-grow 0
          background-color #fff
          flex-shrink 0
          .mini-im-chat-input-bar{
            height 30px
            display flex
            justify-content space-between
            padding 0 15px
            box-sizing border-box
            .mini-im-button{
              height 30px
              padding  0 5px
              border 0
              font-size 18px
              cursor pointer
              background-color  #fff
              color #666
              position relative
              overflow hidden
              input{
                position absolute
                top 0
                cursor pointer
                left 0
                width 100%
                opacity 0
                height 100%
                font-size 100px
              }
              i{
                color #666
              }
            }
          }
          .mini-im-chat-input-edit{
              height 100%
              .mini-im-chat-text-input{
                width 100%
                border: 0px solid #DCDFE6;
                resize none 
                font-size 14px
                color #666
                box-sizing border-box
                padding 5px;
              }
          }
        }
      }
      .mini-im-chat-view-user{
        width 350px
        height 100%
        border-left 1px solid  #edf1f5
        box-sizing border-box
        background-color #fff
        flex-shrink 0
        flex-grow 0
        .el-tabs--border-card{
          height 100%
          border 0
          box-shadow none
        }
      }
    }
    .mini-im-chat-view-content{
      position relative
      .advance{
        position absolute
        box-sizing: border-box;
        width 100%
        left 0
        bottom 115px
        font-size: 14px;
        color: #999;
        display flex
        padding 5px 3px
        background-color: #f5f7fa;
        border-top 1px solid #f3f3f3
        div{
          width 70px
          flex-shrink: 0;
        }
        span{
          font-size 12px
        }
      }
    }
  }
  .no-window{
    display flex
    background-color #fff
    text-align center
    flex-direction column
    align-items center
    justify-content center
    position relative
    i{
      font-size 130px
      color #999
    }
    span{
      color #999
      font-size 20px
      margin-top 10px
    }
    .mini-im-right-window-loading{
        width 100%
        height 100%
        background-color #fff
        display flex
        align-items center
        justify-content center
        position absolute
        left 0
        top 0
        i{
          font-size 25px
        }
        span{
          margin-left 5px
          font-size 15px
          margin-top 0
        }
    }
  }
  .mini-im-user-info{
    width 300px
  }
  .mini-im-online-setting{
    font-size 14px
    color #666
    .item{
      padding 5px
      cursor pointer
      border-radius 3px
      &:hover{
        background  #f2f2f2
      }
    }
  }

  .mini-im-shortcut{
    display flex
    height 500px
    flex-direction column
    .mini-im-shortcut-head{
      height 30px
      width 100%
      display flex
      border-bottom 1px solid #f4f5f7
      justify-content space-between
      align-items center
      padding-bottom 5px
      button{
        width 25px
        height  25px
        flex-grow 0
        flex-shrink 0
        border  0
        i{
          font-size 15px
          color #999
          cursor pointer
        }
      }
    }
    .mini-im-shortcut-body{
      flex-grow 1
      display block
      width 100%
      overflow hidden
      overflow-y auto
    }
  
    .mini-im-shortcut-item{
      display flex
      width 100%
      min-height 30px
      padding 5px
      box-sizing border-box
      cursor pointer
      font-size 13px
      span{
        flex-grow 1
        padding-right 10px
      }
      button{
        width 15px
        height  30px
        flex-grow 0
        flex-shrink 0
        margin-right: 5px;
        border  0
        background none
        i{
          font-size 15px
          color #999
          cursor pointer
        }
      }
      &:hover{
        opacity .9
        background  #f2f2f2
        border-radius 3px
      }
    }

  }
  .mini-im-customer-list{
    overflow hidden
    min-height 150px
    max-height 500px
    overflow-y auto
    .mini-im-customer-title{
      padding-bottom 10px
      border-bottom 1px solid #f2f2f2
    }
    .mini-im-customer-item{
        display flex
        cursor pointer
        align-items center
        padding 5px
        border-bottom 1px solid #f7f5f5
        border-radius 3px
        &:hover{
          background  #f2f2f2
        }
        span{
          margin-left 10px
        }
    }
  }
  .mini-im-avatar{
    flex-grow 0
    flex-shrink 0
  }
</style>
