'use strict'

angular.module('movistarApp')
  .directive 'sgkCommentButton', ($rootScope, $timeout, $compile, $http, Solicitude, CommentPermissions) ->
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

      Solicitude.show scope._solicitude, (err, solicitude) -> 
        if !err
          _solicitude = solicitude

          if scope.type is 'Solicitude.pm' and _solicitude.applicant?._id?
            scope.to = _solicitude.applicant._id

          if scope.type is 'Solicitude.internal' and _solicitude.responsible?._id? and _solicitude.editor?._id?
            scope.to = _solicitude.responsible._id if $rootScope.currentUser.role is 'EDITOR'
            scope.to = _solicitude.editor._id if ['ADMIN', 'ROOT', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role) > -1

          if scope.type is 'Solicitude.provider' and _solicitude.provider?._id? and _solicitude.responsible?._id?
            scope.to = _solicitude.provider._id if $rootScope.currentUser.role is 'CONTENT_MANAGER'
            scope.to = _solicitude.responsible._id if ['ADMIN', 'ROOT', 'PROVIDER'].indexOf($rootScope.currentUser.role) > -1

          if !CommentPermissions.send(scope.type, $rootScope.currentUser.role)
            element.remove()

          if !CommentPermissions.send(scope.type, $rootScope.currentUser.role) and scope.type is 'Solicitude.pm' and $rootScope.currentUser.role is 'CLIENT'
            $http.get("/directives/solicitude/comment_form").success (data) =>
              $el = angular.element data
              angular.element('#form-comment .comments').after($el)
              $el.find('.close').remove()
              $compile($el.contents())(scope)
              # $timeout () ->
              #   angular.element('.overflow').mCustomScrollbar 'update'
              # , 100

          if !CommentPermissions.send(scope.type, $rootScope.currentUser.role) and scope.type is 'Solicitude.provider' and $rootScope.currentUser.role is 'PROVIDER'
            $http.get("/directives/solicitude/comment_form").success (data) =>
              $el = angular.element data
              angular.element('#form-comment .comments').after($el)
              $el.find('.close').remove()
              $compile($el.contents())(scope)
              # $timeout () ->
              #   angular.element('.overflow').mCustomScrollbar 'update'
              # , 100
          
          # if scope.type is 'Solicitude.pm' and ['ROOT', 'ADMIN', 'EDITOR'].indexOf($rootScope.currentUser.role) < 0 or scope.to is null
          #   element.remove()

          # if scope.type is 'Solicitude.internal' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role) < 0 or scope.to is null
          #   element.remove()

          # if scope.type is 'Solicitude.provider' and ['ROOT', 'ADMIN', 'PROVIDER', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role) < 0 or scope.to is null
          #   element.remove()

          element.on 'click', (e) ->
            e.preventDefault()
            
            $http.get("/directives/solicitude/comment_form").success (data) =>
              $el = angular.element data
              element.parents('.comments').after($el)

              $el.on 'click', '.close', (e) ->
                $el.remove()
                # angular.element('.overflow').mCustomScrollbar 'update'

              # angular.element('.overflow').mCustomScrollbar 'update'

              $compile($el.contents())(scope)

              scope.$on 'close', (e) ->
                angular.element('#comment-form').remove()
                angular.element('.overflow').mCustomScrollbar 'update'

            return false



