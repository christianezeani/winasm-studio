.CODE

ToolBoxProc Proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	.If uMsg == WM_SIZE
		MOV ECX,lParam
		MOV EDX,ECX
		AND ECX,0FFFFh 			;ECX holds the width of this window
		SUB ECX,2*XEDGE;4
		PUSH ECX
		SHR EDX,16				;EDX=height of this window
		SUB EDX,2*YEDGE+14
		Invoke MoveWindow,hToolBoxToolBar,XEDGE,YEDGE+14,ECX,EDX,TRUE
;	.ElseIf uMsg==WM_SHOWWINDOW
;		.If wParam
;			Invoke CheckMenuItem,hMenu,IDM_VIEW_OUTPUT,MF_CHECKED
;		.Else
;			Invoke CheckMenuItem,hMenu,IDM_VIEW_OUTPUT,MF_UNCHECKED
;		.EndIf
	.EndIf
	Invoke CallWindowProc,ADDR DockWndProc,hWnd,uMsg,wParam,lParam
	RET
ToolBoxProc EndP
