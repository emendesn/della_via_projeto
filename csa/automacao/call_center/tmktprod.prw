#INCLUDE "TMKXFUNA.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TMKDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³TmkTProd	  ³ Autor ³Fabio Rogerio Pereira  ³ Data ³ 04/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Carrega Caracteristicas do produto para todas as telas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso   	 ³ CALL CENTER    			 					  	     	    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Henry    ³10/06/05³82956 ³ Tratamento da picture do campo peso liquido  ³±±
±±³          ³        ³      ³ de acordo com o SX3                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function TmkTProd()

Local lRet		:= .F.							// Retorno da funcao	
Local aArea		:= GetArea()					// Salva a area atual
Local lTMKMCA  	:= FindFunction("U_TMKMCA")		// P.E. TMK
Local lTMKVCA  	:= FindFunction("U_TMKVCA")		// P.E. TLV
Local cProduto 	:= ""							// Codigo do Produto
Local cObs 		:= ""							// Observacao do Produto
Local oObs
Local oDlg            							// Tela 
Local nPProd 	:= 0							// Posicao do Produto no ACOLS

Local cBitPro 	:= ""							// Bitmap do produto
Local oBitPro							
Local cLocal 	:= ""                   		// Local do produto
Local cPictSB2  := SPACE(12)					// Picture do SB2
Local cNomeAlter:= ""							// Produto Alternativo
Local cGrupo    := ""							// Grupo
Local nPLocal   := 0							// Local
Local cAtend    := ""							// Codigo do Atendimento
Local cCliente  := ""							// Codigo do Cliente
Local cLoja     := ""                           // Loja do Cliente
Local cCodCont  := ""                           // Codigo do Contato
Local cCodOper  := ""                           // Codigo do Operador
Local cEnt      := ""							// Alias da Entidade
Local cChave    := ""                           // Chave da Entidade

Local nAtu   	:= 0
Local nPedVen 	:= 0
Local nEmp    	:= 0
Local nSalPedi	:= 0
Local nReserva	:= 0
Local nSaldo  	:= 0

Local nPosAnt   := 0 
Local nNAux		:= n
Local aColsAux	:= aClone(aCols)
Local aHeadAux	:= aClone(aHeader)

DEFAULT nFolder := IIf(nFolder == NIL,1,nFolder)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

If nFolder == 1  //TeleMarketing
	If TkGetTipoAte() == "1"	.OR. TkGetTipoAte() == "4"// Telemarketing ou Televendas
		nPProd    := aPosicoes[3][2]
		cAtend    := M->UC_CODIGO
		cEnt      := M->UC_ENTIDAD
		cChave    := M->UC_CHAVE
		cCodCont  := M->UC_CODCONT
		cCodOper  := M->UC_OPERADO
		If lTMKMCA
			U_TMKMCA(cAtend,cEnt,cChave,cCodCont,cCodOper)
			Return(lRet)
		Endif

	Elseif 	TkGetTipoAte() == "2"	// Televendas
		nPProd    := aPosicoes[1][2]
		nPLocal   := aPosicoes[7][2]
		cAtend    := M->UA_NUM
		cCliente  := M->UA_CLIENTE
		cLoja     := M->UA_LOJA
		cCodCont  := M->UA_CODCONT
		cCodOper  := M->UA_OPERADO
		
		If lTMKVCA
			U_TMKVCA(cAtend,cCliente,cLoja,cCodCont,cCodOper)
			Return(lRet)
		Endif
	Endif

ElseIf nFolder == 2  //Televendas
	nPProd    := aPosicoes[1][2]
	nPLocal   := aPosicoes[7][2]
	cAtend    := M->UA_NUM
	cCliente  := M->UA_CLIENTE
	cLoja     := M->UA_LOJA
	cCodCont  := M->UA_CODCONT
	cCodOper  := M->UA_OPERADO
	
	If lTMKVCA
		U_TMKVCA(cAtend,cCliente,cLoja,cCodCont,cCodOper)
		Return(lRet)
	Endif
Elseif nFolder == 4  //Configuracao de TMK	
	nPProd  := Ascan(aHeader,{|x| AllTrim(x[2])=="UF_PRODUTO"})
Endif

cProduto := aCols[n][nPProd]
If nPLocal > 0
	cLocal := aCols[n][nPLocal]
Endif

If Empty(cProduto)
	Help(" ",1,"SEM PRODUT" )
	Return(lRet)
Endif

DbSelectarea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1") + cProduto)
	cObs   := MSMM(SB1->B1_CODOBS,TamSx3("B1_OBS")[1])
	cGrupo := SB1->B1_GRUPO
	If Empty(cLocal)
		cLocal := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
	Endif
	nPosAnt:= Recno()
	
	If DbSeek(xFilial("SB1")+SB1->B1_ALTER)
		cNomeAlter := ALLTRIM(B1_COD + " - "+ ALLTRIM(B1_DESC))
	Endif
Endif

DbSelectarea("SB2")
DbSetorder(1)
If DbSeek(xFilial("SB2") + cProduto + cLocal)
	nAtu   	:= B2_QATU
	nPedVen := B2_QPEDVEN
	nEmp    := B2_QEMP
	nSalPedi:= B2_SALPEDI
	nReserva:= B2_RESERVA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Compatibilizacao com o SIGAFAT - Tecla F4 Visualizacao do estoque³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo  := SaldoSb2(,GetNewPar("MV_QEMPV",.T.))
Endif

DbSelectarea("SB5")
DbSeek(xFilial("SB5") + cProduto)

DbSelectarea("SX3")
DbSetorder(2)
If DbSeek("B2_QATU")
	cPictSB2 := SX3->(X3_PICTURE)
Endif

DbSelectarea("SX5")
DbSetorder(1)
If DbSeek(xFilial("SX5")+"03"+cGrupo)
	cGrupo := X5DESCRI()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra dados do Produto.					                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM 23,181 TO 402,723 TITLE (STR0021) PIXEL //"Caracteristicas do produto" 370/410
	DbSelectarea("SB1")
	DbGoto(nPosAnt)              
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados das caracteristicas do produto                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@06,02 TO 43,270 LABEL (STR0022) OF oDlg PIXEL COLOR CLR_BLUE //Dados do Produto 

	@13,04  SAY (STR0023) SIZE  21,7 OF oDlg PIXEL //"C¢digo" 
	@13,29  SAY SB1->B1_COD SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE
	
	@13,80  SAY (STR0024) SIZE  20,7 OF oDlg PIXEL //"Unidade" 
	@13,102 SAY SB1->B1_UM SIZE  10,8 OF oDlg PIXEL COLOR CLR_BLUE
	
	@13,115 SAY (STR0025) SIZE  18,7 OF oDlg PIXEL //"Grupo"
	@13,135 SAY cGrupo SIZE 40,8 OF oDlg PIXEL COLOR CLR_BLUE
	
	@13,155 SAY (STR0026) SIZE  70,7 OF oDlg PIXEL //"Qtd. Embalagem"
	@13,225 SAY Transform(RetFldProd(SB1->B1_COD,"B1_QE"),PesqPict("SB1","B1_QE")) SIZE  35,7 OF oDlg PIXEL COLOR CLR_BLUE
	
	@23, 4  SAY (STR0027) SIZE  32, 7 OF oDlg PIXEL //"Descri‡„o" 
	@23,33  SAY SB1->B1_DESC SIZE 140, 8 OF oDlg PIXEL COLOR CLR_BLUE
	
	@23,155 SAY (STR0028) SIZE  60,7 OF oDlg PIXEL //"Peso Liquido" 
	@23,225 SAY Transform(SB1->B1_PESO,PesqPict("SB1","B1_PESO")) SIZE  35,7 OF oDlg PIXEL COLOR CLR_BLUE
	
	@33, 4  SAY (STR0029) SIZE  80,7 OF oDlg PIXEL //"Produto Alternativo" 
	@33,90  SAY cNomeAlter SIZE 138, 8 OF oDlg PIXEL COLOR CLR_BLUE
	
	cBitPro := SB1->B1_BITMAP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega a imagem do produto                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@45,02 TO 152,105 LABEL (STR0038) OF oDlg PIXEL  //"Foto" 193/105
	If Empty(SB1->B1_BITMAP)
		@ 80,30 SAY (STR0039) SIZE 50,8 PIXEL COLOR CLR_BLUE OF oDlg //"Foto n„o disponivel" 
	Else
		@ 50,04 REPOSITORY oBitPro OF oDlg NOBORDER SIZE 100,100 PIXEL
		Showbitmap(oBitPro,SB1->B1_BITMAP,"")
		oBitPro:lStretch:=.F.
		oBitPro:Refresh()
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega as observa‡ao sobre o produto B1_OBS         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@45,110 TO 152,270 LABEL (STR0040) OF oDlg PIXEL  //"Observa‡oes" 
	@51,115 GET oObs VAR cObs OF oDlg MEMO Size 150,99 PIXEL READONLY

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Saldo do estoque do produto                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@153,02 TO 188,155 LABEL (STR0030) OF oDlg PIXEL  // Estoque 
	
	@158, 04 SAY (STR0031) SIZE  33, 7 OF oDlg PIXEL //"Ped. Abertos" 
	@158, 42 SAY Transform(nPedVen,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
	@168, 04 SAY (STR0032) SIZE  33, 7 OF oDlg PIXEL //"a Entrar" 
	@168, 42 SAY Transform(nSalPedi,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
	@178, 04 SAY (STR0033) SIZE  33, 7 OF oDlg PIXEL //"Atual"
	@178, 42 SAY Transform(nAtu,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
	@158, 83 SAY (STR0034) SIZE  33, 7 OF oDlg PIXEL //"Empenho" 
	@158,110 SAY Transform(nEmp,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
	@168, 83 SAY (STR0035) SIZE  33, 7 OF oDlg PIXEL //"Reservado" 
	@168,110 SAY Transform(nReserva,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
	@178, 83 SAY (STR0036) SIZE  33, 7 OF oDlg PIXEL //"Dispon¡vel" 
	@178,110 SAY Transform(nSaldo,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

//	@154,160 BUTTON STR0057 SIZE 50,15 OF oDlg PIXEL ACTION TKDetalhes(nFolder) 		  		//"Complemento"

//	@154,220 BUTTON STR0058 SIZE 50,15 OF oDlg PIXEL ACTION TKVisuProd(cProduto,cLocal)   		//"Produto"

//	@175,160 BUTTON STR0059 SIZE 50,15 OF oDlg PIXEL ACTION TKTabela(cProduto) 					//"Tabela"

	@175,220 BUTTON "OK" SIZE 50,15 OF oDlg PIXEL ACTION (lRet := .T.,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER

Restarea(aArea)
n		:= nNAux
aCols	:= aClone(aColsAux)
aHeader	:= aClone(aHeadAux)

Return(lRet)