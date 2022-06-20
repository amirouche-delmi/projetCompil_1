    /* 
        Nom                 Prenom          Matricule           Section     Groupe
        DELMI               Amirouche       181831017580           c           3
        BELKACEM NACER      Yacine          171731098194           c           1
    */
//1-decalration
 
	typedef struct
	{
		char NomEntite[100];
		char CodeEntite[20];
		char TypeEntite[20];
		int EstConst;
	} TypeTS;

	//initiation d'un tableau qui va contenir les elements de la table de symbole
	TypeTS ts[10000];

	// un compteur global pour la table de symbole
	int CpTabSym=0;
		
//2- definir une fonction recherche
	int recherche(char entite[])
	{
		int i=0;
		while(i<CpTabSym)
		{
			if (strcmp(entite,ts[i].NomEntite)==0) return i;
			i++;
		}
		return -1;
	}
		
//3-definir la fonction inserer
	void inserer(char entite[], char code[])
	{
		if ( recherche(entite)==-1)
		{
			strcpy(ts[CpTabSym].NomEntite,entite); 
			strcpy(ts[CpTabSym].CodeEntite,code);
			CpTabSym++;
		}
	}
//4-definir la fonction afficher
	void afficher ()
	{
		printf("\n/*************** Table des symboles ******************/\n");
		printf("__________________________________________________________________________\n");
		printf(" |            NomEntite    	 |  CodeEntite | TyepEntite   | EstConst |\n");
		printf("__________________________________________________________________________\n");
		int i=0;
		while(i<CpTabSym)
		{
			if(ts[i].EstConst == 1)
				printf(" |%30s |%12s | %12s | %8s |\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite, "CONST");
			else
				printf(" |%30s |%12s | %12s | %8s |\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite, "");		
			i++;
		}
	}
	
//5-definir une focntion pour inserer le type
	void insererTYPE(char entite[], char type[], int cst)
	{
    	int pos;
		pos=recherche(entite);
		if(pos!=-1)
			strcpy(ts[pos].TypeEntite,type);
			ts[pos].EstConst = cst; 
	}

//6- definir une focntion qui detecte la declaration d'une constante ou variable
	int Declaration(char entite[])
	{
		int pos;
		pos=recherche(entite);
		if(strcmp(ts[pos].TypeEntite,"")==0) 
			return 0;
		else 
			return 1;
	}

//6- definir une focntion qui detecte c'est une variable est une  constante
	int estConst(char entite[])
	{
		int pos;
		pos=recherche(entite); 
		return ts[pos].EstConst;
	}

//6- definir une focntion qui retourne le type d'un idf
	char Type(char entite[])
	{
		int pos;
		pos=recherche(entite);
		if(strcmp(ts[pos].TypeEntite, "INTEGER") == 0)
			return 'I';
			else
				if(strcmp(ts[pos].TypeEntite, "REAL") == 0)
					return 'R';
				else
					if(strcmp(ts[pos].TypeEntite, "STRING") == 0)
						return 'S';
					else
						if(strcmp(ts[pos].TypeEntite, "CHAR") == 0)
							return 'C';
	}
