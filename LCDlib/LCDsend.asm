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
;  $Revision: 2.1 $ $Date: 2008-02-26 20:47:42-05 $

		global		LCDsend
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del40us		; Delay 40 usec

_LCDOV1	udata_ovr
Save	res			1

LCDLIB	code
LCDsend
		banksel	Save
		movwf	Save
	; High byte
		swapf	Save,W
		banksel	0
		call	LCDsndI	; LCDsndI takes care of masking
	; Low byte
		banksel	Save
		movf	Save,W
		banksel	0
		call	LCDsndI
		call	Del40us		; Wait 40 us
		return
		end
