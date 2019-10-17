#INCLUDE 'FSEA021.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA021  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para start exportacao de cada tabela dos Pacotes    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FSEA021( cPacote, cTabela, cEmpresa, cFil, lManual, dDataRef, cHoraRef, lUsaFTP )
Local lEhCentra := .F.
Local lElaMesma := .T.
Local lSubirFTP := .F.
Local lSubiuTod := .F.
Local lIntegro  := .T.
Local lChkInteg := .F.
//Local aFiles    := { 'UA2', cTabela }
Local aArq      := {.F. , '', ''}
Local nHdl      := -1
Local nI        := 0
//Local nRecnoSM0 := 0
Local nTenta    := 10
Local cArqCtrl  := ''
Local cTabEmp   := ''
Local cModo     := ''
Local cCentra   := ''
Local cDirFTP   := ''
Local cDirLocal := ''
Local cDirFTPMov:= ''
Local cDirLocTmp:= ''
Local cDirLocInt:= ''
Local cExtensao := Upper( GetDbExtension() )
Local cExtExport:= '.EOK'
Local aArqToUp  := {}
Local aLimpar   := ''

lManual   := IIf( lManual  == NIL, .T., lManual )
cEmpresa  := IIf( cEmpresa == NIL .OR.  lManual, SM0->M0_CODIGO, cEmpresa )
cFil      := IIf( cFil     == NIL .OR.  lManual, SM0->M0_CODIGO, cFil    )

u_MsgConMon( STR0001 + cPacote + STR0002 + cTabela, .F. ) //'Iniciando   Exportacao Pacote '###' Tabela '

// Abrindo o semaforo para trava
nHdl := MSFCreate( 'PC' + cPacote + cTabela + '.LCK' )

If nHdl < 0
	u_MsgConMon( STR0003 + cPacote + ' ' + cTabela ) //'Pacote/Tabela ja esta sendo exportado por outra thread '
	Return NIL
EndIf

// Linha Alterada para Processar Sequencial
//
// Prepara ambiente se for JOB
//If !lManual
//	RpcSetType( 3 )
//	RpcSetEnv( cEmpresa, cFil,,,,, aFiles )
//EndIf


// Inicializando Variaveis
lUsaFTP    := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP',, .T. ), lUsaFTP )
cCentra    := GetMV( 'FS_CENTRA' ,, '' )
nTenta     := GetMV( 'FS_NUMTENT',, 10 )
lChkInteg  := GetMV( 'FS_CHKINTE',, .F. )
cDirFTPMov := IIf( lUsaFTP, GetMV( 'FS_DRFTPMV',, '' ), GetMV( 'FS_DRREDMV',, '\sincron\movto\' ) )
cDirLocTmp := GetMV( 'FS_DRLOCMV',, '\sincron\temp\' )

If !File( cDirLocTmp )
	u_MyMakeDir( cDirLocTmp )
EndIf

If !lUsaFTP .and. !File( cDirFTPMov )
	If ! ( '\\' $ cDirFTPMov )
		u_MyMakeDir( cDirFTPMov )
	EndIf
EndIf

// Vai checar Integridade no Upload em FTP
If lUsaFTP .AND. lChkInteg
	cDirLocInt := GetMV( 'FS_DRLOCIN',, '\sincron\check\' )
	u_MyMakeDir( cDirLocInt )
EndIf

cTabEmp    := u_InfoSX2( cTabela, 2 )
cModo      := u_InfoSX2( cTabela, 4 )
lEhCentra  := ( ( cEmpresa + cFil )$cCentra )

// Empresa centralizadora ( Matriz ) nao pode exportar tabelas exclusivas
//If lEhCentra .AND. cModo == 'E'
//	FClose( nHdl )
//	FErase( 'PC' + cPacote + cTabela + '.LCK' )
//	u_MsgConMon( STR0004 + cPacote + ' ' + cTabela ) //'Empresa centralizadora nao pode exportar tabelas exclusivas '
// Linha Alterada para Processar Sequencial
// RpcClearEnv()
//	Return NIL
//EndIf

// Verificando se o arquivo eh compartilhado entre empresas
//dbSelectArea( 'SM0' )
//dbSetOrder( 1 )
//nRecnoSM0 := SM0->( Recno() )  // Pro caso de estar sendo rodado manualmente
//dbGoTop()

// Estrutura aArq
// [1] Gravou arquivo com movimento .T./.F.
// [2] Nome do arquivo de movimento ou arquivo temporario ref. inclusoes/alteracoes
// [3] Nome do arquivo de movimento ou arquivo temporario ref. exclusoes
// [4] Indicativo se houve problemas ao renomear arquivo temporario para movimento ( verificar nome extenso de diretorio )
// Faz a preparacao ( copia ) dos registros
aArq := Copiar( cPacote, cTabela, cEmpresa, cFil, cDirLocTmp, cExtensao )

If aArq[1]  // Gravou Arquivo
	If aArq[4]  // Nao houve problemas ao renomear arquivo
		lSubiuTod := .F.
		lIntegro  := .T.
		
		For nI := 1 To 3
			// Subindo Arquivos de Movimentacao para FTP
			u_MsgConMon( STR0005 + cPacote + ' ' + cTabela, .F. ) //'Fazendo UpLoad '
			
			If u_UpLoadFTP( cDirLocTmp + aArq[2] + '.TXT', cDirFTPMov + aArq[2] + '.TXT', nTenta, lUsaFTP )
				If u_UpLoadFTP( cDirLocTmp + aArq[3] + '.TXT', cDirFTPMov + aArq[3] + '.TXT', nTenta, lUsaFTP )
					lSubiuTod := .T.
					Exit
				Else
					u_MsgConMon( STR0006 + cDirLocTmp + aArq[2] + cExtensao )  //'Nao foi possivel fazer upload arquivo '
				EndIf
			Else
				u_MsgConMon( STR0006 + cDirLocTmp + aArq[3] + cExtensao ) //'Nao foi possivel fazer upload arquivo '
			EndIf
		Next
		
		
		If	lSubiuTod
			If lChkInteg
				lIntegro := ChkInteg( aArq, cDirLocInt, cDirFTPMov, cExtensao, nTenta )
			EndIf
		EndIf
		
		
		If	lSubiuTod .AND. ( ( lChkInteg .AND. lIntegro ) .OR. !lChkInteg )
			// Exportando para os destinos
			
			UA3->( dbSeek( xFilial( 'UA3' ) + cPacote ) )
			
			While !UA3->( Eof() ) .AND. UA3->( UA3_FILIAL + UA3_PACOTE  ) == xFilial( 'UA3' ) + cPacote .AND. !KillApp()
				lElaMesma   := ( UA3->( UA3_CODIGO + UA3_CODFIL ) == ( cEmpresa + cFil ) )
				lEhCentDest := ( UA3->( UA3_CODIGO + UA3_CODFIL ) $ cCentra )
				cEmpDest    := UA3->UA3_CODIGO
				cFilDest    := UA3->UA3_CODFIL
				cArqCtrl    := cPacote + cEmpresa + cFil + cEmpDest + cFilDest + cTabela + DToS( dDataRef ) + StrTran( cHoraRef, ':', '' )
				cDirFTP     := u_EmpFilDir( 'F', cEmpDest, cFilDest )	 // Diretorio de FTP ou Rede
				//				cDirLocal   := u_EmpFilDir( 'L', cEmpDest, cFilDest )   // Diretorio Local
				cDirLocal   := cDirLocTmp
				aArqToUp    := {}
				lSubirFTP   := .T.
				
				// Cria Diretorio de Trabalho, se necessario
				If !File( cDirLocal )
					u_MyMakeDir( cDirLocal )
				EndIf
				
				If lElaMesma
					lSubirFTP := .F.
				EndIf
				
				If lSubirFTP
					//Criando Arquivo Controle
					nHdl := MSFCreate( cDirLocal + cArqCtrl + cExtExport )
					fWrite( nHdl, aArq[2] + CRLF, 20 )
					fWrite( nHdl, aArq[3] + CRLF, 20 )
					//			fWrite( nHdl, DToC( Date() ) + CRLF, 20 )
					// 			fWrite( nHdl, Time()      + CRLF, 20 )
					fClose( nHdl )
					
					u_MsgConMon( STR0005 + cArqCtrl, .F. ) //'Fazendo UpLoad '
					
					If !u_UpLoadFTP( cDirLocal + cArqCtrl + cExtExport, cDirFTP + cArqCtrl + cExtExport, nTenta, lUsaFTP )
						u_MsgConMon( STR0006 + cDirFTP + cArqCtrl + cExtExport ) //'Nao foi possivel fazer upload arquivo '
					EndIf
				EndIf
				
				UA3->( dbSkip() )
			End
			
		Else
			u_MsgConMon( STR0013 ) //'Problemas no upload de arquivos'
			DesFaz( aArq[2] + cExtensao, cTabela, cDirLocTmp, .F. )
			DesFaz( aArq[3] + cExtensao, cTabela, cDirLocTmp, .T. )
		EndIf
		
	Else
		DesFaz( aArq[2] + cExtensao, cTabela, cDirLocTmp, .F. )
		DesFaz( aArq[3] + cExtensao, cTabela, cDirLocTmp, .T. )
	EndIf
EndIf

// Limpando arquivos de trabalho
aLimpar := Directory( cDirLocTmp + '*.*' )
aEval( aLimpar, { |y,x| FErase( cDirLocTmp + aLimpar[x][1]) } )

// Fechando o Semaforo
FClose( nHdl )
FErase( 'PC' + cPacote + cTabela + '.LCK' )

u_MsgConMon( STR0009 + cPacote + STR0002 + cTabela, .F. ) //'Finalizando Exportacao Pacote '###' Tabela '
// Linha Alterada para Processar Sequencial
//ClearEnv()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ COPIAR   บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para fazer a copia dos registros da base para os    บฑฑ
ฑฑบ          ณ arquivos de exportacao                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Copiar( cPacote, cTabela, cEmpresa, cFil, cDirLocTmp, cExtensao )
Local aArea      := GetArea()
Local aAreaUA2   := UA2->( GetArea() )
Local aAreaAux   := {}
Local aStru      := {}
Local aRet       := {}
Local cSeq       := ''
Local cArqILimpo := ''
Local cArqELimpo := ''
Local cArqIncAlt := cDirLocTmp + CriaTrab( , .F. )
Local cArqExc    := cDirLocTmp + CriaTrab( , .F. )
Local cCpoMSEXP  := IIF( SubStr( cTabela, 1, 1 )=='S', SubStr( cTabela, 2, 2 ), cTabela ) + '_MSEXP'
Local cCpoFILIAL := IIF( SubStr( cTabela, 1, 1 )=='S', SubStr( cTabela, 2, 2 ), cTabela ) + '_FILIAL'
Local nI         := 0
Local lGravou    := .F.
Local lGravouArq := .F.
Local lRenArq    := .T.

// Posicionando arquivo de tabelas de pacotes
dbSelectArea( 'UA2' )
dbSetOrder( 2 )
dbSeek( xFilial( 'UA2' ) + cPacote + cTabela )

dbSelectArea(cTabela)
dbOrderNickName( cTabela + 'MSEXP' )
dbGoTop()

aStru := (cTabela)->( dbStruct() )
Copy Structure To &( cArqIncAlt )
Copy Structure To &( cArqExc )

// Rotina Execucao no Inicio da Tabela
If ExistBlock( UA2->UA2_RTINEX )
	aAreaAux := GetArea()
	ExecBlock( UA2->UA2_RTINEX, .F., .F., { cPacote, cTabela, cEmpresa, cFil } )
	RestArea( aAreaAux )
EndIf

// Arquivo de Trabalho Inclusao/Alteracao
dbUseArea( .T.,, cArqIncAlt, 'TRBI', .T., .F. )

// Arquivo de Trabalho Exclusao
dbUseArea( .T.,, cArqExc   , 'TRBE', .T., .F. )


/////////////////////
Set Deleted OFF    // Esta variavel de ambiente eh mudada para permitir tratar os registros deletados
/////////////////////

dbSelectArea(cTabela)
//dbSeek( xFilial(cTabela) )
(cTabela)->( dbGoTop() )

// SM2 NAO TEM FILIAL
While !(cTabela)->( Eof() ) .AND. !KillApp() .AND. Empty( (cTabela)->( &( cCpoMSEXP ) ) ) //.AND. IIF( cTabela == 'SM2', .T., xFilial(cTabela) == (cTabela)->( &( cCpoFILIAL ) ) )
	
	lGravou := Gravar( cPacote, cTabela, cEmpresa, cFil, !Deleted(), aStru )
	
	If lGravou
		Begin Transaction
		dbSelectArea(cTabela)
		RecLock( cTabela, .F. )
		(cTabela)->( &( cCpoMSEXP ) ) := DtoS( Date() )
		MsUnLock()
		End Transaction
		lGravouArq := .T.
	EndIf
	
	dbSelectArea(cTabela)
	// Nao esta errado, como o campo chave MSEXP eh preenchido o arquivo se desposiciona
	// assim volta-se ao Top para pegar o 1o. registro com MSEXP vazio
	//	(cTabela)->( dbSkip() )
	(cTabela)->( dbGoTop() )
	//dbSeek( xFilial(cTabela) )
End

dbSelectArea( 'TRBI' )
dbCloseArea()

dbSelectArea( 'TRBE' )
dbCloseArea()

/////////////////////
Set Deleted ON     //
/////////////////////

// Rotina Execucao no Inicio da Tabela
If ExistBlock( UA2->UA2_RTFIEX )
	aAreaAux := GetArea()
	ExecBlock( UA2->UA2_RTFIEX, .F., .F., {cPacote, cTabela, cEmpresa, cFil} )
	RestArea( aAreaAux )
EndIf

If lGravouArq
	// Nome dos Arquivos
	cSeq       := PegaSeq()
	cArqILimpo := 'I' + cEmpresa + cFil + cSeq
	cArqELimpo := 'E' + cEmpresa + cFil + cSeq
	
	
	If FRename( cArqIncAlt + cExtensao, cDirLocTmp + cArqILimpo + cExtensao ) == 0
		If File( cArqIncAlt + '.FPT' )
			FRename( cArqIncAlt + '.FPT', cDirLocTmp + cArqILimpo + '.FPT' )
		EndIf
	Else
		//	lGravouArq := .F.
		lRenArq    := .F.
		u_MsgConMon( STR0017 + cArqIncAlt + cExtensao + ; //'Nใo conseguiu renomear o arquivo temporario '
		STR0018 + cDirLocTmp + cArqILimpo + cExtensao ) //' para o nome do movimento '
	EndIf
	
	If FRename( cArqExc   + cExtensao, cDirLocTmp + cArqELimpo + cExtensao ) == 0
		If File( cArqExc    + '.FPT' )
			FRename( cArqExc   + '.FPT', cDirLocTmp + cArqELimpo + '.FPT' )
		EndIf
	Else
		//  lGravouArq := .F.
		lRenArq    := .F.
		u_MsgConMon( STR0017 + cArqExc   + cExtensao + ; //'Nใo conseguiu renomear o arquivo temporario '
		STR0018 + cDirLocTmp + cArqELimpo + cExtensao )  //'para o nome do movimento '
	EndIf
EndIf

If lGravouArq .and. lRenArq
	If u_GravaTXT( cPacote, cTabela, cDirLocTmp + cArqILimpo + cExtensao, 'I' )
		If 	!u_GravaTXT( cPacote, cTabela, cDirLocTmp + cArqELimpo + cExtensao, 'E' )
			lRenArq := .F.
		EndIf
	Else
		lRenArq := .F.
	EndIf
	
	aRet := { lGravouArq, cArqILimpo, cArqELimpo, lRenArq }
Else
	aRet := { lGravouArq, u_PegaFile( cArqIncAlt ), u_PegaFile( cArqExc ), lRenArq }
EndIf

RestArea( aAreaUA2 )
RestArea( aArea )

Return  aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GRAVAR   บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravar os dados dos arquivos de exportcao                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Gravar( cPacote, cTabela, cEmpresa, cFil, lOperacao, aStru )
Local cAliaTrb := IIF( lOperacao, 'TRBI', 'TRBE' )
Local lRet     := .T.
Local nI       := 0

// Parametros da Rotina executada para cada registro
// 1 Pacote Exportada
// 2 Tabela Exportada
// 3 Empresa Origem
// 4 Filial Origem
// 5 Operacao - .F. Inclusao/Exclusao  .T. Exclusao
// 6 Posicao  - .F. Antes de exportar o registro .T. Depois de exportar o registro

If ExistBlock( UA2->UA2_RTDUEX )
	aAreaAux := GetArea()
	ExecBlock( UA2->UA2_RTDUEX, .F., .F., {cPacote, cTabela, cEmpresa, cFil, lOperacao, .F.} )
	RestArea( aAreaAux )
EndIf

// Exportando Registro
dbSelectArea( cAliaTrb )
RecLock( cAliaTrb, .T. )
For nI := 1 to Len( aStru )
	FieldPut( nI, (cTabela)->( FieldGet( nI ) ) )
Next nI
MsUnlock()

If ExistBlock( UA2->UA2_RTDUEX )
	aAreaAux := GetArea()
	ExecBlock( UA2->UA2_RTDUEX, .F., .F., {cPacote, cTabela, cEmpresa, cFil, lOperacao, .T.} )
	RestArea( aAreaAux )
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PEGASEQ  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Pegar proxima sequencia para nome do arquivos de exportacaoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PegaSeq()
Local cRet     := ''
Local nHdl     := -1
Local nTamaSeq := 3
// Pegando sequencial dos arquivos
While .T. .AND. !KillApp()
	nHdl := MSFcreate( 'SEQUENC.LCK' )
	If nHdl >= 0
		cRet := GetMV( 'FS_SEQEXP',, '000' )
		cRet := Soma1( cRet, nTamaSeq )
		PutMv( 'FS_SEQEXP', cRet )
		FClose( nHdl )
		FErase( 'SEQUENC.LCK' )
		Exit
	EndIf
End
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ VERCOMEMPบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se ha compartilhamento do arquivo entre empresas  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerComEmp( cTabela, cTabEmp, cEmpresa, cEmpDest )
Local aArea    := GetArea()
Local aAreaSX2 := SX2->( GetArea() )
Local lRet     := .F.
Local lIndexou := .F.
Local cArqSX2  := 'SX2' + cEmpDest + '0' + GetDbExtension()
Local cIndSX2  := 'SX2' + cEmpDest + '0' + IndexExt()

If File( cArqSX2 ) .AND. cEmpresa <> cEmpDest   // Arquivo Existe, e nao esta na posicionado na mesma empresa
	dbUseArea( .T.,, cArqSX2, 'TSX2', .T., .F. )
	dbSelectArea( 'TSX2' )
	
	If !File( cIndSX2 )
		cIndSX2 := CriaTrab( , .F. ) + OrdBagExt()
		IndRegua( 'TSX2', cIndSX2, 'X2_CHAVE',,,, .F. )
		lIndexou := .T.
	EndIf
	
	TSX2->( dbSetIndex( cIndSX2 ) )
	
	If TSX2->( dbSeek(cTabela) )
		If cTabEmp == AllTrim( TSX2->X2_ARQUIVO )
			lRet := .T.
		EndIf
	EndIf
	
	dbCloseArea()
	
	If lIndexou
		FErase( cIndSX2 )
	EndIf
EndIf

RestArea( aAreaSX2 )
RestArea( aArea )
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ DESFAZ   บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Desfaz o FLAG de Exportacao                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Desfaz( cArqDesfaz, cTabela, cDirLocTmp, lExclusao )
Local aArea      := GetArea()
Local cChave     := ''
Local cCpoFILIAL := IIf( SubStr( cTabela, 1, 1 )=='S', SubStr( cTabela, 2, 2 ), cTabela ) + '_FILIAL'
Local cCpoMSEXP  := IIf( SubStr( cTabela, 1, 1 )=='S', SubStr( cTabela, 2, 2 ), cTabela ) + '_MSEXP'
Local nI         := 0
Local nOrdem     := 1
Local aStru      := {}
Local lAbriu     := .T.
Local lErroAbert := .F.
Local bBlockErro := ErrorBlock( { |oErroArq| ChkErrDes( oErroArq ) } )

u_MsgConMon( STR0015 + cArqDesfaz, .F. ) //'Iniciando desmarcacao do FLAG de exportacao '

// Tabela de excecao de chave unica
dbSelectArea( 'UA7' )
If dbSeek( xFilial( 'UA7' ) + cTabela )
	nOrdem := UA7->UA7_ORDEM
EndIf

// Inicializo a Tabela

If Select(cTabela) <=0
	ChkFile(cTabela)
	lAbriu := .T.
EndIf

dbSelectArea(cTabela)
dbSetOrder( nOrdem )
aStru  := (cTabela)->( dbStruct() )
cChave := (cTabela)->( IndexKey() )
cChave := StrTran( cChave, ' ', '' )

// Arquivo de Devolucao
Begin Sequence
dbUseArea( .T.,, cDirLocTmp + cArqDesfaz, 'DEFA', .T., .F. )
Recover
lErroAbert := .T.

End Sequence
ErrorBlock( bBlockErro )

If lErroAbert
	RestArea( aArea )
	Return NIL
EndIf


dbSelectArea( 'DEFA' )
dbGoTop()
Begin Transaction
dbSelectArea( 'DEFA' )
ProcRegua( DEFA->( LastRec() ) )

While !DEFA->( Eof() ) .AND. !KillApp()
	IncProc()
	
	dbSelectArea(cTabela)
	
	//	If dbSeek( DEFA->( xFilial(cTabela) + ( &( cChave ) ) ) )
	If lExclusao
		/////////////////////
		Set Deleted OFF    //
		/////////////////////
		
		If dbSeek( DEFA->( &( cChave ) ) )
			cChvAnt := DEFA->( &( cChave ) )
			While !(cTabela)->( Eof() ) .AND. !KillApp() .AND. cChvAnt == (cTabela)->( &( cChave ) )
				
				If DEFA->( &( cChave ) ) == (cTabela)->( &( cChave ) ) .AND. Deleted()
					RecLock( cTabela, .F. )
					(cTabela)->( &( cCpoMSEXP ) ) := ''  // Para poder exportar de volta
					MsUnlock()
					Exit
				EndIf
				
				(cTabela)->( Skip() )
			End
		EndIf
		
		/////////////////////
		Set Deleted ON     //
		/////////////////////
		
	Else
		
		If dbSeek( DEFA->( &( cChave ) ) )
			RecLock( cTabela, .F. )
			(cTabela)->( &( cCpoMSEXP ) ) := ''  // Para poder exportar de volta
			MsUnlock()
		EndIf
		
	EndIf
	
	dbSelectArea( 'DEFA' )
	DEFA->( dbSkip() )
End

End Transaction

dbSelectArea( 'DEFA' )
dbCloseArea()

If 	lAbriu
	dbSelectArea( cTabela )
	dbCloseArea()
EndIf

RestArea( aArea )
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ CHKINTEG บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Checa Integridade dos arquivo feitos upload                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkInteg( aArq, cDirLocInt, cDirFTPMov, cExtensao, nTenta )
Local aArea      := GetArea()
Local lRet       := .T.
Local lErroAbert := .F.
Local bBlockErro := ErrorBlock( { |oErroArq| ChkErrAber( oErroArq ) } )
Local cArqInc    := aArq[2] + cExtensao
Local cArqExc    := aArq[3] + cExtensao
Local cAux       := ''

u_MsgConMon( STR0016, .F. )  //'Verificando Integridade dos Arquivos no FTP'

If u_DwLoadFTP( cDirLocInt + cArqInc, cDirFTPMov + cArqInc, nTenta )
	Begin Sequence
	dbUseArea( .T.,, cDirLocInt + cArqInc, 'INTI', .F., .F. )
	Recover
	lErroAbert := .T.
	End Sequence
	ErrorBlock( bBlockErro )
	
	dbSelectArea( 'INTI' )
	dbCloseArea()
	FErase( cDirLocInt + cArqInc )
	
	cAux := u_TrocaExt( cDirLocInt + cArqInc, '.FPT' )
	If File( cAux )
		FErase( cAux )
	EndIf
	
	If lErroAbert
		lRet := .F.
	Else
		
		If u_DwLoadFTP( cDirLocInt + cArqExc, cDirFTPMov + cArqExc, nTenta )
			Begin Sequence
			dbUseArea( .T.,, cDirLocInt + cArqExc, 'INTD', .F., .F. )
			Recover
			lErroAbert := .T.
			End Sequence
			ErrorBlock( bBlockErro )
			
			dbSelectArea( 'INTD' )
			dbCloseArea()
			FErase( cDirLocInt + cArqExc )
			
			cAux := u_TrocaExt( cDirLocInt + cArqExc, '.FPT' )
			If File( cAux )
				FErase( cAux )
			EndIf
			
			If lErroAbert
				lRet := .F.
			EndIf
			
		EndIf
	EndIf
EndIf

RestArea( aArea )
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCHKERRABERบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tratamento de erro na abertura                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkErrAber( oErroArq )
If oErroArq:GenCode > 0
	u_MsgConMon( STR0014 + Alltrim( Str( oErroArq:GenCode ) ) + ' ) : ' + AllTrim( oErroArq:Description ) ) //'Erro integridade arquivo de movimento - Codigo Erro ( '
EndIf
Break
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCHKERRABERบAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tratamento de erro na abertura                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkErrDes( oErroArq )
If oErroArq:GenCode > 0
	u_MsgConMon( STR0019 + Alltrim( Str( oErroArq:GenCode ) ) + ' ) : ' + AllTrim( oErroArq:Description ) ) //'Erro abertura de arquivo - Codigo Erro ( '
EndIf
Break
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณGRAVATXT  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao do arquivo texto para exportacao                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GravaTXT( cPacote, cTabela, cArqTrat, cOpera )
Local aArea     := GetArea()
Local aAreaUA1  := UA1->( GetArea() )
Local aAreaUA2  := UA2->( GetArea() )
Local aStruct   := (cTabela)->( dbStruct() )
Local nHandle   := -1
Local cBuffer   := 0
Local nTamLin   := 0
Local nPos      := 0
Local nI        := 0
Local cAux      := ''
Local aGravacao := {}
Local cArqTexto := u_TrocaExt( cArqTrat, '.TXT' )
Local cFimLinha := IIf( 'CTREE' $ RealRdd(), Chr( 13 ), Chr( 13 ) + Chr( 10 ) )

If ( nHandle := MSFCreate( cArqTexto, 0 ) ) < 0
	Return .F.
EndIf

UA1->( dbSeek( xFilial( 'UA1' ) + cPacote ) )
UA2->( dbSeek( xFilial( 'UA2' ) + cPacote  + cTabela ) )

aAdd( aGravacao, {'[PACOTE]', cPacote + IIf( cOpera == 'I','MOV', IIf( cOpera == 'E', 'EXC', 'DEV' ) ) + __cRDD } )
aAdd( aGravacao, {'[TABELA]', cTabela + u_FillText( UA2->UA2_RTINIM, 'C', 10 ) + 	u_FillText( UA2->UA2_RTDUIM, 'C', 10 ) + 	u_FillText( UA2->UA2_RTFIIM, 'C', 10 ) } )

nPos := 9
For nI := 1 To Len( aStruct )
	cAux := u_FillText( aStruct[nI][1], 'C', 10 ) + SubStr( aStruct[nI][2], 1, 1 ) + ;
	Str( aStruct[nI][3], 4, 0 ) + Str( aStruct[nI][4], 4, 0 ) + ;
	Str( nPos, 4, 0)
	aAdd( aGravacao, { '[ESTRUT]', cAux } )
	nTamLin += aStruct[nI][3]
	nPos    += aStruct[nI][3]
Next

// 8 Eh o tamanho da TAG
nTamLin := Max( 78, nTamLin + 8 )

aGravacao[1][2] := u_FillText( nTamLin + Len( cFimLinha ), 'N', 4, 0, .T. ) + ;
u_FillText( nTamLin, 'N', 4, 0, .T. ) + ;
aGravacao[1][2]

dbUseArea( .T.,, cArqTrat, 'TAUX', .F., .T. )

TAUX->( dbGoTop() )
nCt := 0

While !TAUX->( Eof() )
	cBuffer := ''
	
	For nI := 1 To Len( aStruct )
		cBuffer += 	u_FillText( TAUX->(&( aStruct[nI][1] ) ), aStruct[nI][2], aStruct[nI][3], aStruct[nI][4] )
	Next
	
	aAdd( aGravacao, { '[REGIST]', cBuffer } )
	
	nCt++
	
	TAUX->( dbSkip() )
End

aAdd( aGravacao, { '[FINAL ]', cTabela + u_FillText( nCt, 'N', 5, 0, .T. ) }  )

TAUX->( dbCloseArea() )

For nI := 1 To Len( aGravacao )
	cAux := aGravacao[nI][1] + aGravacao[nI][2]
	cAux += Replicate( ' ', nTamLin - Len( cAux ) )
	FWrite( nHandle,  cAux + cFimLinha )
Next

FClose(  nHandle )

RestArea( aAreaUA1 )
RestArea( aAreaUA2 )
RestArea( aArea )

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FILLTEXT บAutor  ณ Ernani Forastieri  บ Data ณ  13/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para preencher campos para gravacao em     บฑฑ
ฑฑบ          ณ arquivos  textos                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FillText( uConteudo, cTipo, nTam, nDec, lNumZero, lCharZero )
Local cRet := ''

Default lNumZero   := .T.
Default lCharZero  := .F.
Default nDec       := 0

If     cTipo == 'C'
	
	If lCharZero
		cRet := StrTran( uConteudo, '.', '' )
		cRet := SubStr( PadL( cRet, nTam ), Max( 1, Len( cRet ) - nTam - 1 ), nTam )
		cRet := StrTran( cRet, ' ', '0' )
	Else
		cRet := SubStr( PadR( uConteudo, nTam ), 1, nTam )
	EndIf
	
ElseIf cTipo == 'N'
	cRet := uConteudo * ( 10 ^ nDec )
	cRet := Str( Int( cRet ) )
	//	cRet := StrTran( cRet, '.', '' )
	cRet := SubStr( PadL( AllTrim( cRet ), nTam ), 1, nTam )
	
	If lNumZero
		cRet := StrTran( cRet, ' ', '0' )
	EndIf
	
ElseIf cTipo == 'D'
	cRet := SubStr( PadR( DToS( uConteudo ), nTam ), 1, nTam )
	
Else
	uConteudo := u_EverChar( uConteudo )
	cRet := SubStr( PadR( uConteudo, nTam ), 1, nTam )
	
EndIf

Return cRet

/////////////////////////////////////////////////////////////////////////////