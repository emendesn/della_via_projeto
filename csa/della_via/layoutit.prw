#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LayoutIt  � Autor � Indio Loco            � Data � 06/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela de Manutencao dos Layouts                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LayoutIt  

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := "FXE"
Private cCadastro := "Tabelas para Importacao"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
             
aRotina := {{"Pesquisar"	,"AxPesqui",0,1} ,;
				{"Visualizar"	,"U_INCLUIIT('2')",0,2} ,;
				{"Incluir"		,"U_INCLUIIT('3')",0,3} ,;
				{"Alterar"		,"U_INCLUIIT('4')",0,4} ,;
				{"Excluir"		,"U_INCLUIIT('5')",0,5}}//"U_INCLUIIT('5')",0,5}}

//���������������������������������������������������������������������Ŀ
//� Monta array com os campos para o Browse                             �
//�����������������������������������������������������������������������
/*
Private aCampos := { {"ID.TRANSACAO","FXF_IDTRAN","999"} ,;
           {"TIPO TRANSAC","FXF_TPTRAN","@!"} ,;
           {"SEQUENCIA","FXF_SEQUEN","999"} ,;
           {"DESCRICAO","FXF_TXTRAN","@S30"} ,;
           {"ALIAS","FXF_ALIAS","@!"} ,;
           {"ORDEM","FXF_ORDEM","99"} ,;
           {"POS.INICIAL","FXF_CHPINI","999"} ,;
           {"TAM.CHAVE","FXF_CHTAM","999"} ,;
           {"ID.LAY OUT","FXF_IDLAY","@!"} ,;
           {"ID.LAYOUT CB","FXF_IDLAYC","@!"} ,;
           {"ROTINA AUTO","FXF_AUTO","@!"} }
*/
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "FXE"
Private	cCampo	:= "FXE_IDLAY"
dbSelectArea("FXE")
dbSetOrder(1)

//cPerg   := "FXF"

//Pergunte(cPerg,.F.)
//SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)//,aCampos,cCampo)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �IncluiIt  � Autor � Indio Loco            � Data � 06/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta os Campos do Layout de Importacao                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IncluiIt( cOpcao )

Local lOpc    	:= .F.
Local bOk    	:= {|| lOpc:=.T.,oDialog:End() }
Local bCancel	:= {|| oDialog:End() }
Local aButtons  := {{"PROCESSA", {|| U_LoadSX3() }, "Carrega SX3"}}

Private nUsado  := 0
Private lFirst	:= .T.

aHeader :={}
aCols   :={}
 
nOpcx := Val( cOpcao )

MontaHead()

MontaCols()

oDialog := MSDialog():New(65, 0, 480, 600, "Layout de Importacao",,,,,,,,,.t.,,,)
If nOpcx == 3 .Or. nOpcx == 4
	@ 15,1 TO 209,300 MULTILINE MODIFY DELETE VALID VerLineOk()
Else	
	@ 15,1 TO 209,300 MULTILINE 
Endif	

Activate Dialog oDialog CENTERED  ON INIT EnchoiceBar(oDialog,bOk,bCancel,,IIf(nOpcx==3,aButtons,NIL))

If lopc
	If cOpcao == "3"
		ALTERALAY()  //GRAVALAY()
	ElseIf cOpcao == "4"
		ALTERALAY()
	ElseIf cOpcao == "5"
		EXCLUILAY()
	EndIf
EndIf 

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MontaHead � Autor � Armando T. Buchina    � Data � 23/01/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta aHeader com os dados do arquivo                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA081                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaHead()
//��������������������������������������������������������������Ŀ
//� Salva a Integridade dos campos de Bancos de Dados            �
//����������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("FXE")

//��������������������������������������������������������������Ŀ
//� Monta o array aHeader para a GetDados()                      �
//����������������������������������������������������������������
While !Eof() .And. (X3_ARQUIVO == "FXE")
	IF X3USO(X3_USADO) .And. cNivel >= X3_NIVEL //.and. X3_CAMPO != "FC_TES"
		nUsado:=nUsado+1
		AADD(aHeader,{ Trim(X3Titulo()), ;
			X3_CAMPO,;
			X3_PICTURE, ;
			X3_TAMANHO, ;
			X3_DECIMAL, ;
			"AllwaysTrue()" , ;
			X3_USADO,;
			X3_TIPO, ;
			X3_ARQUIVO,;
			X3_F3,;
			X3_CONTEXT } )
	Endif
	dbSkip()
Enddo

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MontaCols � Autor � Armando T. Buchina    � Data � 23/01/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta aCols   com os dados do arquivo                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA081                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaCols()

Local cCampo	:= ""
Local _ni		:= 0

If nOpcx # 3
		
	//��������������������������������������������������������������Ŀ
	//� Monta o array aCols com os itens                             �
	//����������������������������������������������������������������
	aCols:={}
	cCampo := FXE->FXE_IDLAY
	
	dbSelectArea("FXE")
	dbSetOrder(1)
	dbSeek( xFilial() + cCampo )
	While !Eof() .And. FXE->FXE_IDLAY == cCampo
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
Endif

If Len(aCols)  == 0
	//��������������������������������������������������������������Ŀ
	//� Monta o array aCols com 1 item em branco (inclusao)          �
	//����������������������������������������������������������������
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	Return .T.
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LinOk    � Autor � Indio Loco            � Data � 07/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao da linha digitada na funcao MultiLine             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Static Function VerLineOk
Local i 			:= 0
Local lRet 			:= .T.
Local nTamHeader	:= Len(aHeader)-1
Local cOrder		:= aCols[n,3]
Local nPosSeq		:= 0
Local cMsg			:= ""

If !aCols[n,Len(aHeader)+1]

	For i := 1 To nTamHeader
		If Empty(aCols[n,i])
			MsgBox("O preenchimento do campo " + aHeader[i,1] + " � obrigatorio!","Inconsistencia","STOP")
			lRet := .F.
			Exit
		EndIf
	Next
	
	nPosSeq := aScan(aCols,{|x| x[3] = cOrder})
	
	If nPosSeq # 0 .And. nPosSeq # n
		MsgBox("A ordem " + aCols[n,3] + " j� existe!","Inconsistencia","ALERT")
		lRet := .F.
	EndIf

EndIf
	
Return lRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GRAVALAY � Autor � INDIO LOCO            � Data � 02/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � GRAVA O NOVO LAYOUT                                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*
Static Function GRAVALAY()
Local nTamCols		:= Len(aCOLS)
Local nTamHeader	:= Len(aHeader)
Local lDeleta		:= .F.
Local nI, nX		:= 0

DbSelectArea("FXE")
For nI := 1 To nTamCols
	For nX := 1 To nTamHeader
		lDeleta := aCols[nI, nTamHeader+1]	//Verifica se o registro esta deletado
		If lDeleta
			RecLock("FXE",.T.)
				FXE_FILIAL	:= xFilial("FXE")
				FXE_IDLAY	:= aCols[nI, 1]
				FXE_ALIAS	:= aCols[nI, 2]
				FXE_SEQUEN	:= STR([nX],3)
				FXE_CAMPO	:= aCols[nI, 4]
				FXE_FUNCAO	:= aCols[nI, 5]
			MsUnLock()
		Endif
	Next
Next

Return
/*/

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ALTERALAY � Autor � INDIO LOCO            � Data � 02/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ALTERA LAYOUT DE IMPORTACAO                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                     
Static Function ALTERALAY()
Local nTamCols		:= Len(aCOLS)
Local nTamHeader	:= Len(aHeader)
Local cIdLay		:= ""
Local cSequen		:= ""
Local lDeleta		:= .F.
Local nX			:= 0
Local nCont			:= 1


aCols := aSort(aCols,,,{|x,y| x[1]+x[3] < y[1]+y[3]} )

DbSelectArea("FXE")
DbSetOrder(1)

For nX := 1 To nTamCols
	cIdLay	:= aCols[nX, 1]
	cSequen	:= aCols[nX, 3]
	lDeleta	:= aCols[nX, nTamHeader+1]
	
	If lDeleta			//Verifica se o registro esta deletado
		If DbSeek( xFilial("FXE") + cIdLay + cSequen )
			RecLock("FXE",.F.)
				FXE->(DbDelete())
			FXE->(MSUnlock())
		EndIf
	Else
		IF DbSeek( xFilial("FXE") + cIdLay + cSequen )
			RecLock("FXE",.F.)
				FXE_IDLAY	:= aCols[nX, 1]
				FXE_ALIAS	:= aCols[nX, 2]
				FXE_SEQUEN	:= STRZERO(nCont, 3)
				FXE_CAMPO	:= aCols[nX, 4]
				FXE_FUNCAO	:= aCols[nX, 5]
			MsUnLock()
		Else
			RecLock("FXE",.T.)
				FXE_FILIAL	:= xFilial("FXE")
				FXE_IDLAY	:= aCols[nX, 1]
				FXE_ALIAS	:= aCols[nX, 2]
				FXE_SEQUEN	:= STRZERO(nCont,3)
				FXE_CAMPO	:= aCols[nX, 4]
				FXE_FUNCAO	:= aCols[nX, 5]
			MsUnLock()
		Endif
		nCont++
	Endif
Next

Return


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EXCLUILAY()� Autor � INDIO LOCO           � Data � 02/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � EXCLUI LAYOUT DE IMPORTACAO                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                     
Static Function EXCLUILAY()
//Local nTamCols		:= Len(aCOLS)
//Local nTamHeader	:= Len(aHeader)
Local cIdLay		:= ""
//Local cSequen		:= ""
//Local lDeleta		:= .F.

cIdLay	:= aCols[1, 1]

DbSelectArea("FXE")
DbSetOrder(1)
DbSeek( xFilial("FXE") + cIdLay )

While FXE->(!EOF()) .And. xFilial("FXE") == cFilial .And. FXE->(FXE_IDLAY) == cIdLay
	RecLock("FXE",.F.)
		FXE->(DbDelete())
	FXE->(MSUnlock())
	FXE->(DbSkip())
EndDo

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DemoButton� Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Botoes com Bitmaps padronizados                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function LoadSX3()

Local cArq		:= Space(3)
Local _nI, _nX	:= 0
Local lOpcao	:= .F.
Local aCampos	:= {}

If ! lFirst
	MsgBox("Campos padroes j� carregados!")
	Return(.T.)
Endif
	
@ 0,0 TO 100,200 DIALOG oDlg1 TITLE "Campos Padroes"
@ 12,12 Say "Tabela:"
@ 12,50 Get cArq Picture "@!" F3 "DE7"
@ 35,12 BMPBUTTON TYPE 01 ACTION ( lOpcao:=.T.,Close(oDlg1))
@ 35,50 BMPBUTTON TYPE 02 ACTION ( lOpcao:=.F.,Close(oDlg1))
ACTIVATE DIALOG oDlg1 CENTER

If SX3->( DbSeek(cArq) ) .And. lOpcao
	While SX3->( !Eof() ) .And. SX3->X3_ARQUIVO == cArq
		aAdd(aCampos,{SX3->X3_ARQUIVO+"LAY", SX3->X3_ARQUIVO, SX3->X3_ORDEM, SX3->X3_CAMPO} )
		SX3->(dbSkip())
	EndDo
	
	For _nX:=1 to Len(aCampos)
		If _nX # 1
			AADD(aCols,Array(nUsado+1))
		EndIf
		For _nI:=1 to nUsado-1
			aCols[Len(aCols),_nI] := aCampos[_nX,_nI]
		Next _nI
		aCols[Len(aCols),nUsado+1] := .F.
	Next _nX

	lFirst := .F.
EndIf    


Return (.T.)

