CONTROLDATA STRUCT
	hWnd			HWND ?
	hTreeItem		HWND ?
	ntype			DWORD ?
	IDName			DB 64+1 DUP (?)
	ID				DWORD ?
	Caption			DB 241 DUP (?)
	hFont			HWND ?
	Style			DWORD ?
	NotStyle		DWORD ?
	ExStyle			DWORD ?
	Class			DB 32 DUP (?)		;Set to Null string
	MenuID			DB 32 DUP (?)		;Set to Null string
	dux				DWORD ?
	x				DWORD ?
	duy				DWORD ?
	y				DWORD ?
	duccx			DWORD ?
	ccx				DWORD ?
	duccy			DWORD ?
	ccy				DWORD ?
	hChild			DWORD ?
	hImg			DWORD ?
	ControlRect		RECT <?>
CONTROLDATA ENDS

DIALOGDATA STRUCT
	ControlData			CONTROLDATA <?>
	FontSize			DWORD	?				;Set to 8
	FontName			DB		32 DUP (?)		;Set to "MS Sans Serif"
	FontWeight			DWORD	?
	FontItalic			DWORD	?
	Charset				DWORD	?
	lpUndoRedoMemory	DWORD	?
	lpUndoRedoPointer	DWORD	?
DIALOGDATA  ENDS

VERSIONMEM STRUCT
	hTreeItem		DD ?
	szName			DB 32 DUP(?)
	Value			DD ?
	fv				DD ?
	fv1				DD ?
	fv2				DD ?
	fv3				DD ?
	pv				DD ?
	pv1				DD ?
	pv2				DD ?
	pv3				DD ?
	os				DD ?
	ft				DD ?
	lng				DD ?
	chs				DD ?
VERSIONMEM ENDS

ACCELMEM STRUCT
	hTreeItem		DWORD ?
	szName			DB 32 DUP(?)
	Value			DD ?
	nkey			DD ?
	flag			DD ?	;0=Nothing,1=Control,2=Shift,4=ALT
ACCELMEM ENDS

VERSIONITEM STRUCT
	szName			DB 64 DUP(?)
	szValue			DB 256 DUP(?)
VERSIONITEM ENDS

STRINGMEM STRUCT
	szName			DB 32 DUP(?)
	Value			DD ?
	szString		DB 256 DUP(?)
STRINGMEM ENDS

MNUHEAD STRUCT
	hTreeItem		DD ?
	szMenuName		DB 32 DUP(?)
	MenuID			DD ?
	NextMenuItemID	DD ?
MNUHEAD ENDS

MNUITEM STRUCT
	Flag			DD ?
	szName			DB 32 DUP(?)
	ID				DD ?
	szCaption		DB 64 DUP(?)
	Level			DD ?
	nType			DD ?
	nState			DD ?
	Shortcut		DD ?
MNUITEM ENDS

RESOURCEMEM STRUCT
	nType			DD ?				;0=Bitmap,1=Cursor,2=Icon,3=Avi,
 										;4=Manifest,5=WAVE
	szName			DB 32 DUP(?)
	Value			DD ?
	szFile			DB MAX_PATH DUP(?)
RESOURCEMEM ENDS

DoNewProject				PROTO :DWORD
DockWndProc					PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetResources				PROTO
ClearRCEditor				PROTO

AcceleratorsDialogProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD
ResourcesDialogProc			PROTO :DWORD,:DWORD,:DWORD,:DWORD
VersionInfoDialogProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD
StringTableDialogProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD
MenuEditDialogProc			PROTO :DWORD,:DWORD,:DWORD,:DWORD
IncludesDialogProc			PROTO :DWORD,:DWORD,:DWORD,:DWORD
DeleteMenuDefines 			PROTO :DWORD
DeleteDefine				PROTO :DWORD
DecToBin 					PROTO :DWORD
FindStyle					PROTO :DWORD,:DWORD
DeSelectWindow				PROTO :HWND
SelectWindow				PROTO :HWND,:DWORD
PrepareAndConvertToPixels	PROTO :DWORD
AddOrReplaceDefine 			PROTO :DWORD,:DWORD
HexToBin					PROTO :DWORD
DeleteSelectedWindows		PROTO
CreateDialogFont			PROTO :DWORD
DeMultiSelect				PROTO
DrawButton					PROTO :DWORD,:DWORD
SetImageOfStaticControl		PROTO :DWORD
CreateControl				PROTO :DWORD,:DWORD
ReCreateControl 			PROTO :DWORD
SetClipChildren 			PROTO :DWORD
HandleRCContextMenu			PROTO :DWORD,:DWORD,:HWND


AskToSaveFilesDialogProc	PROTO :DWORD,:DWORD,:DWORD,:DWORD
AddControl					PROTO :HWND, :DWORD, :DWORD, :DWORD, :DWORD

tbProperties				TBBUTTON <7,  IDM_TOOLBOX_DIALOG, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <0,  IDM_RCPROPERTIES_MENUS, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <1,  IDM_RCPROPERTIES_INCLUDES, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <2, IDM_RCPROPERTIES_ACCELERATORS, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <3, IDM_RCPROPERTIES_VERSIONINFO, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <4, IDM_RCPROPERTIES_STRINGTABLE, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <5, IDM_RCPROPERTIES_RESOURCES, 0,TBSTYLE_BUTTON, 0, 0>
							TBBUTTON <6, IDM_RCPROPERTIES_REMOVE, 0,TBSTYLE_BUTTON, 0, 0>


.DATA?
lpOldTreeProc				DWORD ?
hImlRCDialogsTree			DWORD ?
hRCPropertiesToolBar		DWORD ?
hImlRCAddResNormal			DWORD ?
hImlRCAddResDisabled		DWORD ?

hStylesBrowseButton			DWORD ?
lpPrevEditPropertiesProc	DWORD ?
lpPrevPropertiesListProc	DWORD ?
StyleExStyleChanged			DWORD ?



lpPrevSelectComboListProc	DWORD ?
hSelectComboButton			DWORD ?
lpPrevSelectComboButtonProc	DWORD ?

.DATA
hADialog					HWND 0
hSelection					DWORD 0		;This is the handle of the first Static window in the selection Chain
DialogsTreeHeight			DWORD 200
fSplit						DWORD 0


hOthersParentItem			HANDLE 0	;This is the parent item of ALL Other Resources.(i.e all but dialogs)
hStringTableParentItem		HANDLE 0	;This is the parent item of ALL String Tables.
hMenusParentItem			HANDLE 0	;This is the parent item of ALL Menus.
hIncludesParentItem			HANDLE 0	;This is the parent item of ALL Includes.
hResourcesParentItem		HANDLE 0	;This is the parent item of ALL Various resources (BMP, AVI, ICONS etc)
hAccelTablesParentItem		HANDLE 0	;This is the parent item of ALL Accelerator Tables
hVersionInfosParentItem		HANDLE 0	;This is the parent item of ALL Version Info Tables

lpStringTableMem			DWORD 0


fIsPushed					DWORD 0

.CODE
NewToolBoxToolBar Proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local Rect:RECT
	.If uMsg==WM_LBUTTONDBLCLK && ToolSelected>IDM_TOOLBOX_POINTER
		MOV ECX,1
		MOV EDX,IDM_TOOLBOX_POINTER
		
		@@:
			INC EDX
			INC ECX
			.If EDX!=ToolSelected
				JMP @B
			.EndIf
			
		Invoke SendMessage,hWnd,TB_GETITEMRECT,ECX,ADDR Rect
		
		MOV ECX,lParam
		AND ECX,0FFFFh	;ECX is horizontal
		
		MOV EDX,lParam
		SHR EDX,16		;EDX is vertical
		
		Invoke PtInRect,ADDR Rect,ECX,EDX
		.If EAX
			;PrintText "Double Click on button"
			Invoke AddControl,hADialog,0,0,80,40
		.EndIf
	.Else
		Invoke GetWindowLong,hWnd,GWL_USERDATA
		Invoke CallWindowProc,EAX,hWnd,uMsg,wParam,lParam
	.EndIf

	RET
NewToolBoxToolBar EndP

;Returns pointer to RESOURCEMEM.szName
GetImageNameFromValue Proc Uses EDI lpValue:DWORD
Local Buffer[256]:BYTE

	.If lpResourcesMem
		MOV EDI,lpResourcesMem
		Invoke DecToBin,lpValue
		.While [EDI].RESOURCEMEM.szFile
			.If EAX==[EDI].RESOURCEMEM.Value
				LEA EAX,[EDI].RESOURCEMEM.szName
				.If BYTE PTR [EAX]==0
					XOR EAX,EAX
				.EndIf
				JMP Ex
			.EndIf
			LEA EDI,[EDI+SizeOf RESOURCEMEM]
		.EndW
	.EndIf
	XOR EAX,EAX
Ex:
	RET
GetImageNameFromValue EndP

SetProperties Proc Uses EDI lpWindowData:DWORD
Local lvi:LVITEM
Local Buffer[256]:BYTE

	MOV EDI,lpWindowData
	
	Invoke SendMessage,hPropertiesList,WM_SETREDRAW,FALSE,0
	
	Invoke SendMessage,hPropertiesList,LVM_DELETEALLITEMS,0,0

	MOV lvi.imask,LVIF_TEXT


	MOV lvi.iItem,0
	MOV lvi.pszText,Offset szName
	CALL InsertNewItem
	LEA ECX,[EDI].CONTROLDATA.IDName
	MOV lvi.pszText,ECX
	CALL SetSubItem
	
	INC lvi.iItem
	MOV lvi.pszText,Offset szID
	CALL InsertNewItem
	MOV ECX,[EDI].CONTROLDATA.ID
	Invoke BinToDec,ECX,ADDR Buffer
	LEA ECX,Buffer
	MOV lvi.pszText,ECX
	CALL SetSubItem

	
	INC lvi.iItem
	MOV lvi.pszText,Offset szLeftt
	CALL InsertNewItem
	MOV ECX,[EDI].CONTROLDATA.dux
	Invoke BinToDec,ECX,ADDR Buffer
	LEA ECX,Buffer
	MOV lvi.pszText,ECX
	CALL SetSubItem

	INC lvi.iItem
	MOV lvi.pszText,Offset szTop
	CALL InsertNewItem
	MOV ECX,[EDI].CONTROLDATA.duy
	Invoke BinToDec,ECX,ADDR Buffer
	LEA ECX,Buffer
	MOV lvi.pszText,ECX
	CALL SetSubItem

	INC lvi.iItem
	MOV lvi.pszText,Offset szWidth
	CALL InsertNewItem
	MOV ECX,[EDI].CONTROLDATA.duccx
	Invoke BinToDec,ECX,ADDR Buffer
	LEA ECX,Buffer
	MOV lvi.pszText,ECX
	CALL SetSubItem

	INC lvi.iItem
	MOV lvi.pszText,Offset szHeight
	CALL InsertNewItem
	MOV ECX,[EDI].CONTROLDATA.duccy
	Invoke BinToDec,ECX,ADDR Buffer
	LEA ECX,Buffer
	MOV lvi.pszText,ECX
	CALL SetSubItem

	INC lvi.iItem
	MOV lvi.pszText,Offset szStyle
	CALL InsertNewItem
	MOV ECX,[EDI].CONTROLDATA.Style
	Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,ECX
	LEA ECX,Buffer
	MOV lvi.pszText,ECX
	CALL SetSubItem


	INC lvi.iItem
	MOV lvi.pszText,Offset szExStyle
	CALL InsertNewItem
	MOV ECX,[EDI].CONTROLDATA.ExStyle
	Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,ECX
	LEA ECX,Buffer
	MOV lvi.pszText,ECX
	CALL SetSubItem

	
	INC lvi.iItem
	MOV lvi.pszText,Offset szVisibleProperty	;"Visible"
	CALL InsertNewItem
	
	.If [EDI].CONTROLDATA.ntype	;i.e. NOT a dialog
		MOV ECX,[EDI].CONTROLDATA.NotStyle
	.Else	;Thanks SeaFarer
		MOV ECX,[EDI].CONTROLDATA.Style
		NOT ECX
	.EndIf
	
	AND ECX,WS_VISIBLE
	.If ECX
		LEA ECX,szFALSE
	.Else
		LEA ECX,szTRUE
	.EndIf
	
	MOV lvi.pszText,ECX
	CALL SetSubItem


	.If [EDI].CONTROLDATA.ntype==0 || [EDI].CONTROLDATA.ntype==1 || ([EDI].CONTROLDATA.ntype >=3 && [EDI].CONTROLDATA.ntype <= 6) || [EDI].CONTROLDATA.ntype ==13	;13=StatusBar
		MOV lvi.pszText,Offset szCaption
	.ElseIf [EDI].CONTROLDATA.ntype==2 || [EDI].CONTROLDATA.ntype==7 || [EDI].CONTROLDATA.ntype==20 || [EDI].CONTROLDATA.ntype==23 || [EDI].CONTROLDATA.ntype==24
		MOV lvi.pszText,Offset szText
	.ElseIf [EDI].CONTROLDATA.ntype==21	;Image Control
		MOV lvi.pszText,Offset szImage
	.Else
		JMP @F
	.EndIf
	
	INC lvi.iItem
	CALL InsertNewItem
	LEA ECX,[EDI].CONTROLDATA.Caption
	;Let's see if this #..... is defined
	.If [EDI].CONTROLDATA.ntype==21
		.If BYTE PTR [ECX]=="#"
			INC ECX
		.EndIf
		PUSH ECX
		Invoke GetImageNameFromValue,ECX
		POP ECX
		.If EAX	;NOW EAX is a pointer to the name
			MOV ECX,EAX
		.EndIf
	.EndIf

	MOV lvi.pszText,ECX
	CALL SetSubItem
	
	
	@@:
	.If [EDI].CONTROLDATA.ntype==0 || [EDI].CONTROLDATA.ntype==23
		MOV lvi.pszText,Offset szClass
		INC lvi.iItem
		CALL InsertNewItem
		LEA ECX,[EDI].CONTROLDATA.Class
		MOV lvi.pszText,ECX
		CALL SetSubItem
	.EndIf

	.If [EDI].CONTROLDATA.ntype==0
		MOV lvi.pszText,Offset szMenu
		INC lvi.iItem
		CALL InsertNewItem
		LEA ECX,[EDI].CONTROLDATA.MenuID
		MOV lvi.pszText,ECX
		CALL SetSubItem
		
		MOV lvi.pszText,Offset szFont
		INC lvi.iItem
		CALL InsertNewItem
		LEA ECX,[EDI].DIALOGDATA.FontName
		MOV lvi.pszText,ECX
		CALL SetSubItem
	.EndIf
	
	
	Invoke SendMessage,hPropertiesList,WM_SETREDRAW,TRUE,0
	RET
	
	InsertNewItem:
	MOV lvi.iSubItem,0
	Invoke SendMessage,hPropertiesList,LVM_INSERTITEM,0,ADDR lvi
	RETN
	
	SetSubItem:
	MOV lvi.iSubItem,1
	Invoke SendMessage, hPropertiesList, LVM_SETITEM, 0, ADDR lvi
	RETN
SetProperties EndP

GetImageType Proc Uses EDI dwValue:DWORD

	.If lpResourcesMem
		MOV EAX,dwValue
		MOV EDI,lpResourcesMem
		.While [EDI].RESOURCEMEM.szFile
			.If EAX==[EDI].RESOURCEMEM.Value
				MOV EAX,[EDI].RESOURCEMEM.nType
				JMP Ex
			.EndIf
			LEA EDI,[EDI+SizeOf RESOURCEMEM]
		.EndW
	.EndIf
	MOV EAX,-1	;i.e. not found
Ex:
	RET
GetImageType EndP

;Returns value in EAX
GetImageValueFromName Proc Uses EDI lpName:DWORD
Local Buffer[256]:BYTE

	.If lpResourcesMem
		MOV EDI,lpResourcesMem
		.While [EDI].RESOURCEMEM.szFile
			Invoke lstrcmp,ADDR [EDI].RESOURCEMEM.szName,lpName
			.If !EAX
				MOV EAX,[EDI].RESOURCEMEM.Value
				JMP Ex
			.EndIf
			LEA EDI,[EDI+SizeOf RESOURCEMEM]
		.EndW
	.EndIf
	XOR EAX,EAX
Ex:
	RET
GetImageValueFromName EndP

SelectComboListProc Proc Uses EBX EDI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]:BYTE

	.If uMsg==WM_LBUTTONUP || uMsg==WM_KEYDOWN
		.If uMsg==WM_KEYDOWN && wParam!=VK_RETURN
		.Else
			Invoke SendMessage,hWnd,LB_GETCURSEL,0,0
			.If EAX!=LB_ERR
				MOV ECX,EAX
				Invoke SendMessage,hWnd,LB_GETTEXT,ECX,ADDR Buffer
				Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX==-1
				.Else
					MOV EBX,EAX
						
					;MOV RCModified,TRUE
					Invoke SetRCModified,TRUE
					
					Invoke SetItemText,hPropertiesList,EBX,1,ADDR Buffer
					Invoke GetWindowLong,hSelectComboButton,GWL_USERDATA
					MOV EDI,EAX
					;PrintDec EBX
					.If EBX==11	;Menu
						LEA ECX,[EDI].CONTROLDATA.MenuID
						Invoke lstrcpy,ECX,ADDR Buffer
					.ElseIf EBX==8	;Visible
						Invoke lstrcmp,ADDR Buffer,Offset szTRUE
						.If EAX
							OR [EDI].CONTROLDATA.NotStyle,WS_VISIBLE
							AND [EDI].CONTROLDATA.Style,-1 XOR WS_VISIBLE
						.Else
							AND [EDI].CONTROLDATA.NotStyle,-1 XOR WS_VISIBLE
							OR [EDI].CONTROLDATA.Style,WS_VISIBLE
						.EndIf
						
						Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,[EDI].CONTROLDATA.Style
						Invoke SetItemText,hPropertiesList,6,1,ADDR Buffer
						
					.ElseIf EBX==9	;Image
						.If Buffer[0]!=0
							Invoke GetImageValueFromName,ADDR Buffer
							;PrintHex EAX
							.If EAX ;means that there is a name and EAX holds the number
								PUSH EAX							
								MOV Buffer[0],"#"
								MOV ECX,EAX
								Invoke BinToDec,ECX,ADDR Buffer[1]
								Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
								POP EAX
							.Else	;No name --> use what it is in buffer as a number
								;PrintString Buffer
								Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,CTEXT("#")
								Invoke lstrcat,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
								Invoke DecToBin,ADDR Buffer
							.EndIf
							;EAX holds the image ID
							Invoke GetImageType,EAX
						.Else
							Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,Offset szNULL
							XOR EAX,EAX	;i.e. since no image is selected, let's have bitmap as default
						.EndIf
												
						;EAX holds the image type -->0=Bitmap, 2=icon
						AND [EDI].CONTROLDATA.Style,-1 XOR (SS_ICON or SS_BITMAP)
						.If EAX==0
							MOV EAX,SS_BITMAP
						.Else
							MOV EAX,SS_ICON
						.EndIf
						OR [EDI].CONTROLDATA.Style,EAX
						
;						Invoke SetWindowLong,[EDI].CONTROLDATA.hChild,GWL_STYLE,[EDI].CONTROLDATA.Style
						;Update Style on properties list
						Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,[EDI].CONTROLDATA.Style
						Invoke SetItemText,hPropertiesList,6,1,ADDR Buffer
							;.If [EDI].CONTROLDATA.ntype==21	;Image
								Invoke ReCreateControl,EDI
							;	JMP @F
							;.EndIf
							
;						.If [EDI].CONTROLDATA.hImg
;							Invoke DeleteObject,[EDI].CONTROLDATA.hImg
;						.EndIf
;						
;						.If BYTE PTR [[EDI].CONTROLDATA.hChild]
;							Invoke SetImageOfStaticControl,EDI
;						.Else
;							Invoke SendMessage,[EDI].CONTROLDATA.hChild,STM_SETIMAGE,NULL,NULL
;						.EndIf
					.EndIf
				.EndIf				
			.EndIf
			Invoke SetFocus,hPropertiesList
		.EndIf
	.ElseIf uMsg==WM_MOUSEMOVE
		Invoke SendMessage,hWnd,LB_ITEMFROMPOINT,0,lParam
		Invoke SendMessage,hWnd,LB_SETCURSEL,EAX,0
	.ElseIf uMsg==WM_KILLFOCUS
		Invoke ShowWindow,hWnd,SW_HIDE
	.EndIf
	Invoke CallWindowProc,lpPrevSelectComboListProc,hWnd,uMsg,wParam,lParam
	RET
SelectComboListProc EndP

GetMenuNames Proc Uses EBX EDI
Local tvi			:TVITEM
Local Buffer[256]	:BYTE

	Invoke SendMessage,hSelectComboList,LB_ADDSTRING,0,Offset szNULL
	.If hMenusParentItem
		MOV tvi._mask,TVIF_PARAM
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_CHILD,hMenusParentItem
		MoreMenus:
		;----------
		.If EAX	;This is a Menu hItem
			MOV EBX,EAX
			MOV tvi.hItem,EBX
			Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
			MOV EDI,tvi.lParam; is the Menu memory
			
			LEA EAX,[EDI].MNUHEAD.szMenuName
			.If BYTE PTR [EAX]==0
				Invoke BinToDec,[EDI].MNUHEAD.MenuID,ADDR Buffer
				LEA EAX,Buffer
			.EndIf
			Invoke SendMessage,hSelectComboList,LB_ADDSTRING,0,EAX
		.Else
			JMP Finish
		.EndIf
		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_NEXT,EBX
		JMP MoreMenus
	.EndIf
	Finish:
	RET
GetMenuNames EndP


GetImages Proc Uses EDI
Local Buffer[256]:BYTE

	.If lpResourcesMem
		MOV EDI,lpResourcesMem
		Invoke SendMessage,hSelectComboList,LB_ADDSTRING,0,Offset szNULL
		.While [EDI].RESOURCEMEM.szFile
;nType: 0=Bitmap,1=Cursor,2=Icon,3=Avi,4=Manifest
			.If [EDI].RESOURCEMEM.nType==0 || [EDI].RESOURCEMEM.nType==2
				LEA EAX,[EDI].RESOURCEMEM.szName
				.If BYTE PTR [EAX]==0
					Invoke BinToDec,[EDI].RESOURCEMEM.Value,ADDR Buffer
					LEA EAX,Buffer
				.EndIf
				Invoke SendMessage,hSelectComboList,LB_ADDSTRING,0,EAX
			.EndIf
			LEA EDI,[EDI+SizeOf RESOURCEMEM]
		.EndW
	.EndIf
	RET
GetImages EndP

SelectComboButtonProc Proc Uses EBX hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Rect			:RECT
Local Buffer[256]	:BYTE
Local DesktopRect	:RECT

	.If uMsg==WM_LBUTTONDOWN
		MOV fIsPushed,TRUE
		Invoke CallWindowProc,lpPrevSelectComboButtonProc,hWnd,uMsg,wParam,lParam
		PUSH EAX
		Invoke IsWindowVisible,hSelectComboList
		.If EAX==0
			Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
			.If EAX==8 || EAX==11 || EAX==9	;Visible/Menus/Images
				MOV EBX,EAX
				
				Invoke SendMessage,hSelectComboList,LB_RESETCONTENT,0,0
				.If EBX==11	;menu
					Invoke GetMenuNames
				.ElseIf EBX==9	;Image
					Invoke GetImages
				.ElseIf EBX==8	;Visible
					Invoke SendMessage,hSelectComboList,LB_ADDSTRING,0,Offset szTRUE
					Invoke SendMessage,hSelectComboList,LB_ADDSTRING,0,Offset szFALSE
				.EndIf
				Invoke GetWindowRect,hWnd,ADDR Rect
				PUSH Rect.right
				
				Invoke RtlZeroMemory,ADDR Rect,SizeOf RECT
				MOV Rect.top,1
				MOV Rect.left,LVIR_LABEL
				Invoke GetItemText,hPropertiesList,EBX,1,ADDR Buffer
				Invoke SendMessage,hPropertiesList,LVM_GETSUBITEMRECT,EBX,ADDR Rect
				Invoke MapWindowPoints,hPropertiesList,NULL,ADDR Rect,2
				
				
				Invoke SendMessage,hSelectComboList,LB_GETITEMHEIGHT,0,0
				MOV EBX,EAX
				Invoke SendMessage,hSelectComboList,LB_GETCOUNT,0,0
				
				.If EAX && EAX!=LB_ERR 
					Invoke MulDiv,EBX,EAX,1
					MOV EBX,EAX
					ADD EBX,2
					.If EBX>120
						MOV EBX,120
					.EndIf
				.Else
					XOR EBX,EBX
				.EndIf
				
				Invoke GetDesktopWindow
				MOV ECX,EAX
				Invoke GetWindowRect,ECX,ADDR DesktopRect
				MOV EAX,Rect.bottom
				ADD EAX,EBX;80
				.If EAX>DesktopRect.bottom
					MOV EAX,Rect.top
					SUB EAX,EBX;81;0
					DEC EAX
				.Else
					MOV EAX,Rect.bottom		
				.EndIf
				POP EDX	
				SUB EDX,Rect.left
				Invoke SetWindowPos,hSelectComboList,HWND_TOPMOST,Rect.left,EAX,EDX,EBX,SWP_SHOWWINDOW; or SWP_NOACTIVATE
				Invoke SendMessage,hSelectComboList,LB_FINDSTRINGEXACT,-1,ADDR Buffer
				.If EAX!=LB_ERR
					Invoke SendMessage,hSelectComboList,LB_SETCURSEL,EAX,0
				.Else
					Invoke SendMessage,hSelectComboList,LB_SETTOPINDEX,0,0
				.EndIf
				Invoke InvalidateRect,hSelectComboList,NULL,TRUE
				;Invoke UpdateWindow,hSelectComboList
			.EndIf
		.Else
			Invoke ShowWindow,hSelectComboList,SW_HIDE
		.EndIf
		Invoke SetCapture,hWnd
		POP EAX
		RET
	.ElseIf uMsg==WM_LBUTTONUP
		MOV fIsPushed,FALSE
		Invoke ReleaseCapture
		Invoke InvalidateRect,hWnd,NULL,TRUE
	.ElseIf uMsg==WM_PAINT
		Invoke CallWindowProc,lpPrevSelectComboButtonProc,hWnd,uMsg,wParam,lParam
		PUSH EAX
		Invoke DrawButton,hWnd,fIsPushed
		POP EAX
		RET
	.EndIf
	Invoke CallWindowProc,lpPrevSelectComboButtonProc,hWnd,uMsg,wParam,lParam
	RET

SelectComboButtonProc EndP

ProjectTreeSelChange Proc Uses EBX hItem:HWND
	MOV EBX,hItem
	.If EBX==0 || EBX==hParentItem || EBX==hASMFilesItem || EBX==hModulesItem || EBX==hIncludeFilesItem || EBX== hResourceFilesItem || EBX==hTextFilesItem || EBX==hOtherFilesItem || EBX==hDefFilesItem || EBX==hBatchFilesItem
	.Else		
		Invoke GetTreeItemParameter,WinAsmHandles.hProjTree,hItem
		.If EAX
			MOV EBX,EAX
			;Invoke LockWindowUpdate,hClient
			Invoke IsWindowVisible,EBX
			.If !EAX && OpenChildStyle ;i.e. not visible
				Invoke SetWindowPos,EBX,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
				Invoke SendMessage,hClient,WM_MDIMAXIMIZE,EBX,0
			.Else
				Invoke SetWindowPos,EBX,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
			.EndIf			
			;Invoke LockWindowUpdate,0
		.EndIf
	.EndIf
	RET
ProjectTreeSelChange EndP

DialogsTreeSelChange Proc Uses EDI EBX hItem:HWND
Local tvi			:TVITEM
Local lParam		:DWORD

	Invoke SetWindowPos,hRCEditorWindow,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
	Invoke GetTreeItemParameter,hDialogsTree,hItem
	MOV lParam,EAX
	Invoke SetProperties,lParam
	Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM,TVGN_PARENT,hItem
	.If EAX==0	;i.e this is an item that corresponds to a Dialog
		MOV EAX,lParam
		MOV EAX,[EAX].CONTROLDATA.hWnd	;EAX is the Dialog Handle
		MOV EBX,EAX
	.Else	;i.e this is an item that corresponds to a control
		MOV EAX,lParam
		MOV EBX,[EAX].CONTROLDATA.hWnd
		Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM,TVGN_PARENT,hItem
		MOV tvi._mask,TVIF_PARAM
		MOV tvi.hItem,EAX
		Invoke SendMessage,hDialogsTree,TVM_GETITEM,0,ADDR tvi
		MOV EAX,tvi.lParam
		MOV EAX,[EAX].CONTROLDATA.hWnd	;EAX is the Dialog Handle
	.EndIf

	.If EAX!=hADialog
		PUSH EAX
		Invoke ShowWindow,hADialog,SW_HIDE
		
		Invoke SetScrollPos,hRCEditorWindow,SB_HORZ,0,TRUE
		Invoke SetScrollPos,hRCEditorWindow,SB_VERT,0,TRUE
		
		POP EAX
		MOV hADialog,EAX
		Invoke SetClipChildren,TRUE
		Invoke SetWindowPos,hADialog,0,8,DIALOGSYMARGIN,0,0,SWP_NOSIZE or SWP_SHOWWINDOW
	.EndIf

	@@:
	Invoke DeSelectWindow,hSelection
	MOV hSelection,EAX
	.If EAX
		JMP @B
	.EndIf
	Invoke SelectWindow,EBX,TRUE

	;Better Update if user keeps keyboard pressed
	Invoke UpdateWindow,hDialogsTree
	Invoke UpdateWindow,hRCEditorWindow
	RET
DialogsTreeSelChange EndP

CreateBlocksList Proc hWnd:HWND
Local lvc:LV_COLUMN
; OR LVS_SHOWSELALWAYS
	Invoke CreateWindowEx,WS_EX_CLIENTEDGE,Offset szListViewClass,NULL,WS_CHILD OR LVS_REPORT OR LVS_SINGLESEL OR LVS_NOCOLUMNHEADER OR LVS_SORTASCENDING,0, 0, 0, 0,hWnd,NULL,hInstance,0	
	;MOV WinAsmHandles.hBlocksList,EAX
	MOV WinAsmHandles.hBlocksList,EAX

	MOV EAX, LVS_EX_FULLROWSELECT OR LVS_EX_LABELTIP
	Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX

	MOV lvc.imask, LVCF_WIDTH
	
	MOV lvc.lx, 200
	Invoke SendMessage, WinAsmHandles.hBlocksList, LVM_INSERTCOLUMN, 0, ADDR lvc
	
	Invoke SendMessage, WinAsmHandles.hBlocksList, LVM_SETIMAGELIST, LVSIL_SMALL, hListAPIImageList

;	Invoke SendMessage,WinAsmHandles.hBlocksList,WM_SETFONT,hFontTahoma,FALSE
	RET
CreateBlocksList EndP

WindowStylesProc Proc Uses ESI EDI EBX hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lvc			:LV_COLUMN
Local lvi			:LVITEM
Local hList			:HWND
Local Buffer[256]	:BYTE
Local StyleRemaining:DWORD

	.If uMsg==WM_INITDIALOG
		MOV StyleExStyleChanged,FALSE
		Invoke GetDlgItem,hWnd,1
		MOV hList,EAX
		
		MOV EAX, LVS_EX_FULLROWSELECT or LVS_EX_GRIDLINES OR LVS_EX_LABELTIP
		Invoke SendMessage,hList,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX
		
		MOV lvc.imask, LVCF_WIDTH or LVCF_FMT
		MOV lvc.lx, 154
		MOV lvc.fmt,LVCFMT_LEFT	
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 0, ADDR lvc
		MOV lvc.lx, 35
		MOV lvc.fmt,LVCFMT_CENTER
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 1, ADDR lvc
		MOV lvi.imask,LVIF_TEXT; OR LVIF_IMAGE
		
		Invoke SetWindowText,hWnd,Offset szWindowStyles	;"Window Styles"
		
		MOV ESI,Offset StyleDef
		MOV lvi.iItem,-1
		MOV lvi.cchTextMax,256
		MOV EDI,lParam
		
		MOV EAX,[EDI].CONTROLDATA.Style
		MOV StyleRemaining,EAX
		
		Invoke SetWindowLong,hWnd,GWL_USERDATA,EDI
		
		.While BYTE PTR [ESI+4]
			MOV ECX,[ESI]
			.If !ECX; || ECX==WS_VISIBLE
				JMP GetNextStyle
			.EndIf
			
			Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_CHILDWINDOW")	;Equ to WS_CHILD
			.If !EAX
				JMP GetNextStyle
			.EndIf
			
			.If [EDI].CONTROLDATA.ntype==0	;i.e If this is a Dialog
				.If WORD PTR [ESI+4]!="SD" && WORD PTR [ESI+4]!="SW" 
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_OVERLAPPEDWINDOW")	;Equ to WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_POPUPWINDOW")	;Equ to WS_POPUP OR WS_BORDER OR WS_SYSMENU
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_TABSTOP")	;Equ to WS_MAXIMIZEBOX
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_THICKFRAME")	;Equ to WS_SIZEBOX
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_ICONIC")	;Equ to WS_MINIMIZE
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_TILEDWINDOW")	;Equ to WS_OVERLAPPEDWINDOW
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("DS_3DLOOK")	;Obsolete-not used
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_GROUP")	;not suitable for dialogs???
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
			.Else	;This is a control
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_MAXIMIZEBOX")	;Equ to WS_TABSTOP
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_MINIMIZEBOX")	;Equ to WS_GROUP
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				
				;----------------------------------------------------------------
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_MAXIMIZE")	;Equ to ES_SELECTIONBAR && ES_EX_NOCALLOLEINIT
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_SYSMENU")	;Equ to ES_NOIME
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_THICKFRAME")	;Equ to ES_SELFIME
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				Invoke lstrcmp,ADDR [ESI+4],CTEXT("WS_SIZEBOX")	;Equ to WS_THICKFRAME==ES_SELFIME
				.If !EAX
					JMP GetNextStyle
				.EndIf
				
				MOV ECX,DWORD PTR [ESI]
				.If ECX==WS_MINIMIZE || ECX==WS_OVERLAPPEDWINDOW || ECX==WS_TILEDWINDOW || ECX==WS_ICONIC || ECX==WS_POPUP || ECX==WS_POPUPWINDOW  || ECX==WS_CAPTION
					JMP GetNextStyle
				.EndIf
				
				.If [EDI].CONTROLDATA.ntype==1		;Static
					.If WORD PTR [ESI+4]!="SS" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					;|| ECX==SS_OWNERDRAW
					;|| ECX==SS_CENTERIMAGE 
					.If ECX==SS_REALSIZEIMAGE || ECX==SS_ICON || ECX==SS_BITMAP || (ECX>=SS_BLACKRECT && ECX<=SS_WHITEFRAME) || ECX==SS_USERITEM || (ECX>=SS_ETCHEDHORZ && ECX<=SS_ETCHEDFRAME)  
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==2	;Edit
					.If WORD PTR [ESI+4]!="SE" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					
					;Rich Edit only
					.If ECX==ES_SAVESEL || ECX==ES_SUNKEN || ECX==ES_SELECTIONBAR || ECX==ES_EX_NOCALLOLEINIT || ECX==ES_VERTICAL || ECX==ES_NOIME || ECX==ES_SELFIME
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("ES_DISABLENOSCROLL")	;Equ to ES_NUMBER
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
				.ElseIf [EDI].CONTROLDATA.ntype==3	;GroupBox
					.If WORD PTR [ESI+4]!="SB" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					;MOV ECX,DWORD PTR [ESI]
					.If ECX==BS_LEFTTEXT || ECX==BS_USERBUTTON || ECX==BS_OWNERDRAW || ECX==BS_PUSHLIKE || ECX==BS_3STATE || ECX==BS_AUTO3STATE || ECX==BS_AUTOCHECKBOX || ECX==BS_AUTORADIOBUTTON || ECX==BS_CHECKBOX || ECX==BS_DEFPUSHBUTTON || ECX==BS_PUSHBUTTON || ECX== BS_RADIOBUTTON
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==4	;BS_PUSHBUTTON & BS_DEFPUSHBUTTON
					.If WORD PTR [ESI+4]!="SB" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					;MOV ECX,DWORD PTR [ESI]
					.If ECX==BS_LEFTTEXT || ECX==BS_GROUPBOX || ECX==BS_USERBUTTON || ECX==BS_OWNERDRAW || ECX==BS_PUSHLIKE || ECX==BS_3STATE || ECX==BS_AUTO3STATE || ECX==BS_AUTOCHECKBOX || ECX==BS_AUTORADIOBUTTON || ECX==BS_CHECKBOX || ECX== BS_RADIOBUTTON
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==5	;BS_AUTOCHECKBOX
					.If WORD PTR [ESI+4]!="SB" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					.If ECX==BS_USERBUTTON || ECX==BS_OWNERDRAW || ECX==BS_AUTORADIOBUTTON || ECX==BS_DEFPUSHBUTTON || ECX==BS_GROUPBOX || ECX==BS_PUSHBUTTON || ECX== BS_RADIOBUTTON
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==6	;BS_RADIOBUTTON
					.If WORD PTR [ESI+4]!="SB" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					.If ECX==BS_USERBUTTON || ECX==BS_OWNERDRAW || ECX==BS_DEFPUSHBUTTON || ECX==BS_GROUPBOX || ECX==BS_PUSHBUTTON || ECX==BS_AUTOCHECKBOX || ECX==BS_CHECKBOX || ECX==BS_3STATE || ECX==BS_AUTO3STATE
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==7	;ComboBox
					.If WORD PTR [ESI+4]!="BC" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==8	;ListBox
					.If WORD PTR [ESI+4]!="BL" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					.If ECX==LBS_STANDARD	;=LBS_NOTIFY OR LBS_SORT OR WS_VSCROLL OR WS_BORDER=A00003
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==9	;Horizontal Scrollbar
					.If DWORD PTR [ESI+4]!="_SBS" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					
					.If ECX==SBS_SIZEGRIP || ECX==SBS_SIZEBOX
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_SIZEBOXTOPLEFTALIGN")
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_SIZEBOXBOTTOMRIGHTALIGN")
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_LEFTALIGN")	;Applicable only for Vertical Scrollbar
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_RIGHTALIGN")	;Applicable only for Vertical Scrollbar
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_VERT")	;Applicable only for Vertical Scrollbar
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
				.ElseIf [EDI].CONTROLDATA.ntype==10	;Vertical Scrollbar
					.If DWORD PTR [ESI+4]!="_SBS" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					
					.If ECX==SBS_SIZEGRIP || ECX==SBS_SIZEBOX
						JMP GetNextStyle
					.EndIf
					
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_SIZEBOXTOPLEFTALIGN")
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_SIZEBOXBOTTOMRIGHTALIGN")
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_BOTTOMALIGN")	;Applicable only for Horizontal Scrollbar
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
					;Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_HORZ")	;Applicable only for Horizontal Scrollbar==0 anyway!
					;.If !EAX
					;	JMP GetNextStyle
					;.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("SBS_TOPALIGN")	;Applicable only for Horizontal Scrollbar
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
				.ElseIf [EDI].CONTROLDATA.ntype==11	;TabControl
					.If DWORD PTR [ESI+4]!="_SCT" && WORD PTR [ESI+4]!="SW"
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==12	;ToolBar
					.If WORD PTR [ESI+4]!="SW" && DWORD PTR [ESI+4]!="_SCC"
						.If DWORD PTR [ESI+4]=="TSBT" && DWORD PTR [ESI+8]=="_ELY"	;TBSTYLE_
						.Else
							JMP GetNextStyle
						.EndIf
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==13	;StatusBar
					.If WORD PTR [ESI+4]!="SW" && DWORD PTR [ESI+4]!="_SCC"
						.If DWORD PTR [ESI+4] == "RABS" && WORD PTR [ESI+8]=="_S"	;SBARS_
						.Else
							JMP GetNextStyle
						.EndIf
					.EndIf				
				.ElseIf [EDI].CONTROLDATA.ntype==14	;ProgressBar
					.If WORD PTR [ESI+4]!="SW" && DWORD PTR [ESI+4]!="_SBP"
						JMP GetNextStyle
					.EndIf				
				.ElseIf [EDI].CONTROLDATA.ntype==15	;Rebar
					.If WORD PTR [ESI+4]!="SW" && DWORD PTR [ESI+4]!="_SCC"
						JMP GetNextStyle
					.EndIf				
				.ElseIf [EDI].CONTROLDATA.ntype==16	;UpDown
					.If WORD PTR [ESI+4]!="SW" && DWORD PTR [ESI+4]!="_SDU"
						JMP GetNextStyle
					.EndIf				
				.ElseIf [EDI].CONTROLDATA.ntype==17	;TreeView
					.If WORD PTR [ESI+4]!="VT" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==18	;ListView
					.If WORD PTR [ESI+4]!="VL" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==19	;TrackBar
					.If WORD PTR [ESI+4]!="BT" && WORD PTR [ESI+4]!="SW"
						JMP GetNextStyle
					.EndIf
					.If DWORD PTR [ESI+4]=="TSBT"	;i.e don't get confused with Toolbar Styles  
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==20	;RichEdit
					.If WORD PTR [ESI+4]!="SE" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					;Edit only: ES_UPPERCASE,ES_LOWERCASE,ES_OEMCONVERT
					.If ECX==ES_UPPERCASE || ECX==ES_LOWERCASE || ECX==ES_OEMCONVERT
						JMP GetNextStyle
					.EndIf
					
					Invoke lstrcmp,ADDR [ESI+4],CTEXT("ES_EX_NOCALLOLEINIT")	;Equ to ES_SELECTIONBAR
					.If !EAX
						JMP GetNextStyle
					.EndIf
					
				.ElseIf [EDI].CONTROLDATA.ntype==21	;Image
					.If WORD PTR [ESI+4]!="SS" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					.If (ECX>=SS_BLACKRECT && ECX<=SS_WHITEFRAME) || (ECX>=SS_ETCHEDHORZ && ECX<=SS_ETCHEDFRAME) || ECX==SS_OWNERDRAW || ECX==SS_USERITEM || ECX==SS_SIMPLE || ECX==SS_CENTER || ECX==SS_RIGHT || ECX==SS_NOPREFIX || ECX==SS_LEFTNOWORDWRAP 
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==22	;Shape
					.If WORD PTR [ESI+4]!="SS" && WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
					.If ECX==SS_REALSIZEIMAGE || ECX==SS_ICON || ECX==SS_BITMAP || ECX==SS_OWNERDRAW || ECX==SS_USERITEM || ECX==SS_SIMPLE || ECX==SS_CENTER || ECX==SS_RIGHT || ECX==SS_NOPREFIX || ECX==SS_LEFTNOWORDWRAP || ECX==SS_CENTERIMAGE
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==23	;User Defined
					.If WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
				.ElseIf [EDI].CONTROLDATA.ntype==24	;Managed control
					.If WORD PTR [ESI+4]!="SW" 
						JMP GetNextStyle
					.EndIf
				.EndIf 
			.EndIf
			
			MOV EAX,ESI
			ADD EAX,4
			INC lvi.iItem
			MOV lvi.pszText,EAX
			CALL InsertNewItem
			
			MOV EAX,StyleRemaining	;[EDI].CONTROLDATA.Style
			MOV ECX,[ESI]
			AND EAX,ECX
			.If EAX==ECX
				NOT ECX
				AND StyleRemaining,ECX
				MOV lvi.pszText,Offset szYes
			.Else
				MOV lvi.pszText,Offset szNo
			.EndIf 
			CALL SetSubItem
			
			GetNextStyle:
			Invoke lstrlen,ADDR [ESI+4]
			LEA ESI,[ESI+EAX+4+1]
		.EndW
		
		.If [EDI].CONTROLDATA.ntype==23	;User Defined
			MOV EBX,8000h
			.While EBX;<10000h
				INC lvi.iItem
				Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,EBX
				LEA ECX,Buffer
				MOV lvi.pszText,ECX
				CALL InsertNewItem
				
				MOV EAX,[EDI].CONTROLDATA.Style
				MOV ECX,EBX
				
				AND EAX,ECX
				.If EAX==ECX
					MOV lvi.pszText,Offset szYes
				.Else
					MOV lvi.pszText,Offset szNo
				.EndIf 
				CALL SetSubItem
				
				SHR EBX,1
			.EndW
		.ElseIf [EDI].CONTROLDATA.ntype==24	;Managed custom control
			;CUSTOMCONTROL STRUCT
			;	szFriendlyName		DB	24+1		DUP (?)
			;	szClassName			DB	24+1		DUP (?)
			;	;szDescription		DB	256+1		DUP (?)
			;	szDLLFullPathName	DB	MAX_PATH+1	DUP (?)
			;	szStyles			DB	16*(24+1)	DUP (?)
			;CUSTOMCONTROL ENDS
			
			Invoke GetPointerToManagedControl,ADDR [EDI].CONTROLDATA.Class
			LEA ESI,[EAX].CUSTOMCONTROL.szStyles
			MOV EBX,8000h
			.While EBX;<10000h
				.If BYTE PTR [ESI]
					INC lvi.iItem
					MOV lvi.pszText,ESI
					CALL InsertNewItem
					
					MOV EAX,[EDI].CONTROLDATA.Style
					MOV ECX,EBX
					
					AND EAX,ECX
					.If EAX==ECX
						MOV lvi.pszText,Offset szYes
					.Else
						MOV lvi.pszText,Offset szNo
					.EndIf 
					CALL SetSubItem
				.EndIf
				SHR EBX,1
				ADD ESI,25
			.EndW
		.EndIf
		
		Invoke GetWindowLong,hList,GWL_STYLE
		AND EAX,WS_VSCROLL
		.If !EAX
			Invoke SendMessage,hList,LVM_SETCOLUMNWIDTH,0,170
		.EndIf
		
	.ElseIf uMsg==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==2		;OK
				Invoke GetDlgItem,hWnd,1
				MOV hList,EAX
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				MOV EBX,EAX
				XOR ESI,ESI
				XOR EDI,EDI
				.While ESI<EBX
					Invoke GetItemText,hList,ESI,1,ADDR Buffer
					Invoke lstrcmp,ADDR Buffer,Offset szYes
					.If !EAX
						Invoke GetItemText,hList,ESI,0,ADDR Buffer
						LEA ECX,StyleDef
						Invoke FindStyle,ADDR Buffer,ECX
						.If !EAX	;For user defined controls OR Managed controls
							Invoke GetWindowLong,hWnd,GWL_USERDATA
							.If [EAX].CONTROLDATA.ntype==24
								PUSH EBX
								PUSH ESI
								
								Invoke GetPointerToManagedControl,ADDR [EAX].CONTROLDATA.Class
								MOV EBX,EAX;[EAX].CONTROLDATA.lpCustomControl
								LEA ESI,[EBX].CUSTOMCONTROL.szStyles
								MOV EBX,8000h
								.While EBX
									.If BYTE PTR [ESI]
										Invoke lstrcmp,ESI,ADDR Buffer
										.If !EAX	;i.e. found the constant definition
											MOV EAX,EBX
											JMP EndInnerLoop
										.EndIf
									.EndIf
									SHR EBX,1
									ADD ESI,25
								.EndW
								XOR EAX,EAX;<-------------Probably NOT needed but you never know!
								EndInnerLoop:
								POP ESI
								POP EBX
								
							.ElseIf [EAX].CONTROLDATA.ntype==23
								Invoke HexToBin,ADDR Buffer[2]
							.EndIf
						.EndIf
						
						OR EDI,EAX
					.EndIf
					INC ESI
				.EndW
				;Now EDI holds the style
				MOV StyleExStyleChanged,TRUE 
				Invoke EnableAllDockWindows,TRUE
				Invoke EndDialog,hWnd,EDI
			.ElseIf EAX==3	;Cancel
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_NOTIFY
		MOV EDI,lParam
		Invoke GetDlgItem,hWnd,1
		MOV hList,EAX
		MOV EAX, [EDI].NMHDR.hwndFrom
		.If EAX==hList
			.If [EDI].NM_LISTVIEW.hdr.code==NM_DBLCLK
				Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					MOV ESI,EAX
					Invoke GetItemText,hList,ESI,1,ADDR Buffer
					Invoke lstrcmp,ADDR Buffer,Offset szYes
					
					.If !EAX	;i.e. It is a "Yes"
						Invoke SetItemText,hList,ESI,1,Offset szNo
					.Else
						Invoke SetItemText,hList,ESI,1,Offset szYes
					.EndIf
					;MOV RCModified,TRUE
					Invoke SetRCModified,TRUE
				.EndIf
			.EndIf
		.EndIf
		
	.ElseIf uMsg == WM_CLOSE
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL
	.EndIf
	MOV EAX,FALSE
	RET
	
	InsertNewItem:
	MOV lvi.iSubItem,0
	Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
	RETN
	
	SetSubItem:
	MOV lvi.iSubItem,1
	Invoke SendMessage, hList, LVM_SETITEM, 0, ADDR lvi
	RETN

WindowStylesProc EndP

WindowExStylesProc Proc Uses ESI EDI EBX hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lvc			:LV_COLUMN
Local lvi			:LVITEM
Local hList			:HWND
Local Buffer[256]	:BYTE
	.If uMsg==WM_INITDIALOG
		MOV StyleExStyleChanged,FALSE
		Invoke GetDlgItem,hWnd,1
		MOV hList,EAX
		
		MOV EAX, LVS_EX_FULLROWSELECT or LVS_EX_GRIDLINES OR LVS_EX_LABELTIP
		Invoke SendMessage,hList,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX
		
		MOV lvc.imask, LVCF_WIDTH or LVCF_FMT
		MOV lvc.lx, 170
		MOV lvc.fmt,LVCFMT_LEFT	
		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 0, addr lvc
		MOV lvc.lx, 35
		MOV lvc.fmt,LVCFMT_CENTER
   		Invoke SendMessage, hList, LVM_INSERTCOLUMN, 1, addr lvc
		MOV lvi.imask,LVIF_TEXT; OR LVIF_IMAGE

		Invoke SetWindowText,hWnd,Offset szWindowExStyles	;"Window ExStyles"
			
		MOV ESI,Offset ExStyleDef
		MOV lvi.iItem,-1
		MOV lvi.cchTextMax,256
		MOV EDI,lParam
		.While BYTE PTR [ESI+4]
			MOV ECX,[ESI]
			.If ECX
				MOV EAX,ESI
				ADD EAX,4
				INC lvi.iItem
				MOV lvi.pszText,EAX
				CALL InsertNewItem
	
				MOV EAX,[EDI].CONTROLDATA.ExStyle
				MOV ECX,[ESI]
				AND	EAX,ECX
				.If EAX==ECX
					MOV lvi.pszText,Offset szYes
				.Else
					MOV lvi.pszText,Offset szNo
				.EndIf 
				CALL SetSubItem
			.EndIf
			Invoke lstrlen,ADDR [ESI+4]
			LEA ESI,[ESI+EAX+4+1]
		.EndW		
	.ElseIf uMsg==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==2		;OK
				Invoke GetDlgItem,hWnd,1
				MOV hList,EAX
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				MOV EBX,EAX
				XOR ESI,ESI
				XOR EDI,EDI
				.While ESI<EBX
					Invoke GetItemText,hList,ESI,1,ADDR Buffer
					Invoke lstrcmp,ADDR Buffer,Offset szYes
					.If !EAX
						Invoke GetItemText,hList,ESI,0,ADDR Buffer
						LEA ECX,ExStyleDef
						Invoke FindStyle,ADDR Buffer,ECX
						OR EDI,EAX
					.EndIf
					INC ESI
				.EndW
				MOV StyleExStyleChanged,TRUE
				;Now EDI holds the ExStyle 
				Invoke EnableAllDockWindows,TRUE
				Invoke EndDialog,hWnd,EDI
			.ElseIf EAX==3	;Cancel
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_NOTIFY
		MOV EDI,lParam
		Invoke GetDlgItem,hWnd,1
		MOV hList,EAX
		MOV EAX, [EDI].NMHDR.hwndFrom
		.If EAX==hList
			.If [EDI].NM_LISTVIEW.hdr.code==NM_DBLCLK
				Invoke SendMessage,hList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				.If EAX!=-1
					MOV ESI,EAX
					Invoke GetItemText,hList,ESI,1,ADDR Buffer
					Invoke lstrcmp,ADDR Buffer,Offset szYes
					.If !EAX	;i.e. It is a "Yes"
						Invoke SetItemText,hList,ESI,1,Offset szNo
					.Else
						Invoke SetItemText,hList,ESI,1,Offset szYes
					.EndIf
					;MOV RCModified,TRUE
					Invoke SetRCModified,TRUE
				.EndIf
			.EndIf
		.EndIf

	.ElseIf uMsg == WM_CLOSE
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL
	.EndIf
	MOV EAX,FALSE
	RET
	
	InsertNewItem:
	MOV lvi.iSubItem,0
	Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
	RETN
	
	SetSubItem:
	MOV lvi.iSubItem,1
	Invoke SendMessage, hList, LVM_SETITEM, 0, ADDR lvi
	RETN

WindowExStylesProc EndP

SelectFontHook Proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	.If uMsg==WM_INITDIALOG
		Invoke CenterWindow, hWnd
		Invoke SetWindowText,hWnd,Offset szFont
	.EndIf
	MOV EAX,FALSE
	RET
SelectFontHook EndP

SelectDialogFont Proc Uses EDI lpWindowData:DWORD
Local cf		:CHOOSEFONT
Local logfont	:LOGFONT
Local hDC		:HDC

	MOV EDI,lpWindowData
	
	Invoke RtlZeroMemory,ADDR cf,SizeOf cf
	MOV cf.lStructSize,SizeOf cf
	MOV EAX, WinAsmHandles.hMain
	MOV cf.hwndOwner,EAX
	
	Invoke GetDC,NULL
	MOV hDC,EAX
	
  	Invoke RtlZeroMemory,ADDR logfont,SizeOf logfont
	Invoke GetDeviceCaps,hDC,LOGPIXELSY
	Invoke MulDiv,[EDI].DIALOGDATA.FontSize,EAX,72
	NEG EAX
	MOV logfont.lfHeight,EAX
	
	MOV EAX,[EDI].DIALOGDATA.FontWeight
	MOV logfont.lfWeight,EAX
	;MOV logfont.lfWeight,400

	MOV EAX,[EDI].DIALOGDATA.FontItalic
	MOV logfont.lfItalic,AL
	
	MOV EAX,[EDI].DIALOGDATA.Charset
	MOV logfont.lfCharSet,AL

	Invoke lstrcpy,ADDR logfont.lfFaceName,ADDR [EDI].DIALOGDATA.FontName
	Invoke ReleaseDC,NULL,hDC

	
	LEA ECX,logfont
	MOV cf.lpLogFont,ECX

	MOV cf.Flags,CF_ENABLEHOOK OR CF_SCREENFONTS or CF_INITTOLOGFONTSTRUCT or CF_ANSIONLY;CF_SCRIPTSONLY;CF_NOVECTORFONTS
	MOV cf.lpfnHook, Offset SelectFontHook

	Invoke ChooseFont,ADDR cf
	.If EAX
		Invoke lstrcpy,ADDR [EDI].DIALOGDATA.FontName,ADDR logfont.lfFaceName
		MOV EAX, cf.iPointSize
		Invoke MulDiv,EAX,1,10
		MOV [EDI].DIALOGDATA.FontSize,EAX
		
		MOV EAX,logfont.lfWeight
		MOV [EDI].DIALOGDATA.FontWeight,EAX
		
		XOR EAX,EAX
		MOV AL,logfont.lfItalic
		MOV [EDI].DIALOGDATA.FontItalic,EAX
		
		MOV AL,logfont.lfCharSet
		MOV [EDI].DIALOGDATA.Charset,EAX
		
		MOV EAX,TRUE
		
	.EndIf

	RET
SelectDialogFont EndP

SetControlsFontProc Proc Uses ESI lpDialogData:DWORD, lpControlData:DWORD
	MOV ESI,lpControlData
	MOV ECX,lpDialogData
	M2M [ESI].CONTROLDATA.hFont,[ECX].CONTROLDATA.hFont
	;M2M [ESI].CONTROLDATA.FontSize,[ECX].CONTROLDATA.FontSize
	;Invoke lstrcpy,ADDR [ESI].CONTROLDATA.FontName, ADDR [ECX].CONTROLDATA.FontName
	Invoke SendMessage,[ESI].CONTROLDATA.hWnd,WM_SETFONT,[ESI].CONTROLDATA.hFont,TRUE
	Invoke PrepareAndConvertToPixels,ESI
	Invoke MoveWindow,[ESI].CONTROLDATA.hWnd,[ESI].CONTROLDATA.x,[ESI].CONTROLDATA.y,[ESI].CONTROLDATA.ccx,[ESI].CONTROLDATA.ccy,TRUE
	.If [ESI].CONTROLDATA.hChild
		Invoke SendMessage,[ESI].CONTROLDATA.hChild,WM_SETFONT,[ESI].CONTROLDATA.hFont,TRUE
	.EndIf
	RET
SetControlsFontProc EndP

EnumDialogChildren Proc Uses EDI lpDialogData:DWORD, lpProcedure:DWORD
	MOV EDI,lpDialogData
	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CHILD,[EDI].CONTROLDATA.hTreeItem
	.If EAX
		PUSH EAX
		Invoke GetTreeItemParameter,hDialogsTree,EAX
		;Invoke SetControlsFontProc,lpDialogData,EAX
		PUSH EAX
		PUSH lpDialogData
		CALL lpProcedure
		POP EAX
		MoreControls:
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_NEXT,EAX
		.If EAX
			PUSH EAX
			Invoke GetTreeItemParameter,hDialogsTree,EAX
			PUSH EAX
			PUSH lpDialogData
			CALL lpProcedure
			;Invoke SetControlsFontProc,lpDialogData,EAX
			POP EAX
			JMP MoreControls
		.EndIf			
	.EndIf
	RET
EnumDialogChildren EndP

HandlePropertiesListButton Proc Uses EBX EDI ESI
Local Buffer[256]	:BYTE
Local Rect			:RECT
	Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
	.If (EAX==8 || EAX==9 || EAX==11 || EAX==6 || EAX==7 || EAX==12)	;i.e Visible/Image/Menu/Style/ExStyle/Font
		MOV EBX,EAX
		
		;LOOOOOOOOOOOOOOOOK:So that is scrolling occurs, this must happen beofore calculation of the item position
		Invoke SendMessage,hPropertiesList,LVM_ENSUREVISIBLE,EBX,FALSE

		.If EBX==9	;Let's check if this is 'Image'
			Invoke GetItemText,hPropertiesList,EBX,0,ADDR Buffer
			Invoke lstrcmp,ADDR Buffer,Offset szImage
			.If EAX	;This is not Image but either Caption or Text
				Invoke ShowWindow,hSelectComboButton,SW_HIDE
				Invoke MoveWindow,hStylesBrowseButton,-100,0,0,0,TRUE
				;RET
				JMP Ex
			.EndIf
		.EndIf

		Invoke GetSystemMetrics,SM_CXVSCROLL
		MOV EDI,EAX
		
		Invoke GetClientRect,hPropertiesList,ADDR Rect
		MOV ESI,Rect.right
		
		MOV Rect.top,1
		MOV Rect.left,LVIR_LABEL
		Invoke SendMessage,hPropertiesList,LVM_GETSUBITEMRECT,EBX,ADDR Rect

		MOV ECX,Rect.bottom
		SUB ECX,Rect.top
		DEC ECX
		.If EBX==8 || EBX==9 || EBX==11	;Visible/Image/menu
			INC EDI
			SUB ESI,EDI
			Invoke SetWindowPos,hSelectComboButton,HWND_BOTTOM,ESI,Rect.top,EDI,ECX,SWP_SHOWWINDOW
			
			Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
			.If EAX
				Invoke GetTreeItemParameter,hDialogsTree,EAX
				Invoke SetWindowLong,hSelectComboButton,GWL_USERDATA,EAX
			.EndIf
			Invoke MoveWindow,hStylesBrowseButton,-100,0,0,0,TRUE
		.Else
			SUB ESI,ECX
			Invoke MoveWindow,hStylesBrowseButton,ESI,Rect.top,ECX,ECX,TRUE
			Invoke ShowWindow,hSelectComboButton,SW_HIDE
		.EndIf
	.Else
		Invoke ShowWindow,hSelectComboButton,SW_HIDE
		Invoke MoveWindow,hStylesBrowseButton,-100,0,0,0,TRUE
	.EndIf
	Ex:
	RET
HandlePropertiesListButton EndP

HandlePropertiesListDoubleClick Proc Uses EBX EDI
Local Buffer[256]	:BYTE
Local Rect			:RECT

	Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
	MOV EBX,EAX
;	MOV Rect.left,LVIR_LABEL
;	Invoke SendMessage,hPropertiesList,LVM_GETITEMRECT,EBX,ADDR Rect
	.If EBX==-1
	.ElseIf EBX<6 || EBX==9 || EBX==10
		MOV Rect.left,LVIR_LABEL
		Invoke SendMessage,hPropertiesList,LVM_GETITEMRECT,EBX,ADDR Rect
		
		.If EBX==9	;Let's check if this is 'Image'
			Invoke GetItemText,hPropertiesList,EBX,0,ADDR Buffer
			Invoke lstrcmp,ADDR Buffer,Offset szImage
			.If !EAX
				;RET
				JMP Ex
			.EndIf
		.EndIf
		
		
		;Important to set GWL_USERDATA **before** WM_SETTEXT
		;because with WM_SETTEXT EN_CHANGE will arrive and thus we will have
		;WRONG GWL_USERDATA
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
		.If EAX
			Invoke GetTreeItemParameter,hDialogsTree,EAX
			Invoke SetWindowLong,hEditProperties,GWL_USERDATA,EAX
		.EndIf
		
		
		.If EBX==0	;IDName
			Invoke SendMessage,hEditProperties,EM_LIMITTEXT,64,0
		.ElseIf EBX==9	;Caption
			Invoke SendMessage,hEditProperties,EM_LIMITTEXT,240,0
		.Else
			Invoke SendMessage,hEditProperties,EM_LIMITTEXT,31,0
		.EndIf
		Invoke GetItemText,hPropertiesList,EBX,1,ADDR Buffer						
		Invoke SendMessage,hEditProperties,WM_SETTEXT,0,ADDR Buffer

		Invoke SendMessage, hPropertiesList, LVM_GETCOLUMNWIDTH, 1, 0
		MOV ECX,Rect.bottom
		SUB ECX,Rect.top
		DEC ECX
		ADD Rect.right,5
		SUB EAX,9;5
		
		
		Invoke MoveWindow,hEditProperties,Rect.right,Rect.top,EAX,ECX,TRUE
		
		Invoke ShowWindow,hEditProperties,SW_SHOW
		
		Invoke SendMessage,hEditProperties,WM_GETTEXTLENGTH,0,0
		Invoke SendMessage,hEditProperties,EM_SETSEL,EAX,EAX
		Invoke SetFocus,hEditProperties
		
	.ElseIf EBX==8	;Visible
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
		.If EAX
			Invoke GetTreeItemParameter,hDialogsTree,EAX
			MOV EDI,EAX
			
			Invoke GetItemText,hPropertiesList,EBX,1,ADDR Buffer
			Invoke lstrcmp,ADDR Buffer,Offset szTRUE
			.If !EAX
				Invoke SetItemText,hPropertiesList,8,1,Offset szFALSE
				 OR [EDI].CONTROLDATA.NotStyle,WS_VISIBLE
				 
				 AND [EDI].CONTROLDATA.Style,-1 XOR WS_VISIBLE
			.Else
				Invoke SetItemText,hPropertiesList,8,1,Offset szTRUE
				AND [EDI].CONTROLDATA.NotStyle,-1 XOR WS_VISIBLE
				
				OR [EDI].CONTROLDATA.Style,WS_VISIBLE
			.EndIf
			
			Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,[EDI].CONTROLDATA.Style
			Invoke SetItemText,hPropertiesList,6,1,ADDR Buffer
			
			Invoke SetRCModified,TRUE
		.EndIf
	.Else
		Invoke SendMessage,hPropertiesList,WM_COMMAND, (BN_CLICKED SHL 16) OR 200,0
	.EndIf
	
	Ex:
	RET
HandlePropertiesListDoubleClick EndP

NewPropertiesListProc Proc Uses EBX EDI ESI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
;Local Rect			:RECT
Local Buffer[256]	:BYTE

	.If uMsg==WM_VSCROLL || uMsg==WM_HSCROLL || uMsg==WM_MOUSEWHEEL
		;Hide hEditProperties,hStylesBrowseButton,hSelectComboButton
		Invoke SetFocus,WinAsmHandles.hProjExplorer
		
		;Process the 3 messages normally
		Invoke CallWindowProc,lpPrevPropertiesListProc,hWnd,uMsg,wParam,lParam
		
		;Show any one of hEditProperties,hStylesBrowseButton,hSelectComboButton back
		Invoke SetFocus,hWnd
		Invoke InvalidateRect,hWnd,NULL,TRUE
		Invoke UpdateWindow,hWnd
		
		RET
	.ElseIf uMsg==WM_LBUTTONDBLCLK
		Invoke HandlePropertiesListDoubleClick
		
	.ElseIf uMsg==LVM_SETITEM || uMsg==WM_SIZE
		Invoke ShowWindow,hSelectComboButton,SW_HIDE
		Invoke ShowWindow,hEditProperties,SW_HIDE
		Invoke MoveWindow,hStylesBrowseButton,-100,0,0,0,TRUE
		
	.ElseIf uMsg==WM_KILLFOCUS
		MOV EBX,wParam
		.If EBX!=hEditProperties
			Invoke ShowWindow,hEditProperties,SW_HIDE
		.EndIf
		.If EBX!=hStylesBrowseButton
			Invoke MoveWindow,hStylesBrowseButton,-100,0,0,0,TRUE
		.EndIf
		.If EBX!=hSelectComboButton
			Invoke ShowWindow,hSelectComboButton,SW_HIDE
		.EndIf
		
	.ElseIf uMsg==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==200	;Browse Style/ExStyle/Font
				Invoke EnableAllDockWindows,FALSE
				Invoke EnableWindow, hFind,FALSE
				
				Invoke SetClipChildren,FALSE
				Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
				MOV EBX,EAX
				.If EBX==6	;Styles
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
					.If EAX
						PUSH EAX
						;Invoke EnableAllDockWindows,FALSE
						;Invoke EnableWindow, hFind,FALSE
						
						POP EAX
						Invoke GetTreeItemParameter,hDialogsTree,EAX
						PUSH EAX
						Invoke DialogBoxParam,hUILib,216,WinAsmHandles.hProjExplorer,ADDR WindowStylesProc,EAX
						;Returns new style in eax
						POP EDI
						.If StyleExStyleChanged
							.If [EDI].CONTROLDATA.ntype==13 || [EDI].CONTROLDATA.ntype==2 || [EDI].CONTROLDATA.ntype==7 || [EDI].CONTROLDATA.ntype==11 || [EDI].CONTROLDATA.ntype==22	|| [EDI].CONTROLDATA.ntype==21	|| [EDI].CONTROLDATA.ntype==9 || [EDI].CONTROLDATA.ntype==10
								.If [EDI].CONTROLDATA.ntype==10	;Vertical ScrollBar
									OR EAX,SBS_VERT
								.EndIf
								MOV [EDI].CONTROLDATA.Style,EAX
								Invoke ReCreateControl,EDI
								MOV ESI,[EDI].CONTROLDATA.hWnd							
							.Else
								.If [EDI].CONTROLDATA.ntype==3	;GroupBox
									OR EAX,BS_GROUPBOX
								.ElseIf [EDI].CONTROLDATA.ntype==5	;CheckBox
									MOV ECX,EAX
									AND ECX,BS_CHECKBOX or BS_AUTOCHECKBOX or BS_3STATE or BS_AUTO3STATE
									.If !ECX
										OR EAX,BS_CHECKBOX
									.ElseIf ECX==7	;->Push Buton
										AND EAX,-1 XOR (BS_AUTOCHECKBOX or BS_3STATE or BS_AUTO3STATE)
										OR EAX,BS_CHECKBOX
									.EndIf	
								.ElseIf [EDI].CONTROLDATA.ntype==6	;BS_RADIOBUTTON
									MOV ECX,EAX
									AND ECX,BS_RADIOBUTTON or BS_AUTORADIOBUTTON
									.If !ECX
										OR EAX,BS_RADIOBUTTON
									.ElseIf ECX==(BS_RADIOBUTTON or BS_AUTORADIOBUTTON)
										AND EAX,-1 XOR BS_RADIOBUTTON
									.EndIf
								.EndIf
								 
								MOV [EDI].CONTROLDATA.Style,EAX
								
								.If [EDI].CONTROLDATA.ntype==0
									OR EAX,WS_DISABLED; OR WS_DLGFRAME
										
									MOV EDX,EAX
									AND EDX,(WS_POPUP OR WS_CHILD)
									.If !EDX
										OR EAX,WS_CAPTION ;(Thanks IanB)
									.Else
										MOV EDX,EAX
										AND EDX,DS_CONTROL
										.If EDX
											AND EAX,-1 XOR WS_CAPTION
										.EndIf
									.EndIf
									
								.EndIf
								
								AND	EAX,-1 XOR (WS_POPUP OR WS_MINIMIZE OR WS_MAXIMIZE)
								OR EAX,WS_CHILD OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN OR WS_VISIBLE
								
								MOV ESI,[EDI].CONTROLDATA.hWnd							
								.If [EDI].CONTROLDATA.ntype==3 || [EDI].CONTROLDATA.ntype==23 || [EDI].CONTROLDATA.ntype==24	; || [EDI].CONTROLDATA.ntype==21; || [EDI].CONTROLDATA.ntype==22
									MOV ESI,[EDI].CONTROLDATA.hChild
								.ElseIf [EDI].CONTROLDATA.ntype==15	;Rebar
									AND EAX,-1 XOR CCS_TOP
									OR EAX,CCS_NORESIZE
								.EndIf 
								
								Invoke SetWindowLong,ESI,GWL_STYLE,EAX
								
								.If [EDI].CONTROLDATA.ntype==0
									Invoke PrepareAndConvertToPixels,EDI
								.ElseIf [EDI].CONTROLDATA.ntype==14	;ProgressBar
									Invoke SendMessage,[EDI].CONTROLDATA.hWnd,PBM_STEPIT,0,0
									Invoke SendMessage,[EDI].CONTROLDATA.hWnd,PBM_STEPIT,0,0
								.EndIf
								
							.EndIf
							
							.If [EDI].CONTROLDATA.ntype!=21	;image<----Some redrawing anvoided
								;INC [EDI].CONTROLDATA.ccx
								;Invoke SetWindowPos,ESI,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
								;DEC [EDI].CONTROLDATA.ccx
								;Invoke SetWindowPos,ESI,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
								Invoke SendMessage,ESI,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
								
								Invoke InvalidateRect,ESI,NULL,TRUE
								Invoke UpdateWindow,ESI
								.If [EDI].CONTROLDATA.ntype==3	;Thanks Qvasimodo
									Invoke InvalidateRect,[EDI].CONTROLDATA.hWnd,NULL,TRUE
								.EndIf
								;Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR Rect
								;Invoke MapWindowPoints,0,hADialog,ADDR Rect,2
								
							.EndIf
							
							.If [EDI].CONTROLDATA.ntype==0
								Invoke DeMultiSelect
								Invoke SelectWindow,ESI,TRUE
							.Else;If [EDI].CONTROLDATA.ntype==7 || [EDI].CONTROLDATA.ntype==16 || [EDI].CONTROLDATA.ntype==9 || [EDI].CONTROLDATA.ntype==10	|| [EDI].CONTROLDATA.ntype==13 ;ComboBox or UpDown or Vert./Horz scrollbar,Status Bar
								;Because optical size depends on style!
								Invoke DeSelectWindow,hSelection
								MOV hSelection,EAX
								Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
							.EndIf
							
							Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,[EDI].CONTROLDATA.Style
							Invoke SetItemText,hWnd,6,1,ADDR Buffer
							
							MOV EAX,[EDI].CONTROLDATA.Style
							AND EAX,WS_VISIBLE
							.If !EAX
								Invoke SetItemText,hPropertiesList,8,1,Offset szFALSE
								 OR [EDI].CONTROLDATA.NotStyle,WS_VISIBLE
							.Else
								Invoke SetItemText,hPropertiesList,8,1,Offset szTRUE
								AND [EDI].CONTROLDATA.NotStyle,-1 XOR WS_VISIBLE
							.EndIf
							
						.EndIf
						Invoke SetFocus,hWnd
					.EndIf
				.ElseIf EBX==7	;ExStyles
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
					.If EAX
						PUSH EAX
						;Invoke EnableAllDockWindows,FALSE
						;Invoke EnableWindow, hFind,FALSE
						POP EAX
						Invoke GetTreeItemParameter,hDialogsTree,EAX
						PUSH EAX
						Invoke DialogBoxParam,hUILib,216,WinAsmHandles.hProjExplorer,ADDR WindowExStylesProc,EAX
						POP EDI
						.If StyleExStyleChanged
							MOV ESI,[EDI].CONTROLDATA.hWnd
							MOV [EDI].CONTROLDATA.ExStyle,EAX
							MOV EBX,EAX
							
							Invoke wsprintf, ADDR Buffer, Offset szColorTemplate,[EDI].CONTROLDATA.ExStyle
							Invoke SetItemText,hWnd,7,1,ADDR Buffer
							
							.If [EDI].CONTROLDATA.ntype==3 || [EDI].CONTROLDATA.ntype==22 || [EDI].CONTROLDATA.ntype==23 || [EDI].CONTROLDATA.ntype==24
								;GroupBox,Shape	
								MOV ESI,[EDI].CONTROLDATA.hChild
								
							.ElseIf [EDI].CONTROLDATA.ntype==21	;Image
								Invoke ReCreateControl,EDI
								JMP @F
							.EndIf
							
							AND EBX,-1 XOR WS_EX_TRANSPARENT
							Invoke SetWindowLong,ESI,GWL_EXSTYLE,EBX
							
							;Invoke LockWindowUpdate,ESI
							INC [EDI].CONTROLDATA.ccx
							Invoke SetWindowPos,ESI,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
							DEC [EDI].CONTROLDATA.ccx
							Invoke SetWindowPos,ESI,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
							;Invoke LockWindowUpdate,0
							
							.If [EDI].CONTROLDATA.ntype==16	;UpDown
								;Because optical size depends on style!
								Invoke DeSelectWindow,hSelection
								MOV hSelection,EAX
								Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
							.EndIf
							
						.EndIf
						@@:
						Invoke SetFocus,hWnd
					.EndIf
				.ElseIf EBX==12	;Font
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
					.If EAX
						PUSH EAX
						;Invoke EnableAllDockWindows,FALSE
						;Invoke EnableWindow, hFind,FALSE
						POP EAX
						Invoke GetTreeItemParameter,hDialogsTree,EAX
						MOV EDI,EAX
						Invoke SelectDialogFont,EDI
						.If EAX	;Updated the Properties list with the new font name
							Invoke LockWindowUpdate,hRCEditorWindow
							;Invoke DeSelectWindow,hSelection	;Off Course ONLY ONE DIALOG SHOULD BE SELECTED
							Invoke DeMultiSelect	;Off Course ONLY ONE DIALOG SHOULD BE SELECTED
							Invoke DeleteObject,[EDI].CONTROLDATA.hFont
							Invoke CreateDialogFont,EDI
							Invoke SendMessage,[EDI].CONTROLDATA.hWnd,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
							Invoke PrepareAndConvertToPixels,EDI
							Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
							Invoke EnumDialogChildren,EDI,Offset SetControlsFontProc
							Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
							Invoke SetItemText,hWnd,12,1,ADDR [EDI].DIALOGDATA.FontName
							Invoke LockWindowUpdate,0
							
							Invoke SetRCModified,TRUE
						.EndIf
						Invoke EnableAllDockWindows,TRUE
						Invoke SetFocus,hWnd
						Invoke SetClipChildren,TRUE
						;JMP ShowButton
						;Invoke HandlePropertiesListButton
					.EndIf
				.EndIf
				Invoke EnableAllDockWindows,TRUE
				Invoke EnableWindow, hFind,TRUE
				Invoke SetClipChildren,TRUE
			.EndIf
			
			
		.ElseIf EDX==EN_CHANGE
			Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
			.If EAX==9	;Caption
				MOV EAX,lParam
				.If EAX==hEditProperties
					Invoke SendMessage,hEditProperties,WM_GETTEXT,256,ADDR Buffer
					Invoke GetWindowLong,hEditProperties,GWL_USERDATA
					.If EAX
						MOV EDI,EAX
						Invoke MakeEvenNumberOfDoubleQuotes,ADDR Buffer,Offset tmpBuffer
						;Look!!!!!!!! (handle \t, \n, \\, "")
						Invoke TranformText,Offset tmpBuffer,ADDR Buffer
						MOV EBX,[EDI].CONTROLDATA.hChild
						.If !EBX
							MOV EBX,[EDI].CONTROLDATA.hWnd
						.EndIf
						Invoke SetWindowText,EBX,ADDR Buffer
						Invoke UpdateWindow,EBX
					.EndIf
				.EndIf
			.EndIf
		.EndIf
		
	.ElseIf uMsg==LVM_DELETEALLITEMS
		;Invoke MoveWindow,hEditProperties,-100,0,0,0,TRUE
		Invoke ShowWindow,hEditProperties,SW_HIDE
	.EndIf
	Invoke CallWindowProc,lpPrevPropertiesListProc,hWnd,uMsg,wParam,lParam
	RET
NewPropertiesListProc EndP

EditPropertiesProc Proc Uses EDI EBX hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]	:BYTE
Local Buffer2[256]	:BYTE
Local rbi			:REBARBANDINFO

	.If uMsg==WM_KILLFOCUS
		Invoke GetWindowLong,hWnd,GWL_USERDATA
		.If EAX
			MOV EDI,EAX
			Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
			.If EAX!=-1
				MOV EBX,EAX
				Invoke SetRCModified,TRUE
				Invoke SendMessage,hWnd,WM_GETTEXT,256,ADDR Buffer
				.If EBX>=1 && EBX<=5
					.If Buffer[0]==0
						MOV Buffer[0],"0"
						MOV Buffer[1],0 
					.EndIf
				.EndIf
				Invoke SetItemText,hPropertiesList,EBX,1,ADDR Buffer
				.If EBX==0					;Name
					Invoke DeleteDefine,ADDR [EDI].CONTROLDATA.IDName
					Invoke lstrcpy,ADDR [EDI].CONTROLDATA.IDName,ADDR Buffer
					Invoke GetItemText,hPropertiesList,1,1,ADDR Buffer2
					Invoke AddOrReplaceDefine,ADDR Buffer, ADDR Buffer2
					;-----------------------------------------------------------
					;Thanks Jnrz
					LEA ECX,Buffer
					.If BYTE PTR [ECX]==0
						.If Buffer2[0]==0
							MOV Buffer2[0],"0"
							MOV Buffer2[1],0 
						.EndIf
						LEA ECX,Buffer2 
					.EndIf
					Invoke SetTreeItemText,hDialogsTree,[EDI].CONTROLDATA.hTreeItem,ECX
					;-----------------------------------------------------------
				.ElseIf EBX==1				;ID
					Invoke DeleteDefine,ADDR [EDI].CONTROLDATA.IDName
					Invoke DecToBin,ADDR Buffer
					MOV [EDI].CONTROLDATA.ID,EAX
					Invoke GetItemText,hPropertiesList,0,1,ADDR Buffer2
					Invoke AddOrReplaceDefine,ADDR Buffer2, ADDR Buffer
					;-----------------------------------------------------------
					;Thanks Jnrz
					LEA ECX,Buffer2
					.If BYTE PTR [ECX]==0
						.If Buffer[0]==0
							MOV Buffer[0],"0"
							MOV Buffer[1],0 
						.EndIf
						LEA ECX,Buffer 
					.EndIf
					Invoke SetTreeItemText,hDialogsTree,[EDI].CONTROLDATA.hTreeItem,ECX
					;-----------------------------------------------------------
				.ElseIf EBX>=2 && EBX<=5	;Left,Top,Width,Height
					Invoke DecToBin,ADDR Buffer
					.If EBX==2
						MOV [EDI].CONTROLDATA.dux,EAX
					.ElseIf EBX==3
						MOV [EDI].CONTROLDATA.duy,EAX
					.ElseIf EBX==4
						MOV [EDI].CONTROLDATA.duccx,EAX
					.ElseIf EBX==5
						MOV [EDI].CONTROLDATA.duccy,EAX
					.EndIf
					Invoke PrepareAndConvertToPixels,EDI
					
					.If [EDI].CONTROLDATA.ntype==0	;i.e. dialog
						Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy, SWP_NOMOVE OR SWP_SHOWWINDOW
					.ElseIf [EDI].CONTROLDATA.ntype==22	;i.e. shape
						Invoke ReCreateControl,EDI
					.Else
						Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOZORDER or SWP_NOOWNERZORDER
						.If [EDI].CONTROLDATA.ntype==15
							MOV rbi.cbSize, SizeOf REBARBANDINFO
							MOV rbi.fMask,RBBIM_STYLE or RBBIM_CHILD or RBBIM_SIZE or RBBIM_CHILDSIZE
							MOV rbi.fStyle,RBBS_GRIPPERALWAYS or RBBS_CHILDEDGE
							MOV EAX,[EDI].CONTROLDATA.ccx
							MOV rbi.lx,EAX
							MOV EAX,[EDI].CONTROLDATA.ccx
							MOV rbi.cxMinChild,EAX
							MOV EAX,[EDI].CONTROLDATA.ccy
							MOV rbi.cyMinChild,EAX
							MOV EAX,[EDI].CONTROLDATA.hChild
							MOV rbi.hwndChild,EAX
							Invoke SendMessage,[EDI].CONTROLDATA.hWnd,RB_SETBANDINFO,0,ADDR rbi
						.EndIf
					.EndIf
					
					Invoke DeSelectWindow,hSelection
					MOV hSelection,EAX
					Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM, TVGN_CARET, 0 ; get selected item
					.If EAX
						Invoke GetTreeItemParameter,hDialogsTree,EAX
						Invoke SelectWindow,[EAX].CONTROLDATA.hWnd,TRUE
					.EndIf
				.ElseIf EBX==9	;Caption
					Invoke MakeEvenNumberOfDoubleQuotes,ADDR Buffer,ADDR [EDI].CONTROLDATA.Caption
					Invoke SetItemText,hPropertiesList,9,1,ADDR [EDI].CONTROLDATA.Caption
					;Look!!!!!!!! (handle \t, \n, \\, "")
					Invoke TranformText,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
					MOV EBX,[EDI].CONTROLDATA.hChild
					.If !EBX
						MOV EBX,[EDI].CONTROLDATA.hWnd
					.EndIf
					Invoke SetWindowText,EBX,ADDR Buffer
				.ElseIf EBX==10	;Class
					Invoke MakeEvenNumberOfDoubleQuotes,ADDR Buffer,ADDR [EDI].CONTROLDATA.Class
					.If [EDI].CONTROLDATA.ntype	;i.e. NOT a dialog
						Invoke ReCreateControl,EDI
					.EndIf
					Invoke SetItemText,hPropertiesList,10,1,ADDR [EDI].CONTROLDATA.Class
				.EndIf
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_KEYDOWN
		.If wParam==VK_RETURN
			Invoke ShowWindow,hWnd,SW_HIDE
;		.Else
;			Invoke GetKeyState, VK_CONTROL
;			AND EAX,80h
;			.If EAX==80h && ( wParam==VK_X || wParam==VK_C || wParam==VK_V)
;			.EndIf
;			.If EAX==80h
;				.If wParam==VK_X
;					Invoke PostMessage,hWnd,WM_CUT,0,0
;				.ElseIf wParam==VK_C
;					Invoke PostMessage,hWnd,WM_COPY,0,0
;				.ElseIf wParam==VK_V
;					Invoke PostMessage,hWnd,WM_PASTE,0,0
;				.EndIf
;				XOR EAX,EAX
;				RET
;			.EndIf
		.EndIf
	.ElseIf uMsg==WM_CHAR
		Invoke GetKeyState, VK_CONTROL
		AND EAX,80h
		.If EAX!=80h	;i.e if Ctrl is NOT pressed continue with default processing
			Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
			.If EAX!=-1
				MOV EBX,EAX
				 ;i.e.	1.Backspace is always allowed
				 ;		2.EBX=9/10 means user is editing Caption/Class so allow EVERYTHING
				
				MOV EAX, wParam
				.If AL==VK_RETURN || AL==VK_BACK || EBX==9 || EBX==10
				.Else
					;0,1,2,3,4,5,9,10
					.If EBX==0; || EBX==10	;IDName,Class
						;That is: allow only alphanumeric characters
						.If (AL>="0" && AL<="9") || (al>='a' && al<='z') || (AL>='A' && AL<='Z') || AL=="_"
						.Else
							JMP IgnoreChar
						.EndIf
					.Else	;1=ID,2=Left,3=Top,4=Width,5=height
						.If (EBX==4 || EBX==5) && AL=="-"	;i.e. we don't want - for width and height
							JMP IgnoreChar
						.EndIf
						
						.If (AL>="0" && AL<="9")
							Invoke SendMessage,hWnd,WM_GETTEXT,256,ADDR Buffer
							Invoke SendMessage,hWnd,EM_GETSEL,0,0
							HIWORD EAX
							.If Buffer[EAX]=="-"
								JMP IgnoreChar
							.EndIf 
						.ElseIf AL=="-"
							Invoke SendMessage,hWnd,EM_GETSEL,0,0
							MOV EDI,EAX
							LOWORD EAX
							;EAX==Start
							.If EAX
								JMP IgnoreChar
							.EndIf
							Invoke SendMessage,hWnd,WM_GETTEXT,256,ADDR Buffer
							HIWORD EDI
							;EAX==End
							.If Buffer[EAX]=="-"
								JMP IgnoreChar
							.EndIf
						.Else
							JMP IgnoreChar
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		;.Else
		.EndIf
	.EndIf
	DefProc:
	Invoke CallWindowProc,lpPrevEditPropertiesProc,hWnd,uMsg,wParam,lParam
	RET
	
	IgnoreChar:
	Invoke Beep,1000,500
	XOR EAX,EAX
	RET
EditPropertiesProc EndP

NewProjectTreeProc Proc Uses EBX ESI hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local Buffer[320]	:BYTE
	.If uMsg==WM_DROPFILES

		Invoke DragQueryFile,wParam,-1,ADDR Buffer,256
		
		XOR ESI,ESI
		MOV EBX,EAX
		.If EBX==1	;i.e. one file only is dropped
			Invoke DragQueryFile,wParam,ESI,ADDR Buffer,256
			Invoke GetFileAttributes,ADDR Buffer
			.If EAX!=FILE_ATTRIBUTE_DIRECTORY
				Invoke GetFileExtension,ADDR Buffer
				Invoke lstrcmpi,EAX, Offset szExtwap
				.If EAX==0	;i.e. it is a wap file
					;2=Check wap, and all project files. NOT external files
					Invoke DialogBoxParam, hUILib, 217, WinAsmHandles.hMain, Offset AskToSaveFilesDialogProc, 2
					.If EAX	;EAX==TRUE if Yes or No was selected
						Invoke ClearProject
						Invoke OpenWAP,ADDR Buffer
					.EndIf
					
					JMP Ex
				.EndIf
			.EndIf
		.EndIf
		
		Invoke LockWindowUpdate,WinAsmHandles.hMain
		.If FullProjectName[0]==0
			;Put Project Settings here
			Invoke lstrcpy,Offset CompileRC,Offset szCompileRCNew
			Invoke lstrcpy,Offset szReleaseAssemble,Offset szReleaseAssembleNew

			Invoke lstrcpy,Offset szReleaseLink,Offset szReleaseLinkNew
			Invoke RtlZeroMemory,Offset szReleaseOutCommand,MAX_PATH
			Invoke DoNewProject,FALSE
		.EndIf
		.While ESI<EBX
			MOV ProjectModified,TRUE
			Invoke DragQueryFile,wParam,ESI,ADDR Buffer,256
			Invoke GetFileAttributes,ADDR Buffer
			.If EAX!=FILE_ATTRIBUTE_DIRECTORY	
				Invoke AddOpenExistingFile,ADDR Buffer,TRUE
			.Else
				Invoke lstrcat,ADDR Buffer,Offset szIsADirectory;" is a directory."
				Invoke MessageBox,NULL,ADDR Buffer,Offset szAppName,MB_ICONERROR + MB_TASKMODAL + MB_OK
			.EndIf
			INC ESI
		.EndW
		Invoke SetProjectRelatedItems
		
		;POP ESI
		;POP EBX
		Invoke LockWindowUpdate,0
		
		;DragAcceptFiles, DragFinish, DragQueryFile, DragQueryPoint 
	.EndIf


	Invoke CallWindowProc,lpOldTreeProc,hWnd,uMsg,wParam,lParam
	Ex:
	RET
NewProjectTreeProc EndP

ProjectExplorerInit Proc hWnd:HWND
Local TabItem	:TC_ITEM
Local lvc		:LV_COLUMN

	Invoke CreateWindowEx,NULL,Offset szTabControlClass,NULL,WS_CHILD OR WS_VISIBLE OR TCS_BOTTOM OR TCS_FOCUSNEVER,0, 0, 0, 0,hWnd,NULL,hInstance,0
	MOV WinAsmHandles.hProjTab,EAX
	;Invoke SendMessage,WinAsmHandles.hProjTab,TCM_SETIMAGELIST,0,hImlNormal
	
;	Invoke SendMessage,WinAsmHandles.hProjTab,WM_SETFONT,hFontTahoma,FALSE

	MOV TabItem.imask,TCIF_TEXT
	MOV TabItem.pszText,Offset szResources
	Invoke SendMessage,WinAsmHandles.hProjTab,TCM_INSERTITEM,0,ADDR TabItem

	MOV TabItem.pszText,Offset szBlocks
	Invoke SendMessage,WinAsmHandles.hProjTab,TCM_INSERTITEM,0,ADDR TabItem
	
	MOV TabItem.pszText,Offset szProject
	Invoke SendMessage,WinAsmHandles.hProjTab,TCM_INSERTITEM,0,ADDR TabItem
	
	Invoke SendMessage,WinAsmHandles.hProjTab, TCM_SETCURSEL , 0, NULL
	
	;Or TVS_LINESATROOT  
	Invoke CreateWindowEx,WS_EX_CLIENTEDGE OR WS_EX_ACCEPTFILES,Addr szTreeViewClass,NULL,WS_CHILD Or WS_CLIPSIBLINGS OR WS_VISIBLE Or TVS_HASLINES Or TVS_HASBUTTONS Or TVS_SHOWSELALWAYS,0,0,0,0,hWnd,NULL,hInstance,0
	MOV WinAsmHandles.hProjTree,EAX

	Invoke SetWindowLong,EAX,GWL_WNDPROC,Offset NewProjectTreeProc
	MOV lpOldTreeProc,EAX
	
;	Invoke SendMessage,WinAsmHandles.hProjTree,WM_SETFONT,hFontTahoma,FALSE

	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SETIMAGELIST,0,hImlNormal
	Invoke CreateBlocksList,hWnd
	
	;----------------------------------------------------------------------
	Invoke CreateWindowEx,NULL,Offset szTabControlClass,NULL,WS_CHILD OR TCS_FOCUSNEVER OR TCS_BUTTONS,0, 0, 0, 0,hWnd,NULL,hInstance,0
	MOV hResourcesTab,EAX
;	Invoke SendMessage,hResourcesTab,WM_SETFONT,hFontTahoma,FALSE
	MOV TabItem.imask,TCIF_TEXT
	MOV TabItem.cchTextMax,256
	MOV TabItem.pszText, Offset szOthers
	Invoke SendMessage,hResourcesTab,TCM_INSERTITEM,0,ADDR TabItem
	MOV TabItem.imask,TCIF_TEXT; or TCIF_IMAGE
	MOV TabItem.pszText,Offset szDialogs
	Invoke SendMessage,hResourcesTab,TCM_INSERTITEM,0,ADDR TabItem
	Invoke SendMessage,hResourcesTab,TCM_SETCURSEL,0,NULL

	Invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR szTreeViewClass,NULL,WS_CHILD OR WS_CLIPSIBLINGS OR TVS_HASLINES OR TVS_HASBUTTONS OR TVS_LINESATROOT OR TVS_SHOWSELALWAYS,0,0,0,0,hWnd,NULL,hInstance,0
	MOV hDialogsTree,EAX
	
	Invoke ImageList_LoadImage,hInstance,112,16,60,0FF00FFh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	MOV hImlRCDialogsTree,EAX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlRCDialogsTree,CLR_NONE
	
	Invoke SendMessage,hDialogsTree,TVM_SETIMAGELIST,0,hImlRCDialogsTree

;	Invoke SendMessage,hDialogsTree,WM_SETFONT,hFontTahoma,FALSE

	;Not Visible at StartUp
	; OR TVS_SHOWSELALWAYS
	Invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR szTreeViewClass,NULL,WS_CHILD OR WS_CLIPSIBLINGS OR TVS_HASLINES OR TVS_HASBUTTONS OR TVS_LINESATROOT OR TVS_SHOWSELALWAYS,0,0,0,0,hWnd,NULL,hInstance,0
	MOV hOthersTree,EAX
;	Invoke SendMessage,hOthersTree,WM_SETFONT,hFontTahoma,FALSE

	;or LVS_SHOWSELALWAYS	
	Invoke CreateWindowEx,WS_EX_CLIENTEDGE,Offset szListViewClass,NULL,WS_CHILD OR WS_CLIPSIBLINGS OR LVS_REPORT OR LVS_SINGLESEL OR LVS_NOCOLUMNHEADER or WS_CLIPCHILDREN,0, 0, 0, 0,hWnd,NULL,hInstance,0	
	MOV hPropertiesList,EAX

	Invoke SetWindowLong,hPropertiesList,GWL_WNDPROC,Offset NewPropertiesListProc
	MOV lpPrevPropertiesListProc,EAX

	MOV EAX, LVS_EX_FULLROWSELECT or LVS_EX_GRIDLINES OR LVS_EX_LABELTIP
	Invoke SendMessage,hPropertiesList,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, EAX

	MOV lvc.imask, LVCF_WIDTH
	
	MOV lvc.lx, 70
	Invoke SendMessage, hPropertiesList, LVM_INSERTCOLUMN, 0, addr lvc
	MOV lvc.lx, 90
	Invoke SendMessage, hPropertiesList, LVM_INSERTCOLUMN, 1, addr lvc
	;Invoke SendMessage, hPropertiesList, LVM_SETIMAGELIST, LVSIL_SMALL, hListAPIImageList

;	Invoke SendMessage,hPropertiesList,WM_SETFONT,hFontTahoma,FALSE

	;WS_BORDER or 
	Invoke CreateWindowEx,NULL,ADDR szEditClass,NULL,WS_CHILD or WS_VISIBLE or ES_AUTOHSCROLL,0,0,0,0,hPropertiesList,100,hInstance,NULL
	MOV hEditProperties,EAX
;	Invoke SendMessage,hEditProperties,WM_SETFONT,hFontTahoma,FALSE
	Invoke SetWindowLong,hEditProperties,GWL_WNDPROC,Offset EditPropertiesProc
	MOV lpPrevEditPropertiesProc,EAX
	Invoke CreateWindowEx,NULL,ADDR szButtonClass,Offset szTwoDots,WS_CHILD or WS_VISIBLE,0,0,0,0,hPropertiesList,200,hInstance,NULL
	MOV hStylesBrowseButton,EAX

	Invoke CreateWindowEx,NULL,ADDR szButton,NULL,WS_CHILD + WS_CLIPSIBLINGS,0,0,0,0,hPropertiesList,400,hInstance,NULL
	MOV hSelectComboButton,EAX
	Invoke SetWindowLong,hSelectComboButton,GWL_WNDPROC,Offset SelectComboButtonProc
	MOV lpPrevSelectComboButtonProc,EAX


	Invoke CreateWindowEx,NULL,Offset szListBoxClass,NULL,WS_POPUP OR WS_CLIPSIBLINGS or WS_BORDER or LBS_HASSTRINGS or LBS_NOINTEGRALHEIGHT or WS_VSCROLL ,0, 0, 0, 0,hPropertiesList,NULL,hInstance,0	
	MOV hSelectComboList,EAX
	Invoke SetWindowLong,EAX,GWL_WNDPROC,Offset SelectComboListProc
	MOV lpPrevSelectComboListProc,EAX
;	Invoke SendMessage,hSelectComboList,WM_SETFONT,hFontTahoma,FALSE

	;WS_DISABLED or 
	Invoke CreateWindowEx,NULL,Offset szToolbarClass,NULL,WS_CHILD OR TBSTYLE_TOOLTIPS OR CCS_NORESIZE OR TBSTYLE_FLAT,0,0,0,0,hWnd,NULL,hInstance,NULL
	MOV hRCPropertiesToolBar,EAX
	Invoke SendMessage,hRCPropertiesToolBar,TB_BUTTONSTRUCTSIZE,SizeOf TBBUTTON,0
	Invoke SendMessage,hRCPropertiesToolBar,TB_ADDBUTTONS,8,ADDR tbProperties
	
	Invoke ImageList_LoadImage,hInstance,115,16,60,0FF00FFh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	MOV hImlRCAddResNormal,EAX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlRCAddResNormal,CLR_NONE

	Invoke ImageList_LoadImage,hInstance,141,16,60,0FC00FCh,IMAGE_BITMAP,LR_CREATEDIBSECTION
	MOV hImlRCAddResDisabled,EAX
	; Set the background color of the imagelist to transparent
	Invoke ImageList_SetBkColor,hImlRCAddResDisabled,CLR_NONE

	Invoke SendMessage,hRCPropertiesToolBar,TB_SETIMAGELIST,0,hImlRCAddResNormal
	Invoke SendMessage,hRCPropertiesToolBar,TB_SETDISABLEDIMAGELIST,0,hImlRCAddResDisabled

	;----------------------------------------------------------------------
	Invoke SetProjectTreeAndProcListColors
	RET
ProjectExplorerInit EndP

ShowResourcesTab Proc

	Invoke ShowWindow,WinAsmHandles.hProjTree,SW_HIDE
	Invoke ShowWindow,WinAsmHandles.hBlocksList,SW_HIDE
	
	;---------------------------------------------
	Invoke ShowWindow,hRCPropertiesToolBar,SW_SHOW
	Invoke ShowWindow,hResourcesTab,SW_SHOW
	
	Invoke SendMessage,hResourcesTab,TCM_GETCURSEL,0,0
	.If EAX==0
		Invoke ShowWindow,hDialogsTree,SW_SHOW
		Invoke ShowWindow,hPropertiesList,SW_SHOW	
		Invoke ShowWindow,hOthersTree,SW_HIDE
	.ElseIf EAX==1
		Invoke ShowWindow,hDialogsTree,SW_HIDE
		Invoke ShowWindow,hPropertiesList,SW_HIDE
		Invoke ShowWindow,hOthersTree,SW_SHOW
	.EndIf
	RET
ShowResourcesTab EndP

SetPropertiesListColumnSize Proc
Local Rect	:RECT
	
	Invoke GetWindowRect,hPropertiesList,ADDR Rect
	
	MOV ECX,Rect.right
	SUB ECX,Rect.left
	SUB ECX,74	;70 is the width of column 0
	SUB ECX,EAX
	Invoke SendMessage, hPropertiesList, LVM_SETCOLUMNWIDTH, 1, ECX

	RET
SetPropertiesListColumnSize EndP

ProjectExplorerProc Proc Uses EBX EDI hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
Local Pnt			:POINT
Local tvinsert		:TV_INSERTSTRUCT
Local tvhit			:TV_HITTESTINFO
Local Buffer[256]	:BYTE
Local lvi			:LVITEM
Local Rect			:RECT
Local tvi			:TVITEM
Local hCtl			:HWND
;Local tvkdown		:TV_KEYDOWN

	Invoke SendCallBackToAllAddIns,pAddInsProjectExplorerProcedures,hWnd,uMsg,wParam,lParam
	.If EAX==0
		.If uMsg==WM_SHOWWINDOW
			.If wParam
				Invoke CheckMenuItem,hMenu,IDM_VIEW_PROJECTEXPLORER,MF_CHECKED
				Invoke SendMessage,hMainTB,TB_CHECKBUTTON,IDM_VIEW_PROJECTEXPLORER,TRUE
			.Else
				Invoke CheckMenuItem,hMenu,IDM_VIEW_PROJECTEXPLORER,MF_UNCHECKED
				Invoke SendMessage,hMainTB,TB_CHECKBUTTON,IDM_VIEW_PROJECTEXPLORER,FALSE
			.EndIf
		.ElseIf uMsg==WM_SIZE
			Invoke GetWindowLong,WinAsmHandles.hProjTree,GWL_STYLE
			PUSH EAX
			or EAX,TVS_NOTOOLTIPS
			Invoke SetWindowLong,WinAsmHandles.hProjTree,GWL_STYLE,EAX
			POP EAX
			Invoke SetWindowLong,WinAsmHandles.hProjTree,GWL_STYLE,EAX
			
			Invoke GetWindowLong,hDialogsTree,GWL_STYLE
			PUSH EAX
			OR EAX,TVS_NOTOOLTIPS
			Invoke SetWindowLong,hDialogsTree,GWL_STYLE,EAX
			POP EAX
			Invoke SetWindowLong,hDialogsTree,GWL_STYLE,EAX
			
			Invoke GetWindowLong,hOthersTree,GWL_STYLE
			PUSH EAX
			OR EAX,TVS_NOTOOLTIPS
			Invoke SetWindowLong,hOthersTree,GWL_STYLE,EAX
			POP EAX
			Invoke SetWindowLong,hOthersTree,GWL_STYLE,EAX
			
			Invoke SendMessage,hWnd,WAM_GETCLIENTRECT,0,ADDR Rect
			MOV EAX,Rect.right
			SUB EAX,Rect.left
			MOV Rect.right,EAX	;NOW THIS IS WIDTH NOT RIGHT
			
			MOV ECX,Rect.bottom
			SUB ECX,Rect.top
			MOV Rect.bottom,ECX	;NOW THIS IS HEIGHT NOT BOTTOM 
			PUSH Rect.bottom
			
			SUB Rect.bottom,21;2
			Invoke MoveWindow,WinAsmHandles.hProjTree,Rect.left,Rect.top,Rect.right,Rect.bottom,TRUE
			Invoke MoveWindow,WinAsmHandles.hBlocksList,Rect.left,Rect.top,Rect.right,Rect.bottom,TRUE
			ADD Rect.bottom,14
			Invoke MoveWindow,WinAsmHandles.hProjTab,Rect.left,Rect.bottom,Rect.right,24,TRUE
			
			;--------------------------------------------------------------------			
			Invoke MoveWindow,hRCPropertiesToolBar,Rect.left,Rect.top,Rect.right,26,TRUE
			
			ADD Rect.top,26
			Invoke MoveWindow,hResourcesTab,Rect.left,Rect.top,Rect.right,23,TRUE
			
			ADD Rect.top,23
			SUB Rect.bottom,26+23+14
			Invoke MoveWindow,hOthersTree,Rect.left,Rect.top,Rect.right,Rect.bottom,TRUE
			
			MOV EDX,DialogsTreeHeight
			.If EDX>Rect.bottom
				MOV EDX, Rect.bottom
			.EndIf
			;Invoke MoveWindow,hDialogsTree,Rect.left,Rect.top,Rect.right,DialogsTreeHeight,TRUE
			Invoke MoveWindow,hDialogsTree,Rect.left,Rect.top,Rect.right,EDX,TRUE
			
			MOV EAX,DialogsTreeHeight
			ADD EAX,4
			ADD Rect.top,EAX
			
			;SUB Rect.bottom,EAX
			;Invoke MoveWindow,hPropertiesList,Rect.left,Rect.top,Rect.right,Rect.bottom,TRUE
			
			POP ECX;Rect.bottom
			SUB ECX,Rect.top
			SUB ECX,4
			Invoke MoveWindow,hPropertiesList,Rect.left,Rect.top,Rect.right,ECX,TRUE
			Invoke SetPropertiesListColumnSize
			
			;*********************************************
			;Invoke MoveWindow,hEditProperties,-100,0,0,0,TRUE
			;*********************************************
			;So that hEditProperties and the two buttons are hidden if they are shown
			Invoke SetFocus,WinAsmHandles.hProjExplorer
		;------------------------------------------------------------
		.ElseIf uMsg==WM_LBUTTONDOWN
			Invoke SendMessage,hWnd,WAM_GETCLIENTRECT,0,ADDR Rect
			MOV EAX,lParam
			AND EAX,0ffffh
			MOV ECX,lParam
			SHR ECX,16
			ADD Rect.top,49
			SUB Rect.bottom,24
			.If EAX>Rect.left && EAX<Rect.right && ECX>Rect.top && ECX<Rect.bottom
				Invoke SetCursor,hHSplit
				MOV fSplit,TRUE
				Invoke SetCapture,hWnd
			.EndIf
			
		.ElseIf uMsg==WM_LBUTTONUP
			.If DragMode==TRUE
				Invoke ImageList_DragLeave,WinAsmHandles.hProjTree
				Invoke ImageList_EndDrag
				Invoke ImageList_Destroy,hDragImageList
				
				Invoke SendMessage, WinAsmHandles.hProjTree, TVM_GETNEXTITEM, TVGN_PARENT,ItemBeingDragged
				MOV EBX,EAX ;EBX is the parent of the item being dragged
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_DROPHILITE,0	; Get the currently hilited item
				.If EAX==EBX  ;Here user released mouse over parent of item being dragged
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_CARET,EAX
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_DROPHILITE,0
					
					;Get all info about the ItemBeingDragged
					;Invoke RtlZeroMemory,ADDR tvinsert,SizeOf TV_INSERTSTRUCT
					MOV tvinsert.item._mask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE+TVIF_PARAM
					PUSH ItemBeingDragged
					POP tvinsert.item.hItem
					MOV tvinsert.item.cchTextMax,256
					LEA EAX, Buffer	;Holds FileTitle corresponding to this tree item
					MOV tvinsert.item.pszText,EAX
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETITEM,0,ADDR tvinsert.item
					
					;tvinsert.item.lParam    ;Corresponding Child Window Handle
					;Delete the ItemBeingDragged
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_DELETEITEM,0,ItemBeingDragged
					
					;Create a new item with all info of the ItemBeingDragged
					;the only problem : Does hItem stay unchanged ?
					MOV tvinsert.hParent,EBX
					MOV tvinsert.hInsertAfter,TVI_FIRST
					
					Invoke GetWindowLong,tvinsert.item.lParam,0
					MOV EBX,EAX
					
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_INSERTITEM,0, ADDR tvinsert
					
					;In case the hTree item changed
					MOV CHILDWINDOWDATA.hTreeItem[EBX],EAX
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_CARET,EAX
					MOV ProjectModified,TRUE
					
				.Else    ;Here user released mouse over item being dragged
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_CARET,ItemBeingDragged
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_DROPHILITE,0
				.EndIf
				Invoke ReleaseCapture
				MOV DragMode,FALSE
			.ElseIf fSplit
				Invoke ReleaseCapture
				MOV fSplit,FALSE
			.EndIf
		.ElseIf uMsg==WM_NOTIFY
			MOV EDI,lParam
			MOV EAX, [EDI].NMHDR.hwndFrom
			.If EAX==WinAsmHandles.hProjTree
				MOV EBX,[EDI].NM_TREEVIEW.itemNew.hItem
				.If [EDI].NM_TREEVIEW.hdr.code==TVN_SELCHANGED && [EDI].NM_TREEVIEW.action
					Invoke ProjectTreeSelChange,EBX
					;RET
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==TVN_BEGINDRAG
					
					Invoke ProjectTreeSelChange,EBX
					
					MOV ItemBeingDragged,EBX
					.If EBX!=hParentItem && EBX!=hASMFilesItem && EBX!=hModulesItem && EBX!=hIncludeFilesItem && EBX!= hResourceFilesItem && EBX!=hTextFilesItem && EBX!=hOtherFilesItem && EBX!=hDefFilesItem && EBX!=hBatchFilesItem
						Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET, EBX ; select it
						Invoke SendMessage,WinAsmHandles.hProjTree,TVM_CREATEDRAGIMAGE,0,[EDI].NM_TREEVIEW.itemNew.hItem
						MOV hDragImageList,EAX
						Invoke ImageList_BeginDrag,hDragImageList,0,0,0
						Invoke ImageList_DragEnter,WinAsmHandles.hProjTree,[EDI].NM_TREEVIEW.ptDrag.x,[edi].NM_TREEVIEW.ptDrag.y
						Invoke SetCapture,hWnd
						MOV DragMode,TRUE
					.EndIf
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==NM_RCLICK
					Invoke SendMessage, WinAsmHandles.hProjTree, TVM_GETNEXTITEM, TVGN_DROPHILITE, 0 ; get current drop hilited item
					.If(EAX != 0) 
						PUSH EAX					
						Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SELECTITEM, TVGN_CARET, EAX ; select it				.EndIf
						POP EAX
						Invoke ProjectTreeSelChange,EAX
					.EndIf
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==TVN_ITEMEXPANDING
					.If EBX !=hParentItem
						MOV tvi._mask, TVIF_IMAGE or TVIF_SELECTEDIMAGE
						MOV tvi.hItem,EBX
						.If [EDI].NM_TREEVIEW.itemNew.state & TVIS_EXPANDED
							MOV tvi.iImage, 45
							MOV tvi.iSelectedImage, 45
						.Else
							MOV tvi.iImage, 46
							MOV tvi.iSelectedImage, 46
						.EndIf
						Invoke SendMessage, WinAsmHandles.hProjTree, TVM_SETITEM, 0, addr tvi
					.EndIf
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==NM_DBLCLK
					Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
					.If EAX && EAX==hRCEditorWindow
						Invoke SendMessage,WinAsmHandles.hProjTab,TCM_SETCURSEL,2,0
						Invoke ShowResourcesTab
					.EndIf
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==TVN_KEYDOWN
					MOV EDX,lParam
					.If [EDX].TV_KEYDOWN.wVKey==VK_DELETE
						Invoke SendMessage,WinAsmHandles.hMain,WM_COMMAND,IDM_PROJECT_REMOVEFILE,0
					.EndIf
				.EndIf
				
			.ElseIf EAX==WinAsmHandles.hProjTab
				.If [EDI].NMHDR.code == TCN_SELCHANGE
					Invoke SendMessage,WinAsmHandles.hProjTab,TCM_GETCURSEL,0,0
					.If EAX==0
						CALL ShowProjectTab
					.ElseIf EAX==1
						Invoke ShowWindow,WinAsmHandles.hProjTree,SW_HIDE
						Invoke ShowWindow,WinAsmHandles.hBlocksList,SW_SHOW
						Invoke ShowWindow,hRCPropertiesToolBar,SW_HIDE
						Invoke ShowWindow,hDialogsTree,SW_HIDE
						Invoke ShowWindow,hPropertiesList,SW_HIDE
						Invoke ShowWindow,hResourcesTab,SW_HIDE
						Invoke ShowWindow,hOthersTree,SW_HIDE
					.ElseIf EAX==2
						Invoke ShowResourcesTab
					.EndIf
				.EndIf
			.ElseIf EAX==WinAsmHandles.hBlocksList
				.If [EDI].NMHDR.code == LVN_KEYDOWN
					.If [EDI].NMLVKEYDOWN.wVKey==VK_RETURN
						CALL GoToProcedure
					.EndIf
				.ElseIf [EDI].NMHDR.code == NM_DBLCLK
					CALL GoToProcedure
				.EndIf
				
			.ElseIf EAX==hResourcesTab
				.If [EDI].NMHDR.code == TCN_SELCHANGE
					Invoke SendMessage,hResourcesTab,TCM_GETCURSEL,0,0
					.If EAX==0
						Invoke ShowWindow,hDialogsTree,SW_SHOW
						Invoke ShowWindow,hPropertiesList,SW_SHOW
						Invoke ShowWindow,hOthersTree,SW_HIDE
					.ElseIf EAX==1
						Invoke ShowWindow,hDialogsTree,SW_HIDE
						Invoke ShowWindow,hPropertiesList,SW_HIDE
						Invoke ShowWindow,hOthersTree,SW_SHOW
					.EndIf
				.EndIf
			.ElseIf EAX==hDialogsTree
				.If [EDI].NM_TREEVIEW.hdr.code==TVN_SELCHANGED
					.If [EDI].NM_TREEVIEW.action	;TVC_UNKNOWN==0--->when new dialog item is inserted or deleted etc
													;TVC_BYKEYBOARD	By a key stroke
													;TVC_BYMOUSE	By a mouse click
						Invoke DialogsTreeSelChange,[EDI].NM_TREEVIEW.itemNew.hItem
						RET
					.EndIf
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==NM_SETFOCUS	;i.e. an item is grey and not visible then show it.
					RET
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==NM_RCLICK
					Invoke SendMessage, hDialogsTree, TVM_GETNEXTITEM, TVGN_DROPHILITE, 0 ; get current drop hilited item
					.If(EAX != 0) 
						PUSH EAX					
						Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET, EAX ; select it				.EndIf
						POP EAX
						Invoke DialogsTreeSelChange,EAX
					.EndIf
					
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==TVN_KEYDOWN
					MOV EDX,lParam
					.If [EDX].TV_KEYDOWN.wVKey==VK_DELETE
						Invoke SendMessage,hWnd,WM_COMMAND,IDM_RCPROPERTIES_REMOVE,0
					.EndIf
					
				.EndIf
			.ElseIf EAX==hOthersTree
				.If [EDI].NM_TREEVIEW.hdr.code==NM_DBLCLK
					Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_CARET,NULL
					.If EAX==hIncludesParentItem
						Invoke EnableAllDockWindows,FALSE
						Invoke DialogBoxParam,hUILib,210,WinAsmHandles.hMain,ADDR IncludesDialogProc,TRUE
					.ElseIf EAX==hResourcesParentItem
						Invoke EnableAllDockWindows,FALSE
						Invoke DialogBoxParam,hUILib,211,WinAsmHandles.hMain,ADDR ResourcesDialogProc,TRUE
					.ElseIf EAX==hStringTableParentItem
						Invoke EnableAllDockWindows,FALSE
						Invoke DialogBoxParam,hUILib,214,WinAsmHandles.hMain,ADDR StringTableDialogProc,TRUE
					.Else
						MOV EDI,EAX
						Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_PARENT,EAX
						.If EAX	;i.e
							;Let's get the lParam of the item
							MOV tvi._mask,TVIF_PARAM
							MOV tvi.hItem,EDI
							MOV EDI,EAX
							
							Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
							.If EDI==hAccelTablesParentItem			;i.e. This is an Accelerator Table
								;lParam is the pointer to the ACCELMEM for this Table
								Invoke EnableAllDockWindows,FALSE
								Invoke DialogBoxParam,hUILib,212,WinAsmHandles.hMain,ADDR AcceleratorsDialogProc,tvi.lParam
							.ElseIf EDI==hVersionInfosParentItem		;i.e. This is a Version Info
								;lParam is the pointer to the VERSIONMEM for this Table
								Invoke EnableAllDockWindows,FALSE
								Invoke DialogBoxParam,hUILib,213,WinAsmHandles.hMain,ADDR VersionInfoDialogProc,tvi.lParam
							.ElseIf EDI==hMenusParentItem		;i.e. This is a Menu
								;lParam is the pointer to the VERSIONMEM for this Table
								Invoke EnableAllDockWindows,FALSE
								Invoke DialogBoxParam,hUILib,215,WinAsmHandles.hMain,ADDR MenuEditDialogProc,tvi.lParam
								.If EAX	;i.e User Pressed OK-->EAX is the temp memory
									MOV EDI,EAX
									Invoke RtlMoveMemory,tvi.lParam,EDI,64*1024
									Invoke HeapFree,hMainHeap,0,EDI
								.EndIf
							.EndIf
						.EndIf
					.EndIf
					
				.ElseIf [EDI].NM_TREEVIEW.hdr.code==TVN_KEYDOWN
					MOV EDX,lParam
					.If [EDX].TV_KEYDOWN.wVKey==VK_DELETE
						Invoke SendMessage,hWnd,WM_COMMAND,IDM_RCPROPERTIES_REMOVE,0
					.EndIf
				.EndIf
			.ElseIf EAX==hPropertiesList
				.If [EDI].NM_LISTVIEW.hdr.code==LVN_KEYDOWN
					Invoke SendMessage,hPropertiesList,LVM_GETNEXTITEM,-1,LVNI_ALL or LVNI_SELECTED
					.If [EDI].LV_KEYDOWN.wVKey==VK_RETURN
						;.If (EAX<6 || EAX==9 || EAX==10)
							Invoke HandlePropertiesListDoubleClick
							;Invoke PostMessage,hEditProperties,WM_KEYUP,[EDI].LV_KEYDOWN.wVKey,0
						;.Else
						;.EndIf
					.EndIf
				.ElseIf [EDI].NM_LISTVIEW.hdr.code==LVN_ITEMCHANGING
					;VERYYYYYYYYYYYYYYYY important
					Invoke ShowWindow,hEditProperties,SW_HIDE				
				.ElseIf ([EDI].NM_LISTVIEW.hdr.code==LVN_ITEMCHANGED && [EDI].NM_LISTVIEW.uNewState==3) || [EDI].NM_LISTVIEW.hdr.code==NM_SETFOCUS
					;Invoke CallWindowProc,Offset DockWndProc,hWnd,uMsg,wParam,lParam
					;Invoke DoEvents
					;Invoke UpdateWindow,hPropertiesList
					;MOV EAX,[EDI].NM_LISTVIEW.iItem
					;PrintDec EAX
					;Invoke SendMessage,hPropertiesList,LVM_UPDATE,[EDI].NM_LISTVIEW.iItem,0
					Invoke HandlePropertiesListButton
					;RET
				.EndIf
			.Else
				.If [EDI].NMHDR.code==TTN_NEEDTEXT
					MOV EAX,[EDI].NMHDR.idFrom
					.If EAX==IDM_RCPROPERTIES_MENUS
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szNewMenu
					.ElseIf EAX==IDM_RCPROPERTIES_INCLUDES
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szIncFiles
					;.ElseIf EAX==IDM_RCPROPERTIES_DEFINES
					;	MOV [EBX].TOOLTIPTEXT.lpszText,Offset szDefinitions
					.ElseIf EAX==IDM_RCPROPERTIES_ACCELERATORS
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szAddAcceleratorTable
					.ElseIf EAX==IDM_RCPROPERTIES_VERSIONINFO
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szAddVersionInfo
					.ElseIf EAX==IDM_RCPROPERTIES_STRINGTABLE
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szStringTable
					.ElseIf EAX==IDM_RCPROPERTIES_RESOURCES
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szResources
					.ElseIf EAX==IDM_RCPROPERTIES_REMOVE
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szRemoveT
					.ElseIf EAX==IDM_TOOLBOX_DIALOG
						MOV [EDI].TOOLTIPTEXT.lpszText,Offset szAddNewDialog
					.EndIf
					
					;Tooltip is partly shown if parent floats
					Invoke SetWindowPos,[EDI].NMHDR.hwndFrom,HWND_TOP,0,0,0,0,SWP_NOACTIVATE OR SWP_NOMOVE OR SWP_NOSIZE OR SWP_NOOWNERZORDER
				.EndIf
			.EndIf
		.ElseIf uMsg==WM_CONTEXTMENU
			MOV EAX,wParam
			MOV EAX,lParam
			AND EAX,0FFFFh
			MOV Pnt.x,EAX
			MOV EAX,lParam
			SHR EAX,16
			MOV Pnt.y,EAX
			
			Invoke IsWindowVisible,WinAsmHandles.hProjTree
			.If EAX
				Invoke GetCapture ;This is true if we are in the middle of a drag operation
				.If EAX!=hWnd
					Invoke GetWindowRect,WinAsmHandles.hProjTree,ADDR Rect
					Invoke PtInRect,ADDR Rect,Pnt.x,Pnt.y
					.If EAX
						Invoke TrackPopupMenu,WinAsmHandles.PopUpMenus.hProjectMenu,TPM_CENTERALIGN or TPM_RIGHTBUTTON,Pnt.x,Pnt.y,0,WinAsmHandles.hMain,0
						XOR EAX,EAX
						RET
					.EndIf
				.EndIf
			.Else
				Invoke IsWindowVisible,hDialogsTree
				.If EAX && hRCEditorWindow
					Invoke GetWindowRect,hDialogsTree,ADDR Rect
					Invoke PtInRect,ADDR Rect,Pnt.x,Pnt.y
					.If EAX
						Invoke ScreenToClient,hDialogsTree,ADDR Pnt
						Invoke HandleRCContextMenu,Pnt.x,Pnt.y,hDialogsTree
						RET
					.EndIf
				.EndIf
			.EndIf
		.ElseIf uMsg==WM_MOUSEMOVE
			MOV EAX,lParam
			AND EAX,0ffffh
			MOV ECX,lParam
			SHR ECX,16
			
			.If DragMode==TRUE
				MOV tvhit.pt.x,EAX   ;eax is the horizontal position of the drag image
				MOV tvhit.pt.y,ECX   ;ecx is the vertical position			
				Invoke ImageList_DragMove,EAX,ECX
				Invoke ImageList_DragShowNolock,FALSE
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_HITTEST,NULL,addr tvhit	; check if an item is hit
				.If EAX!=NULL && (EAX==hParentItem || EAX==hASMFilesItem || EAX==hModulesItem || EAX==hIncludeFilesItem || EAX== hResourceFilesItem || EAX==hTextFilesItem || EAX==hOtherFilesItem || EAX==hDefFilesItem || EAX==hBatchFilesItem )
					PUSH EAX
					Invoke SendMessage, WinAsmHandles.hProjTree, TVM_GETNEXTITEM, TVGN_PARENT,ItemBeingDragged
					MOV EBX,EAX ;EBX is the parent of the item being dragged
					POP EAX
					.If EAX==EBX
						Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_DROPHILITE,eax
					.Else
						Invoke SendMessage,WinAsmHandles.hProjTree,TVM_SELECTITEM,TVGN_DROPHILITE,ItemBeingDragged
					.EndIf
				.EndIf
				Invoke ImageList_DragShowNolock,TRUE
			.Else;If fSplit
				PUSH EAX
				PUSH ECX
				Invoke SendMessage,hWnd,WAM_GETCLIENTRECT,0,ADDR Rect
				POP ECX
				POP EAX
				ADD Rect.top,49
				SUB Rect.bottom,24
				.If fSplit
					SUB Rect.bottom,4
					.If ECX>=Rect.top && ECX<=Rect.bottom ;EAX>=Rect.left && EAX<=Rect.right &&
						SUB ECX,Rect.top
					.ElseIf ECX<Rect.top || ECX>7FFFh
						MOV ECX,0;Rect.top
					.ElseIf ECX>Rect.bottom
						MOV ECX,Rect.bottom
						SUB ECX,Rect.top
					.EndIf
					MOV DialogsTreeHeight,ECX
					Invoke SendMessage,hWnd,WM_SIZE,0,0
					Invoke UpdateWindow,hWnd
				.Else
					.If EAX>=Rect.left && EAX<=Rect.right && ECX>Rect.top && ECX<Rect.bottom
						Invoke GetCapture
						.If EAX!=hWnd	;Because if it is captured, probably user is moving the docking window
							Invoke SetCursor,hHSplit
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.ElseIf uMsg == WM_COMMAND		
			HIWORD wParam
			.If EAX == 0 || 1 ; 0 is a menu, 1 is an accelerator. Toolbar messages act like menu messages...
				LOWORD wParam
				.If EAX == IDM_RCPROPERTIES_INCLUDES
					Invoke EnableAllDockWindows,FALSE
					Invoke DialogBoxParam,hUILib,210,WinAsmHandles.hMain,ADDR IncludesDialogProc,FALSE
					
				.ElseIf EAX == IDM_RCPROPERTIES_RESOURCES
					Invoke EnableAllDockWindows,FALSE
					Invoke DialogBoxParam,hUILib,211,WinAsmHandles.hMain,ADDR ResourcesDialogProc,FALSE
					
				.ElseIf EAX == IDM_RCPROPERTIES_ACCELERATORS
					Invoke EnableAllDockWindows,FALSE
					Invoke DialogBoxParam,hUILib,212,WinAsmHandles.hMain,ADDR AcceleratorsDialogProc,FALSE
					
				.ElseIf EAX == IDM_RCPROPERTIES_VERSIONINFO
					Invoke EnableAllDockWindows,FALSE
					Invoke DialogBoxParam,hUILib,213,WinAsmHandles.hMain,ADDR VersionInfoDialogProc,FALSE
					
				.ElseIf EAX == IDM_RCPROPERTIES_STRINGTABLE
					Invoke EnableAllDockWindows,FALSE
					Invoke DialogBoxParam,hUILib,214,WinAsmHandles.hMain,ADDR StringTableDialogProc,FALSE
					
				.ElseIf EAX == IDM_RCPROPERTIES_MENUS
					Invoke EnableAllDockWindows,FALSE
					Invoke DialogBoxParam,hUILib,215,WinAsmHandles.hMain,ADDR MenuEditDialogProc,FALSE
					
				.ElseIf EAX == IDM_RCPROPERTIES_REMOVE
					Invoke IsWindowVisible,hOthersTree
					.If EAX
						Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_CARET,NULL
						.If EAX
							.If EAX==hIncludesParentItem
								;PrintHex 1
							.ElseIf EAX==hResourcesParentItem
								;PrintHex 2
							.ElseIf EAX==hStringTableParentItem
								Invoke MessageBox,WinAsmHandles.hMain,Offset szSureToRemoveStringTable,Offset szAppName,MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL
								.If EAX==IDYES
									Invoke SetRCModified,TRUE
									MOV ESI,lpStringTableMem
									.While [ESI].STRINGMEM.szName || [ESI].STRINGMEM.Value
										Invoke DeleteDefine,ADDR [ESI].STRINGMEM.szName
										LEA ESI,[ESI+SizeOf STRINGMEM]
									.EndW
									Invoke HeapFree,hMainHeap,0,lpStringTableMem
									MOV lpStringTableMem,0
									Invoke SendMessage, hOthersTree, TVM_DELETEITEM,0,hStringTableParentItem
									MOV hStringTableParentItem,0
								.EndIf
							.Else
								MOV EDI,EAX
								Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_PARENT,EAX
								.If EAX	;i.e
									MOV EBX,EAX
									Invoke GetTreeItemParameter,hOthersTree,EDI
									.If EBX==hAccelTablesParentItem			;i.e. This is an Accelerator Table
										;EAX is the pointer to the ACCELMEM for this Table
										MOV ESI,EAX
										Invoke MessageBox,WinAsmHandles.hMain,Offset szSureToRemoveAcceleratorTable,Offset szAppName,MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL
										.If EAX==IDYES
											;MOV RCModified,TRUE
											Invoke SetRCModified,TRUE
											LEA EAX,[ESI].ACCELMEM.szName
											.If BYTE PTR [EAX]!=0
												Invoke DeleteDefine,ADDR [ESI].ACCELMEM.szName
											.EndIf
											Invoke HeapFree,hMainHeap,0,ESI
											Invoke SendMessage, hOthersTree, TVM_DELETEITEM,0,EDI
											
											Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_CHILD	,hAccelTablesParentItem
											.If !EAX
												Invoke SendMessage, hOthersTree, TVM_DELETEITEM,0,hAccelTablesParentItem
												MOV hAccelTablesParentItem,0
											.EndIf
										.EndIf
									.ElseIf EBX==hVersionInfosParentItem		;i.e. This is a Version Info
										;EAX is the pointer to the VERSIONMEM for this Table
										MOV ESI,EAX
										Invoke MessageBox,WinAsmHandles.hMain,Offset szSureToRemoveVersionInfo,Offset szAppName,MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL
										.If EAX==IDYES
											Invoke SetRCModified,TRUE
											LEA EAX,[ESI].VERSIONMEM.szName
											.If BYTE PTR [EAX]!=0
												Invoke DeleteDefine,ADDR [ESI].VERSIONMEM.szName
											.EndIf
											Invoke HeapFree,hMainHeap,0,ESI
											Invoke SendMessage, hOthersTree, TVM_DELETEITEM,0,EDI
											
											Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_CHILD	,hVersionInfosParentItem
											.If !EAX
												Invoke SendMessage, hOthersTree, TVM_DELETEITEM,0,hVersionInfosParentItem
												MOV hVersionInfosParentItem,0
											.EndIf
										.EndIf
									.ElseIf EBX==hMenusParentItem		;i.e. This is a Menu
										;EAX is the pointer to the Menu
										MOV ESI,EAX
										Invoke MessageBox,WinAsmHandles.hMain,Offset szSureToRemoveMenu,Offset szAppName,MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL
										.If EAX==IDYES
											Invoke SetRCModified,TRUE
											Invoke DeleteMenuDefines,ESI
											Invoke HeapFree,hMainHeap,0,ESI
											Invoke SendMessage, hOthersTree, TVM_DELETEITEM,0,EDI
											
											Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_CHILD	,hMenusParentItem
											.If !EAX
												Invoke SendMessage, hOthersTree, TVM_DELETEITEM,0,hMenusParentItem
												MOV hMenusParentItem,0
											.EndIf
											
										.EndIf
									.EndIf
								.EndIf
								
							.EndIf
						.EndIf
					.Else	;Dialogs tree is shown NOT others tree
						Invoke DeleteSelectedWindows
					.EndIf
				.ElseIf EAX == IDM_TOOLBOX_DIALOG
					Invoke LockWindowUpdate,hClient
					Invoke IsWindowVisible,hRCEditorWindow
					
					.If !EAX && OpenChildStyle ;i.e. not visible
						Invoke SetWindowPos,hRCEditorWindow,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
						Invoke SendMessage,hClient,WM_MDIMAXIMIZE,hRCEditorWindow,0
					.Else
						Invoke SetWindowPos,hRCEditorWindow,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
					.EndIf			
					Invoke LockWindowUpdate,0
					
					Invoke SendMessage,hToolBox,WM_COMMAND, IDM_TOOLBOX_DIALOG,0
				.EndIf
			.EndIf
			
		.ElseIf uMsg==WM_DESTROY
			Invoke ImageList_Destroy,hImlRCAddResNormal
			Invoke ImageList_Destroy,hImlRCAddResDisabled
			Invoke ImageList_Destroy,hImlRCDialogsTree
		.EndIf
	.EndIf

	Invoke CallWindowProc,Offset DockWndProc,hWnd,uMsg,wParam,lParam
	RET
	
	GoToProcedure:
	;-------------
	Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_GETNEXTITEM,-1, LVNI_ALL OR LVNI_FOCUSED OR LVNI_SELECTED
	.If EAX!=-1
		MOV lvi.iItem,EAX
		MOV lvi.iSubItem,0

		MOV lvi.imask, LVIF_TEXT or LVIF_PARAM
		MOV lvi.cchTextMax,256
		LEA EAX,Buffer
		MOV lvi.pszText,EAX
		Invoke SendMessage,WinAsmHandles.hBlocksList,LVM_GETITEM,0,ADDR lvi
		Invoke GetParent,lvi.lParam	;lParam is the handle of the CodeHi editor
		Invoke GetWindowLong,EAX,0
		MOV ECX,EAX
		Invoke ScrollToTop,ECX,ADDR Buffer
	.EndIf
	RETN
ProjectExplorerProc EndP