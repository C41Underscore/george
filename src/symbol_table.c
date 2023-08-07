//
// Created by root on 8/7/23.
//

#include "symbol_table.h"

struct symbol_table *symbol_table_init()
{
    george_symbol_table = (struct symbol_table*)malloc(sizeof(struct symbol_table));
    george_symbol_table->records = (struct record*)malloc(RECORD_ALLOC_BLOCK_SIZE*sizeof(struct record));
    george_symbol_table->num_records = 0;
    return george_symbol_table;
}

void clean_symbol_tables()
{
    free(george_symbol_table->records);
    free(george_symbol_table);
}