; Configuration.inc
;
;	Establish configuration bits for 18 pin processors that
;	might be used with the PIC-EL.  Note that this application
;	expects to have EEPROM, so the 16F716 is absent.
;
;
;  WB8RCR - 1-Sep-06
;  $Revision: 1.14 $  $State: Exp $ $Date: 2008-12-29 18:56:00-05 $
;
	IF PROC == 627A
		; For PIC16F627A, 628A, 648A
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _BODEN_OFF & _LVP_OFF
	ENDIF
	IF PROC == 627
		; For PIC16F627, 627, 628, 628
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _BODEN_OFF & _LVP_OFF
	ENDIF
	IF (PROC == 818)
		; For PIC16F818, 819
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _BODEN_OFF & _LVP_OFF
	ENDIF
	IF PROC == 88
		; For PIC16F87, 88
		__config	_CONFIG1, _XT_OSC & _WDT_OFF & _BODEN_OFF & _LVP_OFF & _PWRTE_ON & _CCP1_RB3
		__config	_CONFIG2, _IESO_OFF & _FCMEN_OFF

	ENDIF
	IF PROC == 84
		; For PIC16F84, 84A.  App is too large for 16F83
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
	ENDIF

