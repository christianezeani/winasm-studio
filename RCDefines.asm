.CODE

AddDefine Proc Uses ESI lpProMem:DWORD,lpName:DWORD,lpValue:DWORD

	MOV ESI,lpProMem
	.While [ESI].DEFINE.szName || [ESI].DEFINE.dwValue
		ADD ESI,SizeOf DEFINE
	.EndW
	
	Invoke lstrcpyn,ADDR [ESI].DEFINE.szName,lpName,65
	;INC [ESI].DEFINE.ReferenceCount	;<---------Look:Commented
	
	MOV EAX,lpValue
	.If WORD PTR [EAX]=='x0'
		ADD EAX,2
		Invoke HexToBin,EAX
	.Else
		Invoke DecToBin,EAX
	.EndIf
	MOV [ESI].DEFINE.dwValue,EAX
	RET

AddDefine EndP

;UpdateDefines Proc Uses EDI EBX lpName:DWORD, dwValue:DWORD
;Local tvi				:TVITEM
;	MOV tvi._mask,TVIF_PARAM
;
;	;Get Resources (Bitmaps,Icons,etc)
;	.If lpResourcesMem
;		MOV EDI,lpResourcesMem
;		.While [EDI].RESOURCEMEM.szFile
;			Invoke lstrcmpi,lpName,ADDR [EDI].RESOURCEMEM.szName
;			.If !EAX
;				MOV EAX,dwValue
;				MOV [EDI].RESOURCEMEM.Value,EAX
;			.EndIf
;			ADD EDI,SizeOf RESOURCEMEM
;		.EndW
;	.EndIf
;
;
;	;Get Menus
;	;---------
;	.If hMenusParentItem
;		Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_CHILD,hMenusParentItem
;		@@:
;		;----------
;		.If EAX	;This is a Menu hItem
;			;PrintHex EAX
;			MOV EBX,EAX
;			MOV tvi.hItem,EBX
;			Invoke SendMessage,hOthersTree,TVM_GETITEM,0,ADDR tvi
;			MOV EDI,tvi.lParam; is the Menu memory
;			;PrintHex EDI
;			Invoke lstrcmpi,lpName,ADDR [EDI].MNUHEAD.szMenuName
;			;PrintHex EAX
;			LEA edx,[EDI].MNUHEAD.szMenuName
;			PrintStringByAddr EDX
;			.If !EAX
;				MOV EAX,dwValue
;				MOV [EDI].MNUHEAD.MenuID,EAX
;			.EndIf
;			
;			;Menu Items go here
;			ADD EDI,SizeOf MNUHEAD
;			.While [EDI].MNUITEM.Flag
;				Invoke lstrcmpi,lpName,ADDR [EDI].MNUITEM.szName
;				.If !EAX
;					MOV EAX,dwValue
;					MOV [EDI].MNUITEM.ID,EAX
;				.EndIf
;				ADD EDI,SizeOf MNUITEM
;			.EndW
;			;Get the next menu
;			Invoke SendMessage,hOthersTree,TVM_GETNEXTITEM,TVGN_NEXT,EBX
;			JMP @B
;		.EndIf
;	.EndIf
;	
;
;	RET
;UpdateDefines EndP

;This is Add a new Define or Replace a deleted Define with a new one
AddOrReplaceDefine Proc Uses ESI lpName:DWORD, lpValue:DWORD
Local Buffer[256]	:BYTE

	MOV ESI,lpName
	.If BYTE PTR [ESI]!=0	;<----------------Very Important
		;MOV bDefineChanged,FALSE
		MOV ESI,lpDefinesMem
		.While [ESI].DEFINE.szName || [ESI].DEFINE.dwValue
			Invoke lstrcmpi,lpName,ADDR [ESI].DEFINE.szName
			.If !EAX	;Already defined
				.If [ESI].DEFINE.ReferenceCount
					MOV EAX,lpValue
					.If WORD PTR [EAX]=='x0'
						ADD EAX,2
						Invoke HexToBin,EAX
					.Else
						Invoke DecToBin,EAX
					.EndIf
					.If EAX!=[ESI].DEFINE.dwValue
						PUSH EBX
						
						LEA EBX,Buffer
						Invoke lstrcpy,EBX,ADDR [ESI].DEFINE.szName
						;" is already defined as "
						Invoke lstrcat,EBX,Offset szIsAlreadyDefinedAs
						Invoke lstrlen,EBX
						ADD EAX,EBX
						Invoke BinToDec,[ESI].DEFINE.dwValue,EAX
						Invoke lstrlen,EBX
						ADD EAX,EBX
						
						;". Do you want to change it?"
						Invoke lstrcat,EAX,Offset szDoYouWantToChangeIt
						
						Invoke EnableAllDockWindows,FALSE
						Invoke EnableWindow, hFind, FALSE
						Invoke MessageBox,WinAsmHandles.hMain,EBX,Offset szAppName,MB_YESNO + MB_ICONWARNING + MB_TASKMODAL
						
						POP EBX
						
						PUSH EAX
						Invoke EnableAllDockWindows,TRUE
						Invoke EnableWindow, hFind, TRUE
						POP EAX
						.If EAX==IDYES
							JMP SetValue
						.EndIf
					.EndIf
					JMP Ex
				.Else
					JMP SetValue
				.EndIf
			.Else
				ADD ESI,SizeOf DEFINE
			.EndIf
		.EndW
		
		.While [ESI].DEFINE.szName || [ESI].DEFINE.dwValue
			.If [ESI].DEFINE.ReferenceCount==0
				.Break
			.EndIf
			ADD ESI,SizeOf DEFINE
		.EndW
		
		Invoke lstrcpyn,ADDR [ESI].DEFINE.szName,lpName,65
		
		SetValue:
		;--------
		MOV EAX,lpValue
		.If WORD PTR [EAX]=='x0'
			ADD EAX,2
			Invoke HexToBin,EAX
		.Else
			Invoke DecToBin,EAX
		.EndIf
		MOV [ESI].DEFINE.dwValue,EAX
		
		Ex:
		INC [ESI].DEFINE.ReferenceCount
		
	.EndIf
	RET

AddOrReplaceDefine EndP

DeleteDefine Proc Uses ESI lpName:DWORD;,lpValue:DWORD
	MOV ESI,lpDefinesMem
	.While [ESI].DEFINE.szName || [ESI].DEFINE.dwValue
		Invoke lstrcmp,lpName,ADDR [ESI].DEFINE.szName
		.If !EAX && [ESI].DEFINE.ReferenceCount
			MOV EDX,[ESI].DEFINE.ReferenceCount
			DEC [ESI].DEFINE.ReferenceCount
			.Break
		.EndIf
		ADD ESI,SizeOf DEFINE
	.EndW

	RET
DeleteDefine EndP

ParseDefine Proc Uses ESI lpRCMem:DWORD,lpProMem:DWORD

	MOV ESI,lpRCMem
	Invoke GetWord,Offset NameBuffer,ESI
	ADD ESI,EAX

	Invoke GetWord,Offset ThisWord,ESI
	;Do not add EAX to ESI YET
	;ADD ESI,EAX

	.If (ThisWord[0] < "0" || ThisWord[0] > "9") && ThisWord[0]!="-"
		;Since there are VALID define statements that don't have numerical part
		;then : DO NOT add NameBuffer to the defines memory 
		
		;PrintText "This is not a number"
		;XOR EAX,EAX
		;RET
	.Else
		;This is considered to be a vaild Define statement that has a numerical part too
		ADD ESI,EAX
		Invoke AddDefine,lpProMem,Offset NameBuffer,Offset ThisWord
	.EndIf
	MOV EAX,ESI
	SUB EAX,lpRCMem
	RET

ParseDefine EndP
