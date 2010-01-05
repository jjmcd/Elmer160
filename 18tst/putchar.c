// $Id: putchar.c,v 1.1 2007-03-25 16:54:54-04 jjmcd Exp jjmcd $
/*
  putchar.c - Provide LCD interface for STDIO

  John J. McDonough - 16-Feb-07

*/

#include <pic18fregs.h>
#include <stdio.h>

// Define to clarify single byte used as number vs letter
#define byte unsigned char

// The following functions are assembled/compiled externally
//
// Display a character on the LCD
void LCDletr( char );
// Clear the LCD
void LCDclear( void );
// Set the cursor position on the LCD
void LCDaddr( byte );
// Set the LCD cursor to the first position
void LCDzero( void );

static int nLCDcursPos = 0;
void putchar( char ch ) wparam
{

  if ( ch == (char)0x0c )
    {
      nLCDcursPos = 0;
      LCDclear();
      LCDzero();
    }
  else
    {
      LCDletr( ch );
      nLCDcursPos++;
      //if ( nLCDcursPos == 8 )
      //LCDaddr(0x40);
    }
}
