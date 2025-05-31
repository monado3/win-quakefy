#Requires AutoHotkey v2.0
#SingleInstance force

; スクリプトを常駐させる
Persistent()

; ウィンドウタイトルのマッチモードを設定 (完全一致)
SetTitleMatchMode(3)

; 非表示ウィンドウも検出する設定
DetectHiddenWindows(true)

; --- 設定 ---
Global TargetWinTitle := "Stack" ; 操作対象ウィンドウのタイトル
Global Hotkey_Toggle := "^["  ; ホットキー
Global IsStackWindowHidden := false ; ウィンドウが隠されているかどうかを管理する変数 (初期値: false = 表示されている可能性あり)
Global stackWinId := "" ; ウィンドウIDを格納する変数
Global isHidden := false
Global lastActiveWinId := ""

IsInitalized() {
    Global stackWinId
    return StrCompare(stackWinId, "") != 0
}

; 対象ウィンドウの表示/非表示を切り替える関数
ToggleStackWindow(*) {
    Global isHidden, stackWinId, TargetWinTitle, lastActiveWinId

    if !isInitalized() || !WinExist(stackWinId) {
        stackWinId := WinExist(TargetWinTitle) ; ウィンドウのID (HWND) を取得
    }
    if !WinExist(stackWinId) {
        MsgBox("`"" . TargetWinTitle . "`" というウィンドウが見つかりません。")
        ; ここにアプリケーションを起動するコマンドを追加することもできます。 ; 例: Run("C:\Path\To\Your\StackApp.exe")
        return
    }

    if !isHidden && WinActive(stackWinId) {
        WinHide(stackWinId)
        isHidden := true
        if (lastActiveWinId != "" && WinExist(lastActiveWinId)) {
            WinActivate(lastActiveWinId) ; 最後にアクティブだったウィンドウをアクティブにする
        }
    } else {
        lastActiveWinId := WinGetID("A")
        WinShow(TargetWinTitle)
        isHidden := false
        WinActivate(stackWinId)
        WinWaitActive(stackWinId)
    }
}

; --- ホットキーとメッセージハンドラの定義 ---
HotKey(Hotkey_Toggle, ToggleStackWindow) ; ホットキーを設定
