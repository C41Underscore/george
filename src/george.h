//
// Created by c41 on 28/06/23.
//

#ifndef GEORGE_H
#define GEORGE_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include "symbol_table.h"

#define MAX_IDENTIFIER_LENGTH 256

extern int yyparse();
extern void yyerror(const char *str);
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
    struct ast_node *children;
} AST;

static struct ast_node *tree_root;
int set_tree_root(struct ast_node *root);

struct token *newToken(int type);
int george(int numFlags, char *flags[], int numSourceFiles, char *sourceFiles[]);

struct ast_node* create_node(struct token *tok);
//  Create Basic Token
struct token* cbt(char* tag);
int add_node(struct ast_node *node, int numChildren, ...);

//  SEMANTIC ANALYSIS

int george_semantic_analysis(struct ast_node *root);

#endif // GEORGE_H
