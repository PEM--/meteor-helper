{View, BufferedProcess} = require 'atom'
fs = require 'fs'

module.exports =

class MeteorHelperView extends View
  @content: ->
    @div class: 'meteor-helper tool-panel panel-bottom text-smaller', =>
      @div class: 'panel-heading status-bar tool-panel', =>
        @div class: 'status-bar-left pull-left meteor-logo', 'Meteor'
        @div class: 'status-bar-right pull-right', =>
          @i class: 'fa fa-check success faa-spin animated'
      @div class: 'panel-body'

  initialize: (serializeState) ->
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
      atom.workspaceView.prependToBottom @
    # Check if toggling is the 1st one
    if @meteorPath is undefined
      # Get the current assigned value for Meteorite
      @meteorPath = atom.config.get 'meteor-helper.meteorPath'
      # Check if the command is installed on the system
      fs.exists @meteorPath, (exists) ->
        atom.workspaceView.find '.meteor-helper .panel-body'
          .html 'It exists ?'
        console.log 'It exists ?'
