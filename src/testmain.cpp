#include <stdio.h>
#include <string.h>
#include <iostream>
using namespace std;
extern FILE * yyin;
extern int yylex();
extern int yyparse();

int main(int argc, char** argv){
    // open a file handle to a particular file:
    // FILE *myfile = fopen(argv[1], "r");
    FILE * myfile = stdin;
    // make sure it is valid:
    if (!myfile) {
        cout << "Can't open input!" << endl;
        return -1;
    }
    while(1){
	cout << ">";
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	/* do { */
	yyparse();
	cout << endl;
    }
    /* } while (!feof(yyin)); */

    return 0;
}
