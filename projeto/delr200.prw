#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DELR200  ³ Autor ³ Roberto Rogerio Mezzalira ³ Data ³ 11/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ <Relatorio de vendedorer(Sintetico)                            ³±±
±±³          ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DELR200                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT - FATURAMENTO                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo     ³26/01/06³  -   ³Com o intuito de melhorar a performance deste ³±±
±±³Gaspar      ³        ³      ³relatorio de Vendas - Sintetico, este fonte   ³±±
±±³            ³        ³      ³foi reescrito no DELR202.PRW pelo lider de    ³±±
±±³            ³        ³      ³projetos Stanko.                              ³±±
±±³Marcelo     ³11/04/06³  -   ³Bloqueado a execucao deste fonte. E exibicao  ³±±
±±³Gaspar      ³        ³      ³de mensagem informativa ao usuario.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function DELR200()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alguns menus de usuarios ainda estavam acessando o DELR200 indevidamente. Devido a isso foi bloqueado a execucao deste fonte ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgBox("Você está utilizando o fonte DELR200. Ele foi descontinuado e substituido pelo DELR202. Altere a chamada no seu arquivo de MENU.","Atenção !")
Return

/*
Local   cDesc1  := "Imprime a relacao dos vendedores - (Sintetico) "
Local   cDesc2  := ""
Local   cDesc3  := ""
Private titulo  := "RELATORIO DE VENDEDORES SINTETICO"
Private cabec1  :=""
Private cabec2  :=""
Private wnrel		:= "DLR200"
Private cPerg   	:= "DLR20A"
Private nomeprog	:= "DELR200"
Private m_pag		:= 1
Private tamanho      := "G"
Private nTipo        := 18
Private nLastKey     := 0
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 1, 1,"", 1}
Private aVend        := {}
Private aMont        := {}
Private aAlin        := {}

cString :="SF2"
ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // TIPO DE VENDA                                ³
//³ mv_par02     // Data de                                      ³
//³ mv_par03     // Data ate                                     ³
//³ mv_par04     // Vendedor de                                  ³
//³ mv_par05     // Vendedor ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

RptStatus({|lEnd| DELR200imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

Return
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DELR200Imp³ Autor ³ Roberto Rogerio Mezzalira³ Data ³ 11/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ <Descricao da funcao>                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DELR200Imp(lEnd,WnRel,cString)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DELR200                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DELR200Imp(lEnd,WnRel,cString)
Local _nLin := 80
Local cabec1 := "          Vendedor                                          Valor               Valor               Total           Quant.                  Valor         Carro(s)"//               Valor"
Local cabec2 := "                                                       Mercadoria             Servico           Merc+Serv           Seguro                 Seguro      Atendido(s)"//           Devolucao"
Local nI     := 0

Local nMerc  := 0
Local nServ  := 0
Local nQtSeg := 0
Local nVlSeg := 0
Local nCarro := 0
Local nDev   := 0

Local nMercF  := 0
Local nServF  := 0
Local nQtSegF := 0
Local nVlSegF := 0
Local nCarroF := 0
Local nDevF   := 0

Local nMercT  := 0
Local nServT  := 0
Local nQtSegT := 0
Local nVlSegT := 0
Local nCarroT := 0
Local nDevT   := 0

Local nMercG  := 0
Local nServG  := 0
Local nQtSegG := 0
Local nVlSegG := 0
Local nCarroG := 0
Local nDevG   := 0

LOCAL cEnter	   := chr(10)
Local _cGrupserv   := GETMV("FS_DEL037")
Local _cGrupSeg    := GETMV("FS_DEL001")
Local _cFuncao	   := ""

titulo  := "Relatorio de Vendedores Sintetico - Loja: "+xFilial("SF2")+" - Periodo: "+DToC(MV_PAR02)+" à "+ DToC(MV_PAR03)

///////////////////////////////////////////////////// Vendedor /////////////////////////////////////////////////////

cQuery := "SELECT  SF2.F2_DOC,SF2.F2_VEND1, SF2.F2_TIPVND, SA3.A3_NOME, 0 AS  QTD_ALIN, 0 AS QTD_MONT,"+cEnter

//////////// Valor Mercadoria
cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0) )   "+cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2 ,"+retsqlname("SB1")+" SB1 ,"+retsqlname("SF4")+" SF4 "+cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC "+cEnter
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "+cEnter
cQuery += " AND SD2.D2_LOJA = SF2.F2_LOJA "  +cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND B1_DEPTODV <> 'TAC' " // TAC NAO ENTRA PARA COMISSAO
cQuery += " AND SB1.B1_COD = D2_COD "+cEnter
cQuery += " AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S' "+cEnter
cQuery += " ),0,0) VLMERC, "+cEnter  // Valor de mercadoria nao precisa realcionar com a PB4

//////////// Valor Servico
//cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0)  )  "+cEnter
cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0) * PB4_PERC / 100 )  "+cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2 ,"+retsqlname("SB1")+" SB1,"+retsqlname("PB4")+" PB4 ,"+retsqlname("SF4")+" SF4 "  +cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = D2_COD "+cEnter
cQuery += " AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_CODIGO = SD2.D2_TES "+cEnter
cQuery += " AND SF4.F4_DUPLIC = 'S' AND PB4.PB4_FILIAL = '" + xFilial('PB4') + "' AND PB4.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND PB4.PB4_FUNCAO = '3' AND PB4.PB4_META = '4' "+cEnter

If AllTrim(Upper(TcGetDb())) == "DB2"
	cQuery += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN "
	cQuery += " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND  "+cEnter
	cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLSERV,   "+cEnter
Else
	cQuery += " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN "
	cQuery += " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND  "+cEnter
	cQuery += " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM),0,0) VLSERV,   "+cEnter
EndIf

//////////// Qtd. Seguros
cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_QUANT,0)  )  "+cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2 ,"+retsqlname("SB1")+" SB1,"+retsqlname("SF4")+" SF4 "  +cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = D2_COD "+cEnter
cQuery += " AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' " +cEnter
cQuery += " AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S' "+cEnter
cQuery += " AND B1_GRUPO IN "+FORMATIN( _cGrupSeg, '/' )+"),0,0) QTDSEG, "+cEnter

//////////// Valor Seguros
cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0) )  "+cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2 ,"+retsqlname("SB1")+" SB1,"+retsqlname("SF4")+" SF4 "  +cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = D2_COD "+cEnter
cQuery += " AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_CODIGO = SD2.D2_TES "+cEnter
cQuery += " AND SF4.F4_DUPLIC = 'S' "+cEnter
cQuery += " AND B1_GRUPO IN "+FORMATIN( _cGrupSeg, '/' )+"),0,0) VLSEG ,"+cEnter

//////////// Qtd. Carros
//cQuery += " COALESCE(( SELECT COUNT(*) " +cEnter
cQuery += " COALESCE(( SELECT COUNT( DISTINCT D2_DOC ) " +cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2 ,"+retsqlname("SB1")+" SB1,"+retsqlname("SF4")+" SF4 "  +cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SB1.B1_COD = D2_COD AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S' "+cEnter
cQuery += " AND B1_GRUPO IN "+FORMATIN( _cGrupserv, '/' )+" "+cEnter
cQuery += " GROUP BY SB1.B1_GRUPO ),0,0) QTDCAR , "+cEnter

//////////// Valor Devolucao
//cQuery += " COALESCE(( SELECT SUM( COALESCE(D1_TOTAL,0) )  "+cEnter
//cQuery += " COALESCE(( SELECT SUM( COALESCE(D1_TOTAL,0) * PB4_PERC / 100 )  "+cEnter
cQuery += " COALESCE(( SELECT SUM( COALESCE(D1_QUANT*D2_PRCVEN,0) * PB4_PERC / 100 )  "+cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2 " +cEnter
cQuery += " LEFT OUTER JOIN "+retsqlname("SD1")+" SD1 ON (SD1.D1_FILIAL = SD2.D2_FILIAL "       +cEnter
cQuery += " AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE "+cEnter
cQuery += " AND SD1.D1_ITEMORI = SD2.D2_ITEM),"+retsqlname("SB1")+" SB1 ,"+retsqlname("PB4")+" PB4 "  +cEnter
cQuery += ","+retsqlname("SF4")+" SF4 " +cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SB1.B1_COD = D2_COD AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S' "+cEnter
cQuery += " AND PB4.PB4_FILIAL = '" + xFilial('PB4') + "' AND PB4.D_E_L_E_T_ = ' ' AND PB4.PB4_FUNCAO = '3' "+cEnter
//cQuery += " AND PB4.PB4_META = '6' "+cEnter
cQuery +=  "AND PB4.PB4_META <> '2' "+cEnter // A Meta 2 esta dentro da 1 para o Vendedor

If AllTrim(Upper(TcGetDb())) == "DB2"
	cQuery += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN "
	cQuery += " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND  "+cEnter
	//cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLSERV,   "+cEnter
	cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLDEV,   "+cEnter
Else
	cQuery += " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN "
	cQuery += " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND  "+cEnter
	cQuery += " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM),0,0) VLDEV,   "+cEnter
	
EndIf

cQuery += " ' ' FUNCAO "+cEnter

cQuery += " FROM "+retsqlname("SF2")+" SF2 ,"+retsqlname("SA3")+" SA3 "+cEnter

cQuery += " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND SF2.D_E_L_E_T_ = ' ' "+cEnter
//cQuery += "WHERE SF2.F2_FILIAL = '28' AND SF2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SF2.F2_EMISSAO BETWEEN '"+DTOS( mv_par02)+"' AND '"+ DTOS( mv_par03 )+"' AND " +cEnter
cQuery += " SF2.F2_VALFAT > 0 "+cEnter
cQuery += " AND F2_TIPVND IN ("+Parse_Tipo(MV_PAR01)+") AND SF2.F2_VEND1 BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' AND SF2.F2_VEND1 = SA3.A3_COD"+cEnter

///////////////////////////////////////////////////// Montador /////////////////////////////////////////////////////
cQuery += " UNION "+cEnter

//////////// Qtd Alinhamentos
cQuery += " SELECT  SF2.F2_DOC,PAB.PAB_CODTEC AS F2_VEND1 , SF2.F2_TIPVND, SA3.A3_NOME, "+cEnter
cQuery += " (SELECT COUNT(*) QTD FROM "+retsqlname("PAB")+" PAB "+cEnter
cQuery += " WHERE PAB.PAB_FILIAL = SL1.L1_FILIAL AND PAB.D_E_L_E_T_  = ' ' "+cEnter
cQuery += " AND PAB.PAB_FUNCAO = '1' AND PAB.PAB_ORC = SL1.L1_NUM GROUP BY PAB_FILIAL, PAB_ORC ) QTD_ALIN, "+cEnter

//////////// Qtd Montagem
cQuery += " (SELECT COUNT(*) QTD FROM "+retsqlname("PAB")+" PAB " +cEnter
cQuery += " WHERE PAB.PAB_FILIAL = SL1.L1_FILIAL AND PAB.D_E_L_E_T_  = ' ' "+cEnter
cQuery += " AND PAB.PAB_FUNCAO = '2' AND PAB.PAB_ORC = SL1.L1_NUM GROUP BY PAB_FILIAL, PAB_ORC ) QTD_MONT,"   +cEnter

//////////// Valor Mercadoria
cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0) * PB4_PERC / 100  )  "+cEnter
//cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0)  )  "+cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2,"+retsqlname("SB1")+ " SB1, "+retsqlname("PB4")+" PB4,"+retsqlname("SF4")+" SF4 "+cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = D2_COD "+cEnter
cQuery += " AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_CODIGO = SD2.D2_TES "+cEnter
cQuery += " AND SF4.F4_DUPLIC = 'S' AND PB4.PB4_FILIAL = '" + xFilial('PB4') + "' AND PB4.D_E_L_E_T_ = ' ' "+cEnter
//cQuery += " AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO AND PB4.PB4_META IN ('1','2', '3') "+cEnter
cQuery += " AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO AND PB4.PB4_META IN ('1','3') "+cEnter

If AllTrim(Upper(TcGetDb())) == "DB2"
	cQuery += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN "
	cQuery += " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND  "+cEnter
	//	cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLSERV,   "+cEnter
	cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLMERC,   "+cEnter
Else
	cQuery += " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN "
	cQuery += " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND  "+cEnter
	cQuery += " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM),0,0) VLMERC,   "+cEnter
EndIf

//////////// Valor Servico
cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0) * PB4_PERC / 100 )  "+cEnter
//cQuery += " COALESCE(( SELECT SUM( COALESCE(D2_TOTAL,0)  )  "+cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2,"+retsqlname("SB1")+ " SB1, "+retsqlname("PB4")+" PB4,"+retsqlname("SF4")+" SF4 "+cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = D2_COD "+cEnter
cQuery += " AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_CODIGO = SD2.D2_TES "+cEnter
cQuery += " AND SF4.F4_DUPLIC = 'S' AND PB4.PB4_FILIAL = '" + xFilial('PB4') + "' AND PB4.D_E_L_E_T_ = ' ' "+cEnter
//cQuery += " AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO AND PB4.PB4_META = '4' "+cEnter
cQuery += " AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO "

If AllTrim(Upper(TcGetDb())) == "DB2"
	cQuery += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN "
	cQuery += " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND  "+cEnter
	cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLSERV,   "+cEnter
Else
	cQuery += " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN "
	cQuery += " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND  "+cEnter
	cQuery += " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM),0,0) VLSERV,   "+cEnter
EndIf

cQuery += " 0 AS QTDSEG , "+cEnter
cQuery += " 0 AS VLSEG , "+cEnter
cQuery += " 0 AS QTDCAR, "+cEnter

//////////// Valor Devolucao
cQuery += " COALESCE((SELECT SUM(  COALESCE(D1_TOTAL,0) * PB4_PERC  / 100 )  " +cEnter
//cQuery += " COALESCE((SELECT SUM(  COALESCE(D1_TOTAL,0) )  " +cEnter
cQuery += " FROM "+retsqlname("SD2")+" SD2"   +cEnter
cQuery += " LEFT OUTER JOIN "+retsqlname("SD1")+" SD1 ON (SD1.D1_FILIAL = SD2.D2_FILIAL "+cEnter
cQuery += " AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE "+cEnter
cQuery += " AND SD1.D1_ITEMORI = SD2.D2_ITEM) ,"+retsqlname("SB1")+" SB1,"+retsqlname("PB4")+" PB4 ,"+retsqlname("SF4")+" SF4"  +cEnter
cQuery += " WHERE SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SB1.B1_COD = D2_COD AND SF4.F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.F4_DUPLIC = 'S' "+cEnter
cQuery += " AND PB4.PB4_FILIAL = '" + xFilial('PB4') + "' AND PB4.D_E_L_E_T_ = ' ' "+cEnter
//cQuery += " AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO AND PB4.PB4_META = '4' "+cEnter
cQuery += " AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO "

If AllTrim(Upper(TcGetDb())) == "DB2"
	cQuery += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN "
	cQuery += " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND  "+cEnter
	//	cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLSERV,   "+cEnter
	cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)),0,0) VLDEV,   "+cEnter
Else
	cQuery += " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN "
	cQuery += " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND  "+cEnter
	cQuery += " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM),0,0) VLDEV,   "+cEnter
EndIf

cQuery += " PAB.PAB_FUNCAO FUNCAO "+cEnter
cQuery += " FROM "+retsqlname("SF2")+" SF2,"+retsqlname("SL1")+" SL1 ,"+retsqlname("PAB")+" PAB, "+retsqlname("SA3")+" SA3 "+cEnter
cQuery += " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND  SF2.D_E_L_E_T_ = ' ' "+cEnter
//cQuery += " WHERE SF2.F2_FILIAL = '28' AND  SF2.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' AND" +cEnter
cQuery += " SF2.F2_VALFAT > 0 AND SL1.L1_FILIAL = SF2.F2_FILIAL AND SL1.D_E_L_E_T_ = ' '"+cEnter
cQuery += " AND SL1.L1_DOC = SF2.F2_DOC AND SL1.L1_SERIE = SF2.F2_SERIE "+cEnter
cQuery += " AND PAB.PAB_FILIAL = SF2.F2_FILIAL AND PAB.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND PAB.PAB_ORC = SL1.L1_NUM "+cEnter
cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.D_E_L_E_T_ = ' ' "+cEnter
cQuery += " AND PAB.PAB_CODTEC=SA3.A3_COD "+cEnter
cQuery += " AND SF2.F2_TIPVND IN ("+Parse_Tipo(MV_PAR01)+") "+cEnter
cQuery += " AND PAB.PAB_CODTEC BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "+cEnter
cQuery += " ORDER BY F2_TIPVND, FUNCAO, F2_VEND1 "+cEnter

If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()
Endif

MEMOWRIT("DELR200.SQL",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1",.F.,.T.)

DbSelectArea("TMP1")

nMercG  := 0
nServG  := 0
nQtSegG := 0
nVlSegG := 0
nCarroG := 0
nDevG   := 0

While !TMP1->(eof())
	
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	
	
	_cTipoAnt := TMP1->F2_TIPVND
	
	@_nLin,000 PSAY "Tipo de Venda: " + _cTipoAnt + ""
	_nLin+=2
	
	nMercT  := 0
	nServT  := 0
	nQtSegT := 0
	nVlSegT := 0
	nCarroT := 0
	nDevT   := 0
	
	
	While !TMP1->(eof()) .and. _cTipoAnt == TMP1->F2_TIPVND
		
		
		IF _nLin > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 09
		EndIF
		
		_cFuncao := TMP1->FUNCAO
		IF EMPTY(_cFuncao)
			@_nLin,005 PSAY "Funcao: Vendedor"
		ElseIf	_cFuncao == "1"
			@_nLin,005 PSAY "Funcao: Alinhador"
		ElseIf	_cFuncao == "2"
			@_nLin,005 PSAY "Funcao: Montador"
		EndIf
		_nLin+=2
		
		
		nMercF  := 0
		nServF  := 0
		nQtSegF := 0
		nVlSegF := 0
		nCarroF := 0
		nDevF   := 0
		
		
		While !TMP1->(eof()) .and. _cTipoAnt == TMP1->F2_TIPVND .And. TMP1->FUNCAO == _cFuncao
			
			IF _nLin > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				_nLin := 09
			EndIF
			
			_cVENDANT  := TMP1->F2_VEND1
			_cNomeAnt  := TMP1->A3_NOME
			
			nMerc  := 0
			nServ  := 0
			nQtSeg := 0
			nVlSeg := 0
			nCarro := 0
			nDev   := 0
			
			While !TMP1->(eof()) .and. _cTipoAnt == TMP1->F2_TIPVND .and. TMP1->FUNCAO == _cFuncao .And. _cVENDANT == TMP1->F2_VEND1
				
				
				If Empty(_cFuncao)//vendedor
					nMerc  += TMP1->VLMERC - TMP1->VLSERV - TMP1->VLSEG - TMP1->VLDEV
				Else                              
					If _cFuncao == "2" // Montador
						nMerc  += (TMP1->VLMERC / TMP1->QTD_MONT)
					Else                      
						nMerc  += (TMP1->VLMERC / TMP1->QTD_ALIN)
					EndIf	
						
				EndIf
				
				
				If Empty(_cFuncao)//vendedor
					nServ  += TMP1->VLSERV
				Else
					
					If _cFuncao == "2" // Montador
						If TMP1->VLMERC > 0  // So tem servico se tiver mercadoria
							nServ  += ((TMP1->VLSERV - TMP1->VLMERC) / TMP1->QTD_MONT)
							//						Else
							//							nServ  += 0
						EndIf
					Else
						nServ  += ((TMP1->VLSERV - TMP1->VLMERC) / TMP1->QTD_ALIN)
					EndIf
				EndIf
				
				nQtSeg += TMP1->QTDSEG
				nVlSeg += TMP1->VLSEG
				nCarro += TMP1->QTDCAR
				nDev   += TMP1->VLDEV
				
				IF EMPTY(_cFuncao)
					nPos := 0
					If ( nPos := aScan( aVend, { |x| x[1] == _cVENDANT } ) ) == 0
						aAdd( aVend, { _cVENDANT, 0, 0, PadR(_cNomeAnt,25) } )
						nPos := Len( aVend )
					EndIf
					
					aVend[nPos][2] += TMP1->VLMERC-TMP1->VLSERV
					aVend[nPos][3] += TMP1->VLSERV
					
				ElseIf _cFuncao == "1"
					nPos := 0
					If ( nPos := aScan( aAlin, { |x| x[1] == _cVENDANT } ) ) == 0
						aAdd( aAlin, { _cVENDANT, 0, 0, PadR(_cNomeAnt,25) } )
						nPos := Len( aAlin )
					EndIf
					
					aAlin[nPos][2] += TMP1->VLMERC
					aAlin[nPos][3] += TMP1->VLSERV-TMP1->VLMERC
					
				ElseIf _cFuncao == "2"
					nPos := 0
					If ( nPos := aScan( aMont, { |x| x[1] == _cVENDANT } ) ) == 0
						aAdd( aMont, { _cVENDANT, 0, 0, PadR(_cNomeAnt,25) } )
						nPos := Len( aMont )
					EndIf
					
					aMont[nPos][2] += TMP1->VLMERC
					aMont[nPos][3] += TMP1->VLSERV-TMP1->VLMERC
					
				EndIf
				
				TMP1->(dbSkip())
			EndDO
			
			IF _nLin > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				_nLin := 09
			EndIF
			
			@_nLin,010 PSAY _cVENDANT
			@_nLin,017 PSAY PadR(_cNomeAnt,25)
			
			If Empty(_cFuncao) //funcao em branco eh vendedor
				@_nLin,051 PSAY nMerc   Picture PesqPict("SD2","D2_TOTAL")
				@_nLin,071 PSAY nServ   Picture PesqPict("SD2","D2_TOTAL")
				@_nLin,091 PSAY nMerc+nServ   Picture PesqPict("SD2","D2_TOTAL")
				@_nLin,111 PSAY nQtSeg  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
				@_nLin,131 PSAY nVlSeg  Picture PesqPict("SD2","D2_TOTAL")
				@_nLin,151 PSAY nCarro  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
//				@_nLin,168 PSAY nDev    Picture PesqPict("SD2","D2_TOTAL")
				
			ElseIf _cFuncao == "2" //montador
				If nMerc > 0
					@_nLin,051 PSAY nMerc   Picture PesqPict("SD2","D2_TOTAL")
					@_nLin,071 PSAY nServ   Picture PesqPict("SD2","D2_TOTAL")
					@_nLin,091 PSAY nMerc+nServ   Picture PesqPict("SD2","D2_TOTAL")
				Else
					@_nLin,091 PSAY 0   Picture PesqPict("SD2","D2_TOTAL")
				EndIf
				
			ElseIf _cFuncao == "1" //alinhador
				@_nLin,071 PSAY nServ   Picture PesqPict("SD2","D2_TOTAL")
				@_nLin,091 PSAY nMerc+nServ   Picture PesqPict("SD2","D2_TOTAL")
				
			EndIf
			
			_nLin := _nLin + 1
			
			nMercF  += nMerc
			nServF  += nServ
			nQtSegF += nQtSeg
			nVlSegF += nVlSeg
			nCarroF += nCarro
			nDevF   += nDev
			
			
		End //FIM DA FUNCAO
		_nLin := _nLin + 1
		@_nLin,005 PSAY "Total da Funcao:"
		
		@_nLin,051 PSAY nMercF          Picture PesqPict("SD2","D2_TOTAL")
		@_nLin,071 PSAY nServF         Picture PesqPict("SD2","D2_TOTAL")
		@_nLin,091 PSAY nMercF+nServF  Picture PesqPict("SD2","D2_TOTAL")
		@_nLin,111 PSAY nQtSegF        Picture '@E 99,999,999' // PesqPict("SD2","D2_QUANT")
		@_nLin,131 PSAY nVlSegF        Picture PesqPict("SD2","D2_TOTAL")
		@_nLin,151 PSAY nCarroF        Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
//		@_nLin,168 PSAY nDevF          Picture PesqPict("SD2","D2_TOTAL")
		
		_nLin := _nLin + 2
		
		If Empty(_cFuncao)
			nMercT  += nMercF
			nServT  += nServF
			nQtSegT += nQtSegF
			nVlSegT += nVlSegF
			nCarroT += nCarroF
			nDevT   += nDevF
		EndIf
		
	End // FIM DO TIPO DA VENDA
	
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	
	_nLin := _nLin + 1
	
	@_nLin,000 PSAY "Total do Tipo de Venda:"
	@_nLin,051 PSAY nMercT   Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,071 PSAY nServT   Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,091 PSAY nMercT+nServT   Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,111 PSAY nQtSegT  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
	@_nLin,131 PSAY nVlSegT  Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,151 PSAY nCarroT  Picture '@E 99,999,999' //PesqPict("SD2","D2_QUANT")
//	@_nLin,168 PSAY nDevT    Picture PesqPict("SD2","D2_TOTAL")
	
	_nLin := _nLin + 3	
	
	nMercG  += nMercT
	nServG  += nServT
	nQtSegG += nQtSegT
	nVlSegG += nVlSegT
	nCarroG += nCarroT
	nDevG   += nDevT
	
endDO

/* 
IF _nLin > 58
cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
_nLin := 09
EndIF

_nLin := _nLin + 1

@_nLin,000 PSAY "Total Geral (todas as vendas): "
@_nLin,051 PSAY nMercG   Picture PesqPict("SD2","D2_TOTAL")
@_nLin,071 PSAY nServG   Picture PesqPict("SD2","D2_TOTAL")
@_nLin,091 PSAY nMercG+nServG   Picture PesqPict("SD2","D2_TOTAL")
@_nLin,111 PSAY nQtSegG  Picture PesqPict("SD2","D2_QUANT")
@_nLin,131 PSAY nVlSegG  Picture PesqPict("SD2","D2_TOTAL")
@_nLin,151 PSAY nCarroG  Picture PesqPict("SD2","D2_QUANT")
@_nLin,168 PSAY nDevG    Picture PesqPict("SD2","D2_TOTAL")
 */

// Vendedores
/*
_nLin := 90
_nTotReMerc := 0
_nTotReServ := 0

For nI := 1 To Len( aVend )
	Cabec1 := 'Resumo de Vendedores'
	Cabec2 := 'Vendedor                                               Mercadoria             Servico               Total'
	
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	
	_nLin++
	
	@_nLin,000 PSAY aVend[nI][1]
	@_nLin,007 PSAY aVend[nI][4]
	@_nLin,051 PSAY aVend[nI][2] 				 Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,071 PSAY aVend[nI][3] 				 Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,091 PSAY aVend[nI][2]+aVend[nI][3]    Picture PesqPict("SD2","D2_TOTAL")
	
	_nTotReMerc += aVend[nI][2]
	_nTotReServ += aVend[nI][3]
	
Next


If _nTotReMerc > 0 .or. _nTotReServ > 0
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	_nLin++
	
	@_nLin,000 PSAY 'Total'
	@_nLin,051 PSAY _nTotReMerc				  Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,071 PSAY _nTotReServ 			  Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,091 PSAY _nTotReMerc+_nTotReServ   Picture PesqPict("SD2","D2_TOTAL")
EndIf


// Alinhadores

_nLin := 90
_nTotReMerc := 0
_nTotReServ := 0

For nI := 1 To Len( aAlin )
	Cabec1 := 'Resumo de Alinhadores'
	Cabec2 := 'Vendedor                                               Mercadoria             Servico               Total'
	
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	
	_nLin++
	
	@_nLin,000 PSAY aAlin[nI][1]
	@_nLin,007 PSAY aAlin[nI][4]
	@_nLin,051 PSAY aAlin[nI][2] 				 Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,071 PSAY aAlin[nI][3] 				 Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,091 PSAY aAlin[nI][2]+aAlin[nI][3]    Picture PesqPict("SD2","D2_TOTAL")
	
	_nTotReMerc += aAlin[nI][2]
	_nTotReServ += aAlin[nI][3]
	
Next

If _nTotReMerc > 0 .or. _nTotReServ > 0
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	_nLin++
	
	@_nLin,000 PSAY 'Total'
	@_nLin,051 PSAY _nTotReMerc				  Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,071 PSAY _nTotReServ 			  Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,091 PSAY _nTotReMerc+_nTotReServ   Picture PesqPict("SD2","D2_TOTAL")
EndIf



// Montadores

_nLin := 90
_nTotReMerc := 0
_nTotReServ := 0

For nI := 1 To Len( aMont )
	Cabec1 := 'Resumo de Montadores'
	Cabec2 := 'Vendedor                                               Mercadoria             Servico               Total'
	
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	
	_nLin++
	
	@_nLin,000 PSAY aMont[nI][1]
	@_nLin,007 PSAY aMont[nI][4]
	@_nLin,051 PSAY aMont[nI][2] 				 Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,071 PSAY aMont[nI][3] 				 Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,091 PSAY aMont[nI][2]+aMont[nI][3]    Picture PesqPict("SD2","D2_TOTAL")
	
	_nTotReMerc += aMont[nI][2]
	_nTotReServ += aMont[nI][3]
	
Next


If _nTotReMerc > 0 .or. _nTotReServ > 0
	IF _nLin > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 09
	EndIF
	_nLin++
	
	@_nLin,000 PSAY 'Total'
	@_nLin,051 PSAY _nTotReMerc				  Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,071 PSAY _nTotReServ 			  Picture PesqPict("SD2","D2_TOTAL")
	@_nLin,091 PSAY _nTotReMerc+_nTotReServ   Picture PesqPict("SD2","D2_TOTAL")
EndIf
*/

Roda()

Set Device To Screen
If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif

MS_FLUSH()

RETURN

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³Funcao    ³VALIDPERG³ Autor ³ ROBERTO R.MEZZALIRA   ³ Data ³ 21.03.05 ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³Descricao ³ Verifica perguntas, incluindo-as caso nao existam         ³±
±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/


Static Function ValidPerg()

local j      := 0
local i      := 0
ssAlias      := Alias()
cPerg        := PADR(cPerg,len(sx1->x1_grupo))
aRegs        := {}

dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Tipo de Venda ?", "Tipo de Venda?","Tipo de Venda?","mv_ch1","C",05,0,0,"G","","mv_par01", "","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data de       ?", "Data  de     ?","Data      de ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data ate      ?", "Data ate     ?","Data     ate ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Vendedor de   ?", "Vendedor de  ?","Vendedor de ?"  ,"mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})
AADD(aRegs,{cPerg,"05","Vendedor ate  ?", "Vendedor ate ?","Vendedor ate?"  ,"mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(ssAlias)
Return

Static Function Parse_Tipo(cVar)
local cRet := ""
Local nXa := 0
Local cPref := "'"
if !empty(cVar)
	for nXa := 1 to len(Alltrim(cVar))
		cRet += cPref + Substr(cVar,nXa,1)
		cPref := "','"
	next nXa
	cRet += "'"
Else
	cRet := "'/'"
Endif
Return(cRet)

