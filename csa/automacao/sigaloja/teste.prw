#include "rwmake.ch"
#INCLUDE "TBICONN.CH"
User Function estacao()
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SLG"
dbSelectArea("SLG")
	for n:= 2 to 42
		Append From SLGAPP 
		RecLock("SLG",.F.)
		SLG->LG_CODIGO	:= STRZERO(N,3)
		SLG->LG_SERIE	:= STRZERO(N,2)+"A"   
		SLG->LG_NOME	:= Posicione("SM0",1,"01"+STRZERO(N,2),"M0_NOME")
		MSuNLOCK()
	NEXT
RETURN
	

