%{
#include <stdio.h>
#include <parser.tab.h>
%}


//lexical rules specified by regex
DIGIT               [0-9]
LETTER              [a-zA-Z]
IDENT               {LETTER}({LETTER}|{DIGIT})*
INT                 {DIGIT}+
FLOAT               {DIGIT}+(\.{DIGIT}+)?
STRING              \"([^\"\\]|\\.)*\"
OPERATOR            [\+\-\*\/\%\^\&]
RELATIONAL          (==|!=|<=|>=|<|>)
SPACE               [ \t\n]
COMMENT             ("//"(.*)|"/\*"(.*?)"\*/")      

%%
//define actions taken when tokens are matched to user input
IDENT               {yylval.str = strdup(yytext); return IDENTIFIER;}
INT                 {yylval.num_int = atoi(yytext); return INTEGER;}
FLOAT               {yylval.num_float = atof(yytext); return FLOAT_NUM;}
CHAR                {yylval.str = strdup(yytext); return CHAR}
"true"              {yylval.boolean = 1; return BOOLEAN;}
"false"             {yylval.boolean = 0; return BOOLEAN;}
"int"               {return INT_TYPE;}
"float"             {return FLOAT_TYPE;}
"char"              {return CHAR_TYPE;}
"void"              {return VOID_TYPE;}
"bool"              {return BOOL_TYPE;}
"if"                {return IF;}
"else if"           {return ELSE_IF;}
"else"              {return ELSE;}
"return"            {return RETURN;}
"break"             {return BREAK;}
"continue"          {return CONTINUE}
"for"               {return FOR;}
"while"             {return WHILE;}
"("                 {return LEFT_PAREN;}
")"                 {return RIGHT_PAREN;}
"{"                 {return LEFT_BRACE;}
"}"                 {return RIGHT_BRACE;}
";"                 {return SEMICOLON;}
","                 {return COMMA;}
"."                 {return DOT;}
"="                 {return ASSIGNMENT;}
"++"                {return INCREMENT;}
"--"                {return DECREMENT;}
[ \t\n]             ; //ignore
"sin"               {return SIN;}
"cos"               {return COS;}
"tan"               {return TAN;}
"arcsin"            {return ARCSIN;}
"arccos"            {return ARCCOS;}
"arctan"            {return ARCTAN;}
OPERATOR            {yylval.str = strdup(yytext); return OPERATOR;}
RELATIONAL          {yylval.str = strdup(yytext); return RELATIONAL;}
SPACE               {}
COMMENT             {}
.                   {return ERROR;}

%%

yywrap() {

}
