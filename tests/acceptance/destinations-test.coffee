# jshint expr:true
import Ember from 'ember'
import { describe } from 'mocha'
import { expect } from 'chai'
import startApp from '../helpers/start-app'
import { authenticateSession } from '../helpers/ember-simple-auth'

describe "Acceptance: Destinations", ->
  beforeEach ->
    @App = startApp()
    server.createList('destination', 2)
    authenticateSession(@App, {email: "user@exmple.com"})
    return

  afterEach ->
    Ember.run(@App, "destroy")

  it "renders table with destinations sorted by id", ->
    visit "/destinations"
    andThen ->
      expect(find('header h1').text()).to.eq('Destinations')
      expect(find('table tbody tr').length).to.eq(2)
      expect(find('table tbody tr:first-child td:first-child').text()).to.eq('1')

  describe 'click on remove btn', ->
    it 'removes destination', ->
      visit "/destinations"
      click 'table tbody tr:first-child a.remove'
      andThen ->
        expect(find('table tbody tr').length).to.eq(1)
