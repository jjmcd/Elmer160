			title		'L17msg1 - Display MultiPig on the LCD'
			subtitle	'Part of the Lesson 17 regression test'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	L17msg1 - Display a message on the LCD
;
;	This subroutine displays the text 'MultiPig' on the LCD,
;	beginning at the current cursor position.
;
;**
;	JJMcD - 14-May-05
;	$Revision: 1.7 $ $State: Stab $ $Date: 2005-08-07 10:49:40-04 $

			include		p16f84a.inc

			global		Msg1
			extern		LCDletr,LCDaddr

			udata
MsgIdx		res			1				; Counter for message index

;	Table containing the message to display

TABLES		code
Msg1T		movlw		high Msg1Ts		; Pick up high byte of table address
			movwf		PCLATH			; And save into PCLATH
			movf		MsgIdx,W		; Pick up index
			addwf		PCL,F			; And look up in table
Msg1Ts		dt			"MultiPig",0	; Message, terminated with a zero

;	Subroutine to display the message

			code
Msg1
			clrf		MsgIdx			; Clear out the message index
Msg1L
			call		Msg1T			; Go get the character
			xorlw		H'00'			; Test to see if it was a zero
			btfsc		STATUS,Z		; Was it?
			return						; Yes, all done
			call		LCDletr			; Display the letter on the LCD
			incf		MsgIdx,F		; Point to the next letter
			goto		Msg1L			; And go do it again

			end
