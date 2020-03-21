const axios = require('axios')
export default {
  ON_CHANGE_CAR_LIST(context, params) {
    context.commit('onChangeCarList', params)
  },
}