%union 
{
    double valdouble;
    char * str;
}

%token<str> ASSIGNMENT
%type<valdouble> value
%token<valdouble> VALUE_DOUBLE
%token<str> VARIABLE
%token<str> OP_PLUS
%token DELIMITER

%{
  #include <stdio.h>
  #include <string.h>
  //#include <iostream>
  //using namespace std;
  extern FILE * yyin;
  extern int yylex();
  extern int yyparse();
  void yyerror(char *);
%}

%%

     root : expr { printf( "eval expression." ); }
          | value { printf("eval value."); }
          | { printf("nothing found\n"); }
          ;

     expr   : VARIABLE ASSIGNMENT value { printf("variable(%s) assigned value(%f).\n", $1, $3 ); }
            ;

     value  : VALUE_DOUBLE OP_PLUS VALUE_DOUBLE { printf("value(%f).\n", $1 + $3 ); $$ = $1 + $3; }
            | VALUE_DOUBLE { printf("value(%f).\n", $1 ); $$ = $1; }
            ;
%%

void yyerror(char * s){
  fprintf(stderr, "%s\n", s);
}
