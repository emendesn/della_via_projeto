#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA024A � Autor �Ricardo Mansano     � Data �  11/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Tela com GetDados para Cadastro de Cartas de SEPU.         ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada Via Menu                                           ���
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
Project Function DELA024A()
Local oDlg
Local oGetD
Local oFnt
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= MsAdvSize()
Local aInfo     	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local nUsado		:= 0
Local nX			:= 0
Local nReg	 		:= 1
Local nOpc   		:= 3 // Visualiza=2 / Inclui=3 / Altera=4 / Exclui=5

Local aCpoGDa		:= {"PA4_SEPU","PA4_DESGAS","PA4_VBONFA"}	// Campos da GetDados
Local nLinhas 		:= 100 // Numero de linhas Permitido na GetdDados
Local aButtons    	:= {}

//����������������������������������������������Ŀ
//�Declara programas chamados pela GetDados.     �
//������������������������������������������������
Local cFieldOk		:= "P_DELA024C"
Local cLinOk  		:= "P_DELA024D"
Local cTudoOk  		:= "P_DELA024E"
Local cDelOk		:= "P_DELA024F"


//����������������������������������������������Ŀ
//�Variaveis dos Campos de Edicao no topo da Tela�
//������������������������������������������������
Private oNumLote,oDataAp,oVlrTot
Private cDataAp    	:= CriaVar("PA4_DTAPLI")
Private nVlrTot    	:= CriaVar("PA4_VBONFA") 	// Sera Utilizada no Tudo Ok para
// verificar se o valor da carta bate com o Total
//����������������������������������������������Ŀ
//�Variaveis utilizadas pela GetDados.           �
//������������������������������������������������
Private aHeader 	:= {}
Private aCols   	:= {}
Private n			:= 1
Private aRotina 	:= {{"Pesquisar","AxPesqui"   ,0,1},;
{"Visual"   ,"AxVisual"  ,0,2},;
{"Incluir"  ,"AxInclui"  ,0,3} }

//��������������������Ŀ
//�Rodape da GetDados. �
//����������������������
Private oRod
Private _nTot		:= 0

//������������������Ŀ
//� Carrega aHeader. �
//��������������������
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

// Alimenta Variaveis na aCols
aCols:={Array(nUsado+1)}
aCols[1,nUsado+1]:=.F.
For nX := 1 To nUsado
	aCols[1,nX] := CriaVar(aHeader[nX,2])
Next

// Definicoes de Resolucao da Tela
aObjects := {}
AADD(aObjects,{100,020,.T.,.F.,.F.})
AADD(aObjects,{100,085,.T.,.T.,.F.})
AADD(aObjects,{000,15, .T., .F. } )
aPosObj := MsObjSize( aInfo, aObjects )

// Fonte
DEFINE FONT oFnt NAME "Arial" SIZE 08,17 BOLD

DEFINE MSDIALOG oDlg TITLE "Carta Pirelli" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

@ aPosObj[1,1],aPosObj[1,2] To aPosObj[1,3],aPosObj[1,4] of oDlg Pixel

@ 021,010 Say "Dt.Aplicacao"  of oDlg Pixel
@ 020,055 MSGET oDataAp  VAR cDataAp SIZE 60,09 OF oDlg PIXEL

@ 022,200 Say "Valor Total"   of oDlg Pixel
@ 020,255 MSGET oVlrTot  VAR nVlrTot SIZE 70,09 OF oDlg PIXEL Picture "@E 999,999.99"

oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,cLinOk,cTudoOk,,.T.,,,,nLinhas,cFieldOk,,,cDelOk)
oGetD:aInfo[aScan(aHeader, {|x| rTrim(x[2]) == "PA4_VBONFA"})][4] := "" // Desabilita X3_WHEN

// Rodape
@ aPosObj[3,1]+4,010 Say "Valor Digitado:" Pixel Of oDlg
@ aPosObj[3,1]+3,060 SAY oRod VAR Transform(_nTot,"@E 999,999.99")	SIZE 065,10 OF oDlg	 PIXEL RIGHT COLOR CLR_HRED	FONT oFnt

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| ( if(P_DELA024E(),oDlg:End(),nil)  ) },{||oDlg:End()},,aButtons)
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA024C � Autor �Ricardo Mansano     � Data �  11/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � FieldOK da GetDados.                                       ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - .T. se a validacao estiver Ok, caso contrario .F.    ���
�������������������������������������������������������������������������͹��
���Aplicacao � Valida os campos da GetDados apos a sua digitacao          ���
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
Project Function DELA024C()
Local lRet 			:= .T.
Local nX			:= 0
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local cLote			:= ""
Local nPosSepu    	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_SEPU"   })
Local nPosValor		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_VBONFA" })
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"PA4"}) // GetArea

If ReadVar() = "M->PA4_VBONFA"
	// Forco valor do ReadVar para poder somar a aCols na
	// Funcao P_DELA024F()
	aCols[n,nPosValor] := &(ReadVar())
	// Soma total
	P_DELA024F()
Endif

If ReadVar() = "M->PA4_DESGAS"
	//����������������������������������������������Ŀ
	//�Nao permite % de Desgaste maior que 100%.     �
	//������������������������������������������������
	If &(ReadVar()) > 100
		Aviso("Aten��o !!!","Percentual de Desgaste n�o pode ser superior a 100% !!!",{" << Voltar"},2,"SEPU !")
		lRet := .F.
	Endif
endif

If lRet
	If ReadVar() = "M->PA4_SEPU"
		//����������������������������������������������Ŀ
		//�Verifica se SEPU ja foi incluida nesta Carta  �
		//������������������������������������������������
		For nX := 1 To naCols
			// Analisa apenas os Itens n�o deletados
			If !aCols[nX,naColsItem]
				If (n <> nX) .and. (aCols[nX,nPosSepu]==&(ReadVar()))
					Aviso("Aten��o !!!","SEPU j� cadastrado nesta Carta !!!",{" << Voltar"},2,"SEPU !")
					lRet := .F.
				Endif
			Endif
		Next nX
		
		//����������������������������������������������Ŀ
		//�Verifica se SEPU ja foi cadastrado.           �
		//������������������������������������������������
		If lRet
			DbSelectArea("PA4")
			PA4->(DbSetOrder(1)) // Filial + Sepu
			If !PA4->(DbSeek(xFilial("PA4")+&(ReadVar())))
				Aviso("Aten��o !!!","SEPU n�o cadastrado !!!",{" << Voltar"},2,"SEPU !")
				lRet := .F.
			Endif
		Endif
		
		//����������������������������������������������Ŀ
		//�Verifica se SEPU ja nao possui Lote cadastrado�
		//������������������������������������������������
		If lRet
			cLote := PA4->PA4_NUMLOT // Campo Localizado no Dbseek acima
			If !Empty(cLote)
				Aviso("Aten��o !!!","Este SEPU j� est� relacionado com o Lote: "+cLote+chr(13)+chr(10)+;
				"Caso haja a necessidade de gerar um cr�dito  "+chr(13)+chr(10)+;
				"complementar para este SEPU, voc� dever� incluir um"+chr(13)+chr(10)+;
				"t�tulo de Cr�dito (NCC) na rotina de Contas a Receber.",;
				{" << Voltar"},2,"SEPU !")
				
				lRet := .F.
			Endif
		Endif
	Endif
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA024D � Autor �Ricardo Mansano     � Data �  11/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � LinOK da GetDados.                                         ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - .T. se a validacao estiver Ok, caso contrario .F.    ���
�������������������������������������������������������������������������͹��
���Aplicacao �Valida a linha da GetDados apos a sua digitacao             ���
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
Project Function DELA024D()
Local lRet 			:= .T.
Local nPosSepu    	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_SEPU"   })

//����������������������������������������������Ŀ
//�Nao permite SEPU em branco na aCols.          �
//������������������������������������������������
If !aCols[n,Len(aCols[n])] // Ignora Deletado
	If Empty(aCols[n,nPosSepu])
		Aviso("Aten��o !!!","Preencha o campo SEPU !!!",{" << Voltar"},2,"SEPU !")
		lRet := .F.
	Endif
Endif

// Soma total
P_DELA024F()

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA024E � Autor �Ricardo Mansano     � Data �  11/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � TudoOK da GetDados.                                        ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - .T. se a validacao estiver Ok, caso contrario .F.    ���
�������������������������������������������������������������������������͹��
���Aplicacao �Valida a GetDados apos a sua digitacao                      ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���Marcelo   �30/11/05� ---  � Quando este fonte foi desenvolvido a Della ���
���Gaspar    �        �      � Via trabalhava com SE1 exclusivo e depois  ���
���          �        �      � ela mudou para compartilhado. Por isso foi ���
���          �        �      � necessario tratar o SE1 como compartilhado.���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA024E()
Local lRet 			:= .T.
Local nX			:= 0
Local nY			:= 0
Local cSepu			:= ""
Local _n			:= n
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local nPosSepu 		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_SEPU"   })
Local nPosDesg 		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_DESGAS" })
Local nPosValor		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_VBONFA" })
Local _cTipoTit		:= "" // "NCC" p/ Credito ou "AB-" p/ abatimento  ou "AB- e NCC" qdo gera dois titulos para um mesmo SEPU
Local _nAbatim 		:= GetMv("FS_DEL017") // Percentual de abatimento do valor da bonificacao para gerar o credito ou o abatimento da duplicata pendente
Local _nVlrTit 		:= 0
Local _lAtuSepu		:= .T.
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local _nVlDupli    	:= 0
Local cNumLote		:= "" // Numero do Lote em SX8
Local lExistNCC     := .F.
Local _lSE1Comp     := .T. // .T. = SE1 Compartilhado  , .F. = SE1 Exclusivo
Local _cFilSE1      := Space(02)

P_CtrlArea(1,@_aArea,@_aAlias,{"SE1","PA4"}) // GetArea


//������������������������������������������������Ŀ
//� Verifica se o SE1 eh exclusivo ou compartilhado�
//��������������������������������������������������
If !Empty(AllTrim(xFilial("SE1")))                                           
   _lSE1Comp := .F. // Exclusivo
EndIf


//����������������������������������������������Ŀ
//� Verifica se a Data de Aplicacao foi digitada �
//������������������������������������������������
If Empty(cDataAp)
	Aviso("Aten��o !!!","Preencha a Data de Aplica��o !!!",{" << Voltar"},2,"SEPU !")
	lRet := .F.
Endif

//�������������������������������������������������Ŀ
//�Verifica se Valor Total bate com a soma da aCols �
//���������������������������������������������������
If lRet
	If nVlrTot <> _nTot
		Aviso("Aten��o !!!","Soma dos lan�amentos n�o"+chr(13)+;
		"coincide com o Valor Total !!!",{" << Voltar"},2,"SEPU !")
		lRet := .F.
	Endif
Endif

//��������������������������������������������������������Ŀ
//�Verifica se SEPU nao foi incluida duas vezes nesta Carta�
//����������������������������������������������������������
If lRet
	For nX := 1 To naCols
		// Analisa apenas os Itens n�o deletados
		If !aCols[nX,naColsItem]
			n := nX
			cSepu := aCols[n,nPosSepu]
			For nY := 1 To naCols
				// Analisa apenas os Itens n�o deletados
				If !aCols[nY,naColsItem]
					If (n <> nY) .and. (aCols[nY,nPosSepu]==cSepu)
						lRet := .F.
					Endif
				Endif
			Next nY
		Endif
	Next nX
	
	// Restaura N
	n := _n
	
	// Mostra Erro
	If !lRet
		Aviso("Aten��o !!!","O mesmo Nr. de SEPU n�o pode constar duas vezes na mesma Carta !!!",{" << Voltar"},2,"SEPU !")
	Endif
Endif

//����������������������������������������������Ŀ
//� Salva os dados na SEPU.                      �
//������������������������������������������������
If lRet
	DbSelectArea("PA4")
	PA4->(DbSetOrder(1)) // Filial + Sepu
	For nX := 1 To naCols
		// Salva apenas os Itens n�o deletados
		If !aCols[nX,naColsItem]
			
			_nVlrTit	:= aCols[nX,nPosValor]-(aCols[nX,nPosValor]*_nAbatim /100)
			
			//����������������������������������������������������������������������Ŀ
			//� Sepus ja foram validadas na digitacao, consequentemente elas existem �
			//������������������������������������������������������������������������
			PA4->(DbSeek(xFilial("PA4")+aCols[nX,nPosSepu]))
			
			//���������������������������������������������������Ŀ
			//� Verifica se ha bonificacao por parte da della Via �
			//�����������������������������������������������������
			dbSelectArea("SE1")
			dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If _lSE1Comp
    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
    	  	Else
    	  	   _cFilSE1 := PA4->PA4_FILDV  // SE1 Exclusivo
    	  	EndIf   
			If !dbSeek(_cFilSE1 + "SEP" + PA4->PA4_SEPU)
				
				//����������������������������������������������������������������������������������Ŀ
				//� Verifica se Pirelli concedeu bonificacao e a loja NAO fez adiantamento de pneu.  �
				//������������������������������������������������������������������������������������
				If aCols[nX,nPosValor] <> 0 .And. Empty(PA4->PA4_CFANT)
					
					If !lExistNCC
						_cTipoTit	:= "NCC"


						If _lSE1Comp
			    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
			    	  	Else
			    	  	   _cFilSE1 := PA4->PA4_MSFIL  // SE1 Exclusivo
			    	  	EndIf   
			
						//����������������������������������������������������������������������Ŀ
						//� Gera titulo de credito (NCC) para o cliente                          �
						//������������������������������������������������������������������������
						If !P_NCCSEPU(3,_cFilSE1,PA4->PA4_SEPU,"SEP",_cTipoTit,_nVlrTit)
							_lAtuSepu := .F.
							MsgStop(OemtoAnsi("1-A nota de cr�dito do SEPU : "+PA4->PA4_SEPU+" n�o foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten��o"))
						EndIf
					EndIf
					
				//����������������������������������������������������������������������������������Ŀ
				//� Verifica se Pirelli concedeu bonificacao e a loja JA fez adiantamento de pneu.   �
				//������������������������������������������������������������������������������������
				ElseIf aCols[nX,nPosValor] <> 0 .And.  !Empty(PA4->PA4_CFANT)
					
					_cTipoTit := "AB-"
					
					If _lSE1Comp
		    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
		    	  	Else
		    	  	   _cFilSE1 := PA4->PA4_FILANT  // SE1 Exclusivo
		    	  	EndIf   

					//��������������������������������������������������������������������������������������Ŀ
					//� Verifica se Valor do Abatimento eh maior que o valor do Titulo da duplicata pendente �
					//����������������������������������������������������������������������������������������
					DbSelectArea("SE1")
					SE1->(DbSetOrder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					If SE1->(DbSeek(_cFilSE1+PA4->PA4_SERANT+PA4->PA4_CFANT))
						
						_cTipoTit := "AB-"
						_nVlDupli := SE1->E1_VALOR // Valor da duplicata pendente
						
						If _nVlrTit > SE1->E1_VALOR
							If _lSE1Comp
				    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
				    	  	Else
				    	  	   _cFilSE1 := PA4->PA4_FILANT  // SE1 Exclusivo
				    	  	EndIf   
							//�������������������������������������������������������������������������������������������Ŀ
							//� Gera titulo de abatimento (AB-) para o cliente com valor do titulo da duplicata pendente  �
							//���������������������������������������������������������������������������������������������
							If !P_NCCSEPU(3,_cFilSE1,PA4->PA4_CFANT,PA4->PA4_SERANT,_cTipoTit,_nVlDupli)
								_lAtuSepu := .F.
								MsgStop(OemtoAnsi("2-A nota de cr�dito do SEPU : "+PA4->PA4_SEPU+" n�o foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten��o"))
							EndIf
							
							_cTipoTit := "NCC"

							If _lSE1Comp
				    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
				    	  	Else
				    	  	   _cFilSE1 := PA4->PA4_MSFIL  // SE1 Exclusivo
				    	  	EndIf   

							//����������������������������������������������������������������������Ŀ
							//� Gera titulo de credito (NCC) para o cliente com a                    �
							//� diferenca (Valor da Bonfiicacao - Valor da duplicata pendente)       �
							//������������������������������������������������������������������������
							If (_lAtuSepu) .and. (!P_NCCSEPU(3,_cFilSE1,PA4->PA4_SEPU,"SEP",_cTipoTit,( _nVlrTit-_nVlDupli ) ))
								_lAtuSepu := .F.
								MsgStop(OemtoAnsi("3-A nota de cr�dito do SEPU : "+PA4->PA4_SEPU+" n�o foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten��o"))
							Else
								_cTipoTit := "AB- e NCC"// Gerou os dois titulos AB- e NCC
							EndIf
						Else
							If _lSE1Comp
				    	  	   _cFilSE1 := xFilial("SE1") // SE1 Compartilhado
				    	  	Else
				    	  	   _cFilSE1 := PA4->PA4_FILANT  // SE1 Exclusivo
				    	  	EndIf   

							//����������������������������������������������������������������������Ŀ
							//� Gera titulo de abatimento (AB-) para o cliente                       �
							//������������������������������������������������������������������������
							If !P_NCCSEPU(3,_cFilSE1,PA4->PA4_CFANT,PA4->PA4_SERANT,_cTipoTit,_nVlrTit )
								_lAtuSepu := .F.
								MsgStop(OemtoAnsi("4-A nota de cr�dito do SEPU : "+PA4->PA4_SEPU+" n�o foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten��o"))
							EndIf
						Endif
					Endif
				EndIf
			EndIf
			//����������������������������������������������������������������������Ŀ
			//� Caso tenha passa do por todas as Validacoes, salva os dados do SEPU. �
			//������������������������������������������������������������������������
			If _lAtuSepu
				DbSelectArea("PA4")
				PA4->(DbSetOrder(1)) // Filial + Sepu
				PA4->(DbSeek(xFilial("PA4")+aCols[nX,nPosSepu]))
				//����������������������������������������������Ŀ
				//� Confirma SX8 para numero do Lote.            �
				//������������������������������������������������
				If Empty(cNumLote)
					cNumLote := GetSxeNum("PA4","PA4_NUMLOT")
					ConfirmSx8()
				Endif
				
				RecLock("PA4",.F.)
				PA4->PA4_NUMLOT := cNumLote
				PA4->PA4_DTDIGI := dDataBase
				PA4->PA4_DTAPLI := cDataAp
				PA4->PA4_DESGAS := aCols[nX,nPosDesg]
				PA4->PA4_VBONFA := aCols[nX,nPosValor]
				PA4->PA4_ACTFA  := Iif(PA4->PA4_VBONFA<>0,"S","N")
				PA4->PA4_TPFIN  := _cTipoTit  // "NCC" p/ Credito ou "AB-" p/ abatimento  ou "AB- e NCC" qdo gera dois titulos para um mesmo SEPU
				MsUnLock()
				
			EndIf
			
		Endif
	Next nX
Endif

//����������������������������������������������������������������Ŀ
//� Mostra Lote Salvo se pelo menos um deles passou pela Validacao �
//������������������������������������������������������������������
If !Empty(cNumLote)
	Aviso("Aten��o !!!","Numero do Lote Gerado: "+cNumLote+" !!!",{" << Voltar"},2,"Numero do Lote !")
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA024F � Autor �Ricardo Mansano     � Data �  11/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Soma Colunas do Valor para mostra-la no Rodape.            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������͹��
���Observacao� Foi Utilizado na GetDados como cDelOk                      ���
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
Project Function DELA024F()
Local nX 			:= 0
Local naCols    	:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local nPosValor		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "PA4_VBONFA" })

// Soma Total para mostra-lo no Rodape
_nTot := 0
For nX := 1 To naCols
	If !aCols[nX,naColsItem]
		_nTot += aCols[nX,nPosValor]
	Endif
Next nX

// Refresh Rodape
oRod:Refresh()

Return(.T.)
