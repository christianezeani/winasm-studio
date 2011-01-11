.CODE
FindFromStructureMembersListAndSelect Proc Uses ESI EDI lpText:DWORD
Local lvfi:LV_FINDINFO
Local Buffer[256]:BYTE

	Invoke ShowListAutoPosAndHeight,hListStructureMembers
	XOR EDI,EDI
	MOV ESI,lpText
	.If BYTE PTR [ESI]!=0
		Invoke RtlZeroMemory,ADDR lvfi,SizeOf LV_FINDINFO
		MOV lvfi.flags,LVFI_STRING or LVFI_PARTIAL; or LVFI_WRAP or LVFI_PARTIAL; Or 
		MOV lvfi.psz,ESI
		Invoke SendMessage,hListStructureMembers,LVM_FINDITEM,-1,ADDR lvfi
		.If EAX!=-1 ;i.e if there is such text in the list
			MOV EDI,EAX
			Invoke GetItemText,hListStructureMembers, EDI, 0, ADDR Buffer
			Invoke lstrlen,ESI
			MOV Buffer[EAX],0
			Invoke lstrcmpi,ESI,ADDR Buffer
			.If EAX
				XOR EDI,EDI
			.EndIf
		.EndIf
	.EndIf

	Invoke SelectListItem,hListStructureMembers, EDI;,0
    Invoke ScrollListItemToTop,hListStructureMembers,EDI
	RET
FindFromStructureMembersListAndSelect EndP


FindFromListAndSelect Proc Uses EDI ESI EBX lpText:DWORD, hList:DWORD
Local lvfi:LV_FINDINFO
Local Buffer[256]:BYTE

	MOV ESI,lpText
	;.If BYTE PTR [ESI]!=0
		Invoke RtlZeroMemory,ADDR lvfi,SizeOf LV_FINDINFO
		MOV lvfi.flags,LVFI_STRING or LVFI_PARTIAL; or LVFI_WRAP or LVFI_PARTIAL; Or 
		MOV lvfi.psz,ESI
		Invoke SendMessage,hList,LVM_FINDITEM,-1,ADDR lvfi
		.If EAX!=-1 ;i.e if there is such text in the list
			.If BYTE PTR[ESI]==0
				MOV EDI,-1
			.Else
				MOV EDI,EAX			
			.EndIf
			Invoke GetItemText, hList, EDI, 0, ADDR Buffer
			Invoke lstrlen,ESI
			MOV Buffer[EAX],0
			Invoke lstrcmpi,ESI,ADDR Buffer
			.If EAX==0
				Invoke ShowListAutoPosAndHeight,hList
				Invoke SelectListItem, hList, EDI
				Invoke ScrollListItemToTop,hList,EDI
				MOV EAX,TRUE
			.Else
				Invoke ShowWindow,hList,SW_HIDE
				MOV EAX,FALSE
			.EndIf
		.Else
			Invoke ShowWindow,hList,SW_HIDE
			Invoke ShowWindow,hListConstants,SW_HIDE
			MOV EAX,FALSE
		.EndIf
	;.Else
	;	Invoke ShowWindow,hListConstants,SW_HIDE
	;.EndIf
	RET
FindFromListAndSelect EndP

InsertVariableAndType Proc Uses EDI ESI EBX lpText:DWORD,nImage:DWORD
Local lvi:LVITEM
	
	MOV EDI,lpText
	MOV lvi.imask,LVIF_TEXT OR LVIF_IMAGE
	M2M lvi.iImage,nImage
	
	PUSH EDI
	NextOne:
	XOR EBX,EBX
	XOR ESI,ESI
	@@:
	.If BYTE PTR [EDI]==":"
		MOV BYTE PTR [EDI],0
		INC EDI
		MOV EBX,EDI
		JMP @B
		;JMP NextOne
	.ElseIf BYTE PTR [EDI]==","
		MOV BYTE PTR [EDI],0
		MOV ESI,EDI
		INC ESI
	.Else
		.If BYTE PTR [EDI]!=0
			INC EDI
			JMP @B;NextOne
		.EndIf
	.EndIf
	
	POP EDI

	MOV lvi.pszText,EDI
	MOV lvi.iItem,0
	MOV lvi.iSubItem, 0
	Invoke SendMessage,hListVariables,LVM_INSERTITEM,0,ADDR lvi
	.If EBX	;i.e this structure member is a structure
		MOV lvi.iItem,EAX
		MOV lvi.iSubItem, 1
		MOV lvi.pszText,EBX
		;PrintStringByAddr EBX
		Invoke SendMessage,hListVariables,LVM_SETITEM,0,ADDR lvi
	.EndIf
	
	.If ESI
		MOV EDI,ESI
		PUSH EDI
		JMP NextOne
	.EndIf
	RET
InsertVariableAndType EndP

;=======================================================================
;   by shoorick
;=======================================================================
fasm_proc_parser proc  ; uses edi<-o_buff,esi<-i_buff
;-----------------------------------------------------------------------
;   string has to be trimmed from spaces left and right,
;   has no comments, cr, lf or "\"
;   case sensitive! (lowcase as in the fasm definitions)
;-----------------------------------------------------------------------
    xor edx,edx
    mov eax,[esi]
    mov [edi],edx
    add esi,4
    cmp eax,"corp";"proc"
    jne done
    cmp byte ptr [esi],0
    je  done
    cmp byte ptr [esi],20h
    je  search_name
    cmp byte ptr [esi],9
    jne done
search_name:
    call skip_spaces    
search_name_end:
    lodsb
    stosb
    cmp al,0            
    je  done
    cmp al,20h
    je  @F
    cmp al,9
    je  @F
    cmp al,","
    jne search_name_end
@@:
    mov byte ptr [edi - 1],0
    call skip_spaces_noinc   
;-----------------------------------------------------------------------
fasm_params_only label near
;-----------------------------------------------------------------------
    mov ecx,2
    cmp word ptr [esi]," c"
    je  check_uses
    cmp word ptr [esi],"c" or 900h
    je  check_uses
    xor ecx,ecx
    cmp dword ptr [esi],"cdts";"stdc"
    jne check_uses
    mov ecx,8
    cmp dword ptr [esi + 4]," lla";"all "
    je  check_uses
    cmp dword ptr [esi + 4],"lla" or 9000000h
    jne search_params
check_uses:
    add esi,ecx
    call skip_spaces_noinc
    cmp dword ptr [esi],"sesu";"uses"
    jne search_params
    cmp byte ptr [esi + 4],20h
    je  @f
    cmp byte ptr [esi + 4],9
    jne search_params
@@:
    lodsb
    or  al,al
    jz  done
    cmp al,","
    jne @B
    call skip_spaces_noinc
search_params:
;    inc edi
    mov edx,edi
copy_params:
    lodsb
    or  al,al
    jz  done
    cmp al,9
    je  @F
    cmp al,20h
    je  @F
    stosb
    jmp copy_params
@@:
    call skip_spaces_noinc    
    jmp copy_params
;-----------------------------------------------------------------------
done:
    mov eax,edx
    mov byte ptr [edi],0
	ret
;-----------------------------------------------------------------------
skip_spaces:
    inc esi
skip_spaces_noinc:
    cmp byte ptr [esi],0
    je  done
    cmp byte ptr [esi],20h
    je  skip_spaces
    cmp byte ptr [esi],9
    je  skip_spaces
    retn    	
;-----------------------------------------------------------------------
fasm_proc_parser endp
;=======================================================================

InsertProcParameters Proc Uses EDI ESI nProcLine:DWORD
	Invoke GetLineText,hEditor,nProcLine,Offset LineTxt
	;Returns in EAX the length of the line text
	LEA ESI,LineTxt
	;Trim out any comments   				
	Invoke TrimComment,ESI
	;-----------------------------------------------------------
	;Is Procedure Declaration multiline?->Get All Lines
	@@:
	Invoke lstrlen,ESI
	ADD EAX,ESI
	DEC EAX
	;Check whether procedure declaration is multiline
	.If BYTE PTR [EAX]=="\"
	   mov byte ptr [eax],0
	   jmp Multy
	.EndIf
	.If BYTE PTR [EAX]==","	
	    ;i.e. last char of line is comma or backward slash
		;We need to get next line as well
    Multy:
		Invoke lstrcpy,Offset tmpLineTxt,ESI
		INC nProcLine  					
		Invoke GetLineText,hEditor,nProcLine,Offset LineTxt				
		Invoke TrimComment,Offset LineTxt
		Invoke lstrcat,Offset tmpLineTxt, Offset LineTxt
		Invoke lstrcpy,ESI,Offset tmpLineTxt
		JMP @B
	.EndIf
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    cmp FasmProcStyle,0
    jne FasmParams	
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;-----------------------------------------------------------
	;Find first parameter that we know its type e.g. DWORD
	.While BYTE PTR [ESI]!=0
		.If BYTE PTR [ESI]==":"
			;In case there are spaces or tabs just before ":"
			AvoidSpacesAndTabs:
			DEC ESI
			.If BYTE PTR [ESI]==" " || BYTE PTR [ESI]==VK_TAB
				JMP AvoidSpacesAndTabs
			.EndIf
			@@:
			DEC ESI
			.If BYTE PTR [ESI]=="," || BYTE PTR [ESI]==" " || BYTE PTR [ESI]==VK_TAB
				;This is the first letter of the parameter
				MOV BYTE PTR [ESI], ","
				JMP RawParameters
			.EndIf
			JMP @B
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
	.If BYTE PTR [EDI]==","	;i.e. there are parameters for this procedure
		INC EDI	;To leave first comma behind
		Invoke InsertVariableAndType,EDI,4
	.EndIf
	MOV EAX,nProcLine	;this is to return the last procedure declaration line
	RET
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FasmParams:
    mov edi,esi
    call fasm_proc_parser
    or  eax,eax
    jz  @F
    invoke InsertVariableAndType,eax,4
@@:    
	mov eax,nProcLine
    ret
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
InsertProcParameters EndP

InsertConstantsInVariableList Proc Uses EBX EDI
Local lvi	:LVITEM
Local lvfi	:LV_FINDINFO

	MOV lvfi.flags,LVFI_STRING 
	


	MOV lvi.iSubItem, 0
	MOV lvi.imask,LVIF_TEXT OR LVIF_IMAGE
	MOV lvi.iImage,2
	MOV lvi.iItem,0


	MOV EBX,pLinkedList
	.If EBX!=0
		@@:
		MOV EDI,[EBX].APICONSTANTS.pText
		.While BYTE PTR [EDI]!=0
			.If BYTE PTR [EDI]== "="
				
				INC EDI
				MOV lvi.pszText,EDI
				MOV lvfi.psz,EDI
				
				.While BYTE PTR [EDI]!=0
					.If BYTE PTR [EDI]==" "
						MOV BYTE PTR [EDI],0
						
						;Check if not aready in the list
						Invoke SendMessage,hListVariables,LVM_FINDITEM,-1,ADDR lvfi
						.If EAX==-1 ;i.e if there is NOT such text in the list
							Invoke SendMessage,hListVariables,LVM_INSERTITEM,0,ADDR lvi
						.EndIf
						MOV BYTE PTR [EDI]," "
						INC EDI
						
						MOV lvi.pszText,EDI
						MOV lvfi.psz,EDI
					.EndIf
					INC EDI
				.EndW
				
				;Check if not aready in the list
				Invoke SendMessage,hListVariables,LVM_FINDITEM,-1,ADDR lvfi
				.If EAX==-1 ;i.e if there is NOT such text in the list
					Invoke SendMessage,hListVariables,LVM_INSERTITEM,0,ADDR lvi
				.EndIf
		
				.Break
			.EndIf
			INC EDI
		.EndW
		
		.If [EBX].APICONSTANTS.pNext!=0 ;This is NOT last Entry
			MOV EBX,[EBX].APICONSTANTS.pNext
			JMP @B
		.EndIf
	.EndIf


	RET
InsertConstantsInVariableList EndP

FillVariablesList Proc Uses EDI ESI fInsertConstantsToo:DWORD
Local chrg:CHARRANGE
Local ftxt:FINDTEXTEX
Local LineNo:DWORD

	.If fInsertConstantsToo
		Invoke GetWindowLong,hListVariables,GWL_USERDATA
		.If EAX
			;I need SPEEEEEEEEEEEED
			MOV fInsertConstantsToo,FALSE	;i,e. do NOT add constans again;they are already there
			
			;Delete all except constants
			Invoke DeleteAllItemsByImage,hListVariables,4	;i.e. procedure parameters
			Invoke DeleteAllItemsByImage,hListVariables,5	;i.e. local variables
		.Else
			Invoke SetWindowLong,hListVariables,GWL_USERDATA,TRUE
			Invoke SendMessage,hListVariables,LVM_DELETEALLITEMS,0,0
		.EndIf
	.Else
		Invoke SetWindowLong,hListVariables,GWL_USERDATA,0
		Invoke SendMessage,hListVariables,LVM_DELETEALLITEMS,0,0
	.EndIf

	Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
	Invoke SendMessage,hEditor,EM_EXLINEFROMCHAR,0,chrg.cpMin
	
	Invoke InProcedure,hEditor,EAX
	.If EAX
		;EAX is a pointer to Procedure Name
		MOV ftxt.lpstrText,EAX
		MOV ftxt.chrg.cpMin,0
		MOV ftxt.chrg.cpMax,-1	
	  @@:
		Invoke SendMessage,hEditor,EM_FINDTEXTEX,FR_MATCHCASE or FR_WHOLEWORD or FR_DOWN,ADDR ftxt
		.If EAX!=-1
			Invoke SendMessage,hEditor,EM_EXLINEFROMCHAR,0,ftxt.chrgText.cpMin
			
			MOV LineNo,EAX
			Invoke SendMessage,hEditor,CHM_GETBOOKMARK,EAX,0
			.If EAX==1 || EAX==2
				;---------------------------------------------------------------
				;First Of all get Procedure Parameters
				Invoke InsertProcParameters,LineNo
				MOV LineNo,EAX ;i.e. Procdure declaration	last line
				;---------------------------------------------------------------
				;Now Get Locals
				
				NextLine:
				INC LineNo
				Invoke SendMessage,hEditor,CHM_ISLINE,LineNo,Offset szLocal
				.If EAX==0	;i.e this is a 'Local' line
					Invoke GetLineText,hEditor,LineNo,Offset tmpLineTxt
					LEA EDI,tmpLineTxt
					Invoke LTrim,EDI,EDI
					NextChar:
					.If BYTE PTR [EDI] !=" " && BYTE PTR [EDI] !=VK_TAB
						.If BYTE PTR [EDI]!=0
							INC EDI
							JMP NextChar
						.EndIf
					.Else
						Invoke LTrim,EDI,EDI
						Invoke TrimComment,EDI
						
						;Remove any tabs and spaces
						LEA ESI, LineTxt
						.While BYTE PTR [EDI]!=0
							.If BYTE PTR [EDI]!=" " && BYTE PTR [EDI]!=VK_TAB
								MOV CL,BYTE PTR [EDI]
								MOV BYTE PTR [ESI],CL
								INC ESI
							.EndIf
							INC EDI
						.EndW
						MOV	BYTE PTR [ESI],0	;Insert NULL terminator
						Invoke InsertVariableAndType,Offset LineTxt,5
					.EndIf
					JMP NextLine
				.Else
					Invoke GetLineText,hEditor,LineNo,Offset tmpLineTxt
					LEA EDI,tmpLineTxt
					Invoke LTrim,EDI,EDI
					 ;in case this line is empty or commented check the next one.
					.If BYTE PTR [EDI]==0 || BYTE PTR [EDI]==";"
						JMP NextLine
					.EndIf				
				.EndIf
			.Else
				MOV EAX,ftxt.chrgText.cpMin
				INC EAX
				MOV ftxt.chrg.cpMin,EAX
				JMP @B
			.EndIf
		;.Else	;Such a procedure name was not found
		.EndIf
	.EndIf
	
	.If fInsertConstantsToo==TRUE
		;PrintText "Hooray!!!!"
		Invoke InsertConstantsInVariableList
	.EndIf
	
	;Now Get Global Variables
	;Invoke EnumProjectItems,Offset InsertGlobals
	RET
FillVariablesList EndP

FillStructureMembersList Proc Uses ESI EDI EBX lpText:DWORD
Local lvi:LVITEM
	Invoke SendMessage,hListStructureMembers,LVM_DELETEALLITEMS,0,0
	MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE; OR LVIF_STATE
	MOV lvi.iImage,2
	MOV ESI,lpText
	INC ESI	;i.e do NOT need first comma
	MOV EDI,ESI
	.While BYTE PTR [ESI]!=0
		.If BYTE PTR [ESI]==","
			MOV BYTE PTR [ESI],0
			CALL Insert
			MOV EDI,ESI
			INC EDI
		.EndIf
		INC ESI
	.EndW
	CALL Insert
	RET
	;-----------------------------------------------------------------------
	Insert:
	PUSH EDI
	XOR EBX,EBX
	@@:
	.If BYTE PTR [EDI]==":"
		MOV BYTE PTR [EDI],0
		MOV EBX,EDI
		INC EBX
	.Else
		.If BYTE PTR [EDI]!=0
			INC EDI
			JMP @B
		.EndIf
	.EndIf
	POP EDI
	MOV lvi.pszText,EDI
	MOV lvi.iItem,0
	MOV lvi.iSubItem, 0
	Invoke SendMessage,hListStructureMembers,LVM_INSERTITEM,0,ADDR lvi
	.If EBX	;i.e this structure member is a structure
		MOV lvi.iItem,EAX
		MOV lvi.iSubItem, 1
		MOV lvi.pszText,EBX
		Invoke SendMessage,hListStructureMembers,LVM_SETITEM,0,ADDR lvi
	.EndIf
	RETN
FillStructureMembersList EndP

;Returns -1 if not Structure or variable defined as structure
IsWordAPIStructure Proc Uses ESI EBX lpWord:DWORD
Local lvfi:LV_FINDINFO
Local Buffer[256]:BYTE
	
	MOV ESI,lpWord
	MOV lvfi.flags,LVFI_STRING 
	MOV lvfi.psz,ESI
	
	;Check if lpWord is a STRUCTURE NAME
	Invoke SendMessage,hListStructures,LVM_FINDITEM,-1,ADDR lvfi
	.If EAX!=-1 ;i.e if there is such text in the list
		MOV EBX,EAX
		Invoke GetItemText,hListStructures,EBX,0,ADDR Buffer
		Invoke lstrcmp,ESI,ADDR Buffer	;we need case sensitive comparison
		.If EAX !=0	;i.e. if NOT eaxctly the same
			JMP IsItVariable	;test this may be a variable such as rect (case difference with a structure name RECT)
		.EndIf
		MOV EAX,EBX
	.Else	;Check if lpWord is a variable defined as structure
		IsItVariable:
		;Fill list with variables
		Invoke FillVariablesList,FALSE
		;Is this word a variable that is defined as structure ?
		Invoke SendMessage,hListVariables,LVM_FINDITEM,-1,ADDR lvfi	
		.If EAX!=-1 ;i.e if there is such text in the list
			;-----Let us check if they are case sensitive same strings--------
			MOV EBX,EAX
			Invoke GetItemText,hListVariables,EBX,0,ADDR Buffer
			Invoke lstrcmp,ESI,ADDR Buffer	;we need case sensitive comparison
			.If EAX !=0	;i.e. if NOT eaxctly the same
				;XOR EAX,EAX
				MOV EAX,-1
				JMP Done
			.EndIf	
			;-----------------------------------------------------------------
			Invoke GetItemText, hListVariables, EBX, 1, ADDR Buffer
			.If Buffer[0]!=0
				LEA EAX,Buffer
				MOV lvfi.psz,EAX
				Invoke SendMessage,hListStructures,LVM_FINDITEM,-1,ADDR lvfi
				.If EAX!=-1	;i.e such structure found
				.Else
					;XOR EAX,EAX
					MOV EAX,-1
				.EndIf
			.Else
				;XOR EAX,EAX
				MOV EAX,-1
			.EndIf
		.Else
			;XOR EAX,EAX
			MOV EAX,-1
		.EndIf
	.EndIf
	
	Done:
	RET
IsWordAPIStructure EndP

AutoVariableAndStructureMembersList Proc Uses EBX fInsertConstantsToo:DWORD
Local chrg			:CHARRANGE
Local txtrange		:TEXTRANGE
Local Buffer[256]	:BYTE
Local nCurLine		:DWORD
Local BracketFound	:DWORD

	Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
	Invoke SendMessage,hEditor,EM_FINDWORDBREAK,WB_MOVEWORDLEFT,chrg.cpMin
	MOV EBX,EAX
	
	Invoke SendMessage,hEditor,EM_EXLINEFROMCHAR,0,chrg.cpMin
	;Now EAX is the currentline number
	MOV nCurLine,EAX
	Invoke GetLineText,hEditor,EAX,Offset tmpLineTxt
	Invoke SendMessage,hEditor,EM_LINEINDEX,nCurLine,0
	;Now EAX is the first line character
	SUB EBX,EAX
	DEC EBX
	
	
	;Now EBX is the position of the start of CURRENT word in the Line Text
	.If tmpLineTxt[EBX]==" " || tmpLineTxt[EBX]==VK_TAB || tmpLineTxt[EBX]=="," || tmpLineTxt[EBX]=="[" || tmpLineTxt[EBX]=="=" || tmpLineTxt[EBX]=="<" || tmpLineTxt[EBX]==">"
		;New
		Invoke ShowWindow,hListStructureMembers,SW_HIDE
		
		.If EBX!=-1 && EBX!=0
			MOV tmpLineTxt[EBX],0
			
			LEA EBX,tmpLineTxt
			
			XOR EAX,EAX
			@@:
			.If BYTE PTR [EBX]==0
				.If !EAX
					Invoke ShowWindow,hListVariables,SW_HIDE
					JMP Finished
				.EndIf
			.Else
				.If (BYTE PTR [EBX]>='a' && BYTE PTR [EBX]<='z') || (BYTE PTR [EBX]>='A' && BYTE PTR [EBX]<='Z')
					.If !EAX
						MOV EAX,1
					.ElseIf EAX==2
					 	MOV EAX,3
					.EndIf
				.ElseIf BYTE PTR [EBX]==":"
					;There is a label-->start looking from this point onwards
					XOR EAX,EAX
				.ElseIf BYTE PTR [EBX]==" " || BYTE PTR [EBX]=="	"
					.If EAX==1
						MOV EAX,2
					.EndIf
				;.ElseIf BYTE PTR [EBX] == "," || BYTE PTR [EBX] == "="
				;	.If EAX==3
				;		MOV EAX,4
				;	.EndIf
				.EndIf
				INC EBX
				JMP @B
			.EndIf
			
			;PrintDec EAX
			;.If fInsertConstantsToo
				.If EAX!=3
					MOV fInsertConstantsToo,FALSE
				.EndIf
			;.EndIf
			
			Invoke IsWindowVisible,hListVariables
			.If !EAX
				Invoke FillVariablesList,fInsertConstantsToo
			.EndIf
			;Now Get CURRENT WORD
			Invoke SendMessage,hEditor,CHM_GETWORD,SizeOf tmpLineTxt,ADDR tmpLineTxt
			.If tmpLineTxt[0]!=0
				Invoke FindFromListAndSelect,Offset tmpLineTxt,hListVariables
			.Else
				Invoke ShowWindow,hListVariables,SW_HIDE
			.EndIf
		.Else
			Invoke ShowWindow,hListVariables,SW_HIDE
		.EndIf
	.ElseIf tmpLineTxt[EBX]=="."
		Invoke ShowWindow,hListVariables,SW_HIDE
		MOV BracketFound,FALSE		
		@@:
		.If EBX
			DEC EBX
			.If tmpLineTxt[EBX]==" " || tmpLineTxt[EBX]=="	"	;i.e. space or tab
			 	JMP @B
			.ElseIf tmpLineTxt[EBX]=="]" && !BracketFound
				MOV BracketFound,TRUE 	
				JMP @B
			.EndIf
		.EndIf
		
		MOV tmpLineTxt[EBX+1],0
		
		@@:
		.If EBX
			.If tmpLineTxt[EBX]!=" " && tmpLineTxt[EBX]!="	" && tmpLineTxt[EBX]!="," && tmpLineTxt[EBX]!="=" && tmpLineTxt[EBX]!=">" && tmpLineTxt[EBX]!="<" && tmpLineTxt[EBX]!="."
			 	DEC EBX
			 	JMP @B
			.EndIf
			INC EBX
		.EndIf
		
		;Here we have [esi if MOV [ESI].xxxx
		;and we have esi if MOV [           ESI].xxxxxx
		MOV EAX,EBX
		
		.If BracketFound
			.If tmpLineTxt[EBX]!="["
				@@:
				.If EBX
					DEC EBX
				 	.If (tmpLineTxt[EBX]==" " || tmpLineTxt[EBX] == "	"); || tmpLineTxt[EBX]=="["
				 		JMP @B
					.EndIf
				.EndIf
			.Else
				INC EAX
			.EndIf
			.If tmpLineTxt[EBX]!="["
				;MOV BracketFound,FALSE
				JMP HideBoth
			.EndIf
		.EndIf
		
		MOV EBX,EAX
		
		Invoke lstrcpy,ADDR Buffer,ADDR tmpLineTxt[EBX]
		.If BracketFound
			Invoke lstrcmpi,ADDR Buffer,Offset szEAX
			.If EAX
				Invoke lstrcmpi,ADDR Buffer,Offset szEBX
				.If EAX
					Invoke lstrcmpi,ADDR Buffer,Offset szECX
					.If EAX
						Invoke lstrcmpi,ADDR Buffer,Offset szEDX
						.If EAX
							Invoke lstrcmpi,ADDR Buffer,Offset szESI
							.If EAX
								Invoke lstrcmpi,ADDR Buffer,Offset szEDI
								.If EAX
									Invoke ShowWindow,hListStructureMembers,SW_HIDE
									JMP Finished
								.EndIf
							.EndIf
						.EndIf
					.EndIf
				.EndIf
			.EndIf
			CALL IsAnAssumedRegister 
		.Else
			Invoke IsWordAPIStructure,ADDR Buffer
		.EndIf		
		
		.If EAX!=-1
			MOV ECX,EAX
			Invoke GetItemText,hListStructures,ECX,1,Offset tmpLineTxt
			.If tmpLineTxt[0]!=0	;If not a variable
				Invoke IsWindowVisible,hListStructureMembers
				.If !EAX	;i.e not visible
					Invoke FillStructureMembersList,Offset tmpLineTxt
				.EndIf
				;Now Get CURRENT WORD
				Invoke SendMessage,hEditor,CHM_GETWORD,SizeOf tmpLineTxt,Offset tmpLineTxt
				Invoke FindFromStructureMembersListAndSelect,Offset tmpLineTxt
			.EndIf
		.Else
			Invoke ShowWindow,hListStructureMembers,SW_HIDE
		.EndIf
	.Else
		HideBoth:
		Invoke ShowWindow,hListVariables,SW_HIDE
		Invoke ShowWindow,hListStructureMembers,SW_HIDE
	.EndIf
	Finished:
	RET
	
	;Returns -1 if not
	IsAnAssumedRegister:
	;--------------------
	.While nCurLine
		DEC nCurLine
		Invoke SendMessage,hEditor,CHM_ISLINE,nCurLine,ADDR szAssume
		.If EAX==0	;This is an assume line
			Invoke GetLineText,hEditor,nCurLine,Offset tmpLineTxt
			Invoke LTrim,Offset tmpLineTxt,Offset tmpLineTxt
			LEA EBX,tmpLineTxt
			ADD EBX,7
			Invoke LTrim,EBX,EBX
			MOV CL,BYTE PTR [EBX+3]
			PUSH ECX
			MOV BYTE PTR [EBX+3],0
			Invoke lstrcmpi,EBX,ADDR Buffer
			POP ECX
			.If EAX	;i.e. not the same register
				JMP PreviousLine
			.EndIf
			
			MOV BYTE PTR [EBX+3],CL
			@@:
			.If BYTE PTR [EBX]!=0DH
				.If BYTE PTR [EBX]==":"
					SkipBlanks:
					INC EBX
					.If (BYTE PTR [EBX]==" " || BYTE PTR [EBX]=="	")
						JMP SkipBlanks
					.EndIf
					MOV BYTE PTR [EBX+3],0
					Invoke lstrcmpi,EBX,CTEXT("ptr")
					.If !EAX	; :ptr found
						ADD EBX,3
						SkipMoreBlanks:
						INC EBX
						.If BYTE PTR [EBX]==" " || BYTE PTR [EBX]=="	"; || BYTE PTR [EBX]==0dh
							JMP SkipMoreBlanks
						.EndIf
						PUSH EBX
						FindEndOfWord:
						INC EBX
						.If BYTE PTR [EBX]!=" " && BYTE PTR [EBX]!="	" && BYTE PTR [EBX]!=0dh
							JMP FindEndOfWord
						.EndIf
						MOV BYTE PTR [EBX],0
						POP EBX
						Invoke IsWordAPIStructure,EBX
						.Break
					.EndIf
				.Else
					INC EBX
					JMP @B
				.EndIf
			.EndIf
			MOV EAX,-1
			.Break
		.Else
			Invoke SendMessage,hEditor,CHM_ISLINE,nCurLine,ADDR szProc	;Stop searching if we are in proc and reached its top
			.If EAX==0
				Invoke SendMessage,hEditor,CHM_ISLINE,nCurLine,ADDR szOption
				.If EAX!=0
					MOV EAX,-1
					.Break
				.EndIf
			.EndIf
		.EndIf
		PreviousLine:
		MOV EAX,-1
	.EndW
	RETN

AutoVariableAndStructureMembersList EndP

AutoStructuresList Proc
Local chrg:CHARRANGE			
Local Buffer[256]:BYTE
Local txtrange:TEXTRANGE
	
	Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg

	;Go see whether we are after ":"
	Invoke SendMessage,hEditor,EM_FINDWORDBREAK,WB_MOVEWORDLEFT,chrg.cpMin
	.If EAX	;Manos bug-deleting all before first procedure causes WinAsm Studio to hang
		MOV txtrange.chrg.cpMax,EAX
		DEC EAX
		MOV txtrange.chrg.cpMin,EAX
		LEA EAX,Buffer
		MOV txtrange.lpstrText,EAX
		@@:
		Invoke SendMessage,hEditor,EM_GETTEXTRANGE,0 ,ADDR txtrange
		.If Buffer[0]==" " || Buffer[0]==VK_TAB
			DEC txtrange.chrg.cpMax
			DEC txtrange.chrg.cpMin
			.If txtrange.chrg.cpMax && txtrange.chrg.cpMin	;Manos bug-deleting all before first procedure causes WinAsm Studio to hang
				JMP @B
			.Else
				RET
			.EndIf
		.EndIf
		
		.If Buffer[0]==":"	;OK We are after ":"
			Invoke SendMessage,hEditor,CHM_GETWORD,SizeOf Buffer,ADDR Buffer
			.If Buffer[0]!=0
				Invoke FindFromListAndSelect,ADDR Buffer,hListStructures
			.Else
				Invoke ShowWindow,hListStructures,SW_HIDE
			.EndIf
		.Else
	    	Invoke ShowWindow,hListStructures,SW_HIDE
		.EndIf
	.EndIf
	RET
AutoStructuresList EndP

AsmAndIncFiles Proc Uses EBX hChild:DWORD
Local lvi:LVITEM
Local tvi:TVITEM
Local Buffer[MAX_PATH]:BYTE

	Invoke GetWindowLong,hChild,0
	MOV EBX, EAX
	.If CHILDWINDOWDATA.dwTypeOfFile[EBX]==1 || CHILDWINDOWDATA.dwTypeOfFile[EBX]==2; NOOOOOOOOOOOO Modules || CHILDWINDOWDATA.dwTypeOfFile[EBX]==51
		Invoke GetFilePath,ADDR CHILDWINDOWDATA.szFileName[EBX],ADDR Buffer
		Invoke lstrcmpi,ADDR Buffer,Offset ProjectPath
		.If EAX==0	;This file is in the project directory so get only the fileaname+ext
			MOV tvi._mask,TVIF_TEXT
			LEA EAX, Buffer
			MOV tvi.pszText,EAX
			MOV tvi.cchTextMax,256
			PUSH CHILDWINDOWDATA.hTreeItem[EBX]
			POP tvi.hItem
			Invoke SendMessage,WinAsmHandles.hProjTree,TVM_GETITEM,0,ADDR tvi
			LEA EAX,Buffer
		.Else	;This file is in some other directory so get fullpath name+ext
			LEA EAX,CHILDWINDOWDATA.szFileName[EBX]
		.EndIf
		;---------------------------------------------------------
		MOV lvi.pszText,EAX
		MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE
		MOV lvi.iImage,0
		MOV lvi.iSubItem, 0
		Invoke SendMessage,hListIncludes,LVM_INSERTITEM,0,ADDR lvi
	.EndIf
	RET
AsmAndIncFiles EndP

AutoIncludesList Proc Uses EBX nType:DWORD
Local Buffer[2*MAX_PATH]	:BYTE	;in case we have a long comment
Local FindFileData			:WIN32_FIND_DATA
Local hFindFile				:HANDLE
Local lvi					:LVITEM

Local chrg					:CHARRANGE
Local nLine					:DWORD
Local nLineStart			:DWORD
Local ftxt					:FINDTEXTEX
Local txtrng				:TEXTRANGE

Local dwTrials				:DWORD


	MOV EBX,Offset tmpBuffer
	Invoke SendMessage,hEditor,CHM_GETWORD,16383,EBX
	.If BYTE PTR [EBX]==0
		Invoke ShowWindow,hListIncludes,SW_HIDE
		RET
	.EndIf
	
	Invoke IsWindowVisible,hListIncludes
	.If !EAX	;i.e not visible
		Invoke SendMessage,hListIncludes,LVM_DELETEALLITEMS,0,0
		.If nType==1	;i.e. include files
			Invoke EnumProjectItems,Offset AsmAndIncFiles
			Invoke lstrcpy,ADDR Buffer,pIncludePath
			Invoke lstrcat,ADDR Buffer,Offset szSlash
			Invoke lstrcat,ADDR Buffer,Offset szAllInc
		.Else
			Invoke lstrcpy, ADDR Buffer,Offset LibraryPath
			Invoke lstrcat, ADDR Buffer,Offset szSlash
			Invoke lstrcat, ADDR Buffer,Offset szAllLib
		.EndIf
		
		Invoke FindFirstFile,ADDR Buffer,ADDR FindFileData
		MOV hFindFile, EAX
		
		.If hFindFile!=INVALID_HANDLE_VALUE
			MOV lvi.imask, LVIF_TEXT OR LVIF_IMAGE
			MOV lvi.iImage,1
			MOV lvi.iSubItem, 0
			LEA EAX,FindFileData.cFileName
			MOV lvi.pszText,EAX
			Invoke SendMessage,hListIncludes,LVM_INSERTITEM,0,ADDR lvi
			@@:
			Invoke FindNextFile, hFindFile, ADDR FindFileData
			.If EAX!=0
				Invoke SendMessage,hListIncludes,LVM_INSERTITEM,0,ADDR lvi
				JMP @B
			.EndIf
		.EndIf
		Invoke FindClose, hFindFile
	.EndIf


	Invoke SendMessage,hEditor,EM_EXGETSEL,0,ADDR chrg
	
	;chrg.cpMin is the position of the first character of the selection.
	;chrg.cpMax is the position of the last character of the selection.
	Invoke SendMessage,hEditor,EM_EXLINEFROMCHAR,0,chrg.cpMin
	MOV nLine,EAX
	Invoke SendMessage,hEditor,EM_LINEINDEX,nLine,0
	;Now eax is the begining of line
	MOV nLineStart,EAX
	MOV ftxt.chrg.cpMin,EAX


	MOV EAX,chrg.cpMin
	MOV ftxt.chrg.cpMax,EAX	
	
	MOV dwTrials,1
	TryAgain:
	.If nType==1
		 .If dwTrials==1
			MOV ftxt.lpstrText,CTEXT("include ")
		.Else
			MOV ftxt.lpstrText,CTEXT("include	")
		.EndIf
	.Else
		.If dwTrials==1
			MOV ftxt.lpstrText,CTEXT("includelib ")
		.Else
			MOV ftxt.lpstrText,CTEXT("includelib	")
		.EndIf
	.EndIf

	Invoke SendMessage,hEditor,EM_FINDTEXTEX,FR_DOWN,ADDR ftxt
	MOV ECX,chrg.cpMin
	.If EAX!=-1 && ECX>=ftxt.chrgText.cpMax	;i.e if "Include " or "IncludeLib " found AND current pos is after "Include " or "IncludeLib "
		MOV EAX,ftxt.chrgText.cpMax
		MOV txtrng.chrg.cpMin,EAX
		
		MOV ReplaceStart,EAX
		
		Invoke GetLineLength,hEditor,nLine
		ADD EAX,nLineStart
		MOV txtrng.chrg.cpMax,EAX
		LEA EAX,Buffer
		MOV txtrng.lpstrText, EAX
		Invoke SendMessage,hEditor,EM_GETTEXTRANGE,0,ADDR txtrng
		
		Invoke TrimComment,ADDR Buffer
		
		;----------------Right trim Buffer-------------------  	
		.If Buffer[0]!=0
			LEA EBX, Buffer
			MOV EDX,EBX
			Invoke lstrlen,ADDR Buffer
			ADD EBX,EAX		;now EBX is the zero termination
			@@:
			DEC EBX
			.If EBX>=EDX
				.If BYTE PTR [EBX]==" " || BYTE PTR [EBX]==VK_TAB
					MOV BYTE PTR [EBX],0
					JMP @B
				.EndIf
			.EndIf
		.EndIf
		;----------------------------------------------------
		.If Buffer[0]!=0
			Invoke lstrlen,ADDR Buffer
			MOV ReplaceLength,EAX
			Invoke LTrim,ADDR Buffer,ADDR Buffer
			Invoke FindFromListAndSelect,ADDR Buffer,hListIncludes
		.Else
			Invoke ShowWindow,hListIncludes,SW_HIDE
		.EndIf
	.Else
		.If dwTrials==1 && EAX==-1
			INC dwTrials
			JMP TryAgain
		.EndIf
		Invoke ShowWindow,hListIncludes,SW_HIDE
	.EndIf	
	
	RET
AutoIncludesList EndP
