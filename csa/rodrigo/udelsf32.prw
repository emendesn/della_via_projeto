#Include "Protheus.Ch"
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | UDELSF32.prw       | AUTOR | Rodrigo Artur  | DATA | 08/11/05   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO |  Corrige o SF3, fazendo com que as Notas Canceladas no SF2      |//
//|           |  possam estar canceladas tambem no SF3 e não excluidas      	|//
//|           | 											                    |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function UDELSF32()
//+----------------------------------------------------------------------------
//| Atribuicao de variaveis
//+----------------------------------------------------------------------------
Local cKey    := ""
Local nIndex  := 0
Local aSay    := {}
Local aButton := {}
Local nOpcao  := 0
Local cDesc1  := "Este programa tem o objetivo de retirar o sinalizador de exclusao dos"
Local cDesc2  := "registros do Livro Fiscal que foram excluidos erroneamente. "
Local cDesc3  := "Aconselha-se que o usuário tenha muito cuidado a executar a mesma."

Private aArea   := {}
Private aRegs       := {}
Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := OemToAnsi("Acerto de Cancelamento de Nota Via SF2")
Private cPerg       := "USDEL2"
Private nTotal      := 0
Private cArquivo    := ""
Private cSerNota    := "" 
Private cNumNota    := ""
Private aOtimizacao := {}
Private aLivro      := {}
//+----------------------------------------------------------------------------
//| Monta tela de interacao com usuario
//+----------------------------------------------------------------------------
aAdd(aSay,cDesc1)
aAdd(aSay,cDesc2)
aAdd(aSay,cDesc3)

aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
aAdd(aButton, { 2,.T.,{|| FechaBatch()              }})

//FormBatch(<cTitulo>,<aMensagem>,<aBotoes>,<bValid>,nAltura,nLargura)
FormBatch(cCadastro,aSay,aButton)

//+----------------------------------------------------------------------------
//| Se cancelar sair
//+----------------------------------------------------------------------------
If nOpcao <> 1
   Return Nil
Endif

//+--------------------------------------------------------+
//| Parametros utilizado no programa                       |
//+--------------------------------------------------------+
//| mv_par01 - Data Entrada de  ? 99/99/99                 |
//| mv_par02 - Data Entrada de  ? 99/99/99                 |
//+--------------------------------------------------------+

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return()
Endif

Processa({|lEnd|Selecao()})

SET DELETED ON
dbSelectArea("SF2")
RetIndex("SF2")
Set Filter To
dbSelectArea("SF21")
dbCloseArea()
FErase("SF21")
RestArea( aArea )

Return Nil
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| funcao    | SELECAO       | AUTOR | Rodrigo Artur      | DATA | 09/11/05 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Ok_Acerta()                                            |//
//|           |                                                                 |//
//|           | Se usuario confirmar a transferencia sera executada             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function SELECAO()

Local cMsg    := ""
Local cQuery  := " " 
Local nRec    :=0
Local nI      :=0
Local nL      :=0
Local aCpos   := {}
Local aCampos := {}
Local aSF21   := {}
Local cArq    := ""
Local cSer    := "" 
Local cNum    := ""
//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
//aAdd( aRotina ,{"Pesquisar" ,"AxPesqui()"   ,0,1})
aAdd( aRotina ,{"Acerta" ,"u_Corrige()",0,3})
//aAdd( aRotina ,{"MarcaTodos"   ,"u_MarcaTodos()"  ,0,4})
             
//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
aCpos := {"F2_FILIAL","F2_EMISSAO","F2_DOC","F2_SERIE","F2_CLIENTE","F2_LOJA"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
   dbSeek(aCpos[nI])
   aAdd(aSF21,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
Next

Aadd(aSF21,{"RECSF2","N",20,0})
Aadd(aSF21,{"F2_OK","C",02,0})

cArq := CriaTrab(aSF21,.T.)
dbUseArea(.T.,"DBFNTX",cArq,"SF21")

//+----------------------------------------------------------------------------
//| Monta o filtro especifico para MarkBrow()
//+----------------------------------------------------------------------------
aArea := GetArea()

SET DELETED OFF

dbSelectArea("SF2")
dbSetOrder(1)
While !eof() 
	If (SF2->F2_FILIAL == xFilial("SF2") .and. SF2->F2_EMISSAO >= mv_par01 .and.; 
		mv_par02 >= SF2->F2_EMISSAO) .and. deleted()
		cSer    := SF2->F2_SERIE 
		cNum    := SF2->F2_DOC
		nRec := Recno()
		dbSelectArea("SF3")
		dbSetOrder(5)
		If !MsSeek(SF2->F2_FILIAL + cSer + cNum )
			dbSelectArea("SF21")
			Reclock("SF21", .T.)
				SF21->F2_FILIAL  	:= SF2->F2_FILIAL 
				SF21->F2_EMISSAO 	:= SF2->F2_EMISSAO
				SF21->F2_DOC 		:= SF2->F2_DOC
				SF21->F2_SERIE   	:= SF2->F2_SERIE
				SF21->F2_CLIENTE 	:= SF2->F2_CLIENTE
				SF21->F2_LOJA    	:= SF2->F2_LOJA
				SF21->RECSF2     	:= nRec
   			Msunlock()
   		EndIf
   	EndIf
   	dbSelectArea("SF2")
    dbskip()
End
	//+----------------------------------------------------------------------------
	//| Apresenta o MarkBrowse para o usuario
	//+----------------------------------------------------------------------------
dbSelectArea("SF21") 
DbGotop()
If eof()
	MsgStop("Nao foi encontrado registro")
Else
	Aadd(aCampos,{"F2_OK","","",""})
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nL:= 1 To Len(aCpos)
		dbSeek(aCpos[nL])
		aAdd(aCampos,{X3_CAMPO,"",Trim(X3_TITULO),Trim(X3_PICTURE)})
	Next
	cMarca := GetMark()
		//MarkBrow("SF31","F3_OK",,aCampos,.T.,@cMarca,,,,,"u_MarcaBox()")
	MarkBrow("SF21","F2_OK",,aCampos,.F.,cMarca,"uSeltodos()",,,,"u_SelBox()" )
EndIf

Return
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| Função    | Marcabox       | AUTOR | Rodrigo Artur      | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_MarcaBox()                                           |//
//|           |                                                                 |//
//|           | Marca ou desmarca o registro para processamento                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function SelBox()
If IsMark("F2_OK",cMarca )
   RecLock("SF21",.F.)
   SF21->F2_OK := Space(2)
   MsUnLock()
Else
	RecLock("SF21",.F.)
    SF21->F2_OK := cMarca
    MsUnLock()
Endif
MarkBRefresh ( )

Return .T.


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| Função       | MarcaTodos        | AUTOR |Rodrigo Artur| DATA | 10/11/2005  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_MarcaBox()                                           |//
//|           |                                                                 |//
//|           | Marca todos  registros para processamento                       |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function SelTodos()

dbSelectArea("SF21")
dbGotop()
While !eof()
	RecLock("SF21",.F.)
    SF21->F2_OK := cMarca
    MsUnLock()
End
MarkBRefresh ( )

Return .T.

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| Funcao    |Acerta        | AUTOR | Rodrigo Artur        | DATA | 09/11/05   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Acerta()                                             |//
//|           |                                                                 |//
//|           | Corrige os registros marcados                                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Corrige()

Local cMsg   := ""
//+----------------------------------------------------------------------------
//| Guarda os dados chave de todas as nota fiscais marcadas
//+----------------------------------------------------------------------------

dbSelectArea("SF21")
dbGoTop()
While !Eof()
   	If SF21->F2_OK == cMarca
   		aAdd( aRegs,SF21->RECSF2 )
		dbSkip()
		Loop
   	Else
		dbSkip()
	EndIf
End

cMsg := Chr(10)+Chr(13)+OemToAnsi("Confirma a(s) nota(s) marcada(s) para manutencao ?")
//+----------------------------------------------------------------------------
//| Solicita a confirmacao das notas fiscais
//+----------------------------------------------------------------------------
If Len(aRegs)>0
   If MsgYesNo(cMsg,"Confirmação")
//      Processa({||Execute(@Ok_Acerta)},"Corrigindo Livros Fiscais...")
	  Processa({|lEnd|Ok_Acerta()})
   Endif
Endif

Return 
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| funcao    | OK_ACERTA       | AUTOR | Rodrigo Artur      | DATA | 09/11/05 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Ok_Acerta()                                            |//
//|           |                                                                 |//
//|           | Se usuario confirmar a transferencia sera executada             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function Ok_Acerta()
Local nj :=0

DbSelectArea("SF2")
ProcRegua(Len(aRegs))
For nj := 1 To Len(aRegs)
   	dbGoTo(aRegs[nj])
	RecLock("SF2",.F.)
		dbRecall()
	MsUnLock()
	dbSelectArea("SD2")
	dbSetOrder(3)
	If MsSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA);
				.and. deleted()		
			RecLock("SD2",.F.)
				dbRecall()
			MsUnLock()
			dbSkip()
		End	 
	EndIf	
	cSerNota := SF2->F2_SERIE
	cNumNota := SF2->F2_DOC
	IncProc("Atualizando Notas Fiscais...")
 	MaFisIniNF(2,SF2->(Recno()),@aOtimizacao,"SF2",.T.)
// 	MaFisIniNF(2,aRegs[nj],@aOtimizacao,"SF2",.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a gravacao nas funcoes Fiscais               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisWrite()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a gravacao dos registros referente a Nota no SF3 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	MaFisAtuSF3(1,"S",SF2->(Recno()),"SF2")
	dbSelectArea("SF3")
	dbSetOrder(5)
	If MsSeek( xFilial("SF3") + cSerNota + cNumNota )
		While !Eof() .AND. xFilial("SF3")+cSerNota+cNumNota == SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL
			RecLock("SF3",.F.)
			SF3->F3_DTCANC := SF3->F3_EMISSAO
			SF3->F3_OBSERV := "NF CANCELADA"
			SF3->(MsUnLock())
			MaFisEnd()
			MsUnLock()
			SF3->(dbSkip())
		Enddo
	Endif
	dbSelectArea("SD2")
	dbSetOrder(3)
	If MsSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA) ;
				.and. !deleted()		
		While dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA);
				.and. !deleted()		
			RecLock("SD2",.F.)
				dbDelete()
			MsUnLock()
			DbSkip()
		End	 
	EndIf
	dbSelectArea("SF2")
	RecLock("SF2",.F.)
		dbDelete()
	MsUnLock()
Next


MarkBRefresh ( )

Return
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ValidPerg      | AUTOR | Rodrigo Artur        | DATA | 08/11/2005 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO |	Criar registros SX1                                             |//
//|           |                													|//
//|           |                    												|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea  	:= GetArea()
Local aRegs 	:= {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
/*
AADD(aRegs,{cPerg,"01","Filial de           ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","  ","","","","","","","","","","","","","","","","","","","","","SM0",""})
AADD(aRegs,{cPerg,"02","Filial Ate          ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","ZZ","","","","","","","","","","","","","","","","","","","","","SM0",""})
*/
AADD(aRegs,{cPerg,"01","Data Entrada        ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Entrada Ate    ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
/*
AADD(aRegs,{cPerg,"05","CFOP inicial        ?","","","mv_ch5","C",05,0,0,"G","","mv_par05","","","","     ","","","","","","","","","","","","","","","","","","","","","13",""})
AADD(aRegs,{cPerg,"06","CFOP final          ?","","","mv_ch6","C",05,0,0,"G","","mv_par06","","","","ZZZZZ","","","","","","","","","","","","","","","","","","","","","13",""})
*/
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
   EndIf
Next

RestArea(aArea)
Return Nil