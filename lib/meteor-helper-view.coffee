{View, BufferedProcess} = require 'atom'
fs = require 'fs'

module.exports =



class MeteorHelperView extends View
  @content: ->
    @div click: 'onClick', class: 'meteor-helper tool-panel panel-bottom
      text-smaller', =>
      @div class: 'panel-heading status-bar tool-panel', =>
        @div class: 'status-bar-left pull-left meteor-logo'
        @div outlet: 'meteorStatus', class: 'status-bar-right pull-right', =>
          @span class: 'loading loading-spinner-tiny inline-block'
      @div outlet: 'meteorDetails', class: 'panel-body'

  initialize: (serializeState) ->
    atom.workspaceView.command 'meteor-helper:toggle', => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  onClick: ->
    console.log 'Cliky'

  toggle: ->
    # TODO
    window.meteor = @
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
      fs.exists @meteorPath, (exists) =>
        # Set text in the panel
        @meteorDetails.html 'Meteor is launched'
        @meteorStatus.html '<i class="fa fa-gear
          text-hightlight faa-spin animated"></i>'
