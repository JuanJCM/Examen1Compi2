%option noyywrap
%option yylineno

%{
    #include "tokens.h"
    #include "stdio.h"
%}

%%
"+" { return ADD; }
"=" { return '='; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"(" { return '('; }
")" { return ')'; }
"," { return ','; }
";" { return ';'; }
">" { return '>'; }
"<" { return '<'; }
"let" { return LET; }
"while" { return WHILE; }
"do" { return DO; }
"done" { return DONE; }
[0-9]+ {yylval.float_t = atof(yytext); return NUMBER;}
[0-9]+"."[0-9]+ {yylval.float_t = atof(yytext); return NUMBER; } //pending
[a-zA-Z]([0-9]|[a-zA-Z])* {yylval.string_t = strdup(yytext);return TK_ID; }
[\n] { return EOL; }
[ \t] { /* ignorar */ }
. { printf("invalido %c\n", yytext[0]); }

%%