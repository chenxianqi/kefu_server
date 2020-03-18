<template>
  <div>
    <el-row :gutter="20">
      <el-col :span="2">
        <el-form label-width="120px">
          <el-form-item label="按日期：">
          </el-form-item>
        </el-form>
      </el-col>
      <el-col :span="6.5">
        <el-date-picker
          @change="changeDate"
          v-model="selectDate"
          type="daterange"
          align="right"
          :editable="false"
          :clearable="false"
          unlink-panels
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-col>
      <el-col :span="5">
        <el-select @change="changeSelectd" v-model="selectDateValue" placeholder="快捷选择日期">
          <el-option
            v-for="item in optionsDate"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-col>
      <el-col :span="6.5">
        <div class="online-count">
          当天累积访问用户<span>{{todayStatisticalTableDataCount}}</span> 当前在线用户<span>{{onlines}}</span>
        </div>
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="16">
        <div class="mini-im-home-title">各渠道<span style="color: #f44336">{{optionsDate[selectDateValue].label}}</span>服务量统计</div>
        <ve-line :data="statisticalChartData"></ve-line>
      </el-col>
      <el-col :span="8">
        <div class="mini-im-home-title">客服<span style="color: #f44336">{{optionsDate[selectDateValue].label}}</span>接入量统计</div>
        <ve-funnel :data="membersChartData"></ve-funnel>
      </el-col>
    </el-row>
    <div>
      <div class="mini-im-home-title" style="padding-bottom: 10px;">各渠道<span style="color: #f44336;">当天独立用户</span>访问量</div>
      <el-table
        :data="todayStatisticalTableData"
        style="width: 100%">
        <el-table-column
          prop="platform"
          label="#序号(ID)"
          width="180">
        </el-table-column>
        <el-table-column
          prop="title"
          label="平台名称"
          width="250">
        </el-table-column>
        <el-table-column
          prop="count"
          align="center"
          width="180"
          label="当天访问人次">
        </el-table-column>
        <el-table-column
          label="">
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import VeLine from "v-charts/lib/line.common";
import VeFunnel from "v-charts/lib/funnel.common";
import axios from 'axios'
var moment = require('moment');
export default {
  name: "home",
  components: { VeLine, VeFunnel },
  data() {
    return {
      todayStatisticalTableData: [],
      selectDate: [],
      optionsDate: [
        {
          value: 0,
          label: '今天'
        },
        {
          value: 1,
          label: '昨天'
        },
        {
          value: 2,
          label: '近7天'
        },
        {
          value: 3,
          label: '近30天'
        },
        {
          value: 4,
          label: '本月'
        },
        {
          value: 5,
          label: '上月'
        },
      ],
      selectDateValue: 2,
      statisticalChartData: {
        columns: [],
        rows: []
      },
      membersChartData: {
        columns: ["状态", "数值"],
        rows: []
      },
      onlines: 0
    };
  },
  created(){
    this.selectDate = this.getDate(2)
    this.getStatistical()
    this.getTodayStatistical()
    this.getOnlines()
  },
  computed:{
    todayStatisticalTableDataCount(){
      var count = 0
      var self = this
      self.todayStatisticalTableData.map((item) => {
        count = count + parseInt(item.count)
      })
      if(self.todayStatisticalTableData.length > 0){
        var totalCount = self.todayStatisticalTableData[0].count
        self.todayStatisticalTableData[0].count = parseInt(totalCount) + count
      }
      return count
    }
  },
  methods: {
    // 获取数据
    getStatistical(){
      axios.post('/home/statistical', {
        "date_start": moment(this.selectDate[0]).format("YYYY-MM-DD"),
        "date_end": moment(this.selectDate[1]).format("YYYY-MM-DD")
      })
      .then(response => {
          const {members, statistical} = response.data.data
          // 处理客服
          var membersRows = []
          for(let i = 0; i<members.length; i++){
            membersRows.push({
              "状态": members[i].nickname || members[i].username,
              "数值": members[i].count
            })
          }
          this.membersChartData.rows = membersRows
          // 处理statisticalChartData
          var statisticalChartDataColumns = ["日期"]
          var statisticalChartDataRows = []
          for(let i = 0; i< statistical[0]['list'].length; i++){
            statisticalChartDataColumns.push(statistical[0]['list'][i].title)
          }
          this.statisticalChartData.columns = statisticalChartDataColumns
          for(let i = 0; i< statistical.length; i++){
            var jsonData = {}
            jsonData["日期"] = statistical[i].date
            for(let b = 0;b < statistical[i].list.length; b++){
              var item = statistical[i].list[b]
              jsonData[item["title"]] = item["count"]
            }
            statisticalChartDataRows.push(jsonData)
          }
          this.statisticalChartData.rows = statisticalChartDataRows
      })
      .catch(error => {
        this.$message.error(error.response.data.message)
      });
    },
    // 获取今天访问数据
    getTodayStatistical(){
      axios.post('/home/today_statistical', {
        "date_start": moment(new Date()).format("YYYY-MM-DD"),
        "date_end": moment(new Date()).format("YYYY-MM-DD")
      })
      .then(response => {
        this.todayStatisticalTableData = response.data.data
      })
      .catch(error => {
        this.$message.error(error.response.data.message)
      });
    },
    // 快捷日期变化
    changeSelectd(){
      this.selectDate = this.getDate(this.selectDateValue)
      this.changeDate()
    },
    // 获取时间
    getDate(index){
      var start,end
      switch(index){
        case 0:
          start = new Date()
          end = new Date()
          break
        case 1:
           var yesterday =  moment().dayOfYear(moment().dayOfYear() -1);
           end = yesterday;
           start = yesterday;
           break
        case 2:
          end = new Date();
          start = moment().dayOfYear(moment().dayOfYear() -6);
          break
        case 3:
           end = new Date();
           start = moment().dayOfYear(moment().dayOfYear() -29);
          break
        case 4:
           end = new Date();
           start = moment().dayOfYear(moment().dayOfYear() - new Date().getDate() + 1);
          break
        case 5:
           end = moment(moment().subtract(1, 'months').startOf('month')).endOf('month')
           start = moment().subtract(1, 'months').startOf('month')
          break
      }
      return [start, end]
    },
    // 时间变更
    changeDate(){
      this.getStatistical()
    },
    // 获取在线用户数
    getOnlines(){
      axios.get('/user/onlines')
      .then(response => {
        this.onlines = response.data.data
      })
      .catch(error => {
        this.$message.error(error.response.data.message)
      });
    }
  }

};
</script>
<style lang="stylus" scoped>
.mini-im-home-title {
  text-align: center;
  font-size: 18px;
  color: #666;
  padding: 15px 0 50px;
}

.mini-im-home-copyright {
  text-align: center;
  color: #666;
  font-size: 14px;
  padding-top: 50px;
}
.online-count{
  text-align center
  color #666
  margin-top 10px
  span{
    color #8bc34a
    margin 0 5px
  }
}
</style>
