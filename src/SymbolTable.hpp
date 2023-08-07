//
// Created by root on 7/25/23.
//

#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <iostream>
#include <map>
#include <string>

#include "Record.hpp"

enum SymbolTypes
{
    FUNCTION,
    VARIABLE,
    ARGUMENT,
    SCOPE
};

class SymbolTable
{
public:
    SymbolTable();
    ~SymbolTable();
    int AddSymbol(std::string &id, int type, std::string &value);
    void LookUp(std::string &id);
private:
    std::map<std::string, Record> *table;
};

#endif //SYMBOL_TABLE_H
