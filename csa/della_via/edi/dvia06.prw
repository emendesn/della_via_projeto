#INCLUDE "TOPCONN.CH"
#Include "PROTHEUS.CH"
// #Include "DVIA06.CH"
#Define CRLF chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PESQEMP   �Autor  �Wagner Manfre       � Data �  26/09/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela de Pesquisa de Empresa                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DVIA06(nOpcao)

Local aArea      := GetArea()
Local nOpca	     := 0
Local nOpcb	     := 0
Local cCadastro  := "LOG de Importa��o EDI" 
Local nHdl       := 0
Local cBuffer    := ""
Local cQuery     := ""
Local aListAchou := {}
Local aRecnos    := {}
Local nComboEmp  := 0
Local aReturn    := {}
Local oOk 		 := LoadBitmap(GetResources(), "LBOK")
Local oNo 		 := LoadBitmap(GetResources(), "LBNO")
Local nRegSel    := 0
Local oDlgEsp, oDlgEsp1, oGet1, oGet2, oGet3, oGet4, oGet5, oCombo1, oGet6
Local lTem       := .F.

Private nOpc := 2

DEFAULT nOpcao   := 2

cQuery := "SELECT DISTINCT UA9_PROCES, UA9_ARQEDI, UA9_DTBASE " + CRLF
cQuery += "FROM " + RetSqlName("UA9") + CRLF
cQuery += "WHERE UA9_FILIAL = '" + xFilial("UA9") + "' " + CRLF
cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND UA9_PROCES = '"+nOpcao+"' " + CRLF
cQuery += "ORDER BY UA9_PROCES, UA9_ARQEDI" + CRLF

TCQuery cQuery NEW alias "TMP"
dbSelectArea("TMP")
dbGotop()
		                    
aListAchou := {}
		
While !eof()
	Aadd( aListAchou, {.F.,padr(TMP->UA9_PROCES, 10),Padr(TMP->UA9_ARQEDI,100),Padr(TMP->UA9_DTBASE,08) } )
	dbSkip()
	lTem := .T.
end

dbCloseArea()

if len(aListAchou) = 0
	Aadd( aListAchou, {.F.,padr(space(1), 10),Padr(space(1),100),Padr(space(1),08) } )
endif
		
		
dbSelectArea("UA9")
		
DEFINE FONT oFntListBox	NAME "Arial"
DEFINE MSDIALOG oDlgEsp1 TITLE cCadastro FROM 329,137 to 595,792 pixel
@ 114,010 SAY OemToAnsi("Duplo clique, seleciona e entra na visualiza��o!")	SIZE 100,20	OF oDlgEsp PIXEL FONT oFntListBox	//Duplo clique
@ 014,009 LISTBOX oCombo1 VAR nComboemp FIELDS HEADER "", OemToAnsi("Processo"), OemToAnsi("Arquivo EDI"),OemToAnsi("Data Base");
FIELDSIZES 05,15,20,20 SIZE 309,92 OF oDlgEsp1 PIXEL FONT oFntListBox

oCombo1:SetArray(aListAchou)
oCombo1:bLDblClick := {|| nOpcb:=2,nRegSel:=oCombo1:nAt,oDlgEsp1:end()}
oCombo1:bChange := {||  POSUA9( aListAchou[oCombo1:nAt,2] ),oCombo1:Refresh(),nRegSel:=oCombo1:nAt}
oCombo1:bLine := {|| { If(aListAchou[oCombo1:nAt,1],oOk,oNo), aListAchou[oCombo1:nAt,2], aListAchou[oCombo1:nAt,3], Stod(aListAchou[oCombo1:nAt,4]) }}

// @ OB3C1,OB3C2  BUTTON OemToANsi(STR0017)	SIZE 40,14 OF oDlgEsp1 PIXEL ACTION (oDlgEsp1:End(), nOpcb:=3)
If lTem
	@ 114,107  BUTTON OemToAnsi("Visualizar")	SIZE 40,14 OF oDlgEsp1 PIXEL ACTION ( POSUA9( aListAchou[oCombo1:nAt,2] ), oDlgEsp1:End(), nOpcb:=2) // Visualiza
	// @ OB4C1,OB4C2  BUTTON OemToAnsi(STR0013)	SIZE 40,14 OF oDlgEsp1 PIXEL ACTION (oDlgEsp1:End(), nOpcb:=4)
    // @ OB6C1,OB6C2  BUTTON OemToAnsi(STR0015)	SIZE 40,14 OF oDlgEsp1 PIXEL ACTION (oDlgEsp1:End(), nOpcb:=5)
Endif

@ 114,287  BUTTON OemToAnsi("Cancelar")	SIZE 40,14 OF oDlgEsp1 PIXEL ACTION (oDlgEsp1:End(),nOpca:=0, nOpcb:=0) // CANCELA

ACTIVATE MSDIALOG oDlgEsp1 ON INIT EnchoiceBar(oDlgEsp1,{||oDlgEsp1:End(),nOpcb:=0},{||oDlgEsp1:End(),nOpca:=1,nOpcb:=0}) CENTERED
// ACTIVATE MSDIALOG oDlgEsp1 ON INIT EnchoiceBar(oDlgEsp1,{||oDlgEsp1:End(),nOpcb:=0},{||oDlgEsp1:End(),nOpca:=1,nOpcb:=0},,{{"AUTOM",{|| U_LELOG()},"Consulta Log"}})
/*/
If lBotCalc
 ACTIVATE MSDIALOG oDlg ON INIT    EnchoiceBar(oDlg,    {||Iif(A010TudoOk(@nOpcOdlg,oTree,nOpc),oDlg:End(),.F.)},{||oDlg:End()},,{{"AUTOM",Iif(lBotCalc,{|| U_A010ChCalc(AliasTree(oTree,cRev)[1],.t.)},{||Nil}),"Calcula"}}) //Centered    
Else
 ACTIVATE MSDIALOG oDlg ON INIT    EnchoiceBar(oDlg,    {||Iif(A010TudoOk(@nOpcOdlg,oTree,nOpc),oDlg:End(),.F.)},{||oDlg:End()},,) //Centered    
EndIf/*/ 


If nOpcb==2
	// alert("visualiza")	
	PACVisual("UA9", UA9->( RECNO() ), 2 )
EndIF
/*

//+--------------------------------------------------------------+
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//+--------------------------------------------------------------+
PRIVATE aRotina := { 	{OemtoAnsi(STR0001), "AxPesqui"  ,  0 ,  1   },;  // "Pesquisar"
						{OemtoAnsi(STR0002), "I090MANUT" ,  0 ,  2   }}   // "Visualizar"

	
//+--------------------------------------------------------------+
//� Define o cabecalho da tela de atualizacoes                   �
//+--------------------------------------------------------------+
PRIVATE cAlias    := "UA9"
PRIVATE nOpc      := 1
PRIVATE lRefresh  := .T.
		
If nOpcb > 0
	If nOpcb == 1
		Aadd(aReturn, 1)
		Aadd(aReturn, 0)
	elseif nOpcb == 2
		Aadd(aReturn, 2)
		Aadd(aReturn, aRecnos[nRegSel])
	elseif nOpcb == 3
		Aadd(aReturn, 3)
		Aadd(aReturn, aRecnos[nRegSel])
	elseif nOpcb == 4
		Aadd(aReturn, 4)
		Aadd(aReturn, aRecnos[nRegSel])
	elseif nOpcb == 5
		Aadd(aReturn, 5)
		Aadd(aReturn, aRecnos[nRegSel])
	endif
else
	Aadd(aReturn, 0)
	Aadd(aReturn, 0)
endif

if aReturn[1] > 0
	I090manut(cAlias,AReturn[2],aReturn[1], aReturn)
endif          

*/

aReturn := {}

RestArea(aArea)
Return(aReturn)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �PACVISUAL �Autor  � Ernani Forastieri  � Data �  05/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Visualizao do Arquivo                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Imobiliaria Santa Teresinha                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PACVisual( cAlias, nRecNo, nOpcX )

PRIVATE aRotina := { 	{OemtoAnsi("Pesquisar"), "AXPESQUI"  ,  0 ,  1   },;  // "Pesquisar"
						{OemtoAnsi("Visualizar"), "CRIATELA" ,  0 ,  2   }}   // "Visualizar"

Private cCadastro := 'LOG de Importa��o'
Private cDelFunc  := '.T.'
// Private aRotina   := {}
Private aCposCab  := { 'UA9_PROCES', 'UA9_ARQEDI', 'UA9_DTBASE' }

Private aHeader := {}
Private aCols   := {}
Private aAltera := {}
Private nUsado  := 0

If (cAlias)->( RecCount() ) == 0
	Return NIL
EndIf
                                            
Private M->UA9_PROCES := UA9->UA9_PROCES
Private M->UA9_ARQEDI := UA9->UA9_ARQEDI
Private M->UA9_DBASE  := UA9->UA9_DTBASE // M->PAC_OBS    := MSMM(PAC->PAC_CODOBS, TamSX3('PAC_OBS')[1] )

dbSelectArea( cAlias )

If (cAlias)->( RecCount()) == 0
	Return NIL
EndIf

CriaHeader( cAlias )
CriaCols( nOpcX, UA9->UA9_PROCES)

// Monta a tela de visualiza��o
CriaTela( nOpcX )

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �CRIAHEADER�Autor  � Ernani Forastieri  � Data �  05/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Criacao do aHeader                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Imobiliaria Santa Teresinha                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaHeader( cAlias )
Local aArea    := GetArea()
Local aAreaSX3 := SX3->( GetArea() )

dbSelectArea( "SX3" )
SX3->( dbSetOrder( 1 ) )
SX3->( dbSeek( cAlias ) )

While !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == cAlias
	If X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL .AND. ;
		aScan( aCposCab, Trim( SX3->X3_CAMPO ) ) == 0
		nUsado++
		AADD( aHeader, { Trim( X3Titulo() ) , ;
		SX3->X3_CAMPO        , ;
		SX3->X3_PICTURE      , ;
		SX3->X3_TAMANHO      , ;
		SX3->X3_DECIMAL      , ;
		SX3->X3_VALID        , ;
		SX3->X3_USADO        , ;
		SX3->X3_TIPO         , ;
		SX3->X3_ARQUIVO      , ;
		SX3->X3_CONTEXT      } )
	EndIf
	SX3->( dbSkip() )
End

RestArea( aAreaSX3 )
RestArea( aArea )
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �CRIACOLS  �Autor  � Ernani Forastieri  � Data �  05/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Criacao do aCols                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Imobiliaria Santa Teresinha                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaCols( nOpcX, cCodProces)
Local aArea  := GetArea()
Local nLinha := 0

UA9->( dbSetOrder( 4 ) )
UA9->( dbSeek( xFilial( 'UA9' )  +  cCodProces ) )

If nOpcX == 3
	//cCond :=  'nLinha < 1'
Else
	cCond :=  'UA9->UA9_FILIAL  +  UA9->UA9_PROCES == xFilial( "UA9" )  +  "' + cCodProces + '" '
EndIf


While !UA9->( EOF() ) .AND. &cCond
	
	aAdd( aCols, Array( Len( aHeader ) + 1 ) )
	
	nLinha++
	nUsado:=0
	
	SX3->( dbSeek( 'UA9' ) )
	While !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'UA9'
		
		If X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL .AND. ;
			aScan( aCposCab, Trim( SX3->X3_CAMPO ) ) == 0
			nUsado++
			
			If     SX3->X3_CONTEXT == "V" .or. nOpcX == 3
				aCols[nLinha][nUsado] := CriaVar( aHeader[nUsado][2], .T. )
				
			ElseIf SX3->X3_CONTEXT <> "V"
				aCols[nLinha][nUsado] := FieldGet( FieldPos( aHeader[nUsado][2] ) )
				
			EndIf
			
		EndIf
		
		aCols[nLinha][nUsado+1] := .F.
		SX3->( dbSkip() )
	End
	
	If nOpcX <> 3
		aAdd( aAltera, UA9->( Recno() ) )
	EndIf
	
	UA9->( dbSkip() )
End

RestArea( aArea )

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �CRIATELA  �Autor  � Ernani Forastieri  � Data �  05/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Criacao da Tela                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Imobiliaria Santa Teresinha                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaTela( nOpcX )
Local lRet     := .F.
Local lSoExibe := ( nOpcX == 2 .or. nOpcX == 5 )
Local oDlg     := NIL

RegToMemory("UA9",.f.,.t.)

Define MSDialog oDlg Title cCadastro From 0, 0 To 360, 630 Pixel Of oMainWnd

@ 15,   5 To 81, 305 Label "" Of oDlg Pixel

@ 25, 010 Say RetTitle('UA9_PROCES')  Size 70, 8 Pixel Of oDlg
@ 25, 110 Say RetTitle('UA9_ARQEDI')  Size 70, 8 Pixel Of oDlg
@ 40, 010 Say RetTitle('UA9_DTBASE')     Size 70, 8 Pixel Of oDlg

//@ 24, 050 MSGet M->PAC_CODGRD Picture '@!' Valid CheckSX3( 'PAC_CODGRD', M->PAC_CODGRD ) When Inclui    Size  40,  8 Pixel Of oDlg
@ 24, 050 MSGet M->UA9_PROCES Picture '@!' Valid CheckSX3( 'UA9_PROCES', M->UA9_PROCES ) When .F.       Size  40,  8 Pixel Of oDlg
@ 24, 150 MSGet M->UA9_ARQEDI Picture '@!' Valid CheckSX3( 'UA9_ARQEDI', M->UA9_ARQEDI ) When !lSoExibe Size 120,  8 Pixel Of oDlg
@ 39, 050 MSGet M->UA9_DTBASE Picture '@D' Valid CheckSX3( 'UA9_DTBASE', M->UA9_DTBASE ) When !lSoExibe Size 120,  8 Pixel Of oDlg //     MEMO         Valid CheckSX3( 'PAC_OBS'   , M->PAC_OBS )    When !lSoExibe Size 160, 32 Pixel Of oDlg

// oGet := MSGetDados():New( 80, 5, 180, 305, nOpcX, "UA9LinOk()", "UA9TudOk()", " + UA9_DTBASE", .T. )
oGet := MSGetDados():New( 80, 5, 180, 305, nOpcX, "", "", " + UA9_DTBASE", .T. )

If lSoExibe
	Activate MSDialog oDlg Centered On Init EnchoiceBar( oDlg, {|| lRet := .T., IIf( oGet:TudoOk(), oDlg:End(), lOpcA := .F. ) }, { || oDlg:End() } ,,{{"S4WB011N",{|| LELOG()},"Consulta Log"}})
Else
	Activate MSDialog oDlg Centered On Init EnchoiceBar( oDlg, {|| lRet := .T., IIf( oGet:TudoOk() .and. u_UA9TudOk() .and. u_UA9LinOk() , oDlg:End(), lRet := .F. ) }, { || lRet := .F., oDlg:End() } ,,{{"AUTOM",{|| U_LELOG()},"Consulta Log"}})
EndIf

// ACTIVATE MSDIALOG oDlgEsp1 ON INIT EnchoiceBar(oDlgEsp1,{||oDlgEsp1:End(),nOpcb:=0},{||oDlgEsp1:End(),nOpca:=1,nOpcb:=0},,{{"AUTOM",{|| U_LELOG()},"Consulta Log"}})
//.and. Obrigatorio( aGets, aTela )

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UA9LinOk  �Autor  �Microsiga           � Data �  09/01/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function UA9LinOk()
Return .T.
*/                            

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UA9TudOk  �Autor  �Microsiga           � Data �  09/01/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function UA9TudOk()
Return .T.
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �POSUA9    �Autor  �Microsiga           � Data �  09/01/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function POSUA9( cProcesso )

UA9->( dbSetOrder( 4 ) )
LOK:=UA9->( dbSeek( xFilial( 'UA9' ) +  cProcesso ) )

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LELOG     �Autor  �Microsiga           � Data �  09/01/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LELOG()

Local nPosLog := aScan(aHeader, {|x| x[2] == "UA9_AUTOLG"})

If !Empty(aCols[n][nPosLog])
	// MostraErro(GETMV("ES_ARQLOG"),aCols[n][nPosLog])
	TelaErro(GETMV("ES_ARQLOG"),aCols[n][nPosLog])
EndIf
	
Return Nil


Static Function TelaErro(cPath,cNome)
Local oDlg
Local cMemo
Local cFile    :=""
Local oFont 
Local __cFileLog := AllTrim(cPath)+AllTrim(cNome)

DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15
 
cMemo :=MemoRead(__cFileLog)
DEFINE MSDIALOG oDlg TITLE "Log de Erro" From 3,0 to 340,417 PIXEL
 
@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont
 
DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
 
ACTIVATE MSDIALOG oDlg CENTER
 
Return
 