; Processor.inc - Select include based on processor symbol
		nolist
;**
;  This file includes the appropriate procesor include file
;  based on the processor symbol passed in from the IDE.
;
;  NOTE - 18-pin parts >=1K appropriate for PIC-EL only
;**
;  WB8RCR - 23-Nov-04
;  $Revision: 1.1 $ $Date: 2004-11-23 11:56:24-05 $

		IFDEF		__16F88
		include		p16f88.inc
		nolist
		ENDIF
		IFDEF		__16F627
		include		p16f627.inc
		nolist
		ENDIF
		IFDEF		__16F628
		include		p16f628.inc
		nolist
		ENDIF
		IFDEF		__16F628A
		include		p16f628a.inc
		nolist
		ENDIF
		IFDEF		__16F84
		include		p16f84.inc
		nolist
		ENDIF
		IFDEF		__16F84A
		include		p16f84a.inc
		nolist
		ENDIF
		IFDEF		__16F818
		include		p16f818.inc
		nolist
		ENDIF
		IFDEF		__16F819
		include		p16f819.inc
		nolist
		ENDIF
