<template>
  <div>
    <div class="mini-im-head">
      <span>
        <i class="el-icon-setting"></i>
        <span slot="title">系统设置</span>
      </span>
    </div>
    <el-tabs v-model="activeName">
      <el-tab-pane label="基本设置" name="first">
        <el-form style="width:500px" ref="form" label-width="100px">
          <el-form-item label="系统LOGO" label-width="120px">
            <el-row :gutter="10">
              <el-col :span="3">
                <div class="mini-im-file-button" title="点击上传图片">
                  <img :src="systemInfo.logo" alt="点击上传图片">
                  <input
                    :disabled="!isRoot"
                    onClick="this.value = null"
                    @change="systemLogoUpload"
                    type="file"
                    accept="image/*"
                  />
                  <div v-show="isUploadingSysLogo" class="mini-im-file-percent">
                    <span>{{uploadysLogoPercent}}</span>
                  </div>
                </div>
              </el-col>
              <el-col :span="6"></el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="系统名称">
            <el-input :readonly="!isRoot" v-model="systemInfo.title" placeholder="请输入系统名称"></el-input>
          </el-form-item>
          <el-form-item label="版权信息">
            <el-input :readonly="!isRoot" v-model="systemInfo.copy_right" placeholder="请输入版权信息"></el-input>
          </el-form-item>
          <el-divider content-position="left">选择资源存储空间服务商（上传的，图片，文件）</el-divider>
          <el-form-item label="上传选项">
            <el-select v-model="systemInfo.upload_mode">
              <el-option :label="item.name" :value="item.id" :key="item.id" v-for="item in $store.getters.uploadsConfigs"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button v-if="isRoot" @click="saveSystem" size="mini">保存设置</el-button>
          </el-form-item>
        </el-form>
      </el-tab-pane>
      <el-tab-pane label="公司信息" name="second">
        <el-divider content-position="left">该配置信息会展示在各个前台给客户</el-divider>
        <el-form style="width:500px" ref="form" label-width="100px">
          <el-form-item label="公司LOGO" label-width="120px">
            <el-row :gutter="10">
              <el-col :span="3">
                <div class="mini-im-file-button" title="点击上传图片">
                  <img :src="companyInfo.logo" alt="点击上传图片">
                  <input
                    :disabled="!isRoot"
                    onClick="this.value = null"
                    @change="companyLogoUpload"
                    type="file"
                    accept="image/*"
                  />
                  <div v-show="isUploadingCompany" class="mini-im-file-percent">
                    <span>{{uploadCompanyPercent}}</span>
                  </div>
                </div>
              </el-col>
              <el-col :span="6"></el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="公司名称">
            <el-input :readonly="!isRoot" v-model="companyInfo.title" placeholder="请输入公司名称"></el-input>
          </el-form-item>
          <el-form-item label="服务时间">
            <el-input :readonly="!isRoot" v-model="companyInfo.service" placeholder="请输入在线客服服务时间"></el-input>
          </el-form-item>
          <el-form-item label="公司邮箱">
            <el-input :readonly="!isRoot" v-model="companyInfo.email" placeholder="请输入公司邮箱"></el-input>
          </el-form-item>
          <el-form-item label="公司电话">
            <el-input :readonly="!isRoot" v-model="companyInfo.tel" placeholder="请输入公司电话"></el-input>
          </el-form-item>
          <el-form-item label="公司地址">
            <el-input :readonly="!isRoot" type="textarea" rows="5" v-model="companyInfo.address" placeholder="请输入公司地址"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button v-if="isRoot" @click="saveCompany" size="mini">保存设置</el-button>
          </el-form-item>
        </el-form>
      </el-tab-pane>
      <el-tab-pane v-if="isRoot" label="七牛云存储配置" name="three">
        <el-form style="width:500px" ref="form" label-width="100px">
          <el-divider content-position="left">请不要随意修改该选项，可能会导致客户端上传不了文件或图片</el-divider>
          <el-form-item label="Bucket">
            <el-input v-model="qiniuSecret.bucket" placeholder="请输入bucket"></el-input>
          </el-form-item>
          <el-form-item label="accessKey">
            <el-input v-model="qiniuSecret.access_key" placeholder="请输入accessKey"  show-password></el-input>
          </el-form-item>
          <el-form-item label="secretKey">
            <el-input v-model="qiniuSecret.secret_key" placeholder="请输入secretKey"  show-password></el-input>
          </el-form-item>
          <el-form-item label="Host">
            <el-input v-model="qiniuSecret.host" placeholder="请输入host"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button @click="saveQiniu" size="mini">保存设置</el-button>
          </el-form-item>
        </el-form>
      </el-tab-pane>
      <el-tab-pane label="客户端平台" name="fives">
        <el-divider content-position="left">通过该配置，对接的平台，机器人，知识库匹配等 (系统默认项不可修改)</el-divider>
        <el-table :data="$store.getters.platformConfig" style="width: 100%">
          <el-table-column prop="id" label="#ID" width="80"></el-table-column>
          <el-table-column prop="title" label="名称" align="center">
            <template slot-scope="scope">
              <el-tag type="danger" v-if="scope.row.system == 1">{{scope.row.title}}</el-tag>
              <el-tag v-if="scope.row.system == 0">{{scope.row.title}}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="alias" label="别名"  align="center"></el-table-column>
          <el-table-column v-if="isRoot" label="操作" align="center">
            <template slot-scope="scope">
              <template v-if="scope.row.system == 0">
                <el-button @click="editPlatform(scope.row)" size="mini">编 辑</el-button>
                <el-button @click="deletePlatform(scope.row)" size="mini" type="danger">删 除</el-button>
              </template>
              <span  v-if="scope.row.system == 1" style="font-size: 12px;color: #999;">系统内置，不可操作</span>
            </template>
          </el-table-column>
          <el-table-column></el-table-column>
        </el-table>
        <el-button v-if="isRoot" style="margin-top:20px;" @click="createDialogFormVisible = true" size="mini">添加新平台</el-button>
      </el-tab-pane>
    </el-tabs>
    <CreatePlatformDialog :dialogFormVisible.sync="createDialogFormVisible" />
    <EditPlatformDialog :formData="editPlatformItem" :dialogFormVisible.sync="editDialogFormVisible" />
  </div>
</template>

<script>
import axios from 'axios'
import upload from '../../common/upload'
import CreatePlatformDialog from "./create_platform"
import EditPlatformDialog from "./edit_platform"
export default {
  name: "system",
  components: {
    CreatePlatformDialog,
    EditPlatformDialog,
  },
  data() {
    return {
      activeName: "first",
      systemInfo: {},
      companyInfo: {},
      isUploadingSysLogo: false,
      uploadysLogoPercent: "",
      isUploadingCompany: false,
      uploadCompanyPercent: "",
      qiniuSecret: {},
      createDialogFormVisible: false,
      editDialogFormVisible: false,
      editPlatformItem: {}
    }
  },
  computed:{
    isRoot(){
      if(this.$store.getters.adminInfo){
        return this.$store.getters.adminInfo.root == 1
      }else{
        return false
      }
      
    }
  },
  updated: function () {
    this.$nextTick(function () {
      this.systemInfo = this.$store.getters.systemInfo
      this.companyInfo = this.$store.getters.companyInfo
    })
  },
  mounted(){
    this.systemInfo = this.$store.getters.systemInfo
    this.companyInfo = this.$store.getters.companyInfo
    if(this.isRoot) this.getQiniu()
  },
  methods: {
    onSubmit() {
      this.$confirm("您确定要保存修改后的配置吗?", "温馨提示！", {
        confirmButtonText: "保存",
        cancelButtonText: "取消",
        center: true,
        type: "warning"
      });
    },
    //  系统logo上传
    systemLogoUpload(file) {
      var fileData = file.target.files[0];
       upload({
         file: fileData,
         progress: (percent) => {
            this.isUploadingSysLogo = true;
            this.uploadysLogoPercent = percent + "%";
         },
         success: (url) => {
            this.isUploadingSysLogo = false;
            this.uploadysLogoPercent = "";
            this.$message.success("上传成功");
            var imgUrl = this.$store.getters.uploadToken.host + "/" + url;
            this.systemInfo.logo = imgUrl;
         },
         error: (err)=>{
          this.isUploadingSysLogo = false;
          this.uploadysLogoPercent = "";
          this.$message.error(err.message);
         }
       });

    },
    // 保存系统配置
    saveSystem(){
      this.$confirm("您确定要保存修改后的系统配置吗?", "温馨提示！", {
        confirmButtonText: "保存",
        cancelButtonText: "取消",
        center: true,
        type: "warning"
      }).then(()=>{
        axios
        .put("/system", this.systemInfo)
        .then(response => {
            this.$store.commit('onChangeSystemInfo', response.data.data)
            this.$message.success("保存成功");
            this.$store.dispatch('ON_GET_SYSTEM')
            this.$store.dispatch('ON_GET_UPLOADS_CONFIG')
        })
        .catch(error => {
          this.$message.error(error.response.data.message);
        });
      })
    },
    // 公司logo上传
    companyLogoUpload(file) {

       var fileData = file.target.files[0];
       upload({
         file: fileData,
         progress: (percent) => {
            this.isUploadingCompany = true;
            this.uploadCompanyPercent = percent + "%";
         },
         success: (url) => {
            this.isUploadingCompany = false;
          this.uploadCompanyPercent = "";
          this.$message.success("上传成功");
          var imgUrl = this.$store.getters.uploadToken.host + "/" + url;
          this.companyInfo.logo = imgUrl;
         },
         error: (err)=>{
          this.isUploadingCompany = false;
          this.uploadCompanyPercent = "";
          this.$message.error(err.message);
         }
       });

       
    },
    // 保存公司配置
    saveCompany(){
      this.$confirm("您确定要保存修改后的公司信息吗?", "温馨提示！", {
        confirmButtonText: "保存",
        cancelButtonText: "取消",
        center: true,
        type: "warning"
      }).then(()=>{
        axios
        .put("/company", this.companyInfo)
        .then(response => {
            this.$store.commit('onChangeCompanyInfo', response.data.data)
            this.$message.success("保存成功");
        })
        .catch(error => {
          this.$message.error(error.response.data.message);
        });
      })
    },
    // 获取七牛配置
    getQiniu(){
      axios.get('/qiniu')
      .then(response => {
          this.qiniuSecret = response.data.data
      })
      .catch(error => {
        this.$message.error(error.response.data.message)
      });
    },
    // 保存七牛配置
    saveQiniu(){
      this.$confirm("您确定要保存修改后的七牛配置信息吗?如配置信息错误会导致客户端无法上传图片文件", "警告！", {
        confirmButtonText: "保存",
        cancelButtonText: "取消",
        center: true,
        type: "warning"
      }).then(()=>{
        axios
        .put("/qiniu", this.qiniuSecret)
        .then(response => {
            console.log(response.data.data)
            this.$message.success("保存成功");
        })
        .catch(error => {
          this.$message.error(error.response.data.message);
        });
      })
    },
    // 删除平台
    deletePlatform(item){
       console.log(item)
      this.$confirm('您确定要删除该平台配置吗? 删除后不可恢复！', '温馨提示！', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        center: true,
        type: 'warning'
      }).then(() => {
      
        axios.delete('/platform/' + item.id)
        .then(response => {
            console.log(response.data)
            this.$message.success("删除成功")
            this.$store.dispatch('ON_GET_PLATFORM_CONFIG')
        })
        .catch(error => {
          this.$message.error(error.response.data.message)
        });
      })
    },
    // 编辑平台
    editPlatform(item){
      this.editPlatformItem = item
      this.editDialogFormVisible = true
    },
  }
};
</script>
<style lang="stylus" scoped>
.mini-im-head {
  height: 60px;
  display: flex;
  align-items: center;
  font-size: 20px;
  justify-content: space-between;
  color: #666;

  i {
    margin-right: 5px;
  }
}

.mini-im-file-button {
  width: 180px;
  position: relative;
  overflow: hidden;
  // background-color #f3f3f3
  border-radius 3px
  padding 5px
  box-shadow 1px 1px 7px 0px #ccc
  input {
    width: 180px;
    font-size: 100px;
    position: absolute;
    top: 0px;
    left: 0px;
    opacity 0
    cursor: pointer;
    opacity 0
  }
  img{
    width  100%
    display block
  }

  cursor: pointer;

  .mini-im-file-percent {
    position: absolute;
    top: 0px;
    left: 0px;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: rgba(0, 0, 0, 0.5);
    color: #fff;
    font-size: 12px;
  }
}
</style>
