{View, BufferedProcess, $} = require 'atom'
fs = require 'fs'
path = require 'path'
Converter = new (require 'ansi-to-html')()

module.exports =

# Public: Main Meteor's view that extends the View prototype.
class MeteorHelperView extends View

  # Meteor's process
  @process: null

  # Public: Build the pane
  #
  # Returns: main's pane widget
  @content: ->
    @div click: 'onClick', class: 'meteor-helper
      tool-panel panel-bottom text-smaller', =>
      @div class: 'panel-heading status-bar tool-panel', =>
        @div class: 'status-bar-left pull-left meteor-logo'
        @div outlet: 'meteorStatus', class: 'status-bar-right pull-right', =>
          @span class: 'loading loading-spinner-tiny inline-block'
      @div class: 'panel-body', =>
        @div outlet: 'meteorDetails', class: 'meteor-details'

  # Public: Initialize the current package
  #
  # serializeState - The [description] as {[type]}.
  #
  # Returns: `undefined`
  initialize: (serializeState) ->
    # Import Velocity into the main window's context
    # Trick its importation so that it understands that jQuery is present
    window.jQuery = $
    window.velocity = require '../node_modules/velocity-animate/' + \
      'jquery.velocity.js'
    # Pane is closed by default
    @isPaneOpened = false
    # Current pane status
    @paneIconStatus = null
    # Display Meteor's pane
    atom.workspaceView.command 'meteor-helper:toggle', => @toggle()

  # Public: Returns an object that can be retrieved when package is activated
  #
  # Returns: `undefined`
  serialize: ->

  # Public: Tear down any state and detach
  #
  # Returns: `undefined`
  destroy: -> @detach()

  # Public: On click, make the pane appearing or disappearing
  #
  # evt - The event as EventType.
  #
  # Returns: `undefined`
  onClick: (evt) =>
    height = if @isPaneOpened then 25 else 150
    @isPaneOpened = not @isPaneOpened
    @velocity
      properties:
        height: height
      options:
        duration: 100

  # Public: Launch or kill the pane and the Meteor process
  #
  # Returns: `undefined`
  toggle: ->
    # Check if Meteor is launched
    if @hasParent()
      # Fade out the pane before destroying it
      @velocity 'fadeOut', duration: 100
      # FIXME This is just a hack. It seems that 'complete' callback in
      #  Velocity have an issue.
      setTimeout =>
        # Detach pane from the editor's view
        @detach()
        # Kill Meteor's process if it's running
        @process?.kill()
      , 100
    else
      # Set an initial message before appending the panel
      @setMsg 'WAITING', 'Launching Meteor...'
      # Clear height if it has been modified formerly
      @height 25
      @isPaneOpened = false
      # Fade the panel in
      @velocity 'fadeIn', duration: 100, display: 'block'
      # Add the view to the current workspace
      atom.workspaceView.prependToBottom @
      # Get the current assigned value for Meteorite
      @meteorPath = atom.config.get 'meteor-helper.meteorPath'
      # Check if the command is installed on the system
      fs.exists @meteorPath, (isCliDefined) =>
        # Set an error message if Meteor CLI cannot be found
        unless isCliDefined
          @setMsg 'ERROR', "<h3>Meteor command not found: #{@meteorPath}</h3>
            <p>You can override these setting in this package preference.</p>"
          return
        # Chef if the current project owns a Meteor project
        meteor_project_path = path.join atom.project.path, '.meteor'
        fs.exists meteor_project_path, (isPrjCreated) =>
          # Set an error message if no Meteor project is found
          unless isPrjCreated
            @setMsg 'ERROR', '<h3>No Meteor project found.</h3>'
            return
          @process = new BufferedProcess
            command: @meteorPath
            options: cwd: atom.project.path
            stdout: @paneAddInfo
            stderr: @paneAddErr
            exit: @paneAddExit
          # Wait for the appropriate launching message
          @setMsg 'WAITING', ''

  # Public: Force appearing of the pane
  #
  # Returns: `undefined`
  forceAppear: =>
    @isPaneOpened = true
    @velocity
      properties: height: 150
      options: duration: 100

  # Public: Set message in pane's details section
  #
  # status      - The status as String.
  # msg         - The message as String.
  # isAppended  - A flag for appending or replacing as Boolean.
  #
  # Returns: `undefined`
  setMsg: (status, msg, isAppended = false) ->
    switch status
      when 'INFO'
        unless @paneIconStatus is 'INFO'
          @meteorStatus.html '<i class="fa fa-check text-success"></i>'
      when 'WAITING'
        unless @paneIconStatus is 'WAITING'
          @meteorStatus.html '<i class="fa fa-gear text-highlight faa-spin
            animated"></i>'
      else
        unless @paneIconStatus is 'ERROR'
          @meteorStatus.html '<i class="fa fa-warning faa-flash animated
            text-warning"></i>'
        # When an error is detected, force appearance of the pane
        @forceAppear()
    if isAppended
      @meteorDetails.append msg
    else
      @meteorDetails.html msg
    # Ensure scrolling
    @meteorDetails.parent().scrollToBottom()

  # Patterns used for OK status on Meteor CLI's output
  PATTERN_METEOR_OK: ///
    App.running.at:         # Classic start of Meteor
    | remove.dep            # Removal of dependencies in Famono
    | Scan.the.folder       # End of requirements in Famono
    | Ensure.dependencies   # Generally after having fixed an error
  ///

  # Patterns used for error status on Meteor CLI's output
  PATTERN_METEOR_ERROR: ///
    [E|e]rror
  ///

  # Public: Add info in the pane and determine which type of info to add.
  #
  # output - The Meteor's CLI output as String.
  #
  # Returns: `undefined`
  paneAddInfo: (output) =>
    # Check for OK patterns
    status = if output.match @PATTERN_METEOR_OK then 'INFO'
    # Check for error patterns
    else if output.match @PATTERN_METEOR_ERROR then 'ERROR' else 'WAITING'
    # Display the message with the appropriare status
    msg = "<p>#{Converter.toHtml output}</p>"
    @setMsg status, msg, true

  # Public: Add error in the pane
  #
  # output - The Meteor's output as String.
  #
  # Returns: `undefined`
  paneAddErr: (output) =>
    msg = "<p class='text-error'>#{Converter.toHtml output}</p>"
    @setMsg 'ERROR', msg, true

  # Public: Add exit status in the pane.
  #
  # code - The Meteor's exit code as Integer.
  #
  # Returns: `undefined`
  paneAddExit: (code) =>
    # Nullify current process
    @process.kill()
    @process = null
    # Display the exit status
    msg = "<p class='text-error'>Meteor has exited with
      status code: #{code}</p>"
    @setMsg 'ERROR', msg, true
