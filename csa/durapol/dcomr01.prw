/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DCOMR01C   º Autor ³                    º Data ³  11/01/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Resumo de Itens de Entrada - Coleta                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DCOMR01
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Resumo Itens de Entrada - Coleta"
	Local cPict         := ""
	Local titulo        := "Resumo Itens de Entrada - Coleta"
	Local nLin          := 80                
	Local Cabec1        := "Documento  Carcaca            Fogo       Desenho         Cliente/Fornecedor                          Qtd  Vlr.Unitário          Prc.Tab           Prc.Cliente        % Desconto   Motorista                     Entrega"
	Local Cabec2        := ""
	Local imprime       := .T.
	Local aOrd          := {"Emissao","Entrega"}
	Private cString     := "SD1"
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 132
	Private tamanho     := "G"
	Private nomeprog    :=" DCOMR01C" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private _cPerg      := "COMR01"
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "DCOMR01" // Coloque aqui o nome do arquivo usado para impressao em disco

	dbSelectArea("SD1")
	dbSetOrder(1)

	_aRegs := {}
	AAdd(_aRegs,{_cPerg,"01","Da Emissao ?"   ,"Da Emissao"    ,"Da Emissao"    ,"mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Emissao ?"  ,"Ate Emissaor"  ,"Ate Emissao"   ,"mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	ValidPerg(_aRegs,_cPerg)

	Pergunte(_cPerg,.F.)

	// Monta a interface padrao com o usuario...
	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local nOrdem
	Local aResumo := {}

	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

	_cQry := "SELECT ACP_CODREG,D1_DOC,D1_ITEM,D1_COD,D1_NUMFOGO,D1_MARCAPN,D1_X_DESEN,D1_FORNECE,D1_LOJA,D1_QUANT,D1_VUNIT"
	_cQry += " ,ACP_PRCVEN,ACP_PERDES,ACP_PERACR,ACP_CODPRO,C2_DATPRF"
	_cQry += " FROM "+RetSqlName("SD1")+" SD1"
	_cQry += " LEFT JOIN "+RetSqlName("ACP")+" ACP"
	_cQry += " ON    ACP.D_E_L_E_T_ = ''"
	_cQry += " AND   ACP_FILIAL = '"+xFilial("ACP")+"'"
	_cQry += " AND   ACP_CODREG = D1_FORNECE"
	_cQry += " AND   ACP_CODPRO = D1_SERVICO"
	_cQry += " LEFT JOIN "+RetSqlName("SC2")+" SC2"
	_cQry += " ON   SC2.D_E_L_E_T_ = ''"
	_cQry += " AND  C2_FILIAL = D1_FILIAL"
	_cQry += " AND  C2_NUM = D1_NUMC2"
	_cQry += " AND  C2_ITEM = D1_ITEMC2"
	_cQry += " WHERE SD1.D_E_L_E_T_ = ''"
	_cQry += " AND   D1_FILIAL = '"+xFilial("SD1")+"'"
	_cQry += " AND   D1_EMISSAO  BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "'"
	_cQry += " AND   D1_TIPO = 'B'"
	If aReturn[8] = 1
		_cQry += " ORDER BY D1_EMISSAO,D1_DOC,D1_ITEM"
	Else
		_cQry += " ORDER BY C2_DATPRF,D1_DOC,D1_ITEM"
	Endif

	_cQry := ChangeQuery(_cQry)

	MEMOWRITE("ITEM.SQL",_CQRY)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

	dbSelectArea("TRB")
	SetRegua(0)
	dbGoTop()

	SA1->(dbSetOrder(1))
	DA1->(dbSetOrder(2))

	While !EOF()
		IncRegua()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		SA1->(dbSeek(xFilial("SA1")+TRB->D1_FORNECE+TRB->D1_LOJA))
		DA1->(dbSeek(xFilial("DA1")+TRB->ACP_CODPRO ) )                                                   

		SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND3))

		@ nLin,001 Psay TRB->D1_DOC
		@ nLin,011 Psay TRB->D1_COD
		@ nLin,030 Psay TRB->D1_NUMFOGO
		//@ nLin,043 Psay TRB->D1_MARCAPN
		@ nLin,041 Psay TRB->D1_X_DESEN
		@ nLin,057 Psay Alltrim(SA1->A1_NOME)
		@ nLin,101 Psay TRB->D1_QUANT  Picture "@E 999"
		@ nLin,112 Psay TRB->D1_VUNIT  Picture "@E 999.99"
		@ nLin,121 Psay DA1->DA1_PRCVEN Picture "@E 999,999,999.99" //Tabela
		@ nLin,143 Psay TRB->ACP_PRCVEN Picture "@E 999,999,999.99"
		@ nLin,168 Psay IIF(TRB->ACP_PERDES == 0,TRB->ACP_PERACR,TRB->ACP_PERDES) Picture "@E 99.9999"
		@ nLin,178 PSAY Substr(SA3->A3_NOME,1,25)
		@ nLin,208 PSAY stod(TRB->C2_DATPRF)
		@ nLin,218 Psay iif(Len(AllTrim(ACP_CODREG))<=0,"***","")
		nLin ++

		nPos := aScan(aResumo, { |x| AllTrim(x[1]) == AllTrim(TRB->D1_COD) })
		If nPos > 0
			aResumo[nPos,2] += TRB->D1_QUANT
		Else
			aadd(aResumo,{TRB->D1_COD,TRB->D1_QUANT})
		Endif

		TRB->(dbSkip())
	EndDo

	dbSelectArea("TRB")
	dbCloseArea()

	nLin ++
	@ nLin,011 PSAY "Resumo de Carcaças"
	nLin++
	@ nLin,011 PSAY Replicate("-",25)
	nLin++
	@ nLin,010 PSAY "|"
	@ nLin,011 PSAY "Carcaça"
	@ nLin,025 PSAY "|"
	@ nLin,026 PSAY "Quantidade"
	@ nLin,036 PSAY "|"
	nLin++
	@ nLin,010 PSAY "|"
	@ nLin,011 PSAY Replicate("-",25)
	@ nLin,036 PSAY "|"
	nLin++
	nTot := 0
	For k=1 to Len(aResumo)
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		@ nLin,010 PSAY "|"
		@ nLin,011 PSAY Substr(aResumo[k,1],1,14)
		@ nLin,025 PSAY "|"
		@ nLin,030 PSAY aResumo[k,2] Picture "@E 99,999"
		@ nLin,036 PSAY "|"
		nLin ++
		nTot += aResumo[k,2]
	Next k
	@ nLin,010 PSAY "|"
	@ nLin,011 PSAY Replicate("-",25)
	@ nLin,036 PSAY "|"
	nLin++
	@ nLin,010 PSAY "|"
	@ nLin,011 PSAY "Total"
	@ nLin,025 PSAY "|"
	@ nLin,030 PSAY nTot Picture "@E 99,999"
	@ nLin,036 PSAY "|"
	nLin++
	@ nLin,011 PSAY Replicate("-",25)
	nLin+=3
	@ nLin,036 PSAY "*** Sem preço de tabela"


	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()
Return