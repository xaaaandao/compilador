%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdarg.h>
	#include <string.h>
	#include "syntax-tree.h"

	/* Protótipos */
	int yylex(void);
	void yyerror(char *s);
	extern FILE *yyin;
	extern FILE *yyout;
%}

%union	{
	char pgm[100];
	char simbolo[3];
	char tipo[10];
	char identificador[3276];	
	char reservada[3276];
	char comentario[3276];
};
%start programa

%token <pgm> SE ENTAO SENAO FIM REPITA RETORNA ATE LEIA ESCREVA TIPOINTEIRO TIPOFLUTUANTE TIPOVOID IDENTIFICADOR NUMEROINTEIRO NUMEROFLUTUANTE EXPONENCIAL COMENTARIO IGUAL DOISPONTOS ATRIBUICAO MENOR MENORIGUAL MAIOR MAIORIGUAL DIFERENTE ABREPARENTESES FECHAPARENTESES ABRECHAVE FECHACHAVE VIRGULA ADICAO SUBTRACAO MULTIPLICACAO DIVISAO ABRECOLCHETE FECHACOLCHETE END_OF_FILE

%type <pgm> programa lista_declaracoes declaracao comentario declaracao_funcao funcao_tipada funcao_sem_tipo declaracao_variavel tipo lista_statements

%% 
programa:
	lista_declaracoes;

lista_declaracoes:
	/* empty */
	declaracao
	| lista_declaracoes declaracao;

declaracao:
	/* empty */
	comentario
	| declaracao_funcao
	| declaracao_variavel;

comentario: COMENTARIO { printf("comentario\n"); strcpy($$, $1); };

declaracao_funcao:
	funcao_tipada
	| funcao_sem_tipo;

funcao_tipada:
	tipo IDENTIFICADOR ABREPARENTESES lista_parametros FECHAPARENTESES lista_statements FIM { printf("funcao com tipo\n"); };

funcao_sem_tipo:
	IDENTIFICADOR ABREPARENTESES lista_parametros FECHAPARENTESES FIM { printf("funcao sem tipo\n"); };

declaracao_variavel:
	tipo DOISPONTOS lista_variaveis;

lista_variaveis :
	variavel
	| lista_variaveis VIRGULA variavel;

variavel:
	IDENTIFICADOR { printf("variavel\n"); 	}
	| IDENTIFICADOR ABRECOLCHETE FECHACOLCHETE { printf ("variavel vetor\n"); }
	| IDENTIFICADOR ABRECOLCHETE FECHACOLCHETE ABRECOLCHETE FECHACOLCHETE { printf ("variavel matriz\n"); };

tipo:
	TIPOINTEIRO { strcpy($$,$1); }
	| TIPOFLUTUANTE { strcpy($$,$1); };

lista_parametros:
	parametro
	| lista_parametros VIRGULA parametro;

parametro:
	tipo DOISPONTOS IDENTIFICADOR { printf("parâmetro variavel\n"); }
	| tipo DOISPONTOS IDENTIFICADOR ABRECOLCHETE FECHACOLCHETE { printf("parametro vetor\n"); }
	| tipo DOISPONTOS IDENTIFICADOR ABRECOLCHETE FECHACOLCHETE ABRECOLCHETE FECHACOLCHETE { printf("parametro da matriz\n");};

lista_statements:
	declaracao_variavel
	| lista_statements declaracao_variavel;


%%
void yyerror(char *s) {
	fprintf(stdout, "%s\n", s);
}

int main(int argc, char *argv[]){
	/*
		-> precisar ter uma expressão para o comentário?
		-> como fazer com a expressão vazio?
	*/
	yyin = fopen(argv[1], "r");
	yyparse();	
	fclose(yyin);
	return 0;
}

