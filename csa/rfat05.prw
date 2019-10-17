#include "rwmake.CH"

#define LIM_LINHAS 60

#define _NOTAS  1
#define _VALOR  2
#define _PESO   3
#define _FRETE  5

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFAT05   ºAutor  ³Alexandre Martim    º Data ³  28/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio demonstrativo do custo de frete por transporta-  º±±
±±º          ³ dora.                                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Sloten do Brasil                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT05()
    //
	Private cDesc1 := "Relatorio demonstrativo do custo de frete por transportadora"
	Private cDesc2 := "Observar os parametros do Relatorio"
	Private cDesc3 :=""
	Private cString:="SD2"
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
    Private aOrd := {"por Cidade",;
                     "por Transportadora",;
                     "por Estado"}
    //
	Private nomeprog:= "RFAT05"
	Private aLinha  := { },nLastKey := 0
	Private cPerg   := "RFAT05"
	Private nColun  := 0  // Controle de colunas (substitui pCol())
	Private nQuebra := 5
    //
    #IFNDEF TOP
       Alert("Este Relatorio foi feito especicamente para ambiente TOP CONNECT!")
       Return
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
	wnrel := "RFAT05"
	//
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
    Tamanho := "G"
    Titulo  := "Rel. Frete "+aOrd[aReturn[8]]+"  Periodo: "+dtoc(mv_par05)+" ate "+dtoc(mv_par06)
    //
    Processa( {|| FRFAT05(wnRel) }, "Fretes por transportadora, processando..." )
    //
Return

Static Function FRFAT05(wnRel)
       //
       Private cbCont:=0,CbTxt:=Space(10),_lPrimeiraVez:=.t.,_cGuarda,_aTotQuebra,_aTotGeral,_lPriVez:=.t.,;
               _aTotLinha, _aGrupos:={}
       //
       aCampos:={;
   	         {"FILIAL"   , "C" , 02,0},;
   	         {"CLIENTE"  , "C" , 06,0},;
   	         {"LOJA"     , "C" , 02,0},;
   	         {"NOMECLI"  , "C" , 40,0},;
   	         {"CIDCLI"   , "C" , 25,0},;
   	         {"ESTCLI"   , "C" , 02,0},;
  	         {"TRANSP"   , "C" , 06,0},;
  	         {"NOMETRAN" , "C" , 40,2},;
   	         {"DTEMISSAO", "D" , 08,0},;
  	         {"QUANT"    , "N" , 11,2},;
  	         {"PESO"     , "N" , 11,2},;
  	         {"PRTOTAL"  , "N" , 15,4},;
   	         {"NCONHEC"  , "C" , 06,0},;
  	         {"NFISCAL"  , "C" , 06,0},;
  	         {"SERIE"    , "C" , 06,0},;
  	         {"PEDCLI"   , "C" , 06,0},;
  	         {"PEDIDO"   , "C" , 06,0},;
  	         {"VALFRETE" , "N" , 15,4},;
  	         {"FRETETON" , "N" , 15,2},;
   	         {"MARCA"    , "C" , 01,0} }
       //
       cArqTmp := CriaTrab(aCampos,.T.)
       dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)
       If aReturn[8] == 1
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+CIDCLI+TRANSP+NFISCAL+SERIE",,,"Selecionando Registros...")
       ElseIf aReturn[8] == 2
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+TRANSP+NFISCAL+SERIE",,,"Selecionando Registros...")
       ElseIf aReturn[8] == 3
          IndRegua ( "cArqTmp",cArqTmp,"FILIAL+ESTCLI+TRANSP+CIDCLI+NFISCAL+SERIE",,,"Selecionando Registros...")
       Endif
	   //
       // Processa Notas de Saida 
       //
       RFAT05Tmp()
       //
       //
       If aReturn[8] == 1
          cabec1  := "N.Fiscal Transportadora                           Uf Emissao       Valor          Peso       Frete/Ton   Conhec. "
          cabec2  := ""
          //          xxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx 99/99/99  9.999.999,99  9.999.999,99  9.999.999,99  XXXXXX
          //          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
          //                    1         2         3         4         5         6         7         8         9         10        11        12        13     
       ElseIf aReturn[8] == 2
          cabec1  := "N.Fiscal Cliente                                  Cidade                    Uf Emissao       Valor         Peso      Frete/Ton   Conhec. "
          cabec2  := ""
          //          xxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx xx 99/99/99  9.999.999,99 9.999.999,99 9.999.999,99  XXXXXX
          //          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
          //                    1         2         3         4         5         6         7         8         9         10        11        12        13     
       Elseif aReturn[8] == 3
          cabec1  := "N.Fiscal Transportadora                           Cliente                                  Cidade                    Emissao       Valor         Peso      Frete/Ton     Conhec. "
          cabec2  := ""
          //          xxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx 99/99/99  9.999.999,99 9.999.999,99 9.999.999,99  XXXXXX
          //          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          //                    1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17
       Endif
       _cGuarda   :="@#$%¨&*()"
       //
       _aTotQuebra := {   0.00,    0.00,   0.00,   0.00,      0.00    }
       //               No Notas   Valor   Peso   Volume   Vlr Frete
       //                 1          2      3       4          5
       //
       _aTotGeral := {   0.00,    0.00,   0.00,   0.00,      0.00    }
       _aTotLinha := {   0.00,    0.00,   0.00,   0.00,      0.00    }
       //
       //
       // Processa o arquivo temporario
       //
       dbSelectArea("cArqTmp")
       DbGoTop()
       ProcRegua(cArqTmp->(RecCount()))
       Do While .t.
          //
          FImpOrd1()
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
       FimOrd1()
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
       dbSelectArea("SD2")
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
       If _nLinha > LIM_LINHAS
          cabec(Titulo,Space(nQuebra)+cabec1,"",nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
          _nLinha := 8
       Endif
       //
Return 

//
Static Function FImpOrd1()
       //
       If _cGuarda <> Iif(aReturn[8]==1,cArqTmp->FILIAL+cArqTmp->CIDCLI,Iif(aReturn[8]==2,;
                          cArqTmp->FILIAL+cArqTmp->TRANSP,cArqTmp->FILIAL+cArqTmp->ESTCLI))
          //
          If !_lPrimeiraVez
               FLin(1)
               @ _nLinha, 000 PSAY __PrtThinLine()
               FLin(1)
		       @ _nLinha, nQuebra+000 PSAY "Total de Notas"+Transform(_aTotQuebra[_NOTAS], "@E 9,999")
               If aReturn[8] == 1
                  @ _nLinha, nQuebra+063 PSAY Transform(_aTotQuebra[_VALOR] , "@E 9,999,999.99")
                  @ _nLinha, nQuebra+077 PSAY Transform(_aTotQuebra[_PESO]  , "@E 9,999,999.99")
                  @ _nLinha, nQuebra+091 PSAY Transform(_aTotQuebra[_VALOR]/_aTotQuebra[_PESO]*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
               Elseif aReturn[8] == 2
                  @ _nLinha, nQuebra+089 PSAY Transform(_aTotQuebra[_VALOR] , "@E 9,999,999.99")
                  @ _nLinha, nQuebra+102 PSAY Transform(_aTotQuebra[_PESO]  , "@E 9,999,999.99")
                  @ _nLinha, nQuebra+115 PSAY Transform(_aTotQuebra[_VALOR]/_aTotQuebra[_PESO]*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
               Elseif aReturn[8] == 3
                  @ _nLinha, nQuebra+127 PSAY Transform(_aTotQuebra[_VALOR] , "@E 9,999,999.99")
                  @ _nLinha, nQuebra+140 PSAY Transform(_aTotQuebra[_PESO]  , "@E 9,999,999.99")
                  @ _nLinha, nQuebra+153 PSAY Transform(_aTotQuebra[_VALOR]/_aTotQuebra[_PESO]*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
               Endif
               FLin(1)
          Endif
          //
          FLin(1)
          If aReturn[8] == 1
             @ _nLinha, 000 PSAY "Cidade: "+cArqTmp->CIDCLI
             _cGuarda := cArqTmp->FILIAL+cArqTmp->CIDCLI
          Elseif aReturn[8] == 2
             @ _nLinha, 000 PSAY "Transportadora: "+cArqTmp->TRANSP+" - "+cArqTmp->NOMETRAN
             _cGuarda := cArqTmp->FILIAL+cArqTmp->TRANSP
          Elseif aReturn[8] == 3
             @ _nLinha, 000 PSAY "Estado: "+cArqTmp->ESTCLI
             _cGuarda := cArqTmp->FILIAL+cArqTmp->ESTCLI
          Endif
          FLin(1)
          @ _nLinha, 000 PSAY __PrtThinLine()
          //
          _aTotQuebra := {   0.00,    0.00,   0.00,   0.00,      0.00    }
          _lPrimeiraVez:=.f.
          //
          If Eof()
             Return
          Endif
          //
       Endif
       //
       FLin(1)
       If aReturn[8] == 1
          @ _nLinha, nQuebra+000 PSAY cArqTmp->NFISCAL
          @ _nLinha, nQuebra+009 PSAY cArqTmp->NOMETRAN
          @ _nLinha, nQuebra+050 PSAY cArqTmp->ESTCLI
          @ _nLinha, nQuebra+053 PSAY DTOC(cArqTmp->DTEMISSAO)
          @ _nLinha, nQuebra+063 PSAY Transform(cArqTmp->PRTOTAL  , "@E 9,999,999.99")
          @ _nLinha, nQuebra+077 PSAY Transform(cArqTmp->PESO     , "@E 9,999,999.99")
          @ _nLinha, nQuebra+091 PSAY Transform(cArqTmp->PRTOTAL/cArqTmp->PESO*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
          @ _nLinha, nQuebra+105 PSAY cArqTmp->NCONHEC
       ElseIf aReturn[8] == 2
          @ _nLinha, nQuebra+000 PSAY cArqTmp->NFISCAL
          @ _nLinha, nQuebra+009 PSAY cArqTmp->NOMECLI
          @ _nLinha, nQuebra+050 PSAY cArqTmp->CIDCLI
          @ _nLinha, nQuebra+076 PSAY cArqTmp->ESTCLI
          @ _nLinha, nQuebra+079 PSAY DTOC(cArqTmp->DTEMISSAO)
          @ _nLinha, nQuebra+089 PSAY Transform(cArqTmp->PRTOTAL  , "@E 9,999,999.99")
          @ _nLinha, nQuebra+102 PSAY Transform(cArqTmp->PESO     , "@E 9,999,999.99")
          @ _nLinha, nQuebra+115 PSAY Transform(cArqTmp->PRTOTAL/cArqTmp->PESO*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
          @ _nLinha, nQuebra+129 PSAY cArqTmp->NCONHEC
       ElseIf aReturn[8] == 3
          @ _nLinha, nQuebra+000 PSAY cArqTmp->NFISCAL
          @ _nLinha, nQuebra+009 PSAY cArqTmp->NOMETRAN
          @ _nLinha, nQuebra+050 PSAY cArqTmp->NOMECLI
          @ _nLinha, nQuebra+091 PSAY cArqTmp->CIDCLI
          @ _nLinha, nQuebra+117 PSAY DTOC(cArqTmp->DTEMISSAO)
          @ _nLinha, nQuebra+127 PSAY Transform(cArqTmp->PRTOTAL  , "@E 9,999,999.99")
          @ _nLinha, nQuebra+140 PSAY Transform(cArqTmp->PESO     , "@E 9,999,999.99")
          @ _nLinha, nQuebra+153 PSAY Transform(cArqTmp->PRTOTAL/cArqTmp->PESO*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
          @ _nLinha, nQuebra+167 PSAY cArqTmp->NCONHEC
       Endif
       //
       _aTotLinha[_NOTAS]  := 1
       _aTotLinha[_VALOR]  := cArqTmp->PRTOTAL
       _aTotLinha[_PESO]   := cArqTmp->PESO
       _aTotLinha[_FRETE]  := cArqTmp->VALFRETE
       //
       If !((_nPos := Ascan(_aGrupos, {|x| x[Len(_aTotLinha)+1]==IIf(aReturn[8]==1,cArqTmp->CIDCLI,Iif(aReturn[8]==2,cArqTmp->NOMETRAN,cArqTmp->ESTCLI)) })) > 0)
          aadd(_aGrupos, { 0.00, 0.00, 0.00, 0.00, 0.00, IIf(aReturn[8]==1,cArqTmp->CIDCLI,Iif(aReturn[8]==2,cArqTmp->NOMETRAN,cArqTmp->ESTCLI)) })
          _nPos := Len(_aGrupos)
       Endif
       //
       For _n:=1 to Len(_aTotLinha)
           _aGrupos[_nPos, _n] += _aTotLinha[_n]
           _aTotQuebra[_n]     += _aTotLinha[_n]
           _aTotGeral[_n]      += _aTotLinha[_n]
       Next
       //
Return

Static Function FimOrd1() 
       //
       FLin(1000)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       @ _nLinha, nQuebra PSAY "Resumo "+PADL(aOrd[aReturn[8]],18)+"                        Nro Notas        Valor         Peso        Frete;Ton   "
       //                       xxxxxx                                                    99.999.999,99  9.999.999,99  9.999.999,99  9, 999.999,99
       //                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
       //                                 1         2         3         4         5         6         7         8         9         10        11        12        13     
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       //
       For _n:=1 to Len(_aGrupos)
           FLin(1)
	       @ _nLinha, nQuebra+002 PSAY _aGrupos[_n, Len(_aGrupos[_n])]
           @ _nLinha, nQuebra+052 PSAY Transform(_aGrupos[_n, _NOTAS], "@E 9,999")
           @ _nLinha, nQuebra+058 PSAY Transform(_aGrupos[_n, _VALOR] , "@E 9,999,999.99")
           @ _nLinha, nQuebra+073 PSAY Transform(_aGrupos[_n, _PESO]  , "@E 9,999,999.99")
           @ _nLinha, nQuebra+087 PSAY Transform(_aGrupos[_n, _VALOR]/_aGrupos[_n, _PESO]*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
	   Next
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       //
       FLin(4)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       @ _nLinha, nQuebra PSAY "Total Geral                                      Nro Notas        Valor         Peso       Frete;Ton   "
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       FLin(1)
       @ _nLinha, nQuebra+052 PSAY Transform(_aTotGeral[_NOTAS], "@E 9,999")
       @ _nLinha, nQuebra+058 PSAY Transform(_aTotGeral[_VALOR] , "@E 9,999,999.99")
       @ _nLinha, nQuebra+073 PSAY Transform(_aTotGeral[_PESO]  , "@E 9,999,999.99")
       @ _nLinha, nQuebra+087 PSAY Transform(_aTotGeral[_VALOR]/_aTotGeral[_PESO]*1000*(1+(mv_par12/100)), "@E 9,999,999.99")
       FLin(1)
       @ _nLinha, 000 PSAY __PrtThinLine()
       //
Return
//

//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ RFAT05Tmp ºAutor  ³Alexandre Martim    º Data ³  12/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera dados no arquivo temporario                             º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFAT05                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFAT05Tmp()
        //
        LOCAL cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,cAlias:="SF2",cCampo:="F2",;
        nOrdem:=2,_nTotRec,cQuery2,_nTotPeso
        //
    	cAliasTmp := "RFAT05"
   		cQuery  := "SELECT Count(*) AS Soma "
		cQuery2 := "FROM "+RetSqlName("SC7")+" C7,"+RetSqlName("SF2")+" F2,"+RetSqlName("SA1")+" A1, "+RetSqlName("SA4")+" A4 "+chr(13)+chr(10)
		cQuery2 += "WHERE "
		cQuery2 += "F2.F2_FILIAL = '"+xFilial("SF2")+"' AND C7.C7_FILIAL = '"+xFilial("SC7")+"' AND "+chr(13)+chr(10)
		cQuery2 += "F2.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_ =' ' AND A1.D_E_L_E_T_ =' ' AND A4.D_E_L_E_T_ =' ' AND "+chr(13)+chr(10)
        cQuery2 += "C7.C7_FILIAL = F2.F2_FILIAL AND C7.C7_F2NUM = F2.F2_DOC AND F2.F2_CLIENTE = A1.A1_COD AND F2.F2_LOJA = A1.A1_LOJA AND "+chr(13)+chr(10)
        cQuery2 += "F2.F2_EMISSAO BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"' AND "+chr(13)+chr(10)
        cQuery2 += "F2.F2_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "+chr(13)+chr(10)
        cQuery2 += "F2.F2_TRANSP BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "+chr(13)+chr(10)
        cQuery2 += "A4.A4_COD = F2.F2_TRANSP AND "+chr(13)+chr(10)
        cQuery2 += "A1.A1_EST BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+chr(13)+chr(10)
        If !Empty(mv_par10)
           cQuery2 += "AND A1.A1_SLMUN LIKE '%"+alltrim(mv_par10)+"%' "+chr(13)+chr(10)
        Endif
		cQuery  += cQuery2
        //
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
        _nTotRec := (cAliasTmp)->SOMA
        dbCloseArea()
	    //
		cAliasTmp := "RFAT05"
		cQuery := "SELECT F2_FILIAL, C7_NUM, C7_PRECO, C7_TOTAL, C7_FORNECE, C7_LOJA, F2_CLIENTE, F2_LOJA, "
		cQuery += "A4_NOME, F2_TRANSP, F2_EMISSAO, F2_DOC, F2_SERIE, A1_NOME, A1_EST, A1_SLMUN "
		cQuery += cQuery2
        //
		cQuery := ChangeQuery(cQuery)
		Memowrite("SQL",cQuery)
		//
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
		//
    	TcSetField(cAliasTmp,"C7_PRECO","N",TamSx3("C7_PRECO")[1], TamSx3("C7_PRECO")[2] )
    	TcSetField(cAliasTmp,"C7_TOTAL","N",TamSx3("C7_TOTAL")[1], TamSx3("C7_TOTAL")[2] )
    	TcSetField(cAliasTmp,"F2_EMISSAO","D",TamSx3("F2_EMISSAO")[1], TamSx3("F2_EMISSAO")[2] )
    	//
    	dbSelectArea(cAliasTmp)
    	ProcRegua(_nTotRec)
    	Do While ( !Eof() ) 
    	   //
           _nTotPeso := 0.00
           dbSelectArea("SD2")
           DbSetOrder(3)
           If dbSeek(xFilial("SD2")+(cAliasTmp)->F2_DOC+(cAliasTmp)->F2_SERIE,.f.)
              Do While !Eof() .and. SD2->D2_FILIAL==(cAliasTmp)->F2_FILIAL .and.;
                       SD2->D2_DOC==(cAliasTmp)->F2_DOC .and. SD2->D2_SERIE==(cAliasTmp)->F2_SERIE
                 dbSelectArea("SB1")
                 DbSetOrder(1)
                 If dbSeek(xFilial("SB1")+SD2->D2_COD,.f.)
                    _nTotPeso += (SB1->B1_SLPESO*SD2->D2_QUANT)
                 Endif
                 dbSelectArea("SD2")
                 DbSkip()
              Enddo
           Endif
           //
           _lFreteFechado := .f.
           dbSelectArea("SD1")
           DbSetOrder(11)
           If dbSeek(xFilial("SD1")+(cAliasTmp)->C7_FORNECE+(cAliasTmp)->C7_LOJA+(cAliasTmp)->C7_NUM,.f.)
              _lFreteFechado := .t.
           Endif
           //
           If (_lFreteFechado .and. mv_par09==2) .or. (!_lFreteFechado .and. mv_par09==3)
              dbSelectArea(cAliasTmp)
              IncProc("Lendo os Conhecimentos de fretes")
              dbSkip()
              loop
           Endif
           //
           dbSelectArea("cArqTmp")
           If aReturn[8] == 1
              DbSeek((cAliasTmp)->F2_FILIAL+(cAliasTmp)->A1_SLMUN+(cAliasTmp)->F2_TRANSP+(cAliasTmp)->F2_DOC+(cAliasTmp)->F2_SERIE,.F.)
           ElseIf aReturn[8] == 2
              DbSeek((cAliasTmp)->F2_FILIAL+(cAliasTmp)->F2_TRANSP+(cAliasTmp)->F2_DOC+(cAliasTmp)->F2_SERIE,.F.)
           ElseIf aReturn[8] == 3
              DbSeek((cAliasTmp)->F2_FILIAL+(cAliasTmp)->A1_EST+(cAliasTmp)->F2_TRANSP+(cAliasTmp)->A1_SLMUN+(cAliasTmp)->F2_DOC+(cAliasTmp)->F2_SERIE,.F.)
           Endif
           //
           If Found()
              If RecLock("cArqTmp",.F.)
                 cArqTmp->PESO      += _nTotPeso
                 cArqTmp->PRTOTAL   := (cAliasTmp)->C7_TOTAL
                 cArqTmp->FRETETON  := (cAliasTmp)->C7_TOTAL/_nTotPeso*1000*(1+(mv_par12/100))
                 msUnlock()
              Endif
           Else
              If RecLock("cArqTmp",.T.)
                 cArqTmp->FILIAL    := (cAliasTmp)->F2_FILIAL
                 cArqTmp->CLIENTE   := (cAliasTmp)->F2_CLIENTE
                 cArqTmp->LOJA      := (cAliasTmp)->F2_LOJA
                 cArqTmp->NOMECLI   := (cAliasTmp)->A1_NOME
                 cArqTmp->CIDCLI    := (cAliasTmp)->A1_SLMUN
                 cArqTmp->ESTCLI    := (cAliasTmp)->A1_EST
                 cArqTmp->TRANSP    := (cAliasTmp)->F2_TRANSP
                 cArqTmp->NOMETRAN  := (cAliasTmp)->A4_NOME
                 cArqTmp->DTEMISSAO := (cAliasTmp)->F2_EMISSAO
                 cArqTmp->PESO      += _nTotPeso
                 cArqTmp->PRTOTAL   := (cAliasTmp)->C7_TOTAL
                 cArqTmp->FRETETON  := (cAliasTmp)->C7_TOTAL/_nTotPeso*1000*(1+(mv_par12/100))
                 cArqTmp->NFISCAL   := (cAliasTmp)->F2_DOC
                 cArqTmp->SERIE     := (cAliasTmp)->F2_SERIE
                 cArqTmp->PEDIDO    := (cAliasTmp)->C7_NUM
                 cArqTmp->NCONHEC   := Iif(_lFreteFechado,SD1->D1_DOC,"")
                 msUnlock()
              Endif
           Endif
           //
           dbSelectArea(cAliasTmp)
           IncProc("Lendo os Conhecimentos de fretes")
     	   dbSkip()
	       //
        Enddo
        //
		dbSelectArea(cAliasTmp)
		dbCloseArea()
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
       AADD(_aRegs,{_cPerg,"01","Transportadora de            ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","      ","","","","","","","","","","","","","","","","","","","","","SA4",""})
       AADD(_aRegs,{_cPerg,"02","Transportadora Ate           ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA4",""})
       AADD(_aRegs,{_cPerg,"03","Estado de                    ?","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","  ","","","","","","","","","","","","","","","","","","","","","12",""})
       AADD(_aRegs,{_cPerg,"04","Estado Ate                   ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","ZZ","","","","","","","","","","","","","","","","","","","","","12",""})
       AADD(_aRegs,{_cPerg,"05","Periodo de                   ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"06","Periodo Ate                  ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","31/12/49","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"07","Cliente de                   ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","      ","","","","","","","","","","","","","","","","","","","","","SA1",""})
       AADD(_aRegs,{_cPerg,"08","Cliente Ate                  ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1",""})
       AADD(_aRegs,{_cPerg,"09","Quanto aos Fretes            ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Todos","","","","","Somente Abertos","","","","","Somente Fechados","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"10","Nome de Cidade que contem    ?","","","mv_chA","C",30,2,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"11","Relatorio                    ?","","","mv_chB","N",01,0,0,"C","","mv_par11","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"12","Percentual de ICMS no frete  ?","","","mv_chC","N",06,2,0,"G","","mv_par12","","","","12.61","","","","","","","","","","","","","","","","","","","","","",""})
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
