		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

		extern		aSub

		udata
var1	res			1

STARTUP	code
		goto		Start

		code
Start
		movlw		h'17'
		call		aSub
		movwf		var1

aa		goto		aa
		end
