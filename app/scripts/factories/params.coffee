"use strict"

angular.module("movistarApp")
  .factory "UserParams", ->
    state = false
    _change = (b) ->
      state = b
    return {
      change: (b) ->
        _change(b)
      closeModal: state
    }