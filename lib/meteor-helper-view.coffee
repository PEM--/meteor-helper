{View, BufferedProcess, $} = require 'atom'
fs = require 'fs'

module.exports =

class MeteorHelperView extends View
  @content: ->
    @div click: 'onClick', class: 'meteor-helper
      tool-panel panel-bottom text-smaller', =>
      @div class: 'panel-heading status-bar tool-panel', =>
        @div class: 'status-bar-left pull-left meteor-logo'
        @div outlet: 'meteorStatus', class: 'status-bar-right pull-right', =>
          @span class: 'loading loading-spinner-tiny inline-block'
      @div class: 'panel-body', =>
        @div outlet: 'meteorDetails', class: 'meteor-details'

  initialize: (serializeState) ->
    # Import Velocity into the main window's context
    window.jQuery = $
    window.velocity = require '../bower_components/velocity/jquery.velocity.js'
    # Display Meteor's pane
    atom.workspaceView.command 'meteor-helper:toggle', => @toggle()
    # Pane is opened by default
    @paneOpened = true

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: -> @detach()

  onClick: (evt) =>
    height = if @paneOpened then 25 else 150
    @paneOpened = not @paneOpened
    @velocity
      properties:
        height: height
      options:
        duration: 300

  toggle: ->
    console.log 'MeteorHelperView was toggled!'
    if @hasParent()
      @detach()
    else
      # Add the view to the current workspace
      atom.workspaceView.prependToBottom @
      # Get the current assigned value for Meteorite
      @meteorPath = atom.config.get 'meteor-helper.meteorPath'
      # Check if the command is installed on the system
      fs.exists @meteorPath, (exists) =>
        # Set an error message if Meteor cannot be found
        unless exists
          @meteorStatus.html '<i class="fa fa-warning faa-flash animated
            text-warning"></i>'
          @meteorDetails.html "<h3>Meteor command not found: #{@meteorPath}
            </h3>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>
            <p>You can override these setting in this package preference.</p>"
          @meteorDetails.scrollTop @meteorDetails[0].scrollHeight
          window.meteorDetails = @meteorDetails
          return
        # Set text in the panel
        @meteorDetails.html 'Meteor is launched'
        @meteorStatus.html '<i class="fa fa-gear
          text-hightlight faa-spin animated"></i>'
