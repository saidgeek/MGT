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
            $scope.solicitudes = solicitudes

    _loadSolicitudes('')

  .controller 'SolicitudeShowCtrl', ($scope, SolicitudeFactory, $rootScope, SolicitudeParams) ->
    $scope.solicitude = {}
    $scope.errors = {}
    $scope.viewDetail = null
    $scope.tabs = ''

    $rootScope.$on 'loadSolicitudeShow', (e, id) ->
      _loadSolicitude(id)

    if SolicitudeParams?.id?
      _loadUser(SolicitudeParams.id)

    _loadSolicitude = (id) ->
      $scope.solicitude = ''
      SolicitudeFactory.show id, (err, solicitude) ->
        if err
          $scope.errors = err
        else
          # if solicitude.state is 'QUEUE_VALIDATION'
          #   $scope.viewDetail = 'updateByContentManager'
          $scope.solicitude = solicitude

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
