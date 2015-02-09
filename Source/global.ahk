Init()

Init()
{
	Init_DebugWindowSettings()

	Init_CommonVariables()
	
	global GoogleChromeTitle 			:= "Google Chrome"
	global VisualStudioTitle 			:= "Microsoft Visual Studio"
	global AraxisMergeTitle 			:= "Araxis Merge"
	global NotepadTitle 				:= "Notepad"
	global NotepadPlusPlusTitle 		:= "Notepad`+`+"
	global DebugWindowTitle 			:= "DebugMYGUI"
    global AutoHotKeyTitle              := "AutoHotkey"
    
    ; Exe
    global GoogleChromeExe              := "chrome.exe"
    global NotepadPlusPlusExe           := "notepad`+`+.exe"

	; Scroll speeds of various programs
	global VisualStudio_ScrollRate := 10
	global GoogleChrome_ScrollUpRate := 15
	global GoogleChrome_ScrollDownRate := 10
	global Notepad_ScrollRate := 10
	
	return
}

Init_DebugWindowSettings()
{
	; Shows the debug text window
	global EnableDebugWindow 			:= true
	global UseLastStoredDebugWindowPos	:= true
	global DisableMaximizeDebugWindow	:= true
	global PosX 						:= 1404 
	global PosY 						:= 994
	global MarginX 						:= 2
	global MarginY 						:= 1
	global TextFont 					:= "Arial"		;Text must be in ""
	global TextColor 					:= "cGray"
	global BGColor						:= "E8E8FF"
	global sizeX						:= 121
	global sizeY						:= 15
}

Init_CommonVariables()
{
	WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,	; This will get me the Taskbar size
	
	global windowBarX			:= TX
	global windowBarY			:= TY
	global windowBarWidth		:= TW
	global windowBarHeight		:= TH
}