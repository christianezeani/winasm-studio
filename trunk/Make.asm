.DATA
szPlus					DB "+",0
szCRLF					DB 0dh,0ah,0
szLinkResponseFileName	DB "link.war",0

szCompileRCNew			DB "/v",0
szReleaseAssembleNew	DB "/c /coff /Cp /nologo",0
szReleaseLinkNew		DB "/SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0",0
szReleaseLinkNewConsole	DB "/SUBSYSTEM:CONSOLE /RELEASE /VERSION:4.0",0
szReleaseLinkNewLibrary	DB "-LIB",0

szReleaseAssembleNewDOS	DB "/c",0

szDebugAssembleNew		DB "/c /coff /Cp /nologo /Fm /Zi /Zd",0		;Zd=Line number debug info
szDebugLinkNew			DB "/SUBSYSTEM:WINDOWS /DEBUG /VERSION:4.0",0
szDebugLinkNewConsole	DB "/SUBSYSTEM:CONSOLE /DEBUG /VERSION:4.0",0
szDebugLinkNewLibrary	DB "-LIB /DEBUG",0

szDebugAssembleNewDOS	DB "/c",0


.CODE

;Retutns -1 if I must compile
ShallICompile Proc lpFullPathFileName:DWORD, lpExtension:DWORD
Local Buffer[MAX_PATH]:BYTE
Local LastWriteTimeTxt	:FILETIME
Local LastWriteTimeBin	:FILETIME

	;Take source file name-Not filetitle
	;build a full path name as if it is in the project folder
	;Remove its extension,add lpExtension to it
	Invoke lstrcpy,ADDR Buffer,ADDR ProjectPath
	Invoke lstrlen,ADDR Buffer					;In Buffer we now have project path
	LEA ECX,Buffer
	ADD ECX,EAX
	Invoke GetFileName,lpFullPathFileName,ECX	;In Buffer we now have Project path+asmfilename.asm
	Invoke RemoveFileExt,ADDR Buffer			;In Buffer we now have Project path+asmfilename
	Invoke lstrcat,ADDR Buffer,lpExtension		;In Buffer we now have Project path+asmfilename.extension
	
	;Bin exists ????
	Invoke CreateFile,ADDR Buffer,0,FILE_SHARE_READ,0,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	.If EAX!=INVALID_HANDLE_VALUE	;(=-1)
		PUSH EAX
		LEA ECX,LastWriteTimeBin
		Invoke GetFileTime,EAX, NULL, NULL,ECX
		POP EAX
		Invoke CloseHandle,EAX
		
		;Source File (plain text) exists???
		Invoke CreateFile,lpFullPathFileName,0,FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		
		.If EAX!=INVALID_HANDLE_VALUE	;(=-1)
			PUSH EAX
			LEA ECX,LastWriteTimeTxt
			Invoke GetFileTime,EAX, NULL, NULL,ECX
			POP EAX
			Invoke CloseHandle,EAX
		.Else
			RET
		.EndIf
		Invoke CompareFileTime,ADDR LastWriteTimeBin,ADDR LastWriteTimeTxt
		;-1	First file time is less than second file time.
		;0	First file time is equal to second file time.
		;+1	First file time is greater than second file time.
	.EndIf
	RET
ShallICompile EndP

CreatePipeAndExecute Proc Uses EDI lpBuffer:LPSTR
Local sat			:SECURITY_ATTRIBUTES
Local StartupInfo	:STARTUPINFO
Local ProcessInfo	:PROCESS_INFORMATION
Local hRead			:DWORD
Local hWrite		:DWORD
Local BytesRead		:DWORD

	MOV EDI,lpBuffer
	;------------------
	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,Offset szCr
	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,EDI
	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,Offset szCr
	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,Offset szCr
	Invoke SendMessage,hOut,EM_SCROLLCARET,0,0
	
	MOV sat.nLength,SizeOf SECURITY_ATTRIBUTES
	MOV sat.lpSecurityDescriptor,NULL
	MOV sat.bInheritHandle,TRUE
	Invoke CreatePipe,ADDR hRead,ADDR hWrite,ADDR sat,NULL
	.If EAX==NULL
		;CreatePipe failed
		Invoke LoadCursor,0,IDC_ARROW
		Invoke SetCursor,EAX
		Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,ADDR szCreatePipeError
		INC NrOfErrors
	.Else
		Invoke RtlZeroMemory,ADDR StartupInfo,SizeOf STARTUPINFO
		MOV StartupInfo.cb,SizeOf STARTUPINFO
		
		MOV EAX,hWrite
		MOV StartupInfo.hStdOutput,EAX
		MOV StartupInfo.hStdError,EAX
		
		MOV StartupInfo.dwFlags,STARTF_USESTDHANDLES+STARTF_USESHOWWINDOW
		MOV StartupInfo.wShowWindow,SW_HIDE
		
		;Create process
		Invoke CreateProcess,NULL,EDI,NULL,NULL,TRUE,NULL,NULL,NULL,ADDR StartupInfo,ADDR ProcessInfo
		.If EAX==NULL
			;CreateProcess failed
			Invoke CloseHandle,hRead
			Invoke CloseHandle,hWrite
			Invoke LoadCursor,0,IDC_ARROW
			Invoke SetCursor,EAX
			Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,ADDR szCreateProcessError
			INC NrOfErrors
		.Else
			Invoke CloseHandle,hWrite
			Invoke CloseHandle,ProcessInfo.hProcess
			Invoke CloseHandle,ProcessInfo.hThread
			.While TRUE
				Invoke PeekNamedPipe,hRead,NULL,0,NULL,NULL,NULL
				.Break .If !EAX
				Invoke ReadFile,hRead,EDI,32000,ADDR BytesRead,NULL
				.If !EAX
					.Break
				.Else
					MOV ECX,EDI
					ADD ECX,BytesRead
					MOV BYTE PTR [ECX],0
					Invoke SendMessage,hOut,EM_REPLACESEL,FALSE,EDI
				.EndIf
			.EndW
			
			Invoke UpdateWindow,hOut
			
			Invoke CloseHandle,hRead
		.EndIf
		
		Invoke SetFocus,hOut
	.EndIf
	RET
CreatePipeAndExecute EndP

RunBatch Proc lpBatchFile:DWORD
	Invoke WinExec,lpBatchFile,SW_SHOWNORMAL
	RET
RunBatch EndP

OutputMake Proc Uses EBX ESI nCommand:DWORD, fClear:DWORD
Local fNextItem			:DWORD
Local dwGeneral			:DWORD
Local CounterBuffer[12]	:BYTE

	Invoke LoadCursor,0,IDC_WAIT
	Invoke SetCursor,EAX
	
	Invoke SetFocus,hOut
	Invoke SetCurrentDirectory,Offset ProjectPath

	Invoke LocalAlloc,LPTR,65536
	MOV ESI,EAX

	.If fClear==TRUE
		Invoke SendMessage,hOut,WM_SETTEXT,0,NULL
		Invoke SendMessage,hOut,EM_SCROLLCARET,0,0
	.EndIf

	MOV EAX,nCommand
	
	.If EAX==IDM_MAKE_COMPILERESOURCE
		;/fo Rename .RES file:User must NOT use it
		Invoke GetFirstNextChild, hResourceFilesItem,TVGN_CHILD
		.If EAX
			Invoke GetWindowLong,EAX,0
			MOV EBX,EAX
			
			Invoke ShallICompile,ADDR [EBX].CHILDWINDOWDATA.szFileName,Offset szExtRes
			
			.If EAX==-1
				Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szCompilingResources;"Compiling Resources ..."
				
				Invoke lstrcpy,ESI, Offset BinaryPath
				
				Invoke lstrcat,ESI, CTEXT("\rc ")
				
				
				Invoke lstrcat,ESI, Offset CompileRC
				
				;Invoke lstrcat,ESI, Offset szSpc
				Invoke lstrcat,ESI, Offset szSpaceSlashI
				Invoke lstrcat,ESI,Offset szQuote
				Invoke lstrcat,ESI, pIncludePath
				Invoke lstrcat,ESI,Offset szQuote
				Invoke lstrcat,ESI, Offset szSpc
				Invoke lstrcat,ESI,Offset szQuote
				
				Invoke lstrcat,ESI, ADDR [EBX].CHILDWINDOWDATA.szFileName
				Invoke lstrcat,ESI,Offset szQuote
				;CALL GoMake
				Invoke CreatePipeAndExecute,ESI
				
			;.Else
			;	JMP Ex
			.EndIf
		.EndIf
		
		
	.ElseIf EAX==IDM_MAKE_RCTOOBJ
		Invoke GetFirstNextChild, hResourceFilesItem,TVGN_CHILD
		.If EAX
			Invoke GetWindowLong,EAX,0
			MOV EBX,EAX
			Invoke ShallICompile,ADDR CHILDWINDOWDATA.szFileName[EBX],Offset szExtObj
			.If EAX==-1
				Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szConvertingResToObj	;"Converting Res To Obj ..."
				
				Invoke lstrcpy,ESI, Offset BinaryPath
				Invoke lstrcat,ESI, CTEXT("\cvtres ")
				Invoke lstrcat,ESI, Offset RCToObj
				
				Invoke lstrcat,ESI, Offset szSpc
				
				Invoke lstrcat,ESI,Offset szQuote
				
				Invoke lstrcat,ESI, ADDR [EBX].CHILDWINDOWDATA.szFileName
				Invoke RemoveFileExt,ESI
				Invoke lstrcat,ESI, Offset szExtRes
				Invoke lstrcat,ESI,Offset szQuote
				
				Invoke CreatePipeAndExecute,ESI
			.EndIf
		.EndIf		
	.ElseIf EAX==IDM_MAKE_ASSEMBLE
		;/Fo"c:\winasm\www.obj"
		;Notes: First ASM always assembled
		;		Modules are assembled only if bin is older than source
		
		MOV fNextItem,TVGN_CHILD
		Invoke GetFirstNextChild, hASMFilesItem,fNextItem
		
		.If EAX==0
			JMP Modules
		.EndIf
			
			Invoke GetWindowLong,EAX,0
			MOV EBX, EAX
			
			Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szAssemblingProject	;"Assembling Project ..."
			
			AssembleIt:
			Invoke lstrcpy,ESI, Offset BinaryPath
			Invoke lstrcat,ESI, CTEXT("\ML ")
			.If ActiveBuild==0	;i.e. Release build
				Invoke lstrcat,ESI, Offset szReleaseAssemble
			.Else
				Invoke lstrcat,ESI, Offset szDebugAssemble
			.EndIf
			Invoke lstrcat,ESI, Offset szSpaceSlashI
			Invoke lstrcat,ESI,Offset szQuote
			Invoke lstrcat,ESI, pIncludePath
			Invoke lstrcat,ESI,Offset szQuote
			Invoke lstrcat,ESI, Offset szSpc
			Invoke lstrcat,ESI,Offset szQuote
			
			Invoke lstrcat,ESI, ADDR [EBX].CHILDWINDOWDATA.szFileName
			Invoke lstrcat,ESI,Offset szQuote
			
			Invoke CreatePipeAndExecute,ESI
			
			Modules:
			;-------
			.If fNextItem==TVGN_CHILD
				MOV EDX,hModulesItem
			.Else
				NextChild:
				MOV EDX,[EBX].CHILDWINDOWDATA.hTreeItem
			.EndIf
			
			
			Invoke GetFirstNextChild,EDX,fNextItem
			.If EAX
				MOV fNextItem,TVGN_NEXT
				Invoke GetWindowLong,EAX,0
				MOV EBX, EAX
				Invoke ShallICompile,ADDR [EBX].CHILDWINDOWDATA.szFileName,Offset szExtObj
				.If EAX==-1
					JMP AssembleIt
				.Else
					JMP NextChild
				.EndIf
			.EndIf
		;.Else
		;	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE, ADDR szNoASMError
		;	INC NrOfErrors
		;.EndIf
		
	.ElseIf EAX==IDM_MAKE_LINK
		;Invoke GetFirstNextChild, hASMFilesItem,TVGN_CHILD
		;.If EAX
			Invoke SendMessage,hStatus,SB_SETTEXT,4,Offset szLinking;"Linking ...")
			
			;Create Response File
			Invoke lstrcpy,ESI,Offset ProjectPath
			Invoke lstrcat,ESI,Offset szLinkResponseFileName
			
			Invoke CreateFile,ESI,GENERIC_READ OR GENERIC_WRITE,FILE_SHARE_READ OR FILE_SHARE_WRITE,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
			.If EAX!=INVALID_HANDLE_VALUE
				PUSH EDI
				MOV EDI,EAX
				
				;Let's use ESI for something else!!!!
				ADD ESI,MAX_PATH
				
				.If ActiveBuild==0	;i.e. Release build
					MOV EBX,Offset szReleaseLink
				.Else
					MOV EBX,Offset szDebugLink
				.EndIf
				.If BYTE PTR [EBX]!=0
					Invoke lstrcpy,ESI,EBX
				.EndIf
				
				.If ProjectType!=6
					.If bPellesTools
						Invoke lstrcat,ESI, CTEXT(' "/LIBPATH:')
					.Else
						Invoke lstrcat,ESI, CTEXT(' /LIBPATH:"')
					.EndIf
					
					Invoke lstrcat,ESI, Offset LibraryPath
					Invoke lstrcat,ESI,Offset szQuote
				.EndIf
				
				.If ProjectType==1    ;Standard DLL
					Invoke lstrcat,ESI, CTEXT(" /DLL")
					Invoke GetFirstNextChild, hDefFilesItem,TVGN_CHILD
					.If EAX
						Invoke GetWindowLong,EAX,0
						PUSH EAX
						
						.If bPellesTools
							Invoke lstrcat,ESI, CTEXT(' "/DEF:')
						.Else
							Invoke lstrcat,ESI, CTEXT(' /DEF:"')
						.EndIf
						
						POP EDX
						Invoke lstrcat,ESI, ADDR [EDX].CHILDWINDOWDATA.szFileName
						Invoke lstrcat,ESI,Offset szQuote
					.EndIf
				.EndIf
				
				MOV fNextItem,TVGN_CHILD
				Invoke GetFirstNextChild, hASMFilesItem,fNextItem
				.If EAX==0
					JMP LinkModules
				.EndIf
				
				Invoke GetWindowLong,EAX,0
				LEA EBX,[EAX].CHILDWINDOWDATA.szFileName
				.If BYTE PTR [ESI]!=0
					.If ProjectType==6
						Invoke lstrcat,ESI, Offset szPlus
						Invoke lstrcat,ESI, Offset szCRLF
					.Else
						Invoke lstrcat,ESI, Offset szSpc
					.EndIf
					
				.EndIf
				
				Invoke lstrcat,ESI,Offset szQuote
				
				Invoke lstrcat,ESI,EBX
				Invoke RemoveFileExt,ESI
				Invoke lstrcat,ESI,Offset szExtObj
				Invoke lstrcat,ESI,Offset szQuote
				
				
				LinkModules:
				;----------
				MOV EAX,hModulesItem
				
				NextObj:
				;------
				Invoke GetFirstNextChild,EAX,fNextItem
				.If EAX
					MOV fNextItem,TVGN_NEXT
					Invoke GetWindowLong,EAX,0
					MOV EBX, EAX
					
					.If ProjectType==6
						Invoke lstrcat,ESI, Offset szPlus
						Invoke lstrcat,ESI, Offset szCRLF
					.Else
						Invoke lstrcat,ESI, Offset szSpc
					.EndIf
					
					Invoke lstrcat,ESI,Offset szQuote
					Invoke lstrcat,ESI, ADDR [EBX].CHILDWINDOWDATA.szFileName
					Invoke RemoveFileExt,ESI
					Invoke lstrcat,ESI,Offset szExtObj
					Invoke lstrcat,ESI,Offset szQuote
					
					
					MOV EAX,[EBX].CHILDWINDOWDATA.hTreeItem					
					JMP NextObj
				.EndIf
				
				
				LinkBinary:
				;---------
				MOV dwGeneral,0
				@@:		
				INC dwGeneral
				Invoke BinToDec,dwGeneral,ADDR CounterBuffer
				Invoke GetPrivateProfileString, Offset szBINFILES,ADDR CounterBuffer,Offset szNULL,Offset tmpBuffer,MAX_PATH+1,Offset FullProjectName
				.If EAX
					;Invoke lstrcat,ESI, Offset szSpc
					.If ProjectType==6
						Invoke lstrcat,ESI, Offset szPlus
						Invoke lstrcat,ESI, Offset szCRLF
					.Else
						Invoke lstrcat,ESI, Offset szSpc
					.EndIf
					
					Invoke lstrcat,ESI,Offset szQuote
					
					Invoke GetFilePath, Offset tmpBuffer,Offset tmpBuffer2
					.If tmpBuffer2[0]==0	;i.e. path not specified in the project file
						Invoke lstrcpy,Offset tmpBuffer2, Offset ProjectPath
						Invoke lstrcat,Offset tmpBuffer2, Offset tmpBuffer
						MOV ECX,Offset tmpBuffer2
					.Else
						MOV ECX,Offset tmpBuffer
					.EndIf
					Invoke lstrcat, ESI,ECX
					
					Invoke lstrcat,ESI,Offset szQuote
					JMP @B
				.EndIf
				
				.If ProjectType==6
					Invoke lstrcat,ESI,CTEXT(";")	;I found out that since now I am using a response file ";" causes last character to be inserted twice!!!!
				.Else
					Invoke GetFirstNextChild, hResourceFilesItem,TVGN_CHILD
					.If EAX
						PUSH EAX
						Invoke lstrcat,ESI, Offset szSpc
						Invoke lstrcat,ESI,Offset szQuote
						POP EAX
						Invoke GetWindowLong,EAX,0
						Invoke lstrcat,ESI, ADDR [EAX].CHILDWINDOWDATA.szFileName
						Invoke RemoveFileExt,ESI
						.If RCToObj[0]==0
							Invoke lstrcat,ESI, Offset szExtRes
						.Else
							Invoke lstrcat,ESI,Offset szExtObj
						.EndIf
						Invoke lstrcat,ESI,Offset szQuote
					.EndIf
					
					.If bPellesTools
						Invoke lstrcat,ESI, CTEXT(' "/OUT:')
					.Else
						Invoke lstrcat,ESI, CTEXT(' /OUT:"')	;Offset szOUT	;<--Already has quotes and starting space
					.EndIf
					
					.If ActiveBuild==0					;i.e. Release build
						MOV EDX,Offset szReleaseOutCommand
					.Else								;If ActiveBuild==1	;i.e. Debug build
						MOV EDX,Offset szDebugOutCommand
					.EndIf
					
					.If BYTE PTR [EDX]!=0
						Invoke lstrcat,ESI, EDX
					.Else
						MOV EDX, Offset szNULL
						.If ProjectType==0 || ProjectType==2 || ProjectType==4; || ProjectType==6
							MOV EDX,Offset szExtExe
						.ElseIf ProjectType==1	;dll
							MOV EDX,Offset szExtDll
						.ElseIf ProjectType==3	;Lib
							MOV EDX,Offset szExtLib
						.EndIf
						
						Invoke GetProjectBinName,Offset tmpBuffer,EDX
						Invoke lstrcat,ESI,Offset tmpBuffer
					.EndIf
					Invoke lstrcat,ESI,Offset szQuote
					
				.EndIf
				
				Invoke lstrlen,ESI
				MOV EDX,EAX
				Invoke WriteFile,EDI,ESI,EDX,ADDR dwGeneral,0
				Invoke CloseHandle,EDI
				
				;Let's use ESI for something else!!!!
				Invoke lstrcpy,ESI, Offset BinaryPath
				.If ProjectType==6
					MOV EDX,CTEXT("\Link16")
					
				.ElseIf ProjectType==3
					.If bPellesTools
						MOV EDX,CTEXT("\Polib")
					.Else
						MOV EDX,CTEXT("\Lib")
					.EndIf
					
				.Else
					.If bPellesTools
						MOV EDX,CTEXT("\Polink")
					.Else
						MOV EDX,CTEXT("\Link")
					.EndIf
					
				.EndIf
				Invoke lstrcat,ESI, EDX
				Invoke lstrcat,ESI,CTEXT(' @"')
				Invoke lstrcat,ESI,Offset ProjectPath
				Invoke lstrcat,ESI,Offset szLinkResponseFileName
				Invoke lstrcat,ESI,Offset szQuote
				Invoke CreatePipeAndExecute,ESI
				
				;Delete Response File
				SUB ESI,MAX_PATH
				Invoke DeleteFile,ESI
				POP EDI
			.EndIf
		;.Else
		;	Invoke SendMessage,hOut,EM_REPLACESEL,FALSE, ADDR szNoASMError
		;	INC NrOfErrors
		;.EndIf
	.EndIf
	
	Invoke LocalFree,ESI
	
	Invoke LoadCursor,0,IDC_ARROW
	Invoke SetCursor,EAX
	RET
	
OutputMake EndP