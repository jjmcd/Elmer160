		title		'LCDsend - Send data to the LCD display'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDsend
;
;  Send command to the LCD display
;
;  Sends the 8 bit command, 4 bits at a time
;
;**
;  WB8RCR - 20-Nov-04
;  $Revision: 1.31 $ $Date: 2005-03-05 09:51:14-05 $

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
		call	Del40us	; 40us
	; Low byte
		movf	Save,W
		call	LCDsndI
		call	Del2ms		; 4.1ms
		return
		end
