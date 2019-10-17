// #INCLUDE "finr650.CH"
#Include "PROTHEUS.CH"   

//����������������������������������������������������������Ŀ
//� Variaveis para tratamento dos Sub-Totais por Ocorrencia  �
//������������������������������������������������������������
#DEFINE DESPESAS           3
#DEFINE DESCONTOS          4
#DEFINE ABATIMENTOS        5
#DEFINE VALORRECEBIDO      6			
#DEFINE JUROS              7
#DEFINE MULTA              8
#DEFINE VALORIOF           9
#DEFINE VALORCC	           10

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FinR650  � Autor � Elaine F. T. Beraldo  � Data � 17/06/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impress�o do Retorno da Comunica��o Banc�ria               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FinR650()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��� 15/09/05 � Alterado para tratar motivos de rejeicao com dois ou tres  ���
��� Digitos                                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function FinR650()
Local wnrel
Local cString
Local cDesc1  := "Este programa tem como objetivo imprimir o arquivo"
Local cDesc2  := "Retorno da Comunicacao Bancaria, conforme layout, "
Local cDesc3  := "previamente configurado."
LOCAL tamanho := "G"

//������������������Ŀ
//� Define Variaveis �
//��������������������
PRIVATE Titulo := OemToAnsi("Impressao do Retorno da Comunicacao Bancaria")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE cPerg    := "FIN650"   , nLastKey := 0
PRIVATE nomeprog := "finr650"

//������������������������������������Ŀ
//� Verifica as perguntas selecionadas �
//��������������������������������������
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Arquivo de Entrada                    �
//� mv_par02            // Arquivo de Configura��o               �
//� mv_par03            // Codigo do Banco                       �
//� mv_par04            // Codigo Agencia							     �
//� mv_par05            // Codigo Conta			                 �
//� mv_par06            // Codigo SubConta			              �
//� mv_par07            // Receber / Pagar                       �
//� mv_par08            // Modelo Cnab / Cnab2		              �
//����������������������������������������������������������������

If mv_par07 == 1
	cString := "SE1"
Else
	cString := "SE2"
EndIf	

//���������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT �
//�����������������������������������������
wnrel := "FINR650"            //Nome Default do relatorio em Disco
aOrd  := {OemToAnsi("Por numero"),OemToAnsi("Por natureza"),OemToAnsi("Por vencimento"),; 
			 OemToAnsi("Por banco"),OemToAnsi("Fornecedor"),OemToAnsi("Por emissao"),OemToAnsi("Por Cod. Fornec.")}
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
    Return
End

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|lEnd| U_Fa650Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA650Imp � Autor � Elaine F. T. Beraldo  � Data � 20/06/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impress�o da Comunicacao Bancaria - Retorno                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FA650Imp()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR650                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function FA650Imp(lEnd,wnRel,cString)

Local cPosPrin,cPosJuro,cPosMult,cPosCC ,cPosTipo
Local cPosNum ,cPosData,cPosDesp,cPosDesc,cPosAbat,cPosDtCC,cPosIof,cPosOcor 
Local cPosNosso, cPosForne, cPosCgc
Local lPosNum  := .f. , lPosData := .f. , lPosAbat := .f.
Local lPosDesp := .f. , lPosDesc := .f. , lPosMult := .f.
Local lPosPrin := .f. , lPosJuro := .f. , lPosDtCC := .f.
Local lPosOcor := .f. , lPosTipo := .f. , lPosIof  := .f.
Local lPosCC   := .f. , lPosNosso:= .f. , lPosRej	:= .f.
Local lPosForne:=.f. , lPosCgc := .F.
Local nLidos ,nLenNum  ,nLenData ,nLenDesp ,nLenDesc ,nLenAbat ,nLenDtCC, nLenCGC
Local nLenPrin ,nLenJuro ,nLenMult ,nLenOcor ,nLenTipo ,nLenIof  ,nLenCC
Local nLenRej := 0
Local ntamrej_ := 0
Local cArqConf ,cArqEnt  ,xBuffer  ,nTipo
Local tamanho   := "G", lOcorr := .F.
Local cDescr
LOCAL cEspecie,cData,nTamArq,cForne,cCgc
Local nValIof	:= 0
Local nDespT:=nDescT:=nAbatT:=nValT:=nJurT:=nMulT:=nIOFT:=nCCT:=0
Local nHdlBco  := 0
Local nHdlConf := 0
Local cTabela 	:= "17"
Local lRej := .f.
Local cCarteira
Local nTamDet
Local lHeader := .f.
Local lTrailler:= .F.
Local aTabela 	:= {}
Local cChave650
Local nPos := 0
Local lAchouTit := .F.
Local nValPadrao := 0
Local aValores := {}
LOCAL lF650Var := ExistBlock("F650VAR" ) 
Local nTamparc := TamSX3("E1_PARCELA")[1]
LOCAL dDataFin := Getmv("MV_DATAFIN")
Local nCont
Local lOk
Local x
Local nCntOco  := 0
Local aCntOco  := {}
Local cCliFor	:= "  "

PRIVATE m_pag , cbtxt , cbcont , li 

//Essas variaveis tem que ser private para serem manipuladas
//nos pontos de entrada, assim como eh feito no FINA200
Private cNumTit
Private dBaixa
Private cTipo
Private cNossoNum
Private nDespes	:= 0
Private nDescont	:= 0
Private nAbatim	:= 0
Private nValrec	:= 0
Private nJuros	:= 0
Private nMulta	:= 0
Private nValCc	:= 0
Private dCred
Private cOcorr

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
If mv_par07 == 1
	cabec1  := OemToAnsi("No.Titulo   Esp  Cli/For   Ocorrencia                 Dt.Ocor.   Desp. Cobr  Vlr Desconto  Vlr Abatimento   Vlr Principal     Vlr Juros    Vlr Multa      Vlr IOF   Out Creditos  Dt.Cred. Vencimento       Consistencia")
Else
	cabec1  := OemToAnsi("No.Titulo   Esp  Cli/For   Ocorrencia                 Dt.Ocor.   Desp. Cobr  Vlr Desconto  Vlr Abatimento   Vlr Principal     Vlr Juros    Vlr Multa      Nro Titulo Bco   Consistencia ")
EndIf
cabec2  := ""
nTipo:=Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

//��������������������������������������������������������������Ŀ
//� Busca tamanho do detalhe na configura��o do banco            �
//����������������������������������������������������������������
dbSelectArea("SEE")
If dbSeek(xFilial("SEE")+mv_par03+mv_par04+mv_par05+mv_par06)
   nTamDet:= Iif(Empty (SEE->EE_NRBYTES), 400, SEE->EE_NRBYTES)
	ntamDet+= 2  // Ajusta tamanho do detalhe para leitura do CR (fim de linha)
Else
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOBCOCAD")
	Return .F.
Endif

cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

dbSelectArea( "SX5" )
If !SX5->( dbSeek( cFilial + cTabela ) )
	Help(" ",1,"PAR150")
   Return .F.
Endif
While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
	AADD(aTabela,{Alltrim(X5Descri()),Pad(SX5->X5_CHAVE,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)))})  // correcao da tabela de titulos (Pequim 18/08/00) 
	SX5->(dbSkip( ))
Enddo

IF mv_par08 == 1
	//������������������������������Ŀ
	//� Abre arquivo de configura��o �
	//��������������������������������
	cArqConf:=mv_par02
	IF !FILE(cArqConf)
		Set Device To Screen
		Set Printer To
		Help(" ",1,"NOARQPAR")
		Return .F.
	Else
		nHdlConf:=FOPEN(cArqConf,0+64)
	End

	//����������������������������Ŀ
	//� L� arquivo de configura��o �
	//������������������������������
	nLidos :=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)

	While nLidos <= nTamArq

		//�������������������������������������������Ŀ
		//� Verifica o tipo de qual registro foi lido �
		//���������������������������������������������
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)

		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
			nLidos+=85
			Loop
		EndIF
	
		If mv_par07 == 1						// Somente cart receber deve ler estes campos
			IF !lPosIof
				cPosIof:=Substr(xBuffer,17,10)
				nLenIof:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosIof:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosCC
				cPosCC:=Substr(xBuffer,17,10)
				nLenCC:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosCC:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosDtCc
				cPosDtCc:=Substr(xBuffer,17,10)
				nLenDtCc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosDtCc:=.t.
				nLidos+=85
				Loop
			EndIF
		EndIf	
	
		IF !lPosNosso
			cPosNosso:=Substr(xBuffer,17,10)
			nLenNosso:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNosso:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosRej
			cPosRej:=Substr(xBuffer,17,10)
			nLenRej:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosRej:=.t.
			nLidos+=85
			Loop
		EndIF
		If mv_par07 == 2
			IF !lPosForne
	  	    	cPosForne := Substr(xBuffer,17,10)
				nLenForne := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosForne := .t.
				nLidos += 85
				Loop
			EndIF
			IF !lPosCgc
   	   	cPosCgc   := Substr(xBuffer,17,10)
				nLenCgc   := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosCgc   := .t.
				nLidos += 85
				Loop
			EndIF
		Endif
		Exit
	EndDo

	//�������������������������������Ŀ
	//� fecha arquivo de configuracao �
	//���������������������������������
	Fclose(nHdlConf)
Endif
//���������������������������������Ŀ
//� Abre arquivo enviado pelo banco �
//�����������������������������������
cArqEnt:=mv_par01
IF !FILE(cArqEnt)
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOARQENT")
	Return .F.
Else
	nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

//�������������������������������Ŀ
//� L� arquivo enviado pelo banco �
//���������������������������������
nLidos:=0
FSEEK(nHdlBco,0,0)
nTamArq:=FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)

SetRegua(nTamArq/nTamDet)

While nTamArq-nLidos >= nTamDet
	If mv_par08 == 1
		//�����������������������������Ŀ
		//� Tipo qual registro foi lido �
		//�������������������������������
		xBuffer:=Space(nTamDet)
		FREAD(nHdlBco,@xBuffer,nTamDet)

		IncRegua()

		IF !lHeader
			nLidos+=nTamDet
			lHeader := .t.
			Loop
		EndIF

		IF	SubStr(xBuffer,1,1) == "0" .or. SubStr(xBuffer,1,1) == "9" .or. ;
			SubStr(xBuffer,1,1) == "7" .or. SubStr(xBuffer,1,1) == "8"
			nLidos+=nTamDet
			Loop
		EndIF

		If SubStr(xBuffer,1,1) == "1" .or. Substr(xBuffer,1,3) == "001"
			nDespes :=0
			nDescont:=0
			nAbatim :=0
			nValRec :=0
			nJuros  :=0
			nMulta  :=0
			If mv_par07 == 1						// somente carteira receber
				nValIof :=0
				nValCc  :=0
				dCred   :=ctod("  /  /  ")			
			Else
				cCgc := " "
			EndIf	
			cData   :=""
			dBaixa  :=ctod("  /  /  ")
			cEspecie:="  "
			cNossoNum:=Space(15)
			cForne:= Space(8)

			//����������������������������������Ŀ
			//� L� os valores do arquivo Retorno �
			//������������������������������������
			IF !Empty(cPosDesp)
				nDespes:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100
			EndIF
			IF !Empty(cPosDesc)
				nDescont:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100
			EndIF
			IF !Empty(cPosAbat)
				nAbatim:=Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100
			EndIF
			IF !Empty(cPosPrin)
				nValRec :=Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100
			EndIF
			IF !Empty(cPosJuro)
				nJuros  :=Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100
			EndIF
			IF !Empty(cPosMult)
				nMulta  :=Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100
			EndIF
			IF !Empty(cPosIof)
				nValIof :=Val(Substr(xBuffer,Int(Val(Substr(cPosIof,1,3))),nLenIof))/100
			EndIF
			IF !Empty(cPosCc)
				nValCc :=Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100
			EndIF
			IF !Empty(cPosNosso)
				cNossoNum :=Substr(xBuffer,Int(Val(Substr(cPosNosso,1,3))),nLenNosso)
			EndIF
			IF !Empty(cPosForne)
				cForne  :=Substr(xBuffer,Int(Val(Substr(cPosForne,1,3))),nLenForne)
			Endif
			If !Empty(cPosCgc)
				cCgc  :=Substr(xBuffer,Int(Val(Substr(cPosCgc,1,3))),nLenCgc)
			Endif

			cDescr  := ""
			cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
			cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
			cData   := ChangDate(cData,SEE->EE_TIPODAT)
			dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
			cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
			cTipo   := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
			IF !Empty(cPosDtCc)
				cData :=Substr(xBuffer,Int(Val(Substr(cPosDtCc,1,3))),nLenDtCc)
				dCred :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
			EndIF
			If nLenOcor == 2
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
			Else
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
			EndIf	
			If nLenRej > 0
				cRej		:= Substr(xBuffer,Int(Val(Substr(cPosRej,1,3))),nLenRej)
			EndIf	

			lOk := .T.
			//�������������������������������Ŀ
			//� o array aValores ir� permitir �
			//� que qualquer exce��o ou neces-�
			//� sidade seja tratado no ponto  �
			//� de entrada em PARAMIXB        �
			//���������������������������������
			// Estrutura de aValores
			//	Numero do T�tulo	- 01
			//	data da Baixa		- 02
			// Tipo do T�tulo		- 03
			// Nosso Numero		- 04
			// Valor da Despesa	- 05
			// Valor do Desconto	- 06
			// Valor do Abatiment- 07
			// Valor Recebido    - 08
			// Juros					- 09
			// Multa					- 10
			// Valor do Credito	- 11
			// Data Credito		- 12
			// Ocorrencia			- 13
			// Linha Inteira		- 14

			aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })

			If lF650Var
				ExecBlock("F650VAR",.F.,.F.,{aValores})
			Endif

			If !Empty(cTipo)
				//�������������������������������Ŀ
				//� Verifica especie do titulo    �
				//���������������������������������
				nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					cEspecie	:= "  "
				EndIf								
				If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
					nLidos+=nTamDet
					Loop
				Endif
				dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
				dbSetOrder(IIF(mv_par07==1,16,11))
  	         lAchouTit := .F.
				If !Empty(Substr(cNumtit,1,10))
					If dbSeek(xFilial()+Substr(cNumtit,1,10))
   		         lAchouTit := .T.
						nPos   := 1
    				Endif
    			Endif
				While !lAchouTit
					dbSetOrder(1)
					cChave650 := IIf(!Empty(cForne),cNumTit+Space(nTamParc-1)+cEspecie+SubStr(cForne,1,6),cNumTit+Space(nTamParc-1)+cEspecie)
					If !dbSeek(xFilial()+cChave650)
						nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
						If nPos != 0
							cEspecie := aTabela[nPos][2]
						Else
							Exit
						Endif
					Else
						If mv_par07 == 2
							cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
							cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
							nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso
							                    // Encontre o titulo
							While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave650
								nPos := nPosEsp
								If Empty(cCgc)
									Exit
								Endif
								dbSelectArea("SA2")
								If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
									If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
										Exit
									Endif
								Endif
								dbSelectArea("SE2")
								dbSkip()
								cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
								cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
								nPos 	  := 0
							Enddo
						Endif
						Exit
					Endif
				Enddo
				If nPos == 0
					cEspecie	:= "  "
					cCliFor	:= "  "
				Else
					cEspecie := IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)				
					cNumTit := IIF(mv_par07==1,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
					cCliFor	:= IIF(mv_par07==1,SE1->E1_CLIENTE+" "+SE1->E1_LOJA,SE2->E2_FORNECE+" "+SE2->E2_LOJA)
				EndIF
				If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
					nLidos += nTamDet
					Loop
				EndIf
			EndIF
		Else
			lTrailler := .T.
		Endif
	Else
		aLeitura := ReadCnab2(nHdlBco,MV_PAR02,nTamDet)
		If ( Empty(aLeitura[1]) )
			nLidos += nTamDet
			Loop
		Endif
		cNumTit  	:= SubStr(aLeitura[1],1,10)
		cData    	:= aLeitura[04]
		cData   		:= ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa   	:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y", Len(Substr(cData,5))))
		cTipo    	:= aLeitura[02]
		cTipo    	:= Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
		cNossoNum   := aLeitura[11]
		nDespes  	:= aLeitura[06]
		nDescont 	:= aLeitura[07]
		nAbatim  	:= aLeitura[08]
		nValRec  	:= aLeitura[05]
		nJuros   	:= aLeitura[09]
		nMulta   	:= aLeitura[10]
		cOcorr   	:= PadR(aLeitura[03],3)
		nValOutrD	:= aLeitura[12]
		nValCC   	:= aLeitura[13]
		cData    	:= aLeitura[14]
		cData   		:= ChangDate(cData,SEE->EE_TIPODAT)
		dDataCred	:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
		dDataUser	:= dDataCred
		dCred			:= dDataCred
		cRej		  	:= aLeitura[15]
		cForne		:= aLeitura[16]
		cCgc			:= " "
		lOk := .t.
      lAchouTit := .F.
		//�������������������������������Ŀ
		//� o array aValores ir� permitir �
		//� que qualquer exce��o ou neces-�
		//� sidade seja tratado no ponto  �
		//� de entrada em PARAMIXB        �
		//���������������������������������
		// Estrutura de aValores
		//	Numero do T�tulo	- 01
		//	data da Baixa		- 02
		// Tipo do T�tulo		- 03
		// Nosso Numero		- 04
		// Valor da Despesa	- 05
		// Valor do Desconto	- 06
		// Valor do Abatiment- 07
		// Valor Recebido    - 08
		// Juros					- 09
		// Multa					- 10
		// Valor do Credito	- 11
		// Data Credito		- 12
		// Ocorrencia			- 13
		// Linha Inteira		- 14

		aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })
		nLenRej := Len(AllTrim(cRej))
		If lF650Var
			ExecBlock("F650VAR",.F.,.F.,{aValores})
		Endif

		//�������������������������������Ŀ
		//� Verifica especie do titulo    �
		//���������������������������������
		nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
		If nPos != 0
			cEspecie := aTabela[nPos][2]
		Else
			cEspecie	:= "  "
		EndIf								
		If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
			nLidos += nTamDet
			Loop
		Endif
		dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
		dbSetOrder(IIF(mv_par07==1,16,11))
		If dbSeek(xFilial()+Substr(cNumtit,1,10))
         lAchouTit := .T.
			nPos   := 1
		Endif
		While !lAchouTit
			dbSetOrder(1)
			cChave650 := IIf(!Empty(cForne),cNumTit+Space(nTamParc-1)+cEspecie+SubStr(cForne,1,6),cNumTit+Space(nTamParc-1)+cEspecie)
			If !dbSeek(xFilial()+cChave650)
				nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					Exit
				Endif
			Else
				If mv_par07 == 2
					cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
					cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
					nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso
					                    // Encontre o titulo
					While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave650
						nPos := nPosEsp
						If Empty(cCgc)
							Exit
						Endif
						dbSelectArea("SA2")
						If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
							If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
								Exit
							Endif
						Endif
						dbSelectArea("SE2")
						dbSkip()
						cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
						cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
						nPos 	  := 0
					Enddo
				Endif
				Exit
			Endif
		Enddo
		If nPos == 0
			cEspecie	:= "  "
			cCliFor	:= "  "
		Else
			cEspecie := IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)		
			cNumTit := IIF(mv_par07==1,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
			cCliFor	:= IIF(mv_par07==1,SE1->E1_CLIENTE+" "+SE1->E1_LOJA,SE2->E2_FORNECE+" "+SE2->E2_LOJA)
		EndIF
		If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
			nLidos+=nTamDet
			Loop
		EndIf
	EndIf   

	If ( ltrailler )
		nLidos+=nTamDet
		loop
	EndIf

   IF lEnd
		@ PROW()+1, 001 PSAY "CANCELADO PELO OPERADOR" 
		Exit
	End

	IF li > 58
		cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
   End

	@li,000 PSAY cNumTit
	@li,013 PSAY cEspecie
	//�������������������������������Ŀ
	//� Verifica codigo da ocorrencia �
	//���������������������������������
	dbSelectArea("SEB")
	If mv_par07 == 1
		cCarteira := "R"
	Else
		cCarteira := "P"
	EndIf	
   If (dbSeek(cFilial+mv_par03+cOcorr+cCarteira))
		cDescr := cOcorr + "- " + Subs(SEB->EB_DESCRI,1,27)
		
		//�����������������������������������������������Ŀ
		//� Efetua contagem dos SubTotais por ocorrencia  �
		//�������������������������������������������������
		nCntOco := Ascan(aCntOco, { |X| X[1] == cOcorr})
		If nCntOco == 0
			Aadd(aCntOco,{cOcorr,Subs(SEB->EB_DESCRI,1,27),nDespes,nDescont,nAbatim,nValRec,nJuros,nMulta,nValIof,nValCc})
		Else
			aCntOco[nCntOco][DESPESAS]     +=nDespes
			aCntOco[nCntOco][DESCONTOS]    +=nDescont
			aCntOco[nCntOco][ABATIMENTOS]  +=nAbatim
			aCntOco[nCntOco][VALORRECEBIDO]+=nValRec
			aCntOco[nCntOco][JUROS]        +=nJuros
			aCntOco[nCntOco][MULTA]        +=nMulta
			aCntOco[nCntOco][VALORIOF]     +=nValIOF
			aCntOco[nCntOco][VALORCC]      +=nValCC
		Endif

		If SEB->EB_OCORR $ "03�15�16�17�40�41�42"		//Registro rejeitado
			//�������������������������������Ŀ
			//� Verifica tabela de rejeicao   �
			//���������������������������������
			If nLenRej > 0

                // verifica se o cod do motivo de rejeicao tem 2 ou 3 digitos
				If SEB->(dbSeek(cFilial+mv_par03+cOcorr+cCarteira))
				 ntamrej_ := len(alltrim(SEB->EB_MOTBAN))
                End

				If SEB->(dbSeek(cFilial+mv_par03+cOcorr+cCarteira+Substr(cRej,1,ntamrej_)))

                  If ntamrej_ == 2
    				cDescr := cOcorr + "(" + Substr(cRej,1,ntamrej_) + ")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
                  ElseIf ntamrej_ == 3
    				cDescr := cOcorr + "(" + Substr(cRej,1,ntamrej_) + ")" + "-" + Substr(SEB->EB_DESCMOT,1,21)
                  End                  

				EndIf
				lRej := .T.
			EndIf	
		EndIf	
		lOcorr := .T.
	Else
		cDescr  := Space(29)
		lOcorr  := .F.
		nCntOco := Ascan(aCntOco, { |X| X[2] == OemToAnsi("OCORRENCIA NAO ENCONTRADA")})
		If nCntOco == 0
			Aadd(aCntOco,{"00 ",OemToAnsi("OCORRENCIA NAO ENCONTRADA"),nDespes,nDescont,nAbatim,nValRec,nJuros,nMulta,nValIof,nValCc})
		Else
			aCntOco[nCntOco][DESPESAS]     +=nDespes
			aCntOco[nCntOco][DESCONTOS]    +=nDescont
			aCntOco[nCntOco][ABATIMENTOS]  +=nAbatim
			aCntOco[nCntOco][VALORRECEBIDO]+=nValRec
			aCntOco[nCntOco][JUROS]        +=nJuros
			aCntOco[nCntOco][MULTA]        +=nMulta
			aCntOco[nCntOco][VALORIOF]     +=nValIOF
			aCntOco[nCntOco][VALORCC]      +=nValCC
		Endif
	Endif
	If mv_par07 == 1
		dbSelectArea("SE1")
	Else
		dbSelectArea("SE2")
	EndIf		
	@li,017 PSAY cCliFor	
	@li,027 PSAY Subs(cDescr,1,26)
	@li,054 PSAY dBaixa      
	@li,063 PSAY nDespes  picture tm(nDespes,12)  //'@E 99999,999.99'
	@li,076 PSAY nDescont picture tm(nDescont,12) //'@E 99999,999.99'
	@li,092 PSAY nAbatim  picture tm(nAbatim,12)  //'@E 99999,999.99'
	@li,106 PSAY nValRec  picture tm(nValRec,12)	 //'@E 99999,999.99'
	@li,120 PSAY nJuros   picture tm(nJuros,12)	 //'@E 99999,999.99'
	@li,133 PSAY nMulta   picture tm(nMulta,12)	 //'@E 99999,999.99'
	If mv_par07 == 1
		@li,146 PSAY nValIof  picture tm(nValIof,12) //'@E 99999,999.99'
		@li,160 PSAY nValCc   picture tm(nValCC,12)  //'@E 99999,999.99'
		@li,173 PSAY Iif(Empty(dCred),dDataBase,dCred)
		@li,184 PSAY Pad(cNossoNum,19)
	Else
		@li,153 PSAY Pad(cNossoNum,19)
	EndIf			

   nDespT += nDespes
	nDescT += nDescont
	nAbatT += nAbatim
	nValT  += nValRec
	nJurT  += nJuros
	nMulT  += nMulta
	If mv_par07 == 1
		nIOFT  += nValIOF
		nCCT   += nValCC
	EndIf	
		
	IF Empty(cOcorr)
		cDescr := OemToAnsi("OCORRENCIA NAO ENVIADA")
      lOk := U_ImpCons(cDescr)
	Else
		If ! lOcorr
			cDescr := OemToAnsi("OCORRENCIA NAO ENCONTRADA")
			lOk := U_ImpCons(cDescr)
		End
	EndIf

	If dBaixa < dDataFin
		cDescr := OemToAnsi("DATA MENOR QUE DATA FECH.FINANCEIRO")
		lOk := U_ImpCons(cDescr)
	Endif

	IF Empty(cNumTit) 
		cDescr := OemToAnsi("NUMERO TITULO NAO ENVIADO")
      lOk := U_ImpCons(cDescr)
	End
		
	lAchouTit := .F.
	dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
	dbSetOrder(1)
	If mv_par07 == 1
	   cChave650 := cNumTit+cEspecie
	Else
		cChave650 := IIf(!Empty(cForne),;
							cNumTit+cEspecie+SubStr(cForne,1,6),;
							cNumTit+cEspecie)
	EndIf		
	If !dbSeek(cFilial+cChave650)
		cDescr := OemToAnsi("TITULO NAO ENCONTRADO")
  		lOk := U_ImpCons(cDescr)
	Else
		lAchouTit := .T.
	Endif
	IF Substr(dtoc(dBaixa),1,1)=' '
		cDescr := OemToAnsi("DATA DE BAIXA NAO ENVIADA")
      lOk := U_ImpCons(cDescr)
	EndIF

	IF Empty(cTipo)
		cDescr := OemToAnsi("ESPECIE NAO ENVIADA")
      lOk := U_ImpCons(cDescr)
	Endif
		
	If Empty(cEspecie)
		cDescr := OemToAnsi("ESPECIE NAO ENCONTRADA")
      lOk := U_ImpCons(cDescr)
	Endif
		
	If mv_par07 == 1 .and. lAchouTit .and. nAbatim == 0 .and. SE1->E1_SALDO > 0
		nValPadrao := nValRec-(nJuros+nMulta-nDescont)
		nTotAbat := SumAbatRec(Substr(cNumtit,1,3),Substr(cNumtit,4,6),;
									Substr(cNumtit,10,1),1,"S")
		If Round(NoRound((SE1->E1_SALDO-nTotAbat),3),2) < Round(NoRound(nValPadrao,3),2)
			cDescr := OemToAnsi("VALOR RECEBIDO A MAIOR")
	     	lOk := U_ImpCons(cDescr)
		Endif
	Endif

	//�����������������������������������������������Ŀ
	//� Informa a condicao da baixa do titulo         �
	//�������������������������������������������������
	If lOk
		If mv_par07 == 1
			If SE1->E1_SALDO = 0
				cDescr := "BAIXADO ANTERIORMENTE - TOTAL"
		      lOk := U_ImpCons(cDescr)
			ElseIf SE1->E1_VALOR <> SE1->E1_SALDO
				cDescr := "BAIXADO ANTERIORMENTE - PARCIAL"
		      lOk := U_ImpCons(cDescr)
			End
		Else
			If SE2->E2_SALDO = 0
				cDescr := "BAIXADO ANTERIORMENTE - TOTAL"
				lOk := U_ImpCons(cDescr)
			ElseIf SE2->E2_VALOR <> SE2->E2_SALDO
				cDescr := "BAIXADO ANTERIORMENTE - PARCIAL"
				lOk := U_ImpCons(cDescr)
			End
		Endif
	Endif

	If lOk
		cDescr := OemToAnsi("TITULO OK")
      lOk := U_ImpCons(cDescr)
	EndIf

	If nLenRej > 0
		If Len(Alltrim(cRej)) > 2

            // verifica se o cod do motivo de rejeicao tem 2 ou 3 digitos
			If SEB->(dbSeek(cFilial+mv_par03+cOcorr+cCarteira))
			 ntamrej_ := len(alltrim(SEB->EB_MOTBAN))
            End
	
			For nCont := (ntamrej_+1) to Len(Alltrim(cRej)) Step ntamrej_
  				If lRej
					//�������������������������������Ŀ
					//� Verifica tabela de rejeicao   �
					//���������������������������������
					dbSelectArea("SEB")
    
					If dbSeek(cFilial+mv_par03+cOcorr+cCarteira+Substr(cRej,nCont,ntamrej_))

                        If ntamrej_==2
     						cDescr := cOcorr + "(" + Substr(cRej,nCont,ntamrej_) + ")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
                        ElseIf ntamrej_==3
     						cDescr := cOcorr + "(" + Substr(cRej,nCont,ntamrej_) + ")" + "-" + Substr(SEB->EB_DESCMOT,1,21)
                        End                        
						@li,027 PSAY Subs(cDescr,1,26)
						li++
					EndiF

				EndIf
			Next nCont
		EndIf
	EndIf	
	If mv_par07 == 1
		dbSelectArea("SE1")		
	Else
		dbSelectArea("SE2")
	EndIf	
	If mv_par08 == 1
		nLidos+=nTamDet
	Endif
EndDO

IF li != 80
	Li+=2   
	
    If (Len(aCntOco) + Li) > 55
        Cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
    Endif

   //�����������������������������������Ŀ
   //� Imprime Subtotais por ocorrencia  �
   //�������������������������������������
   @li,000 PSAY OemToAnsi("SUBTOTAIS DO RELATORIO")
  	Li+=2   
	For x :=1 to Len(aCntOco)         
		If(x <= 10)                                        
			@li,000 PSAY aCntOco[x][1] + Substr(aCntOco[x][2],1,30) 
			@li,063 PSAY (aCntOco[x][DESPESAS])      picture Tm((aCntOco[x][03]),12) //'@E 9,999,999,999.99'
			@li,076 PSAY (aCntOco[x][DESCONTOS])     picture Tm((aCntOco[x][04]),12) //'@E 9,999,999,999.99'
			@li,092 PSAY (aCntOco[x][ABATIMENTOS])   picture Tm((aCntOco[x][05]),12) //'@E 9,999,999,999.99'
			@li,106 PSAY (aCntOco[x][VALORRECEBIDO]) picture Tm((aCntOco[x][06]),12) //'@E 9,999,999,999.99'
			@li,120 PSAY (aCntOco[x][JUROS])         picture Tm((aCntOco[x][07]),12) //'@E 9,999,999,999.99'
			@li,133 PSAY (aCntOco[x][MULTA])         picture Tm((aCntOco[x][08]),12) //'@E 9,999,999,999.99'
		   If mv_par07 == 1
				@li,146 PSAY (aCntOco[x][VALORIOF])   picture Tm((aCntOco[x][09]),12) //'@E 9,999,999,999.99'
			   @li,160 PSAY (aCntOco[x][VALORCC])    picture Tm((aCntOco[x][10]),12) //'@E 9,999,999,999.99'
			Endif
		Else
			Exit
		Endif
		Li ++
	Next
	Li+=2

	If (Len(aCntOco) + Li) > 58
   	Cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
   Endif

   //�������������������������������Ŀ
   //� Imprime Totais                �
   //���������������������������������
	@li,000 PSAY OemToAnsi("TOTAIS DO RELATORIO")
	@li,063 PSAY nDespT      picture TM(nDespT,12) //'@E 9,999,999,999.99'
	@li,076 PSAY nDescT      picture TM(nDescT,12) //'@E 9,999,999,999.99'
	@li,092 PSAY nAbatT      picture TM(nAbatT,12) //'@E 9,999,999,999.99'
	@li,106 PSAY nValT       picture Tm(nValT,12)  //'@E 9,999,999,999.99'
	@li,120 PSAY nJurT       picture Tm(nJurT,12)  //'@E 9,999,999,999.99'
	@li,133 PSAY nMulT       picture Tm(nMult,12)  //'@E 9,999,999,999.99'
	If mv_par07 == 1
		@li,146 PSAY nIofT    picture TM(nIofT,12) //'@E 9,999,999,999.99'
		@li,160 PSAY nCcT     picture TM(nCcT,12)  //'@E 9,999,999,999.99'
	EndIf	
	roda(cbcont,cbtxt,tamanho)
EndIF

//�������������������������Ŀ
//� Fecha os Arquivos ASCII �
//���������������������������
fClose(nHdlBco)
fClose(nHdlConf)

Set Device TO Screen
dbSelectArea("SEF")
dbSetOrder(1)
Set Filter To

If aReturn[5] = 1
    Set Printer To
    dbCommit()
    Ourspool(wnrel)
End
MS_FLUSH()
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Fun��o    � IMPCONS  � Autor � Elaine F. T. Beraldo  � Data � 27/06/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impress�o da Consistencia                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � IMPCONS(texto)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR650.PRG                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function ImpCons(cTexto)
If mv_par07 == 1
	@ li,204 PSAY Pad(cTexto,15)
Else
	@ li,173 PSAY Pad(cTexto,31)
EndIf		
li++
Return .F.
