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
    Titulo  := "Mov. Estoque Armazem de "+mv_par07+" ate "+mv_par08  // aOrd[aReturn[8]]
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
       GeraTmp()
       //
       cabec1  := "Produto Descricao                                     Saldo   Fisico   Apurado "
       cabec2  := "-------------------------------------------------------------------------------"
       //          xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999999   ______   _______
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
          cabec(Titulo,"Filial : "+SM0->M0_NOME+Space(16)+"movimentacoes de "+dtoc(mv_par05)+" ate "+dtoc(mv_par06),"",nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
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



Static Function GeraTmp()
     //
     Private oProcess := Nil
     oProcess := MsNewProcess():New({|lEnd| ResRelTmp(lEnd,oProcess)},"Processando","Lendo...",.t.)
     oProcess:Activate()
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
Static Function RESRELTmp(lEnd,oObj)
       //
       Local cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,_nTotRec,cQuery2
       Local cAlias, cCampo, _nTotSaldo
       //
       oObj:SetRegua1(3) // SD1, SD2 e SD3 (3 Tabelas)
       //
       cAliasTmp := "RESREL"
       //
       //  --------------------------------------------------------------------------------------------------------------------
       //
       oObj:IncRegua1("Movimentacoes de Saida")
       //
       cAlias := "SD2"
       cCampo := "D2"
       //
       cQuery  := "SELECT Count(*) AS Soma "
       //
       cQuery2 := "FROM "+RetSqlName(cAlias)+" "+cAlias+", "+RetSqlName("SF4")+" SF4, "+RetSqlName("SB1")+" SB1 "
       cQuery2 += "WHERE "
       cQuery2 += cAlias + "." + cCampo + "_FILIAL = '"+cFilAnt+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_TES = SF4.F4_CODIGO AND SF4.F4_ESTOQUE = 'S' AND " 
       cQuery2 += cAlias + "." + cCampo + "_COD = SB1.B1_COD AND SB1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
       cQuery2 += cAlias + ".D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' "
       cQuery2 += "GROUP BY "+cAlias+"."+cCampo+"_FILIAL, "+cAlias+"."+cCampo+"_COD, "+cAlias+"."+cCampo+"_LOCAL "
       cQuery2 += "ORDER BY "+cAlias + "." + cCampo + "_COD"
       //
       cQuery += cQuery2
       //
       //Memowrite("SQL.TXT",cQuery)
       //
       cQuery := ChangeQuery(cQuery)
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       _nTotRec := (cAliasTmp)->SOMA
       dbCloseArea()
       //
       cAliasTmp := "RESREL"
       cQuery := "SELECT "+cAlias+"."+cCampo+"_FILIAL, "+cAlias+"."+cCampo+"_COD, "+cAlias+"."+cCampo+"_LOCAL "
       cQuery += cQuery2
       //
       cQuery := ChangeQuery(cQuery)
       //
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       //
       //TcSetField(cAliasTmp,"B2_QATU","N",TamSx3("B2_QATU")[1], TamSx3("B2_QATU")[2] )
       //
       dbSelectArea(cAliasTmp)
       DbGoTop()
       oObj:SetRegua2(_nTotRec)
       Do While ( !Eof() ) 
          //
          dbSelectArea("SB1") 
          dbSetOrder(1)
          If !dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             //oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC)+"]")
             oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"]")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          dbSelectArea("SB2") 
          dbSetOrder(1)
          If dbSeek(xFilial("SB2")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             //
             dbSelectArea("cArqTmp")  
             dbSetOrder(1) 
             If aReturn[8] == 1
                dbSeek((cAliasTmp)->&(cCampo+"_FILIAL")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             ElseIf aReturn[8] == 2
                dbSeek((cAliasTmp)->&(cCampo+"_FILIAL")+SB1->B1_DESC, .F.)
             Endif
             If !Found()
                // 
                _nTotSaldo := 0.00
                dbSelectArea("SB2")
                Do while !Eof() .and. SB2->B2_FILIAL==xFilial("SB2") .and. SB2->B2_COD == (cAliasTmp)->&(cCampo+"_COD")
                   If SB2->B2_LOCAL >= mv_par07 .and. SB2->B2_LOCAL <= mv_par08
                      _nTotSaldo += SB2->B2_QATU
                   Endif
                   DbSkip()
                Enddo
                //
                dbSelectArea("cArqTmp")  
                If RecLock("cArqTmp",.T.)
	               cArqTmp->FILIAL    := (cAliasTmp)->&(cCampo+"_FILIAL")
	               cArqTmp->PRODUTO   := (cAliasTmp)->&(cCampo+"_COD")
	               cArqTmp->DESCRICAO := SB1->B1_DESC
	               cArqTmp->SALDO     := _nTotSaldo
	               msUnlock()
                Endif
                //
             Endif
             //
          Endif
          //
          dbSelectArea(cAliasTmp)
          //oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC)+"]")
          oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"]")
          dbSkip()
          //
       Enddo
       //
       dbSelectArea(cAliasTmp)
       dbCloseArea()
       dbSelectArea(cAlias)
       //
       //  --------------------------------------------------------------------------------------------------------------------
       //
       oObj:IncRegua1("Movimentacoes de Entrada")
       //
       cAlias := "SD1"
       cCampo := "D1"
       //
       cQuery  := "SELECT Count(*) AS Soma "
       //
       cQuery2 := "FROM "+RetSqlName(cAlias)+" "+cAlias+", "+RetSqlName("SF4")+" SF4, "+RetSqlName("SB1")+" SB1 "
       cQuery2 += "WHERE "
       cQuery2 += cAlias + "." + cCampo + "_FILIAL = '"+cFilAnt+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_DTDIGIT BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_TES = SF4.F4_CODIGO AND SF4.F4_ESTOQUE = 'S' AND " 
       cQuery2 += cAlias + "." + cCampo + "_COD = SB1.B1_COD AND SB1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
       cQuery2 += cAlias + ".D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' "
       cQuery2 += "GROUP BY "+cAlias+"."+cCampo+"_FILIAL, "+cAlias+"."+cCampo+"_COD, "+cAlias+"."+cCampo+"_LOCAL "
       cQuery2 += "ORDER BY "+cAlias + "." + cCampo + "_COD"
       //
       cQuery += cQuery2
       //
       //Memowrite("SQL.TXT",cQuery)
       //
       cQuery := ChangeQuery(cQuery)
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       _nTotRec := (cAliasTmp)->SOMA
       dbCloseArea()
       //
       cAliasTmp := "RESREL"
       cQuery := "SELECT "+cAlias+"."+cCampo+"_FILIAL, "+cAlias+"."+cCampo+"_COD, "+cAlias+"."+cCampo+"_LOCAL "
       cQuery += cQuery2
       //
       cQuery := ChangeQuery(cQuery)
       //
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       //
       dbSelectArea(cAliasTmp)
       DbGoTop()
       oObj:SetRegua2(_nTotRec)
       Do While ( !Eof() ) 
          //
          dbSelectArea("SB1") 
          dbSetOrder(1)
          If !dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             //oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC)+"]")
             oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"]")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          dbSelectArea("SB2") 
          dbSetOrder(1)
          If dbSeek(xFilial("SB2")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             //
             dbSelectArea("cArqTmp")  
             dbSetOrder(1) 
             If aReturn[8] == 1
                dbSeek((cAliasTmp)->&(cCampo+"_FILIAL")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             ElseIf aReturn[8] == 2
                dbSeek((cAliasTmp)->&(cCampo+"_FILIAL")+SB1->B1_DESC, .F.)
             Endif
             If !Found()
                // 
                _nTotSaldo := 0.00
                dbSelectArea("SB2")
                Do while !Eof() .and. SB2->B2_FILIAL==xFilial("SB2") .and. SB2->B2_COD == (cAliasTmp)->&(cCampo+"_COD")
                   If SB2->B2_LOCAL >= mv_par07 .and. SB2->B2_LOCAL <= mv_par08
                      _nTotSaldo += SB2->B2_QATU
                   Endif
                   DbSkip()
                Enddo
                //
                dbSelectArea("cArqTmp")  
                If RecLock("cArqTmp",.T.)
	               cArqTmp->FILIAL    := (cAliasTmp)->&(cCampo+"_FILIAL")
	               cArqTmp->PRODUTO   := (cAliasTmp)->&(cCampo+"_COD")
	               cArqTmp->DESCRICAO := SB1->B1_DESC
	               cArqTmp->SALDO     := _nTotSaldo
	               msUnlock()
                Endif
                //
             Endif
             //
          Endif
          //
          dbSelectArea(cAliasTmp)
          //oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC)+"]")
          oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"]")
          dbSkip()
          //
       Enddo
       //
       dbSelectArea(cAliasTmp)
       dbCloseArea()
       dbSelectArea(cAlias)
       //
       //  --------------------------------------------------------------------------------------------------------------------
       //
       oObj:IncRegua1("Movimentacoes Internas")
       //
       cAlias := "SD3"
       cCampo := "D3"
       //
       cQuery  := "SELECT Count(*) AS Soma "
       //
       cQuery2 := "FROM "+RetSqlName(cAlias)+" "+cAlias+", "+RetSqlName("SB1")+" SB1 "
       cQuery2 += "WHERE "
       cQuery2 += cAlias + "." + cCampo + "_FILIAL = '"+cFilAnt+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_EMISSAO BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_COD = SB1.B1_COD AND SB1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
       cQuery2 += cAlias + ".D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' "
       cQuery2 += "GROUP BY "+cAlias+"."+cCampo+"_FILIAL, "+cAlias+"."+cCampo+"_COD, "+cAlias+"."+cCampo+"_LOCAL "
       cQuery2 += "ORDER BY "+cAlias + "." + cCampo + "_COD"
       //
       cQuery += cQuery2
       //
       //Memowrite("SQL.TXT",cQuery)
       //
       cQuery := ChangeQuery(cQuery)
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       _nTotRec := (cAliasTmp)->SOMA
       dbCloseArea()
       //
       cAliasTmp := "RESREL"
       cQuery := "SELECT "+cAlias+"."+cCampo+"_FILIAL, "+cAlias+"."+cCampo+"_COD, "+cAlias+"."+cCampo+"_LOCAL "
       cQuery += cQuery2
       //
       cQuery := ChangeQuery(cQuery)
       //
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       //
       dbSelectArea(cAliasTmp)
       DbGoTop()
       oObj:SetRegua2(_nTotRec)
       Do While ( !Eof() ) 
          //
          dbSelectArea("SB1") 
          dbSetOrder(1)
          If !dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             //oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC)+"]")
             oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"]")
             dbSelectArea(cAliasTmp)
             dbSkip()
             loop
          Endif
          //
          dbSelectArea("SB2") 
          dbSetOrder(1)
          If dbSeek(xFilial("SB2")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             //
             dbSelectArea("cArqTmp")  
             dbSetOrder(1) 
             If aReturn[8] == 1
                dbSeek((cAliasTmp)->&(cCampo+"_FILIAL")+(cAliasTmp)->&(cCampo+"_COD"), .F.)
             ElseIf aReturn[8] == 2
                dbSeek((cAliasTmp)->&(cCampo+"_FILIAL")+SB1->B1_DESC, .F.)
             Endif
             If !Found()
                // 
                _nTotSaldo := 0.00
                dbSelectArea("SB2")
                Do while !Eof() .and. SB2->B2_FILIAL==xFilial("SB2") .and. SB2->B2_COD == (cAliasTmp)->&(cCampo+"_COD")
                   If SB2->B2_LOCAL >= mv_par07 .and. SB2->B2_LOCAL <= mv_par08
                      _nTotSaldo += SB2->B2_QATU
                   Endif
                   DbSkip()
                Enddo
                //
                dbSelectArea("cArqTmp")  
                If RecLock("cArqTmp",.T.)
	               cArqTmp->FILIAL    := (cAliasTmp)->&(cCampo+"_FILIAL")
	               cArqTmp->PRODUTO   := (cAliasTmp)->&(cCampo+"_COD")
	               cArqTmp->DESCRICAO := SB1->B1_DESC
	               cArqTmp->SALDO     := _nTotSaldo
	               msUnlock()
                Endif
                //
             Endif
             //
          Endif
          //
          dbSelectArea(cAliasTmp)
          //oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC)+"]")
          oObj:IncRegua2("Produto - ["+Alltrim(SB1->B1_COD)+"]")
          dbSkip()
          //
       Enddo
       //
       dbSelectArea(cAliasTmp)
       dbCloseArea()
       dbSelectArea(cAlias)
       //
       //  --------------------------------------------------------------------------------------------------------------------
       //
Return


Static Function Perg(_cPerg)
       //
       Local _cAlias
       Local _lAtualiza:=.f.
       //
       _cAlias := Alias()
       _cPerg  := PADR(_cPerg,6)
       _aRegs  := {}
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
       AADD(_aRegs,{_cPerg,"07","Armazem de                   ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","01","","","","","","","","","","","","","","","","","","","","","Z0",""})
       AADD(_aRegs,{_cPerg,"08","Armazem Ate                  ?","","","mv_ch8","C",02,0,0,"G","","mv_par08","","","","99","","","","","","","","","","","","","","","","","","","","","Z0",""})
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
