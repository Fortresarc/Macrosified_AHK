
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Coding/ AraxisMerge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;------------------------------
;	Visual Studio NameOfCurrentFile is sent to clipboard
;
VSCopyNameOfCurrentFile()
{
    if( VSGetNameOfCurrentFile(out) )
    {
        clipboard := out
        return true
    }
    return false
}

;------------------------------
;	Visual Studio Gets NameOfCurrentFile "asdf.cpp"
;
VSGetNameOfCurrentFile( ByRef outTitle )
{
    global VisualStudioTitle
    if ( CheckWindowActive( VisualStudioTitle ) )
	{
        filePath := VSCopyFullPath()
        
        properFilePath := ReplaceIllegalChar(filePath)
        SplitPath, properFilePath, name, dir, ext, name_no_ext, drive
        outTitle := name
        
        OutputToDebugWindow( "Filename: "outTitle )
        return true
    }
    return false
}

;------------------------------
;	Visual Studio switch between header and cpp files
;
VSSwitchHeaderAndCpp()
{
    global VisualStudioTitle
    global NotepadPlusPlusTitle
    headerString := "`.h"
    cppString := "`.cpp"
    dynamicString := "asdf"
    switchedFileType := headerString
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
        filePath := VSCopyFullPath()
        
        if( InStr(filePath, headerString) )
        {
            ; Replace all .h with .cpp:
            StringReplace, switchedFilePath, filePath, %headerString%, %cppString%, All
            switchedFileType := cppString
        }
        else if ( InStr(filePath, cppString) )
        {
            ; Replace all .cpp with .h :
            StringReplace, switchedFilePath, filePath, %cppString%, %headerString%, All
            switchedFileType := headerString
        } 
        
        dynamicString := switchedFilePath
        
        ;ReplaceBackWithForwardSlash(dynamicString, outFilePath)
        if( FileExist(switchedFilePath) )
        {
            OutputToDebugWindow("Found :In same directory")
            run % devenv /edit switchedFilePath
            return true
        }
        else
        {
            properFilePath := ReplaceIllegalChar(switchedFilePath)
            SplitPath, properFilePath, name, dir, ext, name_no_ext, drive
            
            ; infoString := name_no_ext
            ; infoString .= switchedFileType
            ; infoString .= " in "
            ; infoString .= dir
            ; if( Continue("Can't find "infoString, "Do you want to search recursively?") == false )
                ; return false
            
            name_w_switchedFileType := name_no_ext
            name_w_switchedFileType .= switchedFileType
         
            ;StringLeft, fileDrive, dynamicString, 3   
            ;if( FindRecursively(name_w_switchedFileType, fileDrive, switchedFileType, outFilePath) )
            if( FindUsingCMD( name_w_switchedFileType, drive, switchedFileType, outFilePath) )
            {
                ; Remove all CR+LF's  (StringReplace, input and output can be the same)
                StringReplace, outFilePath, outFilePath, `r`n, , All
                
                OutputToDebugWindow("Found :"outFilePath)
                clipboard := outFilePath
                run % devenv /edit outFilePath
                return true
            }
            else
            {
                OutputToDebugWindow("Cannot find in "drive)
            }
        }
    }
    return false
}

;------------------------------
;	Visual Studio copy full path (Assumes VS is active window)
;
VSCopyFullPath()
{
    pauseInterval = 200
    
    clipboard = asdf
    clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.

    Send, {Alt Down}{-}{Alt Up}
    Sleep pauseInterval
    Send, f
    Sleep pauseInterval
    Send {Enter}
    Sleep pauseInterval

    ClipWait, 2  ; Wait for the clipboard to contain text.
    clipboard := clipboard		; Cannot put %% here, not sure why
    clipboard2 := ReplaceIllegalChar( clipboard )
    
    return clipboard2
}

;------------------------------
;	Open current file in Notepad++
;
VSOpenCurrentFileInNotepadPlusPlus()
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
    global SmartGitTitle
    
    pauseInterval = 200
    pauseIntervalLong = 800
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Open in Notepad`+`+")
		; Copy current line first
		copiedLine := CopyWholeLine()
		Sleep pauseInterval

		clipboard2 := VSCopyFullPath()
		
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
    else if ( CheckWindowActive( SmartGitTitle ) )
    {
        OutputToDebugWindow("Open in Notepad`+`+(SmartGit)")
        Send {Alt Down}{Insert}{Alt Up}
        
        ClipWait, 2  ; Wait for the clipboard to contain text.
        
        OpenNotepadPlusPlus(clipboard)
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
    global SmartGitTitle
    global WinMergeTitle 
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Forward history")
		Send, {Ctrl Down}{Shift Down}{-}{Ctrl Up}{Shift Up}
        return true
	}
	else if ( CheckWindowActive( AraxisMergeTitle )  )
	{
		OutputToDebugWindow("Next Diff(Araxis)")
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
    else if ( CheckWindowActive( SmartGitTitle ) )
    {
        OutputToDebugWindow("Next Diff(SmartGit)")
        Send {F6}
        return true
    }
    else if ( CheckWindowActive( WinMergeTitle ) )
    {
        OutputToDebugWindow("Next Diff(WinMerge)")
        Send {Alt Down}{Down Down}{Alt Up}{Down Up}
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
    global SmartGitTitle
    global WinMergeTitle 
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("Reverse history")
		Send, {Ctrl Down}{-}{Ctrl Up}
        return true
	}
	else if ( CheckWindowActive( AraxisMergeTitle ) )
	{
		OutputToDebugWindow("Prev Diff(Araxis)")
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
    else if ( CheckWindowActive( SmartGitTitle ) )
    {
        OutputToDebugWindow("Prev Diff(SmartGit)")
        Send {Shift Down}{F6}{Shift Up}
        return true
    }
    else if ( CheckWindowActive( WinMergeTitle ) )
    {
        OutputToDebugWindow("Prev Diff(WinMerge)")
        Send {Alt Down}{Up Down}{Alt Up}{Up Up}
        return true
    }
    
	return false
}

;------------------------------
;	Notepad++ Synchronise all the Control ids everytime since it changes all the time
;
SyncControlIdsOfNotepadPlusPlus()
{
    global NotepadPlusPlus_FollowCurrentBox
    global NotepadPlusPlus_InAllSubFoldersBox
    global NotepadPlusPlus_SearchField
    global NotepadPlusPlus_ReplaceField
    global NotepadPlusPlus_MatchWholeWordBox
    global NotepadPlusPlus_MatchCaseBox
    
    global NotepadPlusPlus_FollowCurrentBoxTitle 
    global NotepadPlusPlus_InAllSubFoldersBoxTitle 
    global NotepadPlusPlus_SearchFieldTitle 
    global NotepadPlusPlus_ReplaceFieldTitle
    global NotepadPlusPlus_MatchWholeWordBoxTitle 
    global NotepadPlusPlus_MatchCaseBoxTitle 
    
    
    if( GetControlIdFromText(NotepadPlusPlus_FollowCurrentBoxTitle, NotepadPlusPlus_FollowCurrentBox ) 
    && GetControlIdFromText(NotepadPlusPlus_InAllSubFoldersBoxTitle, NotepadPlusPlus_InAllSubFoldersBox)
    && GetControlIdFromText(NotepadPlusPlus_SearchFieldTitle, NotepadPlusPlus_SearchField)
    && GetControlIdFromText(NotepadPlusPlus_ReplaceFieldTitle, NotepadPlusPlus_ReplaceField)
    && GetControlIdFromText(NotepadPlusPlus_MatchWholeWordBoxTitle, NotepadPlusPlus_MatchWholeWordBox)
    && GetControlIdFromText(NotepadPlusPlus_MatchCaseBoxTitle, NotepadPlusPlus_MatchCaseBox))
    {
        return true
    }
    return false
}

;------------------------------
;	Find all Notepad++ Slow (Unused)
;
NotepadPlusPlus_FindAll_Slow( where )
{
    ; send focus back to "Follow current doc." directory
    ; NOTE: If already selected it will still work
    Loop 5
    {
        Sleep 50
        Send {Tab}
    }
    
    ; Check follow current    
    Send, {Space}
    
    ; Check sub folders 
    ; NOTE: If already selected it MAY NOT work
    Send, {Tab}
    Send, {Space}
    
    ; Send focus to search field
    Send, {f}
    
    return true
}

;------------------------------
;	Find all Notepad++
;
NotepadPlusPlus_FindAll( where )
{   
    global NotepadPlusPlus_FindInFilesTitle
    global NotepadPlusPlus_FollowCurrentBox
    global NotepadPlusPlus_InAllSubFoldersBox
    global NotepadPlusPlus_SearchField
    global NotepadPlusPlus_ReplaceField
    global NotepadPlusPlus_MatchWholeWordBox
    global NotepadPlusPlus_MatchCaseBox
    global NotepadPlusPlus_EntireText
    global NotepadPlusPlus_CurrentText

    SyncControlIdsOfNotepadPlusPlus()

    ; Refreshes the whole Search UI
    Control, Hide, , , , %NotepadPlusPlus_FindInFilesTitle% 
    Control, Show, , , , %NotepadPlusPlus_FindInFilesTitle% 
    
    if ( where == NotepadPlusPlus_EntireText )
    {
        ; Match whole word
        Control, UnCheck, , %NotepadPlusPlus_MatchWholeWordBox%, %NotepadPlusPlus_FindInFilesTitle%
        
        ; Match case
        Control, UnCheck, , %NotepadPlusPlus_MatchCaseBox%, %NotepadPlusPlus_FindInFilesTitle%
    }
    else if ( where == NotepadPlusPlus_CurrentText )
    {
        ; Match whole word
        Control, Check, , %NotepadPlusPlus_MatchWholeWordBox%, %NotepadPlusPlus_FindInFilesTitle%
        
        ; Match case
        Control, Check, , %NotepadPlusPlus_MatchCaseBox%, %NotepadPlusPlus_FindInFilesTitle%
    }
    
    ; Search in current dir
    ;ControlGet, checked, Checked , , %NotepadPlusPlus_FollowCurrentBox%, %NotepadPlusPlus_FindInFilesTitle%    
    Control, Check, , %NotepadPlusPlus_FollowCurrentBox%, %NotepadPlusPlus_FindInFilesTitle%
    
    ; Search recursively
    Control, Check, , %NotepadPlusPlus_InAllSubFoldersBox%, %NotepadPlusPlus_FindInFilesTitle%
    
    
    ; Focus search field
    Control, Show, , %NotepadPlusPlus_SearchField%, %NotepadPlusPlus_FindInFilesTitle%

    ; Replace field should be empty
    ControlSetText, %NotepadPlusPlus_ReplaceField%, , %NotepadPlusPlus_FindInFilesTitle%   
        
    ; Refreshes the whole Search UI
    Control, Show, , , %NotepadPlusPlus_FindInFilesTitle%     
}

;------------------------------
;	Find all helper in Visual Studio, slow because we tab to the control box rather than
;   selecting it instantly
;
VS_FindAll_Slow(where)
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
    global VS_Current
    global VS_Entire
    global VS_EntireSolutionText
    global VS_CurrentDocumentText
    
    Send {Tab}  
    Sleep 50
    
    if ( where == VS_Entire )
    {
        SendTextImmediately( VS_EntireSolutionText )
    }
    else if( where == VS_Current ) 
    {
        SendTextImmediately( VS_CurrentDocumentText )
    }
    else
    {
        SendTextImmediately( where )
    }
    ; send focus back to search field
    Send {Shift Down}{Tab}{Shift Up}
        
    ;Send, {Enter}
    return true
}

;------------------------------
;	Find all helper (Fast) in Visual Studio
;   Selecting it instantly. HOWEVER! the control id(unique), classNN keeps changing so
;   I can't use this version. 
;
VS_FindAll( where, searchWindowTitle )
{
    global VS_LookInBox
    global VS_LookAtFileTypesBox
    global VS_MatchWholeWordBox
    global VS_MatchCaseBox
    global VS_SearchField
    
    ; Constant defines
    global VS_Current
    global VS_Entire
    global VS_EntireSolutionText
    global VS_CurrentDocumentText

    ; Refreshes the whole Search UI
    Control, Show, , , %searchWindowTitle% 
    
    if ( where == VS_Entire )
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
    else if ( where == VS_Current )
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
;	Find all VS in Entire document
;
VSFindAll_Entire()
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
    global NotepadPlusPlus_EntireText
    global NotepadPlusPlus_FindInFilesTitle
    global VS_Entire
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("VS Find all `(Entire`)")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 100
        
        VS_FindAll_Slow( VS_Entire )
        
		return true
	}
    else if (CheckWindowActive( NotepadPlusPlusTitle ) ||  CheckWindowActive( NotepadPlusPlus_FindInFilesTitle )) 
    {
		OutputToDebugWindow("Find all `(Entire`) Notepad++")
        if( CheckWindowActive( NotepadPlusPlus_FindInFilesTitle ) )
            WinClose, %NotepadPlusPlus_FindInFilesTitle%

		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 10
        
        NotepadPlusPlus_FindAll( NotepadPlusPlus_EntireText )
        ;NotepadPlusPlus_FindAll_Slow( NotepadPlusPlus_CurrentText )
        
        return true
    }
    
	return false
}

;------------------------------
;	Find all VS in Current document
;
VSFindAll_Current()
{
	global VisualStudioTitle
    global NotepadPlusPlusTitle
    global NotepadPlusPlus_FindInFilesTitle
    global NotepadPlusPlus_CurrentText
    global VS_Current
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
		OutputToDebugWindow("VS Find all `(Current`)")
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 100
		
        VS_FindAll_Slow( VS_Current )
        
		return true
	}
    else if (CheckWindowActive( NotepadPlusPlusTitle ) ||  CheckWindowActive( NotepadPlusPlus_FindInFilesTitle )) 
    {
		OutputToDebugWindow("Find all `(Current`) Notepad++")
        if( CheckWindowActive( NotepadPlusPlus_FindInFilesTitle ) )
            WinClose, %NotepadPlusPlus_FindInFilesTitle%
        		
		Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 10
        
        NotepadPlusPlus_FindAll( NotepadPlusPlus_CurrentText )
        ;NotepadPlusPlus_FindAll_Slow( NotepadPlusPlus_CurrentText )
        
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
    global VS_Entire
    global VS_SearchField
	functionChar := "`:`:"
    
	if ( CheckWindowActive( VisualStudioTitle ) )
	{
        Send, {Ctrl Down}{Shift Down}{f}{Ctrl Up}{Shift Up}
		Sleep 50
		
        WinGetTitle, searchWindowTitle, A
        VS_FindAll( VS_Entire, searchWindowTitle )
    
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
