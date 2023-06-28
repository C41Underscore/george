//
// Created by c41 on 28/06/23.
//

#ifndef FLEX_BISON_TEST_GEORGE_H
#define FLEX_BISON_TEST_GEORGE_H

#define MAX_IDENTIFIER_LENGTH 256

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

#endif //FLEX_BISON_TEST_GEORGE_H
