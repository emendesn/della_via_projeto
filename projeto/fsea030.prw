#INCLUDE 'FSEA030.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA030  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para importacao dos pacotes                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FSEA030( aParams )
Local lManual    := IIf( aParams == NIL, .T., aParams[1][1] )
Local cEmpresa   := IIf( lManual, SM0->M0_CODIGO, aParams[1][2] )
Local cFil       := IIf( lManual, SM0->M0_CODIGO, aParams[1][3] )
Local cDirLoc    := ''
Local cDirFTP    := ''
Local cDirFTPMov := ''
Local cDirLocTmp := ''
Local cControle  := ''
Local cPacote    := ''
Local cTabela    := ''
Local aFiles     := {}
Local aAux       := {}
Local aPacotes   := {}
Local aArqImp    := {}
Local aArqEOK    := {}    // Arquivos a importar
Local aArqEOK2   := {}    // Arquivos a importar
Local aArqIOK    := {}    // Arquivos ja importados com sucesso
Local aArqDeO    := {}    // Arquivos devolvidos a origem
Local aArqErr    := {}    // Arquivos com erros de estrutura no  movimento
Local aArqUpLoad := {}
Local aExcValid  := {}    // Excecao de Validacao
Local aExcImport := {}    // Excecao de Importacao
Local aAreaAux   := {}
Local nI         := 0
Local nPos       := 0
Local nHdl       := -1
Local nJ         := 0
Local nCnt       := 1
Local nTamOrdem  := 3
Local nTenta     := 10
Local nMaxFTP    := 0
Local nContad    := 0
Local cArqIncAlt := ''
Local cArqExc    := ''
Local lTemPrior  := .F.
Local lArqUse    := .F.
Local lGeraDWN   := .F.
Local lArqImp    := .T.
Local lUsaFTP    := .T.
Local lConsFil   := .F.
Local lArqOk     := .T.
Local cArqSema   := 'FSEA030' + cEmpresa + '.LCK'

Private cExtensao:= Upper( GetDbExtension() )

If File( cArqSema )
	If ( lArqUse := ( FErase( cArqSema ) < 0 ) )
		u_MsgConMon( STR0001 ) //'Job Importacao ja esta em andamento'
		Return NIL
	EndIf
EndIf

// Abrindo o semaforo para trava
nHdl := MSFcreate( cArqSema )

u_MsgConMon( STR0002 + cEmpresa + ' ' + cFil, .F. ) //'Iniciando Processo Importacao '

// Prepara ambiente se for JOB
If !lManual
	RpcSetType( 3 )
	RpcSetEnv( cEmpresa, cFil,,,,, {'UA1', 'UA2', 'UA3', 'UA4', 'UA5', 'UA6', 'UA7'} )
EndIf

// Inicializando tabelas
dbSelectArea( 'UA1' )
dbSetOrder( 1 )

dbSelectArea( 'UA2' )
dbSetOrder( 2 )

dbSelectArea( 'UA3' )
dbSetOrder( 1 )

dbSelectArea( 'UA4' )
dbSetOrder( 1 )

dbSelectArea( 'UA6' )
dbSetOrder( 1 )

dbSelectArea( 'UA7' )
dbSetOrder( 1 )

dbSelectArea( 'SX3' )
dbSetOrder( 1 )

lUsaFTP    := GetMV( 'FS_USAFTP' ,, .T. ) // Usa FTP
lConsFil   := GetMV( 'FS_FILIMP' ,, .F. )
cCentra    := GetMV( 'FS_CENTRA' ,, ''  )
nTenta     := GetMV( 'FS_NUMTENT',, 10  )
lGeraDWN   := GetMV( 'FS_GERADWN',, .F. )
nTamOrdem  := TamSX3( 'UA2_ORDEM' )[1]
cDirFTPMov := IIf( lUsaFTP, GetMV( 'FS_DRFTPMV',, '' ), GetMV( 'FS_DRREDMV',, '\sincron\movto\' ) ) // Diretorio Movimento FTP
cDirLocTmp := GetMV( 'FS_DRLOCMV',, '\sincron\temp\' ) // Diretorio Movimento Local
cDirFTP    := u_EmpFilDir( 'F', cEmpresa, cFil ) // Diretorio de FTP
//cDirLoc    := u_EmpFilDir( 'L', cEmpresa, cFil ) // Diretorio Local
cDirLoc    := cDirLocTmp

// Diretorios de Trabalho
If !File( cDirLocTmp )
	u_MyMakeDir( cDirLocTmp )
EndIf

//If !lUsaFTP .and. !File( cDirFTPMov )
//	u_MyMakeDir( cDirFTPMov )
//EndIf

//If !lUsaFTP .AND. !File( cDirLoc )
//	u_MyMakeDir( cDirLoc )
//EndIf


// Conexao FTP
If u_ConexFTP(,,,,, lUsaFTP)
	
	If  u_DirChaFTP( cDirFTP, lUsaFTP )
		u_MsgConMon( STR0014, .F. ) //'Coletando informacoes para Importacao '
		//		cCurDir   := FTPGetCurDir()
		aArqEOK   := u_DirecFTP( '*.EOK', cDirFTP, lUsaFTP )  // Arquivos a importar
		aArqIOK   := u_DirecFTP( '*.IOK', cDirFTP, lUsaFTP )  // Arquivos ja importados com sucesso
		aArqDeO   := u_DirecFTP( '*.DEO', cDirFTP, lUsaFTP )  // Arquivos devolvidos a origem
		
		/////////////
		aSort( aArqEok,,, {|x, y| Dtos( x[3] ) + x[4]< Dtos( y[3] ) + y[4]} )
		For nI:= 1 To LEN( aArqEok )
			nPos       := At( '.', aArqEok[nI][1] ) - 1
			cControle  := SubStr( aArqEok[nI][1], 1, nPos )
			cPacote    := SubStr( cControle,  1, 3 )
			cTabela    := SubStr( cControle, 12, 3 )
			cGrupo     := SubStr( aArqEok[nI][1], 1, 3 ) + SubStr( aArqEok[nI][1], 15, nPos - 15 + 1 )
			aAdd( aArqEOK2, {aArqEOK[nI], cControle, cPacote, cTabela, cGrupo } )
		Next
		aSort( aArqEok2,,, {|x, y| x[5]+x[3]+x[4] < y[5]+y[3]+y[4]} )
		
		aArqEOK := {}
		For nI:=1 to Len( aArqEOK2 )
			aAdd( aArqEOK, aArqEok2[nI][1] )
		Next
		/////////////
		
	Else
		u_MsgConMon( STR0003 + cDirFTP )          //'Nao foi possivel acessar diretorio FTP '
	EndIf
	
	// Verifica todos os arquivos a importar
	// e monta uma Matriz verificando as prioridades
	
	u_MsgConMon( STR0015, .F. ) //'Fazendo Download de arquivos importacao'
	
	nMaxFTP := Min( Len( aArqEOK ), GetMv( 'FS_QTMXFTP',, 99999 ) )
	nContad := 0
	
	For nI := 1 to Len( aArqEok )
		If nContad >= nMaxFtp
			Exit
		EndIf
		
		nPos       := At( '.', aArqEok[nI][1] ) - 1
		cControle  := SubStr( aArqEok[nI][1], 1, nPos )
		cPacote    := SubStr( cControle,  1, 3 )
		cTabela    := SubStr( cControle, 12, 3 )
		//		cGrupo     := SubStr( aArqEok[nI][1], 1, 11 ) + SubStr( aArqEok[nI][1], 15, nPos - 15 + 1 )
		cGrupo     := SubStr( aArqEok[nI][1], 1, 3 ) + SubStr( aArqEok[nI][1], 15, nPos - 15 + 1 )
		
		// Se foi importado com sucesso ou teve arquivo devolvido nao processar
		If  aScan( aArqIOK , {|x| SubStr( x[1], 1, nPos ) == cControle } ) == 0 .AND. ;
			aScan( aArqDeO , {|x| SubStr( x[1], 1, nPos ) == cControle } ) == 0
			
			u_MsgConMon( STR0016 + cControle, .F. ) //'Fazendo Download '
			
			// Baixando os arquivos do FTP
			If DownFiles( cDirFTP, cDirLoc, cDirFTPMov, cDirLocTmp, aArqEok[nI][1], @cArqIncAlt, @cArqExc, nTenta, lUsaFTP, lGeraDWN )
				//dbSelectArea( 'UA2' )
				lTemPrior := UA2->( dbSeek( xFilial( 'UA2' ) + cPacote + cTabela ) )
				aAdd( aArqImp, { IIF( lTemPrior, UA2->UA2_ORDEM, Replicate( 'Z', nTamOrdem ) ), cControle, cPacote, cTabela, cGrupo, cArqIncAlt, cArqExc} )
				nContad++
			EndIf
			
		EndIf
	Next nI
	
Else
	u_MsgConMon( STR0004 ) //'Nao foi possivel fazer conexao com FTP '
EndIf

u_DesConxFTP()

aSort( aArqImp,,, {|x, y| x[5] + x[3] + x[1] + x[4] < y[5] + y[3] + y[1] + y[4]} )

// Separa os Pacotes para processamento
aPacotes := {}
nCnt := 1

While nCnt <= Len( aArqImp ) .AND. !KillApp()
	
	cQuebra := aArqImp[nCnt][5]
	cPacote := aArqImp[nCnt][3]
	cTabela := aArqImp[nCnt][4]
	aAux    := {}
	
	While nCnt <= Len( aArqImp ) .AND. !KillApp() .AND. 	cQuebra == aArqImp[nCnt][5]
		aAdd( aAux, aArqImp[nCnt] )
		nCnt++
	End
	
	aAdd( aPacotes, aAux )
End

// Carga da tabela de Excecoes de Validacao e Importacao para Matriz

UA4->( dbGoTop() )
While !UA4->( Eof() )
	If    !Empty( UA4->UA4_VALID )
		aAdd( aExcValid, { UA4->UA4_CAMPO, UA4->UA4_VALID } )
	EndIf
	If    UA4->UA4_IGNORA == 'S'
		aAdd( aExcImport, { UA4->UA4_CAMPO } )
	EndIf
	
	UA4->( dbSkip() )
End

aSort( aExcValid,,, {|x, y| x[1] < y[1]} )
aSort( aExcImport )

// Ponto de Entrada Inicio Importa็ao
If ExistBlock( 'FSE030IN' )
	aAreaAux := GetArea()
	lArqImp  := ExecBlock( 'FSE030IN', .F., .F., { cEmpresa, cFil } )
	RestArea( aAreaAux )
EndIf

If lArqImp
	// Importando os pacotes
	For nI := 1 To Len( aPacotes )
		
		cPacote := aPacotes[nI][1][3]
		
		lArqOk := .T.
		UA1->( dbSeek( xFilial( 'UA1' ) + cPacote ) )
		
		// Ponto de Entrada Inicio Importa็ao Pacote
		If ExistBlock( UA1->UA1_RTIIPC )
			aAreaAux := GetArea()
			lArqOk   := ExecBlock( UA1->UA1_RTIIPC,  .F., .F., {cPacote, cEmpresa, cFil } )
			RestArea( aAreaAux )
		EndIf
		
		If lArqOk
			For nJ := 1 To Len( aPacotes[nI] )
				Importar( aPacotes[nI][nJ], cDirFTP, cDirLoc, cDirFTPMov, cDirLocTmp, aExcValid, aExcImport, nTenta, lUsaFTP, lGeraDWN, lConsFil )
			Next
		EndIf
		
		// Ponto de Entrada Final Importa็ao Pacote
		If ExistBlock( UA1->UA1_RTFIPC )
			aAreaAux := GetArea()
			ExecBlock( UA1->UA1_RTFIPC, .F., .F., {cPacote, cEmpresa, cFil } )
			RestArea( aAreaAux )
		EndIf
		
	Next
EndIf

// Ponto de Entrada Final Importa็ao
If ExistBlock( 'FSE030FI' )
	aAreaAux := GetArea()
	ExecBlock( 'FSE030FI', .F., .F., {cEmpresa, cFil} )
	RestArea( aAreaAux )
EndIf

// Limpando arquivos de trabalho
aLimpar := Directory( cDirLocTmp + '*.*' )
aEval( aLimpar, { |y,x| FErase( cDirLocTmp + aLimpar[x][1]) } )

// Fechando o Semaforo
FClose( nHdl )
FErase( cArqSema )

u_MsgConMon( STR0005 + cEmpresa + ' ' + cFil, .F. ) //'Finalizando Processo Importacao '
RpcClearEnv()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ IMPORTAR บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao dos pacotes                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Importar( aParams, cDirFTP, cDirLoc, cDirFTPMov, cDirLocTmp, aExcValid, aExcImport, nTenta, lUsaFTP, lGeraDWN, lConsFil )
Local cControle  := aParams[2]
Local cPacote    := aParams[3]
Local cTabela    := aParams[4]
Local cArqIncAlt := aParams[6]
Local cArqExc    := aParams[7]
Local cEmpOri    := SubStr( cControle, 4, 2 )
Local cFilOri    := SubStr( cControle, 6, 2 )
Local aStru      := {}
Local aStruDel   := {}
Local aStruIA    := {}
Local aDicionario:= {}
Local aArqUpload := {}
Local cChave     := ''
Local cCpoFILIAL := ''
Local cCpoMSEXP  := ''
Local cArqIATemp := ''
Local cArqExTemp := ''
Local cArqDevol  := ''
Local cTipoVal   := ''
Local cPrefCpo   := ''
Local cAux       := ''
Local nOrdem     := 1
Local lAbriu     := .F.
Local lValTudo   := .F.
Local lValObrig  := .F.
Local lValNada   := .F.
Local lRegOk     := .T.
Local lArqOk     := .T.
Local lCpyOk     := .T.
Local lGerouDevol:= .F.
Local nI         := 0
Local nJ         := 0
Local nX         := 0
Local nPos       := 0
Local lErroAbert := .F.
Local lErroPref  := .F.
Local bBlockErro := ErrorBlock( { |oErroArq| ChkErrAber( oErroArq ) } )

Private ALTERA   := NIL   // Para compatibilizar com as validacoes
Private INCLUI   := NIL   // Para compatibilizar com as validacoes

u_MsgConMon( STR0018 + cControle, .F. ) //'Importando '

// Posiciona UA2 para depois pegar as rotinas definidas
dbSelectArea( 'UA2' )
dbSeek( xFilial( 'UA2' ) + cPacote + cTabela )

If Select( cTabela ) <=0
	ChkFile( cTabela )
	lAbriu := .T.
EndIf

// Tabela de excecao de chave unica
dbSelectArea( 'UA7' )
If dbSeek( xFilial( 'UA7' ) + cTabela )
	nOrdem := UA7->UA7_ORDEM
EndIf

// Tabela a se processada
dbSelectArea( cTabela )
dbSetOrder( nOrdem )
cCpoFILIAL := IIF( SubStr( cTabela, 1, 1 )=='S', SubStr( cTabela, 2, 2 ), cTabela ) + '_FILIAL'
cCpoMSEXP  := IIF( SubStr( cTabela, 1, 1 )=='S', SubStr( cTabela, 2, 2 ), cTabela ) + '_MSEXP'
cPrefCpo   := PrefixoCpo( cTabela )
aStru      := (cTabela)->( dbStruct() )
cChave     := (cTabela)->( IndexKey() )
cChave     := StrTran( cChave, ' ', '' )
//cChave     := StrTran( cChave, cCpoFILIAL + ' + ', '' )
cTipoVal   := Upper( GetMv( 'FS_TIPVAL',, 'T' ) )
lValTudo   := ( cTipoVal == 'T' )
lValObrig  := ( cTipoVal == 'O' )
lValNada   := ( cTipoVal == 'N' )
lTemMSEXP  := ( aScan( aStru, {|x| Trim( x[1] )== Trim( cCpoMSEXP ) } ) > 0 )
lRegOk     := .T.
lArqOk     := .T.
lCpyOk     := .T.
cArqIATemp := CriaTrab( , .F. )
cArqExTemp := CriaTrab( , .F. )
cArqDevol  := CriaTrab( , .F. )

If !u_ConvTXT( cDirLoc + cArqIncAlt )
	u_MsgConMon('Nao foi possivel converter arquivo texto ' + cArqIncAlt + ' para ' + GetDbExtension() )
	Return NIL
EndIf

If !u_ConvTXT( cDirLoc + cArqExc    )
	u_MsgConMon('Nao foi possivel converter arquivo texto ' + cArqExc   +  ' para ' + GetDbExtension() )
	Return NIL
EndIf

// Nao considera campos de excecao de importacao
For nI := 1 To Len( aStru )
	If ValType( aStru[nI] ) == 'A'
		If ( nPos := aScan( aExcImport, {|x| Trim( aStru[nI][1] ) == Trim( x[1] ) } ) ) > 0
			aDel( aStru, nPos )
		EndIf
	EndIf
Next

aStru := p_aPack( aStru )
aSort( aStru )
aSort( aStru,,, {|x, y| x[1] < y[1] } )

dbSelectArea( cTabela )

// Cria arquivos Temporarios de Inclusoes/alteracoes
// Com estrutura da tabela de destino
Copy Structure To &cArqIATemp
dbUseArea( .T.,, cArqIATemp, 'TMPI', .T., .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tratamento de Erro de abertura nos arquivos de movimento para nao ณ
//ณ gerar ErrorLog                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Begin Sequence
// Arquivo de Importacao Inclusao/Alteracao
dbUseArea( .T.,, cDirLoc + cArqIncAlt, 'TRBI', .T., .F. )
aStruIA  := TRBI->( dbStruct() )

// Arquivo de Importacao Exclusao
dbUseArea( .T.,, cDirLoc + cArqExc   , 'TRBD', .T., .F. )
aStruDel := TRBD->( dbStruct() )

Recover
lErroAbert := .T.

End Sequence
ErrorBlock( bBlockErro )

If !lErroAbert
	cAux := Subs( aStruIA[1][1], 1, At( '_', aStruIA[1][1] )-1 )
	If cPrefCpo <> cAux
		u_MsgConMon( STR0017 + cAux + '][' + cTabela + '] - ' + cControle + ' - ' + cArqIncAlt ) //'Prefixo dos Campos nao corresponde a tabela ['
		lErroPref := .T.
	EndIf
	
	cAux := Subs( aStruDel[1][1], 1, At( '_', aStruDel[1][1] )-1 )
	If cPrefCpo <> cAux
		u_MsgConMon( STR0017 + cAux + '][' + cTabela + '] - ' + cControle + ' - ' + cArqExc ) //'Prefixo dos Campos nao corresponde a tabela ['
		lErroPref := .T.
	EndIf
EndIf

If lErroAbert .OR. lErroPref
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fechamento de tabelas e subida do arquivo de controle com ณ
	//ณ status de erro                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lErroAbert
		//SobeErro( cControle, cDirLoc, cDirFTP, nTenta, lGeraDWN )
	EndIf
	
	If 	lAbriu
		dbSelectArea( cTabela )
		dbCloseArea()
	EndIf
	
	If Select( 'TRBI' ) > 0
		dbSelectArea( 'TRBI' )
		dbCloseArea()
	EndIf
	
	If Select( 'TRBD' ) > 0
		dbSelectArea( 'TRBD' )
		dbCloseArea()
	EndIf
	
	dbSelectArea( 'TMPI' )
	dbCloseArea()
	FErase( cArqIATemp + cExtensao )
	
	Return NIL
EndIf

// Criar arquivo de devolucao
dbSelectArea( 'TRBI' )
Copy Structure To &cArqDevol
dbUseArea( .T.,, cArqDevol , 'DEVO', .T., .F. )

// Cria arquivos Temporarios de Exclusoes
dbSelectArea( 'TRBD' )
Copy To &cArqExTemp
dbUseArea( .T.,, cArqExTemp, 'TMPE', .T., .F. )


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
// Processando Delecoes                                                                                          //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
lArqOk := .T.
lRegOk := .T.

// Validacao para exclusao
// Rotina Validacao definida para o Inicio da Tabela

// Parametros passados
// 1 Pacote
// 2 Tabela
// 3 Empresa de Origem
// 4 Filial de Ori gem
// 5 Operacao .T. Exclusao / .F. Inclusao/Alteracao

If !Empty( UA2->( UA2_RTINIM + UA2_RTDUIM + UA2_RTFIIM ) )
	
	If ExistBlock( UA2->UA2_RTINIM )
		aAreaAux := GetArea()
		lArqOk := ExecBlock( UA2->UA2_RTINIM, .F., .F., {cPacote, cTabela, .T., 'TMPE', cEmpOri, cFilOri} )
		RestArea( aAreaAux )
	EndIf
	
	If lArqOk
		lRegOk := .T.
		
		dbSelectArea( 'TRBD' )
		While !TRBD->( Eof() ) .AND. !KillApp()
			
			// Tratamento da Filial
			If xFilial( cTabela ) == TMPE->(&(cCpoFILIAL)) .or. !lConsFil
				If ExistBlock( UA2->UA2_RTDUIM )
					aAreaAux := GetArea()
					lRegOk := ExecBlock( UA2->UA2_RTDUIM, .F., .F., {cPacote, cTabela, .T., 'TMPE', cEmpOri, cFilOri} )
					If !lRegOk
						// Se nao validar eu apago do arquivo temporario para
						// nao apagar da base posteriormente
						RegLock( 'TMPE' )
						dbDelete()
						MsUnLock()
					EndIf
					RestArea( aAreaAux )
				EndIf
			Else
				// Se nao validar eu apago do arquivo temporario para
				// nao apagar da base posteriormente
				RegLock( 'TMPE' )
				dbDelete()
				MsUnLock()
			EndIf
			
			dbSelectArea( 'TRBD' )
			TRBD->( dbSkip() )
		End
	EndIf
	
	// Rotina Validacao definida para o Final da Tabela
	If ExistBlock( UA2->UA2_RTFIIM )
		aAreaAux := GetArea()
		lArqOk := ExecBlock( UA2->UA2_RTFIIM, .F., .F., {cPacote, cTabela, .T., 'TMPE', cEmpOri, cFilOri} )
		RestArea( aAreaAux )
	EndIf
EndIf

// Delecao efetiva da Base
If lArqOk
	Begin Transaction
	dbSelectArea( 'TMPE' )
	While !TMPE->( Eof() ) .AND. !KillApp()
		dbSelectArea( cTabela )
		//		If dbSeek( IIF( cTabela <> 'SM2', xFilial( cTabela ) + TMPE->( &cChave ), TMPE->( &cChave ) ) )
		If dbSeek( TMPE->( &cChave ) )
			RecLock( cTabela, .F. )
			If lTemMSEXP
				(cTabela)->( &( cCpoMSEXP ) ) := DtoS( Date() )  // Para nao exportar de volta
			EndIf
			dbDelete()
			MsUnlock()
		EndIf
		dbSelectArea( 'TMPE' )
		TMPE->( dbSkip() )
	End
	End Transaction
EndIf


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
// Processando Inclusoes/Alteracoes                                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

lArqOk := .T.
lRegOk := .T.

lGerouDevol := .F.

// Verifica se existe SX3
dbSelectArea( 'SX3' )
If dbSeek( cTabela )
	While !SX3->( Eof() ) .AND. !KillApp() .AND. cTabela ==  SX3->X3_ARQUIVO
		
		If  SX3->X3_TIPO <> 'M' .AND.  SX3->X3_CONTEXT <> 'V'
			aAdd( aDicionario, {SX3->X3_CAMPO, SX3->X3_VALID, SX3->X3_VLDUSER } )
		EndIf
		
		dbSelectArea( 'SX3' )
		dbSkip()
	End
Else
	lArqOk := .F.
	GravaLog( cControle, '', cTabela,  0, cChave, '' , STR0006 ) //'Nao existe estrutura no SX3'
EndIf


// Rotina Validacao definida para o Inicio da Tabela
If ExistBlock( UA2->UA2_RTINIM )
	aAreaAux := GetArea()
	lArqOk := ExecBlock( UA2->UA2_RTINIM, .F., .F., { cPacote, cTabela, .F., 'TMPI', cEmpOri, cFilOri } )
	RestArea( aAreaAux )
EndIf

If lArqOk
	dbSelectArea( 'TRBI' )
	dbGoTop()
	While !TRBI->( Eof() ) .AND. !KillApp()
		// Para compatibilizar com as validacoes
		ALTERA := .F.
		INCLUI := .F.
		lRegOk := .T.
		
		//		If (cTabela)->( dbSeek( IIF( cTabela <> 'SM2', xFilial( cTabela ) + TRBI->( &cChave ), TRBI->( &cChave ) ) ) )
		If (cTabela)->( dbSeek( TRBI->( &cChave ) ) )
			ALTERA := .T.
		Else
			INCLUI := .T.
		EndIf
		
		If ExistBlock( UA2->UA2_RTDUIM )
			aAreaAux := GetArea()
			lRegOk   := ExecBlock( UA2->UA2_RTDUIM, .F., .F., { cPacote, cTabela, .F., 'TMPI', cEmpOri, cFilOri} )
			RestArea( aAreaAux )
		EndIf
		
		// Tratamento da Filial
		If xFilial( cTabela ) == TRBI->(&(cCpoFILIAL)) .or. !lConsFil
			
			If ( lValTudo .OR. lValObrig )
				
				// Joga Registro para memoria
				For nI := 1 to Len( aDicionario )
					cCampo   := AllTrim( aDicionario[nI][1] )
					
					If aScan( aStru, {|x| Trim( x[1] )== cCampo } ) > 0
						nPos   := aScan( aStruIA, {|x| Trim( x[1] ) == cCampo} )
						If nPos > 0
							M->( &( cCampo ) ) := TRBI->( FieldGet( nPos ) )
						Else
							M->( &( cCampo ) ) := CriaVar( cCampo )
						EndIf
					Else
						M->( &( cCampo ) ) := CriaVar( cCampo )
					EndIf
				Next
				
				// Valida campos
				For nX := 1 to Len( aStru )
					cCampo   := AllTrim( aStru[nX][1] )
					nPos     := aScan( aStruIA, {|x| Trim( x[1] ) == cCampo} )
					
					If nPos  > 0
						xConteud := TRBI->( FieldGet( nPos ) )
						__ReadVar:= cCampo
						
						//Verifica a validacao
						If lValTudo .OR. lValObrig
							//Verifica se o campo Obrigatorio esta vazio
							lEhObrig := X3Obrigat( cCampo )
							
							If lEhObrig .AND. Empty( xConteud )
								lRegOk := .F.
								GravaLog( cControle, cCampo, cTabela, nOrdem, &cChave, xConteud, STR0007 ) //'Campo Obrigatorio Vazio'
							Else
								If lValTudo .OR. ( lEhObrig .AND. lValObrig )
									// Verifica se ha excecao de validacao
									nPos := aScan( aExcValid, {|x| Trim( x[1] )== cCampo } )
									
									If nPos == 0
										
										// Validacao pelo SX3
										nPos := aScan( aDicionario, {|x| Trim( x[1] )== cCampo } )
										If nPos > 0
											If !Empty( aDicionario[nPos][2] ) .OR. !Empty( aDicionario[nPos][3] ) .OR. lEhObrig
												If !CheckSX3( cCampo, xConteud )
													lRegOk := .F.
													GravaLog( cControle, cCampo, cTabela, nOrdem, &cChave, xConteud, aDicionario[nPos][2] + ' / ' + aDicionario[nPos][3] )
												EndIf
											EndIf
										EndIf
										
									Else
										
										// Validacao da excecao
										If !&( aExcValid[nPos][2] )
											lRegOk := .F.
											GravaLog( cControle, cCampo, cTabela, nOrdem, &cChave, xConteud, aExcValid[nPos][2] )
										EndIf
										
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				Next nX
			EndIf
			
			// Grava Arquivo Temporario
			If lRegOk
				RecLock( 'TMPI', .T. )
				For nJ := 1 to Len( aStru )
					// Faz atualizacao de apenas o que existe na estrutura
					nPos := aScan( aStruIA, {|x| Trim( x[1] ) == Trim( Field( nJ ) )} )
					If nPos > 0
						FieldPut( nJ, TRBI->( FieldGet( nPos ) ) )
					EndIf
				Next nJ
				MsUnlock()
			Else
				lGerouDevol := .T.
				RecLock( 'DEVO', .T. )
				For nJ := 1 to Len( aStruIA )
					FieldPut( nJ, TRBI->( FieldGet( nJ ) ) )
				Next nJ
				MsUnlock()
			EndIf
			
		EndIf
		dbSelectArea( 'TRBI' )
		TRBI->( dbSkip() )
	End
EndIf

// Rotina Validacao definida para o Final da Tabela
If ExistBlock( UA2->UA2_RTFIIM )
	aAreaAux := GetArea()
	lArqOk := ExecBlock( UA2->UA2_RTFIIM, .F., .F., {cPacote, cTabela, .F., 'TMPI', cEmpOri, cFilOri } )
	RestArea( aAreaAux )
EndIf

//  Importacao efetiva para base
If lArqOk
	dbSelectArea( 'TMPI' )
	dbGoTop()
	
	Begin Transaction
	
	While !TMPI->( Eof() ) .AND. !KillApp()
		
		// Ponto de Entrada Inicio Gravacao
		If ExistBlock( 'FSE030IG' )
			aAreaAux := GetArea()
			lArqImp  := ExecBlock( 'FSE030IG', .F., .F., {cPacote, cTabela, cEmpOri, cFilOri } )
			RestArea( aAreaAux )
		EndIf
		
		dbSelectArea( cTabela )
		//RecLock( cTabela, !dbSeek( IIF( cTabela <> 'SM2', xFilial( cTabela ) + TMPI->( &cChave ), TMPI->( &cChave ) ) ) )
		RecLock( cTabela, !dbSeek( TMPI->( &cChave ) ) )
		For nI := 1 to Len( aStru )
			FieldPut( nI, TMPI->( FieldGet( nI ) ) )
		Next nI
		//      If cTabela <> 'SM2'
		//			(cTabela)->( &( cCpoFILIAL ) ) := xFilial( cTabela )
		//		EndIf
		If lTemMSEXP
			(cTabela)->( &( cCpoMSEXP ) )  := DtoS( Date() )  // Para nao exportar de volta
		EndIf
		MsUnlock()
		
		// Ponto de Entrada Final Gravacao
		If ExistBlock( 'FSE030DG' )
			aAreaAux := GetArea()
			lArqImp  := ExecBlock( 'FSE030DG', .F., .F., {cPacote, cTabela, cEmpOri, cFilOri } )
			RestArea( aAreaAux )
		EndIf
		
		dbSelectArea( 'TMPI' )
		TMPI->( dbSkip() )
	End
	
	End Transaction
EndIf

dbSelectArea( 'DEVO' )
dbCloseArea()

lCpyOk     := .T.

//
// Tratamento Arquivos de Devolucao
//
aArqUpload := {}
// aArqUpload - Controla Copia de Arquivos e UpLoad
// 1 Arquivo Origem Copia
// 2 Destino de Copia e/ou Origem para FTP
// 3 Destino no FTP
// 4 Subir FTP .t./.f.

cDirFTPOri := ''
// Geracao do arquivo de devolucao

dbSelectArea( 'TRBI' )
dbCloseArea()

dbSelectArea( 'TRBD' )
dbCloseArea()

If lGerouDevol
	If u_GravaTXT( cPacote, cTabela, cArqDevol + cExtensao, 'D' )
		
		// Copia no diretorio da empresa/filial
		// que esta importando
		aAdd( aArqUpload, {cDirLoc + cControle + '.EOK', cDirLoc    + cControle  + '.DEO', cDirFTP + cControle + '.DEO', .T., .T.} )
		aAdd( aArqUpload, {cArqDevol + '.TXT'          , cDirLocTmp + cArqIncAlt + '.DDV', ''                           , .T., .F.} )
		
		//If File( cArqDevol + '.FPT' )
		//	aAdd( aArqUpload, {cArqDevol + '.FPT'        , cDirLocTmp + cArqIncAlt + '.FPT', ''                      , .T., .F.} )
		//EndIf
		
		// Diretorio FTP de Origem para devolucao
		cDirFTPOri := u_EmpFilDir( 'F', cEmpOri, cFilOri )
		aAdd( aArqUpload, {''  , cDirLoc    + cControle  + '.DEO', cDirFTPOri + cControle  + '.DEV', .F., .T.} )
		aAdd( aArqUpload, {''  , cDirLocTmp + cArqIncAlt + '.DDV', cDirFTPMov + cArqIncAlt + '.DDV', .F., .T.} )
	Else
		u_MsgConMon(STR0019 + cArqDevol )  //'Problemas na conversao do arquivo de devolucao para texto '
	EndIf
Else
	aAdd( aArqUpload, {cDirLoc + cControle + '.EOK', cDirLoc + cControle + '.IOK', cDirFTP + cControle + '.IOK', .T., .T.} )
EndIf

For nI := 1 To Len( aArqUpload )
	If aArqUpload[nI][4]
		lCpyOk := __CopyFile( aArqUpload[nI][1], aArqUpload[nI][2] )
		If !lCpyOk
			u_MsgConMon( STR0008 + aArqUpload[nI][1] + ' - ' + aArqUpload[nI][2] ) //'Problemas na copia local de arquivos '
			aArqUpload[nI][4] := .F.
		EndIf
	EndIf
Next nI

// Arquivos para upload e Arquivo de flag de download para apagar
UpFiles( aArqUpload, cDirFTP + cControle + '.DWN', nTenta, lUsaFTP, lGeraDWN )

If 	lAbriu
	dbSelectArea( cTabela )
	dbCloseArea()
EndIf

FErase( cArqDevol + cExtensao )

dbSelectArea( 'TMPI' )
dbCloseArea()
FErase( cArqIATemp + cExtensao )

dbSelectArea( 'TMPE' )
dbCloseArea()
FErase( cArqExTemp + cExtensao )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GRAVALOG บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao do arquivo de log                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaLog( cControle, cCampo, cTabela, nOrdem, cChave, xConteud, cValid )
Local aArea    := GetArea()
Local aAreaUA6 := UA6->( GetArea() )

dbSelectArea( 'UA6' )
RecLock( 'UA6', .T. )
UA6->UA6_FILIAL   := xFilial( 'UA6' )
UA6->UA6_ARQUIV   := cControle
UA6->UA6_DTGER    := Date()
UA6->UA6_HRGER    := Time()
UA6->UA6_CAMPO    := cCampo
UA6->UA6_TABELA   := cTabela
UA6->UA6_ORDEM    := nOrdem
UA6->UA6_CHAVE    := cChave

cTipo := ValType( xConteud )

If     cTipo == 'C'
	UA6->UA6_CONTED   := xConteud
	
ElseIf cTipo == 'N'
	UA6->UA6_CONTED   := AllTrim( Str( xConteud ) )
	
ElseIf cTipo == 'L'
	UA6->UA6_CONTED   := IIF( xConteud, '.T.', '.F.' )
	
ElseIf cTipo == 'D'
	UA6->UA6_CONTED   := DToC( xConteud )
	
ElseIf cTipo == 'M'
	UA6->UA6_CONTED   := 'Campo MEMO'
	
ElseIf cTipo == 'A'
	UA6->UA6_CONTED   := 'Array de ' + Str( Len( xConteud ), 4 ) + ' elementos'
	
EndIf

UA6->UA6_VALID    := cValid
UA6->UA6_EMPGER   := SM0->M0_CODIGO  // Empresa que esta rodando o JOB
UA6->UA6_FILGER   := SM0->M0_CODFIL  // Empresa que esta rodando o JOB
MsUnlock()

RestArea( aAreaUA6 )
RestArea( aArea )
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณDownFiles บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Desce arquivos do FTP                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DownFiles( cDirFTP, cDirLoc, cDirFTPMov, cDirLocTmp, cArqCtrl, cArqIncAlt, cArqExc, nTenta, lUsaFTP, lGeraDWN )
Local cAux     := StrTran( cArqCtrl, '.EOK', '.DWN' )
Local nQtdBxd  := 0
Local nI       := 0

// Baixando Arquivos FTP
If !u_DwLoadFTP( cDirLoc + cArqCtrl, cDirFTP + cArqCtrl, nTenta )
	u_MsgConMon( STR0009 + cDirFTP + cArqCtrl ) //'Nao foi possivel fazer download arquivo '
Else
	nQtdBxd++ 	 // Baixou Controle
EndIf

If nQtdBxd > 0
	If lGeraDWN
		If !u_UpLoadFTP( cDirLoc + cArqCtrl, cDirFTP + cAux, nTenta, lUsaFTP )
			u_MsgConMon( STR0010 + cDirFTP + cAux )     //'Nao foi possivel fazer upload arquivo '
		EndIf
	EndIf
	
	// Pega Nome dos arquivos a importar contidos no Controle
	FT_FUse( cDirLoc + cArqCtrl )
	FT_FGoTop()
	
	For nI := 1 To 2
		cBuffer := FT_FREADLN()
		If nI == 1
			cArqIncAlt := AllTrim( cBuffer ) // Inc./Att. esta na 1a. Linha
		Else
			cArqExc    := AllTrim( cBuffer ) // Exclusao  esta na 2a. Linha
		EndIf
		
		FT_FSkip()
	Next
	FT_FUse()
	
	// Baixando Arquivo de Inclusoes/Alteracoes
	If !Empty( cArqIncAlt )
		If u_DwLoadFTP( cDirLoc + cArqIncAlt + cExtensao, cDirFTPMov + cArqIncAlt + cExtensao, nTenta, lUsaFTP )
			nQtdBxd++ 	 // Baixou Arq. Alteracoes
		Else
			u_MsgConMon( STR0009 + cDirFTPMov + cArqIncAlt + cExtensao ) //'Nao foi possivel fazer download arquivo '
		EndIf
	EndIf
	
	// Baixando Arquivo de Exclusoes
	If !Empty( cArqExc   )
		If u_DwLoadFTP( cDirLoc + cArqExc   + cExtensao, cDirFTPMov + cArqExc   + cExtensao, nTenta, lUsaFTP )
			nQtdBxd++ 	 // Baixou Arq. Exclusoes
		Else
			u_MsgConMon( STR0009 + cDirFTPMov + cArqExc   + cExtensao ) //'Nao foi possivel fazer download arquivo '
		EndIf
	EndIf
	
EndIf

Return ( nQtdBxd == 3 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ UpFiles  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Sobe arquivos para FTP                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function UpFiles( aArqUpload, cArqFlagDwn, nTenta, lUsaFTP, lGeraDWN )
Local nI := 0

If u_ConexFTP(,,,,, lUsaFTP)
	For nI := 1 to Len( aArqUpload )
		If aArqUpload[nI][5]
			If !u_UpLoadFTP( aArqUpload[nI][2], aArqUpload[nI][3], nTenta, lUsaFTP )
				u_MsgConMon( STR0010 + aArqUpload[nI][3] ) //'Nao foi possivel fazer upload arquivo '
			EndIf
		EndIf
	Next nI
	
	If lGeraDWN
		If	!u_EraseFTP( cArqFlagDwn, lUsaFTP )
			u_MsgConMon( STR0011 + cArqFlagDwn )         //'Nao foi possivel apagar arquivo do FTP '
		EndIf
	EndIf
	
Else
	u_MsgConMon( STR0012 ) //'Nao foi possivel fazer conexao com FTP'
EndIf

u_DesConxFTP()

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
Static Function ChkErrAber( oErroArq )
If oErroArq:GenCode > 0
	u_MsgConMon( STR0013 + Alltrim( Str( oErroArq:GenCode ) ) + ' ) : ' + AllTrim( oErroArq:Description ) )  //'Erro abertura de arquivo de movimento - Codigo Erro ( '
EndIf
Break
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ CONVTXT  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para conversao do arquivo texto em arquivo compati- บฑฑ
ฑฑบ          ณ vel com RDD                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConvTXT( cArqTXT )
Local nHandle  := FOpen( cArqTXT + '.TXT', 0)
Local cBuffer  := ''
Local nBtLidos := 0
Local nTamLin  := 0
Local nCt      := 0
Local aStru    := {}
Local aDados   := {}
Local cArqRDD  := cArqTXT + Upper( GetDBExtension() )
Local nI, nJ
Local lRet     := .F.

If nHandle < 0
	Return lRet
EndIf

// Pegando Tamanho da Linha dentro do Texto
fSeek( nHandle, 8, 0)
nTamLin  := Val( fReadStr( nHandle, 4 ) )

// Le o 1o. Registro
fSeek( nHandle, 0, 0)
nBtLidos := fRead( nHandle, @cBuffer, nTamLin )

While nBtLidos >= nTamLin
	nCt++
	cTag := SubStr( cBuffer, 1, 8 )
	
	If     cTag == '[PACOTE]'
		
	ElseIf cTag == '[TABELA]'
		
	ElseIf cTag == '[ESTRUT]'
		aAdd( aStru, { SubStr( cBuffer, 9, 10), SubStr( cBuffer, 19, 1), Val( SubStr( cBuffer, 20, 4 ) ), Val( SubStr( cBuffer, 24, 4 ) ), Val( SubStr( cBuffer, 28, 4 ) ) } )
		
	ElseIf cTag == '[REGIST]'
		aAdd( aDados, cBuffer )
		
	ElseIf cTag == '[FINAL ]'
		
	EndIf
	
	nBtLidos := fRead( nHandle, @cBuffer, nTamLin )
End

FClose( nHandle )

//cTemp := CriaTrab( aStru )
dbCreate( cArqRDD, aStru )
dbusearea( .T.,, cArqRDD, 'TEMP', .T., .F. )

For nI := 1 To Len( aDados )
	RecLock('TEMP', .T. )
	
	For nJ := 1 To Len( aStru )
		
		uDado := SubStr( aDados[nI], aStru[nJ][5], aStru[nJ][3] )
		
		If     aStru[nJ][2] == "C"
			uDado := AllTrim( uDado )
			
		ElseIf aStru[nJ][2] == "N"
			uDado := Val( uDado ) / ( 10 ^ aStru[nJ][4] )
			
		ElseIf aStru[nJ][2] == "D"
			uDado := CToD( SubStr( uDado, 7, 2) + "/" + SubStr( uDado, 5, 2) + "/" + SubStr( uDado, 3, 2) )
			
		ElseIf aStru[nJ][2] == "L"
			uDado := ( uDado == 'T' )
			
		EndIf
		
		TEMP->(&(aStru[nJ][1])) := uDado
	Next
	
	MsUnlock()
Next

TEMP->( dbCloseArea() )

lRet := .T.
Return lRet

/////////////////////////////////////////////////////////////////////////////