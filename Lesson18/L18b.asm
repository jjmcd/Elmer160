			title		'L18b - Test harness for ConvHex2'
			subtitle	'Part of Lesson 18 on display conversion'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	L18b
;
;	Stores a multi-byte value in a defined area, binary.  Then calls
;	ConvHex2 to convert the result to ASCII Hex and store the result
;	in the 4-byte area digits.
;
;	This routine is intended only to test the routine.  Place a breakpoint
;	after the call to ConvHex2 and open a watch window on binary and digits
;	or watch the file register memory to test.  Note that in a watch window
;	the properties will have to be adjusted for the storage size.
;
;**
;  WB8RCR - 10-Aug-05
;  $Revision: 1.2 $ $State: Exp $ $Date: 2005-08-12 09:31:32-04 $

			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF


			global		binary,digits
			extern		ConvHex2

#define value H'1b90'				; Initial value for test

			udata
binary		res			2			; Storage for input
digits		res			4			; Storage for result

STARTUP		code					; Reset vector
			nop
			goto		Start

			code
Start
			movlw		high value	; Initialize high byte
			movwf		binary		; of input value, and
			movlw		low value	; then low byte.
			movwf		binary+1
LoopF
			call		ConvHex2	; Do the conversion

			incfsz		binary+1,F	; Increment the low byte
			goto		LoopF		; If no overflow, do it again
			incf		binary,F	; otherwise, increment high
			goto		LoopF		; byte and do it again.

			end
