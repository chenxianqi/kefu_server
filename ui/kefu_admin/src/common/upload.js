import store from '../store'
import * as qiniu from 'qiniu-js'
import axios from 'axios'
var subscription;
export default function({file, progress, success, error}){
    if(!file) return
    const uploadToken = store.getters.uploadToken || {}
    const fileName = parseInt(Math.random() * 10000 * new Date().getTime()) + file.name.substr(file.name.lastIndexOf('.'))

    // 系统内置
    if(uploadToken.mode == 1){
        var CancelToken = axios.CancelToken;
        subscription = CancelToken.source();
        let fd = new FormData();
        fd.append('file',file);
        fd.append('file_name', fileName);
        axios.post('/public/upload', fd, {
            cancelToken: subscription.token
        })
        .then((res) => success(res.data.data))
        .catch((err) => error(err.message))
        progress(100)
    // 七牛云
    }else if(uploadToken.mode == 2){

        var observer = {
        next: res => progress(Math.ceil(res.total.percent)),
        error: err => error(err.message),
        complete: res => success(res.key)
        };
        const observable = qiniu.upload(file, fileName, uploadToken.secret, {}, {})
        subscription = observable.subscribe(observer)

    }else{
        alert("上传配置错误")
    }
    return subscription
} 