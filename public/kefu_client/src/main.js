import Vue from 'vue'
import App from './App.vue'
import preview from 'vue-photo-preview'
import 'vue-photo-preview/dist/skin.css'
import MintUI from 'mint-ui'
import 'mint-ui/lib/style.css'
import Helps from "../plugins/help"
import MimcPlugin from "../plugins/mimc"
import momentLocal from '../resource/moment_locale'
var moment = require('moment');
moment.locale("zh-cn", momentLocal)

import axios from 'axios'

axios.defaults.baseURL = '/v1'

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
  render: h => h(App)
}).$mount('#app')
