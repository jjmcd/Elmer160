		list		b=4,c=132,n=77,x=Off
		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDinit		; Initialize the LCD
	; Required routines
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del40us		; Delay 40 usec
		extern		Del2ms		; Delay 1.8 msec

_LCDOV1	udata_ovr
_LCDV01	res		1		; Storage for loop counter

		code
; ------------------------------------------------------------------------
	; Initialize the LCD
LCDinit:
		; Initialize the LCD to 4 bits
		;
		; First, need to wait a long time after power up to
		; allow time for 44780 to get it's act together
		movlw	020h		; Need >15.1ms after 4.5V
		movwf	_LCDV01	; we will wait 65ms after 2V

		call	Del2ms		;
		decfsz	_LCDV01,F
		goto	$-2

		; Initialization begins with sending 0x03 3 times followed
		; by a 0x02 to define 4 bit data
		LCD16	H'03',h'03'
		LCD16	H'03',h'02'

		; Now set up the display the way we want it
		LCD16	H'02',H'08'	; Set lines, font
					; 7, 1=2 lines; 6, 0=5x7; 5, 4, don't care 
					;;; Note 0c0, 080 seems no diff on DMC20434
		LCD16	H'00',H'08'	; Display Off
		LCD16	H'00',H'01'	; Display On
		LCD16	H'00',H'06'	; Set Entry Mode
					; 7=0; 6=1; 5, 1=increment; 6, 1=shift
					;; Note, 060, 070 DOES seem to change things
		LCD16	H'00',H'0c'	; cursor, display on blink

		return
		end
