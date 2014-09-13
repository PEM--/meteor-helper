MeteorHelperView = require './meteor-helper-view'

module.exports =
  # Define a default installation path for Meteor
  configDefaults:
    meteorPath: '/usr/local/bin/meteor'
    meteorPort: 3000
    production: false
    debug: false
    mongoURL: ''

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
