var moment = require('moment');
// eslint-disable-next-line no-undef
var Helps = {};
Helps.install = function (Vue, options) {
    Vue.prototype.$myMethod = function(){
        console.log(options)
    }
    // 格式化日期
    Vue.prototype.$formatUnixDate = function(unix, format){
        return moment(parseInt(unix + '000')).format(format)
    }
    // 格式化日期(相对日期)
    Vue.prototype.$formatFromNowDate = function(unix, format = "YYYY-MM-DD HH:mm"){
        if(moment().format("YYYYMMDD") == moment(parseInt(unix + '000')).format("YYYYMMDD")){
            return "今天 " + moment(parseInt(unix + '000')).format("HH:mm")
        }
        return moment(parseInt(unix + '000')).format(format)
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

    // 判断是否是全面屏
    Vue.prototype.$judgeBigScreen = function(){
        let yes = false;
		const rate = window.screen.height / window.screen.width;    
		let limit =  window.screen.height == window.screen.availHeight ? 1.8 : 1.65;
		if (rate > limit) yes = true;
		return yes;
    }

}
export default Helps;