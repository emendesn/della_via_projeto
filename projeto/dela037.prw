#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelA037   ºAutor  ³Norbert Waage Junior   º Data ³  13/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de encapsulamento da rotina padrao CRDA010, criada para º±±
±±º          ³a criacao de variaveis private utilizadas na rotina DELA037A,  º±±
±±º          ³que manipula as informacoes de referencia do cliente.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina chamada pelo menu SIGALOJA.XNU especifico               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelA037A  ºAutor  ³Norbert Waage Junior   º Data ³  13/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Tela de Referencias do cliente, acionada pelo botao criado na  º±±
±±º          ³tela de clientes do SigaCrd                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina chamada pelo P.E.: CRDCRIABUT                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DelA037A()

Local aArea		:=	GetArea()
Local aTitles   :=	{"Instituição","Empresa","Banco"}
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos que nao devem aparecer em cada GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aNaoG1 	:= {"AO_FILIAL","AO_CLIENTE","AO_LOJA","AO_TIPO","AO_TELEFONE","AO_CONTATO","AO_DESDE","AO_ULTCOM",;
			  		"AO_MAICOM","AO_VLRMAI","AO_PAGPON","AO_BCOCAR","AO_LIMCRE","AO_MOVCC","AO_OUTOPE" }
Local aNaoG2 	:= { "AO_FILIAL","AO_CLIENTE","AO_LOJA","AO_TIPO","AO_MOVCC","AO_OUTOPE" }
Local aNaoG3 	:= { "AO_FILIAL","AO_CLIENTE","AO_LOJA","AO_TIPO","AO_ULTCOM","AO_MAICOM","AO_VLRMAI","AO_PAGPON",;
                	 "AO_BCOCAR","AO_LIMCRE" }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicoes da GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nGd1	:=	5
nGd2	:=	5
nGd3	:=	110
nGd4	:=	310
                               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao de aHeader e aCols das GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! _lLoadHead 

	_aHead037	:=	{{},{},{}}
	_aCols037	:=	{{},{},{}} 
	_aRecn037	:=	{{},{},{}}
	
	MontaGet("SAO",aNaoG1,@_aHead037[1],@_aCols037[1])
	MontaGet("SAO",aNaoG2,@_aHead037[2],@_aCols037[2])
	MontaGet("SAO",aNaoG3,@_aHead037[3],@_aCols037[3])

	_lLoadHead	:=	.T.

EndIf
                          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega conteudo das GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Inclui .And. !_lLoaded
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega conteudo das GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	P_LoadGD("SAO", @_aHead037[1], @_aCols037[1], @_aRecn037[1], 1, xFilial("SAO")+SA1->A1_COD+SA1->A1_LOJA, "AO_TIPO=='1'")
	P_LoadGD("SAO", @_aHead037[2], @_aCols037[2], @_aRecn037[2], 1, xFilial("SAO")+SA1->A1_COD+SA1->A1_LOJA, "AO_TIPO=='2'")
	P_LoadGD("SAO", @_aHead037[3], @_aCols037[3], @_aRecn037[3], 1, xFilial("SAO")+SA1->A1_COD+SA1->A1_LOJA, "AO_TIPO=='3'")

	_lLoaded	:= .T.
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Importa dados ja armazenados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols1	:=	aClone(_aCols037[1])
aCols2	:=	aClone(_aCols037[2])
aCols3	:=	aClone(_aCols037[3])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define objeto da tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Referências do Cliente" From 0,0 To 300,650 OF oMainWnd PIXEL 

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria Folder³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oFold := TFolder():New(17,3,aTitles,,oDlg,,,,.T.,.F.,320,130)
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGet1 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4,IIF(!Inclui.And.!Altera,0,GD_INSERT+GD_UPDATE+GD_DELETE),{||.T.},"AllwaysTrue()" ,,/*alteraveis*/,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oFold:aDialogs[1],_aHead037[1],aCols1)
oGet2 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4,IIF(!Inclui.And.!Altera,0,GD_INSERT+GD_UPDATE+GD_DELETE),{||.T.},"AllwaysTrue()" ,,/*alteraveis*/,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oFold:aDialogs[2],_aHead037[2],aCols2)
oGet3 := MsNewGetDados():New(nGd1,nGd2,nGd3,nGd4,IIF(!Inclui.And.!Altera,0,GD_INSERT+GD_UPDATE+GD_DELETE),{||.T.},"AllwaysTrue()" ,,/*alteraveis*/,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oFold:aDialogs[3],_aHead037[3],aCols3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exibe a tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 0,ODlg:End()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o usuario confirmou, salvam-se os dados digitados nas³
//³variaveis private do programa DELA037, para gravacao na ³
//³confirmacao da tela, no ponto de entrada CRD010PG       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nOpcA == 1 )

	_aCols037[1] :=	aClone(oGet1:aCols)
	_aCols037[2] :=	aClone(oGet2:aCols)
	_aCols037[3] :=	aClone(oGet3:aCols)

EndIf	

Restarea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaGet  ºAutor  ³Norbert Waage Juniorº Data ³  10/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para gerar a o aCols e aHeader de acordo com o Alias º±±
±±º          ³recebido em parametros                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaGet(cAlias,aNaoCampos,aH,aC)

Local nPos

aH := {}
aC := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o aCols ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aC,Array(nUsado+1))
For nPos := 1 To nUsado
	aC[1][nPos] := CriaVar(aH[nPos][2])
Next
aC[1][nUsado+1] := .F.

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LoadGD    ºAutor  ³Norbert Waage Juniorº Data ³  07/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para carga do aCols da GetDados                      º±±
±±º          ³Parametros:                                                 º±±
±±º          ³cAlias  - Alias trabalhado                                  º±±
±±º          ³aH      - Array do aHeader recebido por referencia          º±±
±±º          ³aC      - Array do aCols recebido por referencia            º±±
±±º          ³aRecnos - Array que armazena os Recnos receb. por referenciaº±±
±±º          ³nIndChv - Chave do indice a ser considerada para pesquisa   º±±
±±º          ³cChave  - Valor da chave de pesquisa no indice              º±±
±±º          ³cFiltro - Filtro da selecao                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara Filtro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cFiltro == NIL .or. Empty(cFiltro)
	cFiltro := ".T."
EndIf

cFiltro := "(" + AllTrim(cFiltro) + ")"

//ÚÄÄÄÄÄÄÄÄÄ¿
//³Abre area³
//ÀÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
DbSetOrder(nIndChv)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le chave do indice³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndKey := (cAlias)->(IndexKey())

If DbSeek(cChave)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Percorre area, carregando os campos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(cAlias)->(Eof()) .And. SubStr((cAlias)->(&(cIndKey)),1,nLenChave) ==  cChave
	     
		If &cFiltro

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa aCols³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd(aColsTmp,Array(nUsado+1))
			nLin++
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inicializa campos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nPos := 1 To nUsado
				If aH[nPos][10] == "V"
					aColsTmp[nLin][nPos] := CriaVar(aH[nPos][2])
				Else
					aColsTmp[nLin][nPos] := (cAlias)->(&(aH[nPos][2]))
					M->(&(aH[nPos][2])) := (cAlias)->(&(aH[nPos][2]))
				EndIf
			Next
	
			aColsTmp[nLin][nUsado+1] := .F.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Armazena Recno³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AAdd(aRecnos,(cAlias)->(Recno()))
		    
	    EndIf
		
		(cAlias)->(DbSkip())
		
	End
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se algum dado foi encontrado, regrava o aCols atual³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 0
	aC	:=	{}
	aC	:=	aClone(aColsTmp)
EndIf

RestArea(aArea)

Return Nil