# Test case:
#   "'test' test 'test'" and "test" and 'test' 'tis 'twas '90 '90s '90a
# Yields:
#   “‘test’ test ‘test’” and “test” and ‘test’ ’tis ’twas ’90 ’90s ‘90a

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor', 'smart-quotes-plus:smartreplace', ->
      editor = atom.workspace.getActiveTextEditor()
      smartreplace(editor)
    atom.commands.add 'atom-text-editor', 'smart-quotes-plus:dumbreplace', ->
      editor = atom.workspace.getActiveTextEditor()
      dumbreplace(editor)

smartreplace = (editor) ->
  point = editor.getCursorBufferPosition()
  if editor.getSelectedText().length == 0
    editor.selectAll()
  text = editor.getSelectedText()
  editor.insertText(doreplacement(text))
  editor.setCursorBufferPosition(point)

dumbreplace = (editor) ->
  point = editor.getCursorBufferPosition()
  if editor.getSelectedText().length == 0
    editor.selectAll()
  text = editor.getSelectedText()
  editor.insertText(dodumbreplacement(text))
  editor.setCursorBufferPosition(point)

doreplacement = (text) ->
  open_double_single = "“‘"
  open_single_double = "‘“"
  open_double = "“"
  open_single = "‘"
  close_single_double = "’”"
  close_double_single = "”’"
  close_double = "”"
  close_single = "’"

  # quotes
  text = text.replace /"'(?=\w)/g, ($0) ->
    open_double_single
  text = text.replace /([\w\.\!\?\%,])'"/g, ($0, $1) ->
    $1+close_single_double
  text = text.replace /'"(?=\w)/g, ($0) ->
    open_single_double
  text = text.replace /([\w\.\!\?\%,])"'/g, ($0, $1) ->
    $1+close_double_single
  text = text.replace /"(?=\w)/g, ($0) ->
    open_double
  text = text.replace /([\w.!?%,])"/g, ($0, $1) ->
    $1+close_double
  text = text.replace /([\w.!?%,])'/g, ($0, $1) ->
    $1+close_single

  # single tick use cases
  text = text.replace /([\s])'(?=(tis\b|twas\b))/g, ($0, $1) ->
    $1+close_single
  text = text.replace /(\s)'(?=[0-9]+s*\b)/g, ($0, $1) ->
    $1+close_single
  text = text.replace /([^\w]|^)'(?=\w)/g, ($0, $1, $2) ->
    $1+open_single

  return text

dodumbreplacement = (text) ->
  # quotes
  text = text.replace /“|”/g, "\""
  text = text.replace /‘|’/g, "'"

  return text
