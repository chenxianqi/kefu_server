var moment = require('moment');
// eslint-disable-next-line no-undef
var Helps = {};
Helps.install = function (Vue, options) {
    Vue.prototype.$myMethod = function(){
        console.log(options)
    }
    // 获取单个平台数据
    Vue.prototype.$getPlatformItem = function(index){
        var platformConfigItem
        var platformConfig = this.$store.getters.platformConfig
        for(let i = 0; i< platformConfig.length; i++){
            if(platformConfig[i].id == index){
                platformConfigItem = platformConfig[i]
            }
        }
        return platformConfigItem || {title: "未知"}
    }
    // 格式化日期
    Vue.prototype.$formatUnixDate = function(unix, format = "YYYY-MM-DD HH:mm:ss"){
        return moment(parseInt(unix + '000')).format(format)
    }
    // 格式化日期(相对日期)
    Vue.prototype.$formatFromNowDate = function(unix){
        if(moment().format("YYYYMMDD") == moment(parseInt(unix + '000')).format("YYYYMMDD")){
            return moment(parseInt(unix + '000')).format("HH:mm")
        }
        return moment(parseInt(unix + '000')).format("YYYY-MM-DD HH:mm")
    }
    Vue.prototype.$robotNickname = function(id){
        var nickname
        var robots = this.$store.getters.robots
        for(let i = 0; i< robots.length; i++){
            if(robots[i].id == id){
                nickname = robots[i].nickname
            }
        }
        return nickname
    }

}
export default Helps;