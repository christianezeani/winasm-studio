.CODE
IsMenuItemMnemonic Proc hCurrentMenu:HMENU, wID:DWORD, CharPressed:BYTE, CharToggled:BYTE
	PUSH ESI
	PUSH EBX
	
	Invoke GetMenuItemData,hCurrentMenu,wID,TRUE
	MOV EBX,EAX
	Invoke lstrlen,EBX	;mii.dwItemData
	.If EAX				;i.e not a separator
		MOV ESI,EAX
		ADD ESI,EBX
		
		@@:
		.If BYTE PTR [EBX]=="&"
			INC EBX
			.If EBX<ESI
				MOV CL,BYTE PTR [EBX]
				
				.If CL==CharPressed || CL==CharToggled
					MOV EAX,wID
					JMP Done
				.EndIf
			.EndIf	
		.Else
			INC EBX
			.If EBX<ESI
				JMP @B
			.EndIf
		.EndIf
	.EndIf
	
	MOV EAX,-1
	JMP Done


	Done:
	POP EBX
	POP ESI
	RET
IsMenuItemMnemonic EndP

CreateOwnerDrawnMenus Proc Uses EBX EDI
Local mii	:MENUITEMINFO

	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hFileMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_NEWPROJECT,Offset szNewProject
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_OPENPROJECT,Offset szOpenProject
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_CLOSEPROJECT,Offset szCloseProject
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_SAVEPROJECT,Offset szSaveProject
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_SAVEPROJECTAS,Offset szSaveProjectAs
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	;--------------------------------------------------------------------------------
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hNewFileMenu,EAX
	;Let's speed up things!
	MOV EDI,EAX
	Invoke AppendMenu, EDI,MF_OWNERDRAW,IDM_NEWASMFILE,Offset szNewASMFile
	Invoke AppendMenu, EDI,MF_OWNERDRAW,IDM_NEWINCFILE,Offset szNewINCFileMItem
	Invoke AppendMenu, EDI,MF_OWNERDRAW,IDM_NEWRCFILE,Offset szNewRCFileMItem
	Invoke AppendMenu, EDI,MF_OWNERDRAW,IDM_NEWOTHERFILE,Offset szNewOtherFileMItem
	;--------------------------------------------------------------------------------
	Invoke AppendMenu, EBX,MF_ENABLED or MF_POPUP or MF_OWNERDRAW,EDI, Offset szNewFileMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_OPENFILES,Offset szOpenFiles
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_SAVEFILE,Offset szSaveFile
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_SAVEFILEAS,Offset szSaveFileAs
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PRINT,Offset szPrint
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_EXIT,Offset szExit

       
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hEditMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_UNDO,Offset szUndo
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_REDO,Offset szRedo
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_CUT,Offset szCut
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_COPY,Offset szCopyT
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_PASTE,Offset szPaste
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_DELETE,Offset szDelete
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_SELECTALL,Offset szSelectAll
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_FIND,Offset szFind
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_FINDNEXT,Offset szFindNext
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_FINDPREVIOUS,Offset szFindPrevious
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_SMARTFIND,Offset szSmartFind
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_REPLACE,Offset szReplaceMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_GOTOLINE,Offset szGotoLine	
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_HIDELINES,Offset szHideLines
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_GOTOBLOCK,Offset szGotoBlock
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_GOBACK,Offset szGoBack
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_TOGGLEBM,Offset szToggleBookmark
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_NEXTBM,Offset szNextBookmark
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_PREVBM,Offset szPreviousBookmark
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_EDIT_CLEARBM,Offset szClearAllBookmarks


	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hViewMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_VIEW_PROJECTEXPLORER,Offset szProjectExplorerMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_VIEW_OUTPUT,Offset szOutputWindow
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_VIEW_TOOLBOX,Offset szToolBoxMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_VIEW_DIALOG,Offset szDialogMItem


	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hProjectMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_RENAMEPROJECT,Offset szRenameProjectMItem
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_ADDASM,Offset szAddNewAsm
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_ADDINC,Offset szAddNewInc
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_ADDRC,Offset szAddNewRc
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_ADDOTHER,Offset szAddNewOther
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_ADDEXISTINGFILE,Offset szAddFiles
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_BINARYFILES,Offset szBinaryFiles
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_SETASMODULE,Offset szModule
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_RENAMEFILE,Offset szRenameFile
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_REMOVEFILE,Offset szRemoveFile
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_RUNBATCH,Offset szRunBatchFile
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
;	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_VISUALMODE,Offset szVisualMode
;	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_USEEXTRCEDITOR,Offset szUseExternalEditor
;	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_PROJECT_PROPERTIES,Offset szProperties

	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hFormatMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_FORMAT_INDENT,Offset szIndent
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_FORMAT_OUTDENT,Offset szOutdent
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_FORMAT_COMMENT,Offset szComment
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_FORMAT_UNCOMMENT,Offset szUncomment
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hConvertMenu,EAX
	;Let's speed up things!
	MOV EDI,EAX
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_CONVERTTOUPPERCASE,Offset szToUpperCase
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_CONVERTTOLOWERCASE,Offset szToLowerCase
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_TOGGLECASE,Offset szToggleCase
	Invoke AppendMenu, EBX,MF_POPUP or MF_OWNERDRAW,EDI, Offset szConvert




	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hResourcesMenu,EAX
	;Let's speed up things!
	MOV EDI,EAX
	
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hDialogMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_SHOWHIDEGRID, Offset szShowHideGrid
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_SNAPTOGRID,Offset szSnapToGrid
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	;--------------------------------------------------------------------------------
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hControlsMenu,EAX
	Invoke AppendMenu, EAX,MF_OWNERDRAW,IDM_DIALOG_CONTROLSMANAGER,Offset szControlsManager
	;--------------------------------------------------------------------------------
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_DIALOG_CONTROLSMANAGER,Offset szControlsManager
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_CUT,Offset szCut
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_COPY,Offset szCopyT
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_PASTE,Offset szPaste
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_STYLE,Offset szStyleMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_EXSTYLE,Offset szExStyleMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_DIALOGFONT,Offset szFontMItem
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_DELETE,Offset szDelete
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_SENDTOBACK,Offset szSendToBack
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_BRINGONTOP,Offset szBringToFront
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_DIALOG_TESTDIALOG,Offset szTestDialog

	Invoke AppendMenu, EDI,MF_POPUP or MF_OWNERDRAW, EBX, Offset szDialogMenu
	Invoke AppendMenu, EDI,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_RESOURCES_VISUALMODE,Offset szVisualMode
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_RESOURCES_USEEXTRCEDITOR,Offset szUseExternalEditor
	Invoke AppendMenu, EDI,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_RESOURCES_DEFINITIONSMANAGER,Offset szDefinitions





	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hMakeMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hSetActiveBuildMenu,EAX
	;Let's speed up things!
	MOV EDI,EAX
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_MAKEACTIVERELEASEVERSION,Offset szReleaseVersion
	Invoke AppendMenu, EDI,MF_OWNERDRAW or MF_GRAYED,IDM_MAKEACTIVEDEBUGVERSION,Offset szDebugVersion
	Invoke AppendMenu, EBX,MF_POPUP or MF_OWNERDRAW, EDI, Offset szSetActiveBuild
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_CLEAN,Offset szClean
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_COMPILERESOURCE,Offset szCompileRCMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_RCTOOBJ,Offset szRCToObjMItem
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_ASSEMBLE,Offset szAssembleMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_LINK,Offset szLinkMItem
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_GO,Offset szGoAll
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_EXECUTE,Offset szExecute
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_MAKE_DEBUG,Offset szDebug

	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hToolsMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	

	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_TOOLS_CODEEDITORFONT,Offset szCodeEditorFont
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_TOOLS_LINENUMBERFONT,Offset szLineNumberFont
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_TOOLS_OPTIONS,Offset szOptions
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hInterfacePacks,EAX
	Invoke AppendMenu, EBX,MF_POPUP or MF_OWNERDRAW, EAX, Offset szInterfacePacks
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_TOOLS_TOOLSMANAGER,Offset szToolsManagerMItem
	
	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hAddInsMenu,EAX
	Invoke AppendMenu, EAX,MF_OWNERDRAW,IDM_ADDINS_ADDINSMANAGER, Offset szAddInsManager

	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hWindowMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_WINDOW_CLOSE,Offset szClose
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_WINDOW_CLOSEALL,Offset szCloseAll
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_WINDOW_NEXT,Offset szNext
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_WINDOW_PREVIOUS,Offset szPrevious
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_WINDOW_TILEHORIZONTALLY,Offset szTileHorizontally
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_WINDOW_TILEVERTICALLY,Offset szTileVertically
	Invoke AppendMenu, EBX,MF_OWNERDRAW or MF_GRAYED,IDM_WINDOW_CASCADE,Offset szCascade



	Invoke CreatePopupMenu
	MOV WinAsmHandles.PopUpMenus.hHelpMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_HELP_WINASMHELP,Offset szWinAsmHelp
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_HELP_HELPCONTENTS,Offset szOtherHelp
	Invoke AppendMenu, EBX,MF_SEPARATOR,NULL,NULL
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_HELPONTHEWEB,Offset szOnTheWeb
	Invoke AppendMenu, EBX,MF_OWNERDRAW,IDM_HELP_ABOUT,Offset szAboutWinAsm


	Invoke CreateMenu
	MOV hMenu,EAX
	MOV WinAsmHandles.hMenu,EAX
	;Let's speed up things!
	MOV EBX,EAX
	
	MOV mii.cbSize,SizeOf MENUITEMINFO
	MOV mii.fMask,MIIM_TYPE Or MIIM_SUBMENU or MIIM_ID Or MIIM_STATE Or MIIM_DATA	
	MOV mii.fType,MF_STRING
	MOV mii.fState,MF_ENABLED
	MOV mii.cch,31


	MOV ECX,WinAsmHandles.PopUpMenus.hHelpMenu
	MOV EDI,IDM_HELP
	MOV EDX,Offset szHelpMenu
	CALL InsertMI

	MOV ECX,WinAsmHandles.PopUpMenus.hWindowMenu
	MOV EDI,IDM_WINDOW
	MOV EDX,Offset szWindowMenu
	CALL InsertMI

	MOV ECX,WinAsmHandles.PopUpMenus.hAddInsMenu
	MOV EDI,IDM_ADDINS
	MOV EDX,Offset szAddInsMenu
	CALL InsertMI
	
	MOV ECX,WinAsmHandles.PopUpMenus.hToolsMenu
	MOV EDI,IDM_TOOLS
	MOV EDX,Offset szToolsMenu
	CALL InsertMI

	MOV ECX,WinAsmHandles.PopUpMenus.hMakeMenu
	MOV EDI,IDM_MAKE
	MOV EDX,Offset szMakeMenu
	CALL InsertMI

	MOV ECX,WinAsmHandles.PopUpMenus.hResourcesMenu
	MOV EDI,IDM_RESOURCES
	MOV EDX,Offset szResourcesMenu
	CALL InsertMI

	MOV ECX,WinAsmHandles.PopUpMenus.hFormatMenu
	MOV EDI,IDM_FORMAT
	MOV EDX,Offset szFormatMenu
	CALL InsertMI

	MOV ECX,WinAsmHandles.PopUpMenus.hProjectMenu
	MOV EDI,IDM_PROJECT
	MOV EDX,Offset szProjectMenu
	CALL InsertMI
	
	
	MOV ECX,WinAsmHandles.PopUpMenus.hViewMenu
	MOV EDI,IDM_VIEW
	MOV EDX,Offset szViewMenu
	CALL InsertMI


	MOV ECX,WinAsmHandles.PopUpMenus.hEditMenu
	MOV EDI,IDM_EDIT
	MOV EDX,Offset szEditMenu
	CALL InsertMI

	MOV ECX,WinAsmHandles.PopUpMenus.hFileMenu
	MOV EDI,IDM_FILE
	MOV EDX,Offset szFileMenu
	CALL InsertMI
	
	
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hFileMenu,Offset szFileMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hEditMenu,Offset szEditMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hViewMenu, Offset szViewMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hProjectMenu, Offset szProjectMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hFormatMenu, Offset szFormatMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hResourcesMenu, Offset szResourcesMenu;szDialogMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hMakeMenu, Offset szMakeMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hToolsMenu, Offset szToolsMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hAddInsMenu, Offset szAddInsMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hWindowMenu, Offset szWindowMenu
	;Invoke AppendMenu, EBX,MF_OWNERDRAW OR MF_ENABLED or MF_POPUP,WinAsmHandles.PopUpMenus.hHelpMenu, Offset szHelpMenu
	
	Invoke SetMenu,WinAsmHandles.hMain,EBX
	
	Invoke DrawMenuBar,WinAsmHandles.hMain
	RET
	
	
	InsertMI:
	MOV mii.hSubMenu,ECX
	MOV mii.wID,EDI
	MOV mii.dwTypeData,EDX
	Invoke InsertMenuItem,EBX,0,TRUE,ADDR mii
	RETN


CreateOwnerDrawnMenus EndP

MeasureItem Proc Uses EBX EDI ESI lParam:LPARAM
Local hDC			:HDC
Local TextSize		:_SIZE
Local ncm			:NONCLIENTMETRICS
Local tWt			:DWORD
Local Buffer[256]	:BYTE

	Invoke GetDC,WinAsmHandles.hMain
	MOV hDC,EAX
	
	MOV ncm.cbSize,SizeOf NONCLIENTMETRICS
	Invoke SystemParametersInfo,SPI_GETNONCLIENTMETRICS,SizeOf NONCLIENTMETRICS,ADDR ncm,0
	Invoke CreateFontIndirect,ADDR ncm.lfMenuFont
	PUSH EAX
	
	Invoke SelectObject,hDC,EAX
	PUSH EAX
	
	MOV EDI, lParam
	ASSUME EDI:PTR MEASUREITEMSTRUCT
	
	MOV EAX,[EDI].itemID
	.If [EDI].itemID < 40001
		MOV ESI,[EDI].itemData
	 .ElseIf [EDI].itemID>40000 && [EDI].itemID < 50001	;Add-Ins
		MOV EBX,[EDI].itemData
		Invoke GetObjectType,[EBX].ADDINMENUITEM.hBitmapNormal
		.If EAX==OBJ_BITMAP
			MOV ESI,[EBX].ADDINMENUITEM.lpCaption
		.Else
			MOV ESI,[EDI].itemData
		.EndIf
		
	.Else	;For Opened External Files itemData is the handle to the MDI child window
		Invoke GetWindowLong,[EDI].itemData,0

		; "Instant New Project" winds up here, and the LEA below incidentaly sets
		; ESI to 0x10 because GetWindowLong() returns 0. Therefore, ensure
		; that EAX is non-zero before overwriting ESI with nonsense. 
		.If EAX != 0
			LEA ESI,CHILDWINDOWDATA.szFileName[EAX]
		.endif
	.EndIf

	XOR EBX,EBX
	Invoke lstrcpy,ADDR Buffer,ESI
	LEA EAX,Buffer
	.While BYTE PTR [EAX]!=0
		.If BYTE PTR [EAX]==VK_TAB
			MOV BYTE PTR [EAX],0
			MOV EBX,EAX
			.Break
		.EndIf
		INC EAX
	.EndW
	
	.If EBX
		Invoke lstrlen,ADDR Buffer
		MOV ECX,EAX
		Invoke GetTextExtentPoint32,hDC,ADDR Buffer,ECX,ADDR TextSize
		MOV EAX,TextSize.x
		ADD EAX,42
		;NEG EAX	;-for right align
		MOV tWt,EAX
	.EndIf
	
	Invoke lstrlen,ESI
	MOV ECX,EAX
	Invoke GetTabbedTextExtent,hDC,ESI,ECX,1,ADDR tWt
	MOV ECX,EAX
	AND EAX,0FFFFh	;i.e. loword
	SHR ECX,16		;i.e. hiword
	
	.If ECX<20
		MOV ECX,20
	.EndIf
	ADD EAX,22

	MOV [EDI].itemHeight,ECX
	MOV [EDI].itemWidth,EAX
	
	ASSUME EDI:NOTHING
	
	POP EAX
	Invoke SelectObject,hDC,EAX
	POP EAX
	Invoke DeleteObject,EAX
	Invoke ReleaseDC,WinAsmHandles.hMain,hDC
	RET
MeasureItem EndP

DrawItem Proc Uses EBX ESI EDI lParam:LPARAM
Local BitmapPos			:DWORD
Local tWt				:DWORD
Local Buffer[MAX_PATH]	:BYTE
Local ncm				:NONCLIENTMETRICS

	MOV EDI, lParam
	ASSUME EDI:PTR DRAWITEMSTRUCT
	;Prepare Menu DC
	Invoke SetBkMode, [EDI].hdc, TRANSPARENT
	
	MOV ncm.cbSize,SizeOf NONCLIENTMETRICS
	Invoke SystemParametersInfo,SPI_GETNONCLIENTMETRICS,SizeOf NONCLIENTMETRICS,ADDR ncm,0
	Invoke CreateFontIndirect,ADDR ncm.lfMenuFont
	PUSH EAX

	Invoke SelectObject,[EDI].hdc,EAX
	PUSH EAX

 	MOV ESI,[EDI].itemData
	.If [EDI].itemID==IDM_NEWPROJECT
		MOV BitmapPos,0
	.ElseIf [EDI].itemID==IDM_OPENPROJECT
		MOV BitmapPos,1
	.ElseIf [EDI].itemID==IDM_OPENFILES
		MOV BitmapPos,42
	.ElseIf [EDI].itemID==IDM_SAVEFILE
		MOV BitmapPos,2
	.ElseIf [EDI].itemID==IDM_SAVEPROJECT
		MOV BitmapPos,3
	.ElseIf [EDI].itemID==IDM_PRINT
		MOV BitmapPos,43
	.ElseIf [EDI].itemID==IDM_EDIT_CUT || [EDI].itemID==IDM_DIALOG_CUT
		MOV BitmapPos,4
	.ElseIf [EDI].itemID==IDM_EDIT_COPY || [EDI].itemID==IDM_DIALOG_COPY
		MOV BitmapPos,5
	.ElseIf [EDI].itemID==IDM_EDIT_PASTE || [EDI].itemID==IDM_DIALOG_PASTE
		MOV BitmapPos,6
	.ElseIf [EDI].itemID==IDM_EDIT_UNDO; || [EDI].itemID==IDM_DIALOG_UNDO
		MOV BitmapPos,7
	.ElseIf [EDI].itemID==IDM_EDIT_REDO; || [EDI].itemID==IDM_DIALOG_REDO
		MOV BitmapPos,8
	.ElseIf [EDI].itemID==IDM_EDIT_FIND
		MOV BitmapPos,10
	.ElseIf [EDI].itemID==IDM_EDIT_REPLACE
		MOV BitmapPos,11
	.ElseIf [EDI].itemID==IDM_EDIT_GOTOBLOCK
		MOV BitmapPos,48
	.ElseIf [EDI].itemID==IDM_EDIT_GOBACK
		MOV BitmapPos,49
	.ElseIf [EDI].itemID==IDM_FORMAT_INDENT
		MOV BitmapPos,12
	.ElseIf [EDI].itemID==IDM_FORMAT_OUTDENT
		MOV BitmapPos,13
	.ElseIf [EDI].itemID==IDM_FORMAT_COMMENT
		MOV BitmapPos,14
	.ElseIf [EDI].itemID==IDM_FORMAT_UNCOMMENT
		MOV BitmapPos,15
	.ElseIf [EDI].itemID==IDM_EDIT_TOGGLEBM
		MOV BitmapPos,16
	.ElseIf [EDI].itemID==IDM_EDIT_NEXTBM
		MOV BitmapPos,17
	.ElseIf [EDI].itemID==IDM_EDIT_PREVBM
		MOV BitmapPos,18
	.ElseIf [EDI].itemID==IDM_EDIT_CLEARBM
		MOV BitmapPos,19
	.ElseIf [EDI].itemID==IDM_MAKE_ASSEMBLE
		MOV BitmapPos,20
	.ElseIf [EDI].itemID==IDM_MAKE_LINK
		MOV BitmapPos,21
	.ElseIf [EDI].itemID==IDM_MAKE_GO
		MOV BitmapPos,22
	.ElseIf [EDI].itemID==IDM_MAKE_EXECUTE
		MOV BitmapPos,23
	.ElseIf [EDI].itemID==IDM_ADDINS_ADDINSMANAGER
		MOV BitmapPos,25
	.ElseIf [EDI].itemID==IDM_PROJECT_ADDASM || [EDI].itemID==IDM_NEWASMFILE
		MOV BitmapPos,26
	.ElseIf [EDI].itemID==IDM_PROJECT_ADDINC || [EDI].itemID==IDM_NEWINCFILE
		MOV BitmapPos,27
	.ElseIf [EDI].itemID==IDM_PROJECT_ADDRC || [EDI].itemID==IDM_NEWRCFILE
		MOV BitmapPos,28
	.ElseIf [EDI].itemID==IDM_PROJECT_ADDOTHER || [EDI].itemID==IDM_NEWOTHERFILE
		MOV BitmapPos,38
	.ElseIf [EDI].itemID==IDM_HELP_WINASMHELP
		MOV BitmapPos,29
	.ElseIf [EDI].itemID==IDM_TOOLS_CODEEDITORFONT || [EDI].itemID==IDM_DIALOG_DIALOGFONT
		MOV BitmapPos,30
	.ElseIf [EDI].itemID==IDM_TOOLS_TOOLSMANAGER
		MOV BitmapPos,44
	.ElseIf [EDI].itemID==IDM_PROJECT_PROPERTIES
		MOV BitmapPos,31
	.ElseIf [EDI].itemID==IDM_MAKE_COMPILERESOURCE
		MOV BitmapPos,32
	.ElseIf [EDI].itemID==IDM_WINDOW_TILEHORIZONTALLY
		MOV BitmapPos,33
	.ElseIf [EDI].itemID==IDM_WINDOW_TILEVERTICALLY
		MOV BitmapPos,34
	.ElseIf [EDI].itemID==IDM_WINDOW_CASCADE
		MOV BitmapPos,35
	.ElseIf [EDI].itemID==IDM_WINDOW_CLOSE
		MOV BitmapPos,36
	.ElseIf [EDI].itemID==IDM_HELP_ABOUT
		MOV BitmapPos,41
	.ElseIf [EDI].itemID==IDM_CONVERTTOUPPERCASE
		MOV BitmapPos,53
	.ElseIf [EDI].itemID==IDM_CONVERTTOLOWERCASE
		MOV BitmapPos,54
	.ElseIf [EDI].itemID==IDM_PROJECT_ADDEXISTINGFILE
		MOV BitmapPos,55
	.ElseIf [EDI].itemID==IDM_DIALOG_CONTROLSMANAGER
		MOV BitmapPos,56
	.ElseIf [EDI].itemID>40000 && [EDI].itemID < 50001	;Add-Ins
		MOV EBX,[EDI].itemData
		.If EBX
			Invoke GetObjectType,[EBX].ADDINMENUITEM.hBitmapNormal
			.If EAX==OBJ_BITMAP
				MOV ESI,[EBX].ADDINMENUITEM.lpCaption
				MOV BitmapPos,-2
			.Else
				.If [EDI].itemState & ODS_CHECKED
					MOV BitmapPos,24
				.Else
					MOV BitmapPos,-1
				.EndIf
			.EndIf
		.Else
			JMP Ex
		.EndIf
		
	.ElseIf [EDI].itemID>50000 ;For Opened External Files itemData is the handle to the MDI child window
		MOV EAX,[EDI].hwndItem	;hwndItem: For menus, this member identifies the menu containing the item.
		.If EAX==WinAsmHandles.PopUpMenus.hWindowMenu	;otherwise Crash due to New file PopUp in File Menu or Set Active Make in Make menu 
			Invoke GetWindowLong,[EDI].itemData,0
			MOV EBX,EAX
			LEA ESI,[EBX].CHILDWINDOWDATA.szFileName
			.If [EBX].CHILDWINDOWDATA.dwTypeOfFile==101
				MOV BitmapPos,26
			.ElseIf [EBX].CHILDWINDOWDATA.dwTypeOfFile==102
				MOV BitmapPos,27
			.ElseIf [EBX].CHILDWINDOWDATA.dwTypeOfFile==103
				MOV BitmapPos,28
			.ElseIf [EBX].CHILDWINDOWDATA.dwTypeOfFile==104
				MOV BitmapPos,37
			.ElseIf [EBX].CHILDWINDOWDATA.dwTypeOfFile==105
				MOV BitmapPos,39
			.ElseIf [EBX].CHILDWINDOWDATA.dwTypeOfFile==106
				MOV BitmapPos,40
			.Else;If [EBX].CHILDWINDOWDATA.dwTypeOfFile==107
				MOV BitmapPos,38
			.EndIf
		.Else
			MOV BitmapPos,-1	;Basically for New File PopUp in File Menu
		.EndIf
	.Else
		.If [EDI].itemState & ODS_CHECKED
			MOV BitmapPos,24
		.Else
			MOV BitmapPos,-1
		.EndIf
	.EndIf
	
	
	
	;*******************************************************
	; ******************* DRAW BACKGROUND *******************
	; *******************************************************
	.If [EDI].itemState & ODS_SELECTED
		.If [EDI].itemState & ODS_GRAYED
			Invoke GetSysColor, COLOR_GRAYTEXT
			Invoke SetTextColor,[EDI].hdc, EAX
		.Else
			Invoke GetSysColor, COLOR_HIGHLIGHTTEXT
			Invoke SetTextColor,[EDI].hdc, EAX
		.EndIf
		.If BitmapPos!=-1 &&  hImlNormal	;In case any Add-In sets hImlNormal=0
			MOV EAX, [EDI].rcItem.left
			ADD EAX, 20
			PUSH [EDI].rcItem.right
			MOV [EDI].rcItem.right,EAX
			
			Invoke DrawFrameControl,[EDI].hdc,ADDR [EDI].rcItem,DFC_BUTTON,DFCS_BUTTONPUSH OR DFCS_FLAT
			
			POP [EDI].rcItem.right
			
			PUSH [EDI].rcItem.left
			ADD [EDI].rcItem.left,22
		.Else
			PUSH [EDI].rcItem.left
			INC [EDI].rcItem.left
		.EndIf
		
		MOV EDX,DC_ACTIVE OR  DC_TEXT or DC_SMALLCAP 
		.If GradientMenuItems
			OR EDX,DC_GRADIENT 
		.EndIf
		
		;hClient because there is no caption text
		Invoke DrawCaption,hClient,[EDI].hdc,ADDR [EDI].rcItem,EDX
		POP [EDI].rcItem.left
	.Else
		.If [EDI].itemState & ODS_GRAYED
			Invoke GetSysColor, COLOR_GRAYTEXT
			Invoke SetTextColor,[EDI].hdc, EAX
		.Else
			Invoke GetSysColor, COLOR_MENUTEXT
			Invoke SetTextColor,[EDI].hdc, EAX
		.EndIf
		Invoke GetSysColorBrush, COLOR_MENU
		Invoke SelectObject, [EDI].hdc, EAX
		MOV EAX, [EDI].rcItem.bottom
		SUB EAX, [EDI].rcItem.top
		MOV EDX,[EDI].rcItem.right
		SUB EDX,[EDI].rcItem.left
		Invoke PatBlt, [EDI].hdc, [EDI].rcItem.left, [EDI].rcItem.top,EDX, EAX, PATCOPY
	.EndIf
	
	; ****************************************************
	; ******************* DRAW CONTENT *******************
	; ****************************************************

	ADD [EDI].rcItem.left,2
	ADD [EDI].rcItem.top,2
	
	.If BitmapPos!=-1
		.If [EDI].itemState & ODS_GRAYED
			.If hImlMonoChrome
				.If BitmapPos==-2		;i.e. bitmap provided by the Add-In
					MOV EBX,[EDI].itemData
					Invoke GetObjectType,[EBX].ADDINMENUITEM.hBitmapDisabled
					.If EAX==OBJ_BITMAP
						Invoke CopyImage,[EBX].ADDINMENUITEM.hBitmapDisabled,IMAGE_BITMAP,16,16,NULL
						PUSH EAX
						Invoke ImageList_AddMasked,hImlMonoChrome,EAX,0FF00FFh
						MOV BitmapPos,EAX
						POP EAX
						Invoke DeleteObject,EAX
						Invoke ImageList_Draw,hImlMonoChrome,BitmapPos,[EDI].hdc,[EDI].rcItem.left, [EDI].rcItem.top,ILD_TRANSPARENT
						Invoke ImageList_Remove,hImlMonoChrome,BitmapPos
					.EndIf
				.Else
					Invoke ImageList_Draw,hImlMonoChrome,BitmapPos,[EDI].hdc,[EDI].rcItem.left, [EDI].rcItem.top,ILD_TRANSPARENT
				.EndIf
			.EndIf
		.Else
			.If hImlNormal
				.If BitmapPos==-2		;i.e. bitmap provided by the Add-In
					MOV EAX,[EDI].itemData
					Invoke CopyImage,[EAX].ADDINMENUITEM.hBitmapNormal,IMAGE_BITMAP,16,16,NULL
					PUSH EAX
					Invoke ImageList_AddMasked,hImlNormal,EAX,0FF00FFh
					MOV BitmapPos,EAX
					POP EAX
					Invoke DeleteObject,EAX
					Invoke ImageList_Draw,hImlNormal,BitmapPos,[EDI].hdc,[EDI].rcItem.left, [EDI].rcItem.top,ILD_TRANSPARENT
					Invoke ImageList_Remove,hImlNormal,BitmapPos
				.Else
					Invoke ImageList_Draw,hImlNormal,BitmapPos,[EDI].hdc,[EDI].rcItem.left, [EDI].rcItem.top,ILD_TRANSPARENT
				.EndIf
			.EndIf
		.EndIf
	.EndIf
	

	Invoke lstrlen, ESI
	MOV [EDI].itemAction, EAX
	
	XOR EBX,EBX
	Invoke lstrcpy,ADDR Buffer,ESI
	LEA EAX,Buffer
	.While BYTE PTR [EAX]!=0
		.If BYTE PTR [EAX]==VK_TAB
			MOV BYTE PTR [EAX],0
			MOV EBX,EAX
			.Break
		.EndIf
		INC EAX
	.EndW

	SUB [EDI].rcItem.top,2
	ADD [EDI].rcItem.left,26

	Invoke DrawText, [EDI].hdc,ADDR Buffer ,-1, ADDR [EDI].rcItem, DT_SINGLELINE or DT_NOCLIP or DT_VCENTER or DT_EXPANDTABS

	.If EBX
		ADD [EDI].rcItem.top,3
		MOV EAX,[EDI].rcItem.right
		SUB EAX,42
		;MOV tWt,-155;-for right align
		NEG EAX
		MOV tWt,EAX
		MOV BYTE PTR [EBX],VK_TAB
		Invoke lstrlen,EBX
		MOV [EDI].itemAction, EAX
		Invoke TabbedTextOut,[EDI].hdc,[EDI].rcItem.left,[EDI].rcItem.top,EBX,[EDI].itemAction,1,ADDR tWt,26
	.EndIf
	
	Ex:
	POP EAX
	Invoke SelectObject,[EDI].hdc,EAX
	POP EAX
	Invoke DeleteObject,EAX

	ASSUME EDI:NOTHING
	RET
DrawItem EndP
