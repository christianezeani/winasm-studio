.CODE

SelectInTheCombo Proc hWin:DWORD,nLine:DWORD,hCombo:HWND

	Invoke InProcedure,hWin,nLine
	.If EAX==FALSE
		Invoke SendMessage,hCombo,CB_SETCURSEL,0,0
	.Else
		Invoke SendMessage,hCombo,CB_SELECTSTRING ,-1,EAX
	.EndIf
	RET
SelectInTheCombo EndP

DeleteProcTreeItems Proc hWndEdit:DWORD
Local lvfi:LV_FINDINFO
	MOV lvfi.flags,LVFI_PARAM
	M2M lvfi.lParam,hWndEdit
	@@:
	Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_FINDITEM,-1,ADDR lvfi
	.If EAX!=-1 ;i.e if there is such text in the list
		Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_DELETEITEM,EAX,0
		JMP @B
	.EndIf
	RET
DeleteProcTreeItems EndP

UpdateProcCombo Proc Uses ESI hWndEdit:DWORD,hCombo:DWORD
Local nLine:DWORD

	Invoke SendMessage,hCombo,CB_RESETCONTENT,0,0
	Invoke SendMessage,hCombo,CB_ADDSTRING,0,Offset szSelectProcedureOrGoToTop
	MOV nLine,-1
	@@:
	Invoke SendMessage,hWndEdit,CHM_NXTBOOKMARK,nLine,1
	.If EAX!=-1
		MOV nLine,EAX
		Invoke SendMessage,hWndEdit,CHM_ISLINE,nLine,Offset szProc
		.If EAX !=-1
			CALL AddName
		.EndIf
		JMP @B
	.EndIf
	MOV nLine,-1
	@@:
	Invoke SendMessage,hWndEdit,CHM_NXTBOOKMARK,nLine,2
	.If EAX!=-1
		MOV nLine,EAX
		Invoke SendMessage,hWndEdit,CHM_ISLINE,nLine,Offset szProc
		.If EAX !=-1
			CALL AddName
		.EndIf
		JMP @B
	.EndIf
	Invoke SendMessage,hCombo,CB_SETCURSEL,0,0
	RET
	;-----------------------------------------------------------------------
	AddName:
	Invoke GetLineText,hWndEdit,nLine,Offset tmpBuffer
	.If szProc[0]=="$"
		Invoke GetFirstWordOfLine,Offset tmpBuffer
	.Else
		Invoke GetSecondWordOfLine,Offset tmpBuffer	
	.EndIf
	Invoke SendMessage,hCombo,CB_ADDSTRING,0,EAX
	RETN
UpdateProcCombo EndP

UpdateBlocksList Proc Uses ESI EDI hWndEdit:DWORD
LOCAL nLine			:DWORD
LOCAL Buffer[256]	:BYTE
Local lvi			:LVITEM

;PrintHex 1
	MOV lvi.imask, LVIF_TEXT OR LVIF_PARAM OR LVIF_IMAGE
	M2M lvi.lParam,hWndEdit
	MOV lvi.iSubItem, 0
	MOV lvi.cchTextMax,256

	MOV nLine,-1
	@@:
	Invoke SendMessage,hWndEdit,CHM_NXTBOOKMARK,nLine,1
	.If EAX!=-1
		MOV nLine,EAX
		Invoke SendMessage,hWndEdit,CHM_ISLINE,nLine,Offset szProc
		.If EAX !=-1
			MOV EDI, Offset szProc
			MOV lvi.iImage,7
		.Else
			Invoke SendMessage,hWndEdit,CHM_ISLINE,nLine,Offset szMacro
			.If EAX!=-1
				MOV EDI, Offset szMacro
				MOV lvi.iImage,3
			.Else	;szStruct
				MOV EDI, Offset szStruct
				MOV lvi.iImage,8
			.EndIf
		.EndIf			
		CALL AddName
		JMP @B
	.EndIf
	MOV nLine,-1
	@@:
	Invoke SendMessage,hWndEdit,CHM_NXTBOOKMARK,nLine,2
	.If EAX!=-1
		MOV nLine,EAX
		Invoke SendMessage,hWndEdit,CHM_ISLINE,nLine,Offset szProc
		.If EAX !=-1
			MOV EDI, Offset szProc
			MOV lvi.iImage,7
		.Else
			Invoke SendMessage,hWndEdit,CHM_ISLINE,nLine,Offset szMacro
			.If EAX!=-1
				MOV EDI, Offset szMacro
				MOV lvi.iImage,3
			.Else	;szStruct
				MOV EDI, Offset szStruct
				MOV lvi.iImage,8
			.EndIf
		.EndIf			
		CALL AddName
		JMP @B
	.EndIf
	RET
	;-----------------------------------------------------------------------
	AddName:
	Invoke GetLineText,hWndEdit,nLine,Offset tmpBuffer

	.If BYTE PTR [EDI]=="$"
		Invoke GetFirstWordOfLine,Offset tmpBuffer
	.Else
		Invoke GetSecondWordOfLine,Offset tmpBuffer	
	.EndIf
	;Invoke GetFirstWordOfLine,hWndEdit,nLine,ADDR tmpBuffer
	
	
	MOV lvi.iItem,0
	MOV lvi.pszText,EAX
	Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_INSERTITEM,0,ADDR lvi
	RETN
UpdateBlocksList EndP