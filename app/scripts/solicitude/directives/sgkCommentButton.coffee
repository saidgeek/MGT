'use strict'

angular.module('movistarApp')
  .directive 'sgkCommentButton', ($rootScope, $timeout, $compile, $http) ->
    restrict: 'A'
    scope: {}
    controller: ($scope, $rootScope, Comment) ->

      $scope.addComment = (form, type, to, solicitude) ->
        if form.$valid
          Comment.create type, solicitude, to, $scope.comment, (err, comment) ->
            if !err
              $scope.atts = []
              $rootScope.$emit 'clean_list_uploader'
              $scope.comment = {}
              $scope.$emit 'close'

    link: (scope, element, attrs) ->
      scope.comment = {}
      scope.type = attrs.sgkCommentButton
      scope._solicitude = attrs.sgkCommentSolicitude
      scope.to = null

      _solicitude = JSON.parse(scope._solicitude)
      scope._solicitude = _solicitude._id

      if scope.type is 'pm' and _solicitude.editor?._id?
        scope.to = _solicitude.editor._id

      if scope.type is 'internal' and _solicitude.responsible?._id? and _solicitude.editor?._id?
        scope.to = _solicitude.responsible._id if $rootScope.currentUser.role is 'EDITOR'
        scope.to = _solicitude.editor._id if ['ADMIN', 'ROOT', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role) > -1

      if scope.type is 'provider' and _solicitude.provider?._id? and _solicitude.responsible?._id?
        scope.to = _solicitude.provider._id if $rootScope.currentUser.role is 'CONTENT_MANAGER'
        scope.to = _solicitude.responsible._id if ['ADMIN', 'ROOT', 'PROVIDER'].indexOf($rootScope.currentUser.role) > -1
      
      if scope.type is 'pm' and ['ROOT', 'ADMIN', 'EDITOR'].indexOf($rootScope.currentUser.role) < 0 or scope.to is null
        element.remove()

      if scope.type is 'internal' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role) < 0 or scope.to is null
        element.remove()

      if scope.type is 'provider' and ['ROOT', 'ADMIN', 'PROVIDER', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role) < 0 or scope.to is null
        element.remove()

      element.on 'click', (e) ->
        e.preventDefault()
        
        $http.get("/directives/solicitude/comment_form").success (data) =>
          $el = angular.element data
          element.parents('.detalle.bkg').after($el)

          $el.on 'click', '.close', (e) ->
            $el.remove()


          angular.element('.overflow').mCustomScrollbar 'update'

          $compile($el.contents())(scope)

        return false

      scope.$on 'close', (e) ->
        angular.element('#comment-form').remove()



