
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
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Open in Notepad`+`+")
		; Copy current line first
		copiedLine := CopyWholeLine()
		Sleep 300

		clipboard = asdf
		clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.

		Send, {Alt Down}{-}{Alt Up}
		Sleep 300
		Send, f
		Sleep 300
		Send {Enter}
		Sleep 300
	;	Send, {Enter}

		ClipWait, 2  ; Wait for the clipboard to contain text.
		clipboard := clipboard		; Cannot put %% here, not sure why
		clipboard2 := ReplaceIllegalChar( clipboard )
		
		TimedToolTip( clipboard2, 1000 )

		Sleep 800

		OpenNotepadPlusPlus(clipboard2)

		Sleep 1500

		if ( CheckWindowExist( NotepadPlusPlusTitle ) )
		{
			WinActivate
			Sleep 300
			
			; Find the line
			Send ^f
			Sleep 100
			Send %copiedLine%
			Sleep 600
			Send ^{Enter}
			Sleep 600
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
		Send, {Ctrl Down}{-}{Ctrl Up}
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
		Send, {Ctrl Down}{Shift Down}{-}{Ctrl Up}{Shift Up}
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

;------------------------------
;	Find all occurrences in Entire document
;
VSFindAll_Entire()
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Find all `(Entire`)")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 50
		Send {Tab}
		Sleep 50
		Send, Entire Solution
		
		; send focus back to search field
		Loop 11
		{
			Sleep 50
			Send {Tab}
		}
		;Send, {Enter}
		return true
	}
    else if (CheckWindowActive( NotepadPlusPlusTitle )) 
    {
		OutputToDebugWindow("Find all `(Entire`) Notepad++")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 50
        
        ; send focus back to "Follow current doc." directory
        ; NOTE: If already selected it will still work
		Loop 5
		{
			Sleep 50
			Send {Tab}
		}
        Send, {Space}
        
        ; Search sub folders too
        ; NOTE: If already selected it MAY NOT work
        Send, {Tab}
        Send, {Space}
        Send, {Enter}
        
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
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Find all `(Current`)")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 50
		Send, {Tab}
		Sleep 50
		Send, Current Document

        ; Is one less than "Entire" because in current "Look at these file types" field is disabled
		; send focus back to search field
		Loop 10
		{
			Sleep 50
			Send {Tab}
		}
		;Send, {Enter}
		return true
	}
    else if (CheckWindowActive( NotepadPlusPlusTitle )) 
    {
		OutputToDebugWindow("Find all `(Current`) Notepad++")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 50
        
        ; send focus back to "Follow current doc." directory
		Loop 5
		{
			Sleep 50
			Send {Tab}
		}
        Send, {Space}   ; Checks the checkbox
        Send, {Enter}
        return true
    }
	return false
}

;------------------------------
;	My version on "Go to Definition"
;
VSGoToDefinition()
{
	global VisualStudioTitle
	functionChar := "`:`:"
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		;if( GetKeyState("Alt", "P") && GetKeyState("d", "P") )
		{
			; Select current word 
			Click
			Click

			OutputToDebugWindow( "Go to Definition" )
			; Find all in entire solution
			Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
			Sleep 900	;This is the optimal time to wait for Find all window

		
			Sleep 100
			clipboard = asdf
			clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.
			Send ^c
			ClipWait, 2  ; Wait for the clipboard to contain text.
			clipboard := clipboard		; Cannot put %% here, not sure why
			ToolTip, Goto Definition -> %clipboard%

			; Remove all CR+LF's from the clipboard contents:
			clipboard2 := RegExReplace(clipboard,"/")

		
			newStr := functionChar . clipboard2
			Send, %newStr%
			Sleep 100

			Send, {Tab}
			Send, Entire Solution

			ToolTip
		}
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
