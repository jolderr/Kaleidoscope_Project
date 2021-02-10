; Description: Making a Kaleidoscope
; Authors: Josh Nguyen & Jonathan Olderr
; Date 10/30/2020
;
; Reference: Guidance provided by Matthew Bell

INCLUDE Irvine32.inc

.data

;initalizing array t
arrayEAX DWORD 24 DUP (?)

.code

main proc
	
	;sets random seed
	call Randomize

	;calls function to creat kaleidoscope
	call PrintAllLines

	;resets text color back to white
	mov eax, 15
	call setTextColor
	
	exit
main endp



;---------------------------------------------------------------
generateLine PROC
; Creates Array of colors (EAX values), creates symmetry using runtime stack
;
; Receives: eax register, for randomize & color assignment
;
; Returns: arrayEAX holds EAX for color reference
;
; Requires: Global arrayEAX and Irvine32.inc
;
;---------------------------------------------------------------

	;loop counter
	mov ecx, 12

	;initalizing index
	mov esi, 0

	;L1 fills the first half of arrayEAX with random values
	L1:

		;initalizing rand of RandomRange
		mov eax, 16
		call RandomRange

		shl eax, 4

		;push eax value to be called in L2
		push eax

		;move random eax value into arrayEAX at esi index
		mov arrayEAX[esi], eax
		
		;increment index
		add esi, 4
	loop L1

	;loop counter
	mov ecx, 12

	;L2 fills the second half of arrayEAX with mirrored values from the first half
	L2:
		;pop stack value into eax
		pop eax

		;move eax value into arrayEAX at index esi
		mov arrayEAX[esi], eax
		
		;increment index
		add esi, 4
	loop L2

	ret
generateLine ENDP



;---------------------------------------------------------------
printLinePair PROC
; Generates horizontal symmetry for kaleidoscope
;
; Recieves: bl & bh, which hold y-coordinates for rows
;
; Returns: Kaleidoscope line and it's correspoding horizontal symmetry
;
; Requires: function generateLine and Irvine32.inc
;---------------------------------------------------------------
	
	;function call fills arrayEAX with eax values to be used
	;in setTextColor
	call generateLine

	;loop counter
	mov ecx, 24
	
	;initalizng starting column (x-value)
	mov dl, 0
	
	;initalizing index
	mov esi, 0

	L1:
		;move value into eax to set background color
		mov eax, arrayEAX[esi]

		;background color is set depending on the calue in EAX
		call setTextColor

		;character to be printed is inputted into al
		mov al, " "
		
		;puts coursor on corresponding x-y cordinate
		;(x, y) = (dl, dh)
		mov dh, bl 
		call Gotoxy
		
		;prints char held in al at spot designated by GotoXY
		call WriteChar

		;puts coursor on corresponding x-y cordinate
		;(x, y) = (dl, dh)
		mov dh, bh
		call Gotoxy
		
		;prints char held in al at spot designated by GotoXY
		call WriteChar

		;increment pointer
		add esi, 4

		;increment dl, (holder of x-cordinate)
		inc dl
	loop L1

	ret
printLinePair ENDP



;---------------------------------------------------------------
printAllLines PROC
; Fucntion to print out kalidoscope
;
; Recieves: Nothing
;
; Returns: Printed Kalidescope
;
; Requires: Function printLinePair, generateLine, and Irvine32.inc
;---------------------------------------------------------------
	;keeps track of top horizontal symmerty
	mov bl, 0
	;keeps track of top horizontal symmerty
	mov bh, 23

	;loop will continue until the two symmetic lines meet
	.WHILE bl < bh
		
		;function call
		call PrintLinePair
		
		;increment bottom row
		inc bl
		;decrement top row 
		dec bh
	.ENDW
	ret
printAllLines ENDP


end main