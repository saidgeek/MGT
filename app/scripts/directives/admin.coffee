'use strict'

angular.module('movistarApp')
  .directive 'sgkActive', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        el.parent().parent().find('.note').removeClass 'active'
        el.addClass 'active'

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

  .directive 'sgkSubmitLink', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', (e)->
        e.preventDefault()
        element.parents('form').trigger('submit')
        false

  .directive 'sgkDownModal', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', (e) ->
        e.preventDefault()
        angular.element(this).find('span.down').toggleClass 'up'
        angular.element('.esconder').slideToggle(0);
        angular.element('#nueva-solicitud').toggleClass 'auto'
        false

  .directive 'sgkFileUploadUser', (filepickerApi) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, el, attrs, ngModel) ->
      el.find('input[type="file"]').on 'change', (e) ->
        input = angular.element(e.target)
        filepickerApi.storeConvert input[0].files[0], { width: 80, height: 80, fit: 'scale', align: 'face' }, (err, res) ->
          ngModel.$setViewValue(res.url)
          scope.$digest()




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
