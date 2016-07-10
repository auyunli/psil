%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "testyac.tab.h"
  #include <string.h>
  //#include <iostream>
  //using namespace std;
%}

%%

"+"               {
                      return OP_PLUS;
                  }
"<-"              {
                      return ASSIGNMENT;
                  }

[a-z]+[0-9]*      {
                      yylval.str = strdup(yytext);
                      return VARIABLE;
                  }
[+-]?([0-9]*\.?[0-9]+|[0-9]+\.)  {
                      yylval.valdouble = atof(yytext);
                      return VALUE_DOUBLE;
                  }
[ \t\n]           { }
";;"              { return EOF; }
.                 return EOF;

%%

int yywrap(void) {
  return 1;
}
