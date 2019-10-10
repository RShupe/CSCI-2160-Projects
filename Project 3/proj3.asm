;******************************************************************************************
;*  Program Name: proj3.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:          Proj3
;*  Date:         10/19/2019
;*  Purpose:      
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
;******************************************************************************************
;  List all necessary prototypes for methods to be called here
	ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD  					;Executes "normal" termination
	intasc32 PROTO NEAR32 stdcall, lpStringToHold:dword, dval:dword			;Will convert any D-Word number into ACSII characters
	putstring  PROTO NEAR stdcall, lpStringToDisplay:dword  				;Will display ;characters until the NULL character is found
	getstring 	PROTO stdcall, lpStringToHoldInput:dword, maxNumChars:dword ;Get input from user and convert. 
	ascint32 PROTO NEAR32 stdcall, lpStringToConvert:dword  				;This converts ASCII characters to the dword value
	HeapDestroyHarrison PROTO Near32 stdcall								;Creates memory on the heap (of dSize words) and returns the address of the 
																			;start of the allocated heap memory
	HeapAllocHarrison PROTO Near32 stdcall, dSize:DWORD 					;Destroys the allocated heap storage created through heapAllocHarrison
;******************************************************************************************
;EXTERN externalProc:near
;******************************************************************************************
COMMENT %
******************************************************************************
*Name: DisplayString                                                         *
*Purpose:                                                                    *
*	The purpose of this macro is to display a set of strings to the console  *
*                                                                            *
*Date Created: 10/02/2019                                                    *
*Date Modified: 10/02/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%

DisplayString MACRO String:REQ
	INVOKE putstring, ADDR String     				;;display The string passed in 
ENDM

COMMENT %
******************************************************************************
*Name: PullString                                                            *
*Purpose:                                                                    *
*	The purpose is to get information from the user and store into a variable*
*                                                                            *
*Date Created: 10/09/2019                                                    *
*Date Modified: 10/09/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*@param limit:byte                                                           *
*****************************************************************************%

PullString MACRO String:REQ, limit:REQ
		INVOKE getstring, ADDR String, limit		;Take the string input and store it into a variable, max amount of chars typed is sNumChars
		INVOKE ascint32, ADDR String				;Convert the ASCII value to its true decimal number
ENDM

COMMENT %
******************************************************************************
*Name: CvtoNum                                                               *
*Purpose:                                                                    *
*	converts a string to its real decimal number.                            *
*                                                                            *
*Date Created: 10/09/2019                                                    *
*Date Modified: 10/09/2019                                                   *
*                                                                            *
*                                                                            *
*@param String1:byte                                                         *
*****************************************************************************%
CvtoNum MACRO String:REQ
	INVOKE ascint32, ADDR String					;Convert the ASCII value to its true decimal number
ENDM

;******************************************************************************************
	.DATA
	strProjInfo byte  10,13,9,
        "Name: Ryan Shupe",10,
"       Class: CSCI 2160-001",10,
"        Date: 10/19/2019",10,
"         Lab: Project 3",0
	strRectangleLength byte 10,10, "Enter a whole number length for a rectangle [3,25]: ", 0
	strRectangleWidth byte 10,10, "Enter a whole number width for a rectangle [3,25]: ", 0
	strTriangleHeight byte 10,10, "Enter a whole number height for a right triangle [4,25]: ", 0
	strSolidRectangleInfo byte 10,10, "This is a rectangle with input dimensions $recLength by $recWidth: "
	strHallowRectangleInfo byte 10,10, "This is the same rectangle hollowed out: "
	strSolidTriangleInfo byte 10,10, "This is a right triangle with height $Triheight: "
	strHallowTriangleInfo byte 10,10, "This is the same right triangle hollowed out: "
	crlf byte  10,13,0																		;Null-terminated string to skip to new line
	recLength byte ?
	recWidth byte ?
	triHeight byte ?
	
	
;******************************************************************************************
	.CODE
	
_start:
	MOV EAX, 0										;Statement to help in debugging
	
main PROC

	DisplayString strProjInfo						;calls the display string macro as passes in the project information.
	
getRectangleLength:	
	DisplayString strRectangleLength				;calls the display string macro as passes in the length string.
	PullString recLength, 2							;get the user specified string and store into a variable, also in EAX
	CvtoNum recLength								;convert the value to its true decimal number so we can actually use it.
	
	CMP EAX, 0										;Compare EAX to 0 to see if the user typed null character
	JE getRectangleLength							;If it is null then jump to getRectangleLength
	CMP EAX, 25										;Compare EAX to 25 to see if the user typed a number greater than 25.
	JG getRectangleLength							;If greater than, jump to getRectangleLength
	CMP EAX, 3										;Compare EAX to 3 to see if it is less than 3	
	JL getRectangleLength							;If so, jump to getRectangleLength 
	
	
getRectangleWidth:	
	DisplayString strRectangleWidth					;calls the display string macro as passes in the length string.
	PullString recWidth, 2							;get the user specified string and store into a variable, also in EAX
	CvtoNum recWidth								;convert the value to its true decimal number so we can actually use it.
	
	CMP EAX, 0										;Compare EAX to 0 to see if the user typed null character
	JE getRectangleWidth							;If it is null then jump to getRectangleWidth
	CMP EAX, 25										;Compare EAX to 25 to see if the user typed a number greater than 25.
	JG getRectangleWidth							;If greater than, jump to getRectangleWidth
	CMP EAX, 3										;Compare EAX to 3 to see if it is less than 3	
	JL getRectangleWidth							;If so, jump to getRectangleWidth 
	JMP displayRectangle
	
	
displayRectangle:	
	DisplayString strSolidRectangleInfo				;calls the display string macro and passes in the specified string and shows this is a rectangle with the specified dims.
	DisplayString crlf								;calls the display string macro and passes in the specified string to skip to a new line.
	DisplayString strHallowRectangleInfo			;calls the display string macro and passes in the specified string and tells user that this is the hollowed rectangle.
	JMP getTriangleHeight
	
	
getTriangleHeight:	
	DisplayString strTriangleHeight					;calls the display string macro as passes in the length string.
	PullString triHeight, 2							;get the user specified string and store into a variable, also in EAX
	CvtoNum triHeight								;convert the value to its true decimal number so we can actually use it.
	
	CMP EAX, 0										;Compare EAX to 0 to see if the user typed null character
	JE getTriangleHeight							;If it is null then jump to getRectangleWidth
	CMP EAX, 25										;Compare EAX to 25 to see if the user typed a number greater than 25.
	JG getTriangleHeight							;If greater than, jump to getRectangleWidth
	CMP EAX, 4										;Compare EAX to 4 to see if it is less than 4	
	JL getTriangleHeight							;If so, jump to getRectangleWidth 
	JMP displayTriangle
	
displayTriangle:	
	DisplayString strSolidTriangleInfo				;calls the display string macro and passes in the specified string to show information about the solid triangle.
	DisplayString crlf								;calls the display string macro and passes in the specified string to skip to a new line.
	DisplayString strHallowTriangleInfo				;calls the display string macro and passes in the specified string telling user this is the hollowed triangle.
	
	MOV EAX, 0										;Statement to help in debugging
	JMP finished

;************************************* the instructions below calls for "normal termination"	
finished:
	INVOKE ExitProcess,0						 
	PUBLIC _start
	
main ENDP
	END												;Signals assembler that there are no instructions after this statement