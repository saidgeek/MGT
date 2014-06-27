'use strict'

angular.module('movistarApp')
  .controller 'SolicitudesCtrl', ($scope, $rootScope, SolicitudeFactory, IO) ->
    $scope.solicitudes = []
    $scope.role = $rootScope.currentUser.role

    IO.emit 'register.solicitude.change.sla', {}
    IO.emit 'register.solicitude.remove.sla', {}

    # state, category, priority, involved
    reload = (state, category, priority, involved) ->
      SolicitudeFactory.index null, state, category, priority, involved, (err, solicitudes) ->
        if err
          $scope.errors = err
        else
          if solicitudes.length > 0
            $scope.solicitudes = solicitudes
            console.log '$scope.solicitudes:', $scope.solicitudes
          else
            $scope.solicitudes = null
    $rootScope.$on 'reloadSolicitude', (e, solicitude) =>
      selectedId = solicitude._id
      reload('','','','')

    reload('', '', '', '')

    $rootScope.$watchCollection '[filters.solicitude.state, filters.solicitude.category, filters.solicitude.priority, filters.solicitude.involved]', () =>
      state = if $rootScope.filters?.solicitude?.state? then $rootScope.filters.solicitude.state else ''
      category = if $rootScope.filters?.solicitude?.category? then $rootScope.filters.solicitude.category else ''
      priority = if $rootScope.filters?.solicitude?.priority? then $rootScope.filters.solicitude.priority else ''
      involved = if $rootScope.filters?.solicitude?.involved? then $rootScope.filters.solicitude.involved else ''
      reload(state, category, priority, involved) if state isnt '' or category isnt '' or priority isnt '' or involved isnt ''

  .controller 'SolicitudeDetailCtrl', ($scope, SolicitudeFactory, $rootScope, SolicitudeParams, PriorityData, CategoryFactory, UserFactory, SegmentsData, SectionsData, $state) ->
    $scope.solicitude = null
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

    CategoryFactory.index (err, categories) ->
      if err
        $scope.errors = err
      else
        $scope.categories = categories

    UserFactory.index 'CONTENT_MANAGER', (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.contentManagers = users

    UserFactory.index 'PROVIDER', (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.provider = users


    # $scope.showOption = (option) ->
    #   if option is 'PAUSED'
    #     ~['ROOT', 'ADMIN', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role)

    
    SolicitudeFactory.show $state.params.id, (err, solicitude) ->
      if !err
        $scope.solicitude = solicitude
        console.log '$scope.solicitude:', $scope.solicitude

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

    $scope.addComment = (form) ->
      if form.$valid
        SolicitudeFactory.addComments $scope.solicitude._id, $scope.solicitude.comment, $scope.atts, (err) ->
          if err
            $scope.errors = err
          else
            $scope.atts = []
            $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id

    $scope.addTask = (form) ->
      if form.$valid
        SolicitudeFactory.addTasks $scope.solicitude._id, $scope.solicitude.desc, $scope.atts, (err) ->
          if err
            $scope.errors = err
          else
            $scope.atts = []
            $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id

    $scope.toggleCheck = (task) =>
      SolicitudeFactory.toggleCheckTasks $scope.solicitude._id, task, (err) ->
        if err
          $scope.errors = err
        else
          $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id

    $scope.nextState = (state) =>
      $scope.solicitude.nextState = state

    $scope.update = (form) =>
      if form.$valid
        SolicitudeFactory.update $scope.solicitude._id, $scope.solicitude, (err, solicitude) ->
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
            $state.transitionTo 'solicitude.index'

  .controller 'SolicitudeCtrl', ($scope, $rootScope, SolicitudeFactory, IO) ->
    $scope.solicitudes = []
    $scope.role = $rootScope.currentUser.role

    IO.emit 'register.solicitude.change.sla', {}
    IO.emit 'register.solicitude.remove.sla', {}

    $rootScope.$watchCollection '[filters.solicitude.state, filters.solicitude.category, filters.solicitude.priority, filters.solicitude.involved]', () =>
      state = if $rootScope.filters?.solicitude?.state? then $rootScope.filters.solicitude.state else ''
      category = if $rootScope.filters?.solicitude?.category? then $rootScope.filters.solicitude.category else ''
      priority = if $rootScope.filters?.solicitude?.priority? then $rootScope.filters.solicitude.priority else ''
      involved = if $rootScope.filters?.solicitude?.involved? then $rootScope.filters.solicitude.involved else ''
      $scope.reload(state, category, priority, involved)

    # state, category, priority, involved
    $scope.reload = (state, category, priority, involved) ->
      SolicitudeFactory.index null, state, category, priority, involved, (err, solicitudes) ->
        if err
          $scope.errors = err
        else
          if solicitudes.length > 0
            $scope.solicitudes = solicitudes
          else
            $scope.solicitudes = null

    $scope.reload('', '', '', '')

  .controller 'SolicitudeShowCtrl', ($scope, SolicitudeFactory, $rootScope, SolicitudeParams, PriorityData, CategoryFactory, UserFactory, SegmentsData, SectionsData) ->
    $scope.solicitude = null
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

    CategoryFactory.index (err, categories) ->
      if err
        $scope.errors = err
      else
        $scope.categories = categories

    UserFactory.index 'CONTENT_MANAGER', (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.contentManagers = users

    UserFactory.index 'PROVIDER', (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.provider = users


    # $scope.showOption = (option) ->
    #   if option is 'PAUSED'
    #     ~['ROOT', 'ADMIN', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role)

    $rootScope.$on 'loadSolicitudeShow', (e, id) =>
      if typeof id isnt 'undefined'
        SolicitudeFactory.show id, (err, solicitude) ->
          if !err
            $scope.solicitude = solicitude

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

    $scope.addComment = (form) ->
      if form.$valid
        SolicitudeFactory.addComments $scope.solicitude._id, $scope.solicitude.comment, $scope.atts, (err) ->
          if err
            $scope.errors = err
          else
            $scope.atts = []
            $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id

    $scope.addTask = (form) ->
      if form.$valid
        SolicitudeFactory.addTasks $scope.solicitude._id, $scope.solicitude.desc, $scope.atts, (err) ->
          if err
            $scope.errors = err
          else
            $scope.atts = []
            $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id

    $scope.toggleCheck = (task) =>
      SolicitudeFactory.toggleCheckTasks $scope.solicitude._id, task, (err) ->
        if err
          $scope.errors = err
        else
          $rootScope.$emit 'loadSolicitudeShow', $scope.solicitude._id

    $scope.nextState = (state) =>
      $scope.solicitude.nextState = state

    $scope.update = (form) =>
      if form.$valid
        SolicitudeFactory.update $scope.solicitude._id, $scope.solicitude, (err, solicitude) ->
          if err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al actualizar la solicitud.
                       """
          else
            $rootScope.$emit 'reloadSolicitude', solicitude
            $rootScope.$emit 'reloadStateFilter'
            $rootScope.$emit 'reloadPriorityFilter'
            $scope.submitted = false
            $scope.form = null
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se actualizo correctamente.
                       """

  .controller 'SolicitudeSaveCtrl', ($scope, $rootScope, SolicitudeFactory, SolicitudeParams) ->
    $scope.title = 'Crear nueva Solicitud'
    $scope.solicitude = {}
    $scope.errors = {}

    $scope.create = (form) ->
      if form.$valid
        SolicitudeFactory.create $scope.solicitude, (err, solicitude) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al crear la solicitud.
                       """
          else
            $rootScope.$emit 'reloadSolicitude', solicitude
            $scope.$emit 'close', true
            $scope.solicitude = {}
            $rootScope.$emit 'reloadStateFilter'
            $scope.submitted = false
            $scope.form = null
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se creo correctamente.
                       """
