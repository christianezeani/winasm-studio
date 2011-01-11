PrintHook Proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	.If uMsg==WM_INITDIALOG
		Invoke CenterWindow,hWnd
		Invoke SetWindowText,hWnd,Offset szPrintDialogTitle
	.EndIf
	MOV EAX,FALSE
	RET
PrintHook EndP


Print Proc hEdit:DWORD
Local doci:DOCINFO
Local lf:LOGFONT
Local hPrFont:DWORD
Local ptX:DWORD
Local ptY:DWORD
Local pX:DWORD
Local pY:DWORD
Local pML:DWORD
Local pMT:DWORD
Local pMR:DWORD
Local pMB:DWORD
Local nLine:DWORD
Local nMLine:DWORD
Local pt:POINT
Local tWt:DWORD
Local rect:RECT
Local hRgn:DWORD
Local chrg:CHARRANGE
Local nPageno:DWORD
Local Buffer[256]:BYTE
Local pd:PRINTDLG
Local txtrng:TEXTRANGE
Local nPageSize:DWORD	;Lines Per Page
Local prnbuff[1024]:BYTE

	Invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR chrg

	Invoke RtlZeroMemory, ADDR pd, SizeOf pd
	MOV pd.lStructSize, SizeOf pd
	MOV pd.lpfnPrintHook,Offset PrintHook
	PUSH WinAsmHandles.hMain
	POP pd.hwndOwner
	PUSH hInstance
	POP pd.hInstance

	MOV EAX,chrg.cpMin
	.If EAX!=chrg.cpMax
		MOV pd.Flags,PD_RETURNDC or PD_SELECTION or PD_ENABLEPRINTHOOK; or PD_SHOWHELP
	.Else
		MOV pd.Flags,PD_RETURNDC or PD_NOSELECTION or PD_ENABLEPRINTHOOK; or PD_SHOWHELP;or PD_PAGENUMS
	.EndIf

	MOV pd.nMinPage,0
	MOV pd.nMaxPage,-1
	MOV pd.nFromPage,-1
	MOV pd.nToPage,-1

	Invoke PrintDlg,ADDR pd
	
	MOV pd.nFromPage,1 ;To start from Page 1

	.If EAX
		PUSH EBX
		Invoke GetDeviceCaps,pd.hDC,PHYSICALWIDTH
		MOV pX,EAX	;Printer page pixel width
		MOV pML,150	;Left Margin
		MOV pMR,150	;Right Margin

		Invoke GetDeviceCaps,pd.hDC,PHYSICALHEIGHT
		MOV pY,EAX	;Printer page pixel height
		MOV pMT,150	;Top Margin
		MOV pMB,150	;Bottom Margin

		Invoke RtlZeroMemory,ADDR lf,SizeOf lf
		Invoke lstrcpy,ADDR lf.lfFaceName,ADDR lfnt.lfFaceName
		
		
		
		Invoke GetDeviceCaps,pd.hDC,LOGPIXELSY   ;Returns pixels per inch in EAX
		MOV ECX,lfnt.lfHeight
		NEG ECX
		MUL ECX
		XOR EDX,EDX
		MOV ECX,72
		DIV ECX
		;Now in EAX we have the line height in pixels for the printer
		MOV lf.lfHeight,EAX
		
		;Now Calculate Number Of Lines Per Page
		XOR EDX,EDX
		MOV EAX,pY
		SUB EAX,pMT
		SUB EAX,pMB
		MOV ECX,lf.lfHeight
		DIV ECX
		MOV nPageSize,EAX	;Number Of Lines Per Page
		DEC nPageSize		;Subtract 1 line for the title "Page ?"
		;PrintDec nPageSize
		
		
		MOV EAX,lfnt.lfWeight
		MOV lf.lfWeight,EAX
		Invoke CreateFontIndirect,ADDR lf
		MOV hPrFont,EAX
		MOV doci.cbSize,SizeOf doci
		MOV doci.lpszDocName,Offset szAppName
		MOV EAX,pd.Flags
		AND EAX,PD_PRINTTOFILE
		.If EAX
			MOV EAX,'ELIF'
			MOV DWORD PTR Buffer,EAX
			MOV EAX,':'
			MOV DWORD PTR Buffer+4,EAX
			LEA EAX,Buffer
			MOV doci.lpszOutput,EAX
		.Else
			MOV doci.lpszOutput,NULL
		.EndIf
		MOV doci.lpszDatatype,NULL
		MOV doci.fwType,NULL
		Invoke StartDoc,pd.hDC,ADDR doci
		MOV EAX,pd.Flags
		AND EAX,PD_SELECTION
		.If EAX
			Invoke SendMessage,hEdit,EM_EXLINEFROMCHAR,0,chrg.cpMin
			MOV nLine,EAX
			MOV ECX,nPageSize
			XOR EDX,EDX
			DIV ECX
			MOV nPageno,EAX
			Invoke SendMessage,hEdit,EM_EXLINEFROMCHAR,0,chrg.cpMax
			SUB EAX,nLine
			INC EAX
			MOV nMLine,EAX
			MOV pd.nToPage,-1
		.Else
			MOVZX EAX,pd.nFromPage
			DEC EAX
			MOV nPageno,EAX
			MOV EDX,nPageSize
			MUL EDX
			MOV nLine,EAX
			Invoke SendMessage,hEdit,EM_GETLINECOUNT,0,0
			OR EAX,EAX
			JE Exx
			INC EAX
			MOV nMLine,EAX
		.EndIf
		MOV EAX,pML
		MOV rect.left,EAX
		MOV EAX,pX
		SUB EAX,pMR
		MOV rect.right,EAX
		MOV EAX,pMT
		MOV rect.top,EAX
		MOV EAX,pY
		SUB EAX,pMB
		MOV rect.bottom,EAX
		Invoke CreateRectRgn,rect.left,rect.top,rect.right,rect.bottom
		MOV hRgn,EAX
		
		NxtPage:
		INC nPageno
		MOV EAX,nPageno
		.If AX>pd.nToPage
			JMP Exx
		.EndIf
		Invoke StartPage,pd.hDC
		MOV EAX,pMT
		MOV ptY,EAX
		Invoke SelectObject,pd.hDC,hPrFont
		Invoke SelectObject,pd.hDC,hRgn
		;Get tab width
		MOV EAX,'WWWW'
		MOV DWORD PTR Buffer,EAX
		Invoke GetTextExtentPoint32,pd.hDC,ADDR Buffer,4,ADDR pt
		MOV EAX,pt.x
		SHR EAX,2
		MOV ECX,TabSize
		MUL ECX
		MOV tWt,EAX
		
		;----------------------------------------------------------
		MOV EAX,'egaP'
		MOV DWORD PTR Buffer,EAX
		MOV Buffer[4],' '
		;Invoke dwtoa,nPageno,addr buffer[5]
		;Invoke DwToAscii,nPageno, ADDR buffer[5]
		
		;Invoke wsprintf, ADDR buffer[5], Offset szDecimalTemplate, nPageno
		Invoke BinToDec,nPageno,ADDR Buffer[5]
		
		Invoke lstrcpy,ADDR prnbuff,ADDR Buffer
		
		Invoke lstrlen,ADDR prnbuff
		MOV ECX,EAX
		PUSH EAX
		Invoke GetTextExtentPoint32,pd.hDC,ADDR prnbuff,ECX,ADDR pt
		
		;Left
		MOV EAX,pML
		MOV ptX,EAX
		;----------------------------------------------------------
		POP ECX
		
		Invoke TabbedTextOut,pd.hDC,ptX,ptY,ADDR prnbuff,ECX,1,ADDR tWt,ptX
		
		MOV EAX,pt.y
		ADD ptY,EAX
		SHR EAX,1
		ADD ptY,EAX
		
		NxtLine:
		MOV EAX,ptY
		ADD EAX,pt.y
		ADD EAX,pt.y
		CMP EAX,rect.bottom
		JNB Ep
		DEC nMLine
		JE Ep
		MOV EAX,pML
		MOV ptX,EAX
		Invoke SendMessage,hEdit,EM_LINEINDEX,nLine,0
		MOV txtrng.chrg.cpMin,EAX
		;Invoke SendMessage,hEdit,EM_LINELENGTH,EAX,0
		Invoke GetLineLength,hEdit,nLine
		 
		ADD EAX,txtrng.chrg.cpMin
		MOV txtrng.chrg.cpMax,EAX
		
		INC nLine
;		MOV txtrng.lpstrText, Offset prnbuff
		LEA EAX, prnbuff
		MOV txtrng.lpstrText, EAX
		Invoke SendMessage,hEdit,EM_GETTEXTRANGE,0,ADDR txtrng
		OR EAX,EAX
		JE El
		
		Invoke lstrlen,ADDR prnbuff
		MOV ECX,EAX
		Invoke TabbedTextOut,pd.hDC,ptX,ptY,ADDR prnbuff,ECX,1,ADDR tWt,ptX
		
		El:
		MOV EAX,pt.y
		ADD ptY,EAX
		JMP NxtLine
		
		Ep:
		Invoke EndPage,pd.hDC
		.If nMLine
			JMP NxtPage
		.EndIf
		
		Exx:
		Invoke EndDoc,pd.hDC
		Invoke DeleteDC,pd.hDC
		Invoke DeleteObject,hPrFont
		Invoke DeleteObject,hRgn
		POP EBX
	.EndIf
	RET
Print EndP

;HORZSIZE: Width in millimeters				197		; Depends on the paper selected ?
;VERTSIZE: Height in millimeters			285		; Depends on the paper selected ?
;HORZRES: Width in pixels					1009	; Depends on the paper selected ?
;VERTRES: Height in raster lines			2100	; Depends on the paper selected ?
;PHYSICALWIDTH: Printer page pixel width	1164	; Depends on the paper selected ?
;PHYSICALHEIGHT: Printer page pixel height	2250	; Depends on the paper selected ?
;PHYSICALOFFSETX: Printer page X Offset		75
;PHYSICALOFFSETY: Printer page Y Offset		75
