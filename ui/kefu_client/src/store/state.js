export default {
    platform: 5,                // 平台（渠道）
    isShowPageLoading: false,   // page loading
    isShowHeader: true,         // 是否显示header
    isMobile: true,             // 是否是移动端
    isArtificial: false,        // 是否是人工服务
    uid: 0,                     // 业务平台的ID
    userAccount: 0,             // 用户账号
    artificialAccount: null,    // 客服账号ID
    robotInfo: null,            // 机器人信息
    robotAccount: null,         // 机器人账号ID
    messages: [],               // 消息列表
    isLoadMorEnd: false,        // 是否已经到末尾
    userLocal: "",              // 用户地理位置
    AmapAPPKey: "",             // 高德地图web appkey
    isLoadMorLoading: false,    // 是否在加装更多消息loading
    userInfo: {},               // 用户信息
    companyInfo: null,          // 公司信息
    uploadToken: null,          // 上传token

    // workorder
    workorders: [],             // 工单列表
    workorderTypes: [],         // 工单类型列表
    
}