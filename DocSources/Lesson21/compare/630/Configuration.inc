; Configuration.inc
;
;	Establish configuration bits for 18 pin processors that
;	might be used with the PIC-EL.  Note that this application
;	expects to have EEPROM, so the 16F716 is absent.
;
;	Note that only the following have been tested:
;		16F84A
;		16F88
;		16F628
;		16F648A
;		16F819
;
;	The 16F84, 16F627/A, 16F628A ad 16F818 should work but
;	have not been tested.
;
;  WB8RCR - 1-Sep-06
;  $Revision: 1.13 $  $State: Exp $ $Date: 2007-06-13 10:21:20-04 $
;
	IF PROC == 627
		IFDEF __16F648A
			; For PIC16F648A
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _BODEN_OFF & _LVP_OFF
		ELSE
			; For PIC16F627, 627A, 628, 628A
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _BODEN_OFF & _LVP_OFF
		ENDIF
	ELSE
		IF PROC == 819
			; For PIC16F819, should also be OK for 818
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _BODEN_OFF & _LVP_OFF
		ELSE
			IF PROC == 88
				; For PIC16F88
				__config	_CONFIG1, _XT_OSC & _WDT_OFF & _BODEN_OFF & _LVP_OFF & _PWRTE_ON & _CCP1_RB3
				__config	_CONFIG2, _IESO_OFF & _FCMEN_OFF

			ELSE
				; For PIC16F84, 84A.  App is too large for 16F83
				__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
			ENDIF
		ENDIF

	ENDIF

