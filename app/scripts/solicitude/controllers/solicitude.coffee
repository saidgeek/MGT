'use strict'

angular.module('movistarApp')
  .controller 'SolicitudeCtrl', ($scope, Solicitude, $rootScope, PriorityData, Category, User, Comment, Task, SegmentsData, SectionsData, _solicitude, _comments, _attachments, _tasks, $state, IO) ->
    $scope.solicitude = _solicitude
    $scope.comments = []

    angular.element.each _comments, (index, comment) ->
      console.log 'comment.to.role:', comment.to.role
      if ['ADMIN', 'ROOT'].indexOf($rootScope.currentUser.role) > -1 || $rootScope.currentUser.role is comment.to.role
        $scope.comments.push comment

    $scope.attachments = _attachments
    $scope.comment = {}
    $scope.tasks = _tasks
    $scope.task = {}

    $scope.error = {}
    $scope.atts = []
    $scope.role = $rootScope.currentUser.role
    $scope.rejectedState = ''

    $scope.segment = null

    $scope.tabs = ''
    $scope.options = ''
    $scope.section = ''
    $scope.tags = []

    $scope.categories = null
    $scope.contentManagers = null
    $scope.provider = null

    $scope.priorities = PriorityData.getArray()
    $scope.segments = SegmentsData.getArray()
    $scope.sections = SectionsData.getArray()

    Category.index (err, categories) ->
      if err
        $scope.errors = err
      else
        $scope.categories = categories

    User.index 'CONTENT_MANAGER', (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.contentManagers = users

    User.index 'PROVIDER', (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.provider = users

    IO.on 'solicitude.new.comment', (data) ->
      if data.solicitude is $scope.solicitude._id
        Comment.show data.comment, (err, comment) ->
          if !err
            if ['ADMIN', 'ROOT'].indexOf($rootScope.currentUser.role) > -1 || $rootScope.currentUser.role is comment.to.role
              $scope.comments.push comment
            return false

    IO.on 'solicitude.new.task', (data) ->
      if data.solicitude is $scope.solicitude._id
        Task.show data.task, (err, task) ->
          if !err
              $scope.tasks.push task
            return false

    # $scope.showOption = (option) ->
    #   if option is 'PAUSED'
    #     ~['ROOT', 'ADMIN', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role)

    $scope.$watch '[solicitude.ticket.segments, solicitude.ticket.sections]', (v) =>
      if v?
        if $scope.submitted
          $scope.validateForm($scope.form)
    , true

    $scope.validateTags = () ->
      $scope.tags.length > 0

    $scope.validateSections = (form) ->
      $scope.solicitude.ticket.segments.length < 1

    $scope.validateSegments = (form) ->
      $scope.solicitude.ticket.sections.length < 1

    $scope.validateForm = (form) =>
      if $scope.form?
        $scope.error['segments'] = $scope.validateSections(form)
        $scope.error['sections'] = $scope.validateSegments(form)
        if $scope.error['sections'] || $scope.error['sections']
          form.$valid = false
        else
          form.$valid = true
        $scope.submitted = true

    $scope.addTask = (form) ->
      if form.$valid
        console.log 'addTask:', $scope.solicitude._id, $scope.task
        Task.create $scope.solicitude._id, $scope.task, (err, task) ->
          if !err
            $scope.atts = []
            $rootScope.$emit 'clean_list_uploader'
            $scope.task = {}

    $scope.toggleCheck = (id) =>
      Task.toggle_completed id, (err) ->
        if !err
          console.log 'cambio'

    $scope.nextState = (state) =>
      $scope.solicitude.nextState = state

    $scope.edit_priority = () ->
      ['ROOT', 'ADMIN', 'EDITOR'].indexOf($rootScope.currentUser.role) > -1

    $scope.update_priority = () ->
      console.log '$scope.solicitude.priority:', $scope.solicitude.priority
      Solicitude.update $scope.solicitude._id, $scope.solicitude, (err, solicitude) ->
        if !err
          console.log 'prioridad cambiada'

    $scope.update = (form) =>
      if form.$valid
        Solicitude.update $scope.solicitude._id, $scope.solicitude, (err, solicitude) ->
          if err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al actualizar la solicitud.
                       """
          else
            # $rootScope.$emit 'reloadSolicitude', solicitude
            $rootScope.$emit 'reloadStateFilter'
            $rootScope.$emit 'reloadPriorityFilter'
            $scope.submitted = false
            $scope.form = null
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se actualizo correctamente.
                       """
            $state.transitionTo 'solicitudes'
