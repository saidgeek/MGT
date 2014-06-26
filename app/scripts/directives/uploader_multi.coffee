'use strict'

angular.module('movistarApp')
  .directive 'sgkUploaderMulti', (filepickerApi, $timeout) ->
    restrict: 'A'
    scope: {}
    require: 'ngModel'
    templateUrl: 'directives/uploader_multi'
    controller: ($scope, $rootScope) ->
      $scope.attachments = []
      $scope.list = []

      addToList = (id, name) =>
        if name.length > 100
          name = "#{ name.substr(0,10) }...#{ name.substr((name.length - 10), name.length) }"
        $scope.$apply () -> 
          $scope.list.push { id: id, name: name }

      $scope.upload = (id, file) =>
        options =
          id: id
          data: file
          referer:
            id: $scope.refererId
            name: $scope.referer
        addToList(id, file.name)
        filepickerApi.storeAndThumbnail options, (err, res) ->
          $scope.$apply () -> 
            $scope.attachments.push res
  
    link: ($scope, $element, $attrs, ngModel) ->
      $scope.referer = $attrs.sgkType
      $scope.refererId = if $attrs.sgkUploaderMulti is '' then null else $attrs.sgkUploaderMulti
      _posicion = $attrs.sgkPosition || 'top'
    
      # ngModel.$setViewValue []

      html = null
      if _posicion is 'buttom'
        html = $element.find('ul')
        $element.find('ul').remove()
        $element.append(html)

      $_triggers = () =>  
        $element
          .find('input[type="file"]').on 'change', (e) =>
            for file in angular.element(e.target)[0].files
              MD5 = new Hashes.MD5
              _id = MD5.hex file.lastModifiedDate+Date.now()
              $scope.upload(_id, file)
            return false

      $scope.$watch 'attachments', (attachments) =>
        if attachments.length > 0
          _att = []
          for att in attachments
            query = "ul li##{ att.hash } img"
            $element
              .find(query).attr 'src', (att?.data?.thumbnails?._32x32_ || '')
            _att.push att.data

          ngModel.$setViewValue _att
      , true

      $_triggers()