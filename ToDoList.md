# Introduction #

User wishes and improvements are posted here.

# Assemblers support #

## JWASM ##

  * Add switch (radio button) in project properties to compile 64-bit version (-win64 switch)
  * Option for binary output (-bin switch)


# Features suggested #

## User interface ##

### Warning: RAW list ###

TO DO:

---


JimG

---

editor bug, mixing tabs and convert tabs to spaces

---

This is a small problem that I've recently run into. Previous to this, I've always had the
"Convert Tab to Spaces" option unchecked. I started using this option because Ollydbg doesn't
understand that I would like it to use 4 character spacing rather than 8 for tabs.
The same is true for listing files from Masm. That makes it hard to read when some lines have tabs
and some don't.

The problem is that if I'm editing some old code, with embedded tab characters rather than spaces,
the editor get confused which column it is on. To see this, check the option to convert to spaces,
edit a file with tabs, go to the end of a line starting with at least one tab and hit return to add
a new line. If you look at the Col number at the bottom, you will see that it thinks each tab was one
character, so if there was 3 leading tabs on the original line, it will think the new line starts at
column 3 (look at the column indicator at the bottom). Thereafter, anytime you hit the tab key to indent,
the cursor moves to a a column that equals 3 + a multiple of 4 ( or whatever you tab size is).


Seafarer

---

1.If you press the Escape key whilst editing Names or ID's, for Other Resources, the dialog clears
everything listed, ouch!


2.I was working on a project today that required changing of display settings and noticed a small bug with WinAsm Studio's Main Window.
Normally I a run 800x600 16-bit High Color mode, but was testing my project in different display modes.
When changing Display modes, Windows gives a Compatibility Warning and states it will resume previous settings in 15 seconds or if Cancel pressed when changing modes without rebooting, and no conformation to stay with new mode.
When changing to a larger work area the Studio Main window adapts properly.
However...
If I let the Keep New Settings dialog time-out or press Cancel and revert to previous Display settings, WinAsm Studio's main window has lost track of screen size and is still sized for the attempt/previous larger display area.
The same symptoms apply if I scale back from 800x600 to 640x480 using Display Settings and keep new mode without a reboot.
My work around was to to doube-click the Studio's main window title to Restore, and double-click again to Maximize to current screen-size. (darn I hate it when it does this)
Note:
I run with task/eplorer bar always on-top.


X-Treem

---

1)when i select font from the list, there are some fonts that are bold or italic by default,
> if i select one of this and then i select another one that is by default regular (for instance i go back to lucida console), it keeps the bold or the italic style (selected in blue in the style box) also on the regular font i selected and i cannot select the style because style box is grayed (disabled) but with bold or italic selected with blue.

2)after doing font selection the normal text color switch to black (i have dark color scheme
> the one kindly posted on this forum), i have to go to Option->Colors and select back my style
> and reapply to get normal text back to usual color.


Swagler:

---

I don't know if this is configurable, when I open a project, WinAsm main
window turns white and expands, then cascades all project files.
I then use "Window/Hide all windows" to close them. I've cleared recent
file history in WinAsm, still does the same.

This has only been happening with XPTskbrCtrl EXE project not
DLL project. I think it's the size of EXE project. I was going to clean
registry MRU...




Menu shortcuts to be displayed properly on the menu dialog of the visual RC Editor:
> pending Del key and some others)

Seafarer

---

http://www.winasm.net/forum/index.php?showtopic=2056
In addition to my request for an MF\_HELP/MF\_RIGHT checkbox for menu Type, would you add a Test Button?
When clicked by coder...
The studio would create simple dialog window showing defined Menu Resource that can be clicked to confirm behaviors of Drop Down/Pop-up menu items.
Sort of like Dialog Test Window, but for Menu RC's.


And I thought we would finally see improvements and upgrades to the resource editor as well as some of the accessibility functions metioned over the years.

shantanu\_gadgil

---

Intellisense Tooltip, API tooltip does not disappear [BUG](BUG.md)
1. Start a project
2. Open any of the code file
3. Punch in some API ... say "invoke lstrcpy"
At this point the tooltip is already popped up.
4. Close the window using the mouse
The tooltip stays there popped up !!!


samael

---

VERY long post on [REQ](REQ.md) Docking Windows http://www.winasm.net/forum/index.php?showtopic=1995



sonic

---

Just undock any pane and drag it to the taskbar and it will disappear.


JimG

---

1. Find a section of code that has a call to another proc that is not visible.
2. Pull down the splitter so you can see the call in the upper file pane.
3. Click on the name of the called proc, and do a goto block ctrl-b
4. Make a change to the called proc in the upper pane
5. start to move the splitter bar back up to close the upper pane.
It immediately changes the text in the lower window to the start of the file.

-If I place a bookmark on a line, (knowing I'm going to go do a bunch of other stuff and want
> to get back here when I'm done) and then place the cursor on a procedure name within the line
> and do a ctrl-b (goto block), WinAsm Studio forgets where my bookmark was. I understand if it's
> a simple go look and come right back, I can do a ctrl-shift-b to get back, but when it's more complicated,
> it would be nice to have the bookmark still there.

SeaFarer:

---

1.The Show/Hide Line numbers, Expand All, & Collapse all buttons do not repaint correctly after a system wide WM\_SETTINGSCHANGE message is broadcast.
> To confirm...
  1. Switch to a High Contrast Color theme
> 2. Load the Studio.
> 3. While Studio running...
> Change display settings to a Low contrast or different color/theme and you will see what I mean.

2.If you are creating/editing a resource file and switch to text mode before saving your last changes...
> and then switch back to visual mode without saving changes again...
> The Save button disables although no changes were saved yet.



3.Would it be to much trouble to include this new button in your next revision so it is possible to reset the
load order/docking position of Add-Ins without having to re-open this dialog? Err...Uh... Maybe even have another button titled "Unload" as well?
> What I mean is...
  1. Add-In(s) are not really loaded until this dialog is closed.
> 2. If an add-in is docked, say at the bottom, then you load another add-in that was previously docked at the bottom. It will be placed above the allready loaded add-in that was docked at the bottom.
> In other words...
> To get the previous add-in to be at the very bottom, you need to unload the active one first, load the one that was already docked at the bottom, then "re-load" the one you unloaded.



4.Aside from this I wanted to suggest adding second checkbox titled, MF\_HELP or MF\_RIGHT(0x00004000) See RC.HLP and windows.inc

sonic

---

-First is it possible to provide an option to lock controls similar to most of the resource editors...
> it's annoying if one control is moved accidently and worst it can't be undone
-Second is some of the control styles missing for example buttons. Is it possible to have your styles
> defined in a file or maybe incorporating all styles
-Sorry for constant spamming...but i just forgot another thing and that's changing the TabOrder for
> controls....I don't think still there is any other way other then shuffling manually the controls from
> the resource file to change the tab order....It would be great to have that feature too....
> Sorry for being so much demanding but i hope it's ok to make the editor more versatile....


goppit

---

thanks go to you as WinAsm is still the best masm IDE. However I have a small suggestion
WinAsm doesn't play very nicely if ran from a USB flash drive on multiple PCs where it is
assigned a different drive letter each time.
The problem lies in the way WinAsm doesn't handle relative paths properly.
With some tinkering it starts off OK but keeps losing its syntax highlighting keyfile,
the launching of the external debugger and user-specified tools from the tools menu.
This is one place where FASM excels as a single self-contained executable but I would love
my favourite WinAsm to be able to handle a similar setup better. Is this feasible?



-Maximizer
-rc menus

-Clean command should be local to the project (select extensions to delete?) -Thanks shoorick,Jupiter
-When i delete file from project i could optionally remove it from project folder (eg. confirmation dialog with checkbox instead of usual messagebox)?Thanks shoorick
-Under Resources -> Definitions (Definitions Manager) it would be nice to be able to sort the Names and ID's alphabetically in ascending and descending order.(Thanks Desp)

Also, why not export the handles for Dialog & Toolbox? (Thanks SeaFarer)


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-DLL Project - Run, Make run available for DLL project(Jupiter)
> Currently in DLL project command line for RUN is disabled, so I can't run another
> 'host' to debug library, I must do it another way.
> In Visual Studio you can setup params for run even if your project is DLL.
> WinAsm Studio disables RUN parameters and command at all.
> So, my idea is very simple:
> Configure RUN parameters for DLL project too.
> When I call Run, Studio executes app with command line from project properties.

-It would be good for dll/other non-exe still able to use run,
> but command line in properties use as commandline to run,
> not as just parameters to an application(shoorick)

-Also some commands are blocked if there is no asm/rc in project,
> then i need to add dummy.asm to be able process say C++ projects,
> or rename files: some MC assemblers have extensions like "a51" etc.(shoorick)

Jupiter

---

show, which registers are used in proc (to save them in 'uses' statement)

in plus: is there any Proc to Proto generator in WinAsm studio?
just imagine: you choose "Create procedure declarations" and all Protos are created from existing procs.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
xchg

---

Another thing that could be easily done is to offer creation of LOCALs by entering the name and type in a dialog window. With this, you won't need to browse upward and put a "local" directive every time you need a new variable. Just pressing, say, Ctrl-L, you could bring up a small dialog, type the definition for local variable and press OK. And the definition would be created somewhere at the beginning of procedure, and you won't have to worry about it.


just wanted to post a suggestion: you know, I'm used to push Tab instead of space when I create a procedure, instruction and so on.
for example, mov 

&lt;tab&gt;

 eax,1
In the WinASM studio you have a feature which autocompletes procs and macros (found it really useful).
And the point is... when I issue a "proc" statement, I have to correct the automatically inserted "endp" by replacing a space with Tab to make the "proc" and "endp" match visually. For instance, "MyProc

&lt;space&gt;

endp" would be corrected to: "MyProc

&lt;tab&gt;

endp".
So I want to suggest you to add an option that would let the user choose the character WinASM uses in it's automatically generated lines. You already have the "Block auto complete" section which sets the case of "ret" keyword. So it's only to insert another option!




The WinASM Studio's Resource editor works fine. But it lacks a feature that, I dare say, virtually everyone would like to have. It cannot export definitions into a separate file. Yes, it has a window called "Definitions Manager", where you can press "Export" button and your definitions will appear in an edit control. But manually copying them into a file is boring and slow, and completely unnecessary!
Why not export definitions automatically to a file belonging to project? The file name could be given in Project options, the default name could be written in studio's options.
P.s. that is the only reason why I use RadASM's ResEd instead your resource editor. I set their ResEd as "external resource editor".


I once saw a suggestion that had just the same idea as mine!
Here it is: http://www.winasm.net/forum/index.php?showtopic=734
The author wants you to make the interactive definition browsing feature. The same as in Borland Delphi 7 environment. I highly support this suggestion!
Another possible thing to do could be to automatically offer a list of structure members on-the-fly, like in all award-winning environments (VB, Delphi etc.) It's surprising that WinASM offers such a list only if the structure is Local, stack-based. You can try yourself:

Routine proc
> local structure:MSG
> mov structure. {at this point you'll get a drop-down list of MSG members}
> <.........>
Routine endp

Why not to drop such lists for static structurez too? ;)
And finally one more idea))
why to spend time writing hundreds of constants in MasmApiConst.vaa?
The wise Microsoft men invented a way to name their constants: they use prefixes like
WM_, PAGE_, VK_and so on. Why not to specify the prefixes only? And then, upon the need, build the list of all constants which have such a prefix. This is a possible way to avoid writing loads of data into the MasmApiConst.vaa, spending the hours of time...
You may say that in some cases we may find unsuitable constants because they could have the same prefix. (For example, they are intended for another API function.) But that's not a problem. Such cases are rare, but even if it happens, the user apparently won't select the constants that are not the ones he is interested in._

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PronLover(shoorick)

---

1.no feature "go to procedure/variable definition"
i do not know about variables, but there is for procedures, but works only for masm compatible syntaxis - possible it uses not masm

2.no feature "open file under cursor"

3.again wish "region collapsing"
(btw: ;**reserved! ;** is used by scan.exe to skip current include parsing) - look at my sources:


include 'win32w.inc'           ;


he said if locals are on some lines - only first detected. also he said about tooltip with function params: if invoke string continue on next - there is no help tooltip on next lines (ones i already told you about this)


well, new interesting suggestion from PronLover: he suggests if you select some predefined words, say, eax - other occurances should also be highlighted in someway - usefull to check usage of registers while coding. -- i agree with him
i told him that you are busy with HiEdit, so, it will not be fast if even possible.
also i think with this: you can open source of WinAsm Studio for parts you do not wish to support far - if there is no secret ideas or other issues, say, for codehi.dll. - just a thought.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

shoorick

---

-also, i still develop wafasm :) i've been thinking if you will share pointers
> to vaa/vas files in "features" structure it will be possible to try to support
> other assemblers via add-in: i mean replacing x86 instructions with other cpu
> mnemonics etc. at runtime by project settings.

-look there: http://www.asmcommunity.net/board/index.php?topic=25382
when it compiled in visual mode of resource editor there is no mention of calling rc.exe in out window. in non-visual it's ok (says error "include file not found") maybe it is because rc contains only includes, nothing else.
think, it has to be fixed fast.

-addins popup menus on menu bar when changing mui
-when wap is renaming, it loosing all additional settings sad.gif (eg. Compiler=FASM), thus I need to go there and restore everything manually. so, what do you think is better: you will change renamig routine or i'll add a checking for this?
-also, i still say you: if you will update studio at common, the font, used for subclassed edit controls in listviews, has to be same as code editor (i mean codepage). no explanation will be admited - it is a bug, just not occasional, but intentional! (am i strict enough?)
-wish to tell you some wishes about resource editor:
1.it is definetely needed to be able to select a group of controls in the tree
2.it is definetely needed to be able to hide selected group of controls for comfortable editing paged boxes where controls are in messy "stack"
3.when new control defined with same ID there should be warning, but it have to get ID number of previously defined control with same ID: i use B\_OK=1 and B\_CAN=2 on each dialog, so, when i add for new dialog such IDs i have a problem each time.
4.it would be good to be able to update current id manually to new unical value (also with group would be nice): this is usable, when controls from one dialog inserted into another and controls have different string ID, but same numeric.


> some logs into your fire ;)
**impossible to unswitch LVS\_LIST style for listview in styles popup
> window** same for BS\_RIGHTBUTTON for checkboxes
**if line is last in the editor, it is possible to comment it with F2,
> but impossible to uncomment** cosmetic: in resource properties parameter "Visible" has values
> "True" or "False". it is right formally, but i think "Yes"/"No"
> would be better: first variant looks even funny in russian/ukrainian
> (i know, with last nobody interested yet, but since i've posted it,
> i'll support it while it does not ennoy me - even just for stuff ;)
**also cosmetic: i would like to make embedded new project wizard
> window wider, but found it is not in the resource dll. commonly,
> i need just make it wider because when i've add new fasm templates
> groups, it started looks not well enough. Also there is "Empty
> Project", not translated to local language (i not insist on it
> translation - just for your wish).**

more complex, thus just as questions:
1. is it possible to build and call own intellysense list using codehi
> functions? and even more specific: i'd like to call it to insert
> the name of structure: you know, it is very pleasant to select
> "pszReleaseAssembleCommand" after dot, but it not pleasant to type
> "CURRENTPROJECTINFO" :) (of course, i do not mean exactly add-ins
> structures - it is just a good example).
2. is there a way (even does not matter will it be fast or slow) to
> hot switch vas/vaa set? commonly, fasm and masm have few
> differences, but it would be better to have separate sets for them.
> also, this could be the way to support other assemblers (PICs etc.)


---



a sugg: it would be good to be able to drag files from project
> window of one winasm instance to project window of another. :)


when i add a new item a new numeric and symbolic identifiers added
> automatically to it. and if i change symbolic to already existing by
> my wish i want to change this new numeric identifier to same with
> previous (i mean do not change previous to new). this is usable in
> cases if you use many time standart identifiers like ID\_CANCEL (2)
> etc., and when you have many dialogs with controls with same
> meanings and do not want to use too many symbolic constants.

> also, it should be done: at least one step undo has to be in
> resource editor: spent much time to align, then occasional wrong
> mouse move - and start again.

Jupiter

---

may be add 'Browse' button to 'Recent projects' meaning open existing project, not listed in recent?

1. Bugs:
WinAsm fails to uncomment this line

CODE



&lt;TAB&gt;

;Comment<-----------------------------Make it optional



2. Suggestions:
a) fix a bug ;)
b) multiple line comments:

If lLinesToComment >= 5 Then
Comment Style:

CODE

comment ~
<some code>
...
<some code>
~



Else
Comment Style:

CODE

;<some code>
;...
;<some code>



EndIf


Resource Editor
1. C and C++ comments support:
// Single comment
/ Multi line comment
**/
2. Correctly parse escape characters (sometimes fails with \n at the end**



But anyway, can I turn off option to show file folder in project explorer?
for ex. in/gfx.inc will be shown like just 'gdx.inc'?

PhoBos

---

When typing a string with some comma as a function parameter (with SZ() macro for example), the current active parameter isn't right anymore. In the following example the active parameter should be lpCaption...
Invoke MessageBox,hWnd,SZ("A Caption,"),



---


crisanar

[**]When you are in the Ressource Style or exStyle Dialog, if you press F1 on a selected style, it could be useful to show the win32 help on this word.**

[**]Add Block auto complete also for [b](b.md).if .while[/b] ...
Maybe an editable list with the corresponding snippet to add to let the user free to add some others block auto complete?**

[**]Add a tabulation when we press ENTER after an .if, .while, .else, .elseif

---

Thanks sol**

I have a project in:

D:\add\_work\intenso\scan\test\_filter\test\_filter.wap
with one module
prg\_testfiltr.asm

I use external modules from:

D:\lib\asmmod\dct\_CPUInfo.asm
D:\lib\asmmod\sys\_windows.asm

Step 1 (shift+f6)
Now I start a compilation.
In dir: D:\add\_work\intenso\scan\test\_filter\ I have the results:

prg\_testfiltr.obj
dct\_CPUInfo.obj
sys\_windows.obj

D:\programs\winasm\Masm32\Bin\ML /c /coff /Cp /nologo /Fm /Zi /Zd /I"D:\programs\winasm\Masm32\Include" "D:\add\_work\intenso\scan\test\_filter\prg\_testfiltr.asm"
D:\programs\winasm\Masm32\Bin\ML /c /coff /Cp /nologo /Fm /Zi /Zd /I"D:\programs\winasm\Masm32\Include" "D:\lib\asmmod\dct\_CPUInfo.asm"
D:\programs\winasm\Masm32\Bin\ML /c /coff /Cp /nologo /Fm /Zi /Zd /I"D:\programs\winasm\Masm32\Include" "D:\lib\asmmod\sys\_windows.asm"
Make finished. 0 error(s) occured.

Step 2 (shift+f7)
Now I try link, but...:
D:\programs\winasm\Masm32\Bin\Link @"D:\add\_work\intenso\scan\test\_filter\link.war"

Microsoft ® Incremental Linker Version 7.10.3077
Copyright © Microsoft Corporation. All rights reserved.

/SUBSYSTEM:CONSOLE /DEBUG /VERSION:4.0 "/LIBPATH:D:\programs\winasm\Masm32\Lib" "D:\add\_work\intenso\scan\test\_filter\prg\_testfiltr.obj" "D:\lib\asmmod\dct\_CPUInfo.obj" "D:\lib\asmmod\sys\_windows.obj"
LINK : fatal error LNK1104: cannot open file 'D:\lib\asmmod\dct\_CPUInfo.obj'

Make finished. 1 error(s) occured.

Linker try get object files from D:\lib\asmmod\ (winasm told him  but ofcoz there aren't these objects. Can I set winasm to get objects from dir of workspace during link?

Is it bug ? Maybe I can set it, could you advice me, please?

Best regards
SOL

;---------------------------------------------------------------------------------------
Virtual spaces (Thanks sol)
;---------------------------------------------------------------------------------------
Artoo

---

On the Windows menu, have a list of files already open, then appropriate accelerator keys to switch to them.

eg:

CODE
Window
  1. MyAsm.asm
> 2  MyInc.inc



So pressing Alt W + 2 would switch to MyInc.inc

2
In the editor, having the ability to "Block" select, copy, and paste.
eg:
So when you go to select more than one line of text while the ALT key is pressed, the selection doesnt go to the end of the line, but to the "X" point of the mouse (I hope that makes sense).

Both functionality are in MS Visual C++ IDE
;---------------------------------------------------------------------------------------
Thanks sol
In Visual Studio and EditPlusis are an option "windows list".
I would like press for ex. f2 and go to the opened window (it will be very fast selection without use mouse)
By "windows list" you can
1. select window (active)
2. multiselect windows and close it
3. title selected windows


now navigate by project explorer takes to much time.
;---------------------------------------------------------------------------------------
shoorick
i think it is just enough to improve project explorer behavior:
1.hot key to go to proj expl. window
2.when file selected in project explorer hit enter or mouse (dbl)click brings this window forward and get there keyboard focus (i mean it is impossible currently walk through explorer with arrow keys, and clicking filename within it with mouse brings window forward, but gives no keyboard focus to it)

;---------------------------------------------------------------------------------------

masquer
Another good feature would be displaying first line(s) of macro/procs/global and local variables in a small window.
A good sample of such a features is http://www.sourceinsight.com Please, take a look at this application and you'll find a good source of ideas to implement.

;---------------------------------------------------------------------------------------

-"change status" from "externally opened" to "included to project" (e.g. 101 -> 1) - it is needed for conversion... or i'll be searching other way: open converted project in new instance of winasm, or other - it is nice looking conversion, untill you will change source... then you will always get notification "file changed externally"...(Thanks shoorick)

-why doesn't the menus are not displayed at design time or maybe you could do
> this fix for your next update or something(Thanks cegy)

-I want to use Pelle Orinius' linker instead of standard Microsoft's one(Thanks DELTA\_1)
-POLINK and POLIB are great! They make much smaller .exe's(Thanks Mark Jones)

;---------------------------------------------------------------------------------------
;scud:

---

-WinAsm to scan all **.inc file on project, declare with "include" and all user create const declare in this**.inc file to add in popup menu for const. Scan and **.asm file from ".const" and add this is constant in popup menu also(Thanks scud)
1.) When i close project from "File"->"Close project" menu "File"->"Open..." and button "Open" don't work. //W2k+SP4 WinAsm 4.0.1.266//
;---------------------------------------------------------------------------------------**

-Please if possible include in WinAsm an debuger :-) with visual step by step control of code.(line by line and CPU reg. ...)(Thanks vuckovic)

--Undo-Redo for dialog editor(Thanks blues)
> -Under Construction: Undo For Create Control
> -ToDo:HeapFree UndoMemory when dialog is deleted or VRE unloads
> -ToDo:Messagebox that when a dialog is deleted can not be undone

-Invoke CreateWindowEx, WS\_EX\_APPWINDOW, szClass, NULL, WS\_POPUP or \ As far as I know, the calltip will stop doing the job after the '\' in the next line. Could you please add support this?(Thanks L33t\_Onl3y)


-Files&Paths: WinAsm should seperate include and lib paths (e. g. C:\MASM32\Include;C:\WinAsm\Inc should be parsed to ml.exe as /I"C:\MASM32\Include" /I"C:\WinAsm\Inc")(Thanks DarkSoul,Jnrz7)

-SafeSubclass (Thanks Qvasimodo)

-is it possible to add the feature that you can also set relative paths in Tools->Options->Files&Paths?(Thanks Marwin)

-SS\_SUNKEN problem Statics (recreation for style change,move or size) (Thanks Marwin)

-Option Proc (not shown as procedures and not draw line)
-Proto proc for modules and not enumerate the procedures of modules in the project asm files

;-----------------------------------------------------------------------------------
Qvasimodo
1) Just a quick feature request: I'd like the resource editor to support user-defined resource type strings. For example this line:

IDI\_IMAGE1  IMAGE DISCARDABLE   "Res/Splash.jpg"


will cause WinAsm to stop parsing the resource script in visual mode.


;-----------------------------------------------------------------------------------
IanB, teDDy
intellisense does not recognize Global variables or structure members of structure members YET
;-----------------------------------------------------------------------------------
-Can you make the undocked Output Window not always ontop? it's annoying when it gets in the way(Thanks Porkster)

-If I set a bookmark on a line with a call to a procedure, then if I right click on the procedure and select goto block, the bookmark is removed from the line. Then if I scroll back to the line and try to set the bookmark again, WinAsm refuses to set it(Thanks JimG)
;-----------------------------------------------------------------------------------
rubs
1) It would be nice if you included an updated changelog.txt (with all changes, not only the latest ones) with each release or patch file. This would make it easier to track the fixes and enhancements.
;-----------------------------------------------------------------------------------




;-----------------------------------------------------------------------------------
Qvasimodo
1.
When you type something like this:

CODE
invoke dwtoa,


intellisense turns it into:

CODE
invoke DdeAbandonTransaction,


because it's the closest match it can find. I know I should hit Esc before the colon, but it's still a bit annoying. Could you make the autocomplete popup close itself when the word being typed no longer matches a known procedure name?




2.I just tried linking an addin using the Debug mode, and got this error message from the linker. I think the problem was that the command line parameters were wrong, but that's not important -- the thing is WinAsm failed to see the linker's output as an error...


QUOTE
C:\masm32\Bin\ML /c /coff /Cp /nologo /Fm /Zi /Zd /D /I"C:\masm32\Include" "C:\WinAsm\Projects\AManager\AManager.asm"

Assembling: C:\WinAsm\Projects\AManager\AManager.asm

C:\masm32\Bin\Link @"C:\WinAsm\Projects\AManager\link.war"

Microsoft ® Incremental Linker Version 5.12.8078
Copyright © Microsoft Corp 1992-1998. All rights reserved.

/SUBSYSTEM:WINDOWS /DEBUG /VERSION:4.0 "/LIBPATH:C:\masm32\Lib" /DLL "/DEF:C:\WinAsm\Projects\AManager\AManager.def" "C:\WinAsm\Projects\AManager\AManager.obj" "C:\WinAsm\Projects\AManager\AManager.res" "/OUT:\WinAsm\AddIns\AManager.dll"
c:\tmp\lah285.TMP : fatal error LNK1136: invalid or corrupt file

Make finished. 0 error(s) occured.



So I figured maybe WinAsm is only catching link errors when the output file name is given. Then some rare kind of errors would be ignored


I think this happened because I used the /D switch with no parameters... but it could also have had something to do with the fact that the partition I was working on had very little free space. If the switch doesn't work, try setting your temp folder to another partition, a diskette, or a ram drive
;-----------------------------------------------------------------------------------






TO DO:

---

-I'd like to suggest being able to customize what parts of the Intellisense capabilities are turned on. I like being able to see the api parameters for example, but would like to be able to turn off the function autocomplete at times. I think it would be good if the individual intellisense features could be switched on/off.(Thanks newbie)


2.What if i want the items to be evenly spaced? This feature should be usefull both horzontally and vertically. This could maybe done by considering the top most and bottom most item as fixed, and to have the space between items calculated as the sum of existing spaces divided by the number of items - 1(Thanks thierry)

3.This has maybe already be asked, but a nice feature should be the ability to select multiple items and then modify the common attributes. For example to make all not visible, ...(Thanks thierry)
VISIBLE
DISABLED
TABSTOP
GROUP
LEFT (to allow accurate positionning)
TOP (to allow accurate positionning)


Qvasimodo

---

if all controls are of the same class, set or remove any style bits. If controls are of different classes, only those bits common to all windows (WS**_flags).
For the interface, the existing dialog would do, but the style bits need three states instead of two: set, clear, and "don't change"_

-Intellisense for global variables.(Thanks Mieuws,PhoBos,cu.Pegasus,Bi\_Dark).**

-When saving a file as check whether there is already another one with exactly the same name(Thanks Qvasimodo for similar bug report)

-Also i have a problem with the window opening up at center of screen. Where ever i put that window when i close down i want it to be back where i left it.(Thanks cmax)

-how about give the user the options of moving buttons where we may want to see them. Your lay-out is boss but i would like to move a button or two when i use XP(Thanks cmax)

-Tab for opened files(Thanks iceberg,PaulZhao)


---

cmax

---

When we click the Find button it would be nice to have a find next find previous buttons on each side of the FIND button just like WordPerfect.



---


JimG

---

2. After making a new folder in the proper place and saying ok, the files are saved with their original names. Is there some way to specify the names to use when saving the new project when they are first being saved rather than having to change each one individually after they are saved?

sceptor

---

Compile vxd's


Mieuws

---

1.When typing the arguments of an invoke call, The above mentioned arguments list disappears when continuing the arguments on a new line (with the \ character at the end of the first line), it'd be nice if you could change it so that it would keep visible when starting a new line

masquer

---

Is it hard to add floating interactive panel which could show me my macros, structures, procs when I pointed on them. Like SourceInsight 3.5 does - very nice feature.


---

TheOne

---

-At the RC Options : When i select multi object (Button...) The Align Bottoms, Make same width, make same height, make same size is enabled, Normal those button are disabled, because we don't need those when we select one object.

andrew\_k

---

1.	I found the ability to expand or collapse procedures a wonderful feature.
> None of the IDE's I have used before have had this. It made navigating the
> code so much easier , especially when you were dealing with a file of nearly
> 6000 lines. However I would love it if this was expanded so other code blocks
> (.If blocks for instance) could also be collapsed

2. When you select a large area of code (say over 50 lines) and indent or unindent it the process takes a couple of seconds. I would love it if the speed of this operation could be increased.


BerniR

---

-It'd be great to have a toolbar button for the output window.

thomasantony

---

Save Styles not in hex.

defbase.

---

When there are no asm files open in the project, if you right click on the project it auto opens an asm file - Really annoying! Right click shouldn't open files, it should open a popup menu. If there is no valid context menu, don't let it do anything.

WinCC

---

-Debugger
-If I open a .asm file with WinAsm it would be nice to have the ability to create
> a new project with that file.


JohnnyQuest

---

Print Line Numbers
Print with smaller font
Print Highlighting



2.Export Procedure-def files (Thanks maCo).


---

golemxiii

---

- The code folding tag must be inserted in the source file. Then you can load the same folded-code you save.
- You can fold anything you want.
- Nested folding are allowed
- When you fold a peace of code, you want see the first line of the folded code :

Example :

[[;this is the first line

; anything you want

]]

become :

[[;this is the first line]]


[[toto proc ;my proc

ret
toto endp]]

[[proc;my proc](toto.md)]

You coud change the color of the folded code (and sub the [[ ]]), etc...

You can modify some of automatisations (that you can disable) :

"toto proc" + return

become :

[[toto proc
ret
toto endp]]





---

cu.Pegasus

---

- the resourcetype "RCDATA" is missing. In case of that, such resources aren't shown by using the listview via [RESOURCES](RESOURCES.md)[OTHERS](OTHERS.md)[RESOURCES](RESOURCES.md). But it is possible to use them (adding to RC-file manualy)

- there are several other resource types not known at the moment.

EDIT: list of resource types...
Resource types - import by ordinal
RT\_CURSOR       equ 1    RC.EXE: CURSOR
RT\_BITMAP       equ 2    RC.EXE: BITMAP
RT\_ICON         equ 3    RC.EXE: ICON
RT\_MENU         equ 4    RC.EXE: MENU
RT\_DIALOG       equ 5    RC.EXE: DIALOG
RT\_STRING       equ 6    RC.EXE: STRING / STRINGTABLE
RT\_FONTDIR      equ 7    RC.EXE: FONTDIR
RT\_FONT         equ 8    RC.EXE: FONT
RT\_ACCELERATOR  equ 9    RC.EXE: ACCELERATOR
RT\_RCDATA       equ 10   RC.EXE: RCDATA
RT\_MESSAGETABLE equ 11   RC.EXE: MESSAGETABLE
RT\_GROUPCURSOR  equ 12   RC.EXE: 12 - autogen, pointer to RT\_CURSOR
RT\_GROUPICON    equ 14   RC.EXE: 14 - autogen, pointer to RT\_ICON
RT\_VERSIONINFO  equ 16   RC.EXE: VERSIONINFO
RT\_DLGINCLUDE   equ 17   RC.EXE: DLGINCLUDE
RT\_PLUGPLAY     equ 19   RC.EXE: PLUGPLAY
RT\_VXD          equ 20   RC.EXE: VXD
RT\_ANICURSOR    equ 21   RC.EXE: ANICURSOR
RT\_ANIICON      equ 22   RC.EXE: ANIICON
RT\_HTML         equ 23   RC.EXE: HTML
RT\_MANIFEST     equ 24   RC.EXE: 24

Resource types - import by name
RT\_WAVE
RT\_AVI
RT\_IMAGE

---


90.Customized trigger keyword for API Functions List(Thanks Bi\_Dark).

100.JMP or CALL -->popup list with labels.

110.JMP CALL RET RETN etc etc must not pop variable list.

140.Customized keyboard shortcuts(Thanks TBD).

150.Tell if we are at .data, .data?, .const sections.

180.If procedure is multiline, second line onwards are considered normal lines and thus variable list popups.

190.Redesign procedures popup list.

200.Do not enumerate procedures if in comment, comment block, or string.

210.Project Structures in the Structures & variables list.
> (Those in comment blocks or not matching xxx Struct with xxx EndS
> > not taken into account

220.Project Structures Members Parser. Perfect(those members commented

> not taken into account).]]]]]]]]]]]]]]]]

230.'Invoking' functions is allowed only within Procedures and
> Macros otherwise Error.MUST CHECK whether in .CODE section.

240.Debug.PrintDec etc.....

250.Bold font.

280.Drag n'drop

290.Save Toolbars position.

300.Option for empty window for New Projects.

320.GetFont Dialogs in one procedure(less size).

340.Comments Italic/not Italic.

360.User can change DEFAULT command line options for ML, Link, RC by editing
> the ini file(Thanks Masmer).

370.(Two sets of command line options (release and debug modes)that are not hard coded.)(Thanks Masmer)

380.I really like the assembler\linker options dialog box that Negatory
> Assembly Studio has, despite not quite working. Any possibility of someday
> adding dialogs like this to WinASM to give users maximum flexibility when
> it comes to assembling\linking(Thanks Masmer)

390.Single Procedure/whole file view button (Thanks Manos).
> Small limitation: First And Last lines must be always visible-RaEdit limitation.

391(Thanks Caleb) I have a suggestion about the Line Nr Width option..
It's set to Auto here, and I have a file whose maximum line is 196.
But WinASM still appends the line number with 00. So it's 00196.
Why can't it have 196 as the max number, and the rest look like:
001
002
...
035
..
099
100
...
196

392.Be able to change fonttahoma (Thanks Kestrel)

Before Every New Upload

---

1.Make Smaller size.

2.Comment Debug inc and lib

;--------------------------------------------------------------------------

SOL\_bl

---


Sugestions:
3. add option (rebuilid all ->sometimes it is very usefully rebulid all
files in project)
5. add autosave after some time (time should be set by user)


;---------------------------------------------------------------------------
andrew\_k:

---


1.I found the ability to expand or collapse procedures a wonderful feature.
None of the IDE's I have used before have had this. It made navigating the
code so much easier , especially when you were dealing with a file of nearly
6000 lines. However I would love it if this was expanded so other code blocks
(.If blocks for instance) could also be collapsed plus ANY area of code the
user selects.

2.When you select a large area of code (say over 50 lines) and indent or
unindent it the process takes a couple of seconds. I would love it if the
speed of this operation could be increased.

6. The Output window handle should really be on the left of the window.

;---------------------------------------------------------------------------
JohnnyQuest

---

-When mouse cursor is held over a block the prog will display a popup window
> containing informaion about that block which is taken from remark lines
> immediately above the objects declaration in the code. There is a similar
> feature in RadASM but you must manually enter the information. I think Visual
> Studio 6 does this for your function declarations in C++.

;---------------------------------------------------------------------------
Bi\_Dark:

---

2.Smart Tabulation(Bi\_Dark).

3.h4ng4m3:
  1. When Show Linenumbers then when drag mouse still don't scrollbar.
> -This was a little a bit difficult to understand but finally I did! OK will be fixed.

;---------------------------------------------------------------------------
Manos

---

2.Фп рлбЯуйп рпх емцбнЯжефбй ьфбн кйнеЯт кЬрпйп control рЬнщ уфп dialog иб
Юфбн кблэфесп бн Юфбн еуфйгмЭнз гсбммЮ бнфЯ гйб ухмрбгЮт.

8.ґПфбн ереоесгЬжпмбй кЬфй уфйт Resources ен гЭней,фп Undo ден лейфпхсгеЯ.

9.ґПфбн кЬнейт бллбгЭт уе кЬрпйб йдйьфзфб еньт control, з енЭсгейб ден бнфбнбклЬфбй бмЭущт уфп control.


cu.Pegasus

---

FILE: MasmApiConst.vaa (INSERT)

dwFreeType'=MEM\_DECOMMIT,MEM\_RELEASE

dwFlags''=TH32CS\_INHERIT,TH32CS\_SNAPALL,TH32CS\_SNA
PHEAPLIST,TH32CS\_SNAPMODULE,TH32CS\_SNAPPROCESS,TH3
2CS\_SNAPTHREAD

flAllocationType'=MEM\_COMMIT,MEM\_RESERVE,MEM\_RESET
,MEM\_TOP\_DOWN

flProtect'=PAGE\_READONLY,PAGE\_READWRITE,PAGE\_EXECU
TE,PAGE\_EXECUTE\_READ,PAGE\_EXECUTE\_READWRITE,PAGE\_G
UARD,PAGE\_NOACCESS,PAGE\_NOCACHE

flNewProtect'=PAGE\_READONLY,PAGE\_READWRITE,PAGE\_EX
ECUTE,PAGE\_EXECUTE\_READ,PAGE\_EXECUTE\_READWRITE,PAG
E\_GUARD,PAGE\_NOACCESS,PAGE\_NOCACHE


FILE: MasmApiCall.vaa (CHANGE)

OLD: CreateToolhelp32Snapshot,dwFlags,th32ProcessID
NEW: CreateToolhelp32Snapshot,dwFlags'',th32ProcessID

OLD: VirtualAlloc,lpAddress,dwSize,flAllocationType,flP
rotect
NEW: VirtualAlloc,lpAddress,dwSize,flAllocationType',fl
Protect'

OLD: VirtualAllocEx,hProcess,lpAddress,dwSize,flAllocat
ionType,flProtect
NEW: VirtualAllocEx,hProcess,lpAddress,dwSize,flAllocat
ionType',flProtect'

OLD: VirtualFree,lpAddress,dwSize,dwFreeType
NEW: VirtualFree,lpAddress,dwSize,dwFreeType'

OLD: VirtualFreeEx,hProcess,lpAddress,dwSize,dwFreeType

NEW: VirtualFreeEx,hProcess,lpAddress,dwSize,dwFreeType
'

OLD: VirtualProtect,lpAddress,dwSize,flNewProtect,lpflO
ldProtect
NEW: VirtualProtect,lpAddress,dwSize,flNewProtect',lpfl
OldProtect

OLD: VirtualProtectEx,hProcess,lpAddress,dwSize,flNewPr
otect,lpflOldProtect
NEW: VirtualProtectEx,hProcess,lpAddress,dwSize,flNewPr
otect',lpflOldProtect


FILE: MasmApiStruct.vaa (INSERT)

HICON ; in the end of this file

As told already in masmforum, the ThreadEnvironmentBlock has the wrong size in windows.inc. The correct size is 34h (NT AND 9X!) Here are the correct structures (for implementation in windows.inc):

code:--------------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-- Thread Environment Block (TEB aka TIB)
;-- OS: Windows NT/2K/XP/2K3
;-----------------------------------------------------------------------------
NT\_THREADENVIRONMENTBLOCK struct               ; size = 34h
> ExceptionList                   DWORD ?      ; 00h end of SEH chain
> StackBase                       DWORD ?      ; 04h
> StackLimit                      DWORD ?      ; 08h
> SubSystemTIB                    DWORD ?      ; 0Ch
> FiberData                       DWORD ?      ; 10h
> ArbitraryUser                   DWORD ?      ; 14h
> pSelf                           DWORD ?      ; 18h pointer to TEB (7FFDE000h)
> pEnvironmentPtr                 DWORD ?      ; 1Ch
> ProcessID                       DWORD ?      ; 20h (see Taskmanager!)
> ThreadID                        DWORD ?      ; 24h
> pRPCHandle                      DWORD ?      ; 28h
> TLSStorage                      DWORD ?      ; 2Ch
> PEBAddress                      DWORD ?      ; 30h pointer to PEB (7FFDF000h)
NT\_THREADENVIRONMENTBLOCK ends

;-----------------------------------------------------------------------------
;-- Thread Environment Block (TEB aka TIB)
;-- OS: Windows 95/98/98SE/ME
;-----------------------------------------------------------------------------
WX\_THREADINFORMATIONBLOCK struct               ; size = 34h
> ExceptionList                   DWORD ?      ; 00h end of SEH chain
> StackBase                       DWORD ?      ; 04h
> StackLimit                      DWORD ?      ; 08h max stack value
> pTDB                            WORD  ?      ; 0Ch
> pThunkSS                        WORD  ?      ; 0Eh
> Unknown                         DWORD ?      ; 10h
> ArbitraryUser                   DWORD ?      ; 14h
> pSelf                           DWORD ?      ; 18h pointer to TIB
> TIBFlags                        WORD  ?      ; 1Ch
> Win16MutexCount                 WORD  ?      ; 1Eh
> DebugContext                    DWORD ?      ; 20h
> pCurrentPriority                DWORD ?      ; 24h
> pQueue                          DWORD ?      ; 28h
> TLSStorage                      DWORD ?      ; 2Ch


> pProcess                        DWORD ?      ; 30h pointer to process database
WX\_THREADINFORMATIONBLOCK ends

---



To use this structures in WinASM;
FILE: MasmApiStruct.vaa (INSERT)

NT\_THREADENVIRONMENTBLOCK,ExceptionList,StackBase,
StackLimit,SubSystemTIB,FiberData,ArbitraryUser,pS
elf,pEnvironmentPtr,ProcessID,ThreadIS,pRPCHandle,
TLSStorage,PEBAddress

WX\_THREADENVIRONMENTBLOCK,ExceptionList,StackBase,
StackLimit,pTDB,pThunkSS,Unknown,ArbitraryUser,pSe
lf,TIBFlags,Win16MutexCount,DebugContext,pCurrentP
riority,pQueue,TLSStorage,pProcess

NOT TO DO ???

---


-it would be nice if it would be possible to set own width to the first tab at the line (eg. first tab - 16 chars, all other - 4, or even 2).(Thanks shoorick, Bohdan200)

-I usually find it more important to know the column number (for proper formatting) than the character number. Perhaps you could show both(Thanks Qvasimodo)

-Another wish: it would be nice if, when working on a project with multiple modules, the "Assemble" button would only assemble the current module (instead of all of them). If the active MDI child is not a module, assemble then all.(Thanks Qvasimodo)

-I think that the arrows on the right of the menu's (to indicate a submenu) are 1 pixel too high.(Thanks PhoBos)



# Features implemented #