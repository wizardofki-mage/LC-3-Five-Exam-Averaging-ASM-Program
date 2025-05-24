; Course Project - Option B: Average 5 grades, display min, max, and average

.ORIG X3000
START		
		AND R2, R2, #0										; clear R2
		STI R2, MAX										; store #0 to MAX because if any scores are greater than that, they are maximum candiates
		; ADD R2, R2, #5									; start scores entered counter at 5
		STI R2, SCORESENTERED									; keep track of the number of scores entered for division but not for a counter
		LD R6, BASE										; load the address of stack pointer into R6
		LD R5, STACKFULL									; load the address of the full stack x3FFC into R5
		NOT R5, R5										; inverse of R5, R5 =-3FFC, or R5 = C004
		ADD R5, R5, #1										; 2's complement of the stack full address
		STI R5, FULLSTACKADR									; store R5 to FULLSTACKADR
		AND R5, R5, #0										; clear R5
		NOT R5, R6										; store the inverse of R6 (stack currently empty) into R5
		ADD R5, R5, #1										; 2's complement of the stack base address
		STI R5, STACKEMTADDR									; store this number in STACKEMTADDR
		LEA R0, PRMPT										; load enter exam scores prompt to R0
		PUTS											; TRAP to output a string

; minidata section
PRMPT		.STRINGZ	"Enter 5 test grades for the avg: "					; prompt
											
FIRSTCHAR	
		AND R4, R4, #0										; clear R4
		STI R4, TESTSCORE									; reinitialize test 1 score
		STI R4, CHAR1										; reinitialize CHAR1
		STI R4, CHAR2										; reinitialize CHAR2
		STI R4, CHAR3										; reinitialize CHAR3									
		ADD R4, R4, #3										; 3 characters remaining to be entered, R4 keeps track of the character count
		GETC											; TRAP to enter a character
		AND R1, R1, #0										; clear R1
		ADD R1, R1, R0										; copy character entered to R1
		LD R2, CHKDASH										; load #-45 into R2 to check for the minux/dash character
		ADD R2, R2, R1										; subtract 45 from the first character to check for dash
		BRz CANTBENEG										; if zero, the character was a dash/minus										
		LD R2, HEXN30										; load -x30 or -#-48 ASCII offset to check for characters less than '0'
		ADD R2, R2, R1										; subtract 48 from the first character to check for characters less than '0' on the ASCII table
		BRn BADCHAR										; if negative, then the character is less than '0' on the ASCII table
		LD R2, MAXCHAR										; load #-58 into R2 to check for characters greater than '9' 
		ADD R2, R2, R1										; subtract 58 from the first character to check for characters greater than '9' on the ASCII table
		BRzp BADCHAR										; if zero or negative, then the character was greater than '9' on the ASCII table
		LD R2, HEXN30										; load HEXN30 again into R2 to offset the ASCII character
		ADD R1, R1, R2										; ASCII offset the first character since everthing is okay
		STI R1, CHAR1										; store first character entered into CHAR1
		LD R2, HEX30										; load HEX30 offset to R2 to offset the digit for ASCII output
		LDI R0, CHAR1										; loading CHAR1 to R0 to echo it out
		ADD R0 R0, R2										; adds the ASCII offset to the digit
		OUT											; output 1st character	
		ADD R4, R4, #-1										; decrement character count, R4 = 2												

SECONDCHAR
		GETC											; TRAP to enter a character
		AND R1, R1, #0										; clear R1
		ADD R1, R1, R0										; copy character entered to R1
		LD R2, CHKENTER										; load CHKENTER into R2 to check for the enter/return key
		ADD R2, R2, R1										; subtract #10 from R1 to check for enter/return key
		BRz VALIDNUMCHAR									; if the enter/return key was pressed, then entry for that score is done and branch to VALIDNUMCHARS
		LD R2, CHKSPACE										; load CHKSPACE into R2 to check for the space key which will also be interpreted as score entry done
		ADD R2, R2, R1										; subtract #32 from R1 to check for space key
		BRz VALIDNUMCHAR									; if the spacebar was pressed, then entry for that score is done and branch to VALIDNUMCHAR				
		LD R2, HEXN30										; load -x30 or -#-48 ASCII offset to check for characters less than '0'
		ADD R2, R2, R1										; subtract 48 from the second character to check for characters less than '0' on the ASCII table
		BRn BADCHAR										; if negative, then the character is less than '0' on the ASCII table
		LD R2, MAXCHAR										; load #-58 into R2 to check for characters greater than '9' 
		ADD R2, R2, R1										; subtract 58 from the second character to check for characters greater than '9' on the ASCII table
		BRzp BADCHAR										; if zero or positive, then the character was greater than '9' on the ASCII table
		LD R2, HEXN30										; load HEXN30 again into R2 to offset the ASCII character
		ADD R1, R1, R2										; ASCII offset the second character since everthing is okay
		STI R1, CHAR2										; store second character entered into CHAR2
		LD R2, HEX30										; load HEX30 offset to R2 to offset the digit for ASCII output
		LDI R0, CHAR2										; loading CHAR2 to R0 to echo it out
		ADD R0 R0, R2										; adds the ASCII offset to the digit
		OUT											; output 2st character	
		ADD R4, R4, #-1										; decrement character count, R4 = 1

THIRDCHAR
		GETC											; TRAP to enter a character
		AND R1, R1, #0										; clear R1
		ADD R1, R1, R0										; copy character entered to R1
		LD R2, CHKENTER										; load CHKENTER into R2 to check for the enter/return key
		ADD R2, R2, R1										; subtract #10 from R1 to check for enter/return key
		BRz VALIDNUMCHAR									; if the enter/return key was pressed, then entry for that score is done and branch to VALIDNUMCHAR
		LD R2, CHKSPACE										; load CHKSPACE into R2 to check for the space key which will also be interpreted as score entry done
		ADD R2, R2, R1										; subtract #32 from R1 to check for space key
		BRz VALIDNUMCHAR									; if the spacebar was pressed, then entry for that score is done and branch to VALIDNUMCHAR			
		LD R2, HEXN30										; load -x30 or -#-48 ASCII offset to check for characters less than '0'
		ADD R2, R2, R1										; subtract 48 from the second character to check for characters less than '0' on the ASCII table
		BRn BADCHAR										; if negative, then the character is less than '0' on the ASCII table
		LD R2, MAXCHAR										; load #-58 into R2 to check for characters greater than '9' 
		ADD R2, R2, R1										; subtract 58 from the second character to check for characters greater than '9' on the ASCII table
		BRzp BADCHAR										; if zero or negative, then the character was greater than '9' on the ASCII table
		LD R2, HEXN30										; load HEXN30 again into R2 to offset the ASCII character
		ADD R1, R1, R2										; ASCII offset the third character since everthing is okay
		STI R1, CHAR3										; store third character entered into CHAR2
		LD R2, HEX30										; load HEX30 offset to R2 to offset the digit for ASCII output
		LDI R0, CHAR3										; loading CHAR3 to R0 to echo it out
		ADD R0 R0, R2										; adds the ASCII offset to the digit
		OUT											; output 3st character	
		ADD R4, R4, #-1										; decrement character count	
	
VALIDNUMCHAR
		LD R0, NL										; load the newline character into R0
		OUT											; output a newline character
		JSR PREPNUMCHAR										; PREPNUMCHAR is just a housekeeping subroutine for VALIDNUMCHAR so that I don't have to type it four times
		ADD R3, R3, #-3										; R3 = R4 - 3
		BRzp CHARQTYERR										; if the result is zero or positive, then no characters have been entered and a serious error occurred.
		JSR PREPNUMCHAR
		ADD R3, R3, #-2										; R3 = R4 - 2
		BRz SCOREDONE										; if the result is one character, just branch to the SCOREDONE and add up the "characters" even if only one has been entered
		JSR PREPNUMCHAR
		ADD R3, R3, #-1										; R3 = R4 - 1
		BRz MULTITENS										; if the result is two characters, branch to MULTITENS which multiplies CHAR1 * 10 to obtain the intended score
		JSR PREPNUMCHAR
		ADD R3, R3, #0										; if the result is three characters, branch to MULTHUNS
		BRz MULTHUNS										; if the result is two characters, branch to MULTHUNS which multiplies CHAR1 *100 and CHAR2 * 10									
		
PREPNUMCHAR												; This subroutine just does some housekeeping for VALIDNUMCHAR
		AND R3, R3, #0										; clear R3
		ADD R3, R3, R4										; copy R4 to R3
		RET

MULTITENS
		AND R3, R3, #0										; clear R3
		ADD R3, R3, xA										; add xA (#10) to R3
		AND R2, R2, #0										; clear R2
		LDI R2, CHAR1										; load CHAR1 into R2, and it represents the tens place
		AND R5, R5, #0										; clear R5. It will hold the product of multiplication
		
MULTLOOP1	ADD R5, R5, R2										; add the digit in R2 to R5 everytime the multiplication loop repeats (do-while)
		ADD R3, R3, #-1										; decrement multiplication counter by one
		BRnz SAVESECTEN										; if the multiplication is done, branch to SAVESECTEN
		BRp MULTLOOP1										; if the counter is still positive, then loop to MULTLOOP1

MULTHUNS	
		AND R3, R3, #0										; clear R3
		ADD R3, R3, xA										; start accumulating #100 into R3
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		
		LDI R2, CHAR1										; load char1 into R2, it represents the 100s place
		AND R5, R5, #0										; clear R5. It will hold the product of multiplication

MULTLOOP2	ADD R5, R5, R2
		ADD R3, R3, #-1										; subract 1 from multiplication counter
		BRnz SAVE1STHUNS									; once multiplicaiton is done, branch to SAVE1STHUNS
		BRp MULTLOOP2										; branch to MULTLOOP2 until done

SAVE1STHUNS	STI R5, CHAR1										; save 100 * CHAR1 to CHAR1, CHAR2 will now be the tens place
		AND R3, R3, #0										; clear R3
		ADD R3, R3, xA										; add xA (#10) to R3
		AND R2, R2, #0										; clear R2
		LDI R2, CHAR2										; load CHAR2 into R2, and it represents the tens place
		AND R5, R5, #0										; clear R5. It will hold the product of multiplication	
		
MULTLOOP3	ADD R5, R5, R2										; add the digit in R2 to R5 everytime the multiplication loop repeats (do-while)
		ADD R3, R3, #-1										; decrement multiplication counter by one
		BRnz SAVETENSNEXT									; if the multiplication is done, branch to SAVETENSNEXT
		BRp MULTLOOP3
		
SAVESECTEN
		STI R5, CHAR1										; save 10 * CHAR1 to CHAR1, CHAR2 is left unchanged since it's the ones place
		BRnzp SCOREDONE										; branch to SCOREDONE

SAVETENSNEXT	STI R5, CHAR2										; save 10 * CHAR2 to CHAR2, CHAR3 is left unchanged since it's the ones place


; add them up, check if valid, if so put them on the stack as long as there's room on the stack																					
SCOREDONE	
		AND R2, R2, #0										; clear R2
		LDI  R3, CHAR1										; load the value from CHAR1 into R3
		ADD R2, R2, R3										; R2 = R2 + CHAR1 value
		LDI R3, CHAR2										; load the value from CHAR2 into R3
		ADD R2, R2, R3										; R2 = R2 + CHAR2 value
		LDI R3, CHAR3										; load the value from CHAR3 into R3
		ADD R2, R2, R3										; R2 = R2 + CHAR3 value
		ADD R2, R2, #0										; add zero to R2 to set the status flags
		BRn CANTBENEG										; this shouldn't happen, but just in case the exam score is negative at this point
		AND R3, R3, #0										; clear R3
		ADD R3, R3, xA										; start accumulating #100 into R3
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		ADD R3, R3, xA
		STI R3, MIN										; store 100 into MIN (for the minimum score) to compare test scores to it later, if less than they are minimum candidates
		NOT R3, R3										; inverse of R3
		ADD R3, R3, #1										; 2's complement of R3, R3 = #-100
		ADD R3, R3, R2										; R3 = R2 + #-100
		BRp OVER100										; if the testscore is > 100 branch to OVER100
		STI R2, TESTSCORE									; store R2 to TESTSCORE
		JSR PUSH										; Jump to subroutine PUSH													
		LDI R3, SCORESENTERED									; load SCORESENTERED to R3
		ADD R3, R3, #1										; since all went well up to this point, add 1 to scores entered to increment it
		STI R3, SCORESENTERED									; store R3 to scores entered
		; AND R0, R0, #0									; clear R0
		; ADD R0, R3, #0									; ADD R3 to R0 to set condition codes
		ADD R0, R0, #0										; set condition flags for stack full-driven behavior
		BRp FIRSTCHAR										; if the status flag in R0 from PUSH is positive, stack still has room, branch to FIRSTCHAR
		BRnz CHECKMINMAX									; if the status flag in R0 is zero or negative, the stack is full, branch to CHECKMINMAX																				
PUSH
		ST R5, SAVEREG5										; back up R5 because it will be destroyed, an example of callee save
		AND R0, R0, #0										; clear R0
		LDI R5, FULLSTACKADR									; load the 2's complement of the stack full address back into R5
		ADD R0, R5, R6										; ADD R5 (stack full) to R6 (stack pointer), if negative, then the stack is full and it can report negative
		BRzp DOPUSH										; If positive, room is still left on the stack, so go ahead and push a value onto it.
		LD R5, SAVEREG5										; Restore R5
		RET

DOPUSH													; Decrement stack pointer because as our textbook says, stack grows towards 0
		ADD R6, R6, #-1										; Otherwise, the actual push
		STR R2, R6, #0										; stores the value in R0 to the memory location that R6 is pointing to, actual push
		RET

; data	
NL		.FILL		#10									; new line character
HEX30		.FILL 		x0030									; the positive x30 reverse offset to convert the calculation back to an ASCII character
HEXN30		.FILL		xFFD0									; -x30 hex offset 
MAXCHAR		.FILL		xFFC6									; #-58 to check for characters greater than '9'
CHKDASH		.FILL		xFFD3									; #-45 to check for dash
CHKENTER	.FILL		xFFF6									; #-10 to check for enter
CHKSPACE	.FILL		xFFE0									; #-32 to check for space
CHKBS		.FILL		xFFF8									; to check for backspace character
MAXSCORE	.FILL		xFF9C									; to check for max score
MIN		.FILL 		x3250									; memory location for minimum number exam grade
MAX		.FILL 		x3251									; memory location for maximim number exam grade
AVG		.FILL 		x3252									; memory location for average letter grade
CHAR1		.FILL		x3253									; memory location for storing 1st character entered
TESTSCORE	.FILL		x3254									; memory address to hold a testscore
CHAR2		.FILL		x3255									; memory location for storing the value of the 2nd character entered
CHAR3		.FILL		x3256									; memory location for storing the value of the 3rd character entered
BASE		.FILL		x4000									; empty location of the stack						
SCORESENTERED	.FILL		x3257									; counter for number of test scores to enter
STACKSTART	.FILL		x4000									; start stack at x4000
STACKFULL	.FILL		x3FFC									; stack full address, will be 2's complemented to compare to the stack pointer for stack full
FULLSTACKADR	.FILL		x3258									; where the 2's complement of the stack full address will be stored for later retrieval
STACKEMTADDR	.FILL		x325A									; where the 2's complement of the stack base will be stored for later retrieval
SAVEREG5 	.FILL		x3259									; The memory address to back up and restore R5
TOTALSCORE	.FILL		x325B									; used to hold the total score before averaging
SAVEPOP		.FILL		x325C									; saves the status of the popping to drive the part of the program that gets the values off the stack
AVGGRADE	.FILL		x325D									; saves the ASCII character of the average letter grade
MINGRADE	.FILL		x325E									; saves the ASCII character of the minimum letter grade
MAXGRADE	.FILL		x325F									; saves the ASCII character of the maximum letter grade
SAVEREG7	.FILL		x3260
											
CANTBENEG 
		LEA R0, NEGERROR									; load NEGERROR if user tries entering a dash
		PUTS											; TRAP to output a string
		LEA R0, REPROMPT									; load REPROMPT to R0
		PUTS											; TRAP to output a string
		BRnzp FIRSTCHAR										; branch unconditionally to FIRSTCHAR

BADCHAR
		LEA R0, NOTNUM										; load NOTNUM string if the character is not a number
		PUTS											; TRAP to output a string
		LEA R0, REPROMPT									; load REPROMPT to R0
		PUTS											; TRAP to output a string
		BRnzp FIRSTCHAR										; branch unconditionally to FIRSTCHAR

CHARQTYERR	
		LEA R0, NOCHARSEN
		PUTS
		HALT											; if this happens, the program is messed up and it better just HALT

OVER100
		LEA R0, EXAM100P									; load EXAM100P if the exam score entered is >100
		PUTS
		BRnzp FIRSTCHAR										; go back to FIRSTCHAR and have the user re-enter the exam score					

CHECKMINMAX	AND R3, R3, #0										; clear R3
MINMAXLOOP	JSR POP											; JSR POP to get a test score off the stack
		LDI R0, SAVEPOP										; load the value in SAVEPOP to see if the pop was successful
		ADD R0, R0, #0										; set condition flags for stack empty behavior
		BRzp CALCAVG										; if negative, branch to CALCAVG to start calculating the average
		ADD R3, R3, R2										; R3 = R3 + R2 (cummalative total points)
		AND R4, R4, #0										; clear R4
		LDI R1, MAX 										; load current max score into R1
		NOT R1, R1										; inverse of R1
		ADD R1, R1, #1										; 2's complement of R1 (R1 = negative current max test score)
		ADD R4, R2, R1										; check to see if test score popped off the stack is greater than current max score
		BRzp NEWMAX										; if so current test score in R2 = max test score

CHECKMIN	AND R4, R4, #0										; clear R4
		LDI R1, MIN 										; load current minimum score into R1
		NOT R1, R1										; inverse of R1
		ADD R1, R1, #1										; 2's complement of R1 (R1 = negative current min test score)
		ADD R4, R2, R1										; check to see if test score popped off the stack is less than current min score
		BRnz NEWMIN										; if so current test score in R2 = max test score
		BRp MINMAXLOOP

NEWMAX		STI R2, MAX										; store the test score popped of the stack in MAX because it equals the highest test score so far
		BRnzp CHECKMIN										; branch unconditionally to CHECKMIN

NEWMIN		STI R2, MIN
		BRnzp MINMAXLOOP							

POP		AND R0, R0, #0										; clear R0
		; ST R5, SAVEREG5										; back up R5 in SAVEREG5 address
		LDI R5, STACKEMTADDR									; load the 2's complement of the stack base address into R5
		ADD R0, R6, R5										; subtract R5 from R6
		STI R0, SAVEPOP
		ADD R0, R0, #0
		BRn DOPOP
		; LD R5, SAVEREG5
		RET

DOPOP		LDR R2, R6, #0										; load the value that the stack pointer is pointing to into R2 (POP)
		ADD R6, R6, #1										; increment stack pointer
		RET

CALCAVG
		STI R3, TOTALSCORE									; store the total of all scores in R3 to TOTALSCORE
		AND R5, R5, #0										; clear R5
		LDI R5, SCORESENTERED									; SCORESENTERED should equal #5
		NOT R5, R5										; inverse of R5
		ADD R5, R5, #1										; the 2's complement of R5, R5 =#-5
		AND R2, R2, #0										; clear R2, it will hold the quotient

DIVLOOP		ADD R3, R3, R5										; subtract 5 from the total score
		ADD R2, R2, #1										; increment quotient by 1
		ADD R3, R3, #0										; set condition codes
		BRp DIVLOOP										; if positive, keep dividing by subtracting #5
		BRn DEALNEG										; if negative, then the counter must be decreased by one

DEALNEG													; this deals with division that resulting in a negative number because 5 didn't go into the total evenly
		ADD R2, R2, #-1										; subtract one from the quotient since the final subtraction "failed"
		
		STI R2, AVG										; store the quotient to average
		LEA R0, AVGOUT										; load the AVGOUT string to R0
		PUTS											; output the AVGOUT string
		JSR STACK
		LEA R0, MINOUT
		PUTS
		LDI R2, MIN
		JSR STACK
		LEA R0, MAXOUT
		PUTS
		LDI R2, MAX
		JSR STACK
		HALT 
		;BRnzp NEXTFUNCT

STACK		ST R7, SAVEREG7
		AND R0, R0, #0										; clear R0
STACKLOOP	AND R3, R3, #0										; clear R3
		ADD R3, R3, #10										; R3 = #10
		JSR DIV2										; JSR DIV2
		ST R5, SAVEREG5
		AND R2, R2, #0										; clear R2
		ADD R2, R2, R4																					
		JSR PUSH
		ADD R0, R0, #0										; set condition flags for stack full-driven behavior
		BRnz UNSTACK
		LD R5, SAVEREG5
		AND R2, R2, #0
		ADD R2, R5, #0										; the quotient the was in R5 goes gets loaded into R2 for another round of division
		BRp STACKLOOP

UNSTACK		JSR POP
		LDI R0, SAVEPOP										; load the value in SAVEPOP to see if the pop was successful
		ADD R0, R0, #0										; set condition flags for stack empty behavior
		BRzp CONT
		JSR DECODE										; DECODE is the subroutine to handle ASCII offset
		ADD R0, R2, R0
		OUT											; output random number to console
		BR UNSTACK										; unconditional branch to UNSTACK
		
DIV2		NOT R3, R3										; inverse of R3
		ADD R3, R3, #1										; 2's complement, R3 = #-10
		AND R5, R5, #0										; clear R5, it will hold the quotient
		AND R4, R4, #0										; clear R4; it will hold the remainder

DIVLOOP2	AND R4, R4, #0										; clear R4; it will hold the remainder
		ADD R5, R5, #1										; increment quotient
		ADD R4, R2, #0										; R4 = R2
		ADD R2, R2, R3										; subtract #10 from value in R2, R2 will also hold its own remainder
		BRzp DIVLOOP2										; if positive, then keep subtracting 10
		ADD R5, R5, #-1										; subtract one from the quotient since the final subtraction "failed"
		RET

DECODE		AND R1, R1, #0
		AND R0, R0, #0
		LD R1, HEX30										; load HEXN30 reverse ASCII offset into R1
		ADD R0, R0, R1
		RET

CONT		LD R0, NL										; load NL into R0
		OUT
		LD R7, SAVEREG7
		RET
		
NEXTFUNCT
		HALT


MINOUT		.STRINGZ	"Minimum: "								; string to put next to minimum grade
MAXOUT		.STRINGZ	"Maximum: "								; string to put next to maximum grade
AVGOUT		.STRINGZ	"Average: "								; string to put next to average grade
NOTNUM		.STRINGZ	"\nNot a #"								; Not a number error
NOCHARSEN	.STRINGZ	"\nNo chars entered"							; a string just in case a serious error occurs with the number of chars entered
NEGERROR	.STRINGZ	"\nScore cannot be neg"							; error message to enter if user tries entering the dash/minus key
EXAM100P	.STRINGZ	"\nScore cannot be>100"							; error message if the exam score entered is > 100
REPROMPT	.STRINGZ	"\nReenter Score: "
.END									

; to do: Get program working so far and figure out runtime errors.