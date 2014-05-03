'use strict'

angular.module('filepicker', ['ngResource'])
  .factory 'ConfigFiles', ($rootScope, $resource) ->
    if $rootScope.currentUser
      _clientToken = $rootScope.currentUser.access.clientToken
      _accessToken = $rootScope.currentUser.access.accessToken
      $resource '/api/v1/filepicker/key',
        clientToken: _clientToken
        accessToken: _accessToken
      ,
        config:
          method: 'GET'

  .directive 'filepickerRun', ($window, ConfigFiles, $rootScope) ->
    restrict: 'A'
    compile: (element, attrs) ->
      if $rootScope.currentUser?
        config = ConfigFiles.config (data) ->
          script = '<script type="text/javascript">
      (function(a){if(window.filepicker){return}var b=a.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===a.location.protocol?"https:":"http:")+"//api.filepicker.io/v1/filepicker.js";var c=a.getElementsByTagName("script")[0];c.parentNode.insertBefore(b,c);var d={};d._queue=[];var e="pick,pickMultiple,pickAndStore,read,write,writeUrl,export,convert,store,storeUrl,remove,stat,setKey,constructWidget,makeDropPane".split(",");var f=function(a,b){return function(){b.push([a,arguments])}};for(var g=0;g<e.length;g++){d[e[g]]=f(e[g],d._queue)}window.filepicker=d})(document);
      </script>'

          element.append script
          $window.filepicker.setKey(data.key)

  .factory 'filepickerApi', ($timeout) ->

    _store = (input, cb) ->
      if input
        filepicker.store input, (InkBlob) ->
            cb null, InkBlob
        , (FPError) ->
            cb FPError
        , (proccess) =>
          angular.element('[data-type="modal"] #loader').html "#{proccess}%"

    _storeConvert = (input, opts, cb) ->
      _store input, (err, resStore) ->
        _convert resStore, opts, (err, resConvert) ->
          _remove resStore, () ->
            cb null, resConvert

    # { width: 80, height: 80, fit: 'scale', align: 'face' }
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

    pause = (ms) ->
      $timeout () ->
        return false
      , ms

    _getDimension = (inkBlob, cb) ->
      filepicker.stat inkBlob, {width: true, height: true}, (metadata) ->
        cb metadata

    _thumbnails = (inkBlob, cb) ->
      thumbs = {}
      _convert inkBlob, { width: 200, height: 200, fit: 'scale', align: 'face' }, (err, res1) ->
        return false if err
        _convert inkBlob, { width: 32, height: 32, fit: 'scale', align: 'face' }, (err, res2) ->
          return false if err
          _getDimension res1, (d1) ->
            thumbs["_#{d1.width}x#{d1.height}_"] = res1.url
            _getDimension res2, (d2) ->
              thumbs["_#{d2.width}x#{d2.height}_"] = res2.url
              cb thumbs

    _storeAndThumbnail = (opts, cb) ->
      _store opts.data, (err, inkBlob) ->
        return false if err
        _filenameArray = inkBlob.filename.split('.')
        _upload =
          url: inkBlob.url
          name: inkBlob.filename
          ext: _filenameArray[(_filenameArray.length - 1)]
          thumbnails: {}

        if /\.(jpg|jpeg|tiff|png)$/i.test inkBlob.filename
          _thumbnails inkBlob, (res) ->
            _upload.thumbnails = res
            cb null, { hash: opts.id, data: _upload }
        else
          cb null, { hash: opts.id, data: _upload }

    return {
      store: (input, cb) ->
        _store(input, cb)
      storeConvert: (input, opts, cb) ->
        _storeConvert(input, opts, cb)
      storeAndThumbnail: (opts, cb) ->
        _storeAndThumbnail(opts, cb)
    }
