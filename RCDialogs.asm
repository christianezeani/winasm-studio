EnableControlsOnToolBox PROTO :DWORD

.DATA?
hTempFind			DWORD	?
SelRect				RECT	<?>

.DATA
szTab0				DB "Tab0",0
szTab1				DB "Tab1",0
bSelecting			DD 0
szCONTROL			DB 'CONTROL',0
szEDITTEXT			DB 'EDITTEXT',0
szLTEXT				DB 'LTEXT',0
szCTEXT				DB 'CTEXT',0
szRTEXT				DB 'RTEXT',0
szGROUPBOX			DB 'GROUPBOX',0
szPUSHBUTTON		DB 'PUSHBUTTON',0
szDEFPUSHBUTTON		DB 'DEFPUSHBUTTON',0
szAUTOCHECKBOX		DB 'AUTOCHECKBOX',0
szCHECKBOX			DB 'CHECKBOX',0
szAUTORADIOBUTTON	DB 'AUTORADIOBUTTON',0
szCOMBOBOX			DB 'COMBOBOX',0
szLISTBOX			DB 'LISTBOX',0
szSCROLLBAR			DB 'SCROLLBAR',0
szENDSHORT			DB '}',0
szEND				DB 'END',0



Comment $
szFW_DONTCARE	DB "FW_DONTCARE",0 
szFW_THIN		DB "FW_THIN",0 
szFW_EXTRALIGHT	DB "FW_EXTRALIGHT",0 
szFW_ULTRALIGHT	DB "FW_ULTRALIGHT",0 
szFW_LIGHT		DB "FW_LIGHT",0 
szFW_NORMAL		DB "FW_NORMAL",0 
szFW_REGULAR	DB "FW_REGULAR",0 
szFW_MEDIUM		DB "FW_MEDIUM",0 
szFW_SEMIBOLD	DB "FW_SEMIBOLD",0 
szFW_DEMIBOLD	DB "FW_DEMIBOLD",0 
szFW_BOLD		DB "FW_BOLD",0 
szFW_EXTRABOLD	DB "FW_EXTRABOLD",0 
szFW_ULTRABOLD	DB "FW_ULTRABOLD",0 
szFW_HEAVY		DB "FW_HEAVY",0 
szFW_BLACK		DB "FW_BLACK",0 
$

.CODE
GetRCFileLineNumber Proc WordPositionInBlock:DWORD
	MOV EAX,1	;EAX Counts LineNumber
	
	MOV ECX,StartOfBlock
	.While BYTE PTR [ECX] && ECX < WordPositionInBlock 
		.If BYTE PTR [ECX]==0Dh; || BYTE PTR [EAX]==0Ah
			INC EAX
		.EndIf
		INC ECX
	.EndW

	RET
GetRCFileLineNumber EndP

NonCompatibleScriptMessage Proc WordPositionInBlock:DWORD
Local Buffer[512]:BYTE

	Invoke lstrcpy,ADDR Buffer,Offset szLine
	Invoke GetRCFileLineNumber,WordPositionInBlock
	PUSH EAX
	Invoke lstrlen,Offset szLine
	LEA ECX,Buffer
	ADD ECX,EAX	;"Line "=???? characters
	POP EDX
	Invoke BinToDec,EDX,ECX
	Invoke lstrcat,ADDR Buffer,Offset szComma
	Invoke lstrcat,ADDR Buffer,Offset szSpc
	Invoke GetWindowLong,hRCEditorWindow,0
	Invoke lstrcat,ADDR Buffer,ADDR CHILDWINDOWDATA.szFileName[EAX]
	Invoke lstrcat,ADDR Buffer,Offset szLineNotCompatible
	Invoke MessageBox,NULL,ADDR Buffer,Offset szAppName,MB_OK+MB_ICONINFORMATION+MB_TASKMODAL

	RET
NonCompatibleScriptMessage EndP

SetClipChildren Proc bFlag:DWORD
	Invoke GetWindowLong,hADialog,GWL_STYLE
	.If !bFlag
		MOV ECX,WS_CLIPCHILDREN
		NOT ECX
		AND EAX,ECX
	.Else
		OR EAX,WS_CLIPCHILDREN
	.EndIf
	Invoke SetWindowLong,hADialog,GWL_STYLE,EAX
	RET
SetClipChildren EndP

CreateDialogClass Proc
Local wc	:WNDCLASSEX

	;This is the class for the dialogs of the resource file
	MOV wc.cbSize,SizeOf WNDCLASSEX
	MOV wc.style,0;CS_HREDRAW OR CS_VREDRAW;CS_DBLCLKS	;
	MOV wc.lpfnWndProc,Offset RCDlgProc
	MOV wc.cbClsExtra,0
	MOV wc.cbWndExtra,0;4
	PUSH hInstance
	POP wc.hInstance
	MOV wc.hbrBackground,COLOR_3DFACE+1
	MOV wc.lpszMenuName,NULL
	MOV wc.lpszClassName,Offset szRCDlgClass
	MOV EAX,hMainIcon
	MOV wc.hIcon,EAX
	MOV wc.hIconSm,NULL;EAX
	Invoke LoadCursor,NULL,IDC_ARROW
	MOV wc.hCursor,EAX
	Invoke RegisterClassEx,ADDR wc
	;-------------------------------------------------
	MOV wc.lpfnWndProc,Offset TestDialogProc
	MOV wc.lpszClassName,Offset szRCTestDlgClass
	Invoke RegisterClassEx,ADDR wc
	;-------------------------------------------------
	Invoke RegisterClipboardFormat,Offset szRCDlgClass
	MOV hClipFormat,EAX

	RET
CreateDialogClass EndP

GetClosestPointOnGrid Proc
	;;EBX=X
	;;ESI=Y
	Invoke MulDiv,EBX,1,GridSize
	Invoke MulDiv,EAX,GridSize,1
	;Now EAX==X on the grid
	;INC EAX
	MOV EBX,EAX
	
	
	Invoke MulDiv,ESI,1,GridSize
	Invoke MulDiv,EAX,GridSize,1
	;Now EAX==Y on the grid
	;INC EAX
	MOV ESI,EAX

	RET
GetClosestPointOnGrid EndP

DeSelectWindow Proc hSel:HWND
	.If hSel
		MOV EAX,8
		.While EAX
			PUSH EAX
			Invoke GetWindowLong,hSel,GWL_USERDATA
			PUSH EAX
			Invoke DestroyWindow,hSel
			POP hSel
			POP EAX
			DEC EAX
		.EndW
	.EndIf
	MOV EAX,hSel
	RET
DeSelectWindow EndP

;Upon Completion hSelection should always be zero
DeMultiSelect Proc
	.If hSelection
		@@:
		Invoke DeSelectWindow,hSelection
		MOV hSelection,EAX
		.If EAX
			JMP @B
		.EndIf
	.EndIf

	RET
DeMultiSelect EndP

;Returns the handle of the Select Static Control
CreateOneSelection Proc Uses EBX xP:DWORD,yP:DWORD,hPar:HWND,fActive:DWORD,hPrv:HWND
	.If fActive
		MOV EDX,WS_CHILD or WS_VISIBLE OR WS_BORDER; OR SS_WHITERECT ;OR WS_CLIPSIBLINGS
	.Else
		MOV EDX,WS_CHILD or WS_VISIBLE OR SS_GRAYRECT  OR WS_BORDER;OR WS_CLIPSIBLINGS
	.EndIf
	Invoke CreateWindowEx,0,ADDR szStaticClass,0,EDX,xP,yP,6,6,hPar,0,hInstance,0
	MOV EBX,EAX
	Invoke SetWindowLong,EBX,GWL_USERDATA,hPrv
	Invoke SetWindowPos,EBX,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE
 
	MOV EAX,EBX
	RET
CreateOneSelection EndP

SelectWindow Proc Uses EBX hWin:HWND,fActive:DWORD
Local Rect		:RECT
Local Pt		:POINT
Local hSel		:HWND

	.If fActive
		Invoke GetParent,hWin
		MOV EBX,EAX
		
		Invoke GetWindowRect,hWin,ADDR Rect
		Invoke MapWindowPoints,NULL,EBX,ADDR Rect,2
		MOV EAX,Rect.right
		SUB EAX,Rect.left
		SHR EAX,1
		MOV ECX,Rect.left
		ADD ECX,EAX
		SUB ECX,3
		MOV Pt.x,ECX
		
		MOV EAX,Rect.bottom
		SUB EAX,Rect.top
		SHR EAX,1
		MOV ECX,Rect.top
		ADD ECX,EAX
		SUB ECX,3
		MOV Pt.y,ECX
		
		SUB Rect.left,6;7;6
		SUB Rect.top,6;7;6
	.Else
		MOV EAX,hWin
		MOV EBX,EAX
		
		Invoke GetClientRect,hWin,ADDR Rect
		MOV EAX,Rect.right
		SUB EAX,Rect.left
		SHR EAX,1
		MOV ECX,Rect.left
		ADD ECX,EAX
		SUB ECX,3
		MOV Pt.x,ECX
		
		MOV EAX,Rect.bottom
		SUB EAX,Rect.top
		SHR EAX,1
		MOV ECX,Rect.top
		ADD ECX,EAX
		SUB ECX,3
		MOV Pt.y,ECX
		
		SUB Rect.right,6
		SUB Rect.bottom,6
	.EndIf
	
	Invoke CreateOneSelection,Rect.left,Rect.top,EBX,fActive,hSelection
	Invoke CreateOneSelection,Pt.x,Rect.top,EBX,fActive,EAX
	Invoke CreateOneSelection,Rect.right,Rect.top,EBX,fActive,EAX
	Invoke CreateOneSelection,Rect.right,Pt.y,EBX,fActive,EAX
	Invoke CreateOneSelection,Rect.right,Rect.bottom,EBX,fActive,EAX
	Invoke CreateOneSelection,Pt.x,Rect.bottom,EBX,fActive,EAX
	Invoke CreateOneSelection,Rect.left,Rect.bottom,EBX,fActive,EAX
	Invoke CreateOneSelection,Rect.left,Pt.y,EBX,fActive,EAX

	MOV	hSelection,EAX

	RET
SelectWindow EndP

ConvertSelection Proc Uses EDI hSel:HWND
Local tvi:TVITEM

	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
	.If EAX
		MOV tvi._mask,TVIF_PARAM
		MOV tvi.hItem,EAX
		Invoke SendMessage,hDialogsTree,TVM_GETITEM,0,ADDR tvi
		;tvi.lParam holds the handle of a Dialog
		MOV EDI,tvi.lParam
		
		.If hSel
			MOV EAX,8
			.While EAX
				PUSH EAX
				Invoke GetWindowLong,hSel,GWL_USERDATA
				PUSH EAX
				Invoke DestroyWindow,hSel
				POP hSel
				POP EAX
				DEC EAX
			.EndW
		.EndIf
		
		MOV EAX,hSel
		MOV hSelection,EAX
		Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,FALSE
	.EndIf
	RET
ConvertSelection EndP

SetImageOfStaticControl Proc Uses ESI EDI lpWindowData:DWORD
Local Buffer[256]	:BYTE

	.If lpResourcesMem
		MOV EDI,lpWindowData
		MOV ESI,lpResourcesMem
		.While [ESI].RESOURCEMEM.Value
			.If [ESI].RESOURCEMEM.nType==0 || [ESI].RESOURCEMEM.nType==2	;i.e. bitmap or icon
				MOV Buffer,'#'
				Invoke BinToDec,[ESI].RESOURCEMEM.Value,ADDR Buffer[1]
				Invoke lstrcmp,ADDR Buffer,ADDR [EDI].CONTROLDATA.Caption
				.If EAX
					Invoke lstrcmp,ADDR Buffer[1],ADDR [EDI].CONTROLDATA.Caption
					.If !EAX
						CALL ImgFound
						.Break
					.EndIf
				.Else
					CALL ImgFound
					.Break
				.EndIf
			.EndIf
			LEA ESI,[ESI+SizeOf RESOURCEMEM]
		.EndW
			
		.If [ESI].RESOURCEMEM.nType==0
			MOV ECX,IMAGE_BITMAP
		.Else
			MOV ECX,IMAGE_ICON
		.EndIf
		
		Invoke SendMessage,[EDI].CONTROLDATA.hChild,STM_SETIMAGE,ECX,[EDI].CONTROLDATA.hImg
		
	.EndIf

	RET
	
	;-----------------------------------------------------------------------
	ImgFound:
	;--------
	MOV ECX,LR_LOADFROMFILE OR LR_DEFAULTSIZE
	MOV EDX,[EDI].CONTROLDATA.Style
	AND EDX,SS_REALSIZEIMAGE
	.If EDX==SS_REALSIZEIMAGE
		MOV ECX,LR_LOADFROMFILE
	.EndIf
	.If [ESI].RESOURCEMEM.nType==0	;Bitmap
		Invoke LoadImage,NULL,ADDR [ESI].RESOURCEMEM.szFile,IMAGE_BITMAP,NULL,NULL,ECX
	.Else	
		Invoke LoadImage,NULL,ADDR [ESI].RESOURCEMEM.szFile,IMAGE_ICON,NULL,NULL,ECX; or LR_DEFAULTSIZE
	.EndIf
	MOV [EDI].CONTROLDATA.hImg,EAX
	RETN

SetImageOfStaticControl EndP

ReCreateControl Proc Uses EDI lpControlData:DWORD
Local Buffer[256]	:BYTE
Local hCtl			:DWORD
Local TabItem		:TC_ITEM

	MOV EDI,lpControlData
	
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22
		Invoke DestroyWindow,[EDI].CONTROLDATA.hChild
	.Else
		Invoke DestroyWindow,[EDI].CONTROLDATA.hWnd
	.EndIf

	;Look!!!!!!!! (handle \t, \n, \\, "")
	Invoke TranformText,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer

	MOV ECX,[EDI].CONTROLDATA.Style
	AND	ECX,-1 XOR (WS_POPUP)
	OR ECX,WS_ALLCHILDS
	.If [EDI].CONTROLDATA.ntype==2			;Edit
		LEA EDX,szEditClass
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hADialog,NULL,hInstance,NULL
		MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		
	.ElseIf [EDI].CONTROLDATA.ntype==13		;StatusBar
		LEA EDX,szStatusBarClass
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hADialog,NULL,hInstance,NULL
		MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		
	.ElseIf [EDI].CONTROLDATA.ntype==9 || [EDI].CONTROLDATA.ntype==10	;scrollbar
		LEA EDX,szScrollBarClass
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hADialog,NULL,hInstance,NULL
		MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		
	.ElseIf [EDI].CONTROLDATA.ntype==7
		OR ECX,CBS_NOINTEGRALHEIGHT
		LEA EDX,szComboBoxClass
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hADialog,NULL,hInstance,NULL
		MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		
	.ElseIf [EDI].CONTROLDATA.ntype==11	;TabControl
		LEA EDX,szTabControlClass
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hADialog,NULL,hInstance,NULL
		MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		
		MOV TabItem.imask,TCIF_TEXT
		MOV TabItem.pszText, Offset szTab1
		Invoke SendMessage,hCtl,TCM_INSERTITEM,0,ADDR TabItem
		MOV TabItem.pszText, Offset szTab0
		Invoke SendMessage,hCtl,TCM_INSERTITEM,0,ADDR TabItem
		Invoke SendMessage,hCtl,TCM_SETCURSEL,0,NULL

	.ElseIf [EDI].CONTROLDATA.ntype==22 || [EDI].CONTROLDATA.ntype==21 ;shape or image 
		MOV EAX,[EDI].CONTROLDATA.hWnd
		MOV hCtl,EAX
		LEA EDX,szStaticClass
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,ADDR Buffer,ECX,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,EAX,NULL,hInstance,NULL
		MOV [EDI].CONTROLDATA.hChild,EAX
		Invoke SetWindowPos,EAX,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE; OR SWP_NOOWNERZORDER
		Invoke SendMessage,[EDI].CONTROLDATA.hChild,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
	.ElseIf [EDI].CONTROLDATA.ntype==23
		PUSH EBX
		PUSH ECX
		LEA EBX,[EDI].CONTROLDATA.Class
		Invoke IsThereSuchAClass,EBX
		.If !EAX
			LEA EBX,szStaticClass
		.EndIf
		POP ECX
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EBX,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hADialog,NULL,hInstance,NULL
		MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		POP EBX
	.EndIf

	Invoke SetWindowLong,hCtl,GWL_USERDATA,EDI
	
	;Retrieve handle of next sibling item
	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_NEXT,[EDI].CONTROLDATA.hTreeItem
	.If EAX
		Invoke GetTreeItemParameter,hDialogsTree,EAX
		MOV EDX,[EAX].CONTROLDATA.hWnd
	.Else
		MOV EDX,HWND_TOP
	.EndIf
	Invoke SetWindowPos,hCtl,EDX,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE
	
	
	LEA ECX,[EDI].CONTROLDATA.IDName
	.If BYTE PTR [ECX]==0
		MOV ECX,[EDI].CONTROLDATA.ID
		Invoke BinToDec,ECX,ADDR Buffer
		LEA ECX,Buffer
	.EndIf
	
	
	.If [EDI].CONTROLDATA.ntype==7
		Invoke SendMessage,hCtl,CB_ADDSTRING,0,ECX
		Invoke SendMessage,hCtl,CB_SETCURSEL,0,0
	.ElseIf [EDI].CONTROLDATA.ntype==21
		LEA EAX,[EDI].CONTROLDATA.Caption
		.If BYTE PTR [EAX]
			Invoke DeleteObject,[EDI].CONTROLDATA.hImg
			Invoke SetImageOfStaticControl,EDI
		.EndIf
	.EndIf

	RET
ReCreateControl EndP

CreateControl Proc Uses EBX EDI ESI lpDialogData:DWORD, hPar:HWND
Local tvinsert		:TV_INSERTSTRUCT
Local TabItem		:TC_ITEM
Local rbi			:REBARBANDINFO
Local lvi			:LVITEM
Local Buffer[256]	:BYTE

	MOV EDI,lpDialogData
	
	MOV EAX,[EDI].CONTROLDATA.ID
	.If EAX<=7FFFFFFFh && EAX>HighestWindowDialogID
		MOV HighestWindowDialogID,EAX
	.EndIf

	MOV EBX,[EDI].CONTROLDATA.ntype
	.If EBX==1		;Static
		LEA ESI,szStaticClass
		CALL CreateTheControl
	.ElseIf EBX==2	;Edit
		LEA ESI,szEditClass
		CALL CreateTheControl
	.ElseIf EBX==3	;GroupBox
		Invoke CreateWindowEx,0,ADDR szStaticClass,NULL,WS_CHILD OR WS_VISIBLE OR SS_LEFT OR WS_CLIPSIBLINGS,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hPar,NULL,hInstance,NULL
		PUSH hPar
		MOV hPar,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		Invoke SetWindowPos,hPar,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE
		;---------------------------------------------------------------------
		;Look!!!!!!!! (handle \t, \n, \\, "")
		Invoke TranformText,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
		
		LEA EDX,szButtonClass
		MOV ECX,[EDI].CONTROLDATA.Style
		AND	ECX,-1 XOR (WS_POPUP)
		OR ECX,WS_ALLCHILDS
		
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,ADDR Buffer,ECX,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hPar,NULL,hInstance,NULL
		MOV [EDI].CONTROLDATA.hChild,EAX
		Invoke SetWindowPos,[EDI].CONTROLDATA.hChild,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE; OR SWP_NOOWNERZORDER
		Invoke SendMessage,[EDI].CONTROLDATA.hChild,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
		MOV EAX,hPar
		POP hPar
	.ElseIf EBX==4	;BS_PUSHBUTTON & BS_DEFPUSHBUTTON
		LEA ESI,szButtonClass
		CALL CreateTheControl
	.ElseIf EBX==5	;BS_AUTOCHECKBOX
		LEA ESI,szButtonClass
		CALL CreateTheControl
	.ElseIf EBX==6	;BS_RADIOBUTTON
		LEA ESI,szButtonClass
		CALL CreateTheControl
	.ElseIf EBX==7	;ComboBox
		LEA ESI,szComboBoxClass
		CALL CreateTheControl
		
		LEA ECX,[EDI].CONTROLDATA.IDName
		.If BYTE PTR [ECX]==0
			MOV ECX,[EDI].CONTROLDATA.ID
			Invoke BinToDec,ECX,ADDR Buffer
			LEA ECX,Buffer
		.EndIf
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,CB_ADDSTRING,0,ECX
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,CB_SETCURSEL,0,0
		
	.ElseIf EBX==8	;ListBox
		LEA ESI,szListBoxClass
		CALL CreateTheControl
		
		LEA ECX,[EDI].CONTROLDATA.IDName
		.If BYTE PTR [ECX]==0
			MOV ECX,[EDI].CONTROLDATA.ID
			Invoke BinToDec,ECX,ADDR Buffer
			LEA ECX,Buffer
		.EndIf
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,LB_ADDSTRING,0,ECX
		
	.ElseIf EBX==9	;Horizontal Scrollbar
		LEA ESI,szScrollBarClass
		CALL CreateTheControl
		
	.ElseIf EBX==10	;Vertical Scrollbar
		LEA ESI,szScrollBarClass
		CALL CreateTheControl
		
	.ElseIf EBX==11	;TabControl
		LEA ESI,szTabControlClass
		CALL CreateTheControl	
		
		MOV TabItem.imask,TCIF_TEXT
		MOV TabItem.pszText,Offset szTab1
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TCM_INSERTITEM,0,ADDR TabItem
		MOV TabItem.pszText,Offset szTab0
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TCM_INSERTITEM,0,ADDR TabItem
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TCM_SETCURSEL,0,NULL
		
	.ElseIf EBX==12	;ToolBar
		LEA ESI,szToolBarClass
		CALL CreateTheControl	
		
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TB_BUTTONSTRUCTSIZE,SizeOf TBBUTTON,0
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TB_ADDBUTTONS,5,ADDR tbResource
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TB_SETIMAGELIST,0,hImlNormal
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TB_SETDISABLEDIMAGELIST,0,hImlNormal
		
	.ElseIf EBX==13	;StatusBar
		LEA ESI,szStatusBarClass
		CALL CreateTheControl	
	.ElseIf EBX==14	;ProgressBar
		LEA ESI,szProgressBarClass
		CALL CreateTheControl
		
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,PBM_STEPIT,0,0
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,PBM_STEPIT,0,0
		
	.ElseIf EBX==15	;Rebar
		LEA ESI,szReBarClass
		CALL CreateTheControl
		
		Invoke CreateWindowEx,0,ADDR szStaticClass,ADDR [EDI].CONTROLDATA.IDName,WS_CHILD OR WS_VISIBLE OR SS_LEFT OR WS_CLIPSIBLINGS,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,[EDI].CONTROLDATA.hWnd,NULL,hInstance,NULL
		MOV rbi.hwndChild,EAX
		MOV [EDI].CONTROLDATA.hChild,EAX
		;Invoke SendMessage,EAX,WM_SETFONT,hFontTahoma,FALSE
		MOV rbi.cbSize, SizeOf REBARBANDINFO
		MOV rbi.fMask,RBBIM_STYLE or RBBIM_CHILD or RBBIM_SIZE or RBBIM_CHILDSIZE
		MOV rbi.fStyle,RBBS_GRIPPERALWAYS or RBBS_CHILDEDGE
		MOV EAX,[EDI].CONTROLDATA.ccx
		MOV rbi.lx,EAX
		MOV EAX,[EDI].CONTROLDATA.ccx
		MOV rbi.cxMinChild,EAX
		MOV EAX,[EDI].CONTROLDATA.ccy
		MOV rbi.cyMinChild,EAX
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,RB_INSERTBAND,0,ADDR rbi
		
	.ElseIf EBX==16	;UpDown
		LEA ESI,szUpDownClass
		CALL CreateTheControl	
	.ElseIf EBX==17	;TreeView
		LEA ESI,szTreeViewClass
		CALL CreateTheControl
		
		MOV tvinsert.item._mask,TVIF_TEXT
		LEA EAX,[EDI].CONTROLDATA.IDName
		MOV tvinsert.item.pszText,EAX
		MOV tvinsert.item.cchTextMax,256
		MOV tvinsert.hParent,NULL
		MOV tvinsert.hInsertAfter,TVI_ROOT
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TVM_INSERTITEM,0,ADDR tvinsert
		PUSH EAX
		MOV tvinsert.hParent,EAX
		MOV tvinsert.item.pszText,CTEXT("ChildItem")
		MOV tvinsert.hInsertAfter,TVI_LAST
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,TVM_INSERTITEM,0,ADDR tvinsert
		POP EAX
		Invoke SendMessage, [EDI].CONTROLDATA.hWnd, TVM_EXPAND, TVE_EXPAND, EAX
		
	.ElseIf EBX==18	;ListView
		LEA ESI,szListViewClass
		CALL CreateTheControl
		
		MOV lvi.imask, LVIF_TEXT
		MOV lvi.iSubItem, 0
		MOV lvi.cchTextMax,256
		MOV lvi.iItem,0
		LEA EAX,[EDI].CONTROLDATA.IDName
		MOV lvi.pszText,EAX
		Invoke SendMessage,[EDI].CONTROLDATA.hWnd,LVM_INSERTITEM,0,ADDR lvi
		
	.ElseIf EBX==19	;TrackBar
		LEA ESI,szTrackBarClass
		CALL CreateTheControl
	.ElseIf EBX==20	;RichEdit
		LEA ESI,szRichEditClass
		CALL CreateTheControl
	.ElseIf EBX==21	|| EBX==22	;Image OR Shape
		;Create The PARENT Of the Control
		Invoke CreateWindowEx,NULL,ADDR szStaticClass,NULL,WS_CHILD OR WS_VISIBLE OR WS_CLIPSIBLINGS,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hPar,NULL,hInstance,NULL
		PUSH hPar
		MOV hPar,EAX
		;MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		Invoke SetWindowPos,hPar,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE
		
		LEA EDX,szStaticClass
		;---------------------------------------------------------------------
		;Create The Control
		MOV ECX,[EDI].CONTROLDATA.Style
		AND	ECX,-1 XOR (WS_POPUP)
		OR ECX,WS_ALLCHILDS
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,EDX,NULL,ECX,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hPar,NULL,hInstance,NULL
		
		MOV [EDI].CONTROLDATA.hChild,EAX
		Invoke SetWindowPos,EAX,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE; OR SWP_NOOWNERZORDER
		
		MOV EAX,hPar
		POP hPar
		
		LEA EAX,[EDI].CONTROLDATA.Caption
		.If BYTE PTR [EAX] && [EDI].CONTROLDATA.ntype==21
			Invoke SetImageOfStaticControl,EDI
		.EndIf
	.ElseIf EBX==23 || EBX==24	;Managed custom control
		;CUSTOMCONTROL STRUCT
		;	szFriendlyName		DB	24+1		DUP (?)
		;	szClassName			DB	24+1		DUP (?)
		;	szDescription		DB	256+1		DUP (?)
		;	szDLLFullPathName	DB	MAX_PATH+1	DUP (?)
		;	szStyles			DB	16*(24+1)	DUP (?)
		;CUSTOMCONTROL ENDS
		.If [EDI].CONTROLDATA.ntype==24
		
			Invoke GetPointerToManagedControl,ADDR [EDI].CONTROLDATA.Class
			MOV ESI,EAX
			LEA ECX,[ESI].CUSTOMCONTROL.szDLLFullPathName
			.If BYTE PTR [ECX] && [ESI].CUSTOMCONTROLEX.hLib==0
				Invoke LoadLibrary,ECX
				.If EAX
					MOV [ESI].CUSTOMCONTROLEX.hLib,EAX
				.EndIf
			.EndIf
		
			Invoke IsThereSuchAClass,ADDR [ESI].CUSTOMCONTROL.szClassName
			.If !EAX
				LEA ESI,szStaticClass
			.Else
				INC [ESI].CUSTOMCONTROLEX.ReferenceCount
				LEA ESI,[ESI].CUSTOMCONTROL.szClassName
			.EndIf
		.Else
			LEA ESI,[EDI].CONTROLDATA.Class
			Invoke IsThereSuchAClass,ESI
			.If !EAX
				LEA ESI,szStaticClass
			.EndIf
		.EndIf
		
		;Create The PARENT Of the Control
		Invoke CreateWindowEx,NULL,ADDR szStaticClass,NULL,WS_CHILD OR WS_VISIBLE OR WS_CLIPSIBLINGS,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hPar,NULL,hInstance,NULL
		PUSH hPar
		MOV hPar,EAX
		;MOV hCtl,EAX
		MOV [EDI].CONTROLDATA.hWnd,EAX
		Invoke SetWindowPos,hPar,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE
		
		;---------------------------------------------------------------------
		;Create The Control
		;Look!!!!!!!! (handle \t, \n, \\, "")
		Invoke TranformText,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
		
		MOV ECX,[EDI].CONTROLDATA.Style
		AND	ECX,-1 XOR (WS_POPUP)
		OR ECX,WS_ALLCHILDS
		Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,ESI,ADDR Buffer,ECX,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hPar,NULL,hInstance,NULL
		MOV [EDI].CONTROLDATA.hChild,EAX
		Invoke SetWindowPos,EAX,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE; OR SWP_NOOWNERZORDER
		Invoke SendMessage,[EDI].CONTROLDATA.hChild,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
		
		POP hPar
		
	.EndIf
	
	MOV tvinsert.item.iSelectedImage,EBX
	MOV tvinsert.item.iImage,EBX

	Invoke SetWindowLong,[EDI].CONTROLDATA.hWnd,GWL_USERDATA,EDI
	Invoke SetProperties,EDI

	
	MOV tvinsert.item.lParam,EDI
	Invoke GetWindowLong,hPar,GWL_USERDATA
	MOV EAX,[EAX].CONTROLDATA.hTreeItem
	
	;Add Control To Tree
	MOV tvinsert.hParent,EAX
	LEA EBX,[EDI].CONTROLDATA.IDName
	.If BYTE PTR [EBX]==0
		MOV ECX,[EDI].CONTROLDATA.ID
		Invoke BinToDec,ECX,ADDR Buffer
		LEA EBX,Buffer
	.EndIf
	MOV tvinsert.item.pszText,EBX
	MOV tvinsert.item._mask,TVIF_TEXT+TVIF_PARAM+TVIF_IMAGE+TVIF_SELECTEDIMAGE
	MOV tvinsert.hInsertAfter,TVI_LAST
	Invoke SendMessage,hDialogsTree,TVM_INSERTITEM,0,ADDR tvinsert
	MOV [EDI].CONTROLDATA.hTreeItem,EAX

	RET
	
	;-----------------------------------------------------------------------
	CreateTheControl:
	;Look!!!!!!!! (handle \t, \n, \\, "")
	Invoke TranformText,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer

	MOV ECX,[EDI].CONTROLDATA.Style
	AND	ECX,-1 XOR (WS_POPUP)
	OR ECX,WS_ALLCHILDS
	.If [EDI].CONTROLDATA.ntype==15		;Rebar
		AND ECX,-1 XOR CCS_TOP
		OR ECX,CCS_NORESIZE
	.ElseIf [EDI].CONTROLDATA.ntype==7	;ComboBox
		OR ECX,CBS_NOINTEGRALHEIGHT
	.EndIf 
	Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,ESI,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hPar,NULL,hInstance,NULL
	;MOV hCtl,EAX
	MOV [EDI].CONTROLDATA.hWnd,EAX
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE; OR SWP_NOOWNERZORDER
	Invoke SendMessage,[EDI].CONTROLDATA.hWnd,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
	RETN
	
CreateControl EndP

ConvertToDialogUnits Proc Uses ESI lpMem:DWORD
Local hDC		:HDC
Local TextSize	:_SIZE
Local bux		:DWORD
Local buy		:DWORD
Local Rect		:RECT

	MOV ESI,lpMem
	.If [ESI].CONTROLDATA.hFont
		Invoke GetDC,NULL
		MOV hDC,EAX
		Invoke SelectObject,hDC,[ESI].CONTROLDATA.hFont
		PUSH EAX	;OldFont
		Invoke GetTextExtentPoint32,hDC,Offset szAllAlphaNumeric,52,ADDR TextSize
		M2M buy,TextSize.y
		Invoke MulDiv,TextSize.x,1,52;4
		MOV bux,EAX
		POP EAX
		Invoke SelectObject,hDC,EAX
		Invoke ReleaseDC,NULL,hDC
	.Else
		Invoke GetDialogBaseUnits
		MOV EDX,EAX
		AND EAX,0FFFFh
		MOV bux,EAX
		SHR EDX,16
		MOV buy,EDX
	.EndIf

	.If [ESI].CONTROLDATA.ntype==0
		MOV EDX,[ESI].CONTROLDATA.Style
		MOV EAX,[ESI].CONTROLDATA.Style
;		AND EAX,(WS_POPUP OR WS_CHILD)
;		.If !EAX
;			OR EDX,WS_CAPTION ;(Thanks IanB)
;		.Else
;			MOV EAX,[ESI].CONTROLDATA.Style
			AND EAX,DS_CONTROL
			.If EAX
				AND EDX,-1 XOR WS_CAPTION
			.EndIf
;		.EndIf

		MOV Rect.left,0
		MOV Rect.top,0
		MOV Rect.right,0
		MOV Rect.bottom,0
		
;		LEA EAX,[ESI].CONTROLDATA.MenuID
		MOV ECX,FALSE
;		.If BYTE PTR [EAX]
;			MOV ECX,TRUE
;		.EndIf

		Invoke AdjustWindowRectEx,ADDR Rect,EDX,ECX,[ESI].CONTROLDATA.ExStyle
		MOV EAX,Rect.bottom
		SUB EAX,Rect.top				;These are pixels
		SUB [ESI].CONTROLDATA.duccy,EAX	;These are pixels
			
		MOV EAX,Rect.right
		SUB EAX,Rect.left				;These are pixels
		SUB [ESI].CONTROLDATA.duccx,EAX	;These are pixels
	.EndIf

	;Convert them to Dialog Units
	Invoke MulDiv,[ESI].CONTROLDATA.duy,8,buy
	MOV [ESI].CONTROLDATA.duy,EAX
	
	Invoke MulDiv,[ESI].CONTROLDATA.duccy,8,buy
	MOV [ESI].CONTROLDATA.duccy,EAX

	Invoke MulDiv,[ESI].CONTROLDATA.duccx,4,bux
	MOV [ESI].CONTROLDATA.duccx,EAX

	Invoke MulDiv,[ESI].CONTROLDATA.dux,4,bux
	MOV [ESI].CONTROLDATA.dux,EAX


	RET
ConvertToDialogUnits EndP

ConvertToPixels Proc Uses ESI lpMem:DWORD
Local hDC		:HDC
Local TextSize	:_SIZE
Local bux		:DWORD
Local buy		:DWORD
Local Rect		:RECT
	
	MOV ESI,lpMem
	.If [ESI].CONTROLDATA.hFont
		Invoke GetDC,NULL
		MOV hDC,EAX
		Invoke SelectObject,hDC,[ESI].CONTROLDATA.hFont
		PUSH EAX	;OldFont
		Invoke GetTextExtentPoint32,hDC,Offset szAllAlphaNumeric,52,ADDR TextSize
		M2M buy,TextSize.y
		Invoke MulDiv,TextSize.x,1,52;54
		MOV bux,EAX
		POP EAX
		Invoke SelectObject,hDC,EAX
		Invoke ReleaseDC,NULL,hDC
	.Else
		Invoke GetDialogBaseUnits
		MOV EDX,EAX
		AND EAX,0FFFFh
		MOV bux,EAX
		SHR EDX,16
		MOV buy,EDX
	.EndIf
;PrintDec bux
;MOV EAX,[ESI].CONTROLDATA.ccx
;PrintDec eax
	Invoke MulDiv,[ESI].CONTROLDATA.y,buy,8
	MOV [ESI].CONTROLDATA.y,EAX

	Invoke MulDiv,[ESI].CONTROLDATA.ccy,buy,8
	MOV [ESI].CONTROLDATA.ccy,EAX

	Invoke MulDiv,[ESI].CONTROLDATA.ccx,bux,4
	MOV [ESI].CONTROLDATA.ccx,EAX

;PrintDec eax

	Invoke MulDiv,[ESI].CONTROLDATA.x,bux,4
	MOV [ESI].CONTROLDATA.x,EAX

	.If [ESI].CONTROLDATA.ntype==0
		MOV EDX,[ESI].CONTROLDATA.Style
		MOV EAX,[ESI].CONTROLDATA.Style
;		AND EAX,(WS_POPUP OR WS_CHILD)
;		.If !EAX
;			OR EDX,WS_CAPTION ;(Thanks IanB)
;		.Else
;			MOV EAX,[ESI].CONTROLDATA.Style
			AND EAX,DS_CONTROL
			.If EAX
				AND EDX,-1 XOR WS_CAPTION
			.EndIf
;		.EndIf
	
	
		MOV Rect.left,0
		MOV Rect.top,0
		MOV Rect.right,0
		MOV Rect.bottom,0
;		LEA EAX,[ESI].CONTROLDATA.MenuID
		MOV ECX,FALSE
;		.If BYTE PTR [EAX]
;			MOV ECX,TRUE
;		.EndIf
		Invoke AdjustWindowRectEx,ADDR Rect,EDX,ECX,[ESI].CONTROLDATA.ExStyle
		MOV EAX,Rect.bottom
		SUB EAX,Rect.top
		ADD [ESI].CONTROLDATA.ccy,EAX
		
		MOV EAX,Rect.right
		SUB EAX,Rect.left
		ADD [ESI].CONTROLDATA.ccx,EAX
	.EndIf
	
	RET
ConvertToPixels EndP

PrepareAndConvertToPixels Proc Uses EDI lpWindowData:DWORD
	MOV EDI,lpWindowData
	M2M [EDI].CONTROLDATA.x,[EDI].CONTROLDATA.dux
	M2M [EDI].CONTROLDATA.y,[EDI].CONTROLDATA.duy
	M2M [EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.duccx
	M2M [EDI].CONTROLDATA.ccy,[EDI].CONTROLDATA.duccy
	Invoke ConvertToPixels,EDI

;|| [EDI].CONTROLDATA.ntype==15 
	.If [EDI].CONTROLDATA.ntype==3 || [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22 || [EDI].CONTROLDATA.ntype==23 || [EDI].CONTROLDATA.ntype==24;i.e. GroupBox,image,shape
		Invoke MoveWindow,[EDI].CONTROLDATA.hChild,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,TRUE
		Invoke InvalidateRect,[EDI].CONTROLDATA.hWnd,NULL,TRUE
;	.ElseIf  [EDI].CONTROLDATA.ntype==15	;Rebar
;		Invoke SetWindowPos,[EDI].CONTROLDATA.hChild,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_SHOWWINDOW
;		Invoke InvalidateRect,[EDI].CONTROLDATA.hWnd,NULL,TRUE
	.EndIf

	RET
PrepareAndConvertToPixels EndP


PrepareAndConvertToDialogUnits Proc Uses EDI lpWindowData:DWORD
Local rbi			:REBARBANDINFO

	MOV EDI,lpWindowData
	M2M [EDI].CONTROLDATA.dux,[EDI].CONTROLDATA.x
	M2M [EDI].CONTROLDATA.duy,[EDI].CONTROLDATA.y
	M2M [EDI].CONTROLDATA.duccx,[EDI].CONTROLDATA.ccx
	M2M [EDI].CONTROLDATA.duccy,[EDI].CONTROLDATA.ccy
	Invoke ConvertToDialogUnits,EDI

 
	.If [EDI].CONTROLDATA.ntype==3 || [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22  || [EDI].CONTROLDATA.ntype==23 || [EDI].CONTROLDATA.ntype==24;i.e. GroupBox,image,shape
		Invoke MoveWindow,[EDI].CONTROLDATA.hChild,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,TRUE
		Invoke InvalidateRect,[EDI].CONTROLDATA.hWnd,NULL,TRUE
	.ElseIf [EDI].CONTROLDATA.ntype==15
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

	RET
PrepareAndConvertToDialogUnits EndP
 
MultiAlignLefts Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	.If !hFirstStatic
		PUSH [EDI].CONTROLDATA.x
		POP xLeft
	.Else
		PUSH xLeft
		POP [EDI].CONTROLDATA.x
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf

	.EndIf
	RET
MultiAlignLefts EndP


MultiAlignCenters Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
Local Rect	:RECT

	MOV EDI,lpWindowData
	.If !hFirstStatic
		Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR Rect
		Invoke GetParent,[EDI].CONTROLDATA.hWnd
		PUSH 2
		LEA ECX,Rect
		PUSH ECX
		PUSH EAX
		PUSH NULL
		CALL MapWindowPoints


		MOV EAX,Rect.right
		SUB EAX,Rect.left
		SHR EAX,1
		ADD EAX,Rect.left
		MOV xCenter,EAX

	.Else
		MOV EAX,[EDI].CONTROLDATA.ccx	;Do not forget: This is width
		SHR EAX,1
		MOV EDX,xCenter
		SUB EDX,EAX
		
		MOV [EDI].CONTROLDATA.x,EDX
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf
	.EndIf
	RET
MultiAlignCenters EndP

ChangePosProperties Proc Uses EDI lpWindowData:DWORD
Local Buffer[256]:BYTE

	MOV EDI,lpWindowData
	Invoke BinToDec,[EDI].CONTROLDATA.dux,ADDR Buffer
	Invoke SetItemText,hPropertiesList,2,1,ADDR Buffer
	
	Invoke BinToDec,[EDI].CONTROLDATA.duy,ADDR Buffer
	Invoke SetItemText,hPropertiesList,3,1,ADDR Buffer

	Invoke BinToDec,[EDI].CONTROLDATA.duccx,ADDR Buffer
	Invoke SetItemText,hPropertiesList,4,1,ADDR Buffer


	Invoke BinToDec,[EDI].CONTROLDATA.duccy,ADDR Buffer
	Invoke SetItemText,hPropertiesList,5,1,ADDR Buffer
	RET
ChangePosProperties EndP

ChangePosPropertiesAndReselect Proc Uses EDI lpWindowData:DWORD
	MOV EDI,lpWindowData
	Invoke ChangePosProperties,EDI
	;Let's move the Selection statics for the active control only!
	Invoke DeSelectWindow,hSelection
	MOV hSelection,EAX
	Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
	RET
ChangePosPropertiesAndReselect EndP

MultiAlignCentersWithDialogCenter Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
Local Rect	:RECT

	MOV EDI,lpWindowData
	.If !hFirstStatic
		Invoke GetParent,[EDI].CONTROLDATA.hWnd
		;Now EAX is (hopefully!) the Dialog handle
		LEA ECX,Rect
		PUSH ECX
		PUSH EAX
		CALL GetClientRect
		
		MOV EAX,Rect.right
		SUB EAX,Rect.left
		SHR EAX,1
		ADD EAX,Rect.left
		MOV xCenter,EAX
	.EndIf

	MOV EAX,[EDI].CONTROLDATA.ccx	;Do not forget: This is width
	SHR EAX,1
	MOV EDX,xCenter
	SUB EDX,EAX
	
	MOV [EDI].CONTROLDATA.x,EDX

	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf

	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
;		Invoke ChangePosProperties,EDI
		;Let's move the Selection statics for the active control only!
;		Invoke DeSelectWindow,hSelection
;		MOV hSelection,EAX
;		Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
	.EndIf

	RET
MultiAlignCentersWithDialogCenter EndP

MultiAlignRights Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
Local Rect	:RECT

	MOV EDI,lpWindowData
	.If !hFirstStatic
	;xRight
		Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR Rect
		Invoke GetParent,[EDI].CONTROLDATA.hWnd
		PUSH 2
		LEA ECX,Rect
		PUSH ECX
		PUSH EAX
		PUSH NULL
		CALL MapWindowPoints
		M2M xRight,Rect.right
	.Else
		MOV EAX,xRight
		SUB EAX,[EDI].CONTROLDATA.ccx
		MOV [EDI].CONTROLDATA.x,EAX
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf

	.EndIf
	RET
MultiAlignRights EndP

MultiAlignTops Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
	MOV EDI,lpWindowData
	.If !hFirstStatic
		PUSH [EDI].CONTROLDATA.y
		POP xTop
	.Else
		PUSH xTop
		POP [EDI].CONTROLDATA.y
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf
	.EndIf
	RET
MultiAlignTops EndP

MultiAlignMiddles Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
Local Rect	:RECT

	MOV EDI,lpWindowData
	.If !hFirstStatic
		Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR Rect

		Invoke GetParent,[EDI].CONTROLDATA.hWnd
		PUSH 2
		LEA ECX,Rect
		PUSH ECX
		PUSH EAX
		PUSH NULL
		CALL MapWindowPoints
		
		MOV EAX,Rect.bottom
		SUB EAX,Rect.top
		SHR EAX,1
		ADD EAX,Rect.top
		MOV xMiddle,EAX
		
	.Else
		MOV EAX,[EDI].CONTROLDATA.ccy	;Do not forget: This is width
		SHR EAX,1
		MOV EDX,xMiddle
		SUB EDX,EAX
		
		MOV [EDI].CONTROLDATA.y,EDX
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf

	.EndIf
	RET
MultiAlignMiddles EndP

MultiAlignMiddlesWithDialogMiddle Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
Local Rect	:RECT

	MOV EDI,lpWindowData
	.If !hFirstStatic
		Invoke GetParent,[EDI].CONTROLDATA.hWnd
		;Now EAX is (hopefully!) the Dialog handle
		LEA ECX,Rect
		PUSH ECX
		PUSH EAX
		CALL GetClientRect
		
		MOV EAX,Rect.bottom
		SUB EAX,Rect.top
		SHR EAX,1
		ADD EAX,Rect.top
		MOV xMiddle,EAX
	.EndIf

	MOV EAX,[EDI].CONTROLDATA.ccy	;Do not forget: This is height
	SHR EAX,1
	MOV EDX,xMiddle
	SUB EDX,EAX



	
	MOV [EDI].CONTROLDATA.y,EDX
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf

	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
	.EndIf

	RET
MultiAlignMiddlesWithDialogMiddle EndP

MultiAlignBottoms Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
Local Rect	:RECT

	MOV EDI,lpWindowData
	.If !hFirstStatic
		Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR Rect
		Invoke GetParent,[EDI].CONTROLDATA.hWnd
		PUSH 2
		LEA ECX,Rect
		PUSH ECX
		PUSH EAX
		PUSH NULL
		CALL MapWindowPoints
		M2M xBottom,Rect.bottom
	.Else
		MOV EAX,xBottom
		SUB EAX,[EDI].CONTROLDATA.ccy
		MOV [EDI].CONTROLDATA.y,EAX
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf
	.EndIf
	RET
MultiAlignBottoms EndP

AdjustSelection Proc Uses EDI ESI EBX lpWindowData:DWORD, hFirstStatic:DWORD
Local Rect	:RECT

	Invoke GetClientRect,[EDI].CONTROLDATA.hWnd,ADDR Rect
	SUB Rect.bottom,6
	SUB Rect.right,6	

	MOV EDI,lpWindowData
	MOV EBX,hFirstStatic
	MOV ESI,8
	.While ESI
		.If ESI==8
			MOV EAX,Rect.left
			MOV ECX,Rect.bottom
			SHR ECX,1
		.ElseIf ESI==7
			MOV EAX,Rect.left
			MOV ECX,Rect.bottom
		.ElseIf ESI==6
			MOV EAX,Rect.right
			SHR EAX,1
			MOV ECX,Rect.bottom
		.ElseIf ESI==5
			MOV EAX,Rect.right
			MOV ECX,Rect.bottom
		.ElseIf ESI==4
			MOV EAX,Rect.right
			MOV ECX,Rect.bottom
			SHR ECX,1
		.ElseIf ESI==3
			MOV EAX,Rect.right
			MOV ECX,Rect.top
		.ElseIf ESI==2
			MOV EAX,Rect.right
			SHR EAX,1
			MOV ECX,Rect.top
		.ElseIf ESI==1
			MOV EAX,Rect.left
			MOV ECX,Rect.top
		.EndIf
		Invoke SetWindowPos,EBX,HWND_TOP,EAX,ECX,6,6,SWP_NOACTIVATE
		
		Invoke GetWindowLong,EBX,GWL_USERDATA
		MOV EBX,EAX
		DEC ESI
	.EndW	
	RET
AdjustSelection EndP

MultiMakeSameWidth Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
	MOV EDI,lpWindowData
	.If !hFirstStatic
		PUSH [EDI].CONTROLDATA.ccx
		POP xWidth
	.Else
		PUSH xWidth
		POP [EDI].CONTROLDATA.ccx
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf
		
		Invoke AdjustSelection,EDI,hFirstStatic
	.EndIf

	RET
MultiMakeSameWidth EndP

MultiMakeSameHeight Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	.If !hFirstStatic
		PUSH [EDI].CONTROLDATA.ccy
		POP xHeight
	.Else
		PUSH xHeight
		POP [EDI].CONTROLDATA.ccy
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf

		Invoke AdjustSelection,EDI,hFirstStatic
	.EndIf

	RET
MultiMakeSameHeight EndP

MultiMakeSameSize Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
	MOV EDI,lpWindowData
	.If !hFirstStatic
		PUSH [EDI].CONTROLDATA.ccy
		POP xHeight
		PUSH [EDI].CONTROLDATA.ccx
		POP xWidth
	.Else
		PUSH xHeight
		POP [EDI].CONTROLDATA.ccy
		PUSH xWidth
		POP [EDI].CONTROLDATA.ccx
		
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE or SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf
		
		Invoke AdjustSelection,EDI,hFirstStatic
	.EndIf

	RET
MultiMakeSameSize EndP

MultiIncLeft Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	INC [EDI].CONTROLDATA.x
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf

	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
	.EndIf
	RET
MultiIncLeft EndP

MultiDecLeft Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	DEC [EDI].CONTROLDATA.x
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf
	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
	.EndIf
	RET
MultiDecLeft EndP

MultiIncTop Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	INC [EDI].CONTROLDATA.y
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf

	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
	.EndIf
	RET
MultiIncTop EndP

MultiDecTop Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	DEC [EDI].CONTROLDATA.y
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,0,0,SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf

	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
	.EndIf
	RET
MultiDecTop EndP

MultiIncWidth Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	INC [EDI].CONTROLDATA.ccx
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE + SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf

	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
	.Else
		Invoke AdjustSelection,EDI,hFirstStatic
	.EndIf
	RET
MultiIncWidth EndP

MultiDecWidth Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	.If [EDI].CONTROLDATA.ccx;>24
		DEC [EDI].CONTROLDATA.ccx
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE + SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf

		.If !hFirstStatic
			Invoke ChangePosPropertiesAndReselect,EDI
		.Else
			Invoke AdjustSelection,EDI,hFirstStatic
		.EndIf
	.EndIf
	RET
MultiDecWidth EndP

MultiIncHeight Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	INC [EDI].CONTROLDATA.ccy
	Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE + SWP_NOZORDER or SWP_NOOWNERZORDER
	Invoke PrepareAndConvertToDialogUnits,EDI
	.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
		Invoke ReCreateControl,EDI
	.EndIf

	.If !hFirstStatic
		Invoke ChangePosPropertiesAndReselect,EDI
	.Else
		Invoke AdjustSelection,EDI,hFirstStatic
	.EndIf
	RET
MultiIncHeight EndP

MultiDecHeight Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD

	MOV EDI,lpWindowData
	.If [EDI].CONTROLDATA.ccy;>24
		DEC [EDI].CONTROLDATA.ccy
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,0,0,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOMOVE + SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke PrepareAndConvertToDialogUnits,EDI
		.If [EDI].CONTROLDATA.ntype==21 || [EDI].CONTROLDATA.ntype==22	;image, shape
			Invoke ReCreateControl,EDI
		.EndIf
		
		.If !hFirstStatic
			Invoke ChangePosPropertiesAndReselect,EDI
		.Else
			Invoke AdjustSelection,EDI,hFirstStatic
		.EndIf
	.EndIf
	RET
MultiDecHeight EndP

EraseSelectionAndMoveWindow Proc Uses EDI EBX ESI lpWindowData:DWORD, hFirstStatic:DWORD
	MOV EDI,lpWindowData
	Invoke DrawRectangle,hADialog,ADDR [EDI].CONTROLDATA.ControlRect

	MOV EBX,[EDI].CONTROLDATA.ControlRect.right
	SUB EBX,[EDI].CONTROLDATA.ControlRect.left
	MOV [EDI].CONTROLDATA.ccx,EBX

	MOV ESI,[EDI].CONTROLDATA.ControlRect.bottom
	SUB ESI,[EDI].CONTROLDATA.ControlRect.top
	
	.If [EDI].CONTROLDATA.ntype==7	;ComboBox
		MOV EDX,[EDI].CONTROLDATA.Style
		AND EDX,CBS_DROPDOWNLIST
		.If EDX==CBS_DROPDOWNLIST
			;I don't want the height to be recalculated
		.Else
			MOV EDX,[EDI].CONTROLDATA.Style
			AND EDX,CBS_DROPDOWN
			.If EDX==CBS_DROPDOWN
				;I don't want the height to be recalculated
			.Else
				;I DO want the height to be recalculated
				MOV [EDI].CONTROLDATA.ccy,ESI
			.EndIf
		.EndIf
	.Else
		MOV [EDI].CONTROLDATA.ccy,ESI
	.EndIf
	
	M2M [EDI].CONTROLDATA.x,[EDI].CONTROLDATA.ControlRect.left
	M2M [EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ControlRect.top
	
	Invoke PrepareAndConvertToDialogUnits,EDI
	
	;image/shape
	.If [EDI].CONTROLDATA.ntype==21 ||[EDI].CONTROLDATA.ntype==22;[EDI].CONTROLDATA.ntype==13 || [EDI].CONTROLDATA.ntype==2 || [EDI].CONTROLDATA.ntype==7 || [EDI].CONTROLDATA.ntype==11 || [EDI].CONTROLDATA.ntype==22	|| [EDI].CONTROLDATA.ntype==21	|| [EDI].CONTROLDATA.ntype==9 || [EDI].CONTROLDATA.ntype==10
		Invoke SetWindowPos,[EDI].CONTROLDATA.hWnd,0,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,SWP_NOZORDER or SWP_NOOWNERZORDER
		Invoke ReCreateControl,EDI
	.Else
		.If [EDI].CONTROLDATA.ntype==12
			;Needed for the toolbar so thar it resizes/repositions itself
			DEC ESI
		.EndIf
		Invoke MoveWindow,[EDI].CONTROLDATA.hWnd,[EDI].CONTROLDATA.ControlRect.left,[EDI].CONTROLDATA.ControlRect.top,EBX,ESI,TRUE
	.EndIf
	
	.If !hFirstStatic
		Invoke ChangePosProperties,EDI
		;Let's move the Selection statics for the active control only!
		Invoke DeSelectWindow,hSelection
		MOV hSelection,EAX
		Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
	.EndIf
	
	;Invoke UpdateWindow,hADialog
	RET
EraseSelectionAndMoveWindow EndP

DrawEraseSelection Proc Uses EDI lpWindowData:DWORD, hFirstStatic:DWORD
	MOV EDI,lpWindowData
	;Invoke DrawControlRectangle,hADialog,ADDR [EDI].CONTROLDATA.ControlRect
	Invoke DrawRectangle,hADialog,ADDR [EDI].CONTROLDATA.ControlRect
	RET
DrawEraseSelection EndP

EnumSelectedWindows Proc Uses EBX ESI EDI lpProcedure:DWORD;, lParam:DWORD
	;Let's see if there is a selection in the Tree
	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
	MOV EDI,EAX
	.If EDI	;Yes there is.
		Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_PARENT,EDI
		.If EAX	;Active is a Control NOT a Dialog
			Invoke GetTreeItemParameter,hDialogsTree,EDI
			PUSH FALSE
			PUSH EAX
			CALL lpProcedure
			
			.If hSelection
				MOV EBX,hSelection
				XOR EDI,EDI
				@@:
				MOV ESI,8
				.While ESI
					Invoke GetWindowLong,EBX,GWL_USERDATA
					.If ESI==1	;Last Static
						.If EAX
							MOV EDI,EAX
						.Else
							XOR EDI,EDI
						.EndIf									
					.EndIf
					MOV EBX,EAX
					DEC ESI
				.EndW
				
				.If EDI
					MOV EBX,EDI
					Invoke GetParent,EDI
					Invoke GetWindowLong,EAX,GWL_USERDATA
					PUSH EDI	;hStatic
					PUSH EAX
					CALL lpProcedure
					JMP @B
				.EndIf
			.EndIf
		.EndIf
	.EndIf
	RET
EnumSelectedWindows EndP

;Returns 0 if this is not one of the 8 static controls that note the Active selected control
;or 1,2,3,4,5,6,7 or 8
IsActiveSelectionStatic Proc Uses ESI EBX hStatic:HWND
	MOV EBX,hSelection
	.If EBX!=hStatic
		.If hSelection
			@@:
			MOV ESI,8
			.While ESI
				Invoke GetWindowLong,EBX,GWL_USERDATA
				MOV EBX,EAX
				.If EBX==hStatic
					MOV EAX,ESI
					JMP Found
				.EndIf
				DEC ESI
			.EndW
		.EndIf
		XOR EAX,EAX
	.Else
		MOV EAX,1;TRUE
	.EndIf
	Found:
	RET
IsActiveSelectionStatic EndP

HandleRCContextMenu Proc PointX:DWORD, PointY:DWORD, hWnd:HWND
Local Point:POINT

	Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
	.If EAX	;Yes there is-it should be!!!!!
		M2M Point.x,PointX
		M2M Point.y,PointY
		
		Invoke ClientToScreen,hWnd,ADDR Point
		
		AND Point.y,0FFFFh
		AND Point.x,0FFFFh
		Invoke TrackPopupMenu,WinAsmHandles.PopUpMenus.hDialogMenu,TPM_LEFTALIGN OR TPM_RIGHTBUTTON,Point.x,Point.y,0,WinAsmHandles.hMain,0
	.EndIf

	RET
HandleRCContextMenu EndP

CreateTestDialogControls Proc Uses EDI ESI lpDialogData:DWORD, lpControlData:DWORD
Local Buffer[256]	:BYTE

	MOV EDI,lpControlData
	
	.If [EDI].CONTROLDATA.ntype==1		;Static
		LEA ESI,szStaticClass
	.ElseIf [EDI].CONTROLDATA.ntype==2	;Edit
		LEA ESI,szEditClass
	.ElseIf [EDI].CONTROLDATA.ntype==3	;GroupBox
		LEA ESI,szButtonClass
	.ElseIf [EDI].CONTROLDATA.ntype==4	;BS_PUSHBUTTON & BS_DEFPUSHBUTTON
		LEA ESI,szButtonClass
	.ElseIf [EDI].CONTROLDATA.ntype==5	;BS_AUTOCHECKBOX
		LEA ESI,szButtonClass
	.ElseIf [EDI].CONTROLDATA.ntype==6	;BS_RADIOBUTTON
		LEA ESI,szButtonClass
	.ElseIf [EDI].CONTROLDATA.ntype==7	;ComboBox
		LEA ESI,szComboBoxClass
	.ElseIf [EDI].CONTROLDATA.ntype==8	;ListBox
		LEA ESI,szListBoxClass
	.ElseIf [EDI].CONTROLDATA.ntype==9	;Horizontal Scrollbar
		LEA ESI,szScrollBarClass
	.ElseIf [EDI].CONTROLDATA.ntype==10	;Vertical Scrollbar
		LEA ESI,szScrollBarClass
	.ElseIf [EDI].CONTROLDATA.ntype==11	;TabControl
		LEA ESI,szTabControlClass
	.ElseIf [EDI].CONTROLDATA.ntype==12	;ToolBar
		LEA ESI,szToolBarClass
	.ElseIf [EDI].CONTROLDATA.ntype==13	;StatusBar
		LEA ESI,szStatusBarClass
	.ElseIf [EDI].CONTROLDATA.ntype==14	;ProgressBar
		LEA ESI,szProgressBarClass
	.ElseIf [EDI].CONTROLDATA.ntype==15	;Rebar
		LEA ESI,szReBarClass
	.ElseIf [EDI].CONTROLDATA.ntype==16	;UpDown
		LEA ESI,szUpDownClass
	.ElseIf [EDI].CONTROLDATA.ntype==17	;TreeView
		LEA ESI,szTreeViewClass
	.ElseIf [EDI].CONTROLDATA.ntype==18	;ListView
		LEA ESI,szListViewClass
	.ElseIf [EDI].CONTROLDATA.ntype==19	;TrackBar
		LEA ESI,szTrackBarClass
	.ElseIf [EDI].CONTROLDATA.ntype==20	;RichEdit
		LEA ESI,szRichEditClass
	.ElseIf [EDI].CONTROLDATA.ntype==21	|| [EDI].CONTROLDATA.ntype==22	;Image OR Shape
		LEA ESI,szStaticClass
	.ElseIf [EDI].CONTROLDATA.ntype==23 || [EDI].CONTROLDATA.ntype==24	;User Defined or managed custom control		
		Invoke IsThereSuchAClass,ADDR [EDI].CONTROLDATA.Class
		.If !EAX
			LEA ESI,szStaticClass
		.Else
			LEA ESI,[EDI].CONTROLDATA.Class
		.EndIf

	.EndIf
	
	;Look!!!!!!!! (handle \t, \n, \\, "")
	Invoke TranformText,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
	MOV ECX,[EDI].CONTROLDATA.Style
	OR ECX,WS_CHILD
	MOV EDX,[EDI].CONTROLDATA.NotStyle
	AND EDX,WS_VISIBLE
	.If EDX!=WS_VISIBLE
		OR ECX,WS_VISIBLE
	.EndIf
	
	Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,ESI,ADDR Buffer,ECX,[EDI].CONTROLDATA.x,[EDI].CONTROLDATA.y,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,hFind,NULL,hInstance,NULL
	MOV ESI,EAX
	
	Invoke SendMessage,ESI,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
	
	.If [EDI].CONTROLDATA.ntype==21
		.If [EDI].CONTROLDATA.hImg
			Invoke GetObjectType,[EDI].CONTROLDATA.hImg
			.If EAX==OBJ_BITMAP
				MOV ECX,IMAGE_BITMAP
			.Else
				MOV ECX,IMAGE_ICON
			.EndIf
			Invoke SendMessage,ESI,STM_SETIMAGE,ECX,[EDI].CONTROLDATA.hImg
		.EndIf
	.EndIf
	RET
	
CreateTestDialogControls EndP

DeleteTestDialogControls Proc hControl:DWORD, lParam:LPARAM
	;This story for SysIPAddress32 !!!!!
	Invoke GetStockObject,SYSTEM_FONT
	Invoke SendMessage,hControl,WM_SETFONT,EAX,0
	MOV EAX,TRUE
	RET
DeleteTestDialogControls EndP

TestDialogProc Proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	.If uMsg==WM_CREATE
		M2M hTempFind,hFind
		MOV EAX,hWnd
		MOV hFind,EAX	;necessary so that TABSTOPS work in the Test dialog
		
		PUSH EDI
		MOV EAX,lParam
		MOV EDI,[EAX].CREATESTRUCT.lpCreateParams
		
		MOV EAX,[EDI].CONTROLDATA.Style
		
		AND EAX,DS_CENTER
		.If EAX==DS_CENTER
			Invoke CenterWindow,hWnd
		.EndIf
		
		Invoke SendMessage,hWnd,WM_SETFONT,[EDI].CONTROLDATA.hFont,TRUE
		
		Invoke EnumDialogChildren,EDI,Offset CreateTestDialogControls
		POP EDI
		
	.ElseIf uMsg==WM_CLOSE
		Invoke EnumChildWindows,hWnd,Offset DeleteTestDialogControls,0
		
	.ElseIf uMsg==WM_DESTROY
		M2M hFind,hTempFind
		
		Invoke EnableWindow,WinAsmHandles.hMain,TRUE
		Invoke EnableAllDockWindows,TRUE
		Invoke EnableWindow,hFind,TRUE
		Invoke SetFocus,WinAsmHandles.hMain
	.EndIf
	
	Invoke DefWindowProc,hWnd,uMsg,wParam,lParam
	RET
TestDialogProc EndP

SelectControlIfInRectangle Proc Uses ESI lpDialogData:DWORD, lpControlData:DWORD
Local Rect:RECT

	MOV ECX,SelRect.right
	.If SDWORD PTR ECX < 0
		XOR ECX,ECX
	.EndIf
	.If ECX<SelRect.left
		MOV EAX,SelRect.left
		MOV SelRect.left,ECX
		MOV SelRect.right,EAX
	.EndIf
	
	
	MOV ECX,SelRect.bottom
	.If SDWORD PTR ECX < 0
		XOR ECX,ECX
	.EndIf
	.If ECX < SelRect.top
		MOV EAX,SelRect.top
		MOV SelRect.top,ECX
		MOV SelRect.bottom,EAX
	.EndIf
	
	
	MOV ESI,lpControlData
	Invoke GetWindowRect,[ESI].CONTROLDATA.hWnd,ADDR Rect
	Invoke MapWindowPoints,NULL,hADialog,ADDR Rect,2
	
	MOV EAX,Rect.right
	.If SDWORD PTR EAX < 0 || EAX < SelRect.left
		JMP Ex
	.EndIf

	MOV EAX,Rect.bottom
	.If SDWORD PTR EAX < 0 || EAX<SelRect.top
		JMP Ex
	.EndIf

	MOV EAX,Rect.left
	.If SDWORD PTR EAX < 0
		XOR EAX,EAX
	.EndIf
	.If EAX>SelRect.right
		JMP Ex
	.EndIf
	
	MOV EAX,Rect.top
	.If SDWORD PTR EAX < 0
		XOR EAX,EAX
	.EndIf
	.If EAX>SelRect.bottom
		JMP Ex
	.EndIf
	
	.If hSelection
		Invoke ConvertSelection,hSelection
	.EndIf
	
	Invoke SelectWindow,[ESI].CONTROLDATA.hWnd,TRUE
	Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET, [ESI].CONTROLDATA.hTreeItem
	Invoke SetProperties,ESI

	Ex:
	RET
SelectControlIfInRectangle EndP

SelectControlsInRectangle Proc
	Invoke DeMultiSelect
	Invoke GetWindowLong,hADialog,GWL_USERDATA
	Invoke EnumDialogChildren,EAX, Offset SelectControlIfInRectangle
	.If !hSelection ;i.e. no controls selected
		Invoke SelectWindow,hADialog,TRUE
	.EndIf

	RET
SelectControlsInRectangle EndP

AddControl Proc Uses EDI EBX ESI hWndParent:HWND, dwLeft:DWORD, DwTop:DWORD, dwWidth:DWORD, dwHeight:DWORD
Local Buffer[256]	:BYTE

	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CONTROLDATA
	MOV EDI,EAX
	Invoke GetWindowLong,hWndParent,GWL_USERDATA
	MOV ESI,EAX
	M2M [EDI].CONTROLDATA.hFont,[ESI].CONTROLDATA.hFont
	
	MOV EDX,dwLeft
	MOV ECX,DwTop
	MOV [EDI].CONTROLDATA.dux,EDX
	MOV [EDI].CONTROLDATA.x,EDX
	MOV [EDI].CONTROLDATA.duy,ECX
	MOV [EDI].CONTROLDATA.y,ECX
	
	MOV EDX,dwWidth
	MOV ECX,dwHeight
	MOV [EDI].CONTROLDATA.duccx,EDX
	MOV [EDI].CONTROLDATA.ccx,EDX
	MOV [EDI].CONTROLDATA.duccy,ECX
	MOV [EDI].CONTROLDATA.ccy,ECX
	
	;EBX=Caption
	;ESI=IDName
	INC HighestWindowDialogID
	M2M [EDI].CONTROLDATA.ID,HighestWindowDialogID
	MOV EAX,ToolSelected
	LEA EBX,szNULL	
	.If EAX==IDM_TOOLBOX_STATIC
		LEA EBX,szIDC_STATIC
		LEA ESI,szIDC_STATIC
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR SS_LEFT
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,1
	.ElseIf EAX==IDM_TOOLBOX_EDIT
		LEA EBX,szIDC_EDIT
		LEA ESI,szIDC_EDIT
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR ES_LEFT OR WS_TABSTOP OR ES_AUTOHSCROLL
		MOV [EDI].CONTROLDATA.ExStyle,WS_EX_CLIENTEDGE
		MOV [EDI].CONTROLDATA.ntype,2
	.ElseIf EAX==IDM_TOOLBOX_GROUPBOX
		LEA EBX,szIDC_GROUPBOX
		LEA ESI,szIDC_GROUPBOX
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR BS_GROUPBOX
		MOV [EDI].CONTROLDATA.ntype,3
	.ElseIf EAX==IDM_TOOLBOX_BUTTON
		LEA EBX,szIDC_BUTTON
		LEA ESI,szIDC_BUTTON
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR BS_PUSHBUTTON OR WS_TABSTOP
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,4
	.ElseIf EAX==IDM_TOOLBOX_CHECKBOX
		LEA EBX,szIDC_CHECKBOX
		LEA ESI,szIDC_CHECKBOX
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR BS_AUTOCHECKBOX OR WS_TABSTOP
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,5
	.ElseIf EAX==IDM_TOOLBOX_RADIOBUTTON
		LEA EBX,szIDC_RADIOBUTTON
		LEA ESI,szIDC_RADIOBUTTON
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR BS_AUTORADIOBUTTON OR WS_TABSTOP
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,6					
	.ElseIf EAX==IDM_TOOLBOX_COMBOBOX
		LEA EBX,szIDC_COMBOBOX
		LEA ESI,szIDC_COMBOBOX
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR CBS_DROPDOWNLIST OR WS_TABSTOP
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,7					
	.ElseIf EAX==IDM_TOOLBOX_LISTBOX
		;LEA EBX,szIDC_LISTBOX
		LEA ESI,szIDC_LISTBOX
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR LBS_HASSTRINGS OR LBS_NOINTEGRALHEIGHT OR WS_TABSTOP; OR LBS_NOTIFY
		MOV [EDI].CONTROLDATA.ExStyle,WS_EX_CLIENTEDGE
		MOV [EDI].CONTROLDATA.ntype,8					
	.ElseIf EAX==IDM_TOOLBOX_HSCROLL
		;LEA EBX,szIDC_HSCROLL
		LEA ESI,szIDC_HSCROLL
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR SBS_HORZ
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,9					
	.ElseIf EAX==IDM_TOOLBOX_VSCROLL
		;LEA EBX,szIDC_VSCROLL
		LEA ESI,szIDC_VSCROLL
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR SBS_VERT
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,10					
	.ElseIf EAX==IDM_TOOLBOX_TABCONTROL
		;LEA EBX,szIDC_TABCONTROL
		LEA ESI,szIDC_TABCONTROL
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR TCS_FOCUSNEVER OR WS_TABSTOP
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,11					
	.ElseIf EAX==IDM_TOOLBOX_TOOLBAR
		;LEA EBX,szIDC_TOOLBAR
		LEA ESI,szIDC_TOOLBAR
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,12					
	.ElseIf EAX==IDM_TOOLBOX_STATUSBAR
		;LEA EBX,szIDC_STATUSBAR
		LEA ESI,szIDC_STATUSBAR
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT or CCS_BOTTOM
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,13					
	.ElseIf EAX==IDM_TOOLBOX_PROGRESSBAR
		;LEA EBX,szIDC_PROGRESSBAR
		LEA ESI,szIDC_PROGRESSBAR
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,14					
	.ElseIf EAX==IDM_TOOLBOX_REBAR
		;LEA EBX,szIDC_REBAR
		LEA ESI,szIDC_REBAR
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR CCS_TOP;CCS_NORESIZE;
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,15					
	.ElseIf EAX==IDM_TOOLBOX_UPDOWN
		;LEA EBX,szIDC_UPDOWN
		LEA ESI,szIDC_UPDOWN
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT; OR WS_TABSTOP
		
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,16					
	.ElseIf EAX==IDM_TOOLBOX_TREEVIEW
		;LEA EBX,szIDC_TREEVIEW
		LEA ESI,szIDC_TREEVIEW
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR TVS_HASLINES OR TVS_LINESATROOT OR TVS_HASBUTTONS OR WS_TABSTOP
		MOV [EDI].CONTROLDATA.ExStyle,WS_EX_CLIENTEDGE
		MOV [EDI].CONTROLDATA.ntype,17					
	.ElseIf EAX==IDM_TOOLBOX_LISTVIEW
		;LEA EBX,szIDC_LISTVIEW
		LEA ESI,szIDC_LISTVIEW
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR LVS_LIST OR WS_TABSTOP
		MOV [EDI].CONTROLDATA.ExStyle,WS_EX_CLIENTEDGE
		MOV [EDI].CONTROLDATA.ntype,18					
	.ElseIf EAX==IDM_TOOLBOX_SLIDER
		;LEA EBX,szIDC_SLIDER
		LEA ESI,szIDC_SLIDER
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR WS_TABSTOP
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,19
	.ElseIf EAX==IDM_TOOLBOX_RICHEDIT
		LEA EBX,szIDC_RICHEDIT
		LEA ESI,szIDC_RICHEDIT
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR WS_TABSTOP; OR ES_LEFT
		MOV [EDI].CONTROLDATA.ExStyle,WS_EX_CLIENTEDGE
		MOV [EDI].CONTROLDATA.ntype,20
	.ElseIf EAX==IDM_TOOLBOX_SHAPE
		;LEA EBX,szIDC_SHAPE
		LEA ESI,szIDC_SHAPE
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR SS_WHITERECT OR SS_BLACKFRAME
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,22					
	.ElseIf EAX==IDM_TOOLBOX_IMAGE
		;LEA EBX,szNULL
		LEA ESI,szIDC_IMAGE
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR SS_ICON OR 200h;Why ?50000203H;SS_BITMAP OR SS_CENTERIMAGE
		;MOV [EDI].CONTROLDATA.ExStyle,NULL
		MOV [EDI].CONTROLDATA.ntype,21					
	.ElseIf EAX==IDM_TOOLBOX_USERDEFINEDCONTROL
		LEA EBX,szIDC_USERDEFINED
		LEA ESI,szIDC_USERDEFINED
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT
		MOV [EDI].CONTROLDATA.ExStyle,WS_EX_CLIENTEDGE
		MOV [EDI].CONTROLDATA.ntype,23
	.Else	;managed custom control
		MOV EBX,IDM_TOOLBOX_USERDEFINEDCONTROL
		SUB EAX,EBX
		DEC EAX
		MOV EBX,SizeOf CUSTOMCONTROLEX
		MUL EBX
		MOV EBX,lpCustomControls
		ADD EBX,EAX
		
		LEA ESI,Buffer
		
		Invoke lstrcpy,ESI,CTEXT("IDC_")
		Invoke lstrcat,ESI,ADDR [EBX].CUSTOMCONTROL.szFriendlyName
		
		MOV EDX,ESI
		.Repeat	;Remove spaces and tabs and capitalize
			MOV AL,BYTE PTR [EDX]
			.If  AL>='a' && AL<='z'
				AND BYTE PTR [EDX],5Fh
			.ElseIf AL==" " || AL=="	"
				MOV BYTE PTR [EDX],"_"
			.EndIf
			INC EDX
		.Until AL==0
		
		MOV [EDI].CONTROLDATA.Style,WS_ALLCHILDSDEFAULT OR WS_TABSTOP;WS_ALLCHILDSDEFAULT OR 
		MOV [EDI].CONTROLDATA.ExStyle,WS_EX_CLIENTEDGE
		MOV [EDI].CONTROLDATA.ntype,24
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Class,ADDR [EBX].CUSTOMCONTROL.szClassName
		
		LEA EBX,Buffer
	.EndIf
	;EBX=Caption
	;ESI=IDName
	
	Invoke lstrcpy,ADDR [EDI].CONTROLDATA.IDName,ESI
	;.If [EDI].CONTROLDATA.ntype!=24	;mighrt have problems with managed controls e.g. IPAddress
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,EBX	;<--For managed controls this has no effect
	;.EndIf
	
	Invoke BinToDec,HighestWindowDialogID,ADDR Buffer
	.If [EDI].CONTROLDATA.ntype!=21 && BYTE PTR [EBX]!=0 ;i.e. NOT image and NOT NULL caption
		;.If [EDI].CONTROLDATA.ntype!=24	;mighrt have problems with managed controls e.g. IPAddress
			Invoke lstrcat,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer
		;.EndIf
	.EndIf
	
	Invoke lstrcat,ADDR [EDI].CONTROLDATA.IDName,ADDR Buffer
	
	;Invoke AddDefine,lpDefinesMem,ADDR [EDI].CONTROLDATA.IDName,ADDR Buffer
	Invoke AddOrReplaceDefine,ADDR [EDI].CONTROLDATA.IDName,ADDR Buffer
	
	Invoke ConvertToDialogUnits,EDI
	Invoke CreateControl,EDI,hWndParent
	Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET, [EDI].CONTROLDATA.hTreeItem
	Invoke DeMultiSelect
	Invoke SelectWindow,[EDI].CONTROLDATA.hWnd,TRUE
	
	Invoke SetRCModified,TRUE
	;****************************************
	;Invoke AddUndo,UNDOTYPECREATECONTROL,EDI
	;****************************************
	
	Invoke SendMessage,hToolBoxToolBar,TB_CHECKBUTTON,IDM_TOOLBOX_POINTER,TRUE
	MOV ToolSelected,IDM_TOOLBOX_POINTER


	RET
AddControl EndP

ShowProjectTab Proc

	Invoke ShowWindow,WinAsmHandles.hProjTree,SW_SHOW
	Invoke ShowWindow,WinAsmHandles.hBlocksList,SW_HIDE
	
	Invoke ShowWindow,hRCPropertiesToolBar,SW_HIDE
	Invoke ShowWindow,hResourcesTab,SW_HIDE
	
	Invoke ShowWindow,hDialogsTree,SW_HIDE
	Invoke ShowWindow,hPropertiesList,SW_HIDE
	Invoke ShowWindow,hOthersTree,SW_HIDE


	RET
ShowProjectTab EndP

FindIDName Proc Uses EBX EDI hChild:DWORD, lpIDName:DWORD
Local ftxt		:FINDTEXTEX
	
	Invoke GetWindowLong,hChild,0
	MOV EBX,EAX
	.If [EBX].CHILDWINDOWDATA.dwTypeOfFile==1 || [EBX].CHILDWINDOWDATA.dwTypeOfFile==2	;i.e. asm or inc
		MOV EAX,lpIDName
		MOV ftxt.lpstrText,EAX
		MOV ftxt.chrg.cpMin,0
		
		SearchAgain:
		MOV ftxt.chrg.cpMax,-1
		
		Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],EM_FINDTEXTEX,FR_MATCHCASE or FR_WHOLEWORD or FR_DOWN,ADDR ftxt
		.If EAX!=-1
			Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXLINEFROMCHAR,0,ftxt.chrgText.cpMin
			;EAX is line number
			Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_LINEINDEX,EAX,0
			
			;------------------------------------
			;In case we search for next occurence
			MOV EDX,ftxt.chrgText.cpMax
			MOV ftxt.chrg.cpMin,EDX
			;------------------------------------
			
			;EAX is char pos of first char of the line
			MOV EDX,ftxt.chrgText.cpMin
			MOV ftxt.chrgText.cpMax,EDX
			MOV ftxt.chrgText.cpMin,EAX
			
			MOV EDI,Offset tmpBuffer
			Invoke GetTextRange,[EBX].CHILDWINDOWDATA.hEditor,EDI,16384,ADDR ftxt.chrgText
			
			
			@@:
			.If EAX
				DEC EAX
				.If BYTE PTR [EDI+EAX]==" " || BYTE PTR [EDI+EAX]=="	"
					JMP @B
				.ElseIf BYTE PTR [EDI+EAX] == "="
					MOV EAX,ftxt.chrgText.cpMin
					MOV ftxt.chrgText.cpMax,EAX
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,EM_EXSETSEL,0,ADDR ftxt.chrgText
					Invoke SendMessage,[EBX].CHILDWINDOWDATA.hEditor,CHM_VCENTER,0,0
					Invoke SetWindowPos,hChild, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
					Invoke SetFocus,[EBX].CHILDWINDOWDATA.hEditor
					
					Invoke SendMessage,WinAsmHandles.hProjTab,TCM_SETCURSEL,0,0
					Invoke ShowProjectTab
					XOR EAX,EAX	;Stop enumeration
					RET
				.EndIf				
			.EndIf
			
			JMP SearchAgain
			
		.EndIf
	.EndIf
	MOV EAX,TRUE	;i.e. continue enumeration
	RET
FindIDName EndP

RCDlgProc Proc Uses EBX ESI EDI hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
Local ps			:PAINTSTRUCT
Local Rect			:RECT
Local tvi			:TVITEM
Local hDC			:HDC
Local Point			:POINT
Local hCtl			:HWND
Local OffX			:DWORD
Local OffY			:DWORD
Local msg			:MSG
Local Buffer[12]	:BYTE

	.If uMsg==WM_PAINT
		Invoke BeginPaint,hWnd,ADDR ps
		Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SHOWHIDEGRID,0
		AND EAX,TBSTATE_CHECKED	
		.If EAX
			XOR ESI,ESI	;Y
			.While ESI<=ps.rcPaint.bottom
				XOR EDI,EDI	;X
				.While EDI<=ps.rcPaint.right
					Invoke SetPixelV,ps.hdc,EDI,ESI,0
					ADD EDI,GridSize					
				.EndW
				ADD ESI,GridSize
			.EndW	
		.EndIf 
		Invoke EndPaint,hWnd,ADDR ps
		
		
	.ElseIf uMsg == WM_CTLCOLORSTATIC
		Invoke IsActiveSelectionStatic,lParam
		.If EAX
			Invoke GetFocus
			.If EAX==hRCEditorWindow
				Invoke GetSysColorBrush,COLOR_HIGHLIGHT
			.Else
				Invoke GetStockObject,LTGRAY_BRUSH
			.EndIf
		.Else
			Invoke DefWindowProc,hWnd,uMsg,wParam,lParam

		.EndIf
		
	.ElseIf uMsg==WM_CLOSE
		Invoke GetWindowLong,hADialog,GWL_STYLE
		AND EAX,-1 XOR WS_POPUP
		OR EAX,( WS_CHILD OR WS_DISABLED); OR WS_VISIBLE
		Invoke SetWindowLong,hADialog,GWL_STYLE,EAX
		
		Invoke SetParent,hADialog,hRCEditorWindow
		Invoke EnableWindow,WinAsmHandles.hMain,TRUE
		Invoke EnableAllDockWindows,TRUE
		Invoke SendMessage,hRCEditorWindow,WM_VSCROLL,0,0
		Invoke SendMessage,hRCEditorWindow,WM_HSCROLL,0,0
		
		Invoke SetFocus,hRCEditorWindow	;<---Important
		XOR EAX,EAX
		RET
		
	.ElseIf uMsg==WM_CREATE
		Invoke EnableControlsOnToolBox,TRUE
		
	.ElseIf uMsg==WM_LBUTTONDOWN || uMsg==WM_RBUTTONDOWN
		.If uMsg==WM_LBUTTONDOWN
			;Just to let me draw on top of existing controls
			Invoke SetClipChildren,FALSE
		.Else;If uMsg==WM_RBUTTONDOWN
			Invoke GetCapture
			.If EAX==hWnd	;means something is in progress->WM_RBUTTONUP will take care!
				RET
			.EndIf
		.EndIf
		
		LOWORD lParam
		.If EAX>7FFFh
			OR EAX,0FFFF0000h
		.EndIf
		MOV EBX,EAX
		
		HIWORD lParam
		.If EAX>7FFFh
			OR EAX,0FFFF0000h
		.EndIf
		MOV ESI,EAX
		
		.If ToolSelected!=IDM_TOOLBOX_POINTER ;User is creating a New Control
			.If uMsg==WM_LBUTTONDOWN
				Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
				AND EAX,TBSTATE_CHECKED	
				.If EAX
					Invoke GetKeyState,VK_MENU
					AND EAX,80h
					.If !EAX
						Invoke GetClosestPointOnGrid	;X=EBX,Y=ESI
					.EndIf
				.EndIf
				MOV ControlRect.left,EBX
				MOV ControlRect.right,EBX
				MOV ControlRect.top,ESI
				MOV ControlRect.bottom,ESI
				Invoke DrawRectangle,hWnd,ADDR ControlRect
			.EndIf
		.Else	;User is selecting an existing Control or Dialog 
			Invoke ChildWindowFromPoint,hWnd,EBX,ESI
			.If EAX && EAX!=hWnd	;User is selecting an existing Control (EAX==0 if we press on the caption)
				MOV hCtl,EAX
				Invoke IsActiveSelectionStatic,hCtl
				.If !EAX
					;Store
					Invoke GetWindowLong,hCtl,GWL_USERDATA
					MOV EDI,EAX
					Invoke GetWindowRect,hCtl,ADDR [EDI].CONTROLDATA.ControlRect
					Invoke MapWindowPoints,NULL,hWnd,ADDR [EDI].CONTROLDATA.ControlRect,2
					SUB EBX,[EDI].CONTROLDATA.ControlRect.left
					MOV OffsetX,EBX
					SUB ESI,[EDI].CONTROLDATA.ControlRect.top
					MOV OffsetY,ESI
					
					.If wParam!=(MK_CONTROL or MK_LBUTTON) && wParam!=(MK_CONTROL or MK_RBUTTON)
						Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
						.If EAX	;Yes there is.
							Invoke GetTreeItemParameter,hDialogsTree,EAX
							MOV EDI,EAX
							MOV EAX,[EDI].CONTROLDATA.hWnd
							.If EAX==hCtl
								JMP DoNotDeMultiSelect
							.EndIf
						.EndIf
						Invoke DeMultiSelect
						Invoke SelectWindow,hCtl,TRUE
						
						DoNotDeMultiSelect:
						;Do Nothing Here
					.Else
						;Let's see if there is a selection in the Tree
						Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
						MOV EBX,EAX
						.If EBX	;Yes there is.
							Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_PARENT,EBX
							.If !EAX	;Active is not a control-It is a dialog
								Invoke DeMultiSelect
								Invoke SelectWindow,hCtl,TRUE
							.Else
								Invoke GetTreeItemParameter,hDialogsTree,EBX
								MOV EDI,EAX
								MOV EAX,[EDI].CONTROLDATA.hWnd
								.If EAX!=hCtl
									;Let's see if hCtl is already in the chain
									.If hSelection
										MOV EBX,hSelection
										MOV EDI,EBX
										@@:
										MOV ESI,8
										.While ESI
											Invoke GetParent,EBX
											.If EAX==hCtl	;Yes It is in the chain as non-active selection
												Invoke DeSelectWindow,EBX
												Invoke SetWindowLong,EDI,GWL_USERDATA,EAX
												;Convert the active to non active selection
												Invoke ConvertSelection,hSelection
												Invoke SelectWindow,hCtl,TRUE
												JMP Done
											.EndIf
											Invoke GetWindowLong,EBX,GWL_USERDATA
											.If ESI==1	;Keep Last Static
												MOV EDI,EBX											
											.EndIf
											MOV EBX,EAX
											DEC ESI
										.EndW
										.If EAX
											MOV EBX,EAX
											JMP @B
										.EndIf
									.EndIf
									;Control is not in the chain
									Invoke ConvertSelection,hSelection
									Invoke SelectWindow,hCtl,TRUE
									Done:
								.EndIf
							.EndIf
						.EndIf
					.EndIf
					Invoke GetWindowLong,hCtl,GWL_USERDATA
					MOV EDI,EAX
					Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET, [EDI].CONTROLDATA.hTreeItem
					Invoke SetProperties,EDI
					
				.Else	;User Pressed one of the 8 Active Selection Statics 
					.If uMsg==WM_LBUTTONDOWN
						MOV fSizing,EAX
						.If EAX==1
							MOV ECX,IDC_SIZEWE
						.ElseIf EAX==2
							MOV ECX,IDC_SIZENWSE
						.ElseIf EAX==3
							MOV ECX,IDC_SIZENS
						.ElseIf EAX==4
							MOV ECX,IDC_SIZENESW
						.ElseIf EAX==5
							MOV ECX,IDC_SIZEWE
						.ElseIf EAX==6
							MOV ECX,IDC_SIZENWSE
						.ElseIf EAX==7
							MOV ECX,IDC_SIZENS
						.ElseIf EAX==8
							MOV ECX,IDC_SIZENESW
						.EndIf
						Invoke LoadCursor,NULL,ECX
						Invoke SetCursor,EAX
						
						Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
						.If EAX	;Yes there is.
							Invoke GetTreeItemParameter,hDialogsTree,EAX
							MOV EDI,EAX
							Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR [EDI].CONTROLDATA.ControlRect
							Invoke MapWindowPoints,NULL,hWnd,ADDR [EDI].CONTROLDATA.ControlRect,2
							
							Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
						.EndIf
					.EndIf
				.EndIf
			.Else	;User is selecting the Current Dialog
				Invoke DeMultiSelect
				Invoke SelectWindow,hWnd,TRUE
				Invoke GetWindowLong,hWnd,GWL_USERDATA
				MOV EDI,EAX
				Invoke SendMessage, hDialogsTree, TVM_SELECTITEM, TVGN_CARET, [EDI].CONTROLDATA.hTreeItem
				Invoke SetProperties,EDI
				
				MOV SelRect.left,EBX
				MOV SelRect.top,ESI
				MOV SelRect.right,EBX
				MOV SelRect.bottom,ESI
				
			.EndIf
		.EndIf
		
		MOV fMoving,FALSE
		
		.If uMsg==WM_LBUTTONDOWN
			Invoke SetCapture,hWnd
			;Very Important!!! Clear all pending WM_MOUSEMOVE messages
			Invoke ClearPendingMessages,hWnd,WM_MOUSEMOVE,WM_MOUSEMOVE
		.EndIf
		RET
		
	.ElseIf uMsg==WM_MOUSEMOVE
		LOWORD lParam
		.If EAX>7FFFh
			OR EAX,0FFFF0000h
		.EndIf
		MOV EBX,EAX
		
		HIWORD lParam
		.If EAX>7FFFh
			OR EAX,0FFFF0000h
		.EndIf
		MOV ESI,EAX
		
		Invoke GetCapture
		.If EAX==hWnd
			.If ToolSelected!=IDM_TOOLBOX_POINTER	;i.e If a control button is pressed
				Invoke DrawRectangle,hWnd,ADDR ControlRect
				Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
				Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
				AND EAX,TBSTATE_CHECKED	
				.If EAX
					Invoke GetKeyState,VK_MENU
					AND EAX,80h
					.If !EAX
						Invoke GetClosestPointOnGrid;,EBX,ESI
					.EndIf	
				.EndIf
				INC EBX
				INC ESI
				MOV ControlRect.right,EBX
				MOV ControlRect.bottom,ESI
				Invoke DrawRectangle,hWnd,ADDR ControlRect
			.Else
				.If !fSizing
					;Let's see if there is a selection in the Tree
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
					MOV EDI,EAX
					.If EDI	;Yes there is.
						Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_PARENT,EDI
						.If EAX	;Active is a Control NOT a Dialog
							Invoke GetTreeItemParameter,hDialogsTree,EDI
							MOV EDI,EAX
							SUB EBX,OffsetX
							MOV OffX,EBX
							SUB ESI,OffsetY
							MOV OffY,ESI
							
							;Erase Previous Rectangle
							.If fMoving
								Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect;ADDR ControlRect
							.EndIf
							
							Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR [EDI].CONTROLDATA.ControlRect
							Invoke MapWindowPoints,NULL,hWnd,ADDR [EDI].CONTROLDATA.ControlRect,2
							
							Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
							AND EAX,TBSTATE_CHECKED	
							.If EAX
								Invoke GetKeyState,VK_MENU
								AND EAX,80h
								.If !EAX
									Invoke GetClosestPointOnGrid;,EBX,ESI
								.EndIf	
							.EndIf
							;INC EBX
							;INC ESI
							SUB EBX,[EDI].CONTROLDATA.ControlRect.left
							SUB ESI,[EDI].CONTROLDATA.ControlRect.top
							
							MOV OffX,EBX
							MOV OffY,ESI
							Invoke OffsetRect,ADDR [EDI].CONTROLDATA.ControlRect,EBX,ESI
							
							Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
							.If hSelection
								MOV EBX,hSelection
								XOR EDI,EDI
								@@:
								MOV ESI,8
								.While ESI
									Invoke GetWindowLong,EBX,GWL_USERDATA
									.If ESI==1	;Last Static
										.If EAX
											MOV EDI,EAX
										.Else
											XOR EDI,EDI
										.EndIf									
									.EndIf
									MOV EBX,EAX
									DEC ESI
								.EndW
								
								.If EDI
									MOV EBX,EDI
									Invoke GetParent,EDI
									MOV hCtl,EAX
									Invoke GetWindowLong,EAX,GWL_USERDATA
									MOV EDI,EAX
									;Erase Previous Rectangle
									.If fMoving
										Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect;ADDR ControlRect
									.EndIf								
									;Draw New One
									Invoke GetWindowRect,[EDI].CONTROLDATA.hWnd,ADDR [EDI].CONTROLDATA.ControlRect
									Invoke MapWindowPoints,NULL,hWnd,ADDR [EDI].CONTROLDATA.ControlRect,2
									Invoke OffsetRect,ADDR [EDI].CONTROLDATA.ControlRect,OffX,OffY
									Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
									JMP @B
								.EndIf
							.EndIf
							MOV fMoving,TRUE
						.Else
							.If bSelecting
								Invoke DrawFocusRectangle,hWnd,ADDR SelRect
							.EndIf
							MOV SelRect.right,EBX
							MOV SelRect.bottom,ESI
							Invoke DrawFocusRectangle,hWnd,ADDR SelRect
							MOV bSelecting,TRUE
						.EndIf
					.EndIf
				.Else	;User is Sizing
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
					.If EAX	;Yes there is.
						Invoke GetTreeItemParameter,hDialogsTree,EAX
						MOV EDI,EAX
						;Invoke DrawControlRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
						Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
						Invoke SendMessage,hRCOptionsToolBar,TB_GETSTATE,IDM_DIALOG_SNAPTOGRID,0
						AND EAX,TBSTATE_CHECKED	
						.If EAX
							Invoke GetKeyState,VK_MENU
							AND EAX,80h
							.If !EAX
								Invoke GetClosestPointOnGrid;,EBX,ESI
								INC EBX
								INC ESI
							.EndIf
						.EndIf
						.If fSizing==1
							MOV [EDI].CONTROLDATA.ControlRect.left,EBX
							MOV ECX,IDC_SIZEWE
						.ElseIf fSizing==2
							MOV [EDI].CONTROLDATA.ControlRect.left,EBX
							MOV [EDI].CONTROLDATA.ControlRect.top,ESI
							MOV ECX,IDC_SIZENWSE
						.ElseIf fSizing==3
							MOV [EDI].CONTROLDATA.ControlRect.top,ESI
							MOV ECX,IDC_SIZENS
						.ElseIf fSizing==4
							MOV [EDI].CONTROLDATA.ControlRect.right,EBX
							MOV [EDI].CONTROLDATA.ControlRect.top,ESI
							MOV ECX,IDC_SIZENESW
						.ElseIf fSizing==5
							MOV [EDI].CONTROLDATA.ControlRect.right,EBX
							MOV ECX,IDC_SIZEWE
						.ElseIf fSizing==6
							MOV [EDI].CONTROLDATA.ControlRect.right,EBX
							MOV [EDI].CONTROLDATA.ControlRect.bottom,ESI
							MOV ECX,IDC_SIZENWSE
						.ElseIf fSizing==7
							MOV [EDI].CONTROLDATA.ControlRect.bottom,ESI
							MOV ECX,IDC_SIZENS
						.ElseIf fSizing==8
							MOV [EDI].CONTROLDATA.ControlRect.left,EBX
							MOV [EDI].CONTROLDATA.ControlRect.bottom,ESI
							MOV ECX,IDC_SIZENESW
						.EndIf
						Invoke LoadCursor,NULL,ECX
						Invoke SetCursor,EAX
						Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
					.EndIf
				.EndIf
			.EndIf
		.Else	;Mouse is not captured
			Invoke ChildWindowFromPoint,hWnd,EBX,ESI
			.If EAX && EAX!=hWnd && ToolSelected==IDM_TOOLBOX_POINTER	;i.e If a control button is pressed && User is selecting an existing Control (EAX==0 if we press on the caption)
				Invoke IsActiveSelectionStatic,EAX
				.If EAX
					.If EAX==1
						MOV ECX,IDC_SIZEWE
					.ElseIf EAX==2
						MOV ECX,IDC_SIZENWSE
					.ElseIf EAX==3
						MOV ECX,IDC_SIZENS
					.ElseIf EAX==4
						MOV ECX,IDC_SIZENESW
					.ElseIf EAX==5
						MOV ECX,IDC_SIZEWE
					.ElseIf EAX==6
						MOV ECX,IDC_SIZENWSE
					.ElseIf EAX==7
						MOV ECX,IDC_SIZENS
					.ElseIf EAX==8
						MOV ECX,IDC_SIZENESW
					.EndIf
					Invoke LoadCursor,NULL,ECX
					Invoke SetCursor,EAX
				.EndIf
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_LBUTTONUP
		Invoke GetCapture
		.If EAX==hWnd
			Invoke ReleaseCapture
			.If ToolSelected >= IDM_TOOLBOX_STATIC;!=IDM_TOOLBOX_POINTER	;i.e If a control button is pressed
				Invoke DrawRectangle,hWnd,ADDR ControlRect
				
				.If ControlRect.bottom>7FFFh
					OR ControlRect.bottom,0FFFF0000h
				.EndIf
				MOV ECX,ControlRect.bottom
				SUB ECX,ControlRect.top
				.If ECX>7fffffffh
					NEG ECX
					PUSH ControlRect.top
					M2M ControlRect.top,ControlRect.bottom
					POP ControlRect.bottom
				.EndIf
				.If ControlRect.right>7FFFh
					OR ControlRect.right,0FFFF0000h
				.EndIf
				MOV EDX,ControlRect.right
				SUB EDX,ControlRect.left
				.If EDX>7fffffffh
					NEG EDX
					PUSH ControlRect.left
					M2M ControlRect.left,ControlRect.right
					POP ControlRect.right
				.EndIf
				Invoke AddControl,hWnd,ControlRect.left,ControlRect.top,EDX,ECX
			.Else
				;Let's see if there is a selection in the Tree	(There must be!)
				Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
				MOV EDI,EAX
				.If EDI	;Yes there is.
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_PARENT,EDI
					.If EAX	;Active is a Control NOT a Dialog
						.If fSizing
							Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
							.If EAX	;Yes there is.
								Invoke GetTreeItemParameter,hDialogsTree,EAX
								MOV EDI,EAX
								Invoke EraseSelectionAndMoveWindow,EDI,0
								;----------------------------------
								;Thanks Marwin
								;Invoke InvalidateRect,hWnd,NULL,TRUE
								;-----------------------------------
								Invoke SetRCModified,TRUE
							.EndIf
						.ElseIf fMoving
							Invoke EnumSelectedWindows,Offset EraseSelectionAndMoveWindow
							;Invoke InvalidateRect,hWnd,NULL,TRUE
							Invoke SetRCModified,TRUE
						.EndIf
					.Else
						.If bSelecting
							Invoke DrawFocusRectangle,hWnd,ADDR SelRect
							MOV bSelecting,FALSE
							Invoke SelectControlsInRectangle;,ADDR Rect
						.EndIf
					.EndIf
				.EndIf	
			.EndIf
			MOV fSizing,FALSE
		.EndIf
		;Do not draw over controls---->no flicker when RCDlg receives WM_PAINT
		Invoke SetClipChildren,TRUE
		
		
		;---------------------------------
		Invoke GetWindowLong,hRCEditorWindow,0
		.If [EAX].CHILDWINDOWDATA.dwTypeOfFile==3	;i.e. we don't mind for rc files not belonging to the current project
			;Let's check for double click, since WM_LBUTTONDBLCLK is not sent to our dialog
			Invoke GetTickCount
			MOV EBX,EAX
			SUB EBX,TickCount
			MOV TickCount,EAX
			Invoke GetDoubleClickTime
			.If EBX<=EAX
				;PrintText "Double Click!"
				;Let's see if there is a selection in the Tree	(There must be!)
				Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
				MOV EDI,EAX
				.If EDI	;Yes there is.
					Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_PARENT,EDI
					.If EAX	;Active is a Control NOT a Dialog
						Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
						.If EAX	;Yes
							Invoke GetTreeItemParameter,hDialogsTree,EAX
							LEA ESI,[EAX].CONTROLDATA.IDName
							.If BYTE PTR [ESI]==0
								LEA ESI,Buffer
								MOV ECX,[EAX].CONTROLDATA.ID
								Invoke BinToDec,ECX,ESI
							.EndIf
							Invoke EnumProjectItemsExtended,Offset FindIDName,ESI
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.EndIf
		;---------------------------------
	.ElseIf uMsg==WM_RBUTTONUP
		;In case user pressed LButton and is trying to create a new or move an existing control
		Invoke GetCapture
		.If EAX==hWnd
			;PrintHex 1
			Invoke ReleaseCapture
			.If fSizing
				Invoke SendMessage,hDialogsTree,TVM_GETNEXTITEM,TVGN_CARET,0
				.If EAX	;Yes there is.
					Invoke GetTreeItemParameter,hDialogsTree,EAX
					MOV EDI,EAX
					;Invoke DrawControlRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
					Invoke DrawRectangle,hWnd,ADDR [EDI].CONTROLDATA.ControlRect
				.EndIf
				;Invoke InvalidateRect,hWnd,NULL,TRUE
			.ElseIf fMoving
				Invoke EnumSelectedWindows,Offset DrawEraseSelection;,0
			.ElseIf bSelecting
				;Invoke DrawRectangle,hWnd,ADDR SelRect
				Invoke DrawFocusRectangle,hWnd,ADDR SelRect
			.Else
				Invoke DrawRectangle,hWnd,ADDR ControlRect
				Invoke SendMessage,hToolBoxToolBar,TB_CHECKBUTTON,IDM_TOOLBOX_POINTER,TRUE
				MOV ToolSelected,IDM_TOOLBOX_POINTER
			.EndIf
			MOV fSizing,FALSE
			MOV fMoving,FALSE
			MOV bSelecting,FALSE
			;Invoke InvalidateRect,hWnd,NULL,TRUE
		.Else
			LOWORD lParam
			MOV ECX,EAX
			HIWORD lParam
			Invoke HandleRCContextMenu,ECX,EAX,hWnd
		.EndIf
	.Else
		Invoke DefWindowProc,hWnd,uMsg,wParam,lParam
	.EndIf
	RET
RCDlgProc EndP

SkipToEndOfComment Proc

	.While BYTE PTR [ESI] && WORD PTR [ESI]!='/*'
		INC ESI
	.EndW
	RET

SkipToEndOfComment EndP

SkipToEol Proc

	.While BYTE PTR [ESI]!=VK_RETURN && BYTE PTR [ESI]
		INC ESI
	.EndW
	RET

SkipToEol EndP

SkipSpace Proc

  @@:
	.While BYTE PTR [ESI]==VK_SPACE || BYTE PTR [ESI]==VK_TAB
		INC ESI
	.EndW
	.If WORD PTR [ESI]=='*/'
		Invoke SkipToEndOfComment
		JMP @B
	.EndIf
	.If BYTE PTR [ESI]==';' || WORD PTR [ESI]=='//'
		Invoke SkipToEol
	.EndIf
	RET

SkipSpace EndP

SkipCRLF Proc

  @@:
	.While BYTE PTR [ESI]==VK_SPACE || BYTE PTR [ESI]==VK_TAB || BYTE PTR [ESI]==0Dh || BYTE PTR [ESI]==0Ah
		INC	ESI
	.EndW
	.If BYTE PTR [ESI]==';' || (BYTE PTR [ESI]=='/' && BYTE PTR [ESI+1]=='/')
		Invoke SkipToEol
		JMP @B
	.EndIf
	RET

SkipCRLF EndP

HexToBin Proc lpStr:DWORD

	PUSH ESI
	XOR EAX,EAX
	XOR EDX,EDX
	MOV ESI,lpStr
  @@:
	SHL EAX,4
	ADD EAX,EDX
	MOVZX EDX,BYTE PTR [ESI]
	.If EDX>='0' && EDX<='9'
		SUB EDX,'0'
		INC ESI
		JMP @B
	.ElseIf  EDX>='A' && EDX<='F'
		SUB EDX,'A'-10
		INC ESI
		JMP @B
	.ElseIf  EDX>='a' && EDX<='f'
		SUB EDX,'a'-10
		INC ESI
		JMP @B
	.EndIf
	POP ESI
	RET

HexToBin EndP

DecToBin Proc lpStr:DWORD
Local fNeg:DWORD

    PUSH EBX
    PUSH ESI
    MOV ESI,lpStr
    MOV fNeg,FALSE
    MOV AL,[ESI]
    .If AL=='-'
		INC ESI
		MOV fNeg,TRUE
    .EndIf
    XOR EAX,EAX
  @@:
    CMP BYTE PTR [ESI],30h
    JB @f
    CMP BYTE PTR [ESI],3Ah
    JNB @f
    MOV EBX,EAX
    SHL EAX,2
    ADD EAX,EBX
    SHL EAX,1
    XOR EBX,EBX
    MOV BL,[ESI]
    SUB BL,30h
    ADD EAX,EBX
    INC ESI
    JMP @B
  @@:
	.If fNeg
		NEG EAX
	.EndIf
    POP ESI
    POP EBX
    RET

DecToBin EndP

FindName Proc Uses ESI,lpProMem:DWORD,lpName:DWORD

	.If lpProMem
		MOV ESI,lpProMem
		.While [ESI].DEFINE.szName || [ESI].DEFINE.dwValue
			;.If [ESI].DEFINE.ReferenceCount;![ESI].DEFINE.fDeleted
				Invoke lstrcmp,ADDR [ESI].DEFINE.szName,lpName
				.If !EAX
					MOV EAX,ESI
					JMP Ex
				.EndIf
			;.EndIf
			ADD ESI,SizeOf DEFINE
		.EndW
		XOR EAX,EAX
	.EndIf
  Ex:
	RET

FindName EndP

ConvNum Proc lpProMem:DWORD, lpBuff:DWORD

	MOV EAX,lpBuff
	.If WORD PTR [EAX]=='x0'
		ADD EAX,2
		Invoke HexToBin,EAX
	.ElseIf (BYTE PTR [EAX]>='0' && BYTE PTR [EAX]<='9') || BYTE PTR [EAX]=='-'
		Invoke DecToBin,EAX
	.Else
		Invoke FindName,lpProMem,EAX
	.EndIf
	RET

ConvNum EndP

GetWord Proc Uses ESI EDI,lpWord:DWORD,lpLine:DWORD
	MOV ESI,lpLine
	MOV EDI,lpWord
	Invoke SkipCRLF
	.If BYTE PTR [ESI]=='"'
		MOV AL,[ESI]
		MOV [EDI],AL
		INC ESI
		INC EDI
		XOR EAX,EAX
		.While BYTE PTR [ESI]; && AL!='"'; && BYTE PTR [ESI]!='"')
			.If AL!='"'
				MOV AL,[ESI]
				MOV [EDI],AL
				INC ESI
				INC EDI
			.Else
				.If BYTE PTR [ESI]
					.If BYTE PTR [ESI]!='"'
						.Break
					.Else
						MOV BYTE PTR [EDI],'"'
						INC ESI
						INC EDI
						XOR EAX,EAX
					.EndIf
				.EndIf
			.EndIf
		.EndW
	.Else
		.While BYTE PTR [ESI] && BYTE PTR [ESI]!=VK_SPACE && BYTE PTR [ESI]!=VK_TAB && BYTE PTR [ESI]!=0Dh && BYTE PTR [ESI]!=0Ah && BYTE PTR [ESI]!=',' && BYTE PTR [ESI]!='|'
			MOV AL,[ESI]
			MOV [EDI],AL
			INC ESI
			INC EDI
		.EndW
	.EndIf
	MOV BYTE PTR [EDI],0
	Invoke SkipSpace
	MOV DL,[ESI]
	.If DL==',' || DL=='|'
		INC ESI
		Invoke SkipCRLF
	.EndIf
	MOV EAX,ESI
	SUB EAX,lpLine
	RET

GetWord EndP

GetNum Proc lpProMem:DWORD

	Invoke GetWord,Offset ThisWord,ESI
	ADD	ESI,EAX
	Invoke ConvNum,lpProMem,Offset ThisWord
	RET

GetNum EndP

UnQuoteWord Proc Uses ESI EDI,lpWord:DWORD

	MOV ESI,lpWord
	MOV EDI,ESI
	.If BYTE PTR [ESI]=='"'
		INC ESI
	.EndIf
	.While BYTE PTR [ESI]
		MOV AL,[ESI]
		INC ESI
		.If AL!='"'
			MOV [EDI],AL
			INC EDI
		.Else
			.If BYTE PTR [ESI] && BYTE PTR [ESI]=='"'
				MOV BYTE PTR [EDI],'"'
				INC EDI
				MOV BYTE PTR [EDI],'"'
				INC ESI
				INC EDI
			.EndIf
		.EndIf
	.EndW
	MOV DWORD PTR [EDI],0
	RET

UnQuoteWord EndP

GetName Proc lpProMem:DWORD, lpBuff:DWORD, lpName:DWORD, lpID:DWORD

	MOV EAX,lpBuff
	MOV AL,[EAX]
	.If (AL>='0' && AL<='9') || AL=='-'
		;ID
		Invoke DecToBin,lpBuff
		MOV EDX,lpID
		MOV [EDX],EAX
		MOV EDX,lpName
		MOV BYTE PTR [EDX],0
	.Else
		;Name
		Invoke lstrcpyn,lpName,lpBuff,65;32
		;ID
		Invoke FindName,lpProMem,lpBuff
		.If EAX
			;MOV [EAX].DEFINE.fDeleted,FALSE
			INC [EAX].DEFINE.ReferenceCount
			MOV EAX,[EAX].DEFINE.dwValue
			MOV EDX,lpID
			MOV [EDX],EAX
		.EndIf
	.EndIf
	RET

GetName EndP

GetLoadOptions Proc Uses EBX ESI,lpRCMem:DWORD

	MOV		ESI,lpRCMem
	XOR		EBX,EBX
  @@:
	ADD		ESI,EBX
	Invoke GetWord,Offset ThisWord,ESI
	MOV		EBX,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szPRELOAD
	OR		EAX,EAX
	JE		@B
	Invoke lstrcmpi,Offset ThisWord,Offset szLOADONCALL
	OR		EAX,EAX
	JE		@B
	Invoke lstrcmpi,Offset ThisWord,Offset szFIXED
	OR		EAX,EAX
	JE		@B
	Invoke lstrcmpi,Offset ThisWord,Offset szMOVEABLE
	OR		EAX,EAX
	JE		@B
	Invoke lstrcmpi,Offset ThisWord,Offset szDISCARDABLE
	OR		EAX,EAX
	JE		@B
	Invoke lstrcmpi,Offset ThisWord,Offset szPURE
	OR		EAX,EAX
	JE		@B
	Invoke lstrcmpi,Offset ThisWord,Offset szIMPURE
	OR		EAX,EAX
	JE		@B
	MOV		EAX,ESI
	SUB		EAX,lpRCMem
	RET

GetLoadOptions EndP

FindStyle Proc Uses EBX ESI,lpWord:DWORD,lpStyles:DWORD

	MOV ESI,lpStyles
	.While BYTE PTR [ESI+4]
		MOV EBX,[ESI]
		Invoke lstrcmp,ADDR [ESI+4],lpWord
		.If !EAX
			MOV EAX,EBX
			JMP Ex
		.EndIf
		Invoke lstrlen,ADDR [ESI+4]
		LEA ESI,[ESI+EAX+4+1]
	.EndW
	XOR EAX,EAX
  Ex:
	RET

FindStyle EndP

GetStyle Proc Uses EBX ESI EDI lpRCMem:DWORD,lpStyles:DWORD

	XOR EBX,EBX
	XOR EDI,EDI
	MOV ESI,lpRCMem
;	Invoke GetWord,Offset ThisWord,ESI
;	PUSH EAX
;	Invoke lstrcmpi,Offset ThisWord,Offset szNOT
;	POP ECX
;	.If !EAX
;		ADD ESI,ECX
;		Invoke GetWord,Offset ThisWord,ESI
;		ADD ESI,EAX
;
;;		PrintString ThisWord
;		.If WORD PTR ThisWord=='x0'
;			Invoke HexToBin,Offset ThisWord+2
;		.Else
;			Invoke FindStyle,Offset ThisWord,lpStyles
;		.EndIf
;		MOV EDI,EAX
;		;PrintHex EDI
;	.Else
;		XOR EDI,EDI
;	.EndIf
;	.While TRUE
;		Invoke GetWord,Offset ThisWord,ESI
;		ADD ESI,EAX
;		PUSH EDX
;		.If WORD PTR ThisWord=='x0'
;			Invoke HexToBin,Offset ThisWord+2
;		.Else
;			Invoke FindStyle,Offset ThisWord,lpStyles
;		.EndIf
;		OR EBX,EAX
;		POP EDX
;		.break .If dl==',' || dl==0Dh
;	.EndW
;	MOV ECX,EDI
;	MOV EDX,EBX
;PrintHex 1 
	.While TRUE
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		PUSH EDX
		Invoke lstrcmpi,Offset ThisWord,Offset szNOT
		.If !EAX
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
			PUSH EDX	;In case NOT style is the last -->endless loop (Thanks jnrz7) 
			.If WORD PTR ThisWord=='x0'
				Invoke HexToBin,Offset ThisWord+2
			.Else
				Invoke FindStyle,Offset ThisWord,lpStyles
			.EndIf
			OR EDI,EAX
			
			POP EDX
			.If DL==',' || DL==0Dh || DL==0	;is DL==0 needed here
				POP EDX	;Just to balance the stack
				.Break
			.EndIf
		.Else
			.If WORD PTR ThisWord=='x0'
				Invoke HexToBin,Offset ThisWord+2
			.Else
				Invoke FindStyle,Offset ThisWord,lpStyles
			.EndIf
			OR EBX,EAX
		.EndIf
		POP EDX
		.Break .If DL==',' || DL==0Dh || DL==0
	.EndW


	MOV ECX,EDI
	MOV EDX,EBX
	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

GetStyle EndP

CreateDialog Proc Uses EBX EDI lpDialogData:DWORD, hPar:HWND
Local tvinsert		:TV_INSERTSTRUCT
Local Buffer[256]	:BYTE
;Local hDialogMenu:DWORD
;Local ncm:NONCLIENTMETRICS

	;MOV hDialogMenu,NULL
	MOV EBX,hPar
	MOV EDI,lpDialogData
	
	MOV EAX,[EDI].CONTROLDATA.ID
	.If EAX<=7FFFFFFFh && EAX>HighestWindowDialogID
		MOV HighestWindowDialogID,EAX
	.EndIf	
	;Look!!!!!!!! (handle \t, \n, \\, "")
	Invoke TranformText,ADDR [EDI].CONTROLDATA.Caption,ADDR Buffer

;	.If [EDI].CONTROLDATA.MenuID
;		MOV ncm.cbSize,SizeOf NONCLIENTMETRICS
;		Invoke SystemParametersInfo,SPI_GETNONCLIENTMETRICS,NULL,ADDR ncm ,NULL
;		MOV EAX,ncm.iMenuHeight
;		PrintDec EAX
;	.EndIf

	MOV EAX,[EDI].CONTROLDATA.Style
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

	AND	EAX,-1 XOR (WS_POPUP OR WS_MINIMIZE OR WS_MAXIMIZE OR WS_VISIBLE OR WS_CLIPCHILDREN); OR WS_DISABLED )
	OR EAX,WS_CHILD OR WS_CLIPSIBLINGS OR WS_DISABLED ;OR WS_CLIPCHILDREN; OR WS_DLGFRAME; OR WS_VISIBLE; OR WS_GROUP 


	MOV ECX,[EDI].CONTROLDATA.ExStyle
	AND ECX,-1 XOR WS_EX_TRANSPARENT

	;Invoke CreateWindowEx,[EDI].CONTROLDATA.ExStyle,Offset szRCDlgClass,ADDR Buffer,EAX,8,8,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,EBX,NULL,hInstance,NULL
	Invoke CreateWindowEx,ECX,Offset szRCDlgClass,ADDR Buffer,EAX,8,DIALOGSYMARGIN,[EDI].CONTROLDATA.ccx,[EDI].CONTROLDATA.ccy,EBX,NULL,hInstance,NULL
	MOV EBX,EAX
	;Invoke SetMenu,EBX,hDialogMenu
	;PrintHex EAX
	;Invoke DrawMenuBar,ebx

	MOV [EDI].CONTROLDATA.hWnd,EBX
	;Invoke SetWindowLong,EBX,0,EDI
	Invoke SetWindowLong,EBX,GWL_USERDATA,EDI

	MOV hADialog,EBX
	Invoke SendMessage,hADialog,WM_NCACTIVATE,1,0
	Invoke SetWindowPos,hADialog,HWND_TOP,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE; OR SWP_FRAMECHANGED; OR SWP_NOOWNERZORDER
	Invoke SendMessage,hADialog,WM_SETFONT,[EDI].CONTROLDATA.hFont,FALSE
	LEA ECX,[EDI].CONTROLDATA.IDName
	.If BYTE PTR [ECX]==0
		Invoke BinToDec,[EDI].CONTROLDATA.ID,ADDR Buffer
		LEA ECX,Buffer
	.EndIf

	Invoke AddToDialogTree,ECX,EDI;EBX
	MOV CONTROLDATA.hTreeItem[EDI],EAX
	RET

CreateDialog EndP

ParseControl Proc Uses ESI EDI EBX lpRCMem:DWORD,lpProMem:DWORD,hPar:HWND

	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CONTROLDATA
	MOV EDI,EAX

	;--------------------------------------------------------------------------
	;Just make the controls have the same font with the parent dialog
	;so that when ConvertToPixels is called we get proper results
	;Invoke GetWindowLong,hPar,0
	Invoke GetWindowLong,hPar,GWL_USERDATA

	MOV ESI,EAX
	;Invoke lstrcpy,ADDR [EDI].CONTROLDATA.FontName,ADDR [ESI].CONTROLDATA.FontName
	;M2M [EDI].CONTROLDATA.FontSize,[ESI].CONTROLDATA.FontSize
	M2M [EDI].CONTROLDATA.hFont,[ESI].CONTROLDATA.hFont
	;--------------------------------------------------------------------------
	
	MOV ESI,lpRCMem

	;Caption
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke UnQuoteWord,Offset ThisWord
	Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,Offset ThisWord
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke GetName,lpProMem,Offset ThisWord,ADDR [EDI].CONTROLDATA.IDName,ADDR [EDI].CONTROLDATA.ID
	 
	;Class
	Invoke GetWord,Offset NameBuffer,ESI
	ADD ESI,EAX
	Invoke UnQuoteWord,Offset NameBuffer
	;Style
	Invoke GetStyle,ESI,Offset StyleDef
	ADD ESI,EAX
	MOV [EDI].CONTROLDATA.Style,EDX
	MOV [EDI].CONTROLDATA.NotStyle,ECX
	
	MOV EAX,ECX
	AND EAX,WS_VISIBLE
	.If !EAX
		OR [EDI].CONTROLDATA.Style,WS_VISIBLE
	.EndIf
	
	;Pos & Size
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.dux,EAX
	MOV [EDI].CONTROLDATA.x,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duy,EAX
	MOV [EDI].CONTROLDATA.y,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccx,EAX
	MOV [EDI].CONTROLDATA.ccx,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccy,EAX
	MOV [EDI].CONTROLDATA.ccy,EAX
	MOVZX EAX,BYTE PTR [ESI]
	.If EAX!=0Dh
		;ExStyle
		Invoke GetStyle,ESI,Offset ExStyleDef
		ADD ESI,EAX
		MOV [EDI].CONTROLDATA.ExStyle,EDX
		MOVZX EAX, BYTE PTR [ESI]
		.If EAX!=0Dh
			;HelpID
			Invoke GetNum,lpProMem
		.EndIf
	.EndIf
	
	Invoke lstrcmpi,Offset NameBuffer,Offset szEditClass
	.If !EAX
		;Edit
		MOV [EDI].CONTROLDATA.ntype,2
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szStaticClass
	.If !EAX
		;Static
		MOV EAX,[EDI].CONTROLDATA.Style
		AND EAX,SS_TYPEMASK
		.If EAX==SS_ICON || EAX==SS_BITMAP
			;Image
			MOV [EDI].CONTROLDATA.ntype,21
		.ElseIf (EAX>=SS_BLACKRECT && EAX<=SS_WHITEFRAME) || (EAX>=SS_ETCHEDHORZ && EAX<=SS_ETCHEDFRAME) || EAX==15h || EAX==16h || EAX==17h || EAX==SS_OWNERDRAW
			;Shape
			MOV [EDI].CONTROLDATA.ntype,22
		.Else
			;Static
			MOV [EDI].CONTROLDATA.ntype,1
		.EndIf
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szButtonClass
	.If !EAX
		;Button
		MOV EAX,[EDI].CONTROLDATA.Style
		AND EAX,0Fh
		MOV EDX,4
		.If EAX==BS_GROUPBOX
			MOV EDX,3
		.ElseIf EAX==BS_AUTOCHECKBOX || EAX==BS_CHECKBOX;<-----Thanks IanB
			MOV EDX,5
		.ElseIf EAX==BS_AUTORADIOBUTTON || EAX==BS_RADIOBUTTON
			MOV EDX,6
		.EndIf
		MOV [EDI].CONTROLDATA.ntype,EDX
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szComboBoxClass
	.If !EAX
		;ComboBox
		MOV [EDI].CONTROLDATA.ntype,7
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szListBoxClass
	.If !EAX
		;ListBox
		MOV [EDI].CONTROLDATA.ntype,8
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szScrollBarClass
	.If !EAX
		;ScrollBar
		;SBS_HORZ=0
		MOV EDX,[EDI].CONTROLDATA.Style
		;SBS_VERT=1
		AND EDX,SBS_VERT
		ADD EDX,9
		MOV [EDI].CONTROLDATA.ntype,EDX
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szTabControlClass
	.If !EAX
		;TabControl
		MOV [EDI].CONTROLDATA.ntype,11
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szProgressBarClass
	.If !EAX
		;ProgressBar
		MOV [EDI].CONTROLDATA.ntype,14
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szTreeViewClass
	.If !EAX
		;TreeView
		MOV [EDI].CONTROLDATA.ntype,17
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szListViewClass
	.If !EAX
		;ListView
		MOV [EDI].CONTROLDATA.ntype,18
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szTrackBarClass
	.If !EAX
		;TrackBar
		MOV [EDI].CONTROLDATA.ntype,19
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szUpDownClass
	.If !EAX
		;UpDown
		MOV [EDI].CONTROLDATA.ntype,16
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szToolBarClass
	.If !EAX
		;ToolBar
		MOV [EDI].CONTROLDATA.ntype,12
		JMP Ex
	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szStatusBarClass
	.If !EAX
		;StatusBar
		MOV [EDI].CONTROLDATA.ntype,13
		JMP Ex
	.EndIf
;	Invoke lstrcmpi,Offset NameBuffer,Offset szDateTimeClass
;	.If !EAX
;		;DateTime
;		MOV [EDI].CONTROLDATA.ntype,20
;		JMP Ex
;	.EndIf
;	Invoke lstrcmpi,Offset NameBuffer,Offset szMonthViewClass
;	.If !EAX
;		;MonthView
;		MOV [EDI].CONTROLDATA.ntype,21
;		JMP Ex
;	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szRichEditClass
	.If !EAX
		;RichEdit
		MOV [EDI].CONTROLDATA.ntype,20
		JMP Ex
	.EndIf
;	Invoke lstrcmpi,Offset NameBuffer,Offset szComboBoxExClass
;	.If !EAX
;		;ComboBoxEx
;		MOV [EDI].CONTROLDATA.ntype,24
;		JMP Ex
;	.EndIf
;	Invoke lstrcmpi,Offset NameBuffer,Offset szIPAddressClass
;	.If !EAX
;		;IPAddress
;		MOV [EDI].CONTROLDATA.ntype,26
;		JMP Ex
;	.EndIf
;	Invoke lstrcmpi,Offset NameBuffer,Offset szAnimateClass
;	.If !EAX
;		;AnimateControl
;		MOV [EDI].CONTROLDATA.ntype,27
;		JMP Ex
;	.EndIf
;	Invoke lstrcmpi,Offset NameBuffer,Offset szHotKeyClass
;	.If !EAX
;		;HotKey
;		MOV [EDI].CONTROLDATA.ntype,28
;		JMP Ex
;	.EndIf
;	Invoke lstrcmpi,Offset NameBuffer,Offset szPagerClass
;	.If !EAX
;		;PagerControl
;		MOV EDX,[EDI].CONTROLDATA.Style
;		AND EDX,PGS_HORZ
;		NEG EDX
;		ADD EDX,30
;		MOV [EDI].CONTROLDATA.ntype,EDX
;		JMP Ex
;	.EndIf
	Invoke lstrcmpi,Offset NameBuffer,Offset szReBarClass
	.If !EAX
		;ReBar
		MOV [EDI].CONTROLDATA.ntype,15
		JMP Ex
	.EndIf

	;UserControl OR Managed Control?
	Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Class,Offset NameBuffer
	Invoke GetPointerToManagedControl,ADDR [EDI].CONTROLDATA.Class
	.If EAX	;Managed!
		MOV [EDI].CONTROLDATA.ntype,24
		JMP Ex
	.EndIf

	MOV [EDI].CONTROLDATA.ntype,23
	JMP Ex
  Ex:
  	Invoke ConvertToPixels,EDI
	Invoke CreateControl,EDI,hPar
	
	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ParseControl EndP

ParseControlType Proc Uses ESI EDI nType:DWORD,nStyle:DWORD,nExStyle:DWORD,lpRCMem:DWORD,lpProMem:DWORD,hPar:HWND
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf CONTROLDATA
	MOV EDI,EAX
	;--------------------------------------------------------------------------
	;Just make the controls have the same font with the parent dialog
	;so that when ConvertToPixels is called we get proper results
	;Invoke GetWindowLong,hPar,0
	Invoke GetWindowLong,hPar,GWL_USERDATA
	MOV ESI,EAX
	M2M [EDI].CONTROLDATA.hFont,[ESI].CONTROLDATA.hFont
	;--------------------------------------------------------------------------

	MOV ESI,lpRCMem

	;Type
	MOV EAX,nType
	MOV [EDI].CONTROLDATA.ntype,EAX
	;Style
	MOV EAX,nStyle
	;OR EAX,WS_CHILD OR WS_VISIBLE
	MOV [EDI].CONTROLDATA.Style,EAX
	MOV EAX,nExStyle
	MOV [EDI].CONTROLDATA.ExStyle,EAX
	.If BYTE PTR [ESI]=='"'
		;Caption
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,Offset ThisWord
	.ElseIf nType==21	;If ICON-->No quotes for the icon resource exist
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,Offset szHash
		Invoke lstrcat,ADDR [EDI].CONTROLDATA.Caption,Offset ThisWord
	.EndIf
	;Name / ID

	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke GetName,lpProMem,Offset ThisWord,ADDR [EDI].CONTROLDATA.IDName,ADDR [EDI].CONTROLDATA.ID
	;Pos & Size
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.dux,EAX
	MOV [EDI].CONTROLDATA.x,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duy,EAX
	MOV [EDI].CONTROLDATA.y,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccx,EAX
	MOV [EDI].CONTROLDATA.ccx,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccy,EAX
	MOV [EDI].CONTROLDATA.ccy,EAX
	MOVZX EAX,BYTE PTR [ESI]
	.If EAX!=0Dh
		;Style
		Invoke GetStyle,ESI,Offset StyleDef
		ADD ESI,EAX
		;AND DWORD PTR [EDI].CONTROLDATA.Style,0FFFF0000h			
		OR [EDI].CONTROLDATA.Style,EDX
		MOV [EDI].CONTROLDATA.NotStyle,ECX
		
		MOVZX EAX,BYTE PTR [ESI]
		.If EAX!=0Dh
			;ExStyle
			Invoke GetStyle,ESI,Offset ExStyleDef
			ADD ESI,EAX
			.If !EDX
				MOV EDX,nExStyle
			.EndIf
			MOV [EDI].CONTROLDATA.ExStyle,EDX
		.EndIf
	.EndIf
	
	MOV EAX,[EDI].CONTROLDATA.Style
	AND EAX,SBS_VERT
	.If nType==9 && EAX==SBS_VERT
		MOV [EDI].CONTROLDATA.ntype,10
	.EndIf

	MOV ECX,[EDI].CONTROLDATA.NotStyle
	AND ECX,WS_VISIBLE
	.If !ECX
		OR [EDI].CONTROLDATA.Style,WS_VISIBLE
	.EndIf

  	Invoke ConvertToPixels,EDI
	Invoke CreateControl,EDI,hPar

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ParseControlType EndP

ExtractControls Proc lpProMem:DWORD, hPar:HWND

	XOR EAX,EAX
	
	Nxt:
	ADD ESI,EAX
	
	@@:
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	
	;.If ThisWord[0]==0	;just to prevent crashes
	;PrintHex eax
	.If !EAX
		;Neither szENDSHORT nor szEND has been found; Shall I display a message?
		;OR EAX,EAX
		JE Ex
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szCONTROL
	.If !EAX
		Invoke ParseControl,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szEDITTEXT
	.If !EAX
		Invoke ParseControlType,2,ES_LEFT,WS_EX_CLIENTEDGE,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szLTEXT
	.If !EAX
		Invoke ParseControlType,1,SS_LEFT,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szCTEXT
	.If !EAX
		Invoke ParseControlType,1,SS_CENTER,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szRTEXT
	.If !EAX
		Invoke ParseControlType,1,SS_RIGHT,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szGROUPBOX
	.If !EAX
		Invoke ParseControlType,3,BS_GROUPBOX,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf

	
	Invoke lstrcmpi,Offset ThisWord,Offset szPUSHBUTTON
	.If !EAX
		Invoke ParseControlType,4,BS_PUSHBUTTON,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szDEFPUSHBUTTON
	.If !EAX
		Invoke ParseControlType,4,BS_DEFPUSHBUTTON,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szAUTOCHECKBOX
	.If !EAX
		Invoke ParseControlType,5,BS_AUTOCHECKBOX,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szCHECKBOX
	.If !EAX
		Invoke ParseControlType,5,BS_CHECKBOX,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szAUTORADIOBUTTON
	.If !EAX
		Invoke ParseControlType,6,BS_AUTORADIOBUTTON,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szCOMBOBOX
	.If !EAX
		Invoke ParseControlType,7,CBS_SIMPLE,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szLISTBOX
	.If !EAX
		Invoke ParseControlType,8,LBS_NOTIFY,WS_EX_CLIENTEDGE,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szSCROLLBAR
	.If !EAX
		Invoke ParseControlType,9,SBS_HORZ,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szICON
	.If !EAX
		Invoke ParseControlType,21,SS_ICON,0,ESI,lpProMem,hPar
		JMP Nxt
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szENDSHORT
	OR EAX,EAX
	JE Ex
	
	Invoke lstrcmpi,Offset ThisWord,Offset szEND
	OR EAX,EAX
	JNE @B
	

	Ex:
	;--
	RET

ExtractControls EndP

CreateDialogFont Proc Uses ESI lpMem:DWORD
Local lf		:LOGFONT
Local hDC		:HDC

	MOV ESI,lpMem
	LEA EAX,[ESI].DIALOGDATA.FontName
	.If BYTE PTR[EAX]!=0	;i.e FontName is Specified
		Invoke GetDC,NULL
		MOV hDC,EAX
		
		Invoke RtlZeroMemory,ADDR lf,SizeOf lf
		Invoke GetDeviceCaps,hDC,LOGPIXELSY
		Invoke MulDiv,[ESI].DIALOGDATA.FontSize,EAX,72
		NEG EAX
		MOV lf.lfHeight,EAX
		
		;MOV EAX,[ESI].CONTROLDATA.FontWeight
		;PrintHex EAX
		MOV	lf.lfWeight,400;EAX
		
		MOV EAX,[ESI].DIALOGDATA.FontItalic
		MOV lf.lfItalic,AL
		
		MOV EAX,[ESI].DIALOGDATA.Charset		
		MOV lf.lfCharSet,AL
		
		Invoke lstrcpy,ADDR lf.lfFaceName,ADDR [ESI].DIALOGDATA.FontName
		Invoke CreateFontIndirect,ADDR lf
		
		MOV [ESI].CONTROLDATA.hFont,EAX
		
		Invoke ReleaseDC,NULL,hDC
	.EndIf

	RET
CreateDialogFont EndP

ExtractDialogEx Proc Uses EBX ESI EDI lpRCMem:DWORD,lpProMem:DWORD
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf DIALOGDATA
	MOV EDI,EAX
	MOV [EDI].CONTROLDATA.ntype,0

	Invoke GetName,lpProMem,Offset NameBuffer,ADDR [EDI].CONTROLDATA.IDName,ADDR [EDI].CONTROLDATA.ID

	INC EAX
	;MOV [EDI].DLGHEAD.ctlid,EAX

	MOV ESI,lpRCMem
	Invoke GetLoadOptions,ESI
	ADD ESI,EAX
	
	Invoke GetNum,lpProMem
	;EAX==Left
	MOV [EDI].CONTROLDATA.dux,EAX
	MOV [EDI].CONTROLDATA.x,EAX

	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duy,EAX
	MOV [EDI].CONTROLDATA.y,EAX
	
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccx,EAX
	MOV [EDI].CONTROLDATA.ccx,EAX

	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccy,EAX
	MOV [EDI].CONTROLDATA.ccy,EAX

	MOVZX EAX,BYTE PTR [ESI]
	.If EAX!=0Dh
		;HelpID
		Invoke GetNum,lpProMem
	.EndIf

  @@:
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szCHARACTERISTICS
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szVERSION
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szLANGUAGE
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		JMP @B
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szCAPTION
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,Offset ThisWord
		JMP @B
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szFONT
	.If !EAX
		Invoke GetNum,lpProMem
		MOV [EDI].DIALOGDATA.FontSize,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].DIALOGDATA.FontName,Offset ThisWord
		
		XOR EBX,EBX
		.While BYTE PTR [ESI] && BYTE PTR [ESI]!=0Dh
			;PUSH ESI
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
			INC EBX
			.If EBX==1		;FontWeight
				Invoke DecToBin,Offset ThisWord
				MOV [EDI].DIALOGDATA.FontWeight,EAX	;900
			.ElseIf EBX==2	;FontItalic
				Invoke DecToBin,Offset ThisWord
				MOV [EDI].DIALOGDATA.FontItalic,EAX
			.ElseIf EBX==3	;Charset
				Invoke DecToBin,Offset ThisWord
				MOV [EDI].DIALOGDATA.Charset,EAX
			.EndIf
		.EndW
		
		JMP @B
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szMENU
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.MenuID,Offset ThisWord
		JMP @B
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szCLASS
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Class,Offset ThisWord
		JMP @B
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szSTYLE
	.If !EAX
		Invoke GetStyle,ESI,Offset StyleDef
		ADD ESI,EAX
		;OR EDX,WS_VISIBLE
		MOV [EDI].CONTROLDATA.Style,EDX
		JMP @B
	.EndIf
	
	Invoke lstrcmpi,Offset ThisWord,Offset szEXSTYLE
	.If !EAX
		Invoke GetStyle,ESI,Offset ExStyleDef
		ADD ESI,EAX
		MOV [EDI].CONTROLDATA.ExStyle,EDX
		JMP @B
	.EndIf
	
	Invoke CreateDialogFont,EDI
	Invoke ConvertToPixels,EDI
	Invoke CreateDialog,EDI,hRCEditorWindow
	Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szBEGINSHORT
	.EndIf
	.If !EAX
		Invoke ExtractControls,lpProMem,hADialog
	.EndIf

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ExtractDialogEx EndP

ExtractDialog Proc Uses EBX ESI EDI,lpRCMem:DWORD,lpProMem:DWORD

	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf DIALOGDATA
	MOV EDI,EAX
	;Name / ID
	Invoke GetName,lpProMem,Offset NameBuffer,ADDR [EDI].CONTROLDATA.IDName,ADDR [EDI].CONTROLDATA.ID
	;inc EAX
	;MOV [EDI].CONTROLDATA.ctlid,EAX
	MOV ESI,lpRCMem
	Invoke GetLoadOptions,ESI
	ADD ESI,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.dux,EAX
	MOV [EDI].CONTROLDATA.x,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duy,EAX
	MOV [EDI].CONTROLDATA.y,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccx,EAX
	MOV [EDI].CONTROLDATA.ccx,EAX
	Invoke GetNum,lpProMem
	MOV [EDI].CONTROLDATA.duccy,EAX
	MOV [EDI].CONTROLDATA.ccy,EAX
  @@:
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szCHARACTERISTICS
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szVERSION
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szLANGUAGE
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szCAPTION
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Caption,Offset ThisWord
		JMP @B
	.EndIf

	Invoke lstrcmpi,Offset ThisWord,Offset szFONT
	.If !EAX
		Invoke GetNum,lpProMem
		MOV [EDI].DIALOGDATA.FontSize,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].DIALOGDATA.FontName,Offset ThisWord
		
		.While BYTE PTR [ESI] && BYTE PTR [ESI]!=0Dh
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
		.EndW
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szMENU
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.MenuID,Offset ThisWord
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szCLASS
	.If !EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].CONTROLDATA.Class,Offset ThisWord
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szSTYLE
	.If !EAX
		Invoke GetStyle,ESI,Offset StyleDef
		ADD ESI,EAX
		;OR EDX,WS_VISIBLE
		MOV [EDI].CONTROLDATA.Style,EDX
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szEXSTYLE
	.If !EAX
		Invoke GetStyle,ESI,Offset ExStyleDef
		ADD ESI,EAX
		MOV [EDI].CONTROLDATA.ExStyle,EDX
		JMP @B
	.EndIf
	;Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
	;.If EAX
		;PUSH EAX
		Invoke CreateDialogFont,EDI
		Invoke ConvertToPixels,EDI
		;POP EAX
		Invoke CreateDialog,EDI,hRCEditorWindow;EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
		.If EAX
			Invoke lstrcmpi,Offset ThisWord,Offset szBEGINSHORT
		.EndIf
		.If !EAX
			Invoke ExtractControls,lpProMem,hADialog
		.EndIf
	;.EndIf

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ExtractDialog EndP
