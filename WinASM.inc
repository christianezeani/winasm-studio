Include user32.inc
Include kernel32.inc
Include shell32.inc
Include gdi32.inc
Include comctl32.inc
Include comdlg32.inc
Include ole32.inc
Include version.inc
Include shlwapi.inc

;-------------------------------------------------------------------
;Needed For Debug Window Only
IFDEF DEBUG_BUILD
	Include masm32.inc
	Include debug.inc
ENDIF
;-------------------------------------------------------------------
IncludeLib USER32.LIB
IncludeLib KERNEL32.LIB
IncludeLib SHELL32.LIB
IncludeLib GDI32.LIB
IncludeLib COMCTL32.LIB
IncludeLib COMDLG32.LIB
IncludeLib OLE32.LIB
IncludeLib VERSION.LIB
IncludeLib shlwapi.lib
;-------------------------------------------------------------------
;Needed For Debug Window Only
IFDEF DEBUG_BUILD
	IncludeLib masm32.lib
	IncludeLib debug.lib
ENDIF
;-------------------------------------------------------------------

;Include htmlhelp.inc
IncludeLib ADVAPI32.LIB	; required by htmlhelp
;IncludeLib htmlhelp.lib

Include \WinAsm\Inc\WAAddIn.inc


IDR_ACCELERATOR		EQU 100
IDMS_FILE		EQU 100
IDMS_NEWPROJECT		EQU 101
IDMS_OPENPROJECT		EQU 102
IDMS_CLOSEPROJECT		EQU 103
IDMS_SAVEPROJECT		EQU 104
IDMS_SAVEPROJECTAS		EQU 105
IDMS_NEWFILE		EQU 106
IDMS_NEWASMFILE		EQU 107
IDMS_NEWINCFILE		EQU 108
IDMS_NEWRCFILE		EQU 109
IDMS_NEWOTHERFILE		EQU 110
IDMS_OPENFILES		EQU 111
IDMS_SAVEFILE		EQU 112
IDMS_SAVEFILEAS		EQU 123
IDMS_PRINT		EQU 114
IDMS_RECENTPROJECTSMANAGER		EQU 115
IDMS_EXIT		EQU 116
IDMS_EDIT		EQU 200
IDMS_UNDO		EQU 201
IDMS_REDO		EQU 202
IDMS_CUT		EQU 203
IDMS_COPY		EQU 204
IDMS_PASTE		EQU 205
IDMS_DELETE		EQU 206
IDMS_SELECTALL		EQU 207
IDMS_FIND		EQU 208
IDMS_FINDNEXT		EQU 209
IDMS_FINDPREVIOUS		EQU 210
IDMS_SMARTFIND		EQU 211
IDMS_REPLACE		EQU 212
IDMS_GOTOLINE		EQU 213
IDMS_GOTOBLOCK		EQU 214
IDMS_GOBACK								EQU 215
IDMS_TOGGLEBOOKMARK						EQU 216
IDMS_NEXTBOOKMARK						EQU 217
IDMS_PREVIOUSBOOKMARK					EQU 218
IDMS_CLEARALLBOOKMARKS					EQU 219
IDMS_HIDELINES							EQU 220

IDMS_VIEW								EQU 300
IDMS_VIEWEXPLORER						EQU 301
IDMS_VIEWOUTPUT							EQU 302
IDMS_VIEWTOOLBOX						EQU 303
IDMS_VIEWDIALOG							EQU 304

IDMS_PROJECT							EQU 400
IDMS_ADDNEWASM							EQU 401
IDMS_ADDNEWINC							EQU 402
IDMS_ADDNEWRC							EQU 403
IDMS_ADDNEWOTHER						EQU 404
IDMS_ADDFILES							EQU 405
IDMS_MODULE								EQU 406
IDMS_RENAMEFILE							EQU 407
IDMS_REMOVEFILE							EQU 408
IDMS_RUNBATCHFILE						EQU 409
IDMS_VISUALMODE							EQU 410
IDMS_USEEXTERNALEDITOR					EQU 411
IDMS_PROPERTIES							EQU 412
IDMS_BINARYFILES						EQU 413
IDMS_RENAMEPROJECT						EQU 414



IDMS_FORMAT								EQU 500
IDMS_INDENT								EQU 501
IDMS_OUTDENT							EQU 502
IDMS_COMMENT							EQU 503
IDMS_UNCOMMENT							EQU 504
IDMS_CONVERT							EQU 505
IDMS_TOUPPERCASE						EQU 506
IDMS_TOLOWERCASE						EQU 507
IDMS_TOGGLECASE							EQU 508
IDMS_RESOUCES							EQU 600
IDMS_DIALOG								EQU 601
IDMS_SHOWHIDEGRID						EQU 603
IDMS_SNAPTOGRID							EQU 604
IDMS_CONTROLSMANAGER					EQU 605
IDMS_STYLEMITEM							EQU 606
IDMS_EXSTYLEMITEM						EQU 607
IDMS_FONTMITEM							EQU 608
IDMS_SENDTOBACK							EQU 609
IDMS_BRINGTOFRONT						EQU 610
IDMS_TESTDIALOG							EQU 611
IDMS_DEFINITIONS						EQU 602

IDMS_MAKE								EQU 700
IDMS_SETACTIVEBUILD						EQU 701
IDMS_RELEASEVERSION						EQU 702
IDMS_DEBUGVERSION						EQU 703
IDMS_CLEAN								EQU 704
IDMS_COMPILERCMITEM						EQU 705
IDMS_RCTOOBJMITEM						EQU 706
IDMS_ASSEMBLEMITEM						EQU 707
IDMS_LINKMITEM							EQU 708
IDMS_GOALL								EQU 709
IDMS_EXECUTE							EQU 710
IDMS_DEBUG								EQU 711

IDMS_TOOLS								EQU 800
IDMS_CODEEDITORFONT						EQU 801
IDMS_LINENUMBERFONT						EQU 802
IDMS_OPTIONS							EQU 803
IDMS_TOOLSMANAGER						EQU 804
IDMS_INTERFACEPACKS						EQU 805
IDMS_ADDINS								EQU 900
IDMS_ADDINSMANAGER						EQU 901
IDMS_WINDOW								EQU 1000
IDMS_CLOSE								EQU 1001
IDMS_HIDEALL							EQU 1002
IDMS_NEXT								EQU 1003
IDMS_PREVIOUS							EQU 1004
IDMS_TILEHORIZONTALLY					EQU 1005
IDMS_TILEVERTICALLY						EQU 1006
IDMS_CASCADE							EQU 1007
IDMS_HELP								EQU 1100
IDMS_WINASMSTUDIOHELP					EQU 1101
IDMS_OTHERHELP							EQU 1102
IDMS_ONTHEWEB							EQU 1103
IDMS_ABOUT								EQU 1104

IDMS_RESTORE							EQU 1501
IDMS_GRADIENT							EQU 1502
IDMS_DOUBLELINE							EQU 1503
IDMS_SINGLELINE							EQU 1504
IDMS_COPYSELECTION						EQU 1505
IDMS_COPYALLTEXT						EQU 1506
IDMS_SAVEOUTTEXT						EQU 1507


IDTS_GRIDSIZE							EQU 1603
IDTS_ALIGNLEFTS							EQU 1604
IDTS_ALIGNCENTERS						EQU 1605
IDTS_ALIGNCENTERSWITHDIALOGCENTER		EQU 1606
IDTS_ALIGNRIGHTS						EQU 1607
IDTS_ALIGNTOPS							EQU 1608
IDTS_ALIGNMIDDLES						EQU 1609
IDTS_ALIGNMIDDLESWITHDIALOGMIDDLE		EQU 1610
IDTS_ALIGNBOTTOMS						EQU 1611
IDTS_MAKESAMEWIDTH						EQU 1612
IDTS_MAKESAMEHEIGHT						EQU 1613
IDTS_MAKESAMESIZE						EQU 1614
IDTS_POINTER							EQU 1615

IDTS_ADDNEWDIALOG						EQU 1641
IDTS_NEWMENU							EQU 1642
IDTS_INCFILES							EQU 1643
IDTS_ADDACCELERATORTABLE				EQU 1644
IDTS_ADDVERSIONINFO						EQU 1645
IDTS_STRINGTABLE						EQU 1646
IDTS_RESOURCES							EQU 1647
IDTS_REMOVE								EQU 1648

IDTCS_BLOCKS							EQU 1651
IDTCS_PROJECT							EQU 1652
IDTCS_DIALOGS							EQU 1653
IDTCS_OTHERS							EQU 1654
IDTVS_MENUS								EQU 1661
IDTVS_ACCELERATORTABLES					EQU 1662
IDTVS_VERSIONINFO						EQU 1663
IDTVS_ASMFILES							EQU 1664
IDTVS_MODULES							EQU 1665
IDTVS_INCLUDEFILES						EQU 1666
IDTVS_RESOURCEFILES						EQU 1667
IDTVS_TEXTFILES							EQU 1668
IDTVS_BATCHFILES						EQU 1669
IDTVS_DEFINITIONFILES					EQU 1670
IDTVS_OTHERFILES						EQU 1671

IDLBS_EDITORBACKCOLOR					EQU 1672
IDLBS_NORMALTEXTCOLOR					EQU 1673
IDLBS_SELECTIONBACKCOLOR				EQU 1674
IDLBS_SELECTEDTEXTCOLOR					EQU 1675
IDLBS_COMMENTCOLOR						EQU 1676
IDLBS_STRINGCOLOR						EQU 1677
IDLBS_OPERATORCOLOR						EQU 1678
IDLBS_ERROREDLINEBACKCOLOR				EQU 1679
IDLBS_NOERRORSLINEBACKCOLOR				EQU 1680
IDLBS_TABINDICATORSCOLOR				EQU 1681
IDLBS_SELECTIONBARCOLOR					EQU 1682
IDLBS_DIVIDERLINECOLOR					EQU 1683
IDLBS_LINENUMBERSCOLOR					EQU 1684
IDLBS_NUMBERCOLOR						EQU 1685
IDLBS_TOOLTIPSBACKCOLOR					EQU 1686
IDLBS_PROJECTTREEBACKCOLOR				EQU 1687
IDLBS_PROJECTTREETEXTCOLOR				EQU 1688
IDLBS_PROJECTTREELINECOLOR				EQU 1689
IDLBS_RCEDITORBACKCOLOR					EQU 1690


IDCBS_DEFAULT							EQU 1691
IDCBS_UPPERCASE							EQU 1692
IDCBS_LOWERCASE							EQU 1693

IDLBS_TOOLTIPSACTIVEPARAMCOLOR			EQU 1694

IDPS_NAME								EQU 1701
IDPS_ID									EQU 1702
IDPS_LEFT								EQU 1703
IDPS_TOP								EQU 1704
IDPS_WIDTH								EQU 1705
IDPS_HEIGHT								EQU 1706
IDPS_STYLE								EQU 1707
IDPS_EXSTYLE							EQU 1708
IDPS_VISIBLEPROPERTY					EQU 1709
IDPS_CAPTION							EQU 1710
IDPS_TEXT								EQU 1711
IDPS_IMAGE								EQU 1712
IDPS_MENU								EQU 1713
IDPS_CLASS								EQU 1714
IDPS_FONT								EQU 1715

IDTCS_PROJECTTYPE						EQU 1721
IDTCS_RESOURCEMAKEOPTIONS				EQU 1722
IDTCS_RELEASEMAKEOPTIONS				EQU 1723
IDTCS_DEBUGMAKEOPTIONS					EQU 1724

IDTCS_GENERAL							EQU 1731
IDTCS_FILESANDPATHS						EQU 1732
IDTCS_EDITOR							EQU 1733
IDTCS_INTELLISENSE						EQU 1734
IDTCS_KEYWORDS							EQU 1735
IDTCS_COLORS							EQU 1736
IDTCS_MISCELLANEOUS						EQU 1737

IDPTS_STANDARDEXE						EQU 1751
IDPTS_STANDARDDLL						EQU 1752
IDPTS_CONSOLEAPPLICATION				EQU 1753
IDPTS_STATICLIBRARY						EQU 1754
IDPTS_OTHEREXE							EQU 1755
IDPTS_OTHERNOTEXE						EQU 1756
IDPTS_DOSPROJECT						EQU 1757


IDGS_YES								EQU 1801
IDGS_NO									EQU 1802
IDGS_TRUE								EQU 1803
IDGS_FALSE								EQU 1804


IDTT_NEWPROJECT							EQU 2001
IDTT_OPENPROJECT						EQU 2002
IDTT_OPENFILES							EQU 2003
IDTT_ADDFILES							EQU 2004
IDTT_SAVEFILE							EQU 2005
IDTT_SAVEPROJECT						EQU 2006
IDTT_CUT								EQU 2007
IDTT_COPY								EQU 2008
IDTT_PASTE								EQU 2009
IDTT_UNDO								EQU 2010
IDTT_REDO								EQU 2011
IDTT_SHOWHIDEEXPLORER					EQU 2012
IDTT_VISUALMODE							EQU 2013
IDTT_FIND								EQU 2014
IDTT_REPLACE							EQU 2015
IDTT_INCREASEINDENT						EQU 2016
IDTT_DECREASEINDENT						EQU 2017
IDTT_COMMENTBLOCK						EQU 2018
IDTT_UNCOMMENTBLOCK						EQU 2019
IDTT_TOGGLEBOOKMARK						EQU 2020
IDTT_NEXTBOOKMARK						EQU 2021
IDTT_PREVIOUSBOOKMARK					EQU 2022
IDTT_CLEARALLBOOKMARKS					EQU 2023
IDTT_ASSEMBLE							EQU 2024
IDTT_LINK								EQU 2025
IDTT_GOALL								EQU 2026
IDTT_EXECUTE							EQU 2027
IDTT_STOP								EQU 2028

IDDW_EXPLORER							EQU 2100
IDDW_OUTPUT								EQU 2101
IDDW_DIALOG								EQU 2102
IDDW_TOOLBOX							EQU 2103

IDAD_KEY								EQU 2151
IDSD_STRING								EQU 2152
IDRP_PROJECTS							EQU 2153
IDAS_FILE								EQU 2154
IDAM_AVAILABLEADDINS					EQU 2155
IDAM_LOADSTATUS							EQU 2156
IDAM_LOADONSTARTUP						EQU 2157

IDDT_OPENPROJECT						EQU 2201
IDDT_SAVEPROJECTAS						EQU 2202
IDDT_OPENFILES							EQU 2203
IDDT_ADDFILES							EQU 2204
IDDT_SAVEFILEAS							EQU 2205
IDDT_RENAMEFILE							EQU 2206
IDDT_PRINT								EQU 2207
IDDT_NEWPROJECT							EQU 2208
IDDT_BROWSE								EQU 2209
IDDT_BROWSEFORPATH						EQU 2210
IDDT_WINDOWSTYLES						EQU 2211
IDDT_WINDOWEXSTYLES						EQU 2212
IDDT_RENAMEPROJECT						EQU 2213

IDGS_SELECTPROCEDUREORGOTOTOP		EQU 2251

IDSBS_SAVING						EQU 3001
IDSBS_COMPILINGRESOURCES			EQU 3002
IDSBS_CONVERTINGRESTOOBJ			EQU 3003
IDSBS_ASSEMBLINGPROJECT				EQU 3004
IDSBS_LINKING						EQU 3005
IDSBS_LNCOLSEL						EQU 3006
IDSBS_SEARCHING						EQU 3007
IDSBS_REPLACING						EQU 3008
IDSBS_LOADINGRESOURCES				EQU 3009
IDSBS_LOADINGPROJECT				EQU 3010
IDSBS_CREATINGPROJECT				EQU 3011




IDMSG_LINE							EQU 4501
IDMSG_ISADIRECTORY					EQU 4502
IDMSG_ISALREADYDEFINEDAS			EQU 4503
IDMSG_DOYOUWANTTOCHANGEIT			EQU 4504
IDMSG_THELEVELOFMENUITEM 			EQU 4505
IDMSG_ISNOTCORRECT 					EQU 4506
IDMSG_EXECUTIONERROR				EQU 4507
IDMSG_ERRORLOADINGFILE				EQU 4508



IDMSG_SURETOREMOVEFILEFROMPROJECT	EQU 5001
IDMSG_SURETOREMOVEMENU				EQU 5002
IDMSG_CONTROLUSED					EQU 5003
IDMSG_SURETODELETECONTROL			EQU 5004
IDMSG_FILEMODIFIED					EQU 5005
IDMSG_ASKTOSAVEFILECHANGES			EQU 5006
IDMSG_SURETOREMOVEACCELERATORTABLE	EQU 5007
IDMSG_SURETOREMOVEVERSIONINFO		EQU 5008
IDMSG_SURETOREMOVESTRINGTABLE		EQU 5009
IDMSG_FRIENDLYNAMEREQUIRED			EQU 5010
IDMSG_CLASSNAMEREQUIRED				EQU 5011
IDMSG_CLASSALREADYUSED				EQU 5012
IDMSG_NOTWAPROJECTFILE				EQU 5013
IDMSG_PROJECTWASNOTSAVED			EQU 5014
IDMSG_SURETODELETETHISDIALOG		EQU 5015
IDSBS_SEARCHFINISHED				EQU 5016
IDMSG_CREATEPIPEERROR				EQU 5017
IDMSG_CREATEPROCESSERROR			EQU 5018
;IDMSG_NOASMERROR					EQU 5019
IDMSG_MAKEFINSHED					EQU 5020
IDMSG_MAKEERROR						EQU 5021
IDMSG_CANNOTSAVEFILE				EQU 5022
IDMSG_TRIGGERALREADYUSED			EQU 5023



IDMSG_LINENOTCOMPATIBLE				EQU 10001
IDMSG_CODEHINOTFOUND				EQU 10002

IDFS_OPENPROJECT					EQU 12001
IDFS_CHOOSEDLL						EQU 12002
IDFS_CHOOSEEXECUTABLE				EQU 12003
IDFS_CHOOSEKEYFILE					EQU 12004
IDFS_CHOOSEAPIFILE					EQU 12005
IDFS_CHOOSEHELPFILE					EQU 12006
IDFS_CHOOSEALLFILES					EQU 12007
IDFS_CHOOSEBINARYFILE				EQU 12008

IDFS_ADDOPENSAVEFILES				EQU 15001
IDFS_CHOOSERESOURCE					EQU 15002




AUTOCOMPLETEWITHSPACE			EQU 1
AUTOCOMPLETEWITHTAB				EQU 2
AUTOCOMPLETEWITHENTER			EQU 4



IDM_TOOLBOX_DIALOG				EQU 11101
IDM_TOOLBOX_POINTER				EQU 11102
IDM_TOOLBOX_STATIC				EQU 11103	
IDM_TOOLBOX_EDIT				EQU 11104	
IDM_TOOLBOX_GROUPBOX			EQU 11105	
IDM_TOOLBOX_BUTTON				EQU 11106	
IDM_TOOLBOX_CHECKBOX			EQU 11107	
IDM_TOOLBOX_RADIOBUTTON			EQU 11108	
IDM_TOOLBOX_COMBOBOX			EQU 11109	
IDM_TOOLBOX_LISTBOX				EQU 11110	
IDM_TOOLBOX_HSCROLL				EQU 11111	
IDM_TOOLBOX_VSCROLL				EQU 11112	
IDM_TOOLBOX_TABCONTROL			EQU 11113	
IDM_TOOLBOX_TOOLBAR				EQU 11114	
IDM_TOOLBOX_STATUSBAR			EQU 11115	
IDM_TOOLBOX_PROGRESSBAR			EQU 11116
;IDM_TOOLBOX_HEADER				EQU 11117
IDM_TOOLBOX_REBAR				EQU 11117
IDM_TOOLBOX_UPDOWN				EQU 11118
IDM_TOOLBOX_TREEVIEW			EQU 11119
IDM_TOOLBOX_LISTVIEW			EQU 11120	
IDM_TOOLBOX_SLIDER				EQU 11121
IDM_TOOLBOX_SHAPE				EQU 11122
IDM_TOOLBOX_IMAGE				EQU 11123
IDM_TOOLBOX_RICHEDIT			EQU 11124
IDM_TOOLBOX_USERDEFINEDCONTROL	EQU 11125	

;IDM_RCPROPERTIES_VISUAL		EQU 11201
;IDM_RCPROPERTIES_VIEWCODE		EQU 11202
IDM_RCPROPERTIES_MENUS			EQU 11203
IDM_RCPROPERTIES_INCLUDES		EQU 11204
;IDM_RCPROPERTIES_DEFINES		EQU 11205
IDM_RCPROPERTIES_ACCELERATORS	EQU 11206
IDM_RCPROPERTIES_VERSIONINFO	EQU 11207
IDM_RCPROPERTIES_STRINGTABLE	EQU 11208
IDM_RCPROPERTIES_RESOURCES		EQU 11209
IDM_RCPROPERTIES_REMOVE			EQU 11210

;IDM_DIALOG_SHOWHIDEGRID		EQU 11301
;IDM_DIALOG_SNAPTOGRID		EQU 11302
;
IDM_DIALOG_GRIDSIZE			EQU 11303
;IDM_DIALOG_GRIDSIZE_1		EQU 11401	;Too small
IDM_DIALOG_GRIDSIZE_2		EQU 11402
IDM_DIALOG_GRIDSIZE_3		EQU 11403
IDM_DIALOG_GRIDSIZE_4		EQU 11404
IDM_DIALOG_GRIDSIZE_5		EQU 11405
IDM_DIALOG_GRIDSIZE_6		EQU 11406
IDM_DIALOG_GRIDSIZE_7		EQU 11407
IDM_DIALOG_GRIDSIZE_8		EQU 11408
IDM_DIALOG_GRIDSIZE_9		EQU 11409
IDM_DIALOG_GRIDSIZE_10		EQU 11410


IDM_DIALOG_ALIGNLEFTS			EQU 11308
IDM_DIALOG_ALIGNCENTERS			EQU 11309
IDM_DIALOG_ALIGNWITHDIALOGCENTER	EQU 11310
IDM_DIALOG_ALIGNRIGHTS			EQU 11311

IDM_DIALOG_ALIGNTOPS				EQU 11312
IDM_DIALOG_ALIGNMIDDLES			EQU 11313
IDM_DIALOG_ALIGNWITHDIALOGMIDDLE	EQU 11314
IDM_DIALOG_ALIGNBOTTOMS			EQU 11315

IDM_DIALOG_MAKESAMEWIDTH			EQU 11316
IDM_DIALOG_MAKESAMEHEIGHT		EQU 11317
IDM_DIALOG_MAKESAMESIZE			EQU 11318

IDM_VIEW_TOOLBOX			EQU 10203
IDM_VIEW_DIALOG				EQU 10205

SELBARWIDTH					EQU 12

WM_SHELLNOTIFY				EQU WM_USER+5
IDI_TRAY					EQU 0
;--------------------------------------------------------------------------------
IDB_TOOLBARBITMAP			EQU 103
IDB_MASKBITMAP				EQU 104
IDB_DISABLEDBITMAP			EQU 110

IDR_ACCELERATOR				EQU 100
IDB_PROJECTTREELIST			EQU 4006
IDB_NEWPROJECTLIST			EQU 4007
IDB_LISTPROCEDURESLIST      EQU 4008
IDD_SPLASHABOUT				EQU 200
	IDC_OK						EQU 1

IDD_GOTOLINE				EQU 203
	;IDC_OK						EQU 1
	IDC_TEXTLINENR				EQU 1005
	IDC_GO						EQU 1006

IDD_PROJECTPROPERTIES		EQU 206
	IDC_NEWPROJECTLIST			EQU 3
	IDC_TABCONTROL				EQU 4
	IDC_TEXTRC					EQU 11
	IDC_TEXTCVTRES				EQU 12
	IDC_TEXTML					EQU 13
	IDC_TEXTLINK				EQU 14
	IDC_TEXTOUT					EQU 20
	IDC_LABELRC					EQU 15
	IDC_LABELCVTRES				EQU 16
	IDC_LABELML					EQU 17
	IDC_LABELLINK				EQU 18
	IDC_LABELOUT				EQU 19
	IDC_GROUPLINK				EQU 21	

IDD_OPTIONS					EQU 207
	IDC_LSTCATEGORIES		EQU 72
	IDC_LSTKEYWORDS			EQU 74
	IDC_LSTRECYCLED			EQU 76
	IDC_CHKBOLD				EQU 82
	IDC_CHKITALIC			EQU 83
	IDC_BUTTONAPPLY			EQU 84
	
IDD_FINDDLG					EQU 208
	IDC_FINDTEXT				EQU 2001
	IDC_BTN_REPLACE				EQU 2007
	IDC_REPLACETEXT				EQU 2002
	IDC_REPLACESTATIC			EQU 2009
	IDC_BTN_REPLACEALL			EQU 2008

	IDC_CHK_WHOLEWORD			EQU 2004
	IDC_CHK_MATCHCASE			EQU 2003
	IDC_CHK_CURRENTPROJECT		EQU 2011
	
	IDC_RBN_DOWN				EQU 2005
	IDC_RBN_UP					EQU 2006
	IDC_RBN_UPDOWN				EQU 2010


IDD_ADDINSMANAGER			EQU	4200
IDC_LSTALLADDINS			EQU 4201

IDD_TOOLTIPDLG				EQU	209

;IDB_PROCBUTTON				EQU 107

IDI_MAINICON				EQU 1001
IDI_EDITICON				EQU 1002
IDI_INCICON					EQU 1003
IDI_RCICON					EQU 1004
IDI_DEFICON					EQU 1005
IDI_TXTICON					EQU 1006
IDI_OTHERICON				EQU 1007
IDI_BATICON					EQU 1008


CHILDWINDOWPLACEMENT STRUCT
	rcPosAndSize	RECT			<?>
	Joker			DWORD			?	;0-based
	dwState			DWORD			?	;maximized, minimized, normal
	dwLine			DWORD			?
CHILDWINDOWPLACEMENT ENDS

POSANDSIZE STRUCT
	dLeft	DD ?
	dTop	DD ?
	dWidth	DD ?
	dHeight	DD ?
POSANDSIZE ENDS

DOCKDATA STRUCT
	lpCaption			DWORD ?
	fDockedTo			DWORD ?			;1=left,2=right,3=top,4=bottom,5=NoDock
	NoDock				POSANDSIZE <?>
	DockTopHeight		DWORD ?
	DockBottomHeight	DWORD ?	
	DockLeftWidth		DWORD ?
	DockRightWidth		DWORD ?


	fState				DWORD ?			;1=Close Button Pressed
										;2=User Sizing
										;3=User Docking/Undocking
	fDockTo				DWORD ?			;1=left,2=right,3=top,4=bottom,5=NoDock
	FocusRect			RECT <?>
	MousePos			POINT <?>

DOCKDATA ENDS

;Structure for storing data unique to each child window
CHILDWINDOWDATA STRUCT
	hEditor			DWORD ?
	hCombo			DWORD ?
	hTreeItem		DWORD ?
	dwTypeOfFile	DWORD ?
	szFileName		DB MAX_PATH DUP(?)
	nLastLine		DWORD ?
	dwFileNumber	DWORD ?
	fNotOnDisk		DWORD ?	;This is 1 for new files not saved on any media
	FileTime		FILETIME <?>
	fTimer			DWORD ?
	bSelection		DWORD ?	;In NewEditorProc it is set if there is selection
							;In ChildWndProc if it is set, fTimer is set so that
							;in TimerUpdateProcedures the Procedure List is updated
CHILDWINDOWDATA ENDS

;CodeHi Structures
CHFONT STRUCT
	hFont		DD ?		;CodeHi Normal Font
	hIFont		DD ?		;CodeHi Italic Font
	hLnrFont	DD ?		;Line numbers
CHFONT ENDS

BD_NONESTING			EQU 1				;Set to true for non nested blocks
BD_DIVIDERLINE			EQU 2				;Draws a divider line
BD_INCLUDELAST			EQU 4				;lpszEnd line is also collapsed
BD_LOOKAHEAD			EQU 8				;Look 500 lines ahead for the ending

CHBLOCKDEF STRUCT
	lpszStart	DD ?						;Block start
	lpszEnd		DD ?						;Block end
	lpszNot1	DD ?						;Dont hide line containing this or set to NULL
	lpszNot2	DD ?						;Dont hide line containing this or set to NULL
	flag		DD ?						;
CHBLOCKDEF ENDS

CHCOLOR STRUCT
	bckcol		DD ?		;Back color
	txtcol		DD ?		;Text color
	selbckcol	DD ?		;Sel back color
	seltxtcol	DD ?		;Sel text color
	cmntcol		DD ?		;Comment color
	strcol		DD ?		;String color
	oprcol		DD ?		;Operator color
	hicol1		DD ?		;Line hilite 1
	hicol2		DD ?		;Line hilite 2
	hicol3		DD ?		;Line hilite 3	;Tab Indicators
	selbarbck	DD ?		;Selection bar
	selbarpen	DD ?		;Selection bar pen
	lnrcol		DD ?		;Line numbers color
	numcol		dd ?		;Numbers & hex color


	tltbckcol	DD ?		;Tooltip back color
	TltActParamCol	DD ?	;Tooltip active parameter color
	
	TreeBackCol	DD ?
	TreeTextCol	DD ?
	TreeLineCol	DD ?
	
	RCBackCol	DD ?		;Resource Editor BackColor
CHCOLOR ENDS

SCHEME STRUCT
	SchemeName	DB 64 DUP(?) 
	Color		CHCOLOR <?>
SCHEME ENDS

LINE struct
	rpChars		dd ?		;Relative pointer to CHARS
LINE ends

CHARS struct
	len			dd ?		;String len
	max			dd ?		;Max size
	state		dd ?		;Line state
	bmid		dd ?		;Bookmark ID
CHARS ends

RABRUSH struct
	hBrBck		dd ?		;Back color brush
	hBrSelBck	dd ?		;Sel back color brush
	hBrHilite1	dd ?		;Line hilite 1
	hBrHilite2	dd ?		;Line hilite 2
	hBrHilite3	dd ?		;Line hilite 3
	hBrSelBar	dd ?		;Selection bar
	hPenSelbar	dd ?		;Selection bar pen
RABRUSH ends

RAEDT struct
	hwnd		dd ?		;Handle of edit a or b
	hvscroll	dd ?		;Handle of scroll bar
	cpxmax		dd ?		;Last cursor pos x
	cpy			dd ?		;Scroll position
	cp			dd ?		;Character position
	rc			RECT <?>	;Edit a or b rect
	topyp		dd ?		;First visible lines Y position
	topln		dd ?		;First visible lines linenumber
	topcp		dd ?		;First visible lines character position
RAEDT ends

RAFONTINFO struct
	charset		dd ?		;Character set
	fDBCS		dd ?		;Use double byte characters
	fntwt		dd ?		;Font width
	fntht		dd ?		;Font height
	spcwt		dd ?		;Space width
	tabwt		dd ?		;Tab width
	italic		dd ?		;Height shift
	monospace	dd ?		;Font is monospaced
	linespace	dd ?		;Extra line spacing
RAFONTINFO ends

RACOLOR struct
	bckcol		dd ?						;Back color
	txtcol		dd ?						;Text color
	selbckcol	dd ?						;Sel back color
	seltxtcol	dd ?						;Sel text color
	cmntcol		dd ?						;Comment color
	strcol		dd ?						;String color
	oprcol		dd ?						;Operator color
	hicol1		dd ?						;Line hilite 1
	hicol2		dd ?						;Line hilite 2
	hicol3		dd ?						;Line hilite 3
	selbarbck	dd ?						;Selection bar
	selbarpen	dd ?						;Selection bar pen
	lnrcol		dd ?						;Line numbers color
	numcol		dd ?						;Numbers & hex color
RACOLOR ends

EDIT struct
	hwnd		dd ?		;Handle of main window
	fstyle		dd ?		;Window style
	ID			dd ?		;Window ID
	hpar		dd ?		;Handle of parent window
	edta		RAEDT <>
	edtb		RAEDT <>
	hhscroll	dd ?		;Handle of horizontal scrollbar
	hgrip		dd ?		;Handle of sizegrip
	hnogrip		dd ?		;Handle of nosizegrip
	hsbtn		dd ?		;Handle of splitt button
	hlin		dd ?		;Handle of linenumber button
	hexp		dd ?		;Handle of expand button
	hcol		dd ?		;Handle of collapse button
	hsta		dd ?		;Handle of state window
	htt			dd ?		;Handle of tooltip
	fresize		dd ?		;Resize in action flag
	fsplitt		dd ?		;Splitt factor
	nsplitt		dd ?		;Splitt height

	hHeap		dd 3 dup(?)	;Handle of heap
	hLine		dd ?		;Handle of line pointer mem
	cbLine		dd ?		;Size of line pointer mem
	rpLine		dd ?		;Relative pointer into line pointer mem
	rpLineFree	dd ?		;Pointer to free line pointer
	hChars		dd ?		;Handle of character mem
	cbChars		dd ?		;Size of character mem
	rpChars		dd ?		;Relative pointer into character mem
	rpCharsFree	dd ?		;Relative pointer to free character
	hUndo		dd ?		;Handle of undo memory
	cbUndo		dd ?		;Size of undo memory
	rpUndo		dd ?		;Relative pointer to free (last)
	line		dd ?		;Linenumber
	cpLine		dd ?		;Character position for start of line

	rc			RECT <?>	;Main rect
	selbarwt	dd ?		;Width of selection bar
	nlinenrwt	dd ?		;Initial width of linenumber bar
	linenrwt	dd ?		;Width of linenumber bar
	nScroll		dd ?		;Mouse wheel scroll lines
	nPageBreak	dd ?		;Page break
	cpMin		dd ?		;Selection min
	cpMax		dd ?		;Selection max
	fOvr		dd ?		;Insert / Overwrite
	nHidden		dd ?		;Number of hidden lines
	cpx			dd ?		;Scroll position
	focus		dd ?		;Handle of edit having focus
	fCaretHide	dd ?		;Caret is hidden
	fChanged	dd ?		;Content changed
	fHideSel	dd ?		;Hide selection
	fIndent		dd ?		;Auto indent
	clr			RACOLOR <?>
	br			RABRUSH <?>
	nTab		dd ?		;Tab size
	fnt			RAFONT <?>
	fntinfo		RAFONTINFO <?>
	lpBmCB		dd ?		;Bookmark paint callback
	nchange		dd ?		;Used by EN_SELCHANGE
	nlastchange	dd ?		;Used by EN_SELCHANGE
	nWordGroup	dd ?		;Hilite word group
	fExpandTab	dd ?		;TRUE/FALSE Epand tabs to spaces
	savesel		CHARRANGE <?>
EDIT ends

;CodeHi styles
STYLE_NOSPLITT			EQU 001h	;No splitt button
STYLE_NOLINENUMBER		EQU 002h	;No linenumber button
STYLE_NOCOLLAPSE		EQU 004h	;No expand/collapse buttons
STYLE_NOHSCROLL			EQU 008h	;No horizontal scrollbar
STYLE_NOVSCROLL			EQU 010h	;No vertical scrollbar
STYLE_NOHILITE			EQU 020h	;No color hiliting
STYLE_NOSIZEGRIP		EQU 040h	;No size grip
STYLE_NODBLCLICK		EQU 080h	;No action on double clicks
STYLE_READONLY			EQU 100h	;Text is locked
STYLE_NODIVIDERLINE		EQU 200h	;Blocks are not divided by line
STYLE_NOBACKBUFFER		EQU 400h	;Drawing directly to screen DC
STYLE_NOSTATE			EQU 800h	;No state indicator
STYLE_DRAGDROP			equ 1000h	;Drag & Drop support, app must load ole
STYLE_SCROLLTIP			equ 2000h	;Scrollbar tooltip
STYLE_HILITECOMMENT		equ 4000h	;Comments are hilited
STYLE_NOTABINDICATORS	equ 8000h
;-------------------------------------------------------------------
;;Window styles
;STYLE_NOSPLITT			equ 0001h			;No splitt button
;STYLE_NOLINENUMBER		equ 0002h			;No linenumber button
;STYLE_NOCOLLAPSE		equ 0004h			;No expand/collapse buttons
;STYLE_NOHSCROLL			equ 0008h			;No horizontal scrollbar
;STYLE_NOVSCROLL			equ 0010h			;No vertical scrollbar
;STYLE_NOHILITE			equ 0020h			;No color hiliting
;STYLE_NOSIZEGRIP		equ 0040h			;No size grip
;STYLE_NODBLCLICK		equ 0080h			;No action on double clicks
;STYLE_READONLY			equ 0100h			;Text is locked
;STYLE_NODIVIDERLINE		equ 0200h			;Blocks are not divided by line
;STYLE_NOBACKBUFFER		equ 0400h			;Drawing directly to screen DC
;STYLE_NOSTATE			equ 0800h			;No state indicator
;STYLE_DRAGDROP			equ 1000h			;Drag & Drop support, app must load ole
;STYLE_SCROLLTIP			equ 2000h			;Scrollbar tooltip
;STYLE_HILITECOMMENT		equ 4000h			;Comments are hilited



APICONSTANTS STRUCT
	pNext	DWORD ?
	pText	DWORD ?
APICONSTANTS ENDS

comment @
1) Control's friendly name and description.

2) Class name of the control.

3) DLL file where the control resides.

4) Function name to call to initialize the control (may be none, if it's done automatically at the DLL entry point).

5) Function name to call to unregister the control (may be none, if it's done automatically at the DLL entry point).

6) Optional list of styles supported, and their values. Could be an ASCIIZ array stored with WritePrivateProfileStruct.
@

CUSTOMCONTROL STRUCT
	szFriendlyName		DB	24+1		DUP (?)
	szClassName			DB	24+1		DUP (?)
	;szDescription		DB	256+1		DUP (?)
	szDLLFullPathName	DB	MAX_PATH+1	DUP (?)
	szStyles			DB	16*(24+1)	DUP (?)
CUSTOMCONTROL ENDS

CUSTOMCONTROLEX STRUCT
	CustomControl		CUSTOMCONTROL	<>
	hLib				DWORD			?
	ReferenceCount		DWORD			?
CUSTOMCONTROLEX ENDS

FUNCTIONLISTTRIGGER STRUCT
	szKeyWord			DB 32+1	DUP (?)
	OpeningParenthesis	BOOLEAN ?
	CanBeAParameter		BOOLEAN	?
	AcceptsParameters	BOOLEAN ?
	Active				BOOLEAN ?
FUNCTIONLISTTRIGGER ENDS

.CODE

DummyListViewProc Proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	.If uMsg==WM_VSCROLL || uMsg==WM_HSCROLL || uMsg==WM_MOUSEWHEEL
		;Normal Processing
		Invoke GetWindowLong,hWnd,GWL_USERDATA
		Invoke CallWindowProc,EAX,hWnd,uMsg,wParam,lParam
		;Hide Editbox
		Invoke SetFocus,hWnd
		Invoke SendMessage,hWnd,WM_SETREDRAW,FALSE,0
		Invoke InvalidateRect,hWnd,NULL,TRUE
		Invoke SendMessage,hWnd,WM_SETREDRAW,TRUE,0
		Invoke UpdateWindow,hWnd
		RET
	.ElseIf uMsg==WM_NOTIFY
		MOV EDX,lParam
		.If [EDX].NMHDR.code==0FFFFFEBAh	;<--------Begin Drag????
			Invoke SetFocus,hWnd;<-----Set focus to the list so that if edit box is visible it is hidden
		.EndIf
	.EndIf
	;Normal Processing
	Invoke GetWindowLong,hWnd,GWL_USERDATA
	Invoke CallWindowProc,EAX,hWnd,uMsg,wParam,lParam
	RET
DummyListViewProc EndP

.CONST
;arbitrary command id's
tbResource	TBBUTTON <0, 100, TBSTATE_ENABLED,TBSTYLE_BUTTON, 0, 0>
			TBBUTTON <1, 200, TBSTATE_ENABLED,TBSTYLE_BUTTON , 0, 0>
			TBBUTTON <2, 300, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
			TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>
			TBBUTTON <7, 400, TBSTATE_ENABLED, TBSTYLE_BUTTON , 0, 0>
			
tbMain	TBBUTTON <0, IDM_NEWPROJECT, TBSTATE_ENABLED,TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <1, IDM_OPENPROJECT, TBSTATE_ENABLED,TBSTYLE_DROPDOWN , 0, 0>
		TBBUTTON <55, IDM_PROJECT_ADDEXISTINGFILE,0,TBSTYLE_BUTTON, 0, 0>
		
		TBBUTTON <2, IDM_SAVEFILE, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <3, IDM_SAVEPROJECT, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		
		TBBUTTON <4, IDM_EDIT_CUT, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <5, IDM_EDIT_COPY, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <6, IDM_EDIT_PASTE, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		;TBSTYLE_DROPDOWN=8h
		TBBUTTON <7, IDM_EDIT_UNDO, 0, TBSTYLE_BUTTON , 0, 0>
		TBBUTTON <8, IDM_EDIT_REDO, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		TBBUTTON <9, IDM_VIEW_PROJECTEXPLORER,TBSTATE_ENABLED,TBSTYLE_CHECK , 0, 0>
		
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		TBBUTTON <51, IDM_RESOURCES_VISUALMODE,TBSTYLE_BUTTON , 0, 0>
		
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		TBBUTTON <10, IDM_EDIT_FIND,TBSTYLE_BUTTON , 0, 0>
		TBBUTTON <11, IDM_EDIT_REPLACE,TBSTYLE_BUTTON , 0, 0>

tbEdit	TBBUTTON <12, IDM_FORMAT_INDENT, 0,TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <13, IDM_FORMAT_OUTDENT, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		TBBUTTON <14, IDM_FORMAT_COMMENT, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <15, IDM_FORMAT_UNCOMMENT, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		TBBUTTON <16, IDM_EDIT_TOGGLEBM, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <17, IDM_EDIT_NEXTBM, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <18, IDM_EDIT_PREVBM, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <19, IDM_EDIT_CLEARBM, 0, TBSTYLE_BUTTON, 0, 0>

tbMake	TBBUTTON <20, IDM_MAKE_ASSEMBLE, 0,TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <21, IDM_MAKE_LINK, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <22, IDM_MAKE_GO, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <0, 0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>			
		TBBUTTON <23, IDM_MAKE_EXECUTE, 0, TBSTYLE_BUTTON, 0, 0>
		TBBUTTON <57, IDM_MAKE_STOP, 0, TBSTYLE_BUTTON, 0, 0>
.DATA?
proc_info						PROCESS_INFORMATION<?>

ObjectsFont						DWORD ?	;0=Normal,1=Large
hObjectsFont					DWORD ?

gl_uMsg							DWORD ?
hUILib							DWORD ?

hEditProperties					DWORD ?
hSelectComboList				DWORD ?


dwGlobalCounter					DWORD ?
hResourcesTab					DWORD ?

szInterfacePack					DB MAX_PATH+1 DUP(?)

ErrorLoadingFile				DB 32 DUP(?)	;"Error Loading "
szHideLines						DB 32 DUP(?)	;"Hide Lines"


AddOpenSaveFilesFilter			DB 512  DUP(?)
 								;DB "ASM Files (*.asm)",0,"*.asm",0
 								;DB "Include Files (*.inc)",0,"*.inc",0
 								;DB "Resource Files (*.rc)",0,"*.rc",0
 								;DB "Text Files (*.txt)",0,"*.txt",0
 								;DB "Definition Files (*.def)",0,"*.def",0
 								;DB "Batch Files (*.bat)",0,"*.bat",0
 								;DB "All Files (*.*)",0,"*.*",0,0

ResourcesFilter					DB 512  DUP(?)
 								;DB "Bitmap (*.bmp)",0,"*.bmp",0
 								;DB "Cursor (*.cur)",0,"*.cur",0
 								;DB "Icon (*.ico)",0,"*.ico",0
 								;DB "Animation (*.avi)",0,"*.avi",0
 								;DB "Manifest (*.xml)",0,"*.xml",0
 								;DB "Wave (*.wav)",0,"*.wav",0
 								;DB "Any File as Raw Data(*.*)",0,"*.*",0,0
 								;0=Bitmap,1=Cursor,2=Icon,3=Avi,4=Manifest,5=wave,6=Raw Data

OpenProjectFilter				DB 128  DUP(?)
 								;DB "WinAsm Studio Project Files (*.wap)",0,"*.wap",0,0

DLLsFilter						DB 128  DUP(?)
 								;DB "Dynamic Link Libraries (*.dll)",0,"*.dll",0,0


ExecutablesFilter				DB 128  DUP(?)
 								;DB 'Executables (*.EXE)',0,'*.exe',0
 								;DB 'All Files (*.*)',0,'*.*',0,0

KeyFilesFilter					DB 128  DUP(?)	
 								;DB "Key Files (*.vas)",0,"*.vas",0
 								;DB "All Files (*.*)",0,"*.*",0,0

APIFilesFilter					DB 128  DUP(?)
 								;DB "API Files (*.vaa)",0,"*.vaa",0
	           					;DB "All Files (*.*)",0,"*.*",0,0

HelpFilesFilter					DB 128  DUP(?)
 								;DB "Help Files (*.hlp)",0,"*.hlp",0
 								;DB "All Files (*.*)",0,"*.*",0,0

AllFilesFilter					DB 128  DUP(?)
 								;DB "All Files (*.*)",0,"*.*",0,0


BinaryFilesFilter				DB 128  DUP(?)
 								;DB "OBJ Files (*.obj)",0,"*.obj",0
 								;DB "RES Files (*.res)",0,"*.res",0
 								;DB "All Files (*.*)",0,"*.*",0,0

szDefault						DB 32  DUP(?);"Default"
szUppercase						DB 32  DUP(?);"Uppercase"
szLowercase						DB 32  DUP(?);"Lowercase"

szCopySelection					DB 32  DUP(?);"Copy Selected Text"
szCopyAllText					DB 32  DUP(?);"Copy All Out Text"
szSaveOutText					DB 32  DUP(?);"Save Text To File"



szYes							DB 32  DUP(?);"Yes"
szNo							DB 32  DUP(?);"No"
szTRUE							DB 32  DUP(?);"TRUE",0
szFALSE							DB 32  DUP(?);"FALSE",0


szStandardEXE					DB 32  DUP(?);"Standard EXE"
szStandardDLL					DB 32  DUP(?);"Standard DLL"
szConsoleApplication			DB 32  DUP(?);"Console Application",0
szStaticLibrary					DB 32  DUP(?);"Static Library"
szOtherExe						DB 32  DUP(?);"Other (EXE)"
szOtherNotExe					DB 32  DUP(?);"Other (Non-EXE)"
szDOSProject					DB 32  DUP(?);"DOS Project"

szLine							DB 32  DUP(?);"Line "
szIsADirectory					DB 32  DUP(?);" is a directory."
szIsAlreadyDefinedAs			DB 32  DUP(?);" is already defined as "
szDoYouWantToChangeIt			DB 32  DUP(?);". Do you want to change it?"
szTheLevelOfMenuItem			DB 32  DUP(?);"The level of menu item "
szIsNotCorrect					DB 32  DUP(?);" is not correct."
szExecutionError				DB 32  DUP(?);"Execution Failed!"


szLBEditorBackColor				DB 32  DUP(?);"Editor Back Color"
szLBNormalTextColor				DB 32  DUP(?);"Normal Text Color"
szLBSelectionBackColor			DB 32  DUP(?);"Selection Back Color"
szLBSelectedTextColor			DB 32  DUP(?);"Selected Text Color"
szLBCommentColor				DB 32  DUP(?);"Comment Color"
szLBStringColor					DB 32  DUP(?);"String Color"
szLBOperatorColor				DB 32  DUP(?);"Operator Color"
szLBErroredLineBackColor		DB 32  DUP(?);"Errored Line Back Color"
szLBNoErrorsLineBackColor		DB 32  DUP(?);"No Errors Line Back Color"
szLBTabIndicatorsColor			DB 32  DUP(?);"Tab Indicators Color"
szLBSelectionBarColor			DB 32  DUP(?);"Selection Bar Color"
szLBDividerLineColor			DB 32  DUP(?);"Divider Line Color"
szLBLinenumberscolor			DB 32  DUP(?);"Line numbers color"
szLBNumberColor					DB 32  DUP(?);"Number Color"
szLBToolTipsBackColor			DB 32  DUP(?);"ToolTips Back Color"
szLBToolTipsActiveParamColor	DB 32  DUP(?);"ToolTip Active Parameter Color"
szLBProjectTreeBackColor		DB 32  DUP(?);"Project Tree Back Color"
szLBProjectTreeTextColor		DB 32  DUP(?);"Project Tree Text Color"
szLBProjectTreeLineColor		DB 32  DUP(?);"Project Tree Line Color"
szLBRCEditorBackColor			DB 32  DUP(?);"RC Editor Back Color"



szSureToRemoveFileFromProject	DB 64 DUP(?)
szSureToRemoveMenu				DB 64 DUP(?)
szControlUsed					DB 64 DUP(?)
szSureToDeleteControl			DB 64 DUP(?)
szFileModified					DB 64 DUP(?)
szAskToSaveFileChanges			DB 64 DUP(?)
szSureToRemoveAcceleratorTable	DB 64 DUP(?)
szSureToRemoveVersionInfo		DB 64 DUP(?)
szSureToRemoveStringTable		DB 64 DUP(?)
szFriendlyNameRequired			DB 64 DUP(?);"A friendly name is required for this control."
szClassNameRequired				DB 64 DUP(?);"A Class name is required for this control.",0
szClassAlreadyUsed				DB 64 DUP(?);"The Class name is used by one or more controls and thus cannot be changed."
szNotWinAsmStudioProjectFile	DB 64 DUP(?);"This is not a WinAsm Studio project file (*.wap)."
szProjectWasNotSaved			DB 64 DUP(?);"The project was not saved."
szSureToDeleteThisDialog		DB 64 DUP(?);"Are you sure you want to delete this dialog?"
szSearchFinished				DB 64 DUP(?);"The specified region has been searched."
szCannotSaveFile				DB 64 DUP(?);"Can not save file."
szTriggerAlreadyUsed			DB 64 DUP(?);"This trigger word is already used."



szCreatePipeError				DB 64 DUP(?);"Make error: Cannot create pipe."
szCreateProcessError			DB 64 DUP(?);"Make error: Cannot create process.",0Dh,0Ah,0
szMakeFinshed					DB 64 DUP(?);"Make finished. "   ;used when I count errors.
szMakeError						DB 64 DUP(?);" error(s) occured."   ;used later when I count errors.



szCodeHiNotFound				DB 256 DUP(?);"CodeHi.dll not found. Please, make sure it is placed in the application's directory."
szLineNotCompatible				DB 256 DUP(?);" is not compatible with WinAsm Studio. No resources that follow this line will be extracted. Please, switch to non-visual mode and make the necessary changes.",0



szOpenProjectDialogTitle		DB 32 DUP(?)
szSaveProjectAsDialogTitle		DB 32 DUP(?)
szOpenFilesDialogTitle			DB 32 DUP(?)
szAddFilesDialogTitle			DB 32 DUP(?)
szSaveFileAsDialogTitle 		DB 32 DUP(?)
szRenameFileDialogTitle			DB 32 DUP(?)
szPrintDialogTitle				DB 32 DUP(?)
szNewProjectDialogTitle			DB 32 DUP(?);"New Project"
szBrowseDialogTitle				DB 32 DUP(?);"Browse"
szBrowseForPathDialogTitle		DB 32 DUP(?);"Browse For Path"
szWindowStyles					DB 32 DUP(?);"Window Styles"
szWindowExStyles				DB 32 DUP(?);"Window ExStyles"
szRenameProjectDialogTitle		DB 32 DUP(?);"Rename Project"

szPointer						DB 32 DUP(?)

szRestore						DB 32 DUP(?)
szGradient						DB 32 DUP(?);"Gradient"
szDoubleLine					DB 32 DUP(?);"Double Line"
szSingleLine					DB 32 DUP(?);"Single Line"

szSelectProcedureOrGoToTop		DB 32 DUP(?);"(Select Procedure Or GoTo Top)"
szSaving						DB 32 DUP(?);"Saving ..."
szCompilingResources			DB 32 DUP(?);"Compiling Resources ..."
szConvertingResToObj			DB 32 DUP(?);"Converting Res To Obj ..."
szAssemblingProject				DB 32 DUP(?);"Assembling Project ..."
szLinking						DB 32 DUP(?);"Linking ..."
szLnColSel						DB 32 DUP(?);"Ln: %lu, Col: %lu, Sel: %lu"
szSearching						DB 32 DUP(?);"Searching ..."
szReplacing						DB 32 DUP(?);"Replacing ..."
szLoadingResources				DB 32 DUP(?);"Loading Resources ..."
szLoadingProject				DB 32 DUP(?);"Loading Project ..."
szCreatingProject				DB 32 DUP(?);"Creating Project ..."



szKey							DB 32 DUP(?)
szString						DB 32 DUP(?)
szProjects						DB 32 DUP(?)						
szFile							DB 32 DUP(?)
szAvailableAddIns				DB 32 DUP(?)
szLoadStatus					DB 32 DUP(?)
szLoadOnStartUp					DB 32 DUP(?)



szName							DB 32 DUP(?)
szID							DB 32 DUP(?)
szLeftt							DB 32 DUP(?)
szTop							DB 32 DUP(?)
szWidth							DB 32 DUP(?)
szHeight						DB 32 DUP(?)
szStyle							DB 32 DUP(?)
szExStyle						DB 32 DUP(?)
szVisibleProperty				DB 32 DUP(?)
szCaption						DB 32 DUP(?)
szText							DB 32 DUP(?)
szImage							DB 32 DUP(?)
szMenu							DB 32 DUP(?)
szClass							DB 32 DUP(?)
szFont							DB 32 DUP(?)

szProjectType					DB 32 DUP(?);"Project Type"
szResourceMakeOptions			DB 32 DUP(?);"Resource"
szReleaseMakeOptions			DB 32 DUP(?);"Release"
szDebugMakeOptions				DB 32 DUP(?);"Debug"

szGeneral						DB 32 DUP(?);"General",0
szFilesAndPaths					DB 32 DUP(?);"Files && Paths",0
szEditor						DB 32 DUP(?);"Editor",0
szIntellisense					DB 32 DUP(?);"Intellisense",0
szKeyWords						DB 32 DUP(?);"KeyWords",0
szColors						DB 32 DUP(?);"Colors",0
szMiscellaneous					DB 32 DUP(?);"Miscellaneous",0


szAddNewDialog					DB 32 DUP(?)
szNewMenu 						DB 32 DUP(?)
szIncFiles						DB 32 DUP(?)
szAddAcceleratorTable			DB 32 DUP(?)
szAddVersionInfo				DB 32 DUP(?)
szStringTable					DB 32 DUP(?)
szResources						DB 32 DUP(?)
szRemoveT						DB 32 DUP(?)

szBlocks						DB 32 DUP(?)
szProject						DB 32 DUP(?)

szDialogs						DB 32 DUP(?)
szOthers						DB 32 DUP(?)

szMenus							DB 32 DUP(?)
szAcceleratorTables				DB 32 DUP(?)
szVersionInfo					DB 32 DUP(?)

szASMFiles						DB 32 DUP(?)
szModules						DB 32 DUP(?)
szIncludeFiles					DB 32 DUP(?)
szResourceFiles					DB 32 DUP(?)
szTextFiles						DB 32 DUP(?)
szBatchFiles					DB 32 DUP(?)
szDefinitionFiles				DB 32 DUP(?)
szOtherFiles					DB 32 DUP(?)

szGridSize						DB 32 DUP(?)
szAlignLefts					DB 32 DUP(?)
szAlignCenters					DB 32 DUP(?)
szAlignCentersWithDialogCenter	DB 32 DUP(?)
szAlignRights					DB 32 DUP(?)
szAlignTops						DB 32 DUP(?)
szAlignMiddles					DB 32 DUP(?)
szAlignMiddlesWithDialogMiddle	DB 32 DUP(?)
szAlignBottoms					DB 32 DUP(?)
szMakeSameWidth					DB 32 DUP(?)
szMakeSameHeight				DB 32 DUP(?)




szMakeSameSize					DB 32 DUP(?)

szFileMenu				DB 32 DUP(?)
szNewProject			DB 32 DUP(?)
szOpenProject			DB 32 DUP(?)
szCloseProject			DB 32 DUP(?)
szSaveProject			DB 32 DUP(?)
szSaveProjectAs			DB 32 DUP(?)
szNewFileMItem			DB 32 DUP(?)
szNewASMFile			DB 32 DUP(?)
szNewINCFileMItem		DB 32 DUP(?)

szNewRCFileMItem		DB 32 DUP(?)
szNewOtherFileMItem		DB 32 DUP(?)

szOpenFiles				DB 32 DUP(?)
szSaveFile				DB 32 DUP(?)
szSaveFileAs			DB 32 DUP(?)
szPrint					DB 32 DUP(?)
szRecentProjectsManager	DB 32 DUP(?)
szExit					DB 32 DUP(?)


szEditMenu				DB 32 DUP(?)
szUndo					DB 32 DUP(?)
szRedo					DB 32 DUP(?)
szCut					DB 32 DUP(?)
szCopyT					DB 32 DUP(?)
szPaste					DB 32 DUP(?)
szDelete				DB 32 DUP(?)
szSelectAll				DB 32 DUP(?)
szFind					DB 32 DUP(?)
szFindNext				DB 32 DUP(?)
szFindPrevious			DB 32 DUP(?)

szSmartFind				DB 32 DUP(?)
szReplaceMItem			DB 32 DUP(?)
szGotoLine				DB 32 DUP(?)
szGotoBlock				DB 32 DUP(?)
szGoBack				DB 32 DUP(?)
szToggleBookmark		DB 32 DUP(?)
szNextBookmark			DB 32 DUP(?)
szPreviousBookmark		DB 32 DUP(?)
szClearAllBookmarks		DB 32 DUP(?)


szViewMenu				DB 32 DUP(?)
szProjectExplorerMItem	DB 32 DUP(?)
szOutputWindow			DB 32 DUP(?)
szToolBoxMItem			DB 32 DUP(?)
szDialogMItem			DB 32 DUP(?)

szProjectMenu			DB 32 DUP(?)
szAddNewAsm				DB 32 DUP(?)
szAddNewInc				DB 32 DUP(?)
szAddNewRc				DB 32 DUP(?)
szAddNewOther			DB 32 DUP(?)
szAddFiles				DB 32 DUP(?)
szModule				DB 32 DUP(?)
szRenameFile			DB 32 DUP(?)
szRemoveFile			DB 32 DUP(?)
szRunBatchFile			DB 32 DUP(?)
szVisualMode			DB 32 DUP(?)
szUseExternalEditor		DB 32 DUP(?)
szProperties			DB 32 DUP(?)
szBinaryFiles			DB 32 DUP(?)
szRenameProjectMItem	DB 32 DUP(?)

szFormatMenu			DB 32 DUP(?)
szIndent				DB 32 DUP(?)
szOutdent				DB 32 DUP(?)
szComment				DB 32 DUP(?)
szUncomment				DB 32 DUP(?)
szConvert				DB 32 DUP(?)
szToUpperCase			DB 32 DUP(?)
szToLowerCase			DB 32 DUP(?)
szToggleCase			DB 32 DUP(?)


szResourcesMenu			DB 32 DUP(?)
szDialogMenu			DB 32 DUP(?)
szDefinitions			DB 32 DUP(?)
szShowHideGrid			DB 32 DUP(?)
szSnapToGrid			DB 32 DUP(?)

szControlsManager		DB 32 DUP(?)
szStyleMItem			DB 32 DUP(?)
szExStyleMItem			DB 32 DUP(?)
szFontMItem				DB 32 DUP(?)
szSendToBack			DB 32 DUP(?)
szBringToFront			DB 32 DUP(?)
szTestDialog			DB 32 DUP(?)



szMakeMenu				DB 32 DUP(?)
szSetActiveBuild		DB 32 DUP(?)
szReleaseVersion		DB 32 DUP(?)
szDebugVersion			DB 32 DUP(?)
szClean					DB 32 DUP(?)
szCompileRCMItem		DB 32 DUP(?)
szRCToObjMItem			DB 32 DUP(?)
szAssembleMItem			DB 32 DUP(?)
szLinkMItem				DB 32 DUP(?)
szGoAll					DB 32 DUP(?)
szExecute				DB 32 DUP(?)
szDebug					DB 32 DUP(?)

szToolsMenu				DB 32 DUP(?)
szCodeEditorFont		DB 32 DUP(?)
szLineNumberFont		DB 32 DUP(?)
szOptions				DB 32 DUP(?)
szToolsManagerMItem 	DB 32 DUP(?)
szInterfacePacks	 	DB 32 DUP(?)

szAddInsMenu			DB 32 DUP(?)
szAddInsManager			DB 32 DUP(?)

szWindowMenu			DB 32 DUP(?)
szClose					DB 32 DUP(?)
szCloseAll				DB 32 DUP(?)
szNext 					DB 32 DUP(?)
szPrevious 				DB 32 DUP(?)
szTileHorizontally 		DB 32 DUP(?)
szTileVertically 		DB 32 DUP(?)
szCascade 				DB 32 DUP(?)

szHelpMenu				DB 32 DUP(?)
szWinAsmHelp 			DB 32 DUP(?)
szOtherHelp 			DB 32 DUP(?)
szOnTheWeb				DB 32 DUP(?)
szAboutWinAsm 			DB 32 DUP(?)


szTipNewProject				DB 32 DUP(?)
szTipOpenProject			DB 32 DUP(?)
szTipOpenFiles				DB 32 DUP(?)
szTipAddFiles				DB 32 DUP(?)
szTipSaveFile				DB 32 DUP(?)
szTipSaveProject			DB 32 DUP(?)
szTipCut					DB 32 DUP(?)
szTipCopy					DB 32 DUP(?)
szTipPaste					DB 32 DUP(?)
szTipUndo					DB 32 DUP(?)
szTipRedo					DB 32 DUP(?)
szTipShowHideExplorer		DB 32 DUP(?)
szTipVisualMode				DB 32 DUP(?)
szTipFind					DB 32 DUP(?)
szTipReplace				DB 32 DUP(?)
szTipIncreaseIndent			DB 32 DUP(?)
szTipDecreaseIndent			DB 32 DUP(?)
szTipCommentBlock			DB 32 DUP(?)
szTipUncommentBlock			DB 32 DUP(?)
szTipToggleBookmark			DB 32 DUP(?)
szTipNextBookmark			DB 32 DUP(?)
szTipPreviousBookmark		DB 32 DUP(?)
szTipClearAllBookmarks		DB 32 DUP(?)
szTipAssemble				DB 32 DUP(?)
szTipLink					DB 32 DUP(?)
szTipGoAll					DB 32 DUP(?)
szTipExecute				DB 32 DUP(?)
szTipStop					DB 32 DUP(?)

szExplorer					DB 32 DUP(?)
szOutput					DB 32 DUP(?)
szDialogDW					DB 32 DUP(?)
szToolBox					DB 32 DUP(?)



fAutoComplete			DWORD ?
hAutoCompleteWithLabel	DWORD ?
hAutoCompleteWithSpace	DWORD ?
hAutoCompleteWithTab	DWORD ?
hAutoCompleteWithEnter	DWORD ?

hFunctionTriggerList	DWORD ?
hOpeningParenthesis		DWORD ?
hAcceptsParameters		DWORD ?
hCanBeAParameter		DWORD ?
hFunctionTriggerLabel	DWORD ?
hFunctionNameEdit		DWORD ?
hAddFunctionButton		DWORD ?
hDeleteFunctionButton	DWORD ?
hApplyFunctionButton	DWORD ?

lpTrigger				DWORD ?



hChkSilently						DWORD ?
bRCSilent							DWORD ?

hPellesTools						DWORD ?
bPellesTools						DWORD ?

lpCustomControls					DWORD ?

hBrowseDefaultProjectDir			DWORD ?
hTextDefaultProjectDir				DWORD ?
hLabelDefaultProjectDir				DWORD ?

AutoIncFileVersion					DWORD ?

hClipFormat							DWORD ?
hDialogsTree						DWORD ?
hOthersTree							DWORD ?
hPropertiesList						DWORD ?

hFontUnderline						DWORD ?

hArrowRt							DWORD ?
hArrowLt							DWORD ?

ActiveBuild							DWORD ?

Features							FEATURES <>
bThisFileIsAlreadyInTheProject		DWORD ?

OpenChildStyle						DWORD ?
hOpenChildrenMaximized				DWORD ?

hHSplit								DWORD ?
hEditorToGoBack						DWORD ?

hProcAutoComplete					DWORD ?
hRetLabel							DWORD ?
hRetCombo							DWORD ?
;hEndPLabel							DWORD ?
;hEndPCombo							DWORD ?

ActiveDock							DWORD ?

hImlNormal							DWORD ?
hImlMonoChrome						DWORD ?


LaunchExeOnGoAll					DWORD ?
UseQuotes							DWORD ?
DebugUseQuotes						DWORD ?

WinAsmHandles						HANDLES <>
pAddInsFrameProcedures				DWORD ?
pAddInsProjectExplorerProcedures	DWORD ?
pAddInsOutWindowProcedures			DWORD ?
pAddInsChildWindowProcedures		DWORD ?


ExternalResourceEditor				DB MAX_PATH DUP(?)
ExternalDebugger					DB MAX_PATH DUP(?)

hTextExtResEd			DWORD ?
hLabelExtResEd			DWORD ?
hBrowseForExtResEd		DWORD ?

hTextExtDebugger		DWORD ?
hLabelExtDebugger		DWORD ?
hBrowseForExtDebugger	DWORD ?

lpProcedureName			DWORD ?
;hBlocksList			HWND ?
;hProjTab				HWND ?
;-----------------------------------------------
;For insert from list for Include and IncludeLib
ReplaceStart			DWORD ?
ReplaceLength			DWORD ?
;-----------------------------------------------

ShowOutOnSuccess		DWORD ?
hOutPopUpMenu			DWORD ?

hListIncludes			DWORD ?

InitDir					DB 256 DUP (?)
szAppCaption			DB 256 DUP (?)

hBrowseForBinaryPath	HWND ?
hBrowseForIncludePath	HWND ?
hBrowseForLibraryPath	HWND ?

hListVariables						HWND ?
;nProcStart							DWORD ?

hMainIcon							HWND ?
hTrayPopupMenu						HWND ?
note								NOTIFYICONDATA <>

hShowSplash							HWND ?
hLaunchExeOnGoAll					HWND ?
hUseQuotes							HWND ?
hDebugUseQuotes						HWND ?
hOnMinimizeToSysTray				HWND ?
hAutoToolAndOptions					HWND ?

hAutoClean							HWND ?

ShowSplashOnStartUp					DWORD ?
OnMinimizeToSysTray					DWORD ?
AutoToolAndOptions					DWORD ?
AutoClean					 		DWORD ?

hDeleteSchemeButton		HWND ?
hSaveSchemeButton		HWND ?
hSchemesLabel			HWND ?
hSchemesCombo			HWND ?
hColorsList				HWND ?

hGroupsLabel			HWND ?
hGroupsList				HWND ?
hKeyWordsLabel			HWND ?
hKeyWordsList			HWND ?
hRecycledLabel			HWND ?
hRecycledList			HWND ?
hToRecycled				HWND ?
hFromRecycled			HWND ?
hWordToAdd				HWND ?
hAddButton				HWND ?
hDeleteButton			HWND ?
hBoldButton				HWND ?
hItalicButton			HWND ?
hApplyButton			HWND ?


OnStartUp					DWORD ?
hGoupBoxOnStartUp			HWND ?
hOpenDlgOnStartUp			HWND ?
hOpenLastProjectOnStartUp	HWND ?
hShowRecentProjectsOnStartUp	HWND ?
hNoneOnStartUp				HWND ?

pLinkedList				DWORD ?	;API Constants
hListConstants			DWORD ?
hListStructureMembers	DWORD ?

;In this block all API Constants exist so that they
;are always available to fill the Constants List
;only when needed.
pAPIConstantsBlock	DWORD ?


nParam				DWORD ?
PopUpPos			POINT <?>

hToolTip			DWORD ?

hListAPIImageList	DWORD ?
hListProcedures		DWORD ?

hListStructures		DWORD ?
hDragImageList		DD ?
ItemBeingDragged    DD ?

hOut                DWORD ?

LineTxt				DB 16384 DUP(?)
tmpLineTxt			DB 16384 DUP(?)
CurrentLineTxt		DB 16384 DUP(?)
FunctionToolTip		DB 16384 DUP(?)
tmpBuffer			DB 16384 DUP(?)
tmpBuffer2			DB 16384 DUP(?)


BuggyWindowFileName DB MAX_PATH DUP(?)
BugLine             DWORD ?
NrOfErrors          DWORD ?
OldOutProc			DWORD ?
OldEditorProc		DWORD ?
LineHilited         DWORD ?

BinaryPath          DB MAX_PATH DUP(?)
IncludePath			DB MAX_PATH DUP(?)
LibraryPath			DB MAX_PATH DUP(?)

HelpFileName		DB MAX_PATH DUP(?)
KeyWordsFileName	DB MAX_PATH DUP(?)
APIFunctionsFile	DB MAX_PATH DUP(?)
APIStructuresFile	DB MAX_PATH DUP(?)
APIConstantsFile	DB MAX_PATH DUP(?)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; by shoorick 
;-----------------------------------------------------------------------
; alternate keyword files
;-----------------------------------------------------------------------
xIncludePath		DB MAX_PATH DUP(?)
xKeyWordsFileName	DB MAX_PATH DUP(?)
xAPIFunctionsFile	DB MAX_PATH DUP(?)
xAPIStructuresFile	DB MAX_PATH DUP(?)
xAPIConstantsFile	DB MAX_PATH DUP(?)
;-----------------------------------------------------------------------
; pointers to alternate keyword files
;-----------------------------------------------------------------------
.DATA
pIncludePath		DD offset IncludePath
pKeyWordsFileName	DD offset KeyWordsFileName
pAPIFunctionsFile	DD offset APIFunctionsFile
pAPIStructuresFile	DD offset APIStructuresFile
pAPIConstantsFile	DD offset APIConstantsFile
KeyWordsLoaded      DD 0 ; flag to know - was they ever been loaded?
;-----------------------------------------------------------------------
.DATA?
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CustColors			DD 16 DUP(?)

hAutoSave			DD ?
hShowOutOnSuccess	DD ?


hLnNrWidth			DD ?
hLnNrWidthText		DD ?


hTabToSpaces				DD ?
hTabSizeLabel				DD ?
hTabSizeText				DD ?
hAutoIndent					DD ?
hTabIndicators				DD ?
hShowScrollTips				DD ?
hShowLineNumbersOnOpen		DD ?
hAutoshowLineNumbersOnError	DD ?
hGradientMenuItems			DD ?
TabToSpaces					DWORD ?
TabSize						DWORD ?
AutoIndent					DWORD ?
TabIndicators				DWORD ?
ShowScrollTips				DWORD ?
ShowLineNumbersOnOpen		DWORD ?
AutoshowLineNumbersOnError	DWORD ?
GradientMenuItems			DWORD ?
AutoLineNrWidth				DWORD ?
AutoSave					DWORD ?

LineNrWidth        			DD ?

tmpcol				CHCOLOR	<?>
col					CHCOLOR	<?>

hMainHeap			DD ?

C0					DD ?
C1					DD ?
C2					DD ?
C3					DD ?
C4					DD ?
C5					DD ?
C6					DD ?
C7					DD ?
APIFunctionsColor	DD ?
APIStructuresColor	DD ?
APIConstantsColor	DD ?
C11					DD ?
C12					DD ?
C13					DD ?
C14					DD ?

lpC0WORDS			DD ?
lpC1WORDS			DD ?
lpC2WORDS			DD ?
lpC3WORDS			DD ?
lpC4WORDS			DD ?
lpC5WORDS			DD ?
lpC6WORDS			DD ?
lpC7WORDS			DD ?
lpAPIFunctions		DD ?
lpAPIStructures		DD ?
lpAPIConstants		DD ?
lpC11WORDS			DD ?
lpC12WORDS			DD ?
lpC13WORDS			DD ?
lpC14WORDS			DD ?


FileName 					DB MAX_PATH DUP(?)
IniFileName					DB MAX_PATH DUP(?)
ProjectTitle				DB MAX_PATH DUP(?)

CompileRC					DB MAX_PATH DUP(?)
RCToObj						DB MAX_PATH DUP(?)

szReleaseAssemble			DB MAX_PATH DUP(?)
szReleaseLink				DB MAX_PATH DUP(?)
szReleaseOutCommand			DB MAX_PATH DUP(?)
szReleaseCommandLine		DB MAX_PATH DUP(?)


szDebugAssemble				DB MAX_PATH DUP(?)
szDebugLink					DB MAX_PATH DUP(?)
szDebugOutCommand			DB MAX_PATH DUP(?)
szDebugCommandLine			DB MAX_PATH DUP(?)

ProjectPath					DB MAX_PATH DUP(?)

szAppFileName				DB MAX_PATH DUP(?)
szAppFilePath				DB MAX_PATH DUP(?)

FindBuffer					DB 256 DUP(?)
ft							FINDTEXTEX <>
fres						DWORD ?

;hParentOut					DWORD ?
;hProjectTree				DWORD ?

hBrowseKeyFile				DWORD ?
hBrowseAPIFunctionsFile		DWORD ?
hBrowseAPIStructuresFile	DWORD ?
hBrowseAPIConstantsFile		DWORD ?

hBrowseHelpFile			DWORD ?
hClient					DWORD ?
hCodeHiDLL				DWORD ?
hEditTB					DWORD ?
hEditor					DWORD ?
hFind					DWORD ?
hFont					DWORD ?

hIFont					DWORD ?
hInstance 				HINSTANCE ?
hLnrFont				DWORD ?
hMainTB					DWORD ?
hMakeTB					DWORD ?
hMenu					DWORD ?
hNewProjectImageList	DWORD ?
hNewProjectList			DWORD ?
;hProjectExplorer		DWORD ?
;hRebar					DWORD ?
hStatus					DWORD ?

TabCtrlItem				TC_ITEM <?>

hOptionsTabControl		DWORD ?
hTabControl				DWORD ?

hTextCVTRES				DWORD ?
hTextBinaryPath 	    DWORD ?
hTextIncludePath    	DWORD ?
hTextLibraryPath		DWORD ?

hTextKeyFile			DWORD ?
hTextAPIFunctionsFile	DWORD ?
hTextAPIStructuresFile	DWORD ?
hTextAPIConstantsFile	DWORD ?

hTextHelpFile			DWORD ?

hLabelML				DWORD ?
hLabelLINK				DWORD ?
hLabelOUT				DWORD ?
hLabelCommandLine		DWORD ?
hDividerLine			DWORD ?

hReleaseTextML			DWORD ?
hReleaseTextLINK		DWORD ?
hReleaseTextOUT			DWORD ?
hReleaseTextCommandLine	DWORD ?

hDebugTextML			DWORD ?
hDebugTextLINK			DWORD ?
hDebugTextOUT			DWORD ?
hDebugTextCommandLine	DWORD ?


hLabelRC				DWORD ?
hTextRC					DWORD ?
hLabelCVTRES			DWORD ?
hLabelBinaryPath		DWORD ?
hLabelIncludePath		DWORD ?
hLabelLibraryPath		DWORD ?
hLabelKeyFile			DWORD ?
hLabelAPIFunctionsFile	DWORD ?
hLabelAPIStructuresFile	DWORD ?
hLabelAPIConstantsFile	DWORD ?

hLabelHelpFile			DWORD ?

lfntlnr					LOGFONT <>
lfnt					LOGFONT <>

;nLastLine				DWORD ?

ProjectType				DWORD ?	;0=Standard EXE
								;1=Standard DLL
								;2=Console Application
								;3=Static Library
								;4=Other EXE
								;5=Other Non-EXE
								;6=DOS Project
ReplaceBuff				DB 256 DUP(?)
OutCloseButtonRect		RECT <>

.DATA
szCodeHidll				DB "CodeHi.dll",0

szObjectsFont			DB "ObjectsFont",0

szSpaceSlashI			DB " /I",0
szUI					DB "UI",0
szEnglish				DB "English (Official)",0
hFontTahoma				DWORD 0


lpInterfacePacks		DWORD 0
MaxInterfacePackMenuID	DWORD 30101

hAccelerator			DWORD 0

szMASM					DB "MASM",0
szLINK					DB "LINK",0
szRC					DB "RC",0
szAllAlphaNumeric		DB "ABCDEFGHIJKLMNOPQRSTUVWXYZabcedfghijklmnopqrstuvwxyz",0
szHash					DB "#",0
sz99999					DB "99999",0
szTwoDots				DB "..",0


TickCount				DWORD 0
szINTELLISENSE			DB "INTELLISENSE",0
szAutoComplete			DB "AutoComplete",0


szTRIGGER				DB "TRIGGER",0

szRCSilent				DB "RCSilent",0
szPellesTools			DB "PellesTools",0

szCONTROLS				DB "CONTROLS",0
bUpdateSelect			BOOLEAN TRUE
szAutoIncFileVersion	DB "AutoIncFileVersion",0

szSiteURL				DB "http://www.winasm.net",0
szopen					DB "open",0
CanShowMDIChildren 		DWORD TRUE

szShowGridKey			DB "ShowGrid",0
szSnapToGridKey			DB "SnapToGrid",0
szGridSizeKey			DB "GridSize",0

szSCHEMES				DB "SCHEMES",0
szRCBackCol				DB "RCBackCol",0
szFIND					DB "FIND",0


fClosingProject				DWORD FALSE
fClosingApp					DWORD FALSE

szThreeDots					DB "...",0


szEAX						DB "EAX",0
szEBX						DB "EBX",0
szECX						DB "ECX",0
szEDX						DB "EDX",0
szESI						DB "ESI",0
szEDI						DB "EDI",0

szButton					DB "Button",0
szOpenChildrenMaximized		DB "OpenChildrenMaximized",0
FullProjectName				DB MAX_PATH DUP(0)

szPlacement					DB "Placement",0
szCourierNew				DB 'Courier New',0
hRCEditorWindow				DWORD 0
RCModified					DWORD FALSE

szTAB						DB "	",0
hToolBox					DWORD 0

hToolBoxToolBar				DWORD 0
hRCOptions					DWORD 0
hRCOptionsToolBar			DWORD 0


DWBlockSize					DWORD 0
pDWBlock					DWORD 0

szToolbarClass				DB "ToolbarWindow32",0

szSETTINGSONEXIT			DB "SETTINGSONEXIT",0
szActiveDock				DB "ActiveDock",0
szPROJECTEXPLORER			DB "PROJECTEXPLORER",0
szOUTPARENT					DB "OUTPARENT",0

szTOOLBOX					DB "TOOLBOX",0
szRCPROPERTIES				DB "RCPROPERTIES",0
szRCOPTIONS					DB "RCOPTIONS",0
szVisible					DB "Visible",0
szDockedTo					DB "DockedTo",0
szTitleStyle				DB "TitleStyle",0
szNoDockLeft				DB "NoDockLeft",0
szNoDockTop					DB "NoDockTop",0
szNoDockWidth				DB "NoDockWidth",0
szNoDockHeight				DB "NoDockHeight",0
szDockTopHeight				DB "DockTopHeight",0
szDockBottomHeight			DB "DockBottomHeight",0
szDockLeftWidth				DB "DockLeftWidth",0
szDockRightWidth			DB "DockRightWidth",0

ExternalFilesMenuID			DWORD 50000
UntitledAsmCounter			DWORD 0
UntitledIncCounter			DWORD 0
UntitledRcCounter			DWORD 0
UntitledOtherCounter		DWORD 0

szRecentProjects			DB 240 DUP (?)	;40x6
szTools						DB 800 DUP (?)	;40x20
NextMenuID					DWORD 40001


szZero						DB "0",0
szOne						DB "1",0
szTwo						DB "2",0
szADDINS					DB "ADDINS",0

szInUIAllDLLs				DB "UI\*.dll",0
szInAddInsAllDLLs			DB "AddIns\*.dll",0
szInAddIns					DB "AddIns\",0


szWinAsmHelpFileAndPath		DB "Help\WinAsm.chm",0
szQuote						DB '"',0
szInTemplatesAllFiles		DB "Templates\*.*",0
szSlashAllFiles				DB "\*.*",0
szInTemplates				DB "Templates\",0
szEmptyProject				DB "Empty Project",0
szMISCELLANEOUS				DB "MISCELLANEOUS",0

szExtResEdit				DB "ExtResEdit",0
szExtDebugger				DB "ExtDebugger",0


szCr						DB 0DH,0


szShowOutOnSuccess			DB "ShowOutOnSuccess",0

szSlash						DB "\",0
szAllInc					DB "*.inc",0
szAllLib					DB "*.lib",0

szInitDir					DB "InitDir",0


szMinus						DB "-",0

szOnMinimizeToSysTray		DB "OnMinimizeToSysTray",0
szAutoToolAndOptions		DB "AutoToolAndOptions",0
szAutoClean					DB "AutoClean",0


szShowSplash				DB "ShowSplash",0
szLaunchExeOnGoAll			DB "LaunchExeOnGoAll",0
szUseQuotes					DB "UseQuotes",0
szDebugUseQuotes			DB "DebugUseQuotes",0

szSHOWFILE					DB "SHOWFILE",0

szTOOLS						DB "TOOLS",0
szRECENT					DB "RECENT",0

;----------------------------------------
;To read from the ini
szRet						DB "Ret",0
;szEndP						DB "EndP",0
;----------------------------------------
szRETUpperCase				DB 0Dh,VK_TAB,"RET",0Dh,0
szRETLowerCase				DB 0Dh,VK_TAB,"ret",0Dh,0
szRETDefault				DB 0Dh,VK_TAB,"Ret",0Dh,0

;szEndPLowerCase				DB "endp",0
;szEndPUpperCase				DB "ENDP",0
;szEndPDefault				DB "EndP",0
;
;
;szEndSLowerCase				DB " ends",0
;szEndSUpperCase				DB " ENDS",0
;szEndSDefault				DB " EndS",0
;
;szEndMLowerCase				DB "endm",0
;szEndMUpperCase				DB "ENDM",0
;szEndMDefault				DB "EndM",0

szWAToolTipClass			DB "WAToolTip",0

szComma						DB ",",0
DragMode         			DD FALSE

szColorTemplate				DB "%#08lx",0


szCmntStart					DB 'comment +',0
szCmntEnd					DB '-',0

fr							DWORD FR_DOWN	;i.e. Set the initial Find-Replace Direction to down.

hASMFilesItem				DWORD 0
hModulesItem				DWORD 0

hDefFilesItem				DWORD 0
hIncludeFilesItem			DWORD 0
hOtherFilesItem				DWORD 0
hParentItem					DWORD 0
hResourceFilesItem			DWORD 0
hTextFilesItem				DWORD 0
hBatchFilesItem				DWORD 0

szAllObj					DB "*.obj",0
szAllRes					DB "*.res",0
;szALLlst					DB "*.lst",0
szAllExp					DB "*.exp",0

szAppName					DB "WinAsm Studio",0
szCATEGORIES				DB "CATEGORIES",0

szAssemble					DB "Assemble",0
szDebAssemble				DB "DebAssemble",0
szLink						DB "Link",0
szDebLink					DB "DebLink",0
szOut						DB "Out",0
szDebOut					DB "DebOut",0
szRelComLn					DB "ReleaseCommandLine",0
szDebComLn					DB "DebugCommandLine",0


szC0COLOR			DB "C0COLOR",0
szC1COLOR			DB "C1COLOR",0
szC2COLOR			DB "C2COLOR",0
szC3COLOR			DB "C3COLOR",0
szC4COLOR			DB "C4COLOR",0
szC5COLOR			DB "C5COLOR",0
szC6COLOR			DB "C6COLOR",0
szC7COLOR			DB "C7COLOR",0
szC8COLOR			DB "C8COLOR",0
szC9COLOR			DB "C9COLOR",0
szC10COLOR			DB "C10COLOR",0
szC11COLOR			DB "C11COLOR",0
szC12COLOR			DB "C12COLOR",0
szC13COLOR			DB "C13COLOR",0
szC14COLOR			DB "C14COLOR",0



szC0WORDS			DB "C0(Asm&Inc)",0
szC1WORDS			DB "C1(Asm&Inc)",0
szC2WORDS			DB "C2(Asm&Inc)",0
szC3WORDS			DB "C3(Asm&Inc)",0
szC4WORDS			DB "C4(Asm&Inc)",0
szC5WORDS			DB "C5(Asm&Inc)",0
szC6WORDS			DB "C6(Asm&Inc)",0
szC7WORDS			DB "C7(Asm&Inc)",0
szAPIFunctions		DB "API(Funct)",0
szAPIStructures		DB "API(Struct)",0
szAPIConstants		DB "API(Const)",0
szC0RC				DB "C0(Resource)",0
szC1RC				DB "C1(Resource)",0
szC0BAT				DB "C0(Batch)",0
szC1BAT				DB "C1(Batch)",0


szChildClass					DB "ChildWindow",0
szStaticClass					DB 'Static',0
szEditClass						DB 'Edit',0
szButtonClass					DB 'Button',0
szComboBoxClass					DB 'ComboBox',0
szListBoxClass					DB 'ListBox',0
szToolTipsClass					DB 'Tooltips_class32',0
szScrollBarClass				DB 'ScrollBar',0
szTabControlClass				DB 'SysTabControl32',0
szProgressBarClass				DB 'msctls_progress32',0
szTreeViewClass					DB 'SysTreeView32',0
szListViewClass					DB 'SysListView32',0
szTrackBarClass					DB 'msctls_trackbar32',0
szUpDownClass					DB 'msctls_updown32',0
szToolBarClass					DB 'ToolbarWindow32',0
szStatusBarClass				DB 'msctls_statusbar32',0
szDateTimeClass					DB 'SysDateTimePick32',0
szMonthViewClass				DB 'SysMonthCal32',0
szUserControlClass				DB 'UDCCLASS',0
szComboBoxExClass				DB 'ComboBoxEx32',0
szIPAddressClass				DB 'SysIPAddress32',0
szAnimateClass					DB 'SysAnimate32',0
szHotKeyClass					DB 'msctls_hotkey32',0
szPagerClass					DB 'SysPager',0
szReBarClass					DB 'ReBarWindow32',0
szRichEditClass					DB 'RichEdit20A',0


szTahomaFontName				DB "Tahoma",0
szCompileRC						DB "CompileRC",0

szEDITOR						DB "EDITOR",0
szEditorFontName				DB "EditorFontName",0
szEditorFontSize				DB "EditorFontSize",0
szEditorFontCharset				DB "EditorFontCharset",0
szLineNrFontName				DB "LineNrFontName",0
szLineNrFontSize				DB "LineNrFontSize",0

szBackColor						DB "BackColor",0
szTextColor						DB "TextColor",0
szSelBackColor					DB "SelBackColor",0
szSelTextColor					DB "SelTextColor",0
szCommentColor					DB "CommentColor",0
szStringColor					DB "StringColor",0
szOperatorColor					DB "OperatorColor",0
szHiliteColor1					DB "HiliteColor1",0
szHiliteColor2					DB "HiliteColor2",0
szHiliteColor3					DB "HiliteColor3",0
szSelBarBackColor				DB "SelBarBackColor",0
szSelBarPen						DB "SelBarPen",0
szLineNrColor					DB "LineNrColor",0
szNumberColor					DB "NumberColor",0
szTltBackColor					DB "TltBackColor",0
szTltActParamCol				DB "TltActParamCol",0

szLineNrWidth   			    DB "LineNrWidth",0
szTabSize						DB "TabSize",0
szAutoIndent					DB "AutoIndent",0
szTabIndicators					DB "TabIndicators",0
szShowScrollTips				DB "ShowScrollTips",0
szShowLineNumbersOnOpen			DB "ShowLineNumbersOnOpen",0
szAutoshowLineNumbersOnError	DB "AutoshowLineNumbersOnError",0
szGradientMenuItems				DB "GradientMenuItems",0
szAutoLineNrWidth				DB "AutoLineNrWidth",0
szAutoSave						DB "AutoSave",0
szOnStartUp						DB "OnStartUp",0
szTabToSpaces					DB "TabToSpaces",0
szTreeBackColor					DB "TreeBackColor",0
szTreeTextColor					DB "TreeTextColor",0
szTreeLineColor					DB "TreeLineColor",0

szBinaryPath        DB "BinaryPath",0
szIncludePath       DB "IncludePath",0
szLibraryPath       DB "LibraryPath",0

szExtAsm			DB ".asm",0
szExtBat			DB ".bat",0
szExtDef			DB ".def",0
szExtExe			DB ".exe",0
szExtDll			DB ".dll",0
szExtLib			DB ".lib",0
szExtInc			DB ".inc",0
szExtObj			DB ".obj",0
szExtRes            DB ".res",0
szExtRc				DB ".rc",0
szExtTxt			DB ".txt",0
szExtwap			DB ".wap",0
szExtCom			DB ".com",0

szFILES				DB "FILES",0
szBINFILES			DB "BINFILES",0
szFILESANDPATHS		DB "FILES&PATHS",0
szGENERAL			DB "GENERAL",0
szKeyFile			DB "KeyFile",0
szAPIFunctionsFile	DB "APIFunctionsFile",0
szAPIStructuresFile	DB "APIStructuresFile",0
szAPIConstantsFile	DB "APIConstantsFile",0
szHelpFile          DB "HelpFile",0

szMAKE				DB "MAKE",0
szActiveBuild		DB "ActiveBuild",0

szOUT				DB ' /OUT:"',0
szPROJECT			DB "PROJECT",0

szRCToObj			DB "RCToObj",0
;szReplace			DB "Replace",0
szType				DB "Type",0
szWinAsmINI			DB "WinAsm.ini",0


szClientClass		DB "MDICLIENT",0
szCodeHi			DB "CodeHi",0

szNewFile			DB 'Untitled',0


szNewProjectTitle	DB "New Project",0
szNewProjectFile	DB "New Project.wap",0

szParentWindow		DB "MainWindow",0
szRebar				DB "ReBarWindow32",0

szOption			DB 'Option $',0


comment $
shoorick: reminder of fasm blocks
---------------------
Proc NAME
...
EndP
---------------------
struct NAME
...
ends
---------------------
macro NAME {
...
}
---------------------
struc NAME {
...
}
---------------------
winproc NAME
...
EndP
---------------------
ps: winproc - my "wrapper", but i use it widely, Proc/winproc may have locals:
Local name: definition
- seems similar to masm
$


szASSEMBLER			DB 'ASSEMBLER',0

szProcDef			DB 'Proc',0
szEndPDef			DB 'EndP',0
szMacroDef			DB 'Macro',0
szEndmDef			DB 'Endm',0
szStructDef			DB 'Struct',0
szEndsDef			DB 'Ends',0


szPROTO				DB '$ PROTO',0

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   by shoorick - removed space economy
;-----------------------------------------------------------------------
dszProc				DB '$ proc',0    ;masm
dszEndp				DB '$ endp',0    ;masm
dszMacro			DB '$ macro',0   ;masm
dszEndm				DB 'endm',0      ;masm
dszStruct			DB '$ struct',0  ;masm
dszEnds				DB '$ ends',0    ;masm
;-----------------------------------------------------------------------
szFasmProcStyle     db 'FasmProcStyle',0
FasmProcStyle       db 0
;-----------------------------------------------------------------------
.DATA?
;-----------------------------------------------------------------------
szProc				DB 32 DUP (?)
szEndp				DB 32 DUP (?)
szMacro				DB 32 DUP (?)
szEndm				DB 32 DUP (?)
szStruct			DB 32 DUP (?)
szEnds				DB 32 DUP (?)
;-----------------------------------------------------------------------
.DATA
;-----------------------------------------------------------------------
;szProc				DB 'proc $',0		;FASM
;szEndp				DB 'endp',0			;FASM
;szMacro				DB 'macro $',0		;FASM
;szEndm				DB '}',0			;FASM
;szStruct			DB 'struct $',0		;FASM
;szEnds				DB 'ends',0			;FASM


;szData				DB '.data',0
;szDataU			DB '.data?',0
;szConst			DB '.const',0
;szEndSeg			DB '.*',0

;CHBDProc			CHBLOCKDEF <Offset szProc, Offset szEndp, FALSE>

;CHBDFasmProc		CHBLOCKDEF <Offset szFasmProc,Offset szFasmEndp,0,0,BD_DIVIDERLINE>; or BD_INCLUDELAST


CHBDProc			CHBLOCKDEF <Offset szProc,Offset szEndp,0,0,BD_DIVIDERLINE>; or BD_INCLUDELAST
CHBDMacro			CHBLOCKDEF <Offset szMacro,Offset szEndm,0,0,BD_DIVIDERLINE or BD_LOOKAHEAD>; or BD_INCLUDELAST
CHBDStruct			CHBLOCKDEF <Offset szStruct,Offset szEnds,0,0,BD_DIVIDERLINE> 


;CHBDData			CHBLOCKDEF <offset szData,offset szEndSeg,0,0,0>
;CHBDDataU			CHBLOCKDEF <offset szDataU,offset szEndSeg,0,0,0>
;CHBDConst			CHBLOCKDEF <offset szConst,offset szEndSeg,0,0,0>

Blocks				DD Offset CHBDProc,Offset CHBDMacro,Offset CHBDStruct,0;Offset CHBDData,Offset CHBDDataU,Offset CHBDConst,0


szAssume  			DB 'assume $',0
szLocal				DB 'Local $',0



szInclude			DB 'Include $',0
szIncludeLib		DB 'IncludeLib $',0

szSpc				DB " ",0

ProjectModified		DWORD FALSE

szNULL				DB 0

LOWORD MACRO DoubleWord	;;Retrieves the low WORD from double WORD argument
	MOV	EAX,DoubleWord
	AND	EAX,0FFFFh		;;Set to low word 
ENDM
HIWORD MACRO DoubleWord	;;Retrieves the high word from double word 
	MOV	EAX,DoubleWord
	SHR	EAX,16			;;Shift 16 for high word to set to high WORD
ENDM

M2M MACRO M1, M2		;; Copy word from memory to memory
	PUSH M2
	POP  M1
ENDM

Return MACRO Arg
	MOV EAX, Arg
	RET
ENDM

;CTEXT MACRO Text
;LOCAL szText
;
;	.DATA
;	szText BYTE Text, 0
;	.CODE
;	ExitM < Offset szText >
;ENDM

CTEXT MACRO y:VARARG 
   LOCAL sym, dummy 
   dummy EQU $   ;; MASM error fix 
   CONST segment 
      IFIDNI <y>,<> 
         sym db 0 
      ELSE 
         sym db y,0 
      ENDIF 
   CONST ends 
   EXITM <Offset sym> 
ENDM