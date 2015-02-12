; FUNCTION CONCEPTS
; ~~~~~~~~~~~~~~~~~
;	- If you pass in a normal text, which isn't defined in anywhere, we use CheckWindowExist( "yourNormalText" )
;	- If it is a previously declared text for e.g. CheckWindowExist( GoogleChromeTitle ) we don't use ""
;	- For parameters that are in options, for e.g. Gui, font, %TextColor% Italic s7, TextFont	
;													-> we should do this TextColor = cBlue
;		
;

; Debugging
#Include helper_debugui.ahk
;------------------------------------------------------------
;	HELPERS
;

;------------------------------
;	Send text in a flash without waiting for it to type out usually using Send, SendInput
;
SendTextImmediately( text )
{
    originalCopiedText = 
    originalCopiedText := clipboard
    OutputToDebugWindow( originalCopiedText )
    
    ClipWait, 2  ; Wait for the clipboard to contain text.
	clipboard := text
	Sleep 50
    SendInput {Ctrl Down}{v}{Ctrl Up}
    Sleep 300
    
    ClipWait, 2
    clipboard := originalCopiedText
}

;------------------------------
;	Open Programs
;
OpenNotepadPlusPlus(fileToOpen="")
{
    global NotepadPlusPlusTitle
	NotepadPlusPlus_Dir := "C:\Program Files (x86)\Notepad++\notepad++.exe"

	;Run, %NotepadPlusPlus_Dir%
	legalNotepadPlusPlus_Dir := ReplaceIllegalChar(NotepadPlusPlus_Dir)

	TimedToolTip( legalNotepadPlusPlus_Dir, 1000)

	Run, %legalNotepadPlusPlus_Dir% %fileToOpen%
    
    if( CheckWindowActive( NotepadPlusPlusTitle ) )
        WinActivate
	return
}

;------------------------------
;	Illegal Characters
;
ReplaceIllegalChar(inputMessage)
{
	CopyOfIllegalCharArray = CreateIllegalStringArray()

	ArrayCount := GetIllegalStringArraySize()
	Loop %ArrayCount%
	{
		element := CopyOfIllegalCharArray[A_Index]
		StringReplace, outputMessage, inputMessage, element, `element, ALL
	}
	return outputMessage
}

;------------------------------
;	Windows status
;
CheckWindowExist(Title)
{
	SetTitleMatchMode 2
	
	ifWinExist %Title%
		return true
	return false
}

CheckWindowActive(Title)
{
	SetTitleMatchMode 2

	
	ifWinActive %Title%
		return true
	return false
}

MoveMouseToCentreOfActiveWindow()
{
	WinGetPos, X, Y, width, height, A
	center_x:=x+width/2
	center_y:=y+height/2
	DllCall("SetCursorPos", int, center_x, int, center_y)
	return
}

IsMouseMoved()
{
	MouseGetPos, startX, startY
	Sleep 50
	MouseGetPos, endX, endY
	
	if ( ( startX != endX ) || ( startY != endY ) )
		return true
	return false
}

; TODO not working very well cos windows stacking algo is screwed up
GetTitle_LastWindowActive()
{
	WinGet, Window_List, List 

	Loop, %Window_List%
    {
		WinGet, State, MinMax, % "ahk_id" Window_List%A_Index%
		If ( State == -1 )
		{
			WinGetTitle, Title, % "ahk_id" Window_List%A_Index%
			;MsgBox, 4, , s`- %Title% . %State%
			return Title
		}
		;MsgBox, 4, , %State%
    }
	return
}

GetTitle_LastWindowMinimized()
{
	WinGet, Window_List, List 
	
	Loop, %Window_List%
    {
		WinGet, State, MinMax, % "ahk_id" Window_List%A_Index%
		If ( State == -1 )
		{
			;MsgBox, 4, , found
			WinGetTitle, Title, % "ahk_id" Window_List%A_Index%
			return Title
		}
    }
	return
}

;------------------------------
;	Tooltips
;
TimedToolTip(displayMessage, duration=5000)
{
	ToolTip, Multiline`nTooltip, 100, 150

	; To have a ToolTip disappear after a certain amount of time
	; without having to use Sleep (which stops the current thread):
	#Persistent
	ToolTip, %displayMessage%
	SetTimer, RemoveToolTip, %duration%
	

	; We don't return here because the caller function will return for us!
	;return
}

RemoveToolTip:
{
	SetTimer, RemoveToolTip, Off
	ToolTip
	return
}

;------------------------------
;	Arrays
;
CreateIllegalStringArray()
{
	StringArray := Object()
	
	StringArray.Insert("`-")
	StringArray.Insert("`+")
	StringArray.Insert("`@")
	StringArray.Insert("`%")
	StringArray.Insert("`&")
	StringArray.Insert("`*")
	StringArray.Insert("`\")
	StringArray.Insert("`/")
	StringArray.Insert("`[")
	StringArray.Insert("`]")
	StringArray.Insert("`:")
	StringArray.Insert("!")
	StringArray.Insert("`=")

	return StringArray
}

; TODO This is freaking hardcoded
GetIllegalStringArraySize()
{
	return 13
}


;------------------------------
;	Windows copy/ paste
;
; NOTE : We assume the user will call return for this
SelectWholeLine()
{
	Send, {end}
	Sleep 100
	Send, {Shift Down}{Home}{Shift Up}
}

CopyWholeLine()
{
	clipboard = asdf
	clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.

	SelectWholeLine()
	Sleep 100
	Copy()
	
	clipboard := clipboard		; Cannot put %% here, not sure why
	clipboard2 := ReplaceIllegalChar( clipboard )
    
    OutputToDebugWindow( clipboard2 )
	return clipboard2
}

; NOTE : We assume the user will call return for this
Copy()
{
	Send ^c
	ClipWait, 2
}

; NOTE : We assume the user will call return for this
Paste()
{
	Send, {Ctrl Down}{v}{Ctrl Up}
}


;------------------------------
;	Windows Folders
;
OpenCurrentSelectedWithNotepadPlusPlus()
{
    allSelectedFilePath := GetFileSelected_Explorer() 
    replacedIllegalPath := ReplaceIllegalChar(allSelectedFilePath)
    OpenNotepadPlusPlus( replacedIllegalPath )
}

CopyFilePathAtSelectedFolder()
{    
    allSelectedFilePath := GetFileSelected_Explorer()   
        
    ; Copies to clipboard
    replacedIllegalPath := ReplaceIllegalChar(allSelectedFilePath)
    OutputToDebugWindow( replacedIllegalPath )
    Clipboard := replacedIllegalPath
}

GetFileSelected_Explorer(hwnd="") {
	hwnd := hwnd ? hwnd : WinExist("A")
	WinGetClass class, ahk_id %hwnd%
	if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
    sel := window.Document.SelectedItems
	for item in sel
	ToReturn .= item.path "`n"
	return Trim(ToReturn,"`n")
}

; TODO ! 
CheckIsAFunction()
{
	; Make sure we are in focus
	Click

	; Go to end of word
	Send {Ctrl Down}{RightArrow}{Ctrl Up}
	Sleep 1000
	Send {Shift Down}{RightArrow}{Shift Up}
	Sleep 1000

	clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.
	Send ^c
	ClipWait  ; Wait for the clipboard to contain text.
	;clipboard:= %clipboard%

	functionStart := "`("
	ToolTip, %clipboard%
	if ( functionStart in %clipboard% )
		return true
	return false
}