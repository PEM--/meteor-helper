{View} = require 'atom'

module.exports =
class MeteorHelperView extends View
  @content: ->
    @div class: 'meteor-helper overlay from-top', =>
      @div "The MeteorHelper package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "meteor-helper:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "MeteorHelperView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
