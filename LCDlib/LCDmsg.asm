		title		'LCDmsg - Display message on LCD'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDmsg
;
;  Display a message on the LCD.
;
;  This function displays a message stored in the general
;  purpose registers on the LCD.  The caller prepares a
;  buffer in the GPRs containing the length of the message
;  followed by the message text.  The caller then calls
;  LCDmsg with the address of that buffer in the W register.
;
;  The contents of the W register are destroyed.
;**
;  WB8RCR - 13-Nov-04
;  $Revision: 1.37 $ $Date: 2005-06-23 13:22:18-04 $

		include		LCDmacs.inc

		global		LCDmsg
		extern		LCDletr,LCDaddr

_LCDOV2	udata_ovr
BufAddr	res			1
Count	res			1
Switch	res			1

LCDLIB	code
; ------------------------------------------------------------------------
;**
;  Display a message on the LCD.
;
;  LCDmsg sends a message to the LCD.  Enter with
;  the file register address of a message buffer.
;  The buffer contains the message length, 1-16,
;  followed by the message.
;
;  If the message is greater than 8 characters,
;  LCDmsg displays the remainder of the message
;  (chars 9-16) on the second line, presuming the
;  PIC-EL 8 char by 2 line display.
;
;**
LCDmsg
		movwf		BufAddr		; Save off the buffer address
		movwf		FSR			; and write into FSR
		movf		INDF,W		; so we can pick up the length
		movwf		Count		; and save it
		IFDEF		LCD2LINE
		incf		BufAddr,F	; Point to the beginning of text
		movf		BufAddr,W	; And calculate where the start
		addlw		LCDLINELEN	; of line 2 is on the 16
		movwf		Switch		; character display
		ENDIF

MsL
		IFDEF		LCD2LINE
		movf		Switch,W	; Pick up the change line address
		xorwf		BufAddr,W	; Are we there yet?
		btfss		STATUS,Z
		goto		MsL1		; No, continue on
		movlw		LINE2OFFSET	; Yes, point to the start of 
		call		LCDaddr		; line 2 in the LCD memory
MsL1
		ENDIF
		movf		BufAddr,W	; Move the address of the next
		movwf		FSR			; letter into FSR so we can
		movf		INDF,W		; pick up the letter
		call		LCDletr		; Display the character
		incf		BufAddr,F	; Point to next char in message
		decfsz		Count,F		; Count down characters
		goto		MsL			; Not done, go do next char

		return
		end
