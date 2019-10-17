/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ rfina001 ³ Autor ³ Irina sanches Pires   ³ Data ³ 25/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia e-mail para Autorizacao de Pagamento                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         

#include "rwmake.ch"       
#include "tbiconn.ch"      
#include "TOPCONN.CH"

User Function WFINA001( nOpcao, oProcess )

      
    If ValType(nOpcao) = "A" 
      nOpcao := nOpcao[1]
    Endif  
                                 
	If nOpcao == NIL
		nOpcao := 0
	End

	If oProcess == NIL
		oProcess := TWFProcess():New( "AUTORIZA", "Autorizacao de Pagamento" )
	End

	Do Case
		Case nOpcao == 0
			U_APGIniciar( oProcess )
		Case nOpcao == 1
			U_APGRetorno( oProcess )
		Case nOpcao == 2
			U_APGTimeOut( oProcess )
	End

return		


//******************************************//
   User Function APGIniciar( oProcess )
//*****************************************//

    Local _nNumero 
    
   //numerco da autorizacao de pagamento 
	dbSelectArea("SX5")
	dbSetOrder(1)
	if dbSeek(xFilial("SX5")+"Z8",.t.)
		_nNumero := strzero(val(sx5->x5_chave)+1,6)
		reclock("SX5",.f.)
		sx5->x5_chave := _nNumero 
		msunlock() 
	endif

   //Abre o HTML criado. Repare que o mesmo se encontra abaixo do RootPath
   	oProcess:NewTask( "Liberacao", "\HTML\AUTORIZAPG.HTM" )
	oProcess:cSubject := "Autorizacao de Pagamento : " + _nNumero 
	oProcess:bReturn  := "U_WFINA001(1)"   
	oProcess:bTimeOut := {{"U_WFINA001(2)",30, 0, 5 }}

	oHTML    := oProcess:oHTML                  
	oHtml:ValByName( "numero"  , _nNumero  )	
	oHtml:ValByName( "data"    , dDatabase )	
	oHtml:ValByName( "hora"    , time()    )	

	dbSelectArea("TEMP")
	dbGoTop()
	While !Eof()

		if temp->e2_ok <> cMarca
			dbSkip()
			Loop
		EndIf

		sed->(dbSeek(xFilial("SED")+temp->e2_naturez))
  		sm0->(dbSeek(SM0->M0_CODIGO+temp->e2_filorig))

		AAdd( (oHtml:ValByName( "t2.opc" )), space(1))		
        AAdd( (oHtml:ValByName( "t2.filial" )), substr(sm0->m0_filial,6,7))		
        AAdd( (oHtml:ValByName( "t2.titulo" )),temp->e2_prefixo+"/"+temp->e2_num+"/"+temp->e2_parcela)		                     
   	    AAdd( (oHtml:ValByName( "t2.emissao" )),dtoc(temp->e2_emissao))
       	AAdd( (oHtml:ValByName( "t2.vencrea" )),dtoc(temp->e2_vencrea))		                     
        AAdd( (oHtml:ValByName( "t2.fornece" )), temp->e2_fornece+"/"+temp->e2_loja+"-"+substr(temp->e2_nomfor,1,20) )		       
   	    AAdd( (oHtml:ValByName( "t2.vlsaldo" )),transform(temp->e2_saldo,'@E 999,999,999.99' ) )		              
       	AAdd( (oHtml:ValByName( "t2.vltotal" )),transform(temp->e2_valor,'@E 999,999,999.99' ) )		              
        AAdd( (oHtml:ValByName( "t2.historico" )),substr(temp->e2_hist,1,25))		              
        AAdd( (oHtml:ValByName( "t2.natureza" )),temp->e2_naturez+"-"+substr(sed->ed_descric,1,20))		              

        dbSelectArea("temp")
        dbSkip()
   end

	_emaild := alltrim(GetMV("MV_PGENVIO"))  
	_emailf := alltrim(GetMV("MV_PGRETOR"))  
	oHtml:ValByName( "emaildest", _emaild )	
	oHtml:ValByName( "emailfrom", _emailf )	
	
	oProcess:cTo := _emaild  
	oProcess:Start()            

    //ConOut("Rastreando:"+oProcess:fProcCode)
	alert("email enviado") 

Return 


//******************************************//
//   *Faz a Liberação Automática do Pedido* //
     User Function APGRetorno( oProcess )
//******************************************//
  
  Local i
  
  ConOut('Executando Retorno')      
  ConOut('Autorizacao de Pagamento No: '+ oProcess:oHtml:RetByName('Numero') + " APROVADO!!")
  
  //efetua a liberação do título para pagamento 
  For i:=1 to Len(oProcess:oHtml:RetByName("t2.opc"))

		_cTitulo  := oProcess:oHtml:RetByName('t2.titulo')[i]
		_cPrefixo := substr(_cTitulo,1,3)
		_cNum     := substr(_cTitulo,5,6)
		_cParcela := substr(_cTitulo,12,2)

	   	_cForn    := oProcess:oHtml:RetByName('t2.fornece')[i]
		_cFornece := substr(_cForn,1,6)
		_cLoja    := substr(_cForn,8,2)

		dbSelectArea("SE2")
		dbSetOrder(6)
		if dbSeek(xFilial("SE2")+_cFornece+_cLoja+_cPrefixo+_cNum+_cParcela,.t.)
			while !eof() .and. se2->e2_fornece == _cFornece .and. se2->e2_loja == _cLoja .and. se2->e2_prefixo == _cPrefixo;
			    .and. se2->e2_num == _cNum .and. se2->e2_parcela == _cParcela 
				dbSelectArea("SE2")
				reclock("SE2",.f.)
				se2->e2_datalib := dDatabase 
	 			msunlock()
				conout ('Titulo Liberado ' + _cTitulo ) 
				dbSkip()
				Loop
			end 
	   else
			Conout("Nao foi encontrado titulo no SE2 para Liberacao!!!")
	   endif
  Next 

  //define variaveis 
  _cNumero  := oProcess:oHtml:RetByName('Numero')
  _cComent  := oProcess:oHtml:RetByName('Comentario')
  _aRetorno := {} 
  For i:=1 to Len(oProcess:oHtml:RetByName("t2.opc"))
	    _cFilial  := oProcess:oHtml:RetByName('t2.filial')[i]
    	_cTitulo  := oProcess:oHtml:RetByName('t2.titulo')[i] 
	    _cEmissao := oProcess:oHtml:RetByName('t2.emissao')[i]
    	_cVencrea := oProcess:oHtml:RetByName('t2.vencrea')[i]          
	    _cFornece := oProcess:oHtml:RetByName('t2.fornece')[i]
	    _nSaldo   := oProcess:oHtml:RetByName('t2.vlsaldo')[i]
	    _nTotal   := oProcess:oHtml:RetByName('t2.vltotal')[i]
	    
		aAdd(_aRetorno,{_cFilial,_cTitulo,_cEmissao,_cVencrea,_cFornece,_nSaldo,_nTotal})
  Next		

  //envia o retorno para  o usuário que enviou a autorização de pagamento 
  //Abre o HTML criado. Repare que o mesmo se encontra abaixo do RootPath
  oProcess:NewTask( "RetLiberacao", "\HTML\AUTORIZAPGRETORNO.HTM" )                                 
  oProcess:cSubject := "Retorno da Autorizacao de Pagamento : " + _cNumero 

  oHTML    := oProcess:oHTML
  oHtml:ValByName( "numeroret" , _cNumero )	
  oHtml:ValByName( "data"      , dDatabase )	
  oHtml:ValByName( "hora"      , time()    )	
  
  For i:=1 to Len(_aRetorno)
		AAdd( (oHtml:ValByName( "t1.filial"  )), _aRetorno[i,1] )		
        AAdd( (oHtml:ValByName( "t1.titulo"  )), _aRetorno[i,2] )		                     
	    AAdd( (oHtml:ValByName( "t1.emissao" )), _aRetorno[i,3] )
   		AAdd( (oHtml:ValByName( "t1.vencrea" )), _aRetorno[i,4] )		                     
        AAdd( (oHtml:ValByName( "t1.fornece" )), _aRetorno[i,5] )		       
	    AAdd( (oHtml:ValByName( "t1.vlsaldo" )), _aRetorno[i,6] )		              	    
   		AAdd( (oHtml:ValByName( "t1.vltotal" )), _aRetorno[i,7] )		              
  Next 	   

  oHtml:ValByName( "comentario" , _cComent  )	

  _emaild := alltrim(GetMV("MV_PGENVIO"))  
  _emailf := alltrim(GetMV("MV_PGRETOR"))  
  oHtml:ValByName( "emaildest", _emaild )	
  oHtml:ValByName( "emailfrom", _emailf )	
	
  oProcess:cTo := _emailf
  oProcess:Start()            

  alert("retornando liberacao ") 

  RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10005',,"BI")

Return


User Function APGTimeOut( oProcess )
  ConOut("Funcao de TIMEOUT executada")
  oProcess:Finish()  //Finalizo o Processo
Return 

/*

User Function SPCNotificar(cResultado, cNumPed)

Local aCond:={},nTotal := 0,cMailID,cSubject
Local nFrete  := 0 
Local nImp    := 0

	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7")+cNumPed)
    //Abre o HTML criado. Repare que o mesmo se encontra abaixo do RootPath
	oProcess := TWFProcess():New( "000002", "Notificacao do Pedido de Compras" )
	oProcess:NewTask( "Aprovação", "\WORKFLOW\HTML\WFW120P2.HTM" )
	oProcess:cSubject := "Aprovacao de Pedido de Compra"
	oHTML := oProcess:oHTML
 		                                        
	cSubject := "RESULTADO DE PROCESSO DE APROVACAO DO PEDIDO No " + SC7->C7_NUM
    
	If cResultado = 'S'
		oHtml:ValByName( "RESULTADO", "A P R O V A D O" )	
	Else
		oHtml:ValByName( "RESULTADO", "R E P R O V A D O" )		
	EndIf
	
	oHtml:ValByName( "C7_NUM", SC7->C7_NUM )
  */
  		
	/*** Preenche os dados do cabecalho ***/
    /*
	oHtml:ValByName( "C7_EMISSAO", SC7->C7_EMISSAO )
   
	dbSelectArea('SA2')
	dbSetOrder(1)
	dbSeek(xFilial('SA2')+SC7->C7_FORNECE)
	oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE +" / "+SA2->A2_NOME) 

    //Pego as condicoes de Pagamento
    dbSelectArea('SE4')
    DBSETORDER(1)
    dbSeek(xFilial('SE4'))
	oHtml:ValByName( "E4_DESCRI", SC7->C7_COND +" / "+SE4->E4_DESCRI)

	dbSelectArea('SC7')
	dbSetOrder(1)
	dbSeek(xFilial('SC7')+cNumPed)
    While !Eof() .and. C7_NUM = cNumPed
       nTotal  := nTotal + C7_TOTAL
       nFrete  := nFrete + C7_FRETE
       nImp    := nFrete +  (C7_VALIPI + C7_VALICM)
       AAdd( (oHtml:ValByName( "t1.1" )),C7_ITEM )		
       AAdd( (oHtml:ValByName( "t1.2" )),C7_PRODUTO )		       
       dbSelectArea('SB1')
       dbSetOrder(1)
       dbSeek(xFilial('SB1')+SC7->C7_PRODUTO)
       dbSelectArea('SC7')
       AAdd( (oHtml:ValByName( "t1.3" )),SB1->B1_DESC )		              
       AAdd( (oHtml:ValByName( "t1.4" )),SB1->B1_UM )		              
       AAdd( (oHtml:ValByName( "t1.5" )),TRANSFORM( C7_QUANT,'@E 99,999.99' ) )		              
       AAdd( (oHtml:ValByName( "t1.6" )),TRANSFORM( C7_PRECO,'@E 99,999.99' ) )		                     
       AAdd( (oHtml:ValByName( "t1.8" )),TRANSFORM( C7_TOTAL,'@E 99,999.99' ) )		                     
       AAdd( (oHtml:ValByName( "t1.9" )),DTOC(SC7->C7_DATPRF) )
       dbSkip()
    Enddo

	AAdd( (oHtml:ValByName("t2.1" )),TRANSFORM( nTotal,'@E 99,999.99' ))
	AAdd( (oHtml:ValByName("t2.2" )),TRANSFORM( nFrete,'@E 99,999.99' ))		              	    
	AAdd( (oHtml:ValByName("t2.3" )),TRANSFORM( nImp,'@E 99,999.99' ))	              	    

	AAdd( (oHtml:ValByName("t3.1")) ,SC7->C7_OBS)
     
	oProcess:ClientName( Subs(cUsuario,7,15))
	oProcess:cTo := "administrador@local.com"  //Coloque aqui o destinatario do Email.
	oProcess:Start()            
Return 
*/                  
