# jshint expr:true
import Ember from 'ember'
import startApp from 'cgrates-web-frontend/tests/helpers/start-app'
import { Response } from 'ember-cli-mirage'
import { authenticateSession } from 'cgrates-web-frontend/tests/helpers/ember-simple-auth'

describe "Acceptance: TpFilter.Edit", ->
  beforeEach ->
    @App = startApp()
    @tariffPlan = server.create 'tariff-plan', name: 'Test', alias: 'tptest'
    @tpFilter = server.create 'tp-filter', tpid: @tariffPlan.alias
    authenticateSession(@App, {email: "user@example.com"})
    return

  afterEach ->
    Ember.run(@App, "destroy")

  describe 'fill form with incorrect data and submit', ->
    it 'does not submit data', ->
      counter = 0
      server.post('/tp-filters/', (schema, request) ->
        counter = counter + 1
        {}
      )
      visit '/tariff-plans/1/tp-filters'
      click 'table tbody tr:first-child a.edit'
      andThen ->
        fillIn "##{find("label:contains('Tenant')").attr('for')}", ''
        fillIn "##{find("label:contains('ID')").attr('for')}", ''
        fillIn "##{find("label:contains('Filter field name')").attr('for')}", ''
        fillIn "##{find("label:contains('Filter field values')").attr('for')}", ''
        fillIn "##{find("label:contains('Activation interval')").attr('for')}", ''
        click 'button[type="submit"]'
        andThen ->
          expect(counter).to.eq 0

  describe 'fill form with correct data and submit', ->
    it 'sends correct data to the backend', ->
      counter = 0

      server.patch('/tp-filters/:id', (schema, request) ->
        counter = counter + 1
        params = JSON.parse(request.requestBody)
        expect(params.data.attributes['tpid']).to.eq 'tptest'
        expect(params.data.attributes['custom-id']).to.eq 'Test'
        expect(params.data.attributes['filter-type']).to.eq '*gt'
        expect(params.data.attributes['filter-field-name']).to.eq 'Test'
        expect(params.data.attributes['filter-field-values']).to.eq 'Test'
        expect(params.data.attributes['activation-interval']).to.eq 'Test'
        return { data: {id: '1', type: 'tp-filter'} }
      )

      visit '/tariff-plans/1/tp-filters'
      click 'table tbody tr:first-child a.edit'

      andThen ->
        selectChoose "##{find("label:contains('Filter type')").attr('for')}", '*gt'
        fillIn "##{find("label:contains('Tenant')").attr('for')}", 'Test'
        fillIn "##{find("label:contains('ID')").attr('for')}", 'Test'
        fillIn "##{find("label:contains('Filter field name')").attr('for')}", 'Test'
        fillIn "##{find("label:contains('Filter field values')").attr('for')}", 'Test'
        fillIn "##{find("label:contains('Activation interval')").attr('for')}", 'Test'
        click 'button[type="submit"]'
        andThen ->
          expect(counter).to.eq 1
