'use strict'

angular.module('movistarApp')
  .controller 'SolicitudeCtrl', ($scope, $fancyModal, Solicitude, $rootScope, PriorityData, Category, User, Comment, Task, SegmentsData, SectionsData, _solicitude, _comments, _attachments, _tasks, $state, IO, CommentPermissions, $sce) ->
    $scope.solicitude = _solicitude
    $scope.comments = []
    $scope.comment_type = null
    $scope._comment = {}
    $scope.comment =
      types: []
      pm: []
      internal: []
      provider: []
      other: []

    $scope.openProfile = (type) ->
      $scope.profile = 
        email: "#{$scope.solicitude[type].email || false}"
        avatar: "#{$scope.solicitude[type].profile.avatar || false}"
        name: "#{$scope.solicitude[type].profile.firstName} #{$scope.solicitude[type].profile.lastName || false}"
        number: "#{$scope.solicitude[type].profile.phoneNumber || false}"
        cel: "#{$scope.solicitude[type].profile.celNumber || false}"
        description: "#{$scope.solicitude[type].profile.description || false}"
      $fancyModal.open
        template: """
          <div class="modal-profile">
            <img src="{{ profile.avatar }}" ng-show="profile.avatar" />
            <h3>{{ profile.name }}</h3>
            <p ng-show="profile.email">
              <i class="fa fa-envelope"></i> {{ profile.email }}
            </p>
            <p ng-show="profile.cel">
              <i class="fa fa-mobile"></i> {{ profile.cel }}
            </p>
            <p ng-show="profile.number">
              <i class="fa fa-phone"></i> {{ profile.number }}
            </p>
            <p ng-show="profile.description">
             {{ profile.description }}
            </p>
          </div>
        """
        scope: $scope

    angular.element.each _comments, (index, comment) ->
      if CommentPermissions.view(comment.type, $rootScope.currentUser.role)
        switch comment.type
          when 'Solicitude.pm'
            $scope.comment.pm.push comment
          when 'Solicitude.internal'
            $scope.comment.internal.push comment
          when 'Solicitude.provider'
            $scope.comment.provider.push comment
          else
            $scope.comment.other.push comment

    if CommentPermissions.view('Solicitude.pm', $rootScope.currentUser.role)
      _name = 'Comentarios PM'
      if $rootScope.currentUser.role is 'CLIENT'
        _name = 'Comentarios'
      $scope.comment.types.push {  id: 'pm', name: _name }
    if CommentPermissions.view('Solicitude.internal', $rootScope.currentUser.role) and $scope.solicitude.responsible?
      $scope.comment.types.push { id: 'internal', name: 'Comentarios Interno'}
    if CommentPermissions.view('Solicitude.provider', $rootScope.currentUser.role) and $scope.solicitude.provider?
      _name = 'Comentarios Proveedor'
      if $rootScope.currentUser.role is 'PROVIDER'
        _name = 'Comentarios'
      $scope.comment.types.push { id: 'provider', name: _name }

    if $state.params.type?
      $scope.comment_type = $state.params.type
      $scope.comments = $scope.comment[$scope.comment_type]
    else
      paso = true
      if CommentPermissions.view('Solicitude.pm', $rootScope.currentUser.role)
        $scope.comment_type = 'pm'
        $scope.comments = $scope.comment.pm
        paso = false
      if CommentPermissions.view('Solicitude.internal', $rootScope.currentUser.role) and $scope.solicitude.responsible? and paso
        $scope.comment_type = 'internal'
        $scope.comments = $scope.comment.internal
        paso = false
      if CommentPermissions.view('Solicitude.provider', $rootScope.currentUser.role) and $scope.solicitude.provider? and paso
        $scope.comment_type = 'provider'
        $scope.comments = $scope.comment.provider
        paso = false

    $scope.active_tab = (index, type, name) ->
      if $scope.comment_type?
        if $scope.comment_type is type
          $scope.comment_form_placeholder = name
          return true 
      else
        return true if index is 0

    $scope.attachments = _attachments
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

    $scope.tabs = ''

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


    $scope.tabs = (tab) ->
      $scope.tabs = tab

    IO.on 'solicitude.new.comment', (data) ->
      if data.solicitude is $scope.solicitude._id
        Comment.show data.comment, (err, comment) ->
          if !err
            if CommentPermissions.view(comment.type, $rootScope.currentUser.role)
              $scope.comments.unshift comment
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

    $scope.htmlTrusted = () ->
      return $sce.trustAsHtml($scope.solicitude.ticket.description)

    $scope.commentHtmlTrusted = (text) ->
      return $sce.trustAsHtml(text)

    $scope.showCommentForm = () ->
      ['COMPLETED', 'CANCELED'].indexOf($scope.solicitude.state.type) < 0

    $scope.showCompletedAlert = () ->
      $scope.solicitude.state.type is 'COMPLETED'

    $scope.showCanceledAlert = () ->
      $scope.solicitude.state.type is 'CANCELED'

    $scope.validateTags = () ->
      $scope.tags.length > 0

    $scope.validateSegments = (form) ->
      $scope.solicitude.ticket.segments? and $scope.solicitude.ticket.segments.length > 0

    $scope.validateForm = (form) ->
      $scope.error['segments'] = $scope.validateSegments(form)
      form.$invalid = !$scope.validateSegments(form)
      $scope.submitted = true

    $scope.addTask = (form) ->
      if form.$valid
        console.log 'addTask:', $scope.solicitude._id, $scope.task
        Task.create $scope.solicitude._id, $scope.task, (err, task) ->
          if !err
            $scope.atts = []
            $rootScope.$emit 'clean_list_uploader'
            $scope.task = {}

    $scope.addComment = (form) ->
      if form.$valid and typeof($scope._comment.message) isnt 'undefined' and $scope._comment.message isnt ''
        _to = null
        if $scope.comment_type is 'pm' and $scope.solicitude.applicant?._id?
          _to = $scope.solicitude.applicant._id

        if $scope.comment_type is 'internal' and $scope.solicitude.responsible?._id? and $scope.solicitude.editor?._id?
          _to = $scope.solicitude.responsible._id if $rootScope.currentUser.role is 'EDITOR'
          _to = $scope.solicitude.editor._id if ['ADMIN', 'ROOT', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role) > -1

        if $scope.comment_type is 'provider' and $scope.solicitude.provider?._id? and $scope.solicitude.responsible?._id?
          _to = $scope.solicitude.provider._id if $rootScope.currentUser.role is 'CONTENT_MANAGER'
          _to = $scope.solicitude.responsible._id if ['ADMIN', 'ROOT', 'PROVIDER'].indexOf($rootScope.currentUser.role) > -1

        Comment.create "Solicitude.#{$scope.comment_type}", $scope.solicitude._id, _to, $scope._comment, (err, comment) ->
          if !err
            $rootScope.$emit 'clean_list_uploader'
            $scope._comment = {}
            $rootScope.$emit 'resetCkeditor'
            $scope.submitted = false
      else
        $scope.submitted = true

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
