;	Less17e5.asm - Subroutine to display messages
;
;	JJMcD - 2005-04-26
;	$Revision: 1.1 $ $Date: 2005-04-26 10:55:20-04 $
			include		Processor.inc
			extern		LCDletr
			global		Msg1,Msg2

TABSTOR		udata
SavIdx		res			1			; Temporary storage for index

TABLES		code		H'300'		; Start on a page boundary
;	Table of digits to display
Msg1T		movwf		SavIdx		; Save off the index
			movlw		HIGH(Msg1T)	; Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
M1S			dt			" AmQRP  "
M1E
Msg1Len		equ			M1E-M1S		; Message length

Msg2T		movwf		SavIdx		; Save off the index
			movlw		HIGH(Msg1T)	; Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
M2S			dt			" DL-QRP "
M2E
Msg2Len		equ			M2E-M2S		; Message length

;	Storage for message index
			udata
MsgIdx		res			1			; Storage for index into table
			code

;	Send message 1 to the LCD
Msg1		
			clrf		MsgIdx		; Clear out the message index
Msg1L
			movf		MsgIdx,W	; Pick up index into message
			call		Msg1T		; Get the letter from the table
			call		LCDletr		; Send it to the LCD
			incf		MsgIdx,F	; Point to next letter
			movlw		Msg1Len		; Test whether we have used
			subwf		MsgIdx,W	; all the letters in the message
			btfss		STATUS,Z	; ?
			goto		Msg1L		; No, go do next letter
			return					; Yes, all done with message

;	Send message 2 to the LCD
Msg2
			clrf		MsgIdx		; Start at the beginninf
Msg2L
			movf		MsgIdx,W	; Current letter
			call		Msg2T		; Get it
			call		LCDletr		; Send it
			incf		MsgIdx,F	; Next letter
			movlw		Msg2Len		;
			subwf		MsgIdx,W	;
			btfss		STATUS,Z	; Done?
			goto		Msg2L		; No
			return					; Yes

			end

			
