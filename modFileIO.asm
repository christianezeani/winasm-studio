.386

.MODEL FLAT, STDCALL	;32 bit memory model

OPTION CASEMAP:NONE		;Case sensitive

;DEBUG_BUILD		EQU 1		;Uncomment for debug builds

Include WINDOWS.INC
Include gdi32.inc
Include kernel32.inc
Include user32.inc
include shell32.inc

;IFDEF DEBUG_BUILD
;	include masm32.inc
;	include debug.inc
;ENDIF

IncludeLib USER32.LIB
IncludeLib KERNEL32.LIB
IncludeLib GDI32.LIB
includelib SHELL32.LIB

;IFDEF DEBUG_BUILD
;	includelib masm32.lib
;	includelib debug.lib
;ENDIF

.CODE

StreamInProc Proc hFile:DWORD,pBuffer:DWORD,NumBytes:DWORD,pBytesRead:DWORD
	Invoke ReadFile,hFile,pBuffer,NumBytes,pBytesRead,0
	XOR EAX,1
	RET
StreamInProc EndP

StreamOutProc Proc hFile:DWORD,pBuffer:DWORD,NumBytes:DWORD,pBytesWritten:DWORD
	Invoke WriteFile,hFile,pBuffer,NumBytes,pBytesWritten,0
	XOR EAX,1
	RET
StreamOutProc EndP

End