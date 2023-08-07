//
// Created by root on 8/7/23.
//

#ifndef GEORGE_SYMBOL_TABLE_H
#define GEORGE_SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>

#define MAX_SYM_IDENTIFIER_LENGTH 256
#define RECORD_ALLOC_BLOCK_SIZE 4

struct symbol_table;

struct record
{
    char name[MAX_SYM_IDENTIFIER_LENGTH];
    char type[MAX_SYM_IDENTIFIER_LENGTH];
    struct symbol_table *table;
};

struct symbol_table
{
    struct record *records;
    int num_records;
};

struct symbol_table *create_symbol_table();
void clean_symbol_table(struct symbol_table *table);
int add_symbol(struct symbol_table *table, struct record *newRecord);
int lookup(struct symbol_table *table, char* symbol);

#endif //GEORGE_SYMBOL_TABLE_H
