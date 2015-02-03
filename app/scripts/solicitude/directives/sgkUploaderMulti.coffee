'use strict'

angular.module('movistarApp')
  .directive 'sgkUploaderMulti', (filepickerApi, $timeout, $rootScope) ->
    restrict: 'A'
    scope: {}
    require: 'ngModel'
    templateUrl: 'directives/uploader_multi'
    controller: ($scope, $rootScope) ->
      $scope.attachments = []
      $scope.list = []

      $scope.remove = (attachment) ->
        index = $scope.attachments.indexOf(attachment)
        $scope.attachments.splice index, 1
        $scope.list.splice index, 1
        #$scope.$emit 'remove', attachment.id
        angular.element('input[type="file"]').val(null);

      addToList = (id, name) =>
        if name.length > 100
          name = "#{ name.substr(0,10) }...#{ name.substr((name.length - 10), name.length) }"
        $scope.$apply () ->
          $scope.list.push { id: id, name: name }

      $rootScope.$on 'clean_list_uploader', (e) ->
        $scope.list = []

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
              $element.find('.overflow').css 'display', 'block'
              $element.find('.overflow').mCustomScrollbar "update"
            return false

      $scope.$on 'remove', (e, id) ->
        query = "ul li##{ id }"
        $element
          .find(query).remove()

      $scope.$watch 'attachments', (attachments) =>
        if attachments.length > 0
          _att = []
          for att in attachments
            query = "ul li##{ att.hash } img"
            $element
              .find(query).attr 'src', (att?.data?.thumbnails?._32x32_ || '')
            _att.push att.data

            query = "ul li##{ att.hash } a"
            $element
              .find(query).css 'display', 'block'

          ngModel.$setViewValue _att
      , true


      $overflow = $element.find('.overflow')
      if $overflow.find('.mCustomScrollBox').length is 0
        $overflow.mCustomScrollbar
          scrollButtons:
              enable:false
      $overflow.mCustomScrollbar "update"
      $overflow.mCustomScrollbar "scrollTo", "top"

      $_triggers()
