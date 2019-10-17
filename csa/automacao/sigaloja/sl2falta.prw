#INCLUDE "TBICONN.CH"


user function SL2DUP
Local cQuery	:= ""

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "loja" TABLES "SL2"		//Prepara Ambiente para teste

cQuery := "Select L1.L1_FILIAL, L1.L1_NUM, L2.L2_FILIAL, L2.L2_NUM ,L1.L1_EMISSAO, L1.D_E_L_E_T_ from SL1010 as L1"
cQuery += " LEFT OUTER JOIN SL2010 AS L2 ON L1.L1_FILIAL = L2.L2_FILIAL AND L1.L1_NUM = L2.L2_NUM"
cQuery += " WHERE L2.L2_NUM IS NULL"
cQuery += " ORDER BY L1.L1_FILIAL, L1.L1_EMISSAO"

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"qSQL", .F., .T.)

dbUseArea(.T.,, "SL2X","TRB_TMP", .f.,.f.)

//Indexa Arquivo Temporario
cIndex		:= CriaTrab(nil,.f.)
cChave		:= "L2_FILIAL+L2_NUM"
IndRegua("TRB_TMP",cIndex,cChave,,,"Selecionando Registros...")  //"Selecionando Registros..."

aStruSL2	:= TRB_TMP->(DbStruct())

dbSelectArea("qSQL")
dbGoTop()

Do While .Not. Eof()
	If TRB_TMP->(dbSeek(qSQL->L1_FILIAL + qSQL->L1_NUM))
		dbSelectArea("SL2")
		RecLock("SL2",.T.)
		For i:= 1 to len(aStruSL2)
			SL2->&aStruSL2[i][1]:= TRB_TMP->&aStruSL2[i][1]
		Next
		msUnlock()
		dbSelectArea("qSQL")
	EndIf
	dbSkip()				
EndDo


