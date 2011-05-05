InvalidateAllDockWindows	PROTO
SetItemText					PROTO :HWND, :DWORD, :DWORD, :DWORD
GetTreeItemParameter		PROTO :HWND, :DWORD
SetProperties				PROTO :DWORD
EnumProjectItems			PROTO :DWORD
EnumOpenedExternalFiles		PROTO :DWORD

TVM_SETBKCOLOR			EQU  TV_FIRST + 29
TVM_SETTEXTCOLOR    	EQU  TV_FIRST + 30
TVM_SETLINECOLOR    	EQU  TV_FIRST + 40
TVM_SETINSERTMARKCOLOR	EQU  TV_FIRST + 37

LANGANDCODEPAGE STRUCT 
	wLanguage	WORD ? 
	wCodepage	WORD ? 
LANGANDCODEPAGE ENDS


CODEPAGECHARSET STRUCT
	wCodepage	WORD ? 
	byteCharset BYTE ?
CODEPAGECHARSET ENDS

.DATA

CodePageCharset	CODEPAGECHARSET <932,128>	;Japanese
				CODEPAGECHARSET <936,134>	;Simplified Chinese
				CODEPAGECHARSET <949,129>	;Korean
				CODEPAGECHARSET <950,136>	;Traditional Chinese-Taiwan (GB5)
				CODEPAGECHARSET <1250,238>	;Eastern Europe
				CODEPAGECHARSET <1251,204>	;Russian
				CODEPAGECHARSET <1252,0>	;Western European Languages
				CODEPAGECHARSET <1253,161>	;Greek
				CODEPAGECHARSET <1254,162>	;Turkish
				CODEPAGECHARSET <1255,177>	;Hebrew
				CODEPAGECHARSET <1256,178>	;Arabic
				CODEPAGECHARSET <1257,186>	;Baltic
				DW 0  



.CODE

GetFirstNextChild Proc hItem:DWORD,fNextItem:DWORD
Local tvi:TVITEM
	
	XOR EAX,EAX
	.If hItem!=0
		Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,fNextItem,hItem
		.If EAX
			MOV tvi._mask,TVIF_PARAM
			MOV tvi.hItem,EAX

			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETITEM,0,ADDR tvi
			;tvi.lParam holds the handle of Child Window
			MOV EAX, tvi.lParam
		.EndIf
		;EAX==0
	;.Else
	;	MOV EAX,0
	.EndIf
    RET
GetFirstNextChild EndP

GetProjectBinName Proc Uses EDI lpBuffer:DWORD, lpExtension:DWORD
	.If ProjectType!=6
		.If ActiveBuild==0	;i.e. Release build
			MOV EDI, Offset szReleaseOutCommand
		.Else
			MOV EDI, Offset szDebugOutCommand
		.EndIf
			
		.If BYTE PTR [EDI]==0
			Invoke lstrcpy, lpBuffer,Offset FullProjectName
			Invoke RemoveFileExt,lpBuffer
			Invoke lstrcat,lpBuffer,lpExtension
		.Else
			Invoke GetFilePath,EDI,lpBuffer
			MOV EDX,lpBuffer
			.If BYTE PTR [EDX]==0	;i.e. if no path specified->add project path
				Invoke lstrcpy, lpBuffer,Offset ProjectPath
				Invoke lstrcat, lpBuffer, EDI;Offset szReleaseOutCommand
			.Else
				Invoke lstrcpy,lpBuffer,EDI
			.EndIf
		.EndIf
	.Else
		Invoke GetFirstNextChild, hASMFilesItem,TVGN_CHILD
		Invoke GetWindowLong,EAX,0
		Invoke lstrcpy,lpBuffer,ADDR [EAX].CHILDWINDOWDATA.szFileName
		Invoke RemoveFileExt,lpBuffer
		Invoke lstrcat,lpBuffer,lpExtension
	.EndIf
	
	RET
GetProjectBinName EndP

DoEvents Proc
Local Msg:MSG
	.While TRUE
		Invoke PeekMessage,ADDR Msg,NULL,0,0,PM_REMOVE
		.Break .If (!EAX)
		Invoke TranslateMessage, ADDR Msg
		Invoke DispatchMessage, ADDR Msg
	.EndW
	RET
DoEvents EndP

;ExecuteThread Proc lParam:DWORD
;
;	RET
;ExecuteThread EndP
EnableDisableMakeOptions Proc Uses EBX
Local NoCommand:BOOLEAN

	MOV NoCommand,TRUE

	Invoke GetFirstNextChild, hResourceFilesItem,TVGN_CHILD
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_MAKE_COMPILERESOURCE,MF_ENABLED
		MOV NoCommand,FALSE
		.If RCToObj[0]!=0
			Invoke EnableMenuItem,hMenu,IDM_MAKE_RCTOOBJ,MF_ENABLED
		.Else
  			Invoke EnableMenuItem,hMenu,IDM_MAKE_RCTOOBJ,MF_GRAYED
		.EndIf
	.Else
		Invoke EnableMenuItem,hMenu,IDM_MAKE_COMPILERESOURCE,MF_GRAYED
  		Invoke EnableMenuItem,hMenu,IDM_MAKE_RCTOOBJ,MF_GRAYED
	.EndIf
	
	Invoke GetFirstNextChild, hASMFilesItem,TVGN_CHILD
	.If !EAX
		Invoke GetFirstNextChild, hModulesItem,TVGN_CHILD
		.If !EAX
			MOV EDX,MF_GRAYED
			MOV EBX,0
			JMP EnDisableAssemble
		.EndIf
	.EndIf
	
	MOV NoCommand,FALSE
	MOV EDX,MF_ENABLED
	MOV EBX,TBSTATE_ENABLED
	
	EnDisableAssemble:
	;-----------------
	Invoke EnableMenuItem,hMenu,IDM_MAKE_ASSEMBLE,EDX
	Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_ASSEMBLE,EBX

	
	
	
	.If NoCommand==FALSE
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKE_CLEAN,MF_ENABLED
		
		Invoke EnableMenuItem,hMenu,IDM_MAKE_LINK,MF_ENABLED
		Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_LINK,TBSTATE_ENABLED
		
		Invoke EnableMenuItem,hMenu,IDM_MAKE_GO,MF_ENABLED
		Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_GO,TBSTATE_ENABLED
		
		.If ProjectType==0 || ProjectType==2 || ProjectType==4 || ProjectType==6
			Invoke EnableMenuItem,hMenu,IDM_MAKE_EXECUTE,MF_ENABLED
			Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_EXECUTE,TBSTATE_ENABLED
			Invoke EnableMenuItem,hMenu,IDM_MAKE_DEBUG,MF_ENABLED
		.Else
			Invoke EnableMenuItem,hMenu,IDM_MAKE_EXECUTE,MF_GRAYED
			Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_EXECUTE,0
			Invoke EnableMenuItem,hMenu,IDM_MAKE_DEBUG,MF_GRAYED
		.EndIf
		
		
		;Let's enable 'Set Active Make PopUp menu'
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVERELEASEVERSION,MF_ENABLED
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVEDEBUGVERSION,MF_ENABLED
		
		
		;Invoke GetPrivateProfileInt, Offset szMAKE, Offset szActiveMake, 0, Offset FullProjectName
		.If ActiveBuild==0
			Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVERELEASEVERSION,MF_CHECKED
			Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVEDEBUGVERSION,MF_UNCHECKED
		.Else
			Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVERELEASEVERSION,MF_UNCHECKED
			Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVEDEBUGVERSION,MF_CHECKED
		.EndIf
		
	.Else
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKE_CLEAN,MF_GRAYED
		Invoke EnableMenuItem,hMenu,IDM_MAKE_LINK,MF_GRAYED
		Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_LINK,0
		Invoke EnableMenuItem,hMenu,IDM_MAKE_GO,MF_GRAYED
		Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_GO,0
		
		Invoke EnableMenuItem,hMenu,IDM_MAKE_EXECUTE,MF_GRAYED
		Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_EXECUTE,0
		
		Invoke EnableMenuItem,hMenu,IDM_MAKE_DEBUG,MF_GRAYED
		
		;Let's disable 'Set Active Make PopUp menu'
		;Invoke EnableMenuItem,hMakeMenu,0,MF_BYPOSITION or MF_GRAYED
		
		Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVERELEASEVERSION,MF_UNCHECKED
		Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVEDEBUGVERSION,MF_UNCHECKED
		
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVERELEASEVERSION,MF_GRAYED
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVEDEBUGVERSION,MF_GRAYED
	.EndIf
	
	RET
EnableDisableMakeOptions EndP

Execute Proc
Local startinfo		:STARTUPINFO
Local ExitCode		:DWORD
Local Buffer[512]	:BYTE

	PUSH EDI
	PUSH ESI
	
	Invoke RtlZeroMemory,ADDR startinfo,SizeOf STARTUPINFO
	MOV startinfo.cb, SizeOf STARTUPINFO
	
	.If ActiveBuild==0	;i.e. Release build
		MOV ESI,Offset szReleaseCommandLine
	.Else
		MOV ESI,Offset szDebugCommandLine
	.EndIf
	
	
	LEA EDI,Buffer
	MOV BYTE PTR [EDI],'"'
	INC EDI
	Invoke GetProjectBinName,EDI,Offset szExtExe
	Invoke lstrcat,EDI,Offset szQuote
	CALL CreateTheProcess
	.If !EAX
		.If ProjectType==6
			Invoke GetProjectBinName,EDI,Offset szExtCom
			Invoke lstrcat,EDI,Offset szQuote
			CALL CreateTheProcess
			.If EAX
				JMP Success
			.EndIf
		.EndIf
		CALL ExecutionFailed
		JMP Ex
	.EndIf
	

	Success:
	;------
	Invoke EnableMenuItem,hMenu,IDM_NEWPROJECT,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_NEWPROJECT,0
	
	Invoke EnableMenuItem,hMenu,IDM_OPENPROJECT,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_OPENPROJECT,0

	Invoke EnableMenuItem,hMenu,IDM_CLOSEPROJECT,MF_GRAYED


	Invoke EnableMenuItem,hMenu,IDM_MAKE_EXECUTE,MF_GRAYED
	Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_EXECUTE,0
	
	Invoke EnableMenuItem,hMenu,IDM_MAKE_STOP,MF_ENABLED
	Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_STOP,TBSTATE_ENABLED
	
	Invoke SetTimer,WinAsmHandles.hMain,400,200,0
	
	
	Ex:
	POP ESI
	POP EDI
	RET
	
	;****************************************************************************
	CreateTheProcess:
	;Invoke CreateProcess,EDI,ESI,NULL,NULL,FALSE, NORMAL_PRIORITY_CLASS,NULL,NULL,ADDR startinfo,ADDR proc_info
	.If BYTE PTR [ESI]
		Invoke lstrcat,EDI,Offset szSpc
		Invoke lstrcat,EDI,ESI
	.EndIf
	MOV EDX,EDI
	DEC EDX
	Invoke CreateProcess,NULL,EDX,NULL,NULL,FALSE, NORMAL_PRIORITY_CLASS,NULL,NULL,ADDR startinfo,ADDR proc_info
	RETN
	
	
	;****************************************************************************
	ExecutionFailed:
	Invoke MessageBox,WinAsmHandles.hMain,Offset szExecutionError, Offset szAppName,MB_OK+MB_TASKMODAL
	RETN

Execute EndP

;ExecuteThread Proc lParam:DWORD
;Local startinfo		:STARTUPINFO
;Local ExitCode		:DWORD
;Local Buffer[288]	:BYTE
;
;	Invoke RtlZeroMemory,ADDR startinfo,SizeOf STARTUPINFO
;	MOV startinfo.cb, SizeOf STARTUPINFO
;	.If ActiveBuild==0	;i.e. Release build
;		MOV EDI,Offset szReleaseCommandLine
;	.Else
;		MOV EDI,Offset szDebugCommandLine
;	.EndIf
;	
;	.If BYTE PTR [EDI]	;i.e. if there is command line
;		MOV ESI, Offset tmpBuffer
;		Invoke lstrcpy,ESI,Offset szQuote
;		Invoke lstrcat,ESI,EDI
;		Invoke lstrcat,ESI,Offset szQuote
;	.Else
;		MOV ESI, NULL
;	.EndIf
;	
;	LEA EDI,Buffer
;	Invoke GetProjectBinName,EDI,Offset szExtExe
;	
;	;Invoke ShellExecute,NULL,Offset szopen,EDI,ESI,NULL,SW_SHOWDEFAULT
;	CALL CreateTheProcess
;	
;	.If !EAX;<=32
;		.If ProjectType!=6
;			CALL ExecutionFailed
;			
;		.Else
;			Invoke GetProjectBinName,EDI,Offset szExtCom
;			
;			;Invoke ShellExecute,NULL,Offset szopen,EDI,ESI,NULL,SW_SHOWDEFAULT
;			CALL CreateTheProcess
;			.If !EAX;<=32
;				CALL ExecutionFailed
;			.EndIf
;		.EndIf
;	.EndIf
;	
;	;Invoke ExitThread,0
;	
;;	Invoke EnableMenuItem,hMenu,IDM_MAKE_LINK,MF_ENABLED
;;	Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_LINK,TBSTATE_ENABLED
;;	
;;	Invoke EnableMenuItem,hMenu,IDM_MAKE_GO,MF_ENABLED
;;	Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_GO,TBSTATE_ENABLED
;;	
;;	Invoke EnableMenuItem,hMenu,IDM_MAKE_EXECUTE,MF_ENABLED
;	
;	
;	Invoke SendMessage,hMakeTB,TB_SETCMDID,4,IDM_MAKE_EXECUTE
;	Invoke SendMessage,hMakeTB,TB_CHANGEBITMAP,IDM_MAKE_EXECUTE,23
;	Invoke InvalidateRect,hMakeTB,NULL,TRUE
;	
;	Invoke EnableDisableMakeOptions
;
;	MOV proc_info.hProcess,0
;	
;	RET
;	
;	;****************************************************************************
;	CreateTheProcess:
;	Invoke CreateProcess,EDI,ESI,NULL,NULL,FALSE, NORMAL_PRIORITY_CLASS,NULL,NULL,ADDR startinfo, ADDR proc_info
;	.If EAX
;		Invoke GetCurrentThread
;		Invoke SetThreadPriority,EAX,THREAD_PRIORITY_LOWEST
;		;The process has been successfully created
;		
;		Invoke EnableMenuItem,hMenu,IDM_MAKE_LINK,MF_GRAYED
;		Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_LINK,0
;		
;		Invoke EnableMenuItem,hMenu,IDM_MAKE_GO,MF_GRAYED
;		Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_GO,0
;		
;		Invoke EnableMenuItem,hMenu,IDM_MAKE_EXECUTE,MF_GRAYED
;		
;		Invoke SendMessage,hMakeTB,TB_SETCMDID,4,IDM_MAKE_STOP
;		Invoke SendMessage,hMakeTB,TB_CHANGEBITMAP,IDM_MAKE_STOP,25
;		Invoke InvalidateRect,hMakeTB,NULL,TRUE
;		
;		Invoke WaitForInputIdle,proc_info.hProcess,INFINITE
;		;Process is waiting for user input with no input pending
;		
;		;No let's wait till it ends...
;		@@:
;		Invoke GetExitCodeProcess, proc_info.hProcess, ADDR ExitCode
;		.If EAX
;			.If ExitCode==STILL_ACTIVE
;				JMP @B
;			.Else
;				Invoke CloseHandle,proc_info.hThread
;				Invoke CloseHandle,proc_info.hProcess
;				;PrintText "Terminated1"
;			.EndIf
;		.Else
;			;Invoke TerminateProcess,proc_info.hProcess,0
;			Invoke CloseHandle,proc_info.hThread
;			Invoke CloseHandle,proc_info.hProcess
;			;PrintText "Terminated2"
;		.EndIf
;		
;		MOV EAX,TRUE
;	.EndIf
;	RETN
;	
;	;****************************************************************************
;	ExecutionFailed:
;	Invoke MessageBox,WinAsmHandles.hMain,Offset szExecutionError, Offset szAppName,MB_OK+MB_TASKMODAL
;	RETN
;
;ExecuteThread EndP

BrowseForFile Proc hOwner:HWND,lpBrowseForWhatFiles:DWORD, hTextBox:DWORD, lpBuffer:DWORD
Local ofn:OPENFILENAME
Local Buffer[MAX_PATH]:BYTE

	;Zero out the ofn struct
	Invoke RtlZeroMemory,ADDR ofn,SizeOf ofn
	;Setup the ofn struct
	MOV ofn.lStructSize,SizeOf ofn
	PUSH hOwner
	POP ofn.hwndOwner
	PUSH hInstance
	POP ofn.hInstance
	M2M ofn.lpstrFilter, lpBrowseForWhatFiles
	MOV Buffer[0],0
	LEA EAX,Buffer
	MOV ofn.lpstrFile,EAX
	MOV ofn.nMaxFile,SizeOf Buffer
	MOV ofn.lpstrDefExt,NULL
	MOV ofn.lpstrTitle,Offset szBrowseDialogTitle	;"Browse"
	MOV ofn.Flags,OFN_EXPLORER OR OFN_FILEMUSTEXIST OR OFN_HIDEREADONLY OR OFN_PATHMUSTEXIST;OFN_ENABLEHOOK OR 

	;Show the Open dialog
	Invoke GetOpenFileName,ADDR ofn
	.If EAX
		.If hTextBox
			Invoke SendMessage,hTextBox,WM_SETTEXT,NULL,ADDR Buffer
		.Else
			Invoke lstrcpy,lpBuffer,ADDR Buffer
		.EndIf
		MOV EAX,TRUE
		
		;Return Filter index as well
		MOV ECX,ofn.nFilterIndex
	.Else
		XOR EAX,EAX
	.EndIf
	RET
BrowseForFile EndP

BinaryFilesDialogProc Proc Uses EBX EDI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local hBinaryFilesList		:HWND
Local lvc					:LV_COLUMN
Local Rect					:RECT
Local lvi 					:LVITEM
Local Buffer[MAX_PATH+1]	:BYTE
Local szCounter[12]			:BYTE

	.If uMsg==WM_INITDIALOG
		Invoke GetDlgItem,hWnd,222	;Get List's handle
		MOV hBinaryFilesList,EAX
		
		MOV lvc.imask, LVCF_FMT 
		MOV lvc.fmt,LVCFMT_LEFT
		
		Invoke SendMessage, hBinaryFilesList, LVM_INSERTCOLUMN, 0, ADDR lvc
		Invoke SendMessage, hBinaryFilesList, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT OR LVS_EX_LABELTIP
		
		
		MOV lvi.imask,LVIF_TEXT
		MOV lvi.cchTextMax,256
		MOV lvi.iSubItem, 0
		LEA EAX,Buffer
		MOV lvi.pszText,EAX
		
		XOR EBX,EBX
		@@:
		MOV lvi.iItem,EBX
		INC EBX
		Invoke BinToDec,EBX,ADDR Buffer
		Invoke GetPrivateProfileString,	Offset szBINFILES, ADDR Buffer, ADDR szNULL, ADDR Buffer, MAX_PATH, Offset FullProjectName
		.If EAX!=0
			Invoke SendMessage,hBinaryFilesList,LVM_INSERTITEM,0,ADDR lvi
			JMP @B
		.EndIf
		
		.If EBX==1	;i.e. no binary files
			Invoke GetDlgItem,hWnd,227	;Remove
			Invoke EnableWindow,EAX,FALSE
		.EndIf
		
		
		MOV lvi.iItem,0
		MOV lvi.iSubItem,0
		MOV lvi.imask,LVIF_STATE
		MOV lvi.stateMask,LVIS_SELECTED
		MOV lvi.state,LVIS_SELECTED 
		Invoke SendMessage,hBinaryFilesList,LVM_SETITEM,0,ADDR lvi
		
		Invoke GetWindowRect,hBinaryFilesList,ADDR Rect
		Invoke GetSystemMetrics,SM_CXBORDER
		MOV EBX,EAX
		SHL EBX,1	;Twice
		Invoke GetWindowLong,hBinaryFilesList,GWL_STYLE
		AND EAX,WS_VSCROLL
		.If EAX	;i.e. If VSCROLL is present, take its width into account
			Invoke GetSystemMetrics,SM_CXVSCROLL
		.Else
			XOR EAX,EAX
		.EndIf
		ADD EBX,EAX
		ADD EBX,2	;Emperical
		MOV ECX,Rect.right
		SUB ECX,Rect.left
		SUB ECX,EBX
		Invoke SendMessage, hBinaryFilesList, LVM_SETCOLUMNWIDTH, 0, ECX
		
	.ElseIf uMsg==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		
		.If EDX==BN_CLICKED
			.If EAX==226		;Add
				LEA EDI,Buffer
				Invoke BrowseForFile,hWnd,Offset BinaryFilesFilter,0,EDI
				.If EAX
					Invoke GetDlgItem,hWnd,222	;Get List's handle
					MOV hBinaryFilesList,EAX
					MOV lvi.imask,LVIF_TEXT Or LVIF_STATE
					MOV lvi.cchTextMax,256
					MOV lvi.iSubItem, 0
					MOV lvi.stateMask,LVIS_SELECTED
					MOV lvi.state,LVIS_SELECTED
					
					Invoke lstrlen,Offset ProjectPath
					.If EAX
						MOV EBX,EAX
						
						;ESI is the pointer to the filename
						ADD EBX,EDI
						
						MOV CL,BYTE PTR [EBX]
						PUSH ECX
						MOV BYTE PTR [EBX],0
						Invoke lstrcmpi,Offset ProjectPath,EDI
						.If !EAX	;i.e. equal
							INC EBX	;since BYTE PTR [EBX]=0 now
							Invoke ReplaceBackSlashWithSlash,EBX
							DEC EBX
							MOV EDI,EBX
						.EndIf
						POP ECX
						MOV BYTE PTR [EBX],CL
					.EndIf
					
					
					MOV lvi.pszText,EDI
					Invoke SendMessage,hBinaryFilesList,LVM_GETITEMCOUNT,0,0
					MOV lvi.iItem,EAX
					Invoke SendMessage,hBinaryFilesList,LVM_INSERTITEM,0,ADDR lvi
					
					Invoke GetDlgItem,hWnd,227	;Remove
					Invoke EnableWindow,EAX,TRUE
				.EndIf
				
			.ElseIf EAX==227	;Remove
				Invoke GetDlgItem,hWnd,222	;Get List's handle
				MOV hBinaryFilesList,EAX
				Invoke SendMessage,hBinaryFilesList,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_SELECTED
				.If EAX!=-1
					PUSH EAX
					Invoke SendMessage,hBinaryFilesList,LVM_DELETEITEM,EAX,0
					Invoke SendMessage,hBinaryFilesList,LVM_GETITEMCOUNT,0,0
					DEC EAX
					POP ECX
					.If ECX>EAX
						MOV ECX,EAX					
					.EndIf
					MOV lvi.iItem,ECX
					MOV lvi.iSubItem,0
					MOV lvi.imask,LVIF_STATE
					MOV lvi.stateMask,LVIS_SELECTED
					MOV lvi.state,LVIS_SELECTED 
					Invoke SendMessage,hBinaryFilesList,LVM_SETITEM,0,ADDR lvi
				.EndIf
				
				Invoke SendMessage,hBinaryFilesList,LVM_GETITEMCOUNT,0,0
				.If !EAX
					Invoke GetDlgItem,hWnd,227	;Remove
					Invoke EnableWindow,EAX,FALSE
				.EndIf
				
			.ElseIf EAX==224	;OK
			
				Invoke EndDialog,hWnd,FALSE	;Return Cancel
				Invoke GetDlgItem,hWnd,222	;Get List's handle
				MOV hBinaryFilesList,EAX
				Invoke WritePrivateProfileStruct,Offset szBINFILES,NULL,NULL,NULL,Offset FullProjectName
				
				MOV lvi.imask,LVIF_TEXT
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				LEA EDX,Buffer
				MOV lvi.pszText,EDX
				
				Invoke SendMessage,hBinaryFilesList,LVM_GETITEMCOUNT,0,0
				.If EAX
					MOV EBX,EAX 
					XOR EDI,EDI
					.While EDI<EBX
						MOV lvi.iItem,EDI
						INC EDI
						Invoke SendMessage,hBinaryFilesList,LVM_GETITEM,0,ADDR lvi
						Invoke BinToDec,EDI,ADDR szCounter
						Invoke WritePrivateProfileString, Offset szBINFILES, ADDR szCounter, ADDR Buffer, Offset FullProjectName
					.EndW
				.EndIf
			.Else;If EAX==225	;Cancel
				Invoke EndDialog,hWnd,FALSE	;Return Cancel
			.EndIf
		.EndIf
		
	.ElseIf uMsg==WM_CLOSE
		Invoke EndDialog,hWnd,FALSE
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
BinaryFilesDialogProc EndP

RefreshMenuItems Proc Uses EBX EDI
Local mii:MENUITEMINFO


	;SetMenuBarItemsCaptions
	XOR EBX,EBX
	Invoke GetMenuItemCount,WinAsmHandles.hMenu
	.If EAX!=11	;i.e. Active MDI Child is MAXIMIZED 
		INC EBX
	.EndIf
	
	MOV mii.cbSize,SizeOf MENUITEMINFO
	MOV mii.fMask,MIIM_TYPE
	MOV mii.fType,MFT_STRING
	MOV mii.cch,31
	
	MOV EDI,WinAsmHandles.hMenu
	
	MOV mii.dwTypeData,Offset szFileMenu
	CALL SetMenuBarItem
	
	MOV mii.dwTypeData,Offset szEditMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szViewMenu
	INC EBX
	CALL SetMenuBarItem
	
	MOV mii.dwTypeData,Offset szProjectMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szFormatMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szResourcesMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szMakeMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szToolsMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szAddInsMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szWindowMenu
	INC EBX
	CALL SetMenuBarItem

	MOV mii.dwTypeData,Offset szHelpMenu
	INC EBX
	CALL SetMenuBarItem


	
	;------------------------------------------------------------
	;ForceMeasureItem for ALL Items 
	MOV mii.fMask,MIIM_TYPE or MIIM_DATA OR MIIM_ID OR MIIM_STATE or MIIM_SUBMENU

	MOV EDI,WinAsmHandles.PopUpMenus.hFileMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hEditMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hViewMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hProjectMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hFormatMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hResourcesMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hMakeMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hSetActiveBuildMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hToolsMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hAddInsMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hWindowMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hHelpMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hNewFileMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hConvertMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hControlsMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hDialogMenu
	CALL ForceMeasureItem

	MOV EDI,WinAsmHandles.PopUpMenus.hInterfacePacks
	CALL ForceMeasureItem



	;------------------------------------------------------------
	;TrayPopMenuItemCaptions
	MOV mii.fMask,MIIM_TYPE
	MOV mii.fType,MFT_STRING
	MOV mii.cch,31
	
	MOV mii.dwTypeData,Offset szRestore
	Invoke SetMenuItemInfo,hTrayPopupMenu,0,TRUE,ADDR mii


	MOV mii.dwTypeData,Offset szExit
	Invoke SetMenuItemInfo,hTrayPopupMenu,2,TRUE,ADDR mii
	
	
	;Out Window Context menu
	MOV mii.dwTypeData,Offset szCopySelection
	Invoke SetMenuItemInfo,hOutPopUpMenu,0,TRUE,ADDR mii

	MOV mii.dwTypeData,Offset szCopyAllText
	Invoke SetMenuItemInfo,hOutPopUpMenu,1,TRUE,ADDR mii

	MOV mii.dwTypeData,Offset szSaveOutText
	Invoke SetMenuItemInfo,hOutPopUpMenu,3,TRUE,ADDR mii
	;------------------------------------------------------------
	RET
	
	SetMenuBarItem:
	Invoke SetMenuItemInfo,EDI,EBX,TRUE,ADDR mii
	RETN

	ForceMeasureItem:
	Invoke GetMenuItemCount,EDI
	MOV EBX,EAX
	.While EBX
		DEC EBX
		Invoke GetMenuItemInfo,EDI,EBX,TRUE,ADDR mii
		.If mii.fType==MFT_OWNERDRAW	;ignore separators!!!!
			;Switch to MF_STRING
			Invoke ModifyMenu,EDI,EBX,MF_BYPOSITION,0,NULL
			
			;Switch back to MF_OWNERDRAW so that WM_MEASUEITEM is sent!!!
			Invoke SetMenuItemInfo,EDI,EBX,TRUE,ADDR mii
		.EndIf
	.EndW
	RETN
RefreshMenuItems EndP

RefreshComboBoxes Proc hChild:DWORD
	Invoke GetWindowLong,hChild,0
	MOV ECX,[EAX].CHILDWINDOWDATA.dwTypeOfFile
	.If ECX==1 || ECX==2 || ECX==51 || ECX==101 || ECX==102
		PUSH EBX
		MOV EBX,EAX
		;Invoke GetStockObject,ANSI_FIXED_FONT
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hCombo,WM_SETFONT,hFontTahoma,TRUE
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hCombo,CB_GETCURSEL,0,0
		PUSH EAX
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hCombo,CB_DELETESTRING,0,0
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hCombo,CB_INSERTSTRING,0,Offset szSelectProcedureOrGoToTop
		POP EDX
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hCombo,CB_SETCURSEL,EDX,0
		
		POP EBX
	.EndIf
	RET
RefreshComboBoxes EndP

RefreshTahomaFont Proc

	Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,WinAsmHandles.hProjTab,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,hResourcesTab,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,hDialogsTree,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,hOthersTree,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,hPropertiesList,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,hEditProperties,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,hSelectComboList,WM_SETFONT,hFontTahoma,FALSE
	Invoke SendMessage,hStatus,WM_SETFONT,hFontTahoma,FALSE



;	Invoke SendMessage,hListProcedures,WM_SETFONT,hFontTahoma,FALSE
;	Invoke SendMessage,hListStructures,WM_SETFONT,hFontTahoma,FALSE
;	Invoke SendMessage,hListConstants,WM_SETFONT,hFontTahoma,FALSE
;	Invoke SendMessage,hListStructureMembers,WM_SETFONT,hFontTahoma,FALSE
;   	Invoke SendMessage,hListVariables,WM_SETFONT,hFontTahoma,FALSE
;	Invoke SendMessage,hListIncludes,WM_SETFONT,hFontTahoma,FALSE

	RET
RefreshTahomaFont EndP

RefreshTheRest Proc
Local tci:TCITEM
Local tvi:TVITEM

	Invoke SetWindowText,WinAsmHandles.hProjExplorer,Offset szExplorer
	Invoke SetWindowText,WinAsmHandles.hOutParent,Offset szOutput
	Invoke SetWindowText,hToolBox,Offset szToolBox
	Invoke SetWindowText,hRCOptions,Offset Offset szDialogDW
	Invoke InvalidateAllDockWindows

	MOV tci.imask,LVIF_TEXT
	
	MOV tci.pszText,Offset szProject
	Invoke SendMessage,WinAsmHandles.hProjTab,TCM_SETITEM,0,ADDR tci
	MOV tci.pszText,Offset szBlocks
	Invoke SendMessage,WinAsmHandles.hProjTab,TCM_SETITEM,1,ADDR tci
	MOV tci.pszText,Offset szResources
	Invoke SendMessage,WinAsmHandles.hProjTab,TCM_SETITEM,2,ADDR tci

	MOV tci.pszText,Offset szDialogs
	Invoke SendMessage,hResourcesTab,TCM_SETITEM,0,ADDR tci
	MOV tci.pszText,Offset szOthers
	Invoke SendMessage,hResourcesTab,TCM_SETITEM,1,ADDR tci
	
	;------------------------------------------------------
	;Refresh Others Tree Items
	MOV tvi._mask,TVIF_TEXT
	MOV tvi.cchTextMax,31
	
	MOV tvi.pszText,Offset szOthers
	MOV EAX,hOthersParentItem
	MOV tvi.hItem,EAX
	Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
	
	MOV tvi.pszText,Offset szResources
	MOV EAX,hResourcesParentItem
	MOV tvi.hItem,EAX
	Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
	
	MOV tvi.pszText,Offset szStringTable
	MOV EAX,hStringTableParentItem
	MOV tvi.hItem,EAX
	Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
	
	MOV tvi.pszText,Offset szMenus
	MOV EAX,hMenusParentItem
	MOV tvi.hItem,EAX
	Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
	
	MOV tvi.pszText,Offset szIncFiles
	MOV EAX,hIncludesParentItem
	MOV tvi.hItem,EAX
	Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
	
	MOV tvi.pszText,Offset szAcceleratorTables
	MOV EAX,hAccelTablesParentItem
	MOV tvi.hItem,EAX
	Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
	
	MOV tvi.pszText,Offset szVersionInfo
	MOV EAX,hVersionInfosParentItem
	MOV tvi.hItem,EAX
	Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi

	;------------------------------------------------------
	;Refresh Project Tree Items
	MOV tvi.pszText,Offset szASMFiles
	MOV EAX,hASMFilesItem
	CALL SetProjectTreeItem
	
	MOV tvi.pszText,Offset szModules
	MOV EAX,hModulesItem
	CALL SetProjectTreeItem

	MOV tvi.pszText,Offset szIncludeFiles
	MOV EAX,hIncludeFilesItem
	CALL SetProjectTreeItem

	MOV tvi.pszText,Offset szResourceFiles
	MOV EAX,hResourceFilesItem
	CALL SetProjectTreeItem

	MOV tvi.pszText,Offset szTextFiles
	MOV EAX,hTextFilesItem
	CALL SetProjectTreeItem

	MOV tvi.pszText,Offset szBatchFiles
	MOV EAX,hBatchFilesItem
	CALL SetProjectTreeItem

	MOV tvi.pszText,Offset szDefinitionFiles
	MOV EAX,hDefFilesItem
	CALL SetProjectTreeItem

	MOV tvi.pszText,Offset szOtherFiles
	MOV EAX,hOtherFilesItem
	CALL SetProjectTreeItem

	;Properties List
	Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM,TVGN_CARET,NULL
	.If EAX	;Handle to the selected Item
		Invoke GetTreeItemParameter,hDialogsTree,EAX
		Invoke SetProperties,EAX
	.EndIf

	Invoke EnumProjectItems,Offset RefreshComboBoxes
	Invoke EnumOpenedExternalFiles,Offset RefreshComboBoxes
	
	Invoke RefreshTahomaFont
	
	RET
	;-----------------------------------------------------
	SetProperty:
	Invoke SetItemText,hPropertiesList,ECX,0,EDX
	RETN
	;-----------------------------------------------------
	SetProjectTreeItem:
	MOV tvi.hItem,EAX
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SETITEM,0,ADDR tvi
	RETN
RefreshTheRest EndP

CreateTahomaFont Proc
Local lf:LOGFONT
Local Buffer[MAX_PATH]	:BYTE
Local dwDummy			:DWORD
Local lpData			:DWORD
Local lpVersionInfo		:DWORD
Local puLen				:DWORD

	.If hFontTahoma
		Invoke DeleteObject,hFontTahoma
	.EndIf
	Invoke RtlZeroMemory,ADDR lf,SizeOf LOGFONT
	Invoke lstrcpy,ADDR lf.lfFaceName, Offset szTahomaFontName
	.If ObjectsFont
		MOV EAX,-12
	.Else
		MOV EAX,-11
	.EndIf
	MOV lf.lfHeight,EAX
	MOV lf.lfItalic,FALSE
	MOV lf.lfWeight,400
	;Let's retrieve codePage of DLL
	;------------------------------------------------------------------------------
	Invoke GetModuleFileName,hUILib,ADDR Buffer,MAX_PATH
	Invoke GetFileVersionInfoSize,ADDR Buffer,ADDR dwDummy
	.If EAX
		PUSH EAX
		Invoke LocalAlloc,LPTR,EAX
		MOV lpData,EAX
		POP EDX
		Invoke GetFileVersionInfo,ADDR Buffer,NULL,EDX,lpData
		.If EAX
			Invoke VerQueryValue,lpData,CTEXT("\VarFileInfo\Translation"),ADDR lpVersionInfo,ADDR puLen
			.If EAX
				mov EDX,lpVersionInfo
				movzx EAX,[EDX].LANGANDCODEPAGE.wLanguage
				movzx EAX,[EDX].LANGANDCODEPAGE.wCodepage
				
				;Let's get charset:
				LEA EDI,CodePageCharset
				.While DWORD PTR [EDI]
					.If [EDI].CODEPAGECHARSET.wCodepage!=AX
						ADD EDI, SizeOf CODEPAGECHARSET
					.Else
						;***************************************
						MOV AL,[EDI].CODEPAGECHARSET.byteCharset
						MOV lf.lfCharSet,AL
						.Break
						;***************************************
					.EndIf
				.EndW
				
			.EndIf
		.EndIf
		Invoke LocalFree,lpData
	.EndIf
	;------------------------------------------------------------------------------
	
	Invoke CreateFontIndirect,ADDR lf
	MOV hFontTahoma,EAX

	RET
CreateTahomaFont EndP

LoadUI Proc USES EBX EDI ESI

	Invoke CreateTahomaFont

	MOV EBX,hUILib

	Invoke LoadAccelerators,EBX,IDR_ACCELERATOR	;Load the accelerator table.
	MOV hAccelerator,EAX
	
	MOV ECX,IDTS_GRIDSIZE
	MOV EDI,Offset szGridSize
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNLEFTS
	MOV EDI,Offset szAlignLefts
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNCENTERS
	MOV EDI,Offset szAlignCenters
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNCENTERSWITHDIALOGCENTER
	MOV EDI,Offset szAlignCentersWithDialogCenter
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNRIGHTS
	MOV EDI,Offset szAlignRights
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNTOPS
	MOV EDI,Offset szAlignTops
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNMIDDLES
	MOV EDI,Offset szAlignMiddles
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNMIDDLESWITHDIALOGMIDDLE
	MOV EDI,Offset szAlignMiddlesWithDialogMiddle
	CALL Load32Chars
	MOV ECX,IDTS_ALIGNBOTTOMS
	MOV EDI,Offset szAlignBottoms
	CALL Load32Chars
	MOV ECX,IDTS_MAKESAMEWIDTH
	MOV EDI,Offset szMakeSameWidth
	CALL Load32Chars
	MOV ECX,IDTS_MAKESAMEHEIGHT
	MOV EDI,Offset szMakeSameHeight
	CALL Load32Chars
	MOV ECX,IDTS_MAKESAMESIZE
	MOV EDI,Offset szMakeSameSize
	CALL Load32Chars
	
	MOV ECX,IDTS_POINTER
	MOV EDI,Offset szPointer
	CALL Load32Chars
	
	
	MOV ECX,IDTS_ADDNEWDIALOG
	MOV EDI,Offset szAddNewDialog
	CALL Load32Chars
	MOV ECX,IDTS_NEWMENU
	MOV EDI,Offset szNewMenu
	CALL Load32Chars
	MOV ECX,IDTS_INCFILES
	MOV EDI,Offset szIncFiles
	CALL Load32Chars
	MOV ECX,IDTS_ADDACCELERATORTABLE
	MOV EDI,Offset szAddAcceleratorTable
	CALL Load32Chars
	MOV ECX,IDTS_ADDVERSIONINFO
	MOV EDI,Offset szAddVersionInfo
	CALL Load32Chars
	MOV ECX,IDTS_STRINGTABLE
	MOV EDI,Offset szStringTable
	CALL Load32Chars
	MOV ECX,IDTS_RESOURCES
	MOV EDI,Offset szResources
	CALL Load32Chars
	MOV ECX,IDTS_REMOVE
	MOV EDI,Offset szRemoveT
	CALL Load32Chars
	
	
	MOV ECX,IDTCS_PROJECT
	MOV EDI,Offset szProject
	CALL Load32Chars
	MOV ECX,IDTCS_BLOCKS
	MOV EDI,Offset szBlocks
	CALL Load32Chars
	
	MOV ECX,IDTCS_DIALOGS
	MOV EDI,Offset szDialogs
	CALL Load32Chars
	MOV ECX,IDTCS_OTHERS
	MOV EDI,Offset szOthers
	CALL Load32Chars
	
	
	MOV ECX,IDTVS_MENUS
	MOV EDI,Offset szMenus
	CALL Load32Chars
	MOV ECX,IDTVS_ACCELERATORTABLES
	MOV EDI,Offset szAcceleratorTables
	CALL Load32Chars
	MOV ECX,IDTVS_VERSIONINFO
	MOV EDI,Offset szVersionInfo
	CALL Load32Chars
	MOV ECX,IDTVS_ASMFILES
	MOV EDI,Offset szASMFiles
	CALL Load32Chars
	MOV ECX,IDTVS_MODULES
	MOV EDI,Offset szModules
	CALL Load32Chars
	MOV ECX,IDTVS_INCLUDEFILES
	MOV EDI,Offset szIncludeFiles
	CALL Load32Chars
	MOV ECX,IDTVS_RESOURCEFILES
	MOV EDI,Offset szResourceFiles
	CALL Load32Chars
	MOV ECX,IDTVS_TEXTFILES
	MOV EDI,Offset szTextFiles
	CALL Load32Chars
	MOV ECX,IDTVS_BATCHFILES
	MOV EDI,Offset szBatchFiles
	CALL Load32Chars
	MOV ECX,IDTVS_DEFINITIONFILES
	MOV EDI,Offset szDefinitionFiles
	CALL Load32Chars
	MOV ECX,IDTVS_OTHERFILES
	MOV EDI,Offset szOtherFiles
	CALL Load32Chars
	
	MOV ECX,IDLBS_EDITORBACKCOLOR
	MOV EDI,Offset szLBEditorBackColor
	CALL Load32Chars
	MOV ECX,IDLBS_NORMALTEXTCOLOR
	MOV EDI,Offset szLBNormalTextColor
	CALL Load32Chars
	MOV ECX,IDLBS_SELECTIONBACKCOLOR
	MOV EDI,Offset szLBSelectionBackColor
	CALL Load32Chars
	MOV ECX,IDLBS_SELECTEDTEXTCOLOR
	MOV EDI,Offset szLBSelectedTextColor
	CALL Load32Chars
	MOV ECX,IDLBS_COMMENTCOLOR
	MOV EDI,Offset szLBCommentColor
	CALL Load32Chars
	MOV ECX,IDLBS_STRINGCOLOR
	MOV EDI,Offset szLBStringColor
	CALL Load32Chars
	MOV ECX,IDLBS_OPERATORCOLOR
	MOV EDI,Offset szLBOperatorColor
	CALL Load32Chars
	MOV ECX,IDLBS_ERROREDLINEBACKCOLOR
	MOV EDI,Offset szLBErroredLineBackColor
	CALL Load32Chars
	MOV ECX,IDLBS_NOERRORSLINEBACKCOLOR
	MOV EDI,Offset szLBNoErrorsLineBackColor
	CALL Load32Chars
	MOV ECX,IDLBS_TABINDICATORSCOLOR
	MOV EDI,Offset szLBTabIndicatorsColor
	CALL Load32Chars
	MOV ECX,IDLBS_SELECTIONBARCOLOR
	MOV EDI,Offset szLBSelectionBarColor
	CALL Load32Chars
	MOV ECX,IDLBS_DIVIDERLINECOLOR
	MOV EDI,Offset szLBDividerLineColor
	CALL Load32Chars
	MOV ECX,IDLBS_LINENUMBERSCOLOR
	MOV EDI,Offset szLBLinenumberscolor
	CALL Load32Chars
	MOV ECX,IDLBS_NUMBERCOLOR
	MOV EDI,Offset szLBNumberColor
	CALL Load32Chars
	
	MOV ECX,IDLBS_TOOLTIPSBACKCOLOR
	MOV EDI,Offset szLBToolTipsBackColor
	CALL Load32Chars
	
	MOV ECX,IDLBS_TOOLTIPSACTIVEPARAMCOLOR
	MOV EDI,Offset szLBToolTipsActiveParamColor
	CALL Load32Chars

	MOV ECX,IDLBS_PROJECTTREEBACKCOLOR
	MOV EDI,Offset szLBProjectTreeBackColor
	CALL Load32Chars
	MOV ECX,IDLBS_PROJECTTREETEXTCOLOR
	MOV EDI,Offset szLBProjectTreeTextColor
	CALL Load32Chars
	MOV ECX,IDLBS_PROJECTTREELINECOLOR
	MOV EDI,Offset szLBProjectTreeLineColor
	CALL Load32Chars
	MOV ECX,IDLBS_RCEDITORBACKCOLOR
	MOV EDI,Offset szLBRCEditorBackColor
	CALL Load32Chars

	MOV ECX,IDCBS_DEFAULT
	MOV EDI,Offset szDefault
	CALL Load32Chars
	MOV ECX,IDCBS_UPPERCASE
	MOV EDI,Offset szUppercase
	CALL Load32Chars
	MOV ECX,IDCBS_LOWERCASE
	MOV EDI,Offset szLowercase
	CALL Load32Chars
	


	MOV ECX,IDPS_NAME
	MOV EDI,Offset szName
	CALL Load32Chars
	MOV ECX,IDPS_ID
	MOV EDI,Offset szID
	CALL Load32Chars
	MOV ECX,IDPS_LEFT
	MOV EDI,Offset szLeftt
	CALL Load32Chars
	MOV ECX,IDPS_TOP
	MOV EDI,Offset szTop
	CALL Load32Chars
	MOV ECX,IDPS_WIDTH
	MOV EDI,Offset szWidth
	CALL Load32Chars
	MOV ECX,IDPS_HEIGHT
	MOV EDI,Offset szHeight
	CALL Load32Chars
	MOV ECX,IDPS_STYLE
	MOV EDI,Offset szStyle
	CALL Load32Chars
	MOV ECX,IDPS_EXSTYLE
	MOV EDI,Offset szExStyle
	CALL Load32Chars
	MOV ECX,IDPS_VISIBLEPROPERTY
	MOV EDI,Offset szVisibleProperty
	CALL Load32Chars
	MOV ECX,IDPS_CAPTION
	MOV EDI,Offset szCaption
	CALL Load32Chars
	MOV ECX,IDPS_TEXT
	MOV EDI,Offset szText
	CALL Load32Chars
	MOV ECX,IDPS_IMAGE
	MOV EDI,Offset szImage
	CALL Load32Chars
	MOV ECX,IDPS_MENU
	MOV EDI,Offset szMenu
	CALL Load32Chars
	MOV ECX,IDPS_CLASS
	MOV EDI,Offset szClass
	CALL Load32Chars
	MOV ECX,IDPS_FONT
	MOV EDI,Offset szFont
	CALL Load32Chars
	
	MOV ECX,IDTCS_PROJECTTYPE
	MOV EDI,Offset szProjectType
	CALL Load32Chars
	MOV ECX,IDTCS_RESOURCEMAKEOPTIONS
	MOV EDI,Offset szResourceMakeOptions
	CALL Load32Chars
	MOV ECX,IDTCS_RELEASEMAKEOPTIONS
	MOV EDI,Offset szReleaseMakeOptions
	CALL Load32Chars
	MOV ECX,IDTCS_DEBUGMAKEOPTIONS
	MOV EDI,Offset szDebugMakeOptions
	CALL Load32Chars
	
	MOV ECX,IDTCS_GENERAL
	MOV EDI,Offset szGeneral
	CALL Load32Chars
	MOV ECX,IDTCS_FILESANDPATHS
	MOV EDI,Offset szFilesAndPaths
	CALL Load32Chars
	MOV ECX,IDTCS_EDITOR
	MOV EDI,Offset szEditor
	CALL Load32Chars
	MOV ECX,IDTCS_INTELLISENSE
	MOV EDI,Offset szIntellisense
	CALL Load32Chars
	MOV ECX,IDTCS_KEYWORDS
	MOV EDI,Offset szKeyWords
	CALL Load32Chars
	MOV ECX,IDTCS_COLORS
	MOV EDI,Offset szColors
	CALL Load32Chars
	MOV ECX,IDTCS_MISCELLANEOUS
	MOV EDI,Offset szMiscellaneous
	CALL Load32Chars
	
	MOV ECX,IDPTS_STANDARDEXE
	MOV EDI,Offset szStandardEXE
	CALL Load32Chars
	MOV ECX,IDPTS_STANDARDDLL
	MOV EDI,Offset szStandardDLL
	CALL Load32Chars
	MOV ECX,IDPTS_CONSOLEAPPLICATION
	MOV EDI,Offset szConsoleApplication
	CALL Load32Chars
	MOV ECX,IDPTS_STATICLIBRARY
	MOV EDI,Offset szStaticLibrary
	CALL Load32Chars
	MOV ECX,IDPTS_OTHEREXE
	MOV EDI,Offset szOtherExe
	CALL Load32Chars
	MOV ECX,IDPTS_OTHERNOTEXE
	MOV EDI,Offset szOtherNotExe
	CALL Load32Chars
	MOV ECX,IDPTS_DOSPROJECT
	MOV EDI,Offset szDOSProject
	CALL Load32Chars
	
	MOV ECX,IDGS_YES
	MOV EDI,Offset szYes
	CALL Load32Chars
	MOV ECX,IDGS_NO
	MOV EDI,Offset szNo
	CALL Load32Chars
	MOV ECX,IDGS_TRUE
	MOV EDI,Offset szTRUE
	CALL Load32Chars
	MOV ECX,IDGS_FALSE
	MOV EDI,Offset szFALSE
	CALL Load32Chars

	
	MOV ECX,IDMS_FILE
	MOV EDI,Offset szFileMenu
	CALL Load32Chars
	MOV ECX,IDMS_NEWPROJECT
	MOV EDI,Offset szNewProject
	CALL Load32Chars
	MOV ECX,IDMS_OPENPROJECT
	MOV EDI,Offset szOpenProject
	CALL Load32Chars
	MOV ECX,IDMS_CLOSEPROJECT
	MOV EDI,Offset szCloseProject
	CALL Load32Chars
	MOV ECX,IDMS_SAVEPROJECT
	MOV EDI,Offset szSaveProject
	CALL Load32Chars
	MOV ECX,IDMS_SAVEPROJECTAS
	MOV EDI,Offset szSaveProjectAs
	CALL Load32Chars
	MOV ECX,IDMS_NEWFILE
	MOV EDI,Offset szNewFileMItem
	CALL Load32Chars
	MOV ECX,IDMS_NEWASMFILE
	MOV EDI,Offset szNewASMFile
	CALL Load32Chars
	MOV ECX,IDMS_NEWINCFILE
	MOV EDI,Offset szNewINCFileMItem
	CALL Load32Chars
	MOV ECX,IDMS_NEWRCFILE
	MOV EDI,Offset szNewRCFileMItem
	CALL Load32Chars
	MOV ECX,IDMS_NEWOTHERFILE
	MOV EDI,Offset szNewOtherFileMItem
	CALL Load32Chars
	MOV ECX,IDMS_OPENFILES
	MOV EDI,Offset szOpenFiles
	CALL Load32Chars
	MOV ECX,IDMS_SAVEFILE
	MOV EDI,Offset szSaveFile
	CALL Load32Chars
	MOV ECX,IDMS_SAVEFILEAS
	MOV EDI,Offset szSaveFileAs
	CALL Load32Chars
	MOV ECX,IDMS_PRINT
	MOV EDI,Offset szPrint
	CALL Load32Chars
	MOV ECX,IDMS_RECENTPROJECTSMANAGER
	MOV EDI,Offset szRecentProjectsManager
	CALL Load32Chars
	MOV ECX,IDMS_EXIT
	MOV EDI,Offset szExit
	CALL Load32Chars
	
	
	MOV ECX,IDMS_EDIT
	MOV EDI,Offset szEditMenu
	CALL Load32Chars
	MOV ECX,IDMS_UNDO
	MOV EDI,Offset szUndo
	CALL Load32Chars
	MOV ECX,IDMS_REDO
	MOV EDI,Offset szRedo
	CALL Load32Chars
	MOV ECX,IDMS_CUT
	MOV EDI,Offset szCut
	CALL Load32Chars
	MOV ECX,IDMS_COPY
	MOV EDI,Offset szCopyT
	CALL Load32Chars
	MOV ECX,IDMS_PASTE
	MOV EDI,Offset szPaste
	CALL Load32Chars
	MOV ECX,IDMS_DELETE
	MOV EDI,Offset szDelete
	CALL Load32Chars
	MOV ECX,IDMS_SELECTALL
	MOV EDI,Offset szSelectAll
	CALL Load32Chars
	MOV ECX,IDMS_FIND
	MOV EDI,Offset szFind
	CALL Load32Chars
	MOV ECX,IDMS_FINDNEXT
	MOV EDI,Offset szFindNext
	CALL Load32Chars
	MOV ECX,IDMS_FINDPREVIOUS
	MOV EDI,Offset szFindPrevious
	CALL Load32Chars
	MOV ECX,IDMS_SMARTFIND
	MOV EDI,Offset szSmartFind
	CALL Load32Chars
	MOV ECX,IDMS_REPLACE
	MOV EDI,Offset szReplaceMItem
	CALL Load32Chars
	MOV ECX,IDMS_GOTOLINE
	MOV EDI,Offset szGotoLine
	CALL Load32Chars
	MOV ECX,IDMS_GOTOBLOCK
	MOV EDI,Offset szGotoBlock
	CALL Load32Chars
	MOV ECX,IDMS_GOBACK
	MOV EDI,Offset szGoBack
	CALL Load32Chars
	MOV ECX,IDMS_TOGGLEBOOKMARK
	MOV EDI,Offset szToggleBookmark
	CALL Load32Chars
	MOV ECX,IDMS_NEXTBOOKMARK
	MOV EDI,Offset szNextBookmark
	CALL Load32Chars
	MOV ECX,IDMS_PREVIOUSBOOKMARK
	MOV EDI,Offset szPreviousBookmark
	CALL Load32Chars
	MOV ECX,IDMS_CLEARALLBOOKMARKS
	MOV EDI,Offset szClearAllBookmarks
	CALL Load32Chars
	MOV ECX,IDMS_HIDELINES
	MOV EDI,Offset szHideLines
	CALL Load32Chars

	MOV ECX,IDMS_VIEW
	MOV EDI,Offset szViewMenu
	CALL Load32Chars
	MOV ECX,IDMS_VIEWEXPLORER
	MOV EDI,Offset szProjectExplorerMItem
	CALL Load32Chars
	MOV ECX,IDMS_VIEWOUTPUT
	MOV EDI,Offset szOutputWindow
	CALL Load32Chars
	MOV ECX,IDMS_VIEWTOOLBOX
	MOV EDI,Offset szToolBoxMItem
	CALL Load32Chars
	MOV ECX,IDMS_VIEWDIALOG
	MOV EDI,Offset szDialogMItem
	CALL Load32Chars
	
	MOV ECX,IDMS_PROJECT
	MOV EDI,Offset szProjectMenu
	CALL Load32Chars
	MOV ECX,IDMS_ADDNEWASM
	MOV EDI,Offset szAddNewAsm
	CALL Load32Chars
	MOV ECX,IDMS_ADDNEWINC
	MOV EDI,Offset szAddNewInc
	CALL Load32Chars
	MOV ECX,IDMS_ADDNEWRC
	MOV EDI,Offset szAddNewRc
	CALL Load32Chars
	MOV ECX,IDMS_ADDNEWOTHER
	MOV EDI,Offset szAddNewOther
	CALL Load32Chars
	MOV ECX,IDMS_ADDFILES
	MOV EDI,Offset szAddFiles
	CALL Load32Chars
	MOV ECX,IDMS_MODULE
	MOV EDI,Offset szModule
	CALL Load32Chars
	MOV ECX,IDMS_RENAMEFILE
	MOV EDI,Offset szRenameFile
	CALL Load32Chars
	MOV ECX,IDMS_REMOVEFILE
	MOV EDI,Offset szRemoveFile
	CALL Load32Chars
	MOV ECX,IDMS_RUNBATCHFILE
	MOV EDI,Offset szRunBatchFile
	CALL Load32Chars
	MOV ECX,IDMS_VISUALMODE
	MOV EDI,Offset szVisualMode
	CALL Load32Chars
	MOV ECX,IDMS_USEEXTERNALEDITOR
	MOV EDI,Offset szUseExternalEditor
	CALL Load32Chars
	MOV ECX,IDMS_PROPERTIES
	MOV EDI,Offset szProperties
	CALL Load32Chars
	MOV ECX,IDMS_BINARYFILES
	MOV EDI,Offset szBinaryFiles
	CALL Load32Chars
	MOV ECX,IDMS_RENAMEPROJECT
	MOV EDI,Offset szRenameProjectMItem
	CALL Load32Chars
	
	MOV ECX,IDMS_FORMAT
	MOV EDI,Offset szFormatMenu
	CALL Load32Chars
	MOV ECX,IDMS_INDENT
	MOV EDI,Offset szIndent
	CALL Load32Chars
	MOV ECX,IDMS_OUTDENT
	MOV EDI,Offset szOutdent
	CALL Load32Chars
	MOV ECX,IDMS_COMMENT
	MOV EDI,Offset szComment
	CALL Load32Chars
	MOV ECX,IDMS_UNCOMMENT
	MOV EDI,Offset szUncomment
	CALL Load32Chars
	MOV ECX,IDMS_CONVERT
	MOV EDI,Offset szConvert
	CALL Load32Chars
	MOV ECX,IDMS_TOUPPERCASE
	MOV EDI,Offset szToUpperCase
	CALL Load32Chars
	MOV ECX,IDMS_TOLOWERCASE
	MOV EDI,Offset szToLowerCase
	CALL Load32Chars
	MOV ECX,IDMS_TOGGLECASE
	MOV EDI,Offset szToggleCase
	CALL Load32Chars
	
	MOV ECX,IDMS_RESOUCES
	MOV EDI,Offset szResourcesMenu
	CALL Load32Chars
	MOV ECX,IDMS_DIALOG
	MOV EDI,Offset szDialogMenu
	CALL Load32Chars
	MOV ECX,IDMS_SHOWHIDEGRID
	MOV EDI,Offset szShowHideGrid
	CALL Load32Chars
	MOV ECX,IDMS_SNAPTOGRID
	MOV EDI,Offset szSnapToGrid
	CALL Load32Chars
	MOV ECX,IDMS_CONTROLSMANAGER
	MOV EDI,Offset szControlsManager
	CALL Load32Chars
	MOV ECX,IDMS_STYLEMITEM
	MOV EDI,Offset szStyleMItem
	CALL Load32Chars
	MOV ECX,IDMS_EXSTYLEMITEM
	MOV EDI,Offset szExStyleMItem
	CALL Load32Chars
	MOV ECX,IDMS_FONTMITEM
	MOV EDI,Offset szFontMItem
	CALL Load32Chars
	MOV ECX,IDMS_SENDTOBACK
	MOV EDI,Offset szSendToBack
	CALL Load32Chars
	MOV ECX,IDMS_BRINGTOFRONT
	MOV EDI,Offset szBringToFront
	CALL Load32Chars
	MOV ECX,IDMS_TESTDIALOG
	MOV EDI,Offset szTestDialog
	CALL Load32Chars
	MOV ECX,IDMS_DEFINITIONS
	MOV EDI,Offset szDefinitions
	CALL Load32Chars
	
	
	MOV ECX,IDMS_MAKE
	MOV EDI,Offset szMakeMenu
	CALL Load32Chars
	MOV ECX,IDMS_SETACTIVEBUILD
	MOV EDI,Offset szSetActiveBuild
	CALL Load32Chars
	MOV ECX,IDMS_RELEASEVERSION
	MOV EDI,Offset szReleaseVersion
	CALL Load32Chars
	MOV ECX,IDMS_DEBUGVERSION
	MOV EDI,Offset szDebugVersion
	CALL Load32Chars
	MOV ECX,IDMS_CLEAN
	MOV EDI,Offset szClean
	CALL Load32Chars
	MOV ECX,IDMS_COMPILERCMITEM
	MOV EDI,Offset szCompileRCMItem
	CALL Load32Chars
	MOV ECX,IDMS_RCTOOBJMITEM
	MOV EDI,Offset szRCToObjMItem
	CALL Load32Chars
	MOV ECX,IDMS_ASSEMBLEMITEM
	MOV EDI,Offset szAssembleMItem
	CALL Load32Chars
	MOV ECX,IDMS_LINKMITEM
	MOV EDI,Offset szLinkMItem
	CALL Load32Chars
	MOV ECX,IDMS_GOALL
	MOV EDI,Offset szGoAll
	CALL Load32Chars
	MOV ECX,IDMS_EXECUTE
	MOV EDI,Offset szExecute
	CALL Load32Chars
	MOV ECX,IDMS_DEBUG
	MOV EDI,Offset szDebug
	CALL Load32Chars
	
	
	MOV ECX,IDMS_TOOLS
	MOV EDI,Offset szToolsMenu
	CALL Load32Chars
	MOV ECX,IDMS_CODEEDITORFONT
	MOV EDI,Offset szCodeEditorFont
	CALL Load32Chars
	MOV ECX,IDMS_LINENUMBERFONT
	MOV EDI,Offset szLineNumberFont
	CALL Load32Chars
	MOV ECX,IDMS_OPTIONS
	MOV EDI,Offset szOptions
	CALL Load32Chars
	MOV ECX,IDMS_TOOLSMANAGER
	MOV EDI,Offset szToolsManagerMItem
	CALL Load32Chars
	MOV ECX,IDMS_INTERFACEPACKS
	MOV EDI,Offset szInterfacePacks
	CALL Load32Chars
	
	
	MOV ECX,IDMS_ADDINS
	MOV EDI,Offset szAddInsMenu
	CALL Load32Chars
	MOV ECX,IDMS_ADDINSMANAGER
	MOV EDI,Offset szAddInsManager
	CALL Load32Chars
	

	
	
	MOV ECX,IDMS_WINDOW
	MOV EDI,Offset szWindowMenu
	CALL Load32Chars
	MOV ECX,IDMS_CLOSE
	MOV EDI,Offset szClose
	CALL Load32Chars
	MOV ECX,IDMS_HIDEALL
	MOV EDI,Offset szCloseAll
	CALL Load32Chars
	MOV ECX,IDMS_NEXT
	MOV EDI,Offset szNext
	CALL Load32Chars
	MOV ECX,IDMS_PREVIOUS
	MOV EDI,Offset szPrevious
	CALL Load32Chars
	MOV ECX,IDMS_TILEHORIZONTALLY
	MOV EDI,Offset szTileHorizontally
	CALL Load32Chars
	MOV ECX,IDMS_TILEVERTICALLY
	MOV EDI,Offset szTileVertically
	CALL Load32Chars
	MOV ECX,IDMS_CASCADE
	MOV EDI,Offset szCascade
	CALL Load32Chars
	
	
	MOV ECX,IDMS_HELP
	MOV EDI,Offset szHelpMenu
	CALL Load32Chars
	MOV ECX,IDMS_WINASMSTUDIOHELP
	MOV EDI,Offset szWinAsmHelp
	CALL Load32Chars
	MOV ECX,IDMS_OTHERHELP
	MOV EDI,Offset szOtherHelp
	CALL Load32Chars
	MOV ECX,IDMS_ONTHEWEB
	MOV EDI,Offset szOnTheWeb
	CALL Load32Chars
	MOV ECX,IDMS_ABOUT
	MOV EDI,Offset szAboutWinAsm
	CALL Load32Chars
	
	MOV ECX,IDMS_RESTORE
	MOV EDI,Offset szRestore
	CALL Load32Chars
	MOV ECX,IDMS_GRADIENT
	MOV EDI,Offset szGradient
	CALL Load32Chars
	MOV ECX,IDMS_DOUBLELINE
	MOV EDI,Offset szDoubleLine
	CALL Load32Chars
	MOV ECX,IDMS_SINGLELINE
	MOV EDI,Offset szSingleLine
	CALL Load32Chars
	
	MOV ECX,IDMS_COPYSELECTION
	MOV EDI,Offset szCopySelection
	CALL Load32Chars
	MOV ECX,IDMS_COPYALLTEXT
	MOV EDI,Offset szCopyAllText
	CALL Load32Chars
	MOV ECX,IDMS_SAVEOUTTEXT
	MOV EDI,Offset szSaveOutText
	CALL Load32Chars
	


	
	MOV ECX,IDTT_NEWPROJECT
	MOV EDI,Offset szTipNewProject
	CALL Load32Chars
	MOV ECX,IDTT_OPENPROJECT
	MOV EDI,Offset szTipOpenProject
	CALL Load32Chars
	MOV ECX,IDTT_OPENFILES
	MOV EDI,Offset szTipOpenFiles
	CALL Load32Chars
	MOV ECX,IDTT_ADDFILES
	MOV EDI,Offset szTipAddFiles
	CALL Load32Chars
	MOV ECX,IDTT_SAVEFILE
	MOV EDI,Offset szTipSaveFile
	CALL Load32Chars
	MOV ECX,IDTT_SAVEPROJECT
	MOV EDI,Offset szTipSaveProject
	CALL Load32Chars
	MOV ECX,IDTT_CUT
	MOV EDI,Offset szTipCut
	CALL Load32Chars
	MOV ECX,IDTT_COPY
	MOV EDI,Offset szTipCopy
	CALL Load32Chars
	MOV ECX,IDTT_PASTE
	MOV EDI,Offset szTipPaste
	CALL Load32Chars
	MOV ECX,IDTT_UNDO
	MOV EDI,Offset szTipUndo
	CALL Load32Chars
	MOV ECX,IDTT_REDO
	MOV EDI,Offset szTipRedo
	CALL Load32Chars
	MOV ECX,IDTT_SHOWHIDEEXPLORER
	MOV EDI,Offset szTipShowHideExplorer
	CALL Load32Chars
	MOV ECX,IDTT_VISUALMODE
	MOV EDI,Offset szTipVisualMode
	CALL Load32Chars
	MOV ECX,IDTT_FIND
	MOV EDI,Offset szTipFind
	CALL Load32Chars
	MOV ECX,IDTT_REPLACE
	MOV EDI,Offset szTipReplace
	CALL Load32Chars
	MOV ECX,IDTT_INCREASEINDENT
	MOV EDI,Offset szTipIncreaseIndent
	CALL Load32Chars
	MOV ECX,IDTT_DECREASEINDENT
	MOV EDI,Offset szTipDecreaseIndent
	CALL Load32Chars
	MOV ECX,IDTT_COMMENTBLOCK
	MOV EDI,Offset szTipCommentBlock
	CALL Load32Chars
	MOV ECX,IDTT_UNCOMMENTBLOCK
	MOV EDI,Offset szTipUncommentBlock
	CALL Load32Chars
	MOV ECX,IDTT_TOGGLEBOOKMARK
	MOV EDI,Offset szTipToggleBookmark
	CALL Load32Chars
	MOV ECX,IDTT_NEXTBOOKMARK
	MOV EDI,Offset szTipNextBookmark
	CALL Load32Chars
	MOV ECX,IDTT_PREVIOUSBOOKMARK
	MOV EDI,Offset szTipPreviousBookmark
	CALL Load32Chars
	MOV ECX,IDTT_CLEARALLBOOKMARKS
	MOV EDI,Offset szTipClearAllBookmarks
	CALL Load32Chars
	MOV ECX,IDTT_ASSEMBLE
	MOV EDI,Offset szTipAssemble
	CALL Load32Chars
	MOV ECX,IDTT_LINK
	MOV EDI,Offset szTipLink
	CALL Load32Chars
	MOV ECX,IDTT_GOALL
	MOV EDI,Offset szTipGoAll
	CALL Load32Chars
	MOV ECX,IDTT_EXECUTE
	MOV EDI,Offset szTipExecute
	CALL Load32Chars
	MOV ECX,IDTT_STOP
	MOV EDI,Offset szTipStop
	CALL Load32Chars
	
	
	;Docking windows
	MOV ECX,IDDW_EXPLORER
	MOV EDI,Offset szExplorer
	CALL Load32Chars
	MOV ECX,IDDW_OUTPUT
	MOV EDI,Offset szOutput
	CALL Load32Chars
	MOV ECX,IDDW_DIALOG
	MOV EDI,Offset szDialogDW
	CALL Load32Chars
	MOV ECX,IDDW_TOOLBOX
	MOV EDI,Offset szToolBox
	CALL Load32Chars
	
	
	MOV ECX,IDAD_KEY
	MOV EDI,Offset szKey
	CALL Load32Chars
	MOV ECX,IDSD_STRING
	MOV EDI,Offset szString
	CALL Load32Chars
	MOV ECX,IDRP_PROJECTS
	MOV EDI,Offset szProjects
	CALL Load32Chars
	MOV ECX,IDAS_FILE
	MOV EDI,Offset szFile
	CALL Load32Chars
	MOV ECX,IDAM_AVAILABLEADDINS
	MOV EDI,Offset szAvailableAddIns
	CALL Load32Chars
	MOV ECX,IDAM_LOADSTATUS
	MOV EDI,Offset szLoadStatus
	CALL Load32Chars
	MOV ECX,IDAM_LOADONSTARTUP
	MOV EDI,Offset szLoadOnStartUp
	CALL Load32Chars
	
	
	
	
	MOV ECX,IDDT_OPENPROJECT
	MOV EDI,Offset szOpenProjectDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_SAVEPROJECTAS
	MOV EDI,Offset szSaveProjectAsDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_OPENFILES
	MOV EDI,Offset szOpenFilesDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_ADDFILES
	MOV EDI,Offset szAddFilesDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_SAVEFILEAS
	MOV EDI,Offset szSaveFileAsDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_RENAMEFILE
	MOV EDI,Offset szRenameFileDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_PRINT
	MOV EDI,Offset szPrintDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_NEWPROJECT
	MOV EDI,Offset szNewProjectDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_BROWSE
	MOV EDI,Offset szBrowseDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_BROWSEFORPATH
	MOV EDI,Offset szBrowseForPathDialogTitle
	CALL Load32Chars
	MOV ECX,IDDT_WINDOWSTYLES
	MOV EDI,Offset szWindowStyles
	CALL Load32Chars
	MOV ECX,IDDT_WINDOWEXSTYLES
	MOV EDI,Offset szWindowExStyles
	CALL Load32Chars
	MOV ECX,IDDT_RENAMEPROJECT
	MOV EDI,Offset Offset szRenameProjectDialogTitle
	CALL Load32Chars
	

	
	MOV ECX,IDGS_SELECTPROCEDUREORGOTOTOP
	MOV EDI,Offset szSelectProcedureOrGoToTop
	CALL Load32Chars
	
	
	
	MOV ECX,IDSBS_SAVING
	MOV EDI,Offset szSaving
	CALL Load32Chars
	MOV ECX,IDSBS_COMPILINGRESOURCES
	MOV EDI,Offset szCompilingResources
	CALL Load32Chars
	MOV ECX,IDSBS_CONVERTINGRESTOOBJ
	MOV EDI,Offset szConvertingResToObj
	CALL Load32Chars
	MOV ECX,IDSBS_ASSEMBLINGPROJECT
	MOV EDI,Offset szAssemblingProject
	CALL Load32Chars
	MOV ECX,IDSBS_LINKING
	MOV EDI,Offset szLinking
	CALL Load32Chars
	MOV ECX,IDSBS_LNCOLSEL
	MOV EDI,Offset szLnColSel
	CALL Load32Chars
	
	
	MOV ECX,IDSBS_SEARCHING
	MOV EDI,Offset szSearching
	CALL Load32Chars
	MOV ECX,IDSBS_REPLACING
	MOV EDI,Offset szReplacing
	CALL Load32Chars
	
	MOV ECX,IDSBS_LOADINGRESOURCES
	MOV EDI,Offset szLoadingResources
	CALL Load32Chars
	MOV ECX,IDSBS_LOADINGPROJECT
	MOV EDI,Offset szLoadingProject
	CALL Load32Chars
	MOV ECX,IDSBS_CREATINGPROJECT
	MOV EDI,Offset szCreatingProject
	CALL Load32Chars
	
	
	
	MOV ECX,IDSBS_SEARCHFINISHED
	MOV EDI,Offset szSearchFinished
	CALL Load64Chars
	
	MOV ECX,IDMSG_CREATEPIPEERROR
	MOV EDI,Offset szCreatePipeError
	CALL Load64Chars
	MOV ECX,IDMSG_CREATEPROCESSERROR
	MOV EDI,Offset szCreateProcessError
	CALL Load64Chars
	
	MOV ECX,IDMSG_MAKEFINSHED
	MOV EDI,Offset szMakeFinshed
	CALL Load64Chars
	MOV ECX,IDMSG_MAKEERROR
	MOV EDI,Offset szMakeError
	CALL Load64Chars
	MOV ECX,IDMSG_CANNOTSAVEFILE
	MOV EDI,Offset szCannotSaveFile
	CALL Load64Chars
	MOV ECX,IDMSG_TRIGGERALREADYUSED
	MOV EDI,Offset szTriggerAlreadyUsed
	CALL Load64Chars
	
	
	MOV ECX,IDMSG_LINE
	MOV EDI,Offset szLine
	CALL Load32Chars
	MOV ECX,IDMSG_ISADIRECTORY
	MOV EDI,Offset szIsADirectory
	CALL Load32Chars
	MOV ECX,IDMSG_ISALREADYDEFINEDAS
	MOV EDI,Offset szIsAlreadyDefinedAs
	CALL Load32Chars
	MOV ECX,IDMSG_DOYOUWANTTOCHANGEIT
	MOV EDI,Offset szDoYouWantToChangeIt
	CALL Load32Chars
	MOV ECX,IDMSG_THELEVELOFMENUITEM
	MOV EDI,Offset szTheLevelOfMenuItem
	CALL Load32Chars
	MOV ECX,IDMSG_ISNOTCORRECT
	MOV EDI,Offset szIsNotCorrect
	CALL Load32Chars
	MOV ECX,IDMSG_EXECUTIONERROR
	MOV EDI,Offset szExecutionError
	CALL Load32Chars
	MOV ECX,IDMSG_ERRORLOADINGFILE
	MOV EDI,Offset ErrorLoadingFile
	CALL Load32Chars

	
	
	
	MOV ECX,IDMSG_SURETOREMOVEFILEFROMPROJECT
	MOV EDI,Offset szSureToRemoveFileFromProject
	CALL Load64Chars
	MOV ECX,IDMSG_SURETOREMOVEMENU
	MOV EDI,Offset szSureToRemoveMenu
	CALL Load64Chars
	MOV ECX,IDMSG_CONTROLUSED
	MOV EDI,Offset szControlUsed
	CALL Load64Chars
	MOV ECX,IDMSG_SURETODELETECONTROL
	MOV EDI,Offset szSureToDeleteControl
	CALL Load64Chars
	MOV ECX,IDMSG_FILEMODIFIED
	MOV EDI,Offset szFileModified
	CALL Load64Chars
	MOV ECX,IDMSG_ASKTOSAVEFILECHANGES
	MOV EDI,Offset szAskToSaveFileChanges
	CALL Load64Chars
	MOV ECX,IDMSG_SURETOREMOVEACCELERATORTABLE
	MOV EDI,Offset szSureToRemoveAcceleratorTable
	CALL Load64Chars
	MOV ECX,IDMSG_SURETOREMOVEVERSIONINFO
	MOV EDI,Offset szSureToRemoveVersionInfo
	CALL Load64Chars
	MOV ECX,IDMSG_SURETOREMOVESTRINGTABLE
	MOV EDI,Offset szSureToRemoveStringTable
	CALL Load64Chars
	MOV ECX,IDMSG_FRIENDLYNAMEREQUIRED
	MOV EDI,Offset szFriendlyNameRequired
	CALL Load64Chars
	MOV ECX,IDMSG_CLASSNAMEREQUIRED
	MOV EDI,Offset szClassNameRequired
	CALL Load64Chars
	MOV ECX,IDMSG_CLASSALREADYUSED
	MOV EDI,Offset szClassAlreadyUsed
	CALL Load64Chars
	MOV ECX,IDMSG_NOTWAPROJECTFILE
	MOV EDI,Offset szNotWinAsmStudioProjectFile
	CALL Load64Chars
	MOV ECX,IDMSG_PROJECTWASNOTSAVED
	MOV EDI,Offset szProjectWasNotSaved
	CALL Load64Chars
	MOV ECX,IDMSG_SURETODELETETHISDIALOG
	MOV EDI,Offset szSureToDeleteThisDialog
	CALL Load64Chars
	

	MOV ESI,IDFS_OPENPROJECT
	MOV EDI,Offset OpenProjectFilter
	CALL Load128Chars
	MOV ESI,IDFS_CHOOSEDLL
	MOV EDI,Offset DLLsFilter
	CALL Load128Chars
	MOV ESI,IDFS_CHOOSEEXECUTABLE
	MOV EDI,Offset ExecutablesFilter
	CALL Load128Chars
	MOV ESI,IDFS_CHOOSEKEYFILE
	MOV EDI,Offset KeyFilesFilter
	CALL Load128Chars
	MOV ESI,IDFS_CHOOSEAPIFILE
	MOV EDI,Offset APIFilesFilter
	CALL Load128Chars
	MOV ESI,IDFS_CHOOSEHELPFILE
	MOV EDI,Offset HelpFilesFilter
	CALL Load128Chars
	MOV ESI,IDFS_CHOOSEALLFILES
	MOV EDI,Offset AllFilesFilter
	CALL Load128Chars

	MOV ESI,IDFS_CHOOSEBINARYFILE
	MOV EDI,Offset BinaryFilesFilter
	CALL Load128Chars


	
	MOV ECX,IDMSG_LINENOTCOMPATIBLE
	MOV EDI,Offset szLineNotCompatible
	CALL Load256Chars
	MOV ECX,IDMSG_CODEHINOTFOUND
	MOV EDI,Offset szCodeHiNotFound
	CALL Load256Chars
	
	
	MOV ESI,IDFS_ADDOPENSAVEFILES
	MOV EDI,Offset AddOpenSaveFilesFilter
	CALL Load512Chars
	MOV ESI,IDFS_CHOOSERESOURCE
	MOV EDI,Offset ResourcesFilter
	CALL Load512Chars


	RET
	

	Load32Chars:
	Invoke LoadString,EBX,ECX,EDI,32
	RETN
	
	Load64Chars:
	Invoke LoadString,EBX,ECX,EDI,64
	RETN

	Load128Chars:
	Invoke RtlZeroMemory,EDI,128	;<-----Important
	Invoke LoadString,EBX,ESI,EDI,128
	RETN

	Load256Chars:
	Invoke LoadString,EBX,ECX,EDI,256
	RETN

	Load512Chars:
	Invoke RtlZeroMemory,EDI,512			;<-----Important
	Invoke LoadString,EBX,ESI,EDI,512
	RETN

LoadUI EndP

AddInterfacePackItem Proc Uses ESI EBX lpFileName:DWORD

	Invoke GetMenuItemCount,WinAsmHandles.PopUpMenus.hInterfacePacks
	MOV ESI,EAX
	ADD ESI,30101
	MOV MaxInterfacePackMenuID,ESI
	MOV ECX,MAX_PATH+1
	MUL ECX
	
	MOV EBX,lpInterfacePacks
	ADD EBX,EAX
	Invoke lstrcpy,EBX,lpFileName
	
	;-------------------
	;Remove the .dll part-->nicer!
	Invoke lstrlen,EBX
	LEA EDX,[EBX+EAX-4]
	MOV BYTE PTR [EDX],0
	;-------------------
	Invoke lstrcmpi,EBX,Offset szInterfacePack
	MOV EDX,MF_OWNERDRAW
	.If !EAX
		OR EDX,MF_CHECKED
	.EndIf
	Invoke AppendMenu, WinAsmHandles.PopUpMenus.hInterfacePacks,EDX,ESI,EBX
	RET
AddInterfacePackItem EndP

CountInterfacePackDLLs Proc dwReserved:DWORD
	INC dwGlobalCounter
	RET
CountInterfacePackDLLs EndP

EnumDllsInFolder Proc lpProcedure:DWORD, lpFolderDLLs:DWORD
Local FindData	:WIN32_FIND_DATA
Local hFindFile	:DWORD
Local Buffer[MAX_PATH]:BYTE

	Invoke lstrcpy,ADDR Buffer, Offset szAppFilePath
	Invoke lstrcat,ADDR Buffer, lpFolderDLLs

	Invoke FindFirstFile,ADDR Buffer, ADDR FindData
	.If EAX != INVALID_HANDLE_VALUE
    	MOV hFindFile, EAX
		.If !(FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			LEA EAX,FindData.cFileName
			PUSH EAX
			CALL lpProcedure
		.EndIf
		
		@@:
		Invoke FindNextFile, hFindFile, ADDR FindData
		.If EAX!=0
			.If EAX!= INVALID_HANDLE_VALUE
				.If !(FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
					LEA EAX,FindData.cFileName
					PUSH EAX
					CALL lpProcedure
				.EndIf		
			.EndIf
			JMP @B
		.EndIf
		
		Invoke FindClose, hFindFile
	.EndIf
	RET
EnumDllsInFolder EndP

GetPointerToManagedControl Proc Uses EBX lpControlClass:DWORD
	MOV EBX,lpCustomControls
	
	@@:
	LEA ECX,[EBX].CUSTOMCONTROL.szClassName
	.If BYTE PTR [ECX]
		Invoke lstrcmpi,ECX,lpControlClass
		.If !EAX
			MOV EAX,EBX
			RET
		.Else
			ADD EBX,SizeOf CUSTOMCONTROLEX

			JMP @B
		.EndIf
	.EndIf
	XOR EAX,EAX
	RET
GetPointerToManagedControl EndP

GetLineLength Proc Uses EBX hCodeHi:HWND, nLine:DWORD

	Invoke GetWindowLong,hCodeHi,0
	MOV EBX,EAX
	MOV		EDX,nLine
	SHL		EDX,2
	ADD		EDX,[EBX].EDIT.hLine
	MOV		EDX,[EDX].LINE.rpChars
	ADD		EDX,[EBX].EDIT.hChars
	MOV		EAX,[EDX].CHARS.len
	.If EAX
		.If byte ptr [EDX+EAX+SizeOf CHARS-1]==0Dh
			dec		EAX
		.EndIf
	.EndIf
	RET
GetLineLength EndP

IsAnyIntellisenseListVisible Proc
	Invoke IsWindowVisible,hListProcedures
	.If !EAX
		Invoke IsWindowVisible,hListStructures
		.If !EAX
			Invoke IsWindowVisible,hListConstants
			.If !EAX
				Invoke IsWindowVisible,hListStructureMembers
				.If !EAX
					Invoke IsWindowVisible,hListVariables
					.If !EAX
						Invoke IsWindowVisible,hListIncludes
						.If EAX
							MOV EAX,hListIncludes
						.EndIf
					.Else
						MOV EAX,hListVariables
					.EndIf
				.Else
					MOV EAX,hListStructureMembers
				.EndIf
			.Else
				MOV EAX,hListConstants
			.EndIf
		.Else
			MOV EAX,hListStructures
		.EndIf
	.Else
		MOV EAX,hListProcedures
	.EndIf

	RET
IsAnyIntellisenseListVisible EndP

HandleDropDownButton Proc Uses EBX lpnmtb:DWORD
Local Rect:RECT

	Invoke CreatePopupMenu
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_OPENPROJECT,Offset szOpenProject
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_OPENFILES,Offset szOpenFiles
	Invoke SendMessage,hMainTB,TB_GETITEMRECT,1,ADDR Rect
	Invoke MapWindowPoints,hMainTB,NULL,ADDR Rect,2
	Invoke TrackPopupMenu,EBX,TPM_LEFTALIGN or TPM_RIGHTBUTTON or TPM_RETURNCMD,Rect.left,Rect.bottom,0,WinAsmHandles.hMain,0
	PUSH EAX
	.If EAX==IDM_OPENFILES
		Invoke SendMessage,hMainTB,TB_SETCMDID,1,IDM_OPENFILES
		Invoke SendMessage,hMainTB,TB_CHANGEBITMAP,IDM_OPENFILES,42
	.ElseIf EAX==IDM_OPENPROJECT
		Invoke SendMessage,hMainTB,TB_SETCMDID,1,IDM_OPENPROJECT
		Invoke SendMessage,hMainTB,TB_CHANGEBITMAP,IDM_OPENPROJECT,1
	.Else
		POP EAX	;Balnce the stack
		JMP Ex
	.EndIf
	Invoke InvalidateRect,hMainTB,NULL,TRUE
	POP EAX
	Invoke SendMessage,WinAsmHandles.hMain,WM_COMMAND,EAX,0

	Ex:
	Invoke DestroyMenu,EBX
	RET
HandleDropDownButton EndP


SetAsModule Proc Uses EBX EDI hMDIChild:DWORD
Local tvinsert:TV_INSERTSTRUCT
Local Buffer[MAX_PATH+1]:BYTE

	Invoke GetWindowLong,hMDIChild,0
	MOV EBX,EAX
	Invoke SendMessage, WinAsmHandles.hProjTree, TVM_GETNEXTITEM, TVGN_PARENT,CHILDWINDOWDATA.hTreeItem[EBX]
	;Now EAX is the parent of the current item
	MOV EDI, EAX
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_DELETEITEM,0,CHILDWINDOWDATA.hTreeItem[EBX]
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_CHILD,EDI
	.If !EAX	;If there are no childs left
		Invoke SendMessage,WinAsmHandles.hProjTree,TVM_DELETEITEM,0,EDI
		.If EDI==hASMFilesItem
			MOV hASMFilesItem,0
			;Invoke EnableMenuItem,hMenu,IDM_MAKE_ASSEMBLE,MF_GRAYED
			;Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_ASSEMBLE,0
		.ElseIf EDI==hModulesItem
			MOV hModulesItem,0
		.EndIf
	.EndIf
	
	MOV tvinsert.item._mask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE
	PUSH hParentItem
	POP tvinsert.hParent
	MOV tvinsert.hInsertAfter,TVI_LAST
	MOV tvinsert.item.iImage,45
	MOV tvinsert.item.iSelectedImage,45
	MOV tvinsert.item.cchTextMax,256
	
	.If [EBX].CHILDWINDOWDATA.dwTypeOfFile==1	;i.e. it is not module
		MOV [EBX].CHILDWINDOWDATA.dwTypeOfFile,51
		.If hModulesItem==0
			MOV tvinsert.item.pszText,Offset szModules
			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
			MOV hModulesItem, EAX
		.EndIf
		MOV tvinsert.item.iImage,47
		MOV tvinsert.item.iSelectedImage,47
		MOV EDI,hModulesItem
	.Else	;i.e. it is a module
		MOV [EBX].CHILDWINDOWDATA.dwTypeOfFile,1
		.If hASMFilesItem==0
			MOV tvinsert.item.pszText,Offset szASMFiles
			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
			MOV hASMFilesItem, EAX
		.EndIf
		MOV tvinsert.item.iImage,26
		MOV tvinsert.item.iSelectedImage,26
		MOV EDI,hASMFilesItem
		;Invoke EnableMenuItem,hMenu,IDM_MAKE_ASSEMBLE,MF_ENABLED
		;Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_ASSEMBLE,TBSTATE_ENABLED
	.EndIf

	Invoke ImageList_GetIcon,hImlNormal,tvinsert.item.iImage,ILD_NORMAL
	Invoke SendMessage,hMDIChild,WM_SETICON,ICON_BIG,EAX
	Invoke DrawMenuBar,WinAsmHandles.hMain

	MOV tvinsert.item._mask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE+TVIF_PARAM
	MOV tvinsert.hParent,EDI
	Invoke GetFilesTitle,ADDR CHILDWINDOWDATA.szFileName[EBX], ADDR Buffer
	LEA EAX, Buffer
	MOV tvinsert.item.pszText,EAX
	MOV tvinsert.item.cchTextMax,256
	M2M tvinsert.item.lParam, hMDIChild
	MOV tvinsert.hInsertAfter,TVI_LAST
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0, ADDR tvinsert
	MOV CHILDWINDOWDATA.hTreeItem[EBX],EAX
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_EXPAND,TVE_EXPAND,EDI
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_CARET,CHILDWINDOWDATA.hTreeItem[EBX]

	MOV ProjectModified,TRUE
	RET
SetAsModule EndP

DeleteObjReslstExpFiles Proc Uses EDI
Local Buffer[MAX_PATH]:BYTE

	MOV EDI,Offset ProjectPath
	Invoke DeleteFiles, EDI, Offset szAllObj
	Invoke DeleteFiles, EDI, Offset szAllRes
	;Invoke DeleteFiles, EDI, Offset szALLlst

	.If ActiveBuild==0	;i.e. Release build
		MOV EDX,Offset szReleaseOutCommand
	.Else
		MOV EDX,Offset szDebugOutCommand
	.EndIf

	.If BYTE PTR [EDX]!=0
		Invoke GetFilePath,EDX,ADDR Buffer
		.If Buffer[0]!=0
			LEA EDI,Buffer			
		.EndIf
	.EndIf

	Invoke DeleteFiles, EDI, Offset szAllExp

	RET
DeleteObjReslstExpFiles EndP

ReplaceSlashWithBackSlash Proc lpString:DWORD
	MOV EAX,lpString
	.While BYTE PTR [EAX]!=0
		.If BYTE PTR [EAX]=="/"
			MOV BYTE PTR [EAX],"\"
		.EndIf
		INC EAX
	.EndW
	RET
ReplaceSlashWithBackSlash EndP

;Adds on more " if number of continuous "'s is odd.
MakeEvenNumberOfDoubleQuotes Proc Uses EBX lpSource:DWORD, lpDestination:DWORD
	MOV EAX,lpSource
	MOV EDX,lpDestination
	.While BYTE PTR [EAX]!=0
		XOR ECX,ECX
		.While BYTE PTR [EAX]!=0 && BYTE PTR [EAX]=='"'
			INC ECX
			INC EAX
		.EndW
		.If ECX
			MOV EBX,ECX
			AND ECX,1
			.If ECX	;i.e.odd
				INC EBX	;i.e. make it even by adding another one
			.EndIf
			.While EBX
				MOV BYTE PTR [EDX],'"'
				INC EDX
				DEC EBX
			.EndW
		.EndIf
		MOV CL,[EAX]
		MOV [EDX],CL
		INC EAX
		INC EDX
	.EndW
	MOV BYTE PTR [EDX],0
	RET
MakeEvenNumberOfDoubleQuotes EndP

TranformText Proc lpSource:DWORD, lpDestination:DWORD
	MOV EAX,lpSource
	MOV EDX,lpDestination
	.While BYTE PTR [EAX]!=0
		.If WORD PTR [EAX]=="t\"
			MOV BYTE PTR [EDX],"	"	;VK_TAB
			INC EAX
		.ElseIf WORD PTR [EAX]=="n\"
			MOV BYTE PTR [EDX],0Ah
			INC EAX
		.ElseIf WORD PTR [EAX]=="r\"
			MOV BYTE PTR [EDX],0Dh
			INC EAX
		.ElseIf WORD PTR [EAX]=="\\"
			MOV BYTE PTR [EDX],"\"
			INC EAX
		.ElseIf WORD PTR [EAX]=="a\"
			MOV BYTE PTR [EDX],7
			INC EAX
		.ElseIf WORD PTR [EAX]=='""'
			MOV BYTE PTR [EDX],'"'
			INC EAX
		.Else
			MOV CL,BYTE PTR [EAX]
			MOV BYTE PTR [EDX],CL
		.EndIf
		INC EAX
		INC EDX
	.EndW
	MOV BYTE PTR [EDX],0
	RET
TranformText EndP

SetTreeItemText Proc hTree:HWND, hTreeItem:DWORD, lpText:DWORD
Local tvi	:TVITEM
	MOV tvi._mask,TVIF_TEXT
	MOV tvi.cchTextMax,256
	MOV EAX,lpText

	MOV tvi.pszText,EAX
	PUSH hTreeItem
	POP tvi.hItem
	Invoke SendMessage,hTree,TVM_SETITEM,0,ADDR tvi
	RET
SetTreeItemText EndP

SetItemText Proc  hList:HWND, nItem:DWORD, nSubItem:DWORD, lpText:DWORD
Local lvi:LVITEM
	M2M lvi.iItem,nItem
	M2M lvi.iSubItem,nSubItem
	MOV lvi.imask, LVIF_TEXT
	MOV lvi.cchTextMax,256
	M2M lvi.pszText,lpText
	Invoke SendMessage,hList,LVM_SETITEM,0,ADDR lvi
	RET
SetItemText EndP

SaveDockingWindowProperties Proc Uses EDI EBX hDockWindow:DWORD, pDockData:DWORD, lpSectionName:DWORD
Local Buffer[12]:BYTE

	LEA EDI,Buffer


	MOV EBX,pDockData
	
	Invoke BinToDec,DOCKDATA.fDockedTo[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szDockedTo,EDI, Offset IniFileName

	Invoke BinToDec,DOCKDATA.NoDock.dLeft[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szNoDockLeft,EDI, Offset IniFileName

	Invoke BinToDec, DOCKDATA.NoDock.dTop[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szNoDockTop,EDI, Offset IniFileName

	Invoke BinToDec, DOCKDATA.NoDock.dWidth[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szNoDockWidth,EDI, Offset IniFileName

	Invoke BinToDec,DOCKDATA.NoDock.dHeight[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szNoDockHeight,EDI, Offset IniFileName

	Invoke BinToDec, DOCKDATA.DockTopHeight[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szDockTopHeight,EDI, Offset IniFileName

	Invoke BinToDec, DOCKDATA.DockBottomHeight[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szDockBottomHeight,EDI, Offset IniFileName

	Invoke BinToDec,DOCKDATA.DockLeftWidth[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szDockLeftWidth,EDI, Offset IniFileName

	Invoke BinToDec,DOCKDATA.DockRightWidth[EBX],EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szDockRightWidth,EDI, Offset IniFileName

	Invoke IsWindowVisible,hDockWindow
	Invoke BinToDec,EAX,EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szVisible,EDI, Offset IniFileName

	Invoke GetWindowLong,hDockWindow,GWL_STYLE
	AND EAX,0FFFFh
	Invoke BinToDec,EAX,EDI
	Invoke WritePrivateProfileString,lpSectionName, Offset szTitleStyle,EDI,Offset IniFileName

	RET
SaveDockingWindowProperties EndP

GetTreeItemParameter Proc hTreeView:HWND, hItem:DWORD
Local tvi	:TVITEM
	MOV tvi._mask,TVIF_PARAM
	M2M tvi.hItem,hItem
	Invoke SendMessage,hTreeView,TVM_GETITEM,0,ADDR tvi
	MOV EAX,tvi.lParam
	RET
GetTreeItemParameter EndP

;i.e. MACRO, STRUCTURE, PROCEDURE
SetAllBlocks Proc Uses ESI hWndEdit:DWORD
	MOV ESI,Offset Blocks
	MOV EDX,[ESI]
	.While EDX
		Invoke SendMessage,hWndEdit,CHM_SETBLOCKS,0,EDX
		ADD ESI,4
		MOV EDX,[ESI]
	.EndW
	RET
SetAllBlocks EndP

CalculateLineNrWidth Proc
Local hDC			:HDC
Local hPreviousFont	:DWORD
Local TextSize		:_SIZE

	Invoke GetDC,WinAsmHandles.hMain
	MOV hDC,EAX
	Invoke SelectObject,hDC,hLnrFont
	MOV hPreviousFont,EAX
	
	Invoke GetTextExtentPoint32,hDC,Offset sz99999,5,ADDR TextSize
	
	Invoke SelectObject, hDC,hPreviousFont
	Invoke ReleaseDC,WinAsmHandles.hMain,hDC
	
	MOV EAX,TextSize.x
	ADD EAX,3	;Just for more room
	RET
CalculateLineNrWidth EndP

CopyAllFromTo Proc lpFolder:DWORD,lpToFolder:DWORD
LOCAL sfo		:SHFILEOPSTRUCT
LOCAL sfoabort	:DWORD
	
	MOV EAX,WinAsmHandles.hMain
	MOV sfo.hwnd,EAX
	MOV sfo.wFunc,FO_COPY

	MOV EAX,lpFolder
	MOV sfo.pFrom,EAX
	MOV EAX,lpToFolder
	MOV sfo.pTo,EAX
	MOV sfo.fFlags,FOF_NOERRORUI or FOF_SILENT
	LEA EAX,sfoabort
	MOV sfo.fAnyOperationsAborted,EAX
	MOV sfo.hNameMappings,NULL
	MOV sfo.lpszProgressTitle,NULL
	
	Invoke SHFileOperation,ADDR sfo
	RET

CopyAllFromTo EndP

;Actually finds Bookmarks 1 or 2 (i.e. MACRO's, STRUCTURE's, or PROCEDURES)
ScrollToTop Proc Uses EBX EDI ESI lpData:DWORD,lpProcName:DWORD
Local ftxt		:FINDTEXTEX
Local LineNo	:DWORD

	MOV EBX,lpData
	Invoke lstrcmpi,lpProcName,Offset szSelectProcedureOrGoToTop
	.If EAX!=0
		MOV EAX,lpProcName
		MOV ftxt.lpstrText,EAX
		MOV ftxt.chrg.cpMin,0
		MOV ftxt.chrg.cpMax,-1	
		@@:
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_FINDTEXTEX,FR_MATCHCASE or FR_WHOLEWORD or FR_DOWN,ADDR ftxt
		.If EAX!=-1
			;Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_LINEFROMCHAR,ftxt.chrgText.cpMin,0
			Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXLINEFROMCHAR,0,ftxt.chrgText.cpMin
			MOV LineNo,EAX
			Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_GETBOOKMARK,EAX,0
			.If EAX==1 || EAX==2
				;Mark the text found.
				MOV EAX,ftxt.chrgText.cpMin
				MOV ftxt.chrgText.cpMax,EAX
				Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXSETSEL,0,ADDR ftxt.chrgText
				Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_VCENTER,0,0
				;Needed only if this procedure is called from ScrollToProcedure
				Invoke GetParent,[EBX].CHILDWINDOWDATA.hEditor
				Invoke SetWindowPos,EAX, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
				Invoke SetFocus,[EBX].CHILDWINDOWDATA.hEditor
			.Else
				MOV EAX,ftxt.chrgText.cpMin
				INC EAX
				MOV ftxt.chrg.cpMin,EAX
				JMP @B
			.EndIf
		;.Else	;DoNothing
		.EndIf
	.Else
		MOV ftxt.chrgText.cpMin,0
		MOV ftxt.chrgText.cpMax,0
		
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXSETSEL,0,ADDR ftxt.chrgText
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_VCENTER,0,0
		Invoke SetFocus,[EBX].CHILDWINDOWDATA.hEditor
	.EndIf
	RET
ScrollToTop EndP

;Actually finds Bookmarks 1 or 2 (i.e. MACRO's, STRUCTURE's, or PROCEDURES)
ScrollToBlock Proc Uses EBX hChild:DWORD
	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	.If CHILDWINDOWDATA.dwTypeOfFile[EBX]==1 || CHILDWINDOWDATA.dwTypeOfFile[EBX]==2 || CHILDWINDOWDATA.dwTypeOfFile[EBX]==51
		Invoke ScrollToTop,EBX,lpProcedureName
	.EndIf
	RET
ScrollToBlock EndP

;DoEvents Proc
;Local Msg:MSG
;	.While TRUE
;		Invoke PeekMessage,ADDR Msg,NULL,0,0,PM_REMOVE
;		.Break .If (!EAX)
;		Invoke TranslateMessage, ADDR Msg
;		Invoke DispatchMessage, ADDR Msg
;	.EndW
;	RET
;DoEvents EndP

GetFirstWordOfLine Proc lpLineText:DWORD
	
	MOV EDX,lpLineText
	DEC EDX
	
	@@:
	INC EDX
	MOV AL,[EDX]
	CMP AL,VK_SPACE
	JE @B
	CMP AL,VK_TAB
	JE @B
	
	
	MOV ECX,EDX
	DEC EDX
	@@:
	INC EDX
	MOV AL,[EDX]
	CMP AL,VK_SPACE
	JE @F
	CMP AL,VK_TAB
	JE @F
	OR AL,AL
	JNE @B
	
	@@:
	MOV BYTE PTR [EDX],0

	;Now ECX points first word of line
	MOV EAX,ECX
	RET
GetFirstWordOfLine EndP

GetSecondWordOfLine Proc lpLineText:DWORD
	
	MOV EDX,lpLineText
	
	DEC EDX
	@@:
	INC EDX
	;PrintDec EDX
	MOV AL,[EDX]
	CMP AL,VK_SPACE
	JE @B
	CMP AL,VK_TAB
	JE @B
	;    |Proc Hello2 hi
	
	DEC EDX
	@@:
	INC EDX
	;PrintDec EDX
	MOV AL,[EDX]
	;PrintDec AL
	CMP AL,VK_SPACE
	JE @F
	CMP AL,VK_TAB
	JNE @B
	;    Proc| Hello2 hi
	
	@@:
	DEC EDX
	@@:
	INC EDX
	MOV AL,[EDX]
	CMP AL,VK_SPACE
	JE @B
	CMP AL,VK_TAB
	JE @B
	;    Proc |Hello2 hi

	MOV ECX,EDX
	DEC EDX
	@@:
	INC EDX
	MOV AL,[EDX]
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	CMP AL,","
	JE @F
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	CMP AL,VK_SPACE
	JE @F
	CMP AL,VK_TAB
	JE @F
	OR AL,AL
	JNE @B
	
	@@:
	MOV BYTE PTR [EDX],0

	;Now ECX points to the second word of line
	MOV EAX,ECX
	RET
	
GetSecondWordOfLine EndP

HideAllLists Proc
   	Invoke ShowWindow,hListProcedures,SW_HIDE
   	PUSH EAX
	Invoke ShowWindow,hListStructures,SW_HIDE
   	PUSH EAX
	Invoke ShowWindow,hListConstants,SW_HIDE
   	PUSH EAX
	Invoke ShowWindow,hListStructureMembers,SW_HIDE
   	PUSH EAX
	Invoke ShowWindow,hListVariables,SW_HIDE
   	PUSH EAX
	Invoke ShowWindow,hListIncludes,SW_HIDE
	POP ECX
	OR EAX,ECX
	POP ECX
	OR EAX,ECX
	POP ECX
	OR EAX,ECX
	POP ECX
	OR EAX,ECX
	POP ECX
	OR EAX,ECX
	RET
HideAllLists EndP


SetToClipboard Proc
Local hMem  :DWORD
Local nSize :DWORD
	Invoke SendMessage,hOut,WM_GETTEXTLENGTH,0,0
	MOV nSize,EAX
	Invoke OpenClipboard,WinAsmHandles.hMain
	Invoke EmptyClipboard
	Invoke GlobalAlloc,GHND,nSize
	MOV hMem,EAX
	Invoke GlobalLock,EAX
	;EAX contents the pointer of buffer
	Invoke SendMessage,hOut,WM_GETTEXT,nSize,EAX
	Invoke GlobalUnlock,hMem
	Invoke SetClipboardData,CF_TEXT,hMem
	Invoke CloseClipboard
	RET
SetToClipboard EndP

SetMainWindowCaption Proc
	Invoke lstrcpy,Offset szAppCaption, Offset szAppName
	Invoke lstrcat,Offset szAppCaption,CTEXT(": ")
	Invoke lstrcat,Offset szAppCaption,	Offset ProjectTitle
	Invoke SetWindowText,WinAsmHandles.hMain,Offset szAppCaption
	RET
SetMainWindowCaption EndP

GetLineText Proc Uses ESI hEdit:DWORD,nLine:DWORD,lpLineText:DWORD
	MOV ESI,lpLineText
	MOV WORD PTR [ESI],16383;= Size - 1
	Invoke SendMessage,hEdit,EM_GETLINE,nLine,ESI
	;Returns in EAX Number Of characters copied
	
	;Zero terminate it
	MOV BYTE PTR [ESI+EAX],0
	RET
GetLineText EndP

;Returns 0 If we are not in a procedure or a pointer to the name of the procedure
InProcedure Proc Uses EBX hWin:DWORD,nLine:DWORD
Local fInProcedure:BOOLEAN

	MOV fInProcedure,FALSE
	Invoke SendMessage,hWin,CHM_ISLINE,nLine,Offset szEndp
	.If  EAX!=0 ;i.e this is a xxxxx EndP line
		.While TRUE;nLine>=1
			Invoke SendMessage,hWin,CHM_ISLINE, nLine, Offset szEndp
			.If  EAX==0
				.Break
			.EndIf
			
			NoEndP:
			Invoke SendMessage,hWin,CHM_ISLINE,nLine,Offset szProc
			.If EAX==0
				Invoke SendMessage,hWin,CHM_ISLINE,nLine,Offset szOption
				.If EAX!=0
					MOV fInProcedure,TRUE
					
					Invoke GetLineText,hWin,nLine,Offset tmpLineTxt
					
					.If szProc[0]=="$"
						Invoke GetFirstWordOfLine,Offset tmpLineTxt
					.Else
						Invoke GetSecondWordOfLine,Offset tmpLineTxt	
					.EndIf
					
					
;					LEA EDX,tmpLineTxt-1
;				@@:
;					INC EDX
;					MOV AL,[EDX]
;					CMP AL,VK_SPACE
;					JE @B
;					CMP AL,VK_TAB
;					JE @B
;					MOV EBX,EDX
;					DEC EDX
;				@@:
;					INC EDX
;					MOV AL,[EDX]
;					CMP AL,VK_SPACE
;					JE @F
;					CMP AL,VK_TAB
;					JE @F
;					OR AL,AL
;					JNE @B
;				@@:
;					MOV BYTE PTR [EDX],0

				
					;Now EBX Points to the Procedure Name
					MOV ECX,nLine ;ECX points to the line procedure starts
					.Break
				.EndIf
			.EndIf
			
			.If nLine!=0
				DEC nLine
			.Else
				.Break
			.EndIf
			
		.EndW
		
	.Else
		JMP NoEndP
	.EndIf
	
	.If !fInProcedure
		MOV EAX,FALSE
;	.Else
;		MOV EAX,EBX
	.EndIf
	RET
InProcedure EndP

;HideLineRange Proc Uses EBX EDI hActiveEditor:HWND,nStart:DWORD,nStop:DWORD
;	MOV EBX,nStop
;	MOV EDI,nStart
;	@@:
;	INC EDI
;	Invoke SendMessage,hActiveEditor,CHM_LOCKLINE,EDI,TRUE
;	Invoke SendMessage,hActiveEditor,CHM_HIDELINE,EDI,TRUE
;	.If EDI<EBX
;		JMP @B
;	.EndIf
;	RET
;HideLineRange EndP
;UnHideAllLines Proc Uses EBX EDI hActiveEditor:HWND
;
;	Invoke SendMessage,hActiveEditor,EM_GETLINECOUNT,0,0
;	MOV EBX,EAX
;	PUSH EBX
;	MOV EDI,-1
;	@@:
;	INC EDI
;	Invoke SendMessage,hActiveEditor,CHM_LOCKLINE,EDI,FALSE
;	Invoke SendMessage,hActiveEditor,CHM_HIDELINE,EDI,FALSE
;	.If EDI<EBX
;		JMP @B
;	.EndIf
;
;	POP EBX
;	MOV EDI,-1
;	@@:
;	INC EDI
;	Invoke SendMessage,hActiveEditor,CHM_GETBOOKMARK,EDI,0
;	.If EAX==2		;Collapse
;		Invoke SendMessage,hActiveEditor, CHM_COLLAPSE,EDI, Offset CHBDProc
;	.ElseIf EAX==1	;Expand
;		Invoke SendMessage,hActiveEditor, CHM_EXPAND,EDI, Offset CHBDProc
;	.EndIf
;	.If EDI<EBX
;		JMP @B
;	.EndIf
;	
;	RET
;UnHideAllLines EndP

AddRecentProjectsMenuItems Proc Uses EBX ESI EDI
Local szCounter[12]:BYTE
Local Buffer[256]:BYTE
Local MenuID:DWORD
	;Delete all items after "Print" submenu	
	.While TRUE
		Invoke DeleteMenu,WinAsmHandles.PopUpMenus.hFileMenu,MENUITEMAFTERPRINT,MF_BYPOSITION
		.Break .If !EAX
	.EndW
	
	;Insert New Items after Print
	XOR EBX,EBX


	MOV MenuID,10020
	LEA ESI,szRecentProjects
	SUB ESI,40
	@@:
	INC EBX
	INC MenuID
	ADD ESI,40	;Although menu items length is 32 bytes maximum, I use 40 just to have some extra space!
	Invoke BinToDec,EBX,ADDR szCounter
	Invoke GetPrivateProfileString,	Offset szRECENT, ADDR szCounter, ADDR szNULL, ADDR Buffer, 256, Offset IniFileName
	.If EAX!=0 && EBX<=6
		MOV BYTE PTR [ESI],"&"
		MOV BYTE PTR [ESI+1],0
		Invoke lstrcat,ESI,ADDR szCounter
		Invoke lstrcat,ESI,Offset szSpc
		.If EBX==1
			Invoke AppendMenu, WinAsmHandles.PopUpMenus.hFileMenu, MF_SEPARATOR,0,0
		.EndIf
		
		Invoke lstrlen,ADDR Buffer
		.If EAX >30
			LEA ECX,Buffer
			ADD ECX,EAX
			SUB ECX,24
			PUSH ECX
			
			LEA EDI,Buffer
			MOV BYTE PTR [EDI+3],0
			Invoke lstrcat,EDI,Offset szThreeDots	;"..."
			POP ECX
			Invoke lstrcat,EDI,ECX
		.Else
			LEA EDI,Buffer
		.EndIf
		Invoke lstrcat,ESI,EDI
		Invoke AppendMenu,WinAsmHandles.PopUpMenus.hFileMenu,MF_OWNERDRAW, MenuID, ESI
		JMP @B
	.EndIf
	.If EBX>1	;i.e. there is at least one recent project
		Invoke AppendMenu,WinAsmHandles.PopUpMenus.hFileMenu,MF_OWNERDRAW, 	IDM_RECENTPROJECTSMANAGER,Offset szRecentProjectsManager
	.EndIf
	Invoke AppendMenu, WinAsmHandles.PopUpMenus.hFileMenu, MF_SEPARATOR,0,0
	Invoke AppendMenu, WinAsmHandles.PopUpMenus.hFileMenu, MF_OWNERDRAW, IDM_EXIT,Offset szExit
	
	Invoke DrawMenuBar,hMenu
	RET
AddRecentProjectsMenuItems EndP

SaveToRecent Proc Uses EBX
Local Buffer[12]:BYTE
Local BufferExisting[256]:BYTE
Local BufferNew[256]:BYTE

	XOR EBX,EBX
	@@:
	INC EBX
	Invoke BinToDec,EBX,ADDR Buffer

	;Now in Buffer2 I have what should be in the next entry
	Invoke GetPrivateProfileString,	Offset szRECENT, ADDR Buffer, ADDR szNULL, ADDR BufferExisting, 256, Offset IniFileName
	.If EBX==1
		Invoke lstrcmpi,ADDR BufferExisting,Offset FullProjectName
		.If EAX==0	;i.e Current Project is already first-->Do Nothing
			JMP Done
		.EndIf
		Invoke WritePrivateProfileString, Offset szRECENT, ADDR Buffer, Offset FullProjectName, Offset IniFileName
	.Else
		Invoke lstrcmpi,ADDR BufferNew,Offset FullProjectName
		.If EAX==0
			JMP ArrangeMenu
		.EndIf
		Invoke WritePrivateProfileString, Offset szRECENT,ADDR Buffer,ADDR BufferNew, Offset IniFileName
	.EndIf
	.If BufferExisting[0]!=0
		Invoke lstrcpy,ADDR BufferNew,ADDR BufferExisting
		JMP @B
	.EndIf

	ArrangeMenu:
;	Invoke GetRecentProjects
	
	Done:
	RET
SaveToRecent EndP

LTrim Proc Source:DWORD,Dest:DWORD
	PUSH ESI
	PUSH EDI

	MOV ESI, Source
	MOV EDI, Dest
	CLD				;Read forward

	@@:
	LODSB
	CMP AL, 0		;Exit on zero
	JE Done
	CMP AL, 32		;Loop if space
	JE @B
	CMP AL, 9		;Loop if tab
	JE @B
	STOSB

	@@:
	LODSB
	CMP AL, 0		;Exit on zero
	JE Done
	STOSB
	JMP @B

Done:
	STOSB			;Write terminating zero

	POP EDI
	POP ESI
	RET
LTrim EndP

GetMenuItemData Proc hCurrentMenu:HMENU, wID:DWORD,fByPosition:DWORD
Local mii:MENUITEMINFO
	MOV mii.cbSize,SizeOf MENUITEMINFO
	MOV mii.fMask,MIIM_DATA
	Invoke GetMenuItemInfo,hCurrentMenu,wID,fByPosition,ADDR mii
	.If EAX
		MOV EAX, mii.dwItemData
	.EndIf
	RET
GetMenuItemData EndP

EnumOpenedExternalFiles Proc Uses EBX lpProcedure:DWORD
	MOV EBX,50000
	.While EBX <ExternalFilesMenuID
		INC EBX
		Invoke GetMenuItemData,WinAsmHandles.PopUpMenus.hWindowMenu,EBX,FALSE
		;Now EAX contains mii.dwItemData which is effectively the Window Handle
		.If EAX
			PUSH EAX
			CALL lpProcedure
		.EndIf
	.EndW
	RET
EnumOpenedExternalFiles EndP

EnumOpenedExternalFilesExtended Proc Uses EBX lpProcedure:DWORD, lParam:LPARAM
	MOV EBX,50000
	.While EBX <ExternalFilesMenuID
		INC EBX
		Invoke GetMenuItemData,WinAsmHandles.PopUpMenus.hWindowMenu,EBX,FALSE
		;Now EAX contains mii.dwItemData which is effectively the Window Handle
		.If EAX
			PUSH lParam
			PUSH EAX
			CALL lpProcedure
			.If !EAX	;i.e. If 0 is returned, stop enumeration
				RET 
			.EndIf
		.EndIf
	.EndW
	RET
EnumOpenedExternalFilesExtended EndP

IsThisFileAlreadyInTheProject Proc hChild:DWORD, lpFilenameToCheck:DWORD
	Invoke GetWindowLong,hChild,0
	MOV ECX,EAX
	Invoke lstrcmpi,ADDR CHILDWINDOWDATA.szFileName[ECX],lpFilenameToCheck
	.If !EAX	;-->Yes it is already in the project
		MOV bThisFileIsAlreadyInTheProject,TRUE
	.EndIf
	RET
IsThisFileAlreadyInTheProject EndP

EnumProjectItemsExtended Proc pProcedure:DWORD, lParam:DWORD
Local tvi:TVITEM

	.If hParentItem
		MOV tvi._mask,TVIF_PARAM
		MOV EAX,hParentItem
		MOV ECX,TVGN_CHILD
		
		More:
		Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,ECX,EAX
		.If EAX
			PUSH EAX
			
			;MoreParents:
			MOV ECX,TVGN_CHILD
			
			MoreChildren:
			
			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,ECX,EAX
			.If EAX
				PUSH EAX
				MOV tvi.hItem,EAX
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETITEM,0,ADDR tvi
				;tvi.lParam holds the handle of a child window
				PUSH lParam
				PUSH tvi.lParam
				CALL pProcedure
				.If !EAX	;i.e. If 0 is returned, stop enumeration
					POP ECX	;Just to balance the stack
					RET 
				.EndIf
				POP EAX
				MOV ECX,TVGN_NEXT
				JMP MoreChildren
			.EndIf
			
			POP EAX
			MOV ECX,TVGN_NEXT
			JMP More
		.EndIf
	.EndIf
	
	RET
EnumProjectItemsExtended EndP

HideMDIChild Proc hMDIChild:DWORD
	Invoke IsZoomed,hMDIChild
	.If EAX
		Invoke SendMessage,hClient,WM_MDIRESTORE,hMDIChild,NULL
	.EndIf
	Invoke ShowWindow,hMDIChild,SW_HIDE
	RET
HideMDIChild EndP

EnumProjectItems Proc pProcedure:DWORD
Local tvi:TVITEM

	.If hParentItem
		MOV tvi._mask,TVIF_PARAM
		MOV EAX,hParentItem
		MOV ECX,TVGN_CHILD
		
		More:
		Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,ECX,EAX
		.If EAX
			PUSH EAX
			
			;MoreParents:
			MOV ECX,TVGN_CHILD
			
			MoreChildren:
			;------------
			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,ECX,EAX
			.If EAX
				PUSH EAX
				MOV tvi.hItem,EAX
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETITEM,0,ADDR tvi
				
				;tvi.lParam holds the handle of a child window
				PUSH tvi.lParam
				CALL pProcedure
				
				POP EAX
				MOV ECX,TVGN_NEXT
				JMP MoreChildren
			.EndIf
			
			POP EAX
			MOV ECX,TVGN_NEXT
			JMP More
		.EndIf
	.EndIf
	RET
EnumProjectItems EndP

DeleteAllItemsByImage Proc Uses EDI EBX hList:DWORD, nImage:DWORD
Local lvi:LVITEM

	MOV EBX,nImage
	MOV lvi.imask, LVIF_IMAGE
	MOV lvi.iSubItem, 0
	XOR EDI,EDI
	
	@@:
	MOV lvi.iItem,EDI
	Invoke SendMessage,hList,LVM_GETITEM,0,ADDR lvi
	.If EAX
		.If lvi.iImage==EBX
			Invoke SendMessage,hList,LVM_DELETEITEM,EDI,0
			JMP @B
		.Else
			INC EDI
			JMP @B
		.EndIf
   .EndIf

	RET
DeleteAllItemsByImage EndP

AddToolsSubMenus Proc Uses EBX ESI EDI
Local szCounter[256]	:BYTE
Local Buffer[288]		:BYTE	;256+32
Local MenuID			:DWORD

	XOR EBX,EBX
	MOV MenuID,30000
	LEA ESI,szTools
	SUB ESI,40
	@@:
	INC EBX
	INC MenuID
	ADD ESI,40
	Invoke BinToDec,EBX,ADDR szCounter

	Invoke GetPrivateProfileString, Offset szTOOLS, ADDR szCounter, ADDR szNULL, ADDR Buffer, 288, Offset IniFileName
	.If EAX!=0 && EBX<=20
		.If EBX==1
			Invoke AppendMenu,WinAsmHandles.PopUpMenus.hToolsMenu, MF_SEPARATOR,0,0
		.EndIf
		
		LEA EDI,Buffer
		.If BYTE PTR [EDI]=="-"
			Invoke AppendMenu, WinAsmHandles.PopUpMenus.hToolsMenu, MF_SEPARATOR,0,0
			JMP @B
		.EndIf
		.While BYTE PTR [EDI]!=0
			.If BYTE PTR [EDI]==","
				MOV BYTE PTR [EDI],0
				Invoke lstrcpy,ESI,ADDR Buffer
				Invoke AppendMenu, WinAsmHandles.PopUpMenus.hToolsMenu, MF_OWNERDRAW, MenuID, ESI
				.Break
			.EndIf
			INC EDI
		.EndW
		JMP @B
	.EndIf

	Invoke DrawMenuBar,WinAsmHandles.hMain

	RET
AddToolsSubMenus EndP

;IntMul Proc Source:DWORD,Multiplier:DWORD
;Local tmpVar:DWORD
;	FILD Source         ;Load source
;	FILD Multiplier     ;Load multiplier
;	FMUL                ;Multiply source by multiplier
;	FISTP tmpVar        ;Store result in variable
;	MOV EAX, tmpVar
;	RET
;IntMul EndP

GetItemText Proc hList:HWND, nItem:DWORD, nSubItem:DWORD, lpBuffer:DWORD
Local lvi:LVITEM
	M2M lvi.iItem,nItem
	M2M lvi.iSubItem,nSubItem
	MOV lvi.imask, LVIF_TEXT
	MOV lvi.cchTextMax,256
	M2M lvi.pszText,lpBuffer
	Invoke SendMessage,hList,LVM_GETITEM,0,ADDR lvi
	RET
GetItemText EndP

IsThisABlockName Proc lpText:DWORD
Local lvfi			:LV_FINDINFO
Local Buffer[256]	:BYTE
	PUSH ESI
	MOV ESI,lpText
	.If BYTE PTR [ESI]!=0
		Invoke RtlZeroMemory,ADDR lvfi,SizeOf LV_FINDINFO
		MOV lvfi.flags,LVFI_STRING; or LVFI_PARTIAL 
		MOV lvfi.psz,ESI
		Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_FINDITEM,-1,ADDR lvfi
		.If EAX!=-1 ;i.e if there is such text in the list
			MOV EDI,EAX
			Invoke GetItemText, WinAsmHandles.hBlocksList, EDI, 0, ADDR Buffer
			Invoke lstrlen,ESI
			MOV Buffer[EAX],0
			Invoke lstrcmp,ESI,ADDR Buffer
			;.If EAX==0	-----> THIS IS A BLOCK NAME
		.EndIf
	.Else
		MOV EAX,-1
	.EndIf
	
	POP ESI
	RET
IsThisABlockName EndP

;Returns height of List
GetProperColumnWidth Proc Uses EBX
	MOV EBX,250

	Invoke GetSystemMetrics,SM_CXDLGFRAME;SM_CYBORDER
	SHL EAX,1
	SUB EBX,EAX
	Invoke GetSystemMetrics,SM_CXVSCROLL
	SUB EBX,EAX
	MOV EAX,EBX
	RET
GetProperColumnWidth EndP

ShowListAutoPosAndHeight Proc Uses EBX hList:DWORD
Local chrg:CHARRANGE
Local PosToShow:POINT
Local rcWorkArea:RECT

	;Needed so that line after next selects properly.
	Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
	Invoke SendMessage,hEditor,EM_POSFROMCHAR,ADDR PosToShow,chrg.cpMin

	Invoke GetWindowLong,hEditor,0
	;MOV ESI,EAX
	
	LEA EDX,PosToShow
	PUSH EDX
	PUSH [EAX].EDIT.focus
	CALL ClientToScreen
	;Invoke ClientToScreen,[EAX].EDIT.focus,ADDR PosToShow
	ADD PosToShow.x,6

	MOV rcWorkArea.left,LVIR_BOUNDS	
	Invoke SendMessage,hList,LVM_GETITEMRECT,0,ADDR rcWorkArea
	MOV EBX,rcWorkArea.bottom
	SUB EBX,rcWorkArea.top
	
	Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
	.If EAX
		MUL EBX
		.If EAX>160
			MOV EAX,160
		.EndIf
		MOV EBX,EAX
		Invoke GetSystemMetrics,SM_CXDLGFRAME
		SHL EAX,1
		ADD EBX,EAX
		
		Invoke SystemParametersInfo,SPI_GETWORKAREA,0,ADDR rcWorkArea,0
		
		Invoke GetWindowLong,hEditor,0
		MOV EDX,[EAX].EDIT.fntinfo.fntht
		ADD EDX,PosToShow.y
		
		
		MOV EAX,EDX
		ADD EAX,EBX;160
		.If EAX> rcWorkArea.bottom
			MOV ECX,rcWorkArea.bottom
			SUB ECX,EDX
		.Else
			MOV ECX,EBX;160
		.EndIf
		Invoke MoveWindow,hList,PosToShow.x,EDX,250,ECX,TRUE
	
		Invoke ShowWindow,hList,SW_SHOWNA
	.EndIf
	RET
ShowListAutoPosAndHeight EndP

SelectListItem Proc hList:HWND,nItem:DWORD
Local lvi:LVITEM

	MOV lvi.imask, LVIF_STATE
	MOV lvi.iSubItem,0
	MOV lvi.stateMask, LVIS_FOCUSED OR LVIS_SELECTED
	MOV EAX,nItem
	.If EAX==-1
		Invoke SendMessage,hList,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_FOCUSED OR LVNI_SELECTED
		.If EAX!=-1
			MOV lvi.state,0
		.Else
			RET
		.EndIf
	.Else
		MOV lvi.state,LVIS_FOCUSED OR LVIS_SELECTED
	.EndIf
	MOV lvi.iItem, EAX
	Invoke SendMessage,hList,LVM_SETITEM ,0,ADDR lvi
	
	RET
SelectListItem EndP

ScrollListItemToTop Proc hList:HWND,nItem:DWORD
Local Rect:RECT
	.If nItem==-1
		PUSH 0
	.Else
		MOV Rect.left,LVIR_BOUNDS
		Invoke SendMessage,hList,LVM_GETITEMRECT,nItem,ADDR Rect
		PUSH Rect.top
	.EndIf
	
	MOV Rect.left,LVIR_BOUNDS
	Invoke SendMessage,hList,LVM_GETTOPINDEX,0,0
	LEA EDX,Rect
	PUSH EDX
	PUSH EAX
	PUSH LVM_GETITEMRECT
	PUSH hList
	CALL SendMessage
	
	POP EDX
	SUB EDX,Rect.top
	
	Invoke SendMessage,hList,LVM_SCROLL,0,EDX
	Invoke UpdateWindow,hList
	RET
ScrollListItemToTop EndP

TrimComment Proc lpText:DWORD
	MOV EAX,lpText
	.While BYTE PTR [EAX]!=0
		.If BYTE PTR [EAX]==";"
			MOV BYTE PTR [EAX],0
		.EndIf
		INC EAX
	.EndW
	RET
TrimComment EndP

CreateEmptyList Proc
Local lvc:LV_COLUMN
Local hList:HWND

	Invoke CreateWindowEx,NULL,Offset szListViewClass,NULL, WS_DLGFRAME OR WS_POPUP OR LVS_REPORT OR LVS_SINGLESEL OR LVS_NOCOLUMNHEADER OR LVS_SORTASCENDING OR LVS_SHOWSELALWAYS,0, 0, 0, 0,WinAsmHandles.hMain,NULL,hInstance,0
	MOV hList, EAX
	MOV lvc.imask, LVCF_WIDTH;LVCF_TEXT or
	
	Invoke GetProperColumnWidth
	MOV lvc.lx, EAX;200
	Invoke SendMessage, hList, LVM_INSERTCOLUMN, 0, ADDR lvc

	MOV lvc.lx, 0
	Invoke SendMessage, hList, LVM_INSERTCOLUMN, 1, ADDR lvc
	
	MOV EAX, LVS_EX_FULLROWSELECT OR LVS_EX_LABELTIP
	Invoke SendMessage, hList, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX
	Invoke SendMessage, hList, LVM_SETIMAGELIST, LVSIL_SMALL, hListAPIImageList
	;Apply the same font to the Procedure pop up list
	Invoke SendMessage,hList,WM_SETFONT,hFont,FALSE
	MOV EAX,hList
	RET
CreateEmptyList EndP

FillConstantsList Proc Uses EBX ESI EDI lpText:DWORD
Local lvi:LVITEM

	Invoke SendMessage,hListConstants,LVM_DELETEALLITEMS,0,0
	MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE; OR LVIF_STATE
	MOV lvi.iImage,2
	MOV lvi.iSubItem, 0
	
	MOV ESI,lpText
	;PrintStringByAddr ESI
	MOV EDI,ESI
	XOR EBX,EBX
	
	.While BYTE PTR [ESI]!=0
		.If BYTE PTR [ESI]=="="
			MOV EDI,ESI
			INC EDI
		.ElseIf BYTE PTR [ESI]==" "
			MOV BYTE PTR [ESI],0
			
			;EDI is the lvi.pszText
			MOV lvi.iItem,EBX
			MOV lvi.pszText,EDI
			Invoke SendMessage,hListConstants,LVM_INSERTITEM,0,ADDR lvi
			MOV EBX,EAX
			MOV BYTE PTR [ESI]," "
			MOV EDI,ESI
			INC EDI
		.EndIf
		INC ESI
	.EndW
	MOV lvi.iItem,EBX
	MOV lvi.pszText,EDI
	Invoke SendMessage,hListConstants,LVM_INSERTITEM,0,ADDR lvi
	RET
FillConstantsList EndP

IsParameterAPIConstant Proc Uses EBX EDI lpParam:DWORD
Local Buffer[256]:BYTE

	MOV EBX,pLinkedList
	.If EBX!=0
		@@:
		MOV EDI,APICONSTANTS.pText[EBX]
		.While BYTE PTR [EDI]!=0
			.If BYTE PTR [EDI]== "="
				MOV BYTE PTR [EDI],0
				Invoke lstrcpy, ADDR Buffer,APICONSTANTS.pText[EBX]
				MOV BYTE PTR [EDI],"="
				.Break
			.EndIf
			INC EDI
		.EndW
		
		.If APICONSTANTS.pNext[EBX]!=0 ;This is NOT last Entry
			Invoke lstrcmpi,lpParam,ADDR Buffer
			.If EAX==0 ;i.e This parameter refers to an API Constant
				MOV EAX,APICONSTANTS.pText[EBX]
			.Else
				MOV EBX, APICONSTANTS.pNext[EBX]
				JMP @B
			.EndIf
		.Else
			Invoke lstrcmpi,lpParam,ADDR Buffer
			.If EAX==0 ;i.e This parameter refers to an API Constant
				MOV EAX,APICONSTANTS.pText[EBX]
			.Else
				MOV EAX,FALSE
			.EndIf
		.EndIf
	.Else
		MOV EAX,FALSE
	.EndIf
	RET
IsParameterAPIConstant EndP

FreeLinkedList Proc Uses EBX EDI
	MOV EBX,pLinkedList
	.If EBX!=0
		@@:
		.If APICONSTANTS.pNext[EBX]!=0
			MOV EDI, APICONSTANTS.pNext[EBX]
		.Else
			XOR EDI,EDI
		.EndIf
		Invoke HeapFree,hMainHeap,0,EBX
		.If EDI!=0
			MOV EBX, EDI
			JMP @B
		.EndIf
	.EndIf
	RET
FreeLinkedList EndP

GetAPIConstants Proc Uses EBX EDI ESI
Local FileSize			:DWORD
Local NumberOfBytesRead	:DWORD
Local hFile				:DWORD
Local pStartOfKeyWord	:DWORD
Local pPrevious			:DWORD

	Invoke HeapFree,hMainHeap,0,pAPIConstantsBlock
	Invoke FreeLinkedList
	MOV pLinkedList,0

	Invoke HeapFree,hMainHeap,0,lpAPIConstants
	MOV lpAPIConstants,0
	
	Invoke CreateFile,pAPIConstantsFile,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.If EAX!=INVALID_HANDLE_VALUE
		MOV hFile,EAX
		Invoke GetFileSize,hFile,NULL
		INC EAX				;we need one more extra BYTE for last constant if there is no enter at the end
		MOV FileSize, EAX
		
		SHL EAX,1	;lpAPIConstants may need up to twice the file size (very extreme case)
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,EAX
		MOV lpAPIConstants,EAX
		MOV EBX,EAX
		
		Invoke HeapAlloc,hMainHeap,0,FileSize
		MOV pAPIConstantsBlock,EAX
		DEC FileSize
		
		Invoke ReadFile,hFile,pAPIConstantsBlock,FileSize, ADDR NumberOfBytesRead,NULL
		MOV EDI,pAPIConstantsBlock
		MOV ECX,EDI	;ECX will hold the start of line
		DEC EDI
		
		NextLine:
		INC EDI
		.If BYTE PTR [EDI]=="="
			MOV ESI,EDI
			
			NextConstant:
			INC EDI
			.If BYTE PTR [EDI]==0Dh
				MOV BYTE PTR [EDI],0
				MOV WORD PTr [EBX],"^ "
				INC EBX
				
				NewChar1:
				INC EBX
				INC ESI
				.If ESI==EDI
					JMP MakeList
				.EndIf
				MOV AL,BYTE PTR [ESI]
				MOV BYTE PTR [EBX],AL 
				JMP NewChar1
				
				MakeList:
				MOV ESI,ECX
				Invoke HeapAlloc, hMainHeap,HEAP_ZERO_MEMORY, SizeOf APICONSTANTS
				.If pLinkedList==0
					MOV pLinkedList,EAX
					MOV pPrevious,EAX
					MOV APICONSTANTS.pText[EAX],ESI
				.Else
					MOV APICONSTANTS.pText[EAX],ESI
					MOV EDX,pPrevious
					MOV APICONSTANTS.pNext[EDX],EAX
					MOV pPrevious,EAX
				.EndIf
				
				INC EDI
				MOV ECX,EDI
				INC ECX
				JMP NextLine
			.EndIf
			
			.If BYTE PTR [EDI]==","
				MOV BYTE PTR [EDI]," "
				MOV WORD PTr [EBX],"^ "
				INC EBX
				NewChar:
				INC EBX
				INC ESI
				.If ESI==EDI
					JMP NextConstant
				.EndIf
				MOV AL,BYTE PTR [ESI]
				MOV BYTE PTR [EBX],AL 
				JMP NewChar
			.EndIf
			.If BYTE PTR [EDI]==0
				JMP Done
			.Else
				JMP NextConstant
			.EndIf
		.EndIf
		.If BYTE PTR [EDI]==0
			JMP Done
		.EndIf
		JMP NextLine
		
		Done:
		Invoke CloseHandle,hFile
	.EndIf
	RET
GetAPIConstants EndP

GetAPIStructures Proc Uses EBX EDI ESI
Local lvi:LVITEM
Local FileSize:DWORD
Local lpBlock:DWORD
Local NumberOfBytesRead:DWORD
Local hFile:DWORD

	Invoke SendMessage,hListStructures,LVM_DELETEALLITEMS,0,0
	MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE; OR LVIF_STATE

	Invoke HeapFree,hMainHeap,0,lpAPIStructures
	MOV lpAPIStructures,0
   	Invoke CreateFile,pAPIStructuresFile,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.If EAX!=INVALID_HANDLE_VALUE
		MOV hFile,EAX
		Invoke GetFileSize,hFile,NULL
		MOV FileSize,EAX
		INC FileSize	;Because I may passover ???
		
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,FileSize;204800;4096;1024
		MOV lpAPIStructures,EAX
		MOV EBX,EAX	;EBX will hold current position that a new char will be
					;inserted in lpAPIStructures
		
		Invoke HeapAlloc,hMainHeap,0,FileSize
		;Now EAX holds a pointer to the memory block allocated
		MOV lpBlock,EAX
		Invoke ReadFile,hFile,lpBlock,FileSize,ADDR NumberOfBytesRead,NULL
		MOV EDI,lpBlock		
		MOV ECX,EDI	;ECX will hold the start of line
		XOR ESI,ESI	;ESI will hold the Comma position
		DEC EDI
		
		@@:
		INC EDI
		.If BYTE PTR [EDI]==0Dh
			MOV BYTE PTR [EDI],0
			.If ESI
				MOV BYTE PTR [ESI],0
			   	MOV lvi.iImage,1
			.Else
			   	MOV lvi.iImage,3	;This is a variable
			.EndIf
			
			MOV EDX,ECX
			MOV WORD PTR [EBX],"^ "
			INC EBX
			NewChar:
			INC EBX
			MOV AL,BYTE PTR [ECX]
			.If AL!=0			
				MOV BYTE PTR [EBX],AL
				INC ECX
				JMP NewChar
			.EndIf
			
			MOV lvi.iItem,0
			MOV lvi.pszText,EDX
			MOV lvi.iSubItem,0
			Invoke SendMessage,hListStructures,LVM_INSERTITEM,0,ADDR lvi
			.If ESI
				MOV lvi.iItem,EAX
				MOV BYTE PTR [ESI],","
				MOV lvi.pszText,ESI
				MOV lvi.iSubItem,1
				Invoke SendMessage,hListStructures,LVM_SETITEM,0,ADDR lvi
			.EndIf
			
			XOR ESI,ESI
			INC EDI
			MOV ECX,EDI
			INC ECX
			JMP @B
		.EndIf
		
		.If ESI
		.Else
		 	.If BYTE PTR [EDI]==","
				MOV ESI,EDI
				JMP @B
			.EndIf
		.EndIf
		
		.If BYTE PTR [EDI]==0
			JMP Done
		.EndIf
		JMP @B
		
		Done:
		Invoke HeapFree,hMainHeap,0,lpBlock
		Invoke CloseHandle,hFile
	.EndIf
	RET
GetAPIStructures EndP

GetAPIFunctions Proc Uses EBX EDI ESI
Local lvi:LVITEM
Local FileSize:DWORD
Local lpBlock:DWORD
Local NumberOfBytesRead:DWORD
Local hFile:DWORD

	Invoke SendMessage,hListProcedures,LVM_DELETEALLITEMS,0,0
	MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE; OR LVIF_STATE
   	MOV lvi.iImage,1

	Invoke HeapFree,hMainHeap,0,lpAPIFunctions
	MOV lpAPIFunctions,0
	
   	Invoke CreateFile,pAPIFunctionsFile,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.If EAX!=INVALID_HANDLE_VALUE
		MOV hFile,EAX
		Invoke GetFileSize,hFile,NULL
		MOV FileSize,EAX
		INC FileSize	;Because I may passover if last function has no parameters
		
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,FileSize;204800;4096;1024
		MOV lpAPIFunctions,EAX
		MOV EBX,EAX	;EBX will hold current position that a new char will be
					;inserted in lpAPIFunctions
		
		Invoke HeapAlloc,hMainHeap,0,FileSize
		;Now EAX holds a pointer to the memory block allocated
		
		MOV lpBlock,EAX
		Invoke ReadFile,hFile,lpBlock,FileSize,ADDR NumberOfBytesRead,NULL
		MOV EDI,lpBlock		
		MOV ECX,EDI	;ECX will hold the start of line
		XOR ESI,ESI	;ESI will hold the Comma position
		DEC EDI
		
		@@:
		INC EDI
		.If BYTE PTR [EDI]==0Dh
			MOV BYTE PTR [EDI],0
			.If ESI
				MOV BYTE PTR [ESI],0
			.EndIf
			
			MOV EDX,ECX
			MOV WORD PTR [EBX],"^ "
			INC EBX
			NewChar:
			INC EBX
			MOV AL,BYTE PTR [ECX]
			.If AL!=0
				MOV BYTE PTR [EBX],AL
				INC ECX
				JMP NewChar
			.EndIf
			
			MOV lvi.iItem,0
			MOV lvi.pszText,EDX
			MOV lvi.iSubItem,0
			Invoke SendMessage,hListProcedures,LVM_INSERTITEM,0,ADDR lvi

			.If ESI
				MOV lvi.iItem,EAX
				MOV BYTE PTR [ESI],","
				MOV lvi.pszText,ESI
				MOV lvi.iSubItem,1
				Invoke SendMessage,hListProcedures,LVM_SETITEM,0,ADDR lvi
			.EndIf
			
			XOR ESI,ESI
			INC EDI
			MOV ECX,EDI
			INC ECX
			JMP @B
		.EndIf
		
		.If ESI
		.Else
		 	.If BYTE PTR [EDI]==","
				MOV ESI,EDI
				JMP @B
			.EndIf
		.EndIf
		
		.If BYTE PTR [EDI]==0
			JMP Done
		.EndIf
		JMP @B
		
		Done:
		Invoke HeapFree,hMainHeap,0,lpBlock
		Invoke CloseHandle,hFile
	.EndIf
	;PrintStringByAddr lpAPIFunctions
	RET
GetAPIFunctions EndP

;TVGN_CHILD

IndentComment Proc Uses ESI hCodeHi:DWORD, nChr:DWORD, fN:DWORD
Local ochr:CHARRANGE
Local chr:CHARRANGE
Local LnSt:DWORD
Local LnEn:DWORD
Local Buffer[32]:BYTE
	
	;Stop Updating the status bar-faster
	MOV bUpdateSelect,FALSE
	
	;MOV Buffer[0],0
	;MOV Buffer[1],0
	Invoke SendMessage,hCodeHi,WM_SETREDRAW,FALSE,0
	
	.If fN
		.If TabToSpaces==TRUE && nChr==VK_TAB
			XOR ECX,ECX
			@@:
			.If ECX<TabSize
				MOV BYTE PTR Buffer[ECX]," "
				INC ECX
				JMP @B
			.EndIf
			MOV BYTE PTR Buffer[ECX],0
		.Else
			MOV EAX,nChr
			MOV DWORD PTR Buffer[0],EAX
			MOV BYTE PTR Buffer[1],0
		.EndIf
	.EndIf
	
	Invoke SendMessage,hCodeHi,EM_EXGETSEL,0,ADDR ochr
	
	;new------------------
	Invoke SendMessage,hCodeHi,EM_EXLINEFROMCHAR,0,ochr.cpMin
	Invoke SendMessage,hCodeHi,EM_LINEINDEX,EAX,0
	MOV ochr.cpMin,EAX
	
	.If ochr.cpMax>EAX
		DEC ochr.cpMax
	.EndIf
	Invoke SendMessage,hCodeHi,EM_EXLINEFROMCHAR,0,ochr.cpMax
	
	PUSH EAX
	Invoke SendMessage,hCodeHi,EM_LINEINDEX,EAX,0
	POP ECX
	PUSH EAX
	;Invoke SendMessage,hCodeHi,EM_LINELENGTH,ochr.cpMax,0
	Invoke GetLineLength,hCodeHi,ECX
	POP ECX
	ADD EAX,ECX
	
	INC EAX
	MOV ochr.cpMax,EAX

	Invoke SendMessage,hCodeHi,EM_EXGETSEL,0,ADDR chr
	Invoke SendMessage,hCodeHi,EM_HIDESELECTION,TRUE,0
	Invoke SendMessage,hCodeHi,EM_EXLINEFROMCHAR,0,chr.cpMin
	MOV LnSt,EAX


	MOV EAX,chr.cpMax
	.If EAX> chr.cpMin
		DEC EAX
	.EndIf
	Invoke SendMessage,hCodeHi,EM_EXLINEFROMCHAR,0,EAX
	MOV LnEn,EAX

	Next:
	;----
	MOV EAX,LnSt
	.If EAX<=LnEn
		Invoke SendMessage,hCodeHi,CHM_GETBOOKMARK,LnSt,0
		.If EAX==2
			Invoke SendMessage,hCodeHi,CHM_EXPAND,LnSt,Offset CHBDProc
		.EndIf
		Invoke SendMessage,hCodeHi,EM_LINEINDEX,LnSt,0
		MOV chr.cpMin,EAX
		INC LnSt
		.If fN
			MOV chr.cpMax,EAX
			Invoke SendMessage,hCodeHi,EM_EXSETSEL,0,ADDR chr
			Invoke SendMessage,hCodeHi,EM_REPLACESEL,TRUE,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ochr.cpMax,EAX
			JMP Next
		.Else
			Invoke SendMessage,hCodeHi,EM_LINEINDEX,LnSt,0
			MOV chr.cpMax,EAX
			Invoke SendMessage,hCodeHi,EM_EXSETSEL,0,ADDR chr
			Invoke SendMessage,hCodeHi,EM_GETSELTEXT,0,ADDR LineTxt
			MOV ESI, Offset LineTxt
			XOR EAX,EAX
			MOV AL,[ESI]
			.If EAX==nChr
				INC ESI
				Invoke SendMessage,hCodeHi,EM_REPLACESEL,TRUE,ESI
				DEC ochr.cpMax
				
			.ElseIf nChr==09h
				MOV ECX,TabSize
				DEC ESI
			@@:
				INC ESI
				MOV AL,[ESI]
				CMP AL,' '
				JNE @F
				LOOP @B
				INC ESI
			@@:
				.If AL==09h
					INC ESI
					DEC ECX
				.EndIf
				MOV EAX,TabSize
				SUB EAX,ECX
				SUB ochr.cpMax,EAX
				Invoke SendMessage,hCodeHi,EM_REPLACESEL,TRUE,ESI
			.EndIf
			JMP Next
		.EndIf
	.EndIf
	Invoke SendMessage,hCodeHi,EM_EXSETSEL,0,ADDR ochr
	Invoke SendMessage,hCodeHi,EM_HIDESELECTION,FALSE,0
	Invoke SendMessage,hCodeHi,EM_SCROLLCARET,0,0
	Invoke SendMessage,hCodeHi,WM_SETREDRAW,TRUE,0
	Invoke SendMessage,hCodeHi,CHM_REPAINT,0,0
	
	;Allow Updating the status bar
	MOV bUpdateSelect,TRUE
	;Update it !
	Invoke SetFocus,hCodeHi
	RET
IndentComment EndP

SetProjectTreeAndProcListColors Proc
	
	Invoke SendMessage, WinAsmHandles.hBlocksList,LVM_SETBKCOLOR,0,col.TreeBackCol
	Invoke SendMessage, WinAsmHandles.hBlocksList,LVM_SETTEXTBKCOLOR,0,col.TreeBackCol
	Invoke SendMessage, WinAsmHandles.hBlocksList,LVM_SETTEXTCOLOR,0,col.TreeTextCol
	Invoke InvalidateRect,WinAsmHandles.hBlocksList,NULL,TRUE
	
	Invoke SendMessage, WinAsmHandles.hProjTree,TVM_SETBKCOLOR, 0, col.TreeBackCol
	Invoke SendMessage, WinAsmHandles.hProjTree,TVM_SETTEXTCOLOR, 0, col.TreeTextCol
	Invoke SendMessage, WinAsmHandles.hProjTree,TVM_SETLINECOLOR, 0, col.TreeLineCol
	;Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SETINSERTMARKCOLOR, 0, 0000ff00h
	
	Invoke SendMessage, hDialogsTree,TVM_SETBKCOLOR, 0, col.TreeBackCol
	Invoke SendMessage, hDialogsTree,TVM_SETTEXTCOLOR, 0, col.TreeTextCol
	Invoke SendMessage, hDialogsTree,TVM_SETLINECOLOR, 0, col.TreeLineCol

	Invoke SendMessage, hOthersTree,TVM_SETBKCOLOR, 0, col.TreeBackCol
	Invoke SendMessage, hOthersTree,TVM_SETTEXTCOLOR, 0, col.TreeTextCol
	Invoke SendMessage, hOthersTree,TVM_SETLINECOLOR, 0, col.TreeLineCol

	Invoke SendMessage, hPropertiesList,LVM_SETBKCOLOR,0,col.TreeBackCol
	Invoke SendMessage, hPropertiesList,LVM_SETTEXTBKCOLOR,0,col.TreeBackCol
	Invoke SendMessage, hPropertiesList,LVM_SETTEXTCOLOR,0,col.TreeTextCol
	Invoke InvalidateRect,hPropertiesList,NULL,TRUE

	RET
SetProjectTreeAndProcListColors EndP

;Return in EAX the pointer to the KeyWords

GetKeyValue Proc lpSection:DWORD, lpKey:DWORD
Local BlockSize:DWORD
Local pTemp:DWORD
	MOV BlockSize,1024;*10
	Invoke HeapAlloc,hMainHeap,0,BlockSize
	MOV pTemp,EAX
	@@:		
	Invoke GetPrivateProfileString,lpSection,lpKey,ADDR szNULL,pTemp,BlockSize,pKeyWordsFileName
	.If EAX!=0
		INC EAX
		.If EAX==BlockSize	;The Buffer is too small
			ADD BlockSize,1024;*10
			Invoke HeapReAlloc,hMainHeap,0,pTemp,BlockSize
			MOV pTemp,EAX
			JMP @B
		.EndIf
	.Else
		RET	;EAX is 0
	.EndIf
	MOV EAX, pTemp
	RET
GetKeyValue EndP
GetKeyWords Proc; lpSection:DWORD
	;Invoke GetFileAttributes,lpKeyFile	;Check if file exists
	;.If EAX!=-1
        MOV KeyWordsLoaded,1 ; at least once been loaded

		LEA EAX, szC0COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C0, EAX
		
		LEA EAX, szC1COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C1, EAX

		LEA EAX, szC2COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C2, EAX

		LEA EAX, szC3COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C3, EAX

		LEA EAX, szC4COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C4, EAX

		LEA EAX, szC5COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C5, EAX

		LEA EAX, szC6COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C6, EAX

		LEA EAX, szC7COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV C7, EAX

		LEA EAX, szC8COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV APIFunctionsColor, EAX

		LEA EAX, szC9COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV APIStructuresColor, EAX
		
		LEA EAX, szC10COLOR
		CALL GetColor
		AND EAX,0FFFFFFFh
		MOV APIConstantsColor, EAX
		JMP GetRestColors
		;------------------------------------------------------------------
		GetColor:
;		Invoke GetPrivateProfileInt,Offset szCATEGORIES, EAX, 0,Offset KeyWordsFileName
		Invoke GetPrivateProfileInt,Offset szCATEGORIES, EAX, 0,pKeyWordsFileName
		RETN
		;------------------------------------------------------------------
		GetRestColors:
;		Invoke GetPrivateProfileInt,Offset szCATEGORIES, Offset szC11COLOR, 0,Offset KeyWordsFileName
		Invoke GetPrivateProfileInt,Offset szCATEGORIES, Offset szC11COLOR, 0,pKeyWordsFileName
		AND EAX,0FFFFFFFh
		OR EAX,10000000h
		MOV C11, EAX

		Invoke GetPrivateProfileInt,Offset szCATEGORIES, Offset szC12COLOR, 0,pKeyWordsFileName
		AND EAX,0FFFFFFFh
		OR EAX,10000000h
		MOV C12, EAX

		Invoke GetPrivateProfileInt,Offset szCATEGORIES, Offset szC13COLOR, 0,pKeyWordsFileName
		AND EAX,0FFFFFFFh
		OR EAX,20000000h
		MOV C13, EAX

		Invoke GetPrivateProfileInt,Offset szCATEGORIES, Offset szC14COLOR, 0,pKeyWordsFileName

		AND EAX,0FFFFFFFh
		OR EAX,20000000h
		MOV C14, EAX
		

		Invoke HeapFree,hMainHeap,0,lpC0WORDS
		LEA EAX, szC0WORDS
		CALL GetPointerToWords
		MOV lpC0WORDS, EAX
		
		Invoke HeapFree,hMainHeap,0,lpC1WORDS
		LEA EAX, szC1WORDS
		CALL GetPointerToWords
		MOV lpC1WORDS, EAX

		Invoke HeapFree,hMainHeap,0,lpC2WORDS
		LEA EAX, szC2WORDS
		CALL GetPointerToWords
		MOV lpC2WORDS, EAX
				
		Invoke HeapFree,hMainHeap,0,lpC3WORDS
		LEA EAX, szC3WORDS
		CALL GetPointerToWords
		MOV lpC3WORDS, EAX
				
		Invoke HeapFree,hMainHeap,0,lpC4WORDS
		LEA EAX, szC4WORDS
		CALL GetPointerToWords
		MOV lpC4WORDS, EAX
				
		Invoke HeapFree,hMainHeap,0,lpC5WORDS
		LEA EAX, szC5WORDS
		CALL GetPointerToWords
		MOV lpC5WORDS, EAX
				
		Invoke HeapFree,hMainHeap,0,lpC6WORDS
		LEA EAX, szC6WORDS
		CALL GetPointerToWords
		MOV lpC6WORDS, EAX
				
		Invoke HeapFree,hMainHeap,0,lpC7WORDS
		LEA EAX, szC7WORDS
		CALL GetPointerToWords
		MOV lpC7WORDS, EAX
				
;		Invoke HeapFree,hMainHeap,0,lpAPIFunctions
;		LEA EAX,szAPIFunctions
;		CALL GetPointerToWords
;		MOV lpAPIFunctions, EAX
;				
;		Invoke HeapFree,hMainHeap,0,lpAPIStructures
;		LEA EAX, szAPIStructures
;		CALL GetPointerToWords
;		MOV lpAPIStructures, EAX
		JMP Done
		;------------------------------------------------------------------		
		GetPointerToWords:
		Invoke GetKeyValue,Offset szCATEGORIES, EAX
		RETN
		;------------------------------------------------------------------		
		Done:
		Invoke HeapFree,hMainHeap,0,lpC11WORDS
		Invoke GetKeyValue,Offset szCATEGORIES, Offset szC0RC
		MOV lpC11WORDS, EAX

		Invoke HeapFree,hMainHeap,0,lpC12WORDS
		Invoke GetKeyValue,Offset szCATEGORIES, Offset szC1RC
		MOV lpC12WORDS, EAX

		Invoke HeapFree,hMainHeap,0,lpC13WORDS
		Invoke GetKeyValue,Offset szCATEGORIES, Offset szC0BAT
		MOV lpC13WORDS, EAX

		Invoke HeapFree,hMainHeap,0,lpC14WORDS
		Invoke GetKeyValue,Offset szCATEGORIES, Offset szC1BAT
		MOV lpC14WORDS, EAX

	RET
GetKeyWords EndP

;Get Settings from Ini File
GetSettingsFromIni Proc Uses EDI ESI EBX
Local nDefault	:DWORD
	MOV EBX, Offset IniFileName
	
	MOV EDI,Offset szINTELLISENSE
	LEA EAX, szAutoComplete
	MOV nDefault,(AUTOCOMPLETEWITHSPACE OR AUTOCOMPLETEWITHTAB OR AUTOCOMPLETEWITHENTER)
	CALL GetIt
	MOV fAutoComplete, EAX
	

	MOV EDI, Offset szEDITOR
	MOV ESI, Offset szGENERAL

	
	LEA EAX, szBackColor
	MOV nDefault,00ffffffh
	CALL GetIt
	MOV col.bckcol, EAX

	LEA EAX, szTextColor
	MOV nDefault,0
	CALL GetIt
	MOV col.txtcol, EAX

	LEA EAX, szSelBackColor
	MOV nDefault,00804000h
	CALL GetIt
	MOV col.selbckcol, EAX

	LEA EAX, szSelTextColor
	MOV nDefault,00ffffffh
	CALL GetIt
	MOV col.seltxtcol, EAX

	LEA EAX, szCommentColor
	MOV nDefault,00008000h
	CALL GetIt
	MOV col.cmntcol, EAX

	LEA EAX, szStringColor
	MOV nDefault,00a00000h
	CALL GetIt
	MOV col.strcol, EAX

	LEA EAX, szOperatorColor
	MOV nDefault,00ff8000h
	CALL GetIt
	MOV col.oprcol, EAX

	LEA EAX, szHiliteColor1
	MOV nDefault,000000c0h
	CALL GetIt
	MOV col.hicol1, EAX

	LEA EAX, szHiliteColor2
	MOV nDefault,0080ff80h
	CALL GetIt
	MOV col.hicol2, EAX

	LEA EAX, szHiliteColor3
	MOV nDefault,00c08000h
	CALL GetIt
	MOV col.hicol3, EAX

	LEA EAX, szSelBarBackColor
	MOV nDefault,00c08000h
	CALL GetIt
	MOV col.selbarbck, EAX

	LEA EAX, szSelBarPen
	MOV nDefault,00808080h
	CALL GetIt
	MOV col.selbarpen, EAX

	LEA EAX, szLineNrColor
	MOV nDefault,00ffffffh
	CALL GetIt
	MOV col.lnrcol, EAX
	
	LEA EAX, szNumberColor
	MOV nDefault,808080h
	CALL GetIt
	MOV col.numcol, EAX
	
	LEA EAX, szTltBackColor
	MOV nDefault,808000h
	CALL GetIt
	MOV col.tltbckcol, EAX

	LEA EAX, szTltActParamCol
	MOV nDefault,00FFFFFFh
	CALL GetIt
	MOV col.TltActParamCol, EAX


	
	LEA EAX, szRCBackCol
	MOV nDefault,0C08000h
	CALL GetIt
	MOV col.RCBackCol,EAX

	LEA EAX, szTabSize
	MOV nDefault,4
	CALL GetIt
	.If EAX<1 
		MOV TabSize,1
	.ElseIf EAX>20
		MOV TabSize,20
	.Else
		MOV TabSize,EAX
	.EndIf
	JMP GetTreeColors

	;-----------------------------------------------------------------------		
	GetIt:
	Invoke GetPrivateProfileInt,EDI, EAX, nDefault,EBX
	RETN
	;------------------------------------------------------------------------
	GetTreeColors:

	LEA EAX, szTreeBackColor
	MOV nDefault,00ffffffh
	CALL GetThis
	MOV col.TreeBackCol, EAX

	LEA EAX, szTreeTextColor
	MOV nDefault,00c08000h
	CALL GetThis
	MOV col.TreeTextCol, EAX

	LEA EAX, szTreeLineColor
	MOV nDefault,00004000h
	CALL GetThis
	MOV col.TreeLineCol, EAX


	JMP Done
	;-----------------------------------------------------------------------
	GetThis:
	;Offset szGENERAL
	Invoke GetPrivateProfileInt,ESI, EAX, nDefault,EBX
	RETN
	;-----------------------------------------------------------------------
	
	
	Done:
;	MOV EDI, Offset szEDITOR
;	MOV ESI, Offset szGENERAL
;	MOV EBX, Offset IniFileName

	Invoke GetPrivateProfileInt,EDI, Offset szAutoIndent, 1,EBX
	MOV AutoIndent,EAX
	
	Invoke GetPrivateProfileInt,EDI, Offset szTabIndicators, 1,EBX
	MOV TabIndicators,EAX

	Invoke GetPrivateProfileInt,EDI, Offset szShowScrollTips, 0,EBX
	MOV ShowScrollTips,EAX

	Invoke GetPrivateProfileInt,EDI, Offset szShowLineNumbersOnOpen, 0,EBX
	MOV ShowLineNumbersOnOpen,EAX

	Invoke GetPrivateProfileInt,EDI, Offset szAutoshowLineNumbersOnError,1,EBX
	MOV AutoshowLineNumbersOnError,EAX

	Invoke GetPrivateProfileInt,EDI, Offset szAutoLineNrWidth, 0,EBX
	MOV AutoLineNrWidth,EAX
	
	Invoke GetPrivateProfileInt,EDI, Offset szTabToSpaces, 0,EBX
	MOV TabToSpaces,EAX

	Invoke GetPrivateProfileInt,EDI, Offset szLineNrWidth, 31,EBX
	MOV LineNrWidth, EAX

	;-----------------------------------------------------------------------
	Invoke GetPrivateProfileInt,ESI, Offset szGradientMenuItems, 1,EBX
	MOV GradientMenuItems,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szAutoSave, 1,EBX
	MOV AutoSave,EAX
	
	Invoke GetPrivateProfileInt,ESI, Offset szOnStartUp, 1,EBX
	MOV OnStartUp,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szShowSplash, 1,EBX
	MOV ShowSplashOnStartUp,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szOnMinimizeToSysTray, 0,EBX
	MOV OnMinimizeToSysTray,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szAutoToolAndOptions, 0,EBX
	MOV AutoToolAndOptions,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szAutoClean, 0,EBX
	MOV AutoClean,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szShowOutOnSuccess, 0,EBX
	MOV ShowOutOnSuccess,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szOpenChildrenMaximized, 0,EBX
	.If EAX
		MOV OpenChildStyle,WS_MAXIMIZE
	.EndIf
	
	Invoke GetPrivateProfileString,ESI, Offset szInitDir, ADDR szNULL,Offset InitDir, MAX_PATH,EBX
	;---------------------------------------------------------------------------------------------
	MOV EDI, Offset szFILESANDPATHS
	MOV ESI, Offset szMISCELLANEOUS
	;MOV EBX, Offset IniFileName
	
	Invoke GetPrivateProfileString,EDI, Offset szAPIFunctionsFile, ADDR szNULL, Offset APIFunctionsFile, MAX_PATH,EBX
	Invoke GetPrivateProfileString,EDI, Offset szAPIStructuresFile, ADDR szNULL, Offset APIStructuresFile, MAX_PATH,EBX
	Invoke GetPrivateProfileString,EDI, Offset szAPIConstantsFile, ADDR szNULL, Offset APIConstantsFile, MAX_PATH,EBX

	Invoke GetPrivateProfileString,EDI, Offset szBinaryPath,ADDR szNULL, Offset BinaryPath, MAX_PATH,EBX
	Invoke GetPrivateProfileString,EDI, Offset szIncludePath,ADDR szNULL, Offset IncludePath, MAX_PATH,EBX
	Invoke GetPrivateProfileString,EDI, Offset szLibraryPath,ADDR szNULL, Offset LibraryPath, MAX_PATH,EBX

	Invoke GetPrivateProfileString,EDI, Offset szHelpFile, ADDR szNULL,Offset HelpFileName, MAX_PATH,EBX
	;---------------------------------------------------------------------------------------------

	Invoke GetPrivateProfileString,ESI, Offset szExtResEdit, ADDR szNULL,Offset ExternalResourceEditor, MAX_PATH,EBX

	Invoke GetPrivateProfileInt,ESI, Offset szLaunchExeOnGoAll,1, Offset IniFileName
	MOV LaunchExeOnGoAll,EAX
	
	Invoke GetPrivateProfileString,ESI, Offset szExtDebugger, ADDR szNULL,Offset ExternalDebugger, MAX_PATH,EBX

	Invoke GetPrivateProfileInt,ESI, Offset szUseQuotes, 0,EBX
	MOV UseQuotes,EAX

	Invoke GetPrivateProfileInt,ESI, Offset szDebugUseQuotes, 0,EBX
	MOV DebugUseQuotes,EAX

	;---------------------------------------------------------------------------------------------
;	MOV ESI, Offset szASSEMBLER
;
;;szProcDef		DB 'Proc',0
;;szEndPDef		DB 'EndP',0
;;szMacroDef		DB 'Macro',0
;;szEndmDef		DB 'Endm',0
;;szStructDef		DB 'Struct',0
;;szEndsDef		DB 'Ends',0
;
;;szProc				DB '$ proc';,0	;masm
;;szEndp				DB '$ endp';,0	;masm
;;szMacro				DB '$ macro';,0	;masm
;;szEndm				DB 'endm';,0		;masm
;;szStruct			DB '$ struct';,0	;masm
;;szEnds				DB '$ ends';,0	;masm
;
;	Invoke GetPrivateProfileString,ESI, Offset szProcDef, Offset szProc,Offset szProc, MAX_PATH,EBX
;
;	Invoke GetPrivateProfileString,ESI, Offset szEndPDef, Offset szEndp,Offset szEndp, MAX_PATH,EBX
;	
;	Invoke GetPrivateProfileString,ESI, Offset szMacroDef, Offset szMacro,Offset szMacro, MAX_PATH,EBX
;	
;	Invoke GetPrivateProfileString,ESI, Offset szEndmDef, Offset szEndm,Offset szEndm, MAX_PATH,EBX
;	
;	Invoke GetPrivateProfileString,ESI, Offset szStructDef, Offset szStruct,Offset szStruct, MAX_PATH,EBX
;	
;	Invoke GetPrivateProfileString,ESI, Offset szEndsDef, Offset szEnds,Offset szEnds, MAX_PATH,EBX





	RET
GetSettingsFromIni EndP

ProcessCommand Proc CmdLine:LPSTR, lpBuffer:DWORD
Local NoOfQuotes:DWORD

	Invoke lstrlen, CmdLine
	ADD EAX,CmdLine
	DEC EAX
	
	.If BYTE PTR [EAX]==' ' || BYTE PTR [EAX]== VK_TAB
		.While EAX >=CmdLine
			DEC EAX
			.If BYTE PTR [EAX]!=' ' && BYTE PTR [EAX]!= VK_TAB
				.Break
			.EndIf
		.EndW
	.EndIf
	.If BYTE PTR [EAX]=='"'
		MOV NoOfQuotes, 1
		MOV BYTE PTR [EAX], 0
		.While EAX>=CmdLine
			DEC EAX
			.If BYTE PTR [EAX]=='"'
				INC EAX
				;Now EAX is a pointer to string in(quotes NOT included)
				MOV NoOfQuotes, 2
				.Break
			.EndIf
		.EndW
	.Else
		MOV NoOfQuotes, 1
		MOV BYTE PTR [EAX+1], 0 ;if we had trailing spaces  or tabs
		.While EAX>=CmdLine
			DEC EAX
			.If BYTE PTR [EAX]==' '
				INC EAX
				;Now EAX is a pointer to string in(quotes NOT included)
				MOV NoOfQuotes, 2
				.Break
			.EndIf
		.EndW
	.EndIf

	.If NoOfQuotes==2
		Invoke lstrcpy, lpBuffer, EAX
		MOV EAX,TRUE
	.Else
		MOV EAX,FALSE
	.EndIf
	RET
ProcessCommand EndP

CenterWindow Proc hWindow:HWND
Local DlgRect:RECT
Local DesktopRect:RECT 
Local DlgHeight:DWORD 
LOCAL DlgWidth:DWORD 

	Invoke GetWindowRect,hWindow,ADDR DlgRect
	Invoke GetDesktopWindow
	MOV ECX,EAX
	Invoke GetWindowRect,ECX,ADDR DesktopRect
	
	PUSH 0			;fRedraw=FALSE:last parameter of MoveWindow
	
	MOV EAX,DlgRect.bottom
	SUB EAX,DlgRect.top
	MOV DlgHeight,EAX
	PUSH EAX		;nHeight
	
	MOV EAX,DlgRect.right
	SUB EAX,DlgRect.left
	MOV DlgWidth,EAX
	PUSH EAX		;nWidth
	
	MOV EAX,DesktopRect.bottom
	SUB EAX,DlgHeight
	.If SDWORD PTR EAX<0
		XOR EAX,EAX
	.Else
		SHR EAX,1
	.EndIf
	PUSH EAX		;y
	
	MOV EAX,DesktopRect.right
	SUB EAX,DlgWidth
	.If SDWORD PTR EAX<0
		XOR EAX,EAX
	.Else
		SHR EAX,1
	.EndIf
	PUSH EAX		;x
	
	PUSH hWindow	;hWnd
	CALL MoveWindow 
	RET
CenterWindow EndP

ChooseFontHook Proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	.If uMsg==WM_INITDIALOG
		Invoke CenterWindow, hWnd
		Invoke SetWindowText,hWnd,Offset szFont
	.EndIf
	MOV EAX,FALSE
	RET
ChooseFontHook EndP

SetOutEditWindowFormat Proc
Local rafnt:CHFONT

	MOV	EAX,hFont
	MOV	rafnt.hFont,EAX
	MOV	EAX,hIFont
	MOV	rafnt.hIFont,EAX
	MOV	EAX,hLnrFont
	MOV	rafnt.hLnrFont,EAX
	
	Invoke SendMessage,hOut,CHM_SETFONT,0,ADDR rafnt
	Invoke SendMessage, hOut,CHM_SETCOLOR, 0, ADDR col

	RET
SetOutEditWindowFormat EndP

SetFormat Proc hWin:HWND
Local chfnt:CHFONT

	MOV	EAX,hFont
	MOV	chfnt.hFont,EAX
	MOV	EAX,hIFont
	MOV	chfnt.hIFont,EAX
	MOV	EAX,hLnrFont

	MOV	chfnt.hLnrFont,EAX

	;Set Fonts
	Invoke SendMessage,hWin,CHM_SETFONT,0,ADDR chfnt
	;Set Tab Width
	Invoke SendMessage,hWin,CHM_TABWIDTH,TabSize,TabToSpaces
	;Set Autoindent On
	Invoke SendMessage,hWin,CHM_AUTOINDENT,0,AutoIndent	;This is TRUE Or FALSE
	;Set number of lines mouse wheel will scroll
	;NOTE! If you have mouse software installed, set to 0
	Invoke SendMessage,hWin,CHM_MOUSEWHEEL,3,0
	;Set selection bar width
	Invoke SendMessage,hWin,CHM_SELBARWIDTH,SELBARWIDTH,0
	
	;Set linenumber width
	Invoke SendMessage,hWin,CHM_LINENUMBERWIDTH,LineNrWidth,0
	RET
SetFormat EndP

SetKeyWords Proc hWin:HWND,nGroup:DWORD
	
	Invoke SendMessage,hWin,CHM_SETWORDGROUP,0,nGroup
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,0,0

	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C0,lpC0WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C1,lpC1WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C2,lpC2WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C3,lpC3WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C4,lpC4WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C5,lpC5WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C6,lpC6WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C7,lpC7WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,APIFunctionsColor,lpAPIFunctions
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,APIStructuresColor,lpAPIStructures
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,APIConstantsColor,lpAPIConstants
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C11,lpC11WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C12,lpC12WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C13,lpC13WORDS
	Invoke SendMessage,hWin,CHM_SETHILITEWORDS,C14,lpC14WORDS

	RET
SetKeyWords EndP

;Returns in EAX the pointer to the File extension
GetFileExtension Proc lpFileName:DWORD
	Invoke lstrlen,lpFileName
	MOV EDX,lpFileName
	.While EAX
		DEC EAX
		.If BYTE PTR [EDX+EAX]=='.'
			ADD EAX,EDX
			.Break

		.EndIf
	.EndW
	RET
GetFileExtension EndP

ShowWindowAndGoToLine Proc Uses EBX hChild:DWORD
Local chrg:CHARRANGE

	Invoke GetWindowLong,hChild,0
	MOV EBX, EAX
	Invoke lstrcmpi, ADDR CHILDWINDOWDATA.szFileName[EBX], Offset BuggyWindowFileName
	.If EAX == 0
		;Show Line Number Column
		.If AutoshowLineNumbersOnError
			Invoke CheckDlgButton,[EBX].CHILDWINDOWDATA.hEditor,-2,TRUE
			Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_COMMAND,-2,0
		.EndIf
		
		Invoke SetWindowPos,hChild, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
		
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_LINEINDEX,BugLine,0
		MOV chrg.cpMin,EAX
		MOV chrg.cpMax,EAX
		;PrintDec EAX
		;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SETSEL,chrg.cpMin,chrg.cpMax
		Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXSETSEL,0,ADDR chrg
		
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SCROLLCARET,0,0
		Invoke SetFocus,[EBX].CHILDWINDOWDATA.hEditor
	.EndIf
	RET
ShowWindowAndGoToLine EndP

SetBuggyLine Proc Uses EBX hChild:DWORD
	Invoke GetWindowLong,hChild,0
	MOV EBX, EAX
	Invoke lstrcmpi, ADDR CHILDWINDOWDATA.szFileName[EBX], Offset BuggyWindowFileName
	.If EAX == 0
		;Because if not expanded, buggy line will be invisible after Expanding manually
		Invoke InProcedure,CHILDWINDOWDATA.hEditor[EBX],BugLine
		.If EAX!=0 ;i.e. we are in a procedure
			;Now ECX is the line procedure starts
			Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX], CHM_EXPAND,ECX, Offset CHBDProc
		.EndIf
		Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_SETBOOKMARK,BugLine,7
	.EndIf
	RET
SetBuggyLine EndP


;Convert decimal string into DWORD value return value in EAX
A2DW Proc lpString:DWORD

	PUSH ESI
	PUSH EDI
	XOR EAX, EAX
	MOV ESI, [lpString]
	XOR ECX, ECX
	XOR EDX, EDX
	MOV AL, [ESI]
	INC ESI
	CMP AL, 2D;h
	JNE Proceed
	MOV AL, BYTE PTR [ESI]
	NOT EDX
	INC ESI
	JMP Proceed

  @@: 
	SUB AL, 30h
	LEA ECX, DWORD PTR [ECX+4*ECX]
	LEA ECX, DWORD PTR [EAX+2*ECX]
	MOV AL, BYTE PTR [ESI]
	INC ESI

  Proceed:
	OR AL, AL
	JNE @B
	LEA EAX, DWORD PTR [EDX+ECX]
	XOR EAX, EDX

	POP EDI
	POP ESI

	RET
A2DW EndP
;Fills lpWindowCaption with the buggy Window caption
;Returns 0 if no bug found or line with bug
GetErrorPos Proc Uses EBX EDI lpLineBuffer:DWORD, lpWindowCaption:DWORD
Local Found:DWORD ;BOOLEAN


	MOV BugLine, 0
	MOV EDI,lpWindowCaption
	MOV BYTE PTR [EDI],0
	
	MOV Found,FALSE
	Invoke lstrlen,lpLineBuffer
	MOV EBX, EAX
	MOV EAX,lpLineBuffer
	ADD EBX,EAX

	;So that if e.g. D:\blah\blah.asm(23) : error ..... then  skip first :
	ADD EAX,2

	.While EAX<EBX
		.If BYTE PTR [EAX]==":"
			MOV BYTE PTR [EAX],0
			DEC EAX
			.If BYTE PTR [EAX]!=" "
				;There is no space before : when compiling resource.
				INC EAX
			.Else
				MOV BYTE PTR [EAX],0
				PUSH EAX
				;MASM :, LINK :, RC :,CVTRES : errors NOT counted.
				Invoke lstrcmpi,lpLineBuffer,Offset szMASM	;"MASM"
				.If EAX==0	;Dummy Error Found
					MOV Found,TRUE
				.Else
					Invoke lstrcmpi,lpLineBuffer,Offset szLINK	;"LINK"
					.If EAX==0
						.If ProjectType==6;Dummy Error Found-For DOS Projects there are link warnings that we don't mind
							POP ECX
							PUSH EAX	;Balance the stack
							ADD ECX,2
							MOV EDX,ECX
							;If at ECX we have		< warning L4045: name of output file is 'c:DosCom.com'> 
							;LINK : warning L4045: name of output file is 'c:DosCom.com'
							.While BYTE PTR [ECX]
								.If BYTE PTR [ECX]==":"
									INC ECX
									MOV BYTE PTR [ECX],0
								.EndIf
								INC ECX
							.EndW
							
							Invoke lstrcmpi,EDX,CTEXT(" warning L4045:")
							.If EAX
								MOV Found,TRUE
							.EndIf
						.Else
							MOV Found,TRUE
						.EndIf
					.Else
						Invoke lstrcmpi,lpLineBuffer,Offset szRC	;"RC"
						.If EAX==0	;Dummy Error Found
							MOV Found,TRUE
						.Else
							Invoke lstrcmpi,lpLineBuffer,CTEXT("CVTRES")
							.If EAX==0	;Dummy Error Found
								MOV Found,TRUE
							.EndIf
						.EndIf
					.EndIf
				.EndIf
				
				POP EAX
				
				.If Found==TRUE
					MOV BugLine, -1
					JMP Done
				.EndIf
			.EndIf
			MOV Found,TRUE
			.Break
		.EndIf
		INC EAX
	.EndW

	.If Found==TRUE
		MOV Found,FALSE
		.While EAX>lpLineBuffer
			DEC EAX
			.If BYTE PTR [EAX]==")"
				MOV BYTE PTR [EAX],0
				.While EAX>lpLineBuffer
					DEC EAX
					.If BYTE PTR [EAX]=="("
						INC EAX ;NOW EAX Points to Line Number
						PUSH EAX
						Invoke A2DW, EAX
						MOV BugLine, EAX
						
						;DEC BugLine
						DEC EAX ;Line number needed must be 1 less
						POP EAX
						
						DEC EAX
						DEC EAX
						
						.If BYTE PTR [EAX]!= " "
							;There is space before ( when compiling resource.
							INC EAX
						.EndIf
						
						MOV BYTE PTR [EAX],0
						
						;Now lpLineBuffer is the File Name where the bug resides
						Invoke GetFilePath,lpLineBuffer,EDI;ADDR BuggyWindowFileName
						;Now Buffer is File Path
						.If BYTE PTR [EDI]==0
							Invoke lstrcpy,EDI, Offset ProjectPath
							;Now Buffer holds fullpath file name.
							Invoke lstrcat,EDI, lpLineBuffer
						.ElseIf BYTE PTR [EDI]=="\"
							Invoke lstrcpy,EDI, Offset ProjectPath
							MOV BYTE PTR [EDI+2],0	;i.e leave only drive letter D: or C: etc
							Invoke lstrcat,EDI, lpLineBuffer
						.Else   ;leave it as it is
							Invoke lstrcpy,EDI, lpLineBuffer
						.EndIf
						
						MOV Found, TRUE
						JMP Done
					.EndIf
				.EndW
				
			.ElseIf DWORD PTR [EAX]=="jbo."	;For link errors that the error line does not start with "LINK"
				.If DWORD PTR [EAX+1]!="]jbo"	;e.g.: Object Modules [.obj] <------This is for 16-bit link
					MOV Found,TRUE
					MOV BugLine, -1
					JMP Done
				.EndIf
			.EndIf
		.EndW
	.Else
		MOV Found,FALSE
	.EndIf

	Done:
	;----
	XOR EAX,EAX
	.If Found==TRUE
		MOV EAX,BugLine
	.EndIf
	RET
GetErrorPos EndP

ClearBuggyBookmarks Proc Uses EBX hChild:DWORD
	Invoke GetWindowLong,hChild,0
	MOV EBX, EAX
	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_CLRBOOKMARKS,0,7
	RET
ClearBuggyBookmarks EndP

SetAllBuggyLines Proc Uses EBX
Local nLine:DWORD
	;MOV NrOfErrors,0
	Invoke SendMessage, hOut, EM_GETLINECOUNT, 0, 0
	MOV EBX,EAX
	
	MOV nLine,0
	.While nLine<EBX
		Invoke GetLineText,hOut,nLine,Offset LineTxt
		.If BYTE PTR LineTxt[0]!=0
			Invoke GetErrorPos, Offset LineTxt, Offset BuggyWindowFileName;ADDR Buffer
		   ;Now BuggyWindowFileName contains Buggy Window and EAX Buggy Line
		   .If EAX!=0   ;i.e. Error Found
				INC NrOfErrors
				.If EAX!=-1 ;i.e. If NOT Dummy Found
					DEC BugLine
					Invoke EnumProjectItems, Offset SetBuggyLine
				.EndIf
		   .EndIf
		.EndIf

		INC nLine
	.EndW
	RET
SetAllBuggyLines EndP

SetTvItemAndWindowCaption Proc Uses EBX, hChild:HWND
Local tvi:TVITEM
Local Buffer[256]:BYTE
	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	Invoke SetWindowText, hChild, ADDR CHILDWINDOWDATA.szFileName[EBX]
	.If CHILDWINDOWDATA.dwTypeOfFile[EBX]<101	;i.e. part of the current project
		MOV tvi._mask,TVIF_TEXT
		Invoke GetFilesTitle, ADDR CHILDWINDOWDATA.szFileName[EBX], ADDR Buffer
		LEA EAX, Buffer
		MOV tvi.pszText,EAX
		PUSH CHILDWINDOWDATA.hTreeItem[EBX]
		POP tvi.hItem
		Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SETITEM,0,ADDR tvi
	.EndIf
	RET
SetTvItemAndWindowCaption EndP

GetTypeOfFile Proc Uses EDI, lpFileName:DWORD
	Invoke GetFileExtension,lpFileName
	;Now EAX is a pointer to the file extension
	.If EAX!=0
		MOV EDI,EAX
		;1=asm, 2=inc, 3=rc, 4=txt, 5=def, 6=bat, 7=other
		Invoke lstrcmpi, EDI, Offset szExtAsm
		.If EAX==0
			MOV EAX,1
		.Else
			Invoke lstrcmpi, EDI, Offset szExtInc
			.If EAX==0
				MOV EAX,2
			.Else
				Invoke lstrcmpi, EDI,Offset szExtRc
				.If EAX==0
					MOV EAX,3
				.Else
					Invoke lstrcmpi, EDI, Offset szExtTxt
					.If EAX==0
						MOV EAX,4
					.Else
						Invoke lstrcmpi,EDI, Offset szExtDef
						.If EAX==0
							MOV EAX,5
						.Else
							Invoke lstrcmpi,EDI, Offset szExtBat
							.If EAX==0
								MOV EAX,6
							.Else
								MOV EAX, 7 	;Other
							.EndIf
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.EndIf
	.Else
		MOV EAX,7	;Other
	.EndIf
	RET
GetTypeOfFile EndP

SetProjectRelatedItems Proc


	Invoke EnableMenuItem,hMenu,IDM_CLOSEPROJECT,MF_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_SAVEPROJECT,MF_ENABLED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEPROJECT,TBSTATE_ENABLED
	
	Invoke EnableMenuItem,hMenu,IDM_SAVEPROJECTAS,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDASM,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDINC,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDRC,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDOTHER,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDEXISTINGFILE,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_BINARYFILES,MF_ENABLED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_PROJECT_ADDEXISTINGFILE,TBSTATE_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_PROPERTIES,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_RENAMEPROJECT,MF_ENABLED
	Invoke EnableDisableMakeOptions

	RET
SetProjectRelatedItems EndP

EnableDisable Proc Uses EBX hActiveEditor:DWORD
Local chrg:CHARRANGE

	Invoke SendMessage,hActiveEditor,EM_GETMODIFY,0,0
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,0
	.EndIf

	Invoke SendMessage,hActiveEditor,EM_EXGETSEL,0,ADDR chrg
	MOV EAX,chrg.cpMax
	SUB EAX,chrg.cpMin
	.If EAX ;i.e. there is selection
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOUPPERCASE,MF_ENABLED
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOLOWERCASE,MF_ENABLED
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_TOGGLECASE,MF_ENABLED
		
		Invoke EnableMenuItem,hMenu,IDM_EDIT_CUT,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_CUT,TBSTATE_ENABLED
		Invoke EnableMenuItem,hMenu,IDM_EDIT_COPY,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_COPY,TBSTATE_ENABLED
		Invoke EnableMenuItem,hMenu,IDM_EDIT_DELETE,MF_ENABLED
	.Else
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOUPPERCASE,MF_GRAYED
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOLOWERCASE,MF_GRAYED
		Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_TOGGLECASE,MF_GRAYED
		
		Invoke EnableMenuItem,hMenu,IDM_EDIT_CUT,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_CUT,0
		Invoke EnableMenuItem,hMenu,IDM_EDIT_COPY,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_COPY,0
		Invoke EnableMenuItem,hMenu,IDM_EDIT_DELETE,MF_GRAYED
	.EndIf

	Invoke SendMessage,hActiveEditor,EM_CANUNDO,0,0
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_EDIT_UNDO,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_UNDO,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_EDIT_UNDO,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_UNDO,0
	.EndIf
	
	Invoke SendMessage,hActiveEditor,EM_CANREDO,0,0
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_EDIT_REDO,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REDO,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_EDIT_REDO,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REDO,0
	.EndIf
	
	Invoke SendMessage,hActiveEditor,EM_CANPASTE,CF_TEXT,0
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_EDIT_PASTE,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_PASTE,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_EDIT_PASTE,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_PASTE,0
	.EndIf
	
	Invoke SendMessage,hActiveEditor,EM_EXLINEFROMCHAR,0,chrg.cpMin
	MOV EBX,EAX
	Invoke SendMessage,hActiveEditor,CHM_NXTBOOKMARK,EBX,3
	INC EAX
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_EDIT_NEXTBM,MF_ENABLED
		Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_NEXTBM,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_EDIT_NEXTBM,MF_GRAYED
		Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_NEXTBM,0
	.EndIf
	
	Invoke SendMessage,hActiveEditor,CHM_PRVBOOKMARK,EBX,3
	INC EAX
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_EDIT_PREVBM,MF_ENABLED
		Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_PREVBM,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_EDIT_PREVBM,MF_GRAYED
		Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_PREVBM,0
	.EndIf
		
	Invoke SendMessage,hActiveEditor,CHM_NXTBOOKMARK,-1,3
	INC EAX
	.If EAX
		Invoke EnableMenuItem,hMenu,IDM_EDIT_CLEARBM,MF_ENABLED
		Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_CLEARBM,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_EDIT_CLEARBM,MF_GRAYED
		Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_CLEARBM,0
	.EndIf
	RET
EnableDisable EndP

DisableTheRest Proc
	Invoke EnableMenuItem,hMenu,IDM_CLOSEPROJECT,MF_GRAYED
	
	Invoke EnableMenuItem,hMenu,IDM_SAVEPROJECT,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEPROJECT,0
	
	Invoke EnableMenuItem,hMenu,IDM_SAVEPROJECTAS,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDASM,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDINC,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDRC,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDOTHER,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_ADDEXISTINGFILE,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_BINARYFILES,MF_GRAYED
	
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_PROJECT_ADDEXISTINGFILE,0
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_RENAMEFILE,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_REMOVEFILE,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_RUNBATCH,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_RESOURCES_USEEXTRCEDITOR,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_PROPERTIES,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_PROJECT_RENAMEPROJECT,MF_GRAYED

	RET
DisableTheRest EndP

DisableAll Proc
	;Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_PROJECT_VISUALMODE,0

	Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,0

	Invoke EnableMenuItem,hMenu,IDM_SAVEFILEAS,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_PRINT,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_UNDO,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_UNDO,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_REDO,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REDO,0

	Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOUPPERCASE,MF_GRAYED
	Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOLOWERCASE,MF_GRAYED
	Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_TOGGLECASE,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_CUT,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_CUT,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_COPY,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_COPY,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_PASTE,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_PASTE,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_DELETE,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_SELECTALL,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_FIND,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_FIND,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_FINDNEXT,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_FINDPREVIOUS,MF_GRAYED


	Invoke EnableMenuItem,hMenu,IDM_EDIT_SMARTFIND,MF_GRAYED


	Invoke EnableMenuItem,hMenu,IDM_EDIT_REPLACE,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REPLACE,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_GOTOLINE,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_EDIT_HIDELINES,MF_GRAYED


	Invoke EnableMenuItem,hMenu,IDM_FORMAT_INDENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_INDENT,0

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_OUTDENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_OUTDENT,0

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_COMMENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_COMMENT,0

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_UNCOMMENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_UNCOMMENT,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_TOGGLEBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_TOGGLEBM,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_NEXTBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_NEXTBM,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_PREVBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_PREVBM,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_CLEARBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_CLEARBM,0
	
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CLOSE,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CLOSEALL,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_WINDOW_NEXT,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_PREVIOUS,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_TILEHORIZONTALLY,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_TILEVERTICALLY,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CASCADE,MF_GRAYED
	
	;Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_PROJECT_VISUALMODE,0

	RET	
DisableAll EndP

EnableAll Proc
	;Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_ENABLED
	;Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,TBSTATE_ENABLED
	
	Invoke EnableMenuItem,hMenu,IDM_SAVEFILEAS,MF_ENABLED
	
	Invoke EnableMenuItem,hMenu,IDM_PRINT,MF_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_SELECTALL,MF_ENABLED
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_FIND,MF_ENABLED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_FIND,TBSTATE_ENABLED
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_FINDNEXT,MF_ENABLED
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_FINDPREVIOUS,MF_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_SMARTFIND,MF_ENABLED

	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_REPLACE,MF_ENABLED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REPLACE,TBSTATE_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_GOTOLINE,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_EDIT_HIDELINES,MF_ENABLED

	;Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_GOTOLINE,TBSTATE_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_INDENT,MF_ENABLED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_INDENT,TBSTATE_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_OUTDENT,MF_ENABLED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_OUTDENT,TBSTATE_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_COMMENT,MF_ENABLED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_COMMENT,TBSTATE_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_UNCOMMENT,MF_ENABLED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_UNCOMMENT,TBSTATE_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_TOGGLEBM,MF_ENABLED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_TOGGLEBM,TBSTATE_ENABLED


	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CLOSE,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CLOSEALL,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_NEXT,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_PREVIOUS,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_TILEHORIZONTALLY,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_TILEVERTICALLY,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CASCADE,MF_ENABLED
	RET
EnableAll EndP

SetRCModified Proc bFlag:DWORD
	.If bFlag
		MOV RCModified,TRUE
		Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,TBSTATE_ENABLED
	.Else
		MOV RCModified,FALSE
		Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,0
	.EndIf
	RET
SetRCModified EndP


EnableDisableRC Proc

	.If RCModified
		Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_ENABLED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,TBSTATE_ENABLED
	.Else
		Invoke EnableMenuItem,hMenu,IDM_SAVEFILE,MF_GRAYED
		Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_SAVEFILE,0
	.EndIf

	;Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_PROJECT_VISUALMODE,TBSTATE_ENABLED

	Invoke EnableMenuItem,hMenu,IDM_SAVEFILEAS,MF_ENABLED
	
	Invoke EnableMenuItem,hMenu,IDM_PRINT,MF_GRAYED



	Invoke EnableMenuItem,hMenu,IDM_EDIT_SELECTALL,MF_GRAYED
	
;	Invoke EnableMenuItem,hMenu,IDM_EDIT_FIND,MF_GRAYED
;	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_FIND,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_SMARTFIND,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_FINDNEXT,MF_GRAYED
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_FINDPREVIOUS,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_REPLACE,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REPLACE,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_GOTOLINE,MF_GRAYED
	Invoke EnableMenuItem,hMenu,IDM_EDIT_HIDELINES,MF_GRAYED


	Invoke EnableMenuItem,hMenu,IDM_FORMAT_INDENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_INDENT,0

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_OUTDENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_OUTDENT,0

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_COMMENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_COMMENT,0

	Invoke EnableMenuItem,hMenu,IDM_FORMAT_UNCOMMENT,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_UNCOMMENT,0

;	Invoke EnableMenuItem,hMenu,IDM_EDIT_TOGGLEBM,MF_GRAYED
;	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_TOGGLEBM,0


	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CLOSE,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CLOSEALL,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_NEXT,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_PREVIOUS,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_TILEHORIZONTALLY,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_TILEVERTICALLY,MF_ENABLED
	Invoke EnableMenuItem,hMenu,IDM_WINDOW_CASCADE,MF_ENABLED



	Invoke EnableMenuItem,hMenu,IDM_EDIT_UNDO,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_UNDO,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_REDO,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REDO,0

	Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOUPPERCASE,MF_GRAYED
	Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_CONVERTTOLOWERCASE,MF_GRAYED
	Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hConvertMenu,IDM_TOGGLECASE,MF_GRAYED

	Invoke EnableMenuItem,hMenu,IDM_EDIT_CUT,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_CUT,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_COPY,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_COPY,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_PASTE,MF_GRAYED
	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_PASTE,0

	Invoke EnableMenuItem,hMenu,IDM_EDIT_DELETE,MF_GRAYED

;	Invoke EnableMenuItem,hMenu,IDM_EDIT_FIND,MF_GRAYED
;	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_FIND,0
;
;	Invoke EnableMenuItem,hMenu,IDM_EDIT_FINDNEXT,MF_GRAYED
;
;	Invoke EnableMenuItem,hMenu,IDM_EDIT_REPLACE,MF_GRAYED
;	Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_REPLACE,0


;	Invoke EnableMenuItem,hMenu,IDM_EDIT_GOTOLINE,MF_GRAYED
;
;	Invoke EnableMenuItem,hMenu,IDM_FORMAT_INDENT,MF_GRAYED
;	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_INDENT,0
;
;	Invoke EnableMenuItem,hMenu,IDM_FORMAT_OUTDENT,MF_GRAYED
;	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_OUTDENT,0

;	Invoke EnableMenuItem,hMenu,IDM_FORMAT_COMMENT,MF_GRAYED
;	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_COMMENT,0
;
;	Invoke EnableMenuItem,hMenu,IDM_FORMAT_UNCOMMENT,MF_GRAYED
;	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_FORMAT_UNCOMMENT,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_TOGGLEBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_TOGGLEBM,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_NEXTBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_NEXTBM,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_PREVBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_PREVBM,0
	
	Invoke EnableMenuItem,hMenu,IDM_EDIT_CLEARBM,MF_GRAYED
	Invoke SendMessage,hEditTB,TB_SETSTATE,IDM_EDIT_CLEARBM,0

	RET
EnableDisableRC EndP