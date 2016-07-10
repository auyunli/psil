%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "yac_psil.tab.h"
  #include <string.h>
  //#include <iostream>
  //using namespace std;
%}

%%

"+"               {
                      return OP_PLUS;
                  }
[+-]?([0-9]*\.?[0-9]+|[0-9]+\.)  {
                      yylval.valdouble = atof(yytext);
                      return VALUE_DOUBLE;
                  }
"<-"              {
                      return ASSIGNMENT;
                  }
[a-z]+[0-9]*      {
                      yylval.str = strdup(yytext);
                      return VARIABLE;
                  }
[ \t\n]           { }
";;"              { return DELIMITER; }
.                 { return EOF; };

%%

int yywrap(void) {
  return 1;
}
