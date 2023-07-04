//
// Created by c41 on 28/06/23.
//

#ifndef GEORGE_H
#define GEORGE_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_IDENTIFIER_LENGTH 256

extern int yyparse();
extern void yyerror();
extern char* yytext;
extern int yylineno;
extern int yy_flex_debug;
extern FILE *yyin;

enum TOKEN_TYPE
{
    KEYWORD,
    DATATYPE,
    CONSTANT,
    CHARACTER,
    STR,
    ID,
    SYM
};

typedef struct token
{
    int type;
    char value[MAX_IDENTIFIER_LENGTH];
    unsigned int line;
} token;

typedef struct ast_node
{
    struct token *node;
    struct ast_node *left;
    struct ast_node *right;
} AST;

static struct ast_node *tree_root;

struct token *newToken(int type);
int george(int numFlags, char *flags[], int numSourceFiles, char *sourceFiles[]);

#endif // GEORGE_H
