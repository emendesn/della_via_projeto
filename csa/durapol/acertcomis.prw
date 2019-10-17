#include "rwmake.ch"

// 06/02/06 - Atualizar o campo vendedor no SE1 - Denis Tofoli
// 			- O Arquivo sem as alterações é o ACERTCOMIS_VELHO.PRW

User Function AcertComis
	Local   _aArea   := GetArea()
	Private cPerg    := "ACTCMS"
	Private aRegs    := {}
	Private Titulo   := "Ajusta Comissoes"
	Private aSays    := {}
	Private aButtons := {}

	aAdd(aRegs,{cPerg,"01","Da  Data ?"          ,"","","mv_ch1","D", 8,0,0,"G","","mv_par01",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate Data ?"          ,"","","mv_ch2","D", 8,0,0,"G","","mv_par02",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })

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
	Pergunte(cPerg,.F.)

	aAdd(aSays,"Esta rotina ajustas as comissões e os vendedores em todas as tabelas relacionadas as  ")
	aAdd(aSays,"vendas - Durapol")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Ajuste()},"Atualizando ...")  }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                        }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                               }})

	FormBatch(Titulo,aSays,aButtons)

	RestArea(_aArea)
Return

Static Function Ajuste
	Local _nComis3 :=0
	Local _nComis4 :=0
	Local _nComis5 :=0
	Local cVend3   := ""
	Local cVend4   := ""
	Local cVend5   := ""
	Local _cNota   := ""
	Local _cSerie  := ""

	FechaBatch()

	dbSelectArea("SC5")
	ProcRegua(SC5->(LastRec()))
	dbSetOrder(1)
	dbGotop()

	While !Eof()
		IncProc("Atualizando pedidos...Atual = "+SC5->C5_NUM)
		If C5_EMISSAO < mv_par01 .or. C5_EMISSAO > mv_par02
			dbSkip()
			Loop
		Endif

		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

		dbSelectArea("SC5")	
		if Reclock("SC5",.F.)
			IF Empty(SC5->C5_VEND3)
				SC5->C5_VEND3 := SA1->A1_VEND3
			Endif
			IF Empty(SC5->C5_VEND4)
				SC5->C5_VEND4 := SA1->A1_VEND4
			EndIF
			IF Empty(SC5->C5_VEND5)
				SC5->C5_VEND5 := SA1->A1_VEND5
			Endif
			MsUnlock()
		EndIF

		//Recupero os %
		_cNota  := SC5->C5_NOTA
		_cSerie := SC5->C5_SERIE
		cVend3  := SC5->C5_VEND3
		cVend4  := SC5->C5_VEND4
		cVend5  := SC5->C5_VEND5
	
		SA3->(dbSetOrder(1))
		SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND3))
		_nComis3 := SA3->A3_COMIS

		SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND4))
		_nComis4 := SA3->A3_COMIS

		SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND5))
		_nComis5 := SA3->A3_COMIS

		//Atualiza SC5
		dbSelectArea("SC5")	
		If Reclock("SC5",.F.)
			SC5->C5_COMIS3 := _nComis3
			SC5->C5_COMIS4 := _nComis4
			SC5->C5_COMIS5 := _nComis5
			MsUnLock()
		Endif
		
		//Atualiza sc6
		SC6->(dbSetOrder(4))
		SC6->(dbSeek(xFilial("SC6")+_cNota+_cSerie))
		While !Eof() .and. xFilial("SC6")+_cNota+_cSerie == SC6->C6_FILIAL+SC6->C6_NOTA+SC6->C6_SERIE
			if Reclock("SC6",.F.)
				SC6->C6_COMIS3 := _nComis3
				SC6->C6_COMIS4 := _nComis4
				SC6->C6_COMIS5 := _nComis5
				MsUnlock()
			Endif
			dbSkip()
		EndDo

		//Atualiza SF2
		dbSelectArea("SF2")
		dbSetOrder(1)
		IF dbSeek(xFilial("SF2")+_cNota+_cSerie)
			if Reclock("SF2",.F.)
				SF2->F2_VEND3 := cVend3
				SF2->F2_VEND4 := cVend4
				SF2->F2_VEND5 := cVend5
				MsUnlock()
			Endif
		EndIF	
	
		//Atualiza SD2
		SD2->(dbSetOrder(3))
		SD2->(dbSeek(xFilial("SD2")+_cNota+_cSerie))
		While !Eof().and. xFilial("SD2")+_cNota+_cSerie == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
			IF Reclock("SD2",.F.)
				SD2->D2_COMIS3 := _nComis3
				SD2->D2_COMIS4 := _nComis4
				SD2->D2_COMIS5 := _nComis5
				MsUnlock()
			Endif
			dbSelectArea("SD2")
			dbSkip()
		EndDo


		// Alterado por Denis Tofoli
		cSql := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA"
		cSql += " FROM "+RetSqlName("SE1")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   E1_PEDIDO = '"+SC5->C5_NUM+"'"
		cSql += " ORDER BY E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA"

		cSql := ChangeQuery(cSql)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SE1", .T., .T.)

		dbSelectArea("ARQ_SE1")
		dbGoTop()

		Do While !eof()
			//Atualiza SE1
			dbSelectArea("SE1")
			dbSetOrder(1)
			dbSeek(ARQ_SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA))
			IF Found()
				IF Reclock("SE1",.F.)
					// Inserido por Walter Golo Ueda
					// Objetivo:Acertar vendedor no SE1
					if Empty(SE1->E1_VEND3)
						SE1->E1_VEND3 := cVend3
					Endif
					if Empty(SE1->E1_VEND4)
						SE1->E1_VEND4 := cVend4
					Endif
					if Empty(SE1->E1_VEND5)
						SE1->E1_VEND5 := cVend5
					Endif
					SE1->E1_COMIS3 := _nComis3
					SE1->E1_COMIS4 := _nComis4
					SE1->E1_COMIS5 := _nComis5
					MsUnlock()
				Endif
			Endif
			dbSelectArea("ARQ_SE1")
			dbSkip()
		Enddo
		dbSelectArea("ARQ_SE1")
		dbCloseArea()
		// Fim da alteração - Denis Tofoli

		_nComis3 := 0
		_nComis4 := 0
		_nComis5 := 0
		dbSelectArea("SC5")
		dbSkip()
	EndDo
Return