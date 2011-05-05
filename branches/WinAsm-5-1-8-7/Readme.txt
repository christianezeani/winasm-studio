-For ID>15000 string must be 511 chars long max
-For ID>12000 string must be 127 chars long max
-For ID>10000 strings are 255 chars long max
-For ID>5000 && ID<10001 strings are 63 characters long max
-For ID<50001 strings are 31 chars long max


V5.1.7.xxx
----------
-Two new flags on the menu dialog of the Visual RC editor: MF_RIGHTJUSTIFY,MF_DEFAULT (SeaFarer) 
	As a consequence, a new version of the MUI dll for each language supported is needed.
	CONTROL "MF_DISABLED",18,"Button",0x50010003,10,132,74,9,0x00000000
	CONTROL "MF_MENUBREAK",35,"Button",0x50010003,10,142,74,9,0x00000000
-->	CONTROL "MF_RIGHTJUSTIFY",36,"Button",0x50010003,10,152,74,9,0x00000000
-->	CONTROL "MF_DEFAULT",37,"Button",0x50010003,10,162,74,9,0x00000000
	CONTROL "Type",34,"Button",0x50000007,102,102,86,44,0x00000000


V5.1.6.xxx
----------
-Menu item shortcuts are now saved a Ctrl+Shift+... and not Shift+Ctrl+...

-File - Print Accelrator fixed

-TAB / ...+TAB menu shortcuts are now displayed properly on the menu dialog of the visual RC Editor.

-FASM: since procs are not recognized, they are not only noncollapsed, but also are not added
into the list of blocks and do not appeared in the combobox to fast jumping.(shoorick)
1.collapsing blocks proc, struct and macro:
- proc and struct: instead of masm they are macros (not embedded),
so, are the first word in the line (not second). i think, if you check
both positions you will support both compilers at once. macro is also
the first word, but there little more difficulty: macros in fasm (as i
understood) are single-lined and multy-lined. in last case there are
opening { end closing } (i hate these brackets, but what can i do!)...
so, i have no ideas in this. but, i started from collaping because i
think this is more easy, but in real it could be left at all as is!
[ASSEMBLER]
;FASM
Proc=proc $
EndP=endp
Macro=macro $
Endm=}
Struct=struct $
Ends=ends


-MUI developers:
 Tools-Options-Editor- label: "Block End:"=106 (hEndPLabel) not needed
 Tools-Options-Editor- ComboBox 107 (hEndPCombo) not needed
 "Block Auto Complete" = 103 renamed to "Proc Auto Complete"
 "Ret (Proc only):" = 104 renamed to "Ret:"
 
V5.1.5.xxx
----------
-undo for backspace & delete in overstrike mode minor bug fixed (JimG)
-hRebar was not properly exported to Add-Ins (JimG)  


V5.1.4.xxx
----------
-'Visible' property for dialogs reverted to TRUE; fixed (Thanks SeaFarer)

1. change code editor font to tahoma
2. put cursor in any not-empty line
3. Try SHIFT+HOME or SHIFT+END
Result:
The selected range has more then one line. (Thanks al3x4nder, bulk_4me, icehole)


V5.1.3.xxx
----------
-16-bit linker response file line limit bnt to tahoma
2. put cursor in any not-empty line
3. Try SHIFT+HOME or SHIFT+END
Result:
The selected range has more then one line. (Thanks al3x4nder, bulk_4me


V5.1.3.xxx
----------
-16-bit linker response file line limit bnt to tahoma
2. put cursor in any not-empty line
3. Try SHIFT+HOME or SHIFT+END
Result:
The selected range has more then one line. (Thanks al3x4nder, bulk_4me


V5.1.3.xxx
----------
-16-bit linker response file line limit bypassed (Thanks icehole)
-Visual RC Editor: Managed controls did not use window text on creation

V5.1.2.xxx
----------
-DOS projects could not be executed if project name was different than the first asm file(Thanks icehole)
-PopUp lists and tooltip now use hFont (editor's font) so that even large fonts are used, we have correct scrolling(Thanks IanB) and size is under control!(Thanks IanB)
 -Various improvements/speed optimizations regarding intellisense
-Command line passed to projects is now in this format *"C:\appapath\appname.exe" blah blah* - (Thanks shoorick)
-flashing (project explorer sel change,  WM_SYSCOMMAND, WM_NCLBUTTONDOWN)

V5.1.1.xxx
----------
-GetProjectBinName much better/faster: If no /OUT command specified, the project bin name is ProjectName+Extension(e.g. exe)
-Open a standalone rc file (not in a project) that contains a richedit control. Close WinAsm Studio. Crash! (Thanks shoorick)
-SetCurrentDirectory in IDM_MAKE_DEBUG

V5.1.0.xxx
----------
-when add-ins list is active in add-ins manager it would be good if spacebar pressing toggle "Loaded" (as mouse doubleclick) - Thanks shoorick
-it might be good to add a close program button into the tool bar so i don't have to open the Taskmanager and find the program and close it-Thanks lilljocke,Jupiter,blues,shoorick
-polink, polib (Thanks Vortex)
-Open Project/Open files drop down should change commandid/bitmap on selection;fixed

MUI dll developers
IDTT_STOP								EQU 2028 (stop)
New project dialog :Pelles Tools


V5.0.9.xxx
----------
1.The tab control handle on the Project Explorer (hProjTab) was not exported correctly to the Add-Ins (Thanks JimG)

2.Removed all duplicated handles that are already kept in WinAsmHandles

3.Clean from project menu does NOT delete *.lst files( Thanks JimG) 

V5.0.8.xxx
----------
1.Very rarely: 'Invoke ' caused crash or probably fucked variables (crash observed when "option proc:private" statement was present in a project)

2.small bug with non monospaced fonts fixed

3.Updated CodeHi control.

4.Find string is now updated even if find dialog is already loaded and Edit-Find (Ctrl+F) is selected (Thanks Jupiter) 

V5.0.7.xxx
----------
-New library projects don't use -LIB switch for linking

-MENUBREAK type is now supported by the Visual menu editor, as a consequence:

For MUI dll developers:
-----------------------
Dialog ID=215
-------------
1.New control
CONTROL "MF_MENUBREAK",35,"Button",0x50010003,107,143,74,9,0x00000000

2.Some other controls' rearrangments


V5.0.6.xxx
----------
-ComboBoxes of modules not Refresed upon MUI change;fixed

-dzen found this: if your startup splash screen is on, when you start winasm.exe splash window appeared, then it disappeared and winasm window goes backward. i tried this and took same.

-Several images updated (Thanks to our artist, PhoBos)

-New dialogs don't have WS_EX_TOOLWINDOW by default (Thanks shoorick)

-Dialogs/controls or other resources are now deleted by pressing Delete (on the keyboard)

-English (Australia) is added to the available languages on the Vewrsion Info dialog (Thanks Artoo)

-also he complaign he could not add colour schemes into winasm.ini: when he add what Jupiter posted, he could see only one in ver 504 and none in 505. i'd never used colour schemes before yet and supposed it is because of length of the string of colour descriptions... (even because a new colour added in 505) i've add them, but also saw just one (in 505) - "Dark".(Thanks dzen)



For MUI dll developers:
-----------------------
-Remove WS_EX_TOOLWINDOW from ALL dialogs (Thanks dzen)
 
;---------------------------------------------------------------------------------------
V5.0.5.xxx
----------
blues
it seems like there are some statusbar styles missing, as follows:


CODE  

SBARS_SIZEGRIP     0x0100
SBARS_TOOLTIPS     0x0800
CCS_VERT           0x00000080L
CCS_LEFT           (CCS_VERT | CCS_TOP)
CCS_RIGHT          (CCS_VERT | CCS_BOTTOM)
CCS_NOMOVEX        (CCS_VERT | CCS_NOMOVEY)
 



 
those starting with CCS_ apply also to toolbars (also missing).
additionally, some of the statusbar styles don't behave correctly as far as i know.
for example (in winasm resource editor) CCS_TOP and CCS_BOTTOM go in pairs, if you check one the other is checked as well, and viceversa; CCS_NOMOVEY cannot be unchecked unless both CCS_TOP and CCS_BOTTOM are unchecked... 

-Improvements for scrollbars and statusbars after styles changes

-Dialog/Control styles are now sorted in descending order, when higher styles exist , the lower ones are set to No. e.g. style=3 cause style=1 and style=2 to be displayed as no on the styles list.
 
-Tooltip active parameter color (Thanks PhoBos, shoorick, lamer, blues Mark Jones)

-Moving or sizing a control on a dialog caused flickering;fixed

-Test Dialog when DS_CENTER, if Test dialog height or width was bigger than screen dimensions,  was NOT positioned properly

-tab indicators doesnt seem to do anything in the latest version;fixed-->new CodeHi.dll(Thanks Artoo, blues)

-So, we have three buttons and only one #define for the very first button  
 The one only solution - manualy edit RC file, adding needed defines.
 Once I tried to copy and paste 96 statics (Thanks lamer)

-sometimes I can type, the cursor moves to the next place before thelast 3 or 4 characters have been shown.(Thanks Artoo, shoorick)

-New Version Info starts with Western Europe charset.Also, WinAsm Studio always goes back to an empty charset selection if I modify the RC in text mode to something other than the set of predefined entries (Thanks Artoo)

For MUI dll developers:
-----------------------
New Strings
-----------
-IDLBS_TOOLTIPSACTIVEPARAMCOLOR		EQU 1694 --->In English = "ToolTip Active Parameter Color"

-change F12 Accelerator from 10311 to 11202 (Thanks shoorick)



;---------------------------------------------------------------------------------------
V5.0.4.xxx
----------
list on string table and accelarators dialogs are now WS_CLIPCHILDREN

***************************************************
well, a buggy ;) if you open winasm, then open another (i have
usually some opened instances), then if you chose 1'st recent project
from menu (not from the recent projects manager) then will open last
opened project, but not that which name is on the item menu. in
other words, menu items has names from the list from last ini, but
then ini is changed with other instances, and first recent item
opens first project from ini, it could be already not those, written
on it (i hope you understand :D). it should or store real pathes
matching to text on items, or items has to be updated dinamically...
or you can left only recent projects manager, what is not good...
or you can left only some few recent projects - 1..3 - think this
will be enough... or it could be a new submenu, updated dinamically
(as languages submenu)... but i think it would be better store
names matching to the items and have few recent items: even one
could be enough (when winasm just opened - fast open the last of the
last) - all other could be acessed via manager. it is not too bad
bug, but first times i've thought i have hallucinations :D
  
also,if the recent list cleared/filled from empty dinamically, spare
dividers appeared in menu "file". i know it is not easy as looks,
but, i think, it could be solved via simple enabling/disabling
recent projects manager menu item(Thanks shoorick)
***************************************************
-The colapsing PROC statements with a + or - to expand/collapse are great, how about expanding the idea to include a function to select any block of text and do the same, maybe a special 'Bookmark' marking the beginning and end of a colapsable block. I think this could make large files like WinProc (For example) much more readable.(Thanks mrs33,andrew_k)

-And a question i have: When I press CTRL-Space, i get the intellisense list
which is normal; but, is there a hotkey to popup the argument list or
something ? I keep having to retype commas and stuff to get the prompt up,
which is annoying because when i click over to another argument,
the prompt closes again. I don't like having to hold onto Right or Left
to get it make the little tooltip thingy turn a certain argument blue
PS: the fact that you have to do the comma thing or open parenthesis
has always been a pain in the neck for me with other software as well,
e.g. VC++. Ideally I wish the argument prototype tooltip thingy popped up
immediately even when i just positioned my caret in the invoke line!(Thanks Savage,shoorick,Mieuws)

-Intellisense major rewites: when CodeHi splitted, wrong position of tooltip and list

-New CodeHi.dll

-New WAAddIn.inc

-Well, now the toolbox is successfully copying and pasting, but I still hear a computer speaker beep and a small delay (i.e. the text doesnt paste until the beep is done like a second later). Am I alone on this or is it happening to everyone? 
It does it with various CTRL hotkeys (Z,X,C,V,Y,R,Q,A, and also a few other letters that I didn't think even do anything), but curiously not for various others (S,D for example; and others that pull up a popup). 
This applies to all text properties in the dialog editor property box.... that is, except for Caption! Caption acts perfectly normal, so something's working there.(Thanks Savage)

-Large Objects Font uses larger font for several items: Project Explorer, Procedures Combobox, Statusbar etc etc (Thanks iceberg)

-The project tree gives us the ability to rename all the files in a project except the project file itself. Is there anyway this can be changed so that we can rename the actual .wap?(Thanks andrew_k)

-In the explorer window: The dialog created by "Add Files..." should include a string with all possible extensions ".asm;.inc;.rc;.text" for adding quickly a known source file. I hate it to select ".inc" first".(Thanks DarkSoul)

-start to edit first or last line in the listbox in rc editor (for ex.
string list), then (do not complete this!) click on arrow buttons of
scrollband to move this line out from border (eg. if it first - down,
if last - up): new rows will have same image as edited (not repainted)(Thanks shoorick)


For MUI dll developers:
-----------------------
New Strings
-----------
IDMS_HIDELINES		EQU 220 --->In English = "Hide Lines\tCtrl+I"
IDMS_RENAMEPROJECT	EQU 414 --->In English = "Rename Pro&ject"
IDDT_RENAMEPROJECT	EQU 2213 --->In English = "Rename Project"

New Accelerator
---------------
"I", 10120, VIRTKEY, NOINVERT, CONTROL

New Control on Options Dialog
-----------------------------
CONTROL "Large Objects Font",145,"Button",NOT 0x10000000 | 0x00010023,180,80,94,12,0x00000000

;---------------------------------------------------------------------------------------

V5.0.3.xxx
----------

-You should never see wrong or missing Dividing lines for procedure/macros or structures any more (Thanks Qvasimodo, shoorick, blues)
	
-If no correct UI dll in WinAsm UI folder WinAsm Studio now looks for English (Official)-Thanks Jupiter

-	A new option in 'Project-->Add Object files (*.obj)' menu, allows you to link external object files compiled in other programming languages (i.e. C language). The added object files must have been compiled in COFF format and cannot have the same name than any of the Windows or Modules in the project. 
	I create my resources in the MS Visual Studio visual resource editor. It produces .rc files incompatible with WinAsm. I use .res files instead. But I need to add a blank .rc file with the same name as .res file to the project to make it work(Thanks DELTA_1)

-Changes in Opening Project routine should load big projects faster

-When the caret was not on a word, intellisense replaced the previous word;fixed (Thanks Qvasimodo)

-Constants are inserted only once in the Vaiables and Constants intellisense list no matter how many times one can find them in the vaa files (I like it now)

-ES_AUTOHSCROLL set by default for edit controls (Thanks Qvasimodo)

-A problem im having with intellisense is when i go back to edit an invoke argument, and edit the beginning of the word, the intellisense will popup and cover up the original word and the rest of the line, since it appears right next to the cursor. To make it a lot easier, i think making the intellisense menu so that it pops up one line under the current one is a must. (Thanks Savage)
 
-Intellisense does something that I found strange, when dealing with function parameters. For example, when typing the second parameter to ShowWindowAsync, the popup correctly shows all possible flags. But when I type the letter "n" (I tried to type "nCmdShow", a local variable name), the popup dissapears. The strange part is that if I instead paste the variable name, the popup is shown again (and this time it has local variables and a bunch of unrelated constants). I wasn't sure this behavior was intentional... :?

-both ways: through about box and through F10 led to the main page of the site (not forum). since there two of them, it would be good to have at least one direct to the forum.

For MUI dll developers:
-----------------------

-New String:
	IDGS_TRUE				EQU 1803 --->In English = "TRUE"
	IDGS_FALSE				EQU 1804 --->In English = "FALSE"
	
	IDMS_BINARYFILES		EQU 413	--->In English = "Binary Files ..."
	IDFS_CHOOSEBINARYFILE	EQU 12008 -->In English =  "OBJ Files (*.obj)\0*.obj\0RES Files (*.res)\0*.res\0All Files (*.*)\0*.*"

	
-New Dialog (ID==221) for Binary Files
 
V5.0.2.xxx
----------
-Some minor rearrangements on the About dialog (Thanks Artoo)

-RAFONT structure in the WAAddIn.inc

-sometimes while resizing the explorer windows on the left size a line appears and does not disappears. when this happens the mouse cannot move outside the red square(Thanks jnrz7 & shoorick)

-New strings for translation (Thanks Qvasimodo):

	IDGS_YES					EQU 1801 --->In English = "Yes"
	IDGS_NO						EQU 1802 --->In English = "No"
	
	Project Types
	IDPTS_STANDARDEXE			EQU 1751 --->In English = "Standard EXE"
	IDPTS_STANDARDDLL			EQU 1752 --->In English = "Standard DLL"
	IDPTS_CONSOLEAPPLICATION	EQU 1753 --->In English = "Console Application"
	IDPTS_STATICLIBRARY			EQU 1754 --->In English = "Static Library"
	IDPTS_OTHEREXE				EQU 1755 --->In English = "Other (EXE)"
	IDPTS_OTHERNOTEXE			EQU 1756 --->In English = "Other (Non-EXE)" 
	IDPTS_DOSPROJECT			EQU 1757 --->In English = "DOS Project"

	IDMSG_TRIGGERALREADYUSED	EQU 5023 --->In English = "This trigger word is already used."
	IDMSG_EXECUTIONERROR		EQU 4507 --->In English = "Execution Failed!"


	IDMS_COPYSELECTION			EQU 1505 --->In English = "Copy Selected Text"
	IDMS_COPYALLTEXT			EQU 1506 --->In English = "Copy All Out Text"
	IDMS_SAVEOUTTEXT			EQU 1507 --->In English = "Save Text To File"

	IDCBS_DEFAULT				EQU 1691 --->In English = "Default"
	IDCBS_UPPERCASE				EQU 1692 --->In English = "Uppercase"
	IDCBS_LOWERCASE				EQU 1693 --->In English = "Lowercase"
	
	IDMSG_ERRORLOADINGFILE		EQU 4508 --->In English = "Error Loading "
	
	
	IDFS_OPENPROJECT			EQU 12001 --->(127 chars), In English = 
								"WinAsm Studio Project Files (*.wap)\0*.wap"

	IDFS_CHOOSEDLL				EQU 12002 --->(127 chars), In English = 
								"Dynamic Link Libraries (*.dll)\0*.dll"


				
	IDFS_CHOOSEEXECUTABLE		EQU 12003 --->(127 chars), In English = 
 								"Executables (*.EXE)\0*.exe\0All Files (*.*)\0*.*"

	IDFS_CHOOSEKEYFILE			EQU 12004 --->(127 chars), In English = 
 								"Key Files (*.vas)\0*.vas\0All Files (*.*)\0*.*"

	IDFS_CHOOSEAPIFILE			EQU 12005 --->(127 chars), In English = 
 								"API Files (*.vaa)\0*.vaa\0All Files (*.*)\0*.*"

	IDFS_CHOOSEHELPFILE			EQU 12006 --->(127 chars), In English = 
								"Help Files (*.hlp)\0*.hlp\0All Files (*.*)\0*.*"

	IDFS_CHOOSEALLFILES			EQU 12007 --->(127 chars), In English = 
								"All Files (*.*)\0*.*"

	IDFS_ADDOPENSAVEFILES		EQU 15001 --->(511 chars), In English = 
								"ASM Files (*.asm)\0*.asm\0Include Files (*.inc)\0*.inc\0Resource Files (*.rc)\0*.rc\0Text Files (*.txt)\0*.txt\0Definition Files (*.def)\0*.def\0Batch Files (*.bat)\0*.bat\0All Files (*.*)\0*.*"
	
	IDFS_CHOOSERESOURCE			EQU 15002 --->(511 chars), In English = 
								"Bitmap (*.bmp)\0*.bmp\0Cursor (*.cur)\0*.cur\0Icon (*.ico)\0*.ico\0Animation (*.avi)\0*.avi\0Manifest (*.xml)\0*.xml\0Wave (*.wav)\0*.wav\0Any File as Raw Data (*.*)\0*.*"
	
	On Options Dialog:
	1.-'Procedure Auto Complete' renamed to 'Block Auto Complete'
	2.-'Ret' renamed to 'Ret (Proc Only)'
	3.-'EndP' renamed to 'Block End'
	1, 2 & 3 above are handled (for all three type of blocks-NOT only procedures)when typing code
	
	For ID's >12000 string must be 127 chars long max

	For ID's >15000 string must be 511 chars long max
	

-menubar items now have item number - see WAAddIn.inc (Thanks Qvasimodo)

-cosmetic suggestion: swap items "tools manager" and "interfaces" in menu "tools" to place tools manager close to items, configured with it(Thanks shoorick)

-Make include path applicable to resource compiler too(Thanks zellloveyy)

-Version Info is required for setting language & codepage so that FontTahoma use the proper charset

-Browse for file to include in rc script now uses *.* filter (previously no filter applied)

-Ctrl+... for properties list; fixed (Thanks Savage)

V5.0.1.xxx
----------
1.Improved Greek UI

2.New:	IDTCS_PROJECTTYPE			EQU 1721
		IDTCS_RESOURCEMAKEOPTIONS	EQU 1722
		IDTCS_RELEASEMAKEOPTIONS	EQU 1723
		IDTCS_DEBUGMAKEOPTIONS		EQU 1724
		
		IDTCS_GENERAL				EQU 1731
		IDTCS_FILESANDPATHS			EQU 1732
		IDTCS_EDITOR				EQU 1733
		IDTCS_INTELLISENSE			EQU 1734
		IDTCS_KEYWORDS				EQU 1735
		IDTCS_COLORS				EQU 1736
		IDTCS_MISCELLANEOUS			EQU 1737

		
3.winasm has menu options "Viual mode" and "Use external editor" in the  project menu... may be, it would be better to place them into the resource menu(Thanks shoorick)

4.	Added accelerators:	Ctrl+B Go To Block
						Shift+Ctrl+B Go Back (Thanks masquer)
	
5.small bug: Swithing UI did not switch accelerators on the fly

6.After pressing OK on the "the specified region has been searched" messagebox, you can continue searching by pressing F3 if direction is set to all (Thanks JimG)

7.Added /NOENTRY to linker's agruments. So *.asm removed from your language DLL
 
8.Removed .def file from your language DLL
		
		
		From 7 & 8 you get at least 1,5 kb smaller dll and easier to maintain

9.There is no need to have at least one asm file in your project any more, so

10.IDMSG_NOASMERROR not needed; you can remove it from the dll of your language


V5.0.0.1831
---------
-MUI: (Thanks DarkSoul,scroll0_0)
	-Change menu captions to any language you prefer (or simply change the English Caption to your preferences)
	-Use any Accelrators you prefer
	-User defined among others:
		-menus
		-main toolbar tooltips
		-Docking window captions
		-Minimize to system tray context menu
		-Dialog docking window toolbar buttons
		-Toolbox docking window toolbar buttons
		-Resources toolbar buttons
		-Project Tree node texts
		-Dialogs/controls Properties
		-MessageBox's messages (For ID's >=10001 strings are 255 chars long. For ID's>=IDMSG_SURETOREMOVEFILEFROMPROJECT i.e. 5001  && <10001 strings are 63 characters long, all others 31 chars)
	-All Dialogs (Except About) can now be altered to your personal needs 
	-From Tools-Interface choose English (Official)/ÅëëçíéêÜ or any other custom language is provided in the future
	
-New option in Miscellaneous to (not)add quotes to file name to be debugged

-ImageList_LoadImage is used instead of ImageList_Create for 256 colors (16-bit palette) bitmaps
 to correct toolbar buttons images displaying bug (very rare)-(Thanks Lezhik)

-Search button is disabled. It seems that it happens if the project consists of a single file and only when this file starts MAXIMIZED.(Thanks JimG)

-After removing a file from a project, appropriate toolbar buttons were disabled.

-Under certain conditions, Inserting included files for the first time would crash WinAsm Studio

-When i create a new project "Add files..." works perfectly, but if I open an old project "Add files..." doesn't work(Thanks scud)

-Very rare Crash when scrolling fixed (Thanks Mark Jones)

-User Defined and managed custom controls did not show in "test dialog" if class was not available. Now, "static" is used in such a case

-I need to be able or close opened file - external to the project.(Thanks shoorick, Qvasimodo)

-When i "Assemble" project the program is "Not Responding" and project is not assembly. When i start program again and "Assemble" project is assembly normal(Thanks scud, Mark Jones)

-Ctrl+V in edit control of Properties list was inserting text twice

-Context menu on Docking windows title bar now shows current title style as a checked menu item.
 

(Thanks JimG)
I wanted an empty template just to skip the step of deleting the untitiled.asm file you get by default and answering the two questions about saving the file.
I created the attached empty project by doing a new project and deleting the untitled.asm file and savting it in templates as "Empty".
After doing so, this was the number 1 recent file in WinAsm.ini, and WinAsm would then crash every time I try to start it up. I manually changed the winasm.ini so it wasn't number 1 so I could start up WinAsm again. I though you might want to trap this condition rather than just crashing.

(Thanks JimG)
Also, WinAsm crashes if you just delete the #1 recent file from the ini file

V4.0.4.231
---------
-Use Quotes for sending file name to debugger is now optional (Thanks xxxxx)

V4.0.4.230
---------
-ILC_COLOR16 instead of ILC_COLOR24 for ImageList_Create of toolbars (Thanks Lezhik)
-Invoke LoadBitmap,... instead of Invoke LoadImage,... for image lists of toolbars(Thanks Lezhik)


V4.0.4.229
---------
-Controls Manager now closes with Esc
-The sizes aren't remembered correctly so you have to resize every window every time you reopen a project, which is a real pain if you have split a large project over a number of ASM files and INC files, because the default size is really very small. This info could easily be added to the WAP(Thanks IanB)
-Under certain conditions, several toolbar buttons and menu items were not disabled after closing a project.
-Several incompatible resource script statements are now handled-(Thanks DELTA_1)
	#undef
	#if
	#ifdef
	#pragma
	#endif
	#ifndef
	#elif
	#else
	TEXTINCLUDE
-A bug related to the "Handle incompatible scripts silently" option fixed

-New WAAddIn.inc
	-Dialog menu renamed to Resources menu
	
-Definitions Manager

-Much smoother opening and closing of projects<--------I like it very much now.

-When you have more than one control with the same ID, even across dialogs, deleting one of them removes the ID from the script. (I'm not sure if this one has been reported for earlier versions already, I'm posting just in case it hasn't).(Thanks Qvasimodo)

-Export ID definitions(Thanks shoorick)

-A serious (silly) bug regarding the controls Manager dialog Fixed

-From Visual Mode ON--->off--->ON--->OFF CRASH!!!!! fixed

-A lot of minor fixes

V4.0.3.xx
---------
-A bug when parsing resource ID names longer than 31 chars fixed (Thanks Qvasimodo)
-Override snapping to grids if Alt-key is pressed (Thanks shoorick)
-Double click to add Control(Thanks Jnrz)-->Small rearrangement of some buttons on the toolbox
-when I select a control 8 white little squares appear around the control, could you make them blue when active:P and white when inactive ?(Thanks Jnrz) 
-Double click on Control takes you to where ControlID is in code (Thanks DarkSoul)

V4.0.2.xx
---------
-About box: OK button is now BS_DEFPUSHBUTTON
-Now TriggerWord+one or more spaces and/or Tabs: displays function list w/o any entry selected.(Thanks Qvasimodo/JimG)
	-If TriggerWord needs an opening parenthesis,TriggerWord+( displays function list w/o any entry selected.(Thanks Qvasimodo/JimG)
-I get the line that says the next thing is wtype'' and if I type an "M" then I get the dropdown with the valid entries. What I was asking was if I didn't even know they all started with "M", so I don't know which letter to type, how do I get the dropdown so I can see what is in the list??(Thanks JimG)
-..., I would like an option for Intellisense to say, when I hit return, don't select the item from the dropdown, if I want it I will hit tab or space, return means just give me a carriage return. For example, the same problem occurs if the line ends in hwnd. Actually, now that I think about it, I would like the option to disable the tab key also, so I can just tab over to do a comment. If I want it I will just hit the space bar(Thanks JimG) 

V4.0.1.xx
---------
-Not sure if this is a bug or a "feature"  but when you hit Ctrl+Plus at the AddIn Manager you get to see two hidden columns in the listview. These contain the addins description strings and filenames. They would look better left aligned instead of centered. 

-changing the class of a dialog made the dialog invisible;fixed!

-LANGUAGE Statement outside ACCELERATORS, DIALOGEX, MENU, RCDATA, or STRINGTABLE is now supported too-in these statements it was already supported(Thanks cegy)

-when WS_VISIBLE is not defined for dialogs/controls, the visible property is set to false after styles dialog is used (Thanks JimG)

-Set menu item mnemonics for all Dialog menu item mnemonics, &Recent Projects Manager, F&ind Previous

-The output window doesn't seem to support the usual Ctrl+C hotkey to copy the selected text, it would be nice if it did.(Thanks Qvasimodo)

-Can an option be put in to NOT display a warning every time WinAsm Studio starts with a project that has a .rc file which is not compatible? Maybe on the Options window General tab, place a checkbox "Ignore Incompatible Resource Files".(Thanks curious1)<----Local to the project (Thanks Qvasimodo)

->Intellisense for function names only works if the rest of the line you are typing on is empty(Thanks IanB)
-->remember, that it does not work also when the line begins with label! maybe this bug is at the same part of code(shoorick)
--->A LOT of improvements for intellisense

-In a non invoke line, all constants appear in the local variables and parameters list (thanks shoorick for similar idea)

-New CodeHi control

-After last parameter, tooltip should disappear

-Multi invoke's allowed on a single line with proper tooltip!!! (please try to fool WinAsm Studio and let me know)

-Invoke, InvokeX insert a comma after selecting a function from the list. CALL does NOT insert

-some rare flicker of tooltip removed

-"CALL" tooltip show ALL parameters normall but none is active

-complete rewrite for "Invoke" intelisense

-for "CALL" do NOT highlight any parameter

-After a call do not search for any other trigger word in the same line

-Trigger words may or may not be parameters of other function calls (e.g. call and invoke cannot be in a InvokeX function call)

-matching parenthesis are taken into account

-New tab: Tools-Options-Intellisense

-"Font" property was "F&ont"; fixed

-editing a dialog class name, caused the dialog to disappear from the IDE!

-Should be even faster and flicker free (try  on a long line kepp pressing backspace)

New WAAddIn.inc
-New mebmer of the FEATURES structure: (thanks Qvasimodo)
	phRCEditorWindow	;pointer to hRCEditor MDI Child window e.g.:
						MOV EAX,phRCEditorWindow
						MOV EDX,[EAX]
						;EDX is window handle or 0 if resource file is NOT in Visual mode
						
-New mebmer of the FEATURES structure: (thanks Qvasimodo)
	plpDefinesMem	;Pointer to pointer to resource define statements memory e.g.:
					MOV EAX, plpDefinesMem
					MOV EDX,[EAX]
					;EDX is pointer to define statements memory-->Use [EDX].DEFINE.xxxx
Where,

DEFINE STRUCT
	szName			DB 64+1 DUP(?)
	dwValue			DD ?
	fDeleted		DD ?
DEFINE ENDS

-Second word of line was triggering the varaibles list; now,  if there line starts with a labelpossible label is if current line starts with a label,third word is triggering the list

-Third word ADDS ALL constants in the variables list. (if line starts with a label, 4th word instead of third)
	PhoBOs: you could add a dummy parameter and give ALL sorts of constants NOT already presented in the masmapiconst file e.g.
	dummy=IDABORT,IDCANCEL,IDIGNORE,IDNO,IDOK,IDRETRY,IDYES,INVALID_HANDLE_VALUE,etc etc
	

-Create an empty resource script. Add a new dialog. Right click on the caption bar of the toolbox and change it's style (gradient, single line, or double line). Left click on the newly created dialog. WinAsm causes a page fault, apparently when trying to read from a bad pointer in ECX).(Thanks Qvasimodo)

-A small redrawing issue, when changing the alignment of text in a group box. In the attachment there's a sample of how it looks like when you center the text of a previously left aligned group box(Thanks Qvasimodo) 

V4.0.0.xx
---------
1.WS_CLIPSIBLINGS not set to new controls by deafault (Thanks newman)

2.For example, a new INI file could be added (something like WACustCtrl.ini) with the needed info. In particular, I think all that's really needed for each control is:
1) Control's friendly name
2) Class name of the control.
3) DLL file where the control resides.
4) Optional list of styles supported, and their values. Could be an ASCIIZ array stored with WritePrivateProfileStruct.
The goal would be to integrate custom controls, without having to write them specifically for that task. For example, we could integrate controls made by a third party, whose sources we don't have.
(Thanks Qvasimodo)

3.As a result from 2 above: Controls Manager accessible from Dialog menu OR by right clicking on the toolbox

4.Styles dialog for user controls now in descending order (8000h, 4000h,...,1h  instead of 1h, 2h, 4h,...8000h)

5.Add-Ins manager is disabled when "Configure" button is pressed.

6.Double-clicking to choose from the Recent Projects Manager sometimes causes a GPF (Thanks shoorick).

7.correct context menu placement when keyboard is used for editor windows

8.In the Visual Resource Editor, the edit boxes in the Properties grid don't accept the common shortcuts Ctrl+C and Ctrl+V for Copy and Paste, respectively. This forces users to call the context menu which is not very convenient.(Thanks rubs)

9.Safe mode: Having F8 pressed while WinAsm Studio is launched, prevents any Add-In from loading on startup (Thanks shoorick)

10.After saving new files from the "Save Files" dialog,  the file name changes were not reflected on the project explorer (Thanks Qvasimodo)

11.Should observe a considerable increase in resources loading speed

12.ALT-F4 was destroying docking windows; Now it is NOT!!!

13.correct context menu placement when keyboard is used for docking windows

V3.0.6.xx
---------
-bug with checkboxes fixed(Thanks IanB)

-old fashioned CHECKBOX statement supported (Thanks IanB)

-Closing a child window, now previous one is activated-not next.(Thanks IanB)

-If a dialog is neither WS_CHILD nor WS_POPUP then WS_CAPTION is added automatically both in design mode and Test Dialog. The system also does this(Thanks IanB)

-If a dialog has the DS_CONTROL style, cannot have WS_CAPTION(Thanks IanB)

-The above two cases influence the dialog size

-Creates a window that has a border of a style typically used with dialog boxes. A window with this style cannot have a title bar(Thanks IanB)

-Removed WS_OVERLAPPEDWINDOW and WS_POPUPWINDOW from the dialog styles' list(Thanks IanB)

V3.0.5.xx
---------
1.shoorick
open wap - asm on top
  2.switch to rc - tools and dialog toolbars opened
  3.close toolbars
  4.switch to asm - you see 3 additional sets of buttons on client area
    (on the gif)

2.shoorick
about a little bug (to your collection ;)

when i delete pathes from the source help popup appears with lib list.
if i just press enter i got such string as upper:

         includelib user32.libb  <<<==
         includelib  \MASM32V1\lib\kernel32.lib
         includelib  \MASM32V1\lib\gdi32.lib
         includelib  \MASM32V1\lib\comctl32.lib

similar efect i've got for incs.
if i select for deleting also one blank space before \MASM..., then
all work proper (?)

to clear experiment i'll attach that source, so try by yourself ;)
select for deleting:
var1:
         includelib  [\MASM32V1\lib\]kernel32.lib
var2:
         includelib [ \MASM32V1\lib\]kernel32.lib

3. Also 'Include->space' was working OK but 'Include->tab' was not. Similarly for Includelib

4.Since this manager appears when studio starts it would be good to have "New" button on it when you wish to create a new project(Thanks shoorick)

5.Sorry for hijacking the post, but I have a question about the manager. I can't seem to catch the event of loading a project from it... for example, the add-in that shows the current project folder is disabled, because it never caught a message indicating that the current project has changed(Thanks Qvasimodo)
	Qvasimodo: New message (WAM_DIFFERENTCURRENTPROJECT) is sent to Add-Ins after the current project is different (even on startup) (e.g. after New Project/Close Project/Open Project etc is processed)   

6.Appropriate messages (IDM_RECENTPROJECTSMANAGER,IDM_OPENPROJECT) are now sent to Add-Ins also on startup(Thanks Qvasimodo)

V3.0.4.184
---------
-when a docking window is open and not docked, even if a modal dialog is open (eg. "options" dialog) it is possible to pass to the non-docked window just by clicking on it.(Thanks blues)
	-similarly about, Add-Ins manager, Project properties, New Project, Open Project dialogs, Print etc etc etc etc
	
-WAM_ENABLEALLDOCKWINDOWS	EQU WM_USER+106	;hWnd   = hMain
                                            ;wParam = 0
                                            ;lParam = TRUE/FALSE 
-About Dialog:
	-Title now reads exact fileversion (x.x.x.x) from compiled winasm.exe
	-Some minor changes to the text disppalyed to cover 16-bit DOS capabilities of WinAsm Studio

-When a NON modal dialog (eg. "find" dialog) is moved to overlap the titlebar of a docking window, then the titlebar is repainted like it is inactive(Thanks blues)

-Status bar s not updated with current selection while in(out)dent or (un)comment takes place-->faster and nicer

-hOut Scrollcaret fix after make

-Some "GetSettingsFromIni" changes let WinAsm Studio start even faster

-A lot of "SaveOptions" changes let WinAsm Studio save options faster

-Files & Paths should have an additional entry: Default Project Path(Thanks DarkSoul,shoorick,JimG)
	Used for
	-save project as							.If ProjectPath[0]	;i.e. project already saved
													MOV ofn.lpstrInitialDir, Offset ProjectPath
												.Else
													MOV ofn.lpstrInitialDir, Offset InitDir
												.EndIf

	-Save files as								.If [EDI].CHILDWINDOWDATA.dwTypeOfFile<101	;i.e. part of the current project
													.If ProjectPath[0]	;i.e. project already saved
														MOV ofn.lpstrInitialDir, Offset ProjectPath
													.Else
														MOV ofn.lpstrInitialDir, Offset InitDir
													.EndIf
												.Else
													.If [EDI].CHILDWINDOWDATA.fNotOnDisk==FALSE
														Invoke lstrcpy, ADDR Buffer, lpFileName
													.Else
														;No!!!!
														;i.e. Initial directory will be WinAsm Studio's folder
														;MOV ofn.lpstrInitialDir, Offset szAppFilePath
														;let it start with recently used folder
													.EndIf
												.EndIf

	
	-Add files									let it start with recently used folder

	-Open Files									let it start with recently used folder
	-New project based on template	WOW!!!		OK




-I would like if the current project dir become default EACH TIME I add file to the project or save as a new file, or add new resources. of course, this may be discussible, but it can be swithable in setup box.
-When project are created a last dir must be updated to project folder immediately, so, if you want to add existing file to project or want to save a new created file a project folder would be proposed as default.
2.i've suggested to make default dir the project dir after it created
immediatelly - you agree, but i thought better while working with
files from other dirs and now i think that project dir must be default
ALWAYS in "add" and "save as" dialogs, because in first time we are
working with our project dir, many project are made from other so
files have same names, after adding a file from well known dir i have
to search this project dir to save - this can lead to some
difficulties (when you are thinking about code not about dirs ;)



-Docking windows: Perfect!!!!!!!!!!!!!!!!! position for floating windows after WinAsm Studio restert not exactand various fine tunings!!!!

-New optional procedure WAAddInConfig for Add-Ins (Thanks shoorick)

------------------------------------------------------------------------------------------------------------------------------------

V3.0.3.21
---------
-What about applying the "Find" tool options to the "Smart Find" function ?
That is, when the "Match Case" check box is checked in the "Find" dialog, use "Mach Case" option while browsing the "Smart Find" result.
All the options can be used : Match Case, Whole Word, Whole Project and direction except FR_CURRENTPROJECT(Thanks PhoBos)

-it would be great to be able delete selected file from the project just with simple pressing "DELETE". (Thanks shoorick)

-I want to add here similar one: when the system is shutting down you may forget about winasm with changes in the tray, and it won't remind you about them (Thanks shoorick)

-Accelerators, String table, Included files & Resources lists: Add/delete LVM_ENSUREVISIBLE

-I always edit a file in several editors at one time.So when I save the changes in one editor,the others should reload the file and show the changes. But when I edit a file in WinASM and another editor,WinASM doesn't show any changes even if I close the same file in WinASM and reopen it. Can WinASM have a function to check the files weither having been modified and give me a choise weither to reload them?(Thanks iceberg)
	-If file modified outside then ask to reload
	-If file deleted/renamed--->user is asked to save when necessary or saved automatically when make is selected

-SS_REALSIZEIMAGE for image cotrols (Thanks shoorick)
	-Various issues when style/exstyle of images or image or size/position changed by the user.

-Various issues when style/exstyle of shapes or size/position changed by the user.
	
-Please, add to WinAsm Studio opportunity auto incrementation version (build number). It is, IMHO, very convenient.(Thanks NetSharp)
	;Takes place only If:
		-FileVersion Auto Increment is selected from version info dialog
		-Go All is used
		-RC file is in Visual mode
		-VerionInfo=1 is taken into account to autoincrement (This is how Windows OS is designed)
		-RC file is considered to be modified after successful Go All and thus user is asked to save it when appropriate
		
-Parent for messagebox of Find (Thanks blues)

-Set WS_TABSTOP for new controls if appropriate (Thanks shoorick)


V3.0.2.9
---------
-Save Project As for a first time project caused Save As dialog to appear twice

-Save project & Save Project As saved wap file even if it was not selected from the AskToSaveFilesDialog

-Recent Projects Dialog :Double click on any item to open a recent project

-Minor bug when adding multiple files that are at root of drive (e.g. c:\) to a project

-May I nag you again about using that WinAsm icon PhoBos made? I just looked at the "about box" and remembered 



V3.0.2.8a
---------
-Tools options General-On StartUp Recent projects was not saved (Thanks blues)

-Esc handling for "Recent Pojects" and "Ask To Save Dialogs" (Thanks blues)

V3.0.2.8
--------
-GoToProc not selecting correctly due to a bug with EM_LINELENGTH

-Selecting from the procedure combo manys time didn't work. Replaced EM_LINEFROMCHAR with EM_EXLINEFROMCHAR in ScrollToTop procedure

-Font of Project tree was not set (Thanks kestrel)

-New version of CodeHi. Scrollbars and grip size read global setting and (automatically) resized (Thanks kestrel)

-Are you aware that if you change the style setting on an edit control to ES_CENTER=yes, the dialog editor does not update the text to look centered on the control?  It works on statics immediately when you change to centered, just not on edit controls.(Thanks JimG)-->I call ReCreateControl proc

-Recreate Tab control after style changes(Thanks Qvasimodo)--->I call ReCreateControl proc

-Project Tab: Double click on .rc file should automatically open the Resources Tab(Thanks DarkSoul)

-Add-Ins can now specify a bitmap to accompany their Add-In menu items (Thanks Qvasimodo)
	-Size: 16x16, Color depth: 256 colors, Mask:0FF00FFh
	-If you use new ADDINMENUITEM structure method to append a new menu item hBitmapNormal must be a valid bitmap handle.hBitmapDisabled is not nessecary.
	-New WAAddIn.inc
	
-The listview columns of the "add-ins manager" are sized without taking in consideration the vertical scrollbar, so if the add-ins are many the vertical scrollbar covers partially the last column and appears also the horizontal scrollbar. it would look better i think if the columns are sized taking in account the possibility of a vertical bar.(Thanks blues)

-Dialog with all modified files: When you close WinASM, if you have made any changes, a dialog pops up with the question "Do you want to save changes to ......" and the options are Yes or No.Sometimes I can't remember if I made a change intentionally, so a Cancel option would be good so I can do a ctrl-z to see what the change was.(Thanks JimG, Marwin, redox, Fotis Katsis)

-OutPut window did not scroll to the end after make is finished

-Sometimes on opening project the first visible line was not the same with that when project had closed before

-EM_xxxx replaced with EM_EXxxxx I had several problems with big files.

-I would be nice to have a confirmation dialog before deleting a dialog box in the resource editor. Could be a life saver if you click "Delete" by accident, and it isn't used all that often for a messagebox to become an annoyance.(Thanks Qvasimodo)

-About Dialog link changed to http://www.winasm.cjb.net

-How about another item in the Help menu, to go to the WinAsm website?(Thanks Qvasimodo)

-Options: On WinAsm StartUp should have an additional entry: Show Recent Projects (I know of the Project Fodler Explorer but I like those things build in)(Thanks DarkSoul)

-New menuitem: File-Recent Projects Manager


V3.0.2.7
--------
-response file used for linking(Thanks Qvasimodo). Therefore:
	-developer has full control on how the project is linked
	-no size limit on link command line

-Serious changes on displaying "Make" output text-->not a character at a time

-Lib.exe is used for building libraries instead of link-->remove -lib command argument from your lib projects
 
-hClient is not hidden/shown when OpenWAP is called (it was very bad). WM_WINDOWPOSCHANGING is used to prevent showing of MDI children while opening a project

-PopUp menu handles are now exported to Add-Ins(Thanks JimG,QvasiModo,DarkSoul,shoorick)

-several changes in openwap to speed up things

-Add the structure CHSELCHANGE to WAAddIn.inc (Thanks PhoBos)

-Also, if you drop down a procedure combobox list (sometimes just to look there), but dont chose anything - a jump is taking anyway - it is also not well (back key will remove unpleasure from it).(Thanks shoorick)

-Save Files As for external files caused an an irrelevant messagebox to popup(Thanks shoorick) 

-There is no way to place a command line to starting exe - sometimes it's necessary.(Thanks shoorick)-Qvasimodo you need to do some work to your New Project Wizard Add-In

-Release n' Debug command line exported to Add-Ins

-Version Info auto increment(Thanks blues)

-Accelerator Tables auto increment

-Changing a Accelerator Table name, the name change was not reflected to the Others TreeView 


V3.0.2.6
--------
-Invoke DestroyAcceleratorTable,hAccel before application closes so that it is destoroyed if hAccel was created in an add-in
-Using tab to go to next column in stringtable dialog caused a gpf under w2k;Fixed(Thanks shoorick)
-Charset used for code editor is now used for all windows that Tahoma font is used.(Thanks shoorick)
-Could it be possible to remove the lines at root in the Project Explorer? With only one root element there's little use for them, and it would save some screen space(Thanks Qvasimodo) 
-would also be nice to go to the previous field with Shift+TAB.(Thanks blues)
-16-bit linking problems solved-"RedStub" not needed any more(Thanks Caleb)
-"Resources" dialog... tab/shift+tab similar behaviour to stringtable dialog(Thanks blues)
-WM_PAINT of Docking windows: Chack If WS_POPUP do nothing
-in the "options" dialog, "editor" tab, when clicking on "show line numbers on open" the checkbox label goes to overlap the other label "show line numbers on error"(Thanks blues)



V3.0.2.5
--------
-In Font Dialog for Dialog resources now Bold,Italics can be selected too.Weird but when compiled font is nver bold even if it is set so I ignore bold when I create the dialog font in design mode
	-When script is generated Bold,Italics,charset are kept
	
-FontSize	DWORD ?
 FontName	DB 32 DUP (?)
 removed from CONTRODATA to DIALOGDATA --->much? faster extraction of dalogs/controls and thus faster project loading


-WinAsm Help-->renamed to WinAsm Studio Help

-About WinAsm-->renamed to About WinAsm Studio

-Any dialog caption changed from "WinAsm ...." to "WinAsm Studio ...."

-Correction in ConvertToPixels (and ConvertToDialogUnits) procedure-->now dialog size in design mode is always exact.

-New Option: Show Line numbers On Open(Thanks shoorick)

-New Option: AutoShow line Numbers On Error(Thanks shoorick)

-Export pointer Accelerator table handle (Thanks shoorick):
	-New WAAddIn.inc
	-See AddNewAcceleratorEntry and RemoveNewAcceleratorEntry sample procedures
	-You can add/remove/edit existing Accelerator entries

-Now a suggesting to a stringlist dialog: is it too do such algorithm?:(Thanks shoorick)
1.push "add" -> new line added and recieves a focus at first column.
2.press tab -> next column same line get focus.
3.press enter or tab in last column -> complete adding, button "add" get focus
This will give ability of fast adding a large stringlist without touching a mouse or any other extra moves (we are too lazy, yeah) 

 
V3.0.2.4
--------
-New CodeHi (should improve scroll of long lines)
-New option: Show Scroll tips
-Commented lines starting with ; now show tab indicators(blues,JimG,QvasiModo)
-Open/Save dialogs should be resizable(Thanks JimG). Also, new style and not always centered.
-May we have an option to desactivate the gradient in the menu's ?(Thanks PhoBos)
-Open Project & Save Project As add entry in recent documents
-replaced many wsprintf with BinToDec or hardcoded values hence:
	-Smaller code
	-Faster code
	-Faster WinAsm Studio exit
-If the resource script has no "END" at the end, switching editor into visual mode hangs IDE. I met this pasting script from example at the web-page. It would be good to prevent such situation.(Thanks shoorick)

-
ppAddInsFrameProcedures				DWORD ?		;Point to pointer to AddInsFrameProcedures list
ppAddInsChildWindowProcedures		DWORD ?		;Point to pointer to AddInsChildWindowProcedures list
ppAddInsProjectExplorerProcedures	DWORD ?		;Point to pointer to AddInsProjectExplorerProcedures list
ppAddInsOutWindowProcedures			DWORD ?		;Point to pointer to AddInsOutWindowProcedures list
are now exported to Add-Ins (Thanks PhoBos, Qvasimodo)


V3.0.2.3
--------
-For New menus:
	-Menu ID				:1000
	-first Menu item Name	: IDM_
	-First Menu item ID		:1001
	-Editing caption of last menu item, add a new menu item at the end(Thanks JimG)
	
	
-New menu items auto increment ID(Thanks JimG)


-Redo works with Ctrl-Y but is not shown as a hotkey on the menu(Thanks JimG)
-when I want to select several controls, I have to press CTRL and click on each control , can you make it like VB ?, it draws a square and whatever control the square touches it gets selected when I release the mouse button(Thanks Jnrz7)
-Auto Toolbox/Dialog Windows change of options name (Thanks JimG)
-F3 for the next search should hide tooltip and any intellisense lists visible (Thanks cbcrack) 
-XP built in 16-bit debugger could not be launched (Thanks kkiawgah)
-Consider searching down with all selected. After you reach the last existing item, dismissing the "specified region has been searched" message, the next time I hit f3, I assumed it would wrap around to the top and continue searching, just as it does when you hit find next in the dialog box for the toolbar search. Does that make sense?(Thanks JimG)
-If a valid (and available during design time) class is set for a UserDefinedControl, then the actual control is displayed.
 

V3.0.2.2
--------
-Autocomplete when pressing comma ( , ) when invoking procedures (Thanks cbcrack) 
-A bug regarding the "Save Text To File" option fixed(Thanks JimG)
-New Menu(OWNERDRAW): Dialog-->available to Add-Ins(Thanks DarkSoul)
-Selecting an external file from the window menu always displays that file (some small bug fixed). If it  is an rc file, now it does not switch to/from Visual Mode.
-New Menu(OWNERDRAW): "Dialog" now used as the Context menu of the resource editor;Now available to Add-Ins(Thanks DarkSoul)
-Updated WAAddIn.inc
-RC Options docking window renamed to Dialog(Thanks JimG)
-WS_CLIPCHILDREN not set by default for new dialogs(Thanks redox)
-Tool -> Options -> Colors: You should take as Text Color the inversed selected Background color this would make it more readable if the user selects darker colors like darkblue or black as background color.(Thanks JimG, DarkSoul)
-In the "Colors" tab could we have a method of storing color schemes. Functionality for the schemes could be given as: "New", "Restore Defaults", "Save" (d-uh !)  Save would be necessary because...if we change a color but don't like it...so we just press "Cancel" !!!(Thanks shantanu_gadgil)
-ToolTips and Tab Indicator share the same color, could you make it 2 different options, because I use a light yellow for the ToolTips and I can't see the Tab Indicators. I would like to set the Tab Indicator color to black.(Thanks Jnrz7)
-Once I have added a shortcut to an item, how do I get rid of it?  Even though I go to the shortcut box and delete it until "none" shows, the "none" doesn't stick no matter what I do.(Thanks JimG)
-Save states of "Show/Hide Grid" and "Snap To Grid" and Grid Size on WinAsm Studio exit.(Thanks JimG)


V3.0.2.1
--------
-Cut, Copy, Paste for resource editor(Thanks Marwin)
-Toolbar Control buttons sometimes shown disabled.
-Add-Ins now loaded before main window is shown
-Two new HANDLES structure members available to Add-Ins
	phImlNormal		DWORD ?
	phImlMonoChrome	DWORD ?
-New message available to Add-Ins:
	WAM_ENUMEXTERNALFILES		EQU WM_USER+105	;hWnd	=	hMain
												;wParam	=	pointer to EnumProc
												;lParam = 0

-SetImages Add-In

-Test Dialog
	-Tabstops should work, invisible controls not shown, correct position at start up. Use X button or Alt+F4 to return to WinAsm Studio.

-Some control captions mixed up;fixed (Thanks Jnrz7)



V3.0.2.0
--------
-New Version of CodeHi
-Drag & drop text (Thanks DC, Qvasimodo,c00p,blues)
-A mouse click in the selected area now deselects it and places the caret(Thanks blues)
-Normally, after highlighting a string and clicking on the search icon in the toolbar, the search dialog correctly uses the highlighted string as the "Find what" string. However, if this was a string seached for some time in the past, the string that was searched for the last time, rather than the highlighted string is used for the "Find what" string. (Thanks JimG)
-Tab,Enter,Space while intellisense list is visible-->AUTOCOMPLETE(Thanks JimG,shantanu_gadgil,Marwin)
-New menu item: Find Previous (Shift+F3). Also, if search direction is ALL, F3 searches down then over(Thanks JimG).
-When Find dialog is fired for the first time AND there is at least one entry in [FIND] section of WinAsm.ini then Find did not work until combo selection changed (by either selecting an item or editing it)
-MOUSEWHEEL support for RCEditor (Hodling Ctrl down scrolls horizontally)
-Sometimes AutoToolAndOptions caused Toolbox and RC Options Docking windows to show when WinAsm Studio was about to close


V3.0.1.9
--------
-Rename the "Auto clean" option as "Auto clean after make"(Thanks Qvasimodo)
-Ctrl+U,Ctrl+L,Ctrl+T for convert case
-Bug fix: Dialogs/controls caption not displayed properly in some cases



V3.0.1.8
--------
-Tools-Options-General-Auto Clean: Delete Intermediate files to automatically have the intermediate files deleted after Make-link and Make-Go All (Thanks JimG, Qvasimodo)
-Improved RC files bitmap
-Window styles now display WS_VISIBLE.(Thanks DITREX,rubs)
-Changing "Visible" property, adds/removes WS_VISIBLE flag from Window style
-Adding/removing WS_VISIBLE flag, changes "Visible" property
-If errors during make, WinAsm Studio crashes (WinXP)-(Thanks DITREX,blues)
-About Dialog:Hyperlink to WinAsm Studio forum
-Ctrl+E Open Files
-Open Project toolbar button now Dropdown with Open Files(Thanks cmax)
-I think it will be more comfortable if the text will immediately appear on the
 dialog's caption, or button, static control...while I'm typing. So I dont need
 to press enter anytime to see where it is on the dialog, or control... (Thanks santa,Manos)
-Updated API files
-Added TBSTYLE_FLAT,TBSTYLE_TRANSPARENT,TBSTYLE_REGISTERDROP,TBSTYLE_CUSTOMERASE,TBSTYLE_LIST toolbar styles to the resource editor.
-RC Editor Back Color is not hardcoded any more(Thanks JimG)
-Project Tree colors change now reflected to dialogs tree, others tree and Properties list
-"INS" idication changed to "OVR" (Thanks blues)
-Toolbar buttons on AddRes Toolbar are now disabled at WinAsm Studio start up.
-Add New Dialog on AddRes Toolbar (Thanks andrew_k)
-No assembling or linking if no asm file exists (New Error message)-(Based in Masmer's feedback)


V3.0.1.7
--------
-At TVN_BEGINDRAG of ProjectTree, change active MDI child
-Do not invoke DeleteObjResExpFiles after IDM_MAKE_LINK and IDM_MAKE_GO
-Modules (Switch on the fly->much faster assembling && modular programming) (Thanks bigrichlegend, golemxiii, Bi_Dark)
	-Make->Assemble:
		-First ASM always assembled
		-Modules are assembled only if bin is older than source
		
	-Compile RC

		-Do not convert rc to res if res is older than rc
		
	-A sample of modular programming is included

-Mouse RightDown on DlgProc does nothing if capture otherwise, on Mouse right up drawing rectangles did not erase.
-EnumProjectItems make smaller.
-EnumProjectItemsExtended make smaller.
-Toolbar Button to toggle Visual mode(Thanks JimG, PhoBos)
-More ES_ styles. Also, distinguished those for edit controls with those of RichEdit controls (Thanks Drmres,JimG,Qvasimodo)
-Progress bar styles (Thanks blues)
-Several TreeView styles added to resource editor (Thanks Qvasimodo).
-If we are after a "Option Proc" line then we are NOT in a procedure
-No autocomplete for "Option Proc"
-WS_VISIBLE flag not set for new dialogs/controls (Thanks rubs)
-Any File can be added as RCDATA (Thanks andrew_k)
	-Demo included
-Invoke UpdateWindow,hClient in AskAndDestroy procedure after destroying every mdichild (much better)
-Improved Add-Ins Manager image
-New Make Option:Clean
-WAAddIn.inc updated



V3.0.1.6
--------
-Dialogs/Controls of RC are now using a common focus rectangle routine with Docking windows
-Improvements for replace option
-Find Dialog new option: "Current Project" (Thanks andrew_k, DC)
-New strings in the Find Combo are added to the begining (not at the end)
-Save the list of FIND words that we may be using to a file so that when we shut down and restart Win32ASM we will have our previous FIND list ready to go-20 most recent entries are saved(Thanks cmax)
-Under cirtain circumstances, multiple min/max/close buttons and toolbox and rcoptions docking not shown(Thanks qvasimodo)
-Existing files not modified are not saved now. This
	a)will prevent change of the "Modified date" of files
	b)Very much faster project saving and thus faster "Make"
-Tooltips are now a bit longer(Thanks Qvasimodo)
-Right-clicking on the DialogsTree when there was no Dialog in the RC file, cuased a crash unser Win2K(Thanks thierry)

V3.0.1.5
--------
New message for Add-Ins:
	WAM_OPENPROJECT	EQU WM_USER+104	;hMain,wParam=lpProjectFileName, lParam=reserved

V3.0.1.4
--------
-Find Dialog: New option:"Direction-All" (Thanks andrew_k, DC)
-In WM_SYSCOLORCHANGE: SetBandColors(Thanks PhoBos)
-MOV wc.hbrBackground,COLOR_BTNFACE+1 for docking windows otherwise problem due to MENUBAR color not changing when switching from an XP Theme to a Classic one(Thanks PhoBos)
-Ln, Col & Sel indications are now displayed in real time and not in WM_TIMER of MainWindowProc (Thanks Marwin)
-Owner Drawn menus minor vertical change of caption drawing (Thanks PhoBos)
-Ctrl+F3 Smart Find finds next occurence of selected text(if any), otherwise next occurence of current word (Thanks PhoBos)
-Invoke ClearProject and then (not before) Invoke EnableDisableMakeOptions in IDM_CLOSEPROJECT
-Images (Thanks PhoBos) for	:	IDM_CONVERTTOUPPERCASE
							:	IDM_CONVERTTOLOWERCASE
							:	IDM_PROJECT_ADDEXISTINGFILE
-[EBX].NMHDR.hwndFrom now works (The problem was "." before NMHDR
-Add Files button on main Toolbar (Thanks cmax)
-Run command works irrespective if there were errors or warnings during build(Thanks Qvasimodo)
-some issues when WS_EX_TRANSPARENT was used fixed (Thanks Qvasimodo).
-Procedures list should not display macros and structures; fixed (Thanks Qvasimodo).
-asm and inc files new optional style: Tab Indicators.
 From Tools-Options-Editor enable/disable and from Colors-Tooltips & Tab Indicators (Thanks Qvasimodo)
-New version of CodeHi that supports Tab Indicators style.
-Splash was not shown; fixed
-Spalsh asks for seggestions in the forum; not my email
-Docking Windows Focus rectangle Improvements


-WAM_GETCURRENTPROJECTINFO message always (no matter what FullProjectName(0) is) fills CURRENTPROJECTINFO structure members(Thanks Qvasimodo)
-New member of CURRENTPROJECTINFO structure: pszProjectTitle(Thanks Qvasimodo)
-WAM_ADDOPENEXISTINGFILE		EQU WM_USER+103	;hMain,wParam=lpFileName, lParam=TRUE/FALSE(True to Add File to the current project, False to Open File external to the current project(Thanks Qvasimodo)


V3.0.1.3
--------
-Replaced
	Invoke MoveWindow, hRebar, 0, 0, Rect.right, Rect.bottom, TRUE
	with
	Invoke MoveWindow, hRebar, 0, 0,Rect.right,22, TRUE
	In clientresize (removes flicker from Project Tree)

-Invoke LockWindowUpdate,hClient from WM_MDIACTIVATE for MDI Children (removes flicker from Project Tree)

-CS_HREDRAW OR CS_VREDRAW removed for the class of WinAsmHandles.hMain

-Current line and column on the status bar(Thanks Marwin). Also number of selected characters.

-	.ElseIf uMsg==WM_LBUTTONUP
		Invoke SetTimer,WinAsmHandles.hMain,200,200,NULL
	.ElseIf uMsg==WM_LBUTTONDOWN
		Invoke KillTimer,WinAsmHandles.hMain,200
	in docking window procedure so that Status bar is not updated during movement of focus rectangle because it is partly erased when on top of status bar.

-You could also display the status of the insertion-key (overwrite/insert) in the status bar(Thanks Marwin)

-Format->Convert to UPPERCASE/lowercase/tOGGLE cASE(Thanks andrew_k, shantanu_gadgil)

-Double clicking on a RC File that is not in Visual Mode does not convert it to Visual Mode otherwise multiple mix,min,close buttons.	
	


V3.0.1.2
--------
-Dialogs/Others tree view height problem when Project explorer window height was smaller than Dialogs tree height.
-Others tree view height problem.
-Structure members list not shown if no space or tab before structure name
e.g. MOV EAX,Rect.left <------Problem
e.g. MOV EAX, Rect.left <------OK
e.g. .If EAx==Rect.left <------OK
e.g. .If EAx=>Rect.left <------OK


-Invoke DefMDIChildProc,hWnd,uMsg,wParam,lParam in WM_MDIACTIVATE;Let's hope it helps for the multiple min/max/close buttons
	Also in ProjectTreeSelChange
	.If !EAX && OpenChildStyle ;i.e. not visible
		Invoke SetWindowPos,EBX,HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW
		Invoke SendMessage,hClient,WM_MDIMAXIMIZE,EBX,0
		
		Instead of
		;Invoke ShowWindow,EBX,SW_MAXIMIZE

-Comment/Uncomment,Increase/Decrese indent proper behaviour (Thanks Qvasimodo, Marwin)
-Tab to spaces bug fixed(Thanks Marwin)

-In Options Dialog now images are used for ToRecycled/FromRecycled buttons.
-Moving a Floating window caused some flickering; Removed. (Thanks Manos)



V3.0.1.1
--------
-The Toolbox/RC Options docking windows state is not set automatically to undocked.
-Properties list buttons now show/hide with LVN_ITEMCHANGED
-Properties list width, second column width, buttons position better calculation (Thanks Qvasimodo)
-Keywords & Recycled listboxes now have WS_HSCROLL style (Thanks shantanu_gadgil)
-It would also be nice if you can delete by using the Del-key in the Tools Manager too.(Thanks Marwin)
-Resources context menu now shown only if right click is on dialogs tree (not anywhere on project explorer)
-Double clicking on Styles/exstyles/font row of properties list is like pressing the corresponding button(Thanks Marwin) 
-Pressing Enter in a properties list item starts the appropriate action (Thanks Marwin)  
-Double-clicking on "Included Files" and "Resources" lists simulates pressing Browse button.(Thanks Marwin)
-Also, for the OUT:\ field in the Project Options, I name the debug executable by adding a "D" at the end (i.e. Chimes.exe would be called ChimesD.exe). Anyway, renaming the output executable causes problems when Building All and when invoking the debugger (looks for Chimes.exe not ChimesD.exe). I guess this isn't a big problem as maybe only a few people separate debug and release executables via renaming. But I thought I would ask if this could be looked at when you have the time and interest.(Thankss Masmer)
-Some minor improvements on the Button & tab Control images of the toolbox

-Full package Additions:
	-RedStub V1.0.0.1 (New)
	-Two DOS Templates
	-Updated WAAddIn.inc
	-Some updated templates by shantanu_gadgil
	

V3.0.1.0
--------
-Removing a file from the project, caused double max,min and restore buttons on frame window for mdi children.
-The "Keywords" color TAB is excellent !!! Keep it up !!! A problem though. The "C1(Resource)" Keywords listbox is not wide enough(Thanks shantanu_gadgil)
-Make Options now split into three tabs:Resource Options, Release Options, Debug Options.
-Make-Set Active Build (Release/Debug)(Thanks Greg,Masmer,SOL_bl)
-Loading a project should be faster now.
-Faster & smaller Grid painting(Thanks Manos)
-Pressing X of a maximized RCEditor window caused double max,min and restore buttons on frame window for mdi children.(Thanks Gary McAvoy)
-You can now deselect menu for dialogs and bitmap/icon for image controls(Thanks Marwin) 
-Small bug fix: After Closing Project the project name stayed in the caption bar.(Thanks shantanu_gadgil)
-If there was no caption for UserDefinedControls, it was changed to IDName(Thanks Qvasimodo)
-Toolbox and RC Options Title style (gradient/single line/double line) was not saved on Application exit.(Thanks Marwin) 
-double max,min and restore buttons on frame window fixed.(Thanks Tomasz,Relic,Qvasimodo,shantanu_gadgil,Gary McAvoy)


V3.0.0.9
--------
-There is no way to switch to/from visual mode when you double click on an RC file from Explorer.(Thanks Qvasimodo)
-When you click "Add" in "Included Files" and "Resources" dialogs the browse dialog now opens automatically(Thanks Marwin) 
-Included files, Resources dialogs:
	-Delete one line with del Key (Thanks Marwin)
	-Various improvements with list focus 
-String Table Dialog: Delete one line with del Key (Thanks Marwin)
-If only one *.wap file is dropped then the project is opened(Thanks Marwin) 
-Support for DOS Projects(thanks riadh)
-The following controls do not have caption text now: list box, horizontal scroll bar, vertical scroll bar, tab control, toolbar, status bar, progress bar, tree view, list view, slider, rebar, up-down, shape (Thanks Qvasimodo)
-The up-down controls now have their specific styles.(Thanks Qvasimodo)
-WS_GROUP now not available for dialogs. Now it is available to all controls(Thanks Qvasimodo)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.8b
--------
-Menu item shortcuts were not saved(Thanks santa)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.8
--------
-Add/Edit/Delete Resources toolbar always available if there is an RC File in Visual mode open. Also Grayed bitmaps are used(Thanks Forever, Marwin).
-remove button on Resources tab can also be used to remove dialogs/controls as appropriate now.(Thanks Marwin)
-If Auto Toolbox/RC Options is enabled now made to work in all appropriate cases (Thanks Marwin, Qvasimodo, TheOne)
-right-clicking on the dialogs tree selects the appropriate dialog/control and popups the context menu(Thanks Marwin)
-This context menu:
	-has more options: Style, ExStyle for dialogs/controls plus Font or dialogs for even easier access (based on similar requests by Marwin)
	-Send To Back/Bring To Front are disabled if Selection is a dialog (i.e. not a control)

-A rebar resize problem fixed(Thanks PhoBos)
-Invoke SetClipChildren,TRUE whenever Active Dialog changes so that flicker is removed when resizing app main window
-Window-Close All was not disabling ToolBox/RC Options toolbars.
-Invoke SetClipChildren,TRUE after setting the dialog font so that flicker is removed when resizing app main window
-Docking windows are now positioned exaclty as they were before App closes.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.7
--------
-Now you can select dialogs/cotrol(s) by right clicking on them too.(Thanks Marwin)
-The .exp files are now deleted after a dll project is built.(Thanks Qvasimodo)
-CodeHi control update 1.0.5.0; As a consequence:
 -a.Syntax hightlight for dec and hexadecimal numbers(Thanks maCo)
 -b.Tabs are indicated with | ;I disabled it!!!!!!!!!!
-slight changes to cut & replace images
-WS_DLGFRAME was inserted automatically;fixed(Thanks PhoBoS)
-Combo box is recreated after style changes(Thanks Qvasimodo)
-shape is recreated after style changes,move/size from properties list.
-Double clicking on the project tree to open rc in visual mode or choosing IDM_PROJECT_VISUALMODE
 is now flicker free (Invoke LockWindowUpdate,hClient is used).
-#Define NAME NUMBER;Now allows negative numbers too.(Thanks golemxiii)
-...compatibe...---->...compatible... message string spelling mistake(Thanks Gary)
-Opening an RC file from the command prompt doubles all resources.
-If LAST menuitem's level is 2 or greater-->crash for xp (Thanks golemxiii)
-relative paths for included files in resources.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.6
--------
1.String Table:Edit control ES_AUTOHSCROLL always and ES_NUMBER style for ID field.
  Also EM_LIMITTEXT=31 for IDName, 10 for ID, 127 for string
2.-Included Files changes set the Modified flag of the resources properly.
  -Under certain circumstances, String Table changes were not saved to the script.(Thanks Loveasm,BKSY)
  -Under certain circumstances, Resources Table changes were not saved to the script.
  -Under certain circumstances, Accelerator Table changes were not saved to the script.
  
3.Now View Menu "&ToolBox" and "&RC Options".
4.New File (Thanks Bi_Dark).
5.Closing a project was setting hRCEdtorWindow=0. Wrong! There may be an external RC File in visual mode!
6.Grid Background color is now correct even when XP Style themes are used.
7.Proper Docking windows backcolor when XP Style themes are used (Thanks Qvasimodo)
8.Click on "Open project". Enter the name of an existing file, but not a project, but of any other type. WinAsm will try to open it as if it was a project file, and will not report an error.(Thanks Qvasimodo)
9.When extracting resources there is a warning if something is not supported:
  Any resource that follows is not going to be extracted (Thanks Qvasimodo)
10.WS_THICKFRAME not shown in Dialog Styles List; Equ to WS_SIZEBOX (Thanks Qvasimodo)
   WS_ICONIC not shown in Dialog Styles List; Equ to WS_MINIMIZE
   WS_TILEDWINDOW not shown in Dialog Styles List; Equ to WS_OVERLAPPEDWINDOW
11. DS_3DLOOK not shown in Dialog Styles List; Obsolete, has no effect (Thanks Qvasimodo).
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.5
--------
1.features parameter of WAAddInLoad Procedure now points to a FEATURES structure-see WAAddIn.inc. (Thanks Qvasimodo).
 Use it as follows from your Add-In:
	.If features
		MOV EAX,features
		MOV EAX,[EAX].FEATURES.Version
		;Now EAX is 3005 for the current version
	.EndIf

2.The "Save" toolbar button and "File-Save File" are now enabled or disabled as appropriate even for Resource files in Visual Mode (Thanks Qvasimodo)
3.Trying to close WinAsm Studio it finished loading, causes a GPF.(Thanks Qvasimodo)
4.Using RCOptions, RCModified was not set to true.
5.Signed ID,Left,Top values are now supported(Thanks Qvasimodo)
6.WS_CLIPCHILDREN style not set by default for new Controls(Thanks Qvasimodo)
7.WS_CLIPSIBLINGS style not set by default for new Dialogs(Thanks Qvasimodo)
8.Toolbox/RC Options are autoshown if a control/dialog is selected from the Dialogs Tree
 and the 'Auto Toolbox/RC Options' is enabled.(Thanks Marwin)

9.Proper handling of escape sequences for caption.(Thanks Marwin)
\a	->Char 7
\n	->0Ah (New line)
\r	->0Dh (Carriage Return)
\t	->Horizontal tab 
\\	->Print a backslash

Not Supported:
--------------
\xhh (should display equivalent character e.g. \x20=32decimal should display a space)
\oo

""	->"(Qvasimodo) (for Caption)
-Proper handling of double quotes in dialog/control caption.(Thanks Qvasimodo)

10.Proper Update of Controls when they move/size(Thanks Marwin,Qvasimodo)
11.After changing the Style of a dialog now size is recalculated.
12.External resource filenames use / instead of \.(Thanks Qvasimodo,cu.Pegasus)
13.Accelerators for Comment(F2)/Uncomment(Shift+F2)(Thanks Marwin)
14.Navigate via TAB-key in the dialogs "Project properties","Go To Line","Options" (Thanks Marwin)
15.IDName Edit allows only alphanumeric and '_' characters.
16.Deleting a dialog/control(s) didnot update the Properties list.(Thanks Manos)
17.Even number of " for Caption and Class in edit box.(Thanks Qvasimodo)
18.Right-Click on the editor while Ctrl is pressed now pop ups Format menu. If Ctrl is not pressed
   the Edit menu popups(Thanks BerniR for similar request)
19.Close project does not ask to save Project changes.

20.New Project-Build or Save Project, but do not save the asm file.
   On closing WinAsm will not prompt to save it.(Thanks Qvasimodo)
21.Trying to open a RECENT project does not ask to save Project changes.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.4
--------
-Properties List Editbox now narrower by 4 pixels
-Tools-Options-Auto Toolbox/RC Options. (Thanks Marwin,The One)
-Closing WinAsm whilst properties list is in edit mode -->crash
-Auto increment of the dialogs/controls ID's(Thanks Jnrz)
-Gray the buttons of RC Options when active mdi child window is not rc file rarely not working as intended
-.ElseIf uMsg==WM_DESTROY was not in the proper place of the ProjectExplorerProc
-When creating a new project the project properties are not set correctly.(Thanks Qvasimodo)
-Static text controls now support the SS_CENTERIMAGE style. It causes text to be centered vertically.(Thanks Qvasimodo)
-LVS_TYPEMASK,LVS_TYPESTYLEMASK,LVS_ALIGNMASK are not styles->removed(Thanks Qvasimodo)
-IDC_DLG changed to IDD_DLG for new dialogs(Thanks Qvasimodo)
-Styles dialog takes into account the WS_VSCROLL style of the list to set the width of column 0.
-First Dialog is not shown in the Dialogs tree unless a new dialog or control is added after.
-If WinAsm has been set to use the SystemTray when minimized it will not remove its icon when the user right-clicks and selects Exit from the menu.(Thanks Richm)
-Project menu (context menu on Project tree) new item:Switch from Visual Mode to text mode and vice versa
(Thanks thomasantony,Stoby,Manos,Qvasimodo)
-Moving a CBS_DROPDOWN or CBS_DROPDOWNLIST combobox was changing its height unnecessarily(Thanks Qvasimodo) 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.3
--------
-In IDM_WINDOW_CLOSE I simply (better and smaller): Invoke SendMessage, hClient, WM_MDIGETACTIVE, NULL, NULL && ---> Invoke SendMessage,EAX,WM_CLOSE,0,0
-Window-Close all: Close all MDI Children(Thanks Stoby)
-BS_FLAT (Thanks PhoBos)
-When right-clicking in a dialog neither "Show/Hide Grid" nor "Snap To Grid" works.(Thanks Marwin) 
-The cursor is changed to a cross when user is creating a new control(Thanks Manos)
-crash if selection bigger than 255 chars and then Find dialog is created. 
-Sometimes menus/toolbar buttons not enabled when they should
-pProjectType is exposed to the Add-Ins via CURRENTPROJECTINFO Structure.
-Close Project(Thanks WinCC, Stoby)
-When the ID of a control is changed it is not reflected in the Dialogs Tree.(Thanks Jnrz)
-A file can only be added once into a project.(Thanks Nùcleo)
-Hiding the RCParent window removes selection from the Dialogs/controls tree.(Thanks Manos)
-Adding a new rc file caused a gpf if Add New Dialog was pressed (if the rc file was in text mode).(Thanks Mieuws)
-Gray the buttons of RC Options when active mdi child window is not rc file.(Thanks Marwin,Jnrz)
-Remove the RCEditor file from project-->crash
-Replaced all RET with JMP NoDefFrameProc in MainWndProc
-A new or existing RC file added to a project is initialized in Visual
 mode if no other RC file is already in visual mode. Also Opening an external
 RC file initilaizes in Visual mode if no other RC file is already in visual
 mode  (Thanks Mieuws).
-Project menu does not enable/disable items in some cases.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.2
--------
1.The gotoline dialog box now has "Extend selection" option, meaning the user can enter a line number, click the checkbox and the area of selected text is extended to that line.(Thanks andrew_k)
2.Autocomplete structs and macros.(Thanks andrew_k)
3.Project Properties dialog;painting bug (Thanks Marwin, Nùcleo)
4.VK_SPACE is missing in the list of keys of accelerator dialog (Thanks thomasantony)
5.Now even if spaces or tabs before '.' the structure member lists are shown
6.edit control on properties list ES_AUTOHSCROLL (Thanks thomasantony)
7.edit control limit text to 240 chars for caption, 31 chars fot all the rest.
8.assume  esi:ptr PROCESSENTRY32
  mov     [esi].Intellisense (Thanks cu.Pegasus)
9.Current Project Info exposed to Add-Ins (Thanks PhoBos)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.1
--------
1.Image Controls do not allow these styles (ECX>=SS_BLACKRECT && ECX<=SS_WHITEFRAME) || (ECX>=SS_ETCHEDHORZ && ECX<=SS_ETCHEDFRAME) || ECX==SS_OWNERDRAW || ECX==SS_USERITEM || ECX==SS_SIMPLE || ECX==SS_CENTER || ECX==SS_RIGHT || ECX==SS_NOPREFIX || ECX==SS_LEFTNOWORDWRAP
2.Shape Controls do not allow these styles ECX==SS_ICON || ECX==SS_BITMAP || ECX==SS_OWNERDRAW || ECX==SS_USERITEM || ECX==SS_SIMPLE || ECX==SS_CENTER || ECX==SS_RIGHT || ECX==SS_NOPREFIX || ECX==SS_LEFTNOWORDWRAP || ECX==SS_CENTERIMAGE
3.Static Controls do not allow these styles ECX==SS_ICON || ECX==SS_BITMAP || ECX==SS_CENTERIMAGE || (ECX>=SS_BLACKRECT && ECX<=SS_WHITEFRAME) || ECX==SS_USERITEM || (ECX>=SS_ETCHEDHORZ && ECX<=SS_ETCHEDFRAME)  
4.Structure Members List appear just after pressing "." now. Thanks Qvasimodo
5.Structure Members List did not disappear in Invoke lines after certain circumstances.
6.Find Dialog Find Combo and Replace edit controls are now wider. Also Combo is CBS_AUTOHSCROLL (Thanks andrew_k)
7.Info bar on Find/Replace Dialog (Thanks andrew_k)
8.Wav Files can now be added to the resources
9.Some Link Errors were not detected;Fixed (Thanks andrew_k)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.0 Final
---------------
1.The ListBoxs of Virtual Combos are now positioned above Combo Button if screen height is less than Listox's bottom
2.UpdateWindow if user uses very quickly the Splitter on Dialogs Tab.
3.Accelrator dialog was hidden if combo button was pressed after the virtual combo on the preoperties list was used.
4.A Virtual combo for Images on the properties list.
5.Change Image for control after selecting from the combo above.
6.Better handling (source code) and placement of buttons on the properties list.
7.relative path is saved for resources(Thanks thomasantony)
8.<-> cursor when trying to drag on Project Explorer fixed.
9.Resources list on start up. Last column width according to whether WS_VSCROLL.
10.Combo for Visible:TRUE/FALSE (Thanks Manos)
11.The Change of a control/dialog name was not reflected to the Dialogs/Controls tree(Thanks Jnrz)
12.when I move 2 or more controls at the same time, they dont refresh correctly sometimes and wierd lines appear (Jnrz)
13.Now name of image (instead of ID) is shown (if there is name of course) in the properties list. 
14.Resources Table: ID Edit box now accepts only numbers.
15.If a docking window was floating and user is moving it, right clicking should not pop up context menu. Also weird lines stay on the screen
16.Left,Right,Up,Down arrows move ALL selected controls (Thanks Jnrz)
17.Left,Right,Up,Down arrows while Shift is pressed increse/decrease width/height of ALL selected controls (Thanks Jnrz)
18.Send To Back/Bring To Front is now reflected in the script to be saved (Thanks Bi_Dark) 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Visual ASM V1.0.0.0
-------------------

This Visual IDE is for programmers using the Assembly Language.
A lot of effort has been done to avoid any bugs but..."99% of 
the time 99% of all the software is correct". So I would be very
greatful if you could send me any bugs you find so that this IDE
become better. Please be strict!


I know that this IDE is quite far from the term "Visual" and many
features are needed to verify this term. Please send any suggestions.

Quick Start:

-To start a new project select "New Project", and from the dialog
choose the appropriate "Project Type" and the "Make Options" (You
can change these later, if you want from Project-->Properties). A new
project is created with one file (untitled.asm). You can add (new or
existing) or remove files from the "Project" menu.

-You are not allowed to save files with names Untitled.* since these
are used by Visual ASM when creating new empty files.
------------------------------------------------------------------


Version 1.0.0.1
---------------
[1.Select Procedure Combo:	a)"Select Procedure" scrolls now to the top
							of the current file.
							
							b)When selecting a procedure the first line
							of this procedure is the first
							visible line.]

[2.New category in Project Tree: Batch Files which you can execute by
selecting "Run Batch File" from the Project menu.]

[3.Improved support for Command line and *.vap file association.]
------------------------------------------------------------------

Version 1.0.0.2
---------------
1.Syntax Files.

2.Project Properties disables the current hFind Dialog.

3.CTEXT("D:\VisualASM\VisualASM.ini")

4.When Keyword file changed, all files updated.

5.Separate TextBox for /OUT. If this is not empty the
 Execute command looks for the file and the path
 specified here otherwise an executable file the name
 of which is the same with the project title which resides
 in the Project directory.
 
6.Fix the TranslateMDISysAccel(should use hClient, not WinAsmHandles.hMain).

7.Shortcut keys to more menu items.

8.Remove TreeView items when they are not needed.

9.Fonts.

10.Colors.

11.Options Dialog is now modal.
------------------------------------------------------------------

Version 1.0.0.3
---------------
1.Set a Help File (F1 for word under caret) in General Options.

2.EnumTreeItems: Uses EBX ----> Problem in NT.

3.szColorTemplate DB "%#08lx",0 (and not "%#08lX",0 -----> Problem in NT).

4.GetSettingsFromIni (Choose better place--->within the timer).


5.Project Tree Colors.

6.Tab Size.

7.Auto Indent.

8.Expand tabs to spaces.

9.Update to new Code control Version 1.0.1.5

10.Minor bug:correct Project type was not selected in project properties.

11.No animation when double clicking on a child window's title bar.

12.Output Window Colors same with Editor Colors.

13.Save Font Size.
------------------------------------------------------------------

Version 1.0.0.4
---------------
1.In OutParentProc "DefMDIChildProc" was used instead
  of "DefWindowProc".
  
2.Output window semi-readonly. Hilites line user double clicks.
  Go To Error.All Errors marked after make. All Errors cleared
  before new make. Output window cleared for new or open existing
  projects. Total Number Of Errors is displayed(red or green).
  If any errors do not execute executables.
  MASM :, LINK :, RC :,CVTRES : errors not counted.
  
  Masmer: I'd still like to see a way of automatically assembling/linking
  updated files in the project without editing the Make options
  or adding a created batch file.

3.Indent - Comment improved (when space instead of TAB outdent did not work)

4.Comment Blocks support.

5.Output Window made higher.

6.User Selects binary path. The Make properties of all projects must be
  updated. (Masmer)

7.Project Tree Drag and Drop.Perfect!

8.Line Number Column Width Customizable.
------------------------------------------------------------------

Version 1.0.0.5
---------------
1.Different Keywords for ASM & INC, RC, BAT Files

2.User selects Include and library path.

3.Bug Fix:When Error in line 1 then the error not taken into account.

4.Options Tabs much smaller.

5.Properties Tabs much smaller.

6.Changing the order of files in the project tree is considered
  as a change of the project.

7.Make options rework. Check for Definition File if project is DLL.
  Fix for ANY type of new project. If no ASM and no RC files, then
  link, go all and execute is disabled.
  
8.Speed Of light Project Loading (Hide-Show Client & WM_SETREDRAW for project tree)

9.User selects api functions file and api structures file (on the fly).

10.LTrim spaces for RCToObj and /OUT: commands.

11. Enter, space, tab, insert procedure if list has the focus
	Multiline Procedure declaration supported.
	Selection when selecting from the list can be anywhere.
	Requirement:Parameters considered from the first that its
	type is known.
	Comments,spaces,tabs removed.
12: List with Structures after : at a 'Local' line

13. No application window looses focus when any list has got the focus.
------------------------------------------------------------------

Version 1.0.0.6
---------------
1.Find (match case) bug fixed, Replace improved (Masmer), Replace All
 bug causing Visual ASM to hang fixed(Masmer). 

2.Bug Fixed:When procedures are collapsed, procedure combo does
  not scroll RAEdit correctly(frankies).(REM_VCENTER modification
  of RAEdit and small change in Visual ASM).

3.API Functions AND API Structures are now coloured (All case
  sensitive except those few starting with a small letter-
  I will suggest to KetiIO).

4.Procedure Combo reduced flicker when typing.

5.Focus of main window child windows dialogs is now perfect. (Also
  project explorer looses focus when any other dialog of the IDE
  gains focus).

6.Improved support for Function Tooltip position.
------------------------------------------------------------------

Version 1.0.0.7
---------------
1.Left & right arrows hide Functions and Structures list.
  Escape,Up,PgDown,PgUp hide Structures list too (not only
  Functions list).Enter hides Functions list


2.Some minor Tooltip position fix for long Functions.

3.INC files subclassed, Enumerate their procedures, divider lines,
  Procedure combo visible.

4.CTRL_SPACE popups Structures List.

5.Local xxxx: activates Structures list only if we are in a
  procedure.
  
6.Upgrade edit control to V1.0.1.8. Now problem with not painting
  last character after autohscroll is solved. Also ALL API case
  sensitive.

7.If we are between EndP and Proc then we are not in a procedure.

8.Pressing enter at the start of a procedure, the combo was fucked.

9.EM_POSFROMCHAR bug in RAEdit--->changes in Visual ASM for PopUps.




10.Pressing Enter completes Procedure skeleton.

11.API Constants List (constants are keywords ->coloured (case sensitive).
   Use as many parameters as you wish (e.g. ws_ex.... or ws_ex......)
   (Type at least one character to see list),Tooltip is still shown.
   
12.Tooltip & Procedure list not displayed WHEN (CTRL+C?).Functions
   with no parameters tooltip position fixed.

13.User selects api constants file on the fly.

** Minor Improvements to V1.0.0.7
---------------------------------
1.When Opening Project bring first ASM File on top.

2.Constants List vertical auto size and auto column width(both on the fly)

3.API Structures and functions column width takes the list's VScrollbar
  width into account when Visual ASM starts.

4.Bug Fix: API Constants List was not hidden when Editor looses focus.
------------------------------------------------------------------


Version 1.0.0.8
---------------
1.Updated API Files.

2.VK_HOME & VK_END hides all lists.

3.VisualASM.ini reorganized.

4.Options dialog reorganized.

5.Autosave Before Make option.

6.Font Charset is now saved.

7.Variables in the structures list.

8.Bug Fix:Inserting a constant from the list was not replacing
  the whole current word if caret was not at the end of the word.

9.Local xxx: Structures is now perfect (shown only if it ought)
  and searches too.
  
10.	a)Browse For API Constants File Button Fixed (JohnFound).
	b)Files & Paths edit controls now autohscroll (JohnFound).
    c)IsParameterAPIConstant Proc .If !EBX-->Else MOV EAX,FALSE
      & DisplayToolTip Proc Uses ESI EDI ->EBX<-, lpText:DWORD
      caused GPF (JohnFound).

11.Procedure Variables Perfect!!! (structures & variables)

12.Show  Structure list in PROTO's.Perfect!!!

13.API Functions list popups only if we are after I|nvoke.

14.Upgrade to CodeHi V1.0.2.0 (message for comments)-GPF for
   height less than font height.

15.No intellisense if in comment, comment block, or string.


Version 1.0.0.9
---------------
1.Add External Tools(Tools Manager not implemented yet-to add/remove
  tools go to the VisualASM.ini in the [TOOLS] section and make the
  necessary changes).

2.Bug Fix: WinNT and WinXP Bug not saving colors in ini.

3.Recent Projects in File Menu.

4.Option to show open dialog on startup(Thanks Bi_Dark).

5.CodeHi Control Upgrade to V1.0.2.2(DBCS Fonts-Chinese etc-
  Scroll Bug fixed and vertical scrollbar sometimes covered
  by the split.Also '.' is a word separator).

6.Bug Fix: Font Charset was not saved in NT(Thanks Dmitry).

7.Updated API Files.

8.Options Dialog Show Hourglass(Thanks Manos).

9.Only the File used recently is shown after opening a project(Thanks Manos).



10.From Project Explorer child did not open if item was grey
   (Thanks Manos).

11.Set Current directory to Project path before making.

12.If there is /OUT in Project options, check if there is path
   specified;If not add project path to it before executing
   compiled exe.

13.Keywords dialog(Thanks Manos).

14.XP bug. A2DW was not returning correct result and thus double
   clicking on an errored line was forwarding us to a wrong place.

15.Small bug for first time cut or copy: paste was enabled only after
   selection change(Thanks Manos).

Version 1.0.1.0
---------------
1.The name of the IDE changed from Visual ASM to WinAsm to avoid confusion
  with other IDE's with similar names
  
2.Default Project extension changed from vap to wap.

3.Tooltips for long members of all PopUp lists.

2.External Tools Manager.

3.Project Options small bug:When no change was made, ProjectModified was set to
  false! But the project might have been modified for many other reasons before!!

4.If Masm.vas was not found and then set properly, first entry of
  the file was deleted and the Categories list was never enabled.

5.Option to show/not show SplashScreen on startup(Thanks Manos).

6.MainTololbarBitmap had 4 images that are not needed(size is now smaller).

7.Toolbar Button for showing/hiding Project Explorer (Thanks maCo).

8.On Minimize Visual ASM goes to System Tray(Thanks maCo).

9.hOwner is now the appropriate dialog (not WinAsmHandles.hMain) for Browse For File Dialog

10.Updated API Files.

12.PopUp List with locals &  Procedure parameters if we are
   in a procedure.
   (Variables list is shown if we are not editing first word of line and
   only if left wordbreak is " ", VK_TAB, [ or comma-Please correct me if I left
   something behind).
   Multiline Procedure Declaration is supproted. Multiline Locals Declaration
   supported.
   In case of Local Buffers, e.g Local buffer[256], only the name will be
   inserted from the list. (For those who do not know, you can insert from
   ALL the popup lists with space, enter or double click).
   

13.Open project, First visible line is the one user had before closing project
   last time.

14.Caps Lock ON/OFF, Num Lock ON/OFF indications on status bar.

15.Some flickering for tooltips removed.


Version 1.0.1.1
---------------
1.Structures Members PopUp List.------->needs improvement.

2.Some additions to the API Files.

4.Pop up lists are now autoheight so that the bottom side is not hidden(Thanks akyprian & jnrz).


5.Buttons for Browse for Binary, Include & Library Dialogs(Thanks jnrz).

6.Bug Fix: Spaces before ":" in local definitions were inserted in the variable
  pop up list.
 
7.WinXP Bug:Tray Icon small bug on double click(Thanks jnrz).

8.Project title on main window title bar(Thanks Manos).


9.WinAsm remembers last used Open/Save Project Directory.(Thanks Manos).
 
10.Bug Fixed:Deleting all lines before first procedure caused WinAsm to
   hang(Thanks Manos).
   
11.Combo did not show name of first procedure if it was at first line
   (Thanks Manos).

13.Child Window color is now syscolor COLOR_3DFACE.


Version 1.0.1.2
---------------
1.Bug Fix: When WinAsm goes to the notification the area, the context menu
  was not hidden if you decided not to choose anything form it(Thanks Jnrz).

2.Major rework for parsing vaa files---->faster startup(GetAPIFunctions,
  GetAPIStructures GetAPIConstants)-(Thanks TBD for reminding me.Is it OK now ?).

3.Masm.vas reorganized. Different colors for API Functions, Structures, Constants

4.Tools-Options-OK very much faster due to 2.

5.For some structures such as DRAWITEMSTRUCT Pop up list column width was a little bit small.

6.Client WS_HSCROLL Style removed (although still has it) for WinNT hscrollbar on start up.

7.Intellisense: Type Include and list with all asm & inc files of the project
  (only name+ext if in project directory, full path name + ext if in any
  other directory) plus all *.inc files in your Include directory.
  Type IncludeLib and list with all *.lib files in your Lib directory.
  (I hope eko is satisfied with this solution)

8.Child window is shown even if splash is shown.

9.Copy selected text or all text of Output Window to the clipboard. Also all
  text can be saved to file "OutText.txt" in the project directory. You can
  access theese via a contextual menu (Thanks Masmer for similar request).

10.Option to show/not show Output window on successfull Make(Thanks maCo). Also Make
   progress is shown on the status bar .

11.Small Bug Fix: Ctrl+Space inserted a space. It Should not.(Thanks KetiIO)

12.In the Project menu a new item to Rename File (Thanks Jnrz & maCo
   -use with caution).

13.Bookmark menu items changed from MF_DISABLED to MF_GRAYED.

14.Upgrade of CodeHi control to V1.0.2.5

15.Error bookmarks in collapsed procedures makes the error line invisible.
   Only way to get it back is by reopening the project.(Thanks KetiIO).See 14
   
16.Bookmarks in collapsed procedures were hidden after procedures expanded.See 14

17.Errors in collapsed procedures now automatically expand procedures.

18.Caps Lock and Num Lock indications on taskbar altered a bit.


Version 1.0.1.3
---------------
1.PopUp List with locals &  Procedure parameters also popups If left wordbreak
  is "=", "<", ">".

2.Find Dialog--> WS_TABSTOP for Up & Down.

3.A little bit of reorganisation for Tools-Options-General to accommodate
  "Open Last Project On StartUp" (Thanks TBD)

4.Procedure Combo now responds to CBN_CLOSEUP not to CBN_SELCHANGE.

5.Bug Fix: Pop Up Lists did not disappear if we were after last parameter of procedure

6.Tab control and list for all procedures.(Thanks TBD)

7.Quiting application is smoother (user does not see removal of Project Tree Items)

8.No flickering of children when Opening a project.NICE!!!!!!!

9.Add File Multiselect (Add File renamed to Add Files)-Thanks TBD & Manos

10.szCmntStart			DB 'comment +',0

11.Many changes to the EN_SELCHANGE of the child window-Proc combo updates
   very less frequently.
   
12.Default Res To Obj empty.

13.Execute looks for FirstASMFileName.exe not for ProjectName.exe
   if /OUT not specified(Thanks h4ng4m3).

14.Transparent icons in Tools Manager (Thanks TBD - I didn't see a problem
   with document icon in menu near file).

15.Double click on the selection bar on a line that corresponds to a PROTO
   declaration and you will automatically taken to the corresponding procedure
   (Thanks maCo).

16.A new menu item to the Project menu, when active file a RC file, to open
   it in an external resource editor?(Thanks Masmer).
   
17.Cursor at start and end of OpenWAP in addition to removing cursor changing
	at REM_SETBLOCKS of CodeHi made a perfect project loading.



Version 1.0.1.4
---------------
1.Bug Fix: bSelection is now a member of the CHILDWINDOWDATA structure instead
  of global since this would cause troubles if user selects in one child,
  activates another child, presses a key and then goes back to the previous
  child. Pressing a key now wil not refill Procedure List.

2.UpdateProcCombo and UpdateProcList now call GetLineText and GetFirstWordOfLine
  instead of repeating their code (make smaller size).

3.The output window's font now changes according to the Editor font(Thanks Bi_Dark).

4.Small Bug Fix:Tools Manager: If one item left blank then all others following
  are lost(Thanks h4ng4m3).Now they become menu separators.

5.New menu item in Help for the WinAsm help(must be in the Help Directory).

6.Small templates for exe and dll-From New Project Select Template they are
  not saved to recent projects:CORRECT!(Thanks maCo).
  
  Here is the mechanism(Unlimited Templates):
  1.In the WinAsm Directory you must have a directory named Templates.
  2.In the Templates directory you can have as many directories as you want(of courrse!)
    All the names of these directories appear as Tabs in the "New Project" Dialog.
    In the WinAsm package you download there are 3 directories by default. Add as many
    as you wish and you will see their names as new Tabs in the "New Project" Dialog.
    
    In each of these directories you can have as many directories as you
    wish (of course!). For Example in the "Executable" Directory there are 2 directories
    now, namely "SDI" and "MDI". If, and only If, in the "SDI" directory there is
    a project called "SDI.wap" then you see this as template (with the appropriate icon)
    in the "New Project" list in the "Executable" tab. Same logic stands for any template
    you wish to create.
    
    When you select to create a new project based on any template (e.g. the "SDI" template)
    you will be prompted to choose the directory you want the new project to be created in.
  
  3.As you can see the templates are normal WinAsm projects and thus you can open them
    normally (Open Project) if you so wish (e.g to make any changes).

7."Path And File Name" for Assemble,Compile RC, Res To Obj, Definition file and Link

8.Procedure list is not LVS_SHOWSELALWAYS any more.

9.On Minimize Go to system tray is now Optional(Thanks TBD).

10.WinXP Theme support.

11.Clicking on a line where no text was displayed (because of the horizontal
   scrollbar position now CodeHi auto scrolls horizontally(Thanks h4ng4m3).

12.DoEvents	in OpenProject just before OpenWap so that open dialog closes
   before project loading starts(more aesthetic).

13.If there is space before the first variable in procedure declaration then
   we do not get name of variable in tooltip (Modifications done in the
   "FillProceduresList" Procedure).

14.Updated API Files


Version 1.0.1.5
---------------
1.Add-Ins(Thanks eko,TBD).
	
A)The best way to start building Add-Ins for WinAsm is buy choosing File-
New Project-Bare Bone-AddIn. A new project containing the following procedures
will be created:

	a)DllEntry
	----------
	Leave this as it is (a WinAsm Add-In is a Dll after all)
	THIS FUNCTION IS REQUIRED BY ALL VALID WinAsm ADDINS.
	
	b)GetWAAddInData
	----------------
	This procedure must fill in Add-In friendly name and description of what
	this Add-In does.
	THIS FUNCTION IS REQUIRED BY ALL VALID WinAsm ADDINS.
	
	c)WAAddInLoad
	-------------
	Place all one-time initializations here. If all resources are
	successfully allocated, function must return 0. On error, it must free
	partially allocated resources and return -1, in this case Add-In will be
	not be loaded.
	pWinAsmHandles is a pointer to the HANDLES structure (see WAAddIn.inc),
	you will most probably need to keep it. Parameter 'features' is reserved
	for future extentions, do not use it.
	THIS FUNCTION IS REQUIRED BY ALL VALID WinAsm ADDINS.

	
	d)WAAddInUnload
	---------------
	It is called when WinAsm closes and when user selectes to unload the
	Add-In from the WinAsm Add-In Manager. Free all internally allocated
	resources, like window classes, files, memory and so on here.
	THIS FUNCTION IS REQUIRED BY ALL VALID WinAsm ADDINS.
	

	e)FrameWindowProc
	-----------------
	This Procedure receives ALL messages of the Main window. You should
	return 0 if you want WinAsm AND ALL OTHER POSSIBLY LOADED ADDINS to
	process the message otherwise WinAsm AND OTHER POSSIBLY LOADED ADDINS
	will NOT process it.
	If you want to use this procedure you must uncomment it from the WAAddIn.inc
	
	f)ChildWindowProc
	-----------------
	This Procedure receives ALL messages of ALL MDI child windows.
	You should return 0 if you want WinAsm AND ALL OTHER POSSIBLY LOADED
	ADDINS to process the message otherwise WinAsm AND OTHER POSSIBLY LOADED
	ADDINS will NOT process it.
	If you want to use this procedure you must uncomment it from the WAAddIn.inc

	g)ProjectExplorerProc
	---------------------
	This Procedure receives ALL messages of the Project Explorer window.
	You should return 0 if you want WinAsm AND ALL OTHER POSSIBLY LOADED ADDINS
	to process the message otherwise WinAsm AND OTHER POSSIBLY LOADED ADDINS
	will NOT process it.
	If you want to use this procedure you must uncomment it from the WAAddIn.inc
	
	h)OutWindowProc
	---------------
	This Procedure receives ALL messages of the Out window. You should return 0
	if you want WinAsm AND ALL OTHER POSSIBLY LOADED ADDINS to process the
	message otherwise WinAsm AND OTHER POSSIBLY LOADED ADDINS will NOT process it.
	If you want to use this procedure you must uncomment it from the WAAddIn.inc

B)Note the new "Inc" folder in the WinAsm Directory. It includes WAAddIn.inc
(in which you will find all constants, structures etc ). I already know that
more information can be added in this file so I expect suggsestions here.

C)AFTER creating a new Add-In I suggest you go Project-Properties-/OUT and
set the name of your Dll and where it should be created.e.g If your WinAsm
directory is C:\WinAsm you set C:\WinAsm\AddIns\nameofaddin.dll

D)In AddIn.def you change
LIBRARY AddIn -----to-------->LIBRARY nameofaddin.dll

AND uncomment procedure names you will use in your addin:

EXPORTS	GetWAAddInData				<---------Do not comment this
		WAAddInLoad					<---------Do not comment this
		WAAddInUnload				<---------Do not comment this
		;FrameWindowProc			<---------Uncomment this if you are going to use it in your Add-In
		;ChildWindowProc			<---------Uncomment this if you are going to use it in your Add-In
		;ProjectExplorerProc		<---------Uncomment this if you are going to use it in your Add-In
		;OutWindowProc				<---------Uncomment this if you are going to use it in your Add-In


2.Small behaviour change: WinAsm help file was application topmost(Thanks Masmer).

3.In WM_PAINT of Child Window not very good code was "eating" resources.

4.A MesageBox popping up asking if the user really wants remove the
  file (Yes\No)(Thanks Masmer).

5.If project cannot open, do not enable project releated items.

6.If a variable name is the same with structure(not case sensitive then we
  don't get structure parameters for this variable).

7.If a variable name is not the same case with declared variable i should
  not get the structure members list.
  
8.Splash takes a little longer (Thanks FunkyMeister)


Version 1.0.1.6
---------------
1.Intellisense:Structure members of first structure (_SIZE) in Structures list
  were not shown in structure members list.
  
2.Find and Replace buttons on the toolbar(Thanks andrew_k).

3.Small bug fix: When all bookmarks were cleared the toolbar was not updated
  until the left button of the mouse was clicked in the active document
  (Thanks andrew_k).

4.Executing EXE's (incl. consoles) after "Go All" is now optional. Tools-
  Options-Miscellaneous-Launch EXE on Go All(Thanks andrew_k).
  
5.Resource files that contain "space" in file name can't be opened by Borland resource workshop(sometimes)
  Using quotes did not solve the problem.(Bi_Dark)

6.Include and IncludeLib path can now contain spaces. Thus you can have them
  in your WinAsm path (e.g. C:\Program Files\...)(Thanks andrew_k).

7.File not saved indication removed. Save tool and menu item grayed to indicate
  that file is not saved(Thanks Manos).
  
8.SendCallBackToAllAddIns... If EAX==0---->EndIf ----->DefxxxProc(i.e outside If-EndIf)

9."Debug" menu item in Make menu launches external debugger of choice (Tools-
  Options-Miscellaneous-External Debugger) if current project is EXE
  (Thanks Masmer, andrew_k).

10.OwnerDrawn menus.

11.Updated API Files.


Version 1.0.1.7
---------------
1.All Toolbar, Menu, Project Tree bitmaps now into one bmp file and hence one global
  imagelist. Therefore smaller executable (no doublicate bitmaps) and faster Drawing
  for Owner Drawn menus (no loading-destroying of the image list for every item drawing)
  
2.Due to 1 above, w/o extra bitmaps, I draw bitmaps for more menu items.

3.Bug Fix:(Thanks andrew_k)
1. You need to have a procedure with a local
2. Double click on any word to select it
3. Delete the word
4. Start typing the first few letters of the locals name
5. The intellisense popup will appear. Double click the locals name to
select and insert it from the popup.
6. Now start clicking 'undo' from the toolbar. You can't get back to the
original word.

4.Similarly for Functions replacement (API and Project Functions).

5.Tools-Options-Miscellaneous-Use Quotes for *.rc file names (VC++ resource
 Editor needs quotes for filenames containing spaces (Thanks Bi_Dark).

6.Click on + - quickly ------>some flicker and misbehaviour(Thanks VERY MUCH for this Bi_Dark).

7.Line Number Width can now be set to auto (Tools-Options-Editor) so that it
  will automatically reflect the Line Number Font change (Thanks FunkyMeister).
  
8.You can now save Untitled.* (Thanks Dmitry)

9.Now all new files are counted e.g. Untitled1.asm, Untitled2.asm ... Untitled1.inc etc(Thanks h4ng4m3)

10.You can now Open any File that does not belong to your project (Thanks Manos, KetilO, Bi_Dark).Can be viewed
   from the Window menu
   
11.You can now associate ANY file (e.g. *.asm, *.inc etc ) to WinAsm (Thanks Bi_Dark, Masmer).

12.Window Styles are now keywords in rc files and thus colored (Thanks andrew_k)

13.Update to CodeHi control V1.0.3.0----->Faster selection (Thanks andrew_k).
   Now various code blocks can collapse/expand.:
   Macros
   Structures
   
14.Procedures Tab in Project Explorer renamed to Blocks and the corresponding
   List displays Procedures, macros and structures now (Thanks masquer).
   
15.Minor changes to Find and Replace bitmaps (Thanks andrew_k)

Version 2.0.0.0
---------------
1.Image for Blocks Tab Item.

2.Use quotes for /Out switch so that project can be built to any folder
  with any name (when there are spaces)-(Thanks SOL_bl, andrew_k).



3.Exernal tools are now executed with ShellExecute (Thanks P2M)

4.Minimum height and width of main window set to 220 pixels.

5.Print Dialog Screen center (Thanks andrew_k).

6.Improvement on how all windows receive/loose focus

7.Project Explorer and Out Parent are now Docking/float windows.(Thanks Maco, Manos, eko)
Notes:
a).Custom title bar styles;Right-click on the non client area and
  choose the title style from the context menu. 
b).Pressing Ctrl while moving prevents docking (Always float)
c).Double clicking on a docked window converts it to float (last float pos and size)

8.Esc hides the output window (Thanks SOL_bl)

9.Much more comprehensive MasmApiCall.vaa (Thanks PhoBos). The previous renamed to
  MasmApiCallLt.vaa for those who might have startup speed problems.

10.Some more bitmapped menu items and CodeHi different images (Thanks andrew_k for the images).


Version 2.0.0.1
---------------

1.256 color bitmaps used instead of 16-color.(Thanks andrew_k and PhoBos for the help)

2.Procedure Combo form 150 pixels now 250 pixels hide (helps for Win98SE)

2.Procedure Auto Complete: Dafault, Uppercase, Lowercase options for RET and EndP.(Thanks andrew_k)

2.0.0.1 UPDATES
---------------
1.When sizing a float window, some minor position problem occured
2.A bit improvement on toolbar bitmaps (Thanks andrew_k)


Version 2.0.0.2
---------------
1.Docking Windows are not based on "hActiveDock" any more but a Block of memory keeps
  information for the docking windows "turn".

2.If Intellisense Pop up is visible Esc hides it. Otherwise output window will hide(Thanks PhoBos)

3.Project Properties & Tools-Options Dialogs background color when XP theme was used.(Thanks TBD)

4. When you right click on a Block name the popup menu includes
   an item that would let you goto the declaration line of that object.
   Also option for going back.
   This should make analysing large programs less painful.(Thanks JohnnyQuest)
   
   Removed: Double clicking on the selection bar on a line that corresponds to a PROTO
   declaration and you will automatically taken to the corresponding procedure
   not needed any more.

   andrew_k should make minor changes to AddProc and AddMacro Add-Ins to take care of the
   increase in menu items.
    
5.Docking Windows context menu now appears only on non-"client" area.

6.Much better support for showing/hiding docking windows with
  .ElseIf uMsg==WM_WINDOWPOSCHANGED
  
7.WinAsm can handle ANY number of Docking Windows, so I decided to export this
  capability to Add-Ins. Three new messages are applicable for this purpose (Please
  see attached WAAddin.inc):
  
  a)WAM_CREATEDOCKINGWINDOW: Send this message to ***hMain*** to create a new
  docking window; The return value is the window handle of the newly created Add-In,
  hWnd   = hMain
  wParam = Window Style, recommend (WS_VISIBLE OR WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_CHILD or STYLE_xxx)
          WS_CHILD is a must!
  lParam = lpDockData (LPDOCKINGDATA)
  
  
  b)WAM_GETCLIENTRECT: Send this message to the handle you obtained from
   (a) above the get the client rectangle of the docking window. Do not use any
   other method you are aware of to get this rectangle!
   hWnd   = hAddInWindow
   wParam = 0
   lParam = lpRect (LPRECT)

  c)WAM_DESTROYDOCKINGWINDOW: Send this message to the handle you obtained from
  (a) above to destroy your Docking window. DO NOT USE any other method you are aware of to destroy it!
   hWnd   = hAddInWindow
   wParam = 0
   lParam = 0
   
  Note: Pressing x on the Docking window does NOT destroy your docking window.
  It simply hides it. Use (c) above to destroy it if you so wish!


V2.0.0.2 Update 2 (I lost the changes of Update 1-very minor)
------------------------------------------------------------
1.In WM_SIZE of Project Explorer I use this:
			Invoke GetWindowLong,hProjectTree,GWL_STYLE
			PUSH EAX
			or EAX,TVS_NOTOOLTIPS
			Invoke SetWindowLong,hProjectTree,GWL_STYLE,EAX
			POP EAX
			Invoke SetWindowLong,hProjectTree,GWL_STYLE,EAX
	
	so that Tree tooltips are not hidden behind the docking window when it floats.
	
2.In Docking window procedure
	.ElseIf uMsg == WM_NOTIFY
		MOV EAX,lParam

		.If [EAX].NMHDR.code==TTN_NEEDTEXT
			Invoke SetWindowPos,[EAX].NMHDR.hwndFrom,HWND_TOP,0,0,0,0,SWP_NOACTIVATE OR SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER
		.EndIf
	so that Toolbar tooltips are not hidden behind the docking window when it floats.

3.Invoke DrawCaption, hClient,... in ODMenus instead of hWnd of desktop window because sometimes there is text (Thanks Jnrz) 


V2.0.0.2 UPDATE3
----------------
1.WinAsm hangs if Macro or struct at line=0 and no more lines in any asm or inc file (Thanks JohnyQuest)



Version 3.0.0.0
---------------
1.WinAsm renamed to WinAsm Studio.

2.Brand New set of Images (Thanks PhoBos)

3.In WM_ACTIVATEAPP: Invoke InvalidateAllDockWindows (i.e. not only Project Explorer & OutputWindow)

4.EnableAllDockWindows,TRUE/FALSE

5.	.ElseIf EAX >50000
	changed to .ElseIf EAX >50000 && EAX<=ExternalFilesMenuID
	and the bad crash when minimixing,maximizing and pressing X MDI children removed!

6.Caret of CodeHi is now shown even if user selects from Project tree

7.MDI Children now process WM_MDIACTIVATE and WM_SETFOCUS;  and not WM_SETFOCUS || EAX==WM_MOUSEACTIVATE

8.TAB-->Indent, Shift TAB-->Outdent (Thanks JohnhyQuest)

9.Resource Editor:
Thanks Manos, maCo, Dmitry, PhoBos, JohnhyQuest and many others!

-WinAsm can be used as a standard Windows Resource Editor
-Use the Visual RC Editor as:
	1.From associate your RC files with WinAsm
	2.Open your RC Fiels from the command prompt
	3.Open your RC file from File-Open Files and then choose it from the Window menu.
	4.From the Explorer (ex Project Explorer) double click on any rc file (if you havemore than one)
	5.New tab on the Explorer (ex Project Explorer) named Resources
-Controls shown exactly as they should be (e.g. disabled)

-Dialog units are EXACT.
-Menu item levels are checked on pressing OK.

-Recognizes XP Manifests.
-Saving Menus uses Tabs
-Pressing Right mouse button while trying to create a new or move an existing control/dialog cancels the operation
-Flicker-free Dialog editor and all other Dialogs.
-Pick the Window styles easily.


V3.0.0.0 Beta 2
---------------
-Edit Left,Top,Width,Height from the properties list is reflected to the script.
-Change of Name and ID of dialogs and Controls from the properties list is reflected to the script
-Styles Excluded for GroupBoxes: BS_USERBUTTON,BS_OWNERDRAW,BS_PUSHLIKE,BS_3STATE,BS_AUTO3STATE,BS_AUTOCHECKBOX, BS_AUTORADIOBUTTON,BS_CHECKBOX,BS_DEFPUSHBUTTON,BS_PUSHBUTTON,BS_RADIOBUTTON
-Styles Excluded for PUSHBUTTONS:BS_LEFTTEXT,BS_GROUPBOX,BS_USERBUTTON,BS_OWNERDRAW,BS_PUSHLIKE,BS_3STATE,BS_AUTO3STATE,BS_AUTOCHECKBOX,BS_AUTORADIOBUTTON,BS_CHECKBOX,BS_RADIOBUTTON
-Styles Excluded for Checkboxes:BS_USERBUTTON,BS_OWNERDRAW,BS_AUTORADIOBUTTON,BS_DEFPUSHBUTTON,BS_GROUPBOX,BS_PUSHBUTTON,BS_RADIOBUTTON
-Styles Excluded for RadioButtons:BS_USERBUTTON,BS_OWNERDRAW,BS_DEFPUSHBUTTON,BS_GROUPBOX,BS_PUSHBUTTON,BS_AUTOCHECKBOX,BS_CHECKBOX,BS_3STATE,BS_AUTO3STATE
-User defined control styles allowed only WS_.... and 0x....

-Bug For groupboxes after using Styles dialog (same applies for images and shapes because all three controls are children of statics)-thanks BiDark
-Rebar styles allowed are WS_ and CCS_
-ProgressBar styles allowed are WS_.Also Invoke SendMessage,[EDI].CONTROLDATA.hWnd,PBM_STEPIT,0,0 after setting the style
-UpDown styles allowed are WS_
-Under cirtain circumstances, Active Child postion was not saved correclty, so next time
project was open Client scrollbars were confusing user! (Thanks Qvasimodo)
-WS_TABSTOP removed for Dialogs (=WS_MAXIMIZEBOX)
-WS_TABSTOP not inserted by WinAsm for Old type controls
-If a NOT style was last in the styles of a control then endless loop(Thanks Jnrz7) 
-Various issues with Rebar control.
-Style/ExStyle change goes to .CONTROLDATA.hChild for groupboxes images and shapes
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.0 Beta 3
---------------
-Menu was causing problems (no controls detected) for Dialog resources (NOT DialogEx) (Thanks Qvasimodo)
-If Menu had only ID and not name-->all menutitem IDs reset to zero (thanks jnrz) 
-AddOrReplaceDefine does not do anything if lpName==Nothing (Otherwise see problem 2 above)
-String Table can now be edited.
-Resources Table can now be edited.
-Slight changes to ListView and TreeView Bitmaps (Thanks Manos)
-#define can now hold 64 byte declaration (Thanks Qvasimodo)
-Pressing X of a Child window selects hParentItem of the project tree.By this means, TVN_SELCHANGED is fired and no need to handle
 NM_SETFOCUS (Thanks Manos).
-RCOptions visible/invisible on exit was not saved properly in ini
-Delete Dialogs/Controls with the delete key (Thanks Jnrz)
-Tools-Options Dialog made bigger and more comfortable (Thanks Manos)
-Default colors/font/etc if WinAsm.Ini is not found (Thanks Manos)
-On the properties list, Font, Menu,Class are now displayed
-CF_ANSIONLY for Dialog fonts is allowed.
-Caption/Text can be edited and changes are reflected.
-Class can be edited and changes are reflected.
-Font can be changed and changes are reflected
-Icon of ICON Controls was not saved properly (# is needed)
-When users delete a dialog, HeapFree for all Controls & DeleteDefines
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.0 Beta 4
---------------
-AddDefine instead of AddOrReplaceDefine for NEW Dialogs and NEW controls
-When I edit a file the "savefile" icon changes color but when saving the file
 it does not change back to "saved state" unless I open another file(Thanks WinCC)
-Version info was saving VersionItems even if they had no value.
-WinAsm Studio main window remembers its pos and size of last use (Thanks ET)

-Selecting from the Project Tree, shows MDI Child maximized-if it was hidden.(Thank defbase)
-New Project begins with single file maximixed (Thanks Qvasimodo)
-Add-Files Maximized (Thanks Qvasimodo)
-Open-Files Maximized (Thanks Qvasimodo)

-hProjectExplorer does not flicker due to LockWindowUpdate (I use WM_SETREDRAW)

-Find:
	a)MessageBox informing "search complete" (Thanks JohnnyQuest)
	b)Selected is automatically inserted as the Find What Text (Thanks maCo).
	c)Combo to remember all "Find What" strings (Thanks akyprian :-) )

-Appropriate Menu/toolbar options not disabled Open Winasm --> New project --> Project / Add New RC (Thanks TheOne) 

-WinCC
 Drag&Drop files to WinAsm is also on my "Wish list" 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
V3.0.0.0 Beta 5
---------------
1.File --> New Project, a window appears, work on another window so you dont see winasm at all, go back to winasm and "oh oh"(Thanks jnrz7) 
2.WS_MAXIMIZED is now optional (Thanks Manos)
3.Selecting from the project tree does not flicker any more ???????
4.Sizing Dialogs or Controls mouse cursor changes accordingly (Thanks Manos)
5.Edit Controls could not be seen w/o border if they had a border at the bigining.
6.Buttons in Included Files & Resources Lists are not causing "interference".
7..ElseIf EAX==WM_SETFOCUS || EAX==WM_MOUSEACTIVATE
  Invoke SetFocus,hEditor (Because selecting from the selection bar was not killing
  focus of Project tree
8.Accelerator Table can now be edited.
9.winasm does not save the accelerator IDs if Not Defined(Thanks Jnrz) 
10.User Can Choose a menu for dialogs from properties list
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






CHINESE_GB2312 font supports chinese.