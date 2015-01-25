#Include %A_ScriptDir%\thread\keysdetection.ahk

; TODO make this class generic
CreateThread()
{
	InitThreadedObj()
	
	global hModule
	global AhkDllPath
	global AhkDllDir
	
	scriptPath := A_ScriptDir "\thread\keysdetection.ahk"
	
	; Start thread
	hThread := DllCall(AhkDllPath "\ahktextdll","Str",DetectKeyButtonPress_ThreadVersion(),"Str","","Str","","Cdecl UPTR")
	
	; This is unused
	ExitCode := 0
	DllCall("GetExitCodeThread", "Uint", hThread, "UintP", ExitCode)
}

InitThreadedObj()
{
	global AhkDllDir  := A_ScriptDir "\MyAutoHotKeyDLL"
	global AhkDllPath := A_ScriptDir "\MyAutoHotKeyDLL\AutoHotkeyMini.dll"
	global hModule			:= DllCall("LoadLibrary","Str",AhkDllPath)
	global shouldEndThread 	:= false
}

ExitThread()
{
	DllCall(AhkDllPath "\ahkTerminate",”Int”,Timeout,”Cdecl Int”)
	
	global hModule
	DllCall("FreeLibrary","PTR",hThread)	;TODO hModule also works here! Not sure why
	
	ToolTip, End Thread
	
	;Run, regsvr32.exe /u AutoHotkey.dll, %AhkDllDir% 	;Unregister
}

