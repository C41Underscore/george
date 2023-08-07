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
    new_node->left = NULL;
    new_node->right = NULL;
    return new_node;
}

int add_node(struct ast_node *node, struct ast_node *left_node, struct ast_node *right_node)
{
    node->left = left_node;
    node->right = right_node;
    return 0;
}

int george(int numFlags, char *flags[], int numSourceFiles, char *sourceFiles[])
{
    yy_flex_debug = 0;

    if(numSourceFiles == 0)
    {
        yyerror("no source files");
        exit(1);
    }

    FILE *source; int i;
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
    struct symbol_table *tab = create_symbol_table();
    clean_symbol_table(tab);

    return return_code;
}
