%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "yac_psil.tab.h"
  #include <string.h>
  #include <iostream>
%}

%%

"{"               {   return BRACE_START; }
"}"               {   return BRACE_END; }
"("               {   return PAREN_START; }
")"               {   return PAREN_END; }
"<"               {   return ANGLE_START; }
">"               {   return ANGLE_END; }
"+"               {   return OP_PLUS; }
"->"              {   return ARROW; }
","               {   return COMMA; }
[+-]?([0-9]*\.?[0-9]+|[0-9]+\.)  {
                      yylval.valdouble = atof(yytext);
                      return VALUE_DOUBLE;
                  }
"="               {
                      return BIND;
                  }
[_a-zA-Z]+[0-9]*  {
                      yylval.str = strdup(yytext);
                      return WORD;
                  }
[ \t\n]           { }
";;"              { return DELIMITER; }
.                 { return EOF; };

%%

int yywrap(void) {
  return 1;
}
