%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
extern FILE* yyin;
extern int yylex();
void yyerror(const char *msg);
%}

%union {
    char *str;      // String value for IDENTIFIER, CHAR
    int num_int;    // Integer value for INTEGER
    float num_float; // Float value for FLOAT
    int boolean;    // Boolean value for BOOLEAN
}

%token <str> IDENTIFIER CHAR
%token <num_int> INTEGER
%token <num_float> FLOAT
%token <boolean> BOOLEAN
%token TYPE_INT TYPE_FLOAT TYPE_CHAR TYPE_VOID TYPE_BOOL
%token IF ELSE_IF ELSE RETURN BREAK CONTINUE FOR WHILE
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA DOT ASSIGNMENT INCREMENT DECREMENT OPERATOR RELATIONAL
%token PRINT ERROR HASHTAG INCLUDE HEADER
%token SIN COS TAN ARCSIN ARCCOS ARCTAN

%start program

%type <boolean> evaluate

%%
program : action
        | program action
        ;

action : HASHTAG INCLUDE HEADER
       | value_type IDENTIFIER SEMICOLON
       | return_type IDENTIFIER ending SEMICOLON
       | return_type IDENTIFIER ending LBRACE global_inside RBRACE
       ;

global_inside : RETURN value SEMICOLON
              | statement
              | global_inside statement
              ;

statement : conditional_statement
          | iterative_statement
          | declaration SEMICOLON
          | p_statement SEMICOLON
          ;

conditional_statement : IF evaluate LBRACE inside
                      | ELSE IF evaluate LBRACE inside
                      | ELSE LBRACE inside
                      ;

iterative_statement : WHILE evaluate LBRACE inside
                     | FOR LPAREN TYPE_INT IDENTIFIER ASSIGNMENT int SEMICOLON IDENTIFIER  RELATIONAL int SEMICOLON IDENTIFIER p_or_m RPAREN LBRACE inside
                     ;

inside : RBRACE
       | hack RBRACE
       | inside statement
       ;

hack : RETURN value SEMICOLON
     | BREAK SEMICOLON
     | CONTINUE SEMICOLON
     ;

ending : LPAREN RPAREN
       | LPAREN argument RPAREN
       ;

argument : value
         | argument COMMA value
         ;

evaluate : LPAREN value RELATIONAL value RPAREN {
        switch($3) {
            case '==':
                if ($2 == $4) {
                    $$ = 1;
                } else {
                    $$ = 0;
                }
                break;
            case '!=':
                if ($2 != $4) {
                    $$ = 1;
                } else {
                    $$ = 0;
                }
                break;
            case '<=':
                if ($2 <= $4) {
                    $$ = 1;
                } else {
                    $$ = 0;
                }
                break;
            case '>=':
                if ($2 >= $4) {
                    $$ = 1;
                } else {
                    $$ = 0;
                }
                break;
            case '<':
                if ($2 < $4) {
                    $$ = 1;
                } else {
                    $$ = 0;
                }
                break;
            case '>':
                if ($2 > $4) {
                    $$ = 1;
                } else {
                    $$ = 0;
                }
                break;
            default:
                yyerror("Invalid Relational Operator")
            }
         }
 	     | LPAREN BOOLEAN RPAREN                {$$ = $2;}
         | LPAREN IDENTIFIER RPAREN    {$$ = $2;}
         ;

declaration : value_type IDENTIFIER
            | value_type IDENTIFIER declare   {$2 = $3}
	        | IDENTIFIER declare
	        | IDENTIFIER ending
            ;

declare : ASSIGNMENT value_statement        {$$ = $2}
	    | ASSIGNMENT value                  {$$ = $2}
        | ASSIGNMENT IDENTIFIER ending      {$$ = $2}
        ;

value_statement : trig
			    | num_value
			    | value_statement OPERATOR num_value {
                    switch ($2) {
                        case '+':
                            $$ = $1 + $3;
                            break;
                        case '-':
                            $$ = $1 - $3;
                            break;
                        case '*':
                            $$ = $1 * $3;
                            break;
                        case '/':
                            if ($3 != 0) {
                                $$ = $1 / $3; // Division
                            } else {
                                yyerror("Division by zero");
                            }
                            break;
                        case '%':
                            $$ = $1 % $3;
                            break;
                        case '^':
                            $$ = pow($1, $3)
                            break;
                        default:
                            yyerror("Invalid Operator")
                    }
                }
                ;

trig : SIN LPAREN value_statement RPAREN        { $$ = sin($3); }
     | COS LPAREN value_statement RPAREN        { $$ = cos($3); }
     | TAN LPAREN value_statement RPAREN        { $$ = tan($3); }
     | ARCSIN LPAREN value_statement RPAREN     { $$ = asin($3); }
     | ARCCOS LPAREN value_statement RPAREN     { $$ = acos($3); }
     | ARCTAN LPAREN value_statement RPAREN     { $$ = atan($3); }
     ;

p_statement : PRINT LPAREN CHAR RPAREN           {printf("%c\n", $3);}
            ;

value_type : TYPE_INT
	       | TYPE_FLOAT
	       | TYPE_CHAR
	       | TYPE_BOOL
           ;

return_type : value_type
	        | TYPE_VOID
            ;

int : INTEGER
    | IDENTIFIER
    ;

num_value : INTEGER
	      | FLOAT
	      | IDENTIFIER
          ;

p_or_m : INCREMENT
	   | DECREMENT
       ;

value : INTEGER
	  | FLOAT
	  | CHAR
	  | BOOLEAN
      | IDENTIFIER
      ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Parser error: %s\n", msg);
}
