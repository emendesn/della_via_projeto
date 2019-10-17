#include "rwmake.CH"

#define LIM_LINHAS 58

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ cli0002  ºAutor  ³Eugenio Arcanjo     º Data ³  04/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio dos Cliente com titulos em abertos            .  º±±
±±º          ³       											          º±±
±±º          ³                                                            º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³cobranca                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function cli0002()
    //
	Private cDesc1 := "Relatorio dos Titulos em aberto por emissao                    "
	Private cDesc2 := "                                                               "
	Private cDesc3 := "Observar os parametros do Relatorio                            "
    Private cString:="SA1"
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
    Private aOrd    := {"por NOME"}
    //
	Private nomeprog:= "cli0002"
	Private aLinha  := { },nLastKey := 0
	Private cPerg   := "CLI002"
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
	wnrel := "cli0002"
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
    Titulo  := "Relacao de Clientes com Titulos em Aberto "  // aOrd[aReturn[8]]
    Tamanho := "M"
    //
    Processa( {|| FCLI002(wnRel) }, "Titulos em aberto..." )
    //
Return


Static Function FCLI002(wnRel)
       //
       Private cbCont:=0,CbTxt:=Space(10),_lPrimeiraVez:=.t.,_cGuarda,_aTotQuebra,_aTotGeral,;
               _aTotLinha, _aTotVend, _aGrupos:={},_cVenGuarda,_lNota := .t.,_lVendedor := .t.,;
               _aPeriodo:={}
       //
       aCampos:={;
 	         {"NOME"      , "C" , 40,0},;
  	         {"ENDERECO"  , "C" , 40,0},;
  	         {"CEP"       , "C" ,  8,0},;
  	         {"MUNICIPIO" , "C" , 15,0},;
  	         {"UF"        , "C" ,  2,0} }
       //
       cArqTmp := CriaTrab(aCampos,.T.)
       dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)
       If aReturn[8] == 1
          IndRegua ( "cArqTmp",cArqTmp,"NOME",,,"Selecionando Registros...")
       Endif
	   //
       // Processa saldos 
       //
       cli002Tmp()
       //
       cabec1  := "Cliente                                   Endereco de Cobranca                      CEP        Municipio        UF "
       cabec2  := "-------------------------------------------------------------------------------------------------------------------"
       //          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99999-999  XXXXXXXXXXXXXXX  XX
       //          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
       //                    1         2         3         4         5         6         7         8         9         10        11
       //
       // Processa o arquivo temporario
       //
       dbSelectArea("cArqTmp")
       DbGoTop()
       ProcRegua(cArqTmp->(RecCount()))
       Do While .t.
          //
          FImpCLI()
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
          cabec(Titulo,"","",nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
          _nLinha:=6
          @ _nLinha, 000 PSAY cabec1
          _nLinha += 1
          @ _nLinha, 000 PSAY __PrtThinLine()
          _nLinha += 1
       Endif
       //
Return 

Static Function FImpCLI()
       //
       If Eof()
          Return
       Endif
       //
       FLin(1)
       @ _nLinha,000 PSAY cArqTmp->NOME
	   @ _nLinha,042 PSAY cArqTmp->ENDERECO
       @ _nLinha,084 PSAY TRANSFORM(cArqTmp->CEP, "@R 999-99999")
       @ _nLinha,095 PSAY cArqTmp->MUNICIPIO
       @ _nLinha,112 PSAY cArqTmp->UF
       //
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³  cli002tmp   ºAutor  ³Alexandre Martim    º Data ³ 23/09/05    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera dados no arquivo temporario                            º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function cli002Tmp()
       //
       Local cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,_nTotRec,cQuery2
       Local cAlias:="SE1",cCampo:="E1", _dMovSaida, _dMovEntrada
       //
       cAliasTmp := "cli002"
       cQuery  := "SELECT Count(*) AS Soma "
       cQuery2 := "FROM "+RetSqlName(cAlias)+ " "+ cAlias 
       cQuery2 += "WHERE "
       cQuery2 += cAlias + "." + cCampo + "_FILIAL = '"+xFilial("SA1")+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par03+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_LOJA BETWEEN '"+mv_par02+"' AND '"+mv_par04+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' AND "
       cQuery2 += cAlias + "." + cCampo + "_BAIXA = '' AND "
       cQuery2 += cAlias + ".D_E_L_E_T_=' '"
       //
       cQuery += cQuery2
       //
       cQuery := ChangeQuery(cQuery)
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       _nTotRec := (cAliasTmp)->SOMA
       dbCloseArea()
       //
       cQuery := "SELECT DISTINCT SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA "
       cQuery += cQuery2                    '
       cQuery += "ORDER BY "+cAlias + "." + cCampo + "_CLIENTE"
       //
       cQuery := ChangeQuery(cQuery)
       //Memowrite("SQL",cQuery)
       //
       dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
       //
//       TcSetField(cAliasTmp,"B2_QATU","N",TamSx3("B2_QATU")[1], TamSx3("B2_QATU")[2] )
//       TcSetField(cAliasTmp,"B2_USAI","D",TamSx3("B2_USAI")[1], TamSx3("B2_USAI")[2] )
       //
       dbSelectArea(cAliasTmp)
       DbGoTop()
       ProcRegua(_nTotRec)
       Do While ( !Eof() ) 
          //
          dbSelectArea("SA1")
          DbSetOrder(1)
          DbSeek(xFilial("SA1")+(cAliasTmp)->&(cCampo+"_CLIENTE")+(cAliasTmp)->&(cCampo+"_LOJA"),.F.)
          //
          dbSelectArea(cAliasTmp)
          If RecLock("cArqTmp",.T.)
             cArqTmp->NOME      := SA1->A1_NOME
             cArqTmp->ENDERECO  := SA1->A1_ENDCOB
             cArqTmp->CEP       := SA1->A1_CEPC
             cArqTmp->MUNICIPIO := SA1->A1_MUNC
             cArqTmp->UF        := SA1->A1_ESTC
             msUnlock()
          Endif
          //
          dbSelectArea(cAliasTmp)
          IncProc("Lendo Titulos...")
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
       AADD(_aRegs,{_cPerg,"01","Cliente de                   ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
       AADD(_aRegs,{_cPerg,"02","Loja de                      ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"03","Cliente Ate                  ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1",""})
       AADD(_aRegs,{_cPerg,"04","Loja Ate                     ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","ZZ","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"05","Emissao de                   ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","",dtoc(dDatabase-30),"","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"06","Emissao Ate                  ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","",dtoc(dDatabase),"","","","","","","","","","","","","","","","","","","","","",""})
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
