XEDGE					EQU 2
YEDGE					EQU 2

;Constants for fState
CLOSEBUTTONPRESSED		EQU 1
USERSIZING				EQU 2
USERDOCKINGUNDOCKING	EQU 3


BrushColor				EQU 0C0C0C0H

.DATA
szDockClass				DB "DockWindow",0

.DATA?
hActiveDock				DWORD ?
PEDockData				DOCKDATA <>	;Project Explorer
POutDockData			DOCKDATA <>	;Out Parent
TBDockData				DOCKDATA <>
RCOptionsDockData		DOCKDATA <>


hDragCursor				DWORD ?
.CODE

EnableAllDockWindows Proc Uses ESI fEnable:DWORD

	.If pDWBlock
		XOR ECX,ECX
		MOV EAX,pDWBlock
		@@:
		PUSH EAX
		PUSH ECX
		MOV ESI,[EAX+ECX]
		Invoke EnableWindow,ESI,fEnable
		Invoke GetParent,ESI
		.If EAX!=WinAsmHandles.hMain
			Invoke EnableWindow,EAX,fEnable
		.EndIf
		POP ECX
		POP EAX
		ADD ECX,4
		.If ECX<DWBlockSize
			JMP @B
		.EndIf
		
	.EndIf	
	RET
EnableAllDockWindows EndP

InvalidateAllDockWindows Proc; fEnable:DWORD

	.If pDWBlock
		
		XOR ECX,ECX
		MOV EAX,pDWBlock
		@@:
		PUSH EAX
		PUSH ECX
		MOV ESI,[EAX+ECX]
		Invoke InvalidateRect,ESI,NULL,FALSE
		Invoke GetParent,ESI
		.If EAX!=WinAsmHandles.hMain
			Invoke InvalidateRect,EAX,NULL,FALSE
			Invoke UpdateWindow,EAX
		.EndIf
		POP ECX
		POP EAX
		ADD ECX,4
		.If ECX<DWBlockSize
			JMP @B
		.EndIf
	.EndIf	
	RET
	
InvalidateAllDockWindows EndP

MoveFloatingWindow Proc Uses EBX lpWindowData:DWORD, hParent:HWND
	
	MOV EBX, lpWindowData
	;Look here! I am always moving the parent
	Invoke MoveWindow,hParent,[EBX].DOCKDATA.FocusRect.left,[EBX].DOCKDATA.FocusRect.top,[EBX].DOCKDATA.NoDock.dWidth,[EBX].DOCKDATA.NoDock.dHeight,TRUE
	Invoke UpdateWindow,hParent
	
	RET
MoveFloatingWindow EndP

DockWndProc Proc Uses EBX hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
Local Rect		:RECT
Local ps		:PAINTSTRUCT
Local hDC		:HDC
Local Point		:POINT
;Local lf		:LOGFONT

	.If uMsg==WM_SHOWWINDOW
		Invoke GetParent,hWnd
		.If EAX !=WinAsmHandles.hMain
			.If wParam
				Invoke ShowWindow,EAX,SW_SHOW
				Invoke UpdateWindow,hWnd
			.Else
				Invoke ShowWindow,EAX,SW_HIDE
			.EndIf
		.EndIf
	;.ElseIf uMsg==WM_SETFOCUS
	;	Invoke SetFocus,WinAsmHandles.hMain
	.ElseIf uMsg == WM_NOTIFY
		MOV EAX,lParam
		.If [EAX].NMHDR.code==TTN_NEEDTEXT
			Invoke SetWindowPos,[EAX].NMHDR.hwndFrom,HWND_TOP,0,0,0,0,SWP_NOACTIVATE OR SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER
		.EndIf
		
	.ElseIf uMsg==WM_WINDOWPOSCHANGED	;I need to check this AFTER the window is shown or hidden
		Invoke GetParent,hWnd
		.If EAX==WinAsmHandles.hMain
			MOV EBX,lParam
			MOV EDX,[EBX].WINDOWPOS.flags
			AND EDX,SWP_SHOWWINDOW or SWP_HIDEWINDOW
			.If EDX==SWP_HIDEWINDOW || EDX==SWP_SHOWWINDOW
				Invoke ClientResize
				;Invoke UpdateWindow,hWnd
			.EndIf
		.EndIf
		
	.ElseIf uMsg==WM_PAINT
		Invoke GetWindowLong,hWnd,GWL_STYLE
		AND EAX,WS_POPUP
		.If !EAX
			Invoke BeginPaint,hWnd,ADDR ps
			;Invoke GetDC,hWnd
			MOV hDC,EAX
			
			Invoke GetClientRect,hWnd,Addr Rect
			MOV Rect.left,XEDGE
			SUB Rect.right,XEDGE
			MOV EAX,YEDGE
			MOV Rect.top,EAX
			ADD EAX,12			;I want the caption's height to be 12 pixels
			MOV Rect.bottom,EAX
			
			Invoke GetWindowLong,hWnd,GWL_STYLE
			AND EAX,0FFFFh
			.If EAX==STYLE_GRADIENTTITLE
				Invoke GetForegroundWindow
				PUSH EAX
				Invoke GetParent,EAX
				POP ECX
				.If EAX==WinAsmHandles.hMain || ECX==WinAsmHandles.hMain
					Invoke DrawCaption,hWnd,hDC,ADDR Rect,DC_SMALLCAP OR DC_GRADIENT OR  DC_TEXT or DC_ACTIVE
				.Else
					Invoke DrawCaption,hWnd,hDC,ADDR Rect,DC_SMALLCAP OR DC_GRADIENT OR  DC_TEXT
				.EndIf
			.ElseIf EAX==STYLE_TWOLINESTITLE
				PUSH Rect.bottom
				PUSH Rect.right
				SUB Rect.right,16;3	;i.e The x button will be 10 pixels wide
				
				PUSH Rect.top
				ADD Rect.top,3
				
				MOV EAX,Rect.top
				ADD EAX,2
				MOV Rect.bottom,EAX
				Invoke DrawEdge,hDC,ADDR Rect,BDR_RAISEDINNER,BF_RECT
				
				ADD Rect.top,4
				MOV EAX,Rect.top
				ADD EAX,2
				MOV Rect.bottom,EAX
				Invoke DrawEdge,hDC,ADDR Rect,BDR_RAISEDINNER,BF_RECT
				POP Rect.top
				POP Rect.right
				POP Rect.bottom
			.Else		;STYLE_ONELINETITLE
				PUSH Rect.bottom
				PUSH Rect.right
				SUB Rect.right,16;3	;i.e The x button will be 10 pixels wide
				
				PUSH Rect.top
				ADD Rect.top,5
				
				MOV EAX,Rect.top
				ADD EAX,2
				MOV Rect.bottom,EAX
				Invoke DrawEdge,hDC,ADDR Rect,BDR_RAISEDINNER,BF_RECT
				POP Rect.top
				POP Rect.right
				POP Rect.bottom
			.EndIf
			
			INC Rect.top
			DEC Rect.bottom
			DEC Rect.right		;i.e Just to be one pixel left from the caption
			MOV EAX,Rect.right
			SUB EAX,10
			MOV Rect.left,EAX	;i.e The x button will be 10 pixels wide
			;Draw Close Button
			Invoke GetWindowLong,hWnd,0
			.If DOCKDATA.fState[EAX]==CLOSEBUTTONPRESSED
				Invoke DrawFrameControl, hDC, ADDR Rect, DFC_CAPTION, DFCS_CAPTIONCLOSE or DFCS_PUSHED; or DFCS_FLAT
			.Else
				Invoke DrawFrameControl, hDC, ADDR Rect, DFC_CAPTION, DFCS_CAPTIONCLOSE; or DFCS_FLAT
			.EndIf
			;Invoke ReleaseDC,hWnd,hDC
			Invoke EndPaint,hWnd,ADDR ps
		.EndIf
	.ElseIf uMsg == WM_COMMAND
		HIWORD wParam
		.If EAX == 0; || 1 ; 0 is a menu, 1 is an accelerator. Toolbar messages act like menu messages...
			Invoke GetWindowLong,hWnd,GWL_STYLE
			MOV EBX,EAX
			AND EBX,0FFFF0000h
			LOWORD wParam
			.If EAX>=IDM_STYLE_GRADIENTTITLE && EAX<=IDM_STYLE_ONELINETITLE	;Because if menu or toolbar is placed on the docking windows-->the style will be changed unnecessarily!!!
				.If EAX == IDM_STYLE_GRADIENTTITLE
					OR EBX,STYLE_GRADIENTTITLE
				.ElseIf EAX==IDM_STYLE_TWOLINESTITLE
					OR EBX,STYLE_TWOLINESTITLE
				.ElseIf EAX==IDM_STYLE_ONELINETITLE
					OR EBX,STYLE_ONELINETITLE
				.EndIf
				Invoke SetWindowLong,hWnd,GWL_STYLE,EBX
				Invoke InvalidateRect,hWnd,NULL,TRUE
			.EndIf
		.EndIf
		
	.ElseIf uMsg==WM_CONTEXTMENU
		Invoke GetCapture
		MOV EBX,EAX
		Invoke GetParent,EAX
		.If EBX!=hWnd && EAX!=hWnd;in case while user moving the focus rectangle presses the right button ---> do not show context menu.
			.If lParam==0FFFFFFFFh
				Invoke GetWindowRect,hWnd,ADDR Rect
				MOV EAX,Rect.left
				MOV Point.x,EAX
				MOV EAX,Rect.top
				MOV Point.y,EAX
				JMP ShowIt
			.Else
				MOV EAX,lParam
				AND EAX,0FFFFh
				MOV Point.x,EAX
				MOV EAX,lParam
				SHR EAX,16
				MOV Point.y,EAX
			.EndIf
			
			Invoke ScreenToClient,hWnd,ADDR Point
			Invoke SendMessage,hWnd,WAM_GETCLIENTRECT,0,ADDR Rect
			Invoke PtInRect,ADDR Rect,Point.x,Point.y
			.If !EAX	;i.e. not in "client" area
				Invoke ClientToScreen,hWnd,ADDR Point
				
				ShowIt:
				
				PUSH EDI
				Invoke GetWindowLong,hWnd,GWL_STYLE
				AND EAX,0FFFFh
				.If EAX==STYLE_GRADIENTTITLE
					MOV EDI,0
				.ElseIf EAX==STYLE_TWOLINESTITLE
					MOV EDI,1
				.Else;If EAX==STYLE_ONELINETITLE
					MOV EDI,2
				.EndIf
				
				Invoke CreatePopupMenu
				MOV EBX,EAX
				
				MOV ECX,MF_STRING
				.If !EDI
					OR ECX,MF_CHECKED
				.EndIf
				Invoke AppendMenu,EBX,ECX,IDM_STYLE_GRADIENTTITLE,Offset szGradient	;"Gradient"
				
				MOV ECX,MF_STRING
				.If EDI==1
					OR ECX,MF_CHECKED
				.EndIf
				Invoke AppendMenu,EBX,ECX,IDM_STYLE_TWOLINESTITLE,Offset szDoubleLine	;"Double Line"
				
				MOV ECX,MF_STRING
				.If EDI==2
					OR ECX,MF_CHECKED
				.EndIf
				Invoke AppendMenu,EBX,ECX,IDM_STYLE_ONELINETITLE,Offset szSingleLine	;"Single Line"
				
				Invoke TrackPopupMenu,EBX,TPM_LEFTALIGN or TPM_RIGHTBUTTON,Point.x,Point.y,0,hWnd,0
				Invoke DestroyMenu,EBX
				POP EDI
				XOR EAX,EAX
				RET
			.EndIf
		.EndIf
		
	.ElseIf uMsg==WM_LBUTTONDOWN
		Invoke KillTimer,WinAsmHandles.hMain,200
		Invoke GetWindowLong,hWnd,0
		MOV EBX,EAX
		
		LOWORD lParam
		MOV Point.x,EAX
		HIWORD lParam
		MOV Point.y,EAX
		
		Invoke GetClientRect,hWnd,ADDR Rect
		MOV Rect.left,XEDGE
		SUB Rect.right,XEDGE
		SUB Rect.right,11	;i.e. exclude x button width
		MOV EAX,YEDGE
		MOV Rect.top,EAX
		ADD EAX,13			;I want the caption's height to be 13 pixels
		MOV Rect.bottom,EAX
		;Now Rect holds the caption area
		Invoke PtInRect,ADDR Rect,Point.x,Point.y
		.If EAX	;User pressed caption
			MOV EAX,hWnd
			.If EAX==WinAsmHandles.hProjExplorer || EAX==WinAsmHandles.hOutParent
				MOV hActiveDock,EAX
			.EndIf
			
			.If pDWBlock
				MOV ECX,4
				MOV EAX,pDWBlock
				
				@@:
				MOV EDX,DWORD PTR [EAX+ECX-4]
				.If EDX==hWnd
					.If ECX<DWBlockSize
						OnceMore:
						PUSH DWORD PTR [EAX+ECX]
						POP DWORD PTR [EAX+ECX-4]		;.ie. we move the handle one position above
						ADD ECX,4
						.If ECX<DWBlockSize
							JMP OnceMore
						.Else
							PUSH hWnd
							POP DWORD PTR [EAX+ECX-4]		;.ie. we move the handle one position above
							JMP Done
						.EndIf
					.Else
						PUSH hWnd
						POP DWORD PTR [EAX+ECX-4]		;.ie. we move the handle one position above
						JMP Done
					.EndIf
				.EndIf
				.If ECX<DWBlockSize
					ADD ECX,4
					JMP @B
				.EndIf
			.EndIf	
			
			Done:		
			Invoke SetCapture,hWnd
			Invoke LoadCursor,hInstance,107;IDC_DRAGCURSOR
			MOV hDragCursor,EAX
			Invoke SetCursor,EAX
			MOV DOCKDATA.fState[EBX],USERDOCKINGUNDOCKING
			
			PUSH EDI
			Invoke GetParent,hWnd
			.If EAX==WinAsmHandles.hMain
				MOV EDI,hWnd
			.Else	;i.e. floating
				MOV EDI,EAX
			.EndIf
			;Invoke GetWindowRect,hWnd,ADDR DOCKDATA.FocusRect[EBX]
			Invoke GetWindowRect,EDI,ADDR [EBX].DOCKDATA.FocusRect
			
			
			;-----------------------------------------------------
			;This is needed ONLY for the NoDock Drawing of focus Rectangle
			MOV EAX,[EBX].DOCKDATA.FocusRect.right
			SUB EAX,[EBX].DOCKDATA.FocusRect.left
			Invoke MulDiv,Point.x,[EBX].DOCKDATA.NoDock.dWidth,EAX
			MOV DOCKDATA.MousePos.x[EBX],EAX
			MOV EAX,Point.y
			MOV DOCKDATA.MousePos.y[EBX],EAX
			.If EDI!=hWnd	;i.e. floating
				Invoke GetSystemMetrics,SM_CXSIZEFRAME
				ADD DOCKDATA.MousePos.x[EBX],EAX
				
				Invoke GetSystemMetrics,SM_CYSIZEFRAME
				ADD DOCKDATA.MousePos.y[EBX],EAX

			.EndIf
			;-----------------------------------------------------
			POP EDI
			Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
		.Else
			Invoke GetClientRect,hWnd,ADDR Rect
			.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
				.If Point.x<XEDGE
					MOV DOCKDATA.fState[EBX],USERSIZING
				.Else
					MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.ElseIf DOCKDATA.fDockedTo[EBX]==LEFTDOCK
				MOV ECX,Rect.right
				SUB ECX,XEDGE
				.If Point.x>=ECX
					MOV DOCKDATA.fState[EBX],USERSIZING
				.Else
					MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.ElseIf  DOCKDATA.fDockedTo[EBX]==TOPDOCK
				MOV ECX, Rect.bottom
				SUB ECX,YEDGE
				.If Point.y>=ECX
					MOV DOCKDATA.fState[EBX],USERSIZING
				.Else
					MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.ElseIf  DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
				.If Point.y<YEDGE	;e.g. If edge is 5 --> show size from 0 to 4
					MOV DOCKDATA.fState[EBX],USERSIZING
				.Else
					MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.Else
				MOV DOCKDATA.fState[EBX],NULL
			.EndIf
			
			.If DOCKDATA.fState[EBX]==USERSIZING
				Invoke SetCapture,hWnd
				Invoke GetWindowRect,hClient,ADDR Rect
				.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
					ADD Rect.left,8*XEDGE
					PUSH Rect.left
					Invoke GetWindowRect,hWnd,ADDR Rect
					POP Rect.left
					SUB Rect.right,8*XEDGE
					Invoke LoadCursor,NULL,IDC_SIZEWE
				.ElseIf DOCKDATA.fDockedTo[EBX]==LEFTDOCK
					SUB Rect.right,8*XEDGE
					PUSH Rect.right
					Invoke GetWindowRect,hWnd,ADDR Rect
					POP Rect.right
					ADD Rect.left,8*XEDGE
					Invoke LoadCursor,NULL,IDC_SIZEWE
				.ElseIf DOCKDATA.fDockedTo[EBX]==TOPDOCK
					SUB Rect.bottom,8*YEDGE
					PUSH Rect.bottom
					Invoke GetWindowRect,hWnd,ADDR Rect
					POP Rect.bottom
					ADD Rect.top,8*YEDGE
					Invoke LoadCursor,NULL,IDC_SIZENS
				.ElseIf DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
					ADD Rect.top,8*YEDGE
					PUSH Rect.top
					Invoke GetWindowRect,hWnd,ADDR Rect
					POP Rect.top
					SUB Rect.bottom,8*YEDGE
					Invoke LoadCursor,NULL,IDC_SIZENS
				.EndIf
				
				Invoke SetCursor,EAX
				Invoke RtlMoveMemory,ADDR DOCKDATA.MousePos[EBX],ADDR Point,SizeOf POINT
				Invoke GetWindowRect,hWnd,ADDR DOCKDATA.FocusRect[EBX]
				;CALL DrawRectangle
				Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
				Invoke ClipCursor,ADDR Rect
			.Else
				Invoke GetClientRect,hWnd,ADDR Rect
				MOV Rect.left,XEDGE
				SUB Rect.right,XEDGE
				SUB Rect.right,11	;i.e. exclude x button width
				MOV EAX,YEDGE
				MOV Rect.top,EAX
				ADD EAX,13			;I want the caption's height to be 13 pixels
				MOV Rect.bottom,EAX
				
				M2M Rect.left,Rect.right	; Now I am checking for x button
				ADD Rect.right,11
				Invoke PtInRect,ADDR Rect,Point.x,Point.y
				.If EAX	;User pressed x button
					Invoke SetCapture,hWnd
					MOV DOCKDATA.fState[EBX],CLOSEBUTTONPRESSED
					Invoke InvalidateRect,hWnd,NULL,FALSE
				.EndIf
			.EndIf
		.EndIf	
	.ElseIf uMsg==WM_LBUTTONUP
		Invoke SetTimer,WinAsmHandles.hMain,200,200,NULL
		
		Invoke GetCapture
		.If EAX==hWnd
			Invoke GetWindowLong,hWnd,0
			MOV EBX,EAX
			.If DOCKDATA.fState[EBX]==CLOSEBUTTONPRESSED
				Invoke ReleaseCapture
				
				LOWORD lParam
				MOV Point.x,EAX
				HIWORD lParam
				MOV Point.y,EAX
				
				Invoke GetClientRect,hWnd,ADDR Rect
				SUB Rect.right,XEDGE
				MOV ECX,Rect.right
				SUB ECX,11
				MOV Rect.left,ECX
				
				MOV EAX,YEDGE
				MOV Rect.top,EAX
				ADD EAX,13	;I always need caption height 13 pixels
				MOV Rect.bottom,EAX
				
				Invoke PtInRect,ADDR Rect,Point.x,Point.y
				.If EAX	;User relesed mouse in x button area
					Invoke GetParent,hWnd
					.If EAX==WinAsmHandles.hMain
						Invoke ShowWindow,hWnd,SW_HIDE
					.Else
						Invoke ShowWindow,EAX,SW_HIDE
						Invoke ShowWindow,hWnd,SW_HIDE
					.EndIf
					Invoke ClientResize
				.Else
					Invoke InvalidateRect,hWnd,NULL,FALSE	;Draw unpresed state
				.EndIf
			.Else
				;CALL DrawRectangle
				Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
				Invoke ReleaseCapture	
				
				.If DOCKDATA.fState[EBX]==USERDOCKINGUNDOCKING && DOCKDATA.fDockedTo[EBX] == NODOCK && DOCKDATA.fDockTo[EBX] == NODOCK
					MOV DOCKDATA.fDockedTo[EBX],NODOCK
					Invoke GetParent,hWnd
					Invoke MoveFloatingWindow,EBX,EAX
				.Else
					;Invoke LockWindowUpdate,hClient
					Invoke ClientResize
					;Invoke LockWindowUpdate,0
				.EndIf
				
				Invoke DestroyCursor,hDragCursor	;If User is Docking/Undocking
				;Invoke ReleaseCapture
				;Needed for User Sizing
				Invoke ClipCursor,NULL
			.EndIf
			MOV DOCKDATA.fState[EBX],NULL
		.EndIf
	.ElseIf uMsg==WM_MOUSEMOVE
		Invoke GetCapture
		.If EAX==hWnd
			Invoke GetWindowLong,hWnd,0
			MOV EBX,EAX
			.If [EBX].DOCKDATA.fState==USERDOCKINGUNDOCKING
				LOWORD lParam
				MOV Point.x,EAX
				HIWORD lParam
				MOV Point.y,EAX
				
				.If Point.x>7FFFh	;x and y of mouse move are 16-bit-->make them 32-bit
					OR Point.x,0FFFF0000h
				.EndIf
				.If Point.y>7FFFh	;x and y of mouse move are 16-bit-->make them 32-bit
					OR Point.y,0FFFF0000h
				.EndIf
				
				Invoke ClientToScreen,hWnd,ADDR Point
				;Now Point is where the mouse is in Screen coordinates
				
				MOV EAX,wParam
				AND EAX,MK_CONTROL
				.If EAX==MK_CONTROL	;If user is pressing control-->do not dock (Thanks andrew_k)
					CALL NoDock
					RET
				.EndIf
				
				Invoke WindowFromPoint,Point.x,Point.y
				PUSH EAX
				Invoke GetParent,EAX
				MOV ECX,EAX
				POP EAX
				.If EAX==hWnd || ECX ==hWnd
					Invoke GetWindowRect,hClient,ADDR Rect
					.If [EBX].DOCKDATA.fDockedTo == LEFTDOCK
						CALL DockToLeft
					.ElseIf [EBX].DOCKDATA.fDockedTo == RIGHTDOCK
						CALL DockToRight
					.ElseIf [EBX].DOCKDATA.fDockedTo == TOPDOCK
						CALL DockToTop
					.ElseIf [EBX].DOCKDATA.fDockedTo == BOTTOMDOCK
						CALL DockToBottom
					.Else
						CALL NoDock
					.EndIf
				.Else
					Invoke GetWindowRect,hClient,ADDR Rect
					SUB Rect.left,21
					.If Rect.left>7FFFFFFFh
						MOV Rect.left,0
					.EndIf
						
					SUB Rect.top,21
					.If Rect.top>7FFFFFFFh
						MOV Rect.top,0
					.EndIf
					
					ADD Rect.right,21
					ADD Rect.bottom,21
					MOV EAX,Point.x
					MOV ECX,Point.y
					
					.If EAX>Rect.left && EAX <Rect.right && ECX>Rect.top && ECX<Rect.bottom
						Invoke GetWindowRect,hClient,ADDR Rect
						
						MOV EAX,Rect.left
						ADD EAX,20
						MOV ECX,Rect.left
						SUB ECX,20
						
						.If ECX>7FFFFFFFh
						 	MOV ECX,0
						.EndIf
						.If Point.x>=ECX && Point.x<=EAX	;Dock to the left
							CALL DockToLeft
						.Else
							MOV EAX,Rect.right
							ADD EAX,20
							
							MOV ECX,Rect.right
							SUB ECX,20
							.If Point.x>=ECX && Point.x<=EAX	;Dock to the right
								CALL DockToRight
							.Else
								MOV EAX,Rect.top
								ADD EAX,20
								
								MOV ECX,Rect.top
								SUB ECX,20
								.If ECX>7FFFFFFFh
								 	MOV ECX,0
								.EndIf
								
								.If Point.y>=ECX && Point.y<=EAX	;Dock to the top
									CALL DockToTop
								.Else
									MOV EAX,Rect.bottom
									ADD EAX,20
									
									MOV ECX,Rect.bottom
									SUB ECX,20
									.If Point.y>=ECX && Point.y<=EAX	;Dock to the bottom
										CALL DockToBottom
									.Else
										CALL NoDock
									.EndIf
								.EndIf
							.EndIf
						.EndIf
					.Else
						Invoke GetWindowRect,hClient,ADDR Rect
						CALL NoDock
					.EndIf
				.EndIf
			.ElseIf	[EBX].DOCKDATA.fState==USERSIZING
				Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
				.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK || DOCKDATA.fDockedTo[EBX]==LEFTDOCK
					Invoke LoadCursor,NULL,IDC_SIZEWE
				.Else
					Invoke LoadCursor,NULL,IDC_SIZENS
				.EndIf
				Invoke SetCursor,EAX
				LOWORD lParam
				MOV Point.x,EAX
				HIWORD lParam
				MOV Point.y,EAX
				.If Point.x>7FFFh	;x and y of mouse move are 16-bit-->make them 32-bit
					OR Point.x,0FFFF0000h
				.EndIf
				.If Point.y>7FFFh	;x and y of mouse move are 16-bit-->make them 32-bit
					OR Point.y,0FFFF0000h
				.EndIf
				
				MOV ECX,Point.x	
				MOV EAX,DOCKDATA.MousePos.x[EBX]
				SUB ECX,EAX
				
				MOV EAX,DOCKDATA.MousePos.y[EBX]
				MOV EDX,Point.y
				SUB EDX,EAX
				.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
					ADD DOCKDATA.FocusRect.left[EBX],ECX
				.ElseIf DOCKDATA.fDockedTo[EBX]==LEFTDOCK
					ADD DOCKDATA.FocusRect.right[EBX],ECX
				.ElseIf DOCKDATA.fDockedTo[EBX]==TOPDOCK
					ADD DOCKDATA.FocusRect.bottom[EBX],EDX
				.ElseIf DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
					ADD DOCKDATA.FocusRect.top[EBX],EDX
				.EndIf
				;CALL DrawRectangle
				Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
				Invoke RtlMoveMemory,ADDR DOCKDATA.MousePos[EBX],ADDR Point,SizeOf POINT
			.EndIf
			
		;We haven't captured mouse yet	
		.Else	;Here I need to check if mouse is over the edge and WHICH EDGE
			LOWORD lParam
			MOV Point.x,EAX
			HIWORD lParam
			MOV Point.y,EAX
			Invoke GetWindowLong,hWnd,0
			MOV EBX,EAX
			Invoke GetClientRect,hWnd,ADDR Rect
			.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
				.If Point.x<XEDGE	;e.g. If edge is 5 --> show size from 0 to 4
					Invoke LoadCursor,NULL,IDC_SIZEWE
					Invoke SetCursor,EAX
					;MOV DOCKDATA.fState[EBX],USERSIZING
				;.Else
					;MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.ElseIf DOCKDATA.fDockedTo[EBX]==LEFTDOCK
				MOV ECX,Rect.right
				SUB ECX,XEDGE
				.If Point.x>=ECX
					Invoke LoadCursor,NULL,IDC_SIZEWE
					Invoke SetCursor,EAX
					;MOV DOCKDATA.fState[EBX],USERSIZING
				;.Else
					;MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.ElseIf  DOCKDATA.fDockedTo[EBX]==TOPDOCK
				MOV ECX, Rect.bottom
				SUB ECX,YEDGE
				.If Point.y>=ECX
					Invoke LoadCursor,NULL,IDC_SIZENS
					Invoke SetCursor,EAX
					;MOV DOCKDATA.fState[EBX],USERSIZING
				;.Else
					;MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.ElseIf  DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
				.If Point.y<YEDGE	;e.g. If edge is 5 --> show size from 0 to 4
					Invoke LoadCursor,NULL,IDC_SIZENS
					Invoke SetCursor,EAX
					;MOV DOCKDATA.fState[EBX],USERSIZING
				;.Else
					;MOV DOCKDATA.fState[EBX],NULL
				.EndIf
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_SIZE
		Invoke GetWindowLong,hWnd,GWL_STYLE
		AND EAX,WS_POPUP
		.If EAX	;ie this is a float window
			Invoke GetWindow,hWnd,GW_CHILD
			.If EAX
				PUSH EDI
				MOV EDI,EAX
				Invoke GetClientRect,hWnd,ADDR Rect
				;Make its child Docking window exaclty equal to the client area
				Invoke MoveWindow,EDI,Rect.left,Rect.top,Rect.right,Rect.bottom,TRUE
				Invoke GetWindowLong,hWnd,0
				MOV EBX,EAX
				
				Invoke GetWindowRect,hWnd,ADDR [EBX].DOCKDATA.FocusRect
				MOV EAX,[EBX].DOCKDATA.FocusRect.right
				SUB EAX,[EBX].DOCKDATA.FocusRect.left
				MOV DOCKDATA.NoDock.dWidth[EBX],EAX
				
				MOV EAX,[EBX].DOCKDATA.FocusRect.bottom
				SUB EAX,[EBX].DOCKDATA.FocusRect.top
				MOV DOCKDATA.NoDock.dHeight[EBX],EAX
				
;				Invoke GetWindowRect,EDI,ADDR [EBX].DOCKDATA.FocusRect
;				Invoke GetWindowRect,hWnd,ADDR Rect
;				MOV EAX,Rect.right
;				SUB EAX,Rect.left
;				MOV DOCKDATA.NoDock.dWidth[EBX],EAX
;				MOV EAX,Rect.bottom
;				SUB EAX,Rect.top
;				MOV DOCKDATA.NoDock.dHeight[EBX],EAX
				POP EDI
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_MOVE
		Invoke GetWindowLong,hWnd,GWL_STYLE
		AND EAX,WS_POPUP
		.If EAX	;ie this is a float window
			Invoke GetWindowLong,hWnd,0
			.If EAX	&& DOCKDATA.fDockedTo[EAX]==NODOCK 
				MOV EBX,EAX
				LEA EDX,Rect
				Invoke GetWindowRect,hWnd,EDX
				M2M DOCKDATA.NoDock.dLeft[EBX],Rect.left
				M2M DOCKDATA.NoDock.dTop[EBX],Rect.top
			.EndIf
		.EndIf
	.ElseIf uMsg==WM_LBUTTONDBLCLK
		Invoke GetWindowLong,hWnd,0
		.If EAX	&& [EAX].DOCKDATA.fDockedTo!=NODOCK
			MOV EBX,EAX
			MOV EAX,[EBX].DOCKDATA.NoDock.dLeft
			MOV [EBX].DOCKDATA.FocusRect.left,EAX
			ADD EAX,[EBX].DOCKDATA.NoDock.dWidth
			MOV [EBX].DOCKDATA.FocusRect.right,EAX
			
			MOV EAX,[EBX].DOCKDATA.NoDock.dTop
			MOV [EBX].DOCKDATA.FocusRect.top,EAX
			ADD EAX,[EBX].DOCKDATA.NoDock.dHeight
			MOV [EBX].DOCKDATA.FocusRect.bottom,EAX
			
			MOV DOCKDATA.fDockTo[EBX],NODOCK
			Invoke ClientResize
		.EndIf
	.ElseIf uMsg==WAM_GETCLIENTRECT
		Invoke GetClientRect,hWnd,lParam;ADDR Rect
		MOV EAX,lParam
		ADD [EAX].RECT.left,XEDGE
		SUB [EAX].RECT.right,XEDGE;2*XEDGE
		ADD [EAX].RECT.top,YEDGE+14
		SUB [EAX].RECT.bottom,YEDGE;2*YEDGE+14
	.ElseIf uMsg==WAM_DESTROYDOCKINGWINDOW
		.If pDWBlock
			MOV ECX,4
			MOV EAX,pDWBlock
			
			@@:
			MOV EDX,DWORD PTR [EAX+ECX-4]
			.If EDX==hWnd
				.If ECX<DWBlockSize
					OnceMoree:
					PUSH DWORD PTR [EAX+ECX]
					POP DWORD PTR [EAX+ECX-4]		;.ie. we move the handle one position above
					ADD ECX,4
					.If ECX<DWBlockSize
						JMP OnceMoree
					.Else
						PUSH hWnd
						POP DWORD PTR [EAX+ECX-4]		;.ie. we move the handle one position above
						JMP Donee
					.EndIf
				.Else
					PUSH hWnd
					POP DWORD PTR [EAX+ECX-4]		;.ie. we move the handle one position above
					JMP Donee
				.EndIf
			.EndIf
			.If ECX<DWBlockSize
				ADD ECX,4
				JMP @B
			.EndIf
		.EndIf	
		
		Donee:		
		;Now hWnd is last in the pDWBlock
		;Therefore:
		SUB DWBlockSize,4
		
		Invoke GetParent,hWnd
		.If EAX==WinAsmHandles.hMain
			MOV EAX,hWnd
		.EndIf
		
		PUSH EAX
		Invoke GetWindowLong,EAX,0
		MOV [EAX].DOCKDATA.fDockTo,10		;<---------------Only a flag to test in WM_CLOSE
		POP EAX
		
		Invoke DestroyWindow,EAX
		Invoke ClientResize
		
	.ElseIf uMsg==WM_CLOSE
		Invoke GetWindowLong,hWnd,0
		.If [EAX].DOCKDATA.fDockTo!=10	;This is only set from WAM_DESTROYDOCKINGWINDOW otherwise do NOT destroy docking window
			XOR EAX,EAX
			RET
		.EndIf
	.EndIf
	
	Invoke DefWindowProc,hWnd,uMsg,wParam,lParam	   ;Default message processing
	RET
	;------------------------------------------------------------------------
	DockToTop:
	.If DOCKDATA.fDockTo[EBX] != TOPDOCK
		MOV DOCKDATA.fDockTo[EBX],TOPDOCK
		;Erase existing Focus Rectangle!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
		.If DOCKDATA.fDockedTo[EBX]==TOPDOCK	;i.e Already Docked to Top
			Invoke GetWindowRect,hWnd,ADDR DOCKDATA.FocusRect[EBX]
		.Else
			MOV EAX,Rect.left
			MOV DOCKDATA.FocusRect.left[EBX],EAX
			MOV EAX,Rect.right
			.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
				ADD EAX,DOCKDATA.DockRightWidth[EBX]			
			.EndIf
			MOV DOCKDATA.FocusRect.right[EBX],EAX
			MOV EAX,Rect.bottom
			MOV ECX,Rect.top
			MOV DOCKDATA.FocusRect.top[EBX],ECX
			SUB EAX,ECX
			.If DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
				ADD EAX,DOCKDATA.DockBottomHeight[EBX]			
			.EndIf
			.If DOCKDATA.DockTopHeight[EBX]>EAX
				ADD ECX,EAX
			.Else
				ADD ECX,DOCKDATA.DockTopHeight[EBX]
			.EndIf
			MOV DOCKDATA.FocusRect.bottom[EBX],ECX
			.If DOCKDATA.fDockedTo[EBX]==LEFTDOCK	;i.e Already Docked to left
				MOV EAX,Rect.left
				SUB EAX,DOCKDATA.DockLeftWidth[EBX]
				MOV DOCKDATA.FocusRect.left[EBX],EAX
			.EndIf
		.EndIf
		;Draw It!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
	.EndIf
	RETN
	;------------------------------------------------------------------------
	DockToBottom:
	.If DOCKDATA.fDockTo[EBX] != BOTTOMDOCK
		MOV DOCKDATA.fDockTo[EBX],BOTTOMDOCK
		;Erase existing Focus Rectangle!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
		.If DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK	;i.e Already Docked to bottom
			Invoke GetWindowRect,hWnd,ADDR DOCKDATA.FocusRect[EBX]
		.Else
			MOV ECX,Rect.right
			MOV EAX,Rect.left
			MOV DOCKDATA.FocusRect.left[EBX],EAX
			SUB ECX,EAX
			ADD EAX,ECX
			.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
				ADD EAX,DOCKDATA.DockRightWidth[EBX]			
			.EndIf
			MOV DOCKDATA.FocusRect.right[EBX],EAX
			MOV EAX,Rect.bottom
			MOV DOCKDATA.FocusRect.bottom[EBX],EAX
			MOV ECX,Rect.top
			SUB EAX,ECX	;Client Rectangle height
			.If DOCKDATA.fDockedTo[EBX]==TOPDOCK
				ADD EAX,DOCKDATA.DockTopHeight[EBX]			
			.EndIf
			.If DOCKDATA.DockBottomHeight[EBX]>EAX
				MOV DOCKDATA.FocusRect.top[EBX],ECX
			.Else
				MOV ECX,Rect.bottom
				SUB ECX,DOCKDATA.DockBottomHeight[EBX]
				MOV DOCKDATA.FocusRect.top[EBX],ECX
			.EndIf
			.If DOCKDATA.fDockedTo[EBX]==LEFTDOCK	;i.e Already Docked to left
				MOV EAX,Rect.left
				SUB EAX,DOCKDATA.DockLeftWidth[EBX]
				MOV DOCKDATA.FocusRect.left[EBX],EAX
			.EndIf
		.EndIf
		;Draw It!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
	.EndIf

	RETN
	;------------------------------------------------------------------------
	DockToLeft:
	.If DOCKDATA.fDockTo[EBX] != LEFTDOCK
		MOV DOCKDATA.fDockTo[EBX],LEFTDOCK
		;Erase existing Focus Rectangle!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
		.If DOCKDATA.fDockedTo[EBX]==LEFTDOCK	;i.e Already Docked to left
			Invoke GetWindowRect,hWnd,ADDR DOCKDATA.FocusRect[EBX]
		.Else
			MOV EAX,Rect.right
			MOV ECX,Rect.left
			MOV DOCKDATA.FocusRect.left[EBX],ECX
			SUB EAX,ECX	;Client Width
			.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
				ADD EAX,DOCKDATA.DockRightWidth[EBX]			
			.EndIf
			.If DOCKDATA.DockLeftWidth[EBX]>EAX
				ADD ECX,EAX
			.Else
				ADD ECX,DOCKDATA.DockLeftWidth[EBX]
			.EndIf
			
			MOV DOCKDATA.FocusRect.right[EBX],ECX
			.If DOCKDATA.fDockedTo[EBX]==TOPDOCK	;i.e Already Docked to top
				MOV EAX,Rect.top
				SUB EAX,DOCKDATA.DockTopHeight[EBX]
				MOV DOCKDATA.FocusRect.top[EBX],EAX
				MOV EAX,Rect.bottom
				MOV DOCKDATA.FocusRect.bottom[EBX],EAX
			.ElseIf DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
				MOV EAX,Rect.top
				MOV DOCKDATA.FocusRect.top[EBX],EAX
				MOV EAX,Rect.bottom
				ADD EAX, DOCKDATA.DockBottomHeight[EBX]
				MOV DOCKDATA.FocusRect.bottom[EBX],EAX
			.Else
				MOV EAX,Rect.top
				MOV DOCKDATA.FocusRect.top[EBX],EAX
				MOV EAX,Rect.bottom
				MOV DOCKDATA.FocusRect.bottom[EBX],EAX
			.EndIf
		.EndIf	
		;Draw It!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
	.EndIf
	RETN
	;------------------------------------------------------------------------
	DockToRight:
	;-----------
	.If DOCKDATA.fDockTo[EBX] != RIGHTDOCK
		MOV DOCKDATA.fDockTo[EBX],RIGHTDOCK
		;Erase existing Focus Rectangle!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
		MOV EAX,Rect.top
		MOV DOCKDATA.FocusRect.top[EBX],EAX
		MOV EAX,Rect.bottom
		MOV DOCKDATA.FocusRect.bottom[EBX],EAX
		.If DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
			Invoke GetWindowRect,hWnd,ADDR DOCKDATA.FocusRect[EBX]
		.Else
			MOV EAX,Rect.right
			MOV DOCKDATA.FocusRect.right[EBX],EAX
			MOV ECX,EAX
			SUB EAX,Rect.left	;Client Width
			.If DOCKDATA.fDockedTo[EBX]==LEFTDOCK
				ADD EAX,DOCKDATA.DockLeftWidth[EBX]			
			.EndIf
			.If DOCKDATA.DockLeftWidth[EBX]<EAX
				SUB ECX,DOCKDATA.DockRightWidth[EBX]
			.Else
				SUB ECX,EAX
			.EndIf
			MOV DOCKDATA.FocusRect.left[EBX],ECX
			.If DOCKDATA.fDockedTo[EBX]==TOPDOCK	;i.e Docked to top
				MOV EAX,Rect.top
				SUB EAX,DOCKDATA.DockTopHeight[EBX]
				MOV DOCKDATA.FocusRect.top[EBX],EAX
			.ElseIf DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
				MOV EAX,Rect.bottom
				ADD EAX,DOCKDATA.DockBottomHeight[EBX]
				MOV DOCKDATA.FocusRect.bottom[EBX],EAX
			.EndIf
		.EndIf
		;Draw It!
		;CALL DrawRectangle
		Invoke DrawRectangle,0,ADDR DOCKDATA.FocusRect[EBX]
	.EndIf
	RETN
	
	;------------------------------------------------------------------------
	NoDock:
	MOV DOCKDATA.fDockTo[EBX],NODOCK
	;Erase existing Focus Rectangle!
	Invoke DrawRectangle,0,ADDR [EBX].DOCKDATA.FocusRect
	MOV EAX,Point.x
	SUB EAX,DOCKDATA.MousePos.x[EBX]
	MOV [EBX].DOCKDATA.FocusRect.left,EAX
	ADD EAX,[EBX].DOCKDATA.NoDock.dWidth
	MOV [EBX].DOCKDATA.FocusRect.right,EAX
	MOV EAX,Point.y
	SUB EAX,DOCKDATA.MousePos.y[EBX]
	MOV [EBX].DOCKDATA.FocusRect.top,EAX
	ADD EAX,[EBX].DOCKDATA.NoDock.dHeight
	MOV [EBX].DOCKDATA.FocusRect.bottom,EAX
	;Draw new one!
	Invoke DrawRectangle,0,ADDR [EBX].DOCKDATA.FocusRect
	RETN

DockWndProc EndP

CreateDockingWindow Proc Uses EBX EDI dwStyle:DWORD,lpDockData:DWORD

	MOV EBX,lpDockData
	Invoke CreateWindowEx,NULL,Offset szDockClass, [EBX].DOCKDATA.lpCaption,dwStyle, 0, 0, 0, 0,WinAsmHandles.hMain, NULL, hInstance, NULL
	MOV EDI,EAX

	;-------------------------------------------------------------------------
	;Allocate a block of memory from the heap for the
	;Docking Window Handles
	;------------------------------------------------
	ADD DWBlockSize,4
	.If !pDWBlock
		Invoke HeapAlloc,hMainHeap,0,DWBlockSize
	.Else
		Invoke HeapReAlloc,hMainHeap,0,pDWBlock,DWBlockSize
	.EndIf
	MOV pDWBlock,EAX
	SUB DWBlockSize,4
	ADD EAX,DWBlockSize
	MOV [EAX],EDI
	ADD DWBlockSize,4

	;-------------------------------------------------------------------------
	Invoke SetWindowLong,EDI,0,EBX

	M2M DOCKDATA.fDockTo[EBX],DOCKDATA.fDockedTo[EBX]
	
	XOR ECX,ECX
	XOR EAX,EAX	
	.If DOCKDATA.fDockedTo[EBX]==LEFTDOCK
		MOV EAX,[EBX].DOCKDATA.DockLeftWidth
	.ElseIf DOCKDATA.fDockedTo[EBX]==RIGHTDOCK
		MOV EAX,[EBX].DOCKDATA.DockRightWidth
	.ElseIf DOCKDATA.fDockedTo[EBX]==TOPDOCK
		MOV ECX,[EBX].DOCKDATA.DockTopHeight
	.ElseIf DOCKDATA.fDockedTo[EBX]==BOTTOMDOCK
		MOV ECX,[EBX].DOCKDATA.DockBottomHeight
	.Else;If fDock==NODOCK
	MOV EAX,[EBX].DOCKDATA.NoDock.dLeft
		M2M DOCKDATA.FocusRect.left[EBX],[EBX].DOCKDATA.NoDock.dLeft
		M2M DOCKDATA.FocusRect.top[EBX],[EBX].DOCKDATA.NoDock.dTop
		MOV EAX,[EBX].DOCKDATA.NoDock.dWidth
		ADD EAX,[EBX].DOCKDATA.NoDock.dLeft
		MOV ECX,[EBX].DOCKDATA.NoDock.dHeight
		ADD ECX,[EBX].DOCKDATA.NoDock.dTop
	.EndIf
	M2M DOCKDATA.FocusRect.right[EBX],EAX
	M2M DOCKDATA.FocusRect.bottom[EBX],ECX

	MOV EAX,EDI
	RET
CreateDockingWindow EndP