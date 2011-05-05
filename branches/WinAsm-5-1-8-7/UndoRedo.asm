UNDOTYPECREATECONTROL	EQU 1


.CODE
;ResourceRedo Proc Uses EDI
;;	Invoke GetWindowLong,hADialog,GWL_USERDATA
;;	MOV EDI,EAX
;;	.If [EDI].DIALOGDATA.lpUndoRedoMemory	;It should be checked before calling this procedure, but let's check it again
;;		MOV EDX,[EDI].DIALOGDATA.lpUndoRedoMemory
;;		MOV ECX,[EDX]	;ECX is nr of Undo operations
;;		PrintHex ECX
;;	.EndIf
;	RET
;ResourceRedo EndP
;
;ResourceUndo Proc Uses EDI
;;Local Buffer[256]:BYTE	;To be erased
;	Invoke GetWindowLong,hADialog,GWL_USERDATA
;	MOV EDI,EAX
;	.If [EDI].DIALOGDATA.lpUndoRedoMemory	;It should be checked before calling this procedure, but let's check it again
;;		MOV EAX,[EDI].DIALOGDATA.lpUndoRedoMemory
;;		MOV ECX,[EAX]	;ECX now holds Undo Type
;;		PrintDec ECX
;;		
;;		;ADD EAX,4
;;		;MOV ECX,[EAX+4]	;ECX now holds CONTROLDATA
;;		MOV ECX,[EAX+4].CONTROLDATA.hWnd
;;		PrintHex ECX
;
;
;		MOV EAX,[EDI].DIALOGDATA.lpUndoRedoMemory
;		MOV EDX,4
;		@@:
;		MOV ECX,[EAX]	;ECX now holds Undo Type
;		.If ECX
;			MOV ECX,[EAX+4].CONTROLDATA.hWnd
;			PrintHex ECX
;			
;			ADD EDX,(SizeOf CONTROLDATA)+4
;			ADD EAX,(SizeOf CONTROLDATA)+4
;			JMP @B
;		.EndIf
;
;	.EndIf
;;
;;	Invoke GetWindowLong,hADialog,GWL_USERDATA
;;	MOV EDI,EAX
;;	.If [EDI].DIALOGDATA.lpUndoRedoMemory	;It should be checked before calling this procedure, but let's check it again
;;		MOV EDX,[EDI].DIALOGDATA.lpUndoRedoMemory
;;		MOV ECX,[EDX]	;ECX is nr of UndoRedo operations
;;		PrintDec ECX
;;		.If ECX>0
;;			PUSH EDX
;;			
;;			DEC ECX
;;			MOV EAX,8
;;			MUL ECX
;;			ADD EAX,4
;;			
;;			POP EDX
;;			
;;			ADD EDX,EAX
;;			MOV ECX,[EDX]
;;			;PrintDec ECX	;Type of Undo
;;			ADD EDX,4
;;			MOV ECX,[EDX]
;;			;PrintDec ECX	;lpControlData
;;			Invoke lstrcpy,ADDR Buffer,ADDR [ECX].CONTROLDATA.Caption
;;			PrintString Buffer
;;		.EndIf 
;;		;PrintHex ECX
;;		
;;	.EndIf
;	RET
;ResourceUndo EndP
;
;AddUndo Proc Uses EDI dwUndoType:DWORD, lpControlData:DWORD
;
;;To Test
;;MOV EAX,lpControlData
;;MOV EAX,[EAX].CONTROLDATA.hWnd
;;PrintHex EAX
;
;	Invoke GetWindowLong,hADialog,GWL_USERDATA
;	MOV EDI,EAX
;	.If ![EDI].DIALOGDATA.lpUndoRedoMemory
;		MOV EAX, SizeOf CONTROLDATA
;		PrintDec EAX
;		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,(SizeOf CONTROLDATA)+8
;		;i.e. 4 extra bytes to store dwUndoType at the begining
;		;and 4 extra bytes to let lpUndoRedoPointer rest
;		MOV [EDI].DIALOGDATA.lpUndoRedoMemory,EAX
;		
;		
;		MOV ECX,dwUndoType
;		MOV [EAX],ECX
;		ADD EAX,4
;		PUSH EAX
;		Invoke RtlMoveMemory,EAX,lpControlData,SizeOf CONTROLDATA
;		POP EAX
;		ADD EAX, SizeOf CONTROLDATA	;Let the lpUndoRedoPointer rest
;		MOV [EDI].DIALOGDATA.lpUndoRedoPointer,EAX
;		
;		
;	.Else
;		MOV ECX,[EDI].DIALOGDATA.lpUndoRedoPointer
;
;		MOV EAX,[EDI].DIALOGDATA.lpUndoRedoMemory
;		SUB ECX,EAX	;ECX nr of bytes UndoRedoPointer in front of UndoRedoMemory
;		;PrintDec ECX
;		
;;		MOV EDX,(SizeOf CONTROLDATA)+8
;;		@@:
;;		MOV ECX,[EAX]	;ECX now holds Undo Type
;;		.If ECX
;;			;PrintHex 1
;;			ADD EDX,(SizeOf CONTROLDATA)+4
;;			ADD EAX,(SizeOf CONTROLDATA)+4
;;			JMP @B
;;		.EndIf
;;		
;;		PUSH EDX	;New Size required for UndoRedoMemory
;;		Invoke HeapReAlloc,hMainHeap,HEAP_ZERO_MEMORY,[EDI].DIALOGDATA.lpUndoRedoMemory,EDX
;;		MOV [EDI].DIALOGDATA.lpUndoRedoMemory,EAX
;;		POP EDX
;		
;		
;		
;		
;		
;		
;		
;		
;		
;		
;		
;		
;		
;		
;;		SUB EDX,(SizeOf CONTROLDATA)+8
;;		ADD EAX,EDX
;;		
;;		
;;		MOV ECX,dwUndoType
;;		MOV [EAX],ECX
;;		ADD EAX,4
;;		PUSH EAX
;;		Invoke RtlMoveMemory,EAX,lpControlData,SizeOf CONTROLDATA
;;		POP EAX
;;		ADD EAX, SizeOf CONTROLDATA	;Let the lpUndoRedoPointer rest
;;		MOV [EDI].DIALOGDATA.lpUndoRedoPointer,EAX
;
;
;	.EndIf
;
;
;	
;;	Invoke GetWindowLong,hADialog,GWL_USERDATA
;;	MOV EDI,EAX
;;	.If ![EDI].DIALOGDATA.lpUndoRedoMemory
;;		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,16
;;		;i.e. 4 bytes for storing nr of UndoRedo Operations
;;		;4 bytes for storing undotype
;;		;4 bytes for storing controldata
;;		;4 bytes with no data so that lpUndoRedoPointer points to it
;;		MOV [EDI].DIALOGDATA.lpUndoRedoMemory,EAX
;;		
;;		MOV ECX,1	;Means there is 1 UndoRedo Operation
;;		MOV [EAX],ECX
;;		
;;		MOV ECX,dwUndoType
;;		MOV [EAX+4],ECX
;;		
;;		MOV ECX,lpControlData
;;		MOV [EAX+8],ECX
;;		
;;		ADD EAX,12	;i.e lpUndoRedoPointer points to the last 4 bytes that have no data (=0)
;;		MOV [EDI].DIALOGDATA.lpUndoRedoPointer,EAX	
;;
;;	.Else
;;		MOV EDX,[EDI].DIALOGDATA.lpUndoRedoMemory
;;		MOV ECX,[EDX]	;ECX is nr of Undo operations
;;		
;;		INC ECX
;;		MOV [EDX],ECX	;Store new nr of UndoRedo operations
;;		
;;		MOV EAX,8
;;		MUL ECX		;EAX is Size of UndoRedoMemory
;;		ADD EAX,8;4	;Add 4 more bytes to store nr of UndoRedo Operations
;;					;Add 4 more bytes so that lpUndoRedoPointer can rest there if no Redo is possible
;;		;Now EAX is total Size of UndoRedoMemory
;;		
;;		PUSH EAX
;;		Invoke HeapReAlloc,hMainHeap,HEAP_ZERO_MEMORY,[EDI].DIALOGDATA.lpUndoRedoMemory,EAX
;;		
;;		MOV [EDI].DIALOGDATA.lpUndoRedoMemory,EAX
;;		
;;		POP ECX
;;		SUB ECX,12;8
;;		ADD EAX,ECX
;;		
;;		
;;		MOV ECX,dwUndoType
;;		MOV [EAX],ECX
;;		
;;		MOV ECX,lpControlData
;;		MOV [EAX+4],ECX
;;
;;	.EndIf
;	RET
;AddUndo EndP