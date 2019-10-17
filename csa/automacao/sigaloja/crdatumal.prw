#INCLUDE "TBICONN.CH"
//Pula Linha
#Define CTRL Chr(10)+Chr(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณCRDAtuMAL  ณ Autor ณ 						ณ Data ณ 		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ 															  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ CRDAtuMAL()							 		              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso		 ณ Della Via												  ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data/Bops/Ver ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออัออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        |      ณ											  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CRDAtuMAL()

Local nCntMAL    := 0        //Contador de registros atualizados
Local cContrato  := ""       //Numero do contrato
Local cTexto     := ""       //Texto do log
Local cCodFilial := Space(2) //Filial onde foi encontrado o registro pesquisado
Local lDelMAL    := .F.      //Controla se atualizou o MAL
Local aFiliais   := {}       //Filiais do SM0 
Local cData      := DTOC(DATE())  //Data de atualizacao

//MAL - C
//MAH - C
//SUA - E
//SC5 - E
//SE1 - C                                     

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SM0","MAL","MAH","SUA","SC5","SE1"		//Prepara Ambiente para teste

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca todas as filiais da empresa 01  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
dbSelectArea("SM0")
MsSeek("01",.T.)
While !Eof() .AND. SM0->M0_CODIGO == "01"	
   AADD(aFiliais,M0_CODFIL)
   dbSkip()	      
End

If LEN(aFiliais) == 0
   ConOut("Atualizacao do MAL: aFiliais em branco")
   Return .T.
Endif        

DbSelectArea("MAL")  //Compartilhado
DbSetOrder(1)
DbGoTop()

BEGIN TRANSACTION

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVarre o arquivo MAL em busca de registros que devem ser atualizados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
While !Eof()   
   
   lDelMAL  := .F.
   
   If Empty(MAL->MAL_CONTRA)
      DbSkip()
      Loop
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณA analise da primeira parcela do MAL jah foi realizada. Pula para o proximo contrato ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
   If cContrato == MAL->MAL_CONTRA
      DbSkip()
      Loop
   Endif
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณBusca o contrato no arquivo MAH para verificar se o status esta OKณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   DbSelectArea("MAH")   //Compartilhado
   DbSetOrder(1)
   cContrato  := MAL->MAL_CONTRA
   If MsSeek("  "+cContrato)   
      If MAH->MAH_TRANS == "1"
		 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		 //ณBusca o atendimento para pegar o numero do pedido de venda		  ณ
		 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู      
   		 DbSelectArea("SUA")   //Exclusivo
   		 DbSetOrder(10)                     
   		 cCodFilial := Space(2)
   		 If CRDPesq(aFiliais, cContrato, @cCodFilial)   
   		 
   		 	If SUA->UA_STATUS = "CAN" // Se o Atendimento foi cancelado
   		 
				DbSelectArea("MAL")            
   		 	    While !Eof() .AND. "  "+cContrato == MAL->MAL_FILIAL+MAL->MAL_CONTRA
   		 	    	RecLock("MAL",.F.)
   		 	        DbDelete()
   		 	        MsUnlock()   		 	         
   		 	            
					DbSkip()                   //Skip MAL*
   		 	            
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณIncrementa o contador de parcelas atualizadasณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	         		 	            
				    nCntMAL++   		 	            
						   
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณSinaliza que nao eh mais necessario continuar a busca no SE1, pois as parcelas do  ณ
					//ณcontrato jah foram encontradas e atualizadas									    ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	         		 	            				        
					lDelMAL  := .T.
   		 	               
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณGrava o log 								  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	         		 	            				           
					cTexto  := 	" Atendimento Cancelado Data: " + cData + " Contrato: " + cContrato + " Cliente: "+SE1->E1_CLIENTE+"/"+SE1->E1_LOJA+;
								" NF: "+SE1->E1_PREFIXO+SE1->E1_NUM+CTRL 
					Conout(cTexto)				                         				           
					CRDLogMAL( cTexto )				           		 	               
				End   		 	            		 	         
			
			Endif			   		 
   		 
		    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		    //ณBusca o pedido de venda para pegar o numero da NF, se gerada	     ณ
		    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		 
   		 	DbSelectArea("SC5")   //Exclusivo
   		 	DbSetOrder(1)                        		       
   		 	If !Empty(SUA->UA_NUMSC5)
   		 	   If CRDPesq(aFiliais, SUA->UA_NUMSC5, cCodFilial)    
   		 	      If !Empty(SC5->C5_NOTA) .AND. !Empty(SC5->C5_SERIE)           
			         //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			         //ณVerifica se foi gerado titulo a receber para o pedido gerado pelo ณ
			         //ณatendimento 													  ณ			      
			         //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	   
   		 	         DbSelectArea("SE1")   //Compartilhado
   		 	         DbSetOrder(2)                        		          		 	         
//   		 	         If MsSeek("  "+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_SERIE+SC5->C5_NOTA)
						If MsSeek("  "+SC5->C5_CLIENTE+SC5->C5_LOJACLI+"U"+SC5->C5_FILIAL+SC5->C5_NOTA)						
   		 	            While !Eof() .AND. "  "+SC5->C5_CLIENTE+SC5->C5_LOJACLI+"U"+SC5->C5_FILIAL+SC5->C5_NOTA == ;   		 	        
   		 	               SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM .AND. !lDelMAL

				           //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				           //ณDesconsidera se for de tipo diferente de NF   ณ
				           //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	         		 	             
   		 	               If ALLTRIM(SE1->E1_TIPO) <> "NF"
   		 	                  DbSkip()
   		 	                  Loop
   		 	               Endif
				           //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				           //ณSe existe o titulo, deve atualizar o MAL para nao considerar na analise de credito	   ณ
				           //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	      
   		 	               DbSelectArea("MAL")            
   		 	               While !Eof() .AND. "  "+cContrato == MAL->MAL_FILIAL+MAL->MAL_CONTRA
   		 	                  RecLock("MAL",.F.)
   		 	                  DbDelete()
   		 	                  MsUnlock()   		 	         
   		 	            
   		 	                  DbSkip()                   //Skip MAL*
   		 	            
				              //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				              //ณIncrementa o contador de parcelas atualizadasณ
				              //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	         		 	            
				              nCntMAL++   		 	            
						   
				              //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				              //ณSinaliza que nao eh mais necessario continuar a busca no SE1, pois as parcelas do  ณ
				              //ณcontrato jah foram encontradas e atualizadas									    ณ
				              //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	         		 	            				        
   		 	                  lDelMAL  := .T.
   		 	               
				              //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				              //ณGrava o log 								  ณ
				              //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         		    		 	         		 	            				           
				              cTexto  := " Data: " + cData + " Contrato: " + cContrato + " Cliente: "+SE1->E1_CLIENTE+"/"+SE1->E1_LOJA+;
				                         " NF: "+SE1->E1_PREFIXO+SE1->E1_NUM+CTRL 
								Conout(cTexto)				                         				           
						      CRDLogMAL( cTexto )				           		 	               
   		 	               End   		 	            		 	         
   		 	               DbSelectArea("SE1")   		 	         
   		 	               DbSkip()
   		 	            End
   		 	         EndIf   
   		 	      Endif
   		 	   EndIf   
   		 	EndIf
   		 Endif
      EndIf      
   EndIf
   
   DbSelectArea("MAL")
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณSe na iteracao corrente atualizou as parcelas do MAL(lDelMAL=.T.), nao precisa pular ณ
   //ณpara o proximo registro porque jah esta posicionado(ver Skip MAL*)                   ณ   
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู     
   If !lDelMAL
      DbSkip()
   EndIf   
End



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณApaga contratos sem referencia nos arquivos SL1 e SUAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("MAL")                
DbGotop()
While !Eof() 

	cContrato 	:= MAL->MAL_CONTRATO
	_lTemSL1	:= .T.
	_lTemSUA	:= .T.

	DbSelectArea("SL1")
	DbSetOrder(10)
	DbGotop()
	cCodFilial	:= "  "
	If !CRDPesq(aFiliais, cContrato, @cCodFilial)   
		_lTemSL1	:= .F.                 
	Else	
		_lAchou 	:= .T.		
		Conout("OK - Contrato"+cContrato+" encontrado no SL1 "+SL1->L1_NUM)
	Endif	
	
	DbSelectArea("SUA")
	DbSetOrder(10)
	DbGotop()
	cCodFilial	:= "  "
	If !CRDPesq(aFiliais, cContrato, @cCodFilial)   
		_lTemSUA	:= .F.
	Else	
		_lAchou 	:= .T.		
		Conout("OK - Contrato"+cContrato+" encontrado no SUA "+SUA->UA_NUM)
	Endif
	
	DbSelectArea("MAL")	

	If !_lTemSL1 .And. !_lTemSUA 
	   DbSelectArea("MAH")   //Compartilhado
	   DbSetOrder(1)
	   cContrato  := MAL->MAL_CONTRA
	   If MsSeek("  "+cContrato)   
	      If MAH->MAH_TRANS == "1"
            
			DbSelectArea("MAL")
			RecLock("MAL",.F.)
			DbDelete()
			MsUnlock()   		 	         
		   	nCntMAL++   		 	            
						   
    		cTexto  := " Data: " + cData + " Contrato: " + cContrato +" Contrato nao encontrado no SL1 nem no SUA "+CTRL 
			Conout(cTexto)				                         				           
	    	CRDLogMAL( cTexto )				           		 	               
		  Else
		   	Conout("OK - Contrato "+cContrato+" nao encontrado mas MAH_TRANS = 2 "+SUA->UA_NUM)		    	
	      Endif	
	    Endif	
	Endif	

	DbSelectArea("MAL")   	 	            
	DbSkip()                   //Skip MAL*
   	
End   		 	            		 	         


ConOut(cData + " Atualizacao do MAL: " +ALLTRIM(STR(nCntMAL)) + " registros.")

END TRANSACTION

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRDLogMAL บAutor  ณ 					 บ Data ณ  			  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CRDLogMAL( cTexto )

Local cStartPath := Upper(GetSrvProfString("STARTPATH",""))
Local cArquivo   := cStartPath+"LogMal.log"
Local nHandle  	 := 0

If !File(cArquivo)
	nHandle := MsFCreate( cArquivo )
Else
	nHandle := FOpen(cArquivo,1)
	FSeek(nHandle,0,2)
Endif

If nHandle <> -1
   FWrite(nHandle,cTexto,Len(cTexto))
   FClose(nHandle)
Endif   

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRDPesq   บAutor  ณ 					 บ Data ณ  			  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CRDPesq( aFiliais, cChave, cCodFilial )

Local lRet    := .F.   //Retorno da funcao - registro encontrado?
Local nX               //Controle de loop

//Busca no SUA. Se encontrar, retorna a filial para ser utilizada na pesquisa do SC5 
If Empty(cCodFilial)
   For nX := 1 to Len(aFiliais)
      If MsSeek(aFiliais[nX]+cChave)   
         lRet       := .T.
         cCodFilial := aFiliais[nX]     //Armazena a filial onde foi encontrado o registro
         Exit   
      EndIf
   Next nX
//Busca no SC5 de acordo com a filial selecionada na pesquisa do SUA   
Else 
   lRet  := MsSeek(cCodFilial+cChave)   
EndIf   

Return (lRet)

//**
#INCLUDE "TBICONN.CH"
//Pula Linha
#Define CTRL Chr(10)+Chr(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณLimpaMAL  บAutor  ณ Marcio Domingos    บ Data ณ  30/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para Limpar os Contratos gerados pelo Call Center   บฑฑ
ฑฑบ          ณap๓s faturamento.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcContrato = Numero do Contrato                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada nos progrmas:                             บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LimpaMAL(cContrato)

DbSelectArea("MAL")  //Compartilhado
DbSetOrder(1)
DbGoTop()

BEGIN TRANSACTION

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVarre o arquivo MAL em busca de registros que devem ser atualizados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
  
lDelMAL  := .F.
 
DbSelectArea("MAL")            
DbSetOrder(1)
DbSeek(xFilial("MAL")+cContrato)
While 	MAL_FILIAL 	==	xFilial("MAL")	.And.;
		MAL_CONTRA	==	cContrato		.And.	!Eof()

	RecLock("MAL",.F.)
   	DbDelete()
   	MsUnlock()   		 	         
   		            
   	DbSkip()                   //Skip MAL*
   		 	            
Enddo
   
END TRANSACTION

Return .T.


