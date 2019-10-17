#include "DellaVia.ch"

User Function DEDI005
	Private Titulo      := "EDI Vipal - Exportação de pedidos de compra"
	Private aSays       := {}
	Private aButtons    := {}
	Private aRegs       := {}
	Private cPerg       := "EDI005"

	If SM0->M0_CODIGO <> "03"
		msgbox("Esta rotina só pode ser executada na Durapol","EDI","STOP")
		Return  nil
	Endif

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Pedido             ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""   ,"","","","",""   ,"","","","",""   ,"","","","SC7","","","",""          })

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.T.)

	aAdd(aSays,"Esta rotina faz a exportação dos Pedidos de compra para a Vipal.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Export() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Export()
	Local cSql   := ""
	Local aEstru := {}

	aEstru := {}
	aAdd(aEstru,{"R1_ID"      ,"C",02,0})
	aAdd(aEstru,{"R1_PEDIDO"  ,"C",12,0})
	aAdd(aEstru,{"R1_CGC"     ,"C",19,0})
	aAdd(aEstru,{"R1_PEDRES"  ,"C",12,0})
	aAdd(aEstru,{"R1_EMISSAO" ,"C",08,0})
	aAdd(aEstru,{"R1_CONDPG"  ,"C",03,0})
	aAdd(aEstru,{"R1_DESCON1" ,"C",05,0})
	aAdd(aEstru,{"R1_DESCON2" ,"C",05,0})
	aAdd(aEstru,{"R1_TRANSP"  ,"C",12,0})
	aAdd(aEstru,{"R1_CIDCIF"  ,"C",25,0})
	aAdd(aEstru,{"R1_CONTATO" ,"C",25,0})
	aAdd(aEstru,{"R1_TRREDES" ,"C",12,0})
	aAdd(aEstru,{"R1_ESTAB"   ,"C",03,0})
	aAdd(aEstru,{"R1_DTPREVI" ,"C",08,0})

	cTmpR1 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cTmpR1,"TMPR1",.F.,.F.)
	IndRegua("TMPR1",cTmpR1,"R1_PEDIDO",,.t.,"Selecionando Registros...")


	aEstru := {}
	aAdd(aEstru,{"R7_ID"      ,"C",02,0})
	aAdd(aEstru,{"R7_PEDIDO"  ,"C",12,0})
	aAdd(aEstru,{"R7_ITEM"    ,"C",16,0})
	aAdd(aEstru,{"R7_QUANT"   ,"C",11,0})
	aAdd(aEstru,{"R7_AQUANT"  ,"C",11,0})
	aAdd(aEstru,{"R7_PESO"    ,"C",14,0})
	aAdd(aEstru,{"R7_PICMS"   ,"C",06,0})

	cTmpR7 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cTmpR7,"TMPR7",.F.,.F.)
	IndRegua("TMPR7",cTmpR7,"R7_PEDIDO",,.t.,"Selecionando Registros...")


	aEstru := {}
	aAdd(aEstru,{"LINHA"      ,"C",151,0})

	cTmpBf := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cTmpBf,"BUFFER",.F.,.F.)



	cSql := "SELECT C7_LOJA,C7_NUM,C7_EMISSAO,A5_CODPRF,C7_QUANT"
	cSql += " FROM "+RetSqlName("SC7")+" SC7"

	cSql += " LEFT JOIN "+RetSqlName("SA5")+" SA5"
	cSql += " ON   SA5.D_E_L_E_T_ = ''"
	cSql += " AND  A5_FILIAL = '01'"
	cSql += " AND  A5_FORNECE = C7_FORNECE"
	cSql += " AND  A5_LOJA = C7_LOJA"
	cSql += " AND  A5_PRODUTO = C7_PRODUTO"

	cSql += " WHERE SC7.D_E_L_E_T_ = ''"
	cSql += " AND   C7_FILIAL = '01'"
	cSql += " AND   C7_NUM = '"+mv_par01+"'"
	cSql += " AND   C7_FORNECE = '002707'"
	cSql += " AND   C7_ENCER = ''"
	cSql += " AND   C7_QUJE < C7_QUANT"
	cSql += " AND   C7_QTDACLA = 0"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	TcSetField("ARQ_SQL","C7_QUANT"  ,"N",14,2)

	ProcRegua(0)
	Do while !eof()
		incProc("Exportando ...")
		dbSelectArea("TMPR1")
		If RecLock("TMPR1",.T.)
			TMPR1->R1_ID      := "01"
			TMPR1->R1_PEDIDO  := ARQ_SQL->C7_NUM
			TMPR1->R1_CGC     := SM0->M0_CGC
			TMPR1->R1_EMISSAO := ARQ_SQL->(Substr(C7_EMISSAO,7,2)+Substr(C7_EMISSAO,5,2)+Substr(C7_EMISSAO,1,4))
			TMPR1->R1_ESTAB   := IIF(ARQ_SQL->C7_LOJA="01","5","2")
			MsUnLock()
		Endif

		dbSelectArea("ARQ_SQL")
		cNum := ARQ_SQL->C7_NUM
		Do While !eof() .and. ARQ_SQL->C7_NUM = cNum
			dbSelectArea("TMPR7")
			if RecLock("TMPR7",.T.)
				TMPR7->R7_ID     := "07"
				TMPR7->R7_PEDIDO := ARQ_SQL->C7_NUM
				TMPR7->R7_ITEM   := ARQ_SQL->A5_CODPRF
				TMPR7->R7_QUANT  := StrZero(ARQ_SQL->C7_QUANT*100,11)
				TMPR7->R7_AQUANT := StrZero(ARQ_SQL->C7_QUANT*100,11)
				TMPR7->R7_PESO   := Replicate("0",14)
				
				MsUnLock()
			Endif
			dbSelectArea("ARQ_SQL")
			dbSkip()
		Enddo
	Enddo
	dbCloseArea()
	
	dbSelectArea("TMPR1")
	dbGoTop()
	Do While !eof()
		cGrava := ""
		For k=1 to Len(dbStruct())
			cGrava += FieldGet(k)
		Next k

		dbSelectArea("BUFFER")
		If RecLock("BUFFER",.T.)
			LINHA := cGrava
			MsUnLock()
		Endif
		
		dbSelectArea("TMPR7")
		dbGoTop()
		dbSeek(TMPR1->R1_PEDIDO)
		
		Do While !eof() .and. TMPR7->R7_PEDIDO = TMPR1->R1_PEDIDO
			cGrava := ""
			For k=1 to Len(dbStruct())
				cGrava += FieldGet(k)
			Next k

			dbSelectArea("BUFFER")
			If RecLock("BUFFER",.T.)
				LINHA := cGrava
				MsUnLock()
			Endif

			dbSelectArea("TMPR7")
			dbSkip()
		Enddo
		dbSelectArea("TMPR1")
		dbSkip()
	Enddo
	dbSelectArea("TMPR1")
	dbCloseArea()

	dbSelectArea("TMPR7")
	dbCloseArea()

	dbSelectArea("BUFFER")
	dbGoTop()
	cFile := "\SYSTEM\IMPORT\VP"+mv_par01+".TXT"
	Copy To &cFile sdf
	dbCloseArea()
Return nil