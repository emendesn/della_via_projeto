#Include "Dellavia.ch"
#Include "tbiconn.ch"
#Define CRLF chr(13)+chr(10)

User Function DVEDI02
	Local   aAreaSM0
	Private Titulo      := "EDI Mercador - Nota Fiscal"
	Private aSays       := {}
	Private aButtons    := {}
	Private aEnvLog     := {}
	Private cPerg       := "DVEDI2"
	Private aRegs       := {}

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "TMK"

	aAreaSM0 := SM0->(GetArea())

	/*
	If SM0->M0_CODIGO <> "01"
		msgbox("Esta rotina só pode ser executada na DellaVia","EDI","STOP")
		Return  nil
	Endif

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}

	aAdd(aRegs,{cPerg,"01","Da NF              ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })
	aAdd(aRegs,{cPerg,"02","Até a NF           ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })
	aAdd(aRegs,{cPerg,"03","Série              ?"," "," ","mv_ch3","C", 03,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })

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

	aAdd(aSays,"Esta rotina exporta notas fiscais pelo padrão Mercador.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Export() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
	*/
	Export()
	
	RestArea(aAreaSM0)
Return nil

Static Function Export()
	Local   cSql      := ""
	Local   aEstru    := {}
	Local   aRelato   := {}
	Private nHdl      := 0
	Private cFileName := ""

	//FechaBatch()

	// Registro 01 - Cabeçalho
	aEstru := {}
	aAdd(aEstru,{"R01_CMP01" ,"C",02,0}) // "01"                       |C| Tipo de Registro
	aAdd(aEstru,{"R01_CMP02" ,"C",03,0}) // "9 "                       |C| Função Mensagem
	aAdd(aEstru,{"R01_CMP03" ,"C",03,0}) // "380"                      |C| Tipo da Nota
	aAdd(aEstru,{"R01_CMP04" ,"C",06,0}) // F2_DOC                     |N| Número da nota fiscal
	aAdd(aEstru,{"R01_CMP05" ,"C",03,0}) // F2_SERIE                   |C| Série da nota fiscal
	aAdd(aEstru,{"R01_CMP06" ,"C",02,0}) //                            |C| Subsérie da nota fiscal
	aAdd(aEstru,{"R01_CMP07" ,"C",12,0}) // F2_EMISSAO + F2_HORA       |N| Data - Hora de emissao da nota fiscal
	aAdd(aEstru,{"R01_CMP08" ,"C",12,0}) // F2_EMISSAO + F2_HORA       |N| Data - Hora despacho ou saida
	aAdd(aEstru,{"R01_CMP09" ,"C",12,0}) // F2_EMISSAO + F2_HORA       |N| Data - Hora entrega
	aAdd(aEstru,{"R01_CMP10" ,"C",05,0}) // D2_CF                      |C| CFOP
	aAdd(aEstru,{"R01_CMP11" ,"C",20,0}) // UA_PEDCLI                  |C| Número do pedido do comprador
	aAdd(aEstru,{"R01_CMP12" ,"C",20,0}) //                            |C| Número do pedido do sistema de emissão
	aAdd(aEstru,{"R01_CMP13" ,"C",15,0}) //                            |C| Número do contrato
	aAdd(aEstru,{"R01_CMP14" ,"C",15,0}) //                            |C| Lista de preços
	aAdd(aEstru,{"R01_CMP15" ,"C",13,0}) // EANLOC(A1_CGC)             |N| EAN de localização do comprador
	aAdd(aEstru,{"R01_CMP16" ,"C",13,0}) // EANLOC(A1_CGC)             |N| EAN de localização da cobrança da fatura
	aAdd(aEstru,{"R01_CMP17" ,"C",13,0}) // EANLOC(A1_CGC)             |N| EAN de localização do local de entrega
	aAdd(aEstru,{"R01_CMP18" ,"C",13,0}) // EANLOC(M0_CGC)             |N| EAN de localização do fornecedor
	aAdd(aEstru,{"R01_CMP19" ,"C",13,0}) // EANLOC(M0_CGC)             |N| EAN de localização do emissor da nota
	aAdd(aEstru,{"R01_CMP20" ,"C",14,0}) // A1_CGC                     |N| CNPJ do comprador
	aAdd(aEstru,{"R01_CMP21" ,"C",14,0}) // A1_CGC                     |N| CNPJ do local da cobrança da fatura
	aAdd(aEstru,{"R01_CMP22" ,"C",14,0}) // A1_CGC                     |N| CNPJ do local de entrega
	aAdd(aEstru,{"R01_CMP23" ,"C",14,0}) // M0_CGC                     |N| CNPJ do fornecedor
	aAdd(aEstru,{"R01_CMP24" ,"C",14,0}) // M0_CGC                     |N| CNPJ do emissor da nota
	aAdd(aEstru,{"R01_CMP25" ,"C",02,0}) // M0_ESTENT                  |C| Estado do emissor da nota
	aAdd(aEstru,{"R01_CMP26" ,"C",20,0}) // M0_INSC                    |C| Inscrição estadual do emissor da nota
	aAdd(aEstru,{"R01_CMP27" ,"C",03,0}) // "251"                      |C| Tipo de código da transportadora
	aAdd(aEstru,{"R01_CMP28" ,"C",14,0}) // M0_CGC                     |N| Código da transportadora
	aAdd(aEstru,{"R01_CMP29" ,"C",30,0}) // M0_NOMECOM                 |C| Nome da transportadora
	aAdd(aEstru,{"R01_CMP30" ,"C",03,0}) //                            |C| Condição de entrega
	cNomR01 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomR01,"R01CB",.F.,.F.)


	// Registro 02 - Pagamentos
	aEstru := {}
	aAdd(aEstru,{"R02_CMP01" ,"C",02,0}) // "02"                     |C| Tipo de Registro
	aAdd(aEstru,{"R02_CMP02" ,"C",03,0}) // "1"                      |C| Condição de pagamento
	aAdd(aEstru,{"R02_CMP03" ,"C",03,0}) // "5"                      |C| Referência da data
	aAdd(aEstru,{"R02_CMP04" ,"C",03,0}) // "1"                      |C| Referência de tempo
	aAdd(aEstru,{"R02_CMP05" ,"C",03,0}) // "D"                      |C| Tipo de período
	aAdd(aEstru,{"R02_CMP06" ,"C",03,0}) // E1_VENCTO - E1_EMISSAO   |N| Número de períodos
	aAdd(aEstru,{"R02_CMP07" ,"C",08,0}) // E1_VENCTO                |N| Data de vencimento
	aAdd(aEstru,{"R02_CMP08" ,"C",03,0}) // "12E"                    |C| Tipo de percentual da condição de pagamento
	aAdd(aEstru,{"R02_CMP09" ,"C",05,0}) // (E1_VALOR/F2_VALFAT)*100 |N| Percentual da condição de pagamento
	aAdd(aEstru,{"R02_CMP10" ,"C",03,0}) // "262"                    |C| Tipo de valor da condição de pagamento
	aAdd(aEstru,{"R02_CMP11" ,"C",15,0}) // E1_VALOR                 |N| Valor da condição de pagamento
	cNomR02 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomR02,"R02PG",.F.,.F.)


	// Registro 04 - Itens
	aEstru := {}
	aAdd(aEstru,{"R04_CMP01" ,"C",02,0}) // "04"                       |C| Tipo de registro
	aAdd(aEstru,{"R04_CMP02" ,"C",04,0}) // D2_ITEM                    |N| Número sequencial da linha do item
	aAdd(aEstru,{"R04_CMP03" ,"C",05,0}) // "00000"                    |N| Número do item no pedido
	aAdd(aEstru,{"R04_CMP04" ,"C",03,0}) // "EN "                      |C| Tipo de código de produto
	aAdd(aEstru,{"R04_CMP05" ,"C",14,0}) // A7_CODCLI                  |C| Código de produto
	aAdd(aEstru,{"R04_CMP06" ,"C",20,0}) //                            |C| Referência do produto
	aAdd(aEstru,{"R04_CMP07" ,"C",03,0}) // D2_UM                      |C| Unidade de medida
	aAdd(aEstru,{"R04_CMP08" ,"C",05,0}) // Replic("0",Len(R04_CMP08)) |N| Número unidade consumo na embalagem
	aAdd(aEstru,{"R04_CMP09" ,"C",15,0}) // D2_QUANT                   |N| Quantidade
	aAdd(aEstru,{"R04_CMP10" ,"C",03,0}) //                            |C| Tipo de embalagem
	aAdd(aEstru,{"R04_CMP11" ,"C",15,0}) // D2_PRUNIT*D2_QUANT         |N| Valor bruto linha item
	aAdd(aEstru,{"R04_CMP12" ,"C",15,0}) // D2_TOTAL                   |N| Valor liquido linha item
	aAdd(aEstru,{"R04_CMP13" ,"C",15,0}) // D2_PRUNIT                  |N| Preço bruto unitário
	aAdd(aEstru,{"R04_CMP14" ,"C",15,0}) // D2_PRCVEN                  |N| Preço liquido unitário
	aAdd(aEstru,{"R04_CMP15" ,"C",20,0}) //                            |C| Número do lote
	aAdd(aEstru,{"R04_CMP16" ,"C",20,0}) //                            |C| Número do pedido do comprador
	aAdd(aEstru,{"R04_CMP17" ,"C",15,0}) // Replic("0",Len(R04_CMP17)) |N| Peso bruto do item
	aAdd(aEstru,{"R04_CMP18" ,"C",15,0}) // Replic("0",Len(R04_CMP18)) |N| Volume bruto do item
	aAdd(aEstru,{"R04_CMP19" ,"C",14,0}) //                            |C| Código de classificação fiscal
	aAdd(aEstru,{"R04_CMP20" ,"C",05,0}) //                            |C| Código da situação tributária
	aAdd(aEstru,{"R04_CMP21" ,"C",05,0}) // D2_CF                      |C| CFOP
	aAdd(aEstru,{"R04_CMP22" ,"C",05,0}) // Replic("0",Len(R04_CMP22)) |N| Percentual de desconto financeiro
	aAdd(aEstru,{"R04_CMP23" ,"C",15,0}) // Replic("0",Len(R04_CMP23)) |N| Valor de desconto financeiro
	aAdd(aEstru,{"R04_CMP24" ,"C",05,0}) // Replic("0",Len(R04_CMP24)) |N| Percentual de desconto comercial
	aAdd(aEstru,{"R04_CMP25" ,"C",15,0}) // Replic("0",Len(R04_CMP25)) |N| Valor de desconto comercial
	aAdd(aEstru,{"R04_CMP26" ,"C",05,0}) // Replic("0",Len(R04_CMP26)) |N| Percentual de desconto promocional
	aAdd(aEstru,{"R04_CMP27" ,"C",15,0}) // Replic("0",Len(R04_CMP27)) |N| Valor de desconto promocional
	aAdd(aEstru,{"R04_CMP28" ,"C",05,0}) // Replic("0",Len(R04_CMP28)) |N| Percentual de encargos financeiros
	aAdd(aEstru,{"R04_CMP29" ,"C",15,0}) // Replic("0",Len(R04_CMP29)) |N| Valor de encargos financeiros
	aAdd(aEstru,{"R04_CMP30" ,"C",05,0}) // D2_IPI                     |N| Alíquota de IPI
	aAdd(aEstru,{"R04_CMP31" ,"C",15,0}) // D2_VALIPI                  |N| Valor unitário de IPI
	aAdd(aEstru,{"R04_CMP32" ,"C",05,0}) // D2_PICM                    |N| Alíquota de ICMS
	aAdd(aEstru,{"R04_CMP33" ,"C",15,0}) // D2_VALICM                  |N| Valor de ICMS
	aAdd(aEstru,{"R04_CMP34" ,"C",05,0}) // Replic("0",Len(R04_CMP34)) |N| Alíquota de ICMS com substituição tributária
	aAdd(aEstru,{"R04_CMP35" ,"C",15,0}) // Replic("0",Len(R04_CMP35)) |N| Valor de ICMS com substituição tributária
	aAdd(aEstru,{"R04_CMP36" ,"C",05,0}) // Replic("0",Len(R04_CMP36)) |N| Aliquota de redução da base de ICMS
	aAdd(aEstru,{"R04_CMP37" ,"C",15,0}) // Replic("0",Len(R04_CMP37)) |N| Valor de redução a base de ICMS
	aAdd(aEstru,{"R04_CMP38" ,"C",05,0}) // Replic("0",Len(R04_CMP38)) |N| Percentual de desconto do repasse de ICMS
	aAdd(aEstru,{"R04_CMP39" ,"C",15,0}) // Replic("0",Len(R04_CMP39)) |N| Valor de desconto do repasse de ICMS
	cNomR04 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomR04,"R04IT",.F.,.F.)
	

	// Registro 09 - Sumario
	aEstru := {}
	aAdd(aEstru,{"R09_CMP01" ,"C",02,0}) // "09"                       |C| Tipo de Registro
	aAdd(aEstru,{"R09_CMP02" ,"C",04,0}) // Replic("0",Len(R09_CMP02)) |N| Numero de linhas da nota
	aAdd(aEstru,{"R09_CMP03" ,"C",15,0}) // Replic("0",Len(R09_CMP03)) |N| Quantidade total de embalagens
	aAdd(aEstru,{"R09_CMP04" ,"C",15,0}) // Replic("0",Len(R09_CMP04)) |N| Peso bruto total
	aAdd(aEstru,{"R09_CMP05" ,"C",15,0}) // Replic("0",Len(R09_CMP05)) |N| Peso liquido total
	aAdd(aEstru,{"R09_CMP06" ,"C",15,0}) // Replic("0",Len(R09_CMP06)) |N| Cubagem total
	aAdd(aEstru,{"R09_CMP07" ,"C",15,0}) // TOTAL                      |N| Valor total das linhas da nota
	aAdd(aEstru,{"R09_CMP08" ,"C",15,0}) // Replic("0",Len(R09_CMP08)) |N| Valor total de descontos
	aAdd(aEstru,{"R09_CMP09" ,"C",15,0}) // Replic("0",Len(R09_CMP09)) |N| Valor total de encargos
	aAdd(aEstru,{"R09_CMP10" ,"C",15,0}) // Replic("0",Len(R09_CMP10)) |N| Valor total de abatimentos
	aAdd(aEstru,{"R09_CMP11" ,"C",15,0}) // Replic("0",Len(R09_CMP11)) |N| Valor total frete
	aAdd(aEstru,{"R09_CMP12" ,"C",15,0}) // Replic("0",Len(R09_CMP12)) |N| Valor total seguro
	aAdd(aEstru,{"R09_CMP13" ,"C",15,0}) // Replic("0",Len(R09_CMP13)) |N| Valor despesas acessorias
	aAdd(aEstru,{"R09_CMP14" ,"C",15,0}) // TOTAL                      |N| Valor base de calculo do ICMS
	aAdd(aEstru,{"R09_CMP15" ,"C",15,0}) // VALICM                     |N| Valor total de ICMS
	aAdd(aEstru,{"R09_CMP16" ,"C",15,0}) // Replic("0",Len(R09_CMP16)) |N| Valor base de calculo de ICMS com substituição tributaria
	aAdd(aEstru,{"R09_CMP17" ,"C",15,0}) // Replic("0",Len(R09_CMP17)) |N| Valor total de ICMS com substituição tributaria
	aAdd(aEstru,{"R09_CMP18" ,"C",15,0}) // Replic("0",Len(R09_CMP18)) |N| Valor base de calculo de ICMS com reducao tributaria
	aAdd(aEstru,{"R09_CMP19" ,"C",15,0}) // Replic("0",Len(R09_CMP19)) |N| Valor total de ICMS com redução tributaria
	aAdd(aEstru,{"R09_CMP20" ,"C",15,0}) // TOTAL                      |N| Valor base de calculo do IPI
	aAdd(aEstru,{"R09_CMP21" ,"C",15,0}) // VALIPI                     |N| Valor total de IPI
	aAdd(aEstru,{"R09_CMP22" ,"C",15,0}) // TOTAL                      |N| Valor total da nota
	cNomR02 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomR02,"R09SM",.F.,.F.)


	cSql := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_PREFIXO,F2_DUPL,F2_VALFAT"
	cSql += " FROM "+RetSqlName("SF2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   F2_FILIAL BETWEEN '' AND 'ZZ'"
	//cSql += " AND   F2_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	//cSql += " AND   F2_SERIE = '"+mv_par03+"'"
	cSql += " AND   F2_CLIENTE = '0UC8OP'" // Somente Carrefour     
	cSql += " AND   F2_EXFLAG = ''"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_DOC", .T., .T.)
	TcSetField("ARQ_DOC","F2_VALFAT","N",14,2)
	dbSelectArea("ARQ_DOC")

	if !Eof()
		// Cria Arquivo para envio
		cFileName := "NF_" + dtos(Date()) + StrTran(Substr(Time(),1,5),":") + ".txt"
		nHdl := fCreate("\mercador\saida\"+cFileName, 1)

		if nHdl = -1
			dbCloseArea()
			FechaTmp()
			conout("Não é possivel criar o arquivo de envio")
			Return nil
		Endif
	Endif

	dbGoTop()

	Do While !eof()
		cSql := "SELECT F2_DOC,F2_SERIE,F2_EMISSAO,F2_HORA,A1_CGC,UA_PEDCLI,UA_TPFRETE,UA_NUM"
		cSql += " FROM "+RetSqlName("SF2")+" SF2"

		cSql += " JOIN "+RetSqlName("SA1")+" SA1"
		cSql += " ON   SA1.D_E_L_E_T_ = ''"
		cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += " AND  A1_COD = F2_CLIENTE"
		cSql += " AND  A1_LOJA = F2_LOJA"

		cSql += " LEFT JOIN SUA010 SUA"
		cSql += " ON   SUA.D_E_L_E_T_ = ''"
		cSql += " AND  UA_FILIAL = F2_FILIAL"
		cSql += " AND  UA_DOC = F2_DOC"
		cSql += " AND  UA_SERIE = F2_SERIE"
		cSql += " AND  UA_CLIENTE = F2_CLIENTE"
		cSql += " AND  UA_LOJA = F2_LOJA"

		cSql += " WHERE SF2.D_E_L_E_T_ = ''"
		cSql += " AND   F2_FILIAL = '"+ARQ_DOC->F2_FILIAL+"'"
		cSql += " AND   F2_DOC    = '"+ARQ_DOC->F2_DOC+"'"
		cSql += " AND   F2_SERIE  = '"+ARQ_DOC->F2_SERIE+"'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_CAB", .T., .T.)


		dbSelectArea("SM0")
		dbSetOrder(1)
		dbSeek("01"+ARQ_DOC->F2_FILIAL)


		dbSelectArea("SD2")
		dbGoTop()
		dbSetOrder(3)
		dbSeek(ARQ_DOC->(F2_FILIAL+F2_DOC+F2_SERIE))


		dbSelectArea("R01CB")
		Zap
		cNumOrc := ARQ_CAB->UA_NUM
		cPedCli := ARQ_CAB->UA_PEDCLI
		If RecLock("R01CB",.T.)
			R01CB->R01_CMP01 := "01"                                                       // |C| Tipo de Registro
			R01CB->R01_CMP02 := "9 "                                                       // |C| Função Mensagem
			R01CB->R01_CMP03 := "380"                                                      // |C| Tipo da Nota
			R01CB->R01_CMP04 := StrZero(Val(ARQ_CAB->F2_DOC),Len(R01_CMP04))               // |N| Número da nota fiscal
			R01CB->R01_CMP05 := ARQ_DOC->F2_SERIE                                          // |C| Série da nota fiscal
			R01CB->R01_CMP07 := ARQ_CAB->F2_EMISSAO + StrTran(ARQ_CAB->F2_HORA,":")        // |N| Data - Hora de emissao da nota fiscal
			R01CB->R01_CMP08 := ARQ_CAB->F2_EMISSAO + StrTran(ARQ_CAB->F2_HORA,":")        // |N| Data - Hora despacho ou saida
			R01CB->R01_CMP09 := ARQ_CAB->F2_EMISSAO + StrTran(ARQ_CAB->F2_HORA,":")        // |N| Data - Hora entrega
			R01CB->R01_CMP10 := SD2->D2_CF                                                 // |C| CFOP
			R01CB->R01_CMP11 := ARQ_CAB->UA_PEDCLI                                         // |C| Número do pedido do comprador
			R01CB->R01_CMP15 := EANLOC(ARQ_CAB->A1_CGC)                                    // |N| EAN de localização do comprador
			R01CB->R01_CMP16 := EANLOC(ARQ_CAB->A1_CGC)                                    // |N| EAN de localização da cobrança da fatura
			R01CB->R01_CMP17 := EANLOC(ARQ_CAB->A1_CGC)                                    // |N| EAN de localização do local de entrega
			R01CB->R01_CMP18 := EANLOC(SM0->M0_CGC)                                        // |N| EAN de localização do fornecedor
			R01CB->R01_CMP19 := EANLOC(SM0->M0_CGC)                                        // |N| EAN de localização do emissor da nota
			R01CB->R01_CMP20 := StrZero(Val(ARQ_CAB->A1_CGC),Len(R01_CMP20))               // |N| CNPJ do comprador
			R01CB->R01_CMP21 := StrZero(Val(ARQ_CAB->A1_CGC),Len(R01_CMP20))               // |N| CNPJ do local da cobrança da fatura
			R01CB->R01_CMP22 := StrZero(Val(ARQ_CAB->A1_CGC),Len(R01_CMP20))               // |N| CNPJ do local de entrega
			R01CB->R01_CMP23 := SM0->M0_CGC                                                // |N| CNPJ do fornecedor
			R01CB->R01_CMP24 := SM0->M0_CGC                                                // |N| CNPJ do emissor da nota
			R01CB->R01_CMP25 := SM0->M0_ESTENT                                             // |C| Estado do emissor da nota
			R01CB->R01_CMP26 := SM0->M0_INSC                                               // |C| Inscrição estadual do emissor da nota
			R01CB->R01_CMP27 := "251"                                                      // |C| Tipo de código da transportadora
			R01CB->R01_CMP28 := SM0->M0_CGC                                                // |N| Código da transportadora
			R01CB->R01_CMP29 := SM0->M0_NOMECOM                                            // |C| Nome da transportadora
			R01CB->R01_CMP30 := iif(ARQ_CAB->UA_TPFRETE="C","CIF","FOB")                   // |C| Condição de entrega
			MsUnlock()
		Endif
		dbSelectArea("ARQ_CAB")
		dbCloseArea()


		cSql := "SELECT E1_VENCTO,E1_EMISSAO,E1_VALOR"
		cSql += " FROM "+RetSqlName("SE1")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   E1_FILIAL  = '"+xFilial("SE1")+"'"
		cSql += " AND   E1_PREFIXO = '"+ARQ_DOC->F2_PREFIXO+"'"
		cSql += " AND   E1_NUM     = '"+ARQ_DOC->F2_DUPL+"'"
		cSql += " AND   E1_TIPO IN('DP','NF')"
		cSql += " ORDER BY E1_PARCELA"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_PAG", .T., .T.)
		TcSetField("ARQ_PAG","E1_VALOR","N",14,2)

		dbSelectArea("R02PG")
		Zap

		dbSelectArea("ARQ_PAG")
		dbGoTop()
		
		Do While !eof()
			dbSelectArea("R02PG")
			if RecLock("R02PG",.T.)
				R02PG->R02_CMP01 := "02"                                                                         // |C| Tipo de Registro
				R02PG->R02_CMP02 := "1"                                                                          // |C| Condição de pagamento
				R02PG->R02_CMP03 := "5"                                                                          // |C| Referência da data
				R02PG->R02_CMP04 := "1"                                                                          // |C| Referência de tempo
				R02PG->R02_CMP05 := "D"                                                                          // |C| Tipo de pedíodo
				R02PG->R02_CMP06 := StrZero(stod(ARQ_PAG->E1_VENCTO) - stod(ARQ_PAG->E1_EMISSAO),Len(R02_CMP06)) // |N| Número de períodos
				R02PG->R02_CMP07 := ARQ_PAG->E1_VENCTO                                                           // |N| Data de vencimento
				R02PG->R02_CMP08 := "12E"                                                                        // |C| Tipo de percentual da condição de pagamento
				R02PG->R02_CMP09 := StrZero(int((ARQ_PAG->E1_VALOR/ARQ_DOC->F2_VALFAT)*10000),Len(R02_CMP09))    // |N| Percentual da condição de pagamento
				R02PG->R02_CMP10 := "262"                                                                        // |C| Tipo de valor da condição de pagamento
				R02PG->R02_CMP11 := StrZero(int(ARQ_PAG->E1_VALOR*100),Len(R02_CMP11))                           // |N| Valor da condição de pagamento
				MsUnLock()
			Endif
			dbSelectArea("ARQ_PAG")
			dbSkip()
		Enddo
		dbSelectArea("ARQ_PAG")
		dbCloseArea()


		cSql := "SELECT D2_ITEM,D2_UM,D2_QUANT,D2_PRUNIT,D2_TOTAL,D2_PRCVEN,D2_CF,D2_DESC"
		cSql += "      ,D2_DESCON,D2_IPI,D2_VALIPI,D2_PICM,D2_VALICM,A7_CODCLI"
		cSql += " FROM "+RetSqlName("SD2")+" SD2"

		cSql += " JOIN "+RetSqlName("SA7")+" SA7"
		cSql += " ON   SA7.D_E_L_E_T_  = ''"
		cSql += " AND  A7_FILIAL = '"+xFilial("SA7")+"'"
		cSql += " AND  A7_CLIENTE = D2_CLIENTE"
		cSql += " AND  A7_LOJA = '01'"
		cSql += " AND  A7_PRODUTO = D2_COD"

		cSql += " WHERE SD2.D_E_L_E_T_ = ''"
		cSql += " AND   D2_FILIAL = '"+ARQ_DOC->F2_FILIAL+"'"
		cSql += " AND   D2_DOC    = '"+ARQ_DOC->F2_DOC+"'"
		cSql += " AND   D2_SERIE  = '"+ARQ_DOC->F2_SERIE+"'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_ITN", .T., .T.)
		TcSetField("ARQ_ITN","D2_QUANT" ,"N",14,2)
		TcSetField("ARQ_ITN","D2_PRUNIT","N",14,2)
		TcSetField("ARQ_ITN","D2_TOTAL" ,"N",14,2)
		TcSetField("ARQ_ITN","D2_PRCVEN","N",14,2)
		TcSetField("ARQ_ITN","D2_DESCON","N",14,2)
		TcSetField("ARQ_ITN","D2_VALIPI","N",14,2)
		TcSetField("ARQ_ITN","D2_VALICM","N",14,2)
		TcSetField("ARQ_ITN","D2_DESC"  ,"N",06,2)
		TcSetField("ARQ_ITN","D2_PICM"  ,"N",06,2)
		TcSetField("ARQ_ITN","D2_IPI"   ,"N",06,2)

		dbSelectArea("R04IT")
		Zap

		dbSelectArea("ARQ_ITN")
		dbGoTop()
		
		Do While !eof()
			dbSelectArea("R04IT")
			if RecLock("R04IT",.T.)
				R04IT->R04_CMP01 := "04"                                                        // |C| Tipo de registro
				R04IT->R04_CMP02 := StrZero(Recno(),Len(R04_CMP02))                             // |N| Número sequencial da linha do item
				R04IT->R04_CMP03 := Replicate("0",Len(R04_CMP03))                               // |N| Número do item no pedido
				R04IT->R04_CMP04 := "EN "                                                       // |C| Tipo de código de produto
				R04IT->R04_CMP05 := LimpaChr(ARQ_ITN->A7_CODCLI)                                // |C| Código de produto
				R04IT->R04_CMP07 := "EA"                                                        // |C| Unidade de medida
				R04IT->R04_CMP08 := Replic("0",Len(R04_CMP08))                                  // |N| Número unidade consumo na embalagem
				R04IT->R04_CMP09 := StrZero(ARQ_ITN->D2_QUANT*100,Len(R04_CMP09))               // |N| Quantidade
				R04IT->R04_CMP11 := StrZero((ARQ_ITN->(D2_PRUNIT*D2_QUANT))*100,Len(R04_CMP11)) // |N| Valor bruto linha item
				R04IT->R04_CMP12 := StrZero(ARQ_ITN->D2_TOTAL*100,Len(R04_CMP12))               // |N| Valor liquido linha item
				R04IT->R04_CMP13 := StrZero(ARQ_ITN->D2_PRUNIT*100,Len(R04_CMP13))              // |N| Preço bruto unitário
				R04IT->R04_CMP14 := StrZero(ARQ_ITN->D2_PRCVEN*100,Len(R04_CMP14))              // |N| Preço liquido unitário
				R04IT->R04_CMP17 := Replic("0",Len(R04_CMP17))                                  // |N| Peso bruto do item
				R04IT->R04_CMP18 := Replic("0",Len(R04_CMP18))                                  // |N| Volume bruto do item
				R04IT->R04_CMP21 := ARQ_ITN->D2_CF                                              // |C| CFOP
				R04IT->R04_CMP22 := Replic("0",Len(R04_CMP22))                                  // |N| Percentual de desconto financeiro
				R04IT->R04_CMP23 := Replic("0",Len(R04_CMP23))                                  // |N| Valor de desconto financeiro
				R04IT->R04_CMP24 := Replic("0",Len(R04_CMP24))                                  // |N| Percentual de desconto comercial
				R04IT->R04_CMP25 := Replic("0",Len(R04_CMP25))                                  // |N| Valor de desconto comercial
				R04IT->R04_CMP26 := Replic("0",Len(R04_CMP26))                                  // |N| Percentual de desconto promocional
				R04IT->R04_CMP27 := Replic("0",Len(R04_CMP27))                                  // |N| Valor de desconto promocional
				R04IT->R04_CMP28 := Replic("0",Len(R04_CMP28))                                  // |N| Percentual de encargos financeiros
				R04IT->R04_CMP29 := Replic("0",Len(R04_CMP29))                                  // |N| Valor de encargos financeiros
				R04IT->R04_CMP30 := StrZero(ARQ_ITN->D2_IPI*100,Len(R04_CMP30))                 // |N| Alíquota de IPI
				R04IT->R04_CMP31 := StrZero(ARQ_ITN->D2_VALIPI*100,Len(R04_CMP31))              // |N| Valor unitário de IPI
				R04IT->R04_CMP32 := StrZero(ARQ_ITN->D2_PICM*100,Len(R04_CMP32))                // |N| Alíquota de ICMS
				R04IT->R04_CMP33 := StrZero(ARQ_ITN->D2_VALICM*100,Len(R04_CMP33))              // |N| Valor de ICMS
				R04IT->R04_CMP34 := Replic("0",Len(R04_CMP34))                                  // |N| Alíquota de ICMS com substituição tributária
				R04IT->R04_CMP35 := Replic("0",Len(R04_CMP35))                                  // |N| Valor de ICMS com substituição tributária
				R04IT->R04_CMP36 := Replic("0",Len(R04_CMP36))                                  // |N| Aliquota de redução da base de ICMS
				R04IT->R04_CMP37 := Replic("0",Len(R04_CMP37))                                  // |N| Valor de redução a base de ICMS
				R04IT->R04_CMP38 := Replic("0",Len(R04_CMP38))                                  // |N| Percentual de desconto do repasse de ICMS
				R04IT->R04_CMP39 := Replic("0",Len(R04_CMP39))                                  // |N| Valor de desconto do repasse de ICMS
				MsUnlock()
			Endif
			
			dbSelectArea("ARQ_ITN")
			dbSkip()
		Enddo
		dbSelectArea("ARQ_ITN")
		dbCloseArea()


		cSql := "SELECT SUM(D2_TOTAL) AS TOTAL"
		//cSql += " ,     SUM(D2_DESCON)  AS DESCON"
		cSql += " ,     SUM(D2_BASEICM) AS BASEICM"
		cSql += " ,     SUM(D2_VALICM)  AS VALICM"
		cSql += " ,     SUM(D2_BASEIPI) AS BASEIPI"
		cSql += " ,     SUM(D2_VALIPI)  AS VALIPI"
		cSql += " FROM "+RetSqlName("SD2")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   D2_FILIAL  = '"+ARQ_DOC->F2_FILIAL+"'"
		cSql += " AND   D2_DOC     = '"+ARQ_DOC->F2_DOC+"'"
		cSql += " AND   D2_SERIE   = '"+ARQ_DOC->F2_SERIE+"'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SUM", .T., .T.)
		TcSetField("ARQ_SUM","TOTAL"  ,"N",14,2)
		TcSetField("ARQ_SUM","BASEICM","N",14,2)
		TcSetField("ARQ_SUM","VALICM" ,"N",14,2)
		TcSetField("ARQ_SUM","DESCON" ,"N",14,2)
		TcSetField("ARQ_SUM","BASEIPI","N",14,2)
		TcSetField("ARQ_SUM","VALIPI" ,"N",14,2)

		dbSelectArea("R09SM")
		Zap

		If RecLock("R09SM",.T.)
			R09SM->R09_CMP01 := "09"                                         // |C| Tipo de Registro
			R09SM->R09_CMP02 := Replic("0",Len(R09_CMP02))                   // |N| Numero de linhas da nota
			R09SM->R09_CMP03 := Replic("0",Len(R09_CMP03))                   // |N| Quantidade total de embalagens
			R09SM->R09_CMP04 := Replic("0",Len(R09_CMP04))                   // |N| Peso bruto total
			R09SM->R09_CMP05 := Replic("0",Len(R09_CMP05))                   // |N| Peso liquido total
			R09SM->R09_CMP06 := Replic("0",Len(R09_CMP06))                   // |N| Cubagem total
			R09SM->R09_CMP07 := StrZero(ARQ_SUM->TOTAL*100,Len(R09_CMP07))   // |N| Valor total das linhas da nota
			R09SM->R09_CMP08 := Replic("0",Len(R09_CMP08))                   // |N| Valor total de descontos
			R09SM->R09_CMP09 := Replic("0",Len(R09_CMP09))                   // |N| Valor total de encargos
			R09SM->R09_CMP10 := Replic("0",Len(R09_CMP10))                   // |N| Valor total de abatimentos
			R09SM->R09_CMP11 := Replic("0",Len(R09_CMP11))                   // |N| Valor total frete
			R09SM->R09_CMP12 := Replic("0",Len(R09_CMP12))                   // |N| Valor total seguro
			R09SM->R09_CMP13 := Replic("0",Len(R09_CMP13))                   // |N| Valor despesas acessorias
			R09SM->R09_CMP14 := StrZero(ARQ_SUM->BASEICM*100,Len(R09_CMP14)) // |N| Valor base de calculo do ICMS
			R09SM->R09_CMP15 := StrZero(ARQ_SUM->VALICM*100,Len(R09_CMP15))  // |N| Valor total de ICMS
			R09SM->R09_CMP16 := Replic("0",Len(R09_CMP16))                   // |N| Valor base de calculo de ICMS com substituição tributaria
			R09SM->R09_CMP17 := Replic("0",Len(R09_CMP17))                   // |N| Valor total de ICMS com substituição tributaria
			R09SM->R09_CMP18 := Replic("0",Len(R09_CMP18))                   // |N| Valor base de calculo de ICMS com reducao tributaria
			R09SM->R09_CMP19 := Replic("0",Len(R09_CMP19))                   // |N| Valor total de ICMS com redução tributaria
			R09SM->R09_CMP20 := StrZero(ARQ_SUM->BASEIPI*100,Len(R09_CMP20)) // |N| Valor base de calculo do IPI
			R09SM->R09_CMP21 := StrZero(ARQ_SUM->VALIPI*100,Len(R09_CMP21))  // |N| Valor total de IPI
			R09SM->R09_CMP22 := StrZero(ARQ_SUM->TOTAL*100,Len(R09_CMP22))   // |N| Valor total da nota
			
			MsUnLock()
		Endif
		dbSelectArea("ARQ_SUM")
		dbCloseArea()


		GravaTxt()

		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(ARQ_DOC->(F2_FILIAL+F2_DOC+F2_SERIE))
		If Found()
			If RecLock("SF2",.F.)
				SF2->F2_EXFLAG := "X"
				SF2->F2_EXARQ  := cFileName
				MsUnLock()
			Endif
		Endif

		aAdd(aRelato,{cNumOrc,cPedCli,"Faturado",cFileName,ARQ_DOC->(F2_DOC+"/"+F2_SERIE)})

		dbSelectArea("ARQ_DOC")
		dbSkip()
	Enddo
	dbSelectArea("ARQ_DOC")
	dbCloseArea()

	FechaTmp()

	fClose(nHdl)

	U_DVEDI06(aRelato,2)
Return nil

Static Function GravaTxt()
	Local cTxt := ""

	dbSelectArea("R01CB")
	dbGotop()
	cTxt := ""
	aCampos := dbStruct()
	For k=1 to Len(aCampos)
		cCpo := aCampos[k,1]
		cTxt += &cCpo
	Next k
	fWrite(nHdl,cTxt + CRLF)


	dbSelectArea("R02PG")
	dbGotop()
	aCampos := dbStruct()
	Do While !eof()	
		cTxt := ""
		For k=1 to Len(aCampos)
			cCpo := aCampos[k,1]
			cTxt += &cCpo
		Next k
		fWrite(nHdl,cTxt + CRLF)
		dbSkip()
	Enddo

	dbSelectArea("R04IT")
	dbGotop()
	aCampos := dbStruct()
	Do While !eof()	
		cTxt := ""
		For k=1 to Len(aCampos)
			cCpo := aCampos[k,1]
			cTxt += &cCpo
		Next k
		fWrite(nHdl,cTxt + CRLF)
		dbSkip()
	Enddo

	dbSelectArea("R09SM")
	dbGotop()
	cTxt := ""
	aCampos := dbStruct()
	For k=1 to Len(aCampos)
		cCpo := aCampos[k,1]
		cTxt += &cCpo
	Next k
	fWrite(nHdl,cTxt + CRLF)
Return nil

Static Function FechaTmp()
	dbSelectArea("R01CB")
	dbCloseArea()
	fErase(cNomR01+GetDBExtension())

	dbSelectArea("R02PG")
	dbCloseArea()
	fErase(cNomR02+GetDBExtension())

	dbSelectArea("R04IT")
	dbCloseArea()
	fErase(cNomR04+GetDBExtension())
Return

Static Function LimpaChr(cTxt)
	Local cRet := ""

	For k=1 To Len(cTxt)
		If Asc(Substr(cTxt,k,1)) >= 32
			cRet += Substr(cTxt,k,1)
		Else
			cRet += " "
		Endif
	Next k
Return cRet

Static Function EANLOC(cCNPJ)
	Local aArea := GetArea()
	Local cRet  := ""

	dbSelectArea("ZX8")
	dbSetOrder(1)
	dbSeek(xFilial("ZX8")+cCNPJ)
	If Found()
		cRet := ZX8->ZX8_EAN
	Else
		cRet := Space(13)
	Endif

	RestArea(aArea)
Return cRet