#Include 'rwmake.ch'

User Function AltTesTmk()

Local nPosTES		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_TES"    })
Local nPosTpOp		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_OPER"   })
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_PRODUTO"})
Local nPosCF 		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_CF"     })
Local cCliente		:= M->UA_CLIENTE
Local cLoja			:= M->UA_LOJA
Local _nz                    
Local nNatu			:= N  


For _nz := 1 to len(aCols)	      

	//Somente para linhas preenchidas
	If !Empty(aCols[_nZ,nPosProduto])

		//Ajusta N para a rotina MaTesVia
		N := _nz
	
		Acols[_nz][nPosTes]:= u_MaTesVia(2,Acols[_nz][nPosTpOp],cCliente,cLoja,"C",Acols[_nz][nPosProduto],"UB_TES")                                  
//		Acols[_nz][nPosTes]:= u_MaTesVia(2,,M->UA_CLIENTE,M->UA_LOJA,"C",Acols[_nz][nPosProduto],"UB_TES")                                  
		
		//Altera o TES nas funcoes fiscais
		MaFisAlt("IT_TES", aCols[_nz,nPosTES], _nz)
	
		Acols[_nz][nPosCF]	:= MaFisRet(_nz,"IT_CF")                                                                                 
		
	Endif	
		
Next                    

N := nNatu

Return .T.	