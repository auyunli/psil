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
    int token;
}

%token<valdouble> VALUE_DOUBLE
%token KEYWORD_VAL
%token<str> WORD
%token<str> OP_PLUS
%token DELIMITER
%token BRACE_LEFT
%token BRACE_RIGHT
%token PAREN_LEFT
%token BRACKET_LEFT
%token BRACKET_RIGHT
%token PAREN_RIGHT
%token ANGLE_LEFT
%token ANGLE_RIGHT
%token ARROW_LEFT
%token ARROW_RIGHT
%token COMMA
%token KEYWORD_TRUE
%token KEYWORD_FALSE
%token KEYWORD_FUNCTION

%right ARROW_LEFT
%left OP_PLUS
VALUE_DOUBLE
KEYWORD_VAL
WORD

%type<ast> expr
%type<ast> root
%type<ast> list
%type<ast> data
%type<ast> datum
/* %type<ast> prototype */
/* %type<ast> parengroup */
/* %type<ast> definition */

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
     expr   : KEYWORD_VAL datum ARROW_LEFT list {
          	psil_ast_identifier * identifier = new psil_ast_identifier( ( psil_ast_datum * ) $2 );		 
		psil_ast_bind * bind = new psil_ast_bind( identifier, ( psil_ast * ) $4 );
		$$ = bind;
              }
            | list {
		$$ = $1;
              }
            | KEYWORD_VAL datum ARROW_LEFT PAREN_LEFT datum PAREN_RIGHT ARROW_RIGHT expr {
		psil_ast_identifier * identifier = new psil_ast_identifier( ( psil_ast_datum * ) $2 );
		psil_ast_fun * func = new psil_ast_fun( ( psil_ast * )$5, ( psil_ast * )$8, nullptr );
		psil_ast_bind * bind = new psil_ast_bind( identifier, func );
		$$ = bind;
              }
            ;
     list   : BRACKET_LEFT datum BRACKET_RIGHT {
 	         psil_ast_list * psil_list = new psil_ast_list( ( psil_ast_datum * ) $2 );
		 $$ = psil_list;
              }
            ;
     datum  : data {
    	         psil_ast_datum * datum = new psil_ast_datum( ( psil_ast_data * )$1 );
		 $$ = datum;
              }
            | datum COMMA data {
  		 psil_ast_datum * datum = ( psil_ast_datum * )$1;
		 datum->append( ( psil_ast_data * ) $3 );
		 $$ = datum;
              }
	    ;
     data   : WORD {
   	         psil_ast_word * word = new psil_ast_word( $1 );
	         $$ = word;
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
