"use strict"

angular.module("movistarApp")
  .factory "Solicitude", ($resource, $rootScope) ->

    resource = $resource "", {},
      index:
        method: 'GET'
        params:
          target: '@target'
          filter: '@filter'
          perPage: '@perPage'
          page: '@page'
        url: '/api/v1/solicitudes/:target/:filter'
				#isArray: true

      search:
        method: 'GET'
        params:
          q: '@q'
        url: '/api/v1/solicitudes/search/:q'
        isArray: true

      groups:
        method: "GET"
        params:
          states: '@states'
        url: '/api/v1/solicitudes/groups'

      groupsForUser:
        method: "GET"
        params:
          states: '@states'
          user_id: '@user_id'
          role: '@role'
        url: '/api/v1/solicitudes/groups'

      show:
        method: 'GET'
        params:
          id: '@id'
        url: '/api/v1/solicitude/:id'

      create:
        method: 'POST'
        params:
          client_id: $rootScope.currentUser.id
        data:
          solicitude: '@solicitude'
        url: '/api/v1/solicitude/:client_id'

      update:
        method: "PUT"
        params:
          id: "@id"
        data:
          solicitude: '@solicitude'
        url: '/api/v1/solicitude/:id'

      addComments:
        method: 'PUT'
        params:
          id: "@id"
        data:
          comment: '@comment'
          attachments: '@attachments'
        url: '/api/v1/solicitude/:id/add/comments'

      addTasks:
        method: 'PUT'
        params:
          id: "@id"
        data:
          desc: '@desc'
          attachments: '@attachments'
        url: '/api/v1/solicitude/:id/add/tasks'

      toggleCheckTasks:
        method: 'PUT'
        params:
          id: "@id"
          task: "@task"
        url: '/api/v1/solicitude/:id/check/:task'

    _index = (target, filter, perPage, page, cb) ->
      resource.index(
        target: target
        filter: filter
        perPage: perPage
        page: page
      , (solicitudes) ->
        cb null, solicitudes
      , (err) ->
        cb err.data
      ).$premise

    _search = (q, cb) ->
      resource.search(
        q: q
      , (solicitudes) ->
        cb null, solicitudes
      , (err) ->
        cb err
      ).$promise

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
        states: $rootScope.currentUser?.permissions.states
      , (groups) ->
        groups = _makeGroups(groups)
        cb null, groups
      , (err) ->
        cb err.data
      ).$premise

    _groupsForUser = (user_id, role, cb) ->
      resource.groupsForUser(
        states: $rootScope.currentUser?.permissions.states
        user_id: user_id
        role: role
      , (groups) ->
        groups = _makeGroups(groups)
        cb null, groups
      , (err) ->
        cb err.data
      ).$premise

    _show = (id, cb) ->
      resource.show(
        id: id
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _create = (data, cb) ->
      resource.create(
        {}
        solicitude: data
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _update = (id, data, cb) ->
      resource.update(
        {}
        id: id
        solicitude: data
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _addComments = (id, comment, attachments, cb) ->
      resource.addComments(
        {}
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
        {}
        id: id
        desc: desc
        attachments: attachments
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _toggleCheckTasks = (id, task, cb) ->
      resource.toggleCheckTasks(
        {}
        id: id
        task: task
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    return {
      index: (target, filter, perPage, page, cb) ->
        _index(target, filter, perPage, page, cb)
      search: (q, cb) ->
        _search(q, cb)
      groups: (cb) ->
        _groups(cb)
      groupsForUser: (user_id, role, cb) ->
        _groupsForUser(user_id, role, cb)
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
      resource: resource
    }
