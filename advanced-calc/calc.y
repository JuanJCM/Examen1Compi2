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
  Expr * expr_t;
  Statement *statement_t;
}

%token EOL
%token ADD SUB MUL DIV IF THEN ENDIF WHILE DO DONE ELSE LET
%token<float_t> NUMBER
%token<string_t> TK_ID

%type<expr_t> assignment_expression expression factor rational_expression
%type<statement_t> statement block_statement while_statement method_declaration
%
%%
start: start external_declaration
    |external_declaration
     ;

external_declaration: method_declaration 
    | global_declaration {$$ = new GlobalDeclaration($1);}
    ;

method_declaration: LET TK_ID '(' list_params ')' '=' block_statement{$$ = new MethodDeclaration(*$6, yylineno); delete $6; printf("Metodo %s agregado", $2);} 
    ;

list_params : params',' list_params{$$ = $3; $$->pushback($1);}
    |params {$$=$1;}
    ;

params: term {$$ = $1;}
    | /*nada*/
    ;

global_declaration: statement{$$ = $1;}
    | expression {$$ = $1;}
    |variable_declaration {$$ = $1;}
    |callfunction {$$ = $1;}
    ;
callfunction: TK_ID'('list_params')' {$$= new CallFunction(yylineno);}
    | TK_ID'(' ')'
    ;
statement: while_statement {$$= $1;}
    | assignment_expression{$$ = $1;}
    ;

variable_declaration: LET TK_ID '=' expression{$$ = new VariableDeclaration(yylineno); printf("Variable %s declarada ", $2);}
    ;

while_statement: WHILE '(' expression')' DO block_statement DONE{$$ = new WhileStatement($3); $$ = $5;}
    ;

block_statement: statement';' block_statement{
    $$ = $2; 
    $$->pushback($1);
    $$ = new BlockStatement($3,$2,yylineno);
}
    |/*nada*/
    ;

assignment_expression:  TK_ID '=' expression {$$ = new AssignExpr($3, yylineno);}
    ;

expression_list: expression_list expression {$$ = $1; $$->pushback($2);} 
    ;
expression: expression ADD factor {$$ = new AddExpr($1, $3, yylineno);}
    | expression SUB factor {$$ = new SubExpr($1, $3, yylineno);}
    | factor {$$ = $1;}
    ;

factor: factor MUL rational_expression{$$ = new MultExpr($1, $3, yylineno);}
    | factor DIV rational_expression {$$ = new DivExpr($1, $3, yylineno);}
    |rational_expression {$$= $1;}
    ;

rational_expression: rational_expression '>' term {$$ = new GtrExpr($1, $3, yylineno);}
    | rational_expression '<' term {$$ = new LssExpr($1, $3, yylineno);}
    | term {$$ = $1}
    ;

term: NUMBER {$$ = new FloatExpr($1, yylineno);}
    | TK_ID  {$$ = new IdExpr($1, yylineno);}
    ;

%%
