BIF_NEWDIALOGSTYLE	EQU 40H

.DATA?
hImages				DWORD ?
lpStartPath			DWORD ?

.CODE
cbBrowse Proc hWin:DWORD,uMsg:DWORD,lParam :DWORD,lpData :DWORD
	.If uMsg==BFFM_INITIALIZED;WM_INITDIALOG
		Invoke SetWindowText,hWin,lpData
		.If lpStartPath
			Invoke SendMessage, hWin, BFFM_SETSELECTION, TRUE,lpStartPath
		.EndIf
		Invoke CenterWindow,hWin
	.EndIf
	RET
cbBrowse EndP


BrowseForAnyFolder Proc hParent:HWND,hTextBox:HWND,lpBuffer:DWORD
Local lpIDList:DWORD
Local bi:BROWSEINFO
Local Buffer[MAX_PATH]:BYTE

	MOV bi.pidlRoot,0
	MOV EAX,hParent
	MOV bi.hwndOwner,EAX
	MOV bi.pszDisplayName,0
	MOV EAX,Offset szNULL
	MOV bi.lpszTitle,EAX
	MOV bi.lpfn,Offset cbBrowse
	MOV EAX,Offset szBrowseForPathDialogTitle	;"WinAsm Studio - Browse For Path"
	MOV bi.lParam,EAX
	MOV bi.iImage,0

	.If lpBuffer
		.If InitDir[0]
			MOV EDX,Offset InitDir
			MOV lpStartPath,EDX
		.Else
			MOV lpStartPath,0
		.EndIf
		MOV bi.ulFlags,BIF_RETURNONLYFSDIRS OR BIF_DONTGOBELOWDOMAIN OR BIF_NEWDIALOGSTYLE
		Invoke CoInitialize,NULL
	.Else
		MOV lpStartPath,0
		MOV bi.ulFlags,BIF_RETURNONLYFSDIRS OR BIF_DONTGOBELOWDOMAIN
	.EndIf
	
	Invoke SHBrowseForFolder,ADDR bi
	MOV lpIDList,EAX

	.If lpIDList == 0
		MOV EAX,0			;If CANCEL return FALSE
		PUSH EAX
		JMP @F
    .Else
		Invoke SHGetPathFromIDList,lpIDList,ADDR Buffer
		.If lpBuffer==0
			Invoke SendMessage,hTextBox,WM_SETTEXT,0,ADDR Buffer
		.Else
			Invoke lstrcpy,lpBuffer,ADDR Buffer
		.EndIf
		MOV EAX,1			;If OK, return TRUE
		PUSH EAX
		JMP @F
	.EndIf
	
	@@:
	Invoke CoTaskMemFree,lpIDList
	POP EAX
	RET
BrowseForAnyFolder EndP

ShowOptionsFirstTab Proc fShow:DWORD
	Invoke ShowWindow,hGoupBoxOnStartUp,fShow
	Invoke ShowWindow,hOpenDlgOnStartUp,fShow
	Invoke ShowWindow,hOpenLastProjectOnStartUp,fShow
	Invoke ShowWindow,hShowRecentProjectsOnStartUp,fShow
	Invoke ShowWindow,hNoneOnStartUp,fShow

	Invoke ShowWindow,hShowSplash,fShow
	Invoke ShowWindow,hAutoSave,fShow
	Invoke ShowWindow,hShowOutOnSuccess,fShow

	Invoke ShowWindow,hOnMinimizeToSysTray,fShow
	Invoke ShowWindow,hAutoToolAndOptions,fShow
	Invoke ShowWindow,hAutoClean,fShow
	
	Invoke ShowWindow,hOpenChildrenMaximized,fShow
	Invoke ShowWindow,hGradientMenuItems,fShow

    RET
ShowOptionsFirstTab EndP
ShowOptionsSecondTab Proc fShow:DWORD
	Invoke ShowWindow,hTextBinaryPath,fShow
	Invoke ShowWindow,hLabelBinaryPath,fShow
	Invoke ShowWindow,hBrowseForBinaryPath,fShow
	
	Invoke ShowWindow,hTextIncludePath,fShow
	Invoke ShowWindow,hLabelIncludePath,fShow
	Invoke ShowWindow,hBrowseForIncludePath,fShow
	
	Invoke ShowWindow,hTextLibraryPath,fShow
	Invoke ShowWindow,hLabelLibraryPath,fShow
	Invoke ShowWindow,hBrowseForLibraryPath,fShow
	
	Invoke ShowWindow,hTextKeyFile,fShow
	Invoke ShowWindow,hLabelKeyFile,fShow
	Invoke ShowWindow,hBrowseKeyFile,fShow
	
	Invoke ShowWindow,hTextAPIFunctionsFile,fShow
	Invoke ShowWindow,hLabelAPIFunctionsFile,fShow
	Invoke ShowWindow,hBrowseAPIFunctionsFile,fShow

	Invoke ShowWindow,hTextAPIStructuresFile,fShow
	Invoke ShowWindow,hLabelAPIStructuresFile,fShow
	Invoke ShowWindow,hBrowseAPIStructuresFile,fShow
	
	Invoke ShowWindow,hTextAPIConstantsFile,fShow
	Invoke ShowWindow,hLabelAPIConstantsFile,fShow
	Invoke ShowWindow,hBrowseAPIConstantsFile,fShow

	Invoke ShowWindow,hTextHelpFile,fShow
	Invoke ShowWindow,hLabelHelpFile,fShow
	Invoke ShowWindow,hBrowseHelpFile,fShow
	
	Invoke ShowWindow,hBrowseDefaultProjectDir,fShow
	Invoke ShowWindow,hTextDefaultProjectDir,fShow
	Invoke ShowWindow,hLabelDefaultProjectDir,fShow

    RET
ShowOptionsSecondTab EndP
ShowOptionsThirdTab Proc fShow:DWORD
	Invoke ShowWindow,hTabToSpaces,fShow
	Invoke ShowWindow,hTabSizeLabel,fShow
	Invoke ShowWindow,hTabSizeText,fShow
	;Invoke ShowWindow,hTabSizeUpDown,fShow
	Invoke ShowWindow,hAutoIndent,fShow
	Invoke ShowWindow,hTabIndicators,fShow
	Invoke ShowWindow,hShowScrollTips,fShow
	
	Invoke ShowWindow,hShowLineNumbersOnOpen,fShow
	Invoke ShowWindow,hAutoshowLineNumbersOnError,fShow



	Invoke ShowWindow,hLnNrWidth,fShow
	Invoke ShowWindow,hLnNrWidthText,fShow
	
	
	Invoke ShowWindow,hProcAutoComplete,fShow
	Invoke ShowWindow,hRetLabel,fShow
	Invoke ShowWindow,hRetCombo,fShow
;	Invoke ShowWindow,hEndPLabel,fShow
;	Invoke ShowWindow,hEndPCombo,fShow

    RET
ShowOptionsThirdTab EndP

ShowOptionsFourthTab Proc fShow:DWORD
	Invoke ShowWindow,hFunctionTriggerList,fShow
	Invoke ShowWindow,hOpeningParenthesis,fShow
	Invoke ShowWindow,hAcceptsParameters,fShow
	Invoke ShowWindow,hCanBeAParameter,fShow
	Invoke ShowWindow,hFunctionTriggerLabel,fShow
	Invoke ShowWindow,hFunctionNameEdit,fShow
	Invoke ShowWindow,hAddFunctionButton,fShow
	Invoke ShowWindow,hDeleteFunctionButton,fShow
	Invoke ShowWindow,hApplyFunctionButton,fShow
	
	Invoke ShowWindow,hAutoCompleteWithLabel,fShow
	Invoke ShowWindow,hAutoCompleteWithSpace,fShow
	Invoke ShowWindow,hAutoCompleteWithTab,fShow
	Invoke ShowWindow,hAutoCompleteWithEnter,fShow

	RET
ShowOptionsFourthTab EndP

ShowOptionsFifthTab Proc fShow:DWORD
	Invoke ShowWindow,hGroupsLabel,fShow
	Invoke ShowWindow,hGroupsList,fShow
	Invoke ShowWindow,hKeyWordsLabel,fShow
	Invoke ShowWindow,hKeyWordsList,fShow
	Invoke ShowWindow,hRecycledLabel,fShow
	Invoke ShowWindow,hRecycledList,fShow
	
	Invoke ShowWindow,hToRecycled,fShow
	Invoke ShowWindow,hFromRecycled,fShow
	
	Invoke ShowWindow,hWordToAdd,fShow

	Invoke ShowWindow,hAddButton,fShow
	Invoke ShowWindow,hDeleteButton,fShow
	
	Invoke ShowWindow,hBoldButton,fShow
	Invoke ShowWindow,hItalicButton,fShow

	Invoke ShowWindow,hApplyButton,fShow
	RET
ShowOptionsFifthTab EndP

ShowOptionsSixthTab Proc fShow:DWORD
	Invoke ShowWindow,hSchemesLabel,fShow
	Invoke ShowWindow,hSchemesCombo,fShow
	Invoke ShowWindow,hSaveSchemeButton,fShow
	Invoke ShowWindow,hDeleteSchemeButton,fShow
	Invoke ShowWindow,hColorsList,fShow
	RET
ShowOptionsSixthTab EndP

ShowOptionsSeventhTab Proc fShow:DWORD
	Invoke ShowWindow,hTextExtResEd,fShow
	Invoke ShowWindow,hLabelExtResEd,fShow
	Invoke ShowWindow,hBrowseForExtResEd,fShow
	Invoke ShowWindow,hLaunchExeOnGoAll,fShow
	Invoke ShowWindow,hUseQuotes,fShow
	Invoke ShowWindow,hDebugUseQuotes,fShow
	Invoke ShowWindow,hTextExtDebugger,fShow
	Invoke ShowWindow,hLabelExtDebugger,fShow
	Invoke ShowWindow,hBrowseForExtDebugger,fShow
	Invoke ShowWindow,hObjectsFont,fShow
	RET
ShowOptionsSeventhTab EndP

SelectColor Proc Color:DWORD
Local ccc:CHOOSECOLOR
	MOV	ccc.lStructSize,SizeOf CHOOSECOLOR
	M2M ccc.hwndOwner,hFind
	MOV EAX,hInstance
	MOV	ccc.hInstance,EAX
	MOV	ccc.lpCustColors,Offset CustColors
	MOV	ccc.Flags, CC_FULLOPEN OR CC_RGBINIT
	MOV	ccc.lCustData,0
	MOV	ccc.lpfnHook,0
	MOV	ccc.lpTemplateName,0
	MOV EAX,Color
	;Mask off font
	AND	EAX,0FFFFFFh
	MOV	ccc.rgbResult,EAX
	Invoke ChooseColor,ADDR ccc
	.If EAX
		MOV EAX,ccc.rgbResult
	.Else
		MOV EAX,Color
	.EndIf
	RET
SelectColor EndP

RepaintAll Proc Uses EBX EDI hChild:DWORD
	Invoke GetWindowLong,hChild,0
	MOV EBX, EAX

	Invoke GetWindowLong,CHILDWINDOWDATA.hEditor[EBX],GWL_STYLE
	MOV EDI,EAX
	.If ShowScrollTips
		OR EDI,STYLE_SCROLLTIP
	.Else
		AND EDI,-1 XOR STYLE_SCROLLTIP
	.EndIf

    Invoke SendMessage, CHILDWINDOWDATA.hEditor[EBX],CHM_SETCOLOR,0,ADDR col
    Invoke SendMessage, hOut,CHM_SETCOLOR, 0, ADDR col
	
;	Invoke SendMessage,CHILDWINDOWDATA.hEditor[EBX],CHM_LINENUMBERWIDTH,LineNrWidth,0

    Invoke SetFormat, CHILDWINDOWDATA.hEditor[EBX]

	MOV EAX, CHILDWINDOWDATA.dwTypeOfFile[EBX]
	;ASM=1, INC=2, RC=3,BAT=6
	.If EAX==1 || EAX==2 || EAX==51 || EAX==3 || EAX==6 || EAX==101 || EAX==102 || EAX==103 || EAX==106
		.If EAX==1 || EAX==2 || EAX==101 || EAX==102 || EAX==51
			Invoke SetKeyWords, CHILDWINDOWDATA.hEditor[EBX],0
			;Invoke GetWindowLong,CHILDWINDOWDATA.hEditor[EBX],GWL_STYLE
			.If !TabIndicators
				OR EDI,STYLE_NOTABINDICATORS
			.Else
				AND EDI,-1 XOR STYLE_NOTABINDICATORS
			.EndIf
			Invoke SetWindowLong,CHILDWINDOWDATA.hEditor[EBX],GWL_STYLE,EDI
		.ElseIf EAX==3 || EAX==103
			Invoke SetKeyWords, CHILDWINDOWDATA.hEditor[EBX],1
		.Else
			Invoke SetKeyWords, CHILDWINDOWDATA.hEditor[EBX],2
		.EndIf
		Invoke SendMessage, CHILDWINDOWDATA.hEditor[EBX],CHM_REPAINT,0,0
	.EndIf
	
	.If EAX==1 || EAX==2 || EAX==101 || EAX==102 || EAX==51	;because we already did this (faster!) 
	.Else
		Invoke SetWindowLong,CHILDWINDOWDATA.hEditor[EBX],GWL_STYLE,EDI
	.EndIf
	RET
RepaintAll EndP

SaveKeyWords Proc Uses EBX EDI ESI;Only One category is saved
Local Buffer[12]:BYTE
Local hMem:DWORD

	Invoke SendMessage,hGroupsList,LB_GETCURSEL,0,0
	.If EAX==0
		LEA EBX, szC0COLOR
		MOV ESI,lpC0WORDS
		CALL GetIt
		MOV C0,EAX
		MOV lpC0WORDS,ESI
		LEA EAX,szC0WORDS
		CALL SaveOneCategory
	.ElseIf EAX==1
		LEA EBX,szC1COLOR
		MOV ESI,lpC1WORDS
		CALL GetIt
		MOV C1,EAX
		MOV lpC1WORDS,ESI
		LEA EAX,szC1WORDS
		CALL SaveOneCategory
	.ElseIf EAX==2
		LEA EBX, szC2COLOR
		MOV ESI,lpC2WORDS
		CALL GetIt
		MOV C2,EAX
		MOV lpC2WORDS,ESI
		LEA EAX,szC2WORDS
		CALL SaveOneCategory
	.ElseIf EAX==3
		LEA EBX, szC3COLOR
		MOV ESI,lpC3WORDS
		CALL GetIt
		MOV C3,EAX
		MOV lpC3WORDS,ESI
		LEA EAX,szC3WORDS
		CALL SaveOneCategory
	.ElseIf EAX==4
		LEA EBX, szC4COLOR
		MOV ESI,lpC4WORDS
		CALL GetIt
		MOV C4,EAX
		MOV lpC4WORDS,ESI
		LEA EAX,szC4WORDS
		CALL SaveOneCategory
	.ElseIf EAX==5
		LEA EBX, szC5COLOR
		MOV ESI,lpC5WORDS
		CALL GetIt
		MOV C5,EAX
		MOV lpC5WORDS,ESI
		LEA EAX,szC5WORDS
		CALL SaveOneCategory
	.ElseIf EAX==6
		LEA EBX, szC6COLOR
		MOV ESI,lpC6WORDS
		CALL GetIt
		MOV C6,EAX
		MOV lpC6WORDS,ESI
		LEA EAX,szC6WORDS
		CALL SaveOneCategory
	.ElseIf EAX==7
		LEA EBX, szC7COLOR
		MOV ESI,lpC7WORDS
		CALL GetIt
		MOV C7,EAX
		MOV lpC7WORDS,ESI
		LEA EAX,szC7WORDS
		CALL SaveOneCategory
	.ElseIf EAX==8
		LEA EBX, szC8COLOR
		MOV ESI,0;lpAPIFunctions
		CALL GetIt
		MOV APIFunctionsColor,EAX
	.ElseIf EAX==9
		LEA EBX, szC9COLOR
		MOV ESI,0;lpAPIStructures
		CALL GetIt
		MOV APIStructuresColor,EAX
	.ElseIf EAX==10
		LEA EBX,szC10COLOR
		MOV ESI,0
		CALL GetIt
		MOV APIConstantsColor,EAX
	.ElseIf EAX==11
		LEA EBX,szC11COLOR
		MOV ESI,lpC11WORDS
		CALL GetIt
		MOV C11,EAX
		MOV lpC11WORDS,ESI
		LEA EAX,szC0RC
		CALL SaveOneCategory
	.ElseIf EAX==12
		LEA EBX,szC12COLOR
		MOV ESI,lpC12WORDS
		CALL GetIt
		MOV C12,EAX
		MOV lpC12WORDS,ESI
		LEA EAX,szC1RC
		CALL SaveOneCategory
	.ElseIf EAX==13
		LEA EBX, szC13COLOR
		MOV ESI,lpC13WORDS
		CALL GetIt
		MOV C13,EAX
		MOV lpC13WORDS,ESI
		LEA EAX,szC0BAT
		CALL SaveOneCategory
	.ElseIf EAX==14
		LEA EBX, szC14COLOR
		MOV ESI,lpC14WORDS
		CALL GetIt
		MOV C14,EAX
		MOV lpC14WORDS,ESI
		LEA EAX,szC1BAT
		CALL SaveOneCategory
	.EndIf
	RET

	;--------------------------------------------------------------
	GetIt:	
	Invoke SendMessage,hGroupsList,LB_GETITEMDATA,EAX,0
	PUSH EAX
	Invoke wsprintf,ADDR Buffer, Offset szColorTemplate, EAX
	Invoke WritePrivateProfileString,Offset szCATEGORIES,EBX,ADDR Buffer,pKeyWordsFileName
	
	.If ESI!=0
		Invoke HeapFree,hMainHeap,0,ESI
		Invoke HeapAlloc, hMainHeap, HEAP_ZERO_MEMORY, 16384
		MOV hMem,EAX
		MOV EDI,EAX
		XOR ESI,ESI
		
		@@:
		Invoke SendMessage,hKeyWordsList,LB_GETTEXT,ESI,EDI
		.If EAX!=LB_ERR
			Invoke lstrlen,EDI
			ADD EDI,EAX
			MOV BYTE PTR [EDI],VK_SPACE
			INC EDI
			INC	ESI
			JMP	@B
		.EndIf
		.If EDI!=hMem
			MOV	BYTE PTR [EDI-1],0
		.EndIf
		MOV ESI,hMem
	.EndIf
	POP EAX
	RETN

	;--------------------------------------------------------------
	SaveOneCategory:
	Invoke WritePrivateProfileString,Offset szCATEGORIES,EAX,ESI,pKeyWordsFileName
	RETN
SaveKeyWords EndP

SaveOptions Proc Uses EBX EDI ESI
Local Buffer[MAX_PATH]:BYTE
	
	;So that in case that the OLD constants are in the hListVariables, they will be deleted when FillVariablesList is called
	Invoke SetWindowLong,hListVariables,GWL_USERDATA,0

	LEA ESI,Buffer
	
	Invoke WritePrivateProfileSection,Offset szTRIGGER,Offset szNULL,Offset IniFileName
	MOV EDI,lpTrigger
	XOR EBX,EBX 
	@@:
	.If BYTE PTR [EDI]
		INC EBX
		Invoke BinToDec,EBX,ESI
		Invoke WritePrivateProfileStruct,Offset szTRIGGER,ESI,EDI,SizeOf FUNCTIONLISTTRIGGER,Offset IniFileName
		ADD EDI,SizeOf FUNCTIONLISTTRIGGER
		JMP @B
	.EndIf
	
	
	MOV EBX,Offset IniFileName
	;------------------------------------------------------------------------
	MOV EDI,Offset szFILESANDPATHS
	;Save Binary path in WinASM.ini
	MOV ECX,hTextBinaryPath
	LEA EDX,BinaryPath
	CALL GetText
	Invoke WritePrivateProfileString,EDI,Offset szBinaryPath,Offset BinaryPath, EBX

	;Save Include path in WinASM.ini
	MOV ECX,hTextIncludePath
	LEA EDX,IncludePath
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szIncludePath, Offset IncludePath, EBX

	;Save Library path in WinASM.ini
	MOV ECX,hTextLibraryPath
	LEA EDX,LibraryPath
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szLibraryPath, Offset LibraryPath, EBX

	;Save KeyFile in WinASM.ini
	MOV ECX,hTextKeyFile
	LEA EDX,KeyWordsFileName
	CALL GetText
	Invoke GetKeyWords
	Invoke WritePrivateProfileString, EDI, Offset szKeyFile, Offset KeyWordsFileName, EBX

	;Save API Functions File in WinASM.ini
	MOV ECX,hTextAPIFunctionsFile
	LEA EDX,APIFunctionsFile
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szAPIFunctionsFile, Offset APIFunctionsFile, EBX
	Invoke GetAPIFunctions
	
   	;Save API Structures File in WinASM.ini
	MOV ECX,hTextAPIStructuresFile
	LEA EDX,APIStructuresFile
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szAPIStructuresFile, Offset APIStructuresFile, EBX
    Invoke GetAPIStructures
    
  	;Save API Constants File in WinASM.ini
	MOV ECX,hTextAPIConstantsFile
	LEA EDX,APIConstantsFile
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szAPIConstantsFile, Offset APIConstantsFile, EBX
    Invoke GetAPIConstants
    
	;Save HelpFile in WinASM.ini
	MOV ECX,hTextHelpFile
	LEA EDX,HelpFileName
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szHelpFile, Offset HelpFileName, EBX
	
	;Save DefaultProjectDir in WinASM.ini
	MOV ECX,hTextDefaultProjectDir
	LEA EDX,InitDir
	CALL GetText
	Invoke WritePrivateProfileString, Offset szGENERAL, Offset szInitDir,Offset InitDir, EBX

	;------------------------------------------------------------------------
	MOV EDI,Offset szMISCELLANEOUS

	MOV ECX,hTextExtResEd
	LEA EDX,ExternalResourceEditor
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szExtResEdit, Offset ExternalResourceEditor, EBX
	
	Invoke BinToDec,LaunchExeOnGoAll,ESI
	Invoke WritePrivateProfileString, EDI, Offset szLaunchExeOnGoAll,ESI, EBX
		
	Invoke BinToDec,UseQuotes,ESI
	Invoke WritePrivateProfileString, EDI, Offset szUseQuotes, ESI, EBX
	
	Invoke BinToDec,DebugUseQuotes,ESI
	Invoke WritePrivateProfileString, EDI, Offset szDebugUseQuotes, ESI, EBX

	MOV ECX,hTextExtDebugger
	LEA EDX,ExternalDebugger
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szExtDebugger, Offset ExternalDebugger, EBX
	
	
	Invoke BinToDec,ObjectsFont,ESI
	Invoke WritePrivateProfileString, EDI, Offset szObjectsFont, ESI, EBX

	;------------------------------------------------------------------------
	MOV EDI,Offset szGENERAL

	Invoke wsprintf, ESI, Offset szColorTemplate, col.TreeBackCol
	Invoke WritePrivateProfileString, EDI, Offset szTreeBackColor, ESI, EBX

	Invoke wsprintf, ESI, Offset szColorTemplate,col.TreeTextCol
	Invoke WritePrivateProfileString, EDI, Offset szTreeTextColor, ESI, EBX

	Invoke wsprintf, ESI, Offset szColorTemplate, col.TreeLineCol
	Invoke WritePrivateProfileString, EDI, Offset szTreeLineColor, ESI, EBX

	Invoke BinToDec,GradientMenuItems,ESI
	Invoke WritePrivateProfileString, EDI, Offset szGradientMenuItems, ESI, EBX

	Invoke BinToDec,AutoSave,ESI
	Invoke WritePrivateProfileString, EDI, Offset szAutoSave, ESI, EBX
	
	Invoke BinToDec,ShowOutOnSuccess,ESI
	Invoke WritePrivateProfileString, EDI, Offset szShowOutOnSuccess, ESI, EBX

	Invoke BinToDec,OnStartUp,ESI
	Invoke WritePrivateProfileString, EDI, Offset szOnStartUp, ESI, EBX

	Invoke BinToDec,ShowSplashOnStartUp,ESI
	Invoke WritePrivateProfileString, EDI, Offset szShowSplash, ESI, EBX

	Invoke BinToDec,OnMinimizeToSysTray,ESI
	Invoke WritePrivateProfileString, EDI, Offset szOnMinimizeToSysTray, ESI, EBX
	

	Invoke BinToDec,AutoToolAndOptions,ESI
	Invoke WritePrivateProfileString, EDI, Offset szAutoToolAndOptions, ESI, EBX

	Invoke BinToDec,AutoClean,ESI
	Invoke WritePrivateProfileString, EDI, Offset szAutoClean, ESI, EBX

	XOR EAX,EAX
	.If OpenChildStyle
		MOV EAX,1
	.EndIf
	
	;LEA ECX,Buffer
	Invoke BinToDec,EAX,ESI
	Invoke WritePrivateProfileString, EDI, Offset szOpenChildrenMaximized, ESI, EBX

	;--------------------------------------------------------------------------------------------------------------
	MOV EDI,Offset szEDITOR

	Invoke wsprintf, ESI, Offset szColorTemplate, col.bckcol
	LEA ECX, szBackColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.txtcol
	LEA ECX, szTextColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.selbckcol
	LEA ECX, szSelBackColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.seltxtcol
	LEA ECX, szSelTextColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.cmntcol
	LEA ECX, szCommentColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.strcol
	LEA ECX, szStringColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.oprcol
	LEA ECX, szOperatorColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.hicol1
	LEA ECX, szHiliteColor1
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.hicol2
	LEA ECX, szHiliteColor2
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.hicol3
	LEA ECX, szHiliteColor3
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.selbarbck
	LEA ECX, szSelBarBackColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.selbarpen
	LEA ECX, szSelBarPen
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.lnrcol
	LEA ECX, szLineNrColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.numcol
	LEA ECX, szNumberColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.tltbckcol
	LEA ECX, szTltBackColor
	CALL SaveIt

	Invoke wsprintf, ESI, Offset szColorTemplate, col.TltActParamCol
	LEA ECX, szTltActParamCol
	CALL SaveIt



	Invoke wsprintf, ESI, Offset szColorTemplate,col.RCBackCol
	LEA ECX,szRCBackCol
	CALL SaveIt


	;--------------------------------------------------------------------------------------------------------------
	;MOV EDI,Offset szEDITOR Already set!

	MOV ECX,hTabSizeText
	;LEA EDX,Buffer
	MOV EDX,ESI
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szTabSize, ESI, EBX
	;Get Tab Size back in numeric format
	Invoke GetPrivateProfileInt, EDI, Offset szTabSize, 0, EBX
	.If EAX<1 
		MOV TabSize,1
	.ElseIf EAX>20
		MOV TabSize,20
	.Else
		MOV TabSize,EAX
	.EndIf

	MOV ECX,hLnNrWidthText
	;LEA EDX,Buffer
	MOV EDX,ESI
	CALL GetText
	Invoke WritePrivateProfileString, EDI, Offset szLineNrWidth, ESI, EBX
	;Get Tab Size back in numeric format
	Invoke GetPrivateProfileInt, EDI, Offset szLineNrWidth, 0, EBX
	MOV LineNrWidth,EAX

	Invoke BinToDec,TabIndicators,ESI
	Invoke WritePrivateProfileString, EDI, Offset szTabIndicators, ESI, EBX

	Invoke BinToDec,ShowScrollTips,ESI
	Invoke WritePrivateProfileString, EDI, Offset szShowScrollTips, ESI, EBX

	Invoke BinToDec,ShowLineNumbersOnOpen,ESI
	Invoke WritePrivateProfileString, EDI, Offset szShowLineNumbersOnOpen, ADDR Buffer, EBX

	Invoke BinToDec,AutoshowLineNumbersOnError,ESI
	Invoke WritePrivateProfileString, EDI, Offset szAutoshowLineNumbersOnError, ESI, EBX


   	Invoke BinToDec,AutoIndent,ESI
	Invoke WritePrivateProfileString, EDI, Offset szAutoIndent, ESI, EBX

	Invoke BinToDec,AutoLineNrWidth,ESI
	Invoke WritePrivateProfileString, EDI, Offset szAutoLineNrWidth, ESI, EBX
	.If AutoLineNrWidth
		Invoke CalculateLineNrWidth
		MOV	LineNrWidth,EAX
	.EndIf

	Invoke BinToDec,TabToSpaces,ESI
	Invoke WritePrivateProfileString, EDI, Offset szTabToSpaces, ESI, EBX
	

	Invoke IsWindowEnabled,hGroupsList	;If not enabled, then masm.vas was not found so if now set properly if we save keywords then we delete first entry and list will never be enabled.
	.If EAX
		Invoke SaveKeyWords
	.EndIf
	
	Invoke SendMessage,hRetCombo,CB_GETCURSEL,0,0	
	;CB_ERR==-1
	Invoke BinToDec,EAX,ESI
	Invoke WritePrivateProfileString, EDI, Offset szRet, ESI, EBX

;	Invoke SendMessage,hEndPCombo,CB_GETCURSEL,0,0	
;	;CB_ERR==-1
;	Invoke BinToDec,EAX,ESI
;	Invoke WritePrivateProfileString, EDI, Offset szEndP, ESI, EBX

	Invoke BinToDec,fAutoComplete,ESI
	Invoke WritePrivateProfileString, Offset szINTELLISENSE , Offset szAutoComplete, ESI, EBX

	Invoke LockWindowUpdate, WinAsmHandles.hMain
	Invoke EnumProjectItems, Offset RepaintAll
	Invoke EnumOpenedExternalFiles,Offset RepaintAll
	Invoke LockWindowUpdate, 0

	Invoke SetProjectTreeAndProcListColors
	
	Invoke CreateTahomaFont
	Invoke RefreshTahomaFont
	Invoke EnumProjectItems,Offset RefreshComboBoxes
	Invoke EnumOpenedExternalFiles,Offset RefreshComboBoxes
	
;	Invoke SendMessage,hListProcedures,WM_SETFONT,hFont,FALSE
;	Invoke SendMessage,hListStructures,WM_SETFONT,hFont,FALSE
;	Invoke SendMessage,hListConstants,WM_SETFONT,hFont,FALSE
;	Invoke SendMessage,hListStructureMembers,WM_SETFONT,hFont,FALSE
;   	Invoke SendMessage,hListVariables,WM_SETFONT,hFont,FALSE
;	Invoke SendMessage,hListIncludes,WM_SETFONT,hFont,FALSE
;;	Invoke SendMessage,hToolTip,WM_SETFONT,hFont,FALSE

	.If hRCEditorWindow
		Invoke InvalidateRect,hRCEditorWindow,NULL,TRUE
	.EndIf
	RET
	
	;--------------------------------------------------------------
	GetText:
	Invoke SendMessage,ECX,WM_GETTEXT,MAX_PATH,EDX
	RETN
	
	;--------------------------------------------------------------	
	SaveIt:
	Invoke WritePrivateProfileString,EDI,ECX,ESI,EBX
    RETN
	
SaveOptions EndP

DeleteKeyWords Proc
Local nInx:DWORD
Local nCnt:DWORD
	Invoke SendMessage,hKeyWordsList,LB_GETSELCOUNT,0,0
	MOV nCnt,EAX
	MOV nInx,0
	.While nCnt
		Invoke SendMessage,hKeyWordsList,LB_GETSEL,nInx,0
		.If EAX
			Invoke SendMessage,hKeyWordsList,LB_DELETESTRING,nInx,0
			DEC nCnt
			MOV EAX,1
		.EndIf
		XOR EAX,1
		ADD nInx,EAX
	.EndW
	RET
DeleteKeyWords EndP

MoveKeyWords Proc hFrom:HWND,hTo:HWND
Local Buffer[64]:BYTE
Local nInx:DWORD
Local nCnt:DWORD

	Invoke SendMessage,hFrom,LB_GETSELCOUNT,0,0
	MOV nCnt,EAX
	MOV nInx,0
	.While nCnt
		Invoke SendMessage,hFrom,LB_GETSEL,nInx,0
		.If EAX
			Invoke SendMessage,hFrom,LB_GETTEXT,nInx,ADDR Buffer
			Invoke SendMessage,hFrom,LB_DELETESTRING,nInx,0
			Invoke SendMessage,hTo,LB_ADDSTRING,0,ADDR Buffer
			DEC nCnt
			MOV EAX,1
		.EndIf
		XOR EAX,1
		ADD nInx,EAX
	.EndW
	RET
MoveKeyWords EndP

SetKeyWordList Proc Uses EDI ESI EBX nInx:DWORD
	Invoke EnableWindow,hKeyWordsList,TRUE
	Invoke EnableWindow,hRecycledList,TRUE
	Invoke EnableWindow,hWordToAdd,TRUE
	Invoke SendMessage,hKeyWordsList,LB_RESETCONTENT,0,0
	.If nInx==0
		MOV EDI,lpC0WORDS
		CALL ExtractWords
	.ElseIf nInx==1
		MOV EDI,lpC1WORDS
		CALL ExtractWords
	.ElseIf nInx==2
		MOV EDI,lpC2WORDS
		CALL ExtractWords
	.ElseIf nInx==3
		MOV EDI,lpC3WORDS
		CALL ExtractWords
	.ElseIf nInx==4
		MOV EDI,lpC4WORDS
		CALL ExtractWords
	.ElseIf nInx==5
		MOV EDI,lpC5WORDS
		CALL ExtractWords
	.ElseIf nInx==6
		MOV EDI,lpC6WORDS
		CALL ExtractWords
	.ElseIf nInx==7
		MOV EDI,lpC7WORDS
		CALL ExtractWords
	.ElseIf nInx==8 || nInx==9 || nInx==10
		CALL API
		CALL GetBoldItalic
	.ElseIf nInx==11
		MOV EDI,lpC11WORDS
		CALL ExtractWords
	.ElseIf nInx==12
		MOV EDI,lpC12WORDS
		CALL ExtractWords
	.ElseIf nInx==13
		MOV EDI,lpC13WORDS
		CALL ExtractWords
	.ElseIf nInx==14
		MOV EDI,lpC14WORDS
		CALL ExtractWords
	.EndIf
	RET

	;--------------------------------------------------------------
	ExtractWords:
	.If EDI!=0
		Invoke SendMessage,hKeyWordsList,WM_SETREDRAW,FALSE,0
		MOV ESI,EDI
		.While BYTE PTR [EDI]!=0
			.If BYTE PTR [EDI]==" "
				MOV BYTE PTR [EDI],0
				Invoke SendMessage,hKeyWordsList,LB_ADDSTRING,0,ESI
				MOV BYTE PTR [EDI]," "
				MOV ESI,EDI
				INC ESI
			.EndIf
			INC EDI
		.EndW
		;Last Word
		Invoke SendMessage,hKeyWordsList,LB_ADDSTRING,0,ESI
		Invoke SendMessage,hKeyWordsList,WM_SETREDRAW,TRUE,0
		
		GetBoldItalic:
		Invoke SendMessage,hGroupsList,LB_GETITEMDATA,nInx,0
		SHR EAX,24
		MOV ESI,EAX
		MOV EAX,BST_UNCHECKED
		TEST ESI,1
		.If !ZERO?
			MOV EAX,BST_CHECKED
		.EndIf
		Invoke SendMessage,hBoldButton,BM_SETCHECK,EAX,0
		MOV EAX,BST_UNCHECKED
		TEST ESI,2
		.If !ZERO?
			MOV EAX,BST_CHECKED
		.EndIf
		Invoke SendMessage,hItalicButton, BM_SETCHECK,EAX,0
	.Else
		Invoke EnableWindow,hGroupsList,FALSE
		Invoke EnableWindow,hBoldButton,FALSE
		Invoke EnableWindow,hItalicButton,FALSE
		Invoke EnableWindow,hWordToAdd,FALSE
	.EndIf
	RETN
	
	API:
	Invoke SendMessage,hKeyWordsList,LB_RESETCONTENT,0,0
	Invoke EnableWindow,hKeyWordsList,FALSE
	Invoke EnableWindow,hRecycledList,FALSE
	Invoke EnableWindow,hWordToAdd,FALSE
	;MOV EDI,0
	RETN

SetKeyWordList EndP

FillCategoriesList Proc Uses EDI; hOptionsDialog:HWND
	MOV EAX,Offset szC0WORDS
	MOV EDI,C0
	CALL AddIt

	MOV EAX,Offset szC1WORDS
	MOV EDI,C1
	CALL AddIt

	MOV EAX,Offset szC2WORDS
	MOV EDI,C2
	CALL AddIt

	MOV EAX,Offset szC3WORDS
	MOV EDI,C3
	CALL AddIt

	MOV EAX,Offset szC4WORDS
	MOV EDI,C4
	CALL AddIt

	MOV EAX,Offset szC5WORDS
	MOV EDI,C5
	CALL AddIt

	MOV EAX,Offset szC6WORDS
	MOV EDI,C6
	CALL AddIt

	MOV EAX,Offset szC7WORDS
	MOV EDI,C7
	CALL AddIt

	MOV EAX,Offset szAPIFunctions
	MOV EDI,APIFunctionsColor
	CALL AddIt

	MOV EAX,Offset szAPIStructures
	MOV EDI,APIStructuresColor
	CALL AddIt

	MOV EAX,Offset szAPIConstants
	MOV EDI,APIConstantsColor
	CALL AddIt

	MOV EAX,Offset szC0RC
	MOV EDI,C11
	CALL AddIt
	
	MOV EAX,Offset szC1RC
	MOV EDI,C12
	CALL AddIt
	
	MOV EAX,Offset szC0BAT
	MOV EDI,C13
	CALL AddIt
	
	MOV EAX,Offset szC1BAT
	MOV EDI,C14
	CALL AddIt

	RET

	AddIt:
	;----
	Invoke SendMessage,hGroupsList,LB_ADDSTRING,0,EAX
	Invoke SendMessage,hGroupsList,LB_SETITEMDATA,EAX,EDI
	RETN

FillCategoriesList EndP

FillColorsList Proc Uses EDI

	MOV EAX,Offset szLBEditorBackColor			;"Editor Back Color"
	MOV EDI,tmpcol.bckcol
	CALL AddIt

	MOV EAX,Offset szLBNormalTextColor			;"Normal Text Color"
	MOV EDI,tmpcol.txtcol
	CALL AddIt

	MOV EAX,Offset szLBSelectionBackColor		;"Selection Back Color"
	MOV EDI,tmpcol.selbckcol
	CALL AddIt

	MOV EAX,Offset szLBSelectedTextColor		;"Selected Text Color"
	MOV EDI,tmpcol.seltxtcol
	CALL AddIt
	
	MOV EAX,Offset szLBCommentColor				;"Comment Color"
	MOV EDI, tmpcol.cmntcol
	CALL AddIt
	
	MOV EAX,Offset szLBStringColor				;"String Color"
	MOV EDI,tmpcol.strcol
	CALL AddIt
	
	MOV EAX,Offset szLBOperatorColor			;"Operator Color"
	MOV EDI,tmpcol.oprcol
	CALL AddIt
	
	MOV EAX,Offset szLBErroredLineBackColor		;"Errored Line Back Color"
	MOV EDI,tmpcol.hicol1
	CALL AddIt

	MOV EAX,Offset szLBNoErrorsLineBackColor	;"No Errors Line Back Color"
	MOV EDI,tmpcol.hicol2
	CALL AddIt
	
	MOV EAX,Offset szLBTabIndicatorsColor		;"Tab Indicators Color"
	MOV EDI, tmpcol.hicol3
	CALL AddIt

	
	MOV EAX,Offset szLBSelectionBarColor		;"Selection Bar Color"
	MOV EDI,tmpcol.selbarbck
	CALL AddIt
	
	MOV EAX,Offset szLBDividerLineColor			;"Divider Line Color"
	MOV EDI,tmpcol.selbarpen
	CALL AddIt

	MOV EAX,Offset szLBLinenumberscolor			;"Line numbers color"
	MOV EDI, tmpcol.lnrcol
	CALL AddIt
	
	MOV EAX,Offset szLBNumberColor				;"Number Color"
	MOV EDI, tmpcol.numcol
	CALL AddIt
	
	MOV EAX,Offset szLBToolTipsBackColor		;"ToolTips Back Color"
	MOV EDI,tmpcol.tltbckcol
	CALL AddIt
	
	MOV EAX,Offset szLBToolTipsActiveParamColor		;"ToolTips Active Parameter Color"
	MOV EDI,tmpcol.TltActParamCol
	CALL AddIt


	MOV EAX,Offset szLBProjectTreeBackColor		;"Project Tree Back Color"
	MOV EDI,tmpcol.TreeBackCol
	CALL AddIt
	
	MOV EAX,Offset szLBProjectTreeTextColor		;"Project Tree Text Color"
	MOV EDI,tmpcol.TreeTextCol
	CALL AddIt
	
	MOV EAX,Offset szLBProjectTreeLineColor		;"Project Tree Line Color"
	MOV EDI, tmpcol.TreeLineCol
	CALL AddIt
	
	MOV EAX,Offset szLBRCEditorBackColor		;"RC Editor Back Color"
	MOV EDI,tmpcol.RCBackCol
	CALL AddIt
	
	RET
	
	AddIt:
	;----
	Invoke SendMessage,hColorsList,LB_ADDSTRING,0,EAX
	Invoke SendMessage,hColorsList,LB_SETITEMDATA,EAX,EDI
	RETN

FillColorsList EndP

DrawListItems Proc Uses ESI lParam:LPARAM
Local Buffer[256]:BYTE
Local Rect:RECT
Local hBr:DWORD

	MOV ESI,lParam
	TEST [ESI].DRAWITEMSTRUCT.itemState,ODS_SELECTED
	.If ZERO?
		PUSH COLOR_WINDOW
		MOV EAX,COLOR_WINDOWTEXT
	.Else
		PUSH COLOR_HIGHLIGHT
		MOV EAX,COLOR_HIGHLIGHTTEXT
	.EndIf
	Invoke GetSysColor,EAX
	Invoke SetTextColor,[ESI].DRAWITEMSTRUCT.hdc,EAX

	POP EAX
	Invoke GetSysColor,EAX
	Invoke SetBkColor,[ESI].DRAWITEMSTRUCT.hdc,EAX
	Invoke ExtTextOut,[ESI].DRAWITEMSTRUCT.hdc,0,0,ETO_OPAQUE,ADDR [ESI].DRAWITEMSTRUCT.rcItem,NULL,0,NULL
	MOV EAX,[ESI].DRAWITEMSTRUCT.rcItem.left
	INC EAX
	MOV Rect.left,EAX
	ADD EAX,15;25
	MOV Rect.right,EAX
	MOV EAX,[ESI].DRAWITEMSTRUCT.rcItem.top
	INC EAX
	MOV Rect.top,EAX
	MOV EAX,[ESI].DRAWITEMSTRUCT.rcItem.bottom
	DEC EAX
	MOV Rect.bottom,EAX
	MOV EAX,[ESI].DRAWITEMSTRUCT.itemData
	AND EAX,0FFFFFFh
	Invoke CreateSolidBrush,EAX
	MOV hBr,EAX
	Invoke FillRect,[ESI].DRAWITEMSTRUCT.hdc,ADDR Rect,hBr
	Invoke DeleteObject,hBr
	Invoke GetStockObject,BLACK_BRUSH
	Invoke FrameRect,[ESI].DRAWITEMSTRUCT.hdc,ADDR Rect,EAX
	Invoke SendMessage,[ESI].DRAWITEMSTRUCT.hwndItem,LB_GETTEXT,[ESI].DRAWITEMSTRUCT.itemID,ADDR Buffer
	Invoke lstrlen,ADDR Buffer
	MOV EDX,[ESI].DRAWITEMSTRUCT.rcItem.left
	ADD EDX,20;30
	Invoke TextOut,[ESI].DRAWITEMSTRUCT.hdc,EDX,[ESI].DRAWITEMSTRUCT.rcItem.top,ADDR Buffer,EAX
	RET
DrawListItems EndP


OptionsDlgProc_InitDialog Proc Uses EDI ESI EBX hWnd:DWORD
Local Buffer[MAX_PATH]	:BYTE
Local szCounter[12]		:BYTE
Local Scheme			:SCHEME

Local lvc				:LV_COLUMN
Local lvi 				:LVITEM

	;--------------------------------------------------------------------------
	;Get the handle of TabControl
	Invoke GetDlgItem,hWnd,IDC_TABCONTROL
	MOV hOptionsTabControl, EAX
	MOV TabCtrlItem.imask,TCIF_TEXT
	
	MOV TabCtrlItem.pszText,Offset szMiscellaneous
	CALL InsertTabItem
	
	MOV TabCtrlItem.pszText,Offset szColors
	CALL InsertTabItem

	MOV TabCtrlItem.pszText,Offset szKeyWords
	CALL InsertTabItem

	MOV TabCtrlItem.pszText,Offset szIntellisense
	CALL InsertTabItem

	MOV TabCtrlItem.pszText,Offset szEditor
	CALL InsertTabItem

	MOV TabCtrlItem.pszText,Offset szFilesAndPaths
	CALL InsertTabItem

	MOV TabCtrlItem.pszText,Offset szGeneral
	CALL InsertTabItem
	
	Invoke SendMessage,hOptionsTabControl, TCM_SETCURSEL , 0, NULL
;--------------------------------------------------------------------------	
	Invoke GetDlgItem,hWnd,13	;Binary Path TextBox
	MOV hTextBinaryPath, EAX
	;Invoke GetPrivateProfileString, Offset szGeneral, Offset szBinaryPath, ADDR ZeroString, ADDR Buffer, MAX_PATH, Offset IniFileName
	Invoke SendMessage,hTextBinaryPath,WM_SETTEXT,NULL,Offset BinaryPath;ADDR Buffer
	
	Invoke GetDlgItem,hWnd,17	;Binary Path Label
	MOV hLabelBinaryPath, EAX
	;--------------------------------------------------------------------------	
	Invoke GetDlgItem,hWnd,8	;Include Path TextBox
	MOV hTextIncludePath, EAX
	;Invoke GetPrivateProfileString, Offset szGeneral, Offset szIncludePath, ADDR ZeroString, ADDR Buffer, MAX_PATH, Offset IniFileName
	Invoke SendMessage,hTextIncludePath,WM_SETTEXT,NULL, Offset IncludePath;ADDR Buffer
	
	Invoke GetDlgItem,hWnd,7	;Include Path Label
	MOV hLabelIncludePath, EAX
	;--------------------------------------------------------------------------	
	Invoke GetDlgItem,hWnd,10	;Library Path TextBox
	MOV hTextLibraryPath, EAX
	;Invoke GetPrivateProfileString, Offset szGeneral, Offset szLibraryPath, ADDR ZeroString, ADDR Buffer, MAX_PATH, Offset IniFileName
	Invoke SendMessage,hTextLibraryPath,WM_SETTEXT,NULL,Offset LibraryPath;ADDR Buffer

	
	Invoke GetDlgItem,hWnd,9	;Library Path Label
	MOV hLabelLibraryPath, EAX
    ;--------------------------------------------------------------------------	
	Invoke GetDlgItem,hWnd,11	;KeyFile TextBox
	MOV hTextKeyFile, EAX
	;Invoke GetPrivateProfileString, Offset szGeneral, Offset szKeyFile, ADDR ZeroString, ADDR Buffer, MAX_PATH, Offset IniFileName
	Invoke SendMessage,hTextKeyFile,WM_SETTEXT,NULL,Offset KeyWordsFileName;ADDR Buffer
	
	Invoke GetDlgItem,hWnd,15	;KeyFile Label
	MOV hLabelKeyFile, EAX
	
	Invoke GetDlgItem,hWnd,3	;KeyFile Browse button
	MOV hBrowseKeyFile, EAX
    ;--------------------------------------------------------------------------
	Invoke GetDlgItem,hWnd,61	;APIFunctions TextBox
	MOV hTextAPIFunctionsFile, EAX
	;Invoke GetPrivateProfileString, Offset szGeneral, Offset szAPIFunctionsFile, ADDR ZeroString, ADDR Buffer, MAX_PATH, Offset IniFileName
	Invoke SendMessage,hTextAPIFunctionsFile,WM_SETTEXT,NULL, Offset APIFunctionsFile
	
	Invoke GetDlgItem,hWnd,60	;APIFunctions Label
	MOV hLabelAPIFunctionsFile, EAX
	
	Invoke GetDlgItem,hWnd,62	;APIFunctions Browse button
	MOV hBrowseAPIFunctionsFile, EAX
    ;--------------------------------------------------------------------------
   	Invoke GetDlgItem,hWnd,64	;APIStructures TextBox
	MOV hTextAPIStructuresFile, EAX
	;Invoke GetPrivateProfileString, Offset szGeneral, Offset szAPIFunctionsFile, ADDR ZeroString, ADDR Buffer, MAX_PATH, Offset IniFileName

	Invoke SendMessage,hTextAPIStructuresFile,WM_SETTEXT,NULL, Offset APIStructuresFile
	
	Invoke GetDlgItem,hWnd,63	;APIFunctions Label
	MOV hLabelAPIStructuresFile, EAX
	
	Invoke GetDlgItem,hWnd,65	;APIFunctions Browse button
	MOV hBrowseAPIStructuresFile, EAX
    ;--------------------------------------------------------------------------
	Invoke GetDlgItem,hWnd,67	;API Constants TextBox
	MOV hTextAPIConstantsFile, EAX
	;Invoke GetPrivateProfileString, Offset szGeneral, Offset szAPIFunctionsFile, ADDR ZeroString, ADDR Buffer, MAX_PATH, Offset IniFileName
	Invoke SendMessage,hTextAPIConstantsFile,WM_SETTEXT,NULL, Offset APIConstantsFile
	
	Invoke GetDlgItem,hWnd,66	;API Constants Label
	MOV hLabelAPIConstantsFile, EAX
	
	Invoke GetDlgItem,hWnd,68	;API Constants Browse button
	MOV hBrowseAPIConstantsFile, EAX
    ;--------------------------------------------------------------------------

    Invoke GetDlgItem,hWnd,12	;HelpFile TextBox
	MOV hTextHelpFile, EAX
	Invoke SendMessage,hTextHelpFile,WM_SETTEXT,NULL,Offset HelpFileName
	
	Invoke GetDlgItem,hWnd,16	;HelpFile Label
	MOV hLabelHelpFile, EAX
	
	Invoke GetDlgItem,hWnd,5	;HelpFile Browse button
	MOV hBrowseHelpFile, EAX
    ;--------------------------------------------------------------------------

    Invoke GetDlgItem,hWnd,128	;DefaultProjectDir Label
	MOV hLabelDefaultProjectDir, EAX
	
	Invoke GetDlgItem,hWnd,129	;DefaultProjectDir TextBox
	MOV hTextDefaultProjectDir, EAX
	;PrintString InitDir
	Invoke SendMessage,hTextDefaultProjectDir,WM_SETTEXT,NULL,Offset InitDir
	
	Invoke GetDlgItem,hWnd,130	;DefaultProjectDir Browse button
	MOV hBrowseDefaultProjectDir, EAX
    ;--------------------------------------------------------------------------



	Invoke GetDlgItem,hWnd,50
	MOV hTabToSpaces, EAX
	.If TabToSpaces==TRUE
		Invoke CheckDlgButton,hWnd,50,TRUE
	.EndIf
	
	Invoke GetDlgItem,hWnd,51
	MOV hTabSizeLabel, EAX
	
	Invoke GetDlgItem,hWnd,52
	MOV hTabSizeText, EAX

	;Invoke wsprintf,ADDR Buffer, Offset szDecimalTemplate,TabSize
	Invoke BinToDec,TabSize,ADDR Buffer
	Invoke SendMessage,hTabSizeText,WM_SETTEXT,NULL,ADDR Buffer


	Invoke GetDlgItem,hWnd,54
	MOV hAutoIndent, EAX
	.If AutoIndent==TRUE
		Invoke CheckDlgButton,hWnd,54,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,114
	MOV hTabIndicators, EAX
	.If TabIndicators==TRUE
		Invoke CheckDlgButton,hWnd,114,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,123
	MOV hShowScrollTips, EAX
	.If ShowScrollTips==TRUE
		Invoke CheckDlgButton,hWnd,123,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,125
	MOV hShowLineNumbersOnOpen,EAX
	.If ShowLineNumbersOnOpen==TRUE
		Invoke CheckDlgButton,hWnd,125,TRUE
	.EndIf
	
	Invoke GetDlgItem,hWnd,126
	MOV hAutoshowLineNumbersOnError,EAX
	.If AutoshowLineNumbersOnError==TRUE
		Invoke CheckDlgButton,hWnd,126,TRUE
	.EndIf


	Invoke GetDlgItem,hWnd,124
	MOV hGradientMenuItems, EAX
	.If GradientMenuItems==TRUE
		Invoke CheckDlgButton,hWnd,124,TRUE
	.EndIf


	Invoke GetDlgItem,hWnd,56
	MOV hLnNrWidthText, EAX

;	Invoke wsprintf,ADDR Buffer, Offset szDecimalTemplate,LineNrWidth
	Invoke BinToDec,LineNrWidth,ADDR Buffer
	Invoke SendMessage,hLnNrWidthText,WM_SETTEXT,NULL,ADDR Buffer

	Invoke GetDlgItem,hWnd,55
	MOV hLnNrWidth, EAX
	.If AutoLineNrWidth==TRUE
		Invoke CheckDlgButton,hWnd,55,TRUE
		Invoke EnableWindow,hLnNrWidthText,FALSE
	.EndIf

	Invoke GetDlgItem,hWnd,69
	MOV hAutoSave, EAX
	.If AutoSave==TRUE
		Invoke CheckDlgButton,hWnd,69,TRUE
	.EndIf
	
	Invoke GetDlgItem,hWnd,89
	MOV hShowOutOnSuccess,EAX
	.If ShowOutOnSuccess==TRUE
		Invoke CheckDlgButton,hWnd,89,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,90
	MOV hGoupBoxOnStartUp, EAX

	Invoke GetDlgItem,hWnd,91
	MOV hOpenDlgOnStartUp, EAX

	Invoke GetDlgItem,hWnd,92
	MOV hOpenLastProjectOnStartUp, EAX

	Invoke GetDlgItem,hWnd,127
	MOV hShowRecentProjectsOnStartUp, EAX

	Invoke GetDlgItem,hWnd,93
	MOV hNoneOnStartUp, EAX

	.If OnStartUp==0
		Invoke CheckDlgButton,hWnd,91,TRUE
	.ElseIf OnStartUp==1
		Invoke CheckDlgButton,hWnd,92,TRUE
	.ElseIf OnStartUp==2
		Invoke CheckDlgButton,hWnd,127,TRUE
	.Else
		Invoke CheckDlgButton,hWnd,93,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,71
	MOV hGroupsLabel, EAX
	Invoke GetDlgItem,hWnd,72
	MOV hGroupsList, EAX

	Invoke GetDlgItem,hWnd,73
	MOV hKeyWordsLabel, EAX
	Invoke GetDlgItem,hWnd,74
	MOV hKeyWordsList, EAX
	Invoke SendMessage,hKeyWordsList,LB_SETHORIZONTALEXTENT,180,0
	
	Invoke GetDlgItem,hWnd,75
	MOV hRecycledLabel, EAX
	Invoke GetDlgItem,hWnd,76
	MOV hRecycledList, EAX
	Invoke SendMessage,hRecycledList,LB_SETHORIZONTALEXTENT,180,0

	Invoke GetDlgItem,hWnd,77
	MOV hToRecycled,EAX

	Invoke ImageList_Create,11,11,ILC_COLOR4 OR ILC_MASK,2,2
	MOV hImages,EAX
	Invoke LoadImage,  hInstance, 114, IMAGE_BITMAP, 0, 0, LR_DEFAULTCOLOR
	PUSH EAX
	Invoke ImageList_AddMasked,hImages,EAX,0C0C0C0h
	POP EAX
	Invoke DeleteObject,EAX
	Invoke ImageList_GetIcon,hImages,0,NULL
	Invoke SendMessage,hToRecycled,BM_SETIMAGE,IMAGE_ICON,EAX

	Invoke GetDlgItem,hWnd,78
	MOV hFromRecycled,EAX
	Invoke LoadImage,  hInstance, 113, IMAGE_BITMAP, 0, 0,LR_DEFAULTCOLOR
	PUSH EAX
	Invoke ImageList_AddMasked,hImages,EAX,0C0C0C0h
	POP EAX
	Invoke DeleteObject,EAX
	Invoke ImageList_GetIcon,hImages,1,NULL
	Invoke SendMessage,hFromRecycled,BM_SETIMAGE,IMAGE_ICON,EAX

	Invoke GetDlgItem,hWnd,79
	MOV hWordToAdd,EAX
	Invoke SendMessage,EAX,EM_LIMITTEXT,32,0

	Invoke GetDlgItem,hWnd,80
	MOV hAddButton,EAX
	
	Invoke GetDlgItem,hWnd,81
	MOV hDeleteButton,EAX

	Invoke GetDlgItem,hWnd,82
	MOV hBoldButton,EAX
	Invoke GetDlgItem,hWnd,83
	MOV hItalicButton,EAX

	Invoke GetDlgItem,hWnd,84
	MOV hApplyButton,EAX

	Invoke GetDlgItem,hWnd,85	;Show Splash on StartUp
	MOV hShowSplash, EAX
	.If ShowSplashOnStartUp==TRUE
		Invoke CheckDlgButton,hWnd,85,TRUE
	.EndIf
	
	Invoke GetDlgItem,hWnd,97	;On Minimize Go to System Tray
	MOV hOnMinimizeToSysTray, EAX
	.If OnMinimizeToSysTray==TRUE
		Invoke CheckDlgButton,hWnd,97,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,111	;AutoToolAndOptions
	MOV hAutoToolAndOptions, EAX
	.If AutoToolAndOptions==TRUE
		Invoke CheckDlgButton,hWnd,111,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,115
	MOV hAutoClean, EAX
	.If AutoClean==TRUE
		Invoke CheckDlgButton,hWnd,115,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,110	;Open Children Maximized
	MOV hOpenChildrenMaximized, EAX
	.If OpenChildStyle
		Invoke CheckDlgButton,hWnd,110,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,86
	MOV hBrowseForBinaryPath, EAX
	Invoke GetDlgItem,hWnd,87
	MOV hBrowseForIncludePath, EAX
	Invoke GetDlgItem,hWnd,88
	MOV hBrowseForLibraryPath, EAX

	Invoke GetDlgItem,hWnd,94
	MOV hTextExtResEd,EAX
	Invoke SendMessage,hTextExtResEd,WM_SETTEXT,NULL,Offset ExternalResourceEditor
	Invoke GetDlgItem,hWnd,95
	MOV hLabelExtResEd,EAX
	Invoke GetDlgItem,hWnd,96
	MOV hBrowseForExtResEd,EAX
	
	Invoke GetDlgItem,hWnd,98
	MOV hLaunchExeOnGoAll, EAX
	.If LaunchExeOnGoAll==TRUE
		Invoke CheckDlgButton,hWnd,98,TRUE
	.EndIf
	
	Invoke GetDlgItem,hWnd,99
	MOV hUseQuotes, EAX
	.If UseQuotes==TRUE
		Invoke CheckDlgButton,hWnd,99,TRUE
	.EndIf

	Invoke GetDlgItem,hWnd,144
	MOV hDebugUseQuotes, EAX
	.If DebugUseQuotes==TRUE
		Invoke CheckDlgButton,hWnd,144,TRUE
	.EndIf

	

	Invoke GetDlgItem,hWnd,101
	MOV hTextExtDebugger,EAX
	Invoke SendMessage,hTextExtDebugger,WM_SETTEXT,NULL,Offset ExternalDebugger
	Invoke GetDlgItem,hWnd,100
	MOV hLabelExtDebugger,EAX
	Invoke GetDlgItem,hWnd,102
	MOV hBrowseForExtDebugger,EAX

	Invoke GetDlgItem,hWnd,103
	MOV hProcAutoComplete,EAX

	Invoke GetDlgItem,hWnd,104
	MOV hRetLabel,EAX
	Invoke GetDlgItem,hWnd,105
	MOV hRetCombo,EAX
	Invoke SendMessage,hRetCombo,CB_ADDSTRING,0,Offset szDefault
	Invoke SendMessage,hRetCombo,CB_ADDSTRING,0,Offset szLowercase
	Invoke SendMessage,hRetCombo,CB_ADDSTRING,0,Offset szUppercase
	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szRet, 0, Offset IniFileName
	.If EAX!=1 && EAX!=2
		XOR EAX,EAX
	.EndIf
	Invoke SendMessage,hRetCombo,CB_SETCURSEL ,EAX,0	
	

;	Invoke GetDlgItem,hWnd,106
;	MOV hEndPLabel,EAX
;	Invoke GetDlgItem,hWnd,107
;	MOV hEndPCombo,EAX
;	Invoke SendMessage,hEndPCombo,CB_ADDSTRING,0,Offset szDefault
;	Invoke SendMessage,hEndPCombo,CB_ADDSTRING,0,Offset szUppercase
;	Invoke SendMessage,hEndPCombo,CB_ADDSTRING,0,Offset szLowercase
;	Invoke GetPrivateProfileInt, Offset szEDITOR, Offset szEndP, 0, Offset IniFileName
;	.If EAX!=1 && EAX!=2
;		XOR EAX,EAX
;	.EndIf
;	Invoke SendMessage,hEndPCombo,CB_SETCURSEL ,EAX,0	

	
	Invoke GetDlgItem,hWnd,118
	MOV hColorsList, EAX
	Invoke SendMessage,hColorsList,LB_SETHORIZONTALEXTENT,180,0
	Invoke FillColorsList
	
	Invoke GetDlgItem,hWnd,119
	MOV hSchemesLabel, EAX

	Invoke GetDlgItem,hWnd,120
	MOV hSchemesCombo, EAX
	Invoke SendMessage,hSchemesCombo,CB_LIMITTEXT,63,0
	
	PUSH EDI
	;Invoke HeapAlloc, hMainHeap, HEAP_ZERO_MEMORY, SizeOf SCHEME
	;MOV	EDI,EAX
	LEA EDI,Scheme

	
	PUSH EBX
	XOR EBX,EBX
	
	@@:
	INC EBX
	Invoke BinToDec,EBX,ADDR szCounter
	Invoke GetPrivateProfileStruct,Offset szSCHEMES,ADDR szCounter,EDI,SizeOf SCHEME,Offset IniFileName
	.If EAX
		Invoke SendMessage,hSchemesCombo,CB_ADDSTRING,0,ADDR [EDI].SCHEME.SchemeName
		;Invoke SendMessage,hSchemesCombo,CB_SETITEMDATA,EAX,EBX
		JMP @B
	.EndIf
	
	POP EBX
	;Invoke HeapFree,hMainHeap,0,EDI
	POP EDI
	
	Invoke GetDlgItem,hWnd,121
	MOV hSaveSchemeButton, EAX
	
	Invoke GetDlgItem,hWnd,122
	MOV hDeleteSchemeButton, EAX

	
	Invoke GetDlgItem,hWnd,131
	MOV hFunctionTriggerList, EAX
	
;	Invoke SetWindowLong,hFunctionTriggerList,GWL_WNDPROC,Offset DummyListViewProc
;	Invoke SetWindowLong,hFunctionTriggerList,GWL_USERDATA,EAX
	
	Invoke GetDlgItem,hWnd,132
	MOV hOpeningParenthesis, EAX
	Invoke GetDlgItem,hWnd,133
	MOV hAcceptsParameters, EAX
	Invoke GetDlgItem,hWnd,134
	MOV hCanBeAParameter, EAX
	Invoke GetDlgItem,hWnd,135
	MOV hFunctionTriggerLabel, EAX

	Invoke GetDlgItem,hWnd,136
	MOV hFunctionNameEdit, EAX
	Invoke GetDlgItem,hWnd,137
	MOV hAddFunctionButton, EAX
	Invoke GetDlgItem,hWnd,138
	MOV hDeleteFunctionButton, EAX
	Invoke GetDlgItem,hWnd,139
	MOV hApplyFunctionButton, EAX



	MOV lvc.imask, LVCF_FMT OR LVCF_WIDTH
	MOV lvc.fmt,LVCFMT_LEFT
	mov lvc.lx,200
	Invoke SendMessage, hFunctionTriggerList, LVM_INSERTCOLUMN, 0, ADDR lvc
	
	Invoke SendMessage, hFunctionTriggerList, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT OR LVS_EX_LABELTIP
	
	MOV lvi.imask,LVIF_TEXT OR LVIF_PARAM
	MOV lvi.cchTextMax,256
	MOV lvi.iSubItem, 0

	MOV EDI,lpTrigger
	XOR EAX,EAX
	@@:
	MOV lvi.iItem,EAX
	.If BYTE PTR [EDI]
		Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf FUNCTIONLISTTRIGGER
		MOV lvi.lParam,EAX
		Invoke RtlMoveMemory,EAX,EDI,SizeOf FUNCTIONLISTTRIGGER
		LEA EAX,[EDI].FUNCTIONLISTTRIGGER.szKeyWord
		MOV lvi.pszText,EAX
		Invoke SendMessage,hFunctionTriggerList,LVM_INSERTITEM,0,ADDR lvi
		INC EAX
		ADD EDI,SizeOf FUNCTIONLISTTRIGGER
		JMP @B
	.EndIf
	
;	Invoke GetWindowRect,hFunctionTriggerList,ADDR Rect
;
;	Invoke GetSystemMetrics,SM_CXBORDER
;	MOV EDI,EAX
;	SHL EDI,1	;Twice
;	
;	Invoke GetWindowLong,hFunctionTriggerList,GWL_STYLE
;	AND EAX,WS_VSCROLL
;	.If EAX	;i.e. If VSCROLL is present, take its width into account
;		Invoke GetSystemMetrics,SM_CXVSCROLL
;	.Else
;		XOR EAX,EAX
;	.EndIf
;	
;	ADD EDI,EAX
;	ADD EDI,2	;Emperical
;	
;	MOV ECX,Rect.right
;	SUB ECX,Rect.left
;	SUB ECX,EDI
;	Invoke SendMessage, hFunctionTriggerList, LVM_SETCOLUMNWIDTH, 0, ECX

	Invoke GetDlgItem,hWnd,140
	MOV hAutoCompleteWithLabel,EAX
	
	Invoke GetDlgItem,hWnd,141
	MOV hAutoCompleteWithSpace,EAX
	MOV EAX,fAutoComplete
	AND EAX,AUTOCOMPLETEWITHSPACE
	.If EAX
		Invoke CheckDlgButton,hWnd,141,BST_CHECKED
	.EndIf
	
	
	Invoke GetDlgItem,hWnd,142
	MOV hAutoCompleteWithTab,EAX
	MOV EAX,fAutoComplete
	AND EAX,AUTOCOMPLETEWITHTAB
	.If EAX
		Invoke CheckDlgButton,hWnd,142,BST_CHECKED
	.EndIf

	Invoke GetDlgItem,hWnd,143
	MOV hAutoCompleteWithEnter,EAX
	MOV EAX,fAutoComplete
	AND EAX,AUTOCOMPLETEWITHENTER
	.If EAX
		Invoke CheckDlgButton,hWnd,143,BST_CHECKED
	.EndIf

	Invoke GetDlgItem,hWnd,145
	MOV hObjectsFont,EAX
	.If ObjectsFont
		Invoke CheckDlgButton,hWnd,145,BST_CHECKED
	.EndIf

	;-------------------------------------------------------------------
	Invoke FillCategoriesList
	Invoke SendMessage,hGroupsList,LB_SETCURSEL,0,0
	Invoke SetKeyWordList,0
	
	Invoke SetFocus,hOptionsTabControl
	

	RET
	
	InsertTabItem:
	Invoke SendMessage,hOptionsTabControl,TCM_INSERTITEM,0,Offset TabCtrlItem

	RETN
OptionsDlgProc_InitDialog EndP

GetColorsFromScheme Proc Uses EBX EDI ESI; lpSchemeName:LPSTR
Local szCounter[12]	:BYTE
Local Scheme		:SCHEME

	Invoke SendMessage,hSchemesCombo,CB_GETCURSEL,0,0
	.If EAX!=CB_ERR
		INC EAX
		;Invoke wsprintf, ADDR szCounter, Offset szDecimalTemplate, EAX
		LEA EDX,szCounter
		Invoke BinToDec,EAX,EDX
		Invoke GetPrivateProfileStruct,Offset szSCHEMES,ADDR szCounter,ADDR Scheme,SizeOf SCHEME,Offset IniFileName
		Invoke RtlMoveMemory,ADDR tmpcol,ADDR Scheme.Color,SizeOf CHCOLOR
		
		XOR EDI,EDI
		LEA EBX,Scheme
		ADD EBX,SizeOf Scheme.SchemeName
		XOR ESI,ESI
		
		.While ESI<SizeOf Scheme.Color
			Invoke SendMessage,hColorsList,LB_SETITEMDATA,EDI,[EBX]
			INC EDI
			ADD ESI,4
			ADD EBX,4
		.EndW
		Invoke InvalidateRect,hColorsList,NULL,FALSE
	.EndIf
	RET

GetColorsFromScheme EndP

OptionsDlgProc Proc Uses EBX hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
Local Buffer[128]	:BYTE
Local Scheme		:SCHEME
Local lvi			:LVITEM
Local lvfi			:LV_FINDINFO

	.If uMsg == WM_INITDIALOG
		Invoke SendDlgItemMessage,hWnd,136,EM_LIMITTEXT,32,0
		Invoke RtlMoveMemory, ADDR tmpcol, ADDR col, SizeOf CHCOLOR
		
		Invoke OptionsDlgProc_InitDialog, hWnd
		;Copy all colors to a temporary variable (tmpcol)
		
	.ElseIf uMsg==WM_DRAWITEM
		;.If wParam==72 || wParam==118
			Invoke DrawListItems,lParam
		;.EndIf
		
	.ElseIf uMsg == WM_COMMAND
		MOV EAX,wParam
		SHR EAX,16
		MOV EDX,wParam
		.If AX==BN_CLICKED
			.If DX == 1		;OK
				Invoke SendMessage,hWnd,WM_CLOSE,0,TRUE
			.ElseIf DX==2	;Cancel
				Invoke SendMessage,hWnd,WM_CLOSE,0,0
			.ElseIf DX==55	;Auto LineNr Width
				Invoke SendMessage,hLnNrWidth,BM_GETCHECK,0,0
				.If EAX
					Invoke EnableWindow,hLnNrWidthText,FALSE
				.Else
					Invoke EnableWindow,hLnNrWidthText,TRUE
				.EndIf
				
			.ElseIf DX==3	;Browse For KeyFile
				Invoke BrowseForFile,hWnd,Offset KeyFilesFilter, hTextKeyFile,0
			.ElseIf DX==62	;Browse For APIFunctionsFile
				Invoke BrowseForFile,hWnd,Offset APIFilesFilter, hTextAPIFunctionsFile,0
			.ElseIf DX==65	;Browse For APIStructuresFile
				Invoke BrowseForFile,hWnd,Offset APIFilesFilter, hTextAPIStructuresFile,0
			.ElseIf DX==68	;Browse For APIConstantsFile
				Invoke BrowseForFile,hWnd,Offset APIFilesFilter, hTextAPIConstantsFile,0
			.ElseIf DX==5	;Browse For HelpFile
				Invoke BrowseForFile,hWnd,Offset HelpFilesFilter, hTextHelpFile,0
			.ElseIf DX==86
				Invoke BrowseForAnyFolder,hWnd,hTextBinaryPath,0
			.ElseIf DX==87
				Invoke BrowseForAnyFolder,hWnd,hTextIncludePath,0
			.ElseIf DX==88
				Invoke BrowseForAnyFolder,hWnd,hTextLibraryPath,0
			.ElseIf DX==96
				Invoke BrowseForFile,hWnd,Offset ExecutablesFilter,hTextExtResEd,0
			.ElseIf DX==102
				Invoke BrowseForFile,hWnd,Offset ExecutablesFilter,hTextExtDebugger,0
			.ElseIf DX==130	;DefaultProjectDir Browse button
				Invoke BrowseForAnyFolder,hWnd,hTextDefaultProjectDir,0
			.ElseIf DX==77	;To Recycled
				Invoke MoveKeyWords,hKeyWordsList,hRecycledList
				Invoke EnableWindow,hToRecycled,FALSE
				Invoke EnableWindow,hDeleteButton,FALSE
				Invoke EnableWindow,hApplyButton,TRUE
			.ElseIf DX==78	;From Recycled
				Invoke MoveKeyWords,hRecycledList,hKeyWordsList
				Invoke EnableWindow,hFromRecycled,FALSE
				Invoke EnableWindow,hApplyButton,TRUE
			.ElseIf DX==80;IDC_BTNADD
				Invoke SendMessage,hWordToAdd,WM_GETTEXT,64,ADDR Buffer
				Invoke SendMessage,hKeyWordsList,LB_ADDSTRING,0,ADDR Buffer
				Invoke SendMessage,hWordToAdd,WM_SETTEXT,0,NULL
				Invoke EnableWindow,hApplyButton,TRUE
				Invoke SetFocus,hWordToAdd
			.ElseIf DX==81;IDC_BTNDEL
				Invoke DeleteKeyWords
				Invoke EnableWindow,hToRecycled,FALSE
				Invoke EnableWindow,hDeleteButton,FALSE
				Invoke EnableWindow,hApplyButton,TRUE
			.ElseIf DX==IDC_CHKBOLD
				Invoke SendMessage,hGroupsList,LB_GETCURSEL,0,0
				PUSH EAX
				Invoke SendMessage,hGroupsList,LB_GETITEMDATA,EAX,0
				POP EDX
				XOR EAX,01000000h
				Invoke SendMessage,hGroupsList,LB_SETITEMDATA,EDX,EAX
				Invoke EnableWindow,hApplyButton,TRUE
			.ElseIf DX==IDC_CHKITALIC
				Invoke SendMessage,hGroupsList,LB_GETCURSEL,0,0
				PUSH EAX
				Invoke SendMessage,hGroupsList,LB_GETITEMDATA,EAX,0
				POP EDX
				XOR EAX,02000000h
				Invoke SendMessage,hGroupsList,LB_SETITEMDATA,EDX,EAX
				Invoke EnableWindow,hApplyButton,TRUE
			.ElseIf DX==IDC_BUTTONAPPLY
				;Do everything needed first
				Invoke SaveKeyWords
				Invoke LockWindowUpdate, WinAsmHandles.hMain
				Invoke EnumProjectItems, Offset RepaintAll
				Invoke EnumOpenedExternalFiles,Offset RepaintAll
				Invoke LockWindowUpdate, 0
				Invoke EnableWindow,hApplyButton,FALSE
			.ElseIf DX==122	;Delete Scheme
				Invoke SendMessage,hSchemesCombo,CB_GETCURSEL,0,0
				.If EAX!=CB_ERR
					MOV EBX,EAX
					PUSH EBX
					Invoke SendMessage,hSchemesCombo,CB_DELETESTRING,EAX,0
					@@:
					ADD EBX,2
					;Invoke wsprintf, ADDR Buffer, Offset szDecimalTemplate, EBX
					Invoke BinToDec,EBX,ADDR Buffer
					Invoke GetPrivateProfileStruct,Offset szSCHEMES,ADDR Buffer,ADDR Scheme,SizeOf SCHEME,Offset IniFileName
					.If EAX
						DEC EBX
						;Invoke wsprintf, ADDR Buffer, Offset szDecimalTemplate, EBX
						Invoke BinToDec,EBX,ADDR Buffer
						Invoke WritePrivateProfileStruct,Offset szSCHEMES,ADDR Buffer,ADDR Scheme,SizeOf SCHEME,Offset IniFileName
						JMP @B
					.EndIf
					
					DEC EBX
					;Invoke wsprintf, ADDR Buffer, Offset szDecimalTemplate, EBX
					Invoke BinToDec,EBX,ADDR Buffer
					Invoke WritePrivateProfileString,Offset szSCHEMES,ADDR Buffer,Offset szNULL,Offset IniFileName
					
					POP EBX
					Invoke SendMessage,hSchemesCombo,CB_GETCOUNT,0,0
					.If EAX==EBX
						DEC EBX
					.EndIf
					Invoke SendMessage,hSchemesCombo,CB_SETCURSEL,EBX,0
					Invoke GetColorsFromScheme
				.EndIf
			.ElseIf DX==121	;Save Scheme
				Invoke SendMessage,hSchemesCombo,WM_GETTEXT,63,ADDR Buffer
				.If Buffer[0]
					Invoke lstrcpy,ADDR Scheme,ADDR Buffer
					Invoke RtlMoveMemory,ADDR Scheme.Color,ADDR tmpcol,SizeOf CHCOLOR
					Invoke SendMessage,hSchemesCombo,CB_FINDSTRINGEXACT,-1,ADDR Buffer
					.If EAX==CB_ERR	;i.e not found
						Invoke SendMessage,hSchemesCombo,CB_ADDSTRING,0,ADDR Buffer
						Invoke SendMessage,hSchemesCombo,CB_GETCOUNT,0,0
						;Invoke wsprintf, ADDR Buffer, Offset szDecimalTemplate, EAX
						LEA EDX,Buffer
						Invoke BinToDec,EAX,EDX
						Invoke WritePrivateProfileStruct,Offset szSCHEMES,ADDR Buffer, ADDR Scheme,SizeOf SCHEME,Offset IniFileName
					.Else
						INC EAX
						;Invoke wsprintf, ADDR Buffer, Offset szDecimalTemplate, EAX
						LEA EDX,Buffer
						Invoke BinToDec,EAX,EDX
						Invoke WritePrivateProfileStruct,Offset szSCHEMES,ADDR Buffer, ADDR Scheme,SizeOf SCHEME,Offset IniFileName
					.EndIf
				.EndIf
				
			.ElseIf DX==137	;New Function Trigger
				Invoke SendDlgItemMessage,hWnd,136,WM_SETTEXT,0,Offset szNULL
				Invoke CheckDlgButton,hWnd,132,BST_UNCHECKED
				Invoke CheckDlgButton,hWnd,133,BST_UNCHECKED
				Invoke CheckDlgButton,hWnd,134,BST_UNCHECKED
				Invoke SendDlgItemMessage,hWnd,131,LVM_GETNEXTITEM,-1,LVNI_ALL OR LVNI_SELECTED
				.If EAX!=-1
					MOV lvi.iItem,EAX
					MOV lvi.imask,LVIF_STATE
					MOV lvi.iSubItem, 0
					MOV lvi.state,0
					MOV lvi.stateMask,LVIS_SELECTED OR LVIS_FOCUSED
					Invoke SendDlgItemMessage,hWnd,131,LVM_SETITEM,0,ADDR lvi
				.EndIf
			.ElseIf DX==138	;Delete Function Trigger
				Invoke SendDlgItemMessage,hWnd,131,LVM_GETNEXTITEM,-1,LVNI_ALL OR LVNI_SELECTED
				.If EAX!=-1	;if there is selected
					MOV lvi.imask,LVIF_PARAM
					MOV lvi.iSubItem,0
					MOV lvi.iItem,EAX
					;Trigger list
					Invoke SendDlgItemMessage,hWnd,131,LVM_GETITEM,0,ADDR lvi
					Invoke HeapFree,hMainHeap,0,lvi.lParam
					Invoke SendDlgItemMessage,hWnd,131,LVM_DELETEITEM,lvi.iItem,0
					
					Invoke SendDlgItemMessage,hWnd,131,LVM_GETITEMCOUNT,0,0
					.If EAX
						DEC EAX
						.If lvi.iItem>EAX
							DEC lvi.iItem
						.EndIf
						MOV lvi.imask,LVIF_STATE
						MOV lvi.state,LVIS_SELECTED OR LVIS_FOCUSED
						MOV lvi.stateMask,LVIS_SELECTED OR LVIS_FOCUSED
						Invoke SendDlgItemMessage,hWnd,131,LVM_SETITEM,0,ADDR lvi
					.Else
						Invoke SendDlgItemMessage,hWnd,136,WM_SETTEXT,0,Offset szNULL
						Invoke CheckDlgButton,hWnd,132,BST_UNCHECKED
						Invoke CheckDlgButton,hWnd,133,BST_UNCHECKED
						Invoke CheckDlgButton,hWnd,134,BST_UNCHECKED
					.EndIf
				.EndIf
			.ElseIf DX==139	;Apply Function Trigger
				Invoke GetDlgItemText,hWnd,136,ADDR Buffer,32
				.If Buffer[0]!=0
					
					Invoke RtlZeroMemory,ADDR lvfi,SizeOf LV_FINDINFO
					MOV lvfi.flags,LVFI_STRING 
					LEA EDX,Buffer
					MOV lvfi.psz,EDX
					Invoke SendDlgItemMessage,hWnd,131,LVM_FINDITEM,-1,ADDR lvfi
					;.If EAX==-1 ;i.e if there is NOT such text in the list
					MOV EBX,EAX
					
					Invoke SendDlgItemMessage,hWnd,131,LVM_GETNEXTITEM,-1,LVNI_ALL OR LVNI_SELECTED
					.If EAX==-1	&& EBX==-1;Insert new item
						MOV lvi.imask,LVIF_TEXT OR LVIF_PARAM OR LVIF_STATE
						MOV lvi.cchTextMax,32
						MOV lvi.iSubItem, 0
						MOV lvi.state,LVIS_SELECTED OR LVIS_FOCUSED
						MOV lvi.stateMask,LVIS_SELECTED OR LVIS_FOCUSED
						
						Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf FUNCTIONLISTTRIGGER
						MOV lvi.lParam,EAX
						MOV EBX,EAX
						
						Invoke IsDlgButtonChecked,hWnd,132	;opening parenthesis
						MOV [EBX].FUNCTIONLISTTRIGGER.OpeningParenthesis,AL
						
						Invoke IsDlgButtonChecked,hWnd,133	;AcceptsParameters
						MOV [EBX].FUNCTIONLISTTRIGGER.AcceptsParameters,AL
						
						Invoke IsDlgButtonChecked,hWnd,134	;CanBeAParameter
						MOV [EBX].FUNCTIONLISTTRIGGER.CanBeAParameter,AL
						
						Invoke lstrcpy,ADDR [EBX].FUNCTIONLISTTRIGGER.szKeyWord,ADDR Buffer
						
						LEA EDX,Buffer
						MOV lvi.pszText,EDX
						Invoke SendDlgItemMessage,hWnd,131,LVM_GETITEMCOUNT,0,0
						MOV lvi.iItem,EAX	;at the end
						Invoke SendDlgItemMessage,hWnd,131,LVM_INSERTITEM,0,ADDR lvi
					.ElseIf EAX!=-1	&& ( EBX==-1 || EBX==EAX)	;modify existing item
						MOV lvi.imask,LVIF_PARAM
						MOV lvi.iSubItem,0
						MOV lvi.iItem,EAX
						;Trigger list
						Invoke SendDlgItemMessage,hWnd,131,LVM_GETITEM,0,ADDR lvi
						
						MOV EBX,lvi.lParam
						
						Invoke IsDlgButtonChecked,hWnd,132	;opening parenthesis
						MOV [EBX].FUNCTIONLISTTRIGGER.OpeningParenthesis,AL
						
						Invoke IsDlgButtonChecked,hWnd,133	;AcceptsParameters
						MOV [EBX].FUNCTIONLISTTRIGGER.AcceptsParameters,AL
						
						Invoke IsDlgButtonChecked,hWnd,134	;CanBeAParameter
						MOV [EBX].FUNCTIONLISTTRIGGER.CanBeAParameter,AL
						
						;Invoke GetDlgItemText,hWnd,136,ADDR Buffer,32
						Invoke lstrcpy,ADDR [EBX].FUNCTIONLISTTRIGGER.szKeyWord,ADDR Buffer
						
						LEA EDX,Buffer
						MOV lvi.pszText,EDX
						MOV lvi.cchTextMax,32
						MOV lvi.imask,LVIF_PARAM OR LVIF_TEXT
						Invoke SendDlgItemMessage,hWnd,131,LVM_SETITEM,0,ADDR lvi
					.Else
						;Already used
						Invoke MessageBox,WinAsmHandles.hMain,Offset szTriggerAlreadyUsed,Offset szAppName,MB_OK+MB_TASKMODAL
					.EndIf
				.EndIf
			.EndIf
		.ElseIf AX==EN_CHANGE
			.If DX==79	;Add Keyword textbox
				Invoke SendMessage,hWordToAdd,WM_GETTEXTLENGTH,0,0
				.If EAX
					Invoke EnableWindow,hAddButton,TRUE
				.Else
					Invoke EnableWindow,hAddButton,FALSE
				.EndIf
			.EndIf
		.ElseIf AX==LBN_SELCHANGE ;(==CBN_SELCHANGE)
			.If DX==120	;SchemesCombo
				Invoke GetColorsFromScheme
			.ElseIf DX==IDC_LSTCATEGORIES
				Invoke SendMessage,hGroupsList,LB_GETCURSEL,0,0
				Invoke SetKeyWordList,EAX
				Invoke EnableWindow,hToRecycled,FALSE
				Invoke EnableWindow,hDeleteButton,FALSE
				Invoke EnableWindow,hApplyButton,FALSE
			.ElseIf DX==IDC_LSTKEYWORDS
				Invoke SendMessage,hKeyWordsList,LB_GETSELCOUNT,0,0
				.If EAX	;i.e. there is selection
					Invoke EnableWindow,hToRecycled,TRUE
					Invoke EnableWindow,hDeleteButton,TRUE
				.Else
					Invoke EnableWindow,hToRecycled,FALSE
					Invoke EnableWindow,hDeleteButton,FALSE
				.EndIf
			.ElseIf DX==IDC_LSTRECYCLED
				Invoke SendMessage,hRecycledList,LB_GETSELCOUNT,0,0
				.If EAX
					Invoke EnableWindow,hFromRecycled,TRUE
				.Else
					Invoke EnableWindow,hFromRecycled,FALSE
				.EndIf
			.EndIf
		.ElseIf AX==LBN_DBLCLK
			.If DX==IDC_LSTCATEGORIES
				Invoke SendMessage,hGroupsList,LB_GETCURSEL,0,0
				PUSH EAX
				Invoke SendMessage,hGroupsList,LB_GETITEMDATA,EAX,0
				MOV EBX,EAX
				;Mask off group/font
				AND EAX,0FFFFFFh
				Invoke SelectColor,EAX
				;Now EAX holds color selected
				AND EBX,0FF000000h	;Get bold and/OR italic (as it was previously)
				OR EAX,EBX	;Combine it with new color
				POP EDX	;Item position
				Invoke SendMessage,hGroupsList,LB_SETITEMDATA,EDX,EAX
				Invoke InvalidateRect,hGroupsList,NULL,FALSE
				Invoke EnableWindow,hApplyButton,TRUE
			.ElseIf DX==118	;Colors list
				Invoke SendMessage,hColorsList,LB_GETCURSEL,0,0
				MOV EBX,EAX
				Invoke SendMessage,hColorsList,LB_GETITEMDATA,EAX,0
				
				Invoke SelectColor,EAX
				
				LEA ECX,tmpcol
				MOV [ECX+EBX*4],EAX
				
				Invoke SendMessage,hColorsList,LB_SETITEMDATA,EBX,EAX
				Invoke InvalidateRect,hColorsList,NULL,FALSE
				
			.EndIf
		.EndIf
	.ElseIf uMsg == WM_NOTIFY
		PUSH EDI
		MOV EDI, lParam
		
		;Tigger list
		Invoke GetDlgItem,hWnd,131
		
		MOV ECX, [EDI].NMHDR.hwndFrom
		.If ECX==hOptionsTabControl
			.If [EDI].NMHDR.code == TCN_SELCHANGE
				Invoke SendMessage,hOptionsTabControl,TCM_GETCURSEL,0,0
				;Invoke OptionsTabControl_SelChange,EAX
				.If EAX==0 ;General
					Invoke ShowOptionsFirstTab,SW_SHOW
					Invoke ShowOptionsSecondTab,SW_HIDE
					Invoke ShowOptionsThirdTab,SW_HIDE
					Invoke ShowOptionsFourthTab,SW_HIDE
					Invoke ShowOptionsFifthTab,SW_HIDE
					Invoke ShowOptionsSixthTab,SW_HIDE
					Invoke ShowOptionsSeventhTab,SW_HIDE
				.ElseIf EAX==1	;Files & Paths
					Invoke ShowOptionsFirstTab,SW_HIDE
					Invoke ShowOptionsSecondTab,SW_SHOW
					Invoke ShowOptionsThirdTab,SW_HIDE
					Invoke ShowOptionsFourthTab,SW_HIDE
					Invoke ShowOptionsFifthTab,SW_HIDE
					Invoke ShowOptionsSixthTab,SW_HIDE
					Invoke ShowOptionsSeventhTab,SW_HIDE
				.ElseIf EAX==2	;Editor
					Invoke ShowOptionsFirstTab,SW_HIDE
					Invoke ShowOptionsSecondTab,SW_HIDE		
					Invoke ShowOptionsThirdTab,SW_SHOW
					Invoke ShowOptionsFourthTab,SW_HIDE
					Invoke ShowOptionsFifthTab,SW_HIDE
					Invoke ShowOptionsSixthTab,SW_HIDE
					Invoke ShowOptionsSeventhTab,SW_HIDE
				.ElseIf EAX==3	;Intellisense
					Invoke ShowOptionsFirstTab,SW_HIDE
					Invoke ShowOptionsSecondTab,SW_HIDE		
					Invoke ShowOptionsThirdTab,SW_HIDE
					Invoke ShowOptionsFourthTab,SW_SHOW
					Invoke ShowOptionsFifthTab,SW_HIDE
					Invoke ShowOptionsSixthTab,SW_HIDE
					Invoke ShowOptionsSeventhTab,SW_HIDE
				.ElseIf EAX==4	;Keywords
					Invoke ShowOptionsFirstTab,SW_HIDE
					Invoke ShowOptionsSecondTab,SW_HIDE		
					Invoke ShowOptionsThirdTab,SW_HIDE
					Invoke ShowOptionsFourthTab,SW_HIDE
					Invoke ShowOptionsFifthTab,SW_SHOW
					Invoke ShowOptionsSixthTab,SW_HIDE
					Invoke ShowOptionsSeventhTab,SW_HIDE
				.ElseIf EAX==5	;Colors
					Invoke ShowOptionsFirstTab,SW_HIDE
					Invoke ShowOptionsSecondTab,SW_HIDE		
					Invoke ShowOptionsThirdTab,SW_HIDE
					Invoke ShowOptionsFourthTab,SW_HIDE
					Invoke ShowOptionsFifthTab,SW_HIDE
					Invoke ShowOptionsSixthTab,SW_SHOW
					Invoke ShowOptionsSeventhTab,SW_HIDE
				.ElseIf EAX==6	;Miscellaneous
					Invoke ShowOptionsFirstTab,SW_HIDE
					Invoke ShowOptionsSecondTab,SW_HIDE		
					Invoke ShowOptionsThirdTab,SW_HIDE
					Invoke ShowOptionsFourthTab,SW_HIDE
					Invoke ShowOptionsFifthTab,SW_HIDE
					Invoke ShowOptionsSixthTab,SW_HIDE
					Invoke ShowOptionsSeventhTab,SW_SHOW
				.EndIf
			.EndIf
		.ElseIf ECX==EAX
			.If [EDI].NMHDR.code ==LVN_ITEMCHANGED
				.If [EDI].NM_LISTVIEW.uNewState;==LVIS_FOCUSED ;i.e focus and selected
					MOV EDI,[EDI].NM_LISTVIEW.lParam
					XOR EBX,EBX
					
					MOV BL,[EDI].FUNCTIONLISTTRIGGER.OpeningParenthesis
					Invoke CheckDlgButton,hWnd,132,EBX
					
					MOV BL,[EDI].FUNCTIONLISTTRIGGER.AcceptsParameters
					Invoke CheckDlgButton,hWnd,133,EBX
					
					MOV BL,[EDI].FUNCTIONLISTTRIGGER.CanBeAParameter
					Invoke CheckDlgButton,hWnd,134,EBX
					
					Invoke SetDlgItemText,hWnd,136,ADDR [EDI].FUNCTIONLISTTRIGGER.szKeyWord
				.EndIf
			.EndIf
			;Invoke UpdateWindow,hWnd
		.EndIf
		POP EDI
		
		;MOV EAX,FALSE
		;RET
		
	.ElseIf uMsg==WM_CLOSE
		Invoke EndDialog,hWnd,0
		.If lParam
			Invoke HeapFree,hMainHeap,0,lpTrigger
			Invoke HeapAlloc,hMainHeap,HEAP_ZERO_MEMORY,SizeOf FUNCTIONLISTTRIGGER
			MOV lpTrigger,EAX
		.EndIf
		
		MOV lvi.imask,LVIF_PARAM
		MOV lvi.iSubItem,0
		MOV lvi.iItem,0
		MOV EBX,SizeOf FUNCTIONLISTTRIGGER
		@@:
		;Trigger list
		Invoke SendDlgItemMessage,hWnd,131,LVM_GETITEM,0,ADDR lvi
		.If EAX
			.If lParam
				MOV EDX,EBX
				ADD EDX,lpTrigger
				SUB EDX,SizeOf FUNCTIONLISTTRIGGER
				Invoke RtlMoveMemory,EDX,lvi.lParam,SizeOf FUNCTIONLISTTRIGGER
				ADD EBX,SizeOf FUNCTIONLISTTRIGGER
				Invoke HeapReAlloc,hMainHeap,HEAP_ZERO_MEMORY,lpTrigger,EBX
				MOV lpTrigger,EAX
			.EndIf
			Invoke HeapFree,hMainHeap,0,lvi.lParam
			INC lvi.iItem
			JMP @B
		.EndIf
		
		.If lParam
			Invoke RtlMoveMemory, ADDR col, ADDR tmpcol, SizeOf CHCOLOR
			Invoke IsDlgButtonChecked,hWnd,54
			MOV AutoIndent,EAX
			
			Invoke IsDlgButtonChecked,hWnd,114
			MOV TabIndicators,EAX
			
			Invoke IsDlgButtonChecked,hWnd,123
			MOV ShowScrollTips,EAX
			
			Invoke IsDlgButtonChecked,hWnd,125
			MOV ShowLineNumbersOnOpen,EAX
			
			Invoke IsDlgButtonChecked,hWnd,126
			MOV AutoshowLineNumbersOnError,EAX
			
			Invoke IsDlgButtonChecked,hWnd,124
			MOV GradientMenuItems,EAX
			
			Invoke IsDlgButtonChecked,hWnd,55
			MOV AutoLineNrWidth,EAX
			
			Invoke IsDlgButtonChecked,hWnd,50
			MOV TabToSpaces,EAX
			Invoke IsDlgButtonChecked,hWnd,69
			MOV AutoSave,EAX
			
			Invoke IsDlgButtonChecked,hWnd,89
			MOV ShowOutOnSuccess,EAX
			
			Invoke IsDlgButtonChecked,hWnd,91
			.If EAX
				MOV OnStartUp,0
			.Else
				Invoke IsDlgButtonChecked,hWnd,92				
				.If EAX
					MOV OnStartUp,1
				.Else
					Invoke IsDlgButtonChecked,hWnd,127
					.If EAX
						MOV OnStartUp,2
					.Else
						MOV OnStartUp,3
					.EndIf
				.EndIf
			.EndIf
			
			Invoke IsDlgButtonChecked,hWnd,85
			MOV ShowSplashOnStartUp,EAX
			
			Invoke IsDlgButtonChecked,hWnd,97
			MOV OnMinimizeToSysTray,EAX
			
			Invoke IsDlgButtonChecked,hWnd,111
			MOV AutoToolAndOptions,EAX
			
			Invoke IsDlgButtonChecked,hWnd,115
			MOV AutoClean,EAX
			
			Invoke IsDlgButtonChecked,hWnd,110
			.If EAX
				MOV OpenChildStyle,WS_MAXIMIZE
			.Else
				MOV OpenChildStyle,0
			.EndIf
			
			Invoke IsDlgButtonChecked,hWnd,98
			MOV LaunchExeOnGoAll,EAX
			
			Invoke IsDlgButtonChecked,hWnd,99
			MOV UseQuotes,EAX
			
			Invoke IsDlgButtonChecked,hWnd,144
			MOV DebugUseQuotes,EAX
			
			MOV fAutoComplete,0
			Invoke IsDlgButtonChecked,hWnd,141
			.If EAX
				OR fAutoComplete,AUTOCOMPLETEWITHSPACE
			.EndIf
			Invoke IsDlgButtonChecked,hWnd,142
			.If EAX
				OR fAutoComplete,AUTOCOMPLETEWITHTAB
			.EndIf
			Invoke IsDlgButtonChecked,hWnd,143
			.If EAX
				OR fAutoComplete,AUTOCOMPLETEWITHENTER
			.EndIf
			
			Invoke IsDlgButtonChecked,hWnd,145
			.If EAX
				MOV ObjectsFont,1
			.Else
				MOV ObjectsFont,0
			.EndIf
			
			
			;Invoke DeleteObject,hTempBrush
			;MOV hFind,0
			Invoke LoadCursor,0,IDC_WAIT
			Invoke SetCursor,EAX
			Invoke SaveOptions
			Invoke LoadCursor,0,IDC_ARROW
			Invoke SetCursor,EAX
		.EndIf
		
		
		Invoke DeleteObject,hImages
;		Invoke EndDialog,hWnd,0
	.ElseIf uMsg==WM_ACTIVATEAPP	;Thanks Qvasimodo(List is not refreshed otherwise-->VERY Strange
		Invoke UpdateWindow,hWnd
	.Else
		MOV EAX,FALSE
		RET
	.EndIf
	MOV EAX,TRUE
	RET
	
OptionsDlgProc EndP