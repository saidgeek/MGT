"use strict"

angular.module("movistarApp")
  .factory "Solicitude", ($resource, $rootScope) ->
    _clientToken = $rootScope.currentUser.access.clientToken
    _accessToken = $rootScope.currentUser.access.accessToken
    _states = $rootScope.currentUser.permissions.states

    resource = $resource "", {},
      index:
        method: 'GET'
        params:
          clientToken: _clientToken
          accessToken: _accessToken
        url: '/api/v1/solicitudes'
        isArray: true

      groups:
        method: "GET"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          states: '@states'
        url: '/api/v1/solicitudes/groups'

      show:
        method: 'GET'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
        url: '/api/v1/solicitude/:id'

      create:
        method: 'POST'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          solicitude: '@solicitude'
        url: '/api/v1/solicitude'

      update:
        method: "PUT"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
        data:
          solicitude: '@solicitude'
        url: '/api/v1/solicitude/:id'

      addComments:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
        data:
          comment: '@comment'
          attachments: '@attachments'
        url: '/api/v1/solicitude/:id/add/comments'

      addTasks:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
        data:
          desc: '@desc'
          attachments: '@attachments'
        url: '/api/v1/solicitude/:id/add/tasks'

      toggleCheckTasks:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
          task: "@task"
        url: '/api/v1/solicitude/:id/check/:task'

    _index = (cb) ->
      resource.index(
        {}
      , (solicitudes) ->
        cb null, solicitudes
      , (err) ->
        cb err.data
      ).$premise

    _makeGroups = (groups) ->
      result = {
        states: {}
        priorities: {}
      }
      _statesTotal = 0
      _prioritiesTotal = 0

      for s in groups.states
        result.states[s._id] = s.count
        _statesTotal += s.count

      for p in groups.priorities
        if p._id
          result.priorities[p._id] = p.count
          _prioritiesTotal += p.count

      result.states['total'] = _statesTotal
      result.priorities['total'] = _prioritiesTotal

      result

    _groups = (cb) ->
      resource.groups(
        clientToken: _clientToken
        accessToken: _accessToken
        states: _states
      , (groups) ->
        groups = _makeGroups(groups)
        cb null, groups
      , (err) ->
        cb err.data
      ).$premise

    _show = (id, cb) ->
      resource.show(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _create = (data, cb) ->
      resource.create(
        clientToken: _clientToken
        accessToken: _accessToken
        solicitude: data
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _update = (id, data, cb) ->
      resource.update(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        solicitude: data
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _addComments = (id, comment, attachments, cb) ->
      resource.addComments(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        comment: comment
        attachments: attachments
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _addTasks = (id, desc, attachments, cb) ->
      resource.addTasks(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        desc: desc
        attachments: attachments
      , (solicitude) ->
        cb()
      , (err) ->
        cb err.data
      ).$promise

    _toggleCheckTasks = (id, task, cb) ->
      resource.toggleCheckTasks(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        task: task
      , (solicitude) ->
        cb()
      , (err) ->
        cb err.data
      ).$promise

    return {
      index: (cb) ->
        _index(cb)
      groups: (cb) ->
        _groups(cb)
      show: (id, cb) ->
        _show(id, cb)
      create: (data, cb) ->
        _create(data, cb)
      update: (id, data, cb) ->
        _update(id, data, cb)
      addComments: (id, comment, attachments, cb) ->
        _addComments(id, comment, attachments, cb)
      addTasks: (id, desc, attachments, cb) ->
        _addTasks(id, desc, attachments, cb)
      toggleCheckTasks: (id, task, cb) ->
        _toggleCheckTasks(id, task, cb)
    }
