'use strict'

describe 'test', () ->

  beforeEach () ->
    browser().navigateTo '/login'
    # input('user.email').enter 'test@test.com'
    # input('user.password').enter 'test'
    # expect(element('[name="email"]').count()).toEqual 1
    # expect(element('[name="password"]').count()).toEqual 1
    # expect(element('[type="submit"]').count()).toEqual 1
    # element('[type="submit"]').click()
    sleep 1

  afterEach () ->
    browser().navigateTo '/logout'

  describe 'login', () ->

    # it 'should route /login', () ->
    #   expect(browser().location().url()).toEqual '/'

    it 'should navigate to /settings', () ->
      browser().navigateTo '/settings'
      expect(browser().location().url()).toEqual '/login'