%{
    #include <bits/stdc++.h>
    #include "P1.tab.h"
    void yyerror(char *);
    using namespace std;
    extern int line_counter;
%}

%%
"public"                        { yylval.val = strdup(yytext); return PUBLIC; }
"Function"                        { yylval.val = strdup(yytext); return FUNCTION; }
"class"                         { yylval.val = strdup(yytext); return CLASS; }
"static"                        { yylval.val = strdup(yytext); return STATIC; }
"void"                          { yylval.val = strdup(yytext); return VOID; }
"main"                          { yylval.val = strdup(yytext); return MAIN; }
"extends"                       { yylval.val = strdup(yytext); return EXTENDS; }
"System.out.println"            { yylval.val = strdup(yytext); return PRINT; }
"import"                        { yylval.val = strdup(yytext); return IMPORT; }
"<"                             { yylval.val = strdup(yytext); return LAB; }
">"                             { yylval.val = strdup(yytext); return RAB; }
"String"                        { yylval.val = strdup(yytext); return STRING; }
"int"                           { yylval.val = strdup(yytext); return INT; }
"int[]"                         { yylval.val = strdup(yytext); return INTARR; }
"boolean"                       { yylval.val = strdup(yytext); return BOOLEAN; }
"java.util.function.Function"   { yylval.val = strdup(yytext); return JAVAUTILFUNCTION; }
"if"                            { yylval.val = strdup(yytext); return IF; }
"else"                          { yylval.val = strdup(yytext); return ELSE; }
"do"                            { yylval.val = strdup(yytext); return DO; }
"while"                         { yylval.val = strdup(yytext); return WHILE; }
"return"                        { yylval.val = strdup(yytext); return RETURN ; }
"using"                         { yylval.val = strdup(yytext); return USING; }
"break"                         { yylval.val = strdup(yytext); return BREAK; }
"continue"                      { yylval.val = strdup(yytext); return CONTINUE; }
"length"                        { yylval.val = strdup(yytext); return LENGTH; }
"true"                          { yylval.val = strdup(yytext); return TRU; }
"false"                         { yylval.val = strdup(yytext); return FAL; }
"this"                          { yylval.val = strdup(yytext); return THIS; }
"new"                           { yylval.val = strdup(yytext); return NEW; }
"#define"                       { yylval.val = strdup(yytext); return DEFINE; }
"("                             { yylval.val = strdup(yytext); return OP; }
")"                             { yylval.val = strdup(yytext); return CP; }
"*"                             { yylval.val = strdup(yytext); return STAR;}
"/"                             { yylval.val = strdup(yytext); return SLASH;}
"+"                             { yylval.val = strdup(yytext); return PLUS;}
"-"                             { yylval.val = strdup(yytext); return MINUS;}
"!"                             { yylval.val = strdup(yytext); return NOT;}
[)][ ]*[-][>]                   { yylval.val = strdup(yytext); return ARROW;}
"<="                            { yylval.val = strdup(yytext); return LTE;}
">="                            { yylval.val = strdup(yytext); return GTE;}
"!="                            { yylval.val = strdup(yytext); return NOTEQ;}
"||"                            { yylval.val = strdup(yytext); return OR;}
"&&"                            { yylval.val = strdup(yytext); return AND;}
"."                             { yylval.val = strdup(yytext); return DOT;}
","                             { yylval.val = strdup(yytext); return COMMA;}
"="                             { yylval.val = strdup(yytext); return EQ;}
"{"                             { yylval.val = strdup(yytext); return OB;}
"}"                             { yylval.val = strdup(yytext); return CB;}
"["                             { yylval.val = strdup(yytext); return OSB;}
"]"                             { yylval.val = strdup(yytext); return CSB;}
";"                             { yylval.val = strdup(yytext); return SC;}
[0-9]+\.[0-9]+                  { yylval.val = strdup(yytext); return NUM;}
[0-9]+                          { yylval.val = strdup(yytext); return NUM;}
[a-zA-Z_][a-zA-Z0-9_]*          { yylval.val = strdup(yytext); return ID;}
"//".*                          { /* ignore single-line comment */ }

"/*"([^*]|\*+[^*/])*\*+"/"      { /* ignore multi-line comment */ }

[ \t]                           { /* ignore whitespace */ }
\n                              { line_counter++; }
.                               { }

%%

int yywrap(void) {
    return 1;
}
