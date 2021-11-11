%code requires{
    #include "ast.h"
}

%{

    #include <cstdio>
    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
%}

%union{
  float float_t;
  const char* string_t;
}

%token EOL
%token ADD SUB MUL DIV IF THEN ENDIF WHILE DO DONE ELSE LET
%token<float_t> TK_ID, NUMBER
%%
start: start external_declaration
    |external_declaration
     ;

external_declaration: method_declaration
    | global_declaration
    ;

method_declaration: LET TK_ID '(' list_params ')' '=' block_statement 
    ;

list_params : params',' list_params
    |params
    ;

params: TK_ID
    ;

global_declaration: statement
    | expression
    |variable_declaration
    |callfunction
    ;
callfunction: 
    ;
statement: while_statement
    | assignment_expression
    ;

variable_declaration: LET TK_ID '=' expression
    ;

while_statement: WHILE '(' expression')' DO block_statement DONE
    ;

block_statement: expression_list';' block_statement
    |statement';' block_statement
    |/*nada*/
    ;

assignment_expression:  TK_ID '=' expression
    ;

expression_list: expression_list expression EOL {printf("= %d\n", $2)} 
    | /*nada*/
    ;
expression: expression ADD factor {$$ = $1 + $3;}
    | expression SUB factor {$$ = $1 - $3;}
    | factor {$$ = $1}
    ;

factor: factor MUL relational {$$= $1 * $3;}
    | factor DIV relational {$$ = $1 / $3;}
    | relational{$$ = $1}
    ;

relational: relational '>' term {$$ = $1 > $3}
    | relational '<' term {$$ = $1 < $3}
    | term {$$ = $1}
    ;

term: NUMBER {$$ = $1;}
    | TK_ID  {$$ = $1;}
    ;

%%
