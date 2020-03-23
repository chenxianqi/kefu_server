var moment = require('moment');
import axios from "axios";
import * as qiniu from "qiniu-js";
// eslint-disable-next-line no-undef
var Helps = {};
Helps.install = function (Vue, options) {
    Vue.prototype.$myMethod = function () {
        console.log(options)
    }
    // 格式化日期
    Vue.prototype.$formatUnixDate = function (unix, format) {
        return moment(parseInt(unix + '000')).format(format)
    }
    // 格式化日期(相对日期)
    Vue.prototype.$formatFromNowDate = function (unix, format = "YYYY-MM-DD HH:mm") {
        if (moment().format("YYYYMMDD") == moment(parseInt(unix + '000')).format("YYYYMMDD")) {
            return "今天 " + moment(parseInt(unix + '000')).format("HH:mm")
        }
        return moment(parseInt(unix + '000')).format(format)
    }
    // 格式化日期(相对日期)
    Vue.prototype.$formatDate = function (unix, format = "YYYY-MM-DD HH:mm:ss") {
        return moment(parseInt(unix + '000')).format(format)
    }
    Vue.prototype.$robotNickname = function (id) {
        var nickname
        var robots = this.$store.getters.robots
        for (let i = 0; i < robots.length; i++) {
            if (robots[i].id == id) {
                nickname = robots[i].nickname
            }
        }
        return nickname
    }

    // 上传文件
    Vue.prototype.$uploadFile = function ({ mode, file, percent, success, fail }) {
        var qiniuObservable = null;
        const fileName = parseInt(Math.random() * 10000 * new Date().getTime()) + file.name.substr(file.name.lastIndexOf("."));
        // 系统内置
        if (mode == 1) {
            let fd = new FormData();
            fd.append("file", file);
            fd.append("file_name", fileName);
            axios
                .post("/public/upload", fd)
                .then(res => {
                    if (success) success(res.data.data);
                })
                .catch((e) => {
                    if (fail) fail(e);
                });
        }
        // 七牛云
        else if (mode == 2) {
            let options = {
                quality: 0.92,
                noCompressIfLarger: true,
                maxWidth: 1500
            };
            qiniu.compressImage(file, options).then(data => {
                const observable = qiniu.upload(
                    data.dist,
                    fileName,
                    self.uploadToken.secret,
                    {},
                    {
                        mimeType: null
                    }
                );
                qiniuObservable = observable.subscribe({
                    next: function (res) {
                        if (percent) percent(res)
                    },
                    error: function () {
                        // 失败后再次使用FormData上传
                        var formData = new FormData();
                        formData.append("fileType", "image");
                        formData.append("fileName", "file");
                        formData.append("key", fileName);
                        formData.append("token", self.uploadToken.secret);
                        formData.append("file", file);
                        axios
                            .post("https://upload.qiniup.com", formData)
                            .then(() => {
                                if (success) success(fileName);
                            })
                            .catch((e) => {
                                if (fail) fail(e);
                            });
                    },
                    complete: function (res) {
                        if (success) success(res.key);
                    }
                });
            });
        }

        return qiniuObservable

    }


}
export default Helps;