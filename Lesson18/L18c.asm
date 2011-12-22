			title		'L18c - Test harness for ConvBCD1'
			subtitle	'Part of Lesson 18 on BCD conversion'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	L18c
;
;	Stores a value in a defined area, work.  Then calls ConvBCD1 to
;	convert the result to BCD and store the digits in d1 through d3.
;
;**
;  WB8RCR - 10-Aug-05
;  $Revision: 1.2 $ $State: Rel $ $Date: 2011-12-22 11:27:45-05 $

			include		P16F628A.INC
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _BOREN_OFF

			global		binary,d1,d2,d3
			extern		ConvBCD1

#define value D'123'				; Initial value for test

			udata
binary		res			1			; Storage for input value
d1			res			1			; Storage for resulting
d2			res			1			; ASCII digits
d3			res			1			;

STARTUP		code					; Reset vector
			nop
			goto		Start

			code
Start
			movlw		value		; Initialize the input with
			movwf		binary		; the test value
LoopF
			call		ConvBCD1	; Convert to hex ASCII

			incf		binary,F	; Try another value
			goto		LoopF		;

			end
