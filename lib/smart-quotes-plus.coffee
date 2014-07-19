# Test case:
#   "'test' test 'test'" and "test" and 'test' 'tis 'twas '90 '90s '90a ... (C) (R) (TM) 1--2 a--b c---d ---
# Yields:
#   “‘test’ test ‘test’” and “test” and ‘test’ ’tis ’twas ’90 ’90s ‘90a … © ® ™ 1–2 a--b c—d ---
module.exports =
  activate: ->
    atom.workspaceView.command "smart-quotes-plus:smartreplace", => @smartreplace()

  smartreplace: ->
    editor = atom.workspace.activePaneItem
    text = editor.getText()

    open_double_single = "“‘"
    open_double = "“"
    open_single = "‘"
    close_single_double = "’”"
    close_double = "”"
    close_single = "’"

    #quotes
    text = text.replace /"'(?=\w)/g, ($0) -> open_double_single
    text = text.replace /([\w\.\!\?\%])'"/g, ($0, $1) -> $1+close_single_double
    text = text.replace /"(?=\w)/g, ($0) -> open_double
    text = text.replace /([\w.!?%])"/g, ($0, $1) -> $1+close_double
    text = text.replace /([\w.!?%])'/g, ($0, $1) -> $1+close_single
    text = text.replace /([\s])'(?=(tis\b|twas\b))/g, ($0, $1) -> $1+close_single
    text = text.replace /(\s)'(?=[0-9]+s*\b)/g, ($0, $1) -> $1+close_single
    text = text.replace /([^\w])'(?=\w)/g, ($0, $1, $2) -> $1+open_single

    # misc chars
    text = text.replace /\.\.\./g, "…"
    text = text.replace /\(C\)/g, "©"
    text = text.replace /\(R\)/g, "®"
    text = text.replace /\(TM\)/g, "™"
    text = text.replace /([\w])---(?=[a-z])/g, ($0, $1) -> $1+"—"
    text = text.replace /([0-9])--(?=[0-9])/g, ($0, $1) -> $1+"–"

    editor.setText(text)
    #editor.insertText("TEST")