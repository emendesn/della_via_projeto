#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ430DIS  ºAutor  ³Hanna Caroline      º Data ³  21/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para validar se os produtos tem estoque    º±±
±±º          ³para efetuar a distribuicao de mercadorias                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via - LOJA430                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LJ430DIS()
Local lRet	:= .T.				// Retorno da funcao, se encontrou estoque 
Local cProds:= ""				// Adiciona os produtos que nao tem estoque
Local aArea := GetArea()		// Salva area em uso

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se nao pode ter estoque negativo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If GetMv("MV_ESTNEG") == "N"
	DbSelectArea( "SLN" )
	DbSetOrder( 1 )
	
	If DbSeek( xFilial ( "SLN" ) + SLM->LM_NUM + SLM->LM_CLIENTE + SLM->LM_LOJA )

		While 	SLN->( !Eof() ) .AND. xFilial ( "SLN" ) == xFilial ( "SLM" ) .AND. ;
				SLN->LN_NUM + SLN->LN_CLIENTE + SLN->LN_LOJA == SLM->LM_NUM + SLM->LM_CLIENTE + SLM->LM_LOJA

			MsgRun( "Aguarde... Verificando Saldo em Estoque" ,,{|| Del_Saldo( @cProds, @lRet )})
	    
			SLN->( DbSkip())
		End

	Endif

Endif

cProds := Subs(cProds,1,Len(cProds)-2)
If !lRet
	Aviso("O processamento NÃO foi efetuado ","O(s) produto(s) " + cProds + " não tem saldo suficiente ", {"Ok"})

Endif


/////////////////////////////////////////////////////
// Validação do CFOP - Marcio Domingos - 11/07/06  //
/////////////////////////////////////////////////////

DbSelectArea( "SLN" )
DbSetOrder( 1 )         
DbGoTop()
	
If DbSeek( xFilial ( "SLN" ) + SLM->LM_NUM + SLM->LM_CLIENTE + SLM->LM_LOJA )

	While 	SLN->( !Eof() ) .AND. xFilial ( "SLN" ) == xFilial ( "SLM" ) .AND. ;
			SLN->LN_NUM + SLN->LN_CLIENTE + SLN->LN_LOJA == SLM->LM_NUM + SLM->LM_CLIENTE + SLM->LM_LOJA


		_cMsg:=""
		_lret:=.T.       
	
		dBselectarea("SF4")
		dBsetorder(1)
		IF dBseek(xFilial("SF4")+SLN->LN_TES)

			If SLN->LN_CF # "6108"  // Venda para cliente não contribuinte fora do estado			
				IF !Substr(SLN->LN_CF,2,3) = Substr(SF4->F4_CF,2,3)
					_cMsg:=_cMsg + "CFOP Divergente do Pedido de Venda com o TES "+Chr(13)+Chr(10)
					_lret:=.F.
				Endif
			Endif	
			
			_cDig:=" "
	
			dBselectarea("SA1")
			dBsetOrder(1)
			dBseek(xFilial("SA1")+SLM->LM_CLIENTE+SLM->LM_LOJA)
			If SA1->A1_EST == SM0->M0_ESTENT
				_cDig:="5"
			Else
				_cDig:="6"
			ENDIF
	
			
//			IF !Substr(SLN->LN_CF,1,1) = _cDig
//				_cMsg:=_cMsg + "Digito Inicial do CFOP (Dentro ou Fora do Estado) esta Invalido !!!  "+Chr(13)+Chr(10)
//				_lret:=.F.
//			Endif
			
			
//			If _cDig == "6"
//				dBselectarea("SX5")
//				dBsetorder(1)
//				IF !dbseek(xFilial("SX5")+"13"+"5"+Substr(SLN->LN_CF,2,3)+Spac(2))
//					_cMsg:=_cMsg + "Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
//					_lret:=.F.
//				Endif
//			Else
				dBselectarea("SX5")
				dBsetorder(1)
				IF !dbseek(xFilial("SX5")+"13"+Substr(SLN->LN_CF,1,4)+Spac(2))
					_cMsg:=_cMsg + "Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
					_lret:=.F.
				Endif
			
//			Endif
			
		Endif
		
		DbSelectArea("SLN")
		DbSkip()
		
	Enddo

	IF !_lret
		MSGSTOP(_cMsg)    
		lRet := _lRet
	Endif
	
Endif	

RestArea( aArea )
Return ( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |Del_Saldo ºAutor  ³Hanna Caroline      º Data ³  21/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o saldo em estoque dos produtos referentes ao SLM   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DELLA VIA - LOJA430                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Del_Saldo(cProds, lRet)
Local nSaldo:= 0				// Saldo em estoque

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se tem saldo em estoque³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorno da funcao SldAtuEst = Quantidade em estoque disponivel³
//³Parametros                                                    ³
//³1: Codigo do Produto		- Obrigatorio                        ³
//³2: Local					- Obrigatorio                        ³
//³3: Quantidade			- Obrigatorio                    	 ³
//³4: Lote de Controle		- Obrig. se Inf. Sub-Lote        	 ³
//³5: Sub-Lote                                                   ³
//³6: Localizacao			- Obrig. se inf. Nr.Serie        	 ³
//³7: Numero de Serie                                            ³
//³8: Reserva                                                    ³
//³9: Indica se considera poder de terceiro                      ³
//³A: Indica se considera poder em terceiro                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nSaldo := SldAtuEst(SLN->LN_COD,SLN->LN_LOCAL,SLN->LN_QUANT,SLN->LN_LOTECTL,SLN->LN_NLOTE,SLN->LN_LOCALIZ )
If nSaldo > 0
	nSaldo	:= nSaldo - SLN->LN_QUANT

	If nSaldo < 0
		lRet := .F.
		cProds	:= cProds + Alltrim( SLN->LN_COD ) + ", "
	Endif

Else
	lRet := .F.
	cProds	:= cProds + Alltrim( SLN->LN_COD ) + ", "
Endif
Return( cProds ) 

User Function SLNItem()                                         
Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("LN_COD") })
Local nPosLocal	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("LN_LOCAL") })
Local nPosQuant	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("LN_QUANT") })
Local nPosLote	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("LN_LOTECTL") })
Local nPosNLote	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("LN_NLOTE") })
Local nPosLocaz	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("LN_LOCALIZ") })  
Local cCampo 	:= ReadVar()     
Local _aArea	:= GetArea()
Local _lRet		:= .T.

If Rtrim(cCampo) = "M->LN_QUANT"
	If M->LN_QUANT > SldAtuEst(aCols[n,nPosProd],aCols[n,nPosLocal],M->LN_QUANT,aCols[n,nPosLote],aCols[n,nPosNLote],aCols[n,nPosLocaz])
		MsgBox("Saldo Indisponivel !")
		_lRet		:= .F.
	Endif                    
ElseIf Rtrim(cCampo) = "M->LN_COD"	
	If aCols[n,nPosQuant] > SldAtuEst(M->LN_COD,aCols[n,nPosLocal],aCols[n,nPosQuant],aCols[n,nPosLote],aCols[n,nPosNLote],aCols[n,nPosLocaz])
		MsgBox("Saldo Indisponivel !")
		_lRet		:= .F.
	Endif
ElseIf Rtrim(cCampo) = "M->LN_LOCAL"	
	If aCols[n,nPosQuant] > SldAtuEst(aCols[n,nPosProd],M->LN_LOCAL,aCols[n,nPosQuant],aCols[n,nPosLote],aCols[n,nPosNLote],aCols[n,nPosLocaz])
		MsgBox("Saldo Indisponivel !")
		_lRet		:= .F.
	Endif
Endif	

RestArea(_aArea)	
Return _lRet	
