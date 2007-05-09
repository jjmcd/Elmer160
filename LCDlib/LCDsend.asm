		title		'LCDsend - Send data to the LCD display'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off
		include		LCDMacs.inc

;**
;  LCDsend
;
;  Send command to the LCD display
;
;  Sends the 8 bit command, 4 bits at a time
;
;**
;  WB8RCR - 20-Nov-04
;  $Revision: 2.0 $ $Date: 2007-05-09 11:22:33-04 $

		global		LCDsend
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del40us		; Delay 40 usec

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
		call	Del40us		; Wait 40 us
		return
		end
