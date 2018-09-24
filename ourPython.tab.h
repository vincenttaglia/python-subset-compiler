/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_OURPYTHON_TAB_H_INCLUDED
# define YY_YY_OURPYTHON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NEWLINE = 258,
    SEMICOLON = 259,
    COMMA = 260,
    SLASH = 261,
    BEGIN_INDENT = 262,
    END_INDENT = 263,
    PRINT = 264,
    IF = 265,
    ELIF = 266,
    ELSE = 267,
    COLON = 268,
    OPEN_PER = 269,
    CLOSE_PER = 270,
    WHILE = 271,
    LESSER = 272,
    LESSER_EQUAL = 273,
    GREATER = 274,
    GREATER_EQUAL = 275,
    EQUAL_EQUAL = 276,
    NOT_EQUAL = 277,
    EQUAL = 278,
    PLUS = 279,
    MINUS = 280,
    STAR = 281,
    FRT_SLASH = 282,
    STAR_STAR = 283,
    AND = 284,
    OR = 285,
    NOT = 286,
    INT = 287,
    FLOAT = 288,
    STRING = 289,
    TRUE = 290,
    FALSE = 291,
    NAME = 292
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 36 "ourPython.y" /* yacc.c:1909  */

    Statement* statePtr_;
    Expression* exprPtr_;
    Object* objPtr_;
    char* val;
    int int_;
    float float_;
    bool bool_;

#line 102 "ourPython.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_OURPYTHON_TAB_H_INCLUDED  */
