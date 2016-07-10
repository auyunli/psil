%{
  #include <cstdio>
  #include <cstring>
  #include <map>
  extern FILE * yyin;
  extern int yylex();
  extern int yyparse();
  void yyerror(char *);
  extern int yywrap();
  #include "psil_structures.hpp"
  extern std::map<char *, psil_ast *, CStrCompare > symbol_table;
  extern psil_ast * root_ast;
%}

%code requires {
    #ifndef __TYPES_HPP_INCLUDED__
    #define __TYPES_HPP_INCLUDED__
    #include "psil_structures.hpp"
    #include "psil_namespace.hpp"
    #endif
}

%union 
{
    double valdouble;
    char * str;
    psil_ast * ast;
}

%token BIND
%token<valdouble> VALUE_DOUBLE
%token<str> VARIABLE
%token<str> OP_PLUS
%token DELIMITER

%right BIND
%left OP_PLUS
VALE_DOUBLE

%type<ast> expr
%type<ast> root

%%

     root : expr DELIMITER {
	        printf( "evaluated.\n" );
		root_ast = $1;
		YYACCEPT;
            }
          | {
	        printf("nothing found.\n");
		root_ast = nullptr;
		YYACCEPT;
            }
          ;

     expr   : VARIABLE BIND expr {
		  psil_ast_identifier * identifier = new psil_ast_identifier( $1 );		 
		  psil_ast_bind * bind = new psil_ast_bind( identifier, $3 );
		  $$ = bind;
              }
            | expr OP_PLUS expr {
		  psil_ast_add * add = new psil_ast_add( $1, $3 );
		  $$ = add;
              }
            | VALUE_DOUBLE {
		  psil_ast_number * num = new psil_ast_number( $1 );
		  $$ = num;
	      }
            ;
%%

void yyerror(char * s){
  fprintf(stderr, "%s\n", s);
}
