'use strict'

angular.module('filepicker', [])

  .directive 'filepickerRun', ($window) ->
    restrict: 'A'
    compile: (element, attrs) ->
      script = '<script type="text/javascript">
  (function(a){if(window.filepicker){return}var b=a.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===a.location.protocol?"https:":"http:")+"//api.filepicker.io/v1/filepicker.js";var c=a.getElementsByTagName("script")[0];c.parentNode.insertBefore(b,c);var d={};d._queue=[];var e="pick,pickMultiple,pickAndStore,read,write,writeUrl,export,convert,store,storeUrl,remove,stat,setKey,constructWidget,makeDropPane".split(",");var f=function(a,b){return function(){b.push([a,arguments])}};for(var g=0;g<e.length;g++){d[e[g]]=f(e[g],d._queue)}window.filepicker=d})(document); 
  </script>'
      element.append script
      $window.filepicker.setKey('ALYbjhKLjSKiT6sNRHw4Yz')

  .factory 'filepickerApi', ->

    _store = (input, cb) ->
      if input
        filepicker.store input, (InkBlob) ->
            cb null, InkBlob
        , (FPError) ->
            cb FPError

    _storeConvert = (input, opts, cb) ->
      _store input, (err, resStore) ->
        _convert resStore, opts, (err, resConvert) ->
          _remove resStore, () ->
            cb null, resConvert

    _convert = (inkBlob, opts, cb) ->
      filepicker.convert inkBlob, opts, (res) ->
        cb null, res
      , (err) ->
        cb err

    _remove = (inkBlob, cb) ->
      filepicker.remove inkBlob, (res) ->
        cb()
      , (err) ->
        cb err

    return {
      store: (input, cb) ->
        _store(input, cb)
      storeConvert: (input, opts, cb) ->
        _storeConvert(input, opts, cb)
    }

