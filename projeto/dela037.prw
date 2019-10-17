#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA037   �Autor  �Norbert Waage Junior   � Data �  13/07/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de encapsulamento da rotina padrao CRDA010, criada para ���
���          �a criacao de variaveis private utilizadas na rotina DELA037A,  ���
���          �que manipula as informacoes de referencia do cliente.          ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo menu SIGALOJA.XNU especifico               ���
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
Project Function DelA037()
	
Private _aHead037	:=	{{},{},{}}		//Armazena os aHeaders
Private _aCols037	:=	{{},{},{}} 	//Armazena os aCols
Private _aRecn037	:=	{{},{},{}}		//Armazena os Recnos
Private _lLoaded	:=	.F.				//Controla carga do aHeader/aCols
Private _lLoadHead	:=	.F.				//Controla carga do aHeader/aCols

CRDA010()								//Chamada da rotina pardrao

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA037A  �Autor  �Norbert Waage Junior   � Data �  13/07/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Tela de Referencias do cliente, acionada pelo botao criado na  ���
���          �tela de clientes do SigaCrd                                    ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo P.E.: CRDCRIABUT                           ���
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
Project Function DelA037A()

Local aArea		:=	GetArea()
Local aTitles   :=	{"Institui��o","Empresa","Banco"}
Local oDlg		:=	NIL
Local oFold		:=	NIL
Local oGet1		:=	NIL
Local oGet2		:=	NIL
Local oGet3		:=	NIL
Local aCols1	:=	{}
Local aCols2	:=	{}
Local aCols3	:=	{}

Local nGd1,nGd2,nGd3,nGd4 
Local nOpcA		:=	0

//����������������������������������������������Ŀ
//�Campos que nao devem aparecer em cada GetDados�
//������������������������������������������������
Local aNaoG1 	:= {"AO_FILIAL","AO_CLIENTE","AO_LOJA","AO_TIPO","AO_TELEFONE","AO_CONTATO","AO_DESDE","AO_ULTCOM",;
			  		"AO_MAICOM","AO_VLRMAI","AO_PAGPON","AO_BCOCAR","AO_LIMCRE","AO_MOVCC","AO_OUTOPE" }
Local aNaoG2 	:= { "AO_FILIAL","AO_CLIENTE","AO_LOJA","AO_TIPO","AO_MOVCC","AO_OUTOPE" }
Local aNaoG3 	:= { "AO_FILIAL","AO_CLIENTE","AO_LOJA","AO_TIPO","AO_ULTCOM","AO_MAICOM","AO_VLRMAI","AO_PAGPON",;
                	 "AO_BCOCAR","AO_LIMCRE" }

//��������������������Ŀ
//�Posicoes da GetDados�
//����������������������
nGd1	:=	5
nGd2	:=	5
nGd3	:=	110
nGd4	:=	310
                               
//���������������������������������������Ŀ
//�Criacao de aHeader e aCols das GetDados�
//�����������������������������������������
If ! _lLoadHead 

	_aHead037	:=	{{},{},{}}
	_aCols037	:=	{{},{},{}} 
	_aRecn037	:=	{{},{},{}}
	
	MontaGet("SAO",aNaoG1,@_aHead037[1],@_aCols037[1])
	MontaGet("SAO",aNaoG2,@_aHead037[2],@_aCols037[2])
	MontaGet("SAO",aNaoG3,@_aHead037[3],@_aCols037[3])

	_lLoadHead	:=	.T.

EndIf
                          
//�����������������������������Ŀ
//�Carrega conteudo das GetDados�
//�������������������������������
If !Inclui .And. !_lLoaded
	
	//�����������������������������Ŀ
	//�Carrega conteudo das GetDados�
	//�������������������������������
	P_LoadGD("SAO", @_aHead037[1], @_aCols037[1], @_aRecn037[1], 1, xFilial("SAO")+SA1->A1_COD+SA1->A1_LOJA, "AO_TIPO=='1'")
	P_LoadGD("SAO", @_aHead037[2], @_aCols037[2], @_aRecn037[2], 1, xFilial("SAO")+SA1->A1_COD+SA1->A1_LOJA, "AO_TIPO=='2'")
	P_LoadGD("SAO", @_aHead037[3], @_aCols037[3], @_aRecn037[3], 1, xFilial("SAO")+SA1->A1_COD+SA1->A1_LOJA, "AO_TIPO=='3'")

	_lLoaded	:= .T.
	
EndIf

//����������������������������Ŀ
//�Importa dados ja armazenados�
//������������������������������
aCols1	:=	aClone(_aCols037[1])
aCols2	:=	aClone(_aCols037[2])
aCols3	:=	aClone(_aCols037[3])

//���������������������Ŀ
//�Define objeto da tela�
//�����������������������
DEFINE MSDIALOG oDlg TITLE "Refer�ncias do Cliente" From 0,0 To 300,650 OF oMainWnd PIXEL 

//�����������Ŀ
//�Cria Folder�
//�������������
oFold := TFolder():New(17,3,aTitles,,oDlg,,,,.T.,.F.,320,130)
            
//����������������Ŀ
//�Cria as GetDados�
//������������������
oGet1 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4,IIF(!Inclui.And.!Altera,0,GD_INSERT+GD_UPDATE+GD_DELETE),{||.T.},"AllwaysTrue()" ,,/*alteraveis*/,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oFold:aDialogs[1],_aHead037[1],aCols1)
oGet2 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4,IIF(!Inclui.And.!Altera,0,GD_INSERT+GD_UPDATE+GD_DELETE),{||.T.},"AllwaysTrue()" ,,/*alteraveis*/,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oFold:aDialogs[2],_aHead037[2],aCols2)
oGet3 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4,IIF(!Inclui.And.!Altera,0,GD_INSERT+GD_UPDATE+GD_DELETE),{||.T.},"AllwaysTrue()" ,,/*alteraveis*/,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oFold:aDialogs[3],_aHead037[3],aCols3)

//������������Ŀ
//�Exibe a tela�
//��������������
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 0,ODlg:End()})

//��������������������������������������������������������Ŀ
//�Se o usuario confirmou, salvam-se os dados digitados nas�
//�variaveis private do programa DELA037, para gravacao na �
//�confirmacao da tela, no ponto de entrada CRD010PG       �
//����������������������������������������������������������
If ( nOpcA == 1 )

	_aCols037[1] :=	aClone(oGet1:aCols)
	_aCols037[2] :=	aClone(oGet2:aCols)
	_aCols037[3] :=	aClone(oGet3:aCols)

EndIf	

Restarea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaGet  �Autor  �Norbert Waage Junior� Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para gerar a o aCols e aHeader de acordo com o Alias ���
���          �recebido em parametros                                      ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaGet(cAlias,aNaoCampos,aH,aC)

Local nPos

aH := {}
aC := {}

//������������Ŀ
//�Cria aHeader�
//��������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
nUsado := 0
While !EOF() .And. (x3_arquivo == cAlias)
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Empty( AScan( aNaoCampos, { |x| x == AllTrim(SX3->X3_CAMPO) } ) )
		nUsado++
		AADD(aH,{ TRIM(x3titulo()), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_f3, x3_context } )
	EndIf
	dbSkip()
End    

//�������������Ŀ
//�Cria o aCols �
//���������������
Aadd(aC,Array(nUsado+1))
For nPos := 1 To nUsado
	aC[1][nPos] := CriaVar(aH[nPos][2])
Next
aC[1][nUsado+1] := .F.

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LoadGD    �Autor  �Norbert Waage Junior� Data �  07/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para carga do aCols da GetDados                      ���
���          �Parametros:                                                 ���
���          �cAlias  - Alias trabalhado                                  ���
���          �aH      - Array do aHeader recebido por referencia          ���
���          �aC      - Array do aCols recebido por referencia            ���
���          �aRecnos - Array que armazena os Recnos receb. por referencia���
���          �nIndChv - Chave do indice a ser considerada para pesquisa   ���
���          �cChave  - Valor da chave de pesquisa no indice              ���
���          �cFiltro - Filtro da selecao                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function LoadGD(cAlias,aH,aC,aRecnos,nIndChv,cChave,cFiltro)

Local aArea		:=	GetArea()
Local aColsTmp	:=	{}
Local cIndKey	:=	""
Local aLinha	:=	{}
Local nUsado	:=	Len(aH)
Local nPos		:=	0
Local nLin 		:=	0
Local nLenChave	:=	Len(cChave)

//��������������Ŀ
//�Prepara Filtro�
//����������������
If cFiltro == NIL .or. Empty(cFiltro)
	cFiltro := ".T."
EndIf

cFiltro := "(" + AllTrim(cFiltro) + ")"

//���������Ŀ
//�Abre area�
//�����������
DbSelectArea(cAlias)
DbSetOrder(nIndChv)

//������������������Ŀ
//�Le chave do indice�
//��������������������
cIndKey := (cAlias)->(IndexKey())

If DbSeek(cChave)
	
	//�����������������������������������Ŀ
	//�Percorre area, carregando os campos�
	//�������������������������������������
	While !(cAlias)->(Eof()) .And. SubStr((cAlias)->(&(cIndKey)),1,nLenChave) ==  cChave
	     
		If &cFiltro

			//����������������Ŀ
			//�Incrementa aCols�
			//������������������
			Aadd(aColsTmp,Array(nUsado+1))
			nLin++
			
			//�����������������Ŀ
			//�Inicializa campos�
			//�������������������
			For nPos := 1 To nUsado
				If aH[nPos][10] == "V"
					aColsTmp[nLin][nPos] := CriaVar(aH[nPos][2])
				Else
					aColsTmp[nLin][nPos] := (cAlias)->(&(aH[nPos][2]))
					M->(&(aH[nPos][2])) := (cAlias)->(&(aH[nPos][2]))
				EndIf
			Next
	
			aColsTmp[nLin][nUsado+1] := .F.
			
			//��������������Ŀ
			//�Armazena Recno�
			//����������������
			AAdd(aRecnos,(cAlias)->(Recno()))
		    
	    EndIf
		
		(cAlias)->(DbSkip())
		
	End
	
EndIf

//���������������������������������������������������Ŀ
//�Se algum dado foi encontrado, regrava o aCols atual�
//�����������������������������������������������������
If nLin > 0
	aC	:=	{}
	aC	:=	aClone(aColsTmp)
EndIf

RestArea(aArea)

Return Nil