ChildWndProc		PROTO :HWND,:UINT,:WPARAM,:LPARAM
AddToDialogTree		PROTO :DWORD,:DWORD
AddToOthersTree		PROTO :DWORD,:DWORD,:DWORD
AddDefine 			PROTO :DWORD,:DWORD,:DWORD
AddOrReplaceDefine 	PROTO :DWORD,:DWORD


Include WndStyles.inc


.CONST
tbToolBox					TBBUTTON <23, IDM_TOOLBOX_DIALOG, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <20, IDM_TOOLBOX_POINTER,TBSTATE_CHECKED,TBSTYLE_CHECK OR TBSTYLE_GROUP , 0, 0>
							TBBUTTON <19, IDM_TOOLBOX_STATIC, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP , 0, 0>
							TBBUTTON <1, IDM_TOOLBOX_EDIT, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP , 0, 0>
							TBBUTTON <2, IDM_TOOLBOX_GROUPBOX, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP , 0, 0>
							TBBUTTON <0, IDM_TOOLBOX_BUTTON, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP , 0, 0>
							TBBUTTON <3, IDM_TOOLBOX_CHECKBOX, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <4, IDM_TOOLBOX_RADIOBUTTON, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <5, IDM_TOOLBOX_COMBOBOX, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <6, IDM_TOOLBOX_LISTBOX, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <8, IDM_TOOLBOX_HSCROLL, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <7, IDM_TOOLBOX_VSCROLL, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <9, IDM_TOOLBOX_TABCONTROL, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <10, IDM_TOOLBOX_TOOLBAR, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <14, IDM_TOOLBOX_STATUSBAR, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <12, IDM_TOOLBOX_PROGRESSBAR, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							;TBBUTTON <13, IDM_TOOLBOX_HEADER, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							
							TBBUTTON <11, IDM_TOOLBOX_REBAR,0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <17, IDM_TOOLBOX_UPDOWN,0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							
							TBBUTTON <16, IDM_TOOLBOX_TREEVIEW, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <15, IDM_TOOLBOX_LISTVIEW, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <18, IDM_TOOLBOX_SLIDER, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							
							TBBUTTON <25, IDM_TOOLBOX_SHAPE,0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <24, IDM_TOOLBOX_IMAGE,0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <22, IDM_TOOLBOX_RICHEDIT,0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>
							TBBUTTON <21, IDM_TOOLBOX_USERDEFINEDCONTROL, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>


tbOptions					TBBUTTON <24, IDM_DIALOG_SHOWHIDEGRID,0,TBSTYLE_CHECK, 0, 0>
							TBBUTTON <25, IDM_DIALOG_SNAPTOGRID,0,TBSTYLE_CHECK, 0, 0>
							TBBUTTON <26, IDM_DIALOG_GRIDSIZE,0,TBSTYLE_BUTTON, 0, 0>
							
							TBBUTTON <0, IDM_DIALOG_ALIGNLEFTS,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <1, IDM_DIALOG_ALIGNCENTERS,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <19, IDM_DIALOG_ALIGNWITHDIALOGCENTER,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <2, IDM_DIALOG_ALIGNRIGHTS,0,TBSTYLE_BUTTON, 0, 0>
							
							TBBUTTON <3, IDM_DIALOG_ALIGNTOPS,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <4, IDM_DIALOG_ALIGNMIDDLES,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <20, IDM_DIALOG_ALIGNWITHDIALOGMIDDLE,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <5, IDM_DIALOG_ALIGNBOTTOMS,0,TBSTYLE_BUTTON, 0, 0>
							
							TBBUTTON <7, IDM_DIALOG_MAKESAMEWIDTH,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <8, IDM_DIALOG_MAKESAMEHEIGHT,0,TBSTYLE_BUTTON, 0, 0>			
							TBBUTTON <6, IDM_DIALOG_MAKESAMESIZE,0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <22, IDM_DIALOG_SENDTOBACK,0,TBSTYLE_BUTTON, 0, 0>			
							TBBUTTON <21, IDM_DIALOG_BRINGONTOP,0,TBSTYLE_BUTTON, 0, 0>
							;TBBUTTON <23, IDM_DIALOG_LOCKCONTROLS, TBSTATE_ENABLED,TBSTYLE_CHECK, 0, 0>


IDB_TOOLBOXBITMAPNORMAL		EQU 104
IDB_TOOLBOXBITMAPDISABLED	EQU 111

WS_ALLCHILDS				EQU WS_CHILD OR WS_VISIBLE OR WS_CLIPSIBLINGS ;OR WS_CLIPCHILDREN 

;Note:WS_VISIBLE is not needed since it is set by the resource compiler
WS_ALLCHILDSDEFAULT			EQU WS_CHILD OR WS_VISIBLE; OR WS_CLIPSIBLINGS ;OR WS_CLIPCHILDREN 

.DATA
CustomControlButton			TBBUTTON <26, 0, 0,TBSTYLE_CHECK OR TBSTYLE_GROUP, 0, 0>

;lpUndoRedoMemory			DWORD 0
;lpRedoPointer				DWORD 0
HighestWindowDialogID		DWORD 1000
szIDD_DLG					DB 'IDD_DLG',0
szIDC_STATIC				DB 'IDC_STATIC',0
szIDC_EDIT					DB 'IDC_EDIT',0
szIDC_GROUPBOX				DB 'IDC_GROUPBOX',0
szIDC_BUTTON				DB 'IDC_BUTTON',0
szIDC_CHECKBOX				DB 'IDC_CHECKBOX',0
szIDC_RADIOBUTTON			DB 'IDC_RADIOBUTTON',0
szIDC_COMBOBOX				DB 'IDC_COMBOBOX',0
szIDC_LISTBOX				DB 'IDC_LISTBOX',0
szIDC_HSCROLL				DB 'IDC_HSCROLL',0
szIDC_VSCROLL				DB 'IDC_VSCROLL',0
szIDC_TABCONTROL			DB 'IDC_TABCONTROL',0
szIDC_TOOLBAR				DB 'IDC_TOOLBAR',0
szIDC_STATUSBAR				DB 'IDC_STATUSBAR',0
szIDC_PROGRESSBAR			DB 'IDC_PROGRESSBAR',0
szIDC_REBAR					DB 'IDC_REBAR',0
szIDC_UPDOWN				DB 'IDC_UPDOWN',0
szIDC_TREEVIEW				DB 'IDC_TREEVIEW',0
szIDC_LISTVIEW				DB 'IDC_LISTVIEW',0
szIDC_SLIDER				DB 'IDC_SLIDER',0
szIDC_RICHEDIT				DB 'IDC_RICHEDIT',0
szIDC_SHAPE					DB 'IDC_SHAPE',0
szIDC_IMAGE					DB 'IDC_IMAGE',0
szIDC_USERDEFINED			DB 'IDC_USERDEFINED',0




szGeneratedBy				DB ";This Resource Script was generated by WinAsm Studio.",13,10,0

;For Toolbox
szStatic					DB "Static",0
szEdit						DB "Edit",0
szGroupBox					DB "GroupBox",0
szCheckBox					DB "CheckBox",0
szRadioButton				DB "RadioButton",0
szComboBox					DB "ComboBox",0
szListBox					DB "ListBox",0
szHScroll					DB "HScroll",0
szVScroll					DB "VScroll",0
szTabControl				DB "TabControl",0
szToolBar					DB "ToolBar",0
szStatusBar					DB "StatusBar",0
szProgressBar				DB "ProgressBar",0
szTreeView					DB "TreeView",0
szListView					DB "ListView",0
szSlider					DB "Slider",0
szUpDown					DB "UpDown",0
szShape						DB "Shape",0
szRebarTip					DB "Rebar",0
szRichEditTip				DB "RichEdit",0
szUserDefinedControl		DB "UserDefinedControl",0


szRCDlgClass				DB "RCDialog",0
szRCTestDlgClass			DB "RCTestDialog",0

GridSize					DWORD 5
ToolSelected				DWORD IDM_TOOLBOX_POINTER

szDEFINE					DB "#define",0

szelif						DB "#elif",0
szelse						DB "#else",0
szendif						DB "#endif",0
szif						DB "#if",0
szifdef						DB "#ifdef",0
szifndef					DB "#ifndef",0
szINCLUDE					DB '#include',0
szUNDEF						DB "#undef",0


szpragma					DB "#pragma",0

szTEXTINCLUDE				DB "TEXTINCLUDE",0

szSTRINGTABLE				DB 'STRINGTABLE',0
szBITMAP					DB 'BITMAP',0
szCURSOR					DB 'CURSOR',0
szICON						DB 'ICON',0
szAVI						DB 'AVI',0
szMANIFEST					DB "24",0
szRCDATA					DB "RCDATA",0
szWAVE						DB "WAVE",0
szACCELERATORS				DB 'ACCELERATORS',0
	szVIRTKEY					DB 'VIRTKEY',0
	szSHIFT						DB 'SHIFT',0
	szALT						DB 'ALT',0
	szNOINVERT					DB 'NOINVERT',0

szVERSIONINFO				DB 'VERSIONINFO',0
szDIALOGEX					DB 'DIALOGEX',0
szCHARACTERISTICS			DB 'CHARACTERISTICS',0
szVERSION					DB 'VERSION',0
szLANGUAGE					DB 'LANGUAGE',0
szCAPTION					DB 'CAPTION',0
szFONT						DB 'FONT',0
szCLASS						DB 'CLASS',0
szSTYLE						DB 'STYLE',0
szEXSTYLE					DB 'EXSTYLE',0
szBEGIN						DB 'BEGIN',0
szBEGINSHORT				DB '{',0
szPRELOAD					DB 'PRELOAD',0
szLOADONCALL				DB 'LOADONCALL',0
szFIXED						DB 'FIXED',0
szMOVEABLE					DB 'MOVEABLE',0
szDISCARDABLE				DB 'DISCARDABLE',0
szPURE						DB 'PURE',0
szIMPURE					DB 'IMPURE',0
szNOT						DB 'NOT',0

szDIALOG					DB 'DIALOG',0
szMENU						DB 'MENU',0
szMENUEX					DB 'MENUEX',0

szRichEdit					DB 'riched20.dll',0


lpIncludesMem				DWORD 0
lpResourcesMem				DWORD 0

.DATA?
HighestVersionInfoID		DWORD ?
HighestAcceleratorID		DWORD ?
hCopyMemory					DWORD ?
NrOfSelectedControls		DWORD ?

StartOfBlock				DWORD ?
fMoving						DWORD ?
fSizing						DWORD ?

xLeft						DWORD ?
xCenter						DWORD ?
xRight						DWORD ?
xTop						DWORD ?
xMiddle						DWORD ?
xBottom						DWORD ?
xWidth						DWORD ?
xHeight						DWORD ?



hRichEd						HANDLE ?
ControlRect					RECT <?>
OffsetX						DWORD ?
OffsetY						DWORD ?
hImlRCOptions				DWORD ?
hImlRCOptionsDisabled		DWORD ?

hImlRCToolBoxNormal			DWORD ?
hImlRCToolBoxDisabled		DWORD ?

lpDefinesMem				DWORD ?


ThisWord					DB 512 DUP(?)
NameBuffer					DB 512 DUP(?)

Include UndoRedo.asm
Include RCDialogs.asm
Include RCDefines.asm
Include RCIncludes.asm
Include RCResources.asm
Include RCStringTable.asm
Include RCMenus.asm
Include RCAccelerators.asm
Include RCVersionInfo.asm

.CODE
AddToDialogTree Proc lpItemText:DWORD, ItemParam:DWORD
Local tvinsert	:TV_INSERTSTRUCT
	MOV tvinsert.item.cchTextMax,256
	MOV tvinsert.hInsertAfter,TVI_ROOT
	M2M tvinsert.item.iImage,0
	M2M tvinsert.item.lParam,ItemParam
	M2M tvinsert.item.pszText,lpItemText
	MOV tvinsert.item._mask,TVIF_TEXT+TVIF_PARAM+TVIF_IMAGE
	MOV tvinsert.hParent,NULL
	Invoke SendMessage,hDialogsTree,TVM_INSERTITEM,0,ADDR tvinsert
	RET
AddToDialogTree EndP

AddToOthersTree Proc nType:DWORD, lpItemText:DWORD, ItemParam:DWORD
Local tvinsert	:TV_INSERTSTRUCT

	MOV tvinsert.item._mask,TVIF_TEXT+TVIF_PARAM
	MOV tvinsert.item.cchTextMax,256
	MOV tvinsert.hInsertAfter,TVI_LAST	

	.If !hOthersParentItem
		MOV tvinsert.hParent,TVI_ROOT
		MOV tvinsert.item.pszText,Offset szOthers
		Invoke SendMessage,hOthersTree,TVM_INSERTITEM,0,ADDR tvinsert
		MOV hOthersParentItem,EAX
		Invoke SendMessage, hOthersTree, TVM_SELECTITEM, TVGN_CARET,EAX
	.EndIf
	
	.If nType==1	;Accelerator Table
		.If !hAccelTablesParentItem
			PUSH hOthersParentItem
			POP tvinsert.hParent
			MOV tvinsert.hInsertAfter,TVI_LAST
			MOV tvinsert.item.pszText,Offset szAcceleratorTables
			Invoke SendMessage,hOthersTree,TVM_INSERTITEM,0,ADDR tvinsert
			MOV hAccelTablesParentItem,EAX
		.Else
			MOV EAX,hAccelTablesParentItem
		.EndIf
	.ElseIf nType==2	;Included Files
		MOV EAX,hOthersParentItem
	.ElseIf nType==3	;Version Info
		.If !hVersionInfosParentItem
			PUSH hOthersParentItem
			POP tvinsert.hParent
			MOV tvinsert.hInsertAfter,TVI_LAST
			MOV tvinsert.item.pszText,Offset szVersionInfo
			Invoke SendMessage,hOthersTree,TVM_INSERTITEM,0,ADDR tvinsert
			MOV hVersionInfosParentItem,EAX
		.Else
			MOV EAX,hVersionInfosParentItem
		.EndIf
	.ElseIf nType==4	;Resources
		MOV EAX,hOthersParentItem
	.ElseIf nType==5	;String Table
		MOV EAX,hOthersParentItem
	.ElseIf nType==6	;Menus
		.If !hMenusParentItem
			PUSH hOthersParentItem
			POP tvinsert.hParent
			MOV tvinsert.hInsertAfter,TVI_LAST
			MOV tvinsert.item.pszText,Offset szMenus
			Invoke SendMessage,hOthersTree,TVM_INSERTITEM,0,ADDR tvinsert
			MOV hMenusParentItem,EAX
		.Else
			MOV EAX,hMenusParentItem
		.EndIf

	.EndIf

	MOV tvinsert.hParent,EAX
	M2M tvinsert.item.lParam,ItemParam
	M2M tvinsert.item.pszText,lpItemText
	MOV tvinsert.hInsertAfter,TVI_LAST
	Invoke SendMessage,hOthersTree,TVM_INSERTITEM,0,ADDR tvinsert
	PUSH EAX
	Invoke SendMessage, hOthersTree, TVM_EXPAND, TVE_EXPAND,hOthersParentItem
	POP EAX
	RET
AddToOthersTree EndP

EnableButtonsForMultiSelectionOnRCOptions Proc fEnable:DWORD

	PUSH EBX
	MOV EBX,IDM_DIALOG_CUT
	@@:
	Invoke SendMessage,hRCOptionsToolBar,TB_ENABLEBUTTON,EBX,fEnable
	INC EBX
	.If EBX<=IDM_DIALOG_MAKESAMESIZE
		JMP @B
	.EndIf
	POP EBX
	RET
EnableButtonsForMultiSelectionOnRCOptions EndP

EnableAllButtonsOnRCOptions Proc fEnable:DWORD

	Invoke SendMessage,hRCOptionsToolBar,TB_ENABLEBUTTON,IDM_DIALOG_SHOWHIDEGRID,fEnable
	Invoke SendMessage,hRCOptionsToolBar,TB_ENABLEBUTTON,IDM_DIALOG_SNAPTOGRID,fEnable
	Invoke SendMessage,hRCOptionsToolBar,TB_ENABLEBUTTON,IDM_DIALOG_GRIDSIZE,fEnable
	
	Invoke SendMessage,hRCOptionsToolBar,TB_ENABLEBUTTON,IDM_DIALOG_SENDTOBACK,fEnable
	Invoke SendMessage,hRCOptionsToolBar,TB_ENABLEBUTTON,IDM_DIALOG_BRINGONTOP,fEnable

	Invoke EnableButtonsForMultiSelectionOnRCOptions,fEnable
	RET
EnableAllButtonsOnRCOptions EndP

;---------------------
EnableAllButtonsOnAddResourcesToolbar Proc fEnable:DWORD

	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_RCPROPERTIES_MENUS,fEnable
	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_RCPROPERTIES_INCLUDES,fEnable
	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_RCPROPERTIES_ACCELERATORS,fEnable
	
	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_RCPROPERTIES_VERSIONINFO,fEnable
	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_RCPROPERTIES_STRINGTABLE,fEnable
	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_RCPROPERTIES_RESOURCES,fEnable
	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_RCPROPERTIES_REMOVE,fEnable
	Invoke SendMessage,hRCPropertiesToolBar,TB_ENABLEBUTTON,IDM_TOOLBOX_DIALOG,fEnable

	RET
EnableAllButtonsOnAddResourcesToolbar EndP




EnableControlsOnToolBox Proc fEnable:DWORD
	PUSH EBX
	MOV EBX,IDM_TOOLBOX_POINTER
	@@:
	Invoke SendMessage,hToolBoxToolBar,TB_ENABLEBUTTON,EBX,fEnable
	INC EBX
	.If EAX
		JMP @B
	.EndIf
	POP EBX
	RET
EnableControlsOnToolBox EndP

EnableAllButtonsOnToolBox Proc fEnable:DWORD
	Invoke SendMessage,hToolBoxToolBar,TB_ENABLEBUTTON,IDM_TOOLBOX_DIALOG,fEnable
	Invoke EnableControlsOnToolBox,fEnable
	RET
EnableAllButtonsOnToolBox EndP

ScrollDialogHorizontally Proc hDialog:HWND, HPos:DWORD
Local Rect	:RECT
	
	Invoke GetWindowRect,hDialog,ADDR Rect
	Invoke GetParent,hDialog
	LEA ECX,Rect
	Invoke MapWindowPoints,NULL,EAX,ECX,2
	MOV ECX,HPos
	SUB ECX,8
	NEG ECX
	Invoke SetWindowPos,hDialog,0,ECX,Rect.top,0,0,SWP_NOSIZE OR SWP_NOOWNERZORDER OR SWP_NOZORDER
	
	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
	.If EAX	;Yes there is selection
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_PARENT,EAX
		.If !EAX	;Active is not a control-It is a dialog
			Invoke DeSelectWindow,hSelection
			MOV hSelection,EAX
			Invoke SelectWindow,hDialog,TRUE
		.EndIf
	.EndIf
	
	Invoke UpdateWindow,hRCEditorWindow
	RET
ScrollDialogHorizontally EndP

ScrollDialogVertically Proc hDialog:HWND, VPos:DWORD
Local Rect	:RECT
	
	Invoke GetWindowRect,hDialog,ADDR Rect
	Invoke GetParent,hDialog
	LEA ECX,Rect
	Invoke MapWindowPoints,NULL,EAX,ECX,2
	MOV ECX,VPos
	SUB ECX,DIALOGSYMARGIN
	NEG ECX
	Invoke SetWindowPos,hDialog,0,Rect.left,ECX,0,0,SWP_NOSIZE OR SWP_NOOWNERZORDER OR SWP_NOZORDER

	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
	.If EAX	;Yes there is selection
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_PARENT,EAX
		.If !EAX	;Active is not a control-It is a dialog
			Invoke DeSelectWindow,hSelection
			MOV hSelection,EAX
			Invoke SelectWindow,hDialog,TRUE
		.EndIf
	.EndIf

	Invoke UpdateWindow,hRCEditorWindow

	RET
ScrollDialogVertically EndP

ToolBoxProc Proc Uses EBX hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
Local Rect			:RECT
Local Buffer[256]	:BYTE
Local Pt			:POINT
	.If uMsg == WM_SIZE
		Invoke SendMessage,hWnd,WAM_GETCLIENTRECT,0,ADDR Rect
		MOV EAX,Rect.right
		SUB EAX,Rect.left
		MOV ECX,Rect.bottom
		SUB ECX,Rect.top
		Invoke MoveWindow,hToolBoxToolBar,Rect.left,Rect.top,EAX,ECX,TRUE
	.ElseIf uMsg==WM_SHOWWINDOW
		.If wParam
			Invoke CheckMenuItem,hMenu,IDM_VIEW_TOOLBOX,MF_CHECKED
		.Else
			Invoke CheckMenuItem,hMenu,IDM_VIEW_TOOLBOX,MF_UNCHECKED
		.EndIf

	.ElseIf uMsg == WM_COMMAND
		HIWORD wParam
		.If EAX == 0 || 1 ; 0 is a menu, 1 is an accelerator. Toolbar messages act like menu messages...
		
			Invoke SendMessage,hToolBoxToolBar,TB_BUTTONCOUNT,0,0
			;PrintDec EAX
			ADD EAX,IDM_TOOLBOX_DIALOG
			MOV ECX,EAX
			;IDM_TOOLBOX_DIALOG				EQU 11101
			LOWORD wParam
			.If EAX>11100 && EAX <ECX	;thanks Qvasimodo
				MOV ToolSelected,EAX
				;PrintDec EAX
				.If EAX == IDM_TOOLBOX_DIALOG
					;Create a new "Dialog"
					MOV EBX,hRCEditorWindow
					Invoke GetWindowLong,EBX,0
					.If [EAX].CHILDWINDOWDATA.dwTypeOfFile==3 || [EAX].CHILDWINDOWDATA.dwTypeOfFile==103
						.If hADialog
							Invoke ShowWindow,hADialog,SW_HIDE
						.EndIf
						Invoke SetScrollPos,hRCEditorWindow,SB_HORZ,0,TRUE
						Invoke SetScrollPos,hRCEditorWindow,SB_VERT,0,TRUE
						
						Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf DIALOGDATA
						MOV EDI,EAX
						
						;Insert a random pointer to UndoRedoMemory for testing purposes only
						;MOV [EAX].DIALOGDATA.lpUndoRedoMemory,100h
						;MOV [EAX].DIALOGDATA.lpRedoPointer,200h
						
						
						Invoke lstrcpy,ADDR [EDI].DIALOGDATA.FontName,CTEXT("MS Sans Serif")
						MOV [EDI].DIALOGDATA.FontSize,8
						
						M2M [EDI].CONTROLDATA.dux,0
						M2M [EDI].CONTROLDATA.x,0
						M2M [EDI].CONTROLDATA.duy,0
						M2M [EDI].CONTROLDATA.y,0
						MOV [EDI].CONTROLDATA.duccx,340
						MOV [EDI].CONTROLDATA.ccx,340
						MOV [EDI].CONTROLDATA.duccy,240
						MOV [EDI].CONTROLDATA.ccy,240
						
						INC HighestWindowDialogID
						;Invoke wsprintf, ADDR Buffer, Offset szDecimalTemplate,HighestWindowDialogID
						Invoke BinToDec,HighestWindowDialogID,ADDR Buffer
						
						;Invoke AddDefine,lpDefinesMem,Offset szIDC_DLG,ADDR Buffer;Offset sz1001
						
						;Invoke AddDefine,lpDefinesMem,Offset szIDC_DLG,Offset sz1001
						;Invoke AddOrReplaceDefine,Offset szIDC_DLG,Offset sz1001
						
						Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,Offset szIDD_DLG
						Invoke lstrcat,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
						
						Invoke lstrcpy,ADDR [EDI].CONTROLDATA.IDName,Offset szIDD_DLG
						Invoke lstrcat,ADDR [EDI].CONTROLDATA.IDName,ADDR Buffer
						;Invoke AddDefine,lpDefinesMem,ADDR [EDI].CONTROLDATA.IDName,ADDR Buffer;Offset sz1001
						Invoke AddOrReplaceDefine,ADDR [EDI].CONTROLDATA.IDName,ADDR Buffer
						
						M2M [EDI].CONTROLDATA.ID,HighestWindowDialogID;1001
						
						MOV [EDI].CONTROLDATA.Style,WS_BORDER OR WS_SYSMENU OR WS_THICKFRAME OR WS_DLGFRAME or WS_VISIBLE;OR WS_CLIPCHILDREN ; OR DS_MODALFRAME; OR WS_CLIPSIBLINGS 
						MOV [EDI].CONTROLDATA.ExStyle,0;Thanks soorick-was WS_EX_TOOLWINDOW before
						;MOV [EDI].CONTROLDATA.ntype,0
						
						Invoke CreateDialogFont,EDI
						Invoke ConvertToDialogUnits,EDI
						Invoke CreateDialog,EDI,EBX
						Invoke SendMessage,hDialogsTree,TVM_SELECTITEM,TVGN_CARET,[EDI].CONTROLDATA.hTreeItem
						Invoke SetProperties,EDI
						Invoke SendMessage,hADialog,WM_NCACTIVATE,1,0
						Invoke SetWindowPos,hADialog,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE OR SWP_SHOWWINDOW; OR SWP_NOOWNERZORDER
						Invoke SendMessage,hADialog,WM_SETFONT,[EDI].CONTROLDATA.hFont,FALSE
						Invoke DeMultiSelect
						Invoke SelectWindow,hADialog,TRUE
						Invoke SendMessage,hToolBoxToolBar,TB_CHECKBUTTON,IDM_TOOLBOX_POINTER,TRUE
						MOV ToolSelected,IDM_TOOLBOX_POINTER
						Invoke SetRCModified,TRUE
						;Invoke UndoRedo,ADDONELEVELUNDO
					.EndIf
				.EndIf
			.EndIf
		.EndIf
		
	.ElseIf uMsg==WM_SHOWWINDOW
		.If wParam
			Invoke CheckMenuItem,hMenu,IDM_VIEW_TOOLBOX,MF_CHECKED
		.Else
			Invoke CheckMenuItem,hMenu,IDM_VIEW_TOOLBOX,MF_UNCHECKED
		.EndIf
	.ElseIf uMsg == WM_NOTIFY
		MOV EBX,lParam
		
;		MOV EAX,[EBX].NMHDR.hwndFrom
;		.If EAX==hToolBoxToolBar
;			;PrintHex 1
;			.If [EBX].NMHDR.code==NM_CLICK;NM_DBLCLK;NM_RDBLCLK
;			;MOV EAX,[EBX].NMHDR.code
;				PrintHex 1
;			.EndIf
;		.EndIf
		
		.If [EBX].NMHDR.code== TTN_NEEDTEXT
			MOV EAX,[EBX].NMHDR.idFrom
			.If EAX==IDM_TOOLBOX_DIALOG
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAddNewDialog
			.ElseIf EAX==IDM_TOOLBOX_POINTER
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szPointer
			.ElseIf EAX==IDM_TOOLBOX_STATIC
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szStatic
			.ElseIf EAX==IDM_TOOLBOX_EDIT
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szEdit
			.ElseIf EAX==IDM_TOOLBOX_GROUPBOX
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szGroupBox
			.ElseIf EAX==IDM_TOOLBOX_BUTTON
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szButton
			.ElseIf EAX==IDM_TOOLBOX_CHECKBOX
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szCheckBox
			.ElseIf EAX==IDM_TOOLBOX_RADIOBUTTON
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szRadioButton
			.ElseIf EAX==IDM_TOOLBOX_COMBOBOX
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szComboBox
			.ElseIf EAX==IDM_TOOLBOX_LISTBOX
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szListBox
			.ElseIf EAX==IDM_TOOLBOX_HSCROLL
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szHScroll
			.ElseIf EAX==IDM_TOOLBOX_VSCROLL
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szVScroll
			.ElseIf EAX==IDM_TOOLBOX_TABCONTROL
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szTabControl
			.ElseIf EAX==IDM_TOOLBOX_TOOLBAR
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szToolBar
			.ElseIf EAX==IDM_TOOLBOX_STATUSBAR
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szStatusBar
			.ElseIf EAX==IDM_TOOLBOX_PROGRESSBAR
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szProgressBar
			.ElseIf EAX==IDM_TOOLBOX_TREEVIEW
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szTreeView
			.ElseIf EAX==IDM_TOOLBOX_LISTVIEW
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szListView
			.ElseIf EAX==IDM_TOOLBOX_SLIDER
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szSlider
			.ElseIf EAX==IDM_TOOLBOX_REBAR
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szRebarTip
			.ElseIf EAX==IDM_TOOLBOX_UPDOWN
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szUpDown
			.ElseIf EAX==IDM_TOOLBOX_SHAPE
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szShape
			.ElseIf EAX==IDM_TOOLBOX_IMAGE
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szImage
			.ElseIf EAX==IDM_TOOLBOX_RICHEDIT
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szRichEditTip
			.ElseIf EAX==IDM_TOOLBOX_USERDEFINEDCONTROL
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szUserDefinedControl
			.Else
				MOV EDX,IDM_TOOLBOX_USERDEFINEDCONTROL
				SUB EAX,EDX
				DEC EAX
				MOV EDX,SizeOf CUSTOMCONTROLEX
				MUL EDX
				
				MOV EDX,lpCustomControls
				ADD EDX,EAX
				
				LEA ECX,[EDX].CUSTOMCONTROL.szFriendlyName
				MOV [EBX].TOOLTIPTEXT.lpszText,ECX
			.EndIf
			;Tooltip is partly shown if parent floats
			Invoke SetWindowPos,[EBX].NMHDR.hwndFrom,HWND_TOP,0,0,0,0,SWP_NOACTIVATE OR SWP_NOMOVE OR SWP_NOSIZE OR SWP_NOOWNERZORDER
		.ElseIf [EBX].NMHDR.code== NM_RCLICK
				;PrintHex EAX
			Invoke GetCursorPos,ADDR Pt
			Invoke TrackPopupMenu,WinAsmHandles.PopUpMenus.hControlsMenu,TPM_LEFTALIGN+TPM_RIGHTBUTTON,Pt.x,Pt.y,0,WinAsmHandles.hMain,NULL
		.EndIf
;	.ElseIf uMsg==WM_LBUTTONDBLCLK
;	PrintHex 1
;	.ElseIf uMsg==WM_CONTEXTMENU
;		PrintDec 1234

	.ElseIf uMsg==WM_DESTROY
		;Invoke FreeLibrary,hRichEd
		;Invoke DeleteObject,hGridBrush
		Invoke ImageList_Destroy,hImlRCToolBoxNormal
	.EndIf
	Invoke CallWindowProc,ADDR DockWndProc,hWnd,uMsg,wParam,lParam
	RET
ToolBoxProc EndP

RCParentProc Proc Uses EDI hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local PS		:PAINTSTRUCT
Local Rect		:RECT
Local Pt		:POINT
Local ScrInfo	:SCROLLINFO

	.If uMsg==WM_PAINT
		Invoke BeginPaint,hWnd,ADDR PS
		Invoke CreateSolidBrush,col.RCBackCol
		PUSH EAX
		Invoke FillRect,PS.hdc,ADDR PS.rcPaint,EAX
		POP EAX
		Invoke DeleteObject,EAX
		Invoke EndPaint,hWnd,ADDR PS
		
	.ElseIf uMsg==WM_SETFOCUS || uMsg==WM_KILLFOCUS
		;Change color of the 8 ACTIVE Selection static controls 
		PUSH ESI
		.If hSelection
			MOV EDI,hSelection
			@@:
			MOV ESI,8
			.While ESI
				Invoke InvalidateRect,EDI,NULL,TRUE				
				Invoke GetWindowLong,EDI,GWL_USERDATA
				MOV EDI,EAX
				DEC ESI
			.EndW
		.EndIf
		POP ESI
		
	.ElseIf uMsg == WM_CTLCOLORSTATIC
		Invoke IsActiveSelectionStatic,lParam
		.If EAX
			Invoke GetFocus
			.If EAX==hRCEditorWindow
				Invoke GetSysColorBrush,COLOR_HIGHLIGHT
			.Else
				Invoke GetStockObject,LTGRAY_BRUSH
			.EndIf
			RET
		.EndIf
		
	.ElseIf uMsg==WM_SETCURSOR
		.If hADialog
			Invoke GetCursorPos,ADDR Pt
			Invoke GetClientRect,hADialog,ADDR Rect
			Invoke MapWindowPoints,hADialog,NULL,ADDR Rect,2
			.If ToolSelected!=IDM_TOOLBOX_POINTER	;i.e If a control button is pressed
				Invoke PtInRect,ADDR Rect,Pt.x,Pt.y
				.If EAX
					Invoke LoadCursor,NULL,IDC_CROSS
					Invoke SetCursor,EAX
					MOV EAX,TRUE
					RET
				.EndIf
			.EndIf
			
			Invoke ScreenToClient,hWnd,ADDR Pt
			Invoke ChildWindowFromPoint,hWnd,Pt.x,Pt.y
			Invoke IsActiveSelectionStatic,EAX
			.If EAX
				.If EAX>4 && EAX<8
					.If EAX==5
						MOV ECX,IDC_SIZEWE
					.ElseIf EAX==6
						MOV ECX,IDC_SIZENWSE
					.ElseIf EAX==7
						MOV ECX,IDC_SIZENS
					.EndIf
					Invoke LoadCursor,NULL,ECX
					Invoke SetCursor,EAX
					MOV EAX,TRUE
					RET
				.EndIf
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_KEYDOWN
		.If wParam==VK_DELETE
			Invoke DeleteSelectedWindows
		.ElseIf wParam >= VK_LEFT && wParam <=	VK_DOWN
			;VK_LEFT	;25h
			;VK_RIGHT	;27h
			;VK_UP		;26h
			;VK_DOWN	;28h
			
			Invoke GetKeyState, VK_SHIFT
			AND EAX,80h
			.If wParam==VK_RIGHT
				.If EAX!=80h	;Shift is NOT pressed
					Invoke EnumSelectedWindows,Offset MultiIncLeft
				.Else
					Invoke EnumSelectedWindows,Offset MultiIncWidth
				.EndIf
			.ElseIf wParam==VK_LEFT
				.If EAX!=80h	;Shift is NOT pressed
					Invoke EnumSelectedWindows,Offset MultiDecLeft
				.Else
					Invoke EnumSelectedWindows,Offset MultiDecWidth
				.EndIf
			.ElseIf wParam==VK_DOWN
				.If EAX!=80h	;Shift is NOT pressed
					Invoke EnumSelectedWindows,Offset MultiIncTop
				.Else
					Invoke EnumSelectedWindows,Offset MultiIncHeight
				.EndIf
			.ElseIf wParam==VK_UP
				.If EAX!=80h	;Shift is NOT pressed
					Invoke EnumSelectedWindows,Offset MultiDecTop
				.Else
					Invoke EnumSelectedWindows,Offset MultiDecHeight
				.EndIf
			.EndIf
			Invoke SetRCModified,TRUE
		.Else
			Invoke GetKeyState, VK_CONTROL
			AND EAX,80h
			.If EAX==80h
				.If wParam==VK_X
					MOV EAX,IDM_DIALOG_CUT
				.ElseIf wParam==VK_C
					MOV EAX,IDM_DIALOG_COPY
				.ElseIf wParam==VK_V
					MOV EAX,IDM_DIALOG_PASTE
				.Else
					JMP Done
				.EndIf
			.Else
				Invoke GetKeyState, VK_SHIFT
				AND EAX,80h
				.If EAX==80h
					.If wParam==VK_T
						MOV EAX,IDM_DIALOG_TESTDIALOG
					.Else
						JMP Done
					.EndIf
				.Else
					JMP Done
				.EndIf
			.EndIf
			
			Invoke SendMessage,hRCOptions,WM_COMMAND,EAX,0
			Done:
		.EndIf
	.ElseIf uMsg >= WM_MOUSEFIRST && uMsg <= WM_MOUSELAST;WM_LBUTTONDOWN || uMsg==WM_LBUTTONUP || uMsg==WM_RBUTTONUP;WM_MOUSEFIRST && uMsg <= WM_MOUSELAST;WM_LBUTTONDOWN;=
		.If uMsg==WM_LBUTTONDOWN || uMsg==WM_RBUTTONDOWN
			Invoke SetFocus,hWnd
		.EndIf
		
		HIWORD lParam
		MOV Pt.y,EAX
		LOWORD lParam
		MOV Pt.x,EAX
		
		Invoke GetCapture
		MOV EDI,EAX
		Invoke ClientToScreen,hWnd,ADDR Pt
		Invoke GetWindowRect,hADialog,ADDR Rect
		Invoke PtInRect,ADDR Rect,Pt.x,Pt.y
		.If EAX && EDI !=hWnd
			Invoke ScreenToClient,hADialog,ADDR Pt
			MOV EAX,Pt.y
			SHL EAX,16
			MOV ECX,Pt.x
			MOV AX,CX
			MOV lParam,EAX
			Invoke SendMessage,hADialog,uMsg,wParam,lParam
		.Else
			HIWORD lParam
			MOV Pt.y,EAX
			LOWORD lParam
			MOV Pt.x,EAX
			
			.If uMsg==WM_LBUTTONDOWN
				;Just to let me draw on top of existing controls
				Invoke GetWindowLong,hWnd,GWL_STYLE
				MOV ECX,WS_CLIPCHILDREN
				NOT ECX
				AND EAX,ECX
				Invoke SetWindowLong,hWnd,GWL_STYLE,EAX
				
				Invoke ChildWindowFromPoint,hWnd,Pt.x,Pt.y
				.If EAX
					Invoke IsActiveSelectionStatic,EAX
					.If EAX>4 && EAX<8
						MOV fSizing,EAX
						
						Invoke SetCapture,hWnd
						Invoke GetWindowLong,hADialog,GWL_USERDATA
						MOV EDI,EAX
						Invoke GetWindowRect,hADialog,ADDR [EDI].CONTROLDATA.ControlRect
						Invoke MapWindowPoints,0,hWnd,ADDR [EDI].CONTROLDATA.ControlRect,2
						;Invoke DrawControlRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
						Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
						
						MOV Rect.left,0
						MOV Rect.top,0
						MOV Rect.right,0
						MOV Rect.bottom,0
						Invoke AdjustWindowRectEx,ADDR Rect,[EDI].CONTROLDATA.Style,FALSE,[EDI].CONTROLDATA.ExStyle
						MOV EAX,Rect.bottom
						SUB EAX,Rect.top				;These are pixels
						MOV ECX,Rect.right
						SUB ECX,Rect.left				;These are pixels
						PUSH EAX
						PUSH ECX
						
						Invoke GetClientRect,hWnd,ADDR Rect
						
						POP ECX
						POP EAX
						ADD Rect.left,ECX
						ADD Rect.top,EAX
						
						MOV ECX,[EDI].CONTROLDATA.ControlRect.left
						ADD Rect.left,ECX
						.If Rect.left>7FFFFFFFh
							MOV Rect.left,0
						.EndIf
						
						MOV ECX,[EDI].CONTROLDATA.ControlRect.top
						ADD Rect.top,ECX
						.If Rect.top>7FFFFFFFh
							MOV Rect.top,0
						.EndIf
						
						Invoke MapWindowPoints,hWnd,0,ADDR Rect,2
						Invoke ClipCursor,ADDR Rect
						
						;Very Important!!! Clear all pending WM_MOUSEMOVE messages
						Invoke ClearPendingMessages,hWnd,WM_MOUSEMOVE,WM_MOUSEMOVE
						RET
					.EndIf
				.EndIf
			.ElseIf uMsg==WM_MOUSEMOVE
				Invoke GetCapture
				.If EAX==hWnd
					;.If fSizing
					PUSH EBX
					PUSH ESI
					MOV EBX,Pt.x
					MOV ESI,Pt.y
					Invoke GetWindowLong,hADialog,GWL_USERDATA
					MOV EDI,EAX
					;Invoke DrawControlRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
					Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
					.If fSizing==5
						MOV [EDI].CONTROLDATA.ControlRect.right,EBX
					.ElseIf fSizing==6
						MOV [EDI].CONTROLDATA.ControlRect.right,EBX
						MOV [EDI].CONTROLDATA.ControlRect.bottom,ESI
					.ElseIf fSizing==7
						MOV [EDI].CONTROLDATA.ControlRect.bottom,ESI
					.EndIf
					;Invoke DrawControlRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
					Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
					POP ESI
					POP EBX
				.EndIf
			.ElseIf uMsg==WM_LBUTTONUP
				Invoke GetCapture
				.If EAX==hWnd
					Invoke ClipCursor,NULL
					Invoke ReleaseCapture
					MOV fSizing,0
					Invoke GetWindowLong,hADialog,GWL_USERDATA
					MOV EDI,EAX
					Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
					
					MOV EAX,[EDI].CONTROLDATA.ControlRect.right
					SUB EAX,[EDI].CONTROLDATA.ControlRect.left
					MOV [EDI].CONTROLDATA.ccx,EAX
					MOV ECX,[EDI].CONTROLDATA.ControlRect.bottom
					SUB ECX,[EDI].CONTROLDATA.ControlRect.top
					MOV [EDI].CONTROLDATA.ccy,ECX
					
					Invoke MoveWindow,hADialog,[EDI].CONTROLDATA.ControlRect.left,[EDI].CONTROLDATA.ControlRect.top,EAX,ECX,TRUE
					
					Invoke PrepareAndConvertToDialogUnits,EDI
					Invoke ChangePosProperties,EDI
					
					Invoke SetRCModified,TRUE
					
					Invoke DeSelectWindow,hSelection
					MOV hSelection,EAX
					Invoke SelectWindow,hADialog,TRUE
				.EndIf
				;Do not draw over controls---->no flicker when RCDlg receives WM_PAINT
				Invoke GetWindowLong,hWnd,GWL_STYLE
				OR EAX,WS_CLIPSIBLINGS OR WS_CLIPCHILDREN
				Invoke SetWindowLong,hWnd,GWL_STYLE,EAX;WS_CHILD OR WS_VISIBLE OR WS_CLIPSIBLINGS  OR WS_BORDER OR WS_DLGFRAME OR WS_SYSMENU OR WS_THICKFRAME OR WS_GROUP OR WS_DISABLED OR WS_CLIPCHILDREN;EAX
			.ElseIf uMsg==WM_RBUTTONUP
				Invoke GetCapture
				.If EAX==hWnd
					Invoke ReleaseCapture
					Invoke ClipCursor,NULL
					MOV fSizing,0
					Invoke GetWindowLong,hADialog,GWL_USERDATA
					MOV EDI,EAX
					Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
				.EndIf
				;Do not draw over controls---->no flicker when RCDlg receives WM_PAINT
				Invoke GetWindowLong,hWnd,GWL_STYLE
				OR EAX,WS_CLIPSIBLINGS OR WS_CLIPCHILDREN
				Invoke SetWindowLong,hWnd,GWL_STYLE,EAX 
			.EndIf
		.EndIf
		
	.ElseIf uMsg==WM_NCACTIVATE
		.If wParam
			Invoke SetFocus,hWnd
		.EndIf
		Invoke SendMessage,hADialog,WM_NCACTIVATE,wParam,0
	.ElseIf uMsg==WM_VSCROLL
		Invoke GetScrollPos,hWnd,SB_VERT
		MOV ECX,EAX
		LOWORD wParam
		.If EAX !=SB_ENDSCROLL ;Do nothing when user released mouse
			.If EAX == SB_LINEDOWN
				ADD ECX,10
			.ElseIf EAX == SB_LINEUP
				SUB ECX,10
			.ElseIf EAX==SB_THUMBPOSITION
				HIWORD wParam
				MOV ECX,EAX
			.ElseIf EAX==SB_THUMBTRACK
				HIWORD wParam
				MOV ECX,EAX
			.ElseIf EAX==SB_PAGEDOWN
				ADD ECX,100
			.ElseIf EAX==SB_PAGEUP
				SUB ECX,100
			;.ElseIf EAX==	SB_TOP
			;.ElseIf EAX==	SB_BOTTOM
			.EndIf
			CALL ScrollVertically
		.EndIf
	.ElseIf uMsg==WM_HSCROLL
		Invoke GetScrollPos,hWnd,SB_HORZ
		MOV ECX,EAX
		LOWORD wParam
		.If EAX !=SB_ENDSCROLL ;Do nothing when user released mouse
			.If EAX == SB_LINERIGHT
				ADD ECX,10
			.ElseIf EAX == SB_LINELEFT
				SUB ECX,10
			.ElseIf EAX==SB_THUMBPOSITION
				HIWORD wParam
				MOV ECX,EAX
			.ElseIf EAX==SB_THUMBTRACK
				HIWORD wParam
				MOV ECX,EAX
			.ElseIf EAX==SB_PAGERIGHT
				ADD ECX,100
			.ElseIf EAX==SB_PAGELEFT
				SUB ECX,100
			;.ElseIf EAX==	SB_TOP
			;.ElseIf EAX==	SB_BOTTOM
			.EndIf
			CALL ScrollHorizontally
		.EndIf
	.ElseIf uMsg==WM_MOUSEWHEEL
		;fwKeys = LOWORD(wParam);    // key flags
		;zDelta = (short) HIWORD(wParam);    // wheel rotation
		;xPos = (short) LOWORD(lParam);    // horizontal position of pointer
		;yPos = (short) HIWORD(lParam);    // vertical position of pointer
		
		LOWORD wParam
		AND EAX,MK_CONTROL
		.If EAX
			Invoke GetScrollPos,hWnd,SB_HORZ
			MOV ECX,EAX
			CALL CalculateNewScrollPos
			CALL ScrollHorizontally
		.Else
			Invoke GetScrollPos,hWnd,SB_VERT
			MOV ECX,EAX
			CALL CalculateNewScrollPos
			CALL ScrollVertically
		.EndIf
		
;	.ElseIf uMsg==WM_KILLFOCUS
;		PrintHex EAX
	.EndIf
	Invoke CallWindowProc,ADDR ChildWndProc,hWnd,uMsg,wParam,lParam
	RET
	
	CalculateNewScrollPos:
	;---------------------
	MOV EDX,10
	MOV EAX, wParam
	SAR EAX, 16
	.If( SDWORD PTR EAX > 0)
		;Wheel UP
		SHR EAX, 3
		NEG EAX
		AND EAX, 0Fh
		MUL EDX			;i.e. If EAX=2-->EAX will become 20
		SUB ECX,EAX
	.Else
		;;Wheel DOwn
		SHR EAX, 3
		AND EAX, 0Fh
		MUL EDX			;i.e. If EAX=2-->EAX will become 20
		ADD ECX,EAX
	.EndIf

	RETN
	
	ScrollVertically:
	;---------------
	.If ECX>7FFFFFFFh
		XOR ECX,ECX
	.ElseIf ECX>1000
		MOV ECX,1000
	.EndIf
	MOV ScrInfo.cbSize,SizeOf SCROLLINFO
	MOV ScrInfo.fMask,SIF_POS; OR SIF_RANGE	;OR SIF_ALL	;
	MOV ScrInfo.nPos,ECX
	PUSH ECX
	Invoke SetScrollInfo,hWnd,SB_VERT,ADDR ScrInfo,TRUE
	POP ECX
	Invoke ScrollDialogVertically,hADialog,ECX
	RETN
	
	
	ScrollHorizontally:
	;-----------------
	.If ECX>7FFFFFFFh
		XOR ECX,ECX
	.ElseIf ECX>1000
		MOV ECX,1000
	.EndIf
	MOV ScrInfo.cbSize,SizeOf SCROLLINFO
	MOV ScrInfo.fMask,SIF_POS; OR SIF_RANGE	;OR SIF_ALL	;
	MOV ScrInfo.nPos,ECX
	PUSH ECX
	Invoke SetScrollInfo,hWnd,SB_HORZ,ADDR ScrInfo,TRUE
	POP ECX
	
	Invoke ScrollDialogHorizontally,hADialog,ECX
	RETN
RCParentProc EndP

ShowVisualRC Proc Uses EBX hChild:HWND
;Local Rect	:RECT
Local ScrInfo	:SCROLLINFO

	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	Invoke ShowWindow,CHILDWINDOWDATA.hEditor[EBX],SW_HIDE
	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_READONLY,0,TRUE
	
	Invoke SetWindowLong,hChild,GWL_WNDPROC,ADDR RCParentProc

	Invoke GetWindowLong,hChild,GWL_STYLE
	OR EAX,(WS_VSCROLL OR WS_HSCROLL)  
	Invoke SetWindowLong,hChild,GWL_STYLE,EAX

	Invoke GetWindowLong,hChild,GWL_EXSTYLE
	OR EAX,WS_EX_CLIENTEDGE
	Invoke SetWindowLong,hChild,GWL_EXSTYLE,EAX
	
	MOV ScrInfo.cbSize,SizeOf SCROLLINFO
	MOV ScrInfo.fMask,SIF_RANGE	or SIF_POS; OR OR SIF_ALL	;
	MOV ScrInfo.nPos,0
	MOV ScrInfo.nMin,0
	MOV ScrInfo.nMax,1000
	Invoke SetScrollInfo,hChild,SB_HORZ,ADDR ScrInfo,FALSE
	Invoke SetScrollInfo,hChild,SB_VERT,ADDR ScrInfo,FALSE

	;Wow! ;-) This causes the new style to become apparent!
	;Invoke SetWindowPos,hChild,HWND_TOP,Rect.left,Rect.top,Rect.right,Rect.bottom,SWP_FRAMECHANGED; OR SWP_NOMOVE OR SWP_NOSIZE
	Invoke SetWindowPos,hChild,HWND_TOP,0,0,0,0,SWP_FRAMECHANGED OR SWP_NOMOVE OR SWP_NOSIZE

	Invoke InvalidateRect,hChild,NULL,TRUE
	Invoke UpdateWindow,hChild
	

	RET
ShowVisualRC EndP

ShowCodeRC Proc Uses EBX hChild:HWND
	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	Invoke ShowWindow,CHILDWINDOWDATA.hEditor[EBX],SW_SHOW
	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_READONLY,0,FALSE


	Invoke GetWindowLong,hChild,GWL_STYLE
	AND EAX,-1 xor (WS_VSCROLL OR WS_HSCROLL)
	;OR EAX,WS_CAPTION
	Invoke SetWindowLong,hChild,GWL_STYLE,EAX
	
	Invoke GetWindowLong,hChild,GWL_EXSTYLE
	AND EAX,-1 xor WS_EX_CLIENTEDGE
	Invoke SetWindowLong,hChild,GWL_EXSTYLE,EAX	;Wow! ;-) This causes the new style to become apparent!
	Invoke SetWindowPos,hChild,HWND_TOP,0,0,0,0,SWP_FRAMECHANGED OR SWP_NOMOVE OR SWP_NOSIZE

	Invoke SetWindowLong,hChild,GWL_WNDPROC,ADDR ChildWndProc
	
	
	Invoke InvalidateRect,hChild,NULL,TRUE
	Invoke UpdateWindow,hChild

	RET
ShowCodeRC EndP

DeleteControl Proc Uses EBX lpDialogData:DWORD, lpControlData:DWORD
	MOV EBX,lpControlData
	Invoke DeleteDefine,ADDR [EBX].CONTROLDATA.IDName
	.If [EBX].CONTROLDATA.hImg
		Invoke DeleteObject,[EBX].CONTROLDATA.hImg
	.EndIf
	;Not needed since the parent dialog will be destroyed
	;Invoke DestroyWindow,[EDI].CONTROLDATA.hWnd
	
	.If [EBX].CONTROLDATA.ntype==24
		Invoke GetPointerToManagedControl,ADDR [EBX].CONTROLDATA.Class
		.If EAX	;it should be!
			DEC [EAX].CUSTOMCONTROLEX.ReferenceCount
		.EndIf
	.EndIf
	
	.If [EBX].CONTROLDATA.hChild
		Invoke GetStockObject,SYSTEM_FONT
		Invoke SendMessage,[EBX].CONTROLDATA.hChild,WM_SETFONT,eax,0
	.EndIf
	
	Invoke HeapFree,hMainHeap,0,EBX

	RET
DeleteControl EndP

DeleteSelectedWindows Proc Uses EBX ESI EDI
	Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM,TVGN_CARET,0
	.If EAX
		MOV EBX,EAX	;hTreeItem
		Invoke SetRCModified,TRUE
		Invoke GetTreeItemParameter,hDialogsTree,EBX
		MOV EDI,EAX
		
		Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM,TVGN_PARENT,EBX
		.If EAX	;i.e this is NOT a Dialog-It is one ore more controls
			MOV ESI,EAX	;TreeItem handle of the parent Dialog
			Invoke DeSelectWindow,hSelection
			MOV hSelection,EAX
			
			.If [EDI].CONTROLDATA.hChild	;This story for SysIPAddress32 !!!!!
				Invoke GetStockObject,SYSTEM_FONT
				Invoke SendMessage,[EDI].CONTROLDATA.hChild,WM_SETFONT,EAX,0
			.EndIf
			
			.If [EDI].CONTROLDATA.ntype==21 && [EDI].CONTROLDATA.hImg
				Invoke DeleteObject,[EDI].CONTROLDATA.hImg
			.ElseIf [EDI].CONTROLDATA.ntype==24
				Invoke GetPointerToManagedControl,ADDR [EDI].CONTROLDATA.Class
				.If EAX	;it should be!
					DEC [EAX].CUSTOMCONTROLEX.ReferenceCount
				.EndIf
			.EndIf
			
			Invoke DeleteDefine,ADDR [EDI].CONTROLDATA.IDName
			Invoke DestroyWindow,[EDI].CONTROLDATA.hWnd
			Invoke HeapFree,hMainHeap,0,EDI
			Invoke SendMessage, hDialogsTree, TVM_DELETEITEM,0,EBX
			
			.If hSelection
				@@:
				Invoke GetParent,hSelection
				PUSH EAX
				Invoke DeSelectWindow,hSelection
				MOV hSelection,EAX
				POP EAX
				Invoke GetWindowLong,EAX,GWL_USERDATA
				MOV EDI,EAX
				
				.If [EDI].CONTROLDATA.hChild
					Invoke GetStockObject,SYSTEM_FONT
					Invoke SendMessage,[EDI].CONTROLDATA.hChild,WM_SETFONT,EAX,0
				.EndIf
				
				.If [EDI].CONTROLDATA.ntype==21 && [EDI].CONTROLDATA.hImg
					Invoke DeleteObject,[EDI].CONTROLDATA.hImg
				.ElseIf [EDI].CONTROLDATA.ntype==24
					Invoke GetPointerToManagedControl,ADDR [EDI].CONTROLDATA.Class
					.If EAX	;it should be!
						DEC [EAX].CUSTOMCONTROLEX.ReferenceCount
						
					.EndIf
				.EndIf
				
				Invoke DeleteDefine,ADDR [EDI].CONTROLDATA.IDName
				Invoke DestroyWindow,[EDI].CONTROLDATA.hWnd
				Invoke SendMessage, hDialogsTree, TVM_DELETEITEM,0,[EDI].CONTROLDATA.hTreeItem
				
				Invoke HeapFree,hMainHeap,0,EDI
				
				.If hSelection
					JMP @B
				.EndIf
			.EndIf
			;Let's Get the Controls' parent 
			Invoke GetTreeItemParameter,hDialogsTree,ESI
			MOV EDI,EAX
			Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
			Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET, [EDI].CONTROLDATA.hTreeItem
			Invoke SetProperties,EDI
		.Else	;This is a Dialog
			;"Are you sure you want to delete this dialog?"
			Invoke MessageBox,NULL,Offset szSureToDeleteThisDialog,Offset szAppName,MB_YESNO + MB_ICONQUESTION +MB_TASKMODAL
			.If EAX==IDYES
				;Heap free for all Child Controls
				Invoke EnumDialogChildren,EDI,Offset DeleteControl
				
				Invoke DeSelectWindow,hSelection
				MOV hSelection,EAX
				Invoke SendMessage, hDialogsTree, TVM_DELETEITEM,0,EBX
				Invoke DeleteDefine,ADDR [EDI].CONTROLDATA.IDName
				Invoke DeleteObject,[EDI].CONTROLDATA.hFont
				Invoke DestroyWindow,[EDI].CONTROLDATA.hWnd
				Invoke HeapFree,hMainHeap,0,EDI
				Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM,TVGN_CARET,0
				.If !EAX ;i.e No more Dialogs in DialogsTree
					Invoke EnableControlsOnToolBox,FALSE
					Invoke SendMessage,hPropertiesList,LVM_DELETEALLITEMS,0,0
				.Else
					Invoke GetTreeItemParameter,hDialogsTree,EAX
					MOV EDI,EAX
					M2M hADialog,[EDI].CONTROLDATA.hWnd
					Invoke ShowWindow,hADialog,SW_SHOW
					Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
					Invoke SetProperties,EDI
				.EndIf
			.EndIf
		.EndIf
	.EndIf

	RET
DeleteSelectedWindows EndP

TestDialog Proc Uses EDI
	.If hADialog
		Invoke EnableWindow,WinAsmHandles.hMain,FALSE
		Invoke EnableAllDockWindows,FALSE
		Invoke EnableWindow,hFind,FALSE
		
		Invoke GetWindowLong,hADialog,GWL_USERDATA
		MOV EDI,EAX
		
		MOV ECX,[EDI].CONTROLDATA.Style
		
		MOV EDX,ECX
		AND EDX,(WS_POPUP OR WS_CHILD)
		.If !EDX
			OR ECX,WS_CAPTION ;(Thanks IanB)
		.Else
			MOV EDX,ECX
			AND EDX,DS_CONTROL
			.If EDX
				AND ECX,-1 XOR WS_CAPTION
			.EndIf
		.EndIf
		
		
		AND ECX,-1 XOR (WS_CHILD OR WS_DISABLED)
		OR ECX,WS_POPUP OR WS_VISIBLE
		
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,Offset szRCTestDlgClass,ADDR [EDI].CONTROLDATA.Caption,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,WinAsmHandles.hMain,NULL,hInstance,EDI
	.EndIf
	RET
TestDialog EndP

ChangeZOrderOfControl Proc Uses EDI TreeItemParameter:DWORD, ZOrder:DWORD
Local tvinsert		:TV_INSERTSTRUCT
Local Buffer[256]	:BYTE

	MOV EDI,TreeItemParameter
	Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM, TVGN_PARENT,[EDI].CONTROLDATA.hTreeItem
	.If EAX	;i.e. this is a control; Not a dialog.
		PUSH EAX
		;Get all info about the Tree Item that is to be deleted
		;Invoke RtlZeroMemory,ADDR tvinsert,SizeOf TV_INSERTSTRUCT
		MOV tvinsert.item._mask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE+TVIF_PARAM
		MOV EAX,[EDI].CONTROLDATA.hTreeItem
		MOV tvinsert.item.hItem,EAX
		MOV tvinsert.item.cchTextMax,256
	    LEA EAX, Buffer	;Holds FileTitle corresponding to this tree item
	    MOV tvinsert.item.pszText,EAX
	    Invoke SendMessage,hDialogsTree,TVM_GETITEM,0,ADDR tvinsert.item
	
		;Delete the Tree Item that is to be deleted
		Invoke SendMessage,hDialogsTree,TVM_DELETEITEM,0,[EDI].CONTROLDATA.hTreeItem
	    ;Create a new item with all info of the Item already deleted
	    ;the only problem : Does hItem stay unchanged ?
		POP EAX
	    MOV tvinsert.hParent,EAX
	    M2M tvinsert.hInsertAfter,ZOrder

		Invoke SendMessage,hDialogsTree,TVM_INSERTITEM,0, ADDR tvinsert
		;In case the hTree item changed
	    MOV [EDI].CONTROLDATA.hTreeItem,EAX
		Invoke SendMessage,hDialogsTree,TVM_SELECTITEM,TVGN_CARET,EAX
		;MOV RCModified,TRUE
		Invoke SetRCModified,TRUE
	.EndIf
	RET
ChangeZOrderOfControl EndP


CopyControl Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
	Invoke GlobalLock,hCopyMemory
	MOV EDI,EAX
	ADD EDI,4 ;<---------Nr of Selected Controls is stored
	.While [EDI].CONTROLDATA.hWnd
		ADD EDI,SizeOf CONTROLDATA
	.EndW
	Invoke RtlMoveMemory,EDI,lpWindowData,SizeOf CONTROLDATA
	Invoke GlobalUnlock,hCopyMemory
	RET
CopyControl EndP

GetNrOfSelectedControls Proc lpWindowData:DWORD, hFirstStatic:DWORD
	INC NrOfSelectedControls
	RET
GetNrOfSelectedControls EndP

CopyControlsToClipBoard Proc
	MOV NrOfSelectedControls,0
	Invoke EnumSelectedWindows,Offset GetNrOfSelectedControls
	MOV EAX,SizeOf CONTROLDATA
	MUL NrOfSelectedControls
	ADD EAX,4	;<---------I will store Nr of Selected Controls
	Invoke GlobalAlloc,GHND OR GMEM_DDESHARE,EAX
	MOV hCopyMemory,EAX
	
	Invoke GlobalLock,hCopyMemory
	Invoke RtlMoveMemory,EAX,ADDR NrOfSelectedControls,4
	Invoke GlobalUnlock,hCopyMemory
	
	Invoke EnumSelectedWindows,Offset CopyControl
	
	Invoke OpenClipboard,NULL
	.If EAX
		Invoke EmptyClipboard
		Invoke SetClipboardData,hClipFormat,hCopyMemory
		Invoke CloseClipboard
	.EndIf
	RET
CopyControlsToClipBoard EndP

PasteControlsFromClipboard Proc Uses EDI EBX ESI
Local Buffer[256]:BYTE

	Invoke OpenClipboard,WinAsmHandles.hMain;NULL
	.If EAX
		Invoke DeMultiSelect
		
		Invoke GetClipboardData,hClipFormat
		PUSH EAX
		
		Invoke GlobalLock,EAX
		MOV EBX,EAX
		
		MOV ECX,[EAX]
		MOV NrOfSelectedControls,ECX
		
		;Let's find LAST control
		.If ECX
			DEC ECX
			MOV EAX,SizeOf CONTROLDATA
			MUL ECX
			ADD EAX,4	;<---------Nr of Selected Controls is stored at first DWORD
			
			;We start from LAST control and move backwards to the first control
			ADD EBX,EAX
			.While NrOfSelectedControls
				.If hSelection
					Invoke ConvertSelection,hSelection
				.EndIf
				
				Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CONTROLDATA
				MOV EDI,EAX
				Invoke RtlMoveMemory,EDI,EBX,SizeOf CONTROLDATA
				Invoke GetWindowLong,hADialog,GWL_USERDATA
				
				M2M [EDI].CONTROLDATA.hFont,[EAX].CONTROLDATA.hFont
				
				MOV [EDI].CONTROLDATA.dux,0
				MOV [EDI].CONTROLDATA.x,0
				MOV [EDI].CONTROLDATA.duy,0
				MOV [EDI].CONTROLDATA.y,0
				
				INC HighestWindowDialogID
				MOV EDX,HighestWindowDialogID
				MOV [EDI].CONTROLDATA.ID,EDX;,HighestWindowDialogID
				Invoke BinToDec,EDX,ADDR Buffer
				
				LEA ESI,[EDI].CONTROLDATA.Caption
				.If [EDI].CONTROLDATA.ntype!=21 && BYTE PTR [ESI]!=0 ;i.e. NOT image and NOT NULL caption
					;Remove 0,1,2--9  from the end of caption
					Invoke lstrlen,ESI
					ADD ESI,EAX
					@@:
					DEC ESI
					.If BYTE PTR [ESI] && (BYTE PTR [ESI]>="0" && BYTE PTR [ESI]<="9")
						MOV BYTE PTR [ESI],0
						JMP @B
					.EndIf
					LEA ESI,[EDI].CONTROLDATA.Caption
					;Add the number at the end of caption
					Invoke lstrcat,ESI,ADDR Buffer
				.EndIf
				
				LEA ESI,[EDI].CONTROLDATA.IDName
				.If BYTE PTR [ESI]
					;Remove 0,1,2--9  from the end of IDName
					Invoke lstrlen,ESI
					ADD ESI,EAX
					@@:
					DEC ESI
					.If BYTE PTR [ESI] && (BYTE PTR [ESI]>="0" && BYTE PTR [ESI]<="9")
						MOV BYTE PTR [ESI],0
						JMP @B
					.EndIf
					LEA ESI,[EDI].CONTROLDATA.IDName
					;Add the number at the end of IDName
					Invoke lstrcat,ESI,ADDR Buffer
				.EndIf
				
				;Invoke AddDefine,lpDefinesMem,ESI,ADDR Buffer
				Invoke AddOrReplaceDefine,ESI,ADDR Buffer
				
				Invoke ConvertToDialogUnits,EDI
				Invoke CreateControl,EDI,hADialog
				Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET, [EDI].CONTROLDATA.hTreeItem
				
				Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
				
				SUB EBX,SizeOf CONTROLDATA
				DEC NrOfSelectedControls
			.EndW
			
			
			Invoke SetRCModified,TRUE
		.EndIf
		POP EAX
		Invoke GlobalUnlock,EAX
		Invoke CloseClipboard
	.EndIf

	RET
PasteControlsFromClipboard EndP
EmptyAllTextBoxes Proc Uses EBX hDlg:HWND
	;Friendly name
	Invoke SendDlgItemMessage,hDlg,237,WM_SETTEXT,0,Offset szNULL
	;Class name
	Invoke SendDlgItemMessage,hDlg,238,WM_SETTEXT,0,Offset szNULL
	;Description
	Invoke SendDlgItemMessage,hDlg,239,WM_SETTEXT,0,Offset szNULL
	;DLL (full path) name
	Invoke SendDlgItemMessage,hDlg,240,WM_SETTEXT,0,Offset szNULL
	;Style Edit boxes
	MOV EBX,221
	.While EBX<237
		Invoke SendDlgItemMessage,hDlg,EBX,WM_SETTEXT,0,Offset szNULL
		INC EBX
	.EndW
	RET
EmptyAllTextBoxes EndP

DefinitionsDlgProc Proc Uses EDI hDlg:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
Local hControl				:DWORD
LOCAL lvc					:LV_COLUMN
Local lvi					:LVITEM
Local Buffer[12]			:BYTE

	MOV EAX,uMsg
	.If EAX==WM_INITDIALOG
		Invoke GetDlgItem,hDlg,222	;codehi
		MOV hControl,EAX
		Invoke SendMessage,hControl,CHM_SETCOLOR, 0, ADDR col
		Invoke SetFormat, hControl
		
		Invoke GetDlgItem,hDlg,221	;listview
		MOV hControl,EAX
		MOV EAX, LVS_EX_FULLROWSELECT OR LVS_EX_LABELTIP OR LVS_EX_GRIDLINES
		Invoke SendMessage, hControl, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX
		
		MOV lvc.imask, LVCF_WIDTH OR LVCF_TEXT OR LVCF_FMT
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.pszText,Offset szName
		MOV lvc.lx, 200
		Invoke SendMessage, hControl, LVM_INSERTCOLUMN, 0, addr lvc
		
		MOV lvc.pszText,Offset szID
		;MOV lvc.fmt,LVCFMT_CENTER
		MOV lvc.lx, 75
		Invoke SendMessage, hControl, LVM_INSERTCOLUMN, 1, addr lvc
		
		.If lpDefinesMem
			MOV lvi.imask,LVIF_TEXT
			MOV lvi.cchTextMax,256
			MOV lvi.iSubItem, 0
			MOV lvi.iItem,-1
			
			MOV EDI,lpDefinesMem
			.While [EDI].DEFINE.szName
				;MOV EAX,[EDI].DEFINE.ReferenceCount
				;PrintDec EAX
				.If [EDI].DEFINE.ReferenceCount
					
					INC lvi.iItem
					MOV lvi.iSubItem, 0
					LEA EDX,[EDI].DEFINE.szName
					MOV lvi.pszText,EDX
					Invoke SendMessage,hControl,LVM_INSERTITEM,0,ADDR lvi
					
					
					Invoke BinToDec,[EDI].DEFINE.dwValue,ADDR Buffer
					MOV lvi.iSubItem, 1
					LEA EDX,Buffer
					MOV lvi.pszText,EDX
					Invoke SendMessage,hControl,LVM_SETITEM,0,ADDR lvi
				.EndIf
				ADD EDI,SizeOf DEFINE
			.EndW
		.EndIf
		
		Invoke SetColumnsWidth,hControl
		
	.ElseIf EAX==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		
		.If EDX==BN_CLICKED
			.If EAX==223		;OK
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
			.ElseIf EAX==224	;Export
				.If lpDefinesMem
					MOV EDI,lpDefinesMem
					Invoke GetDlgItem,hDlg,222
					MOV hControl,EAX
					Invoke SendMessage,hControl,WM_SETREDRAW,FALSE,0
					Invoke SendMessage,hControl,WM_SETTEXT,0,Offset szNULL
					.While [EDI].DEFINE.szName
						.If [EDI].DEFINE.ReferenceCount
							Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,ADDR [EDI].DEFINE.szName
							
							;Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,Offset szSpc
							
							Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,Offset szTAB
							Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,Offset szTAB
							;Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,Offset szTAB
							
							Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,CTEXT("EQU")
							Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,Offset szSpc
							Invoke BinToDec,[EDI].DEFINE.dwValue,ADDR Buffer
							Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,ADDR Buffer
							Invoke SendMessage,hControl,EM_REPLACESEL,FALSE,Offset szCRLF
						.EndIf
						ADD EDI,SizeOf DEFINE
					.EndW
					Invoke SendMessage,hControl,WM_SETREDRAW,TRUE,0
					Invoke SendMessage,hControl,CHM_REPAINT,0,0
				.EndIf
			.Else
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
			.EndIf
		.EndIf
		
	.ElseIf EAX==WM_CLOSE
		Invoke EndDialog,hDlg,NULL
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
DefinitionsDlgProc EndP

ControlsManagerManagerProc Proc Uses EBX EDI ESI hDlg:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
Local hControlsList			:DWORD
Local Buffer[MAX_PATH+1]	:DWORD
LOCAL lvc					:LV_COLUMN
Local lvi					:LVITEM
Local lvfi					:LV_FINDINFO
Local tbb					:TBBUTTON
Local Buffer2[32]			:DWORD	;only used for class and friendly name

	MOV EAX,uMsg
	.If EAX==WM_INITDIALOG
		;Friendly name
		Invoke SendDlgItemMessage,hDlg,237,EM_LIMITTEXT,24,0
		
		;Class name
		Invoke SendDlgItemMessage,hDlg,238,EM_LIMITTEXT,24,0
		
		;DLL (full path) name
		Invoke SendDlgItemMessage,hDlg,240,EM_LIMITTEXT,MAX_PATH,0
		
		;Style Edit boxes
		MOV EBX,221
		.While EBX<237
			Invoke SendDlgItemMessage,hDlg,EBX,EM_LIMITTEXT,24,0
			INC EBX
		.EndW
		
		Invoke GetDlgItem,hDlg,220
		MOV hControlsList,EAX
		
		MOV EAX, LVS_EX_FULLROWSELECT; OR LVS_EX_LABELTIP
		Invoke SendMessage, hControlsList, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX
		
		MOV lvc.imask, LVCF_WIDTH OR LVCF_FMT
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.lx, 202
		Invoke SendMessage, hControlsList, LVM_INSERTCOLUMN, 0, ADDR lvc
		
		
		MOV EDI,lpCustomControls
		MOV lvi.imask,LVIF_TEXT OR LVIF_PARAM
		MOV lvi.iSubItem, 0
		XOR EBX,EBX
		@@:
		LEA ECX,[EDI].CUSTOMCONTROL.szFriendlyName
		.If BYTE PTR [ECX]
			MOV lvi.pszText,ECX
			MOV lvi.iItem,EBX
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CUSTOMCONTROLEX
			MOV lvi.lParam,EAX
			Invoke RtlMoveMemory,EAX,EDI,SizeOf CUSTOMCONTROLEX
			Invoke SendMessage,hControlsList,LVM_INSERTITEM,0,ADDR lvi
			ADD EDI,SizeOf CUSTOMCONTROLEX
			INC EBX
			JMP @B
		.EndIf
	
	.ElseIf EAX==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		
		.If EDX==BN_CLICKED
			.If EAX==242		;OK
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,TRUE
			.ElseIf EAX==243	;Cancel
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
			.ElseIf EAX==244	;New
				Invoke EmptyAllTextBoxes,hDlg
				Invoke SendDlgItemMessage, hDlg,220, LVM_GETNEXTITEM, -1,LVNI_FOCUSED; + ,LVIS_SELECTED;
				MOV lvi.iSubItem,0
				MOV lvi.iItem,EAX
				MOV lvi.imask,LVIF_STATE
				MOV lvi.stateMask,LVIS_SELECTED
				MOV lvi.state,0;LVIS_SELECTED 
				Invoke SendDlgItemMessage, hDlg,220,LVM_SETITEM,0,ADDR lvi
			.ElseIf EAX==245	;Apply
				;Get friendly Name
				MOV Buffer[0],0
				Invoke GetDlgItemText,hDlg,237,ADDR Buffer,24
				.If Buffer[0]!=0
					MOV Buffer2[0],0
					;Class name
					Invoke GetDlgItemText,hDlg,238,ADDR Buffer2,24
					.If Buffer2[0]!=0
						Invoke GetDlgItem,hDlg,220
						MOV hControlsList,EAX
						MOV lvi.iSubItem, 0
						LEA ECX,Buffer
						MOV lvi.pszText,ECX
						
						Invoke RtlZeroMemory,ADDR lvfi,SizeOf LV_FINDINFO
						MOV lvfi.flags,LVFI_STRING 
						LEA EDX,Buffer
						MOV lvfi.psz,EDX
						Invoke SendMessage,hControlsList,LVM_FINDITEM,-1,ADDR lvfi
						.If EAX==-1 ;i.e if there is NOT such text in the list
							
							Invoke SendMessage, hControlsList, LVM_GETITEMCOUNT,0,0
							.If EAX
								MOV lvi.iItem,0
								MOV EDI,EAX
								
								@@:
								MOV lvi.imask,LVIF_PARAM
								Invoke SendMessage,hControlsList,LVM_GETITEM,0,ADDR lvi
								MOV EBX,lvi.lParam
								Invoke lstrcmpi,ADDR Buffer2,ADDR [EBX].CUSTOMCONTROL.szClassName
								.If !EAX	;i.e. this class already exists
									MOV lvi.imask,LVIF_TEXT
									;LEA ECX,Buffer
									;MOV lvi.pszText,ECX
									Invoke SendMessage,hControlsList,LVM_SETITEM,0,ADDR lvi
									JMP GoSave
								.EndIf
								INC lvi.iItem
								.If lvi.iItem<EDI
									JMP @B
								.EndIf
							.EndIf
								
								
							Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CUSTOMCONTROLEX
							MOV EBX,EAX
							
							MOV lvi.imask,LVIF_TEXT OR LVIF_PARAM; OR LVIF_STATE
							;MOV lvi.state,LVIS_SELECTED OR LVIS_FOCUSED
							MOV lvi.lParam,EBX
							Invoke SendMessage,hControlsList,LVM_GETITEMCOUNT,0,0
							MOV lvi.iItem,EAX
							Invoke SendMessage,hControlsList,LVM_INSERTITEM,0,ADDR lvi
							
						.Else
							MOV lvi.iItem,EAX
							MOV lvi.imask,LVIF_PARAM
							Invoke SendMessage,hControlsList,LVM_GETITEM,0,ADDR lvi
							MOV EBX,lvi.lParam
							.If [EBX].CUSTOMCONTROLEX.ReferenceCount
								Invoke lstrcmpi,ADDR [EBX].CUSTOMCONTROL.szClassName,ADDR Buffer2
								.If EAX
									Invoke MessageBox,WinAsmHandles.hMain,Offset szClassAlreadyUsed, Offset szAppName,MB_OK+MB_TASKMODAL
									Invoke SendDlgItemMessage,hDlg,238,WM_SETTEXT,0,ADDR [EBX].CUSTOMCONTROL.szClassName
									RET
								.EndIf
							.EndIf
						.EndIf
						;CUSTOMCONTROL STRUCT
						;	szFriendlyName		DB	24+1		DUP (?)
						;	szClassName			DB	24+1		DUP (?)
						;	szDescription		DB	256+1		DUP (?)
						;	szDLLFullPathName	DB	MAX_PATH+1	DUP (?)
						;	szStyles			DB	16*(24+1)	DUP (?)
						;CUSTOMCONTROL ENDS
						
						GoSave:
						Invoke lstrcpy,ADDR [EBX].CUSTOMCONTROL.szFriendlyName,ADDR Buffer
						
						;Class name
						Invoke lstrcpy,ADDR [EBX].CUSTOMCONTROL.szClassName,ADDR Buffer2
						
						
						;DLL (full path) name
						Invoke GetDlgItemText,hDlg,240,ADDR Buffer,MAX_PATH
						Invoke lstrcpy,ADDR [EBX].CUSTOMCONTROL.szDLLFullPathName,ADDR Buffer
						
						;Style Edit boxes
						LEA EDI,[EBX].CUSTOMCONTROL.szStyles
						MOV EBX,221
						.While EBX<237
							Invoke GetDlgItemText,hDlg,EBX,ADDR Buffer,24
							Invoke lstrcpy,EDI,ADDR Buffer
							ADD EDI,(24+1)
							INC EBX
						.EndW
						
						MOV lvi.imask,LVIF_STATE
						MOV lvi.state,LVIS_SELECTED OR LVIS_FOCUSED
						MOV lvi.stateMask,LVIS_SELECTED OR LVIS_FOCUSED
						Invoke SendMessage,hControlsList,LVM_SETITEM,0,ADDR lvi
						
					.Else
						Invoke MessageBox,WinAsmHandles.hMain,Offset szClassNameRequired, Offset szAppName,MB_OK+MB_TASKMODAL
					.EndIf
				.Else
					Invoke MessageBox,WinAsmHandles.hMain,Offset szFriendlyNameRequired, Offset szAppName,MB_OK+MB_TASKMODAL
				.EndIf
			.ElseIf EAX==246	;Delete
				Invoke GetDlgItem,hDlg,220
				MOV hControlsList,EAX
				Invoke SendMessage, hControlsList, LVM_GETNEXTITEM, -1,LVIS_SELECTED+LVNI_FOCUSED
				.If EAX!=-1
					MOV EDI,EAX
					MOV lvi.iSubItem, 0
					MOV lvi.iItem,EAX
					MOV lvi.imask,LVIF_PARAM
					Invoke SendMessage,hControlsList,LVM_GETITEM,0,ADDR lvi
					MOV EBX,lvi.lParam
					.If [EBX].CUSTOMCONTROLEX.ReferenceCount
						Invoke MessageBox,WinAsmHandles.hMain,Offset szControlUsed, Offset szAppName,MB_OK+MB_TASKMODAL
					.Else
						Invoke MessageBox,WinAsmHandles.hMain,Offset szSureToDeleteControl, Offset szAppName,MB_YESNO+MB_TASKMODAL
						.If EAX==IDYES
							Invoke SendMessage,hControlsList,LVM_DELETEITEM,EDI,0
						.EndIf
					.EndIf
					
					Invoke SetFocus,hDlg
					
					
					Invoke SendMessage,hControlsList,LVM_GETITEMCOUNT,0,0
					.If EAX
						MOV lvi.imask,LVIF_STATE
						MOV lvi.state,LVIS_SELECTED OR LVIS_FOCUSED
						MOV lvi.stateMask,LVIS_SELECTED OR LVIS_FOCUSED
						.If EDI==EAX
							DEC EDI
						.EndIf
						MOV lvi.iItem,EDI
						Invoke SendMessage,hControlsList,LVM_SETITEM,0,ADDR lvi
					.Else
						Invoke EmptyAllTextBoxes,hDlg
					.EndIf
				.EndIf
			.ElseIf EAX==241	;Browse for dll file
				Invoke GetDlgItem,hDlg,240
				Invoke BrowseForFile,hDlg,Offset DLLsFilter,EAX,NULL
			.Else
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
			.EndIf
		.EndIf
		
	.ElseIf EAX==WM_NOTIFY
		MOV EBX,lParam
		Invoke GetDlgItem,hDlg,220
		;MOV hControlsList,EAX
		.If [EBX].NMHDR.hwndFrom==EAX
			.If [EBX].NMHDR.code ==LVN_ITEMCHANGED
				.If [EBX].NM_LISTVIEW.uNewState;==LVIS_FOCUSED ;i.e focus and selected
					
					MOV EDI,[EBX].NM_LISTVIEW.lParam
					;Friendly name
					Invoke SendDlgItemMessage,hDlg,237,WM_SETTEXT,0,ADDR [EDI].CUSTOMCONTROL.szFriendlyName
					;Class name
					Invoke SendDlgItemMessage,hDlg,238,WM_SETTEXT,0,ADDR [EDI].CUSTOMCONTROL.szClassName
					;DLL (full path) name
					Invoke SendDlgItemMessage,hDlg,240,WM_SETTEXT,0,ADDR [EDI].CUSTOMCONTROL.szDLLFullPathName
					;Style Edit boxes
					MOV EBX,221
					LEA EDI,[EDI].CUSTOMCONTROL.szStyles
					.While EBX<237
						Invoke SendDlgItemMessage,hDlg,EBX,WM_SETTEXT,0,EDI
						ADD EDI,25
						INC EBX
					.EndW
				.EndIf
			.EndIf
		.EndIf
		
	.ElseIf EAX==WM_CLOSE
		Invoke GetDlgItem,hDlg,220
		MOV hControlsList,EAX
		
		Invoke EndDialog,hDlg,0

		.If lParam	;i.e. OK was pressed
			;Next line is just seeing whether control buttons are enabled or disabled
			;let's check button 2 (any would do except 0 which is "Add New Dialog"
			Invoke SendMessage,hToolBoxToolBar,TB_GETBUTTON,2,ADDR tbb
			MOV AL,tbb.fsState
			MOV CustomControlButton.fsState,AL
			
			@@:
			Invoke SendMessage,hToolBoxToolBar,TB_DELETEBUTTON,25,0
			.If EAX
				JMP @B
			.EndIf
			
			Invoke WritePrivateProfileSection,Offset szCONTROLS,Offset szNULL,Offset IniFileName
		.EndIf
		
		Invoke SendMessage,hControlsList,LVM_GETITEMCOUNT,0,0
		.If EAX
			MOV lvi.imask,LVIF_PARAM
			MOV lvi.iSubItem, 0
			MOV lvi.iItem,0
			XOR EBX,EBX
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CUSTOMCONTROLEX
			MOV EDI,EAX
			
			@@:
			Invoke SendMessage,hControlsList,LVM_GETITEM,0,ADDR lvi
			.If EAX
				.If lParam	;i.e. OK was pressed
					INC EBX
					Invoke BinToDec,EBX,ADDR Buffer
					Invoke WritePrivateProfileStruct,Offset szCONTROLS,ADDR Buffer,lvi.lParam,SizeOf CUSTOMCONTROL,Offset IniFileName
					
					MOV EAX,SizeOf CUSTOMCONTROLEX
					MUL EBX
					PUSH EAX
					ADD EAX,EDI
					SUB EAX,SizeOf CUSTOMCONTROLEX
					Invoke RtlMoveMemory,EAX,lvi.lParam,SizeOf CUSTOMCONTROLEX
					POP ECX
					ADD ECX,SizeOf CUSTOMCONTROLEX
					Invoke HeapReAlloc,hMainHeap,HEAP_ZERO_MEMORY,EDI,ECX
					MOV EDI,EAX
					
					MOV EAX,IDM_TOOLBOX_USERDEFINEDCONTROL
					ADD EAX,EBX
					MOV CustomControlButton.idCommand,EAX
					
					Invoke SendMessage,hToolBoxToolBar,TB_ADDBUTTONS,1,ADDR CustomControlButton
					
				.EndIf
				Invoke HeapFree,hMainHeap,0,lvi.lParam
				Invoke SendMessage,hControlsList,LVM_DELETEITEM,0,0
				JMP @B
			.EndIf
			
			.If lParam
				Invoke HeapFree,hMainHeap,0,lpCustomControls
				MOV lpCustomControls,EDI
			.EndIf
			
		.EndIf
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	
	MOV EAX,TRUE
	RET

ControlsManagerManagerProc EndP

OptionsProc Proc Uses EBX EDI ESI hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
Local Rect	:RECT
;Local tvi	:TVITEM

	.If uMsg == WM_SIZE
		Invoke SendMessage,hWnd,WAM_GETCLIENTRECT,0,ADDR Rect
		MOV EAX,Rect.right
		SUB EAX,Rect.left
		MOV ECX,Rect.bottom
		SUB ECX,Rect.top
		Invoke MoveWindow,hRCOptionsToolBar,Rect.left,Rect.top,EAX,ECX,TRUE
	.ElseIf uMsg==WM_SHOWWINDOW
		.If wParam
			Invoke CheckMenuItem,hMenu,IDM_VIEW_DIALOG,MF_CHECKED
		.Else
			Invoke CheckMenuItem,hMenu,IDM_VIEW_DIALOG,MF_UNCHECKED
		.EndIf
	.ElseIf uMsg == WM_NOTIFY
		MOV EBX,lParam
		.If [EBX].NMHDR.code== TTN_NEEDTEXT
			MOV EAX,[EBX].NMHDR.idFrom
			.If EAX==IDM_DIALOG_SHOWHIDEGRID
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szShowHideGrid
			.ElseIf EAX==IDM_DIALOG_SNAPTOGRID
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szSnapToGrid
			.ElseIf EAX==IDM_DIALOG_GRIDSIZE
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szGridSize
			.ElseIf EAX==IDM_DIALOG_ALIGNLEFTS
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignLefts
			.ElseIf EAX==IDM_DIALOG_ALIGNCENTERS
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignCenters
			.ElseIf EAX==IDM_DIALOG_ALIGNWITHDIALOGCENTER
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignCentersWithDialogCenter
			.ElseIf EAX==IDM_DIALOG_ALIGNRIGHTS
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignRights
			.ElseIf EAX==IDM_DIALOG_ALIGNTOPS
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignTops
			.ElseIf EAX==IDM_DIALOG_ALIGNMIDDLES
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignMiddles
			.ElseIf EAX==IDM_DIALOG_ALIGNWITHDIALOGMIDDLE
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignMiddlesWithDialogMiddle
			.ElseIf EAX==IDM_DIALOG_ALIGNBOTTOMS
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szAlignBottoms
			.ElseIf EAX==IDM_DIALOG_MAKESAMEWIDTH
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szMakeSameWidth
			.ElseIf EAX==IDM_DIALOG_MAKESAMEHEIGHT
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szMakeSameHeight
			.ElseIf EAX==IDM_DIALOG_MAKESAMESIZE
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szMakeSameSize
			.ElseIf EAX==IDM_DIALOG_SENDTOBACK
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szSendToBack
			.ElseIf EAX==IDM_DIALOG_BRINGONTOP
				MOV [EBX].TOOLTIPTEXT.lpszText,Offset szBringToFront
			;.ElseIf EAX==IDM_DIALOG_LOCKCONTROLS
			;	MOV [EBX].TOOLTIPTEXT.lpszText,Offset szLockControls
			.EndIf
			;Tooltip is partly shown if parent floats
			Invoke SetWindowPos,[EBX].NMHDR.hwndFrom,HWND_TOP,0,0,0,0,SWP_NOACTIVATE OR SWP_NOMOVE OR SWP_NOSIZE OR SWP_NOOWNERZORDER
		.EndIf
	.ElseIf uMsg == WM_COMMAND
		HIWORD wParam
		.If EAX == 0 || 1 ; 0 is a menu, 1 is an accelerator. Toolbar messages act like menu messages...
			LOWORD wParam
			.If EAX==IDM_DIALOG_SHOWHIDEGRID
				Invoke InvalidateRect,hADialog,NULL,TRUE
			;.ElseIf EAX==IDM_DIALOG_SNAPTOGRID
			.ElseIf EAX==IDM_DIALOG_GRIDSIZE
				Invoke CreatePopupMenu
				MOV EBX,EAX
				;Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_1,CTEXT("1")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_2,CTEXT("2")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_3,CTEXT("3")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_4,CTEXT("4")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_5,CTEXT("5")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_6,CTEXT("6")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_7,CTEXT("7")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_8,CTEXT("8")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_9,CTEXT("9")
				Invoke AppendMenu,EBX,MF_STRING,IDM_DIALOG_GRIDSIZE_10,CTEXT("10")
				MOV EAX,GridSize
				SUB EAX,2
				Invoke CheckMenuItem,EBX,EAX,MF_BYPOSITION OR MF_CHECKED
				Invoke SendMessage,hRCOptionsToolBar,TB_GETITEMRECT,2,ADDR Rect
				Invoke MapWindowPoints,hRCOptionsToolBar,NULL,ADDR Rect,2
				Invoke TrackPopupMenu,EBX,TPM_LEFTALIGN OR TPM_RIGHTBUTTON,Rect.left,Rect.bottom,0,hWnd,0
				Invoke DestroyMenu,EBX
			
			.ElseIf EAX>=IDM_DIALOG_GRIDSIZE_2 && EAX<=IDM_DIALOG_GRIDSIZE_10
				SUB EAX,11400
				MOV GridSize,EAX
				.If hADialog
					Invoke InvalidateRect,hADialog,NULL,TRUE
				.EndIf
			;.ElseIf EAX==IDM_DIALOG_UNDO
				;Invoke ResourceUndo
			;.ElseIf EAX==IDM_DIALOG_REDO
				;Invoke ResourceRedo
			.ElseIf EAX==IDM_DIALOG_CUT
				Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
				.If EAX	;Yes there is
					Invoke GetTreeItemParameter,hDialogsTree,EAX
					.If [EAX].CONTROLDATA.ntype	;i.e NOT a Dialog
						Invoke CopyControlsToClipBoard
						Invoke DeleteSelectedWindows
						Invoke SetRCModified,TRUE
					.EndIf
				.EndIf
			.ElseIf EAX==IDM_DIALOG_COPY
				Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
				.If EAX	;Yes there is
					Invoke GetTreeItemParameter,hDialogsTree,EAX
					.If [EAX].CONTROLDATA.ntype	;i.e NOT a Dialog
						Invoke CopyControlsToClipBoard
					.EndIf
				.EndIf
			.ElseIf EAX==IDM_DIALOG_PASTE
				Invoke IsClipboardFormatAvailable,hClipFormat
				.If EAX
					Invoke PasteControlsFromClipboard
				.EndIf	
			.ElseIf EAX==IDM_DIALOG_STYLE
				
				Invoke SelectListItem,hPropertiesList,6;,0
				Invoke SendMessage,hPropertiesList,WM_COMMAND, (BN_CLICKED SHL 16) OR 200,0
				
				
			.ElseIf EAX==IDM_DIALOG_EXSTYLE
				Invoke SelectListItem,hPropertiesList,7;,0
				Invoke SendMessage,hPropertiesList,WM_COMMAND, (BN_CLICKED SHL 16) OR 200,0
			.ElseIf EAX==IDM_DIALOG_DIALOGFONT
				Invoke SelectListItem,hPropertiesList,12
				Invoke SendMessage,hPropertiesList,WM_COMMAND, (BN_CLICKED SHL 16) OR 200,0
			.ElseIf EAX==IDM_DIALOG_DELETE
				Invoke DeleteSelectedWindows
			.ElseIf EAX>=IDM_DIALOG_ALIGNLEFTS && EAX<=IDM_DIALOG_MAKESAMESIZE
				.If EAX==IDM_DIALOG_ALIGNLEFTS
					MOV EDX,Offset MultiAlignLefts
				.ElseIf EAX==IDM_DIALOG_ALIGNCENTERS
					MOV EDX,Offset MultiAlignCenters
				.ElseIf EAX==IDM_DIALOG_ALIGNWITHDIALOGCENTER
					MOV EDX,Offset MultiAlignCentersWithDialogCenter
				.ElseIf EAX==IDM_DIALOG_ALIGNRIGHTS
					MOV EDX,Offset MultiAlignRights
				.ElseIf EAX==IDM_DIALOG_ALIGNTOPS
					MOV EDX,Offset MultiAlignTops
				.ElseIf EAX==IDM_DIALOG_ALIGNMIDDLES
					MOV EDX,Offset MultiAlignMiddles
				.ElseIf EAX==IDM_DIALOG_ALIGNWITHDIALOGMIDDLE
					MOV EDX,Offset MultiAlignMiddlesWithDialogMiddle
				.ElseIf EAX==IDM_DIALOG_ALIGNBOTTOMS
					MOV EDX,Offset MultiAlignBottoms
				.ElseIf EAX==IDM_DIALOG_MAKESAMEWIDTH
					MOV EDX,Offset MultiMakeSameWidth
				.ElseIf EAX==IDM_DIALOG_MAKESAMEHEIGHT
					MOV EDX,Offset MultiMakeSameHeight
				.ElseIf EAX==IDM_DIALOG_MAKESAMESIZE
					MOV EDX,Offset MultiMakeSameSize
				.EndIf
				
				Invoke EnumSelectedWindows,EDX
				;----------------------------------------------
				;Thanks Marwin
				;All this just to refresh static controls
				Invoke LockWindowUpdate,hADialog
				Invoke SetClipChildren,FALSE
				Invoke InvalidateRect,hADialog,NULL,TRUE
				Invoke UpdateWindow,hADialog
				Invoke SetClipChildren,TRUE
				Invoke LockWindowUpdate,0
				;----------------------------------------------
				
				Invoke SetRCModified,TRUE
				 
			.ElseIf EAX==IDM_DIALOG_BRINGONTOP
				Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
				.If EAX
					;I must also check if this is a control and NOT a dialog
					Invoke GetTreeItemParameter,hDialogsTree,EAX
					MOV EDI,EAX
					Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE
					Invoke ChangeZOrderOfControl,EDI,TVI_LAST
				.EndIf
			.ElseIf EAX==IDM_DIALOG_SENDTOBACK
				Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
				.If EAX
					;I must also check if this is a control and NOT a dialog
					Invoke GetTreeItemParameter,hDialogsTree,EAX
					MOV EDI,EAX
					Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,HWND_BOTTOM,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE
					Invoke ChangeZOrderOfControl,EDI,TVI_FIRST
				.EndIf
			.ElseIf EAX==IDM_DIALOG_TESTDIALOG
				Invoke TestDialog
			.ElseIf EAX==IDM_DIALOG_CONTROLSMANAGER
				Invoke EnableAllDockWindows,FALSE
				Invoke EnableWindow,hFind,FALSE
				Invoke DialogBoxParam,hUILib,219,WinAsmHandles.hMain,Offset ControlsManagerManagerProc,1
				Invoke EnableWindow,hFind,TRUE
				Invoke EnableAllDockWindows,TRUE
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_DESTROY
		Invoke ImageList_Destroy,hImlRCOptions
		Invoke ImageList_Destroy,hImlRCOptionsDisabled
	.EndIf
	Invoke CallWindowProc,ADDR DockWndProc,hWnd,uMsg,wParam,lParam
	RET
OptionsProc EndP

ParseRC Proc Uses ESI EDI lpRCMem:DWORD,lpProMem:DWORD

	MOV ESI,lpRCMem
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX

	;PrintString ThisWord
	
	;In case NonCompatibleScriptMessage will be needed 
	MOV EDI,ESI

	Invoke lstrcmpi,Offset ThisWord,Offset szDEFINE
	.If !EAX
		Invoke ParseDefine,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf


	Invoke lstrcmpi,Offset ThisWord,Offset szINCLUDE
	.If !EAX
		Invoke ParseInclude,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szSTRINGTABLE
	.If !EAX
		Invoke ExtractStringTable,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szLANGUAGE
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		JMP Ex
	.EndIf



	;-------------------------------------------------------------------------
	;Ignore these 	( VC++ statements ;) ;) )
	Invoke lstrcmpi,Offset ThisWord,Offset szUNDEF
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szif
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szifdef
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szpragma
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szifndef
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szendif
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szelif
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szelse
	.If !EAX
		;Chew Whole line
		.While BYTE PTR [ESI] && (BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=0Dh)
			INC ESI
		.EndW
		JMP Ex
	.EndIf


	;-------------------------------------------------------------------------


	Invoke lstrcpy,Offset NameBuffer,Offset ThisWord
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	
	Invoke lstrcmpi,Offset ThisWord,Offset szDIALOGEX
	.If !EAX
		Invoke ExtractDialogEx,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szDIALOG
	.If !EAX
		Invoke ExtractDialog,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szVERSIONINFO
	.If !EAX
		Invoke ExtractVersionInfo,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szBITMAP
	.If !EAX
		Invoke ParseResource,ESI,lpProMem,0
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szCURSOR
	.If !EAX
		Invoke ParseResource,ESI,lpProMem,1
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szICON
	.If !EAX
		Invoke ParseResource,ESI,lpProMem,2
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szAVI
	.If !EAX
		Invoke ParseResource,ESI,lpProMem,3
		ADD ESI,EAX
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szMANIFEST
	.If !EAX
		Invoke ParseResource,ESI,lpProMem,4
		ADD ESI,EAX
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szWAVE
	.If !EAX
		Invoke ParseResource,ESI,lpProMem,5
		ADD ESI,EAX
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szRCDATA
	.If !EAX
		Invoke ParseResource,ESI,lpProMem,6
		ADD ESI,EAX
		JMP Ex
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szACCELERATORS
	.If !EAX
		Invoke ExtractAccelerators,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szMENU
	.If !EAX
		Invoke ExtractMenu,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szMENUEX
	.If !EAX
		Invoke ExtractMenuEx,ESI,lpProMem
		ADD ESI,EAX
		JMP Ex
	.EndIf
	
	;VC++ statement ;) ;)
	Invoke lstrcmpi,Offset ThisWord,Offset szTEXTINCLUDE
	.If !EAX
		;Chew everything until "END" is found"
		@@:
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szEND
		.If EAX
			JMP @B
		.EndIf
		JMP Ex
	.EndIf
	

	
	.If NameBuffer[0]!=0
		.If !bRCSilent
			Invoke NonCompatibleScriptMessage,EDI
			XOR EAX,EAX	;So that it stops parsing resources
			RET
		.EndIf
	.EndIf
	

	Ex:
	;--
	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ParseRC EndP

ExtractResources Proc Uses ESI hRCMem:DWORD, lpProMem:DWORD

	Invoke GetCursor
	PUSH EAX
	Invoke LoadCursor,NULL,IDC_APPSTARTING
	Invoke SetCursor,EAX
	
	Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szLoadingResources
	
	MOV ESI,hRCMem
	.While TRUE
		Invoke ParseRC,ESI,lpProMem
		.Break .If !EAX
		ADD ESI,EAX
	.EndW

	Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szNULL
	
	POP EAX
	Invoke SetCursor,EAX
	
	RET
ExtractResources EndP

GetResources Proc Uses EBX EDI ESI
Local Buffer[256]:BYTE
	Invoke EnableDisableRC
	Invoke SendMessage,hToolBoxToolBar,TB_ENABLEBUTTON,IDM_TOOLBOX_DIALOG,TRUE
	
	Invoke EnableAllButtonsOnRCOptions,TRUE
	

	Invoke ShowVisualRC,hRCEditorWindow
	Invoke DoEvents

	Invoke EnableAllButtonsOnAddResourcesToolbar,TRUE

	Invoke GetWindowLong,hRCEditorWindow,0
	MOV EBX,EAX
	LEA ECX,CHILDWINDOWDATA.szFileName[EBX]
	Invoke GetFilePath,ECX,ADDR Buffer
	MOV BYTE PTR [EDX+EAX],0
	Invoke SetCurrentDirectory,ADDR Buffer

	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],WM_GETTEXTLENGTH,0,0
	.If EAX<64*1024
		MOV EAX,32*1024
	.EndIf
	MOV EDI,EAX
	SHL EDI,1	;i.e. twice as much for safety reasons
	
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,EDI
	MOV ESI,EAX
	MOV StartOfBlock,ESI
	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],WM_GETTEXT,EDI,ESI
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
	MOV lpDefinesMem,EAX
	
	MOV HighestAcceleratorID,0
	MOV HighestVersionInfoID,0
	MOV HighestWindowDialogID,1000
	Invoke ExtractResources,ESI,EAX


	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_ROOT,0
	.If EAX
		MOV EBX,EAX
		Invoke GetTreeItemParameter,hDialogsTree,EBX
		;EAX holds the handle of a Dialog
		MOV EDI,EAX
		M2M hADialog,[EDI].CONTROLDATA.hWnd
		Invoke ShowWindow,[EDI].CONTROLDATA.hWnd,SW_SHOW
		
		Invoke SetClipChildren,TRUE
		
		Invoke SendMessage,hPropertiesList,LVM_DELETEALLITEMS,0,0
		
	.EndIf
	
	Invoke HeapFree,hMainHeap,0,ESI
	
	RET
GetResources EndP

GenerateResourceScript Proc Uses EBX ESI EDI fFreeAll:BOOLEAN
Local tvi				:TVITEM
Local Buffer[256]		:BYTE
Local hExtractedDialog	:DWORD
Local hControlItem		:DWORD
	
	MOV tvi._mask,TVIF_PARAM
	;Invoke LocalAlloc,LPTR,1024*1024
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,2048*1024;1024*1024
	MOV ESI,EAX
	PUSH ESI
	
	;------------------------------------------------------------------------
	;Set Title "Generated by...."
	Invoke lstrcpy,ESI,Offset szGeneratedBy
	Invoke lstrlen,ADDR szGeneratedBy
	ADD ESI,EAX

	MOV BYTE PTR [ESI],0Dh
	INC ESI
	
	;------------------------------------------------------------------------
	;Get Included Files
	;------------------
	MOV EAX,hIncludesParentItem
	.If EAX
		MOV tvi.hItem,EAX
		Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
		MOV EDI,tvi.lParam; is the Window memory
		.While [EDI].INCLUDEMEM.szfile
			Invoke lstrcpy,ESI,Offset szINCLUDE
			Invoke lstrlen,Offset szINCLUDE
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			Invoke lstrcpy,ESI,ADDR [EDI].INCLUDEMEM.szfile
			Invoke lstrlen,ADDR [EDI].INCLUDEMEM.szfile
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			ADD EDI,SizeOf INCLUDEMEM
		.EndW
		MOV BYTE PTR [ESI],0Dh
		INC ESI
	.EndIf
	
	;------------------------------------------------------------------------
	;Get Defines
	;-----------
	MOV EDI,lpDefinesMem
	.If EDI
		.While [EDI].DEFINE.szName
			.If [EDI].DEFINE.ReferenceCount
				Invoke lstrcpy,ESI,Offset szDEFINE
				Invoke lstrlen,Offset szDEFINE
				ADD ESI,EAX
				
				MOV BYTE PTR [ESI]," "
				INC ESI
				
				Invoke lstrcpy,ESI,ADDR [EDI].DEFINE.szName
				Invoke lstrlen,ADDR [EDI].DEFINE.szName
				ADD ESI,EAX
				
				MOV BYTE PTR [ESI]," "
				INC ESI
				
				Invoke BinToDec,[EDI].DEFINE.dwValue,ADDR Buffer
				Invoke lstrcpy,ESI,ADDR Buffer
				Invoke lstrlen,ADDR Buffer
				ADD ESI,EAX
				
				MOV BYTE PTR [ESI],0Dh
				INC ESI
			.EndIf
			ADD EDI,SizeOf DEFINE
		.EndW
		MOV BYTE PTR [ESI],0Dh
		INC ESI
	.EndIf
	;------------------------------------------------------------------------
	;Get Resources (Bitmaps,Icons,etc)
	;-------------
	.If lpResourcesMem
		MOV EDI,lpResourcesMem
		.While [EDI].RESOURCEMEM.szFile
			LEA EAX,[EDI].RESOURCEMEM.szName
			.If BYTE PTR [EAX]==0
				Invoke BinToDec,[EDI].RESOURCEMEM.Value,ADDR Buffer
				LEA EAX,Buffer
			.EndIf
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			;0=Bitmap,1=Cursor,2=Icon,3=Avi,4=Manifest,5=wave,6=Raw Data
			.If [EDI].RESOURCEMEM.nType==0
				LEA EAX,szBITMAP
			.ElseIf [EDI].RESOURCEMEM.nType==1
				LEA EAX,szCURSOR
			.ElseIf [EDI].RESOURCEMEM.nType==2
				LEA EAX,szICON
			.ElseIf [EDI].RESOURCEMEM.nType==3
				LEA EAX,szAVI
			.ElseIf [EDI].RESOURCEMEM.nType==4
				LEA EAX,szMANIFEST
			.ElseIf [EDI].RESOURCEMEM.nType==5
				LEA EAX,szWAVE
			.Else;If [EDI].RESOURCEMEM.nType==6
				LEA EAX,szRCDATA
			.EndIf
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szDISCARDABLE
			Invoke lstrlen,Offset szDISCARDABLE
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			Invoke lstrcpy,ESI,ADDR [EDI].RESOURCEMEM.szFile
			Invoke lstrlen,ADDR [EDI].RESOURCEMEM.szFile
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			ADD EDI,SizeOf RESOURCEMEM
		.EndW
		MOV BYTE PTR [ESI],0Dh
		INC ESI
	.EndIf

	;------------------------------------------------------------------------
	;Get Menus
	;---------
	.If hMenusParentItem
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_CHILD,hMenusParentItem
		MoreMenus:
		;----------
		.If EAX	;This is a Menu hItem
			MOV EBX,EAX
			MOV tvi.hItem,EBX
			Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
			MOV EDI,tvi.lParam; is the Menu memory
			
			LEA EAX,[EDI].MNUHEAD.szMenuName
			.If BYTE PTR [EAX]!=0
				Invoke lstrcpy,ESI,ADDR [EDI].MNUHEAD.szMenuName
				Invoke lstrlen,ADDR [EDI].MNUHEAD.szMenuName
			.Else
				Invoke BinToDec,[EDI].MNUHEAD.MenuID,ADDR Buffer
				Invoke lstrcpy,ESI,ADDR Buffer
				Invoke lstrlen,ADDR Buffer
			.EndIf
			ADD ESI,EAX
			MOV BYTE PTR [ESI]," "
			INC ESI
			Invoke lstrcpy,ESI,Offset szMENUEX
			Invoke lstrlen,Offset szMENUEX
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szDISCARDABLE
			Invoke lstrlen,Offset szDISCARDABLE
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			Invoke lstrcpy,ESI,Offset szBEGIN
			Invoke lstrlen,Offset szBEGIN
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;Menu Items go here
			ADD EDI,SizeOf MNUHEAD
			.While [EDI].MNUITEM.Flag
				MOV ECX,[EDI].MNUITEM.Level
				MOV EAX,ECX
				MoreTabs:
				MOV BYTE PTR [ESI],VK_TAB
				INC ESI
				.If ECX
					DEC ECX
					JMP MoreTabs
				.EndIf
				;PrintDec EDI
				.If [EDI+SizeOf MNUITEM].MNUITEM.Level>EAX	;If Level of next item is gretaer
					Invoke lstrcpy,ESI,Offset szPOPUP
					Invoke lstrlen,Offset szPOPUP
					ADD ESI,EAX
				.Else
					Invoke lstrcpy,ESI,Offset szMENUITEM
					Invoke lstrlen,Offset szMENUITEM
					ADD ESI,EAX
				.EndIf
				;PrintDec EDI
				MOV BYTE PTR [ESI]," "
				INC ESI
				MOV BYTE PTR [ESI],'"'
				INC ESI
				Invoke lstrcmpi,ADDR [EDI].MNUITEM.szCaption,CTEXT("-")
				.If EAX	;i.e Caption is not - 
					Invoke lstrcpy,ESI,ADDR [EDI].MNUITEM.szCaption
					Invoke lstrlen,ADDR [EDI].MNUITEM.szCaption
					ADD ESI,EAX
					Invoke GetStringFromAccel,[EDI].MNUITEM.Shortcut,ADDR Buffer
					.If Buffer[0]!=0
						MOV WORD PTR [ESI],'t\'
						ADD ESI,2
						Invoke lstrcpy,ESI,ADDR Buffer
						Invoke lstrlen,ADDR Buffer
						ADD ESI,EAX
					.EndIf
					
				.Else
					OR [EDI].MNUITEM.nType,MFT_SEPARATOR
				.EndIf
				MOV BYTE PTR [ESI],'"'
				INC ESI
				
				LEA EAX,[EDI].MNUITEM.szName
				.If BYTE PTR [EAX]==0
					.If [EDI].MNUITEM.ID==0
						JMP NameAndIDFinshed	;Actually no Name or ID Will be inserted (only the comma)
					.EndIf
					Invoke BinToDec,[EDI].MNUITEM.ID,ADDR Buffer
					LEA EAX,Buffer
				.EndIf
				
				MOV BYTE PTR [ESI],","
				INC ESI
				
				PUSH EAX
				Invoke lstrcpy,ESI,EAX
				POP EAX
				Invoke lstrlen,EAX
				ADD ESI,EAX
				
				NameAndIDFinshed:
				.If [EDI].MNUITEM.nType
					LEA EAX,[EDI].MNUITEM.szName
					.If BYTE PTR [EAX]==0
						.If [EDI].MNUITEM.ID==0
							MOV BYTE PTR [ESI],","
							INC ESI
						.EndIf
					.EndIf
					MOV BYTE PTR [ESI],","
					INC ESI
					
					Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].MNUITEM.nType
					Invoke lstrcpy,ESI,ADDR Buffer
					Invoke lstrlen,ADDR Buffer
					ADD ESI,EAX
				.EndIf
				
				.If [EDI].MNUITEM.nState
					LEA EAX,[EDI].MNUITEM.szName
					.If BYTE PTR [EAX]==0
						.If [EDI].MNUITEM.ID==0
							MOV BYTE PTR [ESI],","
							INC ESI
						.EndIf
					.EndIf
					.If ![EDI].MNUITEM.nType
						MOV BYTE PTR [ESI],","
						INC ESI
					.EndIf
					MOV BYTE PTR [ESI],","
					INC ESI
					Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].MNUITEM.nState
					Invoke lstrcpy,ESI,ADDR Buffer
					Invoke lstrlen,ADDR Buffer
					ADD ESI,EAX
				.EndIf
				
				MOV EAX,[EDI].MNUITEM.Level				
				.If [EDI+SizeOf MNUITEM].MNUITEM.Level>EAX	;If Level of next item is gretaer
					MOV BYTE PTR [ESI],0Dh
					INC ESI
					
					SomeMoreTabs:
					MOV BYTE PTR [ESI],VK_TAB
					INC ESI
					.If EAX
						DEC EAX
						JMP SomeMoreTabs
					.EndIf
					
					Invoke lstrcpy,ESI,Offset szBEGIN
					Invoke lstrlen,Offset szBEGIN
					ADD ESI,EAX
					MOV BYTE PTR [ESI],0Dh
					INC ESI
					
				.ElseIf [EDI+SizeOf MNUITEM].MNUITEM.Level<EAX
					MOV BYTE PTR [ESI],0Dh
					INC ESI
					
					MOV ECX,EAX
					SUB EAX,[EDI+SizeOf MNUITEM].MNUITEM.Level
					
					MoreENDs:
					.If EAX	;Normally EAX should never be 0 at the first round
						DEC EAX
						
						PUSH ECX
						
						YetMoreTabs:
						.If ECX>=1
							DEC ECX
							MOV BYTE PTR [ESI],VK_TAB
							INC ESI
							JMP YetMoreTabs
						.EndIf
						
						PUSH EAX
						Invoke lstrcpy,ESI,Offset szEND
						Invoke lstrlen,Offset szEND
						ADD ESI,EAX
						POP EAX
						MOV BYTE PTR [ESI],0Dh
						INC ESI
						
						;Must be here and not before Invoke lstrcpy,ESI,Offset szEND and Invoke lstrlen,Offset szEND
						;Thanks golemxiii
						POP ECX
						DEC ECX
						
						JMP MoreENDs
					.EndIf
					
				.Else
					MOV BYTE PTR [ESI],0Dh
					INC ESI
				.EndIf
				
				ADD EDI,SizeOf MNUITEM
			.EndW
			
			Invoke lstrcpy,ESI,Offset szEND
			Invoke lstrlen,Offset szEND
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			MOV BYTE PTR [ESI],0Dh
			INC ESI
		.Else
			JMP NoMoreMenus
		.EndIf
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_NEXT,EBX
		JMP MoreMenus
	.EndIf
	
	NoMoreMenus:
	;------------------------------------------------------------------------
	;Get Dialogs and Controls
	;------------------------
	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_ROOT,0
	MoreDialogs:
	;----------
	.If EAX	;This is a Dialog hItem
		MOV EBX,EAX
		MOV tvi.hItem,EBX
		Invoke SendMessage,hDialogsTree,TVM_GETITEM,0,ADDR tvi
		MOV EDI,tvi.lParam; is the Window memory
		M2M hExtractedDialog,[EDI].CONTROLDATA.hWnd
		LEA EAX,[EDI].CONTROLDATA.IDName
		.If BYTE PTR [EAX]==0
			Invoke BinToDec,[EDI].CONTROLDATA.ID,ADDR Buffer
			LEA EAX,Buffer
		.EndIf
		
		PUSH EAX
		Invoke lstrcpy,ESI,EAX
		POP EAX
		Invoke lstrlen,EAX
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI]," "
		INC ESI
		
		Invoke lstrcpy,ESI,Offset szDIALOGEX
		Invoke lstrlen,Offset szDIALOGEX
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI]," "
		INC ESI
		Invoke BinToDec,[EDI].CONTROLDATA.dux,ADDR Buffer
		
		Invoke lstrcpy,ESI,ADDR Buffer
		Invoke lstrlen,ADDR Buffer
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],","
		INC ESI
		Invoke BinToDec,[EDI].CONTROLDATA.duy,ADDR Buffer
		
		Invoke lstrcpy,ESI,ADDR Buffer
		Invoke lstrlen,ADDR Buffer
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],","
		INC ESI
		Invoke BinToDec,[EDI].CONTROLDATA.duccx,ADDR Buffer
		Invoke lstrcpy,ESI,ADDR Buffer
		Invoke lstrlen,ADDR Buffer
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],","
		INC ESI
		Invoke BinToDec,[EDI].CONTROLDATA.duccy,ADDR Buffer
		
		Invoke lstrcpy,ESI,ADDR Buffer
		Invoke lstrlen,ADDR Buffer
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],0Dh
		INC ESI
		
		LEA EAX,[EDI].CONTROLDATA.Caption
		.If BYTE PTR [EAX]!=0
			Invoke lstrcpy,ESI,Offset szCAPTION
			Invoke lstrlen,Offset szCAPTION
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			Invoke lstrcpy,ESI,ADDR [EDI].CONTROLDATA.Caption
			Invoke lstrlen,ADDR [EDI].CONTROLDATA.Caption
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
		.EndIf
		Invoke lstrcpy,ESI,Offset szFONT
		Invoke lstrlen,Offset szFONT
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI]," "
		INC ESI
		Invoke BinToDec,[EDI].DIALOGDATA.FontSize,ADDR Buffer
		
		Invoke lstrcpy,ESI,ADDR Buffer
		Invoke lstrlen,ADDR Buffer
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],","
		INC ESI
		
		MOV BYTE PTR [ESI],'"'
		INC ESI
		
		Invoke lstrcpy,ESI,ADDR [EDI].DIALOGDATA.FontName
		Invoke lstrlen,ADDR [EDI].DIALOGDATA.FontName
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],'"'
		INC ESI
		
		;------------------------------------------------------
		.If [EDI].DIALOGDATA.FontWeight && [EDI].DIALOGDATA.FontWeight!=400
			MOV BYTE PTR [ESI],","
			INC ESI
			Invoke BinToDec,[EDI].DIALOGDATA.FontWeight,ADDR Buffer
			LEA EAX,Buffer
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
		.EndIf
		
		.If [EDI].DIALOGDATA.FontItalic
			.If ![EDI].DIALOGDATA.FontWeight || [EDI].DIALOGDATA.FontWeight==400
				MOV WORD PTR [ESI],"0,"
				;INC ESI
				ADD ESI,2
			.EndIf
			MOV BYTE PTR [ESI],","
			INC ESI
			Invoke BinToDec,[EDI].DIALOGDATA.FontItalic,ADDR Buffer
			LEA EAX,Buffer
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
		.EndIf
		
		.If [EDI].DIALOGDATA.Charset
			.If ![EDI].DIALOGDATA.FontItalic
				MOV WORD PTR [ESI],"0,"
				;INC ESI
				ADD ESI,2
				.If ![EDI].DIALOGDATA.FontWeight || [EDI].DIALOGDATA.FontWeight==400
					MOV WORD PTR [ESI],"0,"
					;INC ESI
					ADD ESI,2
				.EndIf
			.EndIf
			
			MOV BYTE PTR [ESI],","
			INC ESI
			Invoke BinToDec,[EDI].DIALOGDATA.Charset,ADDR Buffer
			LEA EAX,Buffer
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
		.EndIf
		
		;------------------------------------------------------
		MOV BYTE PTR [ESI],0Dh
		INC ESI
		
		LEA EAX,[EDI].CONTROLDATA.MenuID
		.If BYTE PTR [EAX]!=0
			Invoke lstrcpy,ESI,Offset szMENU
			Invoke lstrlen,Offset szMENU
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke lstrcpy,ESI,ADDR [EDI].CONTROLDATA.MenuID
			Invoke lstrlen,ADDR [EDI].CONTROLDATA.MenuID
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
		.EndIf
		
		LEA EAX,[EDI].CONTROLDATA.Class
		.If BYTE PTR [EAX]!=0
			Invoke lstrcpy,ESI,Offset szCLASS
			Invoke lstrlen,Offset szCLASS
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			Invoke lstrcpy,ESI,ADDR [EDI].CONTROLDATA.Class
			Invoke lstrlen,ADDR [EDI].CONTROLDATA.Class
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
		.EndIf
		
		Invoke lstrcpy,ESI,Offset szSTYLE
		Invoke lstrlen,Offset szSTYLE
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI]," "
		INC ESI
		Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].CONTROLDATA.Style
		
		Invoke lstrcpy,ESI,ADDR Buffer
		Invoke lstrlen,ADDR Buffer
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],0Dh
		INC ESI
		
		Invoke lstrcpy,ESI,Offset szEXSTYLE
		Invoke lstrlen,Offset szEXSTYLE
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI]," "
		INC ESI
		
		Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].CONTROLDATA.ExStyle
		Invoke lstrcpy,ESI,ADDR Buffer
		Invoke lstrlen,ADDR Buffer
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI],0Dh
		INC ESI
		
		Invoke lstrcpy,ESI,Offset szBEGIN
		Invoke lstrlen,Offset szBEGIN
		ADD ESI,EAX
		
		.If fFreeAll
			Invoke DeleteObject,[EDI].CONTROLDATA.hFont
			Invoke HeapFree,hMainHeap,0,EDI
		.EndIf
		
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CHILD,EBX
		MoreControls:
		;-----------
		.If EAX	;This is a Control hItem
			MOV hControlItem,EAX
			MOV tvi.hItem,EAX
			
			Invoke SendMessage,hDialogsTree,TVM_GETITEM,0,ADDR tvi
			MOV EDI,tvi.lParam; is the Control memory
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szCONTROL
			Invoke lstrlen,Offset szCONTROL
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			Invoke lstrcpy,ESI,ADDR [EDI].CONTROLDATA.Caption
			Invoke lstrlen,ADDR [EDI].CONTROLDATA.Caption
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			LEA EAX,[EDI].CONTROLDATA.IDName
			.If BYTE PTR [EAX]==0
				Invoke BinToDec,[EDI].CONTROLDATA.ID,ADDR Buffer
				LEA EAX,Buffer
			.EndIf
			
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			.If [EDI].CONTROLDATA.ntype==1		;Static
				LEA EAX,szStaticClass
			.ElseIf [EDI].CONTROLDATA.ntype==2	;Edit
				LEA EAX,szEditClass
			.ElseIf [EDI].CONTROLDATA.ntype==3	;GroupBox
				LEA EAX,szButtonClass
			.ElseIf [EDI].CONTROLDATA.ntype==4	;BS_PUSHBUTTON & BS_DEFPUSHBUTTON
				LEA EAX,szButtonClass
			.ElseIf [EDI].CONTROLDATA.ntype==5	;BS_AUTOCHECKBOX
				LEA EAX,szButtonClass
			.ElseIf [EDI].CONTROLDATA.ntype==6	;BS_RADIOBUTTON
				LEA EAX,szButtonClass
			.ElseIf [EDI].CONTROLDATA.ntype==7	;ComboBox
				LEA EAX,szComboBoxClass
			.ElseIf [EDI].CONTROLDATA.ntype==8	;ListBox
				LEA EAX,szListBoxClass
			.ElseIf [EDI].CONTROLDATA.ntype==9	;Horizontal Scrollbar
				LEA EAX,szScrollBarClass
			.ElseIf [EDI].CONTROLDATA.ntype==10	;Vertical Scrollbar
				LEA EAX,szScrollBarClass
			.ElseIf [EDI].CONTROLDATA.ntype==11	;TabControl
				LEA EAX,szTabControlClass
			.ElseIf [EDI].CONTROLDATA.ntype==12	;ToolBar
				LEA EAX,szToolBarClass
			.ElseIf [EDI].CONTROLDATA.ntype==13	;StatusBar
				LEA EAX,szStatusBarClass
			.ElseIf [EDI].CONTROLDATA.ntype==14	;ProgressBar
				LEA EAX,szProgressBarClass
			.ElseIf [EDI].CONTROLDATA.ntype==15	;Rebar
				LEA EAX,szReBarClass
			.ElseIf [EDI].CONTROLDATA.ntype==16	;UpDown
				LEA EAX,szUpDownClass
			.ElseIf [EDI].CONTROLDATA.ntype==17	;TreeView
				LEA EAX,szTreeViewClass
			.ElseIf [EDI].CONTROLDATA.ntype==18	;ListView
				LEA EAX,szListViewClass
			.ElseIf [EDI].CONTROLDATA.ntype==19	;TrackBar
				LEA EAX,szTrackBarClass
			.ElseIf [EDI].CONTROLDATA.ntype==20	;RichEdit
				LEA EAX,szRichEditClass
			.ElseIf [EDI].CONTROLDATA.ntype==21	|| [EDI].CONTROLDATA.ntype==22	;Image OR Shape
				LEA EAX,szStaticClass
			.ElseIf [EDI].CONTROLDATA.ntype==23 || [EDI].CONTROLDATA.ntype==24
				LEA EAX,[EDI].CONTROLDATA.Class
			.EndIf
			
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			MOV BYTE PTR [ESI],","
			INC ESI
			.If [EDI].CONTROLDATA.NotStyle
				Invoke lstrcpy,ESI,ADDR szNOT
				Invoke lstrlen,ADDR szNOT
				ADD ESI,EAX
				MOV BYTE PTR [ESI]," "
				INC ESI
				
				Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].CONTROLDATA.NotStyle
				Invoke lstrcpy,ESI,ADDR Buffer
				Invoke lstrlen,ADDR Buffer
				ADD ESI,EAX
				MOV WORD PTR [ESI],"| "
				ADD ESI,2
				MOV BYTE PTR [ESI]," "
				INC ESI
				
			.EndIf
			
			Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].CONTROLDATA.Style
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			Invoke BinToDec,[EDI].CONTROLDATA.dux,ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].CONTROLDATA.duy,ADDR Buffer
			
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].CONTROLDATA.duccx,ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].CONTROLDATA.duccy,ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].CONTROLDATA.ExStyle
			
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			.If fFreeAll
				.If [EDI].CONTROLDATA.ntype==21 && [EDI].CONTROLDATA.hImg
					Invoke DeleteObject,[EDI].CONTROLDATA.hImg
				.EndIf
				Invoke HeapFree,hMainHeap,0,EDI
			.EndIf
		.Else
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szEND
			Invoke lstrlen,Offset szEND
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
				
			.If fFreeAll
				Invoke DestroyWindow,hExtractedDialog	;The Dialog Window handle
			.EndIf
			JMP ControlsFinished
		.EndIf
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_NEXT,hControlItem
		JMP MoreControls
	.Else
		JMP DialogsFinished
	.EndIf
	
	ControlsFinished:
	;----------------
	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_NEXT,EBX
	JMP MoreDialogs
	
	DialogsFinished:
	;------------------------------------------------------------------------
	;Get Accelerators
	;----------------
	.If hAccelTablesParentItem
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_CHILD,hAccelTablesParentItem
		MoreAccelTables:
		.If EAX
			;EAX is the AccelTable hItem
			MOV EBX,EAX
			MOV tvi.hItem,EBX
			Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
			MOV EDI,tvi.lParam
			
			LEA EAX,[EDI].ACCELMEM.szName
			.If BYTE PTR [EAX]==0
				Invoke BinToDec,[EDI].ACCELMEM.Value,ADDR Buffer
				LEA EAX,Buffer
			.EndIf
			PUSH EAX
			Invoke lstrcpy,ESI,EAX;ADDR [EDI].ACCELMEM.szName
			POP EAX
			Invoke lstrlen,EAX;ADDR [EDI].ACCELMEM.szName
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szACCELERATORS
			Invoke lstrlen,Offset szACCELERATORS
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szBEGIN
			Invoke lstrlen,Offset szBEGIN
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			LEA EDI,[EDI+SizeOf ACCELMEM]
			.While BYTE PTR [EDI].ACCELMEM.szName || [EDI].ACCELMEM.Value
				MOV BYTE PTR [ESI],VK_TAB
				INC ESI
				
				;Find Accelerator String
				PUSH EBX
				MOV EBX,[EDI].ACCELMEM.nkey
				PUSH ESI
				PUSH EDI
				MOV ESI,Offset szAclKeys
				XOR EDI,EDI
				@@:
				.If EDI!=EBX
					INC ESI
					Invoke lstrlen,ESI
					ADD ESI,EAX
					INC ESI
					INC EDI
					JMP @B
				.Else
					INC ESI
				.EndIf
				
				;Found at ESI!
				MOV EAX,ESI
				POP EDI
				POP ESI
				POP EBX
				
				PUSH EAX
				Invoke lstrcpy,ESI,EAX
				POP EAX
				Invoke lstrlen,EAX
				ADD ESI,EAX
				
				MOV BYTE PTR [ESI],","
				INC ESI
				MOV BYTE PTR [ESI]," "
				INC ESI
				
				LEA EAX,[EDI].ACCELMEM.szName
				.If BYTE PTR [EAX]==0
					Invoke BinToDec,[EDI].ACCELMEM.Value,ADDR Buffer
					LEA EAX,Buffer
				.EndIf
				PUSH EAX
				Invoke lstrcpy,ESI,EAX
				POP EAX
				Invoke lstrlen,EAX
				ADD ESI,EAX
				MOV BYTE PTR [ESI],","
				INC ESI
				MOV BYTE PTR [ESI]," "
				INC ESI
				
				Invoke lstrcpy,ESI,Offset szVIRTKEY
				Invoke lstrlen,Offset szVIRTKEY
				ADD ESI,EAX
				MOV BYTE PTR [ESI],","
				INC ESI
				MOV BYTE PTR [ESI]," "
				INC ESI
				
				Invoke lstrcpy,ESI,Offset szNOINVERT
				Invoke lstrlen,Offset szNOINVERT
				ADD ESI,EAX
				
				
				MOV EAX,[EDI].ACCELMEM.flag
				.If EAX
					AND EAX,1 
					;0=Nothing,1=Control,2=Shift,4=ALT
					.If EAX
						MOV BYTE PTR [ESI],","
						INC ESI
						MOV BYTE PTR [ESI]," "
						INC ESI
						Invoke lstrcpy,ESI,Offset szCONTROL
						Invoke lstrlen,Offset szCONTROL
						ADD ESI,EAX
					.EndIf
					
					MOV EAX,[EDI].ACCELMEM.flag
					AND EAX,4 
					;0=Nothing,1=Control,2=Shift,4=ALT
					.If EAX
						MOV BYTE PTR [ESI],","
						INC ESI
						MOV BYTE PTR [ESI]," "
						INC ESI
						Invoke lstrcpy,ESI,Offset szALT
						Invoke lstrlen,Offset szALT
						ADD ESI,EAX
					.EndIf

					
					MOV EAX,[EDI].ACCELMEM.flag
					AND EAX,2 
					;0=Nothing,1=Control,2=Shift,4=ALT
					.If EAX
						MOV BYTE PTR [ESI],","
						INC ESI
						MOV BYTE PTR [ESI]," "
						INC ESI
						Invoke lstrcpy,ESI,Offset szSHIFT
						Invoke lstrlen,Offset szSHIFT
						ADD ESI,EAX
					.EndIf
				.EndIf
				
				MOV BYTE PTR [ESI],0Dh
				INC ESI
				
				LEA EDI,[EDI+SizeOf ACCELMEM]
			.EndW
			
			Invoke lstrcpy,ESI,Offset szEND
			Invoke lstrlen,Offset szEND
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI	
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
		.Else
			JMP NoMoreAccelTables
		.EndIf
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_NEXT,EBX
		JMP MoreAccelTables
		
	.EndIf
	
	NoMoreAccelTables:
	
	;------------------------------------------------------------------------
	;Get StringTable
	;---------------
	.If lpStringTableMem
		;STRINGTABLE DISCARDABLE
		;BEGIN
		;  IDS_STRING1 "Hello World 1"
		;  IDS_STRING2 "Hello World 2"
		;  IDS_STRING3 "All Right"
		;END
		Invoke lstrcpy,ESI,Offset szSTRINGTABLE
		Invoke lstrlen,Offset szSTRINGTABLE
		ADD ESI,EAX
		
		MOV BYTE PTR [ESI]," "
		INC ESI
		
		Invoke lstrcpy,ESI,Offset szDISCARDABLE
		Invoke lstrlen,Offset szDISCARDABLE
		ADD ESI,EAX
		MOV BYTE PTR [ESI],0Dh
		INC ESI
		
		Invoke lstrcpy,ESI,Offset szBEGIN
		Invoke lstrlen,Offset szBEGIN
		ADD ESI,EAX
		MOV BYTE PTR [ESI],0Dh
		INC ESI
		
		MOV EDI,lpStringTableMem
		.While [EDI].STRINGMEM.szName || [EDI].STRINGMEM.Value
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			
			LEA EAX,[EDI].STRINGMEM.szName
			.If BYTE PTR [EAX]==0
				Invoke BinToDec,[EDI].STRINGMEM.Value,ADDR Buffer
				LEA EAX,Buffer
			.EndIf
			
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			MOV BYTE PTR [ESI],'"'
			INC ESI
			Invoke lstrcpy,ESI,ADDR [EDI].STRINGMEM.szString			
			
			Invoke lstrlen,ADDR [EDI].STRINGMEM.szString
			ADD ESI,EAX
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			LEA EDI,[EDI+SizeOf STRINGMEM]
		.EndW
		Invoke lstrcpy,ESI,Offset szEND
		Invoke lstrlen,Offset szEND
		ADD ESI,EAX
		MOV BYTE PTR [ESI],0Dh
		INC ESI
		
	.EndIf
	
	;------------------------------------------------------------------------
	;Get Version Info
	;----------------
	.If hVersionInfosParentItem
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_CHILD,hVersionInfosParentItem
		
		MoreVInfoItems:
		.If EAX
			;EAX is the  is the Version Info Memory
			MOV EBX,EAX
			MOV tvi.hItem,EBX
			Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
			MOV EDI,tvi.lParam;; is the Version Info Memory
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			LEA EAX,[EDI].VERSIONMEM.szName
			.If BYTE PTR [EAX]==0
				Invoke BinToDec,[EDI].VERSIONMEM.Value,ADDR Buffer
				LEA EAX,Buffer
			.EndIf
			PUSH EAX
			Invoke lstrcpy,ESI,EAX
			POP EAX
			Invoke lstrlen,EAX
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szVERSIONINFO
			Invoke lstrlen,Offset szVERSIONINFO
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;FILEVERSION 1,0,0,0
			Invoke lstrcpy,ESI,Offset szFILEVERSION
			Invoke lstrlen,Offset szFILEVERSION
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.fv[0],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.fv[4],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.fv[8],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.fv[12],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;PRODUCTVERSION 1,0,0,0
			Invoke lstrcpy,ESI,Offset szPRODUCTVERSION
			Invoke lstrlen,Offset szPRODUCTVERSION
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.pv[0],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.pv[4],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.pv[8],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],","
			INC ESI
			
			Invoke BinToDec,[EDI].VERSIONMEM.pv[12],ADDR Buffer
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;FILEOS 0x00000004
			Invoke lstrcpy,ESI,Offset szFILEOS
			Invoke lstrlen,Offset szFILEOS
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].VERSIONMEM.os
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;FILETYPE 0x00000000
			Invoke lstrcpy,ESI,Offset szFILETYPE
			Invoke lstrlen,Offset szFILETYPE
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI]," "
			INC ESI
			
			Invoke wsprintf, ADDR Buffer, Offset szColorTemplate, [EDI].VERSIONMEM.ft
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szBEGIN
			Invoke lstrlen,Offset szBEGIN
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szBLOCK
			Invoke lstrlen,Offset szBLOCK
			ADD ESI,EAX
			MOV BYTE PTR [ESI]," "
			INC ESI
			MOV BYTE PTR [ESI],'"'
			INC ESI
			Invoke lstrcpy,ESI,Offset szStringFileInfo
			Invoke lstrlen,Offset szStringFileInfo
			ADD ESI,EAX
			MOV BYTE PTR [ESI],'"'
			INC ESI
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szBEGIN
			Invoke lstrlen,Offset szBEGIN
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szBLOCK
			Invoke lstrlen,Offset szBLOCK
			ADD ESI,EAX
			MOV BYTE PTR [ESI]," "
			INC ESI
			MOV BYTE PTR [ESI],'"'
			INC ESI
			
			;Put 041F03B6 HERE
			.DATA
			sz04lX DB "%04lX",0
			.CODE
			Invoke wsprintf, ADDR Buffer, Offset sz04lX, [EDI].VERSIONMEM.lng
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			Invoke wsprintf, ADDR Buffer, Offset sz04lX, [EDI].VERSIONMEM.chs
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],'"'
			INC ESI
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szBEGIN
			Invoke lstrlen,Offset szBEGIN
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;VALUE "FileVersion", "1.0.0.0\0"
			;VALUE "ProductVersion", "1.0.0.0\0"
			PUSH EDI
			LEA EDI,[EDI+SizeOf VERSIONMEM]
			.While [EDI].VERSIONITEM.szName
				.If [EDI].VERSIONITEM.szValue
					MOV BYTE PTR [ESI],VK_TAB
					INC ESI
					MOV BYTE PTR [ESI],VK_TAB
					INC ESI
					MOV BYTE PTR [ESI],VK_TAB
					INC ESI
					Invoke lstrcpy,ESI,Offset szVALUE
					Invoke lstrlen,Offset szVALUE
					ADD ESI,EAX
					MOV BYTE PTR [ESI]," "
					INC ESI
					MOV BYTE PTR [ESI],'"'
					INC ESI
					Invoke lstrcpy,ESI,ADDR [EDI].VERSIONITEM.szName
					Invoke lstrlen,ADDR [EDI].VERSIONITEM.szName
					ADD ESI,EAX
					MOV BYTE PTR [ESI],'"'
					INC ESI
					MOV BYTE PTR [ESI],","
					INC ESI
					MOV BYTE PTR [ESI]," "
					INC ESI
					
					MOV BYTE PTR [ESI],'"'
					INC ESI
					Invoke lstrcpy,ESI,ADDR [EDI].VERSIONITEM.szValue
					Invoke lstrlen,ADDR [EDI].VERSIONITEM.szValue
					ADD ESI,EAX
					
					MOV WORD PTR [ESI],'0\'
					ADD ESI,2
					
					MOV BYTE PTR [ESI],'"'
					INC ESI
					
					MOV BYTE PTR [ESI],0Dh
					INC ESI
				.EndIf
				
				LEA EDI,[EDI+SizeOf VERSIONITEM]
			.EndW
			
			POP EDI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szEND
			Invoke lstrlen,Offset szEND
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szEND
			Invoke lstrlen,Offset szEND
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;BLOCK "VarFileInfo"
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szBLOCK
			Invoke lstrlen,Offset szBLOCK
			ADD ESI,EAX
			MOV BYTE PTR [ESI]," "
			INC ESI
			MOV BYTE PTR [ESI],'"'
			INC ESI
			Invoke lstrcpy,ESI,Offset szVarFileInfo
			Invoke lstrlen,Offset szVarFileInfo
			ADD ESI,EAX
			MOV BYTE PTR [ESI],'"'
			INC ESI
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szBEGIN
			Invoke lstrlen,Offset szBEGIN
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			;VALUE "Translation", 0x041F, 0x03B6
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			;VALUE
			Invoke lstrcpy,ESI,Offset szVALUE
			Invoke lstrlen,Offset szVALUE
			ADD ESI,EAX
			MOV BYTE PTR [ESI]," "
			INC ESI
			MOV BYTE PTR [ESI],'"'
			INC ESI
			Invoke lstrcpy,ESI,Offset szTranslation
			Invoke lstrlen,Offset szTranslation
			ADD ESI,EAX
			MOV BYTE PTR [ESI],'"'
			INC ESI
			MOV BYTE PTR [ESI],","
			INC ESI
			
			.DATA
			szHash04lX DB "%#04lx",0
			
			.CODE
			
			Invoke wsprintf, ADDR Buffer, Offset szHash04lX, [EDI].VERSIONMEM.lng
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			MOV BYTE PTR [ESI],","
			INC ESI
			MOV BYTE PTR [ESI]," "
			INC ESI
			Invoke wsprintf, ADDR Buffer, Offset szHash04lX, [EDI].VERSIONMEM.chs
			Invoke lstrcpy,ESI,ADDR Buffer
			Invoke lstrlen,ADDR Buffer
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			MOV BYTE PTR [ESI],VK_TAB
			INC ESI
			Invoke lstrcpy,ESI,Offset szEND
			Invoke lstrlen,Offset szEND
			ADD ESI,EAX
			MOV BYTE PTR [ESI],0Dh
			INC ESI
			
			Invoke lstrcpy,ESI,Offset szEND
			Invoke lstrlen,Offset szEND
			ADD ESI,EAX
			
			MOV BYTE PTR [ESI],0Dh
			INC ESI
;			MOV BYTE PTR [ESI],0Dh
;			INC ESI
		
		.Else
			JMP NoOtherVInfoItems
		.EndIf
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_NEXT,EBX
		JMP MoreVInfoItems
	.EndIf
	
	NoOtherVInfoItems:
	;----------------
	POP ESI
	.If RCModified
		Invoke GetWindowLong,hRCEditorWindow,0
		MOV EBX,EAX
		Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,WM_SETTEXT,0,ESI
	.EndIf
	Invoke HeapFree,hMainHeap,0,ESI
	
	RET
GenerateResourceScript EndP

ClearRCEditor Proc
	;This is very very important other wise crash if edit is visible and user closes the application
	Invoke ShowWindow,hEditProperties,SW_HIDE
	Invoke DeMultiSelect
	Invoke EnableControlsOnToolBox,FALSE
	Invoke GenerateResourceScript,TRUE
	Invoke SendMessage,hDialogsTree,TVM_DELETEITEM,0,TVI_ROOT
	Invoke SendMessage,hOthersTree,TVM_DELETEITEM,0,TVI_ROOT
	Invoke SendMessage,hPropertiesList,LVM_DELETEALLITEMS,0,0
	Invoke MoveWindow,hStylesBrowseButton,-100,0,0,0,TRUE

	MOV hOthersParentItem,0
	MOV hStringTableParentItem,0
	MOV hMenusParentItem,0
	MOV hIncludesParentItem,0
	MOV hResourcesParentItem,0
	MOV hAccelTablesParentItem,0
	MOV hVersionInfosParentItem,0

	Invoke HeapFree,hMainHeap,0,lpIncludesMem
	MOV lpIncludesMem,0
	Invoke HeapFree,hMainHeap,0,lpResourcesMem
	MOV lpResourcesMem,0
	Invoke HeapFree,hMainHeap,0,lpStringTableMem
	MOV lpStringTableMem,0
	Invoke HeapFree,hMainHeap,0,lpDefinesMem
	MOV lpDefinesMem,0
	
	MOV hADialog,0
	.If AutoToolAndOptions  &&  !fClosingProject
		Invoke ShowWindow,hToolBox,SW_HIDE
		Invoke ShowWindow,hRCOptions,SW_HIDE
	.EndIf

	Invoke EnableAllButtonsOnToolBox,FALSE
	
	Invoke EnableAllButtonsOnRCOptions,FALSE
	
	Invoke EnableAllButtonsOnAddResourcesToolbar,FALSE
	
	Invoke ShowCodeRC,hRCEditorWindow
	
	Invoke SetRCModified,FALSE
	
	MOV hRCEditorWindow,0

	;LOOOK!
	PUSH EDI
	MOV EDI,lpCustomControls
	@@:
	LEA ECX,[EDI].CUSTOMCONTROL.szFriendlyName
	.If BYTE PTR [ECX]
		.If [EDI].CUSTOMCONTROLEX.hLib
			Invoke FreeLibrary,[EDI].CUSTOMCONTROLEX.hLib
			MOV [EDI].CUSTOMCONTROLEX.hLib,0
		.EndIf
		MOV [EDI].CUSTOMCONTROLEX.ReferenceCount,0
		ADD EDI,SizeOf CUSTOMCONTROLEX
		JMP @B
	.EndIf
	POP EDI
	
	RET
ClearRCEditor EndP