.386

.MODEL FLAT,STDCALL

OPTION CASEMAP:NONE

;DEBUG_BUILD		EQU 1		;Uncomment for debug builds

DIALOGSYMARGIN	EQU	8

;CHANGE IT FOR EVERY NEW VERSION !!!!!!!!!!!!!!!!!!!!!!!!!!!!
WINASMVERSION	EQU 5170
;CHANGE IT FOR EVERY NEW VERSION !!!!!!!!!!!!!!!!!!!!!!!!!!!!

MENUITEMAFTERPRINT	EQU 13

Include WINDOWS.INC          

;------------------------------------------------------------------
WinMain						PROTO :DWORD,	:DWORD,	:DWORD,	:SDWORD
ClientResize				PROTO
SendCallBackToAllAddIns 	PROTO :DWORD,	:DWORD,	:DWORD,	:DWORD,	:DWORD
;------------------------------------------------------------------
GetFileName					PROTO :DWORD,	:DWORD
GetFilesTitle				PROTO :DWORD,	:DWORD
DrawRectangle				PROTO :DWORD,	:DWORD
GetTextRange				PROTO :DWORD,	:DWORD,	:DWORD,	:DWORD
ClearPendingMessages		PROTO :HWND,	:DWORD,	:DWORD
GetFilePath					PROTO :DWORD,	:DWORD
RemoveFileExt				PROTO :DWORD
GetItemParameter			PROTO :HWND,	:DWORD
SetItemParameter			PROTO :HWND,	:DWORD, :DWORD
ChangeCase					PROTO :HWND,	:DWORD
DeleteFiles					PROTO :DWORD,	:DWORD
ReplaceBackSlashWithSlash	PROTO :DWORD
DrawFocusRectangle			PROTO :HWND,	:DWORD
IsThereSuchAClass			PROTO :DWORD
SetColumnsWidth				PROTO :DWORD
RemoveFileFromProject		PROTO :HWND, 	:BOOLEAN
BinToDec					PROTO :DWORD,	:DWORD

;------------------------------------------------------------------

Include WinAsm.inc
Include Misc.asm
Include BrowseProc.asm
Include Find.asm
Include Make.asm
Include FileIO.asm
Include Print.asm
Include Options.asm
Include Managers.asm
Include Intellisense.asm
Include AddIns.asm
Include ODMenus.asm
Include Docking.asm
Include ProjectE.asm
Include RCEditor.asm
;------------------------------------------------------------------

.CODE

Start:
;-----

	Invoke GetModuleHandle,NULL
	MOV hInstance,EAX
	Invoke GetCommandLine
	Invoke WinMain,hInstance,NULL,EAX,SW_SHOWDEFAULT
	Invoke ExitProcess,EAX

FillListWithTemplates Proc Uses EBX lpFolderName:DWORD
Local lvi:LV_ITEM
Local FindData:WIN32_FIND_DATA
Local hFindFile:DWORD

	Invoke SendMessage,hNewProjectList,LVM_DELETEALLITEMS,0,0
	MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE; OR LVIF_STATE
	XOR EBX,EBX
	MOV lvi.iSubItem, 0

	Invoke lstrcpy,Offset tmpBuffer, Offset szAppFilePath
	Invoke lstrcat,Offset tmpBuffer, Offset szInTemplates
	Invoke lstrcat,Offset tmpBuffer, lpFolderName
	Invoke lstrcat,Offset tmpBuffer, Offset szSlashAllFiles
	
	Invoke FindFirstFile, Offset tmpBuffer, ADDR FindData
	.If EAX != INVALID_HANDLE_VALUE
		MOV hFindFile, EAX
		.If (FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			.If BYTE PTR FindData.cFileName != '.'
				CALL AddTheNewTemplate
			.EndIf
		.EndIf
		
		@@:
		Invoke FindNextFile, hFindFile, ADDR FindData
		.If EAX!=0
			.If EAX!= INVALID_HANDLE_VALUE
				.If (FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
					.If BYTE PTR FindData.cFileName != '.'
						CALL AddTheNewTemplate
					.EndIf
				.EndIf
			.EndIf
			JMP @B
		.EndIf
		Invoke FindClose, hFindFile
	.EndIf
	
	Invoke SendMessage, hNewProjectList, LVM_ARRANGE, LVA_ALIGNTOP, 0
	MOV lvi.imask,LVIF_STATE
	MOV lvi.stateMask, LVIS_FOCUSED OR LVIS_SELECTED
	MOV lvi.state,LVIS_FOCUSED OR LVIS_SELECTED
	MOV lvi.iItem,0
	MOV lvi.iSubItem, 0
	Invoke SendMessage, hNewProjectList, LVM_SETITEM, 0, ADDR lvi
	RET
	
	;-----------------------------------------------------------------------
	AddTheNewTemplate:
	;-----------------
	LEA EAX,FindData.cFileName
	MOV lvi.pszText,EAX
	Invoke lstrcpy,Offset tmpBuffer, Offset szAppFilePath
	Invoke lstrcat,Offset tmpBuffer, Offset szInTemplates	;"Templates\"
	Invoke lstrcat,Offset tmpBuffer,lpFolderName
	Invoke lstrcat,Offset tmpBuffer,Offset szSlash
	Invoke lstrcat,Offset tmpBuffer,ADDR FindData.cFileName
	Invoke lstrcat,Offset tmpBuffer,Offset szSlash
	Invoke lstrcat,Offset tmpBuffer,ADDR FindData.cFileName
	Invoke lstrcat,Offset tmpBuffer,Offset szExtwap
	;[Get Project Type]
	Invoke GetPrivateProfileInt, Offset szPROJECT, ADDR szType, -1,Offset tmpBuffer
	.If EAX!=-1	;i.e either a wap (with the same name as its folder) is not found or Project Type is not specified in this file(rare)
		MOV lvi.iImage, EAX
		MOV lvi.iItem,EBX
		Invoke SendMessage,hNewProjectList,LVM_INSERTITEM,0,ADDR lvi
		INC EBX
	.EndIf
	RETN
FillListWithTemplates EndP

FillListWithEmptyProjects Proc
Local lvi:LV_ITEM
	Invoke SendMessage,hNewProjectList,LVM_DELETEALLITEMS,0,0
	MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE OR LVIF_STATE
	MOV lvi.state,LVIS_FOCUSED OR LVIS_SELECTED
	MOV lvi.iItem,0
	MOV lvi.iSubItem, 0
	MOV lvi.pszText,Offset szStandardEXE
	MOV lvi.iImage, 0
	CALL InsertIt

	MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE
	MOV lvi.iItem,1
	MOV lvi.pszText, Offset szStandardDLL
	MOV lvi.iImage, 1
	CALL InsertIt
	
	MOV lvi.iItem,2
	MOV lvi.pszText, Offset szConsoleApplication
	MOV lvi.iImage, 2
	CALL InsertIt
	
	MOV lvi.iItem,3
	MOV lvi.pszText, Offset szStaticLibrary
	MOV lvi.iImage,3
	CALL InsertIt
	
	MOV lvi.iItem,4
	MOV lvi.pszText, Offset szOtherExe
	MOV lvi.iImage,4
	CALL InsertIt
	
	MOV lvi.iItem,5
	MOV lvi.pszText, Offset szOtherNotExe
	MOV lvi.iImage,5
	CALL InsertIt


	MOV lvi.iItem,6
	MOV lvi.pszText,Offset szDOSProject
	MOV lvi.iImage,6
	CALL InsertIt

	Invoke SendMessage, hNewProjectList, LVM_ARRANGE, LVA_ALIGNTOP, 0

	RET
	
	;------------------------------------------------------------------------
	InsertIt:
	Invoke SendMessage,hNewProjectList,LVM_INSERTITEM,0,ADDR lvi
	RETN
FillListWithEmptyProjects EndP

ProjectPropertiesDlgProc_InitDialog Proc hWnd    :DWORD, IsNewProjectDialog:DWORD
Local FindData			:WIN32_FIND_DATA
Local hFindFile			:DWORD
	
	MOV TabCtrlItem.imask,TCIF_TEXT

	;Get handles
	Invoke GetDlgItem,hWnd,IDC_NEWPROJECTLIST
	MOV hNewProjectList,EAX

	Invoke GetDlgItem,hWnd,IDC_TABCONTROL
	MOV hTabControl,EAX
	
	Invoke GetDlgItem,hWnd,IDC_LABELRC
	MOV hLabelRC, EAX
	Invoke GetDlgItem,hWnd,IDC_TEXTRC
	MOV hTextRC,EAX
	Invoke GetDlgItem,hWnd,IDC_TEXTCVTRES
	MOV hTextCVTRES, EAX
	Invoke GetDlgItem,hWnd,IDC_LABELCVTRES
	MOV hLabelCVTRES, EAX


	Invoke GetDlgItem,hWnd,IDC_TEXTML
	MOV hReleaseTextML, EAX
	Invoke GetDlgItem,hWnd,IDC_TEXTLINK
	MOV hReleaseTextLINK, EAX
	Invoke GetDlgItem,hWnd,IDC_TEXTOUT
	MOV hReleaseTextOUT, EAX
	Invoke GetDlgItem,hWnd,IDC_LABELML
	MOV hLabelML, EAX
	Invoke GetDlgItem,hWnd,IDC_LABELLINK
	MOV hLabelLINK, EAX
	Invoke GetDlgItem,hWnd,IDC_LABELOUT
	MOV hLabelOUT, EAX

	Invoke GetDlgItem,hWnd,23
	MOV hDebugTextML, EAX
	Invoke GetDlgItem,hWnd,25
	MOV hDebugTextLINK, EAX
	Invoke GetDlgItem,hWnd,27
	MOV hDebugTextOUT, EAX

	Invoke GetDlgItem,hWnd,28
	MOV hDividerLine, EAX

	Invoke GetDlgItem,hWnd,29
	MOV hReleaseTextCommandLine, EAX

	
	Invoke GetDlgItem,hWnd,30
	MOV hLabelCommandLine, EAX
	
	Invoke GetDlgItem,hWnd,31
	MOV hDebugTextCommandLine, EAX

	Invoke GetDlgItem,hWnd,32
	MOV hChkSilently, EAX

	Invoke GetDlgItem,hWnd,33
	MOV hPellesTools, EAX

	.If !IsNewProjectDialog
		MOV TabCtrlItem.pszText, Offset szDebugMakeOptions
		Invoke SendMessage,hTabControl,TCM_INSERTITEM,0,Offset TabCtrlItem
		
		MOV TabCtrlItem.pszText, Offset szReleaseMakeOptions
		Invoke SendMessage,hTabControl,TCM_INSERTITEM,0,Offset TabCtrlItem
		
		MOV TabCtrlItem.pszText, Offset szResourceMakeOptions
		Invoke SendMessage,hTabControl,TCM_INSERTITEM,0,Offset TabCtrlItem
		
		MOV TabCtrlItem.pszText, Offset szProjectType
	.Else
		Invoke lstrcpy,Offset tmpBuffer, Offset szAppFilePath
		Invoke lstrcat,Offset tmpBuffer, Offset szInTemplatesAllFiles	;"Templates\*.*"
		
		Invoke FindFirstFile,Offset tmpBuffer, ADDR FindData
		.If EAX != INVALID_HANDLE_VALUE
			MOV hFindFile, EAX
			.If (FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
				.If BYTE PTR FindData.cFileName != '.'
					LEA EAX,FindData.cFileName
					MOV TabCtrlItem.pszText,EAX
					Invoke SendMessage,hTabControl,TCM_INSERTITEM,0,Offset TabCtrlItem
				.EndIf
			.EndIf
			
			@@:
			Invoke FindNextFile, hFindFile, ADDR FindData
			.If EAX!=0
				.If EAX!= INVALID_HANDLE_VALUE
					.If (FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
						.If BYTE PTR FindData.cFileName != '.'
							LEA EAX,FindData.cFileName
							MOV TabCtrlItem.pszText,EAX
							Invoke SendMessage,hTabControl,TCM_INSERTITEM,0,Offset TabCtrlItem
						.EndIf
					.EndIf
				.EndIf
				JMP @B
			.EndIf
			
			Invoke FindClose, hFindFile
		.EndIf
		MOV TabCtrlItem.pszText, Offset szEmptyProject
	.EndIf
	Invoke SendMessage,hTabControl,TCM_INSERTITEM,0,Offset TabCtrlItem


	Invoke SendMessage,hTabControl,TCM_SETCURSEL,0,NULL
	;32:	Width of each image			
	;0:		Number of images by which the image list can grow.
	;CLR_DEFAULT:The color of the pixel at the upper-left corner of the image is treated as the mask color.
	;Invoke ImageList_LoadImage, hInstance, IDB_NEWPROJECTLIST, 32, 0,CLR_DEFAULT,IMAGE_BITMAP, LR_LOADTRANSPARENT
	Invoke ImageList_LoadImage, hInstance, IDB_NEWPROJECTLIST, 32, 0,0FFFFFFh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	MOV hNewProjectImageList, EAX
	Invoke SendMessage,hNewProjectList,LVM_SETIMAGELIST,LVSIL_NORMAL, hNewProjectImageList
	
	Invoke FillListWithEmptyProjects
	RET
ProjectPropertiesDlgProc_InitDialog EndP

ShowPropertiesFirstTab Proc fShow:DWORD
	Invoke ShowWindow,hNewProjectList,fShow
    RET
ShowPropertiesFirstTab EndP

ShowPropertiesSecondTab Proc fShow:DWORD
	Invoke ShowWindow,hLabelRC,fShow
	Invoke ShowWindow,hTextRC,fShow
	Invoke ShowWindow,hLabelCVTRES,fShow
	Invoke ShowWindow,hTextCVTRES,fShow
	Invoke ShowWindow,hChkSilently,fShow
	
    RET
ShowPropertiesSecondTab EndP

ShowPropertiesThirdTab Proc fShow:DWORD
	Invoke ShowWindow,hReleaseTextML,fShow
	Invoke ShowWindow,hReleaseTextLINK,fShow
	Invoke ShowWindow,hReleaseTextOUT,fShow
	Invoke ShowWindow,hLabelML,fShow
	Invoke ShowWindow,hLabelLINK,fShow
	Invoke ShowWindow,hLabelOUT,fShow
	Invoke ShowWindow,hDividerLine,fShow
	Invoke ShowWindow,hLabelCommandLine,fShow
	Invoke ShowWindow,hReleaseTextCommandLine,fShow
	Invoke ShowWindow,hPellesTools,fShow
	RET
ShowPropertiesThirdTab EndP

ShowPropertiesFourthTab Proc fShow:DWORD
	Invoke ShowWindow,hDebugTextML,fShow
	Invoke ShowWindow,hDebugTextLINK,fShow
	Invoke ShowWindow,hDebugTextOUT,fShow
	Invoke ShowWindow,hLabelML,fShow
	Invoke ShowWindow,hLabelLINK,fShow
	Invoke ShowWindow,hLabelOUT,fShow
	Invoke ShowWindow,hDividerLine,fShow
	Invoke ShowWindow,hLabelCommandLine,fShow
	Invoke ShowWindow,hDebugTextCommandLine,fShow
	Invoke ShowWindow,hPellesTools,fShow

	RET
ShowPropertiesFourthTab EndP

DoNewProject Proc Uses EBX AddOneEmptyASMFile:DWORD
Local Buffer[MAX_PATH]:BYTE
	
	Invoke lstrcpy,Offset ProjectTitle,Offset szNewProjectTitle
	Invoke lstrcpy,Offset FullProjectName,Offset szNewProjectFile
	Invoke SetMainWindowCaption
	
	.If AddOneEmptyASMFile
		Invoke lstrcpy,Offset FileName,ADDR szNewFile;szNewASMFile
		INC UntitledAsmCounter
		Invoke BinToDec,UntitledAsmCounter,ADDR Buffer
		Invoke lstrcat,Offset FileName,ADDR Buffer
		Invoke lstrcat,Offset FileName,Offset szExtAsm
		MOV ECX,MDIS_ALLCHILDSTYLES or WS_CLIPCHILDREN
		OR ECX,OpenChildStyle
		Invoke CreateWindowEx,WS_EX_MDICHILD ,ADDR szChildClass,ADDR FileName,ECX,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,hClient,NULL,hInstance,1
		;------This is needed so that combo gets one item "Select Procedure or go to Top"
		Invoke GetWindowLong,EAX,0
		MOV EBX,EAX
		Invoke UpdateProcCombo,CHILDWINDOWDATA.hEditor[EAX],CHILDWINDOWDATA.hCombo[EBX]
		MOV [EBX].CHILDWINDOWDATA.fNotOnDisk,1
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SETMODIFY,TRUE,0
		Invoke SetProjectRelatedItems
	.EndIf
	;-----------------------------------------------------------------------
	
	Invoke SendCallBackToAllAddIns,pAddInsFrameProcedures,WinAsmHandles.hMain,WAM_DIFFERENTCURRENTPROJECT,0,0

	MOV ProjectModified, TRUE
	RET
DoNewProject EndP

ProjectPropertiesDlgProc_EndDialog Proc hDlg:DWORD
Local Buffer[32]:BYTE
Local LargeBuffer[MAX_PATH]:BYTE

	Invoke GetWindowText, hDlg, ADDR Buffer, 32
	Invoke lstrcmpi, ADDR Buffer, Offset szNewProjectDialogTitle
	.If EAX!=0 ;i.e This is NOT a New Project Dialog
		Invoke SendMessage, hNewProjectList, LVM_GETNEXTITEM, -1,  LVIS_SELECTED;LVNI_FOCUSED; +
		.If EAX!=ProjectType ;i.e user selected other type of project
			MOV ProjectType,EAX
			MOV ProjectModified,TRUE
		.Else
			MOV ECX,hTextRC
			CALL GetModify
			.If EAX	;i.e If User changed CompileRC arguments
				MOV ProjectModified,TRUE
			.Else
				MOV ECX,hReleaseTextML
				CALL GetModify
				.If EAX
					MOV ProjectModified,TRUE
				.Else
					MOV ECX,hReleaseTextLINK
					CALL GetModify
					.If EAX
						MOV ProjectModified,TRUE
					.Else
						MOV ECX,hTextCVTRES
						CALL GetModify					
						.If EAX
							MOV ProjectModified,TRUE
						.Else
							MOV ECX,hReleaseTextOUT
							CALL GetModify					
							.If EAX
								MOV ProjectModified,TRUE
							.Else
								MOV ECX,hReleaseTextCommandLine
								CALL GetModify
								.If EAX
									MOV ProjectModified,TRUE
								.Else
									MOV ECX,hDebugTextML
									CALL GetModify
									.If EAX
										MOV ProjectModified,TRUE
									.Else
										MOV ECX,hDebugTextLINK
										CALL GetModify
										.If EAX
											MOV ProjectModified,TRUE
										.Else
											MOV ECX,hDebugTextOUT
											CALL GetModify					
											.If EAX
												MOV ProjectModified,TRUE
											.Else
												MOV ECX,hDebugTextCommandLine
												CALL GetModify
												.If EAX
													MOV ProjectModified,TRUE
												.EndIf
											.EndIf
										.EndIf
									.EndIf
								.EndIf
							.EndIf						
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.EndIf
		
		Invoke IsDlgButtonChecked,hDlg,32
		.If EAX!=bRCSilent
			MOV ProjectModified,TRUE
		.EndIf
		MOV bRCSilent,EAX
		
		Invoke IsDlgButtonChecked,hDlg,33
		.If EAX!=bPellesTools
			MOV ProjectModified,TRUE
		.EndIf
		MOV bPellesTools,EAX
		
		
		CALL GetMakeOptions
		Invoke SetProjectRelatedItems
	.Else	;New Project Dialog
		Invoke SendMessage,hTabControl,TCM_GETCURSEL,0,0
		.If EAX==0	;i.e. User selected one Empty Project (non template)
			Invoke ClearProject
			Invoke SendMessage, hNewProjectList, LVM_GETNEXTITEM, -1,LVIS_SELECTED; LVNI_FOCUSED; + 
			MOV ProjectType,EAX
			CALL GetMakeOptions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; by shoorick
;-----------------------------------------------------------------------
            invoke lstrcpy,Offset szProc,Offset dszProc
            invoke lstrcpy,Offset szEndp,Offset dszEndp
            invoke lstrcpy,Offset szMacro,Offset dszMacro
            invoke lstrcpy,Offset szEndm,Offset dszEndm
            invoke lstrcpy,Offset szStruct,Offset dszStruct
            invoke lstrcpy,Offset szEnds,Offset dszEnds
;-----------------------------------------------------------------------
            mov pIncludePath, offset IncludePath
            mov pKeyWordsFileName, offset KeyWordsFileName
            mov pAPIFunctionsFile, offset APIFunctionsFile
            mov pAPIStructuresFile, offset APIStructuresFile
            mov pAPIConstantsFile, offset APIConstantsFile
;-----------------------------------------------------------------------
            Invoke GetKeyWords
            Invoke GetAPIFunctions	
            Invoke GetAPIStructures
            Invoke GetAPIConstants
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			Invoke DoNewProject,TRUE
		.Else
			MOV TabCtrlItem.imask,TCIF_TEXT
			LEA ECX,LargeBuffer
			MOV TabCtrlItem.pszText,ECX
			MOV TabCtrlItem.cchTextMax,SizeOf LargeBuffer-1
			Invoke SendMessage,hTabControl,TCM_GETITEM,EAX,ADDR TabCtrlItem
			
			Invoke RtlZeroMemory,Offset tmpBuffer2,SizeOf tmpBuffer2-1	;so that we have a second zero after the folder end when we copy it
			Invoke RtlZeroMemory,Offset tmpBuffer,SizeOf tmpBuffer-1	;so that we have a second zero after the folder end when we copy it
			
			Invoke lstrcpy,Offset tmpBuffer2, Offset szAppFilePath
			Invoke lstrcat,Offset tmpBuffer2, Offset szInTemplates	;"Templates\"
			Invoke lstrcat,Offset tmpBuffer2, ADDR LargeBuffer
			Invoke lstrcat,Offset tmpBuffer2, Offset szSlash
			Invoke SendMessage, hNewProjectList, LVM_GETNEXTITEM, -1, LVNI_FOCUSED; + LVIS_SELECTED;
			MOV ECX,EAX
			Invoke GetItemText, hNewProjectList,ECX,0,ADDR LargeBuffer
			Invoke lstrcat,Offset tmpBuffer2, ADDR LargeBuffer
			
			Invoke BrowseForAnyFolder,hDlg,0,Offset tmpBuffer
			.If EAX	;i.e. user did not select cancel
				Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szCreatingProject
				Invoke lstrcat,Offset tmpBuffer2,Offset szSlashAllFiles
				Invoke CopyAllFromTo,Offset tmpBuffer2,Offset tmpBuffer
				.If EAX==0	;If the same folder found and user pressed OK or Cancel then EAX<>0
					Invoke lstrlen,Offset tmpBuffer
					.If EAX!=3	;it is 3 if tmpBuffer=C:\, or D:\ etc. In such a case I will not add another slash
						Invoke lstrcat,Offset tmpBuffer, Offset szSlash
					.EndIf
					Invoke lstrcat,Offset tmpBuffer, ADDR LargeBuffer
					Invoke lstrcat,Offset tmpBuffer, Offset szExtwap
					Invoke OpenWAP,Offset tmpBuffer
				.EndIf
				Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szNULL
			.EndIf
		.EndIf
	.EndIf
	RET
	;------------------------------------------------------------------------	
	GetMakeOptions:
	
	
	MOV ECX,hTextRC
	LEA EDX,CompileRC
	CALL GetText

	MOV ECX,hReleaseTextML
	LEA EDX,szReleaseAssemble
	CALL GetText

	MOV ECX,hReleaseTextLINK
	LEA EDX,szReleaseLink
	CALL GetText


	MOV ECX,hDebugTextML
	LEA EDX,szDebugAssemble
	CALL GetText

	MOV ECX,hDebugTextLINK
	LEA EDX,szDebugLink
	CALL GetText

	;Trim any leading spaces
	MOV ECX,hTextCVTRES
	LEA EDX,LineTxt
	CALL GetText
	Invoke LTrim,Offset LineTxt,Offset RCToObj

	;Get ReleaseOutCommand and trim any leading spaces
	MOV ECX,hReleaseTextOUT
	LEA EDX,LineTxt
	CALL GetText
	Invoke LTrim,Offset LineTxt,Offset szReleaseOutCommand
	
	
	;Get DebugOutCommand and trim any leading spaces
	MOV ECX,hDebugTextOUT
	LEA EDX,LineTxt
	CALL GetText
	Invoke LTrim,Offset LineTxt,Offset szDebugOutCommand
	
	MOV ECX,hReleaseTextCommandLine
	LEA EDX,szReleaseCommandLine
	CALL GetText
	
	MOV ECX,hDebugTextCommandLine
	LEA EDX,szDebugCommandLine
	CALL GetText
	RETN
	
	;------------------------------------------------------------------------
	GetModify:
	Invoke SendMessage,ECX,EM_GETMODIFY,0,0
	RETN
	;------------------------------------------------------------------------
	GetText:
	Invoke SendMessage,ECX,WM_GETTEXT,256,EDX
	RETN
	;------------------------------------------------------------------------
ProjectPropertiesDlgProc_EndDialog EndP

;This Dialog Procedure is for both new projects as well as changing the properties of existing ones.
ProjectPropertiesDlgProc Proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
Local Buffer[32]:BYTE

	.If uMsg == WM_INITDIALOG
		;Build the Tab Control with all three tabs
		.If lParam	;If the dialog is for a new project
			Invoke ProjectPropertiesDlgProc_InitDialog, hWnd, TRUE
			Invoke SetWindowText,hWnd, Offset szNewProjectDialogTitle
			
			LEA EDX,szCompileRCNew
			MOV ECX,hTextRC
			CALL SetText
			
			LEA EDX,szReleaseAssembleNew
			MOV ECX,hReleaseTextML
			CALL SetText
			
			LEA EDX,szReleaseLinkNew
			MOV ECX,hReleaseTextLINK
			CALL SetText
			
			;------------------------
			LEA EDX,szDebugAssembleNew
			MOV ECX,hDebugTextML
			CALL SetText
			
			LEA EDX,szDebugLinkNew
			MOV ECX,hDebugTextLINK
			CALL SetText
			
		.Else	;If the dialog is for Project Properties
			Invoke ProjectPropertiesDlgProc_InitDialog, hWnd,FALSE
			MOV ECX,hTextRC
			LEA EDX,CompileRC
			CALL SetText
			
			MOV ECX,hTextCVTRES
			LEA EDX,RCToObj
			CALL SetText
			
			MOV ECX,hReleaseTextML
			LEA EDX,szReleaseAssemble
			CALL SetText
			MOV ECX,hReleaseTextLINK
			LEA EDX,szReleaseLink
			CALL SetText
			MOV ECX,hReleaseTextOUT
			LEA EDX,szReleaseOutCommand
			CALL SetText
			
			MOV ECX,hReleaseTextCommandLine
			LEA EDX,szReleaseCommandLine
			CALL SetText
			
			;---------------------
			MOV ECX,hDebugTextML
			LEA EDX,szDebugAssemble
			CALL SetText
			MOV ECX,hDebugTextLINK
			LEA EDX,szDebugLink
			CALL SetText
			MOV ECX,hDebugTextOUT
			LEA EDX,szDebugOutCommand
			CALL SetText
			
			MOV ECX,hDebugTextCommandLine
			LEA EDX,szDebugCommandLine
			CALL SetText
			
			Invoke SelectListItem, hNewProjectList,ProjectType;,0
			
			.If bRCSilent
				Invoke CheckDlgButton,hWnd,32,BST_CHECKED
			.EndIf
			.If bPellesTools
				Invoke CheckDlgButton,hWnd,33,BST_CHECKED
			.EndIf
			
		.EndIf
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		SHR EAX,16
		.If AX==BN_CLICKED
			MOV EAX,wParam
			.If AX == 1		;OK
				Invoke EndDialog, hWnd, TRUE
				Invoke ProjectPropertiesDlgProc_EndDialog,hWnd
				Invoke ImageList_Destroy,hNewProjectImageList
				
			.ElseIf AX==2	;Cancel
				Invoke ImageList_Destroy,hNewProjectImageList
				Invoke EndDialog, hWnd, FALSE
			.EndIf
		.EndIf
	.ElseIf uMsg == WM_NOTIFY
		PUSH EDI
		MOV EDI, lParam
		MOV EAX, [EDI].NMHDR.hwndFrom
		.If EAX==hNewProjectList
			.If [EDI].NMHDR.code == NM_DBLCLK
				Invoke EndDialog, hWnd, TRUE
				Invoke ProjectPropertiesDlgProc_EndDialog,hWnd
				Invoke ImageList_Destroy,hNewProjectImageList
			.ElseIf [EDI].NMHDR.code == LVN_ITEMCHANGED
				.If [EDI].NM_LISTVIEW.uNewState==3 ;i.e focus and selected
					Invoke GetWindowText, hWnd, ADDR Buffer, 32
					Invoke lstrcmpi, ADDR Buffer, Offset szNewProjectDialogTitle
					.If EAX==0 ;i.e This is a New Project Dialog
						LEA EDX,szCompileRCNew
						MOV ECX,hTextRC
						CALL SetText
						
						LEA EDX,szReleaseAssembleNew
						MOV ECX,hReleaseTextML
						CALL SetText
						
						LEA EDX,szDebugAssembleNew
						MOV ECX,hDebugTextML
						CALL SetText
						
						MOV EAX, [EDI].NM_LISTVIEW.iItem
						.If EAX==2    ;Console
							LEA EDX,szReleaseLinkNewConsole
							MOV ECX,hReleaseTextLINK
							CALL SetText
							
							LEA EDX,szDebugLinkNewConsole
							MOV ECX,hDebugTextLINK
							CALL SetText
						.ElseIf EAX==3  ;Library
							;LEA EDX,szReleaseLinkNewLibrary
							MOV EDX,Offset szNULL
							MOV ECX,hReleaseTextLINK
							CALL SetText
							
							;LEA EDX,szDebugLinkNewLibrary
							MOV EDX,Offset szNULL
							MOV ECX,hDebugTextLINK
							CALL SetText
						.ElseIf EAX!=6
							LEA EDX,szReleaseLinkNew
							MOV ECX,hReleaseTextLINK
							CALL SetText
							
							LEA EDX,szDebugLinkNew
							MOV ECX,hDebugTextLINK
							CALL SetText
						.Else	;i.e. DOS Projects
							MOV EDX,Offset szNULL
							MOV ECX,hTextRC
							CALL SetText
							
							MOV EDX,Offset szReleaseAssembleNewDOS
							MOV ECX,hReleaseTextML
							CALL SetText
							
							MOV EDX,Offset szNULL
							MOV ECX,hReleaseTextLINK
							CALL SetText
							
							MOV EDX,Offset szDebugAssembleNewDOS
							MOV ECX,hDebugTextML
							CALL SetText
							
							MOV EDX,Offset szNULL
							MOV ECX,hDebugTextLINK
							CALL SetText
						.EndIf
					.Else	;Existing Project
						Invoke EnableWindow,hReleaseTextCommandLine,TRUE
						Invoke EnableWindow,hDebugTextCommandLine,TRUE
						
						MOV EAX, [EDI].NM_LISTVIEW.iItem
						.If EAX==6	;existing
							Invoke EnableWindow,hTextRC,FALSE
							Invoke EnableWindow,hTextCVTRES,FALSE
						.Else
							.If EAX==1 || EAX==3 || EAX==5
								Invoke EnableWindow,hReleaseTextCommandLine,FALSE
								Invoke EnableWindow,hDebugTextCommandLine,FALSE
							.EndIf
							Invoke EnableWindow,hTextRC,TRUE
							Invoke EnableWindow,hTextCVTRES,TRUE
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.ElseIf EAX==hTabControl
			.If [EDI].NMHDR.code==TCN_SELCHANGE
				Invoke GetWindowText, hWnd, ADDR Buffer, 32
				Invoke lstrcmpi, ADDR Buffer, Offset szNewProjectDialogTitle
				.If EAX ;i.e This is NOT a New Project Dialog
					Invoke SendMessage,hTabControl,TCM_GETCURSEL,0,0
					.If EAX==0
					    Invoke ShowPropertiesFourthTab,SW_HIDE
					    Invoke ShowPropertiesThirdTab,SW_HIDE
					    Invoke ShowPropertiesSecondTab,SW_HIDE
					    Invoke ShowPropertiesFirstTab,SW_SHOW
					.ElseIf EAX==1
					    Invoke ShowPropertiesFourthTab,SW_HIDE
					    Invoke ShowPropertiesThirdTab,SW_HIDE
					    Invoke ShowPropertiesFirstTab,SW_HIDE
						Invoke ShowPropertiesSecondTab,SW_SHOW
					.ElseIf EAX==2
						Invoke ShowPropertiesFourthTab,SW_HIDE
						Invoke ShowPropertiesFirstTab,SW_HIDE
						Invoke ShowPropertiesSecondTab,SW_HIDE
						Invoke ShowPropertiesThirdTab,SW_SHOW
					.ElseIf EAX==3
						Invoke ShowPropertiesThirdTab,SW_HIDE
						Invoke ShowPropertiesFirstTab,SW_HIDE
						Invoke ShowPropertiesSecondTab,SW_HIDE
						Invoke ShowPropertiesFourthTab,SW_SHOW
					.EndIf	
				.Else	;New Project Dialog
					Invoke SendMessage,hTabControl,TCM_GETCURSEL,0,0
					.If EAX==0
						Invoke FillListWithEmptyProjects
					.Else
						MOV TabCtrlItem.imask,TCIF_TEXT
						LEA EAX,tmpBuffer2
						MOV TabCtrlItem.pszText,EAX
						MOV TabCtrlItem.cchTextMax,SizeOf tmpBuffer2-1
						Invoke SendMessage,hTabControl,TCM_GETCURSEL,0,0
						Invoke SendMessage,hTabControl,TCM_GETITEM,EAX,ADDR TabCtrlItem
						Invoke FillListWithTemplates,Offset tmpBuffer2
					.EndIf
				.EndIf
			.EndIf
		.EndIf
		POP EDI
		
	.ElseIf uMsg == WM_CTLCOLORSTATIC
		Invoke SetBkMode, wParam, TRANSPARENT
		;Invoke GetSysColorBrush,COLOR_WINDOW
		MOV EAX, COLOR_WINDOW
		RET

	.ElseIf uMsg==WM_ACTIVATEAPP	;Thanks jnrz(List is not refreshed otherwise-->VERY Strange
		Invoke UpdateWindow,hWnd
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET

	;----------------------------------------
	SetText:
	Invoke SendMessage,ECX,WM_SETTEXT,NULL,EDX
	RETN
ProjectPropertiesDlgProc EndP

RepaintAllFont Proc Uses EBX, hChild:DWORD
	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_SETCOLOR,0,ADDR col
	;This sets fonts and other things that are not needed here
	Invoke SetFormat, CHILDWINDOWDATA.hEditor[EBX]
	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_REPAINT,0,0
	
	;Invoke SendMessage,CHILDWINDOWDATA.hCombo[EBX],WM_SETFONT,hFontTahoma,TRUE

	RET
RepaintAllFont EndP

SelectLineNrFont Proc
Local cf:CHOOSEFONT
Local Buffer[12]:BYTE

	Invoke RtlZeroMemory,ADDR cf,SizeOf cf
	MOV cf.lStructSize,SizeOf cf
	MOV EAX, WinAsmHandles.hMain
	MOV cf.hwndOwner,EAX
	MOV cf.lpLogFont,Offset lfntlnr
	MOV cf.Flags,CF_ENABLEHOOK OR CF_SCREENFONTS  OR CF_INITTOLOGFONTSTRUCT or CF_EFFECTS
	MOV EAX,col.lnrcol
	MOV cf.rgbColors, EAX
	MOV cf.lpfnHook, Offset ChooseFontHook
	Invoke ChooseFont,ADDR cf
	.If EAX
		Invoke DeleteObject,hLnrFont
		Invoke CreateFontIndirect,Offset lfntlnr
		MOV hLnrFont,EAX
		MOV EAX,cf.rgbColors
		MOV col.lnrcol,EAX
		
		.If AutoLineNrWidth
			Invoke CalculateLineNrWidth
			MOV	LineNrWidth,EAX
		.EndIf
		
		Invoke LockWindowUpdate,WinAsmHandles.hMain
		Invoke EnumProjectItems,Offset RepaintAllFont
		Invoke EnumOpenedExternalFiles,Offset RepaintAllFont
		Invoke LockWindowUpdate,0
		
		;Save Font Name in Ini File	
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szLineNrFontName,ADDR lfntlnr.lfFaceName,ADDR IniFileName
		;Set LineNr Text Color in Ini file
		Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, col.lnrcol
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szLineNrColor, ADDR Buffer, ADDR IniFileName
		
		;Save Font Size
		MOV EAX, lfntlnr.lfHeight
		NEG EAX
		LEA ECX,Buffer
		Invoke BinToDec,EAX,ECX
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szLineNrFontSize, ADDR Buffer, ADDR IniFileName
		
		; Save Font style
		MOV EAX, lfntlnr.lfWeight
		AND EAX,03FFh
		MOVZX ECX,lfntlnr.lfItalic
		AND ECX,1
		SHL ECX,10
		OR   EAX,ECX
		MOVZX ECX,lfntlnr.lfStrikeOut
		AND ECX,1
		SHL ECX,11
		OR   EAX,ECX
		MOVZX ECX,lfntlnr.lfUnderline
		AND ECX,1
		SHL ECX,12
		OR  EAX,ECX
		Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, EAX	
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szLineNrFontStyle, ADDR Buffer, ADDR IniFileName
				
	.EndIf

	RET
SelectLineNrFont EndP

SelectEditorFont Proc
Local cf:CHOOSEFONT
Local Buffer[12]:BYTE

	Invoke RtlZeroMemory,ADDR cf,SizeOf cf
	MOV cf.lStructSize,SizeOf cf
	MOV EAX, WinAsmHandles.hMain
	MOV cf.hwndOwner,EAX
	MOV cf.lpLogFont,Offset lfnt
	MOV cf.Flags,CF_ENABLEHOOK OR CF_SCREENFONTS or CF_EFFECTS or CF_INITTOLOGFONTSTRUCT
	MOV EAX,col.txtcol
	MOV cf.rgbColors,EAX

	MOV cf.lpfnHook, Offset ChooseFontHook
	Invoke ChooseFont,ADDR cf
	.If EAX
		Invoke DeleteObject,hFont
		MOV AL,lfnt.lfItalic
		PUSH EAX
		Invoke CreateFontIndirect,Offset lfnt
		MOV hFont,EAX
		Invoke DeleteObject,hIFont
		MOV lfnt.lfItalic,FALSE ;TRUE
		Invoke CreateFontIndirect,Offset lfnt
		MOV hIFont,EAX
		POP	EAX
		MOV	lfnt.lfItalic, AL
		MOV EAX,cf.rgbColors
		MOV col.txtcol,EAX
		
		;Save Font Name in Ini File	
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szEditorFontName, ADDR lfnt.lfFaceName, ADDR IniFileName
		;Set Editor Text Color in Ini file
		Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, col.txtcol
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szTextColor, ADDR Buffer, ADDR IniFileName
		
		;Save Font Size
		MOV EAX, lfnt.lfHeight
		NEG EAX
		LEA ECX,Buffer
		Invoke BinToDec,EAX,ECX
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szEditorFontSize, ADDR Buffer, ADDR IniFileName
		
		; Save Font style
		MOV EAX, lfnt.lfWeight
		AND EAX,03FFh
		MOVZX ECX,lfnt.lfItalic
		AND ECX,1
		SHL ECX,10
		OR   EAX,ECX
		MOVZX ECX,lfnt.lfStrikeOut
		AND ECX,1
		SHL ECX,11
		OR   EAX,ECX
		MOVZX ECX,lfnt.lfUnderline
		AND ECX,1
		SHL ECX,12
		OR  EAX,ECX
		Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, EAX	
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szEditorFontStyle, ADDR Buffer, ADDR IniFileName
		
		;Save Charset
		XOR EAX,EAX
		MOV AL, lfnt.lfCharSet
		LEA ECX,Buffer
		Invoke BinToDec,EAX,ECX
		Invoke WritePrivateProfileString, Offset szEDITOR, Offset szEditorFontCharset, ADDR Buffer, ADDR IniFileName
		
		Invoke LockWindowUpdate, WinAsmHandles.hMain
		Invoke EnumProjectItems, Offset RepaintAllFont
		Invoke EnumOpenedExternalFiles,Offset RepaintAllFont
		
		Invoke LockWindowUpdate, 0
		
		Invoke SendMessage,hListProcedures,WM_SETFONT,hFont,FALSE
		Invoke SendMessage,hListStructures,WM_SETFONT,hFont,FALSE
		Invoke SendMessage,hListConstants,WM_SETFONT,hFont,FALSE
		Invoke SendMessage,hListStructureMembers,WM_SETFONT,hFont,FALSE
		Invoke SendMessage,hListVariables,WM_SETFONT,hFont,FALSE
		Invoke SendMessage,hListIncludes,WM_SETFONT,hFont,FALSE
		Invoke SendMessage,hToolTip,WM_SETFONT,hFont,FALSE
		
		;The Output Window
		Invoke SetOutEditWindowFormat
		
	.EndIf

	RET
SelectEditorFont EndP

RemoveFileFromProject Proc Uses EBX EDI hChild:HWND, AskToSaveFirst:BOOLEAN
	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	
	MOV ECX,hChild
	.If ECX==hRCEditorWindow
		Invoke ClearRCEditor
	.EndIf
	.If AskToSaveFirst
		Invoke AskToSaveFile,hChild
		.If EAX
			Invoke SaveEdit,hChild,ADDR [EBX].CHILDWINDOWDATA.szFileName
		.EndIf
	.EndIf

	;Invoke DisableAll
	Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET,NULL
	Invoke SetFocus,WinAsmHandles.hMain
	
	;Now Delete all procedures from the list
	Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,FALSE,0
	Invoke DeleteProcTreeItems,CHILDWINDOWDATA.hEditor[EBX]
	
	Invoke SendMessage,hClient,WM_MDIRESTORE,hChild,0
;	Invoke SendMessage,hClient,WM_MDINEXT,hChild,TRUE
	Invoke SendMessage,hClient,WM_MDIDESTROY,hChild,0
	
	Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,TRUE,0
	
	Invoke SendMessage, WinAsmHandles.hProjTree, TVM_GETNEXTITEM, TVGN_PARENT,CHILDWINDOWDATA.hTreeItem[EBX]
	;Now EAX is the parent of the current item
	MOV EDI, EAX
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_DELETEITEM,0,CHILDWINDOWDATA.hTreeItem[EBX]
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_CHILD,EDI
	.If !EAX	;If there are no childs left
		Invoke SendMessage,WinAsmHandles.hProjTree,TVM_DELETEITEM,0,EDI
		.If EDI==hASMFilesItem
			MOV hASMFilesItem,0
		.ElseIf EDI==hModulesItem
			MOV hModulesItem,0
		.ElseIf EDI==hDefFilesItem
			MOV hDefFilesItem,0
		.ElseIf EDI==hIncludeFilesItem
			MOV hIncludeFilesItem,0
		.ElseIf EDI==hOtherFilesItem
			MOV hOtherFilesItem,0
		.ElseIf EDI==hResourceFilesItem
			MOV hResourceFilesItem,0
		.ElseIf EDI==hTextFilesItem
			MOV hTextFilesItem,0
		.ElseIf EDI==hBatchFilesItem
			MOV hBatchFilesItem,0
		.EndIf
	.EndIf
	MOV ProjectModified,TRUE

	Invoke EnableDisableMakeOptions
	RET
RemoveFileFromProject EndP

AddFileToAskToSaveFileList Proc Uses EBX hChild:DWORD, hFilesList:DWORD
Local lvi :LVITEM
	MOV EAX,hChild
	.If EAX==hRCEditorWindow && RCModified
		Invoke GenerateResourceScript,FALSE
	.EndIf

	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_GETMODIFY,0,0
	.If EAX	;i.e. modified
		MOV lvi.imask,LVIF_TEXT OR LVIF_STATE Or LVIF_PARAM
		MOV lvi.cchTextMax,256
		MOV lvi.iSubItem, 0
		MOV lvi.state,LVIS_SELECTED;LVIS_FOCUSED; OR LVIS_SELECTED
		MOV lvi.stateMask, LVIS_SELECTED;LVIS_FOCUSED; OR LVIS_SELECTED
		M2M lvi.lParam,hChild
		Invoke SendMessage,hFilesList,LVM_GETITEMCOUNT,0,0
		MOV lvi.iItem,EAX
		LEA ECX,CHILDWINDOWDATA.szFileName[EBX]
		MOV lvi.pszText,ECX
		Invoke SendMessage,hFilesList,LVM_INSERTITEM,0,ADDR lvi
	.Else
	
	.EndIf
	MOV EAX,TRUE	;i.e. continue enumeration
	RET
AddFileToAskToSaveFileList EndP

;1=Check wap, all project files and all external files. bForceSaveAs:FALSE, bSaveFiles:FALSE
;2=Check wap, and all project files. NOT external files. bForceSaveAs:FALSE, bSaveFiles:FALSE
;3=Check wap, and all project files. NOT external files. bForceSaveAs:TRUE, bSaveFiles:FALSE
AskToSaveFilesDialogProc Proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local hFilesList:HWND
Local lvc		:LV_COLUMN
Local Rect		:RECT
Local lvi 		:LVITEM
Local Buffer[256]:BYTE

	.If uMsg==WM_INITDIALOG
		Invoke GetDlgItem,hWnd,218	;Get List's handle
		MOV hFilesList,EAX
		
		MOV lvc.imask, LVCF_FMT	OR LVCF_TEXT;LVCF_WIDTH OR 
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.pszText,Offset szFile
		Invoke SendMessage, hFilesList, LVM_INSERTCOLUMN, 0, ADDR lvc
		
		Invoke SendMessage, hFilesList, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT OR LVS_EX_LABELTIP
		
		.If FullProjectName[0]!=0
			.If ProjectModified || lParam==3	;if wap is modified
				MOV lvi.imask,LVIF_TEXT OR LVIF_STATE or LVIF_PARAM
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				MOV lvi.state,LVIS_SELECTED;LVIS_FOCUSED OR 
				MOV lvi.stateMask,LVIS_SELECTED; LVIS_FOCUSED OR 
				MOV lvi.iItem,0
				MOV lvi.pszText,Offset FullProjectName
				MOV lvi.lParam,-1	;to indicate that this is wap
				Invoke SendMessage,hFilesList,LVM_INSERTITEM,0,ADDR lvi
			.EndIf
			Invoke EnumProjectItemsExtended,Offset AddFileToAskToSaveFileList,hFilesList
		.EndIf
		.If lParam==1
			Invoke EnumOpenedExternalFilesExtended,Offset AddFileToAskToSaveFileList,hFilesList
		.EndIf
		
		Invoke SendMessage,hFilesList,LVM_GETITEMCOUNT,0,0
		.If EAX
			PUSH EBX
			Invoke GetWindowRect,hFilesList,ADDR Rect
			
			Invoke GetSystemMetrics,SM_CXBORDER
			MOV EBX,EAX
			SHL EBX,1	;Twice
			
			Invoke GetWindowLong,hFilesList,GWL_STYLE
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
			Invoke SendMessage, hFilesList, LVM_SETCOLUMNWIDTH, 0, ECX
			POP EBX
			
			Invoke SetWindowLong,hWnd,GWL_USERDATA,lParam
		.Else
			Invoke EndDialog,hWnd,TRUE	;Return TRUE
		.EndIf
		
	.ElseIf uMsg==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==220		;Yes
				;Save selected files
				Invoke GetDlgItem,hWnd,218	;Get List's handle
				MOV hFilesList,EAX
				MOV lvi.imask,LVIF_TEXT or LVIF_PARAM OR LVIF_STATE
				MOV lvi.stateMask,LVIS_SELECTED	; LVIS_FOCUSED 
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				LEA EDX,Buffer
				MOV lvi.pszText,EDX
				
				PUSH EBX
				PUSH EDI
				Invoke SendMessage,hFilesList,LVM_GETITEMCOUNT,0,0
				MOV EBX,EAX	;Since we reach this point, EAX is definately NOT 0 
				XOR EDI,EDI
				Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szSaving	;"Saving ..."
				.While EDI<EBX
					MOV lvi.iItem,EDI
					Invoke SendMessage,hFilesList,LVM_GETITEM,0,ADDR lvi
					.If lvi.state==LVIS_SELECTED
						.If lvi.lParam!=-1	;means this is NOT the wap
							Invoke GetWindowLong,lvi.lParam,0
							LEA EDX,[EAX].CHILDWINDOWDATA.szFileName
							Invoke SaveEdit,lvi.lParam,EDX
							.If EAX	;i.e. saved
								MOV EAX,lvi.lParam
								.If EAX==hRCEditorWindow
									Invoke SetRCModified,FALSE								
								.EndIf
							.EndIf
						.EndIf
					.EndIf
					INC EDI
				.EndW
				
				MOV lvi.iItem,0
				Invoke SendMessage,hFilesList,LVM_GETITEM,0,ADDR lvi
				.If lvi.lParam==-1 && lvi.state==LVIS_SELECTED ;means this is the wap
					Invoke GetWindowLong,hWnd,GWL_USERDATA
					MOV EDX,FALSE
					.If EAX==3
						MOV EDX,TRUE
					.EndIf
					Invoke SaveWAP,EDX,FALSE,Offset szSaveProjectAsDialogTitle
					;.If EAX	;i.e. wap saved
				.EndIf
				
				Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szNULL
				POP EDI
				POP EBX
				MOV EAX,TRUE	;Return TRUE
			.ElseIf EAX==221	;No
				MOV EAX,TRUE	;Return TRUE
			.Else;If EAX==222	;Cancel
				MOV EAX,FALSE	;Return Cancel
			.EndIf
			Invoke EndDialog,hWnd,EAX
		.EndIf
	.ElseIf uMsg==WM_CLOSE
		Invoke EndDialog,hWnd,FALSE	;Return Cancel
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
AskToSaveFilesDialogProc EndP

AboutDialogProc Proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lFont				:LOGFONT
Local Rect				:RECT
Local Buffer[MAX_PATH]	:BYTE

Local dwDummy			:DWORD
Local lpData			:DWORD
Local lpVersionInfo		:DWORD
Local puLen				:DWORD

	.If uMsg == WM_INITDIALOG
		Invoke GetModuleFileName,NULL,ADDR Buffer,MAX_PATH
		Invoke GetFileVersionInfoSize,ADDR Buffer,ADDR dwDummy
		PUSH EAX
		Invoke LocalAlloc,LPTR,EAX
		MOV lpData,EAX
		POP EDX
		Invoke GetFileVersionInfo,ADDR Buffer,NULL,EDX,lpData
		
		Invoke VerQueryValue,lpData,Offset szSlash,ADDR lpVersionInfo,ADDR puLen
		
		PUSH EDI
		PUSH EBX
		PUSH ESI
		
		LEA ESI,Buffer
		Invoke lstrcpy,ESI,Offset szAppName
		Invoke lstrcat,ESI,Offset szSpc
		
		MOV EDI,lpVersionInfo
		
		MOV EBX,[EDI].VS_FIXEDFILEINFO.dwFileVersionMS
		Invoke lstrlen,ESI
		ADD EAX,ESI
		MOV EDX,EBX
		SHR EDX,16
		Invoke BinToDec,EDX,EAX
		Invoke lstrcat,ESI,Offset szDot
		
		Invoke lstrlen,ESI
		ADD EAX,ESI
		AND EBX,0FFFFh
		Invoke BinToDec,EBX,EAX
		Invoke lstrcat,ESI,Offset szDot
		
		MOV EBX,[EDI].VS_FIXEDFILEINFO.dwFileVersionLS
		Invoke lstrlen,ESI
		ADD EAX,ESI
		MOV EDX,EBX
		SHR EDX,16
		Invoke BinToDec,EDX,EAX
		Invoke lstrcat,ESI,Offset szDot
		
		Invoke lstrlen,ESI
		ADD EAX,ESI
		AND EBX,0FFFFh
		Invoke BinToDec,EBX,EAX
		
		Invoke SetDlgItemText,hWnd,2,ADDR Buffer
		
		POP ESI
		POP EBX
		POP EDI
		Invoke LocalFree,lpData
		
		
		
		.If lParam
			Invoke GetDlgItem,hWnd,IDC_OK
			Invoke ShowWindow,EAX,SW_HIDE
		.EndIf
		
		Invoke SendMessage, hWnd, WM_GETFONT, 0, 0
		LEA ECX,lFont
		Invoke	GetObject,EAX,SizeOf(LOGFONT),ECX
		MOV lFont.lfUnderline,TRUE
		Invoke CreateFontIndirect, ADDR lFont
		MOV hFontUnderline,EAX
		Invoke GetDlgItem,hWnd,10
		Invoke SendMessage,EAX,WM_SETFONT,hFontUnderline,TRUE
		
	.ElseIf uMsg==WM_SETCURSOR
		Invoke SetWindowLong,hWnd,DWL_MSGRESULT,TRUE
		
	.ElseIf uMsg>WM_MOUSEFIRST-1 && uMsg<WM_MOUSELAST+1
		;xPos = LOWORD(lParam);  // horizontal position of cursor 
		;yPos = HIWORD(lParam);  // vertical position of cursor 
		Invoke GetDlgItem,hWnd,10
		LEA ECX,Rect
		Invoke GetWindowRect,EAX,ECX;ADDR Rect
		Invoke MapWindowPoints,NULL,hWnd,ADDR Rect,2
		
		LOWORD lParam
		MOV ECX,EAX
		HIWORD lParam
		
		Invoke PtInRect,ADDR Rect,ECX,EAX
		.If EAX
			.If uMsg==WM_LBUTTONUP
				Invoke ShellExecute,NULL,Offset szopen,Offset szSiteURL,NULL,NULL,SW_SHOWDEFAULT
			.EndIf
			PUSH IDC_HAND
		.Else
			PUSH IDC_ARROW
		.EndIf
		PUSH NULL
		CALL LoadCursor
		Invoke SetCursor,EAX
		
	.ElseIf uMsg == WM_COMMAND
		.If WORD PTR [wParam] == IDOK
			Invoke DeleteObject,hFontUnderline
			
			Invoke GetDlgItem,hWnd,IDC_OK
			Invoke IsWindowVisible,EAX
			.If EAX	;i.e. about and NOT splash-->modal
				Invoke EndDialog, hWnd, TRUE
			.Else
				Invoke DestroyWindow,hWnd
			.EndIf
		.EndIf
		
	.ElseIf uMsg == WM_CTLCOLORSTATIC
		; wParam = hDC of control, lParam = hWnd of control
		Invoke SetTextColor, wParam, 00FF0000h
		Invoke SetBkMode, wParam, TRANSPARENT
		Invoke GetSysColorBrush,COLOR_WINDOW
		RET
		
	.ElseIf uMsg == WM_CTLCOLORDLG
		; wParam = hDC of control, lParam = hWnd of control
		Invoke SetBkMode,wParam, TRANSPARENT
		Invoke GetSysColorBrush, COLOR_WINDOW
		RET
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
AboutDialogProc EndP

GoToLineDialogProc Proc Uses EBX hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
Local LineNo:DWORD
Local chrg:CHARRANGE

	.If uMsg==WM_INITDIALOG
		M2M hFind,hWnd
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		SHR EAX,16
		.If AX==BN_CLICKED
			MOV EAX,wParam
			.If AX == IDC_OK
				Invoke SendMessage,hWnd,WM_CLOSE,0,0
			.ElseIf AX == IDC_GO
				Invoke SendMessage, hClient,WM_MDIGETACTIVE, NULL, NULL
				;Now EAX holds Window handle active Child Window
				Invoke GetWindowLong, EAX, 0
				MOV	EBX,EAX
				
				Invoke GetDlgItemInt,hWnd,IDC_TEXTLINENR,NULL,FALSE
				MOV LineNo,EAX
				
				Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_GETLINECOUNT,0,0
				INC EAX	;It seems that it returns one line less
				
				.If LineNo>EAX
					MOV LineNo,EAX
				.EndIf
				
				.If LineNo>0
					DEC LineNo
				.EndIf
				
				Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_LINEINDEX,LineNo,0
				MOV chrg.cpMin,EAX
				
				
				;EM_LINELENGTH is buggyyyyyyyyyyyyyyyy! 
				;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_LINELENGTH,EAX,0
				Invoke GetLineLength,[EBX].CHILDWINDOWDATA.hEditor,LineNo
				
				ADD EAX,chrg.cpMin
				MOV chrg.cpMax,EAX
				
				Invoke IsDlgButtonChecked,hWnd,1007	;Extend Selection
				.If EAX
					;Get current selection
					PUSH chrg.cpMin
					PUSH chrg.cpMax
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXGETSEL,0,ADDR chrg
					POP EAX	;End Of line to select
					POP ECX	;Start of line to select
					.If ECX<chrg.cpMin
						MOV chrg.cpMin,ECX
					.EndIf
					.If EAX>chrg.cpMax
						MOV chrg.cpMax,EAX
					.EndIf
				.EndIf
				;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SETSEL,chrg.cpMin,chrg.cpMax
				Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXSETSEL,0,ADDR chrg
				Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SCROLLCARET,0,0
			.ElseIf AX == 1 
				Invoke SendMessage,hWnd,WM_CLOSE,0,0
				
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_CLOSE
		MOV hFind,0
		;Invoke EndDialog,hWnd,0
		Invoke DestroyWindow,hWnd
	.Else
		.If uMsg==WM_NCACTIVATE
			Invoke InvalidateAllDockWindows
		.EndIf
		MOV EAX, FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
GoToLineDialogProc EndP

ToolTipProc Proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
Local ps				:PAINTSTRUCT
Local hDC				:HDC
Local TextSize			:_SIZE
Local nLengthPrevious	:DWORD
Local tmpParam			:DWORD

Local Buffer[256]		:BYTE
;Local logfnt			:LOGFONT

	.If uMsg==WM_PAINT
		Invoke BeginPaint,hWnd,ADDR ps
		MOV hDC,EAX
;		Invoke GetObject,hFontTahoma,SizeOf LOGFONT,ADDR logfnt
;		MOV logfnt.lfWeight,900
;		Invoke CreateFontIndirect,ADDR logfnt
;		PUSH EAX
		Invoke SelectObject,hDC,hFont;Tahoma
		PUSH EAX
		
		PUSH EBX
		PUSH EDI
		PUSH ESI
		
		MOV EDI,Offset FunctionToolTip
		Invoke lstrlen, EDI
		MOV EBX,EAX
		Invoke SetTextColor, hDC,0;000000FFh
		Invoke SetBkColor,hDC,col.tltbckcol
		Invoke TextOut,hDC,0,0,EDI,EBX
		
		
		;*************************************************
		;Let's set Function name color
		Invoke SetTextColor, hDC, 00FF0000h
		XOR EAX,EAX
		.While BYTE PTR [EDI]
			.If BYTE PTR [EDI]==","
				.Break
			.EndIf
			INC EAX
			INC EDI
		.EndW
		
		MOV CL,BYTE PTR [EDI]
		PUSH ECX
		MOV BYTE PTR [EDI],0
		
		Invoke TextOut,hDC,0,0,Offset FunctionToolTip,EAX
		
		POP ECX
		MOV BYTE PTR [EDI],CL
		;*************************************************
		
		MOV EDI,Offset FunctionToolTip
		MOV EDX,lpTrigger
		@@:
		.If BYTE PTR [EDX]
			.If [EDX].FUNCTIONLISTTRIGGER.Active==FALSE
				ADD EDX, SizeOf FUNCTIONLISTTRIGGER
				JMP @B
			.EndIf
		.EndIf
		
		.If [EDX].FUNCTIONLISTTRIGGER.AcceptsParameters;	&& nParam;for example, for "CALL" do NOT highlight any parameter
			ADD EBX,EDI
			MOV nLengthPrevious,1
			MOV tmpParam,0
			.While EDI<EBX
				.If BYTE PTR [EDI]==","
					INC tmpParam
					MOV EAX,tmpParam
					.If EAX==nParam
						INC EDI
						MOV ESI,EDI
						;Now the , is just before the parameter we want
						.While EDI<EBX
							.If BYTE PTR [EDI]==","
								.Break
							.EndIf
							INC EDI
						.EndW
						Invoke SetTextColor, hDC, col.TltActParamCol;00FFFFFFh
						MOV CL,BYTE PTR [EDI]
						PUSH ECX
						MOV BYTE PTR [EDI],0
						;-----------------------------------------------
						Invoke GetTextExtentPoint32,hDC,Offset FunctionToolTip,nLengthPrevious,ADDR TextSize
						DEC TextSize.x	;Because it must be zero based-Not one based
						Invoke lstrlen, ESI
						Invoke TextOut,hDC,TextSize.x,0,ESI,EAX
						;------------------------------------------------
						
						.If !gl_uMsg
							Invoke IsParameterAPIConstant,ESI
							;Now EAX=TRUE if we should PopUp Constants List
							.If EAX
								PUSH EAX	;pConstants
								Invoke ShowWindow,hListVariables,SW_HIDE
								;New ------------------------------------------
								Invoke ShowWindow,hListStructureMembers,SW_HIDE
								;-----------------------------------------------	                
								Invoke IsWindowVisible,hListConstants
								POP EDX
								.If !EAX
									Invoke FillConstantsList,EDX
								.EndIf
								Invoke SendMessage,hEditor,CHM_GETWORD,256,ADDR Buffer
								Invoke FindFromListAndSelect,ADDR Buffer,hListConstants
								.If !EAX
									Invoke AutoVariableAndStructureMembersList,FALSE
								.EndIf
							.Else
								Invoke ShowWindow,hListConstants,SW_HIDE
								Invoke AutoVariableAndStructureMembersList,FALSE
							.EndIf
						.EndIf
						
						POP ECX
						MOV BYTE PTR [EDI],CL
						JMP TheEnd				
					.EndIf
				.EndIf
				INC nLengthPrevious
				INC EDI
			.EndW
			;If we come here it means that we are after last parameter
			;Invoke ShowWindow,hToolTip,SW_HIDE
		.EndIf
		
		Invoke HideAllLists
		
		TheEnd:
		
		POP EAX
		Invoke SelectObject,hDC,EAX
		
;		POP EAX
;		Invoke DeleteObject,EAX
		
		POP ESI
		POP EDI
		POP EBX
		Invoke EndPaint,hWnd,ADDR ps
		RET
	.ElseIf uMsg==WM_CREATE
		Invoke EnableWindow,hWnd,FALSE
	.EndIf
	Invoke DefWindowProc,hWnd,uMsg,wParam,lParam	   ;Default message processing	

	RET
ToolTipProc EndP

ClientResize Proc Uses EBX ESI EDI
Local LeftOfClient	:DWORD
Local TopOfClient	:DWORD
Local ClientWidth	:DWORD
Local BottomOfClient:DWORD
Local StatusHeight	:DWORD
Local ClientHeight	:DWORD
Local Rect			:RECT

	Invoke MoveWindow, hStatus,0, 0, 0, 0,TRUE
	Invoke GetWindowRect,WinAsmHandles.hRebar,ADDR Rect
	
	MOV	EAX, Rect.top
	SUB	Rect.bottom, EAX
	M2M	TopOfClient,Rect.bottom
	
	Invoke GetWindowRect, hStatus, ADDR Rect
	MOV	EAX, Rect.top
	SUB	Rect.bottom, EAX
	M2M	StatusHeight, Rect.bottom
	
	Invoke GetClientRect, WinAsmHandles.hMain, ADDR Rect

	MOV EAX, Rect.bottom
	SUB EAX, TopOfClient
	SUB EAX, StatusHeight
	MOV ClientHeight,EAX
	
	MOV EAX, Rect.bottom
	SUB EAX, StatusHeight
	SUB EAX, 130
	MOV	BottomOfClient, EAX

	;Believe it or not Rect.bottom works fine; 22 is the value I should use but flickers!!
	;Invoke MoveWindow,WinAsmHandles.hRebar, 0, 0, Rect.right, Rect.bottom, TRUE
	Invoke MoveWindow, WinAsmHandles.hRebar, 0, 0,Rect.right,22, TRUE
	
	M2M ClientWidth,Rect.right
	M2M LeftOfClient,Rect.left
	
	.If pDWBlock
		
		XOR ECX,ECX
		MOV EAX,pDWBlock
		
		@@:
		PUSH EAX
		PUSH ECX
		MOV ESI,[EAX+ECX]
		CALL MoveDock
		POP ECX
		POP EAX
		ADD ECX,4
		
		.If ECX<DWBlockSize
			JMP @B
		.EndIf
		
	.EndIf	

	Invoke MoveWindow, hClient,LeftOfClient,TopOfClient,ClientWidth,ClientHeight,TRUE
	Invoke RedrawWindow,hClient,NULL,NULL,RDW_INVALIDATE or RDW_ERASE or RDW_ALLCHILDREN or RDW_ERASENOW
	;Invoke SetWindowPos,hClient,NULL,LeftOfClient,TopOfClient,ClientWidth,ClientHeight,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOZORDER or SWP_FRAMECHANGED
	RET
	;------------------------------------------------------------------------
	MoveDock:
	Invoke IsWindowVisible,ESI
	.If EAX
		Invoke GetWindowLong,ESI,0
		MOV EBX,EAX
		M2M DOCKDATA.fDockedTo[EBX],DOCKDATA.fDockTo[EBX]
		.If DOCKDATA.fDockTo[EBX]==NODOCK
			Invoke GetParent,ESI
			.If EAX==WinAsmHandles.hMain
				Invoke CreateWindowEx,WS_EX_TOOLWINDOW,Offset szDockClass,NULL,WS_CLIPCHILDREN or WS_POPUP or WS_SIZEBOX OR WS_CLIPSIBLINGS, 0, 0, 0, 0, WinAsmHandles.hMain, NULL, hInstance, NULL
				MOV EDI,EAX
				;Invoke SetWindowPos,EDI,WinAsmHandles.hMain,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE
				Invoke SetParent,ESI,EDI
				Invoke SetWindowLong,EDI,0,EBX
				Invoke ShowWindow,EDI,SW_SHOW
			.Else
				;Look here! I am moving the parent (which is again a docking window)
				MOV EDI,EAX
			.EndIf
			Invoke MoveFloatingWindow,EBX,EDI
		.Else
			Invoke GetParent,ESI
			.If EAX!=WinAsmHandles.hMain
				PUSH EAX
				Invoke SetParent,ESI,WinAsmHandles.hMain
				POP EAX
				Invoke DestroyWindow,EAX
			.EndIf
			
			Invoke GetWindowLong,ESI,0
			MOV EBX,EAX			
			.If DOCKDATA.fDockTo[EBX]==LEFTDOCK
				MOV EAX,DOCKDATA.FocusRect.right[EBX]
				SUB EAX,DOCKDATA.FocusRect.left[EBX]
				MOV DOCKDATA.DockLeftWidth[EBX],EAX
				MOV ECX,LeftOfClient
				.If ClientWidth>=EAX
					ADD LeftOfClient,EAX
					SUB ClientWidth,EAX
				.Else
					MOV EAX,ClientWidth
					MOV LeftOfClient,EAX					
					MOV ClientWidth,0
				.EndIf
				Invoke MoveWindow, ESI,ECX,TopOfClient,EAX,ClientHeight,TRUE
			.ElseIf DOCKDATA.fDockTo[EBX] == RIGHTDOCK
				MOV EAX,DOCKDATA.FocusRect.right[EBX]
				SUB EAX,DOCKDATA.FocusRect.left[EBX]
				MOV DOCKDATA.DockRightWidth[EBX],EAX
				.If ClientWidth>=EAX
					SUB ClientWidth,EAX
				.Else
					MOV EAX,ClientWidth					
					MOV ClientWidth,0
				.EndIf
				MOV ECX,ClientWidth
				ADD ECX,LeftOfClient
				
				Invoke MoveWindow, ESI,ECX,TopOfClient,EAX,ClientHeight,TRUE
			.ElseIf DOCKDATA.fDockTo[EBX]==TOPDOCK	;i.e. Top Dock
				MOV EAX,DOCKDATA.FocusRect.bottom[EBX]
				SUB EAX,DOCKDATA.FocusRect.top[EBX]
				MOV DOCKDATA.DockTopHeight[EBX],EAX
				.If ClientHeight<EAX
					MOV EAX,ClientHeight
				.EndIf
				PUSH EAX
				Invoke MoveWindow, ESI,LeftOfClient,TopOfClient,ClientWidth,EAX,TRUE
				POP EAX
				ADD TopOfClient,EAX
				SUB ClientHeight,EAX
			.ElseIf DOCKDATA.fDockTo[EBX]==BOTTOMDOCK
				MOV ECX,DOCKDATA.FocusRect.bottom[EBX]
				SUB ECX,DOCKDATA.FocusRect.top[EBX]
				MOV DOCKDATA.DockBottomHeight[EBX],ECX
				.If ClientHeight<ECX
					MOV ECX,ClientHeight
				.EndIf
				MOV EAX,TopOfClient
				SUB ClientHeight,ECX
				ADD EAX,ClientHeight
				Invoke MoveWindow, ESI,LeftOfClient,EAX,ClientWidth,ECX,TRUE
			.EndIf
		.EndIf
	.EndIf
	RETN

ClientResize EndP

NewOutProc Proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local chrg			:CHARRANGE
Local LineSelected	:DWORD

	;Note that I send to hOut not hWnd
	Invoke SendCallBackToAllAddIns,pAddInsOutWindowProcedures,hOut,uMsg,wParam,lParam
	.If EAX==0
		
		MOV EAX,uMsg
		.If EAX==WM_KEYDOWN
			Invoke GetKeyState, VK_CONTROL
			AND EAX,80h
			.If EAX==80h
				.If wParam==VK_C
					;Invoke PostMessage,hWnd,WM_COPY,0,0
				.Else
					Return 0
				.EndIf
			.Else
				;Allow only Up, Down, PageUp, PageDown, Home, End but WITHOUT Shift pressed
				MOV EAX, wParam
				.If EAX==VK_UP || EAX==VK_DOWN || EAX==VK_HOME || EAX==VK_END || EAX== VK_PGDN || EAX==VK_PGUP || EAX==VK_LEFT || EAX==VK_RIGHT
				.Else
					Return 0
				.EndIf
			.EndIf
			
		.ElseIf EAX==WM_CHAR
			Return 0
		.ElseIf EAX==WM_LBUTTONDBLCLK
			Invoke SendMessage,hOut,EM_EXGETSEL,0,ADDR chrg
			;chrg.cpMin is the position of the first character of the selection.
			;chrg.cpMax is the position of the last character of the selection.
			Invoke SendMessage,hOut,EM_EXLINEFROMCHAR,0,chrg.cpMin
			MOV LineSelected,EAX
			Invoke GetLineText, hOut, LineSelected, Offset LineTxt
			.If BYTE PTR LineTxt[0]!=0
				Invoke GetErrorPos, Offset LineTxt, Offset BuggyWindowFileName
				;Now Buffer contains Buggy Window and EAX Buggy Line
				.If EAX!=0   ;i.e. Error Found
					DEC BugLine
					Invoke EnumProjectItems, Offset ShowWindowAndGoToLine
					
					;De-hilite previously hilited line and hilite the one user clicked
					Invoke SendMessage,hOut,CHM_SETHILITELINE,LineHilited,0
					Invoke SendMessage,hOut,CHM_SETHILITELINE,LineSelected,1
				.Else
					;De-hilite previously hilited line and hilite the one user clicked
					Invoke SendMessage,hOut,CHM_SETHILITELINE,LineHilited,0
					Invoke SendMessage,hOut,CHM_SETHILITELINE,LineSelected,2
				.EndIf
				M2M LineHilited,LineSelected
			.EndIf
		.ElseIf EAX==WM_CONTEXTMENU
			Invoke SendMessage,hOut,EM_EXGETSEL,0,ADDR chrg
			MOV EAX,chrg.cpMax
			SUB EAX,chrg.cpMin
			.If EAX ;i.e. there is selection
				Invoke EnableMenuItem,hOutPopUpMenu,IDM_COPYSELECTION,MF_ENABLED
			.Else
				Invoke EnableMenuItem,hOutPopUpMenu,IDM_COPYSELECTION,MF_GRAYED
			.EndIf
			
			MOV EAX,wParam
			MOV EAX,lParam
			AND EAX,0FFFFh
			MOV ECX,EAX
			MOV EAX,lParam
			SHR EAX,16
			Invoke TrackPopupMenu,hOutPopUpMenu,TPM_LEFTALIGN or TPM_RIGHTBUTTON,ECX,EAX,0,WinAsmHandles.hMain,0
			RET
		.EndIf
		
	.EndIf
	Invoke CallWindowProc,OldOutProc,hWnd,uMsg,wParam,lParam
	RET
NewOutProc EndP

OutParentInit Proc hWnd:HWND
	Invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR szCodeHi,NULL,WS_VISIBLE OR WS_CHILD OR STYLE_NOSPLITT OR STYLE_NOLINENUMBER OR STYLE_NOCOLLAPSE OR STYLE_NOSIZEGRIP OR STYLE_NOHILITE OR STYLE_NODIVIDERLINE OR STYLE_NOSTATE OR STYLE_NODBLCLICK,CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,hWnd,NULL,hInstance,0
	MOV hOut, EAX
	MOV WinAsmHandles.hOut,EAX
	
    Invoke SendMessage, hOut, CHM_SUBCLASS, 0, Offset NewOutProc
    MOV OldOutProc,EAX
    
    Invoke CreatePopupMenu
    MOV hOutPopUpMenu,EAX
    
    Invoke AppendMenu,hOutPopUpMenu,MF_STRING,IDM_COPYSELECTION,Offset szCopySelection
	Invoke AppendMenu,hOutPopUpMenu,MF_STRING,IDM_COPYALLTEXT,Offset szCopyAllText
	Invoke AppendMenu,hOutPopUpMenu,MF_SEPARATOR,0,0
	Invoke AppendMenu,hOutPopUpMenu,MF_STRING,IDM_SAVEOUTTEXT,Offset szSaveOutText
	RET
OutParentInit EndP

OutParentProc Proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
Local Rect	:RECT
	.If uMsg == WM_SIZE
		Invoke SendMessage,hWnd,WAM_GETCLIENTRECT,0,ADDR Rect
		MOV EAX,Rect.right
		SUB EAX,Rect.left
		MOV ECX,Rect.bottom
		SUB ECX,Rect.top
		Invoke MoveWindow,hOut,Rect.left,Rect.top,EAX,ECX,TRUE
	.ElseIf uMsg==WM_SHOWWINDOW
		.If wParam
			Invoke CheckMenuItem,hMenu,IDM_VIEW_OUTPUT,MF_CHECKED
		.Else
			Invoke CheckMenuItem,hMenu,IDM_VIEW_OUTPUT,MF_UNCHECKED
		.EndIf
	.EndIf
	Invoke CallWindowProc,ADDR DockWndProc,hWnd,uMsg,wParam,lParam
	RET
OutParentProc EndP

CboSelectProc_SelChange Proc Uses EBX lpData:DWORD
Local Buffer[256]:BYTE

	MOV EBX,lpData
	Invoke SendMessage,CHILDWINDOWDATA.hCombo[EBX],CB_GETCURSEL,0,0
	MOV EDX,EAX	
	Invoke SendMessage,CHILDWINDOWDATA.hCombo[EBX],CB_GETLBTEXT, EDX, ADDR Buffer
	Invoke ScrollToTop,lpData,ADDR Buffer
	RET
CboSelectProc_SelChange EndP

DoTheChild Proc hChild:HWND, EditorStyle:DWORD, lpData:DWORD, WindowIcon:DWORD

	;Do the Edit Control
	;OR EditorStyle,STYLE_DRAGDROP
	Invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR szCodeHi,NULL,EditorStyle ,CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,hChild,NULL,hInstance,0
	MOV hEditor, EAX
	MOV ECX, lpData
	MOV CHILDWINDOWDATA.hEditor[ECX],EAX

	Invoke SendMessage,hChild,WM_SETICON,ICON_BIG,WindowIcon

	Invoke SendMessage,hEditor,CHM_SETCOLOR,0,ADDR col
	Invoke SetFormat, hEditor
	Invoke SendMessage,hEditor,EM_SETMODIFY,FALSE,0
	Invoke SendMessage,hEditor,EM_EMPTYUNDOBUFFER,0,0
	RET
DoTheChild EndP

;Accepts everything after 'invoke ' and returns only the first word
GetProcedureName Proc Uses ESI lpText:DWORD
	;lpText holds everything after 'invoke '
	MOV ESI,lpText
	Invoke LTrim,ESI,ESI
	Invoke lstrlen,ESI
	ADD EAX,ESI
	.While ESI<EAX
		;" " AND VK_TAB will not be needed when parsing for local procedures is implemented.
		.If BYTE PTR [ESI]=="," || BYTE PTR [ESI]==" " || BYTE PTR [ESI]==VK_TAB
			MOV BYTE PTR [ESI],0
			.Break
		.EndIf
		INC ESI
	.EndW
	MOV ESI,lpText
	RET
GetProcedureName EndP

FillProceduresList Proc Uses EBX EDI hChild:HWND
Local nLine:DWORD
Local lvi:LVITEM
	PUSH ESI
	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	.If CHILDWINDOWDATA.dwTypeOfFile[EBX]==1 || CHILDWINDOWDATA.dwTypeOfFile[EBX]==2 || CHILDWINDOWDATA.dwTypeOfFile[EBX]==51	;<----51 should n't use it here really
		MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE ;OR LVIF_STATE
		MOV lvi.iImage, 0
		
		MOV nLine,-1
		
		@@:
		Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_NXTBOOKMARK,nLine,1
		.If EAX!=-1
			;PrintDec EAX
			MOV nLine,EAX
			Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_ISLINE,nLine,Offset szProc
			.If !EAX
				CALL AddName
			.EndIf
			JMP @B
		.EndIf
		MOV nLine,-1
		
		@@:
		Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_NXTBOOKMARK,nLine,2
		.If EAX!=-1
			;PrintDec EAX
			MOV nLine,EAX
			Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_ISLINE,nLine,Offset szProc
			.If !EAX
				CALL AddName
			.EndIf
			JMP @B
		.EndIf
		JMP Finished
		
		AddName:
		PUSH EBX
		Invoke GetLineText,CHILDWINDOWDATA.hEditor[EBX],nLine,Offset LineTxt
		;Returns in EAX the length of the line text

		
		;FASM		
		;Proc Hello2
		;	RET
		;EndP
		
		
		LEA EDI,LineTxt
		
		PUSH EAX
		Invoke LTrim,EDI,EDI
		POP EAX
	
		.If szProc[0]!="$"	;!=$  means FASM style
			
			DEC EDI
			INC EAX
			@@:
			DEC EAX
			INC EDI
			;PrintDec EDX
			MOV CL,[EDI]
			;PrintDec AL
			CMP CL,VK_SPACE
			JE @F
			CMP CL,VK_TAB
			JNE @B
			;    Proc| Hello2 hi
			
			
			@@:
			DEC EDI
			INC EAX
			@@:
			DEC EAX
			INC EDI
			
			MOV CL,[EDI]
			CMP CL,VK_SPACE
			JE @B
			CMP CL,VK_TAB
			JE @B
			;    |Proc |Hello2 hi
			
		.EndIf
		
		
		MOV EBX,EAX
		
		;LEA EDI,LineTxt
		MOV ESI,EDI
		ADD EBX,EDI
		
		.While ESI<=EBX	;ESI<EBX
			;PrintDec ESI
			;PrintDec EBX
			.If BYTE PTR [ESI]== " " || BYTE PTR [ESI]== VK_TAB ||  BYTE PTR [ESI]==0 ||  BYTE PTR [ESI]==","
				
				MOV BYTE PTR [ESI],0
				MOV lvi.iItem,0
				
				MOV lvi.pszText, EDI
				MOV lvi.iSubItem, 0
				Invoke SendMessage,hListProcedures, LVM_INSERTITEM,0,ADDR lvi
				;Returns the index of the new item which is
				;probably not the same with lvi.iItem since
				;LVS_SORTASCENDING is used
				.If ESI==EBX
					JMP LineFinished
				.EndIf
				
				MOV lvi.iItem,EAX
				
				
				INC ESI
				;Trim out any comments   				
				Invoke TrimComment,ESI
				
				POP EBX
				PUSH nLine
				;--------------------------------------------------
				;Is Procedure Declaration multiline?->Get All Lines
				@@:
				Invoke lstrlen,ESI
				ADD EAX,ESI
				DEC EAX
				;Check whether procedure declaration is multiline
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				.If BYTE PTR [EAX]=="\"
				    mov byte ptr [eax],0
				    jmp Multy
				.EndIf
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				.If BYTE PTR [EAX]==","	;i.e. last char of line is comma
					;We need to get next line as well
				    Multy:
					Invoke lstrcpy,Offset tmpLineTxt,ESI
					INC nLine  					
					
					Invoke GetLineText,CHILDWINDOWDATA.hEditor[EBX],nLine,Offset LineTxt
					
					Invoke TrimComment,Offset LineTxt
					Invoke lstrcat,Offset tmpLineTxt, Offset LineTxt
					Invoke lstrcpy,ESI,Offset tmpLineTxt
					JMP @B
				.EndIf
				;------------------------------------------------------------------
				POP nLine
				PUSH EBX
				
				
				;NEWWWW V5.1.6.0
				MOV EDI,ESI
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                cmp FasmProcStyle,0
                je NotFasm
                call fasm_params_only
                or  eax,eax
                jz  LineFinished
                mov edi,eax
                dec edi
                mov byte ptr [edi],","
				jmp ParametersReady
            NotFasm:
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				
				
				
				;Find first parameter that we know its type e.g. DWORD
				.While BYTE PTR [ESI]!=0
					.If BYTE PTR [ESI]==":"
						;PrintStringByAddr ESI
						
						FindFirstParametersLastLetter:
						DEC ESI
						
						;.If BYTE PTR [ESI]=="," || BYTE PTR [ESI]==" " || BYTE PTR [ESI]==VK_TAB
						;	;This is the first letter of the parameter
						;	MOV BYTE PTR [ESI], ","
						;	JMP RawParameters
						;	.EndIf
						.If BYTE PTR [ESI]==" " || BYTE PTR [ESI]==VK_TAB ||  BYTE PTR [ESI]==","
							;PrintDec 1
							JMP FindFirstParametersLastLetter
							
						.Else
							INC ESI
							@@:
							DEC ESI
							;PrintDec EDI
							;PrintDec ESI
							.If ESI==EDI || BYTE PTR [ESI]=="," || BYTE PTR [ESI]==" " || BYTE PTR [ESI]==VK_TAB
								
								;NEWWWWW V5.1.6.0
								.If ESI==EDI
									DEC ESI
								.EndIf
								
								MOV BYTE PTR [ESI], ","
								JMP RawParameters
							.EndIf
							JMP @B   						
						.EndIf
					.EndIf
					INC ESI
				.EndW
				
				
				RawParameters:
				;Now remove all tabs and spaces
				LEA EDI, tmpLineTxt
				
				
				PUSH EDI
				.While BYTE PTR [ESI]!=0
					.If BYTE PTR [ESI]!=" " && BYTE PTR [ESI]!=VK_TAB
						MOV CL, BYTE PTR [ESI]
						MOV BYTE PTR [EDI],CL
						INC EDI
					.EndIf
					INC ESI
				.EndW
				MOV	BYTE PTR [EDI],0	;Insert NULL terminator
				POP EDI
        ParametersReady:
				MOV lvi.iSubItem, 1
				MOV lvi.pszText, EDI

				Invoke SendMessage, hListProcedures, LVM_SETITEM, 0, ADDR lvi
				JMP LineFinished
			.EndIf
			INC ESI
		.EndW
		LineFinished:            
		POP EBX
		RETN
	.EndIf
	
	Finished:
	POP ESI
	RET
FillProceduresList EndP

DisplayToolTip Proc Uses ESI EDI EBX lpText:DWORD

Local hDC				:HDC
Local TextSize			:_SIZE
Local Buffer[256]		:BYTE

Local lvfi				:LV_FINDINFO
Local ScreenRect		:RECT
Local tmpParam			:DWORD
Local nLengthPrevious	:DWORD
	

	MOV ESI,lpText
	.If BYTE PTR [ESI]!=0
		Invoke RtlZeroMemory,ADDR lvfi,SizeOf LV_FINDINFO
		MOV lvfi.flags,LVFI_STRING
		MOV lvfi.psz,ESI
		Invoke SendMessage,hListProcedures,LVM_FINDITEM,-1,ADDR lvfi
		.If EAX!=-1 ;i.e if there is such text in the list
			MOV EDI,EAX
			Invoke GetItemText, hListProcedures, EDI, 0, ADDR Buffer
			MOV FunctionToolTip[0],0
			Invoke lstrcpy, Offset FunctionToolTip, ADDR Buffer
			Invoke GetItemText, hListProcedures, EDI, 1, ADDR Buffer
			Invoke lstrcat, Offset FunctionToolTip, ADDR Buffer
			
			Invoke GetDC,NULL
			MOV hDC,EAX
			Invoke SelectObject,hDC,hFont;Tahoma
			PUSH EAX
			
			LEA EDI, FunctionToolTip
			Invoke lstrlen, EDI
			MOV EBX,EAX
			Invoke GetTextExtentPoint32,hDC,Offset FunctionToolTip,EBX,ADDR TextSize
			PUSH TextSize.x
			
			MOV tmpParam,0
			ADD EBX,EDI
			
			MOV nLengthPrevious,0 ;If no paramteres exist
			.While EDI<EBX
				.If BYTE PTR [EDI]=="," || !nParam
					INC tmpParam
					MOV EAX,tmpParam
					;INC tmpParam
					.If !nParam || EAX==nParam
						MOV CL,BYTE PTR [EDI]
						PUSH ECX
						MOV BYTE PTR [EDI],0
						Invoke lstrlen,Offset FunctionToolTip
						MOV ECX,EAX
						INC ECX
						Invoke GetTextExtentPoint32,hDC,Offset FunctionToolTip,ECX,ADDR TextSize
						MOV EAX,TextSize.x
						MOV nLengthPrevious,EAX
						POP ECX
						MOV BYTE PTR [EDI],CL
						XOR EDI,EDI;<-------------Now becomes a FLAG!
						.Break
					.EndIf
				.EndIf
				INC EDI
			.EndW
			
			POP TextSize.x
			POP EAX
			Invoke SelectObject,hDC,EAX
			Invoke ReleaseDC,NULL,hDC
			
			.If EDI ;&& nParam!=0
				Invoke HideAllLists
				Invoke ShowWindow,hToolTip,SW_HIDE
				RET
			.EndIf	;Get outta here!
			
			;Invoke ShowWindow,hToolTip,SW_SHOWNA
			
			Invoke GetDesktopWindow
			LEA EDX,ScreenRect
			PUSH EDX
			PUSH EAX
			CALL GetWindowRect
			
			ADD TextSize.y,2
			
			MOV EAX,TextSize.y
			SUB PopUpPos.y,EAX;18
			SUB PopUpPos.y,4
			;Thanks Qvasimodo
			ADD TextSize.x,2
			
			MOV EAX,TextSize.x
			MOV ECX,EAX
			ADD ECX,17
			ADD ECX,LineNrWidth
			.If ECX>ScreenRect.right	;i.e tooltip text>Screen width-(LineNrWidth+SelectionnBarWidth)
				SUB ScreenRect.right,ECX
				NEG ScreenRect.right	;Now ScreenRect is minimum left of tooltip allowed
				
				MOV EAX,nLengthPrevious
				SUB PopUpPos.x,EAX
				MOV ECX,PopUpPos.x
				NEG ECX
				.If PopUpPos.x>7FFFFFFFh && ECX>ScreenRect.right
					NEG ScreenRect.right
					MOV EAX,ScreenRect.right
					MOV PopUpPos.x,EAX
				.EndIf
			.Else
				MOV EAX,nLengthPrevious
				SUB PopUpPos.x,EAX
				MOV EAX,17			;Selection Bar Width ++
				ADD EAX,LineNrWidth	;Line Number Width
				.If PopUpPos.x>7FFFFFFFh || PopUpPos.x<EAX
					MOV PopUpPos.x,EAX
				.EndIf
			.EndIf
			
			;Invoke MoveWindow,hToolTip,PopUpPos.x,PopUpPos.y,TextSize.x,TextSize.y,TRUE
			Invoke SetWindowPos,hToolTip,0,PopUpPos.x,PopUpPos.y,TextSize.x,TextSize.y,SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOZORDER
			Invoke InvalidateRect,hToolTip,NULL,TRUE
			Invoke UpdateWindow,hToolTip
		.Else
			Invoke ShowWindow,hToolTip,SW_HIDE
		.EndIf
	.Else
		Invoke ShowWindow,hToolTip,SW_HIDE
	.EndIf
	RET
DisplayToolTip EndP

;Returns TRUE if successful, FALSE otherwise
InsertProcedureFromList Proc Uses EDI ESI EBX
Local Buffer[256]	:BYTE

	Invoke SendMessage,hListProcedures,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_FOCUSED	OR LVNI_SELECTED
	.If EAX!=-1
		PUSH EAX
		
		LEA ESI,Buffer
		PUSH ESI
		PUSH 0
		PUSH EAX
		PUSH hListProcedures
		CALL GetItemText
		
		MOV EBX,Offset FunctionToolTip
		MOV BYTE PTR [EBX],0
		Invoke lstrcpy,EBX, ESI
		
		Invoke SendMessage,hEditor,EM_REPLACESEL,TRUE,ESI
		
		MOV EDI,lpTrigger
		@@:
		.If BYTE PTR [EDI]
			.If [EDI].FUNCTIONLISTTRIGGER.Active==FALSE
				ADD EDI, SizeOf FUNCTIONLISTTRIGGER
				JMP @B
			.EndIf
		.EndIf
		
		POP ECX		
		.If [EDI].FUNCTIONLISTTRIGGER.AcceptsParameters
			Invoke GetItemText, hListProcedures, ECX, 1,ESI
			.If Buffer[0]!=0	;i.e. If there are parameters
				Invoke lstrcat,EBX,ESI
				Invoke SendMessage,hEditor,EM_REPLACESEL,TRUE,Offset szComma
			.EndIf
		.EndIf
		
		Invoke ShowWindow,hListProcedures,SW_HIDE
		
		;Get Procedure Name
		Invoke GetProcedureName,EBX
		MOV nParam,1
		Invoke DisplayToolTip,EBX
	.EndIf
	RET
InsertProcedureFromList EndP

FindProcedureAndSelect Proc Uses EDI ESI lpText:DWORD, dShowToolTip:DWORD
Local lvfi			:LV_FINDINFO
Local Buffer[256]	:BYTE
	;lpText holds everything after 'invoke'
	MOV ESI,lpText
	Invoke LTrim,ESI,ESI
	Invoke lstrlen,ESI
	ADD EAX,ESI
	.While ESI<EAX
		.If BYTE PTR [ESI]=="," || BYTE PTR [ESI]==" " || BYTE PTR [ESI]=="	" || BYTE PTR [ESI]==";" || BYTE PTR [ESI]==")" 
			MOV BYTE PTR [ESI],0
			.Break
		.EndIf
		INC ESI
	.EndW
	
	MOV ESI,lpText
	Invoke RtlZeroMemory,ADDR lvfi,SizeOf LV_FINDINFO
	MOV lvfi.flags,LVFI_STRING or LVFI_PARTIAL; or LVFI_WRAP or LVFI_PARTIAL; Or 
	MOV lvfi.psz,ESI
	Invoke SendMessage,hListProcedures,LVM_FINDITEM,-1,ADDR lvfi
	.If EAX!=-1 ;i.e if there is such text in the list
		.If BYTE PTR[ESI]==0
			MOV EDI,-1
		.Else
			MOV EDI,EAX			
		.EndIf
		Invoke GetItemText, hListProcedures,EDI, 0,ADDR Buffer
		Invoke lstrlen,ESI
		MOV Buffer[EAX],0
		Invoke lstrcmpi,ESI,ADDR Buffer
		.If EAX==0
			.If dShowToolTip==0
				Invoke ShowWindow,hListConstants,SW_HIDE
				Invoke ShowWindow,hToolTip,SW_HIDE
				Invoke ShowWindow,hListProcedures,SW_SHOWNA
				Invoke SelectListItem, hListProcedures, EDI
				Invoke ScrollListItemToTop,hListProcedures,EDI
			.Else
				Invoke DisplayToolTip,ESI;It is the same with lpText
				;Invoke ShowWindow,hListStructureMembers,SW_HIDE
				Invoke ShowWindow,hListProcedures,SW_HIDE
			.EndIf
		.Else
			Invoke ShowWindow,hToolTip,SW_HIDE
			Invoke ShowWindow,hListProcedures,SW_HIDE
		.EndIf
	.EndIf
	RET
FindProcedureAndSelect EndP

DeleteProcedureName Proc
Local chrg			:CHARRANGE
Local fText			:FINDTEXTEX
	
	;Invoke SendMessage,hListProcedures,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_FOCUSED	OR LVNI_SELECTED
	;.If EAX!=-1
		Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
		    
		MOV EDX,lpTrigger
		@@:
		.If BYTE PTR [EDX]
			.If [EDX].FUNCTIONLISTTRIGGER.Active==FALSE
				ADD EDX, SizeOf FUNCTIONLISTTRIGGER
				JMP @B
			.EndIf
		.EndIf
		
		.If [EDX].FUNCTIONLISTTRIGGER.AcceptsParameters
			Invoke SendMessage,hEditor,EM_EXLINEFROMCHAR,0,chrg.cpMin
			PUSH EAX

			
			Invoke GetLineLength,hEditor,EAX
			MOV fText.chrg.cpMax,EAX
			
			POP EDX	;LineSelected
			Invoke SendMessage,hEditor,	EM_LINEINDEX,EDX,0
			;Now EAX is the first character of line
			
			ADD fText.chrg.cpMax,EAX
			
			
			MOV EAX,chrg.cpMin
			MOV fText.chrg.cpMin,EAX
			
			MOV fText.lpstrText,Offset szComma
			Invoke SendMessage,hEditor,EM_FINDTEXTEX,FR_DOWN ,ADDR fText
			.If EAX!=-1
				MOV EAX,fText.chrgText.cpMax
				MOV chrg.cpMax,EAX
				DEC EAX
				JMP MaxFound			
			.EndIf
		.EndIf
		
		MOV EAX,chrg.cpMin
		DEC EAX
		Invoke SendMessage,hEditor,EM_FINDWORDBREAK,WB_MOVEWORDRIGHT,EAX
		MOV chrg.cpMax,EAX
		
		MaxFound:
		;-------
		;INC chrg.cpMin
		Invoke SendMessage,hEditor,EM_FINDWORDBREAK,WB_MOVEWORDLEFT,EAX;chrg.cpMax;
		;EAX is the left of current word (Procedure name)
		MOV chrg.cpMin,EAX
		
		
		Invoke SendMessage,hEditor,EM_EXSETSEL,0,ADDR chrg
		Invoke SendMessage,hEditor,EM_REPLACESEL,TRUE,NULL
	;.EndIf
	RET
DeleteProcedureName EndP

InsertFromList Proc hList:DWORD
Local Buffer[256]:BYTE
Local chrg:CHARRANGE

	Invoke SendMessage,hList,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_FOCUSED OR LVNI_SELECTED
	.If EAX!=-1
		MOV ECX,EAX
		Invoke GetItemText, hList, ECX, 0, ADDR Buffer
		;--Only for Varables------------------------------------------------
		MOV EAX,hList
		.If EAX==hListVariables
			LEA EAX,Buffer
			@@:
			;Here we check if variable is an array such as Bufer[256]
			.If BYTE PTR [EAX]!="[" && BYTE PTR [EAX]!=0
				INC EAX	
				JMP @B
			.Else
				MOV BYTE PTR [EAX],0
			.EndIf
		.ElseIf EAX==hListIncludes
			M2M chrg.cpMin,ReplaceStart
			MOV EAX,ReplaceLength
			ADD EAX,chrg.cpMin
			MOV chrg.cpMax,EAX
			JMP SelectAndReplace
		.EndIf
		;-------------------------------------------------------------------
		Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
		Invoke SendMessage,hEditor,EM_FINDWORDBREAK,WB_MOVEWORDLEFT,chrg.cpMin
		PUSH EAX
		Invoke SendMessage,hEditor,EM_FINDWORDBREAK,WB_MOVEWORDRIGHT,EAX
		POP EDX
		.If EAX>=chrg.cpMax
			MOV chrg.cpMax,EAX
			MOV chrg.cpMin,EDX
		.Else
			Invoke SendMessage,hEditor,EM_FINDWORDBREAK,WB_MOVEWORDRIGHT,chrg.cpMin
			MOV chrg.cpMax,EAX
		.EndIf
		
		SelectAndReplace:
		;----------------
		Invoke SendMessage,hEditor,EM_EXSETSEL,0,ADDR chrg
		Invoke SendMessage,hEditor,EM_REPLACESEL,TRUE,ADDR Buffer
		Invoke ShowWindow,hList,SW_HIDE
	.EndIf

	RET
InsertFromList EndP

ReplaceBlockString Proc Uses EDI lpBlockString:LPSTR, lpBlockName:LPSTR, lpResult:LPSTR

	MOV EDI,lpBlockName
	MOV EAX,lpBlockString
	MOV EDX,lpResult
	
	@@:
	MOV CL,BYTE PTR [EAX]
	.If CL
		
		.If BYTE PTR [EAX]=="$"
			
			NextByte:
			MOV CL,BYTE PTR [EDI]
			
			.If CL
				MOV BYTE PTR [EDX],CL
				
				ADD EDI,1
				ADD EDX,1
				JMP NextByte
				
			.Else
				
				ADD EAX,1
				JMP @B
				
			.EndIf
			
		.Else
			
			MOV BYTE PTR [EDX],CL
			
		.EndIf
		
		ADD EAX,1
		ADD EDX,1
		
		JMP @B
	.Else
		
		MOV BYTE PTR [EDX],0
		
	.EndIf
	
	
	RET
ReplaceBlockString EndP

NewEditorProc Proc Uses EBX EDI ESI hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local chrg				:CHARRANGE			
Local LineSelected		:DWORD
Local tmpLine			:DWORD
Local fText				:FINDTEXTEX
Local rcWorkArea		:RECT

Local bFound			:BOOLEAN
Local fTextVar			:FINDTEXTEX
Local txtrange			:TEXTRANGE
Local dwTriggerMax		:DWORD
Local lpActiveTrigger	:DWORD
Local dwCommasToIgnore	:DWORD
Local dwInspectionMax	:DWORD

	Invoke GetParent,hWnd
	MOV EBX,EAX
	
	MOV EAX,uMsg
	.If EAX==WM_LBUTTONDOWN || EAX==WM_KEYUP || EAX==WM_CHAR || EAX==WM_KEYDOWN
		.If EAX==WM_LBUTTONDOWN
			MOV gl_uMsg,TRUE
		.ElseIf EAX==WM_KEYUP
			MOV gl_uMsg,TRUE
			MOV EAX, wParam
			.If EAX==VK_DOWN || EAX==VK_ESCAPE || EAX==VK_UP || EAX==VK_PGDN || EAX==VK_PGUP || EAX==VK_LEFT || EAX==VK_RIGHT || EAX==VK_HOME || EAX==VK_END
				Invoke ShowWindow,hToolTip,SW_HIDE
				Invoke HideAllLists
				;RET
			.Else
				Invoke CallWindowProc,OldEditorProc,hWnd, uMsg, wParam, lParam
				RET
			.EndIf
			
		.ElseIf EAX==WM_KEYDOWN || wParam==VK_TAB
			.If EAX==WM_KEYDOWN 
				MOV gl_uMsg,TRUE
			.Else
				mov gl_uMsg,FALSE
			.EndIf
			
			Invoke SendMessage,EBX,EM_EXGETSEL,0,ADDR chrg
			Invoke GetParent,EBX
			Invoke GetWindowLong,EAX,0
			MOV ECX,EAX
			MOV EAX,chrg.cpMin
			.If EAX!=chrg.cpMax
				MOV [ECX].CHILDWINDOWDATA.bSelection,1
			.Else
				MOV [ECX].CHILDWINDOWDATA.bSelection,0
			.EndIf
			MOV ESI,fAutoComplete
			;AND ESI,(AUTOCOMPLETEWITHSPACE OR AUTOCOMPLETEWITHTAB OR AUTOCOMPLETEWITHENTER)
			
			MOV EAX, wParam
			.If EAX==VK_DOWN
				Invoke IsAnyIntellisenseListVisible
				.If EAX	;EAX=Visible list handle
					MOV EBX,EAX
					Invoke ShowWindow,hToolTip,SW_HIDE
					Invoke SetFocus,EBX
					Invoke SendMessage,EBX,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_FOCUSED OR LVNI_SELECTED
					.If EAX==-1
						Invoke SelectListItem,EBX,0
					.EndIf
					RET
				.Else
					;Invoke ShowWindow,hToolTip,SW_HIDE
					;Invoke HideAllLists
					Invoke CallWindowProc,OldEditorProc,hWnd, uMsg, wParam, lParam
					RET
				.EndIf
				
			.ElseIf EAX==VK_RETURN
				AND ESI,AUTOCOMPLETEWITHENTER
				.If ESI
					JMP AutoComplete
				.EndIf
				
			.ElseIf EAX == VK_SPACE || EAX == VK_TAB
				Invoke GetKeyState,VK_CONTROL
				AND EAX,80h
				.If EAX==80h	;i.e. CTRL_SPACE activates Structures & Variable Types List
					;Find selection
					Invoke SendMessage,EBX,EM_EXGETSEL,0,ADDR chrg
					Invoke SendMessage,EBX,CHM_ISCHARPOS,chrg.cpMin,0
					.If !EAX	;i.e we are neither in comment nor in string
						Invoke ClearPendingMessages,hWnd,WM_KEYDOWN,WM_CHAR
						Invoke HideAllLists
						CALL ShowStructures
						RET
					.EndIf
				.Else
					.If wParam==VK_SPACE
						AND ESI,AUTOCOMPLETEWITHSPACE
						.If !ESI
							Invoke CallWindowProc,OldEditorProc,hWnd, uMsg, wParam, lParam
							RET
						.EndIf
					.Else	;i.e. TAB
						AND ESI,AUTOCOMPLETEWITHTAB
						.If !ESI
							JMP Intellisense
						.EndIf
						
					.EndIf
					
					AutoComplete:
					;-----------
					Invoke IsAnyIntellisenseListVisible
					.If EAX	;EAX=Visible list handle
						DoIt:
						;----
						MOV EDI,EAX
						Invoke SendMessage,EDI,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_SELECTED OR LVNI_FOCUSED
						.If EAX!=-1
							;Watch: I am not sending tab!
							Invoke ClearPendingMessages,hWnd,WM_KEYDOWN,WM_CHAR
							Invoke PostMessage,EDI,WM_KEYDOWN,VK_SPACE,0
							Invoke PostMessage,EDI,WM_KEYUP,VK_SPACE,0
							XOR EAX,EAX
							RET
							
						.ElseIf gl_uMsg	;Basically if TAB go to intellisense
							Invoke CallWindowProc,OldEditorProc,hWnd, uMsg, wParam, lParam
							RET
						.EndIf
					.EndIf
				.EndIf
			.Else
				.If EAX==VK_DELETE
					MOV gl_uMsg,FALSE	;so that in tootip procedure intellisense lists may pop up 
					;Invoke ShowWindow,hToolTip,SW_HIDE
					;Invoke HideAllLists
					JMP Intellisense
				.EndIf
				
				;Invoke ShowWindow,hToolTip,SW_HIDE
				;Invoke HideAllLists
				
				Invoke CallWindowProc,OldEditorProc,hWnd, uMsg, wParam, lParam
				RET
			.EndIf
			
		.Else
			MOV gl_uMsg,FALSE
			.If wParam == ","	;if comma then test for procedures list only
				Invoke IsAnyIntellisenseListVisible
				.If EAX==hListProcedures	;EAX=Visible list handle
					JMP DoIt
				.EndIf
			.EndIf
		.EndIf
		
		;************
		Intellisense:
		;************
		;PrintHex uMsg
		
		Invoke CallWindowProc,OldEditorProc,hWnd, uMsg, wParam, lParam
		;Invoke DoEvents
		Invoke UpdateWindow,WinAsmHandles.hMain
		
		;Find Selection
		Invoke SendMessage,EBX,EM_EXGETSEL,0,ADDR chrg
		Invoke SendMessage,EBX,CHM_ISCHARPOS,chrg.cpMin,0
		.If !EAX	;i.e we are neither in comment nor in string
			Invoke SendMessage,EBX,EM_EXLINEFROMCHAR,0,chrg.cpMin
			MOV LineSelected,EAX
			
			Invoke SendMessage,EBX,	EM_LINEINDEX,LineSelected,0
			;Now EAX is the first character of line
			;so, start searching from the start of line
			MOV fText.chrg.cpMin,EAX
			
			;Search up to the caret pos
			MOV EAX,chrg.cpMax
			MOV fText.chrg.cpMax,EAX
			
			MOV bFound,FALSE
			MOV dwCommasToIgnore,0
			
			MOV ESI,0FFFFFFFFh
			MOV EDI,lpTrigger
			
			MOV EAX,chrg.cpMax
			MOV dwInspectionMax,EAX
			
			NextTigger:
			;----------
			.If BYTE PTR [EDI]
				MOV fText.lpstrText,EDI
				Invoke SendMessage,EBX,EM_FINDTEXTEX,FR_WHOLEWORD,ADDR fText
				MOV EDX,dwInspectionMax;chrg.cpMax
				.If EAX!=-1 && EDX > fText.chrgText.cpMax
					.If fText.chrgText.cpMax<ESI
						MOV ESI,fText.chrgText.cpMax
						MOV lpActiveTrigger,EDI
					.EndIf
				.EndIf
				ADD EDI, SizeOf FUNCTIONLISTTRIGGER
				JMP NextTigger
				
			.Else
				.If ESI!=0FFFFFFFFh	;ie. found
					MOV EDI,lpActiveTrigger
					.If !bFound || (bFound && [EDI].FUNCTIONLISTTRIGGER.CanBeAParameter==TRUE)
						MOV bFound,TRUE
						MOV fText.chrg.cpMin,ESI
						
						;INC fText.chrg.cpMin
						
						MOV dwTriggerMax,ESI
						
						MOV EDX,lpTrigger
						Next:
						.If BYTE PTR [EDX]
							MOV [EDX].FUNCTIONLISTTRIGGER.Active,FALSE
							ADD EDX, SizeOf FUNCTIONLISTTRIGGER
							JMP Next
						.EndIf
						MOV [EDI].FUNCTIONLISTTRIGGER.Active,TRUE
						
						 .If [EDI].FUNCTIONLISTTRIGGER.AcceptsParameters
							MOV ESI,0FFFFFFFFh
							MOV EDI,lpTrigger
							JMP NextTigger
						.EndIf
					.EndIf
				.EndIf
			.EndIf
			
			Invoke GetKeyState,VK_CONTROL
			AND EAX,80h	;i.e. Is CTRL pressed ?
			.If bFound && EAX!=80h
				Invoke IsWindowVisible,hListProcedures
				.If EAX==0	;If there is at least one char after that
					;Delete all non-api functions
					Invoke DeleteAllItemsByImage,hListProcedures,0
					Invoke EnumProjectItems,Offset FillProceduresList
				.EndIf
				
				MOV EDX,lpTrigger
				@@:
				.If BYTE PTR [EDX]
					.If [EDX].FUNCTIONLISTTRIGGER.Active==FALSE
						ADD EDX, SizeOf FUNCTIONLISTTRIGGER
						JMP @B
					.EndIf
				.EndIf
				MOV EDI,EDX
				
				;fText.chrgText.cpMax	;last character of "trigger" word
				;chrg.cpMax				;caret pos
				
				MOV ESI,dwTriggerMax
				MOV fText.chrgText.cpMax,ESI	;fText.chrgText.cpMax has probably been fucked!
				
				MOV fTextVar.chrg.cpMin,ESI
				
				MOV txtrange.chrg.cpMin,ESI
				
				Invoke SendMessage,EBX,	EM_LINEINDEX,LineSelected,0
				PUSH EAX
				Invoke GetLineLength,EBX,LineSelected
				POP EDX
				ADD EDX,EAX	;NOW EDX is the postion of last character of line
				
				MOV fTextVar.chrg.cpMax,EDX
				
				
				MOV txtrange.chrg.cpMax,EDX
				MOV txtrange.lpstrText,Offset CurrentLineTxt
				Invoke SendMessage,EBX,EM_GETTEXTRANGE,0 ,ADDR txtrange
				
				;Now CurrentLineTxt is the text after last character of "trigger" word up to the end of line
				LEA ESI,CurrentLineTxt
				@@:
				.If BYTE PTR [ESI] == " " || BYTE PTR [ESI] == "	"
					INC ESI
					INC fText.chrgText.cpMax
					JMP @B
				.EndIf
				
				
				.If [EDI].FUNCTIONLISTTRIGGER.OpeningParenthesis 
					MOV DL,"("
					.If DL==BYTE PTR [ESI]
						INC fText.chrgText.cpMax
						INC ESI
						
						@@:
						.If BYTE PTR [ESI] == " " || BYTE PTR [ESI] == "	"
							INC ESI
							INC fText.chrgText.cpMax
							JMP @B
						.EndIf
					.Else
						Invoke ShowWindow,hToolTip,SW_HIDE
						Invoke ShowWindow,hListProcedures,SW_HIDE
						RET
					.EndIf
					
					PUSH EDI
					XOR EDX,EDX
					MOV EDI,chrg.cpMax;dwInspectionMax
					SUB EDI,fText.chrgText.cpMax
					
					MOV EAX,1	;i.e. one opening parenthesis found
					MOV ECX,ESI
					.While BYTE PTR [ECX] && EDI
						DEC EDI
						.If BYTE PTR [ECX]=="("
							INC EAX
						.ElseIf BYTE PTR [ECX]==")"
							DEC EAX
						.ElseIf BYTE PTR [ECX]=="," && SDWORD PTR EAX > 0
							INC EDX
						.EndIf
						INC ECX
					.EndW
					POP EDI
					
					.If SDWORD PTR EAX <= 0 ;i.e. matching opening & closing parenthessis AND we are IN
						MOV dwCommasToIgnore,EDX
						;PrintDec dwCommasToIgnore
						;PrintText "WE are in the PREVIOUS function call"
						Invoke lstrlen,EDI
						MOV EDX,dwTriggerMax
						SUB EDX,EAX
						MOV fText.chrg.cpMax,EDX
						Invoke SendMessage,EBX,	EM_LINEINDEX,LineSelected,0
						;Now EAX is the first character of line
						;so, start searching from the start of line
						MOV fText.chrg.cpMin,EAX
						
						MOV EAX,dwTriggerMax
						;MOV chrg.cpMax,EAX
						MOV dwInspectionMax,EAX
						
						MOV EDI,lpTrigger
						MOV ESI,0FFFFFFFFh
						MOV bFound,FALSE
						JMP NextTigger  
					.Else
						
						;PrintText "We are IN the this function call"
					.EndIf
					
				.EndIf
				
				MOV fTextVar.lpstrText,Offset szComma
				Invoke SendMessage,EBX,EM_FINDTEXTEX,FR_DOWN ,ADDR fTextVar
				MOV EDX,chrg.cpMin
				.If EAX==-1	|| EDX < fTextVar.chrgText.cpMax ;no comma found or FIRST comma AFTER caret position
					MOV nParam,0
					Invoke SendMessage,EBX,EM_FINDWORDBREAK,WB_MOVEWORDRIGHT,fText.chrgText.cpMax
					PUSH EAX
					Invoke SendMessage,EBX,EM_FINDWORDBREAK,WB_MOVEWORDLEFT,EAX
					POP EDX
					
					.If chrg.cpMax>EDX || chrg.cpMax<EAX
						Invoke ShowWindow,hToolTip,SW_HIDE
						Invoke ShowWindow,hListProcedures,SW_HIDE
						RET
					.EndIf
					.If gl_uMsg
						Invoke SendMessage,EBX,EM_POSFROMCHAR,ADDR PopUpPos,EAX
						ADD PopUpPos.x,4;some more space!!
					.Else
						Invoke SendMessage,EBX,EM_POSFROMCHAR,ADDR PopUpPos,EDX
					.EndIf
					ADD PopUpPos.x,6	;some more space!!
					
					Invoke ClientToScreen,hWnd,ADDR PopUpPos
					CALL MoveAndSize
					Invoke FindProcedureAndSelect,ESI,gl_uMsg
					
				.Else
					MOV nParam,1
					.If [EDI].FUNCTIONLISTTRIGGER.AcceptsParameters
						;remember that fTextVar.chrg.cpMax is already the line end
						
						MOV EAX,fTextVar.chrgText.cpMax
						
						@@:
						MOV fTextVar.chrg.cpMin,EAX
						
						Invoke SendMessage,EBX,EM_FINDTEXTEX,FR_DOWN ,ADDR fTextVar
						.If EAX!=-1
							MOV EAX,fTextVar.chrgText.cpMax
							.If EAX<=chrg.cpMin
								INC nParam
								JMP @B
							.EndIf
						.EndIf
						
						MOV EAX,dwCommasToIgnore
						SUB nParam,EAX
					;.Else
						;for example "CALL" will always show the first parameter as active
					.EndIf
					
					Invoke SendMessage,EBX,EM_POSFROMCHAR,ADDR PopUpPos,chrg.cpMin
					ADD PopUpPos.x,6	;Some more space!!
					Invoke ClientToScreen,hWnd,ADDR PopUpPos
					
					Invoke FindProcedureAndSelect,ESI,TRUE
				.EndIf
				
			.Else;If uMsg==WM_CHAR
				Invoke ShowWindow,hToolTip,SW_HIDE
				.If uMsg==WM_CHAR
					Invoke ShowWindow,hListProcedures,SW_HIDE
					Invoke ShowWindow,hListConstants,SW_HIDE
					MOV EAX, wParam
					.If EAX!=VK_ESCAPE
						Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,ADDR szLocal
						.If EAX==0
							Invoke InProcedure,EBX,LineSelected
							.If EAX	;We are in procedure
								Invoke AutoStructuresList
							.Else
								Invoke ShowWindow,hListStructures,SW_HIDE
							.EndIf
						.Else
							Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,Offset szProc
							.If EAX==0
								Invoke AutoStructuresList
							.Else
								Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,CTEXT("$ PROTO")
								.If EAX==0
									Invoke AutoStructuresList
								.Else
									Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,Offset szInclude
									.If EAX==0
										Invoke AutoIncludesList,1
									.Else
										Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,Offset szIncludeLib
										.If EAX==0
											Invoke AutoIncludesList,2
										.Else
											Invoke ShowWindow,hListIncludes,SW_HIDE
											Invoke ShowWindow,hListStructures,SW_HIDE
											Invoke AutoVariableAndStructureMembersList,TRUE
										.EndIf
									.EndIf
								.EndIf
							.EndIf
						.EndIf
					.EndIf
					
					;MOV EAX,wParam
					.If wParam==VK_RETURN	;complete procedure skeleton
						DEC LineSelected	;i.e is the previous line a xxxx Proc line ?
						
						MOV EAX,LineSelected
						MOV tmpLine,EAX
						
						
						Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,Offset szProc
						
						.If EAX==0	;This is a xxxx Proc
							
							Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,Offset szOption
							.If EAX	;i.e. this is not a "option Proc" line
								
								MOV ESI,1
								
							.Else
								
								JMP StopChecks
								
							.EndIf
							
						.Else
							
							Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,Offset szMacro
							.If EAX==0	;This is a xxxx MACRO
								
								MOV ESI,2
								
							.Else
								
								Invoke SendMessage,EBX,CHM_ISLINE,LineSelected,Offset szStruct
								.If EAX==0	;This is a xxxx Struct
									
									MOV ESI,3
									
								.Else
									
									JMP StopChecks
									
								.EndIf
								
							.EndIf
							
						.EndIf
						
						
						
						Invoke GetLineText,EBX,LineSelected,Offset CurrentLineTxt
						
						;NEW
						.If ESI==1
							MOV EDX, Offset szProc
						.ElseIf ESI==2
							MOV EDX, Offset szMacro
						.Else
							MOV EDX, Offset szStruct
						.EndIf
						
						.If BYTE PTR [EDX]=="$"
							;PrintDec 1
							Invoke GetFirstWordOfLine,Offset CurrentLineTxt
						.Else
							Invoke GetSecondWordOfLine,Offset CurrentLineTxt
						.EndIf
						
						MOV EDI,EAX
						;PrintStringByAddr EDI
						CALL FillBlock
						
						;PrintStringByAddr EAX
;;						
;;						;Invoke GetProcedureName, Offset CurrentLineTxt
						
						StopChecks:
						
;;						;--------------------------------------------------------------
;;						Invoke SendMessage,EBX,EM_GETLINECOUNT,0,0
;;						MOV EDI,EAX
;;						@@:
;;						INC tmpLine
;;						.If tmpLine<=EDI
;;							
;;							
;;							Invoke SendMessage,EBX,CHM_ISLINE,tmpLine,Offset szProc
;;							.If EAX!=0	;this is NOT a Proc line
;;								Invoke SendMessage,EBX,CHM_ISLINE,tmpLine,Offset szMacro
;;								.If EAX!=0	;this is NOT a Macro line
;;									Invoke SendMessage,EBX,CHM_ISLINE,tmpLine,Offset szStruct
;;									.If EAX!=0
;;										
;;										
;;										
;;										JMP @B
;;										
;;									.EndIf
;;								.EndIf
;;							.EndIf
;;							
;;							
;;							
;;							
;;							.If ESI==1		;Procedure
;;								
;;								LEA EDX,szEndp
;;								
;;							.ElseIf ESI==2	;Macro
;;								
;;								Invoke SendMessage,EBX,CHM_ISLINE,tmpLine,Offset szMacro
;;								.If EAX==0
;;									CALL FillBlock
;;									JMP StopChecks
;;								.EndIf
;;								LEA EDX,szEndm
;;								
;;							.Else;If ESI==3	;Struct
;;								
;;								LEA EDX,szEnds
;;								
;;							.EndIf
;;							
;;							Invoke SendMessage,EBX,CHM_ISLINE,tmpLine,EDX;Is this is endp or Endm or Ends line
;;							.If EAX==0	;this is endp or Endm or Ends line
;;								.If ESI==2	;i.e. we are looking for endm
;;									JMP StopChecks
;;								.Else
;;									;ESI is CurrentLineTxt
;;									;Now ESI is only the procedure name
;;									Invoke GetLineText,EBX,tmpLine,Offset tmpLineTxt
;;									Invoke GetProcedureName,Offset tmpLineTxt
;;									Invoke lstrcmpi, Offset CurrentLineTxt, Offset tmpLineTxt
;;									.If EAX!=0	;i.e 'xxxx' of EndP found is not the same with 'yyyy' of Proc
;;										CALL FillBlock
;;									.EndIf
;;								.EndIf
;;							.Else
;;								JMP @B
;;							.EndIf
;;							
;;						.Else
;;							
;;							CALL FillBlock	
;;							
;						.EndIf
;						
;						StopChecks:
;						
					.EndIf
					
				.EndIf
				
			.EndIf
			
		.Else
			
			Invoke HideAllLists
			
		.EndIf
		
		
		RET
		
	.ElseIf EAX==WM_KILLFOCUS
		MOV EBX,wParam
		.If EBX!=hListProcedures
		   	Invoke ShowWindow,hListProcedures,SW_HIDE
		.EndIf
		.If EBX!=hListStructures
			Invoke ShowWindow,hListStructures,SW_HIDE
		.EndIf
		.If EBX!=hListConstants
			Invoke ShowWindow,hListConstants,SW_HIDE
		.EndIf
		.If EBX!=hListStructureMembers
			Invoke ShowWindow,hListStructureMembers,SW_HIDE
		.EndIf
		.If EBX!=hListVariables
			Invoke ShowWindow,hListVariables,SW_HIDE
		.EndIf	
		.If EBX!=hListIncludes
			Invoke ShowWindow,hListIncludes,SW_HIDE
		.EndIf	
		Invoke ShowWindow,hToolTip,SW_HIDE
		
	.ElseIf EAX==WM_RBUTTONDOWN || EAX==WM_MOUSEWHEEL;EAX==WM_LBUTTONDOWN || 
		Invoke ShowWindow,hToolTip,SW_HIDE
		Invoke HideAllLists
    .EndIf
    Invoke CallWindowProc, OldEditorProc, hWnd, uMsg, wParam, lParam
    RET

	;-----------------------------------------------------------------------
	ShowStructures:
	Invoke SendMessage,EBX,EM_EXGETSEL,0,ADDR chrg
	Invoke SendMessage,EBX,EM_POSFROMCHAR,ADDR PopUpPos,chrg.cpMin
	CALL MapPoint
    Invoke MoveWindow,hListStructures,PopUpPos.x,PopUpPos.y,220,160,TRUE
	Invoke ShowWindow,hListStructures,SW_SHOWNA
	Invoke SelectListItem, hListStructures,0
    Invoke ScrollListItemToTop,hListStructures,0
	RETN
	
	;-----------------------------------------------------------------------
	MapPoint:
	ADD PopUpPos.x,6	;Just to have some extra room
	Invoke ClientToScreen,hWnd,ADDR PopUpPos
	RETN
	
	;-----------------------------------------------------------------------
	FillBlock:
	.If ESI==1	;Proc
		
		
		Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szRet, 0, Offset IniFileName
		.If EAX==1			;Lowercase
			LEA ECX,szRETLowerCase
		.ElseIf EAX==2		;Uppercase
			LEA ECX,szRETUpperCase
		.Else				;Default
			LEA ECX,szRETDefault
		.EndIf
		
		Invoke SendMessage,EBX,EM_REPLACESEL,TRUE,ECX
		
		
		Invoke ReplaceBlockString,Offset szEndp,EDI,Offset tmpLineTxt
		
	.ElseIf ESI==2			;Macro
		
		
		Invoke ReplaceBlockString,Offset szEndm,EDI,Offset tmpLineTxt
		
	.ElseIf ESI==3		;Structure
	
;		Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEndP, 0, Offset IniFileName
;		
;		.If EAX==1			;Lowercase
;			LEA ECX,szEndSLowerCase
;		.ElseIf EAX==2		;Uppercase
;			LEA ECX,szEndSUpperCase
;		.Else				;Default
;			LEA ECX,szEndSDefault
;		.EndIf
;		
;		PUSH ECX
		Invoke ReplaceBlockString,Offset szEnds,EDI,Offset tmpLineTxt


	.EndIf
;	PUSH EDI
;	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEndP, 0, Offset IniFileName
;	MOV EDI,EAX
;
;	Invoke SendMessage,EBX,WM_SETREDRAW,FALSE,0
;	.If ESI==1 ;i.e. Proc
;		Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szRet, 0, Offset IniFileName
;		.If EAX==1			;Lowercase
;			LEA ECX,szRETLowerCase
;		.ElseIf EAX==2		;Uppercase
;			LEA ECX,szRETUpperCase
;		.Else				;Default
;			LEA ECX,szRETDefault
;		.EndIf
;		
;		Invoke SendMessage,EBX,EM_REPLACESEL,TRUE,ECX
;		
;		.If EDI==1			;Lowercase
;			LEA ECX,szEndPLowerCase
;		.ElseIf EDI==2		;Uppercase
;			LEA ECX,szEndPUpperCase
;		.Else				;Default
;			LEA ECX,szEndPDefault
;		.EndIf
;		Invoke lstrcat,Offset CurrentLineTxt,ECX	;" EndP"
;		
;	.ElseIf ESI==2	;MACRO
;		
;		Invoke SendMessage,EBX,EM_REPLACESEL,TRUE,Offset szCr
;		.If EDI==1			;Lowercase
;			LEA ECX,szEndMLowerCase
;		.ElseIf EDI==2		;Uppercase
;			LEA ECX,szEndMUpperCase
;		.Else				;Default
;			LEA ECX,szEndMDefault
;		.EndIf
;		Invoke lstrcpy,Offset CurrentLineTxt,ECX
;		
;	.ElseIf ESI==3	;Struct
;		
;		Invoke SendMessage,EBX,EM_REPLACESEL,TRUE,Offset szCr
;		.If EDI==1			;Lowercase
;			LEA ECX,szEndSLowerCase
;		.ElseIf EDI==2		;Uppercase
;			LEA ECX,szEndSUpperCase
;		.Else				;Default
;			LEA ECX,szEndSDefault
;		.EndIf
;		Invoke lstrcat,Offset CurrentLineTxt,ECX
;		
;	.EndIf
	
	PUSH Offset tmpLineTxt
	PUSH TRUE
	PUSH EM_REPLACESEL
	PUSH EBX
	CALL SendMessage
	
	Invoke SendMessage,EBX,EM_EXSETSEL,0,ADDR chrg

;	Invoke SendMessage,EBX,EM_REPLACESEL,TRUE,Offset CurrentLineTxt
;	Invoke SendMessage,EBX,EM_EXSETSEL,0,ADDR chrg
;
	Invoke SetFocus,EBX
	Invoke SendMessage,EBX,WM_SETREDRAW,TRUE,0
	Invoke InvalidateRect,EBX,NULL,TRUE
;	
;	POP EDI
	RETN
	
	;-----------------------------------------------------------------------
	MoveAndSize:
	Invoke SystemParametersInfo,SPI_GETWORKAREA,0,ADDR rcWorkArea,0
	
	Invoke GetWindowLong,hWnd,0
	MOV EDX,[EAX].EDIT.fntinfo.fntht
	ADD EDX,PopUpPos.y
	
	
	MOV EAX,EDX
	ADD EAX,160
	.If EAX> rcWorkArea.bottom
		MOV ECX,rcWorkArea.bottom
		SUB ECX,EDX
	.Else
		MOV ECX,160
	.EndIf
	Invoke MoveWindow,hListProcedures,PopUpPos.x,EDX,250,ECX,TRUE

	RETN
NewEditorProc EndP

TimerUpdateProcedures Proc Uses EBX hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	Invoke GetWindowLong,hWin,0
	MOV EBX,EAX
	.If [EBX].CHILDWINDOWDATA.fTimer
		DEC [EBX].CHILDWINDOWDATA.fTimer
		Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,FALSE,0
		Invoke DeleteProcTreeItems,[EBX].CHILDWINDOWDATA.hEditor
		Invoke UpdateBlocksList,[EBX].CHILDWINDOWDATA.hEditor
		Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,TRUE,0
	.EndIf
	RET
TimerUpdateProcedures EndP

ChildWndCreate Proc Uses EBX EDI, hWnd:HWND, dwTypeOfFile:DWORD
Local tvinsert:TV_INSERTSTRUCT
Local Buffer[256]:BYTE

	;Allocate memory for window private data
	Invoke HeapAlloc, hMainHeap, HEAP_ZERO_MEMORY, SizeOf CHILDWINDOWDATA
	MOV	EBX, EAX ;Pointer to Child Data
	PUSH EBX
	
	;Create a NON visible Combo
	Invoke CreateWindowEx,NULL,ADDR szComboBoxClass,NULL,CBS_SORT or CBS_DROPDOWNLIST OR WS_CHILD OR WS_VSCROLL, 0,0,0,0,hWnd,NULL,hInstance,NULL
	MOV [EBX].CHILDWINDOWDATA.hCombo,EAX
	Invoke SendMessage,EAX,WM_SETFONT,hFontTahoma,FALSE
	.If dwTypeOfFile<101
		MOV tvinsert.item._mask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE
		.If hParentItem == 0
			MOV tvinsert.hParent,NULL
			MOV tvinsert.hInsertAfter,TVI_ROOT
			MOV tvinsert.item.pszText,Offset ProjectTitle
			MOV tvinsert.item.iImage,41
			MOV tvinsert.item.iSelectedImage,41
			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
			MOV hParentItem,EAX
		.EndIf
			
		PUSH hParentItem
		POP tvinsert.hParent
		MOV tvinsert.hInsertAfter,TVI_LAST
		MOV tvinsert.item.iImage,45
		MOV tvinsert.item.iSelectedImage,45
		
		.If dwTypeOfFile==1  || dwTypeOfFile==51	;.asm or module
			
			.If dwTypeOfFile==51
				.If hModulesItem==0
					MOV tvinsert.item.pszText,Offset szModules
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
					MOV hModulesItem, EAX
				.EndIf
				MOV tvinsert.item.iImage,47
				MOV tvinsert.item.iSelectedImage,47
			.Else
				.If hASMFilesItem==0
					MOV tvinsert.item.pszText,Offset szASMFiles
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
					MOV hASMFilesItem, EAX
				.EndIf
				MOV tvinsert.item.iImage,26
				MOV tvinsert.item.iSelectedImage,26
			.EndIf
			
			Invoke ImageList_GetIcon,hImlNormal,tvinsert.item.iImage,ILD_NORMAL
			MOV EDX, WS_CHILD OR WS_VISIBLE or STYLE_NOSTATE OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			.If !TabIndicators
				OR EDX,STYLE_NOTABINDICATORS			
			.EndIf
			
			Invoke DoTheChild, hWnd,EDX,EBX,EAX
			Invoke SendMessage,hEditor,CHM_SUBCLASS, 0, Offset NewEditorProc
			MOV OldEditorProc,EAX
			Invoke SetKeyWords, hEditor,0
			Invoke SetAllBlocks,hEditor
			;Show Combo		
			Invoke ShowWindow,CHILDWINDOWDATA.hCombo[EBX],SW_SHOW
			Invoke SetTimer,hWnd,201,300,ADDR TimerUpdateProcedures
			.If dwTypeOfFile==51
				MOV EAX,hModulesItem
			.Else
				MOV EAX,hASMFilesItem
			.EndIf
		.ElseIf dwTypeOfFile==2	;.inc
			.If hIncludeFilesItem == 0
				MOV tvinsert.item.pszText,Offset szIncludeFiles
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
				MOV hIncludeFilesItem, EAX
			.EndIf
			
			Invoke ImageList_GetIcon,hImlNormal,27,ILD_NORMAL
			
			MOV EDX, WS_CHILD OR WS_VISIBLE or STYLE_NOSTATE OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			.If !TabIndicators
				OR EDX,STYLE_NOTABINDICATORS			
			.EndIf
			Invoke DoTheChild, hWnd, EDX, EBX, EAX
			
			Invoke SendMessage,hEditor,CHM_SUBCLASS, 0, Offset NewEditorProc
			MOV OldEditorProc,EAX
			Invoke SetKeyWords, hEditor,0
			;Invoke SendMessage,hEditor,CHM_SETBLOCKS,0,Offset CHBDProc
			Invoke SetAllBlocks,hEditor
			;Show Combo		
			Invoke ShowWindow,CHILDWINDOWDATA.hCombo[EBX],SW_SHOW
			Invoke SetTimer,hWnd,201,300,ADDR TimerUpdateProcedures
			MOV tvinsert.item.iImage,27
			MOV tvinsert.item.iSelectedImage,27
			MOV EAX,hIncludeFilesItem
		.ElseIf dwTypeOfFile==3	;.rc
			.If hResourceFilesItem == 0
				MOV tvinsert.item.pszText,Offset szResourceFiles
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
				MOV hResourceFilesItem, EAX
			.EndIf
			Invoke ImageList_GetIcon,hImlNormal,28,ILD_NORMAL
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			Invoke DoTheChild,hWnd,EDX,EBX,EAX
			Invoke SetKeyWords, hEditor,1
			MOV tvinsert.item.iImage,28
			MOV tvinsert.item.iSelectedImage,28
			MOV EAX,hResourceFilesItem
		.ElseIf dwTypeOfFile==4	;.txt
			.If hTextFilesItem == 0
				MOV tvinsert.item.pszText,Offset szTextFiles
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
				MOV hTextFilesItem, EAX
			.EndIf
			Invoke ImageList_GetIcon,hImlNormal,37,ILD_NORMAL
			
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NOHILITE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			Invoke DoTheChild, hWnd,EDX,EBX,EAX
			MOV tvinsert.item.iImage,37
			MOV tvinsert.item.iSelectedImage,37
			MOV EAX,hTextFilesItem
		.ElseIf dwTypeOfFile==5	;.def
			.If hDefFilesItem == 0
				MOV tvinsert.item.pszText,Offset szDefinitionFiles
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
				MOV hDefFilesItem, EAX
			.EndIf
			Invoke ImageList_GetIcon,hImlNormal,39,ILD_NORMAL
			
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NOHILITE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			
			Invoke DoTheChild, hWnd,EDX, EBX, EAX
			MOV tvinsert.item.iImage,39
			MOV tvinsert.item.iSelectedImage,39
			MOV EAX,hDefFilesItem
		.ElseIf dwTypeOfFile==6	;.bat
			.If hBatchFilesItem == 0
				MOV tvinsert.item.pszText,Offset szBatchFiles
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
				MOV hBatchFilesItem, EAX
			.EndIf
			Invoke ImageList_GetIcon,hImlNormal,40,ILD_NORMAL
			Invoke DoTheChild, hWnd, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP, EBX, EAX;IDI_BATICON
			Invoke SetKeyWords, hEditor,2
			MOV tvinsert.item.iImage,40
			MOV tvinsert.item.iSelectedImage,40
			MOV EAX,hBatchFilesItem
		.Else;If dwTypeOfFile==7	;Any other unsupported File Type
			.If hOtherFilesItem == 0
				MOV tvinsert.item.pszText,Offset szOtherFiles
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0,ADDR tvinsert
				MOV hOtherFilesItem, EAX
			.EndIf
			Invoke ImageList_GetIcon,hImlNormal,38,ILD_NORMAL
			
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NOHILITE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			
			Invoke DoTheChild, hWnd,EDX, EBX, EAX;IDI_OTHERICON
			MOV tvinsert.item.iImage,38
			MOV tvinsert.item.iSelectedImage,38
			MOV EAX,hOtherFilesItem
		.EndIf
	.Else	;External Files
		.If dwTypeOfFile==101		;.asm
			Invoke ImageList_GetIcon,hImlNormal,26,ILD_NORMAL
			
			MOV EDX, WS_CHILD OR WS_VISIBLE or STYLE_NOSTATE OR STYLE_DRAGDROP
			.If !TabIndicators
				OR EDX,STYLE_NOTABINDICATORS			
			.EndIf
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			

			.EndIf
			
			Invoke DoTheChild, hWnd, EDX, EBX, EAX
			
			Invoke SendMessage,hEditor,CHM_SUBCLASS, 0, Offset NewEditorProc
			MOV OldEditorProc,EAX
			Invoke SetKeyWords, hEditor,0
			Invoke SetAllBlocks,hEditor
			Invoke ShowWindow,CHILDWINDOWDATA.hCombo[EBX],SW_SHOW
		.ElseIf dwTypeOfFile==102	;.inc
			Invoke ImageList_GetIcon,hImlNormal,27,ILD_NORMAL
			
			MOV EDX, WS_CHILD OR WS_VISIBLE or STYLE_NOSTATE OR STYLE_DRAGDROP
			.If !TabIndicators
				OR EDX,STYLE_NOTABINDICATORS			
			.EndIf
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			
			Invoke DoTheChild, hWnd, EDX, EBX, EAX
			
			Invoke SendMessage,hEditor,CHM_SUBCLASS, 0, Offset NewEditorProc
			MOV OldEditorProc,EAX
			Invoke SetKeyWords, hEditor,0
			;Invoke SendMessage,hEditor,CHM_SETBLOCKS,0,Offset CHBDProc
			Invoke SetAllBlocks,hEditor
			Invoke ShowWindow,CHILDWINDOWDATA.hCombo[EBX],SW_SHOW
		.ElseIf dwTypeOfFile==103	;.rc
			Invoke ImageList_GetIcon,hImlNormal,28,ILD_NORMAL
			
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			
			Invoke DoTheChild, hWnd,EDX, EBX, EAX
			Invoke SetKeyWords, hEditor,1
		.ElseIf dwTypeOfFile==104	;.txt
			Invoke ImageList_GetIcon,hImlNormal,37,ILD_NORMAL
			
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NOHILITE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			Invoke DoTheChild, hWnd,EDX, EBX, EAX;IDI_TXTICON
		.ElseIf dwTypeOfFile==105	;.def
			Invoke ImageList_GetIcon,hImlNormal,39,ILD_NORMAL
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NOHILITE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			Invoke DoTheChild, hWnd,EDX, EBX, EAX;IDI_DEFICON
		.ElseIf dwTypeOfFile==106	;.bat
			Invoke ImageList_GetIcon,hImlNormal,40,ILD_NORMAL
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			Invoke DoTheChild, hWnd,EDX, EBX, EAX;IDI_BATICON
			Invoke SetKeyWords, hEditor,2
		.Else;If dwTypeOfFile=107	;Any other unsupported File Type
			Invoke ImageList_GetIcon,hImlNormal,38,ILD_NORMAL
			MOV EDX, WS_VISIBLE OR WS_CHILD OR STYLE_NOCOLLAPSE OR STYLE_NOHILITE OR STYLE_NODIVIDERLINE or STYLE_NOSTATE or STYLE_NOTABINDICATORS OR STYLE_DRAGDROP
			.If ShowScrollTips
				OR EDX,STYLE_SCROLLTIP			
			.EndIf
			Invoke DoTheChild, hWnd,EDX, EBX, EAX
		.EndIf
		POP EBX
		;Show Line Number Column
		Invoke CheckDlgButton,hEditor,-2,TRUE
		Invoke SendMessage,hEditor,WM_COMMAND,-2,0
		
		M2M CHILDWINDOWDATA.dwTypeOfFile[EBX],dwTypeOfFile
		Invoke SendMessage,CHILDWINDOWDATA.hCombo[EBX],WM_SETFONT,hFontTahoma,FALSE
		Invoke RtlMoveMemory,ADDR CHILDWINDOWDATA.szFileName[EBX],ADDR FileName, MAX_PATH
		Invoke SetWindowLong, hWnd, 0, EBX		;Change attribute of specified window
		
		Invoke GetMenuItemCount,WinAsmHandles.PopUpMenus.hWindowMenu
		.If EAX==8
			Invoke AppendMenu, WinAsmHandles.PopUpMenus.hWindowMenu,MF_SEPARATOR,NULL,NULL
		.EndIf





		INC ExternalFilesMenuID
		Invoke AppendMenu, WinAsmHandles.PopUpMenus.hWindowMenu,MF_OWNERDRAW,ExternalFilesMenuID,hWnd;ADDR CHILDWINDOWDATA.szFileName[EBX]
		RET
	.EndIf

	MOV tvinsert.hParent,EAX
	Invoke GetFilesTitle, Offset FileName, ADDR Buffer
	LEA EAX, Buffer
	MOV tvinsert.item.pszText,EAX
	MOV tvinsert.item.cchTextMax,256
	M2M tvinsert.item.lParam, hWnd
	MOV tvinsert.hInsertAfter,TVI_LAST
	MOV tvinsert.item._mask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE+TVIF_PARAM
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0, ADDR tvinsert
	POP EBX
	MOV CHILDWINDOWDATA.hTreeItem[EBX],EAX
	
	;Show Line Number Column
	.If ShowLineNumbersOnOpen

		Invoke CheckDlgButton,hEditor,-2,TRUE
		Invoke SendMessage,hEditor,WM_COMMAND,-2,0
	.EndIf
	
	M2M CHILDWINDOWDATA.dwTypeOfFile[EBX],dwTypeOfFile
	Invoke SendMessage,CHILDWINDOWDATA.hCombo[EBX],WM_SETFONT,hFontTahoma,FALSE
	;Invoke RtlMoveMemory,ADDR CHILDWINDOWDATA.szFileName[EBX],ADDR FileName, MAX_PATH
	Invoke lstrcpy,ADDR CHILDWINDOWDATA.szFileName[EBX],ADDR FileName
	Invoke SetWindowLong, hWnd, 0, EBX		;Change attribute of specified window
	
	RET
ChildWndCreate EndP

ChildWndProc Proc Uses EBX ESI EDI hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local pt			:POINT
Local ps			:PAINTSTRUCT
Local chrg			:CHARRANGE
Local fBlocksUpdate	:BOOLEAN
Local Buffer[256]	:BYTE
Local FileTime		:FILETIME

	Invoke SendCallBackToAllAddIns,pAddInsChildWindowProcedures,hWnd,uMsg,wParam,lParam
	.If EAX==0
		MOV EAX,uMsg
		.If EAX==WM_CREATE
			MOV EDX,lParam
			MOV EBX,[EDX].CREATESTRUCT.lpCreateParams
			MOV EDX,[EBX].MDICREATESTRUCT.lParam
			;Now EDX holds the Type Of this File (e.g .asm, .inc etc)
			;(as sent by the lParam when CreateWindowEx was invoked)
			Invoke ChildWndCreate,hWnd,EDX
			
			Invoke SetTimer,hWnd,300,1000,NULL
			
		.ElseIf EAX==WM_TIMER
			.If wParam==300
				Invoke KillTimer,hWnd,300
				Invoke GetWindowLong,hWnd,0
				MOV EBX,EAX
				Invoke CreateFile,ADDR [EBX].CHILDWINDOWDATA.szFileName,0,FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
				.If EAX!=INVALID_HANDLE_VALUE	;(=-1)
					PUSH EAX
					LEA EDI,FileTime
					Invoke GetFileTime,EAX, NULL, NULL,EDI
					POP EAX
					Invoke CloseHandle,EAX
					
					Invoke CompareFileTime,EDI,ADDR [EBX].CHILDWINDOWDATA.FileTime
					;-1	First file time is less than second file time.
					;0	First file time is equal to second file time.
					;+1	First file time is greater than second file time.
					.If EAX
						Invoke lstrcpy,Offset tmpBuffer,ADDR [EBX].CHILDWINDOWDATA.szFileName
						Invoke lstrcat,Offset tmpBuffer,Offset szFileModified
						Invoke EnableAllDockWindows,FALSE
						Invoke MessageBox,WinAsmHandles.hMain,Offset tmpBuffer,Offset szAppName,MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL
						.If EAX==IDYES
							MOV EDI,hRCEditorWindow
							.If EDI==hWnd
								Invoke ClearRCEditor
							.EndIf
							
							MOV chrg.cpMin,0
							MOV chrg.cpMax,-1
							Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXSETSEL,0,ADDR chrg
							Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_CLEAR,0,0
							Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,FALSE,0
								
								Invoke DeleteProcTreeItems,[EBX].CHILDWINDOWDATA.hEditor
								Invoke LoadFile,[EBX].CHILDWINDOWDATA.hEditor,ADDR [EBX].CHILDWINDOWDATA.szFileName
								
								.If EDI==hWnd
									MOV hRCEditorWindow,EDI
									Invoke GetResources
								.EndIf
								
								MOV EDI, [EBX].CHILDWINDOWDATA.dwTypeOfFile
								.If EDI==1 || EDI==2 || EDI==101 || EDI==102
									Invoke SetAllBlocks,[EBX].CHILDWINDOWDATA.hEditor
									Invoke UpdateProcCombo,[EBX].CHILDWINDOWDATA.hEditor,[EBX].CHILDWINDOWDATA.hCombo
								.EndIf
								.If EDI==1 || EDI==2
									Invoke UpdateBlocksList,[EBX].CHILDWINDOWDATA.hEditor
								.EndIf
							Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETREDRAW,TRUE,0
							;Invoke SetFocus,[EBX].CHILDWINDOWDATA.hEditor
							
						.Else
							Invoke CreateFile,ADDR [EBX].CHILDWINDOWDATA.szFileName,0,FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
							.If EAX!=INVALID_HANDLE_VALUE	;(=-1)
								PUSH EAX
								LEA EDX,[EBX].CHILDWINDOWDATA.FileTime
								Invoke GetFileTime,EAX, NULL, NULL,EDX	;Store the new file time as our reference
								POP EAX
								Invoke CloseHandle,EAX
							.EndIf
						.EndIf
						Invoke EnableAllDockWindows,TRUE
					.EndIf
				.Else
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SETMODIFY,TRUE,0
				.EndIf
				Invoke SetTimer,hWnd,300,1000,NULL
			.EndIf
			
		.ElseIf EAX == WM_SIZE
			Invoke GetWindowLong,hWnd, 0
			MOV	EBX,EAX
			
			MOV EAX,lParam
			AND EAX,0FFFFh
			.If EAX>=230;250
				SUB EAX, 230
				MOV EDX, 230
			.Else
				MOV EDX,EAX
				MOV EAX,0
			.EndIf
			Invoke MoveWindow,CHILDWINDOWDATA.hCombo[EBX],EAX,0,EDX,250,TRUE
			
			MOV EAX,lParam
			MOV EDX,EAX
			AND EAX,0FFFFh
			SHR EDX,16
			SUB EDX,22
			Invoke MoveWindow,CHILDWINDOWDATA.hEditor[EBX],0,22,EAX,EDX,TRUE
			
		;WM_MOUSEACTIVATE is required if user mouse downs in an already
		;activated child so that the Project tree is updated.
		.ElseIf EAX==WM_MDIACTIVATE
			Invoke DefMDIChildProc,hWnd,uMsg,wParam,lParam
			PUSH EAX
			MOV EBX,hWnd
			.If EBX==lParam	;i.e is activating-not deactivating
				Invoke GetWindowLong, hWnd, 0
				MOV EDX,[EAX].CHILDWINDOWDATA.hEditor
				MOV hEditor,EDX
				
				Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET, [EAX].CHILDWINDOWDATA.hTreeItem
				
				.If CanShowMDIChildren
					.If EBX!=hRCEditorWindow
						;Set menus and tools
						Invoke EnableAll
						Invoke EnableDisable,hEditor
						Invoke EnableAllButtonsOnToolBox,FALSE
						Invoke EnableAllButtonsOnRCOptions,FALSE
						.If AutoToolAndOptions && !fClosingProject
							Invoke ShowWindow,hToolBox,SW_HIDE
							Invoke ShowWindow,hRCOptions,SW_HIDE
						.EndIf
						Invoke SetFocus,hEditor
					.Else
						Invoke EnableDisableRC
						.If hADialog
							Invoke EnableAllButtonsOnToolBox,TRUE
						.Else
							Invoke SendMessage,hToolBoxToolBar,TB_ENABLEBUTTON,IDM_TOOLBOX_DIALOG,TRUE
						.EndIf
						Invoke EnableAllButtonsOnRCOptions,TRUE
						
						.If AutoToolAndOptions && !fClosingProject
							Invoke ShowWindow,hToolBox,SW_SHOW
							Invoke ShowWindow,hRCOptions,SW_SHOW
							
							Invoke UpdateWindow,hToolBox
							Invoke UpdateWindow,hRCOptions
							
						.EndIf
					.EndIf
					
					Invoke UpdateWindow,WinAsmHandles.hMain
				.EndIf					
			.EndIf
			POP EAX
			RET
		.ElseIf EAX==WM_SETFOCUS || EAX==WM_MOUSEACTIVATE
			MOV EBX,hWnd
			.If EBX!=hRCEditorWindow
				Invoke SetFocus,hEditor
			.EndIf
			
		.ElseIf EAX==WM_COMMAND
			Invoke GetWindowLong, hWnd, 0
			MOV	EBX,EAX
			MOV EAX,wParam
			SHR EAX,16
			.If AX == BN_CLICKED
				MOV EAX,wParam
				.If AX==-3
					;Expand button clicked
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX], CHM_EXPANDALL, 0, 0;Offset CHBDProc
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX], EM_SCROLLCARET,0,0
				.ElseIf AX==0000FFFCh;-4
					;Collapse button clicked
					MOV EDI,Offset Blocks
					MOV EDX,[EDI]
					.While EDX
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_COLLAPSEALL,0,EDX
						ADD EDI,4
						MOV EDX,[EDI]
					.EndW
					
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_SCROLLCARET,0,0
				.EndIf
			.ElseIf AX==CBN_SELENDOK
				Invoke CboSelectProc_SelChange,EBX
			.EndIf
			
		.ElseIf EAX==WM_NOTIFY
			MOV EDI,lParam
			.If [EDI].NMHDR.code==EN_SELCHANGE
				Invoke GetWindowLong, hWnd, 0
				MOV	EBX,EAX
				
				Invoke IsWindowVisible,hWnd
				.If EAX
					MOV EAX,hWnd
					.If EAX!=hRCEditorWindow
						Invoke EnableDisable,[EBX].CHILDWINDOWDATA.hEditor
					.EndIf
					
					.If bUpdateSelect
						MOV EAX,[EDI].CHSELCHANGE.chrg.cpMin
						SUB EAX,[EDI].CHSELCHANGE.cpLine
						
						MOV ECX,[EDI].CHSELCHANGE.chrg.cpMax
						MOV EDX,ECX
						
						SUB ECX,[EDI].CHSELCHANGE.chrg.cpMin
						
						.If EDX<[EDI].CHSELCHANGE.chrg.cpMin				
							NEG ECX
						.EndIf
						
						MOV EDX,[EDI].CHSELCHANGE.linenr
						INC EDX
						LEA ESI,Buffer
						;"Ln: %lu, Col: %lu, Sel: %lu"
						Invoke wsprintf,ESI,Offset szLnColSel,EDX, EAX,ECX
					.Else
						MOV ESI,Offset szNULL
					.EndIf
					Invoke SendMessage,hStatus,SB_SETTEXT,3,ESI
				.EndIf
				
				.If [EDI].CHSELCHANGE.seltyp==SEL_OBJECT
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_GETBOOKMARK,[EDI].CHSELCHANGE.linenr,0
					.If EAX==1
						;Collapse
						MOV ESI,Offset Blocks
						MOV EDX,[ESI]
						.While EDX
							MOV EDX,[EDX].CHBLOCKDEF.lpszStart
							Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_ISLINE,[EDI].CHSELCHANGE.linenr,EDX
							.If EAX!=-1
								MOV EDX,[ESI]
								Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_COLLAPSE,[EDI].CHSELCHANGE.linenr,EDX
								.Break
							.EndIf
							ADD ESI,4
							MOV EDX,[ESI]
						.EndW
					.ElseIf EAX==2
						;Expand
						Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_EXPAND,[EDI].CHSELCHANGE.linenr,0
					.ElseIf EAX==8
						;Expand hidden lines
						;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_GETBMID,[EDI].CHSELCHANGE.linenr,0
						;PUSH EAX
						;PrintDec Eax
						Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_EXPAND,[EDI].CHSELCHANGE.linenr,0
						;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBOOKMARK,[EDI].CHSELCHANGE.linenr,9
						;POP EAX
						;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBMID,[EDI].CHSELCHANGE.linenr,EAX
					;.ElseIf EAX==9
					;	Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_GETBMID,[EDI].CHSELCHANGE.linenr,0
					;	MOV ESI,EAX
					;	PrintDec ESI
					;	;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBOOKMARK,[EDI].CHSELCHANGE.linenr,0
					;	;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_HIDELINES,[EDI].CHSELCHANGE.linenr,ESI
					;	;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBMID,[EDI].CHSELCHANGE.linenr,ESI
					.Else
						.If EAX!=7	;Do Not clear Buggy lines
							;Clear Bookmark
							Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBOOKMARK,[EDI].CHSELCHANGE.linenr,0
						.EndIf
					.EndIf
				.Else
					;dwTypeOfFile==51 should not be here
					.If [EDI].CHSELCHANGE.fchanged && ([EBX].CHILDWINDOWDATA.dwTypeOfFile==1 || [EBX].CHILDWINDOWDATA.dwTypeOfFile==2 || [EBX].CHILDWINDOWDATA.dwTypeOfFile== 101 || [EBX].CHILDWINDOWDATA.dwTypeOfFile==102 || [EBX].CHILDWINDOWDATA.dwTypeOfFile==51);![EDI].CHSELCHANGE.nWordGroup	;meaning *.asm or *.inc files
						;PrintDec nLastLine
						Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETCOMMENTBLOCKS,ADDR szCmntStart,ADDR szCmntEnd
						MOV fBlocksUpdate,FALSE
						OnceMore:
						;-------
						MOV ESI,Offset Blocks
						MOV ECX,[ESI]
						.While ECX
							MOV EDX,[ECX].CHBLOCKDEF.flag
							AND EDX,BD_DIVIDERLINE
							PUSH EDX
							MOV ECX,[ECX].CHBLOCKDEF.lpszStart
							Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_ISLINE,[EBX].CHILDWINDOWDATA.nLastLine,ECX
							POP EDX
							.Break .If EAX!=-1
							ADD ESI,4
							MOV ECX,[ESI]
						.EndW
						.If EAX==-1
							Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_GETBOOKMARK,[EBX].CHILDWINDOWDATA.nLastLine,0
							.If EAX==1 || EAX==2
								.If EAX==2
									Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_EXPAND,[EBX].CHILDWINDOWDATA.nLastLine,0
								.EndIf
								Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBOOKMARK,[EBX].CHILDWINDOWDATA.nLastLine,0
								Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETDIVIDERLINE,[EBX].CHILDWINDOWDATA.nLastLine,FALSE
								MOV fBlocksUpdate,TRUE
							.EndIf
						.Else
							XOR EAX,EAX
							MOV ECX,[ESI]
							TEST [ECX].CHBLOCKDEF.flag,BD_NONESTING
							.If !ZERO?
								PUSH EDX
								Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_ISINBLOCK,[EBX].CHILDWINDOWDATA.nLastLine,ECX
								POP EDX
							.EndIf
							
							.If !EAX
								PUSH EDX
								MOV EDX,[EBX].CHILDWINDOWDATA.nLastLine
								INC EDX
								Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_ISLINEHIDDEN,EDX,0
								.If EAX
									Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBOOKMARK,[EBX].CHILDWINDOWDATA.nLastLine,2
								.Else
									Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBOOKMARK,[EBX].CHILDWINDOWDATA.nLastLine,1
								.EndIf
								MOV fBlocksUpdate,TRUE
								POP EDX
								Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETDIVIDERLINE,[EBX].CHILDWINDOWDATA.nLastLine,EDX
							.EndIf
							
						.EndIf
						
						MOV EAX,[EDI].CHSELCHANGE.linenr
						.If EAX>[EBX].CHILDWINDOWDATA.nLastLine
							INC [EBX].CHILDWINDOWDATA.nLastLine
							JMP OnceMore
						.ElseIf EAX < [EBX].CHILDWINDOWDATA.nLastLine
							DEC [EBX].CHILDWINDOWDATA.nLastLine
							JMP OnceMore
						.EndIf
						
						.If fBlocksUpdate
							CALL GetProcedures
						.Else
							.If [EBX].CHILDWINDOWDATA.bSelection;it was a selection (see NewEditorProc)
								CALL GetProcedures
							.EndIf
						.EndIf
						
						;MOV EAX,[EDI].CHSELCHANGE.linenr
						;.If EAX
						;	DEC EAX
						;.EndIf
						;MOV [EBX].CHILDWINDOWDATA.nLastLine,EAX
						
					.EndIf
				.EndIf
				MOV EAX,[EDI].CHSELCHANGE.linenr
				.If EAX
					DEC EAX
				.EndIf
				MOV [EBX].CHILDWINDOWDATA.nLastLine,EAX
				
				Invoke SelectInTheCombo,[EBX].CHILDWINDOWDATA.hEditor,[EDI].CHSELCHANGE.linenr,[EBX].CHILDWINDOWDATA.hCombo
			.EndIf
			
		.ElseIf EAX==WM_CONTEXTMENU
			Invoke GetWindowLong, hWnd, 0
			MOV	EBX,EAX
			MOV EAX,wParam
			.If EAX==[EBX].CHILDWINDOWDATA.hEditor
				Invoke GetKeyState,VK_CONTROL
				AND EAX,80h
				.If EAX	;i.e. CTRL is pressed
					MOV EBX,WinAsmHandles.PopUpMenus.hFormatMenu
				.Else
					MOV EBX,WinAsmHandles.PopUpMenus.hEditMenu
				.EndIf
				
				MOV EAX,lParam
				.If EAX==-1
					Invoke GetCaretPos,ADDR pt
					Invoke GetFocus
					MOV EDX,EAX
					Invoke ClientToScreen,EDX,ADDR pt
				.Else
					AND EAX,0FFFFh
					MOV pt.x,EAX
					MOV EAX,lParam
					SHR EAX,16
					MOV pt.y,EAX
				.EndIf
				
				Invoke TrackPopupMenu,EBX,TPM_LEFTALIGN OR TPM_RIGHTBUTTON,pt.x,pt.y,0,WinAsmHandles.hMain,0
				XOR EAX,EAX
				JMP Exit
			.EndIf
		.ElseIf EAX == WM_PAINT
			Invoke BeginPaint,hWnd,ADDR ps
			Invoke GetSysColor,COLOR_3DFACE
			Invoke CreateSolidBrush,EAX
			PUSH EAX
			MOV ps.rcPaint.bottom,22
			Invoke FillRect,ps.hdc,ADDR ps.rcPaint,EAX
			POP EAX
			Invoke DeleteObject,EAX
			Invoke EndPaint,hWnd,ADDR ps
			
		.ElseIf EAX==WM_CLOSE
			Invoke IsZoomed,hWnd
			.If EAX
				Invoke SendMessage,hClient,WM_MDIRESTORE,hWnd,NULL
			.EndIf
			
			Invoke DisableAll
			Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET,NULL		
			MOV ECX,hWnd
			.If ECX==hRCEditorWindow
				Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET,NULL
				Invoke SendMessage,hPropertiesList,LVM_DELETEALLITEMS,0,0
				Invoke DeMultiSelect				
				.If AutoToolAndOptions
					Invoke ShowWindow,hToolBox,SW_HIDE
					Invoke ShowWindow,hRCOptions,SW_HIDE
				.EndIf
				Invoke EnableAllButtonsOnToolBox,FALSE
				Invoke EnableAllButtonsOnRCOptions,FALSE
			.EndIf
			
			Invoke GetWindowLong,hWnd,0
			MOV EBX,EAX
			.If [EAX].CHILDWINDOWDATA.dwTypeOfFile <101
				Invoke SendMessage,hClient,WM_MDINEXT,0,FALSE ;i.e. Previous
				Invoke ShowWindow,hWnd,SW_HIDE
				XOR EAX,EAX
				JMP Exit
			.Else
				MOV EDI,50000
				.While EDI <ExternalFilesMenuID
					INC EDI
					Invoke GetMenuItemData,WinAsmHandles.PopUpMenus.hWindowMenu,EDI,FALSE
					;Now EAX contains mii.dwItemData which is effectively the Window Handle
					.If EAX == hWnd
						Invoke DeleteMenu,WinAsmHandles.PopUpMenus.hWindowMenu,EDI,MF_BYCOMMAND
						Invoke GetMenuItemCount,WinAsmHandles.PopUpMenus.hWindowMenu
						.If EAX==9	;Delete Separator
							Invoke DeleteMenu,WinAsmHandles.PopUpMenus.hWindowMenu,8,MF_BYPOSITION
						.EndIf
					.EndIf
				.EndW
				
				MOV ECX,hWnd
				.If ECX==hRCEditorWindow
					Invoke ClearRCEditor
				.EndIf
				Invoke AskToSaveFile,hWnd
				.If EAX
					Invoke SaveEdit,hWnd,ADDR [EBX].CHILDWINDOWDATA.szFileName
				.EndIf
				
			.EndIf
			
		.ElseIf EAX==WM_SYSCOMMAND
			.If wParam==SC_MAXIMIZE || wParam==0000F032h ;i.e.Double click on the title bar
				;I need this so that WinAsmHandles.hProjExplorer does not flicker due to LockWindowUpdate
;				Invoke SendMessage,WinAsmHandles.hProjExplorer,WM_SETREDRAW,FALSE,0
				;User, Please see notning until everything is finished.
				;Invoke LockWindowUpdate,hClient
				;Hiding the Window, no animation takes place
				;during maximizing (or is it much faster?).
				Invoke ShowWindow,hWnd,SW_HIDE
				Invoke SendMessage,hClient,WM_MDIMAXIMIZE,hWnd,NULL
				Invoke ShowWindow,hWnd,SW_SHOW
				;Invoke LockWindowUpdate,0
				
				;I needed this so that WinAsmHandles.hProjExplorer does not flicker due to LockWindowUpdate
;				Invoke SendMessage,WinAsmHandles.hProjExplorer,WM_SETREDRAW,TRUE,0
				
				;Message processed; Windows, Please Do Nothing.
				XOR EAX,EAX
				JMP Exit
			.EndIf
			
;		.ElseIf EAX==WM_NCLBUTTONDOWN
;			.If wParam==HTMAXBUTTON	;=9 i.e. Maximize
;				Invoke DoEvents
;			.EndIf
			
		.ElseIf EAX==WM_DESTROY
			Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
			.If !EAX
				Invoke DisableAll
			.EndIf
			
		.ElseIf EAX==WM_KILLFOCUS
			Invoke HideAllLists
			
		.ElseIf EAX==WM_WINDOWPOSCHANGING	;I need to check this BEFORE the window is shown
			.If !CanShowMDIChildren ;(i.e. project is still opening!!!)
				MOV EAX,lParam
				AND [EAX].WINDOWPOS.flags,-1 XOR SWP_SHOWWINDOW
			.EndIf
			
		.ElseIf EAX==WM_WINDOWPOSCHANGED	;I need to check this AFTER the window is shown or hidden
			MOV EAX,lParam
			MOV EBX,[EAX].WINDOWPOS.flags
			AND EBX,SWP_SHOWWINDOW or SWP_HIDEWINDOW
			Invoke GetWindowLong,hWnd,0
			MOV EDI,EAX
			.If EBX==SWP_HIDEWINDOW
				Invoke SendMessage,[EDI].CHILDWINDOWDATA.hEditor,CHM_READONLY,0,TRUE
			.ElseIf EBX==SWP_SHOWWINDOW
				Invoke SendMessage,[EDI].CHILDWINDOWDATA.hEditor,CHM_READONLY,0,FALSE
				MOV EAX,lParam
				MOV EBX,[EAX].WINDOWPOS.flags
				AND EBX,SWP_NOSIZE
				.If EBX==SWP_NOSIZE	;This test if for preventing a serious bug reported by shoorick
					MOV EAX,hWnd
					.If EAX!=hRCEditorWindow
						;Set menus and tools
						Invoke EnableAll
						Invoke EnableDisable,[EDI].CHILDWINDOWDATA.hEditor
					.Else
						Invoke EnableDisableRC
						.If hADialog
							Invoke EnableAllButtonsOnToolBox,TRUE
						.Else
							Invoke SendMessage,hToolBoxToolBar,TB_ENABLEBUTTON,IDM_TOOLBOX_DIALOG,TRUE
						.EndIf
						Invoke EnableAllButtonsOnRCOptions,TRUE
						.If AutoToolAndOptions && !fClosingProject
							Invoke ShowWindow,hToolBox,SW_SHOW
							Invoke ShowWindow,hRCOptions,SW_SHOW
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.EndIf
	.EndIf
	Invoke DefMDIChildProc,hWnd,uMsg,wParam,lParam
	
	Exit:
	RET
	
	GetProcedures:
	Invoke SendMessage,CHILDWINDOWDATA.hCombo[EBX],WM_SETREDRAW,FALSE,0
	Invoke UpdateProcCombo,CHILDWINDOWDATA.hEditor[EBX],CHILDWINDOWDATA.hCombo[EBX]
	MOV [EBX].CHILDWINDOWDATA.fTimer,1
	Invoke SendMessage,CHILDWINDOWDATA.hCombo[EBX],WM_SETREDRAW,TRUE,0
	RETN
ChildWndProc EndP

SetMainWindowPlacement Proc
Local WindowPlacement	:WINDOWPLACEMENT
	Invoke GetPrivateProfileStruct,Offset szGENERAL,Offset szPlacement,ADDR WindowPlacement,SizeOf WINDOWPLACEMENT,Offset IniFileName
	.If !EAX	;i.e. not found
		Invoke ShowWindow,WinAsmHandles.hMain,SW_MAXIMIZE
	.Else
		;Invoke ShowWindow,WinAsmHandles.hMain,SW_MAXIMIZE
		MOV WindowPlacement.iLength, SizeOf WINDOWPLACEMENT
		Invoke SetWindowPlacement,WinAsmHandles.hMain,ADDR WindowPlacement
	.EndIf

	RET
SetMainWindowPlacement EndP

RecentProjectsDialogProc Proc Uses EBX EDI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local hRecentProjectsList	:HWND
Local lvc					:LV_COLUMN
Local Rect					:RECT
Local lvi 					:LVITEM
Local Buffer[MAX_PATH+1]	:BYTE
Local szCounter[12]			:BYTE

	.If uMsg==WM_INITDIALOG
		
		Invoke GetDlgItem,hWnd,225	;Get List's handle
		MOV hRecentProjectsList,EAX
		
		MOV lvc.imask, LVCF_FMT	OR LVCF_TEXT 
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.pszText,Offset szProjects
		
		Invoke SendMessage, hRecentProjectsList, LVM_INSERTCOLUMN, 0, ADDR lvc
		
		Invoke SendMessage, hRecentProjectsList, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT OR LVS_EX_LABELTIP
		
		
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
		Invoke GetPrivateProfileString,	Offset szRECENT, ADDR Buffer, ADDR szNULL, ADDR Buffer, MAX_PATH, Offset IniFileName
		.If EAX!=0; && EBX<=6;20
			Invoke SendMessage,hRecentProjectsList,LVM_INSERTITEM,0,ADDR lvi
			JMP @B
		.EndIf
		
		.If EBX==1	;i.e. no recent projects
			Invoke GetDlgItem,hWnd,220	;Open button handle
			Invoke EnableWindow,EAX,FALSE
			Invoke GetDlgItem,hWnd,222	;Remove button handle
			Invoke EnableWindow,EAX,FALSE
			Invoke GetDlgItem,hWnd,223	;Remove All button handle
			Invoke EnableWindow,EAX,FALSE
			Invoke GetDlgItem,hWnd,224	;Apply button handle
			Invoke EnableWindow,EAX,FALSE
		.EndIf
		
		
		MOV lvi.iItem,0
		MOV lvi.iSubItem,0
		MOV lvi.imask,LVIF_STATE
		MOV lvi.stateMask,LVIS_SELECTED
		MOV lvi.state,LVIS_SELECTED 
		Invoke SendMessage,hRecentProjectsList,LVM_SETITEM,0,ADDR lvi
		
		Invoke GetWindowRect,hRecentProjectsList,ADDR Rect
		
		Invoke GetSystemMetrics,SM_CXBORDER
		MOV EBX,EAX
		SHL EBX,1	;Twice
		
		Invoke GetWindowLong,hRecentProjectsList,GWL_STYLE
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
		Invoke SendMessage, hRecentProjectsList, LVM_SETCOLUMNWIDTH, 0, ECX
		
	.ElseIf uMsg==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		
		.If EDX==BN_CLICKED
			.If EAX==220		;Open
				OpenRecent:
				Invoke GetDlgItem,hWnd,225	;Get List's handle
				MOV hRecentProjectsList,EAX
				
				Invoke EndDialog, hWnd, TRUE
				
				Invoke SendMessage,hRecentProjectsList,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_SELECTED
				.If EAX!=-1
					MOV EBX,EAX
					Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 2
					.If EAX	;EAX==TRUE if Yes or No was selected
						MOV lvi.iItem,EBX
						MOV lvi.imask,LVIF_TEXT
						MOV lvi.cchTextMax,256
						MOV lvi.iSubItem, 0
						LEA EDX,Buffer
						MOV lvi.pszText,EDX
						Invoke SendMessage,hRecentProjectsList,LVM_GETITEM,0,ADDR lvi
						;Invoke ClearProject	;It is in OpenWap
						
						Invoke OpenWAP,ADDR Buffer
						
						;Thanks Qvasimodo
						;WAM_OPENPROJECT
						;wParam=lpProjectFileName
						;lParam=reserved
						;Invoke SendMessage,WinAsmHandles.hMain,WAM_OPENPROJECT,ADDR Buffer,0
					.EndIf
				.EndIf
				
			.ElseIf EAX==222	;Remove
				Invoke GetDlgItem,hWnd,225	;Get List's handle
				MOV hRecentProjectsList,EAX
				Invoke SendMessage,hRecentProjectsList,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_SELECTED
				.If EAX!=-1
					PUSH EAX
					Invoke SendMessage,hRecentProjectsList,LVM_DELETEITEM,EAX,0
					Invoke SendMessage,hRecentProjectsList,LVM_GETITEMCOUNT,0,0
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
					Invoke SendMessage,hRecentProjectsList,LVM_SETITEM,0,ADDR lvi
				.EndIf
				Invoke SendMessage,hRecentProjectsList,LVM_GETITEMCOUNT,0,0
				.If !EAX
					Invoke GetDlgItem,hWnd,220	;Open button handle
					Invoke EnableWindow,EAX,FALSE
					Invoke GetDlgItem,hWnd,222	;Remove button handle
					Invoke EnableWindow,EAX,FALSE
					Invoke GetDlgItem,hWnd,223	;Remove All button handle
					Invoke EnableWindow,EAX,FALSE
				.EndIf
			.ElseIf EAX==223	;Remove All
				Invoke GetDlgItem,hWnd,225	;Get List's handle
				Invoke SendMessage,EAX,LVM_DELETEALLITEMS,0,0
				
				Invoke GetDlgItem,hWnd,220	;Open button handle
				Invoke EnableWindow,EAX,FALSE
				Invoke GetDlgItem,hWnd,222	;Remove button handle
				Invoke EnableWindow,EAX,FALSE
				Invoke GetDlgItem,hWnd,223	;Remove All button handle
				Invoke EnableWindow,EAX,FALSE
				
			.ElseIf EAX==224	;Apply
				Invoke GetDlgItem,hWnd,225	;Get List's handle
				MOV hRecentProjectsList,EAX
				Invoke WritePrivateProfileStruct,Offset szRECENT,NULL,NULL,NULL,Offset IniFileName
				
				MOV lvi.imask,LVIF_TEXT
				MOV lvi.stateMask,LVIS_SELECTED
				MOV lvi.cchTextMax,256
				MOV lvi.iSubItem, 0
				LEA EDX,Buffer
				MOV lvi.pszText,EDX
				
				Invoke SendMessage,hRecentProjectsList,LVM_GETITEMCOUNT,0,0
				.If EAX
					MOV EBX,EAX 
					XOR EDI,EDI
					.While EDI<EBX
						MOV lvi.iItem,EDI
						INC EDI
						Invoke SendMessage,hRecentProjectsList,LVM_GETITEM,0,ADDR lvi
						Invoke BinToDec,EDI,ADDR szCounter
						Invoke WritePrivateProfileString, Offset szRECENT, ADDR szCounter, ADDR Buffer, Offset IniFileName
					.EndW
				.EndIf
;				Invoke GetRecentProjects
				
				Invoke SendMessage,hRecentProjectsList,LVM_GETITEMCOUNT,0,0
				.If !EAX
					Invoke GetDlgItem,hWnd,224	;Apply button handle
					Invoke EnableWindow,EAX,FALSE
				.EndIf
			.ElseIf EAX==226	;New Project
				Invoke EndDialog,hWnd,FALSE	;Return Cancel
				Invoke SendMessage,WinAsmHandles.hMain,WM_COMMAND,IDM_NEWPROJECT,0
			.Else;If EAX==221	;Exit (for some reason if user presses Esc EAX=2???)
				Invoke EndDialog,hWnd,FALSE	;Return Cancel
			.EndIf
		.EndIf

	.ElseIf uMsg==WM_NOTIFY
		;PUSH EDI
		Invoke GetDlgItem,hWnd,225	;Get List's handle
		MOV EDX,lParam
		.If [EDX].NMHDR.hwndFrom==EAX
			.If [EDX].NM_TREEVIEW.hdr.code==NM_DBLCLK
				JMP OpenRecent
			.EndIf
		.EndIf
		
		;POP EDI
	.ElseIf uMsg==WM_CLOSE
		Invoke EndDialog,hWnd,FALSE	;Return Cancel
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
RecentProjectsDialogProc EndP

WinMain Proc hInst:HINSTANCE, hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:SDWORD
Local wc				:WNDCLASSEX
Local Message			:MSG
Local Buffer[MAX_PATH]	:BYTE
Local UILoadTrials		:DWORD

	;Register a class for the main window
	MOV wc.cbSize,SizeOf WNDCLASSEX
	MOV wc.lpszClassName, Offset szParentWindow
	M2M wc.hInstance,hInstance
	MOV wc.lpfnWndProc, Offset MainWndProc
	Invoke LoadCursor,NULL,IDC_ARROW
	MOV wc.hCursor,EAX
	Invoke LoadIcon, hInst, IDI_MAINICON
	MOV wc.hIcon,EAX			;Large icon
	MOV hMainIcon,EAX
	MOV wc.hIconSm,NULL			;Small icon
	MOV wc.lpszMenuName,NULL
	
	MOV wc.hbrBackground,NULL
	MOV wc.style,CS_BYTEALIGNCLIENT OR CS_BYTEALIGNWINDOW;CS_HREDRAW OR CS_VREDRAW OR 
	MOV wc.cbClsExtra,NULL
	MOV wc.cbWndExtra,NULL
	Invoke RegisterClassEx, ADDR wc

	;Register a class for our MDI Child windows
	MOV wc.lpfnWndProc, Offset ChildWndProc
	MOV wc.style,CS_BYTEALIGNCLIENT OR CS_BYTEALIGNWINDOW; OR CS_GLOBALCLASS	;CS_HREDRAW OR CS_VREDRAW OR CS_BYTEALIGNWINDOW
	MOV wc.lpszClassName,Offset szChildClass
	MOV wc.cbWndExtra, SizeOf HANDLE;Space for pointer
	;MOV wc.lpszMenuName, NULL
	;MOV wc.hbrBackground,NULL		;So that WM_ERASEBKGND is not Processed and we have no flicker ;COLOR_WINDOW
	MOV wc.hIcon,NULL
	MOV wc.hIconSm,NULL
	Invoke RegisterClassEx, ADDR wc


	;Register a class for the Docking Windows
	MOV wc.lpfnWndProc, Offset DockWndProc
	MOV wc.style,CS_DBLCLKS or CS_BYTEALIGNCLIENT OR CS_BYTEALIGNWINDOW OR CS_HREDRAW OR CS_VREDRAW
	MOV wc.lpszClassName,Offset szDockClass
	;MOV wc.cbWndExtra, 4
	;MOV wc.lpszMenuName, NULL
	MOV wc.hbrBackground,COLOR_BTNFACE+1
	Invoke RegisterClassEx, ADDR wc

	
	;Register a class for my custom Tooltip	
	MOV wc.lpfnWndProc, Offset ToolTipProc
	MOV wc.lpszClassName,Offset szWAToolTipClass
	MOV wc.hbrBackground,NULL; COLOR_WINDOW
	Invoke RegisterClassEx, ADDR wc
	
	
	Invoke GetProcessHeap
	MOV hMainHeap,EAX

	Invoke GetModuleFileName,0,Offset szAppFileName,SizeOf szAppFileName
	Invoke GetFilePath,Offset szAppFileName, Offset szAppFilePath
	
	
	;Create the IniFileName
	Invoke lstrcpy, Offset IniFileName, Offset szAppFilePath
	Invoke lstrcat, Offset IniFileName, Offset szWinAsmINI
	
	MOV UILoadTrials,0
	
	PUSH EBX
	LEA EBX,Buffer
	Invoke lstrcpy,EBX,Offset szAppFilePath
	Invoke lstrcat,EBX,Offset szUI
	Invoke lstrcat,EBX,Offset szSlash
	Invoke GetPrivateProfileString,Offset szGENERAL,Offset szUI,Offset szEnglish,Offset szInterfacePack,MAX_PATH,Offset IniFileName
	Invoke lstrcat,EBX,Offset szInterfacePack
	POP EBX
	
	LoadUIDLL:
	Invoke LoadLibrary,ADDR Buffer
	INC UILoadTrials
	.If EAX
		
		MOV hUILib,EAX
		.If UILoadTrials==2
			Invoke WritePrivateProfileString,Offset szGENERAL,Offset szUI,Offset szEnglish,Offset IniFileName
			Invoke lstrcpy,Offset szInterfacePack,Offset szEnglish
		.EndIf
		
		Invoke GetPrivateProfileInt,Offset szMISCELLANEOUS, Offset szObjectsFont, 0,Offset IniFileName
		MOV ObjectsFont,EAX
		
		Invoke LoadUI
		
		Invoke LoadLibrary,Offset szCodeHidll
		.If EAX
			PUSH ESI
			PUSH EDI
			PUSH EBX
			
			MOV hCodeHiDLL,EAX
			
			;Needed for resource scripts
			Invoke LoadLibrary,ADDR szRichEdit
			MOV hRichEd,EAX
			
			Invoke OleInitialize,NULL
			
			Invoke CreateWindowEx, NULL, ADDR szParentWindow ,ADDR szAppName,WS_OVERLAPPEDWINDOW OR WS_DISABLED, CW_USEDEFAULT, CW_USEDEFAULT,CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInst,NULL
			Invoke RefreshTahomaFont
			
			LEA EAX,hAccelerator
			MOV WinAsmHandles.phAcceleratorTable,EAX
			
			;---Time consuming----
;			Invoke GetKeyWords
;			Invoke GetAPIFunctions	
;			Invoke GetAPIStructures
;			Invoke GetAPIConstants
			;---------------------
			
			;PrintHex pAddInsChildWindowProcedures
			;-------------------------------------------------------------------
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,1024
			MOV pAddInsFrameProcedures,EAX
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,1024
			MOV pAddInsProjectExplorerProcedures,EAX
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,1024
			MOV pAddInsOutWindowProcedures,EAX
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,1024
			MOV pAddInsChildWindowProcedures,EAX
			;PrintHex pAddInsChildWindowProcedures
			;PrintHex EAX							;83DB50
			;PrintText "---------------------"
			
			PUSH pAddInsFrameProcedures
			PUSH pAddInsProjectExplorerProcedures
			PUSH pAddInsOutWindowProcedures
			PUSH pAddInsChildWindowProcedures
			
			MOV Features.Version,WINASMVERSION
			
			LEA EAX,pAddInsFrameProcedures
			MOV Features.ppAddInsFrameProcedures,EAX
			
			LEA EAX,pAddInsChildWindowProcedures
			;PrintHex EAX							;4355CC
			;PrintText "---------------------"
			
			MOV Features.ppAddInsChildWindowProcedures,EAX
			
			LEA EAX,pAddInsProjectExplorerProcedures
			MOV Features.ppAddInsProjectExplorerProcedures,EAX
			
			LEA EAX,pAddInsOutWindowProcedures
			MOV Features.ppAddInsOutWindowProcedures,EAX
			
			LEA EAX,hRCEditorWindow
			MOV Features.phRCEditorWindow,EAX
			
			LEA EAX,lpDefinesMem
			MOV Features.plpDefinesMem,EAX
			
			Invoke GetKeyState, VK_F8
			AND EAX,80h
			.If EAX==80h	;i.e. if shift is presses don't load ANY Add-Ins on startup-->Thanks shoorick
			.Else	
				Invoke EnumDllsInFolder,Offset ShallAddInLoadOnStartUp,Offset szInAddInsAllDLLs
			.EndIf
			
			POP pAddInsChildWindowProcedures
			POP pAddInsOutWindowProcedures
			
			POP pAddInsProjectExplorerProcedures
			POP pAddInsFrameProcedures
			
			;-------------------------------------------------------------------
			
			Invoke SetMainWindowPlacement
			Invoke UpdateWindow,WinAsmHandles.hMain
			Invoke SetFocus,WinAsmHandles.hMain
			;PrintText "---------------------"
			;MOV EAX,Features.ppAddInsChildWindowProcedures
			;PrintHex EAX				;4355CC
			;
			;MOV EDX,[EAX]
			;PrintHex edx				;83DB50
			;
			;MOV EDX,[EDX]
			;PrintHex EDX				;c21059<-------First ChildWindowProcedure Address
			;
			;MOV ECX,0
			;MOV [eax],ecx				;i.e. put a zero in 4355CC
			;
			;PrintHex pAddInsChildWindowProcedures	;0 i.e. the above two lines are equivalet to MOV pAddInsChildWindowProcedures,0 
			;PrintText "---------------------"
			
			.If ShowSplashOnStartUp==TRUE
				Invoke CreateDialogParam,hInstance,IDD_SPLASHABOUT,WinAsmHandles.hMain,ADDR AboutDialogProc,TRUE
				MOV ESI,EAX
				Invoke GetTickCount
				ADD EAX,2500
				MOV EBX,EAX
			.EndIf
			
			Invoke ProcessCommand, CmdLine, ADDR Buffer
			.If EAX==TRUE ;i.e Matching pairs found in CmdLine
				Invoke GetFileExtension,ADDR Buffer
				MOV EDI, EAX
				Invoke lstrcmpi, EDI, Offset szExtwap
				.If EAX==0
					Invoke OpenWAP, ADDR Buffer
				.Else
					Invoke lstrcmpi,EDI,Offset szExtExe ;probably meaning that user just launched WinAsm Studio
					.If EAX
						Invoke AddOpenExistingFile,ADDR Buffer,FALSE
					.Else
						CALL HandleStartUp
					.EndIf
				.EndIf
			.Else
				CALL HandleStartUp
			.EndIf
			
			Invoke UpdateWindow,WinAsmHandles.hMain
			;-------------------------------------------------------------------
			.If ShowSplashOnStartUp==TRUE
				@@:
				Invoke GetTickCount
				.If EBX>EAX
					JMP @B	
				.EndIf
				Invoke DestroyWindow,ESI	;Since dialog is modeless
			.EndIf
			
			Invoke EnableWindow,WinAsmHandles.hMain,TRUE
			Invoke SetForegroundWindow,WinAsmHandles.hMain
			
			POP EBX
			POP EDI
			POP ESI
			
			.While TRUE
				Invoke GetMessage, ADDR Message,0,0,0
				.Break .If (!EAX)
				Invoke IsDialogMessage,hFind,ADDR Message
				.If !EAX
					Invoke TranslateMDISysAccel,hClient,ADDR Message	;This checks for MDI messages like the window menu etc.
					.If !EAX
						Invoke TranslateAccelerator,WinAsmHandles.hMain,hAccelerator,ADDR Message		;This translates accelerator messages for us
						.If !EAX
							Invoke TranslateMessage,ADDR Message
							Invoke DispatchMessage,ADDR Message
						.EndIf
					.EndIf
				.EndIf
			.EndW
			
			;Invoke DestroyAcceleratorTable,hAccelerator
			
			Invoke FreeLibrary,hRichEd
			
			Invoke FreeLibrary,hCodeHiDLL
			
			Invoke FreeLibrary,hUILib
			
			Invoke OleUninitialize
			
			MOV EAX, Message.wParam
		.Else
			Invoke MessageBox,NULL,Offset szCodeHiNotFound, Offset szAppName,MB_OK
		.EndIf
		
	.Else
		.If UILoadTrials==1
			Invoke MessageBox,NULL,CTEXT("User Interface DLL not found! Will try to load 'English (Official)'"), Offset szAppName,MB_OK
			PUSH EBX
			LEA EBX,Buffer
			Invoke lstrcpy,EBX,Offset szAppFilePath
			Invoke lstrcat,EBX,Offset szUI
			Invoke lstrcat,EBX,Offset szSlash
			Invoke lstrcat,EBX,Offset szEnglish
			POP EBX
			JMP LoadUIDLL
		.Else
			Invoke MessageBox,NULL,CTEXT("'English (Official)' User Interface DLL not found! WinAsm Studio will terminate."), Offset szAppName,MB_OK
		.EndIf
	.EndIf

	RET

	;-----------------------------------------------------------------------
	HandleStartUp:
	.If OnStartUp==0		;Show Open Dialog
		Invoke SendMessage,WinAsmHandles.hMain,WM_COMMAND,IDM_OPENPROJECT,0
	.ElseIf OnStartUp==1	;Open Last Project
		Invoke GetPrivateProfileString, Offset szRECENT, Offset szOne, ADDR szNULL, ADDR Buffer, 288, Offset IniFileName
		.If Buffer[0]!=0
			Invoke OpenWAP,ADDR Buffer
		.EndIf
	.ElseIf OnStartUp==2	;Show Recent Projects Dialog
		Invoke SendMessage,WinAsmHandles.hMain,WM_COMMAND,IDM_RECENTPROJECTSMANAGER,0
	.EndIf
	RETN

WinMain EndP

MainWndProc_Create Proc Uses EBX EDI ESI hWnd:HWND
Local rbi			:REBARBANDINFO
Local cc			:CLIENTCREATESTRUCT
Local icce			:INITCOMMONCONTROLSEX
Local FontName[32]	:BYTE
Local sbParts[6]	:DWORD

Local Buffer[MAX_PATH+1]	:DWORD

	Invoke InitCommonControls
	
	;This inits the newer common controls like rebars and picture comboboxes etc
	;prepare common control structure
	MOV icce.dwSize,SizeOf INITCOMMONCONTROLSEX
	MOV icce.dwICC,ICC_DATE_CLASSES or ICC_USEREX_CLASSES or ICC_INTERNET_CLASSES or ICC_ANIMATE_CLASS or ICC_HOTKEY_CLASS or ICC_PAGESCROLLER_CLASS or ICC_COOL_CLASSES
	Invoke InitCommonControlsEx,ADDR icce

	
	MOV EAX,hWnd
	MOV WinAsmHandles.hMain,EAX



	; Make sure the toolbar button images are transparent so load them separately
	Invoke ImageList_LoadImage,hInstance,IDB_DISABLEDBITMAP,16,60,0FF00FFh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	MOV hImlMonoChrome,EAX
	LEA ECX,hImlMonoChrome
	MOV WinAsmHandles.phImlMonoChrome,ECX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlMonoChrome,CLR_NONE

	; Make sure the toolbar button images are transparent so load them separately
	Invoke ImageList_LoadImage,hInstance,IDB_TOOLBARBITMAP,16,60,0FE02FEh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	; Save the image handle that is returned to identify it when drawing
	MOV hImlNormal,EAX
	LEA ECX,hImlNormal
	MOV WinAsmHandles.phImlNormal,ECX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlNormal,CLR_NONE

    Invoke CreateOwnerDrawnMenus
	Invoke GetSettingsFromIni
	
	; Get Line Number font style
	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szLineNrFontStyle, 400, Offset IniFileName
	MOV ECX,EAX
	SHR ECX,10
	AND EAX,03FFh
	MOV lfntlnr.lfWeight,EAX
	MOV EAX,ECX
	SHR ECX,1
	AND EAX,1
	MOV lfntlnr.lfItalic,AL
	MOV EAX,ECX
	SHR ECX,1
	AND EAX,1
	MOV lfntlnr.lfStrikeOut,AL
	AND ECX,1
	MOV lfntlnr.lfUnderline,CL	

   	;Create Line Number Font
	Invoke GetPrivateProfileString, Offset szEDITOR, Offset szLineNrFontName,Offset szCourierNew,ADDR FontName ,32,Offset IniFileName
	Invoke lstrcpy, Offset lfntlnr.lfFaceName, ADDR FontName
	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szLineNrFontSize, 12, Offset IniFileName
	NEG EAX
	MOV lfntlnr.lfHeight,EAX

	Invoke CreateFontIndirect,Offset lfntlnr
	MOV hLnrFont,EAX
	
	.If AutoLineNrWidth
		Invoke CalculateLineNrWidth
		MOV	LineNrWidth,EAX
	.EndIf
		
	; Get Editor font style
	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEditorFontStyle, 400, Offset IniFileName
	MOV ECX,EAX
	SHR ECX,10
	AND EAX,03FFh
	MOV lfnt.lfWeight,EAX
	MOV EAX,ECX
	SHR ECX,1
	AND EAX,1
	MOV lfnt.lfItalic,AL
	PUSH EAX
	MOV EAX,ECX
	SHR ECX,1
	AND EAX,1
	MOV lfnt.lfStrikeOut,AL
	AND ECX,1
	MOV lfnt.lfUnderline,CL	
	
	;Create Italics Font
	Invoke GetPrivateProfileString, Offset szEDITOR, Offset szEditorFontName,Offset szCourierNew, ADDR FontName , 32, Offset IniFileName
	Invoke lstrcpy, Offset lfnt.lfFaceName, ADDR FontName
	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEditorFontSize, 12, Offset IniFileName
	NEG EAX
	MOV lfnt.lfHeight,EAX;-13
	MOV lfnt.lfItalic,TRUE
	;Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEditorFontCharset, 161, Offset IniFileName
	;MOV lfnt.lfCharSet,AL
	Invoke CreateFontIndirect,Offset lfnt
	MOV hIFont,EAX
	
	; Restore Italic setting for Editor font
	POP EAX
	MOV lfnt.lfItalic,AL
	
	;Create font
	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEditorFontSize, 12, Offset IniFileName
	NEG EAX
	MOV lfnt.lfHeight,EAX
	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEditorFontCharset, 161, Offset IniFileName
	MOV lfnt.lfCharSet,AL
	Invoke CreateFontIndirect,Offset lfnt
	MOV hFont,EAX
	
	Invoke GetPrivateProfileString, Offset szFILESANDPATHS, Offset szKeyFile, ADDR szNULL, Offset KeyWordsFileName, MAX_PATH, Offset IniFileName
	Invoke AddToolsSubMenus

	;---------------------------------------------------------------------
	;Create Image list for API Lists
	;Invoke ImageList_LoadImage, hInstance, IDB_LISTPROCEDURESLIST, 16, 0, CLR_DEFAULT, IMAGE_BITMAP, LR_LOADTRANSPARENT
	Invoke ImageList_LoadImage,hInstance,IDB_LISTPROCEDURESLIST,16,0,0FFFFFFh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	MOV hListAPIImageList, EAX

	;Get API Functions List
	Invoke CreateEmptyList
	MOV hListProcedures, EAX

	;Get API Structures	List
	Invoke CreateEmptyList
	MOV hListStructures, EAX

    ;Get API Constants List
    Invoke CreateEmptyList
    MOV hListConstants,EAX
    
	Invoke CreateEmptyList
	MOV hListStructureMembers,EAX
    
	Invoke CreateEmptyList
	MOV hListVariables,EAX
	
	Invoke CreateEmptyList
	MOV hListIncludes,EAX
	
	;MOV cc.idFirstChild,101
	;M2M cc.hWindowMenu,hWindowMenu
	Invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR szClientClass, NULL,WS_VISIBLE or WS_CHILD OR WS_CLIPCHILDREN OR WS_VSCROLL, 0, 0, 0, 0, hWnd, NULL, hInstance, ADDR cc
	MOV hClient, EAX
	MOV WinAsmHandles.hClient,EAX

	;Make a status bar
	Invoke CreateStatusWindow,WS_CHILD OR WS_VISIBLE, NULL, hWnd, 0
	MOV hStatus, EAX
	MOV WinAsmHandles.hStatus,EAX

	MOV [sbParts +  0],35
	MOV [sbParts +  4],70
	MOV [sbParts +  8],105

	MOV [sbParts +  12],320
	MOV [sbParts +  16],-1
	Invoke SendMessage,hStatus,SB_SETPARTS,5,ADDR sbParts

	Invoke SetTimer,hWnd,200,200,NULL
	;-------------------------------------------------------------------------
	;Make the "Main" Toolbar
	Invoke CreateWindowEx,NULL,Offset szToolbarClass,NULL,WS_CHILD OR WS_VISIBLE  OR WS_CLIPCHILDREN OR TBSTYLE_TOOLTIPS OR CCS_NORESIZE OR CCS_NODIVIDER OR TBSTYLE_FLAT,0,0,0,0,WinAsmHandles.hMain,NULL,hInstance,NULL
	MOV hMainTB, EAX
	MOV WinAsmHandles.hMainTB,EAX
	
	Invoke SendMessage,hMainTB,TB_GETEXTENDEDSTYLE,0,0
	OR EAX,TBSTYLE_EX_DRAWDDARROWS   
	Invoke SendMessage,hMainTB,TB_SETEXTENDEDSTYLE,0,EAX
	
	Invoke SendMessage,hMainTB,TB_BUTTONSTRUCTSIZE,SizeOf TBBUTTON,0

	Invoke SendMessage,hMainTB,TB_SETIMAGELIST,0,hImlNormal
	Invoke SendMessage,hMainTB,TB_SETDISABLEDIMAGELIST,0,hImlMonoChrome
	Invoke SendMessage,hMainTB,TB_ADDBUTTONS,19,ADDR tbMain


	;TB_GETEXTENDEDSTYLE
	;Invoke SendMessage,hMainTB,WM_USER + 85 ,0,0  
	;OR EAX,00000001H;TBSTYLE_EX_DRAWDDARROWS
	;TB_SETEXTENDEDSTYLE
	;Invoke SendMessage,hMainTB,WM_USER + 84 ,0,EAX
	;-------------------------------------------------------------------------	
	;Make the "Edit" toolbar
	Invoke CreateWindowEx,NULL,Offset szToolbarClass,NULL,WS_CHILD OR WS_VISIBLE  OR WS_CLIPCHILDREN OR TBSTYLE_TOOLTIPS OR CCS_NORESIZE OR CCS_NODIVIDER OR TBSTYLE_FLAT,0,0,0,0,WinAsmHandles.hMain,NULL,hInstance,NULL
	MOV hEditTB, EAX
	MOV WinAsmHandles.hEditTB,EAX
	
	Invoke SendMessage,hEditTB,TB_BUTTONSTRUCTSIZE,SizeOf TBBUTTON,0
	Invoke SendMessage,hEditTB,TB_ADDBUTTONS,10,ADDR tbEdit

	Invoke SendMessage,hEditTB,TB_SETIMAGELIST,0,hImlNormal
	Invoke SendMessage,hEditTB,TB_SETDISABLEDIMAGELIST,0,hImlMonoChrome
	;-------------------------------------------------------------------------
	;Make the "Make" toolbar
	Invoke CreateWindowEx,NULL,Offset szToolbarClass,NULL,WS_CHILD OR WS_VISIBLE  OR WS_CLIPCHILDREN OR TBSTYLE_TOOLTIPS OR CCS_NORESIZE OR CCS_NODIVIDER OR TBSTYLE_FLAT,0,0,0,0,WinAsmHandles.hMain,NULL,hInstance,NULL
	MOV hMakeTB, EAX
	MOV WinAsmHandles.hMakeTB,EAX
	
	Invoke SendMessage,hMakeTB,TB_BUTTONSTRUCTSIZE,SizeOf TBBUTTON,0
	Invoke SendMessage,hMakeTB,TB_ADDBUTTONS,6,ADDR tbMake

	Invoke SendMessage,hMakeTB,TB_SETIMAGELIST,0,hImlNormal
	Invoke SendMessage,hMakeTB,TB_SETDISABLEDIMAGELIST,0,hImlMonoChrome
	;-------------------------------------------------------------------------
	
	;Make a Rebar
	; OR CCS_NOPARENTALIGN 
	Invoke CreateWindowEx, NULL, ADDR szRebar, NULL, WS_VISIBLE OR WS_BORDER OR WS_CHILD OR WS_CLIPCHILDREN OR WS_CLIPSIBLINGS OR CCS_NODIVIDER OR RBS_VARHEIGHT OR RBS_BANDBORDERS OR CCS_ADJUSTABLE or CCS_NOPARENTALIGN, 0, 0, 0, 0, hWnd, NULL, hInstance, NULL
	MOV WinAsmHandles.hRebar, EAX

	;Add a band to the rebar and put the toolbar in it
	MOV rbi.cbSize, SizeOf REBARBANDINFO
	MOV rbi.fMask, RBBIM_STYLE or RBBIM_COLORS or RBBIM_SIZE or RBBIM_CHILD or RBBIM_CHILDSIZE
	MOV rbi.fStyle, RBBS_CHILDEDGE

	;Use the normal windows colors...
	Invoke GetSysColor,COLOR_BTNTEXT
	MOV rbi.clrFore,EAX
	Invoke GetSysColor,COLOR_BTNFACE
	MOV rbi.clrBack, EAX
	
	MOV rbi.lx, 388			;Band length
	MOV rbi.cxMinChild, 375	;Second band can slide over almost all of this band
	MOV rbi.cyMinChild, 22

	M2M rbi.hwndChild, hMainTB
	
	;Add a band, the index starts at 0
	Invoke SendMessage, WinAsmHandles.hRebar, RB_INSERTBAND, 0, ADDR rbi
	
	;Add another band
	;MOV rbi.fStyle, RBBS_CHILDEDGE or RBBS_BREAK
	MOV rbi.lx, 213;5
  MOV rbi.cyMinChild, 22
  MOV rbi.cxMinChild, 200
	M2M rbi.hwndChild, hEditTB
	;All other members of REBARBANDINFO structure will remain unchanged
	Invoke SendMessage, WinAsmHandles.hRebar, RB_INSERTBAND, 1, ADDR rbi

	;Add another band
	;MOV rbi.fStyle, RBBS_CHILDEDGE
	MOV rbi.lx, 140
	MOV rbi.cyMinChild, 22
  MOV rbi.cxMinChild, 120
	M2M rbi.hwndChild, hMakeTB
	;All other members of REBARBANDINFO structure will remain unchanged
	Invoke SendMessage, WinAsmHandles.hRebar, RB_INSERTBAND, 2, ADDR rbi
	
	Invoke GetPrivateProfileInt, Offset szSETTINGSONEXIT, Offset szActiveDock, 1, Offset IniFileName
	.If EAX!=1
		CALL CreateProjectExplorer
		CALL CreateOutParent
		M2M hActiveDock,WinAsmHandles.hOutParent
		CALL CreateToolBox
		CALL CreateRCOptions
	.Else
		CALL CreateOutParent
		CALL CreateProjectExplorer
		M2M hActiveDock,WinAsmHandles.hProjExplorer
		CALL CreateToolBox
		CALL CreateRCOptions
	.EndIf

	;------------------------------------------------------------------------
	Invoke CreateWindowEx,NULL,Offset szWAToolTipClass,NULL,WS_BORDER OR WS_POPUP ,0, 0, 10, 10,WinAsmHandles.hMain,NULL,hInstance,0
	MOV hToolTip,EAX
	Invoke SendMessage,hToolTip,WM_SETFONT,hFont,FALSE
	;------------------------------------------------------------------------
	Invoke CreatePopupMenu
	MOV hTrayPopupMenu,EAX

	Invoke AppendMenu,hTrayPopupMenu,MF_STRING,IDM_RESTORE,Offset szRestore
	Invoke AppendMenu,hTrayPopupMenu,MF_SEPARATOR,0,0
	Invoke AppendMenu,hTrayPopupMenu,MF_STRING,IDM_EXIT,Offset szExit

	Invoke LoadCursor,hInstance,120
	MOV hHSplit,EAX
	RET

	;--------------------------------------------------------------------
	CreateProjectExplorer:
	;---------------------
	MOV PEDockData.lpCaption, Offset szExplorer
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szDockedTo,RIGHTDOCK, Offset IniFileName
	MOV PEDockData.fDockedTo,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szNoDockLeft,500, Offset IniFileName
	MOV PEDockData.NoDock.dLeft,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szNoDockTop,40, Offset IniFileName
	MOV PEDockData.NoDock.dTop,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szNoDockWidth,200, Offset IniFileName
	MOV PEDockData.NoDock.dWidth,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szNoDockHeight,350, Offset IniFileName
	MOV PEDockData.NoDock.dHeight,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szDockTopHeight,200, Offset IniFileName
	MOV PEDockData.DockTopHeight,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szDockBottomHeight,150, Offset IniFileName
	MOV PEDockData.DockBottomHeight,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szDockLeftWidth,180, Offset IniFileName
	MOV PEDockData.DockLeftWidth,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szDockRightWidth,180, Offset IniFileName
	MOV PEDockData.DockRightWidth,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szTitleStyle,0, Offset IniFileName
	OR EAX,WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_CHILD
	MOV EBX,EAX
	Invoke GetPrivateProfileInt, Offset szPROJECTEXPLORER, Offset szVisible,1, Offset IniFileName
	.If EAX
		OR EBX,WS_VISIBLE
		Invoke CheckMenuItem,hMenu,IDM_VIEW_PROJECTEXPLORER,MF_CHECKED
		Invoke SendMessage,hMainTB,TB_CHECKBUTTON,IDM_VIEW_PROJECTEXPLORER,TRUE
	.EndIf
	Invoke CreateDockingWindow,EBX,ADDR PEDockData
	MOV WinAsmHandles.hProjExplorer,EAX
	;MOV hProjectExplorer,EAX
	Invoke ProjectExplorerInit,EAX
	Invoke SetWindowLong,WinAsmHandles.hProjExplorer,GWL_WNDPROC,ADDR ProjectExplorerProc

	RETN
	;--------------------------------------------------------------------
	CreateOutParent:
	;---------------
	MOV POutDockData.lpCaption, Offset szOutput
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szDockedTo,4, Offset IniFileName
	MOV POutDockData.fDockedTo,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szNoDockLeft,40, Offset IniFileName
	MOV POutDockData.NoDock.dLeft,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szNoDockTop,400, Offset IniFileName
	MOV POutDockData.NoDock.dTop,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szNoDockWidth,600, Offset IniFileName
	MOV POutDockData.NoDock.dWidth,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szNoDockHeight,120, Offset IniFileName
	MOV POutDockData.NoDock.dHeight,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szDockTopHeight,120, Offset IniFileName
	MOV POutDockData.DockTopHeight,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szDockBottomHeight,120, Offset IniFileName
	MOV POutDockData.DockBottomHeight,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szDockLeftWidth,180, Offset IniFileName
	MOV POutDockData.DockLeftWidth,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szDockRightWidth,180, Offset IniFileName
	MOV POutDockData.DockRightWidth,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szTitleStyle,0, Offset IniFileName
	OR EAX,WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_CHILD
	MOV EBX,EAX
	Invoke GetPrivateProfileInt, Offset szOUTPARENT, Offset szVisible,0, Offset IniFileName
	.If EAX
		OR EBX,WS_VISIBLE
		Invoke CheckMenuItem,hMenu,IDM_VIEW_OUTPUT,MF_CHECKED
	.EndIf
	Invoke CreateDockingWindow,EBX,ADDR POutDockData
	;MOV hParentOut,EAX
	MOV WinAsmHandles.hOutParent,EAX
	Invoke OutParentInit,EAX
	Invoke SetWindowLong,WinAsmHandles.hOutParent,GWL_WNDPROC,ADDR OutParentProc
	Invoke SetOutEditWindowFormat
	RETN
	
	;--------------------------------------------------------------------
	CreateToolBox:
	;Invoke LoadLibrary,ADDR szRichEdit
	;MOV hRichEd,EAX
	Invoke CreateDialogClass
	
	MOV TBDockData.lpCaption, Offset szToolBox
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szDockedTo,1, Offset IniFileName
	MOV TBDockData.fDockedTo,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szNoDockLeft,40, Offset IniFileName
	MOV TBDockData.NoDock.dLeft,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szNoDockTop,40, Offset IniFileName
	MOV TBDockData.NoDock.dTop,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szNoDockWidth,72, Offset IniFileName
	MOV TBDockData.NoDock.dWidth,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szNoDockHeight,370, Offset IniFileName
	MOV TBDockData.NoDock.dHeight,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szDockTopHeight,50, Offset IniFileName
	MOV TBDockData.DockTopHeight,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szDockBottomHeight,50, Offset IniFileName
	MOV TBDockData.DockBottomHeight,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szDockLeftWidth,66, Offset IniFileName
	MOV TBDockData.DockLeftWidth,EAX
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szDockRightWidth,66, Offset IniFileName
	MOV TBDockData.DockRightWidth,EAX
	
 
	Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szTitleStyle,0, Offset IniFileName
	OR EAX,WS_CLIPCHILDREN OR WS_CLIPSIBLINGS OR WS_CHILD
	MOV EBX,EAX
	
	.If !AutoToolAndOptions	;i.e. make it invisible because it will show automatically if MDI child with rc file is activated
		Invoke GetPrivateProfileInt, Offset szTOOLBOX, Offset szVisible,0, Offset IniFileName
		.If EAX
			OR EBX,WS_VISIBLE
			Invoke CheckMenuItem,hMenu,IDM_VIEW_TOOLBOX,MF_CHECKED
		.EndIf
	.EndIf
	
	Invoke CreateDockingWindow,EBX,ADDR TBDockData
	MOV hToolBox,EAX
	Invoke SetWindowLong,hToolBox,GWL_WNDPROC,ADDR ToolBoxProc

	Invoke CreateWindowEx,NULL,Offset szToolbarClass,NULL,WS_CHILD OR WS_VISIBLE OR TBSTYLE_TOOLTIPS OR CCS_NORESIZE OR TBSTYLE_FLAT OR TBSTYLE_WRAPABLE,0,YEDGE+14,50,100,hToolBox,NULL,hInstance,NULL
	MOV hToolBoxToolBar,EAX


	; Make sure the toolbar button images are transparent so load them separately
	Invoke ImageList_LoadImage,hInstance,IDB_TOOLBOXBITMAPNORMAL,24,60,0FF00FFh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	; Save the image handle that is returned to identify it when drawing
	MOV hImlRCToolBoxNormal,EAX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlRCToolBoxNormal,CLR_NONE


	; Make sure the toolbar button images are transparent so load them separately
	Invoke ImageList_LoadImage,hInstance,IDB_TOOLBOXBITMAPDISABLED,24,60,0FF00FFh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	; Save the image handle that is returned to identify it when drawing
	MOV hImlRCToolBoxDisabled,EAX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlRCToolBoxDisabled,CLR_NONE

	Invoke SendMessage,hToolBoxToolBar,TB_SETIMAGELIST,0,hImlRCToolBoxNormal
	Invoke SendMessage,hToolBoxToolBar,TB_SETDISABLEDIMAGELIST,0,hImlRCToolBoxDisabled
	
	Invoke SendMessage,hToolBoxToolBar,TB_BUTTONSTRUCTSIZE,SizeOf TBBUTTON,0
	Invoke SendMessage,hToolBoxToolBar,TB_ADDBUTTONS,25,ADDR tbToolBox

	
	
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CUSTOMCONTROLEX
	MOV lpCustomControls,EAX
	MOV EDI,EAX
	MOV ESI,SizeOf CUSTOMCONTROLEX
	XOR EBX,EBX
	
	@@:
		INC EBX
		Invoke BinToDec,EBX,ADDR Buffer
		Invoke GetPrivateProfileStruct,Offset szCONTROLS,ADDR Buffer,EDI,SizeOf CUSTOMCONTROL,Offset IniFileName
		.If EAX
			MOV EAX,IDM_TOOLBOX_USERDEFINEDCONTROL
			ADD EAX,EBX
			MOV CustomControlButton.idCommand,EAX
			Invoke SendMessage,hToolBoxToolBar,TB_ADDBUTTONS,1,ADDR CustomControlButton
			PUSH ESI
			ADD ESI,SizeOf CUSTOMCONTROLEX
			Invoke HeapReAlloc,hMainHeap,HEAP_ZERO_MEMORY,lpCustomControls,ESI
			MOV lpCustomControls,EAX
			POP EDI
			ADD EDI,EAX
			JMP @B
		.EndIf
		
		Invoke SetWindowLong,hToolBoxToolBar,GWL_WNDPROC,Offset NewToolBoxToolBar
		Invoke SetWindowLong,hToolBoxToolBar,GWL_USERDATA,EAX
	
	RETN
	
	;------------------------------------------------------------------------------------
	CreateRCOptions:

	MOV RCOptionsDockData.lpCaption, Offset szDialogDW
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szDockedTo,RIGHTDOCK, Offset IniFileName
	MOV RCOptionsDockData.fDockedTo,EAX
	
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szNoDockLeft,100, Offset IniFileName
	MOV RCOptionsDockData.NoDock.dLeft,EAX
	
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szNoDockTop,40, Offset IniFileName
	MOV RCOptionsDockData.NoDock.dTop,EAX

	
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szNoDockWidth,180, Offset IniFileName
	MOV RCOptionsDockData.NoDock.dWidth,EAX
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szNoDockHeight,48, Offset IniFileName
	MOV RCOptionsDockData.NoDock.dHeight,EAX
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szDockTopHeight,42, Offset IniFileName
	MOV RCOptionsDockData.DockTopHeight,EAX
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szDockBottomHeight,42, Offset IniFileName
	MOV RCOptionsDockData.DockBottomHeight,EAX
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szDockLeftWidth,28, Offset IniFileName
	MOV RCOptionsDockData.DockLeftWidth,EAX
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szDockRightWidth,28, Offset IniFileName
	MOV RCOptionsDockData.DockRightWidth,EAX
	Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szTitleStyle,0, Offset IniFileName
	OR EAX,WS_CLIPCHILDREN OR WS_CLIPSIBLINGS OR WS_CHILD
	MOV EBX,EAX
	
	.If !AutoToolAndOptions	;i.e. make it invisible because it will show automatically if MDI child with rc file is activated
		Invoke GetPrivateProfileInt, Offset szRCOPTIONS, Offset szVisible,0, Offset IniFileName
		.If EAX
			OR EBX,WS_VISIBLE
			Invoke CheckMenuItem,hMenu,IDM_VIEW_DIALOG,MF_CHECKED
		.EndIf
	.EndIf
	
	Invoke CreateDockingWindow,EBX,ADDR RCOptionsDockData
	MOV hRCOptions,EAX
	Invoke SetWindowLong,hRCOptions,GWL_WNDPROC,ADDR OptionsProc
	
	;WS_DISABLED or 
	Invoke CreateWindowEx,NULL,Offset szToolbarClass,NULL,WS_CHILD OR WS_VISIBLE OR TBSTYLE_TOOLTIPS OR CCS_NORESIZE OR TBSTYLE_FLAT OR TBSTYLE_WRAPABLE,0,YEDGE+14,50,100,hRCOptions,NULL,hInstance,NULL
	MOV hRCOptionsToolBar,EAX
	
	Invoke SendMessage,hRCOptionsToolBar,TB_BUTTONSTRUCTSIZE,SizeOf TBBUTTON,0

	Invoke ImageList_LoadImage,hInstance,106,16,60,0FF00FBh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	; Save the image handle that is returned to identify it when drawing
	MOV hImlRCOptions,EAX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlRCOptions,CLR_NONE


	Invoke ImageList_LoadImage,hInstance,140,16,60,0FF00FBh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	; Save the image handle that is returned to identify it when drawing
	MOV hImlRCOptionsDisabled,EAX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlRCOptionsDisabled,CLR_NONE
	
	
	Invoke SendMessage,hRCOptionsToolBar,TB_SETIMAGELIST,0,hImlRCOptions
	Invoke SendMessage,hRCOptionsToolBar,TB_SETDISABLEDIMAGELIST,0,hImlRCOptionsDisabled
	Invoke SendMessage,hRCOptionsToolBar,TB_ADDBUTTONS,16,ADDR tbOptions
	
	
	Invoke GetPrivateProfileInt,Offset szSETTINGSONEXIT, Offset szShowGridKey, 1,Offset IniFileName
	Invoke SendMessage,hRCOptionsToolBar,TB_SETSTATE,IDM_DIALOG_SHOWHIDEGRID,EAX

	Invoke GetPrivateProfileInt,Offset szSETTINGSONEXIT, Offset szSnapToGridKey, 1,Offset IniFileName

	Invoke SendMessage,hRCOptionsToolBar,TB_SETSTATE,IDM_DIALOG_SNAPTOGRID,EAX

	Invoke GetPrivateProfileInt,Offset szSETTINGSONEXIT, Offset szGridSizeKey, 5,Offset IniFileName
	MOV GridSize,EAX

	RETN
MainWndProc_Create EndP

MakeFinished Proc
Local Buffer[256]:BYTE

	Invoke LoadCursor,0,IDC_WAIT
	Invoke SetCursor,EAX

	Invoke SetAllBuggyLines
	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,Offset szCr
	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE, Offset szMakeFinshed	
	
	Invoke BinToDec,NrOfErrors,ADDR Buffer

	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE, ADDR Buffer
	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE, Offset szMakeError
	
	Invoke SendMessage,hOut,EM_GETLINECOUNT,0,0
    MOV LineHilited,EAX


	.If NrOfErrors==0
		Invoke SendMessage,hOut,CHM_SETHILITELINE,EAX,2
		;Invoke DoEvents
		.If ShowOutOnSuccess==TRUE
			Invoke ShowWindow,WinAsmHandles.hOutParent,SW_SHOW
		.Else
			Invoke ShowWindow,WinAsmHandles.hOutParent,SW_HIDE
		.EndIf
	.Else
		Invoke SendMessage,hOut,CHM_SETHILITELINE,EAX,1
		;Invoke DoEvents
		Invoke ShowWindow,WinAsmHandles.hOutParent,SW_SHOW
	.EndIf
	Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szNULL
	Invoke LoadCursor,0,IDC_ARROW
	Invoke SetCursor,EAX
	RET
MakeFinished EndP

GetMainWindowPlacement Proc
Local WindowPlacement	:WINDOWPLACEMENT

	MOV WindowPlacement.iLength, SizeOf WINDOWPLACEMENT
	Invoke GetWindowPlacement,WinAsmHandles.hMain,ADDR WindowPlacement
	Invoke WritePrivateProfileStruct,Offset szGENERAL,Offset szPlacement,ADDR WindowPlacement,SizeOf WINDOWPLACEMENT,Offset IniFileName
	RET
	
GetMainWindowPlacement EndP

SetBandColors Proc
Local rbi	:REBARBANDINFO
	MOV rbi.cbSize,SizeOf REBARBANDINFO



	MOV rbi.fMask,RBBIM_COLORS
	Invoke GetSysColor,COLOR_BTNTEXT
	MOV rbi.clrFore,EAX
	Invoke GetSysColor,COLOR_BTNFACE
	MOV rbi.clrBack, EAX
	Invoke SendMessage,WinAsmHandles.hRebar,RB_SETBANDINFO,0,ADDR rbi  
	Invoke SendMessage,WinAsmHandles.hRebar,RB_SETBANDINFO,1,ADDR rbi  
	Invoke SendMessage,WinAsmHandles.hRebar,RB_SETBANDINFO,2,ADDR rbi  
	RET
SetBandColors EndP

MainWndProc Proc Uses EBX EDI ESI hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local Rect			:RECT
Local chrg			:CHARRANGE
Local pt			:POINT

Local hActiveChild	:HWND
Local Buffer[288]	:BYTE	;To cover Menus too
Local szCounter[12]	:BYTE
Local tvi			:TVITEM

	
	Invoke SendCallBackToAllAddIns,pAddInsFrameProcedures,hWnd,uMsg,wParam,lParam
	.If EAX==0
;		.If uMsg!=WM_TIMER && uMsg!=4eh && uMsg!=121h
;				PrintHex uMsg
;		.EndIf
		.If uMsg==WM_CREATE
			Invoke MainWndProc_Create, hWnd
			
			;FUNCTIONLISTTRIGGER STRUCT
			;	szKeyWord		DB 32+1	DUP (?)
			;	CharToFollow	DB 1	DUP (?)
			;	CharToAdd		DB 1+1	DUP (?)
			;	Active			BOOLEAN
			;FUNCTIONLISTTRIGGER ENDS
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf FUNCTIONLISTTRIGGER
			
			MOV lpTrigger,EAX
			MOV EDI,EAX
			MOV ESI,SizeOf FUNCTIONLISTTRIGGER
			XOR EBX,EBX
			
			@@:
				INC EBX
				Invoke BinToDec,EBX,ADDR Buffer
				Invoke GetPrivateProfileStruct,Offset szTRIGGER,ADDR Buffer,EDI,SizeOf FUNCTIONLISTTRIGGER,Offset IniFileName
				.If EAX
					PUSH ESI
					ADD ESI,SizeOf FUNCTIONLISTTRIGGER
					Invoke HeapReAlloc,hMainHeap,HEAP_ZERO_MEMORY,lpTrigger,ESI
					MOV lpTrigger,EAX
					POP EDI
					ADD EDI,EAX
					JMP @B
				.EndIf
				
				
			;General rule of thumb:
			;longer keywords first because in rare cases such as
			;Invoke and $Invoke we have problems since $ is a separator
			
			
		.ElseIf uMsg==WM_MEASUREITEM
			.If wParam == 0		;i.e menu
				Invoke MeasureItem,lParam
				MOV EAX,TRUE
				JMP NoDefFrameProc
			.EndIf
			
		.ElseIf uMsg == WM_DRAWITEM
			.If wParam == 0
				Invoke DrawItem,lParam
				MOV EAX,TRUE
				;RET
				JMP NoDefFrameProc
			.EndIf
			
		.ElseIf uMsg==WM_SYSCOLORCHANGE
			Invoke SetBandColors
			
		.ElseIf uMsg == WM_NCACTIVATE
			.If lParam
				Invoke SendMessage,hWnd,WM_NCACTIVATE,TRUE,0
				MOV EAX, TRUE
				JMP NoDefFrameProc
			.EndIf
			
;		.ElseIf uMsg ==WM_ACTIVATE
;			;Invoke SetActiveWindow,hWnd
;			PrintText "Hi qll"
			
		.ElseIf uMsg ==WM_ACTIVATEAPP
			Invoke DefFrameProc, hWnd, hClient, WM_NCACTIVATE, wParam,0
			Invoke InvalidateAllDockWindows
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WM_INITMENUPOPUP
			MOV EAX,wParam
			.If EAX==WinAsmHandles.PopUpMenus.hFileMenu
				Invoke AddRecentProjectsMenuItems
				
			.ElseIf EAX==WinAsmHandles.PopUpMenus.hEditMenu
				Invoke SendMessage,hClient,WM_MDIGETACTIVE,NULL,NULL
				.If EAX	;Thanks Bi_Dark
					MOV hActiveChild, EAX
					Invoke GetWindowLong,EAX,0
					MOV EBX,EAX
					
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXGETSEL,0,ADDR chrg
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXLINEFROMCHAR,0,chrg.cpMin
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_GETBOOKMARK,EAX,0
					.If EAX!=1 && EAX!=2	;i.e. we are not on a block declaration line
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_GETWORD,256,ADDR Buffer
						;Let's see if word under caret is a block
						Invoke IsThisABlockName,ADDR Buffer
						.If !EAX	;i.e. the word under caret is a block name

							Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hEditMenu,IDM_EDIT_GOTOBLOCK,MF_ENABLED
						.Else
							Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hEditMenu,IDM_EDIT_GOTOBLOCK,MF_GRAYED
						.EndIf
					.Else
						Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hEditMenu,IDM_EDIT_GOTOBLOCK,MF_GRAYED
					.EndIf
				.EndIf
			.ElseIf EAX==WinAsmHandles.PopUpMenus.hProjectMenu
				;Disable "Remove File" from Project Menu
				Invoke EnableMenuItem,hMenu,IDM_PROJECT_REMOVEFILE,MF_GRAYED

				Invoke EnableMenuItem,hMenu,IDM_PROJECT_RUNBATCH,MF_GRAYED
				
				Invoke EnableMenuItem,hMenu,IDM_PROJECT_SETASMODULE,MF_GRAYED
				Invoke CheckMenuItem,hMenu,IDM_PROJECT_SETASMODULE,MF_UNCHECKED
				
				Invoke EnableMenuItem,hMenu,IDM_PROJECT_RENAMEFILE,MF_GRAYED
				Invoke SendMessage, WinAsmHandles.hProjTree, TVM_GETNEXTITEM, TVGN_CARET, 0 ; get current item
				PUSH ESI
				MOV ESI,EAX
				.If ESI==0 || ESI==hParentItem || ESI==hASMFilesItem || ESI==hModulesItem || ESI==hIncludeFilesItem || ESI== hResourceFilesItem || ESI==hTextFilesItem || ESI==hOtherFilesItem || ESI==hDefFilesItem || ESI==hBatchFilesItem
				.Else
					Invoke EnableMenuItem,hMenu,IDM_PROJECT_REMOVEFILE,MF_ENABLED
					Invoke EnableMenuItem,hMenu,IDM_PROJECT_RENAMEFILE,MF_ENABLED
					Invoke GetTreeItemParameter,WinAsmHandles.hProjTree,ESI
					.If EAX
						Invoke GetWindowLong,EAX,0
						.If EAX
							.If CHILDWINDOWDATA.dwTypeOfFile[EAX]==6 ;i.e. this is a batch file
								Invoke EnableMenuItem,hMenu,IDM_PROJECT_RUNBATCH,MF_ENABLED
							.ElseIf CHILDWINDOWDATA.dwTypeOfFile[EAX]==1 || CHILDWINDOWDATA.dwTypeOfFile[EAX]==51;i.e. this is a ASM file
								PUSH EAX
								Invoke EnableMenuItem,hMenu,IDM_PROJECT_SETASMODULE,MF_ENABLED
								POP EAX
								.If CHILDWINDOWDATA.dwTypeOfFile[EAX]==51
									Invoke CheckMenuItem,hMenu,IDM_PROJECT_SETASMODULE,MF_CHECKED
								.EndIf
							.EndIf
						.EndIf
					.EndIf
				.EndIf
				POP ESI
			.ElseIf EAX==WinAsmHandles.PopUpMenus.hDialogMenu
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_SHOWHIDEGRID,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_SNAPTOGRID,MF_GRAYED
				;Invoke EnableMenuItem,hMenu,IDM_DIALOG_UNDO,MF_GRAYED
				;Invoke EnableMenuItem,hMenu,IDM_DIALOG_REDO,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_CUT,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_COPY,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_PASTE,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_STYLE,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_EXSTYLE,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_DIALOGFONT,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_DELETE,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_SENDTOBACK,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_BRINGONTOP,MF_GRAYED
				Invoke EnableMenuItem,hMenu,IDM_DIALOG_TESTDIALOG,MF_GRAYED
				
				Invoke SendMessage,hClient,WM_MDIGETACTIVE,NULL,NULL
				.If EAX	&& EAX==hRCEditorWindow
					;Is there any selected dialog/control?
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
					.If EAX	;Yes there is
						Invoke GetTreeItemParameter,hDialogsTree,EAX
						.If [EAX].CONTROLDATA.ntype==0	;Dialog
							Invoke EnableMenuItem,hMenu,IDM_DIALOG_DIALOGFONT,MF_ENABLED
						.Else
							Invoke EnableMenuItem,hMenu,IDM_DIALOG_CUT,MF_ENABLED
							Invoke EnableMenuItem,hMenu,IDM_DIALOG_COPY,MF_ENABLED
							Invoke EnableMenuItem,hMenu,IDM_DIALOG_SENDTOBACK,MF_ENABLED
							Invoke EnableMenuItem,hMenu,IDM_DIALOG_BRINGONTOP,MF_ENABLED
						.EndIf
						
						;Invoke GetWindowLong,hADialog,GWL_USERDATA
						;.If [EAX].DIALOGDATA.lpUndoRedoMemory	;pointer to UndoRedoMemory for this dialog
						;	MOV EDI,EAX
						;	Invoke EnableMenuItem,hMenu,IDM_DIALOG_UNDO,MF_ENABLED
						;	.If [EDI].DIALOGDATA.lpUndoRedoPointer
						;		Invoke EnableMenuItem,hMenu,IDM_DIALOG_REDO,MF_ENABLED
						;	.EndIf
						;.EndIf
						
						Invoke IsClipboardFormatAvailable,hClipFormat
						.If EAX
							Invoke EnableMenuItem,hMenu,IDM_DIALOG_PASTE,MF_ENABLED
						.EndIf
						Invoke EnableMenuItem,hMenu,IDM_DIALOG_STYLE,MF_ENABLED
						Invoke EnableMenuItem,hMenu,IDM_DIALOG_EXSTYLE,MF_ENABLED
						Invoke EnableMenuItem,hMenu,IDM_DIALOG_DELETE,MF_ENABLED
						Invoke EnableMenuItem,hMenu,IDM_DIALOG_TESTDIALOG,MF_ENABLED
						
						Invoke EnableMenuItem,hMenu,IDM_DIALOG_SHOWHIDEGRID,MF_ENABLED
						Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SHOWHIDEGRID,0
						AND EAX,TBSTATE_CHECKED
						;Now EAX=1 if checked;0 if not
						.If EAX
							Invoke CheckMenuItem,hMenu,IDM_DIALOG_SHOWHIDEGRID,MF_CHECKED
						.Else
							Invoke CheckMenuItem,hMenu,IDM_DIALOG_SHOWHIDEGRID,MF_UNCHECKED
						.EndIf
						
						Invoke EnableMenuItem,hMenu,IDM_DIALOG_SNAPTOGRID,MF_ENABLED
						Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
						AND EAX,TBSTATE_CHECKED
						;Now EAX=1 if checked;0 if not
						.If EAX
							Invoke CheckMenuItem,hMenu,IDM_DIALOG_SNAPTOGRID,MF_CHECKED
						.Else
							Invoke CheckMenuItem,hMenu,IDM_DIALOG_SNAPTOGRID,MF_UNCHECKED
						.EndIf
						
					.EndIf
					
				.EndIf
			.ElseIf EAX==WinAsmHandles.PopUpMenus.hResourcesMenu
				MOV EBX,MF_UNCHECKED
				MOV EDI,MF_GRAYED
				MOV ESI,MF_GRAYED
				Invoke SendMessage,hClient,WM_MDIGETACTIVE,NULL,NULL
				.If EAX
					MOV hActiveChild, EAX
					Invoke GetWindowLong,hActiveChild,0
					.If [EAX].CHILDWINDOWDATA.dwTypeOfFile==3 || [EAX].CHILDWINDOWDATA.dwTypeOfFile==103
						MOV EDI,MF_ENABLED
						MOV EAX,hRCEditorWindow
						.If EAX && EAX==hActiveChild
							MOV EBX,MF_CHECKED
							MOV ESI,MF_ENABLED
						.EndIf
					.EndIf
				.EndIf
				
				Invoke EnableMenuItem,hMenu,IDM_RESOURCES_DEFINITIONSMANAGER,ESI
				
				Invoke EnableMenuItem,hMenu,IDM_RESOURCES_USEEXTRCEDITOR,EDI
				Invoke EnableMenuItem,hMenu,IDM_RESOURCES_VISUALMODE,EDI
				Invoke CheckMenuItem,hMenu,IDM_RESOURCES_VISUALMODE,EBX
				
			.ElseIf EAX==WinAsmHandles.PopUpMenus.hInterfacePacks
				.If lpInterfacePacks
					@@:
					Invoke DeleteMenu,WinAsmHandles.PopUpMenus.hInterfacePacks,0,MF_BYPOSITION
					.If EAX
						JMP @B
					.EndIf
					Invoke HeapFree,hMainHeap,0,lpInterfacePacks
					MOV lpInterfacePacks,0
				.EndIf
				
				MOV dwGlobalCounter,0
				Invoke EnumDllsInFolder, Offset CountInterfacePackDLLs,Offset szInUIAllDLLs
				
				.If dwGlobalCounter
					MOV EAX,SizeOf MAX_PATH+1
					MUL dwGlobalCounter
					Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,EAX
					MOV lpInterfacePacks,EAX
					Invoke EnumDllsInFolder, Offset AddInterfacePackItem,Offset szInUIAllDLLs
				.EndIf
				Invoke DrawMenuBar,WinAsmHandles.hMain
			.EndIf
		.ElseIf uMsg == WM_COMMAND
			HIWORD wParam
			.If EAX == 0 || 1 ; 0 is a menu, 1 is an accelerator. Toolbar messages act like menu messages...
				Invoke SendMessage,hClient,WM_MDIGETACTIVE,NULL,NULL
				MOV hActiveChild, EAX
				.If EAX
					Invoke GetWindowLong,EAX,0
					MOV EBX,EAX
				.EndIf
				
				LOWORD wParam
				.If EAX == IDM_NEWPROJECT
					;2=Check wap, and all project files. NOT external files
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 2
					.If EAX	;EAX==TRUE if Yes or No was selected
						;Invoke ClearProject
						Invoke DialogBoxParam, hUILib, IDD_PROJECTPROPERTIES, hWnd, ADDR ProjectPropertiesDlgProc, TRUE
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
				.ElseIf EAX == IDM_OPENPROJECT
					;2=Check wap, and all project files. NOT external files
					
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 2
					.If EAX	;EAX==TRUE if Yes or No was selected
						;Invoke ClearProject	;It is in OpenWap
						Invoke OpenProject
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					;MOV EAX,IDM_OPENPROJECT
					;JMP NoDefFrameProc
					
				.ElseIf EAX == IDM_CLOSEPROJECT
					;2=Check wap, and all project files. NOT external files
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 2
					.If EAX	;EAX==TRUE if Yes or No was selected
						;Invoke DisableAll
						Invoke DisableTheRest
						Invoke ClearProject
						;Look: after Clear project NOT before
						Invoke EnableDisableMakeOptions
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind, TRUE
					
				.ElseIf EAX>10020 && EAX<10027;10040
					MOV EBX,EAX
					
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					;2=Check wap, and all project files. NOT external files
					Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 2
					.If EAX	;EAX==TRUE if Yes or No was selected
						SUB EBX,10020
						Invoke BinToDec,EBX,ADDR Buffer
						Invoke GetPrivateProfileString, Offset szRECENT, ADDR Buffer, ADDR szNULL, ADDR Buffer, 288, Offset IniFileName
						;There is a Call to ClearProject in OpenWAP  
						Invoke OpenWAP,ADDR Buffer
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
				.ElseIf EAX == IDM_SAVEPROJECT
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					;2=Check wap, and all project files. NOT external files
					Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 2
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind, TRUE
					
					;Just to change state of the Save Button
					Invoke SetFocus,hActiveChild
				.ElseIf EAX == IDM_SAVEPROJECTAS
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					;2=Check wap, and all project files. NOT external files
					Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 3
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind, TRUE
					
					;Just to change state of the Save Button
					Invoke SetFocus,hActiveChild
				.ElseIf EAX == IDM_OPENFILES

					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke OpenEdit,Offset szOpenFilesDialogTitle;szWinAsmOpenFiles
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind, TRUE
					;MOV EAX,IDM_OPENFILES
					;JMP NoDefFrameProc
					
				.ElseIf EAX == IDM_NEWASMFILE
					MOV EDI,101
					Invoke lstrcpy,Offset FileName,ADDR szNewFile
					INC UntitledAsmCounter
					
					Invoke BinToDec,UntitledAsmCounter,ADDR Buffer
					
					Invoke lstrcat,Offset FileName,ADDR Buffer
					Invoke lstrcat,Offset FileName,Offset szExtAsm
					CALL NewFile
					
				.ElseIf EAX == IDM_NEWINCFILE
					MOV EDI,102
					Invoke lstrcpy,Offset FileName,ADDR szNewFile
					INC UntitledIncCounter
					Invoke BinToDec,UntitledIncCounter,ADDR Buffer
					Invoke lstrcat,Offset FileName,ADDR Buffer
					Invoke lstrcat,Offset FileName,Offset szExtInc
					CALL NewFile
					
				.ElseIf EAX == IDM_NEWRCFILE
					MOV EDI,103
					Invoke lstrcpy,Offset FileName,ADDR szNewFile
					INC UntitledRcCounter
					Invoke BinToDec,UntitledRcCounter,ADDR Buffer
					Invoke lstrcat,Offset FileName,ADDR Buffer
					Invoke lstrcat,Offset FileName,Offset szExtRc
					CALL NewFile
					
				.ElseIf EAX == IDM_NEWOTHERFILE
					MOV EDI,107
					Invoke lstrcpy,Offset FileName,ADDR szNewFile
					INC UntitledOtherCounter
					Invoke BinToDec,UntitledOtherCounter,ADDR Buffer
					Invoke lstrcat,Offset FileName,ADDR Buffer
					CALL NewFile
					
				.ElseIf EAX == IDM_SAVEFILE
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					MOV EDI,hActiveChild
					.If EDI==hRCEditorWindow
						Invoke GenerateResourceScript,FALSE
					.EndIf
					Invoke SaveEdit,hActiveChild,ADDR [EBX].CHILDWINDOWDATA.szFileName
					.If EAX	;i.e. File Saved
						;Invoke SetTvItemAndWindowCaption, hActiveChild
						.If EDI==hRCEditorWindow
							Invoke SetRCModified,FALSE
						.EndIf
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
					;Just to change state of the Save Button
					Invoke SetFocus,hActiveChild
					
				.ElseIf EAX == IDM_SAVEFILEAS
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					MOV EDI,hActiveChild
					.If EDI==hRCEditorWindow
						Invoke GenerateResourceScript,FALSE
					.EndIf
					
					Invoke SaveEditAs,hActiveChild,ADDR [EBX].CHILDWINDOWDATA.szFileName,Offset szSaveFileAsDialogTitle
					.If EAX		;i.e. File Saved
						Invoke SetTvItemAndWindowCaption, hActiveChild
						.If EDI==hRCEditorWindow
							Invoke SetRCModified,FALSE
						.EndIf
						.If [EBX].CHILDWINDOWDATA.dwTypeOfFile < 101	;i.e. file is part of the currently opened project
							MOV ProjectModified,TRUE
						.EndIf
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
					;Just to change state of the Save Button
					Invoke SetFocus,hActiveChild
					
				.ElseIf EAX==IDM_PRINT
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke Print,CHILDWINDOWDATA.hEditor[EBX]
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
				.ElseIf EAX==IDM_RECENTPROJECTSMANAGER
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke DialogBoxParam, hUILib, 218, WinAsmHandles.hMain, Offset RecentProjectsDialogProc, 2
					;.If EAX	;EAX==TRUE if Open was selected
					
					;.EndIf
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
				.ElseIf EAX == IDM_EXIT
					.If note.hwnd
						;Thanks Richm
						Invoke Shell_NotifyIcon,NIM_DELETE,ADDR note
					.EndIf
					Invoke SendMessage,hWnd,WM_CLOSE,0,0
					
				.ElseIf EAX==IDM_RESTORE
					Invoke ShowWindow,hWnd,SW_RESTORE
					Invoke Shell_NotifyIcon,NIM_DELETE,ADDR note
					
				.ElseIf EAX==IDM_EDIT_UNDO
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_UNDO,0,0
					
				.ElseIf EAX == IDM_EDIT_REDO
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_REDO,0,0
					
				.ElseIf EAX == IDM_EDIT_CUT
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_CUT,0,0
					Invoke EnableMenuItem,hMenu,IDM_EDIT_PASTE,MF_ENABLED
					Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_PASTE,TBSTATE_ENABLED
					
				.ElseIf EAX == IDM_EDIT_COPY
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_COPY,0,0
					Invoke EnableMenuItem,hMenu,IDM_EDIT_PASTE,MF_ENABLED
					Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_EDIT_PASTE,TBSTATE_ENABLED
					
				.ElseIf EAX == IDM_EDIT_PASTE
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_PASTE,0,0
					
				.ElseIf EAX==IDM_EDIT_DELETE
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_CLEAR,0,0
					
				.ElseIf EAX==IDM_EDIT_SELECTALL
					MOV chrg.cpMin,0
					MOV chrg.cpMax,-1
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXSETSEL,0,ADDR chrg
					
				.ElseIf EAX==IDM_EDIT_FIND
					PUSH [EBX].CHILDWINDOWDATA.hEditor
					POP hEditor
					.If hFind==0
						;Invoke InvalidateAllDockWindows
						Invoke CreateDialogParam,hUILib,IDD_FINDDLG,hWnd,ADDR FindDlgProc,FALSE
					.Else
						Invoke UpdateFindCombo,hFind
						Invoke SetFocus,hFind
					.EndIf
				.ElseIf EAX==IDM_EDIT_FINDNEXT
					MOV AL,FindBuffer
					.If AL
						;Just in case any of the following is visible-(Thanks cbcrack)
						Invoke HideAllLists
						Invoke ShowWindow,hToolTip,SW_HIDE
						
						;Get find direction
						MOV EAX,fr
						AND EAX,FR_UPDOWN
						.If EAX
							MOV EAX,FR_UPDOWN	;i.e. down then over
						.Else
							MOV EAX,FR_DOWN		;i.e. down
						.EndIf
						
						Invoke Find,[EBX].CHILDWINDOWDATA.hEditor,EAX,Offset FindBuffer,2
						.If EAX		;i.e. if  FR_UPDOWN is selected, the messagbox "region searched has already been shown, then get ready to start again
							;Useful if FR_UPDOWN (Thanks JimG)
							;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXGETSEL,0,Offset StartChrg
							;MOV bDownSearched,FALSE
							Invoke SetStartingPosition
						.EndIf
						
					.EndIf
					
				.ElseIf EAX==IDM_EDIT_FINDPREVIOUS
					MOV AL,FindBuffer
					.If AL
						Invoke Find,[EBX].CHILDWINDOWDATA.hEditor,0,Offset FindBuffer,2
					.EndIf
					
				.ElseIf EAX==IDM_EDIT_SMARTFIND
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXGETSEL,0,ADDR chrg
					MOV EAX,chrg.cpMax
					.If EAX!=chrg.cpMin
						SUB EAX,chrg.cpMin
						.If EAX>255
							MOV ECX,chrg.cpMin
							ADD ECX,255
							MOV chrg.cpMax,ECX
						.EndIf
						Invoke GetTextRange,CHILDWINDOWDATA.hEditor[EBX],ADDR Buffer,256,ADDR chrg
					.Else
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_GETWORD,256,ADDR Buffer
					.EndIf
					MOV AL,Buffer
					.If AL
						;Invoke Find,CHILDWINDOWDATA.hEditor[EBX],FR_DOWN,ADDR Buffer,0
						MOV EDX,fr
						AND EDX,-1 XOR FR_CURRENTPROJECT
						Invoke Find,[EBX].CHILDWINDOWDATA.hEditor,EDX,ADDR Buffer,2;0
						MOV bDownSearched,FALSE
					.EndIf
					
				.ElseIf EAX==IDM_EDIT_REPLACE
					PUSH CHILDWINDOWDATA.hEditor[EBX]
					POP hEditor
					.If hFind==0
						Invoke CreateDialogParam,hUILib,IDD_FINDDLG,hWnd,ADDR FindDlgProc,TRUE
					.Else
						Invoke SetFocus,hFind
					.EndIf
				.ElseIf EAX == IDM_EDIT_GOTOLINE
					.If hFind == 0
						Invoke CreateDialogParam, hUILib, IDD_GOTOLINE, hWnd, Offset GoToLineDialogProc, EAX
					.EndIf
				.ElseIf EAX == IDM_EDIT_HIDELINES
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXGETSEL,0,addr chrg
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXLINEFROMCHAR,0,chrg.cpMin
					MOV ESI,EAX
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXLINEFROMCHAR,0,chrg.cpMax
					.If EAX>ESI
						MOV EDI,EAX
						SUB EDI,ESI
						Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_HIDELINES,ESI,EDI
						;i.e. I set BM ID = number of lines to hide so that I know later
						;Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBMID,ESI,EDI
						Invoke SetFocus,[EBX].CHILDWINDOWDATA.hEditor
						Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SCROLLCARET,0,0
					.EndIf
					
				.ElseIf EAX == IDM_EDIT_GOTOBLOCK
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXGETSEL,0,ADDR chrg
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXLINEFROMCHAR,0,chrg.cpMin
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_SETBOOKMARK,EAX,10
					M2M hEditorToGoBack,[EBX].CHILDWINDOWDATA.hEditor
					;CHM_GETWORD: wParam=BuffSize,lParam=lpBuff
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_GETWORD,256,ADDR Buffer
					LEA EAX,Buffer
					MOV lpProcedureName,EAX
					Invoke EnumProjectItems,ScrollToBlock
					Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hEditMenu,IDM_EDIT_GOBACK,MF_ENABLED
					
				.ElseIf EAX == IDM_EDIT_GOBACK
					Invoke GetParent,hEditorToGoBack
					Invoke SetWindowPos,EAX, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
					;CHM_NXTBOOKMARK			EQU CHM_BASE+10		;wParam=Line			lParam=Type
					Invoke SendMessage,hEditorToGoBack,CHM_NXTBOOKMARK,-1,10
					;Now EAX is the line containing the Bookmark
					MOV EBX,EAX
					;Clear the bookmark!
					Invoke SendMessage,hEditorToGoBack,CHM_SETBOOKMARK,EBX,0
					Invoke SendMessage,hEditorToGoBack,EM_LINEINDEX,EBX,0
					MOV chrg.cpMin,EAX
					MOV chrg.cpMax,EAX
					Invoke SendMessage,hEditorToGoBack,EM_EXSETSEL,0,ADDR chrg
					Invoke SendMessage,hEditorToGoBack,EM_SCROLLCARET,0,0
					Invoke SetFocus,hEditorToGoBack
					Invoke EnableMenuItem,WinAsmHandles.PopUpMenus.hEditMenu,IDM_EDIT_GOBACK,MF_GRAYED
				.ElseIf EAX==IDM_EDIT_TOGGLEBM
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXGETSEL,0,ADDR chrg
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXLINEFROMCHAR,0,chrg.cpMin
					PUSH EDI
					MOV EDI,EAX
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_GETBOOKMARK,EDI,0
					.If !EAX
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_SETBOOKMARK,EDI,3
					.ElseIf EAX==3
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_SETBOOKMARK,EDI,0
					.EndIf
					Invoke EnableDisable,CHILDWINDOWDATA.hEditor[EBX]
					POP EDI
				.ElseIf EAX==IDM_EDIT_NEXTBM
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXGETSEL,0,ADDR chrg
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXLINEFROMCHAR,0,chrg.cpMin
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_NXTBOOKMARK,EAX,3
					.If EAX!=-1
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_LINEINDEX,EAX,0
						MOV chrg.cpMin,EAX
						MOV chrg.cpMax,EAX
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXSETSEL,0,ADDR chrg
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_SCROLLCARET,0,0
					.EndIf
				.ElseIf EAX==IDM_EDIT_PREVBM
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXGETSEL,0,ADDR chrg
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXLINEFROMCHAR,0,chrg.cpMin
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_PRVBOOKMARK,EAX,3
					.If EAX!=-1
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_LINEINDEX,EAX,0
						MOV chrg.cpMin,EAX
						MOV chrg.cpMax,EAX
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXSETSEL,0,ADDR chrg
						Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_SCROLLCARET,0,0
					.EndIf
				.ElseIf EAX==IDM_EDIT_CLEARBM
					Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_CLRBOOKMARKS,0,3
					Invoke EnableDisable,CHILDWINDOWDATA.hEditor[EBX]
					
				.ElseIf EAX==IDM_VIEW_PROJECTEXPLORER
					Invoke IsWindowVisible,WinAsmHandles.hProjExplorer
					.If EAX
						Invoke ShowWindow,WinAsmHandles.hProjExplorer,SW_HIDE
					.Else
						Invoke ShowWindow,WinAsmHandles.hProjExplorer,SW_SHOW
					.EndIf
					
				.ElseIf EAX==IDM_VIEW_OUTPUT
					Invoke HideAllLists
					.If !EAX	;i.e If no list was shown before calling HideAllLists
						Invoke IsWindowVisible,WinAsmHandles.hOutParent
						.If EAX
							Invoke ShowWindow,WinAsmHandles.hOutParent,SW_HIDE
						.Else
							HIWORD wParam
							.If EAX == 0	; 0 is a menu, 1 is an accelerator. Toolbar messages act like menu messages...
								Invoke ShowWindow,WinAsmHandles.hOutParent,SW_SHOW
							.EndIf
						.EndIf
					.EndIf
					
				.ElseIf EAX==IDM_VIEW_TOOLBOX
					Invoke IsWindowVisible,hToolBox
					.If EAX
						Invoke ShowWindow,hToolBox,SW_HIDE
					.Else
						Invoke ShowWindow,hToolBox,SW_SHOW
					.EndIf
					
				.ElseIf EAX==IDM_VIEW_DIALOG
					Invoke IsWindowVisible,hRCOptions
					.If EAX
						Invoke ShowWindow,hRCOptions,SW_HIDE
					.Else
						Invoke ShowWindow,hRCOptions,SW_SHOW
					.EndIf
					
				.ElseIf EAX == IDM_PROJECT_ADDASM
					MOV EDI,1
					Invoke lstrcpy,Offset FileName,ADDR szNewFile;szNewASMFile
					INC UntitledAsmCounter
					Invoke BinToDec,UntitledAsmCounter,ADDR Buffer
					Invoke lstrcat,Offset FileName,ADDR Buffer
					Invoke lstrcat,Offset FileName,Offset szExtAsm
					CALL AddNewFile
					Invoke EnableDisableMakeOptions
					
				.ElseIf EAX == IDM_PROJECT_ADDINC
					MOV EDI,2
					Invoke lstrcpy,Offset FileName,ADDR szNewFile;szNewASMFile
					
					INC UntitledIncCounter
					Invoke BinToDec,UntitledIncCounter,ADDR Buffer
					Invoke lstrcat,Offset FileName,ADDR Buffer
					Invoke lstrcat,Offset FileName,Offset szExtInc
					CALL AddNewFile
					Invoke EnableDisableMakeOptions
					
				.ElseIf EAX == IDM_PROJECT_ADDRC
					MOV EDI,3
					Invoke lstrcpy,Offset FileName,ADDR szNewFile;szNewASMFile
					INC UntitledRcCounter
					Invoke BinToDec,UntitledRcCounter,ADDR Buffer
					Invoke lstrcat,Offset FileName,ADDR Buffer
					Invoke lstrcat,Offset FileName,Offset szExtRc
					CALL AddNewFile
					Invoke EnableDisableMakeOptions
				.ElseIf EAX == IDM_PROJECT_ADDOTHER
					MOV EDI,7
					Invoke lstrcpy,Offset FileName,ADDR szNewFile;szNewASMFile
					INC UntitledOtherCounter
					Invoke BinToDec,UntitledOtherCounter,ADDR Buffer
					Invoke lstrcat,Offset FileName,ADDR Buffer
					CALL AddNewFile
					Invoke EnableDisableMakeOptions
				.ElseIf EAX == IDM_PROJECT_ADDEXISTINGFILE
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke OpenEdit,Offset szAddFilesDialogTitle
					Invoke EnableDisableMakeOptions
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
				.ElseIf EAX == IDM_PROJECT_BINARYFILES
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					Invoke DialogBoxParam, hUILib, 221, hWnd, Offset BinaryFilesDialogProc, FALSE
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
				.ElseIf EAX==IDM_PROJECT_SETASMODULE
					Invoke SetAsModule,hActiveChild
					
				.ElseIf EAX == IDM_PROJECT_REMOVEFILE
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke MessageBox,hWnd,Offset szSureToRemoveFileFromProject,Offset szAppName,MB_YESNO + MB_ICONQUESTION; + MB_TASKMODAL
					.If EAX==IDYES
						Invoke RemoveFileFromProject,hActiveChild,TRUE
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
				.ElseIf EAX == IDM_PROJECT_RENAMEFILE
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					MOV EDI,hActiveChild
					.If EDI==hRCEditorWindow
						Invoke GenerateResourceScript,FALSE
					.EndIf
					Invoke lstrcpy,ADDR Buffer,ADDR [EBX].CHILDWINDOWDATA.szFileName
					Invoke SaveEditAs,hActiveChild,ADDR [EBX].CHILDWINDOWDATA.szFileName,Offset szRenameFileDialogTitle
					.If EAX		;i.e. File Saved
						Invoke lstrcmpi,ADDR Buffer,ADDR CHILDWINDOWDATA.szFileName[EBX]
						.If EAX!=0 ;i.e. really saved WITH DIFFERENT NAME
							Invoke SetTvItemAndWindowCaption, hActiveChild
							Invoke DeleteFile,ADDR Buffer	;Delete previous file
							.If EDI==hRCEditorWindow
								Invoke SetRCModified,FALSE
							.EndIf
							.If [EBX].CHILDWINDOWDATA.dwTypeOfFile < 101	;i.e. file is part of the currently opened project
								MOV ProjectModified,TRUE
							.EndIf
						.EndIf
					.EndIf
					
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
					;Just to change state of the Save Button
					Invoke SetFocus,hActiveChild
					
				.ElseIf EAX == IDM_PROJECT_RUNBATCH
					Invoke RunBatch, ADDR [EBX].CHILDWINDOWDATA.szFileName
				.ElseIf EAX == IDM_RESOURCES_USEEXTRCEDITOR
					Invoke lstrcpy,ADDR Buffer,ADDR ExternalResourceEditor
					Invoke lstrcat,ADDR Buffer,Offset szSpc
					.If UseQuotes
						Invoke lstrcat,ADDR Buffer,Offset szQuote
					.EndIf
					Invoke lstrcat,ADDR Buffer,ADDR CHILDWINDOWDATA.szFileName[EBX]
					.If UseQuotes
						Invoke lstrcat,ADDR Buffer,Offset szQuote
					.EndIf
					Invoke WinExec,ADDR Buffer,SW_SHOWNORMAL
					
				.ElseIf EAX==IDM_RESOURCES_VISUALMODE
					Invoke LockWindowUpdate,hClient
					.If [EBX].CHILDWINDOWDATA.dwTypeOfFile==3 || [EBX].CHILDWINDOWDATA.dwTypeOfFile==103  
						MOV EAX,hActiveChild
						.If EAX==hRCEditorWindow
							;It is in visual mode-->switch to text mode
							Invoke ClearRCEditor
							Invoke EnableAll
							Invoke EnableDisable,[EBX].CHILDWINDOWDATA.hEditor
							Invoke SetFocus,[EBX].CHILDWINDOWDATA.hEditor
						.Else
							;It is in text mode-->switch to visual mode
							.If hRCEditorWindow
								Invoke ClearRCEditor
							.EndIf
							M2M hRCEditorWindow,hActiveChild
							Invoke GetResources
							
							.If AutoToolAndOptions
								Invoke ShowWindow,hToolBox,SW_SHOW
								Invoke ShowWindow,hRCOptions,SW_SHOW
							.EndIf
						.EndIf
					.EndIf
					Invoke LockWindowUpdate,0
					
				.ElseIf EAX==IDM_PROJECT_PROPERTIES
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					Invoke DialogBoxParam, hUILib, IDD_PROJECTPROPERTIES, hWnd, Offset ProjectPropertiesDlgProc, FALSE
					Invoke EnableWindow, hFind, TRUE
					Invoke EnableAllDockWindows,TRUE
					
				.ElseIf EAX==IDM_PROJECT_RENAMEPROJECT
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					
					Invoke lstrcpy,ADDR Buffer,ADDR FullProjectName					
					Invoke SaveWAP,TRUE,TRUE,Offset szRenameProjectDialogTitle
					;.If Buffer[0]
					Invoke lstrcmpi,ADDR Buffer,ADDR FullProjectName
					.If EAX ;i.e. really saved WITH DIFFERENT NAME
						Invoke DeleteFile,ADDR Buffer	;Delete previous file
					.EndIf
					;.EndIf
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind,TRUE
					
					;Just to change state of the Save Button
					Invoke SetFocus,hActiveChild
					
				.ElseIf EAX == IDM_FORMAT_INDENT
					HIWORD wParam
					.If EAX == 1	;accelerator
						Invoke IsAnyIntellisenseListVisible
						.If EAX	;EAX=Visible list handle
							;MOV EBX,EAX
							;Watch: I am not sending tab! 
							;Invoke PostMessage,EBX,WM_KEYDOWN,VK_SPACE,0
							;Invoke PostMessage,EBX,WM_KEYUP,VK_SPACE,0
							;Invoke PostMessage,hEditor,WM_KEYDOWN,VK_SPACE,0
							Invoke PostMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_KEYUP,VK_TAB,0
							;JMP Handled
							JMP NoDefFrameProc
						.Else
							Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXGETSEL,0, ADDR chrg
							Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXLINEFROMCHAR,0, chrg.cpMin
							PUSH EAX
							Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_EXLINEFROMCHAR,0,chrg.cpMax
							POP ECX
							.If EAX==ECX;chrg.cpMax		;i.e. selection includes only one line
								Invoke PostMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_KEYUP,VK_TAB,0
								JMP NoDefFrameProc
							.EndIf
						.EndIf
					.EndIf
					Invoke IndentComment,CHILDWINDOWDATA.hEditor[EBX],VK_TAB,TRUE
					Handled:
				.ElseIf EAX == IDM_FORMAT_OUTDENT
					Invoke IndentComment,CHILDWINDOWDATA.hEditor[EBX],VK_TAB,FALSE
				.ElseIf EAX == IDM_FORMAT_COMMENT
					Invoke IndentComment,CHILDWINDOWDATA.hEditor[EBX],';',TRUE
				.ElseIf EAX == IDM_FORMAT_UNCOMMENT
					Invoke IndentComment,CHILDWINDOWDATA.hEditor[EBX],';',FALSE
				.ElseIf EAX == IDM_CONVERTTOUPPERCASE
					Invoke ChangeCase,hActiveChild,0
				.ElseIf EAX == IDM_CONVERTTOLOWERCASE
					Invoke ChangeCase,hActiveChild,1
				.ElseIf EAX == IDM_TOGGLECASE
					Invoke ChangeCase,hActiveChild,2
				.ElseIf EAX==IDM_MAKEACTIVERELEASEVERSION         
					.If ActiveBuild==1
						Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVERELEASEVERSION,MF_CHECKED
						Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVEDEBUGVERSION,MF_UNCHECKED
						MOV ActiveBuild,0
						MOV ProjectModified,TRUE
					.EndIf
				.ElseIf EAX==IDM_MAKEACTIVEDEBUGVERSION
					.If ActiveBuild==0
						Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVERELEASEVERSION,MF_UNCHECKED
						Invoke CheckMenuItem,WinAsmHandles.PopUpMenus.hMakeMenu,IDM_MAKEACTIVEDEBUGVERSION,MF_CHECKED
						MOV ActiveBuild,1
						MOV ProjectModified,TRUE
					.EndIf
				.ElseIf (EAX==IDM_MAKE_COMPILERESOURCE) || (EAX==IDM_MAKE_RCTOOBJ) || (EAX==IDM_MAKE_ASSEMBLE)
					MOV EBX, EAX
					.If AutoSave
						Invoke SaveWAP,FALSE,TRUE,Offset szSaveProjectAsDialogTitle
					.EndIf
					MOV NrOfErrors,0
					Invoke EnumProjectItems, Offset ClearBuggyBookmarks
					
					Invoke OutputMake,EBX,TRUE
					
					Invoke MakeFinished
				.ElseIf EAX==IDM_MAKE_LINK
					MOV EBX, EAX
					.If AutoSave
						Invoke SaveWAP,FALSE,TRUE,Offset szSaveProjectAsDialogTitle
					.EndIf
					MOV NrOfErrors,0
					Invoke EnumProjectItems, Offset ClearBuggyBookmarks
					Invoke OutputMake,EBX,TRUE
					Invoke MakeFinished
					.If AutoClean
						Invoke DeleteObjReslstExpFiles
					.EndIf
					
				.ElseIf EAX==IDM_MAKE_CLEAN
					Invoke DeleteObjReslstExpFiles
					
				.ElseIf EAX==IDM_MAKE_GO
					Invoke SetFocus,hEditor
					.If AutoSave
						Invoke SaveWAP,FALSE,TRUE,Offset szSaveProjectAsDialogTitle
					.EndIf
					MOV NrOfErrors,0
					Invoke EnumProjectItems, Offset ClearBuggyBookmarks
						
					Invoke GetFirstNextChild, hResourceFilesItem,TVGN_CHILD
					PUSH EAX
					.If EAX
						Invoke OutputMake,IDM_MAKE_COMPILERESOURCE,TRUE
						.If RCToObj[0]!=0
							Invoke OutputMake,IDM_MAKE_RCTOOBJ,FALSE
						.EndIf
					.EndIf
					
					POP EBX
					.If EBX==0
						Invoke OutputMake,IDM_MAKE_ASSEMBLE,TRUE
					.Else
						Invoke OutputMake,IDM_MAKE_ASSEMBLE,FALSE
					.EndIf
					
					.If NrOfErrors==0
						Invoke OutputMake,IDM_MAKE_LINK,FALSE
					.EndIf
					
					Invoke MakeFinished					
					
					.If NrOfErrors==0
						.If ProjectType==0 || ProjectType==2 || ProjectType==4 || ProjectType==6
							.If LaunchExeOnGoAll
								Invoke SendMessage,hWnd,WM_COMMAND,IDM_MAKE_EXECUTE,0
							.EndIf
						.EndIf
						
						.If AutoIncFileVersion && hVersionInfosParentItem	;This checks that we are in Visual Mode and that there is Version Info
							Invoke GetWindowLong,hRCEditorWindow,0
							.If [EAX].CHILDWINDOWDATA.dwTypeOfFile==3	;i.e. RC File is part of the currently opened project
								MOV tvi._mask,TVIF_PARAM
								Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_CHILD,hVersionInfosParentItem
								@@:
								.If EAX
									;EAX is the Version Info hItem
									MOV EBX,EAX
									MOV tvi.hItem,EBX
									Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
									MOV EDI,tvi.lParam; is the Version Info Memory
									
									.If [EDI].VERSIONMEM.Value==1	;this is only taken into account be windows
										MOV Buffer[0],0
										LEA ESI,Buffer
										INC [EDI].VERSIONMEM.fv[12];[EDI].VERSIONMEM.Value
										Invoke BinToDec,[EDI].VERSIONMEM.fv[0],ESI
										Invoke lstrcat,ESI,Offset szDot
										Invoke lstrlen,ESI
										ADD EAX,ESI
										Invoke BinToDec,[EDI].VERSIONMEM.fv[4],EAX
										Invoke lstrcat,ESI,Offset szDot
										Invoke lstrlen,ESI
										ADD EAX,ESI
										Invoke BinToDec,[EDI].VERSIONMEM.fv[8],EAX
										Invoke lstrcat,ESI,Offset szDot
										Invoke lstrlen,ESI
										ADD EAX,ESI
										Invoke BinToDec,[EDI].VERSIONMEM.fv[12],EAX
										LEA EDI,[EDI+SizeOf VERSIONMEM]
										.While [EDI].VERSIONITEM.szName
											Invoke lstrcmpi,Offset szFileVersion,ADDR [EDI].VERSIONITEM.szName
											.If EAX==0	;i.e. found
												Invoke lstrcpy,ADDR [EDI].VERSIONITEM.szValue,ESI
												Invoke SetRCModified,TRUE
												JMP Done
											.EndIf
											LEA EDI,[EDI+SizeOf VERSIONITEM]
										.EndW
										Done:
									.Else
										Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_NEXT,EBX
										JMP @B
									.EndIf
								.EndIf
							.EndIf
							
						.EndIf
						
					.EndIf
					
					.If AutoClean
						Invoke DeleteObjReslstExpFiles
					.EndIf
					
				.ElseIf EAX==IDM_MAKE_STOP
					Invoke TerminateProcess,proc_info.hProcess, 0
					;All the rest are handled in ExecuteThread procedure
					
				.ElseIf EAX==IDM_MAKE_EXECUTE
					Invoke Execute
					
				.ElseIf EAX==IDM_MAKE_DEBUG
					.If NrOfErrors==0
						PUSH ESI
						;-----
						.If ActiveBuild==0	;i.e. Release build
							MOV EDI,Offset szReleaseCommandLine
						.Else
							MOV EDI,Offset szDebugCommandLine
						.EndIf
						
						MOV ESI,Offset tmpBuffer
						MOV EBX,ESI
						.If DebugUseQuotes
							Invoke lstrcpy,ESI,Offset szQuote
							INC EBX
						.EndIf
						
						Invoke GetProjectBinName,EBX,Offset szExtExe
						.If ProjectType==6	;i.e. It is a DOS Project
							Invoke GetFileAttributes,EBX
							.If EAX==0FFFFFFFFh	;e.g. when exe name does not exist
								;probably this is com
								Invoke GetProjectBinName,EBX,Offset szExtCom
							.EndIf
						.EndIf
						
						.If DebugUseQuotes
							Invoke lstrcat,ESI,Offset szQuote
						.EndIf
						.If BYTE PTR [EDI]	;i.e. if there is command line
							Invoke lstrcat,ESI,Offset szSpc
							;Invoke lstrcat,ESI,Offset szSlash	;"\" otherwise following quote will not be passed
							;Invoke lstrcat,ESI,Offset szQuote
							
							Invoke lstrcat,ESI,EDI
							
							;Invoke lstrcat,ESI,Offset szSlash	;"\"	;<-------otherwise following quote will not be passed
							;Invoke lstrcat,ESI,Offset szQuote
						.EndIf
						
						Invoke SetCurrentDirectory,Offset ProjectPath
						Invoke ShellExecute,NULL,Offset szopen,Offset ExternalDebugger,ESI,NULL,SW_SHOWDEFAULT
						
						.If EAX<=32
							CALL ExecutionFailed
						.EndIf
						POP ESI
					.EndIf
					
				.ElseIf EAX==IDM_TOOLS_LINENUMBERFONT
					;.If hFind == 0
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
						Invoke SelectLineNrFont
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind, TRUE
					;.EndIf
					Invoke SetFocus,hEditor
				.ElseIf EAX==IDM_TOOLS_CODEEDITORFONT
					;.If hFind == 0
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
						
					Invoke SelectEditorFont
						
					Invoke EnableAllDockWindows,TRUE
					Invoke EnableWindow, hFind, TRUE
					

					;.EndIf
					Invoke SetFocus,hEditor
				.ElseIf EAX==IDM_TOOLS_OPTIONS
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					Invoke DialogBoxParam, hUILib, IDD_OPTIONS, hWnd, Offset OptionsDlgProc, FALSE
					Invoke EnableWindow, hFind,TRUE
					Invoke EnableAllDockWindows,TRUE
					
				.ElseIf EAX==IDM_TOOLS_TOOLSMANAGER
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					Invoke DialogBoxParam,hUILib,IDD_DLGOPTMNU,hWnd,Offset ManagerProc,1
					Invoke EnableWindow, hFind,TRUE
					Invoke EnableAllDockWindows,TRUE
					
				.ElseIf EAX>=IDM_DIALOG_SHOWHIDEGRID && EAX<=IDM_DIALOG_CONTROLSMANAGER;IDM_DIALOG_REDO
					;Includes IDM_DIALOG_CUT, IDM_DIALOG_COPY, IDM_DIALOG_PASTE, IDM_DIALOG_DELETE, IDM_DIALOG_STYLE, IDM_DIALOG_EXSTYLE, IDM_DIALOG_DIALOGFONT, IDM_DIALOG_SENDTOBACK, IDM_DIALOG_BRINGONTOP, IDM_DIALOG_TESTDIALOG, IDM_DIALOG_UNDO, IDM_DIALOG_REDO
					MOV EBX,EAX
					.If EAX==IDM_DIALOG_SHOWHIDEGRID
						Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SHOWHIDEGRID,0
						XOR EAX,TBSTATE_CHECKED
						Invoke SendMessage,hRCOptionsToolBar,TB_SETSTATE,IDM_DIALOG_SHOWHIDEGRID,EAX
					.ElseIf EAX==IDM_DIALOG_SNAPTOGRID
						Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
						XOR EAX,TBSTATE_CHECKED
						Invoke SendMessage,hRCOptionsToolBar,TB_SETSTATE,IDM_DIALOG_SNAPTOGRID,EAX
					.EndIf
					Invoke SendMessage,hRCOptions,WM_COMMAND,EBX,0
				.ElseIf EAX==IDM_RESOURCES_DEFINITIONSMANAGER
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					Invoke DialogBoxParam,hUILib,220,hWnd,Offset DefinitionsDlgProc,1
					Invoke EnableWindow, hFind,TRUE
					Invoke EnableAllDockWindows,TRUE
				.ElseIf EAX==IDM_ADDINS_ADDINSMANAGER
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					Invoke DialogBoxParam,hUILib,IDD_ADDINSMANAGER,hWnd,Offset AddInsManagerProc,1
					Invoke EnableWindow, hFind,TRUE
					Invoke EnableAllDockWindows,TRUE
					
				.ElseIf EAX>30000 && EAX<30021
					SUB EAX,30000
					LEA ECX,szCounter
					Invoke BinToDec,EAX,ECX
					Invoke GetPrivateProfileString, Offset szTOOLS, ADDR szCounter, ADDR szNULL, ADDR Buffer, 288, Offset IniFileName
					LEA EDI,Buffer
					.If EAX!=0
						.While BYTE PTR [EDI]!=0
							.If BYTE PTR [EDI]==","
								INC EDI
								.Break
							.EndIf
							INC EDI
						.EndW
						.If BYTE PTR [EDI]!=0
							Invoke DoEvents
							;Invoke WinExec,EDI,SW_SHOWDEFAULT
							Invoke ShellExecute,hWnd, NULL,EDI,NULL,NULL,SW_SHOWDEFAULT
						.Else
							XOR EAX,EAX
						.EndIf
					.EndIf
					.If EAX<=32	;Execution failed
						Invoke MessageBox,WinAsmHandles.hMain,Offset szExecutionError, Offset szAppName,MB_OK+MB_TASKMODAL
					.EndIf
				.ElseIf EAX == IDM_WINDOW_NEXT
					Invoke SendMessage, hClient, WM_MDINEXT, 0, TRUE
				.ElseIf EAX == IDM_WINDOW_PREVIOUS
					Invoke SendMessage, hClient,WM_MDINEXT, 0, FALSE
				.ElseIf EAX == IDM_WINDOW_CASCADE
					Invoke SendMessage, hClient,WM_MDICASCADE,0,0
				.ElseIf EAX == IDM_WINDOW_TILEVERTICALLY
					Invoke SendMessage, hClient, WM_MDITILE, MDITILE_VERTICAL,0
				.ElseIf EAX == IDM_WINDOW_TILEHORIZONTALLY
					Invoke SendMessage, hClient, WM_MDITILE, MDITILE_HORIZONTAL,0
				.ElseIf EAX == IDM_WINDOW_CLOSE
					Invoke SendMessage, hClient, WM_MDIGETACTIVE, NULL, NULL
					Invoke SendMessage,EAX,WM_CLOSE,0,0
				.ElseIf EAX == IDM_WINDOW_CLOSEALL
					Invoke LockWindowUpdate,hClient
					Invoke DisableAll
					Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET,NULL;hParentItem
					Invoke SetFocus,WinAsmHandles.hMain
					Invoke EnumProjectItems,Offset HideMDIChild
					Invoke EnumOpenedExternalFiles,Offset HideMDIChild
					
					.If AutoToolAndOptions
						Invoke ShowWindow,hToolBox,SW_HIDE
						Invoke ShowWindow,hRCOptions,SW_HIDE
					.EndIf
					Invoke EnableAllButtonsOnToolBox,FALSE
					Invoke EnableAllButtonsOnRCOptions,FALSE
					Invoke LockWindowUpdate,0
				.ElseIf EAX >50000 && EAX<=ExternalFilesMenuID;Opened External Files
					;&& EAX<=ExternalFilesMenuID is of Vital importance otherwise crashh!
					Invoke GetMenuItemData,WinAsmHandles.PopUpMenus.hWindowMenu,EAX,FALSE
					Invoke SetWindowPos,EAX, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
					
				.ElseIf EAX >30100 && EAX<=MaxInterfacePackMenuID	;Interface packs
					PUSH EAX
					LEA EBX,Buffer
					Invoke lstrcpy,EBX,Offset szAppFilePath
					Invoke lstrcat,EBX,Offset szUI
					Invoke lstrcat,EBX,Offset szSlash
					POP EAX
					Invoke GetMenuItemData,WinAsmHandles.hMenu,EAX,MF_BYCOMMAND
					Invoke lstrcpy,Offset szInterfacePack,EAX
					Invoke WritePrivateProfileString,Offset szGENERAL,Offset szUI,Offset szInterfacePack,Offset IniFileName
					Invoke lstrcat,EBX,Offset szInterfacePack
					
					MOV EDI,hUILib
					Invoke LoadLibrary,EBX
					.If EAX
						MOV hUILib,EAX
						Invoke LoadUI
						
						;Not necessary ????????
						.If hFind
							Invoke SendMessage,hFind,WM_CLOSE,NULL,NULL
						.EndIf
						
						Invoke FreeLibrary,EDI
						Invoke RefreshMenuItems
						Invoke RefreshTheRest
						Invoke DrawMenuBar,WinAsmHandles.hMain
					.EndIf
					
				.ElseIf EAX == IDM_HELP_HELPKEY
					Invoke SendMessage,hEditor,CHM_GETWORD,SizeOf Buffer,ADDR Buffer
					Invoke WinHelp,WinAsmHandles.hMain, Offset HelpFileName,HELP_KEY, ADDR Buffer
				.ElseIf EAX == IDM_HELP_HELPCONTENTS
					Invoke WinHelp,WinAsmHandles.hMain, Offset HelpFileName,HELP_CONTENTS, ADDR Buffer
				.ElseIf EAX == IDM_HELPONTHEWEB
					Invoke ShellExecute,NULL,Offset szopen,Offset szSiteURL,NULL,NULL,SW_SHOWDEFAULT
				.ElseIf EAX == IDM_HELP_WINASMHELP
					Invoke lstrcpy,ADDR Buffer,Offset szAppFilePath
					Invoke lstrcat,ADDR Buffer,Offset szWinAsmHelpFileAndPath	;"Help\WinAsm.chm"
					;Invoke HtmlHelp, NULL,ADDR Buffer ,HH_DISPLAY_TOPIC,NULL
					Invoke ShellExecute,NULL,Offset szopen,ADDR Buffer,NULL,NULL,SW_SHOWDEFAULT
					
				.ElseIf EAX == IDM_HELP_ABOUT
					Invoke EnableAllDockWindows,FALSE
					Invoke EnableWindow, hFind, FALSE
					Invoke DialogBoxParam, hInstance, IDD_SPLASHABOUT, hWnd, Offset AboutDialogProc, 0
					Invoke EnableWindow, hFind, TRUE
					Invoke EnableAllDockWindows,TRUE
				.ElseIf EAX==IDM_COPYSELECTION
					Invoke SendMessage,hOut,WM_COPY,0,0
				.ElseIf EAX==IDM_COPYALLTEXT
					Invoke SetToClipboard
				.ElseIf EAX==IDM_SAVEOUTTEXT
					;Check it
					.If ProjectPath[0]!=0	;i.e. This is a saved project
						Invoke lstrcpy,ADDR Buffer,Offset ProjectPath
						Invoke lstrcat,ADDR Buffer,CTEXT("OutText.txt")
						Invoke SaveOutText,ADDR Buffer
					.EndIf
				.EndIf
			.EndIf
			Invoke SendCallBackToAllAddIns,pAddInsFrameProcedures,hWnd,WAE_COMMANDFINISHED,wParam,lParam
		.ElseIf uMsg == WM_NOTIFY
			MOV EDI, lParam
			MOV EAX, [EDI].NM_LISTVIEW.hdr.hwndFrom
			.If EAX==hListProcedures
				MOV EAX, [EDI].NMHDR.code
				.If EAX == LVN_KEYDOWN
					.If [EDI].NMLVKEYDOWN.wVKey==VK_SPACE || [EDI].NMLVKEYDOWN.wVKey==VK_RETURN || [EDI].NMLVKEYDOWN.wVKey==VK_TAB
						Invoke SendMessage,hEditor,CHM_GETWORD,2,ADDR Buffer;<-------We need only to check if the first byte =0
						;PrintString Buffer
						.If Buffer[0]!=0
							Invoke DeleteProcedureName
						.EndIf
						Invoke InsertProcedureFromList
					.ElseIf [EDI].NMLVKEYDOWN.wVKey==VK_ESCAPE
						Invoke ShowWindow,hListProcedures,SW_HIDE
					.EndIf
				.ElseIf EAX == NM_DBLCLK
					Invoke SendMessage,hEditor,CHM_GETWORD,2,ADDR Buffer
					.If Buffer[0]!=0
						Invoke DeleteProcedureName
					.EndIf
					Invoke InsertProcedureFromList
				.ElseIf EAX==NM_KILLFOCUS
					Invoke ShowWindow,hListProcedures,SW_HIDE
				.EndIf
			.ElseIf EAX==hListStructures || EAX==hListConstants || EAX==hListStructureMembers || EAX==hListVariables || EAX==hListIncludes
				MOV EBX,EAX
				MOV EAX, [EDI].NMHDR.code
				.If EAX==LVN_KEYDOWN
					.If [EDI].NMLVKEYDOWN.wVKey==VK_SPACE || [EDI].NMLVKEYDOWN.wVKey==VK_RETURN || [EDI].NMLVKEYDOWN.wVKey==VK_TAB
						Invoke InsertFromList,EBX
					.ElseIf [EDI].NMLVKEYDOWN.wVKey==VK_ESCAPE
						Invoke ShowWindow,EBX,SW_HIDE
					.EndIf
				.ElseIf EAX==NM_DBLCLK
					Invoke InsertFromList,EBX
				.ElseIf EAX==NM_KILLFOCUS
					Invoke ShowWindow,EBX,SW_HIDE
				.EndIf
			.EndIf
			
			MOV EBX,lParam
			MOV EAX, [EBX].NMHDR.hwndFrom
			.If EAX == WinAsmHandles.hRebar
				.If [EBX].NMHDR.code==RBN_HEIGHTCHANGE 	;For when a band in the rebar is moved up or down
					Invoke ClientResize
					XOR EAX,EAX
					JMP NoDefFrameProc
				.EndIf
			.Else;If EAX == hMainTB || EAX == hMakeTB || EAX==hEditTB
				.If DWORD PTR [EBX+8] == TTN_NEEDTEXT
					MOV EAX,DWORD PTR [EBX+4]
					.If EAX==IDM_NEWPROJECT
						MOV DWORD PTR [EBX+12],Offset szTipNewProject
					.ElseIf EAX==IDM_OPENPROJECT
						MOV DWORD PTR [EBX+12],Offset szTipOpenProject
					.ElseIf EAX==IDM_OPENFILES
						MOV DWORD PTR [EBX+12],Offset szTipOpenFiles
					.ElseIf EAX==IDM_PROJECT_ADDEXISTINGFILE
						MOV DWORD PTR [EBX+12],Offset szTipAddFiles
					.ElseIf EAX==IDM_SAVEFILE
						MOV DWORD PTR [EBX+12],Offset szTipSaveFile
					.ElseIf EAX==IDM_SAVEPROJECT
						MOV DWORD PTR [EBX+12],Offset szTipSaveProject
					.ElseIf EAX==IDM_EDIT_CUT
						MOV DWORD PTR [EBX+12],Offset szTipCut
					.ElseIf EAX==IDM_EDIT_COPY
						MOV DWORD PTR [EBX+12],Offset szTipCopy
					.ElseIf EAX==IDM_EDIT_PASTE
						MOV DWORD PTR [EBX+12],Offset szTipPaste
					.ElseIf EAX==IDM_EDIT_UNDO
						MOV DWORD PTR [EBX+12],Offset szTipUndo
					.ElseIf EAX==IDM_EDIT_REDO
						MOV DWORD PTR [EBX+12],Offset szTipRedo
					.ElseIf EAX==IDM_VIEW_PROJECTEXPLORER
						MOV DWORD PTR [EBX+12],Offset szTipShowHideExplorer
					.ElseIf EAX==IDM_RESOURCES_VISUALMODE
						MOV DWORD PTR [EBX+12],Offset szTipVisualMode						
					.ElseIf EAX==IDM_EDIT_FIND
						MOV DWORD PTR [EBX+12],Offset szTipFind
					.ElseIf EAX==IDM_EDIT_REPLACE
						MOV DWORD PTR [EBX+12],Offset szTipReplace						
					.ElseIf EAX==IDM_FORMAT_INDENT
						MOV DWORD PTR [EBX+12],Offset szTipIncreaseIndent
					.ElseIf EAX==IDM_FORMAT_OUTDENT
						MOV DWORD PTR [EBX+12],Offset szTipDecreaseIndent
					.ElseIf EAX==IDM_FORMAT_COMMENT
						MOV DWORD PTR [EBX+12],Offset szTipCommentBlock
					.ElseIf EAX==IDM_FORMAT_UNCOMMENT
						MOV DWORD PTR [EBX+12],Offset szTipUncommentBlock
					.ElseIf EAX==IDM_EDIT_TOGGLEBM
						MOV DWORD PTR [EBX+12],Offset szTipToggleBookmark
					.ElseIf EAX==IDM_EDIT_NEXTBM
						MOV DWORD PTR [EBX+12],Offset szTipNextBookmark
					.ElseIf EAX==IDM_EDIT_PREVBM
						MOV DWORD PTR [EBX+12],Offset szTipPreviousBookmark
					.ElseIf EAX==IDM_EDIT_CLEARBM
						MOV DWORD PTR [EBX+12],Offset szTipClearAllBookmarks
					.ElseIf EAX==IDM_MAKE_ASSEMBLE
						MOV DWORD PTR [EBX+12],Offset szTipAssemble
					.ElseIf EAX==IDM_MAKE_LINK
						MOV DWORD PTR [EBX+12],Offset szTipLink
					.ElseIf EAX== IDM_MAKE_GO
						MOV DWORD PTR [EBX+12],Offset szTipGoAll
					.ElseIf EAX==IDM_MAKE_EXECUTE
						MOV DWORD PTR [EBX+12],Offset szTipExecute
					.ElseIf EAX==IDM_MAKE_STOP
						MOV DWORD PTR [EBX+12],Offset szTipStop
					.EndIf
				.ElseIf DWORD PTR [EBX+8] == TBN_DROPDOWN
					Invoke HandleDropDownButton,lParam
					MOV EAX,TBDDRET_DEFAULT
					JMP NoDefFrameProc
				.EndIf
			.EndIf
		.ElseIf uMsg == WM_SIZE
			.If wParam==SIZE_MINIMIZED && OnMinimizeToSysTray
				MOV note.cbSize,SizeOf NOTIFYICONDATA
				PUSH hWnd
				POP note.hwnd
				MOV note.uID,IDI_TRAY
				MOV note.uFlags,NIF_ICON+NIF_MESSAGE+NIF_TIP
				MOV note.uCallbackMessage,WM_SHELLNOTIFY
				M2M note.hIcon,hMainIcon
				Invoke lstrcpy,ADDR note.szTip,Offset szAppCaption
				Invoke ShowWindow,hWnd,SW_HIDE
				Invoke Shell_NotifyIcon,NIM_ADD,ADDR note
			.ElseIf wParam!=SIZE_MINIMIZED	;Because Dockrightwidth and dockleftwidth will be set to zero if I do not check this!
				Invoke ClientResize
				
				;Believe it or not it avoids a problem with rebar height when main window is restored if App starts minimized
				Invoke ClientResize
			.EndIf
			XOR EAX,EAX
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WM_SHELLNOTIFY
			.If wParam==IDI_TRAY
				.If lParam==WM_RBUTTONDOWN
					Invoke GetCursorPos,ADDR pt
					Invoke SetForegroundWindow,hWnd
					Invoke TrackPopupMenu,hTrayPopupMenu,TPM_RIGHTALIGN,pt.x,pt.y,NULL,hWnd,NULL
				.ElseIf lParam==WM_LBUTTONDBLCLK
					Invoke SetWindowPos,hWnd,HWND_TOP,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE+SWP_SHOWWINDOW
					Invoke SendMessage,hWnd,WM_COMMAND,IDM_RESTORE,0
				;.Else
				.EndIf
			.EndIf
			XOR EAX,EAX
			JMP NoDefFrameProc
		.ElseIf uMsg == WM_QUERYENDSESSION 
			Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 1
			.If !EAX	;EAX==False if Cancel was selected
				;XOR EAX,EAX	;it is already FALSE
				RET
			.EndIf
			CALL GoCloseWinAsm
			Invoke DestroyWindow,hWnd
			MOV EAX,TRUE
			RET
		.ElseIf uMsg == WM_CLOSE
			;MOV fClosingApp,TRUE
			;1=Check wap, all project files and all external files
			Invoke DialogBoxParam, hUILib, 217, hWnd, Offset AskToSaveFilesDialogProc, 1
			.If !EAX	;EAX==False if Cancel was selected
				;XOR EAX,EAX	;it is already FALSE
				RET
			.EndIf
			CALL GoCloseWinAsm
		.ElseIf uMsg == WM_DESTROY
			Invoke ImageList_Destroy,hImlNormal
			Invoke ImageList_Destroy,hImlMonoChrome
			Invoke DestroyIcon,hMainIcon
			Invoke DeleteObject,hFont
			Invoke DeleteObject,hIFont
			Invoke DeleteObject,hLnrFont
			Invoke DeleteObject,hFontTahoma
			Invoke PostQuitMessage,NULL
			JMP NoDefFrameProc
		.ElseIf uMsg==WM_ERASEBKGND
			;Return 0
			XOR EAX,EAX
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WM_TIMER
			.If wParam==200
				Invoke GetKeyState,VK_CAPITAL
				AND EAX,1
				.If EAX==1
					Invoke SendMessage,hStatus,SB_SETTEXT,0,CTEXT("CAPS")
					;Caps Lock is on
				.Else
					;Caps Lock is off
					Invoke SendMessage,hStatus,SB_SETTEXT,0,Offset szNULL
				.EndIf
				
				Invoke GetKeyState,VK_NUMLOCK
				AND EAX,1
				.If EAX==1
					;Num Lock is on
					Invoke SendMessage,hStatus,SB_SETTEXT,1,CTEXT("NUM")
				.Else
					;Num Lock is off
					Invoke SendMessage,hStatus,SB_SETTEXT,1,Offset szNULL
				.EndIf
				
				Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
				.If EAX
					PUSH ESI
					MOV ESI,EAX
					
					Invoke IsWindowVisible,ESI
					.If EAX
						Invoke GetWindowLong,ESI,0
						MOV EBX,EAX
						.If CHILDWINDOWDATA.dwTypeOfFile[EBX]==3 || CHILDWINDOWDATA.dwTypeOfFile[EBX]==103
							Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_RESOURCES_VISUALMODE,TBSTATE_ENABLED
						.Else
							Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_RESOURCES_VISUALMODE,0
						.EndIf
						
						.If ESI!=hRCEditorWindow
							Invoke GetWindowLong,[EBX].CHILDWINDOWDATA.hEditor,0
							.If [EAX].EDIT.fOvr
								Invoke SendMessage,hStatus,SB_SETTEXT,2,CTEXT("OVR")
							.Else
								Invoke SendMessage,hStatus,SB_SETTEXT,2,Offset szNULL
							.EndIf
						.Else
							
							Invoke SendMessage,hStatus,SB_SETTEXT,2,Offset szNULL
							Invoke SendMessage,hStatus,SB_SETTEXT,3,Offset szNULL
						.EndIf
					.Else
						Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_RESOURCES_VISUALMODE,0
						Invoke SendMessage,hStatus,SB_SETTEXT,2,Offset szNULL
						Invoke SendMessage,hStatus,SB_SETTEXT,3,Offset szNULL
					.EndIf
					POP ESI
				.Else
					Invoke SendMessage,hStatus,SB_SETTEXT,2,Offset szNULL
					Invoke SendMessage,hStatus,SB_SETTEXT,3,Offset szNULL
					Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_RESOURCES_VISUALMODE,0
				.EndIf
				
			.ElseIf wParam==400
				Invoke GetExitCodeProcess, proc_info.hProcess, ADDR lParam
				.If EAX==0 || lParam!=STILL_ACTIVE
					Invoke KillTimer,hWnd,400
					
					Invoke EnableMenuItem,hMenu,IDM_NEWPROJECT,MF_ENABLED
					Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_NEWPROJECT,TBSTATE_ENABLED
					
					Invoke EnableMenuItem,hMenu,IDM_OPENPROJECT,MF_ENABLED
					Invoke SendMessage,hMainTB,TB_SETSTATE,IDM_OPENPROJECT,TBSTATE_ENABLED
					
					Invoke EnableMenuItem,hMenu,IDM_CLOSEPROJECT,MF_ENABLED
					
					Invoke EnableMenuItem,hMenu,IDM_MAKE_EXECUTE,MF_ENABLED
					Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_EXECUTE,TBSTATE_ENABLED
					Invoke EnableMenuItem,hMenu,IDM_MAKE_STOP,MF_GRAYED
					Invoke SendMessage,hMakeTB,TB_SETSTATE,IDM_MAKE_STOP,0
					
					Invoke CloseHandle,proc_info.hThread
					Invoke CloseHandle,proc_info.hProcess
					
					MOV proc_info.hProcess,0
					
				.EndIf
			.EndIf
			
		.ElseIf uMsg==WAM_GETNEXTMENUID
			;wParam=0,lParam=0
			MOV EAX,NextMenuID
			INC NextMenuID
			;RET
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WAM_GETCURRENTPROJECTINFO
			;wParam=LPCURRENTPROJECTINFO, lParam=0
			MOV EDI,wParam
			MOV EAX, Offset FullProjectName
			MOV [EDI].CURRENTPROJECTINFO.pszFullProjectName,EAX
			
			MOV EAX, Offset ProjectTitle
			MOV [EDI].CURRENTPROJECTINFO.pszProjectTitle,EAX
			
			MOV EAX, Offset ProjectModified
			MOV [EDI].CURRENTPROJECTINFO.pbModified,EAX
			
			MOV EAX, Offset CompileRC
			MOV [EDI].CURRENTPROJECTINFO.pszCompileRCCommand,EAX
			
			MOV EAX, Offset RCToObj
			MOV [EDI].CURRENTPROJECTINFO.pszResToObjCommand,EAX
			
			MOV EAX, Offset szReleaseAssemble
			MOV [EDI].CURRENTPROJECTINFO.pszReleaseAssembleCommand,EAX
			
			MOV EAX, Offset szReleaseLink
			MOV [EDI].CURRENTPROJECTINFO.pszReleaseLinkCommand,EAX
			
			MOV EAX, Offset szReleaseOutCommand
			MOV [EDI].CURRENTPROJECTINFO.pszReleaseOUTCommand,EAX
			
			MOV EAX,Offset ProjectType
			MOV [EDI].CURRENTPROJECTINFO.pProjectType,EAX
			
			MOV EAX, Offset szDebugAssemble
			MOV [EDI].CURRENTPROJECTINFO.pszDebugAssembleCommand,EAX
			
			MOV EAX, Offset szDebugLink
			MOV [EDI].CURRENTPROJECTINFO.pszDebugLinkCommand,EAX
			
			MOV EAX, Offset szDebugOutCommand
			MOV [EDI].CURRENTPROJECTINFO.pszDebugOUTCommand,EAX
			
			
			MOV EAX, Offset szReleaseCommandLine
			MOV [EDI].CURRENTPROJECTINFO.pszReleaseCommandLine,EAX
			
			MOV EAX, Offset szDebugCommandLine
			MOV [EDI].CURRENTPROJECTINFO.pszDebugCommandLine,EAX
			
			.If FullProjectName(0)!=0
				MOV EAX,TRUE
			.Else
				XOR EAX,EAX
			.EndIf
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WAM_ENUMCURRENTPROJECTFILES
			;wParam=EnumProc, lParam=0
			Invoke EnumProjectItemsExtended,wParam,lParam
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WAM_ADDOPENEXISTINGFILE
			Invoke AddOpenExistingFile,wParam,lParam
			
		.ElseIf uMsg==WAM_OPENPROJECT
			;WAM_OPENPROJECT	hMain,
			;					wParam=lpProjectFileName
			;					lParam=reserved
			Invoke OpenWAP,wParam
			;Just set the InitDir
			;Invoke GetFilePath,wParam,ADDR Buffer
			;Invoke WritePrivateProfileString, Offset szGENERAL, Offset szInitDir,ADDR Buffer, Offset IniFileName
			
		.ElseIf uMsg==WAM_ENUMEXTERNALFILES
			;wParam=EnumProc, lParam=0
			Invoke EnumOpenedExternalFilesExtended,wParam,lParam
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WAM_ENABLEALLDOCKWINDOWS
			;-WAM_ENABLEALLDOCKWINDOWS	EQU WM_USER+106		hWnd   = hMain
			;												wParam = 0
			;												lParam = TRUE/FALSE
			Invoke EnableAllDockWindows,lParam
			
		.ElseIf uMsg==WAM_CREATEDOCKINGWINDOW
			Invoke CreateDockingWindow,wParam,lParam
			PUSH EAX
			Invoke ClientResize
			POP EAX
			;RET
			JMP NoDefFrameProc
			
		.ElseIf uMsg==WM_MENUCHAR
			HIWORD wParam
			.If EAX==MF_POPUP
				;lParam==Menu handle
				Invoke GetMenuItemCount,lParam
				MOV EBX,EAX
				XOR EDI,EDI
				
				MOV ECX,wParam;=ASCII pressed.
				AND ECX,0FFFFh
				
				
				MOV Buffer[0],CL
				
				MOV szCounter[0],CL
				MOV szCounter[1],0
				Invoke IsCharUpper,ECX
				.If !EAX
					Invoke CharUpper,ADDR szCounter
				.Else
					Invoke CharLower,ADDR szCounter
				.EndIf
				
				.While EDI<EBX
					Invoke IsMenuItemMnemonic,lParam,EDI,Buffer[0],szCounter[0];AL
					.If EAX!=-1
						MOV ECX,EAX
						MOV EAX,2
						SHL EAX,16
						MOV AX,CX
						JMP NoDefFrameProc
						.Break
					.EndIf
					INC EDI
				.EndW
			.EndIf
		.ElseIf uMsg==WM_GETMINMAXINFO
			MOV EAX,lParam
			MOV [EAX].MINMAXINFO.ptMinTrackSize.x,220
			MOV [EAX].MINMAXINFO.ptMinTrackSize.y,220
			XOR EAX,EAX
			JMP NoDefFrameProc
		.EndIf
	.EndIf
	
	Invoke DefFrameProc, hWnd, hClient, uMsg, wParam, lParam
	NoDefFrameProc:
	RET

	;-----------------------------------------------------------------------
	AddNewFile:
	MOV ProjectModified,TRUE
	NewFile:
	
	MOV ECX,MDIS_ALLCHILDSTYLES or WS_CLIPCHILDREN
	OR ECX,OpenChildStyle
	Invoke CreateWindowEx,WS_EX_MDICHILD ,ADDR szChildClass,ADDR FileName,ECX,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,hClient,NULL,hInstance,EDI
	MOV hActiveChild,EAX
	PUSH EAX	
	Invoke GetWindowLong,EAX,0
	MOV EBX,EAX
	POP EAX
	.If EDI==1 || EDI==2 || EDI==101 || EDI==102
		Invoke UpdateProcCombo,CHILDWINDOWDATA.hEditor[EBX],CHILDWINDOWDATA.hCombo[EBX]
	.ElseIf EDI==3 || EDI==103
		.If !hRCEditorWindow
			MOV hRCEditorWindow,EAX
			Invoke GetResources
			.If AutoToolAndOptions
				Invoke ShowWindow,hToolBox,SW_SHOW
				Invoke ShowWindow,hRCOptions,SW_SHOW
			.EndIf
		.EndIf
	.EndIf
	Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_SETMODIFY,TRUE,0
	MOV [EBX].CHILDWINDOWDATA.fNotOnDisk,TRUE
	
	Invoke SetFocus,hActiveChild
	RETN

	;-----------------------------------------------------------------------
	GoCloseWinAsm:
	;-------------
	.If proc_info.hProcess
		Invoke CloseHandle,proc_info.hThread
		Invoke CloseHandle,proc_info.hProcess
	.EndIf

	Invoke LockWindowUpdate,WinAsmHandles.hMain

	.If lpFind
		Invoke HeapFree,hMainHeap,0,lpFind
	.EndIf
	
	.If lpInterfacePacks
		Invoke HeapFree,hMainHeap,0,lpInterfacePacks
	.EndIf

	Invoke GetMainWindowPlacement
	Invoke ClearProject
	
	;------------------------------------------------
	;LOOOK! This is AFTER ClearProject
	Invoke HeapFree,hMainHeap,0,lpCustomControls
	;------------------------------------------------
	
	
	Invoke HeapFree,hMainHeap,0,lpTrigger

	
	Invoke DeleteObject,hHSplit

	;-----------------------------------------------------------------------------------------------------------------------
	;VERY VERY VERY IMPORTANT-->The Add-Ins will stop recieving any messages and thus no crashes!!!!
	MOV pAddInsFrameProcedures,0
	MOV pAddInsProjectExplorerProcedures,0

	MOV pAddInsOutWindowProcedures,0
	MOV pAddInsChildWindowProcedures,0
	;-----------------------------------------------------------------------------------------------------------------------

	Invoke EnumDllsInFolder,Offset UnloadAddIn,Offset szInAddInsAllDLLs
	;-----------------------------------------------------------------------------------------------------------------------
	
	;Didn't I heap free pAddInsFrameProcedures, pAddInsProjectExplorerProcedures, pAddInsOutWindowProcedures, pAddInsChildWindowProcedures ???????
	
	Invoke SaveDockingWindowProperties, WinAsmHandles.hProjExplorer, ADDR PEDockData, Offset szPROJECTEXPLORER
	Invoke SaveDockingWindowProperties, WinAsmHandles.hOutParent, ADDR POutDockData, Offset szOUTPARENT
	Invoke SaveDockingWindowProperties, hToolBox, ADDR TBDockData, Offset szTOOLBOX
	Invoke SaveDockingWindowProperties, hRCOptions, ADDR RCOptionsDockData, Offset szRCOPTIONS

	LEA EDI,Buffer

	Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SHOWHIDEGRID,0
	AND EAX,TBSTATE_CHECKED	
	.If EAX
		LEA EDX,szOne
	.Else
		LEA EDX,szZero
	.EndIf
	Invoke WritePrivateProfileString, Offset szSETTINGSONEXIT, Offset szShowGridKey,EDX, Offset IniFileName
	
	Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
	AND EAX,TBSTATE_CHECKED	
	.If EAX
		LEA EDX,szOne
	.Else
		LEA EDX,szZero
	.EndIf
	Invoke WritePrivateProfileString, Offset szSETTINGSONEXIT, Offset szSnapToGridKey,EDX, Offset IniFileName
	
	Invoke BinToDec,GridSize,EDI
	Invoke WritePrivateProfileString, Offset szSETTINGSONEXIT, Offset szGridSizeKey,EDI, Offset IniFileName

	;-----------------------------------------------------------------------------------------------------------------------
	MOV EAX,hActiveDock
	.If EAX==WinAsmHandles.hProjExplorer
		LEA EDX,szOne
	.Else
		LEA EDX,szTwo
	.EndIf
	Invoke WritePrivateProfileString, Offset szSETTINGSONEXIT, Offset szActiveDock,EDX, Offset IniFileName

	;-----------------------------------------------------------------------------------------------------------------------
	Invoke LockWindowUpdate,0
	RETN
	
	;-----------------------------------------------------------------------------------------------------------------------
	ExecutionFailed:
	Invoke MessageBox,WinAsmHandles.hMain,Offset szExecutionError, Offset szAppName,MB_OK+MB_TASKMODAL
	RETN
MainWndProc EndP

End Start
