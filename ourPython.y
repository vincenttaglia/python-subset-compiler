%{

/*-------------------------------------------------------------------------*
 *---									---*
 *---		ourPython.y						---*
 *---									---*
 *---	    This file defines the parser and high-level functions that	---*
 *---	implement a basic Python interpreter.				---*
 *---									---*
 *---	----	----	----	----	----	----	----	----	---*
 *---									---*
 *---	Version 1a		2018 May 16		Joseph Phillips	---*
 *---									---*
 *-------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------*

				Compile with:
bison -d --debug ourPython.y
g++ -c ourPython.tab.c -g
flex -o ourPython.cpp ourPython.lex 
g++ -c ourPython.cpp -g
g++ -c Object.cpp -g
g++ -c Expression.cpp -g
g++ -c Statement.cpp -g
g++ -o ourPython ourPython.tab.o ourPython.o Object.o Expression.o Statement.o

 *-------------------------------------------------------------------------*/


#include	"ourPython.h"

%}

%union
{
    Statement* statePtr_;
    Expression* exprPtr_;
    Object* objPtr_;
    char* val;
    int int_;
    float float_;
    bool bool_;
}

%error-verbose

%start	single_input

%token	NEWLINE SEMICOLON COMMA SLASH

%token BEGIN_INDENT END_INDENT PRINT

%token IF ELIF ELSE

%token COLON

%token OPEN_PER CLOSE_PER

%token WHILE

%token LESSER LESSER_EQUAL GREATER GREATER_EQUAL EQUAL_EQUAL NOT_EQUAL EQUAL

%token PLUS MINUS STAR FRT_SLASH STAR_STAR

%token AND OR NOT

%token INT FLOAT STRING TRUE FALSE NAME

%type <statePtr_> single_input

%type <statePtr_> if_stmt

%type <statePtr_> while_stmt

%type <statePtr_> proto_if_stmt

%type <statePtr_> compound_stmt

%type <statePtr_> simple_stmt

%type <statePtr_> small_stmt

%type <statePtr_> expr_stmt

%type <statePtr_> suite

%type <statePtr_> multi_stmt

%type <exprPtr_> test

%type <exprPtr_> or_test

%type <exprPtr_> and_test

%type <exprPtr_> not_test

%type <exprPtr_> comparison

%type <exprPtr_> expr

%type <exprPtr_> term

%type <exprPtr_> factor

%type <objPtr_> atom

%type <int_> INT

%type <val> STRING

%type <float_> FLOAT

%type <bool_> TRUE FALSE

%type <val> NEWLINE SEMICOLON IF ELIF ELSE COLON OPEN_PER CLOSE_PER WHILE LESSER LESSER_EQUAL GREATER GREATER_EQUAL EQUAL_EQUAL NOT_EQUAL EQUAL PLUS MINUS STAR FRT_SLASH STAR_STAR AND OR NOT BEGIN_INDENT END_INDENT PRINT COMMA SLASH NAME

//  Erase this line and declare tokens and types here

%%

single_input: {
		    return(1);
		  }
		| NEWLINE
		  {
		    programRootPtr = $$	= NULL;
		    YYACCEPT;
		  }
		| simple_stmt
		  {
		    programRootPtr = $$	= $1;
		    YYACCEPT;
		  }
		| compound_stmt
		  NEWLINE
		  {
		    programRootPtr = $$	= $1;
		    YYACCEPT;
		  };

compound_stmt: 
          if_stmt
          {
            $$ = $1;
          }
        | while_stmt
          {
            $$ = $1;
          };
          
simple_stmt: 
          small_stmt
          NEWLINE
          {
            $$ = $1;
          }
        | small_stmt
          SEMICOLON
          NEWLINE
          {
            $$ = $1;
          }
        | small_stmt
          SEMICOLON
          simple_stmt
          {
            $$ = new BlockStatement();
            $$ -> addStatement($1);
            $$ -> addStatement($3);
          };

small_stmt:
          expr_stmt
          {
            $$ = $1;
          };

expr_stmt:
          test
          {
            $$ = new ExpressionStatement($1);
          }
        | PRINT
          test
          {
            $$ = new PrintStatement($2);
          }
        | PRINT
          {
            $$ = new PrintStatement();
          };
          
test:
          or_test
          {
            $$ = $1;
          };
          
or_test:
          and_test
          {
            $$ = $1;
          }
        | and_test
          OR
          and_test
          {
            $$ = new BinaryExpression(OR_OP,$1,$3);
          };

and_test:
          not_test
          {
            $$ = $1;
          }
        | not_test
          AND
          not_test
          {
            $$ = new BinaryExpression(AND_OP,$1,$3);
          };
          
not_test:
          NOT
          not_test
          {
            $$ = new UnaryExpression(NOT_OP,$2);
          }
        | comparison
          {
            $$ = $1;
          };

comparison:
          expr
          {
            $$ = $1;
          }
        | expr
          LESSER
          expr
          {
            $$ = new BinaryExpression(LESSER_OP,$1,$3);
          }
        | expr
          LESSER_EQUAL
          expr
          {
            $$ = new BinaryExpression(LESSER_EQUAL_OP,$1,$3);
          }
        | expr
          GREATER
          expr
          {
            $$ = new BinaryExpression(GREATER_OP,$1,$3);
          }
        | expr
          GREATER_EQUAL
          expr
          {
            $$ = new BinaryExpression(GREATER_EQUAL_OP,$1,$3);
          }
        | expr
          EQUAL_EQUAL
          expr
          {
            $$ = new BinaryExpression(EQUAL_EQUAL_OP,$1,$3);
          }
        | expr
          NOT_EQUAL
          expr
          {
            $$ = new BinaryExpression(NOT_EQUAL_OP,$1,$3);
          }
        | expr
          EQUAL
          expr
          {
            $$ = new AssignmentExpression($1,$3);
          };

expr:
          term
          {
            $$ = $1;
          }
        | term
          MINUS
          term
          {
            $$ = new BinaryExpression(MINUS_OP,$1,$3);
          }
        | term
          PLUS
          term
          {
            $$ = new BinaryExpression(PLUS_OP,$1,$3);
          };
          
term:
          factor
          {
            $$ = $1;
          }
        | factor
          STAR
          factor
          {
            $$ = new BinaryExpression(STAR_OP,$1,$3);
          }
        | factor
          SLASH
          factor
          {
            $$ = new BinaryExpression(SLASH_OP,$1,$3);
          };

factor:
          atom
          {
            $$ = new ConstantExpression($1);
          }
        | PLUS
          atom
          {
            $$ = new UnaryExpression(PLUS_OP, new ConstantExpression($2));
          }
        | MINUS
          atom
          {
            $$ = new UnaryExpression(MINUS_OP, new ConstantExpression($2));
          }
        | NAME
          {
            $$ = new VariableExpression($1);
          }
        | OPEN_PER
          test
          CLOSE_PER
          {
            $$ = $2;
          };
          
atom:
          INT
          {
            $$ = new IntObject($1);
          }
        | STRING
          {
            $$ = new StrObject($1);
          }
        | FLOAT
          {
            $$ = new FloatObject($1);
          }
        | TRUE
          {
            $$ = new BoolObject($1);
          }
        | FALSE
          {
            $$ = new BoolObject($1);
          };
          

if_stmt: 
          proto_if_stmt
          {
            $$ = $1;
          }
        | proto_if_stmt
          ELSE
          COLON
          suite
          {
            $$ = $1; $$ -> appendElse($4);
          };

proto_if_stmt:
          IF 
          test
          COLON
          suite
          {
            $$ = new IfThenElseStatement($2,$4);
          }
        | proto_if_stmt
          ELIF
          test
          COLON
          suite
          {
            $$ = $1; $$ -> appendElif($3,$5);
          };

while_stmt: 
          WHILE 
          test
          COLON
          suite
          {
            $$ = new WhileStatement($2,$4);
          }
        | while_stmt
          ELSE
          COLON
          suite
          {
            $$ = $1; $$ -> appendElse($4);
          };

suite:    
          NEWLINE
          BEGIN_INDENT
          multi_stmt
          END_INDENT
          {
            $$ = $3;
          };
          
multi_stmt:
          multi_stmt
          simple_stmt
          {
            $$ = $1;
            $$ -> addStatement($2);
          }
        | simple_stmt
          {
            $$ = new BlockStatement();
            $$ -> addStatement($1);
          };

%%


//  PURPOSE:  To tell the printable names of the values of 'pythonType_ty'.
const char*	typeNameArray[]
      		= {
		    "none",
		    "bool",
		    "int",
		    "float",
		    "str",
		    "type"
		  };


//  PURPOSE:  To tell the printable names of the values of 'operator_ty'.
const char*	operatorNameArray[]
      		= {
		    "OR",
		    "AND",
		    "NOT",
		    "+",
		    "-",
		    "*",
		    "/",
		    "%",
		    "//",
		    "**"
		  };


//  PURPOSE:  To hold the names of boolean constants.
const char*	booleanConstName[]
		= { "False",
		    "True"
		  };


//  PURPOSE:  To serve as a global temporary C-string array.
char		line[LINE_LEN];


//  PURPOSE:  To point to the root of the abstract syntax tree.
Statement*	programRootPtr	= NULL;


//  PURPOSE:  To hold the variables and their values.
VariableStore	variableStore;


//  PURPOSE:  To handle the outputing of parse-time error message 'cPtr'.
//	No return value.
int		yyerror		(const char*	cPtr
				)
{
  throw Exception(cPtr);
}


//  PURPOSE:  To interpret and run the Python program given in 'argv[1]'.
//	Returns 'EXIT_SUCCESS' on success or 'EXIT_FAILURE' otherwise.
int		main		(int		argc,
				 char*		argv[]
				)
{
  //  I.  Application validity check:
  if  (argc < 2)
  {
    fprintf(stderr,"Usage:\t%s <pythonProg>\n",argv[0]);
    exit(EXIT_FAILURE);
  }

  //  II.  Parse and execute program:
  //  II.A.  Initialize file:
  const char*	pythonFilepath	= argv[1];

  if  ( (yyin = fopen(pythonFilepath,"r")) == NULL )
  {
    fprintf(stderr,"Error opening %s.\n",pythonFilepath);
    exit(EXIT_FAILURE);
  }

  //  II.B.  Attempt to parse and assemble 'yyin':
  int	status	= EXIT_SUCCESS;

  try
  {
    //  II.B.1.  Attempt to parse:
    while  ( !feof(yyin) && (yyparse() == 0) )
    {
      //  II.B.1.a.  Parse was successful and have tree:
      if  (programRootPtr != NULL)
      {

        //  II.B.1.a.I.  It highest Statement was an Expression,
        //  	       then convert it to a Print so output is generated:
        ExpressionStatement*	exprPtr;

        exprPtr	= dynamic_cast<ExpressionStatement*>(programRootPtr);

        if  (exprPtr != NULL)
        {
	  programRootPtr = new PrintStatement(exprPtr->giveAwayExprPtr());

	  safeDelete(exprPtr);
        }

        //  II.B.1.a.II.  Walk tree to evaluate it:
        programRootPtr->run();

        //  II.B.1.a.III.  Release memory:
        safeDelete(programRootPtr);
      }
    }

  }
  catch  (Exception error)
  {
    fprintf(stderr,"Error: %s\n",error.getDescription().c_str());
    status	= EXIT_FAILURE;
  }

  //  II.C.  Clean up:
  fclose(yyin);

  //  III.  Finished:
  return(status);
}
