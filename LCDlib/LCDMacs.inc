		nolist
; Macros and defines used in LCDlib

;------------------------------------------------------------------
; Add include so it only needs to be in one place
		include		p16f84a.inc

;------------------------------------------------------------------
; How many lines on the display
; Comment out for a single line display
#define LCD2LINE


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
