#include "protheus.ch"
#include "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELR201  ºAutor  ³Roberto Mezzalira   º Data ³  11/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de vendedores(Analitico)                         º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao se aplica                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado via menu.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function DELR201()

Local cDesc1 := "Imprime a relacao dos vendedores - (Analitico) "
Local cDesc2 := ""
Local cDesc3 := ""
Private titulo      := "RELATORIO DE VENDEDORES ANALITICO"
Private cabec1      :=""
Private cabec2      :=""
Private wnrel	 	:= "DLR201"
Private cPerg   	:= "DLR201"
Private nomeprog	:= "DELR201"
Private m_pag		:= 1
Private tamanho     := "G"
Private nTipo       := 18
Private nLastKey    := 0
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 1, 1, "", 1}
cString :="SF2"
ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Data de                                      ³
//³ mv_par02     // Data ate                                     ³
//³ mv_par03     // Grupo de                                     ³
//³ mv_par04     // Grupo ate                                    ³
//³ mv_par05     // Categoria de                                 ³
//³ mv_par06     // Categoria ate                                ³
//³ mv_par07     // Especie de                                   ³
//³ mv_par08     // Especie ate                                  ³
//³ mv_par09     // Vendedor de                                  ³
//³ mv_par10     // Vendedor ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

RptStatus({|lEnd| DELR201imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DELR201ImpºAutor  ³Roberto Mezzalira   º Data ³  11/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao do Relatorio de vendedores(Analitico)            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³lEnd    - Identifica se o processamento foi interrompido    º±±
±±º          ³WnRel   - Nome do Relatorio                                 º±±
±±º          ³cString - Alias do arquivo processado                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function DELR201Imp(lEnd,WnRel,cString)

LOCAL cabec1         := "Funcao    Vendedor                                          Emissao     Nota    Se   Produto          Descricao                        Quantidade     Valor Total"
LOCAL cabec2         := "                                                                        Fiscal                                                                                   "
LOCAL _cVENDANT      := " "
Local _cNomeAnt      := " "
LOCAL _nTqt          := 0
LOCAL _nTvlr         := 0
LOCAL _nTgqt         := 0
LOCAL _nTgvlr        := 0
LOCAL _nTgvlr        := 0

Local  cEnter		 :=  Chr(13)
Local  _cFuncao		 := ""

Private  _nTdevqt    := 0
Private  _nTdevlr    := 0

Private  _nTgdevqt   := 0
Private  _nTgdevlr   := 0

Private  _nTgdevqtAM := 0
Private  _nTgdevlrAM := 0

Private  _nTgqtAM    := 0
Private  _nTgvlrAM   := 0

Private  _nTTACqt    := 0
Private  _nTTACvl    := 0

Private  _nTgTACqt   := 0
Private  _nTgTACvl   := 0

Private  _nTgTACqtAM := 0
Private  _nTgTACvlAM := 0

Private  _nLin       := 80

Titulo := "Relatorio de Vendedores Analitico - Loja: "+xFilial("SF2")+" Periodo: "+DToC(MV_PAR01)+" à "+ DToC(MV_PAR02)

cQuery := "SELECT SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE, SD2.D2_COD,SB1.B1_DESC,SD2.D2_QUANT,SA3.A3_NOME,SD2.D2_TOTAL, "+cEnter
//cQuery := cQuery + " SD2.D2_NFORI, SD2.D2_SERIORI,SD2.D2_ITEM,SF2.F2_VEND1, '' FUNCAO, 'A' ORDEM "+cEnter
cQuery := cQuery + " SD2.D2_DOC, SD2.D2_SERIE,SD2.D2_ITEM,SF2.F2_VEND1, '' FUNCAO, 'A' ORDEM, "+cEnter
cQuery := cQuery + " SD2.D2_PRCVEN, SD2.D2_FILIAL, SB1.B1_DEPTODV, 0 QTD_MONT, 0 QTD_ALIN "+cEnter
cQuery := cQuery + " FROM "+retsqlname("SF2")+" SF2 ,"+retsqlname("SA3")+" SA3,"+retsqlname("SD2")+" SD2,"+retsqlname("SB1")+" SB1 ,"+retsqlname("SF4")+" SF4 "+cEnter
cQuery := cQuery + " WHERE SF2.F2_FILIAL = '"+SM0->M0_CODFIL+"' AND SF2.D_E_L_E_T_ = ' ' "+cEnter
//cQuery := cQuery + " WHERE SF2.F2_FILIAL = '04' AND  SF2.D_E_L_E_T_ = ' '  "+cEnter
cQuery := cQuery + " AND SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"' "+cEnter
cQuery := cQuery + " AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery := cQuery + " AND SD2.D2_DOC = SF2.F2_DOC  AND SD2.D2_SERIE = SF2.F2_SERIE "+cEnter
cQuery := cQuery + " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE  AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery := cQuery + " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' '  AND SB1.B1_COD = D2_COD "+cEnter
cQuery := cQuery + " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.D_E_L_E_T_ = ' '  AND SF4.F4_CODIGO = SD2.D2_TES  "+cEnter
cQuery := cQuery + " AND SF4.F4_DUPLIC = 'S'  "+cEnter
cQuery := cQuery + " AND SF2.F2_VALFAT > 0  "+cEnter
cQuery := cQuery + " AND F2_TIPVND IN ('A','V','F','T','R') AND SF2.F2_VEND1 BETWEEN '"+MV_PAR09+ "' AND '"+MV_PAR10+"' "+cEnter
cQuery := cQuery + " AND B1_GRUPO   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+cEnter
cQuery := cQuery + " AND B1_CATEG   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+cEnter
cQuery := cQuery + " AND B1_SPECIE2 BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "+cEnter
cQuery := cQuery + " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.D_E_L_E_T_ = ' ' "+cEnter
cQuery := cQuery + " AND SA3.A3_COD = SF2.F2_VEND1  "+cEnter

cQuery := cQuery + " UNION "+cEnter

cQuery := cQuery + " SELECT  SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE,SD2.D2_COD ,SB1.B1_DESC, SD2.D2_QUANT,SA3.A3_NOME, "+cEnter
cQuery := cQuery + " SD2.D2_TOTAL * PB4_PERC / 100 D2_TOTAL,SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_ITEM,PAB.PAB_CODTEC AS F2_VEND1,PAB.PAB_FUNCAO FUNCAO, 'B' ORDEM, " +cEnter
cQuery := cQuery + " SD2.D2_PRCVEN, SD2.D2_FILIAL, SB1.B1_DEPTODV,  " +cEnter

//////////// Qtd Montagem
cQuery += " (SELECT COUNT(*) QTD FROM "+retsqlname("PAB")+" PAB " +cEnter
cQuery += " WHERE PAB.PAB_FILIAL = SL1.L1_FILIAL AND PAB.D_E_L_E_T_  = ' ' "+cEnter
cQuery += " AND PAB.PAB_FUNCAO = '2' AND PAB.PAB_ORC = SL1.L1_NUM GROUP BY PAB_FILIAL, PAB_ORC ) QTD_MONT, "   +cEnter

cQuery += " (SELECT COUNT(*) QTD FROM "+retsqlname("PAB")+" PAB "+cEnter
cQuery += " WHERE PAB.PAB_FILIAL = SL1.L1_FILIAL AND PAB.D_E_L_E_T_  = ' ' "+cEnter
cQuery += " AND PAB.PAB_FUNCAO = '1' AND PAB.PAB_ORC = SL1.L1_NUM GROUP BY PAB_FILIAL, PAB_ORC ) QTD_ALIN "+cEnter



//cQuery := cQuery + " SD2.D2_TOTAL,SD2.D2_NFORI, SD2.D2_SERIORI, SD2.D2_ITEM,PAB.PAB_CODTEC AS F2_VEND1,PAB.PAB_FUNCAO FUNCAO, 'B' ORDEM  " +cEnter
cQuery := cQuery + " FROM "+retsqlname("SF2")+" SF2 ,"+retsqlname("SL1")+" SL1,"+retsqlname("PAB")+" PAB,"+retsqlname("SA3")+" SA3,"+retsqlname("SD2")+" SD2,"+retsqlname("SB1")+" SB1 ,"+retsqlname("PB4")+" PB4 ,"+retsqlname("SF4")+" SF4 "+cEnter
cQuery := cQuery + " WHERE SF2.F2_FILIAL = '"+SM0->M0_CODFIL+"' AND  SF2.D_E_L_E_T_ = ' '  "+cEnter
//cQuery := cQuery + " WHERE SF2.F2_FILIAL = '04' AND  SF2.D_E_L_E_T_ = ' '  "+cEnter
cQuery := cQuery + " AND SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND SF2.F2_VALFAT > 0 AND SL1.L1_FILIAL = SF2.F2_FILIAL "+cEnter
cQuery := cQuery + " AND SL1.D_E_L_E_T_ = ' ' AND SL1.L1_DOC = SF2.F2_DOC AND SL1.L1_SERIE = SF2.F2_SERIE "+cEnter
cQuery := cQuery + " AND PAB.PAB_FILIAL = SF2.F2_FILIAL AND PAB.D_E_L_E_T_ = ' '  AND PAB.PAB_ORC = SL1.L1_NUM "+cEnter
cQuery := cQuery + " AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D_E_L_E_T_ = ' ' "+cEnter
cQuery := cQuery + " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE  "+cEnter
cQuery := cQuery + " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "+cEnter
cQuery := cQuery + " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' '  AND SB1.B1_COD = D2_COD "+cEnter
cQuery := cQuery + " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.D_E_L_E_T_ = ' '  AND SF4.F4_CODIGO = SD2.D2_TES "+cEnter
cQuery := cQuery + " AND SF4.F4_DUPLIC = 'S' AND PB4.PB4_FILIAL = '"+xFilial("PB4")+"'"+cEnter
//cQuery := cQuery + " AND PB4.D_E_L_E_T_ = ' '  AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO AND PB4.PB4_META = '4' "+cEnter
cQuery := cQuery + " AND PB4.D_E_L_E_T_ = ' '  AND PB4.PB4_FUNCAO = PAB.PAB_FUNCAO "+cEnter

If AllTrim(Upper(TcGetDb())) == "DB2"
	cQuery := cQuery + " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN "
	cQuery := cQuery + " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND  "+cEnter
	cQuery := cQuery + " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)   "+cEnter
Else
	cQuery := cQuery + " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN "
	cQuery := cQuery + " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND  "+cEnter
	cQuery := cQuery + " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM   "+cEnter
EndIf

cQuery := cQuery + " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.D_E_L_E_T_ = ' ' "+cEnter
cQuery := cQuery + " AND SA3.A3_COD = PAB.PAB_CODTEC "+cEnter
cQuery := cQuery + " AND SF2.F2_TIPVND IN ('A','V','F','T','R')   "+cEnter
cQuery := cQuery + " AND B1_GRUPO   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+cEnter
cQuery := cQuery + " AND B1_CATEG   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+cEnter
cQuery := cQuery + " AND B1_SPECIE2 BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "+cEnter
cQuery := cQuery + " AND PAB.PAB_CODTEC BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "+cEnter
cQuery := cQuery + " ORDER BY F2_VEND1, FUNCAO, ORDEM, F2_EMISSAO, F2_DOC, F2_SERIE "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
Endif

MEMOWRIT("DELR201.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
SetRegua( TMP->( RecCount() ) )

_nTgqt       := 0
_nTgvlr      := 0
_nTgdevqt    := 0
_nTgdevlr    := 0
_nTgdevqtAM  := 0
_nTgdevlrAM  := 0


DbSelectArea("TMP")
While !TMP->(eof())
	
	IncRegua()
	
	_cVENDANT := TMP->F2_VEND1
	_cNomeAnt := TMP->A3_NOME   // WM
	_cFuncao  := TMP->FUNCAO
	
	_nTqt     := 0
	_nTvlr    := 0
	_nTdevqt  := 0
	_nTdevlr  := 0
	
	DbSelectArea("TMP")
	
	While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao
		
		IF _nLin > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF
		
		
		IF EMPTY(TMP->FUNCAO)
			@_nLin,000 PSAY "Vendedor  "+_cVENDANT+" - "+_cNomeAnt
		ElseIf	TMP->FUNCAO == "1"
			@_nLin,000 PSAY "Alinhador "+_cVENDANT+" - "+_cNomeAnt
		ElseIf	TMP->FUNCAO == "2"
			@_nLin,000 PSAY "Montador  "+_cVENDANT+" - "+_cNomeAnt
		EndIf
		
		@_nLin,60 PSAY SUBSTR(TMP->F2_EMISSAO,7,2)+"/"+SUBSTR(TMP->F2_EMISSAO,5,2)+"/"+SUBSTR(TMP->F2_EMISSAO,1,4)
		@_nLin,pCol()+2 PSAY TMP->F2_DOC
		@_nLin,pCol()+2 PSAY TMP->F2_SERIE
		@_nLin,pCol()+2 PSAY TMP->D2_COD
		@_nLin,pCol()+2 PSAY TMP->B1_DESC
		@_nLin,pCol()+2 PSAY TMP->D2_QUANT  Picture PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY TMP->D2_TOTAL  Picture PesqPict("SD2","D2_TOTAL")
		_nLin := _nLin + 1
		Devolve()
		
		
		If EMPTY(TMP->FUNCAO) //VENDEDOR
			_nTqt  := _nTqt  + TMP->D2_QUANT
			_nTvlr := _nTvlr + TMP->D2_TOTAL
		ElseIf TMP->FUNCAO == "1" //ALINHADOR
			_nTqt  := _nTqt  + (TMP->D2_QUANT/TMP->QTD_ALIN)
			_nTvlr := _nTvlr + (TMP->D2_TOTAL/TMP->QTD_ALIN)
		Else
			_nTqt  := _nTqt  + (TMP->D2_QUANT/TMP->QTD_MONT)
			_nTvlr := _nTvlr + (TMP->D2_TOTAL/TMP->QTD_MONT)
		EndIf
		
		IF EMPTY(TMP->FUNCAO)
			_nTgqt   := _nTgqt  + TMP->D2_QUANT
			_nTgvlr  := _nTgvlr + TMP->D2_TOTAL
		ElseIF TMP->FUNCAO == "1" 
			_nTgqtAM  := _nTgqtAM  + (TMP->D2_QUANT/TMP->QTD_ALIN)
			_nTgvlrAM := _nTgvlrAM + (TMP->D2_TOTAL/TMP->QTD_ALIN)
		Else
			_nTgqtAM  := _nTgqtAM  + (TMP->D2_QUANT/TMP->QTD_MONT)
			_nTgvlrAM := _nTgvlrAM + (TMP->D2_TOTAL/TMP->QTD_MONT)		
		Endif
		
		IF ALLTRIM( TMP->B1_DEPTODV ) == 'TAC'
			
			_nTTACqt += TMP->D2_QUANT
			_nTTACvl += TMP->D2_TOTAL
			
			IF EMPTY(TMP->FUNCAO)
				_nTgTACqt += TMP->D2_QUANT
				_nTgTACvl += TMP->D2_TOTAL
			Else
				_nTgTACqtAM += TMP->D2_QUANT
				_nTgTACvlAM += TMP->D2_TOTAL
			Endif
			
		EndIf
		
		
		dbSkip()
	End
	_nLin++
	@_nLin,000 PSAY "Total:
	@_nLin,134 PSAY _nTqt  Picture PesqPict("SD2","D2_QUANT")
	@_nLin,147 PSAY _nTvlr Picture PesqPict("SD2","D2_TOTAL")
	_nLin++
	@_nLin,000 PSAY "Total de Devolucao: "
	@_nLin,134 PSAY _nTdevqt  Picture PesqPict("SD1","D1_QUANT")
	@_nLin,147 PSAY _nTdevlr  Picture PesqPict("SD1","D1_TOTAL")
	_nLin++
	@_nLin,000 PSAY "Total de TAC: "
	@_nLin,134 PSAY _nTTACqt  Picture PesqPict("SD2","D2_QUANT")
	@_nLin,147 PSAY _nTTACvl  Picture PesqPict("SD2","D2_TOTAL")
	
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
	_nLin := 9
	
End

_nLin :=  _nLin + 3

@_nLin,000 PSAY "Total Geral dos Vendedores: "
@_nLin,134 PSAY _nTgqt  Picture PesqPict("SD2","D2_QUANT")
@_nLin,147 PSAY _nTgvlr Picture PesqPict("SD2","D2_TOTAL")
_nLin := _nLin + 1

@_nLin,000 PSAY "Total Geral de Devolucao dos Vendedores: "
@_nLin,134 PSAY _nTgdevqt  Picture PesqPict("SD1","D1_QUANT")
@_nLin,147 PSAY _nTgdevlr  Picture PesqPict("SD1","D1_TOTAL")
_nLin := _nLin + 1

@_nLin,000 PSAY "Total Geral de TAC Vendedores: "
@_nLin,134 PSAY _nTgTACqt  Picture PesqPict("SD2","D2_QUANT")
@_nLin,147 PSAY _nTgTACvl  Picture PesqPict("SD2","D2_TOTAL")
_nLin := _nLin + 2


@_nLin,000 PSAY "Total Geral dos Alinhadores e Montadores: "
@_nLin,134 PSAY _nTgqtAM  Picture PesqPict("SD2","D2_QUANT")
@_nLin,147 PSAY _nTgvlrAM Picture PesqPict("SD2","D2_TOTAL")
_nLin := _nLin + 1

@_nLin,000 PSAY "Total Geral de Devolucao dos Alinhadores e Montadores: "
@_nLin,134 PSAY _nTgdevqtAM  Picture PesqPict("SD1","D1_QUANT")
@_nLin,147 PSAY _nTgdevlrAM  Picture PesqPict("SD1","D1_TOTAL")
_nLin := _nLin + 1

@_nLin,000 PSAY "Total Geral de TAC dos Alinhadores e Montadores: "
@_nLin,134 PSAY _nTgTACqtAM  Picture PesqPict("SD2","D2_QUANT")
@_nLin,147 PSAY _nTgTACvlAM  Picture PesqPict("SD2","D2_TOTAL")
_nLin := _nLin + 2

@_nLin,000 PSAY "Total Geral: "
@_nLin,134 PSAY (_nTgqt  + _nTgqtAM)  Picture PesqPict("SD2","D2_QUANT")
@_nLin,147 PSAY (_nTgvlr + _nTgvlrAM) Picture PesqPict("SD2","D2_TOTAL")
_nLin := _nLin + 1

@_nLin,000 PSAY "Total Geral de Devolucao: "
@_nLin,134 PSAY (_nTgdevqt + _nTgdevqtAM) Picture PesqPict("SD1","D1_QUANT")
@_nLin,147 PSAY (_nTgdevlr + _nTgdevlrAM) Picture PesqPict("SD1","D1_TOTAL")
_nLin := _nLin + 1

@_nLin,000 PSAY "Total Geral de TAC: "
@_nLin,134 PSAY (_nTgTACqt + _nTgTACqtAM) Picture PesqPict("SD2","D2_QUANT")
@_nLin,147 PSAY (_nTgTACvl + _nTgTACvlAM) Picture PesqPict("SD2","D2_TOTAL")

Roda() //cbcont,cbtxt,"G")
Set Device To Screen
If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif

MS_FLUSH()

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Devolve   ºAutor  ³Roberto Mezzalira   º Data ³  11/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime a devolucao                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Devolve()
Local cQuedev := ""
Local cEnter  := Chr(13)
Local aArea   := GetArea()

cQuedev := "SELECT SD1.D1_EMISSAO, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_COD, SB1.B1_DESC , SD1.D1_QUANT, SD1.D1_TOTAL "+cEnter
cQuedev := cQuedev + " FROM "+retsqlname("SD1")+" SD1 ,"+retsqlname("SB1")+" SB1, "+retsqlname("PB4")+" PB4 " +cEnter
cQuedev := cQuedev + "WHERE SD1.D1_TIPO = 'D' "+cEnter
//cQuedev := cQuedev + " AND SD1.D1_NFORI   = '"+TMP->D2_NFORI+"' "+cEnter
//cQuedev := cQuedev + " AND SD1.D1_SERIORI = '"+TMP->D2_SERIORI+"' "+cEnter
//cQuedev := cQuedev + " AND SD1.D1_ITEMORI = '"+TMP->D2_ITEM+"' "+cEnter

cQuedev := cQuedev + " AND SD1.D1_FILIAL  = '"+TMP->D2_FILIAL+"' "+cEnter
cQuedev := cQuedev + " AND SD1.D1_NFORI   = '"+TMP->D2_DOC+"' "+cEnter
cQuedev := cQuedev + " AND SD1.D1_SERIORI = '"+TMP->D2_SERIE+"' "+cEnter
cQuedev := cQuedev + " AND SD1.D1_ITEMORI = '"+TMP->D2_ITEM+"' "+cEnter
cQuedev := cQuedev + " AND SD1.D_E_L_E_T_ = ' ' "+cEnter

cQuedev := cQuedev + " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "' "+cEnter
cQuedev := cQuedev + " AND SD1.D1_COD  = SB1.B1_COD "+cEnter
cQuedev := cQuedev + " AND SB1.D_E_L_E_T_ = ' ' "+cEnter

cQuedev := cQuedev + " AND PB4.PB4_FILIAL = '" + xFilial('PB4') + "' "+cEnter
cQuedev := cQuedev + " AND PB4.D_E_L_E_T_ = ' ' "+cEnter
cQuedev := cQuedev + " AND PB4.PB4_FUNCAO = '3' AND PB4.PB4_META <> '2' "+cEnter // A Meta 2 esta dentro da 1 para o Venda
cQuedev := cQuedev + " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV)  "+cEnter
cQuedev := cQuedev + " BETWEEN  CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) "+cEnter
cQuedev := cQuedev + " AND   CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)  "+cEnter

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuedev),"DEV",.F.,.T.)
DbSelectArea("DEV")

While !DEV->(eof())
	
	@_nLin,000 PSAY 'DEVOLUCAO'
	@_nLin,010 PSAY SUBSTR(DEV->D1_EMISSAO,7,2)+"/"+SUBSTR(DEV->D1_EMISSAO,5,2)+"/"+SUBSTR(DEV->D1_EMISSAO,1,4)
	@_nLin,pCol()+2 PSAY DEV->D1_DOC
	@_nLin,pCol()+2 PSAY DEV->D1_SERIE
	
	nValDev := DEV->D1_QUANT * TMP->D2_PRCVEN
	@_nLin,pCol()+2 PSAY DEV->D1_COD
	@_nLin,pCol()+2 PSAY DEV->B1_DESC
	@_nLin,pCol()+2 PSAY (DEV->D1_QUANT * -1 )  Picture PesqPict("SD1","D1_QUANT")
	//	@_nLin,pCol()+2 PSAY (DEV->D1_TOTAL * -1 )  Picture PesqPict("SD1","D1_TOTAL")
	@_nLin,pCol()+2 PSAY (nValDev       * -1 )  Picture PesqPict("SD1","D1_TOTAL")
	_nLin := _nLin + 1
	
	_nTdevqt  := _nTdevqt  + DEV->D1_QUANT
	//	_nTdevlr  := _nTdevlr  + DEV->D1_TOTAL
	_nTdevlr  := _nTdevlr  + nValDev
	
	IF EMPTY(TMP->FUNCAO)
		_nTgdevqt := _nTgdevqt  + DEV->D1_QUANT
		//		_nTgdevlr := _nTgdevlr  + DEV->D1_TOTAL
		_nTgdevlr := _nTgdevlr  + nValDev
	Else
		_nTgdevqtAM := _nTgdevqtAM  + DEV->D1_QUANT
		//		_nTgdevlrAM := _nTgdevlrAM  + DEV->D1_TOTAL
		_nTgdevlrAM := _nTgdevlrAM  + nValDev
	Endif
	
	DbSelectArea("DEV")
	DBSKIP()
	
ENDDO
dbCloseArea()

RestArea(aArea)

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Roberto Mezzalira   º Data ³  11/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Cria perguntas no SX1                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Executado pela rotina principal                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±º          ³        ³      ³                                         	  º±±
±±º          ³        ³      ³                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

local j      := 0
local i      := 0
ssAlias      := Alias()
cPerg        := PADR(cPerg,len(sx1->x1_grupo))
aRegs        := {}

dbSelectArea("SX1")
dbSetOrder(1)


AADD(aRegs,{cPerg,"01","Data de       ?","Data       de ?","Data       de ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data ate      ?","Data      ate ?","Data      ate ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Grupo de      ?","Grupo      de ?","Grupo      de ?","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
AADD(aRegs,{cPerg,"04","Grupo ate     ?","Grupo     ate ?","Grupo     ate ?","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
AADD(aRegs,{cPerg,"05","Categoria de  ?","Categoria  de ?","Categoria  de ?","mv_ch5","C",04,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SZ6","","","","",""})
AADD(aRegs,{cPerg,"06","Categoria ate ?","Categoria ate ?","Categoria ate ?","mv_ch6","C",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SZ6","","","","",""})
AADD(aRegs,{cPerg,"07","Especie   de  ?","Especie    de ?","Especie    de ?","mv_ch7","C",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SZ7","","","","",""})
AADD(aRegs,{cPerg,"08","Especie   ate ?","Especie   ate ?","Especie   ate ?","mv_ch8","C",04,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SZ7","","","","",""})
AADD(aRegs,{cPerg,"09","Vendedor de   ?","Vendedor   de ?","Vendedor   de ?","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})
AADD(aRegs,{cPerg,"10","Vendedor ate  ?","Vendedor   ate?","Vendedor   ate?","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})

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