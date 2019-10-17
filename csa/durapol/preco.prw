USER FUNCTION Preco()
	Processa({|| RunProc()})
Return

Static Function RunProc()

dbSelectArea("ACP") // ITENS DA REGRA DE DESCONTO
dbSetOrder(1)
dbGotop()

ProcRegua(RecCount())

While !Eof()

  If ! DA1->( dbSeek(xFilial("DA1")+"001"+ACP->ACP_CODPRO,.F.) )
     ACP->( dbSkip() )
     Loop
  EndIf                
  /*
  If ACP->ACP_PERACR == 0
     ACP->( dbSkip() )
     Loop
  EndIf
  */
  
  IncProc('Produto '+ACP->ACP_CODPRO + ' do Cliente '+ ACP->ACP_CODREG)
  
  nPrecoVenda := 0
  
  If ACP->ACP_PERDES > 0    
     nPrecoVenda := DA1->DA1_PRCVEN * ( ( 100 - ACP_PERDES ) / 100 ) // desconto - Calcula Preco de Venda para o cliente
  ElseIf ACP->ACP_PERACR > 0
     nPrecoVenda := DA1->DA1_PRCVEN + ( ( DA1->DA1_PRCVEN * ACP_PERACR ) / 100 ) // acrescimo - Calcula Preco de Venda para o cliente  
 Else
     nPrecoVenda := DA1->DA1_PRCVEN
 EndIf
  
  RecLock("ACP",.F.)
//    ACP->ACP_PRCTAB := DA1->DA1_PRCVEN // Preco da tabela base
    ACP->ACP_PRCVEN := nPrecoVenda
  MsUnLock()
  
  ACP->( dbSkip() )

EndDo

RETURN