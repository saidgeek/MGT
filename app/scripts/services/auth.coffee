'use strict'

angular.module('movistarApp')
  .factory 'Auth', ($location, $rootScope, Session, UserService, $cookieStore) ->
    
    # Get currentUser from cookie
    $rootScope.currentUser = $cookieStore.get('user') or null
    $cookieStore.remove 'user'
    
    ###
    Authenticate user
    
    @param  {Object}   user     - login info
    @param  {Function} callback - optional
    @return {Promise}
    ###
    login: (user, callback) ->
      cb = callback or angular.noop
      Session.save(
        email: user.email
        password: user.password
        remember: user.remember
      , (user) ->
        $rootScope.currentUser = user
        cb()
      , (err) ->
        cb err
      ).$promise

    
    ###
    Unauthenticate user
    
    @param  {Function} callback - optional
    @return {Promise}
    ###
    logout: (callback) ->
      cb = callback or angular.noop
      Session.delete(->
        $rootScope.currentUser = null
        cb()
      , (err) ->
        cb err
      ).$promise

    recovery: (user, callback) ->
      cb = callback or angular.noop
      UserService.recovery(
        email: user.email
      , (user) ->
        cb(user)
      , (err) ->
        cb err
      ).$promise
    
    ###
    Change password
    
    @param  {String}   oldPassword
    @param  {String}   newPassword
    @param  {Function} callback    - optional
    @return {Promise}
    ###
    changePassword: (oldPassword, newPassword, callback) ->
      cb = callback or angular.noop
      UserService.update(
        oldPassword: oldPassword
        newPassword: newPassword
      , (user) ->
        cb user
      , (err) ->
        cb err
      ).$promise

    
    ###
    Gets all available info on authenticated user
    
    @return {Object} user
    ###
    currentUser: ->
      UserService.get()

    
    ###
    Simple check to see if a user is logged in
    
    @return {Boolean}
    ###
    isLoggedIn: ->
      user = $rootScope.currentUser
      !!user
