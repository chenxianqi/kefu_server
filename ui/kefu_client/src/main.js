import Vue from 'vue'
import App from './App.vue'
import preview from 'vue-photo-preview'
import router from "./router"
import store from './store'
import 'vue-photo-preview/dist/skin.css'
import MintUI from 'mint-ui'
import 'mint-ui/lib/style.css'
import Helps from "../plugins/help"
import MimcPlugin from "../plugins/mimc"
import momentLocal from '../resource/moment_locale'
var moment = require('moment');
moment.locale("zh-cn", momentLocal)

import axios from 'axios'

axios.defaults.baseURL = '/api'

// axios添加请求拦截器
axios.interceptors.request.use(function (config) {
  const token = localStorage.getItem('Token') || ""
  config.headers = Object.assign({}, {
    'Token': token,
  }, config.headers)
  return config;
}, function (error) {
  // eslint-disable-next-line no-console
  console.log(error)
  return Promise.reject(error);
});

var options={
  clickToCloseNonZoomable: false,
  fullscreenEl:false, //关闭全屏按钮
}
Vue.use(preview, options)
Vue.use(Helps)
Vue.use(MimcPlugin)
Vue.use(MintUI)
Vue.config.productionTip = false
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
