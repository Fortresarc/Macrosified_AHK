; This should always be at the top
#Include global.ahk
#Include helper.ahk

; Include all the controls here
;#Include codinganddebugging.ahk
;#Include windowsoperations.ahk

#Include controller.ahk			; All macros are here

;#Include %A_ScriptDir%\thread\thread.ahk	; NOT USED NOW

;#z::Run www.autohotkey.com

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Examples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;^!n::
;IfWinExist Untitled - Notepad
;	WinActivate
;else
;	Run Notepad
;return

;------------------------------
; Suspend the script
;
;^!p::Suspend 	;Ctrl alt p
return

;------------------------------
; Test thread
;
; Detection
; ^!k::
; CreateThread()
; return

; End Detection
; ^!l::
; ExitThread()
return




;; This version is different from the one above why?
;^!p::
;{
;	if( GetKeyState("LControl", "P") && GetKeyState("p", "P") )
;	{
;		;-----------------------
;		; LControl Alt p
;		if( GetKeyState("Alt", "P") )
;		{
;			OutputToDebugWindow( "Suspend/resume" )
;			Suspend
;			return
;		}
;		;-----------------------
;		; LControl p
;		else
;		{
;			; Not used
;		}
;	}
;	return
;}




;*******************************************************************************
;*********************Commented Codes*******************************************
;*******************************************************************************


; Note: From now on whenever you run AutoHotkey directly, this scriptp
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.