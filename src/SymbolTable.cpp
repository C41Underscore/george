#include "SymbolTable.hpp"

SymbolTable::SymbolTable()
{
    this->table = new std::map<std::string, Record>;
};

SymbolTable::~SymbolTable()
{
    delete this->table;
};

int SymbolTable::AddSymbol(std::string &id, int type, std::string &value)
{
    auto *newRecord = new Record(id, type, value, new SymbolTable());
    return 0;
};

void SymbolTable::LookUp(std::string &id)
{};