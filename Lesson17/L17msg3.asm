			title		'L17msg3 - Display Watson message on the LCD'
			subtitle	'Part of the Lesson 17 regression test'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	L17msg3 - Display a scrolling message on the LCD
;
;	This subroutine scrolls the message 'Watson, come here please.'
;	across the left 8 characters of the display.
;
;**
;	JJMcD - 14-May-05
;	$Revision: 1.8 $ $State: Rel $ $Date: 2005-08-09 21:03:56-04 $

			include		p16f84a.inc

			global		Msg3
			extern		LCDletr,LCDshift,LCDunshf,LCDaddr
			extern		Del256ms

			udata
MsgIdx		res			1					; Counter for message index

;	Table containing the message to display

TABLES		code
Msg3T		movlw		high Msg3Ts			; Pick up high byte of table address
			movwf		PCLATH				; And save into PCLATH
			movf		MsgIdx,W			; Pick up index
			addwf		PCL,F				; And look up in table
Msg3Ts		dt			"Watson, come here please.       ",0

;	Subroutine to display the scrolling message

			code
Msg3		clrf		MsgIdx				; Clear out the message index
			call		LCDshift			; Set the LCD to shift mode
			movlw		H'08'				; Position to the right end
			call		LCDaddr				; of the LCD display
Msg3L		call		Msg3T				; Go get the character
			xorlw		H'00'				; Test to see if it was a zero
			btfsc		STATUS,Z			; Was it?
			goto		Msg3Q				; Yes, all done
			call		LCDletr				; Display the letter on the LCD
			call		Del256ms			; Wait so message isn't total blur
			incf		MsgIdx,F			; Point to the next letter
			goto		Msg3L				; And go do it again
Msg3Q		call		LCDunshf			; Leave shifting turned off
			return
			end
