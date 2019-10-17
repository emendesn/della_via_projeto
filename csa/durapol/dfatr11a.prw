#include "Dellavia.ch"

User Function DFATR11A()
	Private cString 	:= "SF2"
	Private aOrd 		:= {"Valor","Cliente"}
	Private CbTxt       := ""
	Private cDesc1      := "Este relatorio tem a finalidade de demonstrar o total faturado dos clientes "
	Private cDesc2      := "atendidos por seus motoristas, vendedores, indicadores em um periodo."
	Private cDesc3      := "Resumo de Vendas por periodo"
	Private lAbortPrint := .F.
	Private limite      := 132
	Private tamanho     := "G"
	Private nomeprog    := "DFATR11"
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private titulo      := "Resumo de Vendas"
	Private nLin        := 80
	Private nPag		:= 0
	Private Cabec1      := ""
	Private Cabec2      := ""
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "DFATR11"
	Private cPerg     	:= "DFAT11"
	Private aQuebra     := {"Geral","Todos","Motoristas","Vendedores","Indicadores"}

	aRegs := {}
	aAdd(aRegs,{cPerg,"01","Da  Data ?"        ,"Da  Data","Da  Data","mv_ch1","D", 8,0,0,"G","","mv_par01",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","",""   })
	aAdd(aRegs,{cPerg,"02","Ate Data ?"        ,"Ate Data","Ate Data","mv_ch2","D", 8,0,0,"G","","mv_par02",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","",""   })
	aAdd(aRegs,{cPerg,"03","Quebra ?"          ," "       ," "       ,"mv_ch3","N", 1,0,0,"C","","mv_par03","Geral","","","","","Todos","","","","","Motorista","","","","","Vendedor","","","","","Indicador","","","",""   })
	aAdd(aRegs,{cPerg,"04","Do Vendedor ? "    ," "       ," "       ,"mv_ch4","C", 6,0,0,"G","","mv_par04",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA3"})
	aAdd(aRegs,{cPerg,"05","Ate o Vendedor ?"  ," "       ," "       ,"mv_ch5","C", 6,0,0,"G","","mv_par05",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA3"})

	ValidPerg(aRegs,cPerg)

	Pergunte(cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	cPerg := nil

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa( {|| ImpRel() } )
Return

Static Function ImpRel()
	Local cSql     := ""
	Local aTam     := {}
	Local aEstru   := {}
	Local nTotVlr  := 0
	Local nTtPneu  := 0
	Local nTotRec  := 0
	Local nTtAsTec := 0
	Local nTotNovo := 0
	Local nTtRecap := 0
	Local nTtCons  := 0

	Titulo := "["+AllTrim(aOrd[aReturn[8]])+"] - "+Alltrim(Titulo) + " - " + aQuebra[mv_par03]
	Cabec1 := " Periodo de " + DtoC(mv_par01) + " a " + DtoC(mv_par02)
	Cabec2 := " Cliente   Nome Cliente                                              Vlr.Recap     Vlr.Conserto    Ref.    Rec.     Vlr.Ass.Tec.    Vlr.Mercantil        Vlr.Total"
	*           xxxxxx    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   999.999.999.99   999.999.999.99   9.999   9.999   999.999.999.99   999.999.999.99   999.999.999.99
	*           12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	*                    1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17


	aAdd(aEstru,{"TMP_VEND"    ,"C",      07,       0})

	aTam := TamSX3("F2_CLIENTE")
	aAdd(aEstru,{"TMP_CLI"     ,"C",aTam[1],aTam[2]})

	aTam := TamSX3("A1_NOME")
	aAdd(aEstru,{"TMP_NOME"    ,"C",aTam[1],aTam[2]})

	aTam := TamSX3("F2_VALFAT")
	aAdd(aEstru,{"TMP_VLFAT"   ,"N",aTam[1],aTam[2]})

	aAdd(aEstru,{"TMP_VLSRV"   ,"N",aTam[1],aTam[2]})
	aAdd(aEstru,{"TMP_VLCON"   ,"N",aTam[1],aTam[2]})
	aAdd(aEstru,{"TMP_VLASS"   ,"N",aTam[1],aTam[2]})
	aAdd(aEstru,{"TMP_NOVO"    ,"N",aTam[1],aTam[2]})
	aAdd(aEstru,{"TMP_REF"     ,"N",4,0})
	aAdd(aEstru,{"TMP_REC"     ,"N",4,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",CriaTrab(,.F.),"TMP_VEND+TMP_CLI",,,"Selecionando Registros")

	GeraTRB()

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	If aReturn[8] = 1
		dbClearIndex()
		IndRegua("TMP",CriaTrab(,.F.),"TMP_VEND+Descend(Strzero(TMP_VLFAT,11,2))",,,"Selecionando Registros")
	Endif
	dbGotop()

	While ! Eof()
		nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		nLin += 2

		cVend := TMP_VEND
		nTotVlr  := 0
		nTtCons  := 0
		nTtPneu  := 0
		nTotRec  := 0
		nTtAsTec := 0
		nTotNovo := 0
		nTtRecap := 0

		If mv_par03 > 1
			@ nLin,001 PSAY iif(Substr(TMP_VEND,1,1)="3","Motorista: ",iif(Substr(TMP_VEND,1,1)="4","Vendedor: ","Indicador: "))+Substr(TMP_VEND,2,6)+" - "+Posicione("SA3",1,xFilial("SA3")+Substr(TMP->TMP_VEND,2,6),"SA3->A3_NOME")
			nLin+=2
		Endif
	
		Do while !eof() .and. TMP_VEND = cVend
			IncProc("Imprimindo ...")

			IF nLin > 60
				nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
				nLin += 2
			EndIF

			@ nLin, 001 Psay TMP_CLI
			@ nLin, 010 Psay Substr(TMP_NOME,1,40)
			@ nLin, 064 Psay TMP_VLSRV Picture "@E 999,999,999.99"
			@ nLin, 081 Psay TMP_VLCON Picture "@E 999,999,999.99"
			@ nLin, 097 Psay TMP_REF   Picture "@E 9,999"
			@ nLin, 106 Psay TMP_REC   Picture "@E 9,999"
			@ nLin, 114 Psay TMP_VLASS Picture "@E 999,999,999.99"
			@ nLin, 131 Psay TMP_NOVO  Picture "@E 999,999,999.99"
			@ nLin, 148 Psay TMP_VLFAT Picture "@E 999,999,999.99"
			nLin ++

			nTotVlr  += TMP_VLFAT
			nTtCons  += TMP_VLCON
			nTtPneu  += TMP_REF
			nTotRec  += TMP_REC 
			nTtAsTec += TMP_VLASS
			nTotNovo += TMP_NOVO
			nTtRecap += TMP_VLSRV

			dbSkip()
		Enddo
		nLin++
		@ nLin, 001 Psay "Total : "
		@ nLin, 064 Psay nTtRecap Picture "@E 999,999,999.99"
		@ nLin, 081 Psay nTtCons  Picture "@E 999,999,999.99"
		@ nLin, 097	Psay nTtPneu  Picture "@E 9,999"
		@ nLin, 106	Psay nTotRec  Picture "@E 9,999"
		@ nLin, 114	Psay nTtAsTec Picture "@E 999,999,999.99"
		@ nLin, 131 Psay nTotNovo Picture "@E 999,999,999.99"
		@ nLin, 148 Psay nTotVlr  Picture "@E 999,999,999.99"
		nLin +=2
	EndDo	

	IF nLin != 80
		Roda(cbcont,cbtxt,"M")
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	EndiF

	MS_FLUSH()
Return

Static Function GeraTRB()
	Local cSql     := ""
	Local nTotVlr  := 0
	Local nTtPneu  := 0
	Local nTotRec  := 0
	Local nTtAsTec := 0
	Local nTotNovo := 0
	Local nTtRecap := 0
	Local nTtCons  := 0

	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

	cSql := "SELECT F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,F2_VEND3,F2_VEND4,F2_VEND5"
	cSql += " ,      D2_TES,D2_TOTAL,D2_QUANT,B1_GRUPO,F4_DUPLIC,A1_NOME"
	cSql += " FROM "+RetSqlName("SF2")+" SF2"

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = F2_CLIENTE"
	cSql += " AND  A1_LOJA = F2_LOJA"

	cSql += " JOIN "+RetSqlName("SD2")+" SD2"
	cSql += " ON   SD2.D_E_L_E_T_ = ''"
	cSql += " AND  D2_FILIAL = F2_FILIAL"
	cSql += " AND  D2_DOC = F2_DOC"
	cSql += " AND  D2_SERIE = F2_SERIE"
	cSql += " AND  D2_TES NOT IN('594','902')"  // Nao considero os itens nao agregados

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D2_COD"

	cSql += " JOIN "+RetSqlName("SF4")+" SF4"
	cSql += " ON   SF4.D_E_L_E_T_ = ''"
	cSql += " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
	cSql += " AND  F4_CODIGO = D2_TES"

	cSql += " WHERE SF2.D_E_L_E_T_ = ''"
	cSql += " AND F2_FILIAL = '"+xFilial("SF2")+"'"
	cSql += " AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND F2_TIPO = 'N'"
	If mv_par03 > 2
		cSql += " AND F2_VEND"+Str(mv_par03,1)+" BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
		cSql += " AND F2_VEND"+Str(mv_par03,1)+" <> ''"
	Elseif mv_par03 = 2
		cSql += " AND (F2_VEND3 BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
		cSql += " OR   F2_VEND4 BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
		cSql += " OR   F2_VEND5 BETWEEN '"+mv_par04+"' AND '"+mv_par05+"')"
	Endif
	cSql += " ORDER BY F2_CLIENTE,F2_LOJA,F2_LOJA,F2_SERIE,F2_DOC"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TRB",.F.,.T.)

	dbSelectArea("TRB")
	dbGoTop()

	While ! Eof()
		cChave1  := F2_CLIENTE+F2_LOJA
		cNomeCli := A1_NOME

		cChave2 := F2_DOC+F2_SERIE
		aVend := {F2_VEND3,F2_VEND4,F2_VEND5}

		Do While !Eof() .and. F2_DOC+F2_SERIE = cChave2
			//--Vlr.Recapagem		
			IF F4_DUPLIC = "S" .and. Alltrim(B1_GRUPO) $ "SERV" //Vlr.Recapagem
				nTtRecap += D2_TOTAL
			EndIF

			//--Vlr.Conserto
			IF F4_DUPLIC = "S" .and. Alltrim(B1_GRUPO) $ "CI/SC" //Vlr.Conserto
				nTtCons  += D2_TOTAL
			EndIF		

			IF F4_DUPLIC = "S" .and. Alltrim(B1_GRUPO) == "SERV" //Total de reformas
				nTtPneu += D2_QUANT
			EndIF		

			//--Qtd.Recusado
			IF F4_DUPLIC = "N" .and. Alltrim(B1_GRUPO) == "SERV" //Total de reformas
				nTotRec += D2_QUANT
			EndIF		

			//--Vlr.Assitencia Tecnica
			IF F4_DUPLIC = "S" .and. Alltrim(B1_GRUPO) == "ATEC" 
				nTtAsTec += D2_TOTAL
			EndIF

			//--Vlr.Mercantil (Pneus novos)
			IF F4_DUPLIC = "S" .and. (B1_GRUPO $ "0001" .or. D2_TES = "503" .or. D2_TES = "506") // Grupo de Pneus novos by Golo
				nTotNovo += D2_TOTAL
			EndIF

			//--Vlr.Total Faturado
			IF F4_DUPLIC = "S" .and. !(B1_GRUPO $ "CARC") //Total Faturado
				nTotVlr += D2_TOTAL
			EndIF

			dbSkip()
		EndDo

		// Grava Temporário
		if mv_par03 = 2
			nLoop := 3
		Else
			nLoop := 1
		Endif

		For k=1 to nLoop
			cVarVend := Space(7)
			If mv_par03 = 2
				If Empty(aVend[k]) .OR. aVend[k] < mv_par04 .OR. aVend[k] > mv_par05
					Loop
				Endif
				cVarVend := Str(k+2,1)+aVend[k]
			Elseif mv_par03 > 2
				cVarVend := Str(mv_par03,1)+aVend[mv_par03-2]
			Endif

			dbSelectArea("TMP")
			dbSeek(cVarVend+Substr(cChave1,1,6))

			if Reclock("TMP",!Found())
				TMP->TMP_VEND    := cVarVend
				TMP->TMP_CLI     := Substr(cChave1,1,6)
				TMP->TMP_NOME    := cNomeCli
				TMP->TMP_VLSRV   += nTtRecap
				TMP->TMP_VLCON   += nTtCons
				TMP->TMP_REF     += nTtPneu
				TMP->TMP_REC     += nTotRec
				TMP->TMP_VLASS   += nTtAsTec
				TMP->TMP_NOVO    += nTotNovo
				TMP->TMP_VLFAT   += nTotVlr
				MsUnlock()
			Endif
        Next k
		nTotVlr := nTtPneu := nTotRec := nTtAsTec := nTotNovo := nTtRecap := nTtCons := 0
		dbSelectArea("TRB")
	EndDo
	dbCloseArea()
Return