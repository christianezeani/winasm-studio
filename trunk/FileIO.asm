GenerateResourceScript		PROTO :BOOLEAN
GetResources				PROTO
ClearRCEditor				PROTO
EnableAllButtonsOnToolBox	PROTO :DWORD
EnableAllButtonsOnRCOptions	PROTO :DWORD
StreamInProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD
StreamOutProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD

.CODE
SaveOutText Proc lpFileName:DWORD
Local EditStream:EDITSTREAM
	
	Invoke CreateFile,lpFileName,GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
	.If EAX!=INVALID_HANDLE_VALUE
		PUSH EAX
		;Stream the text to the file
		MOV EditStream.dwCookie,EAX
		MOV EditStream.pfnCallback,Offset StreamOutProc
		
		Invoke SendMessage,hOut,EM_STREAMOUT,SF_TEXT,ADDR EditStream
		POP EAX
		Invoke CloseHandle,EAX
	.Else
		Invoke MessageBox,WinAsmHandles.hMain,Offset szCannotSaveFile, Offset szAppName, MB_OK
	.EndIf
	RET
SaveOutText EndP

SaveFile Proc Uses EBX hChild:DWORD,lpFileName:DWORD
Local hFile:DWORD
Local EditStream:EDITSTREAM

	Invoke CreateFile,lpFileName,GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
	.If EAX!=INVALID_HANDLE_VALUE
		MOV hFile,EAX
		
		;Stream the text to the file
		MOV EditStream.dwCookie,EAX
		MOV EditStream.pfnCallback,Offset StreamOutProc
		
		Invoke GetWindowLong,hChild,0
		MOV EBX,EAX
		
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_STREAMOUT,SF_TEXT,ADDR EditStream
		
		Invoke CloseHandle,hFile
		;Set the modify state to false
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SETMODIFY,FALSE,0
		
		;-----------------------------------
		MOV [EBX].CHILDWINDOWDATA.fNotOnDisk,FALSE
		;-----------------------------------
		
		Invoke CreateFile,lpFileName,0,FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		PUSH EAX
		LEA EDX,[EBX].CHILDWINDOWDATA.FileTime
		Invoke GetFileTime,EAX, NULL, NULL,EDX
		POP EAX
		Invoke CloseHandle,EAX
		
		MOV EAX,TRUE
	.Else
		Invoke MessageBox,WinAsmHandles.hMain,Offset szCannotSaveFile, Offset szAppName, MB_OK
		MOV EAX,FALSE
	.EndIf
	RET
SaveFile EndP

;Returns TRUE if file saved, FALSE otherwise
SaveEditAs Proc Uses EDI hChild:DWORD,lpFileName:DWORD,lpSaveASDialogTitle:DWORD
Local ofn				:OPENFILENAME
Local Buffer[MAX_PATH]	:BYTE
Local Buffer1[MAX_PATH]	:BYTE
	
	Invoke GetWindowLong,hChild,0
	MOV EDI,EAX

	Invoke ReplaceSlashWithBackSlash,lpFileName
	
	;Zero out the ofn struct
	Invoke RtlZeroMemory,ADDR ofn,SizeOf ofn
	;Setup the ofn struct
	MOV ofn.lStructSize,SizeOf ofn
	PUSH WinAsmHandles.hMain
	POP ofn.hwndOwner
	PUSH hInstance
	POP ofn.hInstance
	MOV ofn.lpstrFilter,Offset AddOpenSaveFilesFilter
	
	MOV Buffer[0],0	;improtant - do not remove!!!!

	.If [EDI].CHILDWINDOWDATA.dwTypeOfFile<101	;i.e. part of the current project
		.If ProjectPath[0]	;i.e. project already saved
			MOV ofn.lpstrInitialDir, Offset ProjectPath
		.Else
			MOV ofn.lpstrInitialDir, Offset InitDir
		.EndIf
	.Else
		.If [EDI].CHILDWINDOWDATA.fNotOnDisk==FALSE
			Invoke lstrcpy, ADDR Buffer, lpFileName
		.Else
			;No!!!!
			;i.e. Initial directory will be WinAsm Studio's folder
			;MOV ofn.lpstrInitialDir, Offset szAppFilePath
			;let it start with recently used folder
		.EndIf
	.EndIf
	
	Invoke GetTypeOfFile, lpFileName
	MOV ofn.nFilterIndex,EAX
	
	LEA EAX,Buffer
	;Not that if buffer contains a file name, then its path is used as the Initial directory
	MOV ofn.lpstrFile, EAX
	MOV ofn.nMaxFile,SizeOf Buffer
	MOV EAX, lpSaveASDialogTitle
	MOV ofn.lpstrTitle,EAX

	MOV ofn.Flags,OFN_EXPLORER OR OFN_FILEMUSTEXIST OR OFN_HIDEREADONLY OR OFN_PATHMUSTEXIST OR OFN_OVERWRITEPROMPT;OFN_ENABLEHOOK OR 

	MOV ofn.lpstrDefExt,NULL
	
	;Show Save As dialog
	Invoke GetSaveFileName,ADDR ofn
	.If EAX
		;If user did not specify extension and filter is not "All Files"
		.If ofn.nFileExtension==0 && ofn.nFilterIndex!=7
			.If ofn.nFilterIndex==1
				Invoke lstrcat, ADDR Buffer, Offset szExtAsm
			.ElseIf ofn.nFilterIndex==2
				Invoke lstrcat, ADDR Buffer, Offset szExtInc
			.ElseIf ofn.nFilterIndex==3
				Invoke lstrcat, ADDR Buffer, Offset szExtRc
			.ElseIf ofn.nFilterIndex==4
				Invoke lstrcat, ADDR Buffer, Offset szExtTxt
			.ElseIf ofn.nFilterIndex==5
				Invoke lstrcat, ADDR Buffer, Offset szExtDef
			.Else
				Invoke lstrcat, ADDR Buffer, Offset szExtBat
			.EndIf
		.EndIf
		
		.If [EDI].CHILDWINDOWDATA.dwTypeOfFile<101	;i.e. part of the current project
			Invoke lstrlen,Offset ProjectPath
			.If EAX
				PUSH EBX
				MOV EBX,EAX
				LEA EDX,Buffer
				ADD EBX,EDX
				
				MOV CL,BYTE PTR [EBX]
				PUSH ECX
				MOV BYTE PTR [EBX],0
				Invoke lstrcmpi,Offset ProjectPath,EDX
				.If !EAX	;i.e. equal
					INC EBX	;since BYTE PTR [EBX]=0 now
					Invoke ReplaceBackSlashWithSlash,EBX
					DEC EBX
				.EndIf
				POP ECX
				MOV BYTE PTR [EBX],CL
				POP EBX
			.EndIf
		.EndIf
		
		Invoke SaveFile,hChild,ADDR Buffer
		
		.If EAX	;i.e. file saved
			Invoke lstrcpy,ADDR [EDI].CHILDWINDOWDATA.szFileName,ADDR Buffer
			MOV EAX,TRUE
		.EndIf
		
	;.Else	;NOT needed EAX is already FALSE
	;	MOV EAX,FALSE
	.EndIf
	RET
SaveEditAs EndP

;Returns TRUE if file saved, FALSE otherwise
SaveEdit Proc hChild:DWORD,lpFileName:DWORD
	Invoke GetWindowLong,hChild,0
	.If [EAX].CHILDWINDOWDATA.fNotOnDisk==FALSE	;It is On Disk
		Invoke SaveFile,hChild,lpFileName
	.Else	;It is NOT On Disk
		Invoke SaveEditAs,hChild,lpFileName,Offset szSaveFileAsDialogTitle
		.If EAX
			Invoke SetTvItemAndWindowCaption, hChild
			MOV EAX,TRUE
		.EndIf
	.EndIf
	RET
SaveEdit EndP

;Returns TRUE if answer is YES, FALSE otherwise
AskToSaveFile Proc Uses EBX hChild:DWORD
Local Buffer[512]:BYTE
Local szQuestionMark[2]:BYTE

	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_GETMODIFY,0,0
	.If EAX
		Invoke lstrcpy,ADDR Buffer,Offset szAskToSaveFileChanges
		Invoke lstrcat,ADDR Buffer,ADDR [EBX].CHILDWINDOWDATA.szFileName
		MOV AX,'?'
		MOV WORD PTR szQuestionMark,AX
		Invoke lstrcat,ADDR Buffer,ADDR szQuestionMark
		Invoke MessageBox,WinAsmHandles.hMain,ADDR Buffer,Offset szAppName,MB_YESNO or MB_ICONQUESTION
		.If EAX==IDYES
			MOV EAX,TRUE
		.Else
		    MOV EAX,FALSE
		.EndIf
	;.Else	Already FALSE
		;MOV EAX,FALSE
	.EndIf
	RET
AskToSaveFile EndP

LoadFile Proc hWin:DWORD,lpFileName:DWORD
Local hFile		:DWORD
Local EditStream:EDITSTREAM
Local chrg		:CHARRANGE

	;Open the file
	Invoke CreateFile,lpFileName,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.If EAX!=INVALID_HANDLE_VALUE
		MOV hFile,EAX
		;Copy Buffer to FileName
		Invoke lstrcpy,Offset FileName,lpFileName
		;stream the text into the RAEdit control
		PUSH hFile
		POP EditStream.dwCookie
		MOV EditStream.pfnCallback,Offset StreamInProc
		Invoke SendMessage,hWin,EM_STREAMIN,SF_TEXT,ADDR EditStream
		
		
		Invoke GetParent,hWin
		Invoke GetWindowLong,EAX,0
		LEA EDX,[EAX].CHILDWINDOWDATA.FileTime
		Invoke GetFileTime,hFile, NULL, NULL,EDX
		
		Invoke CloseHandle,hFile
		Invoke SendMessage,hWin,EM_SETMODIFY,FALSE,0
		MOV chrg.cpMin,0
		MOV chrg.cpMax,0
		Invoke SendMessage,hWin,EM_EXSETSEL,0,ADDR chrg
		MOV EAX,FALSE
	.Else
		;Invoke lstrcat,Offset ErrorLoadingFile,lpFileName
		Invoke MessageBox,WinAsmHandles.hMain,Offset ErrorLoadingFile,Offset szAppName,MB_OK OR MB_ICONERROR
		
		MOV EAX,TRUE
	.EndIf
	RET
LoadFile EndP

AddOpenExistingFile Proc Uses EBX ESI lpFileName:DWORD, IsAddFiles:DWORD
Local dwTypeOfFile:DWORD

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   by shoorick
;-----------------------------------------------------------------------
    CMP KeyWordsLoaded,0
    JNE KeyWordsAlreadyLoaded
    Invoke GetKeyWords
    Invoke GetAPIFunctions	
    Invoke GetAPIStructures
    Invoke GetAPIConstants
KeyWordsAlreadyLoaded:                 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	Invoke lstrcpy,ADDR FileName,lpFileName
	
	Invoke GetTypeOfFile, lpFileName
	.If !IsAddFiles
		ADD EAX,100	;i.e for opening files I will use the dwTypeOfFile+100
	.EndIf
	MOV dwTypeOfFile,EAX

	MOV ECX,MDIS_ALLCHILDSTYLES or WS_CLIPCHILDREN
	OR ECX,OpenChildStyle
	Invoke CreateWindowEx,WS_EX_MDICHILD,ADDR szChildClass,lpFileName,ECX,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,hClient,NULL,hInstance,dwTypeOfFile
	PUSH EAX
	
	Invoke GetWindowLong,EAX,0
	MOV EBX,EAX
	Invoke LoadFile,hEditor,lpFileName
	.If dwTypeOfFile==1 || dwTypeOfFile==2 || dwTypeOfFile==101 || dwTypeOfFile==102
		Invoke SetAllBlocks,hEditor
		Invoke UpdateProcCombo,hEditor,[EBX].CHILDWINDOWDATA.hCombo
	.EndIf
	.If dwTypeOfFile==1 || dwTypeOfFile==2
		Invoke UpdateBlocksList,hEditor
	.EndIf
	Invoke SetFocus,hEditor
	
	POP EAX
	.If (dwTypeOfFile==3 || dwTypeOfFile==103) && hRCEditorWindow==0
		MOV hRCEditorWindow,EAX
		Invoke GetResources
		.If AutoToolAndOptions
			Invoke ShowWindow,hToolBox,SW_SHOW
			Invoke ShowWindow,hRCOptions,SW_SHOW
		.EndIf
	.EndIf

	RET
AddOpenExistingFile EndP

OpenEdit Proc Uses EBX EDI ESI lpCaption:DWORD
Local ofn				:OPENFILENAME
Local Buffer[MAX_PATH]	:BYTE
Local IsAddFiles		:DWORD

	;Zero out the ofn struct
	Invoke RtlZeroMemory,ADDR ofn,SizeOf ofn
	Invoke RtlZeroMemory,ADDR tmpBuffer2,SizeOf tmpBuffer2-1	;VERY importanrt
	;Setup the ofn struct
	MOV ofn.lStructSize,SizeOf ofn
	PUSH WinAsmHandles.hMain
	POP ofn.hwndOwner
	PUSH hInstance
	POP ofn.hInstance
	MOV ofn.lpstrFilter,Offset AddOpenSaveFilesFilter
	MOV ofn.lpstrFile,Offset tmpBuffer2
	MOV ofn.nMaxFile,SizeOf tmpBuffer2
	MOV ofn.lpstrDefExt,NULL
	MOV ofn.nFilterIndex,7

	M2M ofn.lpstrTitle,lpCaption

	Invoke lstrcmp,lpCaption,Offset szOpenFilesDialogTitle
	;.If EAX==0  means this is an "Open Files" - NOT Add Files
	MOV IsAddFiles,EAX
	
	;MOV ofn.lpstrInitialDir, ???????? OK, let it start with recently used folder

	;MOV ofn.lpfnHook, Offset GetSaveOpenHook
	MOV ofn.Flags,OFN_EXPLORER OR OFN_FILEMUSTEXIST OR OFN_HIDEREADONLY OR OFN_PATHMUSTEXIST OR OFN_ALLOWMULTISELECT; or OFN_ENABLEHOOK; OR 
	;Show the Open dialog
	Invoke GetOpenFileName,ADDR ofn
	.If EAX
		.If IsAddFiles	;i.e. User Adds files now
			MOV ProjectModified,TRUE
		.EndIf
		
		XOR EBX,EBX
		MOV BX,ofn.nFileOffset
		DEC EBX
		.If tmpBuffer2[EBX]=="\" ;it means user selected only one file
			MOV bThisFileIsAlreadyInTheProject,FALSE
			
			MOV ESI,Offset tmpBuffer2
			CALL ManipulateFileName
			
			Invoke EnumProjectItemsExtended,Offset IsThisFileAlreadyInTheProject,ADDR tmpBuffer2 
			.If bThisFileIsAlreadyInTheProject==FALSE
				Invoke AddOpenExistingFile,Offset tmpBuffer2, IsAddFiles
			.EndIf
		.Else	;user selected more then one files
			MOV EDI,Offset tmpBuffer2
			Invoke lstrcpy,ADDR Buffer,EDI
			.If EBX==3
				INC EDI
				DEC EBX
			.Else
				MOV Buffer[EBX],"\"
			.EndIf
			
			LEA ESI,Buffer
			CALL ManipulateFileName
			
			INC EBX
			ADD EDI,EBX
			
			Invoke LockWindowUpdate,WinAsmHandles.hMain
			
			GetNewFileName:
			;--------------
			MOV Buffer[EBX],0
			;Now Buffer holds path with "\" at the end
			;Invoke lstrcat,ADDR Buffer,EDI
			Invoke lstrcat,ESI,EDI
			
			MOV bThisFileIsAlreadyInTheProject,FALSE
			Invoke EnumProjectItemsExtended,Offset IsThisFileAlreadyInTheProject,ESI;ADDR Buffer 
			.If bThisFileIsAlreadyInTheProject==FALSE
				Invoke AddOpenExistingFile,ESI, IsAddFiles
			.EndIf
			
			@@:
			INC EDI
			.If BYTE PTR [EDI]!=0
				JMP @B
			.Else
				INC EDI
				.If BYTE PTR [EDI]!=0
					JMP GetNewFileName
				.EndIf
			.EndIf
			Invoke LockWindowUpdate,0
		.EndIf
	.EndIf
	RET
	
	ManipulateFileName:
	.If IsAddFiles
		Invoke lstrlen,Offset ProjectPath
		.If EAX
			PUSH EBX
			MOV EBX,EAX
			
			;ESI is the pointer to the filename
			ADD EBX,ESI
			
			MOV CL,BYTE PTR [EBX]
			PUSH ECX
			MOV BYTE PTR [EBX],0
			Invoke lstrcmpi,Offset ProjectPath,ESI
			.If !EAX	;i.e. equal
				INC EBX	;since BYTE PTR [EBX]=0 now
				Invoke ReplaceBackSlashWithSlash,EBX
				DEC EBX
			.EndIf
			POP ECX
			MOV BYTE PTR [EBX],CL
			POP EBX
		.EndIf
	.EndIf
	RETN
OpenEdit EndP

HanldeToolAndOptions Proc Uses EBX

	.If AutoToolAndOptions
		Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
		MOV EBX,SW_HIDE
		.If EAX && EAX==hRCEditorWindow
			Invoke IsWindowVisible,EAX
			.If EAX
				MOV EBX,SW_SHOW
			.EndIf
		.EndIf
		Invoke ShowWindow,hToolBox,EBX
		Invoke ShowWindow,hRCOptions,EBX
	.EndIf

	RET
HanldeToolAndOptions EndP

ClearProject Proc Uses EBX EDI ESI
Local szCounter[12]		:BYTE
Local ChldWndPlcmnt		:CHILDWINDOWPLACEMENT

	MOV fClosingProject,TRUE
	Invoke LockWindowUpdate,WinAsmHandles.hMain
	Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,FALSE,0
	Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETREDRAW,FALSE,0
	
	Invoke WritePrivateProfileSection, Offset szSHOWFILE,NULL,Offset FullProjectName

	XOR ESI,ESI	;Counter
	Invoke GetTopWindow,hClient
	MOV EDI,EAX
	@@:
	.If EDI
		Invoke GetWindowLong,EDI,0
		MOV EBX,EAX
		.If [EBX].CHILDWINDOWDATA.dwTypeOfFile<101	;i.e. file is part of the project; NOT External file
			.If EDI==hRCEditorWindow
				Invoke ClearRCEditor
			.EndIf
			MOV EAX,[EBX].CHILDWINDOWDATA.dwFileNumber
			.If EAX		;<--LOOK!! (if=0 means that a file added has not been saved in the wap, so IGNORE IT)
				Invoke IsWindowVisible,EDI
				.If EAX
					MOV ChldWndPlcmnt.Joker,ESI	;Joker=ZOrder
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_GETFIRSTVISIBLELINE,0,0
					MOV ChldWndPlcmnt.dwLine,EAX
					Invoke IsZoomed,EDI
					.If EAX
						MOV ChldWndPlcmnt.dwState,SW_SHOWMAXIMIZED
						Invoke SendMessage,hClient,WM_MDIRESTORE,EDI,0
					.Else
						Invoke IsIconic,EDI
						.If EAX
							MOV ChldWndPlcmnt.dwState,SW_SHOWMINIMIZED
							Invoke SendMessage,hClient,WM_MDIRESTORE,EDI,0
						.Else
							MOV ChldWndPlcmnt.dwState,SW_SHOWNORMAL
						.EndIf
					.EndIf
					Invoke GetWindowRect,EDI,ADDR ChldWndPlcmnt.rcPosAndSize
					Invoke MapWindowPoints,NULL,hClient,ADDR ChldWndPlcmnt.rcPosAndSize,2
					
					;MOV EAX,[EBX].CHILDWINDOWDATA.dwFileNumber
					Invoke BinToDec,[EBX].CHILDWINDOWDATA.dwFileNumber,ADDR szCounter
					Invoke WritePrivateProfileStruct,Offset szSHOWFILE,ADDR szCounter,ADDR ChldWndPlcmnt,SizeOf CHILDWINDOWPLACEMENT,Offset FullProjectName
					INC ESI	;Counter
				.EndIf
			.EndIf
		.EndIf
		Invoke GetWindow,EDI,GW_HWNDNEXT
		PUSH EAX
		.If [EBX].CHILDWINDOWDATA.dwTypeOfFile<101
			Invoke SendMessage,hClient,WM_MDIDESTROY,EDI,0
		.EndIf
		POP EDI
		JMP @B
	.EndIf

	;Delete all Blocks
	Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_DELETEALLITEMS,0,0
	;Delete all Project Tree Items
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_DELETEITEM,0,hParentItem
	
	MOV hParentItem,0
	MOV hASMFilesItem,0
	MOV hModulesItem,0
	MOV hIncludeFilesItem,0
	MOV hResourceFilesItem,0
	MOV hTextFilesItem,0
	MOV hDefFilesItem,0
	MOV hBatchFilesItem,0
	MOV hOtherFilesItem,0
	
	MOV NrOfErrors,0
	MOV AutoIncFileVersion,0
	MOV ProjectPath[0],0
	MOV ProjectModified,FALSE
	
	MOV FullProjectName[0],0
	MOV ProjectModified,0
	MOV CompileRC[0],0
	MOV RCToObj[0],0
	
	MOV szReleaseAssemble[0],0
	MOV szReleaseLink[0],0
	MOV szReleaseOutCommand[0],0
	MOV szReleaseCommandLine[0],0
	
	MOV szDebugAssemble[0],0
	MOV szDebugLink[0],0
	MOV szDebugOutCommand[0],0
	MOV szDebugCommandLine[0],0
	MOV bRCSilent,FALSE
	MOV bPellesTools,FALSE
	
	Invoke SetWindowText,WinAsmHandles.hMain,Offset szAppName	;Thanks shantanu_gadgil
	
	
	Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETREDRAW,TRUE,0
	Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,TRUE,0
	Invoke LockWindowUpdate,0
	;Invoke DoEvents
	MOV fClosingProject,FALSE
	
	Invoke HanldeToolAndOptions
	
;	.If proc_info.hProcess
;		Invoke SendMessage,hMakeTB,TB_SETCMDID,4,IDM_MAKE_EXECUTE
;		Invoke SendMessage,hMakeTB,TB_CHANGEBITMAP,IDM_MAKE_EXECUTE,23
;		Invoke InvalidateRect,hMakeTB,NULL,TRUE
;
;		Invoke CloseHandle,proc_info.hThread
;		Invoke CloseHandle,proc_info.hProcess
;		MOV proc_info.hProcess,0
;	.EndIf

	Invoke SendCallBackToAllAddIns,pAddInsFrameProcedures,WinAsmHandles.hMain,WAM_DIFFERENTCURRENTPROJECT,0,0

    RET
ClearProject EndP

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   by shoorick
;-----------------------------------------------------------------------
ForceDefault Macro _ApplicationName,_KeyName,_Default,_ReturnedString,_Size,_FileName
	Invoke GetPrivateProfileString,_ApplicationName,_KeyName,ADDR szNULL,_ReturnedString,_Size,_FileName
    or  eax,eax
    jnz @F
    invoke lstrcpy,_ReturnedString,_Default
@@:
EndM
;-----------------------------------------------------------------------
;   EBX - TempBuffer
;
LoadKeyWords Macro pKeyFileName,_KeyFileName,xKeyFileName,szKeyFileName
	mov pKeyFileName,_KeyFileName
	Invoke GetPrivateProfileString,ESI,szKeyFileName,ADDR szNULL,EBX,MAX_PATH,EDI
	or  eax,eax
	jz  @F
    mov eax,xKeyFileName
    mov pKeyFileName,eax
    call ResolvePath
@@:	
EndM
;-----------------------------------------------------------------------
;
;-----------------------------------------------------------------------
ResolvePath proc
    mov byte ptr [eax],0
    cmp byte ptr [ebx],":"
    jne @F
    inc ebx
    invoke lstrcpy,eax,Offset szAppFilePath
    invoke lstrcat,eax,ebx
    dec ebx    
    ret
@@:
    cmp byte ptr [ebx],"%"
    jne @F
    invoke ExpandEnvironmentStrings,ebx,eax,MAX_PATH
    ret
@@:
    invoke lstrcpy,eax,ebx
    ret        
ResolvePath endp
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

OpenWAP Proc Uses ESI EBX EDI lpBuffer:DWORD
Local pTemp					:DWORD
Local dwCounter				:DWORD
Local Buffer[MAX_PATH+1]	:BYTE

Local dwTypeOfFile			:DWORD	;i.e. 1=asm, 2=inc, 3=rc, 4=txt, etc


Local hMDIChild				:DWORD
Local chrg					:CHARRANGE

Local lpChldWndPlcmnt		:DWORD
Local ChldWndPlcmnt			:CHILDWINDOWPLACEMENT

Local TempBuffer[MAX_PATH+1]:BYTE

Local CounterBuffer[12]		:BYTE


	Invoke ClearProject
	LEA EAX,TempBuffer
	MOV pTemp,EAX
	
	
	Invoke GetFileAttributes,lpBuffer
	.If EAX!=0FFFFFFFFh	;e.g. when project name does not exist
		Invoke LoadCursor,0,IDC_WAIT
		Invoke SetCursor,EAX
		
		Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szLoadingProject
		;Invoke ShowWindow,hClient,SW_HIDE
		
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,1024 * (SizeOf CHILDWINDOWPLACEMENT)
		MOV lpChldWndPlcmnt,EAX
		
		
		MOV CanShowMDIChildren,FALSE
		Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,FALSE,0
		Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETREDRAW,FALSE,0
		
		;[Get the Project path]
		Invoke GetFilePath, lpBuffer, Offset ProjectPath
		
		;If running from the command prompt and user did not specify path
		.If ProjectPath[0]==0
			;Set path to current directory
			Invoke GetCurrentDirectory,MAX_PATH,Offset ProjectPath
			Invoke lstrlen,Offset ProjectPath
			DEC EAX
			.If BYTE PTR ProjectPath[EAX]!="\"
				INC EAX
				MOV BYTE PTR ProjectPath[EAX],"\"
				INC EAX
				MOV BYTE PTR ProjectPath[EAX],0
			.EndIf
			Invoke lstrcpy, ADDR Buffer, Offset ProjectPath
			Invoke lstrcat, ADDR Buffer,lpBuffer
			Invoke lstrcpy, lpBuffer, ADDR Buffer
		.EndIf
		
		Invoke lstrcpy, Offset FullProjectName,lpBuffer
		
		
		;---------------------------------------------------------------
		Invoke GetFilesTitle,Offset FullProjectName, Offset ProjectTitle
		Invoke RemoveFileExt, Offset ProjectTitle
		Invoke SetMainWindowCaption
		
		Invoke GetPrivateProfileInt,Offset szASSEMBLER,Offset szFasmProcStyle,0,Offset FullProjectName
		.If EAX
			MOV FasmProcStyle,TRUE
		.EndIf
		
		Invoke GetPrivateProfileInt,Offset szPROJECT,Offset szRCSilent,0,Offset FullProjectName
		.If EAX
			MOV bRCSilent,TRUE
		.EndIf
		
		Invoke GetPrivateProfileInt,Offset szPROJECT,Offset szPellesTools,0,Offset FullProjectName
		.If EAX
			MOV bPellesTools,TRUE
		.EndIf
		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   by shoorick
;-----------------------------------------------------------------------
	MOV ESI, Offset szASSEMBLER
	MOV EDI, Offset FullProjectName
	LEA EBX, [TempBuffer]
;-----------------------------------------------------------------------
	ForceDefault ESI, Offset szProcDef, Offset dszProc,Offset szProc, 32,EDI
	ForceDefault ESI, Offset szEndPDef, Offset dszEndp,Offset szEndp, 32,EDI
	ForceDefault ESI, Offset szMacroDef, Offset dszMacro,Offset szMacro, 32,EDI
	ForceDefault ESI, Offset szEndmDef, Offset dszEndm,Offset szEndm, 32,EDI
	ForceDefault ESI, Offset szStructDef, Offset dszStruct,Offset szStruct, 32,EDI
	ForceDefault ESI, Offset szEndsDef, Offset dszEnds,Offset szEnds, 32,EDI
;-----------------------------------------------------------------------
    LoadKeyWords pKeyWordsFileName,Offset KeyWordsFileName,Offset xKeyWordsFileName,Offset szKeyFile
    LoadKeyWords pAPIFunctionsFile,Offset APIFunctionsFile,Offset xAPIFunctionsFile,Offset szAPIFunctionsFile
    LoadKeyWords pAPIStructuresFile,Offset APIStructuresFile,Offset xAPIStructuresFile,Offset szAPIStructuresFile
    LoadKeyWords pAPIConstantsFile,Offset APIConstantsFile,Offset xAPIConstantsFile,Offset szAPIConstantsFile
    LoadKeyWords pIncludePath,Offset IncludePath,Offset xIncludePath,Offset szIncludePath
;-----------------------------------------------------------------------
    Invoke GetKeyWords
    Invoke GetAPIFunctions	
    Invoke GetAPIStructures
    Invoke GetAPIConstants
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		MOV dwCounter,0
		
		LEA EDI,Buffer
		@@:		
		INC dwCounter
		Invoke BinToDec,dwCounter,ADDR CounterBuffer
		Invoke GetPrivateProfileString, Offset szFILES, ADDR CounterBuffer,ADDR szNULL,pTemp,MAX_PATH+1,Offset FullProjectName
		.If EAX!=0		
			MOV ESI,pTemp
			.If BYTE PTR [ESI]=="*"
				INC ESI
			.EndIf
			
			Invoke GetFilePath, ESI,EDI	;Buffer now holds Path
			.If BYTE PTR [EDI]==0;.If Buffer[0]==0		;i.e. path not specified in the project file
				Invoke lstrcpy, Offset FileName, Offset ProjectPath
			.Else
				MOV FileName[0],0
			.EndIf
			Invoke lstrcat,Offset FileName, ESI
			
			Invoke GetFileAttributes,Offset FileName
			.If EAX!=0FFFFFFFFh	;e.g. when file does not exist
				Invoke GetTypeOfFile,Offset FileName
				.If ESI!=pTemp && EAX==1 	;This Is A module!!!!!
					MOV EAX,51
				.EndIf
				MOV dwTypeOfFile,EAX
				
				
				Invoke CreateWindowEx,WS_EX_MDICHILD,Offset szChildClass,Offset FileName,MDIS_ALLCHILDSTYLES OR WS_CLIPCHILDREN,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,hClient,NULL,hInstance,EAX
				MOV hMDIChild,EAX
				
				Invoke GetPrivateProfileStruct,Offset szSHOWFILE,ADDR CounterBuffer,ADDR ChldWndPlcmnt,SizeOf CHILDWINDOWPLACEMENT,Offset FullProjectName
				.If EAX
					MOV EAX,SizeOf CHILDWINDOWPLACEMENT
					MUL ChldWndPlcmnt.Joker	;Joker is ZOrder
					MOV EDX,lpChldWndPlcmnt
					ADD EDX,EAX
					MOV EAX,hMDIChild
					MOV ChldWndPlcmnt.Joker,EAX
					Invoke RtlMoveMemory,EDX,ADDR ChldWndPlcmnt,SizeOf CHILDWINDOWPLACEMENT
				.EndIf
				
				Invoke GetWindowLong,hMDIChild,0
				MOV EDX,dwCounter
				MOV [EAX].CHILDWINDOWDATA.dwFileNumber,EDX
				MOV EBX,[EAX].CHILDWINDOWDATA.hEditor
				MOV ESI,[EAX].CHILDWINDOWDATA.hCombo
				;ESI=hCombo
				
				Invoke LoadFile,EBX,Offset FileName
				.If dwTypeOfFile==1 || dwTypeOfFile==2 || dwTypeOfFile==51
					Invoke SetAllBlocks,EBX
					Invoke UpdateProcCombo,EBX,ESI;hCombo
					Invoke UpdateBlocksList,EBX
				.ElseIf dwTypeOfFile==3
					.If !hRCEditorWindow
						MOV EAX,hMDIChild
						MOV hRCEditorWindow,EAX
						Invoke GetResources
					.EndIf
				.EndIf
				
			.Else
				Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETREDRAW,TRUE,0
				Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,TRUE,0
				Invoke lstrcpy, pTemp, Offset ErrorLoadingFile
				Invoke lstrcat, pTemp, Offset FileName
				Invoke MessageBox,WinAsmHandles.hMain, pTemp, Offset szAppName,MB_OK OR MB_ICONERROR
				Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETREDRAW,FALSE,0
				Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,FALSE,0
			.EndIf
			JMP @B
		.EndIf
		
		MOV CanShowMDIChildren,TRUE
		
		;In case no file will be shown, deselect from project tree
		Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET,NULL		
		
		;Let's show those MDI children that we have to!
		MOV EBX,lpChldWndPlcmnt
		@@:
		.If [EBX].CHILDWINDOWPLACEMENT.Joker	;Now Joker is handle
			ADD EBX,SizeOf CHILDWINDOWPLACEMENT
			JMP @B
		.EndIf
		
		PUSH AutoToolAndOptions
		MOV AutoToolAndOptions,FALSE
		
		Invoke LockWindowUpdate,WinAsmHandles.hMain
		;Invoke ShowWindow,hClient,SW_HIDE

		@@:
		.If EBX>=lpChldWndPlcmnt 
			.If [EBX].CHILDWINDOWPLACEMENT.Joker	;Now Joker is handle
				MOV EDI,[EBX].CHILDWINDOWPLACEMENT.Joker
				MOV EDX,[EBX].CHILDWINDOWPLACEMENT.rcPosAndSize.right
				SUB EDX, [EBX].CHILDWINDOWPLACEMENT.rcPosAndSize.left
				MOV ECX,[EBX].CHILDWINDOWPLACEMENT.rcPosAndSize.bottom
				SUB ECX, [EBX].CHILDWINDOWPLACEMENT.rcPosAndSize.top
				Invoke MoveWindow,[EBX].CHILDWINDOWPLACEMENT.Joker,[EBX].CHILDWINDOWPLACEMENT.rcPosAndSize.left,[EBX].CHILDWINDOWPLACEMENT.rcPosAndSize.top,EDX,ECX,FALSE
				
				Invoke GetWindowLong,[EBX].CHILDWINDOWPLACEMENT.Joker,0
				MOV ESI,EAX
				Invoke SendMessage,[ESI].CHILDWINDOWDATA.hEditor,EM_LINEINDEX,[EBX].CHILDWINDOWPLACEMENT.dwLine,0
				
				MOV chrg.cpMax,EAX
				MOV chrg.cpMin,EAX
				Invoke SendMessage,[ESI].CHILDWINDOWDATA.hEditor,EM_EXSETSEL,0,ADDR chrg
				Invoke SendMessage,[ESI].CHILDWINDOWDATA.hEditor,CHM_VCENTER,0,0
				Invoke SendMessage,hClient,WM_MDIACTIVATE,[EBX].CHILDWINDOWPLACEMENT.Joker,0
				
				;---------------------------------------------------------------
				;NEEEDEEEEEEEEED! for correct toolbar buttons state
				;if project has got only one file
				Invoke ShowWindow,[EBX].CHILDWINDOWPLACEMENT.Joker,SW_SHOWNORMAL
				;---------------------------------------------------------------
				
				Invoke ShowWindow,[EBX].CHILDWINDOWPLACEMENT.Joker,[EBX].CHILDWINDOWPLACEMENT.dwState
				
				
				;NEEEDEEEEEEEEED!
				Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET, [ESI].CHILDWINDOWDATA.hTreeItem
			.EndIf
			SUB EBX,SizeOf CHILDWINDOWPLACEMENT
			JMP @B
		.EndIf
		
		POP AutoToolAndOptions
		
		;Invoke ShowWindow,hClient,SW_SHOW
		
		Invoke HanldeToolAndOptions
		
		Invoke LockWindowUpdate,0
		
		
		
		Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,TRUE,0
		Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETREDRAW,TRUE,0
		
		
		
		Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szNULL
		Invoke LoadCursor,0,IDC_ARROW
		Invoke SetCursor,EAX
		
		
		
		
		
		
		
		
		;------------------------------------------
		
		Invoke SendMessage, WinAsmHandles.hProjTree, TVM_EXPAND, TVE_EXPAND, hParentItem
		MOV ESI,Offset szMAKE
		MOV EBX,Offset szNULL
		MOV EDI,Offset FullProjectName
		Invoke GetPrivateProfileString, ESI, Offset szCompileRC, EBX,Offset CompileRC,MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szRCToObj, EBX,Offset RCToObj, MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szAssemble, EBX,Offset szReleaseAssemble,MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szLink, EBX,Offset szReleaseLink,MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szOut, EBX,Offset szReleaseOutCommand, MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szDebAssemble, EBX,Offset szDebugAssemble,MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szDebLink, EBX,Offset szDebugLink,MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szDebOut, EBX,Offset szDebugOutCommand, MAX_PATH,EDI
		Invoke GetPrivateProfileInt, ESI, Offset szActiveBuild, 0,EDI
		MOV ActiveBuild,EAX
		
		MOV ESI,Offset szPROJECT
		Invoke GetPrivateProfileString, ESI, Offset szRelComLn, Offset szNULL,Offset szReleaseCommandLine, MAX_PATH,EDI
		Invoke GetPrivateProfileString, ESI, Offset szDebComLn, Offset szNULL,Offset szDebugCommandLine, MAX_PATH,EDI
		Invoke GetPrivateProfileInt, ESI, Offset szAutoIncFileVersion, 0,EDI
		MOV AutoIncFileVersion,EAX
		
		;[Get Project Type]
		Invoke GetPrivateProfileInt, ESI, ADDR szType, 0,EDI
		.If EAX>6
			MOV EAX,5
		.EndIf
		MOV ProjectType,EAX
		
		Invoke SetProjectRelatedItems
		
		Invoke SaveToRecent
		Invoke SHAddToRecentDocs,SHARD_PATH,EDI
		
		;------------------------------------------
		Invoke HeapFree,hMainHeap,0,lpChldWndPlcmnt
		
		Invoke SendCallBackToAllAddIns,pAddInsFrameProcedures,WinAsmHandles.hMain,WAM_DIFFERENTCURRENTPROJECT,0,0
		
	.Else
		Invoke lstrcpy, pTemp, Offset ErrorLoadingFile
		Invoke lstrcat, pTemp, lpBuffer
		Invoke MessageBox,WinAsmHandles.hMain, pTemp, Offset szAppName,MB_OK OR MB_ICONERROR
	.EndIf
	

	RET

OpenWAP EndP

OpenProject Proc
Local ofn				:OPENFILENAME
Local Buffer[MAX_PATH]	:BYTE

	;Zero out the ofn struct
	Invoke RtlZeroMemory,ADDR ofn,SizeOf ofn
	;Setup the ofn struct
	MOV ofn.lStructSize,SizeOf ofn
	PUSH WinAsmHandles.hMain
	POP ofn.hwndOwner
	PUSH hInstance
	POP ofn.hInstance
	MOV ofn.lpstrFilter,Offset OpenProjectFilter
	MOV ofn.lpstrInitialDir, Offset InitDir
	
	MOV Buffer[0],0
	LEA EAX,Buffer
	MOV ofn.lpstrFile,EAX
	MOV ofn.nMaxFile,SizeOf Buffer
	MOV ofn.lpstrDefExt,NULL
	MOV ofn.lpstrTitle,Offset szOpenProjectDialogTitle


	MOV ofn.Flags,OFN_EXPLORER OR OFN_FILEMUSTEXIST OR OFN_HIDEREADONLY OR OFN_PATHMUSTEXIST;OFN_ENABLEHOOK OR 
	;Show the Open dialog
	Invoke GetOpenFileName,ADDR ofn
	.If EAX
		Invoke GetFileExtension,ADDR Buffer
		Invoke lstrcmpi,EAX,Offset szExtwap
		.If !EAX
			Invoke DoEvents	;so that open dialog closes
			Invoke OpenWAP, ADDR Buffer;,FALSE
		.Else	;Thanks Qvasimodo
			;"This is not a WinAsm Studio project file (*.wap)."
			Invoke MessageBox,NULL,Offset szNotWinAsmStudioProjectFile,Offset szAppName,MB_OK Or MB_TASKMODAL + MB_ICONERROR
		.EndIf
	.EndIf
	RET
OpenProject EndP

SaveAll Proc Uses EBX EDI ESI bSaveFiles:DWORD
Local tvi				:TVITEM
Local Buffer[MAX_PATH+1]:BYTE
Local szCounter[12]		:BYTE

	
	;Delete Everything from the [FILES] Section.
	Invoke WritePrivateProfileSection, Offset szFILES,NULL,ADDR FullProjectName

	XOR EDI,EDI
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
				MOV ESI,tvi.lParam
				
				Invoke GetWindowLong,ESI,0
				MOV EBX,EAX
				
				.If bSaveFiles
					.If ESI==hRCEditorWindow && RCModified
						Invoke GenerateResourceScript,FALSE
					.EndIf
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_GETMODIFY,0,0
					.If EAX
						Invoke SaveEdit,ESI,ADDR [EBX].CHILDWINDOWDATA.szFileName
						.If EAX	;i.e. File Saved
							Invoke SetTvItemAndWindowCaption,ESI
							.If ESI==hRCEditorWindow
								Invoke SetRCModified,FALSE
							.EndIf
						.Else	;We are here because when SaveWAP invoked
								;Invoke SaveWAP,Don't care,TRUE
								;from "Make" commands while AutoSave is TRUE
								;and this is a file not on disk and user chosen not to save it
						.EndIf
					.EndIf
				.EndIf
				
				.If [EBX].CHILDWINDOWDATA.fNotOnDisk==FALSE	;It is On Disk
					Invoke GetFilePath, ADDR [EBX].CHILDWINDOWDATA.szFileName, ADDR Buffer
					Invoke lstrcmpi, ADDR Buffer, Offset ProjectPath	;i.e File is in the project's folder
					.If EAX==0
						Invoke GetFilesTitle, ADDR [EBX].CHILDWINDOWDATA.szFileName, ADDR Buffer[1]
					.Else
						Invoke lstrcpy, ADDR Buffer[1], ADDR [EBX].CHILDWINDOWDATA.szFileName
					.EndIf
					LEA ECX,Buffer
					.If [EBX].CHILDWINDOWDATA.dwTypeOfFile==51
						MOV BYTE PTR [ECX],"*"
					.Else
						INC ECX
					.EndIf
					
					INC EDI
					PUSH ECX
					Invoke BinToDec,EDI,ADDR szCounter
					POP ECX
					Invoke WritePrivateProfileString, Offset szFILES, ADDR szCounter,ECX, ADDR FullProjectName
					
					MOV [EBX].CHILDWINDOWDATA.dwFileNumber,EDI
				.Else
					Invoke RemoveFileFromProject,ESI,FALSE	;We don't ask here because it must have been saved already from within the AskToSaveFilesDialog
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
	
	MOV EDI,Offset FullProjectName
	MOV ESI,Offset szPROJECT
	Invoke BinToDec,ProjectType,ADDR Buffer
	Invoke WritePrivateProfileString,ESI, Offset szType, ADDR Buffer,EDI
	Invoke WritePrivateProfileString,ESI, Offset szRelComLn, ADDR szReleaseCommandLine,EDI
	Invoke WritePrivateProfileString,ESI, Offset szDebComLn, ADDR szDebugCommandLine,EDI
	Invoke BinToDec,AutoIncFileVersion,ADDR Buffer
	Invoke WritePrivateProfileString,ESI, Offset szAutoIncFileVersion, ADDR Buffer,EDI

	Invoke BinToDec,bRCSilent,ADDR Buffer
	Invoke WritePrivateProfileString,ESI, Offset szRCSilent, ADDR Buffer,EDI

	Invoke BinToDec,bPellesTools,ADDR Buffer
	Invoke WritePrivateProfileString,ESI, Offset szPellesTools, ADDR Buffer,EDI



	MOV ESI,Offset szMAKE
	Invoke BinToDec,ActiveBuild,ADDR Buffer
	Invoke WritePrivateProfileString,ESI, Offset szActiveBuild, ADDR Buffer,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szCompileRC, ADDR CompileRC,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szRCToObj, ADDR RCToObj,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szAssemble, ADDR szReleaseAssemble,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szLink, ADDR szReleaseLink,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szOut, ADDR szReleaseOutCommand,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szDebAssemble, ADDR szDebugAssemble,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szDebLink, ADDR szDebugLink,EDI
	Invoke WritePrivateProfileString,ESI, ADDR szDebOut, ADDR szDebugOutCommand,EDI


	MOV tvi._mask,TVIF_TEXT
	MOV tvi.cchTextMax,MAX_PATH
	MOV tvi.pszText,Offset ProjectTitle
	PUSH hParentItem
	POP tvi.hItem
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SETITEM,0,ADDR tvi
	
	Invoke SetMainWindowCaption

	
	;Must be here NOT at the begining of this proc because in case RemoveFileFromProject was called above
	MOV ProjectModified,FALSE

	RET
SaveAll EndP

;Returns TRUE if wap saved, FALSE otherwise
SaveWAP Proc bForceSaveAs:DWORD, bSaveFiles:DWORD, lpDialogTitle:DWORD
Local ofn				:OPENFILENAME
Local Buffer[MAX_PATH+1]:BYTE

	.If bForceSaveAs
		JMP ShowSaveAsDialog
	.EndIf
	
	Invoke lstrcmpi, ADDR FullProjectName,Offset szNewProjectFile
	.If !EAX	;First Time Save
		
		ShowSaveAsDialog:
		;Zero out the ofn struct
		Invoke RtlZeroMemory,ADDR ofn,SizeOf ofn
		
		;Setup the ofn struct
		MOV ofn.lStructSize,SizeOf ofn
		PUSH WinAsmHandles.hMain
		POP ofn.hwndOwner
		PUSH hInstance
		POP ofn.hInstance
		MOV ofn.lpstrFilter,Offset OpenProjectFilter
		
		.If ProjectPath[0]	;i.e. project already saved
			MOV ofn.lpstrInitialDir, Offset ProjectPath
		.Else
			MOV ofn.lpstrInitialDir, Offset InitDir
		.EndIf
		
		MOV Buffer[0],0
		LEA EAX,Buffer
		MOV ofn.lpstrFile,EAX
		MOV ofn.nMaxFile,SizeOf Buffer
		MOV EDX,lpDialogTitle
		MOV ofn.lpstrTitle,EDX;Offset szSaveProjectAsDialogTitle
		
		MOV ofn.Flags,OFN_EXPLORER OR OFN_FILEMUSTEXIST OR OFN_HIDEREADONLY OR OFN_PATHMUSTEXIST OR OFN_OVERWRITEPROMPT;OFN_ENABLEHOOK
		
		;Show save as dialog
		Invoke GetSaveFileName,ADDR ofn
		.If EAX	;If user did not select Cancel
			Invoke GetFileExtension, ADDR Buffer
			;Now EAX is a pointer to the File extension
			;or 0 if there is no extension
			.If EAX!=0
				Invoke lstrcmpi, EAX, Offset szExtwap
				.If EAX!=0	;i.e if extension is not ".wap", do it!
					Invoke lstrcat, ADDR Buffer, Offset szExtwap
				.EndIf
			.Else	;i.e If there is no extension do it ".wap"!
				Invoke lstrcat, ADDR Buffer, Offset szExtwap
			.EndIf
			
			Invoke CreateFile,ADDR Buffer,GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
			.If EAX!=INVALID_HANDLE_VALUE
				Invoke CloseHandle,EAX
				Invoke lstrcpy,Offset FullProjectName, ADDR Buffer
				Invoke SaveToRecent
				
				Invoke SHAddToRecentDocs,SHARD_PATH,Offset FullProjectName
				
				Invoke GetFilesTitle,Offset FullProjectName,Offset ProjectTitle
				Invoke RemoveFileExt,Offset ProjectTitle
				;[Get the Project path] - So that If user save files, Caption and Project update
				Invoke GetFilePath, Offset FullProjectName, Offset ProjectPath		
				;Save path in ini so that next time
				Invoke SaveAll,bSaveFiles
				MOV EAX,TRUE
			.Else
				;"The project was not saved."
				Invoke MessageBox,WinAsmHandles.hMain,Offset szProjectWasNotSaved,Offset szAppName,MB_OK
				XOR EAX,EAX
			.EndIf
		.EndIf
		
	.Else
		Invoke SaveAll,bSaveFiles
		MOV EAX,TRUE
	.EndIf
	RET
	
SaveWAP EndP