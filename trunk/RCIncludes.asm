INCLUDEMEM STRUCT
	szfile			DB MAX_PATH DUP(?)
INCLUDEMEM ENDS

.DATA?
hBrowseButton 		HWND ?
lpPrevBrowseProc	DWORD ?
bIncludesModified	DWORD ?

.CODE

ParseFileName Proc Uses ESI EDI lpRCMem:DWORD
Local nend	:BYTE
	MOV ESI,lpRCMem
	MOV EDI,Offset ThisWord
	CALL SkipSpace
	XOR ECX,ECX
	.While TRUE
		MOV AL,[ESI+ECX]
		.If AL==VK_RETURN
			XOR AL,AL
		.EndIf
		MOV [EDI+ECX],AL
		INC ECX
		.Break .If !AL
	.EndW
	LEA ESI,[ESI+ECX-1]
	PUSH ESI
	MOV ESI,Offset ThisWord
	MOV EDI,ESI
	MOV AL,[ESI]
	.If AL=='"'
		MOV nend,AL
		INC ESI
	.ElseIf AL=='<'
		MOV nend,'>'
		INC ESI
	.Else
		MOV nend,' '
	.EndIf
	.While BYTE PTR [ESI]
		MOV AL,[ESI]
		.If AL==nend
			XOR AL,AL
		.ElseIf AL=='\'
			.If BYTE PTR [ESI+1]=='\'
				INC ESI
			.EndIf
;		.ElseIf AL=='/'
;			MOV AL,'\'
		.EndIf
		MOV [EDI],AL
		INC ESI
		INC EDI
	.EndW
	POP ESI
	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ParseFileName EndP

ParseInclude Proc Uses ESI EDI lpRCMem:DWORD,lpProMem:DWORD

	MOV ESI,lpRCMem
	.If !lpIncludesMem
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
		MOV lpIncludesMem,EAX
	.EndIf
	MOV EDI,lpIncludesMem
	PUSH EDI
	.While [EDI].INCLUDEMEM.szfile
		ADD EDI,SizeOf INCLUDEMEM
	.EndW
	Invoke ParseFileName,ESI
	ADD ESI,EAX
	
	Invoke lstrcpy,ADDR [EDI].INCLUDEMEM.szfile,Offset ThisWord
	POP EDI
	.If !hIncludesParentItem
		Invoke AddToOthersTree,2,Offset szIncFiles,EDI
		MOV hIncludesParentItem,EAX
	.EndIf
	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ParseInclude EndP

BrowseButtonProc Proc Uses EBX hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]	:BYTE
Local Buffer2[256]	:BYTE
Local lvi			:LVITEM

	.If uMsg==WM_LBUTTONUP
		Invoke BrowseForFile,hWnd,Offset AllFilesFilter,0,ADDR Buffer
		.If EAX
			
			;------------------------------------
			Invoke GetWindowLong,hRCEditorWindow,0
			LEA ECX,CHILDWINDOWDATA.szFileName[EAX]
			Invoke GetFilePath,ECX,ADDR Buffer2
			MOV EBX,EAX

			MOV CL,Buffer[EBX+1]
			MOV Buffer[EBX+1],0
			PUSH ECX
			Invoke lstrcmpi,ADDR Buffer,ADDR Buffer2
			POP ECX
			MOV Buffer[EBX+1],CL
			
			.If !EAX
				LEA ECX,Buffer
				ADD EBX,ECX
				INC EBX
			.Else
				LEA EBX,Buffer
				ADD EBX,2
			.EndIf
			;------------------------------------
			Invoke GetParent,hWnd
			PUSH EAX
			Invoke SendMessage,EAX,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
			MOV lvi.iItem,EAX
			MOV lvi.imask,LVIF_TEXT or LVIF_STATE
			MOV lvi.cchTextMax,256
			MOV lvi.iSubItem, 0
			MOV lvi.state,LVIS_SELECTED
			;LEA EAX,Buffer
			MOV lvi.pszText,EBX
			POP ECX
			MOV EBX,ECX
			Invoke SendMessage,ECX,LVM_SETITEM,0,ADDR lvi
			Invoke SetFocus,EBX
			MOV bIncludesModified,TRUE
		.EndIf
	.EndIf
	Invoke CallWindowProc,lpPrevBrowseProc,hWnd,uMsg,wParam,lParam
	RET
BrowseButtonProc EndP

IncludesDialogProc Proc Uses EBX EDI ESI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lvc			:LV_COLUMN
Local lvi			:LVITEM
Local hList			:DWORD
Local Rect			:RECT
Local Buffer[256]	:BYTE

	;PrintHex uMsg

	.If uMsg == WM_INITDIALOG
		MOV bIncludesModified,FALSE
		
		Invoke GetDlgItem,hWnd,1	;Get List handle
		MOV EBX,EAX
		Invoke SendMessage,EBX,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_GRIDLINES OR LVS_EX_FULLROWSELECT
		
		Invoke CreateWindowEx,NULL,ADDR szButton,Offset szTwoDots,WS_CHILD or WS_VISIBLE + WS_CLIPSIBLINGS,0,0,0,0,EBX,100,hInstance,NULL
		MOV hBrowseButton,EAX
		Invoke SetWindowLong,EAX,GWL_WNDPROC,Offset BrowseButtonProc
		MOV lpPrevBrowseProc,EAX
		
		MOV lvc.imask, LVCF_TEXT OR LVCF_WIDTH OR LVCF_FMT
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.cchTextMax,MAX_PATH
		MOV lvc.pszText,Offset szIncFiles;szIncludeFiles
		MOV lvc.lx,315
		Invoke SendMessage, EBX, LVM_INSERTCOLUMN, 0, addr lvc
		
		.If lpIncludesMem
			MOV EDI,lpIncludesMem
			MOV lvi.imask,LVIF_TEXT or LVIF_STATE
			MOV lvi.cchTextMax,256
			MOV lvi.iSubItem, 0
			MOV lvi.state,LVIS_SELECTED
			XOR ESI,ESI
			.While [EDI].INCLUDEMEM.szfile
				MOV lvi.iItem,ESI
				LEA EAX,[EDI].INCLUDEMEM.szfile
				MOV lvi.pszText,EAX
				Invoke SendMessage,EBX,LVM_INSERTITEM,0,ADDR lvi
				ADD EDI,SizeOf INCLUDEMEM
				INC ESI
			.EndW
		.EndIf
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==2	;OK
				.If bIncludesModified
					Invoke SetRCModified,TRUE
				.EndIf
				
				.If lpIncludesMem
					Invoke RtlZeroMemory,lpIncludesMem,64*1024
				.EndIf
				
				Invoke GetDlgItem,hWnd,1
				MOV hList,EAX
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				.If EAX
					MOV EBX,EAX
					
					.If !lpIncludesMem
						Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
						MOV lpIncludesMem,EAX
					.EndIf
					MOV EDI,lpIncludesMem
					
					XOR ESI,ESI
					.While ESI<EBX
						Invoke GetItemText,hList,ESI,0,ADDR Buffer
						LEA ECX,Buffer
						.If BYTE PTR [ECX]!=0
							Invoke lstrcpy,ADDR [EDI].INCLUDEMEM.szfile,ADDR Buffer
							ADD EDI,SizeOf INCLUDEMEM
						.EndIf
						
						INC ESI
					.EndW
				.EndIf
				
				.If !hIncludesParentItem && lpIncludesMem
					Invoke AddToOthersTree,2,Offset szIncFiles,lpIncludesMem
					MOV hIncludesParentItem,EAX
				.EndIf
				
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.ElseIf EAX== 3	;Cancel
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.ElseIf EAX==4	;Add
				MOV bIncludesModified,TRUE
				Invoke GetDlgItem,hWnd,1
				MOV hList,EAX
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				MOV lvi.imask,LVIF_TEXT or LVIF_STATE
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				MOV lvi.iItem,EAX
				MOV lvi.pszText,Offset szNULL
				MOV lvi.state,LVIS_SELECTED; or LVIS_FOCUSED
				Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
				Invoke SendMessage,hList,LVM_ENSUREVISIBLE,EAX,FALSE
				Invoke SetFocus,hList
				;So that Browse for file dialog is displayed automatically 
				Invoke SendMessage,hBrowseButton,WM_LBUTTONUP,0,0
			.ElseIf EAX==5	;Delete
				Invoke GetDlgItem,hWnd,1
				MOV hList,EAX
				Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					MOV bIncludesModified,TRUE
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
					Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
					.If !EAX
						Invoke MoveWindow,hBrowseButton,0,0,0,0,TRUE
					.EndIf
					Invoke SendMessage,hList,LVM_ENSUREVISIBLE,lvi.iItem,FALSE
					Invoke UpdateWindow,hList
					Invoke SetFocus,hList
				.EndIf
			.EndIf
		.EndIf
	.ElseIf uMsg == WM_NOTIFY
		MOV EDI,lParam
		Invoke GetDlgItem,hWnd,1
		MOV hList,EAX
		MOV ECX, [EDI].NMHDR.hwndFrom
		.If ECX==hList
			.If [EDI].NMHDR.code == LVN_ITEMCHANGED || [EDI].NMHDR.code==0FFFFFFF4h
			;hBrowseButton
				.If [EDI].NMHDR.code == LVN_ITEMCHANGED
					MOV ECX,[EDI].NM_LISTVIEW.iItem
				.Else
					Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
					MOV ECX,EAX
				.EndIf
				MOV Rect.left,LVIR_LABEL
				Invoke SendMessage,hList,LVM_GETITEMRECT,ECX,ADDR Rect
				MOV EAX,Rect.bottom
				SUB EAX,Rect.top
				
				MOV ECX,Rect.right
				SUB ECX,EAX
				;Invoke MoveWindow,hBrowseButton,ECX,Rect.top,EAX,EAX,TRUE
				Invoke SetWindowPos,hBrowseButton,HWND_BOTTOM,ECX,Rect.top,EAX,EAX,SWP_SHOWWINDOW
				Invoke UpdateWindow,hList
			.ElseIf [EDI].NMHDR.code ==LVN_KEYDOWN
				;MOV EAX,lParam
				.If [EDI].LV_KEYDOWN.wVKey==VK_DELETE	;simulate delete button
					Invoke SendMessage,hWnd,WM_COMMAND, (BN_CLICKED SHL 16) OR 5,0
				.EndIf
			.ElseIf [EDI].NMHDR.code==NM_DBLCLK	;Simulate Browse button
				Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					Invoke PostMessage,hBrowseButton,WM_LBUTTONUP,0,0
				.EndIf
			.EndIf 
		.EndIf
	.ElseIf uMsg == WM_CLOSE
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL

	.EndIf
	MOV EAX,FALSE
	RET
IncludesDialogProc EndP
