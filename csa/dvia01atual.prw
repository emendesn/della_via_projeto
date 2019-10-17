#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ          บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao / Exportacao Pirelli                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Dell Via                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DVia01()                                        
 
Local aSay     := {}
Local aButton  := {}
Local aEmp     := {}
Local nOpc     := 0
Local cTitulo  := "IMPORTAวรO / EXPORTAวรO"
Local cDesc1   := "Esta rotina tem como objetivo fazer a importa็ใo de Notas de Entrada ou a"
Local cDesc2   := "exporta็ใo de pedidos de compra do Sistema, em layout especํfico."
Local cDesc3   := ""
Local cDesc4   := ""
Local cDesc5   := ""
Local cDesc6   := ""
Local cDesc7   := ""
Local oProcess := NIL

Private cArqTXT  := Space(120) 
Private nOperacao := 1
Private cFilNew := ""
Private cItemPc := ""

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
aAdd( aSay, cDesc6 )
aAdd( aSay, cDesc7 )

aAdd( aButton, { 5, .T., {|| Parametros()             }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch(  cTitulo,  aSay,  aButton )

If  nOpc <> 1
	Return NIL
EndIf

If nOperacao == 1
	Processa( { || ImpNFS( @lEnd ) }, "Aguarde...", "Importando de " + cArqTXT	, .F. )
	
ElseIf  nOperacao == 2
	Processa( { || ExpPC( @lEnd ) }, "Aguarde...", "Exportando para " + cArqTXT, .F. )
	
EndIf

If nOperacao == 1
	ApMsgInfo("Processo de Importa็ใo Finalizado.", "ATENวรO")
Else
	ApMsgInfo("Processo de Exporta็ใo Finalizado.", "ATENวรO")
EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ IMPNFS   บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao de NF. Entrada                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpNFS( lEnd )

// Local   nCtErro := 0
Local   nI      := 0
Local   nJ      := 0
Local   i,j,k

Local aAITP1  := Layout( "ITP" ) // Segmento Inicial Mensagem
Local aAE1V1  := Layout( "AE1" ) // Dados da Nota Fiscal
Local aNF2V0  := Layout( "NF2" ) // Complemento AE1
Local aAE2V0  := Layout( "AE2" ) // Dados do Item da Nota Fiscal
Local aAE4V0  := Layout( "AE4" ) // Complemento AE2
Local aAux    := { aAITP1, aAE1V1, aNF2V0, aAE2V0, aAE4V0 }
Local nTamFor := TamSX3( "F1_FORNECE" )[1]
Local nTamLoj := TamSX3( "F1_LOJA"    )[1]

Private cBuffer  := ""
Private cTipoSeg := ""
Private aCab     := {}
Private aItens   := {}
Private aAuxIt   := {}
Private cEspecie:= GetMV("ES_ESPIMP")
Private nProcess:= GetMV("ES_PROCESS")
Private cForPad := Space(08)	// FORNEC+LOJA 	GetMV("ES_FORIMP")
Private   nCtErro := 0

dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial("SX6")+"ES_PROCESS")
RecLock("SX6",.F.)
SX6->X6_CONTEUD := Str(Val(SX6->X6_CONTEUD)+1)
MsUnlock()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializacao Variaveis Private ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nJ := 1 To Len( aAux )
	For nI := 1 To Len( aAux[nJ] )
		cAux  := aAux[nJ][nI][1]
		&cAux := NIL
	Next nI
Next nJ

IniVar( aAITP1 )	// Segmento Inicial Mensagem
IniVar( aAE1V1 )	// Dados da Nota Fiscal
IniVar( aNF2V0 )	// Complemento AE1
IniVar( aAE2V0 )	// Dados do Item da Nota Fiscal
IniVar( aAE4V0 )	// Complemento AE2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verificacao da existencia do Arquivo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !File( cArqTXT )
	If nOperacao == 1
		ApMsgStop( "Arquivo de Importa็ใo " + AllTrim( cArqTXT ) + " nใo encontrado." )
	Else
		ApMsgStop( "Arquivo de Exporta็ใo " + AllTrim( cArqTXT ) + " nใo encontrado." )
	EndIf
	Return NIL
EndIf

// L๊ os CNPJs das Filiais\Empresas da Della Via
_aEmpSM0 := {}
dbSelectArea("SM0")
dbGotop()
While !Eof()
	aadd(_aEmpSM0,{AllTrim(SM0->M0_CGC),SM0->M0_CODFIL})
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicio do Processamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

FT_FUSE( cArqTXT )
FT_FGOTOP()

cBuffer   := FT_FREADLN()
cTipoSeg  := SubStr( cBuffer, 1, 3 )

ProcRegua(FT_FLASTREC())
IncProc("Processando ...")

While !FT_FEOF()
	aCab      := {}
	aItens    := {}
	aAuxIt    := {}
	lQuebra   := .F.
	nCt       := 1
	
	If ! cTipoSeg $ 'ITP/AE1/NF2/AE2/AE4'
		PrxLinha()
		Loop
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cabecalho da NFE ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While !FT_FEOF() .and. cTipoSeg $ 'ITP/AE1/NF2'
		
		If cTipoSeg == "ITP"
			IniVar( aAITP1 )
			PegaDados( aAITP1, cBuffer, cTipoSeg )
			
			// Verifica se o CNPJ do Receptor (Della Via) consta no SigaMat.emp
			If aScan(_aEmpSM0,{|aVal| aVal[1] == AllTrim(cCNPJR)}) == 0 // // CNPJ do Receptor (Della Via)

				cFilNew := _aEmpSM0[aScan(_aEmpSM0,{|aVal| aVal[1] == AllTrim(cCNPJR)})][2]	// CNPJ do Receptor (Della Via)							
				
				// Grava Log de Erro - CNPJ da Della Via nใo cadastrado
				GravaLog("01","CNPJ Della Via nใo cadastrado. CNPJ: " + cCNPJR)
				
				ApMsgStop("Ocorreram Erros na Importacao do Arquivo. Verificar Log.", "ATENวรO" )
		
				// Desconsidera Demais Registros
				While !FT_FEOF() 
					FT_FSKIP()
					cBuffer   := FT_FREADLN()
					cTipoSeg  := SubStr( cBuffer, 1, 3 )
	
					If cTipoSeg == 'ITP'
						Exit
					EndIf
                EndDo       
                                 
                If !FT_FEOF() 
                	Loop
                Else
                	Return
                EndIf
				
				// Return
				
			Else
			
				cFilNew := _aEmpSM0[aScan(_aEmpSM0,{|aVal| aVal[1] == AllTrim(cCNPJR)})][2]	// CNPJ do Receptor (Della Via)
				
				// Le o Fornecedor/Loja
				dbSelectArea("SA2")
				dbSetOrder(3)
				If !dbSeek(xFilial("SA2")+cCNPJT) // CNPJ do Transmissor (Pirelli)
					
					// Grava Log de Erro
					GravaLog("05","Fornecedor/loja nใo cadastrado. CNPJ Fornecedor: " + cCNPJR)
										
					ApMsgStop("Ocorreram Erros na Importacao do Arquivo. Verificar Log.", "ATENวรO" )
					
					// Desconsidera Demais Registros
					While !FT_FEOF() 
						FT_FSKIP()
						cBuffer   := FT_FREADLN()
						cTipoSeg  := SubStr( cBuffer, 1, 3 )
	
						If cTipoSeg == 'ITP'
							Exit
						EndIf
                	EndDo       
                
	                If !FT_FEOF() 
    	            	Loop
        	        Else
            	    	Return
                	EndIf

					// Return
				Else
					cForPad := SA2->A2_COD+SA2->A2_LOJA
					// cFilAnt := _aEmpSM0[aScan(_aEmpSM0,{|aVal| aVal[1] == AllTrim(cCNPJR)})][2]	// CNPJ do Receptor (Della Via)
				EndIf
				
			EndIf
			
		ElseIf cTipoSeg == "AE1"
			IniVar( aAE1V1 )
			PegaDados( aAE1V1, cBuffer, cTipoSeg )
			
		ElseIf cTipoSeg == "NF2"
			IniVar( aNF2V0 )
			PegaDados( aNF2V0, cBuffer, cTipoSeg )
			
		EndIf
		
		PrxLinha()
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Completamentacao de Campos Cabecalho Faltantes para importacao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd( aCab, { "F1_TIPO"   , "N"      , NIL } )
	aAdd( aCab, { "F1_FORMUL" , "N"      , NIL } )
	aAdd( aCab, { "F1_FORNECE", SubStr(cForPad,1,6), NIL } )
	aAdd( aCab, { "F1_LOJA"   , SubStr(cForPad,7,2), NIL } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Itens da NFE ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู       
	While !FT_FEOF() .and. cTipoSeg $ 'AE2/AE4'
		
		If cTipoSeg == "AE2"
			IniVar( aAE2V0 )
			PegaDados( aAE2V0, cBuffer, cTipoSeg )
			
			aAdd( aAuxIt, { "D1_TOTAL"   , M->D1_QUANT * M->D1_VUNIT , NIL } )
			
			cItemPC := PegaItPC( M->D1_PEDIDO, M->D1_COD, cFilNew )
			
			aAdd( aAuxIt, { "D1_ITEMPC"  , cItemPC , NIL } )
			
			lQuebra := .T.
			
		ElseIf cTipoSeg == "AE4"
			IniVar( aAE4V0 )
			PegaDados( aAE4V0, cBuffer, cTipoSeg )
			
			lQuebra := .T.
			
		EndIf        
		
		PrxLinha()
		
		If cTipoSeg $ "AE4"
			Loop
		Else
			// If cTipoSeg $ "AE1/AE2" .and. lQuebra       
			If lQuebra       
				nCt++
				lQuebra := .F.
				nCt     := 0
			
				aAdd( aItens, aAuxIt )
			
				aAuxIt  := {}
			EndIf
		EndIf
		
		// PrxLinha()
		
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se a NFE ja existe para determinar se sera alteracao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	lContinua := .T.                        // Flag de importa็ใo ou nใo NFE
	
	// Verifica se a NFE jแ foi Importada
	dbSelectArea( "SF1" )
	dbSetOrder(1)
	
	If dbSeek( cFilNew + M->( F1_DOC + F1_SERIE  + cForPad ) ) // NFE jแ Importada Anteriormente
	
	
		lContinua := .F. // Nใo importa NFE
		GravaLog("02","NF jแ cadastrada. NF/Serie/Fornec.: "+M->( F1_DOC)+" / "+M->F1_SERIE+" - "+Left(cForPad,6)+" / "+Right(cForPad,2))  // Nota em outro arquivo EDI
		ApMsgStop("Ocorreram Erros na Importacao do Arquivo. Verificar Log.", "ATENวรO" )
	
    EndIf
    
	// Troca a Filial 
	_cFilAtu := cFilAnt
	cFilAnt := _aEmpSM0[aScan(_aEmpSM0,{|aVal| aVal[1] == AllTrim(cCNPJR)})][2]	// CNPJ do Receptor (Della Via)
	
	// Checa se o pedido de compra/item estใo cadastrados
	For i:= 1 to Len(aItens)     

		// Verifica se o pedido de compra existe
		dbSelectArea("SC7")
		dbSetOrder(1)  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN                                                                                                                              
		If !dbSeek(cFilAnt+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2])		
			GravaLog("09","Pedido de compra nใo Cadastrado. Pedido: " + aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2])			
			lContinua := .F.
			nCtErro++
            Exit
		ElseIf !dbSeek(cFilAnt+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2]+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_ITEMPC"})][2])		
				GravaLog("10","Item do pedido de compra nใo cadastrado. Ped./Item: " + aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2]+" / "+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_ITEMPC"})][2])			
				lContinua := .F.
				nCtErro++
            	Exit
		Else
			dbSetOrder(4)  // C7_FILIAL+C7_PRODUTO+C7_NUM+C7_ITEM+C7_SEQUEN                                                                                                                   
			If !dbSeek(cFilAnt+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_COD"})][2]+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2]+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_ITEMPC"})][2])
				GravaLog("03","C๓digo do produto diverge da nota. Ped./Item/Prod.: " + aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2]+" / "+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_ITEMPC"})][2]+" / "+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_COD"})][2])			
				lContinua := .F.
				nCtErro++
            	Exit
        	EndIf
		EndIf	
	Next I

	// Volta Filial Anterior
	cFilAnt := _cFilAtu  

	If	lContinua
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Execucao do MSExecAuto ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		lMsHelpAuto := .T.
		lMsErroAuto := .F.
		
		Begin Transaction       
		
		// Troca a Filial 
		_cFilAtu := cFilAnt
		
		cFilAnt := _aEmpSM0[aScan(_aEmpSM0,{|aVal| aVal[1] == AllTrim(cCNPJR)})][2]	// CNPJ do Receptor (Della Via)
		
		// Salva array dos Itens da Pr้-Nota para que o Pedido de compra/Item sejam apagados
		// para que o ExecAuto leia os dados do arquivo Texto e nใo do  pedido de compra (SC7).
		// Ap๓s a execu็ใo do ExecAuto os itens da pr้-nota SD1 serใo varridos para gravar o pedido de compra/item 
		_aItens := aClone(aItens) 
		
		aItens2 := {}
		
		For i:= 1 to Len(aItens)     
		        aAux := {}
				For j:= 1 to Len(aItens[i]) 
					If AllTrim(aItens[i][j][1]) <> "D1_PEDIDO" .And. AllTrim(aItens[i][j][1]) <> "D1_ITEMPC" 
						aadd(aAux,{aItens[i][j][1],aItens[i][j][2],aItens[i][j][3]}) 
					EndIf
				Next j
				aAdd( aItens2, aAux )
		Next I

		MSExecAuto({ | x, y, z | MATA140( x, y, z ) }, aCab, aItens2, 3 ) // Inclusใo
		
		// Volta Filial Anterior
		cFilAnt := _cFilAtu  
		
		If lMsErroAuto
		    DisarmTransaction()
			// Grava Log de Erro
			GravaLog("06","NFE com dados inconsistentes. Verifique arquivo de Log.")
			
			// MostraErro()
			nCtErro++

		Else
			
			// Grava arquivo texto EDI Pirelli
			dbSelectArea("SF1") 
			dbSetOrder(1)
			
			// Troca a Filial 
			_cFilAtu := cFilAnt
		
			cFilAnt := _aEmpSM0[aScan(_aEmpSM0,{|aVal| aVal[1] == AllTrim(cCNPJR)})][2]	// CNPJ do Receptor (Della Via)
		
			dbSeek(cFilAnt+M->( F1_DOC + F1_SERIE  + cForPad ))
		
			// Volta Filial Anterior
			cFilAnt := _cFilAtu  

			If Found()
				RecLock("SF1",.F.)
				SF1->F1_ARQEDIP := U_PegaFile( cArqTXT )
				MsUnlock()
			EndIf
			
			// Grava pedido de compra/item
			For i:= 1 to Len(_aItens) 
			
				// Verifica se o pedido de compra existe
 				dbSelectArea("SC7")
 				dbSetOrder(4)  // C7_FILIAL+C7_PRODUTO+C7_NUM+C7_ITEM+C7_SEQUEN                                                                                                                   
 				If dbSeek(cFilAnt+_aItens[i][ASCAN(_AITENS[I], { |X| X[1] == "D1_COD"})][2]+_aItens[i][ASCAN(_AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2]+_aItens[i][ASCAN(_AITENS[I], { |X| X[1] == "D1_ITEMPC"})][2])

					// Grava a quantidade a classificar no pedido de compra 	
					RecLock("SC7",.F.)  
		 			SC7->C7_QTDACLA += _aItens[i][ASCAN(_AITENS[I], { |X| X[1] == "D1_QUANT"})][2]     
		 			MsUnlock()                 

					// Grava o pedido de compra nos itens da NF
					dbSelectArea("SD1")
    		        dbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
					If dbSeek(cFilAnt+M->( F1_DOC + F1_SERIE  + cForPad )+ _aItens[i][ASCAN(_AITENS[I], { |X| X[1] == "D1_COD"})][2]) // _aItens[i][3][2])
						RecLock("SD1",.F.)
						SD1->D1_PEDIDO := _aItens[i][ASCAN(_AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2] // ASCAN(_AITENS[I], { |X| X[1] == "D1_PEDIDO"})
						SD1->D1_ITEMPC := _aItens[i][ASCAN(_AITENS[I], { |X| X[1] == "D1_ITEMPC"})][2]
						MsUnlock()                 
					EndIf	
					
					// Grava Log Nota Fiscal Importada com Sucesso
	    			// GravaLog("04","NFE Impotarda com sucesso. Nota/Serie/Fornec.: " + M->F1_DOC +"/"+ M->F1_SERIE+"/"+cForPad )
	    			GravaLog("04","NFE Impotarda com sucesso.") // Nota/Serie/Fornec.: " + M->F1_DOC +"/"+ M->F1_SERIE+"-"+Left(cForPad,6)+"/"+Right(cForPad,2) )

				Else                    

					// Grava Log de Erro - CNPJ da Della Via nใo cadastrado
					GravaLog("03","Produto nใo cadastrado no Ped./Item/Prod.: " + aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_PEDIDO"})][2]+" / "+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_ITEMPC"})][2]+" / "+aItens[i][ASCAN(AITENS[I], { |X| X[1] == "D1_COD"})][2])			
					nCtErro++
				EndIf	

			Next i
			
		Endif
		
		End Transaction
		
	EndIf
	
EndDo

FT_FUSE()

If nCtErro > 0
	ApMsgStop("Ocorreram Erros na Importacao do Arquivo. Verificar Log.", "ATENวรO" )
	//MostraErro()

// EndIf
Else

	// Move os arquivos para seus diret๓rios correspondentes
	_cDir := GETMV("ES_ARQPROC")	// "C:\PROTHEUS8\PROTHEUS_DATA\DATA\PROCESSADOS\"

	_cArqOri := AllTrim(cArqTXT)

	_cArqDes := _cDir + U_PegaFile( cArqTXT )
 
	__CopyFile (_cArqOri,_cArqDes )

	FErase(_cArqOri)
EndIf
//

Return NIL       
                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณPEGAFILE  บAutor  ณ Ernani Forastieri  บ Data ณ  02/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para retorna o nome do arquivo e extensao            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/     
/*
User Function PegaFile( cNomeArq )

Local cRet := ""
Local nPos := 0

If cNomeArq <> NIL
         If ( nPos := Len( u_PegaPath( cNomeArq ) ) ) > 0
                   cRet := SubStr( cNomeArq, nPos + 1, Len( cNomeArq ) )
         Else
                   cRet := cNomeArq
         EndIf
EndIf

Return cRet
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณPEGAPATH  บAutor  ณ Ernani Forastieri  บ Data ณ  02/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para retorna o Path do arquivo informado             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                    
/*
User Function PegaPath( cNomeArq )

Local cRet := ""
Local nPos := 0

If cNomeArq <> NIL
         If ( nPos := Rat( "\", cNomeArq ) ) > 0
                   cRet := SubStr( cNomeArq, 1, nPos )
         EndIf
EndIf

Return cRet
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ EXPPC    บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exportacao para Ped. Compras                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExpPC( lEnd )
Local aHead   := {}
Local aDet    := {}
Local cPedAnt := ""
Local cBuffer := ""
Local cIndSC7 := ""
Local lAbriu  := .T.
Local nHdl    := 0

If File( cArqTXT )
	If !ApMsgYesNo( "Arquivo " + AllTrim( cArqTXT ) + " jแ existente." + Chr(13) + "Deseja sobrepor ?")
		Return NIL
	EndIf
EndIf

dbSelectArea( "SB1" )
dbSetOrder(1)

dbSelectArea( "SC7" )
dbSetOrder(1)

dbSelectArea( "SZ1" )
dbSetOrder(1)                                    
//dbSeek(xFilial("SZ1")+SM0->M0_CODFIL+SM0->M0_CODFIL)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Header Pedido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//               Variavel     Tipo  Pos  Tam Dec Formula
aAdd( aHead , { "cHeadSeg"  , "C",   1,   1,  0, "'C'"   } )
aAdd( aHead , { "cUsuPire"  , "C",  02,  15,  0, "padr(Upper(AllTrim(GetMv('ES_PEDIUSR'))),15)" } ) // mv_par01 - SubStr(cUsuario,7,15)
aAdd( aHead , { "cCodCliPir", "C",  17,  10,  0, "AllTrim(SZ1->Z1_CODPIR)" } )                   //  "SB1->B1_CODFAB"
aAdd( aHead , { "cTipoCon"  , "C",  27,   4,  0, "AllTrim(GetMv('ES_CTREDIP'))" } )        // mv_par03                   // "'ZWEB'"
aAdd( aHead , { "dContrato" , "D",  31,  10,  0, "TSC7->C7_EMISSAO"  } )
aAdd( aHead , { "cRefCli"   , "C",  41,  20,  0, "TSC7->C7_NUM"      } )
aAdd( aHead , { "dIniVal"   , "D",  61,  10,  0, "FirstDay( Stod(TSC7->C7_EMISSAO) )" } )
aAdd( aHead , { "dFimVal"   , "D",  71,  10,  0, "LastDay( Stod(TSC7->C7_EMISSAO) )"  } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Itens  Pedido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//               Variavel     Tipo Pos  Tam Dec  Formula
aAdd( aDet  , { "cDetSeg"   , "C",   1,   1,  0, "'D'"  } )
aAdd( aDet  , { "cCodFab"   , "C",   2,   7,  0, "SB1->B1_CODFAB"  } )
aAdd( aDet  , { "cQtdeCon"  , "N",   9,   10,  0, "TSC7->C7_QUANT"  } )

#IFDEF TOP
	cQuery := ""
	cQuery += " SELECT C7_FLAGPIR,C7_FILIAL,C7_NUM,C7_ITEM,C7_PRODUTO,C7_QUANT,C7_EMISSAO, R_E_C_N_O_ AS SC7RECNO FROM " + RetSqlName( "SC7" )
	cQuery += "   WHERE C7_FLAGPIR = ' ' AND C7_FORNECE = '"+GetMv("ES_FORNPIR")+"'"
	cQuery += "     AND D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY C7_FILIAL, C7_NUM, C7_ITEM "
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TSC7", .F., .T. )
	
#ELSE
	ChkFile( "SC7",, "TSC7" )
	cIndSC7 := CriaTrab(NIL,.F.)
	IndRegua("TSC7", cIndSC7, "C7_FILIAL+C7_NUM+C7_ITEM",,"EMPTY(C7_FLAGPIR) .And. C7_FORNECE = "+GetMv("ES_FORNPIR"),"Selecionando Registros...")
	lAbriu  := .T.
	
#ENDIF

//nHdl := fCreate( cArqTXT )

dbSelectArea( "TSC7" )
dbGoTop()
ProcRegua( RecCount() )

_nTamOri := Len(cArqTXT)
    
While ! TSC7->( Eof() )
	
	cPedAnt := TSC7->C7_NUM
	
	cArqTXT := SubStr(cArqTXT,1,_nTamOri)+TSC7->C7_NUM + ".TXT"
	
	nHdl := fCreate( cArqTXT )

    SZ1->( dbSeek( xFilial( "SZ1" ) + SM0->M0_CODIGO + TSC7->C7_FILIAL ) )
    
	cBuffer := ""
	CarregaBuffer( aHead, @cBuffer )
	fWrite( nHdl, cBuffer , Len( cBuffer ) )

	//While ! TSC7->( Eof() ) .and. cPedAnt == TSC7->C7_NUM
	
		//IncProc()
	
    cPedAnt := TSC7->C7_NUM
	
	While ! TSC7->( Eof() ) .and. cPedAnt == TSC7->C7_NUM
		
        IncProc()
		
        SB1->( dbSeek( xFilial( "SB1" ) + TSC7->C7_PRODUTO ) )
        
		cBuffer := ""
		CarregaBuffer( aDet, @cBuffer )
		
		fWrite( nHdl, cBuffer , Len( cBuffer ) )
		
		#IFDEF TOP
			SC7->( dbGoTo( TSC7->SC7RECNO ) )
		#ELSE
			SC7->( dbSeek( TSC7->( C7_FILIAL + C7_NUM + C7_ITEM ) ) )
		#ENDIF
		
		RecLock( "SC7", .F. )
		SC7->C7_FLAGPIR := "S"
		SC7->(MsUnlock())
		
		TSC7->( dbSkip() )
	End
	
	fClose( nHdl )
	
End

 fClose( nHdl )

dbSelectArea( "TSC7" )
dbCloseArea()

If lAbriu
	FErase( cIndSC7 + OrdBagExt() )
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณPARAMETROSบAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina auxiliar para definicao de parametros               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Parametros()
Local oGrp1 , oGrp2, oRadio, oFontBold
Local lOk        := .F.   
Local cArqAnt    := cArqTXT
Local nOpAnt     := nOperacao

Private oDlg     := NIL
Private aOpLista := { "Importa็ใo de NF Entrada", "Exporta็ใo de P.Compras" }
Private oButDir  := NIL

// Pergunte("DVIA01",.T.)

// pirok20050808165248c[1].felizardo____DellaVia_53703

Define Font oFontBold Name "Arial" Size 0, -11 Bold
Define MSDialog oDlg From 318, 414 To 490, 845 Title "Parโmetros" Of oMainWnd Pixel

@  5,  5  Group oGrp1 To 45, 105 Label " Escolha o Tipo Opera็ใo " Of oDlg Pixel
oGrp1:oFont := oFontBold
@  15, 10 Radio oRadio  Var nOperacao Valid(oGet:Refresh(),.t.) Size 90,13 Items "Importa็ใo de NF. Entrada", "Exporta็ใo de P.Compras"  Of oDlg Pixel
@  50,   5  Group oGrp2 To 78, 210  Label " Nome Arquivo de Texto " Of oDlg Pixel
oGrp2:oFont := oFontBold
@  60,  10 MSGet oGet Var cArqTXT When Iif(nOperacao==1,.t.,.F.) Picture "@!S50" Size 180, 10 Pixel Of oDlg
@  60, 192 Button oButDir Prompt "..." When Iif(nOperacao==1,.t.,.F.) Size 13, 13 Pixel Action EscDiret( @cArqTXT ) Message "Selecionar Arquivo" Of oDlg

Define SButton From @  5, 180 Type 1 Enable Action ( lOk := .T., oDlg:End() )
Define SButton From @  5, 150 Type 2 Enable Action ( cArqTXT := cArqAnt, nOperacao := nOpAnt, lOk := .T., oDlg:End() )

Activate Dialog oDlg Centered Valid ValidForm( cArqTXT ) .and. lOk

If nOperacao==2
   // cArqTXT :="pirok"+Dtos(dDataBase)+AllTrim(mv_par02)+AllTrim(mv_par01)+"____DellaVia_" // +"53703"+".txt"
   cArqTXT :="\EDI\pirok"+Dtos(dDataBase)+strtran(time(),":","")+padr(Upper(AllTrim(GetMv("ES_PEDIUSR"))),15,"_")+"DellaVia_" // +"53703"+".txt"
Endif

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ ESCDIRET บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Escolha de diretorio                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscDiret( cVar )
Local cStartDir := ""
Local cDir      := ""
Local cArq      := ""
Local nAux      := 0

If Empty( cVar )
	cStartDir := "SERVIDOR"
Else
	nAux := RAT( "\", cVar )
	cDir := SubStr( cVar, 1, nAux)
	cArq := SubStr( cVar, nAux+1)
	cStartDir := IIf( ! ( ":" $ cDir ), "SERVIDOR" + cDir , cDir )
EndIf

cVar := cGetFile("Todos os Arquivos (*.*)|*.* | Arquivo Texto (*.TXT)|*.TXT", "Selecione Arquivo",,  cStartDir, ( nOperacao == 1), GETF_ONLYSERVER )

cVar := AllTrim( cVar ) + Replicate( "  ", 120 - Len( cVar ) )

oGet:Refresh()
oDlg:Refresh()

Return  NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณVALIDFORM บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para validar o FORM                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidForm( cVar)
Local  lRet := .T.

/*
If Empty( cVar )
	ApMsgStop("Nome de Arquivo Nใo Informado.", "ATENวรO")
	lRet := .F.
EndIf
*/

Return  lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณPEGADADOS บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que preenche variaveis de memorio com dados do TXT  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PegaDados( aCampos, cBuffer, cTipoSeg )
Local xDado    := NIL
Local nTamDado := 0
Local nTamSX3  := 0
Local nI       := 0

For nI := 1 To Len( aCampos )
	
	xDado := SubStr( cBuffer, aCampos[nI][3], aCampos[nI][4] )
	
	lEhSD1 := ( SubStr( aCampos[nI][1], 1, 3 ) == "D1_" )
	lEhSF1 := ( SubStr( aCampos[nI][1], 1, 3 ) == "F1_" )
	
	If     aCampos[nI][2] == "C"
		xDado :=  xDado
		
		If  lEhSD1 .or. lEhSF1
			xDado += Space( 200 )
			xDado := SubStr( xDado, 1, TamSX3( aCampos[nI][1] )[1] )
		EndIf
		
		
	ElseIf aCampos[nI][2] == "N"
		xDado := Val( xDado ) / ( 10 ^ aCampos[nI][5] )
		
	ElseIf aCampos[nI][2] == "D"
		xDado := CToD( SubStr( xDado, 5, 2 ) + "/" + SubStr( xDado, 3, 2 ) + "/" + SubStr( xDado, 1, 2 ) )
		
	EndIf
	
	If     lEhSD1
		If aCampos[nI][1] $ "D1_ITEM/D1_PEDIDO/D1_COD"
			If ALLTRIM(aCampos[nI][1]) == "D1_COD"        
				// Troca o produto pirelli (no .TXT - B1_CODFAB) pelo Della Via (SB1->B1_COD)
				dbSelectArea("SB1")
				dbSetOrder(9) // B1_FILIAL+B1_CODFAB
				If dbSeek(xFilial("SB1")+ xDado)
					xDado := SB1->B1_COD  
				Else 
					// Grava Log de Erro - CNPJ da Della Via nใo cadastrado
					GravaLog("08","Codigo do Fabricante (Produto) nใo encontrado. Codigo Fab. : " + xDado)
					nCtErro++
				EndIf
				dbSetOrder(1)
			Else
				xDado := StrZero( Val( xDado ) , TamSX3( aCampos[nI][1] )[1] )
			EndIf
		EndIf
		
		aAdd( aAuxIt, { aCampos[nI][1], xDado, NIL } )
		
	ElseIf lEhSF1
		If  aCampos[nI][1] == "F1_ESPECIE"
			xDado := cEspecie
		EndIf
		
		aAdd( aCab  , { aCampos[nI][1], xDado, NIL } )
		
	EndIf
	
	M->( &( aCampos[nI][1] ) ) := xDado
	
Next

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCARREGABUFบAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Montagem da linha de gravaco                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CarregaBuffer( aCampos, cBuffer )
Local nI    := 0
Local xDado := ""

For nI := 1 To Len( aCampos )
	
	xDado := &( aCampos[nI][6] )
	
	If     aCampos[nI][2] == "C"
		xDado   := AllTrim( xDado )
		cBuffer += SubStr( xDado + Replicate(" ", Max( aCampos[nI][4] - Len( xDado ), 0 ) ) , 1, aCampos[nI][4] )
		
	ElseIf aCampos[nI][2] == "N"
		cBuffer += StrZero( xDado * ( 10 ^ aCampos[nI][5] ), aCampos[nI][4] )
		
	ElseIf aCampos[nI][2] == "D"
		// cBuffer += SubStr( DToC( xDado ), 1, 6 ) +  StrZero( Year( xDado ), 4 )
		If ValType(xDado) == "C"
			cBuffer += SubStr( xDado , 7 , 2 ) + "/" +  SubStr( xDado , 5 , 2 ) + "/" + SubStr(  xDado , 1, 4 ) 
	    ElseIf ValType(xDado) == "D"
			cBuffer += SubStr( DToC( xDado ), 1, 6 ) +  StrZero( Year( xDado ), 4 )
		EndIf
	EndIf
	
Next

cBuffer += CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ INIVAR   บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Inicializacao de variaveis private relacionadas ao TXT     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IniVar( aCampos )
Local nI    := 0
Local xDado := ""

For nI := 1 To Len( aCampos )
	xDado := NIL
	If     aCampos[nI][2] == "C"
		xDado := Space( aCampos[nI][4] )
		
	ElseIf aCampos[nI][2] == "N"
		xDado := 0
		
	ElseIf aCampos[nI][2] == "D"
		xDado := CToD( "  /  /  " )
		
	EndIf
	
	M->( &( aCampos[nI][1] ) ) := xDado
Next nI

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PRXLINHA บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Le proxima linha do TXT                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrxLinha()

While !FT_FEOF()
	IncProc("Processando ...")
	FT_FSKIP()
	cBuffer   := FT_FREADLN()
	cTipoSeg  := SubStr( cBuffer, 1, 3 )
	
	If cTipoSeg $ 'ITP/AE1/NF2/AE2/AE4'
		Exit
	EndIf
End

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ LAYOUT   บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna layout em Array                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Layout( cTipoSeg )
Local aRet := {}

// Sequencia dos registros no TXT
// ITP... Segmento Inicial Mensagem
// AE1... Dados da Nota Fiscal
// NF2... Complemento Dados da Nota Fiscal
// AE2... Dados do Item da Nota Fiscal
// AE4... Complemento Dados do Item da Nota Fiscal
// AE3... Dados Adicionais do Comercial - Ignorado
// AE1...
// NF2...
// AE2...
// AE4...
// AE3...
// FTP... Segmento Final Mensagem
// ITP... Segmento Inicial Mensagem
// ...
// FTP... Segmento Final Mensagem

/*

ITP - Segmento Inicial Mensagem

3  3 2    5          12            14            14                                       25                       25
12312312123451234567890121234567890123412345678901234123456781234567812345678901234567890123451234567890123456789012345123456789
ITP00404000010503141909015917983800439660957784000172                 PIRELLI PNEUS S/A       A.L. MTZ

AE1 - Dados da Nota Fiscal
17     6 2               17  3     6   4                            30
3     6   4     6  3               171  31234567890123456712345612123456789012345671231234561234123456789012345678901234567890
1231234561234123456123123456789012345671123
AE11734941   050314001000000000002185602540000000000000311260505130000000000000025938         0000

NF2 - Complemento Dados da Nota Fiscal

3               17               17               17               17                                                 51
12312345678901234567123456789012345671234567890123456712345678901234567123456789012345678901234567890123456789012345678901
NF200000000000282378000000000000197020000000000017292000000000000031126

AE2 - Dados do Item da Nota Fiscal
3  3          12                            30        9 2        10   4               17        9 2        9 21   4         11
12312312345678901212345678901234567890123456789012345678912123456789012341234567890123456712345678912123456789121123412345678901
AE200139541       1060000                       000000008PC0040111000150000000000000021615000000000  000000000   000000000000000

AE4 - Dados Complementares do Item

3   4               17               17               17 2                            30     6               17             15
12312341234567890123456712345678901234567123456789012345671212345678901234567890123456789012345612345678901234567123456789012345
AE4180000000000000172920000000000000311260000000000002593801195/50R15TL 82V P7000               00000000000019702000000000282378

AE3 - Dados adicionais do Comercial
3            14            14            14                                                                                 83
12312345678901234123456789012341234567890123412345678901234567890123456789012345678901234567890123456789012345678901234567890123
AE3609577840001726095778400017260957784000172

FTP - Segmento Final Mensagem

3    5        9               17               17                                                                                           93
123123451234567891234567890123456712345678901234567123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
FTP0000100000005600000000000000000

*/

If  cTipoSeg == "ITP"
	// Lay-Out Registro Tipo AITP1 - Dados do Segmento Inicial Mensagem
	//               Variavel      Tipo  Pos Tam  Dec
	aAdd( aRet, { "cReg1"      , "C",   1,  25,  0 } )	// Registro 1
	aAdd( aRet, { "cCNPJT"     , "C",  26,  14,  0 } )	// CNPJ Transmissor
	aAdd( aRet, { "cCNPJR"     , "C",  40,  14,  0 } )	// CNPJ Receptor
	aAdd( aRet, { "cReg2"      , "C",  54,  75,  0 } )	// Registro 2
	
ElseIf    cTipoSeg == "AE1"
	// Lay-Out Registro Tipo AE1V1 - Dados da Nota Fiscal
	//               Variavel      Tipo  Pos Tam  Dec
	aAdd( aRet, { "cTipoSeg"   , "C",   1,   3,  0 } )	// Tipo Segmento (AE1)
	aAdd( aRet, { "F1_DOC"     , "C",   4,   6,  0 } )	// Numero NF Origem
	aAdd( aRet, { "F1_SERIE"   , "C",  10,   4,  0 } )	// Serie NF ORigem
	aAdd( aRet, { "F1_EMISSAO" , "D",  14,   6,  0 } )	// Data Emissao NF
	aAdd( aRet, { "cFiller"    , "C",  20,   3,  0 } )	//
	aAdd( aRet, { "F1_VALBRUT" , "N",  23,  17,  2 } )	// Valor Total da NF
	aAdd( aRet, { "cFiller"    , "N",  40,   1,  0 } )	// Qtd. Casas Decimais
	aAdd( aRet, { "cCFOpe"     , "C",  41,   3,  0 } )	// Codigo Fiscal Operacao
	aAdd( aRet, { "nVlTotICMS" , "N",  44,  17,  2 } )	// Vl.Total ICMS Aplicado
	aAdd( aRet, { "dVencto"    , "C",  61,   6,  0 } )	// Data Vecto Documento
	aAdd( aRet, { "F1_ESPECIE" , "C",  67,   2,  0 } )	// Especie da NF
	aAdd( aRet, { "nVlTotIPI"  , "N",  69,  17,  2 } )	// Valor do IPI Aplicado
	aAdd( aRet, { "cCodFabr"   , "C",  86,   3,  0 } )	// Cod. Fabrica de Entrega
	aAdd( aRet, { "dPrevEnt"   , "C",  89,   6,  0 } )	// Data Prev. Entrega NF
	aAdd( aRet, { "cPerEntr"   , "C",  95,   4,  0 } )	// Idnet. Periodo Entrega
	aAdd( aRet, { "cFiller"    , "C",  99,  30,  0 } )	//
	
ElseIf cTipoSeg == "NF2"
	// Lay-Out Registro Tipo NF2V0 - Complemento Dados Nota Fiscal
	//               Variavel      Tipo  Pos Tam  Dec
	aAdd( aRet, { "cTipoSeg"   , "C",   1,   3,  0 } )	// Tipo Segmento (NF2)
	aAdd( aRet, { "F1_BRICMS"  , "N",   4,  17,  2 } )	// Base Calculo Subs Tributaria
	aAdd( aRet, { "F1_ICMSRET" , "N",  21,  17,  2 } )	// Valor Subs. Tributaria
	aAdd( aRet, { "F1_BASEICM" , "N",  38,  17,  2 } )	// Base Calc. ICMS Proprio
	aAdd( aRet, { "F1_VALICM"  , "N",  55,  17,  2 } )	// Valor ICMS Proprio
	aAdd( aRet, { "cFiller"    , "C",  72,  57,  0 } )	//
	
ElseIf cTipoSeg == "AE2"
	// Lay-Out Registro Tipo AE2V0 - Dados Item da Nota Fiscal
	//               Variavel      Tipo  Pos Tam  Dec
	aAdd( aRet, { "cTipoSeg"   , "C",   1,   3,  0 } )	// Tipo Segmento (AE2)
	aAdd( aRet, { "D1_ITEM"    , "C",   4,   3,  0 } )	// Sequencia do Item
	aAdd( aRet, { "D1_PEDIDO"  , "C",   7,  12,  0 } )	// Numero do Ped. Compras
	//	aAdd( aRet, { "cPedNF"     , "C",   7,  12,  0 } )	// Numero do Ped. Compras
	aAdd( aRet, { "D1_COD"     , "C",  19,  30,  0 } )	// Cod. do Item
	aAdd( aRet, { "D1_QUANT"   , "N",  49,   9,  0 } )	// Qtd. do Item
	aAdd( aRet, { "cUniMed"    , "C",  58,   2,  0 } )	// Unid. Med. Item
	aAdd( aRet, { "cClasFis"   , "C",  60,  10,  0 } )	// Clas. Fiscal do Item
	aAdd( aRet, { "D1_IPI"     , "N",  70,   4,  2 } )	// Aliquota de IPI
	aAdd( aRet, { "D1_VUNIT"   , "N",  74,  17,  2 } )	// Valor Unitario
	aAdd( aRet, { "nQtdEst"    , "N",  91,   9,  0 } )	// Qtd. Em Estoque
	aAdd( aRet, { "cUnMedEst"  , "C", 100,   2,  0 } )	// Unid. Med. Estoque
	aAdd( aRet, { "nQtdComp"   , "C", 102,   9,  0 } )	// Qtd. de Compra
	aAdd( aRet, { "cUnMedCom"  , "C", 111,   2,  0 } )	// Unid. Med. de Compra
	aAdd( aRet, { "cCodTipFor" , "C", 113,   1,  0 } )	// Cod. Tipo Fornecimento
	aAdd( aRet, { "nPercDesc"  , "C", 114,   4,  0 } )	// Perc. Desconto
	aAdd( aRet, { "nVlTotDesc" , "C", 118,  11,  0 } )	// Valor Total Desconto
	
ElseIf cTipoSeg == "AE4"
	// Lay-Out Registro Tipo AE4V0 - Dados Complementares do Item
	//               Variavel      Tipo  Pos Tam  Dec
	aAdd( aRet, { "cTipoSeg"   , "C",   1,   3,  0 } )	// Tipo Segmento (AE4)
	aAdd( aRet, { "D1_PICM"    , "N",   4,   2,  0 } )	// Aliquota de ICMS da N.F.
	aAdd( aRet, { "D1_BASEICM" , "N",   8,  17,  2 } )	// Base Calculo ICMS Item
	aAdd( aRet, { "D1_VALICM"  , "N",  25,  17,  2 } )	// Valor ICMS Item
	aAdd( aRet, { "D1_VALIPI"  , "N",  42,  17,  2 } )	// Valor IPI Item
	aAdd( aRet, { "cCodSubTri" , "C",  59,   2,  0 } )	// Cod. Subst. Trib. Item
	aAdd( aRet, { "cDescricao" , "C",  61,  30,  0 } )	// Descricao Item
	aAdd( aRet, { "dDtValDes"  , "C",  91,   6,  0 } )	// Data Validade Desenho
	aAdd( aRet, { "nVlSubTrib" , "N",  97,  17,  0 } )	// Valor Subs. Tributaria
	aAdd( aRet, { "nBsCalST"   , "N", 114,  15,  0 } )	// Base Calc. Subs. Trib. Item
EndIf

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PEGAITPC บAutor  ณ Ernani Forastieri  บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Pega numero do item do Pedido de Compra                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PegaItPC( cPedido, cCod, _cNewFil )
Local aArea    := GetArea()
Local aAreaSC7 := SC7->( GetArea() )
Local aAreaSA2 := SA2->( GetArea() )
Local cRet := ""

dbSelectArea( "SC7" )
dbSetOrder( 4 )
If dbSeek( _cNewFil +  cCod + cPedido )
	cRet := SC7->C7_ITEM                                      
Else                    
	// Grava Log de Erro - CNPJ da Della Via nใo cadastrado
    /*
	GravaLog("03","Pedido de compra inexistente. Pedido: " + cPedido)
	nCtErro++ 
	*/
EndIf	

RestArea( aAreaSC7 ) 
RestArea( aAreaSA2 ) 
RestArea( aArea )

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GRAVALOG บAutor  ณ Marcos Augusto Diasบ Data ณ  14/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava inconsist๊ncias arquivo Text EDI Pirelli             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaLog( _cCodErr, _cMsgErr )

dbSelectArea("UA9")
RecLock("UA9",.T.)

UA9->UA9_PROCES := StrZero(nProcess,10)
UA9->UA9_CODERR := _cCodErr
UA9->UA9_MSGERR := _cMsgErr      
UA9->UA9_FILIAL := cFilNew

If _cCodErr $ "02/03/04/06/07/08/09/10"
	UA9->UA9_DOC    := M->F1_DOC
	UA9->UA9_SERIE  := M->F1_SERIE
	UA9->UA9_FORNEC := SubStr(cForPad,1,6)
	UA9->UA9_LOJA   := SubStr(cForPad,7,2)
EndIf

If _cCodErr $ "06"
	
	// Move os arquivos para seus diret๓rios correspondentes
	_cDir := GETMV("ES_ARQLOG")	// "C:\PROTHEUS8\PROTHEUS_DATA\DATA\LOGS\"

   _cArqOri := NomeAutoLog() 
   // _cArqOri := AllTrim(cArqTXT)     
	
	_cArqDes := _cDir + "Log_"+SubStr(U_PegaFile( cArqTXT ),1,At(".",U_PegaFile( cArqTXT ))-1)+"_"+Dtos(date(),.f.,1)+"_"+StrTran(time(),":","")+".log" // NomeAutoLog()	

	__CopyFile (_cArqOri,_cArqDes )             
	
	FErase(_cArqOri)

	UA9->UA9_AUTOLG := U_PegaFile( _cArqDes )
	
EndIf

If !_cCodErr $ "01/05/02/07"
	UA9->UA9_PEDIDO := M->D1_PEDIDO
	UA9->UA9_ITEMPC := cItemPC // M->D1_ITEMPC
EndIf

UA9->UA9_STATUS := Iif(_cCodErr == "04","0","1")
UA9->UA9_ARQEDIP:= U_PegaFile( cArqTXT )
UA9->UA9_DTBASE := dDataBase
UA9->UA9_DATA   :=  MsDate()
UA9->UA9_HORA   := Time()
UA9->UA9_ENVIRO := GetEnvServer()
UA9->UA9_PATCH  := GetSrvProfString( "Startpath", "" )
UA9->UA9_ROOT   := GetSrvProfString( "SourcePath", "" )
UA9->UA9_VERSAO := GetVersao()
UA9->UA9_MODULO := "SIGA" + cModulo
UA9->UA9_EMPFIL := SM0->M0_CODIGO + "/" + SM0->M0_CODFIL
UA9->UA9_NMEMPR := Capital( Trim( SM0->M0_NOME ) )
UA9->UA9_NMFIL  := Capital( Trim( SM0->M0_FILIAL ) )
UA9->UA9_USER   := SubStr( cUsuario, 7, 15 )
MsUnlock()

Return

//////////////////////////////////////////////////////////////////////////////
