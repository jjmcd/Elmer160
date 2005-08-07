		title		'LCDsend - Send a command to the LCD'
		subtitle	'Part of the Lesson 17 replacement LCDlib library'
		list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  MySend
;
;  Send command to the LCD display
;
;  Sends the 8 bit command, 4 bits at a time
;
;**
;  WB8RCR - 2-Aug-05
;  $Revision: 1.7 $ $Date: 2005-08-07 13:37:02-04 $

		include		"LCDmacs.inc"

		global		LCDsend
		extern		LCDsndI		; Send a command nybble to the LCD
		extern		Del40us		; Delay 40 usec
		extern		Del2ms		; Delay 1.8 msec

		udata
Save	res			1

MYLIB	code
LCDsend
		movwf	Save		; Save off the incoming byte
	; High byte
		swapf	Save,W		; Get high nybble into low nybble of W
		call	LCDsndI		; LCDsndI takes care of masking
		call	Del40us		; 40us
	; Low byte
		movf	Save,W		; Grab the original value
		call	LCDsndI		; And again, LCDsndI masks
		call	Del2ms		; Wait 2ms
		return
		end
