//
// Created by root on 7/25/23.
//

#ifndef RECORD_H
#define RECORD_H

class Record
{
public:
    Record(string &id, int type, string &value);
    ~Record();
private:
    string id;
    int type;
    string value;
    SymbolTable *table;
};

#endif //RECORD_H
