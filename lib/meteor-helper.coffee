MeteorHelperView = require './meteor-helper-view'
{BufferedProcess} = require 'atom'

module.exports =
  configDefaults:
    meteorPath: '/usr/local/bin/mrt'

  meteorHelperView: null

  activate: (state) ->
    @meteorHelperView = new MeteorHelperView state.meteorHelperViewState

  deactivate: ->
    @meteorHelperView.destroy()

  serialize: ->
    meteorHelperViewState: @meteorHelperView.serialize()
