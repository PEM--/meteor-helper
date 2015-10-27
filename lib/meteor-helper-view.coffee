{View, $} = require 'atom-space-pen-views'
{BufferedProcess} = require 'atom'
fs = require 'fs'
path = require 'path'
velocity = require 'velocity-animate/velocity'

PANE_TITLE_HEIGHT_CLOSE = 26
PANE_TITLE_HEIGHT_OPEN = 150

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
    @velocity = velocity.bind @
    # Pane is closed by default
    @isPaneOpened = false
    # Current pane status
    @paneIconStatus = null
    # Register toggle and reset
    atom.commands.add 'atom-workspace',
      'meteor-helper:reset': => @reset()
      'meteor-helper:toggle': => @toggle()
      'meteor-helper:showHide': => @showHide()
    # Ensure destruction of Meteor's process
    $(window).on 'beforeunload', => @_killMeteor()

  # Public: Returns an object that can be retrieved when package is activated
  #
  # Returns: `undefined`
  serialize: ->

  # Public: On click, make the pane appearing or disappearing.
  #
  # evt - The event as EventType.
  #
  # Returns: `undefined`
  onClick: (evt) => @showHide()

  # Public: Make the pane appearing or disappearing.
  #
  # Returns: `undefined`
  showHide: =>
    @isPaneOpened = not @isPaneOpened
    height = if @isPaneOpened then PANE_TITLE_HEIGHT_OPEN \
      else PANE_TITLE_HEIGHT_CLOSE
    @velocity
      properties:
        height: height
      options:
        duration: 100

  # Private: Kill Meteor's process and its subprocess (Mongo).
  #
  # Returns the [Description] as `undefined`.
  _killMeteor: ->
    # Kill Meteor's process if it's running
    @process?.kill()
    # Only kill Mongo if it's Meteor's default one
    return unless @mongoURL is ''
    # Sometimes Mongo get stuck, force exit it
    new BufferedProcess
      command: 'killall'
      args: ['mongod']

  # Public static: Format a Meteor log.
  #
  # str - The log to check and format, if necessary.
  #
  # Returns Either a raw string or a formated Meteor log in HTML.
  @LogFormat = (str) ->
    # Remove ANSI colors
    raw = str.replace /\033\[[0-9;]*m/g, ''
    # Check if it's common message or a Meteor log
    pattern = ///
      ^([I,W])                    # Only take I or W
      \d{8}-                      # Remove the date
      (\d{2}:\d{2}:\d{2}.\d{3})   # Get the time
      \(\d\)\?\s(.*)              # Get the reason
    ///
    found = (raw.match pattern)?[1..3]
    return raw unless found
    # Format the Meteor log
    css_class = if found[0] is 'I' then 'text-info' else 'text-error'
    "<p><span class='#{css_class}'>#{found[1]}</span> #{found[2]}</p>"

  # Private: Display default pane.
  #
  # Returns: `undefined`
  _displayPane: ->
    # Set an initial message before appending the panel
    @paneIconStatus = 'WAITING'
    @setMsg 'Launching Meteor...'
    # Clear height if it has been modified formerly
    @height PANE_TITLE_HEIGHT_CLOSE
    @isPaneOpened = false
    # Fade the panel in
    @velocity 'fadeIn', duration: 100, display: 'block'
    # Add the view to the current workspace
    atom.workspace.addBottomPanel item: @

  # Private: Get and check settings.
  # Throws Error in case of wrong settings.
  # Returns: `undefined`
  _getSettings: ->
    # Get the configured Meteor's path, port and production flag
    @meteorAppPath = atom.config.get 'meteor-helper.meteorAppPath'
    @meteorPath = atom.config.get 'meteor-helper.meteorPath'
    @meteorPort = atom.config.get 'meteor-helper.meteorPort'
    @isMeteorProd = atom.config.get 'meteor-helper.production'
    @isMeteorDebug = atom.config.get 'meteor-helper.debug'
    @mongoURL = atom.config.get 'meteor-helper.mongoURL'
    @mongoOplogURL = atom.config.get 'meteor-helper.mongoOplogURL'
    @settingsPath = atom.config.get 'meteor-helper.settingsPath'
    # Check if the command is installed on the system
    isCliDefined = fs.existsSync @meteorPath
    # Set an error message if Meteor CLI cannot be found
    unless isCliDefined
      throw new Error "<h3>Meteor command not found: #{@meteorPath}</h3>
        <p>You can override these settings in this package preference or in a custom mup.json file.</p>"

    # Check for project specific settings
    mup_project_path = path.join atom.project.getPaths()[0], 'mup.json'
    isMupPrjCreated = fs.existsSync mup_project_path

    # Only overwrite settings if a `mup.json` is available
    if isMupPrjCreated
      try
        cnt = fs.readFileSync mup_project_path
        mup = JSON.parse cnt
        # Overwrite app path if it exists
        @meteorAppPath = mup.app if mup.app?
      catch err
        @paneIconStatus = 'WARNING'
        @setMsg "<h3>mup.json is corrupted: #{err}.
          Default back to current settings.</h3>"

    # Check if the current project owns a Meteor project
    meteor_project_path = path.join atom.project.getPaths()[0], @meteorAppPath, '.meteor'
    isPrjCreated = fs.existsSync meteor_project_path

    # Set an error message if no Meteor project is found
    unless isPrjCreated
      throw new Error "<h3>No Meteor project found in:</h3><br />#{meteor_project_path}"

    # Check if settings path exists
    _settingsPath =
      if @settingsPath[0] is '/'
        @settingsPath
      else
        path.join atom.project.getPaths()[0], @settingsPath
    isSettingsPathValid = fs.existsSync _settingsPath
    # Set an error if settings path is invalid
    unless isSettingsPathValid
      throw new Error "
        <h3>Unable to locate settings JSON file at: #{@settingsPath}</h3><br>
        <p>Please make sure the file exists, or remove it from settings.</p>"

  # Private: Modify process env and parse mup projects.
  #
  # Returns: `undefined`
  _modifyProcessEnv: ->
    # Tweek process path to circumvent Meteorite issue:
    # https://github.com/oortcloud/meteorite/issues/203
    process.env.PATH = "#{process.env.HOME}/.meteor/tools/" +
      "latest/bin:#{process.env.PATH}"
    # Check if Meteor should use a custom MongoDB
    if @mongoURL isnt ''
      # Set MongoDB's URL
      process.env.MONGO_URL = @mongoURL
    else
      # Unset former uses
      delete process.env.MONGO_URL if process.env.MONGO_URL?
    if @mongoOplogURL isnt ''
      # Set MongoDB's URL
      process.env.MONGO_OPLOG_URL = @mongoOplogURL
    else
      # Unset former uses
      delete process.env.MONGO_OPLOG_URL if process.env.MONGO_OPLOG_URL?
    # Check if a specific project file is available which could
    #  overwrite settings variables
    mup_project_path = path.join atom.project.getPaths()[0], 'mup.json'
    isMupPrjCreated = fs.existsSync mup_project_path
    # Only overwrite settings if a `mup.json` is available
    if isMupPrjCreated
      try
        cnt = fs.readFileSync mup_project_path
        mup = JSON.parse cnt
        process.env.MONGO_URL = mup.env.MONGO_URL if mup.env?.MONGO_URL?
        process.env.MONGO_OPLOG_URL = mup.env.MONGO_OPLOG_URL \
          if mup.env?.MONGO_OPLOG_URL?
        @meteorPort = mup.env.PORT if mup.env?.PORT?
      catch err
        @paneIconStatus = 'WARNING'
        @setMsg "<h3>mup.json is corrupted: #{err}.
          Default back to current settings.</h3>"

  # Public: Reset Meteor state and Mongo DB.
  #
  # Returns: `undefined`
  reset: =>
    # Check if Meteor is launched
    unless @hasParent()
      # Display main pane
      @_displayPane()
    try
      # Get and set settings
      @_getSettings()
      # Modify process env and check mup files
      @_modifyProcessEnv()
      @setMsg 'Project reset.'
      # Launch Meteor reset
      new BufferedProcess
        command: @meteorPath
        args: ['reset']
        options:
          cwd: path.join atom.project.getPaths()[0], @meteorAppPath
          env: process.env
      @setMsg 'Project reset.'
    catch err
      @paneIconStatus = 'ERROR'
      @setMsg err.message

  # Public: Launch or kill the pane and the Meteor process.
  #
  # Returns: `undefined`
  toggle: =>
    # Check if Meteor is launched
    if @hasParent()
      # Fade out the pane before destroying it
      @velocity 'fadeOut', duration: 100
      setTimeout =>
        # Detach pane from the editor's view
        @detach()
        # Kill former process
        @_killMeteor()
      , 100
      return
    # Display main pane
    @_displayPane()
    # Store args
    args = []
    try
      # Get and check settings
      @_getSettings()
      # Modify process env and check mup files
      @_modifyProcessEnv()
      # Check if the production flag needs to be added
      args.push '--production' if @isMeteorProd
      # Check if Meteor is in debug mode
      args.push 'debug' if @isMeteorDebug
      # Check if Meteor's port need to be configure
      args.push '--port', String @meteorPort if @meteorPort
      # Check if settings file should be configured
      args.push '--settings', String @settingsPath if @settingsPath
      # Launch Meteor
      @process = new BufferedProcess
        command: @meteorPath
        args: args
        options:
          cwd: path.join atom.project.getPaths()[0], @meteorAppPath
          env: process.env
        stdout: @paneAddInfo
        stderr: @paneAddErr
        exit: @paneAddExit
    catch err
      @paneIconStatus = 'ERROR'
      @setMsg err.message

  # Public: Force appearing of the pane
  #
  # Returns: `undefined`
  forceAppear: =>
    @isPaneOpened = true
    @velocity
      properties: height: PANE_TITLE_HEIGHT_OPEN
      options: duration: 100

  # Public: Set message in pane's details section
  #
  # msg         - The message as String.
  # isAppended  - A flag for appending or replacing as Boolean.
  #
  # Returns: `undefined`
  setMsg: (msg, isAppended = false) =>
    switch @paneIconStatus
      when 'INFO'
        @meteorStatus.html '<span class="icon-check text-success"></span>'
      when 'WAITING'
        @meteorStatus.html '<span class="icon-gear text-highlight
            faa-spin animated"></span>'
      else
        @meteorStatus.html '<span class="icon-alert faa-flash
            animated text-warning"></span>'
        # When an error is detected, force appearance of the pane
        @forceAppear()
    if isAppended
      @meteorDetails.append msg
    else
      @meteorDetails.html msg
    console.log '@meteorDetails', @meteorDetails
    # Ensure scrolling
    @meteorDetails.parent().css('top', 0).scrollToBottom()

  # Patterns used for OK status on Meteor CLI's output
  PATTERN_METEOR_OK: ///
    App.running.at:         # Classic start of Meteor
    | remove.dep            # Removal of dependencies in Famono
    | Scan.the.folder       # End of requirements in Famono
    | Ensure.dependencies   # Generally after having fixed an error
    | server.restarted      # Fresh code on Meteor's server
    | restarting            # Sometimes Meteor do use this one
  ///

  # Patterns used for error status on Meteor CLI's output
  PATTERN_METEOR_ERROR: ///
    [E|e]rror               # Basic error
    | STDERR                # Received a console.error
    | is.crashing           # Server crashing
    | Exited.with.code      # Another case of server crashing
  ///

  # Pattenrs used for detecting unworthy status changes
  # (like a simple console.log in the Meteor app)
  PATTERN_METEOR_UNCHANGED: ///
    I[0-9]                  # console.log statements starts with I and a date
  ///

  # Public: Add info in the pane and determine which type of info to add.
  #
  # outputs - The Meteor's CLI outputs as String.
  #
  # Returns: `undefined`
  paneAddInfo: (outputs) =>
    # Iterate over each new non blank lines
    # and weird white space extensions in the outputs
    tOuputs = outputs.split /\n|\ {8,}/
    for output in tOuputs when output isnt ''
      # spare former status
      oldstatus = @paneIconStatus
      # Check for OK patterns
      @paneIconStatus = if output.match @PATTERN_METEOR_OK then 'INFO'
      # Check for error patterns
      else if output.match @PATTERN_METEOR_ERROR then 'ERROR'
      else if output.match @PATTERN_METEOR_UNCHANGED then oldstatus
      else 'WAITING'
      # Display the message with the appropriare status
      msg = "<p>#{MeteorHelperView.LogFormat output}</p>"
      @setMsg msg, true

  # Public: Add error in the pane
  #
  # output - The Meteor's output as String.
  #
  # Returns: `undefined`
  paneAddErr: (output) =>
    msg = "<p class='text-error'>#{MeteorHelperView.LogFormat output}</p>"
    @paneIconStatus = 'ERROR'
    @setMsg msg, true

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
    @paneIconStatus = 'ERROR'
    @setMsg msg, true
