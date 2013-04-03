%{
#include <string.h>

typedef struct lista {
        char key[200];
        struct lista *next;
} Lista;

typedef struct listf {
        char key[200];
        int ocorrencia;
        struct listf *next;
} Listf;

Listf* insereFinal(Listf *l, char* new); 
Listf* limpaFinal(Listf *l); 
Lista* insere(Lista *l, char* new); 
Lista* limpa(Lista *l); 
void printLista(Lista *l);

char argName[200];
Lista *prov;
Listf *final;

%}

%x Author Normal
%option yylineno
%%
        int flag = 0;
        char nome[200];
        BEGIN Normal;

<Author>(\"|\})                                                     {   if(strcmp(nome+1,argName) == 0){ flag = 1; }
                                                                        prov = insere(prov, nome+1);
                                                                        if(flag == 1){
                                                                            while(prov != NULL){
                                                                                    if(strcmp(prov->key,argName)!=0){
                                                                                    final = insereFinal(final, prov->key);
                                                                                    }
                                                                                    prov = prov -> next;
                                                                            }
                                                                        }
                                                                        flag=0;
                                                                        prov = limpa(prov);
                                                                        strcpy(nome, ""); BEGIN Normal; 
                                                                    }
<Author>and                                                         {   if(strcmp(nome+1,argName) == 0){ flag = 1;}
                                                                        prov = insere(prov, nome+1);
                                                                        strcpy(nome,""); 
                                                                    }
<Author>[A-Za-zàáâãäåçèéêëìíîïðòóôõöùúûüýÿ\.]+                      {   strcat(nome," "); strcat(nome, yytext);   }
<Author>.|\n                                                        { } 

<Normal>[ \t]*author(s)?[ \t]*=[ \t]*(\"|\{)                        {   BEGIN Author;   }
<Normal>.|\n                                                        { } 

%%

int yywrap(){
        return 1;
}

Listf* insereFinal(Listf *l, char* new) {
        Listf *tmp = l;
        Listf *aux;
        int flaga = 0;
        while(flaga == 0 && l != NULL){
                if(strcmp(l->key,new)==0){
                        flaga = 1;
                        l->ocorrencia++;
                }
                l = l->next;
        }

        if(flaga == 0){
                aux = (Listf*) malloc(sizeof(Listf));
                strcpy(aux -> key,new);
                aux->next = tmp;
                aux->ocorrencia = 1;
        }else{
                aux = tmp;
        }
        return aux;
}

Listf* limpaFinal(Listf *l) {
        Listf *temp;
        
        while(l != NULL) {
                temp = l;
                l = l -> next;
                free(temp);
        }

        return l;
}

Lista* insere(Lista *l, char* new) {
        Lista *aux = (Lista*) malloc(sizeof(Lista));
        strcpy(aux -> key,new);
        aux->next = l;
        return aux;
}

Lista* limpa(Lista *l) {
        Lista *temp;
        
        while(l != NULL) {
                temp = l;
                l = l -> next;
                free(temp);
        }

        return l;
}

void printListf(Listf *l){
        printf("graph \"%s\"{\n",argName);
        printf("\t\"%s\"[style=filled,color=red];",argName);
        while(l != NULL){
                printf("\t\"%s\" -- \"%s\";\n\t\"%s\"[width=%d][height=%d];\n",l->key,argName,l->key,l->ocorrencia,l->ocorrencia);
                l = l -> next;
        }
        printf("}\n\n");
}

void printLista(Lista *l){
        Lista *temp;

        while(l != NULL){
                temp = l;
                l = l -> next;
                printf("\"%s\"\n",temp->key);
        }
}

int main(int argc, char *argv[]){
        if (argc > 1){
                strcpy(argName,argv[1]);
                prov = (Lista*) malloc(sizeof(Lista));
                yylex();
                printListf(final);
        }else{
                printf("\nEste programa usa um nome como argumento.\ne.g. author \"John Smith\"\n\n");
                return 1;
        }

    return 0;
}
