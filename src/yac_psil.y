%union 
{
    double valdouble;
    char * str;
}

%token ASSIGNMENT
%token<valdouble> VALUE_DOUBLE
%token<str> VARIABLE
%token<str> OP_PLUS
%token DELIMITER

%right ASSIGNMENT
%left OP_PLUS
VALE_DOUBLE

%type<valdouble> expr
%{
  #include <stdio.h>
  #include <string.h>
  //#include <iostream>
  //using namespace std;
  extern FILE * yyin;
  extern int yylex();
  extern int yyparse();
  void yyerror(char *);
  extern int yywrap();
%}

%%

     root : expr DELIMITER { printf( "eval expression.\n" ); YYACCEPT; }
          | { printf("nothing found.\n"); YYACCEPT; }
          ;

     expr   : VARIABLE ASSIGNMENT expr { printf("variable(%s) assigned value(%f).\n", $1, $3 ); $$ = $3; }
            | expr OP_PLUS expr { printf("value(%f).\n", $1 + $3 ); $$ = $1 + $3; }
            | VALUE_DOUBLE { printf("value(%f).\n", $1); $$ = $1; }
            ;
%%

void yyerror(char * s){
  fprintf(stderr, "%s\n", s);
}
