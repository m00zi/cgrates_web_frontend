import DS from 'ember-data'

export default DS.Model.extend {
  email:      DS.attr 'string'
  password:   DS.attr 'string'
  insertedAt: DS.attr 'date'
  updatedAt:  DS.attr 'date'
}
