			title		'Disp16 - Display 16-bit number on LCD'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc

;------------------------------------------------------------------------
;**
;	Disp16
;
;	This function displays the 16-bit value stored at 'binary'
;
;	The program relies on the BCD and LCD routines from previous lessons.
;
;**
;	WB8RCR - 19-May-06
;	$Revision: 1.5 $ $State: Exp $ $Date: 2006-09-02 11:42:48-04 $

			global		Disp16,binary,digits,dirty,LEDflg
			extern		ConvBCD2, LCDzero, LCDletr

			udata
count		res			1				; Which digit to display
binary		res			2				; Storage for input value
digits		res			5				; Storage for digits
dirty		res			1				; Remember we changed value
LEDflg		res			1

MYLIB		code
Disp16:
			call		ConvBCD2		; Convert the value to BCD
			call		LCDzero			; Cursor to left of LCD
			movlw		digits			; Pick up address of output
			movwf		FSR				; into FSR
			movlw		H'05'			; Count of number of
			movwf		count			; digits to display
Disp16L
			movf		INDF,W			; Get current digit
			call		LCDletr			; Display it
			incf		FSR,F			; Point to next digit
			decfsz		count,F			; Count down one we just did
			goto		Disp16L			; Done? No, do it again
;			movf		LEDflg,W
;			movwf		PORTB
			clrf		dirty			; Value is now current

			return

			end
