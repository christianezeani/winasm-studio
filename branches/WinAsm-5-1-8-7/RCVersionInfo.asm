IDD_DLGVERSIONINFO		EQU 213
IDC_EDITFILEVERSION		EQU 3
IDC_EDITPRODVERSION		EQU 4
IDC_CBOOSVERSION		EQU 5
IDC_CBOVERSIONTYPE		EQU 6
IDC_LSTVERSION			EQU 7
IDC_EDITVERSION			EQU 8
IDC_EDTVERSIONNAME		EQU 9
IDC_EDTVERSIONID		EQU 10
IDC_CBOVERSIONLANG		EQU 11
IDC_CBOVERSIONCHAR		EQU 12
IDC_EDTVERSIONTYPE		EQU 13
IDC_BTNVERSIONADD		EQU 14

.DATA
szFILEVERSION		DB 'FILEVERSION',0
szPRODUCTVERSION	DB 'PRODUCTVERSION',0
szFILEFLAGSMASK		DB 'FILEFLAGSMASK',0
szFILEFLAGS			DB 'FILEFLAGS',0
szFILETYPE			DB 'FILETYPE',0
szFILESUBTYPE		DB 'FILESUBTYPE',0
szBLOCK				DB 'BLOCK',0
szFILEOS			DB 'FILEOS',0
szVALUE				DB 'VALUE',0

szTranslation		DB 'Translation',0
szStringFileInfo	DB 'StringFileInfo',0
szVarFileInfo		DB 'VarFileInfo',0
szDot				DB ".",0

szVerOS				DD 00000004h
					DB 'WINDOWS32',0
					DD 00000000h
					DB 'UNKNOWN',0
					DD 00010000h
					DB 'DOS',0
					DD 00020000h
					DB 'OS216',0
					DD 00030000h
					DB 'OS232',0
					DD 00040000h
					DB 'NT',0
					DD 00000000h
					DB 'BASE',0
					DD 00000001h
					DB 'WINDOWS16',0
					DD 00000002h
					DB 'PM16',0
					DD 00000003h
					DB 'PM32',0
					DD 00010001h
					DB 'DOS_WINDOWS16',0
					DD 00010004h
					DB 'DOS_WINDOWS32',0
					DD 00020002h
					DB 'OS216_PM16',0
					DD 00030003h
					DB 'OS232_PM32',0
					DD 00040004h
					DB 'NT_WINDOWS32',0
					DD 0,0

szVerFT				DD 00000000h
					DB 'UNKNOWN',0
					DD 00000001h
					DB 'APP',0
					DD 00000002h
					DB 'DLL',0
					DD 00000003h
					DB 'DRV',0
					DD 00000004h
					DB 'FONT',0
					DD 00000005h
					DB 'VXD',0
					DD 00000007h
					DB 'STATIC_LIB',0
					DD 0,0
					
szVerLNG			DD 0401h
					DB 'Arabic',0
					DD 0402h
					DB 'Bulgarian',0
					DD 0403h
					DB 'Catalan',0
					DD 0404h
					DB 'Traditional Chinese',0
					DD 0405h
					DB 'Czech',0
					DD 0406h
					DB 'Danish',0
					DD 0407h
					DB 'German',0
					DD 0408h
					DB 'Greek',0
					DD 0409h
					DB 'U.S. English',0
					DD 040Ah
					DB 'Castilian Spanish',0
					DD 040Bh
					DB 'Finnish',0
					DD 040Ch
					DB 'French',0
					DD 040Dh
					DB 'Hebrew',0
					DD 040Eh
					DB 'Hungarian',0
					DD 040Fh
					DB 'Icelandic',0
					DD 0410h
					DB 'Italian',0
					DD 0411h
					DB 'Japanese',0
					DD 0412h
					DB 'Korean',0
					DD 0413h
					DB 'Dutch',0
					DD 0414h
					DB 'Norwegian - Bokml',0
					DD 0415h
					DB 'Polish',0
					DD 0416h
					DB 'Brazilian Portuguese',0
					DD 0417h
					DB 'Rhaeto-Romanic',0
					DD 0417h
					DB 'Rhaeto-Romanic',0
					DD 0418h
					DB 'Romanian',0
					DD 0419h
					DB 'Russian',0
					DD 041Ah
					DB 'Croato-Serbian (Latin)',0
					DD 041Bh
					DB 'Slovak',0
					DD 041Ch
					DB 'Albanian',0
					DD 041Dh
					DB 'Swedish',0
					DD 041Eh
					DB 'Thai',0
					DD 041Fh
					DB 'Turkish',0
					DD 0420h
					DB 'Urdu',0
					DD 0421h
					DB 'Bahasa',0
					DD 0804h
					DB 'Simplified Chinese',0
					DD 0807h
					DB 'Swiss German',0
					DD 0809h
					DB 'U.K. English',0
					DD 080Ah
					DB 'Mexican Spanish',0
					DD 080Ch
					DB 'Belgian French',0
					DD 0810h
					DB 'Swiss Italian',0
					DD 0813h
					DB 'Belgian Dutch',0
					DD 0814h
					DB 'Norwegian - Nynorsk',0
					DD 0816h
					DB 'Portuguese',0
					DD 081Ah
					DB 'Serbo-Croatian (Cyrillic)',0
					
					DD 0C09h
					DB 'English (Australia)',0
					
					DD 0C0Ch
					DB 'Canadian French',0
					DD 100Ch
					DB 'Swiss French',0
					DD 0,0
					
					
szVerCHS			DD 932
					DB 'Japan (Shift - JIS X-0208)',0
					DD 936
					DB 'Simplified Chinese',0
					DD 949
					DB 'Korea (Shift - KSC 5601)',0
					DD 950
					DB 'Taiwan (GB5)',0
					DD 1250
					DB 'Latin-2 (Eastern European)',0
					DD 1251
					DB 'Cyrillic',0
					DD 1252
					DB 'Western Europe',0
					DD 1253
					DB 'Greek',0
					DD 1254
					DB 'Turkish',0
					DD 1255
					DB 'Hebrew',0
					DD 1256
					DB 'Arabic',0
					DD 1257
					DB 'Baltic',0
					DD 0,0

szVerTpe			DB 'CompanyName',0
szFileVersion		DB 'FileVersion',0
					DB 'FileDescription',0
					DB 'InternalName',0
					DB 'LegalCopyright',0
					DB 'LegalTrademarks',0
					DB 'OriginalFilename',0
					DB 'ProductName',0
					DB 'ProductVersion',0
					DB 0
					

.DATA?
bAutoIncStateChanged	DWORD ?
szVersionTxt			DB 32*256 DUP(?)
lpVersionInfoMem		DD ?
lpTempVersionInfoMem	DD ?


.CODE

ExtractVersionInfo Proc Uses EBX ESI EDI,lpRCMem:DWORD,lpProMem:DWORD
Local Buffer[256]:BYTE
Local nNest	:DWORD
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
	MOV EDI,EAX;lpVersionInfoMem
	PUSH EDI
	;Name / ID
	Invoke GetName,lpProMem,Offset NameBuffer,ADDR [EDI].VERSIONMEM.szName,ADDR [EDI].VERSIONMEM.Value
	MOV EAX,[EDI].VERSIONMEM.Value
	.If HighestVersionInfoID < EAX
		MOV HighestVersionInfoID,EAX
	.EndIf
	
	MOV ESI,lpRCMem
	Invoke GetLoadOptions,ESI
	ADD ESI,EAX
  @@:
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szFILEVERSION
	.If !EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.fv[0],EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.fv[4],EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.fv[8],EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.fv[12],EAX
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szPRODUCTVERSION
	.If !EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.pv[0],EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.pv[4],EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.pv[8],EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.pv[12],EAX
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szFILEFLAGSMASK
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szFILEFLAGS
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szFILEOS
	.If !EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.os,EAX
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szFILETYPE
	.If !EAX
		Invoke GetNum,lpProMem
		MOV [EDI].VERSIONMEM.ft,EAX
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szFILESUBTYPE
	.If !EAX
		Invoke GetNum,lpProMem
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
	.If !EAX
		MOV EBX,EDI
		ADD EDI,SizeOf VERSIONMEM
		MOV nNest,1
	  @@:
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
		.If !EAX
			INC nNest
			JMP @B
		.EndIf
		Invoke lstrcmpi,Offset ThisWord,Offset szBLOCK
		.If !EAX
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
			JMP @B
		.EndIf
		Invoke lstrcmpi,Offset ThisWord,Offset szVALUE
		.If !EAX
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
			Invoke UnQuoteWord,Offset ThisWord
			Invoke lstrcmpi,Offset ThisWord,Offset szTranslation
			.If !EAX
				Invoke GetNum,lpProMem
				MOV [EBX].VERSIONMEM.lng,EAX
				Invoke GetNum,lpProMem
				MOV [EBX].VERSIONMEM.chs,EAX
			.Else
				Invoke lstrcpyn,ADDR [EDI].VERSIONITEM.szName,Offset ThisWord,SizeOf VERSIONITEM.szName
				Invoke GetWord,Offset ThisWord,ESI
				ADD ESI,EAX
				Invoke UnQuoteWord,Offset ThisWord
				Invoke lstrlen,Offset ThisWord
				.If WORD PTR ThisWord[EAX-2]=='0\'
					MOV BYTE PTR ThisWord[EAX-2],0
				.EndIf
				Invoke lstrcpyn,ADDR [EDI].VERSIONITEM.szValue,Offset ThisWord,SizeOf VERSIONITEM.szValue
				ADD EDI,SizeOf VERSIONITEM
			.EndIf
			JMP @B
		.EndIf
		Invoke lstrcmpi,Offset ThisWord,Offset szEND
		.If !EAX
			DEC nNest
			JNE @B
		.EndIf
	.EndIf
  Ex:
  	POP EDI
	LEA EAX,[EDI].VERSIONMEM.szName
	.If BYTE PTR [EAX]==0
		Invoke BinToDec,[EDI].VERSIONMEM.Value,ADDR Buffer
		LEA EAX,Buffer
	.EndIf
	Invoke AddToOthersTree,3,EAX,EDI
	MOV [EDI].VERSIONMEM.hTreeItem,EAX

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ExtractVersionInfo EndP

PopulateComboAndSelect Proc Uses ESI EDI hWin:HWND,nID:DWORD,lpKey:DWORD,nVal:DWORD

	MOV ESI,lpKey
	.While BYTE PTR [ESI+4]
		PUSH [ESI]
		ADD ESI,4
		Invoke SendDlgItemMessage,hWin,nID,CB_ADDSTRING,0,ESI
		pop EDX
		Invoke SendDlgItemMessage,hWin,nID,CB_SETITEMDATA,EAX,EDX
		Invoke lstrlen,ESI
		LEA ESI,[ESI+EAX+1]
	.EndW
	XOR EDI,EDI
	.While TRUE
		Invoke SendDlgItemMessage,hWin,nID,CB_GETITEMDATA,EDI,0
		.Break .If EAX==CB_ERR
		.If EAX==nVal
			Invoke SendDlgItemMessage,hWin,nID,CB_SETCURSEL,EDI,0
			.Break
		.EndIf
		INC EDI
	.EndW
	RET

PopulateComboAndSelect EndP

VersionInfoDialogProc Proc Uses EBX EDI ESI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local lvc			:LV_COLUMN
Local lvi			:LVITEM
Local Buffer[256]	:BYTE
Local tvi			:TVITEM

	.If uMsg == WM_INITDIALOG
		MOV bAutoIncStateChanged,FALSE
		.If !lParam;pVersionInfoMem	;This is NEW Version Info in this RC File
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024	;Allocate Memory,otherwise Run time Error 
			MOV EDI,EAX
			MOV lpTempVersionInfoMem,EAX
			MOV lpVersionInfoMem,0
			;Initialize since this is a new Version Info
			Invoke lstrcpy,ADDR [EDI].VERSIONMEM.szName,CTEXT("IDV_VERSION")
			INC HighestVersionInfoID
			MOV EAX,HighestVersionInfoID			
			MOV [EDI].VERSIONMEM.Value,EAX	;1
			Invoke BinToDec,HighestVersionInfoID,ADDR Buffer
			Invoke lstrcat,ADDR [EDI].VERSIONMEM.szName,ADDR Buffer
			
			MOV [EDI].VERSIONMEM.fv[0],1
			MOV [EDI].VERSIONMEM.pv[0],1
			MOV [EDI].VERSIONMEM.os,4h		;i.e WINDOWS32
			MOV [EDI].VERSIONMEM.ft,1		;i.e APP
			MOV [EDI].VERSIONMEM.lng,0409h	;i.e U.S. English
			MOV [EDI].VERSIONMEM.chs,1252	;i.e Western Europe
		.Else
			MOV lpTempVersionInfoMem,0
			MOV EDI,lParam
			MOV lpVersionInfoMem,EDI
;			Invoke DeleteDefine,ADDR [EDI].VERSIONMEM.szName
		.EndIf
		
		
		;VersionInfo Name Edit Box
		Invoke SendDlgItemMessage,hWnd,9,WM_SETTEXT,0,ADDR [EDI].VERSIONMEM.szName
		
		;VersionInfo ID Edit Box
		Invoke BinToDec,[EDI].VERSIONMEM.Value,ADDR Buffer
		Invoke SendDlgItemMessage,hWnd,10,WM_SETTEXT,0,ADDR Buffer

		;File Version
		LEA ESI,Buffer
		Invoke BinToDec,[EDI].VERSIONMEM.fv[0],ESI
		Invoke lstrcat,ADDR Buffer,Offset szDot
		Invoke lstrlen,ADDR Buffer
		ADD EAX,ESI
		Invoke BinToDec,[EDI].VERSIONMEM.fv[4],EAX
		Invoke lstrcat,ADDR Buffer,Offset szDot
		Invoke lstrlen,ADDR Buffer
		ADD EAX,ESI
		Invoke BinToDec,[EDI].VERSIONMEM.fv[8],EAX
		Invoke lstrcat,ADDR Buffer,Offset szDot
		Invoke lstrlen,ADDR Buffer
		ADD EAX,ESI
		Invoke BinToDec,[EDI].VERSIONMEM.fv[12],EAX
		Invoke SendDlgItemMessage,hWnd,3,WM_SETTEXT,0,ADDR Buffer
		
		;Product Version
		LEA ESI,Buffer
		Invoke BinToDec,[EDI].VERSIONMEM.pv[0],ESI
		Invoke lstrcat,ADDR Buffer,Offset szDot
		Invoke lstrlen,ADDR Buffer
		ADD EAX,ESI
		Invoke BinToDec,[EDI].VERSIONMEM.pv[4],EAX
		Invoke lstrcat,ADDR Buffer,Offset szDot
		Invoke lstrlen,ADDR Buffer
		ADD EAX,ESI
		Invoke BinToDec,[EDI].VERSIONMEM.pv[8],EAX
		Invoke lstrcat,ADDR Buffer,Offset szDot
		Invoke lstrlen,ADDR Buffer
		ADD EAX,ESI
		Invoke BinToDec,[EDI].VERSIONMEM.pv[12],EAX
		Invoke SendDlgItemMessage,hWnd,4,WM_SETTEXT,0,ADDR Buffer

		;OS Combo
		Invoke PopulateComboAndSelect,hWnd,IDC_CBOOSVERSION,Offset szVerOS,[EDI].VERSIONMEM.os
		;File Type Combo
		Invoke PopulateComboAndSelect,hWnd,IDC_CBOVERSIONTYPE,Offset szVerFT,[EDI].VERSIONMEM.ft
		;Language Combo
		Invoke PopulateComboAndSelect,hWnd,IDC_CBOVERSIONLANG,Offset szVerLNG,[EDI].VERSIONMEM.lng
		;CharSet Combo
		Invoke PopulateComboAndSelect,hWnd,IDC_CBOVERSIONCHAR,Offset szVerCHS,[EDI].VERSIONMEM.chs
		
		
		LEA EDI,[EDI+SizeOf VERSIONMEM]
		MOV ESI,Offset szVerTpe
		.While BYTE PTR [ESI]
			CALL AddType
			Invoke lstrlen,ESI
			LEA ESI,[ESI+EAX+1]
		.EndW
		MOV ESI,Offset szVersionTxt
		.While [EDI].VERSIONITEM.szName
			Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_ADDSTRING,0,ADDR [EDI].VERSIONITEM.szName
			Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_SETITEMDATA,EAX,ESI
			Invoke lstrcpy,ESI,ADDR [EDI].VERSIONITEM.szValue
			ADD ESI,256
			LEA EDI,[EDI+SizeOf VERSIONITEM]
		.EndW
		
		.If AutoIncFileVersion
			Invoke SendDlgItemMessage,hWnd,15,BM_SETCHECK,BST_CHECKED,0
		.EndIf
		
		Invoke SendDlgItemMessage,hWnd,IDC_EDITVERSION,EM_LIMITTEXT,255,0
		Invoke SendDlgItemMessage,hWnd,IDC_EDTVERSIONTYPE,EM_LIMITTEXT,63,0
		Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_SETCURSEL,0,0
		Invoke SendMessage,hWnd,WM_COMMAND,(LBN_SELCHANGE SHL 16) OR IDC_LSTVERSION,0
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==1	;OK
				
				.If bAutoIncStateChanged
					Invoke SendDlgItemMessage,hWnd,15,BM_GETCHECK,0,0
					MOV AutoIncFileVersion,EAX
					MOV ProjectModified,TRUE
				.EndIf
				.If !lpVersionInfoMem	;There is NOT Version Info in this RC File
					MOV EDI,lpTempVersionInfoMem
				.Else
					MOV EDI,lpVersionInfoMem
					Invoke DeleteDefine,ADDR [EDI].VERSIONMEM.szName
				.EndIf
				
				;VersionInfo Name Edit Box
				Invoke SendDlgItemMessage,hWnd,9,WM_GETTEXT,31,ADDR [EDI].VERSIONMEM.szName
				
				;VersionInfo Value Edit Box
				Invoke SendDlgItemMessage,hWnd,10,WM_GETTEXT,256,ADDR Buffer
				Invoke AddOrReplaceDefine,ADDR [EDI].VERSIONMEM.szName,ADDR Buffer
				
				Invoke DecToBin,ADDR Buffer
				MOV [EDI].VERSIONMEM.Value,EAX
				
				.If HighestVersionInfoID < EAX
					MOV HighestVersionInfoID,EAX
				.EndIf
				
				;.If EAX==1
					;szAutoIncFileVersion
				;.EndIf
				
				;File Version
				Invoke GetDlgItemText,hWnd,3,ADDR Buffer,16
				PUSH EDI
				LEA EDI,[EDI].VERSIONMEM.fv
				CALL GetVerNum
				POP EDI
				
				;Product Version
				Invoke GetDlgItemText,hWnd,4,ADDR Buffer,16
				PUSH EDI
				LEA EDI,[EDI].VERSIONMEM.pv
				CALL GetVerNum
				POP EDI
				
				;Take Values from the Combo's and Store them in the lpVersionInfoMem
				Invoke SendDlgItemMessage,hWnd,IDC_CBOOSVERSION,CB_GETCURSEL,0,0
				Invoke SendDlgItemMessage,hWnd,IDC_CBOOSVERSION,CB_GETITEMDATA,EAX,0
				MOV [EDI].VERSIONMEM.os,EAX
				Invoke SendDlgItemMessage,hWnd,IDC_CBOVERSIONTYPE,CB_GETCURSEL,0,0
				Invoke SendDlgItemMessage,hWnd,IDC_CBOVERSIONTYPE,CB_GETITEMDATA,EAX,0
				MOV [EDI].VERSIONMEM.ft,EAX
				Invoke SendDlgItemMessage,hWnd,IDC_CBOVERSIONLANG,CB_GETCURSEL,0,0
				Invoke SendDlgItemMessage,hWnd,IDC_CBOVERSIONLANG,CB_GETITEMDATA,EAX,0
				MOV [EDI].VERSIONMEM.lng,EAX
				
				Invoke SendDlgItemMessage,hWnd,IDC_CBOVERSIONCHAR,CB_GETCURSEL,0,0
				Invoke SendDlgItemMessage,hWnd,IDC_CBOVERSIONCHAR,CB_GETITEMDATA,EAX,0
				.If EAX!=CB_ERR
					MOV [EDI].VERSIONMEM.chs,EAX
				.EndIf
				LEA EDI,[EDI+SizeOf VERSIONMEM]
				XOR EBX,EBX
				.While TRUE
					MOV [EDI].VERSIONITEM.szName,0
					MOV [EDI].VERSIONITEM.szValue,0
					Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_GETTEXT,EBX,ADDR [EDI].VERSIONITEM.szName
					.Break .If EAX==LB_ERR
					Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_GETITEMDATA,EBX,0
					Invoke lstrcpy,ADDR [EDI].VERSIONITEM.szValue,EAX
					LEA EDI,[EDI+SizeOf VERSIONITEM]
					INC EBX
				.EndW
				
				.If !lpVersionInfoMem	;There is NOT Version Info in this RC File
					;Add this as a new Version Info Table
					MOV EDI,lpTempVersionInfoMem
				.Else
					MOV EDI,lpVersionInfoMem
				.EndIf
				
				LEA EAX,[EDI].VERSIONMEM.szName
				.If BYTE PTR [EAX]==0
					Invoke BinToDec,[EDI].VERSIONMEM.Value,ADDR Buffer
					LEA EAX,Buffer
				.EndIf
				
				.If !lpVersionInfoMem	;There is NOT Version Info in this RC File
					Invoke AddToOthersTree,3,EAX,EDI
					MOV [EDI].VERSIONMEM.hTreeItem,EAX
				.Else
					MOV tvi._mask,TVIF_TEXT
					MOV tvi.cchTextMax,256
					MOV tvi.pszText,EAX
					M2M tvi.hItem,[EDI].VERSIONMEM.hTreeItem
					Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
				.EndIf
				
				;MOV RCModified,TRUE
				Invoke SetRCModified,TRUE
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.ElseIf EAX==2	;Cancel
				.If !lpVersionInfoMem		;This was a new Version Info
					Invoke HeapFree,hMainHeap,0,lpTempVersionInfoMem
					DEC HighestVersionInfoID
				.EndIf
				
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
			.ElseIf EAX==IDC_BTNVERSIONADD
				.If !lpVersionInfoMem	;This was a new Version Info
					MOV EDI,lpTempVersionInfoMem
				.Else
					MOV EDI,lpVersionInfoMem
				.EndIf
				
				Invoke SendDlgItemMessage,hWnd,IDC_EDTVERSIONTYPE,WM_GETTEXT,SizeOf Buffer,ADDR Buffer
				LEA ESI,Buffer
				lea EDI,[EDI+sizeof VERSIONMEM]
				call AddType
				Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_RESETCONTENT,0,0
				mov ESI,offset szVersionTxt
				;mov nInx,-1
				MOV EBX,-1
				.While [EDI].VERSIONITEM.szName
					Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_ADDSTRING,0,addr [EDI].VERSIONITEM.szName
					Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_SETITEMDATA,eax,ESI
					Invoke lstrcpy,ESI,addr [EDI].VERSIONITEM.szValue
					inc EBX
					add ESI,256
					lea EDI,[EDI+sizeof VERSIONITEM]
				.EndW
				mov Buffer,0
				Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_SETCURSEL,EBX,0
				Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,WM_SETTEXT,0,addr Buffer
				Invoke SendMessage,hWnd,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTVERSION,0
			.ElseIf EAX==15	;Auto Increment
				;Let's check if this RC file is part of a project
				Invoke GetWindowLong,hRCEditorWindow,0
				.If [EAX].CHILDWINDOWDATA.dwTypeOfFile==3
					MOV bAutoIncStateChanged,TRUE
				.EndIf
			.EndIf
		.ElseIf EDX==EN_CHANGE
			.If EAX==IDC_EDITVERSION
				Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_GETCURSEL,0,0
				Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_GETITEMDATA,eax,0
				Invoke SendDlgItemMessage,hWnd,IDC_EDITVERSION,WM_GETTEXT,256,eax
			.ElseIf eax==IDC_EDTVERSIONTYPE
				Invoke GetDlgItem,hWnd,IDC_BTNVERSIONADD
				push	eax
				Invoke SendDlgItemMessage,hWnd,IDC_EDTVERSIONTYPE,WM_GETTEXTLENGTH,0,0
				pop		edx
				Invoke EnableWindow,edx,eax
			.EndIf
			
		.ElseIf EDX==LBN_SELCHANGE
			.If EAX==IDC_LSTVERSION
				Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_GETCURSEL,0,0
				.If EAX!=LB_ERR
					Invoke SendDlgItemMessage,hWnd,IDC_LSTVERSION,LB_GETITEMDATA,EAX,0
					;IDC_EDTVER=8
					Invoke SendDlgItemMessage,hWnd,IDC_EDITVERSION,WM_SETTEXT,0,EAX
				.EndIf
			.EndIf
		.EndIf

	.ElseIf uMsg == WM_CLOSE
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL
	.EndIf
	MOV EAX,FALSE
	RET
	
	;-------------------------------------------------------------------------------------------------
	AddType:
	PUSH EDI
	.While [EDI].VERSIONITEM.szName
		Invoke lstrcmpi,ADDR [EDI].VERSIONITEM.szName,ESI
		.Break .If !EAX
		LEA EDI,[EDI+SizeOf VERSIONITEM]
	.EndW
	Invoke lstrcpy,ADDR [EDI].VERSIONITEM.szName,ESI
	POP EDI
	RETN
	
	;-------------------------------------------------------------------------------------------------
	GetVerNum:
	LEA ESI,Buffer
	CALL GetVerNumItem
	MOV [EDI],EAX
	CALL GetVerNumItem
	MOV [EDI+4],EAX
	CALL GetVerNumItem
	MOV [EDI+8],EAX
	CALL GetVerNumItem
	MOV [EDI+12],EAX
	RETN

	;-------------------------------------------------------------------------------------------------
	GetVerNumItem:
	Invoke DecToBin,ESI
	.While BYTE PTR [ESI]!='.' && BYTE PTR [ESI]
		INC ESI
	.EndW
	.If BYTE PTR [ESI]=='.'
		INC ESI
	.EndIf
	RETN

VersionInfoDialogProc EndP

