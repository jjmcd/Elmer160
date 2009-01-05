			title		'setAnalog - Set analog pins to digital'
			subtitle	'Part of Lesson 21 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc

;------------------------------------------------------------------------
;**
;	setAnalog
;
;	Sets any analog pins to digital for PIC-EL
;
;	WARNING - This is reasonable with the PIC-EL because no pins
;	that might be analog are floating.  In a different circuit, this
;	coule result in destruction of the part.
;
;**
;	WB8RCR - 04-Jan-09
;	$Revision: 1.1 $ $State: Exp $ $Date: 2009-01-05 13:28:02-05 $

			global		setAnalog
			code
setAnalog
			errorlevel	-302			; Turn off whining about banks

		IF ( PROC == 818 )
			banksel		ADCON1			; For 818, 819, need to turn
			movlw		H'07'			; off A/D converter pins
			movwf		ADCON1			; in ADCON1.
		ENDIF
	        IF ( PROC == 88 )
			banksel		ANSEL			; For 88, need to deselect
			movlw		H'00'			; A/D converter pins in
			movwf		ANSEL			; ANSEL
		ENDIF
	        IF ( PROC == 627 ) || ( PROC == 627A )
			banksel		CMCON			; For 627/A, 628/A, 648A
			movlw		H'07'			; need to turn off
			movwf		CMCON			; comparator
		ENDIF
		IF ( PROC == 716 )
			banksel		ADCON1			; For 716, need to turn
			movlw		H'07'			; off A/D converter pins
			movwf		ADCON1			; in ADCON1
		ENDIF
	
			errorlevel	+302			; Error message back on
			banksel		0
			return		
			end

