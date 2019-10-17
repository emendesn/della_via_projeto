#INCLUDE 'FSEA160.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA160  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para manutencao de Parametros de Configuracao       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FSEA160()
Local  oSay1, oSay2, oSay3
Local  aPara := {}

Public oDlg, oLbx, oConteudo, oDescric
Public cDescric  := ''
Public cConteudo := ''
Public aItLbx    := {}

aAdd( aPara, 'FS_CENTRA ' )
aAdd( aPara, 'FS_CHKINTE' )
aAdd( aPara, 'FS_DRFTPMV' )
aAdd( aPara, 'FS_DRLOCIN' )
aAdd( aPara, 'FS_DRLOCMV' )
aAdd( aPara, 'FS_DRREDMV' )
aAdd( aPara, 'FS_ESDRFTP' )
aAdd( aPara, 'FS_ESDRLOC' )
aAdd( aPara, 'FS_ESDRRED' )
aAdd( aPara, 'FS_FILIMP ' )
aAdd( aPara, 'FS_FTPPASS' )
aAdd( aPara, 'FS_FTPPORT' )
aAdd( aPara, 'FS_FTPSERV' )
aAdd( aPara, 'FS_FTPUSER' )
aAdd( aPara, 'FS_GERADWN' )
aAdd( aPara, 'FS_NUMTENT' )
aAdd( aPara, 'FS_PRTDDEV' )
aAdd( aPara, 'FS_QTMXFTP' )
aAdd( aPara, 'FS_RFSMON ' )
aAdd( aPara, 'FS_SEQEXP ' )
aAdd( aPara, 'FS_TIPVAL ' )
aAdd( aPara, 'FS_USAFTP ' )
aAdd( aPara, 'FS_VLDLOC ' )
aSort( aPara)

MsAguarde( { || RunForm( aPara ) }, 'Aguarde...', STR0001, .F. ) //'Carregando Parโmetros...'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao da Interface                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define Font oFontHighB Name 'Arial' Size 0, -14 Bold
Define Font oFontHigh  Name 'Arial' Size 0, -14
Define Font oFontBold  Name 'Arial' Size 0, -11 Bold
Define Font oFontNor   Name 'Arial' Size 0, -11

Define MSDialog oDlg From 0, 0 To 290, 590 Title STR0002 Pixel //'Parโmetros de Configura็ใo - Sincronia'

If ( Alltrim( GetTheme() ) == 'FLAT' ) .Or. SetMdiChild()                                         
	oDlg:oFont := oFontHigh 
Else
	oDlg:oFont := oFontHighB 
EndIf

@   5,  5 Say oSay1 Prompt STR0003 Font oFontHighB Size 40, 8  of oDlg Pixel //'Parโmetros'
@  15,  5 ListBox oLbx Fields Header STR0003 Size 80, 123 of oDlg Pixel On Change MontaTela() On DblClick Alteracao() //'Parโmetros'
oLbx:SetArray( aItLbx )
oLbx:bLine     := { || { aItLbx[oLbx:nAt][1]} }
oLbx:bGotFocus := { || MontaTela() }
oLbx:lHScroll  := .F.
oLbx:cToolTip  := STR0003 //'Parโmetros'
oLbx:Refresh()

@   5, 90 Say oSay2 Prompt STR0004  Font oFontHighB Size 60, 8  of oDlg Pixel //'Descri็ใo'
@  15, 90 Get oDescric Var cDescric Memo ReadOnly Message STR0005 Size 200, 90 of oDlg Pixel //'Conte๚do do Parโmetro'
oDescric:cToolTip := STR0006 //'Descri็ใo do Parโmetro'

@ 123, 90 To 139, 230 Design of oDlg Pixel
@ 114, 90 Say oSay3 Prompt STR0007   Font oFontHighB Size 95, 10 of oDlg Pixel //'Conte๚do'
@ 126, 93 MSGet oConteudo Var cConteudo Colors CLR_HRED ReadOnly NoBorder Font oFontHighB Size 135, 10 of oDlg Pixel
oConteudo:cToolTip := STR0005 //'Conte๚do do Parโmetro'


Define SButton From 125, 235 Type 5 Enable Action Alteracao() OnStop  STR0008   of oDlg Pixel //'Alterar Parโmetros'
Define SButton From 125, 265 Type 2 Enable Action oDlg:End()  OnStop  STR0009  of oDlg Pixel //'Sair'

Activate MSDialog oDlg Centered
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA160  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para troca de informacoes na tela                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Montatela()
cDescric  := aItLbx[oLbx:nAt][2]
cConteudo := aItLbx[oLbx:nAt][3]
oDescric:Refresh()
oConteudo:Refresh()
oDlg:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA160  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para alteracao de  Parametros de Configuracao       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Alteracao()
Local oDlgAlt    := NIL
Local cAlteracao := aItLbx[oLbx:nAt][3]
Local nOpc       := 0

Define MSDialog oDlgAlt From 0, 0 To 100, 350 Font oFontNor Title STR0010 + aItLbx[oLbx:nAt][1] Pixel //'Altera็ใo de Parโmetros - '
@   5,  5  Say STR0011 Size  80, 8 of oDlgAlt Pixel //'Novo Conte๚do'
@  15,  5  MSGet cAlteracao    Size 165, 10 of oDlgAlt Pixel
Define SButton From 35, 110 Type 1 Enable Action ( nOpc := 1, oDlgAlt:End() )  of oDlgAlt Pixel
Define SButton From 35, 140 Type 2 Enable Action oDlgAlt:End()  of oDlgAlt Pixel
Activate Dialog oDlgAlt Centered

If nOpc == 1
	PutMV( aItLbx[oLbx:nAt][1], cAlteracao )
	aItLbx[oLbx:nAt][3] := cAlteracao
	cConteudo := cAlteracao
	oConteudo:Refresh()
	oDlg:Refresh()
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA160  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Montagem do Vetor para ListBox                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunForm( aPara )
Local aArea     := GetArea()
Local aAreaSX6  := SX6->( GetArea() )
Local nI        := 0
Local lAchou    := .F.
Local cDescric  := ''
Local cConteudo := ''

SX6->( dbSetOrder( 1 ) )

For nI:= 1 To Len( aPara )
	
	lAchou := .F.
	
	If     SX6->( dbSeek( '  ' + aPara[nI] ) )
		lAchou := .T.
	ElseIf SX6->( dbSeek( cFilAnt + aPara[nI] ) )
		lAchou := .T.
	EndIf
	
	If lAchou
		#IFDEF SPANISH
			cDescric   := TrataDesc( SX6->X6_DESCSPA, SX6->X6_DSCSPA1, SX6->X6_DSCSPA2 )
			cConteudo  := SX6->X6_CONTSPA
		#ELSE
			#IFDEF ENGLISH
				cDescric   := TrataDesc( SX6->X6_DESCENG, SX6->X6_DSCENG1, SX6->X6_DSCENG2 )
				cConteudo  := SX6->X6_CONTENG
			#ELSE
				cDescric   := TrataDesc( SX6->X6_DESCRIC, SX6->X6_DESC1  , SX6->X6_DESC2   )
				cConteudo  := SX6->X6_CONTEUD
			#ENDIF
		#ENDIF
		
		aAdd( aItLbx, { SX6->X6_VAR, cDescric, cConteudo } )
	EndIf
	
Next

RestArea( aAreaSX6 )
RestArea( aArea    )
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA160  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tratamento da Descricao do Parametro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrataDesc( cDesc1, cDesc2, cDesc3 )
//Local cRet := ''
//Local aTXT := {}
/*
If Empty( SubStr( cDesc1, Len( cDesc1 ), 1 ) )
aTXT := JustificaTXT( cDesc1, 50 )
Else
aTXT := { cDesc1 }
EndIf
aEval( aTXT, { |y, x| cRet += aTXT[x] + CRLF } )

If Empty( SubStr( cDesc2, Len( cDesc2 ), 1 ) )
aTXT := JustificaTXT( cDesc2, 50 )
Else
aTXT := { cDesc2 }
EndIf
aEval( aTXT, { |y, x| cRet += aTXT[x] + CRLF } )

If Empty( SubStr( cDesc3, Len( cDesc3 ), 1 ) )
aTXT := JustificaTXT( cDesc3, 50 )
Else
aTXT := { cDesc3 }
EndIf
aEval( aTXT, { |y, x| cRet += aTXT[x] + CRLF } )
*/
Return cDesc1 + CRLF + cDesc2 + CRLF + cDesc3
//Return cDesc1 + Chr(13) + cDesc2 + Chr(13) + cDesc3

/////////////////////////////////////////////////////////////////////////////