%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "george_parse.tab.h"
#include "../src/george.h"

struct token *newToken(int type)
{
    struct token *new_tok = (struct token *)malloc(sizeof(struct token));
    new_tok->type = type;
    strncpy(new_tok->value, yytext, MAX_IDENTIFIER_LENGTH);
    new_tok->line = yylineno;
    return new_tok;
}
%}

%option yylineno

%%
[ \t\r\n]                        ;  /* skip whitespace which isn't part of a string */

function                         {yylval.tok = newToken(KEYWORD); return FUNCTION;}
return                           {yylval.tok = newToken(KEYWORD); return RETURN;}
do                               {yylval.tok = newToken(KEYWORD); return DO;}
while                            {yylval.tok = newToken(KEYWORD); return WHILE;}
for                              {yylval.tok = newToken(KEYWORD); return FOR;}
import                           {yylval.tok = newToken(KEYWORD); return IMPORT;}
from                             {yylval.tok = newToken(KEYWORD); return FROM;}
true                             {yylval.tok = newToken(KEYWORD); return TRUE;}
false                            {yylval.tok = newToken(KEYWORD); return FALSE;}
null                             {yylval.tok = newToken(KEYWORD); return NULL_CHAR;}

int|float|char|void              {yylval.tok = newToken(DATATYPE); return TYPE;}
[0-9]+                           {yylval.tok = newToken(CONSTANT); return INTEGER;}
[0-9]+\.[0-9]*|[0-9]*\.[0-9]+    {yylval.tok = newToken(CONSTANT); return FLOAT;}
\'[a-zA-Z]\'                     {yylval.tok = newToken(CHARACTER); return CHAR;}
\"(.*?)\"                        {yylval.tok = newToken(STR); return STRING;}

[_a-zA-Z]+[_a-zA-Z0-9]*          {yylval.tok = newToken(ID); return IDENTIFIER;}

;                                {yylval.tok = newToken(SYM); return SEMICOLON;}
\(                               {yylval.tok = newToken(SYM); return LEFT_BRACKET;}
\)                               {yylval.tok = newToken(SYM); return RIGHT_BRACKET;}
\[                               {yylval.tok = newToken(SYM); return LEFT_SQUARE_BRACKET;}
\]                               {yylval.tok = newToken(SYM); return RIGHT_SQUARE_BRACKET;}
\{                               {yylval.tok = newToken(SYM); return LEFT_SCOPE_BRACKET;}
\}                               {yylval.tok = newToken(SYM); return RIGHT_SCOPE_BRACKET;}
:                                {yylval.tok = newToken(SYM); return COLON;}
,                                {yylval.tok = newToken(SYM); return COMMA;}

=                                {yylval.tok = newToken(SYM); return EQUAL;}
\+                               {yylval.tok = newToken(SYM); return PLUS;}
\-                               {yylval.tok = newToken(SYM); return MINUS;}
\/                               {yylval.tok = newToken(SYM); return DIVIDE;}
\*                               {yylval.tok = newToken(SYM); return MULTIPLY;}

\-=                              {yylval.tok = newToken(SYM); return MINUS_INLINE;}
\+=                              {yylval.tok = newToken(SYM); return PLUS_INLINE;}
\/=                              {yylval.tok = newToken(SYM); return DIVIDE_INLINE;}
\*=                              {yylval.tok = newToken(SYM); return MULTIPLY_INLINE;}

==                               {yylval.tok = newToken(SYM); return EQ;}
\<                               {yylval.tok = newToken(SYM); return LT;}
\<=                              {yylval.tok = newToken(SYM); return LTQ;}
\>                               {yylval.tok = newToken(SYM); return GT;}
=\>                              {yylval.tok = newToken(SYM); return GTQ;}

and                              {yylval.tok = newToken(KEYWORD); return AND;}
or                               {yylval.tok = newToken(KEYWORD); return OR;}
not                              {yylval.tok = newToken(KEYWORD); return NOT;}
%%