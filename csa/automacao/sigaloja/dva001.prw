#INCLUDE "RwMake.CH"     
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DVA001    ºAutor  ³Edmar/Marcelo Gasparº Data ³  23/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Correção da Base de Dados da Della Via Pneus               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Rotina executada via menu                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Esta rotina foi desenvolvida para corrigir o calculo de PISº±±
±±º          ³ e COFINS das notas fiscais do Sigaloja. Pois o Modulo      º±±
±±º          ³ Sigaloja nao calculou estes campos na rotina padrao.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via Pneus                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION DVA001()

Private lBlind	:= IsBlind()
Private cPerg := "DVA01"
Private nAliqPis := 0
Private nAliqCof := 0
Private nValPis  := 0
Private nValCof  := 0
Private nTotPis  := 0
Private nTotCof  := 0
Private nTotBas  := 0
Private nX       := 0 // Nao sei para que serve, mas a MaFisRet utiliza.
Private _nCont   := 0	                                                           


If lBlind

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SF2","SD2","SB1"


	MV_PAR01 := "01"
	MV_PAR02 := "99"
	MV_PAR03 := Ctod("01/10/05")
	MV_PAR04 := Ctod("31/12/06")
	
	DVAPROC01()

Else	

	If MsgNoYes("Confirma reprocessamento do PIS/COFINS das notas nao calculadas pelo sistema padrão","Atenção !!")
		Pergunte(cPerg,.T.)
		Processa({|| DVAProc01()}, "Corrigindo base de PIS e Cofins...")
		MsgAlert("Fim do processamento!")
	EndIf
	
Endif	

RETURN

STATIC FUNCTION DVAPROC01()                        

cQuery := "SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO FROM " + RetSqlName("SF2") + " SF2 "
cQuery += "WHERE "
cQuery += "SF2.F2_FILIAL BETWEEN '" + Mv_par01 + "' And '"+ Mv_par02 +"' And "
cQuery += "SF2.F2_EMISSAO BETWEEN '" + Dtos(Mv_par03) + "' And '"+ Dtos(Mv_par04) +"' And "
cQuery += "SF2.D_E_L_E_T_=' ' "
cQuery += "ORDER BY F2_FILIAL, F2_EMISSAO, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

While !Eof()

	DbSelectArea("SF2")
	DbSetOrder(1)
	DbSeek(TMP->F2_FILIAL+TMP->F2_DOC+TMP->F2_SERIE+TMP->F2_CLIENTE+TMP->F2_LOJA)

/*	If !lBlind
		IncProc("Analisando NF "+SF2->F2_DOC+" "+SF2->F2_SERIE)
	Endif	
	
	IF SF2->F2_EMISSAO < MV_PAR03 .AND. SF2->F2_EMISSAO > MV_PAR04
		SF2->(DbSkip())
		Loop
	ENDIF                                               
*/	
	IF (SF2->F2_TIPO $ 'B/D')
		TMP->(DbSkip())
		Loop
	ENDIF

	If !lBlind
		IncProc("Atualizando NF "+SF2->F2_DOC+" "+SF2->F2_SERIE+" "+DTOC(SF2->F2_EMISSAO))
	Endif	

	nTotPis := 0
	nTotCof := 0
	nTotBas := 0
	
	If MaFisFound("NF")
		MaFisEnd()
		MaFisIni( SF2->F2_CLIENTE, SF2->F2_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701" )
	Else
		MaFisIni( SF2->F2_CLIENTE, SF2->F2_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701" )	
	Endif

    nX := 0	
	DbSelectArea("SD2")
	DbSetOrder(3)                         
	DbGoTop()
	DbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	While SD2->(!Eof()) .AND. SF2->F2_DOC == SD2->D2_DOC .AND. SF2->F2_SERIE == SD2->D2_SERIE .AND.;
		SF2->F2_CLIENTE == SD2->D2_CLIENTE .AND. SF2->F2_LOJA == SD2->D2_LOJA
		
		nX++
/*		
		If SD2->D2_VALIMP5 < 0
			MsgBox("Valor Cofins < Zero "+SD2->D2_FILIAL+" "+SD2->D2_DOC+" "+SD2->D2_SERIE)			
		Endif	
*/		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+SD2->D2_COD)
		
		DbSelectArea("SD2")
		
		If MaFisFound("NF")                    
		
			If SD2->D2_DESCON > 0
				_nValDesc	:= SD2->D2_DESCON
				RecLock("SD2",.F.)
				SD2->D2_DESCON := 0
				MsUnlock()                    
			Else
				_nValDesc	:= 0
			Endif	
		
			MaFisAdd( SD2->D2_COD,;	// Produto
			SD2->D2_TES   ,;		// Tes
			SD2->D2_QUANT ,;		// Quantidade
			SD2->D2_PRCVEN,; 		// Preco unitario
			SD2->D2_DESCON,;		// Valor do desconto
			"",; 					// Numero da NF original
			"",; 					// Serie da NF original
			Nil,;					// Recno da NF original
			0,; 					// Valor do frete do item
			0,; 					// Valor da despesa do item
			0,; 					// Valor do seguro do item
			0,; 					// Valor do frete autonomo
			SD2->D2_TOTAL,;        // Valor da mercadoria
			0,;						// Valor da embalagem
			SB1->( RecNo() ))						

			nBasePis := MaFisRet(nX,"IT_BASEPS2")
			nValPis  := MaFisRet(nX,"IT_VALPS2")
			nAliqPis := MaFisRet(nX,"IT_ALIQPS2")

			nBaseCof := MaFisRet(nX,"IT_BASECF2")
			nValCof  := MaFisRet(nX,"IT_VALCF2")
			nAliqCof := MaFisRet(nX,"IT_ALIQCF2")
			
			nValCSLL := MaFisRet(nX,"IT_VALCSL")          
 /*			                    
			If nValPis = 0 .and. nBasePis > 0
				nValPis	:= (nBasePis * (nAliqPis / 100))
			Endif	
			
			If nValCof = 0 .and. nBaseCof > 0
				nValCof	:= (nBaseCof * (nAliqCof / 100))
			Endif	
*/			
			RecLock("SD2",.F.)
/*			
			If nValCof	< 0
				MsgBox("Valor Cofins < Zero "+SD2->D2_FILIAL+" "+SD2->D2_DOC+" "+SD2->D2_SERIE)			
				Exit
			Endif
*/				
			SD2->D2_BASIMP5 	:= nBaseCof
			SD2->D2_ALQIMP5 	:= nAliqCof
			SD2->D2_VALIMP5  	:= nValCof              
			
			SD2->D2_BASIMP6 	:= nBasePis
			SD2->D2_ALQIMP6 	:= nAliqPis
			SD2->D2_VALIMP6  	:= nValPis
			
			If _nValDesc > 0
				SD2->D2_DESCON		:= _nValDesc
			Endif	
			
			MsUnlock()
			
			Conout("NF"+SF2->F2_DOC+" "+SF2->F2_SERIE+" Pis:"+Str(SD2->D2_VALIMP6,10,2)+" Cofins:"+Str(SD2->D2_VALIMP5,10,2))
			_nCont += 1
		ENDIF
		
		DbSelectArea("SD2")
		SD2->(Dbskip())
	EndDo
	
	DbSelectArea("TMP")

	DbSkip()

EndDo

Conout("Total de registros alterados "+Str(_nCont,6))          

RETURN
