; Lesson 5a - PIC Elmer lesson 5
; WB8RCR - 17 Nov 2003

		processor	16f84a
		include		<p16f84a.inc>
		__config	_HS_OSC & _WDT_OFF & _PWRTE_ON

; Variable Storage

		cblock		H'20'
			Spot1			; First program variable
			Spot2			; Second program variable
		endc

Spot1	equ		H'20'		; First program variable
Spot2	equ		H'21'		; Second program variable


; Program code

Start
	;	Clear the status bits so we know their state
		bcf			STATUS,Z
		bcf			STATUS,C
		bcf			STATUS,DC

	;	Show how clrf affects the Z flag
		clrf		Spot1	; Clear out Spot1

	;	Show how a carry out of bit 7 affects the C flag
		movlw		H'f0'	; Store H'f0' in Spot2
		movwf		Spot2	;

		movlw		H'10'	; Add a H'10' to Spot2
		addwf		Spot2,W	; 

		nop		
		end					; And we're done
