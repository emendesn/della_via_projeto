#include "rwmake.ch"

User Function AcertaSD1()

Processa({|| Acerta()},"Acertando SD1")

Return
                        


Static Function Acerta()

IF Select("TRB") > 0
	TRB->(dbCloseArea())
EndIF

cQry := " SELECT  D1_VALIMP5, D1_VALIMP6, D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM "
cQry += " FROM "+RetSqlName("SD1") +" D1, "+RetSqlName("SB1") +" B1 "
cQry += " WHERE D1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND D1_COD = B1_COD "
cQry += " 	AND D1_EMISSAO >= '20051201' AND D1_EMISSAO <= '20060111' AND B1_PCOFINS = 0 "
cQry += " 	AND D1_VALIMP5 <> 0 AND D1_CONTA NOT LIKE '11301%' AND D1_TES = '005' "
cQry += " ORDER BY D1_FILIAL, D1_DOC, D1_SERIE,D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM "

//AND D1_FILIAL = '11' AND D1_DOC = '061919'

cQry := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRB",.F.,.T.)

ProcRegua(RecCount())
dbGoTop()

While ! Eof()

	IncProc()
	dbSelectArea("SD1")    
	dbSetOrder(1)
	IF dbSeek(TRB->D1_FILIAL+TRB->D1_DOC+TRB->D1_SERIE+TRB->D1_FORNECE+TRB->D1_LOJA+TRB->D1_COD+TRB->D1_ITEM)
		RecLock("SD1",.F.)
			SD1->D1_VALIMP5 := 0
			SD1->D1_VALIMP6 := 0
		MsUnlock()
	EndIF
    cNFil   := TRB->D1_FILIAL
	cDoc    := TRB->D1_DOC + TRB->D1_SERIE + TRB->D1_FORNECE + TRB->D1_LOJA
	
	dbSelectArea("TRB")
	dbSkip()
	
	
	IF cDoc <> TRB->D1_DOC + TRB->D1_SERIE + TRB->D1_FORNECE + TRB->D1_LOJA
		nValImp5 :=0
		nValImp6 :=0
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(cNFil + cDoc )
		lCalc := .F.
		While !Eof() .and. cNFil == SD1->D1_FILIAL .and. SD1->D1_DOC == Substr(cDoc,1,6)
			lCalc := .T.
			nValImp5 += SD1->D1_VALIMP5
			nValImp6 += SD1->D1_VALIMP6
			dbSelectArea("SD1")
			dbSkip()
		EndDo
		IF lCalc
			dbSelectArea("SF1")
			dbSetOrder(1)
			IF dbSeek(cNFil + cDoc )
			
				RecLock("SF1")
					SF1->F1_VALIMP5 := nValImp5
					SF1->F1_VALIMP6 := nValImp6
				MsUnlock()
			EndIF
		EndIF
		dbSelectArea("TRB")		
	EndIF		
Enddo
      
Alert("Fim do processamento")

Return