#INCLUDE 'FSEA060.CH'
#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FSEA060  �Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para limpeza do flag de exportacao para os arquivos ���
���          � devolvidos                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FSEA060()
Private cCadastro := STR0001                    //'Processamento dos Arquivos de Devolu��o'
Private aCores    := {}
Private cDelFunc  := '.T.'
Private aRotina   := {}
Private lUsaFTP   := GetMV( 'FS_USAFTP' ,, .T. )
Private cProcTod  := GetMv( 'FS_PRTDDEV',, 'S' )
Private cDirFTPMov:= IIf( lUsaFTP, GetMV( 'FS_DRFTPMV',, '' ), GetMV( 'FS_DRREDMV',, '\sincron\movto\' ) ) // Diretorio Movimento FTP
Private cDirLocTmp:= GetMV( 'FS_DRLOCMV',, '\sincron\temp\' ) // Diretorio Movimento Local
//Private cDirLocMov:= GetMV( 'FS_DRLOCMV',, '' )

aAdd( aRotina, {STR0002 , 'AxPesqui'   , 0, 1} ) //'Pesquisar'
aAdd( aRotina, {STR0003 , 'AxVisual'   , 0, 2} ) //'Visualizar'
aAdd( aRotina, {STR0004 , 'u_UA5LinFlg', 0, 4} ) //'Reverter'

dbSelectArea( 'UA8' )
dbGoTop()

While !Eof()
	aAdd( aCores, { "UA5_STATUS == '' + UA8->UA8_STATUS + ''", AllTrim( UA8->UA8_COR ), UA8->UA8_Desc } )
	dbSkip()
End

dbSelectArea( 'UA5' )
cFiltUA5 := "UA5->UA5_ORIGEM == '" + SM0->M0_CODIGO + SM0->M0_CODFIL + "' .AND. UA5->UA5_STATUS == '10'"
bFiltUA5 := &( '{|| ' + AllTrim( cFiltUA5 ) + ' }' )
dbSetFilter( bFiltUA5, cFiltUA5 )
dbGoTop()

dbSelectArea( 'UA5' )
dbSetOrder( 1 )
mBrowse( ,,,, 'UA5',,,, 'UA5_STATUS',, aCores,,, 4 )

dbSelectArea( 'UA5' )
dbClearFilter()
dbGoTop()

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � UA5LINFLG�Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para limpeza do flag de exportacao para os arquivos ���
���          � devolvidos                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UA5LinFlg()
Processa( {|lEnd| RunProc( @lEnd )}, STR0005, STR0006 + UA5->UA5_ARQUIV, .T. ) //'Aguarde...'###'Processando '
Return NIL

Static Function RunProc( lEnd )
Local cControle  := UA5->UA5_ARQUIV + '.DEV'
Local cTabela    := UA5->UA5_TABELA
Local cGrupo     := UA5->( UA5_PACOTE + UA5_ORIGEM + UA5_TABELA + UA5_REF )
Local cArqDev    := ''
Local cChave     := ''
Local cBuffer    := ''
Local cArqAux    := ''
Local cExtensao  := '.DDV'
Local cCpoFILIAL := IIf( SubStr( cTabela, 1, 1 ) == 'S', SubStr( cTabela, 2, 2 ), cTabela ) + '_FILIAL'
Local cCpoMSEXP  := IIf( SubStr( cTabela, 1, 1 ) == 'S', SubStr( cTabela, 2, 2 ), cTabela ) + '_MSEXP'
Local cDirLoc    := cDirLocTmp         // u_EmpFilDir( 'L' ) // Diretorio Local
Local cDirFTP    := u_EmpFilDir( 'F' ) // Diretorio FTP
Local nI         := 0
Local nOrdem     := 1
Local aStru      := {}
Local lAbriu     := .T.
Local dDataRef   := CToD( '  /  /  ' )
Local cTimeRef   := ''
Local lErroAbert := .F.
Local bBlockErro := ErrorBlock( { |oErroArq| ChkErrAber( oErroArq ) } )

If !ApMsgNoYes( STR0007 + Chr(13) + UA5->UA5_ARQUIV + ' ?' ) //'Processar o Arquivo de Devolu��o'
	Return NIL
EndIf

/////////////////////////////////////////////////////////////////////////////
// Baixando arquivos do FTP
/////////////////////////////////////////////////////////////////////////////

// Conexao FTP
If !u_ConexFTP()
	ApMsgStop( STR0008, STR0009 ) //'N�o foi poss�vel conectar ao FTP para baixar arquivos.'###'ATEN��O'
	Return NIL
EndIf

// Baixando Arquivo de devolucao do FTP
If !u_DwLoadFTP( cDirLoc + cControle, cDirFTP + cControle )
	ApMsgStop( STR0010 + Chr(13) + cDirFTP + cControle, STR0009 ) //'N�o foi poss�vel fazer download arquivo '###'ATEN��O'
	Return NIL
EndIf

// Pega Nome dos arquivo a processar contidos no Controle
FT_FUse( cDirLoc + cControle )
FT_FGoTop()

cBuffer := FT_FREADLN()
cArqDev := AllTrim( cBuffer ) // Esta na 1a. Linha
FT_FUse()

// Baixando Arquivo de dados de devolucao do FTP
If !u_DwLoadFTP( cDirLoc + cArqDev + cExtensao, cDirFTPMov + cArqDev + cExtensao )
	ApMsgStop( STR0010 + Chr(13) + cDirLoc + cArqDev + cExtensao, STR0009 ) //'N�o foi poss�vel fazer download arquivo '###'ATEN��O'
	Return NIL
EndIf

u_DesConx()


/////////////////////////////////////////////////////////////////////////////
// Processando os arquivos
/////////////////////////////////////////////////////////////////////////////

// Tabela de excecao de chave unica
dbSelectArea( 'UA7' )
If dbSeek( xFilial( 'UA7' ) + cTabela )
	nOrdem := UA7->UA7_ORDEM
EndIf

// Inicializo a Tabela
If Select( cTabela ) <=0
	ChkFile( cTabela )
	lAbriu := .T.
EndIf

dbSelectArea( cTabela )
dbSetOrder( nOrdem )
aStru  := ( cTabela )->( dbStruct() )
cChave := ( cTabela )->( IndexKey() )
cChave := StrTran( cChave, ' ', '' )
//cChave := StrTran( cChave, cCpoFILIAL + ' + ', '' )

// Verifica se existe flag
If	aScan( aStru, {|x| Trim( x[1] )== cCpoMSEXP } ) <= 0
	ApMsgStop( STR0011 + cCpoMSEXP + Chr(13) + STR0012, STR0009 ) //'N�o esta criado o campo'###'n�o � poss�vel continuar.'###'ATEN��O'
	Return NIL
EndIf

// Convert o arquivo texto em arquivo conforme o RDD
If !ConvTXT( cDirLoc + cArqDev + '.DDV')
	u_MsgConMon( STR0017 + cDirLoc + cArqDev + ' para ' + GetDbExtension() ) //'Nao foi possivel converter arquivo texto '
	Return NIL
EndIf

// Arquivo de Devolucao
Begin Sequence
dbUseArea( .T.,, cDirLoc + cArqDev , 'TRAB', .T., .F. )
Recover
lErroAbert := .T.
End Sequence
ErrorBlock( bBlockErro )

If 	lErroAbert
	ApMsgStop( STR0015 + cArqDev, STR0009 ) //'Problemas na abertura do arquivo de devolucao '
	Return NIL
EndIf

dbSelectArea( 'TRAB' )
dbGoTop()

Begin Transaction
dbSelectArea( 'TRAB' )
ProcRegua( TRAB->( LastRec() ) )

While !TRAB->( Eof() ) .AND. !KillApp()
	IncProc()
	
	dbSelectArea( cTabela )
	
	//	If dbSeek( TRAB->( xFilial( cTabela ) + ( &( cChave ) ) ) )
	If dbSeek( TRAB->( &( cChave ) ) )
		RecLock( cTabela, .F. )
		( cTabela )->( &( cCpoMSEXP ) ) := ''  // Para poder exportar de volta
		MsUnlock()
	EndIf
	
	dbSelectArea( 'TRAB' )
	TRAB->( dbSkip() )
End

End Transaction

dbSelectArea( 'TRAB' )
dbCloseArea()

If 	lAbriu
	dbSelectArea( cTabela )
	dbCloseArea()
EndIf


/////////////////////////////////////////////////////////////////////////////
// Atualizando arquivos no FTP
/////////////////////////////////////////////////////////////////////////////

// Conexao FTP
If !u_ConexFTP()
	ApMsgStop( STR0013, STR0009 ) //'N�o foi poss�vel conectar ao FTP para atualizar arquivos.'###'ATEN��O'
	Return NIL
EndIf

cArqAux := StrTran( cControle, '.DEV', '.ROL' )

If !u_UpLoadFTP( cDirLoc + cControle, cDirFTP + cArqAux )
	ApMsgStop( STR0014 + Chr(13) + cDirFTP + cArqAux, STR0009 ) //'N�o foi poss�vel fazer upload arquivo '###'ATEN��O'
	Return NIL
EndIf

dbSelectArea( 'UA5' )
// Esta movimentacao com Recno � Feita apenas para
// nao desposicionar o mBrowse na tela
nRecAtu  := UA5->( Recno() )
dDataRef := Date()
cTimeRef := SubStr( Time(), 1, 5 )

dbSkip( 1 )
nRecPrx := UA5->( Recno() )
dbGoTo( nRecAtu )

Begin Transaction
RecLock( 'UA5', .F. )
UA5->UA5_STATUS := '20'
UA5->UA5_DTROL  := dDataRef
UA5->UA5_HRROL  := cTimeRef
MsUnLock()
End Transaction

// Tratando o mesmo arquivo delvolvido vindo de outras filiais
If cProcTod == 'S'
	dbSelectArea( 'UA5' )
	dbSetOrder( 3 )
	dbSeek( xFilial( 'UA5' ) + cGrupo )
	ProcRegua( UA5->( LastRec() ) )
	
	While !Eof() .AND. cGrupo  == UA5->( UA5_PACOTE + UA5_ORIGEM + UA5_TABELA + UA5_REF )
		
		If 	UA5->UA5_STATUS == '10'
			IncProc( STR0006 + UA5->UA5_ARQUIV )  //'Processando '
			
			cArqAux  := UA5->UA5_ARQUIV + '.DEV'
			cArqAux2 := StrTran( cArqAux, '.DEV', '.ROL' )
			
			// Baixando Arquivo de devolucao do FTP e Subindo com outra extensao
			If u_DwLoadFTP( cDirLoc + cArqAux, cDirFTP + cArqAux )
				If u_UpLoadFTP( cDirLoc + cArqAux, cDirFTP + cArqAux2 )
					
					Begin Transaction
					RecLock( 'UA5', .F. )
					UA5->UA5_STATUS := '20'
					UA5->UA5_DTROL  := dDataRef
					UA5->UA5_HRROL  := cTimeRef
					MsUnLock()
					End Transaction
					
				Else
					ApMsgStop( STR0014 + Chr(13) + cDirFTP + cArqAux, STR0009 ) //'N�o foi poss�vel fazer upload arquivo '###'ATEN��O'
				EndIf
			Else
				ApMsgStop( STR0010 + Chr(13) + cDirFTP + cArqAux, STR0009 ) //'N�o foi poss�vel fazer download arquivo '###'ATEN��O'
			EndIf
		EndIf
		
		dbSelectArea( 'UA5' )
		dbSkip()
	End
EndIf

dbSelectArea( 'UA5' )
dbSetOrder( 1 )
dbGoTo( nRecPrx )

u_DesConx()

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �CHKERRABER�Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Tratamento de erro na abertura                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ChkErrAber( oErroArq )
If oErroArq:GenCode > 0
	u_MsgConMon( STR0016 + Alltrim( Str( oErroArq:GenCode ) ) + ' ) : ' + AllTrim( oErroArq:Description ) ) //'Erro abertura de arquivo de movimento - Codigo Erro ( '
EndIf
Break
Return NIL

/////////////////////////////////////////////////////////////////////////////