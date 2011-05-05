szAclKeys		DB 30h,'"0"',0
				DB 31h,'"1"',0
				DB 32h,'"2"',0
				DB 33h,'"3"',0
				DB 34h,'"4"',0
				DB 35h,'"5"',0
				DB 36h,'"6"',0
				DB 37h,'"7"',0
				DB 38h,'"8"',0
				DB 39h,'"9"',0
				DB 41h,'"A"',0
				DB 42h,'"B"',0
				DB 43h,'"C"',0
				DB 44h,'"D"',0
				DB 45h,'"E"',0
				DB 46h,'"F"',0
				DB 47h,'"G"',0
				DB 48h,'"H"',0
				DB 49h,'"I"',0
				DB 4Ah,'"J"',0
				DB 4Bh,'"K"',0
				DB 4Ch,'"L"',0
				DB 4Dh,'"M"',0
				DB 4Eh,'"N"',0
				DB 4Fh,'"O"',0
				DB 50h,'"P"',0
				DB 51h,'"Q"',0
				DB 52h,'"R"',0
				DB 53h,'"S"',0
				DB 54h,'"T"',0
				DB 55h,'"U"',0
				DB 56h,'"V"',0
				DB 57h,'"W"',0
				DB 58h,'"X"',0
				DB 59h,'"Y"',0
				DB 5Ah,'"Z"',0
				DB 70h,'VK_F1',0
				DB 71h,'VK_F2',0
				DB 72h,'VK_F3',0
				DB 73h,'VK_F4',0
				DB 74h,'VK_F5',0
				DB 75h,'VK_F6',0
				DB 76h,'VK_F7',0
				DB 77h,'VK_F8',0
				DB 78h,'VK_F9',0
				DB 79h,'VK_F10',0
				DB 7Ah,'VK_F11',0
				DB 7Bh,'VK_F12',0
				DB 08h,'VK_BACK',0
				DB 09h,'VK_TAB',0
				DB 0Dh,'VK_RETURN',0
				DB 1Bh,'VK_ESCAPE',0
				DB 27h,'VK_INSERT',0
				DB 2Eh,'VK_DELETE',0
				DB 24h,'VK_HOME',0
				DB 23h,'VK_END',0
				DB 20h,'VK_SPACE',0
				DB 21h,'VK_PGUP',0
				DB 22h,'VK_PGDN',0
				DB 26h,'VK_UP',0
				DB 28h,'VK_DOWN',0
				DB 25h,'VK_LEFT',0
				DB 27h,'VK_RIGHT',0
				DB 60h,'VK_NUMPAD0',0
				DB 61h,'VK_NUMPAD1',0
				DB 62h,'VK_NUMPAD2',0
				DB 63h,'VK_NUMPAD3',0
				DB 64h,'VK_NUMPAD4',0
				DB 65h,'VK_NUMPAD5',0
				DB 66h,'VK_NUMPAD6',0
				DB 67h,'VK_NUMPAD7',0
				DB 68h,'VK_NUMPAD8',0
				DB 69h,'VK_NUMPAD9',0
				DB 0


.DATA
szControl		DB "Ctrl",0
szAlt			DB "Alt",0					
szShift			DB "Shift",0
fPushed			DWORD 0

.DATA?
hAcceleratorList						DWORD ?
lpTempAcceleratorsMem					DWORD ?
lpAcceleratorsMem						DWORD ?

hEditAcceleratorTable					DWORD ?
lpPrevEditAcceleratorTableProc			DWORD ?

hSelectAcceleratorComboButton			DWORD ?

lpPrevSelectAcceleratorComboButtonProc	DWORD ?

lpPrevSelectAcceleratorComboListProc	DWORD ?
hSelectAcceleratorComboList				DWORD ?
bAcceleratorTableModified				DWORD ?

.CODE
DrawButton Proc hWin:HWND,fDown:DWORD
LOCAL hDC:HDC
LOCAL rect:RECT

	Invoke GetClientRect,hWin,addr rect
	Invoke GetDC,hWin
	MOV hDC,EAX
	.If fDown
		Invoke DrawFrameControl,hDC,ADDR rect,DFC_SCROLL,DFCS_SCROLLDOWN or DFCS_PUSHED; or DFCS_FLAT
	.Else
		Invoke DrawFrameControl,hDC,ADDR rect,DFC_SCROLL,DFCS_SCROLLDOWN; or DFCS_FLAT
	.EndIf
	Invoke ReleaseDC,hWin,hDC
	RET

DrawButton EndP

 
ExtractAccelerators Proc Uses EBX ESI EDI lpRCMem:DWORD,lpProMem:DWORD
Local Buffer[256]	:BYTE
	MOV ESI,lpRCMem
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
	MOV EDI,EAX
	PUSH EDI	;keep it for later use (at the end of this procedure)
	
	;Name / ID
	Invoke GetName,lpProMem,Offset NameBuffer,ADDR [EDI].ACCELMEM.szName,ADDR [EDI].ACCELMEM.Value
	MOV EAX,[EDI].ACCELMEM.Value
	.If HighestAcceleratorID < EAX
		MOV HighestAcceleratorID,EAX
	.EndIf

	ADD EDI,SizeOf ACCELMEM
	
	Invoke GetLoadOptions,ESI
	ADD ESI,EAX
  @@:
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	MOV EBX,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szCHARACTERISTICS
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szVERSION
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szLANGUAGE
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		JMP @B
	.EndIf
	SUB ESI,EBX
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szBEGINSHORT
	.EndIf
	.If !EAX
	  Nxt:
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szEND
		.If EAX
			Invoke lstrcmpi,Offset ThisWord,Offset szENDSHORT
		.EndIf
		.If EAX
			MOV EAX,DWORD PTR ThisWord
			AND EAX,0FFFFFFh
			.If AL=='"'
				Invoke UnQuoteWord,Offset ThisWord
				MOVZX EAX,ThisWord
			.ElseIf AX=='x0'
				Invoke HexToBin,Offset ThisWord+2
			.ElseIf AL>='0' && AL<='9'
				Invoke DecToBin,Offset ThisWord
			.ElseIf EAX=='_KV'
				PUSH ESI
				MOV ESI,Offset szAclKeys
				.While BYTE PTR [ESI]
					LEA EAX,[ESI+1]
					Invoke lstrcmp,Offset ThisWord,EAX
					.If !EAX
						MOVZX EAX,BYTE PTR [ESI]
						JMP @f
					.EndIf
					Invoke lstrlen,ESI
					LEA ESI,[ESI+EAX+1]
				.EndW
				MOV EAX,41h
			  @@:
				POP ESI
			.Else
				MOV EAX,41h
			.EndIf
			
			MOV EBX,EAX
			PUSH ESI
			PUSH EDI
			XOR EDI,EDI
			MOV ESI,Offset szAclKeys
			.While BYTE PTR [ESI]
				.Break .If BL==BYTE PTR [ESI]
				Invoke lstrlen,ESI
				INC EDI
				LEA ESI,[ESI+EAX+1]
			.EndW
			MOV EAX,EDI
			POP EDI
			POP ESI
			MOV [EDI].ACCELMEM.nkey,EAX
			
			
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
			Invoke GetName,lpProMem,Offset ThisWord,ADDR [EDI].ACCELMEM.szName,ADDR [EDI].ACCELMEM.Value
			XOR EBX,EBX
			.While BYTE PTR [ESI]!=0Dh
				Invoke GetWord,Offset ThisWord,ESI
				ADD ESI,EAX
				Invoke lstrcmpi,Offset ThisWord,Offset szVIRTKEY
				.If !EAX
					JMP @f
				.EndIf
				Invoke lstrcmpi,Offset ThisWord,Offset szNOINVERT
				.If !EAX
					JMP @f
				.EndIf
				Invoke lstrcmpi,Offset ThisWord,Offset szCONTROL
				.If !EAX
					OR EBX,1
					JMP @f
				.EndIf
				Invoke lstrcmpi,Offset ThisWord,Offset szSHIFT
				.If !EAX
					OR EBX,2
					JMP @f
				.EndIf
				Invoke lstrcmpi,Offset ThisWord,Offset szALT
				.If !EAX
					OR EBX,4
				.EndIf
			  @@:
			.EndW
			MOV [EDI].ACCELMEM.flag,EBX
			ADD EDI,SizeOf ACCELMEM
			JMP Nxt
		.EndIf
	.EndIf
	POP EDI	;Pointer to Memory of this Accelerator Table
	LEA EAX,[EDI].ACCELMEM.szName
	.If BYTE PTR [EAX]==0
		Invoke BinToDec,[EDI].ACCELMEM.Value,ADDR Buffer
		LEA EAX,Buffer
	.EndIf
	Invoke AddToOthersTree,1,EAX,EDI
	MOV [EDI].ACCELMEM.hTreeItem,EAX
	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ExtractAccelerators EndP

EditAcceleratorTableProc Proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]	:BYTE
	.If uMsg==WM_KILLFOCUS
		Invoke SendMessage,hWnd,EM_GETMODIFY,0,0
		.If EAX
			MOV bAcceleratorTableModified,TRUE
		.EndIf
		
		Invoke SendMessage,hWnd,WM_GETTEXT,256,ADDR Buffer
		Invoke GetParent,hWnd
		MOV ECX,EAX
		Invoke SetItemText,ECX,ItemBeingEdited,SubItemBeingEdited,ADDR Buffer
		Invoke ShowWindow,hWnd,SW_HIDE
	.EndIf
	
	Invoke CallWindowProc,lpPrevEditAcceleratorTableProc,hWnd,uMsg,wParam,lParam
	RET
EditAcceleratorTableProc EndP

SelectAcceleratorComboListProc Proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]:BYTE

	.If uMsg==WM_LBUTTONUP || uMsg==WM_KEYDOWN
		.If uMsg==WM_KEYDOWN && wParam!=VK_RETURN
		.Else
			Invoke SendMessage,hWnd,LB_GETCURSEL,0,0
			.If EAX!=LB_ERR
				MOV ECX,EAX
				Invoke SendMessage,hWnd,LB_GETTEXT,ECX,ADDR Buffer
				Invoke SendMessage,hAcceleratorList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					MOV ECX,EAX
					Invoke SetItemText,hAcceleratorList,ECX,5,ADDR Buffer
					MOV bAcceleratorTableModified,TRUE
				.EndIf				
			.EndIf
			Invoke SetFocus,hAcceleratorList
		.EndIf
	.ElseIf uMsg==WM_MOUSEMOVE
		Invoke SendMessage,hWnd,LB_ITEMFROMPOINT,0,lParam
		Invoke SendMessage,hWnd,LB_SETCURSEL,EAX,0
	.ElseIf uMsg==WM_NCACTIVATE
		;PrintHex lParam
		;Invoke GetParent,hWnd
		Invoke SendMessage,lParam,WM_NCACTIVATE,wParam,0
		MOV EAX,TRUE
		RET
	.ElseIf uMsg==WM_KILLFOCUS
		Invoke ShowWindow,hWnd,SW_HIDE
	.EndIf
	Invoke CallWindowProc,lpPrevSelectAcceleratorComboListProc,hWnd,uMsg,wParam,lParam
	RET
SelectAcceleratorComboListProc EndP

SelectAcceleratorComboButtonProc Proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Rect			:RECT
Local Buffer[256]	:BYTE
Local DesktopRect	:RECT


	.If uMsg==WM_LBUTTONDOWN
		MOV fPushed,TRUE
		Invoke CallWindowProc,lpPrevSelectAcceleratorComboButtonProc,hWnd,uMsg,wParam,lParam
		PUSH EAX
		Invoke IsWindowVisible,hSelectAcceleratorComboList
		.If EAX==0
			Invoke SendMessage,hAcceleratorList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
			.If EAX!=-1
				MOV Rect.top,5
				MOV Rect.left,LVIR_LABEL
				MOV ECX,EAX
				PUSH EAX
				Invoke GetItemText,hAcceleratorList,ECX,5,ADDR Buffer
				POP ECX
				Invoke SendMessage,hAcceleratorList,LVM_GETSUBITEMRECT,ECX,ADDR Rect
				Invoke MapWindowPoints,hAcceleratorList,NULL,ADDR Rect,2
				
				Invoke GetDesktopWindow
				MOV ECX,EAX
				Invoke GetWindowRect,ECX,ADDR DesktopRect
				MOV EAX,Rect.bottom
				ADD EAX,120
				.If EAX>DesktopRect.bottom
					MOV EAX,Rect.top
					SUB EAX,121;0
				.Else
					MOV EAX,Rect.bottom		
				.EndIf
				MOV ECX,Rect.right
				SUB ECX,Rect.left
				Invoke SetWindowPos,hSelectAcceleratorComboList,HWND_TOPMOST,Rect.left,EAX,ECX,120,SWP_SHOWWINDOW; or SWP_NOACTIVATE
				Invoke SendMessage,hSelectAcceleratorComboList,LB_FINDSTRINGEXACT,-1,ADDR Buffer
				.If EAX!=LB_ERR
					Invoke SendMessage,hSelectAcceleratorComboList,LB_SETCURSEL,EAX,0
				.Else
					Invoke SendMessage,hSelectAcceleratorComboList,LB_SETTOPINDEX,0,0
				.EndIf
				Invoke InvalidateRect,hSelectAcceleratorComboList,NULL,TRUE

			.EndIf
		.Else
			Invoke ShowWindow,hSelectAcceleratorComboList,SW_HIDE
		.EndIf
		Invoke SetCapture,hWnd
		POP EAX
		RET
	.ElseIf uMsg==WM_LBUTTONUP
		MOV fPushed,FALSE
		Invoke ReleaseCapture
		Invoke InvalidateRect,hWnd,NULL,TRUE
	.ElseIf uMsg==WM_PAINT
		Invoke CallWindowProc,lpPrevSelectAcceleratorComboButtonProc,hWnd,uMsg,wParam,lParam
		PUSH EAX
		Invoke DrawButton,hWnd,fPushed
		POP EAX
		RET
	.EndIf
	Invoke CallWindowProc,lpPrevSelectAcceleratorComboButtonProc,hWnd,uMsg,wParam,lParam
	RET

SelectAcceleratorComboButtonProc EndP

AcceleratorsDialogProc Proc Uses EBX EDI ESI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lvc			:LV_COLUMN
Local lvi			:LVITEM
Local Buffer[256]	:BYTE
Local tvi			:TVITEM
Local Buffer2[256]	:BYTE
Local Rect			:RECT

	.If uMsg == WM_INITDIALOG
		MOV bAcceleratorTableModified,FALSE
		
		Invoke GetDlgItem,hWnd,1
		MOV hAcceleratorList,EAX
		
		Invoke CreateWindowEx,NULL,ADDR szEditClass,NULL,WS_CHILD,0,0,0,0,hAcceleratorList,100,hInstance,NULL
		MOV hEditAcceleratorTable,EAX
		Invoke SendMessage,hWnd,WM_GETFONT,0,0
		Invoke SendMessage,hEditAcceleratorTable,WM_SETFONT,EAX,FALSE
		Invoke SetWindowLong,hEditAcceleratorTable,GWL_WNDPROC,Offset EditAcceleratorTableProc
		MOV lpPrevEditAcceleratorTableProc,EAX
		
		Invoke CreateWindowEx,NULL,ADDR szButton,NULL,WS_CHILD + WS_CLIPSIBLINGS,0,0,0,0,hAcceleratorList,400,hInstance,NULL
		MOV hSelectAcceleratorComboButton,EAX
		Invoke SetWindowLong,hSelectAcceleratorComboButton,GWL_WNDPROC,Offset SelectAcceleratorComboButtonProc
		MOV lpPrevSelectAcceleratorComboButtonProc,EAX
		
		;hAcceleratorList
		Invoke CreateWindowEx,WS_EX_TOOLWINDOW,Offset szListBoxClass,NULL,WS_POPUP OR WS_CLIPSIBLINGS or WS_BORDER or LBS_HASSTRINGS or LBS_NOINTEGRALHEIGHT or WS_VSCROLL ,0, 0, 0, 0,NULL,NULL,hInstance,0	
		MOV hSelectAcceleratorComboList,EAX
		Invoke SetWindowLong,EAX,GWL_WNDPROC,Offset SelectAcceleratorComboListProc
		MOV lpPrevSelectAcceleratorComboListProc,EAX
		
		Invoke SendMessage,hWnd,WM_GETFONT,0,0
		Invoke SendMessage,hSelectAcceleratorComboList,WM_SETFONT,EAX,FALSE
		
		MOV ESI,Offset szAclKeys
		.While BYTE PTR [ESI]
			LEA EAX,[ESI+1]
			Invoke SendMessage,hSelectAcceleratorComboList,LB_ADDSTRING,0,EAX
			Invoke lstrlen,ESI
			LEA ESI,[ESI+EAX+1]
		.EndW
		
		Invoke SendMessage,hAcceleratorList,LVM_GETEXTENDEDLISTVIEWSTYLE,0,0
		OR EAX, LVS_EX_GRIDLINES OR LVS_EX_FULLROWSELECT 
		Invoke SendMessage,hAcceleratorList,LVM_SETEXTENDEDLISTVIEWSTYLE, 0,EAX
		MOV lvc.imask, LVCF_TEXT OR LVCF_WIDTH OR LVCF_FMT
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.cchTextMax,MAX_PATH
		
		MOV lvc.lx,150
		MOV lvc.pszText,Offset szName
		Invoke SendMessage, hAcceleratorList, LVM_INSERTCOLUMN, 0, ADDR lvc
		
		MOV lvc.pszText,Offset szID
		MOV lvc.lx,72
		Invoke SendMessage, hAcceleratorList, LVM_INSERTCOLUMN, 1, ADDR lvc
		
		MOV lvc.pszText,Offset szControl
		MOV lvc.lx,40
		Invoke SendMessage, hAcceleratorList, LVM_INSERTCOLUMN, 2, ADDR lvc
		
		MOV lvc.pszText,Offset szAlt
		MOV lvc.lx,40
		Invoke SendMessage, hAcceleratorList, LVM_INSERTCOLUMN, 3, ADDR lvc
		
		MOV lvc.pszText,Offset szShift
		MOV lvc.lx,40
		Invoke SendMessage, hAcceleratorList, LVM_INSERTCOLUMN, 4, ADDR lvc
		
		MOV lvc.pszText,Offset szKey
		MOV lvc.lx,94
		Invoke SendMessage, hAcceleratorList, LVM_INSERTCOLUMN, 5, ADDR lvc
		
		.If lParam		;i.e. This is an existing Accelerator Table
			MOV EDI,lParam
			MOV lpAcceleratorsMem,EDI
			MOV lpTempAcceleratorsMem,0
			
			Invoke SetDlgItemText,hWnd,6,ADDR [EDI].ACCELMEM.szName
			Invoke BinToDec,[EDI].ACCELMEM.Value,ADDR Buffer
			Invoke SetDlgItemText,hWnd,7,ADDR Buffer
			
			;I need this because the first entry is the Accelrator Table itself -- not the accelerators
			LEA EDI,[EDI+SizeOf ACCELMEM]
			
			MOV lvi.imask,LVIF_TEXT or LVIF_STATE
			MOV lvi.cchTextMax,256
			MOV lvi.state,LVIS_SELECTED
			XOR ESI,ESI
			.While BYTE PTR [EDI].ACCELMEM.szName || [EDI].ACCELMEM.Value
				MOV lvi.iSubItem,0
				MOV lvi.iItem,ESI
				LEA EAX,[EDI].ACCELMEM.szName
				MOV lvi.pszText,EAX
				Invoke SendMessage,hAcceleratorList,LVM_INSERTITEM,0,ADDR lvi
				
				MOV lvi.iSubItem, 1
				Invoke BinToDec,[EDI].ACCELMEM.Value,ADDR Buffer
				LEA EAX,Buffer
				MOV lvi.pszText,EAX
				Invoke SendMessage,hAcceleratorList,LVM_SETITEM,0,ADDR lvi
				
				MOV EAX,[EDI].ACCELMEM.flag
				AND EAX,1 
				;0=Nothing,1=Control,2=Shift,4=ALT
				.If EAX
					MOV lvi.iSubItem, 2
					LEA EAX,szYes
					MOV lvi.pszText,EAX
					Invoke SendMessage,hAcceleratorList,LVM_SETITEM,0,ADDR lvi
				.EndIf
				
				MOV EAX,[EDI].ACCELMEM.flag
				AND EAX,4 
				;0=Nothing,1=Control,2=Shift,4=ALT
				.If EAX
					MOV lvi.iSubItem, 3
					LEA EAX,szYes
					MOV lvi.pszText,EAX
					Invoke SendMessage,hAcceleratorList,LVM_SETITEM,0,ADDR lvi
				.EndIf
				
				MOV EAX,[EDI].ACCELMEM.flag
				AND EAX,2 
				;0=Nothing,1=Control,2=Shift,4=ALT
				.If EAX
					MOV lvi.iSubItem, 4
					LEA EAX,szYes
					MOV lvi.pszText,EAX
					Invoke SendMessage,hAcceleratorList,LVM_SETITEM,0,ADDR lvi
				.EndIf
				
				MOV lvi.iSubItem, 5
				;Find Accelerator String
				MOV ECX,[EDI].ACCELMEM.nkey
				PUSH ESI
				PUSH EDI
				MOV ESI,Offset szAclKeys
				XOR EDI,EDI
				@@:
				.If EDI!=ECX
					INC ESI
					PUSH ECX
					Invoke lstrlen,ESI
					POP ECX
					ADD ESI,EAX
					INC ESI
					INC EDI
					JMP @B
				.Else
					INC ESI
				.EndIf
				
				;Found at ESI!
				MOV lvi.pszText,ESI
				Invoke SendMessage,hAcceleratorList,LVM_SETITEM,0,ADDR lvi
				POP EDI
				POP ESI
				LEA EDI,[EDI+SizeOf ACCELMEM]
				INC ESI
			.EndW
		.Else	;New Table
			MOV lpTempAcceleratorsMem,1
			MOV lpAcceleratorsMem,0
			INC HighestAcceleratorID
			Invoke lstrcpy,ADDR Buffer,CTEXT("IDA_ACCEL")
			Invoke BinToDec,HighestAcceleratorID,ADDR Buffer[9]
			Invoke SetDlgItemText,hWnd,6,ADDR Buffer
			Invoke SetDlgItemText,hWnd,7,ADDR Buffer[9]
		.EndIf
		
		Invoke SendDlgItemMessage,hWnd,6,EM_SETMODIFY,FALSE,0
		Invoke SendDlgItemMessage,hWnd,7,EM_SETMODIFY,FALSE,0
		
		Invoke SetWindowLong,hAcceleratorList,GWL_WNDPROC,Offset DummyListViewProc
		Invoke SetWindowLong,hAcceleratorList,GWL_USERDATA,EAX
		
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			PUSH EAX
			Invoke GetDlgItem,hWnd,1
			MOV hAcceleratorList,EAX
			POP EAX
			.If EAX==4	;Add
				MOV bAcceleratorTableModified,TRUE
				
				Invoke SendMessage,hAcceleratorList,LVM_GETITEMCOUNT,0,0
				MOV lvi.imask,LVIF_TEXT or LVIF_STATE
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				MOV lvi.iItem,EAX
				MOV lvi.pszText,Offset szNULL
				MOV lvi.state,LVIS_SELECTED or LVIS_FOCUSED
				Invoke SendMessage,hAcceleratorList,LVM_INSERTITEM,0,ADDR lvi
				Invoke SendMessage,hAcceleratorList,LVM_ENSUREVISIBLE,EAX,FALSE
				Invoke SetFocus,hAcceleratorList
			.ElseIf EAX== 5	;Delete
				Invoke SendMessage,hAcceleratorList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					MOV lvi.iItem,EAX
					.If lvi.iItem
						DEC lvi.iItem	;Because after deleting selection, we will select the previous one
					.EndIf
					Invoke SendMessage,hAcceleratorList,LVM_DELETEITEM,EAX,0
					MOV lvi.imask,LVIF_STATE
					MOV lvi.iSubItem, 0
					MOV lvi.state,LVIS_SELECTED or LVIS_FOCUSED
					MOV lvi.stateMask,LVIS_SELECTED
					Invoke SendMessage,hAcceleratorList,LVM_SETITEM,0,ADDR lvi
					Invoke SendMessage,hAcceleratorList,LVM_ENSUREVISIBLE,lvi.iItem,FALSE
					MOV bAcceleratorTableModified,TRUE
					
					Invoke SetFocus,hAcceleratorList
					
				.EndIf
			.ElseIf EAX==2	;OK
				.If lpTempAcceleratorsMem	;i.e This is a New Accelearator Table
					Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
					MOV EDI,EAX
					MOV bAcceleratorTableModified,TRUE
				.Else
					MOV EDI,lpAcceleratorsMem
					.While [EDI].ACCELMEM.szName || [EDI].ACCELMEM.Value
						Invoke DeleteDefine,ADDR [EDI].ACCELMEM.szName
						LEA EDI,[EDI+SizeOf ACCELMEM]
					.EndW
					MOV EDI,lpAcceleratorsMem
					PUSH [EDI].ACCELMEM.hTreeItem
					Invoke RtlZeroMemory,EDI,64*1024
					POP [EDI].ACCELMEM.hTreeItem
				.EndIf
				
				Invoke GetDlgItemText,hWnd,6,ADDR [EDI].ACCELMEM.szName,256
				Invoke GetDlgItemText,hWnd,7,ADDR Buffer,256
				Invoke AddOrReplaceDefine,ADDR [EDI].ACCELMEM.szName,ADDR Buffer
				Invoke DecToBin,ADDR Buffer
				MOV [EDI].ACCELMEM.Value,EAX
				.If HighestAcceleratorID < EAX
					MOV HighestAcceleratorID,EAX
				.EndIf
				
				PUSH EDI
				;-----------------------------
				LEA EDI,[EDI+SizeOf ACCELMEM]
				Invoke SendMessage,hAcceleratorList,LVM_GETITEMCOUNT,0,0
				.If EAX
					MOV EBX,EAX
					XOR ESI,ESI
					.While ESI<EBX
						Invoke GetItemText,hAcceleratorList,ESI,0,ADDR Buffer
						Invoke GetItemText,hAcceleratorList,ESI,1,ADDR Buffer2
						LEA ECX,Buffer
						LEA EDX,Buffer2
						PUSH EDX
						.If BYTE PTR [ECX]!=0 && BYTE PTR [EDX]!=0
							Invoke AddOrReplaceDefine,ECX,EDX
						.EndIf
						POP EDX
						.If BYTE PTR [EDX]!=0
							Invoke DecToBin,ADDR Buffer2
							PUSH EAX
							Invoke GetItemText,hAcceleratorList,ESI,5,ADDR Buffer2
							POP EAX								
							LEA ECX,Buffer2
							.If BYTE PTR [ECX]!=0
								MOV [EDI].ACCELMEM.Value,EAX
								Invoke lstrcpy,ADDR [EDI].ACCELMEM.szName,ADDR Buffer
								
								;Buffer2 is ACCELMEM.nkey
								PUSH ESI
								PUSH EBX
								XOR EBX,EBX
								MOV ESI,Offset szAclKeys
								DEC ESI
								@@:
								ADD ESI,2
								Invoke lstrcmp,ADDR Buffer2,ESI
								.If EAX
									Invoke lstrlen,ESI
									ADD ESI,EAX
									INC EBX
									JMP @B
								.EndIf
								DEC ESI
								MOV [EDI].ACCELMEM.nkey,EBX
								POP EBX
								POP ESI
								
								Invoke GetItemText,hAcceleratorList,ESI,2,ADDR Buffer
								Invoke lstrcmp,ADDR Buffer,Offset szYes
								.If !EAX
									OR [EDI].ACCELMEM.flag,1	;CTRL
								.EndIf
								
								Invoke GetItemText,hAcceleratorList,ESI,3,ADDR Buffer
								Invoke lstrcmp,ADDR Buffer,Offset szYes
								.If !EAX
									OR [EDI].ACCELMEM.flag,4	;ALT
								.EndIf
								
								Invoke GetItemText,hAcceleratorList,ESI,4,ADDR Buffer
								Invoke lstrcmp,ADDR Buffer,Offset szYes
								.If !EAX
									OR [EDI].ACCELMEM.flag,2	;SHIFT
								.EndIf
								
								LEA EDI,[EDI+SizeOf ACCELMEM]
							.EndIf
						.EndIf
						INC ESI
					.EndW
				.EndIf
				
				;ACCELMEM STRUCT
				;	hTreeItem		DWORD ?
				;	szName			DB 32 DUP(?)
				;	Value			DD ?
				;	nkey			DD ?
				;	flag			DD ?	;0=Nothing,1=Control,2=Shift,4=ALT
				;ACCELMEM ENDS
				
				;-----------------------------
				POP EDI
				LEA EAX,[EDI].ACCELMEM.szName
				.If BYTE PTR [EAX]==0
					Invoke BinToDec,[EDI].ACCELMEM.Value,ADDR Buffer
					LEA EAX,Buffer
				.EndIf
				
				.If lpTempAcceleratorsMem	;i.e This is a New Accelearator Table
					Invoke AddToOthersTree,1,EAX,EDI
					MOV [EDI].ACCELMEM.hTreeItem,EAX
				.Else
					MOV tvi._mask,TVIF_TEXT
					MOV tvi.cchTextMax,256
					MOV tvi.pszText,EAX
					M2M tvi.hItem,[EDI].ACCELMEM.hTreeItem
					Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
				.EndIf
				
				Invoke SendDlgItemMessage,hWnd,6,EM_GETMODIFY,0,0
				.If EAX
					MOV bAcceleratorTableModified,TRUE
				.Else
					Invoke SendDlgItemMessage,hWnd,7,EM_GETMODIFY,0,0
					.If EAX
						MOV bAcceleratorTableModified,TRUE
					.EndIf
				.EndIf
				
				.If bAcceleratorTableModified
					Invoke SetRCModified,TRUE
				.EndIf
				
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.ElseIf EAX== 3	;Cancel
				.If lpTempAcceleratorsMem	;i.e This WOULD BE A New Accelearator Table
					DEC HighestAcceleratorID
				.EndIf
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.EndIf
		.EndIf
		
	.ElseIf uMsg == WM_NOTIFY
		MOV EDI,lParam
		Invoke GetDlgItem,hWnd,1	;ListView
		MOV hAcceleratorList,EAX
		.If [EDI].NMHDR.code==NM_DBLCLK
			MOV EAX,[EDI].NMITEMACTIVATE.iItem
			.If EAX!=-1 && ([EDI].NMITEMACTIVATE.iSubItem==0 || [EDI].NMITEMACTIVATE.iSubItem==1)
				;PrintHex EAX
				MOV ItemBeingEdited,EAX
				MOV EAX,[EDI].NMITEMACTIVATE.iSubItem
				MOV SubItemBeingEdited,EAX
				MOV Rect.top,EAX
				
				Invoke GetWindowLong,hEditAcceleratorTable,GWL_STYLE
				.If !Rect.top	;Alphanumeric
					AND EAX,-1 XOR ES_NUMBER
				.Else	;Numeric
					OR EAX,ES_NUMBER
				.EndIf
				Invoke SetWindowLong,hEditAcceleratorTable,GWL_STYLE,EAX
				
				MOV Rect.left,LVIR_LABEL
				Invoke SendMessage,hAcceleratorList,LVM_GETSUBITEMRECT,[EDI].NMITEMACTIVATE.iItem,ADDR Rect
				MOV ECX,Rect.bottom
				SUB ECX,Rect.top
				DEC ECX
				.If [EDI].NMITEMACTIVATE.iSubItem!=0
					ADD Rect.left,3
				.EndIf
				MOV EAX,Rect.right
				SUB EAX,Rect.left
				
				Invoke SetWindowPos,hEditAcceleratorTable,NULL,Rect.left,Rect.top,EAX,ECX,SWP_SHOWWINDOW
				Invoke GetItemText,hAcceleratorList,[EDI].NMITEMACTIVATE.iItem,[EDI].NMITEMACTIVATE.iSubItem,ADDR Buffer
				Invoke SendMessage,hEditAcceleratorTable,WM_SETTEXT,0,ADDR Buffer
				Invoke SendMessage,hEditAcceleratorTable,WM_GETTEXTLENGTH,0,0
				Invoke SendMessage,hEditAcceleratorTable,EM_SETSEL,EAX,EAX
				Invoke SendMessage,hEditAcceleratorTable,EM_SETMODIFY,FALSE,0
				Invoke SetFocus,hEditAcceleratorTable
			.ElseIf [EDI].NMITEMACTIVATE.iSubItem==2 || [EDI].NMITEMACTIVATE.iSubItem==3 || [EDI].NMITEMACTIVATE.iSubItem==4 
				Invoke GetItemText,hAcceleratorList,[EDI].NMITEMACTIVATE.iItem,[EDI].NMITEMACTIVATE.iSubItem,ADDR Buffer
				.If Buffer[0]==0
					LEA ECX,szYes
				.Else
					LEA ECX,szNULL
				.EndIf
				Invoke SetItemText,hAcceleratorList,[EDI].NMITEMACTIVATE.iItem,[EDI].NMITEMACTIVATE.iSubItem,ECX
				MOV bAcceleratorTableModified,TRUE
			.EndIf
		.ElseIf [EDI].NMHDR.code==LVN_ITEMCHANGED || [EDI].NMHDR.code==0FFFFFFF4h
			.If [EDI].NMHDR.code == LVN_ITEMCHANGED
				MOV ECX,[EDI].NM_LISTVIEW.iItem
			.Else
				Invoke SendMessage,hAcceleratorList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				MOV ECX,EAX
			.EndIf
			.If ECX!=-1
				MOV Rect.top,5
				MOV Rect.left,LVIR_LABEL
				Invoke SendMessage,hAcceleratorList,LVM_GETSUBITEMRECT,ECX,ADDR Rect
				MOV ECX,Rect.bottom
				SUB ECX,Rect.top
				DEC ECX
				PUSH ECX
				Invoke GetSystemMetrics,SM_CXVSCROLL
				POP ECX
				SUB Rect.right,EAX
				DEC Rect.right
				Invoke SetWindowPos,hSelectAcceleratorComboButton,HWND_BOTTOM,Rect.right,Rect.top,EAX,ECX,SWP_SHOWWINDOW
				;.If [EDI].NMHDR.code==0FFFFFFF4h
				;	Invoke ShowWindow,hEditAcceleratorTable,SW_HIDE
				;.EndIf
				;Invoke SetWindowPos,hEditAcceleratorTable,NULL,Rect.left,Rect.top,EAX,ECX,SWP_NOZORDER
				Invoke UpdateWindow,hAcceleratorList
			.Else
				Invoke ShowWindow,hSelectAcceleratorComboButton,SW_HIDE
			.EndIf
		;.ElseIf [EDI].NMHDR.code==0FFFFFFF4h	
			
		.EndIf
		
	.ElseIf uMsg == WM_CLOSE
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL
	.EndIf
	MOV EAX,FALSE
	RET
AcceleratorsDialogProc EndP
