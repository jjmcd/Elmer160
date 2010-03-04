
	include		p16f88.inc
	
	; For PIC16F88
	__config	_CONFIG1, _XT_OSC & _WDT_OFF & _BODEN_OFF & _LVP_OFF & _PWRTE_ON & _CCP1_RB3
	__config	_CONFIG2, _IESO_OFF & _FCMEN_OFF
	
	extern		LCDinit,LCDletr,LCDclear,Del1s
	global		_LCDinit,_LCDchar,_LCDclear,_Del1s

	code			

_LCDinit:
	lcall		LCDinit
	return

_LCDchar:
	lcall		LCDletr
	return

_LCDclear:
	lcall		LCDclear
	return

_Del1s:
	lcall		Del1s
	return

	end
	
