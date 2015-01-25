
Lock()
{
	mutex := CreateMutex()
	waitTimeout := -1
	if( mutex )
	{
		DllCall("WaitForSingleObject", UInt, mutex, Int, 0xFFFFFFFF)
		return mutex
	}
	return 0
}

Unlock( ByRef mutex )
{
	if( mutex )
	{
		; Release mutex
		DllCall("ReleaseMutex", "UInt", mutex)
		
		; Free the mutex
		DllCall("CloseHandle", UInt, mutex)
	}
}

; TODO private?
CreateMutex( mutexName="MyMutex" )
{
	if ( mutex := DllCall("CreateMutex", "UInt", 0, "Int", false, "Str", mutexName) )
	{
		return mutex
	}
	return 0
}

; This is an example NOT USED!
MutexExists(name) {
    mutex := DllCall("CreateMutex", "uint", 0, "int", false, "str", name)
    last_error := A_LastError
    DllCall("CloseHandle", "uint", mutex)
    return last_error == 183 ; ERROR_ALREADY_EXISTS
}