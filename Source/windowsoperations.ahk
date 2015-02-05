; TODOs
; - Ctrl Win Right has conficted with Ctrl RButton but we can't see it happen 
;	because Right is on keyboard while RButton is on mouse
;		-> Implement a new class to check if we can get the controls first before giving it 
;			access
;
;



;***************************************************************/
;	Normal Window Operation
;**************************************************************/

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
        Sleep 100
        
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
        Sleep 100
        
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
	}
	else if ( CheckWindowActive( NotepadPlusPlusTitle) )
	{
		OutputToDebugWindow( "Closing Tab" )
		Send {Ctrl Down}{w}{Ctrl Up}
	}
}
return