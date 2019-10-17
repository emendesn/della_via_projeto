#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'COLORS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � DelC004  �Autor  � Ernani Forastieri  � Data �  28/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para Consulta de Dados Historicos de Clientes       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�cCodCli   = Codigo do cliente                               ���
���          �cLojCli	= Loja do cliente                                 ���
���          �lSoVisual = Forca a GetDados a ser apenas visual            ���
���          �            lSoVisual = .T. (Getdados somente Visual)       ���
���          �            lSoVisual = .F. ou Nil (Getdados respeita a     ���
���          �            regra da tela que esta chamando a DELC004,      ���
���          �            podendo ser Altera ou Visual).                  ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada nos progrmas:                             ���
���          � - CRDLIBCR    (Botao na tela de Avaliacao de Credito)      ���
���          � - CRDCRIABUT  (Botao na tela de cadastro de clientes do    ���
���          �                SIGACRD)                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���Marcelo   �17/02/06�      �- Inclus�o de filtro para nao considerar os ���
���Gaspar    �        �      �  Titulos de NCC nas selects de Titulos     ���
���          �        �      �  Vencidos, Tit.Pagos com atraso e          ���
���          �        �      �  Titulos a Vencer.                         ���
�������������������������������������������������������������������������͹��
���Marcio    �06/09/06�      �- Retirados comandos de controle de transa- ���
���Domingos  �        �      �  cao para, para compatibiliza��o de outras ���
���          �        �      �  rotinas.                                  ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Project Function DelC004( cCodCli, cLojCli, lSoVisual )

Local aArea       := GetArea()
Local aAreaSA1    := SA1->( GetArea() )
Local aAreaSX3    := SX3->( GetArea() )


#IFDEF TOP
	MsAguarde( { || RunProc( cCodCli, cLojCli, lSoVisual ) }, "Aguarde...", "Rastreando Informa��es...", .F. )
#ELSE
	ApMsgStop( 'Esta funcionalidade est� dispon�vel apenas para instal��es Protheus com banco de dados', 'ATEN��O' )
#ENDIF

RestArea( aAreaSX3 )
RestArea( aAreaSA1 )
RestArea( aArea )

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � RUNPROC  �Autor  � Ernani Forastieri  � Data �  28/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de Processamento                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc( cCodCli, cLojCli, lSoVisual )
Local aAreaSA1    := SA1->( GetArea() )
Local cNomeCli    := ''
Local dUltCom     := CToD( '  /  /  ' )
Local nVlUltCom   := 0
Local dMaiorCom   := CToD( '  /  /  ' )
Local nMaiorCom   := 0
Local nMaiorAcu   := 0
Local dLimCred    := CToD( '  /  /  ' )
Local dCliente    := CToD( '  /  /  ' )
Local nVlLimCred  := 0
Local nTotSalDev  := 0
Local nSalDispo   := 0
Local nChqDevol   := 0
Local nLucPerdas  := 0
Local nTitProt    := 0
Local nTitNegat   := 0
Local nNotaDeb    := 0
Local nTitVenc    := 0
Local nTitNCC     := 0
Local nChqPre     := 0
Local nTitVinc    := 0
Local nPagCart    := 0
Local nQChqDevol  := 0
Local nTitNegProt := 0
Local nTitBxaPerd := 0
Local nTitPgoAtra := 0
Local nMediaAtra  := 0
Local nRecCobExt  := 0
Local nPedAberto  := 0
Local nTitAberto  := 0
Local lOpca       := .F.
Local aColsPAJ    := {}
Local aHeaderPAJ  := {}
Local aNaoExibe   := {'PAJ_CLIENT', 'PAJ_LOJA' }
Local nX          := 0
Local nI          := 0
Local nUsado      := 0
Local nOpc        := 3
Local nOpcGd      := 0 // opcao da newgetdados
//Anderson // Array que conterea o retorno da funcao de projeto RetStatFin, a qual retorna conteudo para
// diversos campos da tela de historicos.
Local _aRetStFin
Local npDesc      := 0
Local aButtons    := {} // Botoes Adicionais da EnchoiceBar
Local aUsButtons  := {}

Private nQtItExist   := 0


cCodCli   := IIf( cCodCli == NIL, SA1->A1_COD , cCodCli )
cLojCli   := IIf( cLojCli == NIL, SA1->A1_LOJA, cLojCli )
lSoVisual := IIf( lSoVisual == NIL, .F., lSoVisual )

cCodCli +=  Replicate( ' ', TamSX3('A1_COD')[1] - Len( cCodCli ) )
cLojCli +=  Replicate( ' ', TamSX3('A1_LOJA')[1] - Len( cLojCli ) )

//���������������������������������������������������������������������Ŀ
//� Posicionando Cliente                                                �
//�����������������������������������������������������������������������
SA1->(DbSetOrder(1))

If !SA1->( dbSeek( xFilial( 'SA1' ) + cCodCli + cLojCli )  )
	ApMsgStop( 'Cliente n�o encontrado ou em branco', 'ATEN��O' )
	Return .F.
EndIf


cNomeCli    := SA1->( AllTrim( A1_COD ) + ' ' + A1_LOJA  + ' - ' + AllTrim( A1_NOME )  ) + ;
IIf( !Empty( SA1->A1_MUN ) .AND. !Empty( SA1-> A1_EST  ) , ' - ' + SA1->( AllTrim( A1_MUN - '/' - A1_EST  ) ), '' )

dUltCom     := SA1->A1_ULTCOM

dMaiorCom   := CToD( '  /  /  ' )
nMaiorCom   := SA1->A1_MCOMPRA
nMaiorAcu   := SA1->A1_MSALDO
dCliente    := SA1->A1_PRICOM
dLimCred    := SA1->A1_VENCLC
nVlLimCred  := SA1->A1_LC
nTotSalDev  := CrdTitAberto( cCodCli, cLojCli, 2 )
nSalDispo   := SA1->A1_LC - nTotSalDev

nChqDevol   := SA1->A1_CHQDEVO
nLucPerdas  := 0
nTitProt    := 0
nTitNegat   := 0   // A Definir
nNotaDeb    := 0   // A Definir
nTitVinc    := 0
nPagCart    := 0
nQChqDevol  := 0
nTitNegProt := 0   // A Definir
nTitBxaPerd := 0   // A Definir

nMediaAtra  := SA1->A1_METR
nRecCobExt  := 0   // A Definir


//��������������������������������������������������������������Ŀ
//� Avalia botoes do usuario                                     �
//����������������������������������������������������������������
If ExistBlock( 'BUTC004' )
	If ValType( aUsButtons := ExecBlock( 'BUTC004', .F., .F. ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
	EndIf
EndIf

//���������������������������������������������������������������������Ŀ
//� Valor e Data da Maior Compra                                        �
//�����������������������������������������������������������������������
cQuery := "SELECT F2_EMISSAO, F2_VALFAT FROM " + RetSqlName('SF2')
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND F2_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND F2_LOJA    = '" + cLojCli + "' "
cQuery += "   AND F2_VALFAT > 0 "
cQuery += " ORDER BY F2_VALFAT DESC "
cQuery += " FETCH FIRST 1 ROWS ONLY "

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRAB", .T., .T.)
dMaiorCom := StoD(TRAB->F2_EMISSAO)
nMaiorCom := TRAB->F2_VALFAT

TRAB->( dbCloseArea() )


//���������������������������������������������������������������������Ŀ
//� Valor e data da Ultima Compra                                       �
//�����������������������������������������������������������������������
cQuery := "SELECT F2_VALFAT, F2_EMISSAO FROM " + RetSqlName('SF2')
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND F2_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND F2_LOJA    = '" + cLojCli + "' "
cQuery += "   AND F2_VALFAT > 0 "
cQuery += " ORDER BY F2_EMISSAO DESC "
cQuery += " FETCH FIRST 1 ROWS ONLY "

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nVlUltCom := TRAB->F2_VALFAT
dUltCom   := StoD(TRAB->F2_EMISSAO)

TRAB->( dbCloseArea() )


//���������������������������������������������������������������������Ŀ
//� Total de Credito (Titulos de NCC em aberto)                         �
//�����������������������������������������������������������������������
cQuery := "SELECT SUM( E1_SALDO ) AS TITNCC FROM " + RetSqlName( 'SE1' )
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND E1_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND E1_LOJA    = '" + cLojCli + "' "
cQuery += "   AND E1_NUMLIQ  = '" + Space( TamSX3('E1_NUMLIQ')[1] ) + "' "
cQuery += "   AND E1_TIPO    = 'NCC' "
cQuery += "   AND E1_SALDO   > 0 "

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nTitNCC    := TRAB->TITNCC

TRAB->( dbCloseArea() )




//���������������������������������������������������������������������Ŀ
//� Titulos Vencidos                                                    �
//�����������������������������������������������������������������������
cQuery := "SELECT SUM( E1_SALDO ) AS TITVENC FROM " + RetSqlName( 'SE1' )
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND E1_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND E1_LOJA    = '" + cLojCli + "' "
cQuery += "   AND E1_NUMLIQ  = '" + Space( TamSX3('E1_NUMLIQ')[1] ) + "' "
cQuery += "   AND E1_TIPO    <> 'PR ' "
cQuery += "   AND E1_TIPO    <> 'NCC' "
cQuery += "   AND E1_TIPO NOT IN " + FormatIn( MVABATIM, '|')
cQuery += "   AND E1_VENCREA < '" + DtoS(dDataBase) + "' "
cQuery += "   AND E1_SALDO   > 0 "

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nTitVenc    := TRAB->TITVENC

TRAB->( dbCloseArea() )


//���������������������������������������������������������������������Ŀ
//� Titulos Pagos Com Atraso                                            �
//�����������������������������������������������������������������������
cQuery := "SELECT COUNT( * ) AS TITPGOATRA FROM " + RetSqlName( 'SE1' )
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND E1_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND E1_LOJA    = '" + cLojCli + "' "
cQuery += "   AND E1_NUMLIQ  = '" + Space( TamSX3('E1_NUMLIQ')[1] ) + "' "
cQuery += "   AND E1_TIPO    <> 'PR ' "
cQuery += "   AND E1_TIPO    <> 'NCC' "
cQuery += "   AND E1_TIPO NOT IN " + FormatIn( MVABATIM, '|')
cQuery += "   AND E1_SALDO   = 0 "
cQuery += "   AND E1_BAIXA   > E1_VENCREA "

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nTitPgoAtra := TRAB->TITPGOATRA

TRAB->( dbCloseArea() )


//���������������������������������������������������������������������Ŀ
//� Cheques Pre                                                         �
//�����������������������������������������������������������������������
/*
cQuery := "SELECT SUM( EF_VALOR ) AS CHQPRE  FROM " + RetSqlName( 'SEF' )
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND EF_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND EF_LOJACLI = '" + cLojCli + "' "
cQuery += "   AND EF_CART    = 'R' "
cQuery += "   AND EF_VENCTO  > EF_DATA "

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nChqPre := TRAB->CHQPRE

TRAB->( dbCloseArea() )


cQuery := "SELECT SUM( E1_SALDO ) AS CHQPRE  FROM " + RetSqlName( 'SE1' )
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND E1_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND E1_LOJA    = '" + cLojCli + "' "
cQuery += "   AND E1_TIPO    = 'CH ' "
cQuery += "   AND E1_VENCREA >= '" + DtoS(dDataBase) + "'"
*/

nChqPre := 0

cQuery := "SELECT SUM( E1_SALDO ) AS CHQPRE  FROM " + RetSqlName( 'SE1' )
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND E1_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND E1_LOJA    = '" + cLojCli + "' "
cQuery += "   AND E1_TIPO    = 'CH ' "
cQuery += "   AND E1_EMISSAO <> E1_VENCTO "
cQuery += "   AND E1_SALDO > 0 "

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nChqPre += TRAB->CHQPRE

TRAB->( dbCloseArea() )



//���������������������������������������������������������������������Ŀ
//� Titulos a vencer                                                    �
//�����������������������������������������������������������������������
cQuery := "SELECT SUM( E1_SALDO ) AS TITVINC FROM " + RetSqlName( 'SE1' )
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += "   AND E1_CLIENTE = '" + cCodCli + "' "
cQuery += "   AND E1_LOJA    = '" + cLojCli + "' "
cQuery += "   AND E1_NUMLIQ  = '" + Space( TamSX3('E1_NUMLIQ')[1] ) + "' "
cQuery += "   AND E1_TIPO    <> 'PR ' "
cQuery += "   AND E1_TIPO    <> 'NCC' "
cQuery += "   AND E1_TIPO NOT IN " + FormatIn( MVABATIM, '|')
cQuery += "   AND E1_TIPO    <> 'CH ' "
cQuery += "   AND E1_VENCREA >= '" + DtoS(dDataBase) + "'"

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nTitVinc := TRAB->TITVINC - nTitNCC

TRAB->( dbCloseArea() )

//���������������������������������������������������������������������Ŀ
//� Pedidos gerados pelo Call Center em aberto                          �
//�����������������������������������������������������������������������
cQuery := "SELECT SUM(MAL_SALDO) AS PedAberto "
cQuery += "FROM MAL010 AS MAL, MAH010 AS MAH  "
cQuery += "WHERE "
cQuery += "MAL.MAL_SALDO > 0 AND "
cQuery += "MAL.MAL_CONTRA = MAH.MAH_CONTRA AND "
cQuery += "MAL.MAL_FILIAL = MAH.MAH_FILIAL AND "
cQuery += "MAH.MAH_CODCLI = '" + cCodCli + "' AND "
cQuery += "MAH.MAH_LOJA = '" + cLojCli + "' AND "
cQuery += "MAH.MAH_TRANS = '1'  AND "
cQuery += "MAH.D_E_L_E_T_ <> '*' AND "
cQuery += "MAL.D_E_L_E_T_ <> '*' "

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRAB", .T., .T.)
nPedAberto := TRAB->PedAberto

TRAB->( dbCloseArea() )

nTitAberto	:= nTitVenc + nTitVinc

//���������������������������������������������������������������������Ŀ
//� Montagem do aHeaderPAJ / aColsPAJ                                   �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Montagem do aHeaderPAJ                                              �
//�����������������������������������������������������������������������
SX3->( dbSetOrder( 1 ) )
SX3->( dbSeek( 'PAJ'  ) )

While !SX3->( Eof() ) .AND. SX3->X3_ARQUIVO == 'PAJ'
	
	If ( X3Uso( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL ) .AND. ;
		aScan( aNaoExibe, AllTrim( SX3->X3_CAMPO ) ) == 0
		
		aAdd( aHeaderPAJ, { Trim( X3Titulo() ), ;
		SX3->X3_CAMPO   , ;
		SX3->X3_PICTURE , ;
		SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL , ;
		SX3->X3_VALID   , ;
		SX3->X3_USADO   , ;
		SX3->X3_TIPO    , ;
		SX3->X3_F3      , ;
		SX3->X3_CONTEXT } )
		nUsado++
		
	EndIf
	
	SX3->( dbSkip() )
	
End

npDesc := aScan(aHeaderPAJ, {|x| rTrim(x[2]) == "PAJ_DESC"})

//���������������������������������������������������������������������Ŀ
//� Montagem do aColsPAJ                                                �
//�����������������������������������������������������������������������

PAJ->( dbSetOrder( 1 ) )

If PAJ->( dbSeek( xFilial( 'PAJ' ) + cCodCli + cLojCli ) )
	//
	// Ja existem itens cadastrados
	//
	
	nOpc  := 4
	nCols := 0
	
	While !PAJ->( Eof() ) .AND. ( xFilial( 'PAJ' ) + cCodCli + cLojCli ) == PAJ->( PAJ->PAJ_FILIAL + PAJ_CLIENTE + PAJ_LOJA )
		
		aAdd( aColsPAJ, Array( nUsado + 1 ) )
		nCols++
		
		For nI := 1 To nUsado
			If ( aHeaderPAJ[nI][10] != "V" )
				aColsPAJ[nCols][nI] := PAJ->( FieldGet( FieldPos( aHeaderPAJ[nI][2] ) ) )
			Else
				aColsPAJ[nCols][nI] := CriaVar( aHeaderPAJ[nI][2], .T. )
			EndIf
		Next nI
		
		aColsPAJ[nCols][nUsado+1] := .F.
		dbSelectArea( "PAJ" )
		
		PAJ->( dbSkip() )
	End
	
	nQtItExist   := Len( aColsPAJ )
	
Else
	
	//
	// Nao existem itens cadastrados
	//
	
	nOpc         := 3
	
	aAdd( aColsPAJ, Array( nUsado + 1 ) )
	
	For nI := 1 To nUsado
		aColsPAJ[1][nI] := CriaVar( aHeaderPAJ[nI][2], .T. )
	Next nI
	
	aColsPAJ[1][nUsado+1] := .F.
	
	nQtItExist   := 0
	
EndIf

// Anderson - Chamando funcao RetStatFin
_aRetStFin	:= P_RetStatFin(cCodCli,cLojCLi)

If !Empty(_aRetStFin)
	
	nChqDevol	:= _aRetStFin[1][2]
	nLucPerdas	:= _aRetStFin[2][2]
	nTitProt	:= _aRetStFin[3][2]
	nPagCart	:= _aRetStFin[4][1]
	nQChqDevol	:= _aRetStFin[5][1]
	
EndIf

//���������������������������������������������������������������������Ŀ
//� Criacao da Interface                                                �
//�����������������������������������������������������������������������
Define Font oFontHighB Name 'Arial' Size 0, -15 Bold
Define Font oFontHigh  Name 'Arial' Size 0, -15
Define Font oFontBold  Name 'Arial' Size 0, -11 Bold
Define Font oFontNor   Name 'Arial' Size 0, -11

DBSELECTAREA('PAJ')

Define MSDialog oDlgx From 0,  0 To 555, 830 Title 'Consulta Dados Hist�ricos de Cliente' Pixel Of oMainWnd

@  30,  7 Group oGroup1 To  77, 410 Prompt '' Of oDlgx Pixel
oGroup1:oFont := oFontBold
@  75,  7 Group oGroup2 To 115, 410 Label ' Composi��o do Saldo Devedor ( Valores ) ' Of oDlgx Pixel
oGroup2:oFont := oFontBold
@ 110,  7 Group oGroup3 To 145, 410 Label ' Hist�rico De T�tulos Baixados ( Quantidades ) ' Of oDlgx Pixel
oGroup3:oFont := oFontBold
@  30,  7 Group oGroup4 To 145, 410 Label ' Dados Gerais ' Of oDlgx Pixel
oGroup4:oFont := oFontBold

If lSoVisual
	nOpcGd := 0
Else
	If !INCLUI .And. !ALTERA // Exclusao ou Visualizacao
		nOpcGd := 0
	Else // Outras opcoes
		nOpcGd := GD_INSERT + GD_UPDATE + GD_DELETE
	EndIf
EndIf

oGet := MSNewGetDados():New( 145, 7, 275, 410, nOpcGd,"AllwaysTrue","AllwaysTrue",,,, 8192,'p_VlAltPAJ(nQtItExist)',,'p_VlDelPAJ(nQtItExist)' , oDlgx, aHeaderPAJ, aColsPAJ )
oGet:GoTo( Max( Len( aColsPAJ ) - 11, 1 ) )
oGet:Refresh()

@  40,  12 Say 'Ultima Compra'       Size 45, 8 Of oDlgx Pixel
@  50,  12 Say 'Vl. Ultima Compra'   Size 45, 8 Of oDlgx Pixel
@  60,  12 Say 'Data Maior Compra'   Size 45, 8 Of oDlgx Pixel

@  40, 112 Say 'Maior Compra'        Size 45, 8 Of oDlgx Pixel
@  50, 112 Say 'Maior Acumulo'       Size 45, 8 Of oDlgx Pixel
@  60, 112 Say 'Cliente Desde'       Size 45, 8 Of oDlgx Pixel

@  40, 212 Say 'Ped.Pendentes'   	 Size 45, 8 Of oDlgx Pixel
@  50, 212 Say 'Titulos Abertos'  	 Size 45, 8 Of oDlgx Pixel
@  60, 212 Say 'Total Saldo Devedor' Size 45, 8 Of oDlgx Pixel

@  40, 312 Say 'Dt.Limite Cr�dito'   Size 45, 8 Of oDlgx Pixel
@  50, 312 Say 'Limite Cr�dito'      Size 45, 8 Of oDlgx Pixel
@  60, 312 Say 'Saldo Dispo�vel'     Size 45, 8 Of oDlgx Pixel

@  85,  12 Say 'Cheques Devol.'      Size 45, 8 Of oDlgx Pixel
@  95,  12 Say 'Lucros/Perdas'       Size 45, 8 Of oDlgx Pixel

@  85, 112 Say 'T�tulos Protest.'    Size 45, 8 Of oDlgx Pixel
@  95, 112 Say 'T�tulos Negativ.'    Size 45, 8 Of oDlgx Pixel

@  85, 212 Say 'Notas D�bito'        Size 45, 8 Of oDlgx Pixel
@  95, 212 Say 'T�tulos Vencidos'    Size 45, 8 Of oDlgx Pixel

@  85, 312 Say 'Ch. Pr�-Datado'      Size 45, 8 Of oDlgx Pixel
@  95, 312 Say 'Tit. a Vencer'       Size 45, 8 Of oDlgx Pixel

@ 120,  12 Say 'Pag. Cart�rio'       Size 45, 8 Of oDlgx Pixel
@ 130,  12 Say 'Ch. Devolvidos'      Size 45, 8 Of oDlgx Pixel

@ 120, 112 Say 'Tit. Negat./Prot.'   Size 45, 8 Of oDlgx Pixel
@ 130, 112 Say 'Tit. Bxa. Perda'     Size 45, 8 Of oDlgx Pixel

@ 120, 212 Say 'Tit. Pago Atraso'    Size 45, 8 Of oDlgx Pixel
@ 130, 212 Say 'M�dia Atraso'        Size 45, 8 Of oDlgx Pixel

@ 120, 312 Say 'Rec.Cobr.Externa'    Size 45, 8 Of oDlgx Pixel


// Nome Cliente
@  15,  7 Get cNomeCli Size 400, 10 Picture '@!' ReadOnly NoBorder ;
Font oFontHighB Color CLR_HRED Of oDlgx Pixel

// Dados Gerais
@  39, 60 MSGet dUltCom      Size 45, 10 Picture '@!'                 ReadOnly Of oDlgx Pixel
@  49, 60 MSGet nVlUltCom    Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  59, 60 MSGet dMaiorCom    Size 45, 10 Picture '@!'                 ReadOnly Of oDlgx Pixel

@  39, 160 MSGet nMaiorCom   Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  49, 160 MSGet nMaiorAcu   Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  59, 160 MSGet dCliente    Size 45, 10 Picture '@!'                 ReadOnly Of oDlgx Pixel

@  39, 260 MSGet nPedAberto  Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  49, 260 MSGet nTitAberto  Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  59, 260 MSGet nTotSalDev  Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel

@  39, 360 MSGet dLimCred    Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  49, 360 MSGet nVlLimCred  Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  59, 360 MSGet nSalDispo   Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel


// Composicao Saldo Devedor
@  84, 60 MSGet nChqDevol    Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  94, 60 MSGet nLucPerdas   Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel

@  84, 160 MSGet nTitProt    Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  94, 160 MSGet nTitNegat   Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel

@  84, 260 MSGet nNotaDeb    Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  94, 260 MSGet nTitVenc    Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel

@  84, 360 MSGet nChqPre     Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel
@  94, 360 MSGet nTitVinc    Size 45, 10 Picture '@e 99, 999, 999.99' ReadOnly Of oDlgx Pixel


// Historico Ja Baixados
@ 119, 60 MSGet nPagCart     Size 45, 10 Picture '@e 99, 999, 999'    ReadOnly Of oDlgx Pixel
@ 129, 60 MSGet nQChqDevol   Size 45, 10 Picture '@e 99, 999, 999'    ReadOnly Of oDlgx Pixel

@ 119, 160 MSGet nTitNegProt Size 45, 10 Picture '@e 99, 999, 999'    ReadOnly Of oDlgx Pixel
@ 129, 160 MSGet nTitBxaPerd Size 45, 10 Picture '@e 99, 999, 999'    ReadOnly Of oDlgx Pixel

@ 119, 260 MSGet nTitPgoAtra Size 45, 10 Picture '@e 99, 999, 999'    ReadOnly Of oDlgx Pixel
@ 129, 260 MSGet nMediaAtra  Size 45, 10 Picture '@e 99, 999, 999'    ReadOnly Of oDlgx Pixel

@ 119, 360 MSGet nRecCobExt  Size 45, 10 Picture '@e 99, 999, 999'    ReadOnly Of oDlgx Pixel

Activate MSDialog oDlgx Centered On Init EnchoiceBar( oDlgx, {|| lOpcA:=.T., IIf( oGet:TudoOk(), oDlgx:End(), lOpcA := .F. )}, {||oDlgx:End()},, aButtons )

If lOpcA
//	Begin Transaction
	
	//���������������������������������������������������������������������Ŀ
	//� Grava os itens conforme as alteracoes                               �
	//�����������������������������������������������������������������������
	dbSelectArea( "PAJ" )
	dbSetOrder( 1 )
	
	For nX := 1 To Len( oGet:aCols )
		
		lDeletado := oGet:aCols[nX][nUsado + 1]
		
		If  nX > nQtItExist .AND. !lDeletado
			
			If !Empty(oGet:aCols[nX][npDesc])
				RecLock( "PAJ", .T. )
				
				For nI := 1 To Len( aHeaderPAJ )
					FieldPut( FieldPos( Trim( aHeaderPAJ[nI, 2] ) ), oGet:aCols[nX, nI] )
				Next nI
				
				PAJ->PAJ_FILIAL := xFilial( 'PAJ' )
				PAJ->PAJ_CLIENT := cCodCli
				PAJ->PAJ_LOJA   := cLojCli
				
				PAJ->(MsUnLock())
				
				lGravou := .T.
			EndIf
			
		EndIf
		
	Next
	
	EvalTrigger()
	
	If __lSX8
		ConfirmSX8()
	EndIf
	
   //	End Transaction
	
Else
	
	If __lSX8
		RollBackSX8()
	EndIf
	
EndIf

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � VLDELPAJ �Autor  � Ernani Forastieri  � Data �  28/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao da Delecao da Linha                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function VlDelPAJ( nQtItExist )
Local  lRet := .F.
Static lPrimVez := .T.

//
// Tratamento lPrimVez colocado porque a MSNewGetdados
// esta chamando 2 vezes a funcao especificada
//

If oGet:nAt > nQtItExist
	lRet := .T.
Else
	If lPrimVez
		ApMsgStop('Informa��es anteriores a esta opera��o n�o podem ser apagadas', 'ATEN��O' )
		lPrimVez := .F.
	Else
		lPrimVez := .T.
	EndIf
EndIf
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � VLALTPAJ �Autor  � Ernani Forastieri  � Data �  28/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao da Alteracao dos Campos                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function VlAltPAJ( nQtItExist )
Local  lRet     := .F.
Static lPrimVez := .T.

//
// Tratamento lPrimVez colocado porque a MSNewGetdados
// esta chamando 2 vezes a funcao especificada
//

If oGet:nAt > nQtItExist
	lRet := .T.
Else
	If lPrimVez
		ApMsgStop('Informa��es anteriores a esta opera��o n�o podem ser alteradas', 'ATEN��O' )
		lPrimVez := .F.
	Else
		lPrimVez := .T.
	EndIf
EndIf

Return lRet


//////////////////////////////////////////////////////////////////////////////