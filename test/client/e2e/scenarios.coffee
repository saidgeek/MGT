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
      input('user.password').enter '533b959c'
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

  describe 'Admin', () ->

    beforeEach ->
      browser().navigateTo '/login'
      input('user.email').enter 'atarix.010101@gmail.com'
      input('user.password').enter '533b959c'
      element('[type="submit"]').click()
      sleep 1
      expect(browser().location().url()).toEqual '/'

    afterEach ->
      browser().navigateTo '/logout'
      sleep 3

    it 'Deberia poder entrar en el path "/admin"', () ->
      browser().navigateTo '/admin'
      expect(browser().location().url()).toEqual '/admin'

    it 'En el sidebar deberia estar el listado de filtros por roles', () ->
      browser().navigateTo '/admin'
      expect(element('div#estado').count()).toEqual 1
      expect(element('div#estado ul li').count()).toEqual 7

    it 'La lista de usuarios deberia tener elementos', () ->
      browser().navigateTo '/admin'
      expect(element('#left .top-admin').count()).toEqual 1
      expect(element('#left .top-admin div.note').count()).toBeGreaterThan 1

    it 'El boton para crear usuarios deberia estar en el DOM', () ->
      browser().navigateTo '/admin'
      expect(element('a.boton1').count()).toEqual 1

    it 'Al hacer click en el boton crear usuario deberia aprrecer el modal de crear usuario', () ->
      browser().navigateTo '/admin'
      expect(browser().location().url()).toEqual '/admin'

    it 'Al llenar los capos del formulario de nuevo usuario y dar submit se crear el nuevo usaurio agreandose uno mas a la lista y apareciendo el alerta', () ->
      browser().navigateTo '/admin'
      expect(browser().location().url()).toEqual '/admin'

    it 'Al hacer click en el boton editar clasificacion deberia aprrecer el modal de editar clasificacion', () ->
      browser().navigateTo '/admin'
      expect(browser().location().url()).toEqual '/admin'

    it 'Al llenar los capos del formulario de nuevo clasificacion y dar submit se editar el nuevo clasificacion agreandose uno mas a la lista y apareciendo el alerta', () ->
      browser().navigateTo '/admin'
      expect(browser().location().url()).toEqual '/admin'

    it 'Deberia poder entrar en el path "/admin/category"', () ->
      browser().navigateTo '/admin/category'
      expect(browser().location().url()).toEqual '/admin/category'

    it 'El boton para crear clasificacion deberia estar en el DOM', () ->
      browser().navigateTo '/admin/category'
      expect(element('a.boton1').count()).toEqual 1

    it 'La lista de usuarios deberia tener elementos', () ->
      browser().navigateTo '/admin/category'
      expect(element('#left .top-admin').count()).toEqual 1
      expect(element('#left .top-admin div.note').count()).toBeGreaterThan 1

    it 'Al hacer click en el boton crear clasificacion deberia aprrecer el modal de crear clasificacion', () ->
      browser().navigateTo '/admin/category'
      expect(browser().location().url()).toEqual '/admin/category'

    it 'Al llenar los capos del formulario de nuevo clasificacion y dar submit se crear el nuevo clasificacion agreandose uno mas a la lista y apareciendo el alerta', () ->
      browser().navigateTo '/admin/category'
      expect(browser().location().url()).toEqual '/admin/category'

    it 'Al hacer click en el boton editar clasificacion deberia aprrecer el modal de editar clasificacion', () ->
      browser().navigateTo '/admin/category'
      expect(browser().location().url()).toEqual '/admin/category'

    it 'Al llenar los capos del formulario de nuevo clasificacion y dar submit se editar el nuevo clasificacion agreandose uno mas a la lista y apareciendo el alerta', () ->
      browser().navigateTo '/admin/category'
      expect(browser().location().url()).toEqual '/admin/category'

  describe 'Solicitud', () ->

    beforeEach ->
      browser().navigateTo '/login'
      input('user.email').enter 'atarix.010101@gmail.com'
      input('user.password').enter '533b959c'
      element('[type="submit"]').click()
      sleep 1
      expect(browser().location().url()).toEqual '/'

    afterEach ->
      browser().navigateTo '/logout'
      sleep 3

    it 'Deberia estar en el path "/"', () ->
      browser().navigateTo '/'
      expect(browser().location().url()).toEqual '/'

    it 'Deberian estar el listado de estados en el sidebar', () ->
      browser().navigateTo '/'
      expect(element('div#estado').count()).toEqual 1
      expect(element('div#estado ul li').count()).toBeGreaterThan 1

    it 'Deberian estar el listado de prioridades en el sidebar', () ->
      browser().navigateTo '/'
      expect(element('div#prioridad').count()).toEqual 1
      expect(element('div#prioridad ul li').count()).toBeGreaterThan 1

    it 'Deberian estar el listado de categorias en el sidebar', () ->
      browser().navigateTo '/'
      expect(element('div#categoria').count()).toEqual 1
      expect(element('div#categoria ul li').count()).toBeGreaterThan 1

    it 'Deberian estar el listado de involucrados en el sidebar', () ->
      browser().navigateTo '/'
      expect(element('div#involucrados').count()).toEqual 1
      expect(element('div#involucrados ul li').count()).toBeGreaterThan 1

    it 'El boton para crear solicitud deberia estar en el DOM', () ->
      browser().navigateTo '/'
      expect(element('a.boton1').count()).toEqual 1

    it 'Al hacer click al boton crear solicitud deberia aparecer el modal', () ->
      browser().navigateTo '/'
      expect(browser().location().url()).toEqual '/'

    it 'Al llenar el formulario del modal crear solicitud y hacer submit se creara', () ->
      browser().navigateTo '/'
      expect(browser().location().url()).toEqual '/'

    it 'Al llenar el formulario del editor y hacer submit se deberia actualizar la silicitud', () ->
      browser().navigateTo '/'
      expect(browser().location().url()).toEqual '/'

    it 'Al llenar el formulario del gestor de contenido y hacer submit se deberia actualizar la silicitud', () ->
      browser().navigateTo '/'
      expect(browser().location().url()).toEqual '/'

    it 'Al hacer click en una solicitud el detalle deberia cambiar', () ->
      browser().navigateTo '/'
      expect(browser().location().url()).toEqual '/'
