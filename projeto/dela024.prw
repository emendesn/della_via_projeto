#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA024A บ Autor ณRicardo Mansano     บ Data ณ  11/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Tela com GetDados para Cadastro de Cartas de SEPU.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamada Via Menu                                           บฑฑ
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
Project Function DELA024A()
Local oDlg
Local oGetD
Local oFnt
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= MsAdvSize()
Local aInfo     	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local nUsado		:= 0
Local nX			:= 0
Local nReg	 		:= 1
Local nOpc   		:= 3 // Visualiza=2 / Inclui=3 / Altera=4 / Exclui=5

Local aCpoGDa		:= {"PA4_SEPU","PA4_DESGAS","PA4_VBONFA"}	// Campos da GetDados
Local nLinhas 		:= 100 // Numero de linhas Permitido na GetdDados
Local aButtons    	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara programas chamados pela GetDados.     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cFieldOk		:= "P_DELA024C"
Local cLinOk  		:= "P_DELA024D"
Local cTudoOk  		:= "P_DELA024E"
Local cDelOk		:= "P_DELA024F"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis dos Campos de Edicao no topo da Telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oNumLote,oDataAp,oVlrTot
Private cDataAp    	:= CriaVar("PA4_DTAPLI")
Private nVlrTot    	:= CriaVar("PA4_VBONFA") 	// Sera Utilizada no Tudo Ok para
// verificar se o valor da carta bate com o Total
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis utilizadas pela GetDados.           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aHeader 	:= {}
Private aCols   	:= {}
Private n			:= 1
Private aRotina 	:= {{"Pesquisar","AxPesqui"   ,0,1},;
{"Visual"   ,"AxVisual"  ,0,2},;
{"Incluir"  ,"AxInclui"  ,0,3} }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRodape da GetDados. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oRod
Private _nTot		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega aHeader. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT	,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO} )
	Endif
Next nX

// Alimenta Variaveis na aCols
aCols:={Array(nUsado+1)}
aCols[1,nUsado+1]:=.F.
For nX := 1 To nUsado
	aCols[1,nX] := CriaVar(aHeader[nX,2])
Next

// Definicoes de Resolucao da Tela
aObjects := {}
AADD(aObjects,{100,020,.T.,.F.,.F.})
AADD(aObjects,{100,085,.T.,.T.,.F.})
AADD(aObjects,{000,15, .T., .F. } )
aPosObj := MsObjSize( aInfo, aObjects )

// Fonte
DEFINE FONT oFnt NAME "Arial" SIZE 08,17 BOLD

DEFINE MSDIALOG oDlg TITLE "Carta Pirelli" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

@ aPosObj[1,1],aPosObj[1,2] To aPosObj[1,3],aPosObj[1,4] of oDlg Pixel

@ 021,010 Say "Dt.Aplicacao"  of oDlg Pixel
@ 020,055 MSGET oDataAp  VAR cDataAp SIZE 60,09 OF oDlg PIXEL

@ 022,200 Say "Valor Total"   of oDlg Pixel
@ 020,255 MSGET oVlrTot  VAR nVlrTot SIZE 70,09 OF oDlg PIXEL Picture "@E 999,999.99"

oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,cLinOk,cTudoOk,,.T.,,,,nLinhas,cFieldOk,,,cDelOk)
oGetD:aInfo[aScan(aHeader, {|x| rTrim(x[2]) == "PA4_VBONFA"})][4] := "" // Desabilita X3_WHEN

// Rodape
@ aPosObj[3,1]+4,010 Say "Valor Digitado:" Pixel Of oDlg
@ aPosObj[3,1]+3,060 SAY oRod VAR Transform(_nTot,"@E 999,999.99")	SIZE 065,10 OF oDlg	 PIXEL RIGHT COLOR CLR_HRED	FONT oFnt

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| ( if(P_DELA024E(),oDlg:End(),nil)  ) },{||oDlg:End()},,aButtons)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA024C บ Autor ณRicardo Mansano     บ Data ณ  11/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ FieldOK da GetDados.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet - .T. se a validacao estiver Ok, caso contrario .F.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Valida os campos da GetDados apos a sua digitacao          บฑฑ
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
Project Function DELA024C()
Local lRet 			:= .T.
Local nX			:= 0
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local cLote			:= ""
Local nPosSepu    	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_SEPU"   })
Local nPosValor		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_VBONFA" })
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"PA4"}) // GetArea

If ReadVar() = "M->PA4_VBONFA"
	// Forco valor do ReadVar para poder somar a aCols na
	// Funcao P_DELA024F()
	aCols[n,nPosValor] := &(ReadVar())
	// Soma total
	P_DELA024F()
Endif

If ReadVar() = "M->PA4_DESGAS"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณNao permite % de Desgaste maior que 100%.     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If &(ReadVar()) > 100
		Aviso("Aten็ใo !!!","Percentual de Desgaste nใo pode ser superior a 100% !!!",{" << Voltar"},2,"SEPU !")
		lRet := .F.
	Endif
endif

If lRet
	If ReadVar() = "M->PA4_SEPU"
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se SEPU ja foi incluida nesta Carta  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nX := 1 To naCols
			// Analisa apenas os Itens nใo deletados
			If !aCols[nX,naColsItem]
				If (n <> nX) .and. (aCols[nX,nPosSepu]==&(ReadVar()))
					Aviso("Aten็ใo !!!","SEPU jแ cadastrado nesta Carta !!!",{" << Voltar"},2,"SEPU !")
					lRet := .F.
				Endif
			Endif
		Next nX
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se SEPU ja foi cadastrado.           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lRet
			DbSelectArea("PA4")
			PA4->(DbSetOrder(1)) // Filial + Sepu
			If !PA4->(DbSeek(xFilial("PA4")+&(ReadVar())))
				Aviso("Aten็ใo !!!","SEPU nใo cadastrado !!!",{" << Voltar"},2,"SEPU !")
				lRet := .F.
			Endif
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se SEPU ja nao possui Lote cadastradoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lRet
			cLote := PA4->PA4_NUMLOT // Campo Localizado no Dbseek acima
			If !Empty(cLote)
				Aviso("Aten็ใo !!!","Este SEPU jแ estแ relacionado com o Lote: "+cLote+chr(13)+chr(10)+;
				"Caso haja a necessidade de gerar um cr้dito  "+chr(13)+chr(10)+;
				"complementar para este SEPU, voc๊ deverแ incluir um"+chr(13)+chr(10)+;
				"tํtulo de Cr้dito (NCC) na rotina de Contas a Receber.",;
				{" << Voltar"},2,"SEPU !")
				
				lRet := .F.
			Endif
		Endif
	Endif
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA024D บ Autor ณRicardo Mansano     บ Data ณ  11/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ LinOK da GetDados.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet - .T. se a validacao estiver Ok, caso contrario .F.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณValida a linha da GetDados apos a sua digitacao             บฑฑ
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
Project Function DELA024D()
Local lRet 			:= .T.
Local nPosSepu    	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_SEPU"   })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNao permite SEPU em branco na aCols.          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !aCols[n,Len(aCols[n])] // Ignora Deletado
	If Empty(aCols[n,nPosSepu])
		Aviso("Aten็ใo !!!","Preencha o campo SEPU !!!",{" << Voltar"},2,"SEPU !")
		lRet := .F.
	Endif
Endif

// Soma total
P_DELA024F()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA024E บ Autor ณRicardo Mansano     บ Data ณ  11/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ TudoOK da GetDados.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet - .T. se a validacao estiver Ok, caso contrario .F.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณValida a GetDados apos a sua digitacao                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบMarcelo   ณ30/11/05ณ ---  ณ Quando este fonte foi desenvolvido a Della บฑฑ
ฑฑบGaspar    ณ        ณ      ณ Via trabalhava com SE1 exclusivo e depois  บฑฑ
ฑฑบ          ณ        ณ      ณ ela mudou para compartilhado. Por isso foi บฑฑ
ฑฑบ          ณ        ณ      ณ necessario tratar o SE1 como compartilhado.บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA024E()
Local lRet 			:= .T.
Local nX			:= 0
Local nY			:= 0
Local cSepu			:= ""
Local _n			:= n
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local nPosSepu 		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_SEPU"   })
Local nPosDesg 		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_DESGAS" })
Local nPosValor		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_VBONFA" })
Local _cTipoTit		:= "" // "NCC" p/ Credito ou "AB-" p/ abatimento  ou "AB- e NCC" qdo gera dois titulos para um mesmo SEPU
Local _nAbatim 		:= GetMv("FS_DEL017") // Percentual de abatimento do valor da bonificacao para gerar o credito ou o abatimento da duplicata pendente
Local _nVlrTit 		:= 0
Local _lAtuSepu		:= .T.
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local _nVlDupli    	:= 0
Local cNumLote		:= "" // Numero do Lote em SX8
Local lExistNCC     := .F.
Local _lSE1Comp     := .T. // .T. = SE1 Compartilhado  , .F. = SE1 Exclusivo
Local _cFilSE1      := Space(02)

P_CtrlArea(1,@_aArea,@_aAlias,{"SE1","PA4"}) // GetArea


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se o SE1 eh exclusivo ou compartilhadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(AllTrim(xFilial("SE1")))                                           
   _lSE1Comp := .F. // Exclusivo
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se a Data de Aplicacao foi digitada ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cDataAp)
	Aviso("Aten็ใo !!!","Preencha a Data de Aplica็ใo !!!",{" << Voltar"},2,"SEPU !")
	lRet := .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se Valor Total bate com a soma da aCols ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	If nVlrTot <> _nTot
		Aviso("Aten็ใo !!!","Soma dos lan็amentos nใo"+chr(13)+;
		"coincide com o Valor Total !!!",{" << Voltar"},2,"SEPU !")
		lRet := .F.
	Endif
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se SEPU nao foi incluida duas vezes nesta Cartaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	For nX := 1 To naCols
		// Analisa apenas os Itens nใo deletados
		If !aCols[nX,naColsItem]
			n := nX
			cSepu := aCols[n,nPosSepu]
			For nY := 1 To naCols
				// Analisa apenas os Itens nใo deletados
				If !aCols[nY,naColsItem]
					If (n <> nY) .and. (aCols[nY,nPosSepu]==cSepu)
						lRet := .F.
					Endif
				Endif
			Next nY
		Endif
	Next nX
	
	// Restaura N
	n := _n
	
	// Mostra Erro
	If !lRet
		Aviso("Aten็ใo !!!","O mesmo Nr. de SEPU nใo pode constar duas vezes na mesma Carta !!!",{" << Voltar"},2,"SEPU !")
	Endif
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva os dados na SEPU.                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	DbSelectArea("PA4")
	PA4->(DbSetOrder(1)) // Filial + Sepu
	For nX := 1 To naCols
		// Salva apenas os Itens nใo deletados
		If !aCols[nX,naColsItem]
			
			_nVlrTit	:= aCols[nX,nPosValor]-(aCols[nX,nPosValor]*_nAbatim /100)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Sepus ja foram validadas na digitacao, consequentemente elas existem ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			PA4->(DbSeek(xFilial("PA4")+aCols[nX,nPosSepu]))
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Verifica se ha bonificacao por parte da della Via ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			dbSelectArea("SE1")
			dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If _lSE1Comp
    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
    	  	Else
    	  	   _cFilSE1 := PA4->PA4_FILDV  // SE1 Exclusivo
    	  	EndIf   
			If !dbSeek(_cFilSE1 + "SEP" + PA4->PA4_SEPU)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Verifica se Pirelli concedeu bonificacao e a loja NAO fez adiantamento de pneu.  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If aCols[nX,nPosValor] <> 0 .And. Empty(PA4->PA4_CFANT)
					
					If !lExistNCC
						_cTipoTit	:= "NCC"


						If _lSE1Comp
			    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
			    	  	Else
			    	  	   _cFilSE1 := PA4->PA4_MSFIL  // SE1 Exclusivo
			    	  	EndIf   
			
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Gera titulo de credito (NCC) para o cliente                          ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						If !P_NCCSEPU(3,_cFilSE1,PA4->PA4_SEPU,"SEP",_cTipoTit,_nVlrTit)
							_lAtuSepu := .F.
							MsgStop(OemtoAnsi("1-A nota de cr้dito do SEPU : "+PA4->PA4_SEPU+" nใo foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten็ใo"))
						EndIf
					EndIf
					
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Verifica se Pirelli concedeu bonificacao e a loja JA fez adiantamento de pneu.   ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				ElseIf aCols[nX,nPosValor] <> 0 .And.  !Empty(PA4->PA4_CFANT)
					
					_cTipoTit := "AB-"
					
					If _lSE1Comp
		    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
		    	  	Else
		    	  	   _cFilSE1 := PA4->PA4_FILANT  // SE1 Exclusivo
		    	  	EndIf   

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Verifica se Valor do Abatimento eh maior que o valor do Titulo da duplicata pendente ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					DbSelectArea("SE1")
					SE1->(DbSetOrder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					If SE1->(DbSeek(_cFilSE1+PA4->PA4_SERANT+PA4->PA4_CFANT))
						
						_cTipoTit := "AB-"
						_nVlDupli := SE1->E1_VALOR // Valor da duplicata pendente
						
						If _nVlrTit > SE1->E1_VALOR
							If _lSE1Comp
				    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
				    	  	Else
				    	  	   _cFilSE1 := PA4->PA4_FILANT  // SE1 Exclusivo
				    	  	EndIf   
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Gera titulo de abatimento (AB-) para o cliente com valor do titulo da duplicata pendente  ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							If !P_NCCSEPU(3,_cFilSE1,PA4->PA4_CFANT,PA4->PA4_SERANT,_cTipoTit,_nVlDupli)
								_lAtuSepu := .F.
								MsgStop(OemtoAnsi("2-A nota de cr้dito do SEPU : "+PA4->PA4_SEPU+" nใo foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten็ใo"))
							EndIf
							
							_cTipoTit := "NCC"

							If _lSE1Comp
				    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
				    	  	Else
				    	  	   _cFilSE1 := PA4->PA4_MSFIL  // SE1 Exclusivo
				    	  	EndIf   

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Gera titulo de credito (NCC) para o cliente com a                    ณ
							//ณ diferenca (Valor da Bonfiicacao - Valor da duplicata pendente)       ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							If (_lAtuSepu) .and. (!P_NCCSEPU(3,_cFilSE1,PA4->PA4_SEPU,"SEP",_cTipoTit,( _nVlrTit-_nVlDupli ) ))
								_lAtuSepu := .F.
								MsgStop(OemtoAnsi("3-A nota de cr้dito do SEPU : "+PA4->PA4_SEPU+" nใo foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten็ใo"))
							Else
								_cTipoTit := "AB- e NCC"// Gerou os dois titulos AB- e NCC
							EndIf
						Else
							If _lSE1Comp
				    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
				    	  	Else
				    	  	   _cFilSE1 := PA4->PA4_FILANT  // SE1 Exclusivo
				    	  	EndIf   

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Gera titulo de abatimento (AB-) para o cliente                       ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							If !P_NCCSEPU(3,_cFilSE1,PA4->PA4_CFANT,PA4->PA4_SERANT,_cTipoTit,_nVlrTit )
								_lAtuSepu := .F.
								MsgStop(OemtoAnsi("4-A nota de cr้dito do SEPU : "+PA4->PA4_SEPU+" nใo foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten็ใo"))
							EndIf
						Endif
					Endif
				EndIf
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Caso tenha passa do por todas as Validacoes, salva os dados do SEPU. ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If _lAtuSepu
				DbSelectArea("PA4")
				PA4->(DbSetOrder(1)) // Filial + Sepu
				PA4->(DbSeek(xFilial("PA4")+aCols[nX,nPosSepu]))
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Confirma SX8 para numero do Lote.            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If Empty(cNumLote)
					cNumLote := GetSxeNum("PA4","PA4_NUMLOT")
					ConfirmSx8()
				Endif
				
				RecLock("PA4",.F.)
				PA4->PA4_NUMLOT := cNumLote
				PA4->PA4_DTDIGI := dDataBase
				PA4->PA4_DTAPLI := cDataAp
				PA4->PA4_DESGAS := aCols[nX,nPosDesg]
				PA4->PA4_VBONFA := aCols[nX,nPosValor]
				PA4->PA4_ACTFA  := Iif(PA4->PA4_VBONFA<>0,"S","N")
				PA4->PA4_TPFIN  := _cTipoTit  // "NCC" p/ Credito ou "AB-" p/ abatimento  ou "AB- e NCC" qdo gera dois titulos para um mesmo SEPU
				MsUnLock()
				
			EndIf
			
		Endif
	Next nX
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Mostra Lote Salvo se pelo menos um deles passou pela Validacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cNumLote)
	Aviso("Aten็ใo !!!","Numero do Lote Gerado: "+cNumLote+" !!!",{" << Voltar"},2,"Numero do Lote !")
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA024F บ Autor ณRicardo Mansano     บ Data ณ  11/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Soma Colunas do Valor para mostra-la no Rodape.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Foi Utilizado na GetDados como cDelOk                      บฑฑ
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
Project Function DELA024F()
Local nX 			:= 0
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local nPosValor		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_VBONFA" })

// Soma Total para mostra-lo no Rodape
_nTot := 0
For nX := 1 To naCols
	If !aCols[nX,naColsItem]
		_nTot += aCols[nX,nPosValor]
	Endif
Next nX

// Refresh Rodape
oRod:Refresh()

Return(.T.)
