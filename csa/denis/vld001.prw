	Local nCpoOper  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_OPER"}) // Posição do campo "UB_OPER" no aCols
	Local nItens    := 0                                               // Numero de itens não deletados no aCols
	Local lRet      := .T.                                             // Variável de retorno na validação

	// Conta numero de itens não deletados no aCols
	For k=1 to Len(aCols)
		If !aCols[k,Len(aCols[k])]
			nItens++
		Endif
	Next

	// Varre aCols verificando as doações
	For k=1 to Len(aCols)
		If aCols[k,nCpoOper] = AllTrim(GetMv("FS_DEL038")) .and. !aCols[k,Len(aCols[k])]
			// Verifica se existe apenas 1 item para doação
			If nItens > 1
				Help(" ",1,"Doacao",,"Não é permitido mais do que 1 item para NF de doação",4,1)
				lRet := .F.
				exit
			Endif
			// Verifica se o convênio é valido para a doação
			IF Empty(M->UA_CODCON) .OR. Posicione("PA6",1,xFilial("PA6")+M->UA_CODCON,"PA6->PA6_DOACAO") <> "S"
				Help(" ",1,"Doacao",,"Convenio inválido para esse tipo de operação",4,1)
				lRet := .F.
				exit
			Endif
		Endif
	Next	