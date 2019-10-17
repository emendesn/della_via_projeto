#include "rwmake.CH"

#define LIM_LINHAS 58

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESREL   ºAutor  ³Alexandre Martim    º Data ³  23/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio dos saldos dos produtos que foram movimentados.  º±±
±±º          ³ por data em determinado armazem.                           º±±
±±º          ³                                                            º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESREL()
    //
	Private cDesc1 := "Relatorio dos saldos dos produtos que foram movimentados.      "
	Private cDesc2 := "                                                               "
	Private cDesc3 := "Observar os parametros do Relatorio                            "
	Private cString:="SB2"
	Private limite := 80
	Private nMoeda, cTexto
    //
	Private wnrel
	Private Titulo  := ""
	Private cabec1  := ""
	Private cabec2  := ""
	Private cabec3  := ""
	Private tamanho := "" // Dependera da Ordem escolhida
	//
    Private aReturn := {"Zebrado",1,"Administracao",1,2,1,"",1}
			//           |        |  |              | | | |  |__ Ordem a ser Selecionada
			//           |        |  |              | | | |_____ Expressao de Filtro
			//           |        |  |              | | |_______ Porta ou Arquivo
			//           |        |  |              | |_________ Midia (Disco/Impressora)
			//           |        |  |              |___________ Formato
			//           |        |  |__________________________ Destinatario
			//           |        |_____________________________ Numero de Vias
			//           |______________________________________ Nome do Formulario
	//
    Private aOrd    := {"por Codigo","por Descricao"}
    //
	Private nomeprog:= "RESREL"
	Private aLinha  := { },nLastKey := 0
	Private cPerg   := "RESREL"
	Private nColun  := 0 
	Private nQuebra := 5
    //
    #IFNDEF TOP
         Alert("Este Relatorio foi feito especificamente para ambiente TOP CONNECT!")
    #ENDIF
    //
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLinha := LIM_LINHAS
	m_pag   := 1
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Perg(cPerg)
	pergunte(cPerg,.F.)
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a fun‡„o SETPRINT   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "RESREL"
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho,,.F.)
	//
	If nLastKey == 27
		Return
	Endif
    //
	SetDefault(aReturn,cString)
    //
	If nLastKey == 27
		Return
	Endif
    //
    Titulo  := "Movimentacoes do Estoque no armazem "+mv_par07  // aOrd[aReturn[8]]
    Tamanho := "P"
    //
    Processa( {|| FRESREL(wnRel) }, "saldos por movimentacao..." )
    //
Return


Static Function FRESREL(wnRel)
       //
       Private cbCont:=0,CbTxt:=Space(10),_lPrimeiraVez:=.t.,_cGuarda,_aTotQuebra,_aTotGeral,;
               _aTotLinha, _aTotVend, _aGrupos:={},_cVenGuarda,_lNota := .t.,_lVendedor := .t.,;
               _aPeriodo:={}
       //
       aCampos:={;
 	         {"FILIAL"   , "C" , 02,0},;
  	         {"PRODUTO"  , "C" , 15,0},;
  	         {"DESCRICAO", "C" , 45,0},;
  	         {"SALDO"    , "N" , 13,2},;
  	         {"ULTMOV"   , "D" , 08,0} }
       //
       cArqTmp := CriaTrab(aCampos,.T.)
       dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)
       If aReturn[8] == 1
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+PRODUTO",,,"Selecionando Registros...")
       ElseIf aReturn[8] == 2
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+DESCRICAO",,,"Selecionando Registros...")
       Endif
	   //
       // Processa saldos 
       //
       RESRELTmp()
       //
       cabec1  := "Produto Descricao                                     Saldo   Fisico   Apurado "
       cabec2  := "-------------------------------------------------------------------------------"
       //          xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999999   ------   -------
       //          01234567890123456789012345678901234567890123456789012345678901234567890123456789
       //                    1         2         3         4         5         6         7         
       //
       // Processa o arquivo temporario
       //
       dbSelectArea("cArqTmp")
       DbGoTop()
       ProcRegua(cArqTmp->(RecCount()))
       Do While .t.
          //
          FImpOrd12()
          //
          If Eof()
             Exit
          Endif
          //
          dbSelectArea("cArqTmp")
          IncProc("Imprimindo...")
          DbSkip()
          //
       Enddo
       //
       roda(cbcont,cbtxt,"P")
       //
       Set Device To Screen
       Set Filter To
       //
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Apaga arquivos tempor rios  ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       dbSelectarea("cArqTmp")
       cArqTmp->( dbCloseArea() )
       FErase(cArqTmp+OrdBagExt())
       FErase(cArqTmp+GetDBExtension())
       //
       dbSelectArea("SB2")
       If aReturn[5] = 1
          Set Printer To
          dbCommitAll()
          ourspool(wnrel)
       Endif
       MS_FLUSH()
       //
Return Nil
          
Static Function FLin(_nquant)
       //
       _nLinha += _nquant
       If _nLinha >= LIM_LINHAS
          cabec(Titulo,"Filial : "+SM0->M0_NOME+Space(16)+"movimentacoes de "+dtoc(mv_par05)+" ate "+dtoc(mv_Par06),"",nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
          _nLinha:=8
          @ _nLinha, 000 PSAY cabec1
          _nLinha += 1
          @ _nLinha, 000 PSAY __PrtThinLine()
          _nLinha += 1
       Endif
       //
Return 

Static Function FImpOrd12()
       //
       If Eof()
          Return
       Endif
       //
       FLin(1)
       @ _nLinha,000 PSAY Left(cArqTmp->PRODUTO,6)
	   @ _nLinha,008 PSAY cArqTmp->DESCRICAO
       @ _nLinha,053 PSAY TRANSFORM(cArqTmp->SALDO , "@E 999999")
       @ _nLinha,062 PSAY "______"
       @ _nLinha,071 PSAY "_______"
       //
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³  RESREL   ºAutor  ³Alexandre Martim    º Data ³ 23/09/05    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera dados no arquivo temporario                            º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RESRELTmp()
       //
       Local cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,_nTotRec,cQuery2
       Local cAlias:="SB2",cCampo:="B2", _dMovSaida, _dMovEntrada
       //
       cAliasTmp := "RESREL"
       cQuery  := "SELECT Count(*) AS Soma "
       cQuery2 := "FROM "+RetSqlName(cAlias)+ " "+ cAlias 
       cQuery2 += "WHERE "
       cQuery2 += cAlias + "." + cCampo + "_FILIAL BETWEEN '"+cFilAnt+"' AND '"+cFilAnt+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_LOCAL = '"+mv_par07+"' AND "
       cQuery2 += cAlias + ".D_E_L_E_T_=' '"
       //
       cQuery += cQuery2
       //
       cQuery := ChangeQuery(cQuery)
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       _nTotRec := (cAliasTmp)->SOMA
       dbCloseArea()
       //
       cAliasTmp := "RESREL"
       cQuery := "SELECT SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_QATU, SB2.B2_USAI, SB2.B2_LOCAL "
       cQuery += cQuery2
       cQuery += "ORDER BY "+cAlias + "." + cCampo + "_COD"
       //
       cQuery := ChangeQuery(cQuery)
       //Memowrite("SQL",cQuery)
       //
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       //
       TcSetField(cAliasTmp,"B2_QATU","N",TamSx3("B2_QATU")[1], TamSx3("B2_QATU")[2] )
       TcSetField(cAliasTmp,"B2_USAI","D",TamSx3("B2_USAI")[1], TamSx3("B2_USAI")[2] )
       //
       dbSelectArea(cAliasTmp)
       DbGoTop()
       ProcRegua(_nTotRec)
       Do While ( !Eof() ) 
          //
          dbSelectArea("SB1") 
          dbSetOrder(1)
          If !dbSeek(xFilial("SB1")+(cAliasTmp)->B2_COD, .F.)
             IncProc("Lendo os saldos.")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          If !(SB1->B1_GRUPO >= mv_par03 .and. SB1->B1_GRUPO <= mv_par04)
             IncProc("Lendo os saldos.")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          _dMovSaida   := (cAliasTmp)->&(cCampo+"_USAI")
          _dMovEntrada := SB1->B1_UCOM
          //
          dbSelectArea("SBZ") 
          dbSetOrder(1)
          If dbSeek(xFilial("SBZ")+(cAliasTmp)->B2_COD, .F.)
             _dMovEntrada := Max(SBZ->BZ_UCOM,_dMovEntrada)
          Endif
          //
          _dMovimentacao := Max(_dMovEntrada, _dMovSaida)
          //
          If _dMovimentacao < mv_par05 .or. _dMovimentacao > mv_par06
             IncProc("Lendo os saldos.")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          dbSelectArea(cAliasTmp)
          If RecLock("cArqTmp",.T.)
             cArqTmp->FILIAL    := (cAliasTmp)->&(cCampo+"_FILIAL")
             cArqTmp->PRODUTO   := (cAliasTmp)->&(cCampo+"_COD")
             cArqTmp->DESCRICAO := SB1->B1_DESC
             cArqTmp->SALDO     := (cAliasTmp)->&(cCampo+"_QATU")
             msUnlock()
          Endif
          //
          dbSelectArea(cAliasTmp)
          IncProc("Lendo os saldos.")
          dbSkip()
          //
       Enddo
       //
       dbSelectArea(cAliasTmp)
       dbCloseArea()
       dbSelectArea(cAlias)
       //
Return


Static Function Perg(_cPerg)
       //
       Local _cAlias
       //
       _cAlias  := Alias()
       _cPerg   := PADR(_cPerg,6)
       _aRegs    := {}
       //
       dbSelectArea("SX1")
       dbSetOrder(1)
       //
       AADD(_aRegs,{_cPerg,"01","Produto de                   ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
       AADD(_aRegs,{_cPerg,"02","Produto Ate                  ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1",""})
       AADD(_aRegs,{_cPerg,"03","Grupo de                     ?","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})
       AADD(_aRegs,{_cPerg,"04","Grupo Ate                    ?","","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","ZZZZ","","","","","","","","","","","","","","","","","","","","","SBM",""})
       AADD(_aRegs,{_cPerg,"05","Movimentacao de              ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","",dtoc(dDatabase-1),"","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"06","Movimentacao Ate             ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","",dtoc(dDatabase),"","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"07","Armazem                      ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","01","","","","","","","","","","","","","","","","","","","","","Z0",""})
       //
       For i := 1 to Len(_aRegs)
           If !DbSeek(_cPerg+_aRegs[i,2])
              RecLock("SX1",.T.)
              For j := 1 to FCount()
                  If j <= Len(_aRegs[i])
                     FieldPut(j,_aRegs[i,j])
                  Endif
              Next
              MsUnlock()
           Endif
       Next
       DbSelectArea(_cAlias)
       //
Return
