#Include 'rwmake.ch'

User Function LJ7030(_aArray)

If ParamIxb[1] = 2
	P_AltTes(.T.)
Endif	

Return .T.

/*
LJ7030 ( < Array > ) --> L�gico

Par�metros

Argumento
 Tipo
 Descri��o
 
Array 
 Array
 Array contendo:
[1] 1 - Indica que est� sendo chamado da LinOk;
2 - Indica que est� sendo chamado da TudoOk
 


Retorno

Tipo
 Descri��o
 
L�gico
 Valida (True) ou invalida (False) a sa�da da linha ou da getdados.
 


Descri��o


Ponto de entrada chamado na Linok e na TudoOk na getdados da Venda Assistida.

*/