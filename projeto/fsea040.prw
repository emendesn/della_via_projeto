#INCLUDE 'FSEA040.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ FSEA040  ºAutor  ³ Ernani Forastieri  º Data ³  27/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para atualizar do arquivo de uso da rotina de       º±±
±±º          ³ monitoramento                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User  Function FSEA040( aParams )
Local lManual   := IIf( aParams == NIL, .T., aParams[1][1] )
Local cEmpresa  := IIf( lManual, SM0->M0_CODIGO, aParams[1][2] )
Local cFil      := IIf( lManual, SM0->M0_CODIGO, aParams[1][3] )
Local aFiles    := {'UA5'}
Local nHdl      := -1
Local aArqEOK   := {}    // Arquivos a importar
Local aArqIOK   := {}    // Arquivos ja importados com sucesso
Local aArqDev   := {}    // Arquivos devolvidos
Local aArqDwn   := {}    // Arquivos em download
Local lArqUse   := .F.
Local lUsaFTP   := .T.

If File( 'FSEA040.LCK' )
	If ( lArqUse := ( FErase( 'FSEA040.LCK' ) < 0 ) )
		u_MsgConMon( STR0001 ) //'Job atualizacao do monitor ja esta em andamento'
		Return NIL
	EndIf
EndIf

// Abrindo o semaforo para trava
nHdl := MSFcreate( 'FSEA040.LCK' )

u_MsgConMon( STR0002+ cEmpresa+' '+cFil, .F. ) //'Atualizando Monitor Empresa '

// Prepara ambiente se for JOB
If !lManual
	RpcSetType( 3 )
	RpcSetEnv( cEmpresa, cFil, , , , , aFiles )
EndIf

// Inicializando tabelas
dbSelectArea( 'UA5' )
dbSetOrder( 2 )
dbGoTop()

lUsaFTP    := GetMV( 'FS_USAFTP' , , .T. ) // Usa FTP

// Conexao FTP
If u_ConexFTP( , , , , , lUsaFTP )
	
	dbSelectArea( 'SM0' )
	dbGoTop()
	
	While !SM0->( Eof() )
		cEmpRef   := SM0->M0_CODIGO
		cFilRef   := SM0->M0_CODFIL
		cDirFTP   := u_EmpFilDir( 'F', cEmpRef, cFilRef, lUsaFTP )
		
		If u_DirChaFTP( cDirFTP, lUsaFTP )
			
			aArqEOK   := u_DirecFTP( '*.EOK', cDirFTP, lUsaFTP )    // Arquivos a importar
			aArqIOK   := u_DirecFTP( '*.IOK', cDirFTP, lUsaFTP )    // Arquivos ja importados com sucesso
			aArqDev   := u_DirecFTP( '*.DEV', cDirFTP, lUsaFTP )    // Arquivos devolvidos
			aArqDwn   := u_DirecFTP( '*.DWN', cDirFTP, lUsaFTP )    // Arquivos em download
			aArqRol   := u_DirecFTP( '*.ROL', cDirFTP, lUsaFTP )    // Arquivos feito 'Rollback'
			aArqDeO   := u_DirecFTP( '*.DEO', cDirFTP, lUsaFTP )    // Arquivos Devolvido Origem
			//        	aArqErr   := FtpDirectory( '*.ERR' )    // Arquivos com erros de estrutura no  movimento
			Atualiza( cEmpRef, cFilRef, aArqEOK, aArqIOK, aArqDev, aArqDwn, aArqRol, aArqDeO, lUsaFTP ) //, aArqErr )
			
		Else
			u_MsgConMon( STR0003+cDirFTP ) //'Nao foi possivel acessar diretorio FTP '
		EndIf
		
		dbSelectArea( 'SM0' )
		dbSkip()
	End
	
Else
	u_MsgConMon( STR0004 ) //'Nao foi possivel fazer conexao com FTP '
EndIf

u_DesconxFTP()

FClose( nHdl )

FErase( 'FSEA040.LCK' )

u_MsgConMon( STR0005+ cEmpresa+' '+cFil, .F. ) //'Finalizando Atualizacao Monitor Empresa '

RpcClearEnv()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ ATUALIZA ºAutor  ³ Ernani Forastieri  º Data ³  27/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atulizao do Arquivos de monitor com os dados  de           º±±
±±º          ³ monitoramento                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Atualiza( cEmpRef, cFilRef, aArqEOK, aArqIOK, aArqDev, aArqDwn, aArqRol, aArqDeO, lUsaFTP ) //, aArqErr )
Local nI        := 0
Local nJ        := 0
Local nPos      := 0
Local nPosVet   := 0
Local cControle := ''
Local cPacote   := ''
Local cRef      := ''
Local cStatus   := ''
Local cDataRef  := CToD( '  /  /  ' )
Local cHoraRef  := CToD( '  /  /  ' )
Local aArqApagar:= {}

// Recebidos no Diretorio
For nI := 1 to Len( aArqEOK )
	aArqApagar:= {}
	nPos      := At( '.', aArqEok[nI][1] ) - 1
	cControle := SubStr( aArqEok[nI][1], 1, nPos )
	cPacote   := SubStr( cControle,  1, 3 )
	cOrigem   := SubStr( cControle,  4, 4 )
	cDestino  := SubStr( cControle,  8, 4 )
	cTabela   := SubStr( cControle, 12, 3 )
	cRef      := SubStr( cControle, 15 )
	
	// Verifica se esta apenas exportado
	If  aScan( aArqIOK, {|x| SubStr( x[1], 1, nPos ) == cControle } ) == 0 .and. ;
		aScan( aArqDeO, {|x| SubStr( x[1], 1, nPos ) == cControle } ) == 0 .and. ;
		aScan( aArqDwn, {|x| SubStr( x[1], 1, nPos ) == cControle } ) == 0
		//		aScan( aArqErr, {|x| SubStr( x[1], 1, nPos ) == cControle } ) == 0
		cStatus   := '60'
		cDataRef  := aArqEok[nI][3]
		cHoraRef  := aArqEok[nI][4]
	EndIf
	
	// Verifica se esta em download
	nPosVet := aScan( aArqDwn, {|x| SubStr( x[1], 1, nPos ) == cControle } )
	If  nPosVet > 0
		cStatus   := '70'
		cDataRef  := aArqDwn[nPosVet][3]
		cHoraRef  := aArqDwn[nPosVet][4]
	EndIf
	
	// Verifica se foi importado com sucesso
	nPosVet := aScan( aArqIOK, {|x| SubStr( x[1], 1, nPos ) == cControle } )
	If  nPosVet > 0
		cStatus   := '80'
		cDataRef  := aArqIOK[nPosVet][3]
		cHoraRef  := aArqIOK[nPosVet][4]
		aAdd( aArqApagar, cControle+'.EOK' )
		aAdd( aArqApagar, cControle+'.IOK' )
	EndIf
	
	// Verifica se foi devolvido
	nPosVet := aScan( aArqDeO, {|x| SubStr( x[1], 1, nPos ) == cControle } )
	If  nPosVet > 0
		cStatus   := '90'
		cDataRef  := aArqDeO[nPosVet][3]
		cHoraRef  := aArqDeO[nPosVet][4]
		aAdd( aArqApagar, cControle+'.EOK' )
		aAdd( aArqApagar, cControle+'.DEO' )
	EndIf
	
	/*
	// Verifica se tem erro no movimento
	nPosVet := aScan( aArqErr, {|x| SubStr( x[1], 1, nPos ) == cControle } )
	If  nPosVet > 0
	cStatus   := '99'
	cDataRef  := aArqErr[nPosVet][3]
	cHoraRef  := aArqErr[nPosVet][4]
	EndIf
	*/
	
	cHoraRef := StrZero( Val( SubStr( cHoraRef, 1, At( ':', cHoraRef )-1 ) ), 2 )+':'+StrZero( Val( SubStr( cHoraRef, At( ':', cHoraRef )+1, 2 ) ), 2 )
	
	dbSelectArea( 'UA5' )
	RecLock( 'UA5', !dbSeek( xFilial( 'UA5' )+cControle+cEmpRef+cFilRef ) )
	UA5->UA5_FILIAL := xFilial( 'UA5' )
	UA5->UA5_ARQUIV := cControle
	UA5->UA5_STATUS := cStatus
	UA5->UA5_EMPRES := cEmpRef
	UA5->UA5_CODFIL := cFilRef
	UA5->UA5_PACOTE := cPacote
	UA5->UA5_ORIGEM := cOrigem
	UA5->UA5_DESTIN := cDestino
	UA5->UA5_TABELA := cTabela
	UA5->UA5_REF    := cRef
	
	If      cStatus   == '60'
		UA5->UA5_DTEXP  := cDataRef
		UA5->UA5_HREXP  := cHoraRef
		
	ElseIf  cStatus   == '70'
		//		UA5->UA5_DTDWN  := cDataRef
		//		UA5->UA5_HRDWN  := cHoraRef
		
	ElseIf  cStatus   == '80'
		UA5->UA5_DTIMP  := cDataRef
		UA5->UA5_HRIMP  := cHoraRef
		
	ElseIf  cStatus   == '90'
		UA5->UA5_DTDEO  := cDataRef
		UA5->UA5_HRDEO  := cHoraRef
		
	EndIf
	MsUnLock()
	
	If Len( aArqApagar ) > 0
		If u_ConexFTP()
			//u_MsgConMon( 'Monitor: Conectado e pronto para apagar os arquivos.' )
			
			For nJ := 1 to Len( aArqApagar )
				cDirFTP := u_EmpFilDir( 'F', SubStr( aArqApagar[nJ], 8, 2 ), SubStr( aArqApagar[nJ], 10, 2 ), lUsaFTP )
				If !u_EraseFTP( cDirFTP+aArqApagar[nJ] )
					u_MsgConMon( STR0006+cDirFTP+aArqApagar[nJ] ) //'Não Foi Possivel Apagar o Arquivo do FTP '
				EndIf
			Next
		Else
			u_MsgConMon( STR0007 ) //'Não Foi Possivel Fazer Conexao com FTP'
		EndIf
	EndIf
Next nI


// Devolvidos para o Diretorio
For nI := 1 to Len( aArqDev )
	aArqApagar:= {}
	nPos      := At( '.', aArqDev[nI][1] ) - 1
	cControle := SubStr( aArqDev[nI][1], 1, nPos )
	cPacote   := SubStr( cControle, 1, 3 )
	cOrigem   := SubStr( cControle, 4, 4 )
	cDestino  := SubStr( cControle, 8, 4 )
	cTabela   := SubStr( cControle, 12, 3 )
	cRef      := SubStr( cControle, 15 )
	
	// Verifica se foi 'rollback' do arquivo Devolvido
	nPosVet := aScan( aArqRol, {|x| SubStr( x[1], 1, nPos ) == cControle } )
	If  nPosVet <> 0
		cStatus   := '20'
		cDataRef  := aArqRol[nPosVet][3]
		cHoraRef  := aArqRol[nPosVet][4]
		aAdd( aArqApagar, cControle+'.DEV' )
		aAdd( aArqApagar, cControle+'.ROL' )
	Else
		cStatus   := '10'
		cDataRef  := aArqDev[nI][3]
		cHoraRef  := aArqDev[nI][4]
	EndIf
	
	cHoraRef := StrZero( Val( SubStr( cHoraRef, 1, At( ':', cHoraRef )-1 ) ), 2 )+':'+StrZero( Val( SubStr( cHoraRef, At( ':', cHoraRef )+1, 2 ) ), 2 )
	
	dbSelectArea( 'UA5' )
	RecLock( 'UA5', !dbSeek( xFilial( 'UA5' )+cControle+cEmpRef+cFilRef ) )
	UA5->UA5_FILIAL := xFilial( 'UA5' )
	UA5->UA5_ARQUIV := cControle
	UA5->UA5_STATUS := cStatus
	UA5->UA5_EMPRES := cEmpRef
	UA5->UA5_CODFIL := cFilRef
	UA5->UA5_PACOTE := cPacote
	UA5->UA5_ORIGEM := cOrigem
	UA5->UA5_DESTIN := cDestino
	UA5->UA5_TABELA := cTabela
	UA5->UA5_REF    := cRef
	
	If      cStatus   == '10'
		UA5->UA5_DTDEV  := cDataRef
		UA5->UA5_HRDEV  := cHoraRef
		
	ElseIf  cStatus   == '20'
		UA5->UA5_DTROL  := cDataRef
		UA5->UA5_HRROL  := cHoraRef
		
	EndIf
	MsUnLock()
	
	If Len( aArqApagar ) > 0
		If u_ConexFTP()
			For nJ := 1 to Len( aArqApagar )
				//				cDirFTP := u_EmpFilDir( 'F', SubStr( aArqApagar[nJ], 8, 2 ), SubStr( aArqApagar[nJ], 10, 2 ), SubStr( aArqApagar[nJ], 4, 2 ), SubStr( aArqApagar[nJ], 6, 2 ) )
				If !u_EraseFTP( cDirFTP+aArqApagar[nJ] )
					u_MsgConMon( STR0006+cDirFTP+aArqApagar[nJ] ) //'Não Foi Possivel Apagar o Arquivo do FTP '
				EndIf
			Next
		Else
			u_MsgConMon( STR0007 ) //'Não Foi Possivel Fazer Conexao com FTP'
		EndIf
	EndIf
Next nI

Return NIL

/////////////////////////////////////////////////////////////////////////////