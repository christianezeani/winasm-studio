
.DATA?
hEditStringTable			HWND ?
lpPrevEditStringTableProc	DWORD ?
bStringTableModified		DWORD ?


.CODE

ExtractStringTable Proc Uses EBX ESI EDI lpRCMem:DWORD,lpProMem:DWORD
Local Buffer[256]	:BYTE
	.If !lpStringTableMem
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,1024 * SizeOf STRINGMEM
		MOV lpStringTableMem,EAX
	.EndIf
	MOV EDI,lpStringTableMem
	PUSH EDI
	
	MOV ESI,lpRCMem
	XOR EBX,EBX
	
	@@:
	ADD ESI,EBX
	Invoke GetWord,Offset ThisWord,ESI
	MOV EBX,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szPRELOAD
	OR EAX,EAX
	JE @B
	Invoke lstrcmpi,Offset ThisWord,Offset szLOADONCALL
	OR EAX,EAX
	JE @B
	Invoke lstrcmpi,Offset ThisWord,Offset szFIXED
	OR EAX,EAX
	JE @B
	Invoke lstrcmpi,Offset ThisWord,Offset szMOVEABLE
	OR EAX,EAX
	JE @B
	Invoke lstrcmpi,Offset ThisWord,Offset szDISCARDABLE
	OR EAX,EAX
	JE @B
	Invoke lstrcmpi,Offset ThisWord,Offset szPURE
	OR EAX,EAX
	JE @B
	Invoke lstrcmpi,Offset ThisWord,Offset szIMPURE
	OR EAX,EAX
	JE @B
	
	@@:
	Invoke GetWord,Offset ThisWord,ESI
	add ESI,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szBEGINSHORT
	.EndIf
	.If !EAX
		
		@@:
		Invoke GetWord,Offset ThisWord,ESI
		add ESI,EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szEND
		.If EAX
			Invoke lstrcmpi,Offset ThisWord,Offset szENDSHORT
		.EndIf
		.If EAX
			Invoke GetName,lpProMem,Offset ThisWord,addr [EDI].STRINGMEM.szName,addr [edi].STRINGMEM.Value
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
			Invoke UnQuoteWord,Offset ThisWord
			Invoke lstrcpy,addr [EDI].STRINGMEM.szString,Offset ThisWord
			ADD EDI,SizeOf STRINGMEM
			JMP @B
		.EndIf
	.EndIf

	POP EDI
	.If !hStringTableParentItem
		Invoke AddToOthersTree,5,Offset szStringTable,EDI
		MOV hStringTableParentItem,EAX
	.EndIf

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ExtractStringTable EndP

GiveCellFocus Proc Uses ESI hList:HWND, Item:DWORD, SubItem:DWORD
Local Rect			:RECT
Local Buffer[256]	:BYTE

	MOV EAX,Item
	MOV ItemBeingEdited,EAX
	
	MOV EAX,SubItem
	MOV SubItemBeingEdited,EAX
	
	MOV Rect.top,EAX
	MOV Rect.left,LVIR_LABEL
	
	;So that the EM_LIMITTEXT has the proper effect
	Invoke SendMessage,hEditStringTable,WM_SETTEXT,0,Offset szNULL
	Invoke GetWindowLong,hEditStringTable,GWL_STYLE
	.If SubItemBeingEdited==1	;(i.e. ID)
		OR EAX,ES_NUMBER
		MOV ESI,10
	.Else
		AND EAX,-1 XOR ES_NUMBER
		.If SubItemBeingEdited==0	;(i.e. IDName)
			MOV ESI,31
		.Else	;i.e.==2 ---->String
			MOV ESI,127
		.EndIf
	.EndIf
	Invoke SetWindowLong,hEditStringTable,GWL_STYLE,EAX
	Invoke SendMessage,hEditStringTable,EM_LIMITTEXT,ESI,0
	
	Invoke SendMessage,hList,LVM_GETSUBITEMRECT,Item,ADDR Rect
	MOV ECX,Rect.bottom
	SUB ECX,Rect.top
	DEC ECX
	.If SubItem!=0
		ADD Rect.left,3
	.EndIf
	MOV EAX,Rect.right
	SUB EAX,Rect.left
	
	Invoke SetWindowPos,hEditStringTable,NULL,Rect.left,Rect.top,EAX,ECX,SWP_SHOWWINDOW
	Invoke GetItemText,hList,Item,SubItem,ADDR Buffer
	Invoke SendMessage,hEditStringTable,WM_SETTEXT,0,ADDR Buffer
	Invoke SendMessage,hEditStringTable,WM_GETTEXTLENGTH,0,0
	Invoke SendMessage,hEditStringTable,EM_SETSEL,EAX,EAX
	Invoke SendMessage,hEditStringTable,EM_SETMODIFY,FALSE,0
	Invoke SetFocus,hEditStringTable

	RET
GiveCellFocus EndP

EditStringTableProc Proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]	:BYTE
	.If uMsg==WM_KILLFOCUS
		Invoke SendMessage,hWnd,EM_GETMODIFY,0,0
		.If EAX
			MOV bStringTableModified,TRUE
		.EndIf
		
		Invoke SendMessage,hWnd,WM_GETTEXT,256,ADDR Buffer
		Invoke GetParent,hWnd
		MOV ECX,EAX
		Invoke SetItemText,ECX,ItemBeingEdited,SubItemBeingEdited,ADDR Buffer
		Invoke ShowWindow,hWnd,SW_HIDE
	.ElseIf uMsg==WM_KEYDOWN
		.If wParam==VK_TAB || wParam==VK_RETURN
			PUSH EDI
			Invoke GetParent,hWnd
			MOV EDI,EAX
			Invoke SetFocus,EDI	;List
			
			Invoke GetKeyState, VK_SHIFT
			AND EAX,80h
			.If EAX==80h	;Shift is pressed
				.If SubItemBeingEdited==1 || SubItemBeingEdited==2
					DEC SubItemBeingEdited
					Invoke GiveCellFocus,EDI,ItemBeingEdited,SubItemBeingEdited
				.EndIf
			.Else
				.If SubItemBeingEdited==0 || SubItemBeingEdited==1
					INC SubItemBeingEdited
					Invoke GiveCellFocus,EDI,ItemBeingEdited,SubItemBeingEdited
				.EndIf
			.EndIf
			
			POP EDI
		.ElseIf wParam==VK_ESCAPE
			XOR EAX,EAX
			RET
		.EndIf
	.EndIf
	Invoke CallWindowProc,lpPrevEditStringTableProc,hWnd,uMsg,wParam,lParam
	RET
EditStringTableProc EndP

StringTableDialogProc Proc Uses EDI ESI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lvc			:LV_COLUMN
Local lvi			:LVITEM
Local Buffer[256]	:BYTE
Local Buffer2[256]	:BYTE
Local hList			:HWND
Local Rect			:RECT
	.If uMsg == WM_INITDIALOG
		MOV bStringTableModified,FALSE
		
		Invoke GetDlgItem,hWnd,1	;Get List handle
		MOV hList,EAX
		Invoke SendMessage,hList,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_GRIDLINES OR LVS_EX_FULLROWSELECT
		MOV lvc.imask, LVCF_TEXT OR LVCF_WIDTH OR LVCF_FMT
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.cchTextMax,MAX_PATH
		MOV lvc.pszText,Offset szName
		MOV lvc.lx,150
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 0, ADDR lvc
		
		MOV lvc.pszText,Offset szID
		MOV lvc.lx,72
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 1, ADDR lvc
		
		MOV lvc.pszText,Offset szString
		MOV lvc.lx,200
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 2, ADDR lvc
		
		.If lpStringTableMem
			MOV EDI,lpStringTableMem
			MOV lvi.imask,LVIF_TEXT; OR LVIF_IMAGE
			MOV lvi.cchTextMax,256
			XOR ESI,ESI
			.While [EDI].STRINGMEM.szName || [EDI].STRINGMEM.Value
				MOV lvi.iSubItem,0
				MOV lvi.iItem,ESI
				LEA EAX,[EDI].STRINGMEM.szName
				MOV lvi.pszText,EAX
				Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
				
				MOV lvi.iSubItem, 1
				Invoke BinToDec,[EDI].STRINGMEM.Value,ADDR Buffer
				LEA EAX,Buffer
				MOV lvi.pszText,EAX
				Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
				
				MOV lvi.iSubItem, 2
				LEA EAX,[EDI].STRINGMEM.szString
				MOV lvi.pszText,EAX
				Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
				
				LEA EDI,[EDI+SizeOf STRINGMEM]
				INC ESI
			.EndW
		.EndIf
		
		;I don't really need more than on line. I use ES_MULTILINE simply so that I can catch TAB & Enter keys
		; OR ES_MULTILINE
		Invoke CreateWindowEx,NULL,ADDR szEditClass,NULL,WS_CHILD OR ES_AUTOHSCROLL OR ES_MULTILINE,0,0,0,0,hList,100,hInstance,NULL
		MOV hEditStringTable,EAX
		Invoke SendMessage,hWnd,WM_GETFONT,0,0
		Invoke SendMessage,hEditStringTable,WM_SETFONT,EAX,FALSE
		Invoke SetWindowLong,hEditStringTable,GWL_WNDPROC,Offset EditStringTableProc
		MOV lpPrevEditStringTableProc,EAX
		
		Invoke SetWindowLong,hList,GWL_WNDPROC,Offset DummyListViewProc
		Invoke SetWindowLong,hList,GWL_USERDATA,EAX

	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			PUSH EAX
			Invoke GetDlgItem,hWnd,1
			MOV hList,EAX
			POP EAX
			.If EAX==4	;Add
				MOV bStringTableModified,TRUE
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				MOV lvi.imask,LVIF_TEXT or LVIF_STATE
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				MOV lvi.iItem,EAX
				MOV lvi.pszText,Offset szNULL
				MOV lvi.state,LVIS_SELECTED or LVIS_FOCUSED
				Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
				MOV EDI,EAX
				Invoke SendMessage,hList,LVM_ENSUREVISIBLE,EDI,FALSE
				Invoke SetFocus,hList
				Invoke GiveCellFocus,hList,EDI,0
			.ElseIf EAX== 5	;Delete
				Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					MOV bStringTableModified,TRUE
					MOV lvi.iItem,EAX
					.If lvi.iItem
						DEC lvi.iItem	;Because after deleting selection, we will select the previous one
					.EndIf
					Invoke SendMessage,hList,LVM_DELETEITEM,EAX,0
					
					MOV lvi.imask,LVIF_STATE
					MOV lvi.iSubItem, 0
					MOV lvi.state,LVIS_SELECTED
					MOV lvi.stateMask,LVIS_SELECTED
					Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
					Invoke SendMessage,hList,LVM_ENSUREVISIBLE,lvi.iItem,FALSE
					Invoke SetFocus,hList
				.EndIf
			.ElseIf EAX==2	;OK
				;So that WM_KILLFOCUS of hEditStringTable is executed first
				Invoke ShowWindow,hEditStringTable,SW_HIDE
				.If !lpStringTableMem
					Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
					MOV lpStringTableMem,EAX
					MOV bStringTableModified,TRUE
				.Else
					MOV EDI,lpStringTableMem
					;Delete all String defines
					.While [EDI].STRINGMEM.szName || [EDI].STRINGMEM.Value
						Invoke DeleteDefine,ADDR [EDI].STRINGMEM.szName
						LEA EDI,[EDI+SizeOf STRINGMEM]
					.EndW
					Invoke RtlZeroMemory,lpStringTableMem,64*1024
				.EndIf
				
				PUSH EBX
				MOV EDI,lpStringTableMem
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				.If EAX
					MOV EBX,EAX
					XOR ESI,ESI
					.While ESI<EBX
						Invoke GetItemText,hList,ESI,0,ADDR Buffer
						Invoke GetItemText,hList,ESI,1,ADDR Buffer2
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
							Invoke GetItemText,hList,ESI,2,ADDR Buffer2
							POP EAX								
							LEA ECX,Buffer2
							.If BYTE PTR [ECX]!=0
								MOV [EDI].STRINGMEM.Value,EAX
								Invoke lstrcpy,ADDR [EDI].STRINGMEM.szName,ADDR Buffer
								Invoke lstrcpy,ADDR [EDI].STRINGMEM.szString,ADDR Buffer2
								LEA EDI,[EDI+SizeOf STRINGMEM]
							.EndIf
						.EndIf
						INC ESI
					.EndW
				.EndIf
				POP EBX
				.If !hStringTableParentItem
					Invoke AddToOthersTree,5,Offset szStringTable,lpStringTableMem
					MOV hStringTableParentItem,EAX
				.EndIf
				
				.If bStringTableModified
					Invoke SetRCModified,TRUE
				.EndIf
				
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.ElseIf EAX== 3	;Cancel
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.EndIf
		.EndIf
		
	.ElseIf uMsg == WM_NOTIFY
		MOV EDI,lParam
		Invoke GetDlgItem,hWnd,1	;ListView
		MOV hList,EAX
		MOV EAX,[EDI].NMITEMACTIVATE.iItem
		.If [EDI].NMHDR.code==NM_DBLCLK
			.If EAX!=-1
				Invoke GiveCellFocus,hList,[EDI].NMITEMACTIVATE.iItem,[EDI].NMITEMACTIVATE.iSubItem
			.EndIf
			
		.ElseIf [EDI].NMHDR.code ==LVN_KEYDOWN
			MOV EAX,lParam
			.If [EAX].LV_KEYDOWN.wVKey==VK_DELETE
				Invoke SendMessage,hWnd,WM_COMMAND, (BN_CLICKED SHL 16) OR 5,0
;			.ElseIf [EAX].LV_KEYDOWN.wVKey==VK_TAB
;				PrintText "HEY"
			.EndIf
;		.ElseIf [EDI].NMHDR.code==LVN_ITEMCHANGED || [EDI].NMHDR.code==0FFFFFFF4h
;			Invoke InvalidateRect,hList,NULL,TRUE
;			Invoke UpdateWindow,hList
		.EndIf
	.ElseIf uMsg == WM_CLOSE
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL
		
;	.ElseIf uMsg==WM_GETDLGCODE
;		MOV EAX,DLGC_WANTALLKEYS
;		RET
	.EndIf
	MOV EAX,FALSE
	RET
StringTableDialogProc EndP
