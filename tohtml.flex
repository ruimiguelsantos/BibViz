%{
#include <string.h>
#include <ctype.h>

typedef struct listf {
  char categoria[50];
  char chave[200];
  struct listAutor *autores;
  char titulo[2000];
  struct listf *next;
} Listf;

typedef struct listAutor {
  char autor[1000];
  struct listAutor *next;
} ListAutor;


Listf* insereFinal(Listf *l, char* categoria, char* chave, ListAutor* autores, char *titulo );
Listf* limpaFinal(Listf *l);
char *lowerString(char *str);
ListAutor* insere(ListAutor* l, char* autor);
ListAutor* limpa(ListAutor *l);

Listf *final;
ListAutor *autores;
char bibtex[40];
%}

%x Categoria Chavecitacao Taga Tagt Autor Titulo
%option yylineno
%%
  char titulo[2000];
  char categoria[50];
  char chave[200];
  char autor[1000];
  BEGIN Categoria;

<Categoria>@[Pp][Rr][Ee][Aa][Mm][Bb][Ll][Ee].*			{ }

<Categoria>@[Ss][Tt][Rr][Ii][Nn][Gg].*                          { }

<Categoria>@[A-Za-z]+\{                                         {   
								    yytext[strlen(yytext)-1] = '\0';
                                                                    yytext = yytext + 1;
                                                                    strcpy(categoria,yytext);
    								    ListAutor *aux = (ListAutor*) malloc(sizeof(ListAutor));
								    autores = aux;
                                                                    BEGIN Chavecitacao;   }

<Categoria>.|\n                                                 {   }
 
<Chavecitacao>[^\,]+,                                           {   yytext[strlen(yytext)-1]='\0';
                                                                    strcpy(chave,yytext);
                                                                    BEGIN Taga;    }

<Taga>@[A-Za-z]+\{                                              {   strcpy(categoria,""); strcpy(chave,""); strcpy(autor,""); strcpy(titulo,"");
                                                                    BEGIN Categoria;   }

<Taga>[ \t*][Aa][Uu][Tt][Hh][Oo][Rr][ \t]*=[ \t]*(\"|\{)        {   BEGIN Autor;   }

<Taga>.|\n                                                      {    }

<Tagt>@[A-Za-z]+\{                                              {   strcpy(categoria,"");strcpy(chave,"");strcpy(autor,"");strcpy(titulo,"");
                                                                    BEGIN Categoria;   }

<Tagt>[ \t*][Tt][Ii][Tt][Ll][Ee][ \t]*=[ \t]*(\"|\{)            {   BEGIN Titulo;   }

<Tagt>.|\n                                                      {    }

<Autor>(\"|\})                                                  {   autores = insere(autores, autor); strcpy(autor,"");
								    BEGIN Tagt;   }
 
<Autor>and                                                      {   autores = insere(autores, autor); strcpy(autor,"");   }

<Autor>[A-Za-zàáâãäåçèéêëìíîïðòóôõöùúûüýÿ\.]+                   {   strcat(autor," "); strcat(autor, yytext);    }

<Autor>.|\n                                                     {    }

<Titulo>(\"|\})(\n|\,)                                          {   final = insereFinal(final, lowerString(categoria), chave, autores, titulo+1);
                                                                    strcpy(categoria,"");strcpy(chave,"");strcpy(autor,"");strcpy(titulo,"");
                                                                    BEGIN Categoria;   }

<Titulo>(\"|\})                                                 {   strcat(titulo, yytext);   }

<Titulo>[^\"\}]+                                                {   strcat(titulo, " "); 
                                                                    strcat(titulo, yytext);   }

.|\n                                                            {    }

%%

char* lowerString(char *string) {
   char* cursor = string;
   while(*cursor != '\0') {
        *cursor = tolower(*cursor);
        cursor++;
   }
   
   return string;
}

Listf* insereFinal(Listf *l, char* categoria, char* chave, ListAutor* autores , char *titulo) {
    Listf *tmp = l;
    Listf *aux = (Listf*) malloc(sizeof(Listf));
    aux -> autores = autores;
    strcpy(aux -> categoria,categoria);
    strcpy(aux -> chave,chave);
    strcpy(aux -> titulo,titulo);
    aux->next = tmp;
    return aux;
}

void printListf(Listf *l){
    printf("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n");
    printf("<html xmlns=\"http://www.w3.org/1999/xhtml\">\n");
    printf("<head>\n");
    printf("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n");
    printf("<title>Bibtex Source: %s</title>\n",bibtex);
    printf("<link href=\"style.css\" type=\"text/css\" rel=\"stylesheet\">\n");
    printf("</style>\n");
    printf("</head>\n");
    printf("<body>");
    printf("\n");
    printf("<table id=\"hor-minimalist-b\" summary=\"Bibtex summary\">\n");
    printf("\t<thead>\n");
    printf("\t\t<tr>\n");
    printf("\t\t\t<th scope=\"col\">Categoria</th>\n");
    printf("\t\t\t<th scope=\"col\">Chave</th>\n");
    printf("\t\t\t<th scope=\"col\">Autor</th>\n");
    printf("\t\t\t<th scope=\"col\">Titulo</th>\n");
    printf("\t\t</tr>\n");
    printf("\t</thead>\n");
    printf("\t<tbody>\n");
    while(l != NULL){
        printf("\t<tr>\n");
        printf("\t\t<td>%s</td><td>%s</td><td>",l->categoria,l->chave);
	while(l -> autores != NULL) {
		printf("<a href=\"http://localhost/autorGraph.php?autor=%s&bib=%s\">%s</a>&nbsp;&nbsp;&nbsp;",l->autores->autor+1,bibtex,l->autores->autor+1);
		l -> autores = l -> autores -> next;
	}
	printf("</td><td>%s</td>\n",l->titulo);
        l = l -> next;
        printf("\t</tr>\n");
    }
    printf("\t</tbody>\n");
    printf("</table>\n");
    printf("</body>\n</html>\n");
}


//-----------------------------------------

ListAutor* insere(ListAutor *l, char* new) {

	ListAutor *aux = (ListAutor*) malloc(sizeof(ListAutor));

  	strcpy(aux -> autor,new);

        	aux -> next = l;
     
      return aux;
}

ListAutor* limpa(ListAutor *l) {
	    
	ListAutor *temp;
		        
	while(l != NULL) {
		temp = l;
		l = l -> next;
		free(temp);
	}   
	
	return l;

}


//-----------------------------------------

int yywrap(){
    return 1;
}

int main(int argc, char *argv[]){
    if(argc!=2) {
	    printf("[Usage] %s filename.bib\n",argv[0]);
	    return 1;
    }
    strcpy(bibtex,argv[1]);
    yylex();
    printListf(final);

    return 0;
}
