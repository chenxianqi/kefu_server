export default {
     // 获取个人信息
     adminInfo(state){
        return state.adminInfo || {}
    },
    // 是否是登录状态
    isLogin(state){
        return state.isLogin
    },
    // 获取头像
    avatar(state){
        if(state.adminInfo && state.adminInfo.avatar != ""){
            return state.adminInfo.avatar
        }else{
            return ''
        }
    },
    // 获取上传mode
    uploadMod(state){
        return state.uploadToken.mode || -1
    },  
    // 获取昵称
    nickname(state){
        if(state.adminInfo && state.adminInfo.nickname != ""){
            return state.adminInfo.nickname
        }else{
            return '未设置昵称'
        }
    },
    // 获取上传配置文件
    uploadToken(state){
        return state.uploadToken
    },
    // 获取平台配置数据
    platformConfig(state){
        return state.platformConfig
    },
    // 获取systemInfo
    systemInfo(state){
        return state.systemInfo
    },
    // 获取companyInfo
    companyInfo(state){
        return state.companyInfo
    },
    // 获取uploadsConfigs
    uploadsConfigs(state){
        return state.uploadsConfigs
    },
    // 获取会话列表
    contacts(state){
        return state.contacts|| []
    },
    // 获取当前窗口服务谁
    seviceCurrentUser(state){
        return state.seviceCurrentUser || {}
    },
    // 获取机器人
    robots(state){
        return state.robots || []
    },
    // 聊天信息
    messageRecord(state){
        return state.messageRecord || {list:[]}
    },
    // 新消息总数
    readCount(state){
        var count = 0
        for(let i =0; i<state.contacts.length; i++) {
            count = count + state.contacts[i].read
        }
        return count
    },
    // 工作台背景颜色
    workbenchBgColor(state){
        return state.workbenchBgColor
    },
}