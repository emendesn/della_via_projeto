#INCLUDE "TBICONN.CH"

user function SL2DUP2
Local cQuery	:= ""

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "loja" TABLES "SL2"		//Prepara Ambiente para teste

cQuery := "Select L2.L2_FILIAL, L2.L2_NUM, L2.L2_PRODUTO, L2.L2_ITEM,TMP.L2_FILIAL T_FILIAL," 
cQuery += " TMP.L2_NUM T_NUM, TMP.L2_PRODUTO T_PRODUTO, TMP.L2_ITEM T_ITEM, TMP.L2_EMISSAO, TMP.D_E_L_E_T_ from SL2010 as L2"
cQuery += " RIGHT OUTER JOIN TEMPSL2 AS TMP ON L2.L2_FILIAL = TMP.L2_FILIAL AND L2.L2_NUM = TMP.L2_NUM AND L2.L2_PRODUTO = TMP.L2_PRODUTO AND L2.L2_ITEM = TMP.L2_ITEM AND L2.D_E_L_E_T_ <> '*'"
cQuery += " WHERE L2.L2_NUM IS NULL AND TMP.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY TMP.L2_FILIAL, TMP.L2_NUM, TMP.L2_ITEM, TMP.L2_EMISSAO"

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"qSQL", .F., .T.)

dbUseArea(.T.,, "SL2X","TRB_TMP", .f.,.f.)

//Indexa Arquivo Temporario
cIndex		:= CriaTrab(nil,.f.)
cChave		:= "L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO"
IndRegua("TRB_TMP",cIndex,cChave,,,"Selecionando Registros...")  //"Selecionando Registros..."

aStruSL2	:= TRB_TMP->(DbStruct())

dbSelectArea("qSQL")
dbGoTop()

Do While .Not. Eof()
	If TRB_TMP->(dbSeek(qSQL->T_FILIAL + qSQL->T_NUM + qSQL->T_ITEM + qSQL->T_PRODUTO ))
		dbSelectArea("SL2")
//		Do While TRB_TMP->(!EOF()) .AND. TRB_TMP->L2_FILIAL = qSQL->L1_FILIAL .AND. TRB_TMP->L2_NUM = qSQL->L1_NUM 
			RecLock("SL2",.T.)
			For i:= 1 to len(aStruSL2)
				SL2->&(aStruSL2[i][1]):= TRB_TMP->&(aStruSL2[i][1])
			Next
			msUnlock()
//			TRB_TMP->(dbSkip())
//		EndDo
		dbSelectArea("qSQL")

	EndIf
	dbSkip()				
EndDo
