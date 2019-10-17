#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
                        

//---------------- RETORNO E ENVIO

User Function Ret
	U_RECMAIL({'01'})

User Function Send
	U_SENDMAIL({'01'}) 
	
User Function JobWorkflow
	WFOnstart()	

//------------------------------------------------------------------------
// ENVIO DE EMAIL
//------------------------------------------------------------------------

USER FUNCTION SENDMAIL(aParam)
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => SENDMAIL(cEmp)" )
		RETURN
	EndIf
	
	U_CONSOLE('SENDMAIL() /' + aParam[1] )
	
	WFSENDMAIL({aParam[1],"01"})
	RETURN

//------------------------------------------------------------------------
// RETORNO DO WORKFLOW
//------------------------------------------------------------------------

USER FUNCTION RECMAIL( aParam )
	IF aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => RECMAIL()")
		RETURN
	EndIf
	
	U_CONSOLE('RECMAIL() /' + aParam[1] )
	
	WFReturn({aParam[1],"01"})
	RETURN

//------------------------------------------------------------------------
// SEMAFORO
//------------------------------------------------------------------------
                    
USER FUNCTION SEMAFORO(Params)
Local nHdl 	:= 0                  
Local cFile := ""

    IF Params == Nil .OR. ! ValType(Params) $ "N|C" 
    	U_CONSOLE("SEMAFORO - Parametro invalido")
    	RETURN
    ENDIF            

	IF VALTYPE(Params) == "C"	// Quando for caracter - fecha o semaforo
		cFile := TRIM(Params) + ".LCK"
		       
		IF !FILE(cFile)
			nHdl:=MSFCREATE(cFile,0)
			fClose(nHdl)
		ENDIF
			
		While .T.
			nHdl := FOPEN(cFile , 16)
			IF nHdl > 0
			   	EXIT
			ENDIF			    
		    
			SLEEP(5000)
		END
	ENDIF
	
	IF VALTYPE(Params) == "N"	// Quando for numerico - abre o semaforo
		fClose(Params)
	ENDIF
	
	RETURN IIF(nHdl <> 0, nHdl, Nil)
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MAAlcDoc Autor ณ BRUNO PAULINELLI       ณ  Data ณ27.06.05  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ MAAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA1 = Array com informacoes do documento                 ณฑฑ
ฑฑณ          ณ       [1] Numero do documento                              ณฑฑ
ฑฑณ          ณ       [2] Tipo de Documento                                ณฑฑ
ฑฑณ          ณ       [3] Valor do Documento                               ณฑฑ
ฑฑณ          ณ       [4] Codigo do Aprovador                              ณฑฑ
ฑฑณ          ณ       [5] Codigo do Usuario                                ณฑฑ
ฑฑณ          ณ       [6] Grupo do Aprovador                               ณฑฑ
ฑฑณ          ณ       [7] Aprovador Superior                               ณฑฑ
ฑฑณ          ณ       [8] Moeda do Documento                               ณฑฑ
ฑฑณ          ณ       [9] Taxa da Moeda                                    ณฑฑ
ฑฑณ          ณ      [10] Data de Emissao do Documento                     ณฑฑ
ฑฑณ          ณ      [11] Grupo de Compras                                 ณฑฑ
ฑฑณ          ณ ExpD1 = Data de referencia para o saldo                    ณฑฑ
ฑฑณ          ณ ExpN1 = Operacao a ser executada                           ณฑฑ
ฑฑณ          ณ       1 = Inclusao do documento                            ณฑฑ
ฑฑณ          ณ       2 = Estorno do documento                             ณฑฑ
ฑฑณ          ณ       3 = Exclusao do documento                            ณฑฑ
ฑฑณ          ณ       4 = Aprovacao do documento                           ณฑฑ
ฑฑณ          ณ       5 = Estorno da Aprovacao                             ณฑฑ
ฑฑณ          ณ       6 = Bloqueio Manual da Aprovacao                     ณฑฑ
ฑฑณ          ณ ExpC1 = Respondido a 1 Vez ou a 2						  		  ณฑฑ
ฑฑณ          ณ ExpB1 = Chamado via Menu do Sistema .T. or .F.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAAlcDoc(aDocto,dDataRef,nOper, lTimeOut)
	Local cDocto	:= aDocto[1]
	Local cTipoDoc	:= aDocto[2]
	Local nValDcto	:= aDocto[3]
	Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
	Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
	Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
	Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
	Local aArea		:= GetArea()
	Local aAreaSCS  := SCS->(GetArea())
	Local aAreaSCR  := SCR->(GetArea())
	Local nSaldo	:= 0
	Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
	Local lFirstNiv:= .T.
	Local cAuxNivel:= ""
	Local cNextNiv := ""
	Local lAchou	:= .F.
	Local nRec		:= 0
	Local lRetorno	:= .T.
	Local aSaldo	:= {}
	dDataRef 	:= dDataBase
	cDocto 		:= cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
	lTimeOut	:= IF(lTimeOut==Nil, .F. , lTimeOut)

	CHKFile("SAK")
	CHKFile("SC7")
	CHKFile("SCR")
	CHKFile("SCS")
	CHKFile("SAL")
			
	If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
		cUsuario :=	AK_USER
		nMoeDcto :=	AK_MOEDA
		nTxMoeda	:=	0
	EndIf
	If nOper == 1  //Inclusao do Documento
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAL")
		dbSetOrder(2)
		If !Empty(cGrupo) .And. dbSeek(xFilial()+cGrupo)
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
	  		 	If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) .AND. !EMPTY(cWF)
					dbSelectArea("SAL")
					dbSkip()
					Loop
				EndIf
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO := aDocto[10]
		   		SCR->CR_MOEDA	:=	nMoeDcto
		    	SCR->CR_TXMOEDA := nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 3  //exclusao do documento
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial()+cGrupo+SAK->AK_COD)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Reposiciona o usuario aprovador.               ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				dbSelectArea("SAK")
				dbSeek(xFilial()+SCR->CR_LIBAPRO)
				If SAL->AL_LIBAPR == "A" .and. MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) 
					dbSelectArea("SCS")
					dbSetOrder(2)
					If dbSeek(xFilial()+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
						MsUnlock()
					EndIf
				EndIf
			EndIf

			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	EndIf
	
	If nOper == 4 //Aprovacao do documento
	
		U_CONSOLE(" 4 -Aprovacao ")
		
		dbSelectArea("SCS")
		dbSetOrder(2)
		aSaldo 		:= MaSalAlc(cAprov,dDataRef,.T.)
		nSaldo 		:= aSaldo[1]
		dDataRef	:= aSaldo[3]
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza o saldo do aprovador.                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
		
		dbSelectArea("SAL")
		dbSetOrder(3)
		dbSeek(xFilial()+cGrupo+cAprov)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Libera o pedido pelo aprovador.                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SCR")
		cAuxNivel := CR_NIVEL

		U_CONSOLE(" 4 -Aprovacao - CR STATUS = 03")
		
		Reclock("SCR",.F.)
		CR_STATUS	:= "03"
		CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
		CR_DATALIB	:= dDataBase
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		CR_VALLIB	:= nValDcto
		CR_TIPOLIM	:= SAK->AK_TIPO
		MsUnlock()
		
		
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		      
		nRec := SCR->(RecNo()) 
		
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
				Exit
			EndIf
			/*
			Liberacao por Nivel e Pedido terao o mesmo tratamento. 
			Serao aprovados todos os itens que pertencam ao mesmo nivel
			*/
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_DATALIB	:= dDataBase
				CR_USERLIB	:= SAK->AK_USER
				CR_APROV	:= cAprov
				MsUnlock()
				
			EndIf 
			If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
				lAchou 	:= .T.
				cNextNiv := CR_NIVEL
			EndIf
			
			/*
			Agora eh feita a gravacao de qual eh o proximo aprovador a ser notificado
			*/
			If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
				Reclock("SCR",.F.)
				CR_STATUS	:= "02"
				IF (SAL->AL_TPLIBER=="P" .AND. !lTimeOut )
					CR_STATUS	:= "05"
					CR_DATALIB	:= dDataBase
					CR_USERLIB	:= SAK->AK_USER
					CR_APROV	:= cAprov
					CR_OBS		:= "Aprovado por " + UsrRetName(SAK->AK_USER)
				ENDIF			
				MsUnlock()
			Endif
			dbSkip()
		EndDo
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Reposiciona e verifica se ja esta totalmente liberado.       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    
		dbSelectArea("SCR")
		dbGoto(nRec)
		While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
			If CR_STATUS != "03" .And. CR_STATUS != "05" 
				lRetorno := .F.
			EndIf
			dbSkip()
		EndDo
        
   
        If SAL->AL_LIBAPR == "A" //.and. MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
			dbSelectArea("SCS")
			If dbSeek(xFilial()+cAprov+dToS(dDataRef))
				Reclock("SCS",.F.)
			Else
				Reclock("SCS",.T.)
			EndIf
			CS_FILIAL:= xFilial("SCS")
			CS_SALDO	:= CS_SALDO - nValDcto
			CS_APROV	:= cAprov
			CS_USER		:= cUsuario
			CS_MOEDA	:= nMoeDcto
			CS_DATA		:= dDataRef
			MsUnlock()
		   
		    /*	                       
			// LIBERA OS NIVEIS SUPERIORES QUANDO FOR APROVADO COM ALวADAS
			dbSelectArea("SCR")
			dbGoto(nRec)
			While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
				IF SCR->CR_USER <> SAK->AK_USER  // ADICIONADO ESTA LINHA
					RECLOCK("SCR",.F.)
					CR_STATUS	:= "05"
					CR_DATALIB	:= dDataBase
					CR_USERLIB	:= SAK->AK_USER
					CR_APROV	:= cAprov
					CR_OBS		:= "2.Aprovado por " + UsrRetName(SAK->AK_USER)
					MsUnlock()
				ENDIF
				dbSkip()
			EndDo
			lRetorno := .T.	// LIBERA APROVACAO POIS O APROVADOR TEM SALDO PARA ISSO
	    */
		EndIf
	EndIf
	If nOper == 5  //Estorno da Aprovacao
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAK")
		dbSetOrder(1)
		
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		
		nMoeDcto := SCR->CR_MOEDA
		nTxMoeda := SCR->CR_TXMOEDA
		
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Reposiciona o usuario aprovador.               ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				dbSelectArea("SAK")
				dbSeek(xFilial()+SCR->CR_LIBAPRO)
		
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial()+cGrupo+SAK->AK_COD)
				If SAL->AL_LIBAPR == "A" .and. MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) 
					dbSelectArea("SCS")
					dbSetOrder(2)
					If dbSeek(xFilial()+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
						If SCS->CS_SALDO > SAK->AK_LIMITE
							SCS->CS_SALDO := SAK->AK_LIMITE
						EndIf
						MsUnlock()
					EndIf
				EndIf
			EndIf

			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	
		dbSelectArea("SAL")
		dbSetOrder(2)
		If !Empty(cGrupo) .And. dbSeek(xFilial()+cGrupo)
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
				If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) 
					dbSelectArea("SAL")
					dbSkip()
					Loop
				EndIf
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO:= dDataRef
			   	SCR->CR_MOEDA	:=	nMoeDcto
		    	SCR->CR_TXMOEDA:= nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 6  //Bloqueio manual

		U_CONSOLE("  6  - Bloqueio por " + cAprov)

		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
			
		dbSelectArea("SCR")
		cAuxNivel := CR_NIVEL
		
		Reclock("SCR",.F.)
		CR_STATUS   := "04"
		CR_OBS	   	:= If(Len(aDocto)>10,aDocto[11],"Reprova็ao manual")
		CR_DATALIB  := dDataBase
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		MsUnlock()

		cNome		:= UsrRetName(SAK->AK_USER)
				
		dbSelectArea("SCR")                       
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		      
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO  
		    U_CONSOLE(" 6 - Bloqueio - LOOP SCR " + CR_FILIAL+CR_NUM+CR_TIPO + CR_NIVEL + CR_STATUS )
		    
			If (CR_NIVEL==cAuxNivel .And. CR_STATUS != "04" ) 
				Reclock("SCR",.F.)
				CR_STATUS	:= "04"
				CR_DATALIB	:= dDataBase
				CR_USERLIB	:= SAK->AK_USER
				CR_OBS		:= "Reprovado por " + ALLTRIM(cNome)
				MsUnlock()
			EndIf
			dbSkip()
		EndDo
		
		lRetorno := .F.
	EndIf
	
	dbSelectArea("SCR")
	RestArea(aAreaSCR)

	dbSelectArea("SCS")
	RestArea(aAreaSCS)
	RestArea(aArea) 
	Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSOLE   บAutor  ณBRUNO PAULINELLI    บ Data ณ  27/06/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 
ฑฑบ          ณ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Console(_ctxt, _cNome, _lOK)
	
	if _cNome == NIL
		_cNome := 'conout.log'
	endif

	if _ctxt == NIL
		_ctxt := 'nulo'
	endif

	CONOUT(_cTXT + ' ' + DTOC(MSDATE()) + ' ' + TIME())

	IF _lOK == NIL	
		_lOK := .F.
	ENDIF
	
	IF _lOK
	   nHdl2:= FOPEN(_cNome,2)
         IIF(nHdl2 > 0,,nHdl2:=MSFCREATE(_cNome,0))
   	   fseek(nHdl2,0,2)
	
	   _cLogBody := ''
	   _cLogBody += DTOC(DATE()) +" @ "+ TIME() +" "+ _cTxt + chr(13) + chr(10)
	   Fwrite(nHdl2,_cLogBody,len(_cLogBody))
	
	   _cLogBody := replicate('-',80) + chr(13) + chr(10)
	   Fwrite(nHdl2,_cLogBody,len(_cLogBody))
	
	   FCLOSE(nHdl2)
      ENDIF
	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNotifyAdm บAutor  ณMicrosiga           บ Data ณ  08/15/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณUtilizado para enviar qualquer notificacao ao administrador บฑฑ
ฑฑบ          ณdo Siga.     															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION NotifyAdm(cTitle, aMsg)
Local oWf, nInd, cBody

IF aMsg == Nil
	aMsg := {}
	AADD(aMsg, "") 
EndIf 

	cBody := ''
	cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
	cBody += 'size=2><STRONG>MP8 Workflow - Servi็o Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'
	For nInd := 1 TO Len(aMsg)
		cBody += '<DIV><FONT face=Verdana color=#000080 size=3><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
	Next
	
	oWF := TWFObj()
	oWF:oMail:NotifyAdmin('Administrador',cTitle, cBody)
	RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMailNotifyบAutor  ณMicrosiga           บ Data ณ  08/15/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณUtilizado para enviar qualquer notificacao                  บฑฑ
ฑฑบ          ณdo Siga.      											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP87                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
USER FUNCTION MailNotify( cTo, cSubject, aMsg, aFiles )
Local oMsg, oMail, oWF := TWFObj(), nInd, cBody
                                                            
IF cTo == Nil 
	RETURN .F.
EndIf 
IF cSubject == Nil 
	cSubject := ""
EndIf 
IF aMsg == Nil
	aMsg := {}
	AADD(aMsg, "") 
EndIf 

IF aFiles == Nil
	aFiles := {}
EndIf 

cBody := ''
cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
cBody += 'size=3><STRONG>Ap7 Workflow - Servi็o Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'
For nInd := 1 TO Len(aMsg)
	cBody += '<DIV><FONT face=Verdana color=#000080 size=2><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
Next

oMail := oWF:oMail
oMsg := oMail:oSmtpSrv:oMsg
oMsg:cFrom := oMail:cAddress
oMsg:cTo := AllTrim( cTo )
oMsg:cSubject := AllTrim( cSubject )
oMsg:cBody := cBody
 
if Len( aFiles ) > 0
  AEval( aFiles, { |x| if( file( x ), oMsg:AttachFile( x ),nil ) } )
end
 
oMail:oSmtpSrv:Send( oMail )
Return nil
*/