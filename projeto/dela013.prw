#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA013A � Autor �Ricardo Mansano     � Data �  21/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Monta Tela com GetDados p/ Cadastro da Equipe de Montagem  ���
���          � que sera usado no P.E. LJ7002 para salvar as inf. em PAB   ���
���          � atravez da variavel PUBLICA _DELA013B que sera criada no   ���
���          � P.E. LJ7016 no momento de criacao dos Botoes.              ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro(.T.)                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atraves de um botao na tela de Venda Assistida     ���
���          � botao este que foi criado a partir do PE. LJ7016.          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���Benedet   �15/08/05�      �Permitir acesso a tela de montagem somente  ���
���          �        �      �quando existirem servicos no orcamento.  	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA013A()

Local oDlg
Local oGetD
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= MsAdvSize()
Local aInfo     	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local nUsado		:= 0 
Local nX			:= 0
Local nReg	 		:= 1
Local nOpc   		:= 3 //  Visualiza/Exclui=2 / Inclui/Altera=3
Local naCols		:= 0
Local cAcao			:= ""
Local lVirtual 		:= .F. 
Local nLinhas 		:= 100 // Numero de linhas Permitido na GetdDados
Local aButtons    	:= {}
Local aCpoGDa		:= { "PAB_CODTEC", "PAB_NOMTEC", "PAB_FUNCAO" }	
Local cFieldOk		:= "P_DELA013C"
Local cLinOk  		:= "P_DELA013D"
Local cTudoOk  		:= "P_DELA013E"
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local nTotLin       := Len(aCols)
Local lMostraTela   := .F.

//��������������������������������������Ŀ
//�Salva Configuracoes da aCols e aHeader�
//����������������������������������������
Local _aCols		:= aClone(aCols)
Local _aHeader		:= aClone(aHeader)
Local _n			:= n

Private cAliasG 	:= "PAB"
Private aRotina 	:= {{"Pesquisar","AxPesqui"   ,0,1},;
						{"Visual"   ,"AxVisual"  ,0,2},;
						{"Incluir"  ,"AxInclui"  ,0,3} }
Private aGets   	:= Array(0)
Private aTELA 		:= Array(0,0)

//��������������������������������������������������Ŀ
//� Verifica se a tela de montagem pode ser acessada �
//����������������������������������������������������
For nX := 1 to nTotLin
	If !gdDeleted(nX)
		// verifica se existe produto tipo servico
		If GetMV("FS_DEL037") == RetField("SB1", 1, xFilial("SB1") + gdFieldGet("LR_PRODUTO", nX), "B1_GRUPO")
			lMostraTela := .T.
			Exit
		EndIf
	EndIf
Next nX

If !lMostraTela
	MsgAlert(OemtoAnsi("A tela de montagem n�o pode ser acessada porque n�o h� servi�os no or�amento!"), "Aviso")
	Return(.T.)
EndIf

P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4","PA6"}) // GetArea

//���������������������������������������������������������������������������������Ŀ
//� Esta variavel Publica foi criada no P.E. LJ7016 e indica que a Tela de      	�
//� Equipe de Montagem foi acionada, esta variavel sera usada no P.E. LJ7002 		�
//� como ponto de referencia, caso ela seja .T. os or�amentos ser�o deletados     	�
//� de a variavel _DELA013B estiver vazia, caso contrario ser�o mantidos os menbros	�
//� da Equipe de Montagem atual.                                                    �
//�����������������������������������������������������������������������������������
_DELA013A := .T.
aHeader	  := {}
aCols  	  := {}

//���������������Ŀ
//�Carrega aHeader�
//�����������������
dbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
for nX := 1 to Len(aCpoGDa)
	If DbSeek(aCpoGDa[nX])
		nUsado++
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO	,;
			SX3->X3_PICTURE	,;
			SX3->X3_TAMANHO	,;
			SX3->X3_DECIMAL	,;
			SX3->X3_VALID	,;
			SX3->X3_USADO	,;
			SX3->X3_TIPO	,;
			SX3->X3_F3 		,;
			SX3->X3_CONTEXT	,;
			SX3->X3_CBOX	,;
			SX3->X3_RELACAO} )
	Endif
Next nX

//���������������������������������������������������������������������������������Ŀ
//� Se localizar Equipe de montagem deste orcamento o sistema acatara a GetDados	�
//� como Alteracao caso contrario acatara Inclusao e criara a aCols em Branco		�
//� foi feito desta forma pois poderiamos ter um Orcamento em "Alteracao" e       	�
//� um PAB(Equipe Montagem) em "Inclusao"                                         	�
//�����������������������������������������������������������������������������������
DbSelectArea("PAB")
PAB->(DbSetOrder(3)) // Filial + Orcamento              

//�����������������������������������������������������������������������Ŀ
//�Carrega os Dados de PAB se DbSeek for .T. e principalmente de _DELA013B�
//�ainda nao tiver cido preenchida, desta forma tiramos o controle dos    �
//�dados do banco(PAB) e passamos para Array que sera salvo na Confirmacao�
//�do Orcamento ou Venda no P.E. LJ7002                                   �
//�������������������������������������������������������������������������

If ( PAB->(DbSeek(xFilial("PAB")+M->LQ_NUM)) ) .and. ( Len(_DELA013B) == 0 )

	While !PAB->(Eof()) .And. ((xFilial("PAB")+M->LQ_NUM) == PAB->(PAB_FILIAL+PAB_ORC))
		//�����������������������������Ŀ
		//� Estrutura da Array aRet:    �
		//� [1] := Orcamento 			�
		//� [2] := Codido do Tecnico 	�
		//� [3] := Nome do Tecnico   	�
		//� [4] := Funcao 				�
		//�������������������������������
		//��������������������������������������������������������Ŀ
		//�Array utilizada no LJ7002 (P.E. Salvamento do Orcamento)�
		//����������������������������������������������������������
		AADD(_DELA013B,{PAB->PAB_ORC,PAB->PAB_CODTEC,PAB->PAB_NOMTEC,PAB->PAB_FUNCAO})
	PAB->(DbSkip())
	EndDo
Endif
	
//��������������������������������������������������������������������������������Ŀ
//� Se Array foi alimentada mas PAB ainda nao foi Salvo							   � 
//� resgata os dados da Array _DELA013B que soh serah limpa                        �
//� no P.E. LJ7002														           �
//����������������������������������������������������������������������������������
If Len(_DELA013B) == 0
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For nX := 1 To nUsado
		aCols[1,nX] := CriaVar(aHeader[nX,2])
	Next    
Else
	aCols := {}
	For nX := 1 To Len(_DELA013B)
		//������������������������������Ŀ
		//� Estrutura da Array _DELA013B �
		//� [1] := Orcamento 			 �
		//� [2] := Codido do Tecnico 	 �
		//� [3] := Nome do Tecnico   	 �
		//� [4] := Funcao 				 �
		//�������������������������������� 
		//���������������������������������������������������������������Ŀ
		//�Impede que seja carregado Item sem Funcao do Alinhador/Montador�
		//�����������������������������������������������������������������
		If !Empty(_DELA013B[nX,4]) 
			AaDD(aCols,{_DELA013B[nX,2],_DELA013B[nX,3],_DELA013B[nX,4],.F.})
		Endif
	Next   
Endif

//�������������������������������Ŀ
//�Definicoes de Resolucao da Tela�
//���������������������������������
aObjects := {}
AADD(aObjects,{100,100,.T.,.T.})
aPosObj := MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG oDlg TITLE "Equipe de Montagem - Or�amento: "+M->LQ_NUM From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	nOpc  := 3 
	oGetD   := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,cLinOk,cTudoOk,,.T.,,,,nLinhas,cFieldOk)
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| DELA013B(),Iif(P_DELA013E(),oDlg:End(),nil) },{||oDlg:End()},,aButtons)

//�����������������������������������������Ŀ
//�Restaura Configuracoes da aCols e aHeader�
//�������������������������������������������
aCols		:= aClone(_aCols)
aHeader		:= aClone(_aHeader)
n			:= _n

//���������������Ŀ
//�Restaura a area�
//�����������������
P_CtrlArea(2,_aArea,_aAlias)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA013B � Autor �Ricardo Mansano     � Data �  21/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Salva Array PUBLICA _DELA013B que foi criada no P.E.LJ7016 ���
���          � com os Dados da Equipe de Montagem e que sera usada no     ���
���          � P.E. LJ7002 para salvar as informacoes em PAB              ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �(.T.) Verdadeiro                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Venda Assistida (LJ701)                                    ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DELA013B()  

Local nX	:= 0    
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local nPosTec     	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_CODTEC" })
Local nPosNome    	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_NOMTEC" })
Local nPosFuncao  	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_FUNCAO" })
Local naCpo			:= Len(aCols)

	//�������������������������������������������������������������������������������������Ŀ
	//�Limpa Variavel Publica que Guardara ultima Equipe de Montagem para evitar Duplicidade�
	//���������������������������������������������������������������������������������������
	_DELA013B := {} 

	//������������������������������������������Ŀ
	//�Alimenta _DELA013B com aCols nao deletados�
	//��������������������������������������������
	For nX := 1 To naCols
		If !aCols[nX,naColsItem]                                                          
			//�����������������������������Ŀ
			//� Estrutura da Array aRet:    �
			//� [1] := Orcamento 			�
			//� [2] := Codido do Tecnico 	�
			//� [3] := Nome do Tecnico   	�
			//� [4] := Funcao 				�
			//�������������������������������
			//��������������������������������������������������������Ŀ
			//�Array utilizada no LJ7002 (P.E. Salvamento do Orcamento)�
			//����������������������������������������������������������
			AADD(_DELA013B,{M->LQ_NUM,aCols[nX,nPosTec],aCols[nX,nPosNome],aCols[nX,nPosFuncao]})
		EndIf
	Next nX 
                  
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA013C � Autor �Ricardo Mansano     � Data �  21/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � FieldOK da GetDados de Cadastro da Equipe de Montagem      ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   �.T. se todas as validacoes estiverem ok, .F. caso contrario ���
�������������������������������������������������������������������������͹��
���Aplicacao � Executada na digitacao de cada campo da getdados           ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA013C()                                   

Local lRet 			:= .T.
Local nX			:= 0
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local nPosTec     	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_CODTEC" })
Local nPosNome    	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_NOMTEC" })
Local nPosFuncao  	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_FUNCAO" })

P_CtrlArea(1,@_aArea,@_aAlias,{"SA3"})

	If ReadVar() = "M->PAB_CODTEC"
		
		//�������������������������������������������������������������������������Ŀ
		//�Verifica de A3_FILORI(Filial do Montador) eh a mesma da Filial em Questao�
		//���������������������������������������������������������������������������
		dbSelectArea("SA3")
		dbSetOrder(1) // A3_FILIAL + A3_COD

		//�������������������������������������������������Ŀ
		//�Localiza o tecnico no cadastro de Vendedores(SA3)�
		//���������������������������������������������������
		If dbSeek(xFilial("SA1")+&(ReadVar()))
			If SA3->A3_FILORIG <> xFilial("PAB")
				Aviso("Aten��o !!!","Alinhador/Montador n�o pertence a sua Loja  !!!",{" << Voltar"},2,"Alinhador/Montador !")
				lRet := .F.	
			Endif
		Endif   

		//��������������������������������������������Ŀ
		//�Verifica se Montador jah se encontra na Tela�
		//����������������������������������������������
		For nX := 1 To naCols
			If !aCols[nX,naColsItem]
				If (n <> nX) .and. (aCols[nX,nPosTec]==&(ReadVar()))
					Aviso("Aten��o !!!","Alinhador/Montador j� consta na lista !!!",{" << Voltar"},2,"Alinhador/Montador !")
					lRet := .F.	
				Endif	
			Endif
		Next nX	
	Endif

P_CtrlArea(2,_aArea,_aAlias)
	
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA013D � Autor �Ricardo Mansano     � Data �  23/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � LinOK da GetDados de Cadastro da Equipe de Montagem        ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   �.T. se todas as validacoes estiverem ok, .F. caso contrario ���
�������������������������������������������������������������������������͹��
���Aplicacao � Executado na mudanca de linha da GetDados                  ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA013D() 

Local lRet 			:= .T.
Local nPosFuncao  	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_FUNCAO" })

//��������������������������������������������������������������������Ŀ
//�Impede cadastro do Alinhador/Montador sem que se preencha sua Funcao�
//����������������������������������������������������������������������
If Empty(aCols[n,nPosFuncao])
	Aviso("Aten��o !!!","Preencha a Funcao deste profissional !!!",{" << Voltar"},2,"Alinhador/Montador !")
	lRet := .F.	
Endif
	
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA013E � Autor �Ricardo Mansano     � Data �  23/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � TudoOK da GetDados de Cadastro da Equipe de Montagem       ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �.T. se todas as validacoes estiverem ok, .F. caso contrario ���
�������������������������������������������������������������������������͹��
���Aplicacao � Executada apos informar todos os dados na getdados         ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA013E()                                     

Local lRet 			:= .T.
Local nX			:= 0
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local nPosFuncao  	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PAB_FUNCAO" })

//������������������������������������������������������������������Ŀ
//�Verifica se existe alguma linha da aCols sem PAB_FUNCAO preenchida�
//��������������������������������������������������������������������
For nX := 1 To naCols
	If !aCols[nX,naColsItem]
		If Empty(aCols[nX,nPosFuncao])
			Aviso("Aten��o !!!","Preencha todas as Fun��es !!!",{" << Voltar"},2,"Alinhador/Montador !")
			lRet := .F.	
		Endif	
	Endif
Next nX	
	
Return(lRet)

