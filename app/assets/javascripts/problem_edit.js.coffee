
$(document).ready ($) ->


  $("#inputText").wysihtml5 events:
    load: ->
      disabled = @textareaElement.disabled
      readonly = !!@textareaElement.getAttribute("readonly")
      if readonly
        @composer.element.setAttribute "contenteditable", false
        @toolbar.commandsDisabled = true
      if disabled
        @composer.disable()
        @toolbar.commandsDisabled = true

