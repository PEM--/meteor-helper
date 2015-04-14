MeteorHelperView = require './meteor-helper-view'

module.exports = MeteorHelper =
  # Define configuration capabilities
  config:
    meteorPath:
      type: 'string'
      description: 'Customize Meteor\'s launching command'
      default: '/usr/local/bin/meteor'
      order: 1
    meteorPort:
      type: 'integer'
      default: 3000
      description: 'Meteor\'s default port is 3000 and Mongo\'s default port \
        is the same incremented by 1'
      order: 2
    mongoURL:
      type: 'string'
      default: ''
      description: 'Default Mongo installation is generally accessible at: \
        mongodb://localhost:27017'
      order: 3
    mongoOplogURL:
      type: 'string'
      default: ''
      description: 'Default Mongo Oplog installation must match MONGO_URL'
      order: 4
    debug:
      type: 'boolean'
      default: false
      description: 'Add some intersting DDP logs when debugging'
      order: 5
    production:
      type: 'boolean'
      default: false
      description: 'Used for checking production compilations'
      order: 6

  meteorHelperView: null

  # Public: Activate plugin
  #
  # Returns: `undefined`
  activate: (state) ->
    # Create the main's view
    @meteorHelperView = new MeteorHelperView state.meteorHelperViewState

  # Public: Deactivate plugin.
  #
  # Returns: `undefined`
  deactivate: ->
    @meteorHelperView.destroy()

  # Public: Serialize package state.
  #
  # Returns: Seriliazed package.
  serialize: ->
    meteorHelperViewState: @meteorHelperView.serialize()
