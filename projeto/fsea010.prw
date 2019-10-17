#INCLUDE "FSEA010.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA010  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para manutencao Cad. de Pacotes des Exportacao      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FSEA010()
Local   cFiltSX2   := ""
Local   bFiltSX2   := NIL
Private nUsado     := 0
Private cCadastro  := STR0001 //"Configurador de Pacotes"
Private cFilUA1    := ""
Private cFilUA2    := ""
Private cFilUA3    := ""
Private aSM0Ori    := CarregaSM0()
Private aRotina    := {}
Private aCores     := {}

aAdd ( aCores, { "UA1_STATUS == '0'", 'DISABLE'   } )  // Vermelho - Inativo
aAdd ( aCores, { "UA1_STATUS == '1'", 'ENABLE'    } )  // Verde    - Ativo

aAdd( aRotina , {STR0002 , 'AxPesqui'       , 0, 1} ) //"Pesquisar"
aAdd( aRotina , {STR0003 , 'u_UA1Visual'    , 0, 2} ) //"Visualizar"
aAdd( aRotina , {STR0004 , 'u_UA1Inclui'    , 0, 3} ) //"Incluir"
aAdd( aRotina , {STR0005 , 'u_UA1Altera'    , 0, 4} ) //"Alterar"
aAdd( aRotina , {STR0006 , 'u_UA1Exclui'    , 0, 5} ) //"Excluir"
aAdd( aRotina , {STR0007 , 'u_UA1Copia'     , 0, 3} ) //"Copiar"
aAdd( aRotina , {STR0008 , 'u_UA1Ativa( "1" )', 0, 4} ) //"aTivar"
aAdd( aRotina , {STR0009 , 'u_UA1Ativa( "0" )', 0, 4} ) //"deSativar"
aAdd( aRotina , {STR0010 , 'u_UA1Legend()'  , 0, 2} ) //"Legenda"

Define Font oFontNor  Name "Arial" Size 0, -11
Define Font oFontNorB Name "Arial" Size 0, -11 Bold
Define Font oFontBold Name "Arial" Size 0, -13 Bold

// Limpa Filtro SX2
dbSelectArea( "SX2" )
_cFiltSX2 := dbFilter()
_bFiltSX2 := IIF( !Empty( _cFiltSX2 ), &( "{|| "+ALLTRIM( _cFiltSX2 )+" }" ), "" )
dbClearFilter()
dbGoTop()

dbSelectArea( "UA3" )
dbSetOrder( 1 )
cFilUA3 := xFilial( "UA3" )

dbSelectArea( "UA2" )
dbSetOrder( 1 )
cFilUA2 := xFilial( "UA2" )

dbSelectArea( "UA1" )
dbSetOrder( 1 )
cFilUA1 := xFilial( "UA1" )

mBrowse( , , , , "UA1", , , , "UA1_STATUS", 2, aCores, , , 2 )

// Restaura Filtro SX2
dbSelectArea( "SX2" )
If !Empty( _cFiltSX2 )
	dbSetFilter( _bFiltSX2, _cFiltSX2 )
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1VISIALบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para visualizacao do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Visual( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private aSM0      := {}

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "UA1" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := UA1->UA1_PACOTE

For nX:= 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "UA2" )
dbSetOrder( 1 )
dbSeek( cFilUA2 + cChave )

While !Eof() .and. ( cFilUA2 + cChave ) == UA2->( UA2_FILIAL+UA2->UA2_PACOTE )
	aAdd( aCols, Array( nUsado+1 ) )
	nCols++
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado+1] := .F.
	dbSelectArea( "UA2" )
	dbSkip()
End

//
// Monta o Array do ListBox
//
aSM0 := MarcaSM0( aSM0Ori, cChave )

UA1Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1INCLUIบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para inclusao     do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Inclui( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private aSM0      := {}

//
// Cria Variaveis de Memoria da Enchoice
//
dbSelectArea( "UA1" )
For nX := 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := CriaVar( FieldName( nX ), .T. )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
aAdd( aCols, Array( nUsado+1 ) )

nUsado := 0
dbSelectArea( "SX3" )
dbSetOrder( 1 )
dbSeek( "UA2" )
While !Eof() .and. SX3->X3_ARQUIVO == "UA2"
	If X3USO( SX3->X3_USADO ) .and. cNivel >= SX3->X3_NIVEL
		nUsado++
		aCols[1][nUsado] := CriaVar( Trim( SX3->X3_CAMPO ), .T. )
	EndIf
	dbSkip()
End

aCols[1][nUsado+1] := .F.

//
// Monta o Array do ListBox
//
aSM0 := MarcaSM0( aSM0Ori, '' )

If  UA1Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin Transaction
	If UA1Grava( nOpc, , aSM0 )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1ALTERAบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para alteracao    do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Altera( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Local   aAltera   := {}
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private aSM0      := {}

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "UA1" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := UA1->UA1_PACOTE

For nX := 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "UA2" )
dbSetOrder( 1 )
dbSeek( cFilUA2+cChave )

While !Eof() .and. ( cFilUA2+cChave ) == UA2->( UA2->UA2_FILIAL+UA2->UA2_PACOTE )
	aAdd( aCols, Array( nUsado+1 ) )
	nCols++
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado+1] := .F.
	dbSelectArea( "UA2" )
	aAdd( aAltera, Recno() )
	dbSkip()
End

//
// Monta o Array do ListBox
//
aSM0 := MarcaSM0( aSM0Ori, cChave )

If  UA1Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin Transaction
	If UA1Grava( nOpc, aAltera, aSM0 )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1EXCLUIบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para exclusao     do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Exclui( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private aSM0      := {}

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "UA1" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := UA1->UA1_PACOTE
For nX:= 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "UA2" )
dbSetOrder( 1 )
dbSeek( cFilUA2+cChave )

While !Eof() .and. ( cFilUA2+cChave ) == UA2->( UA2_FILIAL+UA2->UA2_PACOTE )
	aAdd( aCols, Array( nUsado+1 ) )
	nCols++
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado+1] := .F.
	dbSelectArea( "UA2" )
	dbSkip()
End

//
// Monta o Array do ListBox
//
aSM0 := MarcaSM0( aSM0Ori, cChave )

If  UA1Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin Transaction
	If UA1Grava( nOpc,, aSM0 )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1ATIVA บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para ativar/desativar os Pacotes                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Ativa( cStatus, X, Y, Z, A, B, C )
Local aArea := GetArea()

dbSelectArea( "UA1" )
RecLock( "UA1", .F. )
UA1->UA1_STATUS := cStatus
MsUnlock()
RestArea( aArea )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1COPIA บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para fazer copias dos Pacotes                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Copia()
Local aArea    := GetArea()
Local aAreaUA1 := UA1->( GetArea() )
Local cPctDe   := UA1->UA1_PACOTE
Local cPctPara := GetSXENum( "UA1", "UA1_PACOTE" )
Local  nX      := 0
Local lRet     := .F.
Local oDlg     := NIL
Local aStru    := {}
Local aRepl    := {}

dbSelectArea( "UA1" )
dbSetOrder( 1 )

Define MSDialog oDlg From    0, 0 To 145, 225 Title STR0011 Pixel Font oFontBold Of oMainWnd //"Copiar Pacote"
@   5, 5 To  47, 110 Label ""          Pixel Of oDlg
@  15, 10 Say STR0012      Size 70, 8   Pixel Of oDlg //"Copiar o Pacote"
@  30, 10 Say STR0013      Size 70, 8   Pixel Of oDlg //"Para"
@  15, 70 MsGet cPctDe     Size 25, 10 Valid ( IIF( !dbSeek( xFilial( "UA1" ) + cPctDe )   .or. Empty( cPctDe )  , ( ApMsgStop( STR0014, STR0015 ), .F. ) , .T. ) ) F3 "UA1" Pixel Of oDlg //"O Pacote de origem nใo existe ou estแ em branco."###"ATENวรO"
@  30, 70 MsGet cPctPara   Size 25, 10 Valid ( IIF( dbSeek( xFilial( "UA1" ) + cPctPara ) .or. Empty( cPctPara ), ( ApMsgStop( STR0016, STR0015 ), .F. ) , .T. ) ) Pixel Of oDlg //"O Pacote de destino jแ existe ou estแ em branco."###"ATENวรO"

Define SButton From 55, 50 Type 2 Enable Action ( oDlg:End() ) Pixel Of oDlg
Define SButton From 55, 80 Type 1 Enable Action ( lRet := .T., oDlg:End() ) Pixel Of oDlg

Activate MSDialog oDlg Centered //Valid IIf(  cPctDe == cPctPara, (ApMsgStop( 'Origem e Destino estใo iguais', STR0015 ), .F.  ), .T. ) 

If !lRet
	If __lSX8
		RollBackSX8()
	EndIf
	Return NIL
EndIf

// Faz Cabecalho
dbSelectArea( "UA1" )
dbSeek( cFilUA1 + cPctDe )
aStru := UA1->( dbStruct() )

aRepl := {}
For nX := 1 to Len( aStru )
	aAdd( aRepl , {aStru[nX][1], UA1->( FieldGet( nX ) )} )
Next nX

Begin Transaction
// Joga pra memoria os dados e grava
RecLock( "UA1", .T. )
For nX := 1 to Len( aStru )
	FieldPut( nX, aRepl[nX][2] )
Next nX
UA1->UA1_PACOTE := cPctPara
MsUnlock()


// Faz Itens
dbSelectArea( "UA2" )
dbSeek( cFilUA2 + cPctDe )
aStru := UA2->( dbStruct() )

While !Eof() .and. ( cFilUA2 + cPctDe ) == UA2->( UA2_FILIAL+UA2_PACOTE )
	
	nRecUA2 := UA2->( Recno() )
	
	aRepl   := {}
	
	// Joga pra memoria os dados e grava
	For nX := 1 to Len( aStru )
		aAdd( aRepl , { aStru[nX][1], UA2->( FieldGet( nX ) )} )
	Next nX
	
	RecLock( "UA2", .T. )
	For nX := 1 to Len( aStru )
		FieldPut( nX, aRepl[nX][2] )
	Next nX
	UA2->UA2_PACOTE := cPctPara
	MsUnlock()
	
	dbSelectArea( "UA2" )
	// Volta posicao antes de incluir novo registro
	dbGoTo( nRecUA2 )
	dbSkip()
End

EvalTrigger()

// Faz Empresas Filiais Destino
dbSelectArea( "UA3" )
dbSeek( cFilUA3 + cPctDe )
aStru := UA3->( dbStruct() )

While !Eof() .and. ( cFilUA3 + cPctDe ) == UA3->( UA3_FILIAL+UA3_PACOTE )
	
	nRecUA3 := UA3->( Recno() )
	
	aRepl   := {}
	
	// Joga pra memoria os dados e grava
	For nX := 1 to Len( aStru )
		aAdd( aRepl , { aStru[nX][1], UA3->( FieldGet( nX ) )} )
	Next nX
	
	RecLock( "UA3", .T. )
	For nX := 1 to Len( aStru )
		FieldPut( nX, aRepl[nX][2] )
	Next nX
	UA3->UA3_PACOTE := cPctPara
	MsUnlock()
	
	dbSelectArea( "UA3" )
	// Volta posicao antes de incluir novo registro
	dbGoTo( nRecUA3 )
	dbSkip()
End

If __lSX8
	ConfirmSX8()
EndIf

End Transaction

RestArea( aAreaUA1 )
RestArea( aArea )
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCRIAHEADERบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para criacao do aHeader                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaHeader()
nUsado  := 0
aHeader := {}

dbSelectArea( "SX3" )
dbSetOrder( 1 )
dbSeek( "UA2" )
While ( !Eof() .and. SX3->X3_ARQUIVO == "UA2" )
	If ( X3USO( SX3->X3_USADO ) .and. cNivel >= SX3->X3_NIVEL )
		aAdd( aHeader, { Trim( X3Titulo() ), ;
		SX3->X3_CAMPO   , ;
		SX3->X3_PICTURE , ;
		SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL , ;
		SX3->X3_VALID   , ;
		SX3->X3_USADO   , ;
		SX3->X3_TIPO    , ;
		SX3->X3_ARQUIVO , ;
		SX3->X3_CONTEXT } )
		nUsado++
	EndIf
	dbSkip()
End

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1LINOK บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validacao da Linha da GetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1LinOk()
Local aArea    := GetArea()
Local aAreaSX3 := SX3->( GetArea() )
Local cCpoMSEXP:= ""
Local cMsg     := ""
Local lRet     := .T.
Local nPosTab  := 0
Local nI       := 0

If aCols[n][nUsado+1]
	Return lRet
EndIf

nPosTab := aScan( aHeader, {|x| Trim( x[2] )=="UA2_TABELA"} )
nPosOrd := aScan( aHeader, {|x| Trim( x[2] )=="UA2_ORDEM" } )

For nI := 1 To Len( aCols )
	If !aCols[nI][nUsado+1]
		If aCols[n][nPosTab] == aCols[nI][nPosTab]
			If n <> nI
				cMsg := STR0017 //"TABELA jแ cadastrada."
				lRet := .F.
				Help( "", 1, "", "UA1LinOk", cMsg, 1, 0 )
				Exit
			EndIf
		EndIf
		If aCols[n][nPosOrd] == aCols[nI][nPosOrd]
			If n <> nI
				cMsg := STR0038 //"ORDEM jแ utilizada."
				lRet := .F.
				Help( "", 1, "", "UA1LinOk", cMsg, 1, 0 )
				Exit
			EndIf
		EndIf
	EndIf
Next

If lRet
	//Verifica Existencia de MSEXP
	lRet := ExisMSExp( aCols[n][nPosTab] )
EndIf

If lRet
	//Verifica Existencia de Indice por MSEXP
	lRet := ExisIMSExp( aCols[n][nPosTab] )
EndIf

If lRet
	//Verifica Se nao eh dicionario
	If SubStr( aCols[n][nPosTab], 1, 2 ) == "SX"
		cMsg := STR0018 + CRLF //"Arquivo de Diconแrio nใo"
		cMsg += STR0019         //"podem ser exportados."
		lRet := .F.
		Help( "", 1, "", "UA1LinOk", cMsg, 1, 0 )
	EndIf
EndIf

If lRet
	aSort( aCols, , , {|x, y| x[nPosOrd] < y[nPosOrd] } )
	oGet:Refresh()
EndIf

RestArea( aAreaSX3 )
RestArea( aArea )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1TUDOK บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validacao da Geral da GetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1TudOk()
Local aArea      := GetArea()
Local aAreaUA1   := UA1->( GetArea() )
Local lRet       := .T.
Local cMsg       := ""
Local nCount     := 0
Local nI         := 0
Local nJ         := 0
Local nPosTab    := aScan( aHeader, {|x| Trim( x[2] )=="UA2_TABELA"} )
Local lMarcou    := .F.

//
// Verifica se tem pelo menos 1 item e se ele nao esta vazio
//
For nI := 1 To Len( aCols )
	If !aCols[nI][nUsado+1]
		lVazio := .T.
		For nJ := 1 To nUsado
			lVazio := IIF( !Empty( aCols[nI][nJ] ), .F., lVazio )
		Next nJ
		nCount += IIF( lVazio, 0, 1 )
		
		//
		// Verifica se a ultima linha nao esta vazia
		//
		If nI == Len( aCols ) .and. lVazio .and. Len( aCols ) > 1
			aCols[nI][nUsado+1] := .T.
		EndIf
		
	EndIf
	
Next nI

If  nCount == 0
	cMsg := STR0020 //"Nenhum item cadastrado."
	Help( "", 1, "", "UA1TudOk", cMsg, 1, 0 )
	lRet := .F.
EndIf

// Verifica Intervalo e Unid. Tempo

If lRet
	If M->UA1_UNITEM == "C" .and. ( M->UA1_INTERV < 1 .or. M->UA1_INTERV > 31 )
		cMsg := STR0021 + CRLF //"Intervalo invแlido para op็ใo"
		cMsg += "dia fixo."
		Help( "", 1, "", "UA1TudOk", cMsg, 1, 0 )
		lRet := .F.
	EndIf
EndIf

If lRet
	If M->UA1_UNITEM == "C" .and. M->UA1_INTERV > 28
		cMsg := STR0022 +Str( M->UA1_INTERV, 2 )   + CRLF //"Vc escolheu o dia fixo "
		cMsg += STR0023 + CRLF                          //"Existem meses que nใo tem esta quantidade de dias."
		cMsg += STR0024 + CRLF                          //"Isto acarretarแ problemas para  os cแlculos de data "
		cMsg += STR0025 + CRLF                          //"de execu็ใo."
		cMsg += STR0026                                  //"Tente utilizar a op็ใo ฺltimo Dia M๊s."
		ApMsgStop( cMsg, STR0015 )                         //"ATENวรO"
		lRet := .F.
	EndIf
EndIf

If lRet
	lMarcou := .F.
	For nI := 1 To Len( aSM0 )
		If aSM0[nI][1]
			lMarcou := .T.
		EndIf
	Next
	If !lMarcou
		lRet := .F.
		cMsg := STR0047 //"Nใo hแ empresas/filiais destino selecionadas"
		ApMsgStop( cMsg, STR0015 )                         //"ATENวรO"
	EndIf
EndIf

RestArea( aAreaUA1 )
RestArea( aArea   )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1GRAVA บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gravacao dos dados dos cadastros               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function UA1Grava( nOpc, aAltera, aSM0 )
Local aArea    := GetArea()
Local aAreaSM0 := SM0->( GetArea() )
Local lGravou  := .F.
Local nUsado   := 0
Local nX       := 0
Local nI       := 0
Local nPosTab  := aScan( aHeader, {|x| Trim( x[2] )=="UA2_TABELA"} )
Private bCampo := { |nField| FieldName( nField ) }

nUsado    := Len( aHeader ) + 1

//
// Se for inclusao
//
If nOpc == 3
	//
	// Colocar os itens em ordem
	//
	aSort( aCols, , , {|x, y| x[3] < y[3] } )
	
	//
	// Grava os Empresas/Filais
	//
	For nX := 1 To Len( aSM0 )
		If aSM0[nX][1]
			RecLock( "UA3", .T. )
			UA3->UA3_FILIAL := cFilUA2
			UA3->UA3_PACOTE := M->UA1_PACOTE
			UA3->UA3_CODIGO := aSM0[nX][2]
			UA3->UA3_CODFIL := aSM0[nX][3]
			MsUnLock()
			lGravou := .T.
		EndIf
	Next
	
	//
	// Grava os itens
	//
	dbSelectArea( "UA2" )
	dbSetOrder( 1 )
	For nX := 1 To Len( aCols )
		lDeletado := aCols[nX][nUsado]
		
		If !lDeletado
			RecLock( "UA2", .T. )
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCols[nX, nI] )
			Next nI
			UA2->UA2_FILIAL := cFilUA2
			UA2->UA2_PACOTE := M->UA1_PACOTE
			MsUnLock()
			lGravou := .T.
		EndIf
	Next
	
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( "UA1" )
		RecLock( "UA1", .T. )
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName( nX )
				FieldPut( nX, cFilUA1 )
			Else
				FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
			EndIf
		Next
		MsUnLock()
	EndIf
	
EndIf

//
// Se for alteracao
//
If nOpc == 4
	
	//
	// Grava os Empresas/Filais
	//
	For nX := 1 To Len( aSM0 )
		dbSelectArea( "UA3" )
		dbSetOrder( 1 )
		
		If dbSeek( xFilial( "UA3" ) + M->UA1_PACOTE + aSM0[nX][2] + aSM0[nX][3] )
			If !aSM0[nX][1]
				RecLock( "UA3", .F. )
				dbDelete()
				MsUnLock()
				UA1X2Del( "UA3" )
			EndIf
		Else
			If aSM0[nX][1]
				RecLock( "UA3", .T. )
				UA3->UA3_FILIAL := cFilUA2
				UA3->UA3_PACOTE := M->UA1_PACOTE
				UA3->UA3_CODIGO := aSM0[nX][2]
				UA3->UA3_CODFIL := aSM0[nX][3]
				MsUnLock()
			EndIf
		EndIf
	Next
	
	
	//
	// Grava os itens conforme as alteracoes
	//
	dbSelectArea( "UA2" )
	dbSetOrder( 1 )
	
	For nX := 1 To Len( aCols )
		lDeletado := aCols[nX][nUsado]
		
		If nX <= Len( aAltera )
			dbGoto( aAltera[nX] )
			RecLock( "UA2", .F. )
			
			If lDeletado
				dbDelete()
				UA1X2Del( "UA2" )
			EndIf
		Else
			If !lDeletado
				RecLock( "UA2", .T. )
			EndIf
		EndIf
		
		If !lDeletado
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCols[nX, nI] )
			Next nI
			UA2->UA2_FILIAL := cFilUA2
			UA2->UA2_PACOTE := M->UA1_PACOTE
			MsUnLock()
			lGravou := .T.
		EndIf
		
	Next
	
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( "UA1" )
		RecLock( "UA1", .F. )
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName( nX )
				FieldPut( nX, cFilUA1 )
			Else
				FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
			EndIf
		Next
		MsUnLock()
	Else
		dbSelectArea( "UA1" )
		RecLock( "UA1", .F. )
		dbDelete()
		MsUnLock()
		UA1X2Del( "UA1" )
	EndIf
EndIf

//
// Se for exclucao
//
If nOpc == 5
	
	//
	// Deleta as Empresas/Filais
	//
	dbSelectArea( "UA3" )
	dbSetOrder( 1 )
	cChave := M->UA1_PACOTE
	dbSeek( cFilUA3+cChave, .T. )
	
	While !Eof() .and. ( cFilUA3+cChave ) == UA3->( UA3_FILIAL+UA3_PACOTE )
		RecLock( "UA3", .F. )
		dbDelete()
		MsUnLock()
		dbSkip()
		UA1X2Del( "UA3" )
	End
	
	//
	// Deleta os Itens
	//
	dbSelectArea( "UA2" )
	dbSetOrder( 1 )
	cChave := M->UA1_PACOTE
	dbSeek( cFilUA2+cChave, .T. )
	
	While !Eof() .and. ( cFilUA2+cChave ) == UA2->( UA2_FILIAL+UA2_PACOTE )
		RecLock( "UA2", .F. )
		dbDelete()
		MsUnLock()
		dbSkip()
		UA1X2Del( "UA2" )
	End
	
	//
	// Deleta o Cabecalho
	//
	dbSelectArea( "UA1" )
	RecLock( "UA1" )
	dbDelete()
	MsUnLock()
	UA1X2Del( "UA1" )
	lGravou := .T.
EndIf

RestArea( aAreaSM0 )
RestArea( aArea )

Return lGravou


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1LEGENDบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para exibicao da legenda                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Legend()
Local aCores  := { { 'DISABLE', STR0027 }, ;  // Vermelho - Inativo   "Pacote Inativo"
{ 'ENABLE', STR0028 } }   // Verde    - Ativo    "Pacote Ativo"

BrwLegenda( cCadastro, STR0010, aCores ) //"Legenda"
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1X2Del บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gravacao SX2 deletados                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function UA1X2Del( cFilSX2 )
Local aArea    := GetArea()
Local aAreaSX2 := SX2->( GetArea() )

dbSelectArea( "SX2" )
dbSetOrder( 1 )
If dbSeek( cFilSX2 )
	RecLock( "SX2", .F. )
	SX2->X2_DELET := SX2->X2_DELET + 1
	MsUnLock()
EndIf

RestArea( aAreaSX2 )
RestArea( aArea    )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1TELA  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para montagek da tela da Enchoice /Getdados         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function UA1Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
Local lOpcA    := .F.
Local oDlg     := NIL
Local aButtons := { {"DESTINOS2", {|| u_UA1Renum( cAlias, nRecno, nOpc )}, STR0039}}	// "Cria Automatico"#"Multiplos" //"Renumerar Sequencia"
Local oLbx, oChkMar, oButInv, oMascEmp, oMascFil
Local oButMarc, oButDMar, oFontBold
Local cVar     := ''
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
Local lChk     := .F.
Local cMascEmp := "??"
Local cMascFil := "??"
Local lSoExibe := ( nOpc == 2 .or. nOpc == 5 )

Private oGet

Define Font oFontBold  Name "Arial" Size 0, -11 Bold
Define MSDialog oDlg Title cCadastro From 0, 0 TO 32, 120  OF oMainWnd

@  15, 01 Say "Dados Gerais" Size  40, 08 Font oFontBold Of oDlg Pixel
EnChoice( cAlias, nRecNo, nOpc, , , , , {25, 1, 110, 280}, , 3 )

@  115, 2 Say "Tabelas a Exportar" Size 100, 08 Font oFontBold Of oDlg Pixel
oGet := MSGetDados():New( 125, 2, 230, 470, nOpc, "u_UA1LinOk()", "u_UA1TudOk()", "", .T. )

@  15, 290 Say "Empresas/Filiais de Destino" Size  120, 08 Font oFontBold Of oDlg Pixel
@  25, 290 Listbox oLbx Var cVar Fields Header " ", " ", " ", "Empresa", "Filial" Size 178, 071 Of oDlg Pixel
oLbx:SetArray(  aSM0 )
oLbx:bLine := {|| {IIf( aSM0[ oLbx:nAt, 1], oOk, oNo ), aSM0[ oLbx:nAt, 2], ;
aSM0[ oLbx:nAt, 3], aSM0[ oLbx:nAt, 4], aSM0[ oLbx:nAt, 5]}}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. //NoScroll

If !lSoExibe
	oLbx:BlDblClick := {|| aSM0[ oLbx:nAt, 1] := !aSM0[ oLbx:nAt, 1], VerTodos( aSM0, @ lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
EndIf

@ 101, 290 CheckBox  oChkMar Var  lChk Prompt "Todos"  When !lSoExibe Message "Marca / Desmarca Todos" Size 40, 07 Pixel Of oDlg;
on Click MarcaTodos( lChk, @ aSM0, oLbx )

@ 100, 320 Button  oButInv  Prompt "&Inverter"  When !lSoExibe Size 27, 10 Pixel Action ( InvSelecao( @ aSM0, oLbx, @ lChk, oChkMar ), VerTodos( aSM0, @ lChk, oChkMar ) ) ;
Message "Inverter Sele็ใo" Of oDlg

// Marca/Desmarca por mascara
@ 101, 355 Say "Emp./Filial" Size  40, 08 Of oDlg Pixel
@ 100, 380 MSGet oMascEmp Var  cMascEmp When !lSoExibe Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Mแscara Empresa ( ?? )" Of oDlg
@ 100, 393 MSGet oMascFil Var  cMascFil When !lSoExibe Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascFil:Refresh(), .T. ) ;
Message "Mแscara Filial ( ?? )"  Of oDlg
@ 100, 413 Button oButMarc Prompt "Marcar"    When !lSoExibe Size 27, 10 Pixel Action ( MarcaMas( oLbx, aSM0, cMascEmp, cMascFil, .T. ), VerTodos( aSM0, @ lChk, oChkMar ) ) ;
Message "Marcar usando mแscara ( ?? )"    Of oDlg
@ 100, 440 Button oButDMar Prompt "Desmarcar" When !lSoExibe Size 27, 10 Pixel Action ( MarcaMas( oLbx, aSM0, cMascEmp, cMascFil, .F. ), VerTodos( aSM0, @ lChk, oChkMar ) ) ;
Message "Desmarcar usando mแscara ( ?? )" Of oDlg

If lSoExibe
	Activate MSDialog oDlg Centered On Init EnchoiceBar( oDlg, {|| lOpcA:=.T., IIf( oGet:TudoOk(), oDlg:End(), lOpcA := .F. )}, {||oDlg:End()} )
Else
	Activate MSDialog oDlg Centered On Init EnchoiceBar( oDlg, {|| lOpcA:=.T., IIf( oGet:TudoOk() .and. u_UA1Tudok().and. u_UA1Linok() .and. Obrigatorio( aGets, aTela ), oDlg:End(), lOpcA:=.F. )}, {||lOpcA:=.F., oDlg:End()}, , aButtons )
EndIf

Return lOpcA


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณEXISMSEXP บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validar   se existe MSEXP criado na tabela     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExisMSExp( cTabela )
Local aArea    := GetArea()
Local aAreaSX3 := SX3->( GetArea() )
Local cCpoMSEXP:= IIF( SubStr( cTabela, 1, 1 )=="S", SubStr( cTabela, 2, 2 ), cTabela )+"_MSEXP"
Local cMsg     := ""
Local lRet     := .T.

dbSelectArea( "SX3" )
dbSetOrder( 2 )

If !dbSeek( cCpoMSEXP )
	cMsg := STR0029 + cCpoMSEXP + CRLF //"Nใo existe o campo "
	cMsg += STR0030 + cTabela + CRLF   //"criado para a tabela "
	cMsg += STR0031 + CRLF             //"Para poder selecionar esta tabela "
	cMsg += STR0032                     //"este campo dever ser criado."
	lRet := .F.
	Help( "", 1, "", "UA1LinOk", cMsg, 1, 0 )
EndIf

RestArea( aAreaSX3 )
RestArea( aArea )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณVLDUA2ROT บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validar nomes das rotinas cadastradas no UA2   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VldUARot( cRot )
Local lRet := .T.
Local cLit := " !@#$%จ&*()+-=[]{}ด`^~<>, .;:/?\"
Local nX   := 0

cRot := ALLTRIM( cRot )

For nX := 1 To Len( cLit )
	If SubStr( cLit, nX, 1 ) $ cRot
		ApMsgStop( STR0033+SubStr( cLit, nX, 1 )+STR0034, STR0015 ) //"Caracter '"###"' invแlido."###"ATENวรO"
		lRet := .F.
		Exit
	EndIf
Next nX

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณEXISIMSEXPบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validar se existe indice MSEXP criado na tabelaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExisIMSExp( cTabela )
Local aArea    := GetArea()
Local aAreaSIX := SIX->( GetArea() )
Local cIndMSEXP:= cTabela+"MSEXP"
Local cCpoMSEXP:= IIF( SubStr( cTabela, 1, 1 )=="S", SubStr( cTabela, 2, 2 ), cTabela )+"_MSEXP"
Local cMsg     := ""
Local lAchou   := .F.
Local lRet     := .T.

dbSelectArea( "SIX" )
dbSetOrder( 1 )
dbSeek( cTabela )
While !SIX->( Eof() ) .and. cTabela == SIX->INDICE
	
	If cIndMSEXP $ SIX->NICKNAME
		lAchou   := .T.
		Exit
	EndIf
	
	dbSelectArea( "SIX" )
	SIX->( dbSkip() )
End

If !lAchou
	cMsg := STR0035 + cCpoMSEXP + CRLF  //"Nใo indice pelo campo "
	cMsg += STR0030 + cTabela   + CRLF  //"criado para a tabela "
	cMsg += STR0031 + CRLF              //"Para poder selecionar esta tabela "
	cMsg += STR0036 + CRLF              //"este dever ser criar este indice "
	cMsg += STR0037 + cIndMSEXP         //"com NickName "
	lRet := .F.
	Help( "", 1, "", "UA1LinOk", cMsg, 1, 0 )
EndIf

RestArea( aAreaSIX )
RestArea( aArea )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA1RENUM บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para renumeracao  da ordem de prioridade dos        บฑฑ
ฑฑบ          ณ pacotes                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA1Renum( cAlias, nRecno, nOpc )
Local aArea    := GetArea()
Local aAreaUA2 := UA2->( GetArea() )
Local cPacote  := M->UA1_PACOTE
Local nInterval:= 10
Local nX       := 0
Local nI       := 0
Local lRet     := .F.
Local oDlg     := NIL
Local aRepl    := {}
Local nTam     := TamSX3( "UA2_ORDEM" )[1]
Local nMaximo  := Val( Replicate( "9", nTam ) )
Local nPrx     := 0
Local lAtMax   := 0
Local cMsg     := ""
Local nPosOrd  := aScan( aHeader, {|x| Trim( x[2] )=="UA2_ORDEM"} )

dbSelectArea( "UA2" )
dbSetOrder( 1 )

Define MSDialog oDlg From    0, 0 To 145, 225 Title STR0040 Pixel Font oFontBold Of oMainWnd  //"Renumera็ใo de Ordem"
@   5, 5 To  47, 110 Label ""           Pixel Of oDlg
@  15, 10 Say STR0041     Size 70, 8  Pixel Of oDlg   //"Renumerar Pacote"
@  30, 10 Say STR0042     Size 70, 8  Pixel Of oDlg   //"Intervalo"
@  15, 80 MsGet cPacote   Size 25, 10  When .F. Valid  ( IIF( !dbSeek( xFilial( "UA2" ) + cPacote  ) .or. Empty( cPacote )  , ( ApMsgStop( STR0043, STR0015 ), .F. ) , .T. ) ) Pixel Of oDlg //"O Pacote nใo cadastrado"###"ATENวรO"
@  30, 80 MsGet nInterval Size 25, 10  Picture "999"  Valid ( nInterval > 0  ) Pixel Of oDlg

Define SButton From 55, 50 Type 2 Enable Action ( oDlg:End() ) Pixel Of oDlg
Define SButton From 55, 80 Type 1 Enable Action ( lRet := .T., oDlg:End() ) Pixel Of oDlg

Activate MSDialog oDlg Centered

If !lRet
	Return NIL
EndIf

// Renumerando
// Feito antes para verificar se nao estourou o tamanho
nPrx := Min( nInterval, nMaximo )

lAtMax := .F.
For nI := 1 To Len( aCols )
	If !aTail( aCols[nI] )
		aAdd ( aRepl, StrZero( nPrx, nTam ) )
		
		If Val( aRepl[nI] ) >= nMaximo
			lAtMax := .T.
		EndIf
		
		nPrx := Min( nPrx + nInterval, nMaximo )
	Else
		aAdd ( aRepl, aCols[nI][nPosOrd] )
	EndIf
Next

If !lAtMax
	// Gravando Nova Ordem
	aSort( aCols, , , {|x, y| x[3] < y[3] } )
	For nI := 1 To Len( aCols )
		If !aTail( aCols[nI] )
			aCols[nI][nPosOrd] := aRepl[nI]
		EndIf
	Next
Else
	cMsg := STR0044 + CRLF //"Com o intervalo escolhido, o tamanho mแximo da ORDEM"
	cMsg += STR0045 + CRLF //"serแ ultrapassado."
	cMsg += STR0046        //"Por favor escolha um intervalo menor."
	
	ApMsgStop( cMsg, STR0015 ) //"ATENวรO"
EndIf

RestArea( aAreaUA2 )
RestArea( aArea )
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UA2ORDEM บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para fazer numerecao de ordem no cadastro           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UA2Ordem( aCols )
Local nI      := 0
Local cRet    := Replicate( " ", TamSX3( "UA2_ORDEM" )[1] )
Local nPosOrd := aScan( aHeader, {|x| Trim( x[2] )=="UA2_ORDEM"} )

For nI := 1 To Len( aCols )
	If !aTail( aCols[nI] )
		cRet := IIF( cRet > aCols[nI][nPosOrd], cRet, aCols[nI][nPosOrd] )
	EndIf
Next
cRet := Soma1( cRet )

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCARREGASM0บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para montagem da ListBox                   บฑฑ
ฑฑบ          ณ Carrega o vetor                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CarregaSM0()
Local aArea    := GetArea()
Local aAreaSM0 := SM0->( GetArea() )
Local aRet     := {}

SM0->( dbGoTop() )
While !SM0->( Eof() )
	aAdd( aRet, { .F., SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	SM0->( dbSkip() )
End

RestArea( aAreaSM0 )
RestArea( aArea )
Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCASM0 บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para montagem da ListBox                   บฑฑ
ฑฑบ          ณ Marca o Vetor                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaSM0( aVetor, cPacote )
Local aRet     := aClone( aVetor )
Local aArea    := GetArea()
Local aAreaUA3 := UA3->( GetArea() )
Local nI       := 0
Local nPos     := 0

UA3->( dbSetOrder( 1 ) )
UA3->( dbSeek( xFilial( "UA3" ) + cPacote ) )

While !UA3->( Eof() ) .and. UA3->( UA3_FILIAL + UA3_PACOTE )  == xFilial( "UA3" ) + cPacote
	nPos := aScan( aVetor, { |x| x[2]+x[3] == UA3->( UA3_CODIGO + UA3_CODFIL ) } )
	If nPos > 0
		aRet[nPos][1] := .T.
	EndIf
	UA3->( dbSkip() )
End

RestArea( aAreaUA3 )
RestArea( aArea )
Return  aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCATODOSบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para marcar/desmarcar todos os itens do    บฑฑ
ฑฑบ          ณ ListBox ativo                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos( lMarca, aSM0, oLbx )
Local  nI := 0

For  nI := 1 To Len( aSM0 )
	aSM0[ nI][1] :=  lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณINVSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para inverter selecao do ListBox Ativo     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InvSelecao( aSM0, oLbx )
Local  nI := 0

For  nI := 1 To Len( aSM0 )
	aSM0[ nI][1] := ! aSM0[ nI][1]
Next  nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ MARCAMAS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para marcar/desmarcar usando mascaras               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaMas( oLbx, aSM0, cMascEmp, cMascFil, lMarDes )
Local  cPos1  := SubStr( cMascEmp, 1, 1 )
Local  cPos2  := SubStr( cMascEmp, 2, 1 )
Local  cPos3  := SubStr( cMascFil, 1, 1 )
Local  cPos4  := SubStr( cMascFil, 2, 1 )
Local  nPos   := oLbx:nAt
Local  nZ     := 0

For  nZ := 1 To Len( aSM0 )
	If   cPos1 == "?" .or. SubStr( aSM0[ nZ][2], 1, 1 ) ==  cPos1
		If  cPos2 == "?" .or. SubStr( aSM0[ nZ][2], 2, 1 ) ==  cPos2
			If   cPos3 == "?" .or. SubStr( aSM0[ nZ][3], 1, 1 ) ==  cPos3
				If  cPos4 == "?" .or. SubStr( aSM0[ nZ][3], 2, 1 ) ==  cPos4
					aSM0[ nZ][1] :=  lMarDes
				EndIf
			EndIf
		EndIf
	EndIf
Next

oLbx:nAt :=  nPos
oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ VERTODOS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para verificar se estao todos marcardos    บฑฑ
ฑฑบ          ณ ou nao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerTodos( aSM0, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For  nI := 1 To Len( aSM0 )
	lTTrue  := IIf( ! aSM0[ nI][1], .F., lTTrue )
Next  nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//////////////////////////////////////////////////////////////////////////////