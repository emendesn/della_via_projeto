#Include 'rwmake.ch' 
#Include 'TbiConn.ch'

User Function Act0081()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" 

_cQuery := "SELECT B1_COD FROM SB1010 WHERE B1_GRUPO = '0084' AND D_E_L_E_T_ <> '*'"
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TMP",.T.,.T.)
Do While !Eof()
	DbSelectArea("SB0")
	DbSetOrder(1)
	If DbSeek(xFilial("SB0")+TMP->B1_COD)
		RecLock("SB0",.F.)
		SB0->B0_PRV1 := 0.01
		MsUnlock()
	Endif
	DbSelectArea("TMP")
	DbSkip()
Enddo		
                                             
Return .T.
