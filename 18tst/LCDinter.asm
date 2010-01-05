
	include		Processor.inc
	
	extern		LCDinit,LCDletr,LCDclear,Del1s,Del256ms,LCDzero,LCDaddr,Del2ms
	global		_LCDinit,_LCDletr,_LCDclear,_Del1s,_LCDzero,_LCDaddr,_Del2ms

	code			

_LCDinit:
	goto		LCDinit

_LCDletr:
	call		LCDletr
	return

_LCDzero:
	call		LCDzero
	return

_LCDaddr:
	call		LCDaddr
	return

_LCDclear:
	;; 	call		LCDzero
	call		LCDclear
	;; 	call		Del256ms
	return

_Del1s:
	call		Del1s
	return

_Del2ms:
	call		Del2ms
	return

	end
	
