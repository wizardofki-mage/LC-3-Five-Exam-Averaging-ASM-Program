; CIS-11
; Jason Ash
; Ana Moreno
; Luis Lopez-Gallegos
; Team B. Awesome
; Course Project: Option B: Test Score Calculator
; Description: Create an LC-3 program that displays the minimum, maximum and average grade of 5 test scores and display the letter grade associated with the test scores.
; 	- User is prompted to enter five integer test scores 
;	- The input is ASCII-converted to corresponding integers.
;	- Input validation: Test scores cannot be less than 0 or greater than 100.
;	- Find the minimum, maximum, and average test scores as integers, and display the corresponding letter grade next to them.
; 	- Course Project - Option B: Average 5 grades, display min, max, and average
; Inputs: User inputs five test scores between 0 and 100 from the keyboard into the console. Input validation is that test scores must be numeric, cannot be a letter or symbol,
; test scores cannot be negative, and they must be between 0 and 100, inclusive. Entering three digits automatically advances to the next test score. Likewise, one or two digits
; can be entered followed by the enter key or space bar which will terminate entry for that test score and advance to the next test score to be entered. Entry will end upon five
; test scores being entered, and processing will begin.
; Major processing: The average score will be calculated and the program will determine the minimum and maximum of the scores entered. The program will also determine the letter
; grade associated with the average, minimum, and maximum test scores.
; Output: Three lines will output and will be labeled "Average: ", "Minimum: ", and "Maximum: ", respectively, along with their corresponding score and letter grade.
; The program will halt upon completion of output.
; Side effects: This program is not be able to handle fractional test scores (i.e., those with a decimal value) because the LC-3 does not support floating point data types.
; Two results have been observed with this program: Currently, without subtracting one from the quotient if subtraction makes the total score negative in the loop,
; then the program will always round up if the calculated average were to have a fractional value. It displays the average correctly for scores that are evenly disible by 5.
; If we uncomment the line that subtracts one from the quotient, then it truncates the decimal part since only integer division is happening without rounding, but sometimes
; the average is one less than it should be in some test runs.
; Due to limitations with the LC-3 simulator, there is not a way to store the test scores, average, minimum, or maximum outside of the main memory of the LC-3 or being displayed
; on it's console. In other words, these values cannot be written to secondary storage, such as, a hard drive. Therefore, a screen capture is necessary to verify correct functioning.
; Run: Download LC3edit and the simulator from our textbook author's (Yale N. Patt and Sanjay J. Patel) Website at
; https://highered.mheducation.com/sites/0072467509/student_view0/lc-3_simulator.html
; The .asm source code file should be opened in LC3edit.exe and assembled by doing these steps:
; 	- File --> Open, navigate to where the .asm file was saved or downloaded to, and double click on it.
;	- Click on Translate --> Assemble
; The user should double click on the simulate.exe program
; Click on File --> Reinitialize Machine
; Click on File --> Load Program and select the object file (.obj) created by the assembler.
; Click on Execute --> run
; Make sure the console window is visible, click on it to give it focus, and enter the five test grades as prompted.

.ORIG X3000
		AND R2, R2, #0										; clear R2
		STI R2, MAX										; store #0 to MAX because if any scores are greater than that, they are maximum candiates
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

; mini data section
PRMPT		.STRINGZ	"Enter 5 test grades for the avg: "					; prompt
											
FIRSTCHAR	AND R4, R4, #0										; clear R4
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

SECONDCHAR	GETC											; TRAP to enter a character
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
		BRzp BADCHAR										; if zero or positive, then the character was greater than '9' on the ASCII table
		LD R2, HEXN30										; load HEXN30 again into R2 to offset the ASCII character
		ADD R1, R1, R2										; ASCII offset the second character since everthing is okay
		STI R1, CHAR2										; store second character entered into CHAR2
		LD R2, HEX30										; load HEX30 offset to R2 to offset the digit for ASCII output
		LDI R0, CHAR2										; loading CHAR2 to R0 to echo it out
		ADD R0 R0, R2										; adds the ASCII offset to the digit
		OUT											; output 2st character	
		ADD R4, R4, #-1										; decrement character count, R4 = 1

THIRDCHAR	GETC											; TRAP to enter a character
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
	
VALIDNUMCHAR	LD R0, NL										; load the newline character into R0
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
		BRz MULTHUNS										; if the result is three characters, branch to MULTHUNS which multiplies CHAR1 *100 and CHAR2 * 10											
PREPNUMCHAR												; This subroutine just does some housekeeping for VALIDNUMCHAR
		AND R3, R3, #0										; clear R3
		ADD R3, R3, R4										; copy R4 to R3
		RET

MULTITENS	AND R3, R3, #0										; clear R3
		LD R3, NL										; Since the NL character is also #10, reuse it to set R3 = #10
		AND R2, R2, #0										; clear R2
		LDI R2, CHAR1										; load CHAR1 into R2, and it represents the tens place
		AND R5, R5, #0										; clear R5. It will hold the product of multiplication
		
MULTLOOP1	ADD R5, R5, R2										; add the digit in R2 to R5 everytime the multiplication loop repeats (do-while)
		ADD R3, R3, #-1										; decrement multiplication counter by one
		BRnz SAVESECTEN										; if the multiplication is done, branch to SAVESECTEN
		BRp MULTLOOP1										; if the counter is still positive, then loop to MULTLOOP1

MULTHUNS	AND R3, R3, #0										; clear R3
		LD R3, HUNDRED										; load #100 into R3
		LDI R2, CHAR1										; load char1 into R2, it represents the 100s place
		AND R5, R5, #0										; clear R5. It will hold the product of multiplication

MULTLOOP2	ADD R5, R5, R2										; ADD R5 to R2, R5 will hold the product of multiplication.
		ADD R3, R3, #-1										; subract 1 from multiplication counter
		BRnz SAVE1STHUNS									; once multiplicaiton is done, branch to SAVE1STHUNS
		BRp MULTLOOP2										; branch to MULTLOOP2 until done

SAVE1STHUNS	STI R5, CHAR1										; save 100 * CHAR1 to CHAR1, CHAR2 will now be the tens place
		AND R3, R3, #0										; clear R3
		LD R3, NL										; Since the NL character is also #10, reuse it to set R3 = #10
		AND R2, R2, #0										; clear R2
		LDI R2, CHAR2										; load CHAR2 into R2, and it represents the tens place
		AND R5, R5, #0										; clear R5. It will hold the product of multiplication	
		
MULTLOOP3	ADD R5, R5, R2										; add the digit in R2 to R5 everytime the multiplication loop repeats (do-while)
		ADD R3, R3, #-1										; decrement multiplication counter by one
		BRnz SAVETENSNEXT									; if the multiplication is done, branch to SAVETENSNEXT
		BRp MULTLOOP3
		
SAVESECTEN	STI R5, CHAR1										; save 10 * CHAR1 to CHAR1, CHAR2 is left unchanged since it's the ones place
		BRnzp SCOREDONE										; branch to SCOREDONE

SAVETENSNEXT	STI R5, CHAR2										; save 10 * CHAR2 to CHAR2, CHAR3 is left unchanged since it's the ones place

; add them up, check if valid, if so put them on the stack as long as there's room on the stack
; Note: This program was changed from a counter-based system detecting five test scores entered to a stack full mechanism for detecting that five test scores have been entered.
SCOREDONE	AND R2, R2, #0										; clear R2
		LDI  R3, CHAR1										; load the value from CHAR1 into R3
		ADD R2, R2, R3										; R2 = R2 + CHAR1 value
		LDI R3, CHAR2										; load the value from CHAR2 into R3
		ADD R2, R2, R3										; R2 = R2 + CHAR2 value
		LDI R3, CHAR3										; load the value from CHAR3 into R3
		ADD R2, R2, R3										; R2 = R2 + CHAR3 value
		ADD R2, R2, #0										; add zero to R2 to set the status flags
		BRn CANTBENEG										; this shouldn't happen, but just in case the exam score is negative at this point
		AND R3, R3, #0										; clear R3
		LD R3, HUNDRED										; load #100 into R3
		STI R3, MIN										; store #100 into MIN (for the minimum score) to compare test scores to it later, if less than they are minimum candidates
		NOT R3, R3										; inverse of R3
		ADD R3, R3, #1										; 2's complement of R3, R3 = #-100
		ADD R3, R3, R2										; R3 = R2 + #-100
		BRp OVER100										; if the testscore is > 100 branch to OVER100
		STI R2, TESTSCORE									; store R2 to TESTSCORE
		JSR PUSH										; Jump to subroutine PUSH													
		LDI R3, SCORESENTERED									; load SCORESENTERED to R3
		ADD R3, R3, #1										; since all went well up to this point, add 1 to scores entered to increment it
		STI R3, SCORESENTERED									; store R3 to scores entered
		ADD R0, R0, #0										; set condition codes for stack full-driven behavior
		BRp FIRSTCHAR										; if the condition code in R0 from PUSH is positive, stack still has room, branch to FIRSTCHAR
		BRnz CHECKMINMAX									; if the condition code in R0 is zero or negative, the stack is full, branch to CHECKMINMAX																				
PUSH		ST R5, SAVEREG5										; back up R5 because it will be destroyed, an example of callee save
		AND R0, R0, #0										; clear R0
		LDI R5, FULLSTACKADR									; load the 2's complement of the stack full address back into R5
		ADD R0, R5, R6										; ADD R5 (stack full) to R6 (stack pointer), if negative, then the stack is full and it can report negative
		BRzp DOPUSH										; If positive, room is still left on the stack, so go ahead and push a value onto it.
		LD R5, SAVEREG5										; Restore R5
		RET

DOPUSH		ADD R6, R6, #-1										; Decrement stack pointer because as our textbook says, stack grows towards 0
		STR R2, R6, #0										; Actual push: stores the value in R0 to the memory location that R6 is pointing to
		RET

; data	
NL		.FILL		#10									; new line character, seconds as #10 for multiply by 10 loops
HUNDRED		.FILL		#100									; #100 for multiply by 100
HEX30		.FILL 		x0030									; the positive x30 reverse offset to convert the calculation back to an ASCII character
HEXN30		.FILL		xFFD0									; -x30 hex offset 
MAXCHAR		.FILL		xFFC6									; #-58 to check for characters greater than '9'
CHKDASH		.FILL		xFFD3									; #-45 to check for dash
CHKENTER	.FILL		xFFF6									; #-10 to check for enter
CHKSPACE	.FILL		xFFE0									; #-32 to check for space
CHKBS		.FILL		xFFF8									; to check for backspace character
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
SPACE		.FILL		#32
REPROMPT	.STRINGZ	"\nReenter Score: "
											
CANTBENEG 	LEA R0, NEGERROR									; load NEGERROR if user tries entering a dash
		PUTS											; TRAP to output a string
		LEA R0, REPROMPT									; load REPROMPT to R0
		PUTS											; TRAP to output a string
		BRnzp FIRSTCHAR										; branch unconditionally to FIRSTCHAR

BADCHAR		LEA R0, NOTNUM										; load NOTNUM string if the character is not a number
		PUTS											; TRAP to output a string
		LEA R0, REPROMPT									; load REPROMPT to R0
		PUTS											; TRAP to output a string
		BRnzp FIRSTCHAR										; branch unconditionally to FIRSTCHAR

CHARQTYERR	LEA R0, NOCHARSEN									; if this happens, the program is messed up and it better just HALT
		PUTS
		HALT											

OVER100		LEA R0, EXAM100P									; load EXAM100P if the exam score entered is >100
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
		LDI R5, STACKEMTADDR									; load the 2's complement of the stack base address into R5
		ADD R0, R6, R5										; subtract R5 from R6
		STI R0, SAVEPOP										; store the pop status in SAVEPOP
		ADD R0, R0, #0										; set condition codes
		BRn DOPOP										; if negative, the stack is not yet empty, so do the actual pop
		RET

DOPOP		LDR R2, R6, #0										; load the value that the stack pointer is pointing to into R2 (actual POP)
		ADD R6, R6, #1										; increment stack pointer
		RET

CALCAVG		STI R3, TOTALSCORE									; store the total of all scores in R3 to TOTALSCORE
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
		; ADD R2, R2, #-1									; subtract one from the quotient since the final subtraction "failed" (commented out, see below)
													; since the average seems to be one less on some test runs, try not subtracting one from the quotient
		STI R2, AVG										; store the quotient to average
		LEA R0, AVGOUT										; load the AVGOUT string to R0
		PUTS
		JSR LETTERGRADE										; currently, the average is in R2, so determine the letter grade for it
		STI R5, AVGGRADE									; store the letter grade for the average in AVGGRADE										
		JSR STACK										; this is a complex series of subroutines to reverse ASCII offset a numeric value from memory and output its digits
		LD R0, SPACE										; it's nice to have a space between the numeric score output and the letter grade, load SPACE to R0
		OUT											; output a space
		LDI R0, AVGGRADE									; load the ASCII value of the average grade (AVGGRADE) determined earlier in the LETTERGRADE subroutine
		OUT											; output the letter grade associated with the average grade
		LD R0, NL										; load NL (newline) character to R0 so that each score and letter grade can display on it's own line
		OUT
		
		LDI R2, MIN										; essentially, repeat the above processing and output that was done for average score for the minimum score
		LEA R0, MINOUT
		PUTS
		JSR LETTERGRADE
		STI R5, MINGRADE
		JSR STACK
		LD R0, SPACE
		OUT
		LDI R0, MINGRADE
		OUT
		LD R0, NL
		OUT

		LDI R2, MAX										; essentially, repeat the above processing and output that was done for average score for the maximum score
		LEA R0, MAXOUT
		PUTS
		JSR LETTERGRADE
		STI R5, MAXGRADE
		JSR STACK
		LD R0, SPACE
		OUT
		LDI R0, MAXGRADE
		OUT
		LD R0, NL
		OUT
		HALT 											; after the output displays, HALT because the program has finished running

; mini data section
FGRADESCALE	.FILL		#-59									; #-59 because 59 or less equals an 'F'
DGRADESCALE	.FILL		#-60									; #-60 because a 'D' equals scores between #60 and #69
CGRADESCALE	.FILL		#-70									; #-70 because a 'C' equals scores between #70 and #79
BGRADESCALE	.FILL		#-80									; #-80 because a 'B' equals scores between #80 and #89
AGRADESCALE	.FILL		#-90									; #-90 because an 'A' equals scores between #90 and #100
FGRADE		.FILL		#70									; the ASCII value for 'F'
DGRADE		.FILL		#68									; the ASCII value for 'D' (note: two away from F, skip E)
CGRADE		.FILL		#67									; the ASCII value for 'C'
BGRADE		.FILL		#66									; the ASCII value for 'B'
AGRADE		.FILL		#65									; the ASCII value for 'A'

; note: I tried this the other way around to check for F through A, and it didn't work. The only way I got it to work was this way checking A through F.
LETTERGRADE	ST R7, SAVEREG7										; The LETTERGRADE subroutine that determines the letter grade of a score, R7 is backed up just in case since there's branching
		JSR PREPLETTER										; jumps to a subroutine that performs housekeeping
		LD R1, AGRADESCALE									; loads the AGRADESCALE value to subtract from a score to determine if the grade was an 'A'
		ADD R3, R2, R1										; subtract #90 from a score
		BRzp LETTERA										; if zero or postitive, the score was an A
		JSR PREPLETTER										; jumps to a subroutine that performs housekeeping
		LD R1, BGRADESCALE									; loads the BGRADESCALE value to subtract from a score to determine if the grade was a 'B'
		ADD R3, R2, R1										; subtract #80 from a score
		BRzp LETTERB										; if zero or positive, the score was a B
		JSR PREPLETTER
		LD R1, CGRADESCALE									; loads the CGRADESCALE value to subtract from a score to determine if the grade was a 'C'
		ADD R3, R2, R1										; subtract #70 from a score
		BRzp LETTERC										; if zero or positive, the score was a C
		JSR PREPLETTER
		LD R1, DGRADESCALE									; loads the DGRADESCALE value to subtract from a score to determine if the grade was a 'D'
		ADD R3, R2, R1										; subtract #60 from a score
		BRzp LETTERD										; if zero or positive, the score was a D
		LD R5, FGRADE										; otherwise, the score was an 'F'
		LD R7, SAVEREG7										; load the saved R7 just in case it was destroyed.
		RET
		
PREPLETTER	AND R3, R3, #0										; this subroutine just performs housekeeping for LETTERGRADE
		RET											; clear R3, it will hold the result of the subtracting R1 from R2 (either min, max, or avg grade)

LETTERA		LD R5, AGRADE										; load the ASCII value for 'A' into R5
		LD R7, SAVEREG7										; load the saved R7 which is the return address
		RET											; jump to return address, I don't know if "go-to" is structured programming but this facilitated implementation

LETTERB		LD R5, BGRADE										; load the ASCII value for 'B' into R5
		LD R7, SAVEREG7										; the same "go-to" branching is repeated here through LETTERD
		RET

LETTERC		LD R5, CGRADE										; load the ASCII value for 'C' into R5
		LD R7, SAVEREG7
		RET

LETTERD		LD R5, DGRADE										; load the ASCII value for 'D' into R5
		LD R7, SAVEREG7
		RET

; The STACK, STACKLOOP, UNSTACK, DIV2, DECODE, and CONT subroutines were based on the example in Lab 10 (random number generator), but changed considerably for this program and to work within this program.
STACK		ST R7, SAVEREG7										; back up R7 just in case it gets destroyed with all of the branching going on
		AND R0, R0, #0										; clear R0
STACKLOOP	AND R3, R3, #0										; clear R3, STACKLOOP performs a modulus 10 on the score to output the digits in the correct order
		ADD R3, R3, #10										; R3 = #10
		JSR DIV2										; JSR DIV2
		ST R5, SAVEREG5										; store the quotient in SAVEREG5
		AND R2, R2, #0										; clear R2
		ADD R2, R2, R4										; add the remainder to R2 so that it can enter the stack via R2 and get pushed onto it		
		JSR PUSH										; reusing the stack that has been used throughout this program to push remainders for display
		ADD R0, R0, #0										; set condition flags for stack full-driven behavior
		BRnz UNSTACK										; if the stack is full, then unstack, this isn't what drives it but just in case (see below)
		LD R5, SAVEREG5
		AND R2, R2, #0
		ADD R2, R5, #0										; add the quotient and the remainder 
		BRp STACKLOOP										; if positive, the quotient in R5 goes gets loaded into R2 for another round of division
													; if negative, then the program "falls through" to UNSTACK which drives the UNSTACK behavior		

UNSTACK		JSR POP											; pop a digit of the stack
		LDI R0, SAVEPOP										; load the value in SAVEPOP to see if the pop was successful
		ADD R0, R0, #0										; set condition flags for stack empty behavior
		BRzp CONT										; if the stack is empty, then branch to CONT and RET to the function that called STACK
		JSR DECODE										; DECODE is the subroutine to handle ASCII offset
		ADD R0, R2, R0										; add the popped value to the negatively ASCII offsetted R0 from DECODE									
		OUT											; output digit to console
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

DECODE		AND R1, R1, #0										; this subroutine just offsets R0 by the HEX x-30 for ASCII display									
		AND R0, R0, #0
		LD R1, HEX30										; load HEXN30 reverse ASCII offset into R1
		ADD R0, R0, R1
		RET

CONT		LD R7, SAVEREG7										; after all the digits from a score value stored in memory are modulus 10 stacked, pushed, unstacked, popped, and displayed
		RET											; return to the calling function

MINOUT		.STRINGZ	"Minimum: "								; string to put next to minimum grade
MAXOUT		.STRINGZ	"Maximum: "								; string to put next to maximum grade
AVGOUT		.STRINGZ	"Average: "								; string to put next to average grade
NOTNUM		.STRINGZ	"\nNot a #"								; Not a number error
NOCHARSEN	.STRINGZ	"\nNo chars entered"							; a string just in case a serious error occurs with the number of chars entered
NEGERROR	.STRINGZ	"\nScore cannot be neg"							; error message to enter if user tries entering the dash/minus key
EXAM100P	.STRINGZ	"\nScore cannot be>100"							; error message if the exam score entered is > 100
.END
