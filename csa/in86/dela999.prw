// Criado os Indices abaixo para ana da DellaVia
// Ordem 6        - F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO+DTOS(F1_EMISSAO)
// Nick D1EMISSAO - D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM+DTOS(D1_EMISSAO)

#INCLUDE "Protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA999  � Autor � Ricardo Mansano    � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Recebe Arquivo de Dados da Della Via para execucao         ���
���          � da Instrucao Normativa 86                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function DELA999()
Private oDlg
Private nPos	:= 0
Private cCabec 	:= Space(100)
Private cItens 	:= Space(100)
Private oCabec
Private oItens
Private cEOL   := CHR(13)+CHR(10) // Pulo de Linha
Private aLog	:= {} 	// Guardara dados do Log de erros
Public _EspecDir:= "" 	// Guardara o Valor de Retorno da Consulta "DI2"

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������  

DEFINE MSDIALOG oDlg TITLE "Dados para Instru��o Normativa (23/06/2006)" FROM C(178),C(181) TO C(292),C(531) PIXEL

	// Cria as Groups do Sistema
	@ C(002),C(003) TO C(043),C(175) LABEL "" PIXEL OF oDlg

	// Cria Componentes Padroes do Sistema
	@ C(010),C(008) Say "Esta Rotina tem por objetivo importar arquivos textos contendo" Size C(149),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(019),C(008) Say "informa��es necess�rias ao processamento da Instru��o" Size C(136),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(029),C(008) Say "Normativa 86. Deve ser executada somente em Ambiente TESTE." Size C(158),C(008) COLOR CLR_BLACK PIXEL OF oDlg

	DEFINE SBUTTON FROM C(046),C(090) TYPE 5 ENABLE OF oDlg ACTION (Pergunta())
	DEFINE SBUTTON FROM C(046),C(119) TYPE 1 ENABLE OF oDlg ACTION (OkLeTxt())
	DEFINE SBUTTON FROM C(046),C(149) TYPE 2 ENABLE OF oDlg ACTION (oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � Ricardo Mansano    � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function OkLeTxt()
If MV_PAR02 == 1
	Processa({|| DELA999A() },"Recebendo Nota Fiscal de Entrada...")
Endif
If MV_PAR03 == 1
	Processa({|| DELA999B() },"Recebendo Nota Fiscal de Saida...")
Endif
If MV_PAR04 == 1
	Processa({|| DELA999C() },"Recebendo Livros Fiscais...")
Endif
If MV_PAR05 == 1
	Processa({|| DELA999D() },"Recebendo Contas Pagar/Receber...")
Endif
If MV_PAR06 == 1
	Processa({|| DELA999E() },"Recebendo Dados Contabeis...")
Endif
If MV_PAR07 == 1
	Processa({|| DELA999F() },"Recebendo Dados Cadastrais...")
Endif

MsgAlert("Processo Finalizado","Aviso")

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � DELA999A � Autor � Ricardo Mansano    � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para Receber Notas Fiscais de Entrada               ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function DELA999A()
Local nTamFile	:= 0
Local nTamLin	:= 0
Local cBuffer	:= ""
Local nBtLidos	:= 0
Local cArq	 	:= ""
Local nHdl 		:= 0
Local lTravaRec	:= .F. // Verificara a Necessidade de Travar a Recepcao da Linha do TXT

// Limpa Log e alimenta Cabecalho inicial
aLog := {}
aAdd(aLog,{"ARQUIVO","CAMPO","LINHA","ERRO","TOTAL NF","TOTAL ITENS","DIFERENCA"})

//����������������������������Ŀ
//� Prepara Arquivos para Uso  �
//������������������������������
DbSelectArea("SF1")
SF1->(DbSetOrder(1)) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
DbSelectArea("SD1")
SD1->(DbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
DbSelectArea("SA2")
SA2->(DbSetOrder(1)) // A2_FILIAL+A2_COD+A2_LOJA
DbSelectArea("SE4")
SE4->(DbSetOrder(1)) // E4_FILIAL+E4_CODIGO
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL+B1_COD
DbSelectArea("SF4")
SF4->(DbSetOrder(1)) // F4_FILIAL+F4_CODIGO

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Cabecalho da NF de Entrada                                      �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/

lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SF1000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+198	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// OLD - F1_FILIAL+F1_DOC+F1_SERIE + F1_FORNECE+F1_LOJA + F1_TIPO
		// Ordem "6" Criada devido a Duplica��o de NFs da Pirelli = 06/02/2006
		SF1->(DbSetOrder(6)) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO+DTOS(F1_EMISSAO)
		
		// Converte a Data de DDMMAAAA para DtoS()
		cDataEmi := Subs(cBuffer,162,008)
		cDataEmi := DtoS(CtoD(Subs(cDataEmi,1,2)+'/'+Subs(cDataEmi,3,2)+'/'+Subs(cDataEmi,5,4)))
		
		cSeek := Subs(cBuffer,001,011)+Subs(cBuffer,146,008)+Subs(cBuffer,170,001) + cDataEmi
		If SF1->( DbSeek( cSeek ) )
			aAdd(aLog, {cArq,"CABECALHO NOTA ENTRADA",nLinha,"Nota Fiscal de Entrada Duplicada ["+cSeek+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SF1",.T.)
			SF1->F1_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SF1->F1_DOC       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SF1->F1_SERIE     := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SF1->F1_COND      := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SF1->F1_VALMERC   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SF1->F1_DESCONT   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SF1->F1_FRETE     := Part("N", cBuffer, RetPos(nPos), IncLen(015), 15, 2)
			SF1->F1_SEGURO    := Part("N", cBuffer, RetPos(nPos), IncLen(015), 15, 2)
			SF1->F1_DESPESA   := Part("N", cBuffer, RetPos(nPos), IncLen(015), 15, 2)
			SF1->F1_VALIPI    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SF1->F1_ICMSRET   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SF1->F1_VALBRUT   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SF1->F1_PESOL     := Part("N", cBuffer, RetPos(nPos), IncLen(011), 11, 4)
			SF1->F1_ESPECIE   := Part("C", cBuffer, RetPos(nPos), IncLen(005))
			SF1->F1_FORNECE   := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SF1->F1_LOJA      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SF1->F1_DTDIGIT   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SF1->F1_EMISSAO   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SF1->F1_TIPO      := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SF1->F1_ICMSRET   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SF1->F1_VALBRUT   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SF1->(MSUnLock())
			SF1->(DbCommit())

		    //���������������������������������������������������������������������Ŀ
	    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
		    //�����������������������������������������������������������������������
		    // Fornecedor - A2_FILIAL+A2_COD+A2_LOJA
		    If !SA2->( DbSeek( xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA) ) )
				aAdd(aLog, {cArq,"F1_FORNECE",nLinha,"Fornecedor nao existe ["+SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA)+"]"} )
		    Endif
		    // Tipo NF
		    If !SF1->F1_TIPO $ "NDIPBC"
				aAdd(aLog, {cArq,"F1_TIPO",nLinha,"Tipo NF Invalido ["+SF1->F1_TIPO+"]"} )
		    Endif
		    // Condicao Pgto - E4_FILIAL+E4_CODIGO
		    If !SE4->( DbSeek( xFilial("SE4")+SF1->F1_COND ) )
				aAdd(aLog, {cArq,"F1_COND",nLinha,"Condicao Pgto nao existe ["+SF1->(F1_FILIAL+F1_COND)+"]"} )
		    Endif
		    // Especie NF
		    // ExistCpo((cAlias,cSeek,nIndice,cHelp,lMostraErro)
		    If !ExistCpo("SX5","42"+SF1->F1_ESPECIE,,,.F.)
				aAdd(aLog, {cArq,"F1_ESPECIE",nLinha,"Especie nao existe ["+SF1->F1_ESPECIE+"]"} )
		    Endif
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Itens da NF de Entrada                                          �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SD1000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+187	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// OLD - D1_FILIAL + D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA + D1_COD + D1_ITEM
		// NickName D1EMISSAO Criado devido a Duplica��o de NFs da Pirelli - 06/02/2006
		DbSelectArea("SD1")
		SD1->(DbOrderNickName("D1EMISSAO")) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM+DTOS(D1_EMISSAO)
		// Converte a Data de DDMMAAAA para DtoS()
		cDataEmi := Subs(cBuffer,053,008)   
		cDataEmi := DtoS(CtoD(Subs(cDataEmi,1,2)+'/'+Subs(cDataEmi,3,2)+'/'+Subs(cDataEmi,5,4)))

		cSeek := Subs(cBuffer,001,002)+Subs(cBuffer,035,017)+Subs(cBuffer,020,015)+Subs(cBuffer,061,004)+cDataEmi
		If SD1->( DbSeek(cSeek) )
			aAdd(aLog, {cArq,"ITEM NOTA ENTRADA",nLinha,"Nota Fiscal de Entrada Duplicada ["+cSeek+"]"} )
			nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Se encontrar registro igual pula para a proxima
	    	nLinha++
			lTravaRec := .T.
		Endif
		
	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
		   	nPos := 1 // Zera Posicao da Linha do Texto
		   	SD1->(DbSetOrder(1))
			RecLock("SD1",.T.)
			SD1->D1_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SD1->D1_DTDIGIT   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SD1->D1_FORMUL    := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SD1->D1_CF        := AllTrim(Str(Part("N", cBuffer, RetPos(nPos), IncLen(005), 05, 0)))
			SD1->D1_TES       := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SD1->D1_COD       := Part("C", cBuffer, RetPos(nPos), IncLen(015))
			SD1->D1_DOC       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SD1->D1_SERIE     := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SD1->D1_FORNECE   := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SD1->D1_LOJA      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SD1->D1_TIPO      := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SD1->D1_EMISSAO   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SD1->D1_ITEM      := Part("C", cBuffer, RetPos(nPos), IncLen(004))
			SD1->D1_QUANT     := Part("N", cBuffer, RetPos(nPos), IncLen(011), 11, 2)
			SD1->D1_UM        := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SD1->D1_TOTAL     := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SD1->D1_VALDESC   := Part("N", cBuffer, RetPos(nPos), IncLen(012), 12, 2)
			SD1->D1_IPI       := Part("N", cBuffer, RetPos(nPos), IncLen(006), 06, 2)
			SD1->D1_VALIPI    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SD1->D1_CLASFIS   := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SD1->D1_PICM      := Part("N", cBuffer, RetPos(nPos), IncLen(005), 05, 2)
			SD1->D1_BASEICM   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SD1->D1_VALICM    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SD1->D1_BRICMS    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SD1->D1_ICMSRET   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
			SD1->(MSUnLock())
			SD1->(DbCommit())
          
            //���������������������������������������������������������������������Ŀ
	    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
		    //�����������������������������������������������������������������������
		    // Fornecedor - A2_FILIAL+A2_COD+A2_LOJA
		    If !SA2->( DbSeek( xFilial("SA2")+SD1->(D1_FORNECE+D1_LOJA) ) )
				aAdd(aLog, {cArq,"D1_FORNECE",nLinha,"Fornecedor nao existe ["+SD1->(D1_FILIAL+D1_FORNECE+D1_LOJA)+"]"} )
		    Endif
		    // Produto - B1_FILIAL+B1_COD
		    If !SB1->( DbSeek( xFilial("SB1")+SD1->D1_COD ) )
				aAdd(aLog, {cArq,"D1_COD",nLinha,"Produto nao existe ["+SD1->(D1_FILIAL+D1_COD)+"]"} )
		    Endif
		    // TES - F4_FILIAL+F4_CODIGO
		    If !SF4->( DbSeek( xFilial("SF4")+SD1->D1_TES ) )
				aAdd(aLog, {cArq,"D1_TES",nLinha,"TES nao existe ["+SD1->(D1_FILIAL+D1_TES)+"]"} )
		    Endif
		    // CFO
		    If !ExistCpo("SX5","13"+SD1->D1_CF,,,.F.)
				aAdd(aLog, {cArq,"D1_CF",nLinha,"CF nao existe ["+SD1->D1_CF+"]"} )
		    Endif
		    // UM
		    If !ExistCpo("SAH",SD1->D1_UM,,,.F.)
				aAdd(aLog, {cArq,"D1_UM",nLinha,"UM nao existe ["+SD1->D1_UM+"]"} )
	        Endif
		    // Tipo NF
		    If !SD1->D1_TIPO $ "NCTOB"
				aAdd(aLog, {cArq,"D1_TIPO",nLinha,"Tipo NF Invalido ["+SD1->D1_TIPO+"]"} )
		    Endif

		Endif
         //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Verifica Erro na Soma entre os Itens e o Cabecalho              �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/                                              
// WILSON JORGE TEDOKON - 25/04/2006 - INICIO
//cQuery := "SELECT D1_FILIAL||D1_DOC||D1_SERIE||D1_FORNECE||D1_LOJA CSEEK,SUM(D1_TOTAL+D1_VALIPI+D1_ICMSRET)TOTAL	"
cQuery := "SELECT D1_FILIAL||D1_DOC||D1_SERIE||D1_FORNECE||D1_LOJA CSEEK,SUM(D1_TOTAL+D1_VALIPI+D1_ICMSRET-D1_VALDESC)TOTAL	"
// WILSON JORGE TEDOKON - 25/04/2006 - FIM
cQuery += " FROM "+RetSqlName("SD1")
cQuery += " WHERE D_E_L_E_T_ <> '*'											 		"
cQuery += " AND   D1_EMISSAO BETWEEN '"+DtoS(MV_PAR08)+"' AND '"+DtoS(MV_PAR09)+"'	"
cQuery += " GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA               	"
cQuery += " ORDER BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA                	"
MontaQuery("TRB","SD1",cQuery)

While !TRB->(Eof())
	// F1_FILIAL+F1_DOC+F1_SERIE + F1_FORNECE+F1_LOJA + F1_TIPO
	If SF1->( DbSeek(TRB->CSEEK) )
		// Caso soma nao bata com Cabec
        // WILSON JORGE TEDOKON - 25/04/2006 - INICIO
		//nDif := SF1->F1_VALBRUT - TRB->TOTAL
		nDif := SF1->F1_VALBRUT - SF1->F1_DESPESA - TRB->TOTAL
        // WILSON JORGE TEDOKON - 25/04/2006 - FIM
		// Acusa erros apenas de diferencas superiores a 0.03 Centavos (Arredondamento)
		If nDif > 0.03 .Or. nDif < -0.03
			aAdd(aLog, {cArq,"D1_DOC",0,"Soma nao bate com Cabec da NF de Entrada ["+TRB->CSEEK+"]",;
			            SF1->F1_VALBRUT,TRB->TOTAL,SF1->F1_VALBRUT-TRB->TOTAL} )
		Endif
	Else
		aAdd(aLog, {cArq,"D1_DOC",0,"Cabecalho da NF de Entrada nao Encontrado ["+TRB->CSEEK+"]"} )
	Endif

TRB->(DbSkip())
EndDo
// Fecha Query
TRB->(DbCloseArea())

//����������������������������������Ŀ
//� Abre Planilha do Excel com LOG   �
//������������������������������������
If Len(aLog) >=2 // Desconto o Cabec da Array
	MontaExcel(aLog,MV_PAR01,"LOG_NF_ENTRADA_"+DtoS(DDataBase)+"_"+Subs(Time(),1,2)+Subs(Time(),4,2))
Endif   

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � DELA999B � Autor � Ricardo Mansano    � Data �  14/12/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para Receber Notas Fiscais de Saida                 ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function DELA999B()
Local nTamFile	:= 0
Local nTamLin	:= 0
Local cBuffer	:= ""
Local nBtLidos	:= 0
Local cArq	 	:= ""
Local nHdl 		:= 0
Local lTravaRec	:= .F. // Verificara a Necessidade de Travar a Recepcao da Linha do TXT

// Limpa Log e alimenta Cabecalho inicial
aLog := {}
aAdd(aLog,{"ARQUIVO","CAMPO","LINHA","ERRO","TOTAL NF","TOTAL ITENS","DIFERENCA"})

//����������������������������Ŀ
//� Prepara Arquivos para Uso  �
//������������������������������
DbSelectArea("SF2")
SF2->(DbSetOrder(1)) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
DbSelectArea("SD2")  
// WILSON JORGE TEDOKON - INICIO - 05/05/2006
//SD2->(DbSetOrder(3)) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM   
SD2->(DbOrderNickName("SD2011")) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_ITEM                                                                                                            
// WILSON JORGE TEDOKON - FIM   - 05/05/2006
DbSelectArea("SA1")
SA1->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA
DbSelectArea("SE4")
SE4->(DbSetOrder(1)) // E4_FILIAL+E4_CODIGO
DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL+B1_COD
DbSelectArea("SF4")
SF4->(DbSetOrder(1)) // F4_FILIAL+F4_CODIGO

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Cabecalho da NF de Saida                                        �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SF2000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+220	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// F2_FILIAL+F2_DOC+F2_SERIE + F2_CLIENTE+F2_LOJA + (F2_FORMUL nao tem esse Campo no TXT)
		If SF2->( DbSeek(Subs(cBuffer,001,011)+Subs(cBuffer,171,008)) )
			aAdd(aLog, {cArq,"CABECALHO NOTA SAIDA",nLinha,"Nota Fiscal de Saida Duplicada ["+Subs(cBuffer,001,011)+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SF2",.T.)
			SF2->F2_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SF2->F2_DOC       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SF2->F2_SERIE     := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SF2->F2_TRANSP    := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SF2->F2_COND      := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SF2->F2_VALMERC   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_DESCONT   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_FRETE     := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_SEGURO    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_DESPESA   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_VALIPI    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_ICMSRET   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_VALBRUT   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_VOLUME1   := Part("N", cBuffer, RetPos(nPos), IncLen(006))
			SF2->F2_ESPECI1   := Part("C", cBuffer, RetPos(nPos), IncLen(010))
			SF2->F2_PBRUTO    := Part("N", cBuffer, RetPos(nPos), IncLen(011), 011, 4)
			SF2->F2_PLIQUI    := Part("N", cBuffer, RetPos(nPos), IncLen(011), 011, 4)
			SF2->F2_CLIENTE   := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SF2->F2_LOJA      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SF2->F2_ESPECIE   := Part("C", cBuffer, RetPos(nPos), IncLen(005))
			SF2->F2_DESCONT   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_VALIRRF   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SF2->F2_EMISSAO   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SF2->F2_TIPO      := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SF2->(MSUnLock())
			SF2->(DbCommit())

		    //���������������������������������������������������������������������Ŀ
	    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
		    //�����������������������������������������������������������������������
		    // Cliente - A1_FILIAL+A1_COD+A1_LOJA
		    If !SA1->( DbSeek( xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA) ) )
				aAdd(aLog, {cArq,"F2_CLIENTE",nLinha,"Cliente nao existe ["+SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA)+"]"} )
		    Endif
		    // Tipo NF (Tirado porque nao veio no arquivo)
		    //If !SF2->F2_TIPO $ "NDIPBC"
			//	aAdd(aLog, {cArq,"F2_TIPO",nLinha,"Tipo NF Invalido ["+SF2->F2_TIPO+"]"} )
		    //Endif
		    // Condicao Pgto - E4_FILIAL+E4_CODIGO
		    If !SE4->( DbSeek( xFilial("SE4")+SF2->F2_COND ) )
				aAdd(aLog, {cArq,"F2_COND",nLinha,"Condicao Pgto nao existe ["+SF2->(F2_FILIAL+F2_COND)+"]"} )
		    Endif
		    // Especie NF
		    // ExistCpo((cAlias,cSeek,nIndice,cHelp,lMostraErro)
		    If !ExistCpo("SX5","42"+SF2->F2_ESPECIE,,,.F.)
				aAdd(aLog, {cArq,"F2_ESPECIE",nLinha,"Especie nao existe ["+SF2->F2_ESPECIE+"]"} )
		    Endif
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Itens da NF de Saida                                            �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SD2000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+234	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// Mudada posi��o do campo de 35 para 34 devido a erro de soma no DOC de arquivos TXT - 06/02/2006
		//WILSON JORGE TEDOKON - INICIO - 05/05/2006
		//cSeek := Subs(cBuffer,001,002)+Subs(cBuffer,034,017)+Subs(cBuffer,019,015)+Subs(cBuffer,052,002)
		cSeek := Subs(cBuffer,001,002)+Subs(cBuffer,034,017)+Subs(cBuffer,052,002)
		//WILSON JORGE TEDOKON - FIM   - 05/05/2006
		If SD2->( DbSeek(cSeek) )
			aAdd(aLog, {cArq,"ITEM NOTA SAIDA",nLinha,"Nota Fiscal de Entrada Duplicada ["+cSeek+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SD2",.T.)
			SD2->D2_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SD2->D2_EMISSAO   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SD2->D2_CF        := AllTrim(Str(Part("N", cBuffer, RetPos(nPos), IncLen(005), 05, 0)))
			SD2->D2_TES       := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SD2->D2_COD       := Part("C", cBuffer, RetPos(nPos), IncLen(015))
			SD2->D2_DOC       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SD2->D2_SERIE     := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SD2->D2_CLIENTE   := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SD2->D2_LOJA      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SD2->D2_TIPO      := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SD2->D2_ITEM      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SD2->D2_QUANT     := Part("N", cBuffer, RetPos(nPos), IncLen(011), 011, 2)
			SD2->D2_UM        := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SD2->D2_PRCVEN    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_TOTAL     := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_DESCON    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_IPI       := Part("N", cBuffer, RetPos(nPos), IncLen(005), 005, 2)
			SD2->D2_VALIPI    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_CLASFIS   := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SD2->D2_PICM      := Part("N", cBuffer, RetPos(nPos), IncLen(005), 005, 2)
			SD2->D2_BASEICM   := Part("N", cBuffer, RetPos(nPos), IncLen(016), 016, 2)
			SD2->D2_VALICM    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_BRICMS    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_ICMSRET   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_CODISS    := Part("C", cBuffer, RetPos(nPos), IncLen(008))
			SD2->D2_ALIQISS   := Part("N", cBuffer, RetPos(nPos), IncLen(005), 005, 2)
			SD2->D2_BASEISS   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->D2_VALISS    := Part("N", cBuffer, RetPos(nPos), IncLen(014), 014, 2)
			SD2->(MSUnLock())
			SD2->(DbCommit())

		    //���������������������������������������������������������������������Ŀ
	    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
		    //�����������������������������������������������������������������������
		    // Cliente - A1_FILIAL+A1_COD+A1_LOJA
		    If !SA1->( DbSeek( xFilial("SA1")+SD2->(D2_CLIENTE+D2_LOJA) ) )
				aAdd(aLog, {cArq,"D2_CLIENTE",nLinha,"Cliente nao existe ["+SD2->(D2_FILIAL+D2_CLIENTE+D2_LOJA)+"]"} )
		    Endif
		    // Produto - B1_FILIAL+B1_COD
		    If !SB1->( DbSeek( xFilial("SB1")+SD2->D2_COD ) )
				aAdd(aLog, {cArq,"D2_COD",nLinha,"Produto nao existe ["+SD2->(D2_FILIAL+D2_COD)+"]"} )
		    Endif
		    // TES - F4_FILIAL+F4_CODIGO
		    If !SF4->( DbSeek( xFilial("SF4")+SD2->D2_TES ) )
				aAdd(aLog, {cArq,"D2_TES",nLinha,"TES nao existe ["+SD2->(D2_FILIAL+D2_TES)+"]"} )
		    Endif
		    // CFO
		    If !ExistCpo("SX5","13"+SD2->D2_CF,,,.F.)
				aAdd(aLog, {cArq,"D2_CF",nLinha,"CF nao existe ["+SD2->D2_CF+"]"} )
		    Endif
		    // UM
		    If !ExistCpo("SAH",SD2->D2_UM,,,.F.)
				aAdd(aLog, {cArq,"D2_UM",nLinha,"UM nao existe ["+SD2->D2_UM+"]"} )
	        Endif
		    // Tipo NF
		    If !SD2->D2_TIPO $ "NCTOBD"
				aAdd(aLog, {cArq,"D2_TIPO",nLinha,"Tipo NF Invalido ["+SD2->D2_TIPO+"]"} )
		    Endif

		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Verifica Erro na Soma entre os Itens e o Cabecalho              �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
cQuery := "SELECT D2_FILIAL||D2_DOC||D2_SERIE||D2_CLIENTE||D2_LOJA CSEEK,SUM(D2_TOTAL+D2_VALIPI+D2_ICMSRET)TOTAL	"
cQuery += " FROM "+RetSqlName("SD2")
cQuery += " WHERE D_E_L_E_T_ <> '*'													"
cQuery += " AND   D2_EMISSAO BETWEEN '"+DtoS(MV_PAR08)+"' AND '"+DtoS(MV_PAR09)+"'	"
cQuery += " GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA              	 	"
cQuery += " ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA                	"
MontaQuery("TRB","SD2",cQuery)

While !TRB->(Eof())
	// F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	If SF2->( DbSeek(TRB->CSEEK) )
		// Caso soma nao bata com Cabec
		nDif := SF2->F2_VALBRUT - TRB->TOTAL
		// Acusa erros apenas de diferen�as superiores a 0.03 Centavos (Arredondamento)
		If nDif > 0.03 .Or. nDif < -0.03
			aAdd(aLog, {cArq,"D2_DOC",0,"Soma nao bate com Cabec da NF de Saida ["+TRB->CSEEK+"]",;
			            SF2->F2_VALBRUT,TRB->TOTAL,SF2->F2_VALBRUT-TRB->TOTAL} )
		Endif
	Else
		aAdd(aLog, {cArq,"D2_DOC",0,"Cabecalho da NF de Saida nao Encontrado ["+TRB->CSEEK+"]"} )
	Endif

TRB->(DbSkip())
EndDo
// Fecha Query
TRB->(DbCloseArea())

//����������������������������������Ŀ
//� Abre Planilha do Excel com LOG   �
//������������������������������������
If Len(aLog) >=2 // Desconto o Cabec da Array
	MontaExcel(aLog,MV_PAR01,"LOG_NF_SAIDA_"+DtoS(DDataBase)+"_"+Subs(Time(),1,2)+Subs(Time(),4,2))
Endif
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � DELA999C � Autor � Ricardo Mansano    � Data �  15/12/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para Receber Livros Fiscais                         ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function DELA999C()
Local nTamFile	:= 0
Local nTamLin	:= 0
Local cBuffer	:= ""
Local nBtLidos	:= 0
Local cArq	 	:= ""
Local nHdl 		:= 0
Local lTravaRec	:= .F. // Verificara a Necessidade de Travar a Recepcao da Linha do TXT

// Limpa Log e alimenta Cabecalho inicial
aLog := {}
aAdd(aLog,{"ARQUIVO","CAMPO","LINHA","ERRO"})

//����������������������������Ŀ
//� Prepara Arquivos para Uso  �
//������������������������������
DbSelectArea("SF3")
SF3->(DbSetOrder(4)) // F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
DbSelectArea("SA1")
SA1->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA
DbSelectArea("SA2")
SA2->(DbSetOrder(1)) // A2_FILIAL+A2_COD+A2_LOJA

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Livro Fiscal                                                    �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
cArq := AllTrim(MV_PAR01)+"SF3000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif
nTamLin  := Len(cEOL)+101	// Tamanho da Linha do Arquivo TXT
cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

nLinha := 1
While nBtLidos >= nTamLin
	// Limpa erros anteriores
	lTravaRec := .F.

    //���������������������������������������������������������������������Ŀ
    //� Verifica Duplicacao de Registro                                     �
    //�����������������������������������������������������������������������
	// F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
	If SF3->( DbSeek(Subs(cBuffer,001,019)) )
		aAdd(aLog, {cArq,"LIVRO FISCAL",nLinha,"Nota Fiscal do Livro Fiscal Duplicada ["+Subs(cBuffer,001,019)+"]"} )
		lTravaRec := .T.
	Endif

    //���������������������������������������������������������������������Ŀ
    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
    //�����������������������������������������������������������������������
	If !lTravaRec
		nPos := 1 // Zera Posicao da Linha do Texto
		RecLock("SF3",.T.)
		SF3->F3_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
		SF3->F3_CLIEFOR   := Part("C", cBuffer, RetPos(nPos), IncLen(006))
		SF3->F3_LOJA      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
		SF3->F3_NFISCAL   := Part("C", cBuffer, RetPos(nPos), IncLen(006))
		SF3->F3_SERIE     := Part("C", cBuffer, RetPos(nPos), IncLen(003))
		SF3->F3_ENTRADA   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
		SF3->F3_CFO       := AllTrim(Str(Part("N", cBuffer, RetPos(nPos), IncLen(005), 05, 0)))
		SF3->F3_TIPO      := Part("C", cBuffer, RetPos(nPos), IncLen(001))
		SF3->F3_ESPECIE   := Part("C", cBuffer, RetPos(nPos), IncLen(005))
		SF3->F3_EMISSAO   := Part("D", cBuffer, RetPos(nPos), IncLen(008))
		SF3->F3_DTCANC    := Part("D", cBuffer, RetPos(nPos), IncLen(008))
		SF3->F3_OBSERV    := Part("C", cBuffer, RetPos(nPos), IncLen(030))
		SF3->F3_VALCONT   := Part("N", cBuffer, RetPos(nPos), IncLen(014), 14, 2)
		SF3->F3_FORMUL    := Part("C", cBuffer, RetPos(nPos), IncLen(001))
		SF3->F3_ESTADO    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
		SF3->(MSUnLock())
		SF3->(DbCommit())

	    //���������������������������������������������������������������������Ŀ
    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
	    //�����������������������������������������������������������������������
	    // Se for NF de Saida
	    If SF3->F3_ESPECIE == "NF"
		    // Cliente - A1_FILIAL+A1_COD+A1_LOJA
		    If !SA1->( DbSeek( xFilial("SA1")+SF3->(F3_CLIEFOR+F3_LOJA) ) )
				aAdd(aLog, {cArq,"F3_CLIEFOR",nLinha,"Cliente nao existe ["+SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA)+"]"} )
		    Endif
	    ElseIf SF3->F3_ESPECIE == "NFE" // NF de Entrada
		    // Fornecedor - A2_FILIAL+A2_COD+A2_LOJA
		    If !SA2->( DbSeek( xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA) ) )
				aAdd(aLog, {cArq,"F3_CLIEFOR",nLinha,"Fornecedor nao existe ["+SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA)+"]"} )
		    Endif
	    Endif
	    // Especie NF
	    // ExistCpo((cAlias,cSeek,nIndice,cHelp,lMostraErro)
	    If !ExistCpo("SX5","42"+SF3->F3_ESPECIE,,,.F.)
			aAdd(aLog, {cArq,"F3_ESPECIE",nLinha,"Especie nao existe ["+SF3->F3_ESPECIE+"]"} )
	    Endif
	    // CFO
	    If !ExistCpo("SX5","13"+SF3->F3_CFO,,,.F.)
			aAdd(aLog, {cArq,"F3_CFO",nLinha,"CF nao existe ["+SF3->F3_CFO+"]"} )
	    Endif
	Endif

    //���������������������������������������������������������������������Ŀ
    //� Leitura da proxima linha do arquivo texto.                          �
    //�����������������������������������������������������������������������
    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
    nLinha++
EndDo
// O arquivo texto deve ser fechado
fClose(nHdl)

//����������������������������������Ŀ
//� Abre Planilha do Excel com LOG   �
//������������������������������������
If Len(aLog) >=2 // Desconto o Cabec da Array
	MontaExcel(aLog,MV_PAR01,"LOG_LIVRO_FISCAL_"+DtoS(DDataBase)+"_"+Subs(Time(),1,2)+Subs(Time(),4,2))
Endif
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � DELA999D � Autor � Ricardo Mansano    � Data �  15/12/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para Receber Contas a Pagar/Receber/Movimentacao    ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function DELA999D()
Local nTamFile	:= 0
Local nTamLin	:= 0
Local cBuffer	:= ""
Local nBtLidos	:= 0
Local cArq	 	:= ""
Local nHdl 		:= 0
Local lTravaRec	:= .F. // Verificara a Necessidade de Travar a Recepcao da Linha do TXT

// Limpa Log e alimenta Cabecalho inicial
aLog := {}
aAdd(aLog,{"ARQUIVO","CAMPO","LINHA","ERRO"})

//����������������������������Ŀ
//� Prepara Arquivos para Uso  �
//������������������������������
DbSelectArea("SE1")
SE1->(DbSetOrder(2)) // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
DbSelectArea("SE2")
SE2->(DbSetOrder(1)) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
DbSelectArea("SE5")
SE5->(DbSetOrder(1)) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Contas a Receber                                                �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/

lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SE1000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo

If lRecebe
	nTamLin  := Len(cEOL)+133	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.
	
	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// E1_FILIAL + E1_PREFIXO+E1_NUM+E1_PARCELA + E1_TIPO                            
		//cSeek := Subs(cBuffer,001,002)+Subs(cBuffer,074,010)+Subs(cBuffer,071,003)
		//If SE1->( DbSeek(cSeek) )
		//	aAdd(aLog, {cArq,"LCTO A RECEBER",nLinha,"Lcto a Receber Duplicado ["+cSeek+"]"} )
		//	lTravaRec := .T.
		//Endif                                                                    
		
		// Mudado indice de acordo coma necessidade da Ana da DellaVia - 06/02/2006
		//         E1_FILIAL      +      E1_CLIENTE     +      E1_LOJA       +       E1_PREFIXO    +      E1_NUM         +      E1_PARCELA     +      E1_TIPO
        cSeek := Subs(cBuffer,001,002)+Subs(cBuffer,003,006)+Subs(cBuffer,009,02)+Subs(cBuffer,074,003)+Subs(cBuffer,077,006)+Subs(cBuffer,083,001)+Subs(cBuffer,071,003)
		If SE1->( DbSeek(cSeek) )
			aAdd(aLog, {cArq,"LCTO A RECEBER",nLinha,"Lcto a Receber Duplicado ["+cSeek+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SE1",.T.)
			SE1->E1_FILIAL     := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SE1->E1_CLIENTE    := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SE1->E1_LOJA       := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SE1->E1_EMIS1      := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SE1->E1_HIST       := Part("C", cBuffer, RetPos(nPos), IncLen(025))
			SE1->E1_VALOR      := Part("N", cBuffer, RetPos(nPos), IncLen(017),17,2)
			SE1->E1_MOEDA      := Part("N", cBuffer, RetPos(nPos), IncLen(002))
			SE1->E1_EMISSAO    := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SE1->E1_TIPO       := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SE1->E1_PREFIXO    := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SE1->E1_NUM        := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SE1->E1_PARCELA    := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SE1->E1_VLCRUZ     := Part("N", cBuffer, RetPos(nPos), IncLen(017),17,2)
			SE1->E1_VENCREA    := Part("D", cBuffer, RetPos(nPos), IncLen(008))

			//inicio stanko
			SE1->E1_BAIXA     := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SE1->E1_VALLIQ    := Part("N", cBuffer, RetPos(nPos), IncLen(017),17,2)
			SE1->E1_SALDO     := SE1->E1_VALOR - SE1->E1_VALLIQ

			SE1->(MSUnLock())
			SE1->(DbCommit())

		    //���������������������������������������������������������������������Ŀ
	    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
		    //�����������������������������������������������������������������������
		    // Cliente - A1_FILIAL+A1_COD+A1_LOJA
		    If !SA1->( DbSeek( xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA) ) )
				aAdd(aLog, {cArq,"E1_CLIENTE",nLinha,"Cliente nao existe ["+SE1->(E1_CLIENTE+E1_LOJA)+"]"} )
		    Endif
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	    
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Contas a Pagar                                                  �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SE2000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+134	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1

	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// E2_FILIAL + E2_PREFIXO+E2_NUM+E2_PARCELA + E2_TIPO + E2_FORNECE+E2_LOJA
		cSeek := Subs(cBuffer,001,002)+Subs(cBuffer,074,010)+Subs(cBuffer,071,003)+Subs(cBuffer,003,008)
		If SE2->( DbSeek(cSeek) )
			aAdd(aLog, {cArq,"LCTO A PAGAR",nLinha,"Lcto a Pagar Duplicado ["+cSeek+"]"} )
			lTravaRec := .T.
		Endif
		
	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SE2",.T.)
			SE2->E2_FILIAL     := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SE2->E2_FORNECE    := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SE2->E2_LOJA       := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SE2->E2_EMIS1      := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SE2->E2_HIST       := Part("C", cBuffer, RetPos(nPos), IncLen(025))
			SE2->E2_VALOR      := Part("N", cBuffer, RetPos(nPos), IncLen(017),17,2)
			SE2->E2_MOEDA      := Part("N", cBuffer, RetPos(nPos), IncLen(002))
			SE2->E2_EMISSAO    := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SE2->E2_TIPO       := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SE2->E2_PREFIXO    := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SE2->E2_NUM        := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SE2->E2_PARCELA    := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SE2->E2_VLCRUZ     := Part("N", cBuffer, RetPos(nPos), IncLen(018),18,2)
			SE2->E2_VENCREA    := Part("D", cBuffer, RetPos(nPos), IncLen(008))
		   
			//inicio stanko
			SE2->E2_BAIXA     := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SE2->E2_VALLIQ    := Part("N", cBuffer, RetPos(nPos), IncLen(017),17,2)
			SE2->E2_SALDO     := SE2->E2_VALOR - SE2->E2_VALLIQ
			//fim stanko
			 
			SE2->(MSUnLock())
			SE2->(DbCommit())

		    //���������������������������������������������������������������������Ŀ
	    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
		    //�����������������������������������������������������������������������
		    // Fornecedor - A2_FILIAL+A2_COD+A2_LOJA
		    If !SA2->( DbSeek( xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA) ) )
				aAdd(aLog, {cArq,"E2_FORNECE",nLinha,"Fornecedor nao existe ["+SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA)+"]"} )
		    Endif
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Movimentacao Financeira                                         �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SE5000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+071	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		cSeek := Subs(cBuffer,001,023)
		If SE5->( DbSeek(cSeek) )
			aAdd(aLog, {cArq,"MOVIMENTO FINANCEIRO",nLinha,"Movimento Financeiro Duplicado ["+cSeek+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SE5",.T.)
			SE5->E5_FILIAL     := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SE5->E5_PREFIXO    := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SE5->E5_NUMERO     := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SE5->E5_PARCELA    := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SE5->E5_TIPO       := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			SE5->E5_CLIFOR     := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SE5->E5_LOJA       := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SE5->E5_DTDIGIT    := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			SE5->E5_HISTOR     := Part("C", cBuffer, RetPos(nPos), IncLen(040))
			SE5->E5_SEQ        := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SE5->E5_RECPAG     := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SE5->(MSUnLock())
			SE5->(DbCommit())
			
		    //���������������������������������������������������������������������Ŀ
	    	//� Verifica demais Inconsistencias que nao impediram Recepcao          �
		    //�����������������������������������������������������������������������
		    // Se for NF de Saida
		    If SE5->E5_RECPAG == "R"
			    // Cliente - A1_FILIAL+A1_COD+A1_LOJA
			    If !SA1->( DbSeek( xFilial("SA1")+SE5->(E5_CLIFOR+E5_LOJA) ) )
					aAdd(aLog, {cArq,"E5_CLIFOR",nLinha,"Cliente nao existe ["+SE5->(E5_FILIAL+E5_CLIFOR+E5_LOJA)+"]"} )
			    Endif
		    ElseIf SE5->E5_RECPAG == "P" // NF de Entrada
			    // Fornecedor - A2_FILIAL+A2_COD+A2_LOJA
			    If !SA2->( DbSeek( xFilial("SA2")+SE5->(E5_CLIFOR+E5_LOJA) ) )
					aAdd(aLog, {cArq,"E5_CLIFOR",nLinha,"Fornecedor nao existe ["+SE5->(E5_FILIAL+E5_CLIFOR+E5_LOJA)+"]"} )
			    Endif
			Else
				aAdd(aLog, {cArq,"E5_RECPAG",nLinha,"Tipo Movimento nao existe ["+SE5->E5_RECPAG+"]"} )
		    Endif
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

//����������������������������������Ŀ
//� Abre Planilha do Excel com LOG   �
//������������������������������������
If Len(aLog) >=2 // Desconto o Cabec da Array
	MontaExcel(aLog,MV_PAR01,"LOG_CONTAS_PAGREC_"+DtoS(DDataBase)+"_"+Subs(Time(),1,2)+Subs(Time(),4,2))
Endif
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � DELA999E � Autor � Ricardo Mansano    � Data �  15/12/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para Receber Arquivos Contabeis                     ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function DELA999E()
Local nTamFile	:= 0
Local nTamLin	:= 0
Local cBuffer	:= ""
Local nBtLidos	:= 0
Local cArq	 	:= ""
Local nHdl 		:= 0
Local lTravaRec	:= .F. // Verificara a Necessidade de Travar a Recepcao da Linha do TXT

// Limpa Log e alimenta Cabecalho inicial
aLog := {}
aAdd(aLog,{"ARQUIVO","CAMPO","LINHA","ERRO"})

//����������������������������Ŀ
//� Prepara Arquivos para Uso  �
//������������������������������
DbSelectArea("CT1")
CT1->(DbSetOrder(3)) // CT1_FILIAL+CT1_CLASSE+CT1_CONTA
DbSelectArea("CT2")
CT2->(DbSetOrder(1)) // CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Centro de Custos                                                �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SI3000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+038	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Centro de Custos nao tem Campos o suficiente para Busca             �
	    //�����������������������������������������������������������������������

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SI3",.T.)
			SI3->I3_FILIAL     	:= Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SI3->I3_CUSTO    	:= Part("C", cBuffer, RetPos(nPos), IncLen(010))
			SI3->I3_DESC       	:= Part("C", cBuffer, RetPos(nPos), IncLen(025))
			c := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			SI3->(MSUnLock())
			SI3->(DbCommit())
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Plano de Contas                                                 �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"CT1000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+083	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// CT1_FILIAL+CT1_CLASSE+CT1_CONTA
		cSeek := Subs(cBuffer,001,023)
		If CT1->( DbSeek(cSeek) )
			aAdd(aLog, {cArq,"PLANO DE CONTAS",nLinha,"Plano de Contas Duplicado ["+cSeek+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("CT1",.T.)
			CT1->CT1_FILIAL  := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			CT1->CT1_CLASSE  := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			CT1->CT1_CONTA   := Part("C", cBuffer, RetPos(nPos), IncLen(020))
			CT1->CT1_CTASUP  := Part("C", cBuffer, RetPos(nPos), IncLen(020))
			CT1->CT1_DESC01  := Part("C", cBuffer, RetPos(nPos), IncLen(040))
			CT1->(MSUnLock())
			CT1->(DbCommit())
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Lancamentos Contabeis                                           �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"CT2000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+163	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		// CT2_FILIAL + DTOS(CT2_DATA) + CT2_LOTE + CT2_SBLOTE + CT2_DOC+CT2_LINHA + CT2_TPSALD + CT2_EMPORI+CT2_FILORI + CT2_MOEDLC
		cData := DtoS(CtoD( Subs(cBuffer,3,2)+"/"+Subs(cBuffer,5,2)+"/"+Subs(cBuffer,7,4) )) // Str para DtoS()
        // Space(03) eh o CT2_SBLOTE -- Space(01) eh o CT2_TPSALD
		cSeek := Subs(cBuffer,001,002)+cData+Subs(cBuffer,081,006)+Space(03)+Subs(cBuffer,087,009)+Space(1)+Subs(cBuffer,160,004)+Subs(cBuffer,012,002)
		If CT2->( DbSeek(cSeek) )
			aAdd(aLog, {cArq,"LANCAMENTOS CONTABEIS",nLinha,"Lancamento Contabil Duplicado ["+cSeek+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("CT2",.T.)
			CT2->CT2_FILIAL  := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			CT2->CT2_DATA    := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			CT2->CT2_DC      := Part("C", cBuffer, RetPos(nPos), IncLen(001))
			CT2->CT2_MOEDLC  := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			CT2->CT2_DEBITO  := Part("C", cBuffer, RetPos(nPos), IncLen(020))
			CT2->CT2_CCD     := Part("C", cBuffer, RetPos(nPos), IncLen(010))
			CT2->CT2_CREDIT  := Part("C", cBuffer, RetPos(nPos), IncLen(020))
			CT2->CT2_VALOR   := Part("N", cBuffer, RetPos(nPos), IncLen(017), 17 , 2)
			CT2->CT2_LOTE    := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			CT2->CT2_DOC     := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			CT2->CT2_LINHA   := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			CT2->CT2_HIST    := Part("C", cBuffer, RetPos(nPos), IncLen(040))
			CT2->CT2_DTLP    := Part("D", cBuffer, RetPos(nPos), IncLen(008))
			CT2->CT2_CCC     := Part("C", cBuffer, RetPos(nPos), IncLen(010))
			CT2->CT2_SEQLAN  := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			CT2->CT2_SEQHIS  := Part("C", cBuffer, RetPos(nPos), IncLen(003))
			CT2->CT2_EMPORI  := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			CT2->CT2_FILORI  := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			CT2->(MSUnLock())
			CT2->(DbCommit())
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

//����������������������������������Ŀ
//� Abre Planilha do Excel com LOG   �
//������������������������������������
If Len(aLog) >=2 // Desconto o Cabec da Array
	MontaExcel(aLog,MV_PAR01,"LOG_CONTABIL_"+DtoS(DDataBase)+"_"+Subs(Time(),1,2)+Subs(Time(),4,2))
Endif
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � DELA999F � Autor � Ricardo Mansano    � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para Receber Clientes/Fornecedores/Produtos/Bancos  ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function DELA999F()
Local nTamFile	:= 0
Local nTamLin	:= 0
Local cBuffer	:= ""
Local nBtLidos	:= 0
Local cArq	 	:= ""
Local nHdl 		:= 0
Local lTravaRec	:= .F. // Verificara a Necessidade de Travar a Recepcao da Linha do TXT

// Limpa Log e alimenta Cabecalho inicial
aLog := {}
aAdd(aLog,{"ARQUIVO","CAMPO","LINHA","ERRO"})

//����������������������������Ŀ
//� Prepara Arquivos para Uso  �
//������������������������������
//DbSelectArea("SA1")
//SA1->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA
DbSelectArea("SA2")
SA2->(DbSetOrder(1)) // A2_FILIAL+A2_COD+A2_LOJA
//DbSelectArea("SA4")
//SA4->(DbSetOrder(1)) // A4_FILIAL+A4_COD
//DbSelectArea("SB1")
//SB1->(DbSetOrder(1)) // B1_FILIAL+B1_COD

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Clientes                                                        �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SA1000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+226	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		If SA1->( DbSeek(Subs(cBuffer,001,011) ))
			aAdd(aLog, {cArq,"CLIENTES",nLinha,"Cliente Duplicado ["+Subs(cBuffer,001,011)+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SA1",.T.)
			SA1->A1_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SA1->A1_COD       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SA1->A1_LOJA      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			Part("C", cBuffer, RetPos(nPos), IncLen(020)) // Pulo
			SA1->A1_CGC       := Part("C", cBuffer, RetPos(nPos), IncLen(014))
			SA1->A1_INSCR     := Part("C", cBuffer, RetPos(nPos), IncLen(018))
			Part("C", cBuffer, RetPos(nPos), IncLen(106)) // Pulo
			SA1->A1_BAIRRO    := Part("C", cBuffer, RetPos(nPos), IncLen(030))
			Part("C", cBuffer, RetPos(nPos), IncLen(015)) // Pulo
			SA1->A1_EST       := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			Part("C", cBuffer, RetPos(nPos), IncLen(015)) // Pulo FINAL
			SA1->(MSUnLock())
			SA1->(DbCommit())
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif
/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Fornecedores                                                    �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SA2000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+216	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		If SA2->( DbSeek(Subs(cBuffer,001,011) ))
			aAdd(aLog, {cArq,"FORNECEDOR",nLinha,"Fornecedor Duplicado ["+Subs(cBuffer,001,011)+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SA2",.T.)
			SA2->A2_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SA2->A2_COD       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SA2->A2_LOJA      := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			Part("C", cBuffer, RetPos(nPos), IncLen(020)) // Pulo
			SA2->A2_CGC       := Part("C", cBuffer, RetPos(nPos), IncLen(014))
			SA2->A2_INSCR     := Part("C", cBuffer, RetPos(nPos), IncLen(018))
			Part("C", cBuffer, RetPos(nPos), IncLen(008)) // Pulo
			SA2->A2_TEL       := Part("C", cBuffer, RetPos(nPos), IncLen(018))
			SA2->A2_NOME      := Part("C", cBuffer, RetPos(nPos), IncLen(040))
			SA2->A2_END       := Part("C", cBuffer, RetPos(nPos), IncLen(040))
			SA2->A2_BAIRRO    := Part("C", cBuffer, RetPos(nPos), IncLen(020))
			SA2->A2_MUN       := Part("C", cBuffer, RetPos(nPos), IncLen(015))
			SA2->A2_EST       := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			Part("C", cBuffer, RetPos(nPos), IncLen(003)) // Pulo
			SA2->A2_CEP       := Part("C", cBuffer, RetPos(nPos), IncLen(008))
			SA2->(MsUnLock())
			SA2->(DbCommit())
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Produtos                                                        �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SB1000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+060	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		If SB1->( DbSeek(Subs(cBuffer,001,008) ))
			aAdd(aLog, {cArq,"PRODUTO",nLinha,"Produto Duplicado ["+Subs(cBuffer,001,011)+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SB1",.T.)
			SB1->B1_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SB1->B1_COD       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			Part("C", cBuffer, RetPos(nPos), IncLen(010)) // Pulo
			SB1->B1_DESC      := Part("C", cBuffer, RetPos(nPos), IncLen(030))
			SB1->B1_POSIPI    := Part("C", cBuffer, RetPos(nPos), IncLen(010))
			SB1->B1_UM        := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SB1->(MsUnLock())
			SB1->(DbCommit())
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif

/*�������������������������������������������������������������������
//�����������������������������������������������������������������Ŀ
//� Transportador                                                   �
//�������������������������������������������������������������������
//�������������������������������������������������������������������*/
lRecebe := .T.
cArq := AllTrim(MV_PAR01)+"SA4000.TXT"
nHdl := fOpen(cArq,68)
If (nHdl == -1)
    MsgAlert("O arquivo de nome "+cArq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    lRecebe := .F.
Endif
// Se confirmar existencia do Arquivo Recebe o mesmo
If lRecebe
	nTamLin  := Len(cEOL)+038	// Tamanho da Linha do Arquivo TXT
	cBuffer  := Space(nTamLin) 	// Variavel para criacao da linha do registro para leitura
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

	nLinha := 1
	While nBtLidos >= nTamLin
		// Limpa erros anteriores
		lTravaRec := .F.

	    //���������������������������������������������������������������������Ŀ
	    //� Verifica Duplicacao de Registro                                     �
	    //�����������������������������������������������������������������������
		If SA4->( DbSeek(Subs(cBuffer,001,008) ))
			aAdd(aLog, {cArq,"TRANSPORTADOR",nLinha,"Transportadora Duplicada ["+Subs(cBuffer,001,011)+"]"} )
			lTravaRec := .T.
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	    //�����������������������������������������������������������������������
		If !lTravaRec
			nPos := 1 // Zera Posicao da Linha do Texto
			RecLock("SA4",.T.)
			SA4->A4_FILIAL    := Part("C", cBuffer, RetPos(nPos), IncLen(002))
			SA4->A4_COD       := Part("C", cBuffer, RetPos(nPos), IncLen(006))
			SA4->A4_NOME      := Part("C", cBuffer, RetPos(nPos), IncLen(016))
			SA4->A4_CGC       := Part("C", cBuffer, RetPos(nPos), IncLen(014))
			SA4->(MsUnLock())
			SA4->(DbCommit())
		Endif

	    //���������������������������������������������������������������������Ŀ
	    //� Leitura da proxima linha do arquivo texto.                          �
	    //�����������������������������������������������������������������������
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    nLinha++
	EndDo
	// O arquivo texto deve ser fechado
	fClose(nHdl)
Endif
//����������������������������������Ŀ
//� Abre Planilha do Excel com LOG   �
//������������������������������������
If Len(aLog) >=2 // Desconto o Cabec da Array
	MontaExcel(aLog,MV_PAR01,"LOG_CADASTRAL_"+DtoS(DDataBase)+"_"+Subs(Time(),1,2)+Subs(Time(),4,2))
Endif

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Part()   � Autor � Ricardo Mansano    � Data �  13/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna um determinado valor a partir da Parte de um       ���
���          � arquivo texto a ser recebido                               ���
�������������������������������������������������������������������������͹��
���Parametros� cTipo   := C=aracter / N=umerico / L=ogico / D=ata         ���
���          � cTexto  := Parte do TXT a ser convertida e retornada       ���
���          � nPos    := Posicao Inicial do Texto                        ���
���          � nLen    := Porcao do TXT a ser tratada a partir do nPos    ���
���          � nSize   := Usado apenas para cTipo=N para converter Numero ���
���          � nDec    := Usado apenas para cTipo=N para converter Numero ���
�������������������������������������������������������������������������͹��
���Retorno   � xRet    := Dado tratado respeitando Type definido em cTipo ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������              '
���������������������������������������������������������������������������*/
Static Function Part(cTipo, cTexto, nPos, nLen, nSize, nDec)
Local xRet 		:= ""
Local cDados	:= ""
Default nSize	:= nLen
Default nDec	:= 0

	//�����������������������������������������������Ŀ
	//� Retorna a porcao da String definida na Funcao �
	//�������������������������������������������������
	cDados := Subs(cTexto,nPos,nLen)

	//�����������������������������������������������Ŀ
	//� Inicia Conversao de Dados                     �
	//�������������������������������������������������
	If cTipo == "C" 	// Caracter
		xRet := cDados
	ElseIf cTipo == "N"	// Numerico   14,2 00000000012345
		xRet := Val(Subs(cDados,1,nSize-nDec)+'.'+Subs(cDados,(nSize-nDec)+1,nDec))
	ElseIf cTipo == "L"	// Logico
		xRet := Iif(cDados=="T",.T.,.F.)
	ElseIf cTipo == "D"	// Data
		xRet := CtoD(Subs(cDados,1,2)+'/'+Subs(cDados,3,2)+'/'+Subs(cDados,5,4))
	Endif
Return(xRet)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RetPos   � Autor � Ricardo Mansano    � Data �  13/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Apenas retorna o nPos, feita pois na chamada da IncLen     ���
���          � o nPos origem do SubStr estava sendo corrompido            ���
���          � com esta funcao corrigi este problema                      ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function RetPos(nPos)
Return(nPos)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IncLen   � Autor � Ricardo Mansano    � Data �  13/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Auxilia na extracao de informacoes do TXT, incrementando a ���
���          � posicao no momento de leitura do cBuffer                   ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function IncLen(nLen)
	nPos += nLen
Return(nLen)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � Pergunta �Autor  � Ricardo Mansano    � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Abre Perguntas da Aplicacao                                ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Pergunta()
Local cPerg 	:= "DEL999"
Local cParArq	:= "ES_DIRARQ"

	PutSx1(cPerg,"01","Diretorio Inicial         ?","","","mv_ch1" ,"C",50,0,0,"G","","DI2","","","MV_PAR01" ,""   ,"","","" ,""   ,"","",""    ,"","","","","","","","")
	PutSx1(cPerg,"02","Nota Fiscal de Entrada    ?","","","mv_ch2" ,"C",01,0,0,"C","",""   ,"","","MV_PAR02" ,"Sim","","","" ,"Nao","","",""    ,"","","","","","","","")
	PutSx1(cPerg,"03","Nota Fiscal de Saida      ?","","","mv_ch3" ,"C",01,0,0,"C","",""   ,"","","MV_PAR03" ,"Sim","","","" ,"Nao","","",""    ,"","","","","","","","")
	PutSx1(cPerg,"04","Livros Fiscais            ?","","","mv_ch4" ,"C",01,0,0,"C","",""   ,"","","MV_PAR04" ,"Sim","","","" ,"Nao","","",""    ,"","","","","","","","")
	PutSx1(cPerg,"05","Contas a Pagar/Receber    ?","","","mv_ch5" ,"C",01,0,0,"C","",""   ,"","","MV_PAR05" ,"Sim","","","" ,"Nao","","",""    ,"","","","","","","","")
	PutSx1(cPerg,"06","Dados Contabeis           ?","","","mv_ch6" ,"C",01,0,0,"C","",""   ,"","","MV_PAR06" ,"Sim","","","" ,"Nao","","",""    ,"","","","","","","","")
	PutSx1(cPerg,"07","Dados Cadastrais          ?","","","mv_ch7" ,"C",01,0,0,"C","",""   ,"","","MV_PAR07" ,"Sim","","","" ,"Nao","","",""    ,"","","","","","","","")
	PutSx1(cPerg,"08","Data Inicial (para NFs)   ?","","","mv_ch8" ,"D",08,0,0,"G","",""   ,"","","MV_PAR08" ,""   ,"","","" ,""   ,"","",""    ,"","","","","","","","")
	PutSx1(cPerg,"09","Data Final (para NFs)     ?","","","mv_ch9" ,"D",08,0,0,"G","",""   ,"","","MV_PAR09" ,""   ,"","","" ,""   ,"","",""    ,"","","","","","","","")

	If Pergunte(cPerg,.T.)
		// Salva Parametro de Diretorio caso ele nao exista
		DbSelectArea("SX6")
		SX6->(DbSetOrder(1)) // X6_FIL+X6_VAR
		If SX6->( DbSeek(xFilial("SX6")+cParArq) )
			// Atualiza Parametro
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := MV_PAR01 // Diretorio
			SX6->(MsUnLock())
		Else
			// Cria Parametro
			RecLock("SX6",.T.)
			SX6->X6_FIL  	:= cFilial
			SX6->X6_VAR  	:= cParArq
			SX6->X6_TIPO 	:= "C"     	// Caracter
			SX6->X6_DESCRIC	:= "Diretorio inicial dos arquivos de importacao"
			SX6->X6_CONTEUD	:= MV_PAR01 // Diretorio
			SX6->X6_PROPRI	:= "U" 		// User
			SX6->(MsUnLock())
		Endif
	Endif
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � EscFile  �Autor  � Ricardo Mansano    � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Escolha do Arquivo para Recepcao de Despesas               ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function EscFile(_cDir)
Local _cStartDir := IIf( Empty( _cDir ), 'SERVIDOR', IIf( ! ':' $ _cDir, 'SERVIDOR' + _cDir , _cDir ) )
	// Opcao GETF_RETDIRECTORY -> Retorna Diretorio
	_cDir := AllTrim( cGetFile( 'Arquivo Texto | *.Txt ', 'Selecione o Arquivo', 0, _cStartDir, .T.,  GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY ) )
Return(_cDir)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � EspecDir �Autor  � Ricardo Mansano    � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � User Function esta no SXB->DI2 para trazer o Diretorio     ���
���          � onde se encontram os Arquivos de Importacao                ���
���          � A variavel _EspecDir eh uma Public criada no inicio deste  ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EspecDir()
	_EspecDir := EscFile("")
Return(.T.)

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao     �MontaExcel � Autor � Ricardo Mansano       � Data � 23/11/05 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o  � Monta e Abre uma planilha do Excel baseada em uma Array     ���
���           � A Planilha eh montada sobre um arquivo CSV que eh um TXT    ���
���           � formatado separado pelo carater ";"                         ���
���������������������������������������������������������������������������Ĵ��
���Parametros � aDados := Array que sera exportada para o Excel             ���
���           � cPath  := Diretorio onde sera salvo o arquivo Temporario    ���
���           � cNome  := Nome Arquivo LOG a ser Gerado                     ���
���������������������������������������������������������������������������Ĵ��
���Uso        � Generico                                                    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function MontaExcel(aDados,cPath,cNome)
//Local oExcelApp 	:= Nil
//Local cArquivo  	:= CriaTrab(,.F.)+".CSV"
Local cArquivo  	:= AllTrim(cNome)+".CSV"
Local nHandle   	:= fCreate(AllTrim(cPath)+cArquivo) // Cria Arquivo
Local nX			:= 0
Local nY			:= 0
Local nLenaDados	:= Len(aDados)
Local nLenaDadIt	:= Len(aDados[1])
Local cType			:= ""

    // Varre Array
    For nX := 1 to nLenaDados    
    	// Verifica Tamanho de cada Linha
    	nLenaDadIt := Len(aDados[nX])
    	For nY := 1 to nLenaDadIt

    		// Verifica se Celula da Array nao esta NIL
    		If aDados[nX,nY] <> Nil
    			// Define Tipo da Celula
	    		cType := ValType(aDados[nX,nY])
		        If cType == "N"
					fWrite(nHandle, Transform(aDados[nX,nY],"@E 999,999,999.99") + ";" )
	    	    ElseIf cType == "C"
					fWrite(nHandle, Transform(aDados[nX,nY],"") + ";" )
	    	    ElseIf cType == "L"
					fWrite(nHandle	, Iif(aDados[nX,nY],".T.",".F.") + ";" )
	    	    ElseIf cType == "D"
					fWrite(nHandle, DtoC(aDados[nX,nY]) + ";" )
	    	    Endif
	    	Else
	    		// Se for NIL alimenta apenas o pulo de Celula
				fWrite(nHandle, ";" ) // Pula linha
	    	Endif

    	Next nY

    	// Alimenta Pulo de Linha
		fWrite(nHandle, CRLF ) // Pula linha
    Next nX

	// Salva Arquivo
	fClose(nHandle)

	// Abre Planilha
	//oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open(AllTrim(cPath)+cArquivo)
	//oExcelApp:SetVisible(.T.)
Return Nil

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao     �MontaQuery � Autor � Ricardo Mansano       � Data � 23/11/05 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o  � Monta Arquivo de trabalho via Query                         ���
���������������������������������������������������������������������������Ĵ��
���Parametros � cAliasTRB  := Nome do arquivo que sera usado Ex: "TR1"      ���
���           � cAliasStru := Alias que sera usado para o TcSetField()      ���
���           � cQueryOri  := String da Queryu que sera gerada              ���
���������������������������������������������������������������������������Ĵ��
���Uso        � Generico                                                    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function MontaQuery(cAliasTRB,cAliasStru,cQueryOri)
Local aStrucTRB	:= &(cAliasStru+"->(dbStruct())") // Retorna Estrutura
Local cQuery 	:= ChangeQuery(cQueryOri)
Local nX		:= 0

MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)},"Aguarde...","Processando Dados...")
For nX := 1 To Len(aStrucTRB)
	If aStrucTRB[nX,2] <> "C" .And. FieldPos(aStrucTRB[nX,1]) <> 0
		TcSetField(cAliasTRB,aStrucTRB[nX,1],aStrucTRB[nX,2],aStrucTRB[nX,3],aStrucTRB[nX,4])
	EndIf
Next nX
Return Nil

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//���������������������������Ŀ
	//�Tratamento para tema "Flat"�
	//�����������������������������
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)