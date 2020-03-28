
<template>
  <div class="workorder-view" v-show="value">
    <div class="mask" @dblclick="close"></div>
    <div class="content-box">
      <el-row type="flex" class="title">
        <span>
          <i class="el-icon-tickets"></i> 分类设置
        </span>
        <div>
          <el-button @click="add" size="mini" type="primary">添加分类</el-button>
        </div>
      </el-row>
      <span class="close" @click="close">
        <i class="el-icon-close"></i>
      </span>
      <div class="content">
        <div class="scroll">
          <ul class="list">
            <template v-for="item in showWorkorderTypes">
              <li :key="item.id">
                <el-row type="flex" algin="middle">
                 <div>
                    <i class="el-icon-tickets"></i>
                 </div>
                  <span>{{item.title}}</span>
                  <div class="update" @click="update(item)">
                    <i class="el-icon-edit-outline"></i>
                  </div>
                  <div class="del" @click="del(item)">
                    <i class="el-icon-close"></i>
                  </div>
                </el-row>
              </li>
            </template>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
export default {
  name: "workorder-view",
  data() {
    return {
      isSubmit: false,
      types: null
    };
  },
  props: {
    value: {
      default: false,
      type: Boolean
    },
    workorderTypes: Array
  },
  created() {
    this.getWorkorderTypes();
  },
  computed: {
    showWorkorderTypes() {
      return (
        this.types ||
        this.workorderTypes.slice(1, this.workorderTypes.length - 2)
      );
    },
    isShowAside() {
      return this.$store.state.isShowAside;
    }
  },
  methods: {
    // 按钮操作
    close() {
      this.$emit("input", false);
    },
    // 获取类型数据
    getWorkorderTypes() {
      axios
        .get("/workorder/types")
        .then(response => {
          this.types = response.data.data;
        })
        .catch(error => {
          this.$message.error(error.response.data.message);
        });
    },
    add() {
      this.$prompt("请输入分类名称！", "添加分类", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        inputPattern: /\S/,
        inputErrorMessage: "分类名称不能为空~"
      }).then(({ value }) => {
        axios
          .post("/workorder/type/", { title: value })
          .then(() => {
            this.getWorkorderTypes();
          })
          .catch(error => {
            this.$message.error(error.response.data.message);
          });
      });
    },
    del(type) {
      this.$confirm("您确定删除 "+type.title+" 该分类吗?", "温馨提示！", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        axios
          .delete("/workorder/type/" + type.id)
          .then(() => {
            this.getWorkorderTypes()
          })
          .catch(error => {
            this.$message.error(error.response.data.message);
          });
      });
    },
    update(type) {
      this.$prompt("", "分类修改", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        inputPlaceholder: "请输入新分类名称~",
        inputPattern: /\S/,
        inputValue: type.title,
        inputErrorMessage: "分类名称不能为空~"
      }).then(({ value }) => {
        if(value == type.title) return
        axios
          .put("/workorder/type/", { id:type.id, title: value })
          .then(() => {
            this.getWorkorderTypes();
          })
          .catch(error => {
            this.$message.error(error.response.data.message);
          });
      });
    }
  },
  watch: {}
};
</script>
<style scoped lang="stylus">
.workorder-view {
  width: 100vw;
  height: 100vh;
  position: fixed;
  right: 0;
  top: 0px;
  left: 0px;
  background-color: rgba(0, 0, 0, 0.8);
  z-index: 9;

  .mask {
    width: 100%;
    height: 100%;
  }

  .content-box {
    width: 400px;
    height: 100%;
    background-color: #fff;
    position: fixed;
    right: 0px;
    margin: 0 auto;
    top: 0px;
    overflow: hidden;
    padding-top: 40px;
    box-sizing: border-box;
    padding-bottom: 30px;

    .content {
      height: 100%;
      overflow: hidden;
      overflow-y: auto;
      margin-top: 20px;
    }

    .list {
      padding: 0 10px;
      display: block;

      li {
        height: 50px;
        line-height: 50px;
        border-bottom: 1px solid #ddd;
        position: relative;

        .del, .update {
          position: absolute;
          display: none;
          right: 0px;
          top: 0;
          bottom: 0;
          margin: auto 0;
          width: 25px;
          height: 30px;
          text-align: center;
          line-height: 30px;
          cursor: pointer;

          i {
            color: #ccc;
          }
        }

        &:hover {
          .del, .update {
            display: block;
          }
        }

        .update {
          right: 30px;
        }

        span {
          margin-left: 10px;
          color: #333;
          font-size: 14px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          padding-right 50px
        }
      }
    }

    .title {
      width: 100%;
      height: 60px;
      border-bottom: 1px solid #ddd;
      position: absolute;
      top: 0;
      left: 0;
      padding: 0 10px;
      background-color: #fff;
      box-sizing: border-box;

      &>span {
        width: 270px;
      }

      align-content: center;
      align-items: center;
    }

    .close {
      position: absolute;
      top: 15px;
      right: 5px;
      font-size: 25px;
      color: #ccc;
      cursor: pointer;
    }
  }
}
</style>

