#include global.ahk

AlwaysOn()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Always ON functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AlwaysOn()
{
	global DebugWindowTitle
	global EnableDebugWindow
	if ( EnableDebugWindow = 1 )
	{
		OutputToDebugWindow("Debugger ")
		EnableUI()
	}
	else 
		DisableUI()
	return
}
;------------------------------
;	Enable debug display
;
ToggleDebugDisplay()
{
	if CheckWindowActive( "DebugMYGUI" )
	{
		DisableUI()
	}
	else
	{
		EnableUI()
	}
}
return
;------------------------------------------------------------
;	UI (DEBUGGING PURPOSE)
;

;------------------------------
;	Draw UI with no border
;
EnableUI()
{
	global DebugWindowTitle
	global PosX
	global PosY
	global MarginX 
	global MarginY
	global TextFont
	global TextColor
	global BGColor
	global sizeX
	global sizeY
	global UseLastStoredDebugWindowPos
	
	; Get the real screen size
	WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,	; This will get me the Taskbar size
	PosX := A_ScreenWidth * 0.8
	PosY := A_ScreenHeight - TH - sizeY - MarginY
	
	; Get the last stored window positon	
	if( UseLastStoredDebugWindowPos )
	{
		ReadWinPosFromFile(PosX, DummyY)
	}
	
	#SingleInstance,Force
		
	Gui, +ToolWindow	; Hide the icon on the Windows Taskbar
						; Decided not to hide because we cannot set text afterward
                        ; 23 Jan 2015 Decided to hide again cos it seems like text can be sent after all
	
	Gui -Caption
	Gui, font, %TextColor% Italic s7, TextFont	;Must be before setting text
	Gui, Color, %BGColor%
	Gui, margin, MarginX, MarginY
	Gui, Add, Text, R1 W%sizeX%-%MarginX%, DebugText
	Gui +AlwaysOnTop +Border
	Gui 2:+LabelMYDEBUGGUI 	; TODO: This is not used!
	Gui, Show, w%sizeX% h%sizeY% x%PosX% y%PosY%, %DebugWindowTitle%

	WinSet, TransColor, %BGColor%
	return
}

DisableUI()
{
	Gui, Destroy
	return
}

OutputToDebugWindow( debugText, duration=1000 )
{	
	global EnableDebugWindow
	global DebugWindowTitle
	if ( EnableDebugWindow && CheckWindowExist( DebugWindowTitle ) )
	{
		Gui, Flash, Off
		
		; To have a DebugText disappear after a certain amount of time
		; without having to use Sleep (which stops the current thread):
		#Persistent
		ControlSetText, Static1, %debugText%, DebugMYGUI
		
		SetTimer, RemoveDebugFromGUI, %duration%
		
		;WinMove, DebugMYGUI,, %PosX%, %PosY%, %sizeX%, %sizeY%*2
	}
	return
}

RemoveDebugFromGUI:
{
	global DebugWindowTitle
	SetTimer, RemoveDebugFromGUI, Off
	if CheckWindowExist( DebugWindowTitle )
	{
		ControlSetText, Static1, , DebugMYGUI
	}
	return
}

;------------------------------
;	Mouse drag debugWindow
;
DragDebugWindow( controlKey )
{
	global DebugWindowTitle
	wasDragged := false
		
	while ( CheckWindowActive( DebugWindowTitle ) && GetKeyState( controlKey, "P") )
	{
		wasDragged := true 
		CoordMode, Mouse
		WinGet, GuiID, ID, A
		MouseGetPos, MouseStartX, MouseStartY, MouseWin
		if( MouseWin <> %GuiID% )
		{
			PostMessage, 0xA1, 2,,, A	;Enable dragging
			;return
		}
	}
	
	; Released
	if( wasDragged )
	{
		MagnetToWindowBarHeight()
		
		;Otherwise, track the mouse as the user drags it
		;SetTimer, WatchMouse, 10
		MouseGetPos, currX, currY
		tmpString = %currX%,%currY%
		WriteWinPosToFile( tmpString )
		return
	}
}

MagnetToWindowBarHeight()
{
	global DebugWindowTitle
	global sizeX
	global sizeY
	global MarginY
	WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,	; This will get me the Taskbar size
	MouseGetPos, currX, currY
	
	currY := A_ScreenHeight - TH - sizeY - MarginY
	WinMove, %DebugWindowTitle%,, %currX%, %currY%, %sizeX%, %sizeY%*2
}

WriteWinPosToFile( textToWrite )
{
	LastWindowPostion = %A_WorkingDir%`\debugWindowPosition`.txt
	
	FileDelete %LastWindowPostion%
	;IfNotEqual ErrorLevel, 0, MsgBox Can't delete fiel "%LastWindowPostion%"`nErrorLevel = "%ErrorLevel%"
	
	FileAppend, %textToWrite%, %LastWindowPostion%
}

ReadWinPosFromFile(ByRef newPosX, ByRef newPosY)
{
	LastWindowPosition = %A_WorkingDir%`\debugWindowPosition`.txt
	
	FileReadLine, lineRead, %LastWindowPosition%, 1	;Read only first line
	Loop, parse, lineRead, `,
	{
		if( A_Index == 1 )
		{
			newPosX = %A_LoopField%
		}
		else if( A_Index == 2 )
		{
			newPosY = %A_LoopField%
		}
	}
}
