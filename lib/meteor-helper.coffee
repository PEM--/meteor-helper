MeteorHelperView = require './meteor-helper-view'

module.exports = MeteorHelper =
  # Define configuration capabilities
  config:
    meteorAppPath:
      type: 'string'
      description: 'The relative path to the Meteor application \
        directory, e.g. "app"'
      default: '.'
      order: 1
    meteorPath:
      type: 'string'
      description: 'Customize Meteor\'s launching command'
      default: '/usr/local/bin/meteor'
      order: 2
    meteorPort:
      type: 'integer'
      default: 3000
      description: 'Meteor\'s default port is 3000 and Mongo\'s default port \
        is the same incremented by 1'
      order: 3
    mongoURL:
      title: 'Mongo URL'
      type: 'string'
      default: ''
      description: 'Default Mongo installation is generally accessible at: \
        mongodb://localhost:27017'
      order: 4
    settingsPath:
      title: 'Settings Path'
      type: 'string'
      default: ''
      description: 'Relative or absolute path to Meteor.settings JSON file'
      order: 5
    mongoOplogURL:
      title: 'Mongo Oplog URL'
      type: 'string'
      default: ''
      description: 'Default Mongo Oplog installation must match MONGO_URL'
      order: 6
    debug:
      title: 'Run in Debug Mode'
      type: 'boolean'
      default: false
      description: 'Run Meteor in debug mode for connecting from debugging \
        clients, such as node-inspector (port 5858)'
      order: 7
    production:
      title: 'Simulate Production'
      type: 'boolean'
      default: false
      description: 'Simulate running in production by minifying the \
        JS/CSS assets'
      order: 8

  meteorHelperView: null

  # Public: Activate plugin
  #
  # state - The serialized state.
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
