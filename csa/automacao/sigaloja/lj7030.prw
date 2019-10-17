#Include 'rwmake.ch'

User Function LJ7030(_aArray)

If ParamIxb[1] = 2
	P_AltTes(.T.)
Endif	

Return .T.

/*
LJ7030 ( < Array > ) --> Lógico

Parâmetros

Argumento
 Tipo
 Descrição
 
Array 
 Array
 Array contendo:
[1] 1 - Indica que está sendo chamado da LinOk;
2 - Indica que está sendo chamado da TudoOk
 


Retorno

Tipo
 Descrição
 
Lógico
 Valida (True) ou invalida (False) a saída da linha ou da getdados.
 


Descrição


Ponto de entrada chamado na Linok e na TudoOk na getdados da Venda Assistida.

*/