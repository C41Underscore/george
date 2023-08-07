//
// Created by root on 8/7/23.
//

#include "symbol_table.h"

struct symbol_table *create_symbol_table()
{
    struct symbol_table *newTable = (struct symbol_table*)malloc(sizeof(struct symbol_table));
    newTable->records = (struct record*)malloc(RECORD_ALLOC_BLOCK_SIZE*sizeof(struct record));
    newTable->num_records = 0;
    return newTable;
}

void clean_symbol_table(struct symbol_table *table)
{
    free(table->records);
    free(table);
}

int add_symbol(struct symbol_table *table, struct record *newRecord)
{
    if(table->num_records % RECORD_ALLOC_BLOCK_SIZE == RECORD_ALLOC_BLOCK_SIZE - 1)
    {
        table->records = realloc(table->records, sizeof(struct record)*(table->num_records + RECORD_ALLOC_BLOCK_SIZE));
    }
    table->records[table->num_records++] = *newRecord;
    return 0;
}

int lookup(struct symbol_table *table, char* symbol)
{

}
