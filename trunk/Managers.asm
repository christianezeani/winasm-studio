IDD_DLGOPTMNU	EQU 3200
IDC_LSTME		EQU 3201
IDC_EDTMEITEM	EQU 3202
IDC_EDTMECMND	EQU 3203
IDC_BTNMEU		EQU 3204
IDC_BTNMED		EQU 3205
IDC_BTNMEADD	EQU 3206
IDC_BTNMEDEL	EQU 3207
IDC_BTNMFILE	EQU 3208

IDB_ARROWUP		EQU 108
IDB_ARROWDN		EQU 109

.DATA?
hArrowUp			DD ?
hArrowDn			DD ?
hManagerDlg			DD ?

lpFilter			DD ?

.CODE
FillMenuItemsList Proc Uses EBX EDI
Local szCounter[12]:BYTE
Local Buffer[288]:BYTE	;256+32
	XOR EBX,EBX
	@@:
	INC EBX
	Invoke BinToDec,EBX,ADDR szCounter

	Invoke GetPrivateProfileString, Offset szTOOLS, ADDR szCounter, ADDR szNULL, ADDR Buffer, 288, Offset IniFileName
	.If EAX!=0 && EBX<=20
		LEA EDI,Buffer
		.If BYTE PTR [EDI]=="-"
			Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_ADDSTRING,0,Offset szMinus
		.Else
			.While BYTE PTR [EDI]!=0
				.If BYTE PTR [EDI]==","
					MOV BYTE PTR [EDI],VK_TAB
					Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_ADDSTRING,0,ADDR Buffer
					.Break
				.EndIf
				INC EDI
			.EndW
		.EndIf
		JMP @B
	.EndIf
	RET
FillMenuItemsList EndP

GetMenuItem Proc Uses EDI mItem:DWORD
Local Buffer[288]:BYTE	;256+32
	Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_GETTEXT,mItem,ADDR Buffer
	LEA EDI,Buffer
	.If BYTE PTR [EDI]=="-"
		Invoke SendDlgItemMessage,hManagerDlg,IDC_EDTMEITEM,WM_SETTEXT,0,Offset szMinus
		Invoke SendDlgItemMessage,hManagerDlg,IDC_EDTMECMND,WM_SETTEXT,0,NULL
	.Else
		.While BYTE PTR [EDI]!=0
			.If BYTE PTR [EDI]==VK_TAB
				MOV BYTE PTR [EDI],0
				Invoke SendDlgItemMessage,hManagerDlg,IDC_EDTMEITEM,WM_SETTEXT,0,ADDR Buffer
				INC EDI
				Invoke SendDlgItemMessage,hManagerDlg,IDC_EDTMECMND,WM_SETTEXT,0,EDI
				.Break
			.EndIf
			INC EDI
		.EndW
	.EndIf
	RET
GetMenuItem EndP

SaveMenuItems Proc Uses ESI
Local Buffer[256]:BYTE
Local nInx:DWORD
Local szCounter[12]:BYTE
	
	;Delete All Tools from INI
	MOV nInx,0
	@@:
	INC nInx
	Invoke BinToDec,nInx,ADDR szCounter
	
	Invoke WritePrivateProfileString,Offset szTOOLS,ADDR szCounter,Offset szNULL,Offset IniFileName
	.If nInx<20
		JMP @B
	.EndIf
	
	;Add New Tools to INI
	MOV nInx,0
	.While TRUE && nInx<20
		Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_GETTEXT,nInx,ADDR Buffer
		.Break .If EAX==LB_ERR
		MOV AL,Buffer[0]
		.If AL=="-" || AL==VK_TAB
			MOV Buffer[0],"-"
			MOV Buffer[1],0
			CALL AddIt			
		.Else;If AL!=VK_TAB
			LEA	ESI,Buffer
		  @@:
			MOV AL,[ESI]
			INC	ESI
			.If AL==09h
				MOV BYTE PTR [ESI-1],","
				CALL AddIt
			.Else
				JMP @B
			.EndIf
		.EndIf
		INC nInx
	.EndW
	RET
	
	AddIt:
	MOV EAX,nInx
	INC EAX
	LEA EDX,szCounter
	Invoke BinToDec,EAX,EDX

	Invoke WritePrivateProfileString,Offset szTOOLS,ADDR szCounter,ADDR Buffer,Offset IniFileName
	RETN
SaveMenuItems EndP

EditUpdate Proc Uses ESI
Local Buffer[256]:BYTE
Local nInx:DWORD
	Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,WM_SETREDRAW,FALSE,0
	Invoke GetDlgItemText,hManagerDlg,IDC_EDTMEITEM,ADDR Buffer,256
	Invoke lstrlen,ADDR Buffer
	LEA ESI,Buffer
	ADD ESI,EAX
	MOV BYTE PTR [ESI],09h
	INC ESI
	Invoke GetDlgItemText,hManagerDlg,IDC_EDTMECMND,ESI,256
	Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_GETCURSEL,0,0
	.If EAX==LB_ERR
		MOV EAX,0
	.EndIf
	MOV nInx,EAX
	Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_DELETESTRING,nInx,0
	Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_INSERTSTRING,nInx,ADDR Buffer
	Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,LB_SETCURSEL,nInx,0
	Invoke SendDlgItemMessage,hManagerDlg,IDC_LSTME,WM_SETREDRAW,TRUE,0
	RET
EditUpdate EndP

ManagerProc Proc hDlg:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
Local nInx:DWORD
Local Buffer[256]:BYTE

	MOV EAX,uMsg
	.If EAX==WM_VKEYTOITEM
;		WM_VKEYTOITEM  
;		vkey = LOWORD(wParam);      // virtual-key code 
;		nCaretPos = HIWORD(wParam); // caret position 
;		hwndLB = lParam;            // handle of list box 
;		
;		vkey
;		Value of the low-order word of wParam. Specifies the virtual-key code of the key the user pressed. 
;		
;		nCaretPos
;		Value of the high-order word of wParam. Specifies the current position of the caret. 
;		
;		hwndLB
;		Value of lParam. Identifies the list box.
		LOWORD wParam
		.If EAX==VK_DELETE
			Invoke SendMessage,hDlg,WM_COMMAND, (BN_CLICKED SHL 16) OR IDC_BTNMEDEL,0
			MOV EAX,-2
		.Else
			;Default processing
			MOV EAX,-1
		.EndIf
		RET
		;A return value of -2 indicates that the application handled all aspects of selecting the item and requires no further action by the list box.
		;A return value of -1 indicates that the list box should perform the default action in response to the keystroke.
		;A return value of 0 or greater specifies the index of an item in the list box and indicates that the list box should perform the default action for the keystroke on the given item. 
	.ElseIf EAX==WM_INITDIALOG
		M2M hManagerDlg,hDlg
		Invoke SendDlgItemMessage,hDlg,IDC_EDTMEITEM,EM_LIMITTEXT,32,0
		Invoke SendDlgItemMessage,hDlg,IDC_EDTMECMND,EM_LIMITTEXT,128,0
		MOV nInx,120
		Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_SETTABSTOPS,1,ADDR nInx
		
		LEA EAX,ExecutablesFilter
		MOV lpFilter,EAX
		
		Invoke LoadImage,hInstance,IDB_ARROWUP,IMAGE_BITMAP,0,0,LR_DEFAULTSIZE + LR_LOADMAP3DCOLORS
		MOV hArrowUp,EAX
		Invoke SendDlgItemMessage,hDlg,IDC_BTNMEU,BM_SETIMAGE,IMAGE_BITMAP,EAX
		
		Invoke LoadImage,hInstance,IDB_ARROWDN,IMAGE_BITMAP,0,0,LR_DEFAULTSIZE + LR_LOADMAP3DCOLORS
		MOV hArrowDn,EAX
		Invoke SendDlgItemMessage,hDlg,IDC_BTNMED,BM_SETIMAGE,IMAGE_BITMAP,EAX
		
		Invoke FillMenuItemsList
		Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_SETCURSEL,0,0
		Invoke GetMenuItem,0
		
	.ElseIf EAX==WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==IDOK
				Invoke SaveMenuItems
				;Delete All Items after "Tools Manager"
				.While TRUE
					Invoke DeleteMenu,WinAsmHandles.PopUpMenus.hToolsMenu,7,MF_BYPOSITION
					.Break .If !EAX
				.EndW
				Invoke AddToolsSubMenus
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
			.ElseIf EAX==IDCANCEL
				Invoke SendMessage,hDlg,WM_CLOSE,NULL,NULL
			.ElseIf EAX==IDC_BTNMEU
				Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETCURSEL,0,0
				.If EAX
					MOV nInx,EAX
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETTEXT,nInx,ADDR Buffer
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_DELETESTRING,nInx,0
					DEC nInx
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_INSERTSTRING,nInx,ADDR Buffer
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_SETCURSEL,nInx,0
				.EndIf
			.ElseIf EAX==IDC_BTNMED
				Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETCURSEL,0,0
				MOV nInx,EAX
				Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETCOUNT,0,0
				DEC EAX
				.If EAX!=nInx
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETTEXT,nInx,ADDR Buffer
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_DELETESTRING,nInx,0
					INC nInx
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_INSERTSTRING,nInx,ADDR Buffer
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_SETCURSEL,nInx,0
				.EndIf
			.ElseIf EAX==IDC_BTNMEADD
				Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETCURSEL,0,0
				.If EAX==LB_ERR
					MOV EAX,0
				.EndIf
				MOV nInx,EAX
				MOV Buffer[0],09h
				MOV Buffer[1],0
				Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_INSERTSTRING,nInx,addr Buffer
				Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_SETCURSEL,nInx,0
				Invoke SendDlgItemMessage,hDlg,IDC_EDTMECMND,WM_SETTEXT,0,addr szNULL
				Invoke SendDlgItemMessage,hDlg,IDC_EDTMEITEM,WM_SETTEXT,0,addr szNULL
			.ElseIf EAX==IDC_BTNMEDEL
				Invoke SendDlgItemMessage,hDlg,IDC_EDTMECMND,WM_SETTEXT,0,ADDR szNULL
				Invoke SendDlgItemMessage,hDlg,IDC_EDTMEITEM,WM_SETTEXT,0,ADDR szNULL
				Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETCURSEL,0,0
				.If EAX!=LB_ERR
					MOV nInx,EAX
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_DELETESTRING,nInx,0
					Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_SETCURSEL,nInx,0
					.If EAX==LB_ERR
						DEC nInx
						Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_SETCURSEL,nInx,0
					.EndIf
					.If EAX!=LB_ERR
						Invoke GetMenuItem,nInx
					.EndIf
				.EndIf
			.ElseIf EAX==IDC_BTNMFILE
				Invoke GetDlgItem,hDlg,IDC_EDTMECMND
				Invoke BrowseForFile,hDlg,lpFilter,EAX,0
			.EndIf
		.ElseIf EDX==EN_CHANGE
			Invoke EditUpdate
		.ElseIf EDX==LBN_SELCHANGE
			Invoke SendDlgItemMessage,hDlg,IDC_LSTME,LB_GETCURSEL,0,0
			.If EAX!=LB_ERR
				Invoke GetMenuItem,EAX
			.EndIf
		.EndIf
	.ElseIf EAX==WM_CLOSE
		Invoke DeleteObject,hArrowUp
		Invoke DeleteObject,hArrowDn
		Invoke EndDialog,hDlg,NULL
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
ManagerProc EndP
