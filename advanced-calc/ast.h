#ifndef _AST_H_
#define _AST_H_

#include <list>
#include <string>
#include <map>
using namespace std;

typedef list<Statement *> StatementList;
enum StatementKind{
    WHILE_STATEMENT,
    EXPRESSION_STATEMENT,
    BLOCK_STATEMENT, 
    GLOBAL_DECLARATION_STATEMENT,
    FUNCTION_DEFINITION_STATEMENT
};

class Statement{
    public:
        int line;
        virtual StatementKind getKind() = 0;
};

class Expr{
    public:
        int line;
};

class Parameter {
    public:
    Parameter(int line){
        this->line = line;
    }
    int line;
    //aqui deberia de ir la validacion de tipo 
};
class VariableDeclaration{
    public:
        VariableDeclaration(int line ){
            this->line = line;
        }
        int line;
};
class GlobalDeclaration: public Statement{
    public:
        GlobalDeclaration(VariableDeclaration vdeclaration){
            this->vdeclaration = vdeclaration;
        }
        VariableDeclaration * vdeclaration;
        StatementKind getKind(){
            return GLOBAL_DECLARATION_STATEMENT;
        }
};
class CallFunction : public Statement{
    public:
        CallFunction(int line){
            this-> line = line;
        } 
        int line;
};
class MethodDeclaration : public Statement{
    public:
        MethodDeclaration(Statement *statement, int line){
            this->statement = statement;
            this->line = line;
        }
        int line;
        Statement *statement;
};

class BlockStatement : public Statement{
    BlockStatement(StatementList statements, int line){
        this->line= line;
        this->statements = statements;
    }   
    StatementList statements;
    int line;
    StatementKind getKind(){
        return BLOCK_STATEMENT;
    }
};

class whileStatement: public Statement{
    public:
    WhileStatement(Expr *expr){
        this->expr = expr;
    }
    Expr *expr;
};

class BinaryExpr : public Expr{
    public:
        BinaryExpr(Expr *expr1, Expr *expr2, int line){
            this->expr1 = expr1;
            this->expr2 = expr2;
            this->line = line;
        }
        Expr *expr1;
        Expr *expr2;
        int line;
};
#define IMPLEMENT_BINARY_EXPR(name) \
class name##Expr : public BinaryExpr{\
    public: \
        name##Expr(Expr * expr1, Expr *expr2, int line) : BinaryExpr(expr1, expr2, line){}\
        
};

class IdExpr : public Expr{
    public:
        IdExpr(string id, int line){
            this->id = id;
            this->line = line;
        }
        string id ;
        int line;
};

class FloatExpr : public Expr{
    public:
        FloatExpr(float value, int line){
            this->value = value;
            this->line = line;
        }
        float value;
};
IMPLEMENT_BINARY_EXPR(Add);
IMPLEMENT_BINARY_EXPR(Sub);
IMPLEMENT_BINARY_EXPR(Mul);
IMPLEMENT_BINARY_EXPR(Div);
IMPLEMENT_BINARY_EXPR(Assign);
IMPLEMENT_BINARY_EXPR(Gtr);
IMPLEMENT_BINARY_EXPR(Lss);


#endif