#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELR001  �Autor  �Ricardo Mansano     � Data �  15/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Ordem de Montagem.                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Sera chamado via Menu onde sera apresentado a tela de      ���
���          �    perguntes.                                              ���
���          � Ou sera chamado na Tela de cadastro da Venda assistida     ���
���          �    para os Orcamentos ja salvos atravez do botao           ���
���          �    Relatorio de Montagem (Ctrl+O), chamado atravez do      ���
���          �    PE. LJ7016.                                             ���
���          � No momento de salvar o Orcamento (P.E.LJ7002) o relatorio  ���
���          �    deve ser impresso com o SL1 posicionado.                ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//������������������������������������������������������������������Ŀ
//� Caso seja executado do Venda Assistida utiliza o orcamento aberto�
//��������������������������������������������������������������������
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

//��������������������Ŀ
//� Executa Relatorio  �
//����������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �StaticRel �Autor  �Ricardo Mansano     � Data �  14/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao �Impressao dos dados do relatorio                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Utilizada pela rotina principal deste programa             ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������Ŀ
//� Se apertou Cancela �
//����������������������
If lEnd
	Return Nil
Endif

//�����������Ŀ
//� Cabecalho �
//�������������
Cabec(cTitulo,Cabec1,Cabec2,cNomeprog,cTamanho,nTipo)

//��������������������Ŀ
//� Localiza Orcamento �
//����������������������
DbSelectArea("SL1")
SL1->(DbSetOrder(1)) // L1_FILIAL+L1_NUM
If !SL1->(DbSeek(xFilial("SL1")+cOrca))
	Aviso("Aten��o !","Or�amento n�o localizado ou n�o salvo, salve o Or�amento e tente novamente !!!",{ " << Voltar " },1,"Rotina Terminada")
	Return Nil
Endif
@ Li,000 PSay "Or�amento: " + SL1->L1_NUM
PrintDireita("Data de Emiss�o: " + DtoC(SL1->L1_EMISSAO))
Li++
Li++

//��������������������Ŀ
//� Dados da Loja.     �
//����������������������
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

//��������������������Ŀ
//� Dados do Cliente.  �
//����������������������
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

//��������������������Ŀ
//� Dados do Veiculo.  �
//����������������������
// Posiciona Modelos
Posicione("PA1",1,xFilial("PA1")+SL1->L1_CODMOD,"PA1_COD")  // 1 = PA1_FILIAL+PA1_COD
@ Li,000 PSay "Ve�culo.: " + PA1->PA1_DESC
@ Li,080 PSay "Placa...: " + SL1->L1_PLACAV
@ Li,160 PSay "Ano.....: " + SL1->L1_ANO
Li++
Li++
'
//��������������������������������Ŀ
//� Dados dos Produtos / Servicos. �
//����������������������������������
@ Li,000 PSay "PRODUTOS / SERVI�OS"
Li++
@ Li,000 PSay __PrtThinLine()
Li++
@ Li,000 PSay "C�digo"
@ Li,020 PSay "Quant."
@ Li,030 PSay "Descri��o"
@ Li,070 PSay "Valor Unit�rio"
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

//��������������������������������Ŀ
//� Dados dos Pagamentos.          �
//����������������������������������
If Alltrim(SL1->L1_CONDPG) == "CN"
	cCondPg := "CONDI��O NEGOCIADA"
Else
	cCondPg := GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+SL1->L1_CONDPG,1,"Erro")
Endif
@ Li,000 PSay "CONDI��O DE PAGAMENTO No " + AllTrim(SL1->L1_CONDPG) + "   -->   " + cCondPg
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

//��������������������������������Ŀ
//� Observacoes.                   �
//����������������������������������
@ Li,000 PSay "OBSERVA��ES"
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

//��������������������������������Ŀ
//� Atividades da Della Via.       �
//����������������������������������
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


//��������������������������������Ŀ
//� Assinatura do Cliente.         �
//����������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintDireita � Autor � RICARDO MANSANO    � Data � 14/06/05 ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descri��o � Imprime Texto a Direita respeitando nTamLin                ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Utilizada pela rotina de impressao neste programa          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PrintDireita(cTexto)
Local cTextoFin := Alltrim(cTexto)
@ Li,(nTamLin-Len(cTextoFin)) PSay cTextoFin
Return Nil

