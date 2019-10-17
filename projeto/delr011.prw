/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELR011  บAutor  ณRicardo Mansano     บ Data ณ  04/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Telecobranca                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamado via Menu.                                          บฑฑ
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
Project Function DELR011()
Local cQuery     	:= ""
Local aOrd       	:= {}
Local cDesc1     	:= "Este programa eh responsavel pela"
Local cDesc2     	:= "geracao do Relatorio de Telecobranca"
Local cDesc3     	:= ""
Private cbtxt    	:= Space(10)
Private cbcont   	:= 00
Private cTitulo  	:= "Telecobranca"
Private m_pag    	:= 01  // Pagina Inicial (deve constar em todos os relatorios)
Private cPerg    	:= "DEL011"
Private nNomeProg 	:= "DEL011"
Private cString  	:= "SE1"
Private aReturn  	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private wnrel    	:= nNomeProg
Private cTamanho  	:= "P" // "P"equeno "M"edio "G"rande
Private nTipo    	:= 18  // 15=Comprimido 18=Normal


// Impede Execucao em Ambiente Codebase
#IFDEF TOP
#ELSE
	Aviso("Aten็ใo !","Relatorio s๓ pode ser executado na Matriz - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
	Return Nil
#ENDIF

// Ajusta Perguntas
PutSx1(cPerg,"01","Do Grupo de Atendimento   ?","","","mv_ch1" ,"C",02,0,0,"G","","SUA","","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"02","Ate o Grupo de Atendimento?","","","mv_ch2" ,"C",02,0,0,"G","","SUA","","","MV_PAR02"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"03","Do Codigo de Operador     ?","","","mv_ch3" ,"C",06,0,0,"G","","SU7","","","MV_PAR03"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSx1(cPerg,"04","Ate o Codigo de Operador  ?","","","mv_ch4" ,"C",06,0,0,"G","","SU7","","","MV_PAR04"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","","")
PutSX1(cPerg,"05","Da data                   ?","","","mv_ch5" ,"D",08,0,0,"G","",""   ,"","","MV_PAR05"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"06","Ate a data                ?","","","mv_ch6" ,"D",08,0,0,"G","",""   ,"","","MV_PAR06"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
Pergunte(cPerg,.F.)

// Variaveis utilizadas para Impresso do Cabealho e Rodap (Obrigatorias)
cbtxt    := SPACE(10)
cbcont   := 0
Li       := 80
m_pag    := 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa Relatorio  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,nNomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,cTamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| StaticRel(@lEnd,wnRel,cString,cTamanho,nTipo)},cTitulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStaticRel บAutor  ณRicardo Mansano     บ Data ณ  03/06/05   บฑฑ
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
Local cAliasTRB 	:= "TRB"
Local nX			:= 0
//Anderson em 26/09/2005 - Substituida linha abaixo
//Local aStrucTRB		:= SE5->(dbStruct())
Local aStrucTRB		:= SE1->(dbStruct())
Local nValFat		:= 0

// Totalizadores
Local nTotOriParc	:= 0
Local nTotRecParc	:= 0
Local nTotOriGer 	:= 0
Local nTotRecGer 	:= 0

// Variaveis de Acumulo
Local cOldOperador 	:= ""

Local Cabec2		:= ""
Local Cabec1		:= " Pref Titulo Parc. TP  Dt.Original Data Baixa     Valor Orig.      Valor Recup."
//
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parmetros                                               ณ
//ณ MV_PAR01   	Do codigo do Grupo de Atendimento                                      ณ
//ณ MV_PAR02	Ate o codigo do Grupo de Atendimento                                   ณ
//ณ MV_PAR03	Do codigo do operador                                                  ณ
//ณ MV_PAR04	Ate o codigo do operador                                               ณ
//ณ MV_PAR05	Da data                                                                ณ
//ณ MV_PAR06	Ate a data                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
cQuery := " SELECT DISTINCT ACF_OPERAD,ACG_PREFIX,ACG_TITULO,ACG_PARCEL,ACG_TIPO,E1_VENCREA,	"
cQuery += " E5_DATA,E1_VALOR,E5_VALOR                                              	"
cQuery += " FROM "+RetSqlName("ACF")+" ACF,"+RetSqlName("ACG")+" ACG,             	"
cQuery +=          RetSqlName("SE5")+" E5 ,"+RetSqlName("SE1")+" E1 ,            	"
cQuery +=          RetSqlName("SU7")+" U7           								"
cQuery += " WHERE U7_POSTO   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'             	"
cQuery += " AND   ACF_OPERAD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'             	"
cQuery += " AND   E5_DATA    BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"'	"
cQuery += " AND   U7_COD     = ACF_OPERAD                                           "
cQuery += " AND   ACG_PREFIX = E5_PREFIXO                                           "
cQuery += " AND   ACG_TITULO = E5_NUMERO                                            "
cQuery += " AND   ACG_PARCEL = E5_PARCELA                                           "
cQuery += " AND   ACG_TIPO   = E5_TIPO                                              "
cQuery += " AND   ACF_CLIENT = E5_CLIENTE                                           "
cQuery += " AND   ACF_LOJA   = E5_LOJA                                              "
cQuery += " AND   ACG_PREFIX = E1_PREFIXO                                           "
cQuery += " AND   ACG_TITULO = E1_NUM                                               "
cQuery += " AND   ACG_PARCEL = E1_PARCELA                                           "
cQuery += " AND   ACG_TIPO   = E1_TIPO                                              "
cQuery += " AND   ACF_CLIENT = E1_CLIENTE                                           "
cQuery += " AND   ACF_LOJA   = E1_LOJA                                              "
cQuery += " AND   ACG_CODIGO = ACF_CODIGO                                           "
cQuery += " AND   ACG_FILIAL = ACF_FILIAL                                           "
cQuery += " AND   ACG_FILIAL = E5_FILIAL                                            "
cQuery += " AND   ACG_FILIAL = E1_FILIAL                                            "
cQuery += " AND   ACF.D_E_L_E_T_ <> '*'                                             "
cQuery += " AND   ACG.D_E_L_E_T_ <> '*'                                             "
cQuery += " AND   E1.D_E_L_E_T_  <> '*'                                             "
cQuery += " AND   E5.D_E_L_E_T_  <> '*'                                             "
cQuery += " AND   U7.D_E_L_E_T_  <> '*'                                             "
cQuery += " ORDER BY ACF_OPERAD,ACG_PREFIX,ACG_TITULO,ACG_PARCEL                    "
*/

// Anderson
// Query acima modificada em 26/09/2005 apos conversa com a Srta. Fabiana/DellaVia
// Haviam registros repetidos, pois o relatorio mostrava cada lancamento do E5 ref. ao E1
// Porem a Coluna Total Recuperado NAO estava OK, pois a mesma acaba mostrando o E5_VALOR, o que no final acabamos tendo um TOTAL errado.
// Srta. Fabiana sugeriu que mostrassemos somente o titulo do E1 e nao os lancamentos do E5 (E1_VALOR e E1_VALLIQ que ja esta OK confrome E5 na coluna Valor Recuperado)

cQuery := " SELECT DISTINCT ACF_OPERAD,ACG_PREFIX,ACG_TITULO,ACG_PARCEL,ACG_TIPO,E1_VENCREA,	"
cQuery += " E1_BAIXA,E1_VALOR,E1_VALLIQ                                             	"
cQuery += " FROM "+RetSqlName("ACF")+" ACF,"+RetSqlName("ACG")+" ACG,             	"
cQuery +=          RetSqlName("SE1")+" E1 ,"+RetSqlName("SU7")+" U7	            	"
cQuery += " WHERE U7_POSTO   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'             	"
cQuery += " AND   ACF_OPERAD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'             	"
cQuery += " AND   E1_BAIXA    BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"'	"
cQuery += " AND   U7_COD     = ACF_OPERAD                                           "
cQuery += " AND   ACG_PREFIX = E1_PREFIXO                                           "
cQuery += " AND   ACG_TITULO = E1_NUM                                               "
cQuery += " AND   ACG_PARCEL = E1_PARCELA                                           "
cQuery += " AND   ACG_TIPO   = E1_TIPO                                              "
cQuery += " AND   ACF_CLIENT = E1_CLIENTE                                           "
cQuery += " AND   ACF_LOJA   = E1_LOJA                                              "
cQuery += " AND   ACG_CODIGO = ACF_CODIGO                                           "
cQuery += " AND   ACG_FILIAL = ACF_FILIAL                                           "
cQuery += " AND   ACG_FILIAL = E1_FILIAL                                            "
cQuery += " AND   ACF.D_E_L_E_T_ <> '*'                                             "
cQuery += " AND   ACG.D_E_L_E_T_ <> '*'                                             "
cQuery += " AND   E1.D_E_L_E_T_  <> '*'                                             "
cQuery += " AND   U7.D_E_L_E_T_  <> '*'                                             "
cQuery += " ORDER BY ACF_OPERAD,ACG_PREFIX,ACG_TITULO,ACG_PARCEL                    "

cQuery := ChangeQuery(cQuery)
// Cria tabela temporแria para o Relatorio
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)},"Aguarde...","Processando Dados...")
// Trata campos diferente de Caracter
For nX := 1 To Len(aStrucTRB)
	If aStrucTRB[nX][2] <> "C" .And. FieldPos(aStrucTRB[nX][1]) <> 0
		TcSetField(cAliasTRB,aStrucTRB[nX][1],aStrucTRB[nX][2],aStrucTRB[nX][3],aStrucTRB[nX][4])
	EndIf
Next nX
// Refaz a estrutura do Campo E1_VENCREA
TcSetField(cAliasTRB,"E1_VENCREA","D",8,0)

MemoWrite("DELR011_AK.SQL", cQuery)

SetRegua(RecCount())
aDados    := {}
While TRB->(!Eof())
	IncRegua()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Imprime Cabecalho.                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Li > 60
		Cabec(cTitulo,cabec1,cabec2,nNomeprog,cTamanho,nTipo)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica salto de Operador                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cOldOperador <> TRB->ACF_OPERAD
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Imprime SubTotal por Operador             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (nTotOriParc > 0).or.(nTotRecParc > 0)
			@ Li,002 PSay "Total Operador:"
			@ Li,047 PSay nTotOriParc Picture "@E 999,999,999.99"
			@ Li,063 PSay nTotRecParc Picture "@E 999,999,999.99"
			Li+=2
			// Zera Subtotais
			nTotOriParc := 0
			nTotRecParc := 0
		Endif
		
		@ Li,000 PSay "OPERADOR: "+TRB->ACF_OPERAD +" - "+ RetField("SU7",1,xFilial("SU7")+TRB->ACF_OPERAD,"U7_NOME")
		Li += 2
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Dados dos Titulos                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ Li,002 PSay TRB->ACG_PREFIX
	@ Li,006 PSay TRB->ACG_TITULO
	@ Li,013 PSay TRB->ACG_PARCEL
	@ Li,019 PSay TRB->ACG_TIPO
	@ Li,023 PSay DtoC(TRB->E1_VENCREA)
	@ Li,035 PSay DtoC(TRB->E1_BAIXA)
	@ Li,047 PSay TRB->E1_VALOR Picture "@E 999,999,999.99"
	//Anderson em 26/09/2005 - Substituida linha abaixo
	//@ Li,063 PSay TRB->E5_VALOR Picture "@E 999,999,999.99"
	@ Li,063 PSay TRB->E1_VALLIQ Picture "@E 999,999,999.99"
	Li++
	
	// Totalizadores
	nTotOriParc	+= TRB->E1_VALOR
	nTotOriGer 	+= TRB->E1_VALOR
	//Anderson em 26/09/2005 - Substituida linha abaixo
	//nTotRecParc	+= TRB->E5_VALOR
	//nTotRecGer 	+= TRB->E5_VALOR
	nTotRecParc	+= TRB->E1_VALLIQ
	nTotRecGer 	+= TRB->E1_VALLIQ
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Guarda informacoes para verificar o saltos do relatorio  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cOldOperador := TRB->ACF_OPERAD
	
	TRB->(dbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Imprime SubTotal Final e Total Geral      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ Li,002 PSay "Total Operador:"
@ Li,047 PSay nTotOriParc Picture "@E 999,999,999.99"
@ Li,063 PSay nTotRecParc Picture "@E 999,999,999.99"
Li+=2
@ Li,000 PSay "TOTAL GERAL:"
@ Li,047 PSay nTotOriGer  Picture "@E 999,999,999.99"
@ Li,063 PSay nTotRecGer  Picture "@E 999,999,999.99"

// Fecha tabela temporaria (outras tabela temporarias foram fechadas ao fim de seu uso)
TRB->(dbCloseArea())

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return NIL
