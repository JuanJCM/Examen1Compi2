#include "ast.h"
#include <map>
#include <iostream>

class ContextStack{
    public:
        struct ContextStack* prev;
        map<string> variables;
};
class FunctionInfo{
    public:
        list<Parameter *> parameters;
};

map<string, float> globalVariables = {};
map<string,FunctionInfo> methods;

ContextStack *context = NULL;

void pushContext(){
    ContextStack *con = new ContextStack();
    con ->prev = context;
    context = con;
}

void popContext(){
    if(context != NULL){
        ContextStack * previous = context->prev;
        free(context);
        context = previous;
    }
}