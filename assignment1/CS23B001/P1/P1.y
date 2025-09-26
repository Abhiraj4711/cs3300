%{
    #include "bits/stdc++.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    using namespace std;
    struct macro {
        vector<string> params;
        string body;   
        int isExpr=0;        
    };

    map<string, macro> macroMap;

    void yyerror(const char *);
    int yylex(void);
    int yyparse(void);
    int line_counter =1;
    string indent(string s) 
    {
        s.insert(0, "\t");

        for (int i = 0; i < s.size(); i++) {
            if (s[i] == '\n') {
                s.insert(i + 1, "\t");
                i++;
            }
        }

        if (!s.empty() && s.back() == '\t') {
            s.pop_back();
        }

        return s;
    }
    
    vector<string> change(vector<string> v){
        for(int i=0;i<v.size();i++){
            v[i]="######"+to_string(i);
        }
        return v;
    }

vector<string> split(string s) {
    vector<string> ans;
    string a;
    for (char ch : s) {
        if (ch == ',') {
            ans.push_back(a);
            a.clear();
        } else {
            a += ch;
        }
    }
    ans.push_back(a);
    if(ans[0]==""){
        return {};
    }
    return ans;
}

    
%}

%union{
    char* val;
}


%token <val> FUNCTION PUBLIC CLASS STATIC VOID MAIN IMPORT LAB RAB JAVAUTILFUNCTION EXTENDS PRINT STRING INT INTARR BOOLEAN ELSE IF DO WHILE RETURN USING BREAK CONTINUE LENGTH TRU FAL THIS NEW DEFINE OB CB STAR SLASH PLUS MINUS NOT ARROW LTE GTE NOTEQ OR AND DOT COMMA EQ OP CP OSB CSB SC NUM ID
%type <val> Goal MainClass TypeDeclaration MethodDeclaration Type Statement Expression PrimaryExpression MacroDefinition MacroDefStatement MacroDefExpression Identifier Integer
%type <val> ImportFunction MacroDefinitionHelp TypeDeclarationHelp  MethodDeclarationHelp MethodParametersHelp StatementHelp MultipleExpressionHelper MultipleIdentifierHelper IfElseBlock   

%%
    Goal: ImportFunction MacroDefinitionHelp MainClass TypeDeclarationHelp {
        cout<<string($1)+string($2)+string($3)+string($4);
    }
        ;
    
    ImportFunction: IMPORT JAVAUTILFUNCTION SC { $$ = "import java.util.function.Function;\n";}
                  | {$$="";}

    MainClass: CLASS Identifier OB PUBLIC STATIC VOID MAIN OP STRING OSB CSB Identifier CP OB PRINT OP Expression CP SC CB CB {
                string ans="";
                ans+=string($1)+" "+string($2)+"\n"+string($3)+"\n"+indent(string($4)+" "+string($5)+" "+string($6)+" "+string($7)+string($8)+string($9)+" "+string($10)+string($11)+string($12)+string($13)+"\n"+string($14)+"\n"+indent(string($15)+string($16)+string($17)+string($18)+string($19))+"\n"+string($20))+"\n"+string($21);
                $$=strdup(ans.c_str());
             }
             ;

    TypeDeclarationHelp: TypeDeclarationHelp TypeDeclaration {
                string ans="";
                ans+=string($1)+"\n"+string($2);
                $$=strdup(ans.c_str());
             }
                       | {$$="";}
                       ;

    TypeDeclaration: CLASS Identifier OB StatementHelp MethodDeclarationHelp CB {
                string ans="";
                ans+=string($1)+" "+string($2)+"\n"+string($3)+"\n"+indent(string($4)+string($5))+"\n"+string($6);
                $$=strdup(ans.c_str());
             }
                    
                   | CLASS Identifier EXTENDS Identifier OB StatementHelp MethodDeclarationHelp CB {
                        string ans="";
                        ans+=string($1)+" "+string($2)+" "+string($3)+" "+string($4)+"\n"+string($5)+"\n"+indent(string($6)+string($7))+"\n"+string($8);
                        $$=strdup(ans.c_str());
             }
                   ;

    MethodDeclarationHelp: MethodDeclarationHelp MethodDeclaration {
                string ans="";
                ans+=string($1)+"\n"+string($2);
                $$=strdup(ans.c_str());
             }
                         | {$$="";}
                         ;

    MethodDeclaration: PUBLIC Type Identifier OP MethodParametersHelp CP OB StatementHelp RETURN Expression SC CB {
                string ans="";
                ans+=string($1)+" "+string($2)+" "+string($3)+string($4)+string($5)+string($6)+"\n"+string($7)+"\n"+indent(string($8)+"\n"+string($9)+" "+string($10)+string($11))+"\n"+string($12);              $$=strdup(ans.c_str());
             }
                     ;


    StatementHelp: StatementHelp Statement {
                string ans="";
                ans+=string($1)+"\n"+string($2);
                $$=strdup(ans.c_str());
             }
                 | {$$="";}
                 ;

    Statement: OB StatementHelp CB { string ans=""; ans+=string($1)+indent(string($2))+"\n"+string($3); $$=strdup(ans.c_str()); }
             | Type Identifier SC { string ans=""; ans+=string($1)+" "+string($2)+string($3); $$=strdup(ans.c_str()); }
             | PRINT OP Expression CP SC { string ans=""; ans+=string($1)+string($2)+string($3)+string($4)+string($5); $$=strdup(ans.c_str()); }
             | Identifier EQ Expression SC { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3)+string($4); $$=strdup(ans.c_str()); }
             | Identifier OSB Expression CSB EQ Expression SC { string ans=""; ans+=string($1)+string($2)+string($3)+string($4)+" "+string($5)+" "+string($6)+string($7); $$=strdup(ans.c_str()); }
             | IfElseBlock { string ans=""; ans+=string($1); $$=strdup(ans.c_str());}
             | DO Statement WHILE OP Expression CP SC { string ans=""; ans+=string($1)+"\n"+indent(string($2))+"\n"+string($3)+" "+string($4)+string($5)+string($6)+string($7); $$=strdup(ans.c_str());}
             | WHILE OP Expression CP Statement { string ans=""; ans+=string($1)+string($2)+string($3)+string($4)+"\n"+indent($5)+"\n"; $$=strdup(ans.c_str()); }
             | Identifier OP MultipleExpressionHelper CP SC {
                                                                string macroName = string($1);
                                                                if (macroMap.find(macroName) != macroMap.end()) {
                                                                    macro m = macroMap[macroName];
                                                                    if (m.isExpr == 1) {
                                                                        yyerror("");
                                                                    }
                                                                    string result = m.body;
                                                                    vector<string> args = split(string($3));

                                                                    if (args.size() != m.params.size()) {
                                                                        yyerror("");
                                                                    }

                                                                    for (int i = 0; i < m.params.size(); ++i) {
                                                                        string parami = m.params[i];

                                                                        string givenArg = args[i];


                                                                        int pos = 0;
                                                                        while ((pos = result.find(parami, pos)) != string::npos) {
                                                                            result.replace(pos, parami.size(), givenArg);
                                                                            pos += givenArg.size();
                                                                        }
                                                                    }

                                                                    string out = result;
                                                                    $$ = strdup(out.c_str());
                                                                } else {
                                                                    yyerror("");
                                                                }
                                                            }
             ;

    IfElseBlock: IF OP Expression CP Statement ELSE Statement { string ans=""; ans+=string($1)+string($2)+string($3)+string($4)+"\n"+(string($5))+"\n"+string($6)+"\n"+(string($7)); $$=strdup(ans.c_str()); }
               | IF OP Expression CP Statement { string ans=""; ans+=string($1)+string($2)+string($3)+string($4)+"\n"+(string($5)); $$=strdup(ans.c_str()); }
               ;

    Expression: PrimaryExpression AND Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression OR Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression NOTEQ Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression LTE Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression PLUS Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression MINUS Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression STAR Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression SLASH Expression { string ans=""; ans+=string($1)+" "+string($2)+" "+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression OSB Expression CSB { string ans=""; ans+=string($1)+string($2)+string($3)+string($4); $$=strdup(ans.c_str()); }
              | PrimaryExpression DOT LENGTH { string ans=""; ans+=string($1)+string($2)+string($3); $$=strdup(ans.c_str()); }
              | PrimaryExpression { string ans=""; ans+=string($1); $$=strdup(ans.c_str()); }
              | PrimaryExpression DOT Identifier OP MultipleExpressionHelper CP { string ans=""; ans+=string($1)+string($2)+string($3)+string($4)+string($5)+string($6); $$=strdup(ans.c_str()); }
              | Identifier OP MultipleExpressionHelper CP { 
                                                                string macroName = string($1);
                                                                if (macroMap.find(macroName) != macroMap.end()) {
                                                                    macro m = macroMap[macroName];
                                                                    if (m.isExpr == 0) {
                                                                        yyerror("");
                                                                    }

                                                                    string result = m.body;
                                                                    vector<string> args = split(string($3));

                                                                    if (args.size() != m.params.size()) {
                                                                        yyerror("");
                                                                    }

                                                                    for (int i = 0; i < m.params.size(); ++i) {
                                                                        string parami = m.params[i];
                                                                        
                                                                        bool isAlphaThingy=false;
                                                                        for(char ch:args[i]){
                                                                            if(isalpha(ch)||ch=='_'){
                                                                                isAlphaThingy=true;
                                                                            }
                                                                        }

                                                                        string arg = !isAlphaThingy?string("("+args[i]+")"):args[i];

                                                                        int pos = 0;
                                                                        while ((pos = result.find(parami, pos)) != string::npos) {
                                                                            result.replace(pos, parami.size(), arg);
                                                                            pos += arg.size();
                                                                        }
                                                                    }

                                                                    string out =  result;
                                                                    $$ = strdup(out.c_str());
                                                                } else {
                                                                    yyerror("");
                                                                }
                                                            }
              | OP Identifier ARROW Expression { string ans=""; ans+="("+string($1)+string($2)+") -> "+string($4)+")"; $$=strdup(ans.c_str());}
              ;

    PrimaryExpression: Integer { string ans=""; ans+=string($1); $$=strdup(ans.c_str()); }
                     | TRU { string ans=""; ans+=string($1); $$=strdup(ans.c_str()); }
                     | FAL { string ans=""; ans+=string($1); $$=strdup(ans.c_str()); }
                     | Identifier { string ans=""; ans+=string($1); $$=strdup(ans.c_str()); }
                     | THIS { string ans=""; ans+=string($1); $$=strdup(ans.c_str()); }
                     | NEW INT OSB Expression CSB { string ans=""; ans+=string($1)+" "+string($2)+string($3)+string($4)+string($5); $$=strdup(ans.c_str()); }
                     | NEW Identifier OP CP { string ans=""; ans+=string($1)+" "+string($2)+string($3)+string($4); $$=strdup(ans.c_str()); }
                     | NOT Expression { string ans=""; ans+=string($1)+string($2); $$=strdup(ans.c_str()); }
                     | OP Expression CP { string ans=""; ans+=string($1)+string($2)+string($3); $$=strdup(ans.c_str()); }
                     ;

    MethodParametersHelp: MethodParametersHelp COMMA Type Identifier { string ans=""; ans+=string($1)+string($2)+string($3)+" "+string($4); $$=strdup(ans.c_str()); }
                        | Type Identifier { string ans=""; ans+=string($1)+" "+string($2); $$=strdup(ans.c_str()); }
                        | {$$="";}
                        ;

    MultipleExpressionHelper: MultipleExpressionHelper COMMA Expression { string ans=""; ans+=string($1)+string($2)+string($3); $$=strdup(ans.c_str()); } 
                            | Expression { string ans=""; ans+=string($1); $$=strdup(ans.c_str()); }
                            | {$$="";}
                            ;

    MacroDefinitionHelp: MacroDefinition MacroDefinitionHelp { $$="";}
                       | {$$="";}
                       ;

    MacroDefinition: MacroDefExpression {$$=$1;}
                   | MacroDefStatement {$$=$1;}
                   ;

    MacroDefStatement: DEFINE Identifier OP MultipleIdentifierHelper CP OB StatementHelp CB { 

                            macro m;
                            vector<string> origParam = split(string($4));
                            m.params = change(origParam);
                            m.body   = string($7);
                            m.isExpr = 0;
                            string result = m.body;

                            for (int i = 0; i < origParam.size(); i++) {
                                string pattern = "\\b" + origParam[i] + "\\b";
                                result = regex_replace(result, regex(pattern), m.params[i]);
                            }

                            m.body = result; 
                            macroMap[string($2)] = m;

                            $$ = "";
                      }
                     ;
 
    MacroDefExpression: DEFINE Identifier OP MultipleIdentifierHelper CP OP Expression CP { 

                            macro m;
                            vector<string> origParam = split(string($4));
                            m.params = change(origParam);
                            m.body   = string($7);
                            m.isExpr = 1;
                            string result = m.body;

                            for (int i = 0; i < origParam.size(); i++) {
                                string pattern = "\\b" + origParam[i] + "\\b";
                                result = regex_replace(result, regex(pattern), m.params[i]);
                            }

                            m.body = result; 
                            macroMap[string($2)] = m;

                            $$ = ""; 
                      }
                      ;
    
    MultipleIdentifierHelper: MultipleIdentifierHelper COMMA Identifier { string ans=""; ans+=string($1)+string($2)+string($3); $$=strdup(ans.c_str()); }
                            | Identifier {$$=$1;}
                            | {$$="";}
                            ;
    Type: INTARR {$$=$1;}
        | BOOLEAN {$$=$1;}
        | INT {$$=$1;}
        | Identifier {$$=$1;}
        | FUNCTION LAB Identifier COMMA Identifier RAB { string ans=""; ans+="Function"+string($2)+string($3)+string($4)+string($5)+string($6); $$=strdup(ans.c_str()); }
        ;

    Identifier: ID {$$=$1;}
              ;
    
    Integer: NUM {$$=$1;}
           ;

%%


void yyerror(const char *s) {
    fprintf(stdout, "// Failed to parse macrojava code.");
    exit(1);
}

int main(void) {
    return yyparse();
} 
 
