		processor	PIC16F84A
		include		<p16f84a.inc>
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

		cblock		H'20'
			Spot1			; A variable to play with
		endc

		goto		Start	; Skip to mainline
;	New subroutine begins here
Sub2
		incf		Spot1,F
		return
;	Original subroutine begins here
Sub1
		call		Sub2
		return
;	Here is the start of the mainline
Start
		movlw		H'fc'	; Put something in
		movwf		Spot1	; Spot1
Loop
		call		Sub1	; Call the subroutine
		goto		Loop	; Do it again

		end
		
