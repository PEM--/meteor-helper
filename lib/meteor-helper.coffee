MeteorHelperView = require './meteor-helper-view'

module.exports =
  # Define a default installation path for Meteorite
  configDefaults:
    meteorPath: '/usr/local/bin/mrt'

  meteorHelperView: null

  activate: (state) ->
    # Create the main's view
    @meteorHelperView = new MeteorHelperView state.meteorHelperViewState

  deactivate: ->
    @meteorHelperView.destroy()

  serialize: ->
    meteorHelperViewState: @meteorHelperView.serialize()
