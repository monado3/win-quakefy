; --- VirtualDesktopAccessor.dll integration ---
VDA_PATH := A_ScriptDir . "\VirtualDesktopAccessor.dll"
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", VDA_PATH, "Ptr")

MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")
GetCurrentDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetCurrentDesktopNumber", "Ptr")

MoveWindowToCurrentDesktop(hwnd) {
    global MoveWindowToDesktopNumberProc, GetCurrentDesktopNumberProc
    currentDesktop := DllCall(GetCurrentDesktopNumberProc, "Int")
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", hwnd, "Int", currentDesktop, "Int")
}
