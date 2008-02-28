// $Id: makeLKR.c,v 1.2 2008-02-28 08:35:06-05 jjmcd Exp $

// makeLKR - Generate a linker script file for LCDlib regression
// tests with random placement of the various sections
//
// JJMcD - 27Feb08

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//! Data section sizes
int sizes[5] = { 1,3,2,2,2 };
//! Defined bank names
char szNames1[5][16] = 
  { "lcd1","lcd2","lcd3","del1","del2" };
//! Data Section names
char szNames2[5][16] = 
  { "_LCDOV1", "_LCDOV2","_LCDOV3","_DELOV1","_DELOV2" };
//! Starting locations of banks
int banks[3] = { 0x20, 0xa0, 0x120 };
//! Ending locations of banks
int banke[3] = { 0x6f, 0xef, 0x16f };
//! Default names of banks
char szDefName[3][16] = { "gpr0", "gpr1", "gpr2" };
//! Starting (useable) address of pages
int pages[2] = {0x40, 0x800 };
//! Ending address of pages
int pagee[2] = { 0x7ff, 0xfff };

// Function to output a CODEPAGE line
void codeLine( char *szName, int nStart, int nEnd, int nProtected )
{
  if ( nProtected )
    printf("CODEPAGE   NAME=%-9s START=0x%04x   END=0x%04x   PROTECTED\r\n",
	   szName,nStart,nEnd);
  else
    printf("CODEPAGE   NAME=%-9s START=0x%04x   END=0x%04x  \r\n",
	   szName,nStart,nEnd);
}

// Function to output at DATABANK line
int dataLine( char *szName, int nStart, int nEnd, int nProtected )
{

  if ( nProtected )
    printf("DATABANK   NAME=%-9s START=0x%04x   END=0x%04x   PROTECTED\r\n",
	   szName,nStart,nEnd);
  else
    printf("DATABANK   NAME=%-9s START=0x%04x   END=0x%04x   \r\n",
	   szName,nStart,nEnd);
}

int main()
{
  //! Current time used to initialize random number generator
  time_t t;
  //! Remember whether we found a segment
  int nProcessed;
  //! Which code section
  int nSegment;
  //  Which data section
  int nBank;
  // Bank to use for this segment
  int nThisBank;

  // Initialize random number generator
  t = 0;
  srand( 0x7fff & time(&t) );

  // File header
  printf("// Linker command file for Lesson 21 (16F648A)\r\n");
  printf("//$Id: makeLKR.c,v 1.2 2008-02-28 08:35:06-05 jjmcd Exp $\r\n\r\nLIBPATH    .\r\n\r\n");

  // A couple of fixed lines
  codeLine("vectors",0,3,1);
  codeLine("isr",4,0x3f,1);

  // Place tables low or high
  if ( rand() & 0x01 )
    {
      codeLine("tables",pages[0],0xff,1);
      pages[0] = 0x100;
    }
  else
    {
      codeLine("tables",pages[1],pages[1]+0xff,1);
      pages[1] += 0x100;
    }

  // Place lcdlib low or high
  if ( rand() & 0x01 )
    {
      codeLine("lcdlib",pages[0],pages[0]+0xff,1);
      pages[0] += 0x100;
    }
  else
    {
      codeLine("lcdlib",pages[1],pages[1]+0xff,1);
      pages[1] += 0x100;
    }

  // More fixed lines
  codeLine("page0",pages[0],pagee[0],0);
  codeLine("page1",pages[1],pagee[1],0);
  codeLine(".idlocs",0x2000,0x2006,1);
  codeLine(".devid",0x2006,0x2006,1);
  codeLine(".config",0x2007,0x2007,1);
  codeLine(".oscval",0x2008,0x2008,1);
  codeLine(".test",0x2009,0x200f,1);
  codeLine("eedata",0x2100,0x21ff,1);
  printf("\r\n");
  dataLine("sfr0",0x0,0x1f,1);
  dataLine("sfr1",0x80,0x9f,1);
  dataLine("sfr2",0x100,0x11f,1);
  dataLine("sfr3",0x180,0x19f,1);
  printf("\r\n");

  // Process each of the data sections
  for ( nSegment=0; nSegment<5; nSegment++ )
    {
      // Note that there are 3 possible locations for these segments.
      // We will take the low two bits of the random number, and if
      // the  result happens to be 3, we will simply try again
      nProcessed = 0;
      while ( !nProcessed )
	{
	  nThisBank = rand() & 0x03;
	  switch ( nThisBank )
	    {
	    case 0:
	    case 1:
	    case 2:
	      dataLine(szNames1[nSegment],banks[nThisBank],
		       banks[nThisBank]+sizes[nSegment]-1,1);
	      banks[nThisBank] += sizes[nSegment];
	      nProcessed = 1;
	      break;
	    case 3:
	      break;
	    }
	}
    }

  // Output the default sections for each bank
  printf("\r\n");
  for ( nBank=0; nBank<3; nBank++ )
    dataLine(szDefName[nBank],banks[nBank],banke[nBank],0);

  // More fixed lines
  printf("\r\n");
  printf("SHAREBANK  NAME=gprnobnk  START=0x70     END=0x7F\r\n");
  printf("SHAREBANK  NAME=gprnobnk  START=0xF0     END=0xFF\r\n");
  printf("SHAREBANK  NAME=gprnobnk  START=0x170    END=0x17F\r\n");
  printf("SHAREBANK  NAME=gprnobnk  START=0x1F0    END=0x1FF\r\n");

  printf("\r\n");

  printf("SECTION    NAME=STARTUP   ROM=vectors    // Reset vector\r\n");

  // Flip default code segment randomly
  if ( rand() & 0x1 )
    {
      printf("SECTION    NAME=PROG1     ROM=page0      // ROM code space\r\n");
      printf("SECTION    NAME=PROG2     ROM=page1      // ROM code space\r\n");
    }
  else
    {
      printf("SECTION    NAME=PROG1     ROM=page1      // ROM code space\r\n");
      printf("SECTION    NAME=PROG2     ROM=page0      // ROM code space\r\n");
    }

  // Still more fixed text
  printf("SECTION    NAME=IRQSVC    ROM=isr        // Interrupt service routine\r\n");
  printf("SECTION    NAME=TABLES    ROM=tables     // Message tables\r\n");
  printf("SECTION    NAME=LCDLIB    ROM=lcdlib     // LCD library\r\n");
  printf("SECTION    NAME=IDLOCS    ROM=.idlocs    // ID locations\r\n");
  printf("SECTION    NAME=DEVID     ROM=.devid     // device id\r\n");
  printf("SECTION    NAME=CONFIG    ROM=.config    // Configuration bits location\r\n");
  printf("SECTION    NAME=OSCVAL    ROM=.oscval    // Oscillator value\r\n");
  printf("SECTION    NAME=TEST      ROM=.test      // Test program memory\r\n");
  printf("SECTION    NAME=DEEPROM   ROM=eedata     // Data EEPROM\r\n");
  // Application data forced into low bank
  printf("SECTION    NAME=.udata    RAM=gpr0       // Application data\r\n");

  // SECTION statements for data sections
  for ( nSegment=0; nSegment<5; nSegment++ )
    printf("SECTION    NAME=%-9s RAM=%-9s  // Library data section\r\n",
	   szNames2[nSegment],szNames1[nSegment]);
  return 0;
}
