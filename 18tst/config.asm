	include		p18f1320.inc
	
             __CONFIG    _CONFIG1H, _IESO_ON_1H & _FSCM_OFF_1H & _HSPLL_OSC_1H
 	 __CONFIG    _CONFIG2L, _PWRT_ON_2L & _BOR_OFF_2L & _BORV_20_2L
            __CONFIG    _CONFIG2H, _WDT_OFF_2H & _WDTPS_32K_2H
            __CONFIG    _CONFIG3H, _MCLRE_ON_3H
            __CONFIG    _CONFIG4L, _DEBUG_OFF_4L & _LVP_OFF_4L & _STVR_ON_4L

            __CONFIG    _CONFIG5L, _CP0_OFF_5L & _CP1_OFF_5L
            __CONFIG    _CONFIG5H, _CPB_OFF_5H & _CPD_OFF_5H
            __CONFIG    _CONFIG6L, _WRT0_OFF_6L & _WRT1_OFF_6L
            __CONFIG    _CONFIG6H, _WRTC_OFF_6H & _WRTB_OFF_6H & _WRTD_OFF_6H
            __CONFIG    _CONFIG7L, _EBTR0_OFF_7L & _EBTR1_OFF_7L
            __CONFIG    _CONFIG7H, _EBTRB_OFF_7H

 	end
