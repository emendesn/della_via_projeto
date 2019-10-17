#INCLUDE "TMKA274.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TMKDEF.CH"
#INCLUDE "AP5MAIL.CH"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �TMKA274   �Autor  �Rafael M. Quadrotti  � Data �  06/03/02   ���
��������������������������������������������������������������������������͹��
���Descricao �Este fonte possui somente funcoes de uso exclusivo           ���
���          �do atendimento TELECOBRANCA                                  ���
��������������������������������������������������������������������������͹��
���Uso       �Telecobranca 						                           ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao	 �Tk271Htlc � Autor � Marcelo Kotaki        � Data � 29/11/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Hist�rico das liga�oes do Cliente na Telecobranca          ���
�������������������������������������������������������������������������Ĵ��
���Uso    	 � Telecobranca           									  ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���Armando T.�18/07/03�710   �-Revisao da Consulta de Historico           ���
���Andrea F. �08/07/05�811   �BOPS 83837 - Nao carregar os dados do histo-���
���          �        �      �rico se o operador abriu a tela do atendi-  ���
���          �        �      �mento atraves do pre-atendimento.           ���
���Marcelo K.�09/08/05�8.11  �-Incluida a limpeza do rodape Telecobranca. ���
���          �86209   �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Htlc(nOpc,lHabilita,oFolderTlc,oEnchTlc)

Local aArea		:= GetArea()						// Salva a area atual	
Local oDlgHist                                      // Tela
Local oObsMemo										// Objeto Memo da observacao
Local cObsMemo 	:= ""								// Variavel com a descricao da observacao
Local oEnceMemo										// Objeto Memo da observacao
Local cEnceMemo	:= ""								// Variavel com a descricao da observacao
Local oCancMemo										// Objeto Memo da observacao
Local cCancMemo	:= ""								// Variavel com a descricao da observacao
Local oMonoAs  	:= TFont():New( "Courier New",6,0)	// Fonte para o campo Memo
Local aHeadACF	:= {}								// aHeader do ACF 	- CABECALHO
Local aColsACF	:= {}								// aCols do ACF
Local oGetACF										// NewGet do ACF

Local aHeadACG	:= {}								// aHeader do ACG	- ITENS	
Local aColsACG	:= {}								// aCols do ACG
Local oGetACG										// NewGet do ACG

Local nPCodigo	:= 0								// Codigo do Atendimento
Local nUsado	:= 0								// Contador para o Acols/Aheader

Local nI		:= 0 								// Contador
Local lAux		:= INCLUI							// Variavel de auxilio

Local aRdpTlc	:= Array(12,2)
Local oFolderRdp									// Objeto FOLDER para os totais
Local nRow 		:= 0								// variavel auxiliar para calculo do tamanho da LINHA
Local nCol 		:= 0								// variavel auxiliar para calculo do tamanho da COLUNA
Local nOpcA     := 0 								// Flag para controlar se o Operador clicou em OK ou CANCELA
Local cPerg		:= "TMKH03"                         // Pergunte exibida para filtrar os atendimentos exibidos no historico

#IFDEF TOP
	Local cQuery	:= ""							// Variavel para composicao do SELECT
	Local aStruct	:= ACF->(DbStruct())			// Array com a estrutura do ACF
#ENDIF
                          
If !Pergunte(cPerg,.T.) 
    RestArea(aArea)
	Return(.F.)
Endif	
//������������������������������������������������������������������������������Ŀ
//�Pergunte - TMKH03                                                             �
//�MV_PAR01 - Da Emissao                                                         �
//�MV_PAR02 - Ate a Emiss�o                                                      �
//�MV_PAR03 - Do Operador                                                        �
//�MV_PAR04 - Ate o Operador                                                     �
//�MV_PAR05 - Status: (1-Todos 2-Atendimento 3-Cobranca 4-Encerrado  			 �
//�MV_PAR06 - Ligacao:(1-Ambos 2-Receptivo 3-Ativo)							     �
//�MV_PAR07 - Ocorrencia                                                         �
//��������������������������������������������������������������������������������

CursorWait()

//������������������������������Ŀ
//�Carrega o aHeader do cabecalho�
//��������������������������������
DbSelectArea("SX3")
DbSetOrder(1)
MsSeek("ACF")
Aadd(aHeadACF,	{"","CHECKBOL","@BMP",20,00,,,"C",,"V" } )
nUsado++
While !Eof() .AND. SX3->X3_ARQUIVO == "ACF"
	If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. X3_CAMPO <> "ACF_OBS"
		Aadd(aHeadACF, {   	AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
		nUsado++
	Endif
	DbSelectArea("SX3")
	DbSkip()
End

If Len(aHeadACF) > 0 
	nPCodigo := Ascan(aHeadACF, {|x| AllTrim(x[2])=="ACF_CODIGO"} )
Endif

DbSelectArea("ACF")
DbSetOrder(2)	// ACF_CLIENT+ACF_LOJA
#IFDEF TOP
	cQuery	:=	" SELECT	* " +;
				" FROM " +	RetSqlName("ACF") + " ACF " +;
				" WHERE	ACF.ACF_FILIAL = '" + xFilial("ACF") + "' AND" +;
				"		ACF.ACF_CLIENT = '" + M->ACF_CLIENT + "' AND" +;
				"		ACF.ACF_LOJA = '" + M->ACF_LOJA + "' AND" +;
				"		ACF.ACF_DATA 	BETWEEN '" + DTOS(MV_PAR01) + "' AND  '" + DTOS(MV_PAR02) + "' AND " +;
				"		ACF.ACF_OPERAD 	BETWEEN '" + MV_PAR03 + "' AND  '" + MV_PAR04 + "' AND " 
		If MV_PAR05 <> 1 //Todas
			cQuery += 	"ACF.ACF_STATUS = '" + STR(MV_PAR05-1,1) + "' AND "
		Endif

        If MV_PAR06 <> 1 //Todos
           	cQuery += 	"ACF.ACF_OPERA = '" + STR(MV_PAR06-1,1) + "' AND "   
		Endif

        If !Empty(MV_PAR07)//Ocorrencia 
           	cQuery += 	"ACF.ACF_MOTIVO = '"+ MV_PAR07 + "' AND "  
		Endif
		
		cQuery +=" ACF.D_E_L_E_T_ = ' '" 
		cQuery +=" ORDER BY " + SqlOrder(IndexKey())
				
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TK274HTLC.SQL", cQuery)
	DbSelectArea("ACF")
	DbCloseArea()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'ACF', .F., .T.)
		
	For nI := 1 To Len(aStruct)
		If aStruct[nI][2] $ "NDL"
			TCSetField("ACF", aStruct[nI][1], aStruct[nI][2], aStruct[nI][3], aStruct[nI][4])
		Endif
	Next nI
#ELSE
	MsSeek(xFilial("ACF") + M->ACF_CLIENT + M->ACF_LOJA)
#ENDIF

INCLUI := .F.
While	!Eof()								.AND.;
		ACF->ACF_FILIAL == xFilial("ACF")	.AND.;
		ACF->ACF_CLIENT == M->ACF_CLIENT	.AND.;
		ACF->ACF_LOJA 	== M->ACF_LOJA
	
	#IFNDEF TOP
		//��������������������������������������������Ŀ
		//�Verifica o intervalo de datas do atendimento�
		//����������������������������������������������
		If ACF->ACF_DATA < MV_PAR01 .OR. ACF->ACF_DATA > MV_PAR02
			Dbselectarea("ACF") 
			Dbskip()
			Loop
		Endif

		//��������������������������������������������Ŀ
		//�Verifica o intervalo de codigos do operador �
		//����������������������������������������������
		If ACF->ACF_OPERAD < MV_PAR03 .OR. ACF->ACF_OPERAD > MV_PAR04
			Dbselectarea("ACF")  
			Dbskip()
			Loop
		Endif
    		
    	If MV_PAR05 <> 1 //Todas (Status)
    		If ACF->ACF_STATUS <> STR(MV_PAR05-1,1)
    			Dbselectarea("ACF") 
		   		Dbskip()
				Loop					 
			Endif
		Endif
					
		If MV_PAR06 <> 1 //Ambas
			If MV_PAR06 == 2 .AND. ACF->ACF_OPERA <> "1" //Receptivo
				Dbselectarea("ACF") 
				Dbskip()
				Loop					 
	    	ElseIf MV_PAR06 == 3 .AND. ACF->ACF_OPERA <> "2"//Ativo
    			Dbselectarea("ACF") 
				Dbskip()
				Loop					 
            Endif           
        Endif    

		//������������������������������������������Ŀ
		//�Filtra a ocorrencia informada no parametro�
		//��������������������������������������������
        If !Empty(MV_PAR07)
        	If ACF->ACF_MOTIVO <> MV_PAR07
        		DbSelectarea("ACF") 
        		Dbskip()
        		Loop
        	Endif
        Endif
    #ENDIF
	
	//�������������������������������������Ŀ
	//�Inicializa o ACOLS do ACF - Cabecalho�
	//���������������������������������������
	Aadd(aColsACF,Array(nUsado+1))
	For nI := 1 TO nUsado
		If nI <> 1
			If ( aHeadACF[nI][10] <>  "V" )
				aColsACF[Len(aColsACF)][nI] := FieldGet(FieldPos(aHeadACF[nI][2]))
			Else
				aColsACF[Len(aColsACF)][nI] := CriaVar(aHeadACF[nI][2],.T.)
			Endif
		Else
			Do Case
				Case (EMPTY(ACF->ACF_CCANC) .AND. VAL(ACF->ACF_STATUS) == 1)
					aColsACF[Len(aColsACF)][nI] := "BR_AZUL"
			   
				Case (EMPTY(ACF->ACF_CCANC) .AND. VAL(ACF->ACF_STATUS) == 2)
					aColsACF[Len(aColsACF)][nI] := "BR_VERDE"               
					
				Case (EMPTY(ACF->ACF_CCANC) .AND. VAL(ACF->ACF_STATUS) == 3)
					aColsACF[Len(aColsACF)][nI] := "BR_VERMELHO"
					
				Case (!EMPTY(ACF->ACF_CCANC))
					aColsACF[Len(aColsACF)][nI] := "BR_CINZA"
			EndCase
		Endif
	Next nI   
		
	aColsACF[Len(aColsACF)][nUsado+1] := .F.
		
	DbSelectArea("ACF")
	DbSkip()
End
INCLUI := lAux
	
#IFDEF TOP
	DbSelectArea("ACF")
	DbCloseArea()
	ChkFile("ACF")
#ENDIF
	
//������������������������������������������������������������������Ŀ
//�Se nao houver Historico anterior de atendimento exibe a tela vazia�
//��������������������������������������������������������������������
If Empty(aColsACF)
//	Help( " ",1,"VAZIO")

	Aadd(aColsACF,Array(nUsado+1))
	For nI := 1 To nUsado
		If nI <> 1
			aColsACF[Len(aColsACF)][nI] := CriaVar(aHeadACF[nI,2],.F.)
		Else
			aColsACF[Len(aColsACF)][nI] := "BR_VERDE"	
		Endif		
	Next nI
	aColsACF[Len(aColsACF)][nUsado+1] := .F.
Endif

CursorArrow()

//��������������������������������������������������������������Ŀ
//� Mostra dados do Produto.								     �
//����������������������������������������������������������������
DEFINE MSDIALOG oDlgHist FROM 0,0 TO 550,750 TITLE STR0001 + ": " + M->ACF_DESC PIXEL  //"Historico" 
	
	EnchoiceBar(oDlgHist,{|| (nOpcA := 1,oDlgHist:End())},{|| oDlgHist:End()} ) //  Botao de OK , Botao de CANCELA		

	// Cabecalho
	oGetACF := MsNewGetDados():New(17,05,72,375,0,,,,,,4096,,,,oDlgHist,aHeadACF,aColsACF)
	oGetACF:bChange := {|| Tk274HACG(@oGetACG:aHeader, @oGetACG:aCols, oGetACF:aCols[oGetACF:nAt][nPCodigo], @cObsMemo, @cEnceMemo, @cCancMemo, @aRdpTlc),;
							oObsMemo:Refresh(),;
							oEnceMemo:Refresh(),;
							oCancMemo:Refresh(),;
							oGetACG:Refresh() }

	// Itens do Cabecalho
	Tk274HACG(@aHeadACG, @aColsACG, M->ACF_CODIGO)
	oGetACG := MsNewGetDados():New(75,05,130,370,0,,,,,,4096,,,,oDlgHist,aHeadACG,aColsACG)
	
	@ 135,05 FOLDER oFolderRdp ITEMS STR0104,STR0105 OF oDlgHist SIZE 365,60 PIXEL //"Varia��es"###"Saldos"
	nRow := (oFolderRdp:nHeight*.9)/2
	nCol := oFolderRdp:nWidth/2
	
	//������������������������������Ŀ
	//�Limpa o rodape de Telecobranca�
	//��������������������������������
	Tk274LimpaRdp()
	
	//��������������������������������������Ŀ
	//�VARIACOES                             �
	//����������������������������������������
	@ nRow*.10,nCol*.02  SAY STR0106 OF oFolderRdp:aDialogs[1] PIXEL //"Abatimentos"
	@ nRow*.10,nCol*.22  MSGET aRdpTlc[1][1] VAR aRdpTlc[1][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[1] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.35,nCol*.02 SAY STR0107 OF oFolderRdp:aDialogs[1] PIXEL //"Corre��es Monet�ria"
	@ nRow*.35,nCol*.22 MSGET aRdpTlc[2][1] VAR aRdpTlc[2][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[1] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.60,nCol*.02 SAY STR0108 OF oFolderRdp:aDialogs[1] PIXEL //"Juros"
	@ nRow*.60,nCol*.22 MSGET aRdpTlc[3][1] VAR aRdpTlc[3][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[1] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.10,nCol*.52  SAY STR0109 OF oFolderRdp:aDialogs[1] PIXEL //"Acr�scimos"
	@ nRow*.10,nCol*.72  MSGET aRdpTlc[4][1] VAR aRdpTlc[4][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[1] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.35,nCol*.52 SAY STR0110 OF oFolderRdp:aDialogs[1] PIXEL //"Decr�scimos"
	@ nRow*.35,nCol*.72 MSGET aRdpTlc[5][1] VAR aRdpTlc[5][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[1] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.60,nCol*.52 SAY STR0111 OF oFolderRdp:aDialogs[1] PIXEL //"Descontos"
	@ nRow*.60,nCol*.72 MSGET aRdpTlc[6][1] VAR aRdpTlc[6][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[1] PIXEL READONLY SIZE 70 ,9
	
	//��������������������������������������Ŀ
	//�SALDOS                                �
	//����������������������������������������
	@ nRow*.10,nCol*.02  SAY STR0112 OF oFolderRdp:aDialogs[2] PIXEL //"Valores Originais"
	@ nRow*.10,nCol*.22  MSGET aRdpTlc[7][1] VAR aRdpTlc[7][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[2] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.35,nCol*.02 SAY STR0113 OF oFolderRdp:aDialogs[2] PIXEL //"Saldos Moeda Titulo"
	@ nRow*.35,nCol*.22 MSGET aRdpTlc[8][1] VAR aRdpTlc[8][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[2] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.60,nCol*.02 SAY STR0114 OF oFolderRdp:aDialogs[2] PIXEL //"Saldos Moeda Corrente"
	@ nRow*.60,nCol*.22 MSGET aRdpTlc[9][1] VAR aRdpTlc[9][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[2] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.10,nCol*.52  SAY STR0115 OF oFolderRdp:aDialogs[2] PIXEL //"Pagamentos Parciais"
	@ nRow*.10,nCol*.72  MSGET aRdpTlc[10][1] VAR aRdpTlc[10][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[2] PIXEL READONLY SIZE 70 ,9
	
	@ nRow*.35,nCol*.52 SAY STR0116 OF oFolderRdp:aDialogs[2] PIXEL COLOR CLR_RED //"D�vida Moeda T�tulo"
	@ nRow*.35,nCol*.72 MSGET aRdpTlc[11][1] VAR aRdpTlc[11][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[2] PIXEL READONLY SIZE 70 ,9 COLOR CLR_RED
	
	@ nRow*.60,nCol*.52 SAY STR0117 OF oFolderRdp:aDialogs[2] PIXEL COLOR CLR_RED //"D�vida Moeda Corrente"
	@ nRow*.60,nCol*.72 MSGET aRdpTlc[12][1] VAR aRdpTlc[12][2] Picture "@E 999,999,999.99" OF oFolderRdp:aDialogs[2] PIXEL READONLY SIZE 70 ,9 COLOR CLR_RED
	
	//Observacao da ligacao
	@ 202,02 TO 248,122 LABEL STR0118 OF oDlgHist PIXEL //"Observa��o da liga��o"
	@ 210,05 GET oObsMemo VAR cObsMemo OF oDlgHist MEMO SIZE 114,35 PIXEL READONLY
	oObsMemo:oFont := oMonoAs
	oObsMemo:bRClicked := {|| AllwaysTrue() }
	
	//Motivo do Encerramento - Se a liga��o for encerrada
	@ 202,125 TO 248,245 LABEL STR0119 OF oDlgHist PIXEL //"Motivo do Encerramento"
	@ 210,128 GET oEnceMemo VAR cEnceMemo OF oDlgHist MEMO SIZE 114,35 PIXEL READONLY
	oEnceMemo:oFont := oMonoAs
	oEnceMemo:bRClicked := {|| AllwaysTrue() }
	
	//Motivo do Cancelamento - Se a liga��o for cancelada
	@ 202,249 TO 248,373 LABEL STR0120 OF oDlgHist PIXEL //"Motivo do Cancelamento"
	@ 210,252 GET oCancMemo VAR cCancMemo OF oDlgHist MEMO SIZE 114,35 PIXEL READONLY
	oCancMemo:oFont := oMonoAs
	oCancMemo:bRClicked := {|| AllwaysTrue() }
	
	// Legendas da Tela
	@ 255,05 BITMAP ResName "BR_AZUL" OF oDlgHist Size 10,10 NoBorder Pixel
	@ 255,15 SAY STR0121 OF oDlgHist Color CLR_BLUE,CLR_WHITE PIXEL //"Atendimento"

	@ 255,60 BITMAP ResName "BR_VERDE" OF oDlgHist Size 10,10 NoBorder Pixel 
	@ 255,70 SAY STR0122 OF oDlgHist Color CLR_GREEN,CLR_WHITE PIXEL //"Cobran�a"

	@ 255,115 BITMAP ResName "BR_VERMELHO" OF oDlgHist Size 10,10 NoBorder Pixel 
	@ 255,125 SAY STR0123 OF oDlgHist Color CLR_RED,CLR_WHITE PIXEL //"Encerrada"

	@ 255,170 BITMAP ResName "BR_CINZA" OF oDlgHist Size 10,10 NoBorder Pixel
	@ 255,180 SAY STR0124 OF oDlgHist Color CLR_GRAY,CLR_WHITE PIXEL //"Cancelado"
	
ACTIVATE MSDIALOG oDlgHist CENTER

//������������������������������������������������������������������������������������������Ŀ
//�Se o Operador confirmou a alteracao do Historico e nao esta na rotina de pre-atendimento. �
//��������������������������������������������������������������������������������������������
If nOpcA == 1 .AND. FUNNAME() <> "TMKA280"
	cNumTlc:= ACF->ACF_CODIGO
	Tk274NumTlc(@nOpc,cNumTlc,@lHabilita,@oFolderTlc,@oEnchTlc)
Endif

RestArea(aArea)
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274HACG �Autor  �Armando Tessaroli   � Data �  18/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega os itens do ACG de acordo com o ACF selecionado     ���
���          �na consulta de historico de cobranca                        ���
�������������������������������������������������������������������������͹��
���Uso       � SOMENTE TELECOBRANCA                                       ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �24/04/04�811   �- Posicoes 4 e 5 do array Avalores substi-  ���
���          �        �      �tuidas pelos campos E1_SDACRES e E1_SDDECRE ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk274HACG(	aHeadNew,	aColsNew,	cCodigo,	cObsMemo,;
							cEnceMemo,	cCancMemo,	aRdpTlc)

Local nUsado	:= 0
Local nI		:= 0
Local lAux		:= INCLUI
Local aValores	:= {}
Local nPPrefix	:= 0
Local nPTitulo	:= 0
Local nPParcel	:= 0
Local nPTipo	:= 0
Local nPFilOrig := 0 
Local cFilOrig	:= ""

#IFDEF TOP
	Local cQuery	:= ""
	Local aStruct	:= ACG->(DbStruct())
#ENDIF

// Limpa os dados carregados no aCols
aColsNew	:= {}

//������������������������������Ŀ
//�Limpa o rodape de Telecobranca�
//��������������������������������
Tk274LimpaRdp()


If Empty(aHeadNew)
	DbSelectArea("SX3")
	DbSetOrder(1)
	MsSeek("ACG")
	While !Eof() .AND. SX3->X3_ARQUIVO == "ACG"
		If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			Aadd(aHeadNew, {   	AllTrim(X3Titulo()),;
								SX3->X3_CAMPO,;
								SX3->X3_PICTURE,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								SX3->X3_VALID,;
								SX3->X3_USADO,;
								SX3->X3_TIPO,;
								SX3->X3_F3,;
								SX3->X3_CONTEXT } )
								nUsado++
		Endif
		DbSelectArea("SX3")
		DbSkip()
	End
Else
	nUsado := Len(aHeadNew)
Endif
nPPrefix	:= Ascan(aHeadNew, {|x| x[2] == "ACG_PREFIX"} )
nPTitulo	:= Ascan(aHeadNew, {|x| x[2] == "ACG_TITULO"} )
nPParcel	:= Ascan(aHeadNew, {|x| x[2] == "ACG_PARCEL"} )
nPTipo		:= Ascan(aHeadNew, {|x| x[2] == "ACG_TIPO  "} )

If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeadNew, {|x| x[2] == "ACG_FILORI"} )
Endif
If !Empty(cCodigo)
	DbSelectArea("ACG")
	DbSetOrder(1)
	#IFDEF TOP
		cQuery	:=	" SELECT	* " +;
					" FROM " +	RetSqlName("ACG") + " ACG " +;
					" WHERE	ACG.ACG_FILIAL = '" + xFilial("ACG") + "' AND" +;
					"		ACG.ACG_CODIGO = '" + cCodigo + "' AND" +;
					"		ACG.D_E_L_E_T_ = ' '" +;
					" ORDER BY " + SqlOrder(IndexKey())
			
		cQuery	:= ChangeQuery(cQuery)
		// MemoWrite("TK280ACG.SQL", cQuery)
		DbSelectArea("ACG")
		DbCloseArea()
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'ACG', .F., .T.)
	
		For nI := 1 To Len(aStruct)
			If aStruct[nI][2] $ "NDL"
				TCSetField("ACG", aStruct[nI][1], aStruct[nI][2], aStruct[nI][3], aStruct[nI][4])
			Endif
		Next nI
	#ELSE
		MsSeek(xFilial("ACG")+cCodigo)
	#ENDIF
	
	INCLUI := .F.
	While	!Eof() 								.AND.;
			ACG->ACG_FILIAL == xFilial("ACG")	.AND.;
			ACG->ACG_CODIGO == cCodigo
		
		Aadd(aColsNew,Array(nUsado+1))
		For nI := 1 To nUsado
			If ( aHeadNew[nI,10] !=  "V" )
				aColsNew[Len(aColsNew)][nI] := FieldGet(FieldPos(aHeadNew[nI,2]))
			Else
				aColsNew[Len(aColsNew)][nI] := CriaVar(aHeadNew[nI,2],.T.)
			Endif								
		Next nI
		aColsNew[Len(aColsNew)][nUsado+1] := .F.
		
		//������������������������������������������������������������������������������������������������Ŀ
		//�Valido a existencia do campo ACG_FILORI criado. Caso nao exista, assumo a filial corrente do SE1�
		//��������������������������������������������������������������������������������������������������
		If nPFilOrig > 0
			cFilOrig	:= aColsNew[Len(aColsNew)][nPFilOrig]
		Else
			cFilOrig	:= xFilial("SE1")
		Endif
		If aRdpTlc <> Nil
			DbSelectArea("SE1")
			DbSetOrder(1)
			If MsSeek(cFilOrig+	aColsNew[Len(aColsNew)][nPPrefix] + ;
								aColsNew[Len(aColsNew)][nPTitulo] + ;
								aColsNew[Len(aColsNew)][nPParcel] + ;
								aColsNew[Len(aColsNew)][nPTipo];
								)
				aValores := FaVlAtuCr()
				// [1]  Abatimentos
				// [2]  Correcao Monetaria
				// [3]  Juros
				// [4]  Acrescimo    - E1_SDACRES
				// [5]  Decrescimo   - E1_SDDECRE
				// [6]  Desconto
				// [7]  Valor Original do Titulo
				// [8]  Saldo do Titulo na Moeda do Titulo
				// [9]  Saldo do Titulo na Moeda Corrente
				// [10] Pagto Parcial
				// [11] Valor a ser Recebido na moeda do titulo
				// [12] Valor a ser Recebido na moeda corrente
				
				aRdpTlc[1][2]	:= aRdpTlc[1][2] + aValores[2]
				aRdpTlc[2][2]	:= aRdpTlc[2][2] + aValores[10]
				aRdpTlc[3][2]	:= aRdpTlc[3][2] + aValores[8]
				aRdpTlc[4][2]	:= aRdpTlc[4][2] + SE1->E1_SDACRES 
				aRdpTlc[5][2]	:= aRdpTlc[5][2] + SE1->E1_SDDECRE 
				aRdpTlc[6][2]	:= aRdpTlc[6][2] + aValores[9]
				aRdpTlc[7][2]	:= aRdpTlc[7][2] + aValores[1]
				aRdpTlc[8][2]	:= aRdpTlc[8][2] + aValores[6]
				aRdpTlc[9][2]	:= aRdpTlc[9][2] + aValores[7]
				aRdpTlc[10][2]	:= aRdpTlc[10][2] + aValores[3]
				aRdpTlc[11][2]	:= aRdpTlc[11][2] + aValores[11]
				aRdpTlc[12][2]	:= aRdpTlc[12][2] + aValores[12]
			Endif
		Endif
		
		DbSelectArea("ACG")
		DbSkip()
	End
	INCLUI := lAux
	
	#IFDEF TOP
		DbSelectArea("ACG")
		DbCloseArea()
		ChkFile("ACG")
	#ENDIF
Endif

If Empty(aColsNew)
	Aadd(aColsNew,Array(nUsado+1))
	For nI := 1 To nUsado
		aColsNew[Len(aColsNew)][nI] := CriaVar(aHeadNew[nI,2],.F.)
	Next nI
	aColsNew[Len(aColsNew)][nUsado+1] := .F.
Endif
		
// Faz um refresh no rodape
If aRdpTlc <> Nil
	For nI := 1 To Len(aRdpTlc)
		aRdpTlc[nI][1]:Refresh()
	Next nI
Endif

//����������������������������������������������������������Ŀ
//�Carrego a observa��o da cobranca.						 �
//������������������������������������������������������������
cObsMemo	:= ""
cEnceMemo	:= ""
cCancMemo	:= ""
DbSelectArea("ACF")
DbSetOrder(1)
If MsSeek(xFilial("ACF") + cCodigo)
	cObsMemo	:= MSMM(ACF->ACF_CODOBS,TamSx3("ACF_OBS")[1])
	cEnceMemo	:= MSMM(ACF->ACF_CODMOT,TamSx3("ACF_OBSMOT")[1])
	cCancMemo	:= MSMM(ACF->ACF_CCANC,TamSx3("ACF_OBSCAN")[1])
Endif
			
Return(.T.)

		
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Tk271NumTc  � Autor �Fabio Rogerio Pereira� Data � 19/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Carrega os dados do atendimento de acordo com o codigo      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Tmka274													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Tk274NumTlc(nOpc,cNumTlc,lHabilita,oFolderTlc,oEnchTlc)


Local cNumAux 	:= ""
Local cCampo    := ""

CursorWait()
//���������������������������������������������������������Ŀ
//�Existe a liga��o preencho a tela com os dados da liga��o �
//�����������������������������������������������������������
DbSelectarea( "ACF" )
DbSetorder(1)
If DbSeek(xFilial("ACF") + cNumTlc)
	
	nOpc     := 4   // Alteracao
	Inclui   := .F.
	//�������������������������������������Ŀ
	//�Atualiza a enchoice de Telemarketing.�
	//���������������������������������������
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("ACF")
	While ( !SX3->( Eof() ) .AND. SX3->X3_ARQUIVO == "ACF")
		If X3USO(SX3->X3_USADO)
			cCampo := ALLTRIM(SX3->X3_CAMPO)
			If (X3_CONTEXT # "V")
				M->&(cCampo) := ACF->&(cCampo)
			ElseIf (X3_CONTEXT == "V")
				M->&(cCampo) :=  CriaVar(cCampo)
			Endif
		Endif
		
		DbSkip()
	End
	
	//������������������������������������������������������Ŀ
	//� Configura�ao da GetDados - Folder 01			     �
	//� *** Telemarketing                       			 �
	//��������������������������������������������������������
	TK271Config("ACG","ACG_CODIGO",nOpc,,,cNumTlc)
	
	aHeader  := {}
	aCols    := {}
	aHeader  := aClone(aSvFolder[3][1])
	aCols    := aClone(aSvFolder[3][2])
	n		 := aSvFolder[3][3]
	
	oGetTlc:oBrowse:Refresh()
	
Else
	cNumAux      := GetSxeNum("ACF","ACF_CODIGO")
	M->ACF_CODIGO := cNumAux
	RollBackSxe()
	
	If cNumTlc > cNumAux
		Help( " ",1,"FORA_SEQ")
	Endif
Endif

CursorArrow()

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274GrvTlc�Autor  �Armando M. Tessaroli� Data �  12/09/03  ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa a gravacao do atendimento de Telecobranca.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �23/04/04�811   �-Inclusao dos campos E1_SDACRES e E1_SDDECRE���
���          �        �      �na gravacao do titulo no SE1.               ���
���Andrea F. �23/08/04�811   �- Validar se o atendimento podera ser       ���
���          �        �      �encerrado pelo usuario.                     ���
���Andrea F. �18/04/05�811   �BOPS 79484- Gravar a pendencia apos a grava-���
���          �        �      �cao do ACF para obter o ACF_CODIGO correto. ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274GrvTlc(nOpc,oFolderTlc,lHabilita,l380,cAgenda,aSX3ACF)

Local nPTitulo		:= aPosicoes[1][2]						// Titulo
Local nPPrefix		:= aPosicoes[2][2]						// Prefixo
Local nPParcel		:= aPosicoes[3][2]						// Parcela
Local nPTipo		:= aPosicoes[4][2]						// Tipo
Local nPOperad		:= aPosicoes[17][2]						// Prefixo
Local nPStatus		:= aPosicoes[30][2]						// Status do Titulo
Local nI        	:= 0									// Contador	de linhas
Local nJ        	:= 0                                    // Contador de colunas
Local cNumAux		:= M->ACF_CODIGO						// Variavel para gravar o codigo do atendimento 
Local cMay			:= ""                                   // Variavel para uso do mayiusecode	
Local cHisTlc   	:= ""									// Variavel para gravacao dos dados no cadastro de cliente - MEMO
Local cCampo    	:= ""									// Variavel para gravacao dos campos
Local lRet 			:= .F.                                  // Retorno da funcao     	
Local lNovo 		:= .F.									// Flag para gravacao - .T. inclui, .F. altera
Local lTMKCFIM 		:= FindFunction("U_TMKCFIM") 			// P.E. no fim da grava�ao do sistema do ACF/ACG
Local aACFCampos	:= {}									// Carregas os campos do SX3 - alias ACF em memoria	
Local cOperAtend	:= ""									// Codigo do Operador
Local cEncerra		:= ""									// Codigo do Encerramento	
Local cMotivo		:= ""    								// Descricao do motivo de encerramento
Local cCidade		:= ""									// Cidade do contato	
Local cEst			:= ""									// Estado do contato
Local cTelRes		:= ""									// Telefone residencial do contato
Local cTelCom1		:= ""									// Telefone Comercial do contato 
Local cEnd			:= ""									// Endereco do contato
Local aRegras		:= {}									// Regras para cobranca
Local nIni          := 0
Local nFim	        := 0
Local nPFilOrig     := 0									// Posicao da Filial de Origem do Titulo
Local cFilOrig		:= ""                                  	// Filial de origem do titulo

If M->ACF_OPERA == "1"		// Receptivo
	//�������������������������������������������������������������Ŀ
	//�Retorna o nome completo do usuario para a verificacao do SU7 �
	//���������������������������������������������������������������
	PswOrder(1)
	If PswSeek(__cUserId)
		cNome := PswRet()[1][4]
	Endif
	
	//��������������������������������������������������������������Ŀ
	//�Pesquisa o usuario no cadastro de operadores					 �
	//����������������������������������������������������������������
	DbSelectarea("SU7")
	DbSetorder(3)
	//Posiciona no operador
	If !MsSeek(xFilial("SU7")+cNome) // Nome completo
		// Caso nao encontre, tenta com todas as letras maiusculas (legado)
		If MsSeek(xFilial("SU7")+UPPER(cNome)) // Nome completo	
			cOperAtend := SU7->U7_COD
		Endif
	Else
		cOperAtend := SU7->U7_COD
	Endif
Endif

//������������������������������������������������������������������������������������������������Ŀ
//�Se o Status nao for somente de Atendimento e o usuario nao informou o Titulo nao faz a gravacao �
//��������������������������������������������������������������������������������������������������
If M->ACF_STATUS <> "1" .AND. Empty( aCols[1][nPTitulo] )
	Help("",1,"FALTA_TIT")
	Return(lRet)
Endif

//������������������������������������������������������������������Ŀ
//�Valida se o atendimento pode ser encerrado.                       �
//��������������������������������������������������������������������
If M->ACF_STATUS == "3"    //Encerrado

	If TmkOk(STR0130)//"Confirma Encerramento ?"
		For nI := 1 To Len(aCols)
			//���������������������������������������������������������������������������������������Ŀ
			//�Se o status estiver em branco ou 2-Negociado ou 4-Baixa, e a linha nao estiver deletada�
			//�o operador nao podera encerrar o atendimento. O atendimento de Telecobranca somente    �
			//�podera ser encerrado quando os titulos ja estiverem pagos ou enviados a cartorio.      �
			//�����������������������������������������������������������������������������������������
			If (aCols[nI][nPStatus]) $ " 24" .AND. !(aCols[nI][Len(aHeader)+1])
				Help(" ",1,"TK274NOENC") //Este t�tulo n�o poder� ser encerrado"
				Return(lRet)
			Endif
		Next nI   
	Else
		Return(lRet)
	Endif
Endif

//���������������������������������������������������������Ŀ
//�Se for uma alteracao, posiciona no respectivo atendimento�
//�����������������������������������������������������������
If	nOpc == 4
	DbSelectarea("ACF")
	DbSetorder(1)
	If !MsSeek(xFilial("ACF") + M->ACF_CODIGO)
		Help(" ",1,"TK270NSEEK")
		Return(lRet)
	Endif
		
	//������������������������������������Ŀ
	//�Valida se a ligacao estava encerrada�
	//��������������������������������������
	If ACF->ACF_STATUS == "3"
		Help(" ",1,"ENCERRADA")
		Return(lRet)
	Endif
	
	//������������������������������������Ŀ
	//�Valida se a ligacao estava cancelada�
	//��������������������������������������
	If !Empty(ACF->ACF_CCANC)
		Help(" ",1,"CANCELADA")
		Return(lRet)
	Endif
Endif

//��������������������������������������������������������������������������������������Ŀ
//�Valida se existe um telefone valido para o contato para a geracao de ligacao pendente �
//����������������������������������������������������������������������������������������
If !Empty(M->ACF_PENDEN) 
	
	If !Empty(M->ACF_CODCON)
		DbSelectArea("SU5")
		DbSetOrder(1)
		If DbSeek( xFilial("SU5") + M->ACF_CODCON)
			
			If 	Empty(SU5->U5_FONE) 	.AND.;
				Empty(SU5->U5_CELULAR) 	.AND.;
				Empty(SU5->U5_FAX) 		.AND.;
				Empty(SU5->U5_FCOM1) 	.AND.;
				Empty(SU5->U5_FCOM2)
				
				Help(" ",1,"TMKSEMTEL")
				Return(lRet)
			Endif
			
			//�������������������������������������������������������������������������������������������Ŀ
			//�Carrega dados do cadastro do contato para colocar no e-mail - quando existe envio de e-mail�
			//���������������������������������������������������������������������������������������������
			cCidade	:= SU5->U5_MUN
			cEst	:= SU5->U5_EST
			cTelRes := SU5->U5_FCOM1
			cTelCom1:= SU5->U5_FONE
			cEnd	:= SU5->U5_END
		Endif		 

	Else
		//�����������������������������������������������������������������������������������Ŀ
		//�Obriga o operador a indicar um contato para poder gerar a Lista de Contato Pendente�
		//�������������������������������������������������������������������������������������
		Aviso(STR0128,STR0080,{"OK"})//"Atencao,Por favor informe o contato para a geracao da pendencia"
		Return(lRet)                     
	Endif
Endif

//���������������������������������������������������������Ŀ
//� Carrega os campos do cabecalho que deverao ser gravados �
//�����������������������������������������������������������
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("ACF")
While !EOF() .AND. (X3_ARQUIVO == "ACF")
	If X3USO(X3_USADO) 
		Aadd(aACFCampos,{ SX3->X3_CAMPO, SX3->X3_CONTEXT, .T. })
	Else
		Aadd(aACFCampos,{ SX3->X3_CAMPO, SX3->X3_CONTEXT, .F. })
	Endif
	DbSkip()
End

BEGIN TRANSACTION

	For nI := 1 To Len(aCols)

		//����������������������������������������������������������������������Ŀ
		//�Grava o cabecalho do atendimento e as tabelas de relacionamento 1 p/ 1�
		//������������������������������������������������������������������������
		If nI == 1
			
			DbSelectarea("ACF")
			Do Case
				Case nOpc == 3  // INCLUSAO
					DbSelectarea("ACF")
					DbSetorder(1)
					
					cMay := "ACF" + AllTrim(xFilial("ACF")) + cNumAux
					While (MsSeek(xFilial("ACF") + cNumAux) .OR. !MayIUseCode(cMay))
						cNumAux := Soma1(cNumAux,Len(cNumAux))
						cMay 	:= "ACF" + AllTrim(xFilial("ACF")) + cNumAux
					End
					
					If (cNumAux != M->ACF_CODIGO)
						Help(" ",1,"NUMSEQ",,cNumAux,4,15)
						M->ACF_CODIGO := cNumAux
					Endif
					
					If __lSX8
						ConfirmSX8()
					Endif     
					
					lNovo := .T.
					
					//����������������������������������������������������������������������������Ŀ
					//�Atualiza o status dos semaforos para evitar o empilhamento do ultimo folder �
					//������������������������������������������������������������������������������
					If TkGetTipoAte() == "4"
						//��������������������������������������Ŀ
						//�O usuario esta no terceiro folder     �
						//����������������������������������������
						If nFolder == 3  //TLC
							//��������������������������������������Ŀ
							//�Volta a sequencia do ultimo folder    �
							//����������������������������������������
							DbSelectArea("SUC")
							RollBackSX8()
							
							//��������������������������������������Ŀ
							//�Volta a sequencia do penultimo folder �
							//����������������������������������������
							DbSelectArea("SUA")
							RollBackSX8()
							
							DbSelectarea("ACF")
						Endif
					Endif
			Endcase
			
			RecLock("ACF",lNovo)
			For nJ := 1 To Len(aACFCampos)
				cCampo := AllTrim(aACFCampos[nJ][1])
				
				Do Case
					Case cCampo == "ACF_FILIAL"
						ACF->&(cCampo) := xFilial("ACF")
						
					Case cCampo == "ACF_INICIO"
						ACF->&(cCampo) := cTimeIni
						
					Case cCampo == "ACF_FIM"
						ACF->&(cCampo) := Time()
						
					Case cCampo == "ACF_DIASDA"
						ACF->&(cCampo) :=  CtoD("01/01/2045") - M->ACF_DATA
						
					Case cCampo == "ACF_HORADA"
						ACF->&(cCampo) :=  86400 - ( (VAL(Substr(cTimeIni,1,2))*3600) + ( VAL(Substr(cTimeIni,4,2))*60) + VAL(Substr(cTimeIni,7,2))  )
						
					Case cCampo == "ACF_OPERAT"
						ACF->&(cCampo) :=  cOperAtend
						
					Case cCampo == "ACF_CODENC"
						ACF->&(cCampo) := cEncerra
						
					OtherWise
						If (aACFCampos[nJ][2] <> "V") .AND. (aACFCampos[nJ][3])		// X3_CONTEXT e .T.
							If ACF->(FieldPos(cCampo))  > 0
								ACF->&(cCampo) := M->&(cCampo)
							Endif
						Endif
				Endcase
				
			Next nJ

			//������������������������������������������������������������������������������������������������Ŀ
			//�Grava uma NOVA ligacao na lista de contatos pendentes - SU4/SU6                                 �
			//��������������������������������������������������������������������������������������������������
			If M->ACF_STATUS <> "3"		// Encerrada
		
				If !Empty(M->ACF_PENDEN)
					If !Empty(cAgenda)
						TKGrvSU4(M->ACF_CODCON	,"SA1"			,M->ACF_CLIENT + M->ACF_LOJA	,M->ACF_OPERAD,;
								"3"				,M->ACF_CODIGO	,M->ACF_PENDEN					,M->ACF_HRPEND,;
								l380			,cAgenda)
					Else
						TKGrvSU4(M->ACF_CODCON	,"SA1"			,M->ACF_CLIENT + M->ACF_LOJA	,M->ACF_OPERAD,;
								"3"				,M->ACF_CODIGO	,M->ACF_PENDEN					,M->ACF_HRPEND,;
								l380)
					Endif
				Endif
		
			Else
				//��������������������������������������������������������������������������������������������Ŀ
				//�Encerra o atendimento com o status de encerrado                                             �
				//����������������������������������������������������������������������������������������������
				Tk274Encerra(.F.,M->ACF_CODIGO,@cEncerra,@cMotivo)
				
				//��������������������������������������������������������������������������������������������Ŀ
				//�Encerra as listas de pendencias se existir alguma - SOMENTE PARA ESSE ATENDIMENTO ENCERRADO �
				//����������������������������������������������������������������������������������������������
				TK274DelSU4(M->ACF_CODIGO)
			Endif

			//��������������������������������
			//�MEMO DO MOTIVO DE ENCERRAMENTO�
			//��������������������������������
			If !Empty(cMotivo)  // Sempre e inclusao porque so pode encerrar 1 vez
				MSMM(,TamSx3("ACF_OBSMOT")[1],,cMotivo,1,,,"ACF","ACF_CODMOT")
			Endif
			
			//��������������������������������
			//�MEMO DA OBSERVACAO ATENDIMENTO�
			//��������������������������������
			If !Empty(M->ACF_OBS)
				If nOpc == 3 //Inclusao
					MSMM(,TamSx3("ACF_OBS")[1],,M->ACF_OBS,1,,,"ACF","ACF_CODOBS")
			    Else         //Alteracao
				    MSMM(ACF->ACF_CODOBS,TamSx3("ACF_OBS")[1],,M->ACF_OBS,1,,,"ACF","ACF_CODOBS")
			    Endif
			Endif
			MsUnlock()
			
			//Gravo no hist�rio do cliente o contato, a data, a observa��o e a origem(TMK)
			DbSelectarea("SA1")
			DbSetorder(1)
			If DbSeek(xFilial("SA1") + M->ACF_CLIENT + M->ACF_LOJA)
				If Empty(SA1->A1_CODHIST)
		           	//��������������������������������������������������������������������������Ŀ
		            //�Se ainda n�o existe historico gravado para esse cliente fa�o uma inclus�o �
		   	        //����������������������������������������������������������������������������
		   			//Visualizacao
		       	    cHisTlc := DTOC(M->ACF_DATA)+STR0011+CRLF //"-Telecobranca-" 
		           	cHisTlc += M->ACF_OBS + CRLF 
		            MSMM(,TamSx3("A1_HISTMK")[1],,cHisTlc,1,,,"SA1","A1_CODHIST") // O nOpc do MSMM para inclusao tem que ser <> 3
		   	     Else
		           	//�����������������������������������������������������Ŀ
		       	    //�Se ja existe historico atualizo com o SA1+ACF atual  �
		            //�������������������������������������������������������
		   	        cHisTlc += CRLF
		   			//Visualizacao
    	    	    cHisTlc	+= MSMM(SA1->A1_CODHIST,35)//Carrego o historico acumulado da entidade antes de inserir o novo
		       	    cHisTlc += DTOC(M->ACF_DATA)+STR0011+CRLF //"-Telecobranca-" 
		           	cHisTlc += M->ACF_OBS + CRLF
		            MSMM(SA1->A1_CODHIST,TamSx3("A1_HISTMK")[1],,cHisTlc,1,,,"SA1","A1_CODHIST")
		   	     Endif
		         MsUnlock()
		       	 Dbcommit()
			Endif

		Endif
		
		//�������������������������������������������������Ŀ
		//�Gravacao dos itens do atendimento de Telecobranca�
		//���������������������������������������������������
		If (ACG->(FieldPos("ACG_FILORI"))  > 0)
			nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
			If nPFilOrig > 0
				cFilOrig := aCols[nI][nPFilOrig]
			Else
				cFilOrig := xFilial("SE1")	
			Endif 	
		Else
			cFilOrig := xFilial("SE1")		
		Endif
		
		//���������������������������������������������������������������������Ŀ
		//�Grava os Titulos do atendimento e as tabelas de relacionamento 1 p/ 1�
		//�����������������������������������������������������������������������
		DbSelectArea("ACG")
		DbSetOrder(1)
		If MsSeek(xFilial("ACG") + M->ACF_CODIGO + aCols[nI][nPPrefix] + aCols[nI][nPTitulo] + aCols[nI][nPParcel] + aCols[nI][nPTipo]+ cFilOrig)
			lNovo := .F.
		Else
			lNovo := .T.
		Endif
		
		If !lNovo .AND. aCols[nI][Len(aCols[nI])]	// Se a linha foi deletada
			RecLock("ACG",lNovo,.T.)
			DbDelete()
		Else
			RecLock("ACG",lNovo)
			ACG->ACG_FILIAL := xFilial("ACG")
			ACG->ACG_CODIGO := M->ACF_CODIGO

			For nJ := 1 To Len(aHeader)
				cCampo := AllTrim(aHeader[nJ][2])
				
				If (aHeader[nJ][10] <> "V")	// X3_CONTEXT
					If ACG->(FieldPos(cCampo)) > 0
						ACG->&(cCampo) := aCols[nI][Ascan(aHeader, {|x| x[2] == aHeader[nJ][2]} )]
					Endif
				Endif
			Next nJ
		Endif
		MsUnlock()
		
		//���������������������������������������Ŀ
		//�Atualiza os dados dos titulos cobrados.�
		//�����������������������������������������
		DbSelectArea("SE1")
		DbSetOrder(1)
		If MsSeek(cFilOrig + aCols[nI][nPPrefix] + aCols[nI][nPTitulo] + aCols[nI][nPParcel] + aCols[nI][nPTipo])
			RecLock("SE1", .F.)
			SE1->E1_VENCTO			:= ACG->ACG_DTVENC
			SE1->E1_VENCREA			:= ACG->ACG_DTREAL

			//��������������������������������������������������������������������Ŀ
			//�Se ainda nao houve baixa para o titulo, significa que os dados de   �
			//�Desconto Financeiro, Descrescimo e Acrescimo poderao ser alterados. �
			//�No Financeiro os Acrescimos, Decrescimos e Descontos, sao concedidos�
			//�somente na primeira baixa do titulo. Se existirem novos valores     �
			//�o usuario  devera informar manualmente na baixa de titulo.		   �
			//����������������������������������������������������������������������
			If  Empty(SE1->E1_BAIXA)
				SE1->E1_DESCFIN			:= ACG->ACG_DESCFI		// Percentual de Desconto Financeiro
				SE1->E1_LIDESCF			:= ACG->ACG_LIDESC		// Data Limite para Desconto Financeiro
				SE1->E1_ACRESC			:= ACG->ACG_ACRESC		// Valor de Acrescimo
				SE1->E1_DECRESC			:= ACG->ACG_DECRES		// Valor de Descrescimo

				//����������������������������������������������������������������Ŀ
				//�Os Saldos de Acrescimo e Decrescimo devem ser atualizados       �
				//�para serem avaliados no momento da baixa do titulo. 			   �
				//�Os Saldos sao atualizados ate que o titulo seja baixado, 	   �
				//�apos a baixa (parcial), o mesmo nao podera ser alterado.        �
				//������������������������������������������������������������������
				SE1->E1_SDACRES	:= ACG->ACG_ACRESC				// Saldo de Acrescimo
				SE1->E1_SDDECRE	:= ACG->ACG_DECRESC				// Saldo de Descrescimo
			Endif	

			MsUnlock()
		Endif
		
	Next nI

	//���������������������������������������������������������������Ŀ
	//�Atualiza a data do ultimo contato.  SU5.                       �
	//�Para que possam ser geradas listas por ultimo contato todas as �
	//�interacoes devem atualizar a data do ultimo contato no cadastro�
	//�de Contatos.                                                   �
	//�����������������������������������������������������������������
   	If !Empty(M->ACF_CODCON)
    	DbSelectArea("SU5")
		DbSetOrder(1)
		If MsSeek(xFilial("SU5") + M->ACF_CODCON)
			Reclock("SU5",.F.)
			Replace SU5->U5_ULTCONT With M->ACF_DATA
			MsUnlock()			
		Endif
	Endif    

END TRANSACTION
		
//����������������������������������������������������������������Ŀ
//�Carrega um array com as regras de cobranca para atualizar o SK1 �
//������������������������������������������������������������������
DbSelectArea("SK0")
DbSetOrder(2)
MsSeek(xFilial("SK0"))
While !Eof()
    nIni := nFim + 1
    If SK0->K0_PRAZO == "999999"		// Trabalha com lista de contato
    	nFim := nFim + 100000
    Else
    	nFim := nFim + Val(SK0->K0_PRAZO)
	Endif
    Aadd(aRegras, {SK0->K0_REGSEL, nIni, nFim})
    DbSelectArea("SK0")
    DbSkip()
End

//�������������������������������������������������������Ŀ
//�Funcao para atualizar no SK1 os titulos para o operador�
//���������������������������������������������������������
Tk280AtuSK1(M->ACF_CLIENT,M->ACF_LOJA,M->ACF_OPERAD,aRegras)		            	

//����������������������������������������������Ŀ
//�Envia e-mail para o responsavel pela cobranca.�
//������������������������������������������������
Tk274EnvTlc(cCidade,cEst,cTelRes,cTelCom1,cEnd,aSX3ACF)

//��������������������������������������������������������������Ŀ
//�Executa o ponto de Entrada TMKCFIM apos a gravacao do ACF/ACG �
//����������������������������������������������������������������
If lTMKCFIM
	U_TMKCFIM(M->ACF_CODIGO)
Endif

//�����������������������������������������������������������Ŀ
//�Se a gravacao chegou ate aqui, entao foi concluida comexito�
//�������������������������������������������������������������
lRet := .T.

Return(lRet)


/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �TK271Titulo  �Autor  �Armando Tessaroli   � Data �  15/10/02   ���
����������������������������������������������������������������������������͹��
���Desc.     �Validacao do conteudo digitado no campo do numero do titulo no ���
���          �telecobranca.                                                  ���
����������������������������������������������������������������������������͹��
���Uso       � Call Center                                                   ���
����������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	     ���
����������������������������������������������������������������������������͹��
���Andrea F .�29/06/05�811   �BOPS 83698 - Validar a existencia do campo     ���
���          �        �      �ACG_FILORI no preenchimento do acols.          ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Function TK274Titulo()

Local aArea		:= GetArea()				// Salva a Area atual
Local lRet		:= .T.						// Retorno da funcao
Local nPPrefix	:= aPosicoes[2][2]			// Posicao do Prefixo			
Local nPParcel	:= aPosicoes[3][2]			// Posicao da Parcela
Local nPTipo	:= aPosicoes[4][2]			// Posicao do Tipo
Local nPFilOrig	:= 0                       	// Posicao da filial de origem do titulo

If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
	If nPFilOrig > 0
	   cFilOrig:= aCols[n][nPFilOrig]
	Else
		cFilOrig	:= xFilial("SE1")
	Endif
Else
	cFilOrig := xFilial("SE1")	
Endif			

DbSelectArea("SE1")
DbSetOrder(1)
If !MsSeek(cFilOrig + aCols[n][nPPrefix] + M->ACG_TITULO + aCols[n][NPParcel] + aCols[n][NPTipo])
	Help(" ",1,"TK274PESQF")
	lRet := .F.
Endif

RestArea(aArea)

Return(lRet)


/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � TK274Tit � Autor � Andrea Farias         � Data � 24/04/04   ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe os titulos vencidos do cliente	(F3/ACG/SXB)            ���
���������������������������������������������������������������������������Ĵ��
���Uso       � TELECOBRANCA                                                 ���
���������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	    ���
���������������������������������������������������������������������������͹��
���Andrea F. �16/03/04�811   �- Ajuste no tratamento da funcao TcSetField() ���
���Andrea F. �24/04/04�811   �- Posicoes 4 e 5 do array Avalores substi-    ���
���          �        �      �tuidas pelos campos E1_SDACRES e E1_SDDECRE   ���
���Marcelo K.�01/09/04�811   �- Inclusao das colunas de Natureza e Portador ���
���Andrea F .�29/06/05�811   �- BOPS 83698 - Validar a existencia do campo  ���
���          �        �      �ACG_FILORI no preenchimento do acols.         ���
���Andrea F. �21/07/05�811   �QNC 002357 - Atualizar os campos Referencia,  ���
���          �        �      �Receber, Juros, Baixa e Status.			    ���
���Henry F   �06/09/05�811   �Bops 85781 - Ajuste da chamada do SE1 para    ���
���          �        �      �abrir o arquivo on-demand      			    ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Function Tk274Tit()

Local aTitulos	:= {}										// Array com os titulos vencidos
Local nOpcao	:= 0										// Opcao de confirmacao
Local nCampo	:= 0										// Controle para carregar o acols
Local nTitulo	:= 1										// Titulo selecionado
Local oDlg													// Dialog com Titulos
Local oTitulos												// Listbox com titulos vencidos
Local oOk		:= LoaDbitmap(GetResources(),"LBOK")		// X Verde
Local oNo		:= LoaDbitmap(GetResources(),"LBNO")		// X Vermelho
Local lFlag		:= .F.										// Define se o titulo sera marcado ou desmarcado
Local oVerd		:= LoaDbitmap(GetResources(),"ENABLE")		// Bitmap Verde
Local oVerm		:= LoaDbitmap(GetResources(),"DISABLE")	// Bitmap Vermelho
Local lVencido	:= .F.										// Define se o titulo esta vencido ou nao
Local nPTitulo	:= aPosicoes[1][2]                         // Posicao do Titulo
Local nPPrefix	:= aPosicoes[2][2]							// Posicao do Prefixo			
Local nPParcel	:= aPosicoes[3][2]							// Posicao da Parcela
Local nPTipo	:= aPosicoes[4][2]							// Posicao do Tipo
Local nPRecebe	:= aPosicoes[11][2]							// Valor a Receber do Titulo
Local nPJuros	:= aPosicoes[12][2]							// Valor de Juros do Titulo
Local nPValRef	:= aPosicoes[28][2]							// Valor de Referencia
Local nPBaixa   := aPosicoes[29][2]							// Log de Baixa        
Local nPStatus  := aPosicoes[30][2]	   						// Status do Atendimento
Local lRet		:= .F.										// Retorno da funcao
Local oTodos												// Objeto de selecao
Local lTodos	:= .F.										// Valor do objeto de selecao
Local oInverte												// Objeto de selecao
Local lInverte	:= .F.										// Valor do objeto de selecao
Local cSK1		:= "SK1"									// Alias temporario de controle
Local cSE1		:= "SE1"									// Alias temporario de controle
Local aValores	:= {}										// Array com todos os valores para o rodape.
Local oBmp1													// Objeto da legenda
Local oBmp2													// Objeto da legenda
Local aButtons	:= {}										// Botoes da tool bar
Local oPanel												// Painel de pesquisa
Local oPrefixo												// Objetos de pesquisa
Local oNum													// Objetos de pesquisa
Local oParcela												// Objetos de pesquisa
Local oTipo													// Objetos de pesquisa
Local oVencimento											// Objetos de pesquisa
Local oVencOrig												// Objetos de pesquisa
Local oHistorico											// Objetos de pesquisa
Local oNaturez												// Objetos de pesquisa
Local oPortado												// Objetos de pesquisa
Local oNumBor												// Objetos de pesquisa
Local oEmissao												// Objetos de pesquisa
Local oVencRea												// Objetos de pesquisa
Local lPrefixo		:= .F.									// Variaveis de pesquisa
Local lNum			:= .F.									// Variaveis de pesquisa
Local lParcela		:= .F.									// Variaveis de pesquisa
Local lTipo			:= .F.									// Variaveis de pesquisa
Local lVencimento	:= .F.									// Variaveis de pesquisa
Local lVencOrig		:= .F.									// Variaveis de pesquisa
Local lHistorico	:= .F.									// Variaveis de pesquisa
Local lNaturez		:= .F.									// Variaveis de pesquisa
Local lPortado		:= .F.									// Variaveis de pesquisa
Local lNumBor		:= .F.									// Variaveis de pesquisa
Local lEmissao		:= .F.									// Variaveis de pesquisa
Local lVencRea		:= .F.									// Variaveis de pesquisa
Local oExpressao											// Objetos de pesquisa
Local cExpressao	:= Space(100)							// Variaveis de pesquisa
Local nLenAux		:= 0 									// Variavel auxiliar para o FOR/NEXT	
Local nLenaHead		:= 0 									// Variavel auxiliar para o FOR/NEXT	
Local nPFilOrig		:= 0                                   	// Posicao da filial de origem do titulo da tabela SK1
Local nPFilACG 		:= 0                                   	// Posicao da filial de origem do titulo da tabela ACG
Local cFilOrig		:= ""									// Filial de Origem do titulo

#IFDEF TOP
	Local cQuery	:= ""									// Query para TOP
	Local aStruSK1	:= SK1->(DbStruct())					// Estrutura do Alias SK1
	Local aStruSE1	:= SE1->(DbStruct())					// Estrutura do Alias SE1
	Local nI		:= 0 
#ENDIF

If (SK1->(FieldPos("K1_FILORIG"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "K1_FILORIG"} )
Endif

If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilACG 	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
Endif

CursorWait()

//������������������������������������������������Ŀ
//�Seleciona os titulos atrasados do cliente atual.�
//��������������������������������������������������
DbSelectArea("SK1")
DbSetOrder(4)		// K1_FILIAL+K1_CLIENTE+K1_LOJA+DTOS(K1_VENCREA)


//�������������������������������������������������������Ŀ
//�DbSelectArea no SE1 para abrir o arquivo on Demand     �
//���������������������������������������������������������
DbSelectArea("SE1")
DbSetOrder(1)		


#IFDEF TOP
	cSK1	:= "TMPSK1"				// Alias temporario do SK1
	cSE1	:= "TMPSK1"				// Alias temporario do SK1
	cQuery	:=	" SELECT	K1_FILIAL, K1_CLIENTE, K1_LOJA, K1_NUM, K1_PARCELA, K1_TIPO, K1_PREFIXO, K1_NUM, K1_PARCELA, K1_TIPO, " +;
				" 			E1_FILIAL, E1_VENCREA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_VENCTO, E1_VENCORI, " +;
				" 			E1_LOJA, E1_NATUREZ, E1_PORTADO, E1_NUMBOR, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_HIST " +;
				" FROM " +	RetSqlName("SK1") + " SK1, " + RetSqlName("SE1") + " SE1 " +;
				" WHERE	SK1.K1_FILIAL 	= '" + xFilial("SK1") + "' AND" +;
				"		SK1.K1_CLIENTE 	= '" + M->ACF_CLIENT + "' AND" +;
				"		SK1.K1_LOJA 	= '" + M->ACF_LOJA + "' AND" +;
				"		SK1.K1_OPERAD 	<> 'XXXXXX' AND" +;
				"		SK1.D_E_L_E_T_ 	= '' AND" 

				//����������������������������������������������������������������Ŀ
				//�Tratamento para filtrar apenas os titulos da filial de origem.  �
				//�Se o campo nao estiver criado, assumo a filial corrente do SE1. �
				//������������������������������������������������������������������
				If SK1->(FieldPos("K1_FILORIG"))  > 0
					cQuery+=	"	SE1.E1_FILIAL 	= SK1.K1_FILORIG 	AND"
				Else
					cQuery+=	"	SE1.E1_FILIAL 	= '" + xFilial("SE1")+ "' 	AND"
				Endif	
	
				cQuery+= "		SE1.E1_PREFIXO 	= SK1.K1_PREFIXO 	AND" 
				cQuery+= "		SE1.E1_NUM 		= SK1.K1_NUM 		AND" 
				cQuery+= "		SE1.E1_PARCELA 	= SK1.K1_PARCELA 	AND" 
				cQuery+= "		SE1.E1_TIPO 	= SK1.K1_TIPO 		AND" 
				cQuery+= "		SE1.D_E_L_E_T_ 	= ''" 
				cQuery+= " 		ORDER BY " + SqlOrder(IndexKey())
	
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TK274F3.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cSK1, .F., .T.)

    Dbselectarea(cSK1)
	For nI := 1 To Len(aStruSK1)
		If aStruSK1[nI][2] $ "NDL" .AND. FieldPos(aStruSK1[nI][1]) > 0
			TCSetField(cSK1, aStruSK1[nI][1], aStruSK1[nI][2], aStruSK1[nI][3], aStruSK1[nI][4])
		Endif
	Next nI
	
	For nI := 1 To Len(aStruSE1)
		If aStruSE1[nI][2] $ "NDL" .AND. FieldPos(aStruSE1[nI][1]) > 0
			TCSetField(cSK1, aStruSE1[nI][1], aStruSE1[nI][2], aStruSE1[nI][3], aStruSE1[nI][4])
		Endif
	Next nI
#ELSE
	MsSeek(xFilial("SK1")+M->ACF_CLIENT+M->ACF_LOJA)
#ENDIF

While	!Eof()								 .AND.;
		(cSK1)->K1_FILIAL  == xFilial("SK1") .AND.;
		(cSK1)->K1_CLIENTE == M->ACF_CLIENT	 .AND.;
		(cSK1)->K1_LOJA    == M->ACF_LOJA
	
	#IFNDEF TOP
		If (cSK1)->K1_OPERAD == "XXXXXX"
			DbSelectArea(cSK1)
			DbSkip()
			Loop
		Endif
		
		If nPFilOrig > 0
			cFilOrig 	:= (cSK1)->K1_FILORIG
		Else
			cFilOrig	:= xFilial("SE1")
		Endif	
		DbSelectArea("SE1")
		DbSetOrder(1)
		If !MsSeek(cFilOrig + (cSK1)->K1_PREFIXO + (cSK1)->K1_NUM + (cSK1)->K1_PARCELA + (cSK1)->K1_TIPO)
			DbSelectArea(cSK1)
			DbSkip()
			Loop
		Endif
	#ENDIF
	
	//����������������������������������������������������������Ŀ
	//�Atualiza o flag de marcado se o titulo ja existir no Acols�
	//������������������������������������������������������������
		
	If !Empty(aCols[n][nPTitulo])
		If Ascan(aCols, {|x| x[nPPrefix]+x[nPTitulo]+x[nPParcel]+x[nPTipo] == (cSK1)->K1_PREFIXO+(cSK1)->K1_NUM+(cSK1)->K1_PARCELA+(cSK1)->K1_TIPO} ) > 0
			lFlag := .T.
		Else
			lFlag := .F.
		Endif
	Endif
	
	Aadd( aTitulos, {	lFlag,;														// 01 - [x] ou [ ]
						lVencido,;													// 02 - Vermelho ou O - Verde
						(cSE1)->E1_PREFIXO,;										// 03 - Prefixo
						(cSE1)->E1_NUM,;											// 04 - Titulo
						(cSE1)->E1_PARCELA,;										// 05 - Parcela
						(cSE1)->E1_TIPO,;											// 06 - Tipo
						DtoC((cSE1)->E1_EMISSAO),;									// 07 - Emissao 
						DtoC((cSE1)->E1_VENCTO),;									// 08 - Vencimento
						DtoC((cSE1)->E1_VENCREA),;									// 09 - Venc. Real	
						DtoC((cSE1)->E1_VENCORI),;									// 10 - Venc. Original
						(cSE1)->E1_HIST,;											// 11 - Historico
						(cSE1)->E1_NATUREZ,;										// 12 - Natureza 
						(cSE1)->E1_PORTADO,;										// 13 - Portador
						(cSE1)->E1_NUMBOR,;											// 14 - Numero do Bordero
						TRANSFORM((cSE1)->E1_VALOR,   PESQPICT("SE1", "E1_VALOR")),;// 15 - Valor	
						TRANSFORM((cSE1)->E1_SALDO,   PESQPICT("SE1", "E1_SALDO")),;
						(cSE1)->E1_FILIAL;
						} )
	DbSelectArea(cSK1)
	DbSkip()
End
#IFDEF TOP
	DbSelectArea(cSK1)
	DbCloseArea()
#ENDIF

If GetMv("MV_TMKTLCT")		// Carrega titulos a vencer
	lVencido := .T.
	//������������������������������������������������Ŀ
	//�Seleciona os titulos A VENCER do cliente atual. �
	//��������������������������������������������������
	DbSelectArea("SE1")
	DbSetOrder(1)		// E1_FILIAL+DTOS(E1_VENCREA)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA
	#IFDEF TOP
		cSE1	:= "TMPSE1"				// Alias temporario do SE1
		cQuery	:=	" SELECT	E1_FILIAL, E1_VENCREA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_VENCTO, E1_VENCORI, " +;
					" 			E1_LOJA, E1_NATUREZ, E1_PORTADO, E1_NUMBOR, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_HIST " +;
					" FROM " +	RetSqlName("SE1") + " SE1 " +;
					" WHERE	SE1.E1_VENCREA 	>= 	'" + DtoS(dDataBase) + 	"' AND" +;
					"		SE1.E1_CLIENTE 	= 	'" + M->ACF_CLIENT + 	"' AND" +;
					"		SE1.E1_LOJA 	= 	'" + M->ACF_LOJA + 		"' AND" +;
					"		SE1.D_E_L_E_T_ 	= 	''" +;
					" ORDER BY " + SqlOrder(IndexKey())
		
		cQuery	:= ChangeQuery(cQuery)
		// MemoWrite("TK274F3.SQL", cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cSE1, .F., .T.)
		
		Dbselectarea(cSE1)		
		nLenAux := Len(aStruSE1)
		For nI := 1 TO nLenAux
			If aStruSE1[nI][2] $ "NDL" .AND. FieldPos(aStruSE1[nI][1]) > 0
				TCSetField(cSE1, aStruSE1[nI][1], aStruSE1[nI][2], aStruSE1[nI][3], aStruSE1[nI][4])
			Endif
		Next nI
	#ELSE
		MsSeek(xFilial("SE1")+DtoS(dDataBase),.T.)
	#ENDIF
	
	While	!Eof()	.AND.(cSE1)->E1_VENCREA >= dDataBase
		
		#IFNDEF TOP
			If (cSE1)->E1_CLIENTE <> M->ACF_CLIENT .OR. (cSE1)->E1_LOJA <> M->ACF_LOJA
				DbSkip()
				Loop
			Endif
		#ENDIF

	    //����������������������������������������������������������Ŀ
	    //�Atualiza o flag de marcado se o titulo ja existir no Acols�
	    //������������������������������������������������������������
		
		If !Empty(aCols[n][nPTitulo])
			If Ascan(aCols, {|x| x[nPPrefix]+x[nPTitulo]+x[nPParcel]+x[nPTipo] == (cSE1)->E1_PREFIXO+(cSE1)->E1_NUM+(cSE1)->E1_PARCELA+(cSE1)->E1_TIPO} ) > 0
				lFlag := .T.
			Else
				lFlag := .F.
			Endif
		Endif 
		
		Aadd( aTitulos, {	lFlag,;														// 01 - [x] ou [ ]
							lVencido,;													// 02 - Vermelho ou O - Verde
							(cSE1)->E1_PREFIXO,;										// 03 - Prefixo
							(cSE1)->E1_NUM,;											// 04 - Titulo
							(cSE1)->E1_PARCELA,;										// 05 - Parcela
							(cSE1)->E1_TIPO,;											// 06 - Tipo
							DtoC((cSE1)->E1_EMISSAO),;									// 07 - Emissao 
							DtoC((cSE1)->E1_VENCTO),;									// 08 - Vencimento
							DtoC((cSE1)->E1_VENCREA),;									// 09 - Venc. Real	
							DtoC((cSE1)->E1_VENCORI),;									// 10 - Venc. Original
							(cSE1)->E1_HIST,;											// 11 - Historico
							(cSE1)->E1_NATUREZ,;										// 12 - Natureza 
							(cSE1)->E1_PORTADO,;										// 13 - Portador
							(cSE1)->E1_NUMBOR,;											// 14 - Numero do Bordero
							TRANSFORM((cSE1)->E1_VALOR,   PESQPICT("SE1", "E1_VALOR")),;// 15 - Valor	
							TRANSFORM((cSE1)->E1_SALDO,   PESQPICT("SE1", "E1_SALDO")),;//16 - Saldo
							(cSE1)->E1_FILIAL;                                         	// 17 - Filial de Origem  	
							} )
		DbSkip()
	End
	
	#IFDEF TOP
		DbSelectArea(cSE1)
		DbCloseArea()
	#ENDIF
	
Endif

If (Len(aTitulos) == 0)
	AAdd(aTitulos,{.F., .F., "", "", "", "", "", "", "", "", "", "", "", "", "", "",""} )
Else
	Asort( aTitulos,,, { |x,y| CtoD(x[9]) < CtoD(y[9]) } )
Endif

CursorArrow()

//���������������������������������������������������Ŀ
//�Cria tela para a escolha do titulo a ser negociado.�
//�����������������������������������������������������
Define MsDialog oDlg Title STR0081 From 0,0 To 360,500 Pixel //"Sele��o de T�tulos para negocia��o"
	
	Aadd(aButtons, { "VERNOTA", { || Tk274SE1Visual(aTitulos[oTitulos:nAt,3],aTitulos[oTitulos:nAt,4],aTitulos[oTitulos:nAt,5],aTitulos[oTitulos:nAt,6],aTitulos[oTitulos:nAt,17]) }, STR0088} ) //"Visualiza"
	Aadd(aButtons, { "TK_FIND", { || Tk274SE1Pesq(	oPanel,		oTodos,		oInverte,	cExpressao,;
													oTitulos,	lPrefixo,	lNum,		lParcela,;
													lTipo,		lVencimento,lVencOrig,	lHistorico,;
													lNaturez,	lPortado,	lNumBor,	lEmissao,;
													lVencRea,	.F.) }, STR0089} ) //"Pesquisa"

	
	EnchoiceBar(oDlg, {|| (nOpcao:= 1,oDlg:End())}, {|| oDlg:End() },,aButtons )
	
	@ 20,05	Listbox oTitulos Fields;
			HEADER	"",;		// 01 - [x] ou [ ]
					"",;		// 02 - Vermelho ou Verde
					STR0017,;	// 03 - Prefixo
					STR0082,;	// 04 - Titulo
					STR0018,;	// 05 - Parcela
					STR0019,;	// 06 - Tipo
					STR0023,;   // 07 - Emissao
					STR0021,;   // 08 - Vencimento
					STR0024,; 	// 09 - Venc. Real
					STR0025,;	// 10 - Venc. Orig
					STR0027,;	// 11 - Historico
					STR0028,;	// 12 - Natureza
					STR0029,;	// 13 - Portador
					STR0030,;	// 14 - Bordero
					STR0022,;	// 15 - Valor
					STR0026;	// 16 - Saldo
			On DbLCLICK (aTitulos[oTitulos:nAt,1]:= !aTitulos[oTitulos:nAt,1], oTitulos:Refresh());
			On Change (nTitulo:= oTitulos:nAt) Size 242,115 Of oDlg Pixel NoScroll

	oTitulos:SetArray(aTitulos)
	oTitulos:bLine:={||{IIF(aTitulos[oTitulos:nAt,1],oOk,oNo),;			// 01 - [x] ou [ ]
						IIF(aTitulos[oTitulos:nAt,2],oVerd,oVerm),;		// 02 - Vermelho ou Verde
					 	aTitulos[oTitulos:nAt,3],;						// 03 - Prefixo
					 	aTitulos[oTitulos:nAt,4],;						// 04 - Titulo
					 	aTitulos[oTitulos:nAt,5],;						// 05 - Parcela
					 	aTitulos[oTitulos:nAt,6],;						// 06 - Tipo
					 	aTitulos[oTitulos:nAt,7],;						// 07 - Emissao
					 	aTitulos[oTitulos:nAt,8],;						// 08 - Vencimento
					 	aTitulos[oTitulos:nAt,9],;						// 09 - Venc. Real	
					 	aTitulos[oTitulos:nAt,10],;						// 10 - Venc. Orig
					 	aTitulos[oTitulos:nAt,11],;						// 11 - Historico
					 	aTitulos[oTitulos:nAt,12],;						// 12 - Natureza		
					 	aTitulos[oTitulos:nAt,13],;						// 13 - Portador
					 	aTitulos[oTitulos:nAt,14],;						// 14 - Bordero	
					 	aTitulos[oTitulos:nAt,15],;						// 15 - Valor
					 	aTitulos[oTitulos:nAt,16],;
						aTitulos[oTitulos:nAt,17]}}
	oTitulos:Refresh()
	
    // Painel de Pesquisa
	@ 020,05 MsPanel oPanel Prompt "" Size 242,115 Of oDlg Centered Lowered
	oPanel:lVisible := .F.
	@ 005,05 To 80,230 Of oPanel Label STR0090 Pixel //"Composicao Sequencial da pesquisa avancada"

	@ 15,010 CheckBox oPrefixo		Var lPrefixo	Size 60,9 Pixel Of oPanel Prompt STR0091 //"01 - Prefixo"
	@ 15,085 CheckBox oNum			Var lNum		Size 60,9 Pixel Of oPanel Prompt STR0092 //"02 - Numero"
	@ 15,165 CheckBox oParcela		Var lParcela	Size 60,9 Pixel Of oPanel Prompt STR0093 //"03 - Parcela"
	@ 30,010 CheckBox oTipo			Var lTipo		Size 60,9 Pixel Of oPanel Prompt STR0094 //"04 - Tipo"
	@ 30,085 CheckBox oEmissao		Var lEmissao	Size 60,9 Pixel Of oPanel Prompt STR0095 //"05 - Emissso"
	@ 30,165 CheckBox oVencimento	Var lVencimento	Size 60,9 Pixel Of oPanel Prompt STR0096 //"06 - Vencimento"
	@ 45,010 CheckBox oVencRea		Var lVencRea	Size 60,9 Pixel Of oPanel Prompt STR0097 //"07 - Vencto Real"
	@ 45,085 CheckBox oVencOrig		Var lVencOrig	Size 60,9 Pixel Of oPanel Prompt STR0098 //"08 - Vencto Original"
	@ 45,165 CheckBox oHistorico	Var lHistorico	Size 60,9 Pixel Of oPanel Prompt STR0099 //"09 - Historico"
	@ 60,010 CheckBox oNaturez		Var lNaturez	Size 60,9 Pixel Of oPanel Prompt STR0100 //"10 - Natureza"
	@ 60,085 CheckBox oPortado		Var lPortado	Size 60,9 Pixel Of oPanel Prompt STR0101 //"11 - Portador"
	@ 60,165 CheckBox oNumBor		Var lNumBor		Size 60,9 Pixel Of oPanel Prompt STR0102 //"12 - Bordero"
	
	@ 85,05 Say STR0103 Of oPanel Pixel //"Express�o da pesquisa"
	@ 95,05 MsGet oExpressao Var cExpressao Size 225,09 Of oPanel Pixel When .T. Valid Tk274SE1Pesq(	oPanel,		oTodos,		oInverte,	cExpressao,;
																										oTitulos,	lPrefixo,	lNum,		lParcela,;
																										lTipo,		lVencimento,lVencOrig,	lHistorico,;
																										lNaturez,	lPortado,	lNumBor,	lEmissao,;
																										lVencRea,	.T.)
	

	@ 140,05 CheckBox oTodos Var lTodos Size 130,9 Pixel Of oDlg Prompt STR0086 On Change Tk274Tools(1, oTitulos, lTodos) //"Marca e Desmarca Todos"
	@ 140,85 CheckBox oInverte Var lInverte Size 130,9 Pixel Of oDlg Prompt STR0087 On Change Tk274Tools(2, oTitulos, lInverte) //"Inverte e Retorna Sele��o"
	
    // Legendas da Tela
	@ 155,05 To 175,247 Of oDlg Label STR0083 Pixel //"Legenda"
	@ 163,10 BitMap oBmp1 ResName "BR_VERDE" OF oDlg Size 10,10 NoBorder When .F. Pixel
	@ 163,20 Say STR0084 Of oDlg Pixel //"Titulos a Vencer em aberto"
	
	@ 163,120 BitMap oBmp2 ResName "BR_VERMELHO" OF oDlg Size 10,10 NoBorder When .F. Pixel
	@ 163,130 Say STR0085 Of oDlg Pixel //"Titulos Vencidos em aberto"
	
Activate MsDialog oDlg Centered


//�����������������������������������������������Ŀ
//�Na confirmacao posiciona no titulo selecionado.�
//�������������������������������������������������
If (nOpcao == 1)
	nUsado:= Len(aHeader) + 1
	aCols := {}
	lRet  := .T.

	//������������������������������������������������������������Ŀ
	//�Cria linhas no acols se existir mais de um item selecionado.�
	//��������������������������������������������������������������
	nLenAux := Len(aTitulos)
	For nTitulo:= 1 To nLenAux
		If (aTitulos[nTitulo][1])
			//���������������������������������������������������Ŀ
			//�Adiciona uma linha no acols e inicializa os campos.�
			//�����������������������������������������������������
			AAdd(aCols,Array(nUsado))
			nLenaHead := Len(aHeader)
			For nCampo := 1 TO nLenaHead
				aCols[Len(aCols)][nCampo] := CriaVar(aHeader[nCampo][2])
			Next nCampo
			aCols[Len(aCols)][nUsado] := .F.
			
			DbSelectArea("SE1")
			DbSetOrder(1)
			If DbSeek(aTitulos[nTitulo,17] + aTitulos[nTitulo,3] + aTitulos[nTitulo,4] + aTitulos[nTitulo,5] + aTitulos[nTitulo,6])
				//�������������������������������������������������Ŀ
				//�Atualiza o campos do acols e executa os gatilhos.�
				//���������������������������������������������������
				aCols[Len(aCols)][nPTitulo] := aTitulos[nTitulo][4]
				
				//������������������������������������������������������������������������������������������������Ŀ
				//�Valido a existencia do campo ACG_FILORI criado. Caso nao exista, assumo a filial corrente do SE1�
				//��������������������������������������������������������������������������������������������������
		  		If nPFilACG > 0
			  		aCols[Len(aCols)][nPFilACG]:= aTitulos[nTitulo][17]
			  	Endif
		
				Posicione("SX3",2,"ACG_TITULO","")
				RunTrigger(2,Len(aCols))
				
				aValores := FaVlAtuCr()

				//����������������������������������������������������������������������������������Ŀ
				//�Atualiza o Valor de Referencia, Receber, Juros, Baixa e Status na Inclusao dos tit�
				//������������������������������������������������������������������������������������
				aCols[Len(aCols)][nPValRef]	:= aValores[6]		// Saldo do Titulo 
				aCols[Len(aCols)][nPJuros]	:= aValores[8]		// Valor de Juros
				aCols[Len(aCols)][nPRecebe]	:= aValores[12] 	// Valor a Receber
		
		        Do Case 
		        	Case !Empty(SE1->E1_BAIXA) // Se houve uma baixa verifica se foi TOTAL ou PARCIAL
		        		 If (SE1->E1_SALDO > 0)
							aCols[Len(aCols)][nPBaixa] := "1" //Baixa Parcial
							aCols[Len(aCols)][nPStatus]:= "4" //Baixa
						 Endif
						 
						 If (SE1->E1_SALDO == 0)
							aCols[Len(aCols)][nPBaixa] := "3" //Baixa Total
							aCols[Len(aCols)][nPStatus]:= "1" //Pago
						 Endif	
		
			        Case Empty(SE1->E1_BAIXA) // Nao houve nenhuma baixa 
						aCols[Len(aCols)][nPBaixa] := "2" //Sem Baixa            	
		
			  	EndCase	  	
		
				// [2] Abatimentos
				// [A] Correcao Monetaria
				// [8] Juros
				// [5] Acrescimo     - E1_SDACRES
				// [4] Decrescimo    - E1_SDDECRE
				// [9] Desconto
				// [1] Valor Original do Titulo
				// [6] Saldo do Titulo na Moeda do Titulo
				// [7] Saldo do Titulo na Moeda Corrente
				// [3] Pagto Parcial
				// [B] Valor a ser Recebido na moeda do titulo
				// [C] Valor a ser Recebido na moeda corrente
				
				aRdpTlc[1][2]	:= aRdpTlc[1][2] + aValores[2]
				aRdpTlc[2][2]	:= aRdpTlc[2][2] + aValores[10]
				aRdpTlc[3][2]	:= aRdpTlc[3][2] + aValores[8]
				aRdpTlc[4][2]	:= aRdpTlc[4][2] + SE1->E1_SDACRES 
				aRdpTlc[5][2]	:= aRdpTlc[5][2] + SE1->E1_SDDECRE 
				aRdpTlc[6][2]	:= aRdpTlc[6][2] + aValores[9]
				aRdpTlc[7][2]	:= aRdpTlc[7][2] + aValores[1]
				aRdpTlc[8][2]	:= aRdpTlc[8][2] + aValores[6]
				aRdpTlc[9][2]	:= aRdpTlc[9][2] + aValores[7]
				aRdpTlc[10][2]	:= aRdpTlc[10][2] + aValores[3]
				aRdpTlc[11][2]	:= aRdpTlc[11][2] + aValores[11]
				aRdpTlc[12][2]	:= aRdpTlc[12][2] + aValores[12]
			Endif	   
		Endif
	Next nTitulo
	
	//�����������������������������������������������������������������������������������Ŀ
	//�Depois de carregar o aCols com os titulos selecionados atualiza os totais do Rodape�
	//�������������������������������������������������������������������������������������
	aRdpTlc[1][1]:Refresh()
	aRdpTlc[2][1]:Refresh()
	aRdpTlc[3][1]:Refresh()
	aRdpTlc[4][1]:Refresh()
	aRdpTlc[5][1]:Refresh()
	aRdpTlc[6][1]:Refresh()
	aRdpTlc[7][1]:Refresh()
	aRdpTlc[8][1]:Refresh()
	aRdpTlc[9][1]:Refresh()
	aRdpTlc[10][1]:Refresh()
	aRdpTlc[11][1]:Refresh()
	aRdpTlc[12][1]:Refresh()
Endif

//���������������������������������������������������������������Ŀ
//�Caso chegar ate aqui com o aCols vazio, entao carrega em branco�
//�����������������������������������������������������������������
If Len(aCols) == 0
	AAdd(aCols,Array(nUsado))

	nLenaHead := Len(aHeader)
	For nCampo := 1 TO nLenaHead
		aCols[Len(aCols)][nCampo] := CriaVar(aHeader[nCampo][2])
	Next nCampo

	aCols[Len(aCols)][nUsado] := .F.
	lRet := .F.
Else
	// Posiciona no primeiro titulo dos itens do atendimento de Telecobranca
	n := 1
	oGetTlc:oBrowse:Refresh()
	DbSelectarea("SE1")
	MsSeek(xFilial("SE1") + aCols[n][nPPrefix]+aCols[n][nPTitulo]+aCols[n][nPParcel]+aCols[n][nPTipo] )
Endif

Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274SE1Visual�Autor�Armando M. Tessaroli� Data � 04/11/03  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de visualizacao do Titulo, auxiliar da pesquisa F3 na���
���          �rotina de Telecobranca Tk274Tit().                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274SE1Visual(cPrefixo, cNum, cParcela, cTipo, cFilOrig)

DbSelectArea("SE1")
DbSetOrder(1)
MsSeek(cFilOrig + cPrefixo + cNum + cParcela + cTipo)

AxVisual("SE1", SE1->(Recno()), 2)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274SE1Pesq�Autor�Armando M. Tessaroli� Data �  04/11/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de pesquisa do Titulo, auxiliar da pesquisa F3 na ro-���
���          �tina de Telecobranca Tk274Tit().                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274SE1Pesq(	oPanel,		oTodos,		oInverte,	cExpressao,;
						oTitulos,	lPrefixo,	lNum,		lParcela,;
						lTipo,		lVencimento,lVencOrig,	lHistorico,;
						lNaturez,	lPortado,	lNumBor,	lEmissao,;
						lVencRea,	lPesq)


Local nPos	:= 0

If oPanel:lVisible
	oPanel:lVisible		:= .F.
	oTodos:Enable()
	oInverte:Enable()
Else
	oPanel:lVisible 	:= .T.
	oTodos:Disable()
	oInverte:Disable()
Endif

If !lPesq
	Return(.T.)
Endif

nPos := Ascan( oTitulos:aArray, {|x|	SubStr(	AllTrim(IIF(lPrefixo,x[3],"")) +;
												AllTrim(IIF(lNum,x[4],"")) +;
												AllTrim(IIF(lParcela,x[5],"")) +;
												AllTrim(IIF(lTipo,x[6],"")) +;
												AllTrim(IIF(lEmissao,x[7],"")) +;
												AllTrim(IIF(lVencimento,x[8],"")) +;
												AllTrim(IIF(lVencRea,x[9],"")) +;
												AllTrim(IIF(lVencOrig,x[10],"")) +;
												AllTrim(IIF(lHistorico,x[11],"")) +;
												AllTrim(IIF(lNaturez,x[12],"")) +;
												AllTrim(IIF(lPortado,x[13],"")) +;
												AllTrim(IIF(lNumBor,x[14],"")),1,Len(AllTrim(cExpressao))) == AllTrim(cExpressao) } )


If nPos > 0
	oTitulos:nAt := nPos
	oTitulos:SetFocus()
	oTitulos:Refresh()
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274DtVenc�Autor �Armando M. Tessaroli� Data �  14/08/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de validacao do campo ACF_DTVENC que representa a  da���
���          �ta de vencimento do titulo.                                 ���
�������������������������������������������������������������������������͹��
���Parametros�cOperador - Define o Operador que esta alterando a data para���
���          �            verificar as permicoes.                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274DtVenc(cOperador)

Local lRet		:= .F.									// Retorno da funcao
Local aArea		:= GetArea()							// Guarda a area atual	
Local cRegNeg   := TkPosto(M->ACF_OPERAD,"U0_REGNEG") 	// Codigo da Regra de Negociacao

DbSelectarea("SK2")
DbSetOrder(1)
If MsSeek(xFilial("SK2") + cRegNeg)
	If SK2->K2_ALTTIT == "1"	// SIM - Pode alterar Titulo
		If &(ReadVar()) >= dDataBase
			If SK2->K2_DIAPROR == 0
				lRet := .F.
			ElseIf &(ReadVar()) <= dDataBase + SK2->K2_DIAPROR
				lRet := .T.
			Endif
		Endif
	Endif
Endif

If !lRet
	Help(" ",1,"TKNPERMITE")
Endif

RestArea(aArea)
Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Tk271Valor� Autor �Fabio Rogerio Pereira  � Data � 21/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se valor podera' ser alterado, ou se abat > valor  ���
���          �Funcao existente no campo ACG_VALOR.                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �Tk274Valor() 												  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � CALL CENTER - TELECOBRANCA   							  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Tk274Valor(lValor)

Local nValor   := IIf(lValor,&(ReadVar()),aCols[n,aPosicoes[10,2]])
Local nRec     := 0
Local lRet     := .T.
Local nPTitulo := aPosicoes[1,2]
Local nPPrefixo:= aPosicoes[2,2]
Local nPParcela:= aPosicoes[3,2]
Local nPTipo   := aPosicoes[4,2]
Local nPFilOrig:= 0
Local cFilOrig := ""

If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
	If nPFilOrig > 0
		cFilOrig := aCols[nI][nPFilOrig]
	Else
		cFilOrig := xFilial("SE1")		
	Endif	
Else
	cFilOrig := xFilial("SE1")
Endif
If (Posicione("SE1",1,cFilOrig + aCols[n,nPPrefixo] + aCols[n,nPTitulo] + aCols[n,nPParcela] + aCols[n,nPTipo],"E1_MOEDA") > 99)
	Return(.F.)
Else
	nRec:= SE1->(RecNo())
Endif

//��������������������������������������������������������������Ŀ
//�Verifica se o abatimento e' maior que valor do titulo         �
//����������������������������������������������������������������
If !Empty(aCols[n,nPTipo])
	If (aCols[n,nPTipo] $ MVPROVIS)
		DbSelectArea( "SE1" )
		If DbSeek( cFilOrig +  aCols[n,nPPrefixo] + aCols[n,nPTitulo] + aCols[n,nPParcela])
			
			While !Eof() .AND. (SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA) == (cFilOrig,aCols[n,nPPrefixo] + aCols[n,nPTitulo] + aCols[n,nPParcela])
				If (SE1->E1_TIPO $ MVABATIM)
					DbSkip( )
					Loop
				Endif
				
				If (nValor > SE1->E1_SALDO)
					Help(" ",1,"ABATMAIOR")
					lRet := .F.
					Exit
				Endif

				Exit
			End
			
			SE1->(DbGoTo(nRec))
		Endif
	Endif
Endif

If (SE1->E1_LA = "S")
	Help(" ",1,"NAOVALOR")
	lRet:=.F.
Endif

If (SE1->E1_TIPO $ MVIRABT+"/"+MVINABT+"/"+MVCFABT+"/"+MVCSABT+"/"+MVPIABT)
		Help(" ",1,"NOVALORIR")
		lRet:=.F.
Endif
	
If (SE1->E1_TIPO $ MVRECANT)
	Help( " ",1,"FA040ADTO")
	lRet := .F.
Endif

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Tk271Natur� Autor �Fabio Rogerio Pereira  � Data � 21/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula os impostos se a natureza assim o mandar			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � Tk274Natur()												  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Ap6 Call Center	Telecobraca / Dicionario de dados   	  ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���Andrea F. �27/04/04�811   �- Alterado as posicoes dos campos           ���
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Tk274Natur(lNatureza)

Local lRet     := .T.
Local nPTitulo := aPosicoes[1][2] 		// Numero do Titulo
Local nPPrefixo:= aPosicoes[2][2]		// Prefixo do titulo
Local nPParcela:= aPosicoes[3][2]		// Parcela do Titulo
Local nPTipo   := aPosicoes[4][2]		// Tipo do titulo
Local nPNaturez:= aPosicoes[6][2]		// Natureza do titulo
Local nPValor  := aPosicoes[10][2]		// Valor Original do Titulo
Local nPIrrf   := aPosicoes[23][2]		// Valor do IRRF
Local nPIss    := aPosicoes[24][2]		// Valor do ISS
Local nPCsll   := aPosicoes[25][2]		// Valor do CSLL
Local nPCofins := aPosicoes[26][2]		// Valor do COFINS
Local nPPis    := aPosicoes[27][2]		// Valor do PIS
Local cNatureza:= ""                 	// Codigo da Natureza
Local nPFilOrig:= 0                    	// Posicao da Filial do titulo
Local cFilOrig := ""                    // Filial do Titulo

Default lNatureza := .T.
If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
    If nPFilOrig > 0
		cFilOrig := aCols[nI][nPFilOrig]
	Else
		cFilOrig := xFilial("SE1")	
	Endif	
Else
	cFilOrig := xFilial("SE1")
Endif

cNatureza:= IIf(lNatureza, &(ReadVar()), aCols[n,nPNaturez])

If Empty(cNatureza)
	Return(lRet)
Endif

//�����������������������������������������������������������Ŀ
//� N�o permite alterar natureza se titulo ja foi contabiliz. �
//�������������������������������������������������������������
If (Posicione("SE1",1,cFilOrig + aCols[n,nPPrefixo] + aCols[n,nPTitulo] + aCols[n,nPParcela] + aCols[n,nPTipo] ,"E1_LA") = "S")
	Help(" ",1,"NAOVALOR")
	Return(.F.)
Endif
	
//�����������������������������������������������������������Ŀ
//� N�o permite alterar natureza quando adiantamento para n�o �
//� desbalancear o arquivo de Movimenta��o Banc�ria (SE5).    �
//�������������������������������������������������������������
If (aCols[n,nPTipo] $ MVRECANT)
	Help(" ",1,"FA040NONAT")
	Return(.F.)
Endif

DbSelectArea("SED")
If !(DbSeek(xFilial("SED") + cNatureza))
	Help(" ",1,"E1_NATUREZ")
	lRet := .F.
Else
   //�����������������������������������������������������������Ŀ
	//� Tratamento dos campos dos impostos Brasileiros E1_IRRF,  �
	//� E1_INSS, etc...											 �
	//��Transp DM Argentina Lucas e Armando 05/01/00��������������
	If (aCols[n,nPValor] > 0)
		aCols[n,nPIrrf] := 0

		//�����������������������������������������������������Ŀ
		//� Calcula IR se a natureza mandar  				    �
		//�������������������������������������������������������
		If (SED->ED_CALCIRF == "S")
			aCols[n,nPIrrf]:= NoRound(aCols[n,nPValor] * Iif(AllTrim(Str(SE1->E1_MOEDA,2))$"01",1,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA))) * IIf(SED->ED_PERCIRF > 0, SED->ED_PERCIRF, GetMV("MV_ALIQIRF"))/100
		Endif

		//�����������������������������������������������������������Ŀ
		//� Titulos Provisorios ou Antecipados n�o geram IR        	  �
		//�������������������������������������������������������������
		If (aCols[n,nPTipo] $ MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM)
			aCols[n,nPIrrf] := 0
		Endif
	
		//�����������������������������������������������������������Ŀ
		//� Tratamento de Dispensa de Retencao de IRF             	  �
		//�������������������������������������������������������������
		If (aCols[n,nPIrrf] <= GetMv("MV_VLRETIR") )
			aCols[n,nPIrrf] := 0
		Endif              
		
		aCols[n,nPIss]:= 0
	
		//�����������������������������������������������������������Ŀ
		//� Calcula ISS se natureza mandar                         	  �
		//�������������������������������������������������������������
		If (SED->ED_CALCISS == "S")
			aCols[n,nPIss]  := aCols[n,nPValor] * GetMV("MV_ALIQISS") / 100
		Endif
	
		//�����������������������������������������������������������Ŀ
		//� Titulos Provisorios ou Antecipados n�o geram ISS       	  �
		//�������������������������������������������������������������
		If (aCols[n,nPTipo] $ MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM)
			aCols[n,nPIss] := 0
		Endif             
		
		aCols[n,nPCsll] := 0
		//�����������������������������������������������������Ŀ
		//� Calcula CSLL se a natureza mandar 					�
		//�������������������������������������������������������
		If (SED->ED_CALCCSL == "S") .AND. (SA1->A1_RECCSLL == "S")
			aCols[n,nPCsll] := (aCols[n,nPValor] * (SED->ED_PERCCSL / 100))
		Endif                                  
		
		//�����������������������������������������������������������Ŀ
		//� Titulos Provisorios ou Antecipados n�o geram CSLL         �
		//�������������������������������������������������������������
		If (aCols[n,nPTipo] $ MVPROVIS+"/"+MVRECANT+"/"+MVPROVIS+"/"+MV_CRNEG+"/"+MVABATIM)
			aCols[n,nPCsll] := 0
		Endif

		//�����������������������������������������������������������Ŀ
		//� Tratamento de Dispensa de Retencao de CSLL             	  �
		//�������������������������������������������������������������
		If ( aCols[n,nPCsll] < GetMv("MV_VRETCSL") )
			aCols[n,nPCsll] := 0
		Endif

		aCols[n,nPCofins] := 0

		//�����������������������������������������������������Ŀ
		//� Calcula COFINS se a natureza mandar 					  �
		//�������������������������������������������������������
		If (SED->ED_CALCCOF == "S") .AND. (SA1->A1_RECCOFI == "S")
			aCols[n,nPCofins] := (aCols[n,nPValor] * (IIf(SED->ED_PERCCOF > 0, SED->ED_PERCCOF, GetMv("MV_TXCOFIN")) / 100))
		Endif

		//�����������������������������������������������������������Ŀ
		//� Titulos Provisorios ou Antecipados n�o geram COFINS       �
		//�������������������������������������������������������������
		If (aCols[n,nPTipo] $ MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM)
			aCols[n,nPCofins]:= 0
		Endif

		//�����������������������������������������������������������Ŀ
		//� Tratamento de Dispensa de Retencao de COFINS           	  �
		//�������������������������������������������������������������
		If ( aCols[n,nPCofins] < GetMv("MV_VRETCOF") )
			aCols[n,nPCofins] := 0
		Endif

		aCols[n,nPPis] := 0

		//�����������������������������������������������������Ŀ
		//� Calcula PIS se a natureza mandar 					  	  �
		//�������������������������������������������������������
		If (SED->ED_CALCPIS == "S") .AND. (SA1->A1_RECPIS == "S")
			aCols[n,nPPis] := (aCols[n,nPValor] * (IIf(SED->ED_PERCPIS > 0, SED->ED_PERCPIS, GetMv("MV_TXPIS")) / 100))
		Endif

		//�����������������������������������������������������������Ŀ
		//� Titulos Provisorios ou Antecipados n�o geram PIS          �
		//�������������������������������������������������������������
		If (aCols[n,nPTipo] $ MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM)
			aCols[n,nPPis] := 0
		Endif

		//�����������������������������������������������������������Ŀ
		//� Tratamento de Dispensa de Retencao de PIS             	  �
		//�������������������������������������������������������������
		If ( aCols[n,nPPis] < GetMv("MV_VRETPIS") )
			aCols[n,nPPis] := 0
		Endif

	Endif

	If  cNatureza $ &(GetMv("MV_IRF")) 	.OR. ;
		cNatureza $ &(GetMv("MV_ISS")) 	.OR. ;
		cNatureza $ &(GetMv("MV_INSS")) .OR. ;
		cNatureza $ (GetMv("MV_CSLL"))	.OR. ;
		cNatureza $ (GetMv("MV_COFINS")).OR. ;
		cNatureza $ (GetMv("MV_PISNAT")) 

		aCols[n,nPTipo] := MVTAXA
		aCols[n,nPTipo]	:= IIf(cNatureza $ (GetMv("MV_CSLL"))	,"MVCSABT" , aCols[n,nPTipo])
		aCols[n,nPTipo]	:= IIf(cNatureza $ (GetMv("MV_COFINS")),"MVCFABT-", aCols[n,nPTipo])
		aCols[n,nPTipo]	:= IIf(cNatureza $ (GetMv("MV_PISNAT")),"MVPIABT" , aCols[n,nPTipo]) 
	Endif
Endif  

Return(lRet)

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun��o	 �Tk271TlcImposto � Autor �Fabio Rogerio Pereira  � Data � 21/08/01 ���
�������������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula os impostos se a natureza assim o mandar		            ���
�������������������������������������������������������������������������������Ĵ��
��� Uso		 � Ap6 Call Center / Telecobranca - Dicionario de dados             ���
�������������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                               ���
�������������������������������������������������������������������������������Ĵ��
���Andrea F. �27/04/04�811   �- Alterado as posicoes dos campos                 ���
���          �        �      �                                            		���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
/*/
Function Tk274TlcImposto(cImposto)
Local lRet     := .T.
Local nPTitulo := aPosicoes[1][2]		// Numero do Titulo
Local nPPrefixo:= aPosicoes[2][2]		// Prefixo do Titulo
Local nPParcela:= aPosicoes[3][2]      // Parcela do Titulo
Local nPTipo   := aPosicoes[4][2]		// Tipo do Titulo
Local nPValor  := aPosicoes[10][2]		// Valor Original do Titulo	
Local nPIrrf   := aPosicoes[23][2]		// Valor de IRRF
Local nPIss    := aPosicoes[24][2]		// Valor de ISS
Local nPCsll   := aPosicoes[25][2]		// Valor de CSLL
Local nPCofins := aPosicoes[26][2]		// Valor de COFINS
Local nPPis    := aPosicoes[27][2]		// Valor de PIS
Local nPFilOrig:= 0
Local cFilOrig := ""
	
If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
	If nPFilOrig > 0
		cFilOrig := aCols[nI][nPFilOrig]
	Else
		cFilOrig := xFilial("SE1")
	Endif	
Else
	cFilOrig := xFilial("SE1")
Endif
If (Posicione("SE1",1,cFilOrig + aCols[n,nPPrefixo] + aCols[n,nPTitulo] + aCols[n,nPParcela] + aCols[n,nPTipo] ,"E1_LA") = "S")
	Help(" ",1,"NAOVALOR")
	Return(.F.)
Endif

Do Case
	Case (cImposto == "IRRF")
		lRet:= IIf ((aCols[n,nPIrrf] < aCols[n,nPValor]) .AND.;
			 		(aCols[n,nPTipo] <> "PR" .AND. aCols[n,nPIrrf] > 0),.T.,.F.)
					
	Case (cImposto == "ISS")
		lRet:= IIf ((aCols[n,nPIss] < aCols[n,nPValor]) .AND.;
			 		(aCols[n,nPTipo] <> "PR" .AND. aCols[n,nPIss] > 0),.T.,.F.)

	Case (cImposto == "CSLL")
		lRet:= IIf ((aCols[n,nPCsll] > aCols[n,nPValor]) .AND.;
			 		(aCols[n,nPTipo] <> "PR" .AND. aCols[n,nPCsll] > 0),.T.,.F.)

	Case (cImposto == "COFINS")
		lRet:= IIf ((aCols[n,nPCofins] > aCols[n,nPValor]) .AND.;
			 		(aCols[n,nPTipo] <> "PR" .AND. aCols[n,nPCofins] > 0),.T.,.F.)

	Case (cImposto == "PIS")
		lRet:= IIf ((aCols[n,nPPis] > aCols[n,nPValor]) .AND.;
			 		(aCols[n,nPTipo] <> "PR" .AND. aCols[n,nPPis] > 0),.T.,.F.)

EndCase

Return(lRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Tk271EnvTlc  � Autor �Marcelo Kotaki       � Data � 29/11/02���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o envio de email para os usuarios selecionados      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Somente Telecobranca		   						          ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���Marcelo K �17/07/03�710   �-Captura a senha sem criptografia do SU7    ���
���Andrea F. �30/12/04�811   �BOPS 77085 - Utilizar a descricao dos campos���
���          �        �      �a partir do dicionario de dados para envio  ���
���          �        �      �de e-mail.                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Tk274EnvTlc(cCidade,cEst,cTelRes,cTelCom1,cEnd,aSX3ACF)

Local aCabecalho:= {}                                         					// Array que carrega a descricao do atendimento
Local aItens	:= {}															// Array para compor os itens do atendimento
Local aLabel	:= {}															   
Local nLinhas	:= 0															// Percorre as linhas do acols para montar a descricao
Local cMensagem := ""															// Monta a descricao do atendimento
Local aSend		:= {}															// Monta um array com os destinatarios de cada linha do acols
Local cEmail	:= ""															// e-mail do remetente
Local cAssunto	:= ""															// Assunto do email
Local nCont		:= 0															// Contador	
Local nPTitulo	:= aPosicoes[1][2]												// Titulo
Local nPPrefix	:= aPosicoes[2][2]                             					// Prefixo
Local nPParcel	:= aPosicoes[3][2]                                              // Parcela
Local nPTipo	:= aPosicoes[4][2]												// Tipo
Local nPDtVenc	:= aPosicoes[8][2]                                              // Data de Vencimento
Local nPDtReal	:= aPosicoes[9][2] 												// Data de Vencimento Real				
Local nPValor	:= aPosicoes[10][2]                                             // Valor do titulo
Local nPAcresc	:= aPosicoes[14][2]												// Acrescimo
Local nPDecres	:= aPosicoes[15][2]                                             // Decrescimo
Local nPOperad	:= aPosicoes[17][2]                                             // Operador
Local nPValJur	:= aPosicoes[20][2]                                             // Valor de juros
Local nPPorJur	:= aPosicoes[21][2]                                             // Porcentual de juros
Local nPStatus	:= aPosicoes[30][2]                                             // Status

//Variaveis utilizadas nos itens do e-mail para exibir os titulos
Local cStatus	:= ""															// Contem o status do titulo
Local cPrefixo	:= ""                                                          	// Contem o prefixo do titulo
Local cTitulo 	:= ""                                                          	// Contem o Numero do titulo
Local cParcela	:= ""                                                          	// Contem a Parcela do titulo
Local cTipo   	:= ""                                                          	// Contem o Tipo do titulo
Local cDtVencto := ""                                                          	// Contem a Data de Vencimento 
Local cDtReal   := ""                                                          	// Contem o Data Real 
Local cValor	:= ""                                                          	// Contem o Valor a Receber
Local cAcresc	:= ""                                                          	// Contem o Valor de Acrescimo
Local cDescres	:= ""                                                          	// Contem o Valor de Descrecimo
Local cTxPerm	:= ""                                                          	// Contem a Taxa de Permanencia
Local cJuros	:= ""                                                          	// Contem a Taxa de Juros 
Local aStatuAt	:= TkSx3Box("ACF_STATUS")                                      	// Contem o status do atendimento 
Local cAccount	:= Posicione("SU7",1,xFilial("SU7") + M->ACF_OPERAD,"U7_CONTA")	// Conta do remetente
Local cPassword	:= Posicione("SU7",1,xFilial("SU7") + M->ACF_OPERAD,"U7_SENHA")	// Senha do remetente
Local cUsaEmail := TkPosto(M->ACF_OPERAD,"U0_TLCMAIL")							// Validacao se o operador pode mandar email

// Captura a senha do operador sem criptografia
If !Empty(cPassword)
	cPassword := Embaralha(cPassword,1)
Endif

//������������������������������������������������������������Ŀ
//�Verifica se o operador pode mandar email para os clientes   �
//��������������������������������������������������������������
If cUsaEmail == "1"  //Sim

	//��������������������������������������������������������������������������Ŀ
	//�Pesquisa no SX3 qual a descricao dos campos, caso o usuario tenha alterado�
	//�e monta o ARRAY  com o cabecalho do atendimento de Telecobranca.			 �
	//����������������������������������������������������������������������������
	// 01 - Atendimento
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_CODIGO"})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4], M->ACF_CODIGO}),"")	
    
    // 02 - Codigo + Loja + Nome do cliente
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_CLIENT"})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4], M->ACF_CLIENT + "-" + M->ACF_LOJA + " - " +M->ACF_DESC }),"")	
	
	// 03 - Contato + Nome do contato
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_CODCON"})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4], M->ACF_CODCON + " - " + ACF_DESCNT}),"") 
	
	// 04 - Cidade - Estado 
	Aadd(aCabecalho, {"Cidade",cCidade + "-" + cEst})
	// 05 - Endereco			
	Aadd(aCabecalho, {"Endere�o",cEnd})								
	// 06 - Telefone Resid/Comer -06
	Aadd(aCabecalho, {"Telefones",Transform(cTelRes,"@R 9999-9999") + "/" + Transform(cTelCom1,"@R 9999-9999")})

	// 07 - Operador + Nome do operador
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_OPERAD"})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4], M->ACF_OPERAD+ " - " + ACF_DESCOP}),"")	
	
	// 08 - Ligacao: ATIVO/RECEPTIVO 
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_OPERA "})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4],IIF(VAL(M->ACF_OPERA) == ATIVO,STR0056,STR0057)}),"")

	// 09 - Status: STATUS DO ATENDIMENTO
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_STATUS"})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4],IIF(!Empty(M->ACF_STATUS),aStatuAt[Val(M->ACF_STATUS)],"")}),"")
	
	// 10 - Ocorrencia + Codigo + Descricao da ocorrencia
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_MOTIVO"})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4], M->ACF_MOTIVO + " - " +ACF_DESCMO }),"")
	
	// 11 - Data do atendimento 
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_DATA  "})
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4],DTOC(M->ACF_DATA)}),"")	

	// 12 - Data e Hora do Retorno
	AAdd(aCabecalho, {STR0060, DTOC(M->ACF_PENDEN) + " - " + M->ACF_HRPEND})								
	
	// 13 - Observacao do atendimento	 
	nPos	:= Ascan(aSx3ACF,{|x| x[1] $ "ACF_OBS   "})  
	IIf (nPos > 0,AAdd(aCabecalho, {aSx3ACF[nPos][4],MSMM(ACF->ACF_CODOBS,80)}),"")

	//�������������������������������������������������
	//�Busca a descricao dos campos existentes no SX3.�
	//�������������������������������������������������
	Posicione("SX3",2,"ACG_PREFIX"	,"X3_TITULO")
	cPrefixo	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_TITULO"	,"X3_TITULO")
	cTitulo 	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_PARCEL"	,"X3_TITULO")
	cParcela	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_TIPO"	,"X3_TITULO")
	cTipo   	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_DTVENC"	,"X3_TITULO")
	cDtVencto:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_DTREAL"	,"X3_TITULO")
	cDtReal 	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_VALOR"	,"X3_TITULO")
	cValor  	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_ACRESC"	,"X3_TITULO")
	cAcresc 	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_DECRES"	,"X3_TITULO")
	cDescres	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_VALJUR"	,"X3_TITULO")
	cTxPerm 	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_JUROS"	,"X3_TITULO")
	cJuros  	:= Alltrim(X3Titulo())       
	Posicione("SX3",2,"ACG_STATUS"	,"X3_TITULO")
	cStatus 	:= Alltrim(X3Titulo())       

	AAdd( aLabel, {cPrefixo	, "30",	"left"}) 	//"Prf"
	AAdd( aLabel, {cTitulo 	, "50",	"left"}) 	//"Titulo"
	AAdd( aLabel, {cParcela	, "30",	"left"}) 	//"Par"
	AAdd( aLabel, {cTipo   	, "30",	"left"}) 	//"Tipo"
	AAdd( aLabel, {cDtVencto, "55",	"left"})	//"Venc"
	AAdd( aLabel, {cDtReal 	, "55",	"left"}) 	//"Real"
	AAdd( aLabel, {cValor 	, "75",	"right"}) 	//"Valor"
	AAdd( aLabel, {cAcresc	, "60",	"right"}) 	//"Acresc"
	AAdd( aLabel, {cDescres	, "60",	"right"}) 	//"Decres"
	AAdd( aLabel, {cTxPerm	, "40",	"right"}) 	//"Perm"
	AAdd( aLabel, {cJuros 	, "40",	"right"}) 	//"Juros"
	AAdd( aLabel, {cStatus 	, "50",	"left"}) 	//"Status"

	//���������������������������������������������������������������Ŀ
	//�Monta o ARRAY  com os itens do atendimento do Telecobranca  	  �
	//�����������������������������������������������������������������
	For nLinhas := 1 TO len(aCols)
		
		Do Case
			Case aCols[nLinhas][nPStatus] == "1"
				cStatus := STR0073 //"PAGO"
		
			Case aCols[nLinhas][nPStatus] == "2"
				cStatus := STR0074 //"NEGOCIADO"
		
			Case aCols[nLinhas][nPStatus] == "3"
				cStatus := STR0075 //"CARTORIO"
		
			Otherwise
				cStatus := ""
		EndCase
		
		If !(aCols[nLinhas][Len(aHeader)+1])	// Se a linha nao estiver apagada.
		
			If !Empty(aCols[nLinhas][nPOperad]) // Se houver um operador selecionado
				AAdd( aItens,	{ SubStr(aCols[nLinhas][nPPrefix],1,3),;								// 01
								  SubStr(aCols[nLinhas][nPTitulo],1,6),;								// 02
								  SubStr(aCols[nLinhas][nPParcel],1,1),;								// 03
								  SubStr(aCols[nLinhas][nPTipo],1,3),;                                  // 04
								  DTOC(aCols[nLinhas][nPDtVenc]),;                                      // 05
								  DTOC(aCols[nLinhas][nPDtReal]),;                                      // 06
								  Transform(aCols[nLinhas][nPValor] , PesqPict("ACG", "ACG_VALOR")),;   // 07  
								  Transform(aCols[nLinhas][nPAcresc], PesqPict("ACG", "ACG_ACRESC")),;  // 08
								  Transform(aCols[nLinhas][nPDecres], PesqPict("ACG", "ACG_DECRES")),;  // 09 
								  Transform(aCols[nLinhas][nPValJur], PesqPict("ACG", "ACG_VALJUR")),;  // 10
								  Transform(aCols[nLinhas][nPPorJur], PesqPict("ACG", "ACG_PORJUR")),;  // 11
								  cStatus } )
							
				//�������������������������������������������������������Ŀ
				//�Monta o ARRAY para o numero de usuarios que vao receber�
				//���������������������������������������������������������
				cEmail 	 := UsrRetMail(aCols[nLinhas][nPOperad])+";"
				cAssunto := STR0076 //"Atendimento call center - Telecobran�a"
				
				If (At("@",cEmail) > 0)
					//���������������������������������������Ŀ
					//�So serao somados os e-mails diferentes.�
					//�����������������������������������������
					If (Ascan(aSend,{|x| ALLTRIM(x[1]) == ALLTRIM(cEmail)}) == 0 )
						AAdd(aSend,{cEmail,cAssunto,"",""})
					Endif
				Endif
			Endif
			
		Endif      
		
	Next nLinhas
	
	//������������������������������������������Ŀ
	//�Pega a conta e a senha do email do usuario�
	//��������������������������������������������
	If Len(aSend) > 0
		If TkAccount(@cAccount,@cPassword)
		
		   	//������������������������������������������Ŀ
			//�Monta o corpo do E-mail                   �
			//��������������������������������������������
		    Tk274Body(@cMensagem,aCabecalho,aItens,aLabel)

			For nCont := 1 TO Len(aSend)
				aSend[nCont][MENSAGEM] := cMensagem
			Next nCont
				
			//���������������Ŀ
			//�Envio de E-mail�
			//�����������������
			For nCont:= 1 To Len(aSend)              
				MsgRun(  STR0077,"",; //"Enviando e-mail para os respons�veis..."
						{ ||lSend:= TkSendMail(	cAccount			,cPassword				,GetMV("MV_RELSERV")	,UsrRetMail(__cUserID),;
												aSend[nCont][EMAIL]	,aSend[nCont][ASSUNTO]	,aSend[nCont][MENSAGEM]	,aSend[nCont][ANEXO]) })
			Next nCont
		Endif
	Endif
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �TK274Body �Autor  �Armando Tessaroli   � Data �  16/10/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta o corpo do e-mail em Html                             ���
�������������������������������������������������������������������������͹��
���Uso       �Somente Telecobranca                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Function Tk274Body(cMensagem,aCabecalho,aItens,aLabel)

Local nI := 0			// Contador
Local nJ := 0			// Contador	

cMensagem := "<html>"  
cMensagem += "<body>"  

cMensagem += '<p align="center"><b><font color="#FF0000" face="Arial" size="4">'
cMensagem += STR0034 //"Call Center TeleCobran�a"
cMensagem += '</font></b></p>'

cMensagem += '<hr>'

cMensagem += '<p><font face="Arial"><b>'
cMensagem += STR0035 //"Dados do Atendimento"
cMensagem += '</b></font></p>'

//������������������������������������������������������������Ŀ
//�comeca a montar o cabecalho do atendimento no e-mail        �
//��������������������������������������������������������������
cMensagem += '<table border="1" >'	// width="100%"

For nI := 1 TO Len(aCabecalho)
	cMensagem += '<tr>'
	cMensagem += '<td width="200"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
	cMensagem += IIF(!Empty(aCabecalho[nI][1]),aCabecalho[nI][1],'&nbsp;')
	cMensagem += '</font>&nbsp;</font></b></td>'
	cMensagem += '<td width="460"><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aCabecalho[nI][2]),aCabecalho[nI][2],'&nbsp;')
	cMensagem += '</font></td>'
	cMensagem += '</tr>'
Next nI
                        
cMensagem += "</table>"
cMensagem += "<br>"

//�����������������������������������������������������������������Ŀ
//�Agora monta  o label dos itens do atendimento para o e-mail      �
//�������������������������������������������������������������������
cMensagem += '<table border="1" >'		// width="100%"

cMensagem += '<tr>'
For nI := 1 TO Len(aLabel)
	cMensagem += '<td width="'+aLabel[nI][2]+'"><b><font color="#0000FF" face="Verdana" size="1">'
	cMensagem += IIF(!Empty(aLabel[nI][1]),aLabel[nI][1]+'&nbsp;','&nbsp;')
	cMensagem += '</font></td>'
Next nI
cMensagem += '</tr>'

//�������������������������������������������Ŀ
//�Monta os itens do atendimento para o e-mail�
//���������������������������������������������
For nI := 1 To Len(aItens)
	cMensagem += '<tr>'
	For nJ := 1 to Len(aItens[nI])
		cMensagem += '<td width="'+aLabel[nJ][2]+'"><font face="Verdana" size="1">'
		cMensagem += Iif(!Empty(aItens[nI][nJ]),'<p align="'+aLabel[nJ][3]+'">'+aItens[nI][nJ]+'&nbsp;'+'</td>','&nbsp;')
		cMensagem += '</font></td>'
	Next nJ
	cMensagem += '</tr>'
Next nI
cMensagem += "</table>"

//cMensagem += '<p>&nbsp;</p>'
cMensagem += '</body>'
cMensagem += '</html>'

Return(.T.)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �TK271EvaTlc  �Autor  �Armando Tessaroli   � Data �  15/10/02   ���
����������������������������������������������������������������������������͹��
���Desc.     �Validacao na troca da linha no browser que contem os titulos   ���
���          �no telecobranca.                                               ���
����������������������������������������������������������������������������͹��
���Uso       � Call Center                                                   ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Function TK274EvaTlc()
Local lRet := .T.
Local nPTitulo	:= Ascan(aHeader, {|x| x[2] == "ACG_TITULO"} )

If !aCols[n][Len(aCols[n])] .AND. Empty(aCols[n][nPTitulo])
	Help("",1,"FALTA_TIT")
	lRet := .F.
Endif

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK274HACF     �Autor  �Marcelo Kotaki  � Data �  22/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao da hora de retorno                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TELECOBRANCA                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function TK274HACF()

Local cHora := &( ReadVar() )
Local lRet	:= .F.

If !Empty(cHora)
	If (M->ACF_PENDEN == M->ACF_DATA)
		If cHora >= Time()
			lRet := .T.
		Endif
	ElseIf (M->ACF_PENDEN > M->ACF_DATA)
		If (cHora >= "00:00") .AND. (cHora <= "24:00")
			lRet := .T.
		Endif		
	Endif	
Endif           
                                                                          
Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Itens�Autor  �Armando M. Tessaroli� Data �  31/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta funcao carrega os titulos na tela de atendimento que de���
���          �verao ser cobrados pelo operador.                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �24/04/04�811   �- Posicoes 4 e 5 do array Avalores substi-  ���
���          �        �      �tuidas pelos campos E1_SDACRES e E1_SDDECRE ���
���          �        �      �- Preenchimento automatico dos campos       ���
���          �        �      �ACG_VALREF, ACG_BAIXA e ACG_STATUS 		  ���
���          �        �      �de acordo com o SE1.						  ���
���Andrea F. �18/02/05�8.11  �Bops 78988. Utilizar a posicao dos campos   ���
���          �        �      �carregada no array aItens para pesquisar o  ���
���          �        �      �titulo no SE1.							  ���
���Cleber M. �07/09/05� 85694�- Substituida a variavel indice nI (aItens) ���
���          �        �8.11  �pelo Len(aCols), para evitar erro de Array  ���
���          �        �      �quando o titulo nao existir mais no SE1     ���
���Marcelo K.�09/08/05�8.11  �-Incluida a limpeza do rodape Telecobranca. ���
���          �86209   �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Itens(aItens)

Local nPTitulo	:= aPosicoes[1][2]		//Numero do Titulo
Local nPPrefix	:= aPosicoes[2][2]		//Prefixo do Titulo
Local nPParcel	:= aPosicoes[3][2]		//Parcela do Titulo
Local nPTipo	:= aPosicoes[4][2]		//Tipo do Titulo
Local nPRecebe	:= aPosicoes[11][2]		//Valor a Receber do Titulo
Local nPJuros	:= aPosicoes[12][2]		//Valor de Juros do Titulo
Local nPPromoc	:= aPosicoes[16][2]		//Promocao 
Local nPValRef	:= aPosicoes[28][2]		//Valor de Referencia
Local nPBaixa   := aPosicoes[29][2]		//Log de Baixa        
Local nPStatus  := aPosicoes[30][2]		//Status do Atendimento
Local nPDtReal	:= aPosicoes[9][2] 		//Data de Vencimento Real				
Local nPAtraso	:= Ascan(aHeader, {|x| x[2] == "ACG_ATRASO"} )
Local nUsado	:= Len(aHeader) + 1
Local nI		:= 0
Local nJ		:= 0
Local aValores	:= {}
Local nPFilOrig	:= 0                 
Local cFilOrig	:= ""

//������������������������������������������Ŀ
//� Seta a posicao do campo Filial de Origem �
//��������������������������������������������
If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
Endif

// Limpa os Itens para comecar a carregar
aCols := {}

// Zera o rodape para recalcular e acordo com os itens carregados
Tk274LimpaRdp()

//������������������������������������������������������������Ŀ
//�Cria linhas no acols se existir mais de um item selecionado.�
//��������������������������������������������������������������
For nI:= 1 To Len(aItens)
	
	If nPfilOrig > 0
		cFilOrig:= aItens[nI][5]	//Filial de origem do titulo
	Else
		cFilOrig:= xFilial("SE1")
	Endif		
	
	//���������������������������������������������Ŀ
	//� Verifica se o titulo ainda existe no SE1    �
	//�����������������������������������������������
	DbSelectArea("SE1")
	DbSetOrder(1)//Filial + Prefixo + Numero + Parcela + Tipo
	If MsSeek(cFilOrig + aItens[nI][1] + aItens[nI][2] + aItens[nI][3] + aItens[nI][4])

		//���������������������������������������������������Ŀ
		//�Adiciona uma linha no acols e inicializa os campos.�
		//�����������������������������������������������������
		AAdd(aCols,Array(nUsado))
		For nJ := 1 to Len(aHeader)
			aCols[Len(aCols)][nJ] := CriaVar(aHeader[nJ][2])
		Next nJ
		aCols[Len(aCols)][nUsado] := .F.

		//�������������������������������������������������Ŀ
		//�Atualiza o campos do acols e executa os gatilhos.�
		//���������������������������������������������������
		aCols[Len(aCols)][nPTitulo] := aItens[nI][2]
		Posicione("SX3",2,"ACG_TITULO","")
		RunTrigger(2,Len(aCols))
		
		aValores := FaVlAtuCr()

		//����������������������������������������������������������������������������������Ŀ
		//�Atualiza o Valor de Referencia, Receber, Juros, Baixa e Status na Inclusao        �
		//������������������������������������������������������������������������������������
		aCols[Len(aCols)][nPValRef]	:= aValores[6]	//Saldo do Titulo 
		aCols[Len(aCols)][nPJuros]	:= aValores[8]
		aCols[Len(aCols)][nPRecebe]	:= aValores[12]
		aCols[Len(aCols)][nPAtraso]	:= dDataBase - aCols[Len(aCols)][nPDtReal]
  		If nPFilOrig > 0
	  		aCols[Len(aCols)][nPFilOrig]:= aItens[nI][5] //Filial Original do titulo
	  	Endif

        Do Case 
        	Case !Empty(SE1->E1_BAIXA) // Se houve uma baixa verifica se foi TOTAL ou PARCIAL
        		 If (SE1->E1_SALDO > 0)
					aCols[Len(aCols)][nPBaixa] := "1" //Baixa Parcial
					aCols[Len(aCols)][nPStatus]:= "4" //Baixa
				 Endif
				 
				 If (SE1->E1_SALDO == 0)
					aCols[Len(aCols)][nPBaixa] := "3" //Baixa Total
					aCols[Len(aCols)][nPStatus]:= "1" //Pago
				 Endif	

	        Case Empty(SE1->E1_BAIXA) // Nao houve nenhuma baixa 
				aCols[Len(aCols)][nPBaixa] := "2" //Sem Baixa            	

	  	EndCase	  	
	  	
		// [2] Abatimentos
		// [A] Correcao Monetaria
		// [8] Juros
		// [5] Acrescimo	- E1_SDACRES
		// [4] Decrescimo   - E1_SDDECRE
		// [9] Desconto
		// [1] Valor Original do Titulo
		// [6] Saldo do Titulo na Moeda do Titulo
		// [7] Saldo do Titulo na Moeda Corrente
		// [3] Pagto Parcial
		// [B] Valor a ser Recebido na moeda do titulo
		// [C] Valor a ser Recebido na moeda corrente				

		//�������������������������������Ŀ
		//� Atualiza os valores no Rodape �
		//���������������������������������
		aRdpTlc[1][2]	:= aRdpTlc[1][2] + aValores[2]
		aRdpTlc[2][2]	:= aRdpTlc[2][2] + aValores[10]
		aRdpTlc[3][2]	:= aRdpTlc[3][2] + aValores[8]
		aRdpTlc[4][2]	:= aRdpTlc[4][2] + SE1->E1_SDACRES 
		aRdpTlc[5][2]	:= aRdpTlc[5][2] + SE1->E1_SDDECRE
		aRdpTlc[6][2]	:= aRdpTlc[6][2] + aValores[9]
		aRdpTlc[7][2]	:= aRdpTlc[7][2] + aValores[1]
		aRdpTlc[8][2]	:= aRdpTlc[8][2] + aValores[6]
		aRdpTlc[9][2]	:= aRdpTlc[9][2] + aValores[7]
		aRdpTlc[10][2]	:= aRdpTlc[10][2]+ aValores[3]
		aRdpTlc[11][2]	:= aRdpTlc[11][2]+ aValores[11]
		aRdpTlc[12][2]	:= aRdpTlc[12][2]+ aValores[12]
		
		aRdpTlc[1][1]:Refresh()
		aRdpTlc[2][1]:Refresh()
		aRdpTlc[3][1]:Refresh()
		aRdpTlc[4][1]:Refresh()
		aRdpTlc[5][1]:Refresh()
		aRdpTlc[6][1]:Refresh()
		aRdpTlc[7][1]:Refresh()
		aRdpTlc[8][1]:Refresh()
		aRdpTlc[9][1]:Refresh()
		aRdpTlc[10][1]:Refresh()
		aRdpTlc[11][1]:Refresh()
		aRdpTlc[12][1]:Refresh()
		
		//����������������������������������������������
		//� Verifica as regras de desconto no cadastro �
		//� de Promocao de Cobranca (SK3)              �
		//����������������������������������������������
		DbSelectArea("SK3")
		DbSetOrder(2)		// K3_FILIAL+K3_VCTINI
		MsSeek(xFilial("SK3") + DtoS(SE1->E1_VENCREA), .T.)
		If SE1->E1_VENCREA >= SK3->K3_VCTINI .AND. SE1->E1_VENCREA <= SK3->K3_VCTFIM
			If dDataBase >= SK3->K3_INICIO .AND. dDataBase <= SK3->K3_FINAL
				aCols[Len(aCols)][nPPromoc] := SK3->K3_CODIGO
			Endif
		Else
			DbSkip(-1)
			If SE1->E1_VENCREA >= SK3->K3_VCTINI .AND. SE1->E1_VENCREA <= SK3->K3_VCTFIM
				If dDataBase >= SK3->K3_INICIO .AND. dDataBase <= SK3->K3_FINAL
					aCols[Len(aCols)][nPPromoc] := SK3->K3_CODIGO
				Endif
			Endif
		Endif
		
	Endif
Next

//���������������������������������������������������������������Ŀ
//�Caso chegar ate aqui com o aCols vazio, entao carrega em branco�
//�����������������������������������������������������������������
If Len(aCols) == 0
	AAdd(aCols,Array(nUsado))
	For nI := 1 to Len(aHeader)
		aCols[Len(aCols)][nI] := CriaVar(aHeader[nI][2])
	Next nI
	aCols[Len(aCols)][nUsado] := .F.
	n := 1
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Campos�Autor �Armando M. Tessaroli� Data �  13/08/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta funcao define os campo que estarao desabilitados para e���
���          �dicao na enchoice.                                          ���
�������������������������������������������������������������������������͹��
���Parametros�aCampos - Devolve por @ os campos que ficarao desabilitados ���
���          �lAtivo  - Tipo de atendimento ATIVO / RECEPTIVO             ���
���          �nOpc    - Tipo de Operacao Inclusao,Alteracao,Exclusao,etc  ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Campos(aCampos, lAtivo, nOpc)

Local cFora	:= ""	// Contem os campos que estarao desabilitados na enchoice

// Se o atendimento for ATIVO desabilita a edicao dos campos abaixo
If lAtivo .OR. nOpc <> 3
	cFora := "ACF_CLIENT"
Endif

DbSelectarea("SX3")
DbSetOrder(1)
If MsSeek("ACF")
	While !Eof() .AND. SX3->X3_ARQUIVO == "ACF"
		If X3USO(SX3->X3_USADO) .AND. !(AllTrim(SX3->X3_CAMPO) $ cFora)
			Aadd(aCampos, SX3->X3_CAMPO )
		Endif
		DbSkip()
	End
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Client�Autor �Armando M. Tessaroli� Data �  15/08/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valid do campo ACF_CLIENT que atualiza os titulos a serem   ���
���          �cobrados pelo operador.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Marcelo K.�12/03/04�811   �Correcao da ordem do indice de busca        ���
���Andrea F. �24/04/04�811   �Atualizacao dos dados da ultima ligacao     ���
���          �        �      �(Operacao e Status) exibidos no rodape.     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Client()

Local aArea		:= GetArea()			// Salva a area atual
Local aItens	:= {}					// Titulos que serao cobrados
Local dAntigo	:= CTOD("//")			// Data de vencimento mais antiga
Local lRet		:= .F.					// Retorno da funcao
Local cRegSel   := ""					// Codigo da Regra de Selecao do Operador "dono" do titulo
Local cRegNeg   := ""					// Codigo da Regra de Negociacao do Operador "dono" do titulo
Local cCodOper	:= CRIAVAR("U7_COD",.F.)//Codigo do Operador que sera usado para buscar as regras no Grupo de Atendimento
Local cFilOrig  := ""					// Filial de origem do titulo

#IFDEF TOP
	Local cQuery:= ""					// Expressao de pesquisa no banco de dados
#ENDIF

//����������������������������������������Ŀ
//�Inicializa as variaveis do rodape sempre�
//������������������������������������������
cLigacao := ""
cOperador:= ""
cOperacao:= ""
cStatus  := ""
cProximo := ""
cContHist:= ""
cNomeHist:= ""

//����������������������������������������������������������������������Ŀ
//�O campo ACF_LOJA nao possui inicilizador padrao. Utilizo a loja padrao�
//�existente no parametro caso a mesma nao tenha sido informada.         �
//������������������������������������������������������������������������
If Empty(M->ACF_LOJA)
	M->ACF_LOJA:= GetMv("MV_LOJAPAD")
Endif
	
//���������������������������������������������������������������������������������������������������������������������������������������������Ŀ
//�Se for uma ALTERACAO nao permite a alteracao dos dados do cliente , caso contrario o operador pode apagar todo o historico de um atendimento �
//�����������������������������������������������������������������������������������������������������������������������������������������������
If !INCLUI
	If M->ACF_CLIENT + M->ACF_LOJA <> ACF->ACF_CLIENT + ACF->ACF_LOJA
		Aviso(STR0128,STR0079,{"Ok"}) //"Na altera��o de cobran�a n�o � poss�vel alterar o cliente","Aten��o",{"OK"}) 
		Return(lRet)
	Endif
Endif

//������������������������������������������������������������������������������������������������������������������������������������Ŀ
//�Primeiro: Atualiza o nome do cliente a partir do codigo e da loja (se estiver preenchido)                                           �
//��������������������������������������������������������������������������������������������������������������������������������������
DbSelectarea("SA1")
DbSetorder(1)
If MsSeek(xFilial("SA1") + M->ACF_CLIENT + M->ACF_LOJA,.T.)
 	M->ACF_DESCCLI	:= SA1->A1_NOME
 	cTipo			:= SA1->A1_TIPO
 	If Empty(M->ACF_LOJA)
	 	M->ACF_LOJA	:= SA1->A1_LOJA
	Endif 	
Endif

//��������������������������������������Ŀ
//�Verifica se existe o cliente  na base �
//����������������������������������������
If !ExistCpo("SA1",M->ACF_CLIENTE+M->ACF_LOJA)
	M->ACF_DESCCLI := ""
	Return(lRet)
Endif

	                     
//�����������������������������������������������������������������������Ŀ
//�Atualiza os dados da entidade e do contato que serao exibidos no rodape�
//�������������������������������������������������������������������������
cContHist:=TkDadosContato(M->ACF_CODCON,0)
cNomeHist:=TkEntidade("SA1",M->ACF_CLIENTE+M->ACF_LOJA,1)

//���������������������������������������������������������������������������������Ŀ
//�Segundo: Atualiza o rodape da tela com o ultimo atendimento feito para o cliente �
//�����������������������������������������������������������������������������������
DbSelectarea("ACF")
DbSetorder(3)//ACF_CLIENT+ACF+LOJA+STR(ACF_DIASDA,8,0)+STR(ACF_HORADA,8,0)
If MsSeek(xFilial("ACF") + M->ACF_CLIENT + M->ACF_LOJA)
	cLigacao 	:= DTOC(ACF->ACF_DATA) + " - " + Substr(ACF->ACF_INICIO,1,5)
	cOperador	:= Posicione("SU7",1,xFilial("SU7") + ACF->ACF_OPERAD,"U7_NOME")
    If VAL(ACF->ACF_OPERA) == ATIVO    
	    cOperacao	:= STR0056  
    ElseIf VAL(ACF->ACF_OPERA) == RECEPTIVO
	    cOperacao	:= STR0057  
    Endif    
    
	If VAL(ACF->ACF_STATUS) == PLANEJADA
		cStatus := STR0121 // "Atendimento" 
	ElseIf VAL(ACF->ACF_STATUS) == PENDENTE
		cStatus := STR0122 // "Cobranca"   
	Else
		cStatus := STR0123 // "Encerrado" 
	Endif
    
	DbSelectArea("SU7")
	DbSetORder(1)
	If MsSeek(xFilial("SU7") + ACF->ACF_OPERAD)
		If !Empty(ACF->ACF_PENDEN)
			cProximo := DTOC(ACF->ACF_PENDEN) + " - " + ACF->ACF_HRPEND + " - " + cOperador
		Endif
	Endif
Endif             

oLigacao:Refresh()
oOperador:Refresh()
oStatus:Refresh()
oOperacao:Refresh()
oProximo:Refresh()
oContHist:Refresh()
oNomeHist:Refresh()

//��������������������������������������������������������������������������������������������������Ŀ
//�Limpa os itens de cobranca porque os titulos so podem ser informados depois da escolha do CLIENTE �
//����������������������������������������������������������������������������������������������������
If INCLUI
	aCols := Array(1, Len(aHeader) + 1)
	TkHeader("ACF","ACG_CODIGO",@aCols,aHeader)
	oGetTlc:oBrowse:Refresh(.T.)
Endif

//������������������������������������������������������������Ŀ
//�Pesquisa os Titulos pendentes do cliente para serem cobrados�
//��������������������������������������������������������������
CursorWait()

DbSelectArea("SK1")
DbSetOrder(4)	// K1_FILIAL+K1_CLIENTE+K1_LOJA+DTOS(K1_VENCREA)
#IFDEF TOP
	cQuery	:=	" SELECT K1_PREFIXO, K1_NUM, K1_PARCELA, K1_TIPO, K1_FILIAL, K1_VENCREA, K1_CLIENTE, K1_LOJA, K1_OPERAD " 
				If SK1->(FieldPos("K1_FILORIG"))  > 0
					cQuery+= " ,K1_FILORIG "
				Endif	
	cQuery+=	" FROM " +	RetSqlName("SK1") + " SK1 " +;
				" WHERE	SK1.K1_FILIAL 	= '" + xFilial("SK1") + "' AND" +;
				"		SK1.K1_CLIENTE 	= '" + SA1->A1_COD 	+ "' AND" +;
				"		SK1.K1_LOJA 	= '" + SA1->A1_LOJA + "' AND" +;
				"		SK1.K1_OPERAD <> 'XXXXXX' AND"+;
				"		SK1.D_E_L_E_T_ = ''" +;
				" ORDER BY " + SqlOrder(IndexKey())
	
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TK280SK1.SQL", cQuery)
	DbSelectArea("SK1")
	DbCloseArea()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SK1', .F., .T.)
	
	TcSetField("SK1", "K1_VENCREA", "D")
	
#ELSE
	MsSeek(xFilial("SK1") + SA1->A1_COD + SA1->A1_LOJA)
#ENDIF

While !Eof() 								.AND.;
	  SK1->K1_FILIAL	== xFilial("SK1")	.AND.;
	  SK1->K1_CLIENTE	== SA1->A1_COD		.AND.;
	  SK1->K1_LOJA		== SA1->A1_LOJA
	
	#IFNDEF TOP
		// Nao carrega titulos marcados para a regra de excessao de cobranca
		If SK1->K1_OPERAD == "XXXXXX"
			DbSelectArea("SK1")
			DbSkip()
			Loop
		Endif
	#ENDIF
	
	If (SK1->(FieldPos("K1_FILORIG"))  > 0)
		cFilOrig:=	SK1->K1_FILORIG
	Else
		cFilOrig:=	xFilial("SE1")
	Endif
	AAdd(aItens, {	SK1->K1_PREFIXO	,;
					SK1->K1_NUM		,;
					SK1->K1_PARCELA	,;
					SK1->K1_TIPO	,;
					cFilOrig})
    
	//���������������������������������������Ŀ
	//�Atualiza a data de cobranca mais antiga�
	//�����������������������������������������
	If Empty(dAntigo) .OR. dAntigo > SK1->K1_VENCREA
		dAntigo := SK1->K1_VENCREA
	Endif
	
	//�����������������������������������������������������������������������Ŀ
	//�Se esses titulosja tem um operador "dono" da conta do titulo           �
	//�o sistema mantem esse operador como responsavel pelo atendimento atual �
	//�O operador do titulo mais antigo                                       �
	//�������������������������������������������������������������������������
	If !Empty(SK1->K1_OPERAD) .AND. Empty(cCodOper)
		cCodOper := SK1->K1_OPERAD
	Endif
	
	DbSelectArea("SK1")
	DbSkip()
End

//�������������������������������������������������������������������������������������������������Ŀ
//�Se os titulos nao tem um "dono" o Operador logado assume os titulos e usa as regras do seu Grupo �
//���������������������������������������������������������������������������������������������������
If Empty(cCodOper)
	cCodOper := M->ACF_OPERAD
Endif

//����������������������������������������������������������������������Ŀ
//�busca as regras do operador "dono" dos titulos no Grupo de atendimento�
//������������������������������������������������������������������������
DbSelectArea("SU7")
DbSetorder(1)
If MsSeek(xFilial("SU7") + cCodOper)
	
	M->ACF_OPERAD	:= SU7->U7_COD
	M->ACF_DESCOP	:= SU7->U7_NOME

	DbSelectArea("SU0")
	DbSetOrder(1)
	If MsSeek(xFilial("SU0") + SU7->U7_POSTO)
		cRegSel := SU0->U0_REGSEL
		cRegNeg := SU0->U0_REGNEG
		
		DbSelectArea("SK0")
		DbSetOrder(2)
		MsSeek(xFilial("SK0"))
		While !Eof() .AND. SK0->K0_FILIAL == xFilial("SK0")
			dAntigo := dAntigo + Val(SK0->K0_PRAZO)
			If SK0->K0_REGSEL == cRegSel
				Exit
			Endif
			DbSkip()
		End
		
		M->ACF_OPERA	:= "1"
		M->ACF_PENDEN	:= dDataBase
		M->ACF_HRPEND	:= Time()
		M->ACF_PRAZO	:= dAntigo
		
		DbSelectArea("SK2")
		DbSetOrder(1)
		If MsSeek(xFilial("SK2") + cRegNeg)
			// Verifica se a selecao sera automatica
			If SK2->K2_SELTIT <> "2"		// Selecao manual
				Tk274Itens(aItens)
			Endif
		Endif
	Endif	
Else
	Aviso(STR0128,STR0129,{"OK"})//"Aten�ao","O operador n�o foi localizado para realizar o atendimento",{"OK"})	
	Return(lRet)
Endif
	
oGetTlc:oBrowse:Refresh(.T.)

#IFDEF TOP
	DbSelectArea("SK1")
	DbCloseArea()
	ChkFile("SK1")
#ENDIF

CursorArrow()
//���������������������������������������������������������������Ŀ
//�Atualiza o status da tabela de atendentes IN/OUT para o Monitor�
//�����������������������������������������������������������������
TkGrvSUV(__cUserId,"TLC1")

//�������������������������������������������Ŀ
//�Ativa o cronometro da tela 10 - 10 Segundos�
//���������������������������������������������
cTimeIni := Time()
oTimerCro:Activate()
	
RestArea(aArea)
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Penden�Autor �Armando M. Tessaroli� Data �  05/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao da data de reagendamento do atendimento.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������ĺ��
���Andrea F. �29/09/04�811   �- Adaptado rotina para ser utilizada na     ���
���          �        �      �validacao contida no campo ACF_PENDEN e na  ���
���          �        �      �rotina de reagendamento existente no pre-   ���
���          �        �      �atendimento.                                ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Penden(dData,cOperador)

Local lRet			:= .F.                 	// Retorno da Funcao
Local aArea			:= GetArea()           	// Guarda a area atual
Local cRegNeg   	:= ""					// Codigo da Regra de Negociacao
Default dData		:= M->ACF_PENDEN		// Assume a data do campo M->ACF_PENDEN quando nao for passada como parametro
Default cOperador	:= ""                  	// Codigo do Operador que ira executar o reagendamento

//��������������������������������������������������������������������������Ŀ
//�Se a funcao foi chamada pelo  Valid do campo ACF_PENDEN, nao foi passado  �
//�como parametro o codigo do operador, por isso valido o seu preenchimento. �
//����������������������������������������������������������������������������
If Empty(cOperador)
	cOperador:= M->ACF_OPERAD
Endif
	
cRegNeg:= TkPosto(cOperador,"U0_REGNEG")

DbSelectArea("SK2")
DbSetOrder(1)
If MsSeek(xFilial("SK2") + cRegNeg)
    //Data do reagendamento deve ser superior a database 
	If dData < dDataBase
		lRet := .F.
	ElseIf dData <= dDataBase + SK2->K2_DIAREAG
		lRet := .T.
	Endif
Endif

RestArea(aArea)

If !lRet
	Help(" ",1,"TKNPERMITE")
Endif

Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274DescFi�Autor �Armando M. Tessaroli� Data �  08/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao do desconto financeiro concedido na cobranca.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �24/04/04�811   �- Utilizacao do campo ACG_VALREF (Valor a   ���
���          �        �      �Receber sem encargos) para calculo do       ���
���          �        �      �desconto financeiro.                        ���
���          �        �      �- Controlar a alteracao do campo Desconto   ���
���          �        �      �de acordo com o conteudo do campo ACG_BAIXA ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274DescFi()

Local aArea		:= GetArea()
Local lRet		:= .F.
Local cRegNeg   := TkPosto(M->ACF_OPERAD,"U0_REGNEG") 	// Codigo da Regra de Negociacao
Local nPRecebe	:= aPosicoes[11][2]						// Valor a Receber do Titulo
Local nPJuros	:= aPosicoes[12][2]						// Valor dos Juros
Local nPDescFi	:= aPosicoes[13][2]						// Percentual do Desconto Financeiro
Local nPPromoc	:= aPosicoes[16][2]						// Promocao
Local nPValRef	:= aPosicoes[28][2]						// Valor de Referencia
Local nPBaixa 	:= aPosicoes[29][2]						// Log de Baixa        
Local nDescFi	:= &(ReadVar())    						// Percentual de desconto concedido
Local nDesc		:= 0			   						// Valor maximo de desconto permitido

//���������������������������������������������������������������������Ŀ
//�Avalia se houve baixa parcial para o titulo. Quando ha uma baixa     �
//�parcial para o titulo, o valor de desconto  nao podera ser alterado, �
//�deve ser informado no momento da baixa do titulo no Financeiro.      �
//�����������������������������������������������������������������������
If Acols[n][nPBaixa] == "2" //Sem Baixa

	DbSelectArea("SK3")
	DbSetOrder(1)
	If MsSeek(xFilial("SK3") + aCols[n][nPPromoc])
		nDesc := nDesc + aCols[n][nPValRef] * SK3->K3_DSCNOM / 100
		nDesc := nDesc + aCols[n][nPJuros] * SK3->K3_DSCJUR / 100
		If (aCols[n][nPValRef] * nDescFi / 100) <= nDesc
			lRet := .T.
		Endif
	Else
		DbSelectArea("SK2")
		DbSetOrder(1)
		If MsSeek(xFilial("SK2") + cRegNeg)
			nDesc := nDesc + aCols[n][nPValRef] * SK2->K2_DSCNOM / 100
			nDesc := nDesc + aCols[n][nPJuros] * SK2->K2_DSCJUR / 100
			If (aCols[n][nPValRef] * nDescFi / 100) <= nDesc
				lRet := .T.
			Endif
		Endif
	Endif
	
	If !lRet
		Help(" ",1,"TKNPERMITE")
	Else 
	    //Desconto Financeiro 
		aRdpTlc[06][02] := aRdpTlc[06][2] - (aCols[n][nPDescFi] * aCols[n][nPValRef] / 100) 
		aRdpTlc[06][02] := aRdpTlc[06][2] + (nDescFi * aCols[n][nPValRef] / 100)
		
		//Valor a ser Recebido na moeda do titulo
		aRdpTlc[11][02] := aRdpTlc[11][2] + (aCols[n][nPDescFi] * aCols[n][nPRecebe] / 100)
		aRdpTlc[11][02] := aRdpTlc[11][2] - (nDescFi * aCols[n][nPRecebe] / 100)
		
		//Valor a ser Recebido na moeda do corrente
		aRdpTlc[12][02] := aRdpTlc[12][2] + (aCols[n][nPDescFi] * aCols[n][nPRecebe] / 100)
		aRdpTlc[12][02] := aRdpTlc[12][2] - (nDescFi * aCols[n][nPRecebe] / 100)
		
		aRdpTlc[06][01]:Refresh()
		aRdpTlc[11][01]:Refresh()
		aRdpTlc[12][01]:Refresh()
	Endif
	
Else	// Sem Baixa
	Help(" ",1,"TK274DESCF")	
Endif	
    
RestArea(aArea)
Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274LiDesc�Autor �Armando M. Tessaroli� Data �  08/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao da data de vencimento do desconto financeiro conce���
���          �dido na negocia��o da cobranca.                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �24/04/04�811   �- Validar a alteracao do campo DATA         ���
���          �        �      �quando for necessario limpar o seu conteudo.���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274LiDesc()

Local lRet		:= .F.                     	// Retorno da Funcao
Local aArea		:= GetArea()				// Guarda a area atual
Local nPDescFi	:= aPosicoes[13][2]			// Percentual do Desconto Financeiro
Local dLiDesc	:= &(ReadVar())            // Data Limite digitada na GetDados
Local nPPromoc	:= Ascan(aHeader, {|x| x[2] == "ACG_PROMOC"} )	// Codigo da Promocao
Local cRegNeg   := TkPosto(M->ACF_OPERAD,"U0_REGNEG") 	// Codigo da Regra de Negociacao

//�����������������������������������������������Ŀ
//�Valida se pode apagar o conteudo da Data Limite�
//�������������������������������������������������
If Empty(dLiDesc) .AND. aCols[n][nPDescFi] == 0
	lRet := .T.
Endif

DbSelectArea("SK3")
DbSetOrder(1)
If MsSeek(xFilial("SK3") + aCols[n][nPPromoc])
	If dLiDesc <= dDataBase + SK3->K3_DIADESC
		lRet := .T.
	Endif
Else
	DbSelectArea("SK2")
	DbSetOrder(1)
	If MsSeek(xFilial("SK2") + cRegNeg)
		If dLiDesc >= dDataBase .AND. dLiDesc <= dDataBase + SK2->K2_DIADESC
			lRet := .T.
		Endif
	Endif
Endif

RestArea(aArea)

If !lRet
	Help(" ",1,"TKNPERMITE")
Endif

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274SelTit�Autor �Armando M. Tessaroli� Data �  22/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que informa se o Operador pode selecionar os titulos ���
���          �ou os titulos serao carregados automaticamente.             ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274SelTit()

Local aArea	:= GetArea()

DbSelectArea("SU7")
DbSetOrder(1)
MsSeek(xFilial("SU7") + M->ACF_OPERAD)

DbSelectArea("SU0")
DbSetOrder(1)
MsSeek(xFilial("SU0") + SU7->U7_POSTO)

DbSelectArea("SK2")
DbSetOrder(1)
MsSeek(xFilial("SK2") + SU0->U0_REGNEG)

RestArea(aArea)

// Verifica se a selecao sera manual
If SK2->K2_SELTIT == "2"		// Selecao manual
	Return(.T.)
Endif

Return(.F.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Status�Autor �Armando M. Tessaroli� Data �  22/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para validar se o valor informado para este campo es-���
���          �ta correto.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �27/04/04�811   �- Nao permitir alterar o Status quando      ���
���          �        �      �estiver preenchido com 1- Pago.             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Status()

Local aArea		:= GetArea()
Local nPTitulo	:= aPosicoes[1][2]		// Numero do Titulo
Local nPPrefix	:= aPosicoes[2][2]		// Prefixo do Titulo
Local nPParcel	:= aPosicoes[3][2]		// Parcela do Titulo
Local nPTipo	:= aPosicoes[4][2]    	// Tipo do Titulo
Local lRet		:= .F.                 	// Retorno da Funcao
Local lPago		:= .F.                	// Controle de Titulo Pago
Local nPFilOrig	:= 0

If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
	If nPFilOrig > 0
		cFilOrig:= aCols[n][nPFilOrig]
	Else
		cFilOrig:= xFilial("SE1")
	Endif
Else
	cFilOrig:= xFilial("SE1")
Endif					

//������������������������������������������������������������������Ŀ
//�Verifico se o titulo esta totalmente baixado. Caso esteja, o      �
//�status do titulo nao podera ser alterado.                         �
//��������������������������������������������������������������������

DbSelectArea("SE1")
DbSetOrder(1)
If MsSeek(cFilOrig + aCols[n][nPPrefix] + aCols[n][nPTitulo] + aCols[n][nPParcel] + aCols[n][nPTipo])
	If SE1->E1_SALDO == 0
		lPago:=	.T.
	Endif
Endif

Do Case
	Case M->ACG_STATUS == "1" .AND. lPago	// Pago     
		lRet := .T.
	Case M->ACG_STATUS == "2" .AND. !lPago	// Negociado
		lRet := .T.
	Case M->ACG_STATUS == "3" .AND. !lPago	// Cartorio
		lRet := .T.
	Case M->ACG_STATUS == "4"             	// Baixa      
		lRet := .F.
	Case M->ACG_STATUS == "5"             	// Abatimento
		If aCols[n][nPTipo] $ MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM
			lRet := .T.
		Endif
Endcase
	
RestArea(aArea)

Return(lRet)
                                        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Tools�Autor  �Armando M. Tessaroli� Data �  25/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para selecao dos Titulos apresentados no browser para���
���          �serem cobrados.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk274Tools(nTipo, oTitulos, lCheck)

Local nI	:= 0		// Variavel de Controle

If nTipo == 1
	If lCheck
		For nI := 1 To Len(oTitulos:aArray)
			oTitulos:aArray[nI][1] := .T.
			oTitulos:Refresh()
		Next nI
	Else
		For nI := 1 To Len(oTitulos:aArray)
			oTitulos:aArray[nI][1] := .F.
			oTitulos:Refresh()
		Next nI
	Endif
Else
	For nI := 1 To Len(oTitulos:aArray)
		If oTitulos:aArray[nI][1]
			oTitulos:aArray[nI][1] := .F.
		Else
			oTitulos:aArray[nI][1] := .T.
		Endif
		oTitulos:Refresh()
	Next nI
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Acresc�Autor �Andrea Farias       � Data �  03/11/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de validacao do campo ACG_ACRESC (Valor Acrescimo)   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �TELECOBRANCA                                                ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �24/04/04�811   �- Utilizacao do campo ACG_VALREF (Valor a   ���
���          �        �      �Receber sem encargos) para calculo do       ���
���          �        �      �acrescimo.                                  ���
���          �        �      �- Validar  a alteracao do campo Acrescimo   ���
���          �        �      �de acordo com o conteudo do campo ACG_BAIXA ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Acresc()

Local nValor	 := &(ReadVar())                       	// Valor do acrescimo ($)digitado pelo usuario na Getdados
Local lRet		 := .F.                                	// Retorno da funcao
Local nPRecebe	 := aPosicoes[11][2]					// Valor a Receber 
Local nPJuros	 := aPosicoes[12][2]					// Total dos Juros aplicado ao titulo
Local nPDescFi	 := aPosicoes[13][2]					// Desconto Financeiro
Local nPDecres	 := aPosicoes[15][2]					// Descrescimo
Local nPValRef	 := aPosicoes[28][2]                   // Valor de Referencia
Local nPBaixa 	 := aPosicoes[29][2]                   // Log de Baixa         
Local cRegNeg    := TkPosto(M->ACF_OPERAD,"U0_REGNEG") // Codigo da Regra de Negocio
Local nMaxAcre	 := 0 									// Valor maximo do acrescimo da regra de negocicao
Local nValPerc   := 0									// Valor informado no campo acrescimo convertido em %
Local nValReceber:= 0                                   // Valor a Receber recalculado
Local nValDescFin:= 0									// Valor do Desconto Financeiro

//���������������������������������������������������������������������Ŀ
//�Avalia se houve baixa parcial para o titulo. Quando ha uma baixa     �
//�parcial para o titulo, o valor de acrescimo nao podera ser alterado, �
//�deve ser informado no momento da baixa do titulo no Financeiro.      �
//�����������������������������������������������������������������������
If Acols[n][nPBaixa] == "2"  //Sem Baixa

	//����������������������������������������������������������������������������������������������Ŀ
	//�Avalia se o valor de ACRESCIMO pode ser aplicado de acordo com a regra de negociacao definida �
	//������������������������������������������������������������������������������������������������
	DbSelectarea("SK2")
	DbSetOrder(1)
	If MsSeek(xFilial("SK2") + cRegNeg)
		If SK2->K2_ALTTIT == "1"	// SIM - Pode alterar Titulo
	
			//��������������������������������������Ŀ
			//�Calcula o valor do desconto financeiro�
			//����������������������������������������
		    nValDescFin	:=  (Acols[n][nPValRef] * Acols[n][nPDescFi]) / 100 
	
			nMaxAcre:= SK2->K2_ACRESC
			nValReceber:=Acols[n][nPValRef]
	
			//�������������������������������������������������������������������������������������Ŀ
			//�O valor digitado foi em R$ e sera calculado em % para avaliar se esta dentro da Regra�
			//���������������������������������������������������������������������������������������
			nValPerc:= NoRound( (100 * nValor) / nValReceber,2)
			If nValPerc > nMaxAcre
				lRet := .F.
	        Else
	        	lRet := .T. 
				//��������������������������������������������������������������������������������������Ŀ
				//�Se o valor informado esta dentro do limite (em %) aplica esse valor no Total a Receber�
				//����������������������������������������������������������������������������������������
	        	//Valor a Receber = Valor de Referencia do Titulo + Juros + Acrescimo - Descrescimo - Desconto Financeiro
	        	Acols[n][nPRecebe]:= Acols[n][nPValRef]+ Acols[n][nPJuros]+ nValor - Acols[n][nPDecres] - nValDescFin
			Endif
		Endif
	Endif

	If !lRet
		Help(" ",1,"TKNPERMITE")
	Endif

Else	// Sem Baixa
	Help(" ",1,"TK274ACRES")	
Endif
	
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Decres�Autor �Andrea Farias       � Data �  03/11/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de validacao do campo ACG_DECRES                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������͹��
���Andrea F. �24/04/04�811   �- Utilizacao do campo ACG_VALREF (Valor a   ���
���          �        �      �Receber sem encargos) para calculo do       ���
���          �        �      �decrescimo.                                 ���
���          �        �      �- Validar  a alteracao do campo Decrescimo  ���
���          �        �      �de acordo com o conteudo do campo ACG_BAIXA ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Decres()

Local nValor	 := &(ReadVar())                  	 	// Valor do decrescimo ($)digitado pelo usuario na Getdados
Local lRet		 := .F.                             	// Retorno da funcao
Local nPRecebe	 := aPosicoes[11][2]					// Valor a Receber 
Local nPJuros	 := aPosicoes[12][2]					// Total dos Juros aplicado ao titulo
Local nPDescFi	 := aPosicoes[13][2]					// Desconto Financeiro
Local nPAcresc	 := aPosicoes[14][2]					// Acrescimo  
Local nPValRef	 := aPosicoes[28][2]                   // Valor de Referencia
Local nPBaixa    := aPosicoes[29][2]                   // Log de  Baixa       
Local cRegNeg    := TkPosto(M->ACF_OPERAD,"U0_REGNEG") // Codigo da Regra de Negociacao
Local nMaxDecr	 := 0 									// Valor maximo do descrescimo na regra de negocicao
Local nValPerc   := 0									// Valor informado no campo descrescimo convertido em %
Local nValReceber:= 0                                   // Valor a Receber recalculado
Local nValDescFin:= 0									// Valor do Desconto Financeiro

//���������������������������������������������������������������������Ŀ
//�Avalia se houve baixa parcial para o titulo. Quando ha uma baixa     �
//�parcial para o titulo, o valor de decrescimo nao podera ser alterado,�
//�deve ser informado no momento da baixa do titulo no Financeiro.      �
//�����������������������������������������������������������������������
If Acols[n][nPBaixa] == "2" //Sem Baixa

	//�����������������������������������������������������������������������������������������������Ŀ
	//�Avalia se o valor de DECRESCIMO pode ser aplicado de acordo com a regra de negociacao definida �
	//�������������������������������������������������������������������������������������������������
	DbSelectarea("SK2")
	DbSetOrder(1)                                                                
	If MsSeek(xFilial("SK2") + cRegNeg)
		If SK2->K2_ALTTIT == "1"	// SIM - Pode alterar Titulo
	
			//��������������������������������������Ŀ
			//�Calcula o valor do desconto financeiro�
			//����������������������������������������
		    nValDescFin	:=  (Acols[n][nPValRef] * Acols[n][nPDescFi]) / 100 
	
			nMaxDecr:= SK2->K2_DECRES
			nValReceber:=Acols[n][nPValRef]
	
			//�������������������������������������������������������������������������������������Ŀ
			//�O valor digitado foi em R$ e sera calculado em % para avaliar se esta dentro da Regra�
			//���������������������������������������������������������������������������������������
			nValPerc:= NoRound( (100 * nValor) / nValReceber,2)
			If nValPerc > nMaxDecr
				lRet := .F.
	        Else
	        	lRet := .T. 
	
				//��������������������������������������������������������������������������������������Ŀ
				//�Se o valor informado esta dentro do limite (em %) aplica esse valor no Total a Receber�
				//����������������������������������������������������������������������������������������
	        	//Valor a Receber = Valor de referencia do Titulo + Juros + Acrescimo - Descrescimo - Desconto Financeiro
	        	Acols[n][nPRecebe]:= Acols[n][nPValRef]+ Acols[n][nPJuros]+  Acols[n][nPAcresc] - nValor - nValDescFin
			Endif
		Endif
	Endif

	If !lRet
		Help(" ",1,"TKNPERMITE")
	Endif

Else	//Sem Baixa
	Help(" ",1,"TK274DECRE")	
Endif
	

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Atend�Autor  �Armando M. Tessaroli� Data �  26/11/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza os dados da tela de atendimento de Telecobranca.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͺ��
���Andrea F. �24/04/04�811   �Atualizacao dos dados da ultima ligacao     ���
���          �        �      �(Operacao e Status) exibidos no rodape.     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Atend(cEtapa,		aTLC,	aCampACF,	nOpc)

Local aArea		:= GetArea()			// Salva a area anterior
Local dAntigo	:= CTOD("//")			// Data de vencimento mais antiga
Local dLimite	:= dDataBase			// Data limite do prazo de cobranca
Local nPDtReal	:= Ascan(aHeader, {|x| x[2] == "ACG_DTREAL"} )
Local nI		:= 0 
Local cRegSel	:= ""
Local nPrazo	:= 0

// Carrega os campos que ficarao habilitados na enchoice
If Len(aTLC) > 0
	
	Do Case
		Case cEtapa == "01"

			//�����������������������������Ŀ
			//�Carrega os campos necessarios�
			//�������������������������������
			M->ACF_OPERAD	:= SU7->U7_COD
			M->ACF_DESCOP	:= SU7->U7_NOME
			M->ACF_OPERA	:= "2"
			M->ACF_PENDEN	:= dDataBase
			M->ACF_HRPEND	:= Time()                          

			//�����������������������������������������������������������������������������������Ŀ
			//�Quando o preenchimento e feito atraves de uma solicitacao de novo pre-atendimento  �
			//�o atendimento ainda nao foi gravado, portanto a funcao MSMM nao pode ser executada.�
			//�porque ainda nao existem observacao.                                               �
			//�������������������������������������������������������������������������������������
			DbSelectarea("ACF")
			DbSetorder(1)
			If MsSeek(xFilial("ACF") + M->ACF_CODIGO)
				M->ACF_OBS	:= MSMM(ACF->ACF_CODOBS,TamSx3("ACF_OBS")[1])
			Endif
			
			// Se entrou aqui o atendimento sera ATIVO
			Tk274Campos(@aCampACF, .T., nOpc)		// Desabilita os campos se for ATIVO, Pre-atendimento
			
		Case cEtapa == "02"
			//�����������������������������������������������������������������������������������������Ŀ
			//�Carrega os itens da tela de atendimento no caso de ser ATIVO e monta os valores do rodape�
			//�������������������������������������������������������������������������������������������
			Tk274Itens(aTLC)
			
		Case cEtapa == "03"
			//����������������������������������������Ŀ
			//�Inicializa as variaveis do rodape sempre�
			//������������������������������������������
			cLigacao := ""
			cOperador:= ""
			cOperacao:= ""
			cStatus  := ""
			cProximo := ""
			
			//���������������������������������������������������������������������������������Ŀ
			//�Segundo: Atualiza o rodape da tela com o ultimo atendimento feito para o cliente �
			//�����������������������������������������������������������������������������������
			DbSelectarea("ACF")
			DbSetorder(2)
			If MsSeek(xFilial("ACF") + M->ACF_CLIENT + M->ACF_LOJA)
				cLigacao := DTOC(ACF->ACF_DATA) + " - " + Substr(ACF->ACF_INICIO,1,5)
				cOperador:= Posicione("SU7",1,xFilial("SU7") + ACF->ACF_OPERAD,"U7_NOME")
			    If VAL(ACF->ACF_OPERA) == ATIVO    
				    cOperacao	:= STR0056  
			    ElseIf VAL(ACF->ACF_OPERA) == RECEPTIVO
				    cOperacao	:= STR0057  
			    Endif    

				If VAL(ACF->ACF_STATUS) == PLANEJADA
					cStatus := STR0121 // "Atendimento" 
				ElseIf VAL(ACF->ACF_STATUS) == PENDENTE
					cStatus := STR0122 // "Cobranca"   
				Else
					cStatus := STR0123 // "Encerrado" 
				Endif
			
				DbSelectArea("SU7")
				DbSetORder(1)
				If MsSeek(xFilial("SU7") + ACF->ACF_OPERAD)
					If !Empty(ACF->ACF_PENDEN)
						cProximo:= DTOC(ACF->ACF_PENDEN) + " - " + ACF->ACF_HRPEND + " - " + cOperador
					Endif
				Endif
			Endif
			
			//�������������������������������������������Ŀ
			//�Ativa o cronometro da tela 10 - 10 Segundos�
			//���������������������������������������������
			cTimeIni := Time()
			oTimerCro:Activate()
			
			oLigacao:Refresh()
			oOperador:Refresh()
			oStatus:Refresh()
			oOperacao:Refresh()
			oProximo:Refresh()
	Endcase
Endif

// Se estiver com o folder de telecobran�a ativo.
If Len(aCols) > 0 .AND. nPDtReal > 0

	//�������������������������������������������������������������������������������Ŀ
	//�Verifica a data limite para realizar a cobranca e carrega os campos necessarios�
	//���������������������������������������������������������������������������������
	DbSelectArea("SU0")
	DbSetOrder(1)
	If MsSeek(xFilial("SU0") + SU7->U7_POSTO)
		cRegSel := SU0->U0_REGSEL
		DbSelectArea("SK0")
		DbSetOrder(2)
		MsSeek(xFilial("SK0"))
		While !Eof() .AND. SK0->K0_FILIAL == xFilial("SK0")
			nPrazo += Val(SK0->K0_PRAZO)
			If SK0->K0_REGSEL == cRegSel
				Exit
			Endif
			DbSkip()
		End
	Endif
	
	For nI := 1 To Len(aCols)
		If Empty(dAntigo) .OR. dAntigo > aCols[nI][nPDtReal]
			dAntigo := aCols[nI][nPDtReal]
		Endif
	Next nI
	M->ACF_PRAZO	:= dAntigo + nPrazo		// A data do titulo mais antiga + o numero de dias que um titulo sai do prazo
Endif

RestArea(aArea)
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Atraso�Autor �Armando M. Tessaroli� Data �  26/11/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de calculo dos dias de atraso do titulo que alimenta ���
���          �o inicializador padrao do campo ACG_ATRASO.                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Atraso()

Local nDias := 0

If !Empty(ACG->ACG_DTREAL)
	nDias := dDataBase - ACG->ACG_DTREAL
Endif

Return(nDias)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Encerra�Autor�Armando M. Tessaroli� Data �  22/01/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta rotina captura o motivo do encerramento e permite in-  ���
���          �formar uma observacao em campo memo.                        ���
�������������������������������������������������������������������������͹��
���Uso       �TELECOBRANCA                                                ���
�������������������������������������������������������������������������͹��
���Andrea F. �23/08/04�811   �- Revisao do Fonte e mudanca da funcao de   ���
���          �        �      �Static para Function.                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274Encerra(lConsulta,cNumTlc,cEncerra,cMotivo)

Local oEncerra											// Listbox com as opcoes de Encerramento
Local cDesc     := CriaVar("UN_DESC",.F.)				// Descricao da opcao de Encerramento
Local oDlg								   				// Tela do Encerramento
Local oMonoAs	:= TFont():New( "Courier New", 6, 0 )	// Fonte do MEMO
Local oMotivo											// MEMO com o motivo 	
Local lHabil	:= .F.									// Habilita os objetos
Local lRet		:= .F.									// Retorno da funcao
Local cCodEnc 	:= CriaVar("UN_ENCERR",.F.)				// Codigo do encerramento

lHabil := IIF(lConsulta,.F.,.T.)

cMotivo := ""
If lConsulta
	DbSelectarea("ACF") 
	DbSetorder(1)
	If DbSeek(xFilial("ACF") + cNumTlc)
		If !Empty(ACF->ACF_CODENC) .OR. !Empty(ACF->ACF_CODMOT)
			cCodEnc := ACF->ACF_CODENC
			cDesc   := Posicione("SUN",1,xFilial("SUN") + ACF->ACF_CODENC,"UN_DESC")
			cMotivo := MSMM(ACF->ACF_CODMOT,TamSx3("ACF_OBSMOT")[1])
		Else
			HELP(" ",1,"NAO ENCERR")
			Return(lRet)
		Endif
	Endif
Endif

DEFINE MSDIALOG oDlg FROM 05,10 TO 262,400 TITLE STR0125 PIXEL //"Status de Encerramento"

	@  2,4 TO 23,190 LABEL STR0119 OF oDlg PIXEL //"Motivo do Encerramento"

	@ 10,07 SAY STR0126 SIZE 50,8 OF oDlg PIXEL //"Encerramento"
	@ 09,45 MSGET oEncerra VAR cCodEnc SIZE  40,8  Picture "@!" OF oDlg PIXEL F3 "SUN001" ;
		VALID Tk274ValSUN(cCodEnc,cDesc) WHEN lHabil
		oEncerra:cSX1Hlp := "UN_ENCERR"			
	
	@ 10,90 SAY cDesc SIZE 100,8 OF oDlg PIXEL
	
	@ 26,4 TO 111,190 LABEL STR0127 OF oDlg PIXEL //"Descri��o do Encerramento"
	If lConsulta
		@ 35,8 GET oMotivo VAR cMotivo OF oDlg MEMO SIZE 180,70 PIXEL When lHabil READONLY
	Else
		@ 35,8 GET oMotivo VAR cMotivo OF oDlg MEMO SIZE 180,70 PIXEL When lHabil
	Endif
	oMotivo:oFont := oMonoAs
	
	DEFINE SBUTTON FROM 115,160 TYPE 1 ACTION (lRet:=.T., oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

cEncerra:= cCodEnc
oMonoas:End()

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274ValSUN �Autor  �Marcelo Kotaki      � Data �  16/03/04 ���
�������������������������������������������������������������������������͹��
���Descricao �Valida o codigo do encerramento informado de acordo com o   ���
���          �codigo e o tipo de atendimento:                             ���
���          �1- Telemarketing, 3 - Telecobranca, 4 - Ambos               ���
�������������������������������������������������������������������������͹��
���Uso       �TELECOBRANCA                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk274ValSUN(cCodEnc,cDesc)

Local lRet := .F.       	// Retorno da funcao
Local aArea:= GetArea()		// Salva a area atual

cDesc := ""
DbSelectarea("SUN")
DbSetorder(1)                                                       	
If DbSeek(xFilial("SUN")+cCodEnc)
	If (SUN->UN_TIPOATE $ "3;4; ")		// Telecobranca e Ambos
		cDesc 	:= SUN->UN_DESC
		lRet 	:= .T.
	Else
		Help(" ",1,"TMK274ENCE" ) //"Esse c�digo de encerramento nao � usado para a rotina de TeleCobranca"
		lRet 	:= .F.
	Endif		
Else
	Help(" ",1,"TMK274ENCE" ) //"Esse c�digo de encerramento nao � usado para a rotina de TeleCobranca"
	lRet := .F.	
Endif

RestArea(aArea)
Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK274DelSU4�Autor �Microsiga           � Data �  01/22/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Encerra as listas de pendencias se existir alguma           ���
���          �SOMENTE PARA ESSE ATENDIMENTO ENCERRADO                     ���
�������������������������������������������������������������������������͹��
���Uso       �Telecobranca                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TK274DelSU4(cCodLig)
Local aArea := GetArea()		//Salva a area atual

DbSelectArea("SU4")
DbSetOrder(4)		// U4_FILIAL+U4_CODLIG
If DbSeek(xFilial("SU4")+cCodLig)
	RecLock("SU4",.F.)	
	Replace SU4->U4_STATUS With "2"			// Lista Encerrada
	MsUnlock()
	DbCommit()
	
	DbSelectArea("SU6")
	DbSetOrder(1)
	If DbSeek(xFilial("SU6")+SU4->U4_LISTA)
		RecLock("SU6",.F.)
		Replace SU6->U6_STATUS With	"3"		// Item da Lista enviado (executado)
		MsUnlock()
		DbCommit()
	Endif
Endif

RestArea(aArea)

Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274Simul�Autor  �Andrea Farias       � Data �  05/10/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela para simular o valor corrigido do titulo com base em   ���
���          �uma data de pagamento.                                      ���
�������������������������������������������������������������������������͹��
���Parametros�cCliente	- Codigo do cliente                               ���
���          �cLoja   	- Loja do Cliente                                 ���
���          �cOperador	- Codigo do OPerador.                             ���
���          �dPrazoCobr- Data com o Prazo de Cobranca                    ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - COBRANCA	                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Function Tk274Simul(cCliente,cLoja,cOperador,dPrazoCobr)

Local aArea		:= GetArea()						// Salva a area atual	
Local lRet		:= .T.								// Retorno da funcao
Local aButtons	:= {}                              	// Botoes da Enchoicebar
Local aHeadACG	:= {}								// aHeader do ACG
Local aColsACG	:= {}   							// aCols do ACG    
Local aRdpCgd	:= aClone(aRdpTLC)					// Valores Corrigidos do Rodape
Local nUsado	:= 0                               	// Numero de campos existentes no aHeader
Local nCont		:= 0								// Contador
Local nI		:= 0								// Contador
Local dDataPagto:= dDatabase						// Data de Pagamento onde sera baseado o calculo do valor corrigido
Local lAtuAtend	:= .F.								// Atualiza o atendimento com os dados alterados
Local lAltTit	:= .F.				                // Flag para indicar se pode alterar o titulo
Local nDiasPrg	:= 0                              	// Numero maximo de dias para prorrogacao do titulo
Local cRegNeg	:= ""								// Regra de negociacao do Operador 
Local cNome		:= ""								// Nome do Cliente 

//Objetos
Local oDlgSimul                        				// Tela
Local oGetACG										// NewGetDados do ACG
Local oDataPagto									// Data de Pagamento
Local oPrazoCobr                                   	// Prazo de Cobranca
Local oDiasPrg                                     	// Numero maximo de dias para prorrogacao do titulo
Local oAtuAtend                                  	// Atualizacao  do atendimento
Local oFontRdp										// Fonte utilizada no rodape
Local oFontLeg										// Fonte utilizada no rodape
Local oFontTex										// Fonte utilizada no rodape

DEFAULT cCliente	:= M->ACF_CLIENTE      			// Codigo do Cliente
DEFAULT cLoja		:= M->ACF_LOJA	           		// Loja do Cliente
DEFAULT cOperador 	:= M->ACF_OPERAD				// Codigo do operador para coberanca. 
DEFAULT dPrazoCobr	:= M->ACF_PRAZO					// Prazo para Cobranca que o operador possui para cobrar os titulos

DEFINE FONT oFontRdp NAME "Arial" SIZE 12,14 BOLD	// Rodape
DEFINE FONT oFontLeg NAME "Arial" SIZE 00,14 BOLD   // Textos
DEFINE FONT oFontTex NAME "Arial" SIZE 00,14        // Legendas (Titulos)
                                  
If Empty(cCliente).AND. Empty(cLoja)
	MsgStop(STR0154)//"Nenhum cliente foi informado para execu��o da rotina."
	lRet:= .F.
	Return(lRet)
Endif		

//����������������������������Ŀ
//�Carrega o aHeader do ACG	   �
//������������������������������
DbSelectArea("SX3")
DbSetOrder(1)
MsSeek("ACG") 
Aadd(aHeadACG,{"","CHECKBOL","@BMP",20,00,,,"C",,"V" } )
nUsado++

While	!Eof() 	.AND. SX3->X3_ARQUIVO == "ACG"
		
	If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL  
		Aadd(aHeadACG,{  	TRIM(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
		nUsado++
	Endif
	DbSelectArea("SX3")
	DbSkip()
End

//�������������������������������������������������������������������������������������Ŀ
//�Inicializa o ACOLS(ACG) baseado nos Itens carregados no Atendimento (ACOLS - PRIVATE)�
//���������������������������������������������������������������������������������������
For nCont:= 1 to Len(aCols)
	Aadd(aColsACG,Array(nUsado+1))
	
	For nI := 1 TO nUsado
	    If nI == 1
    		aColsACG[nCont][nI] := "LBOK"
	    Else	
			aColsACG[nCont][nI] := aCols[nCont][nI-1]
		Endif
	Next nI 
	
	aColsACG[nCont][nUsado+1] := .F.
Next nCont
	  
If Len(aColsACG) == 0
	MsgStop(STR0131)//"N�o existem titulos para cobran�a. Essa opera��o n�a poder� ser realizada!" 
	lRet:= .F.
	Return(lRet)
Endif

cNome	:= Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")
cCGC	:= Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CGC")  
cRegNeg	:= TkPosto(cOperador,"U0_REGNEG")
nDiasPrg:= Posicione("SK2",1,xFilial("SK2")+cRegNeg,"K2_DIAPROR")

//����������������������������������������Ŀ
//�Avalia a regra de negociacao do operador�
//������������������������������������������
Dbselectarea("SK2") 
DbsetOrder(1)
If MsSeek(xFilial("SK2")+cRegNeg) 
	If K2_ALTTIT == "1" //Altera titulo
    	lAltTit:= .T.
    Endif
Endif
    	
DEFINE MSDIALOG oDlgSimul FROM  0,0 TO 425,700 TITLE STR0132  PIXEL  //"Simula��o de Valores"

	AAdd(aButtons,{ "SIMULACA" , {|| Tk271SituaC()},STR0133 })//"Situa��o Financeira"     
	EnchoiceBar(oDlgSimul, {|| (Tk274AtuACG(aColsACG,lAtuAtend,dDataPagto,nDiasPrg,oDlgSimul)) }, {|| oDlgSimul:End() },,aButtons )
	
	@ 15,05  TO 60,130 LABEL STR0134 OF oDlgSimul  PIXEL	//"Informa��es de Cobran�a"
   	@ 15,135 TO 60,345 LABEL STR0135 OF oDlgSimul  PIXEL	//"Dados do Cliente"

	@ 25,10  SAY STR0136 FONT oFontLeg COLOR CLR_BLUE SIZE 80,8 OF oDlgSimul PIXEL	//"Prazo de Cobranca "
	@ 25,80  SAY dPrazoCobr SIZE 50,8 Picture "99/99/99" FONT oFontLeg COLOR CLR_HBLUE  OF oDlgSimul PIXEL
	
	@ 35,10  SAY STR0137 FONT oFontLeg COLOR CLR_BLUE SIZE 80,8 OF oDlgSimul PIXEL//"Dias para Prorroga��o"
	@ 35,80  SAY nDiasPrg SIZE 40,8 Picture "@!" FONT oFontLeg COLOR CLR_HBLUE  OF oDlgSimul PIXEL

	@ 45,10 SAY STR0138 FONT oFontLeg COLOR CLR_BLUE SIZE 80,8 OF oDlgSimul PIXEL	//"Data de Pagamento"
	@ 45,80 MSGET oDataPagto VAR dDataPagto SIZE 45,8 Picture "99/99/99" FONT oFontTex COLOR CLR_BLUE OF oDlgSimul PIXEL ;
		  	VALID Tk274VlrCgd (aHeadACG,@aColsACG,dDataPagto,oGetACG,@aRdpCgd)
	
	//����������������Ŀ
	//�Dados do cliente�                         
	//������������������
	@ 25,140 SAY STR0139 FONT oFontLeg COLOR CLR_BLUE SIZE 40,08 OF oDlgSimul PIXEL//"C�digo/Loja"
	@ 25,180 SAY cCliente FONT oFontTex COLOR CLR_BLUE 	PICTURE PesqPict("SA1", "A1_COD") SIZE 30,08 OF oDlgSimul PIXEL
	@ 25,200 SAY cLoja 	 FONT oFontTex COLOR CLR_BLUE 	PICTURE PesqPict("SA1", "A1_LOJA")SIZE 10,08 OF oDlgSimul PIXEL
	
	@ 35,140 SAY STR0140 FONT oFontLeg COLOR CLR_BLUE SIZE 40,08 OF oDlgSimul PIXEL //"Nome"
	@ 35,180 SAY cNome 	FONT oFontTex COLOR CLR_BLUE PICTURE PesqPict("SA1", "A1_NOME") SIZE 170,08 OF oDlgSimul PIXEL

	@ 45,140 SAY STR0141 FONT oFontLeg COLOR CLR_BLUE SIZE 40,08 OF oDlgSimul PIXEL//"CNPJ/CPF"
	@ 45,180 SAY cCGC  	FONT oFontTex COLOR CLR_BLUE 	PICTURE PesqPict("SA1", "A1_CGC") SIZE 100,08 OF oDlgSimul PIXEL

	//���������������������Ŀ
	//�Titulos para Simular �
	//�����������������������
	@ 65,05 To 150,345 LABEL STR0142 Of oDlgSimul PIXEL//"T�tulos"	

	//GetDados
	oGetACG := MsNewGetDados():New(73,10,145,340,0,,,,,,4096,,,,oDlgSimul,aHeadACG,aColsACG)
	oGetACG:oBrowse:bLDblClick := { || Tk274MarkTit	(@oGetACG,oGetACG:nAt,@aColsACG),;
										Tk274VlrCgd	(aHeadACG,@aColsACG,dDataPagto,oGetACG,@aRdpCgd),;
										oGetACG:Refresh()}

	//�������������������������������Ŀ
	//�Rodape com totais acumulados   �
	//���������������������������������
	@ 155,05 To 210,345 LABEL STR0143 Of oDlgSimul PIXEL //"Valores Corrigidos"	

	@ 165,10 SAY STR0144 FONT oFontLeg COLOR CLR_BLUE OF oDlgSimul PIXEL //"Valor Original"
	@ 165,60 SAY aRdpCgd[7][1]  PROMPT aRdpCgd[7][2] Picture "@E 999,999,999.99" FONT oFontRdp COLOR CLR_HBLUE OF oDlgSimul PIXEL 
                                     
	@ 175,10 SAY STR0145 FONT oFontLeg  COLOR CLR_BLUE OF oDlgSimul PIXEL //"Valor Corrigido"
	@ 175,60 SAY aRdpCgd[11][1] PROMPT aRdpCgd[11][2] Picture "@E 999,999,999.99" FONT oFontRdp COLOR CLR_HBLUE OF oDlgSimul PIXEL

	@ 185,10 SAY STR0146 FONT oFontLeg COLOR CLR_BLUE OF oDlgSimul PIXEL //"Juros"
	@ 185,60 SAY aRdpCgd[3][1]	 PROMPT aRdpCgd[3][2] Picture "@E 999,999,999.99" FONT oFontRdp COLOR CLR_HBLUE OF oDlgSimul PIXEL
	
	@ 165,220 SAY STR0147 FONT oFontLeg COLOR CLR_BLUE OF oDlgSimul PIXEL //"Acr�scimos"
	@ 165,260 SAY aRdpCgd[4][1] PROMPT aRdpCgd[4][2] Picture "@E 999,999,999.99" FONT oFontRdp COLOR CLR_HBLUE OF oDlgSimul PIXEL
	
	@ 175,220 SAY STR0148 FONT oFontLeg COLOR CLR_BLUE OF oDlgSimul PIXEL //"Decr�scimos"
	@ 175,260 SAY aRdpCgd[5][1] PROMPT aRdpCgd[5][2] Picture "@E 999,999,999.99" FONT oFontRdp COLOR CLR_HBLUE OF oDlgSimul PIXEL
	
	@ 185,220 SAY STR0149 FONT oFontLeg COLOR CLR_BLUE OF oDlgSimul PIXEL //"Descontos"
	@ 185,260 SAY aRdpCgd[6][1] PROMPT aRdpCgd[6][2] Picture "@E 999,999,999.99" FONT oFontRdp COLOR CLR_HBLUE OF oDlgSimul PIXEL
	
	@ 195,20  SAY STR0150 FONT oFontLeg COLOR CLR_HBLUE SIZE 80,8 OF oDlgSimul PIXEL  //"Atualiza o Atendimento"
	@ 195,10  CHECKBOX oAtuAtend VAR lAtuAtend SIZE 8,8 PIXEL OF oDlgSimul When (lAltTit .AND. nDiasPrg > 0)		 

ACTIVATE MSDIALOG oDlgSimul CENTER             

Return(lRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274AtuACG�Autor  �Andrea Farias      � Data �  05/13/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza o atendimento de cobranca. Atualiza apenas os cam- ���
���          �pos de data de vencimento para prorrogacao do titulo.       ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA	                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
							
Static Function Tk274AtuACG(aColsACG,lAtuAtend,dDataPagto,nDiasPrg,oDlgSimul)

Local lRet		:= .F.
Local nI		:= 0
Local nPDtVenc	:= Ascan(aHeader, {|x| x[2] == "ACG_DTVENC"} ) //Data de Vencimento       		
Local nPDtReal	:= Ascan(aHeader, {|x| x[2] == "ACG_DTREAL"} )	//Data de Vencimento Real				
Local nPAtraso	:= Ascan(aHeader, {|x| x[2] == "ACG_ATRASO"} )	//Data de Vencimento Real				

If lAtuAtend .AND. nDiasPrg > 0
	If dDataPagto >= dDataBase + nDiasPrg
		MsgStop(STR0151)//"O numero m�ximo de dias para prorroga��o do titulo foi ultrapassado. A altera��o n�o poder� ser realizada."
		Return(lRet)
	Else
		//��������������������������������������������������Ŀ
		//�Atualizacao apenas data de vencimento do titulo.  �
		//����������������������������������������������������
		If TmkOk(STR0152)//"Deseja prorrogar todos os t�tulos selecionados para a data de pagamento informada?"	
            For nI:= 1 to Len(aColsACG)
            	If aColsACG[nI][1] == "LBOK"
					aCols[nI][nPDtVenc]	:= dDataPagto						//Data de Vencimento 
					aCols[nI][nPDtReal]	:= DataValida(dDataPagto)			//Data de Vencimento Real
					aCols[nI][nPAtraso]	:= dDataPagto - aCols[nI][nPDtReal]//Dias em atraso
				Endif	
			Next nI
	    Endif
	    
	Endif	
Endif                                                                  

oDlgSimul:End()

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274VlrCgd �Autor  �Microsiga          � Data �  05/11/05  ���
�������������������������������������������������������������������������͹��
���Desc.     �Calcula para todos os titulos o valor corrigido com base    ���
���          �na data de pagamento informada.                             ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Tk274VlrCgd(aHeadACG,aColsACG,dDataPagto,oGetACG,aRdpCgd)
            
Local lRet		:= .T.            									//Retorno da funcao
Local nI		:= 0                								//Contador
Local nJ		:= 0                								//Contador
Local nPFilOrig := 0                 								//Posicao do campo Filial de Origem no ACG
Local cFilOrig	:= ""                 								//Filial de Origem do Titulo
Local aValores	:= {}												//Retorno da funcao FaVlAtuCr() com os valores do titulo
Local nPTitulo	:= Ascan(aHeadACG, {|x| x[2] == "ACG_TITULO"} )	//Numero do Titulo
Local nPPrefix	:= Ascan(aHeadACG, {|x| x[2] == "ACG_PREFIX"} )	//Prefixo do Titulo
Local nPParcel	:= Ascan(aHeadACG, {|x| x[2] == "ACG_PARCEL"} )	//Parcela do Titulo
Local nPTipo	:= Ascan(aHeadACG, {|x| x[2] == "ACG_TIPO  "} )	//Tipo do Titulo
Local nPRecebe	:= Ascan(aHeadACG, {|x| x[2] == "ACG_RECEBE"} )	//Valor a Receber do Titulo
Local nPJuros	:= Ascan(aHeadACG, {|x| x[2] == "ACG_JUROS "} )	//Valor de Juros do Titulo
Local nPValRef	:= Ascan(aHeadACG, {|x| x[2] == "ACG_VALREF"} )	//Valor de Referencia
Local nPBaixa   := Ascan(aHeadACG, {|x| x[2] == "ACG_BAIXA "} )	//Log de Baixa        
Local nPStatus  := Ascan(aHeadACG, {|x| x[2] == "ACG_STATUS"} )	//Status do Atendimento

If dDataPagto < dDatabase
	MsgStop(STR0153)//"A data para c�lculo deve ser maior que a database"
	Return(.F.)
Endif
	
If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeadACG, {|x| x[2] == "ACG_FILORI"} )
Endif

//��������������������������������������Ŀ
//�Zera o array com os valores de Rodape �
//����������������������������������������
For nI := 1 To Len(aRdpCgd)
	aRdpCgd[nI][2] := 0
Next nI

For nI:= 1 to Len(aColsACG)

	IF aColsACG[nI][1] == "LBNO"
		Loop
	Endif	
	
	If nPfilOrig > 0
		cFilOrig:= aColsACG[nI][nPFilOrig]	//Filial de origem do titulo
	Else
		cFilOrig:= xFilial("SE1")
	Endif  
			
	DbSelectArea("SE1")
	DbSetOrder(1)//Filial + Prefixo + Numero + Parcela + Tipo
	If MsSeek(cFilOrig + aColsACG[nI][nPPrefix] + aColsACG[nI][nPTitulo] + aColsACG[nI][nPParcel] + aColsACG[nI][nPTipo])

		//�������������������������������������������������Ŀ
		//�Atualiza o campos do acols e executa os gatilhos.�
		//���������������������������������������������������
		Posicione("SX3",2,"ACG_TITULO","")
		RunTrigger(2,Len(aColsACG))
		
		aValores := FaVlAtuCr(Nil,dDataPagto)//Data de Pagamento para simulacao do valor corrigido

		//����������������������������������������������������������������������������������Ŀ
		//�Atualiza o Valor de Referencia, Receber, Juros, Baixa e Status na Inclusao        �
		//������������������������������������������������������������������������������������
		aColsACG[nI][nPValRef]	:= aValores[6]	//Saldo do Titulo 
		aColsACG[nI][nPJuros]	:= aValores[8] 	//Valor dos Juros
		aColsACG[nI][nPRecebe]	:= aValores[12]	//Valor a Receber

        Do Case 
        	Case !Empty(SE1->E1_BAIXA) // Se houve uma baixa verifica se foi TOTAL ou PARCIAL
        		 If (SE1->E1_SALDO > 0)
					aColsACG[nI][nPBaixa] := "1" //Baixa Parcial
					aColsACG[nI][nPStatus]:= "4" //Baixa
				 Endif
				 
				 If (SE1->E1_SALDO == 0)
					aColsACG[nI][nPBaixa] := "3" //Baixa Total
					aColsACG[nI][nPStatus]:= "1" //Pago
				 Endif	

	        Case Empty(SE1->E1_BAIXA) // Nao houve nenhuma baixa 
				aColsACG[nI][nPBaixa] := "2" //Sem Baixa            	

	  	EndCase	  	         
		
		aRdpCgd[1][2]	:= aRdpCgd[1][2] + aValores[2]
		aRdpCgd[2][2]	:= aRdpCgd[2][2] + aValores[10]
		aRdpCgd[3][2]	:= aRdpCgd[3][2] + aValores[8]
		aRdpCgd[4][2]	:= aRdpCgd[4][2] + SE1->E1_SDACRES 
		aRdpCgd[5][2]	:= aRdpCgd[5][2] + SE1->E1_SDDECRE
		aRdpCgd[6][2]	:= aRdpCgd[6][2] + aValores[9]
		aRdpCgd[7][2]	:= aRdpCgd[7][2] + aValores[1]
		aRdpCgd[8][2]	:= aRdpCgd[8][2] + aValores[6]
		aRdpCgd[9][2]	:= aRdpCgd[9][2] + aValores[7]
		aRdpCgd[10][2]	:= aRdpCgd[10][2]+ aValores[3]
		aRdpCgd[11][2]	:= aRdpCgd[11][2]+ aValores[11]
		aRdpCgd[12][2]	:= aRdpCgd[12][2]+ aValores[12]
		
	Endif
Next nI

For nJ:=1 to 12
	aRdpCgd[nJ][1]:Refresh()
Next nJ

oGetACG:aCols := aClone(aColsACG)
oGetACG:oBrowse:Refresh()

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk274MarkTit�Autor  �Andrea Farias     � Data �  05/13/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Marca e desmarca o item da GetDados.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Tk274MarkTit(oGetACG,nAt,aColsACG)

IF oGetACG:aCols[nAt][1] == "LBOK"
	oGetACG:aCols[nAt][1]:= "LBNO"
Else
	oGetACG:aCols[nAt][1]:= "LBOK"
Endif

aColsACG:=aClone(oGetACG:aCols)
oGetACG:oBrowse:Refresh()

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK274LimpaRdp �Autor  �Marcelo Kotaki  � Data �  09/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Limpa o rodape do folder de Telecobranca                    ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk274LimpaRdp()

Local nI	:= 0 			// Contador para limpar o Rodape de telecobranca

// Limpa os dados do rodape
If aRdpTlc <> NIL
	For nI := 1 To Len(aRdpTlc)
		aRdpTlc[nI][2] := 0 
	Next nI
Endif

Return(.T.)
