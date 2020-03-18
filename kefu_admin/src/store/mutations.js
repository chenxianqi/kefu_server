export default {
    // 更新标题
    onChangeHeaserTitle(state, title){
        state.heaserTitle = title
    },
    // 更新平台配置数据
    onChangePlatformConfig(state, platformConfig){
        state.platformConfig = platformConfig
    },
    // 展开隐藏
    onChangeToggleAside(state, isShow){
        state.isShowAside = isShow
    },
    // 更新个人资料modal状态
    onChangeEditDialogFormVisible(state, isShow){
        state.editDialogFormVisible = isShow
    },
    // 更新个人密码modal状态
    onChangeEditPasswordDialogFormVisible(state, isShow){
        state.editPasswordDialogFormVisible = isShow
    },
    // 更新个人资料
    onChangeAdminInfo(state, adminInfo){
        state.adminInfo = adminInfo
    },
    // 更新上传token
    onChangeUploadToken(state, uploadToken){
        state.uploadToken = uploadToken
    },
    // 更新systemInfo
    onChangeSystemInfo(state, systemInfo){
        state.systemInfo = systemInfo
    },
    // 更新companyInfo
    onChangeCompanyInfo(state, companyInfo){
        state.companyInfo = companyInfo
    },
    // 更新uploadsConfigs
    onChangeUploadsConfigs(state, uploadsConfigs){
        state.uploadsConfigs = uploadsConfigs
    },
    // 更新mimcUser
    onChangeMimcUser(state, mimcUser){
        state.mimcUser = mimcUser
    },
    // 更新contacts
    onChangeContacts(state, contacts){
        state.contacts = contacts
        for(let index in contacts){
            var contact = contacts[index]
            if(state.seviceCurrentUser && contact.from_account == state.seviceCurrentUser.from_account){
                state.seviceCurrentUser = contact
                break
            }
        }
    },
    // 更新当前窗口服务谁
    onChangeSeviceCurrentUser(state, seviceCurrentUser){
        state.seviceCurrentUser = seviceCurrentUser
    },
    // 更新机器人列表
    onChangeRobos(state, robots){
        state.robots = robots
    },
    // 重置某些值
    onReset(state){
        state.seviceCurrentUser = null
        state.contacts = []
        state.mimcUser = null
    },
    // 更新聊天记录
    onChangeMessageRecord(state, messageRecord){
        state.messageRecord = messageRecord
    },
    // 是否是登陆状态
    onIsLogin(state, isLogin){
        state.isLogin = isLogin
    }
}