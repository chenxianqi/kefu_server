import axios from "axios";
import { Message } from 'element-ui';
var MimcPlugin = {};
MimcPlugin.install = function (Vue, options) {

    console.log(options)

    // 获取单个平台数据
    Vue.MimcInstance = Vue.prototype.$mimcInstance = {
        user: null,
        robot: null,
        fetchMIMCTokenResult: null,
        // 初始化
        init(request, callback){
            this.getRobot()
            this.fetchMIMCToken(request, callback)
        },
        _receiveP2PMsgCallback: null,
        _statusChangeCallback: null,
        _serverAckCallback: null,
        _disconnectCallback: null,
        // 获取token
        // request 登录参数
        // 登录回调 callback bool 是否成功
        fetchMIMCToken(request, callback){
            axios.post('/public/register', request)
            .then(response => {
                this.fetchMIMCTokenResult = response.data.data.token
                if(callback) callback(true)
                console.log("MIMC初始化成功")
            })
            .catch((error)=>{
                if(callback) callback(false)
                Message.error("mimc初始化失败,请刷新重试," + error.response.data.message)
            })
        },
        // 获取机器人
        getRobot(){
            axios.get('/public/robot/1')
            .then(response => {
                this.robot = response.data.data
            })
            .catch((error)=>{
                Message.error("mimc初始化失败,请刷新重试" + error.response.data.message)
            })
        },
        // pushMessage
        pushMessage(payload){
            axios.post('/public/message/push', {
                "msgType": "NORMAL_MSG",
                "payload": payload
            })
            .then(response => {
                console.log(response.data)
                if(response.data['code'] != 200){
                    setTimeout(()=> this.pushMessage(payload), 300)
                }
            })
            .catch(()=>{
                setTimeout(()=> this.pushMessage(payload), 300)
            })
        },
        // 登录
        login(callback){
            try{
                var fetchMIMCTokenResult = this.fetchMIMCTokenResult
                if(!fetchMIMCTokenResult) return
                // eslint-disable-next-line no-undef
                this.user = new MIMCUser(fetchMIMCTokenResult.data.appId, fetchMIMCTokenResult.data.appAccount, "666");
                this.user.registerP2PMsgHandler((message)=>{
                    var msg = JSON.parse(window.Base64.decode(message.getPayload()));
                    if(this._receiveP2PMsgCallback) this._receiveP2PMsgCallback(msg)
                });
                this.user.registerFetchToken(() => {
                    return fetchMIMCTokenResult;
                });
                this.user.registerStatusChange((bindResult, errType, errReason, errDesc)=>{
                    if(this._statusChangeCallback) this._statusChangeCallback(bindResult, errType, errReason, errDesc)
                });
                this.user.registerServerAckHandler((packetId, sequence, timeStamp, errMsg)=>{
                    if(this._serverAckCallback) this._serverAckCallback(packetId, sequence, timeStamp, errMsg)
                });
                this.user.registerDisconnHandler(() => {
                    if(this._disconnectCallback) this._disconnectCallback()
                });
                this.user.login();
                window.mimcInstance = this
                if(callback) callback()
                console.log("MIMC登录成功")
            }catch(e){
                console.log(e)
                console.log("MIMC登录失败")
                // 重新尝试
                setTimeout(()=>{
                    this.login()
                }, 1000)
            }
        },
        // 退出
        logout(){
            if(this.user){
                this.user.logout()
                this.user = null
            }
        },
        // 注册监听器
        addEventListener(type, callback){
            switch(type){
                case "receiveP2PMsg":
                    this._receiveP2PMsgCallback = callback
                break
                case "statusChange":
                    this._statusChangeCallback = callback
                break
                case "serverAck":
                    this._serverAckCallback = callback
                break
                case "disconnect":
                    this._disconnectCallback = callback
                break
            }
        },
        // 发送消息
        sendMessage(type, toAccount, payload = "", transferAccount = 0){
            if(!this.user){
                Message.error("服务异常，请刷新重试！")
                return
            }
            const messageJson = {
                "from_account": parseInt(this.fetchMIMCTokenResult.data.appAccount),
                "to_account": parseInt(toAccount),
                "biz_type": type,
                "version": "0",
                "timestamp": parseInt((new Date().getTime() + " ").substr(0, 10)),
                "key": new Date().getTime(),
                "read": 0,
                "transfer_account": parseInt(transferAccount),
                "payload": payload + ''
            }
            // console.log("发送消息")
            // console.log(messageJson)
            const jsonBase64Msg = window.Base64.encode(JSON.stringify(messageJson))
            try {
                
                // 过滤不入库
                if(!(type == "contacts" || type == "pong" || type == "welcome" || type == "handshake")){
                    // 发送给机器人入库
                    // const intoMessageJson = {
                    //     "biz_type": "into",
                    //     "payload": jsonBase64Msg
                    // }
                    // const intoJsonBase64Msg = window.Base64.encode(JSON.stringify(intoMessageJson))
                    // this.user.sendMessage(this.robot.id.toString(), intoJsonBase64Msg);

                    // 消息入库
                    this.pushMessage(window.Base64.encode(jsonBase64Msg))
                }

                setTimeout(()=>{
                    // 发送给对方
                    this.user.sendMessage(toAccount.toString(), jsonBase64Msg);
                },200)
                
            } catch (err) {
                console.log("sendMessage fail, err=" + err);
            }
            return messageJson
        },
        // 创建本地消息
        createLocalMessage(type, toAccount, payload = "", transferAccount = 0){
            const messageJson = {
                "from_account": parseInt(this.fetchMIMCTokenResult.data.appAccount),
                "to_account": parseInt(toAccount),
                "biz_type": type,
                "version": "0",
                "timestamp": parseInt((new Date().getTime() + " ").substr(0, 10)),
                "key": new Date().getTime(),
                "read": 0,
                "transfer_account": parseInt(transferAccount),
                "payload": payload + ''
            }
            return messageJson
        }
        

    }
}
export default MimcPlugin;