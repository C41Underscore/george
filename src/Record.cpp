//
// Created by root on 7/25/23.
//

#include "Record.hpp"

Record::Record(std::string &id, int type, std::string &value, SymbolTable *table):
id(id), type(type), value(value), table(table){}
