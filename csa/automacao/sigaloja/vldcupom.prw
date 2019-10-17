#include 'rwmake.ch'

User Function VldCupom(_nOpc,cCliente,cLoja)
Local _lRet 	:= .T.
Local _aArea	:= GetArea()             

If FunName() == "LOJA701"

	If _nOpc == 1
	
		// Cupom Fiscal
		// O sistema NAO deve permitir a emissao do cupom fiscal nas seguintes condicoes:
	
		// Condicao 1 : Cliente pessoa jurídica e com inscricao estadual e fora do estado.
		If SA1->A1_PESSOA == "J" .And. !Empty(SA1->A1_INSCR) .And. SA1->A1_EST <> GetMv("MV_ESTADO")
			_lRet	:= .F.
		Endif
		
		//Condicao 2 : Cliente pessos juridica e tipo revendedor
		If SA1->A1_PESSOA = "J" .And. SA1->A1_TIPO = "R"
			_lRet	:= .F.
		Endif
		
	ElseIf _nOpc == 2	
			// Nota Fiscal
			// Cliente pessoa fisica e tipo consumidor final			
			If SA1->A1_PESSOA = "J" .And. SA1->A1_TIPO = "F"
				_lRet	:= .F.                              
			Endif
	Endif			     
	
ElseIf Rtrim(FunName()) $ "TMKA271&MATA410"	 // Call Center ou Pedido de Vendas
	
		If _nOpc == 2 // Faturamento                          
		
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+cCliente+cLoja)
			
				// O sistema NAO deve permitir a geracao de pedido de vendas quando:
				// Cliente pessoa juridica e tipo consumidor final
				If SA1->A1_PESSOA = "F" .And. SA1->A1_TIPO = "F"                  
					MsgBox("Não é permitido gerar pedidos para cliente pessoa física e cosumidor final")
					If Rtrim(FunName()) $ "MATA410"
						M->C5_LOJACLI	:= Space(02)
					Endif	
					_lRet	:= .F.                              
				Endif                   
				
			Else
							
				_lRet := .F.
				
			Endif	
				
		Endif                   
		
Endif

Return _lRet		
		
			
			
		
			
				
	

	