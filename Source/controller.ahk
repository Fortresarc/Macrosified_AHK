#Include windowsoperations.ahk
#Include codinganddebugging.ahk
#Include controllerspecific.ahk

;------------------------------
;	Control ... RButton
;
~LControl & RButton::
{
	if( GetKeyState("LControl", "P") && GetKeyState("RButton", "P") )
	{
		;-----------------------
		; Lcontrol Window RButton
		if( GetKeyState("LWin", "P") )
		{
			ResizeToRightHalf()
		}
		;-----------------------
		; LControl RButton
		else
		{
			if( ExitCurrentTab() == false )
            {
                if( CtrlRB() == false )
                {
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
	if( GetKeyState("LControl", "P") && GetKeyState("LButton", "P") )
	{
		;-----------------------
		; Lcontrol Window LButton
		if( GetKeyState("LWin", "P") )
		{
			ResizeToLeftHalf()
		}
		;-----------------------
		; LControl LButton
		else
		{
			OutputToDebugWindow( "Ctrl LButton" )
			
			; not used so default to Windows select multiple files
			Send {LControl Down}{LButton}{LControl Up}
		}
	}
	return
}

;------------------------------
;	Control ... WheelUp
;
~LControl & WheelUp::
{
	if( GetKeyState("LControl", "P") && GetKeyState("WheelUp", "P") )
	{
		;-----------------------
		; Lcontrol Window WheelUp
		if( GetKeyState("LWin", "P") )
		{
			Maximize()
		}
		;-----------------------
		; LControl Shift WheelUp
        else if( GetKeyState("LShift", "P") )
        {
            if( Reverse() == false )
            {
                if( CtrlShiftWheelUp() == false )
                {
                    Send {Ctrl Down}{Shift Down}{WheelUp}{Shift Up}{Ctrl Up}
                }
            }
            
        }
		;-----------------------
		; LControl WheelUp
		else
		{
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
	if( GetKeyState("LControl", "P") && GetKeyState("WheelDown", "P") )
	{
		;-----------------------
		; Lcontrol Window WheelDown
		if( GetKeyState("LWin", "P") )
		{
			Minimize()
		}
        ;-----------------------
		; LControl Shift WheelDown
        else if( GetKeyState("LShift", "P") )
        {
            if( Forward() == false )
            {
                if( CtrlShiftWheelDown() == false )
                {
                    Send {Ctrl Down}{Shift Down}{WheelDown}{Shift Up}{Ctrl Up}
                }
            }
        }
		;-----------------------
		; LControl WheelDown
		else
		{
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
	if( ! VSOpenCurrentFileInNotepadPlusPlus() )
	{
		Send {Ctrl Down}{MButton}{Ctrl Up}
	}
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
    if( GetKeyState("LControl", "P") && GetKeyState("c", "P") )
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
            Send {LCtrl Down}{c}{LCtrl Up}
        }
    }
    return
}

;------------------------------
;	Control ... d
;
^#d::
{
	if( GetKeyState("LControl", "P") && GetKeyState("d", "P") )
    {
        if( GetKeyState("LWin", "P") )
        {
			ToggleDebugDisplay()
		}
		else
		{
			Send {LCtrl Down}{d}{LCtrl Up}
		}
	}
    return
}

;------------------------------
;	Control ... n
;
^+n::       ;Ctrl Shift 
{
    if( GetKeyState("LControl", "P") && GetKeyState("n", "P") )
    {
        if( GetKeyState("Shift", "P") )
        {
            OpenCurrentSelectedWithNotepadPlusPlus()
        }
        else
        {
            Send {LControl Down}{n}{LControl Up}
        }
    }
    return
}
;------------------------------
;	Control ... s      
;
~LControl & s::
{
	if( GetKeyState("LControl", "P") && GetKeyState("s", "P") )
	{
		;-----------------------
		; test if we can hide windows to taskbar
		if( GetKeyState("Shift", "P") )
        {
            EnableUI()
        }
        else
        {
            ; not used so default to Windows controls
            Send {LControl Down}{s}{LControl Up}
        }
	}
	return
}
 
;------------------------------
;	Control ... t      This command is Reserved for TESTING!!
;
~LControl & t::
{
	if( GetKeyState("LControl", "P") && GetKeyState("t", "P") )
	{
		;-----------------------
		; test if we can hide windows to taskbar
		if( GetKeyState("Shift", "P") )
        {
            CopyFilePathAtSelectedFolder()
        }
        else
        {
            ; not used so default to Windows controls
            Send {LControl Down}{t}{LControl Up}
        }
	}
	return
}

;------------------------------
;	Alt , (use this button for this key <)
;
;------------------------------
;	Alt ... LButton
;
!LButton::
{
	while ( GetKeyState("Alt", "P") && GetKeyState("LButton", "P") )
	{
		if( VSContinue_PressedAndHold() == false )
		{
			; Return usual command
			Send {LAlt Down}{LButton}{LAlt Up}
		}
	}
	VSContinue_Released()
    return
}

;------------------------------
;	Alt ... RButton
;
!RButton::
{
	if( VSStepOut() == false )
	{
		OutputToDebugWindow( "Alt RButton" )
		Send, {Alt Down}{RButton}{Alt Up}
	}
    return
}

;------------------------------
;	Alt ... WheelDown
;
!WheelDown::
{
	if( VSStepOver() == false )
	{
		OutputToDebugWindow( "Alt WheelDown" )
		Send, {Alt Down}{WheelDown}{Alt Up}
	}
    return
}

;------------------------------
;	Alt ... MButton
;
!MButton::
{
	if( VSStepInto() == false )
	{
		OutputToDebugWindow( "Alt WheelDown" )
		Send, {Alt Down}{MButton}{Alt Up}
		; OutputToDebugWindow( "Alt MButton" )
		; Send, {Alt Down}{MButton Down}
		; While GetKeyState("Alt", "P")
		; {
			; Send, {Alt Down}{MButton Down}
		; }
		; Send, {Alt Up}{MButton Up}
	}
    return
}

;------------------------------
;	Alt ... Space
~LAlt & Space::
{
	if( DockFloatingFileVisualStudio() == false)
	{
		; Return usual command
		Send {LAlt Down}{Space}{LAlt Up}
	}
	return
}

;------------------------------
;	Alt ... b
;
!b::
{
	if( VSStopAndBuild() == false)
	{
		; Return usual command
		Send {LAlt Down}{b}{LAlt Up}
	}
    return
}

;------------------------------
;	Alt ... c
;
!c::
{
	if( VSFindAll_Current() == false)
	{
		; Return usual command
		Send {LAlt Down}{c}{LAlt Up}
	}
    return
}

;------------------------------
;	Alt ... d
;
!d::
{
	if( VSGoToDefinition() == false)
	{
		; Return usual command
		Send {LAlt Down}{d}{LAlt Up}
	}
    return
}

;------------------------------
;	Alt ... e
;
!e::
{
	if( VSFindAll_Entire() == false)
	{
        if( AltE() == false )
        {
            ; Return usual command
            Send {LAlt Down}{e}{LAlt Up}
        }
	}
    return
}


;------------------------------
;	Alt ... r
;
!r::
{
	if( VSStopAndRun() == false)
	{
		; Return usual command
		Send {LAlt Down}{r}{LAlt Up}
	}
    return
}

;------------------------------
;	Alt ... w
;
!w::
{
	if( VSWatchInWindow1() == false )
	{
		; Return usual command
		Send {LAlt Down}{w}{LAlt Up}
	}
    return
}

;------------------------------
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


;------------------------------
;	Windows , (use this button for this key <)
;
#n::
{
    if( ( GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ) && GetKeyState("n") )
    {
        OpenNotepadPlusPlus()
    }    
    return
}
