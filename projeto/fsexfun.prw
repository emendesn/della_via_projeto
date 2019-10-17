#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FSEXFUN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �INFOSX2   �Autor  � Ernani Forastieri  � Data �  16/10/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna Informacoes do SX2                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function InfoSX2( cArq, nTipo )
Local aArea    := GetArea( )
Local aAreaSX2 := SX2->( GetArea( ) )
Local cRet     := ''

//��������������������������������������Ŀ
//� Parametro nTipo - Tipo da Informacao �
//�                                      �
//� 0 Path Completo                      �
//� 1 Path                               �
//� 2 Arquivo                            �
//� 3 Nome                               �
//� 4 Modo                               �
//����������������������������������������

cArq  := IIf( cArq  == NIL, Alias( ), cArq  )
nTipo := IIf( nTipo == NIL, 0       , nTipo )

If SX2->( dbSeek( cArq ) )
	If     nTipo == 0
		cRet := X2PATH( cArq )
		
	ElseIf nTipo == 1
		cRet := SX2->X2_PATH
		
	ElseIf nTipo == 2
		cRet := SX2->X2_ARQUIVO
		
	ElseIf nTipo == 3
		#IFDEF SPANISH
			cRet := SX2->X2_NOMESPA
		#ELSE
			#IFDEF ENGLISH
				cRet := SX2->X2_NOMEENG
			#ELSE
				cRet := SX2->X2_NOME
			#ENDIF
		#ENDIF
		
	ElseIf nTipo == 4
		cRet := SX2->X2_MODO
		
	EndIf
EndIf

RestArea( aAreaSX2 )
RestArea( aArea   )

Return AllTrim( cRet )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PRXEXEC  �Autor  � Ernani Forastieri  � Data �  16/10/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Calcula hora e data seguintes para uma data e hora         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PrxExec( dDiaIni, cHorIni, nInterval, cUnidade, lMinDia )
Local dDtPrx := CToD( '  /  /  ' )
Local cHrPrx := ''

dDiaIni  := IIf( dDiaIni   == NIL, Date( ), dDiaIni  )
cHorIni  := IIf( cHorIni   == NIL, Time( ), cHorIni  )
nInterval:= IIf( nInterval == NIL, 1     , nInterval )
cUnidade := IIf( cUnidade  == NIL, '1'   , cUnidade )
lMinDia  := IIf( lMinDia   == NIL, .T.   , lMinDia  )

If     cUnidade  == '1'  // Minutos
	cMinPrx := u_HoraToMin( cHorIni )+ nInterval
	cHrPrx  := u_MinToHora( cMinPrx )
	
	dDtPrx := dDiaIni
	
	If cHrPrx < cHorIni
		dDtPrx := dDiaIni + 1
	EndIf
	
ElseIf cUnidade  == '2'  // Horas
	cMinPrx := u_HoraToMin( cHorIni )+ ( nInterval * 60 )
	cHrPrx  := u_MinToHora( cMinPrx )
	
	dDtPrx := dDiaIni
	
	If cMinPrx > 1439 // Minutos Por Dia
		dDtPrx := dDiaIni + INT( cMinPrx / 1440 )
	EndIf
	
ElseIf cUnidade  == '3'  // Dias
	dDtPrx := dDiaIni + nInterval
	cHrPrx := cHorIni
	
ElseIf cUnidade  == '4'  // Semanas
	dDtPrx := dDiaIni + ( nInterval * 7 )
	cHrPrx := cHorIni
	
ElseIf cUnidade  == '5'  // Meses
	dDtPrx := CToD( StrZero( Day( dDiaIni ), 2 )+ '/' + Substr( DtoC( dDiaIni + ( nInterval * 30 )  ), 3 ) )
	cHrPrx := cHorIni
	
ElseIf cUnidade  == 'A'  // 1o. Dia Mes
	dDtPrx := FirstDay( dDiaIni )
	
	If dDtPrx <= Date( )
		dDtPrx := FirstDay( LastDay( dDtPrx )+1 )
	EndIf
	
	cHrPrx := cHorIni
	
ElseIf cUnidade  == 'B'  // Ult. Dia Mes
	dDtPrx := LastDay( dDiaIni )
	
	If dDtPrx <= Date( )
		dDtPrx := LastDay( dDtPrx+1 )
	EndIf
	
	cHrPrx := cHorIni
	
ElseIf cUnidade  == 'C'  // Todo dia X
	
	dDtPrx := CToD( StrZero( nInterval, 2 )+ SubStr( DToc( dDiaIni ), 3 ) )
	
	If dDtPrx <= Date( )
		dDtPrx := CToD( StrZero( nInterval, 2 )+ '/' + Substr( DtoC( LastDay( dDiaIni )+1 ), 3 ) )
	EndIf
	
	cHrPrx := cHorIni
	
EndIf

If lMinDia
	If DToS( dDtPrx )+cHrPrx < DToS( Date( ) )+SubStr( Time( ), 1, 5 )
		dDtPrx := Date( )
		cHrPrx := SubStr( Time( ), 1, 5 )
	EndIf
EndIf

aRet := { dDtPrx, cHrPrx }

Return aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �          �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte Hora Decimal em Horas Formatadas                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//�����������������������������������������Ŀ
//� Parametros                              �
//� nHorDec - Hora Decimal a ser convertida �
//�                                         �
//� Retorno                                 �
//� Valor no formato de horas ( texto )       �
//�������������������������������������������
//
User Function HoDecToHor( nHorDec )
Local cRet     := ''
Local nTotMin  := HoDecToMin( nHorDec )
Local nHoras   := INT( nTotMin/60 )
Local nMinutos := MOD( nTotMin, 60 )

cRet := StrZero( nHoras, Len( nHoras ) )+':'+StrZero( nMinutos, 2 )

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �          �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte Hora para Horas Decimais                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//����������������������������������������������������Ŀ
//� Parametros                                         �
//� nHoras - Hora a ser convertida para horas decimais �
//�                                                    �
//� Retorno                                            �
//� Valor decimal de horas                             �
//������������������������������������������������������
//
User Function HoToHorDec ( nHora )
Local cRet     := 0
Local nTotMin  := HoraToMin( nHora )
Local nHoras   := INT( nTotMin/60 )
Local nMinutos := MOD( nTotMin, 60 )

cRet := nHoras + nMinutos * ( 1/60 )

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �          �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte Hora Decimal em Minutos                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//�����������������������������������������Ŀ
//� Parametros                              �
//� nHorDec - Hora Decimal a ser convertida �
//�                                         �
//� Retorno                                 �
//� Quantidade de minutos equivalente       �
//�������������������������������������������
//
User Function HoDecToMin ( nHorDec )
Return nHorDec * 60


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �          �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte Hora em Minutos                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//��������������������������������������������������������������������Ŀ
//� Parametros                                                         �
//� xHoraToMi - Hora Decimal a ser convertida que pode ter os formatos �
//� 99.99 ou '99.99' ou '99:99'                                        �
//�                                                                    �
//� Retorno                                                            �
//� Quantidade de minutos equivalente                                  �
//����������������������������������������������������������������������
//
User Function HoraToMin ( xHoraToMi )
Local xHoraCon := xHoraToMi
Local nMinMar  := 0

Do Case
	
	Case ValType( 'xHoraCon' ) == 'N'
		nMinMar := INT( xHoraCon ) * 60
		nMinMar := nMinMar + ( xHoraCon - INT( xHoraCon ) ) * 100
		
	Case ValType( 'xHoraCon' ) == 'C'
		nHorCar := VAL( AllTrim( StrTran( xHoraCon, ':', '.' ) ) )
		nMinMar := INT( nHorCar ) * 60
		nMinMar := nMinMar + ( nHorCar - INT( nHorCar ) ) * 100
		
EndCase

Return nMinMar


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �          �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte Minutos em Horas                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//�������������������������������������������������������Ŀ
//� Parametros                                            �
//� nMinToHor - Quantidade de Minitos a converter         �
//� lHora     - Retorna valores apenas dentro de 24 horas �
//�                                                       �
//� Retorno                                               �
//� Hora em formato texto                                 �
//���������������������������������������������������������
User Function MinToHora ( nMinToHor, lHora24 )
Local nMinCon := nMinToHor
Local nHorInt := 0
Local cRet    := ''

lHora24  := IIf( lHora24  == NIL, .T., lHora24 )

nHorInt  := INT( nMinCon / 60 )
nMinInt  := MOD( nMinCon , 60 )

If lHora24
	If nHorInt > 23
		nHorInt  := nHorInt - ( INT( nHorInt / 24 ) * 24 )
	EndIf
EndIf

cRet     := StrZero( nHorInt, Max( 2, Len( Alltrim( Str( nHorInt ) ) ) ) )+':'+StrZero( nMinInt, 2 )

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �MYMAKEDIR �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para criacao de diretorios a partir do Root         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MyMakeDir( cDir )
Local cDirTrb   := cDir + IIf( SubStr( cDir, Len( cDir ), 1 ) <> '\', '\', '' )
Local cDirCriar := '\'
Local nPosBarra := 0

While Len( cDirTrb ) > 0
	nPosBarra := At( '\', cDirTrb )
	
	If nPosBarra > 2
		cDirCriar += SubStr( cDirTrb, 1, nPosBarra )
		MakeDir( cDirCriar )
	EndIf
	
	cDirTrb := SubStr( cDirTrb, nPosBarra+1 )
End

Return NIL



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �MsgConMon �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para gerar mensagem no console e no monitor do      ���
���          � sistema                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MsgConMon( cMsg, lFrame )
Local nTamBarr := 79
Local nTamUtil := 75
Local nTamMens := 0
Local cStamp   := ''
Local nLinhas  := 0
Local nZ       := 0

cMsg     := IIf( cMsg   == NIL, '', cMsg )
lFrame   := IIf( lFrame == NIL, .T., lFrame )
nTamMens := Len( cMsg )

nLinhas  := Int( nTamMens/75 )+ IIf( Mod( nTamMens, 75 ) == 0, 0, 1 )
cStamp   := ProcName( 1 )
cStamp   := '['+IIf( SubStr( cStamp, 1, 2 ) $ 'u_/U_', SubStr( cStamp, 3 ), cStamp )+ ' ' + SubStr( DtoC( Date( ) ), 1, 5 )+' ' + SubStr( Time( ), 1, 5 )+']'


If lFrame
	ConOut( PadC( ' '+cStamp+' ', nTamBarr, '*' ) )
	If nTamMens <= nTamUtil
		ConOut( '* '+PadR( cMsg, nTamUtil )+' *' )
	Else
		For nZ := 1 to nLinhas
			ConOut( '* '+SubStr( PadR( cMsg, nTamUtil ), 1, nTamUtil )+' *' )
			cMsg := LTrim( SubStr( cMsg, nTamUtil+1 ) )
		Next
	EndIf
	ConOut( PadC( '', nTamBarr, '*' ) )
	ConOut( ' ' )
Else
	ConOut( '* '+cStamp+' '+cMsg )
EndIf

PtInternal( 1, cMsg )

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �EmpFilDir �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para retornar diretorios de trabalho                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EmpFilDir( cRef, cEmpr, cFili, lUsaFTP )
//�����������������������������������������������������������������������Ŀ
//� Parametros                                                            �
//� cRef - Referencia                                                     �
//� 	L - Traz o Diretorio Local                                        �
//� 	F - Traz o Diretorio FTP se usar FTP                              �
//� 	    Traz o Drive Fisico na Rede se nao usar                       �
//�                                                                       �
//�cEmpr - Empresa para qual montar o nome, se omitido pega SM0           �
//�cFili - Filial  para qual montar o nome, se omitido pega SM0           �
//�������������������������������������������������������������������������
//
Local aArea       := GetArea( )
Local aAreaSX6    := SX6->( GetArea( ) )
Local cRet        := ''
Local cBarraFinal := '\' // IIf( IsSrvUnix(), '/', '\' )

cRef    := IIf( cRef  == NIL, 'L' , cRef )
cEmpr   := IIf( cEmpr == NIL, SM0->M0_CODIGO, cEmpr )
cFili   := IIf( cFili == NIL, SM0->M0_CODFIL, cFili )
lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP', , .T. ), lUsaFTP )  // Usa FTP

// Diretorio de FTP ou Rede
If cRef == 'F'
	If lUsaFTP
		cRet := StrTran( StrTran( GetMV( 'FS_ESDRFTP', , '/EMP##/FIL@@/' ), '##', cEmpr ), '@@', cFili )
		cRet += IIf( SubStr( cRet, Len( cRet ), 1 ) <> '/', '/', '' )
	Else
		cRet := StrTran( StrTran( GetMV( 'FS_ESDRRED', , '\SINCRON\EMP##\FIL@@\' ), '##', cEmpr ), '@@', cFili )
		cRet += IIf( SubStr( cRet, Len( cRet ), 1 ) <> cBarraFinal, cBarraFinal, '' )
	EndIf
EndIf

// Diretorio Local
If cRef == 'L'
	cRet   := StrTran( StrTran( GetMV( 'FS_ESDRLOC', , '\SINCRON\EMP##\FIL@@\' ), '##', cEmpr ), '@@', cFili )
	cRet   += IIf( SubStr( cRet, Len( cRet ), 1 ) <> '\', '\', '' )
EndIf

RestArea( aAreaSX6 )
RestArea( aArea )

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �PegaCpo   �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para retornar o conteudo de um campos de desposicio-���
���          � nar a tabela                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PegaCpo( cAlias, nOrdem, cChave, cCpo )
//
// Foi Criada esta funcao pois as funcoes FbuscaCpo e Posicione,
// reposicionam o arquivo definido em cAlias, esta funcao nao.
//
Local aArea     := GetArea( )
Local aAreaAlia := {}
Local cRet      := ''

cAlias := IIf( cAlias == NIL, Alias( ), cAlias )
nOrdem := IIf( nOrdem == NIL, ( cAlias )->( IndexOrd( ) ), nOrdem )
cChave := IIf( cChave == NIL, ( cAlias )->( IndexKey( ) ), cChave )

dbSelectArea( cAlias )
aAreaAlia := ( cAlias )->( GetArea( ) )
dbSetOrder( nOrdem )
dbSeek( cChave )

cRet := &( cCpo )

RestArea( aAreaAlia )
RestArea( aArea )
Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �InicUA8   �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para inicializacao do conteudo da tabela UA8        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function InicUA8( )
Local aArea     := GetArea( )
Local aDadosUA8 := {}
Local nI        := 0
dbSelectArea( 'UA8' )

If UA8->( RecCount( ) ) == 0
	aAdd( aDadosUA8, { '10', 'BR_VERMELHO', STR0001} ) //'Devolvido pelo Destino'
	aAdd( aDadosUA8, { '20', 'BR_PRETO'   , STR0002} ) //'Flag de Exportacao Desfeito'
	aAdd( aDadosUA8, { '60', 'BR_AZUL'    , STR0003} ) //'Exportado e Aguardando'
	aAdd( aDadosUA8, { '70', 'BR_AMARELO' , STR0004} ) //'Feito Download para Importacao'
	aAdd( aDadosUA8, { '80', 'BR_VERDE'   , STR0005} ) //'Importado com Sucesso'
	aAdd( aDadosUA8, { '90', 'BR_LARANJA' , STR0006} ) //'Devolvido para a Origem'
	//	aAdd( aDadosUA8, { '99', 'BR_MARRON'  , STR0009} ) //'Problemas c/arquivo movimento'
	
	For nI := 1 To Len( aDadosUA8 )
		RecLock( 'UA8', .T. )
		UA8->UA8_FILIAL  := xFilial( 'UA8' )
		UA8->UA8_STATUS  := aDadosUA8[nI][1]
		UA8->UA8_COR     := aDadosUA8[nI][2]
		UA8->UA8_DESC    := aDadosUA8[nI][3]
		//		UA8->UA8_MSEXP   := DtoS( Date( ) )
		MsUnlock( )
	Next
EndIf

RestArea( aArea )
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �ConexFTP  �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para conexao com Servidor FTP atravez de parametros ���
���          � definidos, ou verificacao de conexao com link              ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//������������������������������������������������Ŀ
//� Parametros                                     �
//� cFTPServ - Nome do Servidor FTP                �
//� cFTPPort - Porta para acesso ao Servidor FTP   �
//� cFTPUser - Usuario para acesso ao Servidor FTP �
//� cFTPPass - Senha para acesso ao Servidor FTP   �
//� cDirRede - Diretorio de Tranmissao na rede     �
//��������������������������������������������������
//
User Function ConexFTP( cFTPServ, cFTPPort, cFTPUser, cFTPPass, nTenta, lUsaFTP, cDirRede )
Local aArea    := GetArea( )
Local aAreaSX6 := SX6->( GetArea( ) )
Local lRet     := .T.
Local nX       := 0
Local nHandle  := -1
Local cAux     := 0

lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP', , .T. ), lUsaFTP )  // Usa FTP

If lUsaFTP
	
	//���������������������������������������Ŀ
	//� Tratamento utilizando FTP             �
	//�����������������������������������������
	
	cFTPServ := IIf( cFTPServ == NIL, GetMV( 'FS_FTPSERV', , '' ) , cFtpServ )  // Servidor FTP
	cFTPPort := IIf( cFTPPort == NIL, GetMV( 'FS_FTPPORT', , 21 ) , cFtpPort )  // Porta    FTP
	cFTPUser := IIf( cFTPUser == NIL, GetMV( 'FS_FTPUSER', , '' ) , cFtpUser )  // Usuario  FTP
	cFTPPass := IIf( cFTPPass == NIL, GetMV( 'FS_FTPPASS', , '' ) , cFtpPass )  // Senha    FTP
	nTenta   := IIf( nTenta   == NIL, GetMV( 'FS_NUMTENT', , 10 )  , nTenta  )  // Tentativas
	
	FTPDisconnect( )
	
	For nX := 1 To nTenta
		If FTPConnect( cFTPServ, cFTPPort, cFTPUser, cFTPPass )
			//		If GetMV( 'FS_FTPMPAS', , .F. )
			FTPSetPasv( .T. )
			//		EndIf
			lRet  := .T.
			Exit
		EndIf
		
		u_MsgConMon( STR0010 + Alltrim( Str( nX, 2 ) ) + STR0011 ) //'Falhou '###'a. tentativa de conecao com FTP'
		
		Sleep( 5000 )
	Next
	
Else
	//���������������������������������������Ŀ
	//� Tratamento utilizando drives fisicos  �
	//�����������������������������������������
	
	// A ideia e tentar criar um arquivo no diretorio,
	// se criar esta funcionando o Link
	//
	
	cDirRede := IIf( cDirRede == NIL, GetMV( 'FS_DRREDMV', , '' ) , cDirRede )  // Diretorio Tranmissao na Rede
	
	// If !File( cDirRede )
	//     u_MyMakeDir( cDirRede )
	// EndIf
	
	cAux     := cDirRede + CriaTrab( , .F. ) + cEmpAnt + cFilAnt
	nHandle  := MSFCreate( AllTrim( cAux ) )
	
	If nHandle < 0
		lRet := .F.
	Else
		FClose( nHandle )
		FErase( cAux )
	EndIf
	
EndIf

RestArea( aAreaSX6 )
RestArea( aArea )

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �DESCONXFTP�Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para des conexao com Servidor FTP                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DesConxFTP( lUsaFTP )
Local lRet := .T.

lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP', , .T. ), lUsaFTP )  // Usa FTP

If lUsaFTP
	FtpDisconnect( )
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � DIRCHAFTP�Autor  � Ernani Forastieri  � Data �  13/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para trocar diretorio no FTP ou na Rede             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DirChaFTP( cDirFTP, lUsaFTP )
Local lRet := .T.

lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP', , .T. ), lUsaFTP )  // Usa FTP

If lUsaFTP
	lRet := FTPDirChange( cDirFTP )
EndIF

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � DIRCHAFTP�Autor  � Ernani Forastieri  � Data �  13/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para ler arquivos diretorio no FTP ou na Rede       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DirecFTP( cMascara, cDirFTP, lUsaFTP )
Local aRet    := {}

lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP', , .T. ), lUsaFTP )  // Usa FTP
cDirFTP := IIf( cDirFTP == NIL, '', cDirFTP )

If lUsaFTP
	aRet := FtpDirectory( cMascara )
Else
	cDirFTP += IIf( SubStr( cDirFTP, Len( cDirFTP ), 1 ) <> '\', '\', '' )
	aRet    := Directory( cDirFTP + cMascara )
EndIf
Return aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � DIRCHAFTP�Autor  � Ernani Forastieri  � Data �  13/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para apagar arquivos no FTP ou na Rede              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EraseFTP( cArq, lUsaFTP )
Local lRet := .T.

lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP', , .T. ), lUsaFTP )  // Usa FTP

If lUsaFTP
	lRet := FTPErase( cArq )
Else
	lRet := ( FErase( cArq ) == 0 )
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �UPLOADFTP �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para fazer Upload de arquivo para o Servidor FTP    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UpLoadFTP( cArqLocal, cArqFTP, nTenta, lUsaFTP )
Local lRet      := .F.
Local nX        := 0
Local cMsg      := ''
Local cArqZIP   := ''
Local aArqZIP   := {}
Local cExtRDD   := Upper( GetDBExtension( ) )
Local cExtLoc   := Upper( u_PegaExt( cArqLocal ) )
Local cExtZIP   := IIf( cExtLoc == '.DDV', '.DZP', '.MZP' )
Local lCompacta := ( cExtLoc $ cExtRDD + '/.TXT/.DDV' )
//Local lAux      := .T.

nTenta  := IIf( nTenta  == NIL, GetMV( 'FS_NUMTENT', , 10 ), nTenta  )  // Tentativas
lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP', , .T. ), lUsaFTP )  // Usa FTP

// Arquivos .DBF, .DTC, .TXT e .DDV serao compactados no FTP
// alem do .FPT que os acompanha se existir

If lCompacta
	cArqZIP   := u_TrocaExt( cArqLocal, cExtZIP )
	cArqFPT   := u_TrocaExt( cArqLocal, '.FPT' )
	
	aAdd( aArqZIP, cArqLocal )
	
	// Pega o arquivo FPT que acompanha o DBF se existir
	If cExtRDD == '.DBF' .and. File( cArqFPT )
		aAdd( aArqZIP, cArqFPT )
	EndIf
	
	If Empty( MSCompress( aArqZIP, cArqZip ) )
		cMsg := STR0007+cArqLocal //'Nao foi possivel compactar o arquivo '
		MsgConMon( cMsg, .T. )
		Return lRet
	EndIf
	
	cArqLocal := u_TrocaExt( cArqLocal, cExtZIP )
	cArqFTP   := u_TrocaExt( cArqFTP  , cExtZIP )
EndIf

If lUsaFTP
	//���������������������������������������Ŀ
	//� Tratamento utilizando FTP             �
	//�����������������������������������������
	
	// Sobe para FTP tenta n Vezes
	FTPSetPasv( .T. )
	For nX := 1 To nTenta
		If FTPUpLoad( cArqLocal, cArqFTP )
			lRet  := .T.
			
			If lCompacta
				FErase( cArqLocal )
			EndIf
			
			Exit
		EndIf
		
		FTPDisconnect( )
		u_MsgConMon( STR0010+Alltrim( Str( nX, 2 ) )+ STR0012 + cArqFTP ) //'Falhou'###'a. tentativa de upload '
		Sleep( 5000 )
		
		If u_ConexFTP( )
			u_MsgConMon( STR0013+cArqFTP, .F. ) //'Reconectou apos falha de upload '
		Else
			u_MsgConMon( STR0014+cArqFTP ) //'Nao conectou apos falha de upload '
		EndIf
		
	Next
	
Else
	//���������������������������������������Ŀ
	//� Tratamento utilizando drives fisicos  �
	//�����������������������������������������
	
	lRet := .F.
	For nX := 1 To nTenta
		// Copia tenta n Vezes
		If __CopyFile(  cArqLocal, cArqFTP )
			lRet := .T.
			
			If lCompacta
				//		FErase( cArqLocal )
			EndIf
			
			Exit
		EndIf
	Next
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �DWLOADFTP �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para fazer DownLoad de arquivo do  Servidor FTP     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DwLoadFTP( cArqLocal, cArqFTP, nTenta, lUsaFTP )
Local lRet      := .F.
Local nX        := 0
Local cMsg      := ''
Local cPathLocal:= ''
Local cExtRDD   := Upper( GetDBExtension( ) )
Local cExtLoc   := Upper( u_PegaExt( cArqLocal ) )
Local cExtZIP   := IIf( cExtLoc == '.DDV', '.DZP', '.MZP' )
Local lDeCompac := ( cExtLoc $ cExtRDD+'/.TXT/.DDV' )

nTenta  := IIf( nTenta  == NIL, GetMV( 'FS_NUMTENT',, 10 ) , nTenta  )  // Tentativas
lUsaFTP := IIf( lUsaFTP == NIL, GetMV( 'FS_USAFTP' ,, .T. ), lUsaFTP )  // Usa FTP


// Arquivos .DBF e .DDV estao compactados no FTP

If File( cArqLocal )
	FErase( cArqLocal )
EndIf

If lDeCompac
	cPathLocal:= u_PegaPath( cArqLocal )
	cArqLocal := u_TrocaExt( cArqLocal, cExtZIP )
	cArqFTP   := u_TrocaExt( cArqFTP  , cExtZIP )
	
	If File( cArqLocal )
		FErase( cArqLocal )
	EndIf
EndIf

If lUsaFTP
	FTPSetPasv( .T. )
	For nX := 1 To nTenta
		If FTPDownLoad( cArqLocal, cArqFTP )
			lRet  := .T.
			Exit
		EndIf
		
		FTPDisconnect( )
		u_MsgConMon( STR0010+Alltrim( Str( nx, 2 ) )+ STR0016 + cArqFTP ) //'Falhou '###'a. tentativa de download '
		Sleep( 5000 )
		
		If u_ConexFTP( )
			u_MsgConMon( STR0013+cArqFTP, .F. )		 //'Reconectou apos falha de upload '
		Else
			u_MsgConMon( STR0017+cArqFTP ) //'Nao conectou apos falha de download '
		EndIf
	Next
Else
	For nX := 1 To nTenta
		If __CopyFile( cArqFTP, cArqLocal )
			lRet  := .T.
			Exit
		EndIf
	Next
	
EndIf

If lDeCompac .and. lRet
	If !MsDeComp( cArqLocal, cPathLocal )
		cMsg := STR0008+cArqZIP //'Nao foi possivel descompactar o arquivo '
		MsgConMon( cMsg, .T. )
		lRet  := .F.
	Else
		FErase( cArqLocal )
	EndIf
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �PEGAFILE  �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para retorna o nome do arquivo e extensao            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PegaFile( cNomeArq )
Local cRet := '', nPos
If cNomeArq <> NIL
	if ( nPos := Len( u_PegaPath( cNomeArq ) ) ) > 0
		cRet := SubStr( cNomeArq, nPos +1, Len( cNomeArq ) )
	Else
		cRet := cNomeArq
	End
End

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �PEGAPATH  �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para retorna o Path do arquivo informado             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PegaPath( cNomeArq )
Local cRet := '', nPos
If cNomeArq <> NIL
	If ( nPos := Rat( '\', cNomeArq ) ) > 0
		cRet := SubStr( cNomeArq, 1, nPos )
	End
End
Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �PEGAEXT   �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para retornar a extensao de um arquivo               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PegaExt( cNomeArq )
Local cRet := '', nPos
If cNomeArq <> NIL
	If ( nPos := At( '.', cNomeArq ) ) > 0
		cRet := SubStr( cNomeArq, nPos, Len( cNomeArq ) )
	End
End
Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �TROCAEXT  �Autor  � Ernani Forastieri  � Data �  02/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para troca de Extensao de um arquivo                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TrocaExt( cNomeArq, cNovaExt )       
Local nPos := 0
If cNomeArq <> NIL .And. cNovaExt <> NIL
	cNomeArq := AllTrim( cNomeArq )
	If ( nPos := RAt( '.', cNomeArq ) ) > 0
		cNomeArq := Left( cNomeArq, nPos - IIf( At( '.', cNovaExt ) > 0, 1, 0 ) ) + cNovaExt
	Else
		cNomeArq += cNovaExt
	End
End
Return cNomeArq


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � AvaliaFor�Autor  � Ernani Forastieri  � Data �  10/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Generica validar formular                           ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AvaliaFor( cForm )
Local bBlock := ErrorBlock( { |e| ChecErro( e ) } )
Local uRet   := NIL

cForm := Upper( AllTrim( cForm ) )

Begin Sequence
//If !( 'EXECBLOCK' $ cForm )   // Nao avalia EXECBLOCK
uRet := &cForm
//EndIf
End Sequence
ErrorBlock( bBlock )

Return uRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � CHECERRO �Autor  � Ernani Forastieri  � Data �  10/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Generica para erro na formula                       ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ChecErro( e )
If e:GenCode > 0
	Help( ' ', 1, 'ERR_FORM', , e:Description, 3, 1 )
EndIf
Break
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � SX3CPOVAL�Autor  � Ernani Forastieri  � Data �  20/01/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para validacao de campo no SX3                      ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SX3CpoVal( cCampo )
Local lRet     := .F.
Local aArea    := GetArea( )
Local aAreaSX3 := SX3->( GetArea( ) )

dbSelectArea( 'SX3' )
dbSetOrder( 2 )
If dbSeek( cCampo )
	lRet     := .T.
Else
	Help( ' ', 1, 'EXISTCPO' )
EndIf

RestArea( aAreaSX3 )
RestArea( aArea   )

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � EVERCHAR �Autor  � Ernani Forastieri  � Data �  13/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao auxiliar para transformar um campo de qualquer tipo ���
���          � em caracter                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EverChar( uCpoConver )
Local cRet  := NIL
Local cTipo := ""

cTipo := ValType( uCpoConver )

If     cTipo == "C"                    // Tipo Caracter
	cRet := uCpoConver
	
ElseIf cTipo == "N"                    // Tipo Numerico
	cRet := AllTrim( Str( uCpoConver ) )
	
ElseIf cTipo == "L"                    // Tipo Logico
	cRet := IIf( uCpoConver, "T", "F" )
	
ElseIf cTipo == "D"                    // Tipo Data
	cRet := DToC( uCpoConver )
	
ElseIf cTipo == "M"                    // Tipo Memo
	cRet := "MEMO"
	
ElseIf cTipo == "A"                    // Tipo Array
	cRet := "ARRAY[" + AllTrim( Str( Len( uCpoConver ) ) ) + "]"
	
ElseIf cTipo == "U"                    // Indefinido
	cRet := "NIL"
	
EndIf

Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � CARACEQ  �Autor  � Ernani Forastieri  � Data �  13/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao auxiliar para retornar caracter Alfa equivalente    ���
���          � a um numero                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CaracEq( nNumero )
//                      1         2         3
//             123456789012345678901234567890123456    
Local cLit := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
Local cRet := ''
                                       
If nNumero > 0 .and. nNumero < 37
	cRet := SubStr( cLit, nNumero, 1 )
EndIf

Return cRet

/////////////////////////////////////////////////////////////////////////////