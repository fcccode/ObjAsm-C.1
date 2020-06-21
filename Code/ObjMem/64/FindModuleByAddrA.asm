; ==================================================================================================
; Title:      FindModuleByAddrA.asm
; Author:     G. Friedrich
; Version:    C.1.0
; Notes:      Version C.1.0, October 2017
;               - First release. Code from E. Hansen.
; ==================================================================================================


% include @Environ(OBJASM_PATH)\\Code\\OA_Setup64.inc
% include &ObjMemPath&ObjMem.cop
% include &IncPath&Windows\Psapi.inc

.code

; ��������������������������������������������������������������������������������������������������
; Procedure:  FindModuleByAddrA
; Purpose:    Find the module name from an address on a WinNT system.
; Arguments:  Arg1: Address.
;             Arg2: -> ANSI module name buffer.
; Return:     eax = number of characters copied into the buffer.

align ALIGN_CODE
FindModuleByAddrA proc uses rdi rsi rbx pAddress:POINTER, pModuleNameA:POINTER
  local dPID:DWORD
  local hProcess:HANDLE
  local hMods[1024]:HANDLE
  local cbNeeded:DWORD
  local ModInfo:MODULEINFO
  local hModule:HANDLE
  local hLib:HANDLE
  local pEnumProcessModules:POINTER
  local pGetModuleInformation:POINTER
  local cModName[MAX_PATH]:CHRA

  invoke GetModuleHandle, 0                             ;Important to ensure that
  invoke LoadLibraryA, $OfsCStr("psapi.dll")            ;  LoadLibrary works well
  test rax, rax
  jnz @F
  ret
@@:
  mov hLib, rax
  invoke GetProcAddress, hLib, $OfsCStrA("EnumProcessModules")
  mov pEnumProcessModules, rax
  test rax, rax
  jnz @F
  ret
@@:
  invoke GetProcAddress, hLib, $OfsCStrA("GetModuleInformation")
  mov [pGetModuleInformation], rax
  test rax, rax
  jnz @F
  ret
@@:

  mov rax, pModuleNameA
  m2z CHRA ptr [rax]                                    ;Set terminating zero

  mov rbx, pAddress
  invoke GetCurrentProcessId
  mov dPID, eax
  invoke OpenProcess, PROCESS_QUERY_INFORMATION + PROCESS_VM_READ, FALSE, dPID
  mov hProcess, rax

  lea r9, cbNeeded
  mov r8, 1024
  lea rdx, hMods
  mov rcx, hProcess
  call pEnumProcessModules
  test rax, rax
  jz @@Done
    mov edi, cbNeeded
    shr rdi, 2
    lea rax, hMods
    mov rsi, rax
@@L1:
    mov rax, [rsi]
    mov hModule, rax
    add rsi, 4

    mov r9, sizeof(MODULEINFO)
    lea r8, ModInfo
    mov rdx, hModule
    mov rcx, hProcess
    call pGetModuleInformation
    test rax, rax
    jz @@Done
    cmp rbx, ModInfo.lpBaseOfDll
    jg @@L2
      dec rdi
      or rdi, rdi
      js @@Done
      jmp @@L1
@@L2:
      mov eax, ModInfo.SizeOfImage
      add rax, ModInfo.lpBaseOfDll
      cmp rbx, rax
      jl @@L3
      dec rdi
      or rdi, rdi
      js @@Done
      jmp @@L1
@@L3:
    invoke GetModuleFileNameA, hModule, addr cModName, lengthof cModName
    invoke GetFileTitleA, addr cModName, pModuleNameA, lengthof cModName

@@Done:
  invoke CloseHandle, hProcess
  invoke FreeLibrary, hLib
  invoke StrLengthA, pModuleNameA
  ret
FindModuleByAddrA endp

end