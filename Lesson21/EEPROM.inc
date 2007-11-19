			title		'EEPROM.inc - EEPROM Constants'
			subtitle	'Part of Lesson 21 on multiple processors'
			list		b=4,c=132,n=77,x=Off

;	EEPROM.inc
;
;	This include file holds the address we want to
;	use in EEPROM.  It also holds a processor-specifig
;	value for the registers used in the EEPROM write.
;
SAVADR		equ		H'04'

;	The EEPROM interrupt bits, EEIE and EEIF, are in different
;	registers in different processors.  Since this shows up in
;	a number of places, we will establich two new manifest constants,
;	IEREG and IFREG, to point to the appropriate registers for
;	the EEIE and EEIF flags, respectively.
;
;    $Revision: 1.14 $ $State: Exp $ $Date: 2007-11-19 10:35:53-05 $

	IF		PROC==84
IEREG		equ		INTCON
IFREG		equ		EECON1
	ENDIF

	IF		PROC==627
IEREG		equ		PIE1
IFREG		equ		PIR1
	ENDIF

	IF		(PROC==88) || (PROC==818) || (PROC==819) || (PROC==872)
IEREG		equ		PIE2
IFREG		equ		PIR2
	ENDIF


