

###======install beego=======
##### go get github.com/astaxie/beego

###=====install MIMC-Go-SDK====

#####go get github.com/Xiaomi-mimc/mimc-go-sdk
#####cd $GOPATH/src/github.com/Xiaomi-mimc/mimc-go-sdk
#####go build
#####go install 

###**下载依赖库**

#####MIMC-Go-SDK依赖proto buffer进行序列化与反序列化数据，在使用时，确保已经install了proto buffer。如未安装，可参考如下进行安装操作。

#####go get github.com/golang/protobuf/proto
#####// 进入下载目录
#####cd $GOPATH/src/github.com/golang/protobuf/proto
#####// 编译安装
#####go build
#####go install

###===== cache 模块 ====
go get github.com/astaxie/beego/cache

###==== 七牛云SDK ====
#####go get -u github.com/qiniu/api.v7

###=====运行====
#####bee run


#####打包发布
#####bee pack -be GOOS=linux