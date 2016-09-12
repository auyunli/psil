#ifndef PSIL_STRUCTURES_H
#define PSIL_STRUCTURES_H

#include <map>
#include <cassert>
#include <iostream>
#include <vector>

#include "psil_namespace.hpp"

class psil_ast;

extern std::map<char *, psil_ast *, CStrCompare > symbol_table;

enum class psil_type {
    LIST,
    NUMBER,
    WORD,
    ATOM,
    IDENTIFIER,
    DATA,
    DATUM,
    NOT_APPLICABLE,
    DEFERRED,
};

union psil_value {
    double number;
    char * string;
    char * atom;
    char * identifier;
};

class psil_ast {
public:
    psil_ast * _left;
    psil_ast * _right;
    virtual bool eval_current() = 0;
    virtual bool eval(){
	if( nullptr != _left ){
	    if( !_left->eval() ){
		assert( 0 && "eval _left fail" );
		return false;
	    }
	}
	if( nullptr != _right ){
	    if( !_right->eval() ){
		assert( 0 && "eval _right fail" );
		return false;
	    }
	}
	return eval_current();
    }
    psil_type _type;
    psil_value _val;
    psil_ast( psil_type ret_type, psil_ast * left, psil_ast * right ) : _type(ret_type), _left(left), _right(right) {}
};

class psil_ast_number : public psil_ast {
public:
    psil_ast_number( double number ) : psil_ast( psil_type::NUMBER, nullptr, nullptr ){ _val.number = number; }
    bool eval_current(){
	std::cout << "number: " << _val.number << " ";
	return true;
    }
};

class psil_ast_bind : public psil_ast {
public:
    psil_ast_bind( psil_ast * left, psil_ast * right ) : psil_ast( psil_type::DEFERRED, left, right ){}
    bool eval_current(){
	if( nullptr != _left && nullptr != _right && _left->_type == psil_type::IDENTIFIER ){
	    symbol_table[ _left->_val.identifier ] = _right;
	    _type = _right->_type;
	    _val = _right->_val;
	    std::cout << "bind: { " << std::endl;
	    _left->eval_current();
	    std::cout << " <- ";
	    _right->eval_current();
	    std::cout  << " }" << std::endl;
	}
	return true;
    }
};

class psil_ast_word : public psil_ast {
public:
    psil_ast_word( char const * str ) : psil_ast( psil_type::WORD, nullptr, nullptr ) {
	_val.identifier = strdup( str );
    }
    bool eval_current(){
	std::cout << "word: " << _val.identifier << " ";
	return true;
    }
};


class psil_ast_data : public psil_ast {
public:
    psil_ast_data( psil_ast * ast ) : psil_ast( psil_type::DATA, nullptr, nullptr ), _data_specialize(ast) {}
    bool eval_current(){
	_data_specialize->eval_current();
	return true;
    }
    psil_ast * _data_specialize;
};

class psil_ast_datum : public psil_ast {
public:
    psil_ast_datum( psil_ast_data * data ) : psil_ast( psil_type::DATUM, nullptr, nullptr ) {
	_datum.clear();
	_datum.push_back( data );
    }
    bool eval_current(){
	for( auto & i : _datum ){
	    i->eval_current();
	}
	return true;
    }
    bool append( psil_ast_data * data ){
	_datum.push_back( data );
	return true;
    }
    std::vector< psil_ast_data * > _datum;
};

class psil_ast_list : public psil_ast {
public:
    psil_ast_list( psil_ast_datum * datum ) : psil_ast( psil_type::LIST, nullptr, nullptr ), _datum( datum ) {}
    bool eval_current(){
	std::cout << "list: { ";
	_datum->eval_current();
	std::cout << " }" << std::endl;
	return true;
    }
    psil_ast * _datum;
};


class psil_ast_identifier : public psil_ast {
public:
    psil_ast_identifier( psil_ast_data * data ) : psil_ast( psil_type::IDENTIFIER, nullptr, nullptr ), _identifier( data ) {}
    bool eval_current(){
	std::cout << "identifier: { ";
	_identifier->eval_current();
	std::cout << " }" << std::endl;
	return true;
    }
    psil_ast_data * _identifier;
};


//disabled---
// class psil_ast_prototype : public psil_ast {
// public:
//     psil_ast_prototype( psil_ast * words ) : psil_ast( psil_type::DEFERRED, nullptr, nullptr ), _words(words) {}
//     bool eval_current(){
// 	_words->eval_current();
// 	return true;
//     }
//     psil_ast * _words;
// };

// class psil_ast_parengroup : public psil_ast {
// public:
//     psil_ast_parengroup( psil_ast * words ) : psil_ast( psil_type::DEFERRED, nullptr, nullptr ), _words(words) {}
//     bool eval_current(){
// 	_words->eval_current();
// 	return true;
//     }
//     psil_ast * _words;
// };

// class psil_ast_definition : public psil_ast {
// public:
//     psil_ast_definition( psil_ast * args, psil_ast * body ) : psil_ast( psil_type::DEFERRED, nullptr, nullptr ), _args(args), _body(body) {}
//     bool eval_current(){
// 	std::cout << "arguments: ";
// 	_args->eval_current();
// 	std::cout << std::endl;
// 	std::cout << "body: ";
// 	_body->eval_current();
// 	std::cout << std::endl;
// 	return true;
//     }
//     psil_ast * _args;
//     psil_ast * _body;
// };

// class psil_ast_add : public psil_ast {
// public:
//     psil_ast_add( psil_ast * left, psil_ast * right ) : psil_ast( psil_type::NUMBER, left, right ){}
//     bool eval_current(){
// 	if( _left->_type != psil_type::NUMBER ){
// 	    assert( 0 && "type of _left not valid" );
// 	    return false;
// 	}
// 	if( _right->_type != psil_type::NUMBER ){
// 	    assert( 0 && "type of _right not valid" );
// 	    return false;
// 	}
// 	_val.number = _left->_val.number + _right->_val.number;
// 	std::cout << "ADD result: " << _val.number << std::endl;
// 	return true;
//     }
// };

#endif
