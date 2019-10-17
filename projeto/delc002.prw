#INCLUDE "PROTHEUS.CH"
#INCLUDE "DELC002.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELC002A บAutor  ณRicardo Mansano     บ Data ณ  19/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina foi uma adequacao dos programas do TMKXFUND para    บฑฑ
ฑฑบ          ณ liberar na consulta de Orcamentos e Produtos todos os      บฑฑ
ฑฑบ          ณ registros, independente da Filial em que se esteja con-    บฑฑ
ฑฑบ          ณ sultando.                                                  บฑฑ
ฑฑบ          ณ OBS.: Esta consulta multi-filial nao funcionara em C-Tree  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cCliente = M->LQ_CLIENTE                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamada atravez do PE. LJ7016 na tela de Venda Assistida   บฑฑ
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
Project Function DELC002A( cCliente )
Local nPosProduto 	:= aScan( aHeader, { |x| x[2] == "LR_PRODUTO" } )
Private nFolder 	:= 1 		// Variavel utilizada na funcao TkHistLoj
Private _cCliente 	:= cCliente

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Desabilita as teclas de atalho                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Lj7SetKeys(.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chama a tela do historico - Rotina Redesenhada por exigencia do          ณ
//ณ Projeto da Della Via Pneus.                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

TkHistLoj( cCliente, IIf( aCols[ n, Len(aCols[n]) ], "", aCols[n,nPosProduto] ) )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Habilita as teclas de atalho                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Lj7SetKeys(.T.)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELC002B บAutor  ณRicardo Mansano     บ Data ณ  20/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Tela com Enchoice e GetDados para visualizacao dos orca-   บฑฑ
ฑฑบ          ณ mentos em SL1 e SL2                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Venda Assistida (Loja701)                                  บฑฑ
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
Project Function DELC002B()
Local oDlg
Local oGetD
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= MsAdvSize()
Local aInfo     	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local nUsado		:= 0 
Local nX			:= 0
Local nReg	 		:= 1
Local nOpc   		:= 2 // Visualiza=2 / Inclui=3 / Altera=4 / Exclui=5
Local naCols		:= 0   
Local nTot			:= 0 // Total no Rodape
Local oFnt
// Carrega Campos da Enchoice
Local aCpoEnchoice 	:= {"L1_NUM","L1_CLIENTE","L1_LOJA","L1_NOMCLI",,"L1_VEND","L1_NOMVEND","L1_DTLIM","L1_PLACAV",;
						"L1_CODMAR","L1_DESCMAR","L1_CODMOD","L1_DSCMOD","L1_ANO","L1_OBSVEIC",;
						"L1_CODCON","L1_DESCON","L1_CODTAB"}
// Carrega Campos Alteraveis da Enchoice                          
Local aAltEnchoice 	:= {}
Local lVirtual 		:= .F. 
Local nLinhas 		:= 100 // Numero de linhas Permitido na GetdDados
Local aButtons    	:= {}
Local aCpoGDa		:= { "L2_ITEM", "L2_PRODUTO", "L2_DESCRI", "L2_QUANT", "L2_VRUNIT", "L2_VLRITEM",;
				 		  "L2_UM", "L2_DESC", "L2_VALDESC", "L2_ENTREGA" }	

Private cAliasE 	:= "SL1"
Private cAliasG 	:= "SL2"
Private aHeader 	:= {}
Private aCols   	:= {}
Private aRotina 	:= {{"Pesquisar","AxPesqui"   ,0,1},;
						{"Visual"   ,"AxVisual"  ,0,2},;
						{"Incluir"  ,"AxInclui"  ,0,3} }
Private aGets   	:= Array(0)
Private aTELA 		:= Array(0,0)
Private Visualiza	:= (nOpc == 2)

// Carrega aHeader

dbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
for nX := 1 to Len(aCpoGDa)
	If DbSeek(aCpoGDa[nX])
		nUsado++
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO	,;
			SX3->X3_PICTURE	,;
			SX3->X3_TAMANHO	,;
			SX3->X3_DECIMAL	,;
			SX3->X3_VALID	,;
			SX3->X3_USADO	,;
			SX3->X3_TIPO	,;
			"",;//SX3->X3_F3 		,;
			SX3->X3_CONTEXT	,;
			"",;//SX3->X3_CBOX	,;
			SX3->X3_RELACAO} )
	Endif
Next nX

// Carrega Dados na aCols
RegToMemory( "SL1", .F. )       
DbSelectArea("SL2")
SL2->(DbSetOrder(1)) // Filial + Numero + Item + Produto
If SL2->(DbSeek(M->L1_FILIAL+M->L1_NUM))

	nTot := 0 // Zera Totalizador
	While !SL2->(Eof()) .And. ((M->L1_FILIAL+M->L1_NUM) == SL2->(L2_FILIAL+L2_NUM))
		// Acumula Totalizador
		nTot += SL2->L2_VLRITEM        

		aAdd(aCols,Array(nUsado+1))
		naCols := Len(aCols) // Conto aCols aqui para evitar recontagem no FOR

		For nX := 1 To nUsado
			If aHeader[nX][10] <> "V" // Ignora os campos Virtuais
				aCols[naCols,nX] := FieldGet(FieldPos(aHeader[nX,2]))
			EndIf
		Next nX
		aCols[Len(aCols),nUsado+1] := .F.
		
		// Carrega o aCols com o conteudo dos campos
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] == "V" // Ignora os campos Virtuais
				Loop
			EndIf

			// Carrega valores no aCols
			aCols[naCols,nX] := FieldGet(FieldPos(aHeader[nX,2]))
		Next nX
		
	SL2->(DbSkip())
	EndDo
Endif

// Definicoes de Resolucao da Tela
aObjects := {}
AADD(aObjects,{100,080,.T.,.F.,.F.})
AADD(aObjects,{100,085,.T.,.T.,.F.})
AADD(aObjects,{000,15, .T., .F. } )
aPosObj := MsObjSize( aInfo, aObjects )

// Fonte
DEFINE FONT oFnt NAME "Arial" SIZE 08,17 BOLD

DEFINE MSDIALOG oDlg TITLE "Visualiza Or็amento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	EnChoice(cAliasE,nReg,nOpc,,,,aCpoEnchoice,;
	        {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},;
	        aAltEnchoice,3,,,,,,lVirtual)

	oGetD := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],;
	         nOpc,,,,.T.,,,,nLinhas,)
	
	// Rodape
	@ aPosObj[3,1]+4,010 Say "Total do Or็amento:" Pixel Of oDlg
	@ aPosObj[3,1]+3,060 SAY str(nTot) VAR Transform(nTot,"@E 999,999.99")	SIZE 065,10 OF oDlg	 PIXEL RIGHT COLOR CLR_HRED	FONT oFnt
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| (oDlg:End()) },{||oDlg:End()},,aButtons)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณTkHistLoj บAutor  ณRafael M Quadrotti  บ Data ณ  05/21/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDialog com os orcamentos e pedidos gerados a partir do      บฑฑ
ฑฑบ          ณSigaloja                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ ExpC1 : Codigo do cliente                                  บฑฑ
ฑฑบ          ณ ExpC2 : Codigo do Produto                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 -Call Center                                           บฑฑ
ฑฑณAnalista  ณData    ณVersaoณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณMarcelo K ณ04/12/02ณ609   ณ-O total do rodape nao esta sendo somado    ณฑฑ
ฑฑณRafael Q. ณ10/12/02ณ609   ณ-Alterada validacao para p/ carregar a variแณฑฑ
ฑฑณ          ณ        ณ      ณvel cMoeda.                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TkHistLoj(cCliente,cProduto,cTip)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao das Variaveis.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea 	:= GetArea()			//Salva a area anterior 
Local aAlias	:= {}	
Local oDlg								//Tela
Local cCadastro := STR0001 				//"Consulta de orcamentos SigaLoja"
Local cCgc		:= RetTitle("A1_CGC")
Local cMoeda    := IIf(SA1->A1_MOEDALC > 0, AllTrim(Transform(SA1->A1_MOEDALC,"99")), GetMv("MV_MCUSTO"))
Local aSavAhead := If(Type("aHeader")=="A",aHeader,{})
Local aSavAcol  := If(Type("aCols")=="A",aCols,{})
Local nSavN     := If(Type("aCols")=="A",n,0)
Local cColor    := CLR_BLUE
Local nCasas 	:= GetMv("MV_CENT")
Local lRet		:= .F.	

cTip 	:= IIF(cTip == NIL,"1",cTip) 
cMoeda 	:= " "+Pad(Getmv("MV_SIMB"+cMoeda),4)

If Empty( cCliente )
	Help(" ",1,"SEM CLIENT" )
	Return(lRet)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem da tela.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DEFINE MSDIALOG oDlg FROM	09,0 TO 28,80 TITLE cCadastro OF oMainWnd
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDados do Cliente.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ 001,002 TO 043, 267 OF oDlg	PIXEL
	
	@ 004,005 SAY STR0002    	SIZE 025,07  OF oDlg PIXEL //"Codigo"
	@ 012,004 SAY SA1->A1_COD   SIZE 070,09  COLOR cColor OF oDlg PIXEL
	
	@ 004,077 SAY STR0003    	SIZE 020,07  OF oDlg PIXEL //"Loja"
	@ 012,077 SAY SA1->A1_LOJA  SIZE 021,09  COLOR cColor OF oDlg PIXEL
	
	@ 004,100 SAY STR0004    	SIZE 025,07  OF oDlg PIXEL //"Nome"
	@ 012,100 SAY SA1->A1_NOME  SIZE 150,09  COLOR cColor OF oDlg PIXEL
	
	@ 023,005 SAY cCGC       	SIZE 025,07  OF oDlg PIXEL
	@ 030,004 SAY SA1->A1_CGC   SIZE 070,09  PICTURE PesqPict("SA1","A1_CGC") COLOR cColor  OF oDlg PIXEL
	
	@ 023,077 SAY STR0005    	SIZE 025,07  OF oDlg PIXEL //"Telefone"
	@ 030,077 SAY SA1->A1_TEL   SIZE 060,09  PICTURE PesqPict("SA1","A1_TEL") COLOR cColor  OF oDlg PIXEL
	
	@ 023,141 SAY RetTitle("A1_VENCLC") SIZE 035,07  OF oDlg PIXEL
	@ 030,141 SAY SA1->A1_VENCLC        SIZE 060,09  COLOR cColor OF oDlg PIXEL
	
	@ 023,206 SAY STR0006   SIZE 035,07  OF oDlg PIXEL //"Vendedor"
	@ 030,206 SAY SA1->A1_VEND  	     SIZE 053,09  COLOR cColor OF oDlg PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณItens da tela.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ 045,002 TO 107, 267 OF oDlg	PIXEL
	
	@ 051,005 SAY STR0009        	SIZE 042,07 OF oDlg PIXEL //"Saldo Atual"
	@ 049,058 SAY SA1->A1_SALDUP    SIZE 053,09 PICTURE Tm(SA1->A1_SALDUP,15,nCasas) COLOR cColor  OF oDlg PIXEL
	
	@ 062,005 SAY STR0010+cMoeda 	SIZE 047,07 OF oDlg PIXEL //"Maior Compra"
	@ 060,058 SAY SA1->A1_MCOMPRA   SIZE 053,09 PICTURE Tm(SA1->A1_MCOMPRA,15,nCasas) COLOR cColor  OF oDlg PIXEL
	
	@ 073,005 SAY STR0011+cMoeda 	SIZE 047,07 OF oDlg PIXEL //"Maior Saldo "
	@ 071,058 SAY SA1->A1_MSALDO    SIZE 053,09 PICTURE Tm(SA1->A1_MSALDO,15,nCasas)  COLOR cColor  OF oDlg PIXEL
	
	@ 085,005 SAY STR0012+cMoeda 	SIZE 052,07 OF oDlg PIXEL //"Saldo Atual em "
	@ 083,058 SAY SA1->A1_SALDUPM   SIZE 053,09 PICTURE Tm(SA1->A1_SALDUPM,15,nCasas) COLOR cColor   OF oDlg PIXEL
	
	@ 096,005 SAY STR0013        	SIZE 047,07 OF oDlg PIXEL //"Limite Crdito"
	@ 094,058 SAY SA1->A1_LC        SIZE 053,09 PICTURE Tm(SA1->A1_LC,15,nCasas)  COLOR cColor OF oDlg PIXEL
	
	@ 051,152 SAY STR0014         	SIZE 047,07 OF oDlg PIXEL //"Primeira Compra"
	@ 049,206 SAY SA1->A1_PRICOM    SIZE 053,09  COLOR cColor OF oDlg PIXEL
	
	@ 062,152 SAY STR0015         	SIZE 047,7 OF oDlg PIXEL //"Ultima Compra"
	@ 060,206 SAY SA1->A1_ULTCOM    SIZE 053,09  COLOR cColor OF oDlg PIXEL
	
	@ 073,152 SAY STR0016         	SIZE 047,07 OF oDlg PIXEL //"Maior Atraso"
	@ 071,206 SAY SA1->A1_MATR      SIZE 053,09 PICTURE "@9" COLOR cColor OF oDlg PIXEL
	
	@ 085,152 SAY STR0017         	SIZE 047,07 OF oDlg PIXEL //"Media de Atraso"
	@ 083,206 SAY SA1->A1_METR      SIZE 053,09 PICTURE "@9"  COLOR cColor OF oDlg PIXEL
	
	@ 096,152 SAY STR0018         	SIZE 047,07 OF oDlg PIXEL //"Grau de Risco"
	@ 094,206 SAY SA1->A1_RISCO     SIZE 053,09  COLOR cColor OF oDlg PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRodape.     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤู
	@ 115,002 TO 139, 114 OF oDlg	PIXEL
	@ 109,002 SAY STR0019  SIZE 061,07 OF oDlg PIXEL //"Cheques Devolvidos"
	@ 109,121 SAY STR0020  SIZE 061,07 OF oDlg PIXEL //"Titulos Protestados"
	
	@ 115,121 TO 139, 267 OF oDlg	PIXEL
	@ 118,005 SAY STR0021  SIZE 034,07 OF oDlg PIXEL //"Quantidade"
	@ 118,045 SAY STR0022  SIZE 066,07 OF oDlg PIXEL //"Ultimo Devolvido"
	@ 118,126 SAY STR0021  SIZE 034,07 OF oDlg PIXEL //"Quantidade"
	@ 118,163 SAY STR0023  SIZE 063,07 OF oDlg PIXEL //"Ultimo Protesto"
	
	@ 126,006 SAY SA1->A1_CHQDEVO     SIZE 024,08  COLOR cColor OF oDlg PIXEL
	@ 126,045 SAY SA1->A1_DTULCHQ     SIZE 034,08  COLOR cColor OF oDlg PIXEL
	@ 126,126 SAY SA1->A1_TITPROT     SIZE 024,08  COLOR cColor OF oDlg PIXEL
	@ 126,163 SAY SA1->A1_DTULTIT     SIZE 034,08  COLOR cColor OF oDlg PIXEL
	
	@ 003,272 BUTTON STR0024 SIZE 40,12 FONT oDlg:oFont ACTION (lRet:= .T.,TkBrowse(1,@aAlias,.T.)) OF oDlg PIXEL //Orcamentos
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณO botao de consulta por Produto e valido somente para as rotinas de Telemarketing e Televendas      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (nFolder <> 3) 
	 	IF(cTip <> "3") //Para CRM  "3" = Telecobranca
			@ 020,272 BUTTON STR0045 SIZE 40,12 FONT oDlg:oFont ACTION (lRet:= .T.,TkBrowse(2,@aAlias,.T.,cProduto)) OF oDlg PIXEL //produto
        Endif
    Endif

	@ 043,272 BUTTON STR0055 SIZE 40,12 FONT oDlg:oFont ACTION (Lj010Brow({'SA1'},Recno())) OF oDlg PIXEL //"Tit Aberto"
	
	@ 130,272 BUTTON STR0025 SIZE 40,12 FONT oDlg:oFont ACTION (lRet:= .F.,oDlg:End()) OF oDlg PIXEL //"Sair"

ACTIVATE MSDIALOG oDlg CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a Integridade dos Dados                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeader := aSavAHead
aCols   := aSavaCol
n       := nSavN

DbSelectArea("SA1")
RestArea(aArea)

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ	Funcao	 ณ	TkBrowseณAutor  ณRafael M. Quadrotti    ณ Data ณ22.05.2001ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDesc.     ณ Pesquisa e exibe Orcamentos e Pedidos Feitos no SigaLoja   ณฑฑ
ฑฑณ          ณ referentes ao cliente posicionado.                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpN1 : nOpcao                                             ณฑฑ
ฑฑณ          ณ         [1] Orcamentos                                     ณฑฑ
ฑฑณ          ณ         [2] Pedidos                                        ณฑฑ
ฑฑณ          ณ ExpA2 : Alias a Serem Fechados.                            ณฑฑ
ฑฑณ          ณ ExpL4 : Indica se os dados devem ser exibidos              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function TkBrowse(nBrowse,aAlias,lExibe,cProduto)

Local aArea		:= GetArea()
Local aAreaSL1  := SL1->(GetArea())
Local aAreaSL2  := SL2->(GetArea())
Local aStru		:= {}
Local aQuery    := {}
Local aGet      := {"",""}
Local oLbx
Local nCntList
Local aCampos   := {}
Local oDlg
Local oBtn
Local bVisual
Local bWhile
Local cAlias	:= ""
Local cArquivo  := ""
Local cCadastro := ""
Local cQry		:= ""
Local cChave	:= ""
Local lQuery    := .F.
Local nCntFor   := 0
Local nPosProduto 	:= aScan( aHeader, { |x| x[2] == "LR_PRODUTO" } )
Local _aArea  := {} // Array que contera o GetArea        
Local _aAlias := {} // Array que contera o                 

#IFDEF TOP
	Local cQuery    := ""
#ENDIF

Private aHeader := {}

P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4","SM0"}) // Salva Aliases
aAlias := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica qual botao foi executadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do Case
	Case (nBrowse == 1)
		 cCadastro	:= STR0046 //"Orcamentos X Faturamento"
		 cAlias		:= "TKQRY01"
		 bVisual		:= {|| TKVisuaSL1((cAlias)->XX_RECNO,nBrowse) }

	Case (nBrowse == 2)
		 cCadastro	:= STR0047 //"Orcamentos X Produtos"
	 	 cAlias		:= "TKQRY02"
	 	 // Posiciona o SB1 para pegar o produto selecionado na aCols
	     Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosProduto],"B1_COD")
	 	 
		 bVisual		:= {|| TKVisuaSL1((cAlias)->XX_RECNO,nBrowse) }
    	 If Empty(cProduto)
    		Help(" ",1,"SEM PRODUT" )
    		Return .F.
         Endif 
EndCase

DbSelectArea("SX3")
DbSetOrder(2)

Do Case
	Case (nBrowse == 1)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAdiciona Campos que serao visualizados do SL1.                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If DbSeek("L1_FILIAL")
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_CLIENTE")
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_LOJA")
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_NUM")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_EMISSAO")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_HORA")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_VEND")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_VLRTOT")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_DESCONT")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_DESCNF")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_DOC")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
				
		If DbSeek("L1_SERIE")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_DTLIM")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_CONDPG")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L1_EMISNF")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		aadd(aStru,{"XX_RECNO","N",12,0})
		
		SX3->(DbSetOrder(1))
		
		If ( Select(cAlias) ==	0 )
			
			cArquivo := CriaTrab(aStru,.T.)
			aadd(aAlias,{ cAlias , cArquivo })
			
			DbUseArea(.T.,,cArquivo,cAlias,.T.,.F.)
			IndRegua(cAlias,cArquivo,"L1_FILIAL+L1_CLIENTE+L1_LOJA+DTOS(L1_EMISSAO)",,,STR0040)
			
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSeleciona os campos a serem visualizados posteriormente.                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nCntFor :=1 To Len(aStru)
				If (ALLTRIM(aStru[nCntFor][1])=="L1_FILIAL")  .OR. ;
				   (ALLTRIM(aStru[nCntFor][1])=="L1_CLIENTE") .OR. ;
				   (ALLTRIM(aStru[nCntFor][1])=="L1_LOJA")
					Loop
				Else
					Aadd (aCampos,{aStru[nCntFor][1]})
				Endif
			Next nCntFor
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta a pesquisa     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQry := "SL1"
			
			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := ""
					aEval(aQuery,{|x| cQuery += ","+ALLTRIM(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)
					cQuery +=         ",SL1.R_E_C_N_O_ SL1RECNO"
					cQuery += "FROM "+RetSqlName("SL1")+" SL1,"
					cQuery += "WHERE " // Mansano SL1.L1_FILIAL='"+xFilial("SL1")+"' AND "
					cQuery +=		  "SL1.L1_CLIENTE='"+SA1->A1_COD+"' AND "
					cQuery +=		  "SL1.L1_LOJA='"+SA1->A1_LOJA+"' AND "
					cQuery +=		  "SL1.D_E_L_E_T_<>'*'"
					
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"
					
					DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)
					
					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				Endif
			#ENDIF
			
			DbSelectArea(cQry)
			If ( !lQuery )
				DbSetOrder(6)
				// Mansano - Mantive o pois a Loja em DBF soh tera dados de Venda dela propria
				If DbSeek(xFilial("SL1")+SA1->A1_COD+SA1->A1_LOJA)
					bWhile := {|| !Eof() .AND. (xFilial("SL1") == SL1->L1_FILIAL)  .AND. ;
					(SA1->A1_COD    == SL1->L1_CLIENTE) .AND. ;
					(SA1->A1_LOJA   == SL1->L1_LOJA)}
				Else
					Help(" ",1,"REGNOIS")	
				    aEval(aAlias,{|x| (x[1])->(DbCloseArea()),Ferase(x[2]+GetDbExtension()),Ferase(x[2]+OrDbagExt())})
					RestArea(aAreaSL1)
					RestArea(aAreaSL2)
					RestArea(aArea)
				    Return .F.
				Endif
			Else
				bWhile := {|| !Eof() }
			Endif
			
			While ( Eval(bWhile) )
				
				DbSelectArea(cAlias)
				DbSetOrder(1)
				cChave := (cQry)->(L1_FILIAL)+(cQry)->(L1_NUM)
				If ( !DbSeek(cChave) )
					RecLock(cAlias,.T.)
				Else
					RecLock(cAlias,.F.)
				Endif
				
				For nCntFor := 1 To Len(aStru)
					
					Do Case
						Case ( ALLTRIM(aStru[nCntFor][1])=="XX_RECNO" )
							If ( lQuery )
								(cAlias)->XX_RECNO := (cQry)->SL1RECNO
							Else
								(cAlias)->XX_RECNO := SL1->(RecNo())
							Endif
						OtherWise
							(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
					EndCase
				Next nCntFor
				
				DbSelectArea(cAlias)
				MsUnLock()
				DbSelectArea(cQry)
				DbSkip()
			End
			
			If ( lQuery )
				DbSelectArea(cQry)
				DbCloseArea()
			Endif
		Endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTotais da Consulta                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aGet[1] := 0
		aGet[2] := 0               
		DbSelectArea(cAlias)

		// Mansano - Comentei o Seek e Coloquei um GoTop() para pegar todos os Or็amentos independente da Loja
		//DbSeek(xFilial("SL1"))
		TKQRY01->(DbGoTop())

		While !EOF()
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVlr. Total. 	    	  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aGet[2] += L1_VLRTOT
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTotais dos Orcamentos  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Empty(L1_DOC)
				aGet[1] += L1_VLRTOT
			Endif
			 
			DbSkip()
		End                                                      
		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,2))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,2))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExibe os dados Gerados                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If ( lExibe )  
			DbSelectArea(cAlias)  // TKQRY01

			// Mansano - Comentei o Seek e Coloquei um GoTop() para pegar todos os Or็amentos independente da Loja
			//If DbSeek(xFilial("SL1"))
			TKQRY01->(DbGoTop())
			
				DEFINE MSDIALOG oDlg FROM	09,0 TO 28,80 TITLE cCadastro OF oMainWnd
			
					@ 001,002 TO 029,267 OF oDlg	PIXEL
		    	
					@ 004,005 SAY STR0007 SIZE 028,07  OF oDlg PIXEL //"CLIENTE" 
					@ 012,005 SAY SA1->A1_COD        SIZE 060,09  COLOR CLR_BLUE OF oDlg PIXEL
		
					@ 004,040 SAY STR0008 SIZE 020,07  OF oDlg PIXEL //"Loja"
					@ 012,040 SAY SA1->A1_LOJA       SIZE 021,09  COLOR CLR_BLUE OF oDlg PIXEL
		
					@ 004,080 SAY STR0004 SIZE 025,07  OF oDlg PIXEL //"Nome"
					@ 012,080 SAY SA1->A1_NOME       SIZE 165,09  COLOR CLR_BLUE OF oDlg PIXEL
		
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณEstrutura do arquivo de trabalhoณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					//("L1_FILIAL")
					//("L1_CLIENTE")
					//("L1_LOJA")
					//("L1_NUM")
					//("L1_EMISSAO")
					//("L1_HORA")
					//("L1_VEND")
					//("L1_VLRTOT")
					//("L1_DESCONT")		  
					//("L1_DESCNF")		
					//("L1_DOC")
					//("L1_SERIE")
					//("L1_DTLIM")
					//("L1_CONDPG")	
					//("L1_EMISNF")
					//("XX_RECNO")               
					
					@35,02 LISTBOX oLbx VAR nCntList;
						FIELDS ;
							TkStatusSL1(IIF(ALLTRIM(TKQRY01->L1_DOC)="","1","2")),;
							TKQRY01->L1_FILIAL,; // Mansano
							Posicione("SM0",1,SUBS(cNumEmp,1,2)+TKQRY01->L1_FILIAL,"M0_NOME"),;
							TKQRY01->L1_NUM            ,;
							DTOC(TKQRY01->L1_EMISSAO) ,;
							TKQRY01->L1_HORA           ,;
							Posicione("SA3",1,xFilial("SA3")+TKQRY01->L1_VEND,"A3_NOME"),;
							Transform(TKQRY01->L1_DESCONT,Tm(TKQRY01->L1_DESCONT,15,2)) ,;
							TKQRY01->L1_DESCNF         ,;
							Transform(TKQRY01->L1_VLRTOT,Tm(TKQRY01->L1_VLRTOT,15,2)) ,;
							TKQRY01->L1_DOC            ,;
							TKQRY01->L1_SERIE          ,;
							DTOC(TKQRY01->L1_DTLIM)    ,;
							Posicione("SE4",1,xFilial("SE4")+TKQRY01->L1_CONDPG,"E4_DESCRI"),;
							DTOC(TKQRY01->L1_EMISNF)    ;
						HEADER ;              
					 		"",;
					 		STR0056 ,; //"Loja DV"   Mansano
					 		STR0057 ,; //"Descricao" Mansano  
					 		STR0034 ,; //"N. Orcamento"
						 	STR0035 ,; //"Emissao "
						 	STR0048 ,; //"Hora"
						 	STR0006 ,; //"Vendedor"
					 		STR0049 ,; //"Vlr. Desconto"
					 		STR0050 ,; //"% Desconto"
					 		STR0036 ,; //"Total"
							STR0037 ,; //"N.Fiscal"
							STR0038 ,; //"Serie"
							STR0051 ,; //"Validade Orc."
							STR0052 ,; //"Cond. Pagto."			
							STR0039 ; //"Data de emissao"
						ALIAS "TKQRY01" SIZE 306,90 OF oDlg PIXEL 
						// Mansano ;
						//SELECT TKQRY01->L1_FILIAL+TKQRY01->L1_CLIENTE+TKQRY01->L1_LOJA;                                                                   
						//FOR TKQRY01->L1_FILIAL+TKQRY01->L1_CLIENTE+TKQRY01->L1_LOJA TO TKQRY01->L1_FILIAL+TKQRY01->L1_CLIENTE+TKQRY01->L1_LOJA

						oLbx:Refresh()
		    
        			@ 126,005 SAY STR0041 SIZE 080,07 OF oDlg PIXEL  //"Totais de orcamentos"
					If cPaisLoc == "BRA"
						@ 126,040 SAY aGet[1] SIZE 060,07 OF oDlg PIXEL
					Else
						@ 126,060 SAY aGet[1] SIZE 060,07 OF oDlg PIXEL
					Endif
		
					@ 126,210 SAY STR0026 SIZE 025,07 OF oDlg PIXEL //"Vlr. Total"
					@ 126,230 SAY aGet[2] SIZE 060,07 OF oDlg PIXEL

					DEFINE SBUTTON   		FROM 005,280 TYPE 1  ENABLE OF oDlg ACTION ( oDlg:End() )
					
					DEFINE SBUTTON oBtn 	FROM 020,280 TYPE 15 ENABLE OF oDlg
					
					oBtn:lAutDisable := .F.
					If ( bVisual != Nil )
						oBtn:bAction := bVisual
					Else
						oBtn:SetDisable(.T.)
					Endif

				ACTIVATE MSDIALOG oDlg
		    // Mansano - Comentario dependo do IF localizado acima
		    //Else
			//   Help(" ",1,"REGNOIS")
			//Endif				
	
		Else
			Help(" ",1,"REGNOIS")	
		Endif

	
	Case (nBrowse == 2)
	    
	    If DbSeek("L2_FILIAL")
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L2_NUM")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L2_PRODUTO")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		If DbSeek("L2_DESCRI")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		If DbSeek("L2_EMISSAO")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L2_VEND")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L2_VRUNIT")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		If DbSeek("L2_QUANT")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		If DbSeek("L2_VLRITEM")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L2_UM")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
				
		If DbSeek("L2_DESC")                                                                      
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L2_VALDESC")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		If DbSeek("L2_TES")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		If DbSeek("L2_DOC")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		If DbSeek("L2_SERIE")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		If DbSeek("L2_TABELA")
			aadd(aHeader,{ ALLTRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		aadd(aStru,{"XX_CLIENTE","C",6,0})
		aadd(aStru,{"XX_LOJA","C",2,0})
		aadd(aStru,{"XX_NOME","C",40,0})
		aadd(aStru,{"XX_RECNO","N",12,0})
		
		SX3->(DbSetOrder(1))
		
		If ( Select(cAlias) ==	0 )
			
			cArquivo := CriaTrab(aStru,.T.)
			aadd(aAlias,{ cAlias , cArquivo })
			
			DbUseArea(.T.,,cArquivo,cAlias,.T.,.F.)
			IndRegua(cAlias,cArquivo,"L2_FILIAL+L2_PRODUTO+DTOS(L2_EMISSAO)",,,STR0040)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSeleciona os campos a serem visualizados posteriormente.                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nCntFor :=1 To Len(aStru)
				If (ALLTRIM(aStru[nCntFor][1])=="L2_FILIAL")  
				  	Loop
				Else
					Aadd (aCampos,{aStru[nCntFor][1]})
				Endif
			Next
		    
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta a pesquisa     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQry := "SL2"
				
			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := ""
					aEval(aQuery,{|x| cQuery +=","+ALLTRIM(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)
					cQuery +=         ",SL2.R_E_C_N_O_ SL2RECNO"
					cQuery += "FROM "+RetSqlName("SL2")+" SL2,"
					cQuery += "WHERE " // Mansano SL2.L2_FILIAL='"+xFilial("SL2")+"' AND "
					cQuery +=        "SL2.L2_PRODUTO='"+cProduto+"' AND "
					cQuery +=        "SL2.D_E_L_E_T_<>'*'"
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"
						
					DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)
						
					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				Endif
			#Endif
			
			DbSelectArea(cQry)
			If ( !lQuery )
				DbSetOrder(2)
				// Mansano - Mantive o pois a Loja em DBF soh tera dados de Venda dela propria
				If DbSeek(xFilial("SL2")+cProduto)
					bWhile := {|| !Eof() .AND. (xFilial("SL2") == SL2->L2_FILIAL)  .AND. ;
					(ALLTRIM(SB1->B1_COD) == ALLTRIM(SL2->L2_PRODUTO) )}
				Else
					Help(" ",1,"REGNOIS")	
				    aEval(aAlias,{|x| (x[1])->(DbCloseArea()),Ferase(x[2]+GetDbExtension()),Ferase(x[2]+OrDbagExt())})
					RestArea(aAreaSL1)
					RestArea(aAreaSL2)
					RestArea(aArea)
				    Return .F.
				Endif	
			Else
				bWhile := {|| !Eof() }
			Endif
				
			While ( Eval(bWhile) )
			    RecLock(cAlias,.T.)
					
				For nCntFor := 1 To Len(aStru)
					
					Do Case
						Case ( ALLTRIM(aStru[nCntFor][1])=="XX_RECNO" )
							If ( lQuery )
								(cAlias)->XX_RECNO := (cQry)->SL2RECNO
							Else
								(cAlias)->XX_RECNO := SL2->(RecNo())
							Endif
						
						Case ( ALLTRIM(aStru[nCntFor][1])=="XX_CLIENTE")
							 // Mansano 
							 //(cAlias)->XX_CLIENTE := Posicione("SL1",1,xFilial("SL1")+TKQRY02->L2_NUM,"L1_CLIENTE")
							 (cAlias)->XX_CLIENTE := Posicione("SL1",1,TKQRY02->L2_FILIAL+TKQRY02->L2_NUM,"L1_CLIENTE")

						Case ( ALLTRIM(aStru[nCntFor][1])=="XX_LOJA")
							 // Mansano
							 //(cAlias)->XX_LOJA	  := Posicione("SL1",1,xFilial("SL1")+TKQRY02->L2_NUM,"L1_LOJA")
							 (cAlias)->XX_LOJA	  := Posicione("SL1",1,TKQRY02->L2_FILIAL+TKQRY02->L2_NUM,"L1_LOJA")

						Case ( ALLTRIM(aStru[nCntFor][1])=="XX_NOME")
							 (cAlias)->XX_NOME 	  := Posicione("SA1",1,xFilial("SA1")+(cAlias)->XX_CLIENTE+(cAlias)->XX_LOJA,"A1_NOME")
						
						Otherwise	
                             
		 					(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))

					EndCase


				Next nCntFor
					
				DbSelectArea(cAlias)
				MsUnLock()  
				
				DbSelectArea(cQry)
				DbSkip()
			End
				
			If ( lQuery )
				DbSelectArea(cQry)
				DbCloseArea()
			Endif
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTotais da Consulta                                                      ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aGet[1] := 0
			aGet[2] := 0


			DbSelectArea(cAlias)
			// Mansano - Comentei o Seek e Coloquei um GoTop() para pegar todos os Or็amentos independente da Loja
			//DbSeek(xFilial("SL1"))
			TKQRY02->(DbGoTop())

			While !EOF()
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVlr. Total. 	    	  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				aGet[2] += L2_VLRITEM
					
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTotais dos Orcamentos  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If Empty(L2_DOC)
					aGet[1] += L2_VLRITEM
				Endif
					 
				DbSkip()
			End                                                      
			aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,2))
			aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,2))
				

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExibe os dados Gerados                                                  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ( lExibe )  
				DbSelectArea(cAlias)
				
				// Mansano - Comentei o Seek e Coloquei um GoTop() para pegar todos os Or็amentos independente da Loja
				//If DbSeek(xFilial("SL2"))
				TKQRY02->(DbGoTop())
					
					DEFINE MSDIALOG oDlg FROM	09,0 TO 28,80 TITLE cCadastro OF oMainWnd
				        
						@ 001,002 TO 029,267 OF oDlg	PIXEL
				    	
						@ 004,005 SAY STR0002 SIZE 028,07  OF oDlg PIXEL //"Codigo"
						@ 012,005 SAY SB1->B1_COD        SIZE 060,09  COLOR CLR_BLUE OF oDlg PIXEL
				
						@ 004,070 SAY STR0045 SIZE 020,07  OF oDlg PIXEL //"Produto"
						@ 012,070 SAY SB1->B1_DESC       SIZE 150,09  COLOR CLR_BLUE OF oDlg PIXEL
								  
						@35,02 LISTBOX oLbx VAR nCntList ; 
							FIELDS ;
								TkStatusSL1(IIF(ALLTRIM(TKQRY02->L2_DOC)="","1","2")),;
								TKQRY02->L2_FILIAL,; // Mansano
								Posicione("SM0",1,SUBS(cNumEmp,1,2)+TKQRY02->L2_FILIAL,"M0_NOME"),;
								TKQRY02->L2_NUM          ,;
								TKQRY02->XX_CLIENTE       ,;
								TKQRY02->XX_LOJA         ,;
								TKQRY02->XX_NOME         ,;
								Posicione("SA3",1,xFilial("SA3")+TKQRY02->L2_VEND,"A3_NOME"),;
								DTOC(TKQRY02->L2_EMISSAO) ,;
							    Transform(TKQRY02->L2_VRUNIT ,Tm(TKQRY02->L2_VRUNIT ,15,2)) ,; 
							    TKQRY02->L2_QUANT         ,;
							    Transform(TKQRY02->L2_VLRITEM,Tm(TKQRY02->L2_VLRITEM,15,2)) ,; 
								TKQRY02->L2_UM            ,;
								TKQRY02->L2_DESC          ,;
								Transform(TKQRY02->L2_VALDESC,Tm(TKQRY02->L2_VALDESC,15,2)) ,; 
								TKQRY02->L2_TES           ,;
								TKQRY02->L2_DOC           ,;
								TKQRY02->L2_SERIE         ,;
								TKQRY02->L2_TABELA        ;
							HEADER ;              
						 		"",;
						 		STR0056 ,; //"Loja DV"   Mansano
						 		STR0057 ,; //"Descricao" Mansano  
						 		STR0034 ,; //"N. Orcamento"	 
						 		STR0007 ,; //"Cliente "
						 		STR0003 ,; //"Loja"
						 		STR0004 ,; //"Nome"
						 		STR0006 ,; //"Vendedor"
						 		STR0039 ,; //"Data de emissao"       
						 		STR0042 ,; //"Vlr. Unit." 
						 		STR0021 ,; //"Quantidade"
						 		STR0043 ,; //"Vlr. item"
						 		STR0044 ,; //"Un. de Medida"
						 		STR0050 ,; //% desconto
						 		STR0049 ,; //"Vlr. Desconto"		
						 		STR0053 ,; //"TES"
						 		STR0037 ,; //"N. Fiscal"
						 		STR0038 ,; //"Serie"
						 		STR0054 ;  //"Tabela"
					 		SIZE 306,90 OF oDlg PIXEL 
					 		// Mansano ;
							//ALIAS "TKQRY02" SELECT TKQRY02->L2_FILIAL+TKQRY02->L2_PRODUTO;
							//FOR TKQRY02->L2_FILIAL+TKQRY02->L2_PRODUTO TO TKQRY02->L2_FILIAL+TKQRY02->L2_PRODUTO
	
							oLbx:Refresh()
				    
		        		@ 126,005 SAY STR0041 SIZE 080,07 OF oDlg PIXEL  //"Totais de orcamentos"
		        		If cPaisLoc == "BRA"
							@ 126,040 SAY aGet[1] SIZE 060,07 OF oDlg PIXEL
						Else 
							@ 126,060 SAY aGet[1] SIZE 060,07 OF oDlg PIXEL
						Endif
						@ 126,210 SAY STR0026 SIZE 025,07 OF oDlg PIXEL //"Vlr. Total"
						@ 126,230 SAY aGet[2] SIZE 060,07 OF oDlg PIXEL
		
						DEFINE SBUTTON 			FROM 005,280 TYPE 1  ENABLE OF oDlg ACTION ( oDlg:End() )
						
						DEFINE SBUTTON oBtn 	FROM 020,280 TYPE 15 ENABLE OF oDlg
						oBtn:lAutDisable := .F.
						If ( bVisual != Nil )
							oBtn:bAction := bVisual
						Else
							oBtn:SetDisable(.T.)
						Endif

					ACTIVATE MSDIALOG oDlg
					
				// Mansano - Referente ao IF acima
				//Else
				//	Help(" ",1,"REGNOIS")	
				//Endif	
			Else
				//Help(" ",1,"REGNOIS")	
				alert("REGNOIS - 03")	
			Endif
		Endif
			
EndCase

aEval(aAlias,{|x| (x[1])->(DbCloseArea()),Ferase(x[2]+GetDbExtension()),Ferase(x[2]+OrDbagExt())})
RestArea(aAreaSL1)
RestArea(aAreaSL2)
RestArea(aArea)

// Restaura Aliases salvos no incio do Programa inclusive SM0(Filiais)
P_CtrlArea(2,_aArea,_aAlias)

Return(aHeader)       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณTKVisuaSL1บAutor  ณRafael M Quadrotti  บ Data ณ  05/25/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza o item selecionado. (SL1/SL2)                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TKVisuaSL1(nRecno,nBrowse)

Local aArea 	:= GetArea()				
Local aAreaSL1 	:= SL1->(GetArea())
Local aAreaSL2 	:= SL2->(GetArea())
Local aSavAhead	:= aHeader
Local aSavAcol 	:= aCols
Local nSavN    	:= n
Local aPos      := {14,01,114,315}
Local aAC       := {STR0007,STR0008 } 	//"Abandona","Confirma"
Local oEnchoice 
Local oDlg
Local oGet
Local aCampos   :={}
Local aPosicoes := {}
Local nCont		:= 0 

Private aHeader[0],nUsado:=0

n:= 1
bCampo := {|nCPO| Field(nCPO) }

DbSelectarea("SL1")

If (nBrowse == 1 )
	SL1->(MsGoto(nRecno))
ElseIf(nBrowse == 2 )
   	DbSelectarea("SL1")
	DbSetorder(1)
  
   	// Mansano
   	//If DbSeek(xFilial("SL1")+TKQRY02->L2_NUM)
   	If DbSeek(TKQRY02->L2_FILIAL+TKQRY02->L2_NUM)
	   	nRecno := SL1->(Recno())
   	Endif		                             
Endif

// Chama Tela Montada apenas com consulta pois o Lj7Venda forca um DbSeek com xFilial o que tornou
// impossivel visualizar orcamentos que nao fossem da Filial aberta no momento da consulta.
P_DELC002B()
	
RestArea(aAreaSL1)
RestArea(aAreaSL2)
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑ
ฑฑณFuno    ณTkStatusSL1ณ Autor ณLuis Marcelo Kotaki	 ณ Data ณ18/07/00  ณฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑ
ฑฑณDescrio ณDevolve se o orcamento foi faturado ou nao (pago)            ณฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑ
ฑฑณUso	     ณSIGATMK                                     	 	      	   ณฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function TkStatusSL1(cStatus)

Local oOk:= LoaDbitmap( GetResources(), "BR_VERDE" )
Local oNo:= LoaDbitmap( GetResources(), "BR_VERMELHO" )
Local oRet
Local cAliasOld := Alias()

If cStatus == "1"
   oRet := oOk
Else
   oRet := oNo
Endif	

DbSelectarea(cAliasOld)
Return(oRet)
