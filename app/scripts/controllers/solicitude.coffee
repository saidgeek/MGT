'use strict'

angular.module('movistarApp')
  .controller 'SidebarCtrl', ($scope, SolicitudeFactory, $rootScope, StateData, StateIconsData) ->
    $scope.statesGroups = null
    $scope.errors = {}
    $scope.states = StateData.getArray()
    $scope.statesIcons = StateIconsData.getAll()

    _loadStates = () ->
      SolicitudeFactory.groups (err, groups) ->
        if err
          $scope.errors = err
        else
          console.log groups
          $scope.statesGroups = groups

    $rootScope.$on 'reloadStates', (e) ->
      _loadStates()

    $scope.filter = (state) ->
      $rootScope.$emit 'reloadSolicitudes', state

    _loadStates()

  .controller 'SolicitudeCtrl', ($rootScope, $scope, Auth, $location, SolicitudeFactory, RolesData) ->
    $rootScope.title = "Solicitudes"
    $scope.solicitudes = []
    $scope.errors = {}

    $scope.showModals = (modal) ->
      console.log 'showModals:', modal
      _showModals(modal)

    $rootScope.$on 'showModals', (e, args) ->
      _showModals(args.modal)

    $scope.$on 'hideModals', (e) ->
      $scope.modals = ''

    _showModals = (modal) ->
      $scope.modals = modal

    $rootScope.$on 'reloadSolicitudes', (e, state) ->
      _loadSolicitudes('')

    $rootScope.$on 'updateSolicitudes', (e) ->
      _loadSolicitudes('')
      # $rootScope.$emit 'reloadGroups'

    $scope.loadSolicitude = (id) ->
      $rootScope.$emit 'loadSolicitudeShow', id

    _loadSolicitudes = (state) ->
      SolicitudeFactory.index state, (err, solicitudes) ->
        if err
          $scope.errors = err
        else
          if solicitudes.length > 0
            $rootScope.$emit 'loadSolicitudeShow', solicitudes[0]._id
            $rootScope.$emit 'reloadStates'
            $scope.solicitudes = solicitudes

    _loadSolicitudes('')

  .controller 'SolicitudeShowCtrl', ($scope, SolicitudeFactory, $rootScope, SolicitudeParams, PriorityData, CategoryFactory, UserFactory, SegmentsData, SectionsData) ->
    $scope.solicitude = {}
    $scope.tags = []
    $scope.errors = {}
    $scope.viewDetail = null
    $scope.tabs = ''
    $scope.categories
    $scope.contentManagers

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

    $rootScope.$on 'loadSolicitudeShow', (e, id) ->
      _loadSolicitude(id)

    if SolicitudeParams?.id?
      _loadUser(SolicitudeParams.id)

    _changeViewByRole = (solicitude) ->
      if solicitude.state is 'QUEUE_VALIDATION' and ~['EDITOR', 'ADMIN', 'ROOT'].indexOf $rootScope.currentUser.role
        $scope.viewDetail = 'updateByEditor'

      if solicitude.state is 'QUEUE_ALLOCATION' and ~['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf $rootScope.currentUser.role
        $scope.viewDetail = 'updateByContentManager'

    _loadSolicitude = (id) ->
      $scope.solicitude = ''
      SolicitudeFactory.show id, (err, solicitude) ->
        if err
          $scope.errors = err
        else
          $scope.solicitude = solicitude
          _changeViewByRole(solicitude)

    $scope.showTabs = (tab) ->
      $scope.tabs = tab

    $scope.activeTab = (tab) ->
      $scope.tabs is tab

    $scope.addComment = (form) ->
      if form.$valid
        console.log $scope.solicitude._id, $scope.solicitude.message
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

    $scope.updateByEditor = (form) ->
      console.log '$scope.solicitude: ', $scope.solicitude
      if form.$valid
        SolicitudeFactory.update $scope.solicitude._id, $scope.solicitude, (err) ->
          if err
            $scope.errors = err
          else
            $rootScope.$emit 'reloadSolicitudes', ''

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
          else
            $rootScope.$emit 'reloadSolicitudes'
            $scope.$emit 'hideModals'
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se creo correctamente.
                       """

    $scope.closeModal = () ->
      $scope.$emit 'hideModals'
