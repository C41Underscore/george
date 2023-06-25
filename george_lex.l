%{
#include <stdio.h>
#include <string.h>
#include "george_parse.tab.h"
%}

%option yylineno

%%
function                         {return FUNCTION; printf("function\n");}
return                           {return RETURN; printf("return\n");}
do                               {return DO; printf("do\n");}
while                            {return WHILE; printf("while\n");}
for                              {return FOR; printf("for\n");}
import                           {return IMPORT; printf("import\n");}
from                             {return FROM;}
true                             {return TRUE;}
false                            {return FALSE;}
null                             {return NULL_CHAR;}

int|float|char|void              {return TYPE;}
[0-9]+                           {return INTEGER;}
[0-9]+\.[0-9]*|[0-9]*\.[0-9]+      {return FLOAT;}
\'[a-zA-Z]\'                     {return CHAR;}
\"(.*?)\"                        {return STRING;}

[_a-zA-Z]+[_a-zA-Z0-9]*          {return IDENTIFIER;}

;                                {return SEMICOLON;}
\(                               {return LEFT_BRACKET;}
\)                               {return RIGHT_BRACKET;}
\[                               {return LEFT_SQUARE_BRACKET;}
\]                               {return RIGHT_SQUARE_BRACKET;}
\{                               {return LEFT_SCOPE_BRACKET;}
\}                               {return RIGHT_SCOPE_BRACKET;}
:                                {return COLON;}
,                                {return COMMA;}

=                                {return EQUAL;}
\+                               {return PLUS;}
\-                               {return MINUS;}
\/                               {return DIVIDE;}
\*                               {return MULTIPLY;}

\-=                              {return MINUS_INLINE;}
\+=                              {return PLUS_INLINE;}
\/=                              {return DIVIDE_INLINE;}
\*=                              {return MULTIPLY_INLINE;}

==                               {return EQ;}
\<                               {return LT;}
\<=                              {return LTQ;}
\>                               {return GT;}
=\>                              {return GTQ;}

and                              {return AND;}
or                               {return OR;}
not                              {return NOT;}
%%