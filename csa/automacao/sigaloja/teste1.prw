#include "rwmake.ch"
#INCLUDE "TBICONN.CH"
User Function BANCOT()
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SZ8"
	for n:= 1 to 53
		dbUseArea(.T.,, "SZ8010","TRB_TMP", .f.,.f.)
		dbselectArea("TRB_TMP")
		dbGoTop()
		Do While !eof()
			RecLock("TRB_TMP",.F.)
			TRB_TMP->Z8_FILIAL:= STRZERO(N,2)
			msUnlock()
			dbSkip()
		Enddo
		dbSelectArea("TRB_TMP")
		dbCloseArea() 
		dbSelectArea("SZ8")
		Append From SZ8010
	NEXT
RETURN
	

