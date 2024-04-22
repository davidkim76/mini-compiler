%{
#include <stdio.h>
#include <parser.tab.h>

%}

DIGIT               [0-9]
LETTER              [a-zA-Z]
IDENT               {LETTER}({LETTER}|{DIGIT})*
INT                 {DIGIT}+
NUM_FLOAT           {DIGIT}+(\.{DIGIT}+)?
STRING              \"([^\"\\]|\\.)*\"
OPERATOR            [\+\-\*\/\%\^]
RELATIONAL          (==|!=|<=|>=|<|>)
SPACE               [ \t\n]
COMMENT             ("//"(.*)|"/\*"(.*?)"\*/")
HEADER              <w+>

%%
IDENT               {yylval.str = strdup(yytext); return IDENTIFIER;}
INT                 {yylval.num_int = atoi(yytext); return INTEGER;}
NUM_FLOAT           {yylval.num_float = atof(yytext); return FLOAT;}
CHAR                {yylval.str = strdup(yytext); return CHAR}
"true"              {yylval.boolean = 1; return BOOLEAN;}
"false"             {yylval.boolean = 0; return BOOLEAN;}
"int"               {return TYPE_INT;}
"float"             {return TYPE_FLOAT;}
"char"              {return TYPE_CHAR;}
"void"              {return TYPE_VOID;}
"bool"              {return TYPE_BOOL;}
"print"             {return PRINT}
"if"                {return IF;}
"else if"           {return ELSE_IF;}
"else"              {return ELSE;}
"return"            {return RETURN;}
"break"             {return BREAK;}
"continue"          {return CONTINUE}
"for"               {return FOR;}
"while"             {return WHILE;}
"("                 {return LPAREN;}
")"                 {return RPAREN;}
"{"                 {return LBRACE;}
"}"                 {return RBRACE;}
";"                 {return SEMICOLON;}
","                 {return COMMA;}
"."                 {return DOT;}
"="                 {return ASSIGNMENT;}
"++"                {return INCREMENT;}
"--"                {return DECREMENT;}
"#"                 {return HASHTAG}
HEADER              {yylval.str = strdup(yytext); return HEADER;}
OPERATOR            {yylval.str = strdup(yytext); return OPERATOR;}
RELATIONAL          {yylval.str = strdup(yytext); return RELATIONAL;}
SPACE               {;}
COMMENT             {;}
.                   {return yyerror;}
%%

void readFile(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Error opening file: %s\n", filename);
        exit(1);
    }

    yyrestart(file);
}


int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    readFile(argv[1]);

    yylex();

    return 0;
}

int yywrap() {
    return 1;
}
