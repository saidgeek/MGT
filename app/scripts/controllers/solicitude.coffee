'use strict'

angular.module('movistarApp')
  .controller 'SidebarCtrl', ($scope, SolicitudeFactory, $rootScope, AllStateData, StateData, PriorityData, PriorityIconData, CategoryFactory, UserFactory) ->
    $scope.statesGroups = null
    $scope.priorityGroups = null
    $scope.errors = {}
    

    _loadStates = () ->
      SolicitudeFactory.groups (err, groups) ->
        if err
          $scope.errors = err
        else
          $scope.statesGroups = groups.states
          $scope.priorityGroups = groups.priorities

    $rootScope.$on 'reloadStates', (e) ->
      _loadStates()

    $scope.filter = (state, category, priority, involved) ->
      $rootScope.$emit 'reloadSolicitudes', state, category, priority, involved

    _loadStates()

  .controller 'SolicitudeCtrl', ($rootScope, $scope, Auth, $location, SolicitudeFactory, RolesData) ->
    $rootScope.title = "Solicitudes"
    $scope.solicitudes = []
    $scope.errors = {}

    $scope.showModals = (modal) ->
      _showModals(modal)

    $rootScope.$on 'showModals', (e, args) ->
      _showModals(args.modal)

    $scope.$on 'hideModals', (e) ->
      $scope.modals = ''

    _showModals = (modal) ->
      $scope.modals = modal

    $rootScope.$on 'reloadSolicitudes', (e, state, category, priority, involved) ->
      _loadSolicitudes(state, category, priority, involved)

    $rootScope.$on 'updateSolicitudes', (e) ->
      _loadSolicitudes('', '', '', '')
      # $rootScope.$emit 'reloadGroups'

    $scope.loadSolicitude = (id) ->
      $rootScope.$emit 'showTabs', ''
      $rootScope.$emit 'loadSolicitudeShow', id

    _loadSolicitudes = (state, category, priority, involved) ->
      $scope.solicitudes = null
      SolicitudeFactory.index state, category, priority, involved, (err, solicitudes) ->
        if err
          $scope.errors = err
        else
          if solicitudes.length > 0
            $rootScope.$emit 'loadSolicitudeShow', solicitudes[0]._id
            $rootScope.$emit 'reloadStates'
            $scope.solicitudes = solicitudes

    _loadSolicitudes('', '', '', '')

  .controller 'SolicitudeShowCtrl', ($scope, SolicitudeFactory, $rootScope, SolicitudeParams, PriorityData, CategoryFactory, UserFactory, SegmentsData, SectionsData) ->
    $scope.solicitude = {}
    $scope.tags = []
    $scope.errors = {}
    $scope.viewDetail = null
    $scope.tabs = ''
    $scope.viewDetail = null
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

    $rootScope.$on 'loadSolicitudeShow', (e, id) ->
      $scope.viewDetail = null
      _loadSolicitude(id)

    if SolicitudeParams?.id?
      _loadUser(SolicitudeParams.id)

    _changeViewByRole = (solicitude) ->
      _role = $rootScope.currentUser.role
      if solicitude.state[_role] is 'QUEUE_VALIDATION' and ~['EDITOR', 'ADMIN', 'ROOT'].indexOf _role
        $scope.viewDetail = 'updateByEditor'
      if solicitude.state is 'QUEUE_ALLOCATION' and ~['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf _role
        $scope.viewDetail = 'updateByContentManager'
      if solicitude.state is 'QUEUE_PROVIDER'
        $scope.viewDetail = null

    _loadSolicitude = (id) ->
      SolicitudeFactory.show id, (err, solicitude) ->
        if err
          $scope.errors = err
        else
          $scope.solicitude = solicitude
          _changeViewByRole($scope.solicitude)

    _showTabs = (tab) ->
      $scope.tabs = tab

    $rootScope.$on 'showTabs', (e, tab) ->
      _showTabs(tab)

    $scope.showTabs = (tab) ->
      _showTabs(tab)

    $scope.activeTab = (tab) ->
      $scope.tabs is tab

    $scope.addComment = (form) ->
      if form.$valid
        SolicitudeFactory.addComments $scope.solicitude._id, $scope.solicitude.message, (err) ->
          if err
            $scope.errors = err
          else
            _loadSolicitude($scope.solicitude._id)

    $scope.addTag = (e) ->
      if e.keyCode is 13
        e.preventDefault()
        $scope.tags.push $scope.solicitude.tag
        $scope.solicitude.ticket.tags = $scope.tags
        $scope.solicitude.tag = ''
        return false

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
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se actualizo correctamente.
                       """
            $rootScope.$emit 'reloadSolicitudes', '', '', '', ''

  .controller 'SolicitudeSaveCtrl', ($scope, $rootScope, SolicitudeFactory, SolicitudeParams) ->
    $scope.solicitude = {}
    $scope.errors = {}

    if SolicitudeParams?.id?
      SolicitudeFactory.show id, (err, solicitude) ->
        if err
          $scope.errors = err
        else
          $scope.solicitude = solicitude
          SolicitudeParams.id = null

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
            $rootScope.$emit 'reloadSolicitudes', '', '', '', ''
            $scope.$emit 'hideModals'
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se creo correctamente.
                       """

    $scope.closeModal = () ->
      $scope.$emit 'hideModals'
