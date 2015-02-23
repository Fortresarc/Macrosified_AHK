
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Coding/ AraxisMerge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;------------------------------
;	Open current file in Notepad++
;
VSOpenCurrentFileInNotepadPlusPlus()
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
    pauseInterval = 200
    pauseIntervalLong = 800
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Open in Notepad`+`+")
		; Copy current line first
		copiedLine := CopyWholeLine()
		Sleep pauseInterval

		clipboard = asdf
		clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.

		Send, {Alt Down}{-}{Alt Up}
		Sleep pauseInterval
		Send, f
		Sleep pauseInterval
		Send {Enter}
		Sleep pauseInterval
	;	Send, {Enter}

		ClipWait, 2  ; Wait for the clipboard to contain text.
		clipboard := clipboard		; Cannot put %% here, not sure why
		clipboard2 := ReplaceIllegalChar( clipboard )
		
		TimedToolTip( clipboard2, 1000 )

		Sleep pauseInterval

		OpenNotepadPlusPlus(clipboard2)

		Sleep pauseIntervalLong

		if ( CheckWindowExist( NotepadPlusPlusTitle ) )
		{
			WinActivate
			Sleep pauseInterval
			
			; Find the line
			Send ^f
			Sleep pauseInterval
            SendTextImmediately( copiedLine )
			Send ^{Enter}
			Sleep pauseInterval
			Send {Esc}
		}
		return true
	}	
	return false
}

;------------------------------
;	Forward history
;
Forward()
{
	global VisualStudioTitle
	global AraxisMergeTitle
    global GoogleChromeTitle
    global NotepadPlusPlusTitle
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Forward history")
		Send, {Ctrl Down}{Shift Down}{-}{Ctrl Up}{Shift Up}
        return true
	}
	else if ( CheckWindowActive( AraxisMergeTitle )  )
	{
		OutputToDebugWindow("Next Diff")
		Send, {F8}
        return true
	}
    else if ( CheckWindowActive( GoogleChromeTitle ) )
    {
        OutputToDebugWindow("Next Tab")
        Send {Ctrl Down}{Tab}{Ctrl Up}
        return true
    }
    else if( CheckWindowActive( NotepadPlusPlusTitle ) )
    {
        OutputToDebugWindow("Prev Tab")
        Send {Ctrl Down}{PgDn}{Ctrl Up}
        return true
    }
	return false
}

;------------------------------
;	Reverse history
;
Reverse()
{
	global VisualStudioTitle
	global AraxisMergeTitle
    global GoogleChromeTitle
    global NotepadPlusPlusTitle
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Reverse history")
		Send, {Ctrl Down}{-}{Ctrl Up}
        return true
	}
	else if ( CheckWindowActive( AraxisMergeTitle ) )
	{
		OutputToDebugWindow("Prev Diff")
		Send, {F7}
        return true
	}
    else if ( CheckWindowActive( GoogleChromeTitle ) )
    {
        OutputToDebugWindow("Prev Tab")
        Send {Ctrl Down}{Shift Down}{Tab}{Ctrl Up}{Shift Up}
        return true
    }
    else if( CheckWindowActive( NotepadPlusPlusTitle ) )
    {
        OutputToDebugWindow("Prev Tab")
        Send {Ctrl Down}{PgUp}{Ctrl Up}
        return true
    }
	return false
}

NotepadPlusPlus_FindAll( where )
{
    global NotepadPlusPlus_FindInFilesTitle
    global NotepadPlusPlus_FollowCurrentBox
    global NotepadPlusPlus_InAllSubFoldersBox
    global NotepadPlusPlus_SearchField
    global NotepadPlusPlus_ReplaceField
    global NotepadPlusPlus_MatchWholeWordBox
    global NotepadPlusPlus_MatchCaseBox

    ; Refreshes the whole Search UI
    Control, Show, , , %NotepadPlusPlus_FindInFilesTitle% 
    
    if ( where == NotepadPlusPlus_EntireText )
    {
        ; Search in current dir
        ;ControlGet, checked, Checked , , %NotepadPlusPlus_FollowCurrentBox%, %NotepadPlusPlus_FindInFilesTitle%
        Control, Check, , %NotepadPlusPlus_FollowCurrentBox%, %NotepadPlusPlus_FindInFilesTitle%
    
        ; Search recursively
        Control, Check, , %NotepadPlusPlus_InAllSubFoldersBox%, %NotepadPlusPlus_FindInFilesTitle%
    }
    else if ( where == NotepadPlusPlus_CurrentText )
    {
        ; Search in current dir
        Control, Uncheck, , %NotepadPlusPlus_FollowCurrentBox%, %NotepadPlusPlus_FindInFilesTitle%
        
        ; Search recursively
        Control, Uncheck, , %NotepadPlusPlus_InAllSubFoldersBox%, %NotepadPlusPlus_FindInFilesTitle%
    }
    
    ; Match whole word
    Control, Check, , %NotepadPlusPlus_MatchWholeWordBox%, %NotepadPlusPlus_FindInFilesTitle%
    
    ; Match case
    Control, Check, , %NotepadPlusPlus_MatchCaseBox%, %NotepadPlusPlus_FindInFilesTitle%        
    
    ; Focus search field
    Control, Show, , %NotepadPlusPlus_SearchField%, %NotepadPlusPlus_FindInFilesTitle%

    ; Replace field should be empty
    ControlSetText, %NotepadPlusPlus_ReplaceField%, , %NotepadPlusPlus_FindInFilesTitle%   
        
    ; Refreshes the whole Search UI
    Control, Show, , , %NotepadPlusPlus_FindInFilesTitle% 
}

VS_FindAll( where, searchWindowTitle )
{
    global VS_LookInBox
    global VS_LookAtFileTypesBox
    global VS_MatchWholeWordBox
    global VS_MatchCaseBox
    global VS_SearchField
    
    ; Constant defines
    global VS_CurrentText
    global VS_EntireText
    global VS_EntireSolutionText
    global VS_CurrentDocumentText

    ; Refreshes the whole Search UI
    Control, Show, , , %searchWindowTitle% 
    
    if ( where == VS_EntireText )
    {
        ;
        ;   IMPORTANT NOTE: 
        ;   - Control, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]  
        ;     Control ... ahk_id %VS_MatchWholeWordBox% should be used as WinText
        ;
        ;   - ControlSetText [, Control, NewText, WinTitle, WinText, ExcludeTitle, ExcludeText]
        ;     ControlSetText ahk_id %VS_MatchWholeWordBox% should be used as WinTitle
        ;
        
        
        ; Match whole word
        ;ControlGet, checked, Checked , , %VS_MatchCaseBox%, %searchWindowTitle%    ; Also works but VS_MatchCaseBox := Edit5 --> Don't work after com restarts because name is dynamically assigned
        Control, UnCheck, , , ahk_id %VS_MatchWholeWordBox%
    
        ; Match case
        Control, UnCheck, , , ahk_id %VS_MatchCaseBox%
        
        ; Entire
        ControlSetText, , %VS_EntireSolutionText%, ahk_id %VS_LookInBox%   
    }
    else if ( where == VS_CurrentText )
    {
        ; Match whole word
        Control, Uncheck, , , ahk_id %VS_MatchWholeWordBox%
        
        ; Match case
        Control, Uncheck, , , ahk_id %VS_MatchCaseBox%
        
        ; Current
        ControlSetText, , %VS_CurrentDocumentText%, ahk_id %VS_LookInBox%   
    }
        
    ; Focus search field
    Control, Show, , , ahk_id %VS_SearchField%
        
    ; Refreshes the whole Search UI
    Control, Show, , , %searchWindowTitle% 
}
;------------------------------
;	Find all occurrences in Entire document
;
VSFindAll_Entire()
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
    global NotepadPlusPlus_EntireText
    global VS_EntireText
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Find all `(Entire`)")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 100
        
        WinGetTitle, searchWindowTitle, A
        OutputToDebugWindow( searchWindowTitle )
        VS_FindAll( VS_EntireText, searchWindowTitle )
        
		return true
	}
    else if (CheckWindowActive( NotepadPlusPlusTitle )) 
    {
		OutputToDebugWindow("Find all `(Entire`) Notepad++")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 10
        
        NotepadPlusPlus_FindAll( NotepadPlusPlus_EntireText )
        
        return true
    }
    
	return false
}

;------------------------------
;	Find all occurrences in Current document
;
VSFindAll_Current()
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
    global NotepadPlusPlus_CurrentText
    global VS_CurrentText
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Find all `(Current`)")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 100
		
        WinGetTitle, searchWindowTitle, A
        VS_FindAll( VS_CurrentText, searchWindowTitle )
        
		return true
	}
    else if (CheckWindowActive( NotepadPlusPlusTitle )) 
    {
		OutputToDebugWindow("Find all `(Current`) Notepad++")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 10
        
        NotepadPlusPlus_FindAll( NotepadPlusPlus_CurrentText )
        
        return true
    }
	return false
}

;------------------------------
;	My version on "Go to Definition" ONLY works for C++ codes
;
VSGoToDefinition()
{
	global VisualStudioTitle
    global VS_EntireText
    global VS_SearchField
	functionChar := "`:`:"
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
        Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 50
		
        WinGetTitle, searchWindowTitle, A
        VS_FindAll( VS_EntireText, searchWindowTitle )
    
        ControlGetText, origText, %VS_SearchField%, %searchWindowTitle%
        newText := functionChar . origText
        
        OutputToDebugWindow( "Goto Definition" )
        ControlSetText, %VS_SearchField%, %newText%, %searchWindowTitle%
        
        ; Send focus back to search field
        Control, Show, , %VS_SearchField%, %searchWindowTitle%
        
		return true
	}
	return false
}

;***************************************************************
;	Debugging					
;***************************************************************

;------------------------------
; Continue 
; 
VSContinue_PressedAndHold()
{
	global VisualStudioTitle
	; while ( GetKeyState("Alt", "P") && GetKeyState("LButton", "P") )
	; {
		;ToolTip, Run/ Continue
		if ( CheckWindowActive( VisualStudioTitle ) )
		{
			OutputToDebugWindow( "Continue" )
			Send, {F5 Down}
			return true
		}
	;}
	return false
}

VSContinue_Released()
{
	global VisualStudioTitle
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		Send, {F5 Up}
	}
}

;------------------------------
; Step Out
; 
VSStepOut()
{
	global VisualStudioTitle
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow( "Step out" )
		Send, {Shift Down}{F11}{Shift Up}
		return true
	}
	return false
}

;------------------------------
; Step Over
; 
VSStepOver()
{
	global VisualStudioTitle
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow( "Step Over" )
		Send, {F10} 
		return true
	}
	return false 
}

;------------------------------
; Step Into
; 
VSStepInto()
{
	global VisualStudioTitle
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow( "Step In" )
		Send, {F11}
		return true
	}
	return false
}

;------------------------------
; Watch current variable in Window 1
; 
VSWatchInWindow1()
{
	global VisualStudioTitle
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		While GetKeyState("Alt", "P") && GetKeyState("w", "P")
		{
			OutputToDebugWindow( "Watch variable" )
			Click
			Click
			Send, {Ctrl Down}{c}{Ctrl Up}

			Send, {Ctrl Down}
			Sleep 100
			Send, {Alt Down}
			Sleep 100
			Send {w Down}
			Sleep 100
			Send, {Ctrl Up}{Alt Up}{w Up}
			;Sleep 2000
		}
		Send, 1
		Sleep 1000
		Send, {Ctrl Down}{v}{Ctrl Up}
	}
	return false
}


;------------------------------
;	Stop Application
;
VSStop()
{
    global VisualStudioTitle
	if( CheckWindowActive( VisualStudioTitle ) )
	{
		SetTitleMatchMode 2

		CoordMode, Mouse, Screen	; This will set mouse move to use coordinates relative to screen and NOT active window
		MouseGetPos, StartX, StartY, WhichWindow
		WinGetActiveTitle, WinTitle

		;ToolTip, Stopping... %StartX% %StartY% %WinTitle%
		OutputToDebugWindow( "Stopping %StartX% %StartY% %WinTitle%" )

		Send, {Shift Down}{F5}{Shift Up}
		Sleep 100
    }
}

;------------------------------
;	Rerun:	Stop, Run and Refresh Your Application
;
VSStopAndRun()
{
	global VisualStudioTitle
	if( CheckWindowActive( VisualStudioTitle ) )
	{
		SetTitleMatchMode 2

		CoordMode, Mouse, Screen	; This will set mouse move to use coordinates relative to screen and NOT active window
		MouseGetPos, StartX, StartY, WhichWindow
		WinGetActiveTitle, WinTitle

		;ToolTip, Stopping... %StartX% %StartY% %WinTitle%
		OutputToDebugWindow( "Stopping %StartX% %StartY% %WinTitle%" )

		Send, {Shift Down}{F5}{Shift Up}
		Sleep 500

		; Set output window as front
		;Todo if WhichWindow
		;DllCall("SetCursorPos", int, 50, int, 1643)
		;Click

		Send {F5}
		Sleep 1000

		;ToolTip, Refreshing Your Application... %StartX% %StartY% %WinTitle%
		OutputToDebugWindow( "Refreshing Your Application..." )
		

		;ToolTip, Finishing... %StartX% %StartY% %WinTitle%
		OutputToDebugWindow( "Finishing..." )

		ifWinExist %WinTitle%
		{
			WinActivate
			Sleep 100

			DllCall("SetCursorPos", int, StartX, int, StartY)
			;MouseMove, StartX, StartY
		}
		ToolTip
		return true
	}
	return false
}

;------------------------------
;	Rerun:	Stop, Build 
;
VSStopAndBuild()
{
	global VisualStudioTitle
	if( CheckWindowActive( VisualStudioTitle ) )
	{
		SetTitleMatchMode 2

		CoordMode, Mouse, Screen	; This will set mouse move to use coordinates relative to screen and NOT active window
		MouseGetPos, StartX, StartY, WhichWindow
		WinGetActiveTitle, WinTitle

		;ToolTip, Stopping... %StartX% %StartY% %WinTitle%
		OutputToDebugWindow( "Stopping..." )

		Send, {Shift Down}{F5}{Shift Up}
		Sleep 500

		; Set output window as front
		;Todo if WhichWindow
		;DllCall("SetCursorPos", int, 50, int, 1643)
		;Click

		Send {F7}
		Sleep 1000

		;ToolTip, Finishing... %StartX% %StartY% %WinTitle%
		OutputToDebugWindow( "Finishing...")

		ifWinExist %WinTitle%
		{
			WinActivate
			Sleep 100

			DllCall("SetCursorPos", int, StartX, int, StartY)
			;MouseMove, StartX, StartY
		}
		ToolTip
		
		return true
	}
	return false
}

;------------------------------
;	Dock floating file
;
DockFloatingFileVisualStudio()
{
	global VisualStudioTitle
	
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		WinGetPos, X, Y, width, height, A
		WinRestore, A
		newX := X + 5
		newY := Y + 5		;assume the menu bar height is more than 3 
		
		DllCall("SetCursorPos", int, newX, int, newY)
		Click, right
	
		Send {RButton}
		Sleep 10
		Loop 6
			Send {Down}
		Send {Enter}
		
		return true
	}
	return false
}
