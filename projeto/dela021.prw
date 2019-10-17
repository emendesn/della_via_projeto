#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA021  บAutor  ณPaulo Benedet          บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Mostra browse dos SEPU                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo menu sigaloja.xnu especifico              บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA021()
Local aCores := {}

Private aRotina := {}
Private cCadastro := "SEPU"

// preenche acores
aAdd(aCores, {"Empty(PA4_ACTFA).And.Empty(PA4_ACTDV).And.Empty(PA4_CPRODV)", "BR_CINZA"}) // aguardando avaliacao e nao antecipado
aAdd(aCores, {"Empty(PA4_ACTFA).And.Empty(PA4_ACTDV).And.!Empty(PA4_CPRODV)", "BR_AZUL"}) // aguardando avaliacao e antecipado
aAdd(aCores, {"Empty(PA4_ACTFA).And.!Empty(PA4_ACTDV).And.Empty(PA4_CPRODV)", "BR_AMARELO"}) // avaliado pela loja e nao antecipado
aAdd(aCores, {"Empty(PA4_ACTFA).And.!Empty(PA4_ACTDV).And.!Empty(PA4_CPRODV)", "BR_LARANJA"})  // avaliado pela loja e antecipado
aAdd(aCores, {"PA4_ACTFA == 'N'", "BR_VERMELHO"}) // nao aprovado pela Pirelli
aAdd(aCores, {"PA4_ACTFA == 'S'", "BR_VERDE"}) // aprovado pela Pirelli

// preenche arotina
aAdd(aRotina, {"Pesquisar", "axPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "P_D21ManSEPU", 0, 2})
aAdd(aRotina, {"Alterar", "P_D21ManSEPU", 0, 4})
aAdd(aRotina, {"Legenda", "P_D21LegSEPU", 0, 6})

// chama browse
dbSelectArea("PA4")
dbSetOrder(1)
dbGoTop()

mBrowse(06,01,22,75,"PA4",,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณD21LegSEPUบAutor  ณPaulo Benedet          บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Mostra legenda                                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo browse do DELA021                       บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function D21LegSEPU()
Local aCorDsc := {}

// preenche legenda
aAdd(aCorDsc, {"BR_CINZA"   , "Aguardando avalia็ใo - Nใo antecipado"})
aAdd(aCorDsc, {"BR_AZUL"    , "Aguardando avalia็ใo - Antecipado"})
aAdd(aCorDsc, {"BR_AMARELO" , "Avaliado pela loja - Nใo antecipado"})
aAdd(aCorDsc, {"BR_LARANJA" , "Avaliado pela loja - Antecipado"})
aAdd(aCorDsc, {"BR_VERMELHO", "Recusado pela Pirelli"})
aAdd(aCorDsc, {"BR_VERDE"   , "Aprovado pela Pirelli"})

// monta legenda
brwLegenda("SEPU", "Legenda", aCorDsc)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณD21LegSEPUบAutor  ณPaulo Benedet          บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Mostra legenda                                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cAlias - Alias do mbrowse                                     บฑฑ
ฑฑบ          ณ nReg   - Numero do registro posicionado                       บฑฑ
ฑฑบ          ณ nOpcX  - Opcao do aRotina                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo browse do DELA021                       บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function D21ManSEPU(cAlias, nReg, nOpcx)

Local aSize := msAdvSize(.T.)
Local aObj  := {}
Local aInfo := {}
Local aPosObj := {} // array com as posicoes dos objetos
Local aButtons := {} // botoes da enchoice bar
Local bOK := Nil // Acao executada apos clicar no botao OK
Local bCancel := Nil // Acao executada apos clicar no botao Cancelar
Local cSQL := "" // Comando sql
Local cPrdSEPU := GetMV("FS_DEL008") + Space(TamSX3("B1_COD")[1] - Len(AllTrim(GetMV("FS_DEL008")))) // prd sepu
Local cLotSEPU := PA4->PA4_SEPU + Space(TamSX3("D1_LOTECTL")[1] - Len(AllTrim(PA4->PA4_SEPU))) // lote sepu
#IFDEF TOP
	Local cSD1 := RetSQLName("SD1") // Tabela sd1
	Local cSD2 := RetSQLName("SD2") // Tabela sd2
	Local cSA1 := RetSQLName("SA1") // Tabela sa1
	Local cSA2 := RetSQLName("SA2") // Tabela sa2
#ENDIF

/*
array asize - tamanho da dialog e area de trabalho
1 - linha inicial area de trabalho
2 - coluna inicial area de trabalho
3 - linha final area de trabalho
4 - coluna final area de trabalho
5 - coluna final dialog
6 - linha final dialog
7 - linha inicial dialog

array aobjects - tamanho padrao dos objetos para calculo das posicoes
1 - tamanho x
2 - tamanho y
3 - dimensiona x
4 - dimensiona y
5 - retorna dimensoes x e y (size) ao inves de linha / coluna final

array ainfo - tamanho da area onde sera calculada as posicoes dos objetos
1 - posicao inicial x
2 - posicao inicial y
3 - posicao final x
4 - posicao final y
5 - espaco lateral entre os objetos
6 - espaco vertical entre os objetos
*/

Private oDlg, oLbx
Private aDados := {} // Dados da list box

// calcula coordenadas do objeto
aAdd(aObj, {100, 100, .T., .T.}) //100 Largura, 100 Comprimento, recalcula 1 area, recalcula 2 area
aAdd(aObj, {100, 100, .T., .T.}) //100 Largura, 100 Comprimento, recalcula 1 area, recalcula 2 area

aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 3}
aPosObj := msObjSize(aInfo, aObj, .T., .F.)

// Cria as variaveis da Enchoice (M->?)
RegToMemory(cAlias, .F., .F.)

#IFDEF TOP
	// Busca notas que envolvam o SEPU
	cSQL := "SELECT 'SAIDA' ID, D2_EMISSAO EMISSAO, D2_CLIENTE COD, D2_LOJA LOJA, D2_FILIAL FILIAL, D2_DOC DOC, D2_SERIE SERIE "
	cSQL += "FROM " + cSD2 + " WHERE "
	cSQL += "D_E_L_E_T_ <> '*' AND "
	cSQL += "D2_COD = '" + cPrdSEPU + "' AND "
	cSQL += "D2_LOCAL = '" + GetMV("FS_DEL013") + "' AND "
	cSQL += "D2_LOTECTL = '" + cLotSEPU + "'"
	cSQL += " UNION "
	cSQL += "SELECT 'ENTRADA' ID, D1_EMISSAO EMISSAO, D1_FORNECE COD, D1_LOJA LOJA, D1_FILIAL FILIAL, D1_DOC DOC, D1_SERIE SERIE "
	cSQL += "FROM " + cSD1 + " WHERE "
	cSQL += "D_E_L_E_T_ <> '*' AND "
	cSQL += "D1_COD = '" + cPrdSEPU + "' AND "
	cSQL += "D1_LOCAL = '" + GetMV("FS_DEL013") + "' AND "
	cSQL += "D1_LOTECTL = '" + cLotSEPU + "' "
	cSQL += "ORDER BY EMISSAO"
	cSQL := ChangeQuery(cSQL)
	
	//MemoWrite("DELA021.SQL", cSQL)
	
	msAguarde({|| dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "NFTMP", .F., .T.)}, "Selecionando registros...")
	tcSetField("NFTMP", "EMISSAO", "D")
	
	// Carrega list box
	dbSelectArea("NFTMP")
	dbGoTop()
	
	While !EOF()
		aAdd(aDados, {NFTMP->ID, NFTMP->EMISSAO, NFTMP->COD, NFTMP->LOJA, NFTMP->(FILIAL + DOC + SERIE)})
		
		dbSelectArea("NFTMP")
		dbSkip()
	EndDo
	
	// Fecha arquivo
	dbSelectArea("NFTMP")
	dbCloseArea()
#ENDIF

If Len(aDados) == 0
	aAdd(aDados, {"","","","",""})
EndIf

// Botoes complementares
If nOpcx == 3
	aAdd(aButtons, {"USER", {|| P_DelContat(.T.)}, "Contatos"})
Else
	aAdd(aButtons, {"USER", {|| P_DelContat(.F.)}, "Contatos"})
EndIf
aAdd(aButtons, {"RELATORIO", {|| VisNota(oLbx:nAt)}, "Visualizar"})

// Monta dialogo
Define msDialog oDlg Title cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel
Enchoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)

@ aPosObj[2][1],aPosObj[2][2] ListBox oLbx Fields Header "Evento", "Data", "Cli / For", "Loja", "Descricao" Size aPosObj[2][4] - aPosObj[2][2],aPosObj[2][3] - aPosObj[2][1] of oDlg Pixel
oLbx:SetArray(aDados)
oLbx:bLine := {|| {aDados[oLbx:nAt][1], aDados[oLbx:nAt][2], aDados[oLbx:nAt][3], aDados[oLbx:nAt][4], aDados[oLbx:nAt][5]}}

bOK := {|| IIf(nOpcx == 3, IIf(VldGrvSEPU(), (Processa({|| GrvSEPU(nReg)}, "Gravando informacoes..."), oDlg:End()), .T.), oDlg:End())}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOK, bCancel,, aButtons)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvSEPU  บAutor  ณPaulo Benedet          บ Data ณ  06/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava alteracao                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nReg - Numero do registro no PA4.                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo programa D21ManSEPU                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvSEPU(nReg)

Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local nTotCpo  := 0 // numero de campos
Local aVetor   := {} // dados do execauto
Local nFuncao  := 0 // funcao do execauto
Local i

Private lmsErroAuto	:= .F. // variavel do execauto

// Posiciona SEPU
dbSelectArea("PA4")
nTotCpo := fCount()
ProcRegua(nTotCpo)
dbGoTo(nReg)

// Atualiza SEPU
RecLock("PA4", .F.)
For i := 1 to nTotCpo
	IncProc("Gravando SEPU...")
	FieldPut(i, &("M->" + FieldName(i)))
Next i
msUnlock()

// Grava memos
If Empty(PA4->PA4_CLDOFA)
	MSMM(, 80,, M->PA4_MLDOFA, 1,,, "PA4", "PA4_CLDOFA")
Else
	MSMM(PA4->PA4_CLDOFA, 80,, M->PA4_MLDOFA, 1,,, "PA4", "PA4_CLDOFA")
EndIf

If Empty(PA4->PA4_CLDODV)
	MSMM(, 80,, M->PA4_MLDODV, 1,,, "PA4", "PA4_CLDODV")
Else
	MSMM(PA4->PA4_CLDODV, 80,, M->PA4_MLDODV, 1,,, "PA4", "PA4_CLDODV")
EndIf

// Verifica se houve bonificacao
If M->PA4_VBONFA > 0 .Or. M->PA4_VBONDV > 0
	IncProc("Gravando Nota de Credito...")
	
	// Verifica se existe ncc
	dbSelectArea("SE1")
	dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If dbSeek(xFilial("SE1") + "SEP" + PA4->PA4_SEPU)
		nFuncao := 4
	Else
		nFuncao := 3
	EndIf
	
	If !P_NCCSEPU(nFuncao, xFilial("SE1"), PA4->PA4_SEPU, "SEP", "NCC", IIf(PA4->PA4_VBONFA > 0, PA4->PA4_VBONFA, PA4->PA4_VBONDV))
		MsgStop(OemtoAnsi("A nota de cr้dito nใo foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten็ใo"))
	EndIf
EndIf

// Fecha dialogo
oDlg:End()

RestArea(aAreaSE1)
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณD21PegAva บAutor  ณPaulo Benedet          บ Data ณ  07/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Busca avaliadores do SEPU                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo ponto de entrada SF1100I                บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function D21PegAva()

Local aAreaIni := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSA3 := SA3->(GetArea())

Private cCodAva := Space(TamSX3("A3_COD")[1])
Private cNomAva := Space(TamSX3("A3_NOME")[1])
Private lNomAva := .F.
Private oDlg, oNomAva

// Monta dialogo
Define msDialog oDlg Title "Informe o avaliador" From 118,55 to 317,354 of oMainWnd Pixel

@ 0,2 To 63,149 of oDlg Pixel
@ 17,10 Say OemToAnsi("C๓digo") Size 22,8 of oDlg Pixel
@ 37,10 Say OemToAnsi("Nome") Size 16,8 of oDlg Pixel
@ 15,40 msGet cCodAva F3 "SA3" Valid VldAva() Size 40,10 of oDlg Pixel
@ 35,40 msGet oNomAva Var cNomAva Picture "@!" When lNomAva Size 100,10 of oDlg Pixel
Define sButton From 76,115 Type 1 Enable of oDlg Action oDlg:End()

Activate Dialog oDlg Centered Valid VldTelaAva()

// Posiciona cliente
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + SD1->(D1_FORNECE + D1_LOJA))

// Grava SEPU
RecLock("PA4", .T.)
PA4_FILIAL := xFilial("PA4")
PA4_SEPU   := SD1->D1_LOTECTL
PA4_DTINC  := dDataBase
PA4_CODCLI := SD1->D1_FORNECE
PA4_LOJA   := SD1->D1_LOJA
PA4_NOMCLI := SA1->A1_NOME
PA4_FILDV  := SM0->M0_CODFIL
PA4_DSCLOJ := SM0->M0_NOME
PA4_SRNFE  := SD1->D1_SERIE
PA4_NFE    := SD1->D1_DOC
PA4_NOMCON := SA1->A1_NOME
PA4_CPFCON := SA1->A1_CGC
PA4_ENDCON := SA1->A1_END
PA4_BAICON := SA1->A1_BAIRRO
PA4_MUNCON := SA1->A1_MUN
PA4_ESTCON := SA1->A1_EST
PA4_DDDCON := SA1->A1_DDD
PA4_TELCON := SA1->A1_TEL
PA4_CTECFA := IIf(cCodAva == GetMV("FS_DEL014"), cCodAva, "")
PA4_NTECFA := IIf(cCodAva == GetMV("FS_DEL014"), cNomAva, "")
PA4_CTECDV := IIf(cCodAva == GetMV("FS_DEL014"), "", cCodAva)
PA4_NTECDV := IIf(cCodAva == GetMV("FS_DEL014"), "", cNomAva)
msUnlock()

// Retorna ambiente
RestArea(aAreaSA1)
RestArea(aAreaSA3)
RestArea(aAreaIni)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldAva   บAutor  ณPaulo Benedet          บ Data ณ  07/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida avaliadores do SEPU                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Avaliador valido                                 บฑฑ
ฑฑบ          ณ        .F. - Avaliador invalido                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo programa D21PegAva()                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldAva()

Local lRet := .F.

If cCodAva == GetMV("FS_DEL014") // Avaliador Pirelli
	lRet := .T.
	lNomAva := .T.
	cNomAva := Space(TamSX3("A3_NOME")[1])
Else
	lNomAva := .F. // Trava digitacao do nome do avaliador
	
	// Pesquisa avaliadores
	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3") + cCodAva)
		lRet := .T.
		cNomAva := SA3->A3_NOME
	Else
		lRet := .F.
		cNomAva := Space(TamSX3("A3_NOME")[1])
		Help(" ", 1, "REGNOIS")
	EndIf
EndIf

oNomAva:Refresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldTelaAvaบAutor  ณPaulo Benedet          บ Data ณ  07/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida tela de avaliadores do SEPU                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Avaliador valido                                 บฑฑ
ฑฑบ          ณ        .F. - Avaliador invalido                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo programa D21PegAva()                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldTelaAva()

Local lRet := .F.

If cCodAva == GetMV("FS_DEL014") // Avaliador Pirelli
	If Len(AllTrim(cNomAva)) > 0 // Nome preenchido
		lRet := .T.
	EndIf
Else
	// Pesquisa avaliadores
	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3") + cCodAva)
		lRet := .T. // Avaliador existente
	Else
		lRet := .F. // Avaliador inexistente
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldGrvSEPUบAutor  ณPaulo Benedet          บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida alteracao do SEPU.                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Permite a alteracao                              บฑฑ
ฑฑบ          ณ        .F. - Nao permite a alteracao                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo programa D21ManSEPU                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldGrvSEPU()

Local aAreaIni := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local lRet := .T.

// Verifica se NCC foi utilizada
dbSelectArea("SE1")
dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
If dbSeek(xFilial("SE1") + "SEP" + M->PA4_SEPU)
	If SE1->E1_VALOR <> SE1->E1_SALDO
		MsgAlert(OemtoAnsi("SEPU nใo poderแ ser alterado porque a nota de cr้dito jแ foi utilizada!"), "Aviso")
		lRet := .F.
	EndIf
EndIf

// Restaura ambiente
RestArea(aAreaSE1)
RestArea(aAreaIni)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELAXXXX บAutor  ณRicardo Mansano     บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para Cadastro de Contatos para SEPU que sera chamada  บฑฑ
ฑฑบ          ณ pela tela de cadastro de SEPU.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ lDisp - .T. - Habilita botoes incluir/alterar              บฑฑ
ฑฑบ          ณ         .F. - Desabilita botoes incluir/alterar            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ                                                            บฑฑ
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
Project Function DelContat(lDisp)

Local oDlg
Local nX			:= 0
Local _aArea   		:= {}
Local _aAlias  		:= {}

/* AQUI DEVE SER DESCOMENTADO QUANTO SUA ROTINA ESTIVER CHAMANDO ESTA FUNCAO
// Salva Configuracoes da aCols e aHeader
Local _aCols		:= aClone(aCols)
Local _aHeader		:= aClone(aHeader)
Local _n			:= n
*/

Private aCpoGDa		:= {"PA5_DTCON","PA5_HRCON","PA5_NOMUSR","PA5_NOMCON" }
Private nUsado		:= 0
Private aHeader 	:= {}
Private aCols   	:= {}
Private lBtVis := .F.

P_CtrlArea(1,@_aArea,@_aAlias,{"PA5"}) // GetArea

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
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT	,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO} )
	Endif
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta aCols com contatos cadastrados  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DelMonta()

DEFINE MSDIALOG oDlg TITLE "Contatos" From 268,168 to 433,776 of oMainWnd PIXEL
@ 001,001 TO 083,262 MULTILINE

@ 01,265 Button OemToAnsi("&Incluir")    Size 36,16 When lDisp of oDlg Pixel Action DelManut(3)
@ 19,265 Button OemToAnsi("&Alterar")    Size 36,16 When lDisp of oDlg Pixel Action DelManut(4)
@ 36,265 Button OemToAnsi("&Visualizar") Size 36,16 When lBtVis of oDlg Pixel Action DelManut(2)
@ 53,265 Button OemToAnsi("&Sair")       Size 36,16 of oDlg Pixel Action oDlg:End()
Activate MsDialog oDlg


/* AQUI DEVE SER DESCOMENTADO QUANTO SUA ROTINA ESTIVER CHAMANDO ESTA FUNCAO
// Restaura Configuracoes da aCols e aHeader
/*
aCols		:= aClone(_aCols)
aHeader		:= aClone(_aHeader)
n			:= _n
*/

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELAMANUT บAutor  ณRicardo Mansano     บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Static Function que monta AxInclui ou AxAltera para manu-  บฑฑ
ฑฑบ          ณ tencao das informacoes do Cadastro de Contatos de SEPU(PA5)บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nTipo = 3 --> Inclui                                       บฑฑ
ฑฑบ          ณ nTipo = 4 --> Altera                                       บฑฑ
ฑฑบ          ณ nTipo = 2 --> Visualiza                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ                                                            บฑฑ
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
Static Function DELManut(nTipo)

Local nPosData    	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "PA5_DTCON"})
Local nPosHora    	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "PA5_HRCON"})
Private cCadastro  	:= OemtoAnsi("Contatos")
Private aMemos := {{"PA5_CODOBS","PA5_MEMOBS"}}

// Localiza Recno do Registro
If nTipo <> 3
	dbSelectArea("PA5")
	PA5->(DbSetOrder(1)) // PA5_FILIAL + PA5_SEPU + DTOS(PA5_DTCON) + PA5_HRCON
	PA5->(DbSeek(xFilial("PA5")+M->PA4_SEPU+DtoS(aCols[n,nPosData])+aCols[n,nPosHora]))
	_nRecno := Recno()
	INCLUI 	:= .F.
	AxAltera("PA5",_nRecno,nTipo)
Else
	//PA5->(DbGoBottom())
	_nRecno := Recno()
	INCLUI	:= .T.
	AxInclui("PA5")
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta aCols com contatos cadastrados  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DelMonta()
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELMONTA  บAutor  ณRicardo Mansano     บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Static Function que monta aCols para visualizacao dos      บฑฑ
ฑฑบ          ณ registros de Contato de SEPU(PA5).                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ                                                            บฑฑ
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
Static Function DelMonta()

aCols := {}

dbSelectArea("PA5")
dbSetOrder(1) // PA5_FILIAL + PA5_SEPU + DTOS(PA5_DTCON) + PA5_HRCON

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtra os Contatos de acordo com o SEPU aberto no Momento    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If dbSeek(xFilial("PA5") + M->PA4_SEPU)
	While !Eof();
		.and. xFilial("PA5") == PA5->PA5_FILIAL;
		.and. M->PA4_SEPU == PA5->PA5_SEPU
		
		aAdd(aCols, {PA5->PA5_DTCON,PA5->PA5_HRCON,PA5->PA5_NOMUSR,PA5->PA5_NOMCON,.F.})
		dbSkip()
	EndDo
	lBtVis := .T.
Else
	lBtVis := .F.
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VisNota  บAutor  ณPaulo Benedet          บ Data ณ  10/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza notas de entrada e saida                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nLin - Numero da linha no list box                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo programa D21ManSEPU                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VisNota(nLin)

Local aEstIni := GetArea()
Local aEstSF1 := SF1->(GetArea())
Local aEstSF2 := SF2->(GetArea())
Local cSavFil := cFilAnt // Salva filial

// Verifica tipo de nota
If rTrim(aDados[nLin][1]) == "SAIDA" // Nota de saida
	
	// Posiciona SF2
	dbSelectArea("SF2")
	dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	dbSeek(aDados[nLin][5])
	
	// Chama funcao de visualizacao
	cFilAnt := Left(aDados[nLin][5], 2)
	Mc090Visual("SF2", RecNo(), 2)
	
	// Volta filial
	cFilAnt := cSavFil
	
ElseIf rTrim(aDados[nLin][1]) == "ENTRADA" // Nota de entrada
	
	// Posiciona SF1
	dbSelectArea("SF1")
	dbSetOrder(1) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	dbSeek(aDados[nLin][5])
	
	// Chama funcao de visualizacao
	cFilAnt := Left(aDados[nLin][5], 2)
	a103nFiscal("SF1", RecNo(), 2)	
	
	// Volta filial
	cFilAnt := cSavFil
	
Else
	MsgAlert(OemtoAnsi("Nใo existem registros para pesquisa!"), "Aviso")
EndIf

RestArea(aEstSF1)
RestArea(aEstSF2)
RestArea(aEstIni)

Return