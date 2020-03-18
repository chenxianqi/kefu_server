<template>
  <div class="mini-im-container" :class="{'mini-im-pc-container': !isMobile, 'mini-im-container-no-pto': !isShowHeader}">
      <span class="input-ing" v-show="isMobile && (isInputPongIng && !isShowHeader)">{{inputPongIngString}}</span>
      <mt-header v-if="isShowHeader" fixed :title="isInputPongIng ? inputPongIngString : '在线客服'">
        <div slot="left">
          <mt-button @click="back" icon="back"></mt-button>
        </div>
        <mt-button @click="headRightBtn" slot="right">
          <img title="人工客服" v-if="!isArtificial" src="http://qiniu.cmp520.com/kefu_icon_2000.png" alt="">
          <span v-else>结束会话</span>
        </mt-button>
      </mt-header>
      <div v-if="!isMobile" class="mini-im-pc-header">
          <div class="title">
            <img src="http://qiniu.cmp520.com/kefu_icon_2000.png" alt="">
            <span>在线客服</span>
          </div>
          <span v-show="isInputPongIng">{{inputPongIngString}}</span>
          <div class="right">
            <img title="人工客服" @click="headRightBtn" v-if="!isArtificial" src="http://qiniu.cmp520.com/kefu_icon_2000.png" alt="">
            <span v-if="isArtificial" @click="headRightBtn">结束会话</span>
            <div @click="clickCloseWindow" class="close-btn">ㄨ</div>
          </div>
      </div>
      <div class="mini-im-body" ref="miniImBody">
        <ul class="mini-im-chat-list">
          <li class="message-loading" v-if="isLoadMorLoading">
            <mt-spinner color="#26a2ff" :size="20" type="triple-bounce"></mt-spinner>
          </li>
          <li :key="index" v-for="(item,index) in viewMessage">

            <template v-if="item.isShowDate">
              <!-- 日期 -->
              <div class="mini-im-chat-item">
                <div class="chat-content">
                  <div class="chat-body">
                    <template>
                      <div class="system">
                        <div class="content">
                          <span>{{$formatFromNowDate(item.timestamp, "YYYY年MM月DD日 HH:mm")}}</span>
                        </div>
                      </div>
                    </template>
                  </div>
                </div>
              </div>
           </template>

          
           <div class="mini-im-chat-item" :class="{'self': item.from_account == userInfo.id}">

              <!-- 头像 -->
              <div class="chat-avatar" v-if="isShowInfo(item.biz_type)">
                <img :src="item.avatar" >
              </div>

              <!-- 消息主体 -->
              <div class="chat-content">

                <div class="chat-body">

                  <!-- 撤回按钮 -->
                  <template v-if="item.isShowCancel">
                    <span @click="()=>cancelMessage(item.key)" v-if="item.from_account == userInfo.id && isShowInfo(item.biz_type)" class="cancel-btn">撤回</span>
                  </template>

                  <!-- 文本消息 -->
                  <template v-if="item.biz_type == 'text' || item.biz_type == 'welcome'">
                    <div class="text">
                      <span v-html="item.payload.replace(/\n/ig, '<br />')"></span>
                    </div>
                  </template>

                  <!-- 图片消息 -->
                  <template v-if="item.biz_type == 'photo'">
                    <div class="photo">
                      <span v-if="item.percent && item.percent != 100">上传中{{item.percent}}%</span>
                      <img v-if="isMobile" :src="item.payload" preview="1" />
                      <img v-else @click="clickPhoto(item.payload)" :src="item.payload" />
                    </div>
                  </template>

                  <!-- 知识消息 -->
                  <template v-if="item.biz_type == 'knowledge'">
                    <div class="knowledge">
                      <div class="title">以下是您关心的相关问题?</div>
                      <a @click="()=>sendKnowledgeMessage(item.title)" href="javascript:void(0);" :key="index" v-for="(item, index) in JSON.parse(item.payload)">
                        <span>• {{item.title}}</span>
                      </a>
                      <a @click="headRightBtn">• 以上都不是?我要找人工</a>
                    </div>
                  </template>


                  <!-- 会话结束 -->
                  <template v-if="item.biz_type == 'end'">
                    <div class="system">
                      <div class="content">
                        <span>本次会话结束，感谢您的支持！</span>
                      </div>
                    </div>
                  </template>

                  <!-- 会话超时-->
                  <template v-if="item.biz_type == 'timeout'">
                    <div class="system">
                      <div class="content">
                        <span>{{item.payload}}</span>
                      </div>
                    </div>
                  </template>

                  <!-- 系统消息-->
                  <template v-if="item.biz_type == 'system'">
                    <div class="system">
                      <div class="content">
                        <span v-html="item.payload"></span>
                      </div>
                    </div>
                  </template>
                  

                  <!-- 撤回消息 -->
                  <template v-if="item.biz_type == 'cancel'">
                    <div class="system">
                      <div class="content">
                        <span v-if="item.from_account == userInfo.id">您撤回了一条消息</span>
                        <span v-else>对方撤回了一条消息</span>
                      </div>
                    </div>
                  </template>

                  <!-- 客服转接 -->
                  <template v-if="item.biz_type == 'transfer'">
                    <div class="system">
                      <div class="content">
                        <span>已为您转接{{item.transfer_account}}号客服</span>
                      </div>
                    </div>
                  </template>
                  

                </div>
              </div>

           </div>

          </li>


        </ul>
        <div class="no-network" v-if="isNotNetWork"> 
            <img src="./assets/network.png" alt="">
            <span>网络连接已断开，请重新加载尝试~</span>
            <button @click="resetLoad">重新加载</button>
        </div>
      </div>
     
      <div class="mini-im-loading" v-if="isLoading">
        <mt-spinner type="triple-bounce" color="#26a2ff"></mt-spinner>
      </div>
      <div class="mini-im-emoji" v-show="showEmoji">
        <div class="mini-im-emoji-content">
          <span @click="()=>clickEmoji(item)" v-for="(item, index) in emojis" :key="index">{{item}}</span>
        </div>
      </div>
      <div class="mini-im-knowledge" v-show="handshakeKeywordList.length > 0">
        <div class="mask" @click="handshakeKeywordList = []"></div>
        <span>以下是您关心的相关问题?</span>
        <ul>
          <li :data="item.title" class="sendKnowledgeMessage" @click="!isIOS && sendKnowledgeMessage(item.title)" v-for="(item, index) in handshakeKeywordList" :key="index">• {{item.title}}</li>
        </ul>
      </div>
      <div class="mini-im-tabbar-input">
        
        <span class="photo-btn">
          <img src="./assets/photo_btn.png" alt="">
          <input onClick="this.value = null" @change="sendPhotoMessageEvent" type="file" accept="image/*" />
        </span>
        <span class="expression-btn" @click="showEmoji = !showEmoji">
          <img src="./assets/expression.png" alt="">
        </span>
        <span v-show="isMobile && !isShowHeader" @click="headRightBtn" class="serverci" :class="{'on': !isArtificial}">
          <img title="人工客服" v-if="!isArtificial" src="http://qiniu.cmp520.com/bfbfbf.png" alt="">
          <span v-else>结束会话</span>
        </span>
         <textarea
          ref="textarea"
          maxlength="200"
          @keyup.exact="keyUpEvent"
          @keyup.enter.13.shift="enterShift"
          @keyup.enter.exact="enterSendMessage"
          @submit="sendTextMessage"
          @focus="chatInputFocus"
          @blur="chatInputBlur"
          placeholder="请用一句话描述您的问题~"
          v-model="chatValue"
          style="vertical-align:top;outline:none;"
        ></textarea>
        <button ref="sendButton" type="button"  class="mini-input-send">发送</button>
      </div>
  </div>
</template>

<script>
import axios from 'axios'
import { Toast,MessageBox } from 'mint-ui';
import * as qiniu from 'qiniu-js'
var emojiService = require("../resource/emoji")
import BScroll from 'better-scroll'
export default {
  name: 'app',
  data(){
    return {
      messages: [],
      isLoading: true,
      isNotNetWork: false,
      userLocal: "",           // 用户地理位置
      isFirstGetMessage: true, // 第一次获取本地消息
      platform: 5,             // 平台（渠道）
      uid: null,               // 业务平台的ID
      chatValue: "",           // 发送消息的内容
      emojis: emojiService.emojiData, // emoji数据
      showEmoji: false,        // 是否显示emoji面板
      userInfo: {},            // 用户信息
      userAccount: null,       // 用户账号
      companyInfo: null,       // 公司信息
      uploadToken: null,       // 上传token 
      isArtificial: false,     // 是否是人工服务
      artificialAccount: null, // 客服账号ID
      robotInfo: null,         // 机器人信息
      robotAccount: null,      // 机器人账号ID
      isLoadMorEnd: false,
      isUserSendLongTimeSystemMessage: false, // 本次用户会话超时了是否发送了结束前提示语
      isAdminSendLongTimeSystemMessage: false, // 本次客服会话超时了是否发送了结束前提示语
      isInputPongIng: false,
      isLoadMorLoading: false,
      isSendPong: false,
      qiniuObservable: null,
      inputPongIngString: "对方正在输入...",
      scroll: null,        // 滚动控制器
      isShowHeader: true, // 是否显示header
      isMobile: true,       // 是否是移动端
      handshakeKeywordList: [], // 检索关键词
      searchHandshakeTimer: null
    }
  },
  created(){
    // run
    this.getLocal()
    this.run()
  },
  computed: {
    account(){
      return this.isArtificial ? this.artificialAccount : this.robotAccount
    },
    isIOS(){
      return !!navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)
    },
    isSafari(){
      return navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") < 1
    },
    isJudgeBigScreen(){
      return this.$judgeBigScreen();
    },
    viewMessage(){
      var messages = this.messages
      for(let i = 0; i< messages.length; i++){
        if(i == 0) messages[i].isShowDate = true
        if(i < messages.length-1){
          messages[i+1].isShowDate = false
          if(messages[i+1].timestamp-120 > messages[i].timestamp) messages[i+1].isShowDate = true
        }
        
      }
      return messages
    }
  },
  mounted(){

    // url query 介绍
    // h == header  0 不显示 1显示 默认值显示，PC端不显示
    // m == mobile  0 不是移动端 1是移动端
    // p == platform  平台ID（渠道）
    // r == robot   0 当前为为客服 1机器人（对应的账号为a）
    // a == account 当前提供对话服务的账号，即客服账号，或机器人
    // u == userAccount  会话用户账号
    // uid == userId  业务平台的ID
    // c = 1          清除本地缓存
    var query = this.queryToJson(location.search)
    if(query && query.c) localStorage.clear()
    // 获取本地缓存
    var urlQuery = this.queryToJson(localStorage.getItem("urlQuery"))
    if(urlQuery){
      query = Object.assign({}, urlQuery, query)
      query.u = urlQuery.u
    }
    if(query){
      if(query.h == "0") this.isShowHeader = false
      if(query.m == "0"){
        this.isMobile = false
        this.isShowHeader = false
      }
      if(query.u) this.userAccount = parseInt(query.u)
      if(query.p) this.platform = parseInt(query.p)
      if(query.uid) this.uid = parseInt(query.uid)
      if(query.r == "0"){
        this.isArtificial = true
        this.artificialAccount = parseInt(query.a)
      }else{
        this.robotAccount = parseInt(query.a)
      }
      
    }
    var isArtificial = localStorage.getItem("isArtificial_" + this.userAccount)
    var artificialAccount = localStorage.getItem("artificialAccount_" + this.userAccount)
    if(isArtificial == "true"){
      this.isArtificial = true
      this.artificialAccount = parseInt(artificialAccount)
    }
    
    setTimeout(() =>{
       this.isLoading = false
       this.scroll = new BScroll(this.$refs.miniImBody, {
         click: true,
         tab: true,
         scrollY: true,
         scrollbar: true,
         bounceTime: 400,
         preventDefaultException: {className:/(^|\s)text(\s|$)/},
         mouseWheel: true
       })
       this.scroll.on('touchEnd', (pos) => {
        if (pos.y > 30) {
          this.loadMorData()
        }
      })
      // 监听发送按钮触摸事件
      this.addSendButtonTouchEventListener()
      this.createLinkQuery()
      this.scrollIntoBottom()
    }, 500)

    // 判断是否被踢出对话
    this.onCheckIsOutSession()

     // 粘贴事件
    document.addEventListener("paste", this.inputPaste, false)

  },
  beforeDestroy(){
   this.toggleWindow(0)
  },
  methods: {
    // run
    run(){

      // 发起请求
      this.getAllhttp()

      // 上报活动时间
      this.upLastActivity()

      // 监听消息
      this.$mimcInstance.addEventListener("receiveP2PMsg", this.receiveP2PMsg)

      // 监听连接断开
      this.$mimcInstance.addEventListener("disconnect", () => {
        /* eslint-disable */
        console.log("链接断开！")
        this.isNotNetWork = true;
      })

      // 状态发生变化
      this.$mimcInstance.addEventListener("statusChange", (bindResult, errType, errReason, errDesc) => {
        console.log("状态发生变化", bindResult, errType, errReason, errDesc)
      })

      // 发送消息服务器ack
      this.$mimcInstance.addEventListener("serverAck", (packetId, sequence, timeStamp, errMsg) => {
        console.log("发送消息服务器ack", packetId, sequence, timeStamp, errMsg)
        localStorage.setItem("userLastCallBackMessageTime_" + this.userAccount, Date.now())
        this.isUserSendLongTimeSystemMessage = false
      })

      // 计算用户是否长时间未回复弹出给出提示
      this.onCheckIsloogTimeNotCallBack()

    },
    // 根据IP获取用户地理位置
    getLocal(){
      var APPKey = "" // 高德地图web应用key
      axios.get("https://restapi.amap.com/v3/ip?key=" + APPKey)
      .then(response => {
            if(response.data.province){
              console.log(response.data.province + response.data.city)
               this.userLocal = response.data.province + response.data.city
            }
        }).catch((error)=>{
          console.error(error)
      })
    },
    // 初始化IM
    initMimc(){
      const IM = this.$mimcInstance
      const user = IM.getLocalCacheUser(this.userAccount)
      this.userInfo = user
      let userAccount = this.userAccount ? this.userAccount : user ? user.id : 0
      IM.init({
        type: 0,  // 默认0
        address:  this.userLocal,
        uid: this.uid,   // 预留字段扩展自己平台业务
        platform: this.platform, // 渠道（平台）
        account_id: userAccount // 用户ID

        // 初始化完成这里返回一个user
      }, (user) => {
        if(!user){
          setTimeout(()=> this.initMimc(), 1000)
        }else{
          this.userInfo = user
          this.userAccount = user.id
          // 清除未读消息
          this.cleanRead(user.id)
          // 更换toggle
          this.toggleWindow(1)
          // 登录完成发送一条握手消息给机器人
          IM.login(() => {
            setTimeout(()=> {
              // 获取消息记录
              this.getMessageRecord() 
              if(!this.artificialAccount){
                console.log("握手消息")
                IM.sendMessage("handshake", this.robotAccount, "")
              }
              this.scrollIntoBottom()
            }, 500)
          })
        }
      })

      // 计算客服最后回复时间
      this.onServciceLastMessageTimeNotCallBack()
    },
    // 刷新页面
    resetLoad(){
      window.location.reload()
    },
    // 快捷键换行
    enterShift(event){
      if(this.isMobile) return
      if(event.code == "Enter") return
      this.chatValue = this.chatValue + "\n"
    },
    // 监听发送按钮触摸事件
    addSendButtonTouchEventListener(){
      var self = this
      if(this.isIOS){
          document.addEventListener('touchstart', function(e) {
              if(e.target.getAttribute("class") == "mini-input-send"){
                self.sendTextMessage()
              }
              if(e.target.getAttribute("class") == "sendKnowledgeMessage"){
                console.log("监听发送按钮触摸事件", e.target.getAttribute("data"))
                self.sendKnowledgeMessage(e.target.getAttribute("data"))
              }
          }, false);
      }else{
        this.$refs.sendButton.addEventListener('click', this.sendTextMessage, false);
      }
    
    },
    // 清除未读消息
    cleanRead(id){
      axios.get('/public/clean_read/' + id)
    },
    //  用户是否在当前聊天页面
    toggleWindow(window){
      axios.put('/public/window/',{window: window})
    },
    // query 转json
    queryToJson(str){
      if(!str || str == '') return null
      var query = str.substr(1, str.length).split("&")
      if(!query) return null
      var mapData = {}
      for(let i= 0; i<query.length; i++){
         var temArr =  query[i].split("=")
         mapData[temArr[0]] = temArr[1]
      }
      return mapData
      
    },
    // 返回上一页按钮
    back(){
      history.go(-1)
    },
    // 是否显示用户头像信息（系统消息隐藏）
    isShowInfo(biz_type){
     return ['end', 'transfer', 'cancel', 'timeout', "system"].indexOf(biz_type) == -1
    },
    // 点击图片
    clickPhoto(url){
      if(url.indexOf("http") == -1){
        let img = new Image();
        img.src = url;
        const newWin = window.open("", "_blank");
        newWin.document.write(img.outerHTML);
        newWin.document.title = "图片"
        newWin.document.close();
      }else{
        window.open(url);
      }
    },
    // 上报最后活动时间
    upLastActivity(){
      this.onCheckIsOutSession()
      const user = this.$mimcInstance.getLocalCacheUser(this.userAccount)
      if(user) axios.get('/public/activity/' + user.id)
      if(this.isArtificial){
        localStorage.setItem("artificialTime_" + this.userAccount,Date.now())
      }
      setTimeout(() => this.upLastActivity(), 1000*60)
    },
    // 判断是否被踢出对话
    onCheckIsOutSession(){
      var artificialTime = localStorage.getItem("artificialTime_" + this.userAccount)
      if(artificialTime){
        artificialTime = parseInt(artificialTime)
        if(Date.now() > artificialTime + 60*1000 * 10){
          this.isArtificial = false
          this.artificialAccount = null
        }
      }
    },
    // 获取本地更多数据
    loadMorData(){
      if(this.isLoadMorLoading) return
      if(this.isLoadMorEnd) return
      this.isLoadMorLoading = true
      setTimeout(()=> {
        // 获取消息记录
        this.getMessageRecord()
        this.isLoadMorLoading = false
      }, 1000)
    },
    // 获取本地缓存的客服信息
    localAdmin(id){
      var adminString = localStorage.getItem("admin_" + id)
      if(!adminString) return null
      return JSON.parse(adminString)
    },
    // 获取本地缓存的robot
    localRobot(id){
      var adminString = localStorage.getItem("robot_" + id)
      if(!adminString) return null
      return JSON.parse(adminString)
    },
    // emoji
    clickEmoji(emoji){
      this.showEmoji = false
      this.chatValue  = this.chatValue + emoji 
      this.scrollIntoBottom()
    },
    // 发送图片消息
    sendPhotoMessageEvent(e){
      var fileDom = e.target;
      var file = fileDom.files[0]
      this.sendPhotoMessage(file)

    },
    sendPhotoMessage(file) {
      var imgFile = new FileReader();
      imgFile.readAsDataURL(file)
      var self = this
      var localMessage
      const fileName = parseInt(Math.random() * 10000 * new Date().getTime()) + file.name.substr(file.name.lastIndexOf('.'))
      imgFile.onload = function(){

        // 上传失败
        let uploadError = function(){
          localMessage.percent = 0
          self.qiniuObservable= null
          self.removeMessage(self.userInfo.id, localMessage.key)
          Toast({
            message: "上传失败，请重新上传！"
          })
          const IM = self.$mimcInstance
          var message = IM.createLocalMessage("system", self.account, "您刚刚上传的图片失败了，请重新上传！")
          self.messages.push(self.handlerMessage(message))
          self.scrollIntoBottom()
        }

        // 上传成功
        let uploadSuccess = function(url){
          self.qiniuObservable= null
          localMessage.percent = 100
          var imgUrl = self.uploadToken.host + "/" + url
          self.$mimcInstance.sendMessage("photo", self.account, imgUrl)
        }

        // 创建本地消息
        localMessage = self.$mimcInstance.createLocalMessage("photo", self.account, this.result)
        localMessage["percent"] = 0
        localMessage.isShowCancel = true
        setTimeout(() => {
          localMessage.isShowCancel = false
        }, 10000)
        self.messages.push(self.handlerMessage(localMessage))
        var cacheMsg = Object.assign({}, localMessage)
        cacheMsg.payload = self.uploadToken.host + "/" + fileName
        self.$previewRefresh()
        self.scrollIntoBottom()


        // 系统内置
        if(self.uploadToken.mode == 1) {
          let fd = new FormData();
          fd.append('file',file);
          fd.append('file_name', fileName);
          axios.post('/public/upload', fd)
          .then((res) => {
              uploadSuccess(res.data.data)
          })
          .catch(()=>{
            uploadError()
          })
        }
        // 七牛云
        else if(self.uploadToken.mode == 2){
          let options = {
            quality: 0.92,
            noCompressIfLarger: true,
            maxWidth: 1500,
          }
          qiniu.compressImage(file, options).then(data => {
            const observable = qiniu.upload(data.dist, fileName, self.uploadToken.secret, {}, {
               mimeType: null
            })
            self.qiniuObservable = observable.subscribe({
              next: function(res){
                localMessage.percent = Math.ceil(res.total.percent);
                if(res.total.size < 1){
                  self.qiniuObservable.unsubscribe()
                  self.cancelMessage(localMessage.key);
                  Toast({
                    message: "上传失败，该图片已损坏！"
                  })
                }
              },
              error: function(){

                // 失败后再次使用FormData上传
                var formData = new FormData()
                formData.append("fileType", "image")
                formData.append("fileName", "file")
                formData.append("key", fileName)
                formData.append("token", self.uploadToken.secret)
                formData.append("file", file)
                axios.post("https://upload.qiniup.com", formData)
                .then(()=>{
                   uploadSuccess(fileName)
                }).catch(()=>{
                  uploadError()
                })

              },
              complete: function(res){
                uploadSuccess(res.key)
              }
            })
          })
        }


      }
    },
    // 滚动条置底
    scrollIntoBottom(){
      setTimeout(()=>{
        var lis = this.$refs.miniImBody.querySelectorAll("li")
        this.scroll && this.scroll.scrollToElement(lis[lis.length-1])
      }, 50)
    },
    // input获得焦点
    chatInputFocus(){
      this.scrollIntoBottom()
      this.showEmoji = false
    },
    // input 失去焦点
    chatInputBlur(){
      window.chatInputInterval = null
      window.scroll(0, 0)
    },
    // 获取机器人
    getRobot(){
      return axios.get('/public/robot/1')
      .then((response)=>{
        var robot = response.data.data
        localStorage.setItem("robot_" + robot.id, JSON.stringify(robot))
        this.robotAccount = robot.id
        this.robotInfo = robot
      }).catch((error)=>{
        Toast({
          message: error.response.data.message
        })
      })
    },
    // 获取上传配置
    getUploadSecret(){
      return axios.get('/public/secret')
      .then(response => {
          this.uploadToken = response.data.data
      })
    },
    // 获取公司信息
    getCompanyInfo(){
      return axios.get('/public/company')
        .then(response => {
            this.companyInfo = response.data.data
        }).catch((error)=>{
          Toast({
            message: error.response.data.message
          })
      })
    },
    // 发起并发请求
    getAllhttp(){
      axios.all([this.getRobot(), this.getCompanyInfo(), this.getUploadSecret()])
      .then(axios.spread(() => {
        // 初始化MIMC
        this.initMimc()
      })).catch(()=> setTimeout(() => this.getAllhttp(), 1000));
    },
    // 接收消息
    receiveP2PMsg(message){
      console.log(message)
      // 是否是转接客服消息
      if(message.biz_type == "transfer"){
        this.isArtificial = true
        this.artificialAccount = message.transfer_account
        var admin = JSON.parse(message.payload)
        localStorage.setItem("admin_" + admin.id, JSON.stringify(admin))
        localStorage.setItem("adminLastCallBackMessageTime_" + admin.id, Date.now())
        this.isAdminSendLongTimeSystemMessage = false
      }
      // 计算客服最后回复时间
      if(this.isArtificial && (message.biz_type == "text" || message.biz_type == "photo" || message.biz_type == 'cancel')){
        localStorage.setItem("adminLastCallBackMessageTime_" + this.account, Date.now())
        this.isAdminSendLongTimeSystemMessage = false
      }
      // 是否是撤回消息
      if(message.biz_type == "cancel"){
        this.removeMessage(message.from_account, message.payload)
      }
      // 是否是结束或超时消息
      if(message.biz_type == "end" || message.biz_type == "timeout"){
        this.isArtificial = false
        this.artificialAccount = null
      }
       
      // 对方正在输入
      if(message.biz_type == "pong"){
        this.inputPongIng()
        return
      }

      // 检索关键词知识库消息
      if(message.biz_type == "search_knowledge"){
        this.handshakeKeywordList = []
        if(message.payload!=""){
          this.handshakeKeywordList = JSON.parse(message.payload)
        }
        return
      }

      this.messagesPushMemory(message)
      this.scrollIntoBottom()
      this.$previewRefresh()
      window.parent.postMessage({newMessage: 1},'*')
      
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
    // enterSendMessage
    enterSendMessage(){
      if(this.isMobile) return
      this.sendTextMessage()
      this.$refs.textarea.focus()
    },
    // 发送文本消息
    sendTextMessage(){
      // 当前用户是否上线
      if(this.userInfo.online == 0){
        Toast({
          message: "您貌似掉线了"
        })
        return
      }
      var chatValue = this.chatValue.trim()
      if(chatValue == "") return
      const IM = this.$mimcInstance
      const message = IM.sendMessage("text", this.account, chatValue)
      message.isShowCancel = true
      setTimeout(() => message.isShowCancel = false, 10000)
      this.messagesPushMemory(message)
      this.chatValue = ""
      this.handshakeKeywordList = []
    },
    // 撤回消息
    cancelMessage(key){
      const IM = this.$mimcInstance
      const message = IM.sendMessage("cancel", this.account, key)
      this.messagesPushMemory(message)
      this.removeMessage(this.userInfo.id, key)
      if(this.qiniuObservable) this.qiniuObservable.unsubscribe()
    },
    // 点击知识库消息
    sendKnowledgeMessage(content){
      this.handshakeKeywordList = []
      const IM = this.$mimcInstance
      const message = IM.sendMessage("text", this.account, content)
      this.messagesPushMemory(message)
      this.chatValue = ""
    },
    // 点击head右边按钮
    headRightBtn(){
      if(window.isClickHeadRightBtn) return;
      window.isClickHeadRightBtn = true
      const IM = this.$mimcInstance
      if(this.isArtificial){
        MessageBox.confirm('您确定关闭此次会话吗?', "温馨提示! ")
        .then(() => {
          const message = IM.sendMessage("end", this.account, "")
          this.messagesPushMemory(message)
          this.isArtificial = false
          this.artificialAccount = null
        })
        setTimeout( () => window.isClickHeadRightBtn = false, 3000)
        return
      }
      const message = IM.sendMessage("text", this.account, "人工")
      this.messagesPushMemory(message)
      setTimeout( () => window.isClickHeadRightBtn = false, 3000)

    },
    // 消息处理Memory storage
    messagesPushMemory(msg){
      if(msg.biz_type == 'pong' || msg.biz_type == "handshake" || msg.biz_type == "into") return;
      this.messages.push(this.handlerMessage(msg))
      this.scrollIntoBottom()
    },
    // 处理头像昵称
    handlerMessage(msg){
      const defaultAvatar = "http://qiniu.cmp520.com/avatar_degault_3.png"
      var admin = this.localAdmin(msg.from_account)
      var robot = this.localRobot(msg.from_account)
      if(admin && msg.from_account == admin.id){
        msg.nickname = admin.nickname
        msg.avatar = admin.avatar == "" ? defaultAvatar : admin.avatar
      }else if(robot && msg.from_account == robot.id){
        msg.nickname = robot.nickname
        msg.avatar = robot.avatar == "" ? defaultAvatar : robot.avatar
      }else if(msg.from_account == this.userInfo.id){
          msg.nickname = this.userInfo.nickname
          if(this.userInfo.nickname.indexOf(this.userInfo.id) != -1) msg.nickname = "我"
          msg.avatar =this.userInfo.avatar == "" ? defaultAvatar : this.userInfo.avatar
      }
      return msg
    },
    // 获取服务器消息列表
    getMessageRecord(){
      const pageSize = 20
      let uid = this.userInfo.id
      let timestamp = this.messages.length == 0 ? parseInt((new Date().getTime() + " ").substr(0, 10)) : this.messages[0].timestamp
      axios.post('/public/messages',{
          "timestamp": timestamp,
          "page_size": pageSize,
          "account": uid
        })
        .then(response => {
          let messages = response.data.data.list || []
          if(messages.length < pageSize) this.isLoadMorEnd = true;
          if(this.messages.length == 0 && messages.length > 0){
            this.messages = response.data.data.list.map((i) => this.handlerMessage(i))
            this.scrollIntoBottom()
          }else if(messages.length > 0){
            messages = messages.map((i) => this.handlerMessage(i))
            this.messages = messages.concat(this.messages)
          }
        }).catch((error)=>{
          console.log(error)
      })
      
    },
    // 敲键盘发送pong事件消息
    keyUpEvent(){
      if(!this.isArtificial) return
      if(this.isSendPong) return
      this.isSendPong = true
      setTimeout(() => this.isSendPong = false, 100)
      this.$mimcInstance.sendMessage("pong", this.account, this.chatValue)
    },
    // 删除本地消息
    removeMessage(accountId, key){
       var newMessages = []
        for(let i =0; i<this.messages.length; i++){
          if(this.messages[i].key == key && this.messages[i].from_account == accountId) continue
          newMessages.push(this.messages[i])
        }
        this.messages = newMessages
    },
    // 生成query
    createLinkQuery(){
      let r = this.isArtificial ? 0 : 1
      let a = r == 0 ? this.artificialAccount : this.robotAccount
      let m = this.isMobile ? 1 : 0
      let h = this.isShowHeader ? 1 : 0
      let p = this.platform ? this.platform : 1
      let u = this.userAccount ? "&u=" + this.userAccount : ''
      let uid = this.uid ? "&uid=" + this.uid : ''
      let query = "?h=" + h + "&m=" + m + "&p=" + p + "&r=" + r + "&a=" + a + u + uid
      history.replaceState(null, null, query)
      if(this.userAccount != null && this.userAccount != 'null' && this.userAccount != ""){
        localStorage.setItem("urlQuery", query)
      }
    },
    // 关闭窗口
    clickCloseWindow(){
      window.parent.postMessage({clickCloseWindow: true},'*')
    },
    // 计算用户是否长时间未回复弹出给出提示
    onCheckIsloogTimeNotCallBack(){
      var lastCallBackMessageTime = localStorage.getItem("userLastCallBackMessageTime_" + this.userAccount) || Date.now()
      if(this.isArtificial && !this.isUserSendLongTimeSystemMessage && Date.now() - lastCallBackMessageTime >= (1000*60)*5){
        const IM = this.$mimcInstance
        var message = IM.createLocalMessage("system", this.account, "您已超过5分钟未回复消息，系统3分钟后将结束对话")
        this.messages.push(this.handlerMessage(message))
        this.isUserSendLongTimeSystemMessage = true
        this.scrollIntoBottom()
      }
      setTimeout(()=> this.onCheckIsloogTimeNotCallBack(), 10000)
    },
    // 计算客服最后回复时间(超过3分钟没回复给出提示)
    onServciceLastMessageTimeNotCallBack(){
      if(!this.robotInfo) return
      var loogTimeWaitText = this.robotInfo.loog_time_wait_text
      var lastCallBackMessageTime = localStorage.getItem("adminLastCallBackMessageTime_" + this.account) || Date.now()
      if(this.isArtificial && !this.isAdminSendLongTimeSystemMessage && loogTimeWaitText.trim() != "" &&  Date.now() - lastCallBackMessageTime >= (1000*60)*2){
        const IM = this.$mimcInstance
        var message = IM.createLocalMessage("text", this.account, loogTimeWaitText)
        message.from_account = this.robotAccount
        this.messages.push(this.handlerMessage(message))
        this.isAdminSendLongTimeSystemMessage = true
        this.scrollIntoBottom()
      }
      setTimeout(()=> this.onServciceLastMessageTimeNotCallBack(), 10000)
    },
    // 检索知识库消息
    onSearchHandshake(){
      if(!this.chatValue || this.isArtificial){
        this.handshakeKeywordList = []
        return
      }
      if(this.searchHandshakeTimer) clearTimeout(this.searchHandshakeTimer)
      const IM = this.$mimcInstance
      this.searchHandshakeTimer = setTimeout(()=>{
        IM.sendMessage("search_knowledge", this.robotAccount, this.chatValue)
        this.searchHandshakeTimer = null
      },500)
    },
    // 输入框粘贴事件
    inputPaste(e){
      if(this.isMobile) return
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
              self.sendPhotoMessage(file)
          }
      }
    }
  },
  watch: {
    messages(){
      setTimeout(()=>{
        this.scroll && this.scroll.refresh()
        this.$previewRefresh()
      }, 50)
    },
    isArtificial(isArtificial){
      this.createLinkQuery()
      localStorage.setItem("isArtificial_" + this.userAccount, isArtificial)
      localStorage.setItem("artificialTime_" + this.userAccount,Date.now())
      if(!isArtificial){
        localStorage.removeItem("artificialTime_" + this.userAccount)
      }
    },
    artificialAccount(){
      localStorage.setItem("artificialAccount_" + this.userAccount, this.artificialAccount)
    },
    userInfo(){
      this.createLinkQuery()
    },
    chatValue(){
      this.onSearchHandshake()
    }
  }
}
</script>

<style lang="stylus">
  body{
    min-width 240px
    overflow: hidden;
    height 100vh
    background-color #f3f3f3
  }
  .mint-header.is-fixed{
    height 50px!important;
    background: -webkit-linear-gradient(to right,#26a2ff, #736cde);
    background: -o-linear-gradient(to right,#26a2ff, #736cde);
    background: -moz-linear-gradient(to right,#26a2ff, #736cde);
    background: linear-gradient(to right,#26a2ff, #736cde);
    .mint-header-title{
      font-size 15px
    }
  }
  .mint-header,.mint-tabbar{
    min-width 240px
    z-index: 999999999!important;
  }
  .mint-header .is-right{
    img{
      width 25px
    }
  }
  .mint-header .mint-button .mintui{
    font-size 23px!important;
  }
  .mint-tabbar{
    z-index: 999999999!important;
    background-color #fff!important;
  }
  .mint-loadmore-spinner{
    width: 15px !important;
    height: 15px !important;
  }
  .mini-im-container{
    margin: 0 auto;
    padding 50px 0 100px
    overflow: hidden;
    height 100vh
    box-sizing:border-box;
    -moz-box-sizing:border-box;
    -webkit-box-sizing:border-box;
    box-sizing: border-box;
    .input-ing{
      width 100vw
      height 25px
      position fixed
      top 0
      left 0
      right 0
      background-color #26a2ff!important;
      z-index 9
      color #fff
      margin auto
      text-align: center;
      font-size 14px
      line-height 25px
    }
    .mini-im-loading{
      display flex
      min-width 240px
      width 100%;
      position fixed
      top 0
      left 0
      right 0
      background-color #fff!important;
      margin auto
      align-items center
      justify-content center
    }
  }
  .mini-im-container-no-pto{
    padding-top 0px!important;
  }
  .mini-im-tabbar-input{
    width 100%
    padding 5px 10px
    overflow hidden
    height 100px
    display flex
    align-items flex-end
    justify-content space-between
    position fixed
    bottom 0
    z-index 9
    background-color #fff!important;
    border-top 1px solid #f2f2f2
    left 0
    right 0
    margin 0 auto
    -moz-box-sizing:border-box;
    -webkit-box-sizing:border-box;
    box-sizing: border-box;
    textarea{
      outline: none;
      -webkit-appearance none
      -webkit-tap-highlight-color: rgba(0, 0, 0, 0)
      border none
      border-radius 5px
      height 65px
      flex-grow 1
      padding 8px 0
      font-size 14px
      color #666
      background-color #ffffff
      display block
      box-sizing border-box
      resize none
      flex-shrink 1
      flex-grow 1
      width 100px
    }
    span{
      width 25px
      height 25px
      display flex
      align-items center
      justify-content center
      img{
        width 28px
      }
      &.expression-btn{
        position absolute
        left 40px
        top 6px
        z-index 99
      }
      &.photo-btn{
        position absolute
        left 10px
        top 5px
        overflow hidden
        z-index 99
        img{
          width 22px
          
        }
        input{
          width 100%
          height 100%
          position absolute
          top 0
          left 0
          opacity 0
        }
      }
      &.serverci{
        width 70px
        position absolute
        flex-direction: row;
        justify-content: flex-end;
        top 5px
        right 10px
        img{
          width 26px
        }
        span{
          width 70px
          background-color #f3f3f370
          color #999
          font-size 14px
        }
        &.on{
          left 75px
          justify-content: flex-start;
          right initial
        }
      }
    }
    .mini-input-send{
      width 55px
      height 30px
      color #fff
      line-height 30px
      text-align center
      border-radius 3px
      border none
      font-size 14px
      background: linear-gradient(to right, #26a2ff, #736cde);
      flex-shrink 0
      &:active{
        opacity 0.8
      }
    }

  }
  .mini-im-emoji{
    width 100%
    height 100vh
    position fixed
    top 0
    left 0
    right 0
    padding 5px 0
    z-index: 9;
    margin 0 auto
    background-color #fff
    .mini-im-emoji-content{
      width 100%
      height 100vh
      padding 50px 0 5px
      position absolute
      box-sizing:border-box;
      -moz-box-sizing:border-box;
      -webkit-box-sizing:border-box;
      overflow: hidden;
      bottom 0
      left 0
      right 0
      margin 0 auto
      background-color #fff
      text-align center
      box-shadow  0px 2px 2px 1px rgba(0, 0, 0, 0.1)
      span{
        display inline-block
        width 28px
        height 28px
        padding 2px
        text-align center
        font-size 23px
      }
    }
    
  }
  .mini-im-body{
    position: relative
    height 100%;
    box-sizing:border-box;
    -moz-box-sizing:border-box;
    -webkit-box-sizing:border-box;
    background-color #f3f3f3
    margin 0 auto
    overflow: hidden;
    z-index: 1;
    ul{
      position: absolute;
      z-index: 1;
      -webkit-tap-highlight-color: rgba(0,0,0,0);
      width: 100%;
      -webkit-transform: translateZ(0);
      -moz-transform: translateZ(0);
      -ms-transform: translateZ(0);
      -o-transform: translateZ(0);
      transform: translateZ(0);
      -webkit-touch-callout: none;
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      user-select: none;
      -webkit-text-size-adjust: none;
      -moz-text-size-adjust: none;
      -ms-text-size-adjust: none;
      -o-text-size-adjust: none;
      text-size-adjust: none;
    }
    .loading{
      height 100%
      position fixed
      top 0
      left 0
      right 0
      bottom 0
      margin auto
      display flex
      justify-content center
      align-items center
    }
    .no-network{
      width 100%;
      height 100%;
      background-color #fff
      position absolute
      top 0
      left 0
      right 0
      margin 0 auto
      display flex
      flex-direction: column;
      align-items: center;
      justify-content: center;
      z-index: 9;
      span{
        color #999
        font-size 13px
        margin 20px 0
      }
      button{
        width: 100px;
        height: 30px;
        color: #fff;
        line-height: 30px;
        text-align: center;
        border-radius: 3px;
        border: none;
        font-size: 14px;
        background: -webkit-gradient(linear, left top, right top, from(#26a2ff), to(#736cde));
        background: linear-gradient(to right, #26a2ff, #736cde);
        -ms-flex-negative: 0;
        flex-shrink: 0;
      }
    }
  }
  .mini-im-knowledge{
    width 100vw
    height 100vh
    background-color rgba(0,0,0, .2)
    position fixed
    z-index 8
    top 0
    left 0
    right 0
    margin 0 auto
    box-sizing:border-box;
    padding-bottom 100px
    display flex
    flex-direction column
    justify-content flex-end
    .mask{
      flex-grow: 1;
      width 100vw
      height 100px
    }
    span{
      background-color #fff
      font-size 14px
      color #666
      padding 10px
    }
    ul{
      background-color white
      li{
        font-size 13px
        cursor: pointer;
        color #56b7ff
        padding 6px 10px
        border-top 1px solid #f2f2f2
      }
    }
  }
  .mint-loadmore{
    height 100%
  }
  .mint-loadmore-text{
    color #666
    font-size 14px
  }
  .mini-im-chat-list{
    padding 20px 10px
    box-sizing:border-box;
    -moz-box-sizing:border-box;
    -webkit-box-sizing:border-box;
    .message-loading{
      padding-bottom 20px
      display flex
      align-items center
      justify-content center
    }
    .mini-im-chat-item{
      display flex
      margin-bottom 15px
      .chat-avatar{
        width 30px
        height 30px
        flex-grow 0
        flex-shrink 0
        overflow hidden
        margin-top 2px
        box-shadow: 1px 1px 2px 0px rgba(0, 0, 0, 0.3)
        border-radius 100%
        img{
          width 100%
          height 100%
          border-radius 100%
        }
      }
      .chat-content{
        width 100%
        padding-left 10px
        .chat-username{
          display flex
          align-items center
          padding-bottom 5px
          span{
            font-size 12px
            color #666
            font-weight 500
          }
          em{
            color #666
            font-size 12px
            margin-left 8px
          }
        }
        .chat-body{
          display flex
          align-items flex-end
          .cancel-btn{
            font-size 12px
            color #26a2ff !important;
            margin-right 5px
          }
          .text{
            padding 5px 8px
            background-color #fff
            border-radius 3px
            font-size 14px
            color #333
            max-width 85%
            position relative
            box-shadow  1px 2px 2px 0px rgba(0, 0, 0, 0.1)
            -webkit-user-select:text;
            -moz-user-select:text;
            -o-user-select:text;
            user-select:text;
            word-break break-all
            &:before{
              content  ''
              display block
              position absolute
              top 5px
              left -9px
              width 0
              height 0
              overflow hidden
              font-size 0
              line-height 0
              border 5px 
              border-radius 2px
              border-style dashed solid  dashed dashed
              border-color transparent #fff transparent transparent
            }
          }
          .photo{
            display flex
            align-items flex-end
            img{
              width 120px
              display block
              border-radius 5px
              cursor: pointer;
            }
            span{
              font-size 12px
              color #999
              padding-right 5px
            }
          }
          .system{
            width 100%
            display flex
            flex-direction column
            justify-content center
            span{
              text-align center
              font-size 12px
              color #999
            }
            .content{
              margin-top 1.5px
              height 25px
              text-align center
              span{
                padding 0 10px
                text-align center
                font-size 12px
                border-radius 5px
                display inline-block
                line-height 22px
                height 22px
                min-width 80px
                color #949393
              }
            }
          }
          .knowledge{
            padding 5px 8px
            background-color #fff
            border-radius 3px
            font-size 13px
            color #333
            max-width 80%
            position relative
            box-shadow  1px 2px 2px 0px rgba(0, 0, 0, 0.1)
            display flex
            flex-direction column
            align-items flex-start
            .title{
              min-height 25px
              font-size 14px
            }
            a{
              font-size 13px
              color #26a2ff
              text-decoration none
              width 100%
              display flex
              min-height 25px
            }
          }
        }
      }
      &.self{
        justify-content flex-end
        .chat-content{
          padding-right 10px
        }
        .chat-body{
          justify-content flex-end
          .text{
            box-shadow -1px 1px 3px 0px rgba(0,0,0,0.1)
            background-color #26a2ff
            color #fff
            -webkit-user-select:text;
            -moz-user-select:text;
            -o-user-select:text;
            user-select:text;
            word-break:break-all;
            &:before{
              left inherit
              right -9px
              border-style dashed dashed  dashed solid
              border-color transparent transparent transparent #26a2ff
            }
          }
        }
        .chat-avatar{
          order 1
        }
        .chat-username{
          justify-content flex-end
          em{
            order -2
            margin-right 5px
          }
        }

      }

    }

  }
  // PC端兼容样式
  .mini-im-pc-container{
    width 360px;
    height 500px
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    margin auto
    display flex
    flex-direction column
    padding 0!important
    overflow hidden
    box-shadow 1px 1px 8px 2px #ccc
    .mini-im-loading,.mini-im-emoji{
      width 360px!important
      height 500px!important
      bottom 0
      margin auto !important
    }
    .mini-im-emoji{
      box-sizing:border-box;
      -moz-box-sizing:border-box;
      -webkit-box-sizing:border-box;
    }
    .cancel-btn{
      cursor pointer
    }
    .mini-im-emoji-content{
        padding 8px!important
        height 465px!important
        box-sizing:border-box;
        -moz-box-sizing:border-box;
        -webkit-box-sizing:border-box;
        span{
          width 26px
          height 26px
          cursor pointer
        }
    }
    .mini-im-body{
      width 360px;
      height 500px
      position static !important
      .mini-im-chat-list{
        padding 15px!important
      }
    }
    .mini-im-pc-header{
      z-index: 999999999!important;
      height 45px
      background: linear-gradient(to right, #26a2ff, #736cde);
      flex-shrink 0
      display flex
      justify-content space-between
      align-items center
      padding 0 10px
      color #fff
      .right{
        display flex
        align-items center
        cursor pointer
        img{
          width 20px
          margin-right 5px
        }
      }
      .title{
        font-size 14px
        display flex
        align-items center
        img{
          width 20px
          margin-right 5px
        }
      }
      span{
        font-size 14px
      }
      .close-btn{
        width 20px
        height 35px
        text-align right
        line-height 35px
        cursor pointer
      }
    }
    .mini-im-tabbar-input{
        height 130px
        overflow hidden
        padding 5px
        position relative
        box-sizing:border-box;
        -moz-box-sizing:border-box;
        -webkit-box-sizing:border-box;
        z-index 9
        textarea{
          height 65px
          padding-right 5px
          margin 0
        }
        .mini-input-send{
          height 70px
          width 60px
          background: linear-gradient(to right, #26a2ff, #736cde);
          color #fff
          border 0
          cursor pointer
          border-radius 2px
        }
        span.photo-btn{
          left 3px
        }
        span.expression-btn{
          left 30px
        }
      }
  }
  .bscroll-vertical-scrollbar{
    right 0px!important
    height 100%!important
    .bscroll-indicator{
      width 4px !important
      border: 0 !important;
      background: rgba(0, 0, 0, 0.2) !important;
      right 0!important;
    }
  }

</style>
