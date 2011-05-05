EnableAllDockWindows		PROTO :DWORD
InvalidateAllDockWindows	PROTO

.CONST
FR_CURRENTPROJECT		EQU 20000h
FR_UPDOWN				EQU 40000h


.DATA
lpFind					DWORD 0
hFindDialog				DWORD 0


.DATA?
StartChrg				CHARRANGE<?>
hStartChild				HWND ?
bDownSearched			DWORD ?
bSecondPass				DWORD ?

.CODE

SetStartingPosition Proc Uses EBX
	
	MOV bSecondPass,FALSE
	MOV hStartChild,0
	Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
	.If EAX
		MOV EBX,EAX
		Invoke GetWindowLong,EBX,0
		;.If [EAX].CHILDWINDOWDATA.dwTypeOfFile < 100
			MOV hStartChild,EBX
		;.EndIf
			Invoke SendMessage,[EAX].CHILDWINDOWDATA.hEditor,EM_EXGETSEL,0,Offset StartChrg
			MOV bDownSearched,FALSE
		;.EndIf
	.EndIf
	RET
SetStartingPosition EndP

;fShowMessage=0 No message
;fShowMessage=1 On status Bar
;fShowMessage=2 On MessageBox
Find Proc hEdit:DWORD, frType:DWORD, lpBuffer:DWORD, fShowMessage:DWORD;, bChangeSelection:DWORD
	
	;Get current selection
	Invoke SendMessage,hEdit,EM_EXGETSEL,0,Offset ft.chrg
	
	MOV EAX,frType
	AND EAX,FR_UPDOWN
	.If EAX
		MOV EAX,ft.chrg.cpMax
		.If !bDownSearched
			MOV ft.chrg.cpMin,EAX
			MOV ft.chrg.cpMax,-1
		.Else
			MOV ECX,StartChrg.cpMin
			.If EAX>StartChrg.cpMin
				MOV ft.chrg.cpMin,ECX
			.Else
				MOV ft.chrg.cpMin,EAX
			.EndIf
			MOV ft.chrg.cpMax,ECX
		.EndIf
	.Else
		MOV EAX,frType
		AND EAX,FR_DOWN
		.If EAX
			M2M ft.chrg.cpMin,ft.chrg.cpMax
			MOV ft.chrg.cpMax,-1
		.Else
			MOV ft.chrg.cpMax,0
		.EndIf
	.EndIf
	
	
	PUSH lpBuffer
	POP ft.lpstrText
	
	
	@@:
	;Do the find
	Invoke SendMessage,hEdit,EM_FINDTEXTEX,frType,Offset ft
	
	MOV ECX,frType
	AND ECX,FR_UPDOWN
	.If ECX && EAX > ft.chrg.cpMax && bDownSearched
		MOV EAX,-1
	.EndIf

	MOV fres,EAX
	.If EAX!=-1
		;Mark the found text
		Invoke SendMessage,hEdit,EM_EXSETSEL,0,Offset ft.chrgText
		Invoke SendMessage,hEdit,EM_SCROLLCARET,0,0
		Invoke SendDlgItemMessage,hFindDialog,2020,WM_SETTEXT,0, Offset szNULL
	.Else
		
		MOV EAX,frType
		MOV ECX,EAX
		AND EAX,FR_UPDOWN
		AND ECX,FR_CURRENTPROJECT
		.If EAX && !bDownSearched
			.If !ECX
				MOV bDownSearched,TRUE
				MOV ft.chrg.cpMin,0
				PUSH StartChrg.cpMin
				POP ft.chrg.cpMax
				JMP @B
			.EndIf
		.Else
			.If fShowMessage==0
				.If hFindDialog
					Invoke SendDlgItemMessage,hFindDialog,2020,WM_SETTEXT,0, Offset szNULL
				.EndIf
			.ElseIf fShowMessage==1
				Invoke SendDlgItemMessage,hFindDialog,2020,WM_SETTEXT,0, Offset szSearchFinished
				MOV EAX,TRUE
			.ElseIf fShowMessage==2
				Invoke EnableAllDockWindows,FALSE
				Invoke MessageBox,WinAsmHandles.hMain, Offset szSearchFinished, Offset szAppName,MB_OK or MB_TASKMODAL or MB_ICONINFORMATION
				Invoke EnableAllDockWindows,TRUE
				MOV EAX,TRUE 
			.EndIf
		.EndIf
		
	.EndIf

	RET
Find EndP

;fDirection=0	:	Up
;fDirection=1	:	Down
;fDirection=2	:	Down then Over
;Returns next child's handle in EAX 
GetNextChild Proc Uses EBX EDI hCurrentChild:HWND, fDirection:DWORD
	.If fDirection
		MOV EDI,TVGN_NEXT
	.Else
		MOV EDI,TVGN_PREVIOUS
	.EndIf
	
	Invoke GetWindowLong,hCurrentChild,0
	MOV EBX,EAX
	Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,EDI,CHILDWINDOWDATA.hTreeItem[EBX]
	.If !EAX
		Invoke SendMessage, WinAsmHandles.hProjTree, TVM_GETNEXTITEM, TVGN_PARENT, CHILDWINDOWDATA.hTreeItem[EBX]
		.If EAX
			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,EDI,EAX
			.If EAX
				;Now if there is a next/previous parent
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_CHILD,EAX
				.If EAX
					.If EDI==TVGN_NEXT
						;Invoke GetTreeItemParameter,WinAsmHandles.hProjTree,EAX
						;Now EAX is handle of next child
					.Else	;Direction is up, so find LAST child of this parent
						@@:
						MOV EDI,EAX
						Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_NEXT,EDI
						.If EAX
							JMP @B
						.EndIf
						MOV EAX,EDI
					.EndIf
					
					Invoke GetTreeItemParameter,WinAsmHandles.hProjTree,EAX
					;Now EAX is handle of next child
				.EndIf
			.ElseIf fDirection==2
				Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_ROOT,NULL
				.If EAX
					Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_CHILD,EAX
					.If EAX
						Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETNEXTITEM,TVGN_CHILD,EAX
						.If EAX
							Invoke GetTreeItemParameter,WinAsmHandles.hProjTree,EAX
							;Now EAX is handle of next child
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.EndIf
	.Else
		Invoke GetTreeItemParameter,WinAsmHandles.hProjTree,EAX
		;Now EAX is handle of next child
	.EndIf
	
	RET
GetNextChild EndP

FindNext Proc Uses EDI hDlg:HWND
Local Buffer[256]	:BYTE
Local fShowMessage	:DWORD
Local fDirection	:DWORD
Local chrg			:CHARRANGE
	
	MOV ECX,fr
	AND ECX,FR_CURRENTPROJECT
	.If ECX
		MOV fShowMessage,0
	.Else
		MOV fShowMessage,1
	.EndIf

	;fDirection=0	:	Up
	;fDirection=1	:	Down
	;fDirection=2	:	Down then Over
	MOV ECX,fr
	AND ECX,FR_UPDOWN
	.If ECX
		MOV fDirection,2
	.Else
		MOV ECX,fr
		AND ECX,FR_DOWN
		.If ECX
			MOV fDirection,1
		.Else	;Up
			MOV fDirection,0
		.EndIf
	.EndIf

	Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,WM_GETTEXT,256,ADDR Buffer
	.If Buffer[0]!=0
		Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_FINDSTRINGEXACT,-1,ADDR Buffer
		.If EAX==CB_ERR	;i.e not found
			;Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_ADDSTRING,0,ADDR Buffer
			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_INSERTSTRING,0,ADDR Buffer
		.EndIf
		
		Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
		
		FindAgain:
		;--------
		.If EAX && EAX!=hRCEditorWindow
			Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearching
			Invoke Find,hEditor,fr,Offset FindBuffer,fShowMessage
		.Else
		     mov fres,-1
		 .EndIf
		 
		.If fres==-1
			.If fShowMessage==0 ;i.e. Current Project is selected
				Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
				.If EAX
					@@:
					MOV EDI,EAX
					Invoke GetNextChild,EDI,fDirection
					
					.If EAX && !bSecondPass
						PUSH EAX
						Invoke SendMessage,hClient,WM_MDIRESTORE,EDI,0
						POP EDI
						Invoke SetWindowPos,EDI,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
						
						;hEditor is now different
						.If fDirection==0 ;i.e. Up
							Invoke SendMessage,hEditor,WM_GETTEXTLENGTH,0,0
						.Else
							XOR EAX,EAX
						.EndIf
						Invoke SendMessage,hEditor,EM_SETSEL,EAX,EAX
							
						Invoke SetFocus,hDlg
						
						MOV EAX,EDI 
						.If EAX==hStartChild
							MOV bSecondPass,TRUE 
						.EndIf
						JMP FindAgain
					.Else
						Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearchFinished
						Invoke SendMessage,hEditor,EM_SETSEL,StartChrg.cpMin,StartChrg.cpMax
						Invoke SendMessage,hEditor,EM_SCROLLCARET,0,0
					.EndIf
				.Else
					Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearchFinished
				.EndIf
			.Else
				.If fDirection==2 && bDownSearched
					Invoke SetStartingPosition
				.EndIf
			.EndIf
		.Else
			.If bSecondPass	;True only if we deal with the current project option
				Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
				MOV EAX,StartChrg.cpMax
				.If EAX<=chrg.cpMax
					Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearchFinished
					Invoke SendMessage,hEditor,EM_SETSEL,StartChrg.cpMin,StartChrg.cpMax
					Invoke SendMessage,hEditor,EM_SCROLLCARET,0,0
				.EndIf 
			.EndIf
		.EndIf
	.Else
		Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearchFinished
	.EndIf

	RET	
FindNext EndP

Replace Proc Uses EDI hDlg:HWND, fShowMessage:DWORD
Local Buffer[256]	:BYTE
Local tmpft			:FINDTEXTEX
Local fDirection	:DWORD
Local chrg			:CHARRANGE


	Invoke GetDlgItem,hDlg,IDC_BTN_REPLACEALL
	PUSH EAX
	Invoke IsWindowEnabled,EAX
	POP ECX
	.If !EAX
		;Enable Replace all button
		Invoke EnableWindow,ECX,TRUE
		;Set caption to Replace...
		Invoke SetWindowText,hDlg, Offset szTipReplace;szReplace
		;Show replace
		Invoke GetDlgItem,hDlg,IDC_REPLACESTATIC
		Invoke ShowWindow,EAX,SW_SHOWNA
		Invoke GetDlgItem,hDlg,IDC_REPLACETEXT
		Invoke ShowWindow,EAX,SW_SHOWNA
	.Else
		;.If fres!=-1
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		MOV ECX,fr
		AND ECX,FR_CURRENTPROJECT
		.If ECX
			MOV fShowMessage,0
		.Else
			MOV fShowMessage,1
		.EndIf
		
		;fDirection=0	:	Up
		;fDirection=1	:	Down
		;fDirection=2	:	Down then Over
		MOV ECX,fr
		AND ECX,FR_UPDOWN
		.If ECX
			MOV fDirection,2
		.Else
			MOV ECX,fr
			AND ECX,FR_DOWN
			.If ECX
				MOV fDirection,1
			.Else	;Up
				MOV fDirection,0
			.EndIf
		.EndIf
		
		Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
		
		ReplaceAgain:
		;--------
		.If EAX && EAX!=hRCEditorWindow
			Invoke SendMessage,hEditor,EM_EXGETSEL,0,addr tmpft.chrg
			
			MOV EAX,Offset FindBuffer
			MOV tmpft.lpstrText,EAX		
			Invoke SendMessage,hEditor,EM_FINDTEXTEX,fr,addr tmpft
			
			MOV EAX,tmpft.chrgText.cpMin
			MOV ECX,tmpft.chrgText.cpMax
			
			.If EAX==tmpft.chrg.cpMin && ECX==tmpft.chrg.cpMax
				MOV EAX,tmpft.chrg.cpMin
				MOV ft.chrg.cpMin,EAX
				MOV EAX,tmpft.chrg.cpMax
				MOV ft.chrg.cpMax,EAX
				Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szReplacing			
				
				
				Invoke SendMessage,hEditor,EM_REPLACESEL,TRUE,Offset ReplaceBuff
				
				Invoke lstrlen,Offset ReplaceBuff
				MOV EDX,EAX
				ADD EAX,ft.chrg.cpMin
				MOV ft.chrg.cpMax,EAX
				
				MOV ECX,fr
				AND ECX,FR_UPDOWN
				.If ((fShowMessage==0 && bSecondPass) ||  fShowMessage==1) && ECX && bDownSearched 
					PUSH EDX
					Invoke lstrlen,Offset FindBuffer
					POP ECX
					SUB ECX,EAX
					ADD StartChrg.cpMin,ECX
				.EndIf
				;Invoke SendMessage,hEdit,EM_EXSETSEL,0,Offset ft.chrg
			.Else
				MOV EAX,tmpft.chrg.cpMin
				MOV ft.chrg.cpMin,EAX
				MOV ft.chrg.cpMax,EAX
			.EndIf
			Invoke SendMessage,hEditor,EM_EXSETSEL,0,Offset ft.chrg
			
			Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearching
			Invoke Find,hEditor,fr,Offset FindBuffer,fShowMessage
			
		.Else
			MOV fres,-1
		.EndIf	
		
		
		.If fres==-1
			.If fShowMessage==0 ;i.e. Current Project is selected
				Invoke SendMessage,hClient,WM_MDIGETACTIVE,0,0
				.If EAX
					@@:
					MOV EDI,EAX
					Invoke GetNextChild,EDI,fDirection
					
					.If EAX && !bSecondPass
						PUSH EAX
						Invoke SendMessage,hClient,WM_MDIRESTORE,EDI,0
						POP EDI
						Invoke SetWindowPos,EDI,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
						
						;hEditor is now different
						.If fDirection==0 ;i.e. Up
							Invoke SendMessage,hEditor,WM_GETTEXTLENGTH,0,0
						.Else
							XOR EAX,EAX
						.EndIf
						Invoke SendMessage,hEditor,EM_SETSEL,EAX,EAX
							
						Invoke SetFocus,hDlg
						
						MOV EAX,EDI 
						.If EAX==hStartChild
							MOV bSecondPass,TRUE 
						.EndIf
						JMP ReplaceAgain
					.Else
						Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearchFinished
						Invoke SendMessage,hEditor,EM_SETSEL,StartChrg.cpMin,StartChrg.cpMax
						Invoke SendMessage,hEditor,EM_SCROLLCARET,0,0
						MOV EAX,TRUE
						RET
					.EndIf
				.Else
					Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearchFinished
					MOV EAX,TRUE
					RET
				.EndIf
			.Else
				.If fDirection==2 && bDownSearched
					PUSH EAX
					Invoke SetStartingPosition
					POP EAX
				.EndIf
				RET 
			.EndIf
		.Else
			.If bSecondPass	;True only if we deal with the current project option
				Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
				MOV EAX,StartChrg.cpMax
				.If EAX<=chrg.cpMax
					Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szSearchFinished
					Invoke SendMessage,hEditor,EM_SETSEL,StartChrg.cpMin,StartChrg.cpMax
					Invoke SendMessage,hEditor,EM_SCROLLCARET,0,0
					MOV EAX,TRUE
					RET
				.EndIf 
			.EndIf
		.EndIf
	.EndIf

	XOR EAX,EAX
	
	RET 
Replace EndP

ReplaceAll Proc hDlg:HWND

	Invoke GetCursor
	PUSH EAX

	Invoke LoadCursor,0,IDC_WAIT
	Invoke SetCursor,EAX
	
	XOR EAX,EAX
	.While !EAX
		Invoke Replace,hDlg,1
	.EndW
	
	POP EAX
	Invoke SetCursor,EAX

	RET
ReplaceAll EndP

UpdateFindCombo Proc hDlg:HWND
Local chrg			:CHARRANGE
Local Buffer[256]	:BYTE

	Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
	MOV EAX,chrg.cpMin
	MOV ECX,chrg.cpMax
	SUB ECX,EAX
	.If EAX!=chrg.cpMax && ECX<256 
		Invoke SendMessage,hEditor,EM_GETSELTEXT,0,ADDR Buffer
		Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_FINDSTRINGEXACT,-1,ADDR Buffer
		.If EAX==CB_ERR	;i.e not found
			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_INSERTSTRING,0,ADDR Buffer
		.EndIf
		Invoke lstrcpy,Offset FindBuffer,ADDR Buffer
	.EndIf
	
	Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_FINDSTRINGEXACT,-1,ADDR FindBuffer
	.If EAX==CB_ERR
		XOR EAX,EAX
	.EndIf
	Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_SETCURSEL,EAX,0

	RET
UpdateFindCombo EndP

FindDlgProc Proc hDlg:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
Local Buffer[256]	:BYTE
Local nInx			:DWORD
Local szCounter[12]	:BYTE

	MOV EAX,uMsg
	.If EAX==WM_INITDIALOG
		Invoke GetDlgItem,hDlg,IDC_CHK_CURRENTPROJECT
		.If FullProjectName[0]==0
			Invoke EnableWindow,EAX,FALSE
			Invoke CheckDlgButton,hDlg,IDC_CHK_CURRENTPROJECT,BST_UNCHECKED
		.Else
		
		.EndIf
		Invoke SetTimer,hDlg,300,200,NULL
		
		
		Invoke RtlZeroMemory,ADDR Buffer,256
		MOV EAX,hDlg
		MOV hFindDialog,EAX
		MOV hFind,EAX
		.If lParam
			MOV EAX,BN_CLICKED
			SHL EAX,16
			OR EAX,IDC_BTN_REPLACE
			Invoke PostMessage,hDlg,WM_COMMAND,EAX,0
		.EndIf
		
		Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_LIMITTEXT,255,0
		.If lpFind
			PUSH EDI
			MOV EDI,lpFind
			@@:
			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_ADDSTRING,0,EDI
			ADD EDI,256
			.If BYTE PTR [EDI]!=0
				JMP @B
			.EndIf
			POP EDI
		.Else
			MOV nInx,0
			.While nInx<21
				INC nInx
				;Invoke wsprintf, ADDR szCounter, Offset szDecimalTemplate, nInx
				Invoke BinToDec,nInx,ADDR szCounter
				Invoke GetPrivateProfileString,	Offset szFIND,ADDR szCounter,ADDR szNULL, ADDR Buffer, 255, Offset IniFileName
				.If !EAX
					.Break
				.EndIf
				Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_ADDSTRING,0,ADDR Buffer
			.EndW
			
			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_SETCURSEL,0,0
			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,WM_GETTEXT,256,ADDR Buffer
			.If Buffer[0] ;i.e. This is first time Find dialog is fired AND there is at least one entry in [FIND] section of WinAsm.ini
				Invoke lstrcpy,Offset FindBuffer,ADDR Buffer
			.EndIf
		.EndIf
		
		Invoke UpdateFindCombo,hDlg
		
;		Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
;		MOV EAX,chrg.cpMin
;		MOV ECX,chrg.cpMax
;		SUB ECX,EAX
;		.If EAX!=chrg.cpMax && ECX<256 
;			Invoke SendMessage,hEditor,EM_GETSELTEXT,0,ADDR Buffer
;			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_FINDSTRINGEXACT,-1,ADDR Buffer
;			.If EAX==CB_ERR	;i.e not found
;				Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_INSERTSTRING,0,ADDR Buffer
;			.EndIf
;			Invoke lstrcpy,Offset FindBuffer,ADDR Buffer
;		.EndIf
;		
;		Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_FINDSTRINGEXACT,-1,ADDR FindBuffer
;		
;		.If EAX==CB_ERR
;			XOR EAX,EAX
;		.EndIf
;		Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_SETCURSEL,EAX,0
		
		Invoke SendDlgItemMessage,hDlg,IDC_REPLACETEXT,EM_LIMITTEXT,255,0
		Invoke SendDlgItemMessage,hDlg,IDC_REPLACETEXT,WM_SETTEXT,0,Offset ReplaceBuff
		;Set check boxes
		MOV EAX,fr
		AND EAX,FR_MATCHCASE
		.If EAX
			Invoke CheckDlgButton,hDlg,IDC_CHK_MATCHCASE,BST_CHECKED
		.EndIf
		MOV EAX,fr
		AND EAX,FR_WHOLEWORD
		.If EAX
			Invoke CheckDlgButton,hDlg,IDC_CHK_WHOLEWORD,BST_CHECKED
		.EndIf
		
		MOV EAX,fr
		AND EAX,FR_CURRENTPROJECT
		.If EAX
			Invoke SetStartingPosition
			Invoke CheckDlgButton,hDlg,IDC_CHK_CURRENTPROJECT,BST_CHECKED
		.EndIf
		
		
		;Set find direction
		MOV EAX,fr
		AND EAX,FR_UPDOWN
		.If EAX
			MOV EAX,IDC_RBN_UPDOWN
		.Else
			MOV EAX,fr
			AND EAX,FR_DOWN
			.If EAX
				MOV EAX,IDC_RBN_DOWN
			.Else
				MOV EAX,IDC_RBN_UP
			.EndIf
		.EndIf
		Invoke CheckDlgButton,hDlg,EAX,BST_CHECKED
		
		
	.ElseIf EAX==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==2012
				Invoke FindNext,hDlg
			.ElseIf EAX==IDCANCEL
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
				
			.ElseIf EAX==IDC_BTN_REPLACE
				Invoke Replace,hDlg,1
				
			.ElseIf EAX==IDC_BTN_REPLACEALL
				Invoke ReplaceAll,hDlg
				
			.ElseIf EAX==IDC_RBN_DOWN
				;Set find direction to down
				OR fr,FR_DOWN
				AND fr,-1 XOR FR_UPDOWN
				MOV fres,-1
			.ElseIf EAX==IDC_RBN_UP
				;Set find direction to up
				AND fr,-1 XOR (FR_DOWN OR FR_UPDOWN)
				MOV fres,-1
			.ElseIf EAX==IDC_RBN_UPDOWN
				Invoke SetStartingPosition
				;Set find direction to UPdown
				OR fr,FR_UPDOWN OR FR_DOWN
				MOV fres,-1
				
			.ElseIf EAX==IDC_CHK_MATCHCASE
				;Set match case mode
				Invoke IsDlgButtonChecked,hDlg,IDC_CHK_MATCHCASE
				.If EAX
					OR fr,FR_MATCHCASE
				.Else
					AND fr,-1 xor FR_MATCHCASE
				.EndIf
				MOV fres,-1
			.ElseIf EAX==IDC_CHK_WHOLEWORD
				;Set whole word mode
				Invoke IsDlgButtonChecked,hDlg,IDC_CHK_WHOLEWORD
				.If EAX
					OR fr,FR_WHOLEWORD
				.Else
					AND fr,-1 XOR FR_WHOLEWORD
				.EndIf
				MOV fres,-1
				Invoke SetStartingPosition
			.ElseIf EAX==IDC_CHK_CURRENTPROJECT
				;Set All Files mode
				Invoke IsDlgButtonChecked,hDlg,IDC_CHK_CURRENTPROJECT
				.If EAX
					;Invoke CheckDlgButton,hDlg,IDC_RBN_UPDOWN,BST_CHECKED
					OR fr,FR_CURRENTPROJECT
				.Else
					AND fr,-1 XOR FR_CURRENTPROJECT
				.EndIf
				MOV fres,-1
				Invoke SetStartingPosition
			.EndIf
		.ElseIf EDX==EN_CHANGE
			;Update text buffers
			.If EAX==IDC_REPLACETEXT
				Invoke SendDlgItemMessage,hDlg,EAX,WM_GETTEXT,SizeOf ReplaceBuff,Offset ReplaceBuff
				Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szNULL
				MOV fres,-1
				Invoke SetStartingPosition
			.EndIf
		.ElseIf EDX==CBN_EDITCHANGE && EAX==IDC_FINDTEXT
			Invoke SendDlgItemMessage,hDlg,EAX,WM_GETTEXT,SizeOf FindBuffer, Offset FindBuffer
			MOV fres,-1
			Invoke SendDlgItemMessage,hFindDialog,2020,WM_SETTEXT,0, Offset szNULL
			Invoke SetStartingPosition
			
		.ElseIf EDX==CBN_CLOSEUP && EAX==IDC_FINDTEXT
			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_GETCURSEL,0,0
			MOV EDX,EAX
			Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_GETLBTEXT,EDX, Offset FindBuffer
			MOV fres,-1
			Invoke SendDlgItemMessage,hDlg,2020,WM_SETTEXT,0, Offset szNULL
			Invoke SetStartingPosition
		.EndIf
	;.ElseIf EAX==WM_ACTIVATE
		;MOV fres,-1
		;Invoke SetStartingPosition
	.ElseIf EAX==WM_CLOSE
		MOV hFind,0
		
		.If lpFind
			Invoke HeapFree,hMainHeap,0,lpFind
			MOV lpFind,0
		.EndIf
		
		Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_GETCOUNT,0,0
		.If EAX
			PUSH EDI
			Invoke MulDiv,EAX,256,1
			;Now EAX is the number of Bytes I need to allocate
			INC EAX	;For safety
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,EAX
			MOV lpFind,EAX
			MOV EDI,EAX
			MOV nInx,0		
			.While TRUE
				Invoke SendDlgItemMessage,hDlg,IDC_FINDTEXT,CB_GETLBTEXT,nInx,EDI
				.Break .If EAX==CB_ERR
				INC nInx
				.If nInx<21
					;Invoke wsprintf, ADDR szCounter, Offset szDecimalTemplate, nInx
					Invoke BinToDec,nInx,ADDR szCounter
					Invoke WritePrivateProfileString, Offset szFIND, ADDR szCounter, EDI, Offset IniFileName
				.EndIf
				ADD EDI,256
			.EndW
			POP EDI
		.EndIf
		MOV hFindDialog,0
		;Invoke EndDialog,hDlg,NULL
		Invoke DestroyWindow,hDlg
		Invoke SetFocus,hEditor
	.ElseIf EAX==WM_TIMER
		Invoke GetDlgItem,hDlg,IDC_CHK_CURRENTPROJECT
		.If FullProjectName[0]==0
			Invoke EnableWindow,EAX,FALSE
			Invoke CheckDlgButton,hDlg,IDC_CHK_CURRENTPROJECT,BST_UNCHECKED
			AND fr,-1 XOR FR_CURRENTPROJECT
		.Else
			Invoke EnableWindow,EAX,TRUE
			MOV EAX,fr
			AND EAX,FR_CURRENTPROJECT
			.If EAX
				Invoke CheckDlgButton,hDlg,IDC_CHK_CURRENTPROJECT,BST_CHECKED
			.EndIf
		.EndIf
	.Else
		.If EAX==WM_NCACTIVATE
			Invoke InvalidateAllDockWindows
		.EndIf
		MOV EAX,FALSE
		RET
	.EndIf
	MOV  EAX,TRUE
	RET
FindDlgProc EndP