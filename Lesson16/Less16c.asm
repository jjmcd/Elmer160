		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

		extern		Sub1,Sub2

STARTUP	code
		goto		Start
		code
Start
		call		Sub1
		call		Sub2
		goto		Start
		end
