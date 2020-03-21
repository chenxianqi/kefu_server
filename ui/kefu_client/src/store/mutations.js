export default {
    updateState(state, newObj){
      for (var i in newObj) {
        if(newObj[i] == undefined) continue
        state[i] = newObj[i]
      }
    }
}