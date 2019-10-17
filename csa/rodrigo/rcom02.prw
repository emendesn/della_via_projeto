#include "rwmake.CH"
#define LIM_LINHAS 57

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOM02    ºAutor  ³Alexandre Martim    º Data ³  08/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Recebimentos                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ'ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOM02()
    //
	Private cDesc1 := "Relatorio de Recebimentos de materiais por ordens especificas a selecionar"
	Private cDesc2 := "Observar os parametros do Relatorio"
	Private cDesc3 :=""
	Private cString:="SD1"
	Private limite := 80
	Private nMoeda, cTexto
    //
	Private wnrel
	Private Titulo  := ""
	Private cabec1  := ""
	Private cabec2  := ""
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
    Private aOrd    := {"por Recebimento de Produtos/Vencimento Sintetico",;
                        "por Recebimento de Produtos/Vencimento Analitico",;
                        "por Recebimento de Produtos",;
                        "por Recebimento de Fornecedor/Produto",;
                        "por Recebimento de Produtos/Preco Medio"}
	Private nomeprog:= "RCOM02"
	Private aLinha  := { },nLastKey := 0
	Private cPerg   := "RCOM02"
	Private nColun  := 0  // Controle de colunas (substitui pCol())
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
	wnrel := "RCOM02"
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
	Tamanho := Iif(aReturn[8]==1.or.aReturn[8]==5,"G","M")
	Titulo  := "Relatorio "+aOrd[aReturn[8]]
    //
    Processa( {|| FRCOM02(wnRel) }, "Recebimentos de Materiais, processando..." )
    //
Return



Static Function FRCOM02(wnRel)
       //
       Private cbCont:=0,CbTxt:=Space(10),_lPrimeiraVez:=.t.,_nTotQtd,_aTotVal,_cGuarda,_lItem,;
               _aTotGrupos,_nTotDup,_cAnt,_nGTotQtd,_nGTotDup,_cUnidade:="",_nMTotQtd,_nMTotDup,;
               _cMGuarda,_lMes,_lPriVez:=.t.,_cPGuarda,_nPTotQtd,_nPTotDup,_lFornec,_cFGuarda,;
               _nTotPrc
       //
       aCampos:={;
   	         {"FILIAL"   , "C" , 02,0},;
   	         {"FORNEC"   , "C" , 06,0},;
   	         {"LOJA"     , "C" , 02,0},;
   	         {"NREDUZ"   , "C" , 20,0},;
   	         {"PREFIXO"  , "C" , 04,0},;
   	         {"NUMERO"   , "C" , 06,0},;
   	         {"PARCELA"  , "C" , 05,0},;
  	         {"TIPO"     , "C" , 03,0},;
   	         {"DTEMISSAO", "D" , 08,0},;
   	         {"DTENTREGA", "D" , 08,0},;
  	         {"VENCTO"   , "D" , 08,0},;
  	         {"QUANT"    , "N" , 11,2},;
  	         {"UNIDADE"  , "C" , 02,0},;
  	         {"PRUNIT"   , "N" , 15,4},;
  	         {"PRTOTAL"  , "N" , 15,2},;
  	         {"PRODUTO"  , "C" , 15,0},;
  	         {"GRUPO"    , "C" , 04,0},;
  	         {"DESCGRU"  , "C" , 30,0},;
  	         {"ESTOQUE"  , "N" , 15,2},;
  	         {"TOTQTD"   , "N" , 15,2},;
  	         {"MARCA"    , "C" , 01,0},;
   	         {"DESCRICAO", "C" , 30,0},;
  	         {"T01"      , "N" , 15,2},;
  	         {"T02"      , "N" , 15,2},;
  	         {"T03"      , "N" , 15,2},;
  	         {"T04"      , "N" , 15,2},;
  	         {"T05"      , "N" , 15,2},;
  	         {"T06"      , "N" , 15,2},;
  	         {"T07"      , "N" , 15,2},;
  	         {"T08"      , "N" , 15,2},;
  	         {"T09"      , "N" , 15,2},;
  	         {"T10"      , "N" , 15,2},;
  	         {"T11"      , "N" , 15,2},;
  	         {"T12"      , "N" , 15,2} }
       //
       cArqTmp := CriaTrab(aCampos,.T.)
       dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)
       If aReturn[8] == 1 .or. aReturn[8] == 3 .or. aReturn[8] == 5
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+PRODUTO+DTOS(DTENTREGA)+FORNEC",,,"Selecionando Registros...")
       ElseIf aReturn[8] == 2
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+PRODUTO+Dtos(cArqTmp->VENCTO)+DTOS(DTENTREGA)+FORNEC",,,"Selecionando Registros...")
       ElseIf aReturn[8] == 4
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+FORNEC+PRODUTO+DTOS(DTENTREGA)",,,"Selecionando Registros...")
       Endif
	   //
	   If aReturn[8] <> 5 .and. (mv_par13==4 .or. mv_par13==1)
	      //
          dbSelectArea("SC7")
          dbSeek(mv_par01,.T.)
          ProcRegua(SC7->(RecCount()) - SC7->(Recno()))
          While !Eof() .and. SC7->C7_FILIAL <= mv_par02
             //
             //If !Empty(C7_RESIDUO)
             //   IncProc("Lendo Pedidos de Compra")
             //  dbSkip()
             //   Loop
             //Endif
             //
             If SC7->C7_PRODUTO < mv_par07 .or. SC7->C7_PRODUTO > mv_par08
                IncProc("Lendo Pedidos de Compra")
                dbSkip()
                Loop
             Endif
             //
             If SC7->C7_FORNECE < mv_par09 .or. SC7->C7_FORNECE > mv_par10
                IncProc("Lendo Pedidos de Compra")
                dbSkip()
                Loop
             Endif
             //
             If SC7->C7_DATPRF < mv_par03 .or. SC7->C7_DATPRF > mv_par04
                IncProc("Lendo Pedidos de Compra")
                dbSkip()
                Loop
             Endif
             //
             //
             If SC7->C7_EMISSAO < mv_par05 .or. SC7->C7_EMISSAO > mv_par06
                IncProc("Lendo Pedidos de Compra")
                dbSkip()
                Loop
             Endif
             //
             nValor := C7_PRECO * (C7_QUANT-C7_QUJE) * (1+C7_IPI/100)
             dbSelectArea("SA2")
             dbSeek(xFilial("SA2")+SC7->C7_FORNECE)
             dbSelectArea("SB1")
             dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
             dbSelectArea("SBM")
             dbSeek(xFilial("SBM")+SB1->B1_GRUPO)
             //
             If nValor > 0 
                dDataIni := SC7->C7_DATPRF
                aVenc := Condicao ( nValor,SC7->C7_COND,0,dDataIni)
                nValor := nValor / len(aVenc)
                For nX := 1 to Len(aVenc)
                    dbSelectArea("cArqTmp")
                    RecLock("cArqTmp",.T.)
                    cArqTmp->FILIAL    := SC7->C7_FILIAL
                    cArqTmp->FORNEC    := SC7->C7_FORNECE
                    cArqTmp->TIPO      := "PC"
                    cArqTmp->PARCELA   := Alltrim(Str(nX,2))+"/"+Alltrim(Str(Len(aVenc),2))
                    cArqTmp->LOJA      := SC7->C7_LOJA
                    cArqTmp->NREDUZ    := SA2->A2_NREDUZ
                    cArqTmp->DTEMISSAO := SC7->C7_DATPRF
                    cArqTmp->DTENTREGA := SC7->C7_DATPRF
                    cArqTmp->NUMERO    := SC7->C7_NUM
                    cArqTmp->PREFIXO   := SC7->C7_ITEM
                    cArqTmp->VENCTO    := aVenc[nX][1]
                    cArqTmp->DESCRICAO := SB1->B1_DESC
                    If nX == 1
                       cArqTmp->QUANT  := (SC7->C7_QUANT-SC7->C7_QUJE)
                    Endif
                    cArqTmp->UNIDADE   := SC7->C7_UM
                    cArqTmp->PRUNIT    := SC7->C7_PRECO
                    cArqTmp->PRTOTAL   := nValor
                    cArqTmp->PRODUTO   := SC7->C7_PRODUTO
                    cArqTmp->ESTOQUE   := SaldoSB2()
                    cArqTmp->GRUPO     := SB1->B1_GRUPO
                    cArqTmp->DESCGRU   := SBM->BM_DESC
                    msUnlock()
    			Next
    		 Endif
             dbSelectArea("SC7")
             IncProc("Lendo Pedidos de Compra")
             dbSkip()
          Enddo
       Endif
       //
       // Processa Notas de Entrada
       //
       If (mv_par13==4 .or. mv_par13==2)
          RCOM02Tmp()
       Endif
       //
       // Processa devolucoes 
       //
       If mv_par11 == 1 .and. aReturn[8] <> 5 .and. (mv_par13==4 .or. mv_par13==3)
          RCOM02Dev()
       Endif
       //
       // Fazer Totalizacoes por quebra escolhida
       //
       If aReturn[8] == 1
          FTrtOrd1()
       Elseif aReturn[8] == 2
          FTrtOrd2()
       Elseif aReturn[8] == 3
          FTrtOrd3()
       Elseif aReturn[8] == 4
          FTrtOrd4()
       Elseif aReturn[8] == 5
          FTrtOrd5()
       Endif
       //
       // Processa o arquivo temporario
       //
       dbSelectArea("cArqTmp")
       DbGoTop()
       ProcRegua(cArqTmp->(RecCount()))
       Do While .t.
          //
          If aReturn[8] == 1
             FImpOrd1()
          Elseif aReturn[8] == 2
             FImpOrd2()
          Elseif aReturn[8] == 3
             FImpOrd3()
          Elseif aReturn[8] == 4
             FImpOrd4()
          Elseif aReturn[8] == 5
             FImpOrd5()
          Endif
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
       If aReturn[8] == 1
          FimOrd1()
       Elseif aReturn[8] == 2
          FimOrd2()
       Elseif aReturn[8] == 3
          FimOrd3()
       Elseif aReturn[8] == 4
          FimOrd4()
       Elseif aReturn[8] == 5
          FimOrd5()
       Endif
       //
       roda(cbcont,cbtxt,"G")
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
       dbSelectArea("SD1")
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
          If aReturn[8] == 1 .and. !_lPriVez
             @ LIM_LINHAS+1, 000 PSAY __PrtThinLine()
             @ LIM_LINHAS+2, 000 PSAY cabec1
             @ LIM_LINHAS+3, 000 PSAY __PrtThinLine()
          Endif
          cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
          _nLinha:=8
          _lPriVez:=.f.
       Endif
       //
Return 

Static Function FApaga()
       dbSelectArea("cArqTmp")
       DbGoTop()
       ProcRegua(cArqTmp->(RecCount()))
       Do while !Eof()
          If cArqTmp->MARCA == "*"
             RecLock("cArqTmp",.F.)
             dbDelete()
             msUnlock()
          Endif
          IncProc("Apagando registros Marcados")
          DbSkip()
       Enddo
       DbGoTop()
Return
//
//
//
//     Tratamento para a Primeira Ordem Escolhida (1)
//
//
//
Static Function FTrtOrd1()
      //
      cabec1  := "Recebimento      Quantidade  UM           JAN           FEV           MAR           ABR           MAI           JUN           JUL           AGO           SET           OUT           NOV           DEZ         Total"
      cabec2  := ""
	  //             
      _nTotQtd := 0.00
      _aTotVal := {0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00}
      _aTotGrupos := {}
      dbSelectArea("cArqTmp")
      DbGoTop()
      ProcRegua(cArqTmp->(RecCount()))
      _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->DTENTREGA),2)
      Do while !Eof()
         _nTotQtd += cArqTmp->QUANT
         If !Empty(cArqTmp->VENCTO)
            _aTotVal[Month(cArqTmp->VENCTO)] += cArqTmp->PRTOTAL
         Endif
         _nPos := Ascan(_aTotGrupos, { |x| x[1]+x[2]==Iif(Empty(cArqTmp->GRUPO),"9999",cArqTmp->GRUPO)+StrZero(Month(cArqTmp->VENCTO),2) })
         If _nPos > 0
            _aTotGrupos[_nPos, 5] += cArqTmp->PRTOTAL
            _aTotGrupos[_nPos, Month(cArqTmp->VENCTO)+5] += cArqTmp->PRTOTAL
         Else
            Aadd(_aTotGrupos, {Iif(Empty(cArqTmp->GRUPO),"9999",cArqTmp->GRUPO), StrZero(Month(cArqTmp->VENCTO),2), Padr(MesExtenso(cArqTmp->VENCTO),10)+StrZero(Year(cArqTmp->VENCTO),4),;
                 Iif(Empty(cArqTmp->GRUPO),"Outros",cArqTmp->DESCGRU), cArqTmp->PRTOTAL, 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00})
         Endif
         RecLock("cArqTmp",.F.)
         cArqTmp->MARCA := "*"
         msUnlock()
         IncProc("Totalizando registros pela Chave")
         DbSkip()
         If _cGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->DTENTREGA),2)
            DbSkip(-1)
            RecLock("cArqTmp",.F.)
            cArqTmp->MARCA := " "
            cArqTmp->QUANT := _nTotQtd
            For _n:=1 to 12
                &("cArqTmp->T"+StrZero(_n,2)) := _aTotVal[_n]
            Next
            msUnlock()
            DbSkip()
            _nTotQtd := 0.00
            _aTotVal := {0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00}
            _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->DTENTREGA),2)
         Endif
      Enddo
      //
      FApaga()
      //
      _cGuarda  := "@#$%¨&*()"
      _cfGuarda := "@#"
      _lItem:=.t.
      //
Return

Static Function FImpOrd1()
       //
       Local _nTotLin:=0.00
       //
       If _cGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO
          If !_lPrimeiraVez
               FLin(1)
		       @ _nLinha, 000 PSAY "TOTAL DO ITEM"
               _nTotLin:=0.00
		       For _n:=1 to 12
		          @ _nLinha, 019+(_n*14) PSAY Transform(_aTotVal[_n], "@E 99,999,999.99")
                  _nTotLin+=_aTotVal[_n]
		       Next
               @ _nLinha, 019+(_n*14) PSAY Transform(_nTotLin, "@E 99,999,999.99")
               FLin(2)
          Endif
	      _aTotVal := {0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00}
          _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO
          _lItem:=.t.
       Endif
       //
       If Eof()
          Return
       Endif
       //
       If Left(_cFGuarda,2) <> cArqTmp->FILIAL
          If !_lPrimeiraVez
             _nLinha := LIM_LINHAS
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Else
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Endif
          _cFGuarda := cArqTmp->FILIAL
          _lPrimeiraVez:=.f.
       Endif
       //
       If _lItem
          FLin(1)
          @ _nLinha, 000 PSAY "Item : "+AllTrim(cArqTmp->PRODUTO)+" - "+cArqTmp->DESCRICAO
          _lItem:=.f.
       Endif
       //
       // Recebimento      Quantidade  UM           JAN           FEV           MAR           ABR           MAI           JUN           JUL           AGO           SET           OUT           NOV           DEZ"
       // XXXXXXXXXXXXXX 99999999.99   XX  9,999.999,99  9,999.999,99
       // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	   //           1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19
       //
       FLin(1)
       @ _nLinha, 000 PSAY MesExtenso(cArqTmp->DTENTREGA)
       @ _nLinha, 010 PSAY StrZero(Year(cArqTmp->DTENTREGA),4)
       @ _nLinha, 015 PSAY Transform(cArqTmp->QUANT, "@E 9,999,999")
       @ _nLinha, 029 PSAY cArqTmp->UNIDADE
       _nTotLin:=0.00
       For _n:=1 to 12
          @ _nLinha, 019+(_n*14) PSAY Transform(&("cArqTmp->T"+StrZero(_n,2)), "@E 99,999,999.99")
          _nTotLin+=&("cArqTmp->T"+StrZero(_n,2))
       Next
       @ _nLinha, 019+(_n*14) PSAY Transform(_nTotLin, "@E 99,999,999.99")
       For _n:=1 to 12
           _aTotVal[_n] += &("cArqTmp->T"+StrZero(_n,2))
       Next
       //
Return

Static Function FimOrd1()
       //
       Local _nTotVlrGru:=0.00, _nTotVlr:=0.00
       //
       _nLinha:=100
       _cGuarda := "@#$%¨&*()"
       _lPrimeiraVez:=.t.
       _lItem:=.t.
       _nl := 1
       aSort(_aTotGrupos,,,{|x,y| x[1]+x[2]<y[1]+y[2]})
       FLin(1)
       //
       Do While Len(_aTotGrupos) > 0
           //
	       If _cGuarda <> If(_nl<=Len(_aTotGrupos),_aTotGrupos[_nl, 1],"!!!!!!!!!!!")
	          If !_lPrimeiraVez
	               FLin(1)
			       @ _nLinha, 000 PSAY "TOTAL DO GRUPO"
         	       @ _nLinha, 015 PSAY Transform(_nTotVlrGru, "@E 99,999,999.99")
			       For _y:=1 to 12
			          @ _nLinha, 019+(_y*14) PSAY Transform(_aTotVal[_y], "@E 99,999,999.99")
			       Next
	               FLin(2)
	          Endif
		      _aTotVal := {0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00}
	          _cGuarda := If(_nl<=Len(_aTotGrupos),_aTotGrupos[_nl, 1],"!!!!!!!!!!!")
	          _lPrimeiraVez:=.f.
	          _nTotVlrGru:=0.00
	          _lItem:=.t.
	       Endif
	       //
	       If _nl > Len(_aTotGrupos)
	          Exit
	       Endif
	       //
	       If _lItem
	          FLin(1)
	          @ _nLinha, 000 PSAY "Grupo : "+_aTotGrupos[_nl, 1]+" - "+_aTotGrupos[_nl, 4]
	          _lItem:=.f.
	       Endif
	       //
	       FLin(1)
	       @ _nLinha, 000 PSAY _aTotGrupos[_nl, 3]
	       @ _nLinha, 015 PSAY Transform(_aTotGrupos[_nl, 5], "@E 99,999,999.99")
	       For _y:=1 to 12
	          @ _nLinha, 019+(_y*14) PSAY Transform(_aTotGrupos[_nl, _y+5], "@E 99,999,999.99")
	       Next
	       For _y:=1 to 12
	           _aTotVal[_y] += _aTotGrupos[_nl, _y+5]
	       Next
           _nTotVlrGru+=_aTotGrupos[_nl, 5]
           _nTotVlr+=_aTotGrupos[_nl, 5]
	       //
	       _nl += 1
	       //
       Enddo
       //
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       @ _nLinha, 000 PSAY "TOTAL GERAL DO RELATORIO"
       @ _nLinha, 015 PSAY Transform(_nTotVlr, "@E 99,999,999.99")
       @ _nLinha, 015 PSAY Transform((_nT:=0,aEval(_aTotGrupos, {|x| _nT+=x[5]}),_nT), "@E 99,999,999.99")
       For _y:=1 to 12
           @ _nLinha, 019+(_y*14) PSAY Transform((_nT:=0,aEval(_aTotGrupos, {|x| _nT+=x[_y+5]}),_nT), "@E 99,999,999.99")
       Next
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       //
Return
//
//
//
//     Tratamento para a segunda Ordem Escolhida (2)
//
//
//
Static Function FTrtOrd2()
      //
      cabec1  := "Fornec Abreviado            Or    Dt Receb   Par    Vencto   CP Docto  Item       Qtde  Un     P.Unit     Vr.Duplic "
      cabec2  := ""
	  //             
      _nTotQtd := 0.00
      _nTotDup := 0.00
      dbSelectArea("cArqTmp")
      DbGoTop()
      ProcRegua(cArqTmp->(RecCount()))
      _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->VENCTO),2)+DTOS(DTENTREGA)+cArqTmp->FORNEC
      Do while !Eof()
         _nTotQtd += cArqTmp->QUANT
         _nTotDup += cArqTmp->PRTOTAL
         RecLock("cArqTmp",.F.)
         cArqTmp->MARCA := "*"
         msUnlock()
         IncProc("Totalizando registros pela Chave")
         DbSkip()
         If _cGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->VENCTO),2)+DTOS(DTENTREGA)+cArqTmp->FORNEC
            DbSkip(-1)
            RecLock("cArqTmp",.F.)
            cArqTmp->MARCA   := " "
            cArqTmp->QUANT   := _nTotQtd
            cArqTmp->PRTOTAL := _nTotDup
            msUnlock()
            DbSkip()
            _nTotQtd := 0.00
            _nTotDup := 0.00
            _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->VENCTO),2)+DTOS(DTENTREGA)+cArqTmp->FORNEC
         Endif
      Enddo
      //
      FApaga()
      //
      _cGuarda :="@#$%¨&*()"
      _cMGuarda:="@#$%¨&*()"
      _cFGuarda:="@#"
      _lItem:=.t.
      _lMes:=.t.
      _cAnt:=_cGuarda
      _nGTotQtd := 0.00
      _nGTotDup := 0.00
      //
Return

Static Function FImpOrd2()
       //
       Local _lImp
       //
       If _cMGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->VENCTO),2)
          If !_lPrimeiraVez
               FLin(1)
		       @ _nLinha, 000 PSAY "TOTAL DO MES"
               @ _nLinha, 074 PSAY Transform(_nMTotQtd, "@E 99,999,999.99")
               @ _nLinha, 088 PSAY _cUnidade
               @ _nLinha, 103 PSAY Transform(_nMTotDup, "@E 99,999,999.99")
               FLin(1)
          Endif
	      _nMTotQtd := 0.00
	      _nMTotDup := 0.00
          _cMGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->VENCTO),2)
          _lMes     := .t.
       Endif
       //
       If _cGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO
          If !_lPrimeiraVez
               FLin(1)
		       @ _nLinha, 000 PSAY "TOTAL DO PRODUTO"
               @ _nLinha, 074 PSAY Transform(_nTotQtd, "@E 99,999,999.99")
               @ _nLinha, 088 PSAY _cUnidade
               @ _nLinha, 103 PSAY Transform(_nTotDup, "@E 99,999,999.99")
               FLin(1)
               @ _nLinha, 000 PSAY __PrtThinLine()
          Endif
	      _nTotQtd  := 0.00
	      _nTotDup  := 0.00
          _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO
          _lItem:=.t.
       Endif
       //
       If Eof()
          Return
       Endif
       //
       If Left(_cFGuarda,2) <> cArqTmp->FILIAL
          If !_lPrimeiraVez
             _nLinha := LIM_LINHAS
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Else
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Endif
          _cFGuarda := cArqTmp->FILIAL
          _lPrimeiraVez:=.f.
       Endif
       //
       If _lItem
          FLin(1)
          @ _nLinha, 000 PSAY AllTrim(cArqTmp->PRODUTO)+" - "+cArqTmp->DESCRICAO
          FLin(1)
          _lItem:=.f.
       Endif
       //
       If _lMes
          FLin(1)
          @ _nLinha, 000 PSAY "Compras com vencimento para: "+MesExtenso(cArqTmp->VENCTO)+"/"+StrZero(Year(cArqTmp->VENCTO),4)
          _lMes:=.f.
       Endif
       //
       If _cAnt <> cArqTmp->FORNEC+cArqTmp->PRODUTO+cArqTmp->NUMERO+cArqTmp->PREFIXO
         _lImp:=.t.
       Else
         _lImp:=.f.
       Endif
       _cAnt := cArqTmp->FORNEC+cArqTmp->PRODUTO+cArqTmp->NUMERO+cArqTmp->PREFIXO
       //
       // Fornec Abreviado            Or    Dt Receb   Par    Vencto   CP Docto  Item       Qtde  Un     P.Unit     Vr.Duplic 
       // 999999 xxxxxxxxxxxxxxxxxxxx xxxx  99/99/99  xxxxx  99/99/99 999 xxxxxx  999  999,999,99 xx  9999,9999  99.999.999,99
       // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
	   //           1         2         3         4         5         6         7         8         9         10        11        12  
       //
       FLin(1)
       @ _nLinha, 000 PSAY cArqTmp->FORNEC
       @ _nLinha, 007 PSAY cArqTmp->NREDUZ
       @ _nLinha, 028 PSAY cArqTmp->TIPO
       @ _nLinha, 034 PSAY Dtoc(cArqTmp->DTENTREGA)
       @ _nLinha, 044 PSAY cArqTmp->PARCELA
       @ _nLinha, 051 PSAY Dtoc(cArqTmp->VENCTO)
       @ _nLinha, 060 PSAY Str((cArqTmp->VENCTO - cArqTmp->DTEMISSAO),3,0)
       @ _nLinha, 064 PSAY cArqTmp->NUMERO
       @ _nLinha, 072 PSAY Right(cArqTmp->PREFIXO,3)
       @ _nLinha, 076 PSAY Iif(_lImp,Transform(cArqTmp->QUANT  , "@E 9999,999.99"),"       ....")
       @ _nLinha, 088 PSAY Iif(_lImp,cArqTmp->UNIDADE,"..")
       @ _nLinha, 092 PSAY Transform(cArqTmp->PRUNIT , "@E 9999.9999")
       @ _nLinha, 103 PSAY Transform(cArqTmp->PRTOTAL, "@E 99,999,999.99")
       //
       _nTotQtd  += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nTotDup  += cArqTmp->PRTOTAL
       _nMTotQtd += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nMTotDup += cArqTmp->PRTOTAL
       _nGTotQtd += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nGTotDup += cArqTmp->PRTOTAL
       _cUnidade := cArqTmp->UNIDADE
       //
Return

Static Function FimOrd2()
       //
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       @ _nLinha, 000 PSAY "TOTAL GERAL DO RELATORIO"
       @ _nLinha, 074 PSAY Transform(_nGTotQtd, "@E 99,999,999.99")
       @ _nLinha, 103 PSAY Transform(_nGTotDup, "@E 99,999,999.99")
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       //
Return
//
//
//
//     Tratamento para a segunda Ordem Escolhida (3)
//
//
//
Static Function FTrtOrd3()
      //
      cabec1  := "Fornec Abreviado            Or    Dt Receb   Par    Vencto   CP Docto  Item       Qtde  Un     P.Unit     Vr.Duplic "
      cabec2  := ""
	  //             
      _nTotQtd := 0.00
      _nTotDup := 0.00
      dbSelectArea("cArqTmp")
      DbGoTop()
      ProcRegua(cArqTmp->(RecCount()))
      _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+Dtos(cArqTmp->DTENTREGA)+Dtos(cArqTmp->VENCTO)+cArqTmp->FORNEC
      Do while !Eof()
         _nTotQtd += cArqTmp->QUANT
         _nTotDup += cArqTmp->PRTOTAL
         RecLock("cArqTmp",.F.)
         cArqTmp->MARCA := "*"
         msUnlock()
         IncProc("Totalizando registros pela Chave")
         DbSkip()
         If _cGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO+Dtos(cArqTmp->DTENTREGA)+Dtos(cArqTmp->VENCTO)+cArqTmp->FORNEC
            DbSkip(-1)
            RecLock("cArqTmp",.F.)
            cArqTmp->MARCA   := " "
            cArqTmp->QUANT   := _nTotQtd
            cArqTmp->PRTOTAL := _nTotDup
            msUnlock()
            DbSkip()
            _nTotQtd := 0.00
            _nTotDup := 0.00
            _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+Dtos(cArqTmp->DTENTREGA)+Dtos(cArqTmp->VENCTO)+cArqTmp->FORNEC
         Endif
      Enddo
      //
      FApaga()
      //
      _cGuarda:="@#$%¨&*()"
      _cFGuarda:="@#"
      _lItem:=.t.
      _cAnt:=_cGuarda
      _nGTotQtd := 0.00
      _nGTotDup := 0.00
      //
Return

Static Function FImpOrd3()
       //
       Local _lImp
       //
       If _cGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO
          If !_lPrimeiraVez
               FLin(1)
		       @ _nLinha, 000 PSAY "TOTAL DO PRODUTO"
               @ _nLinha, 074 PSAY Transform(_nTotQtd, "@E 99,999,999.99")
               @ _nLinha, 088 PSAY _cUnidade
               @ _nLinha, 103 PSAY Transform(_nTotDup, "@E 99,999,999.99")
               FLin(1)
               @ _nLinha, 000 PSAY __PrtThinLine()
          Endif
	      _nTotQtd  := 0.00
	      _nTotDup  := 0.00
          _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO
          _lItem:=.t.
       Endif
       //
       If Eof()
          Return
       Endif
       //
       If Left(_cFGuarda,2) <> cArqTmp->FILIAL
          If !_lPrimeiraVez
             _nLinha := LIM_LINHAS
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Else
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Endif
          _cFGuarda := cArqTmp->FILIAL
          _lPrimeiraVez:=.f.
       Endif
       //
       If _lItem
          FLin(1)
          @ _nLinha, 000 PSAY AllTrim(cArqTmp->PRODUTO)+" - "+cArqTmp->DESCRICAO
          _lItem:=.f.
       Endif
       //
       If _cAnt <> cArqTmp->FORNEC+cArqTmp->PRODUTO+cArqTmp->NUMERO+cArqTmp->PREFIXO
         _lImp:=.t.
       Else
         _lImp:=.f.
       Endif
       _cAnt := cArqTmp->FORNEC+cArqTmp->PRODUTO+cArqTmp->NUMERO+cArqTmp->PREFIXO
       //
       // Fornec Abreviado            Or    Dt Receb   Par    Vencto   CP Docto  Item       Qtde  Un     P.Unit     Vr.Duplic 
       // 999999 xxxxxxxxxxxxxxxxxxxx xxxx  99/99/99  xxxxx  99/99/99 999 xxxxxx  999 99999999,99 xx  9999,9999  99.999.999,99
       // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
	   //           1         2         3         4         5         6         7         8         9         10        11        12  
       //
       FLin(1)
       @ _nLinha, 000 PSAY cArqTmp->FORNEC
       @ _nLinha, 007 PSAY cArqTmp->NREDUZ
       @ _nLinha, 028 PSAY cArqTmp->TIPO
       @ _nLinha, 034 PSAY Dtoc(cArqTmp->DTENTREGA)
       @ _nLinha, 044 PSAY cArqTmp->PARCELA
       @ _nLinha, 051 PSAY Dtoc(cArqTmp->VENCTO)
       @ _nLinha, 060 PSAY Str((cArqTmp->VENCTO - cArqTmp->DTEMISSAO),3,0)
       @ _nLinha, 064 PSAY cArqTmp->NUMERO
       @ _nLinha, 072 PSAY Right(cArqTmp->PREFIXO,3)
       @ _nLinha, 076 PSAY Iif(_lImp,Transform(cArqTmp->QUANT  , "@E 9999,999.99"),"       ....")
       @ _nLinha, 088 PSAY Iif(_lImp,cArqTmp->UNIDADE,"..")
       @ _nLinha, 092 PSAY Transform(cArqTmp->PRUNIT , "@E 9999.9999")
       @ _nLinha, 103 PSAY Transform(cArqTmp->PRTOTAL, "@E 99,999,999.99")
       //
       _nTotQtd  += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nTotDup  += cArqTmp->PRTOTAL
       _nGTotQtd += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nGTotDup += cArqTmp->PRTOTAL
       _cUnidade := cArqTmp->UNIDADE
       //
Return

Static Function FimOrd3()
       //
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       @ _nLinha, 000 PSAY "TOTAL GERAL DO RELATORIO"
       @ _nLinha, 074 PSAY Transform(_nGTotQtd, "@E 99,999,999.99")
       @ _nLinha, 103 PSAY Transform(_nGTotDup, "@E 99,999,999.99")
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       //
Return
//
//
//
//     Tratamento para a segunda Ordem Escolhida (4)
//
//
//
Static Function FTrtOrd4()
      //
      cabec1  := "Fornec Abreviado            Or    Dt Receb   Par    Vencto   CP Docto  Item       Qtde  Un     P.Unit     Vr.Duplic "
      cabec2  := ""
	  //             
      _nTotQtd := 0.00
      _nTotDup := 0.00
      dbSelectArea("cArqTmp")
      DbGoTop()
      ProcRegua(cArqTmp->(RecCount()))
      _cGuarda := cArqTmp->FILIAL+cArqTmp->FORNEC+cArqTmp->PRODUTO+DTOS(DTENTREGA)+Dtos(cArqTmp->VENCTO)
      Do while !Eof()
         _nTotQtd += cArqTmp->QUANT
         _nTotDup += cArqTmp->PRTOTAL
         RecLock("cArqTmp",.F.)
         cArqTmp->MARCA := "*"
         msUnlock()
         IncProc("Totalizando registros pela Chave")
         DbSkip()
         If _cGuarda <> cArqTmp->FILIAL+cArqTmp->FORNEC+cArqTmp->PRODUTO+DTOS(DTENTREGA)+Dtos(cArqTmp->VENCTO)
            DbSkip(-1)
            RecLock("cArqTmp",.F.)
            cArqTmp->MARCA   := " "
            cArqTmp->QUANT   := _nTotQtd
            cArqTmp->PRTOTAL := _nTotDup
            msUnlock()
            DbSkip()
            _nTotQtd := 0.00
            _nTotDup := 0.00
            _cGuarda := cArqTmp->FILIAL+cArqTmp->FORNEC+cArqTmp->PRODUTO+DTOS(DTENTREGA)+Dtos(cArqTmp->VENCTO)
         Endif
      Enddo
      //
      FApaga()
      //
      _cGuarda :="@#$%¨&*()"
      _cPGuarda:="@#$%¨&*()"
      _cFGuarda:="@#"
      _lItem:=.t.
      _lFornec:=.t.
      _cAnt:=_cGuarda
      _nGTotQtd := 0.00
      _nGTotDup := 0.00
      //
Return

Static Function FImpOrd4()
       //
       Local _lImp
       //
       If _cPGuarda <> cArqTmp->FILIAL+cArqTmp->FORNEC+cArqTmp->PRODUTO
          If !_lPrimeiraVez
               FLin(1)
		       @ _nLinha, 000 PSAY "TOTAL DO PRODUTO"
               @ _nLinha, 074 PSAY Transform(_nPTotQtd, "@E 99,999,999.99")
               @ _nLinha, 088 PSAY _cUnidade
    	       If mv_par12==1
                  @ _nLinha, 103 PSAY Transform(_nPTotDup, "@E 99,999,999.99")
               Endif
               FLin(1)
               @ _nLinha, 000 PSAY __PrtThinLine()
          Endif
	      _nPTotQtd := 0.00
	      _nPTotDup := 0.00
          _cPGuarda := cArqTmp->FILIAL+cArqTmp->FORNEC+cArqTmp->PRODUTO
          _lItem:=.t.
       Endif
       //
       If _cGuarda <> cArqTmp->FILIAL+cArqTmp->FORNEC
          If !_lPrimeiraVez
               FLin(1)
		       @ _nLinha, 000 PSAY "TOTAL DO FORNECEDOR"
               @ _nLinha, 074 PSAY Transform(_nTotQtd, "@E 99,999,999.99")
               @ _nLinha, 088 PSAY _cUnidade
    	       If mv_par12==1
                  @ _nLinha, 103 PSAY Transform(_nTotDup, "@E 99,999,999.99")
               Endif
               FLin(1)
               @ _nLinha, 000 PSAY __PrtThinLine()
               FLin(1)
          Endif
	      _nTotQtd  := 0.00
	      _nTotDup  := 0.00
          _cGuarda := cArqTmp->FILIAL+cArqTmp->FORNEC
          _lFornec  := .t.
       Endif
       //
       If Eof()
          Return
       Endif
       //
       If Left(_cFGuarda,2) <> cArqTmp->FILIAL
          If !_lPrimeiraVez
             _nLinha := LIM_LINHAS
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Else
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Endif
          _cFGuarda := cArqTmp->FILIAL
          _lPrimeiraVez:=.f.
       Endif
       //
       If _lFornec
          FLin(1)
          @ _nLinha, 000 PSAY "Fornecedor: "+AllTrim(cArqTmp->FORNEC)+" - "+cArqTmp->NREDUZ
          _lFornec:=.f.
       Endif
       //
       If _lItem
          FLin(1)
          @ _nLinha, 000 PSAY AllTrim(cArqTmp->PRODUTO)+" - "+cArqTmp->DESCRICAO
          FLin(1)
          _lItem:=.f.
       Endif
       //
       If _cAnt <> cArqTmp->FORNEC+cArqTmp->PRODUTO+cArqTmp->NUMERO+cArqTmp->PREFIXO
         _lImp:=.t.
       Else
         _lImp:=.f.
       Endif
       _cAnt := cArqTmp->FORNEC+cArqTmp->PRODUTO+cArqTmp->NUMERO+cArqTmp->PREFIXO
       //
       // Fornec Abreviado            Or    Dt Receb   Par    Vencto   CP Docto  Item       Qtde  Un     P.Unit     Vr.Duplic 
       // 999999 xxxxxxxxxxxxxxxxxxxx xxxx  99/99/99  xxxxx  99/99/99 999 xxxxxx  999 99999999,99 xx  9999,9999  99.999.999,99
       // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
	   //           1         2         3         4         5         6         7         8         9         10        11        12  
       //
       If !(mv_par12=2 .and. !_lImp)
           FLin(1)
	       @ _nLinha, 000 PSAY cArqTmp->FORNEC
	       @ _nLinha, 007 PSAY cArqTmp->NREDUZ
    	   @ _nLinha, 028 PSAY cArqTmp->TIPO
	       @ _nLinha, 034 PSAY Dtoc(cArqTmp->DTENTREGA)
    	   @ _nLinha, 044 PSAY cArqTmp->PARCELA
	       @ _nLinha, 051 PSAY Dtoc(cArqTmp->VENCTO)
	       @ _nLinha, 060 PSAY Str((cArqTmp->VENCTO - cArqTmp->DTEMISSAO),3,0)
	       @ _nLinha, 064 PSAY cArqTmp->NUMERO
	       @ _nLinha, 072 PSAY Right(cArqTmp->PREFIXO,3)
	       @ _nLinha, 076 PSAY Iif(_lImp,Transform(cArqTmp->QUANT  , "@E 9999,999.99"),"       ....")
	       @ _nLinha, 088 PSAY Iif(_lImp,cArqTmp->UNIDADE,"..")
	       @ _nLinha, 092 PSAY Transform(cArqTmp->PRUNIT , "@E 9999.9999")
	       If mv_par12==1
    	       @ _nLinha, 103 PSAY Transform(cArqTmp->PRTOTAL, "@E 99,999,999.99")
    	   Endif
	   Endif
       //
       _nTotQtd  += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nTotDup  += cArqTmp->PRTOTAL
       _nPTotQtd += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nPTotDup += cArqTmp->PRTOTAL
       _nGTotQtd += Iif(_lImp,cArqTmp->QUANT,0.00)
       _nGTotDup += cArqTmp->PRTOTAL
       _cUnidade := cArqTmp->UNIDADE
       //
Return

Static Function FimOrd4()
       //
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       @ _nLinha, 000 PSAY "TOTAL GERAL DO RELATORIO"
       @ _nLinha, 074 PSAY Transform(_nGTotQtd, "@E 99,999,999.99")
       If mv_par12==1
          @ _nLinha, 103 PSAY Transform(_nGTotDup, "@E 99,999,999.99")
       Endif
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       //
Return
//
//
//     Tratamento para a Primeira Ordem Escolhida (5)
//
//
//
Static Function FTrtOrd5()
      //
      cabec1  := "Produto         Descricao                      UM           JAN           FEV           MAR           ABR           MAI           JUN           JUL           AGO           SET           OUT           NOV           DEZ"
      cabec2  := ""
	  //             
      _nTotQtd := 0.00
      _nTotPrc := 0.00
      _aTotVal := {0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00}
      dbSelectArea("cArqTmp")
      DbGoTop()
      ProcRegua(cArqTmp->(RecCount()))
      _cGuarda  := cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->DTENTREGA),2)
      _cPGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO
      Do while !Eof()
         _nTotQtd += cArqTmp->QUANT
         _nTotPrc += cArqTmp->QUANT*cArqTmp->PRUNIT
         RecLock("cArqTmp",.F.)
         cArqTmp->MARCA := "*"
         msUnlock()
         IncProc("Totalizando registros pela Chave")
         DbSkip()
         If _cGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->DTENTREGA),2)
            If _cPGuarda <> cArqTmp->FILIAL+cArqTmp->PRODUTO
               DbSkip(-1)
               RecLock("cArqTmp",.F.)
               cArqTmp->MARCA := " "
               cArqTmp->QUANT += _nTotQtd
               For _n:=1 to 12
                   &("cArqTmp->T"+StrZero(_n,2)) := _aTotVal[_n]
               Next
               msUnlock()
               DbSkip()
               _cPGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO
               _aTotVal := {0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00}
            Endif
            If Eof()
               exit
            Endif
            _aTotVal[Month(cArqTmp->DTENTREGA)] := _nTotPrc/_nTotQtd
            _nTotQtd := 0.00
            _nTotPrc := 0.00
            _cGuarda := cArqTmp->FILIAL+cArqTmp->PRODUTO+StrZero(Month(cArqTmp->DTENTREGA),2)
         Endif
      Enddo
      //
      FApaga()
      //
      _cGuarda  := "@#$%¨&*()"
      _cfGuarda := "@#"
      _lItem:=.t.
      //
Return

Static Function FImpOrd5()
       //
       Local _nTotLin:=0.00
       //
       If Eof()
          Return
       Endif
       //
       If Left(_cFGuarda,2) <> cArqTmp->FILIAL
          If !_lPrimeiraVez
             _nLinha := LIM_LINHAS
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Else
             FLin(1)
             @ _nLinha, 000 PSAY "Filial: "+cArqTmp->FILIAL
          Endif
          _cFGuarda := cArqTmp->FILIAL
          _lPrimeiraVez:=.f.
       Endif
       //
       // Produto         Descricao                      UM           JAN           FEV           MAR           ABR           MAI           JUN           JUL           AGO           SET           OUT           NOV           DEZ"
       // XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX  9,999.999,99  9,999.999,99
       // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	   //           1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19
       //
       FLin(1)
       @ _nLinha, 000 PSAY AllTrim(cArqTmp->PRODUTO)
       @ _nLinha, 016 PSAY Left(cArqTmp->DESCRICAO,30)
       @ _nLinha, 047 PSAY cArqTmp->UNIDADE
       For _n:=1 to 12
          @ _nLinha, 037+(_n*14) PSAY Transform(&("cArqTmp->T"+StrZero(_n,2)), "@E 99,999,999.99")
       Next
       //
Return

Static Function FimOrd5()
       //
       //
Return
//
//

//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RCOM02Tmp  ºAutor  ³Alexandre Martim    º Data ³  09/04/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera dados no arquivo temporario                            º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOM02                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION RCOM02Tmp()
       //
       LOCAL cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,cAlias:="SD1",cCampo:="D1",nOrdem:=2,_nTotRec,;
             cQuery2
       //
#IFDEF TOP
	IF TcSrvType() != "AS/400"
	    //
		cAliasTmp := "RCOM02"
		cQuery  := "SELECT Count(*) AS Soma "
		cQuery2 := "FROM "+RetSqlName(cAlias)+ " "+ cAlias + " "
		cQuery2 += "WHERE "
		cQuery2 += cAlias + "." + cCampo + "_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
		cQuery2 += cAlias + "." + cCampo + "_DTDIGIT BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' AND "
		cQuery2 += cAlias + "." + cCampo + "_FORNECE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' AND "
		cQuery2 += cAlias + "." + cCampo + "_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
		cQuery2 += cAlias + ".D_E_L_E_T_=' ' "
		cQuery  += cQuery2
        //
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
        _nTotRec := (cAliasTmp)->SOMA
        dbCloseArea()
	    //
		aStru  := (cAlias)->(dbStruct())
		cAliasTmp := "RCOM02"
		cQuery := ""
		aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery +=         ",R_E_C_N_O_ RECNO "
		cQuery += cQuery2
        //
		cQuery := ChangeQuery(cQuery)
		Memowrite("SQL",cQuery)
		//
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
		//
		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(cAliasTmp,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
		//
	Else
#ENDIF
		dbSelectArea(cAlias)
		dbSetOrder(nOrdem)
		cIndTmp := CriaTrab(,.F.)
		IndRegua(cAlias,cIndTmp,IndexKey(),,RCOM2Fil1(cCampo))
		nIndex := RetIndex(cAlias)
		dbSetIndex(cIndTmp+OrdBagExt())
		dbSetOrder(nIndex+1)
		dbGotop()
        _nTotRec := Reccount()
		cAliasTmp := cAlias
#IFDEF TOP
	Endif
#ENDIF
    //
	dbSelectArea(cAliasTmp)
	ProcRegua(_nTotRec)
	Do While ( !Eof() ) 
	   //
#IFDEF TOP
	   IF TcSrvType() != "AS/400"
	      // Posiciona SE2 ou SE1 para pegar o saldo do titulo correto
		  (cAlias)->(DbGoto((cAliasTmp)->RECNO))
	   Endif	
#ENDIF
	   //
       dbSelectArea("SA2")
       DbSetOrder(1)
       dbSeek(xFilial("SA2")+(cAliasTmp)->&(cCampo+"_FORNECE"))
       dbSelectArea("SB1")
       DbSetOrder(1)
       dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_COD"))
       dbSelectArea("SBM")
       DbSetOrder(1)
       dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_COD"))
       dbSelectArea("SF4")
       DbSetOrder(1)
       dbSeek(xFilial("SF4")+(cAliasTmp)->&(cCampo+"_TES"))
       //
       aVenc := {}
       dbSelectArea("SE2")
       DbSetOrder(1)
       If dbSeek(xFilial("SE2")+(cAliasTmp)->&(cCampo+"_SERIE")+(cAliasTmp)->&(cCampo+"_DOC")) .and. SF4->F4_ESTOQUE=="S"
          Do While SE2->E2_FILIAL==xFilial("SE2") .and. SE2->E2_NUM==(cAliasTmp)->&(cCampo+"_DOC") .and.;
                   SE2->E2_PREFIXO==(cAliasTmp)->&(cCampo+"_SERIE") .and. SE2->E2_FORNECE==(cAliasTmp)->&(cCampo+"_FORNECE") .and.;
                   SE2->E2_LOJA==(cAliasTmp)->&(cCampo+"_LOJA") .and.  !Eof()
             //
             If SE2->E2_MSFIL >= mv_par01 .and. SE2->E2_MSFIL <= mv_par02
                Aadd(aVenc,{SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_VALOR, SE2->E2_VENCTO})
                dbSelectArea("SF1")
                DbSetOrder(1)
                dbSeek(SE2->E2_MSFIL+(cAliasTmp)->&(cCampo+"_DOC")+(cAliasTmp)->&(cCampo+"_SERIE")+(cAliasTmp)->&(cCampo+"_FORNECE")+(cAliasTmp)->&(cCampo+"_LOJA"))
                dbSelectArea("SE2")
             Endif
             //                1               2            3               4             5               6
             DbSkip()
             //
          Enddo         
          //
          If Len(aVenc) > 0
             For nX := 1 to Len(aVenc)
                 dbSelectArea("cArqTmp")
                 RecLock("cArqTmp",.T.)
                 cArqTmp->FILIAL    := (cAliasTmp)->&(cCampo+"_FILIAL")
                 cArqTmp->FORNEC    := (cAliasTmp)->&(cCampo+"_FORNECE")
                 cArqTmp->LOJA      := (cAliasTmp)->&(cCampo+"_LOJA")
                 cArqTmp->NREDUZ    := SA2->A2_NREDUZ
                 cArqTmp->DTEMISSAO := (cAliasTmp)->&(cCampo+"_EMISSAO")
                 cArqTmp->DTENTREGA := (cAliasTmp)->&(cCampo+"_DTDIGIT")
                 cArqTmp->PREFIXO   := aVenc[nX,1]
                 cArqTmp->NUMERO    := aVenc[nX,2]
                 cArqTmp->PARCELA   := Alltrim(aVenc[nX,3])+"/"+Alltrim(Str(Len(aVenc),2))
                 cArqTmp->TIPO      := "AP"
                 cArqTmp->VENCTO    := aVenc[nX,6]
                 cArqTmp->DESCRICAO := SB1->B1_DESC
                 If nX == 1
                    cArqTmp->QUANT  := (cAliasTmp)->&(cCampo+"_QUANT")
                 Endif
                 cArqTmp->UNIDADE   := (cAliasTmp)->&(cCampo+"_UM")
                 cArqTmp->PRUNIT    := (cAliasTmp)->&(cCampo+"_VUNIT")
                 cArqTmp->PRTOTAL   := (cAliasTmp)->&(cCampo+"_TOTAL")/SF1->F1_VALBRUT * aVenc[nX,5]
                 cArqTmp->PRODUTO   := (cAliasTmp)->&(cCampo+"_COD")
                 cArqTmp->ESTOQUE   := SaldoSB2()
                 cArqTmp->GRUPO     := SB1->B1_GRUPO
                 cArqTmp->DESCGRU   := SBM->BM_DESC
                 msUnlock()
             Next
          Endif
       Endif
	   //
	   dbSelectArea(cAliasTmp)
	   IncProc("Lendo as Notas Fiscais de Entrada")
	   dbSkip()
	   //
	Enddo
#IFDEF TOP
    //
	IF TcSrvType() != "AS/400"
		dbSelectArea(cAliasTmp)
		dbCloseArea()
		dbSelectArea(cAlias)
	Else
#ENDIF
		dbSelectArea(cAlias)
		DbClearFil()
		RetIndex(cAlias)
		FErase(cIndTmp+OrdBagExt())
#IFDEF TOP
	Endif
	//
#ENDIF
    //
Return


Static FUNCTION RCOM2Fil1( cCampo)
       //
       Local cFiltro,cAlias:=Alias()  
       //
       cFiltro := cCampo + "_FILIAL>='"+mv_par01+"'.And."
       cFiltro += cCampo + "_FILIAL<='"+mv_par02+"'.And."
       cFiltro += "Dtos(" + cCampo + "_DTDIGIT)>='"+Dtos(mv_par03)+"'.And. "
       cFiltro += "Dtos(" + cCampo + "_DTDIGIT)<='"+Dtos(mv_par04)+"'.And. "
       cFiltro += cCampo + "_FORNECE >= '"+mv_par09+"' .And. "+cCampo + "_FORNECE <= '"+mv_par10+"' .And. "
       cFiltro += cCampo + "_COD >= '"+mv_par07+"' .And. "+cCampo + "_COD <= '"+mv_par08+"'"
       //
Return cFiltro


//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RCOM02Dev  ºAutor  ³Alexandre Martim    º Data ³  22/05/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera dados no arquivo temporario                            º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOM02                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION RCOM02Dev()
       //
       LOCAL cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,cAlias:="SD2",cCampo:="D2",nOrdem:=2,_nTotRec,;
             cQuery2
       //
#IFDEF TOP
	IF TcSrvType() != "AS/400"
	    //
		cAliasTmp := "RCOM02"
		cQuery  := "SELECT Count(*) AS Soma "
		cQuery2 := "FROM "+RetSqlName(cAlias)+ " "+ cAlias + " "
		cQuery2 += "WHERE "
		cQuery2 += cAlias + "." + cCampo + "_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
		cQuery2 += cAlias + "." + cCampo + "_TIPO='D' AND "
		cQuery2 += cAlias + "." + cCampo + "_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' AND "
		cQuery2 += cAlias + "." + cCampo + "_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' AND "
		cQuery2 += cAlias + "." + cCampo + "_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
		cQuery2 += cAlias + ".D_E_L_E_T_=' ' "
		cQuery  += cQuery2
        //
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
        _nTotRec := (cAliasTmp)->SOMA
        dbCloseArea()
	    //
		aStru  := (cAlias)->(dbStruct())
		cAliasTmp := "RCOM02"
		cQuery := ""
		aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery +=         ",R_E_C_N_O_ RECNO "
		cQuery += cQuery2
        //
		cQuery := ChangeQuery(cQuery)
		Memowrite("SQL",cQuery)
		//
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
		//
		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(cAliasTmp,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
		//
	Else
#ENDIF
		dbSelectArea(cAlias)
		dbSetOrder(nOrdem)
		cIndTmp := CriaTrab(,.F.)
		IndRegua(cAlias,cIndTmp,IndexKey(),,RCOM2Fil2(cCampo))
		nIndex := RetIndex(cAlias)
		dbSetIndex(cIndTmp+OrdBagExt())
		dbSetOrder(nIndex+1)
		dbGotop()
        _nTotRec := Reccount()
		cAliasTmp := cAlias
#IFDEF TOP
	Endif
#ENDIF
    //
	dbSelectArea(cAliasTmp)
	ProcRegua(_nTotRec)
	Do While ( !Eof() ) 
	   //
#IFDEF TOP
	   IF TcSrvType() != "AS/400"
	      // Posiciona SE2 ou SE1 para pegar o saldo do titulo correto
		  (cAlias)->(DbGoto((cAliasTmp)->RECNO))
	   Endif	
#ENDIF
	   //
       dbSelectArea("SA2")
       DbSetOrder(1)
       dbSeek(xFilial("SA2")+(cAliasTmp)->&(cCampo+"_CLIENTE"))
       dbSelectArea("SB1")
       DbSetOrder(1)
       dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_COD"))
       dbSelectArea("SBM")
       DbSetOrder(1)
       dbSeek(xFilial("SB1")+(cAliasTmp)->&(cCampo+"_COD"))
       dbSelectArea("SF4")
       DbSetOrder(1)
       dbSeek(xFilial("SF4")+(cAliasTmp)->&(cCampo+"_TES"))
       dbSelectArea("SF2")
       DbSetOrder(1)
       dbSeek(xFilial("SF2")+(cAliasTmp)->&(cCampo+"_DOC")+(cAliasTmp)->&(cCampo+"_SERIE")+(cAliasTmp)->&(cCampo+"_CLIENTE")+(cAliasTmp)->&(cCampo+"_LOJA"))
       //
       aVenc := {}
       dbSelectArea("SE2")
       DbSetOrder(1)
       If dbSeek(xFilial("SE2")+(cAliasTmp)->&(cCampo+"_SERIE")+(cAliasTmp)->&(cCampo+"_DOC")) .and. SF4->F4_ESTOQUE=="S"
          Do While SE2->E2_FILIAL==xFilial("SE2") .and. SE2->E2_NUM==(cAliasTmp)->&(cCampo+"_DOC") .and.;
                   SE2->E2_PREFIXO==(cAliasTmp)->&(cCampo+"_SERIE") .and. SE2->E2_FORNECE==(cAliasTmp)->&(cCampo+"_CLIENTE") .and.;
                   SE2->E2_LOJA==(cAliasTmp)->&(cCampo+"_LOJA") .and.  !Eof()
             //
             If SE2->E2_MSFIL >= mv_par01 .and. SE2->E2_MSFIL <= mv_par02 .and. SE2->E2_MSFIL == (cAliasTmp)->&(cCampo+"_FILIAL")
                Aadd(aVenc,{SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_VALOR, SE2->E2_VENCTO})
             Endif
             //                1               2            3               4             5               6
             DbSkip()
             //
          Enddo         
          //
          If Len(aVenc) > 0
             For nX := 1 to Len(aVenc)
                 dbSelectArea("cArqTmp")
                 RecLock("cArqTmp",.T.)
                 cArqTmp->FILIAL    := (cAliasTmp)->&(cCampo+"_FILIAL")
                 cArqTmp->FORNEC    := (cAliasTmp)->&(cCampo+"_CLIENTE")
                 cArqTmp->LOJA      := (cAliasTmp)->&(cCampo+"_LOJA")
                 cArqTmp->NREDUZ    := SA2->A2_NREDUZ
                 cArqTmp->DTEMISSAO := (cAliasTmp)->&(cCampo+"_EMISSAO")
                 cArqTmp->DTENTREGA := (cAliasTmp)->&(cCampo+"_EMISSAO")
                 cArqTmp->PREFIXO   := aVenc[nX,1]
                 cArqTmp->NUMERO    := aVenc[nX,2]
                 cArqTmp->PARCELA   := Alltrim(aVenc[nX,3])+"/"+Alltrim(Str(Len(aVenc),2))
                 cArqTmp->TIPO      := "DV"
                 cArqTmp->VENCTO    := aVenc[nX,6]
                 cArqTmp->DESCRICAO := SB1->B1_DESC
                 If nX == 1
                    cArqTmp->QUANT  := -(cAliasTmp)->&(cCampo+"_QUANT")
                 Endif
                 cArqTmp->UNIDADE   := (cAliasTmp)->&(cCampo+"_UM")
                 cArqTmp->PRUNIT    := (cAliasTmp)->&(cCampo+"_PRCVEN")
                 cArqTmp->PRTOTAL   := -(cAliasTmp)->&(cCampo+"_TOTAL")/SF2->F2_VALBRUT * aVenc[nX,5]
                 cArqTmp->PRODUTO   := (cAliasTmp)->&(cCampo+"_COD")
                 cArqTmp->ESTOQUE   := SaldoSB2()
                 cArqTmp->GRUPO     := SB1->B1_GRUPO
                 cArqTmp->DESCGRU   := SBM->BM_DESC
                 msUnlock()
             Next
          Endif
       Endif
	   //
	   dbSelectArea(cAliasTmp)
	   IncProc("Lendo as Devolucoes nas Saidas")
	   dbSkip()
	   //
	Enddo
#IFDEF TOP
    //
	IF TcSrvType() != "AS/400"
		dbSelectArea(cAliasTmp)
		dbCloseArea()
		dbSelectArea(cAlias)
	Else
#ENDIF
		dbSelectArea(cAlias)
		DbClearFil()
		RetIndex(cAlias)
		FErase(cIndTmp+OrdBagExt())
#IFDEF TOP
	Endif
	//
#ENDIF
    //
Return


Static FUNCTION RCOM2Fil2( cCampo)
       //
       Local cFiltro,cAlias:=Alias()  
       //
       cFiltro := cCampo + "_FILIAL>='"+mv_par01+"'.And."
       cFiltro += cCampo + "_FILIAL<='"+mv_par02+"'.And."
       cFiltro += cCampo + "_TIPO='D'.And."
       cFiltro += "Dtos(" + cCampo + "_EMISSAO)>='"+Dtos(mv_par03)+"'.And. "
       cFiltro += "Dtos(" + cCampo + "_EMISSAO)<='"+Dtos(mv_par04)+"'.And. "
       cFiltro += cCampo + "_CLIENTE >= '"+mv_par09+"' .And. "+cCampo + "_CLIENTE <= '"+mv_par10+"' .And. "
       cFiltro += cCampo + "_COD >= '"+mv_par07+"' .And. "+cCampo + "_COD <= '"+mv_par08+"'"
       //
Return cFiltro


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
       AADD(_aRegs,{_cPerg,"01","Filial de           ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","  ","","","","","","","","","","","","","","","","","","","","","SM0",""})
       AADD(_aRegs,{_cPerg,"02","Filial Ate          ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","ZZ","","","","","","","","","","","","","","","","","","","","","SM0",""})
       AADD(_aRegs,{_cPerg,"03","Data Entrega de     ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"04","Data Entrega Ate    ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","31/12/49","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"05","Data Emissao Ped de ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"06","Data Emissao Ped Ate?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","31/12/49","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"07","Produto De          ?","","","mv_ch7","C",15,0,0,"G","","mv_par07","","","","90000          ","","","","","","","","","","","","","","","","","","","","","SB1",""})
       AADD(_aRegs,{_cPerg,"08","Produto Ate         ?","","","mv_ch8","C",15,0,0,"G","","mv_par08","","","","92999          ","","","","","","","","","","","","","","","","","","","","","SB1",""})
       AADD(_aRegs,{_cPerg,"09","Fornecedor De       ?","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","  ","","","","","","","","","","","","","","","","","","","","","SA2",""})
       AADD(_aRegs,{_cPerg,"10","Fornecdor Ate       ?","","","mv_chA","C",06,0,0,"G","","mv_par10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA2",""})
       AADD(_aRegs,{_cPerg,"11","Considera Devolucao ?","","","mv_chB","N",01,0,0,"C","","mv_par11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"12","Imprime Parcelas    ?","","","mv_chC","N",01,0,0,"C","","mv_par12","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"13","Imprime Tipos       ?","","","mv_chD","N",01,0,4,"C","","mv_par13","PC-Ped. Compra","","","","","AP-A Pagar","","","","","DV-Devolucoes","","","","","Todos","","","","","","","","","",""})
       //AADD(_aRegs,{_cPerg,"13","Imprime tipos       ?","","","mv_chD","C",30,0,0,"G","","mv_par13","","","","PC/AP/DV                      ","","","","","","","","","","","","","","","","","","","","","",""})
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
