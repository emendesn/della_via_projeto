#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARQRECEP  ºAutor  ³Microsiga           º Data ³  05/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta funcao realiza a importacao de arquivos atraves da    º±±
±±º          ³ funcao MsExecAuto ou gravando diretamente nas tabelas do   º±±
±±º          ³ Protheus podendo ser utilizada tambem como workflow.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Acelerador de Implantacao                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ArqRecep(aParams) 

Local lMenu := (aParams == NIL)

If lMenu
	Processa({|| Importa(aParams)},"Importando Arquivos")
Else
	Importa(aParams)
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Importa   ºAutor  ³Microsiga           º Data ³  05/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta funcao realiza a importacao de arquivos atraves da    º±±
±±º          ³ funcao MsExecAuto ou gravando diretamente nas tabelas do   º±±
±±º          ³ Protheus podendo ser utilizada tambem como workflow.       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Importa(aParams)

Local cPath			:= Alltrim( GetMv("MV_ARQREC") )
Local aDiret		:= Directory( cPath+"*.TXT")
Local cLinha		:= cChave	:= ""
Local cMsg			:= cTipo		:= ""
Local cOcorrencia	:= ""
Local nVal			:= 0
Local nPosCpo		:= nVal	:= 0
Local lProcessado   := .F.
Local cAliasBusca,nOrdAlias,cIdTran
Local nProc         := 0
Local nProc2        := 0
Local i				:= 0  
Local nItem         := 0
Private lMenu			:= (aParams == NIL)
Private cLayCab		:= ""
Private nTamLin		:= 0
Private lAuto			:= .F.
Private aAutoItens	:= {}
Private aLayout,aConsiste,nHandle
Private aAutoCab,nOpc
Private cCampo,cConteudo,cTipo
             
cMsg := "Arquivos encontrados no diretorio (MV_ARQREC) "+cPath+": " + Chr(13) + Chr(10)
For i:=1 To Len(aDiret)
	cMsg += aDiret[i,1] + Chr(13) + Chr(10)
Next	

If lMenu
	cMsg += "Prosseguir a importacao?"
	If ! MsgYesNo(cMsg,"Confirma")
	    MsgAlert("Importacao nao realizada.")
		Return
	Endif
Else
	ConOut(cMsg)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processos iniciais...                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nItem	:= 1 To Len(aDiret)

	If lMenu
		ProcRegua(1000)
	Endif
	
	nProc  := 0
	nProc2 := 0
	
	nHandle	:= FT_FUSE(cPath+aDiret[nItem,1])
	
	While ! FT_FEOF()
	
		If lMenu
			IncProc("Registros processados: "+Alltrim(Str(nProc2)))
			nProc ++
			nProc2 ++
			If nProc > 1000
				ProcRegua(1000)
				nProc := 0
			Endif
		Endif
		
		cLinha	:= FT_FREADLN()
		cIdTran	:= Substr(cLinha,1,4)     // Identificador do Tipo de Transacao
		
		dbSelectArea("FXF")
		dbSetOrder(1)
		If !dbSeek(xFilial("FXF")+cIdTran,.F.)
			cMsg	:= "Transacao " + cIdTran + " nao encontrada na tabela de parametros do sincronizador (FXF). Verifique!!!"
			If lMenu
				MsgAlert(cMsg)
			Else
				ConOut(cMsg)
			EndIf
			FT_FSKIP(1)
			Loop
		Endif
		
		cLayCab		:= IIf(!Empty(FXF->FXF_IDLAYC),FXF->FXF_IDLAYC,cLayCab)
		aConsiste	:= U_PosConsiste(cIdTran) // Busco as Ordens para Validacao
		aLayout		:= U_MtLayOutRec(cIdTran) // Trago o Lay out de Abertura de Arquivos
		cAliasBusca	:= FXF->FXF_ALIAS
		nOrdAlias	:= FXF->FXF_ORDEM
		lAuto		:= !Empty(FXF->FXF_AUTO)     
		// aguardar criar parametro para ver se a integridade referencial na v 8.11 esta habilitada ou nao
		lIntegridade811 := .F. // GetNewPar("",.F.)

		// 01/12/04 - quando for versao 8.11 para forcar abertura dos arquivos,
		// pois se nao colocar na chamada do menu nao ira abrir os arquivos
		If Select(cAliasBusca) <= 0
			ChkFile(cAliasBusca)
		Endif	
		
		If ( Empty(aConsiste) .Or. Empty(aLayOut) .Or. ;
			Select(cAliasBusca) <= 0 .Or. Len(cLinha) <> nTamLin )
			cMsg	:= "Transacao " + cIdTran + " possui inconsistencias no dicionario de parametros: "
			If Empty(aConsiste)
				 cMsg += "nao existem sequencias configuradas na tabela FXF para a transacao "+cIdTran+"."
			ElseIf Empty(aLayOut)
				 cMsg += "nao existem campos configurados na tabela FXE."
			ElseIf Len(cLinha) <> nTamLin
				 cMsg += "tamanho da linha do arquivo de origem nao confere com o tamanho dos campos configurados no lay-out. Verifique lay-out do arquivo origem."
			ElseIf Select(cAliasBusca) <= 0
				 cMsg += "arquivo "+cAliasBusca+" nao esta aberto no momento para ser preenchido. Coloque a chamada do arquivo no menu."
			ElseIf lIntegridade811 .And. ! lAuto
				 cMsg += "a integridade referencial esta ativada e a funcao MsExecAuto() nao esta configurada para o arquivo "+cAliasBusca+". A importacao nao pode ser realizada pois podera comprometer a integridade dos dados."
			Endif
			If lMenu
				MsgAlert(cMsg)
			Else
				ConOut(cMsg)
			EndIf
			FT_FSKIP(1)
			Loop
		Endif
		
		cChave := ""
		For i:=1 To Len(aConsiste)
			cChave += Substr(cLinha,aConsiste[i,1],aConsiste[i,2])
		Next
		
		dbSelectarea(cAliasBusca) // Posiciona o Alias para a importacao e Monto a Consistencia do Arquiv
		dbSetOrder(nOrdAlias)
		dbSeek(cChave)
		
		cTipoTran := Upper(FXF->FXF_TPTRAN)
		
		dbSelectarea(cAliasBusca) // Posiciona o Alias para a importacao e Monto a Consistencia do Arquiv
		
		If cTipoTran=="I"		// Inclusao
			If lAuto
				nOpc	:= 3
				U_PreparaAuto(aLayout,cLinha)
			Else
				If RecLock(cAliasBusca,!dbSeek(cChave))
					For nVal := 1 to len(aLayout)
						cCampo    	:= aLayout[nVal,5]
						CConteudo 	:= Substr( cLinha, aLayOut[nVal,2],aLayOut[nVal,3] )
						cTipo 		:= U_CpoGetTipo(cCampo)
						cConteudo 	:= U_Conv2Tipo(cConteudo,cTipo)
						dbSelectarea(cAliasBusca)
						If !Empty(cCampo) .and. (nPosCpo := FieldPos(cCampo)) > 0
							Fieldput(nPosCpo,CConteudo)
							If aLayOut[nVal,6] <> NIL
								Eval(aLayOut[nVal,6])
							Endif
						Endif
					Next
					MsUnlock()
				EndIf
			Endif
			lProcessado := .T.
			
		ElseIf cTipoTran=="A" 	// Alteracao
			
			If lAuto
				nOpc	:= 4
				U_PreparaAuto(aLayout,cLinha)
			ElseIf RecLock(cAliasBusca,!dbSeek(cChave))
				For nVal := 1 to len(aLayout)
					cCampo    	:= aLayout[nVal,5]
					CConteudo 	:= Substr( cLinha, aLayOut[nVal,2],aLayOut[nVal,3] )
					cTipo 		:= U_CpoGetTipo(cCampo)
					cConteudo 	:= U_Conv2Tipo(cConteudo,cTipo)
					dbSelectarea(cAliasBusca)
					If !Empty(cCampo) .and. (nPosCpo := FieldPos(cCampo)) > 0
						Fieldput(nPosCpo,CConteudo)
						If aLayOut[nVal,6] <> NIL
							Eval(aLayout[nVal,6])
						Endif
					Endif
				Next
				MsUnlock()
			Endif
			lProcessado := .T.

		Else			// Exclusao
			
			If lAuto
				nOpc	:= 5
				U_PreparaAuto(aLayout,cLinha)
			Else
				If !dbSeek(cChave)
					cOcorrencia := "01" // Registro nao Encontrado
				Else
					If !RecLock( cAliasBusca ,.F.,.T. )
						cOcorrencia := "04" // Erro ao travar - Exclusao
					Else
						dbDelete()
						MsUnlock()
					Endif
				Endif
			EndIf
			lProcessado := .T.

		EndIf
		
		FT_FSKIP(1)
	EndDo
	
	FClose(nHandle)
Next

If lProcessado
	cMsg := "Final da Importacao!!!"
Else
	cMsg := "Importacao nao realizada. Verifique!!!"
Endif	

If lMenu
	MsgAlert(cMsg)
Else
	ConOut(cMsg)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PosConsisteºAutor  ³Microsiga          º Data ³  05/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna array com as posicoes dos campos a serem           º±±
±±º          ³ consistidos.                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PosConsiste(cIdTran)

Local  aSequencias := {}  // Array que Agregara as Sequencias
Local aAreaFXF

dbSelectArea("FXF")
aAreaFXF	:= GetArea()
dbSetOrder(1)
dbSeek(xFilial("FXF") + cIdTran , .F. )
While !Eof() .And. Alltrim(FXF_IDTRAN) == Alltrim(cIdTran)
	AAdd(aSequencias,{FXF->FXF_CHPINI,FXF->FXF_CHTAM})
	dbSkip()
Enddo

RestArea(aAreaFXF)

Return(aSequencias)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MtLayOutRecºAutor  ³Microsiga          º Data ³  05/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para buscar dentro do dicionarios de posicoes de    º±±
±±º          ³ arquivos quais os dados que deverao ser atualizados e      º±±
±±º          ³ consistidos. Para isto , os arquivos FXD e FXE serao       º±±
±±º          ³ acionados e as sequencias serao buscadas.                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MtLayoutRec(cIdTran)

Local aItens	:= {}  // Itens para Atualizacao do Arquivo
Local nPosIni	:= Len(cIdTran) + 1
Local nTam		:= 0
Local xFunc

nTamLin := Len(cIdTran)

// Este Bloco Prepara as Informacoes de Cada Posicao para Verificacao
dbSelectArea("FXE")
dbSetOrder(1)
dbSeek( xFilial("FXE") + FXF->FXF_IDLAY , .F. )
While !Eof() .And. xFilial("FXE") == FXE_FILIAL .And. FXE_IDLAY  == FXF->FXF_IDLAY
	nTam		:= TamSX3(Alltrim(FXE_CAMPO))[1]
	nTamLin	+= nTam
	xFunc		:= Nil
	If !Empty(FXE_CAMPO)
		If "(" $ FXE_FUNCAO
			xFunc	:= &("{ || " + Alltrim(FXE_FUNCAO) + "}")
		Endif
	EndIf
	AAdd(aItens,{ FXE_SEQUEN , nPosIni , nTam , FXE_ALIAS , Alltrim(FXE_CAMPO) , xFunc } )
	nPosIni += nTam
	DbSkip()
Enddo

Return(aItens)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CpoGetTipo ºAutor  ³Microsiga          º Data ³  05/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta funcao recebe como parametro o codio da transacao     º±±
±±º          ³ e busca todas as amarracoes da tabela do banco com o tipo  º±±
±±º          ³ de tratamento com o alias que ele chama.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CpoGetTipo(cCampo)

Local cRet := "C"

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek(cCampo)

cRet := SX3->X3_TIPO

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Conv2Tipo ºAutor  ³Microsiga          º Data ³  05/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para converter tipos diferentes de variaveis para   º±±
±±º          ³ o tipo caracter.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Conv2Tipo(cConteudo,cTipo)

If cTipo == "C"
	If ValType(cConteudo) == "D"
		cConteudo := DtoC(cConteudo)
	Elseif ValType(cConteudo) == "N"
		cConteudo := Str(cConteudo)
	Endif
Elseif cTipo == "D"
	If ValType(cConteudo) == "C"
		cConteudo := CtoD(cConteudo)
	Endif
Elseif cTipo == "N"
	If ValType(cConteudo) == "C"
		cConteudo := Val(cConteudo)
	Endif
Endif

Return(cConteudo)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PreparaAutoºAutor  ³Microsiga          º Data ³  25/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preparacao da rotina automatica                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PreparaAuto(aLayout,cLinha)
                                                                                  
Local nVal		:= 0
Local cArqItem	:= ""
Private aAuto			:= {}
Private lMsHelpAuto	:= .T.
Private lMsErroAuto	:= .F.

For nVal := 1 to len(aLayout)
	cCampo    	:= aLayout[nVal,5]
	CConteudo 	:= Substr( cLinha, aLayOut[nVal,2],aLayOut[nVal,3] )
	cTipo 		:= U_CpoGetTipo(cCampo)
	cConteudo 	:= U_Conv2Tipo(cConteudo,cTipo)
	AAdd(aAuto,{cCampo,cConteudo,aLayout[nVal,6]})
Next

If Empty(cLayCab)
	If !lMenu
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preparacao do ambiente para rotina workflow        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PREPARE ENVIRONMENT EMPRESA APARAMS[1,1] FILIAL APARAMS[1,2] TABLES FXF->FXF_ALIAS
	EndIf
	U_ProcessaAuto()
	If !lMenu
		RESET ENVIRONMENT
	EndIf
Else
	If cLayCab == FXF->FXF_IDLAY //esta posicionado num cabecalho
		aAutoCab	:= aClone(aAuto)
		If !lMenu
			PREPARE ENVIRONMENT EMPRESA APARAMS[1,1] FILIAL APARAMS[1,2] TABLES FXF->FXF_ALIAS, cArqItem
		EndIf
		U_ProcessaAuto()		
		If !lMenu
			RESET ENVIRONMENT
		EndIf
		aAutoItens	:= {}
	Else //Esta posicionado num item
		AAdd(aAutoItens,aAuto)
		cArqItem	:= FXF->FXF_ALIAS
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcessaAutoºAutor  ³Microsiga         º Data ³  25/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento de rotina automatica                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ProcessaAuto()

Local cMsg	:= ""
Local	cAuto	:= Alltrim(FXF->FXF_AUTO)
Local cOpc1	:= IIf(nOpc=3,"inclusao" ,IIf(nOpc=4,"alteracao","exclusao" ))
Local cOpc2	:= IIf(nOpc=3,"incluidos",IIf(nOpc=4,"alterados","excluidos"))
Private lMsHelpAuto	:= .T.
Private lMsErroAuto	:= .F.
Private bComando := &("{|| MsExecAuto(" + cAuto + ")}")

Begin Transaction

Eval(bComando)

If lMsErroAuto
	If lMenu
		MostraErro()
	Else
		ConOut("Erros encontrados na " + cOpc1 + " de dados tabela " + FXF->FXF_ALIAS + ".")
	EndIf
	DisarmTransaction()
	break
EndIf

End Transaction

Return