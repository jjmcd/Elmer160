/* Template source file generation only partially implemented. */
/* ----------------------------------------------------------------------- */
/* Template source file generated by piklab */
#include <p24Fxxxx.h>

/* ----------------------------------------------------------------------- */
/* Configuration bits: adapt to your setup and needs */
//! Configuration bits
_CONFIG2(FNOSC_PRIPLL & POSCMOD_XT) // Primary XT OSC with PLL
//! Configuration bits
_CONFIG1(JTAGEN_OFF & FWDTEN_OFF)   // JTAG off, watchdog timer off


#define DELAY 200000

static int states[] = {
	0xff,0x5c,0xff,0x02,0xff,0xf9,0xff,0x02, /* 0x07 */
	0xf7,0x00,0x02,0x0a,0x02,0xf5,0x00,0x45, /* 0x0f */
	0x49,0x47,0xbe,0x4f,0xb8,0xf2,0xba,0x02, /* 0x17 */
	0xb5,0x07,0xf7,0x0a,0x45,0x4d,0x4d,0xb8, /* 0x1f */
	0x07,0xbf,0x07,0x50,0x12,0x10,0xaa,0xaf, /* 0x27 */
	0xee,0x45,0xfa,0xb7,0xfa,0x09,0xf8,0x00, /* 0x2f */
	0xb8,0x1a,0x19,0x44,0x04,0x04,0x02,0x14, /* 0x37 */
	0xf2,0xb0,0xeb,0x5a,0xef,0x11,0x5d,0x14, /* 0x3f */
	0x4d,0xab,0x0b,0xa2,0xb8,0xe6,0x14,0x47, /* 0x47 */
	0x00,0x0a,0xa2,0x9a,0xf5,0x58,0x65,0x1c, /* 0x4f */
	0x74,0xf0,0x60,0x93,0xca,0x87,0x08,0x2f, /* 0x57 */
	0x1c,0x25,0x88,0x04,0xc2,0x86,0xe3,0x69, /* 0x5f */
	0xf3,0x1a,0xf7,0x40,0x72,0x02,0x5a,0x51, /* 0x67 */
	0x58,0x21,0x09,0x23,0x20,0x70,0x00,0x48, /* 0x6f */
	0x0b,0x49,0x73,0x62,0x33,0x10,0x3b,0x09, /* 0x77 */
	0x7b,0x00,0x49,0x48,0x48,0x10,0x40,0x11, /* 0x7f */
	0x40,0x19,0x00,0x09,0x08,0x09,0x10,0x10, /* 0x87 */
	0x10,0x00,0x09,0x01,0x09,0x10,0x18,0x10, /* 0x8f */
	0x00,0x11,0x10,0x10,0x00,0x00,0x01,0x01, /* 0x97 */
	0x11,0x00,0x11,0x00,0x00,0x00,0x00,0x10, /* 0x9f */
	0x00,0x10,0x00,0x10,0x00,0x00,0x00,0x00, /* 0xa7 */
};

void dawdle( long n )
{
	long j,k;

	for ( j=0; j<n; j++ )
		k++;
}

int main()
{
	int i;

	TRISA=0xff00;
	LATA=0xff;

	while (1)
	{
		for ( i=0; i<0xa8; i++ )
		{
			LATA=states[i];
			dawdle( DELAY );
		}
		dawdle( 2*DELAY );
	}
	return 0;
}
