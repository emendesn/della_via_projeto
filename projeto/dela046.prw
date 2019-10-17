#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA046   � Autor �Norbert Waage Junior� Data �  16/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Tela de cadastro de descontos por grupo de produtos e lojas ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo menu do sigaloja especifico.            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA046()

Private cCadastro := "Descontos por Grupo de produto"

Private aRotina := {{"Pesquisar","AxPesqui",0,1} ,;
					{"Visualizar","AxVisual",0,2} ,;
					{"Incluir","P_DELA046a",0,3} ,;
					{"Alterar","P_DELA046a",0,4} ,;
					{"Excluir","P_DELA046a",0,5} }
		
dbSelectArea("PAN")
dbSetOrder(1)
mBrowse(6,1,22,75,"PAN")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA046a  � Autor �Norbert Waage Junior� Data �  17/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Tela de edicao dos descontos por loja ou grupo de produtos  ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo mBrowse da rotina DELA046               ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA046a(cAlias, nReg, nOpcx)

Local nX
Local oLoja
Local oDesc
Local oNomLj
Local nOpca		:= 0
Local nPosDescr	:= 0
Local nPosCodGr	:= 0
Local cTitulo   := ""
Local cValid    := ""
Local lInc      := .F.
Local aSize     := {}
Local aObj      := {}
Local aInfo     := {}
Local aPosObj   := {}

//Private cNomLj		:= ""
//Private cLoja		:= Space(2)	//Loja
//Private nDesc		:= 0		//Desconto da loja
//Private nDvDesc  	:= 0        // Campo do usuario
Private aRecnos		:= {}		//Recnos dos itens da tela
Private _oDlg					//Objeto do dialogo
Private oGet1					//Objeto da getdados

If nOpcx == 3 // Inclusao
	lInc := .T.
Else
	lInc := .F.
EndIf

//����������������������Ŀ
//�Definicao da interface�
//������������������������
aAdd(aObj, {100, 033, .T., .T.})
aAdd(aObj, {100, 067, .T., .T.})

aSize   := msAdvSize(.T.)
aInfo   := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 3}
aPosObj := msObjSize(aInfo, aObj, .T., .F.)

// Cria as variaveis da Enchoice (M->?)
RegToMemory(cAlias, lInc, .T., lInc)

/*
ANTIGA TELA COM GETS FIXOS

DEFINE MSDIALOG _oDlg TITLE "Cadastro de descontos da venda assistida" FROM C(225),C(158) TO C(689),C(920) PIXEL

//Says
@ C(018),C(004) Say "Loja" Size C(012),C(008) PIXEL OF _oDlg
@ C(018),C(176) Say "% Desconto da Loja" Size C(049),C(008)  PIXEL OF _oDlg
      
//Gets
@ C(018),C(030) MsGet oLoja Var cLoja F3 "SM0" WHEN INCLUI Valid(ExistCpo("SM0",cEmpAnt+cLoja).And.;
	(SM0->M0_CODIGO == cEmpAnt) .And. ExistChav("PAN",cLoja) .And.;
	Eval({||cNomLj		:= GetAdvFVal("SM0","M0_NOME",cEmpAnt+cLoja,1,""),.T.}) );
	Size C(020),C(009)  PIXEL OF _oDlg   

@ C(018),C(229) MsGet oDesc Var nDesc Valid	(nDesc >= 0) Picture "@E 99.99" Size C(045),C(009)  PIXEL OF _oDlg
@ C(018),C(060) MsGet oNomLj Var cNomLj  WHEN .F. Size C(070),C(009)  PIXEL OF _oDlg

SX3->(dbSetOrder(2)) // X3_CAMPO
If SX3->(dbSeek("PAN_DVDESC"))
	@ C(028),C(004) Say rTrim(SX3->X3_TITULO) Size C(012),C(008) PIXEL OF _oDlg
	@ C(028),C(030) msGet nDvDesc Picture SX3->X3_PICTURE Valid &(SX3->X3_VLDUSER) Size C(030),C(009)  PIXEL OF _oDlg
EndIf
*/

Define msDialog _oDlg Title "Cadastro de descontos da venda assistida" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel
Enchoice(cAlias, nReg, nOpcx,,,,, aPosObj[1],, 3)

// GetDados
DELAGet1(aPosObj[2])      

//�������������������������������������������������Ŀ
//�Se n�o for inclusao, inicializa campos e getdados�
//���������������������������������������������������
If !INCLUI

	/*
	cLoja		:= PAN->PAN_CODFIL
	nDesc		:= PAN->PAN_DESCLJ
	cNomLj		:= PAN->PAN_NOMFIL
	nDvDesc  	:= PAN->PAN_DVDESC
	*/
	
	//����������������������������Ŀ
	//�Carrega conteudo da GetDados�
	//������������������������������
	P_LoadGD("PAO",@oGet1:aHeader,@oGet1:aCols,@aRecnos,1,PAN->(PAN_FILIAL+PAN_CODFIL))
	
	//������������������������Ŀ
	//�Atualiza campos virtuais�
	//��������������������������
	nPosDescr := aScan(oGet1:aHeader,{|x| AllTrim(x[2]) == "PAO_DESCRI"})
	nPosCodGr := aScan(oGet1:aHeader,{|x| AllTrim(x[2]) == "PAO_GRUPO"})
	
	//������������������������������������Ŀ
	//�Atualiza campos virtuais da getdados�
	//��������������������������������������
	For nX := 1 to Len(oGet1:aCols)
		oGet1:aCols[nX,nPosDescr] := GetAdvFVal("SBM","BM_DESC",xFilial("SBM")+oGet1:aCols[nX,nPosCodGr],1,"")
	Next nX
	
	//������������������������Ŀ
	//�Atualiza objeto getdados�
	//��������������������������
	oGet1:oBrowse:Refresh()

EndIf

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,{|| nOpca := 1,_oDlg:End()},{|| nOpca := 0,_oDlg:End()})

//Se o usuario confirmou
If ( nOpcA == 1 )
	GravaPAs()
EndIf	

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELAGet1  � Autor �Norbert Waage Junior� Data �  17/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Montagem da tela da GetDados                                ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo mBrowse da rotina DELA046               ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DELAGet1(aCoord)
// Variaveis deste Form                                                                                                         
Local nX			:= 0                                                                                                              
//�����������������������������������Ŀ
//� Variaveis da MsNewGetDados()      �
//�������������������������������������
// Vetor responsavel pela montagem da aHeader
Local aCpoGDa       := {"PAO_GRUPO","PAO_DESCRI","PAO_DESC","PAO_DVDESC"}                                                                                                 
Local nSuperior    	:= aCoord[1]        // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= aCoord[2]        // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= aCoord[3]        // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= aCoord[4]        // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE // Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local cLinhaOk     	:= "P_D046LOk"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "P_D046LOk"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local aAlter       	:= {"PAO_GRUPO","PAO_DESC","PAO_DVDESC"} // Vetor com os campos que poderao ser alterados
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99				// Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      

// Carrega aHead
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))                                                                                                 
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
	Endif                                                                                                                         
Next nX                                                                                                                         

// Montagem do acols
aAux := {}                                                                                                                      

For nX := 1 to Len(aCpoGDa)                                                                                                     
	If DbSeek(aCpoGDa[nX])                                                                                                        
		Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
	Endif                                                                                                                         
Next nX                                                                                                                         

Aadd(aAux,.F.)                                                                                                                  
Aadd(aCol,aAux)                                                                                                                 

oGet1:=MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,,;                               
                          aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,_oDlg,aHead,aCol)                                   
Return Nil                                                                                                                      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GDChvDup  �Autor  �Norbert Waage Junior� Data �  08/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Checa se existem itens duplicados em um aCols, retornando   ���
���          �.T. se houver duplicidade e .F. caso contrario.             ���
�������������������������������������������������������������������������͹��
���Parametros�aCposCh - Array de campos da chave. Ex: ("A1_COD","A1_LOJA"}���
���          �aH      - aHeader a ser considerado                         ���
���          �aC      - aCols a ser tratado                               ���
���          �nNAtu   - Numero da linha atual do aCols                    ���
�������������������������������������������������������������������������͹��
���Retorno   �.T. se houver duplicidade e .F. caso contrario.             ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao da linha                        ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GDChvDup(aCposCh,aH,aC,nNAtu)

Local lRet		:=	.F.
Local cChvAtu	:=	""
Local cChvCmp	:=	""
Local nX,nY

Default aH		:=	aHeader
Default	aC		:=	aCols
Default	nNAtu	:=	N

//�����������������������������������������������������������Ŀ
//�Percorre aCols, desde que a linha atual nao esteja deletada�
//�������������������������������������������������������������
If !aC[nNAtu][Len(aH)+1]

	//����������������������������Ŀ
	//�Monta a chave da linha atual�
	//������������������������������
	For nY := 1 to Len(aCposCh)
		cChvAtu += aC[nNAtu][aScan(aH,{|x| AllTrim(x[2]) == Alltrim(aCposCh[nY]) })]
	Next nY

	For nX := 1 to Len(aC)
		
		If !aC[nX][Len(aH)+1] 

			//������������������������������������Ŀ
			//�Monta a chave da linha de comparacao�
			//��������������������������������������
			For nY := 1 to Len(aCposCh)
				cChvCmp += aC[nX][aScan(aH,{|x| AllTrim(x[2]) == Alltrim(aCposCh[nY]) })]
			Next nY
		
			//�������������������������������������������������Ŀ
			//�Se as chaves forem identicas, fora da linha atual�
			//���������������������������������������������������
			If (cChvCmp == cChvAtu) .And. (nNAtu != nX)
	
				lRet	:= .T.
				nX		:= Len(aC)+1
	
			EndIf

			cChvCmp	:= ""
			
		EndIf
		
	Next nX
	
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �D046LOK   � Autor �Norbert Waage Junior� Data �  16/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina de validacao das linhas da getdados                  ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - (.T.)Se a linha for valida, (.F.) caso contrario     ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao da linha da getdados            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function D046LOk()

//Verifica duplicidades
Local lRet	:=	!GDChvDup({"PAO_GRUPO"},oGet1:aHeader,oGet1:aCols,oGet1:nAt)

If !lRet
	ApMsgAlert("N�o � permitido utilizar o mesmo grupo mais de uma vez","Aten��o")
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaPAS  � Autor �Norbert Waage Junior� Data �  16/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina de gravacao das tabelas utilizadas neste programa    ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao da linha da getdados            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaPAs()
Local aAreaSX3	:=	SX3->(GetArea())
Local aCposCh	:=	{}
Local i

//���������������������Ŀ
//�Inclusao ou alteracao�
//�����������������������
If Altera .Or. Inclui

	//������������������������Ŀ
	//�Atualizacao do CAbecalho�
	//��������������������������
	dbSelectArea("PAN")
	dbSetOrder(1)
	
	//������������������������������������������Ŀ
	//�RecLock considerando inclusao ou alteracao�
	//��������������������������������������������
	RecLock("PAN",!DbSeek(xFilial("PAN")+M->PAN_CODFIL))

	For i := 1 to fCount()
		If FieldName(i) == "PAN_FILIAL"
			PAN->PAN_FILIAL	:= xFilial("PAN")
		Else
			FieldPut(i, &("M->" + FieldName(i)))
		EndIf
	Next i
	
	/*
	PAN->PAN_FILIAL	:= xFilial("PAN")
	PAN->PAN_CODFIL	:= M->PAN_CODFIL
	PAN->PAN_DESCLJ	:= M->PAN_DESCLJ
	PAN->PAN_NOMFIL	:= M->PAN_NOMFIL
	PAN->PAN_DVDESC := M->PAN_DVDESC
	*/
	
	MsUnLock()
	
	//��������������������Ŀ
	//�Gravacao dos Grupos �
	//����������������������
	AAdd(aCposCh,{"PAO_LOJA",PAN->PAN_CODFIL})
	P_GetToFile("PAO",1,oGet1:aHeader,oGet1:aCols,aRecnos,aCposCh)

//��������Ŀ
//�Exclusao�
//����������
ElseIf !ALTERA .And. !INCLUI

	DbSelectArea("PAO")
	DbSetOrder(1)
	DbSeek(xFilial("PAO")+PAN->PAN_CODFIL)
	
	While !("PAO")->(Eof()) 		  		.And.;
		PAO->PAO_FILIAL	==	xFilial("PAO")	.And.;
		PAO->PAO_LOJA	==	PAN->PAN_CODFIL
		
		RecLock("PAO",.F.)
		DbDelete()
		MsUnLock()
		
		PAO->(DbSkip())
		
	End
	
	//���������������������Ŀ
	//�Apaga registro do PAD�
	//�����������������������
	DbSelectArea("PAN")
	RecLock("PAN",.F.)
	DbDelete()
	MsUnLock()

End
	
RestArea(aAreaSX3)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C        �Autor  �Norbert Waage Junior� Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para calculo de resolucao, utilizada para ajustar a  ���
���          �tela de acordo com a resolucao utilizada no monitor         ���
�������������������������������������������������������������������������͹��
���Parametros�nTam		= Valor de coordenada a ser convertido/ajustado   ���
�������������������������������������������������������������������������͹��
���Retorno   �nTam		= Valor convertido                                ���
�������������������������������������������������������������������������͹��
���Aplicacao �Esta rotina eh chamada para todas as coordenadas de tela u- ���
���          �tilizada neste programa, viabilizando assim a sua execucao  ���
���          �em qualquer resolucao de tela.                              ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C(nTam)                                                         
Local nHRes	:=	GetScreenRes()[1]	//Resolucao horizontal do monitor            
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
End Case                                                                        
//���������������������������Ŀ                                                 
//�Tratamento para tema "Flat"�                                                 
//�����������������������������                                                 
If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                            
   	nTam *= 0.90                                                               
EndIf                                                                           
Return Int(nTam)                                                                