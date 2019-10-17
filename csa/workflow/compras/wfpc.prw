#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

User Function PC_1       	// 1 - ENVIO DE EMAIL - PARA APROVACAO                        
	U_PC({'01',1})  

User Function PC_3       	// 1 - ENVIO DE EMAIL - APROVADO                        
	U_PC({'01',3})  

User Function PC_4       	// 1 - ENVIO DE EMAIL - REPROVADO                        
	U_PC({'01',4}) 

User Function PC( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => PC()")
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
	
	//U_CONSOLE('PC() /' + aParam[1] )
	
	WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1] 
		cFilAnt	:= SM0->M0_CODFIL
	
		//U_CONSOLE('PC() /' + aParam[1] + cFilAnt)
		
		U_WFPC(aParam[2])
		SM0->(DBSkip())
	END
	RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFPC-PEDIDO DE COMPRAS                 บ Data ณ  27/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 - ENVIO DE EMAIL PARA APROVADORES                       บฑฑ
ฑฑบ          ณ 2 - RETORNO DE EMAIL COM RESPOSTA DE APROVADORES           บฑฑ
ฑฑบ          ณ 3 - ENVIA RESPOSTA DE PEDIDO APROVADO  PARA O COMPRADOR	  บฑฑ
ฑฑบ          ณ 4 - ENVIA RESPOSTA DE PEDIDO REPROVADO PARA O COMPRADOR	  บฑฑ
ฑฑบ          ณ 5 - ENVIO DE EMAIL - NOTIFICACAO DE TIME-OUT               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WFPC(_nOpc, oProcess)
Local _cIndex, _cFiltro, _cOrdem
Local _cFilial, _cOpcao, _cObs

Local nSaldo 		:= 0 , 	nSalDif 	:= 0  ,	cTipoLim  	:= ""
Local aRetSaldo 	:={} ,	cAprov    	:= "" , cObs 		:= ""
Local nTotal    	:= 0 , 	cGrupo	 	:= "" , lLiberou	:= .F.


ChkFile("SE4")
ChkFile("SC1")
ChkFile("SC8")
ChkFile("SA2")
ChkFile("SB1")
ChkFile("SBM")
ChkFile("SCR")
ChkFile("SC7")
ChkFile("SAL")
ChkFile("SCS")                    
ChkFile("SAK")                    
ChkFile("SM2")                    


DO 	CASE 

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ1 - Prepara os pedidos a serem enviados para aprovacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

	CASE _nOpc == 1

			//U_CONSOLE("1 - Prepara os pedidos a serem enviados para aprovacao")
			//U_CONSOLE("1 - EmpFil:" + cEmpAnt + cFilAnt)

		  	_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_TIPO,"   
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL," 
		  	_cQuery += " CR_TOTAL," 
		  	_cQuery += " CR_USER,"   
		  	_cQuery += " CR_APROV"   
		  	
		  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
		  	_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND CR_FILIAL = '" + cFilAnt + "'"
		  	_cQuery += " AND CR_TIPO = 'PC'"
		  	_cQuery += " AND CR_STATUS = '02'"  								// Em aprovacao
		  	_cQuery += " AND CR_WF = ' '"
		  	
		  	_cQuery += " ORDER BY"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL,"
		  	_cQuery += " CR_USER"
		  	
			TcQuery _cQuery New Alias "TMP"
		
			dbGotop()
			While !TMP->(Eof())
            
				DBSelectArea("SC7")
				DBSetOrder(1)
				DBSeek(xFilial("SC7")+PADR(ALLTRIM(TMP->CR_NUM),6))

				IF EMPTY(SC7->C7_APROV)
					DBSelectarea("SCR")
					DBSetOrder(3)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= "1" 		 	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= "N/D"		   // Rastreabilidade
						MSUnlock()
					ENDIF	
				ELSE 				
					_aWF	 		:= EnviaPC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV) , TMP->CR_TOTAL, _nOpc)
					
					DBSelectarea("SCR")
					DBSetOrder(3)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= _aWF[1]		// Rastreabilidade
						MSUnlock()     
					ENDIF
				ENDIF
				
				TMP->(DBSkip())           
			End
			
			dbSelectArea("TMP")
			dbCloseArea()

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ2 - Processa O RETORNO DO EMAIL                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
	CASE _nOPC	== 2

			U_CONSOLE("2 - Processa O RETORNO DO EMAIL")
			U_CONSOLE("2 - EmpFil:" + cEmpAnt + cFilAnt)

			U_CONSOLE("2 - Semaforo Vermelho" )
			nWFPC2 		:= U_Semaforo("WFPC2")

			cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
			cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
			cTo   		:= SUBS( alltrim(oProcess:cRetFrom), AT('<',alltrim(oProcess:cRetFrom)) + 1 , LEN(alltrim(oProcess:cRetFrom))-AT('<',alltrim(oProcess:cRetFrom))-1 )   			

			cChaveSCR  	:= oProcess:aParams[1]
			cWFID   	:= oProcess:fProcessId

			oProcess:Finish() // FINALIZA O PROCESSO

			U_CONSOLE("2 - Chave   :" + cChaveSCR)
			U_CONSOLE("2 - Opc     :" + cOpc)
			U_CONSOLE("2 - Obs     :" + cObs)
			U_CONSOLE("2 - WFId    :" + cWFID)
			U_CONSOLE("2 - cTo     :" + cTo)

			IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			
				// Posiciona na tabela de Alcadas 
				DBSelectArea("SCR")
				DBSetOrder(3)
				DBSeek(cChaveSCR)
				
				IF !FOUND() .OR. TRIM(SCR->CR_WFID) <> TRIM(cWFID)
					//"Este processo nao foi encontrado e portanto deve ser descartado
					// abre uma notificacao a pessoa que respondeu
					
					U_CONSOLE("2 - Processo nao encontrado :" + cWFID + " Processo atual :" + SCR->CR_WFID)
					U_CONSOLE("2 - Semaforo Verde" )
					U_Semaforo(nWFPC2)
					Return .T.
				ENDIF
				
				Reclock("SCR",.F.)
				SCR->CR_WF		:= "2"			// Status 2 - respondido
				MSUnlock()

				If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
					U_CONSOLE("2 - Processo ja respondido via sistema :" + cWFID)
					U_CONSOLE("2 - Semaforo Verde" )
					U_Semaforo(nWFPC2)
					Return .T.
				EndIf

				// Verifica se o pedido de compra esta aprovado
				// Se estiver, finaliza o processo
				dbSelectArea("SC7")
				dbSetOrder(1)
				dbSeek(xFilial()+Alltrim(SCR->CR_NUM))

				IF SC7->C7_CONAPRO <> "B"  // NAO ESTIVER BLOQUEADO
					U_CONSOLE("2 - Processo ja respondido via sistema :" + cWFID)
					U_CONSOLE("2 - Semaforo Verde" )
					U_Semaforo(nWFPC2)
					Return .T.
				ENDIF

				// REPosiciona na tabela de Alcadas 
				DBSelectArea("SCR")
				DBSetOrder(3)
				DBSeek(cChaveSCR)
				
				// verifica quanto a saldo de al็ada para aprova็ใo				
				// Se valor do pedido estiver dentro do limite Maximo e minimo 
				// Do aprovador , utiliza o controle de saldos, caso contrแrio nao
				// faz o tratamento como vistador.

				lLiberou := U_MaAlcDoc( {SCR->CR_NUM,"PC",SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))
				
				U_CONSOLE("2 - Liberado :" + IIF(lLiberou, "Sim", "Nao"))

				If lLiberou
					dbSelectArea("SC7")
					dbSetOrder(1)
					dbSeek(xFilial()+Alltrim(SCR->CR_NUM))
			        While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == SCR->CR_FILIAL+TRIM(SCR->CR_NUM)
		                Reclock("SC7",.F.)
		                SC7->C7_CONAPRO 	:= "L"
		                MsUnlock()
		                dbSkip()
			        EndDo
				EndIf

				cTitle:= "Confirmacao de Email / Pedido de Compra No."  + ALLTRIM(SCR->CR_NUM)

				aMsg	:= {}
				AADD(aMsg, Dtoc(MSDate()) + " - " + Time() )
				AADD(aMsg, "Confirmado o recebimento do email")
				AADD(aMsg, "Pedido de Compra No: " + ALLTRIM(SCR->CR_NUM) + " Filial : " + cFilAnt + " Status : " + IIF(cOpc == "S", "Aprovado", "Reprovado"))
			
				//U_MailNotify(cTo, cTitle, aMsg)
			EndIf				

			U_CONSOLE("2 - Semaforo Verde" )
			U_Semaforo(nWFPC2)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ3 - Envia resposta de pedido aprovado para o compradorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

	CASE _nOpc == 3

			//U_CONSOLE("3 - Envia resposta de pedido APROVADO para o comprador")
			//U_CONSOLE("3 - EmpFil:" + cEmpAnt + cFilAnt)

		  	_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " C7_FILIAL," 
		  	_cQuery += " C7_NUM,"
		  	_cQuery += " C7_ITEM,"    
		  	_cQuery += " C7_USER"   
		  	
		  	_cQuery += " FROM " + RetSqlName("SC7") + " SC7"
		  	_cQuery += " WHERE SC7.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND C7_FILIAL   = '" + cFilAnt + "'"
			_cQuery += " AND C7_TIPO=1      "									// 1-Pedido de compra
			_cQuery += " AND C7_CONAPRO='L' "									// Liberado
			_cQuery += " AND C7_APROV <> '      ' "							// Grupo Aprovador
		  	_cQuery += " AND C7_WF <> '1'"	      					    	// 1 Enviado EMAIL
		  	                     
		  	_cQuery += " ORDER BY"
		  	_cQuery += " C7_FILIAL," 
		  	_cQuery += " C7_NUM,"
		  	_cQuery += " C7_ITEM"
			  	
			TcQuery _cQuery New Alias "TMP"
		
			dbGotop()
			While !TMP->(Eof())

				_cNum	   := TMP->C7_NUM
				
				DBSelectarea("SCR")
				DBSetOrder(1)
				DBSeek(TMP->(C7_FILIAL+"PC"+_cNUM),.T.)
                       
				_lAchou  := .F.
				_lAprov	:= .F.
				_cChave	:= ''
				_nTotal	:= 0
				
				While !SCR->(EOF()) .AND. ;
	    				   		SCR->CR_FILIAL		== TMP->C7_FILIAL  	.AND. ;
			    	  			SCR->CR_TIPO 		== "PC" 					.AND. ;
	        					TRIM(SCR->CR_NUM) == TRIM(TMP->C7_NUM)
	        		
	        		IF SCR->CR_STATUS == '03' .AND. !EMPTY(SCR->CR_LIBAPRO)   // SOMENTE CASO APROVADO
        				_cChave	:= SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV)
        				_lAprov	:= .T.
						_lAchou  := .T.        				
        				_nTotal	:= SCR->CR_TOTAL
        			ENDIF
        		
	        		SCR->(DBSkip())
	        	End

				IF !_lAchou
					DBSelectarea("SC7")
					DBSetOrder(1)
					IF DBSeek(TMP->(C7_FILIAL+C7_NUM+C7_ITEM))
						Reclock("SC7",.F.)
						SC7->C7_WF			:= "1"   	                        // Status 1 - envio email
			  			SC7->C7_WFID		:= "N/D"   									// Rastreabilidade
						MSUnlock()
					ENDIF
				ENDIF
					
	    		IF _lAprov
					_aWF	 		:= EnviaPC(TMP->C7_FILIAL, PADR(TMP->C7_NUM, LEN(SCR->CR_NUM)), TMP->C7_USER , _cChave, _nTotal, _nOpc)
						           
					While !TMP->(EOF()) .AND. _cNum == TMP->C7_NUM 
	
						DBSelectarea("SC7")
						DBSetOrder(1)
						IF DBSeek(TMP->(C7_FILIAL+C7_NUM+C7_ITEM))
							Reclock("SC7",.F.)
							SC7->C7_WF			:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
				  			SC7->C7_WFID		:= _aWF[1]									// Rastreabilidade
							MSUnlock()
						ENDIF
						
						TMP->(DBSkip())
					END
				ENDIF
			END
			
			dbSelectArea("TMP")
			dbCloseArea()

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ4 - Envia resposta de pedido bloqueado para o compradorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
	CASE _nOpc == 4

			//U_CONSOLE("4 - Envia resposta de pedido bloqueado para o comprador")
			//U_CONSOLE("4 - EmpFil:" + cEmpAnt + cFilAnt)
			
		  	_cQuery := ""
		  	_cQuery += " SELECT"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_TIPO,"   
		  	_cQuery += " CR_NUM,"    
		  	_cQuery += " CR_NIVEL," 
		  	_cQuery += " CR_TOTAL," 
		  	_cQuery += " CR_USER,"   
		  	_cQuery += " CR_APROV"    
		  	
		  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
		  	_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
		  	_cQuery += " AND CR_FILIAL = '" + cFilAnt + "'"
		  	_cQuery += " AND CR_LIBAPRO <> '      '" 							// Seleciona o Aprovador que reprovou
		  	_cQuery += " AND CR_STATUS = '04'"                          // REPROVADO
		  	_cQuery += " AND CR_TIPO = 'PC'"                            // PEDIDO DE COMPRA
		  	_cQuery += " AND CR_WF <> '1'"	      					    	// 1-Enviado
		  	
		  	_cQuery += " ORDER BY"
		  	_cQuery += " CR_FILIAL," 
		  	_cQuery += " CR_NUM,"
		  	_cQuery += " CR_NIVEL,"
		  	_cQuery += " CR_USER"
		  	
			TcQuery _cQuery New Alias "TMP"
		                            
			dbGotop()
			While !TMP->(Eof())

				DBSelectArea("SC7")
				DBSetOrder(1)
				DBSeek(xFilial("SC7")+PADR(ALLTRIM(TMP->CR_NUM),6))

				IF EMPTY(SC7->C7_APROV)
					DBSelectarea("SCR")
					DBSetOrder(3)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= "1" 		 	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= "N/D"		   // Rastreabilidade
						MSUnlock()
					ENDIF	
				ELSE 				
					_aWF	 		:= EnviaPC(TMP->CR_FILIAL, TMP->CR_NUM, SC7->C7_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV) , TMP->CR_TOTAL, _nOpc)
	
					DBSelectarea("SCR")
					DBSetOrder(3)
					IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV))
						Reclock("SCR",.F.)
						SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
			  			SCR->CR_WFID		:= _aWF[1]		// Rastreabilidade
						MSUnlock()
					ENDIF
				ENDIF		
							
				dbSelectArea("TMP")
				DBSkip()
			End
			
			dbSelectArea("TMP")
			dbCloseArea()

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ5 - ENVIO de Email - Notificacao TIME-OUT             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/  /*
	CASE _nOpc	== 5

		U_CONSOLE("5 - TimeOut" )
		nWFPC5 		:= U_Semaforo("WFPC5")
                            
		_cChave   	:= oProcess:aParams[1]
		_cSubject	:= oProcess:cSubject
		_cEmail  	:= oProcess:cTo       

		oProcess:Finish() // FINALIZA O PROCESSO        

		DBSelectArea("SCR")
		DBSetOrder(3)
		DBSeek(_cChave)
	
		// Atualiza Status WF
		DBSelectArea("SCR")
		RecLock("SCR",.F.)
		SCR->CR_WF 		:= ' '	
		SCR->CR_WFID 	:= ' '	
		MSUnlock()		

		_cTitle	:= "TimeOut - " + _cSubject

		_aMsg	:= {}
		AADD(_aMsg, Dtoc(MSDate()) + " - " + Time() )
		AADD(_aMsg, "Aprova็ใo de Pedido de Compras [Time-Out]")
		AADD(_aMsg, "O prazo de resposta expirou em " + DTOC(dDatabase) + " as " + LEFT(TIME(),5))
		AADD(_aMsg, "Desconsidere o email anterior para responder.")
		AADD(_aMsg, "Aguarde o pr๓ximo email para responder.")
			
	  	//U_MailNotify(_cEmail, _cTitle, _aMsg)
           
		U_CONSOLE("5 - Semaforo Verde" )
		U_Semaforo(nWFPC5)
				

	*/		
END CASE			

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaPC   บAutor  ณBRUNO PAULINELLI    บ Data ณ  27/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaPC(_cFilial,_cNum, _cUser, _cChave, _nTotal, _nOpc)
Private nDD   	:= GetNewPar("MV_WFTODD", 1)	// TimeOut - Dias
Private nHH    	:= GetNewPar("MV_WFTOHH", 0)    // TimeOut - Horas
Private nMM     := GetNewPar("MV_WFTOMM", 0)    // TimeOut - Minutos


	_cTo			:= UsrRetMail(_cUser)

	//-------------------------------------
	//------------------- VALIDACAO
	_lError := .F.
	if Empty(_cTo)
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		
		_aMsg := {}
		AADD(_aMsg, Dtoc(MSDate()) + " - " + Time() )
		AADD(_aMsg, "Ocorreu um ERRO no envio da mensagem :")
		AADD(_aMsg, "Pedido de Compra No: " + _cNum + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(_cUser) )
		AADD(_aMsg, "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" )
		
		U_NotifyAdm(cTitle, _aMsg)

		_aReturn := {}
		AADD(_aReturn, "")
		
		RETURN _aReturn
	Endif

              
	_cChaveSCR	:= _cFilial + 'PC' + _cNum
	_cNum 		:= PADR(ALLTRIM(_cNum),6)

	lDetalhe 	:= .F.	

	_cNum := TRIM(_cNum)

	DBSelectArea("SCR")
	DBSetOrder(3)
	DBSeek(_cChave)

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+cFilAnt)
	
	DBSelectArea("SC7")
	DBSetOrder(1)
	DBSeek(_cFilial+_cNum)

	DBSelectArea("SA2")
	DBSetOrder(1)
	DBSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

	DBSelectArea("SE4")
	DBSetOrder(1)
	DBSeek(xFilial("SE4")+SC7->C7_COND)

	cAttachFile 			:= TRIM("\workflow\html\PC\temp\detalhes do pedido "+ALLTRIM(cEmpAnt)+ALLTRIM(_cFilial)+ALLTRIM(_cNum)+".htm")
	
	DO CASE 
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao
				oProcess          	:= TWFProcess():New( "000001", "Envio Aprovacao PC :" + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC : "+_cFilial + _cNum, "\WORKFLOW\HTML\PC\PCAPROV.HTM" )
				oProcess:cSubject 	:= "Aprovacao PC " + _cFilial + "/" +  _cNum
				oProcess:bReturn  	:= "U_WFPC(2)" 
			//oProcess:bTimeOut 	:= { { "U_WFPC(5)", nDD, nHH, nMM } }
				oProcess:attachfile(cAttachFile)
		
		CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
				oProcess          	:= TWFProcess():New( "000003", "Envio p/comprador PC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC aprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PC\PCRESP.HTM" )
				oProcess:cSubject 	:= "Aprovacao do PC " + _cFilial + "/" +  _cNum
				_cResposta				:= " A P R O V A D O "
			
		CASE _nOpc == 4		// Envio de email Reprovado para solicitante
				oProcess          	:= TWFProcess():New( "000004", "Envio p/comprador PC reprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC reprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PC\PCRESP.HTM" )
				oProcess:cSubject 	:= "Reprovacao do PC " + _cFilial + "/" +  _cNum
				_cResposta				:= "<font color='#FF0000'>R E P R O V A D O </font>"
	
	ENDCASE

	oProcess:cTo      		:= _cTo
	oProcess:UserSiga		:= _cUser
	oProcess:NewVersion(.T.)
	
 	oHtml     				:= oProcess:oHTML
    
	IF _nOpc == 1
		// Hidden Fields
		oHtml:ValByName( "OBS"		   , "" )
		
		// Cria o pedido de detalhe
		oHtmlDet := TWFHtml():New("\WORKFLOW\HTML\PC\PCDet.htm")
	  	oHtmlDet:ValByName("C7_NUM",_cNum)
	  	//oHtmlDet:ValByName("M0_NOME"  ,SM0->M0_NOME)
	  	oHtmlDet:ValByName("C7_FILIAL","")
	ENDIF
   
	IF _nOpc == 3 .OR. _nOpc == 4
		oHtml:ValByName( "mensagem"  	, _cResposta)	 
	ENDIF
   
	//Cabecalho
	//oHtml:ValByName( "M0_NOME"		, SM0->M0_NOME)
	oHtml:ValByName( "C7_FILIAL"	, "" )
	oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM )
	oHtml:ValByName( "C7_EMISSAO"	, DTOC(SC7->C7_EMISSAO) )
	oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI)
	oHtml:ValByName( "C7_USER"		, UsrFullName(SC7->C7_USER))
	IF _nOpc == 1
		oHtml:ValByName( "CR_USER"		, UsrFullName(_cUser))
	ENDIF
	oHtml:ValByName( "A2_NOME"		, SA2->A2_COD + "-" + SA2->A2_NOME)
	
	DBSelectArea("CTT")
	DBSetOrder(1)
	DBSeek(xFilial("CTT")+SC7->C7_CC)
	
	oHtml:ValByName( "C7_CC"	, CTT->CTT_CUSTO   + '-' + CTT->CTT_DESC01)
	oHtml:ValByName( "CR_TOTAL"	, TRANSFORM(_nTotal,'@E 999,999.99'))

	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
	//-------------------------------------------------------------
	_nC7_TOTAL		:= 0
	_nC7_VLDESC		:= 0
	_nDESPESA		:= 0

	aTemp			:= {}
	
	While !SC7->(EOF()) .AND. SC7->C7_FILIAL == _cFilial .AND. SC7->C7_NUM == _cNum
                                              
		DBSELECTAREA("SB1")
		DBSetOrder(1)
		DBSeek(xFilial()+SC7->C7_PRODUTO)

		DBSELECTAREA("SBM")
		DBSetOrder(1)
		DBSeek(xFilial()+SB1->B1_GRUPO)
                                                        
		AAdd( (oHtml:ValByName( "t1.1"    )), SC7->C7_ITEM)
		AAdd( (oHtml:ValByName( "t1.2"    )), SC7->C7_PRODUTO)
		AAdd( (oHtml:ValByName( "t1.3"    )), SB1->B1_DESC)
		AAdd( (oHtml:ValByName( "t1.4"    )), SB1->B1_UM)
		AAdd( (oHtml:ValByName( "t1.5"    )), TRANSFORM(SC7->C7_QUANT,'@E 999,999.999'))
		AAdd( (oHtml:ValByName( "t1.6"    )), TRANSFORM(SC7->C7_PRECO,'@E 999,999.99'))
		AAdd( (oHtml:ValByName( "t1.7"    )), TRANSFORM(SC7->C7_IPI,'@E 99.99'))
		AAdd( (oHtml:ValByName( "t1.8"    )), TRANSFORM(SC7->C7_TOTAL,'@E 99,999,999.99'))
		AAdd( (oHtml:ValByName( "t1.9"    )), SC7->C7_DATPRF)
		AAdd( (oHtml:ValByName( "t1.10"   )), SC7->C7_OBS)

		_nC7_TOTAL 	:= _nC7_TOTAL 	+ SC7->C7_TOTAL
		_nC7_VLDESC	:= _nC7_VLDESC	+ SC7->C7_VLDESC
		_nDESPESA 	:= _nDESPESA 	+ (SC7->C7_VALFRE + SC7->C7_DESPESA + SC7->C7_SEGURO)
		
		IF _nOpc == 1
			PCDetalhe(SC7->C7_PRODUTO,SB1->B1_DESC, SC7->C7_NUMCOT, oHtmlDet)
		ENDIF

		nPos := aScan(aTemp,{|x| x[1] == SC7->C7_CONTA})
		IF nPos == 0
			AADD(aTemp ,{SC7->C7_CONTA,SC7->C7_CC,SC7->C7_TOTAL})   // ESTม POR CONTA, CENTRO DE CUSTO O ORวAMENTO, INFORME OUTRO SE NECESSมRIO
		ELSE
			aTemp[nPos][3] := aTemp[nPos][3] + SC7->C7_TOTAL 
		ENDIF
		         	                                 
		SC7->(dbSkip())
	Enddo

	//oHtml:ValByName( "C7_TOTAL"	    , TRANSFORM(_nC7_TOTAL ,'@E 999,999.99'))
	//oHtml:ValByName( "C7_VLDESC" 	, TRANSFORM(_nC7_VLDESC,'@E 999,999.99'))
	//oHtml:ValByName( "DESPESA"   	, TRANSFORM(_nDESPESA  ,'@E 999,999.99'))
	/*
	IF _nOpc == 1
		//-------------------------------------------------------------	
		// QUADRO RESUMO
		//-------------------------------------------------------------

		aConta	:= aSort(aTemp   ,,,{|x,y| x[1] < y[1] })
		
		For nInd := 1 TO Len(aConta)             
			DBSelectArea("CT1")
			DBSetOrder(1)
			DBSeek(xFilial("CT1")+aConta[nInd][1])
	      
			nSaldo			:= 0 // COLOCAR A FUNวรO QUE TRAZ O SALDO
			nSaldo          += aConta[nInd][3]
			nDisponivel     := nSaldo - aConta[nInd][3]
			
			cDisp			:= Transform(nDisponivel      ,PesqPict("SC7","C7_TOTAL" ,14,1))
			
			AAdd( (oHtml:ValByName( "q1.1"    )), aConta[nInd][1])	// CำDIGO DA CONTA
			AAdd( (oHtml:ValByName( "q1.2"    )), "")   // DESCRIวรO DA CONTA
			AAdd( (oHtml:ValByName( "q1.3"    )), Transform(aConta[nInd][3]  ,PesqPict("SC7","C7_TOTAL",14,1)))
			AAdd( (oHtml:ValByName( "q1.4"    )), Transform(nSaldo           ,PesqPict("SC7","C7_TOTAL",14,1)))
			AAdd( (oHtml:ValByName( "q1.5"    )), IIF(nDisponivel>0          , cDisp, "<font color='#FF0000'>"+cDisp+"</font>"))
		Next
	ENDIF
    */
	//-------------------------------------------------------------
	// ALIMENTA A TELA DE PROCESSO DE APROVAวรO DE PEDIDO DE COMPRA
	//-------------------------------------------------------------
	
	_cCHAVESCR := SUBS(_cCHAVE, 1, 24)
	
	DBSelectarea("SCR")
	DBSetOrder(1)
	DBSeek(_cCHAVESCR,.T.)
	
	WHILE !SCR->(EOF()) .AND. ALLTRIM(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == ALLTRIM(_cCHAVESCR)
		cSituaca := ""
		Do Case
             Case SCR->CR_STATUS == "01"
                     cSituaca := "Aguardando"
             Case SCR->CR_STATUS == "02"
                     cSituaca := "Em Aprovacao"
             Case SCR->CR_STATUS == "03"
                     cSituaca := "Aprovado"
             Case SCR->CR_STATUS == "04"
                     cSituaca := "Bloqueado"
                     lBloq := .T.
             Case SCR->CR_STATUS == "05"
                     cSituaca := "Nivel Liberado"
        EndCase	
                                             
		_cT4 := UsrRetName(SCR->CR_USERLIB)
		_cT6 := SCR->CR_OBS
		
		AAdd( (oHtml:ValByName( "t.1"    )), SCR->CR_NIVEL)
		AAdd( (oHtml:ValByName( "t.2"    )), UsrFullName(SCR->CR_USER))
		AAdd( (oHtml:ValByName( "t.3"    )), cSituaca    )
		AAdd( (oHtml:ValByName( "t.4"    )), IIF(EMPTY(_cT4),"", _cT4))
		AAdd( (oHtml:ValByName( "t.5"    )), DTOC(SCR->CR_DATALIB))
		AAdd( (oHtml:ValByName( "t.6"    )), IIF(EMPTY(_cT6),"", _cT6))
		
		SCR->(DBSkip())
   ENDDO

	IF _nOpc == 1
		oHtmlDet:savefile(cAttachFile)
	Endif
	
	// ARRAY DE RETORNO
	_aReturn := {}
	AADD(_aReturn, oProcess:fProcessId)
	aAdd( oProcess:aParams, _cChave)						
	
	oProcess:nEncodeMime := 0

	oProcess:Start()
	return _aReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCDetalhe บAutor  ณBRUNO PAULINELLI    บ Data ณ  27/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PCDetalhe(cCod, cDesc, cNumCot, oHtmlDet)
Local aViewSC7 := {}, aViewSC8 := {}
Local cHtml                      

IF cCod == Nil
	RETURN
ENDIF

IF cDesc == Nil .or. Empty(trim(cDesc))
	cDesc := "PRODUTO NAO ENCONTRADO"
ENDIF

aViewSC7 := MontaPC(cCod)
aViewSC8 := MontaCT(cCod,cNumCot)
                                
nLimC7	 := GetNewPar("MV_WFMAXC7",3)
nLimC8	 := GetNewPar("MV_WFMAXC8",3)

nLenSC7	 := IIF(LEN(aViewSC7) > nLimC7, nLimC7, LEN(aViewSC7))
nLenSC8  := IIF(LEN(aViewSC8) > nLimC8, nLimC8, LEN(aViewSC8))

cHtml := ''
cHtml += cCOD + ' - ' + RTRIM(cDesc) + ' &nbsp;<br> '

IF LEN(aViewSC7) > 0 
	cHtml += '<table border="0" cellspacing="1" width="100%" bgcolor="#FFFFFF">'
	cHtml += '	  <tr>'
	cHtml += '	    <td width="100%" align="left"><b><font color="#000080" face="Tahoma" size="2">ฺltimos'
	cHtml += '	      Pedido de Compras</font></b></td>'
	cHtml += '	  </tr>'
	cHtml += '	</table>'
	 
	cHtml += '	<table border="0" cellspacing="1" width="100%">'
	cHtml += '	  <tr>'
	cHtml += '	    <td width="10%"  align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Pedido</font></b></td>'
	cHtml += '	    <td width="2%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Item</font></b></td>'
	cHtml += '	    <td width="37%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Fornecedor</font></b></td>'
	cHtml += '	    <td width="6%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Qtde</font></b></td>'
	cHtml += '	    <td width="9%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Preco</font></b></td>'
	cHtml += '	    <td width="11%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Qtde'
	cHtml += '	      Entregue</font></b></td>'
	cHtml += '	    <td width="11%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Cond.Pgto</font></b></td>'
	cHtml += '	    <td width="10%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Dt.Entrega</font></b></td>'
	cHtml += '	  </tr>'
	 
	For nInd := 1 to nLenSC7
		cHtml += '	  <tr>'
		cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC7[nInd][1] +'</font></td>'
		cHtml += '	    <td width="2%" bgcolor="#FFFFFF"><font size="1" face="Tahoma">'   + aViewSC7[nInd][2] +'</font></td>'
		cHtml += '	    <td width="37%" bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC7[nInd][3] +'</font></td>'
		cHtml += '	    <td width="6%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC7[nInd][4] +'</font></td>'
		cHtml += '	    <td width="9%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC7[nInd][5] +'</font></td>'
		cHtml += '	    <td width="11%" bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC7[nInd][6] +'</font></td>'
		cHtml += '	    <td width="11%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC7[nInd][7] +'</font></td>'
		cHtml += '	    <td width="10%" bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC7[nInd][8] +'</font></td>'
		cHtml += '	  </tr>'
	Next
	cHtml += '	</table> &nbsp;<br> '
ELSE
	cHtml += '	<table border="0" cellspacing="1" width="100%" bgcolor="#FFFFFF">'
	cHtml += '	  <tr>'
	cHtml += '	    <td width="100%" align="left"><b><font color="#000080" face="Tahoma" size="2">Nao ha '
	cHtml += '	      Pedido de Compras</font></b></td>'
	cHtml += '	  </tr>'
	cHtml += '	</table>'
ENDIF

IF Len(aViewSC8) > 0 
	cHtml += '	<table border="0" cellspacing="1" width="100%" bgcolor="#FFFFFF">'
	cHtml += '	  <tr>'
	cHtml += '	    <td width="100%" align="left"><b><font color="#000080" face="Tahoma" size="2">'
	cHtml += '	      Cotacoes</font></b></td>'
	cHtml += '	  </tr>'
	cHtml += '	</table>'
	
	cHtml += '	<table border="0" cellspacing="1" width="100%">'
	cHtml += '	  <tr>'
	cHtml += '	    <td width="10%"  align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Cotacao</font></b></td>'
	cHtml += '	    <td width="2%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Item</font></b></td>'
	cHtml += '	    <td width="39%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Fornecedor</font></b></td>'
	cHtml += '	    <td width="6%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Qtde</font></b></td>'
	cHtml += '	    <td width="10%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Preco</font></b></td>'
	cHtml += '	    <td width="22%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Cond.Pgto</font></b></td>'
	cHtml += '	    <td width="11%" align="center" bgcolor="#e4e4e4"><b><font face="Tahoma" size="1">Dt.Entrega</font></b></td>'
	cHtml += '	  </tr>'
	 
	For nInd := 1 to nLenSC8
		cHtml += '	  <tr>'
		cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC8[nInd][1] +'</font></td>'
		cHtml += '	    <td width="2%" bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC8[nInd][2] +'</font></td>'
		cHtml += '	    <td width="39%" bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC8[nInd][3] +'</font></td>'
		cHtml += '	    <td width="6%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC8[nInd][4] +'</font></td>'
		cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC8[nInd][5] +'</font></td>'
		cHtml += '	    <td width="22%" bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC8[nInd][6] +'</font></td>'
		cHtml += '	    <td width="11%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + aViewSC8[nInd][7] +'</font></td>'
		cHtml += '	  </tr>'
	Next
	cHtml += '	</table> &nbsp;<br> '
ELSE
	cHtml += '	<table border="0" cellspacing="1" width="100%" bgcolor="#FFFFFF">'
	cHtml += '	  <tr>'
	cHtml += '	    <td width="100%" align="left"><b><font color="#000080" face="Tahoma" size="2">Nao ha '
	cHtml += '	      Cotacoes</font></b></td>'
	cHtml += '	  </tr>'
	cHtml += '	</table>'
ENDIF

cHtml += '<hr><hr>'

aAdd( (oHtmlDet:ValByName("t.1")), cHtml )
return            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaPC   บAutor  ณBRUNO PAULINELLI    บ Data ณ  27/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaPC(cProduto)
Local aViewSC7 := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona o cadastro de produtos                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea('SB1')
dbSetOrder(1)
If MsSeek(xFilial()+cProduto)
		aViewSC7 := {}
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				cCursor:= CriaTrab(,.F.)
				lQuery := .T.
				cQuery := ""
				cQuery += "SELECT * FROM "+RetSqlName("SC7")+" WHERE "
				cQuery += "C7_FILIAL='"+xFilial("SC7")+"' AND "
				cQuery += "C7_PRODUTO='"+cProduto+"' AND "
				cQuery += "D_E_L_E_T_ <> '*' "
				cQuery += "ORDER BY C7_DATPRF DESC"
				cQuery := ChangeQuery(cQuery)
				SC7->(dbCommit())
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
				aStruQuery	:= SC7->(dbStruct())
				For nLoop := 1 To Len( aStruQuery )
					If aStruQuery[nLoop,2] <> "C"
						TCSetField(cCursor,AllTrim(aStruQuery[nLoop,1]),aStruQuery[nLoop,2],aStruQuery[nLoop,3],aStruQuery[nLoop,4])
					EndIf 										
				Next nLoop
				While ( !Eof() )
					dbSelectArea("SE4")
					MsSeek(xFilial()+(cCursor)->C7_COND)
					dbSetOrder(1)
					dbSelectArea("SA2")
					dbSetOrder(1)
					MsSeek(xFilial()+(cCursor)->C7_FORNECE+(cCursor)->C7_LOJA)
					dbSelectArea(cCursor)		
					aAdd(aViewSC7,{C7_NUM,C7_ITEM,SA2->A2_NOME,TransForm(C7_QUANT,PesqPict("SC7","C7_QUANT")),TransForm(C7_PRECO,PesqPict("SC7","C7_PRECO")),TransForm(C7_QUJE,PesqPict("SC7","C7_QUJE")),C7_COND+" - "+SE4->E4_DESCRI,DTOC(C7_DATPRF)})
					dbSkip()					
				EndDo
			Else
		#ENDIF
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Seleciona os registros do SC8 - DBF / INDREGUA                         ณ
			//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cIndex := CriaTrab(,.F.)
			ChkFile("SC7",.F.,"TMPSC7")
			dbSelectArea("TMPSC7")
			cFiltro := ""
			cFiltro += "C7_FILENT=='"+xFilial("SC7")+"'.AND."
			cFiltro += "C7_PRODUTO=='"+cProduto+"'"
			IndRegua("TMPSC7",cIndex,"C7_FILENT+DTOS(C7_DATPRF)",,cFiltro,"") //"Selecionando Registros..."
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbGoBottom()
			While !Bof().And.Len(aViewSC7)<200
				dbSelectArea("SE4")
				MsSeek(xFilial()+TMPSC7->C7_COND)
				dbSetOrder(1)
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial()+TMPSC7->C7_FORNECE+TMPSC7->C7_LOJA)
				dbSelectArea("TMPSC7")
				aAdd(aViewSC7,{C7_NUM,C7_ITEM,SA2->A2_NOME,TransForm(C7_QUANT,PesqPict("SC7","C7_QUANT")),TransForm(C7_PRECO,PesqPict("SC7","C7_PRECO")),TransForm(C7_QUJE,PesqPict("SC7","C7_QUJE")),C7_COND+" - "+SE4->E4_DESCRI,DTOC(C7_DATPRF)})
				dbSkip(-1)
			End
			dbSelectArea("TMPSC7")
			dbClearFilter()
			dbCloseArea()
			Ferase(cIndex+OrdBagExt())
			
		#IFDEF TOP
			EndIf
		#ENDIF
EndIf	
Return aViewSC7

	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaCT   บAutor  ณMicrosiga           บ Data ณ  28/15/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	
Static Function MontaCT(cProduto, cNumCot)
Local aViewSC8 := {}

dbSelectArea('SB1')
dbSetOrder(1)
If MsSeek(xFilial()+cProduto)
		aViewSC8 := {}
		
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				cCursor:= CriaTrab(,.F.)
				lQuery := .T.
				cQuery := ""
				cQuery += "SELECT * FROM "+RetSqlName("SC8")+" WHERE "
				cQuery += "C8_FILIAL='"+xFilial("SC8")+"' AND "
				cQuery += "C8_PRODUTO='"+cProduto+"' AND "
				cQuery += "C8_NUM='"+cNumCot+"' AND "
				cQuery += "C8_PRECO <> 0  AND "
				cQuery += "D_E_L_E_T_ <> '*' "
				cQuery += "ORDER BY C8_DATPRF DESC"
				cQuery := ChangeQuery(cQuery)
				SC8->(dbCommit())
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
				aStruQuery	:= SC8->(dbStruct())
				For nLoop := 1 To Len( aStruQuery )
					If aStruQuery[nLoop,2] <> "C"
						TCSetField(cCursor,AllTrim(aStruQuery[nLoop,1]),aStruQuery[nLoop,2],aStruQuery[nLoop,3],aStruQuery[nLoop,4])
					EndIf 										
				Next nLoop
				While ( !Eof() )
					dbSelectArea("SE4")
					MsSeek(xFilial()+(cCursor)->C8_COND)
					dbSetOrder(1)
					dbSelectArea("SA2")
					dbSetOrder(1)
					MsSeek(xFilial()+(cCursor)->C8_FORNECE+(cCursor)->C8_LOJA)
					dbSelectArea(cCursor)		
					aAdd(aViewSC8,{C8_NUM,C8_ITEM,SA2->A2_NOME,TransForm(C8_QUANT,PesqPict("SC8","C8_QUANT")),TransForm(C8_PRECO,PesqPict("SC8","C8_PRECO")),C8_COND+" - "+SE4->E4_DESCRI,DTOC(C8_DATPRF)})
					dbSkip()					
				EndDo
			Else
		#ENDIF
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Seleciona os registros do SC8 - DBF / INDREGUA                         ณ
			//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cIndex := CriaTrab(,.F.)
			ChkFile("SC8",.F.,"TMPSC8")
			dbSelectArea("TMPSC8")
			cFiltro := ""
			cFiltro += "C8_FILIAL=='"+xFilial("SC8")+"'.AND."
			cFiltro += "C8_PRODUTO=='"+cProduto+"'.AND."
			cFiltro += "C8_NUM=='"+cNumCot+"'.AND."
			cFiltro += "C8_PRECO<>0"
			IndRegua("TMPSC8",cIndex,"C8_FILIAL+DTOS(C8_DATPRF)",,cFiltro,"") //"Selecionando Registros..."
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbGoBottom()
			While !Bof().And.Len(aViewSC8)<200
				dbSelectArea("SE4")
				MsSeek(xFilial()+TMPSC8->C8_COND)
				dbSetOrder(1)
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial()+TMPSC8->C8_FORNECE+TMPSC8->C8_LOJA)
				dbSelectArea("TMPSC8")
				aAdd(aViewSC8,{C8_NUM,C8_ITEM,SA2->A2_NOME,TransForm(C8_QUANT,PesqPict("SC8","C8_QUANT")),TransForm(C8_PRECO,PesqPict("SC8","C8_PRECO")),C8_COND+" - "+SE4->E4_DESCRI,DTOC(C8_DATPRF)})
				dbSkip(-1)
			End
			dbSelectArea("TMPSC8")
			dbClearFilter()
			dbCloseArea()
			Ferase(cIndex+OrdBagExt())
			
		#IFDEF TOP
			EndIf
		#ENDIF
		
EndIf	
return aViewSC8

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaSC   บAutor  ณMicrosiga           บ Data ณ  08/15/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	
Static Function MontaSC(cNumSC7)
Local aViewSC1 := {}

dbSelectArea('SC1')
dbSetOrder(6)
DBSeek(xFilial()+cNumSC7)

While !EOF() .AND. xFilial() == SC1->C1_FILIAL .AND. SC1->C1_PEDIDO == cNumSC7
                             
	IF !EMPTY(ALLTRIM(SC1->C1_OBS))
		If Ascan(aViewSC1, SC1->C1_OBS)==0
			AADD(aViewSC1 ,SC1->C1_OBS)
		Endif
	ENDIF
		
	SC1->(DBSkip())
EndDo

return aViewSC1

