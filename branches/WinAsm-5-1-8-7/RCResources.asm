.DATA?
hEditResourcesTable				HWND ?
hBrowseResourceButton			HWND ?
lpPrevEditResourcesTableProc	DWORD ?
ItemBeingEdited					DWORD ?
SubItemBeingEdited				DWORD ?
lpPrevBrowseResourceButtonProc	DWORD ?
bResourcesModified				DWORD ?


.CODE

ParseResource Proc Uses EBX ESI EDI,lpRCMem:DWORD,lpProMem:DWORD,nType:DWORD

	MOV ESI,lpRCMem

	.If !lpResourcesMem
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
		MOV lpResourcesMem,EAX
	.EndIf
	MOV EDI,lpResourcesMem
	PUSH EDI

	.While [EDI].RESOURCEMEM.szFile
		LEA EDI,[EDI+SizeOf RESOURCEMEM]
	.EndW
	
	MOV EAX,nType
	MOV [EDI].RESOURCEMEM.nType,EAX
	Invoke GetName,lpProMem,Offset NameBuffer,ADDR [EDI].RESOURCEMEM.szName,ADDR [EDI].RESOURCEMEM.Value
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
	Invoke ParseFileName,ESI
	ADD ESI,EAX
	Invoke lstrcpy,ADDR [EDI].RESOURCEMEM.szFile,Offset ThisWord
	POP EDI
	.If !hResourcesParentItem
		Invoke AddToOthersTree,4,Offset szResources,EDI
		MOV hResourcesParentItem,EAX
	.EndIf

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ParseResource EndP

ResourcesTableGiveCellFocus Proc hList:HWND, Item:DWORD, SubItem:DWORD
Local Rect			:RECT
Local Buffer[256]	:BYTE

	MOV EAX,Item
	MOV ItemBeingEdited,EAX
	
	MOV EAX,SubItem
	MOV SubItemBeingEdited,EAX
	
	MOV Rect.top,EAX
	MOV Rect.left,LVIR_LABEL
	Invoke SendMessage,hList,LVM_GETSUBITEMRECT,Item,ADDR Rect
	
	Invoke GetWindowLong,hEditResourcesTable,GWL_STYLE
	.If SubItem!=0
		ADD Rect.left,3
		OR EAX,ES_NUMBER
	.Else
		AND EAX,-1 XOR ES_NUMBER
	.EndIf
	Invoke SetWindowLong,hEditResourcesTable,GWL_STYLE,EAX
	
	MOV ECX,Rect.bottom
	SUB ECX,Rect.top
	DEC ECX
	
	MOV EAX,Rect.right
	SUB EAX,Rect.left
	
	Invoke SetWindowPos,hEditResourcesTable,NULL,Rect.left,Rect.top,EAX,ECX,SWP_SHOWWINDOW
	Invoke GetItemText,hList,Item,SubItem,ADDR Buffer
	Invoke SendMessage,hEditResourcesTable,WM_SETTEXT,0,ADDR Buffer
	Invoke SendMessage,hEditResourcesTable,WM_GETTEXTLENGTH,0,0
	Invoke SendMessage,hEditResourcesTable,EM_SETSEL,EAX,EAX
	Invoke SendMessage,hEditResourcesTable,EM_SETMODIFY,FALSE,0
	Invoke SetFocus,hEditResourcesTable
	RET
ResourcesTableGiveCellFocus EndP

EditResourcesTableProc Proc Uses EDI EBX hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]	:BYTE
	.If uMsg==WM_KILLFOCUS
		Invoke SendMessage,hWnd,EM_GETMODIFY,0,0
		.If EAX
			MOV bResourcesModified,TRUE
		.EndIf
		
		Invoke SendMessage,hWnd,WM_GETTEXT,256,ADDR Buffer
		Invoke GetParent,hWnd
		MOV ECX,EAX
		Invoke SetItemText,ECX,ItemBeingEdited,SubItemBeingEdited,ADDR Buffer
		Invoke ShowWindow,hWnd,SW_HIDE
		
	.ElseIf uMsg==WM_KEYDOWN
		.If wParam==VK_TAB || wParam==VK_RETURN
			;PUSH EDI
			Invoke GetParent,hWnd
			MOV EDI,EAX
			Invoke SetFocus,EDI	;List
			
			Invoke GetKeyState, VK_SHIFT
			AND EAX,80h
			.If EAX==80h	;Shift is pressed
				.If SubItemBeingEdited==1 ;|| SubItemBeingEdited==2
					DEC SubItemBeingEdited
					Invoke ResourcesTableGiveCellFocus,EDI,ItemBeingEdited,SubItemBeingEdited
				.EndIf
			.Else
				.If SubItemBeingEdited==0 ;|| SubItemBeingEdited==1
					INC SubItemBeingEdited
					Invoke ResourcesTableGiveCellFocus,EDI,ItemBeingEdited,SubItemBeingEdited
				;.ElseIf SubItemBeingEdited==1
					;Invoke SetFocus,hBrowseResourceButton
				.EndIf
			.EndIf
			
			;POP EDI
		.EndIf

	.EndIf
	Invoke CallWindowProc,lpPrevEditResourcesTableProc,hWnd,uMsg,wParam,lParam
	RET
EditResourcesTableProc EndP

BrowseResourceButtonProc Proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer2[256]	:BYTE
Local Buffer[256]	:BYTE
Local lvi			:LVITEM
		
	.If uMsg==WM_LBUTTONUP
		Invoke BrowseForFile,hWnd,Offset ResourcesFilter,0,ADDR Buffer
		.If EAX
			PUSH EBX
			DEC ECX		;(Filter index)
			PUSH ECX	;Resource type
			
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
			.EndIf
			Invoke ReplaceBackSlashWithSlash,EBX
			
			Invoke GetParent,hWnd
			PUSH EAX
			Invoke SendMessage,EAX,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
			MOV lvi.iItem,EAX
			MOV lvi.imask,LVIF_TEXT or LVIF_STATE; or LVIF_PARAM
			MOV lvi.cchTextMax,256
			MOV lvi.iSubItem, 2
			MOV lvi.state,LVIS_SELECTED
			MOV lvi.pszText,EBX
			POP EBX
			
			Invoke SendMessage,EBX,LVM_SETITEM,0,ADDR lvi
			
			POP ECX			
			Invoke SetItemParameter,EBX,lvi.iItem,ECX
			
			MOV bResourcesModified,TRUE
			Invoke SetFocus,EBX			
			POP EBX
		.EndIf
	.EndIf
	Invoke CallWindowProc,lpPrevBrowseResourceButtonProc,hWnd,uMsg,wParam,lParam
	RET
BrowseResourceButtonProc EndP

ResourcesDialogProc Proc Uses EBX EDI ESI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lvc			:LV_COLUMN
Local lvi			:LVITEM
Local Buffer[256]	:BYTE
Local hList			:HWND
Local Rect			:RECT
Local Buffer2[256]	:BYTE

	.If uMsg == WM_INITDIALOG
		MOV bResourcesModified,FALSE
		Invoke GetDlgItem,hWnd,1
		MOV hList,EAX
		
		;I don't really need more than on line. I use ES_MULTILINE simply so that I can catch TAB & Enter keys  
		Invoke CreateWindowEx,NULL,ADDR szEditClass,NULL,WS_CHILD or ES_AUTOHSCROLL or ES_MULTILINE,0,0,0,0,hList,100,hInstance,NULL
		MOV hEditResourcesTable,EAX
		
		Invoke SendMessage,hWnd,WM_GETFONT,0,0
		Invoke SendMessage,hEditResourcesTable,WM_SETFONT,EAX,FALSE
		
		Invoke SetWindowLong,hEditResourcesTable,GWL_WNDPROC,Offset EditResourcesTableProc
		MOV lpPrevEditResourcesTableProc,EAX
		
		Invoke CreateWindowEx,NULL,ADDR szButton,Offset szTwoDots,WS_CHILD or WS_VISIBLE + WS_CLIPSIBLINGS,0,0,0,0,hList,100,hInstance,NULL
		MOV hBrowseResourceButton,EAX
		Invoke SetWindowLong,EAX,GWL_WNDPROC,Offset BrowseResourceButtonProc
		MOV lpPrevBrowseResourceButtonProc,EAX
		
		;MOV EAX, LVS_EX_GRIDLINES ;LVS_EX_FULLROWSELECT; OR 
		Invoke SendMessage,hList,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_GRIDLINES OR LVS_EX_FULLROWSELECT
		MOV lvc.imask, LVCF_TEXT OR LVCF_WIDTH OR LVCF_FMT
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.cchTextMax,MAX_PATH
		MOV lvc.pszText,Offset szName
		MOV lvc.lx,170
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 0, ADDR lvc
		
		MOV lvc.pszText,Offset szID
		MOV lvc.lx,72
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 1, ADDR lvc
		
		MOV lvc.pszText,Offset szFile
		MOV lvc.lx,167
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 2, ADDR lvc
		
		.If lpResourcesMem
			MOV EDI,lpResourcesMem
			MOV lvi.cchTextMax,256
			MOV lvi.state,LVIS_SELECTED
			
			XOR ESI,ESI
			.While [EDI].RESOURCEMEM.szFile
				MOV lvi.imask,LVIF_TEXT or LVIF_STATE or LVIF_PARAM
				MOV lvi.iSubItem,0
				MOV lvi.iItem,ESI
				LEA EAX,[EDI].RESOURCEMEM.szName
				MOV lvi.pszText,EAX
				PUSH [EDI].RESOURCEMEM.nType
				POP lvi.lParam
				Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
				
				MOV lvi.imask,LVIF_TEXT or LVIF_STATE
				MOV lvi.iSubItem, 1
				Invoke BinToDec,[EDI].RESOURCEMEM.Value,ADDR Buffer
				LEA EAX,Buffer
				MOV lvi.pszText,EAX
				Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
				
				MOV lvi.iSubItem,2; 3
				LEA EAX,[EDI].RESOURCEMEM.szFile
				MOV lvi.pszText,EAX
				Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
				
				LEA EDI,[EDI+SizeOf RESOURCEMEM]
				INC ESI
			.EndW
			Invoke GetWindowLong,hList,GWL_STYLE
			AND EAX,WS_VSCROLL
			.If EAX==WS_VSCROLL
				Invoke SendMessage,hList,LVM_SETCOLUMNWIDTH,2,150
			.EndIf
		.EndIf
		
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
				MOV bResourcesModified,TRUE
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				MOV lvi.imask,LVIF_TEXT or LVIF_STATE
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				MOV lvi.iItem,EAX
				MOV lvi.pszText,Offset szNULL
				MOV lvi.state,LVIS_SELECTED or LVIS_FOCUSED
				Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
				Invoke SendMessage,hList,LVM_ENSUREVISIBLE,EAX,FALSE
				Invoke SetFocus,hList
				
				;So that Browse for file dialog is displayed automatically 
				Invoke SendMessage,hBrowseResourceButton,WM_LBUTTONUP,0,0
				
			.ElseIf EAX== 5	;Delete
				Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					MOV bResourcesModified,TRUE
					MOV lvi.iItem,EAX
					.If lvi.iItem
						DEC lvi.iItem	;Because after deleting selection, we will select the previous one
					.EndIf
					Invoke SendMessage,hList,LVM_DELETEITEM,EAX,0
					MOV lvi.imask,LVIF_STATE
					MOV lvi.iSubItem, 0
					MOV lvi.state,LVIS_SELECTED or LVIS_FOCUSED
					MOV lvi.stateMask,LVIS_SELECTED
					Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
					Invoke SendMessage,hList,LVM_ENSUREVISIBLE,lvi.iItem,FALSE
					Invoke SetFocus,hList
				.EndIf
			.ElseIf EAX==2	;OK
				.If !lpResourcesMem
					Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
					MOV lpResourcesMem,EAX
					MOV bResourcesModified,TRUE
				.Else
					MOV EDI,lpResourcesMem
					;Delete all Resource defines
					.While [EDI].RESOURCEMEM.szName || [EDI].RESOURCEMEM.Value
						Invoke DeleteDefine,ADDR [EDI].RESOURCEMEM.szName
						LEA EDI,[EDI+SizeOf RESOURCEMEM]
					.EndW
					Invoke RtlZeroMemory,lpResourcesMem,64*1024
				.EndIf
				MOV EDI,lpResourcesMem
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
								MOV [EDI].RESOURCEMEM.Value,EAX
								Invoke GetItemParameter,hList,ESI
								MOV [EDI].RESOURCEMEM.nType,EAX
								Invoke lstrcpy,ADDR [EDI].RESOURCEMEM.szName,ADDR Buffer
								Invoke lstrcpy,ADDR [EDI].RESOURCEMEM.szFile,ADDR Buffer2
								LEA EDI,[EDI+SizeOf RESOURCEMEM]
							.EndIf
						.EndIf
						INC ESI
					.EndW
				.EndIf
				
				.If !hResourcesParentItem
					Invoke AddToOthersTree,4,Offset szResources,EDI
					MOV hResourcesParentItem,EAX
				.EndIf
				
				.If bResourcesModified
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
		.If [EDI].NMHDR.code==NM_DBLCLK
			MOV EAX,[EDI].NMITEMACTIVATE.iItem
			.If EAX!=-1
				.If ([EDI].NMITEMACTIVATE.iSubItem==0 || [EDI].NMITEMACTIVATE.iSubItem==1)
					Invoke ResourcesTableGiveCellFocus,hList,[EDI].NMITEMACTIVATE.iItem,[EDI].NMITEMACTIVATE.iSubItem
				.Else	;[EDI].NMITEMACTIVATE.iSubItem==2	;Simulate Browse button
					Invoke PostMessage,hBrowseResourceButton,WM_LBUTTONUP,0,0
				.EndIf
			;.Else
				;Invoke ShowWindow,hEditResourcesTable,SW_HIDE
			.EndIf
		.ElseIf [EDI].NMHDR.code==LVN_ITEMCHANGED || [EDI].NMHDR.code==0FFFFFFF4h
			.If [EDI].NMHDR.code == LVN_ITEMCHANGED
				MOV ECX,[EDI].NM_LISTVIEW.iItem
			.Else
				Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				MOV ECX,EAX
			.EndIf
			.If ECX!=-1
				MOV Rect.top,2
				MOV Rect.left,LVIR_LABEL
				Invoke SendMessage,hList,LVM_GETSUBITEMRECT,ECX,ADDR Rect
				MOV ECX,Rect.bottom
				SUB ECX,Rect.top
				DEC ECX
				MOV EAX,Rect.right
				SUB EAX,ECX
				Invoke SetWindowPos,hBrowseResourceButton,HWND_BOTTOM,EAX,Rect.top,ECX,ECX,SWP_SHOWWINDOW
				Invoke UpdateWindow,hList
			.Else
				Invoke ShowWindow,hBrowseResourceButton,SW_HIDE
			.EndIf
			
		.ElseIf [EDI].NMHDR.code ==LVN_KEYDOWN
			;MOV EAX,lParam
			.If [EDI].LV_KEYDOWN.wVKey==VK_DELETE	;simulate delete button
				Invoke SendMessage,hWnd,WM_COMMAND, (BN_CLICKED SHL 16) OR 5,0
			.EndIf
		.EndIf
	.ElseIf uMsg == WM_CLOSE
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL
	.EndIf
	MOV EAX,FALSE
	RET
ResourcesDialogProc EndP
