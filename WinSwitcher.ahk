#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/* CAPSLOCK WINDOWS SWITCHER
* Notice that this will let your left mouse can not drag.
* Do it by hold the alt button down then click once to start, click twice to stop dragging
* Or delete the LButton function but live with your own lack of full function
*/
; initial variables
lastwin := ""

; Tray icon
icon := "winswitcher.ico"
If FileExist(icon)
    Menu, Tray, Icon, %icon%

; Single click tray icon suspend
; https://autohotkey.com/boards/viewtopic.php?t=38761
; https://autohotkey.com/boards/viewtopic.php?t=6110
OnMessage(0x404, "AHK_NOTIFYICON")
AHK_NOTIFYICON(wParam, lParam, uMsg, hWnd)
{
	if (lParam = 0x201) ;WM_LBUTTONDOWN := 0x201
		suspend
}

; Hold mouse | Free hand Click and Drag
; https://autohotkey.com/board/topic/95066-minecraft-hold-left-mouse-button/
!LButton:: Send % "{Click " . ( GetKeyState("LButton") ? "Up}" : "Down}" )
 
$LButton::
    ; for WINDOWS SWITCHER FUNCTION
    CoordMode, Mouse, Screen
    MouseGetPos, x, y
    if (x > 40 && x < A_ScreenWidth / 2 + 200 && y > A_ScreenHeight - 40) {
        ; click on the programs on the taskbar area (height: 40px)
        WinGetTitle, lastwin, a
        Sleep 10
    }
    send {Lbutton}
return

; CAPSLOCK SWITCH WINDOWS | WINDOWS SWITCHER

CapsLock::
	if (lastwin) {
		WinGetTitle, thiswin, a
		Sleep 10
		if (thiswin == lastwin) {
			TrayTip, WinSwitcher, Last window title is the same with this window.
			send !{esc}
		}
		else {
			WinGetTitle, thiswin, a
			Sleep 10
			
			if (thiswin == "Task Switching") { ; windows default Task switcher
				send, !{esc}
				Sleep 10
				WinGetTitle, thiswin, a
			}
			
			WinActivate, %lastwin%
			TrayTip, WinSwitcher, ● Activated window: %lastwin%`n		----------------- `n● Stored new window: %thiswin%
			lastwin := thiswin
			
		}
	} else {
		WinGetTitle, lastwin, a
		send !{tab}
	}
return

/*
Capslock::
	lock := !lock
	if (lock)
	{
		Send, !{esc}
	}
	else
	{
		Send, !+{esc}
	}
	WinActivate, a
return
*/

/*
	CapsLock::	
		switch := !switch
		if switch
			Send !{esc}
		else
			Send !+{esc}
		WinActivate, a
	

		Send !{tab}
		if GetKeyState("Alt", "P")
		{
			Send {Alt up}
			TrayTip, MainKey, Alt is released, 1
		}
	return

*/
