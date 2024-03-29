;******************************************************************************************
;*  Program Name: Student.asm
;*  Programmer:   Ryan Shupe
;*  Class:        CSCI 2160-001
;*  Lab:		  Proj 5
;*  Date:         Created 11/23/2019
;*  Purpose:      create a student class that can hold different attrubutes about a student
;*				   and create setters and getters
;******************************************************************************************
	.486						;This tells assembler to generate 32-bit code
	.model flat					;This tells assembler that all addresses are real addresses
	.stack 100h					;EVERY program needs to have a stack allocated
	.listall
;******************************************************************************************
memoryallocBailey PROTO Near32 stdcall, dSize:DWORD							;dynamically allocate bytes in memory
appendString	  PROTO Near32 stdcall, lpDestination:dword, lpSource:dword	;appends a strring to the end of an existing one
intasc32 proto Near32 stdcall, lpStringToHold:dword, dval:dword				;converts ints to ascii format
Student_setName PROTO stdcall, ths:dword, addrFirst:dword, addrLast:dword	;sets the name ofo a student
Student_getZip PROTO stdcall, ths:dword										;returns the zip of a student
Student_getName PROTO stdcall, ths:dword									;returns the name of a student
Student_getStreet PROTO stdcall, ths:dword									;returns the street 
getBytes PROTO stdcall, String1:dword										;returns the number of bytes in a string
Student_calcAvg PROTO stdcall, ths:dword									;calculates the average of the test scores and returns it
Student_letterGrade PROTO stdcall, ths:dword								;returns a letter grade corresponding to the test average
Student_setTest PROTO stdcall, ths:dword, score:word, numTest:word			;sets a test for a student
Student_getTest PROTO stdcall, ths:dword, numTest:word						;returns a test for a student
Student_setStreet PROTO stdcall, ths:dword, streetAddr:dword				;sets the street for a student
Student_setZip PROTO stdcall, ths:dword, inZip:dword						;sets the zip code for a student
Student_BasicInfo PROTO stdcall, ths:dword									;returns the name and address of a student 
;******************************************************************************************	
Student STRUCT 
	last byte 100 dup(0)							;space to hold the last name of the student
	first byte 100 dup(0)							;space to hold the first name of the student
	street byte 200 dup(0)							;space to hold the street address
	zip dword ?										;space to hold the zip
	test1 word ?									;word to hold the test score 1
	test2 word ?									;word to hold the test score 2
	test3 word ? 									;word to hold the test score 3
Student ENDS
;******************************************************************************************
.DATA
spaceChar byte 32,0									;memory to hold the space char
nullChar byte 10,0									;memory to hold the null char
nextLine byte 10,0									;memory to store the next line char
tempAddr dword ?									;memory to hold an address
tempVar dword ?										;memory to hold a dword

strTest1 byte "Test 1: ", 0
strTest2 byte "Test 2: ", 0
strTest3 byte "Test 3: ", 0
strAverage byte "Average: ", 0
strGrade byte "Grade: ", 0
;******************************************************************************************
.CODE

COMMENT%
******************************************************************************
*Name: Student_1                                                             *
*Purpose:                                                                    *
*	  Creates a student object with dynamic memory allocated                 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*****************************************************************************%
Student_1 PROC stdcall
	INVOKE memoryallocBailey, sizeof Student 			;allocates memory onto the heap the required amount for a student struct
	RET													;returns where I was called, address in EAX
Student_1 endp

COMMENT%
******************************************************************************
*Name: Student_2                                                             *
*Purpose:                                                                    *
*	  Creates a student object with enough memory allocated, with a name set *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param addrFirst:dword                                                      *
*@param addrLast:dword                                                       *
*****************************************************************************%
Student_2 PROC stdcall, firstN:dword, lastN:dword
	INVOKE memoryallocBailey, sizeof Student			;allocate enough memory to hold a student
	PUSH EAX											;store the address it gives
	INVOKE Student_setName, EAX, firstN, lastN			;set the name of the student
	POP EAX												;restore our pushed address of the student
	RET 8												;return back to where i was called cleaning 8 bytes, address in EAX
Student_2 ENDP

COMMENT%
******************************************************************************
*Name: Student_3                                                             *
*Purpose:                                                                    *
*	  Creates a student object with enough memory allocated, also intakes    *
*      another student and copies from it and fills the new student.		 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param sc:dword                                         		             *
*****************************************************************************%
Student_3 PROC stdcall uses EBX EDX EDI, sc:dword
	INVOKE memoryallocBailey, sizeof Student			;allocate enough memory to hold a student
	MOV tempAddr, EAX									;preserves address to the student
	MOV EBX, EAX										;move the allocated address into ebx
	ASSUME EBX:PTR Student								;assume ebx is a student
	MOV EDX, sc											;move into edx the address of the copy student
	ASSUME EDX:PTR Student								;let edx point to a student
	INVOKE Student_setName, EBX, addr [EDX].first, 		;sets the name of the student to the name of the one we are making a copy of
	addr [EDX].last
	INVOKE Student_getZip, EDX							;gets the zip of the copy student
	MOV tempVar, EAX									;moves the zip into the temp var
	INVOKE Student_setZip, EBX, addr tempVar			;sets the zip of the new student
	INVOKE Student_getStreet, EDX						;gets the street of the copy student
	INVOKE Student_setStreet, EBX, EAX					;sets the street of the new student
	INVOKE Student_getTest, EDX, 1						;get the first test of the copy student into ax
	INVOKE Student_setTest, EBX, AX, 1					;place the first test score into the new students test
	INVOKE Student_getTest, EDX, 2						;get the second test of the copy student into ax
	INVOKE Student_setTest, EBX, AX, 2					;place the second test score into the new students test
	INVOKE Student_getTest, EDX, 3						;get the third test of the copy student into ax
	INVOKE Student_setTest, EBX, AX, 3					;place the third test score into the new students test
	ASSUME EDX:PTR nothing								;edx doesnt point to a student anymore
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	MOV EAX, tempAddr									;restores address to the student
	RET 4												;returns back to where I was called with 4 bytes, address in eax.
Student_3 ENDP

COMMENT%
******************************************************************************
*Name: setName                                                               *
*Purpose:                                                                    *
*	  Intakes a student first and last name and stores it onto the heap address*
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param addrFirst:dword                                                      *
*@param addrLast:dword                                                       *
*****************************************************************************%
Student_setName PROC stdcall uses EBX, ths:dword, addrFirst:dword, addrLast:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx.
	ASSUME EBX:PTR Student								;assumes that ebx is a student pointer so we dont have to type that every line
	MOV EAX, addrFirst									;moves the address of the first name into eax 
	.IF byte ptr [EAX] == 0								;if the first name is null
	.ELSE												;if it is not null
		INVOKE appendString, addr [EBX].first, addrFirst;appends the first name string sent in onto the correct memory location	
		MOV EAX, addrLast								;moves the address of the last name into eax so we can check it
		.IF byte ptr [EAX] == 0							;if the last name is null
		.ELSE											;if the last name is not null
			INVOKE appendString, addr [EBX].last, addrLast;appends the last name string sent in ontto the correct memory location	
		.ENDIF											;endif
	.ENDIF												;endif
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;return to where I was called, cleaning 12 bytes.
Student_setName ENDP

COMMENT%
******************************************************************************
*Name: setTestScores                                                         *
*Purpose:                                                                    *
*	  Intakes a student and test scores and stores them in the appropriate   *
*			memory location 												 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param t1:word                                                              *
*@param t2:word                                                              *
*@param t3:word                                                              *
*****************************************************************************%
Student_setTestScores PROC stdcall, ths:dword, t1:word, t2:word, t3:word
	LOCAL bbyte:byte									;use local directive
	INVOKE Student_setTest, ths, t1, 1					;invokes the set test method to set the test for the first one		
	INVOKE Student_setTest, ths, t2, 2					;invokes the set test method to set the 2nd test
	INVOKE Student_setTest, ths, t3, 3					;invokes the set test method to set the 3rd test
	RET 												;return to where I was called, cleaning 12 bytes.
Student_setTestScores ENDP

COMMENT%
******************************************************************************
*Name: setTest                                                               *
*Purpose:                                                                    *
*	  Intakes a student and test scores and stores them in the appropriate   *
*			memory location 												 *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param score:word                                                           *
*@param testNum:word                                                         *
*****************************************************************************%
Student_setTest PROC stdcall uses EBX EDX, ths:dword, score:word, numTest:word	
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx.
	ASSUME EBX:PTR Student								;assumes that ebx is a student pointer so we dont have to type that every line
	
	.IF numTest == 1									;if the in test num is equal to 1
		MOV DX, score									;moves the first test into dx
		TEST DX, DX										;test dx with itself to set flags
		.IF SIGN?										;tests to see if the test score is negative
		.ELSE											;if it is not
			.IF DX <= 100								;checks to see if it is less than 100
				MOV [EBX].test1, DX						;moves the word into the memory location where test 1 is 
			.ENDIF										;end if
		.ENDIF											;endif
	.ELSEIF numTest == 2								;if the in test num is equal to 2
		MOV DX, score									;moves the first test into dx
				TEST DX, DX								;test dx with itself to set flags
		.IF SIGN?										;tests to see if the test score is negative
		.ELSE											;if it is not
			.IF DX <= 100								;checks to see if it is less than 100
				MOV [EBX].test2, DX						;moves the word into the memory location where test 1 is 
			.ENDIF										;end if
		.ENDIF											;endif
	.ELSEIF numTest == 3								;if the in test num is equal to 3
		MOV DX, score									;moves the first test into dx
		TEST DX, DX										;test dx with itself to set flags
		.IF SIGN?										;tests to see if the test score is negative
		.ELSE											;if it is not
			.IF DX <= 100								;checks to see if it is less than 100
				MOV [EBX].test3, DX						;moves the word into the memory location where test 1 is 
			.ENDIF										;end if
		.ENDIF											;endif 
	.ELSE												;if the test number is not 1-3
														;if this was java i would throw an exception here
	.ENDIF												;end if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;return to where i was called from and cleaning 8 bytes
Student_setTest ENDP

COMMENT%
******************************************************************************
*Name: setStreet                                                             *
*Purpose:                                                                    *
*	  Intakes a student and a street and copies the street onto the memory   *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param streetAddr:dword                                                     *
*****************************************************************************%
Student_setStreet PROC stdcall uses EBX EDX, ths:dword, streetAddr:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx.
	ASSUME EBX:PTR Student								;assumes that ebx is a student pointer so we dont have to type that every line
	MOV EDX, streetAddr									;moves the address into EDX
	MOV AL, byte ptr[EDX]								;moves the first byte into al
	.IF AL == 0											;if it is null
	.ELSE												;if it is not
		INVOKE appendString, addr [EBX].street, streetAddr;appends the street in into the location it should go onto the heap
	.ENDIF												;end if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;return to where i was called from and cleaning 8 bytes
Student_setStreet ENDP

COMMENT%
******************************************************************************
*Name: setZip                                                                *
*Purpose:                                                                    *
*	  Intakes a student and a dword zip code, then places the zip in, into   *
*     the student's zip                                                      *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param inZip:dword                                                          *
*****************************************************************************%
Student_setZip PROC stdcall uses EBX EDX, ths:dword, inZip:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:ptr Student								;assumes ebx is a student pointer so we dont have to type it 
	MOV EDX, inZip										;moves the zip parameter into a register, cant do mem to mem
	MOV EAX, dword ptr[EDX]								;moves the first word into al
	.IF EAX == 0										;if it is null
	.ELSE												;if it is not
		MOV [EBX].zip, EDX								;moves the zip sent into the method into the zip in student 
	.ENDIF												;end if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called cleaning 8 bytes. 
Student_setZip ENDP

COMMENT%
******************************************************************************
*Name: setAddr                                                               *
*Purpose:                                                                    *
*	  Intakes a student and a dword address to an address, then places the   *
*		address in, into the student's address              				 *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param inAddr:dword                                                         *
*****************************************************************************%
Student_setAddr PROC stdcall uses EBX EDX, ths:dword, inAddr:dword, inZip:dword
	LOCAL bbyte:byte									;use local directive
	INVOKE Student_setStreet, ths, inAddr				;sets the street to the student
	INVOKE Student_setZip, ths, inZip					;sets the zip of the student
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_setAddr ENDP

COMMENT%
******************************************************************************
*Name: getName                                                               *
*Purpose:                                                                    *
*	  Intakes a student and returns the address of where the name is 		 *
*			( new generated string on the heap)                              *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getName PROC stdcall uses EBX EDX, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 200						;allocate 200 bytes of memory (enough for a big name)
	MOV EDX, EAX										;moves the address of the heap onto edx so we can invoke it
	INVOKE appendString, EDX, addr [EBX].first			;appends the first name at the address
	INVOKE appendString, EDX, addr spaceChar			;appends a space character onto the address
	INVOKE appendString, EDX, addr [EBX].last			;appends the last name onto the address
	MOV EAX, EDX										;moves the address of the name into eax for returning
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_getName ENDP

COMMENT%
******************************************************************************
*Name: getTest                                                               *
*Purpose:                                                                    *
*	  Intakes a student and test number and retuns the test grade            *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param numTest:word                                                         *
*@returns testScore:word                                                     *  
*****************************************************************************%
Student_getTest PROC stdcall uses EBX, ths:dword, numTest:word
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	.IF numTest == 1									;if the in test num is equal to 1
		MOV AX, [EBX].test1								;moves the score from the test into AX
	.ELSEIF numTest == 2								;if the in test num is equal to 2
		MOV AX, [EBX].test2								;moves the score from the test into AX	
	.ELSEIF numTest == 3								;if the in test num is equal to 3
		MOV AX, [EBX].test3								;moves the score from the test into AX
	.ELSE												;if the test number is not 1-3
	.ENDIF												;if this was java i would throw an exception at the else
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_getTest ENDP


COMMENT%
******************************************************************************
*Name: getAddress                                                            *
*Purpose:                                                                    *
*	  Intakes a student and returns the street + zip 			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getAddress PROC stdcall uses ECX EDX EDI, ths:dword 
	LOCAL bbyte:byte									;use local directive
	MOV EDX, 0
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 205						;allocates enough memory for a complete address
	MOV EDI, EAX										;moves into edi the address given back from the allocation
	INVOKE Student_getStreet, ths						;gets the street from the current student passed in
	MOV EDX, EAX										;moves into EDX, the returning street address in EAX
	INVOKE appendString, EDI, EDX						;appends the street to the blank allocated memory
	INVOKE appendString, EDI, addr spaceChar			;appends a space character onto the address
	INVOKE Student_getZip, ths							;gets the current zip from the student and address is in eax
	.IF EAX == -1										;if the zip is null
	.ELSE												;if it is not
		MOV EDX, EAX									;moves the numbers of the zip into eax
		INVOKE memoryallocBailey, 5						;allocates enough memory for a complete address
		INVOKE intasc32, EAX, EDX						;converts the zip to ascii
		MOV EDX, EAX									;moves the addr of the zip into eax
		INVOKE appendString, EDI, EDX					;appends the zip at the end of the current string allocated (the street and the space to seperate)
	.ENDIF												;endif
	MOV EAX, EDI										;moves the address of the address into eax for returning
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_getAddress ENDP

COMMENT%
******************************************************************************
*Name: getStreet                                                             *
*Purpose:                                                                    *
*	  Intakes a student and returns the street      			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getStreet PROC stdcall uses ebx edx, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EDX, 0											;clear our edx
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 200						;allocate 205 bytes of memory (enough for a street and 5 digit zip)
	MOV EDX, EAX										;moves the address of the heap onto edx so we can invoke it
	INVOKE appendString, EDX, addr [EBX].street			;appends the street at the address
	MOV EAX, EDX										;moves the address of the address into eax for returning
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_getStreet ENDP

COMMENT%
******************************************************************************
*Name: getStreet                                                             *
*Purpose:                                                                    *
*	  Intakes a student and returns the street      			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:dword                                                      *  
*****************************************************************************%
Student_getZip PROC stdcall uses ebx edx, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	MOV EAX, [EBX].zip									;moves the address of the zip into EAX
	.IF EAX == 00										;if zip is null
		MOV EAX, -1										;if it is null than put -1 in eax
	.ELSE												;if it is not
		MOV EDX, [EAX]									;moves the value at eax into edx
		MOV EAX, EDX									;moves back to eax for output
	.ENDIF												;end if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_getZip ENDP

COMMENT%
******************************************************************************
*Name: findMax                                                               *
*Purpose:                                                                    *
*	  finds the max test grade of the student        			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outTest:word                                                       *  
*****************************************************************************%
Student_findMax PROC stdcall uses EBX , ths:dword		
	LOCAL bbyte:byte									;use local directive								
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	MOV AX, [EBX].test1									;moves the value in t1 into register so we can compare without mem to mem error
	.IF  AX > [EBX].test2 && AX > [EBX].test3			;if the value in t1 is greater than t2 and t3
		MOV AX, [EBX].test1								;moves the first test into the largest spot
	.ELSE												;considering the value in t1 is less than t2 and t3 we can use else
		MOV AX, [EBX].test2								;moves the value of t2 into the register for comparison
		.IF AX > [EBX].test3							;if the value t2 is greater than t3, it is therefore the greatest number	
			MOV AX, [EBX].test2							;moves the test 2 into the largest spot
		.ELSE											;test3 is the greatest if this gets hit
			MOV AX, [EBX].test3							;move the test score 3 into the largest spot
		.ENDIF											;end if
	.ENDIF												;ends if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_findMax ENDP

COMMENT%
******************************************************************************
*Name: findMin                                                               *
*Purpose:                                                                    *
*	  finds the min test grade of the student        			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outTest:word                                                       *  
*****************************************************************************%
Student_findMin PROC stdcall, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	MOV AX, [EBX].test1									;moves the value in t1 into register so we can compare without mem to mem error
	.IF  AX < [EBX].test2 && AX < [EBX].test3			;if the value in t1 is greater than t2 and t3
		MOV AX, [EBX].test1								;moves the first test into the smallest spot
	.ELSE												;considering the value in t1 is less than t2 and t3 we can use else
		MOV AX, [EBX].test2								;moves the value of t2 into the register for comparison
		.IF AX < [EBX].test3							;if the value t2 is greater than t3, it is therefore the greatest number	
			MOV AX, [EBX].test2							;moves the test 2 into the smallest spot
		.ELSE											;test3 is the greatest if this gets hit
			MOV AX, [EBX].test3							;move the test score 3 into the smallest spot
		.ENDIF											;end if
	.ENDIF												;ends if
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_findMin ENDP

COMMENT%
******************************************************************************
*Name: calcAvg                                                               *
*Purpose:                                                                    *
*	  finds the average of the 3 test grades        			             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAvg:word                                                        *  
*****************************************************************************%
Student_calcAvg PROC stdcall uses EBX, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	MOV AX, [EBX].test1									;moves the first test into AX
	MOV DX, [EBX].test2									;moves the second test into DX
	ADD AX, DX											;add the first two tests together
	MOV DX, [EBX].test3									;move the third test into DX
	ADD AX, DX											;all 3 are added together now
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	MOV BL, 3											;we are dividing by 3
	iDIV BL												;divide by 3
	CBW													;converts the byte to word
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_calcAvg ENDP

COMMENT%
******************************************************************************
*Name: studentRecord                                                         *
*Purpose:                                                                    *
*	  sends back a string address containing the students record             *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:word                                                       *  
*****************************************************************************%
Student_studentRecord PROC stdcall uses EBX EDX EDI ESI, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 400						;holds enough space to have the record...
	MOV EDI, EAX										;moves the address given back into edi
	INVOKE Student_BasicInfo, ths						;gets the name of the student, address is in eax
	MOV EDX, EAX										;moves the address into edx
	INVOKE appendString, EDI, EDX						;appends the address of the student at the end of the main string
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE appendString, EDI, addr strTest1				;append the test 1 string
	INVOKE Student_getTest, ths, 1						;get the score for the test
	MOV DX, AX											;move the score into dx
	INVOKE memoryallocBailey, 4							;allocate 4 bytes, to hold the asc conversion
	MOV ESI, EAX										;move into esi the address of the 4 byte allocation
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;appends the space char
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strTest2				;append the test 1 string
	INVOKE Student_getTest, ths, 2						;get the score for the test
	MOV DX, AX											;move the score into dx
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;appends the space char
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strTest3				;append the test 1 string
	INVOKE Student_getTest, ths, 3						;get the score for the test
	MOV DX, AX											;move the score into dx
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;appends the space char
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strAverage			;append the average string		
	INVOKE Student_calcAvg, ths							;get the average
	MOV DX, AX											;move the avg into dx
	INVOKE intasc32, ESI, DX							;converts the test into ascii
	INVOKE appendString, EDI, ESI						;appends the test at the end of the main string
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr spaceChar			;append the space character
	INVOKE appendString, EDI, addr strGrade				;append the grade string to the main string
	INVOKE memoryallocBailey, 2							;allocated 2 byte of storage onto the heap
	MOV ESI, EAX										;moves the address of the 1 byte into esi
	INVOKE Student_letterGrade, ths						;gets the letter grade of the student
	MOV [ESI], AL										;moves into tehe 1 byte storage the letter grade
	INVOKE appendString, EDI, ESI						;appends the letter grade onto the main string
	INVOKE appendString, EDI, addr nullChar				;append the null character
	MOV EAX, EDI										;moves the address of the main string into eax
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_studentRecord ENDP

COMMENT%
******************************************************************************
*Name: BasicInfo                                                        	 *
*Purpose:                                                                    *
*	  sends back the students name and address            					 *
*                                                                            *
*Date Created: 11/21/2019                                                    *
*Date Modified: 11/21/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outAddr:word                                                       *  
*****************************************************************************%
Student_BasicInfo PROC stdcall uses EBX EDX EDI, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE memoryallocBailey, 200						;holds enough space to have the record...
	MOV EDI, EAX										;moves the address given back into edi
	INVOKE Student_getName, ths							;gets the name of the student, address is in eax
	MOV EDX, EAX										;stores this address into edx
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE appendString, EDI, EDX						;appends the name onto the main string
	INVOKE appendString, EDI, addr nextLine				;appends the new line character
	INVOKE Student_getAddress, ths						;gets the address of the student, address is in eax
	MOV EDX, EAX										;moves the address into edx
	INVOKE appendString, EDI, EDX						;appends the address of the student at the end of the main string
	MOV EAX, EDI										;moves the address of the main string into eax
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_BasicInfo ENDP

COMMENT%
******************************************************************************
*Name: letterGrade                                                           *
*Purpose:                                                                    *
*	  sends back a letter grade corresponding to the average                 *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@returns outASCII:byte                                                      *  
*****************************************************************************%
Student_letterGrade PROC stdcall uses EBX EDX, ths:dword
	LOCAL bbyte:byte									;use local directive
	MOV EBX, ths										;moves the address of the student into ebx
	ASSUME EBX:PTR Student								;assumes ebx is a student so we dont have to type it later
	INVOKE Student_calcAvg, ths							;get the average of the tests
	.IF AX >= 90										;if the average is greater than or equal to 90
		MOV DL, 41h										;move the ASCII A (in hex) into DL
	.ELSEIF AX >= 80									;if it is greater or equal to 80
		MOV DL, 42h										;move the B character in DL
	.ELSEIF AX >= 70									;if it is greater or equal to 70
		MOV DL, 43h										;move the C character in DL
	.ELSEIF AX >= 60									;if it is greater or equal to 60
		MOV DL, 44h										;move the D character in DL
	.ELSE												;if it is not any of the above
		MOV DL, 46h										;move the F character into DL
	.ENDIF												;end if
	MOV AL, DL											;move DL into AL for output
	ASSUME EBX:ptr nothing								;ebx does not point to a student anymore
	RET 												;returns to where I was called, cleaning 8 bytes.
Student_letterGrade ENDP

COMMENT%
******************************************************************************
*Name: equals                                                                *
*Purpose:                                                                    *
*	  tests if the students tests are equal, if they are it returns 1        *
*                                                                            *
*Date Created: 11/19/2019                                                    *
*Date Modified: 11/19/2019                                                   *
*                                                                            *
*@param ths:dword                                                            *
*@param sc:dword                                                             *
*@returns outResult:byte                                                     *  
*****************************************************************************%
Student_equals PROC stdcall uses EBX ECX EDX, ths:dword, sc:dword
LOCAL bbyte:byte										;use local directive
MOV ECX, 0												;moves 0 into ecx, to initialize
INVOKE Student_getTest, ths, 1							;get the first students test score
MOV DX, AX												;move the test score into edx
INVOKE Student_getTest, sc, 1							;get the second students test score
.IF AX == DX											;compare the two to see if they are equal
	INVOKE Student_getTest, ths, 2						;get the first students test score
	MOV DX, AX											;move the test score into edx
	INVOKE Student_getTest, sc, 2						;get the second students test score
	.IF AX == DX										;compare the two to see if they are equal
	INVOKE Student_getTest, ths, 3						;get the first students test score
	MOV DX, AX											;move the test score into edx
	INVOKE Student_getTest, sc, 3						;get the second students test score
		.IF AX == DX									;compare the two to see if they are equal
			MOV CL, 1									;if they are then the students test scores are equal
		.ELSE											;if not
			MOV CL, 0									;move 0 into cl if they are not equal
		.ENDIF											;end if
	.ELSE												;if not
		MOV CL, 0										;move 0 into cl they are not equal
	.ENDIF												;end if
.ELSE													;if not
	MOV CL, 0											;move 0 into cl they are not equal
.ENDIF													;end if
MOV AL, CL												;move the cl into al for standard output
RET 													;return to where i was called cleaning 8 bytes
Student_equals ENDP
END