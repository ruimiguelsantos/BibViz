%{
#include <string.h>
#include <ctype.h>

typedef struct listf {
	char key[200];
	int ocorrencia;
	struct listf *next;
} Listf;

Listf* insereFinal(Listf *l, char* new); 
Listf* limpaFinal(Listf *l); 
char *lowerString(char *str);

Listf *final;
%}

%option yylineno
%%

@[A-Za-z]+\{				{
						yytext[strlen(yytext)-1]='\0';
						yytext = yytext + 1;
						final = insereFinal(final,lowerString(yytext));
					}
.|\n					{ }

%%
char* lowerString(char *string) {
	char* cursor = string;
	while(*cursor != '\0') {
		*cursor = tolower(*cursor);
		cursor++;
	}
	
	return string;
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

void printListf(Listf *l){
	printf("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n");
	printf("<html xmlns=\"http://www.w3.org/1999/xhtml\">\n");
	printf("<head>\n");
	printf("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n");
	printf("<title>Bibtex Source</title>\n");
	printf("<link href=\"style.css\" type=\"text/css\" rel=\"stylesheet\">\n");
	printf("</style>\n");
	printf("</head>\n");
	printf("<body>");
	printf("\n");
	printf("<table id=\"hor-minimalist-b\" summary=\"Bibtex summary\">\n");
	printf("\t<thead>\n");
	printf("\t\t<tr>\n");
	printf("\t\t\t<th scope=\"col\">Categoria</th>\n");
	printf("\t\t\t<th scope=\"col\"># (Num)</th>\n");
	printf("\t\t</tr>\n");
	printf("\t</thead>\n");
	printf("\t<tbody>\n");
	while(l != NULL){
		printf("\t<tr>\n");
		printf("\t\t<td>%s</td><td>%d</td>",l->key,l->ocorrencia);
		l = l -> next;
		printf("</tr>");
	}
	printf("\t</tbody>\n");
	printf("</table>\n");
	printf("</body>\n</html>\n");
}

int yywrap(){
	return 1;
}

int main(int argc, char *argv[]){
	yylex();
	printListf(final);

    return 0;
}
