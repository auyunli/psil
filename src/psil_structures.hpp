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
    NUMBER,
    STRING,
    ATOM,
    IDENTIFIER,
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
    psil_type _ret_type;
    psil_value _ret_val;
    psil_ast( psil_type ret_type, psil_ast * left, psil_ast * right ) : _ret_type(ret_type), _left(left), _right(right) {}
};

class psil_ast_add : public psil_ast {
public:
    psil_ast_add( psil_ast * left, psil_ast * right ) : psil_ast( psil_type::NUMBER, left, right ){}
    bool eval_current(){
	if( _left->_ret_type != psil_type::NUMBER ){
	    assert( 0 && "type of _left not valid" );
	    return false;
	}
	if( _right->_ret_type != psil_type::NUMBER ){
	    assert( 0 && "type of _right not valid" );
	    return false;
	}
	_ret_val.number = _left->_ret_val.number + _right->_ret_val.number;
	std::cout << "ADD result: " << _ret_val.number << std::endl;
	return true;
    }
};

class psil_ast_number : public psil_ast {
public:
    psil_ast_number( double number ) : psil_ast( psil_type::NUMBER, nullptr, nullptr ){ _ret_val.number = number; }
    bool eval_current(){
	std::cout << "Eval: " << _ret_val.number << std::endl;
	return true;
    }
};

class psil_ast_identifier : public psil_ast {
public:
    psil_ast_identifier( char * identifier ) : psil_ast( psil_type::IDENTIFIER, nullptr, nullptr ){ _ret_val.identifier = strdup(identifier); }
    bool eval_current(){
	return true;
    }
};

class psil_ast_bind : public psil_ast {
public:
    psil_ast_bind( psil_ast * left, psil_ast * right ) : psil_ast( psil_type::DEFERRED, left, right ){}
    bool eval_current(){
	if( nullptr != _left && nullptr != _right && _left->_ret_type == psil_type::IDENTIFIER ){
	    symbol_table[ _left->_ret_val.identifier ] = _right;
	    _ret_type = _right->_ret_type;
	    _ret_val = _right->_ret_val;
	}
	return true;
    }
};

class psil_ast_words : public psil_ast {
public:
    psil_ast_words() : psil_ast( psil_type::DEFERRED, nullptr, nullptr ){}
    bool eval_current(){
	std::cout << "words: ";
	for( auto & i : _words ){
	    std::cout << i << " ";
	}
	std::cout << std::endl;
	return true;
    }
    void append( char const * type ){
	_words.push_back( type );
    }
    std::vector<std::string> _words;
};

class psil_ast_prototype : public psil_ast {
public:
    psil_ast_prototype( psil_ast * words ) : psil_ast( psil_type::DEFERRED, nullptr, nullptr ), _words(words) {}
    bool eval_current(){
	_words->eval_current();
	return true;
    }
    psil_ast * _words;
};

class psil_ast_parengroup : public psil_ast {
public:
    psil_ast_parengroup( psil_ast * words ) : psil_ast( psil_type::DEFERRED, nullptr, nullptr ), _words(words) {}
    bool eval_current(){
	_words->eval_current();
	return true;
    }
    psil_ast * _words;
};

class psil_ast_definition : public psil_ast {
public:
    psil_ast_definition( psil_ast * args, psil_ast * body ) : psil_ast( psil_type::DEFERRED, nullptr, nullptr ), _args(args), _body(body) {}
    bool eval_current(){
	std::cout << "arguments: ";
	_args->eval_current();
	std::cout << std::endl;
	std::cout << "body: ";
	_body->eval_current();
	std::cout << std::endl;
	return true;
    }
    psil_ast * _args;
    psil_ast * _body;
};

#endif
