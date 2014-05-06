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

  .controller 'SolicitudeCtrl', ($scope, $rootScope, SolicitudeFactory) ->
    $scope.solicitudes = []
    $scope.role = $rootScope.currentUser.role

    # state, category, priority, involved
    $scope.reload = () ->
      SolicitudeFactory.index '', '', '', '', (err, solicitudes) ->
        if err
          $scope.errors = err
        else
          if solicitudes.length > 0
            $scope.solicitudes = solicitudes

    $scope.reload('', '', '', '')

  .controller 'SolicitudeShowCtrl', ($scope, SolicitudeFactory, $rootScope, SolicitudeParams, PriorityData, CategoryFactory, UserFactory, SegmentsData, SectionsData) ->
    $scope.solicitude = null
    $scope.role = $rootScope.currentUser.role
    $scope.rejectedState = ''

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

    $scope.addComment = (form) ->
      if form.$valid
        SolicitudeFactory.addComments $scope.solicitude._id, $scope.solicitude.message, (err) ->
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
            $rootScope.$emit 'reloadStateFilter', solicitude
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se creo correctamente.
                       """
