import Vue from 'vue'
import ElementUI from 'element-ui'
import App from './App.vue'
import router from './router'
import store from './store'
import 'element-ui/lib/theme-chalk/index.css'
import preview from 'vue-photo-preview'
import 'vue-photo-preview/dist/skin.css'
import Helps from "./plugins/help"
import MimcPlugin from "./plugins/mimc"
import momentLocal from './resource/moment_locale'
var moment = require('moment');
moment.locale("zh-cn", momentLocal)

import axios from 'axios'

axios.defaults.baseURL = '/v1'

// 添加请求拦截器
axios.interceptors.request.use((config) => {
  var token = localStorage.getItem("Authorization")
  config.headers['Authorization'] = token || ""
  return config;
}, (error) => {
  return Promise.reject(error);
});

// 添加响应拦截器
axios.interceptors.response.use((response) => {
  return response;
}, (error) => {
  // 登录失效了
  if(error.response.status == 401) {
    localStorage.clear()
    store.commit("onChangeAdminInfo", null)
    if(store.state.mimcUser) store.state.mimcUser.logout()
    router.push("/login")
  }
  return Promise.reject(error);
});

var options={
  fullscreenEl:false, //关闭全屏按钮
}
Vue.use(preview, options)
Vue.use(ElementUI)
Vue.use(Helps)
Vue.use(MimcPlugin)

Vue.config.productionTip = false
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
