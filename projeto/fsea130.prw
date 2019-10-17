#INCLUDE 'FSEA130.CH'
#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA130  บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de limpeza de flags de exportacao manualmente       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FSEA130()
Local _aSay      := {}
Local _aButton   := {}
Local _nOpc      := 0
Local _cTitulo   := STR0001 //'LIMPEZA DE FLAG DE EXPORTAวรO'
Local _cDesc1    := STR0002 //'Esta rotina tem como fun็ใo fazer a limpeza dos flags de exporta็ใo das tabela dos'
Local _cDesc2    := STR0003 //'pacotes, conforme sele็ใo feita.'
Local _cDesc3    := ''
Local _cDesc4    := ''
Local _cDesc5    := ''
Local _cDesc6    := ''
Local _cDesc7    := ''
Local _oDlg, _oLbxArq, _oButPrx, _oButDMar, _oButMarc, _oDataDe, _oDataAte
Local _oGrp1, _oGrp2, _oGrp3, _oGrp4, _oGrp5, _oCheck, _oGetArq, _oPesq, _oMasc
Local _oOk       := LoadBitMap( GetResources(), 'LBOK' )
Local _oNo       := LoadBitMap( GetResources(), 'LBNO' )
Local _oAtivo    := LoadBitmap( GetResources(), 'BR_VERDE' )
Local _oInat     := LoadBitmap( GetResources(), 'BR_VERMELHO' )
Local _cPesq     := Space( 20 )
Local _cMasc     := '???'
Local _nPosArq   := 1
Local _lOk       := .F.

//Private cPerg     := ''
Private _oTabMarc
Private _cTabMarc := ''
Private _aTabelas := {}
Private _lIncAlt  := .T.
Private _lExclu   := .T.
Private _dDataDe  := Date()-1
Private _dDataAte := Date()-1

// Mensagens de Tela Inicial
aAdd( _aSay, _cDesc1 )
aAdd( _aSay, _cDesc2 )
aAdd( _aSay, _cDesc3 )
aAdd( _aSay, _cDesc4 )
aAdd( _aSay, _cDesc5 )
aAdd( _aSay, _cDesc6 )
aAdd( _aSay, _cDesc7 )

// Botoes Tela Inicial
aAdd( _aButton, {  1, .T., {|| _nOpc := 1, FechaBatch()  }} )
aAdd( _aButton, {  2, .T., {|| FechaBatch()              }} )

FormBatch( _cTitulo, _aSay, _aButton )
	
If _nOpc <> 1
	Return NIL
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta array com os dados do UA2                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea( 'UA1' )
dbSetOrder( 1 )
dbGoTop()

dbSelectArea( 'UA2' )
dbSetOrder( 1 )
dbGoTop()

While !UA2->( EOF() )
	UA1->( dbSeek( xFilial( 'UA1' )+UA2->UA2_PACOTE ) )
	aAdd( _aTabelas, {.F., ( UA1->UA1_STATUS=='1' ), UA2->UA2_PACOTE, UA2->UA2_TABELA, Capital( u_InfoSX2( UA2->UA2_TABELA, 3 ) )} )
	UA2->( dbSkip() )
End


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Tela de Dialogo                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define Font _oFontBold Name 'Arial' Size 0, -13 Bold
Define Font _oFontNor  Name 'Arial' Size 0, -11
Define Font _oFontNorB Name 'Arial' Size 0, -11 Bold

Define MSDialog _oDlg From   89, 98 To 477, 860 Title STR0001 Pixel Of oMainWnd //'Limpeza de Flag de Exporta็ใo'

// ListBox Dos Arquivos
@   5,  2 Group _oGrp1 To 147, 262 Label ' Selecione as Tabelas ' Of _oDlg Pixel
_oGrp1:oFont := _oFontNorB
@  15,  7 ListBox _oLbxArq Fields Header '', '', 'Pacote', 'Tabela', 'Descri็ใo' Size 250, 127 Of _oDlg Pixel;
On DblClick ( _aTabelas[_oLbxArq:nAt, 1] := !_aTabelas[_oLbxArq:nAt, 1], _oLbxArq:Refresh(), TabMarc( @_cTabMarc, _oLbxArq:nAt, _aTabelas[_oLbxArq:nAt, 1] ), _oDlg:Refresh() )
_oLbxArq:SetArray( _aTabelas )

_oLbxArq:bLine    := { || {IIf( _aTabelas[_oLbxArq:nAt, 1], _oOk, _oNo ), ;
IIf( _aTabelas[_oLbxArq:nAt, 2], _oAtivo, _oInat ), ;
_aTabelas[_oLbxArq:nAt, 3], ;
_aTabelas[_oLbxArq:nAt, 4], ;
_aTabelas[_oLbxArq:nAt, 5] }}  // Campos do LIST

_oLbxArq:lHScroll := .F.
_oLbxArq:cToolTip := 'Tabelas que constam dos pacotes'
_oLbxArq:nAt      := _nPosArq
_oLbxArq:Refresh()


// Parametros
@   5, 265 Group _oGrp2 To  85, 375 Label ' Parโmetros ' Of _oDlg Pixel
_oGrp2:oFont := _oFontNorB
@  17, 270 Say   'De'  Size 65, 10 Of _oDlg Pixel
@  32, 270 Say   'At้' Size 65, 10 Of _oDlg Pixel
@  15, 285 MSGet _oDataDe  Var _dDataDe  Size  50, 10 Pixel Picture '@!' Valid !Empty( _dDataDe ) Message 'Data Inicial' Of _oDlg
@  30, 285 MSGet _oDataAte Var _dDataAte Size  50, 10 Pixel Picture '@!' Valid !Empty( _dDataAte ) Message 'Data Final'   Of _oDlg


// Check Ref. Inclusoes/Alteracoes
@  55, 270 CheckBox _oCheck Var _lIncAlt Size  90, 010 Of _oDlg Pixel ;
Prompt 'Inclus๕es/Altera็๕es' Message 'Executa limpeza para inclusใes/altera็๕es' Design


// Check Ref. Exclusoes
@  70, 270 CheckBox _oCheck Var _lExclu  Size  90, 010 Of _oDlg Pixel ;
Prompt 'Exclus๕es'            Message 'Executa limpeza para exclus๕es' Design


// Marca/Desmarca por mascara
@  90, 265 Group _oGrp5 To  115, 375 Label ' Marcar / Desmarcar por mแscara ' Of _oDlg Pixel
_oGrp5:oFont := _oFontNorB
@  98, 269 MSGet _oMasc  Var _cMasc  Size  30, 10 Pixel Picture '@!'  Valid ( _cMasc := StrTran( _cMasc, ' ', '?' ), _oMasc:Refresh(), .T. ) Message 'Mแscara ( ??? )' Of _oDlg
@  98, 300 Button _oButMarc Prompt '&Marcar'    Size 36, 12 Pixel Action MarcaMas( _oLbxArq, _aTabelas, _cMasc, .T. ) Message 'Marcar usando mแscara ( ??? )'    Of _oDlg
@  98, 335 Button _oButDMar Prompt '&Desmarcar' Size 36, 12 Pixel Action MarcaMas( _oLbxArq, _aTabelas, _cMasc, .F. ) Message 'Desmarcar usando mแscara ( ??? )' Of _oDlg


// Pesquisa de Tabela
@ 122, 265 Group _oGrp4 To  147, 375 Label ' Pesquisar Tabela ' Of _oDlg Pixel
_oGrp4:oFont := _oFontNorB
@ 130, 269 MSGet _oPesq  Var _cPesq  Size 90, 10 Message 'Chave de Pesquisa' Of _oDlg Pixel Picture '@!';
Valid ( _nPosArq := IIf( !Empty( _cPesq ), aScan( _aTabelas, {|z| AllTrim( Upper( _cPesq ) ) $ Upper( z[3]+z[4] ) } ), _oLbxArq:nAt ), IIf( _nPosArq <> 0, _oLbxArq:nAt := _nPosArq, ApMsgStop( 'Nใo encontrado.' ) ), _oLbxArq:Refresh(), ( _nPosArq <> 0 ) )
@ 130, 360 Button _oButPrx Prompt '>>' Size 12, 12 Pixel Action PesqPrx( _oLbxArq, _cPesq, _oLbxArq:nAt ) Message 'Pesquisa Pr๓ximo' Of _oDlg


// Memo com tabelas Marcadas
@ 152,   2 Group _oGrp6 To  187, 262 Label ' Tabelas Marcadas ' Of _oDlg Pixel
_oGrp6:oFont := _oFontNorB
@ 159,   6 Get _oTabMarc Var _cTabMarc Memo NoBorder Size 250, 25 Pixel Of _oDlg ReadOnly
//_oTabMarc:bRClicked := {||AlwaysTrue()}
_oTabMarc:cToolTip  := 'Tabelas que estใo marcadas'

Define SButton From 162, 315 Type 1 Enable Of _oDlg Action ( _lOk := .T., Desmarc(), _lOk := .F. ) When !Empty( _dDataDe ) .AND. !Empty( _dDataAte )
Define SButton From 162, 345 Type 2 Enable Of _oDlg Action ( _lOk := .F., _oDlg:End() )

Activate MSDialog _oDlg Centered

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Desmarc  บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Processamento da operacao                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Desmarc()
Private _oProcess := NIL
_oProcess := MsNewProcess():New( {|lEnd| AuxDesmarc( @lEnd, _oProcess )}, 'Exportando', 'Lendo...', .F. )
_oProcess:Activate()
Return NIL

Static Function AuxDesmarc( lEnd, _oProcess )
Local _aArea      := GetArea()
Local _aAreaTab   := {}
Local _aTabs      := {}
Local _nI         := 0
Local _cTabela    := ''
Local _cCpoFILIAL := ''
Local _cCpoMSEXP  := ''
Local _lAbriu     := .F.
Local _lInatMarc  := .F.
Local _aStru      := {}

// Verificacoes
For _nI := 1 To Len( _aTabelas )
	If _aTabelas[_nI][1] .AND. aScan( _aTabs, _aTabelas[_nI][4] ) == 0
		aAdd( _aTabs , _aTabelas[_nI][4] )
		If !_aTabelas[_nI][2]
			_lInatMarc  := .T.
		EndIf
	EndIf
Next

If Len( _aTabs ) == 0
	ApMsgStop( STR0004, STR0005 ) //'Nใo foi selecionada nenhuma Tabela.'###'ATENวรO'
	Return NIL
EndIf

If _lInatMarc
	If !ApMsgNoYes( STR0006+CRLF+; //'CUIDADO! Foram selecionadas tabelas de pacotes INATIVOS'
		STR0007, STR0005 ) //'Deseja continuar assim mesmo ?'###'ATENวรO'
		Return NIL
	EndIf
EndIf


If Empty( _dDataDe )
	ApMsgStop( STR0008, STR0005 ) //'Data Inicial Invแlida.'###'ATENวรO'
	Return NIL
EndIf

If Empty( _dDataAte )
	ApMsgStop( STR0009, STR0005 ) //'Data Final Invแlida.'###'ATENวรO'
	Return NIL
EndIf

If _dDataDe > _dDataAte
	ApMsgStop( STR0010, STR0005 ) //'Data Inicial maior que Data Final.'###'ATENวรO'
	Return NIL
EndIf


_oProcess:SetRegua1( Len( _aTabs ) )

For _nI := 1 To Len( _aTabs )
	_cTabela    := _aTabs[_nI]
	_cCpoFILIAL := IIf( SubStr( _cTabela, 1, 1 )=='S', SubStr( _cTabela, 2, 2 ), _cTabela )+'_FILIAL'
	_cCpoMSEXP  := IIf( SubStr( _cTabela, 1, 1 )=='S', SubStr( _cTabela, 2, 2 ), _cTabela )+'_MSEXP'
	_lAbriu     := .F.
	
	_oProcess:IncRegua1( STR0011+_aTabs[_nI]+' ...' ) //'Processando Tabela '
	
	If Select( _cTabela ) <= 0
		ChkFile( _cTabela )
		_lAbriu := .T.
	EndIf
	
	_aAreaTab := (_cTabela)->( GetArea() )
	
	If _lExclu
		/////////////////////
		Set Deleted OFF    // Esta variavel de ambiente eh mudada para permitir tratar os registros deletados
		/////////////////////
	EndIf
	
	(_cTabela)->( dbSetOrder( 0 ) )
	(_cTabela)->( dbGoTop() )
	_oProcess:SetRegua2( (_cTabela)->( RecCount() ) )
	_aStru    := (_cTabela)->( dbStruct() )
	
	If  aScan( _aStru, {|x| Trim( x[1] )== Trim( _cCpoMSEXP ) } ) > 0
		While !(_cTabela)->( Eof() )
			_oProcess:IncRegua2( STR0012 ) //'Limpando ...'
			
			If ( _lExclu .AND. (_cTabela)->( Deleted() ) ) .OR. ( _lIncAlt .AND. !(_cTabela)->( Deleted() ) )
				If SToD( (_cTabela)->( &( _cCpoMSEXP ) ) ) >= _dDataDe .AND. SToD( (_cTabela)->( &( _cCpoMSEXP ) ) ) <= _dDataAte
					RecLock( _cTabela, .F. )
					(_cTabela)->( &( _cCpoMSEXP ) ) := ''
					MsUnLock()
				EndIf
			EndIf
			
			(_cTabela)->( dbSkip() )
		End
	EndIf
	
	If _lExclu
		/////////////////////
		Set Deleted ON     // Esta variavel de ambiente eh mudada para permitir tratar os registros deletados
		/////////////////////
	EndIf
	
	RestArea( _aAreaTab )
	
	If _lAbriu
		(_cTabela)->( dbCloseArea() )
	EndIf
	
Next

ApMsgInfo( STR0013, STR0005 ) //'Processo Terminado.'###'ATENวรO'

RestArea( _aArea )
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PESQPRX  บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Escolha do diretorio para gravacao                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PesqPrx( _oLbxArq, _cPesq, _nPosArq )

IF !Empty( _cPesq )
	_nPosArq := aScan( _aTabelas, {|z| Upper( AllTrim( _cPesq ) ) $ Upper( z[4]+z[5] )}, _nPosArq+1 )
EndIf

IF _nPosArq <> 0
	_oLbxArq:nAt := _nPosArq
Else
	ApMsgStop( STR0014 ) //'Nใo encontrado.'
EndIf

_oLbxArq:Refresh()

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
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaMas( _oLbxArq, _aTabelas, _cMasc, _lMarDes )
Local _cPos1  := SubStr( _cMasc, 1, 1 )
Local _cPos2  := SubStr( _cMasc, 2, 1 )
Local _cPos3  := SubStr( _cMasc, 3, 1 )
Local _nPos   :=_oLbxArq:nAt
Local _nZ     := 0

If _cMasc == '???'
	_cTabMarc := ''
EndIf

For _nZ := 1 To Len( _aTabelas )
	If  _cPos1 == '?' .OR. SubStr( _aTabelas[_nZ][4], 1, 1 ) == _cPos1
		If _cPos2 == '?' .OR. SubStr( _aTabelas[_nZ][4], 2, 1 ) == _cPos2
			If _cPos3 == '?' .OR. SubStr( _aTabelas[_nZ][4], 3, 1 ) == _cPos3
				_aTabelas[_nZ][1] := _lMarDes
				If _cMasc == '???'
					If _lMarDes
						_cTabMarc += _aTabelas[_nZ][4]+' '
					EndIf
				Else
					TabMarc( @_cTabMarc, _nZ, _lMarDes )
				EndIf
			EndIf
		EndIf
	EndIf
Next

_oLbxArq:nAt := _nPos
_oLbxArq:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ TABMARC  บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Monta memo na tela com as tabelas marcadas                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TabMarc( _cTabMarc, _nPos, _lMarc )
If _lMarc
	If !( _aTabelas[_nPos][4] $ _cTabMarc )
		_cTabMarc += _aTabelas[_nPos][4]+' '
	EndIf
Else
	_cTabMarc := StrTran( _cTabMarc, _aTabelas[_nPos][4]+' ', '' )
EndIf

_oTabMarc:Refresh()
Return NIL


/////////////////////////////////////////////////////////////////////////////