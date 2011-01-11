.CODE

DefaultMakeOptionsDlgProc Proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	.If uMsg == WM_INITDIALOG
	.ElseIf uMsg == WM_CLOSE
		Invoke EndDialog, hWnd,FALSE
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		SHR EAX,16
		.If AX==BN_CLICKED
			MOV EAX,wParam
			.If AX == 1		;OK
				Invoke EndDialog, hWnd, TRUE
			.ElseIf AX==2	;Cancel
				Invoke EndDialog, hWnd,FALSE
			.EndIf
		.EndIf
    .Else
        MOV EAX,FALSE
        RET
    .ENDIF
    MOV EAX, TRUE
	RET
DefaultMakeOptionsDlgProc EndP
