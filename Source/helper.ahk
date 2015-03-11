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
;--------------------------------------------------------------------------------------------------
;	HELPERS
;

;------------------------------------------------------------
;	Ask/ prompts user a question with yes/no feedback
;
Continue(info, question="")
{
    MsgBox, 4, , %info%`n`n%question%
    IfMsgBox, No
        return false
    return true
}

;------------------------------------------------------------
;	Get HwndId which is unique 
;
GetHwndId(classNN, windowTitle)
{
    ; E.g. classNN := "Edit3"
    
    ControlGet, hwndId, Hwnd, , %classNN%, %windowTitle%
    
    IfWinExist, ahk_id %hwndId%
    {
        ControlFocus, , ahk_id %hwndId%
        OutputToDebugWindow( "Exists hwndId="hwndId )
        ;ControlClick, , ahk_id %hwndId%
    }
    else
    {
        OutputToDebugWindow( "NOT Exists hwndId="hwndId )
    }
}

;------------------------------
;	Send text in a flash without waiting for it to type out usually using Send, SendInput
;
SendTextImmediately( text )
{
    originalCopiedText = 
    originalCopiedText := clipboard
    OutputToDebugWindow( originalCopiedText )
    
	clipboard := text
	Sleep 50
    SendInput {Ctrl Down}{v}{Ctrl Up}
    Sleep 300
    
    ;ClipWait, 2        ; Wait for the clipboard to contain text.
    clipboard := originalCopiedText
}

;--------------------------------------------------------------------------------------------------
;	Open Programs
;

;------------------------------
; Search Google the selected text 
;
SearchGoogle()
{
    ; The below get selected works! but ONLY for notepad
    ; WinGet, active_id, ID, A        ; Both works
    ; ;active_id := WinExist("A")     ;Both works    
    ; ControlGet, outSelected, Selected, , , ahk_id %active_id%
    Copy()
    
    ActivateLastGoogleChrome()
    
    Sleep 100
    Send {Ctrl Down}{t}{Ctrl Up}
    Sleep 100
    
    SendTextImmediately( clipboard )
    Send {Enter}
}

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

;--------------------------------------------------------------------------------------------------
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

;--------------------------------------------------------------------------------------------------
;	Windows status
;
;------------------------------
; Get the ControlIds Of Active applications
;
GetControlListOfActive()
{
    global NotepadPlusPlus_FollowCurrentBoxTitle := "Follow current doc`."
    
    WinGet, ActiveControlList, ControlList, A
    Loop, Parse, ActiveControlList, `n
    {
        ControlGetText, currentControlId, %A_LoopField%, A
        ; MsgBox, 4,, Control #%a_index% is "%A_LoopField%" "%currentControlId%". Continue?
                ; IfMsgBox, No
                    ; break
        if(currentControlId == NotepadPlusPlus_FollowCurrentBoxTitle)
        {
            Continue("found")
        }
    }

}

;------------------------------
; Get the ControlIds from text of Windows individual controls
;
GetControlIdFromText( text, ByRef outControlId )
{
    WinGet, ActiveControlList, ControlList, A
    Loop, Parse, ActiveControlList, `n
    {
        ControlGetText, currentControlId, %A_LoopField%, A
        
        if(currentControlId == text)
        {
            outControlId := A_LoopField
            return true
        }
    }
    return false
}

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

;--------------------------------------------------------------------------------------------------
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

;--------------------------------------------------------------------------------------------------
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
    StringArray.Insert("`.")

	return StringArray
}

; TODO This is freaking hardcoded
GetIllegalStringArraySize()
{
	return 13
}

;--------------------------------------------------------------------------------------------------
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


;--------------------------------------------------------------------------------------------------
;	Windows Folders
;

;------------------------------
;	Replace \ with /
;
ReplaceBackWithForwardSlash(filePath, ByRef outFilePath)
{
    StringReplace, outFilePath, filePath, \, /, All
}

;------------------------------
;	Go up a level in folder hierarchy i.e. "cd .."
;
FilePath_cd_Up(filePath)
{
    slash = \
    StringGetPos, lastSlashPosition, filePath, %slash%, R
    ; +1 to include slash
    StringLeft, upFilePath, filePath, lastSlashPosition+1
    
    return upFilePath
}

;------------------------------
;	Find using cmd in folders. 
;   NOTE:   WILL OVERWRITE your clipboard
;           "where" should be a "drive:"
;           "type" should be ".extension"
;           "whichFileName" should HAVE ".extension"
FindUsingCMD(whichFileName, where, type, ByRef foundFilePath)
{
    delimiter := "\"
    clipboard := ""
    searchString := delimiter
    searchString .= whichFileName
    
    ; Runs 2 commands consecutively (&&)
    gotoDirCommand := where             ;"c:"
    findFileCommand := "dir /s /b "     ;"dir /s /b \example.h | clip"
    findFileCommand .= searchString
    findFileCommand .= " | clip"    
    RunWait, %comspec% /c %gotoDirCommand% && %findFileCommand%, , hide
    
    ClipWait, 2
    findResult := clipboard
    
    if( InStr(findResult, searchString) )
    {
        foundFilePath := findResult
        return true
    }
    ;MsgBox, Notfound %ErrorLevel%  %clipboard%
    return false
}

;------------------------------
;	Find recursively into folders. (Terminable)
;   NOTE:   "where" should be a "drive:\"
;           "type" should be ".extension"
;           "whichFileName" should HAVE ".extension"
;
FindRecursively(whichFileName, where, type, ByRef foundFilePath)
{
    global TerminateAll
    delimiter := "\"
    fileMatched := false
    
    timeToSleep := 100
    Loop, %where%*%type%, , 1  ; Recurse into subfolders.
    {
        ; TODO if more than one Terminable, this might not work
        if( TerminateAll )
        {
            OutputToDebugWindow("Terminate FindRecursively")
            TerminateAll := false
            return false
        }
        currentFilePath = %A_LoopFileFullPath%
                    
        OutputToDebugWindow( currentFilePath )        
        
        if( MatchWordFilePath(whichFileName, currentFilePath, delimiter) )
        {
            OutputToDebugWindow("Found: "currentFilePath)
            ;Continue("FoundRecursively Matched "currentFilePath)
            ;{
                foundFilePath := currentFilePath
                return true
            ;}
        }
        
        if( %A_Index% >= timeToSleep )
            Sleep 1000
    }
    return false
}

;------------------------------
;	Match word exactly in file path
;   E.g.    whichFilePath= C:\Prog\whichFile.txt
;           delimiter = \
;           searchWord = whichFile.txt
;           returns true
;
MatchWordFilePath(searchWord, whichFilePath, delimiter)
{
    position := InStr(whichFilePath, searchWord)    ; InStr position 1 is first
    
    if( position>0 )
    {
        properFilePath := ReplaceIllegalChar(whichFilePath)
        
        foundFilePath := properFilePath
        
        StringMid, wasDelimiter, properFilePath, position-1, 1, L
        if ( wasDelimiter==delimiter )
        {
            return true
        }
        else
        {
            return false
        }
    }
}

OpenCurrentSelectedWithNotepadPlusPlus()
{
    allSelectedFilePath := GetFileSelected_Explorer() 
    replacedIllegalPath := ReplaceIllegalChar(allSelectedFilePath)
    
    ; TODO :    There is a possibility an "0x80004005 - Unspecified Error" may appear, this hasn't been solved yet
    ;           However when it happens again, program will be able to continue
    if( replaceIllegalPath != "Unspecified Error" ) 
        OpenNotepadPlusPlus( replacedIllegalPath )
    else 
        Continue("Unspecified Error")
}

CopyFilePathAtSelectedFolder()
{    
    allSelectedFilePath := GetFileSelected_Explorer()   
        
    ; Copies to clipboard
    replacedIllegalPath := ReplaceIllegalChar(allSelectedFilePath)
    OutputToDebugWindow( replacedIllegalPath )
    
    ; TODO :    There is a possibility an "0x80004005 - Unspecified Error" may appear, this hasn't been solved yet
    ;           However when it happens again, program will be able to continue
    if( replaceIllegalPath != "Unspecified Error" ) 
        Clipboard := replacedIllegalPath
    else 
        Continue("Unspecified Error")
}

GetFileSelected_Explorer(hwnd="") 
{
	hwnd := hwnd ? hwnd : WinExist("A")
    
	WinGetClass class, ahk_id %hwnd%
	if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
		for window in ComObjCreate("Shell.Application").Windows
        {
            ; TODO :    There is a possibility an "0x80004005 - Unspecified Error" may appear, this hasn't been solved yet
            ;           However when it happens again, program will be able to continue
            if(window == 0x80004005)
                return "Unspecified Error"
            
			if (window.hwnd==hwnd)
            {
                sel := window.Document.SelectedItems
            }
        }
	for item in sel
        ToReturn .= item.path "`n"
	return Trim(ToReturn,"`n")
}

;------------------------------
;	Get the Control Id, ClassNN and etc
;
GetControlIds()
{
    MouseGetPos, , , id, control
    WinGetTitle, title, ahk_id %id%
    WinGetClass, class, ahk_id %id%
    ToolTip, ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
    
    Sleep 5000
    ToolTip
    return
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