; ==================================================================================================
; Title:      Demo02.asm
; Author:     G. Friedrich
; Version:    C.1.0
; Purpose:    ObjAsm demonstration program 2.
; Notes:      Version C.1.0, October 2017
;               - First release.
; ==================================================================================================


% include @Environ(OBJASM_PATH)\Code\Macros\Model.inc   ;Include & initialize standard modules
SysSetup OOP, WIN32, WIDE_STRING, DEBUG(WND)            ;Load OOP files and OS related objects

% includelib &LibPath&Windows\shell32.lib
% includelib &LibPath&Windows\shlwapi.lib

;Load or build the following objects
MakeObjects Primer, Stream, WinPrimer
MakeObjects Window, Dialog, DialogModal, DialogAbout
MakeObjects WinApp, SdiApp

include Demo02_Globals.inc                              ;Application globals
include Demo02_Main.inc                                 ;DemoApp02 object

.code
start proc                                              ;Program entry point
  SysInit                                               ;Runtime initialization of OOP model

  OCall $ObjTmpl(DemoApp02)::DemoApp02.Init             ;Initialize application
  OCall $ObjTmpl(DemoApp02)::DemoApp02.Run              ;Execute application
  OCall $ObjTmpl(DemoApp02)::DemoApp02.Done             ;Finalize application

  SysDone                                               ;Runtime finalization of the OOP model
  invoke ExitProcess, 0                                 ;Exit program returning 0 to the OS
start endp

end
