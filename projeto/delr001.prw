#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELR001  บAutor  ณRicardo Mansano     บ Data ณ  15/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Ordem de Montagem.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Sera chamado via Menu onde sera apresentado a tela de      บฑฑ
ฑฑบ          ณ    perguntes.                                              บฑฑ
ฑฑบ          ณ Ou sera chamado na Tela de cadastro da Venda assistida     บฑฑ
ฑฑบ          ณ    para os Orcamentos ja salvos atravez do botao           บฑฑ
ฑฑบ          ณ    Relatorio de Montagem (Ctrl+O), chamado atravez do      บฑฑ
ฑฑบ          ณ    PE. LJ7016.                                             บฑฑ
ฑฑบ          ณ No momento de salvar o Orcamento (P.E.LJ7002) o relatorio  บฑฑ
ฑฑบ          ณ    deve ser impresso com o SL1 posicionado.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELR001()
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Orcamento do Cliente"
Local cDesc3     	:= ""
Local _aArea   		:= {}
Local _aAlias  		:= {}

Private cTamanho  	:= "G" // "P"equeno "M"edio "G"rande
Private nTipo    	:= 15  // 15=Comprimido 18=Normal
Private Li			:= 00
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Ordem de Montagem"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= "DEL001"
Private cNomeProg 	:= "DEL001"
Private cString  	:= "SL1"
Private aReturn  	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private wnrel    	:= cNomeProg
Private cOrca		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso seja executado do Venda Assistida utiliza o orcamento abertoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Alltrim(Upper(FunName())) == "LOJA701"
	// Chamado pela Venda Assistida o registro ja esta posicionado
	cOrca := SL1->L1_NUM
Else
	// Ajusta e executa Perguntas
	PutSx1(cPerg,"01","Numero do Orcamento       ?","","","mv_ch1" ,"C",06,0,0,"G","","","","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
	Pergunte(cPerg,.T.)
	cOrca := MV_PAR01
Endif

P_CtrlArea(1,@_aArea,@_aAlias,{"SM0","SL1","SL2","SA1","PA1","PA7","SB1","SL4","PAC","SE4"}) // GetArea

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa Relatorio  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,cNomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,cTamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| StaticRel(@lEnd,wnRel,cString,cTamanho,nTipo)},cTitulo)

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStaticRel บAutor  ณRicardo Mansano     บ Data ณ  14/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณImpressao dos dados do relatorio                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Utilizada pela rotina principal deste programa             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function StaticRel(lEnd,wnRel,cString,cTamanho,nTipo)
Local nX		:= 0
Local aLinhas	:= {}
Local Cabec1	:= ""
Local Cabec2	:= ""
Local cCondPg	:= ""
Local cTxt		:= ""
Local nMemo1    := 162 // 200
Local nMemo2    := 180 // 232
Local nVlrPrd   := 0 // valor total das mercadorias
Local nVlrPag   := 0 // valor total pago
Private nTamLin	:= 220 // Tamanho maximo da Pagina

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se apertou Cancela ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lEnd
	Return Nil
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cabecalho ณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
Cabec(cTitulo,Cabec1,Cabec2,cNomeprog,cTamanho,nTipo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Localiza Orcamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SL1")
SL1->(DbSetOrder(1)) // L1_FILIAL+L1_NUM
If !SL1->(DbSeek(xFilial("SL1")+cOrca))
	Aviso("Aten็ใo !","Or็amento nใo localizado ou nใo salvo, salve o Or็amento e tente novamente !!!",{ " << Voltar " },1,"Rotina Terminada")
	Return Nil
Endif
@ Li,000 PSay "Or็amento: " + SL1->L1_NUM
PrintDireita("Data de Emissใo: " + DtoC(SL1->L1_EMISSAO))
Li++
Li++

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dados da Loja.     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Posiciona Loja
Posicione("SM0",1,SubStr(cNumEmp,1,2)+SL1->L1_FILIAL,"M0_CODIGO")
@ Li,000 PSay "DADOS DA LOJA"
Li++
@ Li,000 PSay __PrtThinLine()
Li++
@ Li,000 PSay "Loja: " + Alltrim(SM0->M0_CODFIL) + " - " + SM0->M0_NOME
PrintDireita("CNPJ: " + P_FormatCgc(SM0->M0_CGC))
Li++
@ Li,000 PSay SM0->M0_ENDENT
PrintDireita("I.E.: " + SM0->M0_INSC)
Li++
@ Li,000 PSay Alltrim(SM0->M0_BAIRENT) + " - " + Alltrim(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT
PrintDireita("Televendas: " + SL1->L1_NUMSUA)
Li++
@ Li,000 PSay "CEP: " + SM0->M0_CEPENT
PrintDireita("Telefone: " + SM0->M0_TEL)
Li++
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"014",1,"Erro"),nMemo2)
@ Li,000 PSay "e-mail: " + AllTrim(aLinhas[1])
Li++
Li++

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dados do Cliente.  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Posiciona Cliente
Posicione("SA1",1,xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"A1_COD") // 1 = A1_FILIAL+A1_COD+A1_LOJA
@ Li,000 PSay "DADOS DO CLIENTE"
Li++
@ Li,000 PSay __PrtThinLine()
Li++
@ Li,000 PSay "Nome....: " + IIf(SA1->A1_COD == GetMV("MV_CLIPAD"), AllTrim(SL1->L1_COMPL), SA1->A1_NOME)
@ Li,080 PSay "CNPJ/CPF: " + P_FormatCgc(SA1->A1_CGC)
@ Li,160 PSay "Telefone: " + SA1->A1_TEL
Li++

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dados do Veiculo.  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Posiciona Modelos
Posicione("PA1",1,xFilial("PA1")+SL1->L1_CODMOD,"PA1_COD")  // 1 = PA1_FILIAL+PA1_COD
@ Li,000 PSay "Veํculo.: " + PA1->PA1_DESC
@ Li,080 PSay "Placa...: " + SL1->L1_PLACAV
@ Li,160 PSay "Ano.....: " + SL1->L1_ANO
Li++
Li++
'
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dados dos Produtos / Servicos. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ Li,000 PSay "PRODUTOS / SERVIวOS"
Li++
@ Li,000 PSay __PrtThinLine()
Li++
@ Li,000 PSay "C๓digo"
@ Li,020 PSay "Quant."
@ Li,030 PSay "Descri็ใo"
@ Li,070 PSay "Valor Unitแrio"
@ Li,090 PSay "Valor Total"
Li++
// Posiciona no primeiro item do Orcamento
nVlrPrd := 0
DbSelectArea("SL2")
SL2->(DbSetOrder(1)) //L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO
If SL2->(DbSeek(xFilial("SL2")+SL1->L1_NUM))
	While xFilial("SL2")+SL1->L1_NUM == SL2->(L2_FILIAL+L2_NUM)
		@ Li,000 PSay SL2->L2_PRODUTO
		@ Li,020 PSay SL2->L2_QUANT
		@ Li,030 PSay GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+SL2->L2_PRODUTO,1,"Erro") // Descricao do Produto
		@ Li,074 PSay Transform(SL2->L2_VRUNIT ,"@E 999,999.99")
		@ Li,091 PSay Transform(SL2->L2_VLRITEM ,"@E 999,999.99")
		nVlrPrd += SL2->L2_VLRITEM
		Li++
		SL2->(DbSkip())
	EndDo
Endif
Li++
@ Li,069 PSay "Total de Mercadorias: R$" + Transform(nVlrPrd,"@E 999,999.99")
Li++
Li++

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dados dos Pagamentos.          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Alltrim(SL1->L1_CONDPG) == "CN"
	cCondPg := "CONDIวรO NEGOCIADA"
Else
	cCondPg := GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+SL1->L1_CONDPG,1,"Erro")
Endif
@ Li,000 PSay "CONDIวรO DE PAGAMENTO No " + AllTrim(SL1->L1_CONDPG) + "   -->   " + cCondPg
Li++
@ Li,000 PSay __PrtThinLine()
Li++
@ Li,000 PSay "Data"
@ Li,020 PSay "Forma"
@ Li,029 PSay "Vlr.Pago R$"
Li++
nVlrPag := 0
DbSelectArea("SL4")
SL4->(DbSetOrder(1)) // L4_FILIAL+L4_NUM+L4_ORIGEM
If SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
	While xFilial("SL4")+SL1->L1_NUM == SL4->(L4_FILIAL+L4_NUM)
		If !Empty(SL4->L4_ORIGEM)
			SL4->(DbSkip())
			Loop
		EndIf
		@ Li,000 PSay SL4->L4_DATA
		@ Li,020 PSay SL4->L4_FORMA
		@ Li,030 PSay SL4->L4_VALOR Picture "@E 999,999.99"
		nVlrPag += SL4->L4_VALOR
		Li++
		SL4->(DbSkip())
	EndDo
Endif
Li++
@ Li,000 PSay __PrtThinLine()
Li++
@ Li,000 PSay "Valor Total do Pedido: R$"
@ Li,030 PSay nVlrPag Picture "@E 999,999.99"
Li++
Li++

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Observacoes.                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ Li,000 PSay "OBSERVAวีES"
Li++
@ Li,000 PSay __PrtThinLine()
Li++
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"013",1,"Erro"),nMemo2)
For nX := 1 to Len(aLinhas)
	nChrEsp := At(Chr(10), aLinhas[nX])
	If nChrEsp > 0
		aLinhas[nX] := SubStr(aLinhas[nX], nChrEsp + 1)
	EndIf
	@ Li,000 PSay aLinhas[nX]
	Li++
Next nI
Li++
Li++

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atividades da Della Via.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ Li,000 PSay "ATIVIDADES DA DELLA VIA"
Li++
@ Li,000 PSay __PrtThinLine()
Li++

// Clube 1 Via
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"006",1,"Erro"),nMemo1)
@ Li,000 PSay "Clube 1 Via"
@ Li,020 PSay aLinhas[1]
Li++
For nX := 2 to Len(aLinhas)
	@ Li,020 PSay aLinhas[nX]
	Li++
Next nI

// Seguro de Pneus
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"007",1,"Erro"),nMemo1)
@ Li,000 PSay "Seguro de Pneus"
@ Li,020 PSay aLinhas[1]
Li++
For nX := 2 to Len(aLinhas)
	@ Li,020 PSay aLinhas[nX]
	Li++
Next nI

// Seguro de Rodas
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"008",1,"Erro"),nMemo1)
@ Li,000 PSay "Seguro de Rodas"
@ Li,020 PSay aLinhas[1]
Li++
For nX := 2 to Len(aLinhas)
	@ Li,020 PSay aLinhas[nX]
	Li++
Next nI

// PAC
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"009",1,"Erro"),nMemo1)
@ Li,000 PSay "PAC"
@ Li,020 PSay aLinhas[1]
Li++
For nX := 2 to Len(aLinhas)
	@ Li,020 PSay aLinhas[nX]
	Li++
Next nI

// Inspecao Veicular
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"010",1,"Erro"),nMemo1)
@ Li,000 PSay "Inspecao Veicular"
@ Li,020 PSay aLinhas[1]
Li++
For nX := 2 to Len(aLinhas)
	@ Li,020 PSay aLinhas[nX]
	Li++
Next nI

// Corretora
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"011",1,"Erro"),nMemo1)
@ Li,000 PSay "Corretora"
@ Li,020 PSay aLinhas[1]
Li++
For nX := 2 to Len(aLinhas)
	@ Li,020 PSay aLinhas[nX]
	Li++
Next nI

// Convenio
aLinhas := TkMemo(GetAdvFVal("PAC","PAC_CODMSG",xFilial("PAC")+"012",1,"Erro"),nMemo1)
@ Li,000 PSay "Convenio"
@ Li,020 PSay aLinhas[1]
Li++
For nX := 2 to Len(aLinhas)
	@ Li,020 PSay aLinhas[nX]
	Li++
Next nI


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Assinatura do Cliente.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Li++
Li++
Li++
Li++
Li++
cTxt := "_____________________"
@ Li,((nTamLin/2)-(Len(cTxt)/2)) Psay cTxt
Li++
cTxt := "Assinatura do Cliente"
@ Li,((nTamLin/2)-(Len(cTxt)/2)) Psay cTxt

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณPrintDireita บ Autor ณ RICARDO MANSANO    บ Data ณ 14/06/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออัออฯอออออัออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime Texto a Direita respeitando nTamLin                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Utilizada pela rotina de impressao neste programa          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintDireita(cTexto)
Local cTextoFin := Alltrim(cTexto)
@ Li,(nTamLin-Len(cTextoFin)) PSay cTextoFin
Return Nil

