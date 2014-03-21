'use strict'

describe 'test', () ->

  # beforeEach () ->
  #   browser().navigateTo '/login'
  #   input('user.email').enter 'atarix.010101@gmail.com'
  #   input('user.password').enter 'test'
  #   expect(element('[name="email"]').count()).toEqual 1
  #   expect(element('[name="Contrasena"]').count()).toEqual 1
  #   expect(element('[type="submit"]').count()).toEqual 1
  #   element('[type="submit"]').click()
  #   sleep 1

  # afterEach () ->
  #   browser().navigateTo '/logout'

  describe 'login', () ->

    it 'deberia entrar a /login', () ->
      browser().navigateTo '/login'
      expect(browser().location().url()).toEqual '/login'

    it 'deberia redireccionar a /login despues de entrar a / sin autenticación', () ->
      browser().navigateTo '/'
      sleep 1
      expect(browser().location().url()).toEqual '/login'

    it 'deberia existir el input email', () ->
      browser().navigateTo '/login'
      expect(element('[name="email"]').count()).toEqual 1
      
    it 'deberia existir el input contraseña', () ->
      browser().navigateTo '/login'
      expect(element('[name="Contrasena"]').count()).toEqual 1

    it 'deberia existir el button submit', () ->
      browser().navigateTo '/login'
      expect(element('[type="submit"]').count()).toEqual 1


    it 'deberian aparecer las alertas al loguarse con usuario y clave erroneas', () ->
      browser().navigateTo '/login'
      input('user.email').enter 'test@test.com'
      input('user.password').enter 'test'
      element('[type="submit"]').click()
      sleep 1
      expect(element('div#alerta:visible').count()).toEqual 1
      expect(element('label.error:visible').count()).toEqual 2

    it 'deberian aparecer solo la alerta general y la de clave al loguarse con email correcto y clave erronea', () ->
      browser().navigateTo '/login'
      input('user.email').enter 'atarix.010101@gmail.com'
      input('user.password').enter 'test'
      element('[type="submit"]').click()
      sleep 1
      expect(element('div#alerta:visible').count()).toEqual 1
      expect(element('label.error:visible').count()).toEqual 1

    it 'deberian aparecer solo la alerta general y las del email y clave,  al loguarse con email erroneo y clave correcto', () ->
      browser().navigateTo '/login'
      input('user.email').enter 'asdasd'
      input('user.password').enter '532b93c9'
      element('[type="submit"]').click()
      sleep 1
      expect(element('div#alerta:visible').count()).toEqual 1
      expect(element('label.error:visible').count()).toEqual 2
    
    it 'deberia loguarse y entrar a /', () ->
      browser().navigateTo '/login'
      input('user.email').enter 'atarix.010101@gmail.com'
      input('user.password').enter '532b93c9'
      element('[type="submit"]').click()
      sleep 1
      expect(browser().location().url()).toEqual '/'
      browser().navigateTo '/logout'
      sleep 3

    it 'deberia entrar a /recovery', () ->
      browser().navigateTo '/recovery'
      expect(browser().location().url()).toEqual '/recovery'

    it 'deberia existir el input email', () ->
      browser().navigateTo '/recovery'
      expect(element('[name="Email"]').count()).toEqual 1
    
    it 'deberian aparecer las alertas al ingresar correo erroneo', () ->
      browser().navigateTo '/recovery'
      input('user.email').enter 'test@test.com'
      element('[type="submit"]').click()
      sleep 1
      expect(element('div#alerta:visible').count()).toEqual 1

    it 'deberian aparecer las alerta success al ingresar correo correcto', () ->
      browser().navigateTo '/recovery'
      input('user.email').enter 'atarix.010101@gmail.com'
      element('[type="submit"]').click()
      sleep 1
      expect(element('div.success:visible').count()).toEqual 1



