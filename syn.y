%{
    #include <string.h>
    int nb_ligne = 1, t = 0, nb_dec_PROCESS = 0, nb_dec_LOOP = 0, nb_dec_ARRAY = 0;
    char sauvType[20], sauvOpt[5], comp[10];
    float sauvOpd;
    typedef struct
	{
		char NomTab[100];
		int TaiTab;
	} T_TAB;
    T_TAB sauvTTab[50];
    
%}

%union{
    int intVal;
    float floatVal;
    char* strVal;
    char charVal;
}
%token 
<strVal> bib_process        <strVal> bib_loop       <strVal> bib_array      <strVal> mc_programme
<strVal> mc_var             <strVal> mc_integer     <strVal> mc_real        <strVal> mc_char
<strVal> mc_string          <strVal> mc_const       <strVal> mc_read        <strVal> mc_write
<strVal> mc_while           <strVal> mc_inf         <strVal> mc_sup         <strVal> mc_eg      
<strVal> mc_infe            <strVal> mc_supe        <strVal> mc_diff        <strVal> mc_execut      
<strVal> mc_if              <strVal> mc_end_if      <strVal> mc_else        <intVal> entier
<intVal> entier_s           <floatVal> real         <floatVal> real_s       <charVal> caractere
<strVal> string             <strVal> idf            <strVal> quatre_points  <strVal> separateur_var
<strVal> affectation        <strVal> diese          <strVal> dollar         <strVal> accolade_o
<strVal> accolade_f         <strVal> crochet_o      <strVal> crochet_f      <strVal> egale
<strVal> guillemet          <strVal> apostrophe     <strVal> parenthese_o   <strVal> parenthese_f
<strVal> signe_de_formatage_integer                 <strVal> signe_de_formatage_real
<strVal> signe_de_formatage_string                  <strVal> signe_de_formatage_char
<strVal> barre_v            <strVal> arobase        <strVal> addition       <strVal> multiplication
<strVal> soustraction       <strVal> division       fin_ligne

%%
S: FIN BIB mc_programme idf FIN accolade_o FIN DEC FIN LIST_INST FIN accolade_f
                            {
                                printf("prog syntaxiquement correct");
                                YYACCEPT;
                            }
;
FIN: fin_ligne FIN 
    | 
;
BIB: diese NOM_BIB dollar fin_ligne FIN BIB 
   | FIN 
;
NOM_BIB: bib_process    {
                            nb_dec_PROCESS++; 
                                if(nb_dec_PROCESS > 1)
                                    printf("Erreur semantique : bib %s est deja declare a la ligne %d \n",$1, nb_ligne);
                        }
       | bib_loop       {
                            nb_dec_LOOP++; 
                                if(nb_dec_LOOP > 1)
                                    printf("Erreur semantique : bib %s est deja declare a la ligne %d \n",$1, nb_ligne);
                        }
       | bib_array      {
                            nb_dec_ARRAY++; 
                                if(nb_dec_ARRAY > 1)
                                    printf("Erreur semantique : bib %s est deja declare a la ligne %d \n",$1, nb_ligne);
                        }
;
DEC: DEC_VAR DEC_CONST 
   | DEC_CONST DEC_VAR 
   | DEC_VAR 
   | DEC_CONST 
   | 
;
DEC_VAR: mc_var FIN LIST_VAR 
;
LIST_VAR: TYPE quatre_points LIST_IDF_VAR dollar FIN LIST_VAR 
        | TYPE quatre_points LIST_IDF_VAR dollar FIN 
;
TYPE: mc_integer {strcpy(sauvType, $1);}
    | mc_real    {strcpy(sauvType, $1);}
    | mc_string  {strcpy(sauvType, $1);}
    | mc_char    {strcpy(sauvType, $1);}
;

LIST_IDF_VAR: DEC_TAB separateur_var LIST_IDF_VAR
            | DEC_TAB
            | idf separateur_var LIST_IDF_VAR       
                    {   
                        if(Declaration($1) == 0)
                            insererTYPE($1, sauvType, 0);
                            else 
                            printf("Erreur semantique : double declaration a la ligne %d \n", nb_ligne);
                    }                             
            | idf            
                    {   
                        if(Declaration($1) == 0)
                            insererTYPE($1, sauvType, 0);
                        else 
                            printf("Erreur semantique : double declaration a la ligne %d \n", nb_ligne);
                    }
;
DEC_TAB: idf crochet_o entier crochet_f 
            {   
                if(nb_dec_ARRAY == 0)
                    printf("Erreur semantique : bib ARRAY non importe \n");
                else
                    if(Declaration($1) == 0)
                        if ($3 == 0)     
                            printf("Erreur semantique : la taille d'un tableau ne peut pas etre 0 a la ligne %d \n", nb_ligne);
                        else
                        {
                            insererTYPE($1, sauvType, 0);
                            strcpy(sauvTTab[t].NomTab, $1);
                            sauvTTab[t].TaiTab = $3;
                            t++; 
                        }
                    else   
                        printf("Erreur semantique : double declaration a la ligne %d \n", nb_ligne);  
            }
       | idf crochet_o entier_s crochet_f 
            {
                if(nb_dec_ARRAY == 0)
                    printf("Erreur semantique : bib ARRAY non importe\n");
                else
                    if(Declaration($1) == 0)
                        if ($3 <= 0)     
                            printf("Erreur semantique : la taille d'un tableau ne peut pas etre <= 0 a la ligne %d \n", nb_ligne);
                        else
                        {                                               
                            insererTYPE($1, sauvType, 0);
                            strcpy(sauvTTab[t].NomTab, $1);
                            sauvTTab[t].TaiTab = $3;
                            t++;
                        }
                    else
                        printf("Erreur semantique : double declaration a la ligne %d \n", nb_ligne);
            }
;
DEC_CONST: mc_const FIN LIST_CONST 
;

LIST_CONST: TYPE quatre_points LIST_IDF_CONST dollar FIN LIST_CONST 
          | TYPE quatre_points LIST_IDF_CONST dollar FIN 
;

LIST_IDF_CONST: idf affectation VALEURE C separateur_var LIST_IDF_CONST       
                            {   
                                if(Declaration($1) == 0)  
                                    insererTYPE($1, sauvType, 1);                                    
                                else 
                                    printf("Erreur semantique : double declaration a la ligne %d \n", nb_ligne);
                            }
              | idf affectation VALEURE C  
                            {   
                                if(Declaration($1) == 0)  
                                    insererTYPE($1, sauvType, 1);                                    
                                else 
                                    printf("Erreur semantique : double declaration a la ligne %d \n", nb_ligne);
                            }
;
C: {
    if(strcmp(sauvType, comp) != 0)
    printf("Erreur semantique : incompatibilite des types a la ligne %d \n", nb_ligne);
}
;
VALEURE: ENTIER 
       | REAL 
       | string {strcpy(comp, "STRING");}
       | caractere {strcpy(comp, "CHAR");}
;
ENTIER: parenthese_o entier_s parenthese_f {sauvOpd = $2; strcpy(comp, "INTEGER");}
      | entier                             {sauvOpd = $1; strcpy(comp, "INTEGER");}
;
REAL: parenthese_o real_s parenthese_f {sauvOpd = $2; strcpy(comp, "REAL");}
    | real                             {sauvOpd = $1; strcpy(comp, "REAL");}
;

LIST_INST: INST FIN LIST_INST 
         | 
;
INST: AFFECTATION 
    | ENT 
    | SOR 
    | BOUCLE 
    | CONDITION 
    | 
;
AFFECTATION: M_G_AFF affectation M_D_AFF dollar FIN 
;
M_G_AFF: idf 
            {   
                if(Declaration($1) == 0)
                    printf("Erreur semantique : %s non declarer a la ligne %d \n", $1, nb_ligne); 
                else 
                {
                    if(estConst($1) == 1)
                        printf("Erreur semantique : on peut pas changer la valeur d'une consatante a la ligne %d \n", nb_ligne);
                }
            }
       | ELE_TAB
;
ELE_TAB: idf crochet_o entier crochet_f 
        {
            if(Declaration($1) == 0)
                printf("Erreur semantique : %s non declarer a la ligne %d \n", $1, nb_ligne);
            else
            {
                int j = 0;
                for(j = 0; j < t; j++)
                {
                    if(strcmp(sauvTTab[j].NomTab, $1) == 0)
                    {
                        if($3 > sauvTTab[j].TaiTab)
                            printf("Erreur semantique : Depassement de la taille du tableau %s a la ligne %d \n", $1, nb_ligne);
                    }
                }
            }
        }
       | idf crochet_o entier_s crochet_f
        {
            if(Declaration($1) == 0)
                printf("Erreur semantique : %s non declarer a la ligne %d \n", $1, nb_ligne);
            else
            {
                if($3 < 0)
                    printf("Erreur semantique : on peut pas avoir un indice < 0 a la ligne %d \n", nb_ligne);
                else
                {
                    int j = 0;
                    for(j = 0; j < t; j++)
                    {
                        if(strcmp(sauvTTab[j].NomTab, $1) == 0)
                        {
                            if($3 > sauvTTab[j].TaiTab)
                                printf("Erreur semantique : Depassement de la taille du tableau %s a la ligne %d \n", $1, nb_ligne);
                        }
                    }
                }
            }
        }
M_D_AFF: caractere
       | string 
       | EXP_ARITH {
                        if(nb_dec_PROCESS == 0)
                            printf("Erreur semantique : la bib PROCESS non importe \n");
                    }
;
EXP_ARITH: OPD A EXP_ARITH_2 
         | parenthese_o OPD A EXP_ARITH_2 parenthese_f
         | parenthese_o OPD A EXP_ARITH_2 parenthese_f EXP_ARITH_2
;
EXP_ARITH_2: OPT EXP_ARITH
           |    
;
A:  {   
        if(strcmp(sauvOpt, "/") == 0 && sauvOpd == 0) 
            printf("Erreur semantique : division sur 0 a la ligne %d \n", nb_ligne);
        strcpy(sauvOpt, "");
        sauvOpd = 1;
    }
;
OPD: ENTIER 
   | REAL 
   | idf    {
                if(Declaration($1) == 0)
                    printf("Erreur semantique : %s non declarer a la ligne %d \n", $1, nb_ligne); 
            }
   | ELE_TAB
;
OPT: addition       {strcpy(sauvOpt, $1);}
   | soustraction   {strcpy(sauvOpt, $1);} 
   | multiplication {strcpy(sauvOpt, $1);} 
   | division       {strcpy(sauvOpt, $1);}
;

ENT: mc_read parenthese_o string barre_v arobase idf parenthese_f dollar 
        {  
            if(Declaration($6) == 0)
                printf("Erreur semantique : %s non declarer a la ligne %d \n", $6, nb_ligne);
            else
            {
                char chain[100], sg;
                strcpy(chain, $3);
                int ln = strlen(chain), i, j = 0;
                for(i = 0 ; i < ln ; i++)
                {
                    if(chain[i] == '%' || chain[i] == ';' || chain[i] == '?' || chain[i] == '&')
                        {
                            j++;
                            sg = chain[i];
                        }
                    if(j > 1)
                        {
                            printf("Erreur semantique : plus d'un signe de formatage a la ligne %d \n", nb_ligne);
                            break;
                        }
                        
                }
                if(j == 1){
                    switch(sg)
                    {
                        case '%':{
                                    if(Type($6) != 'R')
                                        printf("Erreur semantique : signe de formatage incompatible a la ligne %d \n", nb_ligne);
                                }; break;
                        case ';':{
                                    if(Type($6) != 'I')
                                        printf("Erreur semantique : signe de formatage incompatible a la ligne %d \n", nb_ligne);
                                }; break;
                        case '?':{
                                    if(Type($6) != 'S')
                                        printf("Erreur semantique : signe de formatage incompatible a la ligne %d \n", nb_ligne);
                                }; break;
                        case '&':{
                                    if(Type($6) != 'C')
                                        printf("Erreur semantique : signe de formatage incompatible a la ligne %d \n", nb_ligne);
                                }; break;
                    }
                }
            }
        }
   | mc_read parenthese_o string barre_v arobase ELE_TAB parenthese_f dollar 
;
SOR: mc_write parenthese_o string barre_v LIST_IDF parenthese_f dollar 
;
LIST_IDF: idf separateur_var LIST_IDF                 
                {   
                    if(Declaration($1) == 0)
                        printf("Erreur semantique : %s non declarer a la ligne %d \n", $1, nb_ligne); 
                }
        | ELE_TAB separateur_var LIST_IDF
        | idf   {   
                    if(Declaration($1) == 0)
                        printf("Erreur semantique : %s non declarer a la ligne %d \n", $1, nb_ligne); 
                }
        | ELE_TAB 
;
CONDITION: mc_execut FIN LIST_INST IF ELSE mc_end_if FIN dollar
;

IF: mc_if parenthese_o COND parenthese_f FIN 
;

ELSE: mc_else FIN mc_execut FIN LIST_INST 
    | 
;

BOUCLE: mc_while parenthese_o COND parenthese_f FIN B_INST 
                    {
                        if(nb_dec_LOOP == 0)
                            printf("Erreur semantique : la bib LOOP non importe \n");
                    }                    
;

COND: M_D_AFF O_LOGIQUE M_D_AFF 
; 

B_INST: accolade_o FIN LIST_INST accolade_f 
;

O_LOGIQUE: mc_inf 
         | mc_sup 
         | mc_eg 
         | mc_infe 
         | mc_supe 
         | mc_diff 
; 

%%
main () 
{
    yyparse();
    afficher();
}
yywrap(){}

yyerror(char* msg)
{
    printf("Erreur syntaxique a la ligne %d \n", nb_ligne);
}
