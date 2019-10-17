
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA650A  º Autor ³ Jader              º Data ³  23/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na confirmacao da alteracao da OP.        º±±
±±º          ³ Usado para disparar o Job de envio de aprovacao de SEPU    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol - Alterado contemplar Programacao da Producao      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA650A()

Local _aAliasAnt := GetArea()
Local _cObs1,_cObs2,_cObs3,_lOk

If SM0->M0_CODIGO == "03"   // So executa para Durapol
	//Nao executa para chamada pela producao
	If ! IsInCallStack("U_DESTA01")
	    //-- grava campos memos especificos
	    
		_cObs1 := M->C2_XOBS1
		MSMM(SC2->C2_XCOBS1,80,,_cObs1,1,,,"SC2","C2_XCOBS1")
	
		_cObs2 := M->C2_XOBS2
		MSMM(SC2->C2_XCOBS2,80,,_cObs2,1,,,"SC2","C2_XCOBS2")
	
		_cObs3 := M->C2_XOBS3
		MSMM(SC2->C2_XCOBS3,80,,_cObs3,1,,,"SC2","C2_XCOBS3")
	
		//-- verifica se a profundidade aferida esta preenchida
		If SC2->C2_XPROFAF > 0
	
	    	//-- verifica se ja foi enviado 
			If SC2->C2_XWFSEPU == "S"
				_lOk := MsgYesNo("E-mail para aprovacao do SEPU ja enviado. Deseja enviar novamente e reiniciar o processo?","Confirmacao")
			Else
				_lOk := .T.
			Endif		
	
			//-- faz chamada do job para envio do e-mail para aprovacao do SEPU   
			If _lOk
				U_WSEPU01()
	        Endif
	
	        //-- atualiza que foi enviado o e-mail de aprovacao de SEPU
			dbSelectArea("SC2")
			RecLock("SC2",.F.)
				SC2->C2_XWFSEPU := "S"	
			MsUnlock()		        
		Endif
	Else
		IF Select("TMP") > 0
			TMP->( dbCloseArea("TMP") )		
		EndIF
	
		_cQry := "SELECT MAX(ZM_NUMLOTE) LOTEMAX " 	  
		_cQry += " FROM " + RetSqlName("SZM") + " SZM "
		_cQry += " WHERE ZM_FILIAL = '" + xFilial("SZM")+"' AND SZM.D_E_L_E_T_ = '' "
		_cQry := ChangeQuery(_cQry)
	
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TMP",.F.,.T.)
	
		dbSelectArea("TMP")
		dbGotop()
	
		While !Eof()
	
			cLote := TMP->LOTEMAX
			
			Exit
		EndDo
	
		SZM->( dbSetOrder(1) )
		IF SZM->( dbSeek(xFilial("SZM") + cLote ) )
			//--OP em Terceiro / OP Rejeitada e nao for alteracao direta na OP
			IF ! M->C2_X_STATU $ '7/9'
				IF SZM->ZM_QTDLOTE < 22 .And. Empty(SZM->ZM_STATUS) //Qtd. Max. do Lote
					Reclock("SZM")
						IF Empty(SC2->C2_XNUMLOT) //Lote Final
							IF SZM->ZM_QTDLOTE + 1 == 22
								SZM->ZM_STATUS := "E" //Encerrado pela sua totalidade, P=Parcialmente fechado autoclave
							EndIF
							SZM->ZM_QTDLOTE := SZM->ZM_QTDLOTE + 1
						EndIF	
					MsUnlock()  
					cOrdem := Trim(StrZero(SZM->ZM_QTDLOTE,2))
					dbSelectArea("SC2")
					Reclock("SC2")
						SC2->C2_XNUMLOT := cLote //Lote Final
						SC2->C2_X_ORDEM := cOrdem
					MsUnlock()	
				Else
					cLotePro := SOMA1(cLote)
					dbSelectArea("SZM")
				
					Reclock("SZM",.T.)
						SZM->ZM_FILIAL := xFilial("SZM")
						SZM->ZM_NUMLOTE:= cLotePro //Lote Final					
						SZM->ZM_X_HRINI:= Time()   //Hora Inicial
						SZM->ZM_X_DTINI:= dDatabase
						SZM->ZM_QTDLOTE:= 1
					MsUnlock()
		
					cOrdem := Trim(StrZero(SZM->ZM_QTDLOTE,2))
			
					dbSelectArea("SC2")
					Reclock("SC2")
						SC2->C2_XNUMLOT := cLotePro //Lote Final
						SC2->C2_X_ORDEM := cOrdem
					MsUnlock()	
					//MsgAlert("Esta Ordem de Producao devera ser excluida deste lote, pois este ja se encontra encerrado")	
				EndIF		
			Else
				MsgAlert("Esta Ordem de producao nao ira compor o saldo do lote " + SC2->C2_XNUMLOT +",pois encontra-se Rejeitada,em Terceiro")	
				M->C2_X_STATU := "1" 
			EndIF
		Else		
			cLotePro := SOMA1(cLote)
			msgInfo("Criando lote de producao " + cLotePro + " ")
			dbSelectArea("SZM")
			Reclock("SZM",.T.)
				SZM->ZM_FILIAL := xFilial("SZM")
				SZM->ZM_NUMLOTE:= cLotePro
				SZM->ZM_QTDLOTE:= 1
				SZM->ZM_X_HRINI:= Time()   //Hora Inicial
				SZM->ZM_X_DTINI:= dDatabase	
			MsUnlock()
			
				cOrdem := Trim(Strzero(SZM->ZM_QTDLOTE,2))
			
			dbSelectArea("SC2")
			Reclock("SC2")
				SC2->C2_XNUMLOT := cLotePro
				SC2->C2_X_ORDEM := cOrdem
			MsUnlock()					
		EndIf
	EndIf
Endif

RestArea(_aAliasAnt)

Return(NIL)

