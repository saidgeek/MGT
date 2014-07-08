'use strict'

angular.module('movistarApp')
  .controller 'SolicitudeCtrl', ($scope, Solicitude, $rootScope, SolicitudeParams, PriorityData, Category, User, Comment, SegmentsData, SectionsData, _solicitude, _comments, $state) ->
    $scope.solicitude = _solicitude
    $scope.comments = _comments
    $scope.comment = {}
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

    $scope.addComment = (form, type, to, solicitude) ->
      if form.$valid
        console.log '$scope.comment:', $scope.comment
        Comment.create type, solicitude, to, $scope.comment, (err, comment) ->
          if !err
            $scope.atts = []
            # $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id
            $scope.solicitude.comments.push comment
            # if $scope.solicitude._attachments?
            #   for att in $scope.solicitude._attachments 
            #     $scope.solicitude.attachments.push att
            $rootScope.$emit 'clean_list_uploader'
            $scope.comment = {}


        # Solicitude.addComments $scope.solicitude._id, $scope.solicitude.comment, ($scope.solicitude._attachments || {} ), (err, solicitude) ->
        #   if err
        #     $scope.errors = err
        #   else
        #     $scope.atts = []
        #     # $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id
        #     $scope.solicitude.comments = solicitude.comments
        #     if $scope.solicitude._attachments?
        #       for att in $scope.solicitude._attachments 
        #         $scope.solicitude.attachments.push att
        #     $scope.solicitude._attachments = {}
        #     $rootScope.$emit 'clean_list_uploader'
        #     $scope.solicitude.comment = ''

    $scope.addTask = (form) ->
      if form.$valid
        Solicitude.addTasks $scope.solicitude._id, $scope.solicitude._tasks, ($scope.solicitude._attachments_tasks || {} ), (err, solicitude) ->
          if err
            $scope.errors = err
          else
            $scope.atts = []
            $scope.solicitude.tasks = solicitude.tasks
            if $scope.solicitude._attachments?
              for att in $scope.solicitude._attachments_tasks 
                $scope.solicitude.attachments.push att
            $scope.solicitude._attachments_tasks = {}
            $rootScope.$emit 'clean_list_uploader'
            $scope.solicitude._tasks = ''

    $scope.toggleCheck = (task) =>
      Solicitude.toggleCheckTasks $scope.solicitude._id, task, (err, solicitude) ->
        if err
          $scope.errors = err
        else
          $scope.solicitude.tasks = solicitude.tasks

    $scope.nextState = (state) =>
      $scope.solicitude.nextState = state

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
