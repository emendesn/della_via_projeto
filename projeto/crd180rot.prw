/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRD180ROT บAutor  ณPaulo Benedet       บ Data ณ  05/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCriacao de botใo no aRotina da tela de Fila Crediario.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณArray com opcoes do aRotina.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณPonto de entrada executado na criacao do aRotina da tela    บฑฑ
ฑฑบ          ณde Fila de Crediario (CRDA180).                             บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบMarcio    ณ30/08/06ณ      ณ- Mensagem de log no console do Servidor  s บฑฑ
ฑฑบDomingos  ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CRD180ROT()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializacao de Variaveis                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aRotEspec := {}             

AAdd(aRotEspec,{"Pesquisar Cliente","AxPesqui",0,1})
AAdd(aRotEspec,{"Analisa atual" , "P_CRD180Atu", 0 , 4})

Return aRotEspec

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao   ณCRA180Aval   บAutorณViviane M. Fernandesบ Data ณ  05/07/03   บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณAvaliacao do credito na fila do Crediario                    บฑฑ
ฑฑฬอออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametroณ                                                             บฑฑ
ฑฑฬอออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ SIGACRD 													  บฑฑ
ฑฑศอออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function CRD180Atu(cAlias, nRecno, nOpc )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializacao de Variaveis                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local aAreaSA1  := SA1->(GetArea())

Local cCliente  := ""
Local cLoja     := ""                                        
Local cMV_LibNiv:= SuperGetMv("MV_LIBNIV")
Local nTipo     := 3
Local lRet		:= .T.						// Retorno Default
Local nRecnoMAR := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o nivel do usuario logado for menor que a permissao de avalicao CONFIGURADA  ณ
//ณpelo MV_LIBNIV para o analista de Credito nao permite avaliar a proxima venda   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If cNivel < cMV_LibNiv
	MsgStop("Usuแrio sem permissใo de liberar cr้dito para cliente", "Usuแrio sem Permissใo de libera็ใo")
	lRet  := .F.
Else

	dbSelectArea( "MA7" )

	// Se for possivel dar um lock no registro liberar para a analise de credito
	If !CRDSEMABLO("CRDA180",Recno(),@nRecnoMAR)
		MsgStop("Este cliente ja estแ sendo analisado por outro atendente.")
		lRet  := .F.
	EndIf
	
	If lRet .AND. MA7->MA7_BLOQUE <> "4"
		MsgStop("Este cliente nใo pode ser liberado.")
		lRet  := .F.
	Endif
	
	If lRet
		If MA7->MA7_BLOQUE != "4"
			lRet  := .F.
			MsgStop( "Todos os cr้ditos estใo sendo analisados ou nใo existem registros para libera็ใo.", "Aten็ใo" )
		EndIf
		If lRet
			cCliente := MA7->MA7_CODCLI
			cLoja    := MA7->MA7_LOJA
			
			RegToMemory("MA7",.F.)
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek(xFilial("SA1")+cCliente+cLoja)
				RegToMemory("SA1",.F.)
				//Chamada da rotina de libera็ใo de cr้dito ( nTipo possui valor 3 )
				CRM010_006(nTipo,cCliente,cLoja,nRecnoMAR)
				
				lRet := .T.
			Endif
		Endif
	Endif
	
	// Liberar o bloqueio do registro (semaforo)
	dbSelectArea("MAR")

	//////////////////////////////////////////////////
	// 19/09/06 - Altera็ใo solicitada pelo Machima //  
	//////////////////////////////////////////////////
	If nRecnoMAR > 0
		DbGoto(nRecnoMAR)
		ConOut("4. CRDA080 - Exclui registro no MAR. Recno: " + MAR->MAR_REGIST + ;
				" Rotina: " + MAR->MAR_ROTINA + " Usuario MAR: " + MAR->MAR_USUARI + ;
				" Usuario: " + Substr(cUsuario,7,15) + ;
				" Cliente: " + cCliente+"/"+cLoja)     

		RecLock("MAR",.F.,.T.)
		dbDelete()
		MsUnlock()

		WriteSx2("MAR")
	Endif
EndIf

MsUnlockAll()

RestArea(aAreaSA1)
RestArea(aArea)

Return (lRet)
