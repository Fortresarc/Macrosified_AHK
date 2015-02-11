#Include windowsoperations.ahk
#Include codinganddebugging.ahk
#Include controllerspecific.ahk

;======================================================================================================================
; NOTE: 
; Precedence order we currently tested and know: Windows, Ctrl
;======================================================================================================================

;======================================================================================================================
;	Windows , (use this button for this key <)
;   Precedes Ctrl key
;
;------------------------------
;	Windows ... WheelUp
;
~RWin & WheelUp::
~LWin & WheelUp::
{
    if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("WheelUp", "P") )
    {
        if( GetKeyState("Ctrl", "P") )
            LControlWheelUp()
        else if( Maximize() == false )
        {
            OutputToDebugWindow("Win WheelUp")
            Send {Win Down}{WheelUp}{Win Up}
        }
    }
    return
}

;------------------------------
;	Windows ... WheelDown
;
~RWin & WheelDown::
~LWin & WheelDown::
{
    if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("WheelDown", "P") )
    {
        if( GetKeyState("Ctrl", "P") )
            LControlWheelDown()
        else if( Minimize() == false )
        {
            OutputToDebugWindow("Win WheelDown")
            Send {Win Down}{WheelDown}{Win Up}
        }
    }
    return
}

;------------------------------
;	Windows ... RButton
;
~RWin & RButton::
~LWin & RButton::
{
	if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("RButton", "P") )
	{
        ResizeToRightHalf()
    }
    return
}

;------------------------------
;	Windows ... n
;
~RWin & n::
~LWin & n::
{
	if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("n", "P") )
	{
        if( ! VSOpenCurrentFileInNotepadPlusPlus() )
        {
            ActivateLastNotepadPlusPlus()
        }
    }
    return
}

;------------------------------
;	Windows ... e
;
~RWin & e::
~LWin & e::
{
	if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("e", "P") )
	{
        ActivateLastWindowsExplorer()
    }
    return
}

;------------------------------
;	Windows ... c
;
~RWin & c::
~LWin & c::
{
	if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("c", "P") )
	{
        ActivateLastGoogleChrome()
    }
    return
}

;------------------------------
;	Windows ... LButton
;
~RWin & LButton::
~LWin & LButton::
{
	if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("LButton", "P") )
	{
        ResizeToLeftHalf()
    }
    return
}

;======================================================================================================================
;	Control, (use this button for this key <)
;	Control ... RButton
;
~LControl & RButton::
{
	if( GetKeyState("Ctrl", "P") && GetKeyState("RButton", "P") )
	{
		;-----------------------
		; Lcontrol Window RButton
		; if( GetKeyState("LWin", "P") )
		; {
			; ResizeToRightHalf()
		; }
		
        ;-----------------------
		; LControl RButton
		;else
		{
			if( ExitCurrentTab() == false )
            {
                if( CtrlRB() == false )
                {
                    OutputToDebugWindow("Control RButton")
                    Send ^RButton
                }
            }
		}
	}
	
	return
}

;------------------------------
;	Control ... LButton
;
~LControl & LButton::
{
	if( GetKeyState("Ctrl", "P") && GetKeyState("LButton", "P") )
	{
		;-----------------------
		; Lcontrol Window LButton
		; if( GetKeyState("LWin", "P") )
		; {
			; ResizeToLeftHalf()
		; }
		
        ;-----------------------
		; LControl LButton
		;else
		{
			OutputToDebugWindow( "Ctrl LButton" )
			
			; not used so default to Windows select multiple files
			Send {Ctrl Down}{LButton}{Ctrl Up}
		}
	}
	return
}

;------------------------------
;	Control ... WheelUp
;
~LControl & WheelUp::
{
    LControlWheelUp()
    return
}
LControlWheelUp()
{
	if( GetKeyState("Ctrl", "P") && GetKeyState("WheelUp", "P") )
	{
		;-----------------------
		; Lcontrol Window WheelUp
		if( GetKeyState("LWin", "P") )
		{
			Reverse_WindowsTab()
		}
		;-----------------------
		; LControl Shift WheelUp
        else if( GetKeyState("LShift", "P") )
        {
            if( Reverse() == false )
            {
                if( CtrlShiftWheelUp() == false )
                {
                    OutputToDebugWindow("Control Shift WheelUp")
                    Send {Ctrl Down}{Shift Down}{WheelUp}{Shift Up}{Ctrl Up}
                }
            }
            
        }
		;-----------------------
		; LControl WheelUp
		else
		{
            OutputToDebugWindow("Control WheelUp")
			Send {Ctrl Down}{WheelUp}{Ctrl Up}
		}
	}
	return
}

;------------------------------
;	Control ... WheelDown
;
~LControl & WheelDown::
{
    LControlWheelDown()
    return
}
LControlWheelDown()
{
	if( GetKeyState("Ctrl", "P") && GetKeyState("WheelDown", "P") )
	{
		;-----------------------
		; Lcontrol Window WheelDown
		if( GetKeyState("LWin", "P") )
		{
			Forward_WindowsTab()
		}
        ;-----------------------
		; LControl Shift WheelDown
        else if( GetKeyState("LShift", "P") )
        {
            if( Forward() == false )
            {
                if( CtrlShiftWheelDown() == false )
                {
                    OutputToDebugWindow("LControl WheelDown")
                    Send {Ctrl Down}{Shift Down}{WheelDown}{Shift Up}{Ctrl Up}
                }
            }
        }
		;-----------------------
		; LControl WheelDown
		else
		{
            OutputToDebugWindow("Control WheelDown")
			Send {Ctrl Down}{WheelDown}{Ctrl Up}
		}
	}
	return
}

;------------------------------
;	LButton ... MButton
;
~Lcontrol & MButton::
{
	 Send {Ctrl Down}{MButton}{Ctrl Up}
    return
}

;------------------------------
;	LButton (Drag)
;
~LButton::
{
	if( GetKeyState("LButton", "P") )
		DragDebugWindow( "LButton" )
	return
}
;------------------------------
;	Control ... c
;
^+c::       ;Ctrl Shift c
{
    if( GetKeyState("Ctrl", "P") && GetKeyState("c", "P") )
    {
        if( GetKeyState("Shift", "P") )
        {
            ; Only copy path if we are at explorer
            hwnd := WinExist("A")
            WinGetClass class, ahk_id %hwnd%
            if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
            {
                CopyFilePathAtSelectedFolder()
            }
            else
            {   
                CopyWholeLine()
            }
        }
        else
        {
            OutputToDebugWindow("Control c")
            Send {Ctrl Down}{c}{Ctrl Up}
        }
    }
    return
}

;------------------------------
;	Control ... d
;
^#d::
{
	if( GetKeyState("Control", "P") && GetKeyState("d", "P") )
    {
        if( GetKeyState("LWin", "P") )
        {
			ToggleDebugDisplay()
		}
		else
		{
            OutputToDebugWindow("Control d")
			Send {Ctrl Down}{d}{Ctrl Up}
		}
	}
    return
}

;------------------------------
;	Control ... n
;
^+n::       ;Ctrl Shift 
{
    if( GetKeyState("Ctrl", "P") && GetKeyState("n", "P") )
    {
        if( GetKeyState("Shift", "P") )
        {
            ;OpenCurrentSelectedWithNotepadPlusPlus()
        }
        else
        {
            OutputToDebugWindow("Control n")
            Send {Ctrl Down}{n}{Ctrl Up}
        }
    }
    return
}
;------------------------------
;	Control ... s      
;
~LControl & s::
{
	if( GetKeyState("Ctrl", "P") && GetKeyState("s", "P") )
	{
		;-----------------------
		; test if we can hide windows to taskbar
		if( GetKeyState("Shift", "P") )
        {
            EnableUI()
        }
        else
        {
            OutputToDebugWindow("Control s")
            ; not used so default to Windows controls
            Send {Ctrl Down}{s}{Ctrl Up}
        }
	}
	return
}
 
;------------------------------
;	Control ... t      This command is Reserved for TESTING!!
;
~LControl & t::
{
	if( GetKeyState("Ctrl", "P") && GetKeyState("t", "P") )
	{
		;-----------------------
		; test if we can hide windows to taskbar
		if( GetKeyState("Shift", "P") )
        {
            CopyFilePathAtSelectedFolder()
        }
        else
        {
            OutputToDebugWindow("Ctrl t")
            ; not used so default to Windows controls
            Send {Ctrl Down}{t}{Ctrl Up}
        }
	}
	return
}

;======================================================================================================================
;	Alt , (use this button for this key <)
;
;------------------------------
;	Alt ... LButton
;
;!LButton::
~Alt & LButton::
{
	while ( GetKeyState("Alt", "P") && GetKeyState("LButton", "P") )
	{
		if( VSContinue_PressedAndHold() == false )
		{
            if( AltLButton() == false )
            {
                OutputToDebugWindow( "Alt LButton")
			
                ; Return usual command
                Send {LAlt Down}{LButton}{LAlt Up}
            }
		}
	}
	VSContinue_Released()
    return
}

;------------------------------
;	Alt ... RButton
;
;!RButton::
~Alt & RButton::
{
    if( GetKeyState("Alt", "P") && GetKeyState("WheelDown", "P") )
	{
        if( VSStepOut() == false )
        {
            if( AltRButton() == false )
            {
                OutputToDebugWindow( "Alt RButton" )
                Send, {Alt Down}{RButton}{Alt Up}
            }
        }
    }
    return
}

;------------------------------
;	Alt ... WheelDown
;
;!WheelDown::
~Alt & WheelDown::
{
	if( GetKeyState("Alt", "P") && GetKeyState("WheelDown", "P") )
	{
        if( VSStepOver() == false )
        {
            if( AltWheelDown() == false )
            {
                OutputToDebugWindow( "Alt WheelDown" )
                Send, {Alt Down}{WheelDown}{Alt Up}
            }
        }
    }
    return
}

;------------------------------
;	Alt ... MButton
;
;!MButton::
~Alt & MButton::
{    
    if( GetKeyState("Alt", "P") && GetKeyState("MButton", "P") )
	{
        if( VSStepInto() == false )
        {
            if( AltMButton() == false )
            {
                OutputToDebugWindow( "Alt MButton" )
                Send, {Alt Down}{MButton}{Alt Up}
            }
        }
    }
    return
}

;------------------------------
;	Alt ... Space
~LAlt & Space::
{
    if( GetKeyState("Alt", "P") && GetKeyState("Space", "P") )
	{
        if( DockFloatingFileVisualStudio() == false)
        {
            OutputToDebugWindow("Alt Space")
            ; Return usual command
            Send {Alt Down}{Space}{Alt Up}
        }
    }
	return
}

;------------------------------
;	Alt ... b
;
;!b::
~Alt & b::
{
    if( GetKeyState("Alt", "P") && GetKeyState("b", "P") )
	{
        if( VSStopAndBuild() == false)
        {
            OutputToDebugWindow("Alt b")
            ; Return usual command
            Send {Alt Down}{b}{Alt Up}
        }
    }
    return
}

;------------------------------
;	Alt ... c
;
;!c::
~Alt & c::
{
    if( GetKeyState("Alt", "P") && GetKeyState("c", "P") )
	{
        if( VSFindAll_Current() == false)
        {
            OutputToDebugWindow("Alt c")
            ; Return usual command
            Send {Alt Down}{c}{Alt Up}
        }
    }
    return
}

;------------------------------
;	Alt ... d
;
;!d::
~Alt & d::
{
	if( GetKeyState("Alt", "P") && GetKeyState("d", "P") )
	{
        if( VSGoToDefinition() == false)
        {
            OutputToDebugWindow("Alt d")
            ; Return usual command
            Send {Alt Down}{d}{Alt Up}
        }
    }
    return
}

;------------------------------
;	Alt ... e
;
;!e::
~Alt & e::
{
	if( GetKeyState("Alt", "P") && GetKeyState("e", "P") )
	{
        if( VSFindAll_Entire() == false)
        {
            if( AltE() == false )
            {
                OutputToDebugWindow("Alt e")
                ; Return usual command
                Send {Alt Down}{e}{Alt Up}
            }
        }
    }
    return
}


;------------------------------
;	Alt ... r
;
;!r::
~Alt & r::
{
    if( GetKeyState("Alt", "P") && GetKeyState("r", "P") )
	{
        if( VSStopAndRun() == false)
        {
            OutputToDebugWindow("Alt r")
            ; Return usual command
            Send {Alt Down}{r}{Alt Up}
        }
    }
    return
}

;------------------------------
;	Alt ... w
;
;!w::
~Alt & w::
{
    if( GetKeyState("Alt", "P") && GetKeyState("w", "P") )
	{
        if( VSWatchInWindow1() == false )
        {
            OutputToDebugWindow("Alt w")
            ; Return usual command
            Send {Alt Down}{w}{Alt Up}
        }
    }
    return
}

;======================================================================================================================
;	Shift , (use this button for this key <)
;
+WheelUp::
{
    FastScrollUp()
	
	; Just in case 
	Send {Shift Up}
    return
}
+WheelDown::
{
    FastScrollDown()
	
	; Just in case 
	Send {Shift Up}
    return
}


