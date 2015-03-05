MeteorHelperView = require './meteor-helper-view'

module.exports =
  # Define configuration capabilities
  config:
    meteorAppPath:
      type: 'string'
      description: 'The relative path to the Meteor application directory, e.g. "app"'
      default: '.'
    meteorPath:
      type: 'string'
      description: 'Customize Meteor\'s launching command'
      default: '/usr/local/bin/meteor'
    meteorPort:
      type: 'integer'
      default: 3000
      description: 'Meteor\'s default port is 3000 and Mongo\'s default port \
        is the same incremented by 1'
    production:
      type: 'boolean'
      default: false
      description: 'Used for checking production compilations'
    debug:
      type: 'boolean'
      default: false
      description: 'Add some intersting DDP logs when debugging'
    mongoURL:
      type: 'string'
      default: ''
      description: 'Default Mongo installation is generally accessible at: \
        mongodb://localhost:27017'
    mongoOplogURL:
      type: 'string'
      default: ''
      description: 'Default Mongo Oplog installation must match MONGO_URL'

  meteorHelperView: null

  # Public: Activate plugin
  #
  # state - The state of the plugin as {[type]}.
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
