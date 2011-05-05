IDB_ARROWLT			EQU 113
IDB_ARROWRT			EQU	114

IDC_EDTMENUNAME		EQU 4
IDC_EDTMENUID		EQU 5
IDC_EDTSTARTID		EQU 6
IDC_EDTITEMCAPTION	EQU 7
IDC_EDTITEMNAME		EQU 8
IDC_EDTITEMID		EQU 9

IDC_BTNINSERT		EQU 10
IDC_BTNDELETE		EQU 11
IDC_BTNL			EQU 12
IDC_BTNR			EQU 13
IDC_BTNU			EQU 14
IDC_BTND			EQU 15
IDC_CHKCHECKED		EQU 16
IDC_CHKGRAYED		EQU 17
IDC_CHKDISABLED		EQU 18
IDC_RBNSTRING		EQU 19
IDC_RBNBITMAP		EQU 20
IDC_RBNOWNERDRAW	EQU 21

IDC_LSTMNU			EQU 22
IDC_HOTMENU			EQU 23

MenuTypeDefinition	DD MFT_STRING
					DB 'MFT_STRING',0
					DD MFT_BITMAP
					DB 'MFT_BITMAP',0
					DD MFT_MENUBARBREAK
					DB 'MFT_MENUBARBREAK',0
					DD MFT_MENUBREAK
					DB 'MFT_MENUBREAK',0
					DD MFT_OWNERDRAW
					DB 'MFT_OWNERDRAW',0
					DD MFT_RADIOCHECK
					DB 'MFT_RADIOCHECK',0
					DD MFT_SEPARATOR
					DB 'MFT_SEPARATOR',0
					DD MFT_RIGHTORDER
					DB 'MFT_RIGHTORDER',0
					DD MFT_RIGHTJUSTIFY
					DB 'MFT_RIGHTJUSTIFY',0
					DD 0,0
				
MenuStateDefinition	DD MFS_GRAYED
					DB 'MFS_GRAYED',0
					DD MFS_DISABLED
					DB 'MFS_DISABLED',0
					DD MFS_CHECKED
					DB 'MFS_CHECKED',0
					DD MFS_HILITE
					DB 'MFS_HILITE',0
					DD MFS_ENABLED
					DB 'MFS_ENABLED',0
					DD MFS_UNCHECKED
					DB 'MFS_UNCHECKED',0
					DD MFS_UNHILITE
					DB 'MFS_UNHILITE',0
					DD MFS_DEFAULT
					DB 'MFS_DEFAULT',0
					DD MFS_HOTTRACKDRAWN
					DB 'MFS_HOTTRACKDRAWN',0
					DD MFS_CACHEDBMP
					DB 'MFS_CACHEDBMP',0
					DD MFS_BOTTOMGAPDROP
					DB 'MFS_BOTTOMGAPDROP',0
					DD MFS_TOPGAPDROP
					DB 'MFS_TOPGAPDROP',0
					DD MFS_GAPDROP
					DB 'MFS_GAPDROP',0
					DD 0,0


.DATA
szIDM_				DB 'IDM_',0
szPOPUP				DB 'POPUP',0
szMENUITEM			DB 'MENUITEM',0
szSEPARATOR			DB 'SEPARATOR',0
szCHECKED			DB 'CHECKED',0
szGRAYED			DB 'GRAYED',0
szINACTIVE			DB 'INACTIVE',0
szMENUBARBREAK		DB 'MENUBARBREAK',0
szMENUBREAK			DB 'MENUBREAK',0


szShiftPlus			DB 'Shift+',0
szCtrlPlus			DB 'Ctrl+',0
szAltPlus			DB 'Alt+',0

.CODE

;MakeMnuPopup Proc Uses EBX ESI,lpDlgMem:DWORD,nInx:DWORD
;	Local	hMnu[8]:DWORD
;	Local	buffer[512]:BYTE
;	Local	buffer1[32]:BYTE
;
;	MOV		hMnu,0
;	MOV		ESI,lpDlgMem
;	MOV		ESI,[ESI].DLGHEAD.lpmnu
;	add		ESI,sizeof MNUHEAD
;	MOV		EDX,nInx
;	INC		EDX
;  @@:
;	MOV		EAX,(MNUITEM PTR [ESI]).itemflag
;	.If EAX
;		.If EAX!=-1
;			MOV		EAX,(MNUITEM PTR [ESI]).level
;			.If !EAX
;				DEC		EDX
;				.If !EDX
;				  Nx:
;					add		ESI,sizeof MNUITEM
;					MOV		EAX,(MNUITEM PTR [ESI]).level
;					.If EAX
;						DEC		EAX
;						lea		EBX,[hMnu+EAX*4]
;						MOV		EAX,[EBX]
;						.If !EAX
;							Invoke CreatePopupMenu
;							MOV		[EBX],EAX
;						.EndIf
;						MOV		AL,(MNUITEM PTR [ESI]).itemcaption
;						.If AL=='-'
;							Invoke AppendMenu,[EBX],MF_SEPARATOR,0,0
;						.Else
;							MOV		buffer1,VK_TAB
;							Invoke MnuSaveAccel,[ESI].MNUITEM.shortcut,addr buffer1[1]
;							Invoke lstrcpy,addr buffer,addr (MNUITEM PTR [ESI]).itemcaption
;							.If buffer1[1]
;								Invoke lstrcat,addr buffer,addr buffer1
;							.EndIf
;							PUSH	ESI
;							CALL	GetNextLevel
;							POP		ESI
;							MOV		EDX,(MNUITEM PTR [ESI]).level
;							MOV		ECX,(MNUITEM PTR [ESI]).nstate
;							or		ECX,MF_STRING
;							.If EAX>EDX
;								PUSH	ECX
;								Invoke CreatePopupMenu
;								MOV		[EBX+4],EAX
;								POP		ECX
;								or		ECX,MF_POPUP
;								Invoke AppendMenu,[EBX],ECX,[EBX+4],addr buffer
;							.ElseIf EAX==EDX
;								Invoke AppendMenu,[EBX],ECX,(MNUITEM PTR [ESI]).itemid,addr buffer
;							.ElseIf EAX
;								Invoke AppendMenu,[EBX],ECX,(MNUITEM PTR [ESI]).itemid,addr buffer
;								MOV		dword PTR [EBX],0
;							.Else
;								Invoke AppendMenu,[EBX],ECX,(MNUITEM PTR [ESI]).itemid,addr buffer
;							.EndIf
;						.EndIf
;						JMP		Nx
;					.EndIf
;				.EndIf
;			.EndIf
;		.EndIf
;		add		ESI,sizeof MNUITEM
;		JMP		@b
;	.EndIf
;	MOV		EAX,hMnu
;	RET
;
;GetNextLevel:
;	add		ESI,sizeof MNUITEM
;	.If [ESI].MNUITEM.itemflag==-1
;		JMP		GetNextLevel
;	.EndIf
;	MOV		EAX,(MNUITEM PTR [ESI]).level
;	RETN
;
;MakeMnuPopup EndP

;MakeMnuBar Proc Uses EBX ESI EDI,lpDlgMem:DWORD
;	Local	nInx:DWORD
;	Local	mii:MENUITEMINFO
;
;	Invoke CreateMenu
;	MOV		hDlgMnu,EAX
;	MOV		ESI,lpDlgMem
;	MOV		ESI,[ESI].DLGHEAD.lpmnu
;	add		ESI,sizeof MNUHEAD
;	MOV		nInx,0
;  @@:
;	MOV		EAX,(MNUITEM PTR [ESI]).itemflag
;	.If EAX
;		.If EAX!=-1
;			MOV		EAX,(MNUITEM PTR [ESI]).level
;			.If !EAX
;				MOV		EDX,(MNUITEM PTR [ESI]).ntype
;				AND		EDX,MFT_RIGHTJUSTIFY
;				or		EDX,MF_STRING
;				Invoke AppendMenu,hDlgMnu,EDX,(MNUITEM PTR [ESI]).itemid,addr [ESI].MNUITEM.itemcaption
;				Invoke MakeMnuPopup,lpDlgMem,nInx
;				.If EAX
;					MOV		mii.hSubMenu,EAX
;					MOV		mii.cbSize,sizeof MENUITEMINFO
;					MOV		mii.fMask,MIIM_SUBMENU
;					Invoke SetMenuItemInfo,hDlgMnu,nInx,TRUE,addr mii
;				.EndIf
;				INC		nInx
;			.EndIf
;		.EndIf
;		add		ESI,sizeof MNUITEM
;		JMP		@b
;	.EndIf
;	RET
;
;MakeMnuBar EndP

ExtractMenu Proc Uses EBX ESI EDI,lpRCMem:DWORD,lpProMem:DWORD
Local nNest			:DWORD
;Local hMem			:DWORD
Local Buffer[256]	:BYTE
Local MaxID			:DWORD

	MOV MaxID,0
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
	MOV EDI,EAX
	PUSH EDI
	;Name / ID
	Invoke GetName,lpProMem,Offset NameBuffer,ADDR [EDI].MNUHEAD.szMenuName,ADDR [EDI].MNUHEAD.MenuID
	MOV EAX,[EDI].MNUHEAD.MenuID
	INC EAX
	MOV MaxID,EAX

	ADD EDI,SizeOf MNUHEAD
	MOV nNest,0
	MOV ESI,lpRCMem
	Invoke GetLoadOptions,ESI
	ADD ESI,EAX
	
	@@:
	;-
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	MOV EBX,EAX
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
	SUB ESI,EBX
  @@:
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szBEGINSHORT
	.EndIf
	.If !EAX
		INC nNest
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szPOPUP
	.If !EAX
		MOV [EDI].MNUITEM.Flag,TRUE
		MOV EAX,nNest
		DEC EAX
		MOV [EDI].MNUITEM.Level,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		Invoke lstrcpy,ADDR [EDI].MNUITEM.szCaption,Offset ThisWord
		CALL SetOptions
		ADD EDI,SizeOf MNUITEM
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szMENUITEM
	.If !EAX
		MOV [EDI].MNUITEM.Flag,TRUE
		MOV EAX,nNest
		DEC EAX
		MOV [EDI].MNUITEM.Level,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szSEPARATOR
		.If !EAX
			MOV WORD PTR [EDI].MNUITEM.szCaption,'-'
			ADD EDI,SizeOf MNUITEM
			JMP @B
		.EndIf
		
;		Invoke lstrcmpi,Offset ThisWord,Offset szMENUBREAK
;		.If !EAX
;			;MOV WORD PTR [EDI].MNUITEM.szCaption,'|'
;			ADD EDI,SizeOf MNUITEM
;			JMP @B
;		.EndIf
		
		Invoke UnQuoteWord,Offset ThisWord
		MOV EBX,Offset ThisWord
		.While WORD PTR [EBX]!='t\' && BYTE PTR [EBX]
			INC EBX
		.EndW
		.If WORD PTR [EBX]=='t\'
			PUSH EBX
			ADD EBX,2
		  NxtKey:
			XOR EAX,EAX
			.If DWORD PTR [EBX]=='fihS'
				ADD EBX,6
				OR [EDI].MNUITEM.Shortcut,100h
				JMP NxtKey
			.ElseIf DWORD PTR [EBX]=='lrtC'
				ADD EBX,5
				OR [EDI].MNUITEM.Shortcut,200h
				JMP NxtKey
			.ElseIf DWORD PTR [EBX]=='+tlA'
				ADD EBX,4
				OR [EDI].MNUITEM.Shortcut,400h
				JMP NxtKey
			.ElseIf WORD PTR [EBX]>='A' && WORD PTR [EBX]<='Z'
				MOVZX EAX,BYTE PTR [EBX]
				OR [EDI].MNUITEM.Shortcut,EAX
			.ElseIf BYTE PTR [EBX]=='F'
				Invoke DecToBin,ADDR [EBX+1]
				ADD EAX,6Fh
				OR [EDI].MNUITEM.Shortcut,EAX
			.EndIf
			POP EBX
			.If EAX
				MOV BYTE PTR [EBX],0
			.Else
				MOV [EDI].MNUITEM.Shortcut,EAX
			.EndIf
		.EndIf
		Invoke lstrcpy,ADDR [EDI].MNUITEM.szCaption,Offset ThisWord
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		;Name / ID
		Invoke GetName,lpProMem,Offset ThisWord,ADDR [EDI].MNUITEM.szName,ADDR [EDI].MNUITEM.ID
		MOV ECX,[EDI].MNUITEM.ID
		.If ECX>=MaxID
			INC ECX
			MOV MaxID,ECX
		.EndIf
		CALL SetOptions
		ADD EDI,SizeOf MNUITEM
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szEND
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szENDSHORT
	.EndIf
	.If !EAX
		DEC nNest
		JE Ex
		JMP @B
	.EndIf
  Ex:
	POP EDI
	MOV EAX,MaxID
	MOV [EDI].MNUHEAD.NextMenuItemID,EAX
	LEA EAX,[EDI].MNUHEAD.szMenuName
	.If BYTE PTR [EAX]==0
		Invoke BinToDec,[EDI].MNUHEAD.MenuID,ADDR Buffer
		LEA EAX,Buffer
	.EndIf
	Invoke AddToOthersTree,6,EAX,EDI
	MOV [EDI].MNUHEAD.hTreeItem,EAX

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

	SetOptions:
	;---------
	XOR EBX,EBX
	.While BYTE PTR [ESI] && BYTE PTR [ESI]!=0Dh
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szCHECKED
		.If !EAX
			OR EBX,MFS_CHECKED
		.EndIf
		
		Invoke lstrcmpi,Offset ThisWord,Offset szGRAYED
		.If !EAX
			OR EBX,MFS_GRAYED
		.EndIf
		
		Invoke lstrcmpi,Offset ThisWord,Offset szINACTIVE
		.If !EAX
		.EndIf
		Invoke lstrcmpi,Offset ThisWord,Offset szMENUBARBREAK
		.If !EAX
		.EndIf
		Invoke lstrcmpi,Offset ThisWord,Offset szMENUBREAK
		.If !EAX
			MOV [EDI].MNUITEM.nType,MFT_MENUBREAK
		.EndIf
	.EndW
	MOV [EDI].MNUITEM.nState,EBX
	RETN

ExtractMenu EndP

ExtractMenuEx Proc Uses EBX ESI EDI,lpRCMem:DWORD,lpProMem:DWORD
Local nNest			:DWORD
Local hMem			:DWORD
Local Buffer[256]	:BYTE
Local MaxID			:DWORD

	MOV MaxID,0
	Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
	MOV EDI,EAX
	PUSH EDI
	;Name / ID
	Invoke GetName,lpProMem,Offset NameBuffer,ADDR [EDI].MNUHEAD.szMenuName,ADDR [EDI].MNUHEAD.MenuID
	MOV EAX,[EDI].MNUHEAD.MenuID
	INC EAX
	MOV MaxID,EAX
	
	;PrintDec EaX
	ADD EDI,SizeOf MNUHEAD
	MOV nNest,0
	MOV ESI,lpRCMem
	Invoke GetLoadOptions,ESI
	ADD ESI,EAX
	
	@@:
	;-
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	MOV EBX,EAX
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
	SUB ESI,EBX
  @@:
	Invoke GetWord,Offset ThisWord,ESI
	ADD ESI,EAX
	Invoke lstrcmpi,Offset ThisWord,Offset szBEGIN
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szBEGINSHORT
	.EndIf
	.If !EAX
		INC nNest
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szMENUITEM
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szPOPUP
	.EndIf
	.If !EAX
		MOV [EDI].MNUITEM.Flag,TRUE
		MOV EAX,nNest
		DEC EAX
		MOV [EDI].MNUITEM.Level,EAX
		Invoke GetWord,Offset ThisWord,ESI
		ADD ESI,EAX
		Invoke UnQuoteWord,Offset ThisWord
		MOV EBX,Offset ThisWord
		.While WORD PTR [EBX]!='t\' && BYTE PTR [EBX]
			INC EBX
		.EndW
		.If WORD PTR [EBX]=='t\'
			PUSH EBX
			ADD EBX,2
			
			;PrintStringByAddr EBX
			
			NxtKey:
			;------
			XOR EAX,EAX
			.If dword PTR [EBX]=='fihS'
				ADD EBX,6
				OR [EDI].MNUITEM.Shortcut,100h
				JMP NxtKey
			.ElseIf dword PTR [EBX]=='lrtC'
				ADD EBX,5
				OR [EDI].MNUITEM.Shortcut,200h
				JMP NxtKey
			.ElseIf dword PTR [EBX]=='+tlA'
				ADD EBX,4
				OR [EDI].MNUITEM.Shortcut,400h
				JMP NxtKey
				
			.ElseIf (WORD PTR [EBX]>='A' && WORD PTR [EBX]<='Z') 
				MOVZX EAX,BYTE PTR [EBX]
				OR [EDI].MNUITEM.Shortcut,EAX
				
			;V5.0.1.6
			.ElseIf BYTE PTR [EBX]=='T' && BYTE PTR [EBX+1]=='A' && BYTE PTR [EBX+2]=='B'
				XOR EAX,EAX
				MOV AL,VK_TAB
				OR [EDI].MNUITEM.Shortcut,EAX
				
			.ElseIf BYTE PTR [EBX]=='F'
				Invoke DecToBin,ADDR [EBX+1]
				ADD EAX,6Fh
				OR [EDI].MNUITEM.Shortcut,EAX
			.EndIf
			
			POP EBX
			.If EAX
				MOV BYTE PTR [EBX],0
			.Else
				MOV [EDI].MNUITEM.Shortcut,EAX
			.EndIf
			
			;MOV EAX,[EDI].MNUITEM.Shortcut
			;PrintHex EAX
			
		.EndIf
		Invoke lstrcpy,ADDR [EDI].MNUITEM.szCaption,Offset ThisWord
		.If BYTE PTR [ESI] && BYTE PTR [ESI]!=0Dh
			Invoke GetWord,Offset ThisWord,ESI
			ADD ESI,EAX
			;Name / ID
			Invoke GetName,lpProMem,Offset ThisWord,ADDR [EDI].MNUITEM.szName,ADDR [EDI].MNUITEM.ID
			
			MOV ECX,[EDI].MNUITEM.ID
			.If ECX>=MaxID
				INC ECX
				MOV MaxID,ECX
			.EndIf
			CALL SetOptions
		.EndIf
		ADD EDI,SizeOf MNUITEM
		JMP @B
	.EndIf
	Invoke lstrcmpi,Offset ThisWord,Offset szEND
	.If EAX
		Invoke lstrcmpi,Offset ThisWord,Offset szENDSHORT
	.EndIf
	.If !EAX
		DEC nNest
		JE Ex
		JMP @B
	.EndIf
  	
  	Ex:
  	;-
  	POP EDI
	MOV EAX,MaxID
	MOV [EDI].MNUHEAD.NextMenuItemID,EAX

	LEA EAX,[EDI].MNUHEAD.szMenuName
	.If BYTE PTR [EAX]==0
		Invoke BinToDec,[EDI].MNUHEAD.MenuID,ADDR Buffer
		LEA EAX,Buffer
	.EndIf
	Invoke AddToOthersTree,6,EAX,EDI
	MOV [EDI].MNUHEAD.hTreeItem,EAX

	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

	SetOptions:
	;---------
	.If BYTE PTR [ESI] && BYTE PTR [ESI]!=0Dh
		;Type
		Invoke GetStyle,ESI,Offset MenuTypeDefinition
		.If EDX
			TEST EDX,MFT_SEPARATOR
			.If !ZERO?
				XOR EDX,MFT_SEPARATOR
				MOV WORD PTR [EDI].MNUITEM.szCaption,'-'
				
			.EndIf
		.Else	;String (NOT Numerical)
			Invoke GetWord,Offset ThisWord,ESI
			PUSH EAX
			Invoke lstrcmpi,Offset ThisWord,Offset szSEPARATOR
			.If !EAX
				MOV EDX,MFT_SEPARATOR
				MOV WORD PTR [EDI].MNUITEM.szCaption,'-'
			.Else
				Invoke lstrcmpi,Offset ThisWord,Offset szMENUBREAK
				.If !EAX
					MOV EDX,MFT_MENUBREAK
					;MOV WORD PTR [EDI].MNUITEM.szCaption,'|'
				.Else
					XOR EDX,EDX
				.EndIf
			.EndIf
			POP EAX
		.EndIf
		MOV [EDI].MNUITEM.nType,EDX
		ADD ESI,EAX
	.EndIf
	
	
	.If BYTE PTR [ESI] && BYTE PTR [ESI]!=0Dh
		;State
		Invoke GetStyle,ESI,Offset MenuStateDefinition
		MOV [EDI].MNUITEM.nState,EDX
		ADD ESI,EAX
	.EndIf
	.If BYTE PTR [ESI] && BYTE PTR [ESI]!=0Dh
		;HelpID
		Invoke GetNum,lpProMem
	.EndIf
	RETN

ExtractMenuEx EndP

MakeMenuItemCaption Proc Uses ESI EDI lpMenuItem:DWORD, lpBuffer:DWORD
	Invoke RtlZeroMemory,lpBuffer,256
	MOV EDI,lpMenuItem
	MOV ESI,[EDI].MNUITEM.Level
	.If ESI
		Invoke lstrcpy,lpBuffer,Offset szThreeDots
		DEC ESI
		@@:
		.If ESI
			Invoke lstrcat,lpBuffer,Offset szThreeDots
			DEC ESI
			JMP @B
		.EndIf
	.EndIf
	Invoke lstrcat,lpBuffer,ADDR [EDI].MNUITEM.szCaption
	RET
MakeMenuItemCaption EndP

SaveString Proc Uses ECX ESI EDI,lpDest:DWORD,lpSrc:DWORD
	MOV ESI,lpSrc
	MOV EDI,lpDest
	DEC ESI
	DEC EDI
	MOV ECX,-1
  @@:
	INC ECX
	INC ESI
	INC EDI
	MOV AL,[ESI]
	MOV [EDI],AL
	OR AL,AL
	JNE @B
	MOV EAX,ECX
	RET
SaveString EndP

GetStringFromAccel Proc Uses ESI EDI,nAccel:DWORD,lpDest:DWORD
	MOV ESI,nAccel
	MOV EDI,lpDest
	
	TEST ESI,200h
	.If !ZERO?
		Invoke SaveString,EDI,Offset szCtrlPlus
		ADD EDI,EAX
	.EndIf
	
	TEST ESI,100h
	.If !ZERO?
		Invoke SaveString,EDI,Offset szShiftPlus
		ADD EDI,EAX
	.EndIf

	TEST ESI,400h
	.If !ZERO?
		Invoke SaveString,EDI,Offset szAltPlus
		ADD EDI,EAX
	.EndIf

;	SHR ESI,9
;	.If CARRY?
;		Invoke SaveString,EDI,Offset szShiftPlus
;		ADD EDI,EAX
;	.EndIf
;	SHR ESI,1
;	.If CARRY?
;		Invoke SaveString,EDI,Offset szCtrlPlus
;		ADD EDI,EAX
;	.EndIf
;	SHR ESI,1
;	.If CARRY?
;		Invoke SaveString,EDI,Offset szAltPlus
;		ADD EDI,EAX
;	.EndIf
	
;	PrintHex nAccel
	MOV EAX,nAccel
	MOVZX EAX,AL
	
	.If EAX==VK_TAB
		
		MOV BYTE PTR [EDI],'T'
		MOV BYTE PTR [EDI+1],'A'
		MOV BYTE PTR [EDI+2],'B'
		ADD EDI,3
		
	.ElseIf EAX>='A' && EAX<='Z'
		
		STOSB
		
	.ElseIf EAX>=VK_F1 && EAX<=VK_F12
		
		MOV BYTE PTR [EDI],'F'
		INC EDI
		SUB EAX,VK_F1-1
		Invoke BinToDec,EAX,EDI
		Invoke lstrlen,EDI
		LEA EDI,[EDI+EAX]
		
	.EndIf

;	.If EAX>=VK_F1 && EAX<=VK_F12
;		MOV BYTE PTR [EDI],'F'
;		INC EDI
;		SUB EAX,VK_F1-1
;		Invoke BinToDec,EAX,EDI
;		Invoke lstrlen,EDI
;		LEA EDI,[EDI+EAX]
;	.Else
;		STOSB
;	.EndIf

	MOV BYTE PTR [EDI],0
	MOV EAX,EDI
	SUB EAX,lpDest
	RET
GetStringFromAccel EndP

SetColumnsWidth Proc hList:DWORD
Local Rect	:RECT

	Invoke SendMessage, hList, LVM_SETCOLUMNWIDTH, 1, LVSCW_AUTOSIZE
	Invoke SendMessage, hList, LVM_GETCOLUMNWIDTH, 1, 0
	PUSH EAX
	Invoke GetWindowRect,hList,ADDR Rect
	
	Invoke GetSystemMetrics,SM_CXBORDER
	MOV EDX,EAX
	SHL EDX,1	;Twice
	PUSH EDX
	
	Invoke GetWindowLong,hList,GWL_STYLE
	AND EAX,WS_VSCROLL
	.If EAX	;i.e. If VSCROLL is present, take its width into account
		Invoke GetSystemMetrics,SM_CXVSCROLL
	.Else
		XOR EAX,EAX
	.EndIf
	
	POP EDX
	ADD EDX,EAX
	ADD EDX,4	;Emperical
	
	MOV ECX,Rect.right
	SUB ECX,Rect.left
	POP EAX
	SUB ECX,EAX
	SUB ECX,EDX
	Invoke SendMessage, hList, LVM_SETCOLUMNWIDTH, 0, ECX

	RET
SetColumnsWidth EndP

InsertNewMenuItem Proc Uses EDI EBX hList:DWORD, lpItem:DWORD, iItem:DWORD
Local lvi 			:LVITEM
Local Buffer[256]	:BYTE
	
	MOV EDI,lpItem

	MOV [EDI].MNUITEM.Flag,TRUE

	MOV EBX,iItem
	MOV lvi.imask,LVIF_TEXT OR LVIF_PARAM; OR LVIF_STATE
	MOV lvi.cchTextMax,256
	
	Invoke MakeMenuItemCaption,EDI,ADDR Buffer
	MOV lvi.lParam,EDI
	MOV lvi.iSubItem,0
	MOV lvi.iItem,EBX
	LEA EAX,Buffer
	MOV lvi.pszText,EAX
	Invoke SendMessage,hList,LVM_INSERTITEM,0,ADDR lvi
	
	Invoke GetStringFromAccel,[EDI].MNUITEM.Shortcut,ADDR Buffer
	Invoke SetItemText,hList,EBX,1,ADDR Buffer
	RET
InsertNewMenuItem EndP

DeleteMenuDefines Proc Uses EDI lpMenuData:DWORD
	MOV EDI,lpMenuData
	Invoke DeleteDefine,ADDR [EDI].MNUHEAD.szMenuName
	ADD EDI,SizeOf MNUHEAD
	.While [EDI].MNUITEM.Flag
		Invoke DeleteDefine,ADDR [EDI].MNUITEM.szName
		ADD EDI,SizeOf MNUITEM
	.EndW
	RET
DeleteMenuDefines EndP

MenuEditDialogProc Proc Uses EBX EDI ESI hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Buffer[256]	:BYTE
Local tvi			:TVITEM
Local lvc			:LV_COLUMN
Local hList			:DWORD
Local MaxID			:DWORD

	.If uMsg == WM_INITDIALOG
		Invoke SendDlgItemMessage,hWnd,IDC_EDTMENUNAME,EM_LIMITTEXT,31,0
		Invoke SendDlgItemMessage,hWnd,IDC_EDTITEMCAPTION,EM_LIMITTEXT,31,0
		Invoke SendDlgItemMessage,hWnd,IDC_EDTITEMNAME,EM_LIMITTEXT,31,0
		
		Invoke LoadImage,hInstance,IDB_ARROWUP,IMAGE_BITMAP,0,0,LR_DEFAULTSIZE + LR_LOADMAP3DCOLORS
		MOV hArrowUp,EAX
		Invoke SendDlgItemMessage,hWnd,IDC_BTNU,BM_SETIMAGE,IMAGE_BITMAP,EAX
		
		Invoke LoadImage,hInstance,IDB_ARROWDN,IMAGE_BITMAP,0,0,LR_DEFAULTSIZE + LR_LOADMAP3DCOLORS
		MOV hArrowUp,EAX
		Invoke SendDlgItemMessage,hWnd,IDC_BTND,BM_SETIMAGE,IMAGE_BITMAP,EAX
		
		Invoke LoadImage,hInstance,IDB_ARROWLT,IMAGE_BITMAP,0,0,LR_DEFAULTSIZE + LR_LOADMAP3DCOLORS
		MOV hArrowLt,EAX
		Invoke SendDlgItemMessage,hWnd,IDC_BTNL,BM_SETIMAGE,IMAGE_BITMAP,EAX
		
		Invoke LoadImage,hInstance,IDB_ARROWRT,IMAGE_BITMAP,0,0,LR_DEFAULTSIZE + LR_LOADMAP3DCOLORS
		MOV hArrowRt,EAX
		Invoke SendDlgItemMessage,hWnd,IDC_BTNR,BM_SETIMAGE,IMAGE_BITMAP,EAX
		
		.If lParam	;Existing Menu
			;MOV EDI,lParam
			;Let's allocate some temporary memory
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
			MOV EDI,EAX
			;Let's copy from Real Menu memory to temporary
			Invoke RtlMoveMemory,EDI, lParam,64*1024
			Invoke SetWindowLong,hWnd,GWL_USERDATA,EDI
			MOV EDX,Offset szMenu
		.Else	;New Menu
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
			MOV EDI,EAX
			Invoke SetWindowLong,hWnd,GWL_USERDATA,EDI
			Invoke lstrcpy,ADDR [EDI].MNUHEAD.szMenuName,CTEXT("IDM_MNU")
			MOV [EDI].MNUHEAD.MenuID,1000
			MOV [EDI].MNUHEAD.NextMenuItemID,1001
			MOV EDX,Offset szNewMenu
		.EndIf
		
		Invoke SetWindowText,hWnd,EDX
		
		PUSH EDI
		Invoke GetDlgItem,hWnd,IDC_LSTMNU
		MOV ESI,EAX
		Invoke SendMessage,ESI,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT
		MOV lvc.imask,LVCF_WIDTH OR LVCF_FMT
		MOV lvc.fmt,LVCFMT_LEFT
		MOV lvc.cchTextMax,MAX_PATH
		MOV lvc.lx,180
		Invoke SendMessage, ESI, LVM_INSERTCOLUMN, 0, ADDR lvc
		
		MOV lvc.fmt,LVCFMT_RIGHT
		MOV lvc.lx,80
		Invoke SendMessage, ESI, LVM_INSERTCOLUMN, 1, ADDR lvc
		
		Invoke SetDlgItemText,hWnd,IDC_EDTMENUNAME,ADDR [EDI].MNUHEAD.szMenuName
		Invoke BinToDec,[EDI].MNUHEAD.MenuID,ADDR Buffer
		Invoke SetDlgItemText,hWnd,IDC_EDTMENUID,ADDR Buffer
		;Invoke BinToDec,[EDI].MNUHEAD.StartID,ADDR Buffer
		;Invoke SetDlgItemText,hWnd,IDC_EDTSTARTID,ADDR Buffer
		
		ADD EDI,SizeOf MNUHEAD
		
		XOR EBX,EBX
		.While [EDI].MNUITEM.Flag
			Invoke InsertNewMenuItem,ESI,EDI,EBX
			ADD EDI,SizeOf MNUITEM
			INC EBX
		.EndW
		
		Invoke lstrcpy,ADDR [EDI].MNUITEM.szName,Offset szIDM_
		POP EAX
		MOV ECX,[EAX].MNUHEAD.NextMenuItemID
		MOV [EDI].MNUITEM.ID,ECX
		INC [EAX].MNUHEAD.NextMenuItemID
		Invoke InsertNewMenuItem,ESI,EDI,EBX
		
		Invoke SetColumnsWidth,ESI
		Invoke SelectListItem,ESI,0
		
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		MOV EDX,EAX
		SHR EDX,16
		AND EAX,0FFFFh
		.If EDX==BN_CLICKED
			.If EAX==2	;OK
				MOV MaxID,0
				
				Invoke GetDlgItem,hWnd,IDC_LSTMNU
				MOV hList,EAX
				
				;Let's make some checks
				;a)Check menu item levels
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				MOV EBX,EAX
				XOR ESI,ESI
				.While TRUE
					.If ESI==EBX
						.Break
					.EndIf
					
					Invoke GetItemParameter,hList,ESI;,0
					MOV EDX,EAX
					
					.If ESI==0	;i.e this is the first menu item
						.If [EDX].MNUITEM.Level!=0
							MOV ESI,-1
							JMP MenuItemLevelError
						.EndIf
					.EndIf
					
					MOV ECX,[EDX].MNUITEM.Level
					INC ECX
					.If [EDX+SizeOf MNUITEM].MNUITEM.Level>ECX
						JMP MenuItemLevelError
					.EndIf
					
					ADD EDI,SizeOf MNUITEM
					INC ESI
				.EndW
				;End Of Tests
				
				;Let's delete all definitions related to this menu if it is NOT a new menu
				Invoke GetWindowText,hWnd,ADDR Buffer,256
				Invoke lstrcmp,ADDR Buffer,Offset szNewMenu
				.If EAX	;i.e. This is NOT a new menu
					Invoke SendMessage, hOthersTree, TVM_GETNEXTITEM,TVGN_CARET,0
					Invoke GetTreeItemParameter,hOthersTree,EAX
					Invoke DeleteMenuDefines,EAX
				.EndIf
				
				;New Memory (The third one)
				Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,64*1024
				MOV EDI,EAX
				
				;Get The Second temp memory (The one we used so far) 
				Invoke GetWindowLong,hWnd,GWL_USERDATA
				
				Invoke RtlMoveMemory,EDI,EAX,SizeOf MNUHEAD			
				Invoke GetDlgItemText,hWnd,IDC_EDTMENUNAME,ADDR [EDI].MNUHEAD.szMenuName,32
				Invoke GetDlgItemText,hWnd,IDC_EDTMENUID,ADDR Buffer,256
				.If Buffer[0]!="0"	;Points to a null-terminated string that contains the name of the menu resource
					;LoadMenu,hInstance,lpMenuName
					;lpMenuName:Points to a null-terminated string that contains the ****NAME**** of the menu resource. Alternatively, this parameter can consist of the resource identifier in the low-order word and zero in the high-order word. To create this value, use the MAKEINTRESOURCE macro.
					;Therefore if it is '0' #define should not exist in the script
					Invoke AddOrReplaceDefine,ADDR [EDI].MNUHEAD.szMenuName,ADDR Buffer
				.EndIf
				Invoke DecToBin,ADDR Buffer
				MOV [EDI].MNUHEAD.MenuID,EAX
				INC EAX
				MOV MaxID,EAX
				
				
				Invoke GetWindowText,hWnd,ADDR Buffer,256
				Invoke lstrcmp,ADDR Buffer,Offset szNewMenu
				.If !EAX	;i.e. This is a new menu
					LEA EBX,[EDI].MNUHEAD.szMenuName
					.If BYTE PTR [EBX]==0
						Invoke BinToDec,[EDI].MNUHEAD.MenuID,ADDR Buffer
						LEA EBX,Buffer
					.EndIf
					Invoke AddToOthersTree,6,EBX,EDI
					MOV [EDI].MNUHEAD.hTreeItem,EAX
				.Else
					MOV tvi._mask,TVIF_TEXT
					MOV tvi.cchTextMax,256
					LEA EBX,[EDI].MNUHEAD.szMenuName
					.If BYTE PTR [EBX]==0
						Invoke BinToDec,[EDI].MNUHEAD.MenuID,ADDR Buffer
						LEA EBX,Buffer
					.EndIf
					MOV tvi.pszText,EBX
					M2M tvi.hItem,[EDI].MNUHEAD.hTreeItem
					Invoke SendMessage,hOthersTree,TVM_SETITEM,0,ADDR tvi
				.EndIf
				
				PUSH EDI
				
				ADD EDI,SizeOf MNUHEAD
				
				Invoke SendMessage,hList,LVM_GETITEMCOUNT,0,0
				MOV EBX,EAX
				XOR ESI,ESI
				.While TRUE
					.If ESI==EBX
						.Break
					.EndIf
					Invoke GetItemParameter,hList,ESI
					;MOV EDX,EAX
					.If BYTE PTR ([EAX].MNUITEM.szCaption)!=0
						Invoke RtlMoveMemory,EDI,EAX,SizeOf MNUITEM
						MOV EAX, [EDI].MNUITEM.ID
						.If EAX>=MaxID
							INC EAX
							MOV MaxID,EAX
						.EndIf
						
						Invoke BinToDec,[EDI].MNUITEM.ID,ADDR Buffer
						Invoke AddOrReplaceDefine,ADDR [EDI].MNUITEM.szName,ADDR Buffer
						ADD EDI,SizeOf MNUITEM
					.EndIf
					INC ESI
				.EndW
				
				;Get The Second temp memory (The one we used so far) 
				Invoke GetWindowLong,hWnd,GWL_USERDATA
				Invoke HeapFree,hMainHeap,0,EAX
				
				Invoke EnableAllDockWindows,TRUE
				Invoke DeleteObject,hArrowUp
				Invoke DeleteObject,hArrowDn
				Invoke DeleteObject,hArrowLt
				Invoke DeleteObject,hArrowRt
				
				Invoke SetRCModified,TRUE
				
				POP EDI
				
				MOV EAX,MaxID
				MOV [EDI].MNUHEAD.NextMenuItemID,EAX
				
				;Let's return the Third Temporary memory so that Caller copies temp to real and then frees temp
				Invoke EndDialog,hWnd,EDI
				JMP ExitMenuProc
				
				;-----------------------------------------------------------								
				MenuItemLevelError:
				ADD ESI,2
				Invoke lstrcpy,ADDR Buffer,Offset szTheLevelOfMenuItem	;"The level of menu item "
				Invoke lstrlen,Offset szTheLevelOfMenuItem
				LEA EDX,Buffer
				ADD EDX,EAX
				Invoke BinToDec,ESI,EDX
				Invoke lstrcat,ADDR Buffer,Offset szIsNotCorrect		;" is not correct."
				Invoke MessageBox,hWnd,ADDR Buffer,Offset szAppName,MB_ICONERROR or MB_TASKMODAL
				JMP ExitMenuProc
				
			.ElseIf EAX== 3	;Cancel
				Invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
				
			.ElseIf (EAX>=IDC_BTNINSERT && EAX<=IDC_RBNOWNERDRAW) || EAX==35 || EAX==36 || EAX==37	;<-MF_MENUBREAK, MF_RIGHTJUSTIFY, MF_DEFAULT 
				PUSH EAX
				Invoke GetDlgItem,hWnd,IDC_LSTMNU
				MOV ESI,EAX	;ESI == hList
				Invoke SendMessage,ESI, LVM_GETNEXTITEM, -1, LVNI_FOCUSED; + LVIS_SELECTED;
				MOV EBX,EAX	;EBX is selected item
				.If EBX!=-1 ;i.e there is selection
					Invoke GetItemParameter,ESI,EBX
					MOV EDI,EAX
				.EndIf
				POP EAX
				
				.If EAX==IDC_BTNINSERT	;Here we don't mind whether there is selection in the list or not
					;Get the param of the new item
					Invoke GetWindowLong,hWnd,GWL_USERDATA
					MOV EDI,EAX
					;---------------------------					
					PUSH [EDI].MNUHEAD.NextMenuItemID
					INC [EDI].MNUHEAD.NextMenuItemID
					;---------------------------
					
					ADD EDI,SizeOf MNUHEAD
					
					.While [EDI].MNUITEM.Flag
						ADD EDI,SizeOf MNUITEM
					.EndW
					MOV [EDI].MNUITEM.Flag,TRUE
					
					;---------------------------
					Invoke lstrcpy,ADDR [EDI].MNUHEAD.szMenuName,Offset szIDM_
					POP EAX
					MOV [EDI].MNUHEAD.MenuID,EAX
					;---------------------------					
					
					.If EBX==-1
						MOV EBX,0
					.EndIf
					Invoke InsertNewMenuItem,ESI,EDI,EBX
					Invoke SetColumnsWidth,ESI
					Invoke SelectListItem,ESI,EBX;,0
					
				.ElseIf EBX!=-1
					.If EAX==IDC_CHKCHECKED
						Invoke SendDlgItemMessage,hWnd,IDC_CHKCHECKED,BM_GETCHECK,0,0
						.If EAX==BST_CHECKED
							OR (MNUITEM PTR [EDI]).nState,MF_CHECKED
						.Else
							AND (MNUITEM PTR [EDI]).nState,-1 XOR MF_CHECKED
						.EndIf
					.ElseIf EAX==IDC_CHKGRAYED
						Invoke SendDlgItemMessage,hWnd,IDC_CHKGRAYED,BM_GETCHECK,0,0
						.If EAX==BST_CHECKED
							OR (MNUITEM PTR [EDI]).nState,MF_GRAYED
						.Else
							AND (MNUITEM PTR [EDI]).nState,-1 XOR MF_GRAYED
						.EndIf
					.ElseIf EAX==IDC_CHKDISABLED
						Invoke SendDlgItemMessage,hWnd,IDC_CHKDISABLED,BM_GETCHECK,0,0
						.If EAX==BST_CHECKED
							OR (MNUITEM PTR [EDI]).nState,MF_DISABLED
						.Else
							AND (MNUITEM PTR [EDI]).nState,-1 XOR MF_DISABLED
						.EndIf
					.ElseIf EAX==IDC_RBNSTRING
						AND (MNUITEM PTR [EDI]).nType,-1 XOR (MFT_BITMAP OR MFT_OWNERDRAW)
					.ElseIf EAX==IDC_RBNBITMAP
						AND (MNUITEM PTR [EDI]).nType,-1 XOR (MFT_BITMAP OR MFT_OWNERDRAW)
						OR (MNUITEM PTR [EDI]).nType,MFT_BITMAP
					.ElseIf EAX==IDC_RBNOWNERDRAW
						AND (MNUITEM PTR [EDI]).nType,-1 XOR (MFT_BITMAP OR MFT_OWNERDRAW)
						OR (MNUITEM PTR [EDI]).nType,MFT_OWNERDRAW
						
					.ElseIf EAX==35	;MENUBREAK
						Invoke SendDlgItemMessage,hWnd,35,BM_GETCHECK,0,0
						.If EAX==BST_CHECKED
							OR (MNUITEM PTR [EDI]).nType,MF_MENUBREAK
						.Else
							AND (MNUITEM PTR [EDI]).nType,-1 XOR MF_MENUBREAK
						.EndIf
						
						
					.ElseIf EAX==36	;MF_RIGHTJUSTIFY
						Invoke SendDlgItemMessage,hWnd,36,BM_GETCHECK,0,0
						.If EAX==BST_CHECKED
							OR (MNUITEM PTR [EDI]).nType,MF_RIGHTJUSTIFY
						.Else
							AND (MNUITEM PTR [EDI]).nType,-1 XOR MF_RIGHTJUSTIFY
						.EndIf
						
					.ElseIf EAX==37	;MF_DEFAULT
						Invoke SendDlgItemMessage,hWnd,37,BM_GETCHECK,0,0
						.If EAX==BST_CHECKED
							OR (MNUITEM PTR [EDI]).nType,MF_DEFAULT
						.Else
							AND (MNUITEM PTR [EDI]).nType,-1 XOR MF_DEFAULT
						.EndIf
						
						
						
						
					.ElseIf EAX==IDC_BTNL
						MOV EAX,(MNUITEM PTR [EDI]).Level
						.If EAX
							DEC (MNUITEM PTR [EDI]).Level
							Invoke MakeMenuItemCaption,EDI,ADDR Buffer
							Invoke SetItemText,ESI,EBX,0,ADDR Buffer
						.EndIf
					.ElseIf EAX==IDC_BTNR
						MOV EAX,(MNUITEM PTR [EDI]).Level
						.If EAX<5
							INC (MNUITEM PTR [EDI]).Level
							Invoke MakeMenuItemCaption,EDI,ADDR Buffer
							Invoke SetItemText,ESI,EBX,0,ADDR Buffer
						.EndIf
					.ElseIf EAX==IDC_BTNU
						.If EBX	;i.e this is not item 0
							Invoke SendMessage,ESI,LVM_DELETEITEM,EBX,0
							DEC EBX
							Invoke InsertNewMenuItem,ESI,EDI,EBX
							Invoke SelectListItem,ESI,EBX;,0
						.EndIf
					.ElseIf EAX==IDC_BTND
						Invoke SendMessage,ESI,LVM_GETITEMCOUNT,0,0
						.If EAX
							DEC EAX
							.If EAX && EBX!=EAX
								Invoke SendMessage,ESI,LVM_DELETEITEM,EBX,0
								INC EBX
								Invoke InsertNewMenuItem,ESI,EDI,EBX
								Invoke SelectListItem,ESI,EBX;,0
							.EndIf
						.EndIf
					.ElseIf EAX==IDC_BTNDELETE
						Invoke SendMessage,ESI,LVM_DELETEITEM,EBX,0
						Invoke RtlZeroMemory,EDI,SizeOf MNUITEM
						
						Invoke SendMessage,ESI,LVM_GETITEMCOUNT,0,0
						.If !EAX
							Invoke SendMessage,hWnd,WM_COMMAND, (BN_CLICKED SHL 16) OR IDC_BTNINSERT,0
						.Else
							.If EBX
								DEC EBX
							.EndIf								
							Invoke SelectListItem,ESI,EBX;,0
							Invoke SetColumnsWidth,ESI
						.EndIf
					.EndIf
				.EndIf
			.EndIf
		.ElseIf EDX==EN_CHANGE
			MOV ESI,EAX
			Invoke GetDlgItem,hWnd,IDC_LSTMNU
			MOV EBX,EAX
			Invoke SendMessage,EBX,LVM_GETNEXTITEM, -1, LVNI_FOCUSED; + LVIS_SELECTED;
			.If EAX!=-1 ;i.e there is selection
				PUSH EAX
				Invoke GetItemParameter,EBX,EAX;,0
				MOV EDI,EAX
				MOV EAX,ESI
				POP ESI
				.If EAX==IDC_EDTITEMCAPTION
					Invoke GetDlgItemText,hWnd,IDC_EDTITEMCAPTION,ADDR [EDI].MNUITEM.szCaption,256
					Invoke MakeMenuItemCaption,EDI,ADDR Buffer
					Invoke SetItemText,EBX,ESI,0,ADDR Buffer
					
					;Thank JimG i.e. Editing caption of last menu item, add a new menu item at the end
					Invoke GetDlgItem,hWnd,IDC_EDTITEMCAPTION
					PUSH EAX
					Invoke GetFocus
					POP ECX
					.If EAX==ECX	;i.e. user is editing the caption
					
						Invoke SendMessage,EBX,LVM_GETITEMCOUNT,0,0
						DEC EAX
						.If EAX==ESI	;i.e. this is the last item if the listview
							
							;Get the param of the new item
							Invoke GetWindowLong,hWnd,GWL_USERDATA
							MOV EDI,EAX
							;---------------------------					
							PUSH [EDI].MNUHEAD.NextMenuItemID
							INC [EDI].MNUHEAD.NextMenuItemID
							;---------------------------
							
							ADD EDI,SizeOf MNUHEAD
							
							.While [EDI].MNUITEM.Flag
								ADD EDI,SizeOf MNUITEM
							.EndW
							MOV [EDI].MNUITEM.Flag,TRUE
							
							;---------------------------
							Invoke lstrcpy,ADDR [EDI].MNUHEAD.szMenuName,Offset szIDM_
							POP EAX
							MOV [EDI].MNUHEAD.MenuID,EAX
							;---------------------------					
							
							INC ESI
							Invoke InsertNewMenuItem,EBX,EDI,ESI
							Invoke SetColumnsWidth,EBX
							
						.EndIf
						
					.EndIf
					
				.ElseIf EAX==IDC_EDTITEMNAME
					Invoke GetDlgItemText,hWnd,IDC_EDTITEMNAME,ADDR [EDI].MNUITEM.szName,256
					
				.ElseIf EAX==IDC_EDTITEMID
					Invoke GetDlgItemText,hWnd,IDC_EDTITEMID,ADDR Buffer,256
					Invoke DecToBin,ADDR Buffer
					MOV [EDI].MNUITEM.ID,EAX
					
					;Do we need to Increase NextMenuItemID ?
					Invoke GetDlgItem,hWnd,IDC_EDTITEMID
					PUSH EAX
					Invoke GetFocus
					POP ECX
					.If EAX==ECX	;i.e. user is editing the ID
						Invoke GetWindowLong,hWnd,GWL_USERDATA
						MOV ECX,[EDI].MNUITEM.ID
						.If ECX>=[EAX].MNUHEAD.NextMenuItemID
							INC ECX
							MOV [EAX].MNUHEAD.NextMenuItemID,ECX
						.EndIf
					.EndIf
					
				.ElseIf EAX==IDC_HOTMENU
					Invoke SendDlgItemMessage,hWnd,IDC_HOTMENU,HKM_GETHOTKEY,0,0
					;.If AL	;i.e not only Ctrl, Alt etc but a letter also 
						MOV (MNUITEM PTR [EDI]).Shortcut,EAX
						MOV ECX,EAX
						Invoke GetStringFromAccel,ECX,ADDR Buffer
						Invoke SetItemText,EBX,ESI,1,ADDR Buffer
						Invoke SetColumnsWidth,EBX
					;.EndIf
				.EndIf
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_NOTIFY
		Invoke GetDlgItem,hWnd,IDC_LSTMNU
		MOV ESI,EAX
		MOV EBX,lParam
		.If [EBX].NMHDR.hwndFrom==ESI
			.If [EBX].NMHDR.code ==LVN_ITEMCHANGED
				.If [EBX].NM_LISTVIEW.uNewState==3 ;i.e focus and selected
					;---------------------------------------------------------
					MOV EDI,[EBX].NM_LISTVIEW.lParam
					
					;Important so that IDC_EDTITEMCAPTION does not have the focus when WM_SETTEXT ias sent to it
					Invoke SetFocus,ESI
					
					Invoke SendDlgItemMessage,hWnd,IDC_EDTITEMCAPTION,WM_SETTEXT,0,ADDR [EDI].MNUITEM.szCaption
					Invoke SendDlgItemMessage,hWnd,IDC_HOTMENU,HKM_SETHOTKEY,(MNUITEM PTR [EDI]).Shortcut,0;ADDR [EDI].MNUITEM.Shortcut,0;
					
					Invoke SendDlgItemMessage,hWnd,IDC_EDTITEMNAME,WM_SETTEXT,0,ADDR [EDI].MNUITEM.szName
					Invoke BinToDec,[EDI].MNUITEM.ID,ADDR Buffer
					Invoke SendDlgItemMessage,hWnd,IDC_EDTITEMID,WM_SETTEXT,0,ADDR Buffer
					
					;State					
					MOV EAX,[EDI].MNUITEM.nState
					AND EAX,MF_CHECKED
					.If EAX
						Invoke SendDlgItemMessage,hWnd,IDC_CHKCHECKED,BM_SETCHECK,BST_CHECKED,0
					.Else
						Invoke SendDlgItemMessage,hWnd,IDC_CHKCHECKED,BM_SETCHECK,BST_UNCHECKED,0
					.EndIf
					
					MOV EAX,[EDI].MNUITEM.nState
					AND EAX,MF_GRAYED
					.If EAX
						Invoke SendDlgItemMessage,hWnd,IDC_CHKGRAYED,BM_SETCHECK,BST_CHECKED,0
					.Else
						Invoke SendDlgItemMessage,hWnd,IDC_CHKGRAYED,BM_SETCHECK,BST_UNCHECKED,0
					.EndIf
					
					MOV EAX,[EDI].MNUITEM.nState
					AND EAX,MF_DISABLED
					.If EAX
						Invoke SendDlgItemMessage,hWnd,IDC_CHKDISABLED,BM_SETCHECK,BST_CHECKED,0
					.Else
						Invoke SendDlgItemMessage,hWnd,IDC_CHKDISABLED,BM_SETCHECK,BST_UNCHECKED,0
					.EndIf
					;----------------------------------------------------------
					;Type
					MOV EAX,[EDI].MNUITEM.nType
					AND EAX,(MF_MENUBREAK XOR -1)
					.If !EAX	;Since MF_STRING==0
						Invoke CheckRadioButton,hWnd,IDC_RBNSTRING,IDC_RBNOWNERDRAW,IDC_RBNSTRING
					.Else
						MOV EAX,[EDI].MNUITEM.nType
						AND EAX,MF_BITMAP
						.If EAX
							Invoke CheckRadioButton,hWnd,IDC_RBNSTRING,IDC_RBNOWNERDRAW,IDC_RBNBITMAP
						.Else
							Invoke CheckRadioButton,hWnd,IDC_RBNSTRING,IDC_RBNOWNERDRAW,IDC_RBNOWNERDRAW
						.EndIf
					.EndIf
					MOV EAX,[EDI].MNUITEM.nType
					AND EAX,MF_MENUBREAK
					.If EAX
						Invoke SendDlgItemMessage,hWnd,35,BM_SETCHECK,BST_CHECKED,0
					.Else
						Invoke SendDlgItemMessage,hWnd,35,BM_SETCHECK,BST_UNCHECKED,0
					.EndIf
				.EndIf
			.EndIf 
		.EndIf
		
	.ElseIf uMsg == WM_CLOSE
		Invoke GetWindowLong,hWnd,GWL_USERDATA
		;Now EAX is a pointer to memory I should free
		Invoke HeapFree,hMainHeap,0,EAX
		Invoke DeleteObject,hArrowUp
		Invoke DeleteObject,hArrowDn
		Invoke DeleteObject,hArrowLt
		Invoke DeleteObject,hArrowRt
		
		Invoke EnableAllDockWindows,TRUE
		Invoke EndDialog,hWnd,NULL
	.EndIf
	
	ExitMenuProc:
	MOV EAX,FALSE
	RET
MenuEditDialogProc EndP

;,,TYPE,STYLE