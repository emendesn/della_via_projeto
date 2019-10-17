#Include "Protheus.Ch"
#Include "TopConn.ch"

Set Delete On
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | UDELSF3.prw       | AUTOR | Rodrigo Artur  | DATA | 08/11/05   |//
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
Local aArea   := {}
Local cFiltro := ""
Local cKey    := ""
Local cArq    := ""
Local nIndex  := 0
Local aSay    := {}
Local aButton := {}
Local nOpcao  := 0
Local cDesc1  := "Este programa tem o objetivo de retirar o sinalizador de exclusao dos"
Local cDesc2  := "registros do Livro Fiscal que foram excluidos erroneamente. "
Local cDesc3  := "Aconselha-se que o usuário tenha muito cuidado a executar a mesma."
Local aCpos   := {}
Local aCampos := {}
Local cMsg    := ""
Local aEstruSF3:= SF3->(DbStruct())
Local cQuery  := " " 

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
//| mv_par01 - Data Emissao de    ? 99/99/99               |
//| mv_par02 - Data Emissao ate   ? 99/99/99               |
//| mv_par03 - Forncedor de       ? 999999                 |
//| mv_par04 - Fornecedor ate     ? 999999                 |
//| mv_par05 - Filtrar            ? Todos/Manutenção       |
//+--------------------------------------------------------+

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return()
Endif


//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
aAdd( aRotina ,{"Pesquisar" ,"AxPesqui()"   ,0,1})
aAdd( aRotina ,{"Acerta" ,"u_Acerta()",0,3})
//aAdd( aRotina ,{"Legenda"   ,"u_Legenda()"  ,0,4})
             
//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
aCpos := {"F3_FILIAL","F3_ENTRADA","F3_NFISCAL","F3_SERIE","F3_CLIEFOR","F3_LOJA","F3_CFO","F3_FORMUL"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
   dbSeek(aCpos[nI])
//   aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
   aAdd(aCampos,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
Next
Aadd(aCampos,{"RECSF3","N",20,0})
Aadd(aCampos,{"F3_OK","C",01,0})
cArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,"DBFNTX",cArq,"SF31")

//+----------------------------------------------------------------------------
//| Monta o filtro especifico para MarkBrow()
//+----------------------------------------------------------------------------
dbSelectArea("SF3")
aArea := GetArea()
cKey  := IndexKey()

//cAliasSF3	:= "SF3TMP"
cCount		:= " SELECT COUNT(*) AS TOTREGS"
cQuery		:= " SELECT SF3.F3_FILIAL,SF3.F3_ENTRADA,SF3.F3_NFISCAL,SF3.F3_SERIE,SF3.F3_CLIEFOR,"
cQuery		+= " SF3.F3_LOJA,SF3.F3_CFO,SF3.F3_FORMUL,SF3.R_E_C_N_O_ AS RECSF3 "
cQuery		+= " FROM "+RetSqlName("SF3")+" SF3(NOLOCK) "
cQuery		+= " WHERE SF3.F3_FILIAL  BETWEEN '"+mv_par01+"'     AND  '"+mv_par02+"' "
cQuery		+= " AND SF3.F3_ENTRADA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
cQuery		+= " AND SF3.F3_CFO BETWEEN     '"+mv_par05+"'       AND  '"+mv_par06+"' "
cQuery		+= " AND SF3.F3_FORMUL='S' "
cQuery		+= " AND SF3.D_E_L_E_T_='*' "
//cQuery		+= " ORDER BY SF3.F3_FILIAL,SF3.F3_ENTRADA,SF3.F3_NFISCAL,SF3.F3_SERIE,SF3.F3_CLIEFOR"
//cQuery		+= " SF3.F3_LOJA,SF3.F3_CFO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conta a quantidade de registros                            				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If Select(cAliasSF3) > 0
	DbSelectArea(cAliasSF3)
	DbCloseArea()
Endif
nTotRegs := (cAliasSF3)->TOTREGS
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a query com os registros a serem processados         				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select(cAliasSF3) > 0
	DbSelectArea(cAliasSF3)
	DbCloseArea()
Endif
*/
cQuery := ChangeQuery(cQuery)
SQLtoTRB(cQuery,aCampos,"SF31")
/*
cTrab := cAliasSF3 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)
 */
/*
dbselectarea (cAliasSF3)
dbGoTop()
dbSelectArea ("SF31")
Append From cAliasSF3
*/
cMarcaF1 := GetMark()
lInverteF1 := .F.

//+----------------------------------------------------------------------------
//| Apresenta o MarkBrowse para o usuario
//+----------------------------------------------------------------------------
cMarca := GetMark()
//MarkBrow("SF31","F3_OK",,aCampos,.T.,@cMarca,,,,,"u_MarcaBox()")
MarkBrow("SF31","F3_OK",,aCampos,.T.,@cMarca)

//+----------------------------------------------------------------------------
//| Desfaz o indice e filtro temporario
//+----------------------------------------------------------------------------
dbSelectArea("SF3")
RetIndex("SF3")
Set Filter To
FErase( cArq )
FErase( cTrab )
RestArea( aArea )
Return Nil

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
Local aRegs  := {}
//+----------------------------------------------------------------------------
//| Guarda os dados chave de todas as nota fiscais marcadas
//+----------------------------------------------------------------------------
dbSelectArea("SF31")
dbGoTop()
While !Eof()
   If SF31->F3_OK <> cMarca
      dbdelete()
      Loop
   Endif
   aAdd( aRegs,SF31->RECSF3 )
   dbSkip()
End

cMsg += Chr(10)+Chr(13)+OemToAnsi("Confirma a(s) nota(s) marcada(s) para manutencao ?")

//+----------------------------------------------------------------------------
//| Solicita a confirmacao das notas fiscais
//+----------------------------------------------------------------------------
If Len(aRegs)>0
   If MsgYesNo(cMsg,"Confirmação")
      Ok_Acerta()
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

DbSelectArea("SF31")
DbGoTop()
While !Eof()
	DbSelectArea("SF3")
	DbGoTo(SF31->RECSF3)
	If deleted()
		dbRecall()
	EndIf
	DbSelectArea("SF3")
	DbGoTo(SF31->RECSF3)
	Reclock("SF3",.F.)
		F3_DTCANC := F3_ENTRADA
		F3_OBSERV := "NOTA CANCELADA"    
    MsUnlock()
	DbSelectArea("SF31")
	dbSkip()	
End	

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

AADD(aRegs,{cPerg,"01","Filial de           ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","  ","","","","","","","","","","","","","","","","","","","","","SM0",""})
AADD(aRegs,{cPerg,"02","Filial Ate          ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","ZZ","","","","","","","","","","","","","","","","","","","","","SM0",""})
AADD(aRegs,{cPerg,"03","Data Entrada de     ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Data Entrada Ate    ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","CFOP inicial        ?","","","mv_ch5","C",05,0,0,"G","","mv_par05","","","","     ","","","","","","","","","","","","","","","","","","","","","13",""})
AADD(aRegs,{cPerg,"06","CFOP final          ?","","","mv_ch6","C",05,0,0,"G","","mv_par06","","","","ZZZZZ","","","","","","","","","","","","","","","","","","","","","13",""})

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