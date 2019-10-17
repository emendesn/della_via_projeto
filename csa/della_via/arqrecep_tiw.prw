#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ArqRecep  ºAutor  ³Microsiga           º Data ³  05/09/00   º±±
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

//Local aDiret		:= Directory( cPath+"*.TXT")
Local aDiret		:= ""
Local cMsg			:= ""
Local lValida		:= .F.
Local i, nItem		:= .F.

//Local cPath			:= Alltrim( GetMv("MV_ARQREC") )
Private cPath			:= ""
Private lMenu		:= (aParams == NIL)

dbSelectArea("FXF")
dbSetOrder(1)

dbSelectArea("FXE")
dbSetOrder(1)

_cPerg:="ARQREC"
_aRegs:={}
AAdd(_aRegs,{_cPerg,"01","Diretorio origem?"  ,"Diretorio origem?"  ,"Diretorio Origem?"  ,"mv_ch1","C", 30,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
ValidPerg(_aRegs,_cPerg)
Pergunte(_cPerg,.F.)

If lMenu
	Pergunte(_cPerg,.T.)                    
	cPath := Alltrim(mv_par01)
	cMsg := "Arquivos encontrados no diretorio "+cPath+": " + Chr(13) + Chr(10)
Else	
	cPath := Alltrim( GetMv("MV_ARQREC") )
	cMsg := "Arquivos encontrados no diretorio (MV_ARQREC) "+cPath+": " + Chr(13) + Chr(10)
Endif
	
aDiret	:= Directory( cPath+"*.TXT")

For i:=1 To Len(aDiret)
	cMsg += aDiret[i,1] + Chr(13) + Chr(10)
Next	

If lMenu
	cMsg += "Prosseguir a importacao?"
	If !MsgYesNo(cMsg,"Confirma")
	    MsgAlert("Importacao nao realizada.","Importacao de Dados")
		Return
	Endif
Else
	ConOut(cMsg)
Endif

If lMenu
	MsgRun('Criando Arquivo de Log...', , {|| CriaLog()})

	For nItem	:= 1 To Len(aDiret)
	
		cArqTxt := aDiret[nItem,1]

		nHandle	:= FT_FUSE(cPath+cArqTxt)
		
		FT_FGOTOP()
	
		Processa({|| lValida := U_ValidaArq()},"Validando Arquivos...")	
		
		If lValida
			Processa({|| lProcessado := Importa()},"Importando Arquivos...")	
	    EndIf
	
		FClose(nHandle)
		MostraErro()
	Next

	If MsgYesNo( " Deseja imprimir o Log de Ocorencias? " , "Importacao " )
		U_LOGR998()
	Endif

Else
	CriaLog()

	For nItem	:= 1 To Len(aDiret)
	
		cArqTxt := aDiret[nItem,1]
	
		nHandle	:= FT_FUSE(cPath+cArqTxt)
		
		FT_FGOTOP()
	
		lValida := U_ValidaArq()

		If lValida
			Importa()
	    EndIf
		FClose(nHandle)
	Next
EndIf

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

Static Function Importa()
Local aOcorrencia	:= {}
Local cLinha		:= cChave	:= ""
Local nVal			:= 0
Local nPosCpo		:= nVal		:= 0
Local lProcessado   := .T.
Local cAliasBusca,nOrdAlias,cIdTran
Local nProc         := 0
Local nProc2        := 0
Local i				:= 0  
//Local nItem         := 0

Private cLayCab		:= ""
Private nTamLin		:= 0
Private lAuto		:= .F.
Private aAutoItens	:= {}
Private aLayout,aConsiste,nHandle
Private aAutoCab,nOpc
Private cCampo,cConteudo,cTipo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processos iniciais...                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lMenu
	ProcRegua(1000)
Endif

nProc  := 0
nProc2 := 0

FT_FGOTOP()

While !FT_FEOF()
	
	If lMenu
		IncProc("Registros Importados: "+Alltrim(Str(nProc2)))
		nProc ++
		nProc2 ++
		If nProc > 1000
			ProcRegua(1000)
			nProc := 0
		Endif
	Endif
	
	cLinha	:= FT_FREADLN()
	cLinha	:= StrTran(cLinha,"|")   // StrTran(Alltrim(cLinha),"|")

	cIdTran	:= Substr(cLinha,1,4)     // Identificador do Tipo de Transacao
	
	dbSelectArea("FXF")
	dbSetOrder(1)

	cLayCab		:= IIf(!Empty(FXF->FXF_IDLAYC),FXF->FXF_IDLAYC,cLayCab)
	aConsiste	:= U_PosConsiste(cIdTran) // Busco as Ordens para Validacao
	aLayout		:= U_MtLayOutRec(cIdTran) // Trago o Lay out de Abertura de Arquivos
	cAliasBusca	:= FXF->FXF_ALIAS
	nOrdAlias	:= FXF->FXF_ORDEM
	lAuto		:= !Empty(FXF->FXF_AUTO)     
	cChave		:= ""

	For i:=1 To Len(aConsiste)
		cChave += Substr(cLinha,aConsiste[i,1],aConsiste[i,2])
	Next
	
	dbSelectarea(cAliasBusca) // Posiciona o Alias para a importacao e Monto a Consistencia do Arquiv
	dbSetOrder(nOrdAlias)
	dbSeek(cChave)
	
	cTipoTran := Upper(FXF->FXF_TPTRAN)
	
	dbSelectarea(cAliasBusca) // Posiciona o Alias para a importacao e Monto a Consistencia do Arquiv
	
	If cTipoTran=="3"		// Inclusao
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
		
	ElseIf cTipoTran=="4" 	// Alteracao
		
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

	ElseIf cTipoTran == "5"			// Exclusao

		If lAuto
			nOpc	:= 5
			U_PreparaAuto(aLayout,cLinha)
		Else
			If !dbSeek(cChave)
				AADD(aOcorrencia, { cArqTxt, "Linha "+ STR(nProc2,6) +", Registro nao encontrado na tabela "+cAliasBusca+"!"})
				lProcessado := .F.
			Else
				If !RecLock( cAliasBusca ,.F.,.T. )
					AADD(aOcorrencia, { cArqTxt, "Linha "+ STR(nProc2,6) +", Erro ao travar registro - Exclusao "+cAliasBusca+"!"})
					lProcessado := .F.
				Else
					dbDelete()
					MsUnlock()
				Endif
			Endif
		EndIf

	EndIf
	
	FT_FSKIP(1)
EndDo

If lProcessado
	AADD(aOcorrencia, { cArqTxt, "Arquivo Importado!"})
EndIf

GravaLog(aOcorrencia)

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

If Empty(cLayCab)	//Não contem cabecalho
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

Local cMsg		:= ""

Local cAuto		:= Alltrim(FXF->FXF_AUTO)
Local cOpc1		:= IIf(nOpc=3,"inclusao" ,IIf(nOpc=4,"alteracao","exclusao" ))
Local cOpc2		:= IIf(nOpc=3,"incluidos",IIf(nOpc=4,"alterados","excluidos"))
Local aValida	:= {}

Private lMsHelpAuto	:= .T.
Private lMsErroAuto	:= .F.
Private bComando := &("{|| MsExecAuto(" + cAuto + ")}")

Begin Transaction

Eval(bComando)

If lMsErroAuto
//	If lMenu
//		MostraErro()
//	Else
		AADD(aValida, {cArqTxt, "Erros encontrados na " + cOpc1 + " de dados tabela " + FXF->FXF_ALIAS + "."})

//		ConOut("Erros encontrados na " + cOpc1 + " de dados tabela " + FXF->FXF_ALIAS + ".")
//	EndIf
	DisarmTransaction()
	
	GravaLog(aValida)	
	
	break
EndIf

End Transaction

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidaArq   ºAutor  ³Microsiga         º Data ³  25/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento de rotina automatica                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ValidaArq()

Local nProc		:= 0
Local nProc2	:= 0
Local cLinha	:= ""
Local cIdTran	:= ""
Local aValida	:= {}
Local lRet 		:= .T.

Private cLayCab		:= ""
//Private aConsiste	:= ""
//Private aLayout 	:= ""
Private lAuto		:= .F.
Private nTamLin		:= 0

nProc	:= 0
nProc2	:= 0

While !FT_FEOF()

	If lMenu
		IncProc("Registros Validados: "+Alltrim(Str(nProc2)))
		nProc ++
		nProc2 ++
		If nProc > 1000
			ProcRegua(1000)
			nProc := 0
		Endif
	Endif
	
	cLinha	:= FT_FREADLN()
	cLinha	:= StrTran(cLinha,"|")   // StrTran(Alltrim(cLinha),"|")

	cIdTran	:= Substr(cLinha,1,4)     // Identificador do Tipo de Transacao
	
	dbSelectArea("FXF")
	dbSetOrder(1)
	If !dbSeek(xFilial("FXF")+cIdTran,.F.)
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Transacao " + cIdTran + " nao encontrada na tabela de parametros do sincronizador (FXF)."})
		lRet := .F.
		FT_FSKIP(1)
		Loop
	Endif
	                                          
	cLayCab		:= IIf(!Empty(FXF->FXF_IDLAYC),FXF->FXF_IDLAYC,cLayCab)
	lAuto		:= !Empty(FXF->FXF_AUTO)     
	
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

/*	
	dbSelectArea("FXE")
	dbSetOrder(1)
	
	dbSelectArea("FXF")
	dbSetOrder(1)


	If !dbSeek(xFilial("FXF") + cIdTran , .F. )
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Nao existem sequencias configuradas na tabela FXF para a transacao "+cIdTran+"."})
		lRet := .F.
	ElseIf !(dbSeek( xFilial("FXE") + FXF->FXF_IDLAY , .F. ))
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Nao existem campos configurados na tabela FXE."})
		lRet := .F.
	ElseIf Len(cLinha) <> nTamLin
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Tamanho da linha do arquivo de origem nao confere com o tamanho dos campos configurados no lay-out. Verifique lay-out do arquivo origem."})
		lRet := .F.
	ElseIf Select(FXF->FXF_ALIAS) <= 0
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Arquivo "+FXF->FXF_ALIAS+" nao esta aberto no momento para ser preenchido. Coloque a chamada do arquivo no menu."})
		lRet := .F.
	ElseIf lIntegridade811 .And. !lAuto
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". A integridade referencial esta ativada e a funcao MsExecAuto() nao esta configurada para o arquivo "+FXF->FXF_ALIAS+". A importacao nao pode ser realizada pois podera comprometer a integridade dos dados."})
		lRet := .F.
	Endif
*/

	If Empty(aConsiste)
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Nao existem sequencias configuradas na tabela FXF para a transacao "+cIdTran+"."})
		lRet := .F.
	ElseIf Empty(aLayOut)
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Nao existem campos configurados na tabela FXE."})
		lRet := .F.
	ElseIf Len(cLinha) <> nTamLin
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Tamanho da linha do arquivo de origem nao confere com o tamanho dos campos configurados no lay-out. Verifique lay-out do arquivo origem."})
		lRet := .F.
	ElseIf Select(cAliasBusca) <= 0
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". Arquivo "+cAliasBusca+" nao esta aberto no momento para ser preenchido. Coloque a chamada do arquivo no menu."})
		lRet := .F.
	ElseIf lIntegridade811 .And. !lAuto
		AADD(aValida, {cArqTxt, "Inconsistencia na Linha " + STR(nProc2,6) + ". A integridade referencial esta ativada e a funcao MsExecAuto() nao esta configurada para o arquivo "+FXF->FXF_ALIAS+". A importacao nao pode ser realizada pois podera comprometer a integridade dos dados."})
		lRet := .F.
	Endif

	FT_FSKIP(1)
	Loop
EndDo

If lRet
	AADD(aValida, {cArqTxt, "Nenhuma Inconsistencia encontrada!"})
EndIf

GravaLog(aValida)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaLog  º Autor ³ AP6 IDE            º Data ³  24/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera arquivo texto com as inconsistencias encontradas      º±±
±±º          ³ na importacao dos arquivos                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaLog()

//Local cPath			:= Alltrim( GetMv("MV_ARQREC") )

Private cLogArq 	:= cPath+"LOGIMP.DAT"
Private cLogArqBkp	:= cPath+"LOGIMP.BKP"
Private nHdl		:= 0

If File(cLogArq)
	If File(cLogArqBkp)
		fErase(cLogArqBkp)
	EndIf
	fRename(cLogArq,cLogArqBkp)
EndIf

nHdl := fCreate(cLogArq)


If nHdl == -1 .And. lMenu
    MsgAlert("O arquivo de nome "+cLogArq+" nao pode ser executado! Verifique.","Atencao!")
    Return
Endif

FClose( nHdl )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaLog  º Autor ³ AP6 IDE            º Data ³  24/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera arquivo texto com as inconsistencias encontradas      º±±
±±º          ³ na importacao dos arquivos                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GravaLog(aRegistro)

Local cLin		:= ""
//Local cPath		:= Alltrim( GetMv("MV_ARQREC") )
Local nTamLin	:= 0
Local i			:= 0

Private cLogArq	:= cPath+"LOGIMP.DAT"
Private nHdl	:= -1
Private cEOL	:= "CHR(13)+CHR(10)"


If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

if File( cLogArq )
	nHdl := FOpen(cLogArq, 2 )
	if nHdl >= 0
		FSeek( nHdl, 0, 2 )
	endif
else
	nHdl := FCreate(cLogArq)
endif

For i := 1 To Len(aRegistro)

	nTamLin := 270
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    cCpo := PADR(aRegistro[i][1],20)
    cLin := Stuff(cLin,01,20,cCpo)
    cCpo := PADR(aRegistro[i][2],250)
    cLin := Stuff(cLin,21,250,cCpo)

	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		cMsg := "Ocorreu um erro na gravacao do Log." 
		If lMenu
			If !MsgYesNo( cMsg + cEOL + "Deseja continuar?","Confirma!")
				Exit
			Endif
		Else
			ConOut(cMsg)
			Exit
		EndIf
	Endif
Next	

fClose(nHdl)

Return
