#include <iostream>

class SymbolTable
{
public:
    SymbolTable();
    ~SymbolTable();
    int AddSymbol();
    void LookUp();
};