			title		'LCDletr, LCDdig - Display letter or digit'
			subtitle	'Part of the LCDlib library'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  Send a digit to the LCD.
;
;  LCDdig sends a digit to the LCD.  The digit
;  will be entered at the current DDRAM postion.
;  The digit is provided in the lower four bits
;  of the W register.  If the lower four bits of the
;  W register contains a value higher than 9, a
;  trash character will be displayed. The
;  contents of the W register are destroyed on
;  exit.
;
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.10 $ $Date: 2005-01-23 11:08:50-05 $

			include		"LCDMacs.inc"

	; Provided Routines
			global		LCDdig,LCDletr
	; Required routines
			extern		LCDsndD
			extern		Del40us

_LCDOV1		udata_ovr
SaveLetr	res			1			; Storage for letter

			code
LCDdig:
			andlw		00fh
			iorlw		030h		; note falls thru

LCDletr:
			movwf		SaveLetr	; save off the letter
			swapf		SaveLetr,W	; Swap bytes
			call		LCDsndD

			movfw		SaveLetr	; get it
			call		LCDsndD

			call		Del40us		; delay a while
									; Note: Doesn't work without this
			return

			end
