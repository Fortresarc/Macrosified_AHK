; TODOs
; - Ctrl Win Right has conficted with Ctrl RButton but we can't see it happen 
;	because Right is on keyboard while RButton is on mouse
;		-> Implement a new class to check if we can get the controls first before giving it 
;			access
;
;

;------------------------------
; Suspend the script
;
ahkSuspend()
{
    global VisualStudioTitle
    
    if( CheckWindowExist(VisualStudioTitle) == false )
    {
        Suspend
        return true
    }
    
    return false
}
;***************************************************************/
;	Normal Window Operation
;**************************************************************/
ActivateLastNotepadPlusPlus()
{
    ifWinActive ahk_class CabinetWClass
    {
        OpenCurrentSelectedWithNotepadPlusPlus()
        return true
    }
    
    SetTitleMatchMode 2
    IfWinExist, ahk_class Notepad++
    {
        OutputToDebugWindow("Existing Notepad'+'+")
        WinActivate, ahk_class Notepad++
    }
    else
    {
        OutputToDebugWindow("New Notepad'+'+")
        global NotepadPlusPlusExe
        run % NotepadPlusPlusExe
    }
    return true
}

ActivateLastGoogleChrome()
{
    IfWinExist, ahk_class Chrome_WidgetWin_1
    {
        OutputToDebugWindow("Existing Chrome")
        WinActivate, ahk_class Chrome_WidgetWin_1
        return true
    }
    else
    {
        OutputToDebugWindow("New Chrome")
        global GoogleChromeExe
        SetTitleMatchMode 2
        run % GoogleChromeExe
    }
    return true
}

;------------------------------
;	Activate last Windows explorer
;
ActivateLastWindowsExplorer()
{
    WinGet, myList, List, ahk_class CabinetWClass,, Program Manager
    WinGet, numOfWinExplorerExist, count, ahk_class CabinetWClass,, Program Manager
    
    ; Discarded because this only activates one Explorer
    if( numOfWinExplorerExist == 0 ) ;ifWinNotExist ahk_class CabinetWClass
    {
        Send {LWin Down}{e}{LWin Up}
        return true
    }
    
    global windowBarHeight
    maxHorizontalTiled := 5
    minHorizontalTiled := 3
    
    ; Set defaults 
    if ( (numOfWinExplorerExist < maxHorizontalTiled) && (numOfWinExplorerExist <= minHorizontalTiled) )
    {
        singleHeight := A_ScreenHeight-windowBarHeight
        singleWidth := A_ScreenWidth / numOfWinExplorerExist
    }
    else
    {
        singleHeight := (A_ScreenHeight-windowBarHeight) / 2
        
        if ( numOfWinExplorerExist > maxHorizontalTiled )
            singleWidth := A_ScreenWidth / maxHorizontalTiled
        else
            singleWidth := A_ScreenWidth / minHorizontalTiled
    }
    
    Loop, %myList%
    {
        currentID := myList%A_Index%      
        
        ; Window keeps its "maximized state" even when you resize the window via winmove and it's not maximized anymore. So if you 
        ; start from a miximized window (which I always did), you would have to resize AND manually change the "maximized state" to 0. 
        WinGet, MinMaxState , MinMax, ahk_id %currentID%   ;-1 for min, 1 for max, 0 otherwise
        if ( MinMaxState <> 0 )
            WinRestore, ahk_id %currentID%
        
        ; Set width separately if we are in second row
        if( A_Index > maxHorizontalTiled )
        {
            singleWidth := A_ScreenWidth / (numOfWinExplorerExist - maxHorizontalTiled)
            
            OutputToDebugWindow( "Bottom: "singleWidth )
            WinMove, ahk_id %currentID%,, (A_Index - 1 - maxHorizontalTiled) * singleWidth, singleHeight, singleWidth, singleHeight
        }
        else if( (A_Index > minHorizontalTiled) && (numOfWinExplorerExist <= maxHorizontalTiled) )
        {
            singleWidth := A_ScreenWidth / (numOfWinExplorerExist - minHorizontalTiled)
            OutputToDebugWindow( "Bottom: "singleWidth )
            WinMove, ahk_id %currentID%,, (A_Index - 1 - minHorizontalTiled) * singleWidth, singleHeight, singleWidth, singleHeight
        }
        else
        {
            OutputToDebugWindow( "Top: "singleWidth )
            WinMove, ahk_id %currentID%,, (A_Index-1) * singleWidth, 0, singleWidth, singleHeight
        }
        WinActivate ahk_id %currentID%  
    }
    
    return true
}

;------------------------------
;	Forward History of Windows Tab
;
Forward_WindowsTab()
{
    OutputToDebugWindow("Forward Windows")
    Send {Alt Down}{Shift Down}{Esc}{Alt Up}{Shift Up}
    return true
}

;------------------------------
;	Reverse History of Windows Tab
;
Reverse_WindowsTab()
{
    OutputToDebugWindow("Reverse Windows")
    Send {Alt Down}{Esc}{Alt Up}
    return true
}

;------------------------------
;	Scroll faster
;
FastScrollUp()
{
	global GoogleChromeTitle
	global VisualStudioTitle
	global NotepadTitle
	global NotepadPlusPlusTitle
	global VisualStudio_ScrollRate 
	global GoogleChrome_ScrollUpRate
	global Notepad_ScrollRate
	global NotepadPlusPlusTitle
	
    loopTotal := 15
    sleepTime := 10
    {
        if( CheckWindowActive(GoogleChromeTitle) )
        {	
            ;ToolTip, %GoogleChrome_ScrollUpRate%x
            loopTotal := GoogleChrome_ScrollUpRate
            
            OutputToDebugWindow( "Scroll Faster " GoogleChrome_ScrollUpRate )
        }
        else if ( CheckWindowActive( VisualStudioTitle ) )
        {
            ;ToolTip, %VisualStudio_ScrollRate%x
            loopTotal := VisualStudio_ScrollRate
            
            OutputToDebugWindow( "Scroll Faster " VisualStudio_ScrollRate )
        }
        else if ( CheckWindowActive( NotepadTitle ) || CheckWindowActive( NotepadPlusPlusTitle ) )
        {
            ;ToolTip, %Notepad_ScrollRate%x
            loopTotal := Notepad_ScrollRate
            
            OutputToDebugWindow( "Scroll Faster " Notepad_ScrollRate )
        }
        else
            OutputToDebugWindow( "Scroll Faster " loopTotal )

        Loop %loopTotal% 
        {
            Send {WheelUp}
            Sleep %sleepTime%
        }
        ToolTip
    }
    return 
}

;+WheelDown::
FastScrollDown()
{
	global GoogleChromeTitle
	global VisualStudioTitle
	global NotepadTitle
	global NotepadPlusPlusTitle
	global VisualStudio_ScrollRate 
	global GoogleChrome_ScrollDownRate
	global Notepad_ScrollRate
	global NotepadPlusPlusTitle
    
	loopTotal := 8
    sleepTime := 10
    {
        if( CheckWindowActive(GoogleChromeTitle) )
        {	
            ;ToolTip, %GoogleChrome_ScrollDownRate%x
            loopTotal := GoogleChrome_ScrollDownRate
            
            OutputToDebugWindow( "Scroll Faster " GoogleChrome_ScrollDownRate )
        }
        else if ( CheckWindowActive( VisualStudioTitle ) )
        {
            ;ToolTip, %VisualStudio_ScrollRate%x
            loopTotal := VisualStudio_ScrollRate
            
            OutputToDebugWindow( "Scroll Faster " VisualStudio_ScrollRate )
        }
        else if ( CheckWindowActive( NotepadTitle ) || CheckWindowActive( NotepadPlusPlusTitle ) )
        {
            ;ToolTip, %Notepad_ScrollRate%x
            loopTotal := Notepad_ScrollRate
            
            OutputToDebugWindow( "Scroll Faster " Notepad_ScrollRate )
        }
        else
            OutputToDebugWindow( "Scroll Faster " loopTotal )
        
        Loop %loopTotal% 
        {
            Send {WheelDown}
            Sleep %sleepTime%
        }
        ToolTip
    }
    return 
}

;------------------------------
;	Window Resize
;
ResizeToLeftHalf()
{	
	;if( GetKeyState("Control","P") && GetKeyState("LWin","P") && GetKeyState("Left","P") )
	{
		global windowBarHeight
	
		WinGetPos, X, Y, width, height, A
		WinRestore, A
		
        CoordMode, Mouse, Screen	; This will set mouse move to use coordinates relative to screen and NOT active window
        MouseGetPos, absoluteX, absoluteY, WhichWindow
        OutputToDebugWindow( absoluteX )
        Sleep 20
        
        if( absoluteX > A_ScreenWidth )
        {
            OutputToDebugWindow( "Left of R monitor" )
            WinMove, A,, A_ScreenWidth, 0, A_ScreenWidth/2, A_ScreenHeight-windowBarHeight
        }
        else
		{
            OutputToDebugWindow( "Left of L monitor" )
            WinMove, A,, 0, 0, A_ScreenWidth/2, A_ScreenHeight-windowBarHeight
            ;WinMove, A,, (A_ScreenWidth/2)-(width/2), (A_ScreenHeight/2)-(height/2)
        }
	}
	return
}

ResizeToRightHalf()
{	
	;if( GetKeyState("Control","P") && GetKeyState("LWin","P") && GetKeyState("Right","P") )
	{
		global windowBarHeight
		
		WinGetPos, X, Y, width, height, A
		WinRestore, A
        
        CoordMode, Mouse, Screen	; This will set mouse move to use coordinates relative to screen and NOT active window
        MouseGetPos, absoluteX, absoluteY, WhichWindow
        OutputToDebugWindow( absoluteX )
        Sleep 20
        
        ; Check if mouse is on left monitor
        if( absoluteX > A_ScreenWidth )
        {  
            OutputToDebugWindow( "Right of R monitor" )
            WinMove, A,, A_ScreenWidth + (A_ScreenWidth/2), 0, A_ScreenWidth/2, A_ScreenHeight-windowBarHeight
        }
        else
		{
            OutputToDebugWindow( "Right of L monitor" )
            WinMove, A,, 0 + (A_ScreenWidth/2), 0, A_ScreenWidth/2, A_ScreenHeight-windowBarHeight
        }
	}
	return
}

;^#Up::
Maximize()
{	
	global DebugWindowTitle
	global DisableMaximizeDebugWindow
	if( DisableMaximizeDebugWindow && CheckWindowActive( DebugWindowTitle ) )
	{
		OutputToDebugWindow( "Disabled Maximize" )
		return
	}
	
	OutputToDebugWindow( "Maximize" )
    ; Window keeps its "maximized state" even when you resize the window via winmove and it's not maximized anymore. So if you 
    ; start from a miximized window (which I always did), you would have to resize AND manually change the "maximized state" to 0. 
    WinGet, MinMaxState , MinMax, A   ;-1 for min, 1 for max, 0 otherwise
    if ( MinMaxState <> 0 )
        WinRestore, A
        
	WinMaximize, A
	return
	
	;SetTitleMatchMode 2
	;lastMinimizedWindow := GetTitle_LastWindowMinimized()
	;TimedToolTip(Maximize, 1000)
	;WinRestore, %lastMinimizedWindow%
	;return
}

; NOTE: Decided to take out WinMaximize because I realised I don't use it much
Minimize()
{	
	OutputToDebugWindow( "Minimize" )
	SetTitleMatchMode 2
	lastActiveWindow := GetTitle_LastWindowActive()
	;MsgBox, 4, , %lastActiveWindow%
	WinMinimize, A
	
	;WinMaximize, %lastActiveWindow%
	return
}

;------------------------------
;	Exit current code tab
;
ExitCurrentTab()
{		
	global VisualStudioTitle
	global GoogleChromeTitle
	global NotepadPlusPlusTitle
	
	if( CheckWindowActive( VisualStudioTitle ) || CheckWindowActive( GoogleChromeTitle ) )
	{
		OutputToDebugWindow( "Closing Tab" )
		Click
		Sleep 20
		Send {Ctrl Down}{F4}{Ctrl Up}
        return true
	}
	else if ( CheckWindowActive( NotepadPlusPlusTitle) )
	{
		OutputToDebugWindow( "Closing Tab" )
		Send {Ctrl Down}{w}{Ctrl Up}
        return true
	}
    return false
}
