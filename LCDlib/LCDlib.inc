;	Include file for LCDlib
;
;	WB8RCR - 24-Sep-04


;	Defines for LCDsubs
		extern		LCDclear	; Clear the LCD
		extern		LCDzero		; Set the DDRAM address to zero
		extern		LCDshift	; Set the LCD to shift mode
		extern		LCDunshf	; Turn off LCD shift mode
		extern		LCDinit		; Initialize the LCS
		extern		LCDletr		; Send a letter to the LCD
		extern		LCDdig		; Send a digit to the LCD
		extern		LCD8		; Set the DDRAM address to the end
		extern		Del2ms		; Delay 1.8 msec
		extern		Del128ms	; Delay 128 msec
		extern		Del1s		; Delay 1 sec
		extern		DelWrk		; Delay while working
		extern		DelWrkL		; Delay while working - longer
		extern		DelCt1		; Counters for delay while working
		extern		DelCt2		; Counters for delay while working
		extern		DelCt3		; Counters for delay while working