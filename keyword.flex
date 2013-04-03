%{
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct lista {
        char key[200];
        struct lista *next;
}Lista;

Lista* insere(Lista *l, char* new);
int printCombs(Lista *l);
Lista* limpa(Lista *l);        


%}

%x Keyw Normal
%option yylineno
%%
        /*FILE *fp;*/
        Lista* lst = NULL;
        char key[200];
        BEGIN Normal;

<Keyw>[^\"\}\,\t\;]+                                    {   if(yytext[0]==' ')
                                                                  strcpy(key, yytext+1);
                                                              else
                                                                  strcpy(key, yytext);
                                                              lst = insere(lst, key);   }
<Keyw>(\"|\})                                             {   printCombs(lst);
                                                              lst = limpa(lst);
                                                              BEGIN Normal;   }
<Keyw>.|\n                                                { }//fprintf(stderr,"%d: Erro - caracter invalido \'%c\'",yylineno,yytext[0]); 

<Normal>[ \t]*keyword(s)?[ \t]*=[ \t]*(\"|\{)             { BEGIN Keyw; }

<Normal>.|\n                                              { }//fprintf(stderr,"%d: Erro - caracter invalido \'%c\'",yylineno,yytext[0]); 

%%


Lista* insere(Lista *l, char* new) {
        
        Lista *aux = (Lista*) malloc(sizeof(Lista));

        strcpy(aux -> key,new);

                aux -> next = l;
        
        return aux;

}


int printCombs(Lista *l) {
        if(l==NULL) return 0;
        else {
                Lista *aux = l;
                while(aux -> next != NULL) {
                        l = aux -> next;
                        while(l!=NULL) {
                                if(strcmp(aux->key,l->key)<0)
                                        printf("\"%s\" -- \"%s\" ;\n",aux->key,l->key);
                                else
                                        printf("\"%s\" -- \"%s\" ;\n",l->key,aux->key);
                                l = l -> next;
                        }
                        aux = aux -> next;
                }
        }
        return 1;
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


int yywrap(){
        return 1;
}


int main(){
        
        printf("graph g {\n");
        yylex();
        printf("}\n");
        return 0;
}

