#include "SymbolTable.hpp"

SymbolTable::SymbolTable()
{
    this->table = new map<string, Record>;
};

SymbolTable::~SymbolTable()
{
    delete this->table;
};

int SymbolTable::AddSymbol(string &id, int type, string &value)
{
    Record newRecord = new Record(id, type, value);

};

void SymbolTable::LookUp(string &id)
{};