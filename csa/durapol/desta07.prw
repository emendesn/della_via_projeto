#Include 'rwmake.ch'
#Include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DESTA07  ³ Autor ³ Reinaldo Caldas       ³ Data ³01.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina realizacao da programacao da producao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Durapol                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DESTA07x(nOpc)
                         
Local cQuery        := ""
Local oGetDe,oGetAte,oGetRod,oGetAutc,oGetTri,oGetNRod,oPesq
Local _nX
Local aObjects := {}
Local aSize    := {}
Local aInfo    := {}
Local aPosObj  := {}
Local _aPos    := {}

//-- GetDados
Private aHeader	    := {}
Private aCols		:= {}
Private	aRecno      := {}
//-- Outras variaveis
Private nOpx        := nOpc
Private dDataDe     := CtoD("")
Private dDataAte    := CtoD("")
Private cAutoClave  := Space(2)
Private cTrilho     := Space(1)
Private cRodada     := Space(5)
Private cBico       := Space(2)
Private aRegs       := {}
Private cPerg       := "ESTA07"
Private cCadastro   := "Programacao da Producao"
Private oDlgEsp,oMult     
Private aC       := {}
Private aR       := {}
Private _aCampos := {}
Private aCGD     := {44,05,118,315}

//-- cria grupo de perguntas no SX1
aRegs:={}

AAdd(aRegs,{cPerg,"01","Da Entrega ?"   ,"Producao De?"   ,"Producao De?"   ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Ate Entrega?"   ,"Producao Ate?"  ,"Producao Ate?"  ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"03","Data Coleta de?","Data Coleta de"   ,"Data Coleta de?" ,"mv_ch3","D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"04","Data Coleta Ate?","Data Coleta Ate?","Data Coleta Ate?","mv_ch4","D", 8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

IF nOpx == 3

	//-- faz pergunta
	Pergunte(cPerg,.T.)
	dDataDe  := mv_par01
	dDataAte := mv_par02
	                                                                                                      
	AAdd( aHeader, { "Ord", "CBICO", "99",  2, 0, "U_VldBico(cBico)" , , "C", , } )
	AAdd( _aCampos, "CBICO" )

	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC2")
	
	While !Eof() .And. SX3->X3_ARQUIVO == "SC2"
		If SX3->X3_BROWSE == "S" .And. SX3->X3_CONTEXT <> "V"
			If AllTrim(X3_CAMPO) == "C2_NUM"
				AAdd( aHeader, { "Num.OP", SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			Elseif AllTrim(X3_CAMPO) == "C2_ITEM"
				AAdd( aHeader, { "It", SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			Elseif AllTrim(X3_CAMPO) == "C2_X_STATU"
				AAdd( aHeader, { "St", SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			Elseif AllTrim(X3_CAMPO) == "C2_SERIEPN"
				AAdd( aHeader, { "Serie PN", SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			Elseif AllTrim(X3_CAMPO) == "C2_NUMFOGO"
				AAdd( aHeader, { "N. Fogo", SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			Elseif AllTrim(X3_CAMPO) == "C2_EMISSAO"
				AAdd( aHeader, { "Emissao", SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			Else
				AAdd( aHeader, { SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE,  SX3->X3_TAMANHO, SX3->X3_DECIMAL, ".F." , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			Endif
			AAdd( _aCampos, SX3->X3_CAMPO )
		Endif
		dbSkip()
	Enddo
	
	nUsado := Len(aHeader)
	
	//-- posicona neste campo que e' visual para nao pemitir a alteracao dos campos do acols
	dbSetOrder(2)
	MsSeek("C2_XNREDUZ")
	
	For _nX:=2 To Len(aHeader)
		aHeader[_nX,2] := SX3->X3_CAMPO
	Next
	dbSetOrder(1)
	
	IF Select( "TRBSC2" )>0
		dbSelectArea("TRBSC2") 
		dbCloseArea()
	Endif


	cQuery := "SELECT * FROM " + RetSqlName("SC2")+ " SC2 "
	cQuery += " WHERE C2_FILIAL = '" + xFilial('SC2') + "' "
	cQuery += "   AND C2_DATPRF >= '" + DtoS(mv_par01) + "' "        
	cQuery += "   AND C2_DATPRF <= '" + DtoS(mv_par02) + "' "        
	cQuery += "   AND C2_EMISSAO >= '" + DtoS(mv_par03) + "' "
	cQuery += "   AND C2_EMISSAO <= '" + DtoS(mv_par04) + "' "
	cQuery += "   AND C2_X_STATU = '1' "
	cQuery += "   AND C2_QUANT <> C2_QUJE "
	cQuery += "   AND C2_XPRELOT = '' "
	cQuery += "   AND SC2.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY C2_DATPRF,C2_XNREDUZ,C2_PRIOR, C2_PRODUTO, C2_SERVPCP, C2_X_DESEN, C2_NUM, C2_ITEM "
	cQuery := ChangeQuery( cQuery )

	dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), "TRBSC2", .F., .F. )
	
	dbGoTop()

	aCols  := {}

	While !Eof()                 

		AAdd( aCols, Array( Len( aHeader ) + 1 ) )
	
		aCols[Len( aCols ), 1 ] := Space(2)
		
		For _nX:=1 To Len(_aCampos)
			If _aCampos[_nX]<>"CBICO"        
				If aHeader[_nX,8]=="D" 
					_cCampo := "STOD(TRBSC2->"+Alltrim(_aCampos[_nX])+")"
				Else
					_cCampo := "TRBSC2->"+Alltrim(_aCampos[_nX])
				Endif	
				aCols[Len( aCols ), _nX ] := &(_cCampo)
				IF nOpx <> 3 .and. _nX == 1
					_cCampo2 := &("TRBSC2->"+Alltrim(_aCampos[2]))
					_cCampo3 := &("TRBSC2->"+Alltrim(_aCampos[3]))
					_cCampo4 := &("TRBSC2->"+Alltrim(_aCampos[4]))
					_cCampo5 := &("TRBSC2->"+Alltrim(_aCampos[5]))
					_cCampo6 := &("TRBSC2->"+Alltrim(_aCampos[6]))
					aAdd(aRecno,{aCols[Len( aCols ), _nX ],_cCampo2,_cCampo3,_cCampo4,_cCampo5,_cCampo6,REGISTRO})
				EndIF
			Endif	
		Next
	    
		aCols[Len( aCols ),Len( aHeader ) + 1] := .F.
		
		dbSelectArea("TRBSC2")
		dbSkip() 
	
	EndDo	

	TRBSC2->( dbCloseArea() )
	
	aRecno := ASort(aRecno,,,{|x,y| x[1]<y[1]})
	
	If Empty( aCols )
		Aadd( aCols, Array( Len( aHeader ) + 1 ) )
		For _nX:=1 To Len(aHeader)
			If aHeader[_nX,8] == "C"
				xConteudo := Space(aHeader[_nX,4])
			ElseIf aHeader[_nX,8] == "N"
				xConteudo := 0
			ElseIf aHeader[_nX,8] == "D"
				xConteudo := CtoD("")
			Else
				xConteudo := ""	
			Endif
			aCols[Len( aCols ), _nX ] := xConteudo
		Next	
		aCols[1,Len(aHeader)+1] := .F.
	EndIf
	
	dbSelectArea("SC2")
	
Else
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SZL")
	
	While !Eof() .And. SX3->X3_ARQUIVO == "SZL"
		//SX3->X3_BROWSE == "S" .And. SX3->X3_CONTEXT <> "V" .and. !AllTrim(SX3->X3_CAMPO)$"ZL_NUMLOTE"
		IF cNivel >= SX3->X3_NIVEL  .and. !AllTrim(SX3->X3_CAMPO)$"ZL_FILIAL/ZL_NUMLOTE"
			AAdd( aHeader, { SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE,;
							 SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VLDUSER, SX3->X3_USADO,;
							 SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			AAdd( _aCampos, SX3->X3_CAMPO )
		
		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if AllTrim(SX3->X3_CAMPO)="ZL_NUMLOTE"
				cNumLote := Space(6)
				aAdd(aC,{"cNumLote",{25,10},Alltrim(SX3->X3_TITULO),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_F3,.F.})
			endif

		EndIF
		SX3->(dbSkip())
	Enddo
	
	nUsado := Len(aHeader)
		
	dbSetOrder(1)
	dbSelectArea("SZL")
	
	IF Select( "TRBSC2" )>0
		dbSelectArea("TRBSC2") 
		dbCloseArea()
	Endif
	
    cNumLote := SZL->ZL_NUMLOTE
    
	cQuery := "SELECT ZL_NUMLOTE, ZL_NUMOP, ZL_X_ORDEM, R_E_C_N_O_ REGISTRO , ZL_EMISSAO, ZL_DTENTRE, ZL_CLIENTE, ZL_X_HRINI "
	cQuery += " FROM " + RetSqlName("SZL")+ " SZL "
	cQuery += " WHERE ZL_FILIAL = '" + xFilial('SZL') + "' "
	cQuery += "   AND ZL_NUMLOTE = '" + cNumLote + "' "
	cQuery += "   AND SZL.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY ZL_NUMLOTE, ZL_X_ORDEM, ZL_NUMOP "
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), "TRBSC2", .F., .F. )
	
	dbGotop()
	aCols :={}
	aRecno:={}
	
	do While !Eof() 
		aAdd(aCols,Array(nUsado+1))
		For _ni :=1  To nUsado
			aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))		//FieldPut(FieldPos(aHeader[_ni,2]),aCols[Len(aCols),_ni])
		Next _ni
		aCols[Len(aCols),nUsado+1 ] := .F.
		//aAdd(aRecno, REGISTRO)
		aAdd(aRecno,{'',TRBSC2->ZL_NUMOP,'','','','',REGISTRO})
		dbSkip()
	Enddo
	
	dbSelectArea("SZL")
		
	cLinhaOk := "U_ZGLINOK()"
	cTudoOk  := "U_ZGTUDOK()"
	lRetMod2 := Modelo2(cCadastro,aC,aR,aCGD,nOpx)
	
	IF lRetMod2
		IF nOpx == 4 //Alteracao
			// Aproveitando os registros ja gravados
			For _i := 1 to Len(aRecno)
				lDel := .F.
				dbGoTo(aRecno[_i,7])
				RecLock("SZL",.F.)
				
				if !aCols[_i,Len(aHeader)+1]	// Considerar somente vetores nao excluidos
				  	For _k := 1 to Len(aHeader)
				  		FieldPut(FieldPos(aHeader[_k,2]),aCols[_i,_k])
					Next
				else
					lDel   := .T.
					dbDelete()
				endif
				MsUnlock()
				IF lDel
					SC2->( dbSetOrder(1) )
					SC2->( dbSeek(xFilial("SC2") + aRecno[_i,2] ) ) 
					RecLock("SC2",.F.)
			    		SC2->C2_XNUMLOT := ""
			    		SC2->C2_XPRELOT := ""
			    		SC2->C2_PRIOR   := "500"
			    		SC2->C2_X_ORDEM := ""  //Ordem que esta acomodada no Lote
			    		SC2->C2_X_HRINI := ""  //Horario do planejamento do lote
						SC2->C2_XDTLOTE := CTOD("")
					MsUnlock()
					dbSelectArea("SZM")
					SZM->( dbSetOrder(1) )
					IF SZM->( dbSeek(xFilial("SZM") + SC2->C2_XNUMLOT ) )
						RecLock("SZM",.F.)
							IF SZM->ZM_QTDLOTE == 22
								SZM->ZM_STATUS := ""
								SZM->ZM_X_HRFIM := ""
							EndIF
				    		SZM->ZM_QTDLOTE := SZM->ZM_QTDLOTE -1
						MsUnlock()
					EndIF
                EndIF
			Next
			
			// No caso de terem sido incluidos novos registros
			For _i := Len(aRecno) + 1 to Len(aCols)
				
				if !aCols[_i,Len(aHeader)+1]	// Considerar somente vetores nao excluidos
					
					RecLock("SZL",.T.)
					SZL->ZL_FILIAL	:= xFilial("SZL")
					SZL->ZL_NUMLOTE := cNumLote					
				  	For _k := 1 to Len(aHeader)
					  	FieldPut(FieldPos(aHeader[_k,2]),aCols[_i,_k])
					Next
					MsUnlock()
					
				endif
			
			Next
		ElseIF nOpx == 5 //Exclusao
			For _i := 1 to Len(aRecno)
				dbSelectArea("SZL")
				dbGoTo(aRecno[_i,7])
				RecLock("SZL")
					dbDelete()
				MsUnlock()
				SC2->(dbSetOrder(1))
				SC2->(dbSeek(xFilial("SC2") + aRecno[_i,2] ) ) //Verificar
				
				RecLock("SC2")
		    		SC2->C2_XNUMLOT := ""
		    		SC2->C2_XPRELOT := ""
			    	SC2->C2_PRIOR   := "500"
		    		SC2->C2_X_ORDEM := ""  //Ordem que esta acomodada no Lote
		    		SC2->C2_X_HRINI := ""  //Horario do planejamento do lote
					SC2->C2_XDTLOTE := CTOD("")
				MsUnlock()
				dbSelectArea("SZM")
				dbSetOrder(1)
				IF SZM->( dbSeek(xFilial("SZM") + SC2->C2_XNUMLOT ) )
					RecLock("SZM")
						IF SZM->ZM_QTDLOTE == 22
							SZM->ZM_STATUS := ""
							SZM->ZM_X_HRFIM := ""
						EndIF
				   		SZM->ZM_QTDLOTE := SZM->ZM_QTDLOTE -1
					MsUnlock()
				EndIF
			Next
		EndIF
	EndIF
	
EndIF

IF nOpx == 3 //Inclusao da programacao - Exame
    //Gera Numeracao automatica
   	cNumRodada  := NumProg()
   	
	//-- Calcula as dimensoes dos objetos
	aSize  := MsAdvSize(.T.)

	AAdd( aObjects, { 100,40,.T.,.T. } )
	AAdd( aObjects, { 100,60,.T.,.T. } )

	aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4], 0, 0 }
	aPosObj:= MsObjSize( aInfo, aObjects, .T. )

	_aPos := {}
	AAdd(_aPos,aPosObj[1,1]-12)
	AAdd(_aPos,aPosObj[1,2])
	AAdd(_aPos,aPosObj[1,3]-113.6)
	AAdd(_aPos,aPosObj[1,4]-445.7)
	
	@ aSize[7]+20,00 TO aSize[6]-20,aSize[5]-50 DIALOG oDlgEsp TITLE cCadastro
			
		@ _aPos[1]+10,08 SAY "Entrega De" PIXEL OF oDlgEsp SIZE 70,7
		@ _aPos[1]+10,40 MSGET oGetDe VAR dDataDe PICTURE "@D" WHEN .F. PIXEL OF oDlgEsp SIZE 20,7
	
		@ _aPos[1]+10,85 SAY "Ate" PIXEL OF oDlgEsp SIZE 70,7
		@ _aPos[1]+10,100 MSGET oGetAte VAR dDataAte PICTURE "@D" WHEN .F. PIXEL OF oDlgEsp SIZE 20,7
	
		@ _aPos[1]+25,08 SAY "Programacao " PIXEL OF oDlgEsp SIZE 75,7
		@ _aPos[1]+25,45 MSGET oGetNRod VAR cNumRodada  PICTURE "999999" WHEN .F. PIXEL OF oDlgEsp SIZE 20,7 //VALID ! Empty(cNumRodada)
	
		@ _aPos[1]+25,75 SAY "Inicio Programacao" PIXEL OF oDlgEsp SIZE 90,7
		@ _aPos[1]+25,125 MSGET oGetRod VAR cRodada  PICTURE "99:99" VALID ! Empty(cRodada) WHEN .T. PIXEL OF oDlgEsp SIZE 8,7
	
	
		@ aPosObj[2,1]-45, aPosObj[2,2] TO aPosObj[2,3]-40, aPosObj[2,4]-23 MULTILINE MODIFY VALID U_LINOK() FREEZE 1 OBJECT oMult
	
		@aPosObj[ 2, 3 ]-35, aPosObj[ 2, 4 ]-200 BUTTON oPesq PROMPT '&Pesquisar' SIZE 42,12 PIXEL ACTION DESTA02c()
		DEFINE SBUTTON FROM aPosObj[2,3]-35, aPosObj[2,4]-130 TYPE 1 ENABLE OF oDlgEsp ACTION If(DESTA02a(),Close(oDlgEsp),NIL)
		DEFINE SBUTTON FROM aPosObj[2,3]-35, aPosObj[2,4]-80  TYPE 2 ENABLE OF oDlgEsp ACTION If(DESTA02b(),Close(oDlgEsp),NIL)
	
	ACTIVATE DIALOG oDlgEsp CENTERED
	
EndIF

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DESTA02a ³ Autor ³ Reinaldo              ³ Data ³02.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para gravacao dos dados na OP                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DESTA02a()
        
Local _lRet := .F.

If MsgYesNo("Confirma gravacao da ordem da Inspeção(Exame)?","Confirmação")

	_lRet := .T.

	Processa({|| GravaSC2()},"Gravando dados na OP...")
Endif	

Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GravaSC2 ³ Autor ³ Jader                 ³ Data ³01.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para gravacao dos dados na OP                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaSC2()
                        
Local _nX,_cNum,_cItem,_cSeq,_cBico,_cMarca

ProcRegua(Len(aCols))

For _nX:=1 To Len(aCols)

	_cBico  := aCols[_nX,AScan(_aCampos,"CBICO")]
	_cNum   := aCols[_nX,AScan(_aCampos,"C2_NUM")]
	_cItem  := aCols[_nX,AScan(_aCampos,"C2_ITEM")]
	_cSeq   := aCols[_nX,AScan(_aCampos,"C2_SEQUEN")]
	
	If ! Empty(_cBico) .And. ! Empty(_cNum)

		IncProc("Gerando Pré-lote... "+_cNum+_cItem+_cSeq)
		
		dbSelectArea("SC2")
		dbSetOrder(1)
		MsSeek(xFilial("SC2")+_cNum+_cItem+_cSeq)
	
	    If ! Eof()
	    	RecLock("SC2",.F.)
	    		SC2->C2_PRIOR   := _cBico    //Ordem que as OP's deverao ser inspecionadas
	    		SC2->C2_X_HRINI := cRodada   //Horario do planejamento do lote
	    		SC2->C2_XPRELOT := cNumRodada //Pre-Lote
				SC2->C2_XDTLOTE := dDataBase //Data da gravacao do lote
	    	MsUnlock()
	    Endif
	    //Gravar SZL
	    
	    dbSelectArea("SZL")
	    RecLock("SZL",.T.)
	    	SZL->ZL_FILIAL  := xFilial("SZL")
	    	SZL->ZL_X_ORDEM := _cBico    //Ordem que as OP's deverao ser inspecionadas
	    	SZL->ZL_NUMOP   := _cNum+_cItem+_cSeq
	    	SZL->ZL_NUMLOTE := cNumRodada //Pre-Lote
			SZL->ZL_EMISSAO := dDataBase //Data da gravacao do lote
			SZL->ZL_CLIENTE := Trim(SC2->C2_XNREDUZ)
			SZL->ZL_DTENTRE := SC2->C2_DATPRF
			SZL->ZL_X_HRINI := cRodada
	  	MsUnlock()
	   	dbSelectArea("SC2")
	   	
    Endif

Next

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DESTA02b ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para cancelamento dos dados digitados               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DESTA02b()

Local _lRet := .F.


If MsgYesNo("Os dados digitados serão perdidos. Confirma?","Confirmação")
	_lRet := .T.
	RollBackSX8()
Endif

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DESTA02c ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para pesquisar OP                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DESTA02c()

Local oDlgPesq,oGetOP
Local _nPos
Local _npOP := AScan(_aCampos,"C2_NUM")
Local _npIt := AScan(_aCampos,"C2_ITEM")
Local _cOp  := Space(6)
Local _cIt  := Space(2)

DEFINE MSDIALOG oDlgPesq TITLE OemToAnsi("Pesquisar") From 12,10 To 17,40 OF oMainWnd

@ 5,08 SAY "Ordem de Serviço" PIXEL OF oDlgPesq SIZE 70,7
@ 5,55 MSGET oGetOP VAR _cOP  PICTURE "@!" PIXEL OF oDlgPesq SIZE 15,7

@ 5,87 SAY "Item" PIXEL OF oDlgPesq SIZE 70,7
@ 5,98 MSGET oGetOP VAR _cIt  PICTURE "@!" PIXEL OF oDlgPesq SIZE 15,7
	
DEFINE SBUTTON FROM 22,85 TYPE 1 ACTION Close(oDlgPesq) ENABLE OF oDlgPesq

ACTIVATE MSDIALOG oDlgPesq CENTERED

_nPos := AScan(aCols,{|x| x[_npOP]+x[_npIt]==_cOP+_cIt})

If _nPos <> 0
	oMult:oBrowse:nAt := _nPos
Endif	

oMult:Refresh()

Return

User Function ZGLinOk()

Local _nX
Local _lRet  := .T.
Local _nPos  := AScan(_aCampos,"ZL_X_ORDEM")
Local _cBico := aCols[n,_nPos]
Local _cOP   := aCols[n,AScan(_aCampos,"ZL_NUMOP")]

If ! Empty(_cBico) .And. Empty(_cOP)
	MsgStop("Novas linhas não podem ser incluidas.","Atenção")
	ADel(aCols,n)
	aCols:=ASize(aCols,n-1)
	n:=n-1
Endif    

For _nX:=1 To Len(aCols)
	If ! Empty(_cBico) .and. aCols[_nX,_nPos] == _cBico 
		IF  _nX <> n .And. !Acols[_nX][nUsado+1]
			MsgStop("Ordem do lote já digitado. Verifique.","Atenção")
			_lRet := .F.
			Exit
		EndIF	
	Endif
Next
	
Return(_lRet)	

User Function ZGTudOk()
Local _lRet := .T.

Return(_lRet)

Static Function NumProg

Local cLote := ""

IF Select("TMP") > 0
	TMP->( dbCloseArea("TMP") )
EndIF

_cQry := "SELECT MAX(ZL_NUMLOTE) LOTEMAX "
_cQry += " FROM " + RetSqlName("SZL") + " SZL "
_cQry += " WHERE ZL_FILIAL = '" + xFilial("SZL")+"' AND SZL.D_E_L_E_T_ = '' "
_cQry := ChangeQuery(_cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TMP",.F.,.T.)

dbSelectArea("TMP")
dbGotop()

While !Eof()
	cLote := TMP->LOTEMAX
	Exit
EndDo
cLote := Strzero(Val(cLote)+1,6)

Return(cLote)