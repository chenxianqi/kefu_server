// eslint-disable-next-line no-unused-vars
var MiniIM = {
    showChat: false,
    miniImClientBar: null,
    miniImclientIframe: null,
    miniImclientIframeBox: null,
    miniImClientFixed: null,
    miniImClientNewMessageTag: null,
    isShowMiniIM: false,
    isFlashTag: true,
    // 配置信息
    // query 介绍
    // h == header  0 不显示 1显示 默认值显示，PC端不显示
    // m == mobile  0 不是移动端 1是移动端
    // p == platform  平台ID（渠道）
    // r == robot   0 当前为客服 1机器人
    // a == account 当前提供对话服务的账号，客服账号，或机器人账号
    // u == userAccount  会话用户账号
    // uid == userId  业务平台的ID
    options: {
        isShowPcBar: true,// 是否显示PC右下角的bar
        url: "localhost", // 项目地址
        platform: 5,      // 平台
        isHeader: 1,      // 移动端是否显示header
        isMobile: 1,      // 是否是移动端
        isRobot: 1,       // 当前是否机器人提供服务（默认即可）
        account: 0,       // 当前提供对话服务的账号，即客服账号，或机器人默认即可）
        userAccount: 0,   // 会话用户账号
        uid: 0,           // 业务平台的ID
        isFlashTag: true, // 有新消息是否闪烁
    },
    // 初始化
    init: function(options){
        if(!options.url){
            alert("URL不能为空！")
            return
        }
        if(options.url != undefined) this.options.url = options.url
        if(options.platform != undefined) this.options.platform = options.platform
        if(options.isHeader != undefined) this.options.isHeader = options.isHeader
        if(options.isMobile != undefined) this.options.isMobile = options.isMobile
        if(options.isRobot != undefined) this.options.isRobot = options.isRobot
        if(options.account != undefined) this.options.account = options.account
        if(options.isShowPcBar != undefined) this.options.isShowPcBar = options.isShowPcBar
        if(options.userAccount != undefined) this.options.userAccount = options.userAccount
        if(options.uid != undefined) this.options.uid = options.uid
        if(options.isFlashTag != undefined) this.isFlashTag= options.isFlashTag
        var self = this
        if(options.isMobile == 0){
            this.createStyle()
            this.createElement()
            window.addEventListener('message',function(event){
                if(event.data.clickCloseWindow) self.hideChatWindow()
                if(event.data.newMessage > 0 && !this.isShowMiniIM){
                    self.flashTag()
                }else{
                    if(this.flashTagInterval) clearInterval(this.flashTagInterval)
                    this.miniImClientNewMessageTag.innerHTML = "在线客服" 
                }
            }, false)
        }
        return this
    },
    // flash tag
    flashTagInterval: null,
    flashTag(){
        if(!this.isFlashTag) return
        if(this.flashTagInterval) clearInterval(this.flashTagInterval)
        var self = this
        var timer = 0
        this.flashTagInterval = setInterval(function(){
            timer ++
            if(timer%2 == 0){
                self.miniImClientNewMessageTag.innerHTML = " 您有新消息"
            }else{
                self.miniImClientNewMessageTag.innerHTML = ""
            }
        }, 500)
    },
    // showChat
    showChatWindow(){
        if(this.flashTagInterval) clearInterval(this.flashTagInterval)
        this.miniImClientNewMessageTag.innerHTML = "在线客服" 
        if(this.isShowMiniIM) return
        this.isShowMiniIM = true
        this.miniImClientBar.style.display = "none"
        this.miniImclientIframeBox.style.display = "block"
        // 加点动画效果
        var right = -360;
        this.miniImClientFixed.style.right = right + 'px'
        var interval = setInterval(function(){
            right = right + 5
            this.miniImClientFixed.style.right = right + 'px'
            if(right == 10) clearInterval(interval)
        }, 1);
    },
    // hideChat
    hideChatWindow(){
        if(this.flashTagInterval) clearInterval(this.flashTagInterval)
        this.miniImClientNewMessageTag.innerHTML = "在线客服" 
        if(!this.isShowMiniIM) return
        this.isShowMiniIM = false
        // 加点动画效果
        var right = 10;
        var interval = setInterval(function(){
            right = right - 5
            this.miniImClientFixed.style.right = right + 'px'
            if(right <= -360){
                this.miniImClientBar.style.display = "flex"
                this.miniImClientBar.style.display = "flex"
                this.miniImclientIframeBox.style.display = "none"
                this.miniImClientFixed.style.right = 10 + 'px'
                clearInterval(interval)
            }
        }, 1);
    },
    // 创建连接
    createLink(){
        var options = this.options
        var host = options.url +'/'
        var r = options.isRobot
        var a = options.account
        var m = options.isMobile
        var h = options.isHeader
        var p = options.platform
        var u = options.userAccount
        var uid = options.uid
        var query = "?h=" + h + "&m=" + m + "&p=" + p + "&r=" + r + "&a=" + a + "&u=" + u + "&uid=" + uid
        return host + query
    },
    // PC 创建一个element悬浮在右下角
    createElement: function(){
        var htmlString = '<div class="mini-im-client-iframe"id="miniImclientIframeBox"><iframe id="miniImclientIframe"height="500"width="360"frameborder="0"></iframe></div><div class="mini-im-client-bar"id="miniImClientBar"><div class="mini-im-client-bar-icon"><img src="http://qiniu.cmp520.com/kefu_icon_2000.png"alt=""></div><div class="mini-im-client-bar-title" id="miniImClientNewMessageTag">在线客服</div></div>'
        var miniImClientFixedBox = document.createElement("div")
        miniImClientFixedBox.setAttribute("class", "mini-im-client-fixed")
        miniImClientFixedBox.setAttribute("id", "miniImClientFixed")
        miniImClientFixedBox.innerHTML = htmlString
        document.body.append(miniImClientFixedBox)
        this.miniImClientFixed = document.getElementById("miniImClientFixed")
        this.miniImClientNewMessageTag = document.getElementById("miniImClientNewMessageTag")
        this.miniImClientBar = document.getElementById("miniImClientBar")
        this.miniImclientIframe = document.getElementById("miniImclientIframe")
        this.miniImclientIframeBox = document.getElementById("miniImclientIframeBox")
        var link = this.createLink()
        this.miniImclientIframe.src = link
        var self = this
        if(!this.options.isShowPcBar){
            this.miniImClientFixed.style.background = "none";
            this.miniImClientFixed.style.minHeight = "1px"
            this.miniImClientBar.style.height = "1px"
            this.miniImClientBar.style.opacity = 0;
        }
        
        this.options.isShowPcBar && this.miniImClientBar.addEventListener("click", function(){
            self.showChatWindow()
        }, false)
        
    },
    // PC 页面写入样式
    createStyle: function(){
        var style = '.mini-im-client-fixed{position:fixed;z-index: 9999999;bottom:10px;right:10px;min-width:200px;max-width:360px;min-height:40px}.mini-im-client-bar{width:200px;height:40px;border-radius:3px;overflow:hidden;display:flex;cursor:pointer}.mini-im-client-bar-icon{width:40px;height:40px;background-color:#1779ca;display:flex;justify-content:center;align-items:center}.mini-im-client-bar-icon img{width:30px;height:30px}.mini-im-client-bar-title{width:160px;height:40px;background-color:#1898fc;display:flex;justify-content:center;align-items:center;color:#fff;font-size:15px;text-align:center}.mini-im-client-iframe{width:360px;height:500px;box-shadow:1px 1px 8px 2px rgba(0, 0, 0, 0.16);display:none}'
        var styleElement = document.createElement("style")
        styleElement.innerHTML = style
        document.head.append(styleElement)
    }
}