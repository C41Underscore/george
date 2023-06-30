//
// Created by c41 on 30/06/23.
//

#ifdef __cplusplus
extern "C" {
#endif
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    #include "george.h"

    struct token *newToken(int type)
    {
        struct token *new_tok = (struct token *)malloc(sizeof(struct token));
        new_tok->type = type;
        strncpy(new_tok->value, yytext, MAX_IDENTIFIER_LENGTH);
        new_tok->line = yylineno;
        return new_tok;
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

        tree_root = (struct ast_node*)malloc(sizeof(struct ast_node));

        yyin = source;
        int return_code = 0;
        do
        {
            return_code = yyparse();
        } while(!feof(yyin));

        fclose(source);
    }
#ifdef __cplusplus
}
#endif