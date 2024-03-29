;******************************************************************************************
;*  Program Name: strings.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj3
;*  Date:         10/19/2019
;*  Purpose:      A couple string classes that can intake a string and count bytes, and 
;*				  also intake a string and copy it.
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
heapAllocHarrison PROTO Near32 stdcall, dSize:DWORD 							;Creates memory on the heap (of dSize words) and returns the address of the
;******************************************************************************************
.data
	numBytes dword ?			;memory to hold the number of bytes in a string
	bChar byte ?				;memory to hold a char to put into memory 
	originalAddr dword ?		;original address of a string
	cpAddr dword ?				;new address of a string after copying

;******************************************************************************************
.code

COMMENT %
******************************************************************************
*Name: sizeOfString                                                          *
*Purpose:                                                                    *
*	counts the number of bytes in a string and returns the number in eax     *
*                                                                            *
*Date Created: 10/12/2019                                                    *
*Date Modified: 10/12/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:dword                                                        *
*@returns numOfBytes:dword													 *
*****************************************************************************%
sizeOfString PROC Near32
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	PUSH EBX							;pushes EBX to the stack to store this
	PUSH ESI							;pushes ESI to the stack to preseve
	MOV EBX, [EBP + 8]					;moves into ebx the first val in the stack that we are going to use
	MOV ESI, 0							;sets the initial point to 0
		
	stLoop:
		CMP byte ptr [EBX + ESI], 0		;compares the two positions to determine if this is the end of the string
		JE finished						;if it is jump to finished
		INC ESI							;if not increment esi
		JMP stLoop						;jump to the top of the loop and look at the next char
	finished:		
		INC ESI							;increment esi to include the null character in the string
		MOV EAX, ESI					;move the value of esi into eax for proper output and return
	
	POP ESI								;restore original esi
	POP EBX								;restore original ebx
	POP EBP								;restore originla ebp
	RET									;return
sizeOfString ENDP

COMMENT %
******************************************************************************
*Name: createStringCopy                                                      *
*Purpose:                                                                    *
*	accepts an address, makes a copy, sends back new addr in EAX		     *
*                                                                            *
*Date Created: 10/12/2019                                                    *
*Date Modified: 10/12/2019                                                   *
*                                                                            *
*                                                                            *
*@param Addr1:dword                                                          *
*@returns Addr2:dword														 *
*****************************************************************************%
createStringCopy PROC Near32
	PUSH EBP							;preserves base register
	MOV EBP, ESP						;sets a new stack frame
	PUSH EBX							;pushes EBX to the stack to store this
	PUSH EDI							;preserve edi
	PUSH ESI							;pushes ESI to the stack to preseve

	MOV EBX, [EBP + 8]					;moves into ebx the address to the beginning of the original string.
	MOV originalAddr, EBX				;move the address in ebx into a variable
	MOV ESI, 0							;sets the initial point to 0
	MOV EDI, 0							;sets the initial offset to 0
	PUSH EBX							;store ebx into the stack
	CALL sizeOfString					;get the size of the string in bytes
	ADD ESP, 4							;add back the bytes we used
	MOV numBytes, EBX					;move the number of bytes in the string into its own variable
	MOV EBX, 0							;clear the ebx register so we can use it later. 

	INVOKE 	heapAllocHarrison, numBytes ;allocate space on the heap with the number of bytes we need. 
	MOV cpAddr, EAX						;move the address it gives us into its own variable 	
	MOV EAX, 0							;clear out eax to avoid issues
	MOV ESI, [originalAddr]				;move into EDI the derefrenced original address of the string
	topOfLoop:
		MOV BL, [ESI]					;move into BL the value at adress esi
		MOV bChar, BL					;move this into its variable 
		CMP bChar, 00					;compare it to 00 to see if we reached the end of the string
		JE finished						;if it is equal to 0, then jump to finished
		MOV AL, bChar					;moves the char into al so we can insert it at the new point
		MOV [cpAddr + EDI], EAX			;moves the value in eax into the new address offset edi
		INC EDI							;increment edi to get the next position in the new address
		INC ESI							;increment esi to get the next position in the original address
		JMP topOfLoop					;jump to the top of the loop with our incremented numbers. 
	finished:
		MOVSX EBX, bChar				;move into ebx the null character
		MOV [cpAddr + EDI], EBX			;moves the null character into the position in the new address
	MOV EAX, OFFSET cpAddr				;moves the address of the copyed address into EAX for return
	
	POP EBX								;restore original ebx
	POP ESI								;restore original esi
	POP EDI								;restore original ebx
	POP EBP								;restore original ebp
	RET									;return
createStringCopy ENDP
END