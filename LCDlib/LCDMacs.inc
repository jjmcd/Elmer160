		nolist
; Macros used in LCDlib

;------------------------------------------------------------------
; Send a 16 bit command to the LCD
LCD16	Macro	LCDfirst,LCDsecond
		movlw	LCDfirst	; High byte
		call	LCDsndI
		call	Del40us	; 40us
		movlw	LCDsecond	; Low byte
		call	LCDsndI
		call	Del2ms		; 4.1ms
		endm
		list
