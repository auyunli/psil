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
%token<str> WORD
%token<str> OP_PLUS
%token DELIMITER
%token BRACE_START
%token BRACE_END
%token PAREN_START
%token PAREN_END
%token ANGLE_START
%token ANGLE_END
%token ARROW
%token COMMA

%right BIND
%left OP_PLUS
VALE_DOUBLE

%type<ast> expr
%type<ast> root
%type<ast> prototype
%type<ast> words
%type<ast> parengroup
%type<ast> definition

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

     expr   : WORD BIND expr {
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
            | prototype
	    | definition
            ;
     prototype : ANGLE_START words ANGLE_END {
          	     psil_ast_prototype * proto = new psil_ast_prototype( $2 );
		     $$ = proto;
                 }
     definition : parengroup BRACE_START expr BRACE_END{
 	             psil_ast_definition * def = new psil_ast_definition( $1, $3 );
		     $$ = def;
     }
     words : WORD {
                 psil_ast_words * words = new psil_ast_words;
		 words->append( $1 );
		 $$ = words;
             }
           | words WORD {
	         psil_ast_words * words = (psil_ast_words * )$1;
		 words->append( $2 );
		 $$ = words;
             }
     parengroup : PAREN_START words PAREN_END {
  	               psil_ast_parengroup * group = new psil_ast_parengroup( $2 );
		       $$ = group;
     }
%%

void yyerror(char * s){
  fprintf(stderr, "%s\n", s);
}
