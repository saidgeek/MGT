'use strict'

angular.module('movistarApp')
  .directive 'sgkActive', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        angular.element('.note.round').removeClass 'active'
        angular.element(this).addClass 'active'
        angular.element('.note.round.active span').css {'display':'block'}

  .directive 'sgkActiveSolicitude', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        angular.element('.note.round').removeClass 'active'
        angular.element(this).addClass 'active'

  .directive 'sgkSubmenuNotifications', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        _notifications = angular.element('#submenu.notifications')
        _options = angular.element('#submenu.options')
        if _options.css('display') is 'block'
          _options.slideToggle 200
        _notifications.slideToggle 200

  .directive 'sgkSubmenuOptions', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      _notifications = angular.element('#submenu.notifications')
      _options = angular.element('#submenu.options')
      el.on 'click', (e) ->
        if _notifications.css('display') is 'block'
          _notifications.slideToggle 200
        _options.slideToggle 200
      el.parent().find('a.t-c').on 'click', (e) ->
        _options.slideToggle 200

  .directive 'sgkCheck', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        el.parent().find('.hide').trigger('click')
        el.toggleClass 'active'

  .directive 'sgkDownModal', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', (e) ->
        e.preventDefault()
        angular.element(this).find('span.down').toggleClass 'up'
        angular.element('.esconder').slideToggle(0);
        angular.element('#nueva-solicitud').toggleClass 'auto'
        false

  .directive 'sgkAlerts', ($rootScope, $timeout) ->
    restrict: 'A'
    templateUrl: 'partials/_alerts'
    replace: true
    controller: ($scope, $element) ->

      $element.find('a.cerrar').on 'click', (e) ->
        $element.slideToggle(400)

      $rootScope.$watch 'alert', () ->
        if $rootScope.alert?.content?
          $scope.content = $rootScope.alert.content
          $element.slideToggle(400)
          $timeout () ->
            if $element.css('display') is 'block'
              $element.slideToggle(400)
              $rootScope.alert = {}
          , 5000


  .directive 'sgkFileUploadUser', (filepickerApi, $timeout) ->
    restrict: 'A'
    templateUrl: 'partials/_userUploader'
    require: 'ngModel'
    link: (scope, el, attrs, ngModel) ->
      el.find('input[type="file"]').on 'change', (e) ->
        el.find('.edit-avatar-user').css 'display', 'none'
        el.find('#loader').css 'display', 'block'
        input = angular.element(e.target)
        filepickerApi.storeConvert input[0].files[0], { width: 80, height: 80, fit: 'scale', align: 'face' }, (err, res) ->
          ngModel.$setViewValue(res.url)
          scope.$apply () ->
            $timeout () ->
              el.find('#loader').css 'display', 'none'
              el.find('.edit-avatar-user').css 'display', 'block'
            , 600




# $('span.opt-check').click(function(){
#     $(this).parent().find('.hide').trigger('click');
#     $(this).toggleClass('active');
# });

# $('.note.round').click(function(){
#     $('.note.round').removeClass('active');
#     $(this).addClass('active');

#     if($('.overflow.admin').find('.note.round').attr('title') == $(this).attr('id')){

#         console.log('iguales!');

#     }
# });

# $('.hideshow a').bind('click', function(){
#     $(this).find('span.down').toggleClass('up');
#     $('.esconder').slideToggle(0);
#     $('#nueva-solicitud').toggleClass('auto');
# });

# $('.close a').click(function(){
#     $('#nueva-solicitud').css({'opacity':0, 'zIndex':-1});
# });

# $('a.boton1').click(function(){
#     $('#nueva-solicitud').css({'opacity':1, 'zIndex':999});
# });

# $('a.sub-not').click(function(){
#     $('#submenu').slideToggle(200);
# });

# $('.menu-middle li a').click(function(){
#     $('.menu-middle li a').removeClass('active');
#     $(this).addClass('active');
# });
