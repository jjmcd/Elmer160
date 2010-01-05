/* patterns.c

   Create a statement that initializes an array of LED
   patterns.  Ensure that at no time are all 3 LEDs off,
   and 2/3ds of the time at least 2 LEDs are on.

   Statements are printed for sdcc and asm.

   jjmcd - 2009-11-27
*/

#include <stdio.h>
#include <stdlib.h>

int Pattern[1024];  // We won't make it that big

int main()
{
  int i,n,x;

  // Number of entries in the pattern array
  n = 32;

  // Seed the number generator
  srand((unsigned int)time(0));

  // Loop until we have enough values
  i = 0;
  while ( i < n )
    {
      // Get random value that doesn't have all LEDs off
      x = 0x0e;
      while ( x == 0x0e )
	x = rand() & 0x0e;
      // 2/3ds of the time
      if ( rand() > ((RAND_MAX/3)*2) )
	{
	  // it must have at least 2 LEDs on
	  if ( x==2 || x==4 || x==8 || x== 0 )
	    {
	      Pattern[i] = x;
	      i++;
	    }
	}
      // 1/3rd of the time it is OK to have only one
      else
	{
	  Pattern[i] = x;
	  i++;
	}
    }

  // Print out the C statement
  printf("static const unsigned char Patterns[%d] = {\n   ",n);
  for ( i=0; i<n; i++ )
    {
      if ( i>0 )
	{
	  printf(",");
	  if ( (i%8)==0 )
	    printf("\n   ");
	}
      printf(" 0x%02x",Pattern[i]);
    }
  printf("\n    };\n");

  printf("\n\n");

  // Print out the ASM table
  printf("TABSAV\tudata_ovr\n");
  printf("SavIdx\tres\t1\t\t; Temp storage for tableindex\n");
  printf("TABLE\tcode\n");
  printf("Pattern\n");
  printf("\tmovwf\tSavIdx\t\t; Save off index\n");
  printf("\tmovlw\tHIGH(Pattern)\t; Get table's high byte\n");
  printf("\tmovwf\tPCLATH\t\t; and put it to PC high latch\n");
  printf("\tmovf\tSavIdx,W\t; Pick up saved index\n");
  printf("\taddwf\tPCL,F\t\t; and index into table\n");
  for ( i=0; i<n; i++ )
    {
      if ( (i%8)==0 )
	printf("\tdt\t");
      printf("H'%02x'",Pattern[i]);
      if ( (i%8)!=7 )
	printf(", ");
      else
	printf("\n");
    }
  printf("\n\n");
  return 0;
}
