		title		'LCDsend - Send data to the LCD display'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off
		include		LCDmacs.inc

;**
;  LCDsend
;
;  Send command to the LCD display
;
;  Sends the 8 bit command, 4 bits at a time
;
;**
;  WB8RCR - 20-Nov-04
;  $Revision: 1.39 $ $Date: 2006-09-25 16:38:56-04 $

		global		LCDsend
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del40us		; Delay 40 usec
		extern		Del2ms		; Delay 1.8 msec

_LCDOV1	udata_ovr
Save	res			1

LCDLIB	code
LCDsend
		movwf	Save
	; High byte
		swapf	Save,W
		call	LCDsndI	; LCDsndI takes care of masking
	; Low byte
		movf	Save,W
		call	LCDsndI
		call	Del2ms		; Wait 2ms
		return
		end
