%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "yac_psil.tab.h"
  #include <string.h>
  #include <iostream>
%}

%%

"val"             {   return KEYWORD_VAL; }
"true"            {   return KEYWORD_TRUE; }
"false"           {   return KEYWORD_FALSE; }
"fun"             {   return KEYWORD_FUNCTION; }
"{"               {   return BRACE_LEFT; }
"}"               {   return BRACE_RIGHT; }
"("               {   return PAREN_LEFT; }
")"               {   return PAREN_RIGHT; }
"["               {   return BRACKET_LEFT; }
"]"               {   return BRACKET_RIGHT; }
"<"               {   return ANGLE_LEFT; }
">"               {   return ANGLE_RIGHT; }
"+"               {   return OP_PLUS; }
"->"              {   return ARROW_RIGHT; }
"<-"              {   return ARROW_LEFT; }
","               {   return COMMA; }
[+-]?([0-9]*\.?[0-9]+|[0-9]+\.)  {
                      yylval.valdouble = atof(yytext);
                      return VALUE_DOUBLE;
                  }
[_a-zA-Z]+[0-9]*  {
                      yylval.str = strdup(yytext);
                      return WORD;
                  }
[ \t\n]           { }
";"               { return DELIMITER; }
.                 { return EOF; };

%%

int yywrap(void) {
  return 1;
}
