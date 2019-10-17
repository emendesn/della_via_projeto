User Function DFATR13

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDFATR13C   บ Autor ณ AP6 IDE            บ Data ณ  11/01/06  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Tabela de Preco"
Local cPict          := ""
Local titulo         := "Relatorio Tabela de Preco"
Local nLin           := 90
Local Cabec1         := "Cod.Produto             Servico                                         Medida                                   Preco Venda "
Local Cabec2         := ""
Local imprime        := .T.
Local aPergunta      :={}
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 70
Private tamanho      := "M"
Private nomeprog     := "DFATR13" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private cPerg        := "DFAT13"
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "DFATR13" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "DA1"

dbSelectArea("DA1")
dbSetOrder(1)

AAdd(aPergunta,{cPerg,"01","Do  Cliente ?"     ,"Do Cliente"   ,"Da  Data"       ,"mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AAdd(aPergunta,{cPerg,"02","Ate Cliente ?"     ,"Ate Cliente"  ,"Ate Data"       ,"mv_ch2","C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AAdd(aPergunta,{cPerg,"03","Da  Loja    ?"     ,"Da Loja"      ,"Ate Data"       ,"mv_ch3","C", 2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"04","Ate Loja    ?"     ,"Ate Loja"     ,"Ate Data"       ,"mv_ch4","C", 2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"05","Tab.Padrao  ?"     ,"Ate Data"     ,"Ate Data"       ,"mv_ch5","C", 3,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})


ValidPerg(aPergunta,cPerg)

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  11/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cCliente :=""
Local cLoja    :=""

IF Select("TRBACP") > 0
	dbSelectArea("TRBACP")
	TRBACP->(dbCloseArea() )
EndIF

_cQry := "SELECT ACO_CODCLI, ACO_LOJA, DA1_PRCVEN, ACP_PRCVEN, ACP_CODPRO  "
_cQry += "FROM "+ RetSqlName("DA1") + " DA1, " + RetSqlName("ACO") + " ACO, "+ RetSqlName("ACP") + " ACP "
_cQry += "WHERE ACO_CODCLI BETWEEN '" + mv_par01 + "' and '" + mv_par02 + "' and "
_cQry += "ACO_LOJA BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' and "
_cQry += "ACO_CODTAB = '" + mv_par05 + "' and "
_cQry += "DA1_CODTAB = ACO_CODTAB and ACO_CODREG = ACP_CODREG and "
_cQry += "ACP_CODPRO = DA1_CODPRO and "
_cQry += "DA1.D_E_L_E_T_ = '' and "
_cQry += "ACO.D_E_L_E_T_ = '' and "
_cQry += "ACP.D_E_L_E_T_ = '' "
_cQry += "ORDER BY ACO_CODCLI,ACO_LOJA,ACP_CODPRO "

_cQry := ChangeQuery(_cQry)

MEMOWRITE("ACP.SQL",_cQry)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRBACP",.F.,.T.)

dbSelectArea("TRBACP")
dbGoTop()

SA1->(dbSetOrder(1))
SB1->(dbSetOrder(1))

While !EOF()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	SA1->(dbSeek(xFilial("SA1") + TRBACP->ACO_CODCLI + TRBACP->ACO_LOJA) )
	
	SB1->(dbSeek(xFilial("SB1") + TRBACP->ACP_CODPRO) )
	
	
	IF cCliente + cLoja != TRBACP->ACO_CODCLI + TRBACP->ACO_LOJA
		cCliente := TRBACP->ACO_CODCLI
		cLoja    := TRBACP->ACO_LOJA
		
		IF nLin != 8
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIF
		
		@nLin,000 PSAY "Cliente  : " + cCliente + ' - '+ Alltrim(SA1->A1_NOME)
		nLin ++		
		@nLin,000 PSAY "Endere็o : " + Alltrim(SA1->A1_END) + " Bairro : " + Alltrim(SA1->A1_BAIRRO)
		nLin ++
		@nLin,000 PSAY "Municipio: " + Alltrim(SA1->A1_MUN) + " Estado : " + Alltrim(SA1->A1_EST)
		nLin ++
		@nLin,000 PSAY "Telefone : " + Alltrim(SA1->A1_TEL) 
		nLin ++
		@nLin,000 PSAY "CNPJ     : " + Alltrim(SA1->A1_CGC) //Picture "@R 99.999.999/9999-99"
		nLin ++
		@nLin,000 PSAY "Motorista: " + Alltrim(SA1->A1_VEND3)
		nLin ++
		@nLin,000 PSAY "Vendedor : " + Alltrim(SA1->A1_VEND4)
		nLin ++
		
		SE4->( dbSetOrder(1) )
		SE4->( dbSeek(xFilial("SE4") + SA1->A1_COND) )
		
		@nLin,000 PSAY "Cond.Pgto: " + Alltrim(SA1->A1_COND) + " - " + Alltrim(SE4->E4_DESCRI)
		
		nLin ++
		
		@nLin,000 PSAY Replicate("_",130)
		
		nLin := nLin + 3
		
	EndIF
	
	
	@nLin,000 PSAY TRBACP->ACP_CODPRO
	@nLin,020 PSAY Alltrim(SB1->B1_DESC)
	@nLin,070 PSAY SB1->B1_PRODUTO
	@nLin,110 PSAY TRBACP->ACP_PRCVEN Picture "@E 999,999,999.99"
	
	nLin ++ // Avanca a linha de impressao
	
	cCliente := TRBACP->ACO_CODCLI
	cLoja    := TRBACP->ACO_LOJA
	
	TRBACP->(dbSkip())  // Avanca o ponteiro do registro no arquivo
	
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
