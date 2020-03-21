import axios from "axios";
export default {
  // 获取消息列表
  // params.timestamp
  // params.callback
  // params.oldMsg old msgs
  onGetMessages(context, params) {
    const pageSize = 20;
    axios
      .post("/public/messages", {
        timestamp: params.timestamp,
        page_size: pageSize
      })
      .then(response => {
        let newMessage = [];
        let messages = response.data.data.list || [];
        if (messages.length < pageSize) {
          context.commit('updateState', { isLoadMorEnd: true })
        }
        if (params.oldMsg.length == 0 && messages.length > 0) {
          newMessage = response.data.data.list
        } else if (messages.length > 0) {
          newMessage = messages.concat(params.oldMsg);
        }
        context.commit('updateState', { messages: newMessage })
        if (params.callback) params.callback()
      })
      .catch(error => {
        console.log(error);
      });
  },
  // 获取用户位置
  // APPKey 高德地图web应用key
  onGetLocal(context, APPKey) {
    axios
      .get("https://restapi.amap.com/v3/ip?key=" + APPKey)
      .then(response => {
        if (response.data.province) {
          context.commit('updateState', { userLocal: response.data.province + response.data.city })
        }
      })
      .catch(error => {
        console.error(error);
      });
  },
  // 清除未读消息
  onCleanRead() {
    axios.get("/public/clean_read/");
  },
  // 上报最后活动时间
  onUpdateLastActivity() {
    axios.get("/public/activity/");
  },
  // 用户是否在当前聊天页面
  onToggleWindow(context, window) {
    axios.put("/public/window/", { window });
  },
  // 用户是否在当前聊天页面
  onGetCompanyInfo(context) {
    axios
      .get("/public/company")
      .then(response => {
        context.commit('updateState', { companyInfo: response.data.data })
      })
      .catch(error => {
        console.error(error);
      });
  },
  // 获取上传配置
  onGetUploadSecret(context){
    axios.get("/public/secret").then(response => {
      context.commit('updateState', { uploadToken: response.data.data })
    });
  }
}