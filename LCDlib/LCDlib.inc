;  Include file for LCDlib
;
;  WB8RCR - 24-Sep-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:52-04 $


;	Defines for LCDsubs
		extern		LCDclear	; Clear the LCD
		extern		LCDzero		; Set the DDRAM address to zero
		extern		LCDaddr		; Set the DDRAM address
		extern		LCDshift	; Set the LCD to shift mode
		extern		LCDunshf	; Turn off LCD shift mode
		extern		LCDinit		; Initialize the LCD
		extern		LCDinsc		; Initialize 16 character scrolling
		extern		LCDletr		; Send a letter to the LCD
		extern		LCDdig		; Send a digit to the LCD
		extern		LCDmsg		; Display a variable length message
		extern		LCDsc16		; Scroll text on 2x8 (1x16) display
		extern		LCD8		; Set the DDRAM address to the end
		extern		Del2ms		; Delay 1.8 msec
		extern		Del128ms	; Delay 128 msec
		extern		Del256ms	; Delay a quarter second
		extern		Del512ms	; Delay a half second
		extern		Del1s		; Delay 1 sec
		extern		DelWrk		; Delay while working
		extern		DelWrkL		; Delay while working - longer
		extern		DelCt1		; Counters for delay while working
		extern		DelCt2		; Counters for delay while working
		extern		DelCt3		; Counters for delay while working
