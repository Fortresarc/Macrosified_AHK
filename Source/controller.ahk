#Include windowsoperations.ahk
#Include codinganddebugging.ahk
#Include  *i %A_ScriptDir%\specialized\controllerspecific.ahk      ; *i means ignore if we can't find this file

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
        ActivateLastNotepadPlusPlus()
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
                ; Checking if CtrlRB exists, effectively if we don't include controllerspecific.ahk this source code will still
                ; work
                If IsFunc("CtrlRB")
                {
                    funcName = CtrlRB
                    if ( %funcName%() == true)
                    {
                        return
                    }
                }
                OutputToDebugWindow("Control RButton")
                Send ^RButton
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
                If IsFunc("CtrlShiftWheelUp")
                {
                    funcName = CtrlShiftWheelUp
                    if ( %funcName%() == true)
                    {
                        return
                    }
                }
                
                OutputToDebugWindow("Control Shift WheelUp")
                Send {Ctrl Down}{Shift Down}{WheelUp}{Shift Up}{Ctrl Up}
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
                If IsFunc("CtrlShiftWheelDown")
                {
                    funcName = CtrlShiftWheelDown
                    if ( %funcName%() == true)
                    {
                        return
                    }
                }
                OutputToDebugWindow("LControl WheelDown")
                Send {Ctrl Down}{Shift Down}{WheelDown}{Shift Up}{Ctrl Up}
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
            If IsFunc("AltLButton")
            {
                funcName = AltLButton
                if ( %funcName%() == true)
                {
                    return
                }
            }
            OutputToDebugWindow( "Alt LButton")
        
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
;!RButton::
~Alt & RButton::
{
    if( GetKeyState("Alt", "P") && GetKeyState("WheelDown", "P") )
	{
        if( VSStepOut() == false )
        {
            If IsFunc("AltRButton")
            {
                funcName = AltRButton
                if ( %funcName%() == true)
                {
                    return
                }
            }
            OutputToDebugWindow( "Alt RButton" )
            Send, {Alt Down}{RButton}{Alt Up}
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
            If IsFunc("AltWheelDown")
            {
                funcName = AltWheelDown
                if ( %funcName%() == true)
                {
                    return
                }
            }
            OutputToDebugWindow( "Alt WheelDown" )
            Send, {Alt Down}{WheelDown}{Alt Up}
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
            If IsFunc("AltMButton")
            {
                funcName = AltMButton
                if ( %funcName%() == true)
                {
                    return
                }
            }
            OutputToDebugWindow( "Alt MButton" )
            Send, {Alt Down}{MButton}{Alt Up}
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
            If IsFunc("AltE") 
            {
                funcName = AltE
                if ( %funcName%() == true)
                {
                    return
                }
            }
            OutputToDebugWindow("Alt e")
            ; Return usual command
            Send {Alt Down}{e}{Alt Up}
        }
    }
    return
}

;------------------------------
;	Alt ... f
;
; ~Alt & f::
; {
	; if( GetKeyState("Alt", "P") && GetKeyState("f", "P") )
	; {
        ; if( FindUsingCMD( "asdf.h", "w:", ".h", foundFilePath) == false)
        ; {
            ; OutputToDebugWindow("Alt f")
            ; ; Return usual command
            ; Send {Alt Down}{f}{Alt Up}
        ; }
        ; else 
            ; Continue( foundFilePath )
    ; }
    ; return
; }

;------------------------------
; Alt ... p
; Will conflict with VS "Attach to Process", seems like VS take precedence over controls
;
;^!p::
;{
    ; if( GetKeyState("LControl", "P") && GetKeyState("p", "P") )
    ; {
        ; if( ahkSuspend() == false )
        ; {
            ; OutputToDebugWindow("Ctrl Alt p")
            ; ; Return usual command
            ; SendInput {Ctrl Down}{Alt Down}{p}{Ctrl Up}{Alt Up}
            ; return
        ; }
    ; }
    ; else if ( GetKeyState("LAlt", "P") && GetKeyState("p", "P") )
    ; {
        ; OutputToDebugWindow("Alt p")
        ; ; Return usual command
        ; Send {Alt Down}{p}{Alt Up}
    ; }
;}

~Alt & t::
{
    if( GetKeyState("Alt", "P") && GetKeyState("t", "P") )
    {
        TerminateAll()
    }
    return
}

~Alt & o::
{
    if( GetKeyState("Alt", "P") && GetKeyState("o", "P") )
    {
        VSSwitchHeaderAndCpp()
    }
    return
}

;------------------------------
;    Alt ... n
;
~Alt & n::
{
    if( GetKeyState("Alt", "P") && GetKeyState("n", "P") )
    {
        if( ! VSOpenCurrentFileInNotepadPlusPlus() )
        {
            ActivateLastNotepadPlusPlus()
        }
    }
    return
}

;------------------------------
;    Alt ... k
;
~Alt & k::
{
    if( GetKeyState("Alt", "P") && GetKeyState("k", "P") )
    {
        If IsFunc("AltK") 
        {
            funcName = AltK
            if ( %funcName%() == true)
            {
                return
            }
        }
        OutputToDebugWindow("Alt k")
        ; Return usual command
        Send {Alt Down}{k}{Alt Up}
    }
    return
}

;------------------------------
;	Alt ... r
;   Not so useful for VS proj that cannot build and run, and need to manually reload
;
;!r::
~Alt & r::
{
    if( GetKeyState("Alt", "P") && GetKeyState("r", "P") )
	{
        ;if( VSStopAndRun() == false)
        {
            If IsFunc("AltR") >= 1
            {
                funcName = AltR
                if ( %funcName%() == true)
                {
                    return
                }
            }
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

;======================================================================================================================
;	Keyboard controls
;	

;------------------------------
;	F1
;
F1::
{
	if( GetKeyState("F1", "P") )
	{
        SearchGoogle()
    }
    return
}

;------------------------------
;	F2
;
F2::
{
	if( GetKeyState("F2", "P") )
	{
        if( !VSCopyNameOfCurrentFile() )
        {
            OutputToDebugWindow("F2")
            
            ; Like SendInput, SendPlay's keystrokes do not get interspersed with keystrokes typed by the user. Thus, if the user happens to type something during a SendPlay, those keystrokes are postponed until afterward.
            SendPlay {F2}
        }
    }
    return
}
