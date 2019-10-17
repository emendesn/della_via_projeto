#Include "Protheus.Ch"
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | UDELSF31.prw       | AUTOR | Rodrigo Artur  | DATA | 08/11/05   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO |  Acerta o SF3, fazendo com que as Notas Canceladas no Sigaloja  |//
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

User Function UDELSF31()
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
Private cCadastro   := OemToAnsi("Acerto de Cancelamento de Nota")
Private cPerg       := "USDELS"
Private nTotal      := 0
Private cArquivo    := ""

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
dbSelectArea("SF3")
RetIndex("SF3")
Set Filter To
dbSelectArea("SF31")
dbCloseArea()
FErase("SF31")
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
Local aSF31   := {}
Local cArq    := ""

//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
//aAdd( aRotina ,{"Pesquisar" ,"AxPesqui()"   ,0,1})
aAdd( aRotina ,{"Acerta" ,"u_Acerta()",0,3})
//aAdd( aRotina ,{"MarcaTodos"   ,"u_MarcaTodos()"  ,0,4})
             
//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
aCpos := {"F3_FILIAL","F3_ENTRADA","F3_NFISCAL","F3_SERIE","F3_CLIEFOR","F3_LOJA","F3_CFO","F3_FORMUL"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
   dbSeek(aCpos[nI])
   aAdd(aSF31,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
Next

Aadd(aSF31,{"RECSF3","N",20,0})
Aadd(aSF31,{"F3_OK","C",02,0})

cArq := CriaTrab(aSF31,.T.)
dbUseArea(.T.,"DBFNTX",cArq,"SF31")

//+----------------------------------------------------------------------------
//| Monta o filtro especifico para MarkBrow()
//+----------------------------------------------------------------------------
aArea := GetArea()

SET DELETED OFF

dbSelectArea("SF3")
dbSetOrder(1)
While !eof() 
	If SF3->F3_FILIAL == xFilial() .and. SF3->F3_ENTRADA >= mv_par01 .and. mv_par02 >= SF3->F3_ENTRADA .and. deleted()
		IncProc("Selecionando Registros Excluidos...")
//		If deleted() .and. SF3->F3_FORMUL=="S" 
		nRec := Recno()
		dbSelectArea("SF31")
		Reclock("SF31", .T.)
			F3_FILIAL  := SF3->F3_FILIAL 
			F3_ENTRADA := SF3->F3_ENTRADA
			F3_NFISCAL := SF3->F3_NFISCAL
			F3_SERIE   := SF3->F3_SERIE
			F3_CLIEFOR := SF3->F3_CLIEFOR
			F3_LOJA    := SF3->F3_LOJA
			F3_CFO     := SF3->F3_CFO
			F3_FORMUL  := SF3->F3_FORMUL
			RECSF3     := nRec
   		Msunlock()
   	EndIf
   	dbSelectArea("SF3")
    dbskip()
End
	//+----------------------------------------------------------------------------
	//| Apresenta o MarkBrowse para o usuario
	//+----------------------------------------------------------------------------
dbSelectArea("SF31") 
DbGotop()
If eof()
	MsgStop("Nao foi encontrado registro")
Else
	Aadd(aCampos,{"F3_OK","","",""})
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nL:= 1 To Len(aCpos)
		dbSeek(aCpos[nL])
		aAdd(aCampos,{X3_CAMPO,"",Trim(X3_TITULO),Trim(X3_PICTURE)})
	Next
	cMarca := GetMark()
		//MarkBrow("SF31","F3_OK",,aCampos,.T.,@cMarca,,,,,"u_MarcaBox()")
	MarkBrow("SF31","F3_OK",,aCampos,.F.,cMarca,"uMarcaTodos()",,,,"u_MarcaBox()" )
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
User Function MarcaBox()
If IsMark("F3_OK",cMarca )
   RecLock("SF31",.F.)
   SF31->F3_OK := Space(2)
   MsUnLock()
Else
	RecLock("SF31",.F.)
    SF31->F3_OK := cMarca
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
User Function MarcaTodos()

dbSelectArea("SF31")
dbGotop()
While !eof()
	RecLock("SF31",.F.)
    SF31->F3_OK := cMarca
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
User Function Acerta()

Local cMsg   := ""
//+----------------------------------------------------------------------------
//| Guarda os dados chave de todas as nota fiscais marcadas
//+----------------------------------------------------------------------------

dbSelectArea("SF31")
dbGoTop()
While !Eof()
   	If SF31->F3_OK == cMarca
   		aAdd( aRegs,SF31->RECSF3 )
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

DbSelectArea("SF3")
ProcRegua(Len(aRegs))
For nj := 1 To Len(aRegs)
   	dbGoTo(aRegs[nj])
	IncProc("Atualizando Notas Fiscais...")
	If deleted()
		Reclock("SF3",.F.)
			dbRecall()
	    MsUnLock()
	EndIf
   	dbGoTo(aRegs[nj])
	Reclock("SF3",.F.)
		F3_DTCANC := SF3->F3_ENTRADA
		F3_OBSERV := "CANCELADA"    
    MsUnlock()
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
