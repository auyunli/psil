#ifndef PSIL_NAMESPACE_H
#define PSIL_NAMESPACE_H

#include <functional>
#include <cstring>

struct CStrCompare : public std::binary_function<const char*, const char*, bool> {
public:
    bool operator() (const char* str1, const char* str2) const;
};

#endif
