	Local nCpoOper  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_OPER"}) // Posi��o do campo "UB_OPER" no aCols
	Local nItens    := 0                                               // Numero de itens n�o deletados no aCols
	Local lRet      := .T.                                             // Vari�vel de retorno na valida��o

	// Conta numero de itens n�o deletados no aCols
	For k=1 to Len(aCols)
		If !aCols[k,Len(aCols[k])]
			nItens++
		Endif
	Next

	// Varre aCols verificando as doa��es
	For k=1 to Len(aCols)
		If aCols[k,nCpoOper] = AllTrim(GetMv("FS_DEL038")) .and. !aCols[k,Len(aCols[k])]
			// Verifica se existe apenas 1 item para doa��o
			If nItens > 1
				Help(" ",1,"Doacao",,"N�o � permitido mais do que 1 item para NF de doa��o",4,1)
				lRet := .F.
				exit
			Endif
			// Verifica se o conv�nio � valido para a doa��o
			IF Empty(M->UA_CODCON) .OR. Posicione("PA6",1,xFilial("PA6")+M->UA_CODCON,"PA6->PA6_DOACAO") <> "S"
				Help(" ",1,"Doacao",,"Convenio inv�lido para esse tipo de opera��o",4,1)
				lRet := .F.
				exit
			Endif
		Endif
	Next	