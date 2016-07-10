#include <stdio.h>
#include <string.h>
#include <iostream>
#include "psil_structures.hpp"
#include "psil_namespace.hpp"

using namespace std;
extern FILE * yyin;
extern int yylex();
extern int yyparse();

psil_ast * root_ast = nullptr;

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
	root_ast = nullptr;
	cout << ">";
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	//call parser
	yyparse();

	if( nullptr != root_ast ){
	    root_ast->eval();
	    if( root_ast->_ret_type == psil_type::NUMBER ){
		cout << "eval(root) = " << root_ast->_ret_val.number << endl;
	    }
	}
    }

    return 0;
}
