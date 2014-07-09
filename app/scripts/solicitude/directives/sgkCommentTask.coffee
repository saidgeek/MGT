'use strict'

angular.module('movistarApp')
  .directive 'sgkCommentTask', ($rootScope, $timeout, Comment, IO) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/solicitude/task_comments'
    controller: ($scope, Comment) ->
      $scope.task_comment = {}

      $scope.addTaskComment = (form, solicitude_id, task_id) ->
        if form.$valid
          Comment.task $scope.solicitude_id, $scope.id, $scope.task_comment, (err, comment) ->
            if !err
              Comment.show comment._id, (err, comment) ->
                if !err
                  $scope.task_comments.push comment

    link: (scope, element, attrs) ->
      scope.task_comments = null
      scope.id = attrs.sgkCommentTask
      scope.solicitude_id = attrs.sgkCommentTaskSolicitude

      # IO.on 'task.new.comment', (data) ->
      #   query = "#task_#{ data.task }"
      #   if angular.element(query).length > 0 
      #     Comment.show data.comment, (err, comment) ->
      #       if !err
      #         scope.task_comments.push comment

      Comment.index_task scope.id, (err, comments) ->
        if !err
          scope.task_comments = comments