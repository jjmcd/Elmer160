; Lesson14a.asm - Example of using PCLATH
;
;  WB8RCR - 3-Jun-04
;
;=====================================================================
;
; *************************
; *** WARNING PIC16F877 ***
; *************************

		processor	pic16f877
		include		p16f877.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON
		errorlevel	-306
		list		b=4,n=70

		goto		Start

;	Mainline begins here
		org			h'80'
Start
		movlw		h'06'		; Setup PCLATH for a table
		movwf		PCLATH		; in page 6
;		pagesel		Table		; Doesn't work, only gets two bits
		movlw		D'2'		; Load index into table
		call		Table		; return with result in W
		nop						; Just a chance to look

;	Show how calls move around.  Note that PCLATH still
;	contains a 6, but only bits 3 and 4 are used to form
;	the target address of the call

								; Set something in W. Even though PCLATH
		movlw		h'ff'		; contains a 6, call to page 0 works, as
		call		S0050		; does page 7 because they don't need 
		call		S0750		; bits 3 and 4. But page 8 ends up
		call		S0850		; in the wrong place as does page 1f
		call		S1f50		; because bits 3 and 4 wrong
		nop

;	Lets try those last two calls with PCLATH set correctly
		movlw		h'08'		; Set up PCLATH to point to
		movwf		PCLATH		; page 8
		movlw		h'ff'		; Value in W
		call		S0850		; Call now goes to correct place and
		nop						; returns with 8 in W

		movlw		h'1f'		; Now set up PCLATH to point to
		movwf		PCLATH		; page 1f
		movlw		h'ff'		; Value in W
		call		S1f50		; Again call ends up in the right place
		nop						; and returns with 1f in W

alldud	goto		alldud

;	Lookup table in page 6
;
;	Return with D'16' times the W register in W

		org			h'600'
Table
		addwf		PCL,F
		dt			h'00',h'10',h'20',h'30',h'40',h'50',h'60'
;		retlw		h'00'
;		retlw		h'10'
;		retlw		h'20'
;		retlw		h'30'
;		retlw		h'40'
;		retlw		h'50'
;		retlw		h'60'

;	Example subroutine in page 0

		org			h'50'
S0050	movlw		h'00'
		return

;	Subroutine in page 7
		org			h'750'
S0750	movlw		h'07'
		return

;	Subroutine in page 8
		org			h'850'
S0850	movlw		h'08'
		return

;	Subroutine in page 1f
		org			h'1f50'
S1f50	movlw		h'1f'
		return

		end
