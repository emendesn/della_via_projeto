#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

//---------------- SOLICITAวรO DE COMPRAS
User Function SC_1       	// 1 - ENVIO DE EMAIL - PARA APROVACAO                        
	U_SC({'01',1})  

User Function SC_3       	// 3 - ENVIO DE EMAIL - APROVADO                        
	U_SC({'01',3})  
/*
User Function SC_4       	// 4 - ENVIO DE EMAIL - REPROVADO                        
	U_SC({'99',4})
*/

User Function SC( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => SC()")
		RETURN
	EndIf
	
   IF FindFunction('WFPREPENV')
		wfPrepENV( aParam[1], "01")
	ELSE
		Prepare Environment Empresa aParam[1] Filial '01'
	ENDIF
	                                                   
	CHKFILE("SM0")
	
	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(aParam[1],.F.)
	
	//U_CONSOLE('SC() /' + aParam[1] )
	
	WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1] 
		cFilAnt	:= SM0->M0_CODFIL
	
		//U_CONSOLE('SC() /' + aParam[1] + cFilAnt)
		
		U_WFSC(aParam[2])
		SM0->(DBSkip())
	END
	RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFSC      บAutor  ณBRUNO PAULINELLI    บ Data ณ  13/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 - ENVIO DE EMAIL - PARA APROVACAO                        บฑฑ
ฑฑบ          ณ 2 - RECEBE   EMAIL - RETORNO COM RESPOSTA DO EMAIL         บฑฑ
ฑฑบ          ณ 3 - ENVIO DE EMAIL - NOTIFICACAO DE APROVADO               บฑฑ
ฑฑบ          ณ 4 - ENVIO DE EMAIL - NOTIFICACAO DE REPROVADO              บฑฑ
ฑฑบ          ณ 5 - ENVIO DE EMAIL - NOTIFICACAO DE TIME-OUT               บฑฑ                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

cStatus  	:= ""
IF SC1->C1_SITUACA == 'A'
	cStatus := OemToAnsi("Solicita็ใo Aprovada")
endif
IF SC1->C1_SITUACA $ 'U|N'
	cStatus := OemToAnsi("Aguardando Libera็ใo")
endif
IF SC1->C1_SITUACA $ 'R'
	cStatus := OemToAnsi("Solicita็ใo Reprovada")
endif
IF SC1->C1_SITUACA $ 'C'
	cStatus := OemToAnsi("Solicita็ใo Cancelada")
endif

*/

User Function WFSC(_nOpc, oProcess)
Local _cIndex, _cFiltro, _cOrdem
Local _cOpcao, _cObs
Local _aAprov := {}
Local _cMails  := ''
Local _cGrupo

Private _cFILIAL := "", _cNum := "", _cCC := ""

ChkFile("SC1")
ChkFile("SA2")
ChkFile("SB1")
ChkFile("SBM")
ChkFile("SAL")
ChkFile("SAK")
ChkFile("SC1")
ChkFile("SB1")
ChkFile("SBM")
ChkFile("CTT")
ChkFile("SZZ")

DO CASE 

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ1 - ENVIO DE EMAIL PARA APROVACAO                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

	CASE _nOpc == 1

			//U_CONSOLE("1 - Envio de email para aprovacao")

		  	_cQuery := ""
		  	_cQuery += " SELECT DISTINCT "
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM,"   
		  	_cQuery += " C1_CC"   
		  	_cQuery += " FROM " + RetSqlName("SC1") + " SC1"
		  	_cQuery += " WHERE "
		  	_cQuery += "     C1_FILIAL = '" + xFilial("SC1") + "'"
		  	//_cQuery += " AND C1_SITUACA = 'N'"		// EM APROVACAO
		  	_cQuery += " AND C1_APROV = 'B'"            // BLOQUEADA NAO APROVADA
		  	_cQuery += " AND C1_WF = ' '"
		  	_cQuery += " AND SC1.D_E_L_E_T_ = ' '"
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C1_CC,"
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM" 

			TcQuery _cQuery New Alias "TMP"

			_cCC		:= ""
			                                 
			DBSelectArea("TMP")		
			dbGotop()
			While !TMP->(Eof())                                    
            
				IF TMP->C1_CC <> _cCC
					_cCC      	:= TMP->C1_CC              
					_cFILIAL	:= TMP->C1_FILIAL
					_cNUM		:= TMP->C1_NUM
					
					// APROVADOR X CENTRO DE CUSTO
					DBSelectArea("SZZ")
					DBSetOrder(1)
					DBSeek(xFilial("SZZ")+_cCC)
					
					//C. de Custo
					DBSelectArea("CTT")
					DBSetOrder(1)
					DBSeek(xFilial("CTT")+_cCC)
													                              
					EnviaSC(TMP->C1_CC, SZZ->ZZ_APROV, _nOpc)
				ENDIF
				_cCC := ""
				TMP->(DBSkip())
			END
			TMP->(dbCloseArea())

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ2 - RESPOSTA DOS EMAILดS ENVIADOS                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
	CASE _nOpc	== 2

			U_CONSOLE("2 - Resposta dos emails")
			U_CONSOLE("2 - Semaforo Vermelho" )
			
			nWFSC2 := U_Semaforo("WFSC2")

			cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
			cTo     	:= ALLTRIM(oProcess:aParams[2]) + ";" + ALLTRIM(oProcess:cTo)
			
			cNumSC     	:= oProcess:aParams[1]
			cWFID   	:= oProcess:fProcessId

			U_CONSOLE("2 - Num SC  :" + cNumSC)
			U_CONSOLE("2 - WFId    :" + cWFID)
			U_CONSOLE("2 - cTo     :" + cTo)
			U_CONSOLE("2 - cObs    :" + cObs)
			U_CONSOLE("2 - Len     :" + STR(LEN(oProcess:oHtml:RetByName("t.1"))))
	        
	        cOPC   := oProcess:oHtml:RetByName("OPC")
			
			FOR nInd := 1 TO LEN(oProcess:oHtml:RetByName("t.1"))
				cITEM  := oProcess:oHtml:RetByName("t.1")[nind]
			
				U_CONSOLE("2 - cItem   :" + cItem)
				U_CONSOLE("2 - cOpc    :" + cOpc)
							
				dbSelectArea("SC1")
				dbSetOrder(1)
				IF dbSeek( xFilial("SC1") + cNumSC + cItem)
					//IF cWFID == SC1->C1_WFID .AND. SC1->C1_SITUACA == 'N'  // NAO APROVADO
					IF cWFID == SC1->C1_WFID .AND. SC1->C1_APROV == 'B'  // NAO APROVADO     (BRUNO)
						RecLock("SC1",.F.)
						//SC1->C1_SITUACA	:= IIF(cOpc=="S", "A", "C")     (BRUNO)            
						SC1->C1_APROV	:= IIF(cOpc=="S", "L", "R") //LIBERADO OU REJEITADO (BRUNO)
						SC1->C1_OBS2	:= cOBS
 						SC1->C1_WF		:= '2'  // RECEBIDO A RESPOSTA
						MsUnlock()
					ENDIF
				ENDIF
			NEXT

			oProcess:Finish() // FINALIZA O PROCESSO


			cTitle:= "Confirmacao de Email / SC No."  + ALLTRIM(cNUMSC)

			aMsg	:= {}
			AADD(aMsg, Dtoc(MSDate()) + " - " + Time() )
			AADD(aMsg, "Confirmado o recebimento do email")
			AADD(aMsg, "Solicita็ใo de Compras No: " + ALLTRIM(cNUMSC) + " Filial : " + cFilAnt )
			
			//U_MailNotify(cTo, cTitle, aMsg)
         
			U_CONSOLE("2 - Semaforo Verde" )
			U_Semaforo(nWFSC2)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ3 - ENVIO de Email - Notificacao APROVADO             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	CASE _nOpc	== 3

			//U_CONSOLE("3 - Notificacao de Aprovado")
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Seleciona os registros do SCR - DBF / INDREGUA                         ณ
			//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		  	_cQuery := ""
		  	_cQuery += " SELECT DISTINCT "
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM,"   
		  	_cQuery += " C1_CC,"   
		  	_cQuery += " C1_USER"
		  	_cQuery += " FROM " + RetSqlName("SC1") + " SC1"
		  	_cQuery += " WHERE "
		  	_cQuery += "     C1_FILIAL = '" + xFilial("SC1") + "'"
		   //	_cQuery += " AND C1_SITUACA = 'A'"  							
		  	_cQuery += " AND C1_APROV = 'L'"                                    //APROVADO 
		  	_cQuery += " AND C1_WF <> '1'"      						    	// 1-Enviado Email
		  	_cQuery += " AND SC1.D_E_L_E_T_ = ' '"
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C1_CC,"
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM" 

			TcQuery _cQuery New Alias "TMP"

			_cCC		:= ""
			                                 
			DBSelectArea("TMP")		
			dbGotop()
			While !TMP->(Eof())                                    
            
				IF TMP->C1_CC <> _cCC
					_cCC      	:= TMP->C1_CC              
					_cFILIAL	:= TMP->C1_FILIAL
					_cNUM		:= TMP->C1_NUM
					
					// CENTRO DE CUSTO
					DBSelectArea("SZZ")
					DBSetOrder(1)
					DBSeek(xFilial("SZZ")+_cCC)
					
					//SOLICITANTE
					dbSelectArea("SAI")
					dbSetOrder(2)
					dbSeek(xFilial()+TMP->C1_USER)
					
					_cGrupo := SAI->AI_GRUPCOM
					
					//GRUPO DE COMPRA
					dbSelectArea("SAJ")
					dbSetOrder(1)
					dbSeek(xFilial()+_cGrupo)
					
					DBSelectArea("CTT")
					DBSetOrder(1)
					DBSeek(xFilial("CTT")+_cCC)
										 
					WHILE !SAJ->(EOF()) .AND. _cGrupo == SAJ->AJ_GRCOM 
							aadd(_aAprov,SAJ->AJ_USER)
						    SAJ->(DBSkip())                      
				    EndDO	 
			        
					For i:= 1 TO LEN(_aAprov) 
							_cMails += (UsrRetMail(ALLTRIM(_aAprov[i]))+";")
					Next                      
					
					EnviaSC(TMP->C1_CC, _cMails, _nOpc)
				
				ENDIF
				_aAprov := {}
				_cMails :=""
				_cCC := ""  
				TMP->(DBSkip())
			END
			TMP->(dbCloseArea())


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ4 - ENVIO de Email - Notificacao REPROVADO            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/  /*
	CASE _nOpc	== 4

			U_CONSOLE("4 - Notificacao de Reprovado")

		  	_cQuery := ""
		  	_cQuery += " SELECT DISTINCT "
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM,"   
		  	_cQuery += " C1_CC,"
		  	_cQuery += " C1_USER"   
		  	_cQuery += " FROM " + RetSqlName("SC1") + " SC1"
		  	_cQuery += " WHERE "
		  	_cQuery += "     C1_FILIAL = '" + xFilial("SC1") + "'"
		  	_cQuery += " AND C1_SITUACA = 'C'"  								// Cancelado
		  	_cQuery += " AND C1_WF <> '1'"      						    	// 1-Enviado Email
		  	_cQuery += " AND SC1.D_E_L_E_T_ = ' '"
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C1_CC,"
		  	_cQuery += " C1_FILIAL," 
		  	_cQuery += " C1_NUM" 

			TcQuery _cQuery New Alias "TMP"

			_cCC		:= ""
			                                 
			DBSelectArea("TMP")		
			dbGotop()
			While !TMP->(Eof())                                    
            
				IF TMP->C1_CC <> _cCC
					_cCC      	:= TMP->C1_CC              
					_cFILIAL	:= TMP->C1_FILIAL
					_cNUM		:= TMP->C1_NUM
					
					// CENTRO DE CUSTO
					DBSelectArea("SZZ")
					DBSetOrder(1)
					DBSeek(xFilial("SZZ")+_cCC)

					// CENTRO DE CUSTO
					DBSelectArea("CTT")
					DBSetOrder(1)
					DBSeek(xFilial("CTT")+_cCC)
					                              
					// APROVADOR
					dbSelectArea("SAK")
					dbSetOrder(1)
					dbSeek(xFilial()+SZZ->ZZ_APROV)
					
					EnviaSC(TMP->C1_CC, TMP->C1_USER, _nOpc)
				ENDIF
				_cCC := ""  //INCLUSO POR BRUNO 22/07/05
				TMP->(DBSkip())
			END
			TMP->(dbCloseArea())
    */
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ5 - ENVIO de Email - Notificacao TIME-OUT             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/  /*
	CASE _nOpc	== 5

		U_CONSOLE("5 - TimeOut" )
		nWFSC5 		:= U_Semaforo("WFSC5")
                            
		_cNum      	:= oProcess:aParams[1]
		_cSubject	:= oProcess:cSubject
		_cEmail  	:= oProcess:cTo       

		oProcess:Finish() // FINALIZA O PROCESSO        

		ConfirmaSC1(" ")

		_cTitle	:= "TimeOut - " + _cSubject

		_aMsg	:= {}
		AADD(_aMsg, Dtoc(MSDate()) + " - " + Time() )
		AADD(_aMsg, "Aprova็ใo de Solicitacao de Compras [Time-Out]")
		AADD(_aMsg, "O prazo de resposta expirou em " + DTOC(dDatabase) + " as " + LEFT(TIME(),5))
		AADD(_aMsg, "Desconsidere o email anterior para responder.")
		AADD(_aMsg, "Aguarde o pr๓ximo email para responder.")
			
		U_MailNotify(_cEmail, _cTitle, _aMsg)
           
		U_CONSOLE("5 - Semaforo Verde" )
		U_Semaforo(nWFSC5)
*/				
END CASE			

		
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVIASC   บAutor  ณBRUNO PAULINELLI    บ Data ณ  13/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ_cWF ' ' - Envia email para aprovador                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaSC(_cCC, _cUser, _nOpc)
//-------------------------------------
//------------------- VALIDACAO
Local _cAprov  // (Bruno)
    
    If _nOpc == 3
    	_cTo := _cUser
    Else	
		_cTo := UsrRetMail(_cUser)
    EndIf
                            
	IF EMPTY(_cTo)
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		
		_aMsg := {}
		AADD(_aMsg, Dtoc(MSDate()) + " - " + Time() )
		AADD(_aMsg, "Ocorreu um ERRO no envio da mensagem :")
		AADD(_aMsg, "Solicitacao de Compra No: " + _cNum + " Filial : " + cFilAnt + " Centro Custo : " + _cCC )
		IF EMPTY(_cUser)
			AADD(_aMsg, "Usuแrio nใo Cadastrado" )
		ELSE 
			AADD(_aMsg, "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" )
		ENDIF
		
		U_NotifyAdm(cTitle, _aMsg)

		ConfirmaSC1("1",,_nOpc)
		RETURN Nil
	ENDIF

//--------------------- ABERTURA DE ARQUIVOS

	// DADOS DA FILIAL
	dbSelectArea('SM0')
	dbSetOrder(1)
	dbSeek( cEmpAnt + cFilAnt)

	// SOLICITACAO DE COMPRAS
	DBSelectArea("SC1")
	DBSetOrder(1)
	DBSeek(xFilial("SC1")+_cNum)

	_cToUser		:= UsrRetMail(SC1->C1_USER)   // (Bruno)
              
	DO CASE 
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao
			oProcess          	:= TWFProcess():New( "000001", "SC-Envio para Aprovacao :" + _cFilial + "/" +  TRIM(_cNum) )
			oProcess          	:NewTask( "Envio SC : "+_cFilial + _cNum, "\WORKFLOW\HTML\SC\SCAprov.HTM" )
			oProcess:cSubject 	:= "Aprovacao de Despesas  SC-No. " + _cFilial + "/" +  _cNum
			oProcess:bReturn  	:= "U_WFSC(2)" 
			//oProcess:bTimeOut 	:= { { "U_WFSC(5)", GetNewPar("MV_WFTODD", 1), GetNewPar("MV_WFTOHH", 0), GetNewPar("MV_WFTOMM", 0) } }
			
		CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
			oProcess          	:= TWFProcess():New( "000002", "SC-Envia Notificacao ao usuario  :" + _cFilial + "/" +  TRIM(_cNum) )
			oProcess          	:NewTask( "Envio resposta Aprovado SC-No. "+_cFilial + _cNum, "\WORKFLOW\HTML\SC\SCResp.HTM" )
			oProcess:cSubject 	:= "Resposta Aprovacao de Despesas SC-No. " + _cFilial + "/" +  _cNum
			_cResposta				:= " A P R O V A D O "
		/*								
		CASE _nOpc == 4		// Envio de email Reprovado para solicitante
			oProcess          	:= TWFProcess():New( "000003", "SC-Envia Notificacao ao usuario  :" + _cFilial + "/" +  TRIM(_cNum) )
			oProcess          	:NewTask( "Envio resposta Reprovado SC-No. "+_cFilial + _cNum, "\WORKFLOW\HTML\SC\SCResp.HTM" )
			oProcess:cSubject 	:= "Resposta Aprovacao de Despesas SC-No. " + _cFilial + "/" +  _cNum
			_cResposta				:= "<font color='#FF0000'>R E P R O V A D O </font>"
		*/		
	ENDCASE
                                       
	
	oProcess:cTo      	:= _cTo
	oProcess:UserSiga	:= SC1->C1_USER
	oProcess:NewVersion(.T.)

	// OBJETO OHTML                   
  	oHtml     			:= oProcess:oHTML

	// CABEวALHO 
	//oHtml:ValByName( "M0_NOME"      , SM0->M0_NOME)    	// FILIAL                   
	oHtml:ValByName( "C1_FILIAL"	, SM0->M0_FILIAL )		
	oHtml:ValByName( "C1_NUM"   	, SC1->C1_NUM )					// NUMERO DA SOLICITACAO
	oHtml:ValByName( "C1_SOLICIT"   , SC1->C1_SOLICIT )				// QUEM SOLICITOU
	oHtml:ValByName( "C1_EMISSAO"   , DTOC(SC1->C1_EMISSAO) )		// EMISSAO
	oHtml:ValByName( "C1_USER"   	, UsrFullName(SC1->C1_USER) ) // USUARIO QUE INCLUI A SOLICITACAO
	oHtml:ValByName( "C1_CC"     	, CTT->CTT_CUSTO   + '-' + CTT->CTT_DESC01)
	
	_cAprov := UsrFullName(SZZ->ZZ_APROV)
	
	oHtml:ValByName( "ZZ_APROV"     	, _cAprov)                             
	
	While ! SC1->(EOF()) .AND. SC1->C1_FILIAL == xFilial("SC1") .AND. SC1->C1_NUM == _cNum
		IF SC1->C1_CC == _cCC
		    /*
			IF _nOpc == 3
				IF !SC1->C1_SITUACA = 'A'
					SC1->(DBSkip())
					Loop
				ENDIF
			ENDIF                                   (BRUNO)

			IF _nOpc == 4
				IF !SC1->C1_SITUACA = 'C'
					SC1->(DBSkip())
					Loop
				ENDIF
			ENDIF
			*/
			IF _nOpc == 3
				IF !SC1->C1_APROV = 'L'
					SC1->(DBSkip())
					Loop
				ENDIF
			ENDIF

			IF _nOpc == 4
				IF !SC1->C1_APROV = 'R'
					SC1->(DBSkip())
					Loop
				ENDIF
			ENDIF
			
			DBSelectArea("SB1")
			DBSetOrder(1)
			DBSeek(xFilial("SB1")+SC1->C1_PRODUTO)
		
			DBSelectArea("SBM")
			DBSetOrder(1)
			DBSeek(xFilial("SBM")+SB1->B1_GRUPO)
	
			AAdd( (oHtml:ValByName( "t.1"    )), SC1->C1_ITEM)
			AAdd( (oHtml:ValByName( "t.2"    )), SC1->C1_PRODUTO + '-' +ALLTRIM(SB1->B1_DESC))
			AAdd( (oHtml:ValByName( "t.3"    )), SC1->C1_UM)
			AAdd( (oHtml:ValByName( "t.4"    )), DTOC(SC1->C1_DATPRF))
			AAdd( (oHtml:ValByName( "t.5"    )), SC1->C1_LOCAL)
	   //	AAdd( (oHtml:ValByName( "t.6"    )), SC1->C1_CONTA)
			AAdd( (oHtml:ValByName( "t.7"    )), Transform(SC1->C1_QUANT,PesqPict("SC1","C1_QUANT",14,1)))
			AAdd( (oHtml:ValByName( "t.8"    )), ALLTRIM(SC1->C1_OBS))  
		
			IF _nOpc == 1
		              oHtml:ValByName( "OBS"     	, "")                            
	        ENDIF
	
	        IF _nOpc == 3 .OR. _nOpc == 4
	                  oHtml:ValByName( "mensagem" , _cResposta)	 
	                  oHtml:ValByName( "OBS"     	, SC1->C1_OBS2)                            	
	        ENDIF      
		
		ENDIF
						
		SC1->(DBSkip())
	END

	IF _nOPC == 1
			  (oHtml:ValByName("OPC"), "")
	ENDIF    

	aAdd( oProcess:aParams, _cNum)				 
	aAdd( oProcess:aParams, _cToUser)                     			
	
	oProcess:nEncodeMime := 0
	oProcess:Start()    
	
	ConfirmaSC1("1",oProcess:fProcessID, _nOpc)
    
	return NIL
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบROTINA  ณConfirmaSC1                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿     
cStatus
Branco - Preparado para enviar
1	   - Envio com sucesso 
*/
Static Function ConfirmaSC1(cStatus, cProcesso, nOpc)
        
IF cProcesso == Nil
	cProcesso := ""
ENDIF

IF nOpc == Nil
	nOpc := 0
ENDIF

dbSelectArea("SC1")     // LOOP DOS ITENS
dbSetOrder(1)
dbSeek(xFilial("SC1")+_cNUM)

while !SC1->(EOF()) .AND. SC1->C1_FILIAL  =  xFilial("SC1") ;
					.AND. SC1->C1_NUM     = _cNUM  
					
	IF SC1->C1_CC == _cCC					
		/*    
		IF nOpc == 3
			IF !SC1->C1_SITUACA = 'A'
				SC1->(DBSkip())
				Loop
			ENDIF
		ENDIF

		IF nOpc == 4
			IF !SC1->C1_SITUACA = 'C'
				SC1->(DBSkip())
				Loop
			ENDIF
		ENDIF
		*/
		IF nOpc == 3
			IF !SC1->C1_APROV = 'L'
				SC1->(DBSkip())
				Loop
			ENDIF
		ENDIF

		IF nOpc == 4
			IF !SC1->C1_APROV = 'R'
				SC1->(DBSkip())
				Loop
			ENDIF
		ENDIF
	
		RECLOCK("SC1",.F.)
		SC1->C1_WF		:= cStatus
		SC1->C1_WFID    := cProcesso
		MSUNLOCK()	                     
	ENDIF
			
	SC1->(dbSkip())
ENDDO   
RETURN Nil	