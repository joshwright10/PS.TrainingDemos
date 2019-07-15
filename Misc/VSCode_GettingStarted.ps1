<#
.DESCRIPTION

    This file contains information aimed to help get setup and working with VS Code.
    The main focus is aimed towards using VS Code for PowerShell.

#>

<# Reasons to use VS Code for PowerShell

    -- PSScriptAnalyzer
    -- Code Formatting
    -- Remembers previously opened files, even unsaved ones
    -- Quickly find errors
    -- Built-in code snippets
    -- Suggestions
    -- Git integration
    -- Built-in Debugger

#>

<# Recommended VS Code Extensions for PowerShell
    Essential
        -- https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell

    Recommended
        -- https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker
#>


<# Recommended Preferences - PowerShell

    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.renderWhitespace": "all",
    "editor.renderControlCharacters": true,
    "files.trimTrailingWhitespace": true,
    "files.defaultLanguage": "powershell",
    "editor.quickSuggestions": {
        "other": true,
        "comments": true,
        "strings": true
    },

#>

<# Recommended Preferences - Code Spell Checker

    "cSpell.allowCompoundWords": true,
    "cSpell.diagnosticLevel": "Hint",
    "cSpell.language": "en-GB",
    "cSpell.enabledLanguageIds": [
        "powershell",
        "plaintext"
    ],
    "cSpell.dictionaries": [
        "powershell"
    ],
#>
# Setting diagnosticLevel to "Hint" stops any unrecognised words from being flagged by PSScriptAnalyzer


<# Useful Shortcuts

    -- Ctrl  + K +  C / Ctrl  + K +  U
    --- Comment out selected lines / Uncomment selected lines

    -- Ctrl + Shift + P / F1
    --- Show All Commands

    -- Ctrl + Space
    --- Trigger Suggest

    -- F8
    --- Runs Selection when working with PowerShell

    -- Ctrl + =
    --- Zoom in

    -- Ctrl + -
    --- Zoom out
#>