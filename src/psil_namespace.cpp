#include <map>
#include <cstring>
#include <functional>

#include "psil_namespace.hpp"

bool CStrCompare::operator() (const char* str1, const char* str2) const {
    return std::strcmp(str1, str2) < 0;
}

class psil_ast;

std::map<char *, psil_ast *, CStrCompare > symbol_table;
