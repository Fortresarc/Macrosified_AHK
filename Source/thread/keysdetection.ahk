#Include helper.ahk	;TODO clean this up later
#Include %A_ScriptDir%\thread\mutex.ahk
#Include %A_ScriptDir%\thread\threadedcontroller.ahk

; Research ------------------------------------------------------------------------------------------------------------------------------------
;	( Taken from http://www.reocities.com/SiliconValley/Way/3390/mjinput.html )
;	Mouse Clicks
;
;	Using only the standard Windows API, there are at least three ways to monitor mouse clicks within your application's window:
;
;	- Mouse messages. This is the most reliable way of catching every click. The disadvantage is that rapid clicking (e.g. in a shoot-'em-up game) 
;	  will pile up messages on the queue, and they may not be dealt with in a timely way. If you're keeping track of cursor movements by polling 
;	  with GetCursorPos, you may have trouble synchronizing responses to mouse clicks and responses to cursor movements.
;
;	- GetKeyState. This function can be used to check on the status of a mouse button, but just as with keys, it does not return the actual present 
;	  state of the hardware. Rather, it tells you what state the button was in when the last associated message was retrieved from the queue. For 
;	  example, GetKeyState(VK_LBUTTON) returns a negative value (high-order bit is 1) if the last mouse button message retrieved from the queue 
;	  was WM_LBUTTONDOWN.
;	  The low-order bit of the return value for GetKeyState is actually just a toggle that is reversed each time the button (or key) is pressed. 
;	  The following line of code, executed somewhere in the game loop, allows the user to turn the music on and off with the right button:
;	  BOOL MusicOn = (GetKeyState(VK_RBUTTON) & 1);
;	  GetKeyState is really intended to be used in response to a message that sets the button state. As Petzold (p. 296) points out, you can't wait 
;	  for a mouse click with a statement like this:
;	  while (GetKeyState(VK_LBUTTON) >= 0);  // *** doesn't work! ***
;	  Furthermore, polling a mouse button like this:
;	  if (GetKeyState(VK_LBUTTON) < 1) DoSomething();
;	  is not going to catch every click, because the user may have pressed and released the button since the mouse was last polled.
;
;	- GetAsyncKeyState. If you're not going to use DirectInput 3.0 to keep track of mouse clicks, and if your game loop is not based on the message 
;	  queue, GetAsyncKeyState is probably the best way to go. The first article in this series showed this function in action retrieving keystrokes 
;	  in real time. It works exactly the same way for the mouse, using the virtual keys VK_LBUTTON, VK_RBUTTON, and (for three-button mice) VK_MBUTTON. 
;	  Note that these virtual keys are mapped to the actual buttons on the mouse, not the primary and secondary buttons as defined by the user in the 
;	  Control Panel.
;
;
;	Regarding wheelup and wheeldown
;	In v1.0.43.03+, the built-in variable A_EventInfo contains the amount by which the wheel was turned, which is typically 1. However, A_EventInfo can be greater or less than 1 under the following circumstances:
;	-If the mouse hardware reports distances of less than one notch, A_EventInfo may contain 0;
; 	-If the wheel is being turned quickly (depending on type of mouse), A_EventInfo may be greater than 1. A hotkey like the following can help analyze your mouse: ~WheelDown::ToolTip %A_EventInfo%
;	NOTE : Finally, since mouse wheel hotkeys generate only down-events (never up-events), they cannot be used as key-up hotkeys.
; Research ------------------------------------------------------------------------------------------------------------------------------------

MySetKeyState( stateText )
{
	global m_state_text
	if( mutex := Lock() )
	{
		m_state_text := stateText
		Unlock( mutex )
	}
	return
}

MyGetKeyState()
{
	global m_state_text
	return m_state_text
}

IsRepeatedKeyState( single_key_state )
{
	if ( (single_key_state == Control_Key) || (single_key_state == Alt_Key) )
		return true
	else 
		return false
}

DetectKeyButtonPress_ThreadVersion()
{
	#Persistent
	SetTimer, DoLoop, 10		
	return
		
	DoLoop:		
		#singleinstance, Force
		global DebugWindowTitle
		
		;SetTimer, DoLoop, Off
		
		; Test code
		VarSetCapacity( state, 256 )
		SetBatchLines, -1
		SetFormat, Integer, Hex
		SetKeyDelay, -1
		
		while ( !(GetKeyState("LControl", "P") && GetKeyState("LAlt", "P") && GetKeyState("l", "P")) )
		{
			; Get Thread specifications 
			tid_this := DllCall( "GetCurrentThreadId" )
			tid_active := DllCall( "GetWindowThreadProcessId", "uint", WinActive( "A" ), "uint", 0 )
			
			; Todo - make tid_this global so we can track it
			if ( tid_active != tid_active_old )
			{
				DllCall( "AttachThreadInput", "uint", tid_this, "uint", tid_active_old, "int", false )
				DllCall( "AttachThreadInput", "uint", tid_this, "uint", tid_active, "int", true )
				
				tid_active_old := tid_active
			}
			DllCall( "GetKeyboardState", "uint", &state )
			
			; NOTE: 
			; 	The state_text will only store mouse buttons if its combined with another keyboard character
			;	individual mouse click MAY not be caught here
			state_text=
			   loop, 254
				  if ( *( &state+A_Index ) & 0x80 )
				  {					
					;ToolTip, state is %state% and A_Index is %A_Index%
			
					; Skip repeated characters like Control and Alt because we also have LControl and etc
					if ( !IsRepeatedKeyState( A_Index ) )
						state_text = %state_text%|%A_Index%
				  }
			
			; Store the state_text
			MySetKeyState( state_text )
			
			ProcessKeyPressed( MyGetKeyState() )

			Sleep 100
		}
	return
}

ProcessKeyPressed( state_text )
{
	; Creating a thread safe variable

	;ToolTip, Checkcontrol was %state_text%
	
	; IMPORTANT ------------------------------------------------------------------------------------------
	; 	0x41, 0x44, 0x53, etc. are Virtual-Key codes
	; 	must be listed in numerically increasing order
	; /end IMPORTANT--------------------------------------------------------------------------------------
	
	;------------------------------------------------------------------------------
	;	LControl ... RButton
	;
	LControlRButton_stateText := "|" RButton_Key "|" LControl_Key 
	if( state_text == LControlRButton_stateText )
	{
		LControlRButton()
		return
	}
	
	LControlWindowRButton_stateText := "|" RButton_Key "|" LWin_Key "|" LControl_Key 
	if( state_text == LControlWindowRButton_stateText )
	{
		LControlWindowRButton()
		return
	}
	
	LControlWindowLButton_stateText := "|" RButton_Key "|" LWin_Key "|" LControl_Key 
	if( state_text == LControlWindowLButton_stateText )
	{
		LControlWindowLButton()
		return
	}
}	

; -----------------------------------------------------------------------------------------------------
; Example code 
; -----------------------------------------------------------------------------------------------------

; ~~~~~~~~~~~~~~~~~~~~~
; how to use state text
; ~~~~~~~~~~~~~~~~~~~~~
; 0x41, 0x44, 0x53, etc. are Virtual-Key codes
; must be listed in numerically increasing order
;if ( state_text = "|0x41|0x44|0x53" )                              ; ads
;{
;	Send, {Backspace 3}about super dogs
;	Sleep 100
;}

;if ( state_text = "|0x41|0x47|0x49" )                              ; agi
;	Send, {Backspace 3}AHk is great!
;else if ( state_text = "|0x48|0x57" )                              ; hw
;	Send, {Backspace 2}Hello, World!
;else if ( state_text = "|0x4A|0x4B|0x4C" )                           ; jkl
;	Send, {Backspace 3}just kidding Latecia
;else if ( state_text = "|0x43|0x56|0x58|0x5A" )                        ; cvxz
;	Send, {Backspace 4}zoology xylophone category vertical
; ~~~~~~~~~~~~~~~~~~~~~
; how to use state text /end
; ~~~~~~~~~~~~~~~~~~~~~

; ~~~~~~~~~~~~~~~~~~~~~
; how to lock a variable
; ~~~~~~~~~~~~~~~~~~~~~
MySetKeyState2( stateText )
{
	; TODO - create and free -> Isn't it a little taxing?

	global m_state_text
	; Create a mutex so that its guaranteed that only one thread access the variable at one time
	mutexName := "myMutex"
	timeoutms := -1		;infinite	0xFFFFFFFF
	if ( mutex := DllCall("CreateMutex", "UInt", 0, "Int", false, "Str", mutexName) )
	{
		DllCall("WaitForSingleObject", UInt, mutex, Int, 0xFFFFFFFF)
	 
		m_state_text := stateText
	
		; Release mutex
		DllCall("ReleaseMutex", "UInt", mutex)
		
		; Free the mutex
		DllCall("CloseHandle", UInt, mutex)
	}
	else
	{
		ToolTip, Failed to create Mutex
	}
}
; ~~~~~~~~~~~~~~~~~~~~~
; how to lock a variable /end
; ~~~~~~~~~~~~~~~~~~~~~

; -----------------------------------------------------------------------------------------------------
; TODO - REMOVE
; -----------------------------------------------------------------------------------------------------
DetectKeyButtonPress(wParam, lParam, msg) {
	global numOfKeysPressed
	global keysPressedList
	isMouseButton := false
	
	;ToolTip, DetectedKeyPress
	
	Static MouseParamToVK := {1:1, 2:2, 0x10:4, 0x20:5, 0x40:6} ; L,R,M,X1,X2
	;if (msg < 0x200 && lParam & 1<<30) ; Not a mouse message && key-repeat.
      ;numOfKeysPressed++
   
	if msg >= 0x201 ; Mouse message.
	{
		isMouseButton := true
		wParam := MouseParamToVK[wParam & ~12] 
	}
	
	ModifierKeyList := "Control,Shift,Alt"   ;,RWin,LWin are removed
	DisabledKeyList := "RWin,LWin"
	NumPMods := 0
	PressedModifiers := ""

	; Detect and Count the number of Modifiers pressed
	Loop, Parse, ModifierKeyList, `, 
	{
		if NumPMods > 3
			break
		If GetKeyState(A_LoopField, "P") 
		{
			PressedModifiers .= A_LoopField " + "
			NumPMods++
		}
	}
	;numOfKeysPress += NumPMods
   
	SetFormat IntegerFast, H		;Convert to hex
	PressedKeyName := GetKeyName("VK" SubStr(wParam+0, 3))
   
	; To use "in" keyword we have to use "," to delimit
	If PressedKeyName not in %keysPressedList%
	{
		SetFormat IntegerFast, D	;Convert back to digits
		
		keysPressedList .= PressedKeyName "," 
		numOfKeysPressed++
		
		stringToPrint := %numOfKeysPressed% . keysPressedList
		OutputToDebugWindow(stringToPrint)
		ToolTip, stringToPrint
	}
   
	;If PressedKeyName in %DisabledKeyList%
    ;  OutputToDebugWindow("RWin and/or Lwin pressed")
   
	;If PressedKeyName in %ModifierKeyList%
	;	OutputToDebugWindow("Ctrl or Shift or Alt pressed")
	;Else
	;{
		;textToDisplay := % PressedModifiers . PressedKeyName
		;OutputToDebugWindow( textToDisplay )
	;}
	
	; Resets all cached components
	;SetTimer, ClearKeysPressed, 500
	
	; Resets all cached components
	if (msg == 0x101)	; Normal key is released
	{
		If PressedKeyName in %DisabledKeyList%
		{
			if (msg == 0x105)
				ResetCachedKeys()
		}
		else
		{
			If PressedKeyName in %ModifierKeyList%
			{
				if (msg == 0x105)
					ResetCachedKeys()
			}
			else
			{
				ResetCachedKeys()
			}
		}
		ToolTip, I was here
	}
}

ClearKeysPressed:
	SetTimer, ClearKeysPressed, Off
	global numOfKeysPressed
	global keysPressedList
	
	numOfKeysPressed := 0
	keysPressedList := ""
return

ResetCachedKeys()
{
	numOfKeysPressed := 0
	keysPressedList := ""
}
