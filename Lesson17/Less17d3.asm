;	Less17d2 - Send command byte to LCD
;
;	JJMcD - 2005-03-19
;	$Revision: 1.1 $ $Date: 2005-03-19 11:13:34-04 $

		global		LCDsend
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del2ms		; Delay 1.8 msec

LCD1	udata_ovr
SavCmd	res			1

		code
LCDsend
		movwf	SavCmd		; Save off the command
		swapf	SavCmd,W	; Swap nybbles
		call	LCDsndI		; Send hugh nybble
		movf	SavCmd,W	; Grab it again
		call	LCDsndI		; Send low nybble
		call	Del2ms		; Wait for command
		return
		end
