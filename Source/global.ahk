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
    global SmartGitTitle                := "SmartGit"
    
    ; Exe
    global GoogleChromeExe              := "chrome.exe"
    global NotepadPlusPlusExe           := "notepad`+`+.exe"

    Init_NotepadPlusPlus()
    Init_VS()
    
    global DebugDuration                := 1000
    global trackDuration                := 1500
    
	; Scroll speeds of various programs
	global VisualStudio_ScrollRate := 10
	global GoogleChrome_ScrollUpRate := 15
	global GoogleChrome_ScrollDownRate := 10
	global Notepad_ScrollRate := 10
	
    ; Terminate all
    global TerminateAll                 := false
    
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
	global sizeX						:= 421
	global sizeY						:= 15
    global offsetFromMouse              := 5
    
    ; Magnet to top or bottom
    global magnetTop                    := false
}

Init_CommonVariables()
{
	WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,	; This will get me the Taskbar size
	
	global windowBarX			:= TX
	global windowBarY			:= TY
	global windowBarWidth		:= TW
	global windowBarHeight		:= TH
}

Init_NotepadPlusPlus()
{
    ; Buttons
    global NotepadPlusPlus_FindInFilesTitle := "Find in Files"
    global NotepadPlusPlus_FollowCurrentBox := "Button2"        ;Will be overwritten by sync
    global NotepadPlusPlus_InAllSubFoldersBox := "Button3"      ;Will be overwritten by sync  
    global NotepadPlusPlus_MatchWholeWordBox := "Button11"      ;Will be overwritten by sync
    global NotepadPlusPlus_MatchCaseBox := "Button12"           ;Will be overwritten by sync
    global NotepadPlusPlus_SearchField := "Edit1"               ;Will be overwritten by sync
    global NotepadPlusPlus_ReplaceField := "Edit2"              ;Will be overwritten by sync
    global NotepadPlusPlus_FollowCurrentBoxTitle := "Follow current doc`."
    global NotepadPlusPlus_InAllSubFoldersBoxTitle := "In all su`&b`-folders"
    global NotepadPlusPlus_MatchWholeWordBoxTitle := "Match `&whole word"
    global NotepadPlusPlus_MatchCaseBoxTitle := "Match \&case"
    global NotepadPlusPlus_SearchFieldTitle := "`&Find what"
    global NotepadPlusPlus_ReplaceFieldTitle := "Rep`&lace what"
    
    ; Constant defines
    global NotepadPlusPlus_CurrentText := "current"
    global NotepadPlusPlus_EntireText := "entire"
}

Init_VS()
{
    ; Buttons
    global VS_LookInBox := "0x21516"
    global VS_LookAtFileTypesBox := "0x20b22"
    global VS_MatchWholeWordBox := "0x314d2"
    global VS_MatchCaseBox := "0x314d8"
    global VS_SearchField := "0x61510"
    
    ; Constant defines
    global VS_Current := "current"
    global VS_Entire := "entire"
    global VS_EntireSolutionText := "Entire Solution"
    global VS_CurrentDocumentText := "Current Document"
}