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

Local cLinha		:= ""
Local cMsg			:= cTipo		:= ""
Local cOcorrencia	:= ""
Local nPosCpo		:= nVal	:= 0
Local lProcessado   := .F.
Local nOrdAlias,cIdTran
Local nProc         := 0
Local nHandle
Local i, nVal, nItem	:= 0


Private cPath
Private aDiret		
Private lMenu		:= (aParams == NIL)
Private cLayCab		:= ""
Private nTamLin		:= 0
Private lAuto			:= .F.
Private aAutoItens	:= {} 
Private aLayout,aConsiste
Private aAutoCab,nOpc
Private cCampo,cConteudo,cTipo,_aRegs,_cPerg
Private cAliasBusca
Private nProc2 := 0
Private cChave	:= ""
          
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
	If ! MsgYesNo(cMsg,"Confirma")
	    MsgAlert("Importacao nao realizada.")
		Return
	Endif
Else
	ConOut(cMsg)
Endif

// Para preparar o log da inclusão de Clientes

CriaLog()


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
			IncProc("Registros processados "+Substr(cLinha,1,3)+" : "+Alltrim(Str(nProc2)))
			nProc ++
			nProc2 ++
			If nProc > 1000
				ProcRegua(1000)
				nProc := 0
			Endif
		Endif
		
		cLinha	:= FT_FREADLN()
		cLinha	:= StrTran(cLinha,"|")
		
		cIdTran	:= Substr(cLinha,1,4)     // Identificador do Tipo de Transacao
		
		dbSelectArea("FXF")
		dbSetOrder(1)
		If !dbSeek(xFilial("FXF")+cIdTran,.F.)
			cMsg	:= "Transacao " + cIdTran + " nao encontrada na tabela de parametros do sincronizador (FXF). Verifique!!!"
			//
			If lMenu
				MsgAlert(cMsg)
			Else
				ConOut(cMsg)
			EndIf
			//
			FT_FSKIP(1)
			Loop
		Endif
		
		cLayCab		:= IIf(!Empty(FXF->FXF_IDLAYC),FXF->FXF_IDLAYC,cLayCab)
		aConsiste	:= U_PosConsiste(cIdTran) // Busco as Ordens para Validacao
		aLayout		:= U_MtLayOutRec(cIdTran) // Trago o Lay out de Abertura de Arquivos
		cAliasBusca	:= FXF->FXF_ALIAS
		nOrdAlias	:= FXF->FXF_ORDEM
		lAuto		:= !Empty(FXF->FXF_AUTO)
		
		If Select(cAliasBusca) == 0
			ChkFile(cAliasBusca, .F.) // forca a abertura do arquivo, caso nao esteja aberto no menu
		EndIf

		If ( Empty(aConsiste) .Or. Empty(aLayOut) .Or. ; 
			Select(cAliasBusca) <= 0 .Or. Len(cLinha) <> nTamLin )
			cMsg	:= "Transacao " + cIdTran + " possui inconsistencias no dicionario de parametros: "
			If Empty(aConsiste)
				 cMsg += "nao existem sequencias configuradas na tabela FXF para a transacao "+cIdTran+"."
			ElseIf Empty(aLayOut)
				 cMsg += "nao existem campos configurados na tabela FXE."
			ElseIf Len(cLinha) <> nTamLin
				 cMsg += "tamanho da linha do arquivo de origem nao confere com o tamanho dos campos configurados no lay-out. Verifique lay-out do arquivo origem. Linha: " + Str(Len(cLinha),2) + "E X3: " + Str(nTamLin,2) 
			ElseIf Select(cAliasBusca) <= 0
				 cMsg += "arquivo "+cAliasBusca+" nao esta aberto no momento para ser preenchido. Coloque a chamada do arquivo no menu."
			Endif
			//
			If lMenu
				MsgAlert(cMsg)
			Else
				ConOut(cMsg)
			EndIf
			//			
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
//	FClose(cPath+aDiret[nItem,1])
		
	If cIdTran == "SA1I"
		If MsgYesNo( " Deseja imprimir o Log de Ocorencias? " , "Importacao " )
			U_LOGR998(cPath)
		Endif
	ElseIf cIdTran == "SB9I" .Or. cIdTran == "SB9I"
		MATA300(.T.)
	Else
		MostraErro()
	EndIf
    
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
______________________________________________________________________________________
Funcao : PosConsiste	Autor : 							   		  Data : 05.09.00
______________________________________________________________________________________
Observacoes :
______________________________________________________________________________________
*/
User Function PosConsiste(cIdTran)

Local  aSequencias := {}  										// Array que Agragara as Sequencias
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
______________________________________________________________________________________
Funcao : MtLayOutRec	Autor : 							   		  Data : 05.09.00
______________________________________________________________________________________
Observacoes : A funcao abaixo busdca dentro do dicionarios de posicoes de arquivos
quais os dados que deverao ser atualizados e consistidos . Para isto , os arquivos
fxd e fxe serao acionados e as sequencias serao buscadas .
______________________________________________________________________________________
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
	AAdd(aItens,{ FXE_SEQUEN , nPosIni , nTam , FXE_ALIAS , Alltrim(Upper(FXE_CAMPO)) , xFunc } )
	nPosIni += nTam
	DbSkip()
Enddo

Return(aItens)


/*
______________________________________________________________________________________
Funcao : CpoGetTipo     	Autor : 						   		  Data : 05.09.00
______________________________________________________________________________________
Observacoes : Esta funcao recebe como parametro o codio da transacao e busca todas
as amarracoes da tabela do banco com o tipo de tratamento com o alias que ele chama.
Uso : Funcoes do Hyper Site com Tratamento Base de Dados
______________________________________________________________________________________
*/
User Function CpoGetTipo(cCampo)

Local cRet := "C"

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek(cCampo)

cRet := SX3->X3_TIPO

Return(cRet)


/*
______________________________________________________________________________________
Funcao : Conv2Tipo	     	Autor : 						   		  Data : 05.09.00
______________________________________________________________________________________
Observacoes : Esta funcao recebe como parametro o codio da transacao e busca todas
as amarracoes da tabela do banco com o tipo de tratamento com o alias que ele chama.
Uso : Funcoes do Hyper Site com Tratamento Base de Dados
______________________________________________________________________________________
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
                
/*
If cTipo == "C"                   
	_cTexto:="1234567890"
	For _nX:=1 To Len(_cTexto)
		If Substr(_cTexto,_nX,1) $ cConteudo
			cConteudo := '"'+cConteudo+'"'
			Exit
		Endif
	Next		
Endif
*/	

Return(cConteudo)


/*
______________________________________________________________________________________
Funcao : PreparaAuto   	Autor : 						   		  Data : 25.05.04
______________________________________________________________________________________
Observacoes : Preparacao da rotina automatica
Uso : arqrecep
______________________________________________________________________________________
*/
User Function PreparaAuto(aLayout,cLinha)
Local nVal		:= 0
Local cArqItem	:= ""
Local _nX
Private aAuto			:= {}
Private lMsHelpAuto	:= .T.
Private lMsErroAuto	:= .F.
                         
/*
For nVal := 1 to len(aLayout) 
	cCampo    	:= aLayout[nVal,5]
	CConteudo 	:= Substr( cLinha, aLayOut[nVal,2],aLayOut[nVal,3] )
	cTipo 		:= U_CpoGetTipo(cCampo)
	cConteudo 	:= U_Conv2Tipo(cConteudo,cTipo)
	AAdd(aAuto,{cCampo,cConteudo,aLayout[nVal,6]})
Next
*/        

//-- teste
For _nX:=1 To FCount()
	dbSelectArea(FXF->FXF_ALIAS)
	cCampo := FieldName(_nX)
	nVal   := AScan(aLayout,{|x| Alltrim(Upper(x[5]))==Alltrim(Upper(cCampo))})
	If nVal <> 0
		cCampo    	:= aLayout[nVal,5]
		CConteudo 	:= Substr( cLinha, aLayOut[nVal,2],aLayOut[nVal,3] )
		cTipo 		:= U_CpoGetTipo(cCampo)
		cConteudo 	:= U_Conv2Tipo(cConteudo,cTipo)
		AAdd(aAuto,{cCampo,cConteudo,aLayout[nVal,6]})
	Endif	
Next
//-- teste

If Empty(cLayCab)
	If !lMenu
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preparacao do ambiente para rotina workflow        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PREPARE ENVIRONMENT EMPRESA APARAMS[1,1] FILIAL APARAMS[1,2] TABLES FXF->FXF_ALIAS
	EndIf
//	cFilAnt:=
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
______________________________________________________________________________________
Funcao : ProcessaAuto   	Autor : 						   		  Data : 25.05.04
______________________________________________________________________________________
Observacoes : Processamento de rotina automatica
Uso : arqrecep
______________________________________________________________________________________
*/
User Function ProcessaAuto()

Local cMsg	:= ""
Local cAuto	:= Alltrim(FXF->FXF_AUTO)
Local cOpc1	:= IIf(nOpc=3,"inclusao" ,IIf(nOpc=4,"alteracao","exclusao" ))
Local cOpc2	:= IIf(nOpc=3,"incluidos",IIf(nOpc=4,"alterados","excluidos"))
Private lMsHelpAuto	:= .T.
Private lMsErroAuto	:= .F.

If Alltrim(FXF->FXF_IDTRAN) == "SA1I"
	U_DellaValid()
Else
	Begin Transaction
	
	&("MsExecAuto(" + cAuto + ")")
	
	If lMsErroAuto
		If lMenu
	//		MostraErro()
		Else
			ConOut("Erros encontrados na " + cOpc1 + " de dados tabela " + FXF->FXF_ALIAS + ".")
		EndIf
		DisarmTransaction()
		break
	EndIf
	
	End Transaction
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DellaValid  º Autor ³ ADILSON B. de Freitas  º Data ³  24/08/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza as validacoes do sistema (SX3->VALID E SX3->VLDUSER)      º±±
±±º          ³ Gerando um arquivo dos possiveis erros                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User FUNCTION DellaValid()

Local nX 			:= 0
Local nOrdSX3		:= 1
Local cX3Valid		:= ""
Local cVldUser		:= ""
Local cMensErro		:= ""
Local aLogErro		:= {}
Local cMCampo		:= ""
Local cMConteudo	:= ""
Local lRet
PRIVATE INCLUI		:= .T.
Private ALTERA		:= .F.


dbSelectarea(cAliasBusca)
For nX := 1 To Len(aAuto)
	M->&(AllTrim(aAuto[nX,1])) := Iif(ValType(aAuto[nX,2])=="C",ALLTrim(aAuto[nX,2]),aAuto[nX,2])
Next

//lRet := ChkKeyDupl(cAliasBusca,3,M->A1_CGC)

DbSelectArea(cAliasBusca)
DbSetOrder(3)

lRet := DbSeek(xFilial('"'+ cAliasBusca + '"')+M->A1_CGC, .F.)

DbSetOrder(1)

If lRet
	cMensErro := "Cnpj existente - " + Transform(M->A1_CGC, "@R 99.999.999/9999-99")

	AAdd(aLogErro,{nProc2, "A1_CGC", cMensErro})
Else
	nOrdSX3:=SX3->(IndexOrd())
	SX3->(DbSetOrder(2))
	
	For nX := 1 To Len(aAuto)
		cMCampo		:= AllTrim(aAuto[nX,1])
		cMConteudo	:= Iif(ValType(aAuto[nX,2])=="C",ALLTrim(aAuto[nX,2]),aAuto[nX,2])
		
		
		__READVAR := "M->" + cMCampo
		
		If cMCampo == "A1_COD"
			aNewCodCli := P_CNPJCPF(M->A1_CGC,"XX")
			
			M->A1_COD	:= aNewCodCli[1]
			M->A1_LOJA	:= aNewCodCli[2]
		EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Verifica se o campos Obrigatorio e se esta preenchido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		If X3Obrigat( cMCampo ) .And. Empty( cMConteudo )
	
			cMensErro := Transform(M->A1_CGC, "@R 99.999.999/9999-99") + " | Campo Obrigatorio Vazio - " + cMConteudo
	
			AAdd(aLogErro,{nProc2, cMCampo, cMensErro})
		Else
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Busca as validacoes do X3_VALID e X3_VLDUSER e as Executa    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			If SX3->(MsSeek(cMCampo))
/*
				cX3Valid := UPPER(SX3->X3_VALID)
				cX3Valid := IIf(!Empty(cX3Valid),IIF(Alltrim(cX3Valid) == "TEXTO()","",Alltrim(cX3Valid)),"")
				
				cVldUser := UPPER(SX3->X3_VLDUSER)
				cX3Valid += IIf(!Empty(cX3Valid),Iif(!Empty(cVldUser)," .AND. ",""),"")+ IIF(Alltrim(cVldUser) == "TEXTO()","",Alltrim(cVldUser))
				
				If At("TEXTO()", cX3Valid) > 0
					cX3Valid := AllTrim(StrTran(cX3Valid,"TEXTO()"))
					If Right(cX3Valid,4) == ".OR."
						cX3Valid := SubStr(cX3Valid,1,Len(cX3Valid)-4)
					ElseIf Right(cX3Valid,5) == ".AND."
						cX3Valid := SubStr(cX3Valid,1,Len(cX3Valid)-5)
					ElseIf Left(cX3Valid,4) == ".OR."
						cX3Valid := SubStr(cX3Valid,5,Len(cX3Valid)-4)
					ElseIf Left(cX3Valid,5) == ".AND."
						cX3Valid := SubStr(cX3Valid,6,Len(cX3Valid)-5)
					EndIf
				EndIf

				cX3Valid := AllTrim(StrTran(cX3Valid,"VAZIO()","!VAZIO()"))
*/

				cX3Valid := UPPER(SX3->X3_VALID)
				cX3Valid := IIf(!Empty(cX3Valid),Alltrim(cX3Valid),"")
				
				cVldUser := UPPER(SX3->X3_VLDUSER)
				cX3Valid += IIf(!Empty(cX3Valid),Iif(!Empty(cVldUser)," .AND. ",""),"")+ Alltrim(cVldUser)
				
				If Alltrim(cX3Valid) == "TEXTO()"
					cX3Valid := "VAZIO() .Or. "+ cX3Valid
				EndIf

				
				If !Empty(cX3Valid)
					If ! Eval(&("{|| " + cX3Valid + "}"))
						
						cMensErro := Transform(M->A1_CGC, "@R 999.999.999-99") + " | Conteudo Invalido - " + cMConteudo
		
						AAdd(aLogErro,{nProc2, cMCampo, cMensErro})
					EndIf
				EndIf
			Endif
		EndIf
	Next
	SX3->(DbSetOrder(nOrdSX3))
EndIf

If Len(aLogErro) <> 0
	GRAVALOG(aLogErro)
Else
	If RecLock(cAliasBusca,!dbSeek(cChave))
		For nX := 1 to len(aAuto)
			cCampo    	:= AllTrim(aAuto[nX,1])
			CConteudo 	:= &("M->" + cCampo)
			cTipo 		:= U_CpoGetTipo(cCampo)
			cConteudo 	:= U_Conv2Tipo(cConteudo,cTipo)
			dbSelectarea(cAliasBusca)
			If !Empty(cCampo) .and. (nPosCpo := FieldPos(cCampo)) > 0
				Fieldput(nPosCpo,CConteudo)
				If aAuto[nX,3] <> NIL
					Eval(aAuto[nX,3])
				Endif
			Endif
		Next
		MsUnlock()
	EndIf
	
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaLog   º Autor ³ AP6 IDE            º Data ³  24/05/05   º±±
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
Else
	cLin := CHR(13)+CHR(10)
	fWrite(nHdl,cLin,Len(cLin))
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

If File( cLogArq )
	nHdl := FOpen(cLogArq, 2 )
	If nHdl >= 0
		FSeek( nHdl, 0, 2 )
	Endif
Else
	nHdl := FCreate(cLogArq)
Endif

For i := 1 To Len(aRegistro)

	nTamLin := 125
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	cCpo := PADR(aRegistro[i][1],10)
	cLin := Stuff(cLin,01,10,cCpo)
	cCpo := PADR(aRegistro[i][2],30)
	cLin := Stuff(cLin,11,30,cCpo)
	cCpo := PADR(aRegistro[i][3],85)
	cLin := Stuff(cLin,41,85,cCpo)
	
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
/*
User Function ChkKeyDupl(_cAlias, _nOrder, _cChave)
Local lRet := .T.

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
lRet := DbSeek(xFilial('"'+ _cAlias + '"')+_cChave, .F.)

DbSetOrder(1)

Return(lRet)
*/

User Function FRETFIL(_cPref)
Return Substr(_cPref,2,2)
