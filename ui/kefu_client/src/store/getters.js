export default {
    platform(state) {
        return state.platform;
    },
    isArtificial(state) {
        return state.isArtificial;
    },
    isShowHeader(state) {
        return state.isShowHeader;
    },
    isMobile(state) {
        return state.isMobile;
    },
    uid(state) {
        return state.uid;
    },
    userAccount(state) {
        return state.userAccount;
    },
    artificialAccount(state) {
        return state.artificialAccount;
    },
    robotInfo(state) {
        return state.robotInfo
    },
    robotAccount(state) {
        return state.robotAccount
    },
    isLoadMorEnd(state) {
        return state.isLoadMorEnd
    },
    messages(state) {
        return state.messages || []
    },
    userLocal(state) {
        return state.userLocal
    },
    isLoadMorLoading(state) {
        return state.isLoadMorLoading
    },
    userInfo(state) {
        return state.userInfo
    },
    companyInfo(state) {
        return state.companyInfo
    },
    uploadToken(state) {
        return state.uploadToken
    },
    isIOS() {
        return !!navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
    },
    isSafari() {
        return (
            navigator.userAgent.indexOf("Safari") > -1 &&
            navigator.userAgent.indexOf("Chrome") < 1
        );
    },
    isJudgeBigScreen() {
        let yes = false;
        const rate = window.screen.height / window.screen.width;
        let limit = window.screen.height == window.screen.availHeight ? 1.8 : 1.65;
        if (rate > limit) yes = true;
        return yes;
    }
}