#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA026   �Autor  �Norbert Waage Junior   � Data �  17/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de troca dos vendendores associados ao cliente          ���
����������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo menu SIGALOJA.XNU especifico.             ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA026()

Local aAreaSX3	:=	SX3->(GetArea())
Local aSay		:=	{}
Local aButton	:=	{}
Local aCombo	:=	{{},{}}
Local cTpVend	:=	""
Local cCodAtu	:=	Space(TamSx3("A1_VEND")[1])
Local cCodNovo	:=	cCodAtu
Local cSolic	:=	Space(TamSx3("PAE_SOLIC")[1]) 
Local lOk		:=	.F.

//�������������Ŀ
//�Posiciona SX3�
//���������������
SX3->(DbSetOrder(2))
SX3->(DbSeek("A1_VEND"))

//����������������������������������������������������Ŀ
//�Monta combo com campos de vendedores, caracterizados�
//�pela mascara A1_VEND                                �
//�----------------------------------------------------�
//�Estrutura do aCombo:                                �
//�aCombo[1] - > Nome dos campos que contem "A1_VEND"  �
//�aCombo[2] - > Descricao dos campos do 1o. vetor.    �
//������������������������������������������������������
While !SX3->(Eof()) .And. "A1_VEND" $ Alltrim(Upper(SX3->X3_CAMPO))
	AAdd(aCombo[1],SX3->X3_CAMPO)
	AAdd(aCombo[2],SX3->X3_TITULO)
	SX3->(DbSkip())
End

//���������������������������Ŀ
//�Texto explicativo da rotina�
//�����������������������������
aAdd( aSay, "Esta rotina tem por objetivo efetuar a troca do vendedor selecionado, baseando- " )
aAdd( aSay, "se nos par�metros informados pelo usuario.                                      " )
aAdd( aSay, "Toda altera��o gerar� um registro na tabela de hist�rico de troca de vendedores," )
aAdd( aSay, "para controle de altera��es executadas.                                         " )

//������������������������Ŀ
//�Botoes da tela principal�
//��������������������������
//Parametros
aAdd( aButton, { 5,.T.,	{|| lOk := _TelaPar(aCombo,@cTpVend,@cCodAtu,@cCodNovo,@cSolic)}} )
//Confirma
aAdd( aButton, { 1,.T.,	{|| Iif(lOk,FechaBatch(),MsgInfo("Confirme os par�metros antes de prosseguir"))}} )
//Cancela
aAdd( aButton, { 2,.T.,	{|| (lOk := .F.,FechaBatch())}} )

//�����������Ŀ
//�Abre a tela�
//�������������
FormBatch( "Troca de Vendedores", aSay, aButton )

//���������������������������������������������Ŀ
//�Acao executada caso o usuario confirme a tela�
//�����������������������������������������������
If lOk
	Processa({|lEnd|_TrocaVnd(aCombo,cTpVend,cCodAtu,cCodNovo,cSolic,@lEnd)},"Aguarde","Selecionando registros...",.T.)
Endif

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA026A  �Autor  �Norbert Waage Junior   � Data �  17/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �mBrowse de exibicao do historico de troca de vendedores        ���
����������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada pelo menu SIGALOJA.XNU especifico.           ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA026A()

Private cCadastro := "Hist�rico de troca de vendedores"

Private aRotina :=	{{"Pesquisar","AxPesqui",0,1},;
					{"Visualizar","AxVisual",0,2}}

dbSelectArea("PAE")
dbSetOrder(1)
mBrowse( 6,1,22,75,"PAE")

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_TelaPar  �Autor  �Norbert Waage Junior   � Data �  17/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Tela de recebimento dos parametros da alteracao do vendedor    ���
����������������������������������������������������������������������������͹��
���Parametros�aCombo    - Array composto pelos sub-arrays descritos abaixo   ���
���          �aCombo[1] - Nomes dos campos no SX3 relacionados a vendendores ���
���          �aCombo[2] - Descricao dos campos do aCombo[1], relacao 1-1.    ���
���          �cTpVend   - Tipo de vendedor selecionado                       ���
���          �cCodAtu   - Codigo atual                                       ���
���          �cCodNovo  - Codigo a ser gravado                               ���
���          �cSolic    - Nome do responsavel pela troca dos vendedores      ���
����������������������������������������������������������������������������͹��
���Retorno   �lRet(.T.) - Usuario confirmou a tela                           ���
���          �lRet(.F.) - Usuario cancelou a tela                            ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada pelo botao de parametros da tela de troca.     ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _TelaPar(aCombo,cTpVend,cCodAtu,cCodNovo,cSolic)

Local oDlg1		:=	NIL
Local oCombo	:=	NIL
Local lOk := .F.

//Monta a tela
DEFINE MSDIALOG oDlg1 TITLE "Troca de Vendedores" FROM 0,0 TO 215,380 PIXEL OF oMainWnd

//Label
@ 05,05 TO 85,180 LABEL "" OF oDlg1 PIXEL

//Campo Tipo de Vendedor
@ 15,15 SAY "Vendedor"	SIZE 70,7 PIXEL OF oDlg1
@ 15,80 COMBOBOX oCombo VAR cTpVend ITEMS aCombo[2] SIZE 45,30 PIXEL OF oDlg1

//Campo Codigo Atual
@ 30,15 SAY "C�digo Atual"	SIZE 70,7 PIXEL OF oDlg1
@ 30,80 MSGET cCodAtu F3 "SA3" Valid (Empty(cCodAtu) .Or. ExistCpo("SA3",cCodAtu)) SIZE 45,10 PIXEL OF oDlg1

//Campo Codigo Novo
@ 45,15 SAY "C�digo Novo"	SIZE 70,7 PIXEL OF oDlg1
@ 45,80 MSGET cCodNovo F3 "SA3" Valid (Empty(cCodNovo) .Or. ExistCpo("SA3",cCodNovo)) SIZE 45,10 PIXEL OF oDlg1

//Campo Solicitante
@ 60,15 SAY "Solicitante"	SIZE 70,7 PIXEL OF oDlg1
@ 60,80 MSGET cSolic PICTURE "@!" SIZE 90,10 PIXEL OF oDlg1

//Botao Confirma
DEFINE SBUTTON 	FROM 90,120 TYPE 1 ENABLE OF oDlg1;
ACTION (Iif( (!Empty(cTpVend) .And. !Empty(cCodAtu) .And. !Empty(cCodNovo) .And. !Empty(cSolic)) ,;
	(lOk := .T., oDlg1:End()),;
	ApMsgAlert("Preencha todos os campos antes de prosseguir","Par�metros")))

//Botao Cancela
DEFINE SBUTTON 	FROM 90,155 TYPE 2 ENABLE OF oDlg1 ACTION oDlg1:End()

//Abre a tela
Activate MsDialog oDlg1 Centered

Return lOk

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_TrocaVnd �Autor  �Norbert Waage Junior   � Data �  17/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de substituicao de vendedores do cadastro de clientes   ���
����������������������������������������������������������������������������͹��
���Parametros�aCombo    - Array composto pelos sub-arrays descritos abaixo   ���
���          �aCombo[1] - Nomes dos campos no SX3 relacionados a vendendores ���
���          �aCombo[2] - Descricao dos campos do aCombo[1], relacao 1-1.    ���
���          �cTpVend   - Tipo de vendedor selecionado                       ���
���          �cCodAtu   - Codigo atual                                       ���
���          �cCodNovo  - Codigo a ser gravado                               ���
���          �cSolic    - Nome do responsavel pela troca dos vendedores      ���
���          �lEnd      - Tratamento para cancelamento da rotina             ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada pelo botao de confirmacao da tela de troca.    ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _TrocaVnd(aCombo,cTpVend,cCodAtu,cCodNovo,cSolic,lEnd)

Local cArq
Local nPos                   
Local lMark		:=	.T.
Local lRec		:=	.F.
Local aClientes	:=	{}
Local cCampo	:=	Alltrim(aCombo[1][AScan(aCombo[2],cTpVend)])
Local cFilSA1	:=	xFilial("SA1")

//���������������������������������������������������Ŀ
//�Verifica se o usuario selecionou os mesmos codigos,�
//�tornando rotina sem efeito                         �
//�����������������������������������������������������
If cCodAtu == cCodNovo
	ApMsgAlert("Os codigos de origem e destino s�o id�nticos!","Abortando rotina")
	Return .F.
EndIf

DbSelectArea("SA1")	

//Atualiza texto da regua de processamento
IncProc("Selecionando registros...")

//������������������������������������������������Ŀ
//�Cria arquivo temporario, ordenando pelo vendedor�
//��������������������������������������������������
cArq := CriaTrab(Nil,.F.)
IndRegua("SA1",cArq,"A1_FILIAL+" + cCampo)
DbSeek(cFilSA1+cCodAtu)

//�������������������������������������������Ŀ
//�Armazena clientes que atendem os parametros�
//���������������������������������������������
While !Eof() .And. SA1->A1_FILIAL == cFilSA1 .And. SA1->&(cCampo) == cCodAtu
	AAdd(aClientes,{lMark,SA1->A1_CGC,SA1->A1_NOME,SA1->(Recno())})
	DbSkip()
End

//������������������������Ŀ
//�Apaga arquivo temporario�
//��������������������������
RetIndex("SA1")
DbSetorder(1)
Ferase(cArq+OrdBagExt()) 

//���������������������������������������������������������Ŀ
//�Se ha clientes para a troca, ordena por Nome/Razao Social�
//�����������������������������������������������������������
nTotCli := Len(aClientes)

If nTotCli > 0

	aSort(aClientes,,,{|x,y| x[3] < y[3]})
	
	//����������������������������������������������������������Ŀ
	//�Chama a rotina _TelaSCli para a selecao final dos clientes�
	//�a terem o vendedor trocado                                �
	//������������������������������������������������������������
	If !_TelaSCli(@aClientes,cTpVend)	
		ApMsgInfo("Rotina abortada","Troca de vendedores")
		Return Nil
	EndIf
	
	//��������������������������������������������Ŀ
	//�Atualiza o tamanho da Regua de processamento�
	//����������������������������������������������
	ProcRegua(nTotCli)
	
	Begin Transaction
	
	For nPos := 1 to nTotCli

		IncProc("Atualizando clientes")
		
		//������������������������������������������������������Ŀ
		//�Caso o cliente esteja marcado, o codigo do vendedor eh�
		//�substituido                                           �
		//��������������������������������������������������������
		If aClientes[nPos][1]
			
			SA1->(dbGoTo(aClientes[nPos][4]))
			
			//�����������������Ŀ
			//�Troca do vendedor�
			//�������������������
			RecLock("SA1",.F.)
			SA1->&(cCampo) := cCodNovo
			MsUnLock() 
			lRec :=	.T.
			
		EndIf
		
		//�������������������������������Ŀ
		//�Tratamento para o botao cancela�
		//���������������������������������
		If lEnd .And. (lEnd := ApMsgNoYes("Deseja cancelar a execu��o do processo?","Interromper"))
			nPos := nTotCli + 1
			DisarmTransaction()
		EndIf
		
	Next nPos
	
	End Transaction
	
	//��������������������������������������������
	//�Se houve alguma alteracao, o log eh gerado�
	//��������������������������������������������
	If lRec

		IncProc("Gravando Log de altera��o...")

		DbSelectArea("PAE")
		RecLock("PAE",.T.)
		
		PAE->PAE_FILIAL	:=	xFilial("PAE")
		PAE->PAE_USER	:=	cUsername
		PAE->PAE_SOLIC	:=	cSolic
		PAE->PAE_DATA	:=	dDataBase
		PAE->PAE_HORA	:=	Time()
		PAE->PAE_TPVEND	:=	cTpVend
		PAE->PAE_VENDO	:=	cCodAtu
		PAE->PAE_VENDD	:=	cCodNovo		
		
		MsUnLock()
		
		ApMsgInfo("Altera��o realizada com sucesso","Troca de Vendedores")
	
	Else
	
		ApMsgInfo("Nenhum cliente foi selecionado para altera��o","Troca de Vendedores")
	
	EndIf   
	
Else
	
	MsgAlert("Nenhum cliente sofreu altera��o","Sem ocorr�ncias")

EndIf
	
Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_TelaSCli �Autor  �Norbert Waage Junior   � Data �  17/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Tela de selecao dos clientes contidos nos parametros iniciais, ���
���          �para a troca de vendedores                                     ���
����������������������������������������������������������������������������͹��
���Parametros�aClientes - Array que contem os clientes pre-selecionados      ���
����������������������������������������������������������������������������͹��
���Retorno   �lRet(.T.) - Confirmacao da tela                                ���
���          �lRet(.F.) - Cancelamento da tela                               ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada apos a confirmacao dos parametros iniciais da   ���
���          �tela de troca de vendedores                                    ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _TelaSCli(aClientes)

Local oDlg2		:=	Nil
Local oLbx		:=	Nil
Local oOk		:= LoadBitmap( GetResources(), "LBOK" )		//Imagem "Marcado"
Local oNo		:= LoadBitmap( GetResources(), "LBNO" )		//Imagem "Desmarcado"
Local _oButMarc	:=	Nil										//Objeto Botao Marca
Local _oButDmrc	:=	Nil										//Objeto Botao Desmarca
Local _oButInve	:=	Nil										//Objeto Botao Inverte selecao
Local lRet		:=	.F.

//Define tela
DEFINE MSDIALOG oDlg2 FROM 0,0 TO 290,490 PIXEL TITLE "Confirma��o dos clientes" of oMainWnd
     
//Label
@ 04,03 TO 124,210 LABEL "Confirme a sele��o" OF oDlg2 PIXEL

//ListBox
@ 10,06 LISTBOX oLbx FIELDS HEADER " ","CNPJ/CPF","NOME";
SIZE 200,110 OF oDlg2 PIXEL ON dblClick(aClientes[oLbx:nAt,1] := !aClientes[oLbx:nAt,1],oLbx:Refresh())

//Metodos da ListBox
oLbx:SetArray(aClientes)
oLbx:bLine 	:= {|| {Iif(aClientes[oLbx:nAt,1],oOk,oNo),;
						aClientes[oLbx:nAt,2],;
						aClientes[oLbx:nAt,3]}}
                     
//Botoes
@ 125,005 Button _oButMarc Prompt "&Marcar Todos" 		Size 50,10 Pixel Action _Marca(1,@oLbx,@aClientes) Message "Selecionar todos os produtos" Of oDlg2
@ 125,055 Button _oButDmrc Prompt "&Desmarcar Todos"	Size 50,10 Pixel Action _Marca(2,@oLbx,@aClientes) Message "Desmarcar todos os produtos" Of oDlg2
@ 125,105 Button _oButInve Prompt "Inverter sele��o"	Size 50,10 Pixel Action _Marca(3,@oLbx,@aClientes) Message "Inverte a sele��o atual" Of oDlg2

//Botoes graficos
DEFINE SBUTTON 	FROM 10,215 TYPE 1 ENABLE OF oDlg2 ACTION(lRet := .T.,oDlg2:End())
DEFINE SBUTTON 	FROM 30,215 TYPE 2 ENABLE OF oDlg2 ACTION(oDlg2:End())

ACTIVATE MSDIALOG oDlg2	CENTERED

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_Marca    �Autor  �Norbert Waage Junior   � Data �  17/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de marcacao ou nao do primeiro elemento do array recebi-���
���          �do                                                             ���
����������������������������������������������������������������������������͹��
���Parametros�nOp  - Numero da opcao(1-Marca,2-Desmarca,3-Inverte)           ���
���          �oLbx - Listbox a ser atualizada                                ���
���          �aVet - Vetor a ser trabalhado pela rotina                      ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelos botoes da tela de selecao dos clientes    ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _Marca(nOp,oLbx,aVet)

Local lMarca,i

If nOp == 1 		//Marca todos
	lMarca	:=	.T.
ElseIf nOp == 2		//Desmarca Todos
	lMarca	:=	.F.
Endif

If lMarca != NIL
	For i := 1 To Len(aVet)
		aVet[i][1] := lMarca
	Next i
Else	//Inverte Selecao
	For i := 1 To Len(aVet)
		aVet[i][1] := !aVet[i][1]
	Next i
EndIf

oLbx:Refresh()	//Atualiza Listbox

Return Nil