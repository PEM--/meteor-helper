{View, BufferedProcess} = require 'atom'
fs = require 'fs'

module.exports =
class MeteorHelperView extends View
  @content: ->
    @div class: 'meteor-helper tool-panel panel-bottom', =>
      @div class: 'panel-heading affix', 'Meteor output'
      @div class: 'panel-body padded'

  initialize: (serializeState) ->
    # Get the current assigned value for Meteorite
    @meteorPath = atom.config.get 'meteor-helper.meteorPath'
    # Check if the command is installed on the system
    fs.exist @meteorPath, (exists) =>
      if exists
        atom.workspaceView.command 'meteor-helper:toggle', => @toggle()



  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log 'MeteorHelperView was toggled!'
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append @
