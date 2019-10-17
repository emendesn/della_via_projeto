#Include 'rwmake.ch'

User Function AltTesFat()

Local nPosTES		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "C6_TES"    })
Local nPosTpOp		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "C6_OPER"   })
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosCF 		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "C6_CF"     })
Local cCliente		:= M->C5_CLIENTE
Local cLoja			:= M->C5_LOJACLI
Local _nz                    
Local nNatu			:= N  


For _nz := 1 to len(aCols)	      

	//Somente para linhas preenchidas
	If !Empty(aCols[_nZ,nPosProduto])

		//Ajusta N para a rotina MaTesVia
		N := _nz
	
		Acols[_nz][nPosTes]:= u_MaTesVia(2,Acols[_nz][nPosTpOp],cCliente,cLoja,"C",Acols[_nz][nPosProduto],"C6_TES")                                  
//		Acols[_nz][nPosTes]:= u_MaTesVia(2,,M->UA_CLIENTE,M->UA_LOJA,"C",Acols[_nz][nPosProduto],"UB_TES")                                  

		//Altera o TES nas funcoes fiscais
		MaFisAlt("IT_TES", aCols[_nz,nPosTES], _nz)
		
		A410MultT("C6_TES",Acols[_nz][nPosTes])
		
//		Acols[_nz][nPosCF]	:= MaFisRet(_nz,"IT_CF")                                                                                 
		
	Endif	

Next                    
                                                
N := nNatu       


Return .T.	