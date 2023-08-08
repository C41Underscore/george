//
// Created by c41 on 30/06/23.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "george.h"

int set_tree_root(struct ast_node *root)
{
    tree_root = root;
    return 0;
}

struct token *newToken(int type)
{
    struct token *new_tok = (struct token *)malloc(sizeof(struct token));
    new_tok->type = type;
    strncpy(new_tok->value, yytext, MAX_IDENTIFIER_LENGTH);
    new_tok->line = yylineno;
    return new_tok;
}

struct ast_node *create_node(struct token *tok)
{
    struct ast_node *new_node = (struct ast_node*) malloc(sizeof (struct ast_node));
    new_node->node = tok;
    new_node->children = NULL;
    return new_node;
}

//  Create Basic Token
struct token* cbt(char* tag)
{
    struct token* newToken = (struct token*) malloc(sizeof(struct token));
    newToken->line = -1;
    strncpy(newToken->value, tag, MAX_IDENTIFIER_LENGTH);
    newToken->type = -1;
    return newToken;
}

int add_node(struct ast_node *node, int numChildren, ...)
{
    node->children = (struct ast_node*) malloc(numChildren*sizeof(struct ast_node));

    struct ast_node *newChild;
    va_list ap;
    va_start(ap, numChildren);
    for(int i = 0; i < numChildren; i++)
    {
        newChild = va_arg(ap, struct ast_node*);
        printf("%s\n", newChild->node->value);
    }
    va_end(ap);
    return 0;
}

//  Convert arguments into a single array of cmd inputs
int george(int numFlags, char *flags[], int numSourceFiles, char *sourceFiles[])
{
    yy_flex_debug = 0;

    if(numSourceFiles == 0)
    {
        yyerror("no source files");
        exit(1);
    }

    FILE *source;
    source = fopen(sourceFiles[1], "r");
    if(source == NULL)
    {
        yyerror("invalid source file");
        exit(1);
    }

    tree_root = create_node(NULL);

    yyin = source;
    int return_code = 0;
    do
    {
        return_code = yyparse();
    } while(!feof(yyin));

    fclose(source);

    george_semantic_analysis(tree_root);

    return return_code;
}

//  SEMANTIC ANALYSIS

int george_semantic_analysis(struct ast_node *root)
{
    return 0;
}
