; ==================================================================================================
; Title:      StrCCopyW.asm
; Author:     G. Friedrich
; Version:    C.1.0
; Notes:      Version C.1.0, October 2017
;               - First release.
; ==================================================================================================


% include @Environ(OBJASM_PATH)\\Code\\OA_Setup64.inc
% include &ObjMemPath&ObjMem.cop

.code

; 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
; Procedure:  StrCCopyW
; Purpose:    Copy the the source WIDE string with length limitation.
;             The destination buffer should be big enough to hold the maximum number of
;             characters + 1.
; Arguments:  Arg1: -> Destination buffer.
;             Arg2: -> Source WIDE string.
;             Arg3: Maximal number of charachters to be copied.
; Return:     eax = Number of copied characters, not including the ending zero character.

align ALIGN_CODE
StrCCopyW proc uses rdi pBuffer:POINTER, pSrcStringW:POINTER, dMaxChars:DWORD
  ;rcx = pBuffer, rdx = pSrcStringW, r8d = dMaxChars
  mov rdi, rcx                                          ;rdi = pBuffer
  invoke StrCLengthW, rdx, r8d                          ;pSrcStr, dMaxChars
  shl eax, 1
  m2z CHRW ptr [rdi + rax]                              ;Set ZTC
  invoke MemShift, rdi, pSrcStringW, eax
  ret
StrCCopyW endp

end
