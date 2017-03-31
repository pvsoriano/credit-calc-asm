/* Source Name: main.c
 * Compiled Name: main.o
 * Code Model: Flat mode protected model
 * Version: 1.0
 * Created Date: 12 MAR 2006
 * Last Updated: 22 APR 2006
 * Author: Paul V. Soriano
 * Description: The program is the driver for the assembly functions.
 *	Credit Calculator calculates how long it would take for you to 
 *	pay off your credit card.
 */

#include <stdio.h>
#include <stdlib.h>
#include <curses.h>

#define NL puts("\n");

void creditcalc(void);

int main()
{
    creditcalc();
	    
    return 0;
}
	    
	    
