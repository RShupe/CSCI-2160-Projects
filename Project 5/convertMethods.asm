;******************************************************************************************
;*  Program Name: convertMethods.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Project 6b
;*  Date:         Created 12/07/2019
;*  Purpose:      Methods to convert ascii characters to hex characters and vise versa, with encryption
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  						;Executes "normal" termination
;******************************************************************************************
.DATA
;******************************************************************************************
.CODE
COMMENT%
******************************************************************************
*Name: hexToCharacter                                                        *
*Purpose:                                                                    *
*	  Intakes a address of hex chars, converts them to ascii, then returns a *
*		new address with ascii characters									 *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/28/2019                                                   *
*                                                                            *
*@param lpDestination:dword                                                  *
*@param lpSource:dword                                                       *
*@param numBytes:dword                                                       *
*****************************************************************************%
hexToCharacter PROC stdcall, lpDestination:dword, lpSource:dword, numBytes:dword
PUSH EBP					;preserve old stack frame
MOV EBP, ESP				;set a new stack frame

.IF numBytes == 0			;if it is equal to 0
	MOV EDI, 4				;if the number of bytes is 0, then we are going to treat the 2nd param as a dword
.ELSE						;if it is not 0
	MOV EDI, numBytes		;if it is not 0 then we will put the number of bytes to be converted into edi
.ENDIF						;endif
MOV EBX, lpSource

.WHILE EDI != 0
	MOV EAX, byte ptr [EBX + EDI]
	ADD EAX, 30
	MOV byte ptr [EDX + EDI], EAX
	DEC EDI
.ENDW
MOV EAX, 0
POP EBP						;retore previous stack frame
RET 12						;return back with 12 bytes used
hexToCharacter ENDP

COMMENT%
******************************************************************************
*Name: charTo4HexDigits                                                      *
*Purpose:                                                                    *
*	  Accepts a null terminated strings and returns a dword mask    		 *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/28/2019                                                   *
*                                                                            *
*@param lpSourceString:dword                                                 *
*@returns dMask:dword                                                        *
*****************************************************************************%
charTo4HexDigits PROC stdcall, lpSourceString:dword
charTo4HexDigits ENDP

COMMENT%
******************************************************************************
*Name: encrypt32Bit                                                          *
*Purpose:                                                                    *
*	  Intakes a address of hex chars, converts them to ascii, then returns a *
*		new address with ascii characters									 *
*Date Created: 11/28/2019                                                    *
*Date Modified: 11/28/2019                                                   *
*                                                                            *
*@param lpSourceString:dword                                                 *
*@param dMask:dword                                                          *
*@param numBytes:dword                                                       *
*****************************************************************************%
encrypt32Bit PROC stdcall, lpSourceString:dword, dMask:dword , numBytes:dword
encrypt32Bit ENDP
;************************************* the instructions below calls for "normal termination"	

END