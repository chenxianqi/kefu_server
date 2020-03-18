import axios from 'axios'
import router from '../router'
export default {
    // 获取用户信息
    ON_GET_ME(context){
        var pathname = location.pathname
        axios.get('/admin/me')
        .then(response => {
            context.commit("onIsLogin", true)
            context.commit("onChangeAdminInfo", response.data.data)
            if(location.pathname == '/login' || location.hash.indexOf("#/login") != -1){
                router.push({ path: '/index'})
            }
        })
        .catch(error => {
            console.log(error.response)
            context.commit("onIsLogin", false)
            if(pathname != '/login'){
                router.push({ path: '/login'})
            }
        });
    },
    // 获取上传配置
    ON_GET_UPLOAD_TOKEN(context){
        axios.get('/public/secret')
        .then(response => {
            context.commit('onChangeUploadToken', response.data.data)
        })
    },
    // 获取平台配置数据
    ON_GET_PLATFORM_CONFIG(context){
        axios.get('/platform/list')
        .then(response => {
            context.commit('onChangePlatformConfig', response.data.data)
        })
    },
    // 获取systemInfo
    ON_GET_SYSTEM(context){
        axios.get('/system')
        .then(response => {
            context.commit('onChangeSystemInfo', response.data.data)
            document.title =  response.data.data.title
        })
    },
    // 获取companyInfo
    ON_GET_COMPANY(context){
        axios.get('/public/company')
        .then(response => {
            context.commit('onChangeCompanyInfo', response.data.data)
        })
    },
    // 获取uploads/config
    ON_GET_UPLOADS_CONFIG(context){
        axios.get('/uploads/config')
        .then(response => {
            context.commit('onChangeUploadsConfigs', response.data.data)
        })
    },
    // 获取会话列表
    ON_GET_CONTACTS(context){
        axios.get('/contact/list')
        .then(response => {
            context.commit('onChangeContacts', response.data.data)
        })
    },
    // 一分钟上报一次我的活动
    ON_RUN_LAST_ACTiIVITY(){
        axios.get('/public/activity/')
    },
    // 获取机器人列表
    ON_GET_ROBOTS(context){
      axios.get('/robot/list')
      .then(response => {
          context.commit('onChangeRobos', response.data.data)
      })
      .catch(() => {
        this.loading = false
      });
    }
}