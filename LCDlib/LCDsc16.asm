; Scrolling the 16-character display
;
;	The 16x1 display is actually two, 8 char displays arranged
;	side by side.  In order to scroll characters from the left
;	the the right, the character is written twice.  Once in the
;	second line, where it will appear immediately, and once
;	to the right of the first line, so it will appear on the
;	right of the first line when the character on the second
;	line disappears off the left.
;
;
;            <------ Line 1 ------> | <------ Line 2 ------>
;	Before scrolling
;	Display   0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
;   Memory    0  1  2  3  4  5  6  7 40 41 42 43 44 45 46 47
;
;	Scrolled left 39(dec) times
;	Display   0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
;   Memory   27  0  1  2  3  4  5  6 67 40 41 42 43 44 45 46
;
;	To handle this, we turn on scrolling, and write the
;	letter one character to the right of display position
;	0f.  The scrolling will cause the letter to display
;	in the leftmost position.  We then turn off scrolling
;	and write the same letter 8 locations to the right of
;	display position 7.  When the letter written to line
;	2 scrolls off the left of line 2, the second copy will
;	scroll into the right of line 1.
;
;	$Revision: 1.1 $ $Date: 2005-02-05 17:29:04-05 $

		include		Processor.inc

;	Provided routine
		global		LCDsc16		; Scroll char in from right
;	Storage shared with LCDinsc
		extern		LCDad1,LCDad2
;	Routines within LCDlib
		extern		LCDaddr,LCDletr
		extern		LCDshift,LCDunshf
;	Manifest constants
L1START	equ			H'00'		; Start of line 1
L1END	equ			H'28'		; First char past end of line 1
L2START	equ			H'40'		; Start of line 2
L2END	equ			H'68'		; First char past end of line 2

_LCDOV2	udata_ovr
Char	res			1			; Temporary storage for char

_LCDOV1	udata_ovr
Temp	res			1			; Temporary storage for addr

		code
LCDsc16
		movwf		Char		; Save off the character

		call		LCDshift	; Set the LCD to shift mode
		movf		LCDad2,W	; Pick up the address
		call		LCDaddr		; Set the cursor address
		movf		Char,W		; Pick up the character
		call		LCDletr		; and write it
		incf		LCDad2,F	; Increment the address
		movf		LCDad2,W	; Get the address and see if
		call		Limit		; we have run off the end of
		movwf		LCDad2		; memory, if so, wrap it.

		call		LCDunshf	; Set to unshift so we don't
		movf		LCDad1,W	; shift twice.  Now handle the
		call		LCDaddr		; second write just like
		movf		Char,W		; the first.
		call		LCDletr
		incf		LCDad1,F
		movf		LCDad1,W
		call		Limit
		movwf		LCDad1
		return

;	Test whether the address has moved off the high end
;	of memory for a line
Limit
		movwf		Temp		; Save off the address
		sublw		L1END		; Is it past the end of line 1?
		btfsc		STATUS,Z	;
		goto		Limit1		; Yes, go wrap it
		movf		Temp,W		; Pick up the address again
		sublw		L2END		; Is it off the end of line 2?
		btfsc		STATUS,Z
		goto		Limit2		; Yes, go wrap it
		movf		Temp,W		; No wrapping, pic up
		return					; original address
Limit1
		movlw		L1START		; Return start of line 1
		return
Limit2
		movlw		L2START		; Return start of line 2
		return
		end
