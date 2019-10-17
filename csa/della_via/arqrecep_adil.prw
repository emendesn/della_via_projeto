#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณARQRECEP  บAutor  ณMicrosiga           บ Data ณ  05/09/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta funcao realiza a importacao de arquivos atraves da    บฑฑ
ฑฑบ          ณ funcao MsExecAuto ou gravando diretamente nas tabelas do   บฑฑ
ฑฑบ          ณ Protheus podendo ser utilizada tambem como workflow.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Acelerador de Implantacao                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImporta   บAutor  ณMicrosiga           บ Data ณ  05/09/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta funcao realiza a importacao de arquivos atraves da    บฑฑ
ฑฑบ          ณ funcao MsExecAuto ou gravando diretamente nas tabelas do   บฑฑ
ฑฑบ          ณ Protheus podendo ser utilizada tambem como workflow.       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importa(aParams)

Local cLinha		:= cChave	:= ""
Local cMsg			:= cTipo		:= ""
Local cOcorrencia	:= ""
Local nPosCpo		:= nVal	:= 0
Local lProcessado   := .F.
Local cAliasBusca,nOrdAlias,cIdTran
Local nProc         := 0
Local nProc2        := 0
Local nHandle

Private cPath
Private aDiret		
Private lMenu			:= (aParams == NIL)
Private cLayCab		:= ""
Private nTamLin		:= 0
Private lAuto			:= .F.
Private aAutoItens	:= {} 
Private aLayout,aConsiste,nItem
Private aAutoCab,nOpc
Private cCampo,cConteudo,cTipo,_aRegs,_cPerg
          
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processos iniciais...                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		cLinha	:= StrTran(cLinha,"|")   // StrTran(Alltrim(cLinha),"|")
		
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
	
    MostraErro()
    
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
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Preparacao do ambiente para rotina workflow        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

/*/ carrega variaveis na memoria
//RegToMemory(Alltrim(FXF->FXF_ALIAS))
//For _nX := 1 To Len(aAuto)
	If ! Empty(aAuto[_nX,1])
		Private &(aAuto[_nX,1]) := aAuto[_nX,2]
	Endif	
Next  
*/

U_DellaValid()

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

Return

User Function FCNPJCPF(_cCGC, _cLoja)
    //
    Local aCodNovo
    Local aArea	  	:= GetArea()
    Local aAreaSA1	:= SA1->(GetArea())
    //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local nTamCod		:= TamSx3("A1_COD")[1]
	Local numero   		:= Space(nTamCod)
	Local resto			:= 0
	Local lPassouLoja	:= !(_cLoja == NIL)
	Local retorno_conv	:= Space(nTamCod)
	Local cPessoa,cBusca
	
	If Len(alltrim(_cCGC)) > 11  
	    //Pessoa Juridica
		div		:= Val(SubStr(_cCGC,1,8))                                           
		_cLoja	:= "01"
		cPessoa	:= "J"
	Else                 
	    // Pessoa Fisica
		div     := Int(Val(AllTrim(_cCGC))/100)
		_cLoja  := "99"
		cPessoa	:= "F"
	EndIf
	
	//Calcula codigo
	While div >= 35
		resto := div % 35
		div   := int(div / 35)
		numero:= conv1(resto)+alltrim(numero) 
	End
	
	numero       := Conv1(div)+AllTrim(numero)	
	retorno_conv := Replicate("0",nTamCod-Len(AllTrim(numero)))+AllTrim(numero)
	     
	// Abre o SA1 com outro Alias para pesquisa
	chkFile("SA1",.f.,"SA1_TRB")
	dbSelectArea("SA1_TRB")
	
	//cChaveInd := "SA1_TRB->A1_FILIAL+SA1_TRB->A1_COD+SA1_TRB->A1_LOJA"
	//cArqTemp  := CriaTrab(NIL,.f.)
	//IndREgua("SA1_TRB", cArqTemp, cChavInd, .t., "Gerando novo indice")
	//nIndice := RetIndex("SA1_TRB")
	//dbSelectArea("SA1_TRB")
	//DbSetIndex(cArqTemp+OrdBagExt())
	//DbSetOrder(nIndice+1)
	
	dbSetOrder(1)
	
	If _cLoja <> "99"
	    
		While .T.
		
			cBusca := retorno_conv + _cLoja
	
			dbSeek(xFilial("SA1_TRB")+cBusca)
		
			If Eof()
				Exit
			Else
				_cLoja := Soma1(_cLoja)
			EndIf
			
		EndDo	
	
	EndIf	           
	
	dbSelectArea("SA1_TRB")
	dbCloseArea()
	
    RestArea(aAreaSA1)
    RestArea(aArea)
    
    //
    SA1->A1_COD 	:= retorno_conv
    SA1->A1_LOJA	:= _cLoja
    SA1->A1_PESSOA	:= IIf(Len(AllTrim(SA1->A1_CGC)) > 11 ,"J","F")
    //

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Conv1    บAutor  ณ Marcelo Gaspar     บ Data ณ  01/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que converte numeros em letras(base 35)             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Conv1(y)
Return AllTrim(IIf(y<10,Str(y),Chr(y+55))) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Conv1    บAutor  ณ Marcelo Gaspar     บ Data ณ  01/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que converte numeros em letras(base 35)             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User FUNCTION DellaValid()
Local aInconsiste := {}
Local lExist	:= .T.
Local lCNPJOK	:= .T.
Local lIEOK		:= .T.
Local lEST		:= .T.
Local nCOD		:= 0
Local nLoja		:= 0

nCod := Ascan(aAuto, "A1_COD")
nLoja := Ascan(aAuto, "A1_COD")

If ExistChav("SA1",aAUTO[1,2]+aAUTO[2,2])
	lExist	:= .F.
EndIf

If ExistCpo("SX5","12"+M->A1_EST)
	lEst := .F.
EndIf

If ! IE(aAUTO[19,2], aAUTO[9,2], .T.)
	lIEOK := .F.
EndIf

If ! CGC(aAUTO[18,2])
	lCNPJOK		:= .F.
EndIf

U_GRAVA(aInconsiste)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaLog  บ Autor ณ AP6 IDE            บ Data ณ  24/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo texto com as inconsistencias encontradas      บฑฑ
ฑฑบ          ณ na importacao dos arquivos                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaLog  บ Autor ณ AP6 IDE            บ Data ณ  24/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo texto com as inconsistencias encontradas      บฑฑ
ฑฑบ          ณ na importacao dos arquivos                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

	nTamLin := 270
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	cCpo := PADR(aRegistro[i][1],10)
	cLin := Stuff(cLin,01,10,cCpo)
	cCpo := PADR(aRegistro[i][2],1)
	cLin := Stuff(cLin,21,1,cCpo)
	cCpo := PADR(aRegistro[i][3],1)
	cLin := Stuff(cLin,22,1,cCpo)

	
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
