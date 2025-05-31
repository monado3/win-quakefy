#Requires AutoHotkey v2.0
#SingleInstance force

; Performance and responsiveness settings
ListLines 0
SendMode "Input"
SetWorkingDir A_ScriptDir
KeyHistory 0
; #WinActivateForce
SetWinDelay -1
SetControlDelay -1

Persistent() ; Keep the script running
SetTitleMatchMode(3) ; (3 = exact match for window titles)
DetectHiddenWindows(true)

; --- Configuration ---
TargetWinTitle := "Stack" ; Title of the window to operate on
HotkeyForToggle := "^["

stackWinId := ""
lastActiveWinId := ""

#Include vd_library.ahk

IsInitalized() {
    Global stackWinId
    return StrCompare(stackWinId, "") != 0
}

ToggleTargetWindow(*) {
    Global stackWinId, TargetWinTitle, lastActiveWinId

    if !isInitalized() || !WinExist(stackWinId) {
        stackWinId := WinExist(TargetWinTitle) ; Get the ID (HWND) of the target window
    }
    if !WinExist(stackWinId) {
        MsgBox("`"" . TargetWinTitle . "`" not found.")
        ; Optional: Add code here to launch the application if it's not running.
        ; Example: Run("C:\Path\To\Your\StackApp.exe")
        return
    }

    if WinActive(stackWinId) {
        WinHide(stackWinId)
        if (lastActiveWinId != "" && WinExist(lastActiveWinId)) {
            WinActivate(lastActiveWinId)
        }
    } else {
        MoveWindowToCurrentDesktop(stackWinId)
        lastActiveWinId := WinGetID("A")
        WinShow(stackWinId)
        WinActivate(stackWinId)
        WinWaitActive(stackWinId)
    }
}

; --- Hotkey Definition ---
HotKey(HotkeyForToggle, ToggleTargetWindow)
