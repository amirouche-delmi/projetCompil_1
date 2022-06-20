%{
    #include "syn.tab.h"
    #include "fonctions.h"
    extern nb_ligne;
    extern YYSTYPE yylval;
%}

idf            [A-Z][A-Za-z0-9]*
cstI           [+-]?[0-9]+
cstF           [+-]?[0-9]+\.[0-9]+
caractere      \'[A-Za-z0-9]\'
str            \"[^"]*\"
commentaire    "/*".*"*/"

%%

PROCESS        {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return bib_process;}
LOOP           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return bib_loop;}
ARRAY          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return bib_array;}            
Programme      {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_programme;}
VAR            {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_var;}
INTEGER        {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_integer;}
REAL           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_real;}
CHAR           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_char;}
STRING         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_string;}
CONST          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_const;}
READ           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_read;}
WRITE          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_write;}
while          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_while;}
INF            {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_inf;}
SUP            {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_sup;}
EG             {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_eg;}
INFE           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_infe;}
SUPE           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_supe;}
DIFF           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_diff;}
EXECUT         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_execut;}
IF             {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_if;}
END_IF         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_end_if;}
ELSE           {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); return mc_else;}

{cstI}         { 
                    if(atoi(yytext) >= -32768 && atoi(yytext) <= 32767)
                    { 
                        yylval.intVal = atoi(yytext);
                        inserer(yytext, "cst");
                        if(yytext[0] == '+' || yytext[0] == '-')
                            return entier_s;
                        else 
                            return entier;
                    }else
                        printf("l'entier %s n'appartient pas a l'intervalle donne \n", yytext);
                }

{cstF}         {    
                    yylval.floatVal = atof(yytext);
                    inserer(yytext, "cst");
                    if(yytext[0] == '+' || yytext[0] == '-')
                        return real_s;
                    else 
                        return real;                   
                }
{caractere}    {yylval.charVal = yytext[1]; inserer(yytext, "cst"); return caractere;}
{str}          {yylval.strVal = strdup(yytext); inserer(yytext, "cst"); return string;}
{commentaire} 
{idf}          {
                    if(yyleng <= 10)
                    {
                        yylval.strVal = strdup(yytext);
                        inserer(yytext, "idf");
                        return idf;
                    }   
                    else
                        printf("Erreur lexicale a ligne %d IDF : %s trop long \n", nb_ligne, yytext);
                }

"::"           {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return quatre_points;}
"//"           {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return separateur_var;}
":="           {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return affectation;}

##             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return diese;}
\$             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return dollar;}
\{             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return accolade_o;}
\}             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return accolade_f;}
\[             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return crochet_o;}
\]             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return crochet_f;}
\=             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return egale;}
\"             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return guillemet;}
\'             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return apostrophe;}
\(             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return parenthese_o;}
\)             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return parenthese_f;}
\;             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return signe_de_formatage_integer;}
\%             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return signe_de_formatage_real;}
\?             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return signe_de_formatage_string;}
\&             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return signe_de_formatage_char;}
\|             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return barre_v;}
\@             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return arobase;}
\+             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return addition;}
\*             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return multiplication;}
\-             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return soustraction;}
\/             {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); return division;}

[ \t]
\n             {nb_ligne++; return fin_ligne;}
.              printf("erreur lexicale %s a la ligne %d \n", yytext, nb_ligne);
