.386

.MODEL FLAT, STDCALL	;32 bit memory model

OPTION CASEMAP:NONE		;Case sensitive


Include WINDOWS.INC
Include gdi32.inc
Include kernel32.inc
Include user32.inc

IncludeLib user32.lib
IncludeLib kernel32.lib
IncludeLib gdi32.lib

;Structure for storing data unique to each child window
CHILDWINDOWDATA STRUCT
	hEditor		DWORD ?
	hCombo		DWORD ?
	hTreeItem	DWORD ?
	dwTypeOfFile	DWORD ?
	FileName	DB MAX_PATH DUP(?)
	fNotOnDisk	DWORD ?	;This is 1 for new files not saved on any media
	fTimer		DWORD ?
	bSelection	DWORD ?	;In NewEditorProc it is set if there is selection
						;In ChildWndProc if it is set, fTimer is set so that
						;in TimerUpdateProcedures the Procedure List is updated
CHILDWINDOWDATA ENDS

.CODE

;BinToDec Proc dwValue:DWORD, lpBuffer:DWORD
;
;    ; -------------------------------------------------------------
;    ; convert DWORD to ascii string
;    ; dwValue is value to be converted
;    ; lpBuffer is the address of the receiving buffer
;    ; Uses: eax, ecx, edx.
;    ; -------------------------------------------------------------
;
;    PUSH EBX
;    PUSH ESI
;    PUSH EDI
;
;    MOV EAX, dwValue
;    MOV EDI, [lpBuffer]
;
;    OR EAX,EAX
;    JNZ Sign
;
;  Zero:
;    MOV WORD PTR [EDI],30H
;    RET
;
;  Sign:
;    JNS Pos
;    MOV BYTE PTR [EDI],'-'
;    NEG EAX
;    INC EDI
;
;  Pos:
;    MOV ECX, 3435973837
;    MOV ESI, EDI
;
;    .WHILE (EAX > 0)
;      MOV EBX,EAX
;      MUL ECX
;      SHR EDX, 3
;      MOV EAX,EDX
;      LEA EDX,[EDX*4+EDX]
;      ADD EDX,EDX
;      SUB EBX,EDX
;      ADD BL,'0'
;      MOV [EDI],BL
;      INC EDI
;    .ENDW
;
;    MOV BYTE PTR [EDI], 0       ; terminate the string
;
;    ; We now have all the digits, but in reverse order.
;
;    .WHILE (ESI < EDI)
;      DEC EDI
;      MOV AL, [ESI]
;      MOV AH, [EDI]
;      MOV [EDI], AL
;      MOV [ESI], AH
;      INC ESI
;    .ENDW
;
;    POP EDI
;    POP ESI
;    POP EBX
;    RET
;
;BinToDec EndP

BinToDec Proc dwVal:DWORD,lpAscii:DWORD

	PUSH EBX		
	PUSH ESI
	PUSH EDI
	
	MOV EAX,dwVal
	MOV EDI,lpAscii
	OR EAX,EAX
	JNS pos
	MOV BYTE PTR [EDI],'-'
	NEG EAX

	INC EDI
pos:
	MOV ECX,429496730
	MOV ESI,EDI
@@:
	MOV EBX,EAX
	MUL ECX
	MOV EAX,EDX
	LEA EDX,[EDX*4+EDX]
	ADD EDX,EDX
	SUB EBX,EDX
	ADD BL,'0'
	MOV [EDI],BL
	INC EDI
	OR EAX,EAX
	JNE @B
	MOV BYTE PTR [EDI],AL
	.While ESI<EDI
		DEC EDI
		MOV AL,[ESI]
		MOV AH,[EDI]
		MOV [EDI],AL
		MOV [ESI],AH
		INC ESI
	.EndW
	POP EDI
	POP ESI
	POP EBX
	RET

BinToDec EndP

IsThereSuchAClass Proc lpClassName:DWORD
Local wc:WNDCLASSEX
	Invoke GetClassInfoEx,NULL,lpClassName,ADDR wc
	RET
IsThereSuchAClass EndP

ReplaceBackSlashWithSlash Proc lpString:DWORD
	MOV EAX,lpString
	.While BYTE PTR [EAX]!=0
		.If BYTE PTR [EAX]=="\"
			MOV BYTE PTR [EAX],"/"
		.EndIf
		INC EAX
	.EndW
	RET
ReplaceBackSlashWithSlash EndP

;Delete all Files in the specified directory
DeleteFiles Proc lpPath:DWORD, lpFindString:DWORD
Local FindFileData	:WIN32_FIND_DATA
Local hFindFile		:HANDLE
Local Buffer[256]	:BYTE

	Invoke lstrcpy, ADDR Buffer, lpPath
	Invoke lstrcat, ADDR Buffer, lpFindString
	Invoke FindFirstFile,ADDR Buffer,ADDR FindFileData
	MOV hFindFile, EAX
	.If hFindFile!=INVALID_HANDLE_VALUE
		Invoke lstrcpy, ADDR Buffer, lpPath
		
		Invoke lstrcat, ADDR Buffer, ADDR FindFileData.cFileName
		Invoke DeleteFile, ADDR Buffer
	@@:
		Invoke FindNextFile, hFindFile, ADDR FindFileData
		.If EAX!=0
			Invoke lstrcpy, ADDR Buffer, lpPath
			Invoke lstrcat, ADDR Buffer, ADDR FindFileData.cFileName
			Invoke DeleteFile, ADDR Buffer
			JMP @B
		.EndIf
		
	.EndIf
	Invoke FindClose, hFindFile

	RET
DeleteFiles EndP

;fCaseChange=0	To Upper Case
;fCaseChange=1	To Lower Case
;fCaseChange=2	Toggle Case
ChangeCase Proc Uses EBX hChild:HWND, fCaseChange:DWORD
Local chrg	:CHARRANGE
Local hMem	:DWORD

	Invoke GetWindowLong,hChild,0
	MOV EBX,CHILDWINDOWDATA.hEditor[EAX]

	Invoke SendMessage,EBX,EM_EXGETSEL,0,addr chrg
	;Get size
	MOV EAX,chrg.cpMax
	SUB EAX,chrg.cpMin
	;Allow room for terminating zero
	INC EAX
	;Allocate memory for the selected text
	Invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,EAX
	MOV hMem,EAX
	Invoke GlobalLock,hMem
	;Get the selected text
	Invoke SendMessage,EBX,EM_GETSELTEXT,0,hMem
	PUSH EDI
	
	;Start
	MOV EDI,hMem
	@@:
	MOV AL,[EDI]
	.If AL>='A' && AL<='Z'
		.If fCaseChange 
			OR BYTE PTR [EDI],20h
		.EndIf
	.ElseIf AL>='a' && AL<='z' && fCaseChange!=1
		AND BYTE PTR [EDI],5Fh
	.EndIf
	INC EDI
	OR AL,AL
	JNE @B
	
	POP EDI
	;Replace selected text
	Invoke SendMessage,EBX,EM_REPLACESEL,TRUE,hMem
	;Restore selection
	Invoke SendMessage,EBX,EM_EXSETSEL,0,ADDR chrg
	;Free the memory
	Invoke GlobalUnlock,hMem
	Invoke GlobalFree,hMem

	RET
	
ChangeCase EndP

;Returns lParam of List Item
SetItemParameter Proc hList:HWND, nItem:DWORD, lParam:DWORD
Local lvi:LVITEM
	PUSH nItem
	POP lvi.iItem
	
	MOV lvi.iSubItem,0
	MOV lvi.imask, LVIF_PARAM
	PUSH lParam
	POP lvi.lParam
	Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
	RET
SetItemParameter EndP

;Returns lParam of List Item
GetItemParameter Proc hList:HWND, nItem:DWORD
Local lvi:LVITEM
	PUSH nItem
	POP lvi.iItem
	;M2M lvi.iItem,nItem
	;PUSH nSubItem
	;POP lvi.iSubItem
	MOV lvi.iSubItem,0
	MOV lvi.imask, LVIF_PARAM
	Invoke SendMessage,hList,LVM_GETITEM,0,ADDR lvi
	MOV EAX,lvi.lParam
	RET
GetItemParameter EndP

RemoveFileExt Proc lpFileName:DWORD
	Invoke lstrlen,lpFileName
	MOV EDX,lpFileName
	.While EAX
		DEC EAX
		.If BYTE PTR [EDX+EAX]=='.'
			MOV BYTE PTR [EDX+EAX],0
			.Break
		.EndIf
	.EndW
	RET
RemoveFileExt EndP


GetFilePath Proc lpFileName:DWORD, lpFilePath:DWORD
	Invoke lstrcpy,lpFilePath,lpFileName
	Invoke lstrlen,lpFilePath
	MOV EDX,lpFilePath
	.While EAX
		DEC EAX
		.If BYTE PTR [EDX+EAX]!='\'
			;INC EAX ;i.e. leave \ in the returned string
			MOV BYTE PTR [EDX+EAX],0
		.Else
			.Break
		.EndIf
	.EndW
	RET
GetFilePath EndP

ClearPendingMessages Proc hWnd:HWND,wMsgFilterMin:DWORD,wMsgFilterMax:DWORD
Local msg		:MSG
	.While TRUE
		Invoke PeekMessage,ADDR msg,hWnd,wMsgFilterMin,wMsgFilterMax,PM_REMOVE
		.Break .If !EAX
	.EndW
	RET
ClearPendingMessages EndP

GetFileName Proc lpFullPathFileName:DWORD, lpFileName:DWORD
	Invoke lstrlen, lpFullPathFileName
	MOV EDX,lpFullPathFileName
	.While EAX
		DEC EAX
		MOV CL,BYTE PTR [EDX+EAX]
		.If CL=='\' || CL=='/'
			ADD EAX,EDX
			INC EAX
			Invoke lstrcpy, lpFileName, EAX
			JMP Ex
		.EndIf
	.EndW

	Invoke lstrcpy, lpFileName, lpFullPathFileName

	Ex:
	RET
GetFileName EndP

GetFilesTitle Proc lpFullPathFileName:DWORD, lpFileTitle:DWORD
	Invoke lstrlen, lpFullPathFileName
	MOV EDX,lpFullPathFileName
	.While EAX
		DEC EAX
		MOV CL,BYTE PTR [EDX+EAX]
		.If CL=='\' 
			ADD EAX,EDX
			INC EAX
			Invoke lstrcpy, lpFileTitle, EAX
			JMP Ex
		.EndIf
	.EndW

	Invoke lstrcpy, lpFileTitle, lpFullPathFileName

	Ex:
	RET
GetFilesTitle EndP

DrawFocusRectangle Proc Uses EBX hWnd:HWND, lpRect:DWORD

Local hDC:HDC

	MOV EBX,lpRect
	
	Invoke GetDC,hWnd
	MOV hDC,EAX
	Invoke SetROP2,hDC,R2_NOTXORPEN	
	
	Invoke CreatePen,PS_DOT,1,0
	PUSH EAX
	
	Invoke SelectObject,hDC,EAX
	PUSH EAX

	Invoke GetStockObject,NULL_BRUSH
	Invoke SelectObject,hDC,EAX
	PUSH EAX
	
	
	Invoke Rectangle,hDC,[EBX].RECT.left,[EBX].RECT.top,[EBX].RECT.right,[EBX].RECT.bottom
	
	POP EAX
	Invoke SelectObject,hDC,EAX

	POP EAX
	Invoke SelectObject,hDC,EAX
	
	POP EAX
	Invoke DeleteObject,EAX
	
	Invoke ReleaseDC,hWnd,hDC
	RET
DrawFocusRectangle EndP

;Draws a 2 pixel thick rectangle
DrawRectangle Proc Uses EBX hWnd:HWND, lpRect:DWORD
Local hDC:HDC

	MOV EBX,lpRect
	
	Invoke GetDC,hWnd
	MOV hDC,EAX

	Invoke GetStockObject,GRAY_BRUSH
	;Invoke CreateSolidBrush,0C0C0C0h
	;PUSH EAX
	Invoke SelectObject,hDC,EAX
	PUSH EAX
	
	;Left Line
	MOV EDX,[EBX].RECT.top
	ADD EDX,2
	MOV ECX,[EBX].RECT.bottom
	SUB ECX,2
	SUB ECX,[EBX].RECT.top
	Invoke PatBlt,hDC,[EBX].RECT.left,EDX,2,ECX,PATINVERT

	;Right Line
	MOV EDX,[EBX].RECT.right
	SUB EDX,2
	MOV ECX,[EBX].RECT.top
	ADD ECX,2
	MOV EAX,[EBX].RECT.bottom
	SUB EAX,2
	SUB EAX,[EBX].RECT.top
	Invoke PatBlt,hDC,EDX,ECX,2,EAX,PATINVERT

	;Top Line
	MOV ECX,[EBX].RECT.right
	SUB ECX,[EBX].RECT.left
	Invoke PatBlt,hDC,[EBX].RECT.left,[EBX].RECT.top,ECX,2,PATINVERT
	
	;Bottom Line
	MOV ECX,[EBX].RECT.left
	ADD ECX,2
	MOV EAX,[EBX].RECT.bottom
	SUB EAX,2
	MOV EDX,[EBX].RECT.right
	SUB EDX,ECX
	SUB EDX,2
	Invoke PatBlt,hDC,ECX,EAX,EDX,2,PATINVERT

	POP EAX
	Invoke SelectObject,hDC,EAX
	;POP EAX
	;Invoke DeleteObject,eax

	Invoke ReleaseDC,hWnd,hDC
	RET

DrawRectangle EndP

GetTextRange Proc hEdit:DWORD, lpBuffer:DWORD, BufferSize:DWORD, lpchrg:DWORD
Local txtrange:TEXTRANGE

	PUSH lpBuffer
	POP txtrange.lpstrText
	MOV ECX,lpchrg
	PUSH [ECX].CHARRANGE.cpMin
	POP txtrange.chrg.cpMin
	
	PUSH [ECX].CHARRANGE.cpMax
	POP txtrange.chrg.cpMax

	Invoke SendMessage,hEdit,EM_GETTEXTRANGE,0,ADDR txtrange
	RET
GetTextRange EndP


End