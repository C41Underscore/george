//
// Created by root on 7/25/23.
//

#ifndef RECORD_H
#define RECORD_H

#include <string>

class SymbolTable;

class Record
{
public:
    Record(std::string &id, int type, std::string &value, SymbolTable *table);
private:
    std::string id;
    int type;
    std::string value;
    SymbolTable *table;
};

#endif //RECORD_H
