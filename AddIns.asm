IDC_STATICDESCRIPTION	EQU 4202

.DATA?
hAddInsList				HWND ?
ProcedureAddress		DD ?

.DATA
szGetWAAddInData		DB "GetWAAddInData",0
szWAAddInLoad			DB "WAAddInLoad",0
szWAAddInUnload			DB "WAAddInUnload",0
szWAAddInConfig			DB "WAAddInConfig",0
szFrameWindowProc		DB "FrameWindowProc",0
szProjectExplorerProc	DB "ProjectExplorerProc",0
szOutWindowProc			DB "OutWindowProc",0
szChildWindowProc		DB "ChildWindowProc",0

.CODE
SendCallBackToAllAddIns Proc Uses EBX pAddInsProcedures:DWORD, hWnd:DWORD, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	XOR EAX,EAX
	MOV EBX, pAddInsProcedures
	.If EBX
		@@:
		MOV EDX,[EBX]
		.If EDX
			PUSH lParam
			PUSH wParam
			PUSH uMsg
			PUSH hWnd
			MOV ProcedureAddress,EDX
			CALL [ProcedureAddress]
			;AddIn Procedures return FALSE if they do not process a
			;message or wishes WinAsm Studio to continue with default
			;processing once it's done.
			.If !EAX
				ADD EBX,4
				JMP @B
			.EndIf
		.EndIf
	.EndIf
	RET
SendCallBackToAllAddIns EndP

UnloadAddIn Proc lpFileName:DWORD
Local hAddIn:DWORD

	Invoke lstrcpy,Offset tmpBuffer, Offset szAppFilePath
	Invoke lstrcat,Offset tmpBuffer, Offset szInAddIns
	Invoke lstrcat,Offset tmpBuffer, lpFileName
	Invoke GetModuleHandle,Offset tmpBuffer
	.If EAX
		MOV hAddIn,EAX
		Invoke GetProcAddress,hAddIn,Offset szWAAddInUnload
		.If EAX	;i.e The Procedure AddInUnLoad exists thus this is a valid addin  ?
			MOV ProcedureAddress,EAX
			CALL [ProcedureAddress]
		.EndIf
		Invoke FreeLibrary,hAddIn
	.EndIf
	RET
UnloadAddIn EndP

ShallAddInLoadOnStartUp Proc lpFileName:DWORD
Local hAddIn	:DWORD
	Invoke GetPrivateProfileInt, Offset szADDINS,lpFileName , -1, Offset IniFileName
	.If EAX!=-1	&& EAX!=0 ;i.e there is entry in the ini AND it is not 0-->Load at StartUp
		Invoke lstrcpy,Offset tmpBuffer, Offset szAppFilePath
		Invoke lstrcat,Offset tmpBuffer, Offset szInAddIns
		Invoke lstrcat,Offset tmpBuffer, lpFileName
		
		Invoke LoadLibrary,Offset tmpBuffer;ADDR FindData.cFileName
		MOV hAddIn,EAX
		
		Invoke GetProcAddress,hAddIn,ADDR szWAAddInLoad
		.If EAX	;i.e The Procedure AddInLoad exists thus this is a valid addin  ?
			
			;WAAddInLoad Proc WinAsmVersion:DWORD, WinAsmHandles.hMain:HWND, features:PTR DWORD
			LEA EDX,Features
			PUSH EDX
			
			LEA ECX,WinAsmHandles
			PUSH ECX
			MOV ProcedureAddress,EAX
			CALL [ProcedureAddress]
			.If EAX!=-1 ;If -1 means 
				Invoke GetProcAddress,hAddIn,Offset szFrameWindowProc
				.If EAX
					MOV ECX,pAddInsFrameProcedures
					MOV [ECX],EAX
					ADD pAddInsFrameProcedures,4
				.EndIf
					
				Invoke GetProcAddress,hAddIn,Offset szChildWindowProc
				.If EAX
					MOV ECX,pAddInsChildWindowProcedures
					MOV [ECX],EAX
					ADD pAddInsChildWindowProcedures,4
				.EndIf
				
				Invoke GetProcAddress,hAddIn,Offset szProjectExplorerProc
				.If EAX
					MOV ECX,pAddInsProjectExplorerProcedures
					MOV [ECX],EAX
					ADD pAddInsProjectExplorerProcedures,4
				.EndIf
				
				Invoke GetProcAddress,hAddIn,Offset szOutWindowProc
				.If EAX
					MOV ECX,pAddInsOutWindowProcedures
					MOV [ECX],EAX
					ADD pAddInsOutWindowProcedures,4
				.EndIf
				
			.EndIf
		.Else	;Not a valid Add-In so Free library
			Invoke FreeLibrary,hAddIn
		.EndIf
	.EndIf
	RET
ShallAddInLoadOnStartUp EndP

FillAddInsList Proc Uses ESI lpFileName:DWORD
Local lvi					:LVITEM
LOcal hAddIn				:DWORD
Local szFriendlyName[256]	:BYTE
Local szDescription[256]	:BYTE

	;M2M lvi.iImage,nImage
	MOV lvi.cchTextMax,256
	MOV lvi.iSubItem, 0
	MOV lvi.iItem,0	
	;-----------------------------------------------------------------------
	Invoke lstrcpy,Offset tmpBuffer, Offset szAppFilePath
	Invoke lstrcat,Offset tmpBuffer, Offset szInAddIns
	Invoke lstrcat,Offset tmpBuffer, lpFileName
	Invoke GetModuleHandle,Offset tmpBuffer
	.If EAX==0	;i.e if it is not loaded
		Invoke LoadLibrary,Offset tmpBuffer
		MOV hAddIn,EAX
		XOR ESI,ESI
		CALL RetrieveAddInData
		PUSH EAX
		Invoke FreeLibrary,hAddIn
		POP EAX
	.Else
		MOV hAddIn,EAX
		MOV ESI,1
		CALL RetrieveAddInData
	.EndIf

	MOV lvi.imask,LVIF_STATE
	MOV lvi.stateMask, LVIS_FOCUSED OR LVIS_SELECTED
	MOV lvi.state,LVIS_FOCUSED OR LVIS_SELECTED
	MOV lvi.iItem,0
	MOV lvi.iSubItem, 0
	Invoke SendMessage, hAddInsList, LVM_SETITEM, 0, ADDR lvi
	RET
	
	;----------------------------------------------------------------------
	RetrieveAddInData:
	Invoke GetProcAddress,hAddIn,ADDR szGetWAAddInData
	.If EAX
		LEA EDX,szDescription
		PUSH EDX
		LEA ECX,szFriendlyName
		PUSH ECX
		MOV ProcedureAddress,EAX
		CALL [ProcedureAddress]
		
		;.If EAX<=WAADDIN_VERSION	;i.e.The Add-In is not a newer version than WinAsm Studio.
			MOV lvi.imask,LVIF_TEXT OR LVIF_PARAM
			MOV lvi.iItem,0
			MOV lvi.iSubItem, 0
			LEA ECX,szFriendlyName
			MOV lvi.pszText,ECX
			
			Invoke GetProcAddress,hAddIn,Offset szWAAddInConfig
			MOV lvi.lParam,EAX
			
			Invoke SendMessage,hAddInsList,LVM_INSERTITEM,0,ADDR lvi
			;---------------------------------------------------------------
			MOV lvi.imask,LVIF_TEXT		
			MOV lvi.iItem,EAX
			;---------------------------------------------------------------
			MOV lvi.iSubItem, 1
			.If ESI	;i.e. Add-In Loaded
				LEA ECX,szYes
			.Else
				LEA ECX,szNo
			.EndIf
			MOV lvi.pszText,ECX
			Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
			;---------------------------------------------------------------			
			MOV lvi.iSubItem, 2
			Invoke GetPrivateProfileInt, Offset szADDINS,lpFileName , -1, Offset IniFileName
			.If EAX!=-1	&& EAX!=0 ;i.e there is entry in the ini-->Load at StartUp
				LEA ECX,szYes
			.Else
				LEA ECX,szNo
			.EndIf
			MOV lvi.pszText,ECX
			Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
			;---------------------------------------------------------------
			MOV lvi.iSubItem, 3
			LEA ECX,szDescription
			MOV lvi.pszText,ECX
			Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
			;---------------------------------------------------------------
			MOV lvi.iSubItem, 4
			LEA ECX,tmpBuffer ;The name of the Add-In
			MOV lvi.pszText,ECX
			Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
			
			
		;.EndIf
	.EndIf
	RETN	
	
FillAddInsList EndP

;EnumDllsInAddInsFolder Proc lpProcedure:DWORD, lpFolderDLLs:DWORD
;Local FindData	:WIN32_FIND_DATA
;Local hFindFile	:DWORD
;Local Buffer[MAX_PATH]:BYTE
;
;	Invoke lstrcpy,ADDR Buffer, Offset szAppFilePath
;	Invoke lstrcat,ADDR Buffer, lpFolderDLLs;Offset szInAddInsAllDLLs
;
;	Invoke FindFirstFile,ADDR Buffer, ADDR FindData
;	.If EAX != INVALID_HANDLE_VALUE
;    	MOV hFindFile, EAX
;		.If !(FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
;			LEA EAX,FindData.cFileName
;			PUSH EAX
;			CALL lpProcedure
;			
;		.EndIf
;		
;		@@:
;		Invoke FindNextFile, hFindFile, ADDR FindData
;		.If EAX!=0
;			.If EAX!= INVALID_HANDLE_VALUE
;				.If !(FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
;					LEA EAX,FindData.cFileName
;					PUSH EAX
;					CALL lpProcedure
;				.EndIf		
;			.EndIf
;			JMP @B
;		.EndIf
;		
;		Invoke FindClose, hFindFile
;	.EndIf
;	RET
;EnumDllsInAddInsFolder EndP

AddInsManager_InitDialog Proc Uses EBX hDlg:DWORD
LOCAL lvc	:LV_COLUMN
Local Rect	:RECT
	;Get handles
	Invoke GetDlgItem,hDlg,IDC_LSTALLADDINS
	MOV hAddInsList,EAX

;	Invoke SetWindowLong,hAddInsList,GWL_WNDPROC,Offset DummyListViewProc
;	Invoke SetWindowLong,hAddInsList,GWL_USERDATA,EAX

	MOV lvc.imask, LVCF_WIDTH OR LVCF_TEXT OR LVCF_FMT
	MOV lvc.fmt,LVCFMT_LEFT
	MOV lvc.pszText,Offset szAvailableAddIns
	MOV lvc.lx, 185
	Invoke SendMessage, hAddInsList, LVM_INSERTCOLUMN, 0, addr lvc

	MOV lvc.pszText,Offset szLoadStatus
	MOV lvc.fmt,LVCFMT_CENTER
	MOV lvc.lx, 70
    Invoke SendMessage, hAddInsList, LVM_INSERTCOLUMN, 1, addr lvc

	MOV lvc.pszText,Offset szLoadOnStartUp
	MOV lvc.lx, 100
    Invoke SendMessage, hAddInsList, LVM_INSERTCOLUMN, 2, addr lvc
	
	MOV lvc.imask, LVCF_WIDTH OR LVCF_FMT 
	MOV lvc.lx, 0
    Invoke SendMessage, hAddInsList, LVM_INSERTCOLUMN, 3, addr lvc
    
	MOV lvc.lx, 0
    Invoke SendMessage, hAddInsList, LVM_INSERTCOLUMN, 4, addr lvc


	MOV EAX, LVS_EX_FULLROWSELECT; OR LVS_EX_LABELTIP
	Invoke SendMessage, hAddInsList, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX
	;Invoke SendMessage, hAddInsList, LVM_SETIMAGELIST, LVSIL_SMALL, hListAPIImageList
	
	Invoke EnumDllsInFolder,Offset FillAddInsList, Offset szInAddInsAllDLLs
	
	;Auto size column 0; Thanks blues
	Invoke SendMessage, hAddInsList, LVM_GETCOLUMNWIDTH, 1, 0
	PUSH EAX
	Invoke SendMessage, hAddInsList, LVM_GETCOLUMNWIDTH, 2, 0
	POP EBX
	ADD EBX,EAX

	Invoke GetWindowRect,hAddInsList,ADDR Rect
	
	Invoke GetSystemMetrics,SM_CXBORDER
	MOV EDX,EAX
	SHL EDX,1	;Twice
	ADD EBX,EDX
	
	Invoke GetWindowLong,hAddInsList,GWL_STYLE
	AND EAX,WS_VSCROLL
	.If EAX	;i.e. If VSCROLL is present, take its width into account
		Invoke GetSystemMetrics,SM_CXVSCROLL
	.Else
		XOR EAX,EAX
	.EndIf
	
	ADD EBX,EAX
	ADD EBX,4	;Emperical
	
	MOV ECX,Rect.right
	SUB ECX,Rect.left
	SUB ECX,EBX
	Invoke SendMessage, hAddInsList, LVM_SETCOLUMNWIDTH, 0, ECX


	RET
AddInsManager_InitDialog EndP

AddInsManagerProc Proc hDlg:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
Local Buffer[MAX_PATH]		:BYTE
Local lvi					:LVITEM
Local hAddIn				:DWORD

Local pFrameProc			:DWORD
Local pProjExplorerProc		:DWORD
Local pOutWindowProc		:DWORD
Local pChildWindowProc		:DWORD

	MOV EAX,uMsg
	.If EAX==WM_INITDIALOG
		Invoke AddInsManager_InitDialog,hDlg
		
	.ElseIf EAX==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		
		;PrintHex EDX
		.If EDX==BN_CLICKED
			.If EAX==IDOK
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
				
				;Enumarate all list items and
				;a)change in ini file for "Load On StartUp"
				;b)Load/Unload
				
				;Delete all in [ADDINS] section
				Invoke WritePrivateProfileSection,Offset szADDINS,Offset szNULL,Offset IniFileName
				
				PUSH EDI
				Invoke SendMessage, hAddInsList,LVM_GETITEMCOUNT,0,0
				MOV EDI,EAX	;EDI is the nubmer os Add-Ins in the list (and thus the Add-Ins in the Add-ins Folder)
				.If EDI!=0
					PUSH EBX
					XOR EBX,EBX
					PUSH pAddInsFrameProcedures
					PUSH pAddInsProjectExplorerProcedures
					PUSH pAddInsOutWindowProcedures
					PUSH pAddInsChildWindowProcedures
					
					M2M pFrameProc,pAddInsFrameProcedures
					M2M pProjExplorerProc,pAddInsProjectExplorerProcedures
					M2M pOutWindowProc,pAddInsOutWindowProcedures
					M2M pChildWindowProc,pAddInsChildWindowProcedures
					
					;-----------------------------------------------------------------------------------------------------------------------
					;VERY VERY VERY IMPORTANT-->The Add-Ins will stop recieving any messages and thus no crashes!!!!
					MOV pAddInsFrameProcedures,0
					MOV pAddInsProjectExplorerProcedures,0
					MOV pAddInsOutWindowProcedures,0
					MOV pAddInsChildWindowProcedures,0
					;-----------------------------------------------------------------------------------------------------------------------
					@@:
					Invoke GetItemText,hAddInsList,EBX,4,Offset tmpBuffer	;This is Add-In full path File name
					;Process "Loaded/Unloaded"
					;MOV Buffer[0],0
					Invoke GetItemText,hAddInsList,EBX,1,ADDR Buffer
					Invoke lstrcmp,ADDR Buffer,Offset szYes
					.If EAX==0	;i.e Loaded is selected
						Invoke GetModuleHandle,Offset tmpBuffer
						.If !EAX	;i.e it is NOT already loaded
							;Load it NOW!
							Invoke LoadLibrary,Offset tmpBuffer
							MOV hAddIn,EAX
							Invoke GetProcAddress,hAddIn,ADDR szWAAddInLoad
							.If EAX	;i.e The Procedure AddInLoad exists thus this is a valid addin  ?
								;WAAddInLoad Proc WinAsmVersion:DWORD, WinAsmHandles.hMain:HWND, features:PTR DWORD
								
								LEA EDX,Features
								PUSH EDX
								
								LEA ECX,WinAsmHandles
								PUSH ECX
								MOV ProcedureAddress,EAX
								CALL [ProcedureAddress]
								.If EAX!=-1
									MOV EAX,hAddIn
								.Else
									Invoke FreeLibrary,hAddIn
									XOR EAX,EAX
								.EndIf
							.Else	;Not a valid Add-In so Free library
								Invoke FreeLibrary,hAddIn
								XOR EAX,EAX
							.EndIf
						.Else
							MOV hAddIn,EAX
						.EndIf
						
						.If EAX
							Invoke GetProcAddress,hAddIn,Offset szFrameWindowProc
							.If EAX
								MOV ECX,pFrameProc
								MOV [ECX],EAX
								ADD pFrameProc,4
							.EndIf
							
							Invoke GetProcAddress,hAddIn,Offset szProjectExplorerProc
							.If EAX
								MOV ECX,pProjExplorerProc
								MOV [ECX],EAX
								ADD pProjExplorerProc,4
							.EndIf
							
							Invoke GetProcAddress,hAddIn,Offset szOutWindowProc
							.If EAX
								MOV ECX,pOutWindowProc
								MOV [ECX],EAX
								ADD pOutWindowProc,4
							.EndIf
							
							Invoke GetProcAddress,hAddIn,Offset szChildWindowProc
							.If EAX
								MOV ECX,pChildWindowProc
								MOV [ECX],EAX
								ADD pChildWindowProc,4
							.EndIf
						
						.EndIf
					.Else	;User selected to unload it
						Invoke GetModuleHandle,Offset tmpBuffer
						.If EAX	;i.e IT IS LOADED
							;WAAddInUnload Proc
							MOV hAddIn,EAX
							Invoke GetProcAddress,hAddIn,Offset szWAAddInUnload
							.If EAX	;i.e The Procedure AddInUnLoad exists thus this is a valid addin  ?
								MOV ProcedureAddress,EAX
								CALL [ProcedureAddress]
							.EndIf
							Invoke FreeLibrary,hAddIn
						.EndIf
					.EndIf
					
					;Process "Load On StartUp"
					;MOV Buffer[0],0
					Invoke GetItemText,hAddInsList,EBX,2,ADDR Buffer
					Invoke lstrcmp,ADDR Buffer,Offset szYes
					.If EAX==0	;i.e in the Load on StartUp column of the list, "Yes" is written for this item
						Invoke GetFilesTitle,Offset tmpBuffer ,ADDR Buffer
						Invoke WritePrivateProfileString,Offset szADDINS,ADDR Buffer,Offset szOne,Offset IniFileName
					.EndIf
					
					INC EBX
					.If EBX<EDI
						JMP @B
					.EndIf
					
					MOV EAX,pFrameProc
					MOV DWORD PTR [EAX],0
					MOV EAX,pChildWindowProc
					MOV DWORD PTR [EAX],0
					MOV EAX,pOutWindowProc
					MOV DWORD PTR [EAX],0
					MOV EAX,pProjExplorerProc
					MOV DWORD PTR [EAX],0
					
					POP pAddInsChildWindowProcedures
					POP pAddInsOutWindowProcedures
					POP pAddInsProjectExplorerProcedures					
					POP pAddInsFrameProcedures
					POP EBX
				.EndIf
				POP EDI
;				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
			.ElseIf EAX==IDCANCEL
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
				
			.ElseIf EAX==4	;Loaded/Unloaded clicked
				MOV lvi.imask,LVIF_TEXT; OR LVIF_IMAGE
				MOV lvi.cchTextMax,256
				Invoke SendMessage, hAddInsList, LVM_GETNEXTITEM, -1,LVNI_FOCUSED; + ,LVIS_SELECTED; 
				MOV lvi.iItem,EAX
				MOV lvi.iSubItem, 1
				
				;Get state of Loaded/Unloaded check box
				Invoke SendDlgItemMessage,hDlg,4,BM_GETSTATE,0,0
				AND EAX,1
				.If EAX
					LEA ECX,szYes
					MOV lvi.pszText,ECX
					Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
				.Else
					LEA ECX,szNo
					MOV lvi.pszText,ECX
					Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
				.EndIf
			.ElseIf EAX==5	;Load On StartUp clicked
				MOV lvi.imask,LVIF_TEXT; OR LVIF_IMAGE
				MOV lvi.cchTextMax,256
				Invoke SendMessage, hAddInsList, LVM_GETNEXTITEM, -1,LVNI_FOCUSED; + ,LVIS_SELECTED; 
				MOV lvi.iItem,EAX
				MOV lvi.iSubItem, 2
				
				;Get state of Loaded/Unloaded check box
				Invoke SendDlgItemMessage,hDlg,5,BM_GETSTATE,0,0
				AND EAX,1
				.If EAX
					LEA ECX,szYes
					MOV lvi.pszText,ECX
					Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
				.Else
					LEA ECX,szNo
					MOV lvi.pszText,ECX
					Invoke SendMessage,hAddInsList,LVM_SETITEM,0,ADDR lvi
				.EndIf
			.ElseIf EAX==6	;Configure
				Invoke EnableWindow,hDlg,FALSE
				PUSH EDI
				Invoke SendMessage, hAddInsList, LVM_GETNEXTITEM, -1,LVNI_FOCUSED; + ,LVIS_SELECTED;
				MOV EDI,EAX
				Invoke GetItemText,hAddInsList,EDI,4,ADDR Buffer
				;PrintString Buffer
				Invoke GetModuleHandle,ADDR Buffer
				.If EAX==0	;i.e if it is not loaded
					Invoke LoadLibrary,ADDR Buffer
					MOV hAddIn,EAX
					Invoke GetProcAddress,hAddIn,Offset szWAAddInConfig
					;EAX is now address of WAAddInConfig procedure
					CALL CallWAAddInConfig
					Invoke FreeLibrary,hAddIn
				.Else
					MOV hAddIn,EAX
					Invoke GetProcAddress,hAddIn,Offset szWAAddInConfig
					;EAX is now address of WAAddInConfig procedure
					CALL CallWAAddInConfig
				.EndIf
				POP EDI
				Invoke EnableWindow,hDlg,TRUE
			.EndIf
		.EndIf
	.ElseIf EAX == WM_NOTIFY
		PUSH EDI
		MOV EDI, lParam
;		MOV EAX, [EDI].NM_LISTVIEW.hdr.hwndFrom
;		.If EAX==hAddInsList
			.If [EDI].NMHDR.code == LVN_ITEMCHANGED
				.If [EDI].NM_LISTVIEW.uNewState==3 ;i.e focus and selected
					Invoke GetDlgItem,hDlg,6	;Loaded/Unloaded
					.If [EDI].NM_LISTVIEW.lParam
						Invoke EnableWindow,EAX,TRUE
					.Else
						Invoke EnableWindow,EAX,FALSE
					.EndIf
					;If at least one Add-In found then enable the checkboxes
					Invoke GetDlgItem,hDlg,4	;Loaded/Unloaded
					Invoke EnableWindow,EAX,TRUE
					Invoke GetDlgItem,hDlg,5	;Load On StartUp
					Invoke EnableWindow,EAX,TRUE
					
					;Set Loaded/Unloaded check box
					Invoke GetItemText,hAddInsList,[EDI].NM_LISTVIEW.iItem, 1, ADDR Buffer
					Invoke lstrcmpi,ADDR Buffer,Offset szYes
					.If EAX==0
						Invoke CheckDlgButton,hDlg,4,BST_CHECKED
					.Else
						Invoke CheckDlgButton,hDlg,4,BST_UNCHECKED
					.EndIf
					
					;Set Load On StartUp check box
					Invoke GetItemText,hAddInsList,[EDI].NM_LISTVIEW.iItem, 2, ADDR Buffer
					Invoke lstrcmpi,ADDR Buffer,Offset szYes
					.If EAX==0
						Invoke CheckDlgButton,hDlg,5,BST_CHECKED
					.Else
						Invoke CheckDlgButton,hDlg,5,BST_UNCHECKED
					.EndIf
					
					Invoke GetItemText,hAddInsList,[EDI].NM_LISTVIEW.iItem, 3, ADDR Buffer
					Invoke SetDlgItemText,hDlg,IDC_STATICDESCRIPTION,ADDR Buffer			
				.EndIf
			.ElseIf [EDI].NMHDR.code == NM_DBLCLK || ([EDI].NMHDR.code == LVN_KEYDOWN && [EDI].LV_KEYDOWN.wVKey==VK_SPACE)
				Invoke SendMessage,hAddInsList,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_FOCUSED OR LVNI_SELECTED
				;PrintHex EAX
				.If EAX!=-1
					Invoke SendDlgItemMessage,hDlg,4,BM_GETCHECK,0,0
					XOR EAX,1
					Invoke SendDlgItemMessage,hDlg,4,BM_SETCHECK,EAX,0
					Invoke SendMessage,hDlg,WM_COMMAND,4,NULL
				.EndIf
			;.ElseIf [EDI].NMHDR.code == NM_DBLCLK
			
			.EndIf
	.ElseIf uMsg==WM_CLOSE
		Invoke EndDialog,hDlg,0
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
	
	;----------------------
	CallWAAddInConfig:
	LEA EDX,Features
	PUSH EDX

	LEA ECX,WinAsmHandles
	PUSH ECX
	
	;MOV ProcedureAddress,EAX
	CALL EAX;[ProcedureAddress]

	RETN
AddInsManagerProc EndP