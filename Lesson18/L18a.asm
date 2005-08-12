			title		'L18a - Test harness for ConvHex1'
			subtitle	'Part of Lesson 18 on display conversion'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	L18a
;
;	Stores a value in a defined area, work.  Then calls ConvHex1 to
;	convert the result to ASCII Hex and store the digits in d1 and d2.
;
;	This routine is intended only to test the routine.  Place a breakpoint
;	after the call to ConvHex1 and open a watch window on binary, d1 and d2
;	or watch the file register memory to test.
;
;**
;  WB8RCR - 10-Aug-05
;  $Revision: 1.1 $

			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF


			global		binary,d1,d2
			extern		ConvHex1

#define value H'90'					; Initial value for test

			udata
binary		res			1			; Storage for input value
d1			res			1			; Storage for first digit
d2			res			1			; Storage for second digit

STARTUP		code					; Reset vector
			nop
			goto		Start

			code
Start
			movlw		value		; Initialize value to use
			movwf		binary		; for test
LoopF
			call		ConvHex1	; Convert to hex ASCII

			incf		binary,F	; Try another value
			goto		LoopF

			end
