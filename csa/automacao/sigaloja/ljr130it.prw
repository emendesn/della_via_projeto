#Include 'tbiconn.ch'
#Include 'rwmake.ch'

User Function Ljr130IT()   
Local _aArea	:= GetArea()

If !Empty(SD2->D2_CODISS) 
	DbSelectArea("SD2")
	RecLock("SD2",.F.)
	SD2->D2_CODISS 	:= " "
	MsUnlock()
Endif

RestArea(_aArea)
Return .T.	                   

User Function ZeraCodIss()
Local cSql	:= ""

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SF2","SD2"		//Prepara Ambiente para teste

cSql	:= "UPDATE SD2010 "
cSql	+= " SET D2_CODISS = '      ' WHERE"
cSql	+= " R_E_C_N_O_ IN (SELECT D2.R_E_C_N_O_ FROM SF2010 F2, SD2010 D2 WHERE F2.D_E_L_E_T_ <> '*' AND "
cSql	+= " D2.D_E_L_E_T_ <> '*' AND D2_DOC = F2_DOC AND F2_NFCUPOM <> '       ' AND F2_SERIE = 'UN' AND D2_CODISS <> ' ')"
MemoWrite("ZeraCodIss.SQL", cSQL)
nSQL := tcSqlExec(cSQL)          

Return .T.


