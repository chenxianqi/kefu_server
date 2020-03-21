export default {
    updateState(state, newObj){
      var oldState = state
      for (var i in newObj) {
        if(newObj[i] == undefined) continue
        oldState[i] = newObj[i]
      }

      state = oldState

    }
}